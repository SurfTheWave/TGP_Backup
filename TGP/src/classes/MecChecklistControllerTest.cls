/*
Author : Malkeet Singh
Story  :   
Description : Test Class for MecChecklistController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class MecChecklistControllerTest{
static Deal_TGP__c deal;
static Opportunity_TGP__c oppTGP;
static User testUser;
static User testUser1; 
static Operating_Group_Master__c operatingGroup;
static Client_Master__c clientName;
static Client_Geo_Area_Master__c clientGeoArea;
static Client_Geo_Unit_Master__c clientGeoUnit;
static MOB_User_Role_Assignment__c MoURA;
static Mob_User_Roles_Master__c MoURM;
static String USER_Name = 'vc7@testorg.com';
public static void setupData1(){

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

Profile p =  UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
      	testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
      	Database.insert(testUser, false);
      
Profile p1 =  UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
      	testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
      	Database.insert(testUser1, false);
      
      
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
oppTGP.Enterprise_Solution_Architect__c=testUser1.id ;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';
insert oppTGP;

// To create a Mob User Role Master
MoURM=new Mob_User_Roles_Master__c();
MoURM.Access_Level__c='Edit';
MoURM.Role_Name__c='Governance Lead1';

insert MoURM;
///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Opportunity_ID__c=oppTGP.id;
deal.Has_Gov_Lead_Submitted__c=false;
deal.Governance_Lead_Name_Secondary__c=UserInfo.getUserId();
deal.Has_Mob_Architect_Saved__c=false;
deal.Has_Mob_Architect_Submitted__c=false;
insert deal;

// To create a Mob User Role Assignment
MoURA=new MOB_User_Role_Assignment__c();
MoURA.Access_Level__c='Edit';
MoURA.Deal__c=deal.id;
MoURA.User_Assigned__c=testUser.id;
MoURA.Role_Name__c='Governance Lead1';
MoURA.Mob_User_Roles_Master__c=MoURM.id;

insert MoURA;

}

public static void setupData2(){

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
      
Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
      	testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
      	Database.insert(testUser1, false);
      
      
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
oppTGP.Enterprise_Solution_Architect__c=testUser1.id ;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';
insert oppTGP;
///To create a Deal



// To create a Mob User Role Master
MoURM=new Mob_User_Roles_Master__c();
MoURM.Access_Level__c='Edit';
MoURM.Role_Name__c='Governance Lead1';

insert MoURM;

deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Opportunity_ID__c=oppTGP.id;
deal.Has_Gov_Lead_Submitted__c=false;
deal.Governance_Lead_Name_Secondary__c=UserInfo.getUserId();
deal.Has_Mob_Architect_Saved__c=true;
deal.Has_Mob_Architect_Submitted__c=false;
insert deal;





// To create a Mob User Role Assignment
MoURA=new MOB_User_Role_Assignment__c();
MoURA.Access_Level__c='Edit';
MoURA.Deal__c=deal.id;
MoURA.User_Assigned__c=testUser.id;
MoURA.Role_Name__c='Governance Lead1';
MoURA.Mob_User_Roles_Master__c=MoURM.id;

insert MoURA;


}
public static void setupData3(){

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
      
Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
      	testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
      	Database.insert(testUser1, false);
      
      
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
oppTGP.Enterprise_Solution_Architect__c=testUser1.id ;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';
insert oppTGP;

// To create a Mob User Role Master
MoURM=new Mob_User_Roles_Master__c();
MoURM.Access_Level__c='Edit';
MoURM.Role_Name__c='Governance Lead1';

insert MoURM;
///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Opportunity_ID__c=oppTGP.id;
deal.Has_Gov_Lead_Submitted__c=false;
deal.Governance_Lead_Name_Secondary__c=UserInfo.getUserId();
deal.Has_Mob_Architect_Saved__c=true;
deal.Has_Mob_Architect_Submitted__c=true;
insert deal;








// To create a Mob User Role Assignment
MoURA=new MOB_User_Role_Assignment__c();
MoURA.Access_Level__c='Edit';
MoURA.Deal__c=deal.id;
MoURA.User_Assigned__c=testUser.id;
MoURA.Role_Name__c='Governance Lead1';
MoURA.Mob_User_Roles_Master__c=MoURM.id;

insert MoURA;


}
public static void setupData4(){

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
      
Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
      	testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
      	Database.insert(testUser1, false);
      
      
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
oppTGP.Enterprise_Solution_Architect__c=testUser1.id ;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';
insert oppTGP;
// To create a Mob User Role Master
MoURM=new Mob_User_Roles_Master__c();
MoURM.Access_Level__c='Edit';
MoURM.Role_Name__c='Governance Lead1';

insert MoURM;


///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Opportunity_ID__c=oppTGP.id;
deal.Has_Gov_Lead_Submitted__c=true;
deal.Governance_Lead_Name_Secondary__c=UserInfo.getUserId();
deal.Has_Mob_Architect_Saved__c=true;
deal.Has_Mob_Architect_Submitted__c=true;
insert deal;



// To create a Mob User Role Assignment
MoURA=new MOB_User_Role_Assignment__c();
MoURA.Access_Level__c='Edit';
MoURA.Deal__c=deal.id;
MoURA.User_Assigned__c=testUser.id;
MoURA.Role_Name__c='Governance Lead1';
MoURA.Mob_User_Roles_Master__c=MoURM.id;

insert MoURA;


}

public static void setupData5(){

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
      
Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
      	testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,USER_Name);
      	Database.insert(testUser1, false);
      
      
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
oppTGP.Enterprise_Solution_Architect__c=testUser1.id ;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';
insert oppTGP;

// To create a Mob User Role Master
MoURM=new Mob_User_Roles_Master__c();
MoURM.Access_Level__c='Edit';
MoURM.Role_Name__c='Governance Lead1';

insert MoURM;

///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Opportunity_ID__c=null;
deal.Has_Gov_Lead_Submitted__c=true;
deal.Governance_Lead_Name_Secondary__c=UserInfo.getUserId();
deal.Has_Mob_Architect_Saved__c=true;
deal.Has_Mob_Architect_Submitted__c=true;
insert deal;



// To create a Mob User Role Assignment
MoURA=new MOB_User_Role_Assignment__c();
MoURA.Access_Level__c='Edit';
MoURA.Deal__c=deal.id;
MoURA.User_Assigned__c=testUser.id;
MoURA.Role_Name__c='Governance Lead1';
MoURA.Mob_User_Roles_Master__c=MoURM.id;

insert MoURA;

}
public static void setupData6(){

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
      
Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
      	testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,UTIL_Constants.USER_NAME);
      	Database.insert(testUser1, false);
      
      
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
oppTGP.Enterprise_Solution_Architect__c=testUser1.id ;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';
insert oppTGP;

// To create a Mob User Role Master
MoURM=new Mob_User_Roles_Master__c();
MoURM.Access_Level__c='Edit';
MoURM.Role_Name__c='Governance Lead1';

insert MoURM;

///To create a Deal

deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Opportunity_ID__c=oppTGP.id;
deal.Has_Gov_Lead_Submitted__c=true;
deal.Governance_Lead_Name_Secondary__c=UserInfo.getUserId();
deal.Has_Mob_Architect_Saved__c=true;
deal.Has_Mob_Architect_Submitted__c=true;
insert deal;

// To create a Mob User Role Assignment
MoURA=new MOB_User_Role_Assignment__c();
MoURA.Access_Level__c='Edit';
MoURA.Deal__c=deal.id;
MoURA.User_Assigned__c=testUser.id;
MoURA.Role_Name__c='Governance Lead1';
MoURA.Mob_User_Roles_Master__c=MoURM.id;

insert MoURA;


}

static testMethod void test1(){
test.starttest();
setupData1();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,deal.id);
 
 MecChecklistController obj = new MecChecklistController( controller);
 obj.getMecChecklistPage();
 obj.getMecReadOnlyPage();
 obj.getRadioItems();
 
 test.stoptest();
 }  

 
  static testMethod void test2(){
test.starttest();
setupData2();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,deal.id);
 
 MecChecklistController obj = new MecChecklistController( controller);
 obj.getMecChecklistPage();
 obj.getMecReadOnlyPage();
 obj.getRadioItems();
 
 test.stoptest();
  }  
    static testMethod void test3(){
test.starttest();
setupData3();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,deal.id);
 
 MecChecklistController obj = new MecChecklistController( controller);
 obj.getMecChecklistPage();
 obj.getMecReadOnlyPage();
 obj.getRadioItems();
 
 test.stoptest();
  }  
    static testMethod void test4(){
test.starttest();
setupData4();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('Id' ,deal.id);
 
 MecChecklistController obj = new MecChecklistController( controller);
 obj.getMecChecklistPage();
 obj.getMecReadOnlyPage();
 obj.getRadioItems();
 
 test.stoptest();
  }  
      static testMethod void test5(){
test.starttest();
setupData4();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,deal.id);
apexpages.currentpage().getparameters().put('ItemValue' ,'tab1');
 
 MecChecklistController obj = new MecChecklistController( controller);
 obj.getMecChecklistPage();
 obj.getMecReadOnlyPage();
 obj.getRadioItems();
 
 test.stoptest();
  }  
static testMethod void test6(){
test.starttest();
setupData5();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,deal.id);
apexpages.currentpage().getparameters().put('itemValue' ,'tab2');
 
 MecChecklistController obj = new MecChecklistController( controller);
 obj.getMecChecklistPage();
 obj.getMecReadOnlyPage();
 obj.getRadioItems();
 
 test.stoptest();
  }
  static testMethod void test7(){
test.starttest();
setupData4();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,'123456789123456789');

 
 MecChecklistController obj = new MecChecklistController( controller);
 obj.getMecChecklistPage();
 obj.getMecReadOnlyPage();
 obj.getRadioItems();
 
 test.stoptest();
  }
    static testMethod void test8(){
test.starttest();
setupData4();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,null);

 
 MecChecklistController obj = new MecChecklistController( controller);
 obj.getMecChecklistPage();
 obj.getMecReadOnlyPage();
 obj.getRadioItems();
 
 test.stoptest();
  } 
 }