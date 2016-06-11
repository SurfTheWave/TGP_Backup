/*
 * @Author Accenture IDC Team
 * @Description This Batch Apex is used to correct the data in opportunity records
 * @Version 1.0
 */
global class Batch_UTIL_CorrectionOpportunityData implements Database.Batchable<SObject> {
    
    private string query {get; set;}

    /*  
     * @method Overloaded constructor to initialize the batch query string
     */
    global Batch_UTIL_CorrectionOpportunityData() {
        this.query= 'SELECT Complex_Cost_Architect_New__c,Complex_Cost_Architect__c, Enterprise_Solution_Architect__c, Enterprise_Solution_Architect_New__c, BSS_Operation__c, BSS_Operation_New__c, Id FROM Opportunity_TGP__c where (Complex_Cost_Architect__c != null OR Enterprise_Solution_Architect__c != null OR BSS_Operation__c != null)'; 
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
    global void execute(Database.BatchableContext context, List<Opportunity_TGP__c> scope) {
        if(scope.size()>0){
            new UTIL_UserToApprovalUserData().updateOpportunityAndOfferingRecords(scope); // Pasing list of records
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