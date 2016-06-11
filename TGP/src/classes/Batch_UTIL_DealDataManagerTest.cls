/**
 * Batch_UTIL_DealDataManager
 */
@isTest
private class Batch_UTIL_DealDataManagerTest {

   	public User solUser1, solUser2, solUser3;
    public Deal_TGP__c deal1,deal2,deal3;
    private static string USER_NAME_1 = 'v92@testorg.com';
    private static string USER_NAME_2 = 'v99@testorg.com';
    private static string USER_NAME_3 = 'v94@testorg.com';
    
    private void testDataCreation() {
    	Profile solProfile = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        solUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(solProfile,USER_NAME_1);
        solUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(solProfile,USER_NAME_2);
        solUser3 = UTIL_DataCreationForTestClass.getUserWithProfile(solProfile,USER_NAME_3);
        Database.insert(new User[]{solUser1, solUser2,solUser3},false);
        
        deal1 = UTIL_DataCreationForTestClass.getDealRecord('deal1', solUser1.Id);
        deal2 = UTIL_DataCreationForTestClass.getDealRecord('deal2', solUser2.Id);
        deal3 = UTIL_DataCreationForTestClass.getDealRecord('deal3', solUser3.id);
        Database.insert(new Deal_TGP__c[]{deal1, deal2,deal3},false);
        
    }
    
    static testMethod void myUnitTest() {
        Batch_UTIL_DealDataManagerTest testController = new Batch_UTIL_DealDataManagerTest();
        testController.testDataCreation();
        Test.startTest();
            system.runAs(testController.solUser1) {
            	Id jobId = Database.executeBatch(new Batch_UTIL_DealDataManager(), 10); 
            	system.assert(jobId!=null);
            }
        Test.stopTest();
    }
}