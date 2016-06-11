/*
Author : VINAY KUMAR CHADA
Story  :  Story-0063/MOB_024 
Description : OPEX Version Deep Cloneing  

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/

public with sharing class OpexVersion_CloneExtension {

     //Variable to hold current record
    OPEX_Version__c currentRecord;
       
    //Standard constructor method
    public OpexVersion_CloneExtension (ApexPages.StandardController controller) 
    {
        currentRecord = (OPEX_Version__c)controller.getRecord();
    }
   
    public PageReference cloneRecord()
    {
        //Variable to hold the new record
        OPEX_Version__c newRecord;       
       
        Savepoint sp = Database.setSavepoint();

        try
        {   
            //Parent Record Clone.
            currentRecord = [Select id, name, OPEX_Name__c from OPEX_Version__c where id =:currentRecord.id];
            newRecord = currentRecord.clone(false);
            newRecord.isActive__c=false; 
            insert newRecord; // inserted new SRAT version(Parent Data)
            
             // copy over the OPEX Section Name - (Child Data)
             List<OPEX_Section_Name__c> opexSection= new List<OPEX_Section_Name__c>();
                 for (OPEX_Section_Name__c ops: [SELECT Id,Name,OPEX_Section_Name__c,OPEX_Version__c FROM  OPEX_Section_Name__c where OPEX_Version__c = :currentRecord.id]) 
                 {
                      OPEX_Section_Name__c newOPEX = ops.clone(false);
                      newOPEX.OPEX_Version__c = newRecord.id;
                      newOPEX.ExternalId__c = ops.Name;
                      opexSection.add(newOPEX);
                 }
             insert opexSection; // inserted new OPEX Section
             
             
              // copy over the OPEX Sub Section Name   (Grand Child Data)
            List<OPEX_Section_Questionnaire__c> oPexSectionQuest= new List<OPEX_Section_Questionnaire__c>();
               for (OPEX_Section_Name__c oPEXSectionIds : opexSection)
               {            
                 for (OPEX_Section_Questionnaire__c  oPEXSecQuest: [Select Id,Name, Being_Prepared_Go_Live__c, Being_Used_day_7__c, Ok_day_60__c, Ok_day_90__c, Question_Description__c, Stability_Day_30__c, OPEX_Section_Name__c, Question_No__c, Sort_Number__c From OPEX_Section_Questionnaire__c  where OPEX_Section_Name__r.OPEX_Version__r.id=:currentRecord.id  and OPEX_Section_Name__r.Name =:oPEXSectionIds.ExternalId__c])
                 {          
                      OPEX_Section_Questionnaire__c newOPEXSecQuest = oPEXSecQuest.clone(false);
                      newOPEXSecQuest.OPEX_Section_Name__c = oPEXSectionIds.id;
                      oPexSectionQuest.add(newOPEXSecQuest);
                 }              
               }    
            insert oPexSectionQuest; // inserted new OPEX Sub Section Name          
             
        }
        catch(Exception e)
        {
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }
        return new PageReference('/'+newRecord.id);
    }
}