/*
Author : Shridhar Patankar
Story  : Description : Test Class for deleteofferingopportunitycontroller. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class deleteofferingopportunitycontrollerTest{
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
   static Boolean readOnlyMode;
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
     
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Solution_Specialist__c=testUser.id);
     insert oppOffering;
     
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true,Classification__c='Internal');
     insert assumptionMaster;
     
     assumption= new Assumption__c (Name = 'TestAssumption',Assumption__c = 'TestAssume',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id,Classification__c='Internal' );
     insert assumption;
     
     
   }
   static testMethod void testdeleteofferingopportunitycontroller(){
    test.starttest();
      setupData();
      apexpages.currentpage().getparameters().put('id' , oppTGP.id);

      deleteofferingopportunitycontroller  delOffer = new deleteofferingopportunitycontroller();
      List<Opportunity_Offering__c> oppOffer = new List<Opportunity_Offering__c>();
      oppOffer.add(oppOffering);
      delOffer.delteteoffering();
     
      test.stoptest();   
    
   } 
}