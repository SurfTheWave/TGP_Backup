/*@Author: Shivraj
 *@description: This class is used to deactivte MMS and Opportunity records which are not modified for last 7 days 
 *                and also to activate the opportunity records which were modified recently
 */ 
global class MMSScheduler implements Schedulable{
    
    /*@Author: Shivraj
     *@Description: this method is used to mark the records inactive.
     * 				records are marked inactive and then updated through batch class
     */
    global void execute(SchedulableContext SC) {
        
        set<String> alpha=new set<String>();
        set<String> beta=new set<String>();
        set<String> gama=new set<String>();  
        set<String> oppIdToActivate=new set<String>();
        set<String> childSet=new set<String>();
        
        set<String> sapSet=new set<String>();
        Map<String,sap_om_staging__C> sapInactiveMap=new Map<String,sap_om_staging__c>();
        
        List<sap_om_staging__C> MMSInactiveList=new List<sap_om_staging__C>();
        List<sap_om_staging__C> childMMSRecordList=new List<sap_om_staging__C>();
        List<sap_om_staging__C> childMMStoSum=new List<sap_om_staging__C>();
        
        Map<String,MMS_Scheduler_User__c> mmsUser= MMS_Scheduler_User__c.getAll();
        
        String scheduledUser=mmsUser.get('Scheduler User').User_Name__c;
        
        User mmsSchedulerUser=[SELECT Id, Username, Name FROM User where name=:scheduledUser LIMIT 1];
        
        Map<String,Opportunity> OpportunityInactiveMap=new Map<String,Opportunity>();
        List<opportunity> OpportunityInactiveList=new List<opportunity>();
        
        Map<String,Opportunity> OpportunityParentMap=new Map<String,Opportunity>();
        List<opportunity> OpportunityParentList=new List<opportunity>();
        Opportunity_Comments__c oppComment;
        Opportunity_Comments__c oppCommentDelete;
        List<Opportunity_Comments__c> oppCommentList=new List<Opportunity_Comments__c>();
        List<Opportunity_Comments__c> oppCommentListToDelete=new List<Opportunity_Comments__c>();
        
        List<Opportunity> childOpportunityList=new List<Opportunity>();
        set<String> childOppId=new set<String>();
        Map<String,opportunity> childOppMap=new Map<String,Opportunity>();
        
        sap_om_staging__c tempSap=new sap_om_staging__c();
        
        try{
            for(sap_om_staging__C sap:[select opportunity_ID__c,id,Parent_id__c,IC_Net_Revenue__c,BPONR__c,
                                       IO_Net_Revenue__c,AO_Net_Revenue__c,SI_Net_Revenue__c,SC_Net_Revenue__c,
                                       MC_Net_Revenue__c,TCNR__c,TNR__c,Cons_Net_Revenue__c,TC_Net_Rev__c,
                                       OS_Net_Revenue__c,name,hierarchy_level__C,active__C,createddate,
                                       lastmodifieddate,CPM_TNR__c,CS_TNR__c,CC_TNR__c,FA_TNR__c,HA_TNR__c,
                                       HM_TNR__c,HR_TNR__c,INS_TNR__c,LNG_TNR__c,MKT_TNR__c,NS_TNR__c,PHARMA_TNR__c,
                                       PROC_TNR__c,SC_TNR__c,UTL_TNR__c,ECI_TNR__c,EIS_TNR__c,Acc_SW_SaaS_Subsc_TNR__c,
                                       Compute_Services_TNR__c,IS_Capacity_Services_TNR__c,IS_Mgnt_TNR__c,
                                       Managed_Sec_Ser_TNR__c,Nw_Ser_IO_TNR__c,Wp_Ser_TNR__c,IS_Transf_TNR__c,
                                       Data_Center_Transf_TNR__c,Operations_Transf_TNR__c,Nw_Transf_TNR__c,
                                       Wp_Transf_TNR__c,Sec_Transf_TNR__c,MMR_TNR__c,MCS_TNR__c,ICS_TNR__c,
                                       SC_OPS_TNR__c,SI_CS_TNR__c from sap_om_staging__C 
                                       where ((lastmodifieddate >:system.today().addDays(-1) 
                                             and lastmodifieddate < :system.today().addDays(-0)) 
                                            OR (lastmodifieddate >:system.today() and active__c=true)) LIMIT 500]){
                    
                
                    
                if(sap.active__C && sap.lastmodifieddate <= system.today()){
                    if(null != sap.hierarchy_level__C && ((sap.hierarchy_level__C).equalsIgnoreCase('Child'))){
                        childMMSRecordList.add(sap);
                        childSet.add(sap.id);
                    }else if(null != sap.hierarchy_level__C){
                        sap.active__C=false;
                        sapSet.add(sap.id);                           
                        sapInactiveMap.put(sap.id,sap);
                        MMSInactiveList.add(sap); 
                    }
                    beta.add(sap.opportunity_id__c);
                }else if(sap.active__C && sap.lastmodifieddate >= system.today()){
                    /*if(null != sap.hierarchy_level__C && ((sap.hierarchy_level__C).equalsIgnoreCase('Child'))){
                        childMMStoSum.add(sap);
                    }*/
                    oppIdToActivate.add(sap.opportunity_id__c);
                }
                                           
        
            }
            
            for(opportunity opp:[select id,active__C,sap_om_item_id__r.active__c,sap_om_item_id__r.lastmodifieddate,
                                 (select id from Opportunity_Comments__r where Opportunity_Inactive__c=true LIMIT 1) 
                                 from opportunity where sap_om_item_id__r.opportunity_id__c IN :beta]){
                if(opp.active__c){
                    opp.active__C=false;
                    oppComment=new Opportunity_Comments__c();
                    oppComment.Opportunity__c=opp.id;
                    oppComment.comments__c='Opportunity Deactivated via SORT process - Opportunity Information Unavailable/Opportunity Inactive in MMS';
                    oppComment.Opportunity_Inactive__c=true;
                    oppCommentList.add(oppComment);
                    
                    alpha.add(opp.id);
                    OpportunityInactiveMap.put(opp.id,opp);
                    OpportunityInactiveList.add(opp);
                }
                
                system.debug('Comment size is' +oppCommentListToDelete.size());
            }
            
            for(opportunity opp:[select id,active__C,sap_om_item_id__r.active__c,sap_om_item_id__r.lastmodifieddate,
                                 (select id from Opportunity_Comments__r where Opportunity_Inactive__c=true LIMIT 1) 
                                 from opportunity where sap_om_item_id__r.opportunity_id__c IN :oppIdToActivate]){
                if(!opp.active__c){
                    opp.active__C=true;
                    List<Opportunity_Comments__c> oppCList=opp.Opportunity_Comments__r;
                    if(!oppCList.isEmpty()){
                        oppCommentDelete=oppCList[0];
                        oppCommentListToDelete.add(oppCommentDelete);
                    }
                alpha.add(opp.id);
                OpportunityInactiveMap.put(opp.id,opp);
                OpportunityInactiveList.add(opp);
                }
                
            }
            
            
            
            Set<String> parentId = new Set<String>();
            for(Sap_om_Staging__c stagingRec :childMMSRecordList){
                system.debug('>>stagingRec.Parent_ID__c>>'+stagingRec.Parent_ID__c);
                if(stagingRec.Hierarchy_Level__c == UtilConstantsforSWB.CHILD  && stagingRec.Parent_id__c != null){
                    parentId.add(stagingRec.Parent_ID__c);   
                }   
            }
            
            for(Opportunity opp : [select Id,sap_om_id__c,BPO_Net_Rev__c,IC_Net_Revenue_SAP_OM_Thousands__c,
                                   IO_Net_Rev_SAP_OM_Thousands__c,IO_Net_Revenue_Thousands__c,AO_Net_Revenue__c ,SI_Net_Revenue__c,
                                   SC_Net_Revenue__c,MC_Net_Revenue__c,Total_Current_Net_Rev__c,TC_Net_Rev__c,
                                   Cons_Net_Revenue__c,Total_Net_Rev__c,OS_Net_Revenue__c,BPO_Net_Rev_Thousands__c,
                                   IC_Net_Rev_Thousands__c from opportunity where sap_om_id__c in : parentId]){
                                       
                                   Decimal BPO_NR=0,IONR=0,ICNR=0;
                Decimal AONR=0,SINR=0,SCNR=0,MCNR=0,TCNETR=0;
                Decimal TCNR = 0,CNR=0,OSNR=0,TNR=0;
                                       for(sap_om_staging__c sap : childMMSRecordList){
                                           if(sap.Parent_ID__c == opp.sap_om_id__c){
                                               if(sap.IC_Net_Revenue__c!=null ){
                                                   ICNR+= sap.IC_Net_Revenue__c;
                                               }
                                               if(sap.BPONR__c!=null){
                                                   BPO_NR += sap.BPONR__c;
                                                   system.debug('NR is ' +BPO_NR);
                                               }
                                               if(sap.IO_Net_Revenue__c!=null ){
                                                   IONR += sap.IO_Net_Revenue__c;
                                               }
                                               if(sap.AO_Net_Revenue__c!=null){
                                                   AONR +=sap.AO_Net_Revenue__c;
                                               }
                                               if(sap.SI_Net_Revenue__c!=null){
                                                   SINR += sap.SI_Net_Revenue__c;
                                               }
                                               if(sap.SC_Net_Revenue__c!=null){
                                                   SCNR += sap.SC_Net_Revenue__c;
                                               }
                                               if(sap.MC_Net_Revenue__c!=null){
                                                   MCNR += sap.MC_Net_Revenue__c;
                                               }
                                               if(sap.TCNR__c!=null){
                                                   TCNR += sap.TCNR__c;
                                               }
                                               if(sap.TNR__c!=null){
                                                   TNR += sap.TNR__c;
                                               }
                                               
                                               if(sap.Cons_Net_Revenue__c!=null){
                                                   CNR += sap.Cons_Net_Revenue__c;
                                               }
                                               if(sap.OS_Net_Revenue__c!=null){
                                                   OSNR += sap.OS_Net_Revenue__c;
                                               }
                                               if(sap.TC_Net_Rev__c!=null){
                                                   TCNETR += sap.TC_Net_Rev__c;
                                               }
                                            }
                                        }   
                    if(null !=opp.IC_Net_Revenue_SAP_OM_Thousands__c){
                        opp.IC_Net_Revenue_SAP_OM_Thousands__c = opp.IC_Net_Revenue_SAP_OM_Thousands__c - ICNR;
                    }
                    if(null !=opp.IC_Net_Rev_Thousands__c){
                        opp.IC_Net_Rev_Thousands__c = opp.IC_Net_Revenue_SAP_OM_Thousands__c;
                    }
                    if(null!=opp.BPO_Net_Rev__c){
                        opp.BPO_Net_Rev__c = opp.BPO_Net_Rev__c - BPO_NR ;
                    }
                    
                    if(null!=opp.BPO_Net_Rev_Thousands__c){
                        opp.BPO_Net_Rev_Thousands__c = opp.BPO_Net_Rev__c;
                    }
                    
                    if(null!=opp.IO_Net_Rev_SAP_OM_Thousands__c){
                        opp.IO_Net_Rev_SAP_OM_Thousands__c = opp.IO_Net_Rev_SAP_OM_Thousands__c - IONR;
                    }
                    if(null!=opp.IO_Net_Revenue_Thousands__c){
                          opp.IO_Net_Revenue_Thousands__c = opp.IO_Net_Rev_SAP_OM_Thousands__c;                 
                    }
                    if(null!=opp.AO_Net_Revenue__c){
                        opp.AO_Net_Revenue__c = opp.AO_Net_Revenue__c - AONR;
                    }
                    
                    if(null!=opp.SI_Net_Revenue__c){
                        opp.SI_Net_Revenue__c = opp.SI_Net_Revenue__c - SINR ;
                    }
                    
                    if(null!=opp.SC_Net_Revenue__c){
                        opp.SC_Net_Revenue__c = opp.SC_Net_Revenue__c - SCNR ;
                    }
                    
                    if(null!=opp.MC_Net_Revenue__c){
                        opp.MC_Net_Revenue__c = opp.MC_Net_Revenue__c - MCNR;
                    }
                    
                    if(null!=opp.Total_Current_Net_Rev__c){
                        opp.Total_Current_Net_Rev__c = opp.Total_Current_Net_Rev__c - TCNR ;
                    }
                    
                    if(null!=opp.TC_Net_Rev__c){
                        opp.TC_Net_Rev__c = opp.TC_Net_Rev__c - TCNETR;
                    }
                    
                    if(null!=opp.Cons_Net_Revenue__c){
                        opp.Cons_Net_Revenue__c = opp.Cons_Net_Revenue__c - CNR;
                    }
                    
                    if(null!=opp.OS_Net_Revenue__c){
                        opp.OS_Net_Revenue__c = opp.OS_Net_Revenue__c - OSNR;
                    }
                    
                    if(null!=opp.Total_Net_Rev__c){
                        opp.Total_Net_Rev__c = opp.Total_Net_Rev__c - TNR;
                    }
                    system.debug('Opp value is' +opp.Total_Net_Rev__c);
                 gama.add(opp.id);                      
                 OpportunityParentMap.put(opp.id,opp);                      
                 OpportunityParentList.add(opp);                                     
                                                                                      
              }
            
            
            MasterQueries.findAllActiveOffMasters();
            if(!childMMSRecordList.isEmpty()){
                system.debug('Boolean value is' +childMMSRecordList.size());
                SolutionScopeChildOffering.updateParentOffering(childMMSRecordList);
            }
        
            for(sap_om_staging__c childSap:[select id,active__c from sap_om_staging__c 
                                            where ID in :childSet]){
                childSap.active__C=false;
                sapSet.add(childSap.id);                           
                sapInactiveMap.put(childSap.id,childSap);
                MMSInactiveList.add(childSap);
            }
            UtilConstants.IS_OPPTRIGGER_REQUIRED=false;
            RecursiveTriggerHelper.runOnce();
            
            
            /*if(!MMSInactiveList.isEmpty()){
                database.update(MMSInactiveList,false);
            }*/
            
            if(!oppCommentList.isEmpty()){
                database.insert(oppCommentList,false);
            }
                
            if(!oppCommentListToDelete.isEmpty()){
                delete oppCommentListToDelete;
            }
        
            if(!OpportunityInactiveList.isEmpty() || !OpportunityParentList.isEmpty() || !MMSInactiveList.isEmpty()){
                String saasQuery='select id from opportunity where ID in:inactive';
                String saasString='Inactive';
                /*Id batchId=database.executeBatch(new MMSSchedulerBatch(saasQuery,saasString,alpha,
                                                                       OpportunityInactiveMap,gama,
                                                                       OpportunityParentMap,sapSet,sapInactiveMap,
                                                                       childOppId,childOppMap),100);*/
                Id batchId=database.executeBatch(new MMSSchedulerBatch(saasQuery,saasString,alpha,
                                                                       OpportunityInactiveMap,gama,
                                                                       OpportunityParentMap,sapSet,sapInactiveMap),100);
                
            }
        
        }catch(Exception e){
            system.debug('Exception occured in Scheduler');
        }
    }
    
}