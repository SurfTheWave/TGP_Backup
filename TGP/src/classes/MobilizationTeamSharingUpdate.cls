/*
@Author and Created Date : System,  3/11/2015 6:28 AM
@name : MobilizationTeamSharingUpdate 
@Description : 
@Version : 
*/
global class MobilizationTeamSharingUpdate implements Database.Batchable<sObject>,Database.Stateful{
    global String query;
    global set<Id> dealId;
    global Map<Id,set<Id>> dealWithMobTeam=new Map<Id,set<Id>>();
    global String objectName;
    global Map<Id,Id> trackerWithMob=new Map<Id,Id>();
    global Map<Id,Id> mobWithDeal=new Map<Id,Id>();
    global set<Id> sratItemId=new set<Id>();
    global set<Id> opexItemId=new set<Id>();
    global Map<Id,Id> opexWithMobPlan=new Map<Id,Id>();
    global Map<Id,Id> procMap=new Map<id,Id>();
    global set<Id> procWaveId=new set<Id>();
    global Map<Id,ID> waveWithMob=new Map<Id,Id>();
    global Map<Id,set<Id>> mobLatest=new Map<Id,set<Id>>();
    /******************************
    Method Name: MobilizationTeamSharingUpdate
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    global MobilizationTeamSharingUpdate(set<Id> dId,String dealQuery,Map<Id,set<Id>> dealMap,String flag,Map<Id,Id> sratWithMob,Map<Id,Id> mobDealMap,set<Id> sratId,Map<Id,id>opexWithMob,set<Id> opexId,set<Id> waveId,Map<Id,Id> waveMob,Map<id,set<Id>> alpha){
        query=dealQuery;
       // System.debug('Query is' +query);
        dealId=dId;
        dealWithMobTeam=dealMap;
        objectName=flag;
        trackerWithMob=new Map<Id,Id>(sratWithMob);
        opexWithMobPlan=new Map<Id,Id>(opexWithMob);
        mobWithDeal=new Map<Id,Id>(mobDealMap);
        sratItemId=new set<Id>(sratId);
        opexItemId=new set<Id>(opexId);
        procWaveId=new set<Id>(waveId);
        waveWithMob=new Map<Id,Id>(waveMob);
        mobLatest=alpha;
    }
    /******************************
    Method Name: start
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/     
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    /******************************
    Method Name: execute
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    global void execute(Database.BatchableContext bc,List<sObject> sObjectList){
        
        set<String> superSetId=new set<String>();
        List<sObject> shareRecordList=new List<sObject>();
        set<Id> userIdForThisDeal=new set<Id>();
        //system.debug('size of deal is'+sObjectList.size());
        
        System.debug('objectName ->' + objectName);
        System.debug('mobLatest -> ' + mobLatest);
        for(sObject deal:sObjectList){
            
            if(objectName.equals(UtilConstants.DEAL_SHARE)){
                userIdForThisDeal=mobLatest.get(deal.id);    
            }else if(objectName.equals(UtilConstants.SRAT_LEVEL1_SHARE )){
                Id sratId=String.valueOf(deal.get(UtilConstants.SRAT_OBJ ));
                Id mobPlan;
                Id dealId;
                if(!String.isEmpty(sratId)){
                    mobPlan=trackerWithMob.get(sratId);    
                }
                if(!String.isEmpty(mobPlan)){
                    dealId=mobWithDeal.get(mobPlan);    
                }
                
                userIdForThisDeal=mobLatest.get(dealId);
                
            }else if(objectName.equals(UtilConstants.OPEX_LEVEL1_SHARE)){
                Id opexId=String.valueOf(deal.get(UtilConstants.OPEX_Tracker_del_OBJ ));
                Id mobPlan;
                Id dealId;
                if(!String.isEmpty(opexId)){
                   mobPlan=opexWithMobPlan.get(opexId); 
                }
                if(!String.isEmpty(mobPlan)){
                   dealId=mobWithDeal.get(mobPlan); 
                }
                
                userIdForThisDeal=mobLatest.get(dealId);
            }else if(objectName.equals(UtilConstants.WAV_REGION )){
                Id waveId=String.valueOf(deal.get(UtilConstants.WAV ));
                Id mobPlan;
                Id dealId;
                if(!String.isEmpty(waveId)){
                    mobPlan=waveWithMob.get(waveId);
                }
                if(!String.isEmpty(mobPlan)){
                    dealId=mobWithDeal.get(mobPlan);
                }
                userIdForThisDeal=mobLatest.get(dealId);
            }else if(objectName.equals(UtilConstants.MOB_TEAM_SHARE )){
                String objId=String.valueOf(deal.get(UtilConstants.Deal_OBJ ));
                   userIdForThisDeal=dealWithMobTeam.get(objId);
            }else{
               String objId=String.valueOf(deal.get(UtilConstants.Deal_OBJ));
               userIdForThisDeal=mobLatest.get(objId);
               //System.debug('size of set is'+userIdForThisDeal.size());
            }
            
            
           sObject Obj;
            if(userIdForThisDeal!=null){
               // System.debug('Enter here for SRAT');
                System.debug('size of user id is' +userIdForThisDeal);
                for(String userIndex: userIdForThisDeal){
                   // System.debug('First Id is' +userIndex);
                    Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
                    String ownerId=String.valueOf(deal.get(UtilConstants.OwnerId));
                    if(!String.isBlank(userIndex) && userIndex !=null){
                        if(!userIndex.equals(ownerId)){
                            Obj=targetType.newSObject();
                            //System.debug('parentid is' );
                            obj.put(UtilConstants.USER_GROUPID, userIndex);
                            obj.put(UtilConstants.PARENTID,deal.id);
                            obj.put(UtilConstants.ACCESS_LEVEL, UtilConstants.EDIT_STRING);
                            obj.put(UtilConstants.ROW_CAUSE, UtilConstants.MANUAL_STRING);
                            shareRecordList.add(obj);
                        }   
                    }
                }
            }
            
        }
        shareRecordList.sort();
        System.debug('Size is=>'+shareRecordList);
        if(!shareRecordList.isEmpty()){
           // Database.insert(shareRecordList);    
            Database.insert(shareRecordList, false);   
        }
        
        System.debug(shareRecordList + '>>>>');
        
    }
    /******************************
    Method Name: finish
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/    
    global void finish(Database.BatchableContext bc){
        /*
        if(objectName.equals(UtilConstants.DEAL_SHARE )){
            String riskQuery=UtilConstants.RiskQuery;
            String riskFlag= UtilConstants.RISK_SHARE ;
            Id batchIdrisk=database.executeBatch(new MobilizationTeamSharingUpdate(dealId,riskQuery,dealWithMobTeam,riskFlag,trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,opexItemId,procWaveId,waveWithMob,mobLatest));
        }else if(objectName.equals(UtilConstants.RISK_SHARE)){
            String issueQuery=UtilConstants.IssueQuery;
            String issueFlag= UtilConstants.ISSUES_SHARE ;   
            Id batchIdIssue=database.executeBatch(new MobilizationTeamSharingUpdate(dealId,issueQuery,dealWithMobTeam,issueFlag,trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,opexItemId,procWaveId,waveWithMob,mobLatest));
        }else if(objectName.equals( UtilConstants.ISSUES_SHARE)){
            String actionQuery=UtilConstants.ActionQuery;
            String actionFlag= UtilConstants.ACTION_SHARE ;
            Id batchIdAction=database.executeBatch(new MobilizationTeamSharingUpdate(dealId,actionQuery,dealWithMobTeam,actionFlag,trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,opexItemId,procWaveId,waveWithMob,mobLatest));
        }else if(objectName.equals(UtilConstants.ACTION_SHARE)){
            String decisionQuery=UtilConstants.DecisionQuery;
            String decisionFlag= UtilConstants.DECISION_SHARE ;
            Id batchIdDecsiion=database.executeBatch(new MobilizationTeamSharingUpdate(dealId,decisionQuery,dealWithMobTeam,decisionFlag,trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,opexItemId,procWaveId,waveWithMob,mobLatest));
        }else if(objectName.equals(UtilConstants.DECISION_SHARE)){
            String mobTeamQuery=UtilConstants.MobTeamQuery;
            String mobTeamFlag= UtilConstants.MOB_TEAM_SHARE ;
            Id batchMob=database.executeBatch(new MobilizationTeamSharingUpdate(dealId,mobTeamQuery,dealWithMobTeam,mobTeamFlag,trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,opexItemId,procWaveId,waveWithMob,mobLatest));
        }else if(objectName.equals(UtilConstants.MOB_TEAM_SHARE)){
            String sratQuery=UtilConstants.SratQuery;
            String sratFlag=UtilConstants.SRAT_LEVEL1_SHARE ;
            Id batchSRAT=database.executeBatch(new MobilizationTeamSharingUpdate(dealId,sratQuery,dealWithMobTeam,sratFlag,trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,opexItemId,procWaveId,waveWithMob,mobLatest));
        }else if(objectName.equals(UtilConstants.SRAT_LEVEL1_SHARE )){
            String opexQuery=UtilConstants.OpexQuery;
            String opexFlag= UtilConstants.OPEX_LEVEL1_SHARE ;
            Id batchOpexId=database.executeBatch(new MobilizationTeamSharingUpdate(dealId,opexQuery,dealWithMobTeam,opexFlag,trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,opexItemId,procWaveId,waveWithMob,mobLatest)); 
        }else if(objectName.equals(UtilConstants.OPEX_LEVEL1_SHARE )){
            String procQuery=UtilConstants.ProcQuery;
            String procFlag=UtilConstants.PROCUREMENT_WAVE_REGION_SHARE ;
            Id procId=database.executeBatch(new MobilizationTeamSharingUpdate(dealId,procQuery,dealWithMobTeam,procFlag,trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,opexItemId,procWaveId,waveWithMob,mobLatest));
        }
        
        
        else{}
        */
        
        if(objectName.equals(UtilConstants.DEAL_SHARE )){
            String mobTeamQuery=UtilConstants.MobTeamQuery;
            String mobTeamFlag= UtilConstants.MOB_TEAM_SHARE ;
            Id batchMob=database.executeBatch(new MobilizationTeamSharingUpdate(dealId,mobTeamQuery,dealWithMobTeam,mobTeamFlag,trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,opexItemId,procWaveId,waveWithMob,mobLatest));
        }else if(objectName.equals(UtilConstants.MOB_TEAM_SHARE)){
            String sratQuery=UtilConstants.SratQuery;
            String sratFlag=UtilConstants.SRAT_LEVEL1_SHARE ;
            Id batchSRAT=database.executeBatch(new MobilizationTeamSharingUpdate(dealId,sratQuery,dealWithMobTeam,sratFlag,trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,opexItemId,procWaveId,waveWithMob,mobLatest));
        }else if(objectName.equals(UtilConstants.SRAT_LEVEL1_SHARE )){
            String opexQuery=UtilConstants.OpexQuery;
            String opexFlag= UtilConstants.OPEX_LEVEL1_SHARE ;
            Id batchOpexId=database.executeBatch(new MobilizationTeamSharingUpdate(dealId,opexQuery,dealWithMobTeam,opexFlag,trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,opexItemId,procWaveId,waveWithMob,mobLatest)); 
        }else if(objectName.equals(UtilConstants.OPEX_LEVEL1_SHARE )){
            String procQuery=UtilConstants.ProcQuery;
            String procFlag=UtilConstants.PROCUREMENT_WAVE_REGION_SHARE ;
            Id procId=database.executeBatch(new MobilizationTeamSharingUpdate(dealId,procQuery,dealWithMobTeam,procFlag,trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,opexItemId,procWaveId,waveWithMob,mobLatest));
        }
        
        
        
    }
}