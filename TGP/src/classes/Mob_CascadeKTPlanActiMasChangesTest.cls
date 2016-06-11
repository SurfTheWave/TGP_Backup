/*
Author : Sushmanth Hasti
Description : Test Class for Mob_CascadeKTPlanActivityMasterChanges. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class Mob_CascadeKTPlanActiMasChangesTest{
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
static KT_Planning__c kTPlan;
static KT_Planning_Activity_Master__c  KTPAMas;
static KT_Planning_Activity_Master__c  KTPAMas1;
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
static List<KT_Planning_Activity_Master__c> listTasknew = new List<KT_Planning_Activity_Master__c>();
static List<KT_Planning_Activity_Master__c> listTaskOld = new List<KT_Planning_Activity_Master__c>();

public static void setupData(){

//To create a KT Planning Activity Master
KTPAMas= new KT_Planning_Activity_Master__c();
KTPAMas.Name='TestRecruitmentData1';
KTPAMas.Activity_Order__c=20;
insert KTPAMas;
listTaskold.add(KTPAMas);

//To create a KT Planning Activity Master
KTPAMas1= new KT_Planning_Activity_Master__c();
KTPAMas1.Name='TestRecruitmentData';
KTPAMas1.Activity_Order__c=15;
insert KTPAMas1;
listTasknew.add(KTPAMas1);

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

//To create a Contract Legal Infosec record
      
kTPlan=new KT_Planning__c();

kTPlan.Activity__c='TestData';
kTPlan.Activity_Order__c=25;
kTPlan.Planned_Start_Date__c=date.today();
kTPlan.Planned_End_Date__c=date.today()+7;
kTPlan.Wave_Plan_lk__c=waveplan.id;
kTPlan.Deal_Location_lk__c=dealLoc.id;
kTPlan.activity__c ='TestRecruitmentData';
kTPlan.KT_Planning_Activity_Master_ID__c =KTPAMas.id;
insert kTPlan;

}

static testMethod void testInsert(){
test.starttest();
setupData();
Mob_CascadeKTPlanActivityMasterChanges.CascadeActivityMasterChangesOnInsert(listTasknew);
test.stoptest();   
}
static testMethod void testUpdate(){
test.starttest();
setupData();
Mob_CascadeKTPlanActivityMasterChanges.CascadeActivityMasterChangesOnUpdate(listTasknew,listTaskOld);
test.stoptest();   
}
static testMethod void testDelete(){
test.starttest();
setupData();
Mob_CascadeKTPlanActivityMasterChanges.CascadeActivityMasterChangesOnDelete(listTaskOld);
test.stoptest();   
}
   
}