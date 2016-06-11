/*
Author : Vinay Kumar Chada
Story  : Story-0170/MOB_137 
Description : Test Class for saveOPEXVersionTrigger. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
@isTest
private with sharing class saveOPEXVersionTest {
    public static testMethod void testSaveOPEXVersion() {
    test.startTest();
             
       OPEX_Version__c ov = new OPEX_Version__c();
         ov.OPEX_Name__c='vinay';
         ov.isActive__c=true;
         insert ov;
       if(ov.isActive__c==true)
        {
           List<OPEX_Version__c > lstOPEXActive = [select isActive__c, id from OPEX_Version__c where isActive__c=true];
           for(OPEX_Version__c op: lstOPEXActive)
          {    
              op.isActive__c=false;
               upsert op;    
               system.assertEquals(false, op.isActive__c);                
          }
        }               
           test.stopTest();
    }
}