trigger updateActivityOnWPVRecruitTracking on Activity_Master__c (after insert ,after update,after delete)
{
    //if(Test.isRunningTest()==false)
    //{
        List<Activity_Master__c> lstOldActivity= Trigger.old;
        List<Activity_Master__c> lstNewActivity= Trigger.new;
        
        if(Trigger.isUpdate)
        {
            Mob_CascadeActivityMasterChanges.CascadeActivityMasterChangesOnUpdate(Trigger.old,Trigger.new);
        }
        if(Trigger.isInsert)
        {
            Mob_CascadeActivityMasterChanges.CascadeActivityMasterChangesOnInsert(Trigger.new);
        }
        if(Trigger.isDelete)
        {
            Mob_CascadeActivityMasterChanges.CascadeActivityMasterChangesOnDelete(Trigger.old);
        }
    //}    
}