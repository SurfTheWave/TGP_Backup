/*
Author : Sushmanth Hasti
Description : Test Class for Mob_CascadeJourneyMasterChanges. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class Mob_CascadeJourneyMasterChangesTest{
static Client_Specific_Process_Mapping__c clientSpecificProcessMapping;

static Wave_Plan_Version__c wavePlanVersion;
static Deal_TGP__c deal;
static Wave_Planning__c waveplan;
static Wave_Process__c WaveProcess;
static Deal_Location__c dealLoc;
static Deal_Home_Location__c dealHome;
static Delievery_Location_Master__c deliveryLocMa;
static Client_Geo_Area_Master__c clientGeo;

static Service_Management__c serMgmt;
static KT_Planning_Activity_Master__c  KTPAMas;
static Journey_Management_Planning__c JoMaPl;
static Journey_Management__c joumg;
static Journey_Management__c joumg1;
static Journey_Management_Deliverable__c joumgde;
static Journey_Management_Deliverable__c joumgde1;
static  Commercial_Plan_Activity_Master__c CoPAmas;
static  OPEX_Item_master__c OpImas;
static SRAT_Item_Master__c SRImas;
static Service_Management__c serman;
static Service_Management_Master__c sermanmas;
static Service_Management_Task_Master__c servmanta;
static Service_Management_Master__c sermanmas1;
static Service_Management_Task_Master__c servmanta1;

public static void setupData(){
//To create a Journey Section Master
joumg= new Journey_Management__c ();
joumg.Section_Name__c='TestRecruitmentData';
joumg.Section_Number__c='86';
insert joumg;

//To Update a Journey Section Master
joumg1= new Journey_Management__c ();
joumg1.Section_Name__c='TestRecruitmentData1';
joumg1.Section_Number__c='8';
insert joumg1;

//To create Journey Deliverable Master
joumgde= new Journey_Management_Deliverable__c();
joumgde.Deliverable_Name__c='TestRecruitmentData';
joumgde.Deliverable_Number__c='32';
joumgde.Journey_Management__c=joumg.id;
insert joumgde;

//To Update Journey Deliverable Master
joumgde1= new Journey_Management_Deliverable__c();
joumgde1.Deliverable_Name__c='TestRecruitmentData1';
joumgde1.Deliverable_Number__c='2';
joumgde1.Journey_Management__c=joumg.id;
insert joumgde1;



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
//wavePlanVersion.Display_tracking_message__c='Test wave plan version Data';
wavePlanVersion.Deal__c=deal.id;
wavePlanVersion.Active__c=true;
//wavePlanVersion.Display_tracking_message__c='Tracking is On';
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



//To create a Wave Plan

waveplan =new Wave_Planning__c();
waveplan.Wave_Comment__c='test comment data';
waveplan.Wave_Label__c='TestWavePlanData';
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Deal_Location__c=dealLoc.id;
waveplan.Number_of_Projected_FTEs__c=1;
insert waveplan; 

// To create Journey Management

JoMaPl=new Journey_Management_Planning__c ();

JoMaPl.Planned_Start_Date__c=date.today();
JoMaPl.Planned_End_Date__c=date.today()+7;
JoMaPl.Wave_Plan_Version__c=wavePlanVersion.id;
JoMaPl.Section_Name__c='TestRecruitmentData9';
JoMaPl.Section_Number__c='869';
JoMaPl.Deliverable_Name__c='Test';
JoMaPl.Deliverable_Number__c='19';
insert JoMaPl; 





}
 static testMethod void test1(){
test.starttest();
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

List<Journey_Management_Deliverable__c> lstNewDeliverable=[select id,name,Deliverable_Name__c,Deliverable_Number__c,Journey_Management__c from Journey_Management_Deliverable__c where id=:joumgde.id];
List<Journey_Management_Deliverable__c> lstOldDeliverable=[select id,name,Deliverable_Name__c,Deliverable_Number__c,Journey_Management__c from Journey_Management_Deliverable__c where id=:joumgde1.id];
List<Journey_Management__c > lstOldSection=[select id,name,Section_Name__c,Section_Number__c from Journey_Management__c  where id=:joumg.id];
List<Journey_Management__c > lstNewSection=[select id,name,Section_Name__c,Section_Number__c from Journey_Management__c  where id=:joumg1.id];



Mob_CascadeJourneyMasterChanges.CascadeJourneyMasterChangesOnUpdate(lstOldSection,lstNewSection);
Mob_CascadeJourneyMasterChanges.CascadeJourneyDeliverableChangesOnUpdate(lstNewDeliverable,lstOldDeliverable);
Mob_CascadeJourneyMasterChanges.CascadeDeliverableMasterChangesOnInsert(lstNewDeliverable);
Mob_CascadeJourneyMasterChanges.CascadeJourneyDeliverableChangesOnDelete(lstOldDeliverable);
 test.stoptest();
    
 }   
}