trigger updatePhaseOnWPVServicePlanning on Service_Management_Master__c (after update) 
{
    
        List<Service_Management_Master__c > lstOldSection= Trigger.old;
        List<Service_Management_Master__c > lstNewSection= Trigger.new;
        
        if(Trigger.isUpdate) {
            Mob_CascadeServiceManMasterChanges.CascadeServiceManMasterChangesOnUpdate(Trigger.old,Trigger.new);
        }
     
}