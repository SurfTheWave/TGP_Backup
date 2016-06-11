/**
   @Author :Apoorva Sharma
   @name   : TechApprovalDocumentsTrigger 
   @CreateDate : 26 November 2015 
   @Description : This trigger is used for performing operations on Tech Approval Document.
   @Version : 1.0 
  */
trigger TechApprovalDocumentsTrigger on Tech_Approval_Documents__c (after insert, after update, before delete, before insert, before update) {
     if(trigger.IsInsert){
       if(trigger.IsBefore){
          TechApprovalDocumentsOperations.populateLinkToSharePoint(trigger.new);
          TechApprovalDocumentsOperations.duplicateApprovalDocuments(trigger.new);
       }
     }
}