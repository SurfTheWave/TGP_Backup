/**
 * Name : ExportProcTrackerController_VF_Nova_Test
 * Author : NovaCop Unit Test Generator
 * Description : Test class used for testing the ExportProcTrackerController_VFC
 * Date : 3/18/15 6:19 PM 
 * Version : <intial Draft> 
 * TODO : This code is auto-generated. Developer should update the inputs for unit tests as well as expected results in assertions
 */
@isTest
private class ExportProcTrackerController_VF_Nova_Test { 

    private static User testUser;
    private static Wave__c wave; 
    /******************************
    Method Name: setupData
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public static void setupData(){
        Profile profileName = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(profileName,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);

        Export_Fields__c strExportFields = new Export_Fields__c(Name = 'test Export fields', Object_Name__c = 'Procurement_Wave_Region__c',fields_Name__c ='Name', Field_Label_Name__c = 'test Field Label', Tracking_on_off__c = true);        
        insert strExportFields; 
        Deal__c deal=new Deal__c(Name='Testdeal');
        insert deal;
        Mobilization_Plan__c mobPlan=new Mobilization_Plan__c(Name ='planTest123', Deal__c = deal.id,IsTrackingOn__c = True,Active__c=True);
        insert mobPlan;
        wave=new Wave__c(Name='testWave',Mobilization_Plan__c=mobPlan.id,Active__c=True);
        insert wave;
        Procurement_Wave_Region__c procurement=new Procurement_Wave_Region__c(Name='Proc test',Active__c=True,Wave__c=wave.id);
        insert procurement;
    }    
    /******************************
    Method Name: testExportToCSV_Scenario1
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
     static testMethod void  testExportToCSV_Scenario1(){ 
    Test.startTest();
        setupData();
        ExportProcTrackerController_VFC exportTracker = new  ExportProcTrackerController_VFC();       
        PageReference tpageRef = Page.ExportProcTrackersCSV_VFP;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('recordId', Wave.id);
        tpageRef.getParameters().put('objName', 'Procurement_Wave_Region__c');        
        exportTracker.exportToCSV();
        Test.stopTest();      
       
        }
}