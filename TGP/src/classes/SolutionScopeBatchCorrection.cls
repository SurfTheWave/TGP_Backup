global class SolutionScopeBatchCorrection implements Database.Batchable<sObject>,Database.Stateful{
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query='select Hierarchy_Level__c,opportunity_ID__c,Parent_ID__c from sap_om_staging__C';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc,List<sap_om_staging__C> sapList){
    
        Map<String,Decimal> alphaMap=new Map<String,Decimal>();
        Map < String, Staging_CustomSetting__c > stagingCustomSettingMap = Staging_CustomSetting__c.getall();
        Map<String,Solution_Scope__c> solScopeMap=new Map<String,Solution_Scope__c>();
        set<String> sapIdSet=new set<String>();
        set<Id> opportunityId=new set<Id>();
        Map<String,String> serviceGroupMap=new Map<String,String>();
        MAP < String, String > masterOfferingMap = new MAP < String, String> ();
        Map<String,Id> opportunityMap=new Map<String,Id>();
        List<Solution_Scope__c> solutionScopeList=new List<Solution_Scope__c>();
        
        MasterQueries.findAllActiveOffMasters();
        
        for (Offering_Master__c offeringMasterRec: MasterQueries.allActiveOffMasters) {
            masterOfferingMap.put(offeringMasterRec.Name, offeringMasterRec.id);
        }
        
        for(SAP_OM_Staging__c sap:sapList){
                   if(sap.Hierarchy_Level__c=='Child'){
                       sapIdSet.add(sap.Parent_ID__c);
                   }else{
                       sapIdSet.add(sap.opportunity_ID__c);
                   }
                }
            
                for(Opportunity opp:[select id,SAP_OM_Item_Id__r.CPM_TNR__c,SAP_OM_Item_Id__r.CS_TNR__c,
                                     SAP_OM_Item_Id__r.CC_TNR__c,SAP_OM_Item_Id__r.FA_TNR__c,
                                     SAP_OM_Item_Id__r.HA_TNR__c,SAP_OM_Item_Id__r.HM_TNR__c,SAP_OM_Item_Id__r.HR_TNR__c,
                                     SAP_OM_Item_Id__r.INS_TNR__c,SAP_OM_Item_Id__r.LNG_TNR__c,SAP_OM_Item_Id__r.MKT_TNR__c,
                                     SAP_OM_Item_Id__r.NS_TNR__c,SAP_OM_Item_Id__r.PHARMA_TNR__c,SAP_OM_Item_Id__r.PROC_TNR__c,
                                     SAP_OM_Item_Id__r.SC_TNR__c,SAP_OM_Item_Id__r.UTL_TNR__c,SAP_OM_Item_Id__r.ECI_TNR__c,
                                     SAP_OM_Item_Id__r.EIS_TNR__c,SAP_OM_Item_Id__r.Acc_SW_SaaS_Subsc_TNR__c,
                                     SAP_OM_Item_Id__r.Compute_Services_TNR__c,SAP_OM_Item_Id__r.IS_Capacity_Services_TNR__c,
                                     SAP_OM_Item_Id__r.IS_Mgnt_TNR__c,SAP_OM_Item_Id__r.Managed_Sec_Ser_TNR__c,
                                     SAP_OM_Item_Id__r.Nw_Ser_IO_TNR__c,SAP_OM_Item_Id__r.Wp_Ser_TNR__c,
                                     SAP_OM_Item_Id__r.IS_Transf_TNR__c,SAP_OM_Item_Id__r.Data_Center_Transf_TNR__c,
                                     SAP_OM_Item_Id__r.Operations_Transf_TNR__c,SAP_OM_Item_Id__r.Nw_Transf_TNR__c,
                                     SAP_OM_Item_Id__r.Wp_Transf_TNR__c,SAP_OM_Item_Id__r.Sec_Transf_TNR__c,
                                     SAP_OM_ID__c,SAP_OM_Item_Id__r.MMR_TNR__c,SAP_OM_Item_Id__r.MCS_TNR__c,
                                     SAP_OM_Item_Id__r.ICS_TNR__c,SAP_OM_Item_Id__r.SC_OPS_TNR__c,SAP_OM_Item_Id__r.SI_CS_TNR__c,
                                     (select CPM_TNR__c,CS_TNR__c,CC_TNR__c,FA_TNR__c,HA_TNR__c,HM_TNR__c,HR_TNR__c,
                                                   INS_TNR__c,LNG_TNR__c,MKT_TNR__c,NS_TNR__c,PHARMA_TNR__c,PROC_TNR__c,SC_TNR__c,
                                                   UTL_TNR__c,ECI_TNR__c,EIS_TNR__c,Acc_SW_SaaS_Subsc_TNR__c,Compute_Services_TNR__c,
                                                   IS_Capacity_Services_TNR__c,IS_Mgnt_TNR__c,Managed_Sec_Ser_TNR__c,
                                                   Nw_Ser_IO_TNR__c,Wp_Ser_TNR__c,IS_Transf_TNR__c,Data_Center_Transf_TNR__c,
                                                   Operations_Transf_TNR__c,Nw_Transf_TNR__c,Wp_Transf_TNR__c,
                                                   Sec_Transf_TNR__c,MMR_TNR__c,MCS_TNR__c,ICS_TNR__c,SC_OPS_TNR__c,SI_CS_TNR__c
                                                   from SAP_OM_Items__r) 
                                     from Opportunity where SAP_OM_ID__c IN :sapIdSet]){
                    Decimal capitalProjMgmt=0,creditService=0,customerContact=0,FinanceAndAccounting=0,HealthAndAdmin=0,healthMgmt=0,humanresource=0;
                    Decimal insurance=0,learning=0,marketing=0,network=0,pharmaceuticals=0,procurement=0,SupplyChain=0,utilities=0,emerging=0,emergingIndustyr=0,AccentureSW=0;
                    Decimal computeService=0,infrastructre=0,infraMgmt=0,managedSecurity=0,networkService=0,workPlace=0,infraTransformation=0,datacenter=0,operations=0,networkTrans=0;
                    Decimal workPlaceTransformation=0,SecurityTransformation=0;
                    Decimal ICSecurity=0,managedCloudService=0,SCOperation=0,SICustom=0,mediaAndMarketing=0,serviceMgmtIO=0,serviceMgmtIC=0;
                    
                    opportunityId.add(opp.id);
                    
                    if(opp.SAP_OM_Item_Id__r.CPM_TNR__c>0){
                        capitalProjMgmt= opp.SAP_OM_Item_Id__r.CPM_TNR__c;    
                    }
                    if(opp.SAP_OM_Item_Id__r.CS_TNR__c>0){
                        creditService=opp.SAP_OM_Item_Id__r.CS_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.CC_TNR__c > 0){
                        customerContact=opp.SAP_OM_Item_Id__r.CC_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.FA_TNR__c >0){
                        FinanceAndAccounting=opp.SAP_OM_Item_Id__r.FA_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.HA_TNR__c > 0){
                        HealthAndAdmin=opp.SAP_OM_Item_Id__r.HA_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.HM_TNR__c >0){
                        healthMgmt=opp.SAP_OM_Item_Id__r.HM_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.HR_TNR__c >0){
                        humanresource=opp.SAP_OM_Item_Id__r.HR_TNR__c ;
                    }
                    if(opp.SAP_OM_Item_Id__r.INS_TNR__c >0){
                        insurance = opp.SAP_OM_Item_Id__r.INS_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.LNG_TNR__c>0){
                        learning = opp.SAP_OM_Item_Id__r.LNG_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.MKT_TNR__c>0){
                        marketing = opp.SAP_OM_Item_Id__r.MKT_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.NS_TNR__c>0){
                        network = opp.SAP_OM_Item_Id__r.NS_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.PHARMA_TNR__c>0){
                        pharmaceuticals = opp.SAP_OM_Item_Id__r.PHARMA_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.PROC_TNR__c>0){
                        procurement = opp.SAP_OM_Item_Id__r.PROC_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.SC_TNR__c>0){
                        SupplyChain = opp.SAP_OM_Item_Id__r.SC_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.UTL_TNR__c>0){
                        utilities = opp.SAP_OM_Item_Id__r.UTL_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.ECI_TNR__c>0){
                        emerging = opp.SAP_OM_Item_Id__r.ECI_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.EIS_TNR__c>0){
                        emergingIndustyr = opp.SAP_OM_Item_Id__r.EIS_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.Acc_SW_SaaS_Subsc_TNR__c>0){
                        AccentureSW = opp.SAP_OM_Item_Id__r.Acc_SW_SaaS_Subsc_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.Compute_Services_TNR__c>0){
                        computeService = opp.SAP_OM_Item_Id__r.Compute_Services_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.IS_Capacity_Services_TNR__c>0){
                        infrastructre = opp.SAP_OM_Item_Id__r.IS_Capacity_Services_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.IS_Mgnt_TNR__c>0){
                        infraMgmt = opp.SAP_OM_Item_Id__r.IS_Mgnt_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.Managed_Sec_Ser_TNR__c>0){
                        managedSecurity = opp.SAP_OM_Item_Id__r.Managed_Sec_Ser_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.Nw_Ser_IO_TNR__c>0){
                        networkService = opp.SAP_OM_Item_Id__r.Nw_Ser_IO_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.Wp_Ser_TNR__c>0){
                        workPlace = opp.SAP_OM_Item_Id__r.Wp_Ser_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.IS_Transf_TNR__c>0){
                        infraTransformation = opp.SAP_OM_Item_Id__r.IS_Transf_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.Data_Center_Transf_TNR__c>0){
                        datacenter = opp.SAP_OM_Item_Id__r.Data_Center_Transf_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.Operations_Transf_TNR__c>0){
                        operations = opp.SAP_OM_Item_Id__r.Operations_Transf_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.Nw_Transf_TNR__c>0){
                        networkTrans = opp.SAP_OM_Item_Id__r.Nw_Transf_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.Wp_Transf_TNR__c>0){
                        workPlaceTransformation = opp.SAP_OM_Item_Id__r.Wp_Transf_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.Sec_Transf_TNR__c>0){
                        SecurityTransformation = opp.SAP_OM_Item_Id__r.Sec_Transf_TNR__c;
                    }
                     // Added as part of CR-738 and 745                    
                    if(opp.SAP_OM_Item_Id__r.MMR_TNR__c>0){
                        mediaAndMarketing=opp.SAP_OM_Item_Id__r.MMR_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.MCS_TNR__c>0){
                        managedCloudService=opp.SAP_OM_Item_Id__r.MCS_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.ICS_TNR__c>0){
                        ICSecurity=opp.SAP_OM_Item_Id__r.ICS_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.SC_OPS_TNR__c>0){
                        SCOperation=opp.SAP_OM_Item_Id__r.SC_OPS_TNR__c;
                    }
                    if(opp.SAP_OM_Item_Id__r.SI_CS_TNR__c>0){
                        SICustom=opp.SAP_OM_Item_Id__r.SI_CS_TNR__c;
                    }
                    
                     // Ends here 735 and 748                    
                    for(SAP_OM_Staging__c childSAP:opp.sap_om_items__r){
                        if(childSAP.CPM_TNR__c > 0 && capitalProjMgmt >0){
                            capitalProjMgmt += childSAP.CPM_TNR__c;
                        }else if(childSAP.CPM_TNR__c > 0){
                            capitalProjMgmt = childSAP.CPM_TNR__c;
                        }
                        
                        if(childSAP.CS_TNR__c >0 && creditService>0){
                            creditService +=childSAP.CS_TNR__c;
                        }else if(childSAP.CS_TNR__c > 0){
                            creditService = childSAP.CS_TNR__c;
                        }
                        
                        if(childSAP.CC_TNR__c >0 && customerContact>0){
                            customerContact +=childSAP.CC_TNR__c;
                        }else if(childSAP.CS_TNR__c > 0){
                            customerContact = childSAP.CC_TNR__c;
                        }
                        
                        if(childSAP.FA_TNR__c > 0 && FinanceAndAccounting>0){
                            FinanceAndAccounting +=childSAP.FA_TNR__c;
                        }else if(childSAP.FA_TNR__c > 0){
                            FinanceAndAccounting = childSAP.FA_TNR__c;
                        }
                        
                        if(childSAP.HA_TNR__c > 0 && HealthAndAdmin >0){
                            HealthAndAdmin +=childSAP.HA_TNR__c;
                        }else if(childSAP.HA_TNR__c > 0){
                            HealthAndAdmin =childSAP.HA_TNR__c;
                        }
                        
                        if(childSAP.HM_TNR__c > 0 && healthMgmt > 0){
                            healthMgmt +=childSAP.HM_TNR__c;
                        }else if(childSAP.HM_TNR__c>0){
                            healthMgmt = childSAP.HM_TNR__c;
                        }
                        
                        if(childSAP.HR_TNR__c > 0  && humanresource >0){
                            humanresource +=childSAP.HR_TNR__c;
                        }else if(childSAP.HR_TNR__c > 0){
                            humanresource =childSAP.HR_TNR__c;
                        }
                        
                        if(childSAP.INS_TNR__c > 0  && insurance >0){
                            insurance +=childSAP.INS_TNR__c;
                        }else if(childSAP.INS_TNR__c > 0){
                            insurance =childSAP.INS_TNR__c;
                        }
                        
                        if(childSAP.LNG_TNR__c > 0  && learning >0){
                            learning +=childSAP.LNG_TNR__c;
                        }else if(childSAP.LNG_TNR__c > 0){
                            learning =childSAP.LNG_TNR__c;
                        }
                        
                        if(childSAP.MKT_TNR__c > 0  && marketing >0){
                            marketing +=childSAP.MKT_TNR__c;
                        }else if(childSAP.MKT_TNR__c > 0){
                            marketing =childSAP.MKT_TNR__c;
                        }
                        
                        if(childSAP.NS_TNR__c > 0  && network >0){
                            network +=childSAP.NS_TNR__c;
                        }else if(childSAP.NS_TNR__c > 0){
                            network =childSAP.NS_TNR__c;
                        }
                        
                        if(childSAP.PHARMA_TNR__c > 0  && pharmaceuticals >0){
                            pharmaceuticals +=childSAP.PHARMA_TNR__c;
                        }else if(childSAP.PHARMA_TNR__c > 0){
                            pharmaceuticals =childSAP.PHARMA_TNR__c;
                        }
                        
                        if(childSAP.PROC_TNR__c > 0  && procurement >0){
                            procurement +=childSAP.PROC_TNR__c;
                        }else if(childSAP.PROC_TNR__c > 0){
                            procurement =childSAP.PROC_TNR__c;
                        }
                        
                        if(childSAP.SC_TNR__c > 0  && SupplyChain >0){
                            SupplyChain +=childSAP.SC_TNR__c;
                        }else if(childSAP.SC_TNR__c > 0){
                            SupplyChain =childSAP.SC_TNR__c;
                        }
                        
                        if(childSAP.UTL_TNR__c > 0  && utilities >0){
                            utilities +=childSAP.UTL_TNR__c;
                        }else if(childSAP.UTL_TNR__c > 0){
                            utilities =childSAP.UTL_TNR__c;
                        }
                        
                        if(childSAP.ECI_TNR__c > 0  && emerging >0){
                            emerging +=childSAP.ECI_TNR__c;
                        }else if(childSAP.ECI_TNR__c > 0){
                            emerging =childSAP.ECI_TNR__c;
                        }
                        
                        if(childSAP.EIS_TNR__c > 0  && emergingIndustyr >0){
                            emergingIndustyr +=childSAP.EIS_TNR__c;
                        }else if(childSAP.EIS_TNR__c > 0){
                            emergingIndustyr =childSAP.EIS_TNR__c;
                        }
                        
                         if(childSAP.Acc_SW_SaaS_Subsc_TNR__c > 0  && AccentureSW >0){
                            AccentureSW +=childSAP.Acc_SW_SaaS_Subsc_TNR__c;
                        }else if(childSAP.Acc_SW_SaaS_Subsc_TNR__c > 0){
                            AccentureSW =childSAP.Acc_SW_SaaS_Subsc_TNR__c;
                        }
                        
                        if(childSAP.Compute_Services_TNR__c > 0  && computeService >0){
                            computeService +=childSAP.Compute_Services_TNR__c;
                        }else if(childSAP.Compute_Services_TNR__c > 0){
                            computeService =childSAP.Compute_Services_TNR__c;
                        }
                        
                        if(childSAP.IS_Capacity_Services_TNR__c > 0  && infrastructre >0){
                            infrastructre +=childSAP.IS_Capacity_Services_TNR__c;
                        }else if(childSAP.IS_Capacity_Services_TNR__c > 0){
                            infrastructre =childSAP.IS_Capacity_Services_TNR__c;
                        }
                        
                        if(childSAP.IS_Mgnt_TNR__c > 0  && infraMgmt >0){
                            infraMgmt +=childSAP.IS_Mgnt_TNR__c;
                        }else if(childSAP.IS_Mgnt_TNR__c > 0){
                            infraMgmt =childSAP.IS_Mgnt_TNR__c;
                        }
                        
                         if(childSAP.Managed_Sec_Ser_TNR__c > 0  && managedSecurity >0){
                            managedSecurity +=childSAP.Managed_Sec_Ser_TNR__c;
                        }else if(childSAP.Managed_Sec_Ser_TNR__c > 0){
                            managedSecurity =childSAP.Managed_Sec_Ser_TNR__c;
                        }
                        
                        if(childSAP.Nw_Ser_IO_TNR__c > 0  && networkService >0){
                            networkService +=childSAP.Nw_Ser_IO_TNR__c;
                        }else if(childSAP.Nw_Ser_IO_TNR__c > 0){
                            networkService =childSAP.Nw_Ser_IO_TNR__c;
                        }
                        
                        if(childSAP.Wp_Ser_TNR__c > 0  && workPlace >0){
                            workPlace +=childSAP.Wp_Ser_TNR__c;
                        }else if(childSAP.Wp_Ser_TNR__c > 0){
                            workPlace =childSAP.Wp_Ser_TNR__c;
                        }
                        
                        if(childSAP.IS_Transf_TNR__c > 0  && infraTransformation >0){
                            infraTransformation +=childSAP.IS_Transf_TNR__c;
                        }else if(childSAP.IS_Transf_TNR__c > 0){
                            infraTransformation =childSAP.IS_Transf_TNR__c;
                        }
                        
                        if(childSAP.Data_Center_Transf_TNR__c > 0  && datacenter >0){
                            datacenter +=childSAP.Data_Center_Transf_TNR__c;
                        }else if(childSAP.Data_Center_Transf_TNR__c > 0){
                            datacenter =childSAP.Data_Center_Transf_TNR__c;
                        }
                        
                        if(childSAP.Operations_Transf_TNR__c > 0  && operations >0){
                            operations +=childSAP.Operations_Transf_TNR__c;
                        }else if(childSAP.Operations_Transf_TNR__c > 0){
                            operations =childSAP.Operations_Transf_TNR__c;
                        }
                        
                        if(childSAP.Nw_Transf_TNR__c > 0  && networkTrans >0){
                            networkTrans +=childSAP.Nw_Transf_TNR__c;
                        }else if(childSAP.Nw_Transf_TNR__c > 0){
                            networkTrans =childSAP.Nw_Transf_TNR__c;
                        }
                        
                        if(childSAP.Wp_Transf_TNR__c > 0  && workPlaceTransformation >0){
                            workPlaceTransformation +=childSAP.Wp_Transf_TNR__c;
                        }else if(childSAP.Wp_Transf_TNR__c > 0){
                            workPlaceTransformation =childSAP.Wp_Transf_TNR__c;
                        }
                        
                        if(childSAP.Sec_Transf_TNR__c > 0  && SecurityTransformation >0){
                            SecurityTransformation +=childSAP.Sec_Transf_TNR__c;
                        }else if(childSAP.Sec_Transf_TNR__c > 0){
                            SecurityTransformation =childSAP.Sec_Transf_TNR__c;
                        }
                        
                        if(childSAP.MMR_TNR__c>0 && mediaAndMarketing>0){
                            mediaAndMarketing +=childSAP.MMR_TNR__c;
                        }else if(childSAP.MMR_TNR__c>0){
                            mediaAndMarketing =childSAP.MMR_TNR__c;
                        }
                        
                        if(childSAP.MCS_TNR__c>0 && managedCloudService>0){
                            managedCloudService +=childSAP.MCS_TNR__c;
                        }else if(childSAP.MCS_TNR__c>0){
                            managedCloudService =childSAP.MCS_TNR__c;
                        }
                        
                        if(childSAP.ICS_TNR__c>0 && ICSecurity>0){
                            ICSecurity +=childSAP.ICS_TNR__c;
                        }else if(childSAP.ICS_TNR__c>0){
                            ICSecurity =childSAP.ICS_TNR__c;
                        }
                        
                        if(childSAP.SC_OPS_TNR__c>0 && SCOperation>0){
                            SCOperation +=childSAP.SC_OPS_TNR__c;
                        }else if(childSAP.SC_OPS_TNR__c>0){
                            SCOperation =childSAP.SC_OPS_TNR__c;
                        }
                        
                        if(childSAP.SI_CS_TNR__c>0 && SICustom>0){
                            SICustom +=childSAP.SI_CS_TNR__c;
                        }else if(childSAP.SI_CS_TNR__c>0){
                            SICustom =childSAP.SI_CS_TNR__c;
                        }
                        
                   }
                    
                    if(capitalProjMgmt > 0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('CPM_TNR__c').Master_Record_Name__c,capitalProjMgmt);
                        serviceGroupMap.put(stagingCustomSettingMap.get('CPM_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('CPM_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('CPM_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(creditService > 0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('CS_TNR__c').Master_Record_Name__c,creditService);
                        serviceGroupMap.put(stagingCustomSettingMap.get('CS_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('CS_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('CS_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(customerContact > 0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('CC_TNR__c').Master_Record_Name__c,customerContact);
                        serviceGroupMap.put(stagingCustomSettingMap.get('CC_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('CC_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('CC_TNR__c').Master_Record_Name__c,opp.id);
                    
                    }
                    if(FinanceAndAccounting > 0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('FA_TNR__c').Master_Record_Name__c,FinanceAndAccounting);
                        serviceGroupMap.put(stagingCustomSettingMap.get('FA_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('FA_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('FA_TNR__c').Master_Record_Name__c,opp.id);
                    
                    }
                    if(HealthAndAdmin >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('HA_TNR__c').Master_Record_Name__c,HealthAndAdmin);
                        serviceGroupMap.put(stagingCustomSettingMap.get('HA_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('HA_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('HA_TNR__c').Master_Record_Name__c,opp.id);
                    
                    }
                    if(healthMgmt > 0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('HM_TNR__c').Master_Record_Name__c,healthMgmt);
                        serviceGroupMap.put(stagingCustomSettingMap.get('HM_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('HM_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('HM_TNR__c').Master_Record_Name__c,opp.id);
                    
                    }
                    if(humanresource >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('HR_TNR__c').Master_Record_Name__c,humanresource);
                        serviceGroupMap.put(stagingCustomSettingMap.get('HR_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('HR_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('HR_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(insurance>0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('INS_TNR__c').Master_Record_Name__c,insurance);
                        serviceGroupMap.put(stagingCustomSettingMap.get('INS_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('INS_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('INS_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(learning >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('LNG_TNR__c').Master_Record_Name__c,learning);
                        serviceGroupMap.put(stagingCustomSettingMap.get('LNG_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('LNG_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('LNG_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(marketing >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('MKT_TNR__c').Master_Record_Name__c,marketing);
                        serviceGroupMap.put(stagingCustomSettingMap.get('MKT_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('MKT_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('MKT_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(network >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('NS_TNR__c').Master_Record_Name__c,network);
                        serviceGroupMap.put(stagingCustomSettingMap.get('NS_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('NS_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('NS_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(pharmaceuticals  >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('PHARMA_TNR__c').Master_Record_Name__c,pharmaceuticals);
                        serviceGroupMap.put(stagingCustomSettingMap.get('PHARMA_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('PHARMA_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('PHARMA_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(procurement >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('PROC_TNR__c').Master_Record_Name__c,procurement);
                        serviceGroupMap.put(stagingCustomSettingMap.get('PROC_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('PROC_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('PROC_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(SupplyChain >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('SC_TNR__c').Master_Record_Name__c,SupplyChain);
                        serviceGroupMap.put(stagingCustomSettingMap.get('SC_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('SC_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('SC_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(utilities >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('UTL_TNR__c').Master_Record_Name__c,utilities);
                        serviceGroupMap.put(stagingCustomSettingMap.get('UTL_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('UTL_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('UTL_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(emerging  >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('ECI_TNR__c').Master_Record_Name__c,emerging);
                        serviceGroupMap.put(stagingCustomSettingMap.get('ECI_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('ECI_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('ECI_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(emergingIndustyr >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('EIS_TNR__c').Master_Record_Name__c,emergingIndustyr);
                        serviceGroupMap.put(stagingCustomSettingMap.get('EIS_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('EIS_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('EIS_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(AccentureSW >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Acc_SW_SaaS_Subsc_TNR__c').Master_Record_Name__c,AccentureSW);
                        serviceGroupMap.put(stagingCustomSettingMap.get('Acc_SW_SaaS_Subsc_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('Acc_SW_SaaS_Subsc_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Acc_SW_SaaS_Subsc_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(computeService >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Compute_Services_TNR__c').Master_Record_Name__c,computeService);
                        serviceGroupMap.put(stagingCustomSettingMap.get('Compute_Services_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('Compute_Services_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Compute_Services_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(infrastructre >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('IS_Capacity_Services_TNR__c').Master_Record_Name__c,infrastructre);
                        serviceGroupMap.put(stagingCustomSettingMap.get('IS_Capacity_Services_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('IS_Capacity_Services_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('IS_Capacity_Services_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(infraMgmt >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('IS_Mgnt_TNR__c').Master_Record_Name__c,infraMgmt);
                        serviceGroupMap.put(stagingCustomSettingMap.get('IS_Mgnt_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('IS_Mgnt_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('IS_Mgnt_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(managedSecurity >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Managed_Sec_Ser_TNR__c').Master_Record_Name__c,managedSecurity);
                        serviceGroupMap.put(stagingCustomSettingMap.get('Managed_Sec_Ser_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('Managed_Sec_Ser_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Managed_Sec_Ser_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                     if(networkService >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Nw_Ser_IO_TNR__c').Master_Record_Name__c,networkService);
                        serviceGroupMap.put(stagingCustomSettingMap.get('Nw_Ser_IO_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('Nw_Ser_IO_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Nw_Ser_IO_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(workPlace >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Wp_Ser_TNR__c').Master_Record_Name__c,workPlace);
                        serviceGroupMap.put(stagingCustomSettingMap.get('Wp_Ser_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('Wp_Ser_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Wp_Ser_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(infraTransformation >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('IS_Transf_TNR__c').Master_Record_Name__c,infraTransformation);
                        serviceGroupMap.put(stagingCustomSettingMap.get('IS_Transf_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('IS_Transf_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('IS_Transf_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(datacenter >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Data_Center_Transf_TNR__c').Master_Record_Name__c,datacenter);
                        serviceGroupMap.put(stagingCustomSettingMap.get('Data_Center_Transf_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('Data_Center_Transf_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Data_Center_Transf_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(operations >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Operations_Transf_TNR__c').Master_Record_Name__c,operations);
                        serviceGroupMap.put(stagingCustomSettingMap.get('Operations_Transf_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('Operations_Transf_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Operations_Transf_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(networkTrans >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Nw_Transf_TNR__c').Master_Record_Name__c,networkTrans);
                        serviceGroupMap.put(stagingCustomSettingMap.get('Nw_Transf_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('Nw_Transf_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Nw_Transf_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                     if(workPlaceTransformation >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Wp_Transf_TNR__c').Master_Record_Name__c,workPlaceTransformation);
                        serviceGroupMap.put(stagingCustomSettingMap.get('Wp_Transf_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('Wp_Transf_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Wp_Transf_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(SecurityTransformation >0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Sec_Transf_TNR__c').Master_Record_Name__c,SecurityTransformation);
                        serviceGroupMap.put(stagingCustomSettingMap.get('Sec_Transf_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('Sec_Transf_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('Sec_Transf_TNR__c').Master_Record_Name__c,opp.id);
                    }
                    
                    if(mediaAndMarketing > 0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('MMR_TNR__c').Master_Record_Name__c,mediaAndMarketing);
                        serviceGroupMap.put(stagingCustomSettingMap.get('MMR_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('MMR_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('MMR_TNR__c').Master_Record_Name__c,opp.id);
                    }
                                         
                    if(managedCloudService > 0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('MCS_TNR__c').Master_Record_Name__c,managedCloudService);
                        serviceGroupMap.put(stagingCustomSettingMap.get('MCS_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('MCS_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('MCS_TNR__c').Master_Record_Name__c,opp.id);
                    }
                                         
                    if(ICSecurity > 0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('SI_CS_TNR__c').Master_Record_Name__c,ICSecurity);
                        serviceGroupMap.put(stagingCustomSettingMap.get('SI_CS_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('SI_CS_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('SI_CS_TNR__c').Master_Record_Name__c,opp.id);
                    }
                                         
                    if(SCOperation > 0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('SC_OPS_TNR__c').Master_Record_Name__c,SCOperation);
                        serviceGroupMap.put(stagingCustomSettingMap.get('SC_OPS_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('SC_OPS_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('SC_OPS_TNR__c').Master_Record_Name__c,opp.id);
                    }
                                         
                    if(SICustom > 0){
                        alphaMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('CPM_TNR__c').Master_Record_Name__c,SICustom);
                        serviceGroupMap.put(stagingCustomSettingMap.get('CPM_TNR__c').Master_Record_Name__c,stagingCustomSettingMap.get('CPM_TNR__c').Service_Group__c);
                        opportunityMap.put(opp.SAP_OM_ID__c + utilConstants.SPLIT + stagingCustomSettingMap.get('CPM_TNR__c').Master_Record_Name__c,opp.id);
                    }
                                         
                }
                
                for(Solution_Scope__c solScope:[select id,Offering_Master__r.name,Opportunity__c,Opportunity__r.SAP_OM_ID__c,Service_Group__c,SAP_Offering_Revenue__c from Solution_Scope__c where Opportunity__c IN :opportunityId and Solution_Component__c =:utilConstants.SOLCOMP_DELIVERY]){
                    solScopeMap.put(solScope.Opportunity__r.SAP_OM_ID__c + utilConstants.SPLIT + solScope.Offering_Master__r.name,solScope);
                }
                
                for(String betaKey:solScopeMap.keySet()){
                    Solution_Scope__c zeroSolScope=new Solution_Scope__c();
                    if(alphaMap.containsKey(betaKey)){
                        
                    }else{
                        zeroSolScope=solScopeMap.get(betaKey);
                        zeroSolScope.SAP_Offering_Revenue__c=0;
                        solutionScopeList.add(zeroSolScope);
                    }
                }
                for(String alphaKey:alphaMap.keySet()){
                    Solution_Scope__c solutionScope=new Solution_Scope__c();
                    String masterName=alphaKey.split(utilConstants.SPLIT)[1];
                    String serviceGroup=serviceGroupMap.get(alphaKey.split(utilConstants.SPLIT)[1]);
                    if(solScopeMap.containsKey(alphaKey)){
                        solutionScope=solScopeMap.get(alphaKey);
                        solutionScope.SAP_Offering_Revenue__c=alphaMap.get(alphaKey);
                        solutionScopeList.add(solutionScope);
                    }else{
                        solutionScope=new Solution_Scope__c();
                        solutionScope.SAP_Offering_Revenue__c=alphaMap.get(alphaKey);
                        system.debug('Offering master name ' +masterOfferingMap.get(masterName)+ 'master name '+masterName);
                        solutionScope.Offering_Master__c=masterOfferingMap.get(masterName);
                        solutionScope.Service_Group__c =serviceGroup;
                        solutionScope.Opportunity__c=opportunityMap.get(alphaKey);
                        solutionScope.Solution_Component__c = utilConstants.SOLCOMP_DELIVERY;
                        solutionScopeList.add(solutionScope);
                    }
                    system.debug('SAP offering revenue is' +solutionScope.SAP_Offering_Revenue__c);
                }
                database.upsert(solutionScopeList,false);
            
    }
    
     global void finish(Database.BatchableContext bc){
        
    }

}