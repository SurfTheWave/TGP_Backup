/*
  @Author: Yasin Khan
  @Name: MobWaveTrackingScheduler
  @Created Date: 16 Dec 2015
  @Description: Schedulabler for MobWaveWaveProcessReminderBatch 
  @version: 3.5 
*/

public class MobWaveTrackingScheduler implements Schedulable{
    public void execute(SchedulableContext cts){
        MobWaveWaveProcessReminderBatch reminderBatch = new MobWaveWaveProcessReminderBatch('wave');
        Database.executeBatch(reminderBatch,100);   
    }
}