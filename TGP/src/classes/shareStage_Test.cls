/*
   @Author       : 
   @Class name   : shareStage_Test 
   @CreateDate   : 
   @Description : 
   @Version : 1.0 


  */

@isTest
public class shareStage_Test {
    private static Decimal testDecimal = 100;
    private static String testString = 'testString';
    public static Opportunity opp;
     /******************************
     * Method Name: testAddShares
     * Description: 
     * Paramenters: 
     * Return Value: profile
     *******************************/
    static testMethod void testAddShares(){
        User useObj = UtilNovaUnitTest.getUser();
        User useObj1 = UtilNovaUnitTest.getUser1();
        List<user> userlist=new List<user>();
        userlist.add(useObj);
        userlist.add(useObj1);
        insert userlist;
        system.runAs(userlist[0]){
        Email_Template__c cs = new Email_Template__c();
        cs.ID__c=UtilConstants.EMAIL_ApprovalSectionTest3;
        cs.name= UtilConstants.ActionItemMail;


        insert cs;
        User_Master__c userObj = new User_Master__c(Name = 'TestUser',User__c = userlist[0].id,email__c=userlist[0].email);
        User_Master__c userObj1 = new User_Master__c(Name = 'SolTestUser',User__c = userlist[1].id,email__c=userlist[1].email);
        insert(userObj);
        insert(userObj1);
            
            
        
        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        insert ogm;
    
        opp = new Opportunity();
        
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Name = UtilConstants.TEST_OPP;
        insert opp;
            
     List<Opportunity_Teams__c> lstOppTeam = new List<Opportunity_Teams__c>();
     Opportunity_Teams__c OppTeam_Obj = new Opportunity_Teams__c(Role__c = NULL,
                                                                Opportunity_Team_Member__c = userObj.id,
                                                                Request_Team_Member__c = False,
                                                               Team_Member_Request_Status__c = UtilConstants.ASSIGNED,

                                                               opportunity__c=opp.id
                                                               );
         insert OppTeam_Obj; 
        
        Approval_Stage__c appObj_stage = new Approval_Stage__c(opportunity__c=opp.id ,approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL,
                                                             Service_Group__c = utilConstants.BPO,approval_stage_status__c= utilConstants.PENDING_STATUS);
        Database.insert(appObj_stage);
        
         Approval_Request__c appObj = new Approval_Request__c(approval_stage__c=appObj_stage.id,approver__c=userObj1.id,approval_request_type__c='BST Approval',Service_Group__c = utilConstants.BPO,approval_sent_date__c=date.today());
         Approval_Request__c appObj1 = new Approval_Request__c(approval_stage__c=appObj_stage.id,approver__c=userObj1.id,approval_request_type__c='BST Approval',Service_Group__c = utilConstants.BPO,approval_request_status__c= utilConstants.PEND_REQ);
        List<Approval_Request__c> rlist=new List<Approval_Request__c>();
        List<Approval_Request__c> rlist1=new List<Approval_Request__c>();
        rlist.add(appObj);
        rlist1.add(appObj1);
        Action_Item__c actObj=new Action_Item__c(approval_stage__c=appObj_stage.id,Primary_Owner__c=userObj1.id,action__c='Test',due_date__c=date.today(),action_item_status__c = utilConstants.COMPLETED);
        List<Action_Item__c>alist=new List<Action_Item__c>();
        Action_Item__c actObj1=new Action_Item__c(approval_stage__c=appObj_stage.id,Primary_Owner__c=userObj1.id,action__c='Test',due_date__c=date.today(),action_item_status__c = utilConstants.INPROG2);
        Task task1 =new Task(WhatId=actObj1.id);
        Task task2 =new Task(WhatId=actObj.id);
        List<Action_Item__c>alist1=new List<Action_Item__c>();
          
        alist1.add(actObj1);
        alist.add(actObj);
        database.insert(rlist,true);
        database.insert(rlist1,true);
       // database.insert(alist1,true);
        //database.insert(alist,true);
         test.startTest();
        shareStage.share(rlist);
        shareStage.restrictShare(rlist1);
        shareStage.ShareStageWithPrimaryOwner(alist);
        shareStage.restrictShareForPrimaryOwner(alist1);
          test.stopTest();
        }
    }
        

}