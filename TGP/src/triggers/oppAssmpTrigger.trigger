trigger oppAssmpTrigger on Opportunity_Assumption__c (after insert) {
if(trigger.isAfter){
        if(trigger.isInsert){
          ShareWithOppTeam.newAssmp(trigger.new);    
        }    
    }
}