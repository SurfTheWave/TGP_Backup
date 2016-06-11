/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 */
@isTest(seealldata = true)
private class SyncTest {

        public class serializeclass{
        public string method;
        public string jsonRequestObject;
    }
    
      public static Opportunity testOpportunity = new Opportunity();
      public static Scratchpad_Opportunity__c scratchpadOpp;
      public static String opportunityteamjson;
      public static String  autosyncjson;
      public static String completesync;
      public static String bdldatajson;
      public static String opportunitydetailsjson;
      public static String insertfteccdata;
      public static Boolean isQueried = true;
      public static boolean iscostrecrodqueried = false;
      public static costing_request__C costrec = new costing_request__C();
      
 /**
 * @method Name: setupOpportunity
 * @description :Query test opportunity
 */
      public static Opportunity setupOpportunity(){
        //system.debug('master queries after set'+oppIds);
        if(isQueried){
            testOpportunity= [select id FROM Opportunity where name='Opportunity for test class' limit 1];
            if(testOpportunity!=null){
                isQueried = false;
            }
        }
        return testOpportunity;
    }
    public static costing_request__C queryCostRecord(){
        if(!iscostrecrodqueried){
            costrec = [select id from costing_request__C where opportunity__c=:testOpportunity.id limit 1];
            iscostrecrodqueried = true;
        }
        system.debug('cost rec is returned '+costrec+ ' when boolean is '+iscostrecrodqueried);
        return costrec;
    }
 /**
 * @method Name: setupScratchpadOpportunity
 * @description :Query test opportunity
 */
      public static Scratchpad_Opportunity__c setupScratchpadOpportunity(){
            //scratchpadOpp= [select id FROM Scratchpad_Opportunity__c where name='Opportunity for test class' limit 1];
            Account acc =[Select id from account limit 1];
            Geo_Region_Master__c geo=[Select id from Geo_Region_Master__c limit 1];
            Operating_Groups_Master__c oppgrp=[Select id from Operating_Groups_Master__c limit 1];
             scratchpadOpp=new Scratchpad_Opportunity__c(Client__c=acc.id,Country__c='india',Geo_Region__c=geo.id,
                                        Offering__c='Finance and Accounting',Operating_Group__c=oppgrp.id,
                                        Contract_End__c=date.parse('11/1/2017'),
                                        Contract_Start__c=date.parse('11/1/2015'),
                                        Initial_Go_Live__c =date.parse('11/1/2016')
                                        );
            insert scratchpadOpp;                   
            return scratchpadOpp;
    }
    
/**
 * @method Name: syncFteCCD1
 * @description :Positive sync scenario with all offerings and services present
 */

    static testMethod void syncFteCCD1() {
        setupOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'SyncBPOSEDatatoSWB';
        ser.jsonRequestObject='{"FTEData":[{"LanguageNm":"","UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"","CreateDttm":"2015-05-25T07:44:08.537","UpdateDttm":"2015-05-25T07:44:08.537","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CareerLevelNm":"5-Senior Manager","BillCodeCd":"21","RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":"Accenture BPO Delivery Center High SU","MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","Description":"Description","SubServiceOfferingNm":"Finance And Accounting","RecruitingCostPCT":"1.0000","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"freetext 1","Description2":"freetext 2","Description3":"freetext 3","Description4":"freetext 4","Description5":"freetext 5","Description6":"freetext 6","Description7":"0","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","DeliveryLocationNm":"Banglore","DCNFTEType":"NOT DCN using BPO loads","FTEType":"Employee","BaselineFTE":"0.01","PyramidRichness":"2.05","Column4":"","Column5":"","Column6":"","Column7":"","Column8":"","Column9":"","Column10":"","Column11":"","Column12":"","Column13":"","Column14":"","Column15":"","Column16":"","Column17":"","ServiceOfferingNm":"Order to Cash","CrossSolutioning":"Bill code_ 73   Rate type_ BPO|Finance and Accounting_Day_Std|Delhi   Load type_ Borrowed","MobCategory":"N","MobSubCategory":"","Month1":0.3450,"Month2":0.3450,"Month3":0.3450,"Month4":0.3450,"Month5":0.3450,"Month6":0.3450,"Month7":0.3450,"Month8":0.3450,"Month9":0.3450,"Month10":0.3450,"Month11":0.3450,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"GroupName":"PMO","NONDCNLocation":"dvsd","CostRate":6.0000,"TotalLoads":5.0000,"HoursAppliedToContract":869.0000,"FTEMobTotals":4525.0,"FTEYr1":4.0000,"FTEYr2":4.0000,"FTEYr3":4.0000,"FTEYr4":4.0000,"FTEYr5":0.0,"FTEYr6":0.0,"FTEYr7":0.0,"FTEYr8":4.0000,"FTEYr9":0.0,"FTEYr10":0.0,"FinalMonthFTE":85.0000,"LocationTypeCode":3, "LocationTypeName":"ACN OffShore"}],"CCData":[{"UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"ezdhan.hussain.s.k","CreateDttm":"2015-05-25T07:44:08.61","UpdateDttm":"2015-05-25T07:44:08.61","Description":"RECRUITMENT(DNP)","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CostTypeCd":"DNP","RunTypeCd":"","ServiceOfferingNm":"Technology Tools","ToolName":"APC","ToolType":"Standard","MobCategory":null,"MobSubCategory":null,"RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":null,"MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","SubServiceOfferingNm":"Finance And Accounting","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"","Description2":"","Description3":"","Description4":"","Description5":"","Description6":"","Description7":"","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","Month1":5010.0000,"Month2":10.0000,"Month3":10.0000,"Month4":10.0000,"Month5":10.0000,"Month6":10.0000,"Month7":10.0000,"Month8":10.0000,"Month9":10.0000,"Month10":10.0000,"Month11":10.0000,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"LocationTypeCode":0,"LocationTypeName":null}],"isFirstChunk":true,"Opportunityid":"'+testOpportunity.id+'"}';         insertfteccdata=json.serialize(ser);
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        String rest=restendpoint.Base_URL__c;
        test.starttest();
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(insertfteccdata);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        system.debug('results--------------->'+results);
        syncFinal1();
        /*List<Fte_Details__c>ftedetails=[Select id from Fte_Details__C where opportunity__c=:testOpportunity.id];
        List<other_cost_details__c>othercost=[Select id from other_cost_details__c where opportunity__c=:testOpportunity.id];
        costing_request__c  cost=[Select id from costing_request__c where opportunity__c=:testOpportunity.id ];
        system.debug('Opportunityid delete'+testOpportunity.id );
        Map<String, String>costdataMap= new map<String,String>();
                    costdataMap.put(SWBBPOSEIntegrationConstants.id,cost.id);
                    costdataMap.put(SWBBPOSEIntegrationConstants.oppfield,testOpportunity.id);
                    costdataMap.put(SWBBPOSEIntegrationConstants.initialgolive ,string.valueof('11/1/2015'));
                    costdataMap.put(SWBBPOSEIntegrationConstants.contractstart ,string.valueof('10/2/2015'));
                    costdataMap.put(SWBBPOSEIntegrationConstants.contractend ,string.valueof('11/4/2015'));
                    costdataMap.put(SWBBPOSEIntegrationConstants.ssmversion ,'V33');
                    costdataMap.put(SWBBPOSEIntegrationConstants.versionname ,'V1');
                    costdataMap.put(SWBBPOSEIntegrationConstants.scenarioname ,'S1');
                    costdataMap.put(SWBBPOSEIntegrationConstants.mrdbversion ,'MRDB1');
                    costdataMap.put(SWBBPOSEIntegrationConstants.mrdblastrefreshdate ,string.valueof('11/1/2015'));
                    costdataMap.put(SWBBPOSEIntegrationConstants.HasMasterDataBeenCustomizedForDeal,string.valueof('true'));
                    //costdata.put(costingRecord.Last_Synced_Date__c,'This will be system.now() hence not added to map');
                    costdataMap.put(SWBBPOSEIntegrationConstants.lastsyncedby ,'a.avdesh.sharma');
                    costdataMap.put(SWBBPOSEIntegrationConstants.VersionID,'Ver');
        Set<ID> datalist=new Set<ID>();
        system.debug('datalist'+datalist.size());
       // database.executeBatch(new deletebatchsync(datalist,testOpportunity.id,'Commit',costdataMap));
        //database.executeBatch(new new BatchFTEOtherCost(testOpportunity.id));*/
        test.stoptest();
        
        
    }
    
   /**
 * @method Name: syncFteCCD2
 * @description :Positive sync scenario with all offerings and services are not present
 */

   /* static testMethod void syncFteCCD2() {
        setupOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'SyncBPOSEDatatoSWB';
        ser.jsonRequestObject='{"FTEData":[{"LanguageNm":"","UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"","CreateDttm":"2015-05-25T07:44:08.537","UpdateDttm":"2015-05-25T07:44:08.537","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CareerLevelNm":"5-Senior Manager","BillCodeCd":"21","RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":"Accenture BPO Delivery Center High SU","MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","Description":"Description","SubServiceOfferingNm":"Sourcing and Procurement","RecruitingCostPCT":"1.0000","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"freetext 1","Description2":"freetext 2","Description3":"freetext 3","Description4":"freetext 4","Description5":"freetext 5","Description6":"freetext 6","Description7":"0","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","DeliveryLocationNm":"NA Client Loc","DCNFTEType":"NOT DCN using BPO loads","FTEType":"Employee","BaselineFTE":"0.01","PyramidRichness":"2.05","Column4":"","Column5":"","Column6":"","Column7":"","Column8":"","Column9":"","Column10":"","Column11":"","Column12":"","Column13":"","Column14":"","Column15":"","Column16":"","Column17":"","ServiceOfferingNm":"Energy","CrossSolutioning":"Bill code_ 73   Rate type_ BPO|Finance and Accounting_Day_Std|Delhi   Load type_ Borrowed","MobCategory":"N","MobSubCategory":"","Month1":0.3450,"Month2":0.3450,"Month3":0.3450,"Month4":0.3450,"Month5":0.3450,"Month6":0.3450,"Month7":0.3450,"Month8":0.3450,"Month9":0.3450,"Month10":0.3450,"Month11":0.3450,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"GroupName":"PMO","NONDCNLocation":"dvsd","CostRate":6.0000,"TotalLoads":5.0000,"HoursAppliedToContract":869.0000,"FTEMobTotals":4525.0,"FTEYr1":4.0000,"FTEYr2":4.0000,"FTEYr3":4.0000,"FTEYr4":4.0000,"FTEYr5":0.0,"FTEYr6":0.0,"FTEYr7":0.0,"FTEYr8":4.0000,"FTEYr9":0.0,"FTEYr10":0.0,"FinalMonthFTE":85.0000,"LocationTypeCode":3, "LocationTypeName":"ACN OffShore"}],"CCData":[{"UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"ezdhan.hussain.s.k","CreateDttm":"2015-05-25T07:44:08.61","UpdateDttm":"2015-05-25T07:44:08.61","Description":"RECRUITMENT(DNP)","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CostTypeCd":"DNP","RunTypeCd":"","ServiceOfferingNm":"Energy","ToolName":"APC","ToolType":"Standard","MobCategory":null,"MobSubCategory":null,"RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":null,"MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","SubServiceOfferingNm":"Sourcing and Procurement","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"","Description2":"","Description3":"","Description4":"","Description5":"","Description6":"","Description7":"","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","Month1":5010.0000,"Month2":10.0000,"Month3":10.0000,"Month4":10.0000,"Month5":10.0000,"Month6":10.0000,"Month7":10.0000,"Month8":10.0000,"Month9":10.0000,"Month10":10.0000,"Month11":10.0000,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"LocationTypeCode":0,"LocationTypeName":null}],"isFirstChunk":true,"Opportunityid":"'+testOpportunity.id+'"}';       
        insertfteccdata=json.serialize(ser);
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        String rest=restendpoint.Base_URL__c;
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(insertfteccdata);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        syncFinal1();
        test.starttest();
        List<Fte_Details__c>ftedetails=[Select id from Fte_Details__C where opportunity__c=:testOpportunity.id];
        List<other_cost_details__c>othercost=[Select id from other_cost_details__c where opportunity__c=:testOpportunity.id];
        costing_request__c  cost=[Select id from costing_request__c where opportunity__c=:testOpportunity.id ];
        system.debug('Opportunityid delete'+testOpportunity.id );
        Map<String, String>costdataMap= new map<String,String>();
                    costdataMap.put(SWBBPOSEIntegrationConstants.id,cost.id);
                    costdataMap.put(SWBBPOSEIntegrationConstants.oppfield,testOpportunity.id);
                    costdataMap.put(SWBBPOSEIntegrationConstants.initialgolive ,string.valueof('11/1/2015'));
                    costdataMap.put(SWBBPOSEIntegrationConstants.contractstart ,string.valueof('11/1/2015'));
                    costdataMap.put(SWBBPOSEIntegrationConstants.contractend ,string.valueof('11/1/2015'));
                    costdataMap.put(SWBBPOSEIntegrationConstants.ssmversion ,'V33');
                    costdataMap.put(SWBBPOSEIntegrationConstants.versionname ,'V1');
                    costdataMap.put(SWBBPOSEIntegrationConstants.scenarioname ,'S1');
                    costdataMap.put(SWBBPOSEIntegrationConstants.mrdbversion ,'MRDB1');
                    costdataMap.put(SWBBPOSEIntegrationConstants.mrdblastrefreshdate ,string.valueof('2015-06-02'));
                    costdataMap.put(SWBBPOSEIntegrationConstants.HasMasterDataBeenCustomizedForDeal,string.valueof('true'));
                    //costdata.put(costingRecord.Last_Synced_Date__c,'This will be system.now() hence not added to map');
                    costdataMap.put(SWBBPOSEIntegrationConstants.lastsyncedby ,'a.avdesh.sharma');
                    costdataMap.put(SWBBPOSEIntegrationConstants.VersionID,'Ver');
       Set<ID> datalist=new Set<ID>();
         for(Fte_Details__C fte:ftedetails){
            datalist.add(fte.id);
        }
       for(other_cost_details__c otc:othercost){
            datalist.add(otc.id);
        }
        system.debug('datalist'+datalist.size());
        database.executeBatch(new deletebatchsync(datalist,testOpportunity.id,'Rollback',costdataMap));
        
        test.stoptest();
    }*/
    
 /**
 * @method Name: syncFteCCD3
 * @description :Positive sync scenario with all offerings and services prestent and tech tool getting mapped to all
 */

    static testMethod void syncFteCCD3() {
        setupOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'SyncBPOSEDatatoSWB';
        ser.jsonRequestObject='{"FTEData":[{"LanguageNm":"","UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"","CreateDttm":"2015-05-25T07:44:08.537","UpdateDttm":"2015-05-25T07:44:08.537","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CareerLevelNm":"5-Senior Manager","BillCodeCd":"21","RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":"Accenture BPO Delivery Center High SU","MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","Description":"Description","SubServiceOfferingNm":"Sourcing and Procurement","RecruitingCostPCT":"1.0000","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"freetext 1","Description2":"freetext 2","Description3":"freetext 3","Description4":"freetext 4","Description5":"freetext 5","Description6":"freetext 6","Description7":"0","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","DeliveryLocationNm":"0","DCNFTEType":"NOT DCN using BPO loads","FTEType":"Employee","BaselineFTE":"0.01","PyramidRichness":"2.05","Column4":"","Column5":"","Column6":"","Column7":"","Column8":"","Column9":"","Column10":"","Column11":"","Column12":"","Column13":"","Column14":"","Column15":"","Column16":"","Column17":"","ServiceOfferingNm":"Energy","CrossSolutioning":"Bill code_ 73   Rate type_ BPO|Finance and Accounting_Day_Std|Delhi   Load type_ Borrowed","MobCategory":"N","MobSubCategory":"","Month1":0.3450,"Month2":0.3450,"Month3":0.3450,"Month4":0.3450,"Month5":0.3450,"Month6":0.3450,"Month7":0.3450,"Month8":0.3450,"Month9":0.3450,"Month10":0.3450,"Month11":0.3450,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"GroupName":"PMO","NONDCNLocation":"dvsd","CostRate":6.0000,"TotalLoads":5.0000,"HoursAppliedToContract":869.0000,"FTEMobTotals":4525.0,"FTEYr1":4.0000,"FTEYr2":4.0000,"FTEYr3":4.0000,"FTEYr4":4.0000,"FTEYr5":0.0,"FTEYr6":0.0,"FTEYr7":0.0,"FTEYr8":4.0000,"FTEYr9":0.0,"FTEYr10":0.0,"FinalMonthFTE":85.0000,"LocationTypeCode":3, "LocationTypeName":"ACN OffShore"}],"CCData":[{"UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"ezdhan.hussain.s.k","CreateDttm":"2015-05-25T07:44:08.61","UpdateDttm":"2015-05-25T07:44:08.61","Description":"RECRUITMENT(DNP)","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CostTypeCd":"DNP","RunTypeCd":"","ServiceOfferingNm":"Energy","ToolName":"WQM","ToolType":"Standard","MobCategory":null,"MobSubCategory":null,"RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":null,"MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","SubServiceOfferingNm":"Sourcing and Procurement","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"","Description2":"","Description3":"","Description4":"","Description5":"","Description6":"","Description7":"","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","Month1":5010.0000,"Month2":10.0000,"Month3":10.0000,"Month4":10.0000,"Month5":10.0000,"Month6":10.0000,"Month7":10.0000,"Month8":10.0000,"Month9":10.0000,"Month10":10.0000,"Month11":10.0000,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"LocationTypeCode":0,"LocationTypeName":null}],"isFirstChunk":true,"Opportunityid":"'+testOpportunity.id+'"}';        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        insertfteccdata=json.serialize(ser);
        String rest=restendpoint.Base_URL__c;
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(insertfteccdata);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        test.starttest();
        syncFinal1();
        List<Fte_Details__c>ftedetails=[Select id from Fte_Details__C where opportunity__c=:testOpportunity.id];
        List<other_cost_details__c>othercost=[Select id from other_cost_details__c where opportunity__c=:testOpportunity.id];
        costing_request__c  cost = new costing_request__c();
        queryCostRecord();
        system.debug('Opportunityid delete'+testOpportunity.id );
        system.debug('cost rec to update '+costrec.id);
        Map<String, String>costdataMap= new map<String,String>();
                    costdataMap.put(SWBBPOSEIntegrationConstants.id,costrec.id);
                    costdataMap.put(SWBBPOSEIntegrationConstants.oppfield,testOpportunity.id);
                    costdataMap.put(SWBBPOSEIntegrationConstants.initialgolive ,string.valueof('2016-07-24'));
                    costdataMap.put(SWBBPOSEIntegrationConstants.contractstart ,string.valueof('2015-07-24'));
                    costdataMap.put(SWBBPOSEIntegrationConstants.contractend ,string.valueof('2022-07-24'));
                    costdataMap.put(SWBBPOSEIntegrationConstants.ssmversion ,'V33');
                    costdataMap.put(SWBBPOSEIntegrationConstants.versionname ,'V1');
                    costdataMap.put(SWBBPOSEIntegrationConstants.scenarioname ,'S1');
                    costdataMap.put(SWBBPOSEIntegrationConstants.mrdbversion ,'MRDB1');
                    costdataMap.put(SWBBPOSEIntegrationConstants.mrdblastrefreshdate ,string.valueof('2015-06-02'));
                    costdataMap.put(SWBBPOSEIntegrationConstants.HasMasterDataBeenCustomizedForDeal,string.valueof('true'));
                    //costdata.put(costingRecord.Last_Synced_Date__c,'This will be system.now() hence not added to map');
                    costdataMap.put(SWBBPOSEIntegrationConstants.lastsyncedby ,'a.avdesh.sharma');
                    costdataMap.put(SWBBPOSEIntegrationConstants.VersionID,'Ver');
        Set<ID> datalist=new Set<ID>();
         for(Fte_Details__C fte:ftedetails){
            datalist.add(fte.id);
        }
        for(other_cost_details__c otc:othercost){
            datalist.add(otc.id);
        }
        system.debug('datalist'+datalist.size());
        DeleteBatchSync del=new DeleteBatchSync(datalist,testOpportunity.id,'Commit',costdataMap);
        del.isTestvariable=null;
        database.executeBatch(del);
        test.stoptest();
    }
    
 /**
 * @method Name: syncFteCCD4
 * @description :Custom tech tool insertion
 */

    static testMethod void syncFteCCD4() {
        setupOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'SyncBPOSEDatatoSWB';
        ser.jsonRequestObject='{"FTEData":[{"LanguageNm":"","UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"","CreateDttm":"2015-05-25T07:44:08.537","UpdateDttm":"2015-05-25T07:44:08.537","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CareerLevelNm":"5-Senior Manager","BillCodeCd":"21","RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":"Accenture BPO Delivery Center High SU","MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","Description":"Description","SubServiceOfferingNm":"Sourcing and Procurement","RecruitingCostPCT":"1.0000","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"freetext 1","Description2":"freetext 2","Description3":"freetext 3","Description4":"freetext 4","Description5":"freetext 5","Description6":"freetext 6","Description7":"0","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","DeliveryLocationNm":"0","DCNFTEType":"NOT DCN using BPO loads","FTEType":"Employee","BaselineFTE":"0.01","PyramidRichness":"2.05","Column4":"","Column5":"","Column6":"","Column7":"","Column8":"","Column9":"","Column10":"","Column11":"","Column12":"","Column13":"","Column14":"","Column15":"","Column16":"","Column17":"","ServiceOfferingNm":"Energy","CrossSolutioning":"Bill code_ 73   Rate type_ BPO|Finance and Accounting_Day_Std|Delhi   Load type_ Borrowed","MobCategory":"N","MobSubCategory":"","Month1":0.3450,"Month2":0.3450,"Month3":0.3450,"Month4":0.3450,"Month5":0.3450,"Month6":0.3450,"Month7":0.3450,"Month8":0.3450,"Month9":0.3450,"Month10":0.3450,"Month11":0.3450,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"GroupName":"PMO","NONDCNLocation":"dvsd","CostRate":6.0000,"TotalLoads":5.0000,"HoursAppliedToContract":869.0000,"FTEMobTotals":4525.0,"FTEYr1":4.0000,"FTEYr2":4.0000,"FTEYr3":4.0000,"FTEYr4":4.0000,"FTEYr5":0.0,"FTEYr6":0.0,"FTEYr7":0.0,"FTEYr8":4.0000,"FTEYr9":0.0,"FTEYr10":0.0,"FinalMonthFTE":85.0000,"LocationTypeCode":3, "LocationTypeName":"ACN OffShore"}],"CCData":[{"UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"ezdhan.hussain.s.k","CreateDttm":"2015-05-25T07:44:08.61","UpdateDttm":"2015-05-25T07:44:08.61","Description":"RECRUITMENT(DNP)","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CostTypeCd":"DNP","RunTypeCd":"","ServiceOfferingNm":"Energy","ToolName":"ABC","ToolType":"Custom","MobCategory":null,"MobSubCategory":null,"RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":null,"MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","SubServiceOfferingNm":"Sourcing and Procurement","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"","Description2":"","Description3":"","Description4":"","Description5":"","Description6":"","Description7":"","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","Month1":5010.0000,"Month2":10.0000,"Month3":10.0000,"Month4":10.0000,"Month5":10.0000,"Month6":10.0000,"Month7":10.0000,"Month8":10.0000,"Month9":10.0000,"Month10":10.0000,"Month11":10.0000,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"LocationTypeCode":0,"LocationTypeName":null}],"isFirstChunk":true,"Opportunityid":"'+testOpportunity.id+'"}';   
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();  
        insertfteccdata=json.serialize(ser);
        String rest=restendpoint.Base_URL__c;
        test.starttest();
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(insertfteccdata);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        syncFinal1();
        /*List<Fte_Details__c>ftedetails=[Select id from Fte_Details__C where opportunity__c=:testOpportunity.id];
        List<other_cost_details__c>othercost=[Select id from other_cost_details__c where opportunity__c=:testOpportunity.id];
        costing_request__c  cost=[Select id from costing_request__c where opportunity__c=:testOpportunity.id ];
        system.debug('Opportunityid delete'+testOpportunity.id );
        Map<String, String>costdataMap= new map<String,String>();
                    costdataMap.put(SWBBPOSEIntegrationConstants.id,cost.id);
                    costdataMap.put(SWBBPOSEIntegrationConstants.oppfield,testOpportunity.id);
                    costdataMap.put(SWBBPOSEIntegrationConstants.initialgolive ,string.valueof('11-1-2015'));
                    costdataMap.put(SWBBPOSEIntegrationConstants.contractstart ,string.valueof('10/2/2015'));
                    costdataMap.put(SWBBPOSEIntegrationConstants.contractend ,string.valueof('11/4/2015'));
                    costdataMap.put(SWBBPOSEIntegrationConstants.ssmversion ,'V33');
                    costdataMap.put(SWBBPOSEIntegrationConstants.versionname ,'V1');
                    costdataMap.put(SWBBPOSEIntegrationConstants.scenarioname ,'S1');
                    costdataMap.put(SWBBPOSEIntegrationConstants.mrdbversion ,'MRDB1');
                    costdataMap.put(SWBBPOSEIntegrationConstants.mrdblastrefreshdate ,string.valueof('11/1/2015'));
                    costdataMap.put(SWBBPOSEIntegrationConstants.HasMasterDataBeenCustomizedForDeal,string.valueof('true'));
                    //costdata.put(costingRecord.Last_Synced_Date__c,'This will be system.now() hence not added to map');
                    costdataMap.put(SWBBPOSEIntegrationConstants.lastsyncedby ,'a.avdesh.sharma');
                    costdataMap.put(SWBBPOSEIntegrationConstants.VersionID,'Ver');
        Set<ID> datalist=new Set<ID>();
        system.debug('datalist'+datalist.size());
        database.executeBatch(new deletebatchsync(datalist,testOpportunity.id,'Commit',costdataMap));*/
        test.stoptest();
    }
    
    
 /**
 * @method Name: syncFteCCD5
 * @description :Custom tech tool insertion
 */

    static testMethod void syncFteCCD5() {
        setupOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'SyncBPOSEDatatoSWB';
        ser.jsonRequestObject='{"FTEData":[{"LanguageNm":"","UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"","CreateDttm":"2015-05-25T07:44:08.537","UpdateDttm":"2015-05-25T07:44:08.537","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CareerLevelNm":"5-Senior Manager","BillCodeCd":"21","RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":"Accenture BPO Delivery Center High SU","MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","Description":"Description","SubServiceOfferingNm":"Sourcing and Procurement","RecruitingCostPCT":"1.0000","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"freetext 1","Description2":"freetext 2","Description3":"freetext 3","Description4":"freetext 4","Description5":"freetext 5","Description6":"freetext 6","Description7":"0","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","DeliveryLocationNm":"0","DCNFTEType":"NOT DCN using BPO loads","FTEType":"Employee","BaselineFTE":"0.01","PyramidRichness":"2.05","Column4":"","Column5":"","Column6":"","Column7":"","Column8":"","Column9":"","Column10":"","Column11":"","Column12":"","Column13":"","Column14":"","Column15":"","Column16":"","Column17":"","ServiceOfferingNm":"Energy","CrossSolutioning":"Bill code_ 73   Rate type_ BPO|Finance and Accounting_Day_Std|Delhi   Load type_ Borrowed","MobCategory":"N","MobSubCategory":"","Month1":0.3450,"Month2":0.3450,"Month3":0.3450,"Month4":0.3450,"Month5":0.3450,"Month6":0.3450,"Month7":0.3450,"Month8":0.3450,"Month9":0.3450,"Month10":0.3450,"Month11":0.3450,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"GroupName":"PMO","NONDCNLocation":"dvsd","CostRate":6.0000,"TotalLoads":5.0000,"HoursAppliedToContract":869.0000,"FTEMobTotals":4525.0,"FTEYr1":4.0000,"FTEYr2":4.0000,"FTEYr3":4.0000,"FTEYr4":4.0000,"FTEYr5":0.0,"FTEYr6":0.0,"FTEYr7":0.0,"FTEYr8":4.0000,"FTEYr9":0.0,"FTEYr10":0.0,"FinalMonthFTE":85.0000,"LocationTypeCode":3, "LocationTypeName":"ACN OffShore"}],"CCData":[{"UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"ezdhan.hussain.s.k","CreateDttm":"2015-05-25T07:44:08.61","UpdateDttm":"2015-05-25T07:44:08.61","Description":"RECRUITMENT(DNP)","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CostTypeCd":"DNP","RunTypeCd":"","ServiceOfferingNm":"Energy","ToolName":"ABC","ToolType":"Custom","MobCategory":null,"MobSubCategory":null,"RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":null,"MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","SubServiceOfferingNm":"Sourcing and Procurement","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"","Description2":"","Description3":"","Description4":"","Description5":"","Description6":"","Description7":"","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","Month1":5010.0000,"Month2":10.0000,"Month3":10.0000,"Month4":10.0000,"Month5":10.0000,"Month6":10.0000,"Month7":10.0000,"Month8":10.0000,"Month9":10.0000,"Month10":10.0000,"Month11":10.0000,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"LocationTypeCode":0,"LocationTypeName":null}],"isFirstChunk":true,"Opportunityid":"'+testOpportunity.id+'"}';   
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();  
        insertfteccdata=json.serialize(ser);
        String rest=restendpoint.Base_URL__c;
        test.starttest();
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(insertfteccdata);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        syncFinal2();
        test.stoptest();
    }
    
    
 /**
 * @method Name: syncFteCCD6
 * @description :Service maps with ALL and custom tool creation
 */

    static testMethod void syncFteCCD6() {
        setupOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'SyncBPOSEDatatoSWB';
        ser.jsonRequestObject='{"FTEData":[{"LanguageNm":"","UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"","CreateDttm":"2015-05-25T07:44:08.537","UpdateDttm":"2015-05-25T07:44:08.537","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CareerLevelNm":"5-Senior Manager","BillCodeCd":"21","RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":"Accenture BPO Delivery Center High SU","MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","Description":"Description","SubServiceOfferingNm":"Sourcing and Procurement","RecruitingCostPCT":"1.0000","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"freetext 1","Description2":"freetext 2","Description3":"freetext 3","Description4":"freetext 4","Description5":"freetext 5","Description6":"freetext 6","Description7":"0","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","DeliveryLocationNm":"0","DCNFTEType":"NOT DCN using BPO loads","FTEType":"Employee","BaselineFTE":"0.01","PyramidRichness":"2.05","Column4":"","Column5":"","Column6":"","Column7":"","Column8":"","Column9":"","Column10":"","Column11":"","Column12":"","Column13":"","Column14":"","Column15":"","Column16":"","Column17":"","ServiceOfferingNm":"Energy","CrossSolutioning":"Bill code_ 73   Rate type_ BPO|Finance and Accounting_Day_Std|Delhi   Load type_ Borrowed","MobCategory":"N","MobSubCategory":"","Month1":0.3450,"Month2":0.3450,"Month3":0.3450,"Month4":0.3450,"Month5":0.3450,"Month6":0.3450,"Month7":0.3450,"Month8":0.3450,"Month9":0.3450,"Month10":0.3450,"Month11":0.3450,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"GroupName":"PMO","NONDCNLocation":"dvsd","CostRate":6.0000,"TotalLoads":5.0000,"HoursAppliedToContract":869.0000,"FTEMobTotals":4525.0,"FTEYr1":4.0000,"FTEYr2":4.0000,"FTEYr3":4.0000,"FTEYr4":4.0000,"FTEYr5":0.0,"FTEYr6":0.0,"FTEYr7":0.0,"FTEYr8":4.0000,"FTEYr9":0.0,"FTEYr10":0.0,"FinalMonthFTE":85.0000,"LocationTypeCode":3, "LocationTypeName":"ACN OffShore"}],"CCData":[{"UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"ezdhan.hussain.s.k","CreateDttm":"2015-05-25T07:44:08.61","UpdateDttm":"2015-05-25T07:44:08.61","Description":"RECRUITMENT(DNP)","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CostTypeCd":"DNP","RunTypeCd":"","ServiceOfferingNm":"Technology Tools","ToolName":"ABC","ToolType":"Custom","MobCategory":null,"MobSubCategory":null,"RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":null,"MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","SubServiceOfferingNm":"Credit Services","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"","Description2":"","Description3":"","Description4":"","Description5":"","Description6":"","Description7":"","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","Month1":5010.0000,"Month2":10.0000,"Month3":10.0000,"Month4":10.0000,"Month5":10.0000,"Month6":10.0000,"Month7":10.0000,"Month8":10.0000,"Month9":10.0000,"Month10":10.0000,"Month11":10.0000,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"LocationTypeCode":0,"LocationTypeName":null}],"isFirstChunk":true,"Opportunityid":"'+testOpportunity.id+'"}';   
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();  
        insertfteccdata=json.serialize(ser);
        String rest=restendpoint.Base_URL__c;
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(insertfteccdata);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        test.starttest();
        String results = SyncData.parseJson();
       // syncFinal1();
        test.stoptest();
    }
    
    /**
 * @method Name: syncFteCCD7
 * @description :Negative test-->Standard tool not present
 */

    static testMethod void syncFteCCD7() {
        setupOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'SyncBPOSEDatatoSWB';
ser.jsonRequestObject='{"FTEData":[{"LanguageNm":"","UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"","CreateDttm":"2015-05-25T07:44:08.537","UpdateDttm":"2015-05-25T07:44:08.537","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CareerLevelNm":"5-Senior Manager","BillCodeCd":"21","RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":"Accenture BPO Delivery Center High SU","MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","Description":"Description","SubServiceOfferingNm":"Sourcing and Procurement","RecruitingCostPCT":"1.0000","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"freetext 1","Description2":"freetext 2","Description3":"freetext 3","Description4":"freetext 4","Description5":"freetext 5","Description6":"freetext 6","Description7":"0","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","DeliveryLocationNm":"0","DCNFTEType":"NOT DCN using BPO loads","FTEType":"Employee","BaselineFTE":"0.01","PyramidRichness":"2.05","Column4":"","Column5":"","Column6":"","Column7":"","Column8":"","Column9":"","Column10":"","Column11":"","Column12":"","Column13":"","Column14":"","Column15":"","Column16":"","Column17":"","ServiceOfferingNm":"Energy","CrossSolutioning":"Bill code_ 73   Rate type_ BPO|Finance and Accounting_Day_Std|Delhi   Load type_ Borrowed","MobCategory":"N","MobSubCategory":"","Month1":0.3450,"Month2":0.3450,"Month3":0.3450,"Month4":0.3450,"Month5":0.3450,"Month6":0.3450,"Month7":0.3450,"Month8":0.3450,"Month9":0.3450,"Month10":0.3450,"Month11":0.3450,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"GroupName":"PMO","NONDCNLocation":"dvsd","CostRate":6.0000,"TotalLoads":5.0000,"HoursAppliedToContract":869.0000,"FTEMobTotals":4525.0,"FTEYr1":4.0000,"FTEYr2":4.0000,"FTEYr3":4.0000,"FTEYr4":4.0000,"FTEYr5":0.0,"FTEYr6":0.0,"FTEYr7":0.0,"FTEYr8":4.0000,"FTEYr9":0.0,"FTEYr10":0.0,"FinalMonthFTE":85.0000,"LocationTypeCode":3, "LocationTypeName":"ACN OffShore"}],"CCData":[{"UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"ezdhan.hussain.s.k","CreateDttm":"2015-05-25T07:44:08.61","UpdateDttm":"2015-05-25T07:44:08.61","Description":"RECRUITMENT(DNP)","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CostTypeCd":"DNP","RunTypeCd":"","ServiceOfferingNm":"Technology Tools","ToolName":"ABC","ToolType":"Standard","MobCategory":null,"MobSubCategory":null,"RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":null,"MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","SubServiceOfferingNm":"Credit Services","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"","Description2":"","Description3":"","Description4":"","Description5":"","Description6":"","Description7":"","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","Month1":5010.0000,"Month2":10.0000,"Month3":10.0000,"Month4":10.0000,"Month5":10.0000,"Month6":10.0000,"Month7":10.0000,"Month8":10.0000,"Month9":10.0000,"Month10":10.0000,"Month11":10.0000,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"LocationTypeCode":0,"LocationTypeName":null}],"isFirstChunk":true,"Opportunityid":"'+testOpportunity.id+'"}';      Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();  
        insertfteccdata=json.serialize(ser);
        String rest=restendpoint.Base_URL__c;
        test.starttest();
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(insertfteccdata);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        syncFinal1();
        test.stoptest();
    }
    
    
    /**
 * @method Name: syncFteCCD8
 * @description :Positive sync scenario with all offerings and services present and custom tech tool absent
 */

    static testMethod void syncFteCCD8() {
        setupOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'SyncBPOSEDatatoSWB';
        ser.jsonRequestObject='{"FTEData":[{"LanguageNm":"","UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"","CreateDttm":"2015-05-25T07:44:08.537","UpdateDttm":"2015-05-25T07:44:08.537","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CareerLevelNm":"5-Senior Manager","BillCodeCd":"21","RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":"Accenture BPO Delivery Center High SU","MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","Description":"Description","SubServiceOfferingNm":"Finance And Accounting","RecruitingCostPCT":"1.0000","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"freetext 1","Description2":"freetext 2","Description3":"freetext 3","Description4":"freetext 4","Description5":"freetext 5","Description6":"freetext 6","Description7":"0","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","DeliveryLocationNm":"Banglore","DCNFTEType":"NOT DCN using BPO loads","FTEType":"Employee","BaselineFTE":"0.01","PyramidRichness":"2.05","Column4":"","Column5":"","Column6":"","Column7":"","Column8":"","Column9":"","Column10":"","Column11":"","Column12":"","Column13":"","Column14":"","Column15":"","Column16":"","Column17":"","ServiceOfferingNm":"Order to Cash","CrossSolutioning":"Bill code_ 73   Rate type_ BPO|Finance and Accounting_Day_Std|Delhi   Load type_ Borrowed","MobCategory":"N","MobSubCategory":"","Month1":0.3450,"Month2":0.3450,"Month3":0.3450,"Month4":0.3450,"Month5":0.3450,"Month6":0.3450,"Month7":0.3450,"Month8":0.3450,"Month9":0.3450,"Month10":0.3450,"Month11":0.3450,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"GroupName":"PMO","NONDCNLocation":"dvsd","CostRate":6.0000,"TotalLoads":5.0000,"HoursAppliedToContract":869.0000,"FTEMobTotals":4525.0,"FTEYr1":4.0000,"FTEYr2":4.0000,"FTEYr3":4.0000,"FTEYr4":4.0000,"FTEYr5":0.0,"FTEYr6":0.0,"FTEYr7":0.0,"FTEYr8":4.0000,"FTEYr9":0.0,"FTEYr10":0.0,"FinalMonthFTE":85.0000,"LocationTypeCode":3, "LocationTypeName":"ACN OffShore"}],"CCData":[{"UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"ezdhan.hussain.s.k","CreateDttm":"2015-05-25T07:44:08.61","UpdateDttm":"2015-05-25T07:44:08.61","Description":"RECRUITMENT(DNP)","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CostTypeCd":"DNP","RunTypeCd":"","ServiceOfferingNm":"Technology Tools","ToolName":"CUSTOMTOOLTYPE","ToolType":"Custom","MobCategory":null,"MobSubCategory":null,"RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":null,"MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","SubServiceOfferingNm":"Finance And Accounting","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"","Description2":"","Description3":"","Description4":"","Description5":"","Description6":"","Description7":"","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","Month1":5010.0000,"Month2":10.0000,"Month3":10.0000,"Month4":10.0000,"Month5":10.0000,"Month6":10.0000,"Month7":10.0000,"Month8":10.0000,"Month9":10.0000,"Month10":10.0000,"Month11":10.0000,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"LocationTypeCode":0,"LocationTypeName":null}],"isFirstChunk":true,"Opportunityid":"'+testOpportunity.id+'"}';         insertfteccdata=json.serialize(ser);
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        String rest=restendpoint.Base_URL__c;
        test.starttest();
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(insertfteccdata);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        system.debug('results--------------->'+results);
        syncFinal1();
        database.executeBatch(new BatchFTEOtherCost(testOpportunity.id));
        
        test.stoptest();
        
        
    }
 /**
 * @method Name: syncFinal1
 * @description :Positive sync scenario for finalize transaction
 */

    static  void syncFinal1() {
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'SyncCompleted';
        ser.jsonRequestObject='{"Opportunityid":"'+testOpportunity.id+'","isTransactionSuccessful":true,"RowCount":2,"enterpriseid":"ezdhan.hussain.s.k","SSMVersion":"V33","ScenarioNm":"New Scenario","ScenarioContractStartDate":"2015-07-24","ScenarioContractEndDate":"2022-07-24","ScenarioGoLiveDate":"2016-07-24","VersionNm":"Version 1","MRDBDate":"2015-06-02","MRDBVersion":"98","VersionID":"6296","BPOSETemplateVersion":"3","BDLGeneratedUTCDateTime":"1900-01-01T00:00:00","LstBDLGeneratedUserNm":null,"LstBDLGeneratedVrNm":null,"LstBDLGeneratedScNm":null,"HasMasterDataBeenCustomizedForDeal":false}';
        completesync=json.serialize(ser);
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        String rest=restendpoint.Base_URL__c;
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(completesync);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
       
    }
    
     /**
 * @method Name: syncFinal2
 * @description :Negative sync scenario for finalize transaction
 */

    static  void syncFinal2() {
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'SyncCompleted';
        ser.jsonRequestObject='{"Opportunityid":"'+testOpportunity.id+'","isTransactionSuccessful":false,"RowCount":2,"enterpriseid":"ezdhan.hussain.s.k","SSMVersion":"V33","ScenarioNm":"New Scenario","ScenarioContractStartDate":"2015-07-24","ScenarioContractEndDate":"2022-07-24","ScenarioGoLiveDate":"2016-07-24","VersionNm":"Version 1","MRDBDate":"2015-06-02","MRDBVersion":"98","VersionID":"6296","BPOSETemplateVersion":"3","BDLGeneratedUTCDateTime":"1900-01-01T00:00:00","LstBDLGeneratedUserNm":null,"LstBDLGeneratedVrNm":null,"LstBDLGeneratedScNm":null,"HasMasterDataBeenCustomizedForDeal":false}';
        completesync=json.serialize(ser);
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        String rest=restendpoint.Base_URL__c;
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(completesync);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
    }
    
    /**
 * @method Name: sendBDL1
 * @description :Posituve sync scenario for send BDL scenario
 */

    static testMethod void sendBDL1() {
        setupOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'SendBDLData';
        ser.jsonRequestObject='{"opportunityid":"'+testOpportunity.id +'","LstBDLGeneratedScNm":"NewScenario", "LstBDLGeneratedVrNm" : "Version1"," LstBDLGeneratedUserNm" :"bposeintegrationuser","BDLGeneratedUTCDateTime" : "1900-01-01T16:46:00.000Z"}';
        bdldatajson=json.serialize(ser);
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        String rest=restendpoint.Base_URL__c;
        test.starttest();
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(bdldatajson);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        
        
        test.stoptest();
    }
    
 /**
 * @method Name: sendBDL2
 * @description :Posituve sync scenario for send BDL scenario
 */

    static testMethod void sendBDL2() {
        setupOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'SendBDLData';
        ser.jsonRequestObject='{"opportunityid":"'+testOpportunity.id +'","LstBDLGeneratedScNm":"NewScenario", "LstBDLGeneratedVrNm" : "Version1"," LstBDLGeneratedUserNm" :"testuser","BDLGeneratedUTCDateTime" : "1900-01-01T16:46:00.000Z"}';
        bdldatajson=json.serialize(ser);
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        String rest=restendpoint.Base_URL__c;
        test.starttest();
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(bdldatajson);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        test.stoptest();
    }
    
    /**
 * @method Name: autoSync1
 * @description :Positive sync scenario for auto sync scenarios scenario
 */

    static testMethod void autoSync1() {
        setupOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'AutoSyncDateForOpportunity';
        ser.jsonRequestObject='{"opportunityid":"'+testOpportunity.id +'", "ContractStartDate" : "2015-06-01T07:44:08.537","ContractEndDate" :"2016-06-01T07:44:08.537","GoLiveDate" : "2015-06-01T07:44:08.537"}';
        autosyncjson=json.serialize(ser);
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        String rest=restendpoint.Base_URL__c;
        test.starttest();
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(autosyncjson);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        test.stoptest();
    }
    
    
  /**
 * @method Name: oppTeamSync1
 * @description :Positive sync scenario for opportunity team scenario
 */

    static testMethod void oppTeamSync1() {
        setupOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'GetOpportunityTeamDetails';
        ser.jsonRequestObject='{"opportunityid":"'+testOpportunity.id+'"}';
        opportunityteamjson=json.serialize(ser);
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        String rest=restendpoint.Base_URL__c;
        test.starttest();
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(opportunityteamjson);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        test.stoptest();
    }
    
 /**
 * @method Name: oppSync1
 * @description :Positive sync scenario for opportunity details scenario setupScratchpadOpportunity
 */

    static testMethod void oppSync1() {
        setupOpportunity();
        
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'GetOpportunityDataForUser';
        ser.jsonRequestObject='{"opportunityid": "'+testOpportunity.id +'","enterpriseid": "bposeintegrationuser"}';
        opportunitydetailsjson=json.serialize(ser);
        opportunityteamjson=json.serialize(ser);
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        String rest=restendpoint.Base_URL__c;
        test.starttest();
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(opportunityteamjson);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        test.stoptest();
    }
    
 /**
 * @method Name: oppSync2
 * @description :Positive sync scenario for opportunity details scenario setupScratchpadOpportunity
 */

    static testMethod void oppSync2() {
        setupScratchpadOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'GetOpportunityDataForUser';
        ser.jsonRequestObject='{"opportunityid": "'+scratchpadOpp.id +'","enterpriseid": "bposeintegrationuser"}';
        opportunitydetailsjson=json.serialize(ser);
        opportunityteamjson=json.serialize(ser);
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        String rest=restendpoint.Base_URL__c;
        test.starttest();
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(opportunityteamjson);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        test.stoptest();
    }
    
     /**
 * @method Name: oppSync3
 * @description :Negative sync scenario for opportunity details scenario setupScratchpadOpportunity
 */

    static testMethod void oppSync3() {
        setupScratchpadOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'GetOpportunityDataForUser';
        ser.jsonRequestObject='{"opportunityid": "'+scratchpadOpp.id +'","enterpriseid": "ABCD"}';
        opportunitydetailsjson=json.serialize(ser);
        opportunityteamjson=json.serialize(ser);
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        String rest=restendpoint.Base_URL__c;
        test.starttest();
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(opportunityteamjson);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        test.stoptest();
    }
    
  /**
 * @method Name: oppSync4
 * @description :Negative sync scenario for opportunity details scenario setupScratchpadOpportunity
 */

    static testMethod void oppSync4() {
        setupOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'GetOpportunityDataForUser';
        ser.jsonRequestObject='{"opportunityid": "'+testOpportunity.id +'","enterpriseid": "ABCD"}';
        opportunitydetailsjson=json.serialize(ser);
        opportunityteamjson=json.serialize(ser);
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        String rest=restendpoint.Base_URL__c;
        test.starttest();
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(opportunityteamjson);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        test.stoptest();
    }
    
     /**
 * @method Name: oppSync5
 * @description :Negative sync scenario for opportunity details scenario 
 */

    static testMethod void oppSync5() {
        setupOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'GetOpportunityDataForUser';
        ser.jsonRequestObject='{"opportunityid": "005E0000004x35E","enterpriseid": "bposeintegrationuser"}';
        opportunitydetailsjson=json.serialize(ser);
        opportunityteamjson=json.serialize(ser);
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        String rest=restendpoint.Base_URL__c;
        test.starttest();
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(opportunityteamjson);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        test.stoptest();
    }
    
  /**
 * @method Name: oppSync6
 * @description :Negative sync scenario for opportunity details scenario setupScratchpadOpportunity
 */

    static testMethod void oppSync6() {
        setupScratchpadOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'GetOpportunityDataForUser';
        ser.jsonRequestObject='{"opportunityid": "005E0000004x35E","enterpriseid": "bposeintegrationuser"}';
        opportunitydetailsjson=json.serialize(ser);
        opportunityteamjson=json.serialize(ser);
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        String rest=restendpoint.Base_URL__c;
        test.starttest();
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(opportunityteamjson);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        test.stoptest();
    }
    
    /**
 * @method Name: coverResonseFunction
 * @description :functiopn to cover responseFunction method and cover SyncDataRequest
 */

    static testMethod void coverResonseFunction() {
       HandleRestRequestAndSendResponse handler=new HandleRestRequestAndSendResponse();
       handler.responseFunction(true);
       SyncDataRequest syncdata= new SyncDataRequest();
       SyncDataRequest.FTEDataEntity syncfte = new  SyncDataRequest.FTEDataEntity();
       SyncDataRequest.CCDataEntity syncccd =new  SyncDataRequest.CCDataEntity();
    }
    
    
    /**
 * @method Name: deletehugechuncktestOLD
 * @description :Positive sync scenario with all offerings and services present
 */

    static testMethod void deletehugechuncktestOLD() {
        setupOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'SyncBPOSEDatatoSWB';
        ser.jsonRequestObject='{"FTEData":[{"LanguageNm":"","UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"","CreateDttm":"2015-05-25T07:44:08.537","UpdateDttm":"2015-05-25T07:44:08.537","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CareerLevelNm":"5-Senior Manager","BillCodeCd":"21","RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":"Accenture BPO Delivery Center High SU","MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","Description":"Description","SubServiceOfferingNm":"Finance And Accounting","RecruitingCostPCT":"1.0000","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"freetext 1","Description2":"freetext 2","Description3":"freetext 3","Description4":"freetext 4","Description5":"freetext 5","Description6":"freetext 6","Description7":"0","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","DeliveryLocationNm":"Banglore","DCNFTEType":"NOT DCN using BPO loads","FTEType":"Employee","BaselineFTE":"0.01","PyramidRichness":"2.05","Column4":"","Column5":"","Column6":"","Column7":"","Column8":"","Column9":"","Column10":"","Column11":"","Column12":"","Column13":"","Column14":"","Column15":"","Column16":"","Column17":"","ServiceOfferingNm":"Order to Cash","CrossSolutioning":"Bill code_ 73   Rate type_ BPO|Finance and Accounting_Day_Std|Delhi   Load type_ Borrowed","MobCategory":"N","MobSubCategory":"","Month1":0.3450,"Month2":0.3450,"Month3":0.3450,"Month4":0.3450,"Month5":0.3450,"Month6":0.3450,"Month7":0.3450,"Month8":0.3450,"Month9":0.3450,"Month10":0.3450,"Month11":0.3450,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"GroupName":"PMO","NONDCNLocation":"dvsd","CostRate":6.0000,"TotalLoads":5.0000,"HoursAppliedToContract":869.0000,"FTEMobTotals":4525.0,"FTEYr1":4.0000,"FTEYr2":4.0000,"FTEYr3":4.0000,"FTEYr4":4.0000,"FTEYr5":0.0,"FTEYr6":0.0,"FTEYr7":0.0,"FTEYr8":4.0000,"FTEYr9":0.0,"FTEYr10":0.0,"FinalMonthFTE":85.0000,"LocationTypeCode":3, "LocationTypeName":"ACN OffShore"}],"CCData":[{"UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"ezdhan.hussain.s.k","CreateDttm":"2015-05-25T07:44:08.61","UpdateDttm":"2015-05-25T07:44:08.61","Description":"RECRUITMENT(DNP)","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CostTypeCd":"DNP","RunTypeCd":"","ServiceOfferingNm":"Technology Tools","ToolName":"APC","ToolType":"Standard","MobCategory":null,"MobSubCategory":null,"RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":null,"MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","SubServiceOfferingNm":"Finance And Accounting","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"","Description2":"","Description3":"","Description4":"","Description5":"","Description6":"","Description7":"","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","Month1":5010.0000,"Month2":10.0000,"Month3":10.0000,"Month4":10.0000,"Month5":10.0000,"Month6":10.0000,"Month7":10.0000,"Month8":10.0000,"Month9":10.0000,"Month10":10.0000,"Month11":10.0000,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"LocationTypeCode":0,"LocationTypeName":null}],"isFirstChunk":true,"Opportunityid":"'+testOpportunity.id+'"}';         insertfteccdata=json.serialize(ser);
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        String rest=restendpoint.Base_URL__c;
        test.starttest();
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(insertfteccdata);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        system.debug('results--------------->'+results);
        syncFinal1();
        List<Fte_Details__c>ftedetails=[Select id from Fte_Details__C where opportunity__c=:testOpportunity.id];
        List<other_cost_details__c>othercost=[Select id from other_cost_details__c where opportunity__c=:testOpportunity.id];
        queryCostRecord(); 
        //ScopeUpdataion_FutureClass.deleteData_hugeChunk(testOpportunity.id,'OLD',costrec.id);
        test.stoptest();
        
        
    }
    
    /**
 * @method Name: deletehugechuncktestNEW
 * @description :Positive sync scenario with all offerings and services present
 */

    static testMethod void deletehugechuncktestNEW() {
        setupOpportunity();
        SyncTest.serializeclass ser=new SyncTest.serializeclass();
        ser.method = 'SyncBPOSEDatatoSWB';
        ser.jsonRequestObject='{"FTEData":[{"LanguageNm":"","UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"","CreateDttm":"2015-05-25T07:44:08.537","UpdateDttm":"2015-05-25T07:44:08.537","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CareerLevelNm":"5-Senior Manager","BillCodeCd":"21","RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":"Accenture BPO Delivery Center High SU","MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","Description":"Description","SubServiceOfferingNm":"Finance And Accounting","RecruitingCostPCT":"1.0000","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"freetext 1","Description2":"freetext 2","Description3":"freetext 3","Description4":"freetext 4","Description5":"freetext 5","Description6":"freetext 6","Description7":"0","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","DeliveryLocationNm":"Banglore","DCNFTEType":"NOT DCN using BPO loads","FTEType":"Employee","BaselineFTE":"0.01","PyramidRichness":"2.05","Column4":"","Column5":"","Column6":"","Column7":"","Column8":"","Column9":"","Column10":"","Column11":"","Column12":"","Column13":"","Column14":"","Column15":"","Column16":"","Column17":"","ServiceOfferingNm":"Order to Cash","CrossSolutioning":"Bill code_ 73   Rate type_ BPO|Finance and Accounting_Day_Std|Delhi   Load type_ Borrowed","MobCategory":"N","MobSubCategory":"","Month1":0.3450,"Month2":0.3450,"Month3":0.3450,"Month4":0.3450,"Month5":0.3450,"Month6":0.3450,"Month7":0.3450,"Month8":0.3450,"Month9":0.3450,"Month10":0.3450,"Month11":0.3450,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"GroupName":"PMO","NONDCNLocation":"dvsd","CostRate":6.0000,"TotalLoads":5.0000,"HoursAppliedToContract":869.0000,"FTEMobTotals":4525.0,"FTEYr1":4.0000,"FTEYr2":4.0000,"FTEYr3":4.0000,"FTEYr4":4.0000,"FTEYr5":0.0,"FTEYr6":0.0,"FTEYr7":0.0,"FTEYr8":4.0000,"FTEYr9":0.0,"FTEYr10":0.0,"FinalMonthFTE":85.0000,"LocationTypeCode":3, "LocationTypeName":"ACN OffShore"}],"CCData":[{"UpdateUserId":"ezdhan.hussain.s.k","CreateUserid":"ezdhan.hussain.s.k","CreateDttm":"2015-05-25T07:44:08.61","UpdateDttm":"2015-05-25T07:44:08.61","Description":"RECRUITMENT(DNP)","CountryNm":"India","CareerTrackNm":"Client Delivery & Operations","CostTypeCd":"DNP","RunTypeCd":"","ServiceOfferingNm":"Technology Tools","ToolName":"APC","ToolType":"Standard","MobCategory":null,"MobSubCategory":null,"RateTypeCd":"BPO|Finance and Accounting_Day_Std|Delhi","LoadTypeCd":null,"MobilizationStartDt":"11/1/2015","GoLiveDt":"11/1/2015","SubServiceOfferingNm":"Finance And Accounting","CostingTypeCd":"FM","EconomicProfileNm":"Cross Contract Run","Description1":"","Description2":"","Description3":"","Description4":"","Description5":"","Description6":"","Description7":"","Generic1":"","Generic2":"","Generic3":"","Offering1":"","Offering2":"","Offering3":"","Month1":5010.0000,"Month2":10.0000,"Month3":10.0000,"Month4":10.0000,"Month5":10.0000,"Month6":10.0000,"Month7":10.0000,"Month8":10.0000,"Month9":10.0000,"Month10":10.0000,"Month11":10.0000,"Month12":10.0000,"Month13":10.0000,"Month14":10.0000,"Month15":10.0000,"Month16":10.0000,"Month17":10.0000,"Month18":10.0000,"Month19":10.0000,"Month20":10.0000,"Month21":10.0000,"Month22":10.0000,"Month23":10.0000,"Month24":10.0000,"Month25":10.0000,"Month26":10.0000,"Month27":10.0000,"Month28":10.0000,"Month29":10.0000,"Month30":10.0000,"Month31":10.0000,"Month32":10.0000,"Month33":10.0000,"Month34":10.0000,"Month35":10.0000,"Month36":10.0000,"Month37":10.0000,"Month38":10.0000,"Month39":10.0000,"Month40":10.0000,"Month41":10.0000,"Month42":10.0000,"Month43":10.0000,"Month44":10.0000,"Month45":10.0000,"Month46":10.0000,"Month47":10.0000,"Month48":10.0000,"Month49":10.0000,"Month50":10.0000,"Month51":10.0000,"Month52":10.0000,"Month53":10.0000,"Month54":10.0000,"Month55":10.0000,"Month56":10.0000,"Month57":10.0000,"Month58":10.0000,"Month59":10.0000,"Month60":10.0000,"Month61":10.0000,"Month62":10.0000,"Month63":10.0000,"Month64":10.0000,"Month65":10.0000,"Month66":10.0000,"Month67":10.0000,"Month68":10.0000,"Month69":10.0000,"Month70":10.0000,"Month71":10.0000,"Month72":10.0000,"Month73":10.0000,"Month74":10.0000,"Month75":10.0000,"Month76":10.0000,"Month77":10.0000,"Month78":10.0000,"Month79":10.0000,"Month80":10.0000,"Month81":10.0000,"Month82":10.0000,"Month83":10.0000,"Month84":10.0000,"Month85":10.0000,"Month86":10.0000,"Month87":10.0000,"Month88":10.0000,"Month89":10.0000,"Month90":10.0000,"Month91":10.0000,"Month92":10.0000,"Month93":10.0000,"Month94":10.0000,"Month95":10.0000,"Month96":10.0000,"Month97":10.0000,"Month98":10.0000,"Month99":10.0000,"Month100":10.0000,"Month101":10.0000,"Month102":10.0000,"Month103":10.0000,"Month104":10.0000,"Month105":10.0000,"Month106":10.0000,"Month107":10.0000,"Month108":10.0000,"Month109":10.0000,"Month110":10.0000,"Month111":10.0000,"Month112":10.0000,"Month113":10.0000,"Month114":10.0000,"Month115":10.0000,"Month116":10.0000,"Month117":10.0000,"Month118":10.0000,"Month119":10.0000,"Month120":10.0000,"MobTotals":5455.0000,"RunYr1":110.0000,"RunYr2":110.0000,"RunYr3":110.0000,"RunYr4":110.0000,"RunYr5":110.0000,"RunYr6":110.0000,"RunYr7":0.0,"RunYr8":0.0,"RunYr9":0.0,"RunYr10":0.0,"LocationTypeCode":0,"LocationTypeName":null}],"isFirstChunk":true,"Opportunityid":"'+testOpportunity.id+'"}';         insertfteccdata=json.serialize(ser);
        Rest_URL__c restendpoint = Rest_URL__c.getOrgDefaults();
        String rest=restendpoint.Base_URL__c;
        test.starttest();
        RestRequest req1 = new RestRequest();
        RestResponse res = new RestResponse(); 
        req1.httpmethod = 'POST';
        req1.requestBody= Blob.valueof(insertfteccdata);
        req1.requestURI = '<a target="_blank" href="'+rest+'"></a>'; 
        RestContext.request = req1;
        RestContext.response = res;
        String results = SyncData.parseJson();
        system.debug('results--------------->'+results);
        syncFinal1();
        List<Fte_Details__c>ftedetails=[Select id from Fte_Details__C where opportunity__c=:testOpportunity.id];
        List<other_cost_details__c>othercost=[Select id from other_cost_details__c where opportunity__c=:testOpportunity.id];
        queryCostRecord();
        //ScopeUpdataion_FutureClass.deleteData_hugeChunk(testOpportunity.id,'NEW',costrec.id);
        test.stoptest();
        
        
    }
    
    
    /**
 * @method Name: BatchClassfteccd
 * @description :Positive sync scenario with all offerings and services present
 */

   static testMethod void BatchClassfteccd() {
        
        setupOpportunity();
        Service__c serv = [Select id from Service__c where Solutionscope__r.opportunity__c=:testOpportunity.id limit 1];
        Fte_Details__c fte =new Fte_Details__c(opportunity__c=testOpportunity.id,Service__c=serv.id);
        other_cost_details__c ocd =new other_cost_details__c(opportunity__c=testOpportunity.id,Service__c=serv.id);
        ocd.Cost_Type__c = 'Payroll';
        system.debug('Error----------->'+serv.id+'------->');
        try{
        insert fte ;
        system.debug('Error----------->'+serv.id+'------->'+fte);
        insert ocd;
        system.debug('Error----------->'+serv.id+'------->'+ocd);
        
        }
        catch(Exception e){
         system.debug('Error----------->'+e);
        }
        test.starttest();
           Id batchInstanceId =  database.executeBatch(new BatchFTEOtherCost(testOpportunity.id));
        test.stoptest();
    }
    
    
}