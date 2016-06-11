trigger updateActivityOnWPVCommercialPlan on Commercial_Plan_Activity_Master__c (after insert ,after update, after delete) 
{
        if(Trigger.isUpdate)
        {
            Mob_CascadeComercialActivityMasterChange.CascadeActivityMasterChangesOnUpdate(Trigger.old,Trigger.new);
        } 
        if(Trigger.isInsert)
        {
            Mob_CascadeComercialActivityMasterChange.CascadeActivityMasterChangesOnInsert(Trigger.new);
        }   
        if(Trigger.isDelete)
        {
            Mob_CascadeComercialActivityMasterChange.CascadeActivityMasterChangesOnDelete(Trigger.old);
        }
}