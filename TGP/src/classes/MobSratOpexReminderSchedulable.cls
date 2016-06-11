global class MobSratOpexReminderSchedulable implements Schedulable {
   
            global String query;
            global string obj;
            
    global void execute(SchedulableContext ctx) {
            query='sevendays';
            system.debug('query:'+query);
            obj='SRAT_Tracker__c';
    
            MobSratOpexReminderBatch  reminderBatch = new MobSratOpexReminderBatch(query,obj);
            ID batchprocessid = Database.executeBatch(reminderBatch,200);
    }    
}