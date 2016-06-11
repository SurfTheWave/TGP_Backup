global class OpportunityBlankUpdate implements Database.Batchable<sObject>,database.stateful{

        global OpportunityBlankUpdate (){
                   // Batch Constructor
        }
       
        // Start Method
        global Database.QueryLocator start(Database.BatchableContext BC){
              
        String query = 'select Sd_covered__c , id from Opportunity';              
        system.debug('query-------->'+query);
         return Database.getQueryLocator(query);
        }
      
      // Execute Logic
    global void execute(Database.BatchableContext BC, List<Opportunity>Obj){
    List<Opportunity>opUPD=new List<Opportunity>();
    for(Opportunity op:obj){
    op.Sd_covered__c='No';
    if(op.BPO_Net_Rev_Thousands__c==NULL)
    op.BPO_Net_Rev_Thousands__c=0;
    
    if(op.IC_Net_Rev_Thousands__c==NULL) 
    op.IC_Net_Rev_Thousands__c=0;
    
    if(op.IO_Net_Revenue_Thousands__c==NUll) 
    op.IO_Net_Revenue_Thousands__c=0;
        
    opUPD.add(op);
    }
    update opUPD;
    }
       
    global void finish(Database.BatchableContext BC){
            // Logic to be Executed at finish
    }
}