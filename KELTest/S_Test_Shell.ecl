//HPCC Systems KEL Compiler Version 0.9.0-1
IMPORT KEL09 AS KEL;
IMPORT E_Person FROM KELTest;
IMPORT * FROM KEL09.Null;
EXPORT S_Test_Shell := MODULE
  SHARED TYPEOF(E_Person.__Result) __E_Person := E_Person.__Result;
  SHARED __EE43 := __E_Person;
  SHARED __ST30_Layout := RECORD
    KEL.typ.nuid UID;
    KEL.typ.nunk _fname_;
    KEL.typ.nunk _lname_;
    KEL.typ.int __RecordCount := 0;
  END;
  EXPORT Result := __UNWRAP(PROJECT(__EE43,__ST30_Layout));
END;
