/*
Author : Malkeet Singh
Story  :  
Description : Test Class for Mob_CascadeBusinessMasterChanges. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class Mob_CascadeBusinessMasterChangesTest{
static Client_Specific_Process_Mapping__c clientSpecificProcessMapping;
static Offerings_Master__c offering;
static Wave_Plan_Version__c wavePlanVersion;
static Wave_Plan_Version__c wavePlanVersion1;
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
static Commercial_Plan_Activity_Master__c CoPAmas;
static OPEX_Item_master__c OpImas;
static SRAT_Item_Master__c SRImas;
static Commercial_Planning__c comPlan;
static BCP_Section_Master__c bcpSecMas;
static BCP_Section_Master__c bcpSecMas1;
static BCP_Task_Master__c bcpTaskMas;
static BCP_Task_Master__c bcpTaskMas1;
Static Business_Continuity_Planning__c bcpRec;

public static void setupData(){
//To create a Section Master
bcpSecMas=new BCP_Section_Master__c();
bcpSecMas.Section_Name__c='test12323454';
bcpSecMas.Section_Number__c='1000';
insert bcpSecMas;


//To create a Section Master
bcpSecMas1=new BCP_Section_Master__c();
bcpSecMas1.Section_Name__c='test1';
bcpSecMas1.Section_Number__c='2000';
insert bcpSecMas1;
//To create a Task Master

bcpTaskMas= new BCP_Task_Master__c();

bcpTaskMas.Task_Name__c='test12434';
bcpTaskMas.Task_Number__c=200;
bcpTaskMas.Business_Continuity_Planning_del__c=bcpSecMas.id;
insert bcpTaskMas;


//To create a Task Master

bcpTaskMas1= new BCP_Task_Master__c();

bcpTaskMas1.Task_Name__c='test1535646';
bcpTaskMas1.Task_Number__c=10000;
bcpTaskMas1.Business_Continuity_Planning_del__c=bcpSecMas1.id;
insert bcpTaskMas1;
      

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
wavePlanVersion.Display_tracking_message__c='Test wave plan version Data';
wavePlanVersion.Deal__c=deal.id;
wavePlanVersion.Active__c=true;
wavePlanVersion.Display_tracking_message__c='Tracking is On';
insert wavePlanVersion;

wavePlanVersion1 =new Wave_Plan_Version__c();
wavePlanVersion1.Display_tracking_message__c= null;
wavePlanVersion1.Deal__c=deal.id;
wavePlanVersion1.Active__c=true;

insert wavePlanVersion1;

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


// To create a BCP record
bcpRec=new Business_Continuity_Planning__c ();
bcpRec.Wave_Plan_Version__c=wavePlanVersion.id;
bcpRec.Active__c=true;
bcpRec.Comments__c='test';
bcpRec.Section_Number__c='2';
bcpRec.Section_Name__c='test';
bcpRec.Task_Name__c='test';
bcpRec.Task_Number__c=3;
bcpRec.Planned_End_Date__c=date.today()+7;
bcpRec.Planned_Start_Date__c=date.today();
insert bcpRec;


}

static testMethod void test1(){
test.starttest();
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

List<BCP_Task_Master__c> listTasknew=[select id,name,Task_Name__c,Task_Number__c,Business_Continuity_Planning_del__c from BCP_Task_Master__c where id=:bcpTaskMas.id];
List<BCP_Task_Master__c> listTaskOld=[select id,name,Task_Name__c,Task_Number__c,Business_Continuity_Planning_del__c from BCP_Task_Master__c where id=:bcpTaskMas1.id];
List<BCP_Section_Master__c> listSectionOld=[select id,name,Section_Name__c,Section_Number__c from BCP_Section_Master__c where id=:bcpSecMas.id];
List<BCP_Section_Master__c> listSectionNew=[select id,name,Section_Name__c,Section_Number__c from BCP_Section_Master__c where id=:bcpSecMas1.id];



Mob_CascadeBusinessMasterChanges.CascadeBusinessMasterChangesOnUpdate(listSectionOld,listSectionNew);
Mob_CascadeBusinessMasterChanges.CascadeBusinessTaskChangesOnUpdate(listTaskOld,listTasknew);
Mob_CascadeBusinessMasterChanges.CascadeTaskMasterChangesOnInsert(listTasknew);
Mob_CascadeBusinessMasterChanges.CascadeBusinessTaskChangesOnDelete(listTaskOld);
 test.stoptest();
    
 }  
 
 }