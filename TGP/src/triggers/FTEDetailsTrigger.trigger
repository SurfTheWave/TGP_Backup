trigger FTEDetailsTrigger on FTE_Details__c (before insert,after insert) {
    if(UtilConstants.stopTriggersForIO){
    if(trigger.isInsert && trigger.isBefore){
        for(FTE_Details__c fteRec: trigger.new)
        {    
            fteRec.Y1_Y2_Y3_Y4_Y5__c=fteRec.Y1__c+UtilConstants.SLASH_OPRTR+fteRec.Y2__c+UtilConstants.SLASH_OPRTR+fteRec.Y3__c+UtilConstants.SLASH_OPRTR+fteRec.Y4__c+UtilConstants.SLASH_OPRTR+fteRec.Y5__c;
            fteRec.Y6_Y7_Y8_Y9_Y10__c=fteRec.Y6__c+UtilConstants.SLASH_OPRTR+fteRec.Y7__c+UtilConstants.SLASH_OPRTR+fteRec.Y8__c+UtilConstants.SLASH_OPRTR+fteRec.Y9__c+UtilConstants.SLASH_OPRTR+fteRec.Y10__c;        
        }
    
        if(trigger.new[0].Service_Group__c.equalsIgnoreCase('BPO')){
        FTEDetailsTriggerOperations.insertDeliveryLocation(trigger.new,trigger.new[0].Opportunity__c);
        }
        else{
        FTEDetailsTriggerOperations.insertDeliveryLocationIO(trigger.new,trigger.new[0].Opportunity__c);
        //IOMonth_Count ioCount= new IOMonth_Count();
        //ioCount.countMonthFTE(trigger.new);
        }
        
     }   
    }
    //if(UtilConstants.stopTriggersForIO){
        if(trigger.isInsert && trigger.isAfter){
            set<id> fteids=new set<id>();
            for(FTE_Details__c fte:trigger.new){
               fteids.add(fte.id); 
            }
            
            FTEDetailsTriggerOperations.populateDeliveryLocationBPOSE(fteids);
         //}
     }
}