trigger updateActivityOnWPVTechAssessment on Tech_Assessment_Activity_Master__c (after insert ,after update,after delete)
{
    //if(Test.isRunningTest()==false)
    //{
        List<Tech_Assessment_Activity_Master__c> lstOldActivity= Trigger.old;
        List<Tech_Assessment_Activity_Master__c> lstNewActivity= Trigger.new;
        
        if(Trigger.isUpdate)
        {
            Mob_CascadeTechActivityMasterChanges.CascadeActivityMasterChangesOnUpdate(Trigger.old,Trigger.new);
        }
        if(Trigger.isInsert)
        {
            Mob_CascadeTechActivityMasterChanges.CascadeActivityMasterChangesOnInsert(Trigger.new);
        }
        if(Trigger.isDelete)
        {
            Mob_CascadeTechActivityMasterChanges.CascadeActivityMasterChangesOnDelete(Trigger.old);
        }
    //}    
}