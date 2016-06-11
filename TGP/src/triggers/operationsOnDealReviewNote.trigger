/*
@Author and Created Date : jyotsna yadav,  3/2/2015 5:05 AM
@name : operationsOnDealReviewNote 
@Description : 
@Version : 
*/
trigger operationsOnDealReviewNote on Deal_Review_Notes__c (before insert, after insert,before update) {
    operationsOnDealReviewNoteController.oldMap = trigger.oldMap;
    operationsOnDealReviewNoteController.newMap = trigger.newMap;
    if(trigger.isInsert){
        if(trigger.isAfter){
            operationsOnDealReviewNoteController.validateBeforeInsertUpdate(trigger.new);
        }
    }
    if(trigger.isUpdate){
        Boolean isUpdate = false;
        if(trigger.isBefore){
            for( Deal_Review_Notes__c deal : trigger.new ){
                if( trigger.oldMap.get( deal.Id ).Approval_Stage__c != deal.Approval_Stage__c ){
                    isUpdate = true;
                }
            }
            if( isUpdate ){
                operationsOnDealReviewNoteController.validateBeforeInsertUpdate(trigger.new );
            }
             operationsOnDealReviewNoteController.validateBeforeInsertUpdate(trigger.new );
            
        }
    }
    
}