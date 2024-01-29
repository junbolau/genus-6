/*isom_class_check.m

  Use this script to generate isomorphism class of curves data:

    ls ./data/sorted_data/ | parallel -j25 "magma -b InputFileName:={} isom_class_check.m &"
    
  (current) If parallel does not work, run this script within /data/ directory :
  
  find ./ -type f | grep txt | perl -ne 'chomp;s/\.\///;print "magma -b InputFileName:=$_ ../isom_class_check.m &\n"' > RUN
  emacs -nw RUN
  chmod u+x RUN
  ./RUN
  
  Comments on the current method:
  - find ./ -type f | grep txt | grep genus  | perl -ne 'chomp;s/\.\///;print "magma -b InputFileName:=$_ ../isom_class_check.m &\n"' > RUN_isom
  - writes a bash script file to run magma file in parallel. need to select files with certain beginnings, #!/bin/sh on top on RUN
  - use several data folders to manage batches (BU server limit)
  - approx 30-35 .txt files in each data folder

  This will take the data files in `./data/sorted_data/`, and for each curve in each file,
  will generate a new file (appended with `isomclass_`) in the same directory.

*/

/*

 parallel:
 
 RealInputFileName := "./data/" cat InputFileName;
 OutputFileName := "-/data/with_genus_" cat InputFileName;

*/


OutputFileName := "isom_" cat InputFileName;
LinesOfInputFile := Split(Read(InputFileName), "\n");


L := #LinesOfInputFile;

R<x0,x1,x2>:= PolynomialRing(GF(2),3);
X := ProjectiveSpace(R);

// Quick construction of function field with IsIsomorphic functionality
function FFConstruction(fsupp)
    return AlgorithmicFunctionField(FunctionField(Curve(Scheme(X,fsupp))));
end function;

// Each line is a support ordered by point count, so we need to get starting and ending indices
function FindIndex(TxtFile, InitialPointCounts,StartingIndex)
    if StartingIndex eq L then
        return StartingIndex;
    end if;
    for k in [StartingIndex..L] do
        tmp := eval(TxtFile[k]);
        if tmp[1] eq InitialPointCounts and k le L-1 then
            continue;
        elif tmp[1] eq InitialPointCounts and k eq L then
            return k;
        else
            return k-1;
        end if;
    end for;
end function;

function AutomorphismGroupCorrected(F)
    try
        return AutomorphismGroup(F);
    catch e
        /* When this error occurs, Automoprhisms(F) is still assumed to return a list
           of automorphisms which generates the full groups, but may be incomplete and/or
           include repetitions. */
        L := Automorphisms(F);
        G := FreeGroup(#L);
        rels := [];
        for i in [1..#L] do
            for j in [1..#L] do
                g := Composition(L[i], L[j]);
                for k in [1..#L] do
                    if Equality(g, L[k]) then
                        Append(~rels, G.i*G.j*G.k^(-1));
                    end if;
                end for;
            end for;
        end for;
        return quo<G|rels>;
    end try;
end function;


// Main loop: check for pairwise isomorphism by varying over elements of the same point counts
i := 1;
while i le L do
    lst := eval(LinesOfInputFile[i]);
    supp := lst[2];
    F0 := FFConstruction(supp);
    ct := [NumberOfPlacesOfDegreeOneECF(F0,n) : n in [1..6]];
    G := IdentifyGroup(AutomorphismGroupCorrected(F0));

    fprintf OutputFileName, "[" cat "%o" cat "," cat "'" cat "%o" cat "'" cat "," cat "%o" cat "]" cat "\n", ct, G, supp[1];
    
    tmp := [F0];
    j := FindIndex(LinesOfInputFile,ct,i);
    for ind in [i..j] do
        lst2 := eval(LinesOfInputFile[ind]);
        supp2 := lst2[2];
        F02 := FFConstruction(supp2);
        if forall(u){m : m in tmp | #Isomorphisms(F02,m) eq 0 } eq true then
            Append(~tmp,F02);
            ct2 := [NumberOfPlacesOfDegreeOneECF(F0,n) : n in [1..6]];
            G2 := IdentifyGroup(AutomorphismGroupCorrected(F02));
            fprintf OutputFileName, "[" cat "%o" cat "," cat "'" cat "%o" cat "'" cat "," cat "%o" cat "]" cat "\n", ct2, G2, supp2[1];
        end if;
    end for;
    i := j + 1;
end while;

quit;
