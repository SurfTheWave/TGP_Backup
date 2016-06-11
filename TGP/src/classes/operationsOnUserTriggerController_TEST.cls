/*
* @Author : Jyotsna 
* @Description : Test class for  User trigger helper class
* @Version : 1.0                
*/
@isTest
private class operationsOnUserTriggerController_TEST {

    //Class constant varibale definition
   
    /************************************************************************************************
    * Method Name: testAfterInsert
    * Description: creates test data and test after insert scenario of the trigger
    *************************************************************************************************/   
    public static testMethod void testAfterInsert(){    
        UserLicense uL = [Select Id,Name from UserLicense where Name='Salesforce' limit 1];
        Profile p =  [Select Id,Name from Profile where UserLicenseId=:uL.Id and Name='System Administrator' limit 1];
        User_Master__c userMaster=new User_Master__c(email__c='1235237@test.com',name='Test');
        insert userMaster;
        
        test.startTest();
        User testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,'1235237@test.com','test@testorg.com');
        insert testUser;
        User testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,'jkfhj73264@abc.com','test1@testorg.com');
        insert testUser1;
        testUser.email='jkfhj73264435@abc.com';
        update testUser;
        test.stopTest();
        List<User_Master__c> userMasterList1 = [Select Id,email__c from User_Master__c where email__c=:testUser.email Limit 1];
        //system.debug('**************'+userMasterList1);
        system.assertequals(1,userMasterList1.size());
        
        List<User_Master__c> userMasterList = [Select Id from User_Master__c ];
        //system.assertequals(2,userMasterList.size());        
    }
    
    /************************************************************************************************
    * Method Name: testAfterUpdate
    * Description: creates test data and test after update scenario of the trigegr
    *************************************************************************************************/   
   /* public static testMethod void testAfterUpdate(){
    
        UserLicense uL = [Select Id,Name from UserLicense where Name='Salesforce' limit 1];
        Profile p =  [Select Id,Name from Profile where UserLicenseId=:uL.Id and Name='System Administrator' limit 1];
        User testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,'jhfu94r@TGP.com','testnew@testorg.com');
        //
        
        test.startTest();
        insert testUser;
        //update newUser;
        test.stopTest();
        User newUser = [Select Id,email from User where Id=:testUser.Id];
        newUser.isActive= false;
        update newUSer;
        List<User_Master__c> userMasterList = [Select Id,email__c from User_Master__c where user__c=:newUser.Id];
       // system.assertequals('test@test1org.com',userMasterList[0].email__c);
    
    }*/
   
}