/*
Author : Sushmanth Hasti
Description : Test Class for Mob_CascadeTechActivityMasterChanges. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class Mob_CascadeTechActivityMaChangesTest{
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
static Tech_Assessment_Activity_Master__c TechAss;
static Tech_Assessment_Activity_Master__c TechAss1;
static List<Tech_Assessment_Activity_Master__c> listTasknew = new List<Tech_Assessment_Activity_Master__c>();
static List<Tech_Assessment_Activity_Master__c> listTaskOld = new List<Tech_Assessment_Activity_Master__c>();


public static void setupData(){
//To create a KT Planning Activity Master
TechAss= new Tech_Assessment_Activity_Master__c();
TechAss.Name='TestRecruitmentData';
TechAss.Activity_Order__c=15;
insert TechAss;
listTaskOld.add(TechAss); 
//To create a KT Planning Activity Master
TechAss1= new Tech_Assessment_Activity_Master__c();
TechAss1.Name='TestRecruitmentData1';
TechAss1.Activity_Order__c=20;
insert TechAss1;
listTasknew.add(TechAss1); 


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



//To create a Wave Plan

waveplan =new Wave_Planning__c();
waveplan.Wave_Comment__c='test comment data';
waveplan.Wave_Label__c='TestWavePlanData';
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Deal_Location__c=dealLoc.id;
waveplan.Number_of_Projected_FTEs__c=1;
insert waveplan; 

}

static testMethod void testInsert(){
test.starttest();
setupData();
Mob_CascadeTechActivityMasterChanges.CascadeActivityMasterChangesOnInsert(listTaskold);
test.stoptest();
} 
  
static testMethod void testUpdate(){
test.starttest();
setupData();
Mob_CascadeTechActivityMasterChanges.CascadeActivityMasterChangesOnUpdate(listTaskold,listTasknew);
test.stoptest();
}
   
static testMethod void testDelete(){
test.starttest();
setupData();
Mob_CascadeTechActivityMasterChanges.CascadeActivityMasterChangesOnDelete(listTaskOld);
test.stoptest();
}   
}