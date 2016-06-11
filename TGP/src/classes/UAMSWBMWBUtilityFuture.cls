/*
  @Author: 
  @Name: 
  @Created Date:
  @Description:  
  @version: 1.0
*/
global without sharing class UAMSWBMWBUtilityFuture
{
    @future
    public static void createSharings(Map<Id,String> custUsrMap, String sObjectName){
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectName);
        sObject obj;
        //System.debug('finalUserList---creatSharingRecords-->>>>'+finalUserList);
        List < sObject > shareList = new List < sObject > ();
        for(string prntId: custUsrMap.keySet()){
            List<String> Sharevalues = custUsrMap.get(prntId).split(UtilConstants.SOQL_STRING15);
            for(String usrId :Sharevalues){
                obj = targetType.newSObject();
                obj.put(UtilConstants.PARENTID, prntId);
                obj.put(UtilConstants.USER_GROUPID,usrId);
                obj.put(UtilConstants.ACCESS_LEVEL,UtilConstants.EDIT_VALUE);
                obj.put(UtilConstants.ROW_CAUSE,UtilConstants.MANUAL_STRING);
                shareList.add(obj);
                //System.debug('shareList--->>>>' + obj);
            }
        }
        shareList.sort();
        //System.debug('shareList--->>>>'+shareList);   
        Database.SaveResult[] dealShareInsertResult = Database.insert(shareList, false);
    }
    
     @future
     public static void updateShareRecords(set < id > parentids, set < id > userids, set<Id> usersToDeleteShareAccess,string sobjectName) {
        
            list < sobject > updateRecords = new List < sobject > ();

            list < sobject > getshareRecords = database.query(UtilConstants.SELECT_STAT + sobjectName + UtilConstants.QUERY_PART2);
            List < Database.deleteResult > performdelete = Database.delete(getshareRecords, false);
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectName);
            sObject obj;
            if (parentids.size() > userids.size()) {
                for (id pid: parentids) {
                    for (id userid: userids) { 
                        obj = targetType.newSObject();
                        obj.put(UtilConstants.USER_GROUPID, userId);
                        obj.put(UtilConstants.PARENTID, pid);
                        obj.put(UtilConstants.ACCESS_LEVEL, UtilConstants.EDIT_STRING);
                        obj.put(UtilConstants.ROW_CAUSE, UtilConstants.MANUAL_STRING);
                        updateRecords.add(obj);
                    }
                }
            } else {
                for (id userid: userids) {
                    for (id pid: parentids) {
                        obj = targetType.newSObject();
                        obj.put(UtilConstants.USER_GROUPID, userId);
                        obj.put(UtilConstants.PARENTID, pid);
                        obj.put(UtilConstants.ACCESS_LEVEL, UtilConstants.EDIT_STRING);
                        obj.put(UtilConstants.ROW_CAUSE, UtilConstants.MANUAL_STRING);
                        updateRecords.add(obj);
                    }
                }
            }
            List < Database.saveResult > performUpdate = database.insert(updateRecords, false);
            System.debug('updated final list::::::' + performUpdate);
            for (Database.saveResult uresult: performUpdate) {
                if (uresult.isSuccess()) {
                    //System.debug('updated Records::::::::::::::::::::' + uresult);
                } else {
                    //System.debug('failed Records::::::::' + uresult.getErrors());
                }
            }
         
    }
}