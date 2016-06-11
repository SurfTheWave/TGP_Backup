/*
Author : Accenture Team 
@date create -  
@version - 0.1 
Story :
Description : All the trigger operations on Request Review, generally used.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
*/
trigger UAMOperationsOnRequestReviewLog on Review_Action_Item_Log__c (after insert, after update, before delete) {

    UserAccessUtility uam = new UserAccessUtility();
    
    List<Review_Action_Item_Log__c> lstNewRReviewLog = Trigger.new;
    List<Review_Action_Item_Log__c> lstOldRReviewLog = Trigger.old;
    if(trigger.isUpdate && trigger.isAfter) {
        uam.CheckAccessReviewRequestLogDelete(lstOldRReviewLog);   
        uam.CheckAccessReviewRequestLog(lstNewRReviewLog); 
    }   

    /*After Insert Event */
    else if(trigger.isInsert && trigger.isAfter) {      
        uam.CheckAccessReviewRequestLog(lstNewRReviewLog);
    }
    /*Before Delete Event */
    else if(trigger.isdelete && trigger.isBefore) {
        uam.CheckAccessReviewRequestLogDelete(lstOldRReviewLog);        
    }
}