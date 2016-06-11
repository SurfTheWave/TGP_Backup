trigger updateTaskOnWPVBusinessContinuityPlanning on BCP_Task_Master__c (after insert ,after update, after delete) 
{
    
       List<BCP_Task_Master__c > lstOldDeliverable= Trigger.old;
        List<BCP_Task_Master__c > lstNewDeliverable= Trigger.new;
        
        if(Trigger.isUpdate)
        {
            Mob_CascadeBusinessMasterChanges.CascadeBusinessTaskChangesOnUpdate(Trigger.old,Trigger.new);
        } 
        if(Trigger.isInsert)
        {
            Mob_CascadeBusinessMasterChanges.CascadeTaskMasterChangesOnInsert(Trigger.new);
        }   
        if(Trigger.isDelete)
        {
            Mob_CascadeBusinessMasterChanges.CascadeBusinessTaskChangesOnDelete(Trigger.old);
        }   
    
}