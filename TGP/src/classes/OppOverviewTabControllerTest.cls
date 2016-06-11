/*
Author : Shridhar Patankar
Story  : Release 2  
Description : Test Class for OppOverviewTabController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class OppOverviewTabControllerTest{
  static User testUser; 
  static User testUser1; 
   static Client_Master__c clientName;
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
     
      Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SOLUTION_ADMIN);
     
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
     
      Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SOLUTION_ADMIN);
     
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
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
      insert oppTGP;
      }
      
  }
  static testMethod void testOppOverviewTabController(){
    test.starttest();
      setupData();
      PageReference pageRef= Page.insertNewopportunity;
       pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
      Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
     // apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
     OppOverviewTabController oppOverview = new OppOverviewTabController(controller); 
     oppOverview.saverecord();
     oppOverview.edit();
     oppOverview.cancelRecord(); 
     }
     static testMethod void testOppOverviewTabController1(){
    test.starttest();
      setupData1();
      PageReference pageRef= Page.insertNewopportunity;
       pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
      Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
     // apexpages.currentpage().getparameters().put('id' ,oppTGP.id);
     OppOverviewTabController oppOverview = new OppOverviewTabController(controller); 
     
        ApexPages.addMessage( new ApexPages.Message(
            ApexPages.Severity.INFO, 'Required field is missing: [Enterprise Solution Architect]'));
       
        
        oppOverview.saverecord();
     
     }
   }