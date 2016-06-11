/*
Author : Shridhar Patankar
Story  : Story-0143/SOL_060   
Description : Test Class for assumptionInlineController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class OpportunitySearchControllerTest{
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
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
      insert oppTGP;
      
     
     
     offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
     
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering;
     
     
     
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;
     
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
      assumption= new Assumption__c (Name = 'TestAssumption',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
     insert assumption;
    }
     static testMethod void testOpportunitySearchController(){
   test.starttest();
      setupData();
      PageReference pageRef= Page.OpportunitySearchPage;
      
      Test.setCurrentPageReference(pageRef);
     // ApexPages.StandardController controller= new ApexPages.StandardController();
     // ApexPages.StandardController controller;
     apexpages.currentpage().getparameters().put('opportunityName' ,'TestIBM');
     apexpages.currentpage().getparameters().put('offeringName' ,'TestCloffer');
     apexpages.currentpage().getparameters().put('listSelectInactive' ,'listvity');
     apexpages.currentpage().getparameters().put('oppSolLead' ,'');
     apexpages.currentpage().getparameters().put('sapOMId' ,'Testsapt');
     apexpages.currentpage().getparameters().put('clientName' ,'TestClient');
     apexpages.currentpage().getparameters().put('geoArea' ,'TestClientgeo');
     apexpages.currentpage().getparameters().put('opGroup' ,'TestClientop');
     apexpages.currentpage().getparameters().put('stage' ,'TestClientstage');
     apexpages.currentpage().getparameters().put('activity' ,'TestClientactivity');
     apexpages.currentpage().getparameters().put('serviceGrp' ,'TestServiceGrp');
     OpportunitySearchController oppSearchController = new OpportunitySearchController( );
     List<String> listString1 = oppSearchController.stages;
     List<String> listString2 = oppSearchController.activities;
     oppSearchController.listViewSelected ='TestListView';
     oppSearchController.listSelectInactive=true;
     oppSearchController.runQuery();
     oppSearchController.opptysBeforeSorting[0] = oppTGP ;
     oppSearchController.sortField = 'Name';
     // oppSearchController.toggleSort();
     //oppSearchController.toggleSortSearchResults();
     oppSearchController.clearFilter(); 
   //  PageReference runSearch= oppSearchController.runSearch();
    // PageReference runListSearch= oppSearchController.runListSearch();
     PageReference generateReport= oppSearchController.generateReport();    
     List<SelectOption> getListViewsOptions = oppSearchController.getListViewsOptions ();
     
     //Covering Pagination Methods
     oppSearchController.beginningSearch();
     oppSearchController.nextSearch();
     oppSearchController.previousSearch();
     boolean b = oppSearchController.getprevSearch();
     boolean b1 = oppSearchController.getnxtSearch();
     Integer e = oppSearchController.getPageNumberSearch();
     Integer I = oppSearchController.getTotalPagesSearch();
     oppSearchController.beginning();
     oppSearchController.next();
     oppSearchController.previous();
     oppSearchController.end();
     boolean bs = oppSearchController.getprev();
     boolean bs1 = oppSearchController.getnxt();
     Integer es = oppSearchController.getPageNumber();
     Integer Is = oppSearchController.getTotalPages();
   
   test.stoptest(); 
   } 
     static testMethod void testOpportunitySearchController1(){
   test.starttest();
      setupData();
      PageReference pageRef= Page.OpportunitySearchPage;
      
      Test.setCurrentPageReference(pageRef);
     // ApexPages.StandardController controller= new ApexPages.StandardController();
     // ApexPages.StandardController controller;
     apexpages.currentpage().getparameters().put('opportunityName' ,'TestIBM');
     apexpages.currentpage().getparameters().put('sapOMId' ,'Testsapt');
     apexpages.currentpage().getparameters().put('clientName' ,'TestClient');
     apexpages.currentpage().getparameters().put('geoArea' ,'TestClientgeo');
     apexpages.currentpage().getparameters().put('opGroup' ,'TestClientop');
    
     OpportunitySearchController oppSearchController = new OpportunitySearchController( );
     oppSearchController.runQuery();
     oppSearchController.opptysBeforeSorting[0] = oppTGP ;
     oppSearchController.sortField = 'Name';
     // oppSearchController.toggleSort();
     
     
   
   test.stoptest(); 
   } 
   static testMethod void testOpportunitySearchController2(){
   test.starttest();
      setupData();
      PageReference pageRef= Page.OpportunitySearchPage;
      
      Test.setCurrentPageReference(pageRef);
     // ApexPages.StandardController controller= new ApexPages.StandardController();
     // ApexPages.StandardController controller;
     
     apexpages.currentpage().getparameters().put('opportunityName' ,'TestIBM');
     apexpages.currentpage().getparameters().put('offeringName' ,'TestCloffer');
     apexpages.currentpage().getparameters().put('listSelectInactive' ,'listvity');
     apexpages.currentpage().getparameters().put('oppSolLead' ,'');
     apexpages.currentpage().getparameters().put('sapOMId' ,'Testsapt');
     apexpages.currentpage().getparameters().put('clientName' ,'TestClient');
     apexpages.currentpage().getparameters().put('geoArea' ,'TestClientgeo');
     apexpages.currentpage().getparameters().put('opGroup' ,'TestClientop');
     apexpages.currentpage().getparameters().put('stage' ,'TestClientstage');
     apexpages.currentpage().getparameters().put('activity' ,'TestClientactivity');
     apexpages.currentpage().getparameters().put('serviceGrp' ,'TestServiceGrp');
     OpportunitySearchController oppSearchController = new OpportunitySearchController( );
     oppSearchController.listViewSelected ='Active Deals - APAC';
     oppSearchController.listSelectInactive=true;
     oppSearchController.runQuery();
     oppSearchController.opptysBeforeSorting[0] = oppTGP ;
     oppSearchController.sortField = 'Name';
     // oppSearchController.toggleSort();
     oppSearchController.clearFilter();
     //PageReference runSearch= oppSearchController.runSearch();
     //PageReference runListSearch= oppSearchController.runListSearch();
     PageReference generateReport= oppSearchController.generateReport();
     List<SelectOption> getListViewsOptions = oppSearchController.getListViewsOptions ();
     
   
   test.stoptest(); 
   } 
   static testMethod void testOpportunitySearchController3(){
   test.starttest();
      setupData();
      PageReference pageRef= Page.OpportunitySearchPage;
      
      Test.setCurrentPageReference(pageRef);
     // ApexPages.StandardController controller= new ApexPages.StandardController();
     // ApexPages.StandardController controller;
     apexpages.currentpage().getparameters().put('opportunityName' ,'TestIBM');
     apexpages.currentpage().getparameters().put('offeringName' ,'TestCloffer');
     apexpages.currentpage().getparameters().put('listSelectInactive' ,'listvity');
     apexpages.currentpage().getparameters().put('oppSolLead' ,'');
     apexpages.currentpage().getparameters().put('sapOMId' ,'Testsapt');
     apexpages.currentpage().getparameters().put('clientName' ,'TestClient');
     apexpages.currentpage().getparameters().put('geoArea' ,'TestClientgeo');
     apexpages.currentpage().getparameters().put('opGroup' ,'TestClientop');
     apexpages.currentpage().getparameters().put('stage' ,'TestClientstage');
     apexpages.currentpage().getparameters().put('activity' ,'TestClientactivity');
     apexpages.currentpage().getparameters().put('serviceGrp' ,'TestServiceGrp');
     OpportunitySearchController oppSearchController = new OpportunitySearchController( );
     oppSearchController.listViewSelected ='Active Deals - EALA';
     oppSearchController.listSelectInactive=true;
     oppSearchController.runQuery();
     oppSearchController.opptysBeforeSorting[0] = oppTGP ;
     oppSearchController.sortField = 'Name';
     // oppSearchController.toggleSort();
     oppSearchController.clearFilter();
     //PageReference runSearch= oppSearchController.runSearch();
    // PageReference runListSearch= oppSearchController.runListSearch();
     PageReference generateReport= oppSearchController.generateReport();
     List<SelectOption> getListViewsOptions = oppSearchController.getListViewsOptions ();
     
   
   test.stoptest(); 
   } 
   static testMethod void testOpportunitySearchController4(){
   test.starttest();
      setupData();
      PageReference pageRef= Page.OpportunitySearchPage;
      
      Test.setCurrentPageReference(pageRef);
     // ApexPages.StandardController controller= new ApexPages.StandardController();
     // ApexPages.StandardController controller;
     apexpages.currentpage().getparameters().put('opportunityName' ,'TestIBM');
     apexpages.currentpage().getparameters().put('offeringName' ,'TestCloffer');
     apexpages.currentpage().getparameters().put('listSelectInactive' ,'listvity');
     apexpages.currentpage().getparameters().put('oppSolLead' ,'');
     apexpages.currentpage().getparameters().put('sapOMId' ,'Testsapt');
     apexpages.currentpage().getparameters().put('clientName' ,'TestClient');
     apexpages.currentpage().getparameters().put('geoArea' ,'TestClientgeo');
     apexpages.currentpage().getparameters().put('opGroup' ,'TestClientop');
     apexpages.currentpage().getparameters().put('stage' ,'TestClientstage');
     apexpages.currentpage().getparameters().put('activity' ,'TestClientactivity');
     apexpages.currentpage().getparameters().put('serviceGrp' ,'TestServiceGrp');
     OpportunitySearchController oppSearchController = new OpportunitySearchController( );
     oppSearchController.listViewSelected ='Active Deals - F&A';
     oppSearchController.listSelectInactive=true;
     oppSearchController.runQuery();
     oppSearchController.opptysBeforeSorting[0] = oppTGP ;
     oppSearchController.sortField = 'Name';
    // oppSearchController.toggleSort();
     oppSearchController.clearFilter();
     //PageReference runSearch= oppSearchController.runSearch();
     //PageReference runListSearch= oppSearchController.runListSearch();
     PageReference generateReport= oppSearchController.generateReport();
     List<SelectOption> getListViewsOptions = oppSearchController.getListViewsOptions ();
     
   
   test.stoptest(); 
   } 
   static testMethod void testOpportunitySearchController5(){
   test.starttest();
      setupData();
      PageReference pageRef= Page.OpportunitySearchPage;
      
      Test.setCurrentPageReference(pageRef);
     // ApexPages.StandardController controller= new ApexPages.StandardController();
     // ApexPages.StandardController controller;
     apexpages.currentpage().getparameters().put('opportunityName' ,'TestIBM');
     apexpages.currentpage().getparameters().put('offeringName' ,'TestCloffer');
     apexpages.currentpage().getparameters().put('listSelectInactive' ,'listvity');
     apexpages.currentpage().getparameters().put('oppSolLead' ,'');
     apexpages.currentpage().getparameters().put('sapOMId' ,'Testsapt');
     apexpages.currentpage().getparameters().put('clientName' ,'TestClient');
     apexpages.currentpage().getparameters().put('geoArea' ,'TestClientgeo');
     apexpages.currentpage().getparameters().put('opGroup' ,'TestClientop');
     apexpages.currentpage().getparameters().put('stage' ,'TestClientstage');
     apexpages.currentpage().getparameters().put('activity' ,'TestClientactivity');
     apexpages.currentpage().getparameters().put('serviceGrp' ,'TestServiceGrp');
     OpportunitySearchController oppSearchController = new OpportunitySearchController( );
     oppSearchController.listViewSelected ='Active Deals - Latin America';
     oppSearchController.listSelectInactive=true;
     oppSearchController.runQuery();
     oppSearchController.opptysBeforeSorting[0] = oppTGP ;
     oppSearchController.sortField = 'Name';
     // oppSearchController.toggleSort();
     oppSearchController.clearFilter();
    // PageReference runSearch= oppSearchController.runSearch();
    // PageReference runListSearch= oppSearchController.runListSearch();
     PageReference generateReport= oppSearchController.generateReport();
     List<SelectOption> getListViewsOptions = oppSearchController.getListViewsOptions ();
     
   
   test.stoptest(); 
   } 
   static testMethod void testOpportunitySearchController6(){
   test.starttest();
      setupData();
      PageReference pageRef= Page.OpportunitySearchPage;
      
      Test.setCurrentPageReference(pageRef);
     // ApexPages.StandardController controller= new ApexPages.StandardController();
     // ApexPages.StandardController controller;
     apexpages.currentpage().getparameters().put('opportunityName' ,'TestIBM');
     apexpages.currentpage().getparameters().put('offeringName' ,'TestCloffer');
     apexpages.currentpage().getparameters().put('listSelectInactive' ,'listvity');
     apexpages.currentpage().getparameters().put('oppSolLead' ,'');
     apexpages.currentpage().getparameters().put('sapOMId' ,'Testsapt');
     apexpages.currentpage().getparameters().put('clientName' ,'TestClient');
     apexpages.currentpage().getparameters().put('geoArea' ,'TestClientgeo');
     apexpages.currentpage().getparameters().put('opGroup' ,'TestClientop');
     apexpages.currentpage().getparameters().put('stage' ,'TestClientstage');
     apexpages.currentpage().getparameters().put('activity' ,'TestClientactivity');
     apexpages.currentpage().getparameters().put('serviceGrp' ,'TestServiceGrp');
     OpportunitySearchController oppSearchController = new OpportunitySearchController( );
     oppSearchController.listViewSelected ='Active Deals - North America';
     oppSearchController.listSelectInactive=true;
     oppSearchController.runQuery();
     oppSearchController.opptysBeforeSorting[0] = oppTGP ;
     oppSearchController.sortField = 'Name';
     oppSearchController.endSearch();
     oppSearchController.runSearchWrapper();
     oppSearchController.runSearch();
     oppSearchController.runListSearch();
     oppSearchController.clearFilter();
     List<opportunity_tgp__c> items = [select id,name from opportunity_tgp__c];
     List<String> stt =oppSearchController.serviceGrpValues;
     
     //PageReference runSearch= oppSearchController.runSearch();
    // PageReference runListSearch= oppSearchController.runListSearch();
     PageReference generateReport= oppSearchController.generateReport();
     List<SelectOption> getListViewsOptions = oppSearchController.getListViewsOptions ();
     
   
   test.stoptest(); 
   }    
   
   }