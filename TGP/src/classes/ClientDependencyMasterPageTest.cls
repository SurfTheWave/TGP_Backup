/*
Author : Shridhar Patankar
Story  : Story-0043/SOL_010  
Description : Test Class for ClientDependencyMasterPage. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class ClientDependencyMasterPageTest{
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
     
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering;
     
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;
     
      assumption= new Assumption__c (Name = 'TestAssumption',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
     insert assumption;
     
     clientDependencyMaster = new Client_Dependency_Master__c (Category__c = 'TestClientCategory',Client_Dependency__c= 'TestDataClient',Active_Inactive__c = true);
     insert clientDependencyMaster;
     
     clientDependency = new Client_Dependency__c(Name = 'TestClient',Client_Dependency_Master__c= clientDependencyMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id);
     insert  clientDependency;
     
   }
   public static void setupData1(){
     
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
     
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering;
     
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;
     
      assumption= new Assumption__c (Name = 'TestAssumption',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
     insert assumption;
     
     
     
   }
   static testMethod void testClientDependencyMasterPage(){
   test.starttest();
      setupData();
      ApexPages.StandardController controller;
      apexpages.currentpage().getparameters().put('id' ,oppOffering.id);
     ClientDependencyMasterPage clientDependencyMasterPage = new ClientDependencyMasterPage ( controller);
     clientDependencyMasterPage.Offering = 'TestOffering';
     clientDependencyMasterPage.Service = 'TEstServices';
     clientDependencyMasterPage.listAllRecords();
     List<selectOption> getServices =clientDependencyMasterPage.getServices();
     List<selectOption> getOfferings =clientDependencyMasterPage.getOfferings();
     List<selectOption> getCategory=clientDependencyMasterPage.getCategory();
      PageReference insertNewRecord= clientDependencyMasterPage.insertNewRecord();
      PageReference updateRecord= clientDependencyMasterPage.updateRecord();
      PageReference cancelUpdate= clientDependencyMasterPage.cancelUpdate();                       
     
   test.stoptest(); 
   }
   static testMethod void testinsertNewRecord(){
   test.starttest();
      setupData();
      ApexPages.StandardController controller;
      apexpages.currentpage().getparameters().put('id' ,oppOffering.id);
     ClientDependencyMasterPage clientDependencyMasterPage = new ClientDependencyMasterPage ( controller);
      List<selectOption> getServices =clientDependencyMasterPage.getServices();
      getServices.add(new selectOption('TestService','TestService'));
      List<selectOption> getOfferings =clientDependencyMasterPage.getOfferings();
      getOfferings.add(new selectOption('TestOffering','TestOffering'));
      PageReference insertNewRecord= clientDependencyMasterPage.insertNewRecord();
      ClientDependencyMasterPage.newDependency.Client_Dependency__c  ='TestData';
      
      PageReference insertNewRecord1= clientDependencyMasterPage.insertNewRecord();
   test.stoptest(); 
   }
   static testMethod void testinsertNewRecordUpdateRecord(){
   test.starttest();
      setupData1();
      ApexPages.StandardController controller;
      apexpages.currentpage().getparameters().put('id' ,oppOffering.id);
     ClientDependencyMasterPage clientDependencyMasterPage = new ClientDependencyMasterPage ( controller);
      List<selectOption> getServices =clientDependencyMasterPage.getServices();
      getServices.add(new selectOption('TestService','TestService'));
      List<selectOption> getOfferings =clientDependencyMasterPage.getOfferings();
      getOfferings.add(new selectOption('TestOffering','TestOffering'));
      PageReference updateRecord= clientDependencyMasterPage.updateRecord();
     
   test.stoptest(); 
   }
 }