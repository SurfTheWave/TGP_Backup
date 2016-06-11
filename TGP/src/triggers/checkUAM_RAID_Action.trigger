trigger checkUAM_RAID_Action on RAID_Action__c (before insert, before update,after update) 
{    
  if(UAM_RoleSearchUtilityWebService.Mob_CheckUserRoleForUpdate(Trigger.new[0].Deal__c,'RAID_Action__c')== false){
        trigger.new[0].addError('Insufficient Privilege!'); 
    }
    List<RAID_Action__c> lstNewRaidAction = Trigger.new;
    List<RAID_Action__c> lstOldRaidAction = Trigger.old;
     boolean isRiskRefIdChanged = false;
     boolean isIssueRefIdChanged = false;
     RaidActionTriggerController controller = new RaidActionTriggerController();
    if(Trigger.isAfter && Trigger.isUpdate) {
     for(integer i=0;i<lstOldRaidAction.size();i++ )
        {
            if(lstOldRaidAction.get(i).Risk_Ref_ID__c != lstNewRaidAction.get(i).Risk_Ref_ID__c || lstOldRaidAction.get(i).Action_Title__c!= lstNewRaidAction.get(i).Action_Title__c)
            {
                isRiskRefIdChanged=true;
                
                break;                
            }
        }
        if(isRiskRefIdChanged) {
            controller.updateRaidActionOnRaidRisk(lstOldRaidAction,lstNewRaidAction);   
        }   
    
     for(integer i=0;i<lstOldRaidAction.size();i++ )
        {
            if(lstOldRaidAction.get(i).Issue_Ref_ID__c != lstNewRaidAction.get(i).Issue_Ref_ID__c || lstOldRaidAction.get(i).Action_Title__c!= lstNewRaidAction.get(i).Action_Title__c)
            {
                isIssueRefIdChanged=true;
                break;                
            }
        }
        if(isIssueRefIdChanged) {
            controller.updateRaidActionOnRaidIssue(Trigger.new,Trigger.old);    
        }   
    }   
}