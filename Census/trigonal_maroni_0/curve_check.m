/*curve_check.m (for genus 6 curves that are trigonal of maroni invariant 0)

  Use this script to generate curves data with correct genus:

    ls ./data_unfiltered/ | parallel -j28 "magma -b InputFileName:={} curve_check.m &"
*/

OutputFileName := "./data_unfiltered/with_genus_" cat InputFileName;
InputFileName := "./data_unfiltered/" cat InputFileName;

LinesOfInputFile := Split(Read(InputFileName), "\n");

R<x0,x1,y0,y1> := PolynomialRing(GF(2),4);
I1 := ideal<R|[x0,x1]>;
I2 := ideal<R|[y0,y1]>;
CR := CoxRing(R, [I1, I2], [[1,1,0,0],[0,0,1,1]], []);
X := ToricVariety(CR);
monos34 := [x0^3*y0^4,
 x0^3*y0^3*y1,
 x0^3*y0^2*y1^2,
 x0^3*y0*y1^3,
 x0^3*y1^4,
 x0^2*x1*y0^4,
 x0^2*x1*y0^3*y1,
 x0^2*x1*y0^2*y1^2,
 x0^2*x1*y0*y1^3,
 x0^2*x1*y1^4,
 x0*x1^2*y0^4,
 x0*x1^2*y0^3*y1,
 x0*x1^2*y0^2*y1^2,
 x0*x1^2*y0*y1^3,
 x0*x1^2*y1^4,
 x1^3*y0^4,
 x1^3*y0^3*y1,
 x1^3*y0^2*y1^2,
 x1^3*y0*y1^3,
 x1^3*y1^4];

GenusCheck := function(_fsupp)
    fsupp := eval(_fsupp);
    pol := R!0;
    for i in fsupp do
        pol +:= monos34[i+1];
    end for;
    
    Y := Scheme(X,pol);

    if Dimension(Y) eq 1 and IsIrreducible(Y) eq true and IsReduced(Y) eq true then
        C := Curve(Y);
        F0 := FunctionField(C);
        F := AlgorithmicFunctionField(F0);

        if Genus(F) eq 6 then
            ct := "[";
            for n in [1..6] do
                ct :=  ct cat IntegerToString(NumberOfPlacesOfDegreeOneECF(F,n)) cat ",";
            end for;
            Prune(~ct);
            ct := ct cat "]"; 
            return true, ct;
        else
            return false, "";
        end if; 
    else
        return false, "";
    end if;
end function;
    

for MyLine in LinesOfInputFile do
    boo,ct := GenusCheck(MyLine);
    if boo eq true then
        to_print := "[" cat ct cat "," cat MyLine cat "]" cat "\n";
        fprintf OutputFileName, to_print;
    end if;
end for;

quit;