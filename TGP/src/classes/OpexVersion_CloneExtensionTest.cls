/*
Author : VINAY KUMAR CHADA
Story  :  Story-0063/MOB_024 
Description : OPEX Version Deep Cloneing OpexVersion_CloneExtensionTest class

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class OpexVersion_CloneExtensionTest {
public ID newRecordId {get;set;}
     static testMethod void testOPEXCloneExtController() {
     
         // setup a reference to the page the controller is expecting with the parameters
        PageReference pref = Page.opexVersion_Clone;
        Test.setCurrentPage(pref);
        
         // create new po record
        OPEX_Version__c  opexVer= new OPEX_Version__c  ();
        opexVer.OPEX_Name__c  = 'Test Class';
        opexVer.isActive__c=true;
        upsert opexVer;
                 
        OPEX_Section_Name__c   opexSection = new OPEX_Section_Name__c  ();
        opexSection.OPEX_Version__c  = opexVer.id;
        opexSection.OPEX_Section_Name__c  ='Test';
        opexSection.ExternalId__c = opexVer.Name;
        insert opexSection; 
        
        OPEX_Section_Questionnaire__c opexSecQuest = new OPEX_Section_Questionnaire__c();
        opexSecQuest.OPEX_Section_Name__c = opexSection.id;
        opexSecQuest.Question_No__c =10;
        opexSecQuest.Sort_Number__c = 10;
        insert opexSecQuest;

                 
        // Construct the standard controller
        ApexPages.StandardController con = new ApexPages.StandardController(opexVer);
 
        // create the controller
        OpexVersion_CloneExtension ext = new OpexVersion_CloneExtension(con);
 
       // Switch to test context
        Test.startTest();
 
        // call the cloneWithItems method
        PageReference ref = ext.cloneRecord();
        // create the matching page reference
       // PageReference redir = new PageReference('/'+ext.newRecordId+'/e?retURL=%2F'+ext.newRecordId);
        
          // Switch back to runtime context
        Test.stopTest();
     }
}