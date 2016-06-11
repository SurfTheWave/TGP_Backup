/*
Author : Vinay Kumar Chada
Story  :   
Description : Test Class for RivewAndApprovalInboundEmailTest. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/

@isTest
private class RivewAndApprovalInboundEmailTest{
 
static Request_Review__c requestReview;
static Task ts;

public static void setupData(){
// To create a Request Review
requestReview = new Request_Review__c();
    requestReview.Review_type__c='Test Data';
    requestReview.Comments_by_SA__c='Test Data';
    requestReview.Comments_by_approver__c='Test Data';
    requestReview.Approval_email_sent_on__c=date.parse('06/06/1980'); 
    requestReview.Response_received_on__c=date.parse('06/06/1980');
    requestReview.Send_reminder__c=false;
    requestReview.Select_reviewer__c=false;
    requestReview.Status__c='test';
    insert requestReview;

}

/*public static void setupData(){

}*/

public static void setupData5(){
// To create a Request Review
requestReview = new Request_Review__c();
    requestReview.Review_type__c='Test Data';
    requestReview.Comments_by_SA__c='Test Data';
    requestReview.Comments_by_approver__c='Test Data';
    requestReview.Approval_email_sent_on__c=date.parse('06/06/1980'); 
    requestReview.Response_received_on__c=date.parse('06/06/1980');
    requestReview.Send_reminder__c=false;
    requestReview.Select_reviewer__c=false;
    requestReview.Status__c='Approved';
    insert requestReview;

}

public static void setupData1(){
// To create a Task
    ts = new Task();
    ts.Approval_Status__c='Approved';
    ts.Request_Review_Id__c=requestReview.id;
    insert ts;
}
public static void testCreateContactFrmEmail() {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();  
        email.plainTextBody = '< approved >'+'#'+requestReview.id+'#';      
        String reviewId = email.plainTextBody.substringBetween('#'); 
        RivewAndApprovalInboundEmail creatC = new RivewAndApprovalInboundEmail();
        creatC.handleInboundEmail(email, env );
    }
 public static void testCreateContactFrmEmail_1() {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();  
        email.plainTextBody = '#'+requestReview.id+'#'+'<rejected>';      
        String reviewId = email.plainTextBody.substringBetween('#'); 
        RivewAndApprovalInboundEmail creatC = new RivewAndApprovalInboundEmail();
        creatC.handleInboundEmail(email, env );
    }
public static void testCreateContactFrmEmail_2() {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();  
        email.plainTextBody = '#'+requestReview.id+'#'+'<Rework>';      
        String reviewId = email.plainTextBody.substringBetween('#'); 
        RivewAndApprovalInboundEmail creatC = new RivewAndApprovalInboundEmail();
        creatC.handleInboundEmail(email, env );
    }   
static testMethod void test1(){
test.starttest();
    setupData();
    setupData1();
    testCreateContactFrmEmail();
test.stoptest();    

 }   

static testMethod void testX(){
test.starttest();
    setupData5();
    setupData1();
    testCreateContactFrmEmail();
    testCreateContactFrmEmail_2();
test.stoptest();    

 }    
 
static testMethod void test2(){
test.starttest();
    setupData();
    setupData1();
    testCreateContactFrmEmail_1();
test.stoptest();    

 } 
 static testMethod void test3(){
test.starttest();
    setupData();
    setupData1();
    testCreateContactFrmEmail_2();
test.stoptest();    

 } 
}