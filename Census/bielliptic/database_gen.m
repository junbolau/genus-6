InputFileName := "bielliptic.txt";
OutputFileName := "data_" cat InputFileName;
LinesOfInputFile := Split(Read(InputFileName), "\n");

L := #LinesOfInputFile;

print "Starting...";

A<x,y>:= AffineSpace(GF(2),2);
function FFConstruction(fsupp)
    return AlgorithmicFunctionField(FunctionField(Curve(A,fsupp)));
end function;

function count_automs(F)
    try
        return #AutomorphismGroup(F);
    catch e
        /* An error can occur when Automorphisms(F) returns a list with repetitions. */
        L := Automorphisms(F);
        L1 := [* *];
        for i in L do
            match := false;
            for j in L1 do
                if Equality(i, j) then
                    match := true;
                    break;
                end if;
            end for;
            if not match then
                Append(~L1, i);
            end if;
        end for;
        return #L1;
    end try;
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

for i in [1..L] do
    tup := eval(LinesOfInputFile[i]);
    supp := tup[1];

    F := FFConstruction(supp);
    cpc := ([NumberOfPlacesOfDegreeOneECF(F,n) : n in [1..6]]);

    G := IdentifyGroup(AutomorphismGroupCorrected(F));
    fprintf OutputFileName, "[" cat "%o" cat "," cat "'" cat "%o" cat "'" cat "," cat "%o" cat "]" cat "\n", cpc, G, supp;
end for;

print "Done!";
quit;
