/**
   @Author :Apoorva Sharma
   @name   : IOHandleRestRequestAndSendResponse 
   @CreateDate : 01 January 2016 
   @Description : This class is used for handle logic for IO Sync.
   @Version : 1.0 
  */
public with sharing class IOHandleRestRequestAndSendResponse {
    private List<ExceptionLog__c> exceptions=new list<ExceptionLog__c>();
    /**
     * @description       This method is used to populate records in fte details object, other cost detail,payroll and volume object. 
     * @param             SyncDataRequest syncdata
     * @return            string - true-operation sucessfull; false-operation failed
     * @throws            DML Exception
     */  
 public string syncData(SyncDataRequest syncdata){
    SyncDataRequest.SyncDataResponse syncresponse = new SyncDataRequest.SyncDataResponse();
    UtilConstants.IS_OPPTRIGGER_REQUIRED = false;
    list<FTE_Details__c> fte_listtosave= new List<FTE_Details__c>();
    list<Other_Cost_Details__c> ccd_listtosave= new List<Other_Cost_Details__c>();
    list<Payroll__c> payroll_listtosave= new List<Payroll__c>();
    list<Volume_Detail__c> volume_listtosave= new List<Volume_Detail__c>();
    costing_request__c rowcounts = new costing_request__c();
    map<string,id> BillCodeMap = new map<string,id>();
    map<string,id> careerlevelMap = new map<string,id>();
    map<string,id> countryMap=new map<string,id>();
    map<string,list<Opportunity_Delivery_Location__c>> deliveryLocationMap=new map<string,list<Opportunity_Delivery_Location__c>>();
    map<string,id> economicProfileMap=new map<string,id>();
    map<string,id> loadTypeMap=new map<string,id>();
    map<string,id> rateMap=new map<string,id>();
    map<string,id> roleMap=new map<string,id>();
    map<string,List<Service__c>> serviceMap=new map<string,List<Service__c>>();
    list<Service__c> servicelist=new List<Service__c>();
    map<string,Solution_Scope__c> solScopeMap=new map<string,Solution_Scope__c>();
    map<string,list<Service_Components__c>> solutionCompMap=new map<string,list<Service_Components__c>>();
    map<string,id> resourceGrpMap=new map<string,id>();
    map<string,id> careerT=new map<string,id>();
    map<string,id> map_fortechtool = new map<string,id>();
    set<String> services=new set<String>();
    set<string> solutionscopes = new set<string>();
    map<String,Services_Master__c> serviceMasterMap=new map<String,Services_Master__c>();
    map<String,id> serviceMasterMap1=new map<String,id>();
    set<String> offerings=new set<String>();
    map<id,id> toolservicemap=new map<id,id>();
    string description=UtilConstants.emptyStr;
    String serviceandoffering=UtilConstants.emptyStr;
    String offeringandsolutioncomponent=UtilConstants.emptyStr;
    set<id> servids = new set<id>();
    set<id> offmasterids = new set<id>();
    map<String,id> servicecomponentmap=new map<String,id>();
    id costrecordid;              
    map<String,Offering_Master__c> offeringMasterMasterMap=new map<String,Offering_Master__c>();
    FTE_Details__c fteRecordholder;
    Other_Cost_Details__c ccdRecordholder;
    Payroll__c payrollRecordholder;
    Volume_Detail__c volumeRecordholder;
    SWBBPOSEIntegrationConstants.runservTrigger = false;
    /*for(Offering_Master__c offmaster:[Select id,name from Offering_Master__c where active__c=true limit 500 ]){
      offeringMasterMasterMap.put(offmaster.name.toUpperCase(),offmaster);
    }*/
    /******************Building of Master Maps start here*********************/
    for(Career_Track_Master__c career : [select name from Career_Track_Master__c limit 500]){
      careerT.put(career.name.toUpperCase(),career.id);
    }
    for(Bill_Code_Master__c bill : [select name from Bill_Code_Master__c limit 500]){
      BillCodeMap.put(bill.name.toUpperCase(),bill.id);
    }
    for(Career_Level__c career : [select name from Career_Level__c limit 500]){
      careerlevelMap.put(career.name.toUpperCase(),career.id);
    }
    for(Country_Master__c country : masterqueries.querycountrymasters()){
      countryMap.put(country.name.toUpperCase(),country.id);
    }
    for(EconomicProfile_Master__c eco :[select name from EconomicProfile_Master__c limit 500]){
      economicProfileMap.put(eco.name.toUpperCase(),eco.id);
    }
    for(Load_Type_Master__c load :[select name from Load_Type_Master__c limit 500]){
      loadTypeMap.put(load.name.toUpperCase(),load.id);
    }
    for(Rate__c rate :[select name from Rate__c LIMIT 5000]){
      rateMap.put(rate.name.toUpperCase(),rate.id);
    }
    for(Resource_Group_Master__c resgrp:[select id, name from Resource_Group_Master__c limit 500]){
      resourceGrpMap.put(resgrp.name.toUpperCase().trim(),resgrp.id);
    }
    for(Role_Master__c role:[select name from Role_Master__c limit 500]){
      roleMap.put(role.name.toUpperCase(),role.id);
    }
    for(solution_scope__C scope : [select id,offering_master__r.name,(select id,services__r.name from services__r) from solution_scope__C where 
                                    opportunity__c  =:syncdata.opportunityid AND 
                                    (service_group__c=:SWBBPOSEIntegrationConstants.io OR service_group__c=:SWBBPOSEIntegrationConstants.IC) LIMIT 5000])
    {
        solScopeMap.put(scope.offering_master__r.name.toUppercase().trim(),scope);
        serviceMap.put(scope.id,scope.services__r);
    }
    for(service__c ser : [select id,(select id,Delivery_Location_Text__c from Opportunity_Delivery_Locations__r),(select id,Services_Component_Master__r.name
                from Service_Components__r) from service__c where 
                (Solutionscope__r.service_group__c=:SWBBPOSEIntegrationConstants.io OR Solutionscope__r.service_group__c=:SWBBPOSEIntegrationConstants.IC) and 
                Solutionscope__r.opportunity__c =:syncdata.opportunityid LIMIT 5000])
    {
        deliveryLocationMap.put(ser.id,ser.Opportunity_Delivery_Locations__r);
        solutionCompMap.put(ser.id,ser.Service_Components__r);
    }
    /******************Building of Master Maps end here*********************/
    rowcounts = [select id,CCD_Count_Dev__c,In_Progress__c,Payroll_Count_Dev__c,Volume_Count_Dev__c,FTE_count_Dev__c,FTE_CCD_Count_BPOSE_sent__c  from costing_request__c 
                where Opportunity__c=:syncdata.opportunityid limit 1];
    costrecordid = rowcounts.id;
    sync_status__c syncstatus = [select id,Chunk_Status_Sent__c,error_io__c,Final_Status_Recieved__c,Final_Status_Sent__c,Sync_Initiated_Time__c,Last_Synced_User__c,synced_Scenario__c
    from sync_Status__C where opportunity__c=:syncdata.opportunityid limit 1];
    if(syncdata.isFirstChunk){ 
        rowcounts.CCD_Count_Dev__c = 0;
        rowcounts.FTE_count_Dev__c = 0;
        rowcounts.Payroll_Count_Dev__c=0;
        rowcounts.Volume_Count_Dev__c=0;
        rowcounts.Trigger_final_mail_IO__c = false;
        rowcounts.In_Progress_PrevState__c=rowcounts.In_Progress__c;
        rowcounts.In_Progress_IO__c = SWBBPOSEIntegrationConstants.inprogressstatus ;
        rowcounts.In_Sync_IO__c = true;
        rowcounts.Email_Dev_IO__c = SWBBPOSEIntegrationConstants.emptystring;
        rowcounts.Calculation_IO__c = false;
        rowcounts.Sync_Initiated_Time__c = system.now();
        syncstatus.Sync_Initiated_Time__c = system.now();
        syncstatus.Last_Synced_User__c = SWBBPOSEIntegrationConstants.emptystring;
        syncstatus.Chunk_Status_Sent__c=SWBBPOSEIntegrationConstants.emptystring;
        syncstatus.error_io__c  =SWBBPOSEIntegrationConstants.emptystring;
        syncstatus.synced_Scenario_io__c=SWBBPOSEIntegrationConstants.emptystring;
        syncstatus.Final_Status_Recieved__c = SWBBPOSEIntegrationConstants.emptystring;
        syncstatus.Final_Status_Sent__c=SWBBPOSEIntegrationConstants.emptystring;
        syncstatus.calculation_failed__c = false;
        syncstatus.Force_fully_Failed__c = false;
        syncstatus.Sync_Status_IO__c = 2;
        syncstatus.Last_Synced_By_IO__c = null;
        update syncstatus; 
        update rowcounts;
        rowcounts = [select id,CCD_Count_Dev__c,In_Progress__c,Payroll_Count_Dev__c,Volume_Count_Dev__c,FTE_count_Dev__c,FTE_CCD_Count_BPOSE_sent__c  from costing_request__c 
                where Opportunity__c=:syncdata.opportunityid limit 1];
    }
    rowcounts.is_first_chunk_Dev__c = string.valueof(syncdata.isFirstChunk);
    /**************************Mapping of JSON data with Sobject fields start********************************************/
    /***************FTE Data Mapping Start**********************************************************/
    While(syncdata.FTEData.size() >=1){
      SyncDataRequest.FTEDataEntity currFte =  syncdata.FTEData[0];
      fteRecordholder =  new FTE_Details__c();
      if(rowcounts.FTE_count_Dev__c ==null ){
        rowcounts.FTE_count_Dev__c = 0;
      }
      rowcounts.FTE_count_Dev__c = rowcounts.FTE_count_Dev__c+1;
      fteRecordholder.Opportunity__c = syncdata.Opportunityid;
      fteRecordholder.Service_Group__c =syncdata.ServiceGroup;
      Date myDate = date.newinstance(1900,01,01);
      Date myoriginalDate = date.parse(currFte.MobilizationStartDt);
      if(myoriginalDate != mydate && myoriginalDate > mydate  ){
        fteRecordholder.Mobilization_Start_Date__c = myoriginaldate;
      }
      else{
        fteRecordholder.Mobilization_Start_Date__c = null;
      }
      myoriginalDate =  date.parse(currFte.GoLiveDt);
      if(myoriginalDate != myDate  && myoriginalDate > mydate){
        fteRecordholder.Go_Live_Date__c=myoriginalDate;
      }else{
        fteRecordholder.Go_Live_Date__c=null;
      }
      if(currFte.Description.Length() >80){
        fteRecordholder.Name  = currFte.Description.substring(0,80); 
        fteRecordholder.Activity_Description__c = currFte.Description;
      }
      else{
        fteRecordholder.Name = currFte.Description;
        fteRecordholder.Activity_Description__c = currFte.Description;
      }
      if(currFte.RecruitingCostPCT != SWBBPOSEIntegrationConstants.emptystring && currFte.RecruitingCostPCT!= null){
         fteRecordholder.Recruiting_Cost__c = Decimal.valueof(currFte.RecruitingCostPCT)*100;
      } 
      fteRecordholder.Costing_Type__c = currFte.CostingTypeCd;
      fteRecordholder.Language__c = currFte.LanguageNm;
      fteRecordholder.Description1__c = currFte.Description1;
      fteRecordholder.Description2__c = currFte.Description2;
      fteRecordholder.Description3__c = currFte.Description3;
      fteRecordholder.Description4__c = currFte.Description4;
      fteRecordholder.Description5__c = currFte.Description5;
      fteRecordholder.Description6__c = currFte.Description6;
      fteRecordholder.Description7__c = currFte.Description7;
      fteRecordholder.Generic1__c = currFte.Generic1;
      fteRecordholder.Generic2__c = currFte.Generic2;
      fteRecordholder.Generic3__c = currFte.Generic3;
      fteRecordholder.Offering1__c = currFte.ToolName;
      fteRecordholder.Offering2__c = currFte.ToolType;
      fteRecordholder.Offering3__c = currFte.Offering3;
      fteRecordholder.DCN_FTE_Type__c = currFte.DCNFTEType;
      fteRecordholder.FTE_Type__c = currFte.FTEType;
      if(String.isNotBlank(currFte.BaselineFTE) && string.isNotEmpty(currFte.BaselineFTE)){
        fteRecordholder.Baseline_FTEs__c = Decimal.valueof(currFte.BaselineFTE);
      }
      else{
        fteRecordholder.Baseline_FTEs__c = 0.00;
      }
      if(String.isNotBlank(currFte.PyramidRichness) && string.isNotEmpty(currFte.PyramidRichness)){
        fteRecordholder.Pyramid_Richness__c = decimal.valueof(currFte.PyramidRichness);
      }
      else{
        fteRecordholder.Pyramid_Richness__c =0.00;
      }
      fteRecordholder.Column1__c = currFte.CrossSolutioning;
      fteRecordholder.Column4__c = currFte.LanguagePremium;
      fteRecordholder.Column6__c = currFte.column6;
      fteRecordholder.Column7__c = currFte.column7;
      fteRecordholder.Column8__c = currFte.column8;
      fteRecordholder.Column9__c = currFte.column9;
      fteRecordholder.Column10__c = currFte.column10;
      fteRecordholder.Column11__c = currFte.column11;
      fteRecordholder.Column12__c = currFte.column12;
      fteRecordholder.Column13__c = currFte.column13;
      fteRecordholder.Column14__c = currFte.column14;
      fteRecordholder.Column15__c = currFte.column15;
      fteRecordholder.Column16__c = currFte.column16;
      fteRecordholder.Column17__c = currFte.column17;
      fteRecordholder.M1__c = currFte.Month1;
      fteRecordholder.M2__c = currFte.Month2;
      fteRecordholder.M3__c = currFte.Month3;
      fteRecordholder.M4__c = currFte.Month4;
      fteRecordholder.M5__c = currFte.Month5;
      fteRecordholder.M6__c = currFte.Month6;
      fteRecordholder.M7__c = currFte.Month7;
      fteRecordholder.M8__c = currFte.Month8;
      fteRecordholder.M9__c = currFte.Month9;
      fteRecordholder.M10__c = currFte.Month10;
      fteRecordholder.M11__c = currFte.Month11;
      fteRecordholder.M12__c = currFte.Month12;
      fteRecordholder.M13__c = currFte.Month13;
      fteRecordholder.M14__c = currFte.Month14;
      fteRecordholder.M15__c = currFte.Month15;
      fteRecordholder.M16__c = currFte.Month16;
      fteRecordholder.M17__c = currFte.Month17;
      fteRecordholder.M18__c = currFte.Month18;
      fteRecordholder.M19__c = currFte.Month19;
      fteRecordholder.M20__c = currFte.Month20;
      fteRecordholder.M21__c = currFte.Month21;
      fteRecordholder.M22__c = currFte.Month22;
      fteRecordholder.M23__c = currFte.Month23;
      fteRecordholder.M24__c = currFte.Month24;
      fteRecordholder.M25__c = currFte.Month25;
      fteRecordholder.M26__c = currFte.Month26;
      fteRecordholder.M27__c = currFte.Month27;
      fteRecordholder.M28__c = currFte.Month28;
      fteRecordholder.M29__c = currFte.Month29;
      fteRecordholder.M30__c = currFte.Month30;
      fteRecordholder.M31__c = currFte.Month31;
      fteRecordholder.M32__c = currFte.Month32;
      fteRecordholder.M33__c = currFte.Month33;
      fteRecordholder.M34__c = currFte.Month34;
      fteRecordholder.M35__c = currFte.Month35;
      fteRecordholder.M36__c = currFte.Month36;
      fteRecordholder.M37__c = currFte.Month37;
      fteRecordholder.M38__c = currFte.Month38;
      fteRecordholder.M39__c = currFte.Month39;
      fteRecordholder.M40__c = currFte.Month40;
      fteRecordholder.M41__c = currFte.Month41;
      fteRecordholder.M42__c = currFte.Month42;
      fteRecordholder.M43__c = currFte.Month43;
      fteRecordholder.M44__c = currFte.Month44;
      fteRecordholder.M45__c = currFte.Month45;
      fteRecordholder.M46__c = currFte.Month46;
      fteRecordholder.M47__c = currFte.Month47;
      fteRecordholder.M48__c = currFte.Month48;
      fteRecordholder.M49__c = currFte.Month49;
      fteRecordholder.M50__c = currFte.Month50;
      fteRecordholder.M51__c = currFte.Month51;
      fteRecordholder.M52__c = currFte.Month52;
      fteRecordholder.M53__c = currFte.Month53;
      fteRecordholder.M54__c = currFte.Month54;
      fteRecordholder.M55__c = currFte.Month55;
      fteRecordholder.M56__c = currFte.Month56;
      fteRecordholder.M57__c = currFte.Month57;
      fteRecordholder.M58__c = currFte.Month58;
      fteRecordholder.M59__c = currFte.Month59;
      fteRecordholder.M60__c = currFte.Month60;
      fteRecordholder.M61__c = currFte.Month61;
      fteRecordholder.M62__c = currFte.Month62;
      fteRecordholder.M63__c = currFte.Month63;
      fteRecordholder.M64__c = currFte.Month64;
      fteRecordholder.M65__c = currFte.Month65;
      fteRecordholder.M66__c = currFte.Month66;
      fteRecordholder.M67__c = currFte.Month67;
      fteRecordholder.M68__c = currFte.Month68;
      fteRecordholder.M69__c = currFte.Month69;
      fteRecordholder.M70__c = currFte.Month70;
      fteRecordholder.M71__c = currFte.Month71;
      fteRecordholder.M72__c = currFte.Month72;
      fteRecordholder.M73__c = currFte.Month73;
      fteRecordholder.M74__c = currFte.Month74;
      fteRecordholder.M75__c = currFte.Month75;
      fteRecordholder.M76__c = currFte.Month76;
      fteRecordholder.M77__c = currFte.Month77;
      fteRecordholder.M78__c = currFte.Month78;
      fteRecordholder.M79__c = currFte.Month79;
      fteRecordholder.M80__c = currFte.Month80;
      fteRecordholder.M81__c = currFte.Month81;
      fteRecordholder.M82__c = currFte.Month82;
      fteRecordholder.M83__c = currFte.Month83;
      fteRecordholder.M84__c = currFte.Month84;
      fteRecordholder.M85__c = currFte.Month85;
      fteRecordholder.M86__c = currFte.Month86;
      fteRecordholder.M87__c = currFte.Month87;
      fteRecordholder.M88__c = currFte.Month88;
      fteRecordholder.M89__c = currFte.Month89;
      fteRecordholder.M90__c = currFte.Month90;
      fteRecordholder.M91__c = currFte.Month91;
      fteRecordholder.M92__c = currFte.Month92;
      fteRecordholder.M93__c = currFte.Month93;
      fteRecordholder.M94__c = currFte.Month94;
      fteRecordholder.M95__c = currFte.Month95;
      fteRecordholder.M96__c = currFte.Month96;
      fteRecordholder.M97__c = currFte.Month97;
      fteRecordholder.M98__c = currFte.Month98;
      fteRecordholder.M99__c = currFte.Month99;
      fteRecordholder.M100__c = currFte.Month100;
      fteRecordholder.M101__c = currFte.Month101;
      fteRecordholder.M102__c = currFte.Month102;
      fteRecordholder.M103__c = currFte.Month103;
      fteRecordholder.M104__c = currFte.Month104;
      fteRecordholder.M105__c = currFte.Month105;
      fteRecordholder.M106__c = currFte.Month106;
      fteRecordholder.M107__c = currFte.Month107;
      fteRecordholder.M108__c = currFte.Month108;
      fteRecordholder.M109__c = currFte.Month109;
      fteRecordholder.M110__c = currFte.Month110;
      fteRecordholder.M111__c = currFte.Month111;
      fteRecordholder.M112__c = currFte.Month112;
      fteRecordholder.M113__c = currFte.Month113;
      fteRecordholder.M114__c = currFte.Month114;
      fteRecordholder.M115__c = currFte.Month115;
      fteRecordholder.M116__c = currFte.Month116;
      fteRecordholder.M117__c = currFte.Month117;
      fteRecordholder.M118__c = currFte.Month118;
      fteRecordholder.M119__c = currFte.Month119;
      fteRecordholder.M120__c = currFte.Month120;
      fteRecordholder.Mob_Category__c = currFte.MobCategory;
      fteRecordholder.Mob_Sub_Category__c = currFte.MobSubCategory;
      fteRecordholder.Non_DCN_Location__c = currFte.NONDCNLocation;
      fteRecordholder.Service_Component_Dev__c = currFte.ServiceComponent;
      fteRecordholder.Run_Yr1__c = currFte.RunYr1;    
      fteRecordholder.Run_Yr2__c = currFte.RunYr2;    
      fteRecordholder.Run_Yr3__c = currFte.RunYr3;    
      fteRecordholder.Run_Yr4__c = currFte.RunYr4;    
      fteRecordholder.Run_Yr5__c = currFte.RunYr5;    
      fteRecordholder.Run_Yr6__c = currFte.RunYr6;    
      fteRecordholder.Run_Yr7__c = currFte.RunYr7;    
      fteRecordholder.Run_Yr8__c = currFte.RunYr8;    
      fteRecordholder.Run_Yr9__c = currFte.RunYr9;    
      fteRecordholder.Run_Yr10__c = currFte.RunYr10;  
      fteRecordholder.Mob_Totals__c = currFte.MobTotals;
      fteRecordholder.TotalLoads__c = currFte.LoadedCostRate;
      system.debug('mob totals value --------> '+currFte.MobTotals);
      fteRecordholder.Final_Month_FTE__c = currfte.FinalMonthFTE;
      fteRecordholder.FTEYr1__c = currFte.FTEYr1;     
      fteRecordholder.FTEYr2__c = currFte.FTEYr2;     
      fteRecordholder.FTEYr3__c = currFte.FTEYr3;     
      fteRecordholder.FTEYr4__c = currFte.FTEYr4;     
      fteRecordholder.FTEYr5__c = currFte.FTEYr5;     
      fteRecordholder.FTEYr6__c = currFte.FTEYr6;     
      fteRecordholder.FTEYr7__c = currFte.FTEYr7;     
      fteRecordholder.FTEYr8__c = currFte.FTEYr8;     
      fteRecordholder.FTEYr9__c = currFte.FTEYr9;     
      fteRecordholder.FTEYr10__c = currFte.FTEYr10;
      fteRecordholder.costing_request__c = costrecordid; 
      fteRecordholder.FTEMobTotals__c = currFte.FTEMobTotals;
      fteRecordholder.HoursAppliedToContract__c = currFte.HoursAppliedToContract;     
      fteRecordholder.CostRate__c = currFte.CostRate;
      fteRecordholder.Phase__c=  currFte.Phase;
      fteRecordholder.GroupName__c=currFte.GroupName;
      /**********************Transformation Total fields*************************/
      fteRecordholder.FTE_Transformation_Totals__c = currfte.FTETransformationTotals;
      fteRecordholder.Transformation_Totals__c = currfte.TransformationTotals;
      system.debug('FTE mob totals value --------> '+currFte.FTEMobTotals);
      // is transient will be true for all newly inserted records
      fteRecordholder.Is_Transient__c = true;
      //mapping for relationship fields
     fteRecordholder.Load_Type_Dev__c =currFte.LoadTypeCd;
      if(currFte.CountryNm !=null && countryMap.get(currFte.CountryNm.toUppercase()) != null){
        fteRecordholder.Country__c = countryMap.get(currFte.CountryNm.toUppercase());
      }
      if(currFte.CareerLevelNm != null && careerlevelMap.get(currFte.CareerLevelNm.toUppercase()) != null){
        fteRecordholder.Career_Level__c = careerlevelMap.get(currFte.CareerLevelNm.toUppercase());
      }
      if(currFte.BillCodeCd != null && BillCodeMap.get(currFte.BillCodeCd.toUppercase())!=null){
        fteRecordholder.Bill_Code__c = BillCodeMap.get(currFte.BillCodeCd.toUppercase());
      }
      if(currFte.CareerTrackNm!=null && careerT.get(currFte.CareerTrackNm.toUppercase()) != null){
        fteRecordholder.Career_Track__c = careerT.get(currFte.CareerTrackNm.toUppercase());
      }
      if(currFte.LoadTypeCd!=null && loadTypeMap.get(currFte.LoadTypeCd.toUppercase()) != null){
        fteRecordholder.Load_Type__c = loadTypeMap.get(currFte.LoadTypeCd.toUppercase());
      }
      if(currFte.RateTypeCd!=null && rateMap.get(currFte.RateTypeCd.toUppercase()) != null){
        fteRecordholder.Rate_Type__c = rateMap.get(currFte.RateTypeCd.toUppercase());
      }
      if(currFte.EconomicProfileNm!=null && economicProfileMap.get(currFte.EconomicProfileNm.toUppercase()) != null){
        fteRecordholder.Economic_Profile__c = economicProfileMap.get(currFte.EconomicProfileNm.toUppercase());
      }
      if(currFte.Role!=null && roleMap.get(currFte.Role.toUppercase()) != null){
        fteRecordholder.Role_Master__c = roleMap.get(currFte.Role.toUppercase());
      }
      fteRecordholder.Location_typeName__c = currFte.LocationTypeName;
      fteRecordholder.Location_typeCode__c = string.valueof(currFte.LocationTypeCode);
      if(currFte.LocationTypeCode !=null && currFte.LocationTypeCode !=0){
        
        if(currFte.LocationTypeName!=null && resourceGrpMap.get(currFte.LocationTypeName.trim()) != null){
          fteRecordholder.Resource_Group__c = resourceGrpMap.get(currFte.LocationTypeName.trim());
        }
       }
      fteRecordholder.Service_Dev__c = currFte.ServiceOfferingNm;
      fteRecordholder.Offering_Dev__c = currFte.SubServiceOfferingNm;
      system.debug('delivery location received'+currFte.DeliveryLocationNm);
      if(currFte.DeliveryLocationNm.contains(SWBBPOSEIntegrationConstants.Zero)){
        fteRecordholder.Delivery_Location_Dev__c=SWBBPOSEIntegrationConstants.emptystring;
      }
      else{
        fteRecordholder.Delivery_Location_Dev__c=currFte.DeliveryLocationNm;              
      }
      system.debug('solscope map'+solScopeMap.get(currFte.SubServiceOfferingNm.toUppercase().trim()));
      system.debug('scope received'+currFte.SubServiceOfferingNm.toUppercase().trim());
     if(solScopeMap.get(currFte.SubServiceOfferingNm.toUppercase().trim()) != null){
          fteRecordholder.Sub_Service_Group__c = solScopeMap.get(currFte.SubServiceOfferingNm.toUppercase().trim()).id;
          solution_Scope__C scope = solScopeMap.get(currFte.SubServiceOfferingNm.toUppercase().trim());
          system.debug('scope matching');
            for(service__c ser:scope.services__r){
              if(ser.services__r.name.equalsignorecase(currFte.ServiceOfferingNm.toUppercase().trim())){
                  system.debug('Service matching'+currFte.ServiceOfferingNm);
                  fteRecordholder.Service__c = ser.id;
              }
            }
          if(fteRecordholder.Service__c==null){
              system.debug('Service not matching'+currFte.ServiceOfferingNm);
                 if(syncstatus.error_io__c==null || syncstatus.error_io__c==SWBBPOSEIntegrationConstants.emptystring){
                   syncstatus.error_io__c = SWBBPOSEIntegrationConstants.InvalidOffering+currFte.ServiceOfferingNm+
                                            SWBBPOSEIntegrationConstants.offering+currFte.SubServiceOfferingNm;
                 }
                  if(syncstatus.Chunk_Status_Sent__c !=null){
                    syncstatus.Chunk_Status_Sent__c += SWBBPOSEIntegrationConstants.FALSE_STR;
                }
                else{
                    syncstatus.Chunk_Status_Sent__c = SWBBPOSEIntegrationConstants.FALSE_STR;
                }
                update syncstatus;
              return responseFunction(false);
          }
      }
      else{
          if(syncstatus.error_io__c==null || syncstatus.error_io__c==SWBBPOSEIntegrationConstants.emptystring){
              syncstatus.error_io__c = SWBBPOSEIntegrationConstants.InvalidOffering+currFte.ServiceOfferingNm+
                                       SWBBPOSEIntegrationConstants.offering+currFte.SubServiceOfferingNm;
          }
           if(syncstatus.Chunk_Status_Sent__c !=null){
              syncstatus.Chunk_Status_Sent__c += SWBBPOSEIntegrationConstants.FALSE_STR;
           }
           else{
              syncstatus.Chunk_Status_Sent__c = SWBBPOSEIntegrationConstants.FALSE_STR;
           }
           update syncstatus;
           return responseFunction(false);
      }
      fteRecordholder.Country_Dev__c =currFte.CountryNm;
      if(serviceMap.get(fteRecordholder.Sub_Service_Group__c) !=null){
            for(opportunity_delivery_location__c oppdel : deliveryLocationMap.get(fteRecordholder.Service__c)){ 
                 if(oppdel.Delivery_Location_Text__c != null && oppdel.Delivery_Location_Text__c.containsIgnorecase(fteRecordholder.Country_Dev__c) && 
                    oppdel.Delivery_Location_Text__c.containsIgnorecase(SWBBPOSEIntegrationConstants.IS)){
                     system.debug('oppdel.Delivery_Location_Text__c--------------------------------------------->'+oppdel.Delivery_Location_Text__c);
                     system.debug('fteRecordholder.Country_Dev__c------------------------------------------------------>'+fteRecordholder.Country_Dev__c);
                     fteRecordholder.Opportunity_Delivery_Location__c = oppdel.id;
                 }
             }
             for(Service_Components__c serComp : solutionCompMap.get(fteRecordholder.Service__c)){
                  if(serComp.Services_Component_Master__r.name.equalsignoreCase(currFte.ServiceComponent.toUppercase().trim())){
                     fteRecordholder.Service_Component__c = serComp.id;
                 } 
             }
      }
      fte_listtosave.add(fteRecordholder);
      syncdata.FTEData.remove(0);
    }
    Integer i = 0;
    while(i<=100){
      i = Math.Round(Math.Random()*200);
    }
    //if(fte_listtosave.size() >i && fte_listtosave.size() <= 200){
     system.debug('fte_listtosave IO---------------------------------------------------------->'+fte_listtosave.size());
      system.debug('fte_listtosave Result---------------------------------------------------------->'+fte_listtosave);
      try{
            UtilConstants.allowactivation= utilconstants.allowstatusupdation = true;
            insert fte_listtosave;
            fte_listtosave.clear();
      }
      catch(Exception ex){
        ExceptionClass.logException(SWBBPOSEIntegrationConstants.IOHandleRestRequestAndSendResponse,UtilConstants.syncData,ex,UtilConstants.SWB,UtilConstants.BPOSE);
         if(syncstatus.error_io__c==null || syncstatus.error_io__c==SWBBPOSEIntegrationConstants.emptystring){
           syncstatus.error_io__c = ex.getmessage();
         }
          if(syncstatus.Chunk_Status_Sent__c !=null){
            syncstatus.Chunk_Status_Sent__c += SWBBPOSEIntegrationConstants.FALSE_STR;
          }
          else{
            syncstatus.Chunk_Status_Sent__c = SWBBPOSEIntegrationConstants.FALSE_STR;
          }
         return responseFunction(false);
      }
    //}
 /******************Mapping CCD Data starts here*********************/ 
    while(syncdata.CCData.size() >= 1){
      SyncDataRequest.CCDataEntity currccd = syncdata.CCData[0];
      if(rowcounts.CCD_Count_Dev__c  == null){
         rowcounts.CCD_Count_Dev__c=0;
      }
      rowcounts.CCD_Count_Dev__c = rowcounts.CCD_Count_Dev__c+1;
      ccdRecordholder =  new Other_Cost_Details__c();
      ccdRecordholder.source__c=SWBBPOSEIntegrationConstants.sync;
      ccdRecordholder.Opportunity__c = syncdata.Opportunityid;
      ccdRecordholder.Service_Group__c =syncdata.ServiceGroup;
      Date myDate = date.newinstance(01,01,1900);
      //system.debug('Format date SWB'+myDate);
      Date myoriginalDate = date.parse(currccd.MobilizationStartDt);
      //system.debug('Format date BPOSE'+myoriginalDate);
      if(myoriginalDate != mydate  && myoriginalDate > mydate){
        ccdRecordholder.Mobilization_Start_Date__c = myoriginalDate;
      }
      else{
        ccdRecordholder.Mobilization_Start_Date__c = null;
      }
      myoriginalDate =  date.parse(currccd.GoLiveDt);
      if(myoriginalDate != myDate  && myoriginalDate > mydate){
        ccdRecordholder.Go_Live_Date__c = myoriginalDate;
      }else{
        ccdRecordholder.Go_Live_Date__c=null;
      }
      ccdRecordholder.Name = currccd.Description;
      ccdRecordholder.Costing_Type__c = currccd.CostingTypeCd;
      if(currccd.Description.Length() >80){
        ccdRecordholder.Name  = currccd.Description.substring(0,80); 
        ccdRecordholder.ActivityDescription__c = currccd.Description;
      }
      else{
        ccdRecordholder.Name = currccd.Description;
        ccdRecordholder.ActivityDescription__c = currccd.Description;
      }
      ccdRecordholder.Description1__c = currccd.Description1;
      ccdRecordholder.Description2__c = currccd.Description2;
      ccdRecordholder.Description3__c = currccd.Description3;
      ccdRecordholder.Description4__c = currccd.Description4;
      ccdRecordholder.Description5__c = currccd.Description5;
      ccdRecordholder.Description6__c = currccd.Description6;
      ccdRecordholder.Description7__c = currccd.Description7;
      ccdRecordholder.Generic1__c = currccd.Generic1;
      ccdRecordholder.Generic2__c = currccd.Generic2;
      ccdRecordholder.Generic3__c = currccd.Generic3;
      ccdRecordholder.Offering2__c = currccd.ToolName;
      ccdRecordholder.Offering3__c = currccd.ToolType;
      ccdRecordholder.M1__c = currccd.Month1;
      ccdRecordholder.M2__c = currccd.Month2;
      ccdRecordholder.M3__c = currccd.Month3;
      ccdRecordholder.M4__c = currccd.Month4;
      ccdRecordholder.M5__c = currccd.Month5;
      ccdRecordholder.M6__c = currccd.Month6;
      ccdRecordholder.M7__c = currccd.Month7;
      ccdRecordholder.M8__c = currccd.Month8;
      ccdRecordholder.M9__c = currccd.Month9;
      ccdRecordholder.M10__c = currccd.Month10;
      ccdRecordholder.M11__c = currccd.Month11;
      ccdRecordholder.M12__c = currccd.Month12;
      ccdRecordholder.M13__c = currccd.Month13;
      ccdRecordholder.M14__c = currccd.Month14;
      ccdRecordholder.M15__c = currccd.Month15;
      ccdRecordholder.M16__c = currccd.Month16;
      ccdRecordholder.M17__c = currccd.Month17;
      ccdRecordholder.M18__c = currccd.Month18;
      ccdRecordholder.M19__c = currccd.Month19;
      ccdRecordholder.M20__c = currccd.Month20;
      ccdRecordholder.M21__c = currccd.Month21;
      ccdRecordholder.M22__c = currccd.Month22;
      ccdRecordholder.M23__c = currccd.Month23;
      ccdRecordholder.M24__c = currccd.Month24;
      ccdRecordholder.M25__c = currccd.Month25;
      ccdRecordholder.M26__c = currccd.Month26;
      ccdRecordholder.M27__c = currccd.Month27;
      ccdRecordholder.M28__c = currccd.Month28;
      ccdRecordholder.M29__c = currccd.Month29;
      ccdRecordholder.M30__c = currccd.Month30;
      ccdRecordholder.M31__c = currccd.Month31;
      ccdRecordholder.M32__c = currccd.Month32;
      ccdRecordholder.M33__c = currccd.Month33;
      ccdRecordholder.M34__c = currccd.Month34;
      ccdRecordholder.M35__c = currccd.Month35;
      ccdRecordholder.M36__c = currccd.Month36;
      ccdRecordholder.M37__c = currccd.Month37;
      ccdRecordholder.M38__c = currccd.Month38;
      ccdRecordholder.M39__c = currccd.Month39;
      ccdRecordholder.M40__c = currccd.Month40;
      ccdRecordholder.M41__c = currccd.Month41;
      ccdRecordholder.M42__c = currccd.Month42;
      ccdRecordholder.M43__c = currccd.Month43;
      ccdRecordholder.M44__c = currccd.Month44;
      ccdRecordholder.M45__c = currccd.Month45;
      ccdRecordholder.M46__c = currccd.Month46;
      ccdRecordholder.M47__c = currccd.Month47;
      ccdRecordholder.M48__c = currccd.Month48;
      ccdRecordholder.M49__c = currccd.Month49;
      ccdRecordholder.M50__c = currccd.Month50;
      ccdRecordholder.M51__c = currccd.Month51;
      ccdRecordholder.M52__c = currccd.Month52;
      ccdRecordholder.M53__c = currccd.Month53;
      ccdRecordholder.M54__c = currccd.Month54;
      ccdRecordholder.M55__c = currccd.Month55;
      ccdRecordholder.M56__c = currccd.Month56;
      ccdRecordholder.M57__c = currccd.Month57;
      ccdRecordholder.M58__c = currccd.Month58;
      ccdRecordholder.M59__c = currccd.Month59;
      ccdRecordholder.M60__c = currccd.Month60;
      ccdRecordholder.M61__c = currccd.Month61;
      ccdRecordholder.M62__c = currccd.Month62;
      ccdRecordholder.M63__c = currccd.Month63;
      ccdRecordholder.M64__c = currccd.Month64;
      ccdRecordholder.M65__c = currccd.Month65;
      ccdRecordholder.M66__c = currccd.Month66;
      ccdRecordholder.M67__c = currccd.Month67;
      ccdRecordholder.M68__c = currccd.Month68;
      ccdRecordholder.M69__c = currccd.Month69;
      ccdRecordholder.M70__c = currccd.Month70;
      ccdRecordholder.M71__c = currccd.Month71;
      ccdRecordholder.M72__c = currccd.Month72;
      ccdRecordholder.M73__c = currccd.Month73;
      ccdRecordholder.M74__c = currccd.Month74;
      ccdRecordholder.M75__c = currccd.Month75;
      ccdRecordholder.M76__c = currccd.Month76;
      ccdRecordholder.M77__c = currccd.Month77;
      ccdRecordholder.M78__c = currccd.Month78;
      ccdRecordholder.M79__c = currccd.Month79;
      ccdRecordholder.M80__c = currccd.Month80;
      ccdRecordholder.M81__c = currccd.Month81;
      ccdRecordholder.M82__c = currccd.Month82;
      ccdRecordholder.M83__c = currccd.Month83;
      ccdRecordholder.M84__c = currccd.Month84;
      ccdRecordholder.M85__c = currccd.Month85;
      ccdRecordholder.M86__c = currccd.Month86;
      ccdRecordholder.M87__c = currccd.Month87;
      ccdRecordholder.M88__c = currccd.Month88;
      ccdRecordholder.M89__c = currccd.Month89;
      ccdRecordholder.M90__c = currccd.Month90;
      ccdRecordholder.M91__c = currccd.Month91;
      ccdRecordholder.M92__c = currccd.Month92;
      ccdRecordholder.M93__c = currccd.Month93;
      ccdRecordholder.M94__c = currccd.Month94;
      ccdRecordholder.M95__c = currccd.Month95;
      ccdRecordholder.M96__c = currccd.Month96;
      ccdRecordholder.M97__c = currccd.Month97;
      ccdRecordholder.M98__c = currccd.Month98;
      ccdRecordholder.M99__c = currccd.Month99;
      ccdRecordholder.M100__c = currccd.Month100;
      ccdRecordholder.M101__c = currccd.Month101;
      ccdRecordholder.M102__c = currccd.Month102;
      ccdRecordholder.M103__c = currccd.Month103;
      ccdRecordholder.M104__c = currccd.Month104;
      ccdRecordholder.M105__c = currccd.Month105;
      ccdRecordholder.M106__c = currccd.Month106;
      ccdRecordholder.M107__c = currccd.Month107;
      ccdRecordholder.M108__c = currccd.Month108;
      ccdRecordholder.M109__c = currccd.Month109;
      ccdRecordholder.M110__c = currccd.Month110;
      ccdRecordholder.M111__c = currccd.Month111;
      ccdRecordholder.M112__c = currccd.Month112;
      ccdRecordholder.M113__c = currccd.Month113;
      ccdRecordholder.M114__c = currccd.Month114;
      ccdRecordholder.M115__c = currccd.Month115;
      ccdRecordholder.M116__c = currccd.Month116;
      ccdRecordholder.M117__c = currccd.Month117;     
      ccdRecordholder.M118__c = currccd.Month118;
      ccdRecordholder.M119__c = currccd.Month119;
      ccdRecordholder.M120__c = currccd.Month120;         
      ccdRecordholder.Mob_Category__c = currccd.MobCategory;
      ccdRecordholder.Mob_Sub_Category__c = currccd.MobSubCategory;
      ccdRecordholder.Run_Type__c = currccd.RunTypeCd;
      ccdRecordholder.Run_Yr1__c = currccd.RunYr1;    
      ccdRecordholder.Run_Yr2__c = currccd.RunYr2;    
      ccdRecordholder.Run_Yr3__c = currccd.RunYr3;    
      ccdRecordholder.Run_Yr4__c = currccd.RunYr4;    
      ccdRecordholder.Run_Yr5__c = currccd.RunYr5;    
      ccdRecordholder.Run_Yr6__c = currccd.RunYr6;    
      ccdRecordholder.Run_Yr7__c = currccd.RunYr7;    
      ccdRecordholder.Run_Yr8__c = currccd.RunYr8;    
      ccdRecordholder.Run_Yr9__c = currccd.RunYr9;    
      ccdRecordholder.Run_Yr10__c = currccd.RunYr10;  
      ccdRecordholder.Mob_Totals__c = currccd.MobTotals;
      ccdRecordholder.Cost_Type__c = currccd.CostTypeCd;
      ccdRecordholder.costing_request__c = costrecordid;
      ccdRecordholder.Service_Component_Dev__c=currccd.ServiceComponent;
      ccdRecordholder.Load_Type_Dev__c = currccd.LoadTypeCd;
      ccdRecordholder.Phases__c = currccd.Phase;
      ccdRecordholder.Column7__c = currccd.Column7;
      ccdRecordholder.Column8__c = currccd.Column8;
      ccdRecordholder.Column9__c = currccd.Column9;
      ccdRecordholder.Column10__c = currccd.Column10;
      ccdRecordholder.Column11__c = currccd.Column11;
      ccdRecordholder.Column12__c = currccd.Column12;
      ccdRecordholder.Column13__c = currccd.Column13;
      ccdRecordholder.Column14__c = currccd.Column14;     
      ccdRecordholder.Column15__c = currccd.Column15;
      ccdRecordholder.Column16__c = currccd.Column16;
      ccdRecordholder.Column17__c = currccd.Column17;
      ccdRecordholder.DCNType__c = currccd.DCNType;
      ccdRecordholder.Transformation_Totals__c  = currccd.TransformationTotals;
      // is transient will be true for all newly inserted records
      ccdRecordholder.Is_Transient__c = true;
      //mapping look ups!!
      if(currccd.CareerTrackNm !=null && careerT.get(currccd.CareerTrackNm.toUppercase()) != null){
        ccdRecordholder.CareerTrack__c = careerT.get(currccd.CareerTrackNm.toUppercase());
      }
      // system.debug('country in other cost-->'+currccd.CountryNm.toUppercase());
      if(currccd.CountryNm != null && countryMap.get(currccd.CountryNm.toUppercase()) != null){
        ccdRecordholder.Country__c = countryMap.get(currccd.CountryNm.toUppercase());
      }
      if(currccd.LoadTypeCd != null && loadTypeMap.get(currccd.LoadTypeCd.toUppercase()) != null){
        ccdRecordholder.LoadType__c = loadTypeMap.get(currccd.LoadTypeCd.toUppercase());
      }
      if(currccd.RateTypeCd != null && rateMap.get(currccd.RateTypeCd.toUppercase()) != null){
        ccdRecordholder.RateType__c = rateMap.get(currccd.RateTypeCd.toUppercase());
      }
       ccdRecordholder.Location_typeName__c = currccd.LocationTypeName;
       ccdRecordholder.Location_typeCode__c = string.valueof(currccd.LocationTypeCode);
      if(currccd.LocationTypeCode != 0 && currccd.LocationTypeCode != null){
       
        if(currccd.LocationTypeName !=null && resourceGrpMap.get(currccd.LocationTypeName.toUppercase()) != null){
          ccdRecordholder.ResourceGroup__c = resourceGrpMap.get(currccd.LocationTypeName.toUppercase());
        }
      }
      if(currccd.EconomicProfileNm !=null && economicProfileMap.get(currccd.EconomicProfileNm.toUppercase()) != null){
        ccdRecordholder.EconomicProfile__c = economicProfileMap.get(currccd.EconomicProfileNm.toUppercase());
      }
      
      //mapping service
      ccdRecordholder.Service_Dev__c = currccd.ServiceOfferingNm;
      ccdRecordholder.Offering_Dev__c = currccd.SubServiceOfferingNm;
      system.debug('other cost delivery location'+currccd.DCNLocation);
      if(currccd.DCNLocation.contains(SWBBPOSEIntegrationConstants.Zero)){
        ccdRecordholder.Delivery_Location_Dev__c=SWBBPOSEIntegrationConstants.emptystring;
      }
      else{
        ccdRecordholder.Delivery_Location_Dev__c=currccd.DCNLocation;              
      }
     if(solScopeMap.get(currccd.SubServiceOfferingNm.toUppercase().trim()) != null){
         system.debug('ccd scope matching');
          ccdRecordholder.Sub_Service_Group__c = solScopeMap.get(currccd.SubServiceOfferingNm.toUppercase().trim()).id;
          solution_Scope__C scope = solScopeMap.get(currccd.SubServiceOfferingNm.toUppercase().trim());
            for(service__c ser:scope.services__r){
              if(ser.services__r.name.equalsignorecase(currccd.ServiceOfferingNm.toUppercase().trim())){
                  system.debug('ccd service matching');
                  ccdRecordholder.Service__c = ser.id;
              }
            }
          if(ccdRecordholder.Service__c==null){
              system.debug('ccd service not matching'+currccd.ServiceOfferingNm);
              if(syncstatus.error_io__c==null || syncstatus.error_io__c==SWBBPOSEIntegrationConstants.emptystring){
                   syncstatus.error_io__c = SWBBPOSEIntegrationConstants.InvalidOffering+currccd.ServiceOfferingNm+
                                            SWBBPOSEIntegrationConstants.offering+currccd.SubServiceOfferingNm;
                 }
                  if(syncstatus.Chunk_Status_Sent__c !=null){
                    syncstatus.Chunk_Status_Sent__c += SWBBPOSEIntegrationConstants.FALSE_STR;
                }
                else{
                    syncstatus.Chunk_Status_Sent__c = SWBBPOSEIntegrationConstants.FALSE_STR;
                }
                update syncstatus;
              return responseFunction(false);
          }
      }
      else{
          if(syncstatus.error_io__c==null || syncstatus.error_io__c==SWBBPOSEIntegrationConstants.emptystring){
             syncstatus.error_io__c = SWBBPOSEIntegrationConstants.InvalidOffering+currccd.ServiceOfferingNm+
                                      SWBBPOSEIntegrationConstants.offering+currccd.SubServiceOfferingNm;
          }
          if(syncstatus.Chunk_Status_Sent__c !=null){
             syncstatus.Chunk_Status_Sent__c += SWBBPOSEIntegrationConstants.FALSE_STR;
          }
          else{
             syncstatus.Chunk_Status_Sent__c = SWBBPOSEIntegrationConstants.FALSE_STR;
          }
           update syncstatus;
          return responseFunction(false);
      }
      ccdRecordholder.Country_Dev__c=currccd.CountryNm;
      if(serviceMap.get(ccdRecordholder.Sub_Service_Group__c) !=null){
          //for(Service__C ser : serviceMap.get(ccdRecordholder.Service__c)){
            for(opportunity_delivery_location__c oppdel : deliveryLocationMap.get(ccdRecordholder.Service__c)){
                 /*if(oppdel.Delivery_Location_Text__c.equalsignoreCase(currccd.DCNLocation.toUppercase().trim())){
                     ccdRecordholder.Opportunity_Delivery_Location__c = oppdel.id;
                 } */
                 if(oppdel.Delivery_Location_Text__c!=null && oppdel.Delivery_Location_Text__c.containsIgnorecase(ccdRecordholder.Country_Dev__c) && 
                    oppdel.Delivery_Location_Text__c.containsIgnorecase(SWBBPOSEIntegrationConstants.IS)){
                    ccdRecordholder.Opportunity_Delivery_Location__c = oppdel.id;
                 }
             }
             for(Service_Components__c serComp : solutionCompMap.get(ccdRecordholder.Service__c)){
                  if(serComp.Services_Component_Master__r.name.equalsignoreCase(currccd.ServiceComponent.toUppercase().trim())){
                     ccdRecordholder.Service_Component__c = serComp.id;
                 } 
             }
         // }
      }
      ccd_listtosave.add(ccdRecordholder);
      syncdata.CCData.remove(0);
    }
    Integer c = 0;
    while(c<=100){
      c = Math.Round(Math.Random()*200);
    }
    system.debug('ccd_listtosave IO---------------------------------------------------------->'+ccd_listtosave.size());
    system.debug('ccd_listtosave Result---------------------------------------------------------->'+ccd_listtosave);
     // if(ccd_listtosave.size() >c && ccd_listtosave.size() <= 200){
      try{
        UtilConstants.allowactivation= utilconstants.allowstatusupdation = true;
            insert ccd_listtosave;
            ccd_listtosave.clear();
      }
      catch(Exception ex){
        ExceptionClass.logException(SWBBPOSEIntegrationConstants.IOHandleRestRequestAndSendResponse,UtilConstants.syncData,ex,UtilConstants.SWB,UtilConstants.BPOSE);
          if(syncstatus.error_io__c==null || syncstatus.error_io__c==SWBBPOSEIntegrationConstants.emptystring){
            syncstatus.error_io__c = ex.getmessage();
          }
          update syncstatus;
          return responseFunction(false);
      }
   // }
/*****************************Mapping of CCD logic ends here*****************************************************/

/*********************** Volume Mapping Starts Here ************************************************************/
    while(SyncData.VolumeData.size() >=1){
      SyncDataRequest.VolumeData currvolume = syncdata.VolumeData[0];
      if(rowcounts.Volume_Count_Dev__c ==null ){
        rowcounts.Volume_Count_Dev__c = 0;
      }
      rowcounts.Volume_Count_Dev__c = rowcounts.Volume_Count_Dev__c+1;
      volumeRecordholder =new Volume_Detail__c();
      volumeRecordholder.Opportunity__c=syncdata.Opportunityid;
      volumeRecordholder.cost__c = costrecordid; 
      volumeRecordholder.Service_Group__c =syncdata.ServiceGroup;
      volumeRecordholder.name=currvolume.Description;
      volumeRecordholder.Phase__c =currvolume.Phase;
      volumeRecordholder.M1__c = currvolume.Month1;
      volumeRecordholder.M2__c = currvolume.Month2;
      volumeRecordholder.M3__c = currvolume.Month3;
      volumeRecordholder.M4__c = currvolume.Month4;
      volumeRecordholder.M5__c = currvolume.Month5;
      volumeRecordholder.M6__c = currvolume.Month6;
      volumeRecordholder.M7__c = currvolume.Month7;
      volumeRecordholder.M8__c = currvolume.Month8;
      volumeRecordholder.M9__c = currvolume.Month9;
      volumeRecordholder.M10__c = currvolume.Month10;
      volumeRecordholder.M11__c = currvolume.Month11;
      volumeRecordholder.M12__c = currvolume.Month12;
      volumeRecordholder.M13__c = currvolume.Month13;
      volumeRecordholder.M14__c = currvolume.Month14;
      volumeRecordholder.M15__c = currvolume.Month15;
      volumeRecordholder.M16__c = currvolume.Month16;
      volumeRecordholder.M17__c = currvolume.Month17;
      volumeRecordholder.M18__c = currvolume.Month18;
      volumeRecordholder.M19__c = currvolume.Month19;
      volumeRecordholder.M20__c = currvolume.Month20;
      volumeRecordholder.M21__c = currvolume.Month21;
      volumeRecordholder.M22__c = currvolume.Month22;
      volumeRecordholder.M23__c = currvolume.Month23;
      volumeRecordholder.M24__c = currvolume.Month24;
      volumeRecordholder.M25__c = currvolume.Month25;
      volumeRecordholder.M26__c = currvolume.Month26;
      volumeRecordholder.M27__c = currvolume.Month27;
      volumeRecordholder.M28__c = currvolume.Month28;
      volumeRecordholder.M29__c = currvolume.Month29;
      volumeRecordholder.M30__c = currvolume.Month30;
      volumeRecordholder.M31__c = currvolume.Month31;
      volumeRecordholder.M32__c = currvolume.Month32;
      volumeRecordholder.M33__c = currvolume.Month33;
      volumeRecordholder.M34__c = currvolume.Month34;
      volumeRecordholder.M35__c = currvolume.Month35;
      volumeRecordholder.M36__c = currvolume.Month36;
      volumeRecordholder.M37__c = currvolume.Month37;
      volumeRecordholder.M38__c = currvolume.Month38;
      volumeRecordholder.M39__c = currvolume.Month39;
      volumeRecordholder.M40__c = currvolume.Month40;
      volumeRecordholder.M41__c = currvolume.Month41;
      volumeRecordholder.M42__c = currvolume.Month42;
      volumeRecordholder.M43__c = currvolume.Month43;
      volumeRecordholder.M44__c = currvolume.Month44;
      volumeRecordholder.M45__c = currvolume.Month45;
      volumeRecordholder.M46__c = currvolume.Month46;
      volumeRecordholder.M47__c = currvolume.Month47;
      volumeRecordholder.M48__c = currvolume.Month48;
      volumeRecordholder.M49__c = currvolume.Month49;
      volumeRecordholder.M50__c = currvolume.Month50;
      volumeRecordholder.M51__c = currvolume.Month51;
      volumeRecordholder.M52__c = currvolume.Month52;
      volumeRecordholder.M53__c = currvolume.Month53;
      volumeRecordholder.M54__c = currvolume.Month54;
      volumeRecordholder.M55__c = currvolume.Month55;
      volumeRecordholder.M56__c = currvolume.Month56;
      volumeRecordholder.M57__c = currvolume.Month57;
      volumeRecordholder.M58__c = currvolume.Month58;
      volumeRecordholder.M59__c = currvolume.Month59;
      volumeRecordholder.M60__c = currvolume.Month60;
      volumeRecordholder.M61__c = currvolume.Month61;
      volumeRecordholder.M62__c = currvolume.Month62;
      volumeRecordholder.M63__c = currvolume.Month63;
      volumeRecordholder.M64__c = currvolume.Month64;
      volumeRecordholder.M65__c = currvolume.Month65;
      volumeRecordholder.M66__c = currvolume.Month66;
      volumeRecordholder.M67__c = currvolume.Month67;
      volumeRecordholder.M68__c = currvolume.Month68;
      volumeRecordholder.M69__c = currvolume.Month69;
      volumeRecordholder.M70__c = currvolume.Month70;
      volumeRecordholder.M71__c = currvolume.Month71;
      volumeRecordholder.M72__c = currvolume.Month72;
      volumeRecordholder.M73__c = currvolume.Month73;
      volumeRecordholder.M74__c = currvolume.Month74;
      volumeRecordholder.M75__c = currvolume.Month75;
      volumeRecordholder.M76__c = currvolume.Month76;
      volumeRecordholder.M77__c = currvolume.Month77;
      volumeRecordholder.M78__c = currvolume.Month78;
      volumeRecordholder.M79__c = currvolume.Month79;
      volumeRecordholder.M80__c = currvolume.Month80;
      volumeRecordholder.M81__c = currvolume.Month81;
      volumeRecordholder.M82__c = currvolume.Month82;
      volumeRecordholder.M83__c = currvolume.Month83;
      volumeRecordholder.M84__c = currvolume.Month84;
      volumeRecordholder.M85__c = currvolume.Month85;
      volumeRecordholder.M86__c = currvolume.Month86;
      volumeRecordholder.M87__c = currvolume.Month87;
      volumeRecordholder.M88__c = currvolume.Month88;
      volumeRecordholder.M89__c = currvolume.Month89;
      volumeRecordholder.M90__c = currvolume.Month90;
      volumeRecordholder.M91__c = currvolume.Month91;
      volumeRecordholder.M92__c = currvolume.Month92;
      volumeRecordholder.M93__c = currvolume.Month93;
      volumeRecordholder.M94__c = currvolume.Month94;
      volumeRecordholder.M95__c = currvolume.Month95;
      volumeRecordholder.M96__c = currvolume.Month96;
      volumeRecordholder.M97__c = currvolume.Month97;
      volumeRecordholder.M98__c = currvolume.Month98;
      volumeRecordholder.M99__c = currvolume.Month99;
      volumeRecordholder.M100__c = currvolume.Month100;
      volumeRecordholder.M101__c = currvolume.Month101;
      volumeRecordholder.M102__c = currvolume.Month102;
      volumeRecordholder.M103__c = currvolume.Month103;
      volumeRecordholder.M104__c = currvolume.Month104;
      volumeRecordholder.M105__c = currvolume.Month105;
      volumeRecordholder.M106__c = currvolume.Month106;
      volumeRecordholder.M107__c = currvolume.Month107;
      volumeRecordholder.M108__c = currvolume.Month108;
      volumeRecordholder.M109__c = currvolume.Month109;
      volumeRecordholder.M110__c = currvolume.Month110;
      volumeRecordholder.M111__c = currvolume.Month111;
      volumeRecordholder.M112__c = currvolume.Month112;
      volumeRecordholder.M113__c = currvolume.Month113;
      volumeRecordholder.M114__c = currvolume.Month114;
      volumeRecordholder.M115__c = currvolume.Month115;
      volumeRecordholder.M116__c = currvolume.Month116;
      volumeRecordholder.M117__c = currvolume.Month117;     
      volumeRecordholder.M118__c = currvolume.Month118;
      volumeRecordholder.M119__c = currvolume.Month119;
      volumeRecordholder.M120__c = currvolume.Month120;  
      volumeRecordholder.Service_Component_Dev__c=currvolume.ServiceComponent;
      volumeRecordholder.Is_Transient__c=true;
      if(solScopeMap.get(currvolume.SubServiceGroup.toUppercase().trim()) != null){
          volumeRecordholder.Sub_Service_Group__c = solScopeMap.get(currvolume.SubServiceGroup.toUppercase().trim()).id;
          solution_Scope__C scope = solScopeMap.get(currvolume.SubServiceGroup.toUppercase().trim());
          system.debug('scope in volume'+scope);
            for(service__c ser:scope.services__r){
              if(ser.services__r.name.equalsignorecase(currvolume.Service.toUppercase().trim())){
                  volumeRecordholder.Service__c = ser.id;
              }
            }
          if(volumeRecordholder.Service__c==null){
              if(syncstatus.error_io__c==null || syncstatus.error_io__c==SWBBPOSEIntegrationConstants.emptystring){
                syncstatus.error_io__c = SWBBPOSEIntegrationConstants.InvalidOffering+currvolume.Service+
                                         SWBBPOSEIntegrationConstants.offering+currvolume.SubServiceGroup;
              }
              if(syncstatus.Chunk_Status_Sent__c !=null){
                syncstatus.Chunk_Status_Sent__c += SWBBPOSEIntegrationConstants.FALSE_STR;
              }
              else{
               syncstatus.Chunk_Status_Sent__c = SWBBPOSEIntegrationConstants.FALSE_STR;
              }
              update syncstatus;
              return responseFunction(false);
          }
      }
      else{
          if(syncstatus.error_io__c==null || syncstatus.error_io__c==SWBBPOSEIntegrationConstants.emptystring){
            syncstatus.error_io__c = SWBBPOSEIntegrationConstants.InvalidOffering+currvolume.Service+
                                     SWBBPOSEIntegrationConstants.offering+currvolume.SubServiceGroup;
          }
          if(syncstatus.Chunk_Status_Sent__c !=null){
            syncstatus.Chunk_Status_Sent__c += SWBBPOSEIntegrationConstants.FALSE_STR;
          }
          else{
           syncstatus.Chunk_Status_Sent__c = SWBBPOSEIntegrationConstants.FALSE_STR;
          }
          update syncstatus;
          return responseFunction(false);
      }
      if(serviceMap.get(volumeRecordholder.Sub_Service_Group__c) !=null){
             for(Service_Components__c serComp : solutionCompMap.get(volumeRecordholder.Service__c)){
                 system.debug('-------------------------solution component master--------------------'+serComp.Services_Component_Master__r.name);
                  if(serComp.Services_Component_Master__r.name.equalsignoreCase(currvolume.ServiceComponent.toUppercase().trim())){
                     system.debug('-------------------------inside mapping solution component--------------------');
                     volumeRecordholder.Service_Component__c = serComp.id;
                 } 
             }
      }
      volume_listtosave.add(volumeRecordholder);
      SyncData.VolumeData.remove(0);
    }
    Integer v = 0;
    while(v<=100){
      v = Math.Round(Math.Random()*200);
    }
      system.debug('volume_listtosave IO---------------------------------------------------------->'+volume_listtosave.size());
      system.debug('volume_listtosave Result---------------------------------------------------------->'+volume_listtosave);
      try{
        UtilConstants.allowactivation= utilconstants.allowstatusupdation = true;
            insert volume_listtosave;
            volume_listtosave.clear();
      }
      catch(Exception ex){
        ExceptionClass.logException(SWBBPOSEIntegrationConstants.IOHandleRestRequestAndSendResponse,UtilConstants.syncData,ex,UtilConstants.SWB,UtilConstants.BPOSE);
          if(syncstatus.error_io__c==null || syncstatus.error_io__c==SWBBPOSEIntegrationConstants.emptystring){
            syncstatus.error_io__c = ex.getmessage();
          }
          update syncstatus;
          return responseFunction(false);
      }
      update rowcounts;
/********************** Volume Mapping Ends Here **************************************************************/    
    return responseFunction(True);
 }
 
 /**
     * @description       This method is used for generating ILDs. 
     * @param             deserialized JSON of type SendBDLDataRequest class
     * @return            serialized JSON that has true/false as status
     * @throws            NA
    */  
    public string sendBDData(SendBDLDataRequest sendBDLData){
        String userQueryFilter=sendBDLData.LstBDLGeneratedUserNm+SWBBPOSEIntegrationConstants.likeparameter ;
        SendBDLDataRequest.SendBDLDataResponse response =new SendBDLDataRequest.SendBDLDataResponse();
        try{
            Costing_Request__c costRequest=[SELECT Id, Last_BDL_Generated_Version__c,
                                                         Last_IDL_Generated_Scenario__c, Last_IDL_Generated_User__c, 
                                                         IDL_Generated_UTC_Date__c,Last_IDL_Generated_Version__c FROM Costing_Request__c where 
                                                         Opportunity__c=:sendBDLData.opportunityid limit 1];
            User_Master__c user = [select id from User_Master__c where email__c LIKE:userQueryFilter AND active__c=true limit 1];
            costRequest.Last_IDL_Generated_Version__c=sendBDLData.LstBDLGeneratedVrNm;
            costRequest.Last_IDL_Generated_Scenario__c=sendBDLData.LstBDLGeneratedScNm;
            costRequest.Last_IDL_Generated_User__c=sendBDLData.LstBDLGeneratedUserNm;
            Date myDate = date.newinstance(1900, 1, 1);
            Date myoriginalDate = date.newinstance
                        (sendBDLData.BDLGeneratedUTCDateTime.year(), sendBDLData.BDLGeneratedUTCDateTime.month(), sendBDLData.BDLGeneratedUTCDateTime.day());
            if(myoriginalDate != myDate){
                costRequest.IDL_Generated_UTC_Date__c=System.now();
            }
            else{
                costRequest.IDL_Generated_UTC_Date__c=null;
            }
            costRequest.Is_IDL_Updated_Dev__c=true;
            database.update (costRequest,true); 
            response.status=true;
        }
        catch(Exception e){
            ExceptionClass.logException(SWBBPOSEIntegrationConstants.IOHandleRestRequestAndSendResponse,UtilConstants.sendBDData,e,UtilConstants.SWB,UtilConstants.BPOSE);
            response.status=false;
        }
        
        return(system.JSON.serialize(response));
    }
    
    /**
     * @description       This method is used to delete old fte,other cost,volume  and payroll data when is trans is true and update new data.
     * @param             id oppid,integer rowcount,FinalizeTransaction trans,cost record,string serviceGroup
     * @return            serialized JSON that has true/false as status
     * @throws            NA
    */  
    public integer deleteOldAndUpdateNewData(id oppid,integer rowcount,FinalizeTransaction trans,costing_request__c costRec,string serviceGroup){
        system.debug('Opportunity Ids--------------------------------------'+oppid+'-------'+serviceGroup);
        id costid = costRec.id;
        set<id> NOCDids = new set<id>();
        set<id> Nfteids = new set<id>();
        set<id> OOCDids = new set<id>();
        set<id> Ofteids = new set<id>();
        set<id> NVolids = new set<id>();
        set<id> NPayrollids = new set<id>();
        set<id> OVolids = new set<id>();
        set<id> OPayrollids = new set<id>();
        set<id> oldcrossdeal= new set<id>();
        set<id> newcrossdeal= new set<id>();
        integer  response;
        sync_Status__c syncstatus = new sync_Status__C();
        list<FTE_Details__c> ftedata= new List<FTE_Details__c>();
        list<Other_Cost_Details__c> ccddata= new List<Other_Cost_Details__c>();
        list<Payroll__c> payrolldata= new List<Payroll__c>();
        list<Volume_Detail__c> volumedata= new List<Volume_Detail__c>();
        list<FTE_Details__c> ftedata_new= new List<FTE_Details__c>();
        list<Other_Cost_Details__c> ccddata_new= new List<Other_Cost_Details__c>();
        list<Payroll__c> payrolldata_new= new List<Payroll__c>();
        list<Volume_Detail__c> volumedata_new= new List<Volume_Detail__c>();
        list<Cross_Deal__c> crossdeal_old_data= new List<Cross_Deal__c>();
        list<Cross_Deal__c> crossdeal_new_data= new List<Cross_Deal__c>();
        map<string,string> costdataMap = new map<string,string>();
        boolean issuccess = false;
        Opportunity opp = [select id,Is_Synced__c,
                            (Select id from FTE_Details__r where is_transient__c = false and 
                            (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC)),
                            (select id from Other_Cost_Details__r where is_transient__c = false and 
                            (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC)),
                            (select id from Volume_Details__r where is_transient__c = false and 
                            (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC)),
                            (select id from Cross_Deals_Opportunity__r where Is_Transient__c =false)
                            from Opportunity where id=:oppid LIMIT 1];      
        syncstatus = [select id,error_io__c,synced_Scenario__c from sync_Status__C where opportunity__c=:oppid LIMIT 1];
        ftedata.addall(opp.FTE_Details__r);
        for(Fte_details__c fte : ftedata){
            OFteids.add(fte.id);                         
        }
        ftedata.clear();
        CCDData.addall(opp.Other_Cost_Details__r);
        for(Other_Cost_Details__c ocd :CCDData){
            Oocdids.add(ocd.id);
        }  
        CCDdata.clear();
        volumedata.addall(opp.Volume_Details__r);
        for(Volume_Detail__c volume : volumedata){
            OVolids.add(volume.id);
        }
        volumedata.clear();
        crossdeal_old_data.addall(opp.Cross_Deals_Opportunity__r);
        for(Cross_Deal__c crossdealRec:crossdeal_old_data){
            oldcrossdeal.add(crossdealRec.id);
        }
        crossdeal_old_data.clear();
        opp = new Opportunity();
        Opportunity oppquery = [select id,Is_Synced__c,
                                (Select id from FTE_Details__r where is_transient__c = true and 
                                (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC)),
                                (select id from Other_Cost_Details__r where is_transient__c = true and 
                                (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC)),
                                (select id from Volume_Details__r where is_transient__c = true and 
                                (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC)),
                                (select id from Cross_Deals_Opportunity__r where Is_Transient__c =true)
                                 from Opportunity where id=:oppid LIMIT 1];
        system.debug('After opportunity query-------------------------------------------------------'+oppquery);
        ftedata_new.addall(oppquery.FTE_Details__r);
        
        for(Fte_details__c fte : ftedata_new){
            Nfteids.add(fte.id);                         
        }
        ccddata_new.addall(oppquery.Other_Cost_Details__r);
        for(Other_Cost_Details__c ocd :ccddata_new){
            NOCDids.add(ocd.id);
        }
        volumedata_new.addall(oppquery.Volume_Details__r);
        for(Volume_Detail__c volume : volumedata_new){
            NVolids.add(volume.id);
        }
        crossdeal_new_data.addall(oppquery.Cross_Deals_Opportunity__r);
        for(Cross_Deal__c crossdealRec:crossdeal_new_data){
            newcrossdeal.add(crossdealRec.id);
        }
        Costing_Request__c costingRecord = new Costing_Request__c(id=costid);
        costingRecord.FTE_CCD_Count_BPOSE_sent__c = rowcount;
        integer swbrowcount=ftedata_new.size()+ccddata_new.size()+volumedata_new.size()+newcrossdeal.size();
        try{
            system.debug('Total count of records in SWB system----------------->'+swbrowcount);
            system.debug('Count Received from BPOSE System----------------->'+rowcount);
            system.debug('fte list sizeeeeeeee'+ftedata_new.size());
            system.debug('ocd list sizeeeeeeee'+ccddata_new.size());
            system.debug('volume list sizeeeeeeee'+volumedata_new.size());
            system.debug('cross deal list sizeeeeeeee'+newcrossdeal.size());
            if(swbrowcount == rowcount){
                    costdataMap.put(SWBBPOSEIntegrationConstants.id,costid);
                    costdataMap.put(SWBBPOSEIntegrationConstants.oppfield ,oppid);
                    costdataMap.put(SWBBPOSEIntegrationConstants.initialgolive ,string.valueof(trans.ScenarioGoLiveDate));
                    costdataMap.put(SWBBPOSEIntegrationConstants.contractstart,string.valueof(trans.ScenarioContractStartDate));
                    costdataMap.put(SWBBPOSEIntegrationConstants.contractend ,string.valueof(trans.ScenarioContractEndDate));
                    costdataMap.put(SWBBPOSEIntegrationConstants.ssmversionIO ,trans.SSMVersion);
                    costdataMap.put(SWBBPOSEIntegrationConstants.VersionIO,trans.VersionNm);
                    costdataMap.put(SWBBPOSEIntegrationConstants.syncedScenarioNameIO,trans.ScenarioNm);
                    costdataMap.put(SWBBPOSEIntegrationConstants.mrdbVersionIo,trans.MRDBVersion);
                    costdataMap.put(SWBBPOSEIntegrationConstants.mrdbLastRefreshDateIO ,string.valueof(trans.MRDBDate));
                    costdataMap.put(SWBBPOSEIntegrationConstants.HasMasterDataBeenCustomizedForDealIO ,string.valueof(trans.HasMasterDataBeenCustomizedForDeal));
                    costdataMap.put(SWBBPOSEIntegrationConstants.lastsyncedupbyIO,trans.enterpriseid);
                    costdataMap.put(SWBBPOSEIntegrationConstants.versionidio,trans.VersionID);
                    costdataMap.put(SWBBPOSEIntegrationConstants.prevstatfield ,costRec.In_Progress_PrevState__c);
                    issuccess = true;
                    costingRecord.In_Sync_IO__c = false;
                    costingRecord.Calculation_IO__c = true;
                    costingRecord.Email_Dev_io__c=trans.enterpriseid+SWBBPOSEIntegrationConstants.attherateemail;
                    costingRecord.Time_Stamp_IO__c= System.now();
                    update costingRecord;
                    ftedata_new.clear();
                    ccddata_new.clear();
                    payrolldata_new.clear();
                    volumedata_new.clear();
                    response = 1;
            }
            else{
                    costingRecord.In_Sync_IO__c = false;
                    costingRecord.Sync_Failed_At_IO__c = SWBBPOSEIntegrationConstants.sync;
                    costingRecord.Calculation_IO__c = false;
                    costingRecord.Data_Cleaning_dev_IO__c=true;
                    costingRecord.Email_Dev_IO__c=trans.enterpriseid+SWBBPOSEIntegrationConstants.attherateemail ;
                    costingRecord.in_progress__c = CostRec.In_Progress_PrevState__c;
                    update costingRecord;
                    system.debug('row count didn\'t match');
                    rollback_data(trans,rowcount,costRec);
                    issuccess = false;
                    response = 0;
                    syncstatus.error_io__c  = SWBBPOSEIntegrationConstants.ERR ;
                    update syncstatus;
            }
        }
        catch(Exception e){
                ExceptionClass.logException(SWBBPOSEIntegrationConstants.IOHandleRestRequestAndSendResponse,
                        UtilConstants.deleteOldAndUpdateNewData,e,UtilConstants.SWB,UtilConstants.BPOSE);
                costingRecord.in_progress_io__c = SWBBPOSEIntegrationConstants.inprogressstatus ;
                costingRecord.In_Sync_IO__c = false;
                costingRecord.Sync_Failed_At_IO__c = SWBBPOSEIntegrationConstants.sync;
                costingRecord.Calculation_IO__c = false;
                costingRecord.Data_Cleaning_dev_IO__c=true;
                costingRecord.Email_Dev_IO__c=trans.enterpriseid+SWBBPOSEIntegrationConstants.attherateemail ;
                costingRecord.in_progress__c = CostRec.In_Progress_PrevState__c;
                update costingRecord;
                issuccess = false;
                response=0;
        }
        finally{
            if(issuccess){
                System.enqueueJob( new BenchmarkSync_IO_Queue(Nfteids,NOCDids,newcrossdeal,NVolids,OFteids,Oocdids,oldcrossdeal,OVolids,costdataMap));
            }
            else{
                 rollback_data(trans,rowcount,costRec);
            }
        }
        return response;
    }
    /**
     * @description       This method is used to delete the new fte,ccd,payroll and volume data when sync fails for io deals. 
     * @param             SyncDataRequest syncdata
     * @return            string - true-operation sucessfull; false-operation failed
     * @throws            DML Exception
     */  
    public void rollback_data(FinalizeTransaction trans,integer rowcount,costing_request__c costRec){
        id oppid = trans.opportunityid;
        id costid = costRec.id;
        list<FTE_Details__c> ftedata= new List<FTE_Details__c>();
        list<Other_Cost_Details__c> ccddata= new List<Other_Cost_Details__c>();
        list<Payroll__c> payrolldata= new List<Payroll__c>();
        list<Volume_Detail__c> volumedata= new List<Volume_Detail__c>();
        list<Cross_Deal__c> crossdeal_data= new List<Cross_Deal__c>();
        boolean updatecost=false;
        Opportunity opp = [select id,(Select id from FTE_Details__r where is_transient__c = true AND
         (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC)),
                            (select id from Other_Cost_Details__r where is_transient__c = true and
                             (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC)),
                            (select id from Payroll_Details__r where is_transient__c = true and 
                            (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC)),
                            (select id from Volume_Details__r where is_transient__c = true and
                            (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC)),
                            (select id from Cross_Deals_Opportunity__r where Is_Transient__c =true)
                            from Opportunity where id=:oppid LIMIT 1];          
        ftedata.addall(opp.FTE_Details__r);
        ccddata.addall(opp.Other_Cost_Details__r);
        payrolldata.addall(opp.Payroll_Details__r);
        volumedata.addall(opp.Volume_Details__r);
        crossdeal_data.addall(opp.Cross_Deals_Opportunity__r);
        Costing_Request__c costingRecord = new Costing_Request__c(id=costid);
        try{
            if(ftedata.size()+ccddata.size()+payrolldata.size()+volumedata.size() < 9000){
                UtilConstants.allowactivation = true; 
                database.delete(ftedata,true);
                database.delete(ccddata,true);
                database.delete(payrolldata,true);
                database.delete(volumedata,true);
                database.delete(crossdeal_data,true);
                costingRecord.Sync_Failed_At_IO__c = SWBBPOSEIntegrationConstants.emptystring;
                costingRecord.Data_Cleaning_dev_IO__c=false;
                costingRecord.in_sync_io__c = false;
                costingRecord.calculation_io__c = false;
                costingRecord.In_Progress_IO__c =SWBBPOSEIntegrationConstants.failurestatus ;
                costingRecord.in_progress__c = CostRec.In_Progress_PrevState__c;
                costingRecord.Email_Dev_IO__c=trans.enterpriseid+SWBBPOSEIntegrationConstants.attherateemail ;
                updatecost = true;
            }
            else{
                database.executebatch(new DeletehugeBatchSync(oppid,costid,SWBBPOSEIntegrationConstants.io),400);
            }
        }
        catch(Exception e){
                ExceptionClass.logException(SWBBPOSEIntegrationConstants.IOHandleRestRequestAndSendResponse,
                                UtilConstants.rollback_data,e,UtilConstants.SWB,UtilConstants.BPOSE);
                 costingRecord.Sync_Failed_At__c = SWBBPOSEIntegrationConstants.status;
                 costingRecord.Data_Cleaning_dev__c=true;
                 costingRecord.in_progress_io__c =SWBBPOSEIntegrationConstants.inprogressstatus;
                 updatecost = true;
        }
        finally{
            if(updatecost){
                    update costingRecord;
            }
        }
        
    }
    /**
     * @description       This method is used to give back response to BPOSE. 
     * @name              responseFunction
     * @return            string - true-operation sucessfull; false-operation failed
     * @throws            
     */  
    public string responseFunction(boolean bool){
        SyncDataRequest.SyncDataResponse syncresponse = new SyncDataRequest.SyncDataResponse();
        syncresponse.status = bool;
        string finalresponse = JSON.serialize(syncresponse);
        return finalresponse;
    }
}