/*
Author :  Malkeet Singh
Story  :
Description : Test Class for Mob_CascadeUserRoleChanges

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
@isTest
private class Mob_CascadeUserRoleChangesTest
{
    static User testUser; 
    static Deal_TGP__c deal;
     static Mob_User_Roles_Master__c strMoURM; 
    static MOB_User_Role_Assignment__c strMoURA;
    static List<Mob_User_Roles_Master__c> lstOld = new List<Mob_User_Roles_Master__c>();
    static  List<Mob_User_Roles_Master__c> lstNew = new List<Mob_User_Roles_Master__c>();
    
    public static void setupData()
    {
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
		testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
      	insert testUser;
        
        deal=new Deal_TGP__c(Name='DealTest123');
        insert deal;
        
        strMoURM=new Mob_User_Roles_Master__c(Access_Level__c='Edit',Role_Name__c='Governance Lead1');
        insert strMoURM;
        lstOld.add(strMoURM);

        strMoURM=new Mob_User_Roles_Master__c(Access_Level__c='Edit',Role_Name__c='Governance Lead2');
        insert strMoURM;
        lstNew.add(strMoURM);
        
        strMoURA=new MOB_User_Role_Assignment__c(Access_Level__c='Edit',Deal__c=deal.id,User_Assigned__c=testUser.id,Role_Name__c='Governance Lead1',Mob_User_Roles_Master__c=strMoURM.id);
        insert strMoURA;
    } 
static testMethod void testInsert()
{
    test.starttest();
    setupData();
    Mob_CascadeUserRoleChanges.CascadeUserRoleChangesOnInsert(lstOld);
    test.stoptest();
      
}
static testMethod void testUpdate()
{
    test.starttest();
    setupData();
    Mob_CascadeUserRoleChanges.CascadeUserRoleChangesOnUpdate(lstold,lstNew);
    test.stoptest();
      
}
static testMethod void testDelete()
{
    test.starttest();
    setupData();
    Mob_CascadeUserRoleChanges.CascadeUserRoleChangesOnDelete(lstold);
    test.stoptest();
      
}
  
}