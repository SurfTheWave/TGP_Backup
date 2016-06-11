/*
@Author and Created Date : Goudar Devanna ,  3/26/2015 8:05 AM
@name : SRATapprovaltrigger_Test
@Description : 
@Version : 
*/
@isTest
private class SRATapprovaltrigger_Test{

    //private static List<Mobilization_Plan__c> bcpMobPlans;
    // Setting up test data.
    private static User testUser;
    /******************************
    Method Name: test1
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    static testMethod void test1(){
    Test.starttest();
        //creating Deal test data..
        Deal__c strDeal = new Deal__c(Name='DealTest123',Approval_Status__c = 'Approved');
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
        
    /*    List<Journey_Management_Tracker__c> lstJrnyMgntTrkrs = new List<Journey_Management_Tracker__c>();
        Journey_Management_Tracker__c jTrkr = new Journey_Management_Tracker__c(Mobilization_Plan__c = strmobplan.Id, Name = 'test Journey Mgnt Tracker', Responsibility__c = 'Accenture', Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c = System.Today()+20, IsPlanActive__c = True, IsTrackingOn__c = True);
        lstJrnyMgntTrkrs.add(jTrkr);
        insert lstJrnyMgntTrkrs;    */
        
        Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today()+30);
        insert strWave; 
        
        
        Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);                    
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME); 
        insert testUser;
        
        User_Master__c tuser = new User_Master__c(Name = 'testuser2',email__c = 'goudar.devanna@accenture.com',user__c = testUser.Id);
        insert tuser;
        
        Mobilization_Team__c Mobteam = new Mobilization_Team__c(Deal__c = strDeal.Id,Role__c = 'Governance Lead',Primary_Lead__c = tuser.Id);
        insert Mobteam;
        
        List<SRAT_Tracker__c> lstST = new List<SRAT_Tracker__c>();
        SRAT_Tracker__c SratDel = new SRAT_Tracker__c();
        SRATApprovalProcessController s = new SRATApprovalProcessController();
        
        
        SRAT_Tracker__c st = new SRAT_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 1 Assessment',Checklist_Reviewer__c = Mobteam.Id, Send_Checklist_for_Review__c = TRUE, Checklist_Reviewed__c = FALSE,Days_Before_Go_Live__c=5);
    //    insert st;
        SRAT_Tracker__c st2 = new SRAT_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 1 Assessment',Checklist_Reviewer__c = Mobteam.Id, Send_Checklist_for_Review__c = TRUE, Checklist_Reviewed__c = FALSE,Days_Before_Go_Live__c=30);
        lstST.add(st);
        lstST.add(st2);
        insert lstST;
        
     //   s.submitForApproval(st);
         
    
       Test.stoptest();
       }
       
              
}