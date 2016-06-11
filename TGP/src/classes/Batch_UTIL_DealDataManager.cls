/*
 * @Author Accenture IDC Team
 * @Description This Batch Apex is used to correct the data in opportunity records
 * @Version 1.0
 */
global class Batch_UTIL_DealDataManager implements Database.Batchable<SObject> {
    
    private string query {get; set;}

    /*  
     * @method Overloaded constructor to initialize the batch query string
     */
    global Batch_UTIL_DealDataManager() {
        this.query= 'Select BSS_Solution_Architect_New__c, BSS_Solution_Architect__c, Complex_Costing_Architect_New__c, Complex_Costing_Architect__c, Governance_Lead_Name_New__c, Governance_Lead_Name__c, Governance_Lead_Name_Secondary_New__c, Governance_Lead_Name_Secondary__c, Solution_Architect_New__c, Solution_Architect__c, Solution_Lead_New__c, Solution_Lead__c, Solution_Specialist_New__c, Solution_Specialist__c, Technology_Architect_New__c, Technology_Architect__c, Id from Deal_TGP__c'; 
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
    global void execute(Database.BatchableContext context, List<Deal_TGP__c> scope) {
        if(scope.size()>0){
            new UTIL_UserToApprovalUserData().updateDealRecords(scope); // Pasing list of records
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