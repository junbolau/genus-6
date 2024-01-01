/*curve_check.m

  Use this script to generate curves data with correct genus:

    ls ./data/ | parallel -j25 "magma -b InputFileName:={} curve_check.m &"

  (current) If parallel does not work, run this script within /data/ directory :
  
  find ./ -type f | grep txt | perl -ne 'chomp;s/\.\///;print "magma -b InputFileName:=$_ ../curve_check.m &\n"' > RUN
  emacs -nw RUN
  chmod u+x RUN
  ./RUN
  
  Comments on the current method:
  - find ./ -type f | grep txt | grep^ $FILE_NAME_BEGINNING | perl -ne 'chomp;s/\.\///;print "magma -b InputFileName:=$_ ../curve_check.m &\n"' > RUN_genus
  - writes a bash script file to run magma file in parallel. need to select files with certain beginnings, #!/bin/sh on top on RUN
  - use several data folders to manage batches (BU server limit)
  - approx 30-35 .txt files in each data folder
  
  This will take the data files in `./data/`, and for each curve in each file,
  will generate a new file (appended with `with_genus`) in the same directory.

*/


/*

 parallel:
 
 RealInputFileName := "./data/" cat InputFileName;
 OutputFileName := "-/data/with_genus_" cat InputFileName;

*/

OutputFileName := "genus_" cat InputFileName;
LinesOfInputFile := Split(Read(InputFileName), "\n");

R<x0,x1,x2> := PolynomialRing(GF(2),3);
X := ProjectiveSpace(R);

GenusCheck := function(_fsupp)
    pol := eval(_fsupp);
    Y := Scheme(X,pol);
    if Dimension(Y) eq 1 and IsIrreducible(Y) eq true and IsReduced(Y) eq true then
        C := Curve(Y);
        F := AlgorithmicFunctionField(FunctionField(C));
        if Genus(F) eq 6 then
            ct := [IntegerToString(NumberOfPlacesOfDegreeOneECF(F,n)) : n in [1..6]];
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
        fprintf OutputFileName, "[" cat "%o" cat ",[" cat "%o" cat "]]" cat "\n", ct, MyLine;
    end if;
end for;

quit;
    
