/**    TriggerName: operationsOnStagingTrigger
*
*    Purpose:
*
*/

trigger operationsOnStagingTrigger on SAP_OM_Staging__c (before update,after insert, after update) {
    
    List<sap_om_staging__c> oppListToUpdate  = new List<sap_om_staging__c>(); 
    List<sap_om_staging__c>parenttobeChild = new List<sap_om_staging__c>();
    List<sap_om_staging__c>childBecameParent = new List<sap_om_staging__c>();
    List<SAP_OM_Staging__c> stagingList=new List<SAP_OM_Staging__c>();
    List<SAP_OM_Staging__c> stagingChildtoParentList=new List<SAP_OM_Staging__c>();
    List<SAP_OM_Staging__c> stagingChildList=new List<SAP_OM_Staging__c>();
    List<SAP_OM_Staging__c> parentBecameStandAlone =new List<SAP_OM_Staging__c>();
    List<SAP_OM_Staging__C> childOfferingList=new List<sap_om_staging__C>();
    
    List<FlagCheck__c> flagCheckList= FlagCheck__c.getAll().values();
    Boolean sapOmFlag= flagCheckList[0].MMS_Object_Key__c;
    
   if(sapOmFlag){
        if(trigger.isBefore){
        if(trigger.isUpdate){
            for(sap_om_staging__c sapRec : trigger.new){
                sap_om_staging__c oldSap=trigger.oldMap.get(sapRec.id);
                if(sapRec.Hierarchy_Level__c!=null && oldSap.Hierarchy_Level__c!=null){
                    if(sapRec.Hierarchy_Level__c.equalsIgnorecase('Child') && sapRec.Parent_ID__c==null && (oldSap.Hierarchy_Level__c.equals('Standalone') || oldSap.Hierarchy_Level__c.equals('Parent'))){
                        sapRec.Hierarchy_Level__c='Standalone';
                       //get the above condition verified from BA
                    }
                }
                
                
            }
        }
        
    }
        if(trigger.isAfter){
            if(trigger.isUpdate){
                if(RecursiveTriggerHelper.runOnce()){
                    for(sap_om_staging__c sapRec : trigger.new){
                        sap_om_staging__c oldSap=trigger.oldMap.get(sapRec.id);
                        
                        
                        
                        if(!(sapRec.Hierarchy_Level__c).equalsIgnoreCase('Child')){
                            stagingList.add(sapRec);
                        }
                        if((((oldSap.Hierarchy_Level__c).equalsIgnoreCase('Child')) && ((sapRec.Hierarchy_Level__c).equalsIgnoreCase('Parent'))) 
                           || (((oldSap.Hierarchy_Level__c).equalsIgnoreCase('Child')) && ((sapRec.Hierarchy_Level__c).equalsIgnoreCase('Standalone')))){
                            stagingChildtoParentList.add(sapRec);
                        }
                        if(sapRec.Hierarchy_Level__c.equalsIgnoreCase('Child')&& oldSap.Hierarchy_Level__c.equalsIgnoreCase('Child')
                           || 
                           sapRec.Hierarchy_Level__c.equalsIgnoreCase('Child')&& oldSap.Hierarchy_Level__c.equalsIgnoreCase('Parent')
                           ||
                           sapRec.Hierarchy_Level__c.equalsIgnoreCase('Child')&& oldSap.Hierarchy_Level__c.equalsIgnoreCase('Standalone')
                          ){
                              stagingChildList.add(sapRec);
                          }
                        
                    }
                    if(stagingList!=null && !stagingList.isEmpty()){
                        operationsOnStagingTriggerController.createOpportunity(stagingList,trigger.oldMap,true,true);    
                    }
                    if(stagingChildtoParentList!=null && !stagingChildtoParentList.isEmpty()){
                        operationsOnStagingTriggerController.createOpportunity(stagingChildtoParentList,trigger.oldMap,false,true);    
                    }
                    if(stagingChildList!=null && !stagingChildList.isEmpty()){
                        operationsOnStagingTriggerController.createOpportunity(stagingChildList,trigger.oldMap,true,true);    
                    }
                    for (integer i = 0; i < trigger.new.size(); i++) {
                        if(
                            ((trigger.old[i].Hierarchy_Level__c =='Parent' && trigger.old[i].Parent_id__c == null) || 
                             (trigger.old[i].Hierarchy_Level__c =='Standalone' && trigger.old[i].Parent_id__c == null)) && 
                            (trigger.new[i].Hierarchy_Level__c == 'Child' && trigger.new[i].Parent_ID__c!=null)
                        ){
                            parenttobeChild.add(trigger.new[i]);
                        }
                        if(
                            (trigger.old[i].Hierarchy_Level__c =='Child' && trigger.old[i].Parent_id__c != null) && 
                            (
                                (trigger.new[i].Hierarchy_Level__c =='Parent' && trigger.new[i].Parent_id__c==null) || (trigger.new[i].Parent_id__c==null && trigger.new[i].Hierarchy_Level__c =='Standalone') ||
                                (trigger.old[i].Parent_id__c != trigger.new[i].Parent_id__c)
                            )
                        ){
                            childBecameParent.add(trigger.old[i]);
                        }
                        if(trigger.old[i].Hierarchy_Level__c =='Parent' && trigger.new[i].Hierarchy_Level__c =='Standalone'){
                            parentBecameStandAlone.add(trigger.new[i]);        
                        }
                        if(trigger.new[i].Hierarchy_Level__c.equals('Child') && trigger.new[i].Parent_id__c != null){
                            oppListToUpdate.add(trigger.new[i]);
                            
                        }
                        if(null!=trigger.new[i].Hierarchy_Level__c && 
                           ((trigger.old[i].Hierarchy_Level__c.equals('Child') && trigger.new[i].Hierarchy_Level__c.equals('Parent')) 
                            || (trigger.old[i].Hierarchy_Level__c.equals('Child') && trigger.new[i].Hierarchy_Level__c.equals('Standalone'))
                           || (trigger.old[i].Hierarchy_Level__c.equals('Child') && trigger.old[i].Parent_id__c != trigger.new[i].Parent_id__c))){
                                childOfferingList.add(trigger.old[i]);
                            }
                        
                    }
                    
                    if(parenttobeChild.size()>0){
                        operationsOnStagingTriggerController.sendAlertToOperation(parenttobeChild);
                    }
                    if(childBecameParent.size()>0){
                        operationsOnStagingTriggerController.revertValuesofExParent(childBecameParent);
                    }
                    if(parentBecameStandAlone.size()>0){
                        operationsOnStagingTriggerController.updateStandaloneSap(parentBecameStandAlone);
                    }
                    if(oppListToUpdate.size()>0){
                        operationsOnStagingTriggerController.updateParentOpportunityFields(oppListToUpdate,trigger.oldMap); 
                    }
                    AlphaOffering.createOffering(trigger.new,true);
                    
                    if(!childOfferingList.isEmpty()){
                        SolutionScopeChildOffering.updateParentOffering(childOfferingList);
                    }
                    operationsOnStagingTriggerController.createOpportunityAdditionalTeam(trigger.new,true);
                    
                }
               
                List<sap_om_staging__c> sapToSend = new List<sap_om_staging__c>();
                for(sap_om_staging__c sapRec : trigger.new){
                    if((sapRec.delivery_centers__c != null && sapRec.delivery_centers__c != '' && sapRec.delivery_centers__c != 'N/A') && (sapRec.Hierarchy_Level__c.equalsIgnorecase(UtilConstantsforSWB.PARENT)||sapRec.Hierarchy_Level__c.equalsIgnorecase('Standalone'))){
                    
                   sapToSend.add(sapRec);
                    
                }
                }
                if(sapToSend.size()>0){
                	operationsOnStagingTriggerController.insertOppDeliveryCentres(sapToSend);
                }
                
            }
            if(trigger.isInsert){
                List<sap_om_staging__c> sapListtoUpdate = new List<sap_om_staging__c>(); 
                List<sap_om_staging__c> sapChildList = new List<sap_om_staging__c>(); 
                if(oppListToUpdate.size()>0){
                    operationsOnStagingTriggerController.updateParentOpportunityFields(oppListToUpdate,trigger.oldMap); 
                }
                operationsOnStagingTriggerController.createOpportunity(trigger.new,trigger.oldMap,false,false);
                for (integer i = 0; i < trigger.new.size(); i++){
                    if(trigger.new[i].Hierarchy_Level__c == 'Parent'|| trigger.new[i].Hierarchy_Level__c == 'Standalone' || (null == trigger.new[i].Hierarchy_Level__c) || (trigger.new[i].Hierarchy_Level__c == 'Child' && trigger.new[i].Parent_ID__c == null)){
                        sapListtoUpdate.add(trigger.new[i]);
                    }
                    if(trigger.new[i].Hierarchy_Level__c == 'Child' && trigger.new[i].Parent_Opportunity__c != null){
                        sapChildList.add(trigger.new[i]);
                    }
                }
                List<sap_om_staging__c> sapToSend = new List<sap_om_staging__c>();
                for(sap_om_staging__c sapRec : trigger.new){
                    if((sapRec.delivery_centers__c != null && sapRec.delivery_centers__c != '' && sapRec.delivery_centers__c != 'N/A') && (sapRec.Hierarchy_Level__c.equalsIgnorecase(UtilConstantsforSWB.PARENT)||sapRec.Hierarchy_Level__c.equalsIgnorecase('Standalone'))){
                    	sapToSend.add(sapRec);
                    }
                }
                if(sapToSend.size()>0){
                	operationsOnStagingTriggerController.insertOppDeliveryCentres(sapToSend);
                }
                operationsOnStagingTriggerController.createOpportunityAdditionalTeam(trigger.new,false);
                //AlphaOffering.createOffering(trigger.new,false);
            }
            
        }
   
   }
}