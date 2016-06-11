@istest

private class PMOSolutionUserAssignmentControllerTest{

static User testUser;
static User testUser2;
static Client_Master__c clientName;
static Client_Geo_Area_Master__c clientGeoArea;
static Operating_Group_Master__c operatingGroup;
static Client_Geo_Unit_Master__c clientGeoUnit;
static Offerings_Master__c offeringMaster;
static Opportunity_TGP__c oppTGP;
static Opportunity_TGP__c oppTGP1;
static Solution_User_Assignment__c solusassign;
static Solution_User_Assignment__c solusassign1;
static Solution_User_Assignment__c solusassign2;
private static string USER_NAME = 'vc123@testorg.com';
static Review_User_Master__c testUserMaster;

 public static void SetupData()
{
    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false); 
    
    p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
        testUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_NAME);
        Database.insert(testUser2, false);
        
        testUserMaster = new Review_User_Master__c(Name = 'TestUserMaster',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster@testorg.com',SFDC_User__c=testUser.id);
        insert testUserMaster;
}

public static void Setupdata1()
{
     system.runas(testUser2){
    // Inserting Data in Client Name master    
      clientName = new Client_Master__c (Name = 'DelReportTestObject1',Active__c = true);
      insert clientName;
   
      // Inserting data in Client Geo Area master
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'DelReportTestAPAC',Active__c = true);
      insert clientGeoArea;
      
      // Inserting data in Client Geo Unit Master
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'DelReportTestLATAM',Active__c = true);
      insert clientGeoUnit;
      
      // Inserting Data in Operating Group Master
      operatingGroup = new Operating_Group_Master__c (Name = 'DelReportTestHSMPS',Active__c = true);
      insert operatingGroup;
       
      // Inserting Data in Offering Master   
      offeringMaster = new Offerings_Master__c (Name = 'DelReportTestOffering',Active__c = true);
      insert offeringMaster;
      
      testUserMaster = new Review_User_Master__c(Name = 'TestUserMaster',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster@testorg.com',SFDC_User__c=testUser.id);
      insert testUserMaster;
      }
      
     system.runas(testuser){
      // Inserting Data in Opportunity 
      oppTGP = new Opportunity_TGP__c(Name = 'DelReportTestIBM',Stage__c='Stage 1',complex_cost_architect__c=testUser.id,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ManikReportTestC',OG_Sales_Lead__c='ManikReportTestC',TCV__C=55);
      insert oppTGP;
      
      oppTGP1 = new Opportunity_TGP__c(Name = 'DelReportTestIBM1',Stage__c='Stage 1',complex_cost_architect__c=testUser.id,Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ManikReportTestC1',OG_Sales_Lead__c='ManikReportTestC',TCV__C=55);
      insert oppTGP1;
      
      solusassign= new Solution_User_Assignment__c(BPO_Opportunity__c=oppTGP.id,Status__c='Not Assigned',Resource_Assigned_User_New__c =testUserMaster.id,Offering_Master__c=offeringMaster.id,Role_Requested__c='Complex Cost Architect', Role__c='Complex Cost Architect',Date_Assigned__c=System.today(),Date_Needed_by__c= System.today(),SAP_OM_ID__c='12',Date_Requested__c=System.today(),Comments__c='comments',Requester_Name__c= testuser.id);
         insert solusassign;
    
     solusassign2= new Solution_User_Assignment__c(BPO_Opportunity__c=oppTGP1.id,Status__c='Assigned',Resource_Assigned_User_New__c =testUserMaster.id,Offering_Master__c=offeringMaster.id,Role_Requested__c='Complex Cost Architect', Role__c='Complex Cost Architect',Date_Assigned__c=System.today(),Date_Needed_by__c= System.today(),Date_Requested__c=System.today(),Comments__c='comments',Requester_Name__c= testuser.id);
         insert solusassign2;
         
     }
}


 public static void Setupdata2()
 {
     system.runas(testuser)
     {
      solusassign1= new Solution_User_Assignment__c(BPO_Opportunity__c=oppTGP.id,Status__c='Assigned',Role_Requested__c='Complex Cost Architect',Offering_Master__c=offeringMaster.id, Role__c='Complex Cost Architect',Date_Assigned__c=System.today(),Date_Needed_by__c= System.today(),Date_Requested__c=System.today(),Comments__c='comments',Requester_Name__c= testuser.id);
         insert solusassign1; 
 }
 }
  

   /* static testMethod void testPMOSolutionUserAssignmentController()
    {
        test.starttest();
        setupdata();
        setupdata1();
        setupdata2();
        
         ApexPages.StandardController controller;
        PMOSolutionUserAssignmentController obj=new PMOSolutionUserAssignmentController(controller);
        
        obj.toggleSort();
        //obj.runQuery();
        List<String> r1 = obj.role;
        List<String> s2 = obj.Status;
        Apexpages.currentPage().getParameters().put('role','Complex Cost Architect'); 
        Apexpages.currentPage().getParameters().put('status',solusassign.Status__c);
        Apexpages.currentPage().getParameters().put('SAPSelect','12');
         Apexpages.currentPage().getParameters().put('clSelect',clientname.name);
         Apexpages.currentPage().getParameters().put('oppSelect',oppTGP.name);
        
        obj.runSearch();
        
        obj.initializeDetailRecords();
        obj.submitRequestIds=solusassign.id;
        //obj.searchCriteria();
        obj.strOppLookupValue = oppTGP.name;
        obj.refreshOppValues();
        obj.clearFilter();
        
        List<Solution_User_Assignment__c> solUserAssignList = new List<Solution_User_Assignment__c>();
        solUserAssignList.add(solusassign);
        obj.solUserAssign = solUserAssignList;        
        
        //obj.assignRecords();
         
       // obj.assignRecords();
        obj.submitRequestIds=solusassign1.id;
        
        solUserAssignList = new List<Solution_User_Assignment__c>();
        solUserAssignList.add(solusassign1);
        obj.solUserAssign = solUserAssignList;
        
        obj.onHoldRecords();
        obj.notFilledRecords();
        
        obj.submitRequestIds=solusassign1.id;
        
         system.runas(testuser2)
         {
            try{
             obj.assignRecords();
             }
          catch(Exception ex) {
          }
                         
         }
        
        ApexPages.StandardController controller1;
        PMOSolutionUserAssignmentController obj1=new PMOSolutionUserAssignmentController(controller1);
        
        solUserAssignList = new List<Solution_User_Assignment__c>();
        solUserAssignList.add(solusassign2);
        obj1.solUserAssign = solUserAssignList;
        obj1.submitRequestIds=solusassign2.id;
        
         system.runas(testuser2)
         {
            try{
             obj.assignRecords();
             }
          catch(Exception ex) {
          }
                         
         }
        
  //    List<String>lstOPT1=obj.getUserEmailAddress(testuser2.username);
        List<String>lstOPT1=PMOSolutionUserAssignmentController.getUserEmailAddress(testuser.id);
        
        //obj.sendEmailAlertToAssignedUser((String)oppTGP.id,solusassign.Role__c,'05-14-1995','05-15-1995',solusassign.Comments__c,(String)solusassign.Requester_Name__c,(String)solusassign.Resource_Assigned_User_New__c,(String)solusassign.Technical_Architect_Approval_User__c);
        obj.sendEmailAlertToOnHoldUser((String)oppTGP.id,(String)solusassign.Role__c,'05-14-1995','05-15-1995',(String)solusassign.Comments__c,(String)solusassign.Requester_Name__c);
              
        //obj.Beginning();
        obj.Previous();
        //obj.Next();
        obj.End();
        obj.getDisablePrevious();
        obj.getDisableNext();
        obj.getTotal_size();
        obj.getPageNumber();
        obj.getPageNumber();
        obj.getTotalPages();
        obj.checkNullValues(null);
        obj.checkNullValues('new');
        PMOSolutionUserAssignmentController.checkNullValuesDeciamlTCV(null);
        PMOSolutionUserAssignmentController.checkNullValuesDeciamlTCV(12);
        PMOSolutionUserAssignmentController.checkDateNullValues(null);
        PMOSolutionUserAssignmentController.checkDateNullValues(System.today());
        List<SelectOption>lstOPT2=obj.getPickLstValue();
        
        PMOSolutionUserAssignmentController obj2 = new PMOSolutionUserAssignmentController();
        
        test.stoptest();  
    }*/
    
    static testMethod void testPMOSolutionUserAssignmentController1()
    {
        test.starttest();
        setupdata();
        setupdata1();
        setupdata2();
        
         ApexPages.StandardController controller;
        PMOSolutionUserAssignmentController obj=new PMOSolutionUserAssignmentController(controller);
        
        obj.toggleSort();
        //obj.runQuery();

        Apexpages.currentPage().getParameters().put('role','Complex Cost Architect'); 
        Apexpages.currentPage().getParameters().put('status',solusassign.Status__c);
        Apexpages.currentPage().getParameters().put('SAPSelect','12');
         Apexpages.currentPage().getParameters().put('clSelect',clientname.name);
         Apexpages.currentPage().getParameters().put('oppSelect',oppTGP.name);
        
        obj.runSearch();
        
        obj.initializeDetailRecords();
        obj.submitRequestIds=solusassign1.id;
        //obj.searchCriteria();
        obj.refreshOppValues();
        obj.clearFilter();
      
         
             //obj.assignRecords();
         
      //  obj.assignRecords();
        obj.onHoldRecords();
        obj.notFilledRecords();
        
  //    List<String>lstOPT1=obj.getUserEmailAddress(testuser2.username);
        List<String>lstOPT1=PMOSolutionUserAssignmentController.getUserEmailAddress(testuser.id);
        
        //obj.sendEmailAlertToAssignedUser((String)oppTGP.id,solusassign.Role__c,'05-14-1995','05-15-1995',solusassign.Comments__c,(String)solusassign.Requester_Name__c,(String)solusassign.Resource_Assigned_User_New__c,(String)solusassign.Technical_Architect_Approval_User__c);
        obj.sendEmailAlertToOnHoldUser((String)oppTGP.id,(String)solusassign.Role__c,'05-14-1995','05-15-1995',(String)solusassign.Comments__c,(String)solusassign.Requester_Name__c);
              
        obj.Beginning();
        obj.Previous();
        obj.Next();
        obj.End();
        obj.getDisablePrevious();
        obj.getDisableNext();
        obj.getTotal_size();
        obj.getPageNumber();
        obj.getPageNumber();
        obj.getTotalPages();
        obj.checkNullValues(null);
        obj.checkNullValues('new');
        PMOSolutionUserAssignmentController.checkNullValuesDeciamlTCV(null);
        PMOSolutionUserAssignmentController.checkNullValuesDeciamlTCV(12);
        PMOSolutionUserAssignmentController.checkDateNullValues(null);
        PMOSolutionUserAssignmentController.checkDateNullValues(System.today());
        List<SelectOption>lstOPT2=obj.getPickLstValue();
      
          test.stoptest();  
    }
    
static testMethod void testPMOSolutionUserAssignmentController2()
    {
        test.starttest();
        setupdata();
        setupdata1();
        setupdata2();
        
         ApexPages.StandardController controller;
        PMOSolutionUserAssignmentController obj=new PMOSolutionUserAssignmentController(controller);
        
        obj.toggleSort();
        //obj.runQuery();

        Apexpages.currentPage().getParameters().put('role','Complex Cost Architect'); 
        Apexpages.currentPage().getParameters().put('status',solusassign.Status__c);
        Apexpages.currentPage().getParameters().put('SAPSelect','12');
         Apexpages.currentPage().getParameters().put('clSelect',clientname.name);
         Apexpages.currentPage().getParameters().put('oppSelect',oppTGP.name);    
         obj.runSearch();
        
        obj.initializeDetailRecords();
        obj.submitRequestIds=solusassign1.id;
        //obj.searchCriteria();
        obj.refreshOppValues();
        obj.clearFilter();
         
         system.runas(testuser2)
         {try{
             //obj.assignRecords();
             }
          catch(Exception ex) {
          }
                         
         }
         test.stoptest();
         }
         
    static testMethod void testPMOSolutionUserAssignmentControllerTest()
    {
        test.starttest();
        setupdata();
        setupdata1();
        setupdata2();
        
         ApexPages.StandardController controller;
        PMOSolutionUserAssignmentController obj=new PMOSolutionUserAssignmentController(controller);
        
        solusassign= new Solution_User_Assignment__c(BPO_Opportunity__c=oppTGP.id,Status__c='Not Assigned',Resource_Assigned_User_New__c =testUserMaster.id,Offering_Master__c=offeringMaster.id,Role_Requested__c='Complex Cost Architect', Role__c='Complex Cost Architect',Date_Assigned__c=System.today(),Date_Needed_by__c= System.today(),SAP_OM_ID__c='12',Date_Requested__c=System.today(),Comments__c='comments',Requester_Name__c= testuser.id);
        insert solusassign;
        
        obj.submitRequestIds=solusassign.id;
        //obj.toggleSort();
        //obj.runQuery();

        Apexpages.currentPage().getParameters().put('role','Complex Cost Architect'); 
        Apexpages.currentPage().getParameters().put('status',solusassign.Status__c);
        Apexpages.currentPage().getParameters().put('SAPSelect','12');
         Apexpages.currentPage().getParameters().put('clSelect',clientname.name);
         Apexpages.currentPage().getParameters().put('oppSelect',oppTGP.name);    
         //obj.runSearch();
        
        //obj.initializeDetailRecords();
        //obj.submitRequestIds=solusassign1.id;
        //obj.searchCriteria();
        //obj.refreshOppValues();
        //obj.clearFilter();
        
        
         
         system.runas(testuser2)
         {
            try{
             obj.assignRecords();
             }
          catch(Exception ex) {
          }
                         
         }
         
         test.stoptest();
         
         
         }        
}