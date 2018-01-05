//HPCC Systems KEL Compiler Version 0.9.0-1
#OPTION('expandSelectCreateRow',true);
IMPORT KEL09 AS KEL;
IMPORT CFG_ImpDud,RSH_Test_Shell FROM KELTest.Nested;
IMPORT * FROM KEL09.Null;
DATASET(CFG_ImpDud.Id_Stream_Layout) __Id_Stream := DATASET([],CFG_ImpDud.Id_Stream_Layout) : STORED('UniqueIDs');
__RoxieQuery := RSH_Test_Shell(__Id_Stream);
OUTPUT(__RoxieQuery.Result,NAMED('Result'));
