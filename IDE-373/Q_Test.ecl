//HPCC Systems KEL Compiler Version 0.9.0-1
IMPORT KEL09 AS KEL;
IMPORT E_Person FROM IDE-373;
IMPORT * FROM KEL09.Null;
EXPORT Q_Test := MODULE
  SHARED TYPEOF(E_Person.__Result) __E_Person := E_Person.__Result;
  SHARED __EE22 := __E_Person;
  EXPORT Res0 := __UNWRAP(__EE22);
END;
