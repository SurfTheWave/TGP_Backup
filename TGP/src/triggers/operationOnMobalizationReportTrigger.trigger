/*
@Author and Created Date : jyotsna yadav,  3/28/2015 2:23 AM     
@name : operationOnMobalizationReportTrigger 
@Description : Update the query string field on Mobilization report for dynamic URL functionality
@Version : 1.0
*/
trigger operationOnMobalizationReportTrigger on Mob_Reports__c(after insert,after update) {
    
     if( trigger.isAfter ){
        if( trigger.isInsert  || trigger.isUpdate ){
            if( !UtilConstants.IS_RECURSIVE ){
                operOnMobReportTriggerCntlr.createReportURL( trigger.new );
            }
        }
    }        
}