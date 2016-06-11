/*
  @Author: Yasin Khan
  @Name: MobDealReminderBatchScheduler
  @Created Date: 16 Dec 2015
  @Description: Schedulabler for MobDealReminderBatch
  @version: 3.5 
*/

public class MobDealReminderBatchScheduler implements Schedulable{
    public void execute(SchedulableContext cts){
        MobDealReminderBatch  reminderBatch = new MobDealReminderBatch ();
        Database.executeBatch(reminderBatch,100);   
    }
}