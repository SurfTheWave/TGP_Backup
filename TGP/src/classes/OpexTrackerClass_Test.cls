@isTest
/*
@name : OpexTrackerClass_Test
@CreateDate : 4/6/2015 7:15 PM
@Description : 
@Version : 
*/
private class OpexTrackerClass_Test{

    //private static List<Mobilization_Plan__c> bcpMobPlans;
    // Setting up test data.
    
      private static User testUser;
/*
@name : test1
@Description : 
@Version : 
*/
      static testMethod void test1(){
      
        Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
      
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
        
        //Creatinh BCP_Tracker__c test data for 
        List<BCP_Tracker__c> lstBCP = new List<BCP_Tracker__c>();
        BCP_Tracker__c strBCP = new BCP_Tracker__c(Name = 'test BCP', Mobilization_Plan__c = strmobplan.Id, 
                                       Task_Description__c = 'test Desc', Resource_Name__c = 'test Resource', 
                                       Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c=System.Today()+20);
        //insert strBCP;
        List<BCP_Master__c> lstBCPMaster = new List<BCP_Master__c>();
        BCP_Master__c strBCPMaster = new BCP_Master__c(Name = 'test BCP Masters', Section__c = 'Business Impact Analysis', Task__c = 'test Task', BCP_Type__c ='Standard Offering BCP', Task_Order__c = 2, Active__c = True);
        lstBCPMaster.add(strBCPMaster);
        insert lstBCPMaster;
        
        List<Contract_Legal_Master__c> legalMstrsList = new List<Contract_Legal_Master__c>();
        Contract_Legal_Master__c strConMaster = new Contract_Legal_Master__c(Name = 'test Contract and Legal', Section__c = 'CP Questions (CPP Process)', Task_Order__c = 3, Active__c = True);
        legalMstrsList.add(strConMaster);
        
        List<Contract_Legal_Tracker__c> legalContractList = new List<Contract_Legal_Tracker__c>();
        //inserting test data for Contract legal tracker..
        Contract_Legal_Tracker__c strContract = new Contract_Legal_Tracker__c(Name = 'test Contract and Legal', Mobilization_Plan__c= strmobplan.id, Resource_Name__c= 'test Resource', Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c=System.Today()+20, Section__c = 'CP Questions (CPP Process)', Task_Order__c = 3, Active__c = True);  
        //insert strContract;
        legalContractList.add(strContract);
        
        List<Journey_Management_Master__c> jrnyMstrs = new List<Journey_Management_Master__c>(); 
        Journey_Management_Master__c strMstrJrny = new Journey_Management_Master__c(Name = 'test Journey Mgnt Master', Deliverable_Number__c = 20, Section__c = 'Stakeholder Management', Deliverable__c = 'test Deliverables', Section_Number__c = 12, Active__c = True);
        jrnyMstrs.add(strMstrJrny);
        insert jrnyMstrs;
        
        List<Journey_Management_Tracker__c> lstJrnyMgntTrkrs = new List<Journey_Management_Tracker__c>();
        Journey_Management_Tracker__c jTrkr = new Journey_Management_Tracker__c(Mobilization_Plan__c = strmobplan.Id, Name = 'test Journey Mgnt Tracker', Responsibility__c = 'Accenture', Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c = System.Today()+20, IsPlanActive__c = True, IsTrackingOn__c = True);
        lstJrnyMgntTrkrs.add(jTrkr);
        insert lstJrnyMgntTrkrs;
        
        Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today()+30);
        insert strWave;
        
        OPEX_Master__c om = new OPEX_Master__c(Name= 'Day 7 Assessment', Days_After_Go_Live__c = 5,Active__c = TRUE);
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
        
        
        Test.starttest();
        List<OPEX_Tracker__c> lstOT = new List<OPEX_Tracker__c>();
        OPEX_Tracker__c ot = new OPEX_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 5 Assessment',Days_After_Go_Live__c=7);
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
                    
        OpexTrackerClass OTclass = new OpexTrackerClass();
        
        OTclass.InsertOpexL1L2(lstOT);
        OTclass.UpdateOpexOverallScore(lstOpexLevel1);
        OTclass.UpdateOpexChecklistStatus(lstOpexLevel1);
        OTclass.updateRecTypeOpexlevel2(lstOT);
        OTclass.OpexDelete(ot);
        
     /*   OpexLevel1.Active__c = true;
        Update OpexLevel1;
        ot.Submit_Checklist__c = true ;
        Update ot;
        Delete ot;
        
        
        delete ot2;
        
        OPEX_Master__c om = new OPEX_Master__c(Name = 'test OPEX Master', Active__c = True, Days_After_Go_Live__c = 2, Item_Order__c =3);
        insert om;
        */
                    
       
       Test.stoptest();
       }
       
       
}