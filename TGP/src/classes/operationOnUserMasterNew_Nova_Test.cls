/**
 * Name : operationOnUserMasterNew_Nova_Test
 * Author : NovaCop Unit Test Generator
 * Description : Test class used for testing the operationOnUserMasterNew
 * Date : 3/20/15 5:35 PM 
 * Version : <intial Draft> 
 * TODO : This code is auto-generated. Developer should update the inputs for unit tests as well as expected results in assertions
 */
@isTest
private class operationOnUserMasterNew_Nova_Test { 
      static testMethod void userMasterNewTest() {
         UnitTestDatafactory.createOpportunityRecord('Out Of Office');  
         UnitTestDatafactory.createOpportunityRecord('Other Deal Support');  
         User_Master__c userMaster = new User_Master__c(user__c=userinfo.getUserID(),email__c='test@test.com');
         test.startTest();
         insert userMaster;
         test.stopTest();
    }
}