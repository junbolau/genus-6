OutputFileName := "./data_trigonal_maroni_2.txt";
Input := "./sorted_data/" cat Input;
LinesOfInputFile := Split(Read(Input), "\n");

R<x0,x1,y0,y1,y2> := PolynomialRing(GF(2),5);
I1 := ideal<R|[x0,x1]>;
I2 := ideal<R|[y0,y1,y2]>;
CR := CoxRing(R, [I1, I2], [[1,1,0,0,0],[0,0,1,1,1]], []);
X := ToricVariety(CR);
monos13 := [x0*y0^3, 
x0*y0^2*y1, 
x0*y0^2*y2, 
x0*y0*y1^2, 
x0*y0*y1*y2, 
x0*y0*y2^2, 
x0*y1^3, 
x0*y1^2*y2, 
x0*y1*y2^2, 
x0*y2^3, 
x1*y0^3, 
x1*y0^2*y1, 
x1*y0^2*y2, 
x1*y0*y1^2, 
x1*y0*y1*y2, 
x1*y0*y2^2, 
x1*y1^3, 
x1*y1^2*y2, 
x1*y1*y2^2, 
x1*y2^3];

function FFConstruction(fsupp)
    pol := R!0;
    for k in fsupp do
        pol +:= monos13[k+1];
        end for;
    R1<x> := RationalFunctionField(GF(2), 1);
    R2<y> := RationalFunctionField(R1, 1);
    f := Evaluate(pol, [1, x, 1, y, (x^2+1)/x * y]) * x^3;
    Y_ := Scheme(X,[pol, (x0^2+x1^2)*y1 + x0*x1*y2]);
    C_ := Curve(Y_);
    F_ := FunctionField(C_);
    return f, AlgorithmicFunctionField(F_);
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
    f, F := FFConstruction(fsupp);
    R1<x> := RationalFunctionField(GF(2), 1);
    R2<y> := RationalFunctionField(R1, 1);
    poly := R2!f;
    cpc := ([NumberOfPlacesOfDegreeOneECF(F,n) : n in [1..6]]);
    G := IdentifyGroup(AutomorphismGroupCorrected(F));
    fprintf OutputFileName, "[" cat "%o" cat "," cat "'" cat "%o" cat "'" cat "," cat "%o" cat "]" cat "\n", cpc, G, poly;
end for;

quit;