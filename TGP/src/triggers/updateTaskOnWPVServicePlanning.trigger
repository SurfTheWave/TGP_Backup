trigger updateTaskOnWPVServicePlanning on Service_Management_Task_Master__c(after insert ,after update, after delete) 
{
    //if(Test.isRunningTest()==false)
    //{
        List<Service_Management_Task_Master__c> lstOldDeliverable= Trigger.old;
        List<Service_Management_Task_Master__c> lstNewDeliverable= Trigger.new;
        
        if(Trigger.isUpdate)
        {
            Mob_CascadeServiceManMasterChanges.CascadeJourneyDeliverableChangesOnUpdate(Trigger.old,Trigger.new);
        } 
        if(Trigger.isInsert)
        {
            Mob_CascadeServiceManMasterChanges.CascadeDeliverableMasterChangesOnInsert(Trigger.new);
        }   
        if(Trigger.isDelete)
        {
            Mob_CascadeServiceManMasterChanges.CascadeJourneyDeliverableChangesOnDelete(Trigger.old);
        }   
    //}    
}