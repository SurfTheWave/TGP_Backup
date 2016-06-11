/*
Author : Sushmanth Hasti
Story  :   
Description : Test Class for SubmitforApproval. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class SubmitForApprovalTest{
static Deal_TGP__c deal;
static User testUser;
static MOB_User_Role_Assignment__c MoURA;
static Mob_User_Roles_Master__c MoURM; 
static Review_User_Master__c revUser;
   static String USER_Name = 'vc7@testorg.com';
    static String USER_Name1 = 'vc71@testorg.com';
     static String USER_Name2 = 'vc712@testorg.com';

public static void setupData(){



/// To create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name);
Database.insert(testUser, false);



 ///To create a Deal
/*deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Is_Submitted__c=true;

insert deal;*/
}
public static void setupData1(){



/// To create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name1);
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
MoURA.User_Assigned__c=testUser.id;
MoURA.Role_Name__c='Governance Lead1';
MoURA.Mob_User_Roles_Master__c=MoURM.id;

insert MoURA;

}


public static void setupData2(){



/// To create a Test User

        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name2);
        insert testUser;
        
        revUser = UTIL_DataCreationForTestClass.getReviewUserMaster('xyz@abc.com','test');
        revUser.Is_Active__c = true;
        insert revUser;
        


 ///To create a Deal
deal =new Deal_TGP__c();
deal.Name='Test Data';
deal.Is_Submitted__c=false;
deal.Governance_Lead_Name_New__c=revUser.id;
insert deal;
}

static testMethod void test(){
test.starttest();
setupData();
ApexPages.StandardController controller;

//apexpages.currentpage().getparameters().put('Id' ,deal.id);
 
SubmitForApproval obj = new SubmitForApproval();
SubmitForApproval.approvalMethod('test');

 test.stoptest();
  } 
  static testMethod void test1(){
test.starttest();
setupData1();
//ApexPages.StandardController controller;

//apexpages.currentpage().getparameters().put('Id' ,deal.id);
 
SubmitForApproval obj = new SubmitForApproval();
SubmitForApproval.approvalMethod(deal.id);

 test.stoptest();
  }  
  
  
  static testMethod void test2(){
test.starttest();
setupData2();
//ApexPages.StandardController controller;

//apexpages.currentpage().getparameters().put('Id' ,deal.id);
 
SubmitForApproval obj = new SubmitForApproval();
SubmitForApproval.approvalMethod(deal.id);

 test.stoptest();
  }  
  
  static testMethod void test3(){
test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
System.RunAs(testUser){
setupData2();
//ApexPages.StandardController controller;

//apexpages.currentpage().getparameters().put('Id' ,deal.id);
 
SubmitForApproval obj = new SubmitForApproval();
SubmitForApproval.approvalMethod(deal.id);

 test.stoptest();
  }  
  }

//Run As U1

}