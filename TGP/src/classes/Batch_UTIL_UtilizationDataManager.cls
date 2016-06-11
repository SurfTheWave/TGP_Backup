/*
 * @Author Accenture IDC Team
 * @Description This Batch Apex is used to insert the data in Utilization object.
 * @Version 1.0
 */
global class Batch_UTIL_UtilizationDataManager implements Database.Batchable<SObject> {
    
    private string query {get; set;}

    /*  
     * @method Overloaded constructor to initialize the batch query string
     */
    global Batch_UTIL_UtilizationDataManager() {
        this.query= 'SELECT Id from Review_User_Master__c'; 
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
     * @method This method will call the utility class to process the record insert
     * @param  Database.BatchableContext context, List<Opportunity_TGP__c> scope
     * @return Void   
     */ 
    global void execute(Database.BatchableContext context, List<Review_User_Master__c> scope) {
        if(scope.size()>0){
            new UTIL_UtilizationDataManager().insertUtilizationRecordsforDummyOpp(scope); // Pasing list of records
        }
    }

    /* 
     * @method finish
     * @param  Database.BatchableContext context
     * @return void   
     */ 
    global void finish(Database.BatchableContext context){ 
    
    }
}