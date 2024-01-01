OutputFileName := "new_isom_" cat InputFileName;
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

// Main loop: check for pairwise isomorphism by varying over elements of the same point counts
i := 1;
while i le L do
    lst := eval(LinesOfInputFile[i]);
    ct := lst[1];
    supp := lst[2];
    F0 := FFConstruction(supp);

    autsize := #AutomorphismGroup(Curve(A,supp));
    fprintf OutputFileName, "[" cat "%o" cat "," cat "%o" cat "]" cat "\n", supp,autsize;

    tmp := [F0];
    j := FindIndex(LinesOfInputFile,ct,i);
    
    for ind in [i..j] do
        lst2 := eval(LinesOfInputFile[ind]);
        supp2 := lst2[2];
        F02 := FFConstruction(supp2);
        if forall(u){m : m in tmp | IsIsomorphic(F02,m) eq false } eq true then
            Append(~tmp,F02);
            autsize := #AutomorphismGroup(Curve(A,supp2));
            fprintf OutputFileName, "[" cat "%o" cat "," cat "%o" cat "]" cat "\n", supp2,autsize;
        end if;
    end for;
    i := j + 1;
end while;

quit;
