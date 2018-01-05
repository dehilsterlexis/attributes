//HPCC Systems KEL Compiler Version 0.9.0-1
#OPTION('expandSelectCreateRow',true);
IMPORT KEL09 AS KEL;
IMPORT * FROM KEL09.Null;
IMPORT * FROM KELTest.Nested;
OUTPUT(S_Test_Shell.Result,NAMED('TestShell'));
