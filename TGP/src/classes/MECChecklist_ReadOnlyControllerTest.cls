/*
Author : Malkeet Singh
Story  :   
Description : Test Class for MECChecklist_InlineController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class MECChecklist_ReadOnlyControllerTest{
static Deal_TGP__c deal;
static Opportunity_TGP__c oppTGP;
static User testUser; 
static User testUser1; 
static User testUser2; 
static Operating_Group_Master__c operatingGroup;
static Client_Master__c clientName;
static Client_Geo_Area_Master__c clientGeoArea;
static Client_Geo_Unit_Master__c clientGeoUnit;
static MEC_Post_Contract_Version__c  mec;
static MEC_Post_Contract_Questionnaire_Master__c mcq;
static MEC_Post_Contract_End_User__c mpc;
static MEC_Post_Contract_End_User_Questionnaire__c mpceu;
static MOB_User_Role_Assignment__c mobUserAssign;

static Review_User_Master__c testUserMaster;
static Review_User_Master__c testUserMaster1;
static Review_User_Master__c testUserMaster2; 


public static void setupData(){




///To create a MEC_Post_Contract_Version__c

 mec = new MEC_Post_Contract_Version__c ();

 mec.Version_Name__c= 'test';
 mec.Active__c = true;
 insert mec;
 
 //////To create a MEC_Post_Contract_Questionnaire_Master__c
 mcq= new MEC_Post_Contract_Questionnaire_Master__c();
 mcq.MEC_Post_Contract_Version__c=mec.id;
 mcq.Category_Name__c='test';
 mcq.Criteria__c='test';
 mcq.Is_Mandatory__c=false;
 insert mcq;
 
 
///To create a client Geo Unit

 clientGeoUnit = new Client_Geo_Unit_Master__c ();
 clientGeoUnit.Name = 'TestLATAM';
 clientGeoUnit.Active__c = true;
 insert clientGeoUnit;

 /// To insert Operating Group Master
 
operatingGroup = new Operating_Group_Master__c ();
operatingGroup.Name = 'TestHSMPS';
operatingGroup.Active__c = true;
insert operatingGroup;
///To create a Client Geo Area
clientGeoArea = new Client_Geo_Area_Master__c ();
clientGeoArea.Name = 'TestAPAC';
clientGeoArea.Active__c = true;
 insert clientGeoArea;
/// To create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
      
      
/// To create a Client

clientName = new Client_Master__c ();
clientName.Name = 'TestObject1';
clientName.Active__c = true;
insert clientName;
      /// To create an Opportunity

oppTGP = new Opportunity_TGP__c();
oppTGP.Name = 'TestIBM';
oppTGP.Stage__c='Stage 1';
oppTGP.Client_Name__c= clientName.id ;
oppTGP.Client_Geo_Area__c=clientGeoArea.id;
oppTGP.Operating_Group__c=operatingGroup.id;
oppTGP.Enterprise_Solution_Architect__c=testuser.id;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';
insert oppTGP;
///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Opportunity_ID__c=oppTGP.id;
//deal.Governance_Lead_Name__c=UserInfo.getUserId();
deal.Has_Gov_Lead_Submitted__c=false;
//deal.Governance_Lead_Name_Secondary__c=UserInfo.getUserId();
deal.Has_Mob_Architect_Saved__c=false;
deal.Has_Mob_Architect_Submitted__c=false;
insert deal;
// To create a MEC Post Contract End User
 
 mpc= new MEC_Post_Contract_End_User__c();
 mpc.Version_Number__c=mec.id;
 mpc.Entry_Criteria_for_Project_Execution__c='test';
 mpc.Deal__c=deal.id;
 insert mpc;
 
// To create a MEC Post Contract End User Questionnare
mpceu= new MEC_Post_Contract_End_User_Questionnaire__c();
mpceu.Satisfaction_Rating__c='Satisfied';
mpceu.Deal__c=deal.id;
mpceu.Version_Number__c=mec.id;
mpceu.Is_Mandatory__c=true;
insert mpceu;

}
public static void setupData1(){
///To create a MEC_Post_Contract_Version__c

 mec = new MEC_Post_Contract_Version__c ();

 mec.Version_Name__c= 'test';
 mec.Active__c = true;
 insert mec;
 
 //////To create a MEC_Post_Contract_Questionnaire_Master__c
 mcq= new MEC_Post_Contract_Questionnaire_Master__c();
 mcq.MEC_Post_Contract_Version__c=mec.id;
 mcq.Category_Name__c='test';
 mcq.Criteria__c='test';
 mcq.Is_Mandatory__c=false;
 insert mcq;
 
 
///To create a client Geo Unit

 clientGeoUnit = new Client_Geo_Unit_Master__c ();
 clientGeoUnit.Name = 'TestLATAM';
 clientGeoUnit.Active__c = true;
 insert clientGeoUnit;

 /// To insert Operating Group Master
 
operatingGroup = new Operating_Group_Master__c ();
operatingGroup.Name = 'TestHSMPS';
operatingGroup.Active__c = true;
insert operatingGroup;
///To create a Client Geo Area
clientGeoArea = new Client_Geo_Area_Master__c ();
clientGeoArea.Name = 'TestAPAC';
clientGeoArea.Active__c = true;
 insert clientGeoArea;
/// To create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
      
      
/// To create a Client

clientName = new Client_Master__c ();
clientName.Name = 'TestObject1';
clientName.Active__c = true;
insert clientName;
      /// To create an Opportunity

oppTGP = new Opportunity_TGP__c();
oppTGP.Name = 'TestIBM';
oppTGP.Stage__c='Stage 1';
oppTGP.Client_Name__c= clientName.id ;
oppTGP.Client_Geo_Area__c=clientGeoArea.id;
oppTGP.Operating_Group__c=operatingGroup.id;
oppTGP.Enterprise_Solution_Architect__c=testuser.id;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';
insert oppTGP;
///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Opportunity_ID__c=null;
//deal.Governance_Lead_Name__c=UserInfo.getUserId();
deal.Has_Gov_Lead_Submitted__c=false;
//deal.Governance_Lead_Name_Secondary__c=UserInfo.getUserId();
deal.Has_Mob_Architect_Saved__c=true;
deal.Has_Mob_Architect_Submitted__c=false;

insert deal;
// To create a MEC Post Contract End User
 
 mpc= new MEC_Post_Contract_End_User__c();
 mpc.Version_Number__c=mec.id;
 mpc.Entry_Criteria_for_Project_Execution__c='test';
 mpc.Deal__c=deal.id;
 insert mpc;
 
// To create a MEC Post Contract End User Questionnare
mpceu= new MEC_Post_Contract_End_User_Questionnaire__c();
mpceu.Satisfaction_Rating__c='Satisfied';
mpceu.Deal__c=deal.id;
mpceu.Version_Number__c=mec.id;
mpceu.Is_Mandatory__c=true;
insert mpceu;

}
public static void setupData2(){
///To create a MEC_Post_Contract_Version__c

 mec = new MEC_Post_Contract_Version__c ();

 mec.Version_Name__c= 'test';
 mec.Active__c = true;
 insert mec;
 
 //////To create a MEC_Post_Contract_Questionnaire_Master__c
 mcq= new MEC_Post_Contract_Questionnaire_Master__c();
 mcq.MEC_Post_Contract_Version__c=mec.id;
 mcq.Category_Name__c='test';
 mcq.Criteria__c='test';
 mcq.Is_Mandatory__c=false;
 insert mcq;
 
 
///To create a client Geo Unit

 clientGeoUnit = new Client_Geo_Unit_Master__c ();
 clientGeoUnit.Name = 'TestLATAM';
 clientGeoUnit.Active__c = true;
 insert clientGeoUnit;

 /// To insert Operating Group Master
 
operatingGroup = new Operating_Group_Master__c ();
operatingGroup.Name = 'TestHSMPS';
operatingGroup.Active__c = true;
insert operatingGroup;
///To create a Client Geo Area
clientGeoArea = new Client_Geo_Area_Master__c ();
clientGeoArea.Name = 'TestAPAC';
clientGeoArea.Active__c = true;
 insert clientGeoArea;
/// To create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
      
      
/// To create a Client

clientName = new Client_Master__c ();
clientName.Name = 'TestObject1';
clientName.Active__c = true;
insert clientName;
      /// To create an Opportunity

oppTGP = new Opportunity_TGP__c();
oppTGP.Name = 'TestIBM';
oppTGP.Stage__c='Stage 1';
oppTGP.Client_Name__c= clientName.id ;
oppTGP.Client_Geo_Area__c=clientGeoArea.id;
oppTGP.Operating_Group__c=operatingGroup.id;
oppTGP.Enterprise_Solution_Architect__c=testuser.id;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';
insert oppTGP;
///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Opportunity_ID__c=null;
//deal.Governance_Lead_Name__c=UserInfo.getUserId();
deal.Has_Gov_Lead_Submitted__c=false;
//deal.Governance_Lead_Name_Secondary__c=UserInfo.getUserId();
deal.Has_Mob_Architect_Saved__c=true;
deal.Has_Mob_Architect_Submitted__c=true;

insert deal;
// To create a MEC Post Contract End User
 
 mpc= new MEC_Post_Contract_End_User__c();
 mpc.Version_Number__c=mec.id;
 mpc.Entry_Criteria_for_Project_Execution__c='test';
 mpc.Deal__c=deal.id;
 insert mpc;
 
// To create a MEC Post Contract End User Questionnare
mpceu= new MEC_Post_Contract_End_User_Questionnaire__c();
mpceu.Satisfaction_Rating__c='Satisfied';
mpceu.Deal__c=deal.id;
mpceu.Version_Number__c=mec.id;
mpceu.Is_Mandatory__c=true;
insert mpceu;

}
public static void setupData3(){
///To create a MEC_Post_Contract_Version__c

 mec = new MEC_Post_Contract_Version__c ();

 mec.Version_Name__c= 'test';
 mec.Active__c = true;
 insert mec;
 
 //////To create a MEC_Post_Contract_Questionnaire_Master__c
 mcq= new MEC_Post_Contract_Questionnaire_Master__c();
 mcq.MEC_Post_Contract_Version__c=mec.id;
 mcq.Category_Name__c='test';
 mcq.Criteria__c='test';
 mcq.Is_Mandatory__c=false;
 insert mcq;
 
 
///To create a client Geo Unit

 clientGeoUnit = new Client_Geo_Unit_Master__c ();
 clientGeoUnit.Name = 'TestLATAM';
 clientGeoUnit.Active__c = true;
 insert clientGeoUnit;

 /// To insert Operating Group Master
 
operatingGroup = new Operating_Group_Master__c ();
operatingGroup.Name = 'TestHSMPS';
operatingGroup.Active__c = true;
insert operatingGroup;
///To create a Client Geo Area
clientGeoArea = new Client_Geo_Area_Master__c ();
clientGeoArea.Name = 'TestAPAC';
clientGeoArea.Active__c = true;
 insert clientGeoArea;
/// To create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
      
      
/// To create a Client

clientName = new Client_Master__c ();
clientName.Name = 'TestObject1';
clientName.Active__c = true;
insert clientName;
      /// To create an Opportunity

oppTGP = new Opportunity_TGP__c();
oppTGP.Name = 'TestIBM';
oppTGP.Stage__c='Stage 1';
oppTGP.Client_Name__c= clientName.id ;
oppTGP.Client_Geo_Area__c=clientGeoArea.id;
oppTGP.Operating_Group__c=operatingGroup.id;
oppTGP.Enterprise_Solution_Architect__c=testuser.id;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';
insert oppTGP;
///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Opportunity_ID__c=null;
//deal.Governance_Lead_Name__c=UserInfo.getUserId();
deal.Has_Gov_Lead_Submitted__c=false;
//deal.Governance_Lead_Name_Secondary__c=UserInfo.getUserId();
deal.Has_Mob_Architect_Saved__c=true;
deal.Has_Mob_Architect_Submitted__c=true;

insert deal;
// To create a MEC Post Contract End User
 
 mpc= new MEC_Post_Contract_End_User__c();
 mpc.Version_Number__c=mec.id;
 mpc.Entry_Criteria_for_Project_Execution__c='test';
 mpc.Deal__c=deal.id;
 //insert mpc;
 
// To create a MEC Post Contract End User Questionnare
mpceu= new MEC_Post_Contract_End_User_Questionnaire__c();
mpceu.Satisfaction_Rating__c='Satisfied';
mpceu.Deal__c=deal.id;
mpceu.Version_Number__c=mec.id;
mpceu.Is_Mandatory__c=true;
insert mpceu;

}

public static void setupData4(){
///To create a MEC_Post_Contract_Version__c

 mec = new MEC_Post_Contract_Version__c ();

 mec.Version_Name__c= 'test';
 mec.Active__c = true;
 insert mec;
 
 //////To create a MEC_Post_Contract_Questionnaire_Master__c
 mcq= new MEC_Post_Contract_Questionnaire_Master__c();
 mcq.MEC_Post_Contract_Version__c=mec.id;
 mcq.Category_Name__c='test';
 mcq.Criteria__c='test';
 mcq.Is_Mandatory__c=false;
 insert mcq;
 
 
///To create a client Geo Unit

 clientGeoUnit = new Client_Geo_Unit_Master__c ();
 clientGeoUnit.Name = 'TestLATAM';
 clientGeoUnit.Active__c = true;
 insert clientGeoUnit;

 /// To insert Operating Group Master
 
operatingGroup = new Operating_Group_Master__c ();
operatingGroup.Name = 'TestHSMPS';
operatingGroup.Active__c = true;
insert operatingGroup;
///To create a Client Geo Area
clientGeoArea = new Client_Geo_Area_Master__c ();
clientGeoArea.Name = 'TestAPAC';
clientGeoArea.Active__c = true;
 insert clientGeoArea;
/// To create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
      
      
/// To create a Client

clientName = new Client_Master__c ();
clientName.Name = 'TestObject1';
clientName.Active__c = true;
insert clientName;
      /// To create an Opportunity

oppTGP = new Opportunity_TGP__c();
oppTGP.Name = 'TestIBM';
oppTGP.Stage__c='Stage 1';
oppTGP.Client_Name__c= clientName.id ;
oppTGP.Client_Geo_Area__c=clientGeoArea.id;
oppTGP.Operating_Group__c=operatingGroup.id;
oppTGP.Enterprise_Solution_Architect__c=testuser.id;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';
insert oppTGP;
///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Opportunity_ID__c=null;
//deal.Governance_Lead_Name__c=UserInfo.getUserId();
deal.Has_Gov_Lead_Submitted__c=false;
//deal.Governance_Lead_Name_Secondary__c=UserInfo.getUserId();
deal.Has_Mob_Architect_Saved__c=true;
deal.Has_Mob_Architect_Submitted__c=true;

insert deal;
// To create a MEC Post Contract End User
 
 mpc= new MEC_Post_Contract_End_User__c();
 mpc.Version_Number__c=mec.id;
 mpc.Entry_Criteria_for_Project_Execution__c='test';
 mpc.Deal__c=deal.id;
 //insert mpc;
 
// To create a MEC Post Contract End User Questionnare
mpceu= new MEC_Post_Contract_End_User_Questionnaire__c();
mpceu.Satisfaction_Rating__c='Satisfied';
mpceu.Deal__c=deal.id;
mpceu.Version_Number__c=mec.id;
mpceu.Is_Mandatory__c=true;
//insert mpceu;

}







public static void setupData5(){
///To create a MEC_Post_Contract_Version__c

 mec = new MEC_Post_Contract_Version__c ();

 mec.Version_Name__c= 'test';
 mec.Active__c = true;
 insert mec;
 
 //////To create a MEC_Post_Contract_Questionnaire_Master__c
 mcq= new MEC_Post_Contract_Questionnaire_Master__c();
 mcq.MEC_Post_Contract_Version__c=mec.id;
 mcq.Category_Name__c='test';
 mcq.Criteria__c='test';
 mcq.Is_Mandatory__c=false;
 insert mcq;
 
 
///To create a client Geo Unit

 clientGeoUnit = new Client_Geo_Unit_Master__c ();
 clientGeoUnit.Name = 'TestLATAM';
 clientGeoUnit.Active__c = true;
 insert clientGeoUnit;

 /// To insert Operating Group Master
 
operatingGroup = new Operating_Group_Master__c ();
operatingGroup.Name = 'TestHSMPS';
operatingGroup.Active__c = true;
insert operatingGroup;
///To create a Client Geo Area
clientGeoArea = new Client_Geo_Area_Master__c ();
clientGeoArea.Name = 'TestAPAC';
clientGeoArea.Active__c = true;
 insert clientGeoArea;
/// To create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
      
      
/// To create a Client

clientName = new Client_Master__c ();
clientName.Name = 'TestObject1';
clientName.Active__c = true;
insert clientName;
      /// To create an Opportunity

oppTGP = new Opportunity_TGP__c();
oppTGP.Name = 'TestIBM';
oppTGP.Stage__c='Stage 1';
oppTGP.Client_Name__c= clientName.id ;
oppTGP.Client_Geo_Area__c=clientGeoArea.id;
oppTGP.Operating_Group__c=operatingGroup.id;
oppTGP.Enterprise_Solution_Architect__c=testuser.id;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';

insert oppTGP;
///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Opportunity_ID__c=null;
//deal.Governance_Lead_Name__c='Malkeet Singh';
deal.Has_Gov_Lead_Submitted__c=false;
//deal.Governance_Lead_Name_Secondary__c='Malkeet Singh';
deal.Has_Mob_Architect_Saved__c=true;
deal.Has_Mob_Architect_Submitted__c=false;
deal.Opportunity_Name__c=oppTGP.id;

insert deal;
// To create a MEC Post Contract End User
 
 mpc= new MEC_Post_Contract_End_User__c();
 mpc.Version_Number__c=mec.id;
 mpc.Entry_Criteria_for_Project_Execution__c='test';
 mpc.MEC_Submission_End_Date__c=date.today()+4;
 mpc.Governance_Lead_Review_End_Date__c=date.today()+5;
 mpc.Deal__c=deal.id;
 insert mpc;
 
// To create a MEC Post Contract End User Questionnare
mpceu= new MEC_Post_Contract_End_User_Questionnaire__c();
mpceu.Satisfaction_Rating__c='Satisfied';
mpceu.Deal__c=deal.id;
mpceu.Version_Number__c=mec.id;
mpceu.Is_Mandatory__c=true;
insert mpceu;

}
static testMethod void test(){
    test.starttest();
    setupData();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('Id' ,deal.id);
    apexpages.currentpage().getparameters().put('itemValue' ,'tab2');
    MECChecklist_InlineReadOnlyController obj = new MECChecklist_InlineReadOnlyController( controller);
    obj.initializePageMessages();
    obj.assignContractColors('Green');
    obj.assignAssessmentColors('Green');
    obj.assignRatingColors('Green');
    obj.getMECUserValues();
    obj.getMECQuestionnaire();  
    test.stoptest();
  }
static testMethod void test1(){
    test.starttest();
    setupData1();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('Id' ,deal.id);
    apexpages.currentpage().getparameters().put('itemValue' ,'tab2');
    MECChecklist_InlineReadOnlyController obj = new MECChecklist_InlineReadOnlyController( controller);
    obj.initializePageMessages();
    obj.assignContractColors('Green');
    obj.assignAssessmentColors('Green');
    obj.assignRatingColors('Green');
    obj.getMECUserValues();
    obj.getMECQuestionnaire();  
    test.stoptest();
  }
  
 static testMethod void test2(){
    test.starttest();
    setupData2();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('Id' ,deal.id);
    apexpages.currentpage().getparameters().put('itemValue' ,'tab2');
    MECChecklist_InlineReadOnlyController obj = new MECChecklist_InlineReadOnlyController( controller);
    obj.initializePageMessages();
    //obj.assignContractColors('#FF0000');
    obj.assignAssessmentColors('Green');
    obj.assignRatingColors('Green');
    obj.getMECUserValues();
    obj.getMECQuestionnaire();  
    
    test.stoptest();
  }
  static testMethod void test3(){
    test.starttest();
    setupData3();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('Id' ,deal.id);
    apexpages.currentpage().getparameters().put('itemValue' ,'tab2');
    MECChecklist_InlineReadOnlyController obj = new MECChecklist_InlineReadOnlyController( controller);
    obj.initializePageMessages();
    //obj.assignContractColors('#FF0000');
    obj.assignAssessmentColors('Green');
    obj.assignRatingColors('Green');
    obj.getMECUserValues();
    obj.getMECQuestionnaire();  
    test.stoptest();
  }
  static testMethod void test4(){
    test.starttest();
    setupData4();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('Id' ,deal.id);
    apexpages.currentpage().getparameters().put('itemValue' ,'tab2');
    MECChecklist_InlineReadOnlyController obj = new MECChecklist_InlineReadOnlyController( controller);
    obj.initializePageMessages();
    //obj.assignContractColors('#FF0000');
    obj.assignAssessmentColors('Green');
    obj.assignRatingColors('Green');
    obj.getMECUserValues();
    obj.getMECQuestionnaire();  
    test.stoptest();
  }

  static testMethod void test5(){
    test.starttest();
    setupData5();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('Id' ,deal.id);
    apexpages.currentpage().getparameters().put('itemValue' ,'tab2');
    MECChecklist_InlineReadOnlyController obj = new MECChecklist_InlineReadOnlyController( controller);
    obj.initializePageMessages();
   // obj.assignContractColors('#FF0000');
    obj.assignAssessmentColors('Green');
    obj.assignRatingColors('Green');
    obj.getMECUserValues();
    obj.getMECQuestionnaire();  
    test.stoptest();
  }
  
  
  // SETUP DATA 6
  
  
  
  public static void setupData6(){
        ///To create a MEC_Post_Contract_Version__c
        
         mec = new MEC_Post_Contract_Version__c ();
        
         mec.Version_Name__c= 'test';
         mec.Active__c = true;
         insert mec;
         
         //////To create a MEC_Post_Contract_Questionnaire_Master__c
         mcq= new MEC_Post_Contract_Questionnaire_Master__c();
         mcq.MEC_Post_Contract_Version__c=mec.id;
         mcq.Category_Name__c='test';
         mcq.Criteria__c='test';
         mcq.Is_Mandatory__c=false;
         insert mcq;
         
         
        ///To create a client Geo Unit
        
         clientGeoUnit = new Client_Geo_Unit_Master__c ();
         clientGeoUnit.Name = 'TestLATAM';
         clientGeoUnit.Active__c = true;
         insert clientGeoUnit;
        
         /// To insert Operating Group Master
         
        operatingGroup = new Operating_Group_Master__c ();
        operatingGroup.Name = 'TestHSMPS';
        operatingGroup.Active__c = true;
        insert operatingGroup;
        ///To create a Client Geo Area
        clientGeoArea = new Client_Geo_Area_Master__c ();
        clientGeoArea.Name = 'TestAPAC';
        clientGeoArea.Active__c = true;
         insert clientGeoArea;
        /// To create a Test User
        
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
             
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,'testUser');
        Database.insert(testUser, false);
        
        testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,'testUser1');
        Database.insert(testUser1, false);
        
        testUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(p,'testUser2');
        Database.insert(testUser2, false);
                
        testUserMaster = new Review_User_Master__c(Name = 'TestUserMaster',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster@testorg.com',SFDC_User__c=testUser.id);
        insert testUserMaster;
        
        testUserMaster1 = new Review_User_Master__c(Name = 'TestUserMaster1',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster1@testorg.com',SFDC_User__c=testUser1.id);
        insert testUserMaster1;
        
        testUserMaster2 = new Review_User_Master__c(Name = 'TestUserMaster1',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster1@testorg.com',SFDC_User__c=testUser2.id);
        insert testUserMaster2;  
        

              
              
        /// To create a Client
        
        clientName = new Client_Master__c ();
        clientName.Name = 'TestObject1';
        clientName.Active__c = true;
        insert clientName;
              /// To create an Opportunity
        
        oppTGP = new Opportunity_TGP__c();
        oppTGP.Name = 'TestIBM';
        oppTGP.Stage__c='Stage 1';
        oppTGP.Client_Name__c= clientName.id ;
        oppTGP.Client_Geo_Area__c=clientGeoArea.id;
        oppTGP.Operating_Group__c=operatingGroup.id;
        oppTGP.Enterprise_Solution_Architect__c=testuser.id;
        oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
        oppTGP.Risk_Level__c='Low';
        oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
        oppTGP.Activity__c='1-Active';
        oppTGP.Oppotunity_QA__c='TestData';
        oppTGP.OG_Sales_Lead__c='TestData';
        
        insert oppTGP;
        ///To create a Deal
        
        deal =new Deal_TGP__c();
        deal.Name='Test Data';
        deal.Opportunity_ID__c=null;
        //deal.Governance_Lead_Name__c='Malkeet Singh';
        deal.Has_Gov_Lead_Submitted__c=false;
        //deal.Governance_Lead_Name_Secondary__c='Malkeet Singh';
        deal.Has_Mob_Architect_Saved__c=true;
        deal.Has_Mob_Architect_Submitted__c=false;
        deal.Opportunity_Name__c=oppTGP.id;
        deal.Complex_Costing_Architect_New__c=testUser2.id;
        
        insert deal;
        // To create a MEC Post Contract End User
         
         mpc= new MEC_Post_Contract_End_User__c();
         mpc.Version_Number__c=mec.id;
         mpc.Entry_Criteria_for_Project_Execution__c='test';
         mpc.MEC_Submission_End_Date__c=date.today()+4;
         mpc.Governance_Lead_Review_End_Date__c=date.today()+5;
         mpc.Deal__c=deal.id;
         insert mpc;
         
        // To create a MEC Post Contract End User Questionnare
        mpceu= new MEC_Post_Contract_End_User_Questionnaire__c();
        mpceu.Satisfaction_Rating__c='Satisfied';
        mpceu.Deal__c=deal.id;
        mpceu.Version_Number__c=mec.id;
        mpceu.Is_Mandatory__c=true;
        insert mpceu;
        
       /* Mob_User_Roles_Master__c mobUsrRoleMstr=new Mob_User_Roles_Master__c();
        mobUsrRoleMstr.Role_Name__c='TestRole';
        insert mobUsrRoleMstr;
        
        mobUserAssign=new MOB_User_Role_Assignment__c();
        mobUserAssign.Deal__c=deal.id;
        mobUserAssign.Role_Name__c='MOBILIZATION ARCHITECT';
        mobUserAssign.User_Assigned_New__c=testUserMaster.id;
        mobUserAssign.User_Assigned_Secondary_New__c=testUserMaster1.id;
        mobUserAssign.User_Assigned_Secondary_Lead__c=testUserMaster2.id;
        mobUserAssign.Access_Level__c='Test';
        mobUserAssign.Mob_User_Roles_Master__c=mobUsrRoleMstr.Id;
        insert mobUserAssign;  */
}

static testMethod void test6(){
    test.starttest();
    setupData6();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('Id' ,deal.id);
    apexpages.currentpage().getparameters().put('itemValue' ,'tab2');
    MECChecklist_InlineReadOnlyController obj = new MECChecklist_InlineReadOnlyController( controller);
    obj.initializePageMessages();
   // obj.assignContractColors('#FF0000');
    obj.assignAssessmentColors('Green');
    obj.assignRatingColors('Green');
    obj.getMECUserValues();
    obj.getMECQuestionnaire();  
    test.stoptest();
  }
  
  
 }