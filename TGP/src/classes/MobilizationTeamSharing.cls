/*
  @Author: 
  @Name: MobilizationTeamSharing
  @Created Date: 01 January 2015
  @Description: This is a global MobilizationTeamSharing class for database interaction.
  @version: 1.0
*/
global class MobilizationTeamSharing implements Database.Batchable<sObject>,Database.Stateful{
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
/*
  @Author: 
  @Name: MobilizationTeamSharing
  @Created Date: 01 January 2015
  @Description: This is a global method MobilizationTeamSharing .
  @version: 1.0
*/
    global MobilizationTeamSharing(set<Id> dId,String dealQuery,Map<Id,set<Id>> dealMap,String flag,
                                    Map<Id,Id> sratWithMob,Map<Id,Id> mobDealMap,set<Id> sratId,
                                    Map<Id,id>opexWithMob,set<Id> opexId,set<Id> waveId,Map<Id,Id> waveMob){
        query=dealQuery;
        //System.debug('Query is' +query);
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
    }
    
/*
  @Author: 
  @Name: start
  @Created Date: 01 January 2015
  @Description: This is a Database.QuaryLocator type start method.
  @version: 1.0
*/
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
/*
  @Author: 
  @Name: execute
  @Created Date: 01 January 2015
  @Description:This is a Database.QuaryLocator type execute method.
  @version: 1.0
*/
    global void execute(Database.BatchableContext bc,List<sObject> sObjectList){
        
        set<String> superSetId=new set<String>();
        List<sObject> shareRecordList=new List<sObject>();
        set<Id> userIdForThisDeal=new set<Id>();
        //System.debug('size of deal is'+sObjectList.size());
        for(sObject deal:sObjectList){
            if(objectName.equals(UtilConstants.DEAL_SHARE )){
                userIdForThisDeal=dealWithMobTeam.get(deal.id);    
            }
            else if(objectName.equals(UtilConstants.SRAT_ADD_TRACK)){
                Id sratId=String.valueOf(deal.get(UtilConstants.SRAT_OBJ));
                Id mobPlan;      Id dealId;
                if(!String.isEmpty(sratId)){
                    mobPlan=trackerWithMob.get(sratId);    
                }
                if(!String.isEmpty(mobPlan)){
                    dealId=mobWithDeal.get(mobPlan);    
                }
                
                userIdForThisDeal=dealWithMobTeam.get(dealId);   
            }
            else if(objectName.equals(UtilConstants.OPEX_LEVEL1_SHARE)){
                Id opexId=String.valueOf(deal.get(UtilConstants.OPEX_TRACKER_DEL));
                Id mobPlan;       Id dealId;
                if(!String.isEmpty(opexId)){
                   mobPlan=opexWithMobPlan.get(opexId); 
                }
                if(!String.isEmpty(mobPlan)){
                   dealId=mobWithDeal.get(mobPlan); 
                }
                
                userIdForThisDeal=dealWithMobTeam.get(dealId);
            }
            else if(objectName.equals(UtilConstants.WAV_REGION )){
                Id waveId=String.valueOf(deal.get(UtilConstants.WAVE_API ));
                Id mobPlan; Id dealId;
                if(!String.isEmpty(waveId)){
                    mobPlan=waveWithMob.get(waveId);
                }
                if(!String.isEmpty(mobPlan)){
                    dealId=mobWithDeal.get(mobPlan);
                }
                userIdForThisDeal=dealWithMobTeam.get(dealId);
            }else{
               String objId=String.valueOf(deal.get(UtilConstants.Deal_OBJ));
               userIdForThisDeal=dealWithMobTeam.get(objId);
               //System.debug('size of set is'+userIdForThisDeal.size());
            }
            sObject Obj;
            if(userIdForThisDeal!=null && !userIdForThisDeal.isEmpty()){  //userIdForThisDeal!=null &&
                //System.debug('Enter here for SRAT');
                //System.debug('size of user id is' +userIdForThisDeal.size());
                for(String userIndex:userIdForThisDeal){
                    //System.debug('First Id is' +userIndex);
                    Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
                    String ownerId=String.valueOf(deal.get(UtilConstants.OWNER_ID));
                    if(userIndex!=null && userIndex!=UtilConstants.BLANK ){
                        if(!userIndex.equals(ownerId)){
                            Obj=targetType.newSObject();
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
        // For loop ends
        shareRecordList.sort();
        //System.debug('Size is'+shareRecordList.size());
        if(!shareRecordList.isEmpty()){
            Database.insert(shareRecordList,false);    
        }
        
    }
    

/*
  @Author: 
  @Name: finish
  @Created Date: 01 January 2015
  @Description: This is a global finish mehthod for database interaction.
  @version: 1.0
*/   
 global void finish(Database.BatchableContext bc){
        if(objectName.equals(UtilConstants.DEAL_SHARE )){
            String riskQuery=UtilConstants.RiskQuery;
            String riskFlag=UtilConstants.RISK_SHARE ;
            Id batchIdrisk=database.executeBatch(new MobilizationTeamSharing(dealId,riskQuery,dealWithMobTeam,riskFlag,
                                                    trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,
                                                    opexItemId,procWaveId,waveWithMob));
        }else if(objectName.equals(UtilConstants.RISK_SHARE )){
            String issueQuery=UtilConstants.IssueQuery;
            String issueFlag=UtilConstants.ISSUES_SHARE ;   
            Id batchIdIssue=database.executeBatch(new MobilizationTeamSharing(dealId,issueQuery,dealWithMobTeam,issueFlag,
                                                    trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,opexItemId,
                                                    procWaveId,waveWithMob));
        }else if(objectName.equals(UtilConstants.ISSUES_SHARE )){
            String actionQuery=UtilConstants.ActionQuery;
            String actionFlag=UtilConstants.ACTION_SHARE ;
            Id batchIdAction=database.executeBatch(new MobilizationTeamSharing(dealId,actionQuery,dealWithMobTeam,actionFlag,
                                                    trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,opexItemId,
                                                    procWaveId,waveWithMob));
        }else if(objectName.equals(UtilConstants.ACTION_SHARE )){
            String decisionQuery=UtilConstants.DecisionQuery;
            String decisionFlag=UtilConstants.DECISION_SHARE ;
            Id batchIdDecsiion=database.executeBatch(new MobilizationTeamSharing(dealId,decisionQuery,dealWithMobTeam,decisionFlag,
                                                        trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,opexItemId,procWaveId,
                                                        waveWithMob));
        }else if(objectName.equals(UtilConstants.DECISION_SHARE )){
            String mobTeamQuery=UtilConstants.MobTeamQuery;
            String mobTeamFlag=UtilConstants.MOB_TEAM_SHARE ;
            Id batchMob=database.executeBatch(new MobilizationTeamSharing(dealId,mobTeamQuery,dealWithMobTeam,mobTeamFlag,
                                                trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,opexItemId,procWaveId,
                                                waveWithMob));
        }else if(objectName.equals(UtilConstants.MOB_TEAM_SHARE )){
            String sratQuery=UtilConstants.SratQuery;
            String sratFlag=UtilConstants.SRAT_ADD_TRACK ;
            Id batchSRAT=database.executeBatch(new MobilizationTeamSharing(dealId,sratQuery,dealWithMobTeam,sratFlag,
                                                trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,opexItemId,
                                                procWaveId,waveWithMob));
        }else if(objectName.equals(UtilConstants.SRAT_ADD_TRACK )){
            String opexQuery=UtilConstants.OpexQuery;
            String opexFlag=UtilConstants.OPEX_ADD ;
            Id batchOpexId=database.executeBatch(new MobilizationTeamSharing(dealId,opexQuery,dealWithMobTeam,
                                                    opexFlag,trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,
                                                    opexItemId,procWaveId,waveWithMob)); 
        }else if(objectName.equals(UtilConstants.OPEX_ADD )){
            String procQuery=UtilConstants.ProcQuery;
            String procFlag=UtilConstants.PROCUREMENT_WAVE_REGION_SHARE ;
            Id procId=database.executeBatch(new MobilizationTeamSharing(dealId,procQuery,dealWithMobTeam,
                                            procFlag,trackerWithMob,mobWithDeal,sratItemId,opexWithMobPlan,
                                            opexItemId,procWaveId,waveWithMob));
        }
        else{}
        
    }
}