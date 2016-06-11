@IsTest(seeAllData= True)
public class CreateApprovalDocument_VFC_Test{
    private static CreateApprovalDocument_VFC ext;
    private static Approval_Request__c requestReview3;
    private static PageReference pref;
    private static User testUser;
    private static Decimal testDecimal = 100;
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
        /*
        List<Email_Template__c> temp=new List<Email_Template__c>();
        Email_Template__c cs = new Email_Template__c();
        cs.ID__c='00XE0000001AcS5';
        cs.name=UtilConstantsforSWB.ApprovalMailBPO;
        Email_Template__c cs1 = new Email_Template__c();
        cs1.ID__c='00XE0000001AcS3';
        cs1.name=UtilConstantsforSWB.FinalApprovalBPO;
        
        temp.add(cs);
        temp.add(cs1);
        cs1 = new Email_Template__c();
        cs1.ID__c='00XE0000001AcS3';
        cs1.name=UtilConstantsforSWB.ApprovalMailIC;
        temp.add(cs1);
        cs1.ID__c='00XE0000001AcS3';
        cs1.name=UtilConstantsforSWB.ApprovalMailIO;
        temp.add(cs1);
        database.insert(temp,true);
        */
        system.runAs(userlist[0]){
        Profile p = [select id from profile where Name =: Label.System_Admin_Profile limit 1];   
        
        User_Master__c userObj = new User_Master__c(Name = 'TestUser',User__c = userlist[0].id,email__c=userlist[0].email);
        User_Master__c userObj1 = new User_Master__c(Name = 'SolTestUser',User__c = userlist[1].id,email__c=userlist[1].email);
        insert(userObj);
        insert(userObj1);
            
         List<Opportunity_Roles_Master__c > oppRoles = new List<Opportunity_Roles_Master__c > ();   
         Opportunity_Roles_Master__c oppRoleMaster = new Opportunity_Roles_Master__c(Name = UtilConstants.OPP_SOL_LEAD, Description__c = UtilConstants.TEST_DESC, 
                                                                                    HaveEditAccessOnOpportunity__c= true, ShouldReceiveAlertMail__c = False);
         oppRoles.add(oppRoleMaster);
        oppRoleMaster = new Opportunity_Roles_Master__c(Name = UtilConstants.IC_OP_SOL_LEAD, Description__c = UtilConstants.TEST_DESC, 
                                                                                    HaveEditAccessOnOpportunity__c= true, ShouldReceiveAlertMail__c = False);
         oppRoles.add(oppRoleMaster);
        insert oppRoles;   
        
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
        
        List<Opportunity_Teams__c > oppTeam_Obj = new List<Opportunity_Teams__c >();
        Opportunity_Teams__c OppTeam_Obj1 = new Opportunity_Teams__c(Role__c = oppRoles[0].Id,    Opportunity_Team_Member__c = userObj.id,
                                                                Request_Team_Member__c = False, Team_Member_Request_Status__c = 'Assigned',
                                                               opportunity__c=opp.id  );
         OppTeam_Obj.add(OppTeam_Obj1);
        OppTeam_Obj1 = new Opportunity_Teams__c(Role__c = oppRoles[1].Id,    Opportunity_Team_Member__c = userObj.id,
                                                                Request_Team_Member__c = False, Team_Member_Request_Status__c = 'Assigned',
                                                               opportunity__c=opp.id  );
         OppTeam_Obj.add(OppTeam_Obj1);
        insert OppTeam_Obj; 
            
        Approval_Stage__c appObj_stage = new Approval_Stage__c(opportunity__c=opp.id ,approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL,
                                                             Service_Group__c = utilConstants.BPO,approval_stage_status__c='Pending');
        Database.insert(appObj_stage);
           
        
        opportunity_documents__c OppDocs= new opportunity_documents__c(document__c = 'Test Doc' ,Document_Link__c = 'Junk Link text', opportunity__c =opp.Id, type__c = 'Overall Solution Plan Deck',
                                                                            modified_by__c='test user');
           insert oppDocs; 
                 
           Test.startTest();
           List<Approval_Request__c > requestReview3List = new List<Approval_Request__c >();
           
            requestReview3 = new Approval_Request__c();
            requestReview3.SharePoint_Links__c = 
            requestReview3.approval_request_type__c='SDO Approval';
            requestReview3.comments_by_approver__c='Test Data';
            requestReview3.response_received_date__c=date.parse('06/06/1980'); 
            requestReview3.Requestor__c = userObj.Id;
            requestReview3.Approver__c = userObj1.Id;
            requestReview3.approval_stage__c = appObj_stage.Id;
            requestReview3.Service_Group__c = 'BPO';
            requestReview3.approval_request_status__c= UtilConstantsforSWB.PendingwithApprover;
            requestReview3List.add(requestReview3);
            
            requestReview3 = new Approval_Request__c();
            requestReview3.approval_request_type__c='SDO Approval';
            requestReview3.comments_by_approver__c='Test Data';
            requestReview3.response_received_date__c=date.parse('06/06/1980'); 
            requestReview3.Requestor__c = userObj.Id;
            requestReview3.Approver__c = userObj1.Id;
            requestReview3.approval_stage__c = appObj_stage.Id;
            requestReview3.Service_Group__c = 'BPO';
            requestReview3.approval_request_status__c= UtilConstants.APPROVED_STATUS;
            requestReview3List.add(requestReview3);
            
            requestReview3 = new Approval_Request__c();
            requestReview3.approval_request_type__c='SDO Approval';
            requestReview3.comments_by_approver__c='Test Data';
            requestReview3.response_received_date__c=date.parse('06/06/1980'); 
            requestReview3.Requestor__c = userObj.Id;
            requestReview3.Approver__c = userObj1.Id;
            requestReview3.approval_stage__c = appObj_stage.Id;
            requestReview3.Service_Group__c = UtilConstants.IO;
            requestReview3.approval_request_status__c= UtilConstantsforSWB.PendingwithApprover;
            requestReview3List.add(requestReview3);
            
            requestReview3 = new Approval_Request__c();
            requestReview3.approval_request_type__c=UtilConstants.FIN_APPRIC;
            requestReview3.comments_by_approver__c='Test Data';
            requestReview3.response_received_date__c=date.parse('06/06/1980'); 
            requestReview3.Requestor__c = userObj.Id;
            requestReview3.Approver__c = userObj1.Id;
            requestReview3.approval_stage__c = appObj_stage.Id;
            requestReview3.Service_Group__c = UtilConstants.IC;
            requestReview3.approval_request_status__c= UtilConstantsforSWB.PendingwithApprover;
            requestReview3List.add(requestReview3);
            
            requestReview3 = new Approval_Request__c();
            requestReview3.approval_request_type__c=UtilConstants.FIN_APPRIC;
            requestReview3.comments_by_approver__c='Test Data';
            requestReview3.response_received_date__c=date.parse('06/06/1980'); 
            requestReview3.Requestor__c = userObj.Id;
            requestReview3.Approver__c = userObj1.Id;
            requestReview3.approval_stage__c = appObj_stage.Id;
            requestReview3.Service_Group__c = UtilConstants.IC;
            requestReview3.approval_request_status__c= UtilConstants.PEND_WITH_REQSTR;
            requestReview3List.add(requestReview3);
            
            requestReview3 = new Approval_Request__c();
            requestReview3.approval_request_type__c=UtilConstants.FIN_APPRIC;
            requestReview3.comments_by_approver__c='Test Data';
            requestReview3.response_received_date__c=date.parse('06/06/1980'); 
            requestReview3.Requestor__c = userObj.Id;
            requestReview3.Approver__c = userObj1.Id;
            requestReview3.approval_stage__c = appObj_stage.Id;
            requestReview3.Service_Group__c = UtilConstants.IC;
            requestReview3.approval_request_status__c= UtilConstants.PEND_WITH_APPR2;
            requestReview3List.add(requestReview3);
            
            insert requestReview3List;
                                                                   
            List<Approval_Request__c> reqList = [SELECT Id, Name FROM Approval_Request__c WHERE approval_stage__r.opportunity__c = :opp.Id ];
            System.debug('-------requestReview3-----------'+requestReview3  + reqList);
            List<String> apprList = new List<String>();
             List<String> idparamList = new List<String>();
            String idparam = '';
            
            for(Approval_Request__c ap : reqList){
                apprList.add(ap.Id);
                idparam=+ap.Id + ',';
            }
            
            pref = Page.OpportunityDocumentsPopup_VFP;
            pref.getParameters().put('id',opp.id);
            pref.getParameters().put('list',idparam.substring(0, idParam.length()-1));
            Test.setCurrentPage(pref);
            ApexPages.StandardController con = new ApexPages.StandardController(opp);
            ext = new CreateApprovalDocument_VFC(con);
            //pref = CreateApprovalDocument_VFC.recallRequest();
            
            List<String> docList = new List<String>{oppDocs.Id};
           /* List<approval_request__c> apList = [SELECT approver__c, approver__r.user__c,
                                             Service_Group__c,Opportunity_Id_Dev__c,approval_sent_date__c,approver__r.Email__c,
                                             requestor__c,approval_request_type__c,approval_request_status__c, 
                                             id,SharePoint_Links__c,( SELECT Name,
                                             approval_document__r.document__c,Document_Sharepoint_Link_DEV__c,
                                             Opportunity_Approval_Request__c from approval_documents__r where 
                                             approval_document__c in : docList  limit 5000) FROM approval_request__c 
                                             where id in :apprList limit 5000];
            
            */
            
            CreateApprovalDocument_VFC.sendReminder(apprList);
            CreateApprovalDocument_VFC.createApprovalDocumentsMethod( new List<String>{oppDocs.Id}, apprList);
            List<Approval_documents__c> apDocList = [SELECT Name,approval_document__r.document__c,Document_Sharepoint_Link_DEV__c,  Opportunity_Approval_Request__c 
                                             FROM Approval_documents__c WHERE Opportunity_Approval_Request__r.Approval_Stage__r.Opportunity__c = :opp.Id ];
            System.debug('List>>>> ' + apDocList );
            
            List<String> apprvlDocs = new List<String>();
            for(Approval_documents__c  ap : apDocList){
                apprvlDocs.add(ap.id);
            }   
            
            CreateApprovalDocument_VFC.approvalDocumentsReminderCreateDocument( new List<String>{oppDocs.Id}, apprvlDocs);
            CreateApprovalDocument_VFC.updateRecall(requestReview3List[0].Id);
            //CreateApprovalDocument_VFC cApd = new CreateApprovalDocument_VFC();
            ext.createApprovalDocuments();
            Test.stopTest();
        }
    }
}