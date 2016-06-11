/*
Author : Vinay Kumar Chada
Story  : Story-0161/MOB_133 
Description : Test Class for saveSRATVersionTrigger. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/

@isTest
private with sharing class saveSRATVersionTest {
    public static testMethod void testSaveOPEXVersion() {
    test.startTest();
        
      
       SRAT_VERSION__c sv = new SRAT_VERSION__c();
        //Fields Initialization
        sv.SRAT_Name__c='vinay';
         sv.isActive__c=true;
         insert sv;
       if(sv.isActive__c==true)
        {
           List<SRAT_VERSION__c > lstSRATActive = [select isActive__c, id from SRAT_VERSION__c where id=:'a14L0000000N6sx'];
           for(SRAT_VERSION__c sv1: lstSRATActive)
          {    
              sv1.isActive__c=false;
               upsert sv1;    
              // system.assertEquals(false, sv1.isActive__c);                
          }
           sv.Active_Modified_Date__c =date.today(); 
          }               
           test.stopTest();

            
    }
}