trigger OtherCostTrigger on Other_Cost_Details__c (before insert,after insert) {
 System.debug('invoke outside');
    if(UtilConstants.stopTriggersForIO){
    System.debug('invoke inside');
    if(trigger.isInsert && trigger.isBefore){
        //mapping missing techtools
        if(trigger.new[0].source__c.EqualsIgnoreCase('Sync')){
        OtherCostTriggerOperation.mapMissingTechTool(trigger.new,trigger.new[0].Opportunity__c);
        
        //mapping missing delivery location
        if(trigger.new[0].Service_Group__c.equalsIgnoreCase('BPO')){
        OtherCostTriggerOperation.insertDeliveryLocation(trigger.new,trigger.new[0].Opportunity__c);
        }
        else{
        System.debug('invoke othercost delivery location');
        OtherCostTriggerOperation.insertDeliveryLocationIO(trigger.new,trigger.new[0].Opportunity__c);
        //IOMonth_Count ioCount= new IOMonth_Count();
        //ioCount.countMonthFTE(trigger.new);
        }
      /*  else{
            //IOMonth_Count ioCount= new IOMonth_Count();
            //ioCount.countMonthOtherCost(trigger.new);
        }
        
        */
        
        }
      }
    }
    //if(UtilConstants.stopTriggersForIO){
   // if(trigger.isInsert && trigger.isAfter){
        
        //populating deliverlylocationBpose from other cost
         OtherCostTriggerOperation.populateDeliveryLocationBPOSE(trigger.new);
   // }
    
   //}
}