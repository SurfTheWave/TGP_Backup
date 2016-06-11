/*
 * @Author: Aswajit
 * @CreatedDate: 10/12/2015
 * @Description: This Batch class will do CL count update on Opportunity. 
 */
global class Batch_OpportunityCLCountUpdate implements Database.Batchable<SObject> {
    /*
     * @Author: Aswajit
     * @CreatedDate: 10/12/2015
     * @Description:  
     */
    global Database.QueryLocator start(Database.BatchableContext context) {
        Set<Id> oppIds = new Set<Id>();
        for(Opportunity_Teams__c team:[Select Id, Name,Opportunity__c FROM Opportunity_Teams__c WHERE Role__r.Name='Capability Lead']){
            oppIds.add(team.Opportunity__c);
        }
        String cp='Capability Lead';
        String query = 'Select Id,No_of_CLs__c, name,(Select Id, Name FROM Opportunity_Team__r WHERE Role__r.Name=:cp ) FROM Opportunity where Id IN:oppIds';
        return Database.getQueryLocator(query);
    }
    /*
     * @Author: Aswajit
     * @CreatedDate: 10/12/2015
     * @Description:  
     */
    global void execute(Database.BatchableContext context, List<Opportunity> oppList) {
        for (Opportunity oppRec: oppList) {
            if(oppRec.Opportunity_Team__r.size() > 0) {
                oppRec.No_of_CLs__c= oppRec.Opportunity_Team__r.size();
            }
        }
        update oppList;
        
    }
    /*
     * @Author: Aswajit
     * @CreatedDate: 10/12/2015
     * @Description:  
     */
    global void finish(Database.BatchableContext context){ 
    }
}