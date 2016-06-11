/**
   @Author :     Apoorva Sharma
   @name   :     UtilUser
   @CreateDate : 2 January 2015 
   @Description :Queries the user master to return users;
   @Version :     1.0 
  */
public with sharing class UtilUser {
    /**
     * @description       This method create and return  new user
     * @param             uiD :Standard User ID details
     * @return            userid :User ID 
     * @throws            NA
     */
    public static String utilUser(String uid) {
        try {
            User_Master__c users = [SELECT id, user__r.id FROM User_Master__c WHERE id = : uid limit 500];
            String userid = users.user__r.id;
            return (userid);
        } catch (Exception e) {
            //System.debug(e);
            return null;
        }
    }    
    /**
     * @description       This method return the User mail details
     * @param             uiD :Standard User ID details
     * @return            userEmail :User Email
     * @throws            NA
     */
    public static List < String > getUserEmail(String uid){
        List < String > userEmail = new List < String > ();
        try {
            for (User_Master__c userMasterRec: [SELECT id, user__r.id, user__r.Email 
                            FROM User_Master__c WHERE id = : uid limit 500]) {
                userEmail.add(userMasterRec.user__r.Email);
            }
            return (userEmail);
        } catch (Exception e) {
            //System.debug(e); 
            return null;
        }
    }
    /**
     * @description       This method create and return new user
     * @param             Map <Id,Id>: Standard User ID map details
     * @return            Set <Id>: User Ids 
     * @throws            NA
     */
    public static Set < Id > utilUserMap(Map < Id, Id > usermap) {
        Set<Id> userids = new Set <Id> ();
        try {
            for(User_Master__c u: [SELECT id, user__r.id 
                                    FROM User_Master__c WHERE id in : usermap.keySet() LIMIT 500]) {
                userids.add(u.user__r.id);
            }
            // String userid = users[0].user__r.id;
            return (userids);
        }catch (Exception e) {
            //System.debug(e);
            return null;
        }
    }
}