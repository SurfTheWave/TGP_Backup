/*
Author : Malkeet Singh
Story  :   
Description : Test Class for MECChecklist_InlineController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class MECChecklist_InlineControllerTest{
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
static Mob_User_Roles_Master__c strMoURM; 
static MOB_User_Role_Assignment__c strMobUser;
static String USER_Name = 'vc7@testorg.com';
static Review_User_Master__c testUserMaster;
static Review_User_Master__c testUserMaster1;

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

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_ADMIN);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
 
 p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     
     testUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser2, false);
      
p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     
     testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser1, false);
      
/// To create a Client

clientName = new Client_Master__c ();
clientName.Name = 'TestObject1';
clientName.Active__c = true;
insert clientName;
      /// To create an Opportunity
       
testUserMaster = new Review_User_Master__c(Name = 'TestUserMaster',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster@testorg.com',SFDC_User__c=testUser.id);
insert testUserMaster;

testUserMaster1 = new Review_User_Master__c(Name = 'TestUserMaster1',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster1@testorg.com',SFDC_User__c=testUser1.id);
insert testUserMaster1;

oppTGP = new Opportunity_TGP__c();
oppTGP.Name = 'TestIBM';
oppTGP.Stage__c='Stage 1';
oppTGP.Client_Name__c= clientName.id ;
oppTGP.Client_Geo_Area__c=clientGeoArea.id;
oppTGP.Operating_Group__c=operatingGroup.id;
oppTGP.Enterprise_Solution_Architect_New__c=testUserMaster1.id;
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
deal.Governance_Lead_Name_New__c=testUserMaster1.id;
deal.Has_Gov_Lead_Submitted__c=false;
deal.Governance_Lead_Name_Secondary_New__c=testUserMaster1.id;
deal.Has_Mob_Architect_Saved__c=true;
deal.Has_Mob_Architect_Submitted__c=false;
deal.Opportunity_Name__c=oppTGP.id;
deal.Solution_Architect_New__c=testUserMaster.id;

insert deal;

strMoURM=new Mob_User_Roles_Master__c();
    /*List<Mob_User_Roles_Master__c> lstMURM=[select id,Access_Level__c,Role_Name__c from Mob_User_Roles_Master__c where Role_Name__c='Governance Lead'];
    if(lstMURM.size()>0)
    {
        strMoURM=lstMURM[0];
    }
    else
    {*/
    strMoURM.Access_Level__c='Edit';
    strMoURM.Role_Name__c='Governance Lead';
    insert strMoURM;
    //}
    strMobUser= new MOB_User_Role_Assignment__c();
    
        strMobUser.Deal__c=deal.id;
        strMobUser.Mob_User_Roles_Master__c =strMoURM.id;
        strMobUser.Access_Level__c='Edit';
        strMobUser.Role_Name__c='Mobilization Architect';
    strMobUser.User_Assigned_New__c=testUserMaster.id;
    strMobUser.User_Assigned_Secondary_New__c=testUserMaster.id;
    insert strMobUser;

mpc= new MEC_Post_Contract_End_User__c();
 mpc.Version_Number__c=mec.id;
 mpc.Entry_Criteria_for_Project_Execution__c='test';
 mpc.MEC_Submission_End_Date__c=date.today()+4;
 mpc.Governance_Lead_Review_End_Date__c=date.today()+5;
 mpc.HAS_Checklist_Version_Changed__c=true;
 mpc.Deal__c=deal.id;
 insert mpc;
 
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
     insert testUser;
      
Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     
     testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
     insert testUser1;
      
/// To create a Client

testUserMaster = new Review_User_Master__c(Name = 'TestUserMaster',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster@testorg.com',SFDC_User__c=testUser.id);
insert testUserMaster;

testUserMaster1 = new Review_User_Master__c(Name = 'TestUserMaster1',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster1@testorg.com',SFDC_User__c=testUser1.id);
insert testUserMaster1;

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
oppTGP.Enterprise_Solution_Architect_New__c=testUserMaster1.id;
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
deal.Governance_Lead_Name_New__c=testUserMaster1.id;
deal.Has_Gov_Lead_Submitted__c=false;
deal.Governance_Lead_Name_Secondary_New__c=testUserMaster1.id;
deal.Has_Mob_Architect_Saved__c=true;
deal.Has_Mob_Architect_Submitted__c=false;
deal.Opportunity_Name__c=oppTGP.id;
deal.Solution_Architect_New__c=testUserMaster.id;
insert deal;

 mpc= new MEC_Post_Contract_End_User__c();
 mpc.Version_Number__c=mec.id;
 mpc.Entry_Criteria_for_Project_Execution__c='test';
 mpc.MEC_Submission_End_Date__c=date.today()+4;
 mpc.Governance_Lead_Review_End_Date__c=date.today()+5;
 mpc.HAS_Checklist_Version_Changed__c=true;
 mpc.Deal__c=deal.id;
 insert mpc;
 
 //insert mpc;
 
// To create a MEC Post Contract End User Questionnare
mpceu= new MEC_Post_Contract_End_User_Questionnaire__c();
mpceu.Satisfaction_Rating__c='Satisfied';
mpceu.Deal__c=deal.id;
mpceu.Version_Number__c=mec.id;
mpceu.Is_Mandatory__c=true;
//insert mpceu;

    strMoURM=new Mob_User_Roles_Master__c();
    /*List<Mob_User_Roles_Master__c> lstMURM=[select id,Access_Level__c,Role_Name__c from Mob_User_Roles_Master__c where Role_Name__c='Mobilization Architect'];
    if(lstMURM.size()>0)
    {
        strMoURM=lstMURM[0];
    }
    else
    {*/
    strMoURM.Access_Level__c='Edit';
    strMoURM.Role_Name__c='Mobilization Architect';
    insert strMoURM;
    //}
    strMobUser= new MOB_User_Role_Assignment__c();
    /*List<MOB_User_Role_Assignment__c> mobList=[Select id,Access_Level__c,Deal__c,User_Assigned__c,Role_Name__c,Mob_User_Roles_Master__c from MOB_User_Role_Assignment__c where Deal__c=:deal.id and Role_Name__c='Mobilization Architect'];
    if(mobList.size()>0)
    {
        strMobUser=mobList[0];
    }
    else
    {*/
        strMobUser.Deal__c=deal.id;
        strMobUser.Mob_User_Roles_Master__c =strMoURM.id;
        strMobUser.Access_Level__c='Edit';
        strMobUser.Role_Name__c='Mobilization Architect';
    //}
    strMobUser.User_Assigned_New__c=testUserMaster.id;
    strMobUser.User_Assigned_Secondary_New__c=testUserMaster.id;
    insert strMobUser;

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
    insert testUser;
      
    Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
    testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
    insert testUser1;
      
/// To create a Client

clientName = new Client_Master__c ();
clientName.Name = 'TestObject1';
clientName.Active__c = true;
insert clientName;
      /// To create an Opportunity
       
 testUserMaster = new Review_User_Master__c(Name = 'TestUserMaster',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster@testorg.com',SFDC_User__c=testUser.id);
insert testUserMaster;

 testUserMaster1 = new Review_User_Master__c(Name = 'TestUserMaster1',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster1@testorg.com',SFDC_User__c=testUser1.id);
insert testUserMaster1;

oppTGP = new Opportunity_TGP__c();
oppTGP.Name = 'TestIBM';
oppTGP.Stage__c='Stage 1';
oppTGP.Client_Name__c= clientName.id ;
oppTGP.Client_Geo_Area__c=clientGeoArea.id;
oppTGP.Operating_Group__c=operatingGroup.id;
oppTGP.Enterprise_Solution_Architect_New__c=testUserMaster1.id;
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
deal.Governance_Lead_Name_New__c=testUserMaster1.id;
deal.Has_Gov_Lead_Submitted__c=false;
deal.Governance_Lead_Name_Secondary_New__c=testUserMaster1.id;
deal.Has_Mob_Architect_Saved__c=true;
deal.Has_Mob_Architect_Submitted__c=false;
deal.Opportunity_Name__c=oppTGP.id;
deal.Solution_Architect_New__c=testUserMaster.id;
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

    strMoURM=new Mob_User_Roles_Master__c();
    /*List<Mob_User_Roles_Master__c> lstMURM=[select id,Access_Level__c,Role_Name__c from Mob_User_Roles_Master__c where Role_Name__c='Governance Lead'];
    if(lstMURM.size()>0)
    {
        strMoURM=lstMURM[0];
    }
    else
    {*/
    strMoURM.Access_Level__c='Edit';
    strMoURM.Role_Name__c='Governance Lead';
    insert strMoURM;
    //}
    strMobUser= new MOB_User_Role_Assignment__c();
    
        strMobUser.Deal__c=deal.id;
        strMobUser.Mob_User_Roles_Master__c =strMoURM.id;
        strMobUser.Access_Level__c='Edit';
        strMobUser.Role_Name__c='Mobilization Architect';
        strMobUser.User_Assigned_New__c=testUserMaster.id;
        strMobUser.User_Assigned_Secondary_New__c=testUserMaster.id;
        insert strMobUser;
}

   static testMethod void test5(){
        test.starttest();
        setupData5();
        ApexPages.StandardController controller;
        apexpages.currentpage().getparameters().put('Id' ,deal.id);
        apexpages.currentpage().getparameters().put('itemValue' ,'tab2');
        MECChecklist_InlineController obj = new MECChecklist_InlineController( controller);
        
        strMobUser= new MOB_User_Role_Assignment__c();
        strMobUser.Deal__c=deal.id;
        strMobUser.Mob_User_Roles_Master__c =strMoURM.id;
        strMobUser.Access_Level__c='Edit';
        strMobUser.Role_Name__c='Governance Lead';
        strMobUser.User_Assigned_New__c=testUserMaster.id;
        strMobUser.User_Assigned_Secondary_New__c=testUserMaster1.id;
        insert strMobUser;
        
        List<MOB_User_Role_Assignment__c> userList1 = new List<MOB_User_Role_Assignment__c> ();
        userList1.add(strMobUser);
        
     System.runAs(testUser)
    {
        obj.initializePageMessages();
        obj.assignContractColors('Green');
        obj.assignAssessmentColors('Green');
        obj.assignRatingColors('Green');
        obj.getMECUserValues();
        obj.getMECQuestionnaire();  
        //obj.setMECUserQuestionnaire(true);
        
        obj.setMECEndUser();
        obj.saveMECChecklist();
        obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+2;
        obj.saveMECChecklist();
        obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+2;
        obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+1;
        obj.saveMECChecklist();
        obj.isDateChanged=true;
        obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+2;
        obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+3;
        obj.saveMECChecklist();
        obj.doCancelChecklist();
        
        obj.submitMECChecklist();
        obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+2;
        obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+1;
        obj.submitMECChecklist();
        obj.isDateChanged=true;
        obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+2;
        obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+3;
        obj.submitMECChecklist();
        
        obj.initializeSectionsUsers();
        
    }
    
    obj.userList = userList1;
    obj.initializeSectionsUsers();
    
    Deal_TGP__c deal1 =new Deal_TGP__c();
    deal1.Name='Test Data1';
    deal1.Opportunity_ID__c=null;
    deal1.Governance_Lead_Name_New__c=testUserMaster1.id;
    deal1.Has_Gov_Lead_Submitted__c=false;
    deal1.Governance_Lead_Name_Secondary_New__c=testUserMaster1.id;
    deal1.Has_Mob_Architect_Saved__c=false;
    deal1.Has_Mob_Architect_Submitted__c=false;
    deal1.Opportunity_Name__c=oppTGP.id;
    deal1.Solution_Architect_New__c=testUserMaster.id;
    insert deal1;
    
    MOB_User_Role_Assignment__c strMobUser1= new MOB_User_Role_Assignment__c();
    strMobUser1.Deal__c=deal1.id;
    strMobUser1.Mob_User_Roles_Master__c =strMoURM.id;
    strMobUser1.Access_Level__c='Edit';
    strMobUser1.Role_Name__c='Governance Lead';
    strMobUser1.User_Assigned_New__c=testUserMaster.id;
    strMobUser1.User_Assigned_Secondary_New__c=testUserMaster.id;
    insert strMobUser1;
    
    obj.submitMECChecklist();
    
    List<MOB_User_Role_Assignment__c> userList2 = new List<MOB_User_Role_Assignment__c> ();
    userList2.add(strMobUser1);
    
    obj.userList = userList2;
    obj.initializeSectionsUsers();
        
    obj.getActionFunction();
    obj.checkDateChange();
    test.stoptest();
 }
 static testMethod void test4(){
    test.starttest();
    setupData4();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('Id' ,deal.id);
    apexpages.currentpage().getparameters().put('itemValue' ,'tab2');
    MECChecklist_InlineController obj = new MECChecklist_InlineController( controller);
    System.runAs(testUser)
    {
            obj.initializePageMessages();
            obj.assignContractColors('Green');
            obj.assignAssessmentColors('Green');
            obj.assignRatingColors('Green');
            obj.getMECUserValues();
            obj.getMECQuestionnaire();  
            //obj.setMECUserQuestionnaire(true);
            
            obj.setMECEndUser();
            obj.saveMECChecklist();
            obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+1;
            obj.saveMECChecklist();
            obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+2;
            obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+1;
            obj.saveMECChecklist();
            obj.isDateChanged=true;
            obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+2;
            obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+3;
            obj.saveMECChecklist();
            obj.doCancelChecklist();
            
            obj.submitMECChecklist();
            obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+2;
            obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+1;
            obj.submitMECChecklist();
            obj.isDateChanged=true;
            obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+2;
            obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+3;
            obj.submitMECChecklist();
            

    }
     obj.getActionFunction();
     obj.checkDateChange();
     test.stoptest();
}
    static testMethod void test3(){
        test.starttest();
        setupData3();
        ApexPages.StandardController controller;
        apexpages.currentpage().getparameters().put('Id' ,deal.id);
        apexpages.currentpage().getparameters().put('itemValue' ,'tab2');
        MECChecklist_InlineController obj = new MECChecklist_InlineController( controller);

        obj.initializePageMessages();
        obj.assignContractColors('Green');
        obj.assignAssessmentColors('Green');
        obj.assignRatingColors('Green');
        obj.getMECUserValues();
        obj.getMECQuestionnaire();  
        //obj.setMECUserQuestionnaire(true);

        obj.setMECEndUser();
        obj.saveMECChecklist();
        obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+1;
        obj.saveMECChecklist();
        obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+2;
        obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+1;
        obj.saveMECChecklist();
        obj.isDateChanged=true;
        obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+2;
        obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+3;
        obj.saveMECChecklist();
        obj.doCancelChecklist();

        obj.submitMECChecklist();
        obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+2;
        obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+1;
        obj.submitMECChecklist();
        obj.isDateChanged=true;
        obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+2;
        obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+3;
        obj.submitMECChecklist();

        obj.isDateChanged=true;
        obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+4;
        obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+5;
        obj.submitMECChecklist();

        obj.getActionFunction();
        obj.checkDateChange();
        obj.deleteMEC();
        test.stoptest();
  }
  static testMethod void test2(){
        test.starttest();
        setupData3();

        ApexPages.StandardController controller;
        apexpages.currentpage().getparameters().put('Id' ,deal.id);
        apexpages.currentpage().getparameters().put('itemValue' ,'tab2');
        MECChecklist_InlineController obj = new MECChecklist_InlineController( controller);
      
        system.runAs(testUser)
        {
                obj.initializePageMessages();
                obj.assignContractColors('Green');
                obj.assignAssessmentColors('Green');
                obj.assignRatingColors('Green');
                obj.getMECUserValues();
                obj.getMECQuestionnaire();  
                //obj.setMECUserQuestionnaire(true);
                
                obj.setMECEndUser();
                obj.saveMECChecklist();
                obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+1;
                obj.saveMECChecklist();
                obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+2;
                obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+1;
                obj.saveMECChecklist();
                obj.isDateChanged=true;
                obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+2;
                obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+3;
                obj.saveMECChecklist();
                obj.doCancelChecklist();
                
                obj.submitMECChecklist();
                obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+2;
                obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+1;
                obj.submitMECChecklist();
                obj.isDateChanged=true;
                obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+2;
                obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+3;
                obj.submitMECChecklist();
                
                List<MEC_Post_Contract_End_User__c> userMECDataList1 = new List<MEC_Post_Contract_End_User__c>();
                obj.userMECDataList = userMECDataList1;
                obj.getMECUserValues();
        }
        obj.getActionFunction();
        obj.checkDateChange();
        obj.deleteMEC();
        test.stoptest();
  }
  static testMethod void test21(){
        test.starttest();
        setupData3();
        
        strMobUser= new MOB_User_Role_Assignment__c();
    
        strMobUser.Deal__c=deal.id;
        strMobUser.Mob_User_Roles_Master__c =strMoURM.id;
        strMobUser.Access_Level__c='Edit';
        strMobUser.Role_Name__c='Governance Lead';
        strMobUser.User_Assigned_New__c=testUserMaster.id;
        strMobUser.User_Assigned_Secondary_New__c=testUserMaster.id;
        insert strMobUser;
        
        mpc= new MEC_Post_Contract_End_User__c();
         mpc.Version_Number__c=mec.id;
         mpc.Entry_Criteria_for_Project_Execution__c='test';
         mpc.MEC_Submission_End_Date__c=date.today()+4;
         mpc.Governance_Lead_Review_End_Date__c=date.today()+5;
         mpc.HAS_Checklist_Version_Changed__c=true;
         mpc.Deal__c=deal.id;
         insert mpc;

        ApexPages.StandardController controller;
        apexpages.currentpage().getparameters().put('Id' ,deal.id);
        apexpages.currentpage().getparameters().put('itemValue' ,'tab2');
        MECChecklist_InlineController obj = new MECChecklist_InlineController( controller);
        obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+1;
        obj.getMECUserValues();
        //obj.setMECEndUser();
        //obj.saveMECChecklist();
        obj.submitMECChecklist();
        
        //obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=null;
        obj.submitMECChecklist();
        
        
        obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+1;
        obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=null;
        obj.submitMECChecklist();
        
        obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+1;
        obj.endUserSavedRecord.Governance_Lead_Review_End_Date__c=system.today()+5;
        obj.submitMECChecklist();
        
        obj.getMECQuestionnaire();  
        obj.setMECUserQuestionnaire(true);
        obj.submitMECChecklist();
                
        obj.endUserSavedRecord.MEC_Submission_End_Date__c=system.today()+1;
        obj.endUserSavedRecord.Secondary_Gov_Lead_Task_ID__c=null;  
        obj.submitMECChecklist();         
                
               
        test.stoptest();
  }
 }