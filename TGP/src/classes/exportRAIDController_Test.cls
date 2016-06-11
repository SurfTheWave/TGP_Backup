/*
  @Author: 
  @Name: exportRAIDController_Test 
  @Created Date: 01 January 2015
  @Description: This is a test class for for exporting RAIDController.
  @version: 1.0
*/
@isTest
private class exportRAIDController_Test {
    private static List<Export_Fields__c> fieldsList;
    private static User testUser;
    private static Wave__c wave; 
/*
  @Author: 
  @Name: setupData
  @Created Date: 01 January 2015
  @Description: This is a method for Data setup.
  @version: 1.0
*/
    public static void setupData(){
        //UtilConstants uc = new UtilConstants();        
        Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Admin);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false); 
        Export_Fields__c strExportFields = new Export_Fields__c(Name = 'test Export fields', Object_Name__c = 'KT_Trac__c',fields_Name__c ='Name', Field_Label_Name__c = 'test Field Label', Tracking_on_off__c = true);        
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
  @Author: 
  @Name: myUnitTest
  @Created Date: 01 January 2015
  @Description: This is a test method for Unit testing pupose.
  @version: 1.0
*/
    static testMethod void myUnitTest() {
        //system.runAs(testUser);
        setupData();
        Test.startTest();
        PageReference pageRef= Page.ExportRAIDExcel_VFP;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('recordId', Wave.id);
        pageRef.getParameters().put('objName', 'KT_Trac__c');   
        ExportRAIDController newExportRAID = new ExportRAIDController();
        newExportRAID.exportToExcel();
        test.stopTest();
    }
}