//HPCC Systems KEL Compiler Version 0.9.0-1
#OPTION('expandSelectCreateRow',true);
IMPORT KEL09 AS KEL;
IMPORT B_Person FROM IDE-373;
IMPORT * FROM KEL09.Null;
PARALLEL(B_Person.BuildAll);
