/*
Author : Malkeet Singh
Story  :  
Description : Test Class for Mob_NewWavePlanVersion. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class Mob_NewWavePlanVersionTest{
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

public static void setupData(){


///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
insert deal;
/// To create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
Database.insert(testUser, false);

///To create a Client Geo Area
clientGeoArea = new Client_Geo_Area_Master__c ();
clientGeoArea.Name = 'TestAPAC';
clientGeoArea.Active__c = true;
 insert clientGeoArea;
 //To create offering

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

// To create a Deal
deal =new Deal_TGP__c();
deal.Name='Test Data';
insert deal;



//To create a Wave Plan Version
wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Display_tracking_message__c='Test Data';
wavePlanVersion.Deal__c=deal.id;
wavePlanVersion.Version__c=2;
insert wavePlanVersion;

// To create a Deal Home Location
dealHome =new Deal_Home_Location__c(); 
dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
dealHome.Deal__c= deal.id;
insert dealHome;


}
public static void setupData2()
{
///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
insert deal;
}

 static testMethod void test(){
test.starttest();
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('id' ,deal.id);

 
 Mob_NewWavePlanVersion.newVersion(deal.id);
 

 test.stoptest();
    
 
 }
  static testMethod void test2(){
test.starttest();
setupData2();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('id' ,deal.id);

 
 Mob_NewWavePlanVersion.newVersion(deal.id);
 

 test.stoptest();
    
 
 }
 }