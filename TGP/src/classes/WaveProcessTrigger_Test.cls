@isTest
private class WaveProcessTrigger_Test {
    static Testmethod void test1(){
        Test.startTest();
        
        //Inserting New Deal
        Deal__c strDeal = new Deal__c(Name='DealTest123');
        insert strDeal;
        
        //inserting New Plan under Deal
        Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = strDeal.id, Active__c =True);
        insert strmobplan;
                        
        //Inserting new Wave        
        Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today());
        insert strWave;
        
        //Inserting Wave Process
        Offering_Master__c offMaster = new Offering_Master__c(Name = UtilConstants.HR,offering_description__c = UtilConstants.TEST_DESC,
        flywheel_non_flywheel__c = UtilConstants.FLYWHEEL);
        insert offMaster; 
        
        Services_Master__c serviceMaster = new Services_Master__c(Name = UtilConstants.HRSERVICE,offering__c = offMaster.id);
        insert serviceMaster;
                
        Geo_Region_Master__c geoRegion = new Geo_Region_Master__c(Name = UTIL_Constants.AsiaPacific,Active__c = true);
        insert geoRegion;
        
        Country_Master__c countryMaster = new Country_Master__c(Name='IN', Geo_Region__c = geoRegion.Id);
        insert countryMaster;
        
        Delivery_Location_Masters__c deliveryLocMaster = new Delivery_Location_Masters__c(Name = UtilConstants.BANGALORE,country__c = countryMaster.id,delivery_location_description__c = UtilConstants.TEST_DESC,active__c=true);
        insert deliveryLocMaster;
        
        Client_Specific_Process__c clientApe = new Client_Specific_Process__c(Name = 'test Client Process', Deal__c =strDeal.Id, Process_Offering__c =offMaster.Id, Process_Services__c = serviceMaster.Id);
        insert clientApe;
                
        List<Wave_Proc__c> WaveProcList = new List<Wave_Proc__c>();     
        List<Wave_Proc__c> WaveProcList1 = new List<Wave_Proc__c>();    
        Wave_Proc__c strWaveProc = new Wave_Proc__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Wave_Process_Location__c = deliveryLocMaster.Id, Wave_Client_Specific_Process__c = clientApe.Id);
        insert strWaveProc;
        WaveProcList.add(strWaveProc);
        
        strmobplan.Active__c= False;
        update strmobplan;
        strWaveProc.Active__c = FALSE;
        WaveProcList1.add(strWaveProc);
        update WaveProcList1;
        
        delete WaveProcList1;
}

/*    
    //-------------------------second set-------------------------------------------------------------
        static Testmethod void test2(){
        
         try
            {
        //Inserting New Deal
        Deal__c strDeal1 = new Deal__c(Name='DealTest1231');
        insert strDeal1;
        
        //inserting New Plan under Deal
        Mobilization_Plan__c strmobplan1 = new Mobilization_Plan__c(Name ='planTest1231', Deal__c = strDeal1.id, Active__c =true);
        insert strmobplan1;
                        
        //Inserting new Wave        
        Wave__c strWave1 = new Wave__c(Name='Test Wave1', Mobilization_Plan__c= strmobplan1.id, Planned_Go_Live_Date__c= System.Today());
        insert strWave1;
        
        //Inserting Wave Process
        Offering_Master__c offMaster1 = new Offering_Master__c(Name = UtilConstants.HR,offering_description__c = UtilConstants.TEST_DESC,
        flywheel_non_flywheel__c = UtilConstants.FLYWHEEL);
        insert offMaster1; 
        
        Services_Master__c serviceMaster1 = new Services_Master__c(Name = UtilConstants.HRSERVICE,offering__c = offMaster1.id);
        insert serviceMaster1;
                
        Geo_Region_Master__c geoRegion1 = new Geo_Region_Master__c(Name = UTIL_Constants.AsiaPacific,Active__c = true);
        insert geoRegion1;
        
        Country_Master__c countryMaster1 = new Country_Master__c(Name='IN1', Geo_Region__c = geoRegion1.Id);
        insert countryMaster1;
        
        Delivery_Location_Masters__c deliveryLocMaster1 = new Delivery_Location_Masters__c(Name = UtilConstants.BANGALORE,country__c = countryMaster1.id,delivery_location_description__c = UtilConstants.TEST_DESC,active__c=true);
        insert deliveryLocMaster1;
        
        Client_Specific_Process__c clientApe1 = new Client_Specific_Process__c(Name = 'test Client Process1', Deal__c =strDeal1.Id, Process_Offering__c =offMaster1.Id, Process_Services__c = serviceMaster1.Id);
        insert clientApe1;
                
        List<Wave_Proc__c> WaveProcList1 = new List<Wave_Proc__c>();        
        Wave_Proc__c strWaveProc1 = new Wave_Proc__c( Wave__c = strWave1.Id, Mobilization_Plan__c = strmobplan1.Id, IsPlanActive__c = False, Wave_Process_Location__c = deliveryLocMaster1.Id, Wave_Client_Specific_Process__c = clientApe1.Id);
        insert strWaveProc1;
        WaveProcList1.add(strWaveProc1);
        
        
        UTILMobClasses utilTest1 = new UTILMobClasses();
        //delete WaveProcList1;
        //utilTest1.checkDeletingActiveRecords(WaveProcList1);
        
            }catch (DmlException e) {
            	//Assert Error Message
            		System.assert( e.getMessage().contains('Insert failed'),e.getMessage() ); }
            
        
    */

}