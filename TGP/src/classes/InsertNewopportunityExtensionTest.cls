/*
Author : Shridhar Patankar
Story  : Story-0043/SOL_010  
Description : Test Class for InsertNewopportunityExtension. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class InsertNewopportunityExtensionTest{
  static User testUser; 
  static User testUser1;
   static Client_Master__c clientName;
   static Client_Master__c clientName1;
   static Client_Geo_Area_Master__c clientGeoArea;
   static Operating_Group_Master__c operatingGroup;
   static Client_Geo_Unit_Master__c clientGeoUnit;
   static Opportunity_TGP__c oppTGP;
   static Opportunity_TGP__c oppTGP1;
   static Service_Master__c serviceMaster; 
   static Assumption_Master__c assumptionMaster;
   static Offerings_Master__c offeringMaster;
   static Opportunity_Offering__c oppOffering;
   static Assumption__c assumption;
   static SAP_OM_Opportunity__c sAPOMOpp; 
   static String USER_Name = 'vc7@testorg.com';
    public static void setupData(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
     
      Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
     testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
     Database.insert(testUser1, false);
     
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

   }
   public static void setupData1(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
     
      Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
     testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
     Database.insert(testUser1, false);
      
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
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes');
      insert oppTGP;
      }

     
   }
   public static void setupData2(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
     
      Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
     testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
     Database.insert(testUser1, false);
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
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes',SAP_OM_Opportunity__c =sAPOMOpp.id );
      insert oppTGP;
     } 
 
   }
   public static void setupData3(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
     
      Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
     testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
     Database.insert(testUser1, false);
     
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
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes',SAP_OM_Opportunity__c =sAPOMOpp.id );
      insert oppTGP;

     }
   }
   static testMethod void testInsertNewopportunityExtension(){
    test.starttest();
      setupData();
      PageReference pageRef= Page.insertNewopportunity;
       pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
      Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
     // apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
     InsertNewopportunityExtension insertNewOppExten = new InsertNewopportunityExtension(controller);
     insertNewOppExten.noSAPID();
     insertNewOppExten.yesSAPID();
     insertNewOppExten.getOption();
     insertNewOppExten.getQuarterNames();
      String option;
      insertNewOppExten.Option = 'No';
     insertNewOppExten.setOption(option);
     
     PageReference nextSection= insertNewOppExten.nextSection();
     List<SelectOption> getclientGeoArea =insertNewOppExten.getclientGeoArea();
     List<SelectOption> getclientGeoUnit=insertNewOppExten.getclientGeoUnit();
     List<SelectOption> getoperatingGroup=insertNewOppExten.getoperatingGroup();
     List<selectOption> getSAPOMIDOptions =insertNewOppExten.getSAPOMIDOptions();
     PageReference saverecord= insertNewOppExten.saverecord();
    test.stoptest(); 
    } 
    static testMethod void testInsertNewopportunityExtension1(){
    test.starttest();
      setupData();
      PageReference pageRef= Page.insertNewopportunity;
       pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
      Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
     // apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
     InsertNewopportunityExtension insertNewOppExten = new InsertNewopportunityExtension(controller);
     insertNewOppExten.Option = 'No';
     insertNewOppExten.noSAPID();
     insertNewOppExten.yesSAPID();
     insertNewOppExten.getOption();
     insertNewOppExten.getQuarterNames();
      String option;
     insertNewOppExten.setOption(option);
     PageReference nextSection= insertNewOppExten.nextSection();
     List<selectOption> getSAPOMIDOptions =insertNewOppExten.getSAPOMIDOptions();
     PageReference saverecord= insertNewOppExten.saverecord();
    test.stoptest(); 
    } 
    static testMethod void testInsertNewopportunityExtension2(){
    test.starttest();
      setupData();
      PageReference pageRef= Page.insertNewopportunity;
      
      Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
     // apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
     InsertNewopportunityExtension insertNewOppExten = new InsertNewopportunityExtension(controller);
     insertNewOppExten.Option = 'Yes';
     insertNewOppExten.noSAPID();
     insertNewOppExten.yesSAPID();
     insertNewOppExten.getOption();
     insertNewOppExten.getQuarterNames();
      String option;
     insertNewOppExten.setOption(option);
     PageReference nextSection= insertNewOppExten.nextSection();
     List<selectOption> getSAPOMIDOptions =insertNewOppExten.getSAPOMIDOptions();
     PageReference saverecord= insertNewOppExten.saverecord();
    test.stoptest(); 
    } 
    static testMethod void testInsertNewopportunityExtensionCheckNull(){
    test.starttest();
      setupData();
      PageReference pageRef= Page.insertNewopportunity;
      pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
      Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
     // apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
     InsertNewopportunityExtension insertNewOppExten = new InsertNewopportunityExtension(controller);
     insertNewOppExten.Option = 'Yes';
     insertNewOppExten.noSAPID();
     insertNewOppExten.yesSAPID();
     insertNewOppExten.getOption();
     insertNewOppExten.getQuarterNames();
      String option;
     insertNewOppExten.setOption(option);
     PageReference nextSection= insertNewOppExten.nextSection();
     List<selectOption> getSAPOMIDOptions =insertNewOppExten.getSAPOMIDOptions();
     PageReference saverecord= insertNewOppExten.saverecord();
    test.stoptest(); 
    } 
    static testMethod void testInsertNewopportunityExtensionCheckNullEmpty(){
    test.starttest();
      setupData1();
      PageReference pageRef= Page.insertNewopportunity;
      pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
      Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
     // apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
     InsertNewopportunityExtension insertNewOppExten = new InsertNewopportunityExtension(controller);
     insertNewOppExten.Option = 'Yes';
     insertNewOppExten.noSAPID();
     insertNewOppExten.yesSAPID();
     insertNewOppExten.getOption();
     insertNewOppExten.getQuarterNames();
     insertNewOppExten.getclientGeoArea();
     insertNewOppExten.getclientGeoUnit();
      String option;
     insertNewOppExten.setOption(option);
     PageReference nextSection= insertNewOppExten.nextSection();
     List<selectOption> getSAPOMIDOptions =insertNewOppExten.getSAPOMIDOptions();
     PageReference saverecord= insertNewOppExten.saverecord();
     
    test.stoptest(); 
    } 
    static testMethod void testInsertNewopportunityExtensionCheckNullEmptyOptionYEs(){
    test.starttest();
      setupData2();
      PageReference pageRef= Page.insertNewopportunity;
      pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
      Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
     // apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
     InsertNewopportunityExtension insertNewOppExten = new InsertNewopportunityExtension(controller);
     insertNewOppExten.Option = 'Yes';
     insertNewOppExten.noSAPID();
     insertNewOppExten.yesSAPID();
     insertNewOppExten.getOption();
     insertNewOppExten.getQuarterNames();
      String option;
     insertNewOppExten.setOption(option);
     PageReference nextSection= insertNewOppExten.nextSection();
     List<selectOption> getSAPOMIDOptions =insertNewOppExten.getSAPOMIDOptions();
     PageReference saverecord= insertNewOppExten.saverecord();
     
    test.stoptest(); 
    } 
    static testMethod void testInsertNewopportunityExtensionSaveOptionYEs(){
    test.starttest();
      setupData2();
      PageReference pageRef= Page.insertNewopportunity;
      pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
      Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
     // apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
     InsertNewopportunityExtension insertNewOppExten = new InsertNewopportunityExtension(controller);
     insertNewOppExten.Option = 'Yes';
     insertNewOppExten.noSAPID();
     insertNewOppExten.yesSAPID();
     insertNewOppExten.getOption();
     insertNewOppExten.getQuarterNames();
      String option;
     insertNewOppExten.setOption(option);
     PageReference nextSection= insertNewOppExten.nextSection();
     List<selectOption> getSAPOMIDOptions =insertNewOppExten.getSAPOMIDOptions();
     PageReference saverecord= insertNewOppExten.saverecord();
     
    test.stoptest(); 
    } 
    static testMethod void testInsertNewopportunityExtensionSaveOptionNO(){
    test.starttest();
      setupData();
      PageReference pageRef= Page.insertNewopportunity;
      pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
      Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
     // apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
     InsertNewopportunityExtension insertNewOppExten = new InsertNewopportunityExtension(controller);
     insertNewOppExten.Option = 'No';
     insertNewOppExten.noSAPID();
     insertNewOppExten.yesSAPID();
     insertNewOppExten.getOption();
     insertNewOppExten.getQuarterNames();
      String option;
     insertNewOppExten.setOption(option);
     PageReference nextSection= insertNewOppExten.nextSection();
     List<selectOption> getSAPOMIDOptions =insertNewOppExten.getSAPOMIDOptions();
     PageReference saverecord= insertNewOppExten.saverecord();
     
    test.stoptest(); 
    } 
    static testMethod void testInsertNewopportunityExtensionSaveRecord(){
    test.starttest();
      setupData3();
      PageReference pageRef= Page.insertNewopportunity;
      pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
      Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
     // apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
     InsertNewopportunityExtension insertNewOppExten = new InsertNewopportunityExtension(controller);
     insertNewOppExten.Option = 'No';
     insertNewOppExten.quarterName = 'FY13 Q1';
      PageReference saverecord= insertNewOppExten.saverecord();
     insertNewOppExten.Option = 'Yes';
     
     insertNewOppExten.quarterName = 'FY13 Q1';
     Integer yearValue=Integer.valueOf(insertNewOppExten.quarterName.subString(2,4));   
     Integer year1=datetime.now().year();
     String strYear=String.valueOf(year1);
     Integer currentYearValue=Integer.valueOf(strYear.subString(2,4));     
     
     
      PageReference saverecord1= insertNewOppExten.saverecord();
     
    test.stoptest(); 
    } 
    static testMethod void testInsertNewopportunityExtensionSaveRecordNedIDNull(){
    test.starttest();
      setupData3();
      PageReference pageRef= Page.insertNewopportunity;
      
      Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
     // apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
     InsertNewopportunityExtension insertNewOppExten = new InsertNewopportunityExtension(controller);
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
      clientName1 = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName1;
      PageReference pageRef= Page.insertNewopportunity;
      
      Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
     // apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
     InsertNewopportunityExtension insertNewOppExten = new InsertNewopportunityExtension(controller);
     insertNewOppExten.opportunity1.Stage__c= 'TestStage';
     insertNewOppExten.opportunity1.Client_Name__c= null;
      PageReference saverecord= insertNewOppExten.saverecord();
     insertNewOppExten.opportunity1.Stage__c= 'TestStage';
     //string.valueOF(insertNewOppExten.opportunity1.Client_Name__c)= clientName1.id;
     insertNewOppExten.opportunity1.Name= null;
     PageReference saverecord1= insertNewOppExten.saverecord();
     insertNewOppExten.opportunity1.Stage__c= 'TestStage';
     //insertNewOppExten.opportunity1.Client_Name__c= 'TestClient';
     insertNewOppExten.opportunity1.Name= 'TestOpp';
     insertNewOppExten.opportunity1.Risk_Level__c= null;
     PageReference saverecord2= insertNewOppExten.saverecord();
     insertNewOppExten.opportunity1.Stage__c= 'TestStage';
    // insertNewOppExten.opportunity1.Client_Name__c= 'TestClient';
     insertNewOppExten.opportunity1.Name= 'TestOpp';
     insertNewOppExten.opportunity1.Risk_Level__c= 'Low';
      insertNewOppExten.opportunity1.Activity__c= null;
     PageReference saverecord3= insertNewOppExten.saverecord();
     insertNewOppExten.opportunity1.Stage__c= 'TestStage';
     //insertNewOppExten.opportunity1.Client_Name__c= 'TestClient';
     insertNewOppExten.opportunity1.Name= 'TestOpp';
     insertNewOppExten.opportunity1.Risk_Level__c= 'Low';
      insertNewOppExten.opportunity1.Activity__c= 'Pipeline';
     PageReference saverecord4= insertNewOppExten.saverecord();
    test.stoptest(); 
    } 
 }