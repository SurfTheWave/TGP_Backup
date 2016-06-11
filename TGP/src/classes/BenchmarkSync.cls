/*
        @Author : Shashank Shastri
        @Created Date : 17/6/2015
        @name : BenchmarkSync
        @Description : Creating Benchmark records from 2 staging objects viz. FTE Details and Other Cost details.
        @Version : 1.0
    */
    global without sharing class BenchmarkSync{

        global static Savepoint svPt;
        
        
        global static Opportunity bpoOpp=new Opportunity();
        global static BenchMark__c benchmarkrecs = new BenchMark__c();
        
        global static List<FTE_Details__c> inputFTEDetail;
        global static List<benchmarkOffering> listOfOfferingService;
        global static List<BenchMark_Offering_Service__c> listOfBenchOfferingService;
        global static List<Other_Cost_Details__c> inputOtherCost;
        global static Costing_Request__c inputCostingRequest;
        global static Set<String> countryList = new Set<String>();
        global static Set<String> languageSet = new Set<String>();
        global static Set<String> deliveryLocSet = new Set<String>();
        
        global static Map<String,benchmarkOffering> mapOfWrapper= new Map<String,benchmarkOffering>();
        global static Map<String, Id> servSubServMap;
        global static Map<String,decimal> otherCostSum = new Map<String,decimal>();
        public static boolean isSendMail = false;
        global Set<String> OfferingMaster = new Set<String>();
        /***********************************
        Class Name: BenchmarkWrapper
        Description: Wrapper class for calculating and evaluating Benchmark Opportunity records.
        ***********************************/
        private without sharing class BenchmarkWrapper{
            public integer noOfLocations = 0;
            public decimal pyramidrichness = 0;
            public decimal sumOfFteLvl1=0;
            public decimal sumOfFteLvl2=0;
            public decimal sumOfFtLvl3=0;
            public decimal sumOfFteLvl4=0;
            public decimal sumOfFteLvl5=0;
            public decimal sumOfFteLvl6=0;
            public decimal sumOfFteLvl7=0;
            public decimal sumOfFteLvl8=0;
            public decimal sumOfSumFTEyr=0;
            public decimal effSumOfSumFTEyr=0;
            public decimal nearshoreBaselineSDOFTEs=0;
            public decimal onshoreBaselineSDOFTEs=0;
            public decimal offshoreBaselineSDOFTEs=0;
            public decimal baselineftes =0;
        }
        
        /*****************************
        Class Name:BenchmarkOppWrapper
        Description: Wrapper class for calculating Benchmark Opportunity roll-ups
        ****************************/
        private without sharing class BenchMarkOppWrapper{
            public String OpportunityId;
            public decimal CC_BSS_Total_Cost = 0;
            public decimal CC_CFM_Total_Cost = 0;
            public decimal CC_CM_Total_Cost = 0;
            public decimal CC_Command_Center_Total_Cost = 0;
            public decimal CC_Electronic_Data_Management_Total_Cost = 0;
            public decimal CC_Grand_Total_Cost = 0;
            public decimal CC_Mobilization_Total_Cost = 0;
            public decimal CC_OADM_Total_Cost = 0;
            public decimal CC_PMO_Total_Cost = 0;
            public decimal CC_QAD_Total_Cost = 0;
            public decimal CC_SDO_Total_Cost = 0;
            public decimal CC_Service_Management_Total_Cost = 0;
            public decimal CC_Support_Center_Total_Cost = 0;
            public decimal CC_Technology_Tools_Total_Cost = 0;
            public decimal CC_Technology_Total_Cost = 0;
            public decimal CC_Voice_and_Data_Total_Cost = 0;
            public decimal FTE_BSS_Total_Cost = 0;
            public decimal FTE_CFM_Total_Cost = 0;
            public decimal FTE_CM_Total_Cost = 0;
            public decimal FTE_Command_Center_Total_Cost = 0;
            public decimal FTE_Electronic_Data_Management_Total_Cos = 0;
            public decimal FTE_Grand_Total_Cost = 0;
            public decimal FTE_Mobilization_Total_Cost = 0;
            public decimal FTE_OADM_Total_Cost = 0;
            public decimal FTE_PMO_Total_Cost = 0;
            public decimal FTE_QAD_Total_Cost = 0;
            public decimal FTE_SDO_Total_Cost = 0;
            public decimal FTE_Service_Management_Total_Cost = 0;
            public decimal FTE_Support_Center_Total_Cost = 0;
            public decimal FTE_Technology_Tools_Total_Cost = 0;
            public decimal FTE_Technology_Total_Cost = 0;
            public decimal FTE_Voice_and_Data_Total_Cost = 0;
        }
        
        /******************************
        Class Name: benchmarkOffering
        Description: Wrapper Class for evaluating and Creating Benchmark Offering Record.
        *******************************/
        private without sharing class benchmarkOffering{
                public String name = UtilConstants.EMPTY_STRING;
                public boolean Active;  
                public decimal Average_of_FTE_Type=0; 
                public decimal Average_of_Location_Definition=0;
                public decimal Average_of_Pyramid_Richness_Year_1=0;
                public String BenchMark_Offering;
                public String Costing_Type;
                //public decimal Count_of_Language=0;
                public Set<String> Languages = new Set<String>();
                public String DCN_Location;
                public decimal Nearshore_Baseline_FTEs=0;
                public decimal Offshore_Baseline_FTEs=0;
                public decimal No_of_Contractors=0;
                public decimal No_of_Employees=0;
                public decimal of_Headcount_Transferred_from_client=0;
                public String Old_SF_ID;
                public decimal Onshore_Baseline_FTEs=0;
                public String Opportunity_Offering;
                public decimal Sum_of_Average_FTEs=0;
                public decimal Sum_of_Baseline_FTEs=0;
                public decimal Sum_of_Final_Month_FTE=0;
                public decimal Sum_of_Total_Cost=0;
                public String Tech_Tool;
        }
        /******************************
        Class Name: ServiceLocWrapper
        Description: Wrapper Class for evaluating and Creating Benchmark Service Location Record.
        *******************************/
        private Class ServiceLocWrapper{
            public String subServOff;
            public String service;
            public String costingType;
            public String country;
            public String custom_Location;
            public String dcnLocation;
            public String langPrem;
            public Decimal sumTotFTEYear=0;
            public Decimal totalPayrollCost=0;
            public Decimal totalPayrollCostFromFTE=0;
            public Decimal totalMobCost=0;
            public Decimal totalMobCostFTE=0;
            
            public Decimal toolsCostPerFTE=0;
            public Decimal dveCostPerFTE=0;
            public Decimal supportCentCostPerFTE=0;
            public Decimal smCostPerFTE=0;
            public Decimal edmCostPerFTE=0;
            public Decimal ccCostPerFTE=0;
            public Decimal mobCostPerFTE=0;
            public Decimal pmoCostPerFTE=0;
            public boolean consider=false;
        } 
        /******************************
        Class Name: ServiceLocOffWrapper
        Description: Wrapper Class for evaluating and Creating Benchmark Service Location Record.
        *******************************/
        private without sharing Class ServiceLocOffWrapper{
            public String subServOff;
            public Decimal sumTotFTEYear=0;
            
            public Decimal toolsCostPerFTE=0;
            public Decimal dveCostPerFTE=0;
            public Decimal supportCentCostPerFTE=0;
            public Decimal smCostPerFTE=0;
            public Decimal pmoCostPerFTE=0;
            public Decimal edmCostPerFTE=0;
            public Decimal ccCostPerFTE=0;
            public Decimal mobCostPerFTE=0;
        } 
        /******************************
        Method Name: populateBenchMarkObjs
        Description: Invoke this public method from outside to populate benchmark Objects
        Paramenters: NA
        Return Value: void. 
        *******************************/
        @future//(limits='3xHeap')
        //public Static void populateBenchMarkObjsFuture(Id OppId){
        public Static void populateBenchMarkObjsFuture(Set<Id> nFTEids,Set<Id> nOCDids,Set<Id> oFTEids,Set<Id> oOCDids,MAP<String,String>costdataMap){  
            populateBenchMarkObjs(nFTEids,nOCDids,oFTEids,oOCDids,costdataMap);
        }
        
        /******************************
        Method Name: populateBenchMarkObjs
        Description: Invoke this public method from outside to populate benchmark Objects
        Paramenters: NA
        Return Value: void. 
        *******************************/
        public Static void populateBenchMarkObjs(Set<Id> nFTEids,Set<Id> nOCDids,Set<Id> oFTEids,Set<Id> oOCDids,MAP<String,String>costdataMap){
            boolean isSuccess = false;
            UtilConstants.IS_OPPTRIGGER_REQUIRED = false;
            Id OppId=getFTEandOtherCost(nFTEids,nOCDids);
            List<Opportunity> bpoOppList=getBPOOPP(OppId);
            
            Id oldBenchmarkObjId=null;
            Id newBenchmarkObjId=null;
            set<id> oldbnchServLocId = new set<id>();
            set<id> newBnchServLocId = new set<id>();
            system.debug('OppId is'+OppId);
            system.debug('bpoOppList is'+bpoOppList);
            
            if(bpoOppList.size()>0){
                bpoOpp=bpoOppList[0];
                //oldBenchmarkObjList=[Select id from BenchMark__c where Opportunity__c=:bpoOpp.id Limit 1];
                for(BenchMark__c itrObj:[Select id from BenchMark__c where Opportunity__c=:bpoOpp.id AND service_group__c = :UtilConstants.BPO Limit 1]){
                    oldBenchmarkObjId=itrObj.id;    
                }
                for(BenchMark_Service_Location__c itrObj:[Select id from BenchMark_Service_Location__c where BenchMark_Offering_Service__r.BenchMark_Offering__r.BenchMark__r.Opportunity__c=:bpoOpp.id Limit 5000]){
                    oldbnchServLocId.add(itrObj.id);
                }
            }
           // ID jobID = System.enqueueJob(new OppAnalyticCalcQueue(oFTEids,nFTEids,oOCDids,nOCDids,costdataMap,oldBenchmarkObjList[0].id));
            system.debug('bpoOpp---->'+bpoOpp);
            if(bpoOpp.id!=null){
                try{
                    svPt = Database.setSavepoint(); 
                   newBenchmarkObjId = createUniqueBenchmark();
                    createbenchmarkOffering();
                    updateMultiSingleOPP();
                    createSummary(UtilConstants.BPO);
                    createOADM();
                    newBnchServLocId=insertServiceLoc();
                   // Database.delete(oldBenchmarkObjList);
                    //Database.delete(oldBenchMarkServLocList);
                    
                    if(isSendMail){
                        SendEmailOnBenchmarkSyncComplete sendmailobj = new SendEmailOnBenchmarkSyncComplete();
                        sendmailobj.SendEmailToSyncInitiatorOnSuccess();
                    }
                    system.debug('job id--before job'); 
                    id jobid=System.enqueueJob(new OppAnalyticCalcQueue (oFTEids, nFTEids,oOCDids , nOcdids, costdataMap, oldBenchmarkObjId, newBenchmarkObjId, oldbnchServLocId, newBnchServLocId));
                    system.debug('job id-->'+jobid);    
                    isSuccess = true;
                }catch(DMLException de){
                    System.debug('DML Exception::'+de);
                    System.debug('DML Exception Line Number::'+de.getLineNumber());
                    
                    SendEmailOnBenchmarkSyncComplete sendmailobj = new SendEmailOnBenchmarkSyncComplete();
                    sendmailobj.SendEmailToSyncInitiatorOnSuccess();
                    Database.rollback(svPt);
                    ExceptionClass.logException(UtilConstants.BENCH_SYNC,UtilConstants.POP_BENCH_OBJS,de,UtilConstants.SWB,UtilConstants.SWB);
                   // updateCostingRequestOnSyncComplete costobj = new updateCostingRequestOnSyncComplete(bpoOpp.id);
                   // costobj.updateCostingRequestRecordOnFailure();
                   costing_request__c cost = new costing_request__c(id=costdatamap.get('ID'));
                   cost.Calculation__c = false;
                   cost.sync_failed_at__c = 'Benchmark';
                   cost.Data_Cleaning_dev__c =true;
                   cost.In_Progress_IO__c = costdatamap.get('In_Progress_PrevState__c'); 
                   update cost;
                   
                   sync_status__c syncstat = [select id,error__c, Calculation_failed__c from sync_Status__C where opportunity__c=:bpoOpp.id limit 1];
                   syncstat.error__c =SWBBPOSEIntegrationConstants.SYNCUNSUCCESFULSTATUSFAILED;
                   syncstat.Calculation_failed__c = true;
                   update syncstat;

                   
                   deleteSyncData(nFTEids,nOCDids,costdatamap);
                }catch(Exception ex){
                    System.debug('Exception::'+ex);
                    System.debug('Exception Line Number::'+ex.getLineNumber());
                    SendEmailOnBenchmarkSyncComplete sendmailobj = new SendEmailOnBenchmarkSyncComplete();
                    sendmailobj.SendEmailToSyncInitiatorOnSuccess();
                    Database.rollback(svPt);
                    ExceptionClass.logException(UtilConstants.BENCH_SYNC,UtilConstants.POP_BENCH_OBJS,ex,UtilConstants.SWB,UtilConstants.SWB);
                    //updateCostingRequestOnSyncComplete costobj = new updateCostingRequestOnSyncComplete(bpoOpp.id);
                   // costobj.updateCostingRequestRecordOnFailure();
                   costing_request__c cost = new costing_request__c(id=costdatamap.get('ID'));
                   cost.Calculation__c = false;
                   cost.sync_failed_at__c = 'Benchmark';
                   cost.Data_Cleaning_dev__c =true;
                   cost.In_Progress_IO__c = costdatamap.get('In_Progress_PrevState__c'); 
                   update cost;
                   
                   sync_status__c syncstat = [select id,error__c, Calculation_failed__c from sync_Status__C where opportunity__c=:bpoOpp.id limit 1];
                   syncstat.error__c =SWBBPOSEIntegrationConstants.SYNCUNSUCCESFULSTATUSFAILED;
                   syncstat.Calculation_failed__c = true;
                   update syncstat;
                   
                   deleteSyncData(nFTEids,nOCDids,costdatamap);
                }
                finally{        
                    if(!isSuccess){     
                        /*updateCostingRequestOnSyncComplete costobj = new updateCostingRequestOnSyncComplete(bpoOpp.id);     
                        costobj.updateCostingRequestRecordOnFailure(); */     
                    }
                    
                }
            }
        }
        
        /******************************
        Method Name: getFTEDetails
        Description: Invoke this method to fetch FTE Detail Records for an Opportunity
        Paramenters: NA
        Return Value: List<Opportunity> 
        *******************************/
        global Static List<Opportunity> getBPOOPP(Id OppId){
            List<Opportunity> bpoOppList=[select id, name,SAP_OM_ID__c,Account.name,AccountId from Opportunity where id =:OppId limit 1];
            return bpoOppList;
        }
        
        /******************************
        Method Name: getFTEandOtherCost
        Description: Invoke this method to fetch FTE Detail and Other Cost Records for an Opportunity
        Paramenters: NA
        Return Value: void. 
        *******************************/
        global Static Id getFTEandOtherCost(Set<Id> nFTEids,Set<Id> nOCDids){
            Id bpoOppId=null;
            try{
                inputFTEDetail = [SELECT Activity_Description__c,Delivery_Location_Dev__c,Career_Level__r.Name,Service__r.Services__r.name,Sub_Service_Group__r.Offering_Master__r.name,
                                        Bill_Code__c,Baseline_FTEs__c, Career_Level__c,Career_Track__c,Country__c,Country__r.Name,Costing_Type__c,Economic_Profile__c,
                                        Load_Type__c,Location_typeCode__c,Location_typeName__c,Language__c,Opportunity__c,Phase__c,Pyramid_Richness__c,Rate_Type__c,
                                        Resource_Group__c,Role_Master__c,Service_Component_Name__c,Service_Component__c,Service_Group__c,
                                        Service_Name__c,Service__c,Service__r.Serv_Nm__c,Sub_Service_Group_Name__c,Sub_Service_Group__c,Sub_Service_Group__r.Name,Y1_Dev__c,Y2_Dev__c,Y3_Dev__c,Y4_Dev__c,Y5_Dev__c,
                                        Y6_Dev__c,Y7_Dev__c,Y8_Dev__c,Y9_Dev__c,Y10_Dev__c,Mob_Cost__c,Run_Yr1__c,Run_Yr2__c,Run_Yr3__c,Run_Yr4__c,Run_Yr5__c,Run_Yr6__c,Run_Yr7__c, 
                                        Run_Yr8__c,Run_Yr9__c,Run_Yr10__c,Mob_Totals__c,FTEYr1__c,FTEYr2__c,FTEYr3__c,FTEYr4__c,FTEYr5__c,FTEYr6__c,FTEYr7__c,
                                        FTEYr8__c,FTEYr9__c,FTEYr10__c,FTEMobTotals__c,Mobilization_Start_Date__c,Go_Live_Date__c,Delivery_Location__r.Name,
                                        Column4__c,FTE_TYPE__c,Opportunity_Delivery_Location__r.Delivery_Location__r.name,Costing_Request__r.Opportunity__c,Final_Month_FTE__c, 
                                        Service__r.Delivery_Locations__c, Transformation_Totals__c
                                        FROM FTE_Details__c where id in :nFTEids LIMIT 5000];
                                
              inputOtherCost =[SELECT  Id, Name,Service__r.Services__r.name,Sub_Service_Group__r.Offering_Master__r.name, 
                                  Service__c, Country__c, Career_Level__c,Service__r.Name, Career_Level__r.Name, Country__r.Name,Sum_of_Other_Costs__c,
                                  Costing_Type__c,Sub_Service_Group__r.Name,Service_Name__c,Mob_Cost__c,Run_Yr1__c,Run_Yr2__c,Run_Yr3__c,Run_Yr4__c,Run_Yr5__c,
                                  Run_Yr6__c,Run_Yr7__c,Run_Yr8__c,Run_Yr9__c,Run_Yr10__c,Mob_Totals__c,Service__r.Serv_Nm__c,Sub_Service_Group_Name__c,Y1__c,
                                  Y2__c,Y3__c,Y4__c,Y5__c,Y6__c,Y7__c,Y8__c,Y9__c,Y10__c,Costing_Request__r.Opportunity__c, Transformation_Totals__c
                                  FROM Other_Cost_Details__c WHERE id in :nOCDids LIMIT 5000];                  
            system.debug('inputFTEDetail'+inputFTEDetail);  
            if(inputFTEDetail.size()>0){
                bpoOppId=inputFTEDetail[0].Costing_Request__r.Opportunity__c;
            }else if(inputOtherCost.size()>0){
                bpoOppId=inputOtherCost[0].Costing_Request__r.Opportunity__c;
            }
            if(inputFTEDetail.size()>4000){
                isSendMail = true;
                
            }
            system.debug('bpoOppId'+bpoOppId);
            inputCostingRequest = [Select Client__c, Contract_End__c,Allow_Deal_Customization__c, HasMasterDataBeenCustomizedForDeal__c,Contract_Start__c, Initial_Go_Live__c, SAP_OM_ID__c, Synced_Scenario_Name__c, SSM_Version__c, Version__c from Costing_Request__c where Opportunity__c =:bpoOppId LIMIT 1];
            
            }catch(QueryException qe){
                throw(qe);
            }catch(Exception ex){
                throw(ex);
            }
            return bpoOppId;
        }
        
        
        /******************************
        Method Name: createUniqueBenchmark
        Description: This private method is invoked to insert benchmark opportunity object
        Paramenters: NA
        Return Value: NA
        *******************************/
        global Static id createUniqueBenchmark(){
            BenchmarkWrapper benchWr = new BenchmarkWrapper();
            for(FTE_Details__c fterec : inputFTEDetail){
            
                //calculation for count of languages

                    if(!(string.isBlank(fterec.Language__c)))
                    {
                        languageSet.add(fterec.Language__c);
                    }
                    
                 //calculation for count of delivery locations
                    if(!(string.isBlank(fterec.Delivery_Location_Dev__c)))  
                    {
                        deliveryLocSet.add(fterec.Delivery_Location_Dev__c);
                    }    
            
                if(fterec!=null && UtilConstants.SDO.equalsIgnoreCase(fterec.Costing_Type__c)  ){    
                    
                    //calculation for number of locations

                    if(!(string.isBlank(fterec.Country__c))){
                        countryList.add(fterec.Country__c);
                    }
                    
                    
                    //calculation for pyramid richness
                    if(UtilConstants.ASSOCIATE13.equalsIgnoreCase(fterec.Career_Level__r.Name)){
                        benchWr.sumOfFteLvl1+= fterec.FTEYr1__c;
                    }else if(UtilConstants.ASSOCIATE12.equalsIgnoreCase(fterec.Career_Level__r.Name)){
                        benchWr.sumOfFteLvl2+= fterec.FTEYr1__c;
                    }else if(UtilConstants.ANALYST11.equalsIgnoreCase(fterec.Career_Level__r.Name)){
                        benchWr.sumOfFtLvl3+= fterec.FTEYr1__c;
                    }else if(UtilConstants.ANALYST10.equalsIgnoreCase(fterec.Career_Level__r.Name)){
                        benchWr.sumOfFteLvl4+= fterec.FTEYr1__c;
                    }else if(UtilConstants.CONSULTANT9.equalsIgnoreCase(fterec.Career_Level__r.Name)){
                        benchWr.sumOfFteLvl5+= fterec.FTEYr1__c;
                    }else if(UtilConstants.CONSULTANT8.equalsIgnoreCase(fterec.Career_Level__r.Name)){
                        benchWr.sumOfFteLvl6+= fterec.FTEYr1__c;
                    }else if(UtilConstants.MANAGER7.equalsIgnoreCase(fterec.Career_Level__r.Name)){
                        benchWr.sumOfFteLvl7+= fterec.FTEYr1__c;
                    }else if(UtilConstants.SENIORMANAGER6.equalsIgnoreCase(fterec.Career_Level__r.Name) || UtilConstants.SENIORMANAGER5.equalsIgnoreCase(fterec.Career_Level__r.Name)){
                        benchWr.sumOfFteLvl8+= fterec.FTEYr1__c;

                    }else{}
                    
                    //Calculation for Baseline FTEs
                    {
                        benchWr.baselineftes += fterec.Baseline_FTEs__c;
                    }
                    
                    
                    //Calculation for Onshore/Offshore/Nearshore Baseline ftes
                    if(UtilConstants.ONE_1.equalsIgnoreCase(fterec.Location_typeCode__c))
                    {
                        benchWr.onshoreBaselineSDOFTEs += fterec.Baseline_FTEs__c;
                    }
                    else if(UtilConstants.TWO_2.equalsIgnoreCase(fterec.Location_typeCode__c))
                    {
                        benchWr.nearshoreBaselineSDOFTEs += fterec.Baseline_FTEs__c;
                    }
                    else if(UtilConstants.THREE_3.equalsIgnoreCase(fterec.Location_typeCode__c))
                    {
                        benchWr.offshoreBaselineSDOFTEs += fterec.Baseline_FTEs__c;

                    }else{}
                }
            }
            
            //Calculation for Pyramid Richness
            if(benchWr != null){
                benchWr.sumOfSumFTEyr = benchWr.sumOfFteLvl1 + benchWr.sumOfFteLvl2 + benchWr.sumOfFtLvl3 + benchWr.sumOfFteLvl4 + benchWr.sumOfFteLvl5 + benchWr.sumOfFteLvl6 + benchWr.sumOfFteLvl7 + benchWr.sumOfFteLvl8;
                benchWr.effSumOfSumFTEyr = benchWr.sumOfFteLvl1*1 + benchWr.sumOfFteLvl2*2 + benchWr.sumOfFtLvl3*3 + benchWr.sumOfFteLvl4*4 + benchWr.sumOfFteLvl5*5 + benchWr.sumOfFteLvl6*6 + benchWr.sumOfFteLvl7*7 + benchWr.sumOfFteLvl8*8;
                if(!(benchWr.sumOfSumFTEyr==0|| benchWr.effSumOfSumFTEyr==0)){
                    benchWr.pyramidrichness = benchWr.sumOfSumFTEyr / benchWr.effSumOfSumFTEyr;
                }
            }
            
            benchmarkrecs.Name=bpoOpp.name+ UtilConstants.VFP_BENCHMARK_DATA;
            //benchmarkrecs.Name=UtilConstants.VFP_BENCHMARK_DATA;
            benchmarkrecs.Deal_Unlocked__c = inputCostingRequest.Allow_Deal_Customization__c;
            benchmarkrecs.Deal_Data_Tables_Updated__c = inputCostingRequest.HasMasterDataBeenCustomizedForDeal__c;
            benchmarkrecs.Onshore_Baseline_FTEs__c = benchWr.onshoreBaselineSDOFTEs.setscale(4);
            benchmarkrecs.Nearshore_Baseline_FTEs__c = benchWr.nearshoreBaselineSDOFTEs.setscale(4);
            benchmarkrecs.Offshore_Baseline_FTEs__c = benchWr.offshoreBaselineSDOFTEs.setscale(4);
            benchmarkrecs.Pyramid_Richness_Year1__c = benchWr.pyramidrichness.setscale(4);
            benchmarkrecs.Opportunity__c = bpoOpp.id;
            benchmarkrecs.Contract_End_Date__c = inputCostingRequest.Contract_End__c;
            benchmarkrecs.Contract_Start_Date__c = inputCostingRequest.Contract_Start__c;
            benchmarkrecs.Initial_Go_Live__c = inputCostingRequest.Initial_Go_Live__c;
            benchmarkrecs.SAP_OM_ID__c = bpoOpp.SAP_OM_ID__c;
            benchmarkrecs.Scenario__c = inputCostingRequest.Synced_Scenario_Name__c;
            benchmarkrecs.SSM_Version__c = inputCostingRequest.SSM_Version__c;
            benchmarkrecs.Version__c = inputCostingRequest.Version__c;
            benchmarkrecs.Client__c = bpoOpp.AccountId;
            benchmarkrecs.of_Locations__c = countryList.size();
            benchmarkrecs.Active__c = TRUE;
            benchmarkrecs.Inc_in_BM_Report__c = UtilConstants.NOT_REVIEWED;
            benchmarkrecs.Count_of_Language__c = String.valueOf(languageSet.size());
            benchmarkrecs.Baseline_FTEs__c = benchWr.baselineftes.setscale(4);
            benchmarkrecs.Number_of_locations_where_scope_is_deliv__c = deliveryLocSet.size();
            benchmarkrecs.Service_Group__C = UtilConstants.BPO;
            
            
            //Calculations for roll-up summary fields
            BenchMarkOppWrapper bnchOpp = new BenchMarkOppWrapper();
            
            if(inputFTEDetail  <>  null){
                for(FTE_Details__c  fte: inputFTEDetail  ){
                    bnchOpp.FTE_Grand_Total_Cost += fte.Mob_Totals__c+ fte.Run_Yr1__c + fte.Run_Yr2__c + fte.Run_Yr3__c + fte.Run_Yr4__c +
                                                                                    fte.Run_Yr5__c +  fte.Run_Yr6__c + fte.Run_Yr7__c + fte.Run_Yr8__c + fte.Run_Yr9__c + fte.Run_Yr10__c ;
                    if(UtilConstants.SDO.equalsIgnoreCase(fte.Costing_Type__c)){
                        bnchOpp.FTE_SDO_Total_Cost += fte.Mob_Totals__c+ fte.Run_Yr1__c + fte.Run_Yr2__c + fte.Run_Yr3__c + fte.Run_Yr4__c +
                        fte.Run_Yr5__c +  fte.Run_Yr6__c + fte.Run_Yr7__c + fte.Run_Yr8__c + fte.Run_Yr9__c + fte.Run_Yr10__c ;
                    }else if(UtilConstants.BSS.equalsIgnoreCase(fte.Costing_Type__c)){
                        bnchOpp.FTE_BSS_Total_Cost += fte.Mob_Totals__c+ fte.Run_Yr1__c + fte.Run_Yr2__c + fte.Run_Yr3__c + fte.Run_Yr4__c + 
                        fte.Run_Yr5__c +  fte.Run_Yr6__c + fte.Run_Yr7__c + fte.Run_Yr8__c + fte.Run_Yr9__c + fte.Run_Yr10__c ;
                    }else if( UtilConstants.TECH.equalsIgnoreCase(fte.Costing_Type__c)){
                        bnchOpp.FTE_Technology_Total_Cost += fte.Mob_Totals__c+ fte.Run_Yr1__c + fte.Run_Yr2__c + fte.Run_Yr3__c + fte.Run_Yr4__c +
                        fte.Run_Yr5__c +  fte.Run_Yr6__c + fte.Run_Yr7__c + fte.Run_Yr8__c + fte.Run_Yr9__c + fte.Run_Yr10__c ;
                    }else if(UtilConstants.MOB.equalsIgnoreCase(fte.Costing_Type__c)){
                        bnchOpp.FTE_Mobilization_Total_Cost += fte.Mob_Totals__c+ fte.Run_Yr1__c + fte.Run_Yr2__c + fte.Run_Yr3__c + fte.Run_Yr4__c +
                        fte.Run_Yr5__c +  fte.Run_Yr6__c + fte.Run_Yr7__c + fte.Run_Yr8__c + fte.Run_Yr9__c + fte.Run_Yr10__c ;
                    }else if(UtilConstants.PMO.equalsIgnoreCase(fte.Costing_Type__c) ){
                        bnchOpp.FTE_PMO_Total_Cost += fte.Mob_Totals__c+ fte.Run_Yr1__c + fte.Run_Yr2__c + fte.Run_Yr3__c + fte.Run_Yr4__c +
                        fte.Run_Yr5__c +  fte.Run_Yr6__c + fte.Run_Yr7__c + fte.Run_Yr8__c + fte.Run_Yr9__c + fte.Run_Yr10__c ;

                    }else{}
               
                    //Costing type Comparison Ends Here
                    if(UtilConstants.SER_MGMT.equalsIgnoreCase(fte.Service__r.Services__r.name )){
                        bnchOpp.FTE_Service_Management_Total_Cost += fte.Mob_Totals__c+ fte.Run_Yr1__c + fte.Run_Yr2__c + fte.Run_Yr3__c + fte.Run_Yr4__c +
                        fte.Run_Yr5__c +  fte.Run_Yr6__c + fte.Run_Yr7__c + fte.Run_Yr8__c + fte.Run_Yr9__c + fte.Run_Yr10__c ;
                    }else if(UtilConstants.SUP_CENT.equalsIgnoreCase(fte.Service__r.Services__r.name)){
                        bnchOpp.FTE_Support_Center_Total_Cost += fte.Mob_Totals__c+ fte.Run_Yr1__c + fte.Run_Yr2__c + fte.Run_Yr3__c + fte.Run_Yr4__c +
                        fte.Run_Yr5__c +  fte.Run_Yr6__c + fte.Run_Yr7__c + fte.Run_Yr8__c + fte.Run_Yr9__c + fte.Run_Yr10__c ;
                    }else if(UtilConstants.EDM.equalsIgnoreCase(fte.Service__r.Services__r.name)){
                        bnchOpp.FTE_Electronic_Data_Management_Total_Cos += fte.Mob_Totals__c+ fte.Run_Yr1__c + fte.Run_Yr2__c + fte.Run_Yr3__c + fte.Run_Yr4__c +
                        fte.Run_Yr5__c +  fte.Run_Yr6__c + fte.Run_Yr7__c + fte.Run_Yr8__c + fte.Run_Yr9__c + fte.Run_Yr10__c ;
                    }else if(UtilConstants.CMD_CENT.equalsIgnoreCase(fte.Service__r.Services__r.name)){
                        bnchOpp.FTE_Command_Center_Total_Cost += fte.Mob_Totals__c+ fte.Run_Yr1__c + fte.Run_Yr2__c + fte.Run_Yr3__c + fte.Run_Yr4__c +
                        fte.Run_Yr5__c +  fte.Run_Yr6__c + fte.Run_Yr7__c + fte.Run_Yr8__c + fte.Run_Yr9__c + fte.Run_Yr10__c ;
                    }else if(UtilConstants.TECH_TOOLS.equalsIgnoreCase(fte.Service__r.Services__r.name)){
                        bnchOpp.FTE_Technology_Tools_Total_Cost += fte.Mob_Totals__c+ fte.Run_Yr1__c + fte.Run_Yr2__c + fte.Run_Yr3__c + fte.Run_Yr4__c +
                        fte.Run_Yr5__c +  fte.Run_Yr6__c + fte.Run_Yr7__c + fte.Run_Yr8__c + fte.Run_Yr9__c + fte.Run_Yr10__c ;
                    }else if(UtilConstants.VOICE_DATA.equalsIgnoreCase(fte.Service__r.Services__r.name)){
                        bnchOpp.FTE_Voice_and_Data_Total_Cost  += fte.Mob_Totals__c + fte.Run_Yr1__c + fte.Run_Yr2__c + fte.Run_Yr3__c + fte.Run_Yr4__c +
                        fte.Run_Yr5__c +  fte.Run_Yr6__c + fte.Run_Yr7__c + fte.Run_Yr8__c + fte.Run_Yr9__c + fte.Run_Yr10__c ;
                    }else if(UtilConstants.OADM.equalsIgnoreCase(fte.Service__r.Services__r.name)){
                        bnchOpp.FTE_OADM_Total_Cost += fte.Mob_Totals__c+ fte.Run_Yr1__c + fte.Run_Yr2__c + fte.Run_Yr3__c + fte.Run_Yr4__c +
                        fte.Run_Yr5__c +  fte.Run_Yr6__c + fte.Run_Yr7__c + fte.Run_Yr8__c + fte.Run_Yr9__c + fte.Run_Yr10__c ;
                    }else if(UtilConstants.CFM.equalsIgnoreCase(fte.Service__r.Services__r.name)){
                        bnchOpp.FTE_CFM_Total_Cost += fte.Mob_Totals__c+ fte.Run_Yr1__c + fte.Run_Yr2__c + fte.Run_Yr3__c + fte.Run_Yr4__c +
                        fte.Run_Yr5__c +  fte.Run_Yr6__c + fte.Run_Yr7__c + fte.Run_Yr8__c + fte.Run_Yr9__c + fte.Run_Yr10__c ;
                    }else if(UtilConstants.CM.equalsIgnoreCase(fte.Service__r.Services__r.name)){
                        bnchOpp.FTE_CM_Total_Cost += fte.Mob_Totals__c+ fte.Run_Yr1__c + fte.Run_Yr2__c + fte.Run_Yr3__c + fte.Run_Yr4__c +
                        fte.Run_Yr5__c +  fte.Run_Yr6__c + fte.Run_Yr7__c + fte.Run_Yr8__c + fte.Run_Yr9__c + fte.Run_Yr10__c ;
                    }else if(UtilConstants.QAD.equalsIgnoreCase(fte.Service__r.Services__r.name)){
                        bnchOpp.FTE_QAD_Total_Cost += fte.Mob_Totals__c+ fte.Run_Yr1__c + fte.Run_Yr2__c + fte.Run_Yr3__c + fte.Run_Yr4__c +
                        fte.Run_Yr5__c +  fte.Run_Yr6__c + fte.Run_Yr7__c + fte.Run_Yr8__c + fte.Run_Yr9__c + fte.Run_Yr10__c ;

                    }else{}
                }
            }  
            if(inputOtherCost <>  null){
                for(Other_Cost_Details__c  ccs : inputOtherCost){
                    bnchOpp.CC_Grand_Total_Cost += ccs.Mob_Totals__c+ ccs.Run_Yr1__c + ccs.Run_Yr2__c + ccs.Run_Yr3__c + ccs.Run_Yr4__c +
                    ccs.Run_Yr5__c +  ccs.Run_Yr6__c + ccs.Run_Yr7__c + ccs.Run_Yr8__c + ccs.Run_Yr9__c + ccs.Run_Yr10__c ;
                   
                    if(UtilConstants.SDO.equalsIgnoreCase(ccs.Costing_Type__c)){
                        bnchOpp.CC_SDO_Total_Cost += ccs.Mob_Totals__c+ ccs.Run_Yr1__c + ccs.Run_Yr2__c + ccs.Run_Yr3__c + ccs.Run_Yr4__c +
                        ccs.Run_Yr5__c +  ccs.Run_Yr6__c + ccs.Run_Yr7__c + ccs.Run_Yr8__c + ccs.Run_Yr9__c + ccs.Run_Yr10__c ;
                    }else if(UtilConstants.BSS.equalsIgnoreCase(ccs.Costing_Type__c)){
                   bnchOpp.CC_BSS_Total_Cost += ccs.Mob_Totals__c + ccs.Run_Yr1__c + ccs.Run_Yr2__c + ccs.Run_Yr3__c + ccs.Run_Yr4__c + 
                   ccs.Run_Yr5__c +  ccs.Run_Yr6__c + ccs.Run_Yr7__c + ccs.Run_Yr8__c + ccs.Run_Yr9__c + ccs.Run_Yr10__c ;
               }else if( UtilConstants.TECH.equalsIgnoreCase(ccs.Costing_Type__c)){
                   bnchOpp.CC_Technology_Total_Cost += ccs.Mob_Totals__c+ ccs.Run_Yr1__c + ccs.Run_Yr2__c + ccs.Run_Yr3__c + ccs.Run_Yr4__c +
                   ccs.Run_Yr5__c +  ccs.Run_Yr6__c + ccs.Run_Yr7__c + ccs.Run_Yr8__c + ccs.Run_Yr9__c + ccs.Run_Yr10__c ;
               }else if(UtilConstants.MOB.equalsIgnoreCase(ccs.Costing_Type__c)){
                   bnchOpp.CC_Mobilization_Total_Cost += ccs.Mob_Totals__c + ccs.Run_Yr1__c + ccs.Run_Yr2__c + ccs.Run_Yr3__c + ccs.Run_Yr4__c +
                   ccs.Run_Yr5__c +  ccs.Run_Yr6__c + ccs.Run_Yr7__c + ccs.Run_Yr8__c + ccs.Run_Yr9__c + ccs.Run_Yr10__c ;
               }else if(UtilConstants.PMO.equalsIgnoreCase(ccs.Costing_Type__c) ){
                   bnchOpp.CC_PMO_Total_Cost += ccs.Mob_Totals__c+ ccs.Run_Yr1__c + ccs.Run_Yr2__c + ccs.Run_Yr3__c + ccs.Run_Yr4__c +
                   ccs.Run_Yr5__c +  ccs.Run_Yr6__c + ccs.Run_Yr7__c + ccs.Run_Yr8__c + ccs.Run_Yr9__c + ccs.Run_Yr10__c ;

               }else{}
               //Costing type Comparison Ends Here
               
               if(UtilConstants.SER_MGMT.equalsIgnoreCase( ccs.Service__r.Services__r.name)){
                   bnchOpp.CC_Service_Management_Total_Cost += ccs.Mob_Totals__c+ ccs.Run_Yr1__c + ccs.Run_Yr2__c + ccs.Run_Yr3__c + ccs.Run_Yr4__c +
                   ccs.Run_Yr5__c +  ccs.Run_Yr6__c + ccs.Run_Yr7__c + ccs.Run_Yr8__c + ccs.Run_Yr9__c + ccs.Run_Yr10__c ;
               }else if(UtilConstants.SUP_CENT.equalsIgnoreCase(ccs.Service__r.Services__r.name)){
                   bnchOpp.CC_Support_Center_Total_Cost += ccs.Mob_Totals__c+ ccs.Run_Yr1__c + ccs.Run_Yr2__c + ccs.Run_Yr3__c + ccs.Run_Yr4__c +
                   ccs.Run_Yr5__c +  ccs.Run_Yr6__c + ccs.Run_Yr7__c + ccs.Run_Yr8__c + ccs.Run_Yr9__c + ccs.Run_Yr10__c ;
               }else if(UtilConstants.EDM.equalsIgnoreCase(ccs.Service__r.Services__r.name)){
                   bnchOpp.CC_Electronic_Data_Management_Total_Cost += ccs.Mob_Totals__c+ ccs.Run_Yr1__c + ccs.Run_Yr2__c + ccs.Run_Yr3__c + ccs.Run_Yr4__c +
                   ccs.Run_Yr5__c +  ccs.Run_Yr6__c + ccs.Run_Yr7__c + ccs.Run_Yr8__c + ccs.Run_Yr9__c + ccs.Run_Yr10__c ;
               }else if(UtilConstants.CMD_CENT.equalsIgnoreCase(ccs.Service__r.Services__r.name)){
                    bnchOpp.CC_Command_Center_Total_Cost += ccs.Mob_Totals__c+ ccs.Run_Yr1__c + ccs.Run_Yr2__c + ccs.Run_Yr3__c + ccs.Run_Yr4__c +
                   ccs.Run_Yr5__c +  ccs.Run_Yr6__c + ccs.Run_Yr7__c + ccs.Run_Yr8__c + ccs.Run_Yr9__c + ccs.Run_Yr10__c ;
               }else if(UtilConstants.TECH_TOOLS.equalsIgnoreCase(ccs.Service__r.Services__r.name)){
                   bnchOpp.CC_Technology_Tools_Total_Cost += ccs.Mob_Totals__c+ ccs.Run_Yr1__c + ccs.Run_Yr2__c + ccs.Run_Yr3__c + ccs.Run_Yr4__c +
                   ccs.Run_Yr5__c +  ccs.Run_Yr6__c + ccs.Run_Yr7__c + ccs.Run_Yr8__c + ccs.Run_Yr9__c + ccs.Run_Yr10__c ;
               }else if(UtilConstants.VOICE_DATA.equalsIgnoreCase(ccs.Service__r.Services__r.name)){
                  bnchOpp.CC_Voice_and_Data_Total_Cost  += ccs.Mob_Totals__c+ ccs.Run_Yr1__c + ccs.Run_Yr2__c + ccs.Run_Yr3__c + ccs.Run_Yr4__c +
                   ccs.Run_Yr5__c +  ccs.Run_Yr6__c + ccs.Run_Yr7__c + ccs.Run_Yr8__c + ccs.Run_Yr9__c + ccs.Run_Yr10__c ;
               }else if(UtilConstants.OADM.equalsIgnoreCase(ccs.Service__r.Services__r.name)){
                   bnchOpp.CC_OADM_Total_Cost += ccs.Mob_Totals__c+ ccs.Run_Yr1__c + ccs.Run_Yr2__c + ccs.Run_Yr3__c + ccs.Run_Yr4__c +
                   ccs.Run_Yr5__c +  ccs.Run_Yr6__c + ccs.Run_Yr7__c + ccs.Run_Yr8__c + ccs.Run_Yr9__c + ccs.Run_Yr10__c ;
               }else if(UtilConstants.CFM.equalsIgnoreCase(ccs.Service__r.Services__r.name)){
                   bnchOpp.CC_CFM_Total_Cost += ccs.Mob_Totals__c+ ccs.Run_Yr1__c + ccs.Run_Yr2__c + ccs.Run_Yr3__c + ccs.Run_Yr4__c +
                   ccs.Run_Yr5__c +  ccs.Run_Yr6__c + ccs.Run_Yr7__c + ccs.Run_Yr8__c + ccs.Run_Yr9__c + ccs.Run_Yr10__c ;
               }else if(UtilConstants.CM.equalsIgnoreCase(ccs.Service__r.Services__r.name)){
                   bnchOpp.CC_CM_Total_Cost += ccs.Mob_Totals__c+ ccs.Run_Yr1__c + ccs.Run_Yr2__c + ccs.Run_Yr3__c + ccs.Run_Yr4__c +
                   ccs.Run_Yr5__c +  ccs.Run_Yr6__c + ccs.Run_Yr7__c + ccs.Run_Yr8__c + ccs.Run_Yr9__c + ccs.Run_Yr10__c ;
               }else if(UtilConstants.QAD.equalsIgnoreCase(ccs.Service__r.Services__r.name)){
                   bnchOpp.CC_QAD_Total_Cost += ccs.Mob_Totals__c+ ccs.Run_Yr1__c + ccs.Run_Yr2__c + ccs.Run_Yr3__c + ccs.Run_Yr4__c +
                   ccs.Run_Yr5__c +  ccs.Run_Yr6__c + ccs.Run_Yr7__c + ccs.Run_Yr8__c + ccs.Run_Yr9__c + ccs.Run_Yr10__c ;

               }else{}
            }
           //End of For loop
        }
        benchmarkrecs.BSS_Total_Cost__c =(bnchOpp.FTE_BSS_Total_Cost + bnchOpp.CC_BSS_Total_Cost).setscale(4);
        benchmarkrecs.CFM_Total_Cost__c =(bnchOpp.FTE_CFM_Total_Cost + bnchOpp.CC_CFM_Total_Cost).setscale(4);
        benchmarkrecs.CM_Total_Cost__c = (bnchOpp.FTE_CM_Total_Cost + bnchOpp.CC_CM_Total_Cost).setscale(4);
        benchmarkrecs.Command_Center_Total_Cost__c = (bnchOpp.FTE_Command_Center_Total_Cost + bnchOpp.CC_Command_Center_Total_Cost).setscale(4);
        benchmarkrecs.Electronic_Documentation_Mgmy_Total__c = (bnchOpp.FTE_Electronic_Data_Management_Total_Cos + bnchOpp.CC_Electronic_Data_Management_Total_Cost).setscale(4);
        benchmarkrecs.Grand_Total_Cost__c = (bnchOpp.FTE_Grand_Total_Cost + bnchOpp.CC_Grand_Total_Cost).setscale(4);
        benchmarkrecs.Mobilization_Total_Cost__c = (bnchOpp.FTE_Mobilization_Total_Cost + bnchOpp.CC_Mobilization_Total_Cost).setscale(4);
        benchmarkrecs.OADM_Total_Cost__c = (bnchOpp.FTE_OADM_Total_Cost + bnchOpp.CC_OADM_Total_Cost).setscale(4);
        benchmarkrecs.PMO_Total_Cost__c =(bnchOpp.FTE_PMO_Total_Cost + bnchOpp.CC_PMO_Total_Cost).setscale(4);
        benchmarkrecs.QAD_Total_Cost__c = (bnchOpp.FTE_QAD_Total_Cost + bnchOpp.CC_QAD_Total_Cost).setscale(4);
        benchmarkrecs.SDO_Total_Cost__c = (bnchOpp.FTE_SDO_Total_Cost + bnchOpp.CC_SDO_Total_Cost).setScale(4);
        benchmarkrecs.Service_Management_Total_Cost__c = (bnchOpp.FTE_Service_Management_Total_Cost + bnchOpp.CC_Service_Management_Total_Cost).setscale(4);
        benchmarkrecs.Support_Center_Total_Cost__c = (bnchOpp.FTE_Support_Center_Total_Cost + bnchOpp.CC_Support_Center_Total_Cost).setscale(4);
        benchmarkrecs.Technology_Tools_Total_Cost__c = (bnchOpp.FTE_Technology_Tools_Total_Cost + bnchOpp.CC_Technology_Tools_Total_Cost).setscale(4);
        benchmarkrecs.Technology_Total_Cost__c = (bnchOpp.FTE_Technology_Total_Cost + bnchOpp.CC_Technology_Total_Cost).setscale(4);
        benchmarkrecs.Voice_and_Data_Total_Cost__c =bnchOpp.FTE_Voice_and_Data_Total_Cost + bnchOpp.CC_Voice_and_Data_Total_Cost;  
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
    Method Name: updateMultiSingleOPP
    Description: 
    Paramenters: FTE_Details__c
    Return Value: NA
    *******************************/
    global static void updateMultiSingleOPP(){
        //For updating multi/single offering
        BenchMark__c benchmarkUpdate = [Select Id, of_offerings_in_scope__c, Multi_Single_Offering__c  from BenchMark__c where id =:benchmarkrecs.id Limit 1];
        if(UtilConstants.EMPTY_STRING.equals(benchmarkUpdate.of_offerings_in_scope__c))
        {
            benchmarkUpdate.Multi_Single_Offering__c = UtilConstants.EMPTY_STRING;
        }
        else
        {
            if(benchmarkUpdate.of_offerings_in_scope__c > 1)
            {
                benchmarkUpdate.Multi_Single_Offering__c = UtilConstants.MULTIPLE;
            }
            else
            {
                benchmarkUpdate.Multi_Single_Offering__c = UtilConstants.SINGLE;
            }
        }

        try
        {
            Database.update(benchmarkUpdate, true);
        }catch(DMLException de){
            throw(de);
        }
    
    }
    
    /******************************
    Method Name:updateCommercialData
    Description:to update Commercial Data with benchmark ID
    Parameters: NA
    Return Value:NA
    ******************************/
    global static void updateCommercialData(ID Id){
        List<Commercial_Data__c> comdataList = [Select id, BenchMark__c, Opportunity__r.Off__c from Commercial_Data__c where Opportunity__c=:Id];
        List<BenchMark__c> benchrecsList = [Select id, BenchMark_Delivery_Location__c, Opportunity__r.Delivery_Locations__c from benchmark__c where Opportunity__c=:Id AND Service_Group__c =: UtilCOnstants.BPO ORDER BY CreatedDate DESC LIMIT 1];
        
        if(comdataList.size()>0 && benchrecsList.size() > 0)
        {
            comdataList[0].benchmark__c = benchrecsList[0].id;
            benchrecsList[0].BenchMark_Delivery_Location__c = benchrecsList[0].Opportunity__r.Delivery_Locations__c;
        }
        try{
        if(comdataList.size()>0 && benchrecsList.size() > 0)
        {
        Database.update(comdataList);
        Database.update(benchrecsList);
        }
        }catch(DMLException de)
        {
            throw(de);
        }
    }
    
    /******************************
    Method Name: createUniqueOtherCost
    Description: 
    Paramenters: FTE_Details__c
    Return Value: NA
    *******************************/
    global Static void createbenchmarkOffering(){
        /**** Reading from Other Cost  ****/
        String key =UtilConstants.EMPTY_STRING;
        Map<String,Set<String>> languageMap = new Map<String,Set<String>>();
        Set<String> languages;
        /**** Reading from Other Cost  ****/
        /**** Reading from FTE  ****/
        integer count =0;
        integer noOfLang = 0;
        integer fteType = 0;
        decimal avglocationDef = 0;
        for(FTE_Details__c  rec: inputFTEDetail ){
            key = rec.Costing_Type__c + rec.Sub_Service_Group__r.Offering_Master__r.name + rec.Service__r.Serv_Nm__c;
            if(mapOfWrapper.get(key)!=null){
                // Addition Logic
                count++;
               if(rec.Location_typeCode__c==null){
                    avglocationDef = 0;  
                }else {
                    avglocationDef = integer.valueOf(rec.Location_typeCode__c);  
                }
                
                //fTE TYPE ASSIGNMENT
                if(rec.fte_type__c==null){
                    fteType = 0;  
                }else if(rec.fte_type__c==UtilConstants.EMPLOYEE){
                    fteType = 1;  
                }else if(rec.fte_type__c==UtilConstants.CONTRACTORS){
                    fteType = 2;  
                }else if(rec.fte_type__c==UtilConstants.HEADCOUNTTRANSFER){
                    fteType = 3;  
                }else{}

                
                benchmarkOffering newOff = mapOfWrapper.get(key);
                
                newOff.Sum_of_Total_Cost += rec.Mob_Totals__c + rec.Run_Yr1__c + rec.Run_Yr2__c + rec.Run_Yr3__c + rec.Run_Yr4__c + rec.Run_Yr5__c + rec.Run_Yr6__c + rec.Run_Yr7__c + rec.Run_Yr8__c + rec.Run_Yr9__c + rec.Run_Yr10__c;//Vaishnavi's code change
                newOff.Average_of_FTE_Type = ((newOff.Average_of_FTE_Type*(count-1))+fteType)/count;
                newOff.Average_of_Location_Definition = ((newOff.Average_of_Location_Definition*(count-1))+avglocationDef)/count;
                newOff.Average_of_Pyramid_Richness_Year_1 =((newOff.Average_of_Pyramid_Richness_Year_1*(count-1))+ rec.Pyramid_Richness__c)/count;
                if(rec.Language__c!=null){
                    newOff.Languages.add(rec.Language__c);
                }
                newOff.DCN_Location = UtilConstants.EMPTY_STRING;
                  
                if(UtilConstants.SDO.equalsIgnoreCase(rec.Costing_Type__c)){
                    if(UtilConstants.CONTRACTORS.equalsIgnoreCase(rec.FTE_Type__c)){
                        newOff.No_of_Contractors +=(rec.Y1_Dev__c+rec.Y2_Dev__c+rec.Y3_Dev__c+rec.Y4_Dev__c+rec.Y5_Dev__c+rec.Y6_Dev__c+rec.Y7_Dev__c+rec.Y8_Dev__c+rec.Y9_Dev__c+rec.Y10_Dev__c)/12;
                    }
                    if(UtilConstants.EMPLOYEE.equalsIgnoreCase(rec.FTE_Type__c)){
                        newOff.No_of_Employees +=(rec.Y1_Dev__c+rec.Y2_Dev__c+rec.Y3_Dev__c+rec.Y4_Dev__c+rec.Y5_Dev__c+rec.Y6_Dev__c+rec.Y7_Dev__c+rec.Y8_Dev__c+rec.Y9_Dev__c+rec.Y10_Dev__c)/12;
                    }
                    if(UtilConstants.HEADCOUNTTRANSFER.equalsIgnoreCase(rec.FTE_Type__c)){
                        newOff.of_Headcount_Transferred_from_client +=(rec.Y1_Dev__c+rec.Y2_Dev__c+rec.Y3_Dev__c+rec.Y4_Dev__c+rec.Y5_Dev__c+rec.Y6_Dev__c+rec.Y7_Dev__c+rec.Y8_Dev__c+rec.Y9_Dev__c+rec.Y10_Dev__c)/12;
                    }
                    if(UtilConstants.ACNONSHORE.equalsIgnoreCase(rec.Location_typeName__c)){
                        newOff.Onshore_Baseline_FTEs +=(rec.Y1_Dev__c+rec.Y2_Dev__c+rec.Y3_Dev__c+rec.Y4_Dev__c+rec.Y5_Dev__c+rec.Y6_Dev__c+rec.Y7_Dev__c+rec.Y8_Dev__c+rec.Y9_Dev__c+rec.Y10_Dev__c)/12;
                    }
                    if(UtilConstants.ACNNEARSHORE.equalsIgnoreCase(rec.Location_typeName__c)){
                        newOff.Nearshore_Baseline_FTEs +=(rec.Y1_Dev__c+rec.Y2_Dev__c+rec.Y3_Dev__c+rec.Y4_Dev__c+rec.Y5_Dev__c+rec.Y6_Dev__c+rec.Y7_Dev__c+rec.Y8_Dev__c+rec.Y9_Dev__c+rec.Y10_Dev__c)/12;
                    }
                    if(UtilConstants.ACNOFFSHORE.equalsIgnoreCase(rec.Location_typeName__c)){
                        newOff.Offshore_Baseline_FTEs +=(rec.Y1_Dev__c+rec.Y2_Dev__c+rec.Y3_Dev__c+rec.Y4_Dev__c+rec.Y5_Dev__c+rec.Y6_Dev__c+rec.Y7_Dev__c+rec.Y8_Dev__c+rec.Y9_Dev__c+rec.Y10_Dev__c)/12;
                    }
                }
                
                
                
                
                newOff.Sum_of_Average_FTEs += (rec.Y1_Dev__c+rec.Y2_Dev__c+rec.Y3_Dev__c+rec.Y4_Dev__c+rec.Y5_Dev__c+rec.Y6_Dev__c+rec.Y7_Dev__c+rec.Y8_Dev__c+rec.Y9_Dev__c+rec.Y10_Dev__c)/12;
                newOff.Sum_of_Baseline_FTEs += rec.Baseline_FTEs__c;
                newOff.Sum_of_Final_Month_FTE += rec.Final_Month_FTE__c;
                
                newOff.Tech_Tool = UtilConstants.EMPTY_STRING;
                mapOfWrapper.put(key,newOff);
                }else{
                    count =1;
                  
                if(rec.Location_typeCode__c==null){
                    avglocationDef = 0;  
                }else {
                    avglocationDef = integer.valueOf(rec.Location_typeCode__c);  
                }
                
                //fTE TYPE ASSIGNMENT
                if(rec.fte_type__c==null){
                    fteType = 0;  
                }else if(rec.fte_type__c==UtilConstants.EMPLOYEE){
                    fteType = 1;  
                }else if(rec.fte_type__c==UtilConstants.CONTRACTORS){
                    fteType = 2;  
                }else if(rec.fte_type__c==UtilConstants.HEADCOUNTTRANSFER){
                    fteType = 3;  
                }else{}

                    if(rec.Language__c!=null){
                        noOfLang=1;
                        languages = new Set<String>();
                        languages.add(rec.Language__c);
                        languageMap.put(key,languages);
                        }
                    
                        benchmarkOffering newOff = new benchmarkOffering();
                        newOff.name = rec.Service__r.Services__r.name;
                        newOff.Average_of_FTE_Type = fteType; //Need to check Later
                        newOff.Average_of_Location_Definition = avglocationDef;
                        newOff.Average_of_Pyramid_Richness_Year_1 = rec.Pyramid_Richness__c ;
                        newOff.BenchMark_Offering = rec.Sub_Service_Group__c ;
                        newOff.Costing_Type = rec.Costing_Type__c;
                        if(rec.Language__c!=null){
                            newOff.Languages.add(rec.Language__c);
                        }
                        newOff.DCN_Location = rec.Delivery_Location_Dev__c;
                    
                    if(UtilConstants.SDO.equalsIgnoreCase(rec.Costing_Type__c)){
                        if(UtilConstants.CONTRACTORS.equalsIgnoreCase(rec.FTE_Type__c)){
                            newOff.No_of_Contractors = (rec.Y1_Dev__c+rec.Y2_Dev__c+rec.Y3_Dev__c+rec.Y4_Dev__c+rec.Y5_Dev__c+rec.Y6_Dev__c+rec.Y7_Dev__c+rec.Y8_Dev__c+rec.Y9_Dev__c+rec.Y10_Dev__c)/12;
                        }
                        if(UtilConstants.EMPLOYEE.equalsIgnoreCase(rec.FTE_Type__c)){
                            newOff.No_of_Employees = (rec.Y1_Dev__c+rec.Y2_Dev__c+rec.Y3_Dev__c+rec.Y4_Dev__c+rec.Y5_Dev__c+rec.Y6_Dev__c+rec.Y7_Dev__c+rec.Y8_Dev__c+rec.Y9_Dev__c+rec.Y10_Dev__c)/12;
                        }
                        if(UtilConstants.HEADCOUNTTRANSFER.equalsIgnoreCase(rec.FTE_Type__c)){
                            newOff.of_Headcount_Transferred_from_client = (rec.Y1_Dev__c+rec.Y2_Dev__c+rec.Y3_Dev__c+rec.Y4_Dev__c+rec.Y5_Dev__c+rec.Y6_Dev__c+rec.Y7_Dev__c+rec.Y8_Dev__c+rec.Y9_Dev__c+rec.Y10_Dev__c)/12;
                        }
                        if(UtilConstants.ACNONSHORE.equalsIgnoreCase(rec.Location_typeName__c)){
                            newOff.Onshore_Baseline_FTEs = (rec.Y1_Dev__c+rec.Y2_Dev__c+rec.Y3_Dev__c+rec.Y4_Dev__c+rec.Y5_Dev__c+rec.Y6_Dev__c+rec.Y7_Dev__c+rec.Y8_Dev__c+rec.Y9_Dev__c+rec.Y10_Dev__c)/12;
                        }
                        if(UtilConstants.ACNNEARSHORE.equalsIgnoreCase(rec.Location_typeName__c)){
                            newOff.Nearshore_Baseline_FTEs = (rec.Y1_Dev__c+rec.Y2_Dev__c+rec.Y3_Dev__c+rec.Y4_Dev__c+rec.Y5_Dev__c+rec.Y6_Dev__c+rec.Y7_Dev__c+rec.Y8_Dev__c+rec.Y9_Dev__c+rec.Y10_Dev__c)/12;
                        }
                        if(UtilConstants.ACNOFFSHORE.equalsIgnoreCase(rec.Location_typeName__c)){
                            newOff.Offshore_Baseline_FTEs = (rec.Y1_Dev__c+rec.Y2_Dev__c+rec.Y3_Dev__c+rec.Y4_Dev__c+rec.Y5_Dev__c+rec.Y6_Dev__c+rec.Y7_Dev__c+rec.Y8_Dev__c+rec.Y9_Dev__c+rec.Y10_Dev__c)/12;
                        }
                    }
                    
                    
                    newOff.Sum_of_Total_Cost = rec.Mob_Totals__c  + rec.Run_Yr1__c + rec.Run_Yr2__c + rec.Run_Yr3__c + rec.Run_Yr4__c + rec.Run_Yr5__c + rec.Run_Yr6__c + rec.Run_Yr7__c + rec.Run_Yr8__c + rec.Run_Yr9__c + rec.Run_Yr10__c;//Vaishnavi's code change
                    newOff.Opportunity_Offering = rec.Sub_Service_Group__r.Offering_Master__r.name ;
                    newOff.Sum_of_Average_FTEs = (rec.Y1_Dev__c+rec.Y2_Dev__c+rec.Y3_Dev__c+rec.Y4_Dev__c+rec.Y5_Dev__c+rec.Y6_Dev__c+rec.Y7_Dev__c+rec.Y8_Dev__c+rec.Y9_Dev__c+rec.Y10_Dev__c)/12;
                    newOff.Sum_of_Baseline_FTEs = rec.Baseline_FTEs__c ;
                    newOff.Sum_of_Final_Month_FTE = rec.Final_Month_FTE__c ;
                    
                    newOff.Tech_Tool = UtilConstants.EMPTY_STRING;
                    mapOfWrapper.put(key,newOff);
                }
            }
            /**** Reading from FTE  ****/
            decimal sumOfTotals=0;
        for(Other_Cost_Details__c rec: inputOtherCost){
            key = rec.Costing_Type__c + rec.Sub_Service_Group__r.Offering_Master__r.name + rec.Service__r.Serv_Nm__c;
            if(mapOfWrapper.get(key)!=null){
                benchmarkOffering newOff = mapOfWrapper.get(key);
                
                newOff.Sum_of_Total_Cost += rec.Mob_Totals__c + rec.Run_Yr1__c + rec.Run_Yr2__c + rec.Run_Yr3__c + rec.Run_Yr4__c + rec.Run_Yr5__c + rec.Run_Yr6__c + rec.Run_Yr7__c + rec.Run_Yr8__c + rec.Run_Yr9__c + rec.Run_Yr10__c;
                newOff.Sum_of_Average_FTEs += (rec.Y1__c+rec.Y2__c+rec.Y3__c+rec.Y4__c+rec.Y5__c+rec.Y6__c+rec.Y7__c+rec.Y8__c+rec.Y9__c+rec.Y10__c)/12;
            }else{
                benchmarkOffering newOff = new benchmarkOffering();
                newOff.Opportunity_Offering = rec.Sub_Service_Group__r.Offering_Master__r.name ;
                newOff.Costing_Type = rec.Costing_Type__c;
                newOff.name = rec.Service__r.Services__r.name;
                //newOff.Sum_of_Baseline_FTEs += rec.Baseline_FTEs__c ;   // FTE Data on available in Other Cost Object
                newOff.Sum_of_Total_Cost += rec.Mob_Totals__c + rec.Run_Yr1__c + rec.Run_Yr2__c + rec.Run_Yr3__c + rec.Run_Yr4__c + rec.Run_Yr5__c + rec.Run_Yr6__c + rec.Run_Yr7__c + rec.Run_Yr8__c + rec.Run_Yr9__c + rec.Run_Yr10__c;
                newOff.Sum_of_Average_FTEs = (rec.Y1__c+rec.Y2__c+rec.Y3__c+rec.Y4__c+rec.Y5__c+rec.Y6__c+rec.Y7__c+rec.Y8__c+rec.Y9__c+rec.Y10__c)/12;
                mapOfWrapper.put(key,newOff);
            }
        }
            /**** populateOfferingServiceFromWrapper  ****/
            listOfBenchOfferingService = new List<BenchMark_Offering_Service__c>();
            BenchMark_Offering_Service__c benchOffSer;
            for(String keyItrObj: mapOfWrapper.keySet()){
                benchOffSer = new BenchMark_Offering_Service__c ();
                benchOffSer.name = mapOfWrapper.get(keyItrObj).name;
                benchOffSer.Average_of_FTE_Type__c = (mapOfWrapper.get(keyItrObj).Average_of_FTE_Type).setscale(4);//Need to check Later
                benchOffSer.Average_of_Location_Definition__c = mapOfWrapper.get(keyItrObj).Average_of_Location_Definition.setscale(4);
                benchOffSer.Average_of_Pyramid_Richness_Year_1__c = mapOfWrapper.get(keyItrObj).Average_of_Pyramid_Richness_Year_1.setscale(4);
                benchOffSer.BenchMark_Offering__c = mapOfWrapper.get(keyItrObj).BenchMark_Offering;
                benchOffSer.Costing_Type__c = mapOfWrapper.get(keyItrObj).Costing_Type;
                benchOffSer.Count_of_Language__c = mapOfWrapper.get(keyItrObj).Languages.size();
                benchOffSer.DCN_Location__c = mapOfWrapper.get(keyItrObj).DCN_Location;
                benchOffSer.Nearshore_Baseline_FTEs__c = mapOfWrapper.get(keyItrObj).Nearshore_Baseline_FTEs.setscale(4);
                benchOffSer.No_of_Contractors__c = mapOfWrapper.get(keyItrObj).No_of_Contractors.setscale(4);
                benchOffSer.No_of_Employees__c = mapOfWrapper.get(keyItrObj).No_of_Employees.setscale(4);
                benchOffSer.of_Headcount_Transferred_from_client__c = mapOfWrapper.get(keyItrObj).of_Headcount_Transferred_from_client.setscale(4);
                benchOffSer.Onshore_Baseline_FTEs__c = mapOfWrapper.get(keyItrObj).Onshore_Baseline_FTEs.setscale(4);
                benchOffSer.Offshore_Baseline_FTEs__c = mapOfWrapper.get(keyItrObj).Offshore_Baseline_FTEs.setscale(4);
                benchOffSer.Opportunity_Offering__c = mapOfWrapper.get(keyItrObj).Opportunity_Offering;
                benchOffSer.Sum_of_Average_FTEs__c = mapOfWrapper.get(keyItrObj).Sum_of_Average_FTEs.setscale(4);
                benchOffSer.Sum_of_Baseline_FTEs__c = mapOfWrapper.get(keyItrObj).Sum_of_Baseline_FTEs.setscale(4);
                benchOffSer.Sum_of_Final_Month_FTE__c = mapOfWrapper.get(keyItrObj).Sum_of_Final_Month_FTE.setscale(4);
                benchOffSer.Sum_of_Total_Cost__c = mapOfWrapper.get(keyItrObj).Sum_of_Total_Cost.setscale(4);
                benchOffSer.Tech_Tool__c = mapOfWrapper.get(keyItrObj).Tech_Tool;
                
                listOfBenchOfferingService.add(benchOffSer);
            }
            /**** populateOfferingServiceFromWrapper  ****/
            Set<String> OfferingMaster = new Set<String>();
            String OfferingNameList = UtilConstants.EMPTY_STRING;
            /**** populate Offering Excluding Service list objects  ****/
            List<Benchmark_Offerings__c> benchmarkOffExServiceList=new List<Benchmark_Offerings__c>();  
            for(BenchMark_Offering_Service__c OppOffBenchMark:listOfBenchOfferingService){
                boolean present=false; 
                for(Benchmark_Offerings__c benchmarkOff:benchmarkOffExServiceList){
                    if(OppOffBenchMark!=null && OppOffBenchMark.Opportunity_Offering__c!=null && OppOffBenchMark.Opportunity_Offering__c.equalsIgnoreCase(benchmarkOff.Name)){
                        present=true;
                        
                        if(benchmarkOff.SDO_Services__c==null || benchmarkOff.SDO_Services__c.equals(UtilConstants.EMPTY_STRING))
                            benchmarkOff.SDO_Services__c=OppOffBenchMark.Name;
                        else
                            benchmarkOff.SDO_Services__c+=UtilConstants.SEMICOLON_STRING+OppOffBenchMark.Name;  
                              
                        benchmarkOff.SDO_Services_Picklist__c=benchmarkOff.SDO_Services__c;
                        if(OppOffBenchMark.Costing_Type__c==null || UtilConstants.BSS.equalsIgnoreCase(OppOffBenchMark.Costing_Type__c)){
                            if(UtilConstants.EMPTY_STRING.equals(benchmarkOff.BSS_Services__c))
                                benchmarkOff.BSS_Services__c=OppOffBenchMark.Name;
                            else
                                benchmarkOff.BSS_Services__c+=UtilConstants.SEMICOLON_STRING+OppOffBenchMark.Name;    
                        }
                        else if(UtilConstants.TECH.equalsIgnoreCase(OppOffBenchMark.Costing_Type__c)){
                           if(benchmarkOff.Technology_Tools__c!=null){
                            if(UtilConstants.EMPTY_STRING.equals(benchmarkOff.Technology_Tools__c))
                                benchmarkOff.Technology_Tools__c=OppOffBenchMark.Tech_Tool__c;
                            else
                                benchmarkOff.Technology_Tools__c+=UtilConstants.SEMICOLON_STRING +OppOffBenchMark.Tech_Tool__c;    
                           }
                        }else{}
                        
                    }   
                }
                if(!present){
                    Benchmark_Offerings__c objToBeinsert=new Benchmark_Offerings__c();
                    objToBeinsert.BenchMark__c=benchmarkrecs.id;
                    objToBeinsert.Name=OppOffBenchMark.Opportunity_Offering__c;  
                    OfferingMaster.add(OppOffBenchMark.Opportunity_Offering__c);
                    objToBeinsert.BSS_Services__c= UtilConstants.EMPTY_STRING;
                    objToBeinsert.SDO_Services__c= UtilConstants.EMPTY_STRING;
                    objToBeinsert.Technology_Tools__c= UtilConstants.EMPTY_STRING;
                    
                    objToBeinsert.SDO_Services__c=OppOffBenchMark.Name;
                    
                    objToBeinsert.SDO_Services_Picklist__c=objToBeinsert.SDO_Services__c;
                    
                    if(UtilConstants.BSS.equalsIgnoreCase(OppOffBenchMark.Costing_Type__c)){
                        objToBeinsert.BSS_Services__c=OppOffBenchMark.Name;
                    }
                    else if(UtilConstants.TECH.equalsIgnoreCase(OppOffBenchMark.Costing_Type__c)){
                        objToBeinsert.Technology_Tools__c=OppOffBenchMark.Tech_Tool__c;     
                    }else{
                    }
                    benchmarkOffExServiceList.add(objToBeinsert);
                }
    
            }
            /**** populate Offering Excluding Service list objects  ****/
            for(String s : OfferingMaster){                 
                 OfferingNameList=OfferingNameList+UtilConstants.SEMICOLON_STRING+s+UtilConstants.SEMICOLON_STRING;       
            }       
            benchmarkrecs.Offerings__c=populateofferingList(OfferingNameList);
            try{
                System.debug('List o fservice Offerings ' + benchmarkOffExServiceList);
                database.Insert(benchmarkOffExServiceList);
                database.update(benchmarkrecs);
            }catch(DMLException de){
                throw(de);
            }
            
            /**** populate Offering Id Offering Service Objects  ****/
            for(Benchmark_Offerings__c benchmarkOff:benchmarkOffExServiceList){
                for(BenchMark_Offering_Service__c  OppOffBenchMark:listOfBenchOfferingService){
                    if(OppOffBenchMark!=null && OppOffBenchMark.Opportunity_Offering__c!=null && OppOffBenchMark.Opportunity_Offering__c.equalsIgnoreCase(benchmarkOff.Name)){
                        OppOffBenchMark.Benchmark_Offering__c=benchmarkOff.Id;
                    }
                }
            }
            /**** populate Offering Id Offering Service Objects  ****/
            try{
                database.Insert(listOfBenchOfferingService);
            }catch(DMLException de){
                throw(de);
            }
            
            //List<BenchMark_Offering_Service__c> lstbenchOff = [select id, Name, Opportunity_Offering__c from BenchMark_Offering_Service__c where BenchMark_Offering__r.BenchMark__c =:benchmarkrecs.id Limit 100];
            servSubServMap= new Map<String,Id>();
            for(BenchMark_Offering_Service__c off: [select id, Name, Opportunity_Offering__c from BenchMark_Offering_Service__c where BenchMark_Offering__r.BenchMark__c =:benchmarkrecs.id Limit 100] ){
                servSubServMap.put(off.Opportunity_Offering__c+UtilConstants.PLUS_OPERATOR+off.Name,off.Id);
            }
        }
        /******************************
        Method Name: createSummary
        Description: This private method is invoked to insert benchmark Summary objects
        Paramenters: NA
        Return Value: NA
        *******************************/    
        global Static void createSummary(String serviceGroup){
            Map<String,BenchMark_Summary__c> mapBenchSummary= new Map<String,BenchMark_Summary__c>();/////////////////
            String key =UtilConstants.EMPTY_STRING;
            double GrandTotalCost=0;
            BenchMark_Summary__c benchSummary=null;
                    
            for(FTE_Details__c  rec: inputFTEDetail){
                if(serviceGroup <> null && UtilConstants.IO.equalsIgnoreCase(serviceGroup) ){
                    key =  rec.Sub_Service_Group__r.Offering_Master__r.name + rec.Service__r.Serv_Nm__c;
                }
                else{
                    key = rec.Costing_Type__c + rec.Sub_Service_Group__r.Offering_Master__r.name + rec.Service__r.Serv_Nm__c;
                }
                        
                if(mapBenchSummary.get(key)!=null){
                    benchSummary = mapBenchSummary.get(key);
                        
                    
                            
                    if(benchSummary.Sum_of_Transition_cost__c!=null && rec.Mob_Totals__c!=null)
                        benchSummary.Sum_of_Transition_cost__c += rec.Mob_Totals__c.setscale(4);
                    if(benchSummary.Sum_of_Transformation_Cost__c!=null && rec.Transformation_Totals__c!=null)
                        benchSummary.Sum_of_Transformation_Cost__c+= rec.Transformation_Totals__c.setscale(4);
                        
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
                        
                    benchSummary.Costing_Type__c = UtilConstants.EMPTY_STRING;
                    benchSummary.Offering__c = UtilConstants.EMPTY_STRING;
                    benchSummary.Service__c=UtilConstants.EMPTY_STRING;
                    benchSummary.Service_Group__c = UtilConstants.BPO;    
                    benchSummary.Sum_of_Transition_cost__c=0;
                    benchSummary.Sum_of_Transformation_Cost__c=0;
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
                        
                        
                    if(serviceGroup <> null && UtilConstants.IO.equalsIgnoreCase(serviceGroup))  {
                        benchSummary.Service_Group__c = UtilConstants.IO;
                        benchSummary.costing_Type__C = UtilConstants.SDO;
                        benchSummary.Sum_of_Transition_cost__c = 0;
        
                    }
                    else{
                        benchSummary.Service_Group__c = UtilConstants.BPO;
                        if(rec.Costing_Type__c!=null)
                            benchSummary.Costing_Type__c = rec.Costing_Type__c;
                            
                           
                    }
                    
                    if(rec.Sub_Service_Group__r!=null && rec.Sub_Service_Group__r.Name!=null)
                        benchSummary.Offering__c = rec.Sub_Service_Group__r.Offering_Master__r.name;
                    if(rec.Service_Name__c!=null)    
                        benchSummary.Service__c=rec.Service__r.Serv_Nm__c;
                        
                   
                    if(rec.Transformation_Totals__c!=null)
                        benchSummary.Sum_of_Transformation_Cost__c= rec.Transformation_Totals__c.setscale(4);
                    if(rec.Mob_Totals__c!=null)
                        benchSummary.Sum_of_Transition_cost__c=rec.Mob_Totals__c.setscale(4);        
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
            for(Other_Cost_Details__c  rec: inputOtherCost){
                if(serviceGroup <> null && UtilConstants.IO.equalsIgnoreCase(serviceGroup) ){
                    key =  rec.Sub_Service_Group__r.Offering_Master__r.name + rec.Service__r.Serv_Nm__c;
                }
                else{
                    key = rec.Costing_Type__c + rec.Sub_Service_Group__r.Offering_Master__r.name + rec.Service__r.Serv_Nm__c;
                }
                
                        
                if(mapBenchSummary.get(key)!=null){
                    benchSummary = mapBenchSummary.get(key);
                            
                    /*    
                    if(serviceGroup <> null && UtilConstants.IO.equalsIgnoreCase(serviceGroup) ){
                         if(benchSummary.Sum_of_Transition_cost__c!=null && rec.Transformation_Totals__c!=null)
                                benchSummary.Sum_of_Transition_cost__c += rec.Transformation_Totals__c.setscale(4);
                    }
                    else{    
                        if(benchSummary.Sum_of_Transition_cost__c!=null && rec.Mob_Totals__c!=null) 
                            benchSummary.Sum_of_Transition_cost__c += rec.Mob_Totals__c.setscale(4);
                    }    
                    */
                    
                    if(benchSummary.Sum_of_Transition_cost__c!=null && rec.Mob_Totals__c!=null)
                        benchSummary.Sum_of_Transition_cost__c += rec.Mob_Totals__c.setscale(4);
                    if(benchSummary.Sum_of_Transformation_Cost__c!=null && rec.Transformation_Totals__c!=null)
                        benchSummary.Sum_of_Transformation_Cost__c+= rec.Transformation_Totals__c.setscale(4);
                            
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
                    benchSummary.Service_Group__c = UtilConstants.BPO;    
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
                        
                    
                    
                    if(serviceGroup <> null && UtilConstants.IO.equalsIgnoreCase(serviceGroup))  {
                        benchSummary.Service_Group__c = UtilConstants.IO;
                        benchSummary.costing_Type__C = UtilConstants.SDO;
                        
                    }
                    else{
                        benchSummary.Service_Group__c = UtilConstants.BPO;
                        if(rec.Costing_Type__c!=null)
                            benchSummary.Costing_Type__c = rec.Costing_Type__c;
                    }
                    
                        
                    if(rec.Sub_Service_Group__r!=null && rec.Sub_Service_Group__r.Name!=null)
                        benchSummary.Offering__c = rec.Sub_Service_Group__r.Offering_Master__r.name;
                    if(rec.Service_Name__c!=null)    
                        benchSummary.Service__c=rec.Service__r.Serv_Nm__c;    
                    
                    
                     if(rec.Transformation_Totals__c!=null)
                        benchSummary.Sum_of_Transformation_Cost__c= rec.Transformation_Totals__c.setscale(4);
                    if(rec.Mob_Totals__c!=null)
                        benchSummary.Sum_of_Transition_cost__c=rec.Mob_Totals__c.setscale(4); 
                            
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
            List<BenchMark_Summary__c> benchSummaryList=new List<BenchMark_Summary__c>(); 
            
            for(String mapKey:mapBenchSummary.keySet()){
                benchSummary=mapBenchSummary.get(mapKey);
                        
                GrandTotalCost += (benchSummary.Sum_of_Transition_cost__c+ benchSummary.Sum_of_Transformation_Cost__c + benchSummary.Sum_of_RUN_Year1__c+benchSummary.Sum_of_RUN_Year2__c+benchSummary.Sum_of_RUN_Year3__c+
                                                    benchSummary.Sum_of_RUN_Year4__c+benchSummary.Sum_of_RUN_Year5__c+benchSummary.Sum_of_RUN_Year6__c+benchSummary.Sum_of_RUN_Year7__c+
                                                    benchSummary.Sum_of_RUN_Year8__c+benchSummary.Sum_of_RUN_Year9__c+benchSummary.Sum_of_RUN_Year10__c).setscale(4);
            }
            //GrandTotalCost=GrandTotalCost.round();
            
            for(String mapKey:mapBenchSummary.keySet()){
                benchSummary=mapBenchSummary.get(mapKey);
                        
                benchSummary.BenchMark__c=benchmarkrecs.id;
                        
                benchSummary.Total_FTE_all_years__c = (benchSummary.Sum_of_FTE_YR1__c+benchSummary.Sum_of_FTE_YR2__c+benchSummary.Sum_of_FTE_YR3__c+benchSummary.Sum_of_FTE_YR4__c+benchSummary.Sum_of_FTE_YR5__c+benchSummary.Sum_of_FTE_YR6__c+benchSummary.Sum_of_FTE_YR7__c+benchSummary.Sum_of_FTE_YR8__c+benchSummary.Sum_of_FTE_YR9__c+benchSummary.Sum_of_FTE_YR10__c).setscale(4);
                
                benchSummary.Sum_of_Total_Cost__c = (benchSummary.Sum_of_Transition_cost__c+ benchSummary.Sum_of_Transformation_Cost__c + benchSummary.Sum_of_RUN_Year1__c+benchSummary.Sum_of_RUN_Year2__c+benchSummary.Sum_of_RUN_Year3__c+
                                                    benchSummary.Sum_of_RUN_Year4__c+benchSummary.Sum_of_RUN_Year5__c+benchSummary.Sum_of_RUN_Year6__c+benchSummary.Sum_of_RUN_Year7__c+
                                                    benchSummary.Sum_of_RUN_Year8__c+benchSummary.Sum_of_RUN_Year9__c+benchSummary.Sum_of_RUN_Year10__c).setscale(4);
                
                benchSummary.Total_FTE_all_years__c=benchSummary.Total_FTE_all_years__c.setscale(4);
                benchSummary.Sum_of_Total_Cost__c=benchSummary.Sum_of_Total_Cost__c.setscale(4);
                
                benchSummary.percent_of_costs__c=GrandTotalCost==0 ? 0 : (benchSummary.Sum_of_Total_Cost__c/GrandTotalCost)*100;
                                        
                benchSummary.Average_cost_FTE_Full_deal__c=benchSummary.Total_FTE_all_years__c==0 || benchSummary.Sum_of_Total_Cost__c==0 ? 0 : (benchSummary.Sum_of_Total_Cost__c/benchSummary.Total_FTE_all_years__c).setscale(4);
                benchSummary.Average_cost_FTE_YR_1_Mob__c=benchSummary.Sum_of_FTE_YR1__c==0 ? 0 : ((benchSummary.Sum_of_Transition_cost__c+benchSummary.Sum_of_RUN_Year1__c)/benchSummary.Sum_of_FTE_YR1__c).setscale(4);
                benchSummary.Average_cost_FTE_YR_2__c=benchSummary.Sum_of_FTE_YR2__c==0 ? 0 : (benchSummary.Sum_of_RUN_Year2__c/benchSummary.Sum_of_FTE_YR2__c).setscale(4);
                benchSummary.Average_cost_FTE_YR_3__c=benchSummary.Sum_of_FTE_YR3__c==0 ? 0 : (benchSummary.Sum_of_RUN_Year3__c/benchSummary.Sum_of_FTE_YR3__c).setscale(4);
                benchSummary.Average_cost_FTE_YR_4__c=benchSummary.Sum_of_FTE_YR4__c==0 ? 0 : (benchSummary.Sum_of_RUN_Year4__c/benchSummary.Sum_of_FTE_YR4__c).setscale(4);
                benchSummary.Average_cost_FTE_YR_5__c=benchSummary.Sum_of_FTE_YR5__c==0 ? 0 : (benchSummary.Sum_of_RUN_Year5__c/benchSummary.Sum_of_FTE_YR5__c).setscale(4);
                benchSummary.Average_cost_FTE_YR_6__c=benchSummary.Sum_of_FTE_YR6__c==0 ? 0 : (benchSummary.Sum_of_RUN_Year6__c/benchSummary.Sum_of_FTE_YR6__c).setscale(4);
                benchSummary.Average_cost_FTE_YR_7__c=benchSummary.Sum_of_FTE_YR7__c==0 ? 0 : (benchSummary.Sum_of_RUN_Year7__c/benchSummary.Sum_of_FTE_YR7__c).setscale(4);
                benchSummary.Average_cost_FTE_YR_8__c=benchSummary.Sum_of_FTE_YR8__c==0 ? 0 : (benchSummary.Sum_of_RUN_Year8__c/benchSummary.Sum_of_FTE_YR8__c).setscale(4);
                benchSummary.Average_cost_FTE_YR_9__c=benchSummary.Sum_of_FTE_YR9__c==0 ? 0 : (benchSummary.Sum_of_RUN_Year9__c/benchSummary.Sum_of_FTE_YR9__c).setscale(4);
                benchSummary.Average_cost_FTE_YR_10__c=benchSummary.Sum_of_FTE_YR10__c==0 ? 0 : (benchSummary.Sum_of_RUN_Year10__c/benchSummary.Sum_of_FTE_YR10__c).setscale(4);        
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
        
        /*
        @Author : Aswajit Swain
        @Created Date : 24/6/2015
        @name : createOADM
        @Description : Creating BenchMark OADM FTE from 2 staging objects viz. FTE Details and Other Cost details.
        @Version : 1.0
        */
        global Static void createOADM(){
            Map<String, BenchMark_OADM_FTE__c> oadmMap=new Map<String, BenchMark_OADM_FTE__c>();
            BenchMark_OADM_FTE__c oadm;
            for(FTE_Details__c fte : inputFTEDetail){
            if(UtilConstants.OADM.equalsIgnoreCase(fte.Service__r.Serv_Nm__c)){
                String key = (String)fte.Service__r.Serv_Nm__c + (String)fte.Country__c + (String)fte.Career_Level__c;
                if(oadmMap.get(key)!=null){
                    oadm = oadmMap.get(key);
                    if(oadm.OADM_FTEs__c!=null && fte.Baseline_FTEs__c!=null)
                        oadm.OADM_FTEs__c  += fte.Baseline_FTEs__c;
                    }else{
                        oadm = new BenchMark_OADM_FTE__c();
                            
                        oadm.OADM_Costing_Type__c=UtilConstants.EMPTY_STRING;
                        oadm.OADM_Service__c=UtilConstants.EMPTY_STRING;
                        oadm.OADM_FTE_Location__c=UtilConstants.EMPTY_STRING;
                        oadm.OADM_FTE_Level__c=UtilConstants.EMPTY_STRING;
                        oadm.OADM_FTEs__c=0;
                            
                        if(fte.Costing_Type__c!=null)
                            oadm.OADM_Costing_Type__c=fte.Costing_Type__c ;
                        if(fte.Service__r!=null && fte.Service__r.Serv_Nm__c!=null)
                            oadm.OADM_Service__c=fte.Service__r.Serv_Nm__c;
                        if(fte.Country__r!=null && fte.Country__r.Name!=null)
                            oadm.OADM_FTE_Location__c=fte.Country__r.Name;
                        if(fte.Career_Level__r!=null && fte.Career_Level__r.Name!=null)
                            oadm.OADM_FTE_Level__c=fte.Career_Level__r.Name;
                        if(fte.Baseline_FTEs__c!=null)
                            oadm.OADM_FTEs__c=fte.Baseline_FTEs__c;
                        oadmMap.put(key, oadm);
                    }
                }
            }
            for(Other_Cost_Details__c cost : inputOtherCost){
                if(UtilConstants.OADM.equalsIgnoreCase(cost.Service__r.Serv_Nm__c)){
                    String key = (String)cost.Service__r.Serv_Nm__c + (String)cost.Country__c + (String)cost.Career_Level__c;
                    if(oadmMap.get(key)!=null){
                        oadm = new BenchMark_OADM_FTE__c();
                            
                        oadm.OADM_Costing_Type__c=UtilConstants.EMPTY_STRING;
                        oadm.OADM_Service__c=UtilConstants.EMPTY_STRING;
                        oadm.OADM_FTE_Location__c=UtilConstants.EMPTY_STRING;
                        oadm.OADM_FTE_Level__c=UtilConstants.EMPTY_STRING;
                        oadm.OADM_FTEs__c=0;
                            
                        if(cost.Costing_Type__c!=null)
                            oadm.OADM_Costing_Type__c=cost.Costing_Type__c ;
                        if(cost.Service__r!=null && cost.Service__r.Serv_Nm__c!=null)
                            oadm.OADM_Service__c=cost.Service__r.Serv_Nm__c;
                        if(cost.Country__r!=null && cost.Country__r.Name!=null)
                            oadm.OADM_FTE_Location__c=cost.Country__r.Name;
                        if(cost.Career_Level__r!=null && cost.Career_Level__r.Name!=null)
                            oadm.OADM_FTE_Level__c=cost.Career_Level__r.Name;
                            
                        oadmMap.put(key, oadm);
                    }
                }
            }
            List<BenchMark_OADM_FTE__c> oadmList = new List<BenchMark_OADM_FTE__c>();
            for(String key : oadmMap.keySet()){
                oadm=oadmMap.get(key);
                oadm.BenchMark__c=benchmarkrecs.id;
                oadmList.add(oadm);
            }
            if(oadmList.size() >0 ){
                try{
                    Database.insert(oadmList,true);
                }catch(DMLException de){
                    throw(de);
                }
            }
        }
        
        /******************************
        Method Name: insertServiceLoc
        Description: This private method is invoked to insert benchmark Service Location objects
        Paramenters: NA
        Return Value: NA
        *******************************/
        global Static Set<Id> insertServiceLoc(){
            set<id> newServLocId = new set<id>();
            Map<String, ServiceLocWrapper> serLocWrapMap=new Map<String, ServiceLocWrapper>();
            Map<String, ServiceLocOffWrapper> serLocOffWrapMap=new Map<String, ServiceLocOffWrapper>();
            
            ServiceLocWrapper serLocWrap;
        
            for(FTE_Details__c fte : inputFTEDetail) {
                String keyFte = (String)fte.Sub_Service_Group__r.Offering_Master__r.name+(String)fte.Service__r.Serv_Nm__c+(String)fte.Country__r.Name+(String)fte.Opportunity_Delivery_Location__r.Delivery_Location__r.Name+(String)fte.Column4__c;
                if(serLocWrapMap.get(keyFte)!=null){
                    serLocWrap=serLocWrapMap.get(keyFte);
                    serLocWrap.sumTotFTEYear+=fte.FTEYr1__c+fte.FTEYr2__c+fte.FTEYr3__c+fte.FTEYr4__c+fte.FTEYr5__c+fte.FTEYr6__c+fte.FTEYr7__c+fte.FTEYr8__c+fte.FTEYr9__c+fte.FTEYr10__c;
                    serLocWrap.totalPayrollCost += fte.Mob_Totals__c + fte.Run_Yr1__c+ fte.Run_Yr2__c+ fte.Run_Yr3__c+ fte.Run_Yr4__c+ fte.Run_Yr5__c+ fte.Run_Yr6__c+ fte.Run_Yr7__c+ fte.Run_Yr8__c+ fte.Run_Yr9__c+ fte.Run_Yr10__c;
                    serLocWrap.totalMobCost += fte.Mob_Totals__c;
                    if(UtilConstants.SDO.equalsIgnoreCase(fte.Costing_Type__c)) {
                        serLocWrap.totalPayrollCostFromFTE += fte.Mob_Totals__c + fte.Run_Yr1__c+ fte.Run_Yr2__c+ fte.Run_Yr3__c+ fte.Run_Yr4__c+ fte.Run_Yr5__c+ fte.Run_Yr6__c+ fte.Run_Yr7__c+ fte.Run_Yr8__c+ fte.Run_Yr9__c+ fte.Run_Yr10__c;
                        serLocWrap.totalMobCostFTE += fte.Mob_Totals__c;
                    }
                }else{
                    serLocWrap=new ServiceLocWrapper();
                    serLocWrap.subServOff=fte.Sub_Service_Group__r.Offering_Master__r.name;
                    serLocWrap.service=fte.Service__r.Serv_Nm__c;
                    serLocWrap.country = fte.Country__r.Name;
                    serLocWrap.dcnLocation = fte.Opportunity_Delivery_Location__r.Delivery_Location__r.Name;
                    serLocWrap.langPrem = fte.Column4__c;
                    serLocWrap.costingType=fte.Costing_Type__c;
                    serLocWrap.custom_Location=fte.Delivery_Location_Dev__c;
                 
                    serLocWrap.sumTotFTEYear=fte.FTEYr1__c+fte.FTEYr2__c+fte.FTEYr3__c+fte.FTEYr4__c+fte.FTEYr5__c+fte.FTEYr6__c+fte.FTEYr7__c+fte.FTEYr8__c+fte.FTEYr9__c+fte.FTEYr10__c;
                    serLocWrap.totalPayrollCost = fte.Mob_Totals__c + fte.Run_Yr1__c+ fte.Run_Yr2__c+ fte.Run_Yr3__c+ fte.Run_Yr4__c+ fte.Run_Yr5__c+ fte.Run_Yr6__c+ fte.Run_Yr7__c+ fte.Run_Yr8__c+ fte.Run_Yr9__c+ fte.Run_Yr10__c;
                    serLocWrap.totalMobCost = fte.Mob_Totals__c;
                    if(UtilConstants.SDO.equalsIgnoreCase(fte.Costing_Type__c)) {
                        serLocWrap.totalPayrollCostFromFTE = fte.Mob_Totals__c + fte.Run_Yr1__c+ fte.Run_Yr2__c+ fte.Run_Yr3__c+ fte.Run_Yr4__c+ fte.Run_Yr5__c+ fte.Run_Yr6__c+ fte.Run_Yr7__c+ fte.Run_Yr8__c+ fte.Run_Yr9__c+ fte.Run_Yr10__c;
                        serLocWrap.totalMobCostFTE = fte.Mob_Totals__c;
                        serLocWrap.consider=true;
                    }
                    serLocWrapMap.put(keyFte,serLocWrap);
                }
            }
            for(Other_Cost_Details__c cost : inputOtherCost) {
                String keyCustomCost = (String)cost.Sub_Service_Group__r.Offering_Master__r.name+(String)cost.Service__r.Serv_Nm__c+(String)cost.Country__r.Name;
                
                if(serLocWrapMap.get(keyCustomCost)!=null){
                    serLocWrap=serLocWrapMap.get(keyCustomCost);
                    
                    serLocWrap.totalPayrollCost += cost.Mob_Totals__c + cost.Run_Yr1__c+ cost.Run_Yr2__c+ cost.Run_Yr3__c+ cost.Run_Yr4__c+ cost.Run_Yr5__c+ cost.Run_Yr6__c+ cost.Run_Yr7__c+ cost.Run_Yr8__c+ cost.Run_Yr9__c+ cost.Run_Yr10__c;
                    serLocWrap.totalMobCost += cost.Mob_Totals__c;
                }else{
                    serLocWrap=new ServiceLocWrapper();
                    serLocWrap.subServOff=cost.Sub_Service_Group__r.Offering_Master__r.name;
                    serLocWrap.service=cost.Service__r.Serv_Nm__c;
                    serLocWrap.country = cost.Country__r.Name;
                    serLocWrap.costingType=cost.Costing_Type__c;
                    
                    serLocWrap.totalPayrollCost = cost.Mob_Totals__c + cost.Run_Yr1__c+ cost.Run_Yr2__c+ cost.Run_Yr3__c+ cost.Run_Yr4__c+ cost.Run_Yr5__c+ cost.Run_Yr6__c+ cost.Run_Yr7__c+ cost.Run_Yr8__c+ cost.Run_Yr9__c+ cost.Run_Yr10__c;
                    serLocWrap.totalMobCost = cost.Mob_Totals__c;
                    
                    /*if(UtilConstants.SDO.equalsIgnoreCase(cost.Costing_Type__c)) {
                        serLocWrap.totalPayrollCostFromFTE = cost.Mob_Totals__c + cost.Run_Yr1__c+ cost.Run_Yr2__c+ cost.Run_Yr3__c+ cost.Run_Yr4__c+ cost.Run_Yr5__c+ cost.Run_Yr6__c+ cost.Run_Yr7__c+ cost.Run_Yr8__c+ cost.Run_Yr9__c+ cost.Run_Yr10__c;
                        serLocWrap.totalMobCostFTE = cost.Mob_Totals__c;
                        serLocWrap.consider=true;
                    }*/
                    
                    
                    serLocWrapMap.put(keyCustomCost,serLocWrap);
                }
            }
            
            for(String key:serLocWrapMap.keySet()){
                serLocWrap=serLocWrapMap.get(key);
                String keyOff = serLocWrap.subServOff;
                if(serLocOffWrapMap.get(keyOff)!=null){
                    ServiceLocOffWrapper servLocOffWrap=serLocOffWrapMap.get(keyOff);
                    
                    if(serLocWrap.consider && UtilConstants.SDO.equalsIgnoreCase(serLocWrap.costingType)){
                        servLocOffWrap.sumTotFTEYear+=serLocWrap.sumTotFTEYear; 
                    }
                    
                    
                    if(UtilConstants.TECH_TOOLS.equalsIgnoreCase(serLocWrap.service)) {
                        servLocOffWrap.toolsCostPerFTE+=serLocWrap.totalPayrollCost;
                        system.debug('totalPayrollCost::::'+serLocWrap.totalPayrollCost);
                    }
                    if(UtilConstants.VOICE_DATA.equalsIgnoreCase(serLocWrap.service)) {
                        servLocOffWrap.dveCostPerFTE+=serLocWrap.totalPayrollCost;
                    }
                    if(UtilConstants.SUP_CENT.equalsIgnoreCase(serLocWrap.service)) {
                        servLocOffWrap.supportCentCostPerFTE+=serLocWrap.totalPayrollCost;
                    }
                    if(UtilConstants.SER_MGMT.equalsIgnoreCase(serLocWrap.service)) {
                        servLocOffWrap.smCostPerFTE+=serLocWrap.totalPayrollCost;
                    }
                    if(UtilConstants.EDM.equalsIgnoreCase(serLocWrap.service)) {
                        servLocOffWrap.edmCostPerFTE+=serLocWrap.totalPayrollCost; 
                    }
                    if(UtilConstants.CMD_CENT.equalsIgnoreCase(serLocWrap.service)) {
                        servLocOffWrap.ccCostPerFTE+=serLocWrap.totalPayrollCost;
                    }
                    if(UtilConstants.MOB.equalsIgnoreCase(serLocWrap.service)) {
                        servLocOffWrap.mobCostPerFTE+=serLocWrap.totalPayrollCost;
                    }
                    if(UtilConstants.PMO.equalsIgnoreCase(serLocWrap.costingType)) {
                        servLocOffWrap.pmoCostPerFTE+=serLocWrap.totalPayrollCost;
                    }
                    
                }else{
                    ServiceLocOffWrapper servLocOffWrap=new ServiceLocOffWrapper();
                    
                    servLocOffWrap.subServOff=serLocWrap.subServOff;
                    
                    if(serLocWrap.consider && UtilConstants.SDO.equalsIgnoreCase(serLocWrap.costingType)){
                        servLocOffWrap.sumTotFTEYear=serLocWrap.sumTotFTEYear;  
                    }
                    
                    
                    if(UtilConstants.TECH_TOOLS.equalsIgnoreCase(serLocWrap.service)) {
                        servLocOffWrap.toolsCostPerFTE=serLocWrap.totalPayrollCost;
                        system.debug('totalPayrollCost::::'+serLocWrap.totalPayrollCost);
                    }
                    if(UtilConstants.VOICE_DATA.equalsIgnoreCase(serLocWrap.service)) {
                        servLocOffWrap.dveCostPerFTE=serLocWrap.totalPayrollCost;
                    }
                    if(UtilConstants.SUP_CENT.equalsIgnoreCase(serLocWrap.service)) {
                        servLocOffWrap.supportCentCostPerFTE=serLocWrap.totalPayrollCost;
                    }
                    if(UtilConstants.SER_MGMT.equalsIgnoreCase(serLocWrap.service)) {
                        servLocOffWrap.smCostPerFTE=serLocWrap.totalPayrollCost;
                    }
                    if(UtilConstants.EDM.equalsIgnoreCase(serLocWrap.service)) {
                        servLocOffWrap.edmCostPerFTE=serLocWrap.totalPayrollCost;  
                    }
                    if(UtilConstants.CMD_CENT.equalsIgnoreCase(serLocWrap.service)) {
                        servLocOffWrap.ccCostPerFTE=serLocWrap.totalPayrollCost;
                    }
                    if(UtilConstants.MOB.equalsIgnoreCase(serLocWrap.service)) {
                        servLocOffWrap.mobCostPerFTE=serLocWrap.totalPayrollCost;
                    }
                    if(UtilConstants.PMO.equalsIgnoreCase(serLocWrap.costingType)) {
                        servLocOffWrap.pmoCostPerFTE=serLocWrap.totalPayrollCost;
                    }
                    
                    serLocOffWrapMap.put(keyOff,servLocOffWrap);
                }
                
            }
            Decimal totFTEAllYear=0;
            for(String key:serLocOffWrapMap.keySet()){
                ServiceLocOffWrapper serLocOffWrapObj=serLocOffWrapMap.get(key);
                totFTEAllYear+=serLocOffWrapObj.sumTotFTEYear;
            }
            
            System.debug('serLocOffWrapMap:::'+serLocOffWrapMap);
            System.debug('serLocWrapMap:::'+serLocWrapMap);
            
            List<CPR_Master__c> allCPRMstr=[select Active__c,CPR__c,DCN_Location__c,FTE_Maximum__c,FTE_Minimum__c,  Offering_Name__c,Service_Name__c from CPR_Master__c limit 999]; 
            Map<String,BenchMark_Offerings__c> offrMap=new Map<String,BenchMark_Offerings__c>();
            for(BenchMark_Offerings__c off:[Select id,Name,Baseline_FTE_Non_SDO__c,Baseline_FTE_SDO__c,Total_Offering_FTEs__c from BenchMark_Offerings__c where BenchMark__c =: benchmarkrecs.id Limit 100]){
                offrMap.put(off.Name,off);
            }
            List<BenchMark_Service_Location__c>lstServLocations=new List<BenchMark_Service_Location__c>();
            ////////////////////////////////////////////////
            for(String key:serLocWrapMap.keySet()){
                ServiceLocWrapper itrObj=serLocWrapMap.get(key);
                if(itrObj.consider){
                    String[] inputvalues = new String[]{};
                    BenchMark_Service_Location__c bnchServLoc = new BenchMark_Service_Location__c();
                    String servSubServ=UtilConstants.EMPTY_STRING;    
                    servSubServ=itrObj.subServOff+UtilConstants.PLUS_OPERATOR+itrObj.service;///////////////
                    bnchServLoc.BenchMark_Offering_Service__c=servSubServMap.get(servSubServ);
                    BenchMark_Offerings__c off= offrMap.get(itrObj.subServOff);
                    if(off!=null){
                        for(CPR_Master__c cprMstr:allCPRMstr){
                            if(cprMstr.Active__c==true){
                                if(cprMstr.Offering_Name__c ==itrObj.subServOff){
                                    if(cprMstr.Service_Name__c == itrObj.service){
                                        if(cprMstr.DCN_Location__c ==itrObj.dcnLocation){
                                            if(cprMstr.FTE_Maximum__c >= off.Total_Offering_FTEs__c){
                                                if(off.Total_Offering_FTEs__c >=cprMstr.FTE_Minimum__c){
                                                    bnchServLoc.CPR__c=cprMstr.CPR__c;
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                } 
                            }
                        }
                    }
                    bnchServLoc.Name= itrObj.country;
                    bnchServLoc.DCN_Location__c= itrObj.dcnLocation;
                    bnchServLoc.Language_Premium__c= itrObj.langPrem;
                    bnchServLoc.Sum_of_Total_Cost__c=itrObj.totalPayrollCost.setScale(4);
                    bnchServLoc.Sum_of_Mob_cost__c=itrObj.totalMobCost.setScale(4);
                    bnchServLoc.Custom_Location__c = itrObj.custom_Location;                      
                
                
                    bnchServLoc.Sum_of_Total_SDO_RUN_Cost_FTE_Custom__c=itrObj.totalPayrollCostFromFTE.setScale(4);
                    bnchServLoc.Sum_of_Total_SDO_MOB_Cost_FTE_Custom__c=itrObj.totalMobCostFTE.setScale(4);
                    bnchServLoc.Sum_of_Total_FTE_Year__c= itrObj.sumTotFTEYear.setScale(4);
                    bnchServLoc.Total_SDO_Cost_less_Mob__c=(itrObj.totalPayrollCostFromFTE - itrObj.totalMobCostFTE).setScale(4);
                      
                    bnchServLoc.SDO_Cost_Per_FTE__c=bnchServLoc.Sum_of_Total_FTE_Year__c==0 ? 0 : (bnchServLoc.Total_SDO_Cost_less_Mob__c/bnchServLoc.Sum_of_Total_FTE_Year__c).setScale(4);
                    
                    
                    ServiceLocOffWrapper servLocOffWrap= serLocOffWrapMap.get(itrObj.subServOff);
                    
                    ServiceLocOffWrapper servLocOffWrapOffAll= serLocOffWrapMap.get('Cross Offering');//Changed All to Cross Offering String
                    
                    
                    Decimal toolsCostPerFTEALL=0;
                    Decimal toolsCostPerFTE=0;
                    
                    toolsCostPerFTEALL=serLocOffWrapMap.get(itrObj.subServOff)==null || servLocOffWrapOffAll==null || totFTEAllYear==0 ? 0: serLocOffWrapMap.get('Cross Offering').toolsCostPerFTE/totFTEAllYear;//Changed All to Cross Offering String
                    toolsCostPerFTE=serLocOffWrapMap.get(itrObj.subServOff)==null || serLocOffWrapMap.get(itrObj.subServOff).sumTotFTEYear==0 ? 0: serLocOffWrapMap.get(itrObj.subServOff).toolsCostPerFTE/ serLocOffWrapMap.get(itrObj.subServOff).sumTotFTEYear;
                    
                    bnchServLoc.Tools_Cost_Per_FTE__c= (toolsCostPerFTEALL+toolsCostPerFTE).setScale(4);
                    
                    
                    bnchServLoc.SM_Cost_Per_FTE__c= serLocOffWrapMap.get(itrObj.subServOff)==null || servLocOffWrapOffAll==null || serLocOffWrapMap.get(itrObj.subServOff).sumTotFTEYear==0 ? 0: (serLocOffWrapMap.get('Cross Offering').smCostPerFTE/ serLocOffWrapMap.get(itrObj.subServOff).sumTotFTEYear).setScale(4);//Changed All to Cross Offering String
                    bnchServLoc.CC_Cost_Per_FTE__c= serLocOffWrapMap.get(itrObj.subServOff)==null || servLocOffWrapOffAll==null || serLocOffWrapMap.get(itrObj.subServOff).sumTotFTEYear==0 ? 0: (serLocOffWrapMap.get('Cross Offering').ccCostPerFTE/ serLocOffWrapMap.get(itrObj.subServOff).sumTotFTEYear).setScale(4);//Changed All to Cross Offering String
                    bnchServLoc.PMO_Cost_Per_FTE__c= serLocOffWrapMap.get(itrObj.subServOff)==null || servLocOffWrapOffAll==null || serLocOffWrapMap.get(itrObj.subServOff).sumTotFTEYear==0 ? 0: (serLocOffWrapMap.get('Cross Offering').pmoCostPerFTE/ serLocOffWrapMap.get(itrObj.subServOff).sumTotFTEYear).setScale(4);//Changed All to Cross Offering String
                    
                    
                    bnchServLoc.DVE_Cost_Per_FTE__c= serLocOffWrapMap.get(itrObj.subServOff)==null || serLocOffWrapMap.get(itrObj.subServOff).sumTotFTEYear==0 ? 0: (serLocOffWrapMap.get(itrObj.subServOff).dveCostPerFTE/ serLocOffWrapMap.get(itrObj.subServOff).sumTotFTEYear).setScale(4);
                    bnchServLoc.Support_Center_Cost_Per_FTE__c= serLocOffWrapMap.get(itrObj.subServOff)==null || serLocOffWrapMap.get(itrObj.subServOff).sumTotFTEYear==0 ? 0: (serLocOffWrapMap.get(itrObj.subServOff).supportCentCostPerFTE/ serLocOffWrapMap.get(itrObj.subServOff).sumTotFTEYear).setScale(4);
                    
                    bnchServLoc.EDM_Cost_Per_FTE__c= serLocOffWrapMap.get(itrObj.subServOff)==null || serLocOffWrapMap.get(itrObj.subServOff).sumTotFTEYear==0 ? 0: (serLocOffWrapMap.get(itrObj.subServOff).edmCostPerFTE/ serLocOffWrapMap.get(itrObj.subServOff).sumTotFTEYear).setScale(4);
                    
                    bnchServLoc.Mob_Cost_Per_FTE__c= serLocOffWrapMap.get(itrObj.subServOff)==null || serLocOffWrapMap.get(itrObj.subServOff).sumTotFTEYear==0 ? 0: (serLocOffWrapMap.get(itrObj.subServOff).mobCostPerFTE/ serLocOffWrapMap.get(itrObj.subServOff).sumTotFTEYear).setScale(4);
                    
                    
                    
                    bnchServLoc.Total_Cost_per_FTE__c= (bnchServLoc.SDO_Cost_Per_FTE__c+bnchServLoc.Tools_Cost_Per_FTE__c+bnchServLoc.DVE_Cost_Per_FTE__c+bnchServLoc.Support_Center_Cost_Per_FTE__c+bnchServLoc.SM_Cost_Per_FTE__c+bnchServLoc.EDM_Cost_Per_FTE__c+bnchServLoc.CC_Cost_Per_FTE__c+bnchServLoc.Mob_Cost_Per_FTE__c+bnchServLoc.PMO_Cost_Per_FTE__c).setScale(4); 
                
                
                    bnchServLoc.Active__c= true;
                      
                    lstServLocations.add(bnchServLoc);
                }
            }
            
            if(lstServLocations.size() >0 ){
                try{
                    Database.insert(lstServLocations);
                    for(BenchMark_Service_Location__c itrObj:lstServLocations){
                        newServLocId.add(itrObj.id);    
                    }
                } catch(DMLException de){
                    throw(de);
                }
            }
            return newServLocId;
        }
        
        /******************************
        Method Name: populateofferingList
        Description: This private method is invoked to insert benchmark Service Location objects
        Paramenters: List of Offering Names
        Return Value: List of new offerings in scope
        *******************************/
        global static String populateofferingList(String orgInScopeOff) {
            String newInScopeOff= UtilConstants.EMPTY_STRING; 

            if (!(string.isBlank(orgInScopeOff))){
                 String[] arrStr=orgInScopeOff.split(UtilConstants.SEMICOLON_STRING);
                 for(String s:arrStr){
                     if(!(UtilConstants.EMPTY_STRING.equals(newInScopeOff))){

                        if(!(string.isBlank(s))){
                            newInScopeOff=newInScopeOff+UtilConstants.SEMICOLON_STRING+s; 
                        }
                     }else{

                         if(!(string.isBlank(s))){
                             newInScopeOff=s;
                         }
                     }    
                 }
                newInScopeOff=newInScopeOff;             
            }
            return newInScopeOff;         
        }
        /*****************
        @author : BPO SE
        @description : This method is used to sync the data from BPO SE System
        
        *******************/
        public static void deleteSyncData(Set<id> nFTEids,Set<id> nOCDids,map<string,string> costMap){
        boolean datadeleted;
        try{
        
           delete [select id from FTE_Details__c where id IN:nFTEids LIMIT 2000];
           delete [select id from Other_Cost_Details__c where id IN:nOCDids LIMIT 2000];
           datadeleted = true;
        }
        catch(exception e){
            datadeleted  = false;
        }
        finally {
            if(datadeleted){
                   costing_request__c cost = new costing_request__c(id=costMap.get('ID'));
                   cost.Calculation__c = false;
                   cost.sync_failed_at__c = '';
                   cost.Data_Cleaning_dev__c =false;
                   cost.in_progress__c ='0';
                   update cost;
            }
            else{
                costing_request__c cost = new costing_request__c(id=costMap.get('ID'));
                   cost.Calculation__c = false;
                   cost.sync_failed_at__c = 'Rollback';
                   cost.Data_Cleaning_dev__c =false;
                   cost.in_progress__c ='2';
                   update cost;
            }
        }
        } 
    }