/*
Author : Accenture Team 
@date create -  
@version - 0.1 
Story :
Description : All the trigger operations on Request Review, generally used.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
*/
trigger UAMOperationsOnRequestReview on Request_Review__c (after insert, after update, before delete) {

    UserAccessUtility uam = new UserAccessUtility();
    
    List<Request_Review__c> lstNewRReview = Trigger.new;
    List<Request_Review__c> lstOldRReview = Trigger.old;
    if(trigger.isUpdate && trigger.isAfter) {
        uam.CheckAccessReviewRequestDelete(lstOldRReview);   
        uam.CheckAccessReviewRequest(lstNewRReview); 
    }   

    /*After Insert Event */
    else if(trigger.isInsert && trigger.isAfter) {      
        uam.CheckAccessReviewRequest(lstNewRReview);
    }
    /*Before Delete Event */
    else if(trigger.isdelete && trigger.isBefore) {
        uam.CheckAccessReviewRequestDelete(lstOldRReview);        
    }
    
}