public class Mob_CascadeUserRoleChanges
{

public static void CascadeUserRoleChangesOnUpdate(List<Mob_User_Roles_Master__c> lstOldUserRole, List<Mob_User_Roles_Master__c> lstNewUserRole)
{
    if(lstOldUserRole.size()>0 && lstNewUserRole.size()>0)
    {
        if(lstOldUserRole.get(0).Role_Name__c!= lstNewUserRole.get(0).Role_Name__c)
        {    
            List<MOB_User_Role_Assignment__c> lstUserRole = [select id,Role_Name__c,Mob_User_Roles_Master__c,
                                                                Access_Level__c,Deal__c 
                                                                from  MOB_User_Role_Assignment__c where Role_Name__c=:lstOldUserRole.get(0).Role_Name__c ];
                                                                
            for(MOB_User_Role_Assignment__c tmpUserRole : lstUserRole )    
            {
                tmpUserRole.Role_Name__c=  lstNewUserRole.get(0).Role_Name__c;
                tmpUserRole.Mob_User_Roles_Master__c= lstNewUserRole.get(0).id;
                tmpUserRole.Access_Level__c = lstNewUserRole.get(0).Access_Level__c;
            }    
            update lstUserRole ;
        }
    }
}


public static void CascadeUserRoleChangesOnInsert(List<Mob_User_Roles_Master__c> lstNewUserRole)
{
    List<MOB_User_Role_Assignment__c> lstUserRole = new List<MOB_User_Role_Assignment__c>();
    MOB_User_Role_Assignment__c tmpUserAssign;
    if(lstNewUserRole.size()>0)
    {
        List<deal_tgp__c> lstDeal = [select id from deal_tgp__c];
        for(Mob_User_Roles_Master__c tmpUserRole: lstNewUserRole)
        {
            for(deal_tgp__c tmpDeal : lstDeal )
            {
                tmpUserAssign= new MOB_User_Role_Assignment__c ();
                tmpUserAssign.deal__c = tmpDeal.id ;
                tmpUserAssign.Role_Name__c = tmpUserRole.Role_Name__c;
                tmpUserAssign.Mob_User_Roles_Master__c= tmpUserRole.id;
                tmpUserAssign.Access_Level__c = tmpUserRole.Access_Level__c;
                lstUserRole.add(tmpUserAssign);
            }
        }        
        insert lstUserRole;
    }
}


public static void CascadeUserRoleChangesOnDelete(List<Mob_User_Roles_Master__c> lstOldUserRole)
{
    if(lstOldUserRole.size()>0)
    {
        List<MOB_User_Role_Assignment__c > lstUserRole = [select id,Role_Name__c ,Mob_User_Roles_Master__c
                                                            from  MOB_User_Role_Assignment__c 
                                                            where Role_Name__c = :lstOldUserRole.get(0).Role_Name__c
                                                         ];   
        if(lstUserRole.size()>0)
        {
            delete lstUserRole;
        }    
    }
}

}