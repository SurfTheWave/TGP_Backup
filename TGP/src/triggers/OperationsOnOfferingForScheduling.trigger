trigger OperationsOnOfferingForScheduling  on Opportunity_Offering__c(after insert, after update,after delete) {

    /*List<Opportunity_Offering__c> lstNewOff = Trigger.new;
    List<Opportunity_Offering__c> lstOldOff = Trigger.old;
   
    if(trigger.isInsert && trigger.isAfter) {
        
        offeringTriggerController.insertSchedulingRec(lstNewOff );
    }
    if(trigger.isUpdate && trigger.isAfter) {
        
        offeringTriggerController.updateSchedulingRec(lstNewOff,lstOldOff);
    }
    if(trigger.isDelete && trigger.isAfter) {
        
        offeringTriggerController.deleteSchedulingRec(lstOldOff);
    }*/
}