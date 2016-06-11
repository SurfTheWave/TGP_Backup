@isTest
private class UserWelcomeConroller_Test {

    private static User testUser;
    static testMethod void test1(){
    
    Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        
        Test.StartTest();
       System.runAs(testUser) {
        UserWelcomeConroller userWC = new UserWelcomeConroller();
        userWC.userLogin();
       }
        
        Test.stopTest();
    
    }

}