/*
Author : Malkeet Singh
Story  :   
Description : Test Class for OPEXPlanController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class DealOpportunity_InlineControllerTest{
static Deal_TGP__c deal;
static Opportunity_TGP__c oppTGP;
static Client_Master__c clientName;
static Client_Geo_Area_Master__c clientGeoArea;
static Operating_Group_Master__c operatingGroup;
static Client_Geo_Unit_Master__c clientGeoUnit;
static User testUser; 
static Deal_Opportunity__c dealopp;
static SAP_OM_Opportunity__c sapom;
static Opportunity_Offering__c oppoff;
static Offerings_Master__c offname;
static Wave_Process__c WaveProcess;
static Deal_Location__c dealLoc;
static Deal_Home_Location__c dealHome;
static Delievery_Location_Master__c deliveryLocMa;
static Wave_Plan_Version__c wavePlanVersion;
static Delivery_Location__c delloc;
static ProcessInstanceWorkitem pItem;
static Service_Delivery_Location__c serviceDeliveryLocation;
static Service_Master__c serviceMaster;
public static void setupData(){

/// To create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
insert deal;

      
      
/// To create a Client

clientName = new Client_Master__c ();
clientName.Name = 'TestObject1';
clientName.Active__c = true;
insert clientName;

///To create a Client Geo Area
clientGeoArea = new Client_Geo_Area_Master__c ();
clientGeoArea.Name = 'TestAPAC';
clientGeoArea.Active__c = true;
 insert clientGeoArea;
 //To create offering
 
 offname=new Offerings_Master__c();
 offname.Name='TestData';
 insert offname;
 
 /// To insert Operating Group Master
 
operatingGroup = new Operating_Group_Master__c ();
operatingGroup.Name = 'TestHSMPS';
operatingGroup.Active__c = true;
insert operatingGroup;

///To create a client Geo Unit

 clientGeoUnit = new Client_Geo_Unit_Master__c ();
 clientGeoUnit.Name = 'TestLATAM';
 clientGeoUnit.Active__c = true;
 insert clientGeoUnit;
 
 // To create a Delivery Location Master
deliveryLocMa =new Delievery_Location_Master__c();
deliveryLocMa.Delivery_Location_Description__c='testdata';
deliveryLocMa.Name='TestData';
deliveryLocMa.Client_Geo_Area_Master__c=clientGeoArea.id;
insert deliveryLocMa;


 //To create SAP OM OPurtunity
 sapom = new SAP_OM_Opportunity__c();
 sapom.name='401';
 sapom.Opportunity_Name__c='TestIBM';
 sapom.Client_Name__c=clientName.id;
 sapom.Client_Geo_Area__c=clientGeoArea.id;
 sapom.Operating_Group__c=operatingGroup.id;
 sapom.Client_Geo_Unit__c=clientGeoUnit.id;
 sapom.Expected_contract_sign_Quarter__c='FY12-Q4';
 
 
 insert sapom;
 

 
/// To create an Opportunity

oppTGP = new Opportunity_TGP__c();
oppTGP.Name = 'TestIBM';
oppTGP.Stage__c='Stage 1';
oppTGP.Client_Name__c= clientName.id ;
oppTGP.Client_Geo_Area__c=clientGeoArea.id;
oppTGP.Operating_Group__c=operatingGroup.id;
oppTGP.Enterprise_Solution_Architect__c=testUser.id ;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';
oppTGP.SAP_OM_Opportunity__c=sapom.id;
insert oppTGP;

//To create a Wave Plan Version
wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Display_tracking_message__c='Test Data';
wavePlanVersion.Deal__c=deal.id;
insert wavePlanVersion;

// To create a Deal Home Location
dealHome =new Deal_Home_Location__c(); 
dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
dealHome.Deal__c= deal.id;
insert dealHome;


//Creating Deal Oppurtunity
 dealopp=new Deal_Opportunity__c();
 dealopp.Deal_TGP__c=deal.id;
 dealopp.Opportunity_TGP__c=oppTGP.id;
 dealopp.Associate_to_Deal__c=true;
 insert dealopp;
 //To create new opportunity offering
 
 oppoff =new Opportunity_Offering__c();
 //oppoff.Solution_Lead__c=testUser.id;
 //oppoff.Solution_Specialist__c=testUser.id;
 oppoff.Offering_Master__c=offname.id;
 oppoff.Opportunity_TGP__c=oppTGP.id;
 
 insert oppoff;
 
 String ser = 'TestService';
 serviceMaster = new Service_Master__c(Name =ser,Offering__c = offname.id,Active__c = true );
 insert serviceMaster;
 
 serviceDeliveryLocation = new Service_Delivery_Location__c(Name = serviceMaster.name, Opportunity_Offering__c = oppoff.id, Service_Master__c = serviceMaster.id);
 insert serviceDeliveryLocation;
 
 //To create Delivery Loaction
 
 delloc = new Delivery_Location__c();
 delloc.Service_Delivery_Location__c=serviceDeliveryLocation.id;
 delloc.Delivery_Location_Master__c=deliveryLocMa.id;
 
 insert delloc;

}
public static void setupData1(){



/// To create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
      
///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Governance_Lead_Name__c=testUser.id;
insert deal;   
   
/// To create a Client

clientName = new Client_Master__c ();
clientName.Name = 'TestObject1';
clientName.Active__c = true;
insert clientName;

///To create a Client Geo Area
clientGeoArea = new Client_Geo_Area_Master__c ();
clientGeoArea.Name = 'TestAPAC';
clientGeoArea.Active__c = true;
 insert clientGeoArea;
 
 //To create offering
 
 offname=new Offerings_Master__c();
 offname.Name='TestData';
 insert offname;
 
 /// To insert Operating Group Master
 
operatingGroup = new Operating_Group_Master__c ();
operatingGroup.Name = 'TestHSMPS';
operatingGroup.Active__c = true;
insert operatingGroup;

///To create a client Geo Unit

 clientGeoUnit = new Client_Geo_Unit_Master__c ();
 clientGeoUnit.Name = 'TestLATAM';
 clientGeoUnit.Active__c = true;
 insert clientGeoUnit;
 // To create a Delivery Location Master
deliveryLocMa =new Delievery_Location_Master__c();
deliveryLocMa.Delivery_Location_Description__c='testdata';
deliveryLocMa.Name='TestData';
deliveryLocMa.Client_Geo_Area_Master__c=clientGeoArea.id;
insert deliveryLocMa;





//To create a Wave Plan Version

 //To create SAP OM OPurtunity
 sapom = new SAP_OM_Opportunity__c();
 sapom.name='102';

 
/// To create an Opportunity

oppTGP = new Opportunity_TGP__c();
oppTGP.Name = 'TestIBM';
oppTGP.Stage__c='Stage 1';
oppTGP.Client_Name__c= clientName.id ;
oppTGP.Client_Geo_Area__c=clientGeoArea.id;
oppTGP.Operating_Group__c=operatingGroup.id;
//oppTGP.Enterprise_Solution_Architect__c=testUser.id ;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';
oppTGP.SAP_OM_Opportunity__c=sapom.id;
 insert oppTGP;
 
 wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Display_tracking_message__c='Test Data';
wavePlanVersion.Deal__c=deal.id;
insert wavePlanVersion;

// To create a Deal Home Location
dealHome =new Deal_Home_Location__c(); 
dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
dealHome.Deal__c= deal.id;
insert dealHome;

 
//Creating Deal Oppurtunity
 dealopp=new Deal_Opportunity__c();
 dealopp.Deal_TGP__c=deal.id;
 dealopp.Opportunity_TGP__c=oppTGP.id;
 dealopp.Associate_to_Deal__c=false;
 insert dealopp;
 
 
 //Creating Deal Oppurtunity
 //dealopp.Associate_to_Deal__c=true;
 //update dealopp;
 //To create new opportunity offering
 
 oppoff =new Opportunity_Offering__c();
 //oppoff.Solution_Lead__c=testUser.id;
 ////oppoff.Solution_Specialist__c=testUser.id;
 oppoff.Offering_Master__c=offname.id;
 oppoff.Opportunity_TGP__c=oppTGP.id;
 
 insert oppoff;
 
 String ser = 'TestService';
 serviceMaster = new Service_Master__c(Name =ser,Offering__c = offname.id,Active__c = true );
 insert serviceMaster;
 
 serviceDeliveryLocation = new Service_Delivery_Location__c(Name = serviceMaster.name, Opportunity_Offering__c = oppoff.id, Service_Master__c = serviceMaster.id);
 insert serviceDeliveryLocation;
 
 //To create Delivery Loaction
 
 delloc = new Delivery_Location__c();
 delloc.Service_Delivery_Location__c=serviceDeliveryLocation.id;
 delloc.Delivery_Location_Master__c=deliveryLocMa.id;
 
 insert delloc;

}
public static void setupData2(){

/// To create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
insert deal;

      
      
/// To create a Client

clientName = new Client_Master__c ();
clientName.Name = 'TestObject1';
clientName.Active__c = true;
insert clientName;

///To create a Client Geo Area
clientGeoArea = new Client_Geo_Area_Master__c ();
clientGeoArea.Name = 'TestAPAC';
clientGeoArea.Active__c = true;
 insert clientGeoArea;
 //To create offering
 
 offname=new Offerings_Master__c();
 offname.Name='TestData';
 insert offname;
 
 /// To insert Operating Group Master
 
operatingGroup = new Operating_Group_Master__c ();
operatingGroup.Name = 'TestHSMPS';
operatingGroup.Active__c = true;
insert operatingGroup;

///To create a client Geo Unit

 clientGeoUnit = new Client_Geo_Unit_Master__c ();
 clientGeoUnit.Name = 'TestLATAM';
 clientGeoUnit.Active__c = true;
 insert clientGeoUnit;
 // To create a Delivery Location Master
deliveryLocMa =new Delievery_Location_Master__c();
deliveryLocMa.Delivery_Location_Description__c='testdata';
deliveryLocMa.Name='TestData';
deliveryLocMa.Client_Geo_Area_Master__c=clientGeoArea.id;
insert deliveryLocMa;

 //To create SAP OM OPurtunity
 sapom = new SAP_OM_Opportunity__c();
 sapom.name='401';
 sapom.Opportunity_Name__c='TestIBM';
 sapom.Client_Name__c=clientName.id;
 sapom.Client_Geo_Area__c=clientGeoArea.id;
 sapom.Operating_Group__c=operatingGroup.id;
 sapom.Client_Geo_Unit__c=clientGeoUnit.id;
 sapom.Expected_contract_sign_Quarter__c='FY12-Q4';
 
 
 insert sapom;
 

 
/// To create an Opportunity

oppTGP = new Opportunity_TGP__c();
oppTGP.Name = 'TestIBM';
oppTGP.Stage__c='Stage 1';
oppTGP.Client_Name__c= clientName.id ;
oppTGP.Client_Geo_Area__c=clientGeoArea.id;
oppTGP.Operating_Group__c=operatingGroup.id;
oppTGP.Enterprise_Solution_Architect__c=testUser.id ;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';
oppTGP.SAP_OM_Opportunity__c=sapom.id;

      insert oppTGP;
//To create a Wave Plan Version
wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Display_tracking_message__c='Test Data';
wavePlanVersion.Deal__c=deal.id;
insert wavePlanVersion;

// To create a Deal Home Location
dealHome =new Deal_Home_Location__c(); 
dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
dealHome.Deal__c= deal.id;
insert dealHome;      
      
//Creating Deal Oppurtunity
 dealopp=new Deal_Opportunity__c();
 dealopp.Deal_TGP__c=deal.id;
 dealopp.Opportunity_TGP__c=oppTGP.id;
 dealopp.Associate_to_Deal__c=true;
 insert dealopp;
 //To create new opportunity offering
 
 oppoff =new Opportunity_Offering__c();
 //oppoff.Solution_Lead__c=testUser.id;
 //oppoff.Solution_Specialist__c=testUser.id;
 oppoff.Offering_Master__c=offname.id;
 oppoff.Opportunity_TGP__c=oppTGP.id;
 
 insert oppoff;
 
String ser = 'TestService';
 serviceMaster = new Service_Master__c(Name =ser,Offering__c = offname.id,Active__c = true );
 insert serviceMaster;
 
 serviceDeliveryLocation = new Service_Delivery_Location__c(Name = serviceMaster.name, Opportunity_Offering__c = oppoff.id, Service_Master__c = serviceMaster.id);
 insert serviceDeliveryLocation;
 
 //To create Delivery Loaction
 
 delloc = new Delivery_Location__c();
 delloc.Service_Delivery_Location__c=serviceDeliveryLocation.id;
 delloc.Delivery_Location_Master__c=deliveryLocMa.id;
 
 insert delloc;


// Create an approval request for the deal
Approval.ProcessSubmitRequest req1 = 
    new Approval.ProcessSubmitRequest();
req1.setComments('Submitting request for approval.');
req1.setNextApproverIds(new Id[] {UserInfo.getUserId()});
req1.setObjectId(deal.id);
// Submit the approval request for the deal
Approval.ProcessResult result = Approval.process(req1);

}
public static void setupData3(){



/// To create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
      
///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Governance_Lead_Name__c=testUser.id;
insert deal;   
   
/// To create a Client

clientName = new Client_Master__c ();
clientName.Name = 'TestObject1';
clientName.Active__c = true;
insert clientName;

///To create a Client Geo Area
clientGeoArea = new Client_Geo_Area_Master__c ();
clientGeoArea.Name = 'TestAPAC';
clientGeoArea.Active__c = true;
 insert clientGeoArea;
 
 //To create offering
 
 offname=new Offerings_Master__c();
 offname.Name='TestData';
 insert offname;
 
 /// To insert Operating Group Master
 
operatingGroup = new Operating_Group_Master__c ();
operatingGroup.Name = 'TestHSMPS';
operatingGroup.Active__c = true;
insert operatingGroup;

///To create a client Geo Unit

 clientGeoUnit = new Client_Geo_Unit_Master__c ();
 clientGeoUnit.Name = 'TestLATAM';
 clientGeoUnit.Active__c = true;
 insert clientGeoUnit;
 // To create a Delivery Location Master
deliveryLocMa =new Delievery_Location_Master__c();
deliveryLocMa.Delivery_Location_Description__c='testdata';
deliveryLocMa.Name='TestData';
deliveryLocMa.Client_Geo_Area_Master__c=clientGeoArea.id;
insert deliveryLocMa;

 //To create SAP OM OPurtunity
 sapom = new SAP_OM_Opportunity__c();
 sapom.name='102';

 
/// To create an Opportunity

oppTGP = new Opportunity_TGP__c();
oppTGP.Name = 'TestIBM';
oppTGP.Stage__c='Stage 1';
oppTGP.Client_Name__c= clientName.id ;
oppTGP.Client_Geo_Area__c=clientGeoArea.id;
oppTGP.Operating_Group__c=operatingGroup.id;
//oppTGP.Enterprise_Solution_Architect__c=testUser.id ;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';
      insert oppTGP;
      
//To create a Wave Plan Version
wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Display_tracking_message__c='Test Data';
wavePlanVersion.Deal__c=deal.id;
insert wavePlanVersion;

// To create a Deal Home Location
dealHome =new Deal_Home_Location__c(); 
dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
dealHome.Deal__c= deal.id;
insert dealHome;
      
//Creating Deal Oppurtunity
 dealopp=new Deal_Opportunity__c();
 dealopp.Deal_TGP__c=deal.id;
 dealopp.Opportunity_TGP__c=oppTGP.id;
 dealopp.Associate_to_Deal__c=false;
 insert dealopp;
 
 
 //Creating Deal Oppurtunity
 //dealopp.Associate_to_Deal__c=true;
 //update dealopp;
 //To create new opportunity offering
 
 oppoff =new Opportunity_Offering__c();
 //oppoff.Solution_Lead__c=testUser.id;
 //oppoff.Solution_Specialist__c=testUser.id;
 oppoff.Offering_Master__c=offname.id;
 oppoff.Opportunity_TGP__c=oppTGP.id;
 
 insert oppoff;
 
 String ser = 'TestService';
 serviceMaster = new Service_Master__c(Name =ser,Offering__c = offname.id,Active__c = true );
 insert serviceMaster;
 
 serviceDeliveryLocation = new Service_Delivery_Location__c(Name = serviceMaster.name, Opportunity_Offering__c = oppoff.id, Service_Master__c = serviceMaster.id);
 insert serviceDeliveryLocation;
 
 //To create Delivery Loaction
 
 delloc = new Delivery_Location__c();
 delloc.Service_Delivery_Location__c=serviceDeliveryLocation.id;
 delloc.Delivery_Location_Master__c=deliveryLocMa.id;
 
 insert delloc;
// Create an approval request for the account

Approval.ProcessSubmitRequest req1 = 
    new Approval.ProcessSubmitRequest();
req1.setComments('Submitting request for approval.');
req1.setNextApproverIds(new Id[] {deal.Governance_Lead_Name__c});
req1.setObjectId(deal.id);

// Submit the approval request for the account
Approval.ProcessResult result = Approval.process(req1);


}
public static void setupData4(){

/// To create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
insert deal;

      
      
/// To create a Client

clientName = new Client_Master__c ();
clientName.Name = 'TestObject1';
clientName.Active__c = true;
insert clientName;

///To create a Client Geo Area
clientGeoArea = new Client_Geo_Area_Master__c ();
clientGeoArea.Name = 'TestAPAC';
clientGeoArea.Active__c = true;
 insert clientGeoArea;
 //To create offering
 
 offname=new Offerings_Master__c();
 offname.Name='TestData';
 insert offname;
 
 /// To insert Operating Group Master
 
operatingGroup = new Operating_Group_Master__c ();
operatingGroup.Name = 'TestHSMPS';
operatingGroup.Active__c = true;
insert operatingGroup;

///To create a client Geo Unit

 clientGeoUnit = new Client_Geo_Unit_Master__c ();
 clientGeoUnit.Name = 'TestLATAM';
 clientGeoUnit.Active__c = true;
 insert clientGeoUnit;
 // To create a Delivery Location Master
deliveryLocMa =new Delievery_Location_Master__c();
deliveryLocMa.Delivery_Location_Description__c='testdata';
deliveryLocMa.Name='TestData';
deliveryLocMa.Client_Geo_Area_Master__c=clientGeoArea.id;
insert deliveryLocMa;

 
 //To create SAP OM OPurtunity
 sapom = new SAP_OM_Opportunity__c();
 sapom.name='401';
 sapom.Opportunity_Name__c='TestIBM';
 sapom.Client_Name__c=clientName.id;
 sapom.Client_Geo_Area__c=clientGeoArea.id;
 sapom.Operating_Group__c=operatingGroup.id;
 sapom.Client_Geo_Unit__c=clientGeoUnit.id;
 sapom.Expected_contract_sign_Quarter__c='FY12-Q4';
 
 
 insert sapom;
 

 
/// To create an Opportunity

oppTGP = new Opportunity_TGP__c();
oppTGP.Name = 'TestIBM';
oppTGP.Stage__c='Stage 1';
oppTGP.Client_Name__c= clientName.id ;
oppTGP.Client_Geo_Area__c=clientGeoArea.id;
oppTGP.Operating_Group__c=operatingGroup.id;
oppTGP.Enterprise_Solution_Architect__c=testUser.id ;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';
oppTGP.SAP_OM_Opportunity__c=sapom.id;
insert oppTGP;




//To create a Wave Plan Version
wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Display_tracking_message__c='Test Data';
wavePlanVersion.Deal__c=deal.id;
insert wavePlanVersion;

// To create a Deal Home Location
dealHome =new Deal_Home_Location__c(); 
dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
dealHome.Deal__c= deal.id;
//insert dealHome;

//Creating Deal Oppurtunity
 dealopp=new Deal_Opportunity__c();
 dealopp.Deal_TGP__c=deal.id;
 dealopp.Opportunity_TGP__c=oppTGP.id;
 dealopp.Associate_to_Deal__c=true;
 insert dealopp;
 //To create new opportunity offering
 
 oppoff =new Opportunity_Offering__c();
 //oppoff.Solution_Lead__c=testUser.id;
 //oppoff.Solution_Specialist__c=testUser.id;
 oppoff.Offering_Master__c=offname.id;
 oppoff.Opportunity_TGP__c=oppTGP.id;
 
 insert oppoff;
 
 String ser = 'TestService';
 serviceMaster = new Service_Master__c(Name =ser,Offering__c = offname.id,Active__c = true );
 insert serviceMaster;
 
 serviceDeliveryLocation = new Service_Delivery_Location__c(Name = serviceMaster.name, Opportunity_Offering__c = oppoff.id, Service_Master__c = serviceMaster.id);
 insert serviceDeliveryLocation;
 
 //To create Delivery Loaction
 
 delloc = new Delivery_Location__c();
 delloc.Service_Delivery_Location__c=serviceDeliveryLocation.id;
 delloc.Delivery_Location_Master__c=deliveryLocMa.id;
 
 insert delloc;

}
static testMethod void test1(){
test.starttest();
setupData();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,deal.id);
 
 DealOpportunity_InlineController obj = new DealOpportunity_InlineController( controller);
 //Deal_Opportunity__c.listOfLoactionDetailsActual.Associate_to_Deal__c=true;
 //obj.addLocationDetail();
 //obj.initializeDetailRecords();
 //obj.saveLocationDetails();
 //obj.refreshLocationPage();
 //obj.getLocationNames();
 //obj.getLocationNamesWithoutClientName();
 test.stoptest();
  } 
  static testMethod void test2(){
test.starttest();
setupData();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,deal.id);
 
 DealOpportunity_InlineController obj = new DealOpportunity_InlineController( controller);
 //obj.listOfLoactionDetailsActual.Associate_to_Deal__c=true;
 //obj.addLocationDetail();
 //obj.initializeDetailRecords();
 obj.listOfLoactionDetailsActual[0].Associate_to_Deal__c=true;
 //obj.saveLocationDetails();
 //obj.refreshLocationPage();
 //obj.getLocationNames();
 test.stoptest();
  }  
  
static testMethod void test3(){
test.starttest();
setupData();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,null);
 
 DealOpportunity_InlineController obj = new DealOpportunity_InlineController( controller);
 // obj.listOfLoactionDetailsActual.Associate_to_Deal__c=true;
 //obj.addLocationDetail();
 obj.initializeDetailRecords();
// obj.saveLocationDetails();
 obj.refreshLocationPage();
 obj.getLocationNames();
 test.stoptest();
  } 
 
  static testMethod void test4(){
test.starttest();
setupData();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,deal.id);
 
 DealOpportunity_InlineController obj = new DealOpportunity_InlineController( controller);
 // obj.listOfLoactionDetailsActual.Associate_to_Deal__c=true;
 //obj.addLocationDetail();
 //obj.initializeDetailRecords();
 obj.listOfLoactionDetailsActual[0].Associate_to_Deal__c=false;
 //obj.saveLocationDetails();
 //obj.refreshLocationPage();
 //obj.getLocationNames();
 test.stoptest();
  }  
   static testMethod void test5(){
test.starttest();
setupData2();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,deal.id);
 
 DealOpportunity_InlineController obj = new DealOpportunity_InlineController( controller);
  //obj.listOfLoactionDetailsActual.Associate_to_Deal__c=true;
 //obj.addLocationDetail();
 //obj.initializeDetailRecords();
 //obj.listOfLoactionDetailsActual[0].Associate_to_Deal__c=false;
 //obj.saveLocationDetails();
 //obj.refreshLocationPage();
 //obj.getLocationNames();
 test.stoptest();
  } 
  static testMethod void test6(){
test.starttest();
setupData2();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,deal.id);
 
 DealOpportunity_InlineController obj = new DealOpportunity_InlineController( controller);
 // obj.listOfLoactionDetailsActual.Associate_to_Deal__c=true;
 //obj.addLocationDetail();
 //obj.initializeDetailRecords();
// obj.saveLocationDetails();
 //obj.refreshLocationPage();
 //obj.getLocationNamesWithoutClientName();
// obj.getLocationNames();
 test.stoptest();
  } 
  
  
  
static testMethod void test7(){
test.starttest();
setupData1();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,deal.id);
 
 DealOpportunity_InlineController obj = new DealOpportunity_InlineController( controller);
 // obj.listOfLoactionDetailsActual.Associate_to_Deal__c=true;
 obj.addLocationDetail();
 obj.initializeDetailRecords();
 obj.saveLocationDetails();
 obj.refreshLocationPage();
 obj.getLocationNamesWithoutClientName();
 obj.getLocationNames();
 test.stoptest();
  } 
  static testMethod void test8(){
test.starttest();
setupData1();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,deal.id);
 
 DealOpportunity_InlineController obj = new DealOpportunity_InlineController( controller);
 // obj.listOfLoactionDetailsActual.Associate_to_Deal__c=true;
 obj.addLocationDetail();
 obj.initializeDetailRecords();
 obj.listOfLoactionDetailsActual[0].Associate_to_Deal__c=true;
 obj.saveLocationDetails();
 obj.refreshLocationPage();
 obj.getLocationNamesWithoutClientName();
 obj.getLocationNames();
 test.stoptest();
  }  
  
static testMethod void test9(){
test.starttest();
setupData1();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,null);
 
 DealOpportunity_InlineController obj = new DealOpportunity_InlineController( controller);
  //obj.listOfLoactionDetailsActual.Associate_to_Deal__c=true;
 //obj.addLocationDetail();
 obj.initializeDetailRecords();
// obj.saveLocationDetails();
obj.getLocationNamesWithoutClientName();
 obj.refreshLocationPage();
 obj.getLocationNames();
 test.stoptest();
  } 
 
  static testMethod void test10(){
test.starttest();
setupData1();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,deal.id);
 
 DealOpportunity_InlineController obj = new DealOpportunity_InlineController( controller);
  //obj.listOfLoactionDetailsActual.Associate_to_Deal__c=true;
 obj.addLocationDetail();
 obj.initializeDetailRecords();
 obj.listOfLoactionDetailsActual[0].Associate_to_Deal__c=false;
 obj.saveLocationDetails();
 obj.refreshLocationPage();
 obj.getLocationNames();
 test.stoptest();
  }  
  static testMethod void test11(){
test.starttest();
setupData4();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,null);
 
 DealOpportunity_InlineController obj = new DealOpportunity_InlineController( controller);
 // obj.listOfLoactionDetailsActual.Associate_to_Deal__c=true;
 //obj.addLocationDetail();
 obj.initializeDetailRecords();
// obj.saveLocationDetails();
 obj.refreshLocationPage();
 obj.getLocationNames();
 test.stoptest();
  } 
 
  static testMethod void test12(){
test.starttest();
setupData4();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,deal.id);
 
 DealOpportunity_InlineController obj = new DealOpportunity_InlineController( controller);
  //obj.listOfLoactionDetailsActual.Associate_to_Deal__c=true;
 //obj.addLocationDetail();
 //obj.initializeDetailRecords();
 obj.listOfLoactionDetailsActual[0].Associate_to_Deal__c=false;
 //obj.saveLocationDetails();
 //obj.refreshLocationPage();
 //obj.getLocationNamesWithoutClientName();
 //obj.getLocationNames();
 test.stoptest();
  }  
 }