public class operationsOnStagingTriggerController{
        public static Map<String,String> geoRegionMap=new Map<String,String>();
        public static Map<String,String> operatingGroupMap=new Map<String,String>();
        public static Map<Id,Opportunity> opportunityWithSAP=new Map<ID,Opportunity>();
        public static Map<String,String> accountMap=new Map<String,String>();
        public static List < Schema.FieldSetMember > fieldSetMemberList;
        public static List < Schema.FieldSetMember > fieldSetMemberOfferingList;
        public static Map < String, Staging_CustomSetting__c > stagingCustomSettingMap = Staging_CustomSetting__c.getall();
        public static MAP < String, Opportunity_Additional_Role_Master__c > masterOppAdditionalRoleMap = new MAP < String, Opportunity_Additional_Role_Master__c > ();
        public static Map < String, Opportunity_Additional_Team__c > oppAdditionalTeamMap = new Map < String, Opportunity_Additional_Team__c > ();
        public static List < Opportunity_Additional_Team__c > oppAdditionalTeamList;
        public static Map < String, String > stageOpportunityMap=new Map<String,String>();
        public static Map < String, Solution_Scope__c > oppOfferingToInsertMap;
        public static Boolean childToParent=false;
        public static map < string, account > account_map;
        public static Map < String, Opportunity > stagingOpportunityMap;
        public static MAP < String, Offering_Master__c > masterOfferingMap = new MAP < String, Offering_Master__c > ();
        public static List < Solution_Scope__c > oppOfferingToInsertList;
        
        /* @Authour: Shivraj
         * @Description: This method is used to create Opportunity records on creation of SAP OM Records 
         * @Parameters: This method takes trigger.new parameters and Old Map values
         */
        public static void createOpportunity(List<SAP_OM_Staging__c> SAPList,Map<Id,SAP_OM_Staging__c> sapOmOldMap,Boolean isStageUpdate,Boolean parentChild){
            IOCostModelUpload.stopTriggerExecution = false;
            //UtilConstants.stopTriggersForIO = False; 
            List<Opportunity> OpportunityList=new List<Opportunity>();
            List<SAP_OM_Staging__c> stagingList=new List<SAP_OM_Staging__c>();
            Opportunity stagingOpportunity;
            String operatingGroupId;
            set<ID> sapId=new set<Id>();
            set<Id> sapIdtoUpdate=new set<Id>();
            set<Id> updateChildSAP=new set<Id>();
            List<SAP_OM_Staging__c> sapParentChildList=new List<SAP_OM_Staging__c>();
            Map<String,Id> oppWithParentIdMap=new Map<String,Id>();
            set<String> sapParentId=new set<String>();
            stagingOpportunityMap = new Map < String, Opportunity > ();
            oppOfferingToInsertMap = new Map < String, Solution_Scope__c > ();
            oppOfferingToInsertList = new List < Solution_Scope__c > ();
            Boolean oppTeamFlag=false;
            
            saveNewAccounts(SAPList);
            saveAccountDetails(SAPList);
            getMasterData();
            
            fieldSetMemberList = readFieldSet(UtilConstants.SAP_OM_FIELD_SET, UtilCOnstants.SAP_OM_STAGING);
            fieldSetMemberOfferingList = readFieldSet(utilCOnstants.SAM_OM_OFF_FIELD_SET, UtilCOnstants.SAP_OM_STAGING); 
            System_User_Id__c systemUser = System_User_Id__c.getValues(UtilConstants.SYSTEM_ID);
                   
            for(SAP_OM_Staging__c sapOM:SAPList){
                sapId.add(sapOM.id);
                sapParentId.add(sapOM.Parent_ID__c);
            }
            
            for(Opportunity opp:[select id,SAP_OM_Item_Id__c,BPO_Net_Rev__c,IC_Net_Revenue_SAP_OM_Thousands__c,IO_Net_Rev_SAP_OM_Thousands__c,Total_Net_Rev__c,Total_Current_Net_Rev__c,Cons_Net_Revenue__c,OS_net_revenue__c,MC_Net_Revenue__c,SC_Net_Revenue__c,SI_Net_Revenue__c,AO_Net_Revenue__c,TC_Net_Rev__c,(select id,name,BPONR__c,IC_Net_Revenue__c,IO_Net_Revenue__c,TCNR__c,TNR__c,Cons_Net_Revenue__c,OS_net_revenue__c,MC_Net_Revenue__c,SC_Net_Revenue__c,SI_Net_Revenue__c,AO_Net_Revenue__c,TC_Net_Rev__c from SAP_OM_Items__r) from Opportunity where SAP_OM_Item_Id__c IN:sapId]){
                opportunityWithSAP.put(opp.SAP_OM_Item_Id__c,opp);
            }
            
             if(!parentChild){
                //InsertOfferingCode.insertAndUpdateFlag=false;
                AlphaOffering.insertAndUpdateFlag=false;
            }
            
            try{
                System.debug('Come here 4');
                for(SAP_OM_Staging__c sapOM:SAPList){
                    stagingOpportunity=new Opportunity();
                    system.debug('During insert test One');
                    if(isStageUpdate){
                        Opportunity opportunityWithStage = opportunityWithSAP.get(sapOM.id);
                        system.debug('sapOM.sapOmOldMap 74:'+sapOmOldMap.get(sapOm.id).BPONR__c);
                        system.debug('sapOM.BPONR__c :'+sapOM.BPONR__c);
                        
                        if(sapOM.BPONR__c != sapOmOldMap.get(sapOm.id).BPONR__c){
                            if(sapOM.BPONR__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                if(sapOM.BPONR__c > sapOmOldMap.get(sapOm.id).BPONR__c){
                                    stagingOpportunity.BPO_Net_Rev__c=opportunityWithStage.BPO_Net_Rev__c + (sapOM.BPONR__c - sapOmOldMap.get(sapOm.id).BPONR__c);
                                }else if (sapOM.BPONR__c < sapOmOldMap.get(sapOm.id).BPONR__c){
                                    stagingOpportunity.BPO_Net_Rev__c=opportunityWithStage.BPO_Net_Rev__c - (sapOmOldMap.get(sapOm.id).BPONR__c - sapOM.BPONR__c);
                                }
                                
                            }else if (sapOM.BPONR__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Standalone')){
                                stagingOpportunity.BPO_Net_Rev__c=sapOM.BPONR__c;
                            }else if(sapOM.BPONR__c ==null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                stagingOpportunity.BPO_Net_Rev__c=opportunityWithStage.BPO_Net_Rev__c - sapOmOldMap.get(sapOm.id).BPONR__c;
                            }else if(sapOM.Hierarchy_Level__c==null && sapOM.BPONR__c !=null){
                                stagingOpportunity.BPO_Net_Rev__c=sapOM.BPONR__c;
                            }else if(sapOM.BPONR__c ==null){
                                stagingOpportunity.BPO_Net_Rev__c=0;
                            }
                            stagingOpportunity.BPO_Net_Rev_Thousands__c=stagingOpportunity.BPO_Net_Rev__c;  
                        }
                        
                        if(sapOM.IC_Net_Revenue__c != sapOmOldMap.get(sapOm.id).IC_Net_Revenue__c){
                            if(sapOM.IC_Net_Revenue__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                   if(sapOM.IC_Net_Revenue__c > sapOmOldMap.get(sapOm.id).IC_Net_Revenue__c){
                                      stagingOpportunity.IC_Net_Revenue_SAP_OM_Thousands__c=opportunityWithStage.IC_Net_Revenue_SAP_OM_Thousands__c + (sapOM.IC_Net_Revenue__c - sapOmOldMap.get(sapOm.id).IC_Net_Revenue__c);
                                   }else if (sapOM.IC_Net_Revenue__c < sapOmOldMap.get(sapOm.id).IC_Net_Revenue__c){
                                       stagingOpportunity.IC_Net_Revenue_SAP_OM_Thousands__c=opportunityWithStage.IC_Net_Revenue_SAP_OM_Thousands__c - (sapOmOldMap.get(sapOm.id).IC_Net_Revenue__c - sapOM.IC_Net_Revenue__c );
                                   }
                                    
                                }else if (sapOM.IC_Net_Revenue__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Standalone')){
                                    stagingOpportunity.IC_Net_Revenue_SAP_OM_Thousands__c=sapOM.IC_Net_Revenue__c;
                                }else if(sapOM.IC_Net_Revenue__c ==null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    stagingOpportunity.IC_Net_Revenue_SAP_OM_Thousands__c=opportunityWithStage.IC_Net_Revenue_SAP_OM_Thousands__c - sapOmOldMap.get(sapOm.id).IC_Net_Revenue__c;
                                }else if(sapOM.Hierarchy_Level__c==null && sapOM.IC_Net_Revenue__c !=null){
                                    stagingOpportunity.IC_Net_Revenue_SAP_OM_Thousands__c=sapOM.IC_Net_Revenue__c;
                                }else if(sapOM.IC_Net_Revenue__c ==null){
                                    stagingOpportunity.IC_Net_Revenue_SAP_OM_Thousands__c=0;
                                }
                                stagingOpportunity.IC_Net_Rev_Thousands__c=stagingOpportunity.IC_Net_Revenue_SAP_OM_Thousands__c; 
                        }
                        
                        if(sapOM.IO_Net_Revenue__c != sapOmOldMap.get(sapOm.id).IO_Net_Revenue__c){
                            if(sapOM.IO_Net_Revenue__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    if(sapOM.IO_Net_Revenue__c > sapOmOldMap.get(sapOm.id).IO_Net_Revenue__c){
                                        stagingOpportunity.IO_Net_Rev_SAP_OM_Thousands__c=opportunityWithStage.IO_Net_Rev_SAP_OM_Thousands__c + (sapOM.IO_Net_Revenue__c - sapOmOldMap.get(sapOm.id).IO_Net_Revenue__c);
                                    }else if (sapOM.IO_Net_Revenue__c < sapOmOldMap.get(sapOm.id).IO_Net_Revenue__c){
                                        stagingOpportunity.IO_Net_Rev_SAP_OM_Thousands__c=opportunityWithStage.IO_Net_Rev_SAP_OM_Thousands__c - (sapOmOldMap.get(sapOm.id).IO_Net_Revenue__c - sapOM.IO_Net_Revenue__c);
                                    }
                                    
                                }else if (sapOM.IO_Net_Revenue__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Standalone')){
                                    stagingOpportunity.IO_Net_Rev_SAP_OM_Thousands__c=sapOM.IO_Net_Revenue__c;
                                }else if(sapOM.IO_Net_Revenue__c ==null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    stagingOpportunity.IO_Net_Rev_SAP_OM_Thousands__c=opportunityWithStage.IO_Net_Rev_SAP_OM_Thousands__c - sapOmOldMap.get(sapOm.id).IO_Net_Revenue__c;
                                }else if(sapOM.Hierarchy_Level__c==null && sapOM.IO_Net_Revenue__c !=null){
                                    stagingOpportunity.IO_Net_Rev_SAP_OM_Thousands__c=sapOM.IO_Net_Revenue__c;
                                }else if(sapOM.IO_Net_Revenue__c ==null){
                                    stagingOpportunity.IO_Net_Rev_SAP_OM_Thousands__c=0;
                                }
                                stagingOpportunity.IO_Net_Revenue_Thousands__c=stagingOpportunity.IO_Net_Rev_SAP_OM_Thousands__c; 
                        }
                        
                         if(sapOM.TNR__c != sapOmOldMap.get(sapOm.id).TNR__c){
                            if(sapOM.TNR__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    if(sapOM.TNR__c > sapOmOldMap.get(sapOm.id).TNR__c){
                                        stagingOpportunity.Total_Net_Rev__c=opportunityWithStage.Total_Net_Rev__c + (sapOM.TNR__c - sapOmOldMap.get(sapOm.id).TNR__c);
                                    }else if (sapOM.TNR__c < sapOmOldMap.get(sapOm.id).TNR__c){
                                        stagingOpportunity.Total_Net_Rev__c=opportunityWithStage.Total_Net_Rev__c - (sapOmOldMap.get(sapOm.id).TNR__c - sapOM.TNR__c);
                                    }
                                    
                                }else if (sapOM.TNR__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Standalone')){
                                    stagingOpportunity.Total_Net_Rev__c=sapOM.TNR__c;
                                }else if(sapOM.TNR__c ==null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    stagingOpportunity.Total_Net_Rev__c=opportunityWithStage.Total_Net_Rev__c - sapOmOldMap.get(sapOm.id).TNR__c;
                                }else if(sapOM.Hierarchy_Level__c==null && sapOM.TNR__c !=null){
                                    stagingOpportunity.Total_Net_Rev__c=sapOM.TNR__c;
                                }else if(sapOM.TNR__c ==null){
                                    stagingOpportunity.Total_Net_Rev__c=0;
                                }
                         }
                        // added recently
                        if(sapOM.TCNR__c != sapOmOldMap.get(sapOm.id).TCNR__c){
                            if(sapOM.TCNR__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    if(sapOM.TCNR__c > sapOmOldMap.get(sapOm.id).TCNR__c){
                                        stagingOpportunity.Total_Current_Net_Rev__c=opportunityWithStage.Total_Current_Net_Rev__c + (sapOM.TCNR__c - sapOmOldMap.get(sapOm.id).TCNR__c);
                                    }else if (sapOM.TCNR__c < sapOmOldMap.get(sapOm.id).TCNR__c){
                                        stagingOpportunity.Total_Current_Net_Rev__c=opportunityWithStage.Total_Current_Net_Rev__c - (sapOmOldMap.get(sapOm.id).TCNR__c - sapOM.TCNR__c);
                                    }
                                    
                                }else if (sapOM.TCNR__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Standalone')){
                                    stagingOpportunity.Total_Current_Net_Rev__c=sapOM.TCNR__c;
                                }else if(sapOM.TCNR__c ==null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    stagingOpportunity.Total_Current_Net_Rev__c=opportunityWithStage.Total_Current_Net_Rev__c - sapOmOldMap.get(sapOm.id).TCNR__c;
                                }else if(sapOM.Hierarchy_Level__c==null && sapOM.TCNR__c !=null){
                                    stagingOpportunity.Total_Current_Net_Rev__c=sapOM.TCNR__c;
                                }else if(sapOM.TCNR__c ==null){
                                    stagingOpportunity.Total_Current_Net_Rev__c=0;
                                }
                         }
                        
                        if(sapOM.TC_Net_Rev__c != sapOmOldMap.get(sapOm.id).TC_Net_Rev__c){
                            if(sapOM.TC_Net_Rev__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                if(sapOM.TC_Net_Rev__c > sapOmOldMap.get(sapOm.id).TC_Net_Rev__c){
                                    stagingOpportunity.TC_Net_Rev__c=opportunityWithStage.TC_Net_Rev__c + (sapOM.TC_Net_Rev__c - sapOmOldMap.get(sapOm.id).TC_Net_Rev__c);
                                }else if (sapOM.TC_Net_Rev__c < sapOmOldMap.get(sapOm.id).TC_Net_Rev__c){
                                    stagingOpportunity.TC_Net_Rev__c=opportunityWithStage.TC_Net_Rev__c - (sapOmOldMap.get(sapOm.id).TC_Net_Rev__c - sapOM.TC_Net_Rev__c);
                                }
                                
                            }else if (sapOM.TC_Net_Rev__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Standalone')){
                                stagingOpportunity.TC_Net_Rev__c=sapOM.TC_Net_Rev__c;
                            }else if(sapOM.TC_Net_Rev__c ==null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                stagingOpportunity.TC_Net_Rev__c=opportunityWithStage.TC_Net_Rev__c - sapOmOldMap.get(sapOm.id).TC_Net_Rev__c;
                            }else if(sapOM.Hierarchy_Level__c==null && sapOM.TC_Net_Rev__c !=null){
                                stagingOpportunity.TC_Net_Rev__c=sapOM.TC_Net_Rev__c;
                            }else if(sapOM.TC_Net_Rev__c ==null){
                                stagingOpportunity.TC_Net_Rev__c=0;
                            }
                        }
                        //changes are done
                        
                        
                        if(sapOM.Cons_Net_Revenue__c != sapOmOldMap.get(sapOm.id).Cons_Net_Revenue__c){
                            if(sapOM.Cons_Net_Revenue__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    if(sapOM.Cons_Net_Revenue__c > sapOmOldMap.get(sapOm.id).Cons_Net_Revenue__c){
                                        stagingOpportunity.Cons_Net_Revenue__c=opportunityWithStage.Cons_Net_Revenue__c + (sapOM.Cons_Net_Revenue__c - sapOmOldMap.get(sapOm.id).Cons_Net_Revenue__c);
                                    }else if (sapOM.Cons_Net_Revenue__c < sapOmOldMap.get(sapOm.id).Cons_Net_Revenue__c){
                                        stagingOpportunity.Cons_Net_Revenue__c=opportunityWithStage.Cons_Net_Revenue__c - (sapOmOldMap.get(sapOm.id).Cons_Net_Revenue__c - sapOM.Cons_Net_Revenue__c);
                                    }
                                    
                                }else if (sapOM.Cons_Net_Revenue__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Standalone')){
                                    stagingOpportunity.Cons_Net_Revenue__c=sapOM.Cons_Net_Revenue__c;
                                }else if(sapOM.Cons_Net_Revenue__c ==null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    stagingOpportunity.Cons_Net_Revenue__c=opportunityWithStage.Cons_Net_Revenue__c - sapOmOldMap.get(sapOm.id).Cons_Net_Revenue__c;
                                }else if(sapOM.Hierarchy_Level__c==null && sapOM.Cons_Net_Revenue__c !=null){
                                    stagingOpportunity.Cons_Net_Revenue__c=sapOM.Cons_Net_Revenue__c;
                                }else if(sapOM.Cons_Net_Revenue__c ==null){
                                    stagingOpportunity.Cons_Net_Revenue__c=0;
                                }
                        }
                        
                         if(sapOM.OS_net_revenue__c != sapOmOldMap.get(sapOm.id).OS_net_revenue__c){
                            if(sapOM.OS_net_revenue__c !=null && sapOM.Hierarchy_Level__c=='Parent'){
                                    if(sapOM.OS_net_revenue__c > sapOmOldMap.get(sapOm.id).OS_net_revenue__c){
                                        stagingOpportunity.OS_net_revenue__c=opportunityWithStage.OS_net_revenue__c + (sapOM.OS_net_revenue__c - sapOmOldMap.get(sapOm.id).OS_net_revenue__c);
                                    }else if (sapOM.OS_net_revenue__c < sapOmOldMap.get(sapOm.id).OS_net_revenue__c){
                                        stagingOpportunity.OS_net_revenue__c=opportunityWithStage.OS_net_revenue__c - (sapOmOldMap.get(sapOm.id).OS_net_revenue__c - sapOM.OS_net_revenue__c);
                                    }
                                    
                                }else if (sapOM.OS_net_revenue__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Standalone')){
                                    stagingOpportunity.OS_net_revenue__c=sapOM.OS_net_revenue__c;
                                }else if(sapOM.OS_net_revenue__c ==null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    stagingOpportunity.OS_net_revenue__c=opportunityWithStage.OS_net_revenue__c - sapOmOldMap.get(sapOm.id).OS_net_revenue__c;
                                }else if(sapOM.Hierarchy_Level__c==null && sapOM.OS_net_revenue__c !=null){
                                    stagingOpportunity.OS_net_revenue__c=sapOM.OS_net_revenue__c;
                                }else if(sapOM.OS_net_revenue__c ==null){
                                    stagingOpportunity.OS_net_revenue__c=0;
                                }
                        }  
                        
                        if(sapOM.MC_Net_Revenue__c != sapOmOldMap.get(sapOm.id).MC_Net_Revenue__c){
                            if(sapOM.MC_Net_Revenue__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    if(sapOM.MC_Net_Revenue__c > sapOmOldMap.get(sapOm.id).MC_Net_Revenue__c){
                                        stagingOpportunity.MC_Net_Revenue__c=opportunityWithStage.MC_Net_Revenue__c + (sapOM.MC_Net_Revenue__c - sapOmOldMap.get(sapOm.id).MC_Net_Revenue__c);
                                    }else if (sapOM.MC_Net_Revenue__c < sapOmOldMap.get(sapOm.id).MC_Net_Revenue__c){
                                        stagingOpportunity.MC_Net_Revenue__c=opportunityWithStage.MC_Net_Revenue__c - (sapOmOldMap.get(sapOm.id).MC_Net_Revenue__c - sapOM.MC_Net_Revenue__c);
                                    }
                                    
                                }else if (sapOM.MC_Net_Revenue__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Standalone')){
                                    stagingOpportunity.MC_Net_Revenue__c=sapOM.MC_Net_Revenue__c;
                                }else if(sapOM.MC_Net_Revenue__c ==null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    stagingOpportunity.MC_Net_Revenue__c=opportunityWithStage.MC_Net_Revenue__c - sapOmOldMap.get(sapOm.id).MC_Net_Revenue__c;
                                }else if(sapOM.Hierarchy_Level__c==null && sapOM.MC_Net_Revenue__c !=null){
                                    stagingOpportunity.MC_Net_Revenue__c=sapOM.MC_Net_Revenue__c;
                                }else if(sapOM.MC_Net_Revenue__c ==null){
                                    stagingOpportunity.MC_Net_Revenue__c=0;
                                }
                        }    
                        
                        if(sapOM.SC_Net_Revenue__c != sapOmOldMap.get(sapOm.id).SC_Net_Revenue__c){
                            if(sapOM.SC_Net_Revenue__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    if(sapOM.SC_Net_Revenue__c > sapOmOldMap.get(sapOm.id).SC_Net_Revenue__c){
                                        stagingOpportunity.SC_Net_Revenue__c=opportunityWithStage.SC_Net_Revenue__c + (sapOM.SC_Net_Revenue__c - sapOmOldMap.get(sapOm.id).SC_Net_Revenue__c);
                                    }else if (sapOM.SC_Net_Revenue__c < sapOmOldMap.get(sapOm.id).SC_Net_Revenue__c){
                                        stagingOpportunity.SC_Net_Revenue__c=opportunityWithStage.SC_Net_Revenue__c - (sapOmOldMap.get(sapOm.id).SC_Net_Revenue__c - sapOM.SC_Net_Revenue__c);
                                    }
                                    
                                }else if (sapOM.SC_Net_Revenue__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Standalone')){
                                    stagingOpportunity.SC_Net_Revenue__c=sapOM.SC_Net_Revenue__c;
                                }else if(sapOM.SC_Net_Revenue__c ==null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    stagingOpportunity.SC_Net_Revenue__c=opportunityWithStage.SC_Net_Revenue__c - sapOmOldMap.get(sapOm.id).SC_Net_Revenue__c;
                                }else if(sapOM.Hierarchy_Level__c==null && sapOM.SC_Net_Revenue__c !=null){
                                    stagingOpportunity.SC_Net_Revenue__c=sapOM.SC_Net_Revenue__c;
                                }else if(sapOM.SC_Net_Revenue__c ==null){
                                    stagingOpportunity.SC_Net_Revenue__c=0;
                                }
                        }   
                        
                       if(sapOM.SI_Net_Revenue__c != sapOmOldMap.get(sapOm.id).SI_Net_Revenue__c){
                           if(sapOM.SI_Net_Revenue__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    if(sapOM.SI_Net_Revenue__c > sapOmOldMap.get(sapOm.id).SI_Net_Revenue__c){
                                        stagingOpportunity.SI_Net_Revenue__c=opportunityWithStage.SI_Net_Revenue__c + (sapOM.SI_Net_Revenue__c - sapOmOldMap.get(sapOm.id).SI_Net_Revenue__c);
                                    }else if (sapOM.SI_Net_Revenue__c < sapOmOldMap.get(sapOm.id).SI_Net_Revenue__c){
                                        stagingOpportunity.SI_Net_Revenue__c=opportunityWithStage.SI_Net_Revenue__c - (sapOmOldMap.get(sapOm.id).SI_Net_Revenue__c - sapOM.SI_Net_Revenue__c);
                                    }
                                    
                                }else if (sapOM.SI_Net_Revenue__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Standalone')){
                                    stagingOpportunity.SI_Net_Revenue__c=sapOM.SI_Net_Revenue__c;
                                }else if(sapOM.SI_Net_Revenue__c ==null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    stagingOpportunity.SI_Net_Revenue__c=opportunityWithStage.SI_Net_Revenue__c - sapOmOldMap.get(sapOm.id).SI_Net_Revenue__c;
                                }else if(sapOM.Hierarchy_Level__c==null && sapOM.SI_Net_Revenue__c !=null){
                                    stagingOpportunity.SI_Net_Revenue__c=sapOM.SI_Net_Revenue__c;
                                }else if(sapOM.SI_Net_Revenue__c ==null){
                                    stagingOpportunity.SI_Net_Revenue__c=0;
                                }
                        }    
                        
                        if(sapOM.AO_Net_Revenue__c != sapOmOldMap.get(sapOm.id).AO_Net_Revenue__c){
                            if(sapOM.AO_Net_Revenue__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    if(sapOM.AO_Net_Revenue__c > sapOmOldMap.get(sapOm.id).AO_Net_Revenue__c){
                                        stagingOpportunity.AO_Net_Revenue__c=opportunityWithStage.AO_Net_Revenue__c + (sapOM.AO_Net_Revenue__c - sapOmOldMap.get(sapOm.id).AO_Net_Revenue__c);
                                    }else if (sapOM.AO_Net_Revenue__c < sapOmOldMap.get(sapOm.id).AO_Net_Revenue__c){
                                        stagingOpportunity.AO_Net_Revenue__c=opportunityWithStage.AO_Net_Revenue__c - (sapOmOldMap.get(sapOm.id).AO_Net_Revenue__c - sapOM.AO_Net_Revenue__c);
                                    }
                                    
                                }else if (sapOM.AO_Net_Revenue__c !=null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Standalone')){
                                    stagingOpportunity.AO_Net_Revenue__c=sapOM.AO_Net_Revenue__c;
                                }else if(sapOM.AO_Net_Revenue__c ==null && (sapOM.Hierarchy_Level__c).equalsIgnoreCase('Parent')){
                                    stagingOpportunity.AO_Net_Revenue__c=opportunityWithStage.AO_Net_Revenue__c - sapOmOldMap.get(sapOm.id).AO_Net_Revenue__c;
                                }else if(sapOM.Hierarchy_Level__c==null && sapOM.AO_Net_Revenue__c !=null){
                                    stagingOpportunity.AO_Net_Revenue__c=sapOM.AO_Net_Revenue__c;
                                }else if(sapOM.AO_Net_Revenue__c ==null){
                                    stagingOpportunity.AO_Net_Revenue__c=0;
                                }
                        }     
                    }else{
                        System.debug('Came here in insert ');
                        if(sapOM.BPONR__c <1 && sapOm.BPONR__c>0){
                            stagingOpportunity.BPO_Net_Rev__c=1;
                        }else if(sapOm.BPONR__c==null){
                            stagingOpportunity.BPO_Net_Rev__c=0;
                        }else {
                            stagingOpportunity.BPO_Net_Rev__c = sapOM.BPONR__c;
                        }
                        
                        if(sapOM.IO_Net_Revenue__c <1 && sapOM.IO_Net_Revenue__c>0){
                            stagingOpportunity.IO_Net_Rev_SAP_OM_Thousands__c=1;
                        }else if(sapOM.IO_Net_Revenue__c ==null) {
                            stagingOpportunity.IO_Net_Rev_SAP_OM_Thousands__c=0;
                        }else{
                            stagingOpportunity.IO_Net_Rev_SAP_OM_Thousands__c=sapOM.IO_Net_Revenue__c;
                        }
                        
                        if(sapOM.IC_Net_Revenue__c <1 && sapOM.IC_Net_Revenue__c>0){
                            stagingOpportunity.IC_Net_Revenue_SAP_OM_Thousands__c=1;
                        }else if(sapOM.IC_Net_Revenue__c==null){
                            stagingOpportunity.IC_Net_Revenue_SAP_OM_Thousands__c=0;
                        }else {
                            stagingOpportunity.IC_Net_Revenue_SAP_OM_Thousands__c=sapOM.IC_Net_Revenue__c;
                        }
                        
                        if(sapOM.Cons_Net_Revenue__c <1 && sapOM.Cons_Net_Revenue__c>0){
                            stagingOpportunity.Cons_Net_Revenue__c=1;
                        }else if(sapOM.Cons_Net_Revenue__c==null){
                            stagingOpportunity.Cons_Net_Revenue__c=0;
                        }else {
                            stagingOpportunity.Cons_Net_Revenue__c=sapOM.Cons_Net_Revenue__c;
                        }
                         if(sapOM.OS_net_revenue__c <1 && sapOM.OS_net_revenue__c>0){
                            stagingOpportunity.OS_net_revenue__c=1;
                        }else if(sapOM.OS_net_revenue__c==null){
                            stagingOpportunity.OS_net_revenue__c=0;
                        }else {
                            stagingOpportunity.OS_net_revenue__c=sapOM.OS_net_revenue__c;
                        }
                         if(sapOM.MC_Net_Revenue__c <1 && sapOM.MC_Net_Revenue__c>0){
                            stagingOpportunity.MC_Net_Revenue__c=1;
                        }else if(sapOM.MC_Net_Revenue__c==null){
                            stagingOpportunity.MC_Net_Revenue__c=0;
                        }else {
                            stagingOpportunity.MC_Net_Revenue__c=sapOM.MC_Net_Revenue__c;
                        }
                         if(sapOM.SC_Net_Revenue__c <1 && sapOM.SC_Net_Revenue__c>0){
                            stagingOpportunity.SC_Net_Revenue__c=1;
                        }else if(sapOM.SC_Net_Revenue__c==null){
                            stagingOpportunity.SC_Net_Revenue__c=0;
                        }else {
                            stagingOpportunity.SC_Net_Revenue__c=sapOM.SC_Net_Revenue__c;
                        }
                         if(sapOM.SI_Net_Revenue__c <1 && sapOM.SI_Net_Revenue__c>0){
                            stagingOpportunity.SI_Net_Revenue__c=1;
                        }else if(sapOM.SI_Net_Revenue__c==null){
                            stagingOpportunity.SI_Net_Revenue__c=0;
                        }else {
                            stagingOpportunity.SI_Net_Revenue__c=sapOM.SI_Net_Revenue__c;
                        }
                         if(sapOM.AO_Net_Revenue__c <1 && sapOM.AO_Net_Revenue__c>0){
                            stagingOpportunity.AO_Net_Revenue__c=1;
                        }else if(sapOM.AO_Net_Revenue__c==null){
                            stagingOpportunity.AO_Net_Revenue__c=0;
                        }else {
                            stagingOpportunity.AO_Net_Revenue__c=sapOM.AO_Net_Revenue__c;
                        }
                         if(sapOM.TNR__c <1 && sapOM.TNR__c>0){
                            stagingOpportunity.Total_Net_Rev__c=1;
                        }else if(sapOM.TNR__c==null){
                            stagingOpportunity.Total_Net_Rev__c=0;
                        }else {
                            stagingOpportunity.Total_Net_Rev__c=sapOM.TNR__c;
                        }
                         if(sapOM.TCNR__c <1 && sapOM.TCNR__c>0){
                            stagingOpportunity.Total_Current_Net_Rev__c=1;
                        }else if(sapOM.TCNR__c==null){
                            stagingOpportunity.Total_Current_Net_Rev__c=0;
                        }else {
                            stagingOpportunity.Total_Current_Net_Rev__c=sapOM.TCNR__c;
                        } 
                        
                        if(sapOM.TC_Net_Rev__c <1 && sapOM.TC_Net_Rev__c>0){
                            stagingOpportunity.TC_Net_Rev__c=1;
                        }else if(sapOM.TC_Net_Rev__c==null){
                            stagingOpportunity.TC_Net_Rev__c=0;
                        }else {
                            stagingOpportunity.TC_Net_Rev__c=sapOM.TC_Net_Rev__c;
                        } 
                        stagingOpportunity.OwnerId=systemUser.User_Id__c; 
                        
                        stagingOpportunity.IC_Net_Rev_Thousands__c = stagingOpportunity.IC_Net_Revenue_SAP_OM_Thousands__c;
                        stagingOpportunity.IO_Net_Revenue_Thousands__c = stagingOpportunity.IO_Net_Rev_SAP_OM_Thousands__c;
                        stagingOpportunity.BPO_Net_Rev_Thousands__c = stagingOpportunity.BPO_Net_Rev__c;
                       
                        
                    }
                    if(sapOM.pipeline_entry_date__c !=null)
                    {
                        stagingOpportunity.CloseDate = sapOM.pipeline_entry_date__c;
                    }else{
                        stagingOpportunity.CloseDate = system.today();
                    }
        
                    operatingGroupId=operatingGroupMap.get(sapOM.OG__c);
                    stagingOpportunity.BPO_Total_CCI__c=sapOM.bpo_cci__c;
                    stagingOpportunity.BPO_Total_CCI__c = sapOM.bpo_cci__c;
                    stagingOpportunity.OperatingGroup__c = operatingGroupId; 
                    stagingOpportunity.BPO_Total_CCI_Per__c = sapOM.bpo_total_cci__c;
                    stagingOpportunity.Competitive_Sole_Source__c = sapOM.competitive_sole_source__c;
                    stagingOpportunity.AccountID=accountMap.get(sapOM.master_client_name__c);
                    stagingOpportunity.Name = sapOM.Opportunity_name__c;
                    stagingOpportunity.StageName = sapOM.Stage__c;
                    stagingOpportunity.SAP_OM_Item_Id__c=sapOM.id;
                    stagingOpportunity.Actual_Contract_Sign_Date__c=sapOM.Actual_Contract_Sign_Date__c;
                    stagingOpportunity.Competitor__c = sapOM.competitor__c;
                    stagingOpportunity.Contract_Extension_Flag__c = sapOM.contract_extension_flag__c;
                    stagingOpportunity.CR_Name__c = sapOM.CR_name__c;
                    stagingOpportunity.CSG__c = sapOM.CSG__c;
                    stagingOpportunity.Deal_Total_CCI__c = sapOM.CCI__c;
                    stagingOpportunity.Deal_Total_CCI_Per__c = sapOM.total_CCI__c;
                    stagingOpportunity.Delivery_Centers__c = sapOM.delivery_centers__c;
                    stagingOpportunity.ECSD_Quarter__c = sapOM.ECSD_quarter__c;
                    stagingOpportunity.Function_Business_Services__c = sapOM.function_business_services__c;
                    stagingOpportunity.Geo_Area__c = sapOM.geo_area__c;
                    stagingOpportunity.Geo_Unit__c = sapOM.geo_unit__c;
                    stagingOpportunity.Geo_Region__c = getGeoRegion(stagingOpportunity.Geo_Area__c,stagingOpportunity.Geo_Unit__c);
                    stagingOpportunity.Industry_Business_Services__c = sapOM.industry_business_services__c;
                    stagingOpportunity.Industry_Segment__c = sapOM.industry_segment__c;
                    stagingOpportunity.Master_Client_Class__c = sapOM.master_client_class__c;
                    stagingOpportunity.Master_Client_Name__c = sapOM.Master_Client_Name__c;
                    stagingOpportunity.Mergers_Acquisitions__c = sapOM.mergers_acquisitions__c;
                    stagingOpportunity.Operating_Unit__c = sapOM.OU__c;
                    stagingOpportunity.Pricing_Structure__c = sapOM.pricing_structure__c;
                    stagingOpportunity.Primary_Work_Location__c = sapOM.primary_work_location__c;
                    stagingOpportunity.Reason__c = sapOM.reason__c;
                    stagingOpportunity.Reporting_Status__c = sapOM.reporting_status__c;
                    stagingOpportunity.Restricted__c = sapOM.restricted__c;
                    stagingOpportunity.RSD_Quarter__c = sapOM.RSD_quarter__c;
                    stagingOpportunity.Sales_Forecast_Watch__c = sapOM.sales_forecast_watch__c;
                    stagingOpportunity.SAP_OM_ID__c = sapOM.Opportunity_ID__c;
                    stagingOpportunity.Sub_CSG__c = sapOM.sub_CSG__c;
                    stagingOpportunity.Target_Margin_Per__c = sapOM.target_margin__c;
                    stagingOpportunity.Total_CCI_Per__c = sapOM.total_CCI__c;
                    stagingOpportunity.Total_Sol_Contingency_Amt__c = sapOM.TCNR__c;
                    stagingOpportunity.Total_Sol_Contingency_Per__c = sapOM.total_solution_contingency__c;
                    stagingOpportunity.Probability = sapOM.win_probability__c;
                    stagingOpportunity.Winning_Competitor__c = sapOM.winning_competitor__c;
                    stagingOpportunity.Third_Party_Adv__c = sapOM.third_party_advisor__c;
                    stagingOpportunity.Create_Date_SAP__c = sapOM.create_date_SAP__c;
                    stagingOpportunity.Expected_Contract_Signing_Date__c = sapOM.expected_contract_signing_date__c;
                    stagingOpportunity.Pipeline_Entry_Date__c = sapOM.pipeline_entry_date__c;
                    stagingOpportunity.Proposal_Submission_Date__c = sapOM.proposal_submission_date__c;
                    stagingOpportunity.Stage_Update_Date__c = sapOM.stage_update_date__c;
                    stagingOpportunity.Opportunity_Class__c = sapOM.Opportunity_Class__c;
                    stagingOpportunity.Offerings_SAP_Rev_Mix_BPO__c = sapOM.Offerings_SAP_Rev_Mix_BPO__c;
                    stagingOpportunity.Client_Account_Lead__c = sapOM.Client_Account_Lead__c;
                    stagingOpportunity.Solution_Arch_BPO__c = sapOM.Solution_Arch_BPO__c;
                    stagingOpportunity.Opportunity_QA_Director__c = sapOM.Opportunity_QA_director__c;   
                    
                    
                    stagingOpportunity.Hrchy_Lvl__c  = sapOM.Hierarchy_Level__c;
                    stagingOpportunity.Hierarchy_Type__c = sapOM.Hierarchy_Type__c;
                    
                    if (sapOM.restricted__c != null && sapOM.restricted__c.equals(utilConstants.Y_APHA)) {
                        stagingOpportunity.Confidential_Opp__c = true;
                    } else if ((sapOM.restricted__c != null && sapOM.restricted__c.equals(utilConstants.N_ALPHA)) || sapOM.restricted__c == NULL) {
                        stagingOpportunity.Confidential_Opp__c = false;
                    }
                    
                    System.debug('Came here one');
                    if (sapOM.BPONR__c > 0 ) {
                        stagingOpportunity.SAP_Modified_Date__c = system.today();
                    }
                    if (sapOM.IO_Net_Revenue__c > 0) {
                        stagingOpportunity.SAP_Modified_Date_IO__c = system.today();
                    }
                    if (sapOM.IC_Net_Revenue__c > 0 ) {
                        stagingOpportunity.SAP_Modified_Date_IC__c = system.today();
                    }
                    
                    if(!isStageUpdate && parentChild){
                        updateChildSAP.add(sapOM.id);
                    }
                    if(sapOM.Hierarchy_Level__c == 'Child' && sapOM.Parent_ID__c!=null){
                        sapIdtoUpdate.add(sapOM.id);
                        
                    }else if(sapOM.Hierarchy_Level__c == 'Child' && sapOM.Parent_ID__c==null){
                        sapIdtoUpdate.add(sapOm.id);
                        OpportunityList.add(stagingOpportunity);
                    }else if(sapOM.Hierarchy_Level__c == 'Parent' || sapOM.Hierarchy_Level__c == 'Standalone') {
                        System.debug('Debug issue test threee');
                        OpportunityList.add(stagingOpportunity);
                    }
                    
                    //createOpportunityOfferings(sapOM);
                    
                }
                
                
                
                Schema.SObjectField sapSuperField=Opportunity.Fields.SAP_OM_ID__c;
                
                if(!OpportunityList.isEmpty()){
                    
                    Database.upsert(OpportunityList,sapSuperField,true);
                }
                
                for(Opportunity oppo:[select id,SAP_OM_Item_Id__c,SAP_OM_ID__c from Opportunity where SAP_OM_ID__c IN :sapParentId]){
                    oppWithParentIdMap.put(oppo.SAP_OM_ID__c,oppo.id);
                    stageOpportunityMap.put(oppo.SAP_OM_ID__c,oppo.id);
                }
                
                for(SAP_OM_Staging__c sapAlpha:[select id,Parent_Opportunity__c,Parent_ID__c,Hierarchy_Level__c from SAP_OM_Staging__c where id in:sapIdtoUpdate]){
                    if(sapAlpha.Hierarchy_Level__c == 'Child' && sapAlpha.Parent_ID__c!=null){
                        
                        sapAlpha.Parent_Opportunity__c=oppWithParentIdMap.get(sapAlpha.Parent_ID__c);
                        stagingList.add(sapAlpha);
                    }else if(sapAlpha.Hierarchy_Level__c == 'Child' && sapAlpha.Parent_ID__c==null){
                        sapAlpha.Hierarchy_Level__c='Standalone';
                        stagingList.add(sapAlpha);
                    }
                }
                if(stagingList!=null && !stagingList.isEmpty()){
                    database.update(stagingList);
                }
                
                /*if (isStageUpdate) {
                    createUpdateChildRecords(true);
                }*/
                for(SAP_OM_Staging__c sapBeta:[select Parent_Opportunity__c,Parent_ID__c,Hierarchy_Level__c from SAP_OM_Staging__c where id in:updateChildSAP]){
                    sapBeta.Parent_Opportunity__c=null;
                    sapBeta.Parent_ID__c=null;
                    sapParentChildList.add(sapBeta);
                }
                
                if(sapParentChildList!=null && !sapParentChildList.isEmpty()){
                    database.update(sapParentChildList);
                }
                //createOpportunityAdditionalTeamAndOffering(SAPList);
                //insertOpportunityOfferings();
                
            }catch(Exception e){
                
            }    
                    
         }
        
        public static void saveAccountDetails(List<SAP_OM_Staging__c> SAPList){
            IOCostModelUpload.stopTriggerExecution = false;
          // UtilConstants.stopTriggersForIO = FALSE;
            set<String> masterAcccountName=new set<String>();
            for(SAP_OM_Staging__c sap:SAPList){
                masterAcccountName.add(sap.master_client_name__c);
            }
            for(Account account:[select id,name from Account where Name IN :masterAcccountName]){
                accountMap.put(account.name,account.id);
            }
        }
        
    
        
        public static String getGeoRegion(String geoArea,String geoUnit){
            IOCostModelUpload.stopTriggerExecution = false;
            //UtilConstants.stopTriggersForIO = FALSE;
            String geoRegion = UtilConstants.BLANK ;
            if( geoArea.equals(utilConstants.APAC) || geoArea.equals(UTIL_Constants.AsiaPacific)){
                geoRegion = UTIL_Constants.AsiaPacific;
            }else if( geoArea.equals(utilConstants.EALA) && (!geoUnit.equals(utilConstants.LATIN_AMERICA)) ){
                geoRegion = utilConstants.EMEA;
            }else if( geoArea.equals(utilConstants.EALA) && geoUnit.equals(utilConstants.LATIN_AMERICA) ){
                geoRegion = utilConstants.LATIN_AMERICA;
            }else if( geoArea.equals(utilConstants.NORTH_AMERICA)){
                geoRegion = utilConstants.NORTH_AMERICA;
            }else{
                geoRegion = geoArea;
            }
            if(geoRegionMap.containsKey(geoRegion)){
                return geoRegionMap.get(geoRegion);
            }else{
                return null;
            }
        }
        
        /******************************
        Method Name: createOpportunityAdditionalTeam
        Description: Method to create Opportunity Additional team Record
        Paramenters: stgRec 
        Return Value: void
        *****************************/
        public static void createOpportunityAdditionalTeam(List<SAP_OM_Staging__c> stgRecList,Boolean flag) {
            IOCostModelUpload.stopTriggerExecution = false;
            //UtilConstants.stopTriggersForIO = FALSE;
            set<String> sapSet=new set<String>();
            Opportunity_Additional_Team__c oppAdditionaTeamRec;
            
    
            String serviceGroup = UtilConstants.BLANK_SPACE; 
            List<Opportunity_Additional_Team__c> addTeamList=new List<Opportunity_Additional_Team__c>();
            List<Opportunity_Additional_Team__c> addTeamListToDelete=new List<Opportunity_Additional_Team__c>();
            Map<String,Opportunity_Additional_Team__c> oppTeamWithSAP=new Map<String,Opportunity_Additional_Team__c>();
            fieldSetMemberList = readFieldSet(UtilConstants.SAP_OM_FIELD_SET, UtilCOnstants.SAP_OM_STAGING);
            
            
            
            
            for (Opportunity_Additional_Role_Master__c oppAddRoleMasterRec: MasterQueries.queryAdditionalMaster()){
                 masterOppAdditionalRoleMap.put(oppAddRoleMasterRec.Name, oppAddRoleMasterRec);
            }
            
            for(Opportunity oppo:[select id,SAP_OM_Item_Id__c,SAP_OM_ID__c,(select id,Additional_Opportunity_Role__r.name from Opportunity_Additional_Team__r) from Opportunity where SAP_OM_Item_Id__c IN :stgRecList]){
                stageOpportunityMap.put(oppo.SAP_OM_ID__c,oppo.id);
                for(Opportunity_Additional_Team__c oppTeam:oppo.Opportunity_Additional_Team__r){
                    oppTeamWithSAP.put(oppo.SAP_OM_ID__c +utilConstants.SPLIT + oppTeam.Additional_Opportunity_Role__r.name,oppTeam);
                }
            }
            
            /*if(!addTeamListToDelete.isEmpty()){
                delete addTeamListToDelete;
            }*/
    
            for(SAP_OM_Staging__c stgRec:stgRecList){
                for (Schema.FieldSetMember fieldSetMemberObj: fieldSetMemberList) {
                    String fieldMember=(String) stgRec.get(fieldSetMemberObj.getFieldPath());
                    System.debug('Value is' +fieldMember);
                    if(stgRec.Hierarchy_Level__c!=null && !(stgRec.Hierarchy_Level__c).equalsIgnoreCase('Child')){
    
                        if (masterOppAdditionalRoleMap.containsKey(stagingCustomSettingMap.get(fieldSetMemberObj.getFieldPath()).Master_Record_Name__c) ) {
                       
    
                            oppAdditionaTeamRec = new Opportunity_Additional_Team__c();
                            String keyOpp= stgRec.opportunity_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get(fieldSetMemberObj.getFieldPath()).Master_Record_Name__c;
                            if(oppTeamWithSAP.containsKey(keyOpp)){
                                oppAdditionaTeamRec = oppTeamWithSAP.get(keyOpp);
                            }
                            
                            if (stgRec.BPONR__c != NULL && stgRec.BPONR__c > 0){
                              oppAdditionaTeamRec.Service_Group__c = UtilConstants.BPO;  
                            } 
    
                            if (stgRec.IO_Net_Revenue__c != NULL && stgRec.IO_Net_Revenue__c > 0){
                              oppAdditionaTeamRec.Service_Group__c = UtilConstants.IO;  
                            } 
    
                            if (stgRec.IC_Net_Revenue__c != NULL && stgRec.IC_Net_Revenue__c > 0){
                              oppAdditionaTeamRec.Service_Group__c = UtilConstants.IC;  
                            } 
    
                            oppAdditionaTeamRec.Additional_Opportunity_Team_Member__c = (String) stgRec.get(fieldSetMemberObj.getFieldPath());
                            oppAdditionaTeamRec.isChecked__c = true;
                            oppAdditionaTeamRec.Additional_Opportunity_Role__c = masterOppAdditionalRoleMap.get(stagingCustomSettingMap.get(fieldSetMemberObj.getFieldPath()).Master_Record_Name__c).Id;
                            if(oppAdditionaTeamRec.opportunity__c==null){
                                oppAdditionaTeamRec.opportunity__c=stageOpportunityMap.get(stgRec.opportunity_ID__c);
                            }
                            
                            System.debug('Alpha is' +oppAdditionaTeamRec.Additional_Opportunity_Team_Member__c);
                            addTeamList.add(oppAdditionaTeamRec);
                        
                        }
                    }
                    
                }
            }
            System.debug('Before insert list size is'+addTeamList.size());
            database.upsert(addTeamList,false);
            System.debug('Inserted well' );
            
        }   
        
        public static List < Schema.FieldSetMember > readFieldSet(String fieldSetName, String ObjectName) {
            IOCostModelUpload.stopTriggerExecution = false;
            //UtilConstants.stopTriggersForIO = FALSE;
            try{
                Map < String, Schema.SObjectType > GlobalDescribeMap = Schema.getGlobalDescribe();
                Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
                Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
                Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
                return fieldSetObj.getFields();
            }Catch(DMLException e) {
                String sheetThrowingException = UtilConstants.EMPTY_STRING;
                sheetThrowingException = e.getMessage() + e.getStackTraceString();
                throw (e);
                
            }
        }
        
        
        
        public static void getMasterData() {
             IOCostModelUpload.stopTriggerExecution = false;
            //UtilConstants.stopTriggersForIO = FALSE;
            for (Opportunity_Additional_Role_Master__c oppAddRoleMasterRec: [Select Name, active__c, ShouldBePopulatedFromSAP__c
            from Opportunity_Additional_Role_Master__c where ShouldBePopulatedFromSAP__c = True and active__c = true Limit 5000]) {
                masterOppAdditionalRoleMap.put(oppAddRoleMasterRec.Name, oppAddRoleMasterRec);
            }
            
            for(Operating_Groups_Master__c operatingGroupMaster:[select id,name from Operating_Groups_Master__c where active__C=true LIMIT 1000]){
                operatingGroupMap.put(operatingGroupMaster.name,operatingGroupMaster.id);
            }
            
            for(Geo_Region_Master__c geoRegionMaster:[select id,name from Geo_Region_Master__c where active__C=true LIMIT 1000]){
                geoRegionMap.put(geoRegionMaster.name,geoRegionMaster.id);
            }
            for (Offering_Master__c offeringMasterRec: [Select Name, Service_Group__c, active__c, offering_description__c from Offering_Master__c where active__c = true Limit 5000]) {
                masterOfferingMap.put(offeringMasterRec.Name + offeringMasterRec.Service_Group__c, offeringMasterRec);
            }
        }
        
        public static void saveNewAccounts(list < SAP_OM_Staging__c > saplist) {
            IOCostModelUpload.stopTriggerExecution = false;
           // UtilConstants.stopTriggersForIO = FALSE;
            set < string > accounts_tosave = new set < string > ();
            Set < String > accountsToFetch = new Set < String > ();
            account_map = new map < string, account > ();
            try{
                for (SAP_OM_Staging__c sap: saplist) {
                    accountsToFetch.add(sap.master_client_name__c);
                }
                
                for (account acc: [select id, name from account where name IN: accountsToFetch Limit 5000]) {
                    account_map.put(acc.name, acc);
                }
                
                for (SAP_OM_Staging__c sap: saplist) {
                    account acc;
                    acc = account_map.get(sap.master_client_name__c);
                    if (acc == null) {
                        accounts_tosave.add(sap.master_client_name__c);
                    }
                }
                list < account > final_acclisttocommit = new list < account > ();
                if (accounts_tosave.size() > 0) {
                    account acc;
                    for (string acc_name: accounts_tosave) {
                        acc = new account();
                        acc.Name = acc_name;
                        final_acclisttocommit.add(acc);
                        account_map.put(acc_name, acc);
                    }
                    database.saveResult[] save_result = database.insert(final_acclisttocommit, false);
                   
                }
            }Catch(DMLException e) {
                String sheetThrowingException = UtilConstants.EMPTY_STRING;
                sheetThrowingException = e.getMessage() + e.getStackTraceString();
                throw (e);
            }
            
        }
        
        
        public static void sendAlertToOperation(List<sap_om_staging__c> sapList)
        {
             
            Set<Id> oppId = new Set<Id>();
            List<Opportunity> oppList= [Select id,Name,Flag_For_Deletion__c,(Select id,Parent_ID__c,Name,Hierarchy_Level__c from Sap_Om_Items__r) from Opportunity where SAP_OM_Item_Id__c IN : sapList];
            List<sap_om_staging__c> sapToUpdate = new List<sap_om_staging__c>();
            List<Opportunity> oppToUpdate = new List<Opportunity>();
            
            try{
                for(Opportunity oppRec : oppList){
                    if(oppRec.Sap_Om_Items__r.size()>0){
                        for(sap_om_staging__c sapRec : oppRec.Sap_Om_Items__r){
                            if(sapRec.Hierarchy_Level__c.equals('Child') && sapRec.Parent_ID__c == null){
                                System.debug('----Inside if----'+sapRec.Hierarchy_Level__c+'---'+sapRec.Parent_ID__c);
                                sapRec.Hierarchy_Level__c = 'Standalone';
                                sapToUpdate.add(sapRec);
                                System.debug('---'+sapToUpdate.size());
                            }
                        }
                    }
                    oppId.add(oppRec.id);
                    System.debug('---oppId---'+oppId);
                    oppRec.Flag_For_Deletion__c = true;
                    oppToUpdate.add(oppRec);
                }
                System.debug('---oppId---'+oppId);
                if(oppToUpdate.size()>0 || !oppToUpdate.isEmpty()){
                    database.update(oppToUpdate);
                }
                if(sapToUpdate.size()>0 || !sapToUpdate.isEmpty()){
                    database.update(sapToUpdate);
                }
                sendMail(oppId);
            }
            catch(Exception e){
                String exceptionString = e.getMessage();
                throw e;
            }
            
            finally{
                
                oppList.clear();
                sapToUpdate.clear();
                oppToUpdate.clear();
            }
        }
        
          
       
        
        public static void sendMail(Set<Id> oppIds){
            String groupName = UtilConstantsforSWB.PUBLIC_GROUP ;
            List<String> mailList = new List<String>();
            List<String> mailAddresses = new List<String>(); 
            Messaging.SingleEmailMessage  mail =  new Messaging.SingleEmailMessage();
            List<ID> usersID = new List<ID>();
            Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name =: groupName];
            for (GroupMember gm : g.groupMembers)
            {
                mailList.add(gm.userOrGroupId);
            }
            User[] usr = [SELECT id,email FROM user WHERE id IN :mailList];
            for(User u : usr)
            {
                mailAddresses.add(u.email);
            } 
            Email_Template__c template=Email_Template__c.getValues(UtilConstantsforSWB.CHILD_OPPORTUNITY_CREATED);
            Id childOpportunity = '00XE0000001BpbP';
                                   
            for(Id alertonOpp :oppIds){
                
                mail.setTargetObjectId(userInfo.getUserId());
                mail.setToAddresses(mailAddresses);
                mail.setWhatId(alertonOpp);                             
                mail.setTemplateId(childOpportunity);
                mail.saveAsActivity=false;
                if(!Test.isrunningTest()){ 
                Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
               } 
            }
        }
        
         // method when Parent became standalone
        public static void updateStandaloneSap(List<sap_om_staging__c> sapList){
            Map<String,Opportunity> map1 = new Map<String,Opportunity>();
            List<Opportunity> oppList = new List<Opportunity>();
            List<sap_om_staging__c> stagingList = new List<sap_om_staging__c>();
            for(Opportunity opp : [select id,name,BPO_Net_Rev__c, sap_om_item_id__C, 
                                    sap_om_id__c,OS_Net_Revenue__c,Total_Current_Net_Rev__c,
                                    AO_Net_Revenue__c,MC_Net_Revenue__c,SI_Net_Revenue__c,
                                    SC_Net_Revenue__c,IO_Net_Rev_SAP_OM_Thousands__c,
                                    IC_Net_Revenue_SAP_OM_Thousands__c,TC_Net_Rev__c,Total_Net_Rev__c,(Select id,Parent_Opportunity__c,Name from Sap_om_items__r) 
                                    from opportunity where sap_om_item_id__C in : sapList])
            {
                map1.put(opp.sap_om_id__c, opp);
            } 
            for(sap_om_staging__c sapRec : sapList){
               if(sapRec.Hierarchy_level__c == 'Standalone' || sapRec.Hierarchy_level__c == null){
                   map1.get(sapRec.name).BPO_Net_Rev__c  = sapRec.BPONR__c;
                   map1.get(sapRec.name).BPO_Net_Rev_Thousands__c = map1.get(sapRec.name).BPO_Net_Rev__c;
                   map1.get(sapRec.name).IO_Net_Rev_SAP_OM_Thousands__c = sapRec.IO_Net_Revenue__c;
                   map1.get(sapRec.name).IO_Net_Revenue_Thousands__c  = map1.get(sapRec.name).IO_Net_Rev_SAP_OM_Thousands__c;
                   map1.get(sapRec.name).IC_Net_Revenue_SAP_OM_Thousands__c = sapRec.IC_Net_Revenue__c;
                   map1.get(sapRec.name).IC_Net_Rev_Thousands__c = map1.get(sapRec.name).IC_Net_Revenue_SAP_OM_Thousands__c;
                   map1.get(sapRec.name).AO_Net_Revenue__c = sapRec.AO_Net_Revenue__c;
                   map1.get(sapRec.name).SI_Net_Revenue__c = sapRec.SI_Net_Revenue__c;
                   map1.get(sapRec.name).SC_Net_Revenue__c = sapRec.SC_Net_Revenue__c;
                   map1.get(sapRec.name).MC_Net_Revenue__c = sapRec.MC_Net_Revenue__c;
                   map1.get(sapRec.name).Cons_Net_Revenue__c = sapRec.Cons_Net_Revenue__c;
                   map1.get(sapRec.name).OS_Net_Revenue__c = sapRec.OS_Net_Revenue__c;
                   map1.get(sapRec.name).Total_Current_Net_Rev__c = sapRec.TCNR__c  ;
                   map1.get(sapRec.name).TC_Net_Rev__c = sapRec.TC_Net_Rev__c;
                   map1.get(sapRec.name).Total_Net_Rev__c = sapRec.TNR__c;
                   oppList.add(map1.get(sapRec.name));
                }
                if(map1.get(sapRec.name).Sap_om_items__r.size()>0){
                    for(sap_om_staging__c sap : map1.get(sapRec.name).Sap_om_items__r){
                        sap.Parent_Opportunity__c = null;
                        stagingList.add(sap);    
                    }    
                } 
                   
            }
            if(oppList.size()>0){
                database.update(oppList);
            }
            if(stagingList.size()>0){
                database.update(stagingList);
            }
        } 
          /** This method is being used to update the Parent Opportunity fields with child field values
      **/
        
        public static void updateParentOpportunityFields(List<SAP_OM_Staging__c> stagingList,MAp<Id,Sap_om_staging__c> stagingMap){
            IOCostModelUpload.stopTriggerExecution = false;
            //UtilConstants.stopTriggersForIO = FALSE;
            Set<String> parentOppIds = new Set<String>();
            List<Opportunity> oppList = new List<Opportunity>();
            List<Opportunity> oppListToUpdate = new List<Opportunity>();        
            for(SAP_OM_Staging__c sapRec : stagingList){
                parentOppIds.add(sapRec.Parent_Id__c);        
            }
            oppList = [Select id,SAP_OM_Item_Id__r.active__c,Name,SAP_OM_Item_Id__r.name,BPO_Net_Rev__c,BPO_Net_Rev_Thousands__c,SAP_OM_Item_Id__r.BPONR__c,
                       IO_Net_Rev_SAP_OM_Thousands__c,IO_Net_Revenue_Thousands__c,SAP_OM_Item_Id__r.IO_Net_Revenue__c,
                       IC_Net_Revenue_SAP_OM_Thousands__c,IC_Net_Rev_Thousands__c,SAP_OM_Item_Id__r.IC_Net_Revenue__c,
                       AO_Net_Revenue__c,SAP_OM_Item_Id__r.AO_Net_Revenue__c,
                       SI_Net_Revenue__c,SAP_OM_Item_Id__r.SI_Net_Revenue__c,
                       SC_Net_Revenue__c,SAP_OM_Item_Id__r.SC_Net_Revenue__c,
                       MC_Net_Revenue__c,SAP_OM_Item_Id__r.MC_Net_Revenue__c,
                       Total_Current_Net_Rev__c,SAP_OM_Item_Id__r.TCNR__c,
                       Total_Net_Rev__c,SAP_OM_Item_Id__r.TNR__c,
                       Cons_Net_Revenue__c,SAP_OM_Item_Id__r.Cons_Net_Revenue__c,
                       OS_Net_Revenue__c,SAP_OM_Item_Id__r.OS_net_revenue__c,TC_Net_Rev__c,SAP_OM_Item_Id__r.TC_Net_Rev__c,
                       (Select id,active__c,Name,BPONR__c,IO_Net_Revenue__c,IC_Net_Revenue__c,OS_net_revenue__c,
                        AO_Net_Revenue__c,SI_Net_Revenue__c,SC_Net_Revenue__c,Cons_Net_Revenue__c,
                        MC_Net_Revenue__c,TCNR__c,TNR__c,Parent_id__c,Parent_Opportunity__c,TC_Net_Rev__c from SAP_OM_Items__r) 
                       from Opportunity where SAP_OM_Item_Id__r.name IN : parentOppIds];
            for(Opportunity oppRec: oppList){
                
                      Decimal BPO_NR=0,IONR=0,ICNR=0;
                    Decimal AONR=0,SINR=0,SCNR=0,MCNR=0,TONR=0;
                    Decimal TCNR = 0,CNR=0,OSNR=0,TNR=0,TC_NR=0;
                    for(SAP_OM_Staging__c sapOmRec : oppRec.SAP_OM_Items__r){
                        if(sapOmRec.active__c){
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
                                if(sapOmRec.OS_net_revenue__c!= null){
                                    OSNR += sapOmRec.OS_net_revenue__c;
                                    System.debug('---OSNR--'+OSNR);   
                                }
                                if(sapOmRec.Cons_Net_Revenue__c!= null){
                                    CNR += sapOmRec.Cons_Net_Revenue__c;
                                    System.debug('---CNR--'+CNR);   
                                }
                                if(sapOmRec.TC_Net_Rev__c!=null){
                                    TC_NR +=sapOmRec.TC_Net_Rev__c;
                                }
                            }
                        }
                        
                    }
                    System.debug('oppRec.BPO_Net_Rev__c' +oppRec.BPO_Net_Rev__c);
                    if(oppRec.SAP_OM_Item_Id__r.BPONR__c !=null){
                        BPO_NR += oppRec.SAP_OM_Item_Id__r.BPONR__c; } 
                    if(oppRec.SAP_OM_Item_Id__r.IO_Net_Revenue__c !=null){
                        IONR += oppRec.SAP_OM_Item_Id__r.IO_Net_Revenue__c; }
                    if(oppRec.SAP_OM_Item_Id__r.IC_Net_Revenue__c != null){
                        ICNR += oppRec.SAP_OM_Item_Id__r.IC_Net_Revenue__c; }
                    if(oppRec.SAP_OM_Item_Id__r.AO_Net_Revenue__c != null){
                        AONR += oppRec.SAP_OM_Item_Id__r.AO_Net_Revenue__c; }
                    if(oppRec.SAP_OM_Item_Id__r.SI_Net_Revenue__c != null) {
                        SINR += oppRec.SAP_OM_Item_Id__r.SI_Net_Revenue__c; }
                    if(oppRec.SAP_OM_Item_Id__r.SC_Net_Revenue__c != null){
                        SCNR += oppRec.SAP_OM_Item_Id__r.SC_Net_Revenue__c; }
                    if(oppRec.SAP_OM_Item_Id__r.MC_Net_Revenue__c != null){
                        MCNR += oppRec.SAP_OM_Item_Id__r.MC_Net_Revenue__c; }
                    if(oppRec.SAP_OM_Item_Id__r.TCNR__c != null){
                        TCNR += oppRec.SAP_OM_Item_Id__r.TCNR__c; }
                    if(oppRec.SAP_OM_Item_Id__r.TNR__c != null){
                        TNR  += oppRec.SAP_OM_Item_Id__r.TNR__c; }
                    if(oppRec.SAP_OM_Item_Id__r.OS_net_revenue__c != null){
                        OSNR += oppRec.SAP_OM_Item_Id__r.OS_net_revenue__c; }
                    if(oppRec.SAP_OM_Item_Id__r.Cons_Net_Revenue__c != null){
                        CNR += oppRec.SAP_OM_Item_Id__r.Cons_Net_Revenue__c; }
                    if(oppRec.SAP_OM_Item_Id__r.TC_Net_Rev__c!=null){
                        TC_NR +=oppRec.SAP_OM_Item_Id__r.TC_Net_Rev__c;
                    }
                    
                    System.debug('Final BPONR' +BPO_NR);
                    oppRec.BPO_Net_Rev__c = BPO_NR;
                    oppRec.IO_Net_Rev_SAP_OM_Thousands__c = IONR ;
                    oppRec.IC_Net_Revenue_SAP_OM_Thousands__c = ICNR ;
                    oppRec.AO_Net_Revenue__c = AONR ;
                    oppRec.SI_Net_Revenue__c = SINR ;
                    oppRec.SC_Net_Revenue__c = SCNR ;
                    oppRec.MC_Net_Revenue__c = MCNR ;
                    oppRec.Total_Current_Net_Rev__c = TCNR ;
                    oppRec.Total_Net_Rev__c = TNR  ;
                    oppRec.OS_Net_Revenue__c = OSNR ;
                    oppRec.Cons_Net_Revenue__c = CNR ;
                    oppRec.TC_Net_Rev__c = TC_NR;
                    
                    System.debug('after assignment'+oppRec.BPO_Net_Rev__c);
                    oppRec.BPO_Net_Rev_Thousands__c = oppRec.BPO_Net_Rev__c;
                    oppRec.IO_Net_Revenue_Thousands__c = oppRec.IO_Net_Rev_SAP_OM_Thousands__c ;
                    oppRec.IC_Net_Rev_Thousands__c = oppRec.IC_Net_Revenue_SAP_OM_Thousands__c ;
                    oppListToUpdate.add(oppRec);
            }
            if(oppListToUpdate.size()>0 || !oppListToUpdate.isEmpty()){
                database.update(oppListToUpdate);
            }
        }  
          
        /** this method is used when Child becomes Parent again
    */
        
        public static void revertValuesofExParent(List<sap_om_staging__c> sapList)
        {    
            IOCostModelUpload.stopTriggerExecution = false;
            // UtilConstants.stopTriggersForIO = FALSE;
            Set<String> parentId = new Set<String>();
            for(Sap_om_Staging__c stagingRec :sapList){
                system.debug('>>stagingRec.Parent_ID__c>>'+stagingRec.Parent_ID__c);
                if(stagingRec.active__c && stagingRec.Hierarchy_Level__c == UtilConstantsforSWB.CHILD  && stagingRec.Parent_id__c != null){
                    parentId.add(stagingRec.Parent_ID__c);   
                }   
            }
            List<Opportunity> opptoUpdate = new List<Opportunity>();
            for(Opportunity opp : [select Id,sap_om_id__c,BPO_Net_Rev__c,IC_Net_Revenue_SAP_OM_Thousands__c,
                                   IO_Net_Rev_SAP_OM_Thousands__c,AO_Net_Revenue__c ,SI_Net_Revenue__c,SC_Net_Revenue__c,
                                   MC_Net_Revenue__c,Total_Current_Net_Rev__c,TC_Net_Rev__c,Cons_Net_Revenue__c,  
                                   Total_Net_Rev__c,OS_Net_Revenue__c from opportunity where sap_om_id__c in : parentId]){
                                   Decimal BPO_NR=0,IONR=0,ICNR=0;
                Decimal AONR=0,SINR=0,SCNR=0,MCNR=0,TONR=0,TCNetRevenue=0;
                Decimal TCNR = 0,CNR=0,OSNR=0,TNR=0;
                                       for(sap_om_staging__c sap : sapList){
                                           if(sap.active__c){
                                               if(sap.Parent_ID__c == opp.sap_om_id__c){
                                                       if(sap.IC_Net_Revenue__c!=null ){
                                                           ICNR+= sap.IC_Net_Revenue__c;
                                                           //opp.IC_Net_Revenue_SAP_OM_Thousands__c = opp.IC_Net_Revenue_SAP_OM_Thousands__c - sap.IC_Net_Revenue__c;
                                                           //opp.IC_Net_Rev_Thousands__c = opp.IC_Net_Revenue_SAP_OM_Thousands__c;
                                                       }
                                                       if(sap.BPONR__c!=null){
                                                           BPO_NR += sap.BPONR__c;
                                                          // opp.BPO_Net_Rev__c = opp.BPO_Net_Rev__c - sap.BPONR__c; 
                                                           //opp.BPO_Net_Rev_Thousands__c = opp.BPO_Net_Rev__c;
                                                       }
                                                       if(sap.IO_Net_Revenue__c!=null ){
                                                           IONR += sap.IO_Net_Revenue__c;
                                                          // opp.IO_Net_Rev_SAP_OM_Thousands__c = opp.IO_Net_Rev_SAP_OM_Thousands__c - sap.IO_Net_Revenue__c;
                                                          // opp.IO_Net_Revenue_Thousands__c = opp.IO_Net_Rev_SAP_OM_Thousands__c;
                                                       }
                                                       if(sap.AO_Net_Revenue__c!=null){
                                                           AONR +=sap.AO_Net_Revenue__c;
                                                           //opp.AO_Net_Revenue__c = opp.AO_Net_Revenue__c - sap.AO_Net_Revenue__c; 
                                                       }
                                                       if(sap.SI_Net_Revenue__c!=null){
                                                           SINR += sap.SI_Net_Revenue__c;
                                                           //opp.SI_Net_Revenue__c = opp.SI_Net_Revenue__c - sap.SI_Net_Revenue__c; 
                                                       }
                                                       if(sap.SC_Net_Revenue__c!=null){
                                                           SCNR += sap.SC_Net_Revenue__c;
                                                           //opp.SC_Net_Revenue__c = opp.SC_Net_Revenue__c - sap.SC_Net_Revenue__c; 
                                                       }
                                                       if(sap.MC_Net_Revenue__c!=null){
                                                           MCNR += sap.MC_Net_Revenue__c;
                                                           //opp.MC_Net_Revenue__c = opp.MC_Net_Revenue__c - sap.MC_Net_Revenue__c; 
                                                       }
                                                       if(sap.TCNR__c!=null){
                                                           TCNR += sap.TCNR__c;
                                                           //opp.Total_Current_Net_Rev__c = opp.Total_Current_Net_Rev__c - sap.TCNR__c; 
                                                       }
                                                       if(sap.TNR__c!=null){
                                                           TNR += sap.TNR__c;
                                                           //opp.TC_Net_Rev__c = opp.TC_Net_Rev__c - sap.TNR__c; 
                                                       }
                                                       if(sap.TC_Net_Rev__c!=null){
                                                           TCNetRevenue +=sap.TC_Net_Rev__c;
                                                       }
                                                       
                                                       if(sap.Cons_Net_Revenue__c!=null){
                                                           CNR += sap.Cons_Net_Revenue__c;
                                                           //opp.Cons_Net_Revenue__c = opp.Cons_Net_Revenue__c - sap.Cons_Net_Revenue__c; 
                                                       }
                                                       if(sap.OS_Net_Revenue__c!=null){
                                                           OSNR += sap.OS_Net_Revenue__c;
                                                           //opp.OS_Net_Revenue__c = opp.OS_Net_Revenue__c - sap.OS_Net_Revenue__c; 
                                                       }
                                                  }

                                           }
                                       }
                                       opp.IC_Net_Revenue_SAP_OM_Thousands__c = opp.IC_Net_Revenue_SAP_OM_Thousands__c - ICNR;
                                       opp.IC_Net_Rev_Thousands__c = opp.IC_Net_Revenue_SAP_OM_Thousands__c;
                                       opp.BPO_Net_Rev__c = opp.BPO_Net_Rev__c - BPO_NR ; 
                                       opp.BPO_Net_Rev_Thousands__c = opp.BPO_Net_Rev__c;
                                       opp.IO_Net_Rev_SAP_OM_Thousands__c = opp.IO_Net_Rev_SAP_OM_Thousands__c - IONR;
                                       opp.IO_Net_Revenue_Thousands__c = opp.IO_Net_Rev_SAP_OM_Thousands__c;
                                       opp.AO_Net_Revenue__c = opp.AO_Net_Revenue__c - AONR;
                                       opp.SI_Net_Revenue__c = opp.SI_Net_Revenue__c - SINR ;
                                       opp.SC_Net_Revenue__c = opp.SC_Net_Revenue__c - SCNR ;
                                       opp.MC_Net_Revenue__c = opp.MC_Net_Revenue__c - MCNR;
                                       opp.Total_Current_Net_Rev__c = opp.Total_Current_Net_Rev__c - TCNR ;
                                       opp.TC_Net_Rev__c = opp.TC_Net_Rev__c - TCNetRevenue;
                                       opp.Total_Net_Rev__c = opp.Total_Net_Rev__c - TNR;
                                       opp.Cons_Net_Revenue__c = opp.Cons_Net_Revenue__c - CNR;
                                       opp.OS_Net_Revenue__c = opp.OS_Net_Revenue__c - OSNR;   
                                       opptoUpdate.add(opp);
                                       
                                   }
            if(opptoUpdate.size()>0){
                database.update(opptoUpdate);
            }
            
        }
      public static void insertOppDeliveryCentres(List<sap_om_staging__c> sapList){
            List<Opportunity> oppListToUpdate = new List<Opportunity>();
            Set<Id> parentSaps = new Set<Id>();
            Map<Opportunity,String> oppMap = new Map<Opportunity,String>();
            
            for(sap_om_staging__c sapRec : sapList){
                if((sapRec.delivery_centers__c != null && sapRec.delivery_centers__c != '') && (sapRec.Hierarchy_Level__c.equalsIgnorecase(UtilConstantsforSWB.PARENT))){
                    
                    parentSaps.add(sapRec.id); 
                    
                }
                if((sapRec.delivery_centers__c != null && sapRec.delivery_centers__c != '') && (sapRec.Hierarchy_Level__c.equalsIgnorecase(UtilConstantsforSWB.STANDALONE))){
                    parentSaps.add(sapRec.id);
                }               
            }
            List<Opportunity> oppList= [Select id,Name,SAP_OM_Item_Id__r.delivery_centers__c,SAP_OM_Item_Id__r.Hierarchy_Level__c,(Select id,delivery_centers__c From SAP_OM_Items__r) from Opportunity where SAP_OM_Item_Id__c IN : parentSaps];
            for(Opportunity oppRec : oppList){
                String deliveryCentres = oppRec.SAP_OM_Item_Id__r.delivery_centers__c+UtilConstantsforSWB.SEMICOLON;
                if(oppRec.SAP_OM_Item_Id__r.Hierarchy_Level__c.equalsIgnorecase(UtilConstantsforSWB.PARENT)){
                if(oppRec.SAP_OM_Items__r.size()>0){
                    for(SAP_OM_Staging__c sapRec : oppRec.SAP_OM_Items__r){
                            if(sapRec.delivery_centers__c != null && sapRec.delivery_centers__c!=''){
                            deliveryCentres += sapRec.delivery_centers__c+UtilConstantsforSWB.SEMICOLON;
                            }
                    }
                    
                }
                }
                deliveryCentres = deliveryCentres.removeEnd(UtilConstantsforSWB.SEMICOLON);
                oppMap.put(oppRec,deliveryCentres);
                //System.debug('----oppMap---'+oppMap);
                
            }
            for(Opportunity oppRec : oppMap.keyset()){
                oppRec.Delivery_Centers__c = oppMap.get(oppRec);
                oppListToUpdate.add(oppRec);
            }
            if(oppListToUpdate.size()>0){
                database.update(oppListToUpdate);
            }
        }
      
    }