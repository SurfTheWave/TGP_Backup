/*
 * @Author: Aswajit
 * @CreatedDate: 03/12/2015
 * @Description: This Batch class will do blank update on PTO. 
 */
global class Batch_UtilizationPTOUpdate implements Database.Batchable<SObject> {
    /*
     * @Author: Aswajit
     * @CreatedDate: 03/12/2015
     * @Description:  
     */
    global Database.QueryLocator start(Database.BatchableContext context) {
        String query = 'SELECT Id FROM PTO__c WHERE PTO_Start__c >= LAST_N_DAYS:7 AND PTO_End__c <= NEXT_N_DAYS:30';
        return Database.getQueryLocator(query);
    }
    /*
     * @Author: Aswajit
     * @CreatedDate: 03/12/2015
     * @Description:  
     */
    global void execute(Database.BatchableContext context, List<PTO__c> scope) {
        if(scope.size()>0){
            update scope;
        }
    }
    /*
     * @Author: Aswajit
     * @CreatedDate: 03/12/2015
     * @Description:  
     */
    global void finish(Database.BatchableContext context){ 
    }
}