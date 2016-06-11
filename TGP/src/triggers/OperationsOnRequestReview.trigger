/*
Author : Accenture Team 
@date create -  
@version - 0.1 
Story :
Description : All the trigger operations on Request Review, generally used.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
*/
trigger OperationsOnRequestReview on Request_Review__c (after update, before delete) {
    List<Request_Review__c> listOldRequestReview=trigger.old;
    List<Request_Review__c> listNewRequestReview=trigger.new;
    /*Before Delete Event*/
    if(Trigger.isDelete && Trigger.isBefore)
    { 
        RequestReviewTriggerController.DeleteReview(listOldRequestReview);
    }
    /*After Update Event*/
    else if(Trigger.isUpdate && Trigger.isAfter) {
         RequestReviewTriggerController.sendApprovalResponseMail(listNewRequestReview, listOldRequestReview);
         //RequestReviewTriggerController.sendApprovalResponseMailToRequestor(listNewRequestReview, listOldRequestReview);
         RequestReviewTriggerController.updateReviewStage(listNewRequestReview);
         RequestReviewTriggerController.sendAlertToFinalApprover(listNewRequestReview, listOldRequestReview);
        
    }
}