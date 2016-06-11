/*
    Author : Muthukumar
    Story  :   
    Description : Test Class for  Mob_PrepopulateUserRoles

    Updated by        Story no.                Update Date        Update details
    ------------    -----------------        --------------    -------------------------------------------------------------
*/
@isTest
private class Mob_PrepopulateUserRoles_Test {
	static list<Deal_TGP__c> dealTGPList=new  list<Deal_TGP__c>();
	static list <MOB_User_Role_Assignment__c> mobUserRolelist=new list<MOB_User_Role_Assignment__c>();
	/******************************
	    Method Name: setupData
	    Description: setup the scenario data for code coverange  
	    Paramenters: NA
	    Return Value: void 
    *******************************/
	static void setupData(){
// To Create Deal record
		Deal_TGP__c dealData=new Deal_TGP__c();
		dealData.Opportunity_Name__c='TestOpportunity';
		database.insert(dealData);
		dealTGPList.add(dealData);
// To Create Review User Master	record
		Review_User_Master__c reviewUserMaster=new Review_User_Master__c();
		reviewUserMaster.First_Name__c='Test';
		reviewUserMaster.Last_Name__c='User';
		reviewUserMaster.Is_Active__c=true;
		reviewUserMaster.isUserActive__c=true;
		reviewUserMaster.SFDC_User__c=Userinfo.getUserId();
		database.insert(reviewUserMaster);
// To Create Mob User Roles Master record	
		Mob_User_Roles_Master__c mobUserRoleMaster=new Mob_User_Roles_Master__c();
		mobUserRoleMaster.Role_Name__c='Governance Lead';
		mobUserRoleMaster.Access_Level__c='edit';
		database.insert(mobUserRoleMaster);
// To Create Mob User Role Assignment record
		MOB_User_Role_Assignment__c mobUserRoleAssignment=new MOB_User_Role_Assignment__c();
	    mobUserRoleAssignment.Deal__c=dealData.id;
		mobUserRoleAssignment.Mob_User_Roles_Master__c=mobUserRoleMaster.Id;
		mobUserRoleAssignment.Access_Level__c='edit';
		mobUserRoleAssignment.Role_Name__c='Governance Lead';
		mobUserRoleAssignment.User_Assigned_New__c=reviewUserMaster.id;
		database.insert(mobUserRoleAssignment);
		mobUserRolelist.add(mobUserRoleAssignment);
		
	}
//This method created for insert user role record
	static testMethod void insertUserRoles(){
		setupdata();
		Mob_PrepopulateUserRoles mobPrepopUserRole=new Mob_PrepopulateUserRoles();
		mobPrepopUserRole.insertUserRoles(dealTGPList);
	}

}