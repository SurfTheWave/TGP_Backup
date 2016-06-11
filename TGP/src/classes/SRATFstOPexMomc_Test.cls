/**
   @Author :Mobilization WorkBench
   @name   :SRATFstOPexMomc_Test
   @CreateDate :12 December 2015 
   @Description : This is a trigger on SRAT_Additional_Tracking_Level_2_FST__c.
   @Version : 1.0 
  */
@isTest
public Class SRATFstOPexMomc_Test{


/**
   @Author :Mobilization WorkBench
   @name   :SRAT_Lvl2_FST_Trigger 
   @CreateDate :12 December 2015 
   @Description : This is a trigger on SRAT_Additional_Tracking_Level_2_FST__c.
   @Version : 1.0 
  */
    public static testMethod void testFSTMomc(){
         Deal__c strDeal = new Deal__c(Name='DealTest123');
        insert strDeal;
        
        List<Mobilization_Plan__c> bcpMobPlans = new List<Mobilization_Plan__c>();        
        Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = strDeal.id,  IsTrackingOn__c = True);
        bcpMobPlans.add(strmobplan);
        insert bcpMobPlans;
        
        Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today()+30);
        insert strWave; 
        
        
         SRAT_Tracker__c st20 = new SRAT_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 20 Assessment',Days_Before_Go_Live__c = 20);
         insert st20;  
            
         SRAT_Additional_Tracking_Level_1__c stLevel1T5 = new SRAT_Additional_Tracking_Level_1__c(Name = 'Factory Specific Technology', Overall_RAG_Status__c = 'Green',SRAT_Tracker__c = st20.id,SRAT_Level_1_Tracking_Type__c = 'Factory Specific Technology');       
         insert stLevel1T5;
        
         SRAT_Additional_Tracking_Level_2_FST__c sFst = new SRAT_Additional_Tracking_Level_2_FST__c(Name='srat Level Tracker FST',Deal_SRAT_Additional_Tracking_Level_1__c=stLevel1T5.id);
         insert sFSt;
         
         
         OPEX_Tracker__c ot = new OPEX_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 30 Assessment',Days_After_Go_Live__c=30);
        insert ot;
        
         Deal_OPEX_Additional_Tracking_Level_1__c OpexLevel1 = new Deal_OPEX_Additional_Tracking_Level_1__c(OPEX_Tracker_del__c = ot.Id, Name = 'test OPEX Additonal Master',OPEX_Level_1_Tracking_Type__c = 'Focus the Service operation');
        insert OpexLevel1;
        
        Deal_OPEX_Additional_Tckn_Level_2_MOMC__c opMOMc = new Deal_OPEX_Additional_Tckn_Level_2_MOMC__c( Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id);
        insert opMOMc;
        
    }
}