/*********************************
  * @author        Urmi Chatterjee
  * @date          10/10/2013
  * @description   This method returns the user context with edit permission on record access
  * 
*********************************/
global without sharing class UserRecordAccess {
    /**
      * @description       This method returns the user context with edit permission on record access
      * @param             userRecId A reference to the userRecordAccess object
      * @param             oppId  A reference to the userRecordAccess object
      * @return            Boolean value for user record access level
      * @throws            NA
      */
    webservice static Boolean getHasEditAccess(String userRecId, String oppId){
        //system.debug('-----userRecId-----'+userRecId);
        //system.debug('-------oppId---'+oppId);
        Boolean accessLevel = [SELECT HasEditAccess, RecordId FROM userRecordAccess where UserId =: userRecId AND RecordId =: oppId Limit 1].HasEditAccess;
        //system.debug('----------'+accessLevel);        
        return accessLevel;
    }

}