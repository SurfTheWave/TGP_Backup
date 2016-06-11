/******************************
   @Author       : 
   @Class name   : SratTrackerClass_Test
   @CreateDate   : 
   @Description : 
   @Version : 1.0 
*******************************/
@isTest
private class SratTrackerClass_Test{

 /******************************
     * Method Name: test1
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/ 
    static testMethod void test1(){
    Test.starttest();
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
        
        
        
        SRAT_Master__c sm = new SRAT_Master__c(name='srat days 30',Active__c=TRUE,Days_Before_Go_Live__c=30);
        insert sm;
        //SRAT_Master__c sm = new SRAT_Master__c(name='srat days 30',Active__c=TRUE,Days_Before_Go_Live__c=30);
        //insert sm;
        SRAT_Additional_Tracking_Level1_Master__c sml1 = new SRAT_Additional_Tracking_Level1_Master__c(name='BPO Mobilization Controls',Active__c=true,Question__c='testquest',SRAT_Level1_Tracking_Type__c='BPO Mobilization Controls',SRAT_Master__c=sm.Id);
        insert sml1;
        SRAT_Additional_Tracking_Level2_Master__c sml2 = new SRAT_Additional_Tracking_Level2_Master__c(name='BPO Mobilization Control',Active__c=true,Question__c='testquest2',SRAT_Additional_Tracking_Level1_Master__c=sml1.Id);
        insert sml2;
        
        SRAT_Master__c smRec2 = new SRAT_Master__c(name='srat days 120',Active__c=TRUE,Days_Before_Go_Live__c=120);
        insert smRec2;
        //SRAT_Master__c sm = new SRAT_Master__c(name='srat days 30',Active__c=TRUE,Days_Before_Go_Live__c=30);
        //insert sm;
        SRAT_Additional_Tracking_Level1_Master__c sml1Rec2 = new SRAT_Additional_Tracking_Level1_Master__c(name='BPO Mobilization Controls',Active__c=true,Question__c='testquest',SRAT_Level1_Tracking_Type__c='BPO Mobilization Controls',SRAT_Master__c=smRec2.Id);
        insert sml1Rec2;
        SRAT_Additional_Tracking_Level2_Master__c sml2Rec2 = new SRAT_Additional_Tracking_Level2_Master__c(name='BPO Mobilization Control',Active__c=true,Question__c='testquest2',SRAT_Additional_Tracking_Level1_Master__c=sml1Rec2.Id);
        insert sml2Rec2;
        
        
        
        List<SRAT_Tracker__c> lstST = new List<SRAT_Tracker__c>();
        SRAT_Tracker__c SratDel = new SRAT_Tracker__c();
        SratTrackerClass STclass = new SratTrackerClass ();
        
        
        SRAT_Tracker__c st = new SRAT_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 5 Assessment',Days_Before_Go_Live__c = 5);
        SRAT_Tracker__c st60 = new SRAT_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 60 Assessment',Days_Before_Go_Live__c = 60);
     //   insert st;
     //   insert st60;
       // lstST.add(st);
        lstST.add(st60);
        insert lstST;
        
       
     //   SRAT_Additional_Tracking_Level_1__c stLevel1rec2 = new SRAT_Additional_Tracking_Level_1__c(Name = 'BPO Mobilization Controls', Overall_RAG_Status__c = 'Green',SRAT_Tracker__c = st30.id,SRAT_Level_1_Tracking_Type__c = 'BPO Mobilization Controls');       
    //   insert stLevel1rec2;
        
        
        
        SRAT_Tracker__c st20 = new SRAT_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 20 Assessment',Days_Before_Go_Live__c = 20);
        insert st20;  

        SRAT_Tracker__c st90 = new SRAT_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 90 Assessment',Days_Before_Go_Live__c = 90);
        insert st90; 
        
        
        SRAT_Additional_Tracking_Level_1__c stLevel1T5 = new SRAT_Additional_Tracking_Level_1__c(Name = 'BPO Mobilization Controls', Overall_RAG_Status__c = 'Green',SRAT_Tracker__c = st20.id,SRAT_Level_1_Tracking_Type__c = 'BPO Mobilization Controls');       
        insert stLevel1T5;    
         

        SRAT_Additional_Tracking_Level_1__c stLevel1 = new SRAT_Additional_Tracking_Level_1__c(Name = 'BPO Mobilization Controls', Overall_RAG_Status__c = 'Green',SRAT_Tracker__c = st90.id,SRAT_Level_1_Tracking_Type__c = 'BPO Mobilization Controls',Previous_Item__c = stLevel1T5.Id);       
        insert stLevel1;

        //SRAT_Additional_Tracking_Level_2__c stLevel2 = new SRAT_Additional_Tracking_Level_2__c(Name = 'BPO Mobilization Control',RAG_Status__c = 'Green',Comments__c = 'test comments',SRAT_Additional_Tracking_Level_1__c = stLevel1T5.Id, SRAT_Level_1_Tracking_Type__c = 'BPO Mobilization Controls', Previous_Item__c = stLevel1.Id);        
        //insert stLevel2;        
        
        SRAT_Additional_Tracking_Level_2__c stLevel2 = new SRAT_Additional_Tracking_Level_2__c(Name = 'BPO Mobilization Control',RAG_Status__c = 'Green',Comments__c = 'test comments',SRAT_Additional_Tracking_Level_1__c = stLevel1T5.Id, SRAT_Level_1_Tracking_Type__c = 'BPO Mobilization Controls');        
        insert stLevel2;        
        
        
        //SRAT_Additional_Tracking_Level_2__c stLevel2T5 = new SRAT_Additional_Tracking_Level_2__c(Name = 'BPO Mobilization Control',RAG_Status__c = 'Green',Comments__c = 'test comments',SRAT_Additional_Tracking_Level_1__c = stLevel1T5.Id,SRAT_Level_1_Tracking_Type__c = 'BPO Mobilization Controls');        
        //insert stLevel2T5;   

         
        STclass.InsertSratL1L2(lstST);
        STclass.updateRecTypesratlevel2(lstST);
        STclass.SratDelete(st90);
        
                   
       Test.stoptest();
       }
       
              
}