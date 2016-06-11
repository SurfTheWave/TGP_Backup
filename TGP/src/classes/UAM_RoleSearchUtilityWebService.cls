/*
Description : 

Author : Nilesh Adkar
Story no. :

Updated by        Story no                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
           
*/

global class UAM_RoleSearchUtilityWebService
{
    
    webservice static Boolean Mob_CheckUserRoleForUpdate(String dealId, String strObjectType)
    { 
      //  UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
      //  Map<String,Boolean> m = uam.CheckUserRole(dealId,strObjectType);
	  UAMSolMobUtility.RunSoqlQueries(dealId);
      Map<String,Boolean> map_RAID_LOG = UAMSolMobUtility.checkSolMobAcess(strObjectType);      
      return map_RAID_LOG.get('C');            
    }
  /* 
  	webservice static Boolean Mob_CheckUserRoleForCreate(String dealId, String strObjectType)
    { 
        UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
        Map<String,Boolean> m = uam.CheckUserRole(dealId,strObjectType);
        return m.get('C');        
        //return UAMSolMobUtility.isAddVisible_RAIDLog;    
    }
  	 webservice static Boolean Mob_CheckUserRoleForRead(String dealId, String strObjectType)
    { 
        UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
        Map<String,Boolean> m = uam.CheckUserRole(dealId,strObjectType);
        return m.get('R');
    }
    webservice static Boolean Mob_CheckUserRoleForNA(String dealId, String strObjectType)
    { 
        UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
        Map<String,Boolean> m = uam.CheckUserRole(dealId,strObjectType);
        return m.get('NA');
    } */
}