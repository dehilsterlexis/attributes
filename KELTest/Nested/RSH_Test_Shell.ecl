//HPCC Systems KEL Compiler Version 0.9.0-1
IMPORT KEL09 AS KEL;
IMPORT B_Person,CFG_ImpDud,E_Person FROM KELTest.Nested;
IMPORT * FROM KEL09.Null;
EXPORT RSH_Test_Shell(DATASET(CFG_ImpDud.Id_Stream_Layout) __Id_Stream) := MODULE
  SHARED __EE251 := B_Person.IDX_Person_UID;
  SHARED __EE194 := __Id_Stream;
  __JC313(B_Person.__ST75_Layout __EE251, CFG_ImpDud.Id_Stream_Layout __EE194) := KEL.Indexing.Key(__EE251.UID) = __EE194.UID;
  SHARED __EE314 := JOIN(__EE194,__EE251,__JC313(RIGHT,LEFT),TRANSFORM(B_Person.__ST75_Layout,SELF:=RIGHT),HASH);
  SHARED __EE352 := PROJECT(__EE314,TRANSFORM(E_Person.Layout,SELF.UID := __CN(LEFT.UID),SELF := LEFT));
  SHARED __ST30_Layout := RECORD
    KEL.typ.nuid UID;
    KEL.typ.nunk _fname_;
    KEL.typ.nunk _lname_;
    KEL.typ.int __RecordCount := 0;
  END;
  EXPORT Result := __UNWRAP(PROJECT(__EE352,__ST30_Layout));
END;
