@isTest
/*
   @Author       : Madhusudhan
   @Class name   : UTIL_TestDataCreationForMobClasses
   @CreateDate   : 4 March 2015 
   @Description : Class for creating Test Data
   @Version : 1.0 
  */
public with sharing class UTIL_TestDataCreationForMobClasses {
    private static final string ALIAS = UtilConstants.ALIAS;
    private static final string EMAIL = UtilConstants.USER_NAME;
    private static final string EMAIL_ENCODING_KEY = UtilConstants.UTF_8;
    private static final string LANGUAGE_LOCAL_KEY = UtilConstants.EN_US;
    private static final string COUNTRY = UtilConstants.COUNTRY;
    private static final string TIME_ZONE = UtilConstants.TIME_ZONE;
    public static final string USER_NAME = UtilConstants.USER_NAME;
    private static final string LAST_NAME = UtilConstants.LAST_NAME;
    /******************************
     * Method Name: getProfile
     * Description: get the profile record based on profile name
     * Paramenters: profile Name
     * Return Value: profile
     *******************************/
    public static profile getProfile(String profileName) {
        try {
            Profile p = [Select id from Profile where Name = : profileName limit 1];
            return p;
        } Catch(Exception e) {
            //System.debug('E==='+e);
        }
        return null;
    }
    /******************************
     * Method Name: getUserWithProfile
     * Description: get user record based on profile
     * Paramenters: profile 
     * Return Value: User
     *******************************/
    public static User getUserWithProfile(Profile p, String userName) {
        try {
            User testUser = new User(alias = ALIAS, email = EMAIL,
            emailencodingkey = EMAIL_ENCODING_KEY, lastname = LAST_NAME, languagelocalekey = LANGUAGE_LOCAL_KEY,
            localesidkey = LANGUAGE_LOCAL_KEY, profileid = p.Id, country = COUNTRY,
            timezonesidkey = TIME_ZONE, username = userName);
            return testUser;
        } Catch(Exception e) {
            //System.debug('E==='+e);
        }
        return null;
    }
    /**
     *  @Description : This method is used to create operating group Master record
     *  @name : createOperatingGroup
     *  @param : String Name
     *  @return parameter - Operating_Groups_Master__c
     *  @throws exception- N/A
     */
    public static Operating_Groups_Master__c createOperatingGroup(String Name) {
        try {
            Operating_Groups_Master__c operatingGroupRec = new Operating_Groups_Master__c();
            operatingGroupRec.Name = Name;
            insert operatingGroupRec;
            return operatingGroupRec;
        } Catch(DMLException e) {
            //System.debug('E==='+e);
        }
        return null;
    }

    /**
     *  @Description : This method is used to create record of opportunity 
     *  @name : Opportunity
     *  @param : 
     *  @return parameter - Opportunity
     *  @throws exception- N/A
     */
    public static Opportunity getOpportunity() {
        try {
            Opportunity opp = new Opportunity();
            Operating_Groups_Master__c oppOperatingGrup = createOperatingGroup(UtilConstants.INDIA);
            opp.OperatingGroup__c = oppOperatingGrup.id;
            opp.name = UtilConstants.TEST_OPP;
            opp.Geo_Area__c = UTIL_Constants.AsiaPacific;
            opp.Reporting_Status__c = UtilConstants.UNQUALIFIED;
            opp.StageName = UtilConstants.OA;
            opp.Risk_Level__c = UtilConstants.LOW;
            opp.SAP_OM_Id_Dev__c = UtilConstants.SAPIDDEV;
            opp.SAP_OM_ID__c = UtilConstants.SAPOMID;
            opp.CloseDate = date.newInstance(2001, 3, 21);
            insert opp;
            return opp;
        } Catch(Exception e) {
            //System.debug('E==='+e);
        }
        return null;
    }
    /******************************
      Description : This method is used to create record of Account
    * Method Name: getAccountRec
    * Description: get Account record
    * Paramenters: Name
    * Return Value: Account
    ***************************/
    public static Account createAccount(String Name) {
        try {
            Account acc = new Account(Name = UtilConstants.TEST_ACT);
            insert acc;
            return acc;
        } Catch(Exception e) {
            //System.debug('E==='+e);
        }
        return null;
    }
    /******************************
      Description : This method is used to create record of deal
    * Method Name: getDeal
    * Description: get Deal record
    * Paramenters: N/A
    * Return Value: deal
    ***************************/
    public static Deal__c getDeal() {
        try {
            Deal__c deal = new Deal__c();
            deal.Name = UtilConstants.TEST_DEAL;
            deal.Active__c = True;
            Account acc = createAccount(UtilConstants.TEST_ACC);
            deal.Client__c = acc.id;
            insert deal;
            return deal;
        } Catch(DMLException e) {
            //System.debug('E==='+e);
        }
        return null;
    }
    /******************************
      Description : This method is used to create record of Mobilization Plan
    * Method Name: getDeal
    * Description: get Deal record
    * Paramenters: N/A
    * Return Value: deal
    ***************************/
    public static Mobilization_Plan__c getMobilizationPlan() {
        try {
            Mobilization_Plan__c mp = new Mobilization_Plan__c();
            mp.Name = UtilConstants.TEST_MP;
            Deal__c deal = getDeal();
            mp.Deal__c = deal.id;
            insert mp;
            return mp;
        } Catch(DMLException e) {
            //System.debug('E==='+e);
        }
        return null;
    }

}