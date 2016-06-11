@isTest
private class updateGEOregionTest{

    static testMethod void testupdateGEOregionTest(){
    
        test.starttest();
        
        Client_Geo_Area_Master__c ClientGeoAreaMasterObj = UTIL_DataCreationForTestClass.getClientGEOAreaMaster('Latin America');
        insert ClientGeoAreaMasterObj;
        
        Client_Geo_Area_Master__c ClientGeoAreaMasterObjNew = UTIL_DataCreationForTestClass.getClientGEOAreaMaster(UTIL_Constants.AsiaPacific);
        insert ClientGeoAreaMasterObjNew;
        
        Pipeline_Trend_Report__c pipelineObj = new Pipeline_Trend_Report__c();
        pipelineObj.Geo_Region__c = 'Latin America';
        pipelineObj.All_Deals__c = 1;
        pipelineObj.All_TCV__c = 1;
        pipelineObj.SD_Deals__c = 1;
        pipelineObj.SD_TCV__c = 1;
        //pipelineObj.Snapshot_Date__c = system.today();

        insert pipelineObj;
        
        pipelineObj.Geo_Region__c = UTIL_Constants.AsiaPacific;
        
        update pipelineObj;
        
        Test.stoptest(); 
        
    
    }

}