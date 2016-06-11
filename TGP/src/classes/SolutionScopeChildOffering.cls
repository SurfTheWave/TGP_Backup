public class SolutionScopeChildOffering {
    public static void updateParentOffering(List<sap_om_staging__C> childSapList){
        system.debug('Boolean value from child' +childSapList[0].active__c);
        Map < String, String > masterOfferingMap = new Map < String, String> ();
        set<String> parentId=new set<String>();
        Map<String,Solution_scope__C> solutionScopeMap=new Map<String,Solution_scope__C>();
        Map<String,Solution_scope__C> solutionScopeToUpdate=new Map<String,Solution_scope__c>();
        set<String> solScopeSet=new set<String>();
        Map < String, Staging_CustomSetting__c > stagingCustomSettingMap = Staging_CustomSetting__c.getall();
        
        for (Offering_Master__c offeringMasterRec: MasterQueries.allActiveOffMasters) {
            masterOfferingMap.put(offeringMasterRec.Name, offeringMasterRec.id);
        }
        
        for(sap_om_staging__C sapChild:childSapList){
            if(null!=sapChild.parent_id__C){
                parentId.add(sapChild.parent_id__C);
            }
            
        }
        for(solution_scope__C solScope:[select id,SAP_Offering_Revenue__c,Offering_Master__c,
                                        Opportunity__r.sap_om_item_id__r.opportunity_id__c
                                        from solution_scope__C where Opportunity__r.sap_om_item_id__r.opportunity_id__c 
                                        IN :parentId and Solution_Component__c =:utilConstants.SOLCOMP_DELIVERY]){
            solutionScopeMap.put(solScope.Offering_Master__c+solScope.Opportunity__r.sap_om_item_id__r.opportunity_id__c,solScope);
        }
        Solution_scope__C solutionToSubtract=new Solution_Scope__C();
        try{
			for(sap_om_staging__C childSap:childSapList){
				system.debug('Opp id is' +childSap.opportunity_id__c +'revenue is' +childSap.Data_Center_Transf_TNR__c);
				if(childSap.active__c){
					if(childSap.CPM_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('CPM_TNR__c').Master_Record_Name__c) + childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.CPM_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c + childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);  
						}
						
					}
					if(childSap.CS_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('CS_TNR__c').Master_Record_Name__c) + childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.CS_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c + childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.CC_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('CC_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.CC_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.FA_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('FA_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.FA_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.HA_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('HA_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.HA_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.HM_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('HM_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.HM_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.HR_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('HR_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.HR_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.INS_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('INS_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.INS_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.LNG_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('LNG_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.LNG_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.MKT_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('MKT_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.MKT_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.NS_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('NS_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.NS_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.PHARMA_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('PHARMA_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.PHARMA_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.PROC_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('PROC_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.PROC_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.SC_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('SC_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.SC_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.UTL_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('UTL_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.UTL_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.ECI_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('ECI_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.ECI_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.EIS_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('EIS_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.EIS_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.Acc_SW_SaaS_Subsc_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('Acc_SW_SaaS_Subsc_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.Acc_SW_SaaS_Subsc_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}   
					if(childSap.Compute_Services_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('Compute_Services_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.Compute_Services_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.IS_Capacity_Services_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('IS_Capacity_Services_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.IS_Capacity_Services_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
					}
					if(childSap.IS_Mgnt_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('IS_Mgnt_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.IS_Mgnt_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.Managed_Sec_Ser_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('Managed_Sec_Ser_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.Managed_Sec_Ser_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.Nw_Ser_IO_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('Nw_Ser_IO_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							 solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.Nw_Ser_IO_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
					   
					}
					if(childSap.Wp_Ser_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('Wp_Ser_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.Wp_Ser_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.IS_Transf_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('IS_Transf_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.IS_Transf_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.Data_Center_Transf_TNR__c>0){
						system.debug('For refe' +childSap.Data_Center_Transf_TNR__c + 'Id is' +childSap.opportunity_ID__c);
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('Data_Center_Transf_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.Data_Center_Transf_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.Operations_Transf_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('Operations_Transf_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.Operations_Transf_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
					   
					}
					if(childSap.Nw_Transf_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('Nw_Transf_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.Nw_Transf_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.Wp_Transf_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('Wp_Transf_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.Wp_Transf_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.Sec_Transf_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('Sec_Transf_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.Sec_Transf_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.MMR_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('MMR_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.MMR_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.MCS_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('MCS_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.MCS_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.ICS_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('ICS_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.ICS_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.SC_OPS_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('SC_OPS_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.SC_OPS_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
					if(childSap.SI_CS_TNR__c>0){
						solutionToSubtract=solutionScopeMap.get(masterOfferingMap.get(stagingCustomSettingMap.get('SI_CS_TNR__c').Master_Record_Name__c)+ childSap.Parent_ID__c);
						if(solutionToSubtract!=null){
							solutionToSubtract.SAP_Offering_Revenue__c = solutionToSubtract.SAP_Offering_Revenue__c - childSap.SI_CS_TNR__c;
							solScopeSet.add(solutionToSubtract.id);
							solutionScopeMap.put(solutionToSubtract.Offering_Master__c+ childSap.Parent_ID__c,solutionToSubtract);
							solutionScopeToUpdate.put(solutionToSubtract.id,solutionToSubtract);
						}
						
					}
				}
			}
				
			String query='select id from solution_scope__c where id IN :solScopeId';
			Id batch=database.executeBatch(new SolutionScopeBatch(query,solutionScopeToUpdate,solScopeSet),10);
		}catch(Exception e){
				
		}
   }
}