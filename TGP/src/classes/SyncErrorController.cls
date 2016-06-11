public without sharing class SyncErrorController {
public sync_status__c syncstatus {set;get;}
private costing_request__c cost;
public boolean showBPOblock{Set;get;}
public boolean showIOblock{set;get;}
    public SyncErrorController(ApexPages.StandardController controller) {
    	showBPOblock = showIOblock = false;
        id oppid = system.currentpagereference().getparameters().get('oppid');
    syncstatus = [SELECT Id, Final_Status_Recieved__c, Chunk_Status_Sent__c,
                 Final_Status_Sent__c, Opportunity__c, Sync_Initiated_Time__c, Error__c,
                 Final_Sync_Result__c, Last_Synced_User__c,Last_Synced_By_IO__c,
                 synced_scenario__c,Last_Synced_By__c,Error_IO__c,Synced_Scenario_IO__c FROM Sync_Status__c where opportunity__c =:oppid limit 1];
                 
   cost  = [select id,in_progress__C,in_progress_io__C from costing_request__c where opportunity__c=:oppid limit 1];
   if(cost.in_progress__C == '0'){
   	showBPOblock = true;
   }
   if(cost.in_progress_io__c=='0'){
   	showIOblock = true;
   }
}
    

}