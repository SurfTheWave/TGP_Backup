trigger updatedCommentsOnBPOOpportunity on Comments_on_Opportunity__c (before update) {
    
    list<Comments_on_Opportunity__c> existCommentsList=[Select Comments__c,Created_Date__c,Created_by__c from Comments_on_Opportunity__c ];
/*
if(Trigger.isBefore){
    for(Comments_on_Opportunity__c commentsRecords:existCommentsList){
        system.debug('------existCommentsList-------->'+existCommentsList);
        system.debug('------trigger.New-------->'+Trigger.new);
        system.debug('------trigger.Old-------->'+Trigger.old);
    
    }
    
}   */
        

}