/*
 * @Author Accenture IDC Team
 * @Description This Batch Apex is used to correct the data in opportunity records
 * @Version 1.0
 */
global class Batch_UTIL_SolUserAssignmentDataManager implements Database.Batchable<SObject> {
    
    private string query {get; set;}

    /*  
     * @method Overloaded constructor to initialize the batch query string
     */
    global Batch_UTIL_SolUserAssignmentDataManager() {
        this.query= 'SELECT Resource_Assigned_User__c, Resource_Assigned_User_New__c, Id FROM Solution_User_Assignment__c where Resource_Assigned_User__c != null'; 
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
     * @method This method will call the utility class to process the record update
     * @param  Database.BatchableContext context, List<Opportunity_TGP__c> scope
     * @return Void   
     */ 
    global void execute(Database.BatchableContext context, List<Solution_User_Assignment__c> scope) {
        if(scope.size()>0){
            new UTIL_UserToApprovalUserData().updateSolutionUserAssignmentRecords(scope); // Pasing list of records
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