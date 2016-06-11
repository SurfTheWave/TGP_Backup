/*
 * @Author Accenture IDC Team
 * @Description This Batch Apex is used to correct the data in opportunity records
 * @Version 1.0
 */
global class Batch_UTIL_DealWaveDataManager implements Database.Batchable<SObject> {
    
    private string query {get; set;}

    /*  
     * @method Overloaded constructor to initialize the batch query string
     */
    global Batch_UTIL_DealWaveDataManager() {
        this.query= 'SELECT KT_Lead_New__c, KT_Lead__c, Mobilization_KT_Lead_Secondary_New__c, Mobilization_KT_Lead_Secondary__c, Mob_Recruitment_Lead_Primary_New__c, Mobilization_Recruitment_Lead_Primary__c, Mob_Recruitment_Lead_Secondary_New__c, Mobilization_Recruitment_Lead_Secondary__c, Mobilization_Opex_Lead_Primary_New__c, Mobilization_Opex_Lead_Primary__c, Mobilization_Opex_Lead_Secondary_New__c, Mobilization_Opex_Lead_Secondary__c, Mobilization_Technology_Lead_Primary_New__c, Mobilization_Technology_Lead_Primary__c, Mob_Technology_Lead_Secondary_New__c, Mobilization_Technology_Lead_Secondary__c, Id from Wave_Planning__c where (KT_Lead__c != null OR Mobilization_KT_Lead_Secondary__c != null OR Mobilization_Recruitment_Lead_Primary__c != null OR Mobilization_Recruitment_Lead_Secondary__c != null OR Mobilization_Opex_Lead_Primary__c != null OR Mobilization_Opex_Lead_Secondary__c != null OR Mobilization_Technology_Lead_Primary__c != null OR Mobilization_Technology_Lead_Secondary__c != null)'; 
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
    global void execute(Database.BatchableContext context, List<Wave_Planning__c> scope) {
        if(scope.size()>0){
            new UTIL_UserToApprovalUserData().updateDealWaveRecords(scope); // Pasing list of records
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