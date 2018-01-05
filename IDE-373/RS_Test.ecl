//HPCC Systems KEL Compiler Version 0.9.0-1
#OPTION('expandSelectCreateRow',true);
IMPORT KEL09 AS KEL;
IMPORT RQ_Test FROM IDE-373;
IMPORT * FROM KEL09.Null;
__RoxieQuery := RQ_Test;
OUTPUT(__RoxieQuery.Res0,NAMED('Result'));
