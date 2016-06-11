global class MobOpexReminderSchedulable implements Schedulable {
   
            global String query;
            global string obj;
            
    global void execute(SchedulableContext ctx) {
            query='sevendays';
            system.debug('query:'+query);
            obj='OPEX_Tracker__c';
    
            MobOpexReminderBatch reminderBatch = new MobOpexReminderBatch(query,obj);
            ID batchprocessid = Database.executeBatch(reminderBatch,200);
    }    
}