/*
Author : Malkeet Singh
Story  : MOB_126
Description : Test Class for BudgetTrackerController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class   BudgetTrackerControllerTest{
static Client_Specific_Process_Mapping__c clientSpecificProcessMapping;
static Offerings_Master__c offering;
static User testUser;
static User testUser1;
static User testUser2;
static ApexPages.StandardController sc;
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
static Contract_Legal_Infosec__c conLegInfo;
static Business_Continuity_Planning__c  bcpRec;
static Budget_Solution__c budSol;
private static string USER_NAME = 'vc12@testorg.com';

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
wavePlanVersion.Display_tracking_message__c='Tracking is On';
insert wavePlanVersion;

//To create a Budget Solution

budSol= new Budget_Solution__c();
budSol.name='test';
budSol.isSubmittedToGovernanceLead__c=true;
budSol.Wave_Plan_Version__c=wavePlanVersion.id;
budSol.Number__c=2;
insert budSol;
    
}
static testMethod void test(){
test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);


//Run As U1
System.RunAs(testUser){
setupData();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('id',wavePlanVersion.id);
 
 BudgetTrackerController obj = new BudgetTrackerController(controller);
 obj.functionF1();
 obj.functionF2();
 obj.functionF3();
 obj.functionF4();
 obj.functionF5();
 obj.functionF6();

 }
 test.stoptest();
    
 }  
static testMethod void test1(){
test.starttest();
Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,UTIL_Constants.USER_NAME);
        Database.insert(testUser1, false);

//Run As U2
System.RunAs(testUser1){
setupData();
Mob_User_Roles_Master__c userMaster=new Mob_User_Roles_Master__c ();
userMaster.Access_Level__c='read';
userMaster.Role_Name__c='Test User Role';
insert userMaster;

MOB_User_Role_Assignment__c userObj=new MOB_User_Role_Assignment__c();
userObj.Role_Name__c='Governance Lead';
userObj.Deal__c=deal.id;
userObj.Access_Level__c='read';
userObj.User_Assigned__c=testUser1.id;
userObj.Mob_User_Roles_Master__c=userMaster.id;
insert userObj;
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('id',wavePlanVersion.id);
 
 BudgetTrackerController obj = new BudgetTrackerController(controller);
 obj.functionF1();
 obj.functionF2();
 obj.functionF3();
 obj.functionF4();
 obj.functionF5();
 obj.functionF6();

 }
 test.stoptest();
    
 }
 
static testMethod void test2(){
test.starttest();
Profile p2 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(p2,UTIL_Constants.USER_NAME);
        Database.insert(testUser2, false);

//Run As U2
System.RunAs(testUser2){
setupData();

ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('id',wavePlanVersion.id);
 
 BudgetTrackerController obj = new BudgetTrackerController(controller);
 obj.functionF1();
 obj.functionF2();
 obj.functionF3();
 obj.functionF4();
 obj.functionF5();
 obj.functionF6();

 }
 test.stoptest();
    
 } 
 
}