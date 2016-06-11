/*
Author : Vinay Kumar Chada
Story  :   
Description : Test Class for SharepointInboundEmail. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/

@isTest
private class SharepointInboundEmailTest{

    static User testUser; 


    public static void testCreateContactFrmEmail() {
    
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
    
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        
        email.ccAddresses = new String[] {'user@acme.com'};
        email.fromAddress = 'test@test.com';
        env.toAddress = 'test1@test1.com';
          
        email.plainTextBody = 'BPOSD<https://adtkm2amr1.accenture.com/sites/BPOSD>' + '\n' +'itworks.pptx has been added' +
        
        '\n' + 'Modify my alert settings<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/MySubs.aspx>' + '\n' +
        
        'View itworks.pptx<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/PowerPoint.aspx?PowerPointView=ReadingView%26PresentationId=/sites/BPOSD/Opportunity%2520Documents%2520%2520Documents/BAE%2520%60%60%60%2520SYSTEMS%2520PLC%2520--%2520UST%2520%60%60%2520testing%25207/1.%2520Required%2520Documents/itworks.pptx>' + '\n' +
        
        'View Opportunity Documents - Documents<https://adtkm2amr1.accenture.com/sites/BPOSD/Opportunity%20Documents%20%20Documents>' + '\n' +
       
        'Mobile View<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/mobile/dispform.aspx?List=D0D20AD4-674F-4292-B7D6-1915692D0889&ID=2903>' + '\n' +
        
        'Last Modified 7/2/2014 8:12 AM by DIR\\sara.r.percival';      
        //String reviewId = email.plainTextBody.substringBetween('#'); 
        SharepointInboundEmail sharePointEmail = new SharepointInboundEmail();
        sharePointEmail.handleInboundEmail(email, env );
    }
    
    public static void testCreateContactFrmEmail1() {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        
        email.ccAddresses = new String[] {'user@acme.com'};
        email.fromAddress = 'test@test.com';
        env.toAddress = 'test1@test1.com';
          
        email.plainTextBody = 'BPOSD<https://adtkm2amr1.accenture.com/sites/BPOSD>' + '\n' +'itworks.pptx has been changed' +
        
        '\n' + 'Modify my alert settings<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/MySubs.aspx>' + '\n' +
        
        'View itworks.pptx<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/PowerPoint.aspx?PowerPointView=ReadingView%26PresentationId=/sites/BPOSD/Opportunity%2520Documents%2520%2520Documents/BAE%2520SYSTEMS%2520PLC%2520--%2520UST%2520%60%60%2520testing%25207/1.%2520Required%2520Documents/itworks.pptx>' + '\n' +
        
        'View Opportunity Documents - Documents<https://adtkm2amr1.accenture.com/sites/BPOSD/Opportunity%20Documents%20%20Documents>' + '\n' +
       
        'Mobile View<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/mobile/dispform.aspx?List=D0D20AD4-674F-4292-B7D6-1915692D0889&ID=2903>' + '\n' +
        
        'Last Modified 7/2/2014 8:12 AM by DIR\\sara.r.percival';      
        //String reviewId = email.plainTextBody.substringBetween('#'); 
        SharepointInboundEmail sharePointEmail = new SharepointInboundEmail();
        sharePointEmail.handleInboundEmail(email, env );
    }
    
    public static void testCreateContactFrmEmail2() {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        
        email.ccAddresses = new String[] {'user@acme.com'};
        email.fromAddress = 'test@test.com';
        env.toAddress = 'test1@test1.com';
          
        email.plainTextBody = 'BPOSD<https://adtkm2amr1.accenture.com/sites/BPOSD>' + '\n' +'itworks.pptx has been deleted' +
        
        '\n' + 'Modify my alert settings<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/MySubs.aspx>' + '\n' +
        
        'View Opportunity Documents - Documents<https://adtkm2amr1.accenture.com/sites/BPOSD/Opportunity%20Documents%20%20Documents>' + '\n' +
       
        'Mobile View<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/mobile/dispform.aspx?List=D0D20AD4-674F-4292-B7D6-1915692D0889&ID=2903>' + '\n' +
        
        'Last Modified 7/2/2014 8:12 AM by DIR\\sara.r.percival';      
        //String reviewId = email.plainTextBody.substringBetween('#'); 
        SharepointInboundEmail sharePointEmail = new SharepointInboundEmail();
        sharePointEmail.handleInboundEmail(email, env );
    }
    
    static testMethod void test1(){
        test.starttest();
            testCreateContactFrmEmail();
        test.stoptest();    
    }
    
    static testMethod void test2(){
        test.starttest();
            testCreateContactFrmEmail2();
        test.stoptest();    
    }
    
    static testMethod void test3(){
        test.starttest();
            testCreateContactFrmEmail1();
        test.stoptest();    
    }   
}