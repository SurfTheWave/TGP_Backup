global class MobilizationSharingBatch implements Database.Batchable<sObject>,Database.Stateful{
    global String query;
    global String objFlag;
    global Map<Id,Id> objWithDealId=new Map<Id,Id>();
    global set<Id> objectId=new set<Id>();
    global set<Id> userIdSet=new set<Id>();
    global Map<Id,set<Id>> dealWithMobTeam=new Map<Id,set<Id>>();
    global MobilizationSharingBatch(set<Id> ojectId,Map<Id,Id> objectWithDeal,Map<Id,set<Id>> dealMobMap,String flag,String objQuery){
        query=objQuery;
        objFlag=flag;
        objWithDealId=objectWithDeal;
        objectId=ojectId;
        dealWithMobTeam=dealMobMap;
        
    }
	global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc,List<sObject> sObjectList){
        List<sObject> shareObjectInsert=new List<sObject>();
        
        for(sObject obj:sObjectList){
            Id oId=String.valueOf(obj.get('Id'));
            Id dealId=objWithDealId.get(oId);
            String ownerId=String.valueOf(obj.get('ownerId'));
            if(dealId!=null){
            	userIdSet=dealWithMobTeam.get(dealId);    
            }
            
                
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objFlag);
            if(userIdSet!=null && !userIdSet.isEmpty()){
                for(Id userId:userIdSet){
                        if(!ownerId.equals(userId)){
                            obj = targetType.newSObject();
                            obj.put(UtilConstants.USER_GROUPID, userId);
                            obj.put(UtilConstants.PARENTID, oId);
                            obj.put(UtilConstants.ACCESS_LEVEL, UtilConstants.EDIT_STRING);
                            obj.put(UtilConstants.ROW_CAUSE, UtilConstants.MANUAL_STRING);
                            shareObjectInsert.add(obj);    
                    	}
                }
            }
            
        }
        Database.insert(shareObjectInsert,false);
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}