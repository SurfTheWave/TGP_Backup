public class UpdateBatchSync implements Database.batchable<list<sobject>>,Database.Stateful{
    string srvgrp;
    list<list<sobject>> datalist;
    id Opportunityid;
    id costingId;
    boolean issuccess;
    set<id> ocIds;
    map<string,string> costingdata;
    public UpdateBatchSync (id oppid,map<string,string> costingJson,String serviceGroup){
        srvgrp=serviceGroup;
        UtilConstants.allowactivation = true;
        UtilConstants.allowstatusupdation = true;
        UtilConstants.IS_OPPTRIGGER_REQUIRED = false;
        datalist = new list<list<sobject>>();
        Opportunityid = oppid;
        ocIds = new set<id>();
        costingdata = costingJson;
        list<fte_details__c> ftelist = new list<fte_details__c>();
        list<Other_cost_details__c> ocdlist = new list<Other_cost_details__c>();
        list<Payroll__c> payrolldata= new List<Payroll__c>();
        list<Volume_Detail__c> volumedata= new List<Volume_Detail__c>();
        list<Cross_Deal__c> crossdealdata= new List<Cross_Deal__c>();
        if(serviceGroup.equalsIgnorecase(SWBBPOSEIntegrationConstants.BPO)){
            for(fte_details__c ft: [select id,is_transient__c, Costing_Request__c,Costing_Type__c,Mob_Category__c,
                                    Service_Dev__c,Location_typeCode__c
                                     from fte_details__c where Opportunity__c=:oppid and Service_Group__c=:SWBBPOSEIntegrationConstants.BPO limit 5000 ]){
                ftelist.add(ft);
                costingId = ft.Costing_Request__c;
            }
            for(Other_cost_details__c ot:[select id,is_transient__c, Costing_Request__c,Costing_Type__c,Mob_Category__c,
                                            Service_Dev__c,Cost_Type__c,Location_typeCode__c    
                                         from Other_cost_details__c where Opportunity__c=:oppid and Service_Group__c=:SWBBPOSEIntegrationConstants.BPO limit 5000]){
                ocdlist.add(ot);
                costingId = ot.Costing_Request__c;
                ocids.add(ot.Id);
            }
        }
        else{
            for(fte_details__c ft: [select id,is_transient__c, Costing_Request__c,Costing_Type__c,Mob_Category__c,
                                Service_Dev__c,Location_typeCode__c
                                from fte_details__c where Opportunity__c=:oppid AND is_transient__c=true AND 
                                (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC) limit 5000]){
                ftelist.add(ft);
                costingId = ft.Costing_Request__c;
            }
            for(Other_cost_details__c ot:[select id,is_transient__c, Costing_Request__c,Costing_Type__c,Mob_Category__c,
                                        Service_Dev__c,Cost_Type__c,Location_typeCode__c    
                                        from Other_cost_details__c where Opportunity__c=:oppid AND is_transient__c=true AND
                                        (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC) limit 5000]){
                ocdlist.add(ot);
                costingId = ot.Costing_Request__c;
                ocids.add(ot.Id);
            }
           for( Volume_Detail__c vRec:[select id,Cost__c from Volume_Detail__c where Opportunity__c=:oppid AND is_transient__c=true AND 
           (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC) limit 5000]){
                volumedata.add(vRec);
                costingId = vRec.Cost__c;
           }
           for(Cross_Deal__c cRec :[select id,Cost_Detail__c from Cross_Deal__c where Opportunity__c=:oppid AND is_transient__c=true limit 5000]){
                crossdealdata.add(cRec);
                costingId = cRec.Cost_Detail__c;
           }
            
        }
        system.debug('ocdlist --'+ocdlist );
        if(ftelist.size()>0){
            datalist.add((List<sObject>)ftelist);
        }
        //ftelist.clear();
        if(ocdlist.size()>0){
            datalist.add((List<sObject>)ocdlist);
        }
        if(!crossdealdata.isEmpty()){
                datalist.add((List<sObject>)crossdealdata);
        }
        if(!volumedata.isEmpty()){
                datalist.add((List<sObject>)volumedata);
        }
        
        system.debug('final size--'+datalist.size());
       //ocdlist.clear(); 
    }
     public Iterable<list<sObject>> start(Database.BatchableContext bc) {
         system.debug('datalist--'+datalist.size());
        return  datalist;
    }

    public void execute(Database.BatchableContext bc, List<list<sObject>> scope) {
        system.debug('scope size--'+scope.size()); 
        UtilConstants.IS_OPPTRIGGER_REQUIRED = false;       
        list<fte_details__c> ftelist = new list<fte_details__c>();
        list<Other_cost_details__c> ocdlist = new list<Other_cost_details__c>();
        list<Payroll__c> payrolldata= new List<Payroll__c>();
        list<Volume_Detail__c> volumedata= new List<Volume_Detail__c>();
        list<Cross_Deal__c> crossdealdata= new List<Cross_Deal__c>();
        set<id> fteids = new set<id>();
        set<id> ocdids = new set<id>();
        set<id> payrollids = new set<id>();
        set<id> volumeids = new set<id>();
        set<id> crossdealids = new set<id>();
        system.debug('combined list-->'+scope);
        if(scope[0].size()>0 ){
                if(scope[0] instanceof list<fte_details__c>){
                    ftelist  = ((list<fte_details__c>)scope[0]);
                }
                if(scope[0] instanceof list<Other_cost_details__c>){
                    ocdlist = ((list<Other_cost_details__c>)scope[0]);
                }
                if(scope[0] instanceof list<Volume_Detail__c>){
                    volumedata = ((list<Volume_Detail__c>)scope[0]);
                }
                if(scope[0] instanceof list<Cross_Deal__c>){
                    crossdealdata = ((list<Cross_Deal__c>)scope[0]);
                }
          }
          if(scope.size()>1){
                if(scope[1].size()>0 ){
                    if(scope[1] instanceof list<fte_details__c>){
                        ftelist  = ((list<fte_details__c>)scope[1]);
                    }
                    if(scope[1] instanceof list<Other_cost_details__c>){
                        ocdlist = ((list<Other_cost_details__c>)scope[1]);
                    }
                    if(scope[1] instanceof list<Volume_Detail__c>){
                        volumedata = ((list<Volume_Detail__c>)scope[1]);
                    }
                    if(scope[1] instanceof list<Cross_Deal__c>){
                        crossdealdata = ((list<Cross_Deal__c>)scope[1]);
                    }
                }
            }
            if(scope.size()>2){
                if(scope[2].size()>0){
                    if(scope[2] instanceof list<fte_details__c>){
                        ftelist  = ((list<fte_details__c>)scope[2]);
                    }
                    if(scope[2] instanceof list<Other_cost_details__c>){
                        ocdlist = ((list<Other_cost_details__c>)scope[2]);
                    }
                    if(scope[2] instanceof list<Volume_Detail__c>){
                        volumedata = ((list<Volume_Detail__c>)scope[2]);
                    }
                    if(scope[2] instanceof list<Cross_Deal__c>){
                        crossdealdata = ((list<Cross_Deal__c>)scope[2]);
                    }
                }
            }
            
           if(scope.size()>3){
                if(scope[3].size()>0){
                    if(scope[3] instanceof list<fte_details__c>){
                        ftelist  = ((list<fte_details__c>)scope[3]);
                    }
                    if(scope[3] instanceof list<Other_cost_details__c>){
                        ocdlist = ((list<Other_cost_details__c>)scope[3]);
                    }
                    if(scope[3] instanceof list<Volume_Detail__c>){
                        volumedata = ((list<Volume_Detail__c>)scope[3]);
                    }
                    if(scope[3] instanceof list<Cross_Deal__c>){
                        crossdealdata = ((list<Cross_Deal__c>)scope[3]);
                    }
                }
            }
            if(scope.size()>4){
                if(scope[4].size()>0){
                    if(scope[4] instanceof list<fte_details__c>){
                        ftelist  = ((list<fte_details__c>)scope[4]);
                    }
                    if(scope[4] instanceof list<Other_cost_details__c>){
                        ocdlist = ((list<Other_cost_details__c>)scope[4]);
                    }
                    if(scope[4] instanceof list<Volume_Detail__c>){
                        volumedata = ((list<Volume_Detail__c>)scope[4]);
                    }
                    if(scope[4] instanceof list<Cross_Deal__c>){
                        crossdealdata = ((list<Cross_Deal__c>)scope[4]);
                    }
                }
            }
        
        system.debug('fte list--->'+ftelist  );
        system.debug('ocd list--->'+ocdlist );
        list<fte_details__c> ftelist_toupdate = new list<fte_details__c>();
        list<Other_cost_details__c> ocdlist_toupdate = new list<Other_cost_details__c>();
        list<Volume_Detail__c> volumelist_toupdate= new List<Volume_Detail__c>();
        list<Cross_Deal__c> crossdeallist_toupdate= new List<Cross_Deal__c>();
        for(fte_details__c fte : ftelist){
            fte.is_transient__c = false; 
            fteids.add(fte.id);
            ftelist_toupdate.add(fte);
        }
        for(Other_cost_details__c ocd: ocdlist ){
            ocd.is_transient__c = false;
            ocdids.add(ocd.id);
            ocdlist_toupdate.add(ocd);
        }
        for(Volume_Detail__c vid: volumedata ){
            vid.is_transient__c = false;
            volumeids.add(vid.id);
            volumelist_toupdate.add(vid);
        }
        for(Cross_Deal__c cdid: crossdealdata ){
            cdid.is_transient__c = false;
            crossdealids.add(cdid.id);
            crossdeallist_toupdate.add(cdid);
        }
        try{
            SWBBPOSEIntegrationConstants.isExceutionFromSync = true;
            UtilConstants.issyncedOpp = true;
            SWBBPOSEIntegrationConstants.RunFTErollup = true;
            SWBBPOSEIntegrationConstants.rundeliverylocationtrigger = false; 
            SWBBPOSEIntegrationConstants.runsolScopeTrigger= true;
            Database.update (ocdlist_toupdate,true);
            Database.update (ftelist_toupdate,true);
            if(!volumelist_toupdate.isEmpty()){
                Database.update(volumelist_toupdate,true);
            }
            if(!crossdeallist_toupdate.isEmpty()){
                Database.update(crossdeallist_toupdate,true);
            }           
            issuccess = true;
        }catch(exception e){
            issuccess = false;
        }      
    }

    public void finish(Database.BatchableContext bc) {
    UtilConstants.IS_OPPTRIGGER_REQUIRED = true;
    SWBBPOSEIntegrationConstants.rundeliverylocationtrigger = false;
    Costing_Request__c cr = new Costing_Request__c(Id=costingId);
        if(issuccess = false){
            if(srvgrp.equalsIgnorecase(SWBBPOSEIntegrationConstants.BPO)){
                cr.In_Sync__c=false;
                cr.Sync_Failed_At__c=SWBBPOSEIntegrationConstants.finalcommit;
                cr.In_Progress__c = SWBBPOSEIntegrationConstants.failurestatus;
                cr.calculation__c = false;
            }
            else{
                cr.In_Sync_IO__c=false;
                cr.Sync_Failed_At_IO__c=SWBBPOSEIntegrationConstants.finalcommit;
                cr.In_Progress_IO__c = SWBBPOSEIntegrationConstants.failurestatus;
                cr.Calculation_IO__c = false;
            }
            update cr;
        }
        else{
            ScopeUpdataion_FutureClass.deleteOpportunityDeliveryLocation(Opportunityid);
            costing_request__c cost = new costing_request__c();
            id costid = costingData.get(SWBBPOSEIntegrationConstants.id);
            try{
                 cost = [select id,time_stamp__c,Time_Stamp_IO__c,In_Progress_PrevState__c from costing_request__c where id =:costid limit 1];
                 if(srvgrp.equalsIgnorecase(SWBBPOSEIntegrationConstants.BPO)){
                      ScopeUpdataion_FutureClass.maketechtoolsOOF(Opportunityid,SWBBPOSEIntegrationConstants.outofscope);
                      ScopeUpdataion_FutureClass.updatetechtoolsScope(Opportunityid,UtilConstants.IN_SCOPE,SWBBPOSEIntegrationConstants.Retained);
                     system.debug('======='+cost.time_stamp__c);
                     datetime dt = cost.time_stamp__c;
                     DateTime myDT;
                     if(dt !=null){
                        myDT = dt.addMinutes(5);
                     }
                     datetime currenttime = system.now();
                     system.debug('***********'+myDT+'time now is ::::::::'+currenttime);
                     if(currenttime >= myDT){
                        cost.Trigger_Final_Mail__c = true;
                     }
                     else{
                        cost.Trigger_Final_Mail__c = false;
                     }
                     BenchMark__c bnc = [select id from BenchMark__c where Opportunity__c =:Opportunityid AND 
                                            Service_group__c=:SWBBPOSEIntegrationConstants.BPO limit 1];
                     cost.Initial_Go_Live__c = date.parse(costingData.get(SWBBPOSEIntegrationConstants.initialgolive));
                     cost.Contract_Start__c = date.parse(costingData.get(SWBBPOSEIntegrationConstants.contractstart));
                     cost.Contract_End__c =date.parse(costingData.get(SWBBPOSEIntegrationConstants.contractend));
                     cost.SSM_Version__c = costingData.get(SWBBPOSEIntegrationConstants.ssmversion);
                     cost.Version__c =    costingData.get(SWBBPOSEIntegrationConstants.versionname);
                     cost.Synced_Scenario_Name__c =   costingData.get(SWBBPOSEIntegrationConstants.scenarioname);
                     cost.MRDB_Version__c=   costingData.get(SWBBPOSEIntegrationConstants.mrdbversion);
                     cost.MRDB_Last_Refresh_Date__c=   date.parse(costingData.get(SWBBPOSEIntegrationConstants.mrdblastrefreshdate));
                     cost.HasMasterDataBeenCustomizedForDeal__c = boolean.valueof(costingData.get(SWBBPOSEIntegrationConstants.HasMasterDataBeenCustomizedForDeal));
                     cost.Last_Synced_Date__c = system.now();
                     string usermas = costingData.get(SWBBPOSEIntegrationConstants.lastsyncedby) +'%';
                     user_master__C us = [select id,email__c from User_Master__c where email__c like : usermas AND active__c=true limit 1 ];
                     cost.Last_Synced_Up_By__c= us.id;
                     cost.VersionID__c =    costingData.get(SWBBPOSEIntegrationConstants.VersionID);
                     cost.In_Progress__c =SWBBPOSEIntegrationConstants.successstatus;
                     cost.in_progress_io__c=cost.In_Progress_PrevState__c;
                     cost.Cost_Summary_and_Metrics__c = bnc.id;
                     cost.Sync_Failed_At__c ='';
                     cost.Calculation__c = false;
                     cost.In_Sync__c = false;
                     cost.Email_Dev__c = us.email__c;
                     cost.Has_Updated__c = true;
                     update cost;
                     Opportunity Opp = new Opportunity(id= costingdata.get(SWBBPOSEIntegrationConstants.oppfield));
                     opp.is_synced__c = true;
                     opp.Initial_Go_live_Date__c = cost.Initial_Go_Live__c ;
                     opp.Contract_Start_Date__c = cost.Contract_Start__c ;
                     opp.Contract_End_Date__c = cost.Contract_End__c ;
                     cost.Last_Synced_Service__c=SWBBPOSEIntegrationConstants.BPO;
                     update opp;
                     // Update commercial data record with Benchmark opportunity ID
                     BenchmarkSync.updateCommercialData(Opportunityid);
                 }
                 else{
                   // IO logic
                   datetime dt = cost.time_stamp_io__c;
                     DateTime myDT;
                     if(dt !=null){
                        myDT = dt.addMinutes(5);
                     }
                     datetime currenttime = system.now();
                     system.debug('***********'+myDT+'time now is ::::::::'+currenttime);
                     if(currenttime >= myDT){
                        cost.Trigger_final_mail_IO__c = true;
                     }
                     else{
                        cost.Trigger_final_mail_IO__c = false;
                     }
                    ScopeUpdataion_FutureClass.updateScope(Opportunityid,SWBBPOSEIntegrationConstants.outofscope);
                    BenchMark__c bnc = [select id from BenchMark__c where Opportunity__c =:Opportunityid AND 
                                            Service_group__c=:SWBBPOSEIntegrationConstants.io limit 1];
                     cost.CostSummaryandMetrics_IO__c = bnc.id;
                    //ScopeUpdataion_FutureClass.updatetechtoolsScope(Opportunityid,UtilConstants.IN_SCOPE,'Retained');
                     cost.Initial_Go_Live__c = date.parse(costingData.get(SWBBPOSEIntegrationConstants.initialgolive));
                     cost.Contract_Start__c = date.parse(costingData.get(SWBBPOSEIntegrationConstants.contractstart));
                     cost.Contract_End__c =date.parse(costingData.get(SWBBPOSEIntegrationConstants.contractend));
                     cost.SSM_Version_IO__c = costingData.get(SWBBPOSEIntegrationConstants.ssmversionIO);
                     cost.Synced_Scenario_Name_IO__c =   costingData.get(SWBBPOSEIntegrationConstants.syncedScenarioNameIO);
                     cost.MRDB_Version_IO__c=   costingData.get(SWBBPOSEIntegrationConstants.mrdbVersionIo);
                     cost.MRDB_Last_Refresh_Date_IO__c=   date.parse(costingData.get(SWBBPOSEIntegrationConstants.mrdbLastRefreshDateIO));
                     cost.HasMasterDataBeenCustomizedForDealIO__c = boolean.valueof(costingData.get(SWBBPOSEIntegrationConstants.HasMasterDataBeenCustomizedForDealIO));
                     cost.Last_Synced_Date_IO__c = system.now();
                     string usermas = costingData.get(SWBBPOSEIntegrationConstants.lastsyncedupbyIO) +SWBBPOSEIntegrationConstants.likeparameter;
                     user_master__C us = [select id,email__c from User_Master__c where email__c like : usermas and active__c=true limit 1 ];
                     cost.Last_Synced_Up_By_IO__c= us.id;
                     cost.Version_IO__c =costingData.get(SWBBPOSEIntegrationConstants.VersionIO);
                     cost.version_id_io__c = costingData.get(SWBBPOSEIntegrationConstants.versionidio);
                     cost.In_Progress_IO__c =SWBBPOSEIntegrationConstants.successstatus;
                     cost.In_Progress__c = cost.In_Progress_PrevState__c;
                     cost.Sync_Failed_At_IO__c ='';
                     cost.Calculation_IO__c = false;
                     cost.In_Sync_IO__c = false;
                     cost.Email_Dev_IO__c = us.email__c;
                     cost.Has_Updated_IO__c = true;
                     cost.Last_Synced_Service__c=SWBBPOSEIntegrationConstants.io;
                     cost.CDR_Scenario_Name__c = costingData.get(SWBBPOSEIntegrationConstants.syncedScenarioNameIO);
                     cost.CDR_Sync_Date__c = system.today();
                     update cost;
                     Opportunity Opp = new Opportunity(id= costingdata.get(SWBBPOSEIntegrationConstants.oppfield));
                     opp.Is_Synced_IO__c= true;
                     opp.Initial_Go_live_Date__c = cost.Initial_Go_Live__c ;
                     opp.Contract_Start_Date__c = cost.Contract_Start__c ;
                     opp.Contract_End_Date__c = cost.Contract_End__c ;
                     update opp;
                 }

            }
            catch(exception e){
              ExceptionClass.logException(SWBBPOSEIntegrationConstants.updatebatch,SWBBPOSEIntegrationConstants.finalmethod,e,UtilConstants.SWB,UtilConstants.BPOSE);
              costing_request__c cos = new costing_request__c(id=costid);
              sync_status__C syncstatus = [select id from sync_Status__c where 
                                        opportunity__c=:costingdata.get(SWBBPOSEIntegrationConstants.oppfield) limit 1];
              if(srvgrp.equalsIgnorecase(SWBBPOSEIntegrationConstants.BPO)){              
                    cos.In_Progress__c =SWBBPOSEIntegrationConstants.failurestatus;
                    cos.Sync_Failed_At__c =SWBBPOSEIntegrationConstants.sync;
                    cos.Calculation__c = false;
                    cos.Data_Cleaning_dev__c = false;
                    cos.in_progress_io__c=cost.In_Progress_PrevState__c;
                    syncstatus.error__C= e.getMessage();
              }
              else{
                  cos.In_Progress_IO__c =SWBBPOSEIntegrationConstants.failurestatus;
                  cos.Sync_Failed_At_IO__c =SWBBPOSEIntegrationConstants.sync;
                  cos.Calculation_IO__c = false;
                  cos.Data_Cleaning_dev_IO__c = false;
                  cos.in_progress__c=cost.In_Progress_PrevState__c;
                  syncstatus.error_io__C= e.getMessage();
              }
              update cos;
              update syncstatus;
            }
            finally{
                try{
                  id payrollinsert= database.executeBatch(new BatchFTEOtherCost(costingdata.get(SWBBPOSEIntegrationConstants.oppfield),srvgrp));
                }
                catch(Exception e){
                ExceptionClass.logException(SWBBPOSEIntegrationConstants.payrollinsertion,SWBBPOSEIntegrationConstants.finalmethod,e,UtilConstants.SWB,UtilConstants.BPOSE);
                    
                }
            }
        }
        
    }
}