trigger checkUAM_RAID_Decision on RAID_Decision__c(before insert, before update ,after update) {
    if(UAM_RoleSearchUtilityWebService.Mob_CheckUserRoleForUpdate(Trigger.new[0].Deal__c,'RAID_Decision__c')== false) {
        trigger.new[0].addError('Insufficient Privilege!'); 
    }
    List<RAID_Decision__c> lstNewRaidDecision = Trigger.new;
    List<RAID_Decision__c> lstOldRaidDecision = Trigger.old;
     boolean isRiskRefIdChanged = false;
     boolean isIssueRefIdChanged = false;
     RaidDecisionTriggerController controller = new RaidDecisionTriggerController();
    if(Trigger.isAfter && Trigger.isUpdate) {
     for(integer i=0;i<lstOldRaidDecision.size();i++ ){
            if(lstOldRaidDecision.get(i).Risk_Ref_ID__c != lstNewRaidDecision.get(i).Risk_Ref_ID__c || lstOldRaidDecision.get(i).Decision_Title__c != lstNewRaidDecision.get(i).Decision_Title__c ) {
                isRiskRefIdChanged=true;
                break;                
            }
        }
        if(isRiskRefIdChanged) {
            controller.updateRaidDecisionOnRaidRisk(lstOldRaidDecision,lstNewRaidDecision); 
        }   
    
        for(integer i=0;i<lstOldRaidDecision.size();i++ ){
            if(lstOldRaidDecision.get(i).Issue_Ref_ID__c != lstNewRaidDecision.get(i).Issue_Ref_ID__c || lstOldRaidDecision.get(i).Decision_Title__c != lstNewRaidDecision.get(i).Decision_Title__c ){
                isIssueRefIdChanged=true;
                break;                
            }
        }
        if(isIssueRefIdChanged) {
            controller.updateRaidDecisionOnRaidIssue(Trigger.new,Trigger.old);  
        }   
    }   
}