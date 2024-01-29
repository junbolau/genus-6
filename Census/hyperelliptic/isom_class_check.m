OutputFileName := "isom_" cat InputFileName;
LinesOfInputFile := Split(Read(InputFileName), "\n");

L := #LinesOfInputFile;
A<x,y>:= AffineSpace(GF(2),2);

// Quick construction of function field with IsIsomorphic functionality
function FFConstruction(fsupp)
    return AlgorithmicFunctionField(FunctionField(Curve(A,fsupp)));
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
