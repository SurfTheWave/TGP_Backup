/*
        @Author : Divyashree C K
        @Created Date : 27/1/2016
        @name : BenchmarkSync_IO
        @Description : Creating Benchmark records from 2 staging objects viz. FTE Details and Other Cost details.
        @Version : 1.0
    */
global without sharing class BenchmarkSync_IOBPOSync_V2{

        global static List<Payroll__c> inputPayroll;
        global static List<FTE_Details__c> inputFTEDetail;
        //global static List<benchmarkOffering> listOfOfferingService;
       // global static List<BenchMark_Offering_Service__c> listOfBenchOfferingService;
        global static List<Other_Cost_Details__c> inputOtherCost;
        global static Costing_Request__c inputCostingRequest;
        global static Savepoint svPt;
         global static Opportunity bpoOpp=new Opportunity();
        //global static BenchMark__c benchmarkrecs = new BenchMark__c();
        //global static String serviceGroup = UtilConstants.BLANK;
        
/******************************
        Method Name: populateBenchMarkObjs
        Description: Invoke this public method from outside to populate benchmark Objects
        Paramenters: NA
        Return Value: void. 
        *******************************/
    global static void populateBenchMarkObjs_IO(Set<Id> nFTEids,Set<Id> nOCDids,Set<Id> nCdr, Set<Id> nVol, Set<Id> oFTEids,Set<Id> oOCDids,Set<Id> oCdr, Set<Id> oVol, MAP<String,String>costDataMap){
         boolean isSuccess = false;
         UtilConstants.IS_OPPTRIGGER_REQUIRED = false;
         Id oldBenchmarkObjId=null;
         Id newBenchmarkObjId=null;
         set<id> oldbnchServLocId = new set<id>();
         set<id> newBnchServLocId = new set<id>();
         BenchMark__c oldBnchMark;
         
         //Id OppId=BenchmarkSync.getFTEandOtherCost(nFTEids,nOCDids, nPayrll, costDataMap.get('Opportunity__c'));
         Id OppId=BenchmarkSync.getFTEandOtherCost(nFTEids,nOCDids);
         List<Opportunity> bpoOppList= BenchmarkSync.getBPOOPP(OppId);
         
         system.debug('OppId is'+OppId);
         //system.debug('bpoOppList is'+bpoOppList);
         //oldBnchMark = [SELECT id, Name FROM BenchMark__c WHERE Opportunity__c=:costDataMap.get('Opportunity__c') AND Service_group__C = :UtilConstants.IO Limit 1];

         if(bpoOppList.size()>0){
            bpoOpp=bpoOppList[0];
            for(BenchMark__c itrObj:[Select id from BenchMark__c where Opportunity__c=:bpoOpp.id AND service_group__c = :UtilConstants.IO Limit 1]){
                oldBnchMark=itrObj;     
            }
         }
         
         if(bpoOpp.id!=null){
             try{
                  svPt = Database.setSavepoint(); 
                  newBenchmarkObjId = createUniqueBenchmark(oppId);

                  if(newBenchmarkObjId <> null){
                      BenchmarkSync.benchmarkrecs = new BenchMark__c(id= newBenchmarkObjId);
                      BenchmarkSync.createSummary(UtilConstants.IO);
                     // createSummary(newBenchmarkObjId);
                  }
                  if(oldBnchMark <> null ){
                       Database.delete(oldBnchMark , true);
                  }

                  issuccess =true;
             }
             catch(Exception de){
                  Database.rollback(svPt);
                  System.debug('Error!!!! -> '+ de);
                  ExceptionClass.logException(UtilConstants.BENCH_SYNC,UtilConstants.POP_BENCH_OBJS,de,UtilConstants.SWB,UtilConstants.SWB);
                   
                   
                   costing_request__c cost = new costing_request__c(id=costdatamap.get('ID'));
                   cost.Calculation__c = false;
                   cost.sync_failed_at__c = 'Benchmark';
                   cost.Data_Cleaning_dev__c =true;
                   cost.In_Progress__c = costDatamap.get('In_Progress_PrevState__c');
                   update cost;
                   
                   sync_status__c syncstat = [select id,error__c, Calculation_failed__c from sync_Status__C where opportunity__c=: oppId limit 1];
                   syncstat.error__c =SWBBPOSEIntegrationConstants.SYNCUNSUCCESFULSTATUSFAILED;
                   syncstat.Calculation_failed__c = true;
                   update syncstat;
             }
             finally{
                  if(issuccess){
                    costing_request__c cost = new costing_request__c(id=costdatamap.get('ID'));
                    cost.CostSummaryandMetrics_IO__c = newBenchmarkObjId;

                    update cost;
                    
                    
                    set<id> datalist = new set<id>();
                    datalist.addall(OFteids);
                    datalist.addall(Oocdids);
                    //datalist.addall(oPayrll);
                    datalist.addall(oCdr);
                    datalist.addall(oVol);
                    //datalist.addAll(oldcrossdeal);
                    system.debug('data list sizee---------------------------------------------------'+datalist.size());
                     //further calculation
                    database.executeBatch(new deletebatchsync(datalist,oppid,'Commit',costdataMap,'IO'));
                  }
                  else{
                     //rollback_data(oppid,rowcount,costid);
                      database.executebatch(new DeletehugeBatchSync(oppid,costdatamap.get('ID'),'IO'),400);
                  }
        }
             
         }
          
    }
    
    
    
/******************************
        Method Name: createSummary
        Description: This private method is invoked to insert benchmark Summary objects
        Paramenters: NA
        Return Value: NA
   
        global Static void createSummary(Id benchmarkrecsId){
            Map<String,BenchMark_Summary__c> mapBenchSummary= new Map<String,BenchMark_Summary__c>();
            String key =UtilConstants.EMPTY_STRING;
            double GrandTotalCost=0;
            BenchMark_Summary__c benchSummary=null;
                    


            for(Other_Cost_Details__c  rec: inputOtherCost){
                key = rec.Sub_Service_Group__r.Offering_Master__r.name + rec.Service__r.Serv_Nm__c;
                        
                if(mapBenchSummary.get(key)!=null){
                    benchSummary = mapBenchSummary.get(key);

                            

                            
                    if(benchSummary.Sum_of_RUN_Year1__c!=null && rec.Run_Yr1__c!=null)
                        benchSummary.Sum_of_RUN_Year1__c+=rec.Run_Yr1__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year2__c!=null && rec.Run_Yr2__c!=null)
                        benchSummary.Sum_of_RUN_Year2__c+=rec.Run_Yr2__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year3__c!=null && rec.Run_Yr3__c!=null)
                        benchSummary.Sum_of_RUN_Year3__c+=rec.Run_Yr3__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year4__c!=null && rec.Run_Yr4__c!=null)
                        benchSummary.Sum_of_RUN_Year4__c+=rec.Run_Yr4__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year5__c!=null && rec.Run_Yr5__c!=null)
                        benchSummary.Sum_of_RUN_Year5__c+=rec.Run_Yr5__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year6__c!=null && rec.Run_Yr6__c!=null)    
                        benchSummary.Sum_of_RUN_Year6__c+=rec.Run_Yr6__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year7__c!=null && rec.Run_Yr7__c!=null)
                        benchSummary.Sum_of_RUN_Year7__c+=rec.Run_Yr7__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year8__c!=null && rec.Run_Yr8__c!=null)    
                        benchSummary.Sum_of_RUN_Year8__c+=rec.Run_Yr8__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year9__c!=null && rec.Run_Yr9__c!=null)    
                        benchSummary.Sum_of_RUN_Year9__c+=rec.Run_Yr9__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year10__c!=null && rec.Run_Yr10__c!=null)    
                        benchSummary.Sum_of_RUN_Year10__c+=rec.Run_Yr10__c.setscale(4);
                            
                }else{
                    benchSummary=new BenchMark_Summary__c(); 
                        
                    benchSummary.Costing_Type__c = UtilConstants.EMPTY_STRING;
                    benchSummary.Offering__c = UtilConstants.EMPTY_STRING;
                    benchSummary.Service__c=UtilConstants.EMPTY_STRING;
                        
                    benchSummary.Sum_of_Transition_cost__c=0;
                            
                    benchSummary.Sum_of_RUN_Year1__c=0;
                    benchSummary.Sum_of_RUN_Year2__c=0;
                    benchSummary.Sum_of_RUN_Year3__c=0;
                    benchSummary.Sum_of_RUN_Year4__c=0;
                    benchSummary.Sum_of_RUN_Year5__c=0;
                    benchSummary.Sum_of_RUN_Year6__c=0;
                    benchSummary.Sum_of_RUN_Year7__c=0;
                    benchSummary.Sum_of_RUN_Year8__c=0;
                    benchSummary.Sum_of_RUN_Year9__c=0;
                    benchSummary.Sum_of_RUN_Year10__c=0;


                            
                    benchSummary.Sum_of_Total_Cost__c=0;
                            
                    benchSummary.Sum_of_FTE_YR1__c=0;
                    benchSummary.Sum_of_FTE_YR2__c=0;
                    benchSummary.Sum_of_FTE_YR3__c=0;
                    benchSummary.Sum_of_FTE_YR4__c=0;
                    benchSummary.Sum_of_FTE_YR5__c=0;
                    benchSummary.Sum_of_FTE_YR6__c=0;
                    benchSummary.Sum_of_FTE_YR7__c=0;
                    benchSummary.Sum_of_FTE_YR8__c=0;
                    benchSummary.Sum_of_FTE_YR9__c=0;
                    benchSummary.Sum_of_FTE_YR10__c =0;

                     
                    //if(rec.Costing_Type__c!=null)
                        benchSummary.Costing_Type__c = UtilConstants.SDO;
                    if(rec.Sub_Service_Group__r!=null && rec.Sub_Service_Group__r.Name!=null)
                        benchSummary.Offering__c = rec.Sub_Service_Group__r.Offering_Master__r.name;
                    if(rec.Service_Name__c!=null)    
                        benchSummary.Service__c=rec.Service__r.Serv_Nm__c;

                        
                   // if(rec.Mob_Totals__c!=null)
                    //    benchSummary.Sum_of_Transition_cost__c=rec.Mob_Totals__c.setscale(4);
                            
                    if(rec.Run_Yr1__c!=null)
                        benchSummary.Sum_of_RUN_Year1__c=rec.Run_Yr1__c.setscale(4);
                    if(rec.Run_Yr2__c!=null)
                        benchSummary.Sum_of_RUN_Year2__c=rec.Run_Yr2__c.setscale(4);
                    if(rec.Run_Yr3__c!=null)
                        benchSummary.Sum_of_RUN_Year3__c=rec.Run_Yr3__c.setscale(4);
                    if(rec.Run_Yr4__c!=null)
                        benchSummary.Sum_of_RUN_Year4__c=rec.Run_Yr4__c.setscale(4);
                    if(rec.Run_Yr5__c!=null)
                        benchSummary.Sum_of_RUN_Year5__c=rec.Run_Yr5__c.setscale(4);
                    if(rec.Run_Yr6__c!=null)
                        benchSummary.Sum_of_RUN_Year6__c=rec.Run_Yr6__c.setscale(4);
                    if(rec.Run_Yr7__c!=null)
                        benchSummary.Sum_of_RUN_Year7__c=rec.Run_Yr7__c.setscale(4);
                    if(rec.Run_Yr8__c!=null)
                        benchSummary.Sum_of_RUN_Year8__c=rec.Run_Yr8__c.setscale(4);
                    if(rec.Run_Yr9__c!=null)
                        benchSummary.Sum_of_RUN_Year9__c=rec.Run_Yr9__c.setscale(4);
                    if(rec.Run_Yr10__c!=null)
                        benchSummary.Sum_of_RUN_Year10__c=rec.Run_Yr10__c.setscale(4);
                    
                    mapBenchSummary.put(key,benchSummary);
                }

            }
            
            for(FTE_Details__c  rec: inputFTEDetail){
            
                key =  rec.Sub_Service_Group__r.Offering_Master__r.name + rec.Service__r.Serv_Nm__c;
                        
                if(mapBenchSummary.get(key)!=null){
                    benchSummary = mapBenchSummary.get(key);
                        
                    
                                                   
                    if(benchSummary.Sum_of_RUN_Year1__c!=null && rec.Run_Yr1__c!=null)
                        benchSummary.Sum_of_RUN_Year1__c+=rec.Run_Yr1__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year2__c!=null && rec.Run_Yr2__c!=null)
                        benchSummary.Sum_of_RUN_Year2__c+=rec.Run_Yr2__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year3__c!=null && rec.Run_Yr3__c!=null)
                        benchSummary.Sum_of_RUN_Year3__c+=rec.Run_Yr3__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year4__c!=null && rec.Run_Yr4__c!=null)
                        benchSummary.Sum_of_RUN_Year4__c+=rec.Run_Yr4__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year5__c!=null && rec.Run_Yr5__c!=null)
                        benchSummary.Sum_of_RUN_Year5__c+=rec.Run_Yr5__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year6__c!=null && rec.Run_Yr6__c!=null)    
                        benchSummary.Sum_of_RUN_Year6__c+=rec.Run_Yr6__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year7__c!=null && rec.Run_Yr7__c!=null)
                        benchSummary.Sum_of_RUN_Year7__c+=rec.Run_Yr7__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year8__c!=null && rec.Run_Yr8__c!=null)    
                        benchSummary.Sum_of_RUN_Year8__c+=rec.Run_Yr8__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year9__c!=null && rec.Run_Yr9__c!=null)    
                        benchSummary.Sum_of_RUN_Year9__c+=rec.Run_Yr9__c.setscale(4);
                    if(benchSummary.Sum_of_RUN_Year10__c!=null && rec.Run_Yr10__c!=null)    
                        benchSummary.Sum_of_RUN_Year10__c+=rec.Run_Yr10__c.setscale(4);
                        
                       
                    if(benchSummary.Sum_of_FTE_YR1__c!=null && rec.FTEYr1__c!=null)    
                        benchSummary.Sum_of_FTE_YR1__c +=rec.FTEYr1__c.setscale(4);
                    if(benchSummary.Sum_of_FTE_YR2__c!=null && rec.FTEYr2__c!=null)
                        benchSummary.Sum_of_FTE_YR2__c +=rec.FTEYr2__c.setscale(4);
                    if(benchSummary.Sum_of_FTE_YR3__c!=null && rec.FTEYr3__c!=null)
                        benchSummary.Sum_of_FTE_YR3__c +=rec.FTEYr3__c.setscale(4);
                    if(benchSummary.Sum_of_FTE_YR4__c!=null && rec.FTEYr4__c!=null)
                        benchSummary.Sum_of_FTE_YR4__c +=rec.FTEYr4__c.setscale(4);
                    if(benchSummary.Sum_of_FTE_YR5__c!=null && rec.FTEYr5__c!=null)    
                        benchSummary.Sum_of_FTE_YR5__c +=rec.FTEYr5__c.setscale(4);
                    if(benchSummary.Sum_of_FTE_YR6__c!=null && rec.FTEYr6__c!=null)
                        benchSummary.Sum_of_FTE_YR6__c +=rec.FTEYr6__c.setscale(4);
                    if(benchSummary.Sum_of_FTE_YR7__c!=null && rec.FTEYr7__c!=null)
                        benchSummary.Sum_of_FTE_YR7__c +=rec.FTEYr7__c.setscale(4);
                    if(benchSummary.Sum_of_FTE_YR8__c!=null && rec.FTEYr8__c!=null)
                        benchSummary.Sum_of_FTE_YR8__c +=rec.FTEYr8__c.setscale(4);
                    if(benchSummary.Sum_of_FTE_YR9__c!=null && rec.FTEYr9__c!=null)
                        benchSummary.Sum_of_FTE_YR9__c +=rec.FTEYr9__c.setscale(4);
                    if(benchSummary.Sum_of_FTE_YR10__c!=null && rec.FTEYr10__c!=null)
                        benchSummary.Sum_of_FTE_YR10__c +=rec.FTEYr10__c.setscale(4);
                     

                            
                }else{
                    benchSummary=new BenchMark_Summary__c();
                        
                    benchSummary.Costing_Type__c = UtilConstants.SDO;
                    benchSummary.Offering__c = UtilConstants.EMPTY_STRING;
                    benchSummary.Service__c=UtilConstants.EMPTY_STRING;
                        
                    
                            
                    benchSummary.Sum_of_RUN_Year1__c=0;
                    benchSummary.Sum_of_RUN_Year2__c=0;
                    benchSummary.Sum_of_RUN_Year3__c=0;
                    benchSummary.Sum_of_RUN_Year4__c=0;
                    benchSummary.Sum_of_RUN_Year5__c=0;
                    benchSummary.Sum_of_RUN_Year6__c=0;
                    benchSummary.Sum_of_RUN_Year7__c=0;
                    benchSummary.Sum_of_RUN_Year8__c=0;
                    benchSummary.Sum_of_RUN_Year9__c=0;
                    benchSummary.Sum_of_RUN_Year10__c=0;

                            
                    benchSummary.Sum_of_Total_Cost__c=0;
                            
                    benchSummary.Sum_of_FTE_YR1__c=0;
                    benchSummary.Sum_of_FTE_YR2__c=0;
                    benchSummary.Sum_of_FTE_YR3__c=0;
                    benchSummary.Sum_of_FTE_YR4__c=0;
                    benchSummary.Sum_of_FTE_YR5__c=0;
                    benchSummary.Sum_of_FTE_YR6__c=0;
                    benchSummary.Sum_of_FTE_YR7__c=0;
                    benchSummary.Sum_of_FTE_YR8__c=0;
                    benchSummary.Sum_of_FTE_YR9__c=0;
                    benchSummary.Sum_of_FTE_YR10__c =0; 

                        
                    
                        benchSummary.Costing_Type__c = UtilConstants.SDO;
                    if(rec.Sub_Service_Group__r!=null && rec.Sub_Service_Group__r.Name!=null)
                        benchSummary.Offering__c = rec.Sub_Service_Group__r.Offering_Master__r.name;
                    if(rec.Service_Name__c!=null)    
                        benchSummary.Service__c=rec.Service__r.Serv_Nm__c;
                        
                    if(rec.Run_Yr1__c!=null)
                        benchSummary.Sum_of_RUN_Year1__c=rec.Run_Yr1__c.setscale(4);
                    if(rec.Run_Yr2__c!=null)
                        benchSummary.Sum_of_RUN_Year2__c=rec.Run_Yr2__c.setscale(4);
                    if(rec.Run_Yr3__c!=null)
                        benchSummary.Sum_of_RUN_Year3__c=rec.Run_Yr3__c.setscale(4);
                    if(rec.Run_Yr4__c!=null)
                        benchSummary.Sum_of_RUN_Year4__c=rec.Run_Yr4__c.setscale(4);
                    if(rec.Run_Yr5__c!=null)
                        benchSummary.Sum_of_RUN_Year5__c=rec.Run_Yr5__c.setscale(4);
                    if(rec.Run_Yr6__c!=null)
                        benchSummary.Sum_of_RUN_Year6__c=rec.Run_Yr6__c.setscale(4);
                    if(rec.Run_Yr7__c!=null)
                        benchSummary.Sum_of_RUN_Year7__c=rec.Run_Yr7__c.setscale(4);
                    if(rec.Run_Yr8__c!=null)
                        benchSummary.Sum_of_RUN_Year8__c=rec.Run_Yr8__c.setscale(4);
                    if(rec.Run_Yr9__c!=null)
                        benchSummary.Sum_of_RUN_Year9__c=rec.Run_Yr9__c.setscale(4);
                    if(rec.Run_Yr10__c!=null)
                        benchSummary.Sum_of_RUN_Year10__c=rec.Run_Yr10__c.setscale(4);

                    if(rec.FTEYr1__c!=null)
                        benchSummary.Sum_of_FTE_YR1__c =rec.FTEYr1__c.setscale(4);
                    if(rec.FTEYr2__c!=null)
                        benchSummary.Sum_of_FTE_YR2__c =rec.FTEYr2__c.setscale(4);
                    if(rec.FTEYr3__c!=null)
                        benchSummary.Sum_of_FTE_YR3__c =rec.FTEYr3__c.setscale(4);
                    if(rec.FTEYr4__c!=null)
                        benchSummary.Sum_of_FTE_YR4__c =rec.FTEYr4__c.setscale(4);
                    if(rec.FTEYr5__c!=null)
                        benchSummary.Sum_of_FTE_YR5__c =rec.FTEYr5__c.setscale(4);
                    if(rec.FTEYr6__c!=null)
                        benchSummary.Sum_of_FTE_YR6__c =rec.FTEYr6__c.setscale(4);
                    if(rec.FTEYr7__c!=null)
                        benchSummary.Sum_of_FTE_YR7__c =rec.FTEYr7__c.setscale(4);
                    if(rec.FTEYr8__c!=null)
                        benchSummary.Sum_of_FTE_YR8__c =rec.FTEYr8__c.setscale(4);
                    if(rec.FTEYr9__c!=null)
                        benchSummary.Sum_of_FTE_YR9__c =rec.FTEYr9__c.setscale(4);
                    if(rec.FTEYr10__c!=null)
                        benchSummary.Sum_of_FTE_YR10__c =rec.FTEYr10__c.setscale(4);   
                            

                    mapBenchSummary.put(key,benchSummary);
                }
                
            }
            
            
            List<BenchMark_Summary__c> benchSummaryList=new List<BenchMark_Summary__c>(); 
            
            for(String mapKey:mapBenchSummary.keySet()){
                benchSummary=mapBenchSummary.get(mapKey);
                        
                GrandTotalCost += (benchSummary.Sum_of_RUN_Year1__c+benchSummary.Sum_of_RUN_Year2__c+benchSummary.Sum_of_RUN_Year3__c+
                                   benchSummary.Sum_of_RUN_Year4__c+benchSummary.Sum_of_RUN_Year5__c+benchSummary.Sum_of_RUN_Year6__c+benchSummary.Sum_of_RUN_Year7__c+
                                   benchSummary.Sum_of_RUN_Year8__c+benchSummary.Sum_of_RUN_Year9__c+benchSummary.Sum_of_RUN_Year10__c).setscale(4);


            }
            //GrandTotalCost=GrandTotalCost.round();
            
            for(String mapKey:mapBenchSummary.keySet()){
                benchSummary=mapBenchSummary.get(mapKey);
                        
                benchSummary.BenchMark__c=benchmarkrecsId;
                benchSummary.Service_Group__c = UtilConstants.IO;

                        
                benchSummary.Total_FTE_all_years__c = (benchSummary.Sum_of_FTE_YR1__c+benchSummary.Sum_of_FTE_YR2__c+benchSummary.Sum_of_FTE_YR3__c+
                                                            benchSummary.Sum_of_FTE_YR4__c+benchSummary.Sum_of_FTE_YR5__c+
                                                            benchSummary.Sum_of_FTE_YR6__c+benchSummary.Sum_of_FTE_YR7__c+
                                                            benchSummary.Sum_of_FTE_YR8__c+benchSummary.Sum_of_FTE_YR9__c+
                                                            benchSummary.Sum_of_FTE_YR10__c).setscale(4);
                

                benchSummary.Sum_of_Total_Cost__c = (benchSummary.Sum_of_RUN_Year1__c+benchSummary.Sum_of_RUN_Year2__c+benchSummary.Sum_of_RUN_Year3__c+
                                                    benchSummary.Sum_of_RUN_Year4__c+benchSummary.Sum_of_RUN_Year5__c+benchSummary.Sum_of_RUN_Year6__c+benchSummary.Sum_of_RUN_Year7__c+
                                                    benchSummary.Sum_of_RUN_Year8__c+benchSummary.Sum_of_RUN_Year9__c+benchSummary.Sum_of_RUN_Year10__c).setscale(4);
                
                //benchSummary.Total_FTE_all_years__c=benchSummary.Total_FTE_all_years__c.setscale(4);
                //benchSummary.Sum_of_Total_Cost__c=benchSummary.Sum_of_Total_Cost__c.setscale(4);
                

                benchSummary.percent_of_costs__c=GrandTotalCost==0 ? 0 : ((benchSummary.Sum_of_Total_Cost__c/GrandTotalCost)*100).setScale(6);
                                        
                
                benchSummaryList.add(benchSummary);
            }
            if(benchSummaryList.size() >0 ){
                try{
                    Database.insert(benchSummaryList,true);

                }catch(DMLException de){
                    throw(de);
                }
            }
        }
        *******************************/ 
        
        
/******************************
        Method Name: createUniqueBenchmark
        Description: This private method is invoked to insert benchmark opportunity object
        Paramenters: NA
        Return Value: NA
        *******************************/
    global static Id createUniqueBenchmark(Id optyId){
           
           BenchMark__c benchmarkrecs = new BenchMark__c();
           
           inputCostingRequest = [SELECT Client__c, Contract_End__c,Allow_Deal_Customization__c, Opportunity__c,Opportunity__r.SAP_OM_ID__c, 



                                        Opportunity__r.AccountId, Opportunity__r.Name,
                                        HasMasterDataBeenCustomizedForDeal__c,Contract_Start__c, Initial_Go_Live__c, SAP_OM_ID__c,
                                        Synced_Scenario_Name__c, SSM_Version__c, Version__c FROM Costing_Request__c where Opportunity__c =:optyId LIMIT 1];
                                         
            //serviceGroup = UtilConstants.IO;
            benchmarkrecs.Name= inputCostingRequest.Opportunity__r.Name+ UtilConstants.VFP_BENCHMARK_DATA;
            benchmarkrecs.service_Group__c = UtilConstants.IO;
            benchmarkrecs.Deal_Unlocked__c = inputCostingRequest.Allow_Deal_Customization__c;
            benchmarkrecs.Deal_Data_Tables_Updated__c = inputCostingRequest.HasMasterDataBeenCustomizedForDeal__c;
            benchmarkrecs.Opportunity__c = inputCostingRequest.Opportunity__c;
            benchmarkrecs.Contract_End_Date__c = inputCostingRequest.Contract_End__c;
            benchmarkrecs.Contract_Start_Date__c = inputCostingRequest.Contract_Start__c;
            benchmarkrecs.Initial_Go_Live__c = inputCostingRequest.Initial_Go_Live__c;
            benchmarkrecs.SAP_OM_ID__c = inputCostingRequest.Opportunity__r.SAP_OM_ID__c;
            benchmarkrecs.Scenario__c = inputCostingRequest.Synced_Scenario_Name__c;
            benchmarkrecs.SSM_Version__c = inputCostingRequest.SSM_Version__c;
            benchmarkrecs.Version__c = inputCostingRequest.Version__c;
            benchmarkrecs.Client__c = inputCostingRequest.Opportunity__r.AccountId;
            benchmarkrecs.Active__c = TRUE;
            //benchmarkrecs.of_Locations__c = countryList.size();
            //benchmarkrecs.Inc_in_BM_Report__c = UtilConstants.NOT_REVIEWED;
            //benchmarkrecs.Count_of_Language__c = String.valueOf(languageSet.size());
            //benchmarkrecs.Baseline_FTEs__c = benchWr.baselineftes.setscale(4);
            //benchmarkrecs.Number_of_locations_where_scope_is_deliv__c = deliveryLocSet.size();
             //benchmarkrecs.Onshore_Baseline_FTEs__c = benchWr.onshoreBaselineSDOFTEs.setscale(4);
            //benchmarkrecs.Nearshore_Baseline_FTEs__c = benchWr.nearshoreBaselineSDOFTEs.setscale(4);
            //benchmarkrecs.Offshore_Baseline_FTEs__c = benchWr.offshoreBaselineSDOFTEs.setscale(4);
            //benchmarkrecs.Pyramid_Richness_Year1__c = benchWr.pyramidrichness.setscale(4);

        try{
            //Database.insert(benchmarkrecs, true);
            insert benchmarkrecs;
            return benchmarkrecs.id;

        }catch(DMLException de){
            throw(de);




            return null;
        }
    
    
    }


     /******************************
        Method Name: getFTEandOtherCost
        Description: Invoke this method to fetch FTE Detail and Other Cost Records for an Opportunity
        Paramenters: NA
        Return Value: void. 
        *******************************/
        /******************************
    global static Id getFTEandOtherCost(Set<Id> nFTEIds,Set<Id> nOCDids,Set<Id> nPayrll, Id optyId){
            Id bpoOppId=null;
            try{
            
                List<Opportunity> opptyList = new List<Opportunity>();
                opptyList= [SELECT Id, Name ,
                            (SELECT Activity_Description__c,Delivery_Location_Dev__c,Career_Level__r.Name,Service__r.Services__r.name,Service_Group__c,Costing_Type__c,
                                    Sub_Service_Group__r.Offering_Master__r.name,Bill_Code__c,Baseline_FTEs__c, Career_Level__c,Career_Track__c,Country__c,
                                    Load_Type__c,Location_typeCode__c,Location_typeName__c,Language__c,Opportunity__c,Phase__c,Pyramid_Richness__c,Rate_Type__c,
                                    Resource_Group__c,Role_Master__c,Service_Component_Name__c,Service_Component__c,
                                    Service_Name__c,Service__c,Service__r.Serv_Nm__c,Sub_Service_Group_Name__c,Sub_Service_Group__c,Sub_Service_Group__r.Name,
                                    Costing_Request__r.Opportunity__c,Final_Month_FTE__c, Service__r.Delivery_Locations__c ,
                                     Y1__c, Y2__c, Y3__c, Y4__c, Y5__c, Y6_Y7_Y8_Y9_Y10__c, Y6__c, Y7__c, Y8__c, Y9__c, Y10__c,
                                   FTEYr1__c,FTEYr2__c,FTEYr3__c,FTEYr4__c,FTEYr5__c,FTEYr6__c,FTEYr7__c, FTEYr8__c,FTEYr9__c,FTEYr10__c
                                    FROM FTE_Details__r where id in :nFTEids AND Service_Group__c = :UtilConstants.IO),
                            (SELECT Y1__c, Y2__c, Y3__c, Y4__c, Y5__c, Y6_Y7_Y8_Y9_Y10__c, Y6__c, Y7__c, Y8__c, Y9__c, 
                                  Costing_Request__c, Country_Dev__c, FTE_Details__c, Is_Transient__c, Mob_Payroll_Ops__c, Mob_Totals__c, Other_Cost_Details__c, 
                                  Service_Component_Name__c, Service_Name__c, Sub_Service_Group_Name__c, Sum_of_Payroll_Dev__c, Total_Dev__c, Y10__c, 
                                  Sum_of_Payroll__c, Sub_Service_Group__c, Service_Group__c, Service_Component__c, Opportunity__c,                                   
                                  Service__c, Name, Id, Costing_Request__r.Opportunity__c,
                                  Sub_Service_Group__r.Offering_Master__r.name, Service__r.Serv_Nm__c, Sub_Service_Group__r.Name,
                                  Y10_Ops__c, Y1_Ops__c, Y2_Ops__c, Y3_Ops__c, Y4_Ops__c, Y5_Ops__c, Y6_Ops__c, Y7_Ops__c, Y8_Ops__c, Y9_Ops__c
                                  FROM Payroll_Details__r WHERE ID IN :nPayrll AND service_Group__c= :UtilConstants.IO LIMIT 9000),
                            (SELECT  Id, Name,Service__r.Services__r.name,Sub_Service_Group__r.Offering_Master__r.name, Service__c, Country__c, Career_Level__c,
                                  Service__r.Name, Career_Level__r.Name, Country__r.Name,Sum_of_Other_Costs__c,Costing_Type__c,Sub_Service_Group__r.Name,Service_Name__c,Service_Group__c,
                                  Mob_Cost__c,Run_Yr1__c,Run_Yr2__c,Run_Yr3__c,Run_Yr4__c,Run_Yr5__c,Run_Yr6__c,Run_Yr7__c,Run_Yr8__c,Run_Yr9__c,Run_Yr10__c,Mob_Totals__c,
                                  Service__r.Serv_Nm__c,Sub_Service_Group_Name__c,Y1__c,Y2__c,Y3__c,Y4__c,Y5__c,Y6__c,Y7__c,Y8__c,Y9__c,Y10__c,Costing_Request__r.Opportunity__c 
                                  FROM Other_Cost_Details__r WHERE id in :nOCDids AND Service_Group__c = :UtilConstants.IO LIMIT 9000),
                            (SELECT Client__c, Contract_End__c,Allow_Deal_Customization__c, Opportunity__c,Opportunity__r.SAP_OM_ID__c, 
                                        Opportunity__r.AccountId, Opportunity__r.Name,
                                        HasMasterDataBeenCustomizedForDeal__c,Contract_Start__c, Initial_Go_Live__c, SAP_OM_ID__c,
                                        Synced_Scenario_Name__c, SSM_Version__c, Version__c FROM Costing_Requests__r  WHERE Opportunity__c =:optyId LIMIT 1)
                           FROM Opportunity WHERE id =:optyId ];
                
                
            if(opptyList[0].FTE_Details__r.size() >0){
                inputFteDetail = opptyList[0].FTE_Details__r;
                bpoOppId = opptyList[0].Id;
            }
            if(opptyList[0].Payroll_Details__r.size() >0) {
                inputPayroll = opptyList[0].Payroll_Details__r;
                bpoOppId = opptyList[0].Id;
            }
            if(opptyList[0].Other_Cost_Details__r.size() >0) {
                inputOtherCost = opptyList[0].Other_Cost_Details__r;
                 bpoOppId = opptyList[0].Id;
            }
            if(opptyList[0].Costing_Requests__r.size() >0){
                inputCostingRequest = opptyList[0].Costing_Requests__r[0];
            }
             
            system.debug('bpoOppId'+bpoOppId);
            
            
            }catch(QueryException qe){
                throw(qe);
            }catch(Exception ex){
                throw(ex);
            }
            return bpoOppId;
        }
        *******/

        


}