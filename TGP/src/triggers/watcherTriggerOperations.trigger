/**
   @Author :Apoorva Sharma
   @name   : watcherTriggerOperations 
   @CreateDate : 17 November 2015 
   @Description : This trigger is used for performing operations on watchers.
   @Version : 1.0 
  */
trigger watcherTriggerOperations on Watcher__c (before insert,after insert) {
    
    if(trigger.isafter && trigger.isInsert){
        WatchersOperations.sendMailToAddedWatcher(trigger.new);
    }
    if(trigger.isbefore && trigger.isInsert && UtilConstantsR3.runaddWatcher){
        WatchersOperations.addWatchers(trigger.new);
        //WatchersOperations.sendMailToAddedWatcher(trigger.new);
    }
}