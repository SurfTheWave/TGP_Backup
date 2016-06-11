/*
Author : Shridhar Patankar
Story  : Story-0043/SOL_010  
Description : Test Class for ExportClientDependencyController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class ExportClientDependencyControllerTest{
  static User testUser; 
  static User testUser1; 
   static Client_Master__c clientName;
   static Client_Geo_Area_Master__c clientGeoArea;
   static Operating_Group_Master__c operatingGroup;
   static Client_Geo_Unit_Master__c clientGeoUnit;
   static Opportunity_TGP__c oppTGP;
   static Service_Master__c serviceMaster; 
   static Client_Dependency__c clientDependency ;
   static Offerings_Master__c offeringMaster;
   static Offerings_Master__c offeringMaster1;
   static Opportunity_Offering__c oppOffering;
   static Client_Dependency_Master__c clientDependencyMaster ;
   static Boolean readOnlyMode;
   static Review_User_Master__c revUser;
   static String USER_Name = 'vc7@testorg.com';
    public static void setupData(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
     
      Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SOLUTION_ADMIN);
     
     testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
     Database.insert(testUser1, false);
     
    // revUser = UTIL_DataCreationForTestClass.getReviewUserMaster('u123@testUser.com','test');
     //revUser.SFDC_User__c = testUser.id;
     //insert revUser;
     
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      //system.Runas(testUser)
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
      insert oppTGP;
      
     oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering;
      system.Runas(testUser1)
     {
     offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
     
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     clientDependencyMaster = new Client_Dependency_Master__c (Category__c = 'TestClientDepCategory',Client_Dependency__c = 'TestDataClient',Active_Inactive__c = true);
     insert clientDependencyMaster;
     }
    // assumption= new Assumption__c (Name = 'TestAssumption',Assumption__c = 'TestAssume',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id,Classification__c='Internal' );
     //insert assumption;
    }
    public static void setupData1(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
     
      Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SOLUTION_ADMIN);
     
     testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
     Database.insert(testUser1, false);
     
     //revUser = UTIL_DataCreationForTestClass.getReviewUserMaster('u123@testUser','test');
     //revUser.SFDC_User__c = testUser.id;
     //insert revUser;
     
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      //system.Runas(testUser)
     //{
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
      insert oppTGP;
      //} 
      //system.Runas(testUser1)
     //{
     
     offeringMaster1 = UTIL_DataCreationForTestClass.getOfferingMaster('TestOffering');
     insert offeringMaster1;
     
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster1.id,Active__c = true );
     insert serviceMaster;
     
     oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering', Offering_Master__c=offeringMaster1.id, Opportunity_TGP__c=oppTGP.id);
     insert oppOffering;
     
     clientDependencyMaster = new Client_Dependency_Master__c (Category__c = 'TestClientDepCategory',Client_Dependency__c = 'TestDataClient',Active_Inactive__c = true,Offering__c=oppOffering.Offering_Master__c);
     insert clientDependencyMaster;
     //}
     clientDependency = new Client_Dependency__c (Name = 'TestClientDep',Client_Dependency_Master__c = clientDependencyMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id);
     insert clientDependency;
    }
    static testMethod void testExportClientDependencyController  (){
     test.starttest();
      setupData();
      PageReference pageRef = Page.ExportClientDependencyPage;
      ApexPages.StandardController controller;
      apexpages.currentpage().getparameters().put('id' ,oppOffering.id);
     ExportClientDependencyController exportClient = new ExportClientDependencyController ( controller);
     
    test.stoptest();   
    
   }  
   static testMethod void testExportClientDependencyController1(){
     test.starttest();
      setupData1();
      PageReference pageRef = Page.ExportClientDependencyPage;
      ApexPages.StandardController controller;
      apexpages.currentpage().getparameters().put('id' ,oppOffering.id);
     ExportClientDependencyController exportClient = new ExportClientDependencyController( controller);
     String  getFileName = exportClient.getFileName ();
    test.stoptest();   
    
   }  
   static testMethod void testExportClientDependencyController2(){
     test.starttest();
      setupData1();
      String value;
      PageReference pageRef = Page.ExportAssumptionPage;
      ApexPages.StandardController controller;
      
     ExportClientDependencyController exportClient = new ExportClientDependencyController ( controller);
     value = exportClient.getFileName();
    test.stoptest();   
    
   }  
     
   }