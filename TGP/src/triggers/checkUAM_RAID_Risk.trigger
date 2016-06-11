trigger checkUAM_RAID_Risk on RAID_Risk__c(before insert, before update) 
{
    if(UAM_RoleSearchUtilityWebService.Mob_CheckUserRoleForUpdate(Trigger.new[0].Deal__c,'RAID_Risk__c')== false)
    {
        trigger.new[0].addError('Insufficient Privilege!'); 
    }
}