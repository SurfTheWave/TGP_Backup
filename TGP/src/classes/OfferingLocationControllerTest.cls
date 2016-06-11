/*
Author : Shridhar Patankar
Story  : Story-0168/SOL_071      
Description : Test Class for OfferingLocationController . 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class OfferingLocationControllerTest{
   static User testUser; 
   static Client_Master__c clientName;
   static Client_Geo_Area_Master__c clientGeoArea;
   static Operating_Group_Master__c operatingGroup;
   static Client_Geo_Unit_Master__c clientGeoUnit;
   static Opportunity_TGP__c oppTGP;
   static Service_Master__c serviceMaster; 
   static Assumption_Master__c assumptionMaster;
   static Offerings_Master__c offeringMaster;
   static Offerings_Master__c offeringMaster1;
   static Offerings_Master__c offeringMaster2;
   static Opportunity_Offering__c oppOffering;
   static Opportunity_Offering__c oppOffering1;
   static Assumption__c assumption;
   static Risk_Master__c riskMaster;
   static Risk__c risk;
   static Client_Dependency_Master__c clientDependencyMaster;
   static Client_Dependency__c clientDependency;
   static Delievery_Location_Master__c deliveryLocMa;
   static Delivery_Location__c deliveryLocation;
   static Service_Delivery_Location__c serviceDeliveryLocation;
  
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
     
     assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
     insert assumptionMaster;
     
      oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id);
     insert oppOffering;
     
      oppOffering1 = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering1',Opportunity_TGP__c=oppTGP.id,Offering_Master__c=offeringMaster.id);
     insert oppOffering1;
     
     serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;

     riskMaster = new Risk_Master__c (Category__c = 'TestRiskCategory',Risks__c= 'TestDataRisk',Active_Inactive__c = true);
     insert riskMaster;
     
     clientDependencyMaster = new Client_Dependency_Master__c (Category__c = 'TestClientDepCategory',Client_Dependency__c = 'TestDataClient',Active_Inactive__c = true);
     insert clientDependencyMaster;
     
     risk = new Risk__c (Name = 'TestRisk',Risk_Master__c = riskMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id);
     insert risk;
     
     serviceDeliveryLocation = new Service_Delivery_Location__c(Name = serviceMaster.name, Opportunity_Offering__c = oppOffering.id, Service_Master__c = serviceMaster.id);
     insert serviceDeliveryLocation;
     
     deliveryLocMa =new Delievery_Location_Master__c();
     deliveryLocMa.Delivery_Location_Description__c='testdata';
     deliveryLocMa.Name='TestData';
     deliveryLocMa.Client_Geo_Area_Master__c=clientGeoArea.id;
     insert deliveryLocMa;
     
     deliveryLocation = new Delivery_Location__c(Offering_Name__c =oppOffering.id, Service_Delivery_Location__c = serviceDeliveryLocation.Id, Delivery_Location_Master__c=deliveryLocMa.id );
     insert deliveryLocation;
      
     clientDependency = new Client_Dependency__c (Name = 'TestClientDep',Client_Dependency_Master__c = clientDependencyMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id);
     insert clientDependency;
     
     assumption= new Assumption__c (Name = 'TestAssumption',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
     insert assumption;
   }
   /*static testMethod void testOfferingLocationController(){
    test.starttest();
      setupData();
      ApexPages.StandardController stdCon;
      apexpages.currentpage().getparameters().put('id' ,oppOffering.id);
      OfferingLocationController offeringLocationController = new OfferingLocationController (stdCon);
      //PageReference addNewLocDetail= offeringLocationController.addNewLocDetail();
      //offeringLocationController.initializeDetailRecords();
      //List<selectOption> getLocationNames =offeringLocationController.getLocationNames();
      //PageReference saveLocationDetails= offeringLocationController.saveLocationDetails();
      PageReference refreshAccProfilePage= offeringLocationController.refreshAccProfilePage();
      PageReference deleteFile= offeringLocationController.deleteFile();
      String  getFileIdDelete= offeringLocationController.getFileIdDelete();
      
      offeringLocationController.pageid = serviceDeliveryLocation.id;
      offeringLocationController.initializeDetailRecords();
      PageReference saveLocationDetails= offeringLocationController.saveLocationDetails();
      
      String fileIdDelete;
      offeringLocationController.setFileIdDelete(fileIdDelete);


    test.stoptest();
   } */
   static testMethod void testOfferingLocationControllerPageMessage(){
    test.starttest();
      setupData();
      ApexPages.StandardController stdCon;
      
      OfferingLocationController offeringLocationController = new OfferingLocationController (stdCon);
      List<ApexPages.Message> msgList = ApexPages.getMessages();
        // or loop over the messages
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
           
            System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        } 
      PageReference addNewLocDetail= offeringLocationController.addNewLocDetail();
      offeringLocationController.initializeDetailRecords();
      List<selectOption> getLocationNames =offeringLocationController.getLocationNames();
      PageReference saveLocationDetails= offeringLocationController.saveLocationDetails();
      PageReference refreshAccProfilePage= offeringLocationController.refreshAccProfilePage();
      PageReference deleteFile= offeringLocationController.deleteFile();

    test.stoptest();
   } 
     
   }