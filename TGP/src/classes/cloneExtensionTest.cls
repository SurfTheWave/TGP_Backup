/*
Author : Vinay Kumar Chada
Story  : Story-0096/MOB_018
Description : Test Class for cloneExtension. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class cloneExtensionTest {
public ID newRecordId {get;set;}
     static testMethod void testCloneExtController() {
     
         // setup a reference to the page the controller is expecting with the parameters
        PageReference pref = Page.CloneRecord;
        Test.setCurrentPage(pref);
        
        // create new record for SRAT_VERSION__c 
        SRAT_VERSION__c sv= new SRAT_VERSION__c ();
        sv.SRAT_Name__c = 'Test Class';
        sv.isActive__c=true;
        sv.Active_Modified_Date__c =date.today();
        insert sv;
                        
        // create new record for SRAT_Section_Name__c
        SRAT_Section_Name__c  sSection = new SRAT_Section_Name__c ();
        sSection.SRAT_Version__c = sv.id;
        sSection.ExternalId__c = sv.Name;
        insert sSection; 
        
        // create new record for SRAT_Sub_Section_Name__c 
        SRAT_Sub_Section_Name__c newSRATSub = new SRAT_Sub_Section_Name__c();
        newSRATSub.SRAT_Section_Name__c = sSection.id;
        newSRATSub.ExternalId__c = sSection.Name;
        insert newSRATSub;
        
        // create new record for SRAT_Sub_Section_Questionnaire__c 
        SRAT_Sub_Section_Questionnaire__c newSRATSubSecQuest = new SRAT_Sub_Section_Questionnaire__c();
        newSRATSubSecQuest.SRAT_Sub_Section_Id__c = newSRATSub.id;
        newSRATSubSecQuest.Sort_Number__c=10;
        insert newSRATSubSecQuest;    
        
        // create new record for SRAT_Section_Questionnaire__c 
        SRAT_Section_Questionnaire__c newSRATSecQuest = new SRAT_Section_Questionnaire__c ();
        newSRATSecQuest.SRAT_Section_Name__c = sSection.id;
        newSRATSecQuest.Sort_Order__c=10;
        insert newSRATSecQuest;      
                 
        // Construct the standard controller
        ApexPages.StandardController con = new ApexPages.StandardController(sv);
 
        // create the controller
        cloneExtension ext = new cloneExtension (con);
 
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