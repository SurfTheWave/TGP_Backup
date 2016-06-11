/*
@Author and Created Date : IO Solution Editor,  1/10/2015 1:21 AM
@name : ReviewRequest 
@Description : 
@Version : 
*/
trigger ReviewRequest on Review_Request__c (after insert,after update) {
 if(trigger.isAfter){
   if(trigger.IsInsert){
   ReviewRequestController.sendMailToReviewer(trigger.new);
   }
 if(trigger.isUpdate){
   ReviewRequestController.sendMailToApprover(trigger.new);
 }
 }
}