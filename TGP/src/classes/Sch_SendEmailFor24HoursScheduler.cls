/*
 * @Author Accenture IDC Team
 * @CreatedDate 1/3/2014
 * @Description This Schedulable class created to Schedulable class to schedule 
                Batch_SendEmailFor24HoursSchedule batch apex and to send bulk mails. 
 *              The per batch size is being set to 50.
 */
global class Sch_SendEmailFor24HoursScheduler  implements Schedulable {
    
    //Query string
    private static final String QUERY = 'select id, name, Email_ID__c, Outbound_Email_User_Name__c, Active__c, Comments__c from Outbound_Email_User_Master__c where Active__c = true';

    /* 
     * @method It starts the Batch_SendEmailFor24HoursSchedule batch apex              
     * @param SchedulableContext
     * @return Void   
     */
    global void execute(SchedulableContext context) {
           //Initializing the batch process
            //TO-DO The batch size should go into a custom settings
        Database.executeBatch(new Batch_SendEmailFor24HoursSchedule(QUERY), 50); 
    }
}