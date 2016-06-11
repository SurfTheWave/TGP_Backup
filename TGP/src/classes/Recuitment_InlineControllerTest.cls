/*
Author : Sanjay Kumar Das
Story  :  Story-0138 / MOB_122 
Description : Test Class for Recruitment tracking Plan Controller. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class Recuitment_InlineControllerTest{
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

static Opportunity_TGP__c oppTGP;
static Recruitment_Tracking__c RecruitmentTracking;
static User testUser;
static Mob_User_Roles_Master__c strMoURM;
static MOB_User_Role_Assignment__c roleAssign;

public static void setupData(){

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
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
deal.Name='Tesing the Deal Data';
insert deal;

// To create a offering
offering =new Offerings_Master__c();
offering.Name='Test offering Data';
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
dealLoc.Location__c='test  Data';
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
waveplan.Wave_Comment__c='test comment data';
waveplan.Wave_Label__c='TestWavePlanData';
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Deal_Location__c=dealLoc.id;
waveplan.Number_of_Projected_FTEs__c=1;
insert waveplan; 

// To create a Wave Process

WaveProcess =new Wave_Process__c();
WaveProcess.Wave_Planning__c=waveplan.id;
WaveProcess.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
insert WaveProcess;






      
//To create a Recruitment tracking Plan record
      
RecruitmentTracking=new Recruitment_Tracking__c();
RecruitmentTracking.Name='TestRecruitmentData';
RecruitmentTracking.Activity__c='TestActData';
RecruitmentTracking.Planned_Start_Date__c=date.today();
RecruitmentTracking.Planned_End_Date__c=date.today()+7;
RecruitmentTracking.Wave_Plan_lk__c=waveplan.id;
RecruitmentTracking.Deal_Location_lk__c=dealLoc.id;
RecruitmentTracking.FTE_Number__c=11;
RecruitmentTracking.Wave_Plan_Version__c=wavePlanVersion.id;
insert RecruitmentTracking;

testUser = new User(alias = 'vc30', email='vc30@testorg.com',
emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
localesidkey='en_US', profileid = p1.Id, country='United States',
timezonesidkey='America/Los_Angeles', username='vc30@testorg.com');
insert testUser;
    
// To create a Mob_User_Roles_Master__c
strMoURM=new Mob_User_Roles_Master__c();
strMoURM.Access_Level__c='Edit';
strMoURM.Role_Name__c='Deal PMO1';
insert strMoURM;
    
    roleAssign = new MOB_User_Role_Assignment__c();
    roleAssign.Access_Level__c='Edit';
    roleAssign.Deal__c=deal.id;
    roleAssign.Mob_User_Roles_Master__c=strMoURM.id;
    roleAssign.Role_Name__c='Program Control PMO';
    roleAssign.User_Assigned__c=testUser.id;
    roleAssign.User_Assigned_Secondary__c=testUser.id;
    insert roleAssign ;

      
}
static testMethod void test1(){
test.starttest();
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('processId' ,RecruitmentTracking.id);
apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);


 
 Recuitment_InlineController obj = new Recuitment_InlineController( controller);

 obj.addWaveProcessDetail();
 obj.getLocationNames();
 obj.refreshWaveProcessPage();
 obj.getWavePlans();
 obj.goToRecTracker();
 obj.checkRecordDeactivated();
 obj.getLocationWaveList();
 obj.save();
 obj.cancel();
 obj.edit();
 obj.selectAll();
 obj.selectAllMilestone();

 test.stoptest();
    
 }  
 static testMethod void test2(){
test.starttest();
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

 
 Recuitment_InlineController obj = new Recuitment_InlineController( controller);

 obj.addWaveProcessDetail();
 obj.refreshWaveProcessPage();
 obj.getLocationNames();
 obj.getWavePlans();
 obj.goToRecTracker();
 obj.checkRecordDeactivated();
 obj.getLocationWaveList();
 obj.save();
 

 test.stoptest();
    
 } 
 static testMethod void test3(){
test.starttest();
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

 
 Recuitment_InlineController obj = new Recuitment_InlineController( controller);

 obj.addWaveProcessDetail();
 obj.refreshWaveProcessPage();
 obj.getLocationNames();
 obj.getWavePlans();
 obj.goToRecTracker();
 obj.checkRecordDeactivated();
 obj.getLocationWaveList();
 obj.cancel();
 

 test.stoptest();
    
 } 
 
 static testMethod void test4(){
test.starttest();
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

 
 Recuitment_InlineController obj = new Recuitment_InlineController( controller);

 obj.addWaveProcessDetail();
 obj.refreshWaveProcessPage();
 obj.getLocationNames();
 obj.getWavePlans();
 obj.goToRecTracker();
 obj.checkRecordDeactivated();
 obj.getLocationWaveList();
 obj.edit();
 

 test.stoptest();
    
 } 
 
 static testMethod void test5(){
test.starttest();
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

 
 Recuitment_InlineController obj = new Recuitment_InlineController( controller);

 obj.addWaveProcessDetail();
 obj.refreshWaveProcessPage();
 obj.getLocationNames();
 obj.getWavePlans();
 obj.goToRecTracker();
 obj.checkRecordDeactivated();
 obj.getLocationWaveList();
 obj.selectAll();
 obj.selectAllMilestone();
 

 test.stoptest();
    
 } 
 
 
}