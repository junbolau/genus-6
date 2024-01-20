
OutputFileName := "./data_generic.txt";
Input := "./sorted_data/flat0/" cat Input;

if Input eq "./sorted_data/flat0/problematic_automorphisms.txt" then 
    quit;
end if;

LinesOfInputFile := Split(Read(Input), "\n");

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

//flat 0
flat := [[2], [3, 5], [4], [6, 7]];
linear_forms := [];
for lst in flat do
    form := R!0;
    for ele in lst do
        form +:= R_gens[ele+1];
    end for;
    linear_forms := Append(linear_forms, form);
end for;

// Quick construction of function field with IsIsomorphic functionality
function FFConstruction(fsupp)
    pol := R!0;
    for i in fsupp do
        pol +:= R_monos2[i+1];
    end for;
    generators := Append(linear_forms, pol) cat quads;
    Y := Scheme(X, generators);
    C := Curve(Y);
    F := FunctionField(C);
    return AlgorithmicFunctionField(F);
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

for MyLine in LinesOfInputFile do
    fsupp := eval(MyLine);
    F := FFConstruction(fsupp);
    B := Parent(DefiningPolynomial(F));
    A := BaseRing(B);
    AssignNames(~A, ["x"]);
    AssignNames(~B, ["y"]);
    poly := DefiningPolynomial(F);
    cpc := ([NumberOfPlacesOfDegreeOneECF(F,n) : n in [1..6]]);
    G := IdentifyGroup(AutomorphismGroupCorrected(F));
    fprintf OutputFileName, "[" cat "%o" cat "," cat "'" cat "%o" cat "'" cat "," cat "%o" cat "]" cat "\n", cpc, G, poly;
end for;

quit;
