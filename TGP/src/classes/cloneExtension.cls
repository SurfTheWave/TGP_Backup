/*
Author : VINAY KUMAR CHADA
Story  :  Story-0096/MOB_018 
Description : SRAT Version Deep Cloneing  

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/

public with sharing class cloneExtension 
{
    //Variable to hold current record
    SRAT_VERSION__c currentRecord;
    
    //Standard constructor method
    public cloneExtension(ApexPages.StandardController controller) 
    {
        currentRecord = (SRAT_VERSION__c)controller.getRecord();
    }
    
    public PageReference cloneRecord()
    {
        //Variable to hold the new record
        SRAT_VERSION__c newRecord;       
       
        Savepoint sp = Database.setSavepoint();
        SRAT_VERSION__c newPO;
        try
        {
            currentRecord = [Select id, name, SRAT_Name__c from SRAT_VERSION__c where id =:currentRecord.id];
            newRecord = currentRecord.clone(false);
            currentRecord.isActive__c=false;
            insert newRecord; // inserted new SRAT version(Parent Data)
 
             // copy over the SRAT Section Name - (Child Data)
             List<SRAT_Section_Name__c> sRATSection= new List<SRAT_Section_Name__c>();
                 for (SRAT_Section_Name__c ss: [SELECT Id,Name,SRAT_Section_Name__c,SRAT_Version__c FROM  SRAT_Section_Name__c where SRAT_VERSION__c = :currentRecord.id]) 
                 {
                      SRAT_Section_Name__c newSRAT = ss.clone(false);
                      newSRAT.SRAT_Version__c = newRecord.id;
                      newSRAT.ExternalId__c = ss.Name;
                      sRATSection.add(newSRAT);
                 }
             insert sRATSection; // inserted new SRAT Section
                         
             
        // copy over the SRAT Sub Section Name   (Grand Child Data)
            List<SRAT_Sub_Section_Name__c > sRATSubSection= new List<SRAT_Sub_Section_Name__c >();
               for (SRAT_Section_Name__c sRATIds : sRATSection)
               {            
                 for (SRAT_Sub_Section_Name__c  subSection: [Select Id,Name, SRAT_Sub_Section_Name__c, SRAT_Section_Name__c From SRAT_Sub_Section_Name__c  where SRAT_Section_Name__r.SRAT_VERSION__r.id=:currentRecord.id  and SRAT_Section_Name__r.Name =:sRATIds.ExternalId__c])
                 {          
                      SRAT_Sub_Section_Name__c newSRATSub = subSection.clone(false);
                      newSRATSub.SRAT_Section_Name__c = sRATIds.id;
                      newSRATSub.ExternalId__c = subSection.Name;
                      sRATSubSection.add(newSRATSub);
                 }              
               }    
            insert sRATSubSection; // inserted new SRAT Sub Section Name
            
            // copy over the SRAT Sub Section Questionnaire (Gr Grand Child Data)
            List<SRAT_Sub_Section_Questionnaire__c> sRATSubSectionQuest= new List<SRAT_Sub_Section_Questionnaire__c >();
                for (SRAT_Sub_Section_Name__c sRATSubSecQuest : sRATSubSection)
                {
                     for (SRAT_Sub_Section_Questionnaire__c  subSectionQuest: [Select Id,Name,Title__c, Sort_Number__c, SRAT_Sub_Section_Id__c, Reference__c, Question_Description__c, Measurement__c, Category__c From SRAT_Sub_Section_Questionnaire__c where 
                                                                           SRAT_Sub_Section_Id__r.SRAT_Section_Name__r.SRAT_VERSION__r.id=:currentRecord.id  and SRAT_Sub_Section_Id__r.Name=:sRATSubSecQuest.ExternalId__c])
                     {     
                          SRAT_Sub_Section_Questionnaire__c newSRATSubSecQuest = subSectionQuest.clone(false);
                          newSRATSubSecQuest.SRAT_Sub_Section_Id__c = sRATSubSecQuest.id;
                          sRATSubSectionQuest.add(newSRATSubSecQuest);
                     }
                 }
            insert sRATSubSectionQuest; // inserted new SRAT Sub Section Questionnaire
            
            
            // Below Code belongs to 2nd Grand Chid for the Parent Object            
            // copy over the SRAT Section Questionnaire (Grand Chid Data)
            List<SRAT_Section_Questionnaire__c > sRATSectionQuest= new List<SRAT_Section_Questionnaire__c >();
            for (SRAT_Section_Name__c ssq : sRATSection)
            {        
                 for (SRAT_Section_Questionnaire__c  sRATSecQuest: [Select Title__c, Sort_Order__c, SRAT_Section_Name__c, Question_Description__c, Name, Id From SRAT_Section_Questionnaire__c  where SRAT_Section_Name__r.SRAT_VERSION__r.id=:currentRecord.id  and SRAT_Section_Name__r.Name =:ssq.ExternalId__c])
                 {     
                      SRAT_Section_Questionnaire__c newSRATSecQuest = sRATSecQuest.clone(false);
                      newSRATSecQuest.SRAT_Section_Name__c = ssq.id;
                      sRATSectionQuest.add(newSRATSecQuest);
                 }
            }
            insert sRATSectionQuest; // inserted new SRAT Section Questionnaire
        
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