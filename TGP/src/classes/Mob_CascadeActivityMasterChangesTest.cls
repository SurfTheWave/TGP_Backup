/*
Author : Sushmanth Hasti
Description : Test Class for Mob_CascadeActivityMasterChanges. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class Mob_CascadeActivityMasterChangesTest{
static Client_Specific_Process_Mapping__c clientSpecificProcessMapping;

static Wave_Plan_Version__c wavePlanVersion;
static Deal_TGP__c deal;
static Wave_Planning__c waveplan;
static Wave_Process__c WaveProcess;
static Deal_Location__c dealLoc;
static Deal_Home_Location__c dealHome;
static Delievery_Location_Master__c deliveryLocMa;
static Client_Geo_Area_Master__c clientGeo;
static Recruitment_Tracking__c RecruitmentTracking;
static Activity_Master__c ActivMas;
static Activity_Master__c ActivMas1;
static Service_Management__c serMgmt;
static KT_Planning_Activity_Master__c  KTPAMas;
static Journey_Management__c joumg;
static Journey_Management_Deliverable__c joumgde;
static  Commercial_Plan_Activity_Master__c CoPAmas;
static  OPEX_Item_master__c OpImas;
static SRAT_Item_Master__c SRImas;
static Service_Management__c serman;
static Service_Management_Master__c sermanmas;
static Service_Management_Task_Master__c servmanta;
static Service_Management_Master__c sermanmas1;
static Service_Management_Task_Master__c servmanta1;
static List<Activity_Master__c> listTaskOld = new List<Activity_Master__c>();
static List<Activity_Master__c> listTaskNew = new List<Activity_Master__c>();

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


//To create a Wave Plan Version
wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Display_tracking_message__c='Test wave plan version Data';
wavePlanVersion.Deal__c=deal.id;
wavePlanVersion.Active__c=true;
wavePlanVersion.Display_tracking_message__c=null;
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




//To create a Activity Master
ActivMas = new Activity_Master__c();
ActivMas.Name='TestRecruitmentData';
ActivMas.Activity_Order__c=15;
insert ActivMas;
listTaskOld.add(ActivMas);

ActivMas1 = new Activity_Master__c();
ActivMas1.Name='TestRecruitmentData1';
ActivMas1.Activity_Order__c=20;
insert ActivMas1;
listTaskNew.add(ActivMas1);

//To create a Wave Plan

waveplan =new Wave_Planning__c();
waveplan.Wave_Comment__c='test comment data';
waveplan.Wave_Label__c='TestWavePlanData';
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Deal_Location__c=dealLoc.id;
waveplan.Number_of_Projected_FTEs__c=1;
insert waveplan; 

//To create a Recruitment tracking Plan record
      
RecruitmentTracking=new Recruitment_Tracking__c();
RecruitmentTracking.Name='TestRecruitmentData';
RecruitmentTracking.Activity__c='TestRecruitmentData';
RecruitmentTracking.Activity_Order__c=20;
RecruitmentTracking.Planned_Start_Date__c=date.today();
RecruitmentTracking.Planned_End_Date__c=date.today()+7;
RecruitmentTracking.Wave_Plan_lk__c=waveplan.id;
RecruitmentTracking.Deal_Location_lk__c=dealLoc.id;
RecruitmentTracking.FTE_Number__c=11;
RecruitmentTracking.Activity_Master_ID__c= ActivMas.id;
insert RecruitmentTracking;


}

static testMethod void testInsert(){
test.starttest();
setupData();
Mob_CascadeActivityMasterChanges.CascadeActivityMasterChangesOnInsert(listTasknew);
 test.stoptest();    
 }   

static testMethod void testUpdate(){
test.starttest();
setupData();
Mob_CascadeActivityMasterChanges.CascadeActivityMasterChangesOnUpdate(listTaskOld,listTasknew);
 test.stoptest();    
 }   

static testMethod void testDelete(){
test.starttest();
setupData();
Mob_CascadeActivityMasterChanges.CascadeActivityMasterChangesOnDelete(listTaskOld);
 test.stoptest();    
}   
 
}