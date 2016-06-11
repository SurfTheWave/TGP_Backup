trigger updateSectionOnWPVBusinessContinuityPlanning on BCP_Section_Master__c (after update) 
{
    if(Trigger.isUpdate) {
            Mob_CascadeBusinessMasterChanges.CascadeBusinessMasterChangesOnUpdate(Trigger.old,Trigger.new);
        }
}