//HPCC Systems KEL Compiler Version 0.9.0-1
IMPORT KEL09 AS KEL;
IMPORT E_Person FROM IDE-373;
IMPORT * FROM KEL09.Null;
EXPORT B_Person := MODULE
  SHARED __EE26 := E_Person.__Result;
  SHARED IDX_Person_UID_Layout := RECORD
    KEL.typ.uid UID;
    __EE26.__RecordCount;
  END;
  SHARED IDX_Person_UID_Projected := PROJECT(__EE26,TRANSFORM(IDX_Person_UID_Layout,SELF.UID:=__T(LEFT.UID),SELF:=LEFT));
  EXPORT IDX_Person_UID := INDEX(IDX_Person_UID_Projected,{UID},{IDX_Person_UID_Projected},'~key::KEL::IDE-373::Person::UID');
  EXPORT IDX_Person_UID_Build := BUILD(IDX_Person_UID,OVERWRITE);
  EXPORT __ST28_Layout := RECORDOF(IDX_Person_UID);
  EXPORT IDX_Person_UID_Wrapped := PROJECT(IDX_Person_UID,TRANSFORM(E_Person.Layout,SELF.UID := __CN(LEFT.UID),SELF:=LEFT));
  EXPORT BuildAll := PARALLEL(IDX_Person_UID_Build);
END;
