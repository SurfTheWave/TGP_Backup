/*
@Author and Created Date : System,  2/18/2015 7:35 AM
@name : SSRTTrigger 
@Description : 
@Version : 
*/
trigger SSRTTrigger on SSRT_Content_Management_Request__c (after insert,after update,after delete) {
SSRTTriggerHandlerClass handler = new SSRTTriggerHandlerClass();
    if(SSRTTriggerHandlerClass.runOnce()){
         if(trigger.isInsert){
            handler.insertOppTeam(trigger.new);
             handler.performInsertLogic(trigger.new,true);
         }
        else if(trigger.isupdate){
            handler.insertOppTeam(trigger.new);
            handler.performUpdateLogic(trigger.oldmap,trigger.new);
        }
         else if(trigger.isdelete){
            handler.deleteOppTeam(trigger.old);
         }
    }
}