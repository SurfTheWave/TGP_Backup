/*
Author : Shridhar Patankar
Story  : 
Description : Test Class for UAM_RoleSearchUtilityWebService.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class UAM_RoleSearchUtilityWebServiceTest{

 public static void setupData(){
 
 }
 static testMethod void testUploadOfferImageController(){
       test.starttest();
       String dealId;
       String strObjectType;
      //Boolean Mob_CheckUserRoleForNA = UAM_RoleSearchUtilityWebService.Mob_CheckUserRoleForNA(dealId,strObjectType);
      //Boolean Mob_CheckUserRoleForCreate= UAM_RoleSearchUtilityWebService.Mob_CheckUserRoleForCreate(dealId,strObjectType);
      //Boolean Mob_CheckUserRoleForRead = UAM_RoleSearchUtilityWebService.Mob_CheckUserRoleForRead(dealId,strObjectType);
      Boolean Mob_CheckUserRoleForUpdate= UAM_RoleSearchUtilityWebService.Mob_CheckUserRoleForUpdate(dealId,strObjectType);
       test.stoptest(); 
       
 }

}