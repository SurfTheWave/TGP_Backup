global class Batch_SchedulingDateInsertSchedule implements Database.Batchable<SObject> {
    
    private string query {get; set;}

    /*  
     * @method Overloaded constructor to initialize the batch query string
     * @param String q
     */
    global Batch_SchedulingDateInsertSchedule(String q) {
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
    global void execute(Database.BatchableContext context, List<Opportunity_TGP__c> scope) {
        if(scope.size()>0){
            new UTIL_SchedulingDateInsert().insertSchedulingDate(scope); // Pasing list of records
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