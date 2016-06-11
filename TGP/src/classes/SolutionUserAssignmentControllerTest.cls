/*
Author : Shridhar Patankar
Story  : Release 2
Description : Test Class for SolutionUserAssignmentController.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
@isTest
private class SolutionUserAssignmentControllerTest{
   static User testUser; 
   static Client_Master__c clientName;
   static Client_Geo_Area_Master__c clientGeoArea;
   static Operating_Group_Master__c operatingGroup;
   static Client_Geo_Unit_Master__c clientGeoUnit;
   static Opportunity_TGP__c oppTGP;
   static Client_Dependency_Master__c clientdependency;
   static Opportunity_Offering__c oppOffering;
   static Offerings_Master__c offeringMaster;
   static Risk_Master__c listRiskMaster;
   static Services__c service;
   static Service_Master__c serviceMaster;
   static Assumption_Master__c listAssumptionMaster;
   static List<Services__c> lservice = new List<Services__c>();
   static Solution_User_Assignment__c sua;
   static Solution_User_Assignment__c sua1;
   static Solution_User_Assignment__c sua2;
   static SAP_OM_Opportunity__c sAPOMOpp ;
   static Service_Delivery_Location__c serviceDeliveryLocation;
  
    public static void setupData(){
     
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        
        System.debug('CheckingInsert:: '+'testUser'+testUser.Id);     
      
        String[] thirdPartyvendor = new String[]{};
       
      
        clientName = new Client_Master__c (Name = 'TestObject1');
        insert clientName;
        
        System.debug('CheckingInsert:: '+'clientName'+clientName.Id); 
      
        clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC');
        insert clientGeoArea;
        
        System.debug('CheckingInsert:: '+'clientGeoArea'+clientGeoArea.Id); 
      
        operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS');
        insert operatingGroup;
        
        System.debug('CheckingInsert:: '+'operatingGroup'+operatingGroup.Id); 
      
        clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM');
        insert clientGeoUnit;
        
        System.debug('CheckingInsert:: '+'clientGeoUnit'+clientGeoUnit.Id);
      
        sAPOMOpp = new SAP_OM_Opportunity__c(Name = '104',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,
                  Expected_contract_sign_Quarter__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Opportunity_Name__c = 'IBMTest');
        insert sAPOMOpp;
        
        System.debug('CheckingInsert:: '+'sAPOMOpp'+sAPOMOpp.Id);
         
        oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='Yes',SAP_OM_Opportunity__c=sAPOMOpp .id);
        insert oppTGP;
        
        System.debug('CheckingInsert:: '+'oppTGP'+oppTGP.Id);


        offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
        insert offeringMaster;
        
        System.debug('CheckingInsert:: '+'offeringMaster'+offeringMaster.Id);
        
        oppOffering = new Opportunity_Offering__c(Domain_Expert_Functional_Architect_1__c=testUser.id,Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id);
        insert oppOffering;
        
        System.debug('CheckingInsert:: '+'oppOffering'+oppOffering.Id);

        clientdependency = new Client_Dependency_Master__c();
        clientdependency.Category__c='Language';
        clientdependency.Client_Dependency__c='English';
        clientdependency.Active_Inactive__c=true;
        
        insert clientdependency;
        
        System.debug('CheckingInsert:: '+'clientdependency'+clientdependency.Id);
        
        serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
        insert serviceMaster;
        
        System.debug('CheckingInsert:: '+'serviceMaster'+serviceMaster.Id);
        
        serviceDeliveryLocation = new Service_Delivery_Location__c(Name = serviceMaster.name, Opportunity_Offering__c = oppOffering.id, Service_Master__c = serviceMaster.id);
        insert serviceDeliveryLocation;
        
        System.debug('CheckingInsert:: '+'serviceDeliveryLocation'+serviceDeliveryLocation.Id);
        
        service = new Services__c (Opportunity_Offering__c = oppOffering.id, Service_Text_Name__c = 'TestService',Active__c=true, Service_Delivery_Location__c = serviceDeliveryLocation.Id);
        insert service;   
        
        System.debug('CheckingInsert:: '+'service'+service.Id);
        
        lservice.add(service);
           
        /*service = new Services__c (Opportunity_Offering__c = oppOffering.id, Service_Text_Name__c = 'TestService',Active__c=true, Service_Delivery_Location__c = serviceDeliveryLocation.Id);
        insert service;
        
        
        lservice.add(service); */
        
        listRiskMaster = new Risk_Master__c(Offering_Master__c = offeringMaster.id,Active_Inactive__c = true,Service_Master__c = serviceMaster.id);
        insert listRiskMaster;
        
        System.debug('CheckingInsert:: '+'listRiskMaster'+listRiskMaster.Id);
        
        listAssumptionMaster = new Assumption_Master__c(Assumption__c = 'TestAssumption',Active_Inactive__c = true,Offering__c = offeringMaster.id,Services_per_Offering__c = serviceMaster.id);
        insert listAssumptionMaster; 
        
        System.debug('CheckingInsert:: '+'listAssumptionMaster'+listAssumptionMaster.Id);
        
        sua = new Solution_User_Assignment__c (BPO_Opportunity__c=oppTGP.id,Role__c = 'Complex Cost Architect',Offering_Master__c=offeringMaster.id,Solutions__c=oppOffering.id,User__c=testUser.id,Resource_Assigned_User__c=testUser.id,Requester_Name__c=testUser.id,Status__c = 'New');
        insert sua;
        
        System.debug('CheckingInsert:: '+'sua'+sua.Id);
        
        sua1 = new Solution_User_Assignment__c (BPO_Opportunity__c=oppTGP.id,Role__c = 'Complex Cost Architect',Offering_Master__c=offeringMaster.id,Solutions__c=oppOffering.id,User__c=testUser.id,Resource_Assigned_User__c=testUser.id,Requester_Name__c=testUser.id, Status__c = 'Cancelled');
        insert sua1;
        
        System.debug('CheckingInsert:: '+'sua1'+sua1.Id);
        
        sua2 = new Solution_User_Assignment__c (BPO_Opportunity__c=oppTGP.id,Role__c = 'Complex Cost Architect',Offering_Master__c=offeringMaster.id,Solutions__c=oppOffering.id,User__c=testUser.id,Resource_Assigned_User__c=testUser.id,Requester_Name__c=testUser.id, Status__c = 'In Progress');
        insert sua2;
        
        System.debug('CheckingInsert:: '+'sua2'+sua2.Id);
 }
 
 
    static testMethod void testSolutionUserAssignmentController(){
     test.starttest();
     setupData();
     system.runas(testUser){
            PageReference pageRef = Page.SolutionUserAssignment;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', oppTGP.id);
           
           apexpages.currentpage().getparameters().put('role' ,'Complex Cost Architect');
           apexpages.currentpage().getparameters().put('status' ,'New');
           apexpages.currentpage().getparameters().put('SAPSelect' ,'103');
           apexpages.currentpage().getparameters().put('clSelect' ,'Singapore Power Ltd');
           apexpages.currentpage().getparameters().put('oppSelect' ,'New York');
           String s=sua.id+','+sua1.id+','+sua2.id;
           apexpages.currentpage().getparameters().put('submitRequestIds' ,s);
           
           ApexPages.StandardController sc = new ApexPages.StandardController(oppTGP);
           SolutionUserAssignmentController  solUserAssContr = new SolutionUserAssignmentController(sc);
           
           solUserAssContr.submitRequestIds=sua.id;
           
           solUserAssContr.toggleSort();
           solUserAssContr.runQuery();
           PageReference runSearch = solUserAssContr.runSearch ();
           solUserAssContr.solUserAssign.add(sua);
           solUserAssContr.submitRequestIds = s;
           //solUserAssContr.submitRequestRecords();
           //solUserAssContr.cancelRequestRecords();
           //solUserAssContr.modifyRequestRecords();
           
           //Pagereference modifyRequestRecords=solUserAssContr.modifyRequestRecords();
           //Pagereference cancelRequestRecords=solUserAssContr.cancelRequestRecords();
           Pagereference Beginning=solUserAssContr.Beginning();
           Pagereference Previous=solUserAssContr.Previous();
           Pagereference Next=solUserAssContr.Next();
           Pagereference evnd=solUserAssContr.End();
           Boolean getDisablePrevious=solUserAssContr.getDisablePrevious();
           Boolean getDisableNext=solUserAssContr.getDisableNext();
           Integer getPageNumber=solUserAssContr.getPageNumber();
           Integer getTotalPages=solUserAssContr.getTotalPages();
           Integer getTotal_size=solUserAssContr.getTotal_size();
          // solUserAssContr.savingCustomerRecord();
           //solUserAssContr.clearFilter();
           String value;
           Decimal value1;
           Date value2;
           //String checkNullValues=solUserAssContr.checkNullValues(value);
           //String checkNullValuesDeciamlTCV=SolutionUserAssignmentController.checkNullValuesDeciamlTCV(value1);
          // String checkDateNullValues=SolutionUserAssignmentController.checkDateNullValues(value2);
           String oppId;
           String roleName;
           String dateNeeded;
           String  dateRequested;
           String comment;
           String request;
           //solUserAssContr.sendEmailAlertToPmo(oppId,roleName,dateNeeded,dateRequested,comment,request);
          // List<String> getMAEmailAddresses = solUserAssContr.getMAEmailAddresses();
          // List<String> getSSEmailAddresses= solUserAssContr.getSSEmailAddresses();
          // List<String> getTAEmailAddresses= solUserAssContr.getTAEmailAddresses();
          // List<String> getCCAEmailAddresses= solUserAssContr.getCCAEmailAddresses();
          // List<String> getOSLEmailAddresses = solUserAssContr.getOSLEmailAddresses();
           //List<String> getEmailAddresses= solUserAssContr.getEmailAddresses();
           //List<String> status= solUserAssContr.status();
           //List<String> role= solUserAssContr.role();
     }
      test.stoptest();    

   }
   static testMethod void testSolutionUserAssignmentControllerNew(){
     test.starttest();
     setupData();
     system.runas(testUser){
            PageReference pageRef = Page.SolutionUserAssignment;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', oppTGP.id);
           
           apexpages.currentpage().getparameters().put('role' ,'Complex Cost Architect');
           apexpages.currentpage().getparameters().put('status' ,'New');
           apexpages.currentpage().getparameters().put('SAPSelect' ,'103');
           apexpages.currentpage().getparameters().put('clSelect' ,'Singapore Power Ltd');
           apexpages.currentpage().getparameters().put('oppSelect' ,'New York');
           String s=sua.id+','+sua1.id+','+sua2.id;
           apexpages.currentpage().getparameters().put('submitRequestIds' ,s);
           
           ApexPages.StandardController sc = new ApexPages.StandardController(oppTGP);
           SolutionUserAssignmentController  solUserAssContr = new SolutionUserAssignmentController(sc);
           
           solUserAssContr.submitRequestIds=sua.id;
           
           solUserAssContr.toggleSort();
           solUserAssContr.runQuery();
           PageReference runSearch = solUserAssContr.runSearch ();
           solUserAssContr.solUserAssign.add(sua);
           solUserAssContr.submitRequestIds = s;
           //Pagereference modifyRequestRecords=solUserAssContr.modifyRequestRecords();
           //Pagereference cancelRequestRecords=solUserAssContr.cancelRequestRecords();

           //solUserAssContr.clearFilter();
           String value;
           Decimal value1;
           Date value2;
           String checkNullValues=solUserAssContr.checkNullValues(value);
           String checkNullValuesDeciamlTCV=SolutionUserAssignmentController.checkNullValuesDeciamlTCV(value1);
           String checkDateNullValues=SolutionUserAssignmentController.checkDateNullValues(value2);
           String oppId;
           String roleName;
           String dateNeeded;
           String  dateRequested;
           String comment;
           String request;
           //solUserAssContr.sendEmailAlertToPmo(oppId,roleName,dateNeeded,dateRequested,comment,request);
          // List<String> getMAEmailAddresses = solUserAssContr.getMAEmailAddresses();
          
     }
      test.stoptest();    

   }
   static testMethod void testSolutionUserAssignmentControllerNew1(){
     test.starttest();
     setupData();
     system.runas(testUser){
            PageReference pageRef = Page.SolutionUserAssignment;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', oppTGP.id);
           
           apexpages.currentpage().getparameters().put('role' ,'Complex Cost Architect');
           apexpages.currentpage().getparameters().put('status' ,'New');
           apexpages.currentpage().getparameters().put('SAPSelect' ,'103');
           apexpages.currentpage().getparameters().put('clSelect' ,'Singapore Power Ltd');
           apexpages.currentpage().getparameters().put('oppSelect' ,'New York');
           String s=sua.id+','+sua1.id+','+sua2.id;
           apexpages.currentpage().getparameters().put('submitRequestIds' ,s);
           
           ApexPages.StandardController sc = new ApexPages.StandardController(oppTGP);
           SolutionUserAssignmentController  solUserAssContr = new SolutionUserAssignmentController(sc);
           


           //List<String> getSSEmailAddresses= solUserAssContr.getSSEmailAddresses();
           //List<String> getTAEmailAddresses= solUserAssContr.getTAEmailAddresses();
           //List<String> getCCAEmailAddresses= solUserAssContr.getCCAEmailAddresses();
           //List<String> getOSLEmailAddresses = solUserAssContr.getOSLEmailAddresses();
           //List<String> getEmailAddresses= solUserAssContr.getEmailAddresses();
           //List<String> status= solUserAssContr.status();
           //List<String> role= solUserAssContr.role();
     }
      test.stoptest();    

   }
    
    //New Methods for 101 issue
        
        static testMethod void testSolutionUserAssignmentController1(){
     test.starttest();
     setupData();
     system.runas(testUser){
            PageReference pageRef = Page.SolutionUserAssignment;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', oppTGP.id);
           
           apexpages.currentpage().getparameters().put('role' ,'Complex Cost Architect');
           apexpages.currentpage().getparameters().put('status' ,'New');
           apexpages.currentpage().getparameters().put('SAPSelect' ,'103');
           apexpages.currentpage().getparameters().put('clSelect' ,'Singapore Power Ltd');
           apexpages.currentpage().getparameters().put('oppSelect' ,'New York');
           String s=sua.id+','+sua1.id+','+sua2.id;
           apexpages.currentpage().getparameters().put('submitRequestIds' ,s);
           
           ApexPages.StandardController sc = new ApexPages.StandardController(oppTGP);
           SolutionUserAssignmentController  solUserAssContr = new SolutionUserAssignmentController(sc);
           
           solUserAssContr.submitRequestIds=sua.id;
           
           solUserAssContr.toggleSort();
           solUserAssContr.runQuery();
           PageReference runSearch = solUserAssContr.runSearch ();
           solUserAssContr.solUserAssign.add(sua);
           solUserAssContr.submitRequestIds = s;
           //solUserAssContr.submitRequestRecords();
           //solUserAssContr.cancelRequestRecords();
           //solUserAssContr.modifyRequestRecords();
           
           //Pagereference modifyRequestRecords=solUserAssContr.modifyRequestRecords();
           //Pagereference cancelRequestRecords=solUserAssContr.cancelRequestRecords();
           Pagereference Beginning=solUserAssContr.Beginning();
           Pagereference Previous=solUserAssContr.Previous();
           Pagereference Next=solUserAssContr.Next();
           Pagereference evnd=solUserAssContr.End();
           Boolean getDisablePrevious=solUserAssContr.getDisablePrevious();
           Boolean getDisableNext=solUserAssContr.getDisableNext();
           Integer getPageNumber=solUserAssContr.getPageNumber();
           Integer getTotalPages=solUserAssContr.getTotalPages();
           Integer getTotal_size=solUserAssContr.getTotal_size();
           //solUserAssContr.savingCustomerRecord();
           //solUserAssContr.clearFilter();
           String value;
           Decimal value1;
           Date value2;
           //String checkNullValues=solUserAssContr.checkNullValues(value);
           //String checkNullValuesDeciamlTCV=SolutionUserAssignmentController.checkNullValuesDeciamlTCV(value1);
          // String checkDateNullValues=SolutionUserAssignmentController.checkDateNullValues(value2);
           String oppId;
           String roleName;
           String dateNeeded;
           String  dateRequested;
           String comment;
           String request;
           //solUserAssContr.sendEmailAlertToPmo(oppId,roleName,dateNeeded,dateRequested,comment,request);
          // List<String> getMAEmailAddresses = solUserAssContr.getMAEmailAddresses();
          // List<String> getSSEmailAddresses= solUserAssContr.getSSEmailAddresses();
          // List<String> getTAEmailAddresses= solUserAssContr.getTAEmailAddresses();
          // List<String> getCCAEmailAddresses= solUserAssContr.getCCAEmailAddresses();
          // List<String> getOSLEmailAddresses = solUserAssContr.getOSLEmailAddresses();
           //List<String> getEmailAddresses= solUserAssContr.getEmailAddresses();
           //List<String> status= solUserAssContr.status();
           //List<String> role= solUserAssContr.role();
     }
      test.stoptest();    

   }
   
   static testMethod void testSolutionUserAssignmentController2(){
     test.starttest();
     setupData();
     system.runas(testUser){
            PageReference pageRef = Page.SolutionUserAssignment;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', oppTGP.id);
           
           apexpages.currentpage().getparameters().put('role' ,'Complex Cost Architect');
           apexpages.currentpage().getparameters().put('status' ,'New');
           apexpages.currentpage().getparameters().put('SAPSelect' ,'103');
           apexpages.currentpage().getparameters().put('clSelect' ,'Singapore Power Ltd');
           apexpages.currentpage().getparameters().put('oppSelect' ,'New York');
           String s=sua.id+','+sua1.id+','+sua2.id;
           apexpages.currentpage().getparameters().put('submitRequestIds' ,s);
           
           ApexPages.StandardController sc = new ApexPages.StandardController(oppTGP);
           SolutionUserAssignmentController  solUserAssContr = new SolutionUserAssignmentController(sc);
           
           solUserAssContr.submitRequestIds=sua.id;
           
           solUserAssContr.toggleSort();
           solUserAssContr.runQuery();
           PageReference runSearch = solUserAssContr.runSearch ();
           solUserAssContr.solUserAssign.add(sua);
           solUserAssContr.submitRequestIds = s;
           //solUserAssContr.submitRequestRecords();
          // solUserAssContr.cancelRequestRecords();
           //solUserAssContr.modifyRequestRecords();
           
           //Pagereference modifyRequestRecords=solUserAssContr.modifyRequestRecords();
           //Pagereference cancelRequestRecords=solUserAssContr.cancelRequestRecords();
           Pagereference Beginning=solUserAssContr.Beginning();
           Pagereference Previous=solUserAssContr.Previous();
           Pagereference Next=solUserAssContr.Next();
           Pagereference evnd=solUserAssContr.End();
           Boolean getDisablePrevious=solUserAssContr.getDisablePrevious();
           Boolean getDisableNext=solUserAssContr.getDisableNext();
           Integer getPageNumber=solUserAssContr.getPageNumber();
           Integer getTotalPages=solUserAssContr.getTotalPages();
           Integer getTotal_size=solUserAssContr.getTotal_size();
           //solUserAssContr.savingCustomerRecord();
           //solUserAssContr.clearFilter();
           String value;
           Decimal value1;
           Date value2;
           //String checkNullValues=solUserAssContr.checkNullValues(value);
           //String checkNullValuesDeciamlTCV=SolutionUserAssignmentController.checkNullValuesDeciamlTCV(value1);
          // String checkDateNullValues=SolutionUserAssignmentController.checkDateNullValues(value2);
           String oppId;
           String roleName;
           String dateNeeded;
           String  dateRequested;
           String comment;
           String request;
           //solUserAssContr.sendEmailAlertToPmo(oppId,roleName,dateNeeded,dateRequested,comment,request);
           List<String> getMAEmailAddresses = solUserAssContr.getMAEmailAddresses();
          // List<String> getSSEmailAddresses= solUserAssContr.getSSEmailAddresses();
          // List<String> getTAEmailAddresses= solUserAssContr.getTAEmailAddresses();
          // List<String> getCCAEmailAddresses= solUserAssContr.getCCAEmailAddresses();
          // List<String> getOSLEmailAddresses = solUserAssContr.getOSLEmailAddresses();
           //List<String> getEmailAddresses= solUserAssContr.getEmailAddresses();
           //List<String> status= solUserAssContr.status();
           //List<String> role= solUserAssContr.role();
     }
      test.stoptest();    

   }
   
    static testMethod void testSolutionUserAssignmentController3(){
     test.starttest();
     setupData();
     system.runas(testUser){
            PageReference pageRef = Page.SolutionUserAssignment;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', oppTGP.id);
           
           apexpages.currentpage().getparameters().put('role' ,'Complex Cost Architect');
           apexpages.currentpage().getparameters().put('status' ,'New');
           apexpages.currentpage().getparameters().put('SAPSelect' ,'103');
           apexpages.currentpage().getparameters().put('clSelect' ,'Singapore Power Ltd');
           apexpages.currentpage().getparameters().put('oppSelect' ,'New York');
           String s=sua.id+','+sua1.id+','+sua2.id;
           apexpages.currentpage().getparameters().put('submitRequestIds' ,s);
           
           ApexPages.StandardController sc = new ApexPages.StandardController(oppTGP);
           SolutionUserAssignmentController  solUserAssContr = new SolutionUserAssignmentController(sc);
           
           solUserAssContr.submitRequestIds=sua.id;
           
           solUserAssContr.toggleSort();
           solUserAssContr.runQuery();
           PageReference runSearch = solUserAssContr.runSearch ();
           solUserAssContr.solUserAssign.add(sua);
           solUserAssContr.submitRequestIds = s;
           
           
           //solUserAssContr.savingCustomerRecord();
           //solUserAssContr.clearFilter();
           String value;
           Decimal value1;
           Date value2;
           //String checkNullValues=solUserAssContr.checkNullValues(value);
           //String checkNullValuesDeciamlTCV=SolutionUserAssignmentController.checkNullValuesDeciamlTCV(value1);
          // String checkDateNullValues=SolutionUserAssignmentController.checkDateNullValues(value2);
           String oppId;
           String roleName;
           String dateNeeded;
           String  dateRequested;
           String comment;
           String request;
           
           List<String> getSSEmailAddresses= solUserAssContr.getSSEmailAddresses();
           //List<String> getTAEmailAddresses= solUserAssContr.getTAEmailAddresses();
           //List<String> getCCAEmailAddresses= solUserAssContr.getCCAEmailAddresses();
           //List<String> getOSLEmailAddresses = solUserAssContr.getOSLEmailAddresses();
           //List<String> getEmailAddresses= solUserAssContr.getEmailAddresses();
           
     }
      test.stoptest();    

   }
   static testMethod void testSolutionUserAssignmentController4(){
     test.starttest();
     setupData();
     system.runas(testUser){
            PageReference pageRef = Page.SolutionUserAssignment;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', oppTGP.id);
           
           apexpages.currentpage().getparameters().put('role' ,'Complex Cost Architect');
           apexpages.currentpage().getparameters().put('status' ,'New');
           apexpages.currentpage().getparameters().put('SAPSelect' ,'103');
           apexpages.currentpage().getparameters().put('clSelect' ,'Singapore Power Ltd');
           apexpages.currentpage().getparameters().put('oppSelect' ,'New York');
           String s=sua.id+','+sua1.id+','+sua2.id;
           apexpages.currentpage().getparameters().put('submitRequestIds' ,s);
           
           ApexPages.StandardController sc = new ApexPages.StandardController(oppTGP);
           SolutionUserAssignmentController  solUserAssContr = new SolutionUserAssignmentController(sc);
           
           solUserAssContr.submitRequestIds=sua.id;
           
           solUserAssContr.toggleSort();
           solUserAssContr.runQuery();
           PageReference runSearch = solUserAssContr.runSearch ();
           solUserAssContr.solUserAssign.add(sua);
           solUserAssContr.submitRequestIds = s;
           
           
           //solUserAssContr.savingCustomerRecord();
           //solUserAssContr.clearFilter();
           String value;
           Decimal value1;
           Date value2;
           //String checkNullValues=solUserAssContr.checkNullValues(value);
           //String checkNullValuesDeciamlTCV=SolutionUserAssignmentController.checkNullValuesDeciamlTCV(value1);
          // String checkDateNullValues=SolutionUserAssignmentController.checkDateNullValues(value2);
           String oppId;
           String roleName;
           String dateNeeded;
           String  dateRequested;
           String comment;
           String request;
           
           
           List<String> getTAEmailAddresses= solUserAssContr.getTAEmailAddresses();
           //List<String> getCCAEmailAddresses= solUserAssContr.getCCAEmailAddresses();
           //List<String> getOSLEmailAddresses = solUserAssContr.getOSLEmailAddresses();
           //List<String> getEmailAddresses= solUserAssContr.getEmailAddresses();
           
     }
      test.stoptest();    

   }
   static testMethod void testSolutionUserAssignmentController5(){
     test.starttest();
     setupData();
     system.runas(testUser){
            PageReference pageRef = Page.SolutionUserAssignment;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', oppTGP.id);
           
           apexpages.currentpage().getparameters().put('role' ,'Complex Cost Architect');
           apexpages.currentpage().getparameters().put('status' ,'New');
           apexpages.currentpage().getparameters().put('SAPSelect' ,'103');
           apexpages.currentpage().getparameters().put('clSelect' ,'Singapore Power Ltd');
           apexpages.currentpage().getparameters().put('oppSelect' ,'New York');
           String s=sua.id+','+sua1.id+','+sua2.id;
           apexpages.currentpage().getparameters().put('submitRequestIds' ,s);
           
           ApexPages.StandardController sc = new ApexPages.StandardController(oppTGP);
           SolutionUserAssignmentController  solUserAssContr = new SolutionUserAssignmentController(sc);
           
           solUserAssContr.submitRequestIds=sua.id;
           
           solUserAssContr.toggleSort();
           solUserAssContr.runQuery();
           PageReference runSearch = solUserAssContr.runSearch ();
           solUserAssContr.solUserAssign.add(sua);
           solUserAssContr.submitRequestIds = s;
           
           
           //solUserAssContr.savingCustomerRecord();
           //solUserAssContr.clearFilter();
           String value;
           Decimal value1;
           Date value2;
           //String checkNullValues=solUserAssContr.checkNullValues(value);
           //String checkNullValuesDeciamlTCV=SolutionUserAssignmentController.checkNullValuesDeciamlTCV(value1);
          // String checkDateNullValues=SolutionUserAssignmentController.checkDateNullValues(value2);
           String oppId;
           String roleName;
           String dateNeeded;
           String  dateRequested;
           String comment;
           String request;
           
           
           
           List<String> getCCAEmailAddresses= solUserAssContr.getCCAEmailAddresses();
           //List<String> getOSLEmailAddresses = solUserAssContr.getOSLEmailAddresses();
           //List<String> getEmailAddresses= solUserAssContr.getEmailAddresses();
           
     }
      test.stoptest();    

   }
   static testMethod void testSolutionUserAssignmentController6(){
     test.starttest();
     setupData();
     system.runas(testUser){
            PageReference pageRef = Page.SolutionUserAssignment;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', oppTGP.id);
           
           apexpages.currentpage().getparameters().put('role' ,'Complex Cost Architect');
           apexpages.currentpage().getparameters().put('status' ,'New');
           apexpages.currentpage().getparameters().put('SAPSelect' ,'103');
           apexpages.currentpage().getparameters().put('clSelect' ,'Singapore Power Ltd');
           apexpages.currentpage().getparameters().put('oppSelect' ,'New York');
           String s=sua.id+','+sua1.id+','+sua2.id;
           apexpages.currentpage().getparameters().put('submitRequestIds' ,s);
           
           ApexPages.StandardController sc = new ApexPages.StandardController(oppTGP);
           SolutionUserAssignmentController  solUserAssContr = new SolutionUserAssignmentController(sc);
           
           solUserAssContr.submitRequestIds=sua.id;
           
           solUserAssContr.toggleSort();
           solUserAssContr.runQuery();
           PageReference runSearch = solUserAssContr.runSearch ();
           solUserAssContr.solUserAssign.add(sua);
           solUserAssContr.submitRequestIds = s;
           
           
           //solUserAssContr.savingCustomerRecord();
           //solUserAssContr.clearFilter();
           String value;
           Decimal value1;
           Date value2;
           //String checkNullValues=solUserAssContr.checkNullValues(value);
           //String checkNullValuesDeciamlTCV=SolutionUserAssignmentController.checkNullValuesDeciamlTCV(value1);
          // String checkDateNullValues=SolutionUserAssignmentController.checkDateNullValues(value2);
           String oppId;
           String roleName;
           String dateNeeded;
           String  dateRequested;
           String comment;
           String request;
           
           
           
           
           List<String> getOSLEmailAddresses = solUserAssContr.getOSLEmailAddresses();
           //List<String> getEmailAddresses= solUserAssContr.getEmailAddresses();
           
     }
      test.stoptest();    

   }
   static testMethod void testSolutionUserAssignmentController7(){
     test.starttest();
     setupData();
     system.runas(testUser){
            PageReference pageRef = Page.SolutionUserAssignment;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', oppTGP.id);
           
           apexpages.currentpage().getparameters().put('role' ,'Complex Cost Architect');
           apexpages.currentpage().getparameters().put('status' ,'New');
           apexpages.currentpage().getparameters().put('SAPSelect' ,'103');
           apexpages.currentpage().getparameters().put('clSelect' ,'Singapore Power Ltd');
           apexpages.currentpage().getparameters().put('oppSelect' ,'New York');
           String s=sua.id+','+sua1.id+','+sua2.id;
           apexpages.currentpage().getparameters().put('submitRequestIds' ,s);
           
           ApexPages.StandardController sc = new ApexPages.StandardController(oppTGP);
           SolutionUserAssignmentController  solUserAssContr = new SolutionUserAssignmentController(sc);
           
           solUserAssContr.submitRequestIds=sua.id;
           
           solUserAssContr.toggleSort();
           solUserAssContr.runQuery();
           PageReference runSearch = solUserAssContr.runSearch ();
           solUserAssContr.solUserAssign.add(sua);
           solUserAssContr.submitRequestIds = s;
           
           
           //solUserAssContr.savingCustomerRecord();
           //solUserAssContr.clearFilter();
           String value;
           Decimal value1;
           Date value2;
           //String checkNullValues=solUserAssContr.checkNullValues(value);
           //String checkNullValuesDeciamlTCV=SolutionUserAssignmentController.checkNullValuesDeciamlTCV(value1);
          // String checkDateNullValues=SolutionUserAssignmentController.checkDateNullValues(value2);
           String debugsoq = solUserAssContr.debugSoql;
           List<String> roleName = solUserAssContr.role;
           List<String> dstatus = solUserAssContr.status;
           String  dateRequested;
           String comment;
           String request;
           
           
           
           
           
           List<String> getEmailAddresses= solUserAssContr.getEmailAddresses();
           
     }
      test.stoptest();    

   }
   static testMethod void testSolutionUserAssignmentController8(){
     test.starttest();
     setupData();
     system.runas(testUser){
            PageReference pageRef = Page.SolutionUserAssignment;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', oppTGP.id);
           
           apexpages.currentpage().getparameters().put('role' ,'Complex Cost Architect');
           apexpages.currentpage().getparameters().put('status' ,'New');
           apexpages.currentpage().getparameters().put('SAPSelect' ,'103');
           apexpages.currentpage().getparameters().put('clSelect' ,'Singapore Power Ltd');
           apexpages.currentpage().getparameters().put('oppSelect' ,'New York');
           String s=sua.id+','+sua1.id+','+sua2.id;
           apexpages.currentpage().getparameters().put('submitRequestIds' ,s);
           
           ApexPages.StandardController sc = new ApexPages.StandardController(oppTGP);
           SolutionUserAssignmentController  solUserAssContr = new SolutionUserAssignmentController(sc);
           
           solUserAssContr.submitRequestIds=sua.id;
           
           solUserAssContr.toggleSort();
           solUserAssContr.runQuery();
           PageReference runSearch = solUserAssContr.runSearch ();
           solUserAssContr.solUserAssign.add(sua);
           solUserAssContr.submitRequestIds = s;
           
           solUserAssContr.submitRequestRecords();
           
     }
      test.stoptest();    

   }
    static testMethod void testSolutionUserAssignmentController9(){
     test.starttest();
     setupData();
     system.runas(testUser){
            PageReference pageRef = Page.SolutionUserAssignment;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', oppTGP.id);
           
           apexpages.currentpage().getparameters().put('role' ,'Complex Cost Architect');
           apexpages.currentpage().getparameters().put('status' ,'New');
           apexpages.currentpage().getparameters().put('SAPSelect' ,'103');
           apexpages.currentpage().getparameters().put('clSelect' ,'Singapore Power Ltd');
           apexpages.currentpage().getparameters().put('oppSelect' ,'New York');
           String s=sua.id+','+sua1.id+','+sua2.id;
           apexpages.currentpage().getparameters().put('submitRequestIds' ,s);
           
           ApexPages.StandardController sc = new ApexPages.StandardController(oppTGP);
           SolutionUserAssignmentController  solUserAssContr = new SolutionUserAssignmentController(sc);
           
           solUserAssContr.submitRequestIds=sua.id;
           
           solUserAssContr.toggleSort();
           solUserAssContr.runQuery();
           PageReference runSearch = solUserAssContr.runSearch ();
           solUserAssContr.solUserAssign.add(sua);
           solUserAssContr.submitRequestIds = s;
           
           solUserAssContr.modifyRequestRecords();
           
     }
      test.stoptest();    

   }
   static testMethod void testSolutionUserAssignmentController11(){
     test.starttest();
     setupData();
     system.runas(testUser){
            PageReference pageRef = Page.SolutionUserAssignment;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', oppTGP.id);
           
           apexpages.currentpage().getparameters().put('role' ,'Complex Cost Architect');
           apexpages.currentpage().getparameters().put('status' ,'New');
           apexpages.currentpage().getparameters().put('SAPSelect' ,'103');
           apexpages.currentpage().getparameters().put('clSelect' ,'Singapore Power Ltd');
           apexpages.currentpage().getparameters().put('oppSelect' ,'New York');
           String s=sua.id+','+sua1.id+','+sua2.id;
           apexpages.currentpage().getparameters().put('submitRequestIds' ,s);
           
           ApexPages.StandardController sc = new ApexPages.StandardController(oppTGP);
           SolutionUserAssignmentController  solUserAssContr = new SolutionUserAssignmentController(sc);
           
           solUserAssContr.submitRequestIds=sua.id;
           
           solUserAssContr.toggleSort();
           solUserAssContr.runQuery();
           PageReference runSearch = solUserAssContr.runSearch ();
           solUserAssContr.solUserAssign.add(sua);
           solUserAssContr.submitRequestIds = s;
           
           solUserAssContr.cancelRequestRecords();
           
     }
      test.stoptest();    

   }
   static testMethod void testSolutionUserAssignmentController10(){
     test.starttest();
     setupData();
     system.runas(testUser){
            PageReference pageRef = Page.SolutionUserAssignment;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', oppTGP.id);
           
           apexpages.currentpage().getparameters().put('role' ,'Complex Cost Architect');
           apexpages.currentpage().getparameters().put('status' ,'New');
           apexpages.currentpage().getparameters().put('SAPSelect' ,'103');
           apexpages.currentpage().getparameters().put('clSelect' ,'Singapore Power Ltd');
           apexpages.currentpage().getparameters().put('oppSelect' ,'New York');
           String s=sua.id+','+sua1.id+','+sua2.id;
           apexpages.currentpage().getparameters().put('submitRequestIds' ,s);
           
           ApexPages.StandardController sc = new ApexPages.StandardController(oppTGP);
           SolutionUserAssignmentController  solUserAssContr = new SolutionUserAssignmentController(sc);
           
           solUserAssContr.submitRequestIds=sua.id;
           
           solUserAssContr.savingCustomerRecord();
           solUserAssContr.clearFilter();
           PageReference runSearch = solUserAssContr.runSearch ();
           solUserAssContr.solUserAssign.add(sua);
           solUserAssContr.submitRequestIds = s;
           
           solUserAssContr.cancelRequestRecords();
           
     }
      test.stoptest();    

   }
    //New Code Ends
       
    }