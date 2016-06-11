global class MobUserReminder implements Schedulable {
   
    
    global void execute(SchedulableContext ctx) {
    
    MobUserReminderBatch mobsch = new MobUserReminderBatch();
    
    ID batchprocessid = Database.executeBatch(mobsch,25);
            }
 
    
}