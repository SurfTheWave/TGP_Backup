global class batchupdateDeliveryLocation implements Database.Batchable<sObject> {
global Database.QueryLocator start(Database.BatchableContext BC){
    string BPO ='BPO';
   String query = 'select id,Opportunity_Delivery_Location__c.Offering_Service__c from Opportunity_Delivery_Location__c where Offering_Service__r.Service_Group__c=\''+BPO+'\'';
  system.debug('query-->'+query);
  return Database.getQueryLocator(query);
  }
  global void execute(Database.BatchableContext BC, List<Opportunity_Delivery_Location__c > scope) {
     AP01_OpportunityDeliveryLocation.updateDeliverylocOnOpp(scope);
    }
global void finish(Database.BatchableContext BC) {}
}