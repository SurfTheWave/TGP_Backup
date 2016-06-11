trigger updateItemOnWPV_SRAT on SRAT_Item_Master__c (after insert ,after update, after delete) 
{
    //if(Test.isRunningTest()==false)
   // {
        List<SRAT_Item_Master__c > lstOldItem= Trigger.old;
        List<SRAT_Item_Master__c > lstNewItem= Trigger.new;
        
        if(Trigger.isUpdate)
        {
            Mob_CascadeSRATMasterChanges.CascadeItemMasterChangesOnUpdate(Trigger.old,Trigger.new);
        }
        if(Trigger.isInsert)
        {
            Mob_CascadeSRATMasterChanges.CascadeItemMasterChangesOnInsert(Trigger.new);
        }
        if(Trigger.isDelete)
        {
            Mob_CascadeSRATMasterChanges.CascadeItemMasterChangesOnDelete(Trigger.old);
        }
    //}    
}