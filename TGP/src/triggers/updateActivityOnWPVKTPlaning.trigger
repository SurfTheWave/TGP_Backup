trigger updateActivityOnWPVKTPlaning  on KT_Planning_Activity_Master__c (after insert ,after update,after delete) {
    List<KT_Planning_Activity_Master__c > lstOldActivity= Trigger.old;
    List<KT_Planning_Activity_Master__c > lstNewActivity= Trigger.new;
    
    if(Trigger.isUpdate) {
        Mob_CascadeKTPlanActivityMasterChanges.CascadeActivityMasterChangesOnUpdate(Trigger.old,Trigger.new);
    }
    if(Trigger.isInsert) {
        Mob_CascadeKTPlanActivityMasterChanges.CascadeActivityMasterChangesOnInsert(Trigger.new);
    }
    if(Trigger.isDelete) {
        Mob_CascadeKTPlanActivityMasterChanges.CascadeActivityMasterChangesOnDelete(Trigger.old);
    }
     
}