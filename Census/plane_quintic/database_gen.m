InputFileName := "plane_quintic.txt";
OutputFileName := "data_" cat InputFileName;
LinesOfInputFile := Split(Read(InputFileName), "\n");

L := #LinesOfInputFile;

print "Starting...";

R<x0,x1,x2>:= PolynomialRing(GF(2),3);
X := ProjectiveSpace(R);
function FFConstruction(fsupp)
    return AlgorithmicFunctionField(FunctionField(Curve(Scheme(X,fsupp))));
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

for i in [1..L] do
    tup := eval(LinesOfInputFile[i]);
    supp := tup[1];
    F := FFConstruction(supp);
    cpc := ([NumberOfPlacesOfDegreeOneECF(F,n) : n in [1..6]]);

    try
        G := IdentifyGroup(AutomorphismGroup(F));
        fprintf OutputFileName, "[" cat "%o" cat "," cat "'" cat "%o" cat "'" cat "," cat "%o" cat "]" cat "\n", cpc, G, supp;
    catch e
        G := count_automs(F);
        fprintf OutputFileName, "[" cat "%o" cat "," cat "'" cat "%o" cat "'" cat "," cat "%o" cat "]" cat "\n", cpc, G, supp;
    end try;
end for;

print "Done!";
quit;
