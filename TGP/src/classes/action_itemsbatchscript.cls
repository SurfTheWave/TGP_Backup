/***************
run this script to insert tasks for Action Item scripts which are not completed
********************/
global class action_itemsbatchscript implements Database.Batchable<sObject>,database.stateful{

        // Start Method
        global Database.QueryLocator start(Database.BatchableContext BC){
        string filter = 'Completed';
        String query = 'SELECT Id, Primary_Owner__c, action_item_status__c FROM Action_Item__c where action_item_status__c!=\''+filter+'\'';
        
         return Database.getQueryLocator(query);
        }
      
      // Execute Logic
    global void execute(Database.BatchableContext BC, List<Action_Item__c >scope){
    List<task> task_tosave = new List<task>();
    task ts;
    
    for(Action_Item__c appreq: scope){
    ts = new task();
    
    ts.ownerid = [select id from user where name='System' limit 1].id;
    ts.subject = 'Opportunity Approval';
    ts.ActivityDate = system.today();
    ts.whatid = appreq.id;
    ts.status = 'Not Started';
    ts.priority = 'Normal';
    task_tosave.add(ts);
    }  
     Savepoint sp = Database.setSavepoint();
    try{
    insert task_tosave;
    }
    catch(Exception e){
    system.debug('exception::::::;'+e);
     Database.rollback(sp);
    }
}
     
       global void finish(Database.BatchableContext BC){
            // Logic to be Executed at finish
       }
}