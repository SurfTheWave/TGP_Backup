trigger updateUserRolesOnDeal on Mob_User_Roles_Master__c (after insert, after update, after delete) 
{
       if(Trigger.isInsert)
        {
            Mob_CascadeUserRoleChanges.CascadeUserRoleChangesOnInsert(Trigger.new);
        }
        else if(Trigger.isUpdate)
        {
            Mob_CascadeUserRoleChanges.CascadeUserRoleChangesOnUpdate(Trigger.old,Trigger.new);
        }
        else if(Trigger.isDelete)
        {
            Mob_CascadeUserRoleChanges.CascadeUserRoleChangesOnDelete(Trigger.old);
        }
}