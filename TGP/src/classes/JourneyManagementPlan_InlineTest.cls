/*
Author : Sanjay

Description : Test Class for Journey Management Plan. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/


@isTest(SeeAlldata= true)
private class JourneyManagementPlan_InlineTest{

static User testUser;
static ApexPages.StandardController sc;
static Wave_Plan_Version__c wavePlanVersion;
static Deal_TGP__c deal;
static Journey_Management_Planning__c jourPlan;
static Journey_Management_Planning__c jourPlan1;
static Journey_Management_Deliverable__c joumandel;
static Journey_Management__c joumastas;

public static void setupData()
 {
 
 // record creation for deal
  deal =new Deal_TGP__c();
 deal.Name='Test Data';
 
 insert deal;
 
 // record creation for wave plan version
 
 wavePlanVersion =new Wave_Plan_Version__c();
 wavePlanVersion.Display_tracking_message__c='Test Data';
 wavePlanVersion.Deal__c=deal.id;
 wavePlanVersion.Display_tracking_message__c='Tracking is On';
 
 insert wavePlanVersion;
 
 // record creation for Journey Management Section
 joumastas=new Journey_Management__c();
joumastas.Section_Name__c='test';
joumastas.Section_Number__c='9';
insert joumastas;
 
 // record creation for Journey Management Deliverable 
 joumandel=new Journey_Management_Deliverable__c();
joumandel.Journey_Management__c=joumastas.id;
joumandel.Deliverable_Name__c='test';
joumandel.Deliverable_Number__c='4';
insert joumandel;
 
 // record creation for journey management plan 
 jourPlan = new Journey_Management_Planning__c();
 jourPlan.Active__c=true;
 jourPlan.Comments__c='test comment';
 jourPlan.Planned_End_Date__c=date.today()+7;
 jourPlan.Planned_Start_Date__c=date.today();
 jourPlan.Responsibility__c='client';
 jourPlan.Wave_Plan_Version__c=wavePlanVersion.id;
 jourPlan.Section_Number__c='2';
 jourPlan.Section_Name__c='test';
 jourPlan.Journey_Management_Deliverable_Id__c=joumandel.id; 
 insert jourPlan;
 
 
 jourPlan1=new Journey_Management_Planning__c();
 insert jourPlan1;
sc = new ApexPages.StandardController(wavePlanVersion);
 }
 
 static testMethod void test1()
 {
	 test.starttest();
	 Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
//Run As U1
System.RunAs(testUser)
{
    setupData();
    ApexPages.StandardController controller;
   apexpages.currentpage().getparameters().put('processId',jourPlan.id);
   apexpages.currentpage().getparameters().put('id',null);
   JourneyManagementPlan_Inline obj = new JourneyManagementPlan_Inline(sc);
   obj.initializeDetailRecords();
   obj.journeyManagementPlan.comments__c='test';

   obj.saveJourneyPlan();
   obj.getSectionNames();
   obj.journeyManagementPlan.comments__c='test';

   obj.checkRecordDeactivated();
   obj.cancel();
   obj.edit();
   obj.selectAll();
   obj.selectAllMilestone();
   obj.save();
}
  test.stoptest();
 
 }
static testMethod void test2()
 {
	 test.starttest();
	 Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
//Run As U1
System.RunAs(testUser)
{
    setupData();
    ApexPages.StandardController controller;
   apexpages.currentpage().getparameters().put('processId',null);
   apexpages.currentpage().getparameters().put('id',wavePlanVersion.id);
   JourneyManagementPlan_Inline obj = new JourneyManagementPlan_Inline(sc);
   obj.initializeDetailRecords();
   obj.saveJourneyPlan();
   obj.strSectionName=joumastas.id;
   obj.buttonName='Add';
   obj.saveJourneyPlan();
   obj.buttonName='updated';
   obj.saveJourneyPlan();
   obj.getSectionNames();
   obj.checkRecordDeactivated();
}
  test.stoptest();
 
 }
 
 static testMethod void test3()
 {
	 test.starttest();
	 Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
//Run As U1
System.RunAs(testUser)
{
    setupData();
    ApexPages.StandardController controller;
   apexpages.currentpage().getparameters().put('processId',jourPlan1.id);
   apexpages.currentpage().getparameters().put('id',null);
   JourneyManagementPlan_Inline obj = new JourneyManagementPlan_Inline(sc);
   obj.initializeDetailRecords();
   obj.saveJourneyPlan();
   obj.strSectionName=joumastas.id;
   obj.buttonName='Add';
   obj.saveJourneyPlan();
   obj.buttonName='updated';
   obj.saveJourneyPlan();
   obj.getSectionNames();
   obj.checkRecordDeactivated();
}
  test.stoptest();
 
 }
 
}