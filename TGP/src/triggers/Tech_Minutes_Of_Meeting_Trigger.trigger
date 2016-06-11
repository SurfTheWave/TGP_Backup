trigger Tech_Minutes_Of_Meeting_Trigger on Tech_Minutes_Of_Meeting__c (before insert) {
    if(trigger.isInsert && trigger.isBefore){
        TechApprovalRequestOperations.addMOM(trigger.new);
    }
}