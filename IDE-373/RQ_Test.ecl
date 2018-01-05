//HPCC Systems KEL Compiler Version 0.9.0-1
IMPORT KEL09 AS KEL;
IMPORT B_Person,E_Person FROM IDE-373;
IMPORT * FROM KEL09.Null;
EXPORT RQ_Test := MODULE
  SHARED __EE38 := B_Person.IDX_Person_UID_Wrapped;
  EXPORT Res0 := __UNWRAP(__EE38);
END;
