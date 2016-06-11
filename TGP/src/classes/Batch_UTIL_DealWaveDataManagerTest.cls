/**
 * Batch_UTIL_DealWaveDataManager
 */
@isTest
private class Batch_UTIL_DealWaveDataManagerTest {

   	public User solUser1, solUser2, solUser3;
   	public Deal_Location__c dealLoc1,dealLoc2,dealLoc3;
    public Deal_Home_Location__c dealHome1,dealHome2,dealHome3;
    public Deal_TGP__c deal1, deal2, deal3;
    public Wave_Plan_Version__c wavePlanVersion1, wavePlanVersion2, wavePlanVersion3;
    public Client_Geo_Area_Master__c clientGeoAreaMaster;
    public Delievery_Location_Master__c delLocMAster;
    public Wave_Planning__c wp1, wp2, wp3;
    private static string USER_NAME_1 = 'v92@testorg.com';
    private static string USER_NAME_2 = 'v99@testorg.com';
    private static string USER_NAME_3 = 'v94@testorg.com';
    
    private void testDataCreation() {
    	Profile solProfile = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        solUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(solProfile,USER_NAME_1);
        solUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(solProfile,USER_NAME_2);
        solUser3 = UTIL_DataCreationForTestClass.getUserWithProfile(solProfile,USER_NAME_3);
        Database.insert(new User[]{solUser1, solUser2,solUser3},false);
        
        deal1=UTIL_DataCreationForTestClass.getDealRecord('deal', solUser1.Id);
        deal2=UTIL_DataCreationForTestClass.getDealRecord('deal2', solUser2.Id);
        deal3=UTIL_DataCreationForTestClass.getDealRecord('deal2', solUser3.Id);
		wavePlanVersion1 =new Wave_Plan_Version__c(Display_tracking_message__c='Tracking is Off',Deal__c=deal1.Id); 
		wavePlanVersion2 =new Wave_Plan_Version__c(Display_tracking_message__c='Tracking is Off',Deal__c=deal2.Id);
		wavePlanVersion3 =new Wave_Plan_Version__c(Display_tracking_message__c='Tracking is Off',Deal__c=deal3.Id);
		clientGeoAreaMaster=UTIL_DataCreationForTestClass.getClientGEOAreaMaster('testGeo1');
		delLocMAster=UTIL_DataCreationForTestClass.getDelieveryLocationMaster('test',clientGeoAreaMaster.Id);   
		
		dealHome1=UTIL_DataCreationForTestClass.getDealHomeLocation(delLocMAster.Id,deal1.Id);
		dealHome2=UTIL_DataCreationForTestClass.getDealHomeLocation(delLocMAster.Id,deal2.Id);    
		dealHome3=UTIL_DataCreationForTestClass.getDealHomeLocation(delLocMAster.Id,deal3.Id);
        
        dealLoc1 = UTIL_DataCreationForTestClass.getDealLocation('dealL1', dealHome1.Id,wavePlanVersion1.Id);
        dealLoc2 = UTIL_DataCreationForTestClass.getDealLocation('dealc', dealHome2.Id,wavePlanVersion2.Id);
        dealLoc3 = UTIL_DataCreationForTestClass.getDealLocation('dealoc', dealHome3.id,wavePlanVersion3.Id);
        Database.insert(new Deal_Location__c[]{dealLoc1, dealLoc2,dealLoc3},false);
        
        Date d= System.today();
        wp1 = UTIL_DataCreationForTestClass.getWavePlanning(dealLoc1.Id,d,'test12');
        wp1.KT_Lead__c=solUser1.Id;
        wp2 = UTIL_DataCreationForTestClass.getWavePlanning(dealLoc2.Id,d,'test122');
        wp2.KT_Lead__c=solUser2.Id;
        wp3 = UTIL_DataCreationForTestClass.getWavePlanning(dealLoc3.Id,d,'test1223');
        wp3.KT_Lead__c=solUser3.Id;
        Database.insert(new Wave_Planning__c[]{wp1,wp2,wp3},false);
        
    }
    
    static testMethod void myUnitTest() {
        Batch_UTIL_DealWaveDataManagerTest testController = new Batch_UTIL_DealWaveDataManagerTest();
        testController.testDataCreation();
        Test.startTest();
            system.runAs(testController.solUser1) {
            	Id jobId = Database.executeBatch(new Batch_UTIL_DealWaveDataManager(), 10); 
            	system.assert(jobId!=null);
            }
        Test.stopTest();
    }
}