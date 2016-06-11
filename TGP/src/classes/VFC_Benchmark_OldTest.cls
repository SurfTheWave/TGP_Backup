/*
Author : Rajdeep Bhuiya
Story  : Release 2.0  
Description : Test Class for VFC_Benchmark_Old. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class VFC_Benchmark_OldTest{
    static User testUser; 
    static Client_Master__c clientName;
    static Client_Master__c clientName1;
    static Client_Master__c clientName2;
    static Client_Geo_Area_Master__c clientGeoArea;
    static Operating_Group_Master__c operatingGroup;
    static Client_Geo_Unit_Master__c clientGeoUnit;
    static Opportunity_TGP__c oppTGP;
    static Opportunity_TGP__c oppTGP1;
    static Opportunity_TGP__c oppTGP2;
    static Opportunity_Benchmark_Data__c oppBenchmarkDataRecord;
    static Opportunity_Benchmark_Data__c oppBenchmarkDataRecord1; 
    static Opportunity_Benchmark_Data__c oppBenchmarkDataRecord2;  
    
    static Benchmark_Offering__c    benchmarkOffering;
    static Benchmark_Offering__c    benchmarkOffering1;
    static Benchmark_Offering__c    benchmarkOffering2;
    
    static Opportunity_Offering_BenchMark_Data__c    oppOfferingBenchMarkData;
    static Opportunity_Offering_BenchMark_Data__c    oppOfferingBenchMarkData1;
    static Opportunity_Offering_BenchMark_Data__c    oppOfferingBenchMarkData2;
        
    static  List<selectOption> selectOptionList;
   
    public static void setupData(){
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
        insert clientName;
        clientName1 = new Client_Master__c (Name = 'TestObject2',Active__c = true);
        insert clientName1;
        clientName2 = new Client_Master__c (Name = 'TestObject3',Active__c = true);
        insert clientName2;
          
        clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
        insert clientGeoArea;
         
        operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
        insert operatingGroup;
          
        clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
        insert clientGeoUnit;
        
        oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                      Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                      Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
        insert oppTGP; 
        oppTGP1 = new Opportunity_TGP__c(Name = 'TestIBM1',Stage__c='Stage 1',Client_Name__c= clientName1.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                      Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                      Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
        insert oppTGP1; 
        oppTGP2 = new Opportunity_TGP__c(Name = 'TestIBM2',Stage__c='Stage 1',Client_Name__c= clientName2.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                      Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                      Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
        insert oppTGP2; 
        oppBenchmarkDataRecord = new Opportunity_Benchmark_Data__c(Name = 'testBenchmark', Client__c = clientName.Id, Opportunity__c =oppTGP .Id, Active__c = True, Average_Run_Contingency__c = 20.12,
                                         
                                        BSS_Total_Cost__c = 1234569, CFM_Total_Cost__c = 321654, CI__c = 12.62, CM_Total_Cost__c = 56239, Command_Center_Total_Cost__c = 1234,
                                        Contract_End_Date__c = Date.newInstance(2015,08,01),
                                        Contract_Start_Date__c = Date.newInstance(2014,08,01), Deal_Data_Tables_Updated__c = True, Deal_Unlocked__c = True,
                                        Delivery_Locations__c = 'three', Electronic_Doc_Management_Total_Cost__c = 65000, Grand_Total_Cost__c = 123,
                                        Include_in_BenchMark_Report__c = True, Initial_Go_Live__c = Date.newInstance(2015,08,01), Languages__c = '8', no_of_languages__c = '3+', Mobilization_Contingency__c = 56,
                                        Mobilization_Total_Cost__c = 125, Multi_Single_Offering__c = 'Multiple', Nearshore_Baseline_FTEs__c = 569,  No_of_Locations__c = 3,
                                        OADM_Total_Cost__c = 123965,
                                        Offshore_Baseline_FTEs__c = 123,  Onshore_Baseline_FTEs__c = 985,
                                        PMO_Total_Cost__c = 9586, Pyramid_Richness_Year1__c = 55,
                                        QAD_Total_Cost__c   = 4568, SAP_OM_ID__c = '101154', Scenario__c = 'Hello Scene', SDO_Total_Cost__c = 5698,
                                        Service_Management_Total_Cost__c = 1562, SSM_Version__c = 'version 2', Support_Center_Total_Cost__c = 5689,
                                        Technology_Tools_Total_Cost__c = 78954, Technology_Total_Cost__c = 78459, TOTAL_Baseline_SDO_FTEs__c = 4562.32,
                                        Transformation_Costs_consulting__c = 4589, Version__c = '8', Voice_and_Data_Total_Cost__c = 1234);
        oppBenchmarkDataRecord1 = new Opportunity_Benchmark_Data__c(Name = 'testBenchmark1', Client__c = clientName1.Id, Opportunity__c =oppTGP1.Id,Active__c = True, Average_Run_Contingency__c = 20.12,  
                                         
                                        
                                        BSS_Total_Cost__c = 1234569, CFM_Total_Cost__c = 321654, CI__c = 12.62, CM_Total_Cost__c = 56239, Command_Center_Total_Cost__c = 1234,
                                        Contract_End_Date__c = Date.newInstance(2015,08,01),
                                        Contract_Start_Date__c = Date.newInstance(2014,08,01), Deal_Data_Tables_Updated__c = True, Deal_Unlocked__c = True,
                                        Delivery_Locations__c = 'three', Electronic_Doc_Management_Total_Cost__c = 65000, Grand_Total_Cost__c = 123,
                                        Include_in_BenchMark_Report__c = True, Initial_Go_Live__c = Date.newInstance(2015,08,01), Languages__c = '8', no_of_languages__c = '3+', Mobilization_Contingency__c = 56,
                                        Mobilization_Total_Cost__c = 125, Multi_Single_Offering__c = 'Multiple', Nearshore_Baseline_FTEs__c = 569,  No_of_Locations__c = 3,
                                        OADM_Total_Cost__c = 123965,
                                        Offshore_Baseline_FTEs__c = 123, Onshore_Baseline_FTEs__c = 985,
                                        PMO_Total_Cost__c = 9586, Pyramid_Richness_Year1__c = 55,
                                        QAD_Total_Cost__c   = 4568, SAP_OM_ID__c = '101154', Scenario__c = 'Hello Scene', SDO_Total_Cost__c = 5698,
                                        Service_Management_Total_Cost__c = 1562, SSM_Version__c = 'version 2', Support_Center_Total_Cost__c = 5689,
                                        Technology_Tools_Total_Cost__c = 78954, Technology_Total_Cost__c = 78459,  TOTAL_Baseline_SDO_FTEs__c = 4562.32,
                                        Transformation_Costs_consulting__c = 4589, Version__c = '8', Voice_and_Data_Total_Cost__c = 1234);
        oppBenchmarkDataRecord2 = new Opportunity_Benchmark_Data__c(Name = 'testBenchmark2', Client__c = clientName2.Id, Opportunity__c =oppTGP2.Id, Active__c = True, Average_Run_Contingency__c = 20.12,  
                                         
                                        
                                        BSS_Total_Cost__c = 1234569, CFM_Total_Cost__c = 321654, CI__c = 12.62, CM_Total_Cost__c = 56239, Command_Center_Total_Cost__c = 1234,
                                        Contract_End_Date__c = Date.newInstance(2015,08,01),
                                        Contract_Start_Date__c = Date.newInstance(2014,08,01), Deal_Data_Tables_Updated__c = True, Deal_Unlocked__c = True, 
                                        Delivery_Locations__c = 'three', Electronic_Doc_Management_Total_Cost__c = 65000, Grand_Total_Cost__c = 123,
                                        Include_in_BenchMark_Report__c = True, Initial_Go_Live__c = Date.newInstance(2015,08,01), Languages__c = '8', no_of_languages__c = '3+', Mobilization_Contingency__c = 56,
                                        Mobilization_Total_Cost__c = 125, Multi_Single_Offering__c = 'Multiple', Nearshore_Baseline_FTEs__c = 569,  No_of_Locations__c = 3,
                                        OADM_Total_Cost__c = 123965,
                                        Offshore_Baseline_FTEs__c = 123, Onshore_Baseline_FTEs__c = 985,
                                        PMO_Total_Cost__c = 9586, Pyramid_Richness_Year1__c = 55,
                                        QAD_Total_Cost__c   = 4568, SAP_OM_ID__c = '101154', Scenario__c = 'Hello Scene', SDO_Total_Cost__c = 5698,
                                        Service_Management_Total_Cost__c = 1562, SSM_Version__c = 'version 2', Support_Center_Total_Cost__c = 5689,
                                        Technology_Tools_Total_Cost__c = 78954, Technology_Total_Cost__c = 78459,  TOTAL_Baseline_SDO_FTEs__c = 4562.32,
                                        Transformation_Costs_consulting__c = 4589, Version__c = '8', Voice_and_Data_Total_Cost__c = 1234);                                
        insert oppBenchmarkDataRecord;
        insert oppBenchmarkDataRecord1;
        insert oppBenchmarkDataRecord2;
        
        benchmarkOffering = new Benchmark_Offering__c(Name='Human Resources',Opportunity_Benchmark_Data__c=oppBenchmarkDataRecord.Id);
        benchmarkOffering1 = new Benchmark_Offering__c(Name='Human Resources',Opportunity_Benchmark_Data__c=oppBenchmarkDataRecord1.Id);
        benchmarkOffering2 = new Benchmark_Offering__c(Name='Human Resources',Opportunity_Benchmark_Data__c=oppBenchmarkDataRecord2.Id);
        
        insert benchmarkOffering;
        insert benchmarkOffering1;
        insert benchmarkOffering2;
        
        oppOfferingBenchMarkData = new Opportunity_Offering_BenchMark_Data__c(No_of_Contractors__c=3,No_of_Employees__c=3,No_of_Headcounts__c=3,Active__c=true,Average_of_FTE_Type__c=4,Average_of_Location_Definition__c=2,Average_of_Pyramid_Richness_Year_1__c=2,Costing_Type__c='SDO',Count_of_Language__c=3,Nearshore_Baseline_FTEs__c=4,Offshore_Baseline_FTEs__c=4,Onshore_Baseline_FTEs__c=4,Sub_Service_Offering__c='Human Resource',Service__c='Payroll',Sum_of_Average_FTEs__c=5,Sum_of_Baseline_FTEs__c=6,Sum_of_Final_Month_FTE__c=6,Sum_of_Total_Cost__c=100,Opportunity_BenchMark_Data__c=oppBenchmarkDataRecord.Id,Benchmark_Offering__c=benchmarkOffering.Id);
        oppOfferingBenchMarkData1 = new Opportunity_Offering_BenchMark_Data__c(No_of_Contractors__c=3,No_of_Employees__c=3,No_of_Headcounts__c=3,Active__c=true,Average_of_FTE_Type__c=4,Average_of_Location_Definition__c=2,Average_of_Pyramid_Richness_Year_1__c=2,Costing_Type__c='SDO',Count_of_Language__c=3,Nearshore_Baseline_FTEs__c=4,Offshore_Baseline_FTEs__c=4,Onshore_Baseline_FTEs__c=4,Sub_Service_Offering__c='Human Resource',Service__c='Payroll',Sum_of_Average_FTEs__c=5,Sum_of_Baseline_FTEs__c=6,Sum_of_Final_Month_FTE__c=6,Sum_of_Total_Cost__c=100,Opportunity_BenchMark_Data__c=oppBenchmarkDataRecord1.Id,Benchmark_Offering__c=benchmarkOffering1.Id);
        oppOfferingBenchMarkData2 = new Opportunity_Offering_BenchMark_Data__c(No_of_Contractors__c=3,No_of_Employees__c=3,No_of_Headcounts__c=3,Active__c=true,Average_of_FTE_Type__c=4,Average_of_Location_Definition__c=2,Average_of_Pyramid_Richness_Year_1__c=2,Costing_Type__c='SDO',Count_of_Language__c=3,Nearshore_Baseline_FTEs__c=4,Offshore_Baseline_FTEs__c=4,Onshore_Baseline_FTEs__c=4,Sub_Service_Offering__c='Human Resource',Service__c='Payroll',Sum_of_Average_FTEs__c=5,Sum_of_Baseline_FTEs__c=6,Sum_of_Final_Month_FTE__c=6,Sum_of_Total_Cost__c=100,Opportunity_BenchMark_Data__c=oppBenchmarkDataRecord2.Id,Benchmark_Offering__c=benchmarkOffering2.Id);
                                         
        insert oppOfferingBenchMarkData;
        insert oppOfferingBenchMarkData1;
        insert oppOfferingBenchMarkData2;    
    }
    
    static testMethod void testSelectOptionMethods(){
        setupData();
        VFC_Benchmark_Old VFCbenchmarkInstance =  new VFC_Benchmark_Old();
        selectOptionList = VFCbenchmarkInstance.getFirstBunchOfClientNames();
        selectOptionList = VFCbenchmarkInstance.getListOfOpportunities();
        selectOptionList = VFCbenchmarkInstance.getListOfGeoRegion();
        selectOptionList = VFCbenchmarkInstance.getListOfOffering();
        selectOptionList = VFCbenchmarkInstance.getListOfOperatingGroup();
        selectOptionList = VFCbenchmarkInstance.getListOfFTERange();
        selectOptionList = VFCbenchmarkInstance.getListOfReportingStatus();
        selectOptionList = VFCbenchmarkInstance.getListOfDeliveryLocation();
        selectOptionList = VFCbenchmarkInstance.getListOfMultiSingleOffering();
        selectOptionList = VFCbenchmarkInstance.getListOfBPONetRevenueRange();
        selectOptionList = VFCbenchmarkInstance.getListOfNoOfLanguages();     
    }
    static testMethod void testSearchResults(){
        setupData();
        VFC_Benchmark_Old VFCbenchmarkInstance =  new VFC_Benchmark_Old();   
        VFC_Benchmark_Old.averageBnechmarkRecordWrapper abc = new VFC_Benchmark_Old.averageBnechmarkRecordWrapper();
        VFC_Benchmark_Old.OpportunityDataWrapperDisplay def = new VFC_Benchmark_Old.OpportunityDataWrapperDisplay();
          
        VFCbenchmarkInstance.selectedOpportunity = 'None';
        VFCbenchmarkInstance.selectedClientName = 'None';
        
        VFCbenchmarkInstance.OfferingCountMap=new Map<id,decimal>();
        
        
        
        VFCbenchmarkInstance.searchResults();
        VFCbenchmarkInstance.selectedOpportunity = oppTGP.Id;
        VFCbenchmarkInstance.selectedClientName = clientName.Id;
        
        VFCbenchmarkInstance.OfferingCountMap.put(oppBenchmarkDataRecord.Opportunity__c,oppBenchmarkDataRecord.Offerring_Count__c);
        
        VFCbenchmarkInstance.searchResults(); 
        VFCbenchmarkInstance.searchOpportunities();
        VFCbenchmarkInstance.resetPage();
        
        VFCbenchmarkInstance.selectedOffering='None';
        
        VFCbenchmarkInstance.searchAdvanceResult();
        VFCbenchmarkInstance.exportAll();
        
        
        
        //Pagination Method Test
        VFCbenchmarkInstance.Beginning();
        VFCbenchmarkInstance.Previous();
        VFCbenchmarkInstance.Next();
        VFCbenchmarkInstance.End();
        VFCbenchmarkInstance.getDisablePrevious();
        VFCbenchmarkInstance.getDisableNext();
        VFCbenchmarkInstance.getTotal_size();
        VFCbenchmarkInstance.getPageNumber();
        VFCbenchmarkInstance.getTotalPages(); 
        
        VFCbenchmarkInstance.selectedGeoRegion = clientGeoArea.Id;
        VFCbenchmarkInstance.selectedOperatingGroup = operatingGroup.id;
        VFCbenchmarkInstance.selectedFteRange = '>400';
        VFCbenchmarkInstance.selectedReportingStatus = '1-Active';
        VFCbenchmarkInstance.selectedDeliveryLocation = 'Onshore';
        VFCbenchmarkInstance.selectedBPONetRevenueRange = 'Mega (100M+)';
        VFCbenchmarkInstance.selectedMultiSingleOffering = 'Multiple';
        VFCbenchmarkInstance.selectedNoOfLanguage = '3+';
        VFCbenchmarkInstance.selectedOffering = 'None';
        VFCbenchmarkInstance.OfferingCountMap=new Map<id,decimal>();     
        //VFCbenchmarkInstance.searchAdvanceResult();           
    }
    
    static testMethod void testSearchResultsOffering(){
        setupData();
        VFC_Benchmark_Old VFCbenchmarkInstance =  new VFC_Benchmark_Old();   
        VFC_Benchmark_Old.averageBnechmarkRecordWrapper abc = new VFC_Benchmark_Old.averageBnechmarkRecordWrapper();
        VFC_Benchmark_Old.OpportunityDataWrapperDisplay def = new VFC_Benchmark_Old.OpportunityDataWrapperDisplay();
          
        VFCbenchmarkInstance.selectedOpportunity = 'None';
        VFCbenchmarkInstance.selectedClientName = 'None';
        VFCbenchmarkInstance.searchResults();
        VFCbenchmarkInstance.selectedOpportunity = oppTGP.Id;
        VFCbenchmarkInstance.selectedClientName = clientName.Id;
        VFCbenchmarkInstance.selectedOffering='Human Resources';
        
        VFCbenchmarkInstance.OfferingCountMap=new Map<id,decimal>();
        
        VFCbenchmarkInstance.searchAdvanceResult();
        VFCbenchmarkInstance.exportAll();
        
    }
}