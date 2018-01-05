//HPCC Systems KEL Compiler Version 0.9.0-1
IMPORT KEL09 AS KEL;
IMPORT Modules;
IMPORT * FROM KEL09.Null;
EXPORT E_Person := MODULE
  EXPORT Typ := KEL.typ.uid;
  EXPORT InLayout := RECORD
    KEL.typ.nuid UID;
    KEL.typ.nunk _fname_;
    KEL.typ.nunk _lname_;
    KEL.typ.nint _rawage_;
    KEL.typ.nint _income_;
  END;
  SHARED VIRTUAL __SourceFilter(DATASET(InLayout) __ds) := __ds;
  SHARED VIRTUAL __GroupedFilter(GROUPED DATASET(InLayout) __ds) := __ds;
  SHARED __Mapping := 'id(UID),fname(_fname_:\'\'),lname(_lname_:\'\'),age(_rawage_:0),income(_income_:0)';
  EXPORT Modules_PersonSet_Big_File_Invalid := Modules.PersonSet.Big.File((KEL.typ.uid)id = 0);
  SHARED __d0_Prefiltered := Modules.PersonSet.Big.File((KEL.typ.uid)id <> 0);
  SHARED __d0 := __SourceFilter(KEL.FromFlat.Convert(__d0_Prefiltered,InLayout,__Mapping));
  EXPORT InData := __d0;
  EXPORT Layout := RECORD
    KEL.typ.nuid UID;
    KEL.typ.nunk _fname_;
    KEL.typ.nunk _lname_;
    KEL.typ.nint _rawage_;
    KEL.typ.nint _income_;
    KEL.typ.int __RecordCount := 0;
  END;
  EXPORT __PostFilter := __GroupedFilter(GROUP(DISTRIBUTE(InData,HASH(UID)),UID,LOCAL,ALL));
  Person_Group := __PostFilter;
  Layout Person__Rollup(InLayout __r, DATASET(InLayout) __recs) := TRANSFORM
    SELF._fname_ := KEL.Intake.SingleValue(__recs,_fname_);
    SELF._lname_ := KEL.Intake.SingleValue(__recs,_lname_);
    SELF._rawage_ := KEL.Intake.SingleValue(__recs,_rawage_);
    SELF._income_ := KEL.Intake.SingleValue(__recs,_income_);
    SELF.__RecordCount := COUNT(__recs);
    SELF := __r;
  END;
  Layout Person__Single_Rollup(InLayout __r) := TRANSFORM
    SELF.__RecordCount := 1;
    SELF := __r;
  END;
  EXPORT __PreResult := ROLLUP(HAVING(Person_Group,COUNT(ROWS(LEFT))=1),GROUP,Person__Single_Rollup(LEFT)) + ROLLUP(HAVING(Person_Group,COUNT(ROWS(LEFT))>1),GROUP,Person__Rollup(LEFT, ROWS(LEFT)));
  EXPORT __Result := __CLEARFLAGS(__PreResult) : PERSIST('~temp::KEL::KELTest::Nested::Person::Result',EXPIRE(7));
  EXPORT Result := __UNWRAP(__Result);
  EXPORT _fname__SingleValue_Invalid := KEL.Intake.DetectMultipleValues(__PreResult,_fname_);
  EXPORT _lname__SingleValue_Invalid := KEL.Intake.DetectMultipleValues(__PreResult,_lname_);
  EXPORT _rawage__SingleValue_Invalid := KEL.Intake.DetectMultipleValues(__PreResult,_rawage_);
  EXPORT _income__SingleValue_Invalid := KEL.Intake.DetectMultipleValues(__PreResult,_income_);
  EXPORT SanityCheck := DATASET([{COUNT(Modules_PersonSet_Big_File_Invalid),COUNT(_fname__SingleValue_Invalid),COUNT(_lname__SingleValue_Invalid),COUNT(_rawage__SingleValue_Invalid),COUNT(_income__SingleValue_Invalid)}],{KEL.typ.int Modules_PersonSet_Big_File_Invalid,KEL.typ.int _fname__SingleValue_Invalid,KEL.typ.int _lname__SingleValue_Invalid,KEL.typ.int _rawage__SingleValue_Invalid,KEL.typ.int _income__SingleValue_Invalid});
  EXPORT NullCounts := DATASET([
    {'Person','Modules.PersonSet.Big.File','UID',COUNT(Modules_PersonSet_Big_File_Invalid),COUNT(__d0)},
    {'Person','Modules.PersonSet.Big.File','fname',COUNT(__d0(__NL(_fname_))),COUNT(__d0(__NN(_fname_)))},
    {'Person','Modules.PersonSet.Big.File','lname',COUNT(__d0(__NL(_lname_))),COUNT(__d0(__NN(_lname_)))},
    {'Person','Modules.PersonSet.Big.File','age',COUNT(__d0(__NL(_rawage_))),COUNT(__d0(__NN(_rawage_)))},
    {'Person','Modules.PersonSet.Big.File','income',COUNT(__d0(__NL(_income_))),COUNT(__d0(__NN(_income_)))}]
  ,{KEL.typ.str entity,KEL.typ.str fileName,KEL.typ.str fieldName,KEL.typ.int nullCount,KEL.typ.int notNullCount});
  EXPORT Composite := MODULE
    EXPORT ID_Modules_PersonSet_Big_File := 1;
    EXPORT ID_All := [ID_Modules_PersonSet_Big_File];
    EXPORT Modules_PersonSet_Big_File_Reduced := RECORD
      #EXPAND(KEL.FromFlat.ReducedRecord(Modules.PersonSet.Big.File,'age,fname,id,income,lname'));
    END;
    EXPORT Modules_PersonSet_Big_File_Layout := RECORD
      Modules_PersonSet_Big_File_Reduced;
      KEL.typ.int __RecordCount := 0;
    END;
    EXPORT Layout := RECORD
      KEL.typ.uid UID := 0;
      DATASET(Modules_PersonSet_Big_File_Layout) Modules_PersonSet_Big_File := DATASET([],Modules_PersonSet_Big_File_Layout);
    END;
    SHARED Modules_PersonSet_Big_File_Sorted := PROJECT(SORT(DISTRIBUTE(Modules.PersonSet.Big.File((KEL.typ.uid)id <> 0),(KEL.typ.uid)id),(KEL.typ.uid)id,LOCAL),TRANSFORM({RECORDOF(Modules_PersonSet_Big_File_Reduced),KEL.typ.uid __UID},SELF:=LEFT,SELF.__UID:=(KEL.typ.uid)LEFT.id));
    SHARED Modules_PersonSet_Big_File_Dedup := TABLE(Modules_PersonSet_Big_File_Sorted,{Modules_PersonSet_Big_File_Sorted,KEL.typ.int __RecordCount := COUNT(GROUP)},#EXPAND(KEL.FromFlat.TopLevelNames(Modules_PersonSet_Big_File_Sorted)),LOCAL);
    EXPORT Modules_PersonSet_Big_File_PayloadByUID := INDEX(Modules_PersonSet_Big_File_Dedup,{__UID},{Modules_PersonSet_Big_File_Dedup},'~key::KEL::KELTest::Nested::E_Person::Composite::__EE15::Payload');
    EXPORT Build_Modules_PersonSet_Big_File_Index := BUILDINDEX(Modules_PersonSet_Big_File_PayloadByUID,OVERWRITE);
    Modules_PersonSet_Big_File_UIDs := DEDUP(PROJECT(Modules_PersonSet_Big_File_Sorted,TRANSFORM({KEL.typ.uid UID},SELF.UID:=(KEL.typ.uid)LEFT.id)),LOCAL);
    Base := PROJECT(DEDUP(Modules_PersonSet_Big_File_UIDs,UID,LOCAL),Layout);
    Layout __EE15_Denorm(Layout __r, DATASET(RECORDOF(Modules_PersonSet_Big_File_Dedup)) __recs) := TRANSFORM
      SELF.Modules_PersonSet_Big_File := PROJECT(__recs,Modules_PersonSet_Big_File_Layout);
      SELF := __r;
    END;
    __EE15_Composite := DENORMALIZE(Base,Modules_PersonSet_Big_File_Dedup,LEFT.UID = (KEL.typ.uid)RIGHT.__UID,GROUP,__EE15_Denorm(LEFT,ROWS(RIGHT)),LOCAL);
    EXPORT Stream := __EE15_Composite;
    SHARED Build_File := OUTPUT(Stream,,'~key::KEL::KELTest::Nested::Person::Composite::File',COMPRESSED,OVERWRITE);
    EXPORT File := DATASET('~key::KEL::KELTest::Nested::Person::Composite::File',{Layout,KEL.typ.int __RecPtr{virtual(fileposition)}},FLAT);
    EXPORT File_Index := INDEX(File,{UID,__RecPtr},'~key::KEL::KELTest::Nested::Person::Composite::Index');
    SHARED Build_File_Index := BUILDINDEX(File_Index,OVERWRITE);
    EXPORT Build_FileWithIndex := SEQUENTIAL(Build_File,Build_File_Index);
    EXPORT BuildAll := PARALLEL(Build_FileWithIndex,Build_Modules_PersonSet_Big_File_Index);
    EXPORT ID_Stream_Layout := RECORD
      KEL.typ.uid UniqueId;
    END;
    EXPORT Fetch(DATASET(ID_Stream_Layout) ins, SET OF KEL.typ.int ToFetch = []) := FUNCTION
      Layout Update(ID_Stream_Layout __ID, RECORDOF(File) __Base) := TRANSFORM
        SELF.UID := __Base.UID;
        __EE15_Fetch := PROJECT(Modules_PersonSet_Big_File_PayloadByUID(__UID = __ID.UniqueId),Modules_PersonSet_Big_File_Layout);
        SELF.Modules_PersonSet_Big_File := IF(ID_Modules_PersonSet_Big_File IN ToFetch,__EE15_Fetch,__Base.Modules_PersonSet_Big_File);
      END;
      RETURN JOIN(ins,File,LEFT.UniqueId = RIGHT.UID,UPDATE(LEFT,RIGHT),KEYED(File_Index));
    END;
  END;
  EXPORT ResultFromComposite(DATASET(Composite.Layout) __fdc) := FUNCTION
    __CombinedLayout := RECORD
      KEL.typ.uid UID;
      DATASET(Layout) __Result;
    END;
    __CombinedLayout __CombineSources(Composite.Layout __r) := TRANSFORM
      __Source0_Prefiltered := __r.Modules_PersonSet_Big_File;
      __Source0 := __SourceFilter(KEL.FromFlat.Convert(__Source0_Prefiltered,InLayout,__Mapping));
      __All := __Source0;
      SELF.UID := __r.UID;
      Person_Group := GROUP(DISTRIBUTE(__All,HASH(UID)),UID,LOCAL,ALL);
      Layout Person__Rollup(InLayout __r, DATASET(InLayout) __recs) := TRANSFORM
        SELF._fname_ := KEL.Intake.SingleValue(__recs,_fname_);
        SELF._lname_ := KEL.Intake.SingleValue(__recs,_lname_);
        SELF._rawage_ := KEL.Intake.SingleValue(__recs,_rawage_);
        SELF._income_ := KEL.Intake.SingleValue(__recs,_income_);
        SELF.__RecordCount := COUNT(__recs);
        SELF := __r;
      END;
      Layout Person__Single_Rollup(InLayout __r) := TRANSFORM
        SELF.__RecordCount := 1;
        SELF := __r;
      END;
      SELF.__Result := ROLLUP(HAVING(Person_Group,COUNT(ROWS(LEFT))=1),GROUP,Person__Single_Rollup(LEFT)) + ROLLUP(HAVING(Person_Group,COUNT(ROWS(LEFT))>1),GROUP,Person__Rollup(LEFT, ROWS(LEFT)));
    END;
    RETURN NORMALIZE(PROJECT(__fdc,__CombineSources(LEFT)),LEFT.__Result,TRANSFORM(Layout, SELF:=RIGHT));
  END;
END;
