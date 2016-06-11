trigger operationOnPtoTrigger on PTO__c (after insert,after update,before delete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            
            //OperationOnPtoTriggerController.populateUtilization(Trigger.new);
            OperationOnPtoTriggerController.populateUser(Trigger.new);
            //OperationOnPtoTriggerController.calculatePto(Trigger.new);
        }
        if(Trigger.isUpdate){ 
            OperationOnPtoTriggerController.calculatePto(Trigger.new);
        }
         
    } 
   if(Trigger.isDelete){ 
            OperationOnPtoTriggerController.calculatePto(Trigger.old);
        }
    
}