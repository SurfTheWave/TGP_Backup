trigger CostDetailTrigger on Costing_Request__c (before update) {
    CostDetailValidation.validateDates(trigger.new);
}