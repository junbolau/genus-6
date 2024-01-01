/*isom_class_check.m

  Use this script to generate isomorphism class of curves data:

    ls ./data/sorted_data/ | parallel -j25 "magma -b InputFileName:={} isom_class_check.m &"
    
  (current) If parallel does not work, run this script within /data/ directory :
  
  find ./ -type f | grep txt | perl -ne 'chomp;s/\.\///;print "magma -b InputFileName:=$_ ../isom_class_check.m &\n"' > RUN
  emacs -nw RUN
  chmod u+x RUN
  ./RUN
  
  Comments on the current method:
  - find ./ -type f | grep txt | grep genus  | perl -ne 'chomp;s/\.\///;print "magma -b InputFileName:=$_ ../isom_class_check.m &\n"' > RUN_isom
  - writes a bash script file to run magma file in parallel. need to select files with certain beginnings, #!/bin/sh on top on RUN
  - use several data folders to manage batches (BU server limit)
  - approx 30-35 .txt files in each data folder

  This will take the data files in `./data/sorted_data/`, and for each curve in each file,
  will generate a new file (appended with `isomclass_`) in the same directory.

*/

/*

 parallel:
 
 RealInputFileName := "./data/" cat InputFileName;
 OutputFileName := "-/data/with_genus_" cat InputFileName;

*/


OutputFileName := "final_" cat InputFileName;
LinesOfInputFile := Split(Read(InputFileName), "\n");


L := #LinesOfInputFile;

R<x0,x1,x2>:= PolynomialRing(GF(2),3);
X := ProjectiveSpace(R);

// Quick construction of function field with IsIsomorphic functionality
function FFConstruction(fsupp)
    return AlgorithmicFunctionField(FunctionField(Curve(Scheme(X,fsupp))));
end function;

// Main loop: check for pairwise isomorphism by varying over elements of the same point counts
lst := eval(LinesOfInputFile[1]);
supp := lst[1];
F0 := FFConstruction(supp);
fprintf OutputFileName, LinesOfInputFile[1] cat "\n";  
tmp := [F0];
for ind in [1..L] do
    lst2 := eval(LinesOfInputFile[ind]);
    supp2 := lst2[1];
    F02 := FFConstruction(supp2);
    if forall(u){m : m in tmp | IsIsomorphic(F02,m) eq false } eq true then
        Append(~tmp,F02);
        fprintf OutputFileName, LinesOfInputFile[ind] cat "\n";
    end if;
end for;

quit;
