/*
 * @Author Jayashree Pradhan
 * @CreatedDate 01/03/2014
 * @Description This Batch Apex is used to update utilization data.
 */
global class Batch_UtilizationNew implements Database.Batchable<SObject> {
    
    private string query {get; set;}

    /*  
     * @method Overloaded constructor to initialize the batch query string
     * @param String q
     */
    global Batch_UtilizationNew (String q) {
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
    global void execute(Database.BatchableContext context, List<Utilizations__c> scope) {
        //system.debug('scope record::::::::::'+scope);
        if(scope.size()>0){
            new UTIL_UtilizationDataUpdateNew().updateData(scope); // Parsing list of records
        }
    }

    /* 
     * @method This method is finish method.
     * @param  Database.BatchableContext context
     * @return void   
     */ 
    global void finish(Database.BatchableContext context){ 
       String QUERY_CUSTOMSETTING = 'select Name, Id, Referenced_Date__c from Utilization_weekStartDate__c';
       Database.executeBatch(new Batch_UtilizationDatesNew(QUERY_CUSTOMSETTING),10);
        
    }
}