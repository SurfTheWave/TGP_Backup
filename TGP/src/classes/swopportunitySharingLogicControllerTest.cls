/*
Author : Shridhar Patankar
Story  : Story-0149/SOL_036
Description : Test Class for OpportunityOffSharingLogicController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class swopportunitySharingLogicControllerTest{
  static User testUser;
  static User testUser1;
   static Client_Master__c clientName;
   static Client_Geo_Area_Master__c clientGeoArea;
   static Operating_Group_Master__c operatingGroup;
   static Client_Geo_Unit_Master__c clientGeoUnit;
   static Opportunity_TGP__c oppTGP;
   static Opportunity_TGP__c oppTGP1;
   static Opportunity_TGP__c[] oppTGPArray;
   static Opportunity_TGP__c[] oppTGPArray1;
   static Service_Master__c serviceMaster; 
   static Assumption_Master__c assumptionMaster;
   static Offerings_Master__c offeringMaster;
   static Opportunity_Offering__c oppOffering;
   static Opportunity_Offering__c oppOffering1;
   static Opportunity_Offering__c[] oppOfferingArray;
   public static final string USER_NAME = 'vc123@testorg.com';
   static Review_User_Master__c testUserMaster;
   static Review_User_Master__c testUserMasterNew;
   static Assumption__c assumption;
   static List<Opportunity_TGP__c> oppListNew;
  
    public static void setupData(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
      
      testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_NAME);
     insert testUser1;
     
     testUserMaster = new Review_User_Master__c(Name = 'TestUserMaster',Is_Active__c = true, SFDC_User__c = testUser1.id,
                          Email_ID_of_the_reviewer__c = 'TestUserMaster@testorg.com');
    insert   testUserMaster; 
    
    testUserMasterNew = new Review_User_Master__c(Name = 'TestUserMaster',Is_Active__c = true, SFDC_User__c = testUser.id,
                          Email_ID_of_the_reviewer__c = 'TestUserMaster123@testorg.com');
    insert testUserMasterNew;  
      
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect_New__c=testUserMaster.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',Complex_Cost_Architect_New__c = testUserMaster.id, Analytics_Solution_Lead__c = testUserMaster.id);
      insert oppTGP;
      
          
      oppTGP1 = new Opportunity_TGP__c(Name = 'TestIBM1',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect_New__c=testUserMasterNew.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',Complex_Cost_Architect_New__c = testUserMasterNew.id);
      //insert oppTGP1;
      
      oppListNew = [select Name ,Stage__c,Expected_contract_sign_qtr__c,Analytics_Solution_Lead__c,Analytics_Solution_Lead__r.SFDC_User__c,Enterprise_Solution_Architect_New__r.SFDC_User__c,Client_Name__c,Client_Geo_Area__c,Operating_Group__c,Risk_Level__c,Client_Geo_Unit__c,Activity__c,Enterprise_Solution_Architect_New__c,Complex_Cost_Architect_New__r.SFDC_User__c,Complex_Cost_Architect_New__c from Opportunity_TGP__c where id =: oppTGP.id];
      
        
      oppTGPArray = new Opportunity_TGP__c[]{oppTGP};
      
      oppTGPArray1 = new Opportunity_TGP__c[]{oppTGP1};
     
     offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
     
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id,Solution_Lead__c =testUser.id,Solution_Specialist__c=testUser.id,Domain_Expert_Functional_Architect__c=testUser.id,Functional_Architect_Mobilization__c=testUser.id);
     insert oppOffering;
     
     //update oppOffering;
     
     oppOffering1 = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id,Solution_Lead__c =testUser1.id,Solution_Specialist__c=testUser1.id,Domain_Expert_Functional_Architect__c=testUser1.id,Functional_Architect_Mobilization__c=testUser1.id);
     //insert oppOffering1;
     
     //update oppOffering1;
     
     oppOfferingArray = new Opportunity_Offering__c[]{oppOffering1,oppOffering};
    
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;
     
     assumption= new Assumption__c (Name = 'TestAssumption',Assumption__c = 'TestAssume',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
     insert assumption;
    }
    static testMethod void test1(){
    
   test.starttest();
      setupData();
     // ApexPages.StandardController controller;
      
     //swopportunitySharingLogicController swoppSharingLogicController = new swopportunitySharingLogicController();
     swopportunitySharingLogicController.updateOppty(oppListNew,oppTGP1);
     swopportunitySharingLogicController.insertOppty(oppListNew);
   test.stoptest(); 
   }
     
   }