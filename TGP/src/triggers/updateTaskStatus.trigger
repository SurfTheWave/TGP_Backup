trigger updateTaskStatus on Task (Before Update,Before Insert) {

    List<Task> taskList = new List<Task>();
    
     for(Task taskRec : Trigger.new){
         
         if(taskRec.Approval_Status__c == 'Approved' || taskRec.Approval_Status__c == 'Rejected' || taskRec.Approval_Status__c == 'Reject' || taskRec.Approval_Status__c == 'Ready For Review' || taskRec.Approval_Status__c == 'Rework'){
         
             taskRec.Status = 'Completed';
             taskList.add(taskRec);
         
         }
     
     }

}