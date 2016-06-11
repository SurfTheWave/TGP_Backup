@isTest
private class WaveProcessAdd_InlineControllerTest{
static Wave_Planning__c waveplan;
static Wave_Planning__c waveplan1;
static Deal_Location__c dealLocation;
static Wave_Plan_Version__c wavePlanVersion;
static Deal_TGP__c  deal;
static User  testUser;
static Wave_Process__c  WaveProcess;
static Wave_Process__c  WaveProcess1;
static Client_Specific_Process_Mapping__c clientSpecificProcessMapping;
static Client_Specific_Process_Mapping__c clientSpecificProcessMapping1;
static Offerings_Master__c offering;
static MOB_User_Role_Assignment__c MoURA;
static Mob_User_Roles_Master__c MoURM;
public static void setupData1(){
// To Create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);


// To create a Deal
deal =new Deal_TGP__c();
deal.Name='Test Data';
insert deal;



// To create a Mob User Role Master
MoURM=new Mob_User_Roles_Master__c();
MoURM.Access_Level__c='Edit';
MoURM.Role_Name__c='Governance Lead1';

insert MoURM;



// To create a Mob User Role Assignment
MoURA=new MOB_User_Role_Assignment__c();
MoURA.Access_Level__c='Edit';
MoURA.Deal__c=deal.id;
MoURA.User_Assigned__c=testUser.id;
MoURA.Role_Name__c='Governance Lead1';
MoURA.Mob_User_Roles_Master__c=MoURM.id;

insert MoURA;


//To create a Wave Plan Version
wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Deal__c=deal.id;
wavePlanVersion.Name='TestData';
insert wavePlanVersion;

//To create DealLocation
dealLocation=new Deal_Location__c();
dealLocation.Wave_Plan_Version__c=wavePlanVersion.id;
dealLocation.Mobilization_Recruitment_Lead_Primary__c=testUser.id;
insert dealLocation;

dealLocation.Comment__c = 'test';
update dealLocation;


//To create a Wave Plan
waveplan =new Wave_Planning__c();
waveplan.Wave_Label__c='TestData';
waveplan.GO_Live_Date_del__c=date.today()+7;
//waveplan.Number_of_Projected_FTEs__c=1;
waveplan.Deal_Location__c=dealLocation.id;
insert waveplan;

// To create a offering
offering =new Offerings_Master__c();
offering.Name='Test Data';
insert offering;

// To Create Client Specific Process Mapping
clientSpecificProcessMapping = new Client_Specific_Process_Mapping__c();
clientSpecificProcessMapping.Name='TestData';
clientSpecificProcessMapping.Deal__c=deal.id;
clientSpecificProcessMapping.Offering__c=offering.id;
insert clientSpecificProcessMapping;

//To create WaveProcess
WaveProcess =new Wave_Process__c();
WaveProcess.Wave_Planning__c=waveplan.id;
WaveProcess.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
WaveProcess.Number_of_Projected_FTEs__c=1;
insert WaveProcess;


}
public static void setupData2(){

// To Create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);





// To create a Deal
deal =new Deal_TGP__c();
deal.Name='Test Data';
insert deal;



// To create a Mob User Role Master
MoURM=new Mob_User_Roles_Master__c();
MoURM.Access_Level__c='Edit';
MoURM.Role_Name__c='Governance Lead1';

insert MoURM;



// To create a Mob User Role Assignment
MoURA=new MOB_User_Role_Assignment__c();
MoURA.Access_Level__c='Edit';
MoURA.Deal__c=deal.id;
MoURA.User_Assigned__c=testUser.id;
MoURA.Role_Name__c='Governance Lead1';
MoURA.Mob_User_Roles_Master__c=MoURM.id;

insert MoURA;


//To create a Wave Plan Version
wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Deal__c=deal.id;
wavePlanVersion.Name='TestData';
wavePlanVersion.Display_tracking_message__c='Tracking is On';
wavePlanVersion.active__c=false;
insert wavePlanVersion;

//To create DealLocation
dealLocation=new Deal_Location__c();
dealLocation.Wave_Plan_Version__c=wavePlanVersion.id;
dealLocation.Mobilization_Recruitment_Lead_Primary__c=testUser.id;
insert dealLocation;

//To create a Wave Plan
waveplan =new Wave_Planning__c();
waveplan.Wave_Label__c='TestData';
waveplan.GO_Live_Date_del__c=date.today()+7;
//waveplan.Number_of_Projected_FTEs__c=1;
waveplan.Deal_Location__c=dealLocation.id;
insert waveplan;

//To create a Wave Plan
waveplan1 =new Wave_Planning__c();
waveplan1.Wave_Label__c='TestData';
waveplan1.GO_Live_Date_del__c=date.today()+7;
//waveplan1.Number_of_Projected_FTEs__c=1;
waveplan1.Deal_Location__c=dealLocation.id;
insert waveplan1;

// To create a offering
offering =new Offerings_Master__c();
offering.Name='Test Data';
insert offering;

// To Create Client Specific Process Mapping
clientSpecificProcessMapping = new Client_Specific_Process_Mapping__c();
clientSpecificProcessMapping.Name='None';
clientSpecificProcessMapping.Deal__c=deal.id;
clientSpecificProcessMapping.Offering__c=offering.id;
insert clientSpecificProcessMapping;


// To Create Client Specific Process Mapping
clientSpecificProcessMapping1 = new Client_Specific_Process_Mapping__c();
clientSpecificProcessMapping1.Name='TestData';
clientSpecificProcessMapping1.Deal__c=deal.id;
clientSpecificProcessMapping1.Active__c=true;
clientSpecificProcessMapping1.Offering__c=offering.id;
insert clientSpecificProcessMapping1; 

//To create WaveProcess
WaveProcess =new Wave_Process__c();
WaveProcess.Wave_Planning__c=waveplan.id;
WaveProcess.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
WaveProcess.Number_of_Projected_FTEs__c=1;
insert WaveProcess;

//To create WaveProcess
WaveProcess1 =new Wave_Process__c();
WaveProcess1.Wave_Planning__c=waveplan.id;
WaveProcess1.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
WaveProcess1.Number_of_Projected_FTEs__c=1;
insert WaveProcess1;


}
static testMethod void test1(){
setupData1();
test.starttest();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,waveplan.id);
 
 WaveProcessAdd_InlineController obj = new WaveProcessAdd_InlineController( controller);
 obj.newWaveProcessDetail = WaveProcess;
 obj.getClientSpecificProcessNames();
 obj.addWaveProcessDetail();
 obj.initializeDetailRecords();
 obj.saveWaveProcessDetails();
 obj.refreshWaveProcessPage();

 test.stoptest();
 }
 static testMethod void test2(){
setupData2();
test.starttest();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,waveplan.id);
 
 WaveProcessAdd_InlineController obj = new WaveProcessAdd_InlineController( controller);
 obj.newWaveProcessDetail = WaveProcess;
 obj.getClientSpecificProcessNames();
 obj.addWaveProcessDetail();
 obj.initializeDetailRecords();
 obj.saveWaveProcessDetails();
 obj.refreshWaveProcessPage();
 
 test.stoptest();
 }

 static testMethod void test3(){
setupData2();
test.starttest();
ApexPages.StandardController controller = new ApexPages.StandardController(deal)  ;

apexpages.currentpage().getparameters().put('Id' ,null);
 
 WaveProcessAdd_InlineController obj = new WaveProcessAdd_InlineController( controller);
 obj.getClientSpecificProcessNames();
 obj.addWaveProcessDetail();
 obj.initializeDetailRecords();
 obj.saveWaveProcessDetails();
 obj.refreshWaveProcessPage();
 
 test.stoptest();
 }


 }