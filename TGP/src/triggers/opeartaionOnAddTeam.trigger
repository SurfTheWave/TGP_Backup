/*
@Author and Created Date : System,  2/20/2015 1:11 AM
@name : opeartaionOnAddTeam 
@Description : 
@Version : 
*/
trigger opeartaionOnAddTeam on Opportunity_Additional_Team__c(before insert, after update, before update, after delete, before delete) {

    if (trigger.isUpdate && trigger.isBefore) {
        UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +'--'+'Opp addiotnal team after update Trigger';
		system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue);
        operationOnAddTeam.getApproverRequsetUserMap(trigger.old);
        operationOnAddTeam.getApproverRequsetUserMap1(trigger.old);
        operationOnAddTeam.getoppTeammapIsChecked(trigger.old);
        //operationOnAddTeam.validateBeforeEdit(trigger.new);
    }
    if (trigger.isDelete && trigger.isBefore) {
        UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +'--'+'Opp addiotnal team  before delete Trigger';
		system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue);
        operationOnAddTeam.getApproverRequsetUserMap(trigger.old);
        operationOnAddTeam.getApproverRequsetUserMap1(trigger.old);
        operationOnAddTeam.getoppTeammapIsChecked(trigger.old);
        //operationOnAddTeam.validateBeforeDelete(trigger.old);
        operationOnAddTeam.getLatestRole(trigger.old);
        operationOnAddTeam.updateOpp(trigger.old,true);

    }

    if (trigger.isAfter) {
        if (trigger.isInsert || trigger.isUpdate) {
            UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +'--'+'Opp addiotnal team  after insert or update Trigger';
			system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue);
        
            operationOnAddTeam.getOpportunityRole(trigger.new);
            operationOnAddTeam.updateOpp(trigger.new,false);
        }
        
    }

}