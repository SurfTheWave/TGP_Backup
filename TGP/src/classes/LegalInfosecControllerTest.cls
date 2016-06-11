/*
Author : Malkeet Singh
Story  : MOB_126
Description : Test Class for LegalInfosecController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class LegalInfosecControllerTest{
static Client_Specific_Process_Mapping__c clientSpecificProcessMapping;
static Offerings_Master__c offering;
static Wave_Plan_Version__c wavePlanVersion;
static Deal_TGP__c deal;
static Wave_Planning__c waveplan;
static Wave_Process__c WaveProcess;
static Deal_Location__c dealLoc;
static Deal_Home_Location__c dealHome;
static Delievery_Location_Master__c deliveryLocMa;
static Client_Geo_Area_Master__c clientGeo;

static Commercial_Planning__c comPlan;
static Opportunity_TGP__c oppTGP;
static Contract_Legal_Infosec__c conLegInfo;
static User testUser;

public static void setupData(){
// To create a Client Geo

clientGeo = new Client_Geo_Area_Master__c();
clientGeo.Client_Geo_Area_Description__c='TestData';
insert clientGeo;

// To create a Delivery Location Master
deliveryLocMa =new Delievery_Location_Master__c();
deliveryLocMa.Delivery_Location_Description__c='testdata';
deliveryLocMa.Name='TestData';
deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
insert deliveryLocMa;

// To create a Deal
deal =new Deal_TGP__c();
deal.Name='Test Data';
insert deal;

// To create a offering
offering =new Offerings_Master__c();
offering.Name='Test Data';
insert offering;

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


// To create a Deal Location
dealLoc= new Deal_Location__c();
dealLoc.Location__c='test Data';
dealLoc.Deal_Home_Location__c=dealHome.id;
dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
insert dealLoc;

// To Create Client Specific Process Mapping

clientSpecificProcessMapping = new Client_Specific_Process_Mapping__c();
clientSpecificProcessMapping.Name='TestData';
clientSpecificProcessMapping.Deal__c=deal.id;
clientSpecificProcessMapping.Offering__c=offering.id;
insert clientSpecificProcessMapping;

//To create a Wave Plan

waveplan =new Wave_Planning__c();
waveplan.Wave_Comment__c='test data';
waveplan.Wave_Label__c='TestData';
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Deal_Location__c=dealLoc.id;
waveplan.Number_of_Projected_FTEs__c=1;
insert waveplan; 

// To create a Wave Process

WaveProcess =new Wave_Process__c();
WaveProcess.Wave_Planning__c=waveplan.id;
WaveProcess.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
insert WaveProcess;



// To Create Commercial Planning
comPlan = new Commercial_Planning__c();
comPlan.Name='TestData';
comPlan.Activity__c='TestData';
comPlan.Delivery_Location__c=deliveryLocMa.id;
comPlan.Planned_Start_Date__c=date.today();
comPlan.Planned_End_Date__c=date.today()+7;
insert comPlan;


      
//To create a Contract Legal Infosec record
      
conLegInfo=new Contract_Legal_Infosec__c();
conLegInfo.Name='TestData';
conLegInfo.Activity__c='TestData';
conLegInfo.Planed_Start_Date__c=date.today();
conLegInfo.Planned_End_Date__c=date.today()+7;
conLegInfo.Wave_Plan_lk__c=waveplan.id;
conLegInfo.Deal_Location_lk__c=dealLoc.id;
insert conLegInfo;

      
}
static testMethod void test1(){
test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
     
      	testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
      	Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('ProcessId' ,conLegInfo.id);
 
 LegalInfosecController obj = new LegalInfosecController( controller);
 obj.addWaveProcessDetail();
 obj.getLocationNames();
 obj.refreshWaveProcessPage();
 obj.getWavePlans();
 obj.checkRecordDeactivated();
 }
 test.stoptest();
    
 }  
 /*static testMethod void test2(){
test.starttest();
setupData();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('ProcessId' ,null);
 
 LegalInfosecController obj = new LegalInfosecController( controller);
 obj.addWaveProcessDetail();
 obj.getLocationNames();
 obj.refreshWaveProcessPage();
 obj.getWavePlans();
 test.stoptest();
    
 } */ 
 static testMethod void test3(){
test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
     
      	testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
      	Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
LegalInfosecController obj = new LegalInfosecController( controller);
 obj.addWaveProcessDetail();
 obj.refreshWaveProcessPage();
 obj.getLocationNames();
 obj.getWavePlans();
 obj.checkRecordDeactivated();
 }
 test.stoptest();
    
 } 
 static testMethod void test4(){
test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
     
      	testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
      	Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('ProcessId' ,conLegInfo.id);
LegalInfosecController obj = new LegalInfosecController( controller);
 //obj.locationName='None';
 obj.buttonName='None';
 obj.addWaveProcessDetail();
 obj.refreshWaveProcessPage();
 obj.getLocationNames();
 obj.getWavePlans();
 obj.checkRecordDeactivated();
 }
 test.stoptest();
    
 } 
 
 
}