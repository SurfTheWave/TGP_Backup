/*
 * @Author Accenture IDC Team
 * @Description This Batch Apex is used to correct the data in opportunity records
 * @Version 1.0
 */
global class Batch_OpportunityDataParentChild implements Database.Batchable<SObject> {
    
   
    
      String query= 'Select id,Name,BPONR__c,IO_Net_Revenue__c,IC_Net_Revenue__c,Parent_Id__c,OS_net_revenue__c,AO_Net_Revenue__c,SI_Net_Revenue__c,SC_Net_Revenue__c,Cons_Net_Revenue__c,MC_Net_Revenue__c,TCNR__c,TNR__c,Hierarchy_Level__c From Sap_om_staging__c';
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
    Set<String> parentOppIds = new Set<String>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Opportunity> oppListToUpdate = new List<Opportunity>();        
        for(SAP_OM_Staging__c sapRec : scope){
            if(sapRec.Hierarchy_Level__c!=null && sapRec.Hierarchy_Level__c.equalsIgnoreCase('Child')){
                parentOppIds.add(sapRec.Parent_Id__c); 
            }       
        }
        oppList = [Select id,Name,SAP_OM_Item_Id__r.name,BPO_Net_Rev__c,BPO_Net_Rev_Thousands__c,SAP_OM_Item_Id__r.BPONR__c,
                   IO_Net_Rev_SAP_OM_Thousands__c,IO_Net_Revenue_Thousands__c,SAP_OM_Item_Id__r.IO_Net_Revenue__c,
                   IC_Net_Revenue_SAP_OM_Thousands__c,IC_Net_Rev_Thousands__c,SAP_OM_Item_Id__r.IC_Net_Revenue__c,
                   AO_Net_Revenue__c,SAP_OM_Item_Id__r.AO_Net_Revenue__c,
                   SI_Net_Revenue__c,SAP_OM_Item_Id__r.SI_Net_Revenue__c,
                   SC_Net_Revenue__c,SAP_OM_Item_Id__r.SC_Net_Revenue__c,
                   MC_Net_Revenue__c,SAP_OM_Item_Id__r.MC_Net_Revenue__c,
                   Total_Current_Net_Rev__c,SAP_OM_Item_Id__r.TCNR__c,
                   Total_Net_Rev__c,SAP_OM_Item_Id__r.TNR__c,
                   Cons_Net_Revenue__c,SAP_OM_Item_Id__r.Cons_Net_Revenue__c,
                   OS_Net_Revenue__c,SAP_OM_Item_Id__r.OS_net_revenue__c,
                   TC_Net_Rev__c,SAP_OM_Item_Id__r.TC_Net_Rev__c,
                   (Select id,Name,BPONR__c,IO_Net_Revenue__c,IC_Net_Revenue__c,OS_net_revenue__c,
                    AO_Net_Revenue__c,SI_Net_Revenue__c,SC_Net_Revenue__c,Cons_Net_Revenue__c,
                    MC_Net_Revenue__c,TCNR__c,TNR__c,Parent_id__c,Parent_Opportunity__c,TC_Net_Rev__c from SAP_OM_Items__r) 
                   from Opportunity where SAP_OM_Item_Id__r.name IN : parentOppIds];
        for(Opportunity oppRec: oppList){
            Decimal BPO_NR=0,IONR=0,ICNR=0;
            Decimal AONR=0,SINR=0,SCNR=0,MCNR=0,TONR=0;
            Decimal TCNR = 0,CNR=0,OSNR=0,TNR=0;
            Decimal TotalCurrentNetRevenue=0;
            for(SAP_OM_Staging__c sapOmRec : oppRec.SAP_OM_Items__r){
                if(oppRec.SAP_OM_Item_Id__r.name == sapOmRec.Parent_id__c){
                    
                    if(sapOmRec.BPONR__c!= null ){
                        BPO_NR += sapOmRec.BPONR__c;
                        System.debug('---BPO_NR--'+BPO_NR);   
                    }
                    if(sapOmRec.IO_Net_Revenue__c!= null){
                        IONR += sapOmRec.IO_Net_Revenue__c;
                        System.debug('---IONR--'+IONR);   
                    }
                    if(sapOmRec.IC_Net_Revenue__c!= null){
                        ICNR += sapOmRec.IC_Net_Revenue__c;
                        System.debug('---ICNR--'+ICNR);   
                    }
                    if(sapOmRec.AO_Net_Revenue__c!= null){
                        AONR += sapOmRec.AO_Net_Revenue__c;
                        System.debug('---AONR--'+AONR);   
                    }
                    if(sapOmRec.SI_Net_Revenue__c!= null){
                        SINR += sapOmRec.SI_Net_Revenue__c;
                        System.debug('---SINR--'+SINR);   
                    }
                    if(sapOmRec.SC_Net_Revenue__c!= null){
                        SCNR += sapOmRec.SC_Net_Revenue__c;
                        System.debug('---SCNR--'+SCNR);   
                    }
                    if(sapOmRec.MC_Net_Revenue__c!= null){
                        MCNR += sapOmRec.MC_Net_Revenue__c;
                        System.debug('---MCNR--'+MCNR);   
                    }
                    if(sapOmRec.TCNR__c!= null){
                        TCNR += sapOmRec.TCNR__c;
                        System.debug('---TCNR--'+TCNR);   
                    }
                    
                    if(sapOmRec.TNR__c!= null){
                        TNR += sapOmRec.TNR__c;
                        System.debug('---TNR--'+TNR);   
                    }
                    if(sapOmRec.TC_Net_Rev__c!=null){
                        TotalCurrentNetRevenue +=sapOmRec.TC_Net_Rev__c;
                    }
                    if(sapOmRec.OS_net_revenue__c!= null){
                        OSNR += sapOmRec.OS_net_revenue__c;
                        System.debug('---OSNR--'+OSNR);   
                    }
                    if(sapOmRec.Cons_Net_Revenue__c!= null){
                        CNR += sapOmRec.Cons_Net_Revenue__c;
                        System.debug('---CNR--'+CNR);   
                    }                   
                    
                }
            }
            
            if(oppRec.SAP_OM_Item_Id__r.BPONR__c !=null){
                BPO_NR += oppRec.SAP_OM_Item_Id__r.BPONR__c;
            }
            if(oppRec.SAP_OM_Item_Id__r.IO_Net_Revenue__c !=null){
                IONR += oppRec.SAP_OM_Item_Id__r.IO_Net_Revenue__c;
            }
            if(oppRec.SAP_OM_Item_Id__r.IC_Net_Revenue__c != null){
                ICNR += oppRec.SAP_OM_Item_Id__r.IC_Net_Revenue__c;
            }
            if(oppRec.SAP_OM_Item_Id__r.AO_Net_Revenue__c != null){
                AONR += oppRec.SAP_OM_Item_Id__r.AO_Net_Revenue__c;
            }
            if(oppRec.SAP_OM_Item_Id__r.SI_Net_Revenue__c != null){
                SINR += oppRec.SAP_OM_Item_Id__r.SI_Net_Revenue__c;
            }
            if(oppRec.SAP_OM_Item_Id__r.SC_Net_Revenue__c != null){
                SCNR += oppRec.SAP_OM_Item_Id__r.SC_Net_Revenue__c;
            }
            if(oppRec.SAP_OM_Item_Id__r.MC_Net_Revenue__c != null){
                MCNR += oppRec.SAP_OM_Item_Id__r.MC_Net_Revenue__c;
            }
            if(oppRec.SAP_OM_Item_Id__r.TCNR__c != null){
                TCNR += oppRec.SAP_OM_Item_Id__r.TCNR__c;
            }
            if(oppRec.SAP_OM_Item_Id__r.TNR__c != null){
                TNR  += oppRec.SAP_OM_Item_Id__r.TNR__c;
            }
            if(oppRec.SAP_OM_Item_Id__r.TC_Net_Rev__c!= null){
                TotalCurrentNetRevenue += oppRec.SAP_OM_Item_Id__r.TC_Net_Rev__c;
            }
            if(oppRec.SAP_OM_Item_Id__r.OS_net_revenue__c != null){
                OSNR += oppRec.SAP_OM_Item_Id__r.OS_net_revenue__c;
            }
            if(oppRec.SAP_OM_Item_Id__r.Cons_Net_Revenue__c != null){
                CNR += oppRec.SAP_OM_Item_Id__r.Cons_Net_Revenue__c;
            }
            oppRec.BPO_Net_Rev__c = BPO_NR;
            oppRec.BPO_Net_Rev_Thousands__c=BPO_NR;
            oppRec.IO_Net_Rev_SAP_OM_Thousands__c = IONR ;
            oppRec.IO_Net_Revenue_Thousands__c=IONR;
            oppRec.IC_Net_Revenue_SAP_OM_Thousands__c = ICNR ;
            oppRec.IC_Net_Rev_Thousands__c = ICNR;
            oppRec.AO_Net_Revenue__c = AONR ;
            oppRec.SI_Net_Revenue__c = SINR ;
            oppRec.SC_Net_Revenue__c = SCNR ;
            oppRec.MC_Net_Revenue__c = MCNR ;
            oppRec.Total_Current_Net_Rev__c = TCNR ;
            oppRec.Total_Net_Rev__c = TNR  ;
            oppRec.TC_Net_Rev__c=TotalCurrentNetRevenue ;
            oppRec.OS_Net_Revenue__c = OSNR ;
            oppRec.Cons_Net_Revenue__c = CNR ;
            oppListToUpdate.add(oppRec);
        }
        if(oppListToUpdate.size()>0 || !oppListToUpdate.isEmpty()){
            database.update(oppListToUpdate,false);
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