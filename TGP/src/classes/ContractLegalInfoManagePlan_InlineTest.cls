/*
Author : Malkeet Singh

Description : Test Class for JourneyPlan. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class ContractLegalInfoManagePlan_InlineTest{
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
static Contract_Legal_Infosec__c strTechAssessment;
static Opportunity_TGP__c oppTGP;
static Journey_Management_Planning__c jmplan;
static Contract_Legal_Infosec_Section_Master__c joumg;
static Contract_Legal_Infosec_Task_Master__c joumgde;
static Journey_Management__c jManagaement;
static Journey_Management_Planning__c  jManagaementPlanning;
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

// To Create Client Specific Process Mapping

clientSpecificProcessMapping = new Client_Specific_Process_Mapping__c();
clientSpecificProcessMapping.Name='TestData';
clientSpecificProcessMapping.Deal__c=deal.id;
clientSpecificProcessMapping.Offering__c=offering.id;
insert clientSpecificProcessMapping;

//To create a Wave Plan

waveplan =new Wave_Planning__c();
waveplan.Wave_Comment__c='test data';
waveplan.Wave_Label__c='TestData';
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Deal_Location__c=dealLoc.id;
waveplan.Number_of_Projected_FTEs__c=1;
insert waveplan; 

// To create a Wave Process

WaveProcess =new Wave_Process__c();
WaveProcess.Wave_Planning__c=waveplan.id;
WaveProcess.Number_of_Projected_FTEs__c=5;
WaveProcess.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
insert WaveProcess;





//To create a Contract_Legal_Infosec_Section_Master__c
      
joumg=new Contract_Legal_Infosec_Section_Master__c();
joumg.Section_Name__c='TestData';
joumg.Section_Number__c='5555';
insert joumg;
List<Contract_Legal_Infosec_Section_Master__c>  smList=[Select name ,id from Contract_Legal_Infosec_Section_Master__c where id=:joumg.id];
 upsert smList[0];
//To create a Contract_Legal_Infosec_Task_Master__c
      
joumgde=new Contract_Legal_Infosec_Task_Master__c();
joumgde.Task_Name__c='Name';
joumgde.Task_Number__c='555555';
joumgde.Contract_Legal_Infosec_Section_Master__c=joumg.id;
insert joumgde;



   

// To create a tech assessment plan
       strTechAssessment=new Contract_Legal_Infosec__c(Name='TestKT', Planed_Start_Date__c=System.today()+1, Planned_End_Date__c=System.today()+2, 
        Deal_Location_lk__c=dealLoc.id, Wave_Plan_lk__c=waveplan.id,Active__c=true, Activity__c='TestActivity', Wave_Plan_Version__c=WavePlanVersion.id);
        insert strTechAssessment;

     List<Contract_Legal_Infosec__c>  ClfList=[Select name ,id from Contract_Legal_Infosec__c where id=:strTechAssessment.id];
     
     upsert ClfList[0];
sc = new ApexPages.StandardController(wavePlanVersion);

}


static testMethod void test1(){
test.starttest();
setupData();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.id);
 
 ContractLegalInfoManagementPlan_Inline obj = new ContractLegalInfoManagementPlan_Inline(sc);
 obj.initializeDetailRecords();
 //obj.saveJourneyPlan();
 obj.getSectionNames();
 obj.checkRecordDeactivated();
 test.stoptest();
    
 }  
 
 static testMethod void test2(){
test.starttest();
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('ProcessId' ,strTechAssessment.id);

 
 ContractLegalInfoManagementPlan_Inline obj = new ContractLegalInfoManagementPlan_Inline(sc);
 obj.journeyManagementPlan.Active__c=true;
 obj.initializeDetailRecords();
 //obj.saveJourneyPlan();
 obj.getSectionNames();
 obj.journeyManagementPlan.Active__c=true;
 obj.checkRecordDeactivated();
// obj.saveJourneyPlan();
 test.stoptest();
    
 } 
  static testMethod void test3(){
test.starttest();
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('ProcessId' ,null);

 
 ContractLegalInfoManagementPlan_Inline obj = new ContractLegalInfoManagementPlan_Inline(sc);
 obj.journeyManagementPlan.Active__c=true;
 obj.initializeDetailRecords();
 //obj.saveJourneyPlan();
 obj.getSectionNames();
 obj.checkRecordDeactivated();
 test.stoptest();
    
 } 
 
   static testMethod void test4(){
test.starttest();
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('ProcessId' ,null);
 
 ContractLegalInfoManagementPlan_Inline obj = new ContractLegalInfoManagementPlan_Inline(sc);
  List<SelectOption> secNameList = obj.getSectionNames();
  obj.strSectionName=secNameList[0].getValue();
 obj.journeyManagementPlan.Active__c=true;
 obj.journeyManagementPlan.Task_Name__c='test';
 obj.journeyManagementPlan.Planed_Start_Date__c=date.today()+1;
 obj.journeyManagementPlan.Planned_End_Date__c=date.today()+7;
 obj.journeyManagementPlan.Resource_Name__c='Test';
 obj.journeyManagementPlan.comments__c='Test comment';
 obj.journeyManagementPlan.Section_Master_ID__c='test';
 obj.saveJourneyPlan();
//obj.save();
 test.stoptest();
    
 } 
 
 

   static testMethod void test5(){
test.starttest();
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('ProcessId' ,null);
List<Contract_Legal_Infosec__c>  newListna=[Select name ,id from Contract_Legal_Infosec__c where id=:strTechAssessment.id];
List<Contract_Legal_Infosec__c>  oldListoa=[Select name ,id from Contract_Legal_Infosec__c where id=:strTechAssessment.id];


List<Contract_Legal_Infosec_Section_Master__c>  newListbn=[Select name ,id,Section_Name__c,Section_Number__c from Contract_Legal_Infosec_Section_Master__c where id=:joumg.id];
List<Contract_Legal_Infosec_Section_Master__c>  oldListbo=[Select name ,id,Section_Name__c,Section_Number__c  from Contract_Legal_Infosec_Section_Master__c where id=:joumg.id];

List<Contract_Legal_Infosec_Task_Master__c>  newListcn=[Select name ,id,Task_Name__c,Task_Number__c,Contract_Legal_Infosec_Section_Master__c  from Contract_Legal_Infosec_Task_Master__c where id=:joumgde.id];
List<Contract_Legal_Infosec_Task_Master__c>  oldListco=[Select name ,id,Task_Name__c,Task_Number__c,Contract_Legal_Infosec_Section_Master__c from Contract_Legal_Infosec_Task_Master__c where id=:joumgde.id];

List<Contract_Legal_Infosec_Section_Master__c>  newListbn2=new List<Contract_Legal_Infosec_Section_Master__c> ();
List<Contract_Legal_Infosec_Task_Master__c>  newListcn2 =new List<Contract_Legal_Infosec_Task_Master__c> ();

for(Contract_Legal_Infosec_Section_Master__c ac :newListbn )
{
ac.Section_Name__c='testing123';
newListbn2.add(ac);
}
upsert newListbn2;
for(Contract_Legal_Infosec_Task_Master__c bc :newListcn )
{
bc.Task_Name__c='testing123';
newListcn2.add(bc);
}
upsert newListcn2;

 Mob_CascadeContractLegalMasterChanges.CascadeJourneyMasterChangesOnUpdate(oldListbo,newListbn2);
 Mob_CascadeContractLegalMasterChanges.CascadeTaskMasterChangesOnInsert(newListcn);
 Mob_CascadeContractLegalMasterChanges.CascadeJourneyMasterChangesOnDelete(oldListbo);
 Mob_CascadeContractLegalMasterChanges.CascadeJourneyTaskChangesOnUpdate(oldListco,newListcn2);
 Mob_CascadeContractLegalMasterChanges.CascadeJourneyTaskChangesOnDelete(oldListco);

 test.stoptest();
    
 } 
 
  static testMethod void test6(){
test.starttest();
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('ProcessId' ,wavePlanVersion.id);
apexpages.currentpage().getparameters().put('ProcessId' ,strTechAssessment.id);
 
 ContractLegalInfoManagementPlan_Inline obj = new ContractLegalInfoManagementPlan_Inline(sc);
 // obj.strSectionName='test';
 obj.journeyManagementPlan.Active__c=true;
 obj.journeyManagementPlan.Task_Name__c='test';
 obj.journeyManagementPlan.Planed_Start_Date__c=date.today()+1;
 obj.journeyManagementPlan.Planned_End_Date__c=date.today()+7;
 obj.journeyManagementPlan.Resource_Name__c='Test';
 obj.journeyManagementPlan.comments__c='Test comment';
 //obj.journeyManagementPlan.Section_Master_ID__c='test';
 //obj.saveJourneyPlan();
obj.save();
obj.edit();
obj.cancel();
 test.stoptest();
    
 }
 
/*static testMethod void test6()
{
test.starttest();
setupData();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('ProcessId' ,null);
 ContractLegalInfoManagementPlan_Inline obj = new ContractLegalInfoManagementPlan_Inline(sc);
 obj.strSectionName='test';
 
 obj.journeyManagementPlan.Task_Name__c='test';
 obj.journeyManagementPlan.Active__c=true;
 obj.journeyManagementPlan.Task_Name__c='test';
 obj.journeyManagementPlan.Planed_Start_Date__c=date.today()+1;
 obj.journeyManagementPlan.Planned_End_Date__c=date.today()+7;
 obj.journeyManagementPlan.Resource_Name__c='Test';
 obj.saveJourneyPlan();

 test.stoptest();    
 }*/ 
 
 
}