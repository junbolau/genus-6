/* curve_check.m (for generic genus 6 curves over F_2)
ls ./flats/unfiltered/flat32/ | parallel -j50 "magma -b Input:={} curve_check.m"
*/

OutputFileName := "./data_unfiltered/flat32/with_genus_" cat Input;
InputFileName := "./flats/unfiltered/flat32/" cat Input;

LinesOfInputFile := Split(Read(InputFileName), "\n");

R<x01,x02,x03,x04,x12,x13,x14,x23,x24,x34> := PolynomialRing(GF(2), 10);
X := ProjectiveSpace(R);
R_gens := [x01,x02,x03,x04,x12,x13,x14,x23,x24,x34];
quads := [x01*x23 + x02*x13 + x03*x12,
         x01*x24 + x02*x14 + x04*x12,
         x01*x34 + x03*x14 + x04*x13,
         x02*x34 + x03*x24 + x04*x23,
         x12*x34 + x13*x24 + x14*x23];

R_monos2 :=[x01^2, x01*x02, x01*x03, x01*x04, x01*x12, x01*x13, x01*x14, x01*x23, 
x01*x24, x01*x34, x02^2, x02*x03, x02*x04, x02*x12, x02*x13, 
x02*x14, x02*x23, x02*x24, x02*x34, x03^2, x03*x04, x03*x12, 
x03*x13, x03*x14, x03*x23, x03*x24, x03*x34, x04^2, x04*x12, 
x04*x13, x04*x14, x04*x23, x04*x24, x04*x34, x12^2, x12*x13, 
x12*x14, x12*x23, x12*x24, x12*x34, x13^2, x13*x14, x13*x23, 
x13*x24, x13*x34, x14^2, x14*x23, x14*x24, x14*x34, x23^2, 
x23*x24, x23*x34, x24^2, x24*x34, x34^2];

linear_forms := [];
for lst in eval(LinesOfInputFile[1]) do
    form := R!0;
    for ele in lst do
        form +:= R_gens[ele+1];
    end for;
    linear_forms := Append(linear_forms, form);
end for;

GenusCheck := function(_fsupp)
    fsupp := eval(_fsupp);
    pol := R!0;
    for i in fsupp do
        pol +:= R_monos2[i+1];
    end for;
    generators := Append(linear_forms, pol) cat quads;
    Y := Scheme(X, generators);
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

n := 0;
for MyLine in LinesOfInputFile do
    if n gt 0 then 
        boo, ct := GenusCheck(MyLine);
        if boo eq true then 
            to_print := "[" cat ct cat "," cat MyLine cat "]" cat "\n";
            fprintf OutputFileName, to_print;
        end if;
    else
        to_print := MyLine cat "\n";
        fprintf OutputFileName, to_print;
    end if;
    n +:= 1;
end for;

quit;
