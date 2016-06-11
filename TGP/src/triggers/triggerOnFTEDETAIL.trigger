/*
@Author and Created Date : System,  3/11/2015 6:28 AM
@name : triggerOnFTEDETAIL 
@Description : 
@Version : 
*/
trigger triggerOnFTEDETAIL on FTE_Details__c (after insert) {
list<FTE_Details__c> listToUpdate = new List<FTE_Details__c>();
if(trigger.isInsert)
{
    listToUpdate = [select id,Y1__c,Y2__c,Y3__c,Y4__c,Y5__c,Y6__c,Y7__c,Y8__c,Y9__c,Y10__c from FTE_Details__c where id IN: Trigger.newMap.keySet()];
    for(FTE_Details__c fteRec: listToUpdate)
    {    
        //fteRec.Y1_Y2_Y3_Y4_Y5__c=fteRec.Y1__c+UtilConstants.SLASH_OPRTR+fteRec.Y2__c+UtilConstants.SLASH_OPRTR+fteRec.Y3__c+UtilConstants.SLASH_OPRTR+fteRec.Y4__c+UtilConstants.SLASH_OPRTR+fteRec.Y5__c;
       // fteRec.Y6_Y7_Y8_Y9_Y10__c=fteRec.Y6__c+UtilConstants.SLASH_OPRTR+fteRec.Y7__c+UtilConstants.SLASH_OPRTR+fteRec.Y8__c+UtilConstants.SLASH_OPRTR+fteRec.Y9__c+UtilConstants.SLASH_OPRTR+fteRec.Y10__c;        
    }

        if(listToUpdate.size()>0){
            database.update(listToUpdate);
        }
    
}
}