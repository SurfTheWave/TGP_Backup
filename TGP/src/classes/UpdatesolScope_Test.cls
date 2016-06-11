global class UpdatesolScope_Test implements Database.Batchable<sObject>,database.stateful{
        global UpdatesolScope_Test(){
                   // Batch Constructor
        }
       
        // Start Method
        global Database.QueryLocator start(Database.BatchableContext BC){
        String HL = 'Standalone';
              
        String query = 'select id,IO_Net_Revenue__c,BPONR__c,IC_Net_Revenue__c,TCNR__c,TNR__c,Cons_Net_Revenue__c,OS_net_revenue__c,MC_Net_Revenue__c, name,SC_Net_Revenue__c,SI_Net_Revenue__c,AO_Net_Revenue__c from sap_om_staging__c where hierarchy_level__c = :HL or hierarchy_level__c = null';              
        system.debug('query-------->'+query);
         return Database.getQueryLocator(query);
        }
      
      // Execute Logic
    global void execute(Database.BatchableContext BC, List<sap_om_staging__c>oldObject){
    Map<String,sap_om_staging__c> map1 = new Map<String,sap_om_staging__c>();
List<String> sapomid = new List<String>();

for(sap_om_staging__c sapom: oldObject)
{
            sapomid.add(sapom.name);
            map1.put(sapom.name,sapom);
}

List<Opportunity> oppL = new List<Opportunity>();
for(Opportunity opp :[select id,name,sap_om_id__c,IO_Net_Rev_SAP_OM_Thousands__c,IO_Net_Revenue_Thousands__c,BPO_Net_Rev__c,BPO_Net_Rev_Thousands__c,IC_Net_Revenue_SAP_OM_Thousands__c,IC_Net_Rev_Thousands__c,Total_Current_Net_Rev__c,Total_Net_Rev__c,Cons_Net_Revenue__c,OS_net_revenue__c,MC_Net_Revenue__c,SC_Net_Revenue__c,SI_Net_Revenue__c,AO_Net_Revenue__c from Opportunity where sap_om_id__c in :sapomid])
{
    opp.IO_Net_Rev_SAP_OM_Thousands__c = map1.get(opp.sap_om_id__c).IO_Net_Revenue__c;
    opp.IO_Net_Revenue_Thousands__c = map1.get(opp.sap_om_id__c).IO_Net_Revenue__c;
    opp.BPO_Net_Rev__c = map1.get(opp.sap_om_id__c).BPONR__c;
    opp.BPO_Net_Rev_Thousands__c = map1.get(opp.sap_om_id__c).BPONR__c;
    opp.IC_Net_Revenue_SAP_OM_Thousands__c = map1.get(opp.sap_om_id__c).IC_Net_Revenue__c;
    opp.IC_Net_Rev_Thousands__c = map1.get(opp.sap_om_id__c).IC_Net_Revenue__c;
    opp.Total_Current_Net_Rev__c = map1.get(opp.sap_om_id__c).TCNR__c;
    opp.Total_Net_Rev__c = map1.get(opp.sap_om_id__c).TNR__c;
    opp.Cons_Net_Revenue__c = map1.get(opp.sap_om_id__c).Cons_Net_Revenue__c;
    opp.OS_net_revenue__c = map1.get(opp.sap_om_id__c).OS_net_revenue__c;
    opp.MC_Net_Revenue__c = map1.get(opp.sap_om_id__c).MC_Net_Revenue__c;
    opp.SC_Net_Revenue__c = map1.get(opp.sap_om_id__c).SC_Net_Revenue__c;
    opp.SI_Net_Revenue__c = map1.get(opp.sap_om_id__c).SI_Net_Revenue__c;
    opp.AO_Net_Revenue__c = map1.get(opp.sap_om_id__c).AO_Net_Revenue__c;
    
    oppL.add(opp);
}

if(oppL.size()>0)
{
    database.update(oppL);
}
   
   }
     
     
    global void finish(Database.BatchableContext BC){
            // Logic to be Executed at finish
    }
}