public class Mob_PrepopulateUserRoles
{
    public void insertUserRoles(List<Deal_tgp__c> lstDeal)
    {
        List<Mob_User_Roles_Master__c> lstUserRole = [select id, Role_Name__c,Access_Level__c from Mob_User_Roles_Master__c];
        List<MOB_User_Role_Assignment__c> lstUserRoleAssign= new List<MOB_User_Role_Assignment__c>();
        MOB_User_Role_Assignment__c userRoleAssign; 
        for(Mob_User_Roles_Master__c tmpUserRole : lstUserRole)
        {
            userRoleAssign = new MOB_User_Role_Assignment__c();
            userRoleAssign.Deal__c = lstDeal.get(0).id;
            userRoleAssign.Mob_User_Roles_Master__c = tmpUserRole.id;
            userRoleAssign.Role_Name__c = tmpUserRole.Role_Name__c ;
            userRoleAssign.Access_Level__c = tmpUserRole.Access_Level__c ;
            if(UTIL_Constants.GOVERNANCE_LEAD.equalsIgnoreCase(tmpUserRole.Role_Name__c)==true)
                userRoleAssign.User_Assigned_New__c = lstDeal.get(0).Governance_Lead_Name_New__c;
            lstUserRoleAssign.add(userRoleAssign); 
        }      
        insert lstUserRoleAssign;
    }
    
}