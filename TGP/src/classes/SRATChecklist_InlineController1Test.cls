@isTest
private class SRATChecklist_InlineController1Test{


static SRAT__c srat;
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
static Factory_Specific_Technology__c delapp;
static Factory_Specific_Technology__c manageapp;
static User testUser;
static Task emailTask;
static SRAT_User_Section_Question__c userSection;
static SRAT_User_Sub_Section_Question__c userSubSection;

static SRATChecklist_InlineController1.MainQuestion mainQuestion;
static SRATChecklist_InlineController1.SubSection subSection;
static SRATChecklist_InlineController1.SubQuestion subQuestion;

static List<SRATChecklist_InlineController1.SubQuestion> lstSubQuestion;
static List<SRATChecklist_InlineController1.SubSection> lstSubSection;
static List<SRATChecklist_InlineController1.MainQuestion> lstMainQuestion;



public static void setupData(){

//To create SRAT Version

sratversion=new SRAT_Version__c();
sratversion.isActive__c=true;
insert sratversion;

// To Create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);


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
waveplan.Deal_Location__c = dealLoc.id;
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Number_of_Projected_FTEs__c=1;
insert waveplan;



//To create SRAT

srat=new SRAT__c();
srat.Has_KT_Lead_Submitted__c=true;
srat.Wave_Plan_Version__c=wavePlanVersion.id;
srat.SRAT_Version__c=sratversion.id;
srat.name='Test Data';
srat.Planned_Date__c=date.today();
srat.Deal_Location_lk__c=dealLoc.id;
srat.Wave_Plan_lk__c=waveplan.id;
insert srat;



sratsec=new SRAT_Section_Name__c();
sratsec.SRAT_Version__c=sratversion.id;
sratsec.SRAT_Section_Name__c='Manage Mobilization Program';
insert sratsec;
//To create SRAT Section Questionare

sratques=new SRAT_Section_Questionnaire__c();
sratques.SRAT_Section_Name__c=sratsec.id;
sratques.Question_Description__c='Ensure that the mobilization program is set up and managed using standard mobilization protocols; that mobilization scope and approach incorporate critical risks; that clear exit criteria are agreed with Delivery leadership; and the mobilization program is properly closed down.';
sratques.Sort_Order__c=4;
insert sratques;

sratsubsec=new SRAT_Sub_Section_Name__c();
sratsubsec.SRAT_Section_Name__c=sratsec.id;
sratsubsec.SRAT_Sub_Section_Name__c='3.1.0 Recruit and Induct';
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

delapp=new Factory_Specific_Technology__c();
delapp.Application_Name__c='test appln';
delapp.Application_Type__c='Service Delivery Applications';
delapp.SRAT__c=srat.id;
delapp.SRAT_Version__c=sratversion.id;
delapp.RAG_Status__c='Green';
insert delapp;

manageapp=new Factory_Specific_Technology__c();
manageapp.Application_Name__c='test appln2';
manageapp.Application_Type__c='Service Management Applications';
manageapp.SRAT__c=srat.id;
manageapp.SRAT_Version__c=sratversion.id;
manageapp.RAG_Status__c='Green';
insert manageapp;

emailTask= new Task();
emailTask.OwnerId = testUser.id;
emailTask.Subject = 'Approval Email Attachment on SRAT';
emailTask.Status = 'Not Started';
emailTask.Description = 'Please Attach Approval Email from Governance Lead for following SRAT';
insert emailTask;

srat.Deployment_Lead_Task_ID__c=emailTask.id;
//srat.Has_Deployment_Lead_Saved__c=true;
//srat.Has_Deployment_Lead_Submitted__c=true;
update srat;


// Record for User Section Question

userSection = new SRAT_User_Section_Question__c();
userSection.Question_Description__c =null;
userSection.RAG_Status__c= 'Green';
userSection.Category__c =null;
userSection.Default_RAG_Status__c ='Complete';
userSection.Measurement__c ='Measurmwent 1';
userSection.Overall_RAG_Status__c = 'A=Incomplete,On Track';
userSection.Active__c = true;
userSection.Comments__c = '';
userSection.Version__c =1;
userSection.IS_Factory_Engagement_Spc_Record__c= true;
insert userSection;

//Record for User Scetion Sub Question
userSubSection=new SRAT_User_Sub_Section_Question__c();
userSubSection.Active__c=true;
userSubSection.Category__c = null;
userSubSection.Comments__c = '';
userSubSection.IS_Factory_Engagement_Spc_Record__c =true;
userSubSection.Measurement__c = 'Measurment 1';
userSubSection.Question_Description__c =null;
userSubSection.RAG_Status__c ='G=Complete';
userSubSection.Title__c ='complete';
userSubSection.Version__c =1;
insert userSubSection;

//Record for SubQuestion
SubQuestion = new SRATChecklist_InlineController1.SubQuestion(userSubSection,'Green');
SubQuestion.subSecQuestion = userSubSection;
SubQuestion.RAGStatusColor = 'Green';
//SubQuestion.questionNo =1;
//insert SubQuestion;
lstSubQuestion = new List<SRATChecklist_InlineController1.SubQuestion>();
lstSubQuestion.add(SubQuestion);

// Record for Sub Section
subSection = new SRATChecklist_InlineController1.SubSection(sratsubsec,lstSubQuestion);
//subSection.subSection = sratsubsec;
//subSection.subQues = lstSubQuestion;
//insert subSection;
lstSubSection = new List<SRATChecklist_InlineController1.SubSection>();
lstSubSection.add(subSection);

//record for main question
mainQuestion = new SRATChecklist_InlineController1.MainQuestion(userSection,lstSubSection);
//mainQuestion.secQuestion = userSection.id;
//mainQuestion.subSec= lstSubSection;
//mainQuestion.color='Green';
//mainQuestion.RAGColor ='Green';
//insert mainQuestion;
lstMainQuestion = new List<SRATChecklist_InlineController1.MainQuestion>();
lstMainQuestion.add(mainQuestion);

}
public static void setupData1(){

// To Create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);


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
waveplan.Deal_Location__c = dealLoc.id;
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Number_of_Projected_FTEs__c=1;
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
insert srat;



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
bposratsubsec.SRAT_Sub_Section_Name__c='BPO Mobilization Controls';
insert bposratsubsec;

bposratsubques=new SRAT_Sub_Section_Questionnaire__c();
bposratsubques.SRAT_Sub_Section_Id__c=bposratsubsec.id;
bposratsubques.Question_Description__c='Mobilization approach and estimates are agreed and signed-off with Factory Global Mobilization Lead. Necessary exceptions to standard onboarding deliverables are confirmed.';
bposratsubques.Sort_Number__c=1;
insert bposratsubques;

delapp=new Factory_Specific_Technology__c();
delapp.Application_Name__c='test appln';
delapp.Application_Type__c='Service Delivery Applications';
delapp.SRAT__c=srat.id;
delapp.SRAT_Version__c=sratversion.id;
delapp.RAG_Status__c='Green';
insert delapp;

manageapp=new Factory_Specific_Technology__c();
manageapp.Application_Name__c='test appln2';
manageapp.Application_Type__c='Service Management Applications';
manageapp.SRAT__c=srat.id;
manageapp.SRAT_Version__c=sratversion.id;
manageapp.RAG_Status__c='Green';
insert manageapp;

emailTask= new Task();
emailTask.OwnerId = testUser.id;
emailTask.Subject = 'Approval Email Attachment on SRAT';
emailTask.Status = 'Not Started';
emailTask.Description = 'Please Attach Approval Email from Governance Lead for following SRAT';
insert emailTask;

srat.Deployment_Lead_Task_ID__c=emailTask.id;

update srat;



// Record for User Section Question

userSection = new SRAT_User_Section_Question__c();
userSection.Question_Description__c ='Question Description 1';
userSection.RAG_Status__c= ' ';
userSection.Category__c ='people';
userSection.Default_RAG_Status__c ='Complete';
userSection.Measurement__c ='Measurmwent 1';
userSection.Overall_RAG_Status__c = 'A=Incomplete, On Track';
userSection.Active__c = true;
userSection.Comments__c = 'Comment 1';
userSection.Version__c =1;
userSection.IS_Factory_Engagement_Spc_Record__c= true;
insert userSection;

//Record for User Scetion Sub Question
userSubSection=new SRAT_User_Sub_Section_Question__c();
userSubSection.Active__c=true;
userSubSection.Category__c = 'people';
userSubSection.Comments__c = 'Comment 1';
userSubSection.IS_Factory_Engagement_Spc_Record__c =true;
userSubSection.Measurement__c = 'Measurment 1';
userSubSection.Question_Description__c ='Description 1';
userSubSection.RAG_Status__c ='';
userSubSection.Title__c ='main question';
userSubSection.Version__c =1;
insert userSubSection;

//Record for SubQuestion
SubQuestion = new SRATChecklist_InlineController1.SubQuestion(userSubSection,'Green');
SubQuestion.subSecQuestion = userSubSection;
SubQuestion.RAGStatusColor = 'Green';

lstSubQuestion = new List<SRATChecklist_InlineController1.SubQuestion>();
lstSubQuestion.add(SubQuestion);

// Record for Sub Section
subSection = new SRATChecklist_InlineController1.SubSection(sratsubsec,lstSubQuestion);

lstSubSection = new List<SRATChecklist_InlineController1.SubSection>();
lstSubSection.add(subSection);

//record for main question
mainQuestion = new SRATChecklist_InlineController1.MainQuestion(userSection,lstSubSection);

lstMainQuestion = new List<SRATChecklist_InlineController1.MainQuestion>();
lstMainQuestion.add(mainQuestion);

}
public static void setupUserData1(){

userSection =new SRAT_User_Section_Question__c();
userSection.Title__c='Section Question Title';
userSection.SRAT_Version__c=sratversion.id;
userSection.SRAT_Section_Questionnaire__c=sratques.id;
userSection.SRAT__c=srat.id;
userSection.Overall_RAG_Status__c='A=Incomplete,On Track';
userSection.IS_Factory_Engagement_Spc_Record__c= true;
insert userSection;


userSubSection = new SRAT_User_Sub_Section_Question__c();
userSubSection.Title__c='main question';
userSubSection.SRAT_Version__c=sratversion.id;
userSubSection.SRAT_Sub_Section_Questionnaire__c=sratsubques.id;
userSubSection.SRAT__c=srat.id;
userSubSection.RAG_Status__c='A=Incomplete,On Track';
insert userSubSection;

}
public static void setupUserData2(){

userSection =new SRAT_User_Section_Question__c();
userSection.Title__c='Section Question Title';
userSection.SRAT_Version__c=sratversion.id;
userSection.SRAT_Section_Questionnaire__c=sratques.id;
userSection.SRAT__c=srat.id;
userSection.Overall_RAG_Status__c='R=Incomplete,Off Track';
userSection.IS_Factory_Engagement_Spc_Record__c= true;
insert userSection;


userSubSection = new SRAT_User_Sub_Section_Question__c();
userSubSection.Title__c='complete';
userSubSection.SRAT_Version__c=sratversion.id;
userSubSection.SRAT_Sub_Section_Questionnaire__c=sratsubques.id;
userSubSection.SRAT__c=srat.id;
userSubSection.RAG_Status__c='Not Applicable';
insert userSubSection;

}
static testMethod void test1(){
test.starttest();
 setupData();
 
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,srat.id);

SRATChecklist_InlineController1  obj = new SRATChecklist_InlineController1( controller);
 obj.isCalledFromSubmit=true;
 //obj.assignMessages();
 //obj.assignColors(String coloringField);
 //obj.mainQueries();
 obj.initializeSerDelApp();
 obj.initializeservManageApp();
 obj.servDelApp.Application_Name__c='testing';
 obj.servManageApp.Application_Name__c='testing2';
 obj.addservDelApp();
 obj.addmanageDelApp();
 obj.getQuestionnaire();
 obj.getBPOMobQuestionnaire();
 obj.getBusOpsQuestionnaire();
 obj.getDelCapQuestionnaire();
 obj.getClientChgQuestionnaire();
 obj.getOMReadinessSummaryQuestionnaire();
 //obj.getFacEngSpcQuestionnaire();
 obj.getServiceDelApp();
 obj.getServiceManageApp();
 //obj.setTabQuestionnaires(1);
 //obj.setBPOMobilization();  
 //obj.setAllValues();
 //obj.setFacEngSpecUserAnswers(lstMainQuestion);
 obj.getFacEngSpecTabQues();
 PageReference saveAccProfileDetails1= obj.saveSRATChecklist();
 PageReference saveAccProfileDetails2= obj.doCancelChecklist();
 PageReference saveAccProfileDetails3= obj.depLeadSubmitSRATChecklist();
 test.stoptest();
 
} 
static testMethod void test2(){
test.starttest();
setupData();
setupUserData2();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,srat.id);
 
 SRATChecklist_InlineController1  obj = new SRATChecklist_InlineController1( controller);
 //obj.assignMessages();
 //obj.assignColors(String coloringField);
 //obj.mainQueries();
 obj.getQuestionnaire();
 obj.getBPOMobQuestionnaire();
 obj.getBusOpsQuestionnaire();
 obj.getDelCapQuestionnaire();
 obj.getClientChgQuestionnaire();
 obj.getOMReadinessSummaryQuestionnaire();
 //obj.getFacEngSpcQuestionnaire();
 obj.getServiceDelApp();
 obj.getServiceManageApp();
 //obj.setTabQuestionnaires(1);
 //obj.setBPOMobilization();
 obj.initializeSerDelApp();
 obj.addservDelApp();
 obj.addmanageDelApp();
 //obj.setAllValues();
 obj.listOfServiceDelApp[0].Application_Name__c='';
 obj.listOfServiceManageApp[0].Application_Name__c='';
 PageReference saveAccProfileDetails1= obj.saveSRATChecklist();
 PageReference saveAccProfileDetails2= obj.doCancelChecklist();
 PageReference saveAccProfileDetails3= obj.depLeadSubmitSRATChecklist();
 test.stoptest();
    
 } 
 static testMethod void test3(){
test.starttest();
setupData();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,srat.id);
 
 SRATChecklist_InlineController1  obj = new SRATChecklist_InlineController1( controller);
 //obj.assignMessages();
 //obj.assignColors(String coloringField);
 //obj.mainQueries();
 obj.getQuestionnaire();
 obj.getBPOMobQuestionnaire();
 obj.getBusOpsQuestionnaire();
 obj.getDelCapQuestionnaire();
 obj.getClientChgQuestionnaire();
 obj.getOMReadinessSummaryQuestionnaire();
 //obj.getFacEngSpcQuestionnaire();
 obj.getServiceDelApp();
 obj.getServiceManageApp();
 //obj.setTabQuestionnaires(1);
 //obj.setBPOMobilization();
 obj.initializeSerDelApp();
 obj.addservDelApp();
 obj.addmanageDelApp();
 //obj.setAllValues();
 obj.listOfServiceManageApp[0].Application_Name__c='';
 PageReference saveAccProfileDetails1= obj.saveSRATChecklist();
 PageReference saveAccProfileDetails2= obj.doCancelChecklist();
 PageReference saveAccProfileDetails3= obj.depLeadSubmitSRATChecklist();
 test.stoptest();
    
 } 
 static testMethod void test4(){
test.starttest();
setupData1();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,null);
 
 SRATChecklist_InlineController1  obj = new SRATChecklist_InlineController1( controller);
 //obj.assignMessages();
 //obj.assignColors(String coloringField);
 //obj.mainQueries();
 obj.getQuestionnaire();
 obj.getBPOMobQuestionnaire();
 obj.getBusOpsQuestionnaire();
 obj.getDelCapQuestionnaire();
 obj.getClientChgQuestionnaire();
 obj.getOMReadinessSummaryQuestionnaire();
 //obj.getFacEngSpcQuestionnaire();
 obj.getServiceDelApp();
 obj.getServiceManageApp();
 //obj.setTabQuestionnaires(1);
 //obj.setBPOMobilization();
 obj.initializeSerDelApp();
 //obj.addservDelApp();
 //obj.addmanageDelApp();
 //obj.setAllValues();

 //obj.doCancelChecklist();

 //obj.setFacEngSpecUserAnswers(lstMainQuestion);
 obj.setFacEngSpecTabQues();
 // PageReference saveAccProfileDetails1= obj.saveSRATChecklist();
  // PageReference saveAccProfileDetails3= obj.depLeadSubmitSRATChecklist();
 test.stoptest();
    
 }
 static testMethod void test5(){
test.starttest();
 setupData1();
 setupUserData1();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,srat.id);

SRATChecklist_InlineController1  obj = new SRATChecklist_InlineController1( controller);
 
 String coloringField = 'Not Applicable';
 
 obj.assignMessages();
 obj.assignColors(coloringField);
 obj.mainQueries();
 obj.initializeSerDelApp();
 obj.initializeservManageApp();
 obj.servDelApp.Application_Name__c='testing';
 obj.servManageApp.Application_Name__c='testing2';
 obj.addservDelApp();
 obj.addmanageDelApp();
 obj.getQuestionnaire();
 obj.getBPOMobQuestionnaire();
 obj.getBusOpsQuestionnaire();
 obj.getDelCapQuestionnaire();
 obj.getClientChgQuestionnaire();
 obj.getOMReadinessSummaryQuestionnaire();
 //obj.getFacEngSpcQuestionnaire();
 obj.getServiceDelApp();
 obj.getServiceManageApp();
 //obj.setTabQuestionnaires(1);
 //obj.setBPOMobilization(); 
 //obj.setFacEngSpecUserAnswers(lstMainQuestion);
 List<SRAT_User_Sub_Section_Question__c> userSubSecExistList1 = new List<SRAT_User_Sub_Section_Question__c>();
 SRAT_User_Sub_Section_Question__c sRatUsrSubSecQ = new SRAT_User_Sub_Section_Question__c();
 sRatUsrSubSecQ.IS_Factory_Engagement_Spc_Record__c=true;
 userSubSecExistList1.add(sRatUsrSubSecQ);
 obj.userSubSecExistList = userSubSecExistList1;
obj.setFacEngSpecTabQues(); 

 //obj.setAllValues();
 PageReference saveAccProfileDetails1= obj.saveSRATChecklist();
 PageReference saveAccProfileDetails2= obj.doCancelChecklist();
 PageReference saveAccProfileDetails3= obj.depLeadSubmitSRATChecklist();
 test.stoptest();
 
} 
 }