public without sharing class HandleRestRequestAndSendResponse {
     List<ExceptionLog__c> exceptions=new list<ExceptionLog__c>();
       /*
              @methodname : syncData
              @methodDescription : This method is used to populate records in fte details object other cost detail object. 
              @return type: String true-operation sucessfull; false-operation failed
       */       
       public string syncData(SyncDataRequest syncdata){
        system.debug('CPU time In handle request response---> '+Limits.getCPUtime());
        //syncdata.ServiceGroup='BPO';
         if(syncdata.ServiceGroup.EqualsIgnoreCase(SWBBPOSEIntegrationConstants.BPO)){
             UtilConstants.IS_OPPTRIGGER_REQUIRED = false;
             system.debug('CPU time in BPO PART---> '+Limits.getCPUtime());
             system.debug('Heap consumed --0--'+limits.getHeapSize());
              list<FTE_Details__c> fte_listtosave= new List<FTE_Details__c>();
              list<FTE_Details__c> fte_listwoservice= new List<FTE_Details__c>();
              list<FTE_Details__c> fte_listwoservice2= new List<FTE_Details__c>();
              list<Other_Cost_Details__c> ccd_listtosave= new List<Other_Cost_Details__c>();
              list<Other_Cost_Details__c> ccd_listwoservice= new List<Other_Cost_Details__c>();
              costing_request__c rowcounts = new costing_request__c();
              list<Other_Cost_Details__c> ccd_listwoservice2= new List<Other_Cost_Details__c>();
              map<string,id> BillCodeMap = new map<string,id>();
              map<string,id> careerlevelMap = new map<string,id>();
              map<string,id> countryMap=new map<string,id>();
              map<string,id> deliveryLocationMap=new map<string,id>();
              map<string,id> economicProfileMap=new map<string,id>();
              map<string,id> loadTypeMap=new map<string,id>();
              map<string,id> rateMap=new map<string,id>();
              map<string,id> roleMap=new map<string,id>();
              map<string,List<Service__c>> serviceMap=new map<string,List<Service__c>>();
              list<Service__c> servicelist=new List<Service__c>();
              map<string,id> solScopeMap=new map<string,id>();
              map<string,id> solutionCompMap=new map<string,id>();
              map<string,id> resourceGrpMap=new map<string,id>();
              map<string,id> careerT=new map<string,id>();
              map<string,id>techTool=new map<string,id>();
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
              map<String,id> transactionaltechtool=new map<String,id>();
              map<String,id> transactionalCustomToolName=new map<String,id>();
              id costrecordid;              
              map<String,Offering_Master__c> offeringMasterMasterMap=new map<String,Offering_Master__c>();
              FTE_Details__c fteRecordholder;
              Other_Cost_Details__c ccdRecordholder;
              SWBBPOSEIntegrationConstants.runservTrigger = false;
              for(Offering_Master__c offmaster:[Select id,name from Offering_Master__c where active__c=true  and 
                                                Service_Group__c=: SWBBPOSEIntegrationConstants.BPO limit 500]){
                offeringMasterMasterMap.put(offmaster.name.toUpperCase(),offmaster);
              }
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
              for(Delivery_Location_Masters__c deliveryloc : masterqueries.querydeliverymasters()){
                     deliveryLocationMap.put(deliveryloc.name.toUpperCase(),deliveryloc.id);
              }
              for(EconomicProfile_Master__c eco :[select name from EconomicProfile_Master__c limit 500]){
                     economicProfileMap.put(eco.name.toUpperCase(),eco.id);
              }
              for(Load_Type_Master__c load :[select name from Load_Type_Master__c limit 500]){
                     loadTypeMap.put(load.name.toUpperCase(),load.id);
              }
              for(Rate__c rate :[select name from Rate__c]){
                     rateMap.put(rate.name.toUpperCase(),rate.id);
              }
              for(Resource_Group_Master__c resgrp:[select id, name from Resource_Group_Master__c limit 500]){
                     resourceGrpMap.put(resgrp.name.toUpperCase().trim(),resgrp.id);
              }
              for(Role_Master__c role:[select name from Role_Master__c limit 500]){
                     roleMap.put(role.name.toUpperCase(),role.id);
              }
              for(Opportunity Opp : [select id,(Select id,Offering_Master__r.name from Solution_Components__r) from Opportunity where
                                    id=:syncdata.Opportunityid limit 500]){
                for(solution_Scope__c sol : opp.Solution_Components__r){
                    solutionscopes.add(sol.Offering_Master__r.name);
                }
              }
              for(Services_Component_Master__c servicecomponentmaster :[Select id,name from Services_Component_Master__c limit 500]){
                servicecomponentmap.put(servicecomponentmaster.name.toUpperCase(),servicecomponentmaster.id);
              }
              Map<String,id> ServiceComponentTrans =new Map<String,id>();
              for(Service_Components__c component :[Select id ,Services_Component_Master__r.name,Service__c from Service_Components__c where 
              Service__r.Solutionscope__r.Opportunity__c=:syncdata.Opportunityid limit 1000 ]){
                  ServiceComponentTrans.put(component.Services_Component_Master__r.name+component.Service__c,component.id);
                  //system.debug('Service Component'+component.Services_Component_Master__r.name+component.Service__c);
              }
             /*for(String s:ServiceComponentTrans.keyset()){
              system.debug('ServiceComponentTrans'+s+'ServiceComponentTrans'+ServiceComponentTrans.get(s));
             }*/
              for(Service__c ser:[select id, services__r.name,Solutionscope__c,services__r.solution_component__c
                                                ,Solutionscope__r.Offering_Master__r.name,Solutionscope__r.Solution_Component__c,
                                                (Select id,Tech_Tool__c,Custom_Tool_Name__c from Tech_Tools__r)
                                                from Service__c where Solutionscope__r.opportunity__c=:syncdata.Opportunityid and
                                                 Solutionscope__r.service_group__c=: SWBBPOSEIntegrationConstants.BPO limit 5000]){
                     //SYSTEM.DEBUG('SERVICES------>'+SER.services__r.name);
                    //S//YSTEM.DEBUG('scopes------>'+SER.Solutionscope__r.Offering_Master__r.name);
                if(serviceMap.get(ser.services__r.Name.toUpperCase().trim()) != null){
                    list<service__c> serlist1 = serviceMap.get(ser.services__r.Name.toUpperCase().trim());
                    system.debug('Serlist1----+'+syncdata.Opportunityid+'------------------'+serlist1);
                    serlist1.add(ser);
                    serviceMap.put(ser.services__r.Name.toUpperCase().trim(), serlist1);
                }else{
                    //system.debug('first add--'+ser.services__r.Name);
                    list<service__c> serlist = new list<service__c>();
                    serlist.add(ser);
                    serviceMap.put(ser.services__r.Name.toUpperCase().trim(), serlist);  
                    //system.debug('Service map at top:');
                }
                //solScopeMap.put(ser.Solutionscope__r.Offering_Master__r.name+ser.Solutionscope__r.Solution_Component__c,ser.Solutionscope__c);
                servids.add(ser.id);
                offmasterids.add(ser.Solutionscope__r.Offering_Master__c);
             }
            /* for(string s:serviceMap.keyset()){
                system.debug('service map data '+serviceMap.get(s));
             }*/
             //logic for delivery location map
             String dellocNService=SWBBPOSEIntegrationConstants.emptystring;
             map<string,id> OpportunitydeliveryLocationMap=new map<string,id>();
             String oppidfordeloc=syncdata.Opportunityid;
            // system.debug('oppdelloc'+oppidfordeloc.substring(0,15));
             for(Opportunity_Delivery_Location__c del:[select id, Offering_Service__r.services__r.name,Offering_Service__c,Delivery_Location__c,Delivery_Location__r.name
                                                from Opportunity_Delivery_Location__c where 
                                                Offering_Service__r.Opportunity_Id_Dev__c=:oppidfordeloc.substring(0,15) limit 1000]){
                    if(del.Delivery_Location__r.name.contains(SWBBPOSEIntegrationConstants.hyphen)){
                        List<String> temp=del.Delivery_Location__r.name.split(SWBBPOSEIntegrationConstants.hyphen);
                        dellocNService=temp[1].trim()+del.Offering_Service__c;
                    }
                    else{                   
                      dellocNService=del.Delivery_Location__r.name+del.Offering_Service__c;     
                    }
                      OpportunitydeliveryLocationMap.put(dellocNService,del.id);                            
             }
             for(Tech_Tools__c tool:[select id, name,service__r.name,Service__c,Tech_Tool_Name__c,Tech_Tool__c,Custom_Tool_Name__c from Tech_Tools__c where 
                                    service__r.Solutionscope__r.opportunity__c=:syncdata.Opportunityid limit 5000]){
                 if(tool.Tech_Tool_Name__c!=null){                       
                transactionaltechtool.put(tool.Tech_Tool_Name__c.trim()+tool.Service__c,tool.id);
                }
                if(tool.tech_tool_name__c != null && tool.Tech_Tool_Name__c.equalsignorecase(SWBBPOSEIntegrationConstants.customtools)){
                    transactionalCustomToolName.put(tool.Custom_Tool_Name__c+tool.Service__c,tool.id);
                }
             }
             /*for(Tech_Tools__c customtool :[Select id,Custom_Tool_Name__c,Service__c from  Tech_Tools__c where 
                                    service__r.Solutionscope__r.opportunity__c=:syncdata.Opportunityid  and Tech_Tool_Name__c ='Custom Tools' limit 5000
                                            ]){
             }*/
              /*Costing_Request__c costingRecord = new Costing_Request__c();
                    costingRecord =[SELECT Id,In_Progress__c,In_Sync__c,Calculation__c
                                                               FROM Costing_Request__c 
                                                               where Opportunity__c=:syncdata.Opportunityid LIMIT 1];*/
            //system.debug('Heap consumed --1--'+limits.getHeapSize());                                               
             SavePoint sp = database.setSavePoint();
             system.debug('Heap consumed --2--'+limits.getHeapSize());
            // system.debug('solScopeMap**************************************************'+solScopeMap);
             //system.debug('CPU time after queries---> '+Limits.getCPUtime());
             integer cnt;
             rowcounts = [select id,CCD_Count_Dev__c,FTE_count_Dev__c,FTE_CCD_Count_BPOSE_sent__c,In_Progress_IO__c  from costing_request__c where Opportunity__c=:syncdata.opportunityid limit 1];
             costrecordid = rowcounts.id;
             sync_status__c syncstatus = [select id,Chunk_Status_Sent__c,error__c,Final_Status_Recieved__c,Final_Status_Sent__c,
                Sync_Initiated_Time__c,Last_Synced_User__c,synced_Scenario__c from sync_Status__C where opportunity__c=:syncdata.opportunityid limit 1];
              if(syncdata.isFirstChunk){ 
                  rowcounts.CCD_Count_Dev__c = 0;
                  rowcounts.FTE_count_Dev__c = 0;
                  rowcounts.In_Progress__c = SWBBPOSEIntegrationConstants.inprogressstatus;
                  rowcounts.In_Progress_PrevState__c=rowcounts.In_Progress_IO__c;
                  rowcounts.In_Progress_IO__c='4';                  
                  rowcounts.Trigger_Final_Mail__c = false;
                  rowcounts.In_Sync__c = true;
                  rowcounts.Email_Dev__c = SWBBPOSEIntegrationConstants.emptystring;
                  rowcounts.Calculation__c = false;
                  rowcounts.Sync_Initiated_Time__c = system.now();
                  syncstatus.Sync_Initiated_Time__c = system.now();
                  syncstatus.Last_Synced_User__c = SWBBPOSEIntegrationConstants.emptystring;
                  syncstatus.Chunk_Status_Sent__c= SWBBPOSEIntegrationConstants.emptystring;
                  syncstatus.error__c  =SWBBPOSEIntegrationConstants.emptystring;
                  syncstatus.synced_Scenario__c= SWBBPOSEIntegrationConstants.emptystring;
                  syncstatus.Final_Status_Recieved__c = SWBBPOSEIntegrationConstants.emptystring;
                  syncstatus.Final_Status_Sent__c= SWBBPOSEIntegrationConstants.emptystring;
                  syncstatus.calculation_failed__c = false;
                  syncstatus.Force_fully_Failed__c = false;
                  syncstatus.Sync_Status_BPO__c = 2;
                  syncstatus.Last_Synced_By__c = null;
                  update syncstatus;
                  update rowcounts;
                  rowcounts = [select id,CCD_Count_Dev__c,FTE_count_Dev__c,FTE_CCD_Count_BPOSE_sent__c,In_Progress_IO__c  from costing_request__c where Opportunity__c=:syncdata.opportunityid limit 1];
              }
              rowcounts.is_first_chunk_Dev__c = string.valueof(syncdata.isFirstChunk);
             // system.debug('Heap consumed --3--'+limits.getHeapSize());
    While(syncdata.FTEData.size() >=1){
           SyncDataRequest.FTEDataEntity currFte =  syncdata.FTEData[0];
           if(rowcounts.FTE_count_Dev__c ==null ){
            rowcounts.FTE_count_Dev__c = 0;
           }
            rowcounts.FTE_count_Dev__c = rowcounts.FTE_count_Dev__c+1;         
                     fteRecordholder =  new FTE_Details__c();
                     //System.debug('Received mobilization Date in FTE'+currFte.MobilizationStartDt);
                     //System.debug('Received Go live Date in FTE'+currFte.GoLiveDt);
                     //fteRecordholder.benchmark__c=benchmarks.id;
                     fteRecordholder.Opportunity__c = syncdata.Opportunityid;
                     fteRecordholder.Service_Group__c =UtilConstants.BPO;
                     Date myDate = date.newinstance(1900,01,01);
                     //system.debug('SWB Date'+myDate);
                     Date myoriginalDate = date.parse(currFte.MobilizationStartDt);
                     //system.debug('BPOSE Date'+myoriginalDate);
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
                     fteRecordholder.Recruiting_Cost__c = Decimal.valueof(currFte.RecruitingCostPCT)*100;
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
                     /*fteRecordholder.Column2__c = currFte.column2;
                     fteRecordholder.Column3__c = currFte.column3;*/
                     fteRecordholder.Column4__c = currFte.LanguagePremium;
                     //fteRecordholder.Column5__c = currFte.;
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
                     fteRecordholder.GroupName__c=currFte.GroupName;
                     system.debug('loaded cost rate'+currFte.LoadedCostRate);
                     fteRecordholder.TotalLoads__c = currFte.LoadedCostRate;     
                     fteRecordholder.HoursAppliedToContract__c = currFte.HoursAppliedToContract;     
                     fteRecordholder.CostRate__c = currFte.CostRate;  
                     //fteRecordholder.Phase__c=  currFte.Phase;
                     fteRecordholder.FTEMobTotals__c = currFte.FTEMobTotals;
                     system.debug('FTE mob totals value --------> '+currFte.FTEMobTotals);
                     // is transient will be true for all newly inserted records
                     fteRecordholder.Is_Transient__c = true;
                     //from here relationship fields are mapped
                     //system.debug('country received------>'+currFte.CountryNm.toUppercase());
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
                     //if(solScopeMap.get(currFte.SubServiceOfferingNm) != null){
                           //fteRecordholder.Sub_Service_Group__c = solScopeMap.get(currFte.SubServiceOfferingNm);
                     //}
                     if(currFte.EconomicProfileNm!=null && economicProfileMap.get(currFte.EconomicProfileNm.toUppercase()) != null){
                           fteRecordholder.Economic_Profile__c = economicProfileMap.get(currFte.EconomicProfileNm.toUppercase());
                     }
                     /*if(currFte.GroupName!=null && roleMap.get(currFte.role.toUppercase()) != null){
                           fteRecordholder.Role_Master__c = roleMap.get(currFte.GroupName.toUppercase());
                     }*/
                     //if(solutionCompMap.get(currFte.ResourceLevelNm.toUppercase()) != null){
                     //     fteRecordholder.Career_Level__c = BillCodeMap.get(currFte.ResourceLevelNm.toUppercase());
                     //}
                     fteRecordholder.Location_typeName__c = currFte.LocationTypeName;
                     fteRecordholder.Location_typeCode__c = string.valueof(currFte.LocationTypeCode);
                     if(currFte.LocationTypeCode !=null && currFte.LocationTypeCode !=0){
                       
                       if(currFte.LocationTypeName!=null && resourceGrpMap.get(currFte.LocationTypeName.trim()) != null){
                           fteRecordholder.Resource_Group__c = resourceGrpMap.get(currFte.LocationTypeName.trim());
                      }
                     }
                  // mapping service
                  fteRecordholder.Service_Dev__c = currFte.ServiceOfferingNm;
                  fteRecordholder.Offering_Dev__c = currFte.SubServiceOfferingNm;
                  system.debug('service received'+currFte.ServiceOfferingNm+ 'offering received'+currFte.SubServiceOfferingNm);       
                  /*added as part of SWB 563 to show Custom Location in BenchmarkSummary VF Page as Blank if 
                     * NON DCN Location is 0.00 in SSM*/
                    if(currFte.DeliveryLocationNm.contains(SWBBPOSEIntegrationConstants.failurestatus)){
                        fteRecordholder.Delivery_Location_Dev__c=SWBBPOSEIntegrationConstants.emptystring;
                    }
                    else{
                        fteRecordholder.Delivery_Location_Dev__c=currFte.DeliveryLocationNm;              
                    }
                  //fteRecordholder.Delivery_Location_Dev__c=currFte.DeliveryLocationNm;
                  if(serviceMap.get(currFte.ServiceOfferingNm.toUpperCase().trim()) != null){
                    boolean matchfte =false;
                    //system.debug('record size--->'+serviceMap.get(currFte.ServiceOfferingNm.toUpperCase()).size()+'service -->'+currFte.ServiceOfferingNm);
                     for(Service__c ser:serviceMap.get(currFte.ServiceOfferingNm.toUpperCase().trim())){
                    //    system.debug(' before fte service**************************************************');
                    //    system.debug('before if '+currFte.SubServiceOfferingNm);
                        //system.debug('before if '+ser.Solutionscope__r.Offering_Master__r.Name);
                        if(currFte.SubServiceOfferingNm.equalsignorecase(ser.Solutionscope__r.Offering_Master__r.Name) || ser.Solutionscope__r.Offering_Master__r.Name == Label.offering_all){
                            matchfte = true;
                           //system.debug('inside if '+currFte.SubServiceOfferingNm);
                            fteRecordholder.Service__c=ser.id;
                            //system.debug('fte service**************************************************'+fteRecordholder.Service__c);
                            fteRecordholder.Sub_Service_Group__c=ser.Solutionscope__c;
                            system.debug('currFte.ServiceComponent  ------------------------------------- '+currFte.ServiceComponent);
                            if(ServiceComponentTrans.values().size()>0 &&  currFte.ServiceComponent!=null && ServiceComponentTrans.get(currFte.ServiceComponent.trim()+fteRecordholder.Service__c) != null){
                            /*system.debug('mapped ServiceComponentTrans.get(currFte.ServiceComponent.trim()+fteRecordholder.Service__c)'+ServiceComponentTrans.get(currFte.ServiceComponent+fteRecordholder.Service__c));*/
                                fteRecordholder.Service_Component__c=ServiceComponentTrans.get(currFte.ServiceComponent.trim()+fteRecordholder.Service__c);
                            }
                            //system.debug('DeliveryLocationNm  ------------------------------------- '+currFte.DeliveryLocationNm);
                          if(OpportunitydeliveryLocationMap.get(currFte.DeliveryLocationNm+fteRecordholder.Service__c) != null){
                            system.debug('fte mapping in opportunity del location    '+OpportunitydeliveryLocationMap.get(currFte.DeliveryLocationNm+fteRecordholder.Service__c));
                           fteRecordholder.Opportunity_Delivery_Location__c = OpportunitydeliveryLocationMap.get(currFte.DeliveryLocationNm+fteRecordholder.Service__c);
                           }
                           else if(currFte.DeliveryLocationNm!=null && currFte.DeliveryLocationNm!=SWBBPOSEIntegrationConstants.emptystring){
                            /*added as part of SWB 563 to show Custom Location in BenchmarkSummary VF Page as Blank if 
               * NON DCN Location is 0.00 in SSM*/
                                if(currFte.DeliveryLocationNm.contains(SWBBPOSEIntegrationConstants.failurestatus)){
                                    fteRecordholder.Delivery_Location_Dev__c= SWBBPOSEIntegrationConstants.emptystring;
                                }
                                else{
                                    fteRecordholder.Delivery_Location_Dev__c=currFte.DeliveryLocationNm;              
                                }
                                //fteRecordholder.Delivery_Location_Dev__c=currFte.DeliveryLocationNm;
                           }
                        }
                    }
                    //system.debug('Before Match fte service**************************************************'+matchfte);
                      if(matchfte){
                            fte_listtosave.add(fteRecordholder);
                            fteRecordholder = null;
                        }
                        else{
                        offerings.add(currFte.SubServiceOfferingNm);
                        fte_listwoservice.add(fteRecordholder); 
                        fteRecordholder = null;
                      // System.debug('missing service ----> '+currFte.ServiceOfferingNm);
                       //System.debug('missing offering ----> '+currFte.SubServiceOfferingNm);
                      }   
                  }else{
                    offerings.add(currFte.SubServiceOfferingNm);
                  //  System.debug('missing service ----> '+currFte.ServiceOfferingNm);
                   // System.debug('missing offering ----> '+currFte.SubServiceOfferingNm);
                    fte_listwoservice.add(fteRecordholder); 
                    fteRecordholder = null;
                  }
          /*    Integer i = 0;
              while(i<=100){
                      i = Math.Round(Math.Random()*200);
                  }
                if(fte_listtosave.size() >i && fte_listtosave.size() <= 200){
                  try{
                        //database.insert(fte_listtosave,true);
                        insert fte_listtosave;
                        fte_listtosave.clear();
                      //  system.debug('Heap consumed --4--'+limits.getHeapSize());
                    }
                    catch(exception e){
                     ExceptionClass.logException(UtilConstants.HandleRestRequestAndSendResponse,UtilConstants.syncData,e,UtilConstants.SWB,UtilConstants.BPOSE);
                     if(syncstatus.error__c==null || syncstatus.error__c==SWBBPOSEIntegrationConstants.emptystring){
                        syncstatus.error__c = e.getmessage();
                     }
                     return responseFunction(false);
                    }
              }
              syncdata.FTEData.remove(0);*/
              syncdata.FTEData.remove(0);
   }
//system.debug('Heap consumed --5--'+limits.getHeapSize());   
   //list<sobject> sobjectlist = new list<sobject>();
    //sobjectlist.addAll((List<sObject>)(fte_listtosave));
    Integer i = 0;
              while(i<=100){
                      i = Math.Round(Math.Random()*200);
                  }
                //if(fte_listtosave.size() >i && fte_listtosave.size() <= 200){
                  try{
                        //database.insert(fte_listtosave,true);
                        insert fte_listtosave;
                        fte_listtosave.clear();
                      //  system.debug('Heap consumed --4--'+limits.getHeapSize());
                    }
                    catch(exception e){
                     ExceptionClass.logException(UtilConstants.HandleRestRequestAndSendResponse,UtilConstants.syncData,e,UtilConstants.SWB,UtilConstants.BPOSE);
                     if(syncstatus.error__c==null || syncstatus.error__c== SWBBPOSEIntegrationConstants.emptystring){
                        syncstatus.error__c = e.getmessage();
                     }
                     return responseFunction(false);
                    }
              //}
              
    //fte_listtosave.clear();
   // boolean fteissuccess = insert_AndDeleteHeap(sobjectlist);
   /* sobjectlist.clear();
    if(!fteissuccess){
        return responseFunction(false);
    }*/
              /*-------------------------------------Other Cost Mapping--------------------------------------------------*/
             // system.debug('syncdata.CCData.size()syncdata.CCData.size()t'+syncdata.CCData.size());
              while(syncdata.CCData.size() >= 1){
                //cnt++;
                //system.debug('CCD count'+cnt);
                if(rowcounts.CCD_Count_Dev__c  == null){
                    rowcounts.CCD_Count_Dev__c=0;
                }
                
                rowcounts.CCD_Count_Dev__c = rowcounts.CCD_Count_Dev__c+1;
                SyncDataRequest.CCDataEntity currccd = syncdata.CCData[0];
                system.debug('service received'+currccd.ServiceOfferingNm+ 'offering received'+currccd.SubServiceOfferingNm);
                     ccdRecordholder =  new Other_Cost_Details__c();
                     ccdRecordholder.source__c= SWBBPOSEIntegrationConstants.sync;
                     ccdRecordholder.Opportunity__c = syncdata.Opportunityid;
                     ccdRecordholder.Service_Group__c =UtilConstants.BPO;
                     //System.debug('Received mobilization Date in CCD'+currccd.MobilizationStartDt);
                     //System.debug('Received Go live Date in CCD'+currccd.GoLiveDt);
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
                     ccdRecordholder.Column6__c = currccd.Column6;
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
                     //ccdRecordholder.Phases__c = currccd.Phase;
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
                     // mapping service
                 System.debug('CCD services---------> '+currccd.ServiceOfferingNm);
                 system.debug('Tech tools received --> '+currccd.toolName+' tool type-->'+currccd.tooltype);
                  ccdRecordholder.Service_Dev__c=currccd.ServiceOfferingNm;
                  ccdRecordholder.Offering_Dev__c=currccd.SubServiceOfferingNm;
                  system.debug('CCD offering--->'+currccd.SubServiceOfferingNm);
                   if(serviceMap.containskey(currccd.ServiceOfferingNm.toUpperCase().trim())){
                    boolean matchccd =false;
                        for(Service__c ser:serviceMap.get(currccd.ServiceOfferingNm.toUpperCase().trim())){
                            //system.debug(' before ccd service**************************************************');
                        system.debug('before if ccd'+currccd.SubServiceOfferingNm);
                        system.debug('before if ccd'+ser.Solutionscope__r.Offering_Master__r.Name);
                           if((!currccd.ServiceOfferingNm.equalsignorecase(SWBBPOSEIntegrationConstants.technologytools) &&
                            (currccd.SubServiceOfferingNm.equalsignorecase(ser.Solutionscope__r.Offering_Master__r.Name) || ser.Solutionscope__r.Offering_Master__r.Name == Label.offering_all))
                            ||(currccd.ServiceOfferingNm.equalsignorecase(SWBBPOSEIntegrationConstants.technologytools) && currccd.SubServiceOfferingNm.equalsignorecase(ser.Solutionscope__r.Offering_Master__r.Name))
                            ){
                                matchccd = true;
                                ccdRecordholder.Service__c=ser.id;
                                ccdRecordholder.Sub_Service_Group__c=ser.Solutionscope__c;
                                if(ServiceComponentTrans.values().size()>0 && currccd.ServiceComponent!=null && ServiceComponentTrans.get(currccd.ServiceComponent.trim()+ccdRecordholder.Service__c)!=null){
                                system.debug('mapped ServiceComponentTrans.get(currccd.ServiceComponent.trim()+ccdRecordholder.Service__c)'+ServiceComponentTrans.get(currccd.ServiceComponent+ccdRecordholder.Service__c));
                                ccdRecordholder.Service_Component__c=ServiceComponentTrans.get(currccd.ServiceComponent.trim()+ccdRecordholder.Service__c);
                            }
                            if(OpportunitydeliveryLocationMap.get(currccd.DCNLocation+ccdRecordholder.Service__c) != null){
                            system.debug('ccd mapping in opportunity del location    '+OpportunitydeliveryLocationMap.get(currccd.DCNLocation+ccdRecordholder.Service__c));
                           ccdRecordholder.Opportunity_Delivery_Location__c = OpportunitydeliveryLocationMap.get(currccd.DCNLocation+ccdRecordholder.Service__c);
                           }
                           else if(currccd.DCNLocation!=null && currccd.DCNLocation != SWBBPOSEIntegrationConstants.emptystring){
                            /*added as part of SWB 563 to show Custom Location in BenchmarkSummary VF Page as Blank if 
                     * NON DCN Location is 0.00 in SSM*/
                                if(currccd.DCNLocation.contains(SWBBPOSEIntegrationConstants.failurestatus)){
                                    ccdRecordholder.Delivery_Location_Dev__c= SWBBPOSEIntegrationConstants.emptystring;
                                }
                                else{
                                    ccdRecordholder.Delivery_Location_Dev__c=currccd.DCNLocation;              
                                }
                                //ccdRecordholder.Delivery_Location_Dev__c=currccd.DCNLocation;
                           }
                                //system.debug('tool key----------'+currccd.ToolName+ccdRecordholder.Service__c);
                                if(transactionaltechtool.get(currccd.ToolName.trim()+ccdRecordholder.Service__c)!=null && (currccd.ServiceOfferingNm.equalsignorecase(SWBBPOSEIntegrationConstants.technologytools))){
                                    system.debug('transactional tool name------------------------------'+transactionaltechtool.get(currccd.ToolName.trim()+ccdRecordholder.Service__c));
                                    ccdRecordholder.Tech_Tools__c= transactionaltechtool.get(currccd.ToolName.trim()+ccdRecordholder.Service__c);
                                }
                                else if(transactionalCustomToolName.get(currccd.ToolName.trim()+ccdRecordholder.Service__c)!=null){
                                    system.debug('custom tool name transactional tool name------------------------------'+transactionalCustomToolName.get(currccd.ToolName.trim()+ccdRecordholder.Service__c));
                                    ccdRecordholder.Tech_Tools__c= transactionalCustomToolName.get(currccd.ToolName.trim()+ccdRecordholder.Service__c);
                                }
                                /*system.debug(' inside ccd service**************************************************');
                                system.debug('indide if ccd'+currccd.SubServiceOfferingNm);
                                system.debug('inside if ccd'+ser.Solutionscope__r.Offering_Master__r.Name);*/
                            }
                       }
                     system.debug('matchccd'+matchccd);
                     if(matchccd){      
                        ccd_listtosave.add(ccdRecordholder); 
                        ccdRecordholder = null;  
                    }
                    else{
                        offerings.add(currccd.SubServiceOfferingNm);
                      System.debug('missing service ----> '+currccd.ServiceOfferingNm);
                      System.debug('missing offering ----> '+currccd.SubServiceOfferingNm);
                       ccd_listwoservice.add(ccdRecordholder);
                       ccdRecordholder = null;  
                    }
                 }
                 else{
                    offerings.add(currccd.SubServiceOfferingNm);
                   System.debug('missing service ----> '+currccd.ServiceOfferingNm);
                   System.debug('missing offering ----> '+currccd.SubServiceOfferingNm);
                    ccd_listwoservice.add(ccdRecordholder);
                    ccdRecordholder = null; 
                  }
               //   Integer c = 0;
                  /*while(i<=100){
                      c = Math.Round(Math.Random()*200);
                  }
                  if(ccd_listtosave.size() >c && ccd_listtosave.size() <= 200){
                    try{
                            //database.insert(ccd_listtosave,true);
                            insert ccd_listtosave;
                            ccd_listtosave.clear();
                            system.debug('Heap consumed --10--'+limits.getHeapSize());
                        }
                        catch(exception e){
                            ExceptionClass.logException(UtilConstants.HandleRestRequestAndSendResponse,UtilConstants.syncData,e,UtilConstants.SWB,UtilConstants.BPOSE);
                                if(syncstatus.error__c==null || syncstatus.error__c==SWBBPOSEIntegrationConstants.emptystring){
                                    syncstatus.error__c = e.getmessage();
                                }
                            return responseFunction(false);
                        }
                    }
                  */ 
                  syncdata.CCData.remove(0);
              }
              system.debug('Heap consumed --6--'+limits.getHeapSize());
             /*  sobjectlist.addAll((List<sObject>)(ccd_listtosave));
               ccd_listtosave.clear();
    boolean CCdissuccess = insert_AndDeleteHeap(sobjectlist);
    sobjectlist.clear();
    if(!CCdissuccess){
        return responseFunction(false);
    }*/
    
     Integer c = 0;
     while(c<=100){
           c = Math.Round(Math.Random()*200);
      }
    //if(ccd_listtosave.size() >c && ccd_listtosave.size() <= 200){
                    try{
                            //database.insert(ccd_listtosave,true);
                            insert ccd_listtosave;
                            ccd_listtosave.clear();
                            system.debug('Heap consumed --10--'+limits.getHeapSize());
                        }
            catch(exception e){
             ExceptionClass.logException(UtilConstants.HandleRestRequestAndSendResponse,UtilConstants.syncData,e,UtilConstants.SWB,UtilConstants.BPOSE);
             if(e.getmessage().contains(SWBBPOSEIntegrationConstants.TECH_TOOLS)){
                syncstatus.error__c  = SWBBPOSEIntegrationConstants.MISSING_STD_TECHTOOL;
                if(syncstatus.Chunk_Status_Sent__c !=null){
                    syncstatus.Chunk_Status_Sent__c += SWBBPOSEIntegrationConstants.FALSE_STR;
                }
                else{
                    syncstatus.Chunk_Status_Sent__c = SWBBPOSEIntegrationConstants.FALSE_STR;
                }
             }
             if(syncstatus.error__c==null || syncstatus.error__c==SWBBPOSEIntegrationConstants.emptystring){
                syncstatus.error__c = e.getmessage();
             }
             update syncstatus;
             return responseFunction(false);
            }
    //}
    update rowcounts;
         List<Solution_Scope__c> newOffering=new list<Solution_Scope__c>();
         if(!offerings.isEmpty()){
            Offering_Master__c solScope;
            for(String off:offerings){
                //solScope = new Offering_Master__c();
                //solScope =offeringMasterMasterMap.get(off);
                system.debug('solution scope ---> '+offeringMasterMasterMap.get(off.toUpperCase()));
                Solution_Scope__c sc = new Solution_Scope__c();
                if(offeringMasterMasterMap.get(off.toUpperCase()) !=null && !solutionscopes.contains(off)){                    
                    sc.Offering_Master__c=offeringMasterMasterMap.get(off.toUpperCase()).id;
                    sc.Solution_Component__c= SWBBPOSEIntegrationConstants.delivery;
                    sc.opportunity__c=syncdata.Opportunityid;
                    newOffering.add(sc);
                }
            }
         }
             // inserting fte and ccd
              SyncDataRequest.SyncDataResponse syncresponse = new SyncDataRequest.SyncDataResponse();
              List<ExceptionLog__c> toolexceptions=new list<ExceptionLog__c>();
              try{  
                System.debug('newOfferingnewOfferingnewOffering'+newOffering);
                if(!newOffering.isEmpty()){
                    insert newOffering;
                    //system.debug('CPU time after offering insert---> '+Limits.getCPUtime());
                    //Re-querying services to update map with new values
                    for(Service__c ser:[select id, name,services__r.name,Solutionscope__c
                                                ,Solutionscope__r.Offering_Master__c,Solutionscope__r.Offering_Master__r.name,Solutionscope__r.Solution_Component__c,
                                                (Select id,name,Tech_Tool__c,Custom_Tool_Name__c from Tech_Tools__r)
                                                from Service__c where Solutionscope__r.opportunity__c=:syncdata.Opportunityid AND Solutionscope__c IN:newOffering limit 5000]){
                     //serviceMap.put(ser.services__r.name,servicelist.add(ser));
                        if(serviceMap.get(ser.services__r.Name) != null){
                            serviceMap.get(ser.services__r.Name).add(ser);
                        }else{
                            list<service__c> serlist = new list<service__c>{ser};
                            serviceMap.put(ser.services__r.Name.toUpperCase(), serlist);                                  
                        }
                    }
                    system.debug('Service MAP'+serviceMap.size());
                    /*for(String s:serviceMap.keyset()){
                        system.debug('Service map after requery'+serviceMap.get(s));
                    }*/
                    //Re-querying transactional tech tool map to update map with new values
                    for(Tech_Tools__c tool:[select id, name,service__r.name,Service__c,Tech_Tool_Name__c,Tech_Tool__c,Custom_Tool_Name__c from Tech_Tools__c where 
                                    service__r.Solutionscope__r.opportunity__c=:syncdata.Opportunityid limit 5000]){
                transactionaltechtool.put(tool.Tech_Tool_Name__c.trim()+tool.Service__c,tool.id);
                    }
                    //Re-querying ServiceComponentTrans  map to update map with new values
                    for(Service_Components__c component :[Select id ,Services_Component_Master__r.name,Service__c from Service_Components__c where                                 Service__r.Solutionscope__r.Opportunity__c=:syncdata.Opportunityid limit 1000 ]){
                  ServiceComponentTrans.put(component.Services_Component_Master__r.name+component.Service__c,component.id);
                  //system.debug(component.Services_Component_Master__r.name+component.Service__c);
              }
                } 
                for( FTE_Details__c FTEData :fte_listwoservice){
                  if(serviceMap.containsKey(FTEData.Service_Dev__c.toUpperCase())){
                     for(Service__c ser:serviceMap.get(FTEData.Service_Dev__c.toUpperCase())){
                        if(FTEData.Offering_Dev__c.equalsignorecase(ser.Solutionscope__r.Offering_Master__r.Name) || ser.Solutionscope__r.Offering_Master__r.Name == Label.offering_all){
                            FTEData.Service__c=ser.id;
                            FTEData.Sub_Service_Group__c=ser.Solutionscope__c;
                            FTEData.costing_request__c = costrecordid;       
                            if(ServiceComponentTrans.values().size()>0 && FTEData.Service_Component_Dev__c!=null && ServiceComponentTrans.get(FTEData.Service_Component_Dev__c+FTEData.Service__c)!=null){
                            FTEData.Service_Component__c=ServiceComponentTrans.get(FTEData.Service_Component_Dev__c.trim()+FTEData.Service__c);
                            }
                            fte_listtosave.add(FTEData); 
                            FTEData = null;
                           // system.debug('final list in fte-->'+fte_listtosave);
                        }
                      }
                  }
                  else{
                    fte_listwoservice2.add(FTEData);
                    FTEData = null;
                  }
                }
                system.debug('ccd_listwoservice size--'+ccd_listwoservice.size());
                system.debug('Service MAP'+serviceMap.size());
                    for(String s:serviceMap.keyset()){
                        system.debug('Service map after requery'+serviceMap.get(s));
                    }
                List<Other_Cost_Details__c> othercostdetails=new List<Other_Cost_Details__c>();
                for(Other_Cost_Details__c CCDdata :ccd_listwoservice){
                    if(serviceMap.containsKey(CCDData.Service_Dev__c.toUpperCase().trim())){
                        boolean matched = false;
                        for(Service__c ser:serviceMap.get(CCDData.Service_Dev__c.toUpperCase().trim())){
                            system.debug('offering dev name ---> '+CCDData.Offering_Dev__c+'offering name ---> '+ser.Solutionscope__r.Offering_Master__r.Name);
                            if(CCDData.Offering_Dev__c.equalsignorecase(ser.Solutionscope__r.Offering_Master__r.Name)
                          ){
                                CCDdata.Service__c=ser.id;
                                CCDdata.Sub_Service_Group__c=ser.Solutionscope__c;
                                system.debug('CCD SERVICES------'+ser.id);
                                system.debug('tech tool key ---> '+CCDdata.Offering2__c.trim()+CCDdata.Service__c );
                                matched = true;
                                if(transactionaltechtool.get(CCDdata.Offering2__c.trim()+CCDdata.Service__c)!=null && (CCDdata.Service_Dev__c.equalsignorecase(SWBBPOSEIntegrationConstants.technologytools))){
                                    system.debug('transactional tool name------------------------------'+transactionaltechtool.get(CCDdata.Offering2__c.trim()+CCDdata.Service__c));
                                    CCDdata.Tech_Tools__c= transactionaltechtool.get(CCDdata.Offering2__c.trim()+CCDdata.Service__c);
                                }
                                 else if(transactionalCustomToolName.get(CCDdata.Offering2__c.trim()+CCDdata.Service__c)!=null){
                                    CCDdata.Tech_Tools__c= transactionalCustomToolName.get(CCDdata.Offering2__c.trim()+CCDdata.Service__c);
                                }
                            CCDdata.costing_request__c = costrecordid;
                            if(ServiceComponentTrans.values().size()>0 && CCDdata.Service_Component_Dev__c!=null && ServiceComponentTrans.get(CCDdata.Service_Component_Dev__c.trim()+CCDdata.Service__c)!=null){
                            CCDdata.Service_Component__c=ServiceComponentTrans.get(CCDdata.Service_Component_Dev__c.trim()+CCDdata.Service__c);
                            }
                            }
                        }
                    if(matched){
                        ccd_listtosave.add(CCDdata);
                        CCDdata = null;   
                    }
                    else{
                        //ccd_listwoservice2.add(CCDdata);
                        othercostdetails.add(CCDdata);
                        CCDdata = null;
                    }
                 }
                }
                if(!othercostdetails.isEmpty()){
                //ccd_listwoservice2.clear();
                Service__c serAllTech =[Select id,Solutionscope__c from Service__c where Solutionscope__r.Offering_Master__r.name =:Label.offering_all
                                     and  Solutionscope__r.opportunity__c=:syncdata.Opportunityid and Solutionscope__r.Solution_Component__c=: SWBBPOSEIntegrationConstants.technology limit 1 ];
                ExceptionLog__c exlog =new ExceptionLog__c();
                for(Other_Cost_Details__c othercost:othercostdetails){
                    if(othercost.Service_Dev__c==SWBBPOSEIntegrationConstants.technologytools && othercost.service__c==null){
                        boolean matched = false;
                        exlog =new ExceptionLog__c();
                        othercost.service__c=serAllTech.id;
                        othercost.Sub_Service_Group__c=serAllTech.Solutionscope__c;
                        othercost.Tech_Tools__c=transactionaltechtool.get(othercost.Offering2__c.trim()+othercost.Service__c);
                        if(ServiceComponentTrans.values().size()>0 && othercost.Service_Component_Dev__c!=null && othercost.Service_Component__c!= null){
                        othercost.Service_Component__c=ServiceComponentTrans.get(othercost.Service_Component_Dev__c+othercost.Service__c);
                        }
                        if(transactionaltechtool.get(othercost.Offering2__c.trim()+othercost.Service__c)!=null && (othercost.Service_Dev__c.equalsignorecase(SWBBPOSEIntegrationConstants.technologytools)) && (othercost.Offering3__c != null && othercost.Offering3__c.equalsignorecase(SWBBPOSEIntegrationConstants.standard))){
                                    system.debug('transactional tool name-----------------------------'+transactionaltechtool.get(othercost.Offering2__c.trim()+othercost.Service__c));
                                    othercost.Tech_Tools__c= transactionaltechtool.get(othercost.Offering2__c.trim()+othercost.Service__c);
                                    matched = true;
                                }else if(transactionalCustomToolName.get(othercost.Offering2__c.trim()+othercost.Service__c)!=null){
                                    othercost.Tech_Tools__c= transactionalCustomToolName.get(othercost.Offering2__c.trim()+othercost.Service__c);
                                    matched = true;
                                }
                                else if(othercost.Offering2__c != null && othercost.Offering3__c.equalsignorecase(SWBBPOSEIntegrationConstants.custom)){
                                    matched = true;
                                }
                                else if(othercost.Offering2__c != null && othercost.Offering3__c.equalsignorecase(SWBBPOSEIntegrationConstants.standard)){
                                    system.debug('Standard tool not present '+othercost.Offering2__c);
                                    matched = false;
                                    exlog.ExceptionDescription__c+= SWBBPOSEIntegrationConstants.MISSING_STD_TOOL+othercost.Offering2__c;
                                    //exlog.ExceptionDetails__c=SWBBPOSEIntegrationConstants.emptystring;
                                    exlog.ExceptionLogTimestamp__c=system.now();
                                    exlog.ExceptionType__c= SWBBPOSEIntegrationConstants.customexception;
                                    exlog.Application__c= SWBBPOSEIntegrationConstants.bpose_swbappname;
                                    exlog.WSCallingApplication__c= SWBBPOSEIntegrationConstants.BPOSE;
                                    exlog.MethodName__c= SWBBPOSEIntegrationConstants.SyncData;
                                    exlog.ClassName__c= SWBBPOSEIntegrationConstants.HandleRestRequestAndSendResponse;
                                    exlog.ContextUser__c=userinfo.getuserid();
                                    toolexceptions.add(exlog);
                                    system.debug('missing tech tool exception'+toolexceptions);
                                    syncstatus.error__c  = SWBBPOSEIntegrationConstants.STD_TTOOL_NOT_MATCH;
                                }
                                if(matched){
                                    ccd_listtosave.add(othercost); 
                                    othercost = null; 
                                }
                                else{
                                    ccd_listwoservice2.add(othercost);
                                    othercost = null;
                                }
                    }
                    else{
                        ccd_listwoservice2.add(othercost);
                        othercost = null;
                    }
                }
                }
                           System.debug('ccd_listtosave records size to save'+ccd_listtosave.size());
                           System.debug('fte_listtosave records size to save'+fte_listtosave.size());
                    if(!ccd_listtosave.isEmpty()){
                                 /* genericlist_toinsert.addAll((List<sObject>)(ccd_listtosave));
                                  */
                                  UtilConstants.allowactivation= utilconstants.allowstatusupdation = true;
                                  database.insert(ccd_listtosave,true);
                                  ccd_listtosave.clear();
                           }
                           if(!fte_listtosave.isEmpty()){
                               UtilConstants.allowactivation= utilconstants.allowstatusupdation = true;
                                 /* genericlist_toinsert.addAll((List<sObject>)(fte_listtosave));*/
                                 database.insert(fte_listtosave,true);
                                  fte_listtosave.clear();
                           }
                           if(ccd_listwoservice2.IsEmpty() && fte_listwoservice2.IsEmpty()){
                            syncresponse.status = true;
                            //genericlist_toinsert.clear();
                          }
                          else{
                            syncresponse.status = false;
                            syncstatus.error__c  = SWBBPOSEIntegrationConstants.INVALID_CMB_SRV_OFF;
                            //database.rollback(sp);
                         }
              }
              catch(Exception e){
                     //system.debug(' catch block'+e);
                     ExceptionClass.logException(UtilConstants.HandleRestRequestAndSendResponse,UtilConstants.syncData,e,UtilConstants.SWB,UtilConstants.BPOSE);
                     syncresponse.status = false;
                     //database.rollback(sp);
                     system.debug('exceptions---------->'+exceptions.size());
              }
              finally{
              system.debug('missing tech tool exception before insert'+toolexceptions);
                   if(!toolexceptions.isempty()){
                         database.insert(toolexceptions,false);
                         syncstatus.error__c  = SWBBPOSEIntegrationConstants.STD_TTOOL_NOT_MATCH;
                         syncresponse.status = false;
                     }
              }
              if(syncdata.isfirstchunk){
                syncstatus.Chunk_Status_Sent__c = string.valueof(syncresponse.status)+SWBBPOSEIntegrationConstants.semicolon;
              }
              else{
                syncstatus.Chunk_Status_Sent__c+= string.valueof(syncresponse.status)+SWBBPOSEIntegrationConstants.semicolon;
              }
              update syncstatus;
              //syncresponse.status = true;
              string finalresponse = JSON.serialize(syncresponse);
              system.debug('Heap consumed --8--'+limits.getHeapSize());
              return finalresponse;
       } 
       else{
          system.debug('CPU time in else io part---> '+Limits.getCPUtime());
          IOHandleRestRequestAndSendResponse iosync =new IOHandleRestRequestAndSendResponse();
          string finalresponse=iosync.syncData(syncdata);
          //finalresponse=JSON.serialize(syncresponse);
          return finalresponse;
       }
    }
       /*
              @methodname : getOppdetailsonUserRequest
              @methodDescription : This method is used to return opportunity details to BPOSE user. 
              @return type: serialize jason string
       */
        public string getOppdetailsonUserRequest(GetOpportunityDataForUserRequest findoppdataforuserrequest){
              String userQueryFilter=findoppdataforuserrequest.enterpriseid+SWBBPOSEIntegrationConstants.likeparameter;
              boolean userHasAccess = false;
              String finalResponse;
              user_master__c userList;
              Opportunity oppRecord;
              id oppid = findoppdataforuserrequest.opportunityid;
              Schema.SObjectType objType ;
              objType = oppid.getSobjectType();
              string objName = string.valueof(objType);
              string oppname= SWBBPOSEIntegrationConstants.emptystring;
              string clientName =SWBBPOSEIntegrationConstants.emptystring;
              Set<String> Offerings= new Set<String>{SWBBPOSEIntegrationConstants.BSS,SWBBPOSEIntegrationConstants.CROSS,SWBBPOSEIntegrationConstants.PMO,SWBBPOSEIntegrationConstants.technology};
              List<String> countriesInScope = new List<String>();
              Date startdate = Date.newInstance(1990,01,01);
              GetOpportunityDataForUserRequest.GetOpportunityDataForUserResponse response =new GetOpportunityDataForUserRequest.GetOpportunityDataForUserResponse();
              if(objName.equalsignorecase(SWBBPOSEIntegrationConstants.oppname)){
              try{
                     userList =[SELECT Id,email__c,user__c FROM User_master__c where email__c like: userQueryFilter AND active__c=true limit 1];
                     system.debug('userList****************************************'+userList.user__C);
                     oppRecord=[SELECT Id,SAP_OM_ID__c, Account.name,service_grp__c, Initial_Go_live_Date__c,Name,Geo_Region__r.name, Contract_Start_Date__c,OperatingGroup__r.name,Contract_End_Date__c FROM Opportunity 
                                                                     where id=:oppid limit 1];
                     Costing_Request__c costingRecord1 = [SELECT Country__c,SAP_OM_ID__c,Last_Checked_Out_By_Dev__c,Is_Checked_Out__c,In_Progress_IO__c,in_progress__c,Allow_Deal_Customization__c,
                                                                Initial_Go_Live__c,Contract_End__c,Contract_Start__c FROM Costing_Request__c 
                                                               where Opportunity__c= :oppRecord.id limit 1];                                                
                    response.IsUserPresentInSystem = true;
                    oppname = oppRecord.name;
                    clientName = oppRecord.account.name;
                    if(oppname.contains(SWBBPOSEIntegrationConstants.DBL_CD)){
                        oppname = oppname.replace(SWBBPOSEIntegrationConstants.DBL_CD,SWBBPOSEIntegrationConstants.QT);
                    }
                    if(clientName != null && clientName.contains(SWBBPOSEIntegrationConstants.DBL_CD)){
                        clientName = clientName.replace(SWBBPOSEIntegrationConstants.DBL_CD,SWBBPOSEIntegrationConstants.QT);
                    }
                    response.OpportunityName = oppname;
                    response.ClientName = clientName;         
                    response.whatif = false;             

                 response.enterpriseid=findoppdataforuserrequest.enterpriseid;
                 
                 string offquery = SWBBPOSEIntegrationConstants.emptystring ;
                 string delivery = SWBBPOSEIntegrationConstants.delivery;
                 string bpo = SWBBPOSEIntegrationConstants.BPO;
                 if(findoppdataforuserrequest.ServiceGroup.equalsignorecase(SWBBPOSEIntegrationConstants.BPO)){
                 offquery = SWBBPOSEIntegrationConstants.bpooffquery;
                 }
                 else{
                    offquery = SWBBPOSEIntegrationConstants.iooffquery;
                 }
                 List<Solution_Scope__c> offeringList=database.query(offquery);

                        //Offerings.add('BST','Cross','PMO','Technology');
                        for(Solution_Scope__c scope:offeringList){
                            if(!scope.Offering_Master__r.name.equalsignorecase(Label.offering_all)){
                               Offerings.add(scope.Offering_Master__r.name);
                            }
                        }
                       system.debug('costing record -->'+costingRecord1);                  
                       countriesInScope=costingRecord1.country__c.split(SWBBPOSEIntegrationConstants.semicolon);
                       if(costingRecord1.in_progress__c!=null){
                            response.issyncinprogress = integer.valueof(costingRecord1.in_progress__c);
                       }
                       else{
                        response.issyncinprogress = integer.valueof(SWBBPOSEIntegrationConstants.THREE_STTS);
                       }
                        if(response.issyncinprogress == 2){
                            response.IsSyncInProgressForIO =integer.valueof(costingRecord1.in_progress_io__c);
                        }

                        if(costingRecord1.In_Progress_IO__c != null && response.IsSyncInProgressForIO != 2){

                            response.IsSyncInProgressForIO = integer.valueof(costingRecord1.In_Progress_IO__c);
                        }
                        else if(response.IsSyncInProgressForIO != 2){

                            response.IsSyncInProgressForIO =integer.valueof(SWBBPOSEIntegrationConstants.THREE_STTS);
                        }
                        if(response.IsSyncInProgressForIO == 2){
                            response.issyncinprogress =integer.valueof(costingRecord1.in_progress__c);
                        }
                       /* if(!costingRecord1.Last_Checked_Out_By_Dev__c.equals(userinfo.getUserid()) && costingRecord1.Is_Checked_Out__c){
                            response.CanOpportunityBeCheckedOut=false;
                        }*/
                        if(costingRecord1.SAP_OM_ID__c != null){
                            response.SAPOMID=long.valueOf(costingRecord1.SAP_OM_ID__c);
                        }
                        else{
                            //if SAP om ID is not present we are sending 0 as BPOSE can't handle null
                             response.SAPOMID= 0 ;
                        }

                        response.ContractStartDate=costingRecord1.Contract_Start__c;
                        response.ContractEndDate=costingRecord1.Contract_End__c;
                        response.GoLiveDate=costingRecord1.Initial_Go_Live__c;
                        if(response.GoLiveDate == null){
                            response.GoLiveDate = startdate;
                        }
                        if(response.ContractEndDate == null){
                            response.ContractEndDate = startdate;
                        }
                        if(response.ContractStartDate == null){
                            response.ContractStartDate = startdate;
                        }
                        response.ClientName=oppRecord.Account.name;
                        response.SalesGeography=oppRecord.Geo_Region__r.name;
                        response.OG=oppRecord.OperatingGroup__r.name;
                        response.Offerings=Offerings;
                       if(!countriesInScope.isEmpty()){
                            response.CountriesInScope=countriesInScope;
                       }   


                        string profilename = [select profile.name from user where id=:userList.user__c limit 1].profile.name;






                                   
                        //response.ServiceGroup = oppRecord.service_grp__c;
                        if(SWBBPOSEIntegrationConstants.BPO.equalsignorecase(findoppdataforuserrequest.ServiceGroup)){
                            response.IsDealCustomizable=costingRecord1.Allow_Deal_Customization__c; 
                        }
                        else{
                            response.IsDealCustomizable= false;
                        }

                        string accessLevel =
                               ProfileMatrix.giveAccessLevel(profilename,findoppdataforuserrequest.ServiceGroup,oppRecord.id,userList.user__c);
                 if(accessLevel =='E'){   
                      if(costingRecord1.Last_Checked_Out_By_Dev__c == userList.user__c && costingRecord1.Is_Checked_Out__c){
                                response.CanOpportunityBeCheckedOut=true;
                                system.debug('if****************************************'+userList.user__c);
                       }
                      else if(costingRecord1.Last_Checked_Out_By_Dev__c!=userList.user__c && costingRecord1.Is_Checked_Out__c){
                        system.debug('else if****************************************'+userList.user__c);
                                response.CanOpportunityBeCheckedOut=false;
                       }
                      else{
                        system.debug('else****************************************'+userList.user__c);
                           response.CanOpportunityBeCheckedOut=true;
                       }

                     response.isDealEditableForUser = true;                  
                 }
                 else{
                    response.CanOpportunityBeCheckedOut=false;
                    response.isDealEditableForUser = false;
                  }
              }              


              catch(exception e){
                  system.debug('get opp exception--'+e);
                     if(userlist== null){
                         response.IsUserPresentInSystem = false;
                         response.whatif = false;
                         response.OpportunityName = null;
                         response.ClientName = null;
                         response.IsDealCustomizable=false;
                         response.isDealEditableForUser = false;
                         response.SAPOMID = 0;
                         response.ContractStartDate = startdate ;
                         response.ContractEndDate = startdate ;
                         response.GoLiveDate = startdate ;
                         response.SalesGeography = null;
                         response.OG = null;
                         response.Offerings = null;
                         response.CountriesInScope = null;
                     }
                     else if(oppRecord == null){
                         response.IsUserPresentInSystem = true;
                         response.whatif = false;
                         response.OpportunityName = null;
                         response.ClientName = null;
                         response.IsDealCustomizable=false;
                         response.isDealEditableForUser = false;
                         response.SAPOMID = 0;
                         response.ContractStartDate = startdate ;
                         response.ContractEndDate = startdate ;
                         response.GoLiveDate = startdate ;
                         response.SalesGeography = null;
                         response.OG = null;
                         response.Offerings = null;
                         response.CountriesInScope = null;
                     }
              }
              }
              else{
                Scratchpad_Opportunity__c whatifrec = new Scratchpad_Opportunity__c();
              try{
                  string whatifname= SWBBPOSEIntegrationConstants.emptystring;
                  string wcliName=SWBBPOSEIntegrationConstants.emptystring;
                whatifrec = [SELECT Id, Name, Contract_End__c, Contract_Start__c, Country__c, Initial_Go_Live__c, Offering__c, Geo_Region__r.name, Operating_Group__r.name, Client__r.name FROM Scratchpad_Opportunity__c where id=:oppid limit 1];
                userList =[SELECT Id,email__c,user__c FROM User_master__c where email__c like: userQueryFilter AND active__c=true limit 1];
                    response.IsUserPresentInSystem = true;
                    response.whatif = true;
                    whatifname = whatifrec.name;
                    wcliName =whatifrec.client__r.name;
                    if(whatifname.contains(SWBBPOSEIntegrationConstants.DBL_CD)){
                        whatifname.replace(SWBBPOSEIntegrationConstants.DBL_CD,SWBBPOSEIntegrationConstants.QT);
                    }
                    if(wcliName != null && wcliName.contains(SWBBPOSEIntegrationConstants.DBL_CD)){
                        wcliName.replace(SWBBPOSEIntegrationConstants.DBL_CD,SWBBPOSEIntegrationConstants.QT);
                    }
                    response.OpportunityName = whatifname;
                    response.ClientName = wcliName;         
                    //userHasAccess=UserRecordAccess.getHasEditAccess(userList.user__c,oppRecord.id);
                    response.CanOpportunityBeCheckedOut=true;
                    response.enterpriseid=findoppdataforuserrequest.enterpriseid;
                    response.IsDealCustomizable=true;
                    response.isDealEditableForUser = true;                   
                    response.SAPOMID= 0 ;
                    response.issyncinprogress = 1;
                    response.IsSyncInProgressForIO = 1;
                    response.ContractStartDate=whatifrec.Contract_Start__c;
                    response.ContractEndDate=whatifrec.Contract_End__c;
                    response.GoLiveDate=whatifrec.Initial_Go_Live__c;
                    response.SalesGeography=whatifrec.Geo_Region__r.name;
                    response.OG=whatifrec.Operating_Group__r.name;
                    list<string> off1 = new list<string>();
                    off1 = whatifrec.offering__c.split(SWBBPOSEIntegrationConstants.semicolon);
                    offerings.addALL(off1);
                    for(string ss: offerings){
                        response.Offerings.add(ss);
                    }

                    response.CountriesInScope = whatifrec.country__c.split(SWBBPOSEIntegrationConstants.semicolon);

                    }
                    catch(Exception e){
                         if(userlist== null){
                         response.IsUserPresentInSystem = false;
                         response.OpportunityName = null;
                         response.ClientName = null;
                         response.IsDealCustomizable=false;
                         response.isDealEditableForUser = false;
                         response.SAPOMID = null;
                         response.ContractStartDate = startdate ;
                         response.ContractEndDate = startdate ;
                         response.GoLiveDate = startdate ;
                         response.SalesGeography = null;
                         response.OG = null;
                         response.Offerings = null;
                         response.CountriesInScope = null;
                     }
                     else if(whatifrec == null){
                         response.IsUserPresentInSystem = true;
                         response.OpportunityName = null;
                         response.ClientName = null;
                         response.IsDealCustomizable=false;
                         response.isDealEditableForUser = false;
                         response.SAPOMID = null;
                         response.ContractStartDate = startdate ;
                         response.ContractEndDate = startdate ;
                         response.GoLiveDate = startdate ;
                         response.SalesGeography = null;
                         response.OG = null;
                         response.Offerings = null;
                         response.CountriesInScope = null;
                     }
                }
              }
                     //change to sap om id 
               system.debug('response-----?'+response); 
              finalResponse=system.JSON.serialize(response);
              system.debug('finalResponse----> '+finalResponse);
           return finalResponse;
       }
              /*
              @methodname : getOpportunityTeamDetails
              @methodDescription : This method is used to return opportunity details to BPOSE user. 
              @return type: serialize jason string
       */
       public string getOpportunityTeamDetails(GetOpportunityTeamDetailsRequest getoppsataforTeamDetail){
              List<Opportunity_Teams__c> oppTeamRecord=[SELECT Id,Opportunity__c, Opportunity_Team_Member__r.user__r.email FROM Opportunity_Teams__c where 
                                                                     Opportunity__c=:getoppsataforTeamDetail.opportunityid limit 5000];//change to sap om id
              String finalResponse;
              List<String> enterpriseids= new List<String>();
              if(!oppTeamRecord.isEmpty()){     
                           for(Opportunity_Teams__c oppteam:oppTeamRecord){
                                  List<String> tempEnterpriseid=oppteam.Opportunity_Team_Member__r.user__r.email.split(UtilConstants.AT_THE_RATE_OF);
                                  enterpriseids.add(tempEnterpriseid[0]);
                           }      
                     GetOpportunityTeamDetailsRequest.GetOpportunityTeamDetailsResponse response = new GetOpportunityTeamDetailsRequest.GetOpportunityTeamDetailsResponse();
                     response.enterpriseids=    enterpriseids;                    
                   finalResponse=system.JSON.serialize(response);
                     return finalResponse;
              }
              else{
                     return UtilConstants.OppMemberNotFound;
              }
       }
        /*
              @methodname : autoSyncData
              @methodDescription : This method is used to return sync dates with opportunity object. 
              @return type: serialize jason string
        */
        public string autoSyncData(AutoSyncDateForOpportunityRequest autosyncoppdata){
        UtilConstants.IS_OPPTRIGGER_REQUIRED = false;
              String finalResponse;
              AutoSyncDateForOpportunityRequest.AutoSyncDateForOpportunityResponse response =new AutoSyncDateForOpportunityRequest.AutoSyncDateForOpportunityResponse();
              try{
              Costing_Request__c costingRecord=[SELECT Country__c,Last_Checked_Out_By_Dev__c,Is_Checked_Out__c,Allow_Deal_Customization__c,
                                                                Initial_Go_Live__c,Contract_End__c,Contract_Start__c FROM Costing_Request__c 
                                                               where Opportunity__c=:autosyncoppdata.opportunityid limit 1];
                           //oppRecord.id=oppRecord.id;
                       Date myDate1 = date.newinstance(autosyncoppdata.GoLiveDate.year(), autosyncoppdata.GoLiveDate.month(), autosyncoppdata.GoLiveDate.day());
                       costingRecord.Initial_Go_Live__c=myDate1 ;
                       myDate1 = date.newinstance(autosyncoppdata.ContractStartDate.year(), autosyncoppdata.ContractStartDate.month(), autosyncoppdata.ContractStartDate.day());
                       costingRecord.Contract_Start__c=myDate1;
                       myDate1 = date.newinstance(autosyncoppdata.ContractEndDate.year(), autosyncoppdata.ContractEndDate.month(), autosyncoppdata.ContractEndDate.day());
                       costingRecord.Contract_End__c=myDate1;
                           costingRecord.Has_Updated__c =true;
                 Opportunity Opportunitytoupdate=[SELECT Contract_End_Date__c,Contract_Start_Date__c,
                                                                Initial_Go_live_Date__c FROM Opportunity 
                                                               where id=:autosyncoppdata.opportunityid limit 1];
                           //oppRecord.id=oppRecord.id;
                           Opportunitytoupdate.Initial_Go_live_Date__c=costingRecord.Initial_Go_Live__c;
                           Opportunitytoupdate.Contract_End_Date__c=costingRecord.Contract_End__c;
                           Opportunitytoupdate.Contract_Start_Date__c=costingRecord.Contract_Start__c;
                   database.update(costingRecord,true);
                   database.update(Opportunitytoupdate,true);
                   response.status=true;
                   finalResponse=system.JSON.serialize(response);
                  /*Refresh_Canvas__c rs = Refresh_Canvas__c.getOrgDefaults();
                  rs.has_updated__c = true;
                  update rs;        */          
                  //canvasclass.showUpdates();       
              }
              catch(Exception e){
               ExceptionClass.logException(UtilConstants.HandleRestRequestAndSendResponse,UtilConstants.autoSyncData,e,UtilConstants.SWB,UtilConstants.BPOSE);
               response.status=false;
               finalResponse=system.JSON.serialize(response);
              }
              return finalResponse;
       }
       /*************************
       @method Name:  sendBDData
       @parameters : deserialized JSON of type SendBDLDataRequest class
       @output : serialized JSON that has true/false as status
       @returntype : string
       *****************************/
       public string sendBDData(SendBDLDataRequest sendBDLData){
              String finalResponse;
              System.debug('send bdl request-->'+sendBDLData);
              String userQueryFilter=sendBDLData.LstBDLGeneratedUserNm+SWBBPOSEIntegrationConstants.likeparameter;
              system.debug('user email--->'+userQueryFilter);
              if(sendBDLData.ServiceGroup.equalsignorecase(SWBBPOSEIntegrationConstants.BPO)){
                    SendBDLDataRequest.SendBDLDataResponse response =new SendBDLDataRequest.SendBDLDataResponse();
                    try{
                      Costing_Request__c costRequest=[SELECT Id, Last_BDL_Generated_Version__c,
                                                         Last_BDL_Generated_Scenario__c, Last_BDL_Generated_User__c, 
                                                         BDL_Generated_UTC_Date__c FROM Costing_Request__c where 
                                                         Opportunity__c=:sendBDLData.opportunityid limit 1];
                      /*****************************Querying User record*************************************/
                      User_Master__c user = [select id from User_Master__c where email__c LIKE:userQueryFilter AND active__c=true limit 1];  
                      costRequest.Last_BDL_Generated_Version__c=sendBDLData.LstBDLGeneratedVrNm;
                      costRequest.Last_BDL_Generated_Scenario__c=sendBDLData.LstBDLGeneratedScNm;
                      costRequest.Last_BDL_Generated_User__c=sendBDLData.LstBDLGeneratedUserNm;
                      //costRequest.Last_Synced_Date__c = system.now();
                      //costRequest.Last_Synced_Up_By__c = user.id;
                       costRequest.Is_BDL_Updated_Dev__c =true;
                      //date mydate = date.parse(sendBDLData.BDLGeneratedUTCDateTime);
                      Date myDate = date.newinstance(1900, 1, 1);
                      Date myoriginalDate = date.newinstance(sendBDLData.BDLGeneratedUTCDateTime.year(), sendBDLData.BDLGeneratedUTCDateTime.month(), sendBDLData.BDLGeneratedUTCDateTime.day());
                     if(myoriginalDate != myDate){
                      costRequest.BDL_Generated_UTC_Date__c=System.now();
                    }else{
                        costRequest.BDL_Generated_UTC_Date__c=null;
                    }
                      database.update (costRequest,true); 
                      response.status=true;
                    }
                    catch(Exception e){
                     ExceptionClass.logException(UtilConstants.HandleRestRequestAndSendResponse,UtilConstants.sendBDData,e,UtilConstants.SWB,UtilConstants.BPOSE);
                         response.status=false;
                  }
                  finalResponse=system.JSON.serialize(response); 
            }   
            else{
                IOHandleRestRequestAndSendResponse iosync =new IOHandleRestRequestAndSendResponse();
                finalresponse=iosync.sendBDData(sendBDLData);
            }                                                   
            return finalResponse;
       }
       /*************************
       @method Name: finaliseTransaction
       @parameters : deserialized JSON of type FinalizeTransaction class
       @output : serialized JSON that has true/false as status
       @returntype : string
       *****************************/
       public string finaliseTran(FinalizeTransaction transrequest){
              string finalResponse=SWBBPOSEIntegrationConstants.emptystring;
              UtilConstants.IS_OPPTRIGGER_REQUIRED = false;
              FinalizeTransaction.FinalizeTransResponse response =new FinalizeTransaction.FinalizeTransResponse();
              sync_status__c syncstat = new sync_status__c();
              system.debug('final call --->'+transrequest.isTransactionSuccessful+'row count -->'+transrequest.RowCount);
              costing_request__c costRec = [select id,In_Progress_PrevState__c from costing_Request__c where Opportunity__c =:transrequest.Opportunityid limit 1];
              //system.debug('Null pointer yahaan hai '+transrequest); 
              syncstat = [select id,Chunk_Status_Sent__c,error__c,Final_Status_Recieved__c,Final_Status_Sent__c,
                Sync_Initiated_Time__c,Last_Synced_User__c,synced_Scenario__c,Error_IO__c
                 from sync_Status__C where opportunity__c=:transrequest.Opportunityid limit 1];
            syncstat.Final_Status_Recieved__c = string.valueof(transrequest.isTransactionSuccessful);
              if(transrequest.isTransactionSuccessful){
                try{
                
                    if(transrequest.CDRRowCount==null ){
                        transrequest.CDRRowCount = 0;
                    }
                    response.status = deleteOldAndUpdateNewData(transrequest.Opportunityid,transrequest.RowCount+transrequest.CDRRowCount,transrequest,costRec,transrequest.ServiceGroup);
                }
                catch(Exception e){
                    response.status=0;
                    ExceptionClass.logException(UtilConstants.HandleRestRequestAndSendResponse,UtilConstants.finaliseTransaction,e,UtilConstants.SWB,UtilConstants.BPOSE);
                    if(transrequest.ServiceGroup.equalsignorecase(SWBBPOSEIntegrationConstants.BPO)){
                        rollback_data(transrequest,transrequest.RowCount,costRec );    
                        response.status= 0;
                    }
                    else{
                        IOHandleRestRequestAndSendResponse iosync =new IOHandleRestRequestAndSendResponse();
                        iosync.rollback_data(transrequest,transrequest.RowCount+transrequest.CDRRowCount,costRec);
                        response.status= 0;
                    }
                }
              }
              else{
                    if(transrequest.ServiceGroup.equalsignorecase(SWBBPOSEIntegrationConstants.BPO)){
                      rollback_data(transrequest,transrequest.RowCount,costRec );
                      if(syncstat.Error__c == null || syncstat.error__c == SWBBPOSEIntegrationConstants.emptystring ){
                            syncstat.Error__c ='Sync Failed. Roll Back Initiated by Solution Estimator';
                      }
                      response.status= 1;
                    }
                    else{
                        IOHandleRestRequestAndSendResponse iosync =new IOHandleRestRequestAndSendResponse();
                        iosync.rollback_data(transrequest,transrequest.RowCount+transrequest.CDRRowCount,costRec);
                        if(syncstat.Error_IO__c == null || syncstat.error_io__c == SWBBPOSEIntegrationConstants.emptystring ){
                            syncstat.Error_IO__c ='Sync Failed. Roll Back Initiated by Solution Estimator';
                        }
                        response.status= 1;
                    }
              }
              try{
              syncstat.Final_Status_Sent__c = string.valueof(response.status);
              syncstat.last_synced_user__C = transrequest.enterpriseid;
              String userQueryFilter=transrequest.enterpriseid+SWBBPOSEIntegrationConstants.likeparameter;
                user_master__c u = [select id from user_master__C where email__c LIKE :userQueryFilter AND active__c=true LIMIT 1];
                if(transrequest.ServiceGroup.equalsignorecase(SWBBPOSEIntegrationConstants.BPO)){
                    syncstat.Last_Synced_By__c = u.id;
                    syncstat.synced_Scenario__c = transrequest.ScenarioNm;
                }
                else{
                    syncstat.Last_Synced_By_IO__c = u.id;
                    syncstat.synced_Scenario_io__c = transrequest.ScenarioNm;
                }
              }
              catch (exception e){
                ExceptionClass.logException(UtilConstants.HandleRestRequestAndSendResponse,UtilConstants.finaliseTransaction,e,UtilConstants.SWB,UtilConstants.BPOSE);
              }
              
              
              transrequest = null;
              finalResponse = system.JSON.serialize(response);
              update syncstat;
              return finalResponse;
       }
        /*
              @methodname : deleteData
              @methodDescription : to delete old fte,other cost and payroll data when is trans 
              is true and update new data. 
              @return type:boolean
       */
       public integer deleteOldAndUpdateNewData(id oppid,integer rowcount,FinalizeTransaction trans,costing_request__c costRec,string serviceGroup){
        system.debug('service group received '+serviceGroup);
        id costid= costRec.id;
         if(serviceGroup.equalsignorecase(SWBBPOSEIntegrationConstants.BPO)){
              system.debug('Heap consumed --9--'+limits.getHeapSize());
              set<id> NOCDids = new set<id>();
              set<id> Nfteids = new set<id>();
              set<id> OOCDids = new set<id>();
              set<id> Ofteids = new set<id>();
              integer  response;
              sync_Status__c syncstatus = new sync_Status__C();
              list<Fte_details__c> ftedata = new list<FTE_details__c>();
              List<Other_Cost_Details__c> CCDData = new list<Other_Cost_Details__c>();
               list<Fte_details__c> ftedata_new = new list<FTE_details__c>();
              List<Other_Cost_Details__c> CCDData_new = new list<Other_Cost_Details__c>();
              map<string,string> costdataMap = new map<string,string>();
         
              boolean issuccess = false;
              Opportunity opp = [select id,(Select id from FTE_Details__r where is_transient__c = false and Service_Group__c=:SWBBPOSEIntegrationConstants.BPO),
                                              (select id from Other_Cost_Details__r where is_transient__c = false and Service_Group__c=:SWBBPOSEIntegrationConstants.BPO) 
                                              from Opportunity where id=:oppid limit 1];
              syncstatus = [select id,error__c,synced_Scenario__c from sync_Status__C where opportunity__c=:oppid limit 1]; 
              // extracting old records start
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
              system.debug('Heap consumed --10--'+limits.getHeapSize());
              //clearing variable to release memory
              opp = new Opportunity();
            //extracting old data end
              Opportunity oppquery = [select id,Is_Synced__c,(Select id from FTE_Details__r where is_transient__c = true and Service_Group__c=:SWBBPOSEIntegrationConstants.BPO),
                                            (select id from Other_Cost_Details__r where is_transient__c = true and Service_Group__c=:SWBBPOSEIntegrationConstants.BPO) 
                                            from Opportunity where id=:oppid limit 1];
             // extracting New records start
              ftedata_new.addALL(oppquery.FTE_Details__r);
              CCDData_new.addALL(oppquery.Other_Cost_Details__r);
              //clearing variable to release memory
              oppquery = new Opportunity();               
              for(Fte_details__c fte : ftedata_new){
                   Nfteids.add(fte.id); 
              }
              for(Other_Cost_Details__c ccd : CCDData_new){
                    NOCDids.add(ccd.id);
              }
              //extracting New records end
              Costing_Request__c costingRecord = new Costing_Request__c(id=costid);
             costingRecord.FTE_CCD_Count_BPOSE_sent__c = rowcount;
             try{
               system.debug('Total Count Received in JSON ---->'+rowcount);
               system.debug('FTE count saved ---->'+ftedata_new.size());
               system.debug('CCD count Saved ---->'+ccddata_new.size());
               if(ftedata_new.size()+ccddata_new.size() == rowcount){
                    //inserting Tech Tools
                    ScopeUpdataion_FutureClass.insertTechTool(Nocdids,trans.Opportunityid);
                    //Mapping cost record map to update in final commit
                    costdataMap.put(SWBBPOSEIntegrationConstants.id,costid);
                    costdataMap.put(SWBBPOSEIntegrationConstants.oppfield,oppid);
                    costdataMap.put(SWBBPOSEIntegrationConstants.initialgolive,string.valueof(trans.ScenarioGoLiveDate));
                    costdataMap.put(SWBBPOSEIntegrationConstants.contractstart,string.valueof(trans.ScenarioContractStartDate));
                    costdataMap.put(SWBBPOSEIntegrationConstants.contractend,string.valueof(trans.ScenarioContractEndDate));
                    costdataMap.put(SWBBPOSEIntegrationConstants.ssmversion,trans.SSMVersion);
                    costdataMap.put(SWBBPOSEIntegrationConstants.versionname,trans.VersionNm);
                    costdataMap.put(SWBBPOSEIntegrationConstants.scenarioname,trans.ScenarioNm);
                    costdataMap.put(SWBBPOSEIntegrationConstants.mrdbversion,trans.MRDBVersion);
                    costdataMap.put(SWBBPOSEIntegrationConstants.mrdblastrefreshdate,string.valueof(trans.MRDBDate));
                    costdataMap.put(SWBBPOSEIntegrationConstants.HasMasterDataBeenCustomizedForDeal,string.valueof(trans.HasMasterDataBeenCustomizedForDeal));
                    //costdata.put(costingRecord.Last_Synced_Date__c,'This will be system.now() hence not added to map');
                    costdataMap.put(SWBBPOSEIntegrationConstants.lastsyncedby,trans.enterpriseid);
                    costdataMap.put(SWBBPOSEIntegrationConstants.VersionID,trans.VersionID);
                    //trans = null;
                    issuccess = true;
                    costingRecord.In_Sync__c = false;
                    costingRecord.calculation__c = true;
                    costingRecord.Email_Dev__c=trans.enterpriseid+SWBBPOSEIntegrationConstants.attherateemail;
                    costingRecord.Time_Stamp__c= System.now();
                    update costingRecord;
                    ftedata_new.clear();
                    ccddata_new.clear();
                    response = 1;
                    system.debug('Heap consumed --11--'+limits.getHeapSize());
                }
                 else{
                    //this part will be invoked if row count didn't match
                    //costingRecord.In_Progress__c = '2';
                    costingRecord.In_Sync__c = false;
                    costingRecord.Sync_Failed_At__c = SWBBPOSEIntegrationConstants.sync;
                    costingRecord.Calculation__c = false;
                    costingRecord.Data_Cleaning_dev__c=true;
                    costingRecord.in_progress_io__c = costRec.In_Progress_PrevState__c;
                    costingRecord.Email_Dev__c=trans.enterpriseid+SWBBPOSEIntegrationConstants.attherateemail;
                    update costingRecord;
                    system.debug('row count didn\'t match');
                    rollback_data(trans,rowcount,costRec);
                    issuccess = false;
                    response = 0;
                    syncstatus.error__c  = SWBBPOSEIntegrationConstants.ERR;
                    update syncstatus;
                 }                                  
             }
             catch (exception e){
                ExceptionClass.logException(UtilConstants.HandleRestRequestAndSendResponse,UtilConstants.deleteOldAndUpdateNewData,e,UtilConstants.SWB,UtilConstants.BPOSE);
                //costingRecord.In_Progress__c = '2';
                costingRecord.In_Sync__c = false;
                costingRecord.Sync_Failed_At__c = SWBBPOSEIntegrationConstants.sync;
                costingRecord.Calculation__c = false;
                costingRecord.Data_Cleaning_dev__c=true;
                costingRecord.Email_Dev__c=trans.enterpriseid+SWBBPOSEIntegrationConstants.attherateemail;
                costingRecord.in_progress_io__c = costRec.In_Progress_PrevState__c;
                update costingRecord;
                issuccess = false;
                response=0;
             }
             finally{
                if(issuccess){
                    //BenchmarkSync.populateBenchMarkObjs(oppid);
                    system.debug('Heap consumed --12--'+limits.getHeapSize());
                    system.debug('Nfteids--'+Nfteids.size());
                    system.debug('NOCDids--'+NOCDids.size());
                    system.debug('Ofteids--'+Ofteids.size());
                    system.debug('Oocdids--'+Oocdids.size());
                    system.debug('costdataMap--'+costdataMap.size());
                  BenchmarkSync.populateBenchMarkObjsFuture(Nfteids,NOCDids,Ofteids,Oocdids,costdataMap);
                } 
                else{
                    rollback_data(trans,rowcount,CostRec);
                }                
             }
              return response;
         }
         else{
            IOHandleRestRequestAndSendResponse iosync = new IOHandleRestRequestAndSendResponse();
            return iosync.deleteOldAndUpdateNewData(oppid, rowcount,trans,costRec,serviceGroup);
            
         }
        }
       /*
              @methodname : rollback_data
              @methodDescription : to delete new fte,other cost and payroll data when is trans is false (rollback). 
              @return type:void
       */
         public void rollback_data(FinalizeTransaction trans,integer rowcount,costing_request__c costRec){
             id costid = costRec.id;
             id oppid = trans.opportunityid;
              List<Other_Cost_Details__c> CCDData = new list<Other_Cost_Details__c>();
              list<Fte_details__c> ftedata = new list<FTE_details__c>();
              //reason for this boolean is to handle asynchronous invocation
              //this will stop updating of costing if roll back goes in asynchronous mode
              boolean updatecost=false;
            Opportunity opp = [select id,(Select id from FTE_Details__r where is_transient__c = true and Service_Group__c=: SWBBPOSEIntegrationConstants.BPO),
                                    (select id from Other_Cost_Details__r where is_transient__c = true and Service_Group__c=: SWBBPOSEIntegrationConstants.BPO) 
                                    from Opportunity where id=:oppid limit 1];          
             ftedata.addall(opp.FTE_Details__r);
             CCDData.addall(opp.Other_Cost_Details__r);
             system.debug('ftedata**************************************'+ftedata.size());
             system.debug('ccddata**************************************'+CCDData.size());
             Costing_Request__c costingRecord = new Costing_Request__c(id=costid);
              try{
                    if(ftedata.size()+ccddata.size() < 9000){
                        UtilConstants.allowactivation = true; 
                        database.delete(ftedata,true);
                        database.delete(ccddata,true);
                        costingRecord.Sync_Failed_At__c = SWBBPOSEIntegrationConstants.emptystring;
                        costingRecord.Data_Cleaning_dev__c=false;
                        costingRecord.in_sync__c = false;
                        costingRecord.calculation__c = false;
                        costingRecord.in_progress__c =SWBBPOSEIntegrationConstants.failurestatus;
                        costingRecord.Email_Dev__c=trans.enterpriseid+SWBBPOSEIntegrationConstants.attherateemail;
                        costingRecord.in_progress_io__c = CostRec.In_Progress_PrevState__c;
                        updatecost = true;
                     }
                    else{
                        database.executebatch(new DeletehugeBatchSync(oppid,costid,SWBBPOSEIntegrationConstants.BPO),400);
                       //ScopeUpdataion_FutureClass.deleteData_hugeChunk(oppid,'new',costid);
                     }
              }             
              catch(exception e){
                 ExceptionClass.logException(UtilConstants.HandleRestRequestAndSendResponse,UtilConstants.rollback_data,e,UtilConstants.SWB,UtilConstants.BPOSE);
                 costingRecord.Sync_Failed_At__c = SWBBPOSEIntegrationConstants.status;
                 costingRecord.Data_Cleaning_dev__c=true;
                 costingRecord.in_progress__c =SWBBPOSEIntegrationConstants.inprogressstatus;
                 updatecost = true;
              }
              finally{
                  if(updatecost){
                    update costingRecord;
                  }
              }            
        }
       /**************
        @methodname : insert_AndDeleteHeap
        @decription : method to perform insert and to remove heap size
       *****************/
       private boolean insert_AndDeleteHeap(List<sobject> genericlist){
        boolean response = false;
        try{
        system.debug('Main call hi nahi hua');
        UtilConstants.allowactivation = true; 
        database.insert (genericlist,true);
        response = true;
        }
        catch(exception e){
               ExceptionClass.logException(UtilConstants.HandleRestRequestAndSendResponse,UtilConstants.insert_AndDeleteHeap,e,UtilConstants.SWB,UtilConstants.BPOSE);
               response=false;
              }
        return response;
       }
       public string responseFunction(boolean bool){
        SyncDataRequest.SyncDataResponse syncresponse = new SyncDataRequest.SyncDataResponse();
        syncresponse.status = bool;
        string finalresponse = JSON.serialize(syncresponse);
        return finalresponse;
       }
}