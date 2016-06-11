/*
Author : Malkeet Singh
Story  :   
Description : Test Class for OPEXPlanController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class CommercialPlanControllerTest{

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
static User testUser;

static Commercial_Planning__c comPlan;

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
wavePlanVersion.Display_tracking_message__c='Tracking is On';
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

Commercial_Plan_Activity_Master__c commPlanActivityMaster = new Commercial_Plan_Activity_Master__c();
commPlanActivityMaster.Activity_Name__c = 'test';
commPlanActivityMaster.Activity_Order__c = 1294; 

insert commPlanActivityMaster;

// To Create Commercial Planning
comPlan = new Commercial_Planning__c();
comPlan.Name='TestData';
comPlan.Activity__c='TestData';
comPlan.Delivery_Location__c=deliveryLocMa.id;
comPlan.Planned_Start_Date__c=date.today();
comPlan.Planned_End_Date__c=date.today()+7;
comPlan.Commercial_Plan_Activity_Master_Id__c = commPlanActivityMaster.Id;
insert comPlan;
}
static testMethod void test1(){

test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);

testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);

insert testUser;

//Run As U1
System.RunAs(testUser){
setupData();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('ProcessId' ,comPlan.id);
 
 CommercialPlanController obj = new CommercialPlanController( controller);
 obj.addWaveProcessDetail();
 obj.refreshWaveProcessPage();
 obj.checkRecordDeactivated();
 obj.BudgetTracker();
 obj.save();
 obj.cancel();
 obj.edit();
 obj.selectAll();
 obj.selectAllMilestone();
 }
 test.stoptest();
    
 }  
 static testMethod void test2(){

test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);

testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
insert testUser;

//Run As U1
System.RunAs(testUser){
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

 
 CommercialPlanController obj = new CommercialPlanController( controller);
 obj.addWaveProcessDetail();
 obj.refreshWaveProcessPage();
 obj.checkRecordDeactivated();
 obj.BudgetTracker();
 obj.save();
 obj.cancel();
 obj.edit();
 obj.selectAll();
 obj.selectAllMilestone();
 }
 test.stoptest();
    
 } 
static testMethod void test3(){

test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);

testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);

insert testUser;

//Run As U1
System.RunAs(testUser){
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('ProcessId' ,comPlan.id);

 
 CommercialPlanController obj = new CommercialPlanController( controller);
  obj.buttonName='None';
 obj.addWaveProcessDetail();
 obj.refreshWaveProcessPage();
 obj.checkRecordDeactivated();
 obj.BudgetTracker();
 obj.save();
 obj.cancel();
 obj.edit();
 obj.selectAll();
 obj.selectAllMilestone();
 }
 test.stoptest();
    
 }  
  
}