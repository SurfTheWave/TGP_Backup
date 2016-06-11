/**
 * @author        Urmi Chatterjee
 * @date          30/10/2013
 * @description   UTIL Class for creation of common Data used in Test Classes.
 */
public with sharing class UTIL_TestMethods {
    /**
     * @description       Method for defining User object record to be created for use in Test Class. 
     * @param             String aliasId- Alias Id of the User record is to be created
     * @param             String profileName - profile for which the User record is to be created
     * @return            User
     * @throws            NA
     */
    public static User runningUser(String aliasId, String profileName) {
        try {
            Id profId = [SELECT Id FROM Profile WHERE Name = : profileName].Id;
            User userData = new User(FirstName = aliasId, LastName = aliasId, Alias = aliasId, IsActive = True, Email = aliasId + UtilConstants.DOMAIN_ALISE,
            ProfileId = profId, Username = aliasId + UtilConstants.DOMAIN_ALISE, EmailEncodingKey = UtilConstants.UTF_8, CommunityNickname = UtilConstants.TEST,
            LanguageLocaleKey = UtilConstants.EN_US, LocaleSidKey = UtilConstants.EN_US, TimeZoneSidKey = UtilConstants.GMT);
            return userData;
        } Catch(Exception e) {
            //system.debug('E==='+e);
        }
        return null;
    }
    /**
      * @description       Method for setting the Custom Setting Value to display fixed records on a Visualforce page
                           for use in Test Class.
      * @param             String custName: the Custom Setting name
      * @param             Integer num: the number of records value
      * @return            void
      * @throws            NA
      */
    public static void createCustomSetting(String custName, Integer num) {
        PaginationRecords__c noOfRecs = new PaginationRecords__c(Name = custName, NumberofRecords__c = num);
        try {
            insert noOfRecs;
        } Catch(DMLException e) {
            //system.debug('E==='+e);
        }
    }
    
       /**
      * @description       Method to create Custom Setting record to determine severity level. 
      * @param             NA
      * @return            void
      * @throws            NA
      */
    public static void severityLevelValue(){
        LogSeverityLevelValue__c logLevel = new LogSeverityLevelValue__c(Name=UTIL_ErrorConstants.SYSTEM_ADMIN_PROFILE_ID,LoggingLevel__c=UTIL_ErrorConstants.SEVERITY_LEVEL_ERROR);
        insert logLevel;  
    }
}