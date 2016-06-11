@isTest
private class WavePlanAdd_InlineControllerTest{
static Wave_Planning__c waveplan;
static Deal_Location__c dealLocation;
static Wave_Plan_Version__c wavePlanVersion;
static Deal_TGP__c  deal;
static User  testUser;
static MOB_User_Role_Assignment__c MoURA;
static Mob_User_Roles_Master__c MoURM;
static Recruitment_Tracking__c RecruitmentTracking;
static Tech_Assessment_Activity_Master__c TechAss;
static KT_Planning__c kTPlan;
static KT_Planning_Activity_Master__c  KTPAMas;
static Service_Management__c serMgmt;
static Service_Management_Master__c sermanmas;
static Service_Management_Task_Master__c servmanta;
static SRAT_VERSION__c sratversion;
static SRAT__c srat;
static OPEX__c opex;
static Contract_Legal_Infosec__c conLegInfo;
static List<ID> idList = new List<ID>();
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
MoURA.Role_Name__c='Governance Lead1';
MoURA.Mob_User_Roles_Master__c=MoURM.id;

insert MoURA;


//To create a Wave Plan Version
wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Deal__c=deal.id;
wavePlanVersion.Name='TestData';
insert wavePlanVersion;

//To create dealLocation
dealLocation=new Deal_Location__c();
dealLocation.Wave_Plan_Version__c=wavePlanVersion.id;
insert dealLocation;
//To create a Wave Plan
waveplan =new Wave_Planning__c();
waveplan.Wave_Label__c='TestData';
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Number_of_Projected_FTEs__c=1;
waveplan.NewActive__c=false;
waveplan.Deal_Location__c=dealLocation.id;
insert waveplan;


}
public static void setupData2(){
// To Create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
// To create a Deal
deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Governance_Lead_Name__c=testUser.id;
insert deal;
//To create a Wave Plan Version
wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Deal__c=deal.id;
wavePlanVersion.Name='TestData';
insert wavePlanVersion;

//To create dealLocation
dealLocation=new Deal_Location__c();
dealLocation.Wave_Plan_Version__c=wavePlanVersion.id;
insert dealLocation;
//To create a Wave Plan
waveplan =new Wave_Planning__c();
waveplan.Wave_Label__c='TestData';
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Number_of_Projected_FTEs__c=1;
waveplan.Deal_Location__c=dealLocation.id;
insert waveplan;
waveplan.Wave_Label__c='TestData2';
update waveplan;
}

public static void setupData3(){
// To Create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
// To create a Deal
deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Governance_Lead_Name__c=testUser.id;
insert deal;
//To create a Wave Plan Version
wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Deal__c=deal.id;
wavePlanVersion.Name='TestData';
insert wavePlanVersion;

//To create dealLocation
dealLocation=new Deal_Location__c();
dealLocation.Wave_Plan_Version__c=wavePlanVersion.id;
insert dealLocation;
//To create a Wave Plan
waveplan =new Wave_Planning__c();
waveplan.Wave_Label__c='TestData';
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Number_of_Projected_FTEs__c=1;
waveplan.Deal_Location__c=dealLocation.id;
insert waveplan;

idList.add(waveplan.id);
//To create a Recruitment tracking Plan record
      
RecruitmentTracking=new Recruitment_Tracking__c();
RecruitmentTracking.Name='TestRecruitmentData';
RecruitmentTracking.Activity__c='TestRecruitmentData';
RecruitmentTracking.Planned_Start_Date__c=date.today();
RecruitmentTracking.Planned_End_Date__c=date.today()+7;
RecruitmentTracking.Wave_Plan_lk__c=waveplan.id;
RecruitmentTracking.Deal_Location_lk__c=dealLocation.id;
RecruitmentTracking.FTE_Number__c=11;
//RecruitmentTracking.Activity_Master_ID__c= ActivMas.id;
insert RecruitmentTracking;

//To create a Tech Assessment Activity Master
TechAss= new Tech_Assessment_Activity_Master__c();
TechAss.Name='TestRecruitmentData';
TechAss.Activity_Order__c=1234;
insert TechAss;

//To create a KT Planning Activity Master
KTPAMas= new KT_Planning_Activity_Master__c();
KTPAMas.Name='TestRecruitmentData1';
KTPAMas.Activity_Order__c=1234;
insert KTPAMas;

//To create a Contract Legal Infosec record
      
kTPlan=new KT_Planning__c();

kTPlan.Activity__c='TestData';
kTPlan.Planned_Start_Date__c=date.today();
kTPlan.Planned_End_Date__c=date.today()+7;
kTPlan.Wave_Plan_lk__c=waveplan.id;
kTPlan.Deal_Location_lk__c=dealLocation.id;
kTPlan.activity__c ='TestRecruitmentData';
kTPlan.KT_Planning_Activity_Master_ID__c =KTPAMas.id;
insert kTPlan;



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



//To create a Service Phase Master
sermanmas= new Service_Management_Master__c ();
sermanmas.Phase_Name__c='TestRecruitmentData';
sermanmas.Phase_Number__c=86;
insert sermanmas;



//To create Service Task Master
servmanta= new Service_Management_Task_Master__c ();
servmanta.Task_Name__c='TestRecruitmentData';
servmanta.Task_Number__c=32;
servmanta.Service_Management_Phase__c=sermanmas.id;
insert servmanta;

//To create SRAT

srat=new SRAT__c();
srat.Has_KT_Lead_Submitted__c=true;
srat.Wave_Plan_Version__c=wavePlanVersion.id;
srat.name='Test Data';
srat.Planned_Date__c=date.today();
srat.Deal_Location_lk__c=dealLocation.id;
srat.Wave_Plan_lk__c=waveplan.id;
insert srat;
//To create an Opex record
opex =new OPEX__c();
opex.Deal_Location_lk__c=dealLocation.id;
opex.Wave_Plan_lk__c=waveplan.id;
opex.Item__c='Day 30 Assessment';
opex.Active__c=true;
opex.Planned_Date__c=date.today();
opex.Deal_Location__c='India';
opex.Wave_Plan_Version__c=wavePlanVersion.id;
insert opex; 
     
//To create a Contract Legal Infosec record
      
conLegInfo=new Contract_Legal_Infosec__c();
conLegInfo.Name='TestData';
conLegInfo.Activity__c='TestData';
conLegInfo.Planed_Start_Date__c=date.today();
conLegInfo.Planned_End_Date__c=date.today()+7;
conLegInfo.Wave_Plan_lk__c=waveplan.id;
conLegInfo.Deal_Location_lk__c=dealLocation.id;
insert conLegInfo;
}

static testMethod void test1(){
test.starttest();
    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData1();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,dealLocation.id);
WavePlanAdd_InlineController obj = new WavePlanAdd_InlineController( controller);
obj.addingnewWavePlan=[select id,name,NewActive__c from Wave_Planning__c];
//obj.initializeDetailRecords();
obj.addNewWavePlan();
obj.saveWavePlan();
obj.refreshWavePlanPage();
obj.checkRecordDeactivated();
 }
 test.stoptest();
 }
 static testMethod void test2(){
test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData2();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,dealLocation.id);
 
 WavePlanAdd_InlineController obj = new WavePlanAdd_InlineController( controller);
 //obj.initializeDetailRecords();
 obj.addNewWavePlan();
 //obj.saveWavePlan();
 //obj.refreshWavePlanPage();
 //obj.checkRecordDeactivated();
 }
 test.stoptest();
 }
 static testMethod void test21(){
test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData2();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,dealLocation.id);
 
 WavePlanAdd_InlineController obj = new WavePlanAdd_InlineController( controller);
 obj.refreshWavePlanPage();
 obj.checkRecordDeactivated();
 }
 test.stoptest();
 }
 static testMethod void test3(){
test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData2();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,dealLocation.id);
 
 WavePlanAdd_InlineController obj = new WavePlanAdd_InlineController( controller);
 //obj.initializeDetailRecords();
 obj.addNewWavePlan();
 //obj.saveWavePlan();
 //obj.refreshWavePlanPage();
 //obj.checkRecordDeactivated();
 }
 test.stoptest();
 }
 static testMethod void test4(){
test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData2();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,dealLocation.id);
 
 WavePlanAdd_InlineController obj = new WavePlanAdd_InlineController( controller);
 obj.newWavePlan.Wave_Label__c='TestData2';
 //obj.initializeDetailRecords();
 obj.addNewWavePlan();
 //obj.saveWavePlan();
 //obj.refreshWavePlanPage();
 //obj.checkRecordDeactivated();
 }
 test.stoptest();
 }
 static testMethod void test5(){
test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData2();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,dealLocation.id);
 
 WavePlanAdd_InlineController obj = new WavePlanAdd_InlineController( controller);
 obj.newWavePlan.GO_Live_Date_del__c =date.today();
 //obj.initializeDetailRecords();
 obj.addNewWavePlan();
 //obj.saveWavePlan();
 //obj.refreshWavePlanPage();
 //obj.checkRecordDeactivated();
 }
 test.stoptest();
 }
 
  static testMethod void test6(){
test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData2();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,dealLocation.id);
 
 WavePlanAdd_InlineController obj = new WavePlanAdd_InlineController( controller);
 obj.newWavePlan=waveplan;
 obj.newWavePlan.Wave_Label__c='testdata';
 obj.newWavePlan.GO_Live_Date_del__c =date.today()+7;
 //obj.initializeDetailRecords();
 obj.addNewWavePlan();
 //obj.saveWavePlan();
// obj.refreshWavePlanPage();
 //obj.checkRecordDeactivated();
 obj.d = date.valueOf('2013-12-21 01:01:01');
 //obj.checkweekendupdate();
 obj.checkweekendadd();
 }
 test.stoptest();
 }
 
 

 
 
   static testMethod void test7(){
test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData3();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,dealLocation.id);
 
 WavePlanAdd_InlineController obj = new WavePlanAdd_InlineController( controller);

 obj.addingnewWavePlan=[Select Wave_Label__c, GO_Live_Date_del__c, Wave_RAG_Status__c,Deal_Location__c, Wave_Completion_Status__c, Number_of_Projected_FTEs__c, Wave_Comment__c,Active__c,NewActive__c,Hyperlink__c from Wave_Planning__c where Deal_Location__c=:dealLocation.Id];
 obj.addingnewWavePlan[0].NewActive__c=false;
 //obj.deactivateHighLevelPlans(idList);
}
 test.stoptest();
 }
 
 }