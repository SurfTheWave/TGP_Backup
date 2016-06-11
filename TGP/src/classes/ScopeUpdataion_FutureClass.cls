/* ScopeUpdataion_FutureClass Class */ 
global without sharing class ScopeUpdataion_FutureClass {
    
    
       /*************************
       @method Name: updateScope
       @parameters : set<id> servids,set<id> offMasterids,string status,boolean active
       @output :
       @returntype : void
       *****************************/
    public static void updateScope(id oppid,string status){
        list<sobject> genericlist = new list<sobject>();
        list<service__c> servlist = new list<service__c>();
        list<Tech_Tools__c> techlist = new list<Tech_Tools__c>();
        List<ExceptionLog__c> exceptions=new list<ExceptionLog__c>();
        list<Solution_Scope__c> offmasterlist = new list<Solution_Scope__c>();
        list<Service_Components__c> servcomplist = new list<Service_Components__c>();
                String ss=oppid;
                UtilConstants.allowactivation = true;
            for(service__c serv: [select id,active__c,Scope_Status__c,Solutionscope__r.active__c,Out_Of_Scope_Reason__c from service__c where 
            Opportunity_Id_Dev__c=:ss.substring(0,15) AND FTE_Revenue__c=0 AND Other_Cost_Revenue__c=0 AND Payroll_Revenue_c__c=0 AND volume_revenue__c=0 AND service_group__c=:UtilConstants.IO LIMIT 5000]){
                serv.Scope_Status__c = status;
                //serv.Solutionscope__r.active__c = false;
                //serv.Out_Of_Scope_Reason__c=UtilConstants.Other;
                servlist.add(serv);
            }
           for(Solution_Scope__c off:[select id,active__c from Solution_Scope__c where Opportunity__c =:oppid AND
                                     FTE_Revenue__c=0 AND Other_Cost_Revenue__c=0 AND Payroll_Revenue__c =0 AND service_group__c=:UtilConstants.IO limit 5000]){
                off.active__c = false;
                //off.offering_description__c=UtilConstants.offering_description;
                offmasterlist.add(off);
            }
           /* for(Tech_Tools__c ttc : [select id,Scope_Status__c from Tech_Tools__c where Service__r.Opportunity_Id_Dev__c=:ss.substring(0,15) LIMIT 5000]){
                ttc.Scope_Status__c = status;
                techlist.add(ttc);
            }*/
            for(Service_Components__c solc: [select id,active__c,Service_Component_Status__c from Service_Components__c where 
            Service__r.Opportunity_Id_Dev__c=:ss.substring(0,15) limit 5000]){
                //solc.Service_Component_Status__c  = UtilConstants.EMPTY_STRING;
                solc.active__c=true;
                servcomplist.add(solc);
            }
        /*genericlist.addAll((List<sObject>)(servlist));
        genericlist.addAll((List<sObject>)(offmasterlist));
        genericlist.addAll((List<sObject>)(techlist));
        genericlist.addAll((List<sObject>)(servcomplist));
        genericlist.sort();*/
        try{
            SWBBPOSEIntegrationConstants.isExceutionFromSync = true;
            database.update(servlist,true);
            database.update(servcomplist,true);
            database.update(offmasterlist,true);
            IOCostModelFuture.calcOppFte(oppid);
        }
        catch(exception e){
            ExceptionClass.logException(UtilConstants.ScopeUpdataion_FutureClass,
            UtilConstants.updateScope,e,UtilConstants.SWB,UtilConstants.BPOSE);
        }
    }
    /* updateScopeService */
  /*  public static void updateScopeService(Set<Id> oppid,string status,boolean active){
        list<sobject> genericlist = new list<sobject>();
        list<service__c> servlist = new list<service__c>();
        list<Tech_Tools__c> techlist = new list<Tech_Tools__c>();
        List<ExceptionLog__c> exceptions=new list<ExceptionLog__c>();
        list<Solution_Scope__c> offmasterlist = new list<Solution_Scope__c>();
        list<Service_Components__c> servcomplist = new list<Service_Components__c>();
               // String ss=oppid;
                UtilConstants.allowactivation = true;
            for(service__c serv: [select id,Scope_Status__c,Out_Of_Scope_Reason__c from service__c where Opportunity_Id_Dev__c IN:oppid LIMIT 5000]){
                serv.Scope_Status__c = status;
                //serv.Out_Of_Scope_Reason__c=UtilConstants.Other;
                servlist.add(serv);
            }
            for(Solution_Scope__c off:[select id,active__c from Solution_Scope__c where Opportunity__c IN :oppid limit 5000]){
                off.active__c = active;
                //off.offering_description__c=UtilConstants.offering_description;
                offmasterlist.add(off);
            }
            
        genericlist.addAll((List<sObject>)(servlist));
        genericlist.addAll((List<sObject>)(offmasterlist));
        
        genericlist.sort();
        try{
            database.update(genericlist,true);
        }
        catch(exception e){
            ExceptionClass.logException(UtilConstants.ScopeUpdataion_FutureClass,UtilConstants.updateScope,e,UtilConstants.SWB,UtilConstants.BPOSE);
        }
    }
    */
    
     /*************************
       @method Name: insertCountryInMaster
       @parameters : set<id> servids,set<id> offMasterids,string status,boolean active
       @output :
       @returntype : void
       *****************************/
      /*  @future
        public static void insertCountryInMaster(Set<id> ftedataList,Set<id> ccddataList){
            system.debug('FTE IDS-----------------------------------------------------------------------------'+ftedataList);
            system.debug('ccd IDS-----------------------------------------------------------------------------'+ccddataList);
            //system.debug('payroll IDS-----------------------------------------------------------------------------'+payrollids);
            List<ExceptionLog__c> exceptions=new list<ExceptionLog__c>();
            List<Country_Master__c> countryMasterToInsert=new List<Country_Master__c>();
            List<FTE_Details__c> fteDataToUpdate=new List<FTE_Details__c>();
            List<other_cost_details__c> ccdDataToUpdate=new List<other_cost_details__c>();
            //List<Payroll__c> payrollDataToUpdate=new List<Payroll__c>();
            List<sObject> genericDatatoupdate=new List<sObject>();
            boolean isSucsess=false;
            map<String,id> updatedCountryMaster=new map<String,id>();
            Set<String> countryNotInMaster=new Set<String>();
            
            for(FTE_Details__c fte :[Select Country_Dev__c from FTE_Details__c where id in:ftedataList LIMIT 5000]){
                countryNotInMaster.add(fte.Country_Dev__c);
            }
            
            for(other_cost_details__c ccd :[Select Country_Dev__c from other_cost_details__c where id in:ccddataList LIMIT 5000]){
                countryNotInMaster.add(ccd.Country_Dev__c);
            }
            if(!countryNotInMaster.isEmpty()){
                for(String con:countryNotInMaster){
                    Country_Master__c country =new Country_Master__c();
                    country.name=con;
                    countryMasterToInsert.add(country);
                }   
                    
                try{
                    if(!countryMasterToInsert.isEmpty()){
                        database.insert(countryMasterToInsert,true);
                        isSucsess=true;
                    }
                }
                catch(exception e){
                ExceptionClass.logException(UtilConstants.ScopeUpdataion_FutureClass,UtilConstants.insertCountryInMaster,e,UtilConstants.SWB,UtilConstants.BPOSE);
                }
          }
        
        //updating fte and ccd records
        if(isSucsess){
          for(Country_Master__c country :[select name from Country_Master__c limit 500]){
                     updatedCountryMaster.put(country.name,country.id);
              }
          if(updatedCountryMaster!=null){ 
            //insert fte 
            for(FTE_Details__c fte:[Select Country_Dev__c,Country__c,id from FTE_Details__c where id in:ftedataList and Country_Dev__c!=null LIMIT 5000]){
                if(updatedCountryMaster.get(fte.Country_Dev__c) != null){
                           fte.Country__c = updatedCountryMaster.get(fte.Country_Dev__c);
                  }
                  fteDataToUpdate.add(fte);
            }
            
            for(other_cost_details__c ccd:[Select Country_Dev__c,Country__c,id from other_cost_details__c where id in:ccddataList and Country_Dev__c!=null LIMIT 5000]){
                if(updatedCountryMaster.get(ccd.Country_Dev__c) != null){
                           ccd.Country__c = updatedCountryMaster.get(ccd.Country_Dev__c);
                  }
                  ccdDataToUpdate.add(ccd);
            }
            
            /*for(Payroll__c payroll:[Select Country_Dev__c,Country_Master__c,id from Payroll__c where id in:payrollids and Country_Dev__c!=null LIMIT 5000]){
                if(updatedCountryMaster.get(payroll.Country_Dev__c) != null){
                           payroll.Country_Master__c = updatedCountryMaster.get(payroll.Country_Dev__c);
                  }
                  payrollDataToUpdate.add(payroll);
            }*/
            
           /*}*/
           /*
           
           if(!ccdDataToUpdate.isEmpty()|| !ccdDataToUpdate.isEmpty()){
            genericDatatoupdate.addAll((List<sObject>)(fteDataToUpdate));
            genericDatatoupdate.addAll((List<sObject>)(ccdDataToUpdate));
            //genericDatatoupdate.addAll((List<sObject>)(payrollDataToUpdate)); 
           }
           try{
                     if(!genericDatatoupdate.isEmpty()){
                        genericDatatoupdate.sort();
                        database.update(genericDatatoupdate,true);
                    }
                }
                catch(exception e){
                   ExceptionClass.logException(UtilConstants.ScopeUpdataion_FutureClass,UtilConstants.insertCountryInMaster,e,UtilConstants.SWB,UtilConstants.BPOSE);
                }
        }  
    }
       
       */
       public static void maketechtoolsOOF(id oppid,string status){
           UtilConstants.stopTriggersForIO = false;
           list<sobject> genericlist = new list<sobject>();
           list<Tech_Tools__c> techlist = new list<Tech_Tools__c>();
           list<Service_Components__c> servcomplist = new list<Service_Components__c>();
           String ss=oppid;
           list<service__c> servlist = new list<service__c>();
           list<Solution_Scope__c> scopelist = new list<solution_scope__C>();
           UtilConstants.allowactivation = true;
           utilconstants.allowstatusupdation = true;
           for(service__c serv: [select id,Scope_Status__c,Out_Of_Scope_Reason__c from service__c where 
                                    Opportunity_Id_Dev__c =: ss.substring(0,15) AND FTE_Revenue__c=0 AND Other_Cost_Revenue__c=0 
                                    AND Payroll_Revenue_c__c =0 AND Solutionscope__r.service_group__c=:SWBBPOSEIntegrationConstants.BPO LIMIT 5000]){
                serv.Scope_Status__c = UtilConstants.OUT_SCOPE;
                //serv.Out_Of_Scope_Reason__c=UtilConstants.Other;
                servlist.add(serv);
            }
            for(Solution_Scope__c off:[select id,active__c from Solution_Scope__c where Opportunity__c =:oppid AND
                                     FTE_Revenue__c=0 AND Other_Cost_Revenue__c=0 AND Payroll_Revenue__c =0 AND service_group__c=:UtilConstants.BPO limit 5000]){
                off.active__c = false;
                //off.offering_description__c=UtilConstants.offering_description;
                scopelist.add(off);
            }
           for(Tech_Tools__c ttc : [select id,Scope_Status__c from Tech_Tools__c where 
           Service__r.Opportunity_Id_Dev__c=:ss.substring(0,15) LIMIT 5000]){
                ttc.Scope_Status__c = status;
                techlist.add(ttc);
            }
            for(Service_Components__c solc: [select id,Service_Component_Status__c from 
            Service_Components__c where Service__r.Opportunity_Id_Dev__c=:ss.substring(0,15) limit 5000]){
                solc.Service_Component_Status__c  = UtilConstants.EMPTY_STRING;
                servcomplist.add(solc);
            }
        genericlist.addAll((List<sObject>)(techlist));
        genericlist.addAll((List<sObject>)(servcomplist));
        genericlist.sort();
        try{
            SWBBPOSEIntegrationConstants.isExceutionFromSync = true;
            database.update(scopelist,true);
            database.update(Servlist,true);
            database.update(genericlist,true);
        }
        catch(exception e){
            ExceptionClass.logException(UtilConstants.ScopeUpdataion_FutureClass,
            UtilConstants.updateScope,e,UtilConstants.SWB,UtilConstants.BPOSE);
        }
       }
       /*updatetechtoolsScope */
        public static void updatetechtoolsScope(id oppid,string status,string solcomStatus){
        UtilConstants.stopTriggersForIO = false;
    //    system.debug('inside scope updation');
        List<ExceptionLog__c> exceptions=new list<ExceptionLog__c>();
        list<sobject> genericlist = new list<sobject>();
        list<service__c> servlist = new list<service__c>();
        list<Tech_Tools__c> techlist = new list<Tech_Tools__c>();
        list<Service_Components__c> servcomplist = new list<Service_Components__c>();
        set<id> servids = new set<id>();
        set<id> offMasterids = new set<id>();
        set<id> servcompids= new set<id>();
        set<id> techids = new set<id>();
        
        list<Solution_Scope__c> offmasterlist = new list<Solution_Scope__c>();
        for(fte_details__c fte : [select service__c,Sub_Service_Group__c,service_component__c 
                                    from fte_details__c where Opportunity__c=:oppid LIMIT 5000]){
           /* if(fte.service__c != null){
                servids.add(fte.service__c);
            }
            if(fte.Sub_Service_Group__c != null){
                offMasterids.add(fte.Sub_Service_Group__c);
            }  */              
            if(fte.service_component__c != null){
                servcompids.add(fte.service_component__c );
            }
            
        }
        for(Other_Cost_Details__c ccd : [select service__c,Sub_Service_Group__c,Tech_Tools__c,service_component__c
                                    from Other_Cost_Details__c where Opportunity__c=:oppid LIMIT 5000]){
           /* if(ccd.service__c != null){
                servids.add(ccd.service__c);
            }
            if(ccd.Sub_Service_Group__c != null){
                offMasterids.add(ccd.Sub_Service_Group__c);
            }*/
            if(ccd.Tech_Tools__c != null){
                techids.add(ccd.Tech_Tools__c);
            }
            if(ccd.service_component__c != null){
                 servcompids.add(ccd.service_component__c );
            }
           
        }
        UtilConstants.allowactivation = true;
        utilconstants.allowstatusupdation = true;
          /*  
            for(Id servId: servids){
                service__c serv = new service__c (id=servId);
                serv.Scope_Status__c = status;
                serv.Out_Of_Scope_Reason__c=UtilConstants.emptyStr;
                servlist.add(serv);
            }
            for(Id offId:offMasterids){
                Solution_Scope__c off = new Solution_Scope__c(Id = offId);
                off.active__c = active;
                offmasterlist.add(off);
            }*/
            for(Id ttId : techids){
                Tech_Tools__c ttc = new Tech_Tools__c(Id=ttId);
                ttc.Scope_Status__c = status;
                techlist.add(ttc);
            }
            for(Id solId: servcompids){
                Service_Components__c solc = new Service_Components__c(Id=solId);
                //solc.Service_Component_Status__c  = solcomStatus;
                solc.active__c  = true;
                servcomplist.add(solc);
            }
       /* if(servlist.size()>0){
            genericlist.addAll((List<sObject>)(servlist));
        }   
        if(offmasterlist.size()>0){
            genericlist.addAll((List<sObject>)(offmasterlist));
        } */
        if(techlist.size()>0){
            genericlist.addAll((List<sObject>)(techlist));
        } 
        if(servcomplist.size()>0){
            genericlist.addAll((List<sObject>)(servcomplist));
        } 
        
        genericlist.sort();
        try{
            SWBBPOSEIntegrationConstants.isExceutionFromSync = true;
            database.update(genericlist,true);
        }
        catch(exception e){
           ExceptionClass.logException(UtilConstants.ScopeUpdataion_FutureClass,
           UtilConstants.commit_RollBack,e,UtilConstants.SWB,UtilConstants.BPOSE);
        }
    }
       
       /*************************
       @method Name: updateInScope
       @parameters : set<id> fteids,set<id> ocdids,string status,boolean active
       @output :
       @returntype : void
       *****************************/    
   /* public static void updateInScope(set<id> fteids,set<id> ocdids,string status,string solcomStatus,boolean active){
    //    system.debug('inside scope updation');
        List<ExceptionLog__c> exceptions=new list<ExceptionLog__c>();
        list<sobject> genericlist = new list<sobject>();
        list<service__c> servlist = new list<service__c>();
        list<Tech_Tools__c> techlist = new list<Tech_Tools__c>();
        list<Service_Components__c> servcomplist = new list<Service_Components__c>();
        set<id> servids = new set<id>();
        set<id> offMasterids = new set<id>();
        set<id> servcompids= new set<id>();
        set<id> techids = new set<id>();
        list<Solution_Scope__c> offmasterlist = new list<Solution_Scope__c>();
        for(fte_details__c fte : [select service__c,Sub_Service_Group__c,service_component__c 
                                    from fte_details__c where ID IN:fteids LIMIT 5000]){
            if(fte.service__c != null){
                servids.add(fte.service__c);
            }
            if(fte.Sub_Service_Group__c != null){
                offMasterids.add(fte.Sub_Service_Group__c);
            }                
            if(fte.service_component__c != null){
                servcompids.add(fte.service_component__c );
            }
            
        }
        for(Other_Cost_Details__c ccd : [select service__c,Sub_Service_Group__c,Tech_Tools__c,service_component__c
                                    from Other_Cost_Details__c where ID IN:ocdids LIMIT 5000]){
           if(ccd.service__c != null){
                servids.add(ccd.service__c);
            }
            if(ccd.Sub_Service_Group__c != null){
                offMasterids.add(ccd.Sub_Service_Group__c);
            }
            if(ccd.Tech_Tools__c != null){
                techids.add(ccd.Tech_Tools__c);
            }
            if(ccd.service_component__c != null){
                 servcompids.add(ccd.service_component__c );
            }
           
        }
        UtilConstants.allowactivation = true;
           
            for(Id servId: servids){
                service__c serv = new service__c (id=servId);
                serv.Scope_Status__c = status;
                serv.Out_Of_Scope_Reason__c=UtilConstants.emptyStr;
                servlist.add(serv);
            }
            for(Id offId:offMasterids){
                Solution_Scope__c off = new Solution_Scope__c(Id = offId);
                off.active__c = active;
                offmasterlist.add(off);
            }
            for(Id ttId : techids){
                Tech_Tools__c ttc = new Tech_Tools__c(Id=ttId);
                ttc.Scope_Status__c = status;
                techlist.add(ttc);
            }
            for(Id solId: servcompids){
                Service_Components__c solc = new Service_Components__c(Id=solId);
                solc.Service_Component_Status__c  = solcomStatus;
                servcomplist.add(solc);
            }
        if(servlist.size()>0){
            genericlist.addAll((List<sObject>)(servlist));
        }   
        if(offmasterlist.size()>0){
            genericlist.addAll((List<sObject>)(offmasterlist));
        } 
        if(techlist.size()>0){
            genericlist.addAll((List<sObject>)(techlist));
        } 
        if(servcomplist.size()>0){
            genericlist.addAll((List<sObject>)(servcomplist));
        } 
        
        genericlist.sort();
        try{
            database.update(genericlist,true);
        }
        catch(exception e){
           ExceptionClass.logException(UtilConstants.ScopeUpdataion_FutureClass,UtilConstants.commit_RollBack,e,UtilConstants.SWB,UtilConstants.BPOSE);
        }
    }*/
    
    /* commitNewRecords_sync */
   /* @future (limits='3xHEAP')
    public static void commitNewRecords_sync(set<id> fteids,set<id> ocdids,id oppId,id costid){
           UtilConstants.allowactivation = true; 
           List<ExceptionLog__c> exceptions=new list<ExceptionLog__c>();
           list<sobject> genericlist1 = new list<sobject>();
           list<Payroll__c> payrolllist = new list<Payroll__c>();
           list<Fte_details__c> ftedata = new list<FTE_details__c>();
           List<Other_Cost_Details__c> CCDData = new list<Other_Cost_Details__c>();
           list<Fte_details__c> ftedata_final = new list<FTE_details__c>();
           List<Other_Cost_Details__c> CCDData_final = new list<Other_Cost_Details__c>();
           Opportunity opp = [select id,Is_Synced__c,(Select id from FTE_Details__r where is_transient__c = true LIMIT 200),
                                            (select id from Other_Cost_Details__r where is_transient__c = true LIMIT 200) 
                                            from Opportunity where id=:oppid limit 5000];
                    ftedata.addALL(opp.FTE_Details__r);
                    CCDData.addALL(opp.Other_Cost_Details__r);
                     
        
            /*for(Fte_details__c fte :ftedata){
               ftedata_final.add(fte);
            }
            for(Other_Cost_Details__c ccd : CCDData){
               CCDData_final.add(ccd);
             }*/
            /* for(Payroll__c payroll : [select id from payroll__c where Opportunity__c =: oppid limit 5000]){
                payrolllist.add(payroll);
             }
             try{
                //database.update (genericlist1,true);
                if(!payrolllist.isEmpty()){
                    database.delete (payrolllist,true);
                }
                Costing_Request__c costingRecord =new Costing_Request__c(id=costid);
                costingRecord.Last_Synced_Date__c=system.now();
                costingRecord.In_Sync__c=false;
                costingRecord.Has_Updated__c =true;
                update  costingRecord ;                                  
                //FTEDetailsTriggerOperations.populatePayrollData(ftedata);
                //OtherCostTriggerOperation.populatePayrollData(CCDData);
                //maketechtoolsOOF(oppid,UtilConstants.OUT_SCOPE);
                //updatetechtoolsScope(fteids,ocdids,UtilConstants.IN_SCOPE,'Retained');
                //BenchmarkSync.populateBenchMarkObjs(oppId);
                deleteOpportunityDeliveryLocation(oppId);
                insertTechTool(ocdids,oppId);
                //Benchmark calculation 
                /****
                Queue 2
                ***/
                //ID jobID = System.enqueueJob(new BenchmarkCalulationQueue(oppId));
                 //BenchmarkSync.populateBenchMarkObjs(oppId);
                //Mob Analytics Calculation on Opportunity
                /****
                Queue 3
                ***/
                //ID jobID = System.enqueueJob(new OppAnalyticCalcQueue(oppId));
                //OppAnalyticCalcQueue  oppmobAnalytic = new OppAnalyticCalcQueue (oppId);
                //System.enqueueJob(oppmobAnalytic );
                //OppAnalyticCalc.calcAnalyticsOnOpp(oppId);
                //MobAnalyticsUtil.proccessFTEOtherCost(oppId);
              /*}
              catch (exception e){
                ExceptionClass.logException(UtilConstants.ScopeUpdataion_FutureClass,UtilConstants.commitNewRecords,e,UtilConstants.SWB,UtilConstants.BPOSE);
              }
    }*/
    //@future(limits='3xDMLRows')
    /* commitNewRecords */
  /* public static void commitNewRecords(set<id> fteids,set<id> ocdids,id oppId){
           List<ExceptionLog__c> exceptions=new list<ExceptionLog__c>();
           list<sobject> genericlist1 = new list<sobject>();
           list<Payroll__c> payrolllist = new list<Payroll__c>();
           list<Fte_details__c> ftedata = new list<FTE_details__c>();
           List<Other_Cost_Details__c> CCDData = new list<Other_Cost_Details__c>();
           list<Fte_details__c> ftedata_final = new list<FTE_details__c>();
           List<Other_Cost_Details__c> CCDData_final = new list<Other_Cost_Details__c>();
           //Set<Id>ocdids=new set<id>();
           Opportunity opp = [select id,Is_Synced__c,(Select id from FTE_Details__r where is_transient__c = true LIMIT 200),
                                            (select id from Other_Cost_Details__r where is_transient__c = true LIMIT 200) 
                                            from Opportunity where id=:oppid limit 5000];
                    ftedata.addALL(opp.FTE_Details__r);
                    CCDData.addALL(opp.Other_Cost_Details__r);
                     
        
            for(Fte_details__c fte :ftedata){
                     fte.is_transient__c = false;
                     ftedata_final.add(fte);
            }
            for(Other_Cost_Details__c ccd : CCDData){
                   ccd.is_transient__c = false;
                   CCDData_final.add(ccd);
                   //ocdids.add(ccd.id);
             }
             
              for(Payroll__c payroll : [select id from payroll__c where Opportunity__c =: oppid limit 5000]){
         
                      payrolllist.add(payroll);
              }
         
         
            

              //genericlist1.sort();
              try{
                //database.update (genericlist1,true);
                database.update(ftedata,true);
                database.update (CCDData,true);
                if(!payrolllist.isEmpty()){
                    database.delete (payrolllist,true);
                }
                Costing_Request__c costingRecord =new Costing_Request__c();
                costingRecord =[SELECT Id,In_Progress__c, In_Sync__c,Calculation__c,Last_Synced_Date__c FROM Costing_Request__c 
                                      where Opportunity__c=:oppId LIMIT 1];
                                                               
                       costingRecord.Last_Synced_Date__c=system.now();
                       costingRecord.In_Sync__c=false;
                       costingRecord.Has_Updated__c =true;
                       costingRecord.In_Progress__c = UtilConstants.ONE_1;
                       costingRecord.Calculation__c = false;
                       update  costingRecord ;                                  
                //FTEDetailsTriggerOperations.populatePayrollData(ftedata);
                //OtherCostTriggerOperation.populatePayrollData(CCDData);
                //updateScope(oppid,UtilConstants.OUT_SCOPE,false);
                //updateInScope(fteids,ocdids,UtilConstants.IN_SCOPE,'Retained',true);
                //BenchmarkSync.populateBenchMarkObjs(oppId);
                deleteOpportunityDeliveryLocation(oppId);
                insertTechTool(ocdids,oppId);
                //Benchmark calculation 
                
                //ID jobID = System.enqueueJob(new BenchmarkCalulationQueue(oppId));
                //Mob Analytics Calculation on Opportunity
                
                //ID jobID = System.enqueueJob(new OppAnalyticCalcQueue(oppId));
                //OppAnalyticCalcQueue  oppmobAnalytic = new OppAnalyticCalcQueue (oppId);
                //System.enqueueJob(oppmobAnalytic );
                //OppAnalyticCalc.calcAnalyticsOnOpp(oppId);
                //MobAnalyticsUtil.proccessFTEOtherCost(oppId);
              }
              catch (exception e){
                ExceptionClass.logException(UtilConstants.ScopeUpdataion_FutureClass,UtilConstants.commitNewRecords,e,
                UtilConstants.SWB,UtilConstants.BPOSE);
               
              }
   }*/
   /* deleteData_hugeChunk */
   @future//(limits='2xDMLRows')
   public static void deleteData_hugeChunk(id oppid,string type,id costid){
    list<Payroll__c> payrolllist = new list<Payroll__c>();
    list<Fte_details__c> ftedata = new list<FTE_details__c>();
    List<Other_Cost_Details__c> CCDData = new list<Other_Cost_Details__c>();
    Opportunity opp = new Opportunity();
    if(UtilConstants.OLD.equalsignorecase(type)){
     opp = [select id,Is_Synced__c,(Select id from FTE_Details__r where is_transient__c = false LIMIT 200),
                                            (select id from Other_Cost_Details__r where is_transient__c = false LIMIT 200) 
                                            from Opportunity where id=:oppid limit 5000];
    }
    else{
         opp = [select id,Is_Synced__c,(Select id from FTE_Details__r where is_transient__c = true LIMIT 200),
                                            (select id from Other_Cost_Details__r where is_transient__c = true LIMIT 200) 
                                            from Opportunity where id=:oppid limit 5000];
    }
                    ftedata.addALL(opp.FTE_Details__r);
                    CCDData.addALL(opp.Other_Cost_Details__r);
    if(!ftedata.isempty() || !ccddata.isempty()){
              for(Payroll__c payroll : [select id from payroll__c where 
                                  (FTE_Details__c IN:ftedata OR Other_Cost_Details__c IN:ccddata) AND 
                                  Opportunity__c =: oppid limit 5000]){
                      Payroll.is_transient__c = false;
                      payrolllist.add(payroll);
              }
            }
            boolean issuccess = false;
            costing_request__c costrecord = new costing_request__c(id=costid);
        try{
         database.delete (ftedata,true);
         database.delete (ccddata,true);
         database.delete (payrolllist,true);
         costrecord.in_progress__c = UtilConstants.ZERO;
         costrecord.sync_Failed_at__c=UtilConstants.EMPTY_STRING;
         costrecord.Data_Cleaning_dev__c=false;
          
        }
        catch(exception e){
         costrecord.Sync_Failed_At__c =UtilConstantsR3.ROLL_BACK_FAILED;
         costrecord.Data_Cleaning_dev__c=true;
        costrecord.in_progress__c =UtilConstants.TWO_2;
        }
        finally{
            update costrecord;
        }
        
   }
   
    /*************************
       @method Name: insertTechTool
       @parameters : s,set<id> ocdids,opportunity id
       @output :
       @returntype : void
       *****************************/    
       public static void insertTechTool(set<id> ocdids,Id OpportunityId){
        List<ExceptionLog__c> exceptions=new list<ExceptionLog__c>();
        map<String,id> missingTechtoolservice=new map<String,id>();
        map<String,String> missingTechtoolname=new map<String,String>();
        map<String,id> missingcustomtool=new map<String,id>();
        map<String,id> newTechtool=new map<String,id>();
        map<String,String> offeringname=new map<String,String>();
        List<Tech_Tools__c> techToolsToInsert =new List<Tech_Tools__c>();
        set<tech_tools__c> removedups = new set<tech_tools__c>();
       // Tech_Tool_Master__c techtoolmaster=[Select id,name from Tech_Tool_Master__c where name=:UtilConstants.CustomTools and ];
        for(Other_Cost_Details__c ccd : [select id,Tech_Tools__c,Offering2__c,Service__c,Sub_Service_Group__r.Offering_Master__r.name
                                    from Other_Cost_Details__c where ID IN:ocdids and 
                                    Tech_Tools__c=null and Service_Dev__c=:UtilConstants.TECH_TOOLS LIMIT 5000]){
            if(ccd.Offering2__c!=null){
            missingTechtoolservice.put(ccd.id+UtilConstants.EMPTY_STRING+ccd.Service__c,ccd.Service__c);
            missingTechtoolname.put(ccd.id+UtilConstants.EMPTY_STRING+ccd.Service__c,ccd.Offering2__c);
            offeringname.put(ccd.id+UtilConstants.EMPTY_STRING+ccd.Service__c,ccd.Sub_Service_Group__r.Offering_Master__r.name);
            }
            
        }
        
        for(Tech_Tool_Master__c toolmaster:[Select id,name,Services__r.offering__r.name from 
        Tech_Tool_Master__c where name=:UtilConstants.CustomTools and Services__r.name =:UtilConstants.TECH_TOOLS LIMIT 5000]){
            missingcustomtool.put(toolmaster.Services__r.offering__r.name,toolmaster.id);
        }
        
        
        for(String i:missingTechtoolservice.keyset()){
            Tech_Tools__c techtooltoinsert=new Tech_Tools__c();
            
            techtooltoinsert.Service__c=missingTechtoolservice.get(i);
            techtooltoinsert.Custom_Tool_Name__c=missingTechtoolname.get(i);
            techtooltoinsert.Tech_Tool__c=missingcustomtool.get(offeringname.get(i));
            techtooltoinsert.Scope_Status__c=UtilConstants.IN_SCOPE;
            techToolsToInsert.add(techtooltoinsert);
        }
        try{
          String opportunityid1=OpportunityId;
          removedups.addAll(techToolsToInsert);
          techToolsToInsert.clear();
          techToolsToInsert.addAll(removedups);
            database.insert(techToolsToInsert,true);
             map<String,id> transactionalCustomToolName=new map<String,id>();
            for(Tech_Tools__c tool : [select id, name,service__r.name,service__c,Tech_Tool_Name__c,
            Tech_Tool__c,Custom_Tool_Name__c from Tech_Tools__c where 
                                    service__r.Opportunity_Id_Dev__c=:opportunityid1.substring(0,15) limit 5000]){
                //newTechtool.put(tool.Tech_Tool_Name__c+tool.service__c,tool.id);
                transactionalCustomToolName.put(tool.Custom_Tool_Name__c+tool.service__c,tool.id);
            }
            for(String s:newTechtool.keyset()){
            //    system.debug('String newTechtool'+s+'newTechtool key value---------'+newTechtool.get(s));
            }
            List<Other_Cost_Details__c> ocdtoupdate=new List<Other_Cost_Details__c>();
            for(Other_Cost_Details__c ocd:[select id,Tech_Tools__c,Offering2__c,Service__c
                                    from Other_Cost_Details__c where ID IN:ocdids and Tech_Tools__c=null  LIMIT 5000]){
                //     system.debug('ocd.Offering2__c+ocd.Service__c'+ocd.Offering2__c+ocd.Service__c+'newTechtool key value---------'+transactionalCustomToolName.get(ocd.Offering2__c+ocd.Service__c));             
                ocd.Tech_Tools__c=transactionalCustomToolName.get(ocd.Offering2__c+ocd.Service__c);
                ocdtoupdate.add(ocd);
            }
            
            database.update(ocdtoupdate,true); 
        }
        catch(exception e){
           ExceptionClass.logException(UtilConstants.ScopeUpdataion_FutureClass,
           UtilConstants.commit_RollBack,e,UtilConstants.SWB,UtilConstants.BPOSE);
        }
    }
        /**************
        @methodname : deleteOpportunityDeliveryLocation
        @decription : method to perform delete opportunity delivery location
       *****************/
       public static void deleteOpportunityDeliveryLocation(ID opportunityID){
        Set<id> dellocationids=new Set<Id>();
        Set<id> alldellocationids=new Set<Id>();
        Set<id> dellocationidstodelete=new Set<Id>();
       for(FTE_Details__c fte:[Select id,Opportunity_Delivery_Location__c from FTE_Details__c where 
       Service__r.Solutionscope__r.Opportunity__c=:opportunityID LIMIT 10000]){
        dellocationids.add(fte.Opportunity_Delivery_Location__c);
       }
       
       for(Other_Cost_Details__c fte:[Select id,Opportunity_Delivery_Location__c from Other_Cost_Details__c where 
       Service__r.Solutionscope__r.Opportunity__c=:opportunityID LIMIT 10000]){
        dellocationids.add(fte.Opportunity_Delivery_Location__c);
       }
       
       for(Opportunity_Delivery_Location__c oppdelloc:[Select id from Opportunity_Delivery_Location__c where 
       Offering_Service__r.Solutionscope__r.Opportunity__c=:opportunityID LIMIT 10000]){
        alldellocationids.add(oppdelloc.id);
       }
       
       for(Id i:alldellocationids){
        if(!dellocationids.contains(i)){
            dellocationidstodelete.add(i);
        }
       }
        if(!dellocationidstodelete.isEmpty()){
            delete [Select id from Opportunity_Delivery_Location__c where id in: dellocationidstodelete LIMIT 10000];
        }
       }
}