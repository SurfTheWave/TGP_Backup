/*
Author : Shridhar Patankar
Story  : Release 2  
Description : Test Class for BPO_Opportunity_tabController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class BPO_Opportunity_tabControllerTest{
  static User testUser; 
  static User testUser1; 
  static User testUserNew; 
  static User testUser12;
  static User testSysAdmUser;
   static Client_Master__c clientName;
   static Client_Geo_Area_Master__c clientGeoArea;
   static Operating_Group_Master__c operatingGroup;
   static Client_Geo_Unit_Master__c clientGeoUnit;
   static Opportunity_TGP__c oppTGP;
   static Opportunity_TGP__c oppTGP1;
   static Opportunity_TGP__c oppTGP2;
   static Opportunity_TGP__c oppTGP3;
   static Opportunity_TGP__c oppTGP4;
   static Opportunity_TGP__c oppTGP5;
   static Opportunity_TGP__c oppTGP6;
   static Service_Master__c serviceMaster; 
   static Assumption_Master__c assumptionMaster;
   static Offerings_Master__c offeringMaster;
   static Opportunity_Offering__c oppOffering;
   static Assumption__c assumption;
   static SAP_OM_Opportunity__c sAPOMOpp;
   static Review_User_Master__c revUser;
   static String User_Name1='vc71@testorg.com';
   static String User_Name12='vc712@testorg.com';
   static String UserName123='vc71223@testorg.com';
   static Comments_on_Opportunity__c commOnBpo;
   static Solution_Plan__c solPlanRec;
   static Key_Buyer_Value__c keyValue;
   static Opportunity_Team_SAP__c oppSapTeam;
   static List<Opportunity_Team_SAP__c> lstOppTeamSap;
 
   
    public static void setupData(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        testUser.email = 'abc@abc321.com';
        Database.insert(testUser, false);
        
      Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,User_Name1);
        Database.insert(testUser1, false);
        
        testUserNew = UTIL_DataCreationForTestClass.getUserWithProfile(p1,User_Name12);
        testUserNew.Email = 'sophia.prem.kumar@accenture.com';
        Database.insert(testUserNew, false);
        
        Profile p3 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
        testSysAdmUser = UTIL_DataCreationForTestClass.getUserWithProfile(p3,'test sysadm');
        Database.insert(testSysAdmUser, false);
      
      revUser = UTIL_DataCreationForTestClass.getReviewUserMaster('sophia.prem.kumar@accenture.com','sophia prem kumar');
      revUser.SFDC_User__c = testUserNew.id;
      revUser.Is_Active__c = true;
      insert revUser ;
      
       system.Runas(testUser1)
     {
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      }
      system.Runas(testUser)
      {
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
      insert oppTGP;
      }
      
      offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
      insert offeringMaster;
     
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
      insert oppOffering;
     
      system.Runas(testUser)
      {
     
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;
     
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     commOnBpo = new Comments_on_Opportunity__c();
      commOnBpo.Comments__c = 'test';
      commOnBpo.BPO_Opportunity__c = oppTGP.id;
      insert commOnBpo;
      
      solPlanRec = new Solution_Plan__c();
      solPlanRec.BPO_Opportunity__c = oppTGP.id;
      solPlanRec.Comments__c = 'test';
      insert solPlanRec;
     
     
     }
      assumption= new Assumption__c (Name = 'TestAssumption',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
     insert assumption;
     
      
     
     
   }
   public static void setupData1(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        testUser.email = 'abc@abc321.com';
        Database.insert(testUser, false);
        
      Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,User_Name1);
        Database.insert(testUser1, false);
      
      revUser = UTIL_DataCreationForTestClass.getReviewUserMaster('sophia.prem.kumar@accenture.com','sophia prem kumar');
      insert revUser ;
      system.Runas(testUser1)
     {
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      
      sAPOMOpp = new SAP_OM_Opportunity__c(Name = '104',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,
                  Expected_contract_sign_Quarter__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Opportunity_Name__c = 'IBMTest');
      insert sAPOMOpp;
      }
     system.Runas(testUser)
     {
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',RFI_response_due__c= System.today()+7,Solution_Start_Date__c = System.today(),RFP_Received__c = System.today()+1,Contract_Signature__c =  System.today()+1,Contract_Start_Date__c = System.today()+1,
                                            Initial_Go_live__c = System.today()+1,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',SAP_OM_Opportunity__c=sAPOMOpp.id,Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes',Offerings__c='test');
      insert oppTGP;
      
      oppSapTeam = new Opportunity_Team_SAP__c(BPO_Opp__c=oppTGP.Id);
      insert oppSapTeam;
      lstOppTeamSap = new List<Opportunity_Team_SAP__c>();
      lstOppTeamSap.add(oppSapTeam);
      
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
      insert oppOffering;
      offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
      insert offeringMaster;
      }
      
      
     system.Runas(testUser1)
     {
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     }
  //   assumption= new Assumption__c (Name = 'TestAssumption',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
    // insert assumption;
      
   }
   public static void setupData102(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        testUser.email = 'abc@abc321.com';
        Database.insert(testUser, false);
        
      Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,User_Name1);
        Database.insert(testUser1, false);
      
      revUser = UTIL_DataCreationForTestClass.getReviewUserMaster('sophia.prem.kumar@accenture.com','sophia prem kumar');
      insert revUser ;
      system.Runas(testUser1)
     {
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      
      sAPOMOpp = new SAP_OM_Opportunity__c(Name = '104',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,
                  Expected_contract_sign_Quarter__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Opportunity_Name__c = 'IBMTest');
      insert sAPOMOpp;
      }
     system.Runas(testUser)
     {
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',RFI_response_due__c= System.today()+7,Solution_Start_Date__c = System.today(),RFP_Received__c = System.today()+1,Contract_Signature__c =  System.today()+1,Contract_Start_Date__c = System.today()+1,
                                            Initial_Go_live__c = System.today()+1,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',SAP_OM_Opportunity__c=sAPOMOpp.id,Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes',Offerings__c='test');
      insert oppTGP;
      
      /*oppSapTeam = new Opportunity_Team_SAP__c(BPO_Opp__c=oppTGP.Id);
      insert oppSapTeam;
      lstOppTeamSap = new List<Opportunity_Team_SAP__c>();
      lstOppTeamSap.add(oppSapTeam);*/
      
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
      insert oppOffering;
      offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
      insert offeringMaster;
      }
      
      
     system.Runas(testUser1)
     {
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     }
  //   assumption= new Assumption__c (Name = 'TestAssumption',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
    // insert assumption;
      
   }
   public static void setupData2(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        testUser.email = 'abc@abc321.com';
        Database.insert(testUser, false);
        
      Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,User_Name1);
        Database.insert(testUser1, false);
      
      revUser = UTIL_DataCreationForTestClass.getReviewUserMaster('sophia.prem.kumar@accenture.com','sophia prem kumar');
      insert revUser ;
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      
      sAPOMOpp = new SAP_OM_Opportunity__c(Name = '104',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,
                  Expected_contract_sign_Quarter__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Opportunity_Name__c = 'IBMTest');
      insert sAPOMOpp;
      system.Runas(testUser)
     {
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Solution_Start_Date__c = System.today(),RFP_Received__c = System.today()+1,Contract_Signature__c =  System.today()+1,Contract_Start_Date__c = System.today()+1,
                                            Initial_Go_live__c = System.today()+1,RFI_response_due__c = System.today()+1,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes',SAP_OM_Opportunity__c =sAPOMOpp.id);
      insert oppTGP;
      }
      offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering;
     system.Runas(testUser1)
     {
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;
     
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     
     }
      assumption= new Assumption__c (Name = 'TestAssumption',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
     insert assumption;
     
     
   }
   public static void setupData3(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        testUser.email = 'abc@abc321.com';
        Database.insert(testUser, false);
        
      Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,User_Name1);
        Database.insert(testUser1, false);
      
      revUser = UTIL_DataCreationForTestClass.getReviewUserMaster('sophia.prem.kumar@accenture.com','sophia prem kumar');
      insert revUser ;
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      
      sAPOMOpp = new SAP_OM_Opportunity__c(Name = '104',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,
                  Expected_contract_sign_Quarter__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Opportunity_Name__c = 'IBMTest',TCV__c=50000);
      insert sAPOMOpp;
      system.Runas(testUser)
     {
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Solution_Start_Date__c = system.today(),Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes',SAP_OM_Opportunity__c =sAPOMOpp.id );
      insert oppTGP;
      }
     /* oppTGP1 = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY13 Q1',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No' );
      insert oppTGP1;*/
     
   }
    public static void setupDateNew1() {
        Delievery_Location_Master__c delLocMaster = UTIL_DataCreationForTestClass.getDelieveryLocationMaster('Test', clientGeoArea.Id);
        delLocMaster.Active__c = true;
        insert delLocMaster;
        Key_Buyer_Value_Category_Master__c keyMaster = UTIL_DataCreationForTestClass.getkeyBuyerValueCategoryMaster('Test');
        keyMaster.Active__c = true;
        insert keyMaster;
        
    }
    public static void setupDateNew2() {
        keyValue = UTIL_DataCreationForTestClass.getkeyBuyerValue(oppTGP.Id);
        keyValue.Description__c ='Test...';
        keyValue.Solution_Component__c = 'Test';
        keyValue.Importance_to_the_client__c = '1';
        insert keyValue;
    }
    
    static testMethod void testInsertNewopportunityExtensionSaveRecord(){
    test.starttest();
      setupData3();
      PageReference pageRef= Page.insertNewopportunity;
      pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
      Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
     // apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
     BPO_Opportunity_tabController insertNewOppExten = new BPO_Opportunity_tabController(controller);
     insertNewOppExten.getstatusOptionsForSubOffering();
     List<selectOption> getClientGEO = insertNewOppExten.getclientGeoArea();
     List<selectOption> getClientUNIT = insertNewOppExten.getclientGeoUnit();
     List<selectOption> getClientOperatingGroup = insertNewOppExten.getoperatingGroup();
     insertNewOppExten.refreshAccProfilePageForKeyBuyerValue();
     insertNewOppExten.Option = 'No';
     insertNewOppExten.quarterName = 'FY13 Q1';
     PageReference saverecord= insertNewOppExten.saverecord();
     insertNewOppExten.Option = 'Yes';
     
     insertNewOppExten.quarterName = 'FY13 Q1';
     PageReference saverecord1= insertNewOppExten.saverecord();
     
     List<selectOption> getSAPOMIDOptions =insertNewOppExten.getSAPOMIDOptions();
     PageReference saverecord2= insertNewOppExten.saverecord();
      
     //BG
     insertNewOppExten.saverecordForOtherCharecteristics();
     insertNewOppExten.noAnalyticsInScope();
     insertNewOppExten.YesAnalyticsInScope();
     insertNewOppExten.saveAccProfileDetails();
     insertNewOppExten.inputShow();
     insertNewOppExten.Option = 'Yes';
     insertNewOppExten.noSAPID();
     insertNewOppExten.yesSAPID();
     insertNewOppExten.getOption();
     insertNewOppExten.getQuarterNames();
     insertNewOppExten.saverecordForOppTimeLineClientBackTab();
     insertNewOppExten.cancelRecordForOppTimeLineClientBackTab();
     insertNewOppExten.docNames();
     //insertNewOppExten.addNewProfDetail();
     insertNewOppExten.getOffering();
     //insertNewOppExten.refreshAccProfilePageInOff();               
           
    test.stoptest(); 
    } 
    static testMethod void testInsertNewopportunityExtensionSaveRecordAgain(){
    test.starttest();
      setupData3();
      PageReference pageRef= Page.insertNewopportunity;
      pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
      Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
     // apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
     BPO_Opportunity_tabController insertNewOppExten = new BPO_Opportunity_tabController(controller);
     insertNewOppExten.getstatusOptionsForSubOffering();
     List<selectOption> getClientGEO = insertNewOppExten.getclientGeoArea();
     List<selectOption> getClientUNIT = insertNewOppExten.getclientGeoUnit();
     List<selectOption> getClientOperatingGroup = insertNewOppExten.getoperatingGroup();
     insertNewOppExten.refreshAccProfilePageForKeyBuyerValue();
     insertNewOppExten.Option = 'No';
     insertNewOppExten.quarterName = 'FY13 Q1';
     PageReference saverecord= insertNewOppExten.saverecord();
     insertNewOppExten.Option = 'Yes';
     
     insertNewOppExten.quarterName = 'FY13 Q1';
     PageReference saverecord1= insertNewOppExten.saverecord();
     
     List<selectOption> getSAPOMIDOptions =insertNewOppExten.getSAPOMIDOptions();
     PageReference saverecord2= insertNewOppExten.saverecord();
      
     insertNewOppExten.refreshAccProfilePageInOff();     
     PageReference pg = insertNewOppExten.GoBackToHomeTab();
     PageReference pg1 = insertNewOppExten.deleteFileForKeyBuyerValue();          
           
    test.stoptest(); 
    } 
    
    static testMethod void testInsertNewopportunityExtensionSaveRecordNedIDNull(){
    test.starttest();
      setupData3();
      PageReference pageRef= Page.insertNewopportunity;
      pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));//BG
      Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
     // apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
     BPO_Opportunity_tabController insertNewOppExten = new BPO_Opportunity_tabController(controller);
     insertNewOppExten.Option = 'No';
     insertNewOppExten.quarterName = 'FY13 Q1';
      PageReference saverecord= insertNewOppExten.saverecord();
     insertNewOppExten.Option = 'Yes';
     
     insertNewOppExten.quarterName = 'FY13 Q1';
      PageReference saverecord1= insertNewOppExten.saverecord();
     
    test.stoptest(); 
    } 
    static testMethod void testInsertNewopportunityExtensionSaveRecordNedIDNull1(){
    test.starttest();
      setupData3();
      PageReference pageRef= Page.insertNewopportunity;
      pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));//BG
      Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
     // apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
     BPO_Opportunity_tabController insertNewOppExten = new BPO_Opportunity_tabController(controller);
     
     insertNewOppExten.Option = 'No';
     insertNewOppExten.quarterName = 'FY13 Q1';
      PageReference saverecord= insertNewOppExten.saverecord();
     insertNewOppExten.Option = 'Yes';
     
     insertNewOppExten.quarterName = 'FY13 Q1';
      PageReference saverecord1= insertNewOppExten.saverecord();
     
    test.stoptest();     
    } 
    static testMethod void uncoveredCodeTest() {
        setupData();
        setupDateNew1();
        Test.startTest();
            PageReference pageRef= Page.insertNewopportunity;
            pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));//BG
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
            BPO_Opportunity_tabController insertNewOppExten = new BPO_Opportunity_tabController(controller);
            insertNewOppExten.setFileIdDelete('Test');
            insertNewOppExten.getFileIdDelete();
            insertNewOppExten.setfileIdDeleteForKeyBuyerValue('Test');
            insertNewOppExten.getfileIdDeleteForKeyBuyerValue();
            List<selectOption> test1 = insertNewOppExten.getlocations();
            insertNewOppExten.addComments();
            insertNewOppExten.commOnBpo.Comments__c = 'Test';
            insertNewOppExten.addComments();
            insertNewOppExten.listCommentsBpo.add(insertNewOppExten.commOnBpo);
            insertNewOppExten.saveComments();
            insertNewOppExten.refreshAccProfilePage();
            insertNewOppExten.deleteFile();
            //insertNewOppExten.getScheduling();
            insertNewOppExten.checkOpp();
            insertNewOppExten.getBCPStandard();
             insertNewOppExten.getstatusOptionsForOffering();
             insertNewOppExten.pagerefresh();
             insertNewOppExten.SaveLinkForOppCircle();
             insertNewOppExten.SaveLinkForOneNote();
             insertNewOppExten.ClickHereForOppCircle();
             insertNewOppExten.ClickHereForOppNote();
            BPO_Opportunity_tabController.AssessmentDetailsActual ter= new BPO_Opportunity_tabController.AssessmentDetailsActual(solPlanRec,true,true);
        Test.stopTest();
    }  
    static testMethod void uncoveredCodeTest1() {
        setupData();
        setupDateNew1();
        ApexPages.CurrentPage().getParameters().put('id',oppTGP.Id);
        Test.startTest();
            PageReference pageRef= Page.insertNewopportunity;
            pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));//BG
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
            BPO_Opportunity_tabController insertNewOppExten = new BPO_Opportunity_tabController(controller);
            insertNewOppExten.newProfDetail = oppOffering;
            insertNewOppExten.pageid = oppTGP.Id;
            insertNewOppExten.opptys1 = new List<Opportunity_Offering__c>();
            insertNewOppExten.initializeDetailRecordsForSolutionPlan();
            insertNewOppExten.getDocumentfromMasters();
            insertNewOppExten.SaveLink();
            insertNewOppExten.objOpportunity.Link_to_Additional_Documents__c ='Test';
            insertNewOppExten.ClickHere();
            insertNewOppExten.newProfDetail.Solution_Lead_New__c = revUser.Id;
            insertNewOppExten.newProfDetail = new Opportunity_Offering__c();
            insertNewOppExten.addNewProfDetail();
            insertNewOppExten.newProfDetail.Solution_Lead_New__c = revUser.Id;
            insertNewOppExten.listProfileDetailsActual.add(oppOffering);
            insertNewOppExten.saveAccProfileDetails();
            insertNewOppExten.fileIdDelete = oppTGP.Id; 
            insertNewOppExten.deleteFileForOff();
            List<selectOption> test1 = insertNewOppExten.getCategories();
        Test.stopTest();
    }
    static testMethod void uncoveredCodeTest2() {
        setupData();
        setupDateNew2();
        Test.startTest();
            PageReference pageRef= Page.insertNewopportunity;
            pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));//BG
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
            BPO_Opportunity_tabController insertNewOppExten = new BPO_Opportunity_tabController(controller);
            insertNewOppExten.newProfDetailForKeyBuyerValue = new Key_Buyer_Value__c();
            insertNewOppExten.newProfDetailForKeyBuyerValue.Description__c = 'Test';
            insertNewOppExten.newProfDetailForKeyBuyerValue.Solution_Component__c = 'Test';
            insertNewOppExten.newProfDetailForKeyBuyerValue.Importance_to_the_client__c ='1';
            insertNewOppExten.addNewProfDetailForKeyBuyerValue();
            insertNewOppExten.listProfileDetailsActualForKeyBuyerValue.add(keyValue);
            insertNewOppExten.saveAccProfileDetailsForKeyBuyerValue();
            //insertNewOppExten.setOption(UTIL_Constants.YES);
            //insertNewOppExten.Option = UTIL_Constants.YES;
            //insertNewOppExten.nextSection();
            insertNewOppExten.Option = UTIL_Constants.YES;
            insertNewOppExten.saverecord();
            insertNewOppExten.saverecordOtherCharacteristics();
        Test.stopTest();
    }
    static testMethod void uncoveredNextSection() {
        
        setupData1();
        //setupDateNew2();
        Test.startTest();
            PageReference pageRef= Page.insertNewopportunity;
            pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));//BG
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
            BPO_Opportunity_tabController insertNewOppExten = new BPO_Opportunity_tabController(controller);
            insertNewOppExten.setOption(UTIL_Constants.YES);
            //insertNewOppExten.Option = UTIL_Constants.YES;
            insertNewOppExten.nextSection();
            insertNewOppExten.Option = UTIL_Constants.YES;
            insertNewOppExten.saverecord();
            insertNewOppExten.saverecordOtherCharacteristics();
        Test.stopTest();
    }
    static testMethod void uncoveredNextSection1() {
        
        setupData102();
        //setupDateNew2();
        Test.startTest();
            PageReference pageRef= Page.insertNewopportunity;
            pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));//BG
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
            BPO_Opportunity_tabController insertNewOppExten = new BPO_Opportunity_tabController(controller);
            insertNewOppExten.setOption(UTIL_Constants.YES);
            //insertNewOppExten.Option = UTIL_Constants.YES;
            insertNewOppExten.nextSection();
            insertNewOppExten.Option = UTIL_Constants.YES;
            insertNewOppExten.saverecord();
            insertNewOppExten.saverecordOtherCharacteristics();
        Test.stopTest();
    }
    static testMethod void uncoveredCodeTest3() {
        setupData();
        Test.startTest();
            PageReference pageRef= Page.insertNewopportunity;
            pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));//BG
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
            BPO_Opportunity_tabController insertNewOppExten = new BPO_Opportunity_tabController(controller);
            insertNewOppExten.edit();
            insertNewOppExten.edit1();
            insertNewOppExten.cancelRecord();
            insertNewOppExten.saverecordForOtherCharecteristics();
            insertNewOppExten.starting();
            insertNewOppExten.ending();
            insertNewOppExten.getOfferings();
            insertNewOppExten.getOfferingsOnGeneralInfo();
        Test.stopTest();
    }
    static testMethod void uncoveredCodeTest4() {
    setupData();
        Test.startTest();
            PageReference pageRef= Page.insertNewopportunity;
            pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));//BG
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
            BPO_Opportunity_tabController insertNewOppExten = new BPO_Opportunity_tabController(controller);
            insertNewOppExten.opportunity1 = oppTGP;
            insertNewOppExten.opportunity1.Analytics_in_Scope__c =UTIL_Constants.NO;
            insertNewOppExten.opportunity1.Capacity_Services_in_Scope__c =UTIL_Constants.NO;
            insertNewOppExten.opportunity1.Capacity_Services_in_Scope__c =UTIL_Constants.NO;
            insertNewOppExten.saverecordForOtherCharecteristics();
            insertNewOppExten.opportunity1.BSS_SC__c = 'Test';
            insertNewOppExten.saverecordForOtherCharecteristics();
            insertNewOppExten.opportunity1.BSS_SM__c = 'Test';
            insertNewOppExten.saverecordForOtherCharecteristics();
            insertNewOppExten.opportunity1.BSS_EDM__c = 'Test';
            insertNewOppExten.saverecordForOtherCharecteristics();
            insertNewOppExten.opportunity1.BSS_Command_Center__c = 'Test';
            insertNewOppExten.saverecordForOtherCharecteristics();
            insertNewOppExten.opportunity1.BPO_Tech__c = 'Test';
            insertNewOppExten.saverecordForOtherCharecteristics();
        Test.stopTest();
    }
    static testMethod void uncoveredCodeTest5() {
        setupData1();
        
        Test.startTest();
            PageReference pageRef= Page.insertNewopportunity;
            pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));//BG
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
            BPO_Opportunity_tabController insertNewOppExten = new BPO_Opportunity_tabController(controller);
            insertNewOppExten.clientGeoAreaMaster = UTIL_Constants.NONE_FOR_PICKLIST;
            insertNewOppExten.operatingGroupMaster = UTIL_Constants.NONE_FOR_PICKLIST;
            insertNewOppExten.opportunity1 = new Opportunity_TGP__c();
            insertNewOppExten.saverecord();
            insertNewOppExten.opportunity1.Client_Name__c = clientName.Id;
            insertNewOppExten.saverecord();
            insertNewOppExten.opportunity1.Name = 'Test12';
            insertNewOppExten.saverecord();
            insertNewOppExten.opportunity1.Stage__c = '0A';
            insertNewOppExten.saverecord();
            insertNewOppExten.clientGeoAreaMaster = clientGeoArea.Id;
            insertNewOppExten.saverecord();
            insertNewOppExten.operatingGroupMaster = operatingGroup.Id;
            insertNewOppExten.saverecord();
            insertNewOppExten.opportunity1.Activity__c = 'Lost';
            insertNewOppExten.saverecord();
            insertNewOppExten.opportunity1.Risk_Level__c = 'Low';
            insertNewOppExten.saverecord();
            insertNewOppExten.opportunity1.Enterprise_Solution_Architect_New__c = revUser.Id;
            insertNewOppExten.saverecord();
            insertNewOppExten.Option = UTIL_Constants.YES;
            insertNewOppExten.saverecord();
            insertNewOppExten.opportunity1.SAP_OM_Opportunity__c = sAPOMOpp.ID;
            insertNewOppExten.saverecord();
            ApexPages.CurrentPage().getParameters().put('id',oppTGP.Id);
            insertNewOppExten.saverecord();
            insertNewOppExten.Option = UTIL_Constants.NO;
            insertNewOppExten.quarterName = UTIL_Constants.NONE;
            insertNewOppExten.saverecord();
            insertNewOppExten.quarterName = 'FY14-Q4';
            insertNewOppExten.saverecord();
            
        Test.stopTest();    
    }
 }