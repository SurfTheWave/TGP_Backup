/*
 * @Author Accenture IDC Team
 * @CreatedDate 01/03/2014
 * @Description This Batch Apex is used to send bulk mail.
 */
global class Batch_SendEmailFor24HoursSchedule implements Database.Batchable<SObject> {
    
    private string query {get; set;}

    /*  
     * @method Overloaded constructor to initialize the batch query string
     * @param String q
     */
    global Batch_SendEmailFor24HoursSchedule(String q) {
        this.query=q; 
    }

    /* 
     * @method Initialize and returns the Database.QueryLocator
     * @param Database.BatchableContext context
     * @return Database.queryLocator   
     */
    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(query);
    }
    
    /* 
     * @method This method will create call method sendEmail24Hours of UTIL_SendEmailFor24HoursSchedule to perform the bulk mailing action.
     * @param  Database.BatchableContext context, List<Outbound_Email_User_Master__c> scope
     * @return Void   
     */ 
    global void execute(Database.BatchableContext context, List<Outbound_Email_User_Master__c> scope) {
        if(scope.size()>0){
            new UTIL_SendEmailFor24HoursSchedule().sendEmail24Hours(scope); // Pasing list of records
        }
    }

    /* 
     * @method This method is finish method.
     * @param  Database.BatchableContext context
     * @return void   
     */ 
    global void finish(Database.BatchableContext context){ 
        
    }
}