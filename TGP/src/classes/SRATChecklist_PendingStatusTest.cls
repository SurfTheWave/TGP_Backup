@isTest(SeeAlldata= true)
private class SRATChecklist_PendingStatusTest{


static SRAT__c srat;
static Wave_Plan_Version__c wavePlanVersion;
static Deal_TGP__c deal;



public static void setupData(){

// To create a Deal
deal =new Deal_TGP__c();
deal.Name='Test Data';
insert deal;


//To create a Wave Plan Version
wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Display_tracking_message__c='Test Data';
wavePlanVersion.Deal__c=deal.id;
insert wavePlanVersion;
//To create SRAT

srat=new SRAT__c();
srat.Has_KT_Lead_Submitted__c=true;
srat.Wave_Plan_Version__c=wavePlanVersion.id;



}

static testMethod void test1(){
test.starttest();
setupData();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.id);
 
 SRATChecklist_PendingStatusController obj = new SRATChecklist_PendingStatusController( controller);
 
 
 test.stoptest();
    
 }  
 static testMethod void test2(){
test.starttest();
setupData();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,null);
 
 SRATChecklist_PendingStatusController obj = new SRATChecklist_PendingStatusController( controller);
 
 
 test.stoptest();
    
 }  


}