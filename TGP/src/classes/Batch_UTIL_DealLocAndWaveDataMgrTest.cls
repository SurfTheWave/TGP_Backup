/**
 * Batch_UTIL_DealLocationAndWavDataManager
 */
@isTest
private class Batch_UTIL_DealLocAndWaveDataMgrTest {

    static User solUser1, solUser2, solUser3;
    static Deal_Location__c dealLoc1,dealLoc2,dealLoc3;
     static Deal_Home_Location__c dealHome1,dealHome2,dealHome3;
    static Wave_Plan_Version__c wavePlanVersion1, wavePlanVersion2, wavePlanVersion3;
    static Deal_TGP__c deal1, deal2, deal3;
    static Client_Geo_Area_Master__c clientGeoAreaMaster;
    static Delievery_Location_Master__c delLocMAster;
    static string USER_NAME_1 = 'v92@testorg.com';
    static string USER_NAME_2 = 'v99@testorg.com';
    static string USER_NAME_3 = 'v94@testorg.com';
    
    public static void testDataCreation() {
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
        dealLoc1.Deployment_Lead__c=solUser1.Id;
        dealLoc2 = UTIL_DataCreationForTestClass.getDealLocation('dealc', dealHome2.Id,wavePlanVersion2.Id);
        dealLoc2.Deployment_Lead__c=solUser2.Id;
        dealLoc3 = UTIL_DataCreationForTestClass.getDealLocation('dealoc', dealHome3.id,wavePlanVersion3.Id);
        dealLoc3.Deployment_Lead__c=solUser3.Id;
        Database.insert(new Deal_Location__c[]{dealLoc1, dealLoc2,dealLoc3},false);
        
    }
    
    static testMethod void myUnitTest() {
        testDataCreation();
        Test.startTest();
            system.runAs(solUser1) {
                Id jobId = Database.executeBatch(new Batch_UTIL_DealLocationAndWavDataManager(), 10); 
                system.assert(jobId!=null);
            }
        Test.stopTest();
    }
}