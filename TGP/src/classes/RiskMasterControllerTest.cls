/*
Author : Shridhar Patankar
Story  : Story-0043/SOL_010  
Description : Test Class for RiskMasterController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class RiskMasterControllerTest{
  static User testUser; 
   static Client_Master__c clientName;
   static Client_Geo_Area_Master__c clientGeoArea;
   static Operating_Group_Master__c operatingGroup;
   static Client_Geo_Unit_Master__c clientGeoUnit;
   static Opportunity_TGP__c oppTGP;
   static Service_Master__c serviceMaster; 
   static Assumption_Master__c assumptionMaster;
   static Offerings_Master__c offeringMaster;
   static Opportunity_Offering__c oppOffering;
   static Assumption__c assumption;
   static Client_Dependency_Master__c clientDependencyMaster;
   static Client_Dependency__c clientDependency;
   static Risk_Master__c riskMaster;
   static Risk__c risk;
   static String Offering;
   static String Service;
    public static void setupData(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     	  testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
          Database.insert(testUser, false);
     
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
      insert oppTGP;
      
     
     
     offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
     
     riskMaster = new Risk_Master__c (Category__c = 'TestRiskCategory',Risks__c= 'TestDataRisk',Active_Inactive__c = true);
     insert riskMaster;
     
     oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering;
     
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     
     risk = new Risk__c (Name = 'TestRisk',Risk_Master__c = riskMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id);
     insert risk;
   }
   static testMethod void testRiskMasterController(){
   test.starttest();
      setupData();
      ApexPages.StandardController controller;
      apexpages.currentpage().getparameters().put('id' ,oppOffering.id);
     RiskMasterController riskMasterController = new RiskMasterController( controller);
     RiskMasterController.initializeDetailRecords();
      Risk_Master__c  newRisk = new Risk_Master__c();
      newRisk.Risks__c ='testRisk';  
      newRisk.Classification__c ='testClassification';    
      riskMasterController.Offering = 'testOffering';
      riskMasterController.Service = 'testService'; 
     RiskMasterController.insertNewRecord();
      
     RiskMasterController.updateRecord();
     RiskMasterController.cancelUpdate();
     List<selectOption> getServices =riskMasterController.getServices();
     List<selectOption> getOfferings =riskMasterController.getOfferings();
     List<selectOption> getCategory = riskMasterController.getCategory();
   test.stoptest(); 
   }
   static testMethod void testinsertNewRecord(){
   test.starttest();
      setupData();
      ApexPages.StandardController controller;
      apexpages.currentpage().getparameters().put('id' ,oppOffering.id);
     RiskMasterController riskMasterController = new RiskMasterController( controller);
      RiskMasterController.initializeDetailRecords();
      List<selectOption> getServices =riskMasterController.getServices();
      getServices.add(new selectOption('TestService','TestService'));
      List<selectOption> getOfferings =riskMasterController.getOfferings();
      getOfferings.add(new selectOption('TestOffering','TestOffering'));
       List<selectOption> getCategory =riskMasterController.getCategory();
      getCategory.add(new selectOption('TestCategory','TestCategory'));
      
      RiskMasterController.newRisk.Risks__c='testrisk';
      RiskMasterController.newRisk.Classification__c='testclass';
      
      
      
      riskMasterController.Offering = 'testOffering';
      riskMasterController.Service = 'testService';  
      
      RiskMasterController.insertNewRecord();
      
     
   test.stoptest(); 
   }
 }