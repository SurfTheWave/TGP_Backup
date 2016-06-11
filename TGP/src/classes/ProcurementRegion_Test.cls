/*
@Author and Created Date : Suresh ,  4/2/2015 2:47 AM
@name : ProcurementRegion_Test
@Description : 
@Version : 
*/
@isTest
private class ProcurementRegion_Test{
    /******************************
    Method Name: createRegionWiseTest
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/  
    static testMethod void createRegionWiseTest(){  
        UTIL_DataCreationForTestClass utilObj = new UTIL_DataCreationForTestClass();
        User testUser = utilObj.createTestUser('test user 1','test.user.1@example.com','test.1@example.com');
        System.runAs(testUser){
            Test.startTest();
            //Creating Procurement Master test data           
            Procurement_Region_Wise_Activity_Master__c procMaster = new Procurement_Region_Wise_Activity_Master__c(Name = 'test Procurment Master', Activity_Description__c = 'test Desc', Activity_Order__c = 2, Type__c = 'Client spend owner plan', Active__c = True);
            insert procMaster;
            UtilConstants uc = new UtilConstants(); 
            //creating Deal test data
            Deal__c strDeal = new Deal__c(Name='DealTest123');
            insert strDeal;
            //inserting New Plan under Deal.
            Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = strDeal.id, Active__c = True);
            insert strmobplan;
            //Inserting new Wave        
            Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today());
            insert strWave;
            List<Procurement_Wave_Region__c> procLst = new List<Procurement_Wave_Region__c>();
            Procurement_Wave_Region__c procWaveRegion = new Procurement_Wave_Region__c(Wave__c = strWave.Id, Name = 'test Proc Wave Region', Active__c = True);
            procLst.add(procWaveRegion);
            insert procLst;
            
            List<Procurement_Region_Wise_Activity_Item__c> regionWiseList = new List<Procurement_Region_Wise_Activity_Item__c>();            
            Procurement_Region_Wise_Activity_Item__c newProcRegion = new Procurement_Region_Wise_Activity_Item__c(Name = 'test Proc Region', Active__c = True, Activity_Description__c = 'test Desc', Activity_Order__c = 2, 
                                                                            Region__c = procLst[0].Id, Type__c = 'Client spend owner plan', Wave__c = strWave.Id, Value__c = 0);
            //insert newProcRegion;
            regionWiseList.add(newProcRegion);
            insert regionWiseList;
            Test.stopTest();
        }
    }
}