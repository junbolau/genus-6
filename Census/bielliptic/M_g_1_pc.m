InputFileName := "elliptic.txt"; 
LinesOfInputFile := Split(Read(InputFileName), "\n");
//OutputFileName:= "F2_pc_" cat InputFileName;

L := #LinesOfInputFile;

//bielliptic and hyperelliptic
AA<x,y>:= AffineSpace(Rationals(),2);

//plane quintic
//R<x0,x1,x2>:= PolynomialRing(GF(2),3);
//X := ProjectiveSpace(R);

function ff_pc(fsupp)
    A<x,y>:= AffineSpace(GF(2),2);
    return NumberOfPlacesOfDegreeOneECF(AlgorithmicFunctionField(FunctionField(Curve(A,fsupp))),1); // bielliptic and hyperelliptic
//    return NumberOfPlacesOfDegreeOneECF(AlgorithmicFunctionField(FunctionField(Curve(Scheme(X,fsupp)))),1);
end function;

weighted_ct := 0;

for i in [1..L] do
    
    lst := eval(LinesOfInputFile[i]);
    autsize := lst[2];
    supp := lst[1];
    ct := ff_pc(supp);
//    fprintf OutputFileName, "[" cat "%o" cat "," cat "%o" cat "," cat "%o" cat "]" cat "\n", supp,autsize,ct;
    weighted_ct +:= ct/autsize;
end for;

print weighted_ct;
