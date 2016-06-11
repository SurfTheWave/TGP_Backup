/*
 * @Author Accenture IDC Team
 * @CreatedDate 1/3/2014
 * @Description This Schedulable class created to Schedulable class to schedule 
                Batch_SendEmailFor24HoursSchedule batch apex and to send bulk mails. 
 *              The per batch size is being set to 50.
 */
global class Sch_SchedulingDateUpdateScheduler  implements Schedulable {
    
    //Query string
    private static final String QUERY = 'select id, MondayDate__c ,MondayDate_1__c,MondayDate_2__c,MondayDate_3__c,isDateActive__c ,name, Current_week__c, Current_week_1__c, Current_week_2__c, Current_week_3__c,First_Date__c from Scheduling__c';

    /* 
     * @method It starts the Batch_SendEmailFor24HoursSchedule batch apex              
     * @param SchedulableContext
     * @return Void   
     */
    global void execute(SchedulableContext context) {
           //Initializing the batch process
            //TO-DO The batch size should go into a custom settings
        Database.executeBatch(new Batch_SchedulingDateUpdateSchedule(QUERY), 50); 
    }
}