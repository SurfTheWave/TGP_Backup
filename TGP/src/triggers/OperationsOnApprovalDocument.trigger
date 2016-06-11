trigger OperationsOnApprovalDocument on approval_documents__c (Before Insert) {
     if(trigger.IsInsert){
       if(trigger.IsBefore){
          OperationsOnApprovalDocumentController.populateLinkToSharePoint(trigger.new);
          OperationsOnApprovalDocumentController.duplicateApprovalDocuments(trigger.new);
       }
     }
}