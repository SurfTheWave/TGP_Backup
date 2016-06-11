/*
Author : Vinay Chada
Story  : MOB_120
Description : Test Class for OPEXPlanController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Malkeet Singh     MOB_120                   07/03/2013       To increase code coverage

*/
@isTest
private class OPEXPlanControllerTest{
static Deal_Home_Location__c dealHome;
static Delievery_Location_Master__c delivery;
static OPEX__c opex;
static Deal_Location__c deal;
static Deal_Location__c dl;
static Wave_Plan_Version__c wave;
static Deal_TGP__c dealTGP;
static Wave_Planning__c waveplan;
static OPEX__c op;
public static String ProcessId;
public static String buttonName = 'Update';
static Client_Geo_Area_Master__c clientGeo;
static User testUser;

public static void setupData(){

clientGeo = new Client_Geo_Area_Master__c();
clientGeo.Client_Geo_Area_Description__c='TestData';
insert clientGeo;

delivery =new Delievery_Location_Master__c();
delivery.Delivery_Location_Description__c='testdata';
delivery.Name='TestData';
delivery.Client_Geo_Area_Master__c=clientGeo.id;
insert delivery; 

dealTGP =new Deal_TGP__c();
dealTGP.Name='Test Data';
insert dealTGP;

wave =new Wave_Plan_Version__c();
wave.Display_tracking_message__c='Test Data';
wave.active__c=true;
wave.Deal__c=dealTGP.id;
insert wave;

dealHome =new Deal_Home_Location__c(); 
dealHome.Delivery_Location_Master__c=delivery.id;
dealHome.Deal__c= dealTGP.id;
insert dealHome;


deal= new Deal_Location__c();
deal.Location__c='test Data';
deal.Deal_Home_Location__c=dealHome.id;
deal.Wave_Plan_Version__c=wave.id;
insert deal;

waveplan =new Wave_Planning__c();
waveplan.Wave_Comment__c='test data';
waveplan.Wave_Label__c='TestData';
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Deal_Location__c=deal.id;
waveplan.Number_of_Projected_FTEs__c=1;
insert waveplan; 

Wave_Planning__c wav1= [select id,Wave_Comment__c from Wave_Planning__c where Wave_Comment__c='test data'];  
waveplan.Id = wav1.ID;


opex =new OPEX__c();
opex.Deal_Location_lk__c=deal.id;
opex.Wave_Plan_lk__c=waveplan.id;
opex.Item__c='Day 30 Assessment';
opex.Active__c=true;
opex.Planned_Date__c=date.today();
opex.Deal_Location__c='India';
opex.Deal_Location_lk__c=deal.id;
opex.Wave_Plan_Version__c=wave.id;
insert opex; 


op= [Select id,Wave_Plan_Version__r.active__c,Wave_Plan_Version__c,Active__c,Item__c,Deal_Location_lk__c,Planned_Date__c, Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name from OPEX__c where id =:opex.id];
ProcessId =op.id;

dl= [select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c where Wave_Plan_Version__c=:wave.id limit 1];
}
static testMethod void testOPEXPlanController(){
    test.starttest();
    
    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
      setupData();
ApexPages.StandardController controller;
    //  apexpages.currentpage().getparameters().put('id' ,opex.id);
    apexpages.currentpage().getparameters().put('id' ,wave.id);

  
 OPEXPlanController OPEXPlanControllertest = new OPEXPlanController( controller);
 OPEXPlanControllertest.getLocationNames();
 OPEXPlanControllertest.getWavePlans();
 OPEXPlanControllertest.wavePlanName = waveplan.Id;
 OPEXPlanControllertest.addWaveProcessDetail();
 OPEXPlanControllertest.assignWave();
 OPEXPlanControllertest.checkRecordDeactivated();
 OPEXPlanControllertest.refreshWaveProcessPage();
 OPEXPlanControllertest.cancel();
 OPEXPlanControllertest.edit();
 OPEXPlanControllertest.selectAll();
 OPEXPlanControllertest.selectAllMilestone();
 List<selectOption> listSP = OPEXPlanControllertest.getLocationWaveList();
 OPEXPlanControllertest.changeDate();
 
 //OPEXPlanControllertest.OPEXNewList opexInner = new OPEXPlanControllertest.OPEXNewList();
 //opexInner.OPEXNewList();
 OPEXPlanControllertest.getListOfOPEX();
 
 }
test.stoptest();
   
 }  
 static testMethod void testOPEXPlanController2(){
    test.starttest();
      setupData();
ApexPages.StandardController controller;
     apexpages.currentpage().getparameters().put('ProcessId' ,opex.id);
    //apexpages.currentpage().getparameters().put('id' ,wave.id);

  
 OPEXPlanController OPEXPlanControllertest = new OPEXPlanController( controller);
 OPEXPlanControllertest.getLocationNames();
OPEXPlanControllertest.getWavePlans();
 OPEXPlanControllertest.addWaveProcessDetail();
  OPEXPlanControllertest.assignWave();
 OPEXPlanControllertest.checkRecordDeactivated();
 OPEXPlanControllertest.refreshWaveProcessPage();
 opex.Item__c='Day 30 Assessment';
 OPEXPlanControllertest.changeDate();
 OPEXPlanControllertest.dealLocation.item__c = 'Day 60 Assessment';
 OPEXPlanControllertest.changeDate();
 OPEXPlanControllertest.dealLocation.item__c = 'Day 90 Assessment';
 OPEXPlanControllertest.changeDate();
 OPEXPlanControllertest.dealLocation.item__c = 'Day 7 Assessment';
 OPEXPlanControllertest.changeDate();
 OPEXPlanControllertest.save();
test.stoptest();
   
 }  
}