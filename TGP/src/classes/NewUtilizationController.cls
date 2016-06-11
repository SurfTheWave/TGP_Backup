/******************************
   @Author       : 
   @Class name   : NewUtilizationController
   @CreateDate   : 
   @Description : 
   @Version : 1.0 
*******************************/
Public without sharing class NewUtilizationController{
    public static String SEPERATOR_withspace = UtilConstants.SEMICOLON_STRING_WHITESPACE;
    /******************************
     * Method Name: cleanUpDupRoles
     * Description: 
     * Paramenters: set<id> utilids
     * Return Value: void
     *******************************/ 
    public void cleanUpDupRoles(set<id> utilids){
    List<Utilizations__c> utils_toupdate = new List<utilizations__c>();
    List<string> roles = new List<string>();
    string rolestoinsert = UtilConstants.EMPTY_STRING;
    Map<string,string> rolesAfterDupRemoval = new Map<string,string>();
    List<utilizations__c> utilnewlist = new List<utilizations__c>();
    utilnewlist = [select id,user_role_s__c from utilizations__c where ID IN:utilids LIMIT 5000];
        for(utilizations__c util : utilnewlist ){
        if(util.user_role_s__c != null){
            roles = util.user_role_s__c.trim().split(UtilConstants.SEMICOLON_STRING);
        }
        }
        for(string role: roles){
        role = role.trim();
            rolesAfterDupRemoval.put(role,role);
        }
        //System.debug('roles after dup removal'+rolesAfterDupRemoval);
        for(utilizations__c util : utilnewlist){
            for(string ss : rolesAfterDupRemoval.keyset()){
                rolestoinsert +=UtilConstants.BLANK_SPACE +ss+SEPERATOR_withspace;   
            }
            util.user_role_s__c = rolestoinsert ;
            utils_toupdate.add(util);
        }
        //System.debug('utils to update:::'+utils_toupdate);
        Database.update(utils_toupdate,false);
    }
}