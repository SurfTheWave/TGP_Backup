trigger ScratchpadTrigger on Scratchpad_Opportunity__c (before update,before insert) {
    ScratchpadValidation.validateDates(trigger.new);
}