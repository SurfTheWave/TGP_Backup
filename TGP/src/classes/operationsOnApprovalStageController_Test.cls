/******************************
   @Author       : 
   @Class name   : operationsOnApprovalStageController_Test
   @CreateDate   : 
   @Description : 
   @Version : 1.0 
*******************************/
@isTest(SeeAllData=true)
private class operationsOnApprovalStageController_Test{
     /******************************
     * Method Name: Test1
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/ 
    static testMethod void Test1() {
        User stdUser = UtilNovaUnitTest.getUser();
        Profile p = [select id from profile where Name =: Label.System_Admin_Profile limit 1];   
        stdUser.profileid = p.Id;
        System.runAs(stdUser) {
            Test.startTest();
            
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
            //requestReview.Requestor__r.Email__c='abc@accenture.com';
            User_Master__c Approver = new User_Master__c();   //Added for null pointer error
            Approver.Name = 'TestUserMaster';
            Approver.Email__c=stdUser.Email;
            insert Approver;
            requestReview3.Approver__c = Approver.Id;
            // requestReview.Approver__r.Email__c='abc@accenture.com';
            // requestReview.Approver__c=' a0Qc00000029TCh';  //Why is this hard coded?
            //ApprovalStage.Name = 'TestApprovalStage';
            //ApprovalStage.opportunity__c = '006c000000CoVkzAAF'; //Added to check if the code working
            // ApprovalStage.approval_stage_type__c = 'Stage 1 - Solution Approval';
            // ApprovalStage.version__c = 'V1';
            //  insert ApprovalStage;
            requestReview3.approval_stage__c = ApprovalStage.Id;
            requestReview3.Service_Group__c = UtilConstants.BPO;
            requestReview3.approval_request_status__c ='Not Sent'; //Trigger Issue
           // requestReview3.approval_request_status__c= UtilConstants.REJECT_STATUS;
            requestReview3.approval_sent_date__c = System.Today() + 3 ;
            insert requestReview3;
            Delete ApprovalStage;
            Test.stopTest();
        }
    }
    /******************************
     * Method Name: Test2
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/ 
    static testMethod void Test2() {
        User stdUser = UtilNovaUnitTest.getUser();
        Profile p = [select id from profile where Name =: Label.System_Admin_Profile limit 1];   
        stdUser.profileid = p.Id;
        System.runAs(stdUser) {
            Test.startTest();
            
            List<Opportunity> oppList = UnitTestDatafactory.createOppList('TestOppty',1);
            List<Approval_stage__c> ApprovalStageList = new List<Approval_stage__c>();
            Approval_stage__c ApprovalStage1 = new Approval_stage__c();
            ApprovalStage1.opportunity__c = oppList[0].id;
            ApprovalStage1.Service_Group__c = 'BPO';
            ApprovalStage1.approval_stage_type__c = utilConstants.STAGE3_SOL_APPROVAL;
            ApprovalStageList.add(ApprovalStage1);
            Approval_stage__c ApprovalStage2 = new Approval_stage__c();
            ApprovalStage2.opportunity__c = oppList[0].id;
            ApprovalStage2.Service_Group__c ='BPO';
            ApprovalStage2.approval_stage_type__c = utilConstants.STAGE2_SOL_APPROVAL;
            ApprovalStageList.add(ApprovalStage2);
            Approval_stage__c ApprovalStage3 = new Approval_stage__c();
            ApprovalStage3.opportunity__c = oppList[0].id;
            ApprovalStage3.Service_Group__c = 'BPO';
            ApprovalStage3.approval_stage_type__c = utilConstants.STAGE1_SOL_APPROVAL;
            ApprovalStageList.add(ApprovalStage3);
            Insert ApprovalStageList;
            Delete ApprovalStageList;
            Test.stopTest();
        }
    }
    
    /******************************
     * Method Name: Test2
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/ 
     static testMethod void Test3() {
        User stdUser = UtilNovaUnitTest.getUser();
        Profile p = [select id from profile where Name =: Label.System_Admin_Profile limit 1];   
        stdUser.profileid = p.Id;
        System.runAs(stdUser) {
            Test.startTest();
            
            List<Opportunity> oppList3 = UnitTestDatafactory.createOppList('TestOppty',1);
            List<Approval_stage__c> ApprovalStageList8 = new List<Approval_stage__c>();
            Approval_stage__c ApprovalStage12 = new Approval_stage__c();
            ApprovalStage12.opportunity__c = oppList3[0].id;
            ApprovalStage12.Service_Group__c = 'BPO';
            ApprovalStage12.approval_stage_type__c = utilConstants.STAGE3_SOL_APPROVAL;
            ApprovalStageList8.add(ApprovalStage12);
            Approval_stage__c ApprovalStage25 = new Approval_stage__c();
            ApprovalStage25.opportunity__c = oppList3[0].id;
            ApprovalStage25.Service_Group__c ='BPO';
            ApprovalStage25.approval_stage_type__c = utilConstants.STAGE2_SOL_APPROVAL;
            ApprovalStageList8.add(ApprovalStage25);
            Approval_stage__c ApprovalStage35 = new Approval_stage__c();
            ApprovalStage35.opportunity__c = oppList3[0].id;
            ApprovalStage35.Service_Group__c = 'BPO';
            ApprovalStage35.approval_stage_type__c = utilConstants.STAGE1_SOL_APPROVAL;
            ApprovalStageList8.add(ApprovalStage35);
            
            Approval_stage__c ApprovalStage45 = new Approval_stage__c();
            ApprovalStage45.opportunity__c = oppList3[0].id;
            ApprovalStage45.Service_Group__c = 'IO';
            ApprovalStage45.approval_stage_type__c = utilConstants.STAGE1_SOL_APPROVAL;
            ApprovalStageList8.add(ApprovalStage45);
            
            Approval_stage__c ApprovalStage55 = new Approval_stage__c();
            ApprovalStage55.opportunity__c = oppList3[0].id;
            ApprovalStage55.Service_Group__c = 'IC';
            ApprovalStage55.approval_stage_type__c = utilConstants.STAGE1_SOL_APPROVAL;
            ApprovalStageList8.add(ApprovalStage55);
            
            Insert ApprovalStageList8;
            operationsOnApprovalStageController.validateBeforeDelete(ApprovalStageList8);
            operationsOnApprovalStageController.setVersion(ApprovalStageList8);
            operationsOnApprovalStageController.reSetVersion(ApprovalStageList8);
            
            
            Test.stopTest();
        }
    }
}