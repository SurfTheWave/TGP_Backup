@isTest
private class SRATChecklist_ReadOnlyInlineTest{


static SRAT__c srat;
static SRAT__c srat1;
static Wave_Plan_Version__c wavePlanVersion;
static Deal_TGP__c deal;
static SRAT_VERSION__c sratversion;
static Wave_Planning__c waveplan;
static Deal_Location__c dealLoc;
static Client_Geo_Area_Master__c clientGeo ;
static Delievery_Location_Master__c deliveryLocMa ;
static Deal_Home_Location__c dealHome ;
static SRAT_Section_Name__c sratsec;
static SRAT_Section_Questionnaire__c sratques;
static SRAT_Sub_Section_Name__c sratsubsec;
static SRAT_Sub_Section_Questionnaire__c sratsubques;

static SRAT_Section_Name__c bposratsec;
static SRAT_Section_Questionnaire__c bposratques;
static SRAT_Sub_Section_Name__c bposratsubsec;
static SRAT_Sub_Section_Questionnaire__c bposratsubques;
static SRAT_User_Section_Question__c sratUser;
static SRAT_User_Sub_Section_Question__c sratSubUser;
static SRAT_User_Sub_Section_Question__c sratSubUser1;

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


clientGeo = new Client_Geo_Area_Master__c();
clientGeo.Client_Geo_Area_Description__c='TestData';
insert clientGeo;

// To create a Delivery Location Master
deliveryLocMa =new Delievery_Location_Master__c();
deliveryLocMa.Delivery_Location_Description__c='testdata';
deliveryLocMa.Name='TestData';
deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
insert deliveryLocMa;



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

//To create a Wave Plan
waveplan =new Wave_Planning__c();
waveplan.Wave_Label__c='TestData';
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Number_of_Projected_FTEs__c=1;
waveplan.Deal_Location__c = dealLoc.id;
insert waveplan;

//To create SRAT Version

sratversion=new SRAT_Version__c();
sratversion.isActive__c=true;
insert sratversion;

//To create SRAT

srat=new SRAT__c();
srat.Has_KT_Lead_Submitted__c=true;
srat.Wave_Plan_Version__c=wavePlanVersion.id;
srat.SRAT_Version__c=sratversion.id;
srat.name='Test Data';
srat.Planned_Date__c=date.today();
srat.Deal_Location_lk__c=dealLoc.id;
srat.Wave_Plan_lk__c=waveplan.id;
srat.Days_Before_Go_Live_Date__c = 3;
insert srat;

srat1=new SRAT__c();
srat1.Has_KT_Lead_Submitted__c=true;
srat1.Wave_Plan_Version__c=wavePlanVersion.id;
srat1.name='Test Data';
srat1.Planned_Date__c=date.today();
srat1.Deal_Location_lk__c=dealLoc.id;
srat1.Wave_Plan_lk__c=waveplan.id;
srat1.Days_Before_Go_Live_Date__c = 1;
insert srat1;

 sratSubUser= new SRAT_User_Sub_Section_Question__c();
 sratSubUser.SRAT__c = srat.id;
  sratSubUser.Reference__c = 'test';
 insert sratSubUser;
 
 
 sratSubUser1= new SRAT_User_Sub_Section_Question__c();
 sratSubUser1.SRAT__c = srat1.id;
 sratSubUser1.Title__c = 'test';
 sratSubUser1.Reference__c = 'test';
 insert sratSubUser1;

sratsec=new SRAT_Section_Name__c();
sratsec.SRAT_Version__c=sratversion.id;
sratsec.SRAT_Section_Name__c='Manage Mobilization Program';
insert sratsec;
//To create SRAT Section Questionare

sratques=new SRAT_Section_Questionnaire__c();
sratques.SRAT_Section_Name__c=sratsec.id;
sratques.Question_Description__c='Ensure that the mobilization program is set up and managed using standard mobilization protocols; that mobilization scope and approach incorporate critical risks; that clear exit criteria are agreed with Delivery leadership; and the mobilization program is properly closed down.';
sratques.Sort_Order__c=1;
insert sratques;

sratsubsec=new SRAT_Sub_Section_Name__c();
sratsubsec.SRAT_Section_Name__c=sratsec.id;
sratsubsec.SRAT_Sub_Section_Name__c='1.0 Manage Mobilization Program';
insert sratsubsec;

sratsubques=new SRAT_Sub_Section_Questionnaire__c();
sratsubques.SRAT_Sub_Section_Id__c=sratsubsec.id;
sratsubques.Question_Description__c='Mobilization approach and estimates are agreed and signed-off with Factory Global Mobilization Lead. Necessary exceptions to standard onboarding deliverables are confirmed.';
sratsubques.Sort_Number__c=1;
insert sratsubques;


bposratsec=new SRAT_Section_Name__c();
bposratsec.SRAT_Version__c=sratversion.id;
bposratsec.SRAT_Section_Name__c='BPO Mobilization Controls';
insert bposratsec;
//To create SRAT Section Questionare


bposratsubsec=new SRAT_Sub_Section_Name__c();
bposratsubsec.SRAT_Section_Name__c=bposratsec.id;
bposratsubsec.SRAT_Sub_Section_Name__c='OM Readiness Summary';
insert bposratsubsec;

bposratsubques=new SRAT_Sub_Section_Questionnaire__c();
bposratsubques.SRAT_Sub_Section_Id__c=bposratsubsec.id;
bposratsubques.Question_Description__c='Mobilization approach and estimates are agreed and signed-off with Factory Global Mobilization Lead. Necessary exceptions to standard onboarding deliverables are confirmed.';
bposratsubques.Sort_Number__c=1;
insert bposratsubques;

sratUser= new SRAT_User_Section_Question__c ();
}

public static void setupData1(){

// To create a Deal
deal =new Deal_TGP__c();
deal.Name='Test Data';
insert deal;


//To create a Wave Plan Version
wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Display_tracking_message__c='Test Data';
wavePlanVersion.Deal__c=deal.id;
insert wavePlanVersion;


clientGeo = new Client_Geo_Area_Master__c();
clientGeo.Client_Geo_Area_Description__c='TestData';
insert clientGeo;

// To create a Delivery Location Master
deliveryLocMa =new Delievery_Location_Master__c();
deliveryLocMa.Delivery_Location_Description__c='testdata';
deliveryLocMa.Name='TestData';
deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
insert deliveryLocMa;



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

//To create a Wave Plan
waveplan =new Wave_Planning__c();
waveplan.Wave_Label__c='TestData';
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Number_of_Projected_FTEs__c=1;
waveplan.Deal_Location__c = dealLoc.id;
insert waveplan;

//To create SRAT Version

sratversion=new SRAT_Version__c();
sratversion.isActive__c=true;
insert sratversion;

//To create SRAT

srat=new SRAT__c();
srat.Has_KT_Lead_Submitted__c=true;
srat.Wave_Plan_Version__c=wavePlanVersion.id;
srat.name='Test Data';
srat.Planned_Date__c=date.today();
srat.Deal_Location_lk__c=dealLoc.id;
srat.Wave_Plan_lk__c=waveplan.id;
insert srat;



}

static testMethod void test1(){
test.starttest();
 setupData();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,srat.id);

 SRATChecklist_ReadOnlyInlineController  obj = new SRATChecklist_ReadOnlyInlineController( controller);

 SRATChecklist_ReadOnlyInlineController.SubQuestion objSubQues=new SRATChecklist_ReadOnlyInlineController.SubQuestion(sratSubUser,'red',10);
 List<SRATChecklist_ReadOnlyInlineController.SubQuestion> listSubQues=new List<SRATChecklist_ReadOnlyInlineController.SubQuestion>();
 listSubQues.add(objSubQues);
 SRATChecklist_ReadOnlyInlineController.SubSection objSub=new SRATChecklist_ReadOnlyInlineController.SubSection(sratsubsec,listSubQues);
 List<SRATChecklist_ReadOnlyInlineController.SubSection> listSubSec=new List<SRATChecklist_ReadOnlyInlineController.SubSection>();
 listSubSec.add(objSub);
 SRATChecklist_ReadOnlyInlineController.MainQuestion obj1=new SRATChecklist_ReadOnlyInlineController.MainQuestion(sratUser,listSubSec);
 obj.getQuestionnaire();
 obj.getBPOMobQuestionnaire();
 obj.getBusOpsQuestionnaire();
 obj.getDelCapQuestionnaire();
 obj.getClientChgQuestionnaire();
 obj.getFacEngSpcQuestionnaire();
 obj.getOMReadinessSummaryQuestionnaire();
 obj.getServiceDelApp();
 obj.getServiceManageApp();
 List<SRATChecklist_ReadOnlyInlineController.MainQuestion> lst1=obj.setFacEngSpecTabQues();
 List<SRATChecklist_ReadOnlyInlineController.MainQuestion> lst2=obj.getFacEngSpecTabQues();
 Factory_Specific_Technology__c objFac=new Factory_Specific_Technology__c ();
 SRATChecklist_ReadOnlyInlineController.FactorySpecTech objFac1= new SRATChecklist_ReadOnlyInlineController.FactorySpecTech(objFac,'red');
 obj.callisRAIDAccessible();
 
 SRATChecklist_ReadOnlyInlineController.PreviousSubSec obj5 =new SRATChecklist_ReadOnlyInlineController.PreviousSubSec(sratSubUser,true,'test','green');
 
 
 
 test.stoptest();
 
} 
static testMethod void test2()
{
    test.starttest();
    setupData();
    ApexPages.StandardController controller;
    
    apexpages.currentpage().getparameters().put('Id' ,null);
     
     SRATChecklist_ReadOnlyInlineController  obj = new SRATChecklist_ReadOnlyInlineController( controller);
     //obj.assignMessages();
     //obj.assignColors(String coloringField);
     //obj.mainQueries();
     obj.getQuestionnaire();
     obj.getBPOMobQuestionnaire();
     obj.getBusOpsQuestionnaire();
     obj.getDelCapQuestionnaire();
     obj.getClientChgQuestionnaire();
     obj.getFacEngSpcQuestionnaire();
     obj.getOMReadinessSummaryQuestionnaire();
     obj.getServiceDelApp();
     obj.getServiceManageApp();
     test.stoptest();
 } 
 
 


}