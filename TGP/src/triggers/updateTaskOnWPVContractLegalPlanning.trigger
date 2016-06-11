trigger updateTaskOnWPVContractLegalPlanning on Contract_Legal_Infosec_Task_Master__c (after insert ,after update, after delete) 
{
    //if(Test.isRunningTest()==false)
    //{
        List<Contract_Legal_Infosec_Task_Master__c > lstOldDeliverable= Trigger.old;
        List<Contract_Legal_Infosec_Task_Master__c > lstNewDeliverable= Trigger.new;
        
        if(Trigger.isUpdate)
        {
            Mob_CascadeContractLegalMasterChanges.CascadeJourneyTaskChangesOnUpdate(Trigger.old,Trigger.new);
        } 
        if(Trigger.isInsert)
        {
            Mob_CascadeContractLegalMasterChanges.CascadeTaskMasterChangesOnInsert(Trigger.new);
        }   
        if(Trigger.isDelete)
        {
            Mob_CascadeContractLegalMasterChanges.CascadeJourneyTaskChangesOnDelete(Trigger.old);
        }   
    //}    
}