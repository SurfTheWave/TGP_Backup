/******************
 * @class name : BatchApexGovernanceLead
 
 * @description : Batch Processing of Governance Lead Data
 ******************/
global class BatchApexGovernanceLead implements Database.Batchable<SObject>{

 private string query {get; set;}
  /*  
     * @method Overloaded constructor to initialize the batch query string
     * @param String q
     */
    global BatchApexGovernanceLead (String q) {
        this.query=q; 
        //system.debug('--------'+q);
    }
/*  
     * @method start
     * @param BatchableContext ctx
     */    
    global Database.queryLocator start(Database.BatchableContext ctx) {
        //system.debug('--------'+query);
        return Database.getQueryLocator(query);
    }
/*  
     * @method : execute
     * @param  : BatchableContext BC, List<SD_Governance_Data__c> govData
     * @returntype : void
     */    
    global void execute(Database.BatchableContext BC, List<SD_Governance_Data__c> govData) {
        if(govData.size()>0){
            new UTIL_SendEmailForGovernanceLead().sendEmailTOGovernanceLead(govData); // Pasing list of records
        }
    }
/*  
     * @method : finish
     * @param : BatchableContext BC
     * @returntype : void
     */    
    global void finish(Database.BatchableContext BC) {
    
    }
}