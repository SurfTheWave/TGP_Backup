/*
@name : ChangeTaskName_Test
@Description : 
@Version : 
*/ 
@isTest(SeeAllData=false) 
private class ChangeTaskName_Test{
    private Static String aliasString = 'testUNIQ';
    private Static Id sysAdminId = [Select Id from Profile Where Name = 'System Administrator' Limit 1].Id;
    private Static User stdUser = new User(
    alias = aliasString, 
    email= aliasString+'@accenture.com',
    emailencodingkey='UTF-8',
    lastname='Testing', 
    languagelocalekey='en_US',
    localesidkey='en_US',
    profileid = sysAdminId,
    timezonesidkey='Europe/London',
    username= aliasString+'@accenture.com');
    
  /*  static testMethod void test1(){
        test.starttest();
         Id I = UserInfo.getUserId();                 

        //creating Deal test data..
        Deal__c strDeal = new Deal__c(Name='DealTest123',Approval_Status__c= 'Approved' );
        insert strDeal;
        
        //inserting New Plan under Deal.
        List<Mobilization_Plan__c> bcpMobPlans = new List<Mobilization_Plan__c>();        
        Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = strDeal.id, BCP_Type__c = 'Standard Offering BCP', IsTrackingOn__c = True);
        bcpMobPlans.add(strmobplan);
        insert bcpMobPlans;
   
        Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today()+30);
        insert strWave; 
        
        List<SRAT_Tracker__c> lstST = new List<SRAT_Tracker__c>();
        SRAT_Tracker__c SratDel = new SRAT_Tracker__c();
        SratTrackerClass STclass = new SratTrackerClass ();
        
        List<User_Master__c> MasterList= new List<User_Master__c>();
        
        User_Master__c UserMasterRef0= new User_Master__c();
        UserMasterRef0.Name = 'UserMasterTest0';
        UserMasterRef0.User__c = stdUser.Id;
        MasterList.add(UserMasterRef0);
        User_Master__c UserMasterRef1= new User_Master__c();
        UserMasterRef1.Name = 'UserMasterTest1';
        UserMasterRef1.User__c = stdUser.Id;
        MasterList.add(UserMasterRef1);
        User_Master__c UserMasterRef2= new User_Master__c();
        UserMasterRef2.Name = 'UserMasterTest2';
        UserMasterRef2.User__c = stdUser.Id;
        MasterList.add(UserMasterRef2);
        
        Insert MasterList;
        
        Mobilization_Team__c MTeamRef = new Mobilization_Team__c();
        MTeamRef.Role__c = 'Global Transition Lead';
        MTeamRef.Primary_Lead__c = MasterList[0].Id ;
        MTeamRef.Active__c = true;
        //MTeamRef.Wave__c = strWave.Id;
        
        MTeamRef.Secondary_Lead_1__c = MasterList[1].Id ;
        MTeamRef.Secondary_Lead_2__c = MasterList[2].Id ;
        Insert MTeamRef ;
        
        
        SRAT_Tracker__c st = new SRAT_Tracker__c(Checklist_Reviewer__c = MTeamRef.Id,Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 5 Assessment',Days_Before_Go_Live__c = 5);
        SRAT_Tracker__c st30 = new SRAT_Tracker__c(Checklist_Reviewer__c = MTeamRef.Id ,Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 30 Assessment',Days_Before_Go_Live__c = 30);
        insert st;
        insert st30;
        lstST.add(st);
        STclass.InsertSratL1L2(lstST);
        
        List<Task> lstTask = new List<Task>(); 
       
       
        Task lstTask2 = new Task();
         
        lstTask2.WhatId = lstST[0].Id;   //need to add Id of SRAT_Tracker__c  and approval_request__c 
        lstTask2.OwnerId = I;
        lstTask2.Subject = 'Call';
        lstTask2.Status = 'In Progress';
        lstTask2.Priority = 'High';
        lstTask2.ActivityDate = Date.newInstance(1960, 2, 17);
        
        insert lstTask2;  
        lstTask.add(lstTask2); 
        

        test.stoptest();    
        
    } */
/**********
@name : test2
@Description : 
@Version : 
************/ 
     static testMethod void test2(){
        test.starttest();

        Id I = UserInfo.getUserId();
      //List<Task> lstTask = new List<Task>();  
      
       List<Opportunity> oppList = UnitTestDatafactory.createOppList('TestOppty',1);
        Approval_stage__c ApprovalStage = new Approval_stage__c();
        ApprovalStage.opportunity__c = oppList[0].id;
        ApprovalStage.Service_Group__c = 'BPO';
        ApprovalStage.approval_stage_type__c = utilConstants.FLY_BY_SOL_REVIEW;
        ApprovalStage.approval_stage_status__c = 'Pending';
        Insert ApprovalStage;
        
        Approval_Request__c requestReview3 = new Approval_Request__c();
        requestReview3.approval_request_type__c='SDO Approval';
        requestReview3.comments_by_approver__c='Test Data';
        requestReview3.response_received_date__c=date.parse('06/06/1980'); 
        User_Master__c Requestor = new User_Master__c();   //Added for null pointer error
        Requestor.Name = 'TestUserMaster';
        Requestor.Email__c='abc@accenture.com';
        insert Requestor;
        requestReview3.Requestor__c = Requestor.Id;
        
        User_Master__c Approver = new User_Master__c();   //Added for null pointer error
        Approver.Name = 'TestUserMaster';
        Approver.Email__c=stdUser.Email;
        Approver.User__c = stdUser.Id;
        insert Approver;
        requestReview3.Approver__c = Approver.Id;
        
        requestReview3.approval_stage__c = ApprovalStage.Id;
        requestReview3.Service_Group__c = UtilConstants.BPO;
        requestReview3.approval_request_status__c ='Not Sent'; //Trigger Issue
        
        requestReview3.approval_sent_date__c = System.Today() + 3 ;
        insert requestReview3;
        
        User_Master__c UserMasterRef0= new User_Master__c();
        UserMasterRef0.Name = 'UserMasterTest0';
        UserMasterRef0.user__c = I ;
        Insert UserMasterRef0;
        
        Action_Item__c AI = new Action_Item__c();
        AI.Primary_Owner__c = UserMasterRef0.Id;
        AI.action__c = 'Description test class';
        AI.due_date__c = System.today() + 5 ;
        AI.approval_stage__c = ApprovalStage.Id;
        AI.Primary_Owner__c = UserMasterRef0.Id;
        Insert AI ;

      /*  Task lstTask1 = new Task(); // issue with Approver__r.user__c in the class
         
        lstTask1.WhatId = requestReview3.Id;
        lstTask1.OwnerId = I;
        lstTask1.Subject = 'Call';
        lstTask1.Status = 'In Progress';
        lstTask1.Priority = 'High';
        lstTask1.ActivityDate = Date.newInstance(1960, 2, 17);
       // lstTask.add(lstTask2);
        Insert lstTask1;      */

        Task lstTask2 = new Task();
         
        lstTask2.WhatId = AI.Id;
        lstTask2.Subject = 'Call';
        lstTask2.Status = 'In Progress';
        lstTask2.Priority = 'High';
        lstTask2.ActivityDate = Date.newInstance(1960, 2, 17);
       // lstTask.add(lstTask2);
        
        insert lstTask2;
               
        
        test.stoptest();
        
    }
/**********
@name : test3
@Description : 
@Version : 
************/  
static testMethod void test3(){
        test.starttest();
        Id I = UserInfo.getUserId();  
        List<Opportunity> oppList = UnitTestDatafactory.createOppList('TestOppty',1);
        oppList[0].Active__c = true ;
        Update oppList[0];
        SD_Governance_Data__c SD= new SD_Governance_Data__c ();
        SD.Name = 'SD';
        SD.Opportunity__c =  oppList[0].Id ;
        Insert SD;
        List<Task> lstTask = new List<Task>(); 
        Task lstTask1 = new Task(); 
        lstTask1.OwnerId = I;
        lstTask1.Subject = 'Call';
        lstTask1.Status = 'In Progress';
        lstTask1.Priority = 'High';
        lstTask1.ActivityDate = Date.newInstance(1960, 2, 17);
        Insert lstTask1;                     
        lstTask.add(lstTask1);   
        Task lstTask2 = new Task();
        
        lstTask2.WhatId = SD.Id;
        lstTask2.Subject = 'Call';
        lstTask2.Status = 'In Progress';
        lstTask2.Priority = 'High';
        lstTask2.ActivityDate = Date.newInstance(1960, 2, 17);
        insert lstTask2;
        lstTask.add(lstTask2); 
        ChangeTaskName.updateExistingTasks(lstTask);      
        ChangeTaskName.deltask(lstTask); 
        
        test.stoptest();
        
    }
/**********
@name : test_customsettings
@Description : 
@Version : 
************/  
    static testMethod void test_customsettings(){
        Email_Template__c em = new Email_Template__c(Name=utilConstants.ActionItemMail ,id__c =UtilConstants.EMAIL_ApprovalSectionTest3);
        test.startTest();
        insert em;
        test.stopTest();
    }
}