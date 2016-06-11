/*
@Author and Created Date : System
@name : OperationsOnApprovalDocument_Test
@Description : 
@Version : 
*/
@isTest(SeeAllData=false)
private class OperationsOnApprovalDocument_Test{
    /******************************
    Method Name: test1
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    static testMethod void test1(){
        User stdUser = UtilNovaUnitTest.getUser();
        Profile p = [select id from profile where Name =: Label.System_Admin_Profile limit 1];   
        stdUser.profileid = p.Id;
        System.runAs(stdUser) {
            test.starttest();
            List<Opportunity> oppList = UnitTestDatafactory.createOppList('UnitTest Opportunity',1);
            opportunity_documents__c OppDocs= new opportunity_documents__c(document__c = 'Test Doc' ,Document_Link__c = 'Junk Link text', opportunity__c = oppList[0].Id,type__c = 'Overall Solution Plan Deck',
                                                                            modified_by__c='test user'
                                                                          
                                                                          );
            opportunity_documents__c OppDocs2= new opportunity_documents__c(document__c = 'Test Doc1' ,Document_Link__c = 'Junk Link text', opportunity__c = oppList[0].Id,type__c = 'Overall Solution Plan Deck'
                                                                          );
            List<opportunity_documents__c> oppdoclist=new List<opportunity_documents__c>();
            oppdoclist.add(OppDocs);
            oppdoclist.add(OppDocs2);
            insert oppdoclist;
            User_Master__c UserMasterRef0= new User_Master__c();
            UserMasterRef0.Name = 'UserMasterTest0';
            Insert UserMasterRef0;
            
            Approval_Request__c ApprovalReqRef = new Approval_Request__c();
            ApprovalReqRef.approval_request_type__c='SDO Approval';
            ApprovalReqRef.comments_by_approver__c='Test Data';
            ApprovalReqRef.response_received_date__c=date.parse('06/06/1980'); 
            User_Master__c Requestor = new User_Master__c();   //Added for null pointer error
            Requestor.Name = 'TestUserMaster';
            Requestor.Email__c='abc@accenture.com';
            insert Requestor;
            ApprovalReqRef.Requestor__c = Requestor.Id;
            
            User_Master__c Approver = new User_Master__c();   //Added for null pointer error
            Approver.Name = 'TestUserMaster';
            Approver.Email__c='abc@accenture.com';
            insert Approver;
            ApprovalReqRef.Approver__c = Approver.Id;
            
            Approval_Stage__c ApprovalStage = new Approval_Stage__c ();
            ApprovalStage.opportunity__c = oppList[0].id;
            ApprovalStage.Service_Group__c = 'BPO';
            ApprovalStage.approval_stage_type__c = utilConstants.FLY_BY_SOL_REVIEW;
            Insert ApprovalStage;
            ApprovalReqRef.approval_stage__c = ApprovalStage.Id;
            
            ApprovalReqRef.approval_request_status__c= UtilConstants.PEND_WITH_APPR2;
            insert ApprovalReqRef;
            approval_documents__c ADocs1 = new approval_documents__c(active__c = true,approval_document__c = oppdoclist[0].Id,Opportunity_Approval_Request__c = ApprovalReqRef.Id);
            approval_documents__c ADocs2 = new approval_documents__c(active__c = true,approval_document__c = oppdoclist[0].Id,Opportunity_Approval_Request__c = ApprovalReqRef.Id);
            approval_documents__c ADocs3 = new approval_documents__c(active__c = true,approval_document__c = oppdoclist[1].Id,Opportunity_Approval_Request__c = ApprovalReqRef.Id);
            List<approval_documents__c> ADocs=new List<approval_documents__c>();
            ADocs.add(ADocs1);
            ADocs.add(ADocs3);
            database.insert(ADocs,false) ;
            try{
            insert ADocs2 ;
            }
            Catch(Exception e){
                String msg=e.getMessage();
                system.assert(msg.contains('Already this document in use'));
            }
            test.stoptest();
      }
      }  
}