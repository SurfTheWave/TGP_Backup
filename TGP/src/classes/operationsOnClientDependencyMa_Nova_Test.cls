/**
 * Name : operationsOnClientDependencyMa_Nova_Test
 * Author : NovaCop Unit Test Generator
 * Description : Test class used for testing the operationsOnClientDependencyMaster
 * Date : 3/24/15 11:17 AM 
 * Version : <intial Draft> 
 * TODO : This code is auto-generated. Developer should update the inputs for unit tests as well as expected results in assertions
 */
@isTest
private class operationsOnClientDependencyMa_Nova_Test { 
     static testMethod  void testoperationsOnClientDependencyMaster(){
     Offering_Master__c offObj = new Offering_Master__c(offering_description__c = 'Test', 
                                                        flywheel_non_flywheel__c = 'Random');
     Database.insert(offObj);
        Client_Dependencies_Master__c client_dependencies_mastercTest =  new 
                                                Client_Dependencies_Master__c(offering__c = offObj.id);
        insert client_dependencies_mastercTest;
        delete client_dependencies_mastercTest;
    }
}