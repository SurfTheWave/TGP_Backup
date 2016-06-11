trigger checkUAM_RAID_Issue on RAID_Issue__c(before insert, before update) 
{
        if(UAM_RoleSearchUtilityWebService.Mob_CheckUserRoleForUpdate(Trigger.new[0].Deal__c,'RAID_Issue__c')== false)
        {
            trigger.new[0].addError('Insufficient Privilege!'); 
        }
    
}