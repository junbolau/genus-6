/* isom_class_check.m (for generic genus 6 curves over F_2)
Use this command to run this script in parallel:
    ls ./data_unfiltered_updated/ | parallel -j50 "magma -b Input:={} isom_class_check.m&"
*/

OutputFileName := "./sorted_data/flat22/isom_class" cat Input;
InputFileName := "./data_unfiltered_updated/flat22/" cat Input;

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
i := 2;
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
            fprintf "./sorted_data/flat22/problematic_automorphisms.txt", "%o" cat "\n", eqn;
            aut_ord := CountAutoms(FFConstruction(eqn));
            fprintf OutputFileName, "%o" cat "," cat "%o" cat "\n", eqn, aut_ord;
            //fprintf OutputFileName, "%o" cat "," cat "%o" cat ",'error'" cat "\n", eqn, 1;
        end try;
    end for;
    i := j + 1;
end while;


quit;