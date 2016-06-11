@isTest
/*
Author : Rajdeep Bhuiya
Story  : Release 2.0  
Description : Test Class for VFC_Benchmark. 
*/
private class VFC_BenchmarkTest{
    Private static User testUser; 
    
    Private static Account clientName;
    Private static Account clientName1;
    Private static Account clientName2;
    
    Private static Operating_Groups_Master__c operatingGroup;
    
    Private static Opportunity oppTGP;
    Private static Opportunity oppTGP1;
    Private static Opportunity oppTGP2;
    
    Private static BenchMark__c oppBenchmarkDataRecord;
    Private static BenchMark__c oppBenchmarkDataRecord1; 
    Private static BenchMark__c oppBenchmarkDataRecord2;  
    
    Private static BenchMark_Offerings__c    benchmarkOffering;
    Private static BenchMark_Offerings__c    benchmarkOffering1;
    Private static BenchMark_Offerings__c    benchmarkOffering2;
    
    Private static BenchMark_Offering_Service__c    oppOfferingBenchMarkData;
    Private static BenchMark_Offering_Service__c    oppOfferingBenchMarkData1;
    Private static BenchMark_Offering_Service__c    oppOfferingBenchMarkData2;
        
    Private static  List<selectOption> selectOptionList;
   
    /******************************
    Method Name:setupData
    Description:to setup test data
    Parameters: NA
    Return Value:NA
    ******************************/
    public static void setupData(){
        Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.SYSTEM_ADMIN);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UtilConstants.USER_NAME);
        Database.insert(testUser, false);
        
        clientName = UTIL_DataCreationForTestClass.getAccountRec('TestObject1');
        insert clientName;
        clientName1 = UTIL_DataCreationForTestClass.getAccountRec('TestObject2');
        insert clientName1;
        clientName2 = UTIL_DataCreationForTestClass.getAccountRec('TestObject3');
        insert clientName2;
          
         
        operatingGroup = UTIL_DataCreationForTestClass.getOperatingGroupMasterRec(UtilConstants.TESTOPERATINGGRP,true);
        insert operatingGroup;
        
        
        Offering_Master__c offMaster=UTIL_DataCreationForTestClass.getOfferingwithALL();
        insert offMaster;   
        
        Services_Master__c service1=UTIL_DataCreationForTestClass.getBSSServiceMaster(offMaster);
        insert service1;
        
        oppTGP =UTIL_DataCreationForTestClass.getOpportunityForBenchmark(operatingGroup);
        insert oppTGP;
        
        oppTGP1 = UTIL_DataCreationForTestClass.getOpportunityForBenchmark(operatingGroup);
        insert oppTGP1; 
        
        oppTGP2 = UTIL_DataCreationForTestClass.getOpportunityForBenchmark(operatingGroup);
        insert oppTGP2; 
        
        
        oppBenchmarkDataRecord = UTIL_DataCreationForTestClass.getBenchmark(clientName,oppTGP);
        oppBenchmarkDataRecord1 = UTIL_DataCreationForTestClass.getBenchmark(clientName1,oppTGP1);
        oppBenchmarkDataRecord2 = UTIL_DataCreationForTestClass.getBenchmark(clientName2,oppTGP2);
        
        insert oppBenchmarkDataRecord;
        insert oppBenchmarkDataRecord1;
        insert oppBenchmarkDataRecord2;
        
        benchmarkOffering = UTIL_DataCreationForTestClass.getBenchmarkOffering(oppBenchmarkDataRecord);
        benchmarkOffering1 = UTIL_DataCreationForTestClass.getBenchmarkOffering(oppBenchmarkDataRecord1);
        benchmarkOffering2 = UTIL_DataCreationForTestClass.getBenchmarkOffering(oppBenchmarkDataRecord2);
        
        insert benchmarkOffering;
        insert benchmarkOffering1;
        insert benchmarkOffering2;
        
        oppOfferingBenchMarkData = UTIL_DataCreationForTestClass.getBenchmarkOfferingService(benchmarkOffering);
        oppOfferingBenchMarkData1 = UTIL_DataCreationForTestClass.getBenchmarkOfferingService(benchmarkOffering1);
        oppOfferingBenchMarkData2 = UTIL_DataCreationForTestClass.getBenchmarkOfferingService(benchmarkOffering2);
                                         
        insert oppOfferingBenchMarkData;
        insert oppOfferingBenchMarkData1;
        insert oppOfferingBenchMarkData2;   
    }
    /******************************
    Method Name:testSelectOptionMethods
    Description:to create select values
    Parameters: NA
    Return Value:NA
    ******************************/
    static testMethod void testSelectOptionMethods(){
        setupData();
        VFC_benchmark VFCbenchmarkInstance =  new VFC_benchmark();
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
    /******************************
    Method Name:testSearchResults
    Description: test method for search
    Parameters: NA
    Return Value:NA
    ******************************/
    static testMethod void testSearchResults(){
        setupData();
        VFC_benchmark VFCbenchmarkInstance =  new VFC_benchmark();   
        VFC_Benchmark.averageBnechmarkRecordWrapper abc = new VFC_Benchmark.averageBnechmarkRecordWrapper();
        VFC_Benchmark.OpportunityDataWrapperDisplay def = new VFC_Benchmark.OpportunityDataWrapperDisplay();
          
        VFCbenchmarkInstance.selectedOpportunity = 'None';
        VFCbenchmarkInstance.selectedClientName = 'None';
        
        VFCbenchmarkInstance.OfferingCountMap=new Map<id,decimal>();
        
        
        
        VFCbenchmarkInstance.searchResults();
        VFCbenchmarkInstance.selectedOpportunity = oppTGP.Id;
        VFCbenchmarkInstance.selectedClientName = clientName.Id;
        
        VFCbenchmarkInstance.OfferingCountMap.put(oppBenchmarkDataRecord.Opportunity__c,oppBenchmarkDataRecord.of_offerings_in_scope__c);
        
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
        
        VFCbenchmarkInstance.selectedGeoRegion = UTIL_Constants.AsiaPacific;
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
    /******************************
    Method Name:testSearchResultsOffering
    Description: test method for search by offering
    Parameters: NA
    Return Value:NA
    ******************************/
    static testMethod void testSearchResultsOffering(){
        setupData();
        VFC_benchmark VFCbenchmarkInstance =  new VFC_benchmark();   
        VFC_Benchmark.averageBnechmarkRecordWrapper abc = new VFC_Benchmark.averageBnechmarkRecordWrapper();
        VFC_Benchmark.OpportunityDataWrapperDisplay def = new VFC_Benchmark.OpportunityDataWrapperDisplay();
          
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