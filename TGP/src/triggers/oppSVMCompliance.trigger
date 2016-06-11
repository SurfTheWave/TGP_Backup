trigger oppSVMCompliance on Opportunity_SVM_Compliance__c (Before insert) {
    if(trigger.isInsert)
    {
        if(trigger.isBefore)
        {
            oppSVMComplianceController.deactivateOtherSVM(trigger.new);
        }
    }
}