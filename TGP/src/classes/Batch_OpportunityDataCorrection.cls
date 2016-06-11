/*
 * @Author Accenture IDC Team
 * @Description This Batch Apex is used to correct the data in opportunity records
 * @Version 1.0
 */
global class Batch_OpportunityDataCorrection implements Database.Batchable<SObject> {
    
   
    
      String query= 'Select id,Name,BPONR__c,IO_Net_Revenue__c,IC_Net_Revenue__c,OS_net_revenue__c,AO_Net_Revenue__c,SI_Net_Revenue__c,SC_Net_Revenue__c,Cons_Net_Revenue__c,MC_Net_Revenue__c,TCNR__c,TNR__c,Hierarchy_Level__c From Sap_om_staging__c';
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
    global void execute(Database.BatchableContext context, List<Sap_Om_Staging__c> scope) {
    List<Opportunity> oppListToUpdate = new List<Opportunity>();
     List<opportunity> oppList = [select id,name,BPO_Net_Rev__c,BPO_Net_Rev_Thousands__c,sap_om_item_id__C, 
                                  sap_om_id__c,OS_Net_Revenue__c,Total_Current_Net_Rev__c,
                                AO_Net_Revenue__c,MC_Net_Revenue__c,SI_Net_Revenue__c,
                                SC_Net_Revenue__c,IO_Net_Rev_SAP_OM_Thousands__c,IO_Net_Revenue_Thousands__c,
                                IC_Net_Revenue_SAP_OM_Thousands__c,IC_Net_Rev_Thousands__c,TC_Net_Rev__c,Total_Net_Rev__c,
                                SAP_OM_Item_Id__r.Hierarchy_Level__c,
                                SAP_OM_Item_Id__r.BPONR__c,
                                SAP_OM_Item_Id__r.IO_Net_Revenue__c,
                                SAP_OM_Item_Id__r.IC_Net_Revenue__c,
                                SAP_OM_Item_Id__r.OS_net_revenue__c, 
                                SAP_OM_Item_Id__r.AO_Net_Revenue__c,
                                SAP_OM_Item_Id__r.MC_Net_Revenue__c,
                                SAP_OM_Item_Id__r.SI_Net_Revenue__c,
                                SAP_OM_Item_Id__r.SC_Net_Revenue__c,
                                SAP_OM_Item_Id__r.TCNR__c,SAP_OM_Item_Id__r.TC_Net_Rev__c,
                                SAP_OM_Item_Id__r.TNR__c
                                from opportunity where sap_om_item_id__C in : scope];
                                
        for(Opportunity opp : oppList){
            if(opp.SAP_OM_Item_Id__r.Hierarchy_Level__c!=null && ((opp.SAP_OM_Item_Id__r.Hierarchy_Level__c.equalsignorecase('Standalone')) || (opp.SAP_OM_Item_Id__r.Hierarchy_Level__c.equalsignorecase('Parent')))){
                opp.BPO_Net_Rev__c = opp.SAP_OM_Item_Id__r.BPONR__c;
                opp.BPO_Net_Rev_Thousands__c = opp.SAP_OM_Item_Id__r.BPONR__c;
                opp.IO_Net_Rev_SAP_OM_Thousands__c = opp.SAP_OM_Item_Id__r.IO_Net_Revenue__c;
                opp.IO_Net_Revenue_Thousands__c = opp.SAP_OM_Item_Id__r.IO_Net_Revenue__c;
                opp.IC_Net_Revenue_SAP_OM_Thousands__c = opp.SAP_OM_Item_Id__r.IC_Net_Revenue__c;
                opp.IC_Net_Rev_Thousands__c = opp.SAP_OM_Item_Id__r.IC_Net_Revenue__c;
                opp.OS_Net_Revenue__c = opp.SAP_OM_Item_Id__r.OS_net_revenue__c;
                opp.AO_Net_Revenue__c = opp.SAP_OM_Item_Id__r.AO_Net_Revenue__c;
                opp.MC_Net_Revenue__c = opp.SAP_OM_Item_Id__r.MC_Net_Revenue__c;
                opp.SI_Net_Revenue__c = opp.SAP_OM_Item_Id__r.SI_Net_Revenue__c;
                opp.SC_Net_Revenue__c = opp.SAP_OM_Item_Id__r.SC_Net_Revenue__c;
                opp.Total_Current_Net_Rev__c = opp.SAP_OM_Item_Id__r.TCNR__c;
                opp.TC_Net_Rev__c = opp.SAP_OM_Item_Id__r.TC_Net_Rev__c;
                opp.Total_Net_Rev__c=opp.SAP_OM_Item_Id__r.TNR__c;
                oppListToUpdate.add(opp);
            }
        }
        if(oppListToUpdate.size()>0){
            database.update(oppListToUpdate,false);
        }
    }

    /* 
     * @method finish
     * @param  Database.BatchableContext context
     * @return void   
     */ 
    global void finish(Database.BatchableContext context){ 
      id alpha=database.executeBatch(new Batch_OpportunityDataParentChild(),1000);
    }
}