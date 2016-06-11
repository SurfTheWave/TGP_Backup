trigger updateActivityOnWPV_OPEX on OPEX_Item_master__c (after insert ,after update, after delete) 
{
   
        List<OPEX_Item_Master__c > lstOldItem= Trigger.old;
        List<OPEX_Item_Master__c > lstNewItem= Trigger.new;
        
        if(Trigger.isUpdate)
        {
            Mob_CascadeOPEXMasterChanges.CascadeItemMasterChangesOnUpdate(Trigger.old,Trigger.new);
        }
        if(Trigger.isInsert)
        {
            Mob_CascadeOPEXMasterChanges.CascadeItemMasterChangesOnInsert(Trigger.new);
        }
        if(Trigger.isDelete)
        {
            Mob_CascadeOPEXMasterChanges.CascadeItemMasterChangesOnDelete(Trigger.old);
        }
        
}