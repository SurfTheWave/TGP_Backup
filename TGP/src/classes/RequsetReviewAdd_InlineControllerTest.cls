/*
Author : Varsha Chougule.
Story  : 
Description : Test class for Mob_BudgetSolutionController

Updated by        Story no./Defect No.           Update Date        Update details
------------    -----------------------        --------------    -------------------------------------------------------------

*/
@isTest
private class RequsetReviewAdd_InlineControllerTest
{
    static Client_Master__c clientName;
    static Client_Geo_Area_Master__c clientGeoArea;
    static Operating_Group_Master__c operatingGroup;
    static Client_Geo_Unit_Master__c clientGeoUnit;
    static Opportunity_TGP__c oppTGP;
    static Offerings_Master__c offeringMaster;
    static Opportunity_Offering__c oppOffering;
    static Review_Process__c rProcess;
    static Review_User_Master__c objReviewUser;
    static Review_Type_Master__c objReviewTypeMaster;
    static Request_Review__c objRequestReview;
    static User testUser3;
    static User testUser4;
    static User testUser2;
    static User testUserPMO;
    static Document_for_Request_Review__c objDoc;
    static String User_Name2='vc7@testorg.com';
    static String User_Name1='vc71@testorg.com';
    static String User_NamePMO='vc711@testorg.com';
    static Review_User_Master__c revUser;
    static Opportunity_Document__c objOppDoc;
    static Task taskRec;
    
    public static void setupData()
    {  
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        User testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

        profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
        testUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,User_Name1);
        Database.insert(testUser2, false);
        
        
        profile p2 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.PMO);
     
        testUserPMO = UTIL_DataCreationForTestClass.getUserWithProfile(p2,User_NamePMO);
        insert testUserPMO;
        
        revUser = UTIL_DataCreationForTestClass.getReviewUserMaster('test123@email.com','testUser');
        revUser.Is_Active__c = true;
        revUser.SFDC_User__c = testUserPMO.id;
        insert revUser;
        

        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser3 = UTIL_DataCreationForTestClass.getUserWithProfile(p,User_Name2);
        insert testUser3;
        //insert testUser3;



        system.runas(testUser2)
        {
            clientName = new Client_Master__c (Name = 'Testv1',Active__c = true);
            insert clientName;
            
            clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
            insert clientGeoArea;
            
            operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
            insert operatingGroup;
            
            clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
            insert clientGeoUnit;
         }
        system.runas(testUser)
        {
            
            oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',complex_cost_architect__c=testUser.id,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                      Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                      Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',TCV__C=55);
            insert oppTGP;
    
            offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
            insert offeringMaster;
            
            oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Solution_Lead__c=testUser.id,Solution_Specialist__c=testUser.id);
            insert oppOffering;
            
            //To create a record of Review Process
            rProcess=new Review_Process__c();
            rProcess.BPO_Opportunity__c=oppTGP.id;
            insert rProcess;  
            
            objReviewUser= new Review_User_Master__c();
            objReviewUser.Email_ID_of_the_reviewer__c =testUser3.Email;
            objReviewUser.Name='reviewUaser2';
            insert objReviewUser;
            
            objReviewTypeMaster=new Review_Type_Master__c();
            List<Review_Type_Master__c> lstRTN=[select id, name from Review_Type_Master__c where name='Final Approval'];
            if(lstRTN.size()>0)
            {
                objReviewTypeMaster=lstRTN[0];
            }
            else
            {
                objReviewTypeMaster.Name='Final Approval';
                objReviewTypeMaster.Active__c=true;
                insert objReviewTypeMaster;
            }
            
            objRequestReview=new Request_Review__c ();
            objRequestReview.Review_Process__c=rProcess.id;
            objRequestReview.Status__c='Pending';
            objRequestReview.Select_reviewer__c=true; 
            objRequestReview.Send_reminder__c=true; 
            objRequestReview.Review_User_Master__c=objReviewUser.id;
            objRequestReview.Review_Type_Master__c=objReviewTypeMaster.id;
            objRequestReview.Review_User_Master__c = revUser.id;
            //objRequestReview.version__c = 1; 
            insert objRequestReview;
            
                        
            objDoc= new Document_for_Request_Review__c();
            objDoc.Review_Process__c=rProcess.id;
            objDoc.Select_document__c=true;
            objDoc.Document_Name__c='test';
            insert objDoc;
                        
            objOppDoc = new Opportunity_Document__c();
            objOppDoc.Name='test123';
            objOppDoc.BPO_Opportunity__c=oppTGP.Id;
            objOppDoc.Client_Name__c=clientName.Id;
            insert objOppDoc;           
            }  
    }
    public static void setupData1()
    {  
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        User testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
        testUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(p,User_Name1);
        Database.insert(testUser2, false);

        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser3 = UTIL_DataCreationForTestClass.getUserWithProfile(p,User_Name2);
        Database.insert(testUser3, false);
        
        profile p2 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.PMO);
     
        testUserPMO = UTIL_DataCreationForTestClass.getUserWithProfile(p2,User_NamePMO);
        insert testUserPMO;
                
        system.runas(testUser2)
        {
            clientName = new Client_Master__c (Name = 'Testv1',Active__c = true);
            insert clientName;
            
            clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
            insert clientGeoArea;
            
            operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
            insert operatingGroup;
            
            clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
            insert clientGeoUnit;
         }
        system.runas(testUser)
        {
            
            oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',complex_cost_architect__c=testUser.id,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                      Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                      Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',TCV__C=55);
            insert oppTGP;
    
            offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
            insert offeringMaster;
            
            oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Solution_Lead__c=testUser.id,Solution_Specialist__c=testUser.id);
            insert oppOffering;
            
            //To create a record of Review Process
            rProcess=new Review_Process__c();
            rProcess.BPO_Opportunity__c=oppTGP.id;
            insert rProcess;  
            
            objReviewUser= new Review_User_Master__c();
            objReviewUser.Email_ID_of_the_reviewer__c ='v4@testorg.com';
            objReviewUser.Name='reviewUaser2';
            insert objReviewUser;
            
            objReviewTypeMaster=new Review_Type_Master__c();
            List<Review_Type_Master__c> lstRTN=[select id, name from Review_Type_Master__c where name='Final review'];
            if(lstRTN.size()>0)
            {
                objReviewTypeMaster=lstRTN[0];
            }
            else
            {
                objReviewTypeMaster.Name='Final review';
                objReviewTypeMaster.Active__c=true;
                insert objReviewTypeMaster;
            }
            
            objRequestReview=new Request_Review__c ();
            objRequestReview.Review_Process__c=rProcess.id;
            objRequestReview.Status__c='Approved';
            objRequestReview.Select_reviewer__c=true; 
            objRequestReview.Send_reminder__c=true;            
            objRequestReview.Review_User_Master__c=objReviewUser.id;
            objRequestReview.Review_Type_Master__c=objReviewTypeMaster.id;
            insert objRequestReview;
                        
            objDoc= new Document_for_Request_Review__c();
            objDoc.Review_Process__c=rProcess.id;
            objDoc.Select_document__c=true;
            objDoc.Document_Name__c='test';
            insert objDoc;
            
            objOppDoc = new Opportunity_Document__c();
            objOppDoc.Name='test123';
            objOppDoc.BPO_Opportunity__c=oppTGP.Id;
            objOppDoc.Client_Name__c=clientName.Id;
            insert objOppDoc;
          }  
    }
    
 /*  public static void setupData2()
    {  
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        User testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
        testUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(p,User_Name1);
        Database.insert(testUser2, false);

        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser3 = UTIL_DataCreationForTestClass.getUserWithProfile(p,User_Name2);
        Database.insert(testUser3, false);
        
        profile p2 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.PMO);
     
        testUserPMO = UTIL_DataCreationForTestClass.getUserWithProfile(p2,User_NamePMO);
        insert testUserPMO;
        

        system.runas(testUser2)
        {
            clientName = new Client_Master__c (Name = 'Testv1',Active__c = true);
            insert clientName;
            
            clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
            insert clientGeoArea;
            
            operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
            insert operatingGroup;
            
            clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
            insert clientGeoUnit;
         }
        system.runas(testUser)
        {
            
            oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',complex_cost_architect__c=testUser.id,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                      Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                      Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',TCV__C=55);
            insert oppTGP;
    
            offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
            insert offeringMaster;
            
            oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Solution_Lead__c=testUser.id,Solution_Specialist__c=testUser.id);
            insert oppOffering;
            
            //To create a record of Review Process
            rProcess=new Review_Process__c();
            rProcess.BPO_Opportunity__c=oppTGP.id;
            insert rProcess;  
            
            objReviewUser= new Review_User_Master__c();
            objReviewUser.Email_ID_of_the_reviewer__c ='v4@testorg.com';
            objReviewUser.Name='reviewUaser2';
            insert objReviewUser;
            
            objReviewTypeMaster=new Review_Type_Master__c();
            List<Review_Type_Master__c> lstRTN=[select id, name from Review_Type_Master__c where name='Final review'];
            if(lstRTN.size()>0)
            {
                objReviewTypeMaster=lstRTN[0];
            }
            else
            {
                objReviewTypeMaster.Name='Final review';
                objReviewTypeMaster.Active__c=true;
                insert objReviewTypeMaster;
            }
            
            
            objRequestReview=new Request_Review__c ();
            objRequestReview.Review_Process__c=rProcess.id;
            objRequestReview.Status__c='Reject';
            objRequestReview.Select_reviewer__c=true; 
            objRequestReview.Send_reminder__c=true; 
            objRequestReview.Review_User_Master__c=objReviewUser.id;
            objRequestReview.Review_Type_Master__c=objReviewTypeMaster.id;
            insert objRequestReview;
            
            Document doc = new Document(Name = 'TestDoc',FolderId =testUser.id,AuthorId =testUser.id,body =Blob.valueOf('I am a test'));
            insert doc;
            //Document doc = [select id, name, body, contenttype, developername, type from Document limit 1];
            objDoc= new Document_for_Request_Review__c();
            objDoc.Review_Process__c=rProcess.id;
            objDoc.Select_document__c=true;
            objDoc.Document_Name__c='test';
            objDoc.Document_id__c = doc.Id;
            insert objDoc;
            objOppDoc = new Opportunity_Document__c();
            objOppDoc.Name='test123';
            objOppDoc.BPO_Opportunity__c=oppTGP.Id;
            objOppDoc.Client_Name__c=clientName.Id;
            insert objOppDoc;
          }  
    }*/
    public static void setupData3()
    {  
       Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        User testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
        testUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(p,User_Name1);
        Database.insert(testUser2, false);

        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
        testUser3 = UTIL_DataCreationForTestClass.getUserWithProfile(p,User_Name2);
        testUser3.IsActive = true;
        Database.insert(testUser3, false);
    
         profile p2 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.PMO);
     
        testUserPMO = UTIL_DataCreationForTestClass.getUserWithProfile(p2,User_NamePMO);
        insert testUserPMO;
       

        system.runas(testUser2)
        {
            clientName = new Client_Master__c (Name = 'Testv1',Active__c = true);
            insert clientName;
            
            clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
            insert clientGeoArea;
            
            operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
            insert operatingGroup;
            
            clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
            insert clientGeoUnit;
         }
        system.runas(testUser)
        {
            
            oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',complex_cost_architect__c=testUser.id,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                      Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                      Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',TCV__C=55);
            insert oppTGP;
    
            offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
            insert offeringMaster;
            
            oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Solution_Lead__c=testUser.id,Solution_Specialist__c=testUser.id);
            insert oppOffering;
            
            //To create a record of Review Process
            rProcess=new Review_Process__c();
            rProcess.BPO_Opportunity__c=oppTGP.id;
            insert rProcess;  
            
            objReviewUser= new Review_User_Master__c();
            objReviewUser.Email_ID_of_the_reviewer__c = testUser3.Email;
            objReviewUser.Name='reviewUaser2';
            objReviewUser.SFDC_User__c = testUser3.id;
            insert objReviewUser;
            
            objReviewTypeMaster=new Review_Type_Master__c();
            List<Review_Type_Master__c> lstRTN=[select id, name from Review_Type_Master__c where name='Final review'];
            if(lstRTN.size()>0)
            {
                objReviewTypeMaster=lstRTN[0];
            }
            else
            {
                objReviewTypeMaster.Name='Final review';
                objReviewTypeMaster.Active__c=true;
                insert objReviewTypeMaster;
            }
            
            objRequestReview=new Request_Review__c ();
            objRequestReview.Review_Process__c=rProcess.id;
            objRequestReview.Status__c=UTIL_constants.PENDING;
            objRequestReview.Select_reviewer__c=true; 
            objRequestReview.Send_reminder__c=true; 
            objRequestReview.Review_User_Master__c=objReviewUser.id;
            objRequestReview.Review_Type_Master__c=objReviewTypeMaster.id;
            objRequestReview.version__c = 1;
            insert objRequestReview;
            
            
            objDoc= new Document_for_Request_Review__c();
            objDoc.Review_Process__c=rProcess.id;
            objDoc.Select_document__c=true;
            objDoc.Document_Name__c='test';
            insert objDoc;
            
            objOppDoc = new Opportunity_Document__c();
            objOppDoc.Name='test123';
            objOppDoc.BPO_Opportunity__c=oppTGP.Id;
            objOppDoc.Client_Name__c=clientName.Id;
            objOppDoc.Select_document__c = true;
            insert objOppDoc;
            
            taskRec = new Task();
            taskRec.Request_Review_Id__c = objRequestReview.id;
            
            insert taskRec;
            
          }  
    }
  /*public static void setupData4()
    {  
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        User testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
        testUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(p,User_Name1);
        Database.insert(testUser2, false);

        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser4 = UTIL_DataCreationForTestClass.getUserWithProfile(p,User_Name2);
        Database.insert(testUser4, false);
    
         profile p2 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.PMO);
     
        testUserPMO = UTIL_DataCreationForTestClass.getUserWithProfile(p2,User_NamePMO);
        insert testUserPMO;
       

        system.runas(testUser2)
        {
            clientName = new Client_Master__c (Name = 'Testv1',Active__c = true);
            insert clientName;
            
            clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
            insert clientGeoArea;
            
            operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
            insert operatingGroup;
            
            clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
            insert clientGeoUnit;
         }
        system.runas(testUser)
        {
            
            oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',complex_cost_architect__c=testUser.id,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                      Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                      Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',TCV__C=55);
            insert oppTGP;
    
            offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
            insert offeringMaster;
            
            oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Solution_Lead__c=testUser.id,Solution_Specialist__c=testUser.id);
            insert oppOffering;
            
            //To create a record of Review Process
            rProcess=new Review_Process__c();
            rProcess.BPO_Opportunity__c=oppTGP.id;
            insert rProcess;  
            
            objReviewUser= new Review_User_Master__c();
            objReviewUser.Email_ID_of_the_reviewer__c = testUser4.Email;
            objReviewUser.Name='reviewUaser2';
            objReviewUser.SFDC_User__c = testUser4.id;
            insert objReviewUser;
            
            objReviewTypeMaster=new Review_Type_Master__c();
            List<Review_Type_Master__c> lstRTN=[select id, name from Review_Type_Master__c where name='Final review'];
            if(lstRTN.size()>0)
            {
                objReviewTypeMaster=lstRTN[0];
            }
            else
            {
                objReviewTypeMaster.Name='Final review';
                objReviewTypeMaster.Active__c=true;
                insert objReviewTypeMaster;
            }
            
            objRequestReview=new Request_Review__c ();
            objRequestReview.Review_Process__c=rProcess.id;
            objRequestReview.Status__c='Not Sent';
            objRequestReview.Select_reviewer__c=true; 
            objRequestReview.Send_reminder__c=true; 
            objRequestReview.Review_User_Master__c=objReviewUser.id;
            objRequestReview.Review_Type_Master__c=objReviewTypeMaster.id;
            insert objRequestReview;
            
            objDoc= new Document_for_Request_Review__c();
            objDoc.Review_Process__c=rProcess.id;
            objDoc.Select_document__c=true;
            objDoc.Document_Name__c='test';
            insert objDoc;
            
            objOppDoc = new Opportunity_Document__c();
            objOppDoc.Name='test123';
            objOppDoc.BPO_Opportunity__c=oppTGP.Id;
            objOppDoc.Client_Name__c=clientName.Id;
            insert objOppDoc;

          }  
    }*/

    static testMethod void testRequsetReviewAdd_InlineController()
    {
        setupData();
        test.starttest();
        
        system.runas(testUser3)
        {
        ApexPages.StandardController controller= new ApexPages.StandardController(rProcess);
        PageReference pageRef= Page.RequsetReviewAdd_Inline;
        pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_ID, String.valueOf(rProcess.Id));
        pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_OPPID, String.valueOf(oppTGP.Id));
        Test.setCurrentPageReference(pageRef);
        RequsetReviewAdd_InlineController obj1= new RequsetReviewAdd_InlineController(controller);
        obj1.addRequestReview();
        /*obj1.ReviewType=objReviewTypeMaster.id;
        
        obj1.saveRequestReviewList();
          */     
        
        }
        test.stopTest();
    }
    static testMethod void testRequsetReviewAdd_InlineController1()
    {
        setupData();
        test.starttest();
        
        system.runas(testUser3)
        {
        ApexPages.StandardController controller= new ApexPages.StandardController(rProcess);
        PageReference pageRef= Page.RequsetReviewAdd_Inline;
        pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_ID, String.valueOf(rProcess.Id));
        pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_OPPID, String.valueOf(oppTGP.Id));
        Test.setCurrentPageReference(pageRef);
        RequsetReviewAdd_InlineController obj1= new RequsetReviewAdd_InlineController(controller);
        obj1.ReviewType=objReviewTypeMaster.id;       
        obj1.addRequestReview();
        }
        test.stopTest();
    }
    static testMethod void testRequsetReviewAdd_InlineController2()
    {
        setupData();
        test.starttest();        
        system.runas(testUser3)
        {
            ApexPages.StandardController controller= new ApexPages.StandardController(rProcess);
            PageReference pageRef= Page.RequsetReviewAdd_Inline;
            pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_ID, String.valueOf(rProcess.Id));
            pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_OPPID, String.valueOf(oppTGP.Id));
            Test.setCurrentPageReference(pageRef);
            RequsetReviewAdd_InlineController obj1= new RequsetReviewAdd_InlineController(controller);
            obj1.saveRequestReviewList();       
        
        }
        test.stopTest();
    }
    static testMethod void testRequsetReviewAdd_InlineController3()
    {
        setupData();
        test.starttest();        
        system.runas(testUser3)
        {
            ApexPages.StandardController controller= new ApexPages.StandardController(rProcess);
            PageReference pageRef= Page.RequsetReviewAdd_Inline;
            pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_ID, String.valueOf(rProcess.Id));
            pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_OPPID, String.valueOf(oppTGP.Id));
            Test.setCurrentPageReference(pageRef);
            RequsetReviewAdd_InlineController obj1= new RequsetReviewAdd_InlineController(controller);  
            obj1.resetUAMFields();          
        
        }
        test.stopTest();
    }
    static testMethod void testRequsetReviewAdd_InlineControllerForDelete()
    {
        setupData();
        test.starttest();
        
        system.runas(testUser3)
        {
        ApexPages.StandardController controller= new ApexPages.StandardController(rProcess);
        PageReference pageRef= Page.RequsetReviewAdd_Inline;
        pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_ID, String.valueOf(rProcess.Id));
        pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_OPPID, String.valueOf(oppTGP.Id));
        Test.setCurrentPageReference(pageRef);
        RequsetReviewAdd_InlineController obj1= new RequsetReviewAdd_InlineController(controller);
        List<SelectOption> lstSelectOpt=obj1.getReviewTypes();
        
        }
        test.stopTest();
    }
    static testMethod void testRequsetReviewAdd_InlineControllerWithPMO()
    {
        setupData();
        test.starttest();
        
        system.runas(testUserPMO)
        {
        ApexPages.StandardController controller= new ApexPages.StandardController(rProcess);
        PageReference pageRef= Page.RequsetReviewAdd_Inline;
        pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_ID, String.valueOf(rProcess.Id));
        pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_OPPID, String.valueOf(oppTGP.Id));
        Test.setCurrentPageReference(pageRef);
        RequsetReviewAdd_InlineController obj1= new RequsetReviewAdd_InlineController(controller);
        //List<SelectOption> lstSelectOpt=obj1.getReviewTypes();
        obj1.addRequestReview();
        }
        test.stopTest();
    }
    static testMethod void testRequsetReviewAdd_InlineController11()
    {
        setupData1();
        test.starttest();
        
        system.runas(testUser3)
        {
        ApexPages.StandardController controller= new ApexPages.StandardController(rProcess);
        PageReference pageRef= Page.RequsetReviewAdd_Inline;
        pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_ID, String.valueOf(rProcess.Id));
        pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_OPPID, String.valueOf(oppTGP.Id));
        Test.setCurrentPageReference(pageRef);
        RequsetReviewAdd_InlineController obj1= new RequsetReviewAdd_InlineController(controller);
        //List<SelectOption> lstSelectOpt=obj1.getReviewTypes();
        obj1.addRequestReview();
        obj1.ReviewType=objReviewTypeMaster.id;
        obj1.newRequestReview.Review_User_Master__c=objReviewTypeMaster.id;
        obj1.newRequestReview.Review_User_Master__c=objReviewUser.id;
        obj1.addRequestReview();
        obj1.getRequestReviewList();
        obj1.saveRequestReviewList();
        obj1.cancelRequestReviewList();
        
       // obj1.cancelDocumentList();
        //obj1.saveDocumentList();
                
        
        }
        test.stopTest();
    }
    static testMethod void testRequsetReviewAdd_InlineController2_new1() {
        setupData1();
        test.starttest();
        
        system.runas(testUser3) {
            ApexPages.StandardController controller= new ApexPages.StandardController(rProcess);
            PageReference pageRef= Page.RequsetReviewAdd_Inline;
            pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_ID, String.valueOf(rProcess.Id));
            pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_OPPID, String.valueOf(oppTGP.Id));
            Test.setCurrentPageReference(pageRef);
            RequsetReviewAdd_InlineController obj1= new RequsetReviewAdd_InlineController(controller);
            //List<SelectOption> lstSelectOpt=obj1.getReviewTypes();
            /*obj1.addRequestReview();
            obj1.ReviewType=objReviewTypeMaster.id;
            obj1.newRequestReview.Review_User_Master__c=objReviewTypeMaster.id;
            obj1.newRequestReview.Review_User_Master__c=objReviewUser.id;
            obj1.addRequestReview();*/
            //obj1.recordIdToDelete = objRequestReview.id;
            obj1.deleteRequestReview();
            
        }
        Test.stopTest();
    }
    static testMethod void testRequsetReviewAdd_InlineController2_new() {
        setupData1();
        test.starttest();
        
        system.runas(testUser3) {
            ApexPages.StandardController controller= new ApexPages.StandardController(rProcess);
            PageReference pageRef= Page.RequsetReviewAdd_Inline;
            pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_ID, String.valueOf(rProcess.Id));
            pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_OPPID, String.valueOf(oppTGP.Id));
            Test.setCurrentPageReference(pageRef);
            RequsetReviewAdd_InlineController obj1= new RequsetReviewAdd_InlineController(controller);
            //List<SelectOption> lstSelectOpt=obj1.getReviewTypes();
            /*obj1.addRequestReview();
            obj1.ReviewType=objReviewTypeMaster.id;
            obj1.newRequestReview.Review_User_Master__c=objReviewTypeMaster.id;
            obj1.newRequestReview.Review_User_Master__c=objReviewUser.id;
            obj1.addRequestReview();*/
            obj1.recordIdToDelete = objRequestReview.id;
            obj1.deleteRequestReview();
            
        }
        Test.stopTest();
    }
    static testMethod void testRequsetReviewAdd_InlineController3_New11() {
        setupData3();
        test.starttest();
        
        system.runas(testUser3) {
            ApexPages.StandardController controller= new ApexPages.StandardController(rProcess);
        PageReference pageRef= Page.RequsetReviewAdd_Inline;
        pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_ID, String.valueOf(rProcess.Id));
        pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_OPPID, String.valueOf(oppTGP.Id));
        Test.setCurrentPageReference(pageRef);
        RequsetReviewAdd_InlineController obj1= new RequsetReviewAdd_InlineController(controller);
        //List<SelectOption> lstSelectOpt=obj1.getReviewTypes();
        //obj1.sendEmailForApproval();
        List<Opportunity_Document__c> docReqReviewDoc = new List<Opportunity_Document__c>();
        docReqReviewDoc.add(objOppDoc);
        obj1.listOpportunityDocument =docReqReviewDoc;
        obj1.getlistOpportunityDocument();
        obj1.sendEmailForApproval();
        obj1.saveDocumentList();
        obj1.cancelDocumentList();
       // obj1.sendEmailForReminder();
        
        //obj1.checkNullValues('test');
        //obj1.checkNullValuesDeciamlTCV(3);
        
        }
        Test.stopTest();
    }
    static testMethod void testRequsetReviewAdd_InlineController3_New111() {
        setupData3();
        test.starttest();
        
        system.runas(testUser3) {
            ApexPages.StandardController controller= new ApexPages.StandardController(rProcess);
        PageReference pageRef= Page.RequsetReviewAdd_Inline;
        pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_ID, String.valueOf(rProcess.Id));
        pageRef.getParameters().put(UTIL_Constants.URL_PARAMETER_OPPID, String.valueOf(oppTGP.Id));
        Test.setCurrentPageReference(pageRef);
        RequsetReviewAdd_InlineController obj1= new RequsetReviewAdd_InlineController(controller);
        //List<SelectOption> lstSelectOpt=obj1.getReviewTypes();
        //obj1.sendEmailForApproval();
        List<Opportunity_Document__c> docReqReviewDoc = new List<Opportunity_Document__c>();
        docReqReviewDoc.add(objOppDoc);
        obj1.listOpportunityDocument =docReqReviewDoc;
        obj1.sendEmailForReminder();
        
        }
        Test.stopTest();
    }
        
}