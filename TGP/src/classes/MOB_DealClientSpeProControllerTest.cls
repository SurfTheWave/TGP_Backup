/*
Author : Malkeet Singh
Story  : MOB_126
Description : Test Class for MOB_DealClientSpeProController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class MOB_DealClientSpeProControllerTest{
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
static Commercial_Planning__c comPlan;
static Opportunity_TGP__c oppTGP;
static Offerings_Master__c offeringMaster;
static Service_Master__c serviceMaster;
static ApexPages.StandardController sc;

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
wavePlanVersion.Display_tracking_message__c='Test Data';
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

//To create an Offering Master
offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
     insert offeringMaster;

// to create a service master record

serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
     insert serviceMaster;

// To Create Client Specific Process Mapping

clientSpecificProcessMapping = new Client_Specific_Process_Mapping__c();
clientSpecificProcessMapping.Name='TestData';
clientSpecificProcessMapping.Deal__c=deal.id;
clientSpecificProcessMapping.Active__c=true;
clientSpecificProcessMapping.Offering__c=offering.id;
clientSpecificProcessMapping.Process__c=serviceMaster.id;
insert clientSpecificProcessMapping;

//To create a Wave Plan

waveplan =new Wave_Planning__c();
waveplan.Wave_Comment__c='test data';
waveplan.Wave_Label__c='TestData';
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Deal_Location__c=dealLoc.id;
insert waveplan; 

// To create a Wave Process

WaveProcess =new Wave_Process__c();
WaveProcess.Wave_Planning__c=waveplan.id;
WaveProcess.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
WaveProcess.Number_of_Projected_FTEs__c=555;
insert WaveProcess;

// To Create Commercial Planning
comPlan = new Commercial_Planning__c();
comPlan.Name='TestData';
comPlan.Activity__c='TestData';
comPlan.Delivery_Location__c=deliveryLocMa.id;
comPlan.Planned_Start_Date__c=date.today();
comPlan.Planned_End_Date__c=date.today()+7;
insert comPlan;

sc = new ApexPages.StandardController(deal);

      
}
static testMethod void test1(){
test.starttest();
setupData();
ApexPages.StandardController controller;
PageReference pageRef = new PageReference('/apex/MOB_DealClientSpecificProcess');
test.setCurrentPage(pageRef); 
apexpages.currentpage().getparameters().put('id' ,deal.id);
 
 MOB_DealClientSpecificProcessController obj = new MOB_DealClientSpecificProcessController( sc);
 obj.strProcessName = 'TestData';
 obj.SaveProcess();
 obj.refreshServices();
 obj.refreshServiceComponents();
 obj.CheckProcessExistInWave();
 test.stoptest();
    
 }  
 static testMethod void test2(){
test.starttest();
setupData();
ApexPages.StandardController controller;
PageReference pageRef = new PageReference('/apex/MOB_DealClientSpecificProcess');
test.setCurrentPage(pageRef); 
apexpages.currentpage().getparameters().put('processID',clientSpecificProcessMapping.id);

 
 MOB_DealClientSpecificProcessController obj = new MOB_DealClientSpecificProcessController( sc);
 obj.strProcessName = 'TestData';
 obj.strActive=false;
 obj.SaveProcess();
 obj.refreshServices();
 obj.refreshServiceComponents();
  obj.CheckProcessExistInWave();
 test.stoptest();
    
 } 
 
 static testMethod void test3(){
test.starttest();
setupData();
ApexPages.StandardController controller;
PageReference pageRef = new PageReference('/apex/MOB_DealClientSpecificProcess');
test.setCurrentPage(pageRef); 
apexpages.currentpage().getparameters().put('processID',clientSpecificProcessMapping.id);

 
 MOB_DealClientSpecificProcessController obj = new MOB_DealClientSpecificProcessController( sc);
 obj.strProcessName = 'TestData';

 obj.SaveProcess();
 obj.refreshServices();
 obj.refreshServiceComponents();
  obj.CheckProcessExistInWave();
 test.stoptest();
    
 } 
 
 
 
}