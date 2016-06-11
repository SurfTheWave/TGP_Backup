/*
@Author and Created Date : System,  2/19/2015 5:05 AM 
@name : operationOnUserMasterNew 
@Description : 
@Version : 
*/
trigger operationOnUserMasterNew on User_Master__c (after insert) {
     if(trigger.isInsert && trigger.isAfter) {
        OperationOnUserMasterNewController.createdummyRec(trigger.new);
    }
}