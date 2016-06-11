trigger oppClientDepTrigger on Opportunity_Client_Dependency__c (after insert) {
    if(trigger.isAfter){
        if(trigger.isInsert){
        	ShareWithOppTeam.newClientDep(trigger.new);    
        }    
    }
}