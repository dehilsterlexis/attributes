//HPCC Systems KEL Compiler Version 0.9.0-1
#OPTION('expandSelectCreateRow',true);
IMPORT KEL09 AS KEL;
IMPORT B_Person,E_Person FROM KELTest;
IMPORT * FROM KEL09.Null;
PARALLEL(E_Person.Composite.BuildAll,B_Person.BuildAll);
