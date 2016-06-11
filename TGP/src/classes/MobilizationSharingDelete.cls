/*@Descrption: This class is used to create share 
 * 			   record for Mobilization Team users
 */
global class MobilizationSharingDelete implements Database.Batchable<sObject>, Database.Stateful{
    global String delquery;
    global Map<Id,set<Id>> dealWithMobTeam=new Map<Id,set<Id>>();
    global Map<Id,Id> sratWithDeal=new Map<Id,Id>();
    //global Map<Id,set<Id>> opexDeal=new Map<Id,set<Id>>();
    global set<Id> dealId=new set<Id>();
    global set<Id> sratLevel=new set<Id>();
    global String objectName;
    global set<Id> userId=new set<Id>();
    global set<Id> riskId=new set<Id>();
    global set<Id> issueId=new set<Id>();
    global set<Id> actionId=new set<Id>();
    global set<Id> decisionId=new set<Id>();
    global Map<Id,Id> riskMap=new Map<Id,Id>();
    global Map<Id,Id> issueMap=new Map<Id,Id>();
    global Map<Id,Id> actionMap=new Map<Id,Id>();
    global Map<Id,Id> decisionMap=new Map<Id,Id>();
    global set<Id> opexId=new set<Id>();
    global Map<Id,Id> opexMap=new Map<Id,Id>();
    global set<Id> procId=new set<Id>();
    global Map<Id,Id> procMap=new Map<Id,Id>();
    global set<Id> mTeamId=new set<Id>();
    global Map<Id,Id> mteamMap=new Map<Id,Id>();
    /*
     * @Description: This method is used to Pass parameters to constructor class
     */
    global MobilizationSharingDelete(set<Id> userGroupId,String query,String objName,Map<Id,set<Id>> dealWithteam,
                                     set<Id> ddID,set<Id> sId,Map<Id,id> sratDeal,set<Id> rId,Map<Id,Id> rMap,
                                     set<Id> iId,Map<Id,Id> iMap,set<Id> aId,Map<Id,Id> aMap,set<Id> dId,
                                     Map<id,id>dMap,set<Id> oId,Map<Id,Id> oMap,set<Id> pId,Map<Id,Id> pMap,
                                     set<Id> mtId,Map<Id,Id> mtMap){
        dealId=ddID;
        procId=pId;
        procMap=pMap;
        mTeamId=mtId;
        mTeamMap=mtMap;            
        delQuery=query;
        dealWithMobTeam=dealWithteam;
        sratWithDeal=sratDeal;
        sratLevel=sId;
        objectName=objName;
        opexId=oId;
        opexMap=oMap;
        userId=userGroupId;
        riskId=rid;
        riskMap=rMap;
        issueId=iId;
        issueMap=iMap;
        actionId=aId;
        actionMap=aMap;
        decisionId=dId;
        decisionMap=dMap;
    }
    /*
     * @Description: This method is used to Query records for execute method
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(delquery);
    }
    /*
     *@Description: This method is used to create share records 
     */
    global void execute(Database.BatchableContext bc,List<sObject> sObjectList){
        set<Id> userIdForThisDeal=new set<Id>();
        List<sObject> shareRecordsToDelete=new List<sObject>();
        for(sObject obj:sObjectList){
            Id pId=String.valueOf(obj.get(UtillContstant_Novasuite.PARENT_ID));
            Id userId=String.valueOf(obj.get(UtillContstant_Novasuite.USER_GROUP_ID));
            Id dealId;
            String cause=String.valueof(obj.get(UtillContstant_Novasuite.ROW_CAUSE));
            if((UtillContstant_Novasuite.DEAL_SHARE).equals(objectName)){
                dealId=pId;
                userIdforThisDeal=dealWithMobTeam.get(pId);
            }else if((UtillContstant_Novasuite.RISK_SHARE).equals(objectName)){
                dealId=riskMap.get(pId);
            }else if((UtillContstant_Novasuite.ISSUE_SHARE).equals(objectName)){
                dealId=issueMap.get(pId);
            }else if((UtillContstant_Novasuite.ACTION_SHARE).equals(objectName)){
                dealId=actionMap.get(pId);
            }else if((UtillContstant_Novasuite.DECISION_SHARE).equals(objectName)){
                dealId=decisionMap.get(pId);
            }else if((UtilConstants.OPEX_LEVEL1_SHARE).equals(objectName)){
                dealId=opexMap.get(pId);
            }else if((UtilConstants.SRAT_ADD_TRACK).equals(objectName)){
                dealId=sratWithDeal.get(pid);
            }else if((UtillContstant_Novasuite.MOB_TEAM).equals(objectName)){
                dealId=mTeamMap.get(pId);
            }else if((UtillContstant_Novasuite.PROC_WAVE).equals(objectName)){
                dealId=procMap.get(pId);
            }
            userIdforThisDeal=dealWithMobTeam.get(dealId);         
            if(userIdforThisDeal!=null && !userIdforThisDeal.isEmpty()){
                for(String mobTeamId:userIdforThisDeal){
                    if(!(UtillContstant_Novasuite.OWNER).equals(cause) && userId.equals(mobTeamId)){
                        shareRecordsToDelete.add(obj);
                    }
                }
            }
        }
        Database.delete(shareRecordsToDelete);
    }
    /*
     * @Description:: The finish method is used to create a new instance of Sharing
     */
    global void finish(Database.BatchableContext bc){
        if((UtillContstant_Novasuite.DEAL_SHARE).equals(objectName)){
            String riskQuery='select id,userorgroupid,parentid,rowcause from Risks__Share where parentid IN:riskId AND userorgroupId in:userId';
            String riskFlag=UtillContstant_Novasuite.RISK_SHARE;
            Id batchIdrisk=database.executeBatch(new MobilizationSharingDelete(userId,riskQuery,riskFlag,
                                                                               dealWithMobTeam,dealId,sratLevel,
                                                                               sratWithDeal,riskId,riskMap,issueId,
                                                                               issueMap,actionId,actionMap,decisionId,
                                                                               decisionMap,opexId,opexMap,procId,
                                                                               procMap,mTeamId,mTeamMap));
        }else if((UtillContstant_Novasuite.RISK_SHARE).equals(objectName)){
            String riskQuery='select id,userorgroupid,parentid,rowcause from Issues__share where parentid IN:issueId AND userorgroupId in:userId';
            String riskFlag=UtillContstant_Novasuite.ISSUE_SHARE;
            Id batchIdrisk=database.executeBatch(new MobilizationSharingDelete(userId,riskQuery,riskFlag,
                                                                               dealWithMobTeam,dealId,sratLevel,
                                                                               sratWithDeal,riskId,riskMap,issueId,
                                                                               issueMap,actionId,actionMap,decisionId,
                                                                               decisionMap,opexId,opexMap,procId,
                                                                               procMap,mTeamId,mTeamMap));
        }else if((UtillContstant_Novasuite.ISSUE_SHARE).equals(objectName)){
            String riskQuery='select id,userorgroupid,parentid,rowcause from Action__share where parentid IN:actionId AND userorgroupId in:userId';
            String riskFlag=UtillContstant_Novasuite.ACTION_SHARE;
            Id batchIdrisk=database.executeBatch(new MobilizationSharingDelete(userId,riskQuery,riskFlag,
                                                                               dealWithMobTeam,dealId,sratLevel,
                                                                               sratWithDeal,riskId,riskMap,issueId,
                                                                               issueMap,actionId,actionMap,decisionId,
                                                                               decisionMap,opexId,opexMap,procId,
                                                                               procMap,mTeamId,mTeamMap));
        }else if((UtillContstant_Novasuite.ACTION_SHARE).equals(objectName)){
            String riskQuery='select id,userorgroupid,parentid,rowcause from Decision__share where parentid IN:decisionId AND userorgroupId in:userId';
            String riskFlag=UtillContstant_Novasuite.DECISION_SHARE;
            Id batchIdrisk=database.executeBatch(new MobilizationSharingDelete(userId,riskQuery,riskFlag,
                                                                               dealWithMobTeam,dealId,sratLevel,
                                                                               sratWithDeal,riskId,riskMap,issueId,
                                                                               issueMap,actionId,actionMap,decisionId,
                                                                               decisionMap,opexId,opexMap,procId,
                                                                               procMap,mTeamId,mTeamMap));
        }else if((UtillContstant_Novasuite.DECISION_SHARE).equals(objectName)){
            String riskQuery='select id,userorgroupid,parentid,rowcause from Deal_OPEX_Additional_Tracking_Level_1__share where parentid IN:opexId AND userorgroupId in:userId';
            String riskFlag=UtilConstants.OPEX_ADD;
            Id batchIdrisk=database.executeBatch(new MobilizationSharingDelete(userId,riskQuery,riskFlag,
                                                                               dealWithMobTeam,dealId,sratLevel,
                                                                               sratWithDeal,riskId,riskMap,issueId,
                                                                               issueMap,actionId,actionMap,decisionId,
                                                                               decisionMap,opexId,opexMap,procId,
                                                                               procMap,mTeamId,mTeamMap));
        }else if((UtilConstants.OPEX_ADD).equals(objectName)){
            String riskQuery='select id,userorgroupid,parentid,rowcause from SRAT_Additional_Tracking_Level_1__share where parentid IN:sratLevel AND userorgroupId in:userId';
            String riskFlag=UtilConstants.SRAT_ADD_TRACK;
            Id batchIdrisk=database.executeBatch(new MobilizationSharingDelete(userId,riskQuery,riskFlag,
                                                                               dealWithMobTeam,dealId,sratLevel,
                                                                               sratWithDeal,riskId,riskMap,issueId,
                                                                               issueMap,actionId,actionMap,decisionId,
                                                                               decisionMap,opexId,opexMap,procId,
                                                                               procMap,mTeamId,mTeamMap));
        }else if((UtilConstants.SRAT_ADD_TRACK).equals(objectName)){
            String riskQuery='select id,userorgroupid,parentid,rowcause from Mobilization_team__share where parentid IN:mTeamId AND userorgroupId in:userId';
            String riskFlag=UtillContstant_Novasuite.MOB_TEAM;
            Id batchIdrisk=database.executeBatch(new MobilizationSharingDelete(userId,riskQuery,riskFlag,
                                                                               dealWithMobTeam,dealId,sratLevel,
                                                                               sratWithDeal,riskId,riskMap,issueId,
                                                                               issueMap,actionId,actionMap,decisionId,
                                                                               decisionMap,opexId,opexMap,procId,
                                                                               procMap,mTeamId,mTeamMap));
        }else if((UtillContstant_Novasuite.MOB_TEAM).equals(objectName)){
            String riskQuery='select id,userorgroupid,parentid,rowcause from Procurement_Wave_Region__share where parentid IN:procId AND userorgroupId in:userId';
            String riskFlag=UtillContstant_Novasuite.PROC_WAVE;
            Id batchIdrisk=database.executeBatch(new MobilizationSharingDelete(userId,riskQuery,riskFlag,
                                                                               dealWithMobTeam,dealId,sratLevel,
                                                                               sratWithDeal,riskId,riskMap,issueId,
                                                                               issueMap,actionId,actionMap,decisionId,
                                                                               decisionMap,opexId,opexMap,procId,procMap,
                                                                               mTeamId,mTeamMap));
        }
    }
    
}