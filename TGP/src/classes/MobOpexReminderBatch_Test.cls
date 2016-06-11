@isTest
private class MobOpexReminderBatch_Test {

    static testMethod void test1(){
        Test.StartTest();       
        //creating Deal test data..
        Deal__c strDeal = new Deal__c(Name='DealTest123');
        insert strDeal;
        
        //inserting New Plan under Deal.
        List<Mobilization_Plan__c> bcpMobPlans = new List<Mobilization_Plan__c>();        
        Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = strDeal.id, BCP_Type__c = 'Standard Offering BCP', IsTrackingOn__c = True);
        //Database.Insert(strmobplan,false);
        //insert strmobplan;
        bcpMobPlans.add(strmobplan);
        insert bcpMobPlans;
        
        User_Master__c userMaster=new User_Master__c(Name='abc user',email__c='abc@exple.com');
        insert userMaster;
        //Inserting New mobilization team under Deal.
        Mobilization_Team__c mt = new Mobilization_Team__c(Role__c = 'Global Transition Lead', Deal__c = strDeal.Id,Primary_Lead__c=userMaster.id,Secondary_Lead_1__c=userMaster.id,Secondary_Lead_2__c=userMaster.id);
        insert mt;
    Mobilization_Team__c mt1 = new Mobilization_Team__c(Role__c = 'Global ', Deal__c = strDeal.Id,Primary_Lead__c=userMaster.id,Secondary_Lead_1__c=userMaster.id,Secondary_Lead_2__c=userMaster.id);
        insert mt1;
         
        Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today());
        insert strWave;
        
        OPEX_Master__c om = new OPEX_Master__c(Name= 'Day 7 Assessment', Days_After_Go_Live__c = 1,Active__c = TRUE);
        insert om;
        OPEX_Master__c omrec2 = new OPEX_Master__c(Name= 'Day 30 Assessment', Days_After_Go_Live__c = 30,Active__c = TRUE);
        insert omrec2;
    //  OPEX_Master__c omrec3 = new OPEX_Master__c(Name= 'Day 30 Assessment', Days_After_Go_Live__c = 10,Active__c = TRUE);
    //    insert omrec3;
        
        OPEX_Additional_Tracking_Level1_Master__c om1 = new OPEX_Additional_Tracking_Level1_Master__c(name='Focus the Service operation', Active__c=TRUE, OPEX_Level_1_Tracking_Type__c= 'Focus the Service operation',OPEX_Master__c=om.Id);
        insert om1;
        OPEX_Additional_Tracking_Level1_Master__c om1Rec2 = new OPEX_Additional_Tracking_Level1_Master__c(name='Focus the Service operation', Active__c=TRUE, OPEX_Level_1_Tracking_Type__c= 'Focus the Service operation',OPEX_Master__c=omrec2.Id);
        insert om1Rec2;
        
        OPEX_Additional_Tracking_Level2_Master__c om2 = new OPEX_Additional_Tracking_Level2_Master__c(name='Focus the Service operation Question 1',Active__c= TRUE, OPEX_Additional_Tracking_Level1_Master__c=om1.Id,Question__c='testq1');
        insert om2;
        OPEX_Additional_Tracking_Level2_Master__c om2Rec2 = new OPEX_Additional_Tracking_Level2_Master__c(name='Focus the Service operation Question 1',Active__c= TRUE, OPEX_Additional_Tracking_Level1_Master__c=om1Rec2.Id,Question__c='testq1');
        insert om2Rec2;

        List<OPEX_Tracker__c> lstOT = new List<OPEX_Tracker__c>();
        OPEX_Tracker__c ot = new OPEX_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 5 Assessment',Days_After_Go_Live__c=1,Checklist_Status__c='abc');
    //    insert ot; 
         OPEX_Tracker__c ot2 = new OPEX_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 30 Assessment',Days_After_Go_Live__c=30);
     //   insert ot2;
        
        lstOT.add(ot);
        lstOT.add(ot2);
        insert lstOT;
        
        
        OPEX_Tracker__c ot3 = new OPEX_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 10 Assessment',Days_After_Go_Live__c=10);
        insert ot3; 
        
        
        Deal_OPEX_Additional_Tracking_Level_1__c OpexLevel1 = new Deal_OPEX_Additional_Tracking_Level_1__c(OPEX_Tracker_del__c = ot.Id, Name = 'test OPEX Additonal Master',OPEX_Level_1_Tracking_Type__c = 'Focus the Service operation');
        insert OpexLevel1;
        Deal_OPEX_Additional_Tracking_Level_1__c OpexLevel1Rec2 = new Deal_OPEX_Additional_Tracking_Level_1__c(OPEX_Tracker_del__c = ot2.Id, Name = 'test OPEX Additonal Master',OPEX_Level_1_Tracking_Type__c = 'Focus the Service operation');
        insert OpexLevel1Rec2;
        
        List<Deal_OPEX_Additional_Tracking_Level_1__c> lstOpexLevel1 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
        lstOpexLevel1.add(OpexLevel1);
        
          List <Deal_OPEX_Additional_Tracking_Level_2__c> Level2List = new List <Deal_OPEX_Additional_Tracking_Level_2__c>();
       
        Deal_OPEX_Additional_Tracking_Level_2__c Level2a = new Deal_OPEX_Additional_Tracking_Level_2__c(Name= 'Test',Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id , Active__c = true ,Answer__c = 'Yes');
        Deal_OPEX_Additional_Tracking_Level_2__c Level2b = new Deal_OPEX_Additional_Tracking_Level_2__c(Name= 'Test',Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id , Active__c = true ,Answer__c = 'Yes');
        Deal_OPEX_Additional_Tracking_Level_2__c Level2c = new Deal_OPEX_Additional_Tracking_Level_2__c(Name= 'Test',Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id , Active__c = true ,Answer__c = 'Yes');
        Deal_OPEX_Additional_Tracking_Level_2__c Level2d = new Deal_OPEX_Additional_Tracking_Level_2__c(Name= 'Test',Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id , Active__c = true ,Answer__c = 'Yes');
        Deal_OPEX_Additional_Tracking_Level_2__c Level2e = new Deal_OPEX_Additional_Tracking_Level_2__c(Name= 'Test',Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id , Active__c = true ,Answer__c = 'Yes');
        Deal_OPEX_Additional_Tracking_Level_2__c Level2f = new Deal_OPEX_Additional_Tracking_Level_2__c(Name= 'Test',Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id , Active__c = true ,Answer__c = 'Yes');
        Deal_OPEX_Additional_Tracking_Level_2__c Level2g = new Deal_OPEX_Additional_Tracking_Level_2__c(Name= 'Test',Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id , Active__c = true ,Answer__c = 'Yes');
        Deal_OPEX_Additional_Tracking_Level_2__c Level2h = new Deal_OPEX_Additional_Tracking_Level_2__c(Name= 'Test',Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id , Active__c = true ,Answer__c = 'Yes');
        Deal_OPEX_Additional_Tracking_Level_2__c Level2i = new Deal_OPEX_Additional_Tracking_Level_2__c(Name= 'Test',Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id , Active__c = true ,Answer__c = 'Yes');
        
        Level2List.add(Level2a);
        Level2List.add(Level2b);
        Level2List.add(Level2c);
        Level2List.add(Level2d);
        Level2List.add(Level2e);
        Level2List.add(Level2f);
        Level2List.add(Level2g);
        Level2List.add(Level2h);
        Level2List.add(Level2i);
        Insert Level2List;  
      // query='SELECT Id, name,Planned_Date__c,Checklist_Status__c,wave__r.name,Wave__r.Mobilization_Plan__r.Deal__r.name FROM OPEX_Tracker__c where Active__c=true and IsTrackingOn__c=true and Checklist_Status__c!=\'Submitted\' and Planned_Date__c=:sevenDaysBefore';
                
    
        MobOpexReminderSchedulable mobsch = new MobOpexReminderSchedulable();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test MobOpexReminderBatch_Test', sch, mobsch); 
        Test.stopTest();
    
    }

}