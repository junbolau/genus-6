InputFileName := "hyperelliptic.txt"; 
LinesOfInputFile := Split(Read(InputFileName), "\n");
OutputFileName:= "unequal_aut_gps.txt";

L := #LinesOfInputFile;

AA<x,y>:= AffineSpace(Rationals(),2);

function FFConstruction(fsupp)
    return AlgorithmicFunctionField(FunctionField(Curve(AA,fsupp)));
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
    lst := eval(LinesOfInputFile[i]);
    supp := lst[1];
    try
        autC := #AutomorphismGroup(Curve(AA,supp));
        autF := #AutomorphismGroup(FFConstruction(supp));
        autK := count_automs(FFConstruction(supp));
        if (autC ne autF) or (autC ne autK) or (autF ne autK) then
            fprintf OutputFileName, lst cat "\n";
        end if;
    catch e
        fprintf OutputFileName, i cat "\n";
    end try;
end for;

print("Done");
quit;
