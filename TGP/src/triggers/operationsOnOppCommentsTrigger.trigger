/**
   @Author         : Komal Priya
   @Trigger name   : operationsOnOppCommentsTrigger
   @CreateDate     : 22 December 2014
   @Description    : Trigger to update records on Opportunity object.
   @Version        : 1.0
  */

trigger operationsOnOppCommentsTrigger on Opportunity_Comments__c(after insert,after update,after delete) {

    if(trigger.isInsert){
        
        operationsOnOppCommentsTriggerController.updateOpportunityRecords(Trigger.New);
        
    }
    if(trigger.isUpdate){
        
        operationsOnOppCommentsTriggerController.updateOpportunityRecords(Trigger.New);
        
    }
    if(trigger.isDelete){
        
        operationsOnOppCommentsTriggerController.deleteCommentsRecords(Trigger.Old);
        
    }
    

}