/*
Author : Sushmanth Hasti 
Story  :  Story-0138 / MOB_122 
Description : Test Class for Mob_CascadeActivityMasterChanges. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class Mob_CascadeComercialActMasterChangeTest{
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
static Activity_Master__c ActivMas;
static KT_Planning_Activity_Master__c  KTPAMas;
static Journey_Management__c joumg;
static Journey_Management_Deliverable__c joumgde;
static  Commercial_Plan_Activity_Master__c CoPAmas;
static  OPEX_Item_master__c OpImas;
static SRAT_Item_Master__c SRImas;
static Commercial_Planning__c comPlan;
static Commercial_Plan_Activity_Master__c cpam;
static List<Commercial_Plan_Activity_Master__c> lstOldActivity = new List<Commercial_Plan_Activity_Master__c>();
static List<Commercial_Plan_Activity_Master__c> lstNewActivity = new List<Commercial_Plan_Activity_Master__c>();

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
deal.Name='Tesing the Deal Data';
insert deal;

// To create a offering
offering =new Offerings_Master__c();
offering.Name='Test offering Data';
insert offering;

//To create a Wave Plan Version
wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Display_tracking_message__c=null;
wavePlanVersion.Deal__c=deal.id;
wavePlanVersion.Active__c=true;
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

//To create a Commercial Planning Activity Master
CoPAmas= new Commercial_Plan_Activity_Master__c();
CoPAmas.Activity_Name__c='TestRecruitmentData';
CoPAmas.Activity_Order__c = 20;
insert CoPAmas;
lstOldActivity.add(CoPAmas);



//To create a commercial planning master record
cpam=new Commercial_Plan_Activity_Master__c();
cpam.Activity_Name__c='test';
cpam.Activity_Order__c=25;
insert cpam;


// To Create Commercial Planning
comPlan = new Commercial_Planning__c();
comPlan.Name='TestData';
comPlan.Activity__c='TestData';
comPlan.Delivery_Location__c=deliveryLocMa.id;
comPlan.Planned_Start_Date__c=date.today();
comPlan.Planned_End_Date__c=date.today()+7;
insert comPlan;

      
}

static testMethod void testInsert()
{
test.starttest();
setupData();
Mob_CascadeComercialActivityMasterChange.CascadeActivityMasterChangesOnInsert(lstOldActivity);
test.stoptest();
}  
static testMethod void testUpdate()
{
test.starttest();
setupData();
//To create a Commercial Planning Activity Master
CoPAmas= new Commercial_Plan_Activity_Master__c();
CoPAmas.Activity_Name__c='TestRecruitmentData1';
CoPAmas.Activity_Order__c=15;
insert CoPAmas;
lstNewActivity.add(CoPAmas);
Mob_CascadeComercialActivityMasterChange.CascadeActivityMasterChangesOnUpdate(lstOldActivity,lstNewActivity);
test.stoptest();
}  

static testMethod void testDelete()
{
test.starttest();
setupData();
Mob_CascadeComercialActivityMasterChange.CascadeActivityMasterChangesOnDelete(lstOldActivity);
test.stoptest();
}  
 
 static testMethod void test2(){
test.starttest();
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);


 
 Trackingonmessagepagecontroller obj = new Trackingonmessagepagecontroller( controller);

 test.stoptest();
    
 
 }

 }