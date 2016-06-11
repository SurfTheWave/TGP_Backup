/*
  @Author: 
  @Name: OpexTrackerLevel1_Test
  @Created Date: 01 January 2015
  @Description:This is a test class OpexTrackerLevel1_Test for checking deletion insertion for ot2.
  @version: 1.0
*/
@isTest
private class OpexTrackerLevel1_Test{

    //private static List<Mobilization_Plan__c> bcpMobPlans;
    // Setting up test data.
/*
  @Author: 
  @Name: test1
  @Created Date: 01 January 2015
  @Description: This is a test method test1 for checking deletion insertion ot2.
  @version: 1.0
*/      
        static testMethod void test1(){
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
        Test.starttest();
        List<OPEX_Tracker__c> opexList = new List<OPEX_Tracker__c>();
        OPEX_Tracker__c ot = new OPEX_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 1 Assessment',Days_After_Go_Live__c=7);
    //    insert ot; 
        
         OPEX_Tracker__c ot2 = new OPEX_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 1 Assessment',Days_After_Go_Live__c=30);
     //   insert ot2;
        opexList.add(ot);
        opexList.add(ot2);
        insert opexList;
     
    //    delete ot2;
        
        OPEX_Master__c om = new OPEX_Master__c(Name = 'test OPEX Master', Active__c = True, Days_After_Go_Live__c = 2, Item_Order__c =3);
        insert om;
        
        Deal_OPEX_Additional_Tracking_Level_1__c OpexLevel1 = new Deal_OPEX_Additional_Tracking_Level_1__c(OPEX_Tracker_del__c = ot.Id, Name = 'test OPEX Additonal Master');
        insert OpexLevel1;
        // }
        
        // static testMethod void TestMethod1(){
        
        // setupData();
        List <Deal_OPEX_Additional_Tracking_Level_2__c> Level2List = new List <Deal_OPEX_Additional_Tracking_Level_2__c>();
       
        Deal_OPEX_Additional_Tracking_Level_2__c Level2a = new Deal_OPEX_Additional_Tracking_Level_2__c(Name= 'Test',Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id , Active__c = true ,Answer__c = 'NO');
        Deal_OPEX_Additional_Tracking_Level_2__c Level2b = new Deal_OPEX_Additional_Tracking_Level_2__c(Name= 'Test',Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id , Active__c = true ,Answer__c = 'NO');
        Deal_OPEX_Additional_Tracking_Level_2__c Level2c = new Deal_OPEX_Additional_Tracking_Level_2__c(Name= 'Test',Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id , Active__c = true ,Answer__c = 'NO');
        Deal_OPEX_Additional_Tracking_Level_2__c Level2d = new Deal_OPEX_Additional_Tracking_Level_2__c(Name= 'Test',Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id , Active__c = true ,Answer__c = 'NO');
        Deal_OPEX_Additional_Tracking_Level_2__c Level2e = new Deal_OPEX_Additional_Tracking_Level_2__c(Name= 'Test',Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id , Active__c = true ,Answer__c = 'NO');
        Deal_OPEX_Additional_Tracking_Level_2__c Level2f = new Deal_OPEX_Additional_Tracking_Level_2__c(Name= 'Test',Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id , Active__c = true ,Answer__c = 'NO');
        Deal_OPEX_Additional_Tracking_Level_2__c Level2g = new Deal_OPEX_Additional_Tracking_Level_2__c(Name= 'Test',Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id , Active__c = true ,Answer__c = 'NO');
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
        OpexLevel1.Active__c = true;
        Update OpexLevel1;
        ot.Submit_Checklist__c = true ;
        Update ot;
        Delete ot;
       
       Test.stoptest();
       }
}