@isTest(SeeAllData=false)
/*
@name : ApprovalSectionTest
@Description : 
@Version : 
*/
private class ApprovalSectionTest {
    private static ApprovalSection ext;
    private static Approval_Request__c requestReview3;
    private static Approval_Request__c requestReview31;
    private static PageReference pref;
    private User testUser;
    private Decimal testDecimal = 100;
    private String testString = 'testString';
    private static Opportunity opp;
/*
@name : Test2
@Description : 
@Version : 
*/
  
    static testMethod void Test2() {
        User useObj = UtilNovaUnitTest.getUser();
        User useObj1 = UtilNovaUnitTest.getUser1();
        List<user> userlist=new List<user>();
        userlist.add(useObj);
        userlist.add(useObj1);
        insert userlist;
        Email_Template__c cs = new Email_Template__c();
        cs.ID__c='00XE0000001AcS5';
        cs.name=UtilConstants.RECALL_MAIL_BPO;
        Email_Template__c cs1 = new Email_Template__c();
        cs1.ID__c='00XE0000001AcS3';
        cs1.name=UtilCOnstants.POST_APPR_REC;
        List<Email_Template__c> temp=new List<Email_Template__c>();
        temp.add(cs);
        temp.add(cs1);
        database.insert(temp,true);
        system.runAs(userlist[0]){
        Profile p = [select id from profile where Name =: Label.System_Admin_Profile limit 1];   
        Test.startTest();
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
            
        Opportunity_Teams__c OppTeam_Obj = new Opportunity_Teams__c(Role__c = NULL,
                                                                Opportunity_Team_Member__c = userObj.id,
                                                                Request_Team_Member__c = False,
                                                               Team_Member_Request_Status__c = 'Assigned',
                                                               opportunity__c=opp.id
                                                               );
        insert OppTeam_Obj; 
            
        Approval_Stage__c appObj_stage = new Approval_Stage__c(opportunity__c=opp.id ,approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL,
                                                             Service_Group__c = utilConstants.BPO,approval_stage_status__c='Pending');
        Database.insert(appObj_stage);

            requestReview3 = new Approval_Request__c();
            requestReview3.approval_request_type__c='SDO Approval';
            requestReview3.comments_by_approver__c='Test Data';
            requestReview3.response_received_date__c=date.parse('06/06/1980'); 
            requestReview3.Requestor__c = userObj.Id;
            requestReview3.Approver__c = userObj1.Id;
            requestReview3.approval_stage__c = appObj_stage.Id;
            requestReview3.Service_Group__c = 'BPO';
            requestReview3.approval_request_status__c= UtilConstants.PEND_WITH_APPR2;
            insert requestReview3;
            System.debug('-------requestReview3-----------'+requestReview3);
            pref = Page.ApproverSection_VFP ;
            pref.getParameters().put('id',requestReview3.id);
            Test.setCurrentPage(pref);
            ApexPages.StandardController con = new ApexPages.StandardController(requestReview3);
            ext = new ApprovalSection(con);
            pref = ext.recallRequest();
            pref = ext.sendReminder();
            Test.stopTest();
        }
    }
 /*
@name : Test3
@Description : 
@Version : 
*/ 
    static testMethod void Test3() {
        User useObj = UtilNovaUnitTest.getUser();
        User useObj1 = UtilNovaUnitTest.getUser1();
        List<user> userlist=new List<user>();
        userlist.add(useObj);
        userlist.add(useObj1);
        insert userlist;
        system.runAs(userlist[0]){
        Profile p = [select id from profile where Name =: Label.System_Admin_Profile limit 1];   
        Test.startTest();
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
            
        Approval_Stage__c appObj_stage = new Approval_Stage__c(opportunity__c=opp.id ,approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL,
                                                             Service_Group__c = utilConstants.BPO,approval_stage_status__c='Pending');
        Database.insert(appObj_stage);
            
            requestReview31 = new Approval_Request__c();
            requestReview31.approval_request_type__c='SDO Approval';
            requestReview31.comments_by_approver__c='Test Data';
            requestReview31.response_received_date__c=date.parse('06/06/1980'); 
            requestReview31.Requestor__c = userObj.Id;
            requestReview31.Approver__c = userObj1.Id;
            requestReview31.approval_stage__c = appObj_stage.Id;
            requestReview31.approval_request_status__c= UtilConstants.PEND_WITH_APPR2;
            requestReview31.Service_Group__c= 'BPO';
            insert requestReview31;
            pref = Page.ApproverSection_VFP ;
            pref.getParameters().put('id',requestReview31.id);
            Test.setCurrentPage(pref);
            ApexPages.StandardController con = new ApexPages.StandardController(requestReview31);
            ext = new ApprovalSection(con);
            pref = ext.sendReminder();
            pref = ext.saveData(); 
            
            //Adding conditions to cover more code on SaveData   
            requestReview31.Service_Group__c = UTILConstants.IO;
            Update requestReview31;
            pref = ext.saveData();
            requestReview31.Service_Group__c = UTILConstants.IC;
            Update requestReview31;
            pref = ext.saveData(); 
            // requestReview31.approval_request_status__c = UTILConstants.APPROVED_STATUS ;           
            Test.stopTest();
        }
    }
/*
@name : Test4
@Description : 
@Version : 
*/  
    static testMethod void Test4() {
       User useObj = UtilNovaUnitTest.getUser();
        User useObj1 = UtilNovaUnitTest.getUser1();
        List<user> userlist=new List<user>();
        userlist.add(useObj);
        userlist.add(useObj1);
        insert userlist;
        Email_Template__c cs = new Email_Template__c();
        cs.ID__c='00XE0000001AcS5';
        cs.name=UtilConstants.RECALL_MAIL_BPO;
        Email_Template__c cs1 = new Email_Template__c();
        cs1.ID__c='00XE0000001AcS3';
        cs1.name=UtilCOnstants.POST_APPR_REC;
        List<Email_Template__c> temp=new List<Email_Template__c>();
        temp.add(cs);
        temp.add(cs1);
        database.insert(temp,true);
        cs.name=UtilConstants.RECALL_MAIL_BPO;
        system.runAs(userlist[0]){
        Profile p = [select id from profile where Name =: Label.System_Admin_Profile limit 1];   
        Test.startTest();
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
            
        Approval_Stage__c appObj_stage = new Approval_Stage__c(opportunity__c=opp.id ,approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL,
                                                             Service_Group__c = utilConstants.BPO,approval_stage_status__c='Pending');
            
             Database.insert(appObj_stage);
            Approval_Request__c requestReview4 = new Approval_Request__c ();
            requestReview4 = new Approval_Request__c();
            requestReview4.approval_request_type__c='SDO Approval';
            requestReview4.comments_by_approver__c='Test Data';
            requestReview4.response_received_date__c=date.parse('06/06/1980'); 
            requestReview4.Requestor__c = userObj.Id;
            requestReview4.Approver__c = userObj.Id;
            requestReview4.approval_stage__c = appObj_stage.Id;
            requestReview4.approval_request_status__c = UTILConstants.APPROVED_STATUS ; //Issue execution of AfterUpdate Trigger.requestTaskComplete: line 7, column 1:  > Class.requestTaskClose.sendMail: line 232, column 1
            requestReview4.Service_Group__c= 'BPO';
            
            insert requestReview4;
            
            pref = Page.ApproverSection_VFP ;
            pref.getParameters().put('id',requestReview4.id);
            Test.setCurrentPage(pref);
            ApexPages.StandardController con = new ApexPages.StandardController(requestReview4);
            ext = new ApprovalSection(con);
            try{
            pref = ext.sendReminder();
            }
            catch(Exception e){
                String msg=e.getMessage();
                system.assert(msg.contains('Attempt to de-reference a null object'));
            }
            pref = ext.saveData();            
            Test.stopTest();
        }
    }
 /*
@name : Test5
@Description : 
@Version : 
*/   
    static testMethod void Test5() {
        User useObj = UtilNovaUnitTest.getUser();
        User useObj1 = UtilNovaUnitTest.getUser1();
        List<user> userlist=new List<user>();
        userlist.add(useObj);
        userlist.add(useObj1);
        insert userlist;
        system.runAs(userlist[0]){
        Profile p = [select id from profile where Name =: Label.System_Admin_Profile limit 1];   
        Test.startTest();
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
            
        Approval_Stage__c appObj_stage = new Approval_Stage__c(opportunity__c=opp.id ,approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL,
                                                             Service_Group__c = 'IO',approval_stage_status__c='Pending');
        Database.insert(appObj_stage);
            
            requestReview31 = new Approval_Request__c();
            requestReview31.approval_request_type__c='SDO Approval';
            requestReview31.comments_by_approver__c='Test Data';
            requestReview31.response_received_date__c=date.parse('06/06/1980'); 
            requestReview31.Requestor__c = userObj.Id;
            requestReview31.Approver__c = userObj1.Id;
            requestReview31.approval_stage__c = appObj_stage.Id;
            requestReview31.approval_request_status__c= UtilConstants.PEND_WITH_APPR2;
            requestReview31.Service_Group__c= 'IO';
            insert requestReview31;
            pref = Page.ApproverSection_VFP ;
            pref.getParameters().put('id',requestReview31.id);
            Test.setCurrentPage(pref);
            ApexPages.StandardController con = new ApexPages.StandardController(requestReview31);
            ext = new ApprovalSection(con);
            pref = ext.sendReminder();
            pref = ext.saveData(); 
            
            //Adding conditions to cover more code on SaveData   
            requestReview31.Service_Group__c = UTILConstants.IO;
            Update requestReview31;
            pref = ext.saveData();
            requestReview31.Service_Group__c = UTILConstants.IC;
            Update requestReview31;
            pref = ext.saveData(); 
            // requestReview31.approval_request_status__c = UTILConstants.APPROVED_STATUS ;           
            Test.stopTest();
        }
    }
/*
@name : Test6
@Description : 
@Version : 
*/  
    static testMethod void Test6() {
        User useObj = UtilNovaUnitTest.getUser();
        User useObj1 = UtilNovaUnitTest.getUser1();
        List<user> userlist=new List<user>();
        userlist.add(useObj);
        userlist.add(useObj1);
        insert userlist;
        system.runAs(userlist[0]){
        Profile p = [select id from profile where Name =: Label.System_Admin_Profile limit 1];   
        Test.startTest();
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
            
        Approval_Stage__c appObj_stage = new Approval_Stage__c(opportunity__c=opp.id ,approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL,
                                                             Service_Group__c = 'IC',approval_stage_status__c='Pending');
        Database.insert(appObj_stage);
            
            requestReview31 = new Approval_Request__c();
            requestReview31.approval_request_type__c='SDO Approval';
            requestReview31.comments_by_approver__c='Test Data';
            requestReview31.response_received_date__c=date.parse('06/06/1980'); 
            requestReview31.Requestor__c = userObj.Id;
            requestReview31.Approver__c = userObj1.Id;
            requestReview31.approval_stage__c = appObj_stage.Id;
            requestReview31.approval_request_status__c= UtilConstants.PEND_WITH_APPR2;
            requestReview31.Service_Group__c= 'IC';
            insert requestReview31;
            pref = Page.ApproverSection_VFP ;
            pref.getParameters().put('id',requestReview31.id);
            Test.setCurrentPage(pref);
            ApexPages.StandardController con = new ApexPages.StandardController(requestReview31);
            ext = new ApprovalSection(con);
            pref = ext.sendReminder();
            pref = ext.saveData(); 
            
            //Adding conditions to cover more code on SaveData   
            requestReview31.Service_Group__c = UTILConstants.IO;
            Update requestReview31;
            pref = ext.saveData();
            requestReview31.Service_Group__c = UTILConstants.IC;
            Update requestReview31;
            pref = ext.saveData(); 
            // requestReview31.approval_request_status__c = UTILConstants.APPROVED_STATUS ;           
            Test.stopTest();
        }
    }
}