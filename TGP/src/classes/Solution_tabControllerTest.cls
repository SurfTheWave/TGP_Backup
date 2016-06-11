/*
Author : Shridhar Patankar
Story  : Release 2
Description : Test Class for Solution_tabController.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class Solution_tabControllerTest{
   static User testUser; 
   static User testUser1; 
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
   static Service_Delivery_Location__c serviceDeliveryLocation;
   static Document doc1;
   
    public static void setupData(){
     
     Profile p =  UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    insert testUser;
      
      
       String[] thirdPartyvendor = new String[]{};
       //thirdPartyvendor.add('test1');
       //thirdPartyvendor.add('test2');
       //thirdPartyvendor.add('test3');
      
      
      
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

        offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
      oppOffering = new Opportunity_Offering__c(Domain_Expert_Functional_Architect_1__c=testUser.id,Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id);
      insert oppOffering;
      
      //oppOffering1 = new Opportunity_Offering__c(Domain_Expert_Functional_Architect_1__c=testUser.id,Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id);
      //insert oppOffering1;

        clientdependency = new Client_Dependency_Master__c();
        clientdependency.Category__c='Language';
        clientdependency.Client_Dependency__c='English';
        clientdependency.Active_Inactive__c=true;
        
        insert clientdependency;
        
        serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
        insert serviceMaster;
                
        serviceDeliveryLocation = new Service_Delivery_Location__c(Name = serviceMaster.name, Opportunity_Offering__c = oppOffering.id, Service_Master__c = serviceMaster.id);
        insert serviceDeliveryLocation;
        
       service = new Services__c (Opportunity_Offering__c = oppOffering.id, Service_Text_Name__c = 'TestService',Active__c=true, Service_Delivery_Location__c = serviceDeliveryLocation.Id);
        insert service;   
           lservice.add(service);
           
         service = new Services__c (Opportunity_Offering__c = oppOffering.id, Service_Text_Name__c = 'TestService',Active__c=true, Service_Delivery_Location__c = serviceDeliveryLocation.Id);
        insert service;
       lservice.add(service); 
        
        listRiskMaster = new Risk_Master__c(Offering_Master__c = offeringMaster.id,Active_Inactive__c = true,Service_Master__c = serviceMaster.id);
        insert listRiskMaster;
        
        listAssumptionMaster = new Assumption_Master__c(Assumption__c = 'TestAssumption',Active_Inactive__c = true,Offering__c = offeringMaster.id,Services_per_Offering__c = serviceMaster.id);
        insert listAssumptionMaster; 


      
    }
    public static void setupData1(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
      insert testUser;
      
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

      insert oppTGP;
      offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
    //  oppOffering = new Opportunity_Offering__c(Domain_Expert_Functional_Architect_1__c=testUser.id,Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id);
    //  insert oppOffering;
      
        clientdependency = new Client_Dependency_Master__c();
        clientdependency.Category__c='Language';
        clientdependency.Client_Dependency__c='English';
        clientdependency.Active_Inactive__c=true;
        
        insert clientdependency;
        
        serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
        insert serviceMaster;
                
        serviceDeliveryLocation = new Service_Delivery_Location__c(Name = serviceMaster.name, Opportunity_Offering__c = oppOffering.id, Service_Master__c = serviceMaster.id);
        insert serviceDeliveryLocation;
        
        service = new Services__c (Service_Text_Name__c = 'TestService',Active__c=true,Opportunity_Offering__c = oppOffering.id, Service_Delivery_Location__c = serviceDeliveryLocation.Id);
       insert service;
         
        listRiskMaster = new Risk_Master__c(Offering_Master__c = offeringMaster.id,Active_Inactive__c = true,Service_Master__c = serviceMaster.id);
        insert listRiskMaster;
        
        listAssumptionMaster = new Assumption_Master__c(Assumption__c = 'TestAssumption',Active_Inactive__c = true,Offering__c = offeringMaster.id,Services_per_Offering__c = serviceMaster.id);
        insert listAssumptionMaster; 


      
    }
    public static void setupData2(){
     
     Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
      insert testUser;
      
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

        insert oppTGP;
        offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
        insert offeringMaster;
        oppOffering = new Opportunity_Offering__c(Domain_Expert_Functional_Architect_1__c=testUser.id,Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id);
        insert oppOffering;
      
        clientdependency = new Client_Dependency_Master__c();
        clientdependency.Category__c='Language';
        clientdependency.Client_Dependency__c='English';
        clientdependency.Active_Inactive__c=true;
        
        insert clientdependency;
        
        serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
        insert serviceMaster;
        
        
        serviceDeliveryLocation = new Service_Delivery_Location__c(Name = serviceMaster.name, Opportunity_Offering__c = oppOffering.id, Service_Master__c = serviceMaster.id);
        insert serviceDeliveryLocation;
        
        service = new Services__c (Opportunity_Offering__c = oppOffering.id, Service_Text_Name__c = 'TestService',Active__c=true, Service_Delivery_Location__c = serviceDeliveryLocation.Id);
        insert service;
          
        listRiskMaster = new Risk_Master__c(Offering_Master__c = offeringMaster.id,Active_Inactive__c = true,Service_Master__c = serviceMaster.id);
        insert listRiskMaster;
        
        listAssumptionMaster = new Assumption_Master__c(Assumption__c = 'TestAssumption',Active_Inactive__c = true,Offering__c = offeringMaster.id,Services_per_Offering__c = serviceMaster.id);
        insert listAssumptionMaster; 
    }
    public static void setupData3(){
     
     Profile p =  UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    insert testUser;
      
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

      insert oppTGP;
      
       offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
      
      oppOffering = new Opportunity_Offering__c(Domain_Expert_Functional_Architect_2__c=testUser.id,Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id);
      insert oppOffering;
      
        clientdependency = new Client_Dependency_Master__c();
        clientdependency.Category__c='Language';
        clientdependency.Client_Dependency__c='English';
        clientdependency.Active_Inactive__c=true;
        
        insert clientdependency;
                          
        serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
        insert serviceMaster;
        
        serviceDeliveryLocation = new Service_Delivery_Location__c(Name = serviceMaster.name, Opportunity_Offering__c = oppOffering.id, Service_Master__c = serviceMaster.id);
        insert serviceDeliveryLocation;
                
        service = new Services__c (Opportunity_Offering__c = oppOffering.id, Service_Text_Name__c = 'TestService',Active__c=true, Service_Delivery_Location__c = serviceDeliveryLocation.Id);
        insert service;

        listRiskMaster = new Risk_Master__c(Offering_Master__c = offeringMaster.id,Active_Inactive__c = true,Service_Master__c = serviceMaster.id);
        insert listRiskMaster;
        
        listAssumptionMaster = new Assumption_Master__c(Assumption__c = 'TestAssumption',Active_Inactive__c = true,Offering__c = offeringMaster.id,Services_per_Offering__c = serviceMaster.id);
        insert listAssumptionMaster; 
      
    }
    public static void setupData4(){
     
     Profile p =  UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    insert testUser;
      
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

      insert oppTGP;
      
       offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
      
      oppOffering = new Opportunity_Offering__c(Domain_Expert_Functional_Architect_3__c=testUser.id,Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id);
      insert oppOffering;
      
        clientdependency = new Client_Dependency_Master__c();
        clientdependency.Category__c='Language';
        clientdependency.Client_Dependency__c='English';
        clientdependency.Active_Inactive__c=true;
        
        insert clientdependency;
           
        serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
        insert serviceMaster;
        
        serviceDeliveryLocation = new Service_Delivery_Location__c(Name = serviceMaster.name, Opportunity_Offering__c = oppOffering.id, Service_Master__c = serviceMaster.id);
        insert serviceDeliveryLocation;
       
        service = new Services__c (Opportunity_Offering__c = oppOffering.id, Service_Text_Name__c = 'TestService',Active__c=true, Service_Delivery_Location__c = serviceDeliveryLocation.Id);
        insert service;
        
        listRiskMaster = new Risk_Master__c(Offering_Master__c = offeringMaster.id,Active_Inactive__c = true,Service_Master__c = serviceMaster.id);
        insert listRiskMaster;
        
        listAssumptionMaster = new Assumption_Master__c(Assumption__c = 'TestAssumption',Active_Inactive__c = true,Offering__c = offeringMaster.id,Services_per_Offering__c = serviceMaster.id);
        insert listAssumptionMaster;
      
    }
    public static void setupData5(){
     
     Profile p =  UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    insert testUser;
      
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

      insert oppTGP;
      offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
      oppOffering = new Opportunity_Offering__c(Domain_Expert_Functional_Architect_1__c=testUser.id,Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id);
      insert oppOffering;
      
        clientdependency = new Client_Dependency_Master__c();
        clientdependency.Category__c='Language';
        clientdependency.Client_Dependency__c='English';
        clientdependency.Active_Inactive__c=true;
        clientdependency.Offering__c=offeringMaster.id;
        insert clientdependency;
        
        serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
        insert serviceMaster;
        
        serviceDeliveryLocation = new Service_Delivery_Location__c(Name = serviceMaster.name, Opportunity_Offering__c = oppOffering.id, Service_Master__c = serviceMaster.id);
        insert serviceDeliveryLocation;
        
        service = new Services__c (Service_Text_Name__c = 'TestService',Active__c=true,Opportunity_Offering__c = oppOffering.id, Service_Delivery_Location__c = serviceDeliveryLocation.Id);
        insert service;
           
        listRiskMaster = new Risk_Master__c(Offering_Master__c = offeringMaster.id,Active_Inactive__c = true);
        insert listRiskMaster;
        
        listAssumptionMaster = new Assumption_Master__c(Assumption__c = 'TestAssumption',Active_Inactive__c = true);
        insert listAssumptionMaster; 


      
    }
    public static void setupData6(){
     
     Profile p =  UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    insert testUser;
      
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

      insert oppTGP;
      offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
      oppOffering = new Opportunity_Offering__c(Domain_Expert_Functional_Architect_2__c=testUser.id,Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id);
      insert oppOffering;
      
        clientdependency = new Client_Dependency_Master__c();
        clientdependency.Category__c='Language';
        clientdependency.Client_Dependency__c='English';
        clientdependency.Active_Inactive__c=true;
        clientdependency.Offering__c=offeringMaster.id;
        insert clientdependency;
        
        serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
        insert serviceMaster;
        
        serviceDeliveryLocation = new Service_Delivery_Location__c(Name = serviceMaster.name, Opportunity_Offering__c = oppOffering.id, Service_Master__c = serviceMaster.id);
        insert serviceDeliveryLocation;
                
        service = new Services__c (Service_Text_Name__c = 'TestService',Active__c=true,Opportunity_Offering__c = oppOffering.id, Service_Delivery_Location__c = serviceDeliveryLocation.Id);
       insert service;
           
        listRiskMaster = new Risk_Master__c(Offering_Master__c = offeringMaster.id,Active_Inactive__c = true);
        insert listRiskMaster;
        
        listAssumptionMaster = new Assumption_Master__c(Assumption__c = 'TestAssumption',Active_Inactive__c = true);
        insert listAssumptionMaster; 


      
    }
    public static void setupData7(){
     
     Profile p =  UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    insert testUser;
      
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

      insert oppTGP;
      offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;
      oppOffering = new Opportunity_Offering__c(Domain_Expert_Functional_Architect_3__c=testUser.id,Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id);
      insert oppOffering;
      
        clientdependency = new Client_Dependency_Master__c();
        clientdependency.Category__c='Language';
        clientdependency.Client_Dependency__c='English';
        clientdependency.Active_Inactive__c=true;
        clientdependency.Offering__c=offeringMaster.id;
        insert clientdependency;
        
        serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
        insert serviceMaster;
        
        serviceDeliveryLocation = new Service_Delivery_Location__c(Name = serviceMaster.name, Opportunity_Offering__c = oppOffering.id, Service_Master__c = serviceMaster.id);
        insert serviceDeliveryLocation;
                       
        service = new Services__c (Service_Text_Name__c = 'TestService',Active__c=true,Opportunity_Offering__c = oppOffering.id, Service_Delivery_Location__c = serviceDeliveryLocation.Id);
       insert service;
           
        listRiskMaster = new Risk_Master__c(Offering_Master__c = offeringMaster.id,Active_Inactive__c = true);
        insert listRiskMaster;
        
        listAssumptionMaster = new Assumption_Master__c(Assumption__c = 'TestAssumption',Active_Inactive__c = true);
        insert listAssumptionMaster; 


      
    }/*
    static testMethod void testSolution_tabController(){
     test.starttest();
      setupData();
      //Id id;
     Opportunity_Offering__c oppOffering1 = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering1;
     
     //id = oppOffering.id;
     PageReference pageRef = Page.assumptionInline;

       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id', oppOffering1.id);
       ApexPages.CurrentPage().getParameters().put('tabFocus','tab0');
       ApexPages.CurrentPage().getParameters().put('Count','1'); 
        ApexPages.CurrentPage().getParameters().put('CountService','1');
        ApexPages.CurrentPage().getParameters().put('CountRisk','1');
        ApexPages.CurrentPage().getParameters().put('CountClient','1'); 
        ApexPages.CurrentPage().getParameters().put('isVisible','true');
       ApexPages.StandardController sc = new ApexPages.StandardController(oppOffering1);
       Solution_tabController  solTabContr = new Solution_tabController (sc);
       //Solution_tabController  solTabController = new Solution_tabController (); 
       
       String[] str = new String[]{};
       str.add('a');
       str.add('b');
       //solTabContr.thirdPartyvendor=str;
       //solTabContr.getClientDependency();
       //solTabContr.saverecordOfferingUser();
       solTabContr.getServiceDeliveryModel();
       solTabContr.getAssumption();
       solTabContr.starting();
       //solTabContr.setOtherComments();
       solTabContr.ending();
       solTabContr.edit1();
       solTabContr.saverecord();
       solTabContr.getthirdPartyvendor();
       solTabContr.plus1();
       solTabContr.plus2();
       solTabContr.plus3();
       solTabContr.plus4();
       solTabContr.saveNow();
       solTabContr.cancelNow();
       solTabContr.toggleSort();
       solTabContr.addNewOppOfferForServiceComponent();
       solTabContr.getServicesForServiceComponent();
       solTabContr.saveAccProfileDetailsForServiceComponent();
       solTabContr.cancelNowForServiceComponent();
       solTabContr.deleteFileForServiceComponent();
       solTabContr.saveDeliveryLocation();
       solTabContr.runQueryForClientDependency();
       solTabContr.addNewOppOfferForClientDependency();
       solTabContr.saveAccProfileDetailsForClientDependency();
       solTabContr.ExportClientDependency(); 
      test.stoptest();    

   } 
    static testMethod void testSolution_tabController_new() {
        test.starttest();
            setupData();
            Opportunity_Offering__c oppOffering1 = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id);
            insert oppOffering1;
            PageReference pageRef = Page.assumptionInline;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', oppOffering1.id);
            ApexPages.CurrentPage().getParameters().put('tabFocus','tab0');
            ApexPages.CurrentPage().getParameters().put('Count','1'); 
            ApexPages.CurrentPage().getParameters().put('CountService','1');
            ApexPages.CurrentPage().getParameters().put('CountRisk','1');
            ApexPages.CurrentPage().getParameters().put('CountClient','1'); 
            ApexPages.CurrentPage().getParameters().put('isVisible','true');
            ApexPages.StandardController sc = new ApexPages.StandardController(oppOffering1);
            Solution_tabController  solTabContr = new Solution_tabController (sc);
            String[] str = new String[]{};
            str.add('a');
            str.add('b');
            solTabContr.saverecordOfferingUser();
            solTabContr.getServiceDeliveryModel();
            solTabContr.getAssumption();
            solTabContr.starting();
            solTabContr.cancelRecord();
            solTabContr.addSolCharEdit();
            solTabContr.getFileIdDelete();
            solTabContr.setFileIdDelete(oppOffering1.id);
            solTabContr.deleteFile();
            List<String> tempList = new List<String>();
           tempList.add('Others');
           tempList.add('test2');
           tempList.add('test3');
           solTabContr.thirdPartyvendor = tempList;
           List<SelectOption> getThirdPartyVendorName = solTabContr.getThirdPartyVendorName(); 
        Test.stopTest();
   } */
  /* static testMethod void testSolution_tabControllerWithUpload(){
     test.starttest();
      setupData();
      //Id id;
       doc1 = new Document();
       doc1.Body = Blob.valueof('test');
       doc1.AuthorId = UserInfo.getUserId();
       doc1.FolderId = UserInfo.getUserId();
       doc1.Name= 'testDoc';
       //insert doc1;
      
     Opportunity_Offering__c oppOffering1 = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering1;
     
     //id = oppOffering.id;
     PageReference pageRef = Page.assessmentUpload;

       Test.setCurrentPage(pageRef);
       
       ApexPages.currentPage().getParameters().put('id', oppOffering1.id);
       ApexPages.CurrentPage().getParameters().put('tabFocus','tab0');
       ApexPages.CurrentPage().getParameters().put('Count','1'); 
        ApexPages.CurrentPage().getParameters().put('CountService','1');
        ApexPages.CurrentPage().getParameters().put('CountRisk','1');
        ApexPages.CurrentPage().getParameters().put('CountClient','1'); 
        ApexPages.CurrentPage().getParameters().put('isVisible','true');
       ApexPages.StandardController sc = new ApexPages.StandardController(oppOffering1);
      // Solution_tabController  solTabContr = new Solution_tabController (sc);
     // solTabContr.doc1=doc1;
       //solTabContr.upload(); 
      test.stoptest();    

   }*/

   /*static testMethod void testClientDependencyButtonController(){
     
      setupData();
      //Id id;
     
     Opportunity_Offering__c oppOffering4 = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering4;
     //id = oppOffering.id;
     
        serviceDeliveryLocation = new Service_Delivery_Location__c(Name = serviceMaster.name, Opportunity_Offering__c = oppOffering.id, Service_Master__c = serviceMaster.id);
        //insert serviceDeliveryLocation;  
        
        serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
        //insert serviceMaster;
      
        service = new Services__c (Opportunity_Offering__c = oppOffering.id, Service_Text_Name__c = 'TestService',Active__c=true, Service_Delivery_Location__c = serviceDeliveryLocation.Id);
        //insert service;

     PageReference pageRef = Page.clientDependencyInline;

       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id', oppOffering4.id);
       
       test.starttest();
       
       ApexPages.StandardController sc = new ApexPages.StandardController(oppOffering4);
       //Solution_tabController  solTabContr = new Solution_tabController (sc);
       //solTabContr.getClientDependency();
      test.stoptest();    

   }*/
    /*static testMethod void testRiskButtonController(){
     test.starttest();
      setupData();
      //Id id;
     
     Opportunity_Offering__c oppOffering6 = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering6;
     //id = oppOffering.id;
     
    serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
    insert serviceMaster;
           
    serviceDeliveryLocation = new Service_Delivery_Location__c(Name = serviceMaster.name, Opportunity_Offering__c = oppOffering.id, Service_Master__c = serviceMaster.id);
    insert serviceDeliveryLocation;
           
    service = new Services__c (Opportunity_Offering__c = oppOffering.id, Service_Text_Name__c = 'TestService',Active__c=true, Service_Delivery_Location__c = serviceDeliveryLocation.Id);
    insert service;
       
       listRiskMaster = new Risk_Master__c(Offering_Master__c = offeringMaster.id,Active_Inactive__c = true,Service_Master__c = serviceMaster.id);
        insert listRiskMaster;


     PageReference pageRef = Page.riskInline;

       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id', oppOffering6.id);
       ApexPages.StandardController sc = new ApexPages.StandardController(oppOffering6);
        //Solution_tabController  solTabContr = new Solution_tabController (sc);
       //solTabContr.getRisk();
      test.stoptest();    

   }*/
   /*static testMethod void testRiskButtonController12(){
     test.starttest();
      setupData();
      //Id id;
     
     Opportunity_Offering__c oppOffering7 = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering7;
     //id = oppOffering.id;
     PageReference pageRef = Page.riskInline;

       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id', oppOffering7.id);
       ApexPages.StandardController sc = new ApexPages.StandardController(oppOffering7);
        //Solution_tabController  solTabContr = new Solution_tabController (sc);
       //solTabContr.edit1();
      test.stoptest();    

   }*/
   static testMethod void testRiskButtonController122(){
     test.starttest();
      setupData2();
      //Id id;
     
     Opportunity_Offering__c oppOffering8 = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering8;
     //id = oppOffering.id;
     PageReference pageRef = Page.riskInline;

       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id', oppOffering8.id);
       ApexPages.StandardController sc = new ApexPages.StandardController(oppOffering8);
        //Solution_tabController  solTabContr = new Solution_tabController (sc);
       //solTabContr.edit1();
      test.stoptest();    

   }
   static testMethod void testRiskButtonController123(){
     test.starttest();
      setupData3();
      //Id id;
     
     Opportunity_Offering__c oppOffering11 = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering11;
     //id = oppOffering.id;
     PageReference pageRef = Page.riskInline;

       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id', oppOffering11.id);
       ApexPages.StandardController sc = new ApexPages.StandardController(oppOffering11);
       // Solution_tabController  solTabContr = new Solution_tabController (sc);
       //solTabContr.edit1();
      test.stoptest();    

   }
   static testMethod void testRiskButtonController124(){
     test.starttest();
      setupData4();
      //Id id;
      
     Opportunity_Offering__c oppOffering12 = new Opportunity_Offering__c(Offering_Text_Name__c = 'AC',Opportunity_TGP__c=oppTGP.id);
     insert oppOffering12;
     //id = oppOffering.id;
     PageReference pageRef = Page.riskInline;

       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id', oppOffering12.id);
       ApexPages.StandardController sc = new ApexPages.StandardController(oppOffering12);
        //Solution_tabController  solTabContr = new Solution_tabController (sc);
      // solTabContr.edit1();
      test.stoptest();    

   }
  
   /*static testMethod void newMethod(){
   
   setupData5();
   test.starttest();
      
          //id = oppOffering.id;
     PageReference pageRef = Page.riskInline;

       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id', oppOffering.id);
       ApexPages.StandardController sc = new ApexPages.StandardController(oppOffering);
       Solution_tabController  solTabContr = new Solution_tabController (sc);
     
       //solTabContr.getAssumption();
       solTabContr.edit1();
       
       //solTabContr.getRisk();
       //solTabContr.getClientDependency();
       
       test.stoptest();    
        }
    static testMethod void newMethod1(){
   
   setupData6();
     
          //id = oppOffering.id;
     PageReference pageRef = Page.riskInline;

       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id', oppOffering.id);
       ApexPages.StandardController sc = new ApexPages.StandardController(oppOffering);
       Solution_tabController  solTabContr = new Solution_tabController (sc);
     test.starttest(); 
       //solTabContr.getAssumption();
       solTabContr.edit1();
       
       //solTabContr.getRisk();
       //solTabContr.getClientDependency();
       
       test.stoptest();    
        }    */
        static testMethod void newMethod2(){
   
   setupData6();
    test.starttest();  
          //id = oppOffering.id;
     PageReference pageRef = Page.riskInline;

       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('id', oppOffering.id);
       ApexPages.StandardController sc = new ApexPages.StandardController(oppOffering);
       Solution_tabController  solTabContr = new Solution_tabController (sc);
     
       //solTabContr.getAssumption();
       solTabContr.edit1();
       Pagereference p1 = solTabContr.goBackToHomeTab(); 
       //solTabContr.getRisk();
       //solTabContr.getClientDependency();
       
       test.stoptest();    
        }  
       
}