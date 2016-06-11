/**
   @Author : Apoorva Sharma
   @name   : ActionItemTaskComplete
   @CreateDate : 09 Jan 2015 
   @Description : Close the Task related to actions items based on action item status.
   @Version : 1.0 
   Comment Added by-Reena Thakre on 21 Jan 2015
  */






    public with sharing class ActionItemTaskComplete {
    
    public static void actionTaskClose(List<Action_Item__c> rlist){
        Set<Id> actids = new Set<Id>();
        List<Task> taskstoupdate = new list<Task>();
       for(  action_item__c act : rlist){

      if((act.action_item_status__c == 'Completed' || act.action_item_status__c == 'on hold' || act.action_item_status__c == 'In Progress' ||act.action_item_status__c == 'Not Started' ||act.action_item_status__c == 'Next Stage' )) {

            actids.add(act.id);
        }

   }
     for(action_item__c act : [SELECT Id, (SELECT Id, Whatid, status FROM Tasks) from action_item__c Where Id in : actids]) {

        for(Task t : act.Tasks) {

            t.status= 'Completed';

            taskstoupdate.add(t);

        }

    }
    
    /* try-catch block added by Reena Thakre on 21 Jan 2015 */
  try{
    if(taskstoupdate.size()>0) {

        update taskstoupdate;
    }
    }
   catch(Exception e){
   //system.debug('-----'+e);
   }
    
   
  
   }

}