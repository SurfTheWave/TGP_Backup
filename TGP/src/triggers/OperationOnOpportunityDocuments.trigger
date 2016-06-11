/*
@Author and Created Date : System,  3/10/2015 5:26 AM
@name : OperationOnOpportunityDocuments 
@Description : 
@Version : 
*/
trigger OperationOnOpportunityDocuments on opportunity_documents__c(before delete, after insert) {

    if (trigger.isInsert) {
        OperationsOnOpportunityDocuments.insertDocument(trigger.new);
    }

    if (trigger.isBefore) {
        if (trigger.isDelete) {
            OperationsOnOpportunityDocuments.validatedeleteforOpportunityDocument(trigger.old);
        }
    }
}