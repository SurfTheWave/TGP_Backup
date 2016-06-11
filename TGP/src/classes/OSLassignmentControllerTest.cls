/*
Author : Malkeet Singh

Description : Test Class for OSLassignmentControllerTest. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class OSLassignmentControllerTest
{
    private static User testUser;
    private static User testUser1;
    private static Deal_TGP__c strDealTGP;
    private static Wave_Plan_Version__c strWavePlanVersion;
    private static Deal_Location__c strDealLocation;
    private static Wave_Planning__c strWavePlanning;
    private static Client_Master__c clientName;
    private static Client_Geo_Area_Master__c clientGeoArea;
    private static Operating_Group_Master__c operatingGroup;
    private static Client_Geo_Unit_Master__c clientGeoUnit;
    private static Opportunity_TGP__c oppTGP;
    private static Opportunity_TGP__c oppTGP1;
    private static Client_Specific_Process_Mapping__c clientProcess;
    private static Wave_Process__c strWaveProcess;
    private static SRAT__c strSRAT;
    private static OPEX__c strOPEX;
    private static Service_Management__c strServiceManagement;
    private static KT_Planning__c strKTPlanning;
    private static Recruitment_Tracking__c strRecruitmentTracking;
    private static Commercial_Planning__c strCommercialPlanning;
    private static Contract_Legal_Infosec__c strContractLegalInfosec;
    private static Opportunity_Solution_Lead_Task__c oslTask;
    private static Mob_User_Roles_Master__c strMoURM; 
    private static MOB_User_Role_Assignment__c strMoURA;
    private static String USER_Name = 'vc7@testorg.com';
    private static String USER_Name1 = 'vc71@testorg.com';
    private static String USER_Name2 = 'vc72@testorg.com';
    private static String USER_Name3 = 'vc73@testorg.com';
    private static String USER_Name4 = 'vc734@testorg.com';
    private static SAP_OM_Opportunity__c sapOMID;
    private static Review_User_Master__c testUserMaster;
    //static Opportunity_Solution_Lead_Task__c ccatRecord{get;set;}
    /******************************
     * Method Name: setupData
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/ 
    public static void setupData()
    {
        
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name);
        Database.insert(testUser, false);
     
         clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
        insert clientName;
        
        strDealTGP=new Deal_TGP__c(Name='DealTest123');
        insert strDealTGP;
        
        strMoURM=new Mob_User_Roles_Master__c(Access_Level__c='Edit',Role_Name__c='Governance Lead1');
        insert strMoURM;
        
        strMoURA=new MOB_User_Role_Assignment__c(Access_Level__c='Edit',Deal__c=strDealTGP.id,User_Assigned__c=testUser.id,Role_Name__c='Governance Lead1',Mob_User_Roles_Master__c=strMoURM.id);
        //insert strMoURA;
        
        strWavePlanVersion =new Wave_Plan_Version__c(Name='WaveTest123',Deal__c=strDealTGP.id);
        insert strWavePlanVersion;   
        
        strDealLocation=new Deal_Location__c(Wave_Plan_Version__c=strWavePlanVersion .id);
        insert strDealLocation;
              
        //testUserMaster = new Review_User_Master__c(Name = 'TestUserMaster',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster@testorg.com',SFDC_User__c=testUser.id);
        //insert testUserMaster; 
       
      
        clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
        insert clientGeoArea;
      
        operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
        insert operatingGroup;
      
        clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
        insert clientGeoUnit;
        
        oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
      insert oppTGP;
      
      }
        /******************************
     * Method Name: setupData
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/ 
      public static void setupData00()
    {  
    setupData();
       //To create OSL record
       oslTask=new Opportunity_Solution_Lead_Task__c();
       oslTask.Opportunity_TGP__c='test';
       oslTask.Client_Name_Master__c=clientName.id;
       oslTask.Opportunity_Solution_Lead__c=testUser.id;
       
       insert oslTask;
        
    }
      /******************************
     * Method Name: setupData
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/ 
static testMethod void test1(){

test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name1);
        Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData00();
//ApexPages.StandardController controller;


 OSLassignmentController obj = new OSLassignmentController( );
 Opportunity_Solution_Lead_Task__c obj1=new Opportunity_Solution_Lead_Task__c( );
 obj1.Opportunity_TGP__c='test';
 obj1.Client_Name_Master__c=clientName.id;
 obj1.Opportunity_Solution_Lead__c=testUser.id;
 obj.ccatRecord = obj1;
 obj.noSAPID();
 obj.yesSAPID();
 obj.getSAPOMIDOptions();
 //obj.nextSection();
 
 }
 //obj.getUserEmailAddress(username);
 //obj.sendEmailAlertToAssignedUser();
 //obj.findUserName();
 //obj.checkNullValues();
 test.stoptest();
}  
  /******************************
     * Method Name: setupData
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/ 
static testMethod void test2(){

test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name2);
        Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData00();
//ApexPages.StandardController controller;

 
 OSLassignmentController obj = new OSLassignmentController( );
 Opportunity_Solution_Lead_Task__c obj1=new Opportunity_Solution_Lead_Task__c( );
 obj1.Opportunity_TGP__c='test';
 obj1.Client_Name_Master__c=clientName.id;
 obj1.Opportunity_Solution_Lead__c=testUser.id;
 obj.ccatRecord = obj1;

 obj.ccatRecord.Opportunity_TGP__c='test';
 obj.ccatRecord.Opportunity_Solution_Lead__c  =testuser.id;
 obj.ccatRecord.Client_Name_Master__c =clientName.id;
 //obj.AssignSolutionLead();
 }
 //obj.getUserEmailAddress(username);
 //obj.sendEmailAlertToAssignedUser();
 //obj.findUserName();
 //obj.checkNullValues();
 test.stoptest();
}  
  /******************************
     * Method Name: setupData
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/ 
static testMethod void test3(){

test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData00();
//ApexPages.StandardController controller;

 
 OSLassignmentController obj = new OSLassignmentController( );
 Opportunity_Solution_Lead_Task__c obj1=new Opportunity_Solution_Lead_Task__c( );
 obj1.Opportunity_TGP__c='test';
 obj1.Client_Name_Master__c=clientName.id;
 obj1.Opportunity_Solution_Lead__c=testUser.id;
 obj.ccatRecord = obj1;
 obj.noSAPID();
 obj.yesSAPID();
 obj.getSAPOMIDOptions();
 //obj.nextSection();
 
 }
 //obj.getUserEmailAddress(username);
 //obj.sendEmailAlertToAssignedUser();
 //obj.findUserName();
 //obj.checkNullValues();
 test.stoptest();  
 }  
 /*
static testMethod void test4(){

test.starttest();
Profile p = [Select id from Profile where Name = 'System Administrator'];
List<userRole> role = [select id from userRole where name='Operations'];
testUser = new User(alias = 'vc22', email='vc22@testorg.com',
emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
localesidkey='en_US', profileid = p.Id, country='United States',UserRoleId =role[0].id,
timezonesidkey='America/Los_Angeles', username='vc22@testorg.com');
insert testUser;

//Run As U1
System.RunAs(testUser){
setupData00();
//ApexPages.StandardController controller;

 
 OSLassignmentController obj = new OSLassignmentController( );
 Opportunity_Solution_Lead_Task__c obj1=new Opportunity_Solution_Lead_Task__c( );
 obj1.Opportunity_TGP__c='test';
 obj1.Client_Name_Master__c=clientName.id;
 obj1.Opportunity_Solution_Lead__c=testUser.id;

 obj.ccatRecord.Opportunity_TGP__c='test';
 obj.ccatRecord.Opportunity_Solution_Lead__c  =testuser.id;
 obj.ccatRecord.Client_Name_Master__c =clientName.id;
 obj.AssignSolutionLead();
 }
 //obj.getUserEmailAddress(username);
 //obj.sendEmailAlertToAssignedUser();
 //obj.findUserName();
 //obj.checkNullValues();
 test.stoptest();  
 }  */
   /******************************
     * Method Name: setupData
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/ 
 static testMethod void test5(){

test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name3);
        Database.insert(testUser, false);
//Run As U1
System.RunAs(testUser){
setupData00();
//ApexPages.StandardController controller;

 
 OSLassignmentController obj = new OSLassignmentController( );
 Opportunity_Solution_Lead_Task__c obj1=new Opportunity_Solution_Lead_Task__c( );
 obj1.Opportunity_TGP__c='test';
 
 obj1.Client_Name_Master__c=clientName.id;
 obj1.Opportunity_Solution_Lead__c=testUser.id;
 obj.ccatRecord = obj1;
 //obj.AssignSolutionLead();

 obj1.Opportunity_Solution_Lead__c=null;
 obj.ccatRecord = obj1;
 //obj.AssignSolutionLead();
 obj1.Client_Name_Master__c=null;
 obj.ccatRecord = obj1;
 //obj.AssignSolutionLead();
 obj.getstatusOptionsNew();
 }

 test.stoptest();  
 }  




  /******************************
     * Method Name: setupData
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/ 
static testMethod void test6(){

test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
        testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name4);
        insert testUser1;

//Run As U1
System.RunAs(testUser1){
setupData00();


sapOMID = new SAP_OM_Opportunity__c();
sapOMID.Name='test';
sapOMID.Client_Name__c=clientName.id;
sapOMID.Client_Geo_Unit__c=clientGeoUnit.id;
sapOMID.Client_Geo_Area__c=clientGeoArea.id;
sapOMID.Operating_Group__c=operatingGroup.id;
sapOMID.TCV__c=45435;
sapOMID.Stage__c='2A';
sapOMID.Opportunity_Name__c='test';
sapOMID.Expected_contract_sign_Quarter__c='test';
sapOMID.Activity__c='Lost';
insert sapOMID ;
//ApexPages.StandardController controller;

testUserMaster = new Review_User_Master__c(Name = 'TestUserMaster1',Is_Active__c = true,Email_ID_of_the_reviewer__c = 'TestUserMaster@testorg.com',SFDC_User__c=testUser1.id);
 insert testUserMaster; 

oppTGP1 = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.Id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect_New__c=testUserMaster.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest');
insert oppTGP1;
  
 OSLassignmentController obj = new OSLassignmentController( );
 
 Opportunity_Solution_Lead_Task__c obj1=new Opportunity_Solution_Lead_Task__c( );
 obj1.Opportunity_Solution_Lead_New__c=testUserMaster.id;
 obj1.SAP_OM_Opportunity__c=sapOMID.id;
 obj1.Opportunity_TGP__c = sapOMID.Opportunity_Name__c;
 obj1.Client_Name_Master__c = clientName.id;
 insert obj1;
 
 obj.newOpp=oppTGP1;
 obj.newOpp1=oppTGP1;
 obj.ccatRecord = obj1;
 obj.Option = 'yes';
 
  obj.nextSection();
  obj.AssignSolutionLead();
  obj.sendEmailAlertToAssignedUser('Lead Solution Architect – BPO', testUser1.id, testUser1.name);
 }
  
    OSLassignmentController OSLassignmentObj = new OSLassignmentController();
    OSLassignmentObj.getSAPOMIDOptions();
    
    test.stoptest(); 
 }   
    
}