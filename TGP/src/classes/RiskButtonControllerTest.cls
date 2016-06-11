/*
Author : Shridhar Patankar
Story  : Story-0043/SOL_010  
Description : Test Class for ClientDependencyButtonController.Go to Client Dependency Button button for display logic of Client Dependency. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class RiskButtonControllerTest{
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
   static Risk_Master__c riskMaster;
   static Category__c catMaster; 
   static Risk__c risk;
   
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
      catMaster = new Category__c(Name = 'TestCategory', Active__c=true);
      insert catMaster ;
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM');
      insert clientGeoUnit;
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');

/*      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= :clientName.id,Client_Geo_Area__c='+clientGeoArea.id +',Operating_Group__c='+operatingGroup.id +',Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c='+clientGeoUnit.id +',Activity__c='1-Active',Enterprise_Solution_Architect__c='+testUser.id +',
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
*/      insert oppTGP;
      offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
    
        serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;
     
     oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id, Offering_Master__c =offeringMaster.id);
     insert oppOffering;
     
     riskMaster = new Risk_Master__c (Category__c = catMaster.id,Risks__c= 'TestDataRisk',Active_Inactive__c = true);
     insert riskMaster;
     
     risk = new Risk__c (Name = 'TestRisk',Risk_Master__c = riskMaster.id,Category__c = catMaster.id,Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id);
     insert risk;
     
     
    }
    static testMethod void testRiskButtonController(){
     test.starttest();
      setupData();
      //Id id;
     
     oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id, Offering_Master__c =offeringMaster.id);
     insert oppOffering;
     //id = oppOffering.id;
     PageReference pageRef = Page.riskInline;

       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id', oppOffering.id);
       ApexPages.StandardController sc = new ApexPages.StandardController(oppOffering);
       RiskButtonController control = new RiskButtonController(sc);
       control.getRisk();
      test.stoptest();    

   }
   
   static testMethod void testRiskButtonController1(){
     test.starttest();
      setupData();
      //Id id;
     
     oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id, Offering_Master__c =offeringMaster.id);
     insert oppOffering;
     //id = oppOffering.id;
     PageReference pageRef = Page.riskInline;

       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id', oppOffering.id);
       ApexPages.StandardController sc = new ApexPages.StandardController(oppOffering);
       RiskButtonController control = new RiskButtonController(sc);
       control.getRisk();
      test.stoptest();    

   }
   
}