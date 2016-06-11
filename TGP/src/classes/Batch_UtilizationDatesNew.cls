/*
 * @Author Jayashree Pradhan
 * @CreatedDate 6th Feb,2015
 * @Description This Batch Apex is used to update utilization data.
 */
global class Batch_UtilizationDatesNew implements Database.Batchable<SObject> {
    
    private string query {get; set;}

    /*  
     * @method Overloaded constructor to initialize the batch query string
     * @param String q
     */
    global Batch_UtilizationDatesNew (String q) {
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
     * @method This method will create call method updateData of UTIL_UtilizationDataUpdate to perform the bulk updation of records.
     * @param  Database.BatchableContext context, List<Outbound_Email_User_Master__c> scope
     * @return Void   
     */ 
    global void execute(Database.BatchableContext context, List<Utilization_weekStartDate__c> scope) {
        if(scope.size()>0){
            new UTIL_UtilizationDataUpdateNew().updateDateInCustomSetting(scope); // Parsing list of records
        }
    }

    /* 
     * @method This method is finish method.
     * @param  Database.BatchableContext context
     * @return void   
     */ 
    global void finish(Database.BatchableContext context){ 
        //Blank update on PTO
        Database.executeBatch(new Batch_UtilizationPTOUpdate()); 
    }
}