/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class SharePointInboundEmailNewTest {
    
    private static User testUser; 

/******************************
    Method Name: testCreateContactFrmEmail
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public static void testCreateContactFrmEmail() {
    
         Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.SYSTEM_ADMIN);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
    
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        
        email.ccAddresses = new String[] {'user@acme.com'};
        email.fromAddress = 'test@test.com';
        env.toAddress = 'test1@test1.com';
        email.subject= 'E2E Workbench Shared Folders: TestSP2SF - To TeST---Test Mohan 123.docx';
          
        email.plainTextBody = 'BPOSD<https://adtkm2amr1.accenture.com/sites/BPOSD>' + '\n' +'itworks.pptx has been added' +
        
        '\n' + 'Modify my alert settings<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/MySubs.aspx>' + '\n' +
        
        'View itworks.pptx<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/PowerPoint.aspx?PowerPointView=ReadingView%26PresentationId=/sites/BPOSD/Opportunity%2520Documents%2520%2520Documents/BAE%2520%60%60%60%2520SYSTEMS%2520PLC%2520--%2520UST%2520%60%60%2520testing%25207/1.%2520Required%2520Documents/itworks.pptx>' + '\n' +
        
        'View Opportunity Documents - Documents<https://adtkm2amr1.accenture.com/sites/BPOSD/Opportunity%20Documents%20%20Documents>' + '\n' +
       
        'Mobile View<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/mobile/dispform.aspx?List=D0D20AD4-674F-4292-B7D6-1915692D0889&ID=2903>' + '\n' +
        
        'Last Modified 7/2/2014 8:12 AM by DIR\\sara.r.percival';      
        //String reviewId = email.plainTextBody.substringBetween('#'); 
        SharePointInboundEmailNew sharePointEmail = new SharePointInboundEmailNew();
        sharePointEmail.handleInboundEmail(email, env );
    }
    /******************************
    Method Name: testCreateContactFrmEmail1
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
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
        SharePointInboundEmailNew sharePointEmail = new SharePointInboundEmailNew();
        sharePointEmail.handleInboundEmail(email, env );
    }
    /******************************
    Method Name: testCreateContactFrmEmail2
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
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
        SharePointInboundEmailNew sharePointEmail = new SharePointInboundEmailNew();
       // sharePointEmail.handleInboundEmail(email, env );
    }
    /******************************
    Method Name: test1
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    static testMethod void test1(){
        test.starttest();
            testCreateContactFrmEmail();
        test.stoptest();    
    }
    /******************************
    Method Name: test2
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    static testMethod void test2(){
        test.starttest();
            testCreateContactFrmEmail2();
        test.stoptest();    
    }
    /******************************
    Method Name: test3
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    static testMethod void test3(){
        test.starttest();
            testCreateContactFrmEmail1();
        test.stoptest();    
    }   
    /******************************
    Method Name: testCreateContactEmail4
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public static void testCreateContactEmail4(){
    
         Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.SYSTEM_ADMIN);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
    
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        
        email.ccAddresses = new String[] {'user@acme.com'};
        email.fromAddress = 'test@test.com';
        env.toAddress = 'test1@test1.com';
        email.subject= 'E2E Workbench Shared Folders: TestSP2SF - To TeST---Test Mohan 123.docx';
        
    email.plainTextBody = 'BPOSD<https://adtkm2amr1.accenture.com/sites/BPOSD>' + '\n' +'itworks.pptx has been added' +
        
        '\n' + 'Modify my alert settings<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/MySubs.aspx>' + '\n' +
        
        'View itworks.pptx<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/PowerPoint.aspx?PowerPointView=ReadingView%26PresentationId=/sites/BPOSD/Opportunity%2520Documents%2520%2520Documents/BAE%2520%60%60%60%2520SYSTEMS%2520PLC%2520--%2520UST%2520%60%60%2520testing%25207/1.%2520Required%2520Documents/itworks.pptx>' + '\n' +
        
         '\n' +
       
        'Mobile View<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/mobile/dispform.aspx?List=D0D20AD4-674F-4292-B7D6-1915692D0889&ID=2903>' + '\n' +
        
        'Last Modified 7/2/2014 8:12 AM by DIR\\sara.r.percival';
        SharePointInboundEmailNew sharePointEmail = new SharePointInboundEmailNew();
        sharePointEmail.handleInboundEmail(email, env );
    }
    /******************************
    Method Name: test4
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    static testMethod void test4(){
        test.starttest();
            testCreateContactEmail4();
        test.stoptest();    
    }
    
    /******************************
    Method Name: testCreateContactEmail5
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public static void testCreateContactFrmEmail5() {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        
        email.ccAddresses = new String[] {'user@acme.com'};
        email.fromAddress = 'test@test.com';
        env.toAddress = 'test1@test1.com';
          
        email.plainTextBody = 'BPOSD<https://adtkm2amr1.accenture.com/sites/BPOSD>' + '\n' +'itworks.pptx has been deleted' +
        
        '\n' + 'Modify my alert settings<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/MySubs.aspx>' + '\n' +
        
        'View itworks.pptx<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/PowerPoint.aspx?PowerPointView=ReadingView%26PresentationId=/sites/BPOSD/Opportunity%2520Documents%2520%2520Documents/BAE%2520SYSTEMS%2520PLC%2520--%2520UST%2520%60%60%2520testing%25207/1.%2520Required%2520Documents/itworks.pptx>' + '\n' +
        
        'View Opportunity Documents - Documents<https://adtkm2amr1.accenture.com/sites/BPOSD/Opportunity%20Documents%20%20Documents>' + '\n' +
       
        'Mobile View<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/mobile/dispform.aspx?List=D0D20AD4-674F-4292-B7D6-1915692D0889&ID=2903>' + '\n' +
        
        'Last Modified 7/2/2014 8:12 AM by DIR\\sara.r.percival';      
        //String reviewId = email.plainTextBody.substringBetween('#'); 
        SharePointInboundEmailNew sharePointEmail = new SharePointInboundEmailNew();
        sharePointEmail.handleInboundEmail(email, env );
    }
    /******************************
    Method Name: test6
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    static testMethod void test5(){
        test.starttest();
            testCreateContactFrmEmail5();
        test.stoptest();    
    }
    /******************************
    Method Name: testCreateContactEmail6
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public static void testCreateContactEmail6(){
    
         Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.SYSTEM_ADMIN);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        
        //Opportunity oppObj = new Opporunity(Name = '',Accountid,SP_Folder_Name__c);
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        
        email.ccAddresses = new String[] {'user@acme.com'};
        email.fromAddress = 'test@test.com';
        env.toAddress = 'test1@test1.com';
        email.subject= 'E2E Workbench Shared Folders: TestSP2SF - To TeST---Test Mohan 123.docx';
        
    email.plainTextBody = 'BPOSD<https://adtkm2amr1.accenture.com/sites/BPOSD>' + '\n' +'itworks.pptx has been added' +
        
        '\n' + 'Modify my alert settings<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/MySubs.aspx>' + '\n' +
        
        'View itworks.pptx<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/PowerPoint.aspx?PowerPointView=ReadingView%26PresentationId=/sites/BPOSD/Opportunity%2520Documents%2520%2520Documents/BAE%2520%60%60%60%60%60%2520SYSTEMS%2520PLC%2520--%2520UST%2520%60%60%2520testing%25207/1.%2520Required%2520Documents/itworks.pptx>' + '\n' +
        
         '\n' +
       
        'Mobile View<https://adtkm2amr1.accenture.com/sites/BPOSD/_layouts/mobile/dispform.aspx?List=D0D20AD4-674F-4292-B7D6-1915692D0889&ID=2903>' + '\n' +
        
        'Last Modified 7/2/2014 8:12 AM by DIR\\sara.r.percival';
        SharePointInboundEmailNew sharePointEmail = new SharePointInboundEmailNew();
        sharePointEmail.handleInboundEmail(email, env );
    }
    /******************************
    Method Name: test7
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    static testMethod void test6(){
        test.starttest();
            testCreateContactEmail6();
        test.stoptest();    
    }
    /******************************
    Method Name: testCreateContactEmail7
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public static void testCreateContactEmail7(){
    
         Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.SYSTEM_ADMIN);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        
        //Opportunity oppObj = new Opporunity(Name = 'Test opportunity',Accountid,SP_Folder_Name__c);
        List<opportunity> oppList = new List<opportunity>();
        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        insert ogm;
        
        Account accounts =new Account(name='Test_Latest1');
        insert accounts;
        
        opportunity opp = new Opportunity();
        
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Name = 'Test_Latest1';
        opp.Accountid=accounts.id;
        
        oppList.add(opp);
        
        opportunity opp1 = new Opportunity();
        
        opp1.Reporting_Status__c = UtilConstants.WON;
        opp1.Geo_Area__c = UtilConstants.EALA;
        opp1.OperatingGroup__c = ogm.id;
        opp1.StageName = UtilConstants.TWO_B;
        opp1.Risk_Level__c = UtilConstants.NORMAL;
        opp1.CloseDate = System.today();
        opp1.Name = 'Test_Latest1';
        opp1.Accountid=accounts.id;
        
        oppList.add(opp1);
        
        database.insert(oppList);
        

        

        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        
        email.ccAddresses = new String[] {'user@acme.com'};
        email.fromAddress = 'test@test.com';
        env.toAddress = 'test1@test1.com';
        email.subject= 'E2E Workbench Shared Folders: TestSP2SF - testtesttest.docx';
        
    email.plainTextBody='From: E2E Workbench <tsdonotreply@accenture.com> Sent: Saturday, April 4, 2015 9:12 PMTo: Avdesh Sharma, A.Subject: E2E Workbench Shared Folders: TestSP2SF - testtesttest.docx E2E Workbench<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench>testtesttest.docx has been added Modify my alert settings<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/_layouts/15/MySubs.aspx>       &#124;       View testtesttest.docx<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/E2E%20Workbench%20Shared%20Folders/TestSP2SF/Test_Latest1--Test_Latest1/1.%20Required%20Documents/testtesttest.docx>     &#124;       View E2E Workbench Shared Folders<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/E2E%20Workbench%20Shared%20Folders>   &#124;       Mobile View<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/_layouts/mobile/dispform.aspx?List=15B39199-5E52-46BE-8C5C-976E77925921&ID=1968> Title: Last Modified 4/4/2015 10:40 AM by Avdesh Sharma, A. This message is for the designated recipient only and may contain privileged, proprietary, or otherwise confidential information. If you have received it in error, please notify the sender immediately and delete the original. Any other use of the e-mail by you is prohibited. Where allowed by local law, electronic communications with Accenture and its affiliates, including e-mail and instant messaging (including content), may be scanned by our systems for the purposes of information security and assessment of internal compliance with Accenture policy. www.accenture.com';
        SharePointInboundEmailNew sharePointEmail = new SharePointInboundEmailNew();
        sharePointEmail.handleInboundEmail(email, env );
        
        
    }
    /******************************
    Method Name: test7
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    static testMethod void test7(){
        test.starttest();
            testCreateContactEmail7();
        test.stoptest();    
    }
    
    /******************************
    Method Name: testCreateContactEmail8
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public static void testCreateContactEmail8(){
    
         Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.SYSTEM_ADMIN);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        
        //Opportunity oppObj = new Opporunity(Name = 'Test opportunity',Accountid,SP_Folder_Name__c);
        List<opportunity> oppList = new List<opportunity>();
        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        insert ogm;
        
        Account accounts =new Account(name='Test_Latest1');
        insert accounts;
        
        opportunity opp = new Opportunity();
        
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Name = 'Test_Latest1';
        opp.Accountid=accounts.id;
        oppList.add(opp);
        database.insert(oppList);    
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        
        email.ccAddresses = new String[] {'user@acme.com'};
        email.fromAddress = 'test@test.com';
        env.toAddress = 'test1@test1.com';
        email.subject= 'E2E Workbench Shared Folders: TestSP2SF - testtesttest.docx';
        
    email.plainTextBody='From: E2E Workbench <tsdonotreply@accenture.com> Sent: Saturday, April 4, 2015 9:12 PMTo: Avdesh Sharma, A.Subject: E2E Workbench Shared Folders: TestSP2SF - testtesttest.docx E2E Workbench<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench>testtesttest.docx has been added Modify my alert settings<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/_layouts/15/MySubs.aspx>       &#124;       View testtesttest.docx<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/E2E%20Workbench%20Shared%20Folders/TestSP2SF/Test_Latest1--Test_Latest1/1.%20Required%20Documents/testtesttest.docx>     &#124;       View E2E Workbench Shared Folders<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/E2E%20Workbench%20Shared%20Folders>   &#124;       Mobile View<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/_layouts/mobile/dispform.aspx?List=15B39199-5E52-46BE-8C5C-976E77925921&ID=1968> Title: Last Modified 4/4/2015 10:40 AM by Avdesh Sharma, A. This message is for the designated recipient only and may contain privileged, proprietary, or otherwise confidential information. If you have received it in error, please notify the sender immediately and delete the original. Any other use of the e-mail by you is prohibited. Where allowed by local law, electronic communications with Accenture and its affiliates, including e-mail and instant messaging (including content), may be scanned by our systems for the purposes of information security and assessment of internal compliance with Accenture policy. www.accenture.com';
        SharePointInboundEmailNew sharePointEmail = new SharePointInboundEmailNew();
        sharePointEmail.handleInboundEmail(email, env );
        
        
    }
    /******************************
    Method Name: test8
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    static testMethod void test8(){
        test.starttest();
            testCreateContactEmail8();
        test.stoptest();    
    }
    
    /******************************
    Method Name: testCreateContactEmail9
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
        public static void testCreateContactEmail9(){
    
         Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.SYSTEM_ADMIN);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        
        //Opportunity oppObj = new Opporunity(Name = 'Test opportunity',Accountid,SP_Folder_Name__c);
        List<opportunity> oppList = new List<opportunity>();
        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        insert ogm;
        
        Account accounts =new Account(name='Test_Latest1');
        insert accounts;
        
        opportunity opp = new Opportunity();
        
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Name = 'Test_Latest1';
        opp.Accountid=accounts.id;
        
        oppList.add(opp);
        database.insert(oppList);
        
        opportunity_documents__c oppdocuments=new opportunity_documents__c(opportunity__c=oppList[0].id,
                                                                           document__c='testAgain.docx',
                                                                           Document_Link__c='test link',
                                                                           Service_Group__c='BPO',
                                                                           modified_by__c='test user',
                                                                           modified_date__c =date.today()
                                                                          );
        insert oppdocuments;
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope(); 
        email.ccAddresses = new String[] {'user@acme.com'};
        email.fromAddress = 'test@test.com';
        env.toAddress = 'test1@test1.com';
        email.subject= 'E2E Workbench Shared Folders: TestSP2SF - testAgain.docx';
        email.plaintextbody='From: E2E Workbench <tsdonotreply@accenture.com>Sent: Saturday, April 4, 2015 9:12 PMTo: Avdesh Sharma, A.Subject: E2E Workbench Shared Folders: TestSP2SF - testAgain.docx E2E Workbench<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench>testAgain.docx has been changed Modify my alert settings<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/_layouts/15/MySubs.aspx>       &#124;       View testAgain.docx<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/E2E%20Workbench%20Shared%20Folders/TestSP2SF/Test_Latest1--Test_Latest1/1.%20Required%20Documents/testAgain.docx>   &#124;       View E2E Workbench Shared Folders<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/E2E%20Workbench%20Shared%20Folders>   &#124;       Mobile View<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/_layouts/mobile/dispform.aspx?List=15B39199-5E52-46BE-8C5C-976E77925921&ID=1959> Checked Out To:Title:Last Modified 4/4/2015 10:39 AM by Avdesh Sharma, A.';
        SharePointInboundEmailNew sharePointEmail = new SharePointInboundEmailNew();
        sharePointEmail.handleInboundEmail(email, env );
        
        
    }
    /******************************
    Method Name: test9
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    static testMethod void test9(){
        test.starttest();
            testCreateContactEmail9();
        test.stoptest();    
    }
    /******************************
    Method Name: testCreateContactEmail10
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public static void testCreateContactEmail10(){
    
         Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.SYSTEM_ADMIN);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        
        //Opportunity oppObj = new Opporunity(Name = 'Test opportunity',Accountid,SP_Folder_Name__c);
        List<opportunity> oppList = new List<opportunity>();
        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        insert ogm;
        
        Account accounts =new Account(name='Test_Latest1');
        insert accounts;
        
        opportunity opp = new Opportunity();
        
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Name = 'Test_Latest1';
        opp.Accountid=accounts.id;
        oppList.add(opp);
        database.insert(oppList);
        
        opportunity_documents__c oppdocuments=new opportunity_documents__c(opportunity__c=oppList[0].id,
                                                                           document__c='testtesttest.docx',
                                                                           Document_Link__c='testtesttest.docx',
                                                                           Service_Group__c='BPO',
                                                                           modified_by__c='Avdesh Sharma, A.',
                                                                           modified_date__c =date.today()
                                                                          );
        insert oppdocuments;
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        
        email.ccAddresses = new String[] {'user@acme.com'};
        email.fromAddress = 'test@test.com';
        env.toAddress = 'test1@test1.com';
        email.subject= 'E2E Workbench Shared Folders: TestSP2SF - testtesttest.docx';
        
    email.plainTextBody='From: E2E Workbench <tsdonotreply@accenture.com>Sent: Sunday, April 5, 2015 11:25 AMTo: Avdesh Sharma, A.Subject: E2E Workbench Shared Folders: TestSP2SF - testtesttest.docxE2E Workbench<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench>testtesttest.docx has been deletedModify my alert settings<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/_layouts/15/MySubs.aspx>       &#124;       View E2E Workbench Shared Folders<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/E2E%20Workbench%20Shared%20Folders>   &#124;       Mobile View<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/_layouts/mobile/dispform.aspx?List=15B39199-5E52-46BE-8C5C-976E77925921&ID=1968>Last Modified 4/5/2015 12:55 AM by Avdesh Sharma, A.';
        SharePointInboundEmailNew sharePointEmail = new SharePointInboundEmailNew();
        sharePointEmail.handleInboundEmail(email, env );
        
        
    }
    
   /*static testMethod void test10(){
        test.starttest();
            testCreateContactEmail10();
        test.stoptest();    
    }*/
    /******************************
    Method Name: testCreateContactEmail11
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public static void testCreateContactEmail11(){
    
         Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.SYSTEM_ADMIN);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        
        //Opportunity oppObj = new Opporunity(Name = 'Test opportunity',Accountid,SP_Folder_Name__c);
        List<opportunity> oppList = new List<opportunity>();
        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        insert ogm;
        
        Account accounts =new Account(name='Test_Latest1');
        insert accounts;
        
        opportunity opp = new Opportunity();
        
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Name = 'Test_Latest1';
        opp.Accountid=accounts.id;
        oppList.add(opp);
        database.insert(oppList);
        
        opportunity_documents__c oppdocuments=new opportunity_documents__c(opportunity__c=oppList[0].id,
                                                                           document__c='testtesttest.docx',
                                                                           Document_Link__c='testtesttest.docx',
                                                                           Service_Group__c='BPO',
                                                                           modified_by__c='Avdesh Sharma, A.',
                                                                           modified_date__c =date.today()
                                                                          );
        opportunity_documents__c oppdocuments1=new opportunity_documents__c(opportunity__c=oppList[0].id,
                                                                           document__c='testtesttest.docx',
                                                                           Document_Link__c='testtesttest.docx',
                                                                           Service_Group__c='BPO',
                                                                           modified_by__c='Avdesh Sharma, A.',
                                                                           modified_date__c =date.today()
                                                                          );
        List<opportunity_documents__c> oppdoclist=new List<opportunity_documents__c>();
        oppdoclist.add(oppdocuments);
        oppdoclist.add(oppdocuments1);
        insert oppdoclist;
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        
        email.ccAddresses = new String[] {'user@acme.com'};
        email.fromAddress = 'test@test.com';
        env.toAddress = 'test1@test1.com';
        email.subject= 'E2E Workbench Shared Folders: TestSP2SF - testtesttest.docx';
        
    email.plainTextBody='From: E2E Workbench <tsdonotreply@accenture.com>Sent: Sunday, April 5, 2015 11:25 AMTo: Avdesh Sharma, A.Subject: E2E Workbench Shared Folders: TestSP2SF - testtesttest.docxE2E Workbench<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench>testtesttest.docx has been deletedModify my alert settings<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/_layouts/15/MySubs.aspx>       &#124;       View E2E Workbench Shared Folders<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/E2E%20Workbench%20Shared%20Folders>   &#124;       Mobile View<https://ts.accenture.com/sites/TGP_for_BPO/E2EWorkbench/_layouts/mobile/dispform.aspx?List=15B39199-5E52-46BE-8C5C-976E77925921&ID=1968>Last Modified 4/5/2015 12:55 AM by Avdesh Sharma, A.';
        SharePointInboundEmailNew sharePointEmail = new SharePointInboundEmailNew();
        sharePointEmail.handleInboundEmail(email, env );
    }
    /******************************
    Method Name: test11
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    static testMethod void test11(){  
        test.starttest();
            testCreateContactEmail11();
        test.stoptest();   
    }
}