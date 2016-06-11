/*
 * @Author Accenture IDC Team
 * @Description This Batch Apex is used to insert the data in opportunity team object.
 * @Version 1.0
 */
global class Batch_UTIL_OpportunityTeamDataManager implements Database.Batchable<SObject> {
    
    private string query {get; set;}

    /*  
     * @method Overloaded constructor to initialize the batch query string
     */
    global Batch_UTIL_OpportunityTeamDataManager() {
        this.query= 'SELECT Analytics_Functional_Architect__c,  Analytics_Solution_Lead__c,  BSS_Operation_New__c,  Complex_Cost_Architect_New__c , Enterprise_Solution_Architect_New__c,  PrimeSDOLeadName__c , SD_Governance_Lead__c, Id FROM Opportunity_TGP__c where (Analytics_Functional_Architect__c != null OR Analytics_Solution_Lead__c != null OR BSS_Operation_New__c != null OR Complex_Cost_Architect_New__c != null OR Enterprise_Solution_Architect_New__c != null OR PrimeSDOLeadName__c != null OR SD_Governance_Lead__c != null)'; 
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
    global void execute(Database.BatchableContext context, List<Opportunity_TGP__c> scope) {
        if(scope.size()>0){
            new UTIL_OpportunityTeamDataManager().insertOpportuintyTeamRecords(scope); // Pasing list of records
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