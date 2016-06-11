@isTest
private class SratOpexScheduler_Test {
    private static List<SRAT_Additional_Tracking_Level_1__c> sratList = new List<SRAT_Additional_Tracking_Level_1__c>();
    private static List<Deal_OPEX_Additional_Tracking_Level_1__c> opexList = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
    
   private static void setupData(){ 
        SRAT_Additional_Tracking_Level_1__c srat = new SRAT_Additional_Tracking_Level_1__c();
        srat.name='Srat Test';
        srat.Question__c='Why We are running this scheduler class';
        srat.batchExecuted__c=FALSE;
        sratList.add(srat);
        insert sratList;
        Deal_OPEX_Additional_Tracking_Level_1__c opex = new Deal_OPEX_Additional_Tracking_Level_1__c();
        opex.name='Opex Test';
        opex.batchExecuted__c=FALSE;
        opexList.add(opex);
        insert opexList;
    }
    
    static testMethod void testSRATandOPEX(){
        test.startTest();
        SratOpexScheduler sh1 = new SratOpexScheduler();
        String sch = '0 0 23 * * ?'; 
        system.schedule('SratOpexScheduler_Test1', sch, sh1); 
        setupData();
        Test.stopTest(); 
    }

}