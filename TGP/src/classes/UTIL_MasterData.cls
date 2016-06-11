/**
 * @author         
 * @date          04/10/2013
 * @description   This is utility class used for the purpose of creating Master user record.
 */
public class UTIL_MasterData{
    /**
     * @description       This utility method creates Master user record.
     * @param             Master user Email variable details
     * @param             User - standard user associated with Master user details
     * @return            List<User_Master__c>
     * @throws            NA
     */
    public static List<User_Master__c> getUserMasterData(){
        return [SELECT email__c, canBeApprover__c, canBeSolUser__c, user__c FROM User_Master__c LIMIT 5000];
    }
}