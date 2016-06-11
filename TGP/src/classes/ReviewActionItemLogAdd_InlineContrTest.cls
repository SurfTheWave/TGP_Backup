@isTest

private class ReviewActionItemLogAdd_InlineContrTest{
    static Event cEvent;
    static Approver_Master__c aMaster;
    static Review_Meeting_Request__c revMeetReq;
    static User testUser;
    static Review_Process__c rProcess;
    static Client_Master__c clientName;
    static Client_Geo_Area_Master__c clientGeoArea;
    static Operating_Group_Master__c operatingGroup;
    static Client_Geo_Unit_Master__c clientGeoUnit;
    static Opportunity_TGP__c oppTGP;
    static Offerings_Master__c offeringMaster;
    static Opportunity_Offering__c oppOffering;
    static Assumption__c assumption;
    static Current_Client_Capability_Assessment__c ccca;
    static Document doc;
    static Review_Action_Item_Log__c rAIL;
    static Review_Action_Item_Log__c rAIL1;
    static List<Review_Action_Item_Log__c> rAILList;
    static Review_User_Master__c testUserMaster;
    static Review_Type_Master__c  testRevTypeMaster;
    
    public static void setupData(){
        Profile p = [Select id from Profile where Name = 'Workbench User'];
        List<userRole> role = [select id from userRole where name='WorkbenchUser'];
        testUser = new User(alias = 'u1', email='u1@testorg.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',UserRoleId =role[0].id,
        timezonesidkey='America/Los_Angeles', username='u92@testorg.com');
        insert testUser;
        testUserMaster = new Review_User_Master__c(Name = 'TestUserMaster',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster@testorg.com');
      insert testUserMaster; 
  
  
      rAILList= new List<Review_Action_Item_Log__c>();
     
      
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',complex_cost_architect__c=testUser.Id,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.Id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',TCV__C=55);
      insert oppTGP;

     //To create a record of Review Process
    rProcess=new Review_Process__c();
    rProcess.BPO_Opportunity__c=oppTGP.id;
    insert rProcess;
    //To create a Review meeting request
    revMeetReq=new Review_Meeting_Request__c();
    revMeetReq.Client_Name__c='test';
    revMeetReq.Status__c='Scheduled';
    revMeetReq.Review_Process__c=rProcess.id;
    revMeetReq.BPO_Opportunity__c=oppTGP.id;
    insert revMeetReq;
    
    
    //To create a Approval Master
    
    aMaster=new Approver_Master__c();
    //aMaster.TCV_Range__c='10-40M';
    //aMaster.Region__c='NA';
    aMaster.Name='TEst';
    aMaster.Approver_Mail_ID__c='abc@email.com';
    insert aMaster;
    
    //To craete an Event
    testRevTypeMaster = new Review_Type_Master__c();
    testRevTypeMaster.Active__c = true;
    
    insert testRevTypeMaster;
            
    cEvent=new Event();
    cEvent.StartDateTime =datetime.now()+1;
    cEvent.Subject='testevent';
    cEvent.EndDateTime =datetime.now()+2;
    //cEvent.OwnerId = testUser.Id;
    cEvent.Meeting_Record_ID__c=revMeetReq.id;
    insert cEvent;
    //to create a document
    String strFolderId= [select id from folder where name = 'Solution Document'].id;
    doc = new Document();
    doc.name='Doc1';
    doc.folderId=strFolderId;
    insert doc;
    //to create a review rqeasrt log
    
    rAIL=new Review_Action_Item_Log__c();
    rAIL.name='test';
    rAIL.Due_date__c=date.today();
    rAIL.File_id__c=doc.id;
    rAIL.Send__c=true;
    rAIL.User__c =testUser.Id;
    rAIL.Attached_File_Name__c='test';
    rAIL.Review_Process__c=rProcess.id;
    rAIL.Description__c='test';
    rAIL.Primary_Owner__c = testUserMaster.id;
    rAIL.Issue_Status__c = 'Not Started';
    insert rAIL;
    
    rAIL1=new Review_Action_Item_Log__c();
    rAIL1.name='test';
    rAIL1.Due_date__c=null;
    rAIL.Issue_Status__c = 'Not Started';
    /*rAIL.File_id__c=doc.id;
    rAIL.Send__c=true;
    rAIL.User__c =testUser.Id;
    rAIL.Attached_File_Name__c='test';
    rAIL.Review_Process__c=rProcess.id;
    rAIL.Description__c='test';*/
    insert rAIL1;
    
     rAILList.add(rAIL);
     rAILList.add(rAIL1);
     
      //Review_files_attachment__c
    
    } 
    static testMethod void test1(){
    test.starttest();
        
            Profile p = [Select id from Profile where Name = 'PMO'];
            List<userRole> role = [select id from userRole where name='PMO'];
            testUser = new User(alias = 'u1', email='u1543@testorg.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',UserRoleId =role[0].id,
            timezonesidkey='America/Los_Angeles', username='u9335646@testorg.com');
        System.runAs ( testUser) {
        setupData();
        
        Review_Action_Item_Log__c rAILTest = new Review_Action_Item_Log__c();
        
        rAILTest.name='test';
        rAILTest.Due_date__c=date.today()+1;
        rAILTest.File_id__c=doc.id;
        rAILTest.Send__c=true;
        rAILTest.User__c =testUser.Id;
        rAILTest.Attached_File_Name__c='test';
        rAILTest.Review_Process__c=rProcess.id;
        rAILTest.Description__c='test';
        rAILTest.Primary_Owner__c = testUserMaster.id;
        rAILTest.Issue_Status__c = 'Not Started';
        insert rAILTest;
        
        rAILList.add(rAILTest);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(rProcess);
        
        apexpages.currentpage().getparameters().put('id',rProcess.id);
        apexpages.currentpage().getparameters().put('oppId',oppTGP.id);
        
        ReviewActionItemLogAdd_InlineController.sendMailReview(rProcess);
        
        ReviewActionItemLogAdd_InlineController.getEmailAddresses();
        
        ReviewActionItemLogAdd_InlineController obj = new ReviewActionItemLogAdd_InlineController(controller);
        ReviewActionItemLogAdd_InlineController objTest = new ReviewActionItemLogAdd_InlineController(controller);
        
        obj.recordId=rAIL.id;
        obj.recordIdToDelete=rAIL.id;
         obj.doc.body = Blob.valueOf('I am a test');
         obj.newProfDetail = rAILTest;
         obj.listProfileDetailsActual = rAILList;
        obj.listProfileDetailsActual.add(rAIL);
        obj.getReviewTypes();
        obj.addNewProfDetail();
        
        obj.newProfDetail.Description__c='test';
        obj.addNewProfDetail();
        obj.newProfDetail.User__c=testUser.Id;
        obj.addNewProfDetail();
        obj.newProfDetail.Due_date__c=date.today()-1;
        obj.addNewProfDetail();
        obj.newProfDetail.Due_date__c=date.today()+7;
        obj.addNewProfDetail();
        ReviewActionItemLogAdd_InlineController.fileInfo obj1=new ReviewActionItemLogAdd_InlineController.fileInfo('testFile444','testId123');
        obj.getListOfActionItemLog();
        //obj.initializeDetailRecords();
        obj.saveAccProfileDetails();
        obj.sendRemainder();
        obj.generateReport();
        obj.refreshAccProfilePage();
        }
        test.stoptest();
    }
    static testMethod void test11(){
    test.starttest();
        
            Profile p = [Select id from Profile where Name =: UTIL_Constants.SOLUTION_ADMIN];
            List<userRole> role = [select id from userRole where name=: UTIL_Constants.SOLUTION_ADMIN];
            testUser = new User(alias = 'u1', email='u1543@testorg.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.Id, country='United States',UserRoleId =role[0].id,
                        timezonesidkey='America/Los_Angeles', username='u9335646@testorg.com');
                        
                        insert testUser;
                        
        System.runAs ( testUser) {
        setupData();
        
        Review_Action_Item_Log__c rAILTest = new Review_Action_Item_Log__c();
        
        rAILTest.name='test';
        rAILTest.Due_date__c=date.today()+1;
        rAILTest.File_id__c=doc.id;
        rAILTest.Send__c=true;
        rAILTest.User__c =testUser.Id;
        rAILTest.Attached_File_Name__c='test';
        rAILTest.Review_Process__c=rProcess.id;
        rAILTest.Description__c='test';
        rAILTest.Primary_Owner__c = testUserMaster.id;
        rAILTest.Issue_Status__c = 'Not Started';
        insert rAILTest;
        
        
        ApexPages.StandardController controller = new ApexPages.StandardController(rProcess);
        
        apexpages.currentpage().getparameters().put('id',rProcess.id);
        apexpages.currentpage().getparameters().put('oppId',oppTGP.id);
        
        ReviewActionItemLogAdd_InlineController.sendMailReview(rProcess);
        
        ReviewActionItemLogAdd_InlineController.getEmailAddresses();
        
        ReviewActionItemLogAdd_InlineController obj = new ReviewActionItemLogAdd_InlineController(controller);
        ReviewActionItemLogAdd_InlineController objTest = new ReviewActionItemLogAdd_InlineController(controller);
        
        obj.recordId=rAIL.id;
        obj.recordIdToDelete=rAIL.id;
         obj.doc.body = Blob.valueOf('I am a test');
         obj.newProfDetail = rAILTest;
         obj.listProfileDetailsActual = rAILList;
        obj.listProfileDetailsActual.add(rAIL);
        obj.getReviewTypes();
        obj.addNewProfDetail();
        
        obj.newProfDetail.Description__c='test';
        obj.addNewProfDetail();
        obj.newProfDetail.User__c=testUser.Id;
        obj.addNewProfDetail();
        obj.newProfDetail.Due_date__c=date.today()-1;
        obj.addNewProfDetail();
        obj.newProfDetail.Due_date__c=date.today()+7;
        obj.addNewProfDetail();
        ReviewActionItemLogAdd_InlineController.fileInfo obj1=new ReviewActionItemLogAdd_InlineController.fileInfo('testFile444','testId123');
        obj.getListOfActionItemLog();
        //obj.initializeDetailRecords();
        obj.saveAccProfileDetails();
        obj.sendRemainder();
        obj.generateReport();
        obj.refreshAccProfilePage();
        }
        test.stoptest();
    }
    
    static testMethod void test_new (){
        Test.startTest();
            Profile p = [Select id from Profile where Name = 'PMO'];
            List<userRole> role = [select id from userRole where name='PMO'];
            testUser = new User(alias = 'u1', email='u1543@testorg.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p.Id, country='United States',UserRoleId =role[0].id,
                timezonesidkey='America/Los_Angeles', username='u9335646@testorg.com');
            
            system.runAs ( testUser) {
                setupData();
                Review_Action_Item_Log__c rAILTest = new Review_Action_Item_Log__c(name = 'Test', Send__c = true, Description__c = 'test');
                rAILTest.Due_date__c=date.today()+1;
                rAILTest.File_id__c=doc.id;
                rAILTest.User__c =testUser.Id;
                rAILTest.Attached_File_Name__c='test';
                rAILTest.Review_Process__c=rProcess.id;
                rAILTest.Primary_Owner__c = testUserMaster.id;
                rAILTest.Issue_Status__c = 'Not Started';
                insert rAILTest;
                ApexPages.StandardController controller = new ApexPages.StandardController(rProcess);
                apexpages.currentpage().getparameters().put('id',rProcess.id);
                apexpages.currentpage().getparameters().put('oppId',oppTGP.id);
                ReviewActionItemLogAdd_InlineController obj = new ReviewActionItemLogAdd_InlineController(controller);
                ReviewActionItemLogAdd_InlineController objTest = new ReviewActionItemLogAdd_InlineController(controller);
                obj.recordId=rAIL.id;
                obj.recordIdToDelete=rAIL.id;
                obj.doc.body = Blob.valueOf('I am a test');
                obj.newProfDetail = rAILTest;
                obj.listProfileDetailsActual = rAILList;
                obj.listProfileDetailsActual.add(rAIL);
                obj.result='true';
                obj.fileId ='true';
                obj.addDocument();
                obj.doc.name='test';
                obj.doc.body=Blob.valueOf('test');
                obj.addDocument();
                obj.recordId=rAIL.id;
                obj.deleteDocument();
                obj.deleteRecord();
            }
        Test.stopTest();
    }
    static testMethod void test_new_2 () {
        Test.startTest();
            Profile p = [Select id from Profile where Name = 'PMO'];
            List<userRole> role = [select id from userRole where name='PMO'];
            testUser = new User(alias = 'u1', email='u1543@testorg.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p.Id, country='United States',UserRoleId =role[0].id,
                timezonesidkey='America/Los_Angeles', username='u9335646@testorg.com');
            system.runAs ( testUser) {
                setupData();
                Review_Action_Item_Log__c rAILTest = new Review_Action_Item_Log__c(name = 'Test', Send__c = true, Description__c = 'test');
                rAILTest.Due_date__c=date.today()+1;
                rAILTest.File_id__c=doc.id;
                rAILTest.User__c =testUser.Id;
                rAILTest.Attached_File_Name__c='test';
                rAILTest.Review_Process__c=rProcess.id;
                rAILTest.Primary_Owner__c = testUserMaster.id;
                rAILTest.Issue_Status__c = 'Not Started';
                insert rAILTest;
                ApexPages.StandardController controller = new ApexPages.StandardController(rProcess);
                apexpages.currentpage().getparameters().put('id',rProcess.id);
                apexpages.currentpage().getparameters().put('oppId',oppTGP.id);
                ReviewActionItemLogAdd_InlineController.sendMailReview(rProcess);
                ReviewActionItemLogAdd_InlineController.getEmailAddresses();
                ReviewActionItemLogAdd_InlineController obj = new ReviewActionItemLogAdd_InlineController(controller);
                ReviewActionItemLogAdd_InlineController objTest = new ReviewActionItemLogAdd_InlineController(controller);
                ReviewActionItemLogAdd_InlineController.checkNullValues('abc');
                ReviewActionItemLogAdd_InlineController.checkNullValuesDeciamlTCV(56);
                objTest.recordId=rAIL1.id;
                objTest.recordIdToDelete=rAIL1.id;
                objTest.doc.body = Blob.valueOf('I am a test');
                objTest.listProfileDetailsActual.add(rAIL1);
                objTest.getReviewTypes();
                objTest.addNewProfDetail();
            }
        Test.stopTest();
    }
    
}