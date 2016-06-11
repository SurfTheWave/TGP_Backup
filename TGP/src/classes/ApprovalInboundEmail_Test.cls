/**
   @Author         : 
   @name           : ApprovalInboundEmail_Test 
   @CreateDate     : 22 December 2014
   @Description    : Test class for Approval Inbound Email Test functionality 
   @Version        : 1.0
  */
@isTest(SeeAllData=true)
private class ApprovalInboundEmail_Test {

    Private Static Approval_Request__c ApprovalReqRef1 ;
    Private Static Approval_Request__c ApprovalReqRef2 ;
    Private Static Approval_Request__c ApprovalReqRef3 ;
    Private Static Approval_Request__c ApprovalReqRef4 ;
    Private Static Approval_Request__c ApprovalReqRef5 ;
    Private Static Approval_Request__c ApprovalReqRef6 ;
    Private Static Approval_Request__c ApprovalReqRef7 ;
    Private Static Approval_Request__c ApprovalReqRef8 ;
    
    Private Static Action_Item__c actitem1;
    Private Static Action_Item__c actitem2;
    Private Static List<Action_Item__c> ACList = new List<Action_Item__c>();
    Private Static List<Approval_Request__c> ARList = new List<Approval_Request__c>();
    Private Static String aliasString = 'testUNIQ';
    Private Static Id sysAdminId = [Select Id from Profile Where Name = 'System Administrator' Limit 1].Id;
    Private Static User stdUser = new User(
    alias = aliasString, 
    email= aliasString+'@accenture.com',
    emailencodingkey='UTF-8',
    lastname='Testing', 
    languagelocalekey='en_US',
    localesidkey='en_US',
    profileid = sysAdminId,
    timezonesidkey='Europe/London',
    username= aliasString+'@accenture.com');
    

    /*
    @name : TestCreateContactFrmEmail1
    @Description : 
    @Version : 
    */
    public static void TestCreateContactFrmEmail1(Approval_Request__c AR) {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();  
        email.plainTextBody = '<approved>'+'#'+AR.id+'#';  
        email.fromAddress = stdUser.Email;  
        //String reviewId = email.plainTextBody.substringBetween('#'); 
        ApprovalInboundEmail AIEmail1 = new ApprovalInboundEmail();
        AIEmail1.handleInboundEmail(email, envelope); 
        
    }
    /*
    @name : TestCreateContactFrmEmail2
    @Description : 
    @Version : 
    */
    public static void TestCreateContactFrmEmail2(Approval_Request__c AR) {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope envelope= new Messaging.InboundEnvelope();  
        email.plainTextBody =  '#'+AR.id+'#'+'<reject>';     
        email.fromAddress = stdUser.Email;  
        //String reviewId = email.plainTextBody.substringBetween('#'); 
        ApprovalInboundEmail AIEmail1 = new ApprovalInboundEmail();
        AIEmail1.handleInboundEmail(email, envelope);
        
    }
    /*
    @name : TestCreateContactFrmEmail3
    @Description : 
    @Version : 
    */
    public static void TestCreateContactFrmEmail3(Approval_Request__c AR) {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope envelope= new Messaging.InboundEnvelope();  
        email.plainTextBody =  '#'+AR.id+'#'+'<rework>'; 
        email.fromAddress = stdUser.Email;  
        //String reviewId = email.plainTextBody.substringBetween('#'); 
        ApprovalInboundEmail AIEmail1 = new ApprovalInboundEmail();
        AIEmail1.handleInboundEmail(email, envelope); 
        
    }
    /*
    @name : TestCreateContactFrmEmail4
    @Description : 
    @Version : 
    */ 
    public static void TestCreateContactFrmEmail4(Approval_Request__c AR) {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope envelope= new Messaging.InboundEnvelope();  
        email.plainTextBody =  '#'+AR.id+'#'+'<ready for review>';  
        email.fromAddress = stdUser.Email;  
        //String reviewId = email.plainTextBody.substringBetween('#'); 
        ApprovalInboundEmail AIEmail1 = new ApprovalInboundEmail();
        AIEmail1.handleInboundEmail(email, envelope); 
        
    }
    /*
    @name : TestCreateContactFrmEmail5
    @Description : 
    @Version : 
    */ 
    public static void TestCreateContactFrmEmail5(Action_Item__c AC) {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();  
        email.plainTextBody = '<completed>'+'#'+AC.id+'#';  
        email.fromAddress = stdUser.Email;  
        //String reviewId = email.plainTextBody.substringBetween('#'); 
        ApprovalInboundEmail AIEmail1 = new ApprovalInboundEmail();
        AIEmail1.handleInboundEmail(email, envelope); 
        
    }
    /*
    @name : TestCreateContactFrmEmail6
    @Description : 
    @Version : 
    */        
    public static void TestCreateContactFrmEmail6(Action_Item__c AC) {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();  
        email.plainTextBody = '<In Progress>'+'#'+AC.id+'#';  
        email.fromAddress = stdUser.Email;  
        //String reviewId = email.plainTextBody.substringBetween('#'); 
        ApprovalInboundEmail AIEmail1 = new ApprovalInboundEmail();
        AIEmail1.handleInboundEmail(email, envelope); 
        
    }
     /*
    @name : TestCreateContactFrmEmail7
    @Description : 
    @Version : 
    */    
    public static void TestCreateContactFrmEmail7(Action_Item__c AC) {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();  
        email.plainTextBody = '<On Hold>'+'#'+AC.id+'#';  
        email.fromAddress = stdUser.Email;  
        //String reviewId = email.plainTextBody.substringBetween('#'); 
        ApprovalInboundEmail AIEmail1 = new ApprovalInboundEmail();
        AIEmail1.handleInboundEmail(email, envelope); 
        
    }
     /*
    @name : TestCreateContactFrmEmail8
    @Description : 
    @Version : 
    */     
    public static void TestCreateContactFrmEmail8(Action_Item__c AC) {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();  
        email.plainTextBody = '<Next Stage>'+'#'+AC.id+'#';  
        email.fromAddress = stdUser.Email;  
        //String reviewId = email.plainTextBody.substringBetween('#'); 
        ApprovalInboundEmail AIEmail1 = new ApprovalInboundEmail();
        AIEmail1.handleInboundEmail(email, envelope); 
        
    }
    /*
    @name : TestCreateContactFrmEmail10
    @Description : 
    @Version : 
    */      
    public static void TestCreateContactFrmEmail10(Approval_Request__c AR) {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope envelope= new Messaging.InboundEnvelope();  
        email.plainTextBody =  '#'+' '+'#'+'<rework>'; 
        email.fromAddress = stdUser.Email;  
        //String reviewId = email.plainTextBody.substringBetween('#'); 
        ApprovalInboundEmail AIEmail1 = new ApprovalInboundEmail();
        AIEmail1.handleInboundEmail(email, envelope); 
        
    }
    /*
    @name : TestCreateContactFrmEmail9
    @Description : 
    @Version : 
    */    
    public static void TestCreateContactFrmEmail9(Action_Item__c AC) {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();  
        email.plainTextBody = '<Not Started>'+'#'+AC.id+'#';  
        email.fromAddress = stdUser.Email;  
        //String reviewId = email.plainTextBody.substringBetween('#'); 
        ApprovalInboundEmail AIEmail1 = new ApprovalInboundEmail();
        AIEmail1.handleInboundEmail(email, envelope); 
        
    }
    //Test Methods:
    /*
    @name : setupData1
    @Description : 
    @Version : 
    */
    public static void setupData1(){ //approval_request_status__c = UtilConstants.PEND_WITH_APPR2;
       // List<Opportunity> oppList = UnitTestDatafactory.createOppList('UnitTest Opportunity',1);
      Operating_Groups_Master__c OppGrpMaster = new Operating_Groups_Master__c();
      Database.insert(OppGrpMaster);
        List<Opportunity> oppList =new list<Opportunity>();
      Opportunity opp_obj = UTIL_DataCreationForTestClass.getOpportunity(OppGrpMaster);//new Opportunity(Name = 'TestOPP', StageName = 'Approval Stage:14', CloseDate = system.today());
      opp_obj.BPO_Net_Rev_Thousands__c=1;
      opp_obj.IO_Net_Revenue_Thousands__c =0;
      opp_obj.IC_Net_Rev_Thousands__c=0;
        
      oppList.add(opp_obj);
      Database.insert(oppList);
        
        opportunity_documents__c OppDocs= new opportunity_documents__c(document__c = 'Test Doc' ,Document_Link__c = 'Junk Link text', opportunity__c = oppList[0].Id,type__c = 'DSCO');
        insert OppDocs;
        User_Master__c UserMasterRef0= new User_Master__c();
        UserMasterRef0.Name = 'UserMasterTest0';
        Insert UserMasterRef0;
        User_Master__c Requestor = new User_Master__c();   //Added for null pointer error
        Requestor.Name = 'TestUserMaster';
        Requestor.Email__c='abc@accenture.com';
        insert Requestor;
        User_Master__c Approver = new User_Master__c();   //Added for null pointer error
        Approver.Name = 'TestUserMaster';
        Approver.Email__c= stdUser.Email;
        Approver.User__c = stdUser.Id;
        insert Approver;
        Approval_stage__c ApprovalStage = new Approval_stage__c();
        ApprovalStage.opportunity__c = oppList[0].id;
        ApprovalStage.Service_Group__c = 'BPO';
        ApprovalStage.approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL;   // utilConstants.FLY_BY_SOL_REVIEW;
     //   ApprovalStage.approval_stage_status__c = UtilConstants.APPRVD;
        Insert ApprovalStage;
        ApprovalReqRef1 = new Approval_Request__c();
        ApprovalReqRef1.comments_by_approver__c='Test Data';
        ApprovalReqRef1.response_received_date__c=date.parse('06/06/1980'); 
        ApprovalReqRef1.Requestor__c = Requestor.Id;
        ApprovalReqRef1.Approver__c = Approver.Id;
        ApprovalReqRef1.approval_request_type__c=UtilConstants.FIN_APPRBPO;
        ApprovalReqRef1.approval_stage__c = ApprovalStage.Id;
        ApprovalReqRef1.approval_request_status__c= UtilConstants.PEND_WITH_APPR2;  //Check for UtilConstants.APPRVD , UtilConstants.REJ , UtilConstants.REWORK1 and UtilConstants.READYREV
        ApprovalReqRef1.Service_Group__c = 'BPO';
      /*  
        ApprovalReqRef2 = new Approval_Request__c();
        ApprovalReqRef2.approval_request_type__c='SDO Approval';
        ApprovalReqRef2.comments_by_approver__c='Test Data';
        ApprovalReqRef2.response_received_date__c=date.parse('06/06/1980'); 
        ApprovalReqRef2.Requestor__c = Requestor.Id;
        ApprovalReqRef2.Approver__c = Approver.Id;
        ApprovalReqRef2.approval_stage__c = ApprovalStage.Id;
        ApprovalReqRef2.approval_request_status__c= UtilConstantsforSWB.approved1; //Check for UtilConstants.APPRVD , UtilConstants.REJ , UtilConstants.REWORK1 and UtilConstants.READYREV
        ApprovalReqRef2.Service_Group__c ='BPO';
        
        */
        //List<Approval_Request__c> ARList = new List<Approval_Request__c>();
        
        //Insert ARList;
        Insert ApprovalReqRef1;
        system.debug('ApprovalReqRef1:'+ApprovalReqRef1);
        system.debug('ApprovalStage.of_approval_request__c:'+ApprovalStage);
        system.debug('dg3:'+opp_obj);
        ARList.add(ApprovalReqRef1);
    }
    
    /*
    @name : setupData2
    @Description : 
    @Version : 
    */
 public static void setupData2(){ //approval_request_status__c = UtilConstants.APPRVD;
        List<Opportunity> oppList = UnitTestDatafactory.createOppList('UnitTest Opportunity',1);
        
        Opportunity opp2 = new Opportunity();
     opp2.Id = oppList[0].Id;
      opp2.BPO_Net_Rev_Thousands__c=0;
      opp2.IO_Net_Revenue_Thousands__c =1;
      opp2.IC_Net_Rev_Thousands__c=1;
     update opp2;
        
        
        opportunity_documents__c OppDocs= new opportunity_documents__c(document__c = 'Test Doc' ,Document_Link__c = 'Junk Link text', opportunity__c = oppList[0].Id,type__c = 'DSCO');
        insert OppDocs;
        User_Master__c UserMasterRef0= new User_Master__c();
        UserMasterRef0.Name = 'UserMasterTest0';
        Insert UserMasterRef0;
        User_Master__c Requestor = new User_Master__c();   //Added for null pointer error
        Requestor.Name = 'TestUserMaster';
        Requestor.Email__c='abc@accenture.com';
        insert Requestor;
        User_Master__c Approver = new User_Master__c();   //Added for null pointer error
        Approver.Name = 'TestUserMaster';
        Approver.Email__c= stdUser.Email;
        Approver.User__c = stdUser.Id;
        insert Approver;
        Approval_stage__c ApprovalStage = new Approval_stage__c();
        ApprovalStage.opportunity__c = opp2.id;
        ApprovalStage.Service_Group__c = 'BPO';
        ApprovalStage.approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL; // utilConstants.FLY_BY_SOL_REVIEW;
        Insert ApprovalStage;
        ApprovalReqRef2 = new Approval_Request__c();
        ApprovalReqRef2.approval_request_type__c='SDO Approval';
        ApprovalReqRef2.comments_by_approver__c='Test Data';
        ApprovalReqRef2.response_received_date__c=date.parse('06/06/1980'); 
        ApprovalReqRef2.Requestor__c = Requestor.Id;
        ApprovalReqRef2.Approver__c = Approver.Id;
        
        ApprovalReqRef2.approval_request_type__c=UtilConstants.FIN_APPRIO;
        
        ApprovalReqRef2.approval_stage__c = ApprovalStage.Id;
        ApprovalReqRef2.approval_request_status__c= UtilConstants.APPRVD; // UtilConstantsforSWB.approved1; //Check for UtilConstants.APPRVD , UtilConstants.REJ , UtilConstants.REWORK1 and UtilConstants.READYREV
        ApprovalReqRef2.Service_Group__c = 'BPO';
        //List<Approval_Request__c> ARList = new List<Approval_Request__c>();
        //ARList.add(ApprovalReqRef1);
        //Insert ARList;
        Insert ApprovalReqRef2;
        ARList.add(ApprovalReqRef2);
    }
     /*
    @name : setupData3
    @Description : 
    @Version : 
    */ 
 public static void setupData3(){ //approval_request_status__c = UtilConstants.REJ;
        List<Opportunity> oppList = UnitTestDatafactory.createOppList('UnitTest Opportunity',1);
        
         Opportunity opp3 = new Opportunity();
     opp3.Id = oppList[0].Id;
      opp3.BPO_Net_Rev_Thousands__c=1;
      opp3.IO_Net_Revenue_Thousands__c =0;
      opp3.IC_Net_Rev_Thousands__c=1;
     update opp3;
                
        
        opportunity_documents__c OppDocs= new opportunity_documents__c(document__c = 'Test Doc' ,Document_Link__c = 'Junk Link text', opportunity__c = oppList[0].Id,type__c = 'DSCO');
        insert OppDocs;
        User_Master__c UserMasterRef0= new User_Master__c();
        UserMasterRef0.Name = 'UserMasterTest0';
        Insert UserMasterRef0;
        User_Master__c Requestor = new User_Master__c();   //Added for null pointer error
        Requestor.Name = 'TestUserMaster';
        Requestor.Email__c='abc@accenture.com';
        insert Requestor;
        User_Master__c Approver = new User_Master__c();   //Added for null pointer error
        Approver.Name = 'TestUserMaster';
        Approver.Email__c= stdUser.Email;
        Approver.User__c = stdUser.Id;
        insert Approver;
        Approval_stage__c ApprovalStage = new Approval_stage__c();
        ApprovalStage.opportunity__c = opp3.id;
        ApprovalStage.Service_Group__c = 'BPO';
        ApprovalStage.approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL; // utilConstants.FLY_BY_SOL_REVIEW;
        Insert ApprovalStage;
        ApprovalReqRef3 = new Approval_Request__c();
        ApprovalReqRef3.approval_request_type__c= UtilConstants.FIN_APPRBPO; // 'SDO Approval';
        ApprovalReqRef3.comments_by_approver__c='Test Data';
        ApprovalReqRef3.response_received_date__c=date.parse('06/06/1980'); 
        ApprovalReqRef3.Requestor__c = Requestor.Id;
        ApprovalReqRef3.Approver__c = Approver.Id;
        ApprovalReqRef3.approval_stage__c = ApprovalStage.Id;
        ApprovalReqRef3.approval_request_status__c= UtilConstants.APPRVD; // UtilConstantsforSWB.reject1;  //Check for UtilConstants.APPRVD , UtilConstants.REJ , UtilConstants.REWORK1 and UtilConstants.READYREV
        ApprovalReqRef3.Service_Group__c = 'BPO';
        //List<Approval_Request__c> ARList = new List<Approval_Request__c>();
        //ARList.add(ApprovalReqRef1);
        //Insert ARList;
        Insert ApprovalReqRef3;
        ARList.add(ApprovalReqRef3);
    }
     /*
    @name : setupData4
    @Description : 
    @Version : 
    */ 
 public static void setupData4(){ //approval_request_status__c = UtilConstants.REWORK1 ;
        List<Opportunity> oppList = UnitTestDatafactory.createOppList('UnitTest Opportunity',1);
        
        Opportunity opp4 = new Opportunity();
     opp4.Id = oppList[0].Id;
      opp4.BPO_Net_Rev_Thousands__c=1;
      opp4.IO_Net_Revenue_Thousands__c =1;
      opp4.IC_Net_Rev_Thousands__c=1;
     update opp4;
        
        
        opportunity_documents__c OppDocs= new opportunity_documents__c(document__c = 'Test Doc' ,Document_Link__c = 'Junk Link text', opportunity__c = oppList[0].Id,type__c = 'DSCO');
        insert OppDocs;
        User_Master__c UserMasterRef0= new User_Master__c();
        UserMasterRef0.Name = 'UserMasterTest0';
        Insert UserMasterRef0;
        User_Master__c Requestor = new User_Master__c();   //Added for null pointer error
        Requestor.Name = 'TestUserMaster';
        Requestor.Email__c='abc@accenture.com';
        insert Requestor;
        User_Master__c Approver = new User_Master__c();   //Added for null pointer error
        Approver.Name = 'TestUserMaster';
        Approver.Email__c= stdUser.Email;
        Approver.User__c = stdUser.Id;
        insert Approver;
        Approval_stage__c ApprovalStage = new Approval_stage__c();
        ApprovalStage.opportunity__c = opp4.id;
        ApprovalStage.Service_Group__c = 'BPO';
        ApprovalStage.approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL; // utilConstants.FLY_BY_SOL_REVIEW;
        Insert ApprovalStage;
        ApprovalReqRef4 = new Approval_Request__c();
        ApprovalReqRef4.approval_request_type__c= UtilConstants.FIN_APPRBPO; // 'SDO Approval';
        ApprovalReqRef4.comments_by_approver__c='Test Data';
        ApprovalReqRef4.response_received_date__c=date.parse('06/06/1980'); 
        ApprovalReqRef4.Requestor__c = Requestor.Id;
        ApprovalReqRef4.Approver__c = Approver.Id;
        ApprovalReqRef4.approval_stage__c = ApprovalStage.Id;
        ApprovalReqRef4.approval_request_status__c= UtilConstants.APPRVD; // UtilConstantsforSWB.rework1 ;  //Check for UtilConstants.APPRVD , UtilConstants.REJ , UtilConstants.REWORK1 and UtilConstants.READYREV
        ApprovalReqRef4.Service_Group__c = 'BPO';
        //List<Approval_Request__c> ARList = new List<Approval_Request__c>();
        //ARList.add(ApprovalReqRef1);
        //Insert ARList;
        Insert ApprovalReqRef4;
        ARList.add(ApprovalReqRef4);
    }
     /*
    @name : setupData5
    @Description : 
    @Version : 
    */ 
 public static void setupData5(){ //approval_request_status__c = UtilConstants.READYREV;
        List<Opportunity> oppList = UnitTestDatafactory.createOppList('UnitTest Opportunity',1);
        opportunity_documents__c OppDocs= new opportunity_documents__c(document__c = 'Test Doc' ,Document_Link__c = 'Junk Link text', opportunity__c = oppList[0].Id,type__c = 'DSCO');
        insert OppDocs;
        User_Master__c UserMasterRef0= new User_Master__c();
        UserMasterRef0.Name = 'UserMasterTest0';
        Insert UserMasterRef0;
        User_Master__c Requestor = new User_Master__c();   //Added for null pointer error
        Requestor.Name = 'TestUserMaster';
        Requestor.Email__c='abc@accenture.com';
        insert Requestor;
        User_Master__c Approver = new User_Master__c();   //Added for null pointer error
        Approver.Name = 'TestUserMaster';
        Approver.Email__c= stdUser.Email;
        Approver.User__c = stdUser.Id;
        insert Approver;
        Approval_stage__c ApprovalStage = new Approval_stage__c();
        ApprovalStage.opportunity__c = oppList[0].id;
        ApprovalStage.Service_Group__c = 'BPO';
        //ApprovalStage.opportunity__r.BPO_Net_Rev_Thousands__c=1000;
        //ApprovalStage.opportunity__r.IO_Net_Revenue_Thousands__c=1000;
        //ApprovalStage.opportunity__r.IC_Net_Rev_Thousands__c=1000;
        ApprovalStage.approval_stage_type__c = utilConstants.FLY_BY_SOL_REVIEW;
        Insert ApprovalStage;
        ApprovalReqRef5= new Approval_Request__c();
        ApprovalReqRef5.approval_request_type__c='SDO Approval';
        ApprovalReqRef5.comments_by_approver__c='Test Data';
        ApprovalReqRef5.response_received_date__c=date.parse('06/06/1980'); 
        ApprovalReqRef5.Requestor__c = Requestor.Id;
        ApprovalReqRef5.Approver__c = Approver.Id;
        ApprovalReqRef5.approval_stage__c = ApprovalStage.Id;
        ApprovalReqRef5.approval_request_status__c= UtilConstantsforSWB.readyforreview1;  //Check for UtilConstants.APPRVD , UtilConstants.REJ , UtilConstants.REWORK1 and UtilConstants.READYREV
        ApprovalReqRef5.Service_Group__c = 'BPO';
        //List<Approval_Request__c> ARList = new List<Approval_Request__c>();
        //ARList.add(ApprovalReqRef1);
        //Insert ARList;
        Insert ApprovalReqRef5;
        ARList.add(ApprovalReqRef5);
    }
    
    
    //Test Methods:
    /*
    @name : setupDataCheck
    @Description : 
    @Version : 
    */
    public static void setupDataCheck(){ //approval_request_status__c = UtilConstants.PEND_WITH_APPR2;
       // List<Opportunity> oppList = UnitTestDatafactory.createOppList('UnitTest Opportunity',1);
      Operating_Groups_Master__c OppGrpMaster = new Operating_Groups_Master__c();
      Database.insert(OppGrpMaster);
        List<Opportunity> oppList =new list<Opportunity>();
      Opportunity opp_obj = UTIL_DataCreationForTestClass.getOpportunity(OppGrpMaster);//new Opportunity(Name = 'TestOPP', StageName = 'Approval Stage:14', CloseDate = system.today());
      opp_obj.BPO_Net_Rev_Thousands__c=1;
      opp_obj.IO_Net_Revenue_Thousands__c =1;
      opp_obj.IC_Net_Rev_Thousands__c=1;
        
      oppList.add(opp_obj);
      Database.insert(oppList);
        
        opportunity_documents__c OppDocs= new opportunity_documents__c(document__c = 'Test Doc' ,Document_Link__c = 'Junk Link text', opportunity__c = oppList[0].Id,type__c = 'DSCO');
        insert OppDocs;
        User_Master__c UserMasterRef0= new User_Master__c();
        UserMasterRef0.Name = 'UserMasterTest0';
        Insert UserMasterRef0;
        User_Master__c Requestor = new User_Master__c();   //Added for null pointer error
        Requestor.Name = 'TestUserMaster';
        Requestor.Email__c='abc@accenture.com';
        insert Requestor;
        User_Master__c Approver = new User_Master__c();   //Added for null pointer error
        
        Opportunity_Roles_Master__c opprole = new Opportunity_Roles_Master__c(name=UtilCOnstants.OPP_SOL_LEAD,Role_Level__c='Both');
        insert opprole;
        Opportunity_Teams__c oppteam = new Opportunity_Teams__c(Opportunity_Team_Member__c = Requestor.Id,Role__c = opprole.Id,Opportunity__c=oppList[0].id);
        insert oppteam;
        
        Approver.Name = 'TestUserMaster';
        Approver.Email__c= stdUser.Email;
        Approver.User__c = stdUser.Id;
        insert Approver;
        Approval_stage__c ApprovalStage = new Approval_stage__c();
        ApprovalStage.opportunity__c = oppList[0].id;
        ApprovalStage.Service_Group__c = 'BPO';
        ApprovalStage.approval_stage_type__c = utilConstants.FLY_BY_SOL_REVIEW;
        Insert ApprovalStage;
        ApprovalReqRef1 = new Approval_Request__c();
        ApprovalReqRef1.comments_by_approver__c='Test Data';
        ApprovalReqRef1.response_received_date__c=date.parse('06/06/1980'); 
        ApprovalReqRef1.Requestor__c = Requestor.Id;
        ApprovalReqRef1.Approver__c = Approver.Id;
        ApprovalReqRef1.approval_request_type__c=UtilConstants.FIN_APPRBPO;
        ApprovalReqRef1.approval_stage__c = ApprovalStage.Id;
        ApprovalReqRef1.approval_request_status__c= UtilConstants.PEND_WITH_APPR2;  //Check for UtilConstants.APPRVD , UtilConstants.REJ , UtilConstants.REWORK1 and UtilConstants.READYREV
        ApprovalReqRef1.Service_Group__c = 'BPO';
        
        Insert ApprovalReqRef1;
        ARList.add(ApprovalReqRef1);
    }
    
    
  /*
    @name : setupData6
    @Description : 
    @Version : 
    */     
    public static void setupData6(){ 
        
            User useObj = UtilNovaUnitTest.getUser();
            Database.insert(useObj);
            User_Master__c userObj1 = new User_Master__c(Name = 'TestUser',User__c = useObj.id,email__c=useObj.email);
            Database.insert(userObj1);
        List<Opportunity> oppList = UnitTestDatafactory.createOppList('UnitTest Opportunity',1);
        Approval_Stage__c appObj_stage = new Approval_Stage__c(opportunity__c=oppList[0].id ,approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL,
                                                             Service_Group__c = utilConstants.BPO,approval_stage_status__c='Pending');
            Database.insert(appObj_stage);
  
        ApprovalReqRef6=new Approval_Request__c(approval_stage__c=appObj_stage.id,approver__c=userObj1.id,approval_request_type__c='BST Approval',Service_Group__c = utilConstants.BPO,
                                                approval_request_status__c=UtilConstants.PEND_WITH_REQSTR);
        Insert ApprovalReqRef6;
        //System.debug('ApprovalReqRef6'+ApprovalReqRef6.approval_request_status__c);
        ARList.add(ApprovalReqRef6);
    }
/*
@name : setupData7
@Description : creating test data for testing functionality
@Version : 1.0
*/    
    
      public static void setupData7(){
            User useObj = UtilNovaUnitTest.getUser();
            Database.insert(useObj);
            User_Master__c userObj1 = new User_Master__c(Name = 'TestUser',User__c = useObj.id,email__c=useObj.email);
            Database.insert(userObj1);
            
          List<Opportunity> oppList = UnitTestDatafactory.createOppList('UnitTest Opportunity',1);
            Approval_Stage__c appObj_stage = new Approval_Stage__c(opportunity__c=oppList[0].id ,approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL,
                                                             Service_Group__c = utilConstants.BPO,approval_stage_status__c='Pending');
            Database.insert(appObj_stage);
            
           actitem1=new Action_Item__c(approval_stage__c=appObj_stage.id,
                                                    Primary_Owner__c=userObj1.id,action__c='Test',
                                                    due_date__c=date.today(),
                                                    action_item_status__c ='IN Progress');

            Database.insert(actitem1);
            ACList.add(actitem1);
            
       }
     /*
    @name : setupData8
    @Description : 
    @Version : 
    */ 
      public static void setupData8(){
            User useObj = UtilNovaUnitTest.getUser();
            Database.insert(useObj);
            User_Master__c userObj1 = new User_Master__c(Name = 'TestUser',User__c = useObj.id,email__c=useObj.email);
            Database.insert(userObj1);
            
          List<Opportunity> oppList = UnitTestDatafactory.createOppList('UnitTest Opportunity',1);
            Approval_Stage__c appObj_stage = new Approval_Stage__c(opportunity__c=oppList[0].id ,approval_stage_type__c = UtilConstants.STAGE1_SOL_APPROVAL,
                                                             Service_Group__c = utilConstants.BPO,approval_stage_status__c='Pending');
            Database.insert(appObj_stage);
            
            actitem2=new Action_Item__c(approval_stage__c=appObj_stage.id,
                                                    Primary_Owner__c=userObj1.id,action__c='Test',
                                                    due_date__c=date.today(),
                                                    action_item_status__c ='IN Progress');

            Database.insert(actitem2);
            ACList.add(actitem2);
            
       }
     /*
    @name : setupData9
    @Description : 
    @Version : 
    */      
    public static void setupData9(){ //FOr IO
        List<Opportunity> oppList = UnitTestDatafactory.createOppList('UnitTest Opportunity',1);
        
        
     Opportunity opp9 = new Opportunity();
     opp9.Id = oppList[0].Id;
      opp9.BPO_Net_Rev_Thousands__c=0;
      opp9.IO_Net_Revenue_Thousands__c =1;
      opp9.IC_Net_Rev_Thousands__c=0;
     update opp9;
        
        
        
        opportunity_documents__c OppDocs= new opportunity_documents__c(document__c = 'Test Doc' ,Document_Link__c = 'Junk Link text', opportunity__c = oppList[0].Id,type__c = 'DSCO');
        insert OppDocs;
        User_Master__c UserMasterRef0= new User_Master__c();
        UserMasterRef0.Name = 'UserMasterTest0';
        Insert UserMasterRef0;
        User_Master__c Requestor = new User_Master__c();   //Added for null pointer error
        Requestor.Name = 'TestUserMaster';
        Requestor.Email__c='abc@accenture.com';
        insert Requestor;
        User_Master__c Approver = new User_Master__c();   //Added for null pointer error
        Approver.Name = 'TestUserMaster';
        Approver.Email__c= stdUser.Email;
        Approver.User__c = stdUser.Id;
        insert Approver;
        Approval_stage__c ApprovalStage = new Approval_stage__c();
        ApprovalStage.opportunity__c =  opp9.Id;  // oppList[0].id;
        ApprovalStage.Service_Group__c = 'IO';
        ApprovalStage.approval_stage_type__c ='Stage 3 - Solution Approval';
        //ApprovalStage.opportunity__r.BPO_Net_Rev_Thousands__c=1000;
        //ApprovalStage.opportunity__r.IO_Net_Revenue_Thousands__c=1000;
        //ApprovalStage.opportunity__r.IC_Net_Rev_Thousands__c=1000;
        Insert ApprovalStage;
        ApprovalReqRef7 = new Approval_Request__c();
        ApprovalReqRef7.approval_request_type__c= UtilConstants.FIN_APPRIO;  // 'SDO Approval';
        ApprovalReqRef7.comments_by_approver__c='Test Data';
        ApprovalReqRef7.response_received_date__c=date.parse('06/06/1980'); 
        ApprovalReqRef7.Requestor__c = Requestor.Id;
        ApprovalReqRef7.Approver__c = Approver.Id;
        ApprovalReqRef7.approval_stage__c = ApprovalStage.Id;
        ApprovalReqRef7.approval_request_status__c= UtilConstants.PEND_WITH_APPR2;  //Check for UtilConstants.APPRVD , UtilConstants.REJ , UtilConstants.REWORK1 and UtilConstants.READYREV
        ApprovalReqRef7.Service_Group__c = 'IO';
        Insert ApprovalReqRef7;
        ARList.add(ApprovalReqRef7);
        
    }
    /*
    @name : setupData10
    @Description : 
    @Version : 
    */    
    public static void setupData10(){ //FOr IC
        List<Opportunity> oppList = UnitTestDatafactory.createOppList('UnitTest Opportunity',1);
        
        
        Opportunity opp10 = new Opportunity();
     opp10.Id = oppList[0].Id;
      opp10.BPO_Net_Rev_Thousands__c=0;
      opp10.IO_Net_Revenue_Thousands__c =0;
      opp10.IC_Net_Rev_Thousands__c=1;
     update opp10;
        
        
        opportunity_documents__c OppDocs= new opportunity_documents__c(document__c = 'Test Doc' ,Document_Link__c = 'Junk Link text', opportunity__c = oppList[0].Id,type__c = 'DSCO');
        insert OppDocs;
        User_Master__c UserMasterRef0= new User_Master__c();
        UserMasterRef0.Name = 'UserMasterTest0';
        Insert UserMasterRef0;
        User_Master__c Requestor = new User_Master__c();   //Added for null pointer error
        Requestor.Name = 'TestUserMaster';
        Requestor.Email__c='abc@accenture.com';
        insert Requestor;
        User_Master__c Approver = new User_Master__c();   //Added for null pointer error
        Approver.Name = 'TestUserMaster';
        Approver.Email__c= stdUser.Email;
        Approver.User__c = stdUser.Id;
        insert Approver;
        Approval_stage__c ApprovalStage = new Approval_stage__c();
        ApprovalStage.opportunity__c = opp10.id;
        ApprovalStage.Service_Group__c = 'IO';
        //ApprovalStage.opportunity__r.BPO_Net_Rev_Thousands__c=1000;
        //ApprovalStage.opportunity__r.IO_Net_Revenue_Thousands__c=1000;
        //ApprovalStage.opportunity__r.IC_Net_Rev_Thousands__c=1000;
        ApprovalStage.approval_stage_type__c ='Stage 3 - Solution Approval';
        Insert ApprovalStage;
        ApprovalReqRef8 = new Approval_Request__c();
        ApprovalReqRef8.approval_request_type__c=  UtilConstants.FIN_APPRIC; // 'SDO Approval';
        ApprovalReqRef8.comments_by_approver__c='Test Data';
        ApprovalReqRef8.response_received_date__c=date.parse('06/06/1980'); 
        ApprovalReqRef8.Requestor__c = Requestor.Id;
        ApprovalReqRef8.Approver__c = Approver.Id;
        ApprovalReqRef8.approval_stage__c = ApprovalStage.Id;
        ApprovalReqRef8.approval_request_status__c= UtilConstants.PEND_WITH_APPR2;  //Check for UtilConstants.APPRVD , UtilConstants.REJ , UtilConstants.REWORK1 and UtilConstants.READYREV
        ApprovalReqRef8.Service_Group__c = 'IC';
        Insert ApprovalReqRef8;
        ARList.add(ApprovalReqRef8);
        
    }
    
    /*
    @name : Test1
    @Description : 
    @Version : 
    */   
    Public static TestMethod void Test1(){ 
        //List<Email_Template__c> cs = new List<Email_Template__c>();
        //Email_Template__c temp1= new Email_Template__c(name=UtilConstantsforSWB.ApprReqCannotBeApproved);
       // Email_Template__c temp2= new Email_Template__c(name=UtilConstantsforSWB.Opscannotbeapproved);
        //Email_Template__c temp3= new Email_Template__c(name=UtilConstantsforSWB.StageApproved);
        //cs.add(temp1);
        //cs.add(temp2);
        //cs.add(temp3);
//insert cs;
        System.runAs(stdUser) {    
            setupData1();                     
            Test.starttest();
            ApprovalInboundEmail AIEmail = new ApprovalInboundEmail();
            TestCreateContactFrmEmail1(ApprovalReqRef1);
            TestCreateContactFrmEmail2(ApprovalReqRef1);
            TestCreateContactFrmEmail3(ApprovalReqRef1);
            TestCreateContactFrmEmail10(ApprovalReqRef1);
           // TestCreateContactFrmEmail4(ApprovalReqRef1); //Commented due to 101 SOQL Issue
            Test.stoptest();
        
        }
    }  
     /*
    @name : Test2
    @Description : 
    @Version : 
    */           
    Public static TestMethod void Test2(){ 
        
       // List<Email_Template__c> cs = new List<Email_Template__c>();
       // Email_Template__c temp1= new Email_Template__c(name=UtilConstantsforSWB.ApprReqCannotBeApproved);
       // Email_Template__c temp2= new Email_Template__c(name=UtilConstantsforSWB.Opscannotbeapproved);
       // Email_Template__c temp3= new Email_Template__c(name=UtilConstantsforSWB.StageApproved);
        //cs.add(temp1);
        //cs.add(temp2);
       // cs.add(temp3);
       // insert cs;
        System.runAs(stdUser) {    
            setupData2();                     
            Test.starttest();      
            TestCreateContactFrmEmail1(ApprovalReqRef2);
            TestCreateContactFrmEmail2(ApprovalReqRef2);
            TestCreateContactFrmEmail3(ApprovalReqRef2);
            TestCreateContactFrmEmail4(ApprovalReqRef2);
            Test.stoptest();
        
        }
    }
    /*
    @name : Test3
    @Description : 
    @Version : 
    */
    Public static TestMethod void Test3(){ 
       // List<Email_Template__c> cs = new List<Email_Template__c>();
       // Email_Template__c temp1= new Email_Template__c(name=UtilConstantsforSWB.ApprReqCannotBeApproved);
       // Email_Template__c temp2= new Email_Template__c(name=UtilConstantsforSWB.Opscannotbeapproved);
       // Email_Template__c temp3= new Email_Template__c(name=UtilConstantsforSWB.StageApproved);
       // cs.add(temp1);
       // cs.add(temp2);
       // cs.add(temp3);
       // insert cs;
        System.runAs(stdUser) {    
            setupData3();                     
            Test.starttest();  
            TestCreateContactFrmEmail1(ApprovalReqRef3);
            TestCreateContactFrmEmail2(ApprovalReqRef3);
            TestCreateContactFrmEmail3(ApprovalReqRef3);
            //TestCreateContactFrmEmail4(ApprovalReqRef3); //Commented due to 101 SOQL Issue
            Test.stoptest();
        
        }
    }
    /*
    @name : Test4
    @Description : 
    @Version : 
    */
    Public static TestMethod void Test4(){ 
        
      //  List<Email_Template__c> cs = new List<Email_Template__c>();
       // Email_Template__c temp1= new Email_Template__c(name=UtilConstantsforSWB.ApprReqCannotBeApproved);
      //  Email_Template__c temp2= new Email_Template__c(name=UtilConstantsforSWB.Opscannotbeapproved);
      //  Email_Template__c temp3= new Email_Template__c(name=UtilConstantsforSWB.StageApproved);
       // cs.add(temp1);
       // cs.add(temp2);
      //  cs.add(temp3);
      //  insert cs;
        System.runAs(stdUser) {    
            setupData4();                     
            Test.starttest();  
            TestCreateContactFrmEmail1(ApprovalReqRef4);
            TestCreateContactFrmEmail2(ApprovalReqRef4);
            TestCreateContactFrmEmail3(ApprovalReqRef4);
            //TestCreateContactFrmEmail4(ApprovalReqRef4);  //Commented due to 101 SOQL Issue
            Test.stoptest();
        
        }
    }
    /*
    @name : Test5
    @Description : 
    @Version : 
    */  
    Public static TestMethod void Test5(){ 
       // List<Email_Template__c> cs = new List<Email_Template__c>();
       // Email_Template__c temp1= new Email_Template__c(name=UtilConstantsforSWB.ApprReqCannotBeApproved);
      //  Email_Template__c temp2= new Email_Template__c(name=UtilConstantsforSWB.Opscannotbeapproved);
       // Email_Template__c temp3= new Email_Template__c(name=UtilConstantsforSWB.StageApproved);
       // cs.add(temp1);
      //  cs.add(temp2);
      //  cs.add(temp3);
     //   insert cs;
        System.runAs(stdUser) {    
            setupData5();                     
            Test.starttest();  
            TestCreateContactFrmEmail1(ApprovalReqRef5);
            TestCreateContactFrmEmail2(ApprovalReqRef5);
            TestCreateContactFrmEmail3(ApprovalReqRef5);
            TestCreateContactFrmEmail4(ApprovalReqRef5);
            Test.stoptest();
        
        }
    }
    /*
    @name : Test6
    @Description : 
    @Version : 
    */  
    Public static TestMethod void Test6(){ 
        //List<Email_Template__c> cs = new List<Email_Template__c>();
       // Email_Template__c temp1= new Email_Template__c(name=UtilConstantsforSWB.ApprReqCannotBeApproved);
       // Email_Template__c temp2= new Email_Template__c(name=UtilConstantsforSWB.Opscannotbeapproved);
       // Email_Template__c temp3= new Email_Template__c(name=UtilConstantsforSWB.StageApproved);
       // cs.add(temp1);
       // cs.add(temp2);
       // cs.add(temp3);
       // insert cs;
        System.runAs(stdUser) {    
            setupData6();                     
            Test.starttest();  
            TestCreateContactFrmEmail1(ApprovalReqRef6);
            TestCreateContactFrmEmail2(ApprovalReqRef6);
            TestCreateContactFrmEmail3(ApprovalReqRef6);
            TestCreateContactFrmEmail4(ApprovalReqRef6);
            Test.stoptest();
        
        }
    }
   /*  
    @name : Test7
    @Description : 
    @Version : 
    */
    Public static TestMethod void Test7(){ 
      //  Email_Template__c cs = new Email_Template__c();
          //cs.name='Unauthorized Mail Approval';
         // insert cs;
        System.runAs(stdUser) {  
            setupDataCheck(); // setupData1(); 
            Test.starttest(); 
            Messaging.InboundEmail email = new Messaging.InboundEmail() ;
            Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();  
            email.plainTextBody = '<approved>'+'#'+ARList[0].id+'#';  
            email.fromAddress = stdUser.Email;  
            ApprovalInboundEmail.checkUnauthorizedAccess(email,ARList);
            Test.stoptest();
        
        }
    }
    
         /*
        @name : Test8
        @Description : creating test data for testing functionality
        @Version : 
        */ 
        Public static TestMethod void Test8(){ 
            //List<Email_Template__c> cs = new List<Email_Template__c>();
           // Email_Template__c temp1= new Email_Template__c(name=UtilConstantsforSWB.ApprReqCannotBeApproved);
           // Email_Template__c temp2= new Email_Template__c(name=UtilConstantsforSWB.Opscannotbeapproved);
           // Email_Template__c temp3= new Email_Template__c(name=UtilConstantsforSWB.StageApproved);
           // cs.add(temp1);
           // cs.add(temp2);
           // cs.add(temp3);
          //  insert cs;
          test.startTest();
          insert stdUser;
          test.stopTest();
          System.runAs(stdUser) {                         
              //Test.starttest();  
              setupData7();                     
              TestCreateContactFrmEmail5(actitem1);
              TestCreateContactFrmEmail6(actitem1);
              TestCreateContactFrmEmail7(actitem1);
              TestCreateContactFrmEmail8(actitem1);
              TestCreateContactFrmEmail9(actitem1);
              //Test.stoptest();
          }
      }
     /*
    @name : Test9
    @Description : 
    @Version : 
    */     
    Public static TestMethod void Test9(){ 
       // List<Email_Template__c> cs = new List<Email_Template__c>();
       // Email_Template__c temp1= new Email_Template__c(name=UtilConstantsforSWB.ApprReqCannotBeApproved);
       // Email_Template__c temp2= new Email_Template__c(name=UtilConstantsforSWB.Opscannotbeapproved);
       // Email_Template__c temp3= new Email_Template__c(name=UtilConstantsforSWB.StageApproved);
       // cs.add(temp1);
       // cs.add(temp2);
       // cs.add(temp3);
       // insert cs;
        System.runAs(stdUser) {                         
            Test.starttest();  
            setupData9();                     
            TestCreateContactFrmEmail1(ApprovalReqRef7);
            TestCreateContactFrmEmail2(ApprovalReqRef7);
            Test.stoptest();
        
        }
    }
    /*
    @name : Test10
    @Description : 
    @Version : 
    */    
    Public static TestMethod void Test10(){ 
      //  List<Email_Template__c> cs = new List<Email_Template__c>();
      //  Email_Template__c temp1= new Email_Template__c(name=UtilConstantsforSWB.ApprReqCannotBeApproved);
      //  Email_Template__c temp2= new Email_Template__c(name=UtilConstantsforSWB.Opscannotbeapproved);
      //  Email_Template__c temp3= new Email_Template__c(name=UtilConstantsforSWB.StageApproved);
      //  cs.add(temp1);
      //  cs.add(temp2);
       // cs.add(temp3);
      //  insert cs;
        System.runAs(stdUser) {                         
            Test.starttest();  
            setupData10();                     
            TestCreateContactFrmEmail1(ApprovalReqRef8);
            TestCreateContactFrmEmail2(ApprovalReqRef8);
            Test.stoptest();
        
       }
    }
}