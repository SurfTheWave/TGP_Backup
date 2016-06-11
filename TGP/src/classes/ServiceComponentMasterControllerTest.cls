/*
Author : Shridhar Patankar
Story  : Story-0111/COM_051     
Description : Test Class for ServicesComponent. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class ServiceComponentMasterControllerTest{
   static User testUser; 
   static User testUser1;
   static Client_Master__c clientName;
   static Client_Geo_Area_Master__c clientGeoArea;
   static Operating_Group_Master__c operatingGroup;
   static Client_Geo_Unit_Master__c clientGeoUnit;
   static Opportunity_TGP__c oppTGP;
   static Service_Component__c servComponent;
   static Service_Master__c serviceMaster; 
   static Assumption_Master__c assumptionMaster;
   static Offerings_Master__c offeringMaster;
   static Offerings_Master__c offeringMaster1;
   static Offerings_Master__c offeringMaster2;
   static Opportunity_Offering__c oppOffering;
   static Opportunity_Offering__c oppOffering1;
   static Assumption__c assumption;
     static Offerings_Master__c offMaster;
  
    public static void setupData(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SOLUTION_ADMIN);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
      Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,UTIL_Constants.USER_NAME);
     Database.insert(testUser1, false);
      
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser1.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
      insert oppTGP;
      
     
     
    /* offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;*/
     
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id);
     insert oppOffering;
     
      oppOffering1 = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering1',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id);
     insert oppOffering1;
     
    String ser = 'TestService';
     serviceMaster = new Service_Master__c(Name =ser,Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     /*servComponent= new Service_Component__c(Name = 'serviceComponent111d',Service_Master__c=serviceMaster.id,Active__c = true,Offering_Master__c=offeringMaster.id);
     insert servComponent;*/
     
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;
     
      assumption= new Assumption__c (Name = 'TestAssumption',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
     insert assumption;
    } 
     public static void setupData1(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SOLUTION_ADMIN);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
      
      Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,UTIL_Constants.USER_NAME);
     Database.insert(testUser1, false);
      
      clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
     
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser1.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
      insert oppTGP;
      
     
     
     offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
     
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id);
     insert oppOffering;
     
      oppOffering1 = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering1',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id);
     insert oppOffering1;
     
     String ser = 'TestService';
     serviceMaster = new Service_Master__c(Name =ser,Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;
     
     servComponent= new Service_Component__c(Name = 'serviceComponent1333e',Service_Master__c=serviceMaster.id,Active__c = true,Offering_Master__c=offeringMaster.id);
     insert servComponent;
     
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;
     
      assumption= new Assumption__c (Name = 'TestAssumption',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
     insert assumption;
    } 
     static testMethod void testServiceComponentMasterController(){
    test.starttest();
         offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
         insert offeringMaster;
         String ser = 'TestService';
         serviceMaster = new Service_Master__c(Name =ser,Offering__c = offeringMaster.id,Active__c = true );
         insert serviceMaster;
         servComponent= new Service_Component__c(Name = 'serviceComponent1666',Service_Master__c=serviceMaster.id,Active__c = true,Offering_Master__c=offeringMaster.id);
         insert servComponent;
      setupData();
      
      servComponent= new Service_Component__c(Name = 'serviceComponent1g',Service_Master__c=serviceMaster.id,Active__c = true,Offering_Master__c=offeringMaster.id);
      insert servComponent;
      PageReference pageRef= Page.ServiceComponentsMaster;
      Test.setCurrentPageReference(pageRef);
      
      ApexPages.StandardController stdCon = new ApexPages.StandardController(servComponent);
      
      ServiceComponentMasterController serviceComponentMaster = new ServiceComponentMasterController(stdCon);
      
      List<selectOption> getOfferings=serviceComponentMaster.getOfferings();
      List<selectOption> getServices=serviceComponentMaster.getServices();
      
    
    test.stoptest();
   } 
   /* static testMethod void testServicesComponentPageMessage(){
    test.starttest();
         offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
         insert offeringMaster;
         String ser = 'TestService';
         serviceMaster = new Service_Master__c(Name =ser,Offering__c = offeringMaster.id,Active__c = true );
         insert serviceMaster;
         servComponent= new Service_Component__c(Name = 'serviceComponent1a',Service_Master__c=serviceMaster.id,Active__c = true,Offering_Master__c=offeringMaster.id);
         insert servComponent;
      setupData();
      ApexPages.StandardController stdCon;
      
      ServiceComponentMasterController serviceComponent = new ServiceComponentMasterController();
      List<ApexPages.Message> msgList = ApexPages.getMessages();
        // or loop over the messages
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
            
            System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity()); 
        }
      
    test.stoptest();
   } */
   static testMethod void testServiceComponentMasterControllerMethod(){
    test.starttest();
      
   
         offeringMaster = new Offerings_Master__c (Name = 'TestOffering24',Active__c = true);
         insert offeringMaster;
         String ser = 'TestService';
         serviceMaster = new Service_Master__c(Name ='TestService25',Offering__c = offeringMaster.id,Active__c = true );
         insert serviceMaster;
         servComponent= new Service_Component__c(Name = 'serviceComponent1b',Service_Master__c=serviceMaster.id,Active__c = true,Offering_Master__c=offeringMaster.id);
          insert servComponent;
      setupData();
         
      PageReference pageRef= Page.ServiceComponentsMaster;
      pageRef.getParameters().put('id', String.valueOf(servComponent.Id));
      Test.setCurrentPageReference(pageRef);
      
      ApexPages.StandardController stdCon= new ApexPages.StandardController(servComponent);
     // apexpages.currentpage().getparameters().put('id' ,serviceMaster.id);
      ServiceComponentMasterController serviceComponentMaster = new ServiceComponentMasterController(stdCon);
      serviceComponentMaster.Service = 'TestService';
      serviceComponentMaster.Offering= 'TestOffering';
      //String ser = 'TestService';
       offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
      insert offeringMaster;
      serviceMaster = new Service_Master__c(Name ='TestService',Offering__c = offeringMaster.id,Active__c = true );
      insert serviceMaster;

      servComponent= new Service_Component__c(Name = 'serviceComponent123c',Service_Master__c=serviceMaster.id,Active__c = true,Offering_Master__c= offeringMaster.id);
      insert servComponent;
      List<selectOption> getOfferings=serviceComponentMaster.getOfferings();
      List<selectOption> getServices=serviceComponentMaster.getServices();
      //PageReference saveAccProfileDetails= serviceComponentMaster.saveAccProfileDetails();
    
    test.stoptest();
   } 
    static testMethod void testServiceComponentMasterControllerMethod1(){
        test.starttest();
        
        offeringMaster = new Offerings_Master__c (Name = 'TestOffering24',Active__c = true);
        insert offeringMaster;
        
        String ser = 'TestService';
        serviceMaster = new Service_Master__c(Name ='TestService25',Offering__c = offeringMaster.id,Active__c = true );
        insert serviceMaster;
        
        servComponent= new Service_Component__c(Name = 'Test Component',Service_Master__c=serviceMaster.id,Active__c = true,Offering_Master__c=offeringMaster.id);
        //insert servComponent;
        
        setupData();
         
        PageReference pageRef= Page.ServiceComponentsMaster;
        //pageRef.getParameters().put('id', String.valueOf(servComponent.Id));
        Test.setCurrentPageReference(pageRef);
     
        ApexPages.StandardController stdCon= new ApexPages.StandardController(servComponent);
        // apexpages.currentpage().getparameters().put('id' ,serviceMaster.id);
        ServiceComponentMasterController serviceComponentMaster = new ServiceComponentMasterController(stdCon);
       
        List<selectOption> getOfferings=serviceComponentMaster.getOfferings();
        List<selectOption> getServices=serviceComponentMaster.getServices();
      
        serviceComponentMaster.Service = serviceMaster.id;
        serviceComponentMaster.Offering= offeringMaster.id;
        PageReference saveAccProfileDetails= serviceComponentMaster.saveAccProfileDetails();
        test.stoptest();
   } 
   static testMethod void testServiceComponentMasterControllerMethod2(){
    test.starttest();
      
   
         offeringMaster = new Offerings_Master__c (Name = 'TestOffering24',Active__c = true);
         insert offeringMaster;
         String ser = 'TestService';
         serviceMaster = new Service_Master__c(Name ='TestService25',Offering__c = offeringMaster.id,Active__c = true );
         insert serviceMaster;
         servComponent = new Service_Component__c();
         servComponent= new Service_Component__c(Name = 'TestServ',Service_Master__c=serviceMaster.id,Active__c = true,Offering_Master__c=offeringMaster.id);
         insert servComponent;
               
      PageReference pageRef= Page.ServiceComponentsMaster;
      pageRef.getParameters().put('id', String.valueOf(servComponent.Id));
      Test.setCurrentPageReference(pageRef);
     
      ApexPages.StandardController stdCon= new ApexPages.StandardController(servComponent);
     // apexpages.currentpage().getparameters().put('id' ,serviceMaster.id);
      ServiceComponentMasterController serviceComponentMaster = new ServiceComponentMasterController(stdCon);
       serviceComponentMaster.Service = 'testid';
       serviceComponentMaster.Offering= 'testofferid';
      
      List<selectOption> getServices=serviceComponentMaster.getServices();
  //    PageReference saveAccProfileDetails= serviceComponentMaster.saveAccProfileDetails();
    
    test.stoptest();
   } 
   static testMethod void testServiceComponentMasterControllerMethod3(){
    test.starttest();
      setupData1();
      PageReference pageRef= Page.ServiceComponentsMaster;
      pageRef.getParameters().put('id', String.valueOf(servComponent.Id));
      Test.setCurrentPageReference(pageRef);
     
      ApexPages.StandardController stdCon= new ApexPages.StandardController(servComponent);
      apexpages.currentpage().getparameters().put('id' ,serviceMaster.id);
      ServiceComponentMasterController serviceComponentMaster = new ServiceComponentMasterController(stdCon);
      // serviceComponentMaster.Service = serviceMaster.id;
      // serviceComponentMaster.Offering= offeringMaster.id;
      serviceComponentMaster.Offering ='Testoffer';
      List<Service_Master__c> servmaster = new List<Service_Master__c>();
      servmaster.add(serviceMaster);
       serviceComponentMaster.newServiceComponent.Name= 'testName';
      // serviceComponentMaster.newServiceComponent.Offering_Master__c =offeringMaster.id;
      // serviceComponentMaster.newServiceComponent.Service_Master__c = serviceMaster.id;
      List<selectOption> getServices=serviceComponentMaster.getServices();
  //    PageReference saveAccProfileDetails= serviceComponentMaster.saveAccProfileDetails();
    
    test.stoptest();
   } 
   }