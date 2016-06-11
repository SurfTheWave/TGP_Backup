/*
Author : Shridhar Patankar
Story  : Story-0043/SOL_010  
Description : Test Class for ExportRiskController . 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class ExportRiskControllerTest{
  static User testUser; 
  static User testUser1; 
   static Client_Master__c clientName;
   static Client_Geo_Area_Master__c clientGeoArea;
   static Operating_Group_Master__c operatingGroup;
   static Client_Geo_Unit_Master__c clientGeoUnit;
   static Opportunity_TGP__c oppTGP;
   static Service_Master__c serviceMaster; 
   static Risk_Master__c riskMaster ;
   static Offerings_Master__c offeringMaster;
   static Opportunity_Offering__c oppOffering;
   static Risk__c risk ;
   static Boolean readOnlyMode;
   static String USER_Name = 'vc7@testorg.com';
    public static void setupData(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
     
      Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SOLUTION_ADMIN);
     
     testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
     Database.insert(testUser1, false);
     
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      system.Runas(testUser)
     {
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
      insert oppTGP;
      } 
     oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering;
      system.Runas(testUser1)
     {
     offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
     
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     riskMaster = new Risk_Master__c (Category__c = 'TestRiskCategory',Risks__c= 'TestDataRisk',Active_Inactive__c = true);
     insert riskMaster;
     }
    
    }
    public static void setupData1(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
     
      Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SOLUTION_ADMIN);
     
     testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
     Database.insert(testUser1, false);
     
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
      system.Runas(testUser)
     {
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
      insert oppTGP;
      } 
      //system.Runas(testUser1)
     
     
     offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
     
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Offering_Master__c=offeringMaster.id,Opportunity_TGP__c=oppTGP.id);
     insert oppOffering;
     
     riskMaster = new Risk_Master__c (Category__c = 'TestRiskCategory',Risks__c= 'TestDataRisk',Active_Inactive__c = true,Offering_Master__c=oppOffering.Offering_Master__c);
     insert riskMaster;
     
     risk = new Risk__c (Name = 'TestRisk',Risk_Master__c = riskMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id);
     insert risk;
    }
    static testMethod void testExportRiskController(){
     test.starttest();
      setupData();
      PageReference pageRef = Page.ExportRiskPage;
      ApexPages.StandardController controller;
      apexpages.currentpage().getparameters().put('id' ,oppOffering.id);
     ExportRiskController exportRisk = new ExportRiskController( controller);
     String  getFileName =exportRisk.getFileName();
    test.stoptest();   
    
   }  
   static testMethod void testExportRiskController1(){
     test.starttest();
      setupData1();
      PageReference pageRef = Page.ExportRiskPage;
      ApexPages.StandardController controller;
      apexpages.currentpage().getparameters().put('id' ,oppOffering.id);
     ExportRiskController exportRisk = new ExportRiskController( controller);
     
    test.stoptest();   
    
   }  
   static testMethod void testExportRiskController3(){
     test.starttest();
      setupData1();
      String value;
      PageReference pageRef = Page.ExportRiskPage;
      ApexPages.StandardController controller;
      
     ExportRiskController exportRisk = new ExportRiskController( controller);
     value = exportRisk.getFileName();

    test.stoptest();   
    
   }  
     
   }