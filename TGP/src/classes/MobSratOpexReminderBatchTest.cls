/*
  @Author: yasin khan
  @Name: MobSratOpexReminderBatch and MobSratOpexReminderSchedulable
  @Created Date: 12 DEC 2015
  @Description:  
  @version: 
*/

@isTest
private class MobSratOpexReminderBatchTest {
   
    static testmethod void MobSratOpexReminderBatchTest(){
        
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
        
        Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today()+2);
        insert strWave; 
        SRAT_Master__c sm = new SRAT_Master__c(name='srat days 30',Active__c=TRUE,Days_Before_Go_Live__c=1);
        insert sm;
        //SRAT_Master__c sm = new SRAT_Master__c(name='srat days 30',Active__c=TRUE,Days_Before_Go_Live__c=30);
        //insert sm;
        SRAT_Additional_Tracking_Level1_Master__c sml1 = new SRAT_Additional_Tracking_Level1_Master__c(name='BPO Mobilization Controls',Active__c=true,Question__c='testquest',SRAT_Level1_Tracking_Type__c='BPO Mobilization Controls',SRAT_Master__c=sm.Id);
        insert sml1;
        SRAT_Additional_Tracking_Level2_Master__c sml2 = new SRAT_Additional_Tracking_Level2_Master__c(name='BPO Mobilization Control',Active__c=true,Question__c='testquest2',SRAT_Additional_Tracking_Level1_Master__c=sml1.Id);
        insert sml2;
        
        SRAT_Master__c smRec2 = new SRAT_Master__c(name='srat days 120',Active__c=TRUE,Days_Before_Go_Live__c=30);
        insert smRec2;
        //SRAT_Master__c sm = new SRAT_Master__c(name='srat days 30',Active__c=TRUE,Days_Before_Go_Live__c=30);
        //insert sm;
        SRAT_Additional_Tracking_Level1_Master__c sml1Rec2 = new SRAT_Additional_Tracking_Level1_Master__c(name='BPO Mobilization Controls',Active__c=true,Question__c='testquest',SRAT_Level1_Tracking_Type__c='BPO Mobilization Controls',SRAT_Master__c=smRec2.Id);
        insert sml1Rec2;
        SRAT_Additional_Tracking_Level2_Master__c sml2Rec2 = new SRAT_Additional_Tracking_Level2_Master__c(name='BPO Mobilization Control',Active__c=true,Question__c='testquest2',SRAT_Additional_Tracking_Level1_Master__c=sml1Rec2.Id);
        insert sml2Rec2;
        
        
        
        List<SRAT_Tracker__c> lstST = new List<SRAT_Tracker__c>();
        SRAT_Tracker__c SratDel = new SRAT_Tracker__c();        
        SRAT_Tracker__c st = new SRAT_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 5 Assessment',Days_Before_Go_Live__c = 1,Checklist_Status__c='abc',IsTrackingOn__c=true,Active__c=true);
        SRAT_Tracker__c st60 = new SRAT_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 60 Assessment',Days_Before_Go_Live__c = 30,Checklist_Status__c='xyz',IsTrackingOn__c=true,Active__c=true);
     //   insert st;
     //   insert st60;
        lstST.add(st);
        lstST.add(st60);
        insert lstST;
        SRAT_Additional_Tracking_Level_1__c stLevel1T5 = new SRAT_Additional_Tracking_Level_1__c(Name = 'BPO Mobilization Controls', Overall_RAG_Status__c = 'Green',SRAT_Tracker__c = st.id,SRAT_Level_1_Tracking_Type__c = 'BPO Mobilization Controls');       
        insert stLevel1T5;    
         
        SRAT_Additional_Tracking_Level_2__c stLevel2T5 = new SRAT_Additional_Tracking_Level_2__c(Name = 'BPO Mobilization Control',RAG_Status__c = 'Green',Comments__c = 'test comments',SRAT_Additional_Tracking_Level_1__c = stLevel1T5.Id,SRAT_Level_1_Tracking_Type__c = 'BPO Mobilization Controls');        
        insert stLevel2T5;   

        SRAT_Additional_Tracking_Level_1__c stLevel1 = new SRAT_Additional_Tracking_Level_1__c(Name = 'BPO Mobilization Controls', Overall_RAG_Status__c = 'Green',SRAT_Tracker__c = st60.id,SRAT_Level_1_Tracking_Type__c = 'BPO Mobilization Controls',Previous_Item__c = stLevel1T5.Id);       
        insert stLevel1;
     //   SRAT_Additional_Tracking_Level_1__c stLevel1rec2 = new SRAT_Additional_Tracking_Level_1__c(Name = 'BPO Mobilization Controls', Overall_RAG_Status__c = 'Green',SRAT_Tracker__c = st30.id,SRAT_Level_1_Tracking_Type__c = 'BPO Mobilization Controls');       
    //   insert stLevel1rec2;
        
        SRAT_Additional_Tracking_Level_2__c stLevel2 = new SRAT_Additional_Tracking_Level_2__c(Name = 'BPO Mobilization Control',RAG_Status__c = 'Green',Comments__c = 'test comments',SRAT_Additional_Tracking_Level_1__c = stLevel1.Id, SRAT_Level_1_Tracking_Type__c = 'BPO Mobilization Controls', Previous_Item__c = stLevel2T5.Id);        
        insert stLevel2;        
        Test.startTest();
        MobSratOpexReminderSchedulable MobSratORS = new MobSratOpexReminderSchedulable ();       
        String sch = '0 0 10 * * ?'; 
        system.schedule('Test MobSratOpexReminderSchedulable', sch, MobSratORS); 
        Test.stopTest();
        
       // MobSratOpexReminderBatch MobSratOpRemBatch = new MobSratOpexReminderBatch();    
        
        
    }
       
}