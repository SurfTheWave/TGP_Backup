/**
 * Batch_UTIL_MobUserAssignmentDataManager
 */
@isTest
private class Batch_UTIL_MobUserAssignDataManagerTest {

   	public User solUser1, solUser2, solUser3;
    public MOB_User_Role_Assignment__c mob1,mob2,mob3;
    private static string USER_NAME_1 = 'v92@testorg.com';
    private static string USER_NAME_2 = 'v99@testorg.com';
    private static string USER_NAME_3 = 'v94@testorg.com';
    
    private void testDataCreation() {
    	Profile solProfile = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        solUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(solProfile,USER_NAME_1);
        solUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(solProfile,USER_NAME_2);
        solUser3 = UTIL_DataCreationForTestClass.getUserWithProfile(solProfile,USER_NAME_3);
        Database.insert(new User[]{solUser1, solUser2,solUser3},false);
        
        mob1 = UTIL_DataCreationForTestClass.getMobUserRoleAssignment();
        mob1.User_Assigned__c=solUser1.Id;
        mob2 = UTIL_DataCreationForTestClass.getMobUserRoleAssignment();
        mob2.User_Assigned__c=solUser2.Id;
        mob3 = UTIL_DataCreationForTestClass.getMobUserRoleAssignment();
        mob3.User_Assigned__c=solUser3.Id;
        Database.insert(new MOB_User_Role_Assignment__c[]{mob1, mob2,mob3},false);
        
    }
    
    static testMethod void myUnitTest() {
        Batch_UTIL_MobUserAssignDataManagerTest testController = new Batch_UTIL_MobUserAssignDataManagerTest();
        testController.testDataCreation();
        Test.startTest();
            system.runAs(testController.solUser1) {
            	Id jobId = Database.executeBatch(new Batch_UTIL_MobUserAssignmentDataManager(), 10); 
            	system.assert(jobId!=null);
            }
        Test.stopTest();
    }
}