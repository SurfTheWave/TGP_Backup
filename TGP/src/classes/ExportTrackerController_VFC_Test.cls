/**
   @Author : 
   @name   : ExportTrackerController_VFCTest 
   @CreateDate :  
   @Description : Test Class for ExportTrackerController_VFC
   @Version : 1.0 
  */
  @isTest
private class ExportTrackerController_VFC_Test {
    
    private static List<Export_Fields__c> fieldsList;
    private static User testUser;
    private static Wave__c wave;           
    private static final String REC_ID ='recordId';  
/*    
    @Name :         setupData
    @Description :  Test data setup for required data details 
*/         
    public static void setupData(){
        Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        Export_Fields__c strExportFields = new Export_Fields__c(Name = 'test Export fields', Object_Name__c = 'KT_Trac__c',fields_Name__c ='Name,Active__c', Field_Label_Name__c = 'test Field Label', Tracking_on_off__c = true);        
        insert strExportFields;
        fieldsList=new List<Export_Fields__c>();
        fieldsList.add(strExportFields);
        
        Deal__c deal=new Deal__c(Name='Testdeal');
        insert deal;
        Mobilization_Plan__c mobPlan=new Mobilization_Plan__c(Name ='planTest123', Deal__c = deal.id,IsTrackingOn__c = True,Active__c=True);
        insert mobPlan;
        wave=new Wave__c(Name='testWave',Mobilization_Plan__c=mobPlan.id,Active__c=True);
        insert wave;
        KT_Trac__c ktracker=new KT_Trac__c(Name='kt test',Active__c=True,Wave__c=wave.id);
        insert ktracker;
    }  
/*    
    @Name :         setupData1
    @Description :  inserting test data with all the mandatory fields
*/ 
    public static void setupData1(){
        Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        Export_Fields__c strExportFields = new Export_Fields__c(Name = 'test Export fields', Object_Name__c = 'KT_Trac__c',fields_Name__c ='Name', Field_Label_Name__c = 'test Field Label', Tracking_on_off__c = true);        
        insert strExportFields;
        fieldsList=new List<Export_Fields__c>();
        fieldsList.add(strExportFields);
    Export_Fields__c strExportFields1 = new Export_Fields__c(Name = 'test Export fields', Object_Name__c = 'KT_Trac__c',fields_Name__c =',Active__c', Field_Label_Name__c = 'test Field Label', Tracking_on_off__c = true);        
        insert strExportFields1;         
        fieldsList.add(strExportFields1);
        Deal__c deal=new Deal__c(Name='Testdeal');
        insert deal;
        Mobilization_Plan__c mobPlan=new Mobilization_Plan__c(Name ='planTest123', Deal__c = deal.id,IsTrackingOn__c = True,Active__c=True);
        insert mobPlan;
        wave=new Wave__c(Name='testWave',Mobilization_Plan__c=mobPlan.id,Active__c=True);
        insert wave;
        KT_Trac__c ktracker=new KT_Trac__c(Name='kt test',Active__c=True,Wave__c=wave.id);
        insert ktracker;
    } 
/*    
    @Name :         testExportToCSV_Scenario1
    @Description :  inserting test data with all the mandatory fields
*/   
    static testMethod void testExportToCSV_Scenario1(){
        Test.startTest();
        setupData();
        ExportTrackerController_VFC exportTracker = new ExportTrackerController_VFC();        
        PageReference tpageRef = Page.ExportTrackersCSV_VFP;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('recordId', Wave.id);
        tpageRef.getParameters().put('objName', 'KT_Trac__c');        
        exportTracker.exportToCSV();
        Test.stopTest();        
    }
/*    
    @Name :         testExportToCSV_Scenario2
    @Description :  inserting test data with all the mandatory fields
*/
     static testMethod void testExportToCSV_Scenario2(){
        Test.startTest();
        setupData1();
        ExportTrackerController_VFC exportTracker = new ExportTrackerController_VFC();        
        PageReference tpageRef = Page.ExportTrackersCSV_VFP;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('recordId', Wave.id);
        tpageRef.getParameters().put('objName', 'KT_Trac__c');        
        exportTracker.exportToCSV();
        Test.stopTest();        
    }
}