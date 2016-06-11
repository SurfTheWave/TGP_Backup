/*
Author : Accenture Team
Story  : UserTriggerControllerTest
Description : Test Class for UserTriggerController

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/

@istest
private class UserTrigerControllerTest {
    
    static User testUser;
    static User userRecord;
    public static final string User_Name =  'vc123@testorg.com';
    static Review_User_Master__c reviewUserMaster;
    static List<Id> userIdList =  new List<Id>();
    
    public static void SetupData()
    {
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        insert testUser;
    
        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);        
        userRecord = UTIL_DataCreationForTestClass.getUserWithProfile(p,User_Name);       
        insert userRecord;      
        userIdList.add(userRecord.Id);
        
        reviewUserMaster = new Review_User_Master__c();
        reviewUserMaster.SFDC_User__c= userRecord.Id;
        reviewUserMaster.Name = userRecord.Name;
        reviewUserMaster.UserName__c = userRecord.UserName;
        reviewUserMaster.User_Type__c = userRecord.User_Type__c;
        reviewUserMaster.IsUserActive__c = userRecord.IsActive;
        reviewUserMaster.Email_ID_of_the_reviewer__c =  userRecord.Email;
        insert reviewUserMaster;       
    }
    
    
    static testMethod void testDynamicReportCreation()
    {
        test.starttest();
        SetupData();
        UserTriggerController.insertUpdateApprovalUserMaster(userIdList);  
        UserTriggerController.updateApprovalUserMaster(userIdList);      
        test.stoptest();

         
    }

}