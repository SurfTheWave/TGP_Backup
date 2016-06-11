/*
 * @Author Accenture IDC Team
 * @CreatedDate 1/3/2014
 * @Description This Schedulable class created to Schedulable class to schedule. 
 */
global class Sch_UtilizationDataUpdateScheduler  implements Schedulable {
    
    //Query string
    private static final String QUERY = 'select id, Current_week__c, Current_week_1__c, Current_week_2__c, Current_week_3__c, Current_week_4__c from Utilization__c';
    private static final String QUERY_CUSTOMSETTING = 'select Name, Id, ReferenceDate__c from Utilization_Date__c';
    /* 
     * @method It starts the Sch_UtilizationDataUpdateScheduler            
     * @param SchedulableContext
     * @return Void   
     */
    global void execute(SchedulableContext context) {
           //Initializing the batch process
            //TO-DO The batch size should go into a custom settings
        Database.executeBatch(new Batch_Utilization(QUERY), 200);
        Database.executeBatch(new Batch_UtilizationDates(QUERY_CUSTOMSETTING),10); 
    }
}