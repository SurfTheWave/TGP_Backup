/*
Author : Shridhar Patankar
Story  : Story-0043/SOL_010  
Description : Test Class for assumptionButtonController.Go to Assumption button for display logic of Assumption. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class AssumptionButtonControllerTest{
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
    public static void setupData(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
      
      clientName = new Client_Master__c (Name = 'TestObject1');
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC');
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS');
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM');
      insert clientGeoUnit;
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');

/*      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= :clientName.id,Client_Geo_Area__c='+clientGeoArea.id +',Operating_Group__c='+operatingGroup.id +',Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c='+clientGeoUnit.id +',Activity__c='1-Active',Enterprise_Solution_Architect__c='+testUser.id +',
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
*/      insert oppTGP;

    oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering;

    offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
    
    serviceMaster=UTIL_DataCreationForTestClass.getServiceMaster(oppOffering.id);
    serviceMaster.Name = 'TestService';
    serviceMaster.Offering__c = offeringMaster.id;
    serviceMaster.Active__c = true;
    insert serviceMaster;

    serviceMaster.Name = 'TestService1';
    
    update serviceMaster;

     
     assumptionMaster = UTIL_DataCreationForTestClass.getAssumptionMaster('TestCategory','TestData');
     assumptionMaster.Active_Inactive__c = true;       
     insert assumptionMaster;
     
     
      
    }
    static testMethod void testAssumptionButtonController(){
     test.starttest();
      setupData();

     PageReference pageRef = Page.assumptionInline;

       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id', oppOffering.id);
       ApexPages.StandardController sc = new ApexPages.StandardController(oppOffering);
       AssumptionButtonController control = new AssumptionButtonController(sc);
       control.getAssumption();
      test.stoptest();    

   }
   static testMethod void testAssumptionButtonController1(){
     test.starttest();
      setupData();

     PageReference pageRef = Page.assumptionInline;

       Test.setCurrentPage(pageRef);
      
       ApexPages.StandardController sc = new ApexPages.StandardController(oppOffering);
       AssumptionButtonController control = new AssumptionButtonController(sc);
       control.getAssumption();
      test.stoptest();    

   }
}