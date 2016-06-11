/*
 * @Author Accenture IDC Team
 * @Description This Batch Apex is used to correct the data in opportunity records
 * @Version 1.0
 */
global class Batch_UTIL_MobUserAssignmentDataManager implements Database.Batchable<SObject> {
    
    private string query {get; set;}

    /*  
     * @method Overloaded constructor to initialize the batch query string
     */
    global Batch_UTIL_MobUserAssignmentDataManager() {
        this.query= 'select User_Assigned_New__c, User_Assigned__c, User_Assigned_Secondary_New__c, User_Assigned_Secondary__c, Id from MOB_User_Role_Assignment__c where (User_Assigned__c != null OR User_Assigned_Secondary__c != null)'; 
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
    global void execute(Database.BatchableContext context, List<MOB_User_Role_Assignment__c> scope) {
        if(scope.size()>0){
            new UTIL_UserToApprovalUserData().updateMobUserAssignmentRecords(scope); // Pasing list of records
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