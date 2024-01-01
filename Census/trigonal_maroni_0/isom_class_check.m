/*isom_class_check.m (for genus 6 curves that are trigonal of maroni invariant 0)

  Use this script to generate isomorphism class of curves data:

    ls ./data_filtered_updated/ | parallel -j28 "magma -b InputFileName:={} isom_class_check.m &"
    
*/


OutputFileName := "./sorted_data/isomclass_" cat InputFileName;
InputFileName := "./data_filtered_updated/" cat InputFileName;
LinesOfInputFile := Split(Read(InputFileName), "\n");

// Count number of lines in text file
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

// Quick construction of function field with IsIsomorphic functionality
function FFConstruction(fsupp)
    pol := R!0;
    for k in fsupp do
        pol +:= monos34[k+1];
        end for;
    Y_ := Scheme(X,pol);
    C_ := Curve(Y_);
    F_ := FunctionField(C_);
    return AlgorithmicFunctionField(F_);
end function;

// Each line is a support ordered by point count, so we need to get starting and ending indices
function CountIndices(TxtFile, InitialPointCounts,StartingIndex)
    L := #TxtFile;
    for k in [StartingIndex..L] do
        tmp := eval(TxtFile[k]);
        if tmp[1] eq InitialPointCounts then
            continue;
        else
            return k-1;
        end if;
    end for;
    return L;
end function;

function CountAutoms(F)
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

// Main loop: check for pairwise isomorphism by varying over elements of the same point counts
lst := eval(LinesOfInputFile[1]);
final := [lst[2]];
i := 1;
while i le L do
    lst := eval(LinesOfInputFile[i]);
    ct := lst[1];
    supp := lst[2];
    F0 := FFConstruction(supp);

    tmp := [F0];
    supptmp := [supp];
    j := CountIndices(LinesOfInputFile,ct,i);
    for ind in [i..j] do
        lst2 := eval(LinesOfInputFile[ind]);
        supp2 := lst2[2];
        F02 := FFConstruction(supp2);
        if forall(u){m : m in tmp | #Isomorphisms(F02,m) eq 0} eq true then
            Append(~tmp,F02);
            Append(~supptmp,supp2);
        end if;
    end for;
    for eqn in supptmp do
        try 
            aut_ord := #AutomorphismGroup(FFConstruction(eqn));
            fprintf OutputFileName, "%o" cat "," cat "%o" cat "\n", eqn, aut_ord;
        catch e
            fprintf "problematic_automorphisms.txt", "%o" cat "\n", eqn;
            aut_ord := CountAutoms(FFConstruction(eqn));
            fprintf OutputFileName, "%o" cat "," cat "%o" cat "\n", eqn, aut_ord;
            //fprintf OutputFileName, "%o" cat ",'error'" cat "\n", eqn;
        end try;
    end for;
    i := j + 1;
end while;

quit;