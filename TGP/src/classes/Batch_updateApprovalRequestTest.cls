@isTest
/*
*@author:Vaishnavi 
*@createdDate:24/12/2015
*@Description: Test class for Batch_updateApprovalRequest class
*/
private class Batch_updateApprovalRequestTest
{
    public static User_Master__c TestUserMaster;
    public static Opportunity TestOpportunity;
    public static Opportunity TestOpportunity1;
    public static Approval_Stage__c TestApprovalStage;
    public static Approval_Stage__c TestApprovalStage2;
    public static approval_request__c TestApprovalRequest1;
    public static approval_request__c TestApprovalRequest2;
    public static approval_request__c TestApprovalRequest3;
    public static approval_request__c TestApprovalRequest4;
    public static approval_request__c TestApprovalRequest5;
    public static approval_request__c TestApprovalRequest6;
    public static approval_request__c TestApprovalRequest7;
    public static approval_request__c TestApprovalRequest8;
    public static approval_request__c TestApprovalRequest9;
    public static approval_request__c TestApprovalRequest10;
    //public static List<approval_request__c> appReqList;
    
    @testSetup static void setup()
    {
        TestUserMaster = new User_Master__c();
        TestUserMaster.Active__c = TRUE;
        TestUserMaster.User__c = '005E0000006CTLz';
        insert TestUserMaster;
    
        List<Opportunity> oppList = UnitTestDatafactory.createOppList('TEST_OPPortunity',1);
        
        TestApprovalStage = new Approval_Stage__c();
        TestApprovalStage.Opportunity__c = oppList[0].ID;
        TestApprovalStage.approval_stage_type__c = 'Stage 1 - Solution Approval';
        TestApprovalStage.approval_stage_status__c = 'Pending';
        insert TestApprovalStage; 
        
       
        TestApprovalRequest1 = new approval_request__c();
        TestApprovalRequest1.Service_Group__c = 'IO';
        TestApprovalRequest1.Approval_Stage__c = TestApprovalStage.ID;
        TestApprovalRequest1.approval_request_type__c = 'DCSO Approval';
        TestApprovalRequest1.Approver__c = TestUserMaster.ID;
        TestApprovalRequest1.approval_request_status__c = 'Approved';
        insert TestApprovalRequest1;
        
        TestApprovalRequest2 = new approval_request__c();
        TestApprovalRequest2.Service_Group__c = 'IO';
        TestApprovalRequest2.Approval_Stage__c = TestApprovalStage.ID;
        TestApprovalRequest2.approval_request_type__c = 'Solution Plan Approval';
        TestApprovalRequest2.Approver__c = TestUserMaster.ID;
        TestApprovalRequest2.approval_request_status__c = 'Not Sent';
        insert TestApprovalRequest2;
                      
        TestApprovalRequest3 = new approval_request__c();
        TestApprovalRequest3.Service_Group__c = 'IO';
        TestApprovalRequest3.Approval_Stage__c = TestApprovalStage.ID;
        TestApprovalRequest3.approval_request_type__c = 'IO Final Approval';
        TestApprovalRequest3.Approver__c = TestUserMaster.ID;
        TestApprovalRequest3.approval_request_status__c = 'Pending';
        insert TestApprovalRequest3;
        
        TestApprovalRequest4 = new approval_request__c();
        TestApprovalRequest4.Service_Group__c = 'IO';
        TestApprovalRequest4.Approval_Stage__c = TestApprovalStage.ID;
        TestApprovalRequest4.approval_request_type__c = 'Solution Plan Approval';
        TestApprovalRequest4.Approver__c = TestUserMaster.ID;
        TestApprovalRequest4.approval_request_status__c = 'Approved';
        insert TestApprovalRequest4;
        
        TestApprovalRequest5 = new approval_request__c();
        TestApprovalRequest5.Service_Group__c = 'IO';
        TestApprovalRequest5.Approval_Stage__c = TestApprovalStage.ID;
        TestApprovalRequest5.approval_request_type__c = 'Solution Plan Approval';
        TestApprovalRequest5.Approver__c = TestUserMaster.ID;
        TestApprovalRequest5.approval_request_status__c = 'Approved';
        insert TestApprovalRequest5;   
                  
        
    }
    
       
    private static testmethod void doTest()
    {  
        
        Test.startTest();
        
        //Batch_updateApprovalRequest batchvr = new Batch_updateApprovalRequest();
        Batch_deleteApprovalRequest batchvr = new Batch_deleteApprovalRequest();
        Database.executeBatch(batchvr);
        
        Test.stopTest();
        
        
        
        
    }
    
    
    
}