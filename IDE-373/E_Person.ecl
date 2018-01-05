//HPCC Systems KEL Compiler Version 0.9.0-1
IMPORT KEL09 AS KEL;
IMPORT Module;
IMPORT * FROM KEL09.Null;
EXPORT E_Person := MODULE
  EXPORT Typ := KEL.typ.uid;
  EXPORT InLayout := RECORD
    KEL.typ.nuid UID;
  END;
  SHARED VIRTUAL __SourceFilter(DATASET(InLayout) __ds) := __ds;
  SHARED __Mapping := 'uid(UID)';
  EXPORT Module_Attr_Invalid := Module.Attr((KEL.typ.uid)UID = 0);
  SHARED __d0_Prefiltered := Module.Attr((KEL.typ.uid)UID <> 0);
  SHARED __d0 := __SourceFilter(KEL.FromFlat.Convert(__d0_Prefiltered,InLayout,__Mapping));
  EXPORT InData := __d0;
  EXPORT Layout := RECORD
    KEL.typ.nuid UID;
    KEL.typ.int __RecordCount := 0;
  END;
  EXPORT __PreResult := PROJECT(TABLE(InData,{KEL.typ.int __RecordCount := COUNT(GROUP),UID},UID,MERGE),Layout);
  EXPORT __Result := __CLEARFLAGS(__PreResult) : PERSIST('~temp::KEL::IDE-373::Person::Result',EXPIRE(7));
  EXPORT Result := __UNWRAP(__Result);
  EXPORT SanityCheck := DATASET([{COUNT(Module_Attr_Invalid)}],{KEL.typ.int Module_Attr_Invalid});
  EXPORT NullCounts := DATASET([
    {'Person','Module.Attr','UID',COUNT(Module_Attr_Invalid),COUNT(__d0)}]
  ,{KEL.typ.str entity,KEL.typ.str fileName,KEL.typ.str fieldName,KEL.typ.int nullCount,KEL.typ.int notNullCount});
END;
