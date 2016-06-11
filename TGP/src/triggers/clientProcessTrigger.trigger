trigger clientProcessTrigger on Client_Specific_Process__c (after insert,after delete,after update) {

    //List<Client_Specific_Process__c> clientProcessList=new List<Client_Specific_Process__c>(); 
    //List<Client_Specific_Process__c> clientProcessDeleteList=new List<Client_Specific_Process__c>(); 
    
    if(trigger.isInsert && trigger.isAfter || trigger.isAfter && trigger.isUpdate){
        Deal.updateOffering(trigger.new);
    }
    else if(trigger.isDelete && trigger.isAfter)    {
        Deal.updateOffering(trigger.old);
    }
    
}