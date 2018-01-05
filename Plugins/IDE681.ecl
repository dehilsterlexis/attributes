import iesp, doxie, doxie_crs, UCCv2_Services,doxie_ln, LN_PropertyV2_Services,Votersv2_services,fcra,ATF_Services,AutoStandardI,
	Foreclosure_Services, property;

export IncludeMod := module

	// ****************************************************************
	// To deploy only a subset of datasources, set IncludeAll=false and 
	//   toggle respective flags below.	
	// ****************************************************************
	shared IncludeAll											:= false;
	shared IncludeSexOffender							:= true;
	
	shared IncludePatriot 								:= false;	
	shared IncludeDriversAtAddress 				:= false;	
	shared IncludeFictitiousBusiness 			:= false;	
	shared IncludeRealtimeVehicle 				:= false;	
	shared IncludeTimeline				 				:= false;	
	shared IncludeUCCLegacy				 				:= false;	
	shared IncludeUCC2						 				:= false;	
	shared IncludeCorporateAffiliation		:= false;	
	shared IncludeEmployment							:= false;	
	shared IncludePropertiesV1						:= false;	
	shared IncludePropertiesV2						:= false;	
	shared IncludeAccident								:= false;	
	shared IncludeVoterV1									:= false;	
	shared IncludeVoterV2									:= false;	
	shared IncludeConcealedWeaponLicenses	:= false;	
	shared IncludeProfessionalLicenses		:= false;	
	shared IncludeSanctions								:= false;	
	shared IncludeProviders								:= false;	
	shared IncludeFireArmsAndExplosives		:= false;	
	shared IncludeHunting									:= false;	
	shared IncludePilots									:= false;	
	shared IncludeFAACertificates					:= false;	
	shared IncludeNoticeOfDefaults				:= false;	
	shared IncludeForeclosures						:= false;	
	shared IncludeJailbooking							:= false;	
	
	shared LayoutSexOffender 					:= doxie.layout_sexoffender_report;
	shared LayoutPatriot 							:= iesp.globalwatchlist.t_GlobalWatchListSearchRecord;
	shared LayoutDriversAtAddress 		:= iesp.driverlicense2.t_DLEmbeddedReport2Record;
	shared LayoutFictitiousBusiness		:= iesp.fictitiousbusinesssearch.t_FictitiousBusinessSearchRecord;
	shared LayoutRealtimeVehicle 			:= iesp.motorvehicle.t_MotorVehicleReport2Record;
	shared LayoutTimeline				 			:= doxie_crs.layout_timeline_summary;
	shared LayoutUCCLegacy			 			:= doxie_crs.layout_UCC_Records;
	shared LayoutUCC2						 			:= UCCv2_Services.layout_ucc_rollup;
	shared LayoutCorporateAffiliation	:= doxie_crs.layout_corp_affiliations_records;
	shared LayoutEmployment						:= doxie_crs.Layout_employment;
	shared LayoutPropertiesV1					:= doxie_crs.layout_property_ln;
	shared LayoutPropertiesV2					:= doxie_crs.layout_property_v2;
	shared LayoutAccident							:= doxie_crs.layout_FLCrash_Search_Records;
	shared LayoutVoterV1							:= doxie_crs.layout_voter_records;
	shared LayoutVoterV2							:= Votersv2_services.layouts.EmbeddedOutput;
	shared LayoutConcealedWeaponLicense	:= doxie_crs.layout_ccw_records;
	shared LayoutProfessionalLicense	:= doxie_crs.layout_PL_Records;
	shared LayoutSanction							:= doxie.ingenix_sanctions_module.layout_ingenix_sanctions_report;
	shared LayoutProvider							:= doxie.ingenix_provider_module.layout_ingenix_provider_report;
	shared LayoutFireArmsAndExplosives:= iesp.firearm.t_FirearmRecord;
	shared LayoutHunting							:= doxie_crs.layout_hunting_records;
	shared LayoutPilot								:= doxie_crs.layout_pilot_records;
	shared LayoutFAACertificate				:= doxie_crs.layout_pilot_cert_records;
	shared LayoutFAAAircraft					:= doxie_crs.layout_Faa_Aircraft_records;
	shared LayoutNoticeOfDefault			:= iesp.foreclosure.t_ForeclosureSearchRecord;
	shared LayoutForeclosure					:= doxie_crs.layout_foreclosure_report;
	shared LayoutJailbooking					:= iesp.jailbooking.t_BaseJailBookingRecord;
	
	export SexOffenderRecords(boolean include) := function
		#if(IncludeAll or IncludeSexOffender)
			recs := if(include,dedup(doxie.sexoffender_search_records(), seisint_primary_key));
		#else
			recs := dataset([], LayoutSexOffender);
		#end
		return recs;
	end;
	
	
	export PatriotRecords(boolean include) := function
		#if(IncludeAll or IncludePatriot)
			recs := if(include, doxie.CompPatriotSearch);
		#else
			recs := dataset([], LayoutPatriot);
		#end
		return recs;
	end;
	
	export DriversAtAddressRecords(boolean include, dataset(doxie.Layout_Comp_Addresses) csa_addresses) := function
		#if(IncludeAll or IncludeDriversAtAddress)
			recs := if(include, doxie.DlsAtAddress(csa_addresses));
		#else
			recs := dataset([], LayoutDriversAtAddress);
		#end
		return recs;
	end;
	
	export FictitiousBusinessRecords(boolean include, dataset(doxie.layout_references) dids) := function
		#if(IncludeAll or IncludeFictitiousBusiness)
			recs := if(include, doxie.Comp_FBN2Search(dids));
		#else
			recs := dataset([], LayoutFictitiousBusiness);
		#end
		return recs;
	end;
	
	export RealtimeVehicleRecords(boolean include, dataset(doxie.layout_references) dids) := function
		#if(IncludeAll or IncludeRealtimeVehicle)
			rtvDids := if(include, dids, dataset ([0], doxie.layout_references)); // force the gateway call to not take place work around for #8414  
			recs := if(include,doxie.Comp_RealTime_Vehicles(rtvDids).do);  			
		#else
			recs := dataset([], LayoutRealtimeVehicle);
		#end
		return recs;
	end;

	export TimelineRecords(dataset(doxie.layout_references) in_dids, string1 in_party_type = '', boolean incTimeline = false, 
												 boolean incCorporateAffiliations = false, unsigned3 dateVal = 0) := 	
	function
		#if(IncludeAll or IncludeTimeline)
			recs := doxie.timeline_summary(in_dids, in_party_type, incTimeline, incCorporateAffiliations, dateVal);
		#else
			recs := dataset([], LayoutTimeline);
		#end
		return recs;
	end;
	
	export UCCLegacyRecords(boolean include, string1 in_party_type = '') := function
		#if(IncludeAll or IncludeUCCLegacy)
			recs := if(include, doxie.UCC_legacy_records(in_party_type));
		#else
			recs := dataset([], LayoutUCCLegacy);
		#end
		return recs;
	end;	
	
	export UCC2Records(boolean include, dataset(doxie.layout_references) in_dids, string6 ssn_mask='NONE', string1 in_party_type = '') := function
		#if(IncludeAll or IncludeUCC2)
			recs := if(include, doxie.UCC_v2_Records(in_dids, ssn_mask, in_party_type));
		#else
			recs := dataset([], LayoutUCC2);
		#end
		return recs;
	end;	

	export CorporateAffiliationRecords(dataset(doxie.layout_references) in_dids, unsigned3 date_val = 0) := function
		#if(IncludeAll or IncludeCorporateAffiliation)
			recs := doxie.corp_affiliations_records(in_dids, date_val);
		#else
			recs := dataset([], LayoutCorporateAffiliation);
		#end
		return recs;
	end;	

	// export EmploymentRecords(boolean include, dataset(doxie.layout_references) in_dids, unsigned3 maxPeopleAtWork = 50,	unsigned3 date_val = 0,
			// unsigned1 glb_purpose = 0, unsigned1 dppa_purpose = 0, string6 ssn_mask='NONE') := function
	export EmploymentRecords(boolean include) := function 
		#if(IncludeAll or IncludeEmployment)			
			//recs := if(include, doxie.employment_records(in_dids, maxPeopleAtWork, date_val, glb_purpose, dppa_purpose, ssn_mask));
			recs := if(include, doxie.employment_records);
		#else
			recs := dataset([], LayoutEmployment);
		#end
		return recs;
	end;

	export PropertyRecordsV1(
		boolean include, 
		dataset (doxie.layout_best) besr  									= dataset ([], doxie.layout_best), 
		dataset (doxie.Layout_Comp_Addresses) csa_addresses = dataset ([], doxie.Layout_Comp_Addresses),
		dataset(doxie.layout_NameDID) csa_names 						= dataset ([], doxie.layout_NameDID),
		boolean IsFCRA = false) := function
		#if(IncludeAll or IncludePropertiesV1)			
			// TODO: fcra version used skipAddressRollup = false; why?
			recs := if(include, doxie_ln.property_records(besr,csa_addresses,csa_names,IsFCRA,skipAddressRollup := true));			
		#else
			recs := dataset([], LayoutPropertiesV1);
		#end;
		return recs;
	end;
	
	export PropertyRecordsV2(
		boolean include, 
		dataset(doxie.layout_references)			in_dids,
		dataset(doxie.Layout_Comp_Addresses)	csa_addresses,
		dataset(doxie.layout_NameDID)					csa_names,
		string32 appType) := function
		#if(IncludeAll or IncludePropertiesV2)			
			recs := if(include, LN_PropertyV2_Services.Ownership.get_CRS_records(in_dids, csa_addresses, csa_names, appType));
		#else
			recs := dataset([], LayoutPropertiesV2);
		#end;
		return recs;
	end;
	
	export AccidentRecords(boolean include, dataset(doxie.layout_references) in_dids) := function
		#if(IncludeAll or IncludeAccident)
			recs := if(include, doxie.flcrash_search_records(in_dids));
		#else
			recs := dataset([], LayoutAccident);
		#end
		return recs;
	end;	

	export VoterRecordsV1(boolean include) := function
		#if(IncludeAll or IncludeVoterV1)
			recs := if(include, doxie.voter_records);
		#else
			recs := dataset([], LayoutVoterV1);
		#end
		return recs;
	end;	

	export VoterRecordsV2(boolean include, dataset(doxie.layout_references) in_dids, string6 ssn_mask='NONE') := function
		#if(IncludeAll or IncludeVoterV2)
			recs := if(include, doxie.voters_v2_records(in_dids, ssn_mask));
		#else
			recs := dataset([], LayoutVoterV2);
		#end
		return recs;
	end;	

	export ConcealedWeaponLicenseRecords(boolean include) := function
		#if(IncludeAll or IncludeConcealedWeaponLicenses)
			recs := if(include, doxie.ccw_records);
		#else
			recs := dataset([], LayoutConcealedWeaponLicense);
		#end
		return recs;
	end;	

	export ProfessionalLicenseRecords(
		boolean include,
		dataset (doxie.layout_best) besr  = dataset ([], doxie.layout_best),
		boolean IsFCRA = false,
		dataset (fcra.Layout_override_flag) flags = fcra.compliance.blank_flagfile) := function
		#if(IncludeAll or IncludeProfessionalLicenses)
			recs := if(include,  doxie.pl_records (besr, IsFCRA, flags));
		#else
			recs := dataset([], LayoutProfessionalLicense);
		#end
		return recs;
	end;
	
	export SanctionRecords(boolean include, dataset(doxie.layout_references) in_dids) := function
		#if(IncludeAll or IncludeSanctions)
			recs := if(include, doxie.Sanc_records(in_dids));
		#else
			recs := dataset([], LayoutSanction);
		#end
		return recs;
	end;		
	
	export ProviderRecords(boolean include, dataset(doxie.layout_references) in_dids) := function
		#if(IncludeAll or IncludeProviders)
			recs := if(include,	doxie.Prov_records(in_dids));
		#else
			recs := dataset([], LayoutProvider);
		#end
		return recs;
	end;		

	export FireArmsAndExplosiveRecords(boolean include, dataset(doxie.layout_references) in_dids, boolean IsFCRA = false) := function
		#if(IncludeAll or IncludeFireArmsAndExplosives)
			global_mod := AutoStandardI.GlobalModule (true, , IsFCRA);
			aMod := module(project (global_mod,ATF_Services.SearchService_Records.params,opt)) 
				export string14 did := (string) in_dids[1].did;
			end;
			recs := if(include,ATF_Services.SearchService_Records.val(aMod));
		#else
			recs := dataset([], LayoutFireArmsAndExplosives);
		#end
		return recs;
	end;		

	export HuntingRecords() := function
		#if(IncludeAll or IncludeHunting)
			recs := doxie.hunting_records;
		#else
			recs := dataset([], LayoutHunting);
		#end
		return recs;
	end;		
	
	export PilotRecords(boolean include, dataset(doxie.layout_references) dids,  unsigned3 dateVal = 0,
    unsigned1 dppa_purpose = 0, unsigned1 glb_purpose = 0, string6 ssn_mask_value = 'NONE') := function
		#if(IncludeAll or IncludePilots)
			recs := if(include,	doxie.pilot_records(dids, dateVal, glb_purpose, dppa_purpose, ssn_mask_value));
		#else
			recs := dataset([], LayoutPilot);
		#end
		return recs;
	end;		
	
	export FAACertificateRecords(boolean include, dataset(doxie.layout_references) in_dids, unsigned3 dateVal = 0) := function
		#if(IncludeAll or IncludeFAACertificates)
			recs := if(include,	doxie.pilot_cert_records(in_dids, dateVal));
		#else
			recs := dataset([], LayoutFAACertificate);
		#end
		return recs;
	end;		
	
	export FAAAircraftRecords(boolean include) := function
		#if(IncludeAll or IncludeFAACertificates)
			recs := if(include, doxie.Faa_Aircraft_records);
		#else
			recs := dataset([], LayoutFAAAircraft);
		#end
		return recs;
	end;		

	export NoticeOfDefaultRecords(boolean include, dataset(doxie.layout_references) in_dids,  boolean IsFCRA = false) := function
		#if(IncludeAll or IncludeNoticeOfDefaults)
			global_mod := AutoStandardI.GlobalModule (true, , IsFCRA);
			nMod := module(project (global_mod, Foreclosure_Services.Records.params,opt)) 
				export string14 did := (string) in_dids[1].did;
			end;
			recs := if(include, Foreclosure_Services.Records.val(nMod,true));
		#else
			recs := dataset([], LayoutNoticeOfDefault);
		#end
		return recs;
	end;

	export ForeclosureRecords(boolean include) := function
		#if(IncludeAll or IncludeForeclosures)
			recs := if(include, property.Foreclosures_Records);
		#else
			recs := dataset([], LayoutForeclosure);
		#end
		return recs;
	end;	

	export JailbookingRecords(boolean include, dataset(doxie.layout_references) in_dids) := function
		#if(IncludeAll or IncludeJailbooking)
			recs := if(include, choosen(doxie.Jail_Booking_Records(in_dids), iesp.Constants.JB.MAX_COMP_REPORT_RECORDS));
		#else
			recs := dataset([], LayoutJailbooking);
		#end
		return recs;
	end;	
	


end;