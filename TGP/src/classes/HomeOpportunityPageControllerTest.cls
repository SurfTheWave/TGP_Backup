/*
Author : Shridhar Patankar
Story  : Home Page Component   
Description : Test Class for HomeOpportunityPageController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class HomeOpportunityPageControllerTest{
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
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c= testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
      insert oppTGP;
      
     
     
     offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
     
     
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;
     
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering;
     
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
      assumption= new Assumption__c (Name = 'TestAssumption',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
     insert assumption;
    }
     static testMethod void testHomeOpportunityPageController(){
     setupData();
   test.starttest();
   system.runas(testUser)
   {
      
      PageReference pageRef= Page.HomeOpportunityPage;
      
      Test.setCurrentPageReference(pageRef);
     // ApexPages.StandardController controller= new ApexPages.StandardController();
     // ApexPages.StandardController controller;
     apexpages.currentpage().getparameters().put('opportunityName' ,'TestIBM');
     apexpages.currentpage().getparameters().put('sapOMId' ,'Testsapt');
     apexpages.currentpage().getparameters().put('clientName' ,'TestClient');
     apexpages.currentpage().getparameters().put('geoArea' ,'TestClientgeo');
     apexpages.currentpage().getparameters().put('opGroup' ,'TestClientop');
     apexpages.currentpage().getparameters().put('stage' ,'TestClientstage');
     apexpages.currentpage().getparameters().put('activity' ,'TestClientactivity');
     apexpages.currentpage().getparameters().put('offeringName' ,'TestOffering');
     HomeOpportunityPageController homeOppPageContr = new HomeOpportunityPageController( );
     //HomeOpportunityPageController.OpportunityWrapper innerObj = new HomeOpportunityPageController.OpportunityWrapper();
     //HomeOpportunityPageController.OpportunityWrapper innerList = new HomeOpportunityPageController.OpportunityWrapper(oppOffering,oppTGP);
     //innerObj.ListOpportunityWrapper = innerList;
     
     List<Opportunity_Offering__c> lstoppoffl=new List<Opportunity_Offering__c> ();
     lstoppoffl.add(oppOffering);
     HomeOpportunityPageController.OpportunityWrapper obj2 =new HomeOpportunityPageController.OpportunityWrapper(lstoppoffl,oppTGP);
     homeOppPageContr.runQuery();
     homeOppPageContr.toggleSort();
     homeOppPageContr.getDisableNext();
     homeOppPageContr.getPageNumber();
     homeOppPageContr.getTotalPages();
     homeOppPageContr.Next();
     homeOppPageContr.End();
     homeOppPageContr.getDisablePrevious();
     homeOppPageContr.Beginning();
     homeOppPageContr.Previous();
     homeOppPageContr.getDisableNext();
    // homeOppPageContr.getTotal_size();
     homeOppPageContr.getPageNumber();
     homeOppPageContr.getTotalPages();
     homeOppPageContr.getListOpportunityWrapper();
     homeOppPageContr.Next();
     homeOppPageContr.End();
     homeOppPageContr.getDisablePrevious();
     homeOppPageContr.getListOpportunityWrapper();
     homeOppPageContr.sortField=null;
     homeOppPageContr.sortDir=null;


     
    // PageReference runSearch= homeOppPageContr.runSearch();
    
     }
   
   test.stoptest(); 
   } 
     /*static testMethod void testHomeOpportunityPageController1(){
   test.starttest();
      setupData();
      PageReference pageRef= Page.HomeOpportunityPage;
      
      Test.setCurrentPageReference(pageRef);
     // ApexPages.StandardController controller= new ApexPages.StandardController();
     // ApexPages.StandardController controller;
     apexpages.currentpage().getparameters().put('opportunityName' ,'TestIBM');
     apexpages.currentpage().getparameters().put('sapOMId' ,'Testsapt');
     apexpages.currentpage().getparameters().put('clientName' ,'TestClient');
     apexpages.currentpage().getparameters().put('geoArea' ,'TestClientgeo');
     apexpages.currentpage().getparameters().put('opGroup' ,'TestClientop');
    
     HomeOpportunityPageController homeOppPageContr = new HomeOpportunityPageController( );
     homeOppPageContr.runQuery();
     homeOppPageContr.toggleSort();
          
     
   
   test.stoptest(); 
   }*/ 
   }