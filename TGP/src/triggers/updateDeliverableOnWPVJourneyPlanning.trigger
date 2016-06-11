trigger updateDeliverableOnWPVJourneyPlanning on Journey_Management_Deliverable__c (after insert ,after update, after delete) 
{
    //if(Test.isRunningTest()==false)
    //{
        List<Journey_Management_Deliverable__c > lstOldDeliverable= Trigger.old;
        List<Journey_Management_Deliverable__c > lstNewDeliverable= Trigger.new;
        
        if(Trigger.isUpdate)
        {
            Mob_CascadeJourneyMasterChanges.CascadeJourneyDeliverableChangesOnUpdate(Trigger.old,Trigger.new);
        } 
        if(Trigger.isInsert)
        {
            Mob_CascadeJourneyMasterChanges.CascadeDeliverableMasterChangesOnInsert(Trigger.new);
        }   
        if(Trigger.isDelete)
        {
            Mob_CascadeJourneyMasterChanges.CascadeJourneyDeliverableChangesOnDelete(Trigger.old);
        }   
    //}    
}