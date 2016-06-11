/*
Author : Sushmanth Hasti
Description : Test Class for Mob_CascadeServiceManMasterChanges. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class Mob_CascadeServiceManMasterChangesTest{
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

public static void setupData(){


//To create a Service Phase Master
sermanmas= new Service_Management_Master__c ();
sermanmas.Phase_Name__c='TestRecruitmentData';
sermanmas.Phase_Number__c=86;
insert sermanmas;

//To upadate a Service Phase Master
sermanmas1= new Service_Management_Master__c ();
sermanmas1.Phase_Name__c='TestRecruitmentData1';
sermanmas1.Phase_Number__c=89;
insert sermanmas1;

//To create Service Task Master
servmanta= new Service_Management_Task_Master__c ();
servmanta.Task_Name__c='TestRecruitmentData';
servmanta.Task_Number__c=32;
servmanta.Service_Management_Phase__c=sermanmas.id;
insert servmanta;

//To create Service Task Master
servmanta1= new Service_Management_Task_Master__c ();
servmanta1.Task_Name__c='TestRecruitmentData1';
servmanta1.Task_Number__c=327;
servmanta1.Service_Management_Phase__c=sermanmas1.id;
insert servmanta1;


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

// To create Service Management

serMgmt=new Service_Management__c();
serMgmt.Name='TestData';
serMgmt.Activity__c='TestData';
serMgmt.Planned_Start_Date__c=date.today();
serMgmt.Planned_End_Date__c=date.today()+7;
serMgmt.Wave_Plan_lk__c=waveplan.id;
serMgmt.Phase_Name__c='TestRecruitmentData9';
serMgmt.Phase_Number__c=869;
serMgmt.Task_Name__c='Test';
serMgmt.Task_Number__c=19;
insert serMgmt; 



}

static testMethod void test1(){
test.starttest();
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

List<Service_Management_Task_Master__c> listTasknew=[select id,name,Task_Name__c,Task_Number__c,Service_Management_Phase__c from Service_Management_Task_Master__c where id=:servmanta.id];
List<Service_Management_Task_Master__c> listTaskOld=[select id,name,Task_Name__c,Task_Number__c,Service_Management_Phase__c from Service_Management_Task_Master__c where id=:servmanta1.id];
List<Service_Management_Master__c> listSectionOld=[select id,name,Phase_Name__c,Phase_Number__c from Service_Management_Master__c where id=:sermanmas.id];
List<Service_Management_Master__c> listSectionnew=[select id,name,Phase_Name__c,Phase_Number__c from Service_Management_Master__c where id=:sermanmas1.id];



Mob_CascadeServiceManMasterChanges.CascadeServiceManMasterChangesOnUpdate(listSectionOld,listSectionNew);
Mob_CascadeServiceManMasterChanges.CascadeJourneyDeliverableChangesOnUpdate(listTasknew,listTaskOld);
Mob_CascadeServiceManMasterChanges.CascadeDeliverableMasterChangesOnInsert(listTasknew);
Mob_CascadeServiceManMasterChanges.CascadeJourneyDeliverableChangesOnDelete(listTaskOld);
 test.stoptest();
    
 }   
}