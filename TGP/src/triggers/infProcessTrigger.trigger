trigger infProcessTrigger on Infrastructure_Service__c (after insert,after update,after delete) {
    //List<Infrastructure_Service__c> infProcessList=new List<Infrastructure_Service__c>(); 
    //List<Infrastructure_Service__c> infProcessDeleteList=new List<Infrastructure_Service__c>(); 

    
    if(trigger.isInsert && trigger.isAfter || trigger.isAfter && trigger.isUpdate){
        Deal.updateOffering(trigger.new);
    }
    else if(trigger.isDelete && trigger.isAfter)    {
        Deal.updateOffering(trigger.old);
    }
    
    
}