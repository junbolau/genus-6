OutputFileName := "pc_" cat InputFileName;
LinesOfInputFile := Split(Read(InputFileName), "\n");

function LineCount(F)
    FP := Open(F, "r");
    count := 0;
    while true do
        line := Gets(FP);
        if IsEof(line) then
            break;
        end if;
        count +:= 1;
    end while;
    return count;
end function;

L := LineCount(InputFileName);

A<x,y>:= AffineSpace(GF(2),2);

i := 1;

while i le L do
    lst := eval(LinesOfInputFile[i]);
    C_ := Curve(A,lst);
    F_ := AlgorithmicFunctionField(FunctionField(C_));
    ct := [NumberOfPlacesOfDegreeOneECF(F_,n) : n in [1..6]];
    fprintf OutputFileName, "[" cat "%o" cat "," cat "%o" cat "," cat "%o" cat "]" cat "\n", ct,lst, #AutomorphismGroup(C_);
    i +:= 1;
end while;

quit;
