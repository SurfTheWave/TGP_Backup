/*
    @Author     : 
    @name :         BudgetCostExport_Test 
    @CreateDate :   4/7/2015 3:03 AM
    @Description :  Test class for Util import tracker page functionality testing
    @Version : 
*/
@isTest
private class UtilImportTrackers_VFC_Test{
    private static UtilImportTrackers_VFC ext;
    private static PageReference pref;
    private static User testUser;
    private static Wave__c wave;
    private static KT_Trac__c ktracker;
    /*    
    @Name :         setupData
    @Description :  Test data setup for required data details 
    */
    static void setupData(){
        Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        Deal__c deal=new Deal__c(Name='Testdeal');
        insert deal;
        Mobilization_Plan__c mobPlan=new Mobilization_Plan__c(Name =UtilConstants.TEST, Deal__c = deal.id,IsTrackingOn__c = True,Active__c=True);
        insert mobPlan;
        wave=new Wave__c(Name=UtilConstants.TEST, Mobilization_Plan__c=mobPlan.id,Active__c=True);
        insert wave;
        ktracker=new KT_Trac__c(Name=UtilConstants.TEST,Active__c=True,Wave__c=wave.id);
        insert ktracker;
    }
    /*    
    @name :         Test1    
    @Description :  Test class for Util import tracker page functionality testing    
    */    
    static testMethod void Test1() {
        Test.startTest();
        setupData();
        ext = new UtilImportTrackers_VFC();
        PageReference tpageRef = Page.Import_Browse_VFP;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put(UtilConstants.REC_ID, Wave.id);
        tpageRef.getParameters().put(UtilConstants.OBJECT_NAME, UtilConstants.KT_TRAC); 
        ext.BlobFile = Blob.valueOf('Id,Name,Wave__r.name,Completion_Status__c,Actual_Start_Date__c,Actual_End_Date__c,Active__c,Milestone__c,Tracking_Comments__c\n'+ktracker.id+',Knowledge Transfer Plan11,"Wave 1",,10/12/2015,,true,false,test\r\n');
        pref = ext.processingFile();            
        pref = ext.cancel();
        UtilImportTrackers_VFC.addError('CustomError');
        Test.stopTest();
    }
}