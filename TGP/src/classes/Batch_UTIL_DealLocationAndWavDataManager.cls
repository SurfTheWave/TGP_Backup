/*
 * @Author Accenture IDC Team
 * @Description This Batch Apex is used to correct the data in opportunity records
 * @Version 1.0
 */
global class Batch_UTIL_DealLocationAndWavDataManager implements Database.Batchable<SObject> {
    
    private string query {get; set;}

    /*  
     * @method Overloaded constructor to initialize the batch query string
     */
    global Batch_UTIL_DealLocationAndWavDataManager() {
        this.query= 'select Deployment_Lead_New__c, Deployment_Lead__c, Location_Mobilization_Lead_Secondary_New__c, Location_Mobilization_Lead_Secondary__c, Mob_Recruitment_Lead_Primary_New__c, Mobilization_Recruitment_Lead_Primary__c, Mob_Recruitment_Lead_Secondary_New__c, Mobilization_Recruitment_Lead_Secondary__c, Id from Deal_Location__c where (Deployment_Lead__c != null OR Location_Mobilization_Lead_Secondary__c != null OR Mobilization_Recruitment_Lead_Primary__c != null OR Mobilization_Recruitment_Lead_Secondary__c != null)'; 
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
    global void execute(Database.BatchableContext context, List<Deal_Location__c> scope) {
        if(scope.size()>0){
            new UTIL_UserToApprovalUserData().updateDealLocationRecords(scope); // Pasing list of records
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