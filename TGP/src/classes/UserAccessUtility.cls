/*

Description : Generic Class to manage access permissions of an object through apex
Author :       Nilesh Adkar (Accenture)

Updated by        Update date        User story
-----------    ------------------  --------------

*/

public without sharing class UserAccessUtility
{

// Users and corresponding access rights
     class UserList
     {
         Id userId;
         String accessLevel;
     }  

/*-------------------------------------------------------
Description : Check id in set
---------------------------------------------------------*/

public boolean CheckIdInSet(Id strId, Set<Id> lstId)
{
    for(Id tmpId : lstId)
    {
        if(strId == tmpId){
            return true;
        }
    }
    return false;
}


//========================================    MOB UAM Starts  ==============================================    
/*-------------------------------------------------------
Description : Access management for Deal

---------------------------------------------------------*/

    public void CheckAccessDeal(String strDealId, List<MOB_User_Role_Assignment__c> lstUserRoleAssign )
    {
        String strAccessLevel;
        Deal_TGP__Share dealShareLeads;
        List<Deal_TGP__Share> lstDealTgpShare = new List<Deal_TGP__Share>();
        
        List<UAM_Roles_Permissions__c> lstUserRole = UAM_Roles_Permissions__c.getall().values();
        Set<Id> setUserIdsWithEditAccess = new Set<Id>();
        List<MOB_User_Role_Assignment__c> listOfMobRole=new List<MOB_User_Role_Assignment__c>();
        listOfMobRole=[select id, Role_Name__c, User_Assigned_New__c, User_Assigned_New__r.SFDC_User__c,
                       User_Assigned_Secondary_New__c, User_Assigned_Secondary_New__r.SFDC_User__c,
                       User_Assigned_Secondary_Lead__c, User_Assigned_Secondary_Lead__r.SFDC_User__c 
                       from MOB_User_Role_Assignment__c where id IN: lstUserRoleAssign limit 10000];
         
        for(MOB_User_Role_Assignment__c tmpUser : listOfMobRole)
        {  
            for(UAM_Roles_Permissions__c tmpRoleCustSet : lstUserRole )
            {
                if(tmpRoleCustSet.Object_Name__c.equalsIgnoreCase(UTIL_Constants.UAM_OBJ_Deal_TGP) && 
                    tmpRoleCustSet.Roles__c.equalsIgnoreCase(tmpUser.Role_Name__c))
                {
                    if(tmpRoleCustSet.Permissions__c.containsIgnoreCase(UTIL_Constants.CREATE) || 
                        tmpRoleCustSet.Permissions__c.containsIgnoreCase(UTIL_Constants.UAM_UPDATE))
                    {
                        strAccessLevel = UTIL_Constants.EDIT;
                        if(tmpUser.User_Assigned_New__c != null)
                         {                        
                            setUserIdsWithEditAccess.add(tmpUser.User_Assigned_New__r.SFDC_User__c);
                          }                            
                        if(tmpUser.User_Assigned_Secondary_New__c != null)
                          {                        
                            setUserIdsWithEditAccess.add(tmpUser.User_Assigned_Secondary_New__r.SFDC_User__c );     
                          }                            
                        if(tmpUser.User_Assigned_Secondary_Lead__c != null)
                          {                        
                            setUserIdsWithEditAccess.add(tmpUser.User_Assigned_Secondary_Lead__r.SFDC_User__c );     
                          }                                                      
                    }
                    else
                    {                    
                        if(tmpUser.User_Assigned_New__c!=null && CheckIdInSet(tmpUser.User_Assigned_New__r.SFDC_User__c,setUserIdsWithEditAccess)==false)
                           { strAccessLevel = UTIL_Constants.EDIT;}
                        if(tmpUser.User_Assigned_Secondary_New__c!=null && CheckIdInSet(tmpUser.User_Assigned_Secondary_New__r.SFDC_User__c,setUserIdsWithEditAccess)==false)    
                            { strAccessLevel = UTIL_Constants.EDIT;}
                        if(tmpUser.User_Assigned_Secondary_Lead__c!=null && CheckIdInSet(tmpUser.User_Assigned_Secondary_Lead__r.SFDC_User__c,setUserIdsWithEditAccess)==false)    
                            { strAccessLevel = UTIL_Constants.EDIT;}                            
                    }
                    if(tmpUser.User_Assigned_New__c != null)
                    {
                         dealShareLeads= new Deal_TGP__Share();                     
                         dealShareLeads.ParentId = strDealId;
                         dealShareLeads.UserOrGroupId = tmpUser.User_Assigned_New__r.SFDC_User__c;
                         dealShareLeads.AccessLevel = strAccessLevel;
                         dealShareLeads.RowCause = UTIL_Constants.MANUAL;
                         lstDealTgpShare.add(dealShareLeads);
                    } 
                    if(tmpUser.User_Assigned_Secondary_New__c != null)
                    {
                         dealShareLeads= new Deal_TGP__Share();                     
                         dealShareLeads.ParentId = strDealId;
                         dealShareLeads.UserOrGroupId = tmpUser.User_Assigned_Secondary_New__r.SFDC_User__c ;
                         dealShareLeads.AccessLevel = strAccessLevel;
                         dealShareLeads.RowCause = UTIL_Constants.MANUAL;
                         lstDealTgpShare.add(dealShareLeads);
                    } 
                    if(tmpUser.User_Assigned_Secondary_Lead__c != null)
                    {
                         dealShareLeads= new Deal_TGP__Share();                     
                         dealShareLeads.ParentId = strDealId;
                         dealShareLeads.UserOrGroupId = tmpUser.User_Assigned_Secondary_Lead__r.SFDC_User__c ;
                         dealShareLeads.AccessLevel = strAccessLevel;
                         dealShareLeads.RowCause = UTIL_Constants.MANUAL;
                         lstDealTgpShare.add(dealShareLeads);
                    } 
                    
                }
            }    
        }
        
        Database.SaveResult[] dealTgpInsertResult = Database.insert(lstDealTgpShare,false);
        List<Deal_TGP__c> lstDeal = [select id, Governance_Lead_Name_New__r.SFDC_User__c ,Solution_Architect_New__r.SFDC_User__c  
        from Deal_TGP__c where id=:strDealId limit 10000];
        CheckAccessDeal(lstDeal);
    }

    public void CheckAccessDeal(List<Deal_TGP__c> lstDeal)
    {
        Deal_TGP__Share dealShareLeads;
        List<Id> lstId = new List<Id>();
        List<Deal_TGP__c> lstDealRecord= new List<Deal_TGP__c>();
        lstDealRecord= [select id,Governance_Lead_Name_New__r.SFDC_User__c,Solution_Architect_New__r.SFDC_User__c from Deal_TGP__c 
        where id IN:lstDeal limit 10000];
        for(Deal_TGP__c tmpDeal : lstDeal)
        {
            lstId.add(tmpDeal.Id);            
        }
        List<Deal_TGP__Share> lstDealTgpShare = new List<Deal_TGP__Share>();
        List<Deal_TGP__Share> lstDealShare = [select UserOrGroupId from Deal_TGP__Share where ParentId in :lstId limit 10000];
        lstId = new List<Id>();
        for(Deal_TGP__Share tmpDeal : lstDealShare)
        {
            lstId.add(tmpDeal.UserOrGroupId);
        }
        
        /*List<User> lstUser = [select id,Profile.Name from User where (Profile.Name ='Mobilization Admin' OR Profile.Name ='Super Admin') and id not in :lstId ];
        for(Deal_TGP__c tmpDeal :lstDeal)
        {
            for(User tmpUser : lstUser)
            {
                 dealShareLeads= new Deal_TGP__Share();                     
                 dealShareLeads.ParentId = tmpDeal.id ;
                 dealShareLeads.UserOrGroupId = tmpUser.id ;
                 dealShareLeads.AccessLevel = 'edit';
                 dealShareLeads.RowCause = 'Manual';
                 lstDealTgpShare.add(dealShareLeads);
            }        
        }*/   
        for(Deal_TGP__c tmpDeal :lstDealRecord)
        {
            // Governance_Lead
            if(tmpDeal.Governance_Lead_Name_New__r.SFDC_User__c != null)
            {
                 dealShareLeads= new Deal_TGP__Share();                     
                 dealShareLeads.ParentId = tmpDeal.id ;
                 dealShareLeads.UserOrGroupId = tmpDeal.Governance_Lead_Name_New__r.SFDC_User__c ;
                 dealShareLeads.AccessLevel = UTIL_Constants.EDIT;
                 dealShareLeads.RowCause = UTIL_Constants.MANUAL;
                 lstDealTgpShare.add(dealShareLeads);
            } 
            // Solution Architect
            if(tmpDeal.Solution_Architect_New__r.SFDC_User__c != null)
            {
                 dealShareLeads= new Deal_TGP__Share();                     
                 dealShareLeads.ParentId = tmpDeal .id ;
                 dealShareLeads.UserOrGroupId = tmpDeal.Solution_Architect_New__r.SFDC_User__c ;
                 dealShareLeads.AccessLevel = UTIL_Constants.EDIT;
                 dealShareLeads.RowCause = UTIL_Constants.MANUAL;
                 lstDealTgpShare.add(dealShareLeads);
            }
        }
        Database.SaveResult[] dealTgpInsertResult = Database.insert(lstDealTgpShare,false);
        updateDealTrackAccess();
    }
        
/*--------------------------------------------------------------------
Description : Access management for Deal Delete shared data

----------------------------------------------------------------------*/ 
    public void CheckAccessDealDelete(String strDealId, List<MOB_User_Role_Assignment__c> lstUserRoleAssign ) {
    
        Set<Id> userMasterId=new Set<ID>();
    
        Set<Id> roleIds = new Set<Id>();
        Set<Id> dealTgpId = new Set<Id>();
        //List<MOB_User_Role_Assignment__c> lstUserRoleAssignSFDCUser=new List<MOB_User_Role_Assignment__c>();
        //lstUserRoleAssignSFDCUser=[select id,User_Assigned_New__c ,User_Assigned_New__r.SFDC_User__c,User_Assigned_Secondary_New__r.SFDC_User__c,User_Assigned_Secondary_New__c  from MOB_User_Role_Assignment__c where id IN:lstUserRoleAssignSFDCUser];
        dealTgpId.add(strDealId);
        boolean isPresent = false;
        
        for(MOB_User_Role_Assignment__c tmpUserRole : lstUserRoleAssign){
        
            userMasterId.add(tmpUserRole.User_Assigned_New__c);
            userMasterId.add(tmpUserRole.User_Assigned_Secondary_New__c);
            userMasterId.add(tmpUserRole.User_Assigned_Secondary_Lead__c);    
        }
        List<Review_User_Master__c> revUserMaster =[Select UserName__c,SFDC_User__c from Review_User_Master__c where 
        id in : userMasterId limit 10000];    
        for(Review_User_Master__c revUser : revUserMaster){        
            roleIds.add(revUser.SFDC_User__c);
        }
        
       /* for(MOB_User_Role_Assignment__c tmpUserRole : lstUserRoleAssignSFDCUser)
        {
        
           
            if(tmpUserRole.User_Assigned_New__c != null)
                roleIds.add(tmpUserRole.User_Assigned_New__r.SFDC_User__c);
            if(tmpUserRole.User_Assigned_Secondary_New__c != null)
                roleIds.add(tmpUserRole.User_Assigned_Secondary_New__r.SFDC_User__c);
                
        }*/
        List<Deal_TGP__c> lstDeal = [select Governance_Lead_Name_New__r.SFDC_User__c,Solution_Architect_New__r.SFDC_User__c 
                                    FROM Deal_TGP__c where id in :dealTgpId limit 10000];
                                    
        for(Deal_TGP__c tmpDeal : lstDeal)
        {
            roleIds.add(tmpDeal.Governance_Lead_Name_New__r.SFDC_User__c);
            roleIds.add(tmpDeal.Solution_Architect_New__r.SFDC_User__c);
        }
        
        List<Deal_Location__c> lstDealLoc = [select id from deal_location__c where 
                                                    (Deployment_Lead_New__r.SFDC_User__c in : roleIds or Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c in : roleIds or Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c in : roleIds
                                                    or Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c in : roleIds or  Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c in : roleIds or Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__c in : roleIds) 
                                                    and (Wave_Plan_Version__r.Deal__c in : dealTgpId) limit 10000];
                                           
        Set<Id> roleIdsToDelete = new Set<Id>();
        for(Id tmpId : roleIds)
        {
            if(tmpId != null)
            {
               /* string str='select id from deal_location__c where (Deployment_Lead_New__r.SFDC_User__c= '+ tmpId +' or Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c = '+ tmpId +') and (Wave_Plan_Version__r.Deal__c in '+ dealTgpId +')';
                List<Deal_Location__c> lstDealLoc = [select id from deal_location__c where 
                                                    (Deployment_Lead_New__r.SFDC_User__c= :tmpId or Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c = :tmpId or Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c = :tmpId
                                                    or Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c= :tmpId or  Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c= :tmpId or Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__c= :tmpId) 
                                                    and (Wave_Plan_Version__r.Deal__c in : dealTgpId) ]; */
                if(lstDealLoc.size()>0)
                {
                    roleIdsToDelete.remove(tmpId);
                }
                else if(lstDealLoc.size()==0)                                                
                {
                    roleIdsToDelete.add(tmpId);
                }   
                else{}
            }
        }
        
        List<Wave_Planning__c> lstWavePlan = [select id from Wave_Planning__c where 
                                                    (Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c in : roleIds or  Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c in : roleIds or Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c in : roleIds or
                                                    Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c in : roleIds or  Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c in : roleIds or 
                                                    Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c in : roleIds or Mob_Technology_Lead_Secondary_New__r.SFDC_User__c in : roleIds or Mob_Technology_Lead_Secondary_2__r.SFDC_User__c in : roleIds or 
                                                    KT_Lead_New__r.SFDC_User__c in : roleIds or   Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c in : roleIds or Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c in : roleIds ) 
                                                    and (deal_location__r.Wave_Plan_Version__r.Deal__c in :dealTgpId) limit 10000];
        for(Id tmpId : roleIds)
        {
            if(tmpId != null)
            {
                /* List<Wave_Planning__c> lstWavePlan = [select id from Wave_Planning__c where 
                                                    (Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c= :tmpId or  Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c= :tmpId or Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c= :tmpId or
                                                    Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c= :tmpId or  Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c= :tmpId or 
                                                    Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c= :tmpId or Mob_Technology_Lead_Secondary_New__r.SFDC_User__c= :tmpId or Mob_Technology_Lead_Secondary_2__r.SFDC_User__c= :tmpId or 
                                                    KT_Lead_New__r.SFDC_User__c= :tmpId or   Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c= :tmpId or Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c= :tmpId ) 
                                                    and (deal_location__r.Wave_Plan_Version__r.Deal__c in :dealTgpId)]; */
                if(lstWavePlan.size()>0)
                {
                    roleIdsToDelete.remove(tmpId);
                }                                                
                else if(lstWavePlan.size()==0 && CheckIdInSet(tmpId,roleIdsToDelete)==false)                                                
                {
                    roleIdsToDelete.add(tmpId);
                }
                else{}
            }                                   
        }
        
        List<Deal_TGP__Share> lstDealTgpSharedelete = [Select ParentId,UserOrGroupId from Deal_TGP__Share where ParentId IN: dealTgpId AND UserOrGroupId IN: roleIdsToDelete AND RowCause =:UTIL_Constants.MANUAL limit 10000];
        Set<Id> pId=new Set<Id>();
        for(Deal_TGP__Share parentList : lstDealTgpSharedelete){
            pId.add(parentList.ParentId);
        }
        List<Deal_Track__c> dealTrackList=[select id from Deal_Track__c where Deal__c IN : pId];
        CheckAccessOfDealTrackDelete(dealTrackList);
        Database.DeleteResult[] dealTgpDeleteResult = Database.delete(lstDealTgpSharedelete,false);
    }   


//END

/*--------------------------------------------------------------------
Description : Access management for Deal Delete shared data

----------------------------------------------------------------------*/ 
    public void CheckAccessDealDelete(List<Deal_TGP__c> lstSObjOld) {
        
        Set<Id> roleIds = new Set<Id>();
        Set<Id> dealTgpId = new Set<Id>();
        Set<Id> userMasterId=new Set<ID>();
        //List<Deal_TGP__c> lstSObjOldSFDCUser=new List<Deal_TGP__c>();
        //lstSObjOldSFDCUser=[select id,Governance_Lead_Name_New__c,Governance_Lead_Name_New__r.SFDC_User__c,Solution_Architect_New__r.SFDC_User__c from Deal_TGP__c where id IN:lstSObjOld];
        boolean isPresent = false;
           
        for(Deal_TGP__c dealTgp : lstSObjOld)
        { 
            //roleIds.add(dealTgp.Governance_Lead_Name_New__r.SFDC_User__c);
            //roleIds.add(dealTgp.Solution_Architect_New__r.SFDC_User__c);
            userMasterId.add(dealTgp.Governance_Lead_Name_New__c);
            userMasterId.add(dealTgp.Solution_Architect_New__c); 
            dealTgpId.add(dealTgp.Id);
        }
        
        List<Review_User_Master__c> revUserMaster =[Select UserName__c,SFDC_User__c from Review_User_Master__c where 
        id in : userMasterId limit 10000]; 
        for(Review_User_Master__c revUser : revUserMaster){ 
            roleIds.add(revUser.SFDC_User__c);
        }
        
        List<Deal_Location__c> lstDealLoc = [select id from deal_location__c where 
                                                    (Deployment_Lead_New__r.SFDC_User__c IN: roleIds or Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c IN: roleIds or Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c IN: roleIds
                                                    or Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c IN: roleIds or  Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c IN: roleIds or Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__c IN: roleIds) 
                                                    and (Wave_Plan_Version__r.Deal__c in : dealTgpId) limit 10000];
        

        Set<Id> roleIdsToDelete = new Set<Id>();
        for(Id tmpId : roleIds)
        {
            if(tmpId != null)
            {
                /*string str='select id from deal_location__c where (Deployment_Lead_New__r.SFDC_User__c= '+ tmpId +' or Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c = '+ tmpId +') and (Wave_Plan_Version__r.Deal__c in '+ dealTgpId +')';
                List<Deal_Location__c> lstDealLoc = [select id from deal_location__c where 
                                                    (Deployment_Lead_New__r.SFDC_User__c= :tmpId or Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c = :tmpId or Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c = :tmpId
                                                    or Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c= :tmpId or  Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c= :tmpId or Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__c= :tmpId) 
                                                    and (Wave_Plan_Version__r.Deal__c in : dealTgpId) ];*/
                if(lstDealLoc.size()>0)
                {
                    isPresent = true;
                    //return;
                }
                else if(lstDealLoc.size()==0)                                                
                {
                    roleIdsToDelete.add(tmpId);
                } 
                else{}
            }
        }
        
        List<Wave_Planning__c> lstWavePlan = [select id from Wave_Planning__c where 
                                                     (Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c IN: roleIds or  Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c IN: roleIds or Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c IN: roleIds or 
                                                      Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c IN: roleIds or  Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c IN: roleIds or 
                                                      Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c IN: roleIds or Mob_Technology_Lead_Secondary_New__r.SFDC_User__c IN: roleIds or Mob_Technology_Lead_Secondary_2__r.SFDC_User__c IN: roleIds or 
                                                      KT_Lead_New__r.SFDC_User__c IN: roleIds or Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c IN: roleIds or Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c IN: roleIds)
                                                       and (deal_location__r.Wave_Plan_Version__r.Deal__c in :dealTgpId) limit 10000];
                                                       
        for(Id tmpId : roleIds)
        {
            if(tmpId != null)
            {
               /* List<Wave_Planning__c> lstWavePlan = [select id from Wave_Planning__c where 
                                                     (Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c= :tmpId or  Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c= :tmpId or Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c= :tmpId or 
                                                      Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c= :tmpId or  Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c= :tmpId or 
                                                      Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c= :tmpId or Mob_Technology_Lead_Secondary_New__r.SFDC_User__c= :tmpId or Mob_Technology_Lead_Secondary_2__r.SFDC_User__c= :tmpId or 
                                                      KT_Lead_New__r.SFDC_User__c= :tmpId or Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c= :tmpId or Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c= :tmpId)
                                                       and (deal_location__r.Wave_Plan_Version__r.Deal__c in :dealTgpId)];*/
                if(lstWavePlan.size()>0)
                {
                    isPresent = true;
                    //return;
                }                                                
                else if(lstWavePlan.size()==0 && CheckIdInSet(tmpId,roleIdsToDelete)==false)                                                
                {
                    roleIdsToDelete.add(tmpId);
                }
                else{}
            }                                   
        }
        
        if(isPresent){
            return;
        }
        if(roleIdsToDelete.size()==0)
        {
            for(Id tmpId : roleIds)
            {
                if(tmpId != null)
                {
                    roleIdsToDelete.add(tmpId);
                }
            }
        }
        List<Deal_TGP__Share> lstDealTgpSharedelete = [Select ParentId,UserOrGroupId from Deal_TGP__Share where 
        ParentId IN: dealTgpId AND UserOrGroupId IN: roleIdsToDelete AND RowCause =:UTIL_Constants.MANUAL limit 10000];
        Set<Id> pId=new Set<Id>();
        for(Deal_TGP__Share parentList : lstDealTgpSharedelete){
            pId.add(parentList.ParentId);
        }
        List<Deal_Track__c> dealTrackList=[select id from Deal_Track__c where Deal__c IN : pId limit 10000];
        CheckAccessOfDealTrackDelete(dealTrackList);
        Database.DeleteResult[] dealTgpInsertResult = Database.delete(lstDealTgpSharedelete,false);
    }   

//End

    public void CheckAccessOfDealTrack(List<Deal_Track__c> lstNewDealTrack)
    {
        Deal_Track__Share dealTrackShare;
        Set<Id> delIds = new Set<Id>();
        List<Deal_Track__c> dealTrackList = new List<Deal_Track__c>();
        List<Deal_Track__Share> lstDealTgpShare = new List<Deal_Track__Share>();
        dealTrackList=[select id,Name,Deal__c from Deal_Track__c where id IN : lstNewDealTrack]; 
        for(Deal_Track__c dtList : dealTrackList){
            delIds.add(dtList.Deal__c);
        }
        List<Deal_TGP__Share> lstDealTgpTrackShare = [Select ParentId,UserOrGroupId,AccessLevel from Deal_TGP__Share where ParentId IN: delIds limit 10000];
        if(lstDealTgpTrackShare.size() > 0)
        {
            for(Deal_Track__c dTrackList : dealTrackList){
                for(Deal_TGP__Share lstDealTgpList : lstDealTgpTrackShare){ 
                    if(dTrackList.Deal__c == lstDealTgpList.ParentId){
                        dealTrackShare= new Deal_Track__Share();        
                         dealTrackShare.ParentId = dTrackList.Id;
                         dealTrackShare.UserOrGroupId = lstDealTgpList.UserOrGroupId;
                         dealTrackShare.AccessLevel = 'Read';
                         dealTrackShare.RowCause = UTIL_Constants.MANUAL;
                         lstDealTgpShare.add(dealTrackShare);
                    }       
                }
            }
        }
        Database.SaveResult[] dealTrackInsertResult = Database.insert(lstDealTgpShare,false);        
    }
    
    public void CheckAccessOfDealTrackDelete(List<Deal_Track__c> lstOldDealTrack) {
        
        Deal_Track__Share dealTrackShare;
        Set<Id> deleteDelIds = new Set<Id>();
        List<Deal_Track__c> deleteDelTrack = new List<Deal_Track__c>();
        List<Deal_Track__Share> lstDeleteDealTrackSare = new List<Deal_Track__Share>();
        deleteDelTrack=[select id,Name,Deal__c from Deal_Track__c where id IN : lstOldDealTrack]; 
        for(Deal_Track__c dtList : deleteDelTrack){
            deleteDelIds.add(dtList.Id);
        }
        List<Deal_Track__Share> lstDeleteDealTgpTrackShare = [Select ParentId,UserOrGroupId,AccessLevel from Deal_Track__Share 
        where ParentId IN: deleteDelIds limit 10000];
        Database.DeleteResult[] dealTgpInsertResult = Database.delete(lstDeleteDealTgpTrackShare,false);
    }
/*--------------------------------------------------------------------
Description : Access management for Deal Location 

----------------------------------------------------------------------*/
    public void CheckAccessDealLocation(List<Deal_Location__c> lstSObj)
    {
        Set<Id> waveVersionId = new Set<Id>();
        List<Deal_Location__c> lstSObjSFDCUser = new List<Deal_Location__c>();
        lstSObjSFDCUser=[select id,Deployment_Lead_New__r.SFDC_User__c,
        Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c, Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c, Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c,Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c, Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__c from Deal_Location__c where id IN:lstSObj limit 10000];
        for(Deal_Location__c dealLocPassed : lstSObj){
            waveVersionId.add(dealLocPassed.Wave_Plan_Version__c);
        }
        List<Wave_Plan_Version__c> wavePlanVerList = [Select Deal__c from Wave_Plan_Version__c where Id IN: waveVersionId limit 10000];
        set<Id> dealIdList = new Set<Id>();
        for(Wave_Plan_Version__c wavVerPassed : wavePlanVerList){
            dealIdList.add(wavVerPassed.Deal__c);
        } 
        List<UserList> lstUserList = new List<UserList>();
        UserList ulist; 
        for(Deal_Location__c dealLoc : lstSObjSFDCUser)
        {
            ulist= new UserList();
            ulist.userId = dealLoc.Deployment_Lead_New__r.SFDC_User__c;
            ulist.accessLevel= UTIL_Constants.EDIT;
            lstUserList.add(ulist);
            
            ulist= new UserList();
            ulist.userId = dealLoc.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c;
            ulist.accessLevel= UTIL_Constants.EDIT;
            lstUserList.add(ulist);
 
            ulist= new UserList();
            ulist.userId = dealLoc.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c;
            ulist.accessLevel= UTIL_Constants.EDIT;
            lstUserList.add(ulist);
                                         
            ulist= new UserList();
            ulist.userId = dealLoc.Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c;
            ulist.accessLevel= UTIL_Constants.EDIT;
            lstUserList.add(ulist);            
            
            ulist= new UserList();
            ulist.userId = dealLoc.Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c;
            ulist.accessLevel= UTIL_Constants.EDIT;
            lstUserList.add(ulist);            
            
            ulist= new UserList();
            ulist.userId = dealLoc.Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__c;
            ulist.accessLevel= UTIL_Constants.EDIT;
            lstUserList.add(ulist);      
        }        
        
        Deal_TGP__Share dealShareLeads;
        List<Deal_TGP__Share> lstDealTgpShare = new List<Deal_TGP__Share>();
        for(Deal_Location__c dealLoc : lstSObj)
        {
            for(UserList tmpUser : lstUserList)
            {
                for(Id dealId :dealIdList){
                    if(tmpUser.userId != null && tmpUser.accessLevel != null)
                    {
                         dealShareLeads= new Deal_TGP__Share();
                         dealShareLeads.ParentId = dealId;
                         dealShareLeads.UserOrGroupId = tmpUser.userId;
                         dealShareLeads.AccessLevel = tmpUser.accessLevel;
                         dealShareLeads.RowCause = UTIL_Constants.MANUAL;
                         lstdealTgpShare.add(dealShareLeads);
                    }
                }
            } 
        }
        Database.SaveResult[] dealLocInsertResult = Database.insert(lstDealTgpShare,false);
       //523 commented for Go-Live Plan 101 SOQL queries issue 
        updateDealTrackAccess();
    }
    
/*--------------------------------------------------------------------
Description : Access management for Deal Location Delete shared data

----------------------------------------------------------------------*/ 
public void CheckAccessDealLocationDelete(List<Deal_Location__c> lstSObjOld)
    {
        boolean isPresent = false;
        Set<Id> roleIds = new Set<Id>();
        Set<Id> waveVersionId = new Set<Id>();
        Set<Id> dealLocId = new Set<Id>();
        Set<Id> userMasterId=new Set<ID>();
        Set<String> userAssignedMURASet = new set<String>();
        Set<String> userAssignedSecMURASet = new set<String>();
        Set<String> deploymentLeadDLSet = new set<String>();
        Set<String> locMobLeadSecDLSet = new set<String>();
        Set<String> locMobLeadSec2DLSet = new set<String>();        
        Set<String> mobRecrLeadPrimaryDLSet = new set<String>();
        Set<String> mobRecrLeadsecDLSet = new set<String>();
        Set<String> mobRecrLeadsec2DLSet = new set<String>();        
        List<Deal_Location__c> lstSObjOldSFDCUser= new List<Deal_Location__c>();
       /* lstSObjOldSFDCUser=[select id,Wave_Plan_Version__c,Deployment_Lead_New__r.SFDC_User__c,Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c,Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c,Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c from Deal_Location__c where id IN : lstSObjOld];
        for(Deal_Location__c dealloc : lstSObjOldSFDCUser)
        { 
            waveVersionId.add(dealloc.Wave_Plan_Version__c);
            dealLocId.add(dealLoc.id);
            roleIds.add(dealloc.Deployment_Lead_New__r.SFDC_User__c);
            roleIds.add(dealloc.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c);
            roleIds.add(dealloc.Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c);
            roleIds.add(dealloc.Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c);
            
        }
        */
       for(Deal_Location__c dealloc : lstSObjOld)
        { 
            waveVersionId.add(dealloc.Wave_Plan_Version__c);
            dealLocId.add(dealLoc.id);
            userMasterId.add(dealloc.Deployment_Lead_New__c);
            userMasterId.add(dealloc.Location_Mobilization_Lead_Secondary_New__c);
            userMasterId.add(dealloc.Location_Mobilization_Lead_Secondary_2__c);
            userMasterId.add(dealloc.Mob_Recruitment_Lead_Primary_New__c);
            userMasterId.add(dealloc.Mob_Recruitment_Lead_Secondary_New__c);
            userMasterId.add(dealloc.Mob_Recruitment_Lead_Secondary_New_2__c);
            
        }
        List<Review_User_Master__c> revUserMaster =[Select UserName__c,SFDC_User__c from Review_User_Master__c where id in : userMasterId limit 10000]; 
        for(Review_User_Master__c revUser : revUserMaster){ 
            roleIds.add(revUser.SFDC_User__c);
        }
        List<Wave_Plan_Version__c> wavePlanVerList = [Select Deal__c from Wave_Plan_Version__c where Id IN: waveVersionId limit 10000];
        set<Id> dealIdList = new Set<Id>();
        for(Wave_Plan_Version__c wavVerPassed : wavePlanVerList){
            dealIdList.add(wavVerPassed.Deal__c);
        }
        List<MOB_User_Role_Assignment__c> lstUserRoleAssignAll = [select User_Assigned_New__c,User_Assigned_New__r.SFDC_User__c,
                                                                  User_Assigned_Secondary_New__c, User_Assigned_Secondary_New__r.SFDC_User__c,
                                                                  User_Assigned_Secondary_Lead__c, User_Assigned_Secondary_Lead__r.SFDC_User__c  
                                                                  from MOB_User_Role_Assignment__c where (User_Assigned_New__r.SFDC_User__c = :roleIds or User_Assigned_Secondary_New__r.SFDC_User__c=:roleIds or User_Assigned_Secondary_Lead__r.SFDC_User__c=:roleIds) and (Deal__c in : dealIdList) limit 10000];
        
        for(MOB_User_Role_Assignment__c tempMBUA : lstUserRoleAssignAll) {
            if(String.isNotEmpty(tempMBUA.User_Assigned_New__r.SFDC_User__c)) {
                userAssignedMURASet.add(tempMBUA.User_Assigned_New__r.SFDC_User__c);
            }
            if(String.isNotEmpty(tempMBUA.User_Assigned_Secondary_New__r.SFDC_User__c)) {
                userAssignedSecMURASet.add(tempMBUA.User_Assigned_Secondary_New__r.SFDC_User__c);
            }
            if(String.isNotEmpty(tempMBUA.User_Assigned_Secondary_Lead__r.SFDC_User__c)) {
                userAssignedSecMURASet.add(tempMBUA.User_Assigned_Secondary_Lead__r.SFDC_User__c);
            }
            
        }                                           
        
        Set<Id> roleIdsToDelete = new Set<Id>();
        
        for(Id tmpId : roleIds)
        {
            if(tmpId != null) { 
                if(userAssignedMURASet.contains(tmpId) || userAssignedSecMURASet.contains(tmpId)) {
                     roleIdsToDelete.remove(tmpId);
                }
                else {
                    roleIdsToDelete.add(tmpId);
                }                              
           }                                     
        }
        
        //Hareesh
        List<Wave_Planning__c> lstAllWavePlan = [select id,Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c, Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c, Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c,
                                                 Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c, Mob_Technology_Lead_Secondary_New__r.SFDC_User__c, Mob_Technology_Lead_Secondary_2__r.SFDC_User__c,
                                                 KT_Lead_New__r.SFDC_User__c, Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c, Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c  from Wave_Planning__c where 
                                                (Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c= :roleIds or Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c= :roleIds or Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c= :roleIds or 
                                                 Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c= :roleIds or Mob_Technology_Lead_Secondary_New__r.SFDC_User__c= :roleIds or Mob_Technology_Lead_Secondary_2__r.SFDC_User__c= :roleIds or 
                                                 KT_Lead_New__r.SFDC_User__c= :roleIds or Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c= :roleIds or Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c= :roleIds) and (deal_location__r.Wave_Plan_Version__c in :waveVersionId) limit 10000];

        Map<String,Wave_Planning__c> mobOpexLeadPrimaryWPMap = new Map<String,Wave_Planning__c>();
        Map<String,Wave_Planning__c> mobOpexLeadSecondaryWPMap = new Map<String,Wave_Planning__c>();
        Map<String,Wave_Planning__c> mobOpexLeadSecondary2WPMap = new Map<String,Wave_Planning__c>();        
        Map<String,Wave_Planning__c> mobTechnologyLeadPrimaryWPMap = new Map<String,Wave_Planning__c>();
        Map<String,Wave_Planning__c> mobTechnologyLeadSecondaryWPMap = new Map<String,Wave_Planning__c>();
        Map<String,Wave_Planning__c> mobTechnologyLeadSecondary2WPMap = new Map<String,Wave_Planning__c>();        
        Map<String,Wave_Planning__c> kTLeadWPMap = new Map<String,Wave_Planning__c>();
        Map<String,Wave_Planning__c> mobKTLeadSecondaryWPMap = new Map<String,Wave_Planning__c>();
        Map<String,Wave_Planning__c> mobKTLeadSecondary2WPMap = new Map<String,Wave_Planning__c>();
        
        
         
        for(Wave_Planning__c tempWavePlan: lstAllWavePlan) {
            if(String.isNotEmpty(tempWavePlan.Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c)) {
                mobOpexLeadPrimaryWPMap.put(tempWavePlan.Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c,tempWavePlan);
            }
            if(String.isNotEmpty(tempWavePlan.Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c)) {
                mobOpexLeadSecondaryWPMap.put(tempWavePlan.Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c,tempWavePlan);
            }
            if(String.isNotEmpty(tempWavePlan.Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c)) {
                mobOpexLeadSecondary2WPMap.put(tempWavePlan.Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c,tempWavePlan);
            }

            if(String.isNotEmpty(tempWavePlan.Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c)) {
                mobTechnologyLeadPrimaryWPMap.put(tempWavePlan.Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c,tempWavePlan);
            }
            if(String.isNotEmpty(tempWavePlan.Mob_Technology_Lead_Secondary_New__r.SFDC_User__c)) {
                mobTechnologyLeadSecondaryWPMap.put(tempWavePlan.Mob_Technology_Lead_Secondary_New__r.SFDC_User__c,tempWavePlan);
            }
            if(String.isNotEmpty(tempWavePlan.Mob_Technology_Lead_Secondary_2__r.SFDC_User__c)) {
                mobTechnologyLeadSecondary2WPMap.put(tempWavePlan.Mob_Technology_Lead_Secondary_2__r.SFDC_User__c,tempWavePlan);
            }
            if(String.isNotEmpty(tempWavePlan.KT_Lead_New__r.SFDC_User__c)) {
                kTLeadWPMap.put(tempWavePlan.KT_Lead_New__r.SFDC_User__c,tempWavePlan);
            }
            if(String.isNotEmpty(tempWavePlan.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c)) {
                mobKTLeadSecondaryWPMap.put(tempWavePlan.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c,tempWavePlan);
            }
            if(String.isNotEmpty(tempWavePlan.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c)) {
                mobKTLeadSecondary2WPMap.put(tempWavePlan.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c,tempWavePlan);
            }

        }                                            
        for(Id tmpId : roleIds)
        {
            if(tmpId != null) {
            //Harish commented code 
            /*    List<Wave_Planning__c> lstWavePlan = [select id from Wave_Planning__c where 
                                                    (Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c= :tmpId or  Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c= :tmpId or 
                                                    Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c= :tmpId or   Mob_Technology_Lead_Secondary_New__r.SFDC_User__c= :tmpId or 
                                                    KT_Lead_New__r.SFDC_User__c= :tmpId or   Mobilization_KT_Lead_Secondary__c= :tmpId) and (deal_location__r.Wave_Plan_Version__c in :waveVersionId)];
            
                if(lstWavePlan.size()>0)
                {
                    roleIdsToDelete.remove(tmpId);
                }
                else if(lstWavePlan.size()==0 && CheckIdInSet(tmpId,roleIdsToDelete)==false)                                                
                {
                    roleIdsToDelete.add(tmpId);
                } */ 
                if(mobOpexLeadPrimaryWPMap.containsKey(tmpId) || mobOpexLeadSecondaryWPMap.containsKey(tmpId) || mobOpexLeadSecondary2WPMap.containsKey(tmpId) || mobTechnologyLeadPrimaryWPMap.containsKey(tmpId) || 
                    mobTechnologyLeadSecondaryWPMap.containsKey(tmpId) ||  mobTechnologyLeadSecondary2WPMap.containsKey(tmpId) || kTLeadWPMap.containsKey(tmpId) || mobKTLeadSecondaryWPMap.containsKey(tmpId)|| mobKTLeadSecondary2WPMap.containsKey(tmpId)) {  
                    roleIdsToDelete.remove(tmpId);
                }
                /*else if(CheckIdInSet(tmpId,roleIdsToDelete)==false)  {
                    roleIdsToDelete.add(tmpId);
                }*/                                        
                                                
           }                                     
        }
        List<Deal_Location__c> lstDealLocALL = [select id,Deployment_Lead_New__r.SFDC_User__c, Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c, Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c, Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c,
                                                    Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c, Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__c from deal_location__c where 
                                                    (Deployment_Lead_New__r.SFDC_User__c in : roleIds or Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c in : roleIds or Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c  in : roleIds or
                                                    Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c in : roleIds or Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c in : roleIds or Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__c in : roleIds) 
                                                    and (Wave_Plan_Version__c in : waveVersionId ) and (id not in :dealLocId) limit 10000];
        for(Deal_Location__c tempDL : lstDealLocALL) {
            if(String.isNotEmpty(tempDL.Deployment_Lead_New__r.SFDC_User__c)) {
                deploymentLeadDLSet.add(tempDL.Deployment_Lead_New__r.SFDC_User__c);
            }
            if(String.isNotEmpty(tempDL.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c)) {
                locMobLeadSecDLSet.add(tempDL.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c);
            }
            if(String.isNotEmpty(tempDL.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c)) {
                locMobLeadSec2DLSet.add(tempDL.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c);
            }

            if(String.isNotEmpty(tempDL.Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c)) {
                mobRecrLeadPrimaryDLSet.add(tempDL.Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c);
            }
            if(String.isNotEmpty(tempDL.Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c)) {
                mobRecrLeadsecDLSet.add(tempDL.Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c);
            }
            if(String.isNotEmpty(tempDL.Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__c)) {
                mobRecrLeadsec2DLSet.add(tempDL.Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__c);
            }
            
        }                                            
        for(Id tmpId : roleIds)
        {
            if(tmpId != null)
            { // Hareesh commented code
                /*
                List<Deal_Location__c> lstDealLoc = [select id from deal_location__c where 
                                                    (Deployment_Lead_New__r.SFDC_User__c= :tmpId or Location_Mobilization_Lead_Secondary__c = :tmpId or
                                                    Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c=:tmpId or Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c = :tmpId) 
                                                    and (Wave_Plan_Version__c in : waveVersionId ) and (id not in :dealLocId) ];
                if(lstDealLoc.size()>0)
                {
                    roleIdsToDelete.remove(tmpId);
                }
                else if(lstDealLoc.size()==0 && CheckIdInSet(tmpId,roleIdsToDelete)==false)                                                
                {
                    roleIdsToDelete.add(tmpId);
                } */
                if(deploymentLeadDLSet.contains(tmpId) || locMobLeadSecDLSet.contains(tmpId) || locMobLeadSec2DLSet.contains(tmpId) || mobRecrLeadPrimaryDLSet.contains(tmpId) || mobRecrLeadsecDLSet.contains(tmpId)|| mobRecrLeadsec2DLSet.contains(tmpId)) {
                    roleIdsToDelete.remove(tmpId);
                }
              /*  else if(CheckIdInSet(tmpId,roleIdsToDelete)==false) {
                    roleIdsToDelete.add(tmpId);
                }*/
            }                                   
        }
        
        List<Deal_TGP__Share> lstDealTgpSharedelete = [Select ParentId,UserOrGroupId from Deal_TGP__Share where ParentId IN: dealIdList AND 
        UserOrGroupId IN: roleIdsToDelete AND RowCause =: UTIL_Constants.MANUAL limit 10000];
        Set<Id> pId=new Set<Id>();
        for(Deal_TGP__Share parentList : lstDealTgpSharedelete){
            pId.add(parentList.ParentId);
        }
        List<Deal_Track__c> dealTrackList=[select id from Deal_Track__c where Deal__c IN : pId];
        CheckAccessOfDealTrackDelete(dealTrackList);
        Database.DeleteResult[] dealTgpInsertResult = Database.delete(lstDealTgpSharedelete,false);
    }   

    
//END

/*
Description : Access management for Deal Wave (Wave Planning__c)

*/
    public void CheckAccessDealWave(List<Wave_Planning__c> lstSObj)
    {
    
        Set<Id> dealLocId = new Set<Id>();
        
        list<Wave_Planning__c> listOfWavePlan=new list<Wave_Planning__c>();
        listOfWavePlan=[select id,Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c,Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c,
                        Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c, KT_Lead_New__r.SFDC_User__c,
                        Mob_Technology_Lead_Secondary_New__r.SFDC_User__c,Mob_Technology_Lead_Secondary_2__r.SFDC_User__c, 
                        Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c,Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c, 
                        Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c from Wave_Planning__c where id IN: lstSObj limit 10000];
        
        
        
        
        for(Wave_Planning__c wavePlanPassed : lstSObj){
            dealLocId.add(wavePlanPassed.Deal_Location__c);
        }
        List<Deal_Location__c> dealLocList = [select Wave_Plan_Version__c,Wave_Plan_Version__r.Deal__c from Deal_Location__c 
        where Id IN: dealLocId limit 10000];
        Set<Id> waveVersionId = new Set<Id>();
        //set<Id> dealIdList = new Set<Id>();
        Id dealIdRec;
        for(Deal_Location__c dealLocPassed : dealLocList){
            waveVersionId.add(dealLocPassed.Wave_Plan_Version__c);
            //dealIdList.add(dealLocPassed.Wave_Plan_Version__r.Deal__c);
            dealIdRec = dealLocPassed.Wave_Plan_Version__r.Deal__c;
        }
        /*List<Wave_Plan_Version__c> wavePlanVerList = [Select Deal__c from Wave_Plan_Version__c where Id IN: waveVersionId];
        set<Id> dealIdList = new Set<Id>();
        for(Wave_Plan_Version__c wavVerPassed : wavePlanVerList){
            dealIdList.add(wavVerPassed.Deal__c);
        }*/
        //List<UserList> lstUserList = new List<UserList>();
        List<UserList> lstUserList = new List<UserList>();
        UserList ulist; 
        for(Wave_Planning__c wavePlan : listOfWavePlan)
        {
            ulist= new UserList();
            ulist.userId = wavePlan.Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c;
            ulist.accessLevel = UTIL_Constants.EDIT;
            lstUserList.add(ulist);
            
            ulist= new UserList();
            ulist.userId = wavePlan.Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c;
            ulist.accessLevel= UTIL_Constants.EDIT;
            lstUserList.add(ulist);            
            
            ulist= new UserList();
            ulist.userId = wavePlan.Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c;
            ulist.accessLevel= UTIL_Constants.EDIT;
            lstUserList.add(ulist);            
            
            ulist= new UserList();
            ulist.userId = wavePlan.Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c;
            ulist.accessLevel= UTIL_Constants.EDIT;
            lstUserList.add(ulist);            
            
            ulist= new UserList();
            ulist.userId = wavePlan.Mob_Technology_Lead_Secondary_New__r.SFDC_User__c;
            ulist.accessLevel= UTIL_Constants.EDIT;
            lstUserList.add(ulist);
            
            ulist= new UserList();
            ulist.userId = wavePlan.Mob_Technology_Lead_Secondary_2__r.SFDC_User__c;
            ulist.accessLevel= UTIL_Constants.EDIT;
            lstUserList.add(ulist);
            
            ulist= new UserList();
            ulist.userId = wavePlan.KT_Lead_New__r.SFDC_User__c;
            ulist.accessLevel= UTIL_Constants.EDIT;
            lstUserList.add(ulist);
            
            ulist= new UserList();
            ulist.userId = wavePlan.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c;
            ulist.accessLevel= UTIL_Constants.EDIT;
            lstUserList.add(ulist);            
            
            ulist= new UserList();
            ulist.userId = wavePlan.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c;
            ulist.accessLevel= UTIL_Constants.EDIT;
            lstUserList.add(ulist);                        
        }        
        
        
        Deal_TGP__Share dealShareLeads;
        List<Deal_TGP__Share> lstDealTgpShare = new List<Deal_TGP__Share>();
        
        //for(Wave_Planning__c wavePlan : lstSObj)
        //{
        
            for(UserList tmpUser : lstUserList)
            {
                //for(Id dealId :dealIdList){
                    //system.debug('-----dealIdList-----'+dealIdList);
                    if(tmpUser.userId != null && tmpUser.accessLevel != null)
                    {
                         dealShareLeads= new Deal_TGP__Share();
                         //dealShareLeads.ParentId = dealId;
                         dealShareLeads.ParentId = dealIdRec;
                         dealShareLeads.UserOrGroupId = tmpUser.userId;
                         dealShareLeads.AccessLevel = tmpUser.accessLevel;
                         dealShareLeads.RowCause = UTIL_Constants.MANUAL;
                         lstdealTgpShare.add(dealShareLeads);
                     }
                // }
            } 
        //}
        
        
        
        Database.SaveResult[] wavePlanInsertResult = Database.insert(lstDealTgpShare,false);
        updateDealTrackAccess();
}

/*--------------------------------------------------------------------
Description : Access management for Deal Wave Delete shared data

----------------------------------------------------------------------*/ 
public void CheckAccessDealWaveDelete(List<Wave_Planning__c> lstSObjOld)
    {
        
        boolean isPresent = false;

        Set<Id> dealLocId = new Set<Id>();
        Set<Id> dealWaveId = new  Set<Id>();
        Set<Id> userMasterId=new Set<ID>();
        for(Wave_Planning__c tmpWave : lstSObjOld)
        {
            dealLocId.add(tmpWave.Deal_Location__c);
            dealWaveId.add(tmpWave.id);
            userMasterId.add(tmpWave.Mobilization_Opex_Lead_Primary_New__c);
            userMasterId.add(tmpWave.Mobilization_Opex_Lead_Secondary_New__c);
            userMasterId.add(tmpWave.Mobilization_Opex_Lead_Secondary_2__c);            
            userMasterId.add(tmpWave.Mobilization_Technology_Lead_Primary_New__c);
            userMasterId.add(tmpWave.Mob_Technology_Lead_Secondary_New__c);
            userMasterId.add(tmpWave.Mob_Technology_Lead_Secondary_2__c);            
            userMasterId.add(tmpWave.KT_Lead_New__c);
            userMasterId.add(tmpWave.Mobilization_KT_Lead_Secondary_New__c);
            userMasterId.add(tmpWave.Mobilization_KT_Lead_Secondary_2__c);            
        }

        List<Deal_Location__c> dealLocList = [select Wave_Plan_Version__c,Wave_Plan_Version__r.Deal__c from Deal_Location__c 
        where Id IN: dealLocId limit 10000];
        Set<Id> waveVersionId = new Set<Id>();
        set<Id> dealIdList = new Set<Id>();
        for(Deal_Location__c dealLocPassed : dealLocList){
            waveVersionId.add(dealLocPassed.Wave_Plan_Version__c);
            dealIdList.add(dealLocPassed.Wave_Plan_Version__r.Deal__c);
        }
        /*List<Wave_Plan_Version__c> wavePlanVerList = [Select Deal__c from Wave_Plan_Version__c where Id IN: waveVersionId];
        set<Id> dealIdList = new Set<Id>();
        for(Wave_Plan_Version__c wavVerPassed : wavePlanVerList){
            dealIdList.add(wavVerPassed.Deal__c);
        }*/
        Set<Id> roleIds = new Set<Id>();    
    
    List<Review_User_Master__c> revUserMaster =[Select UserName__c,SFDC_User__c from Review_User_Master__c 
        where id in : userMasterId limit 10000];    
        for(Review_User_Master__c revUser : revUserMaster){
        
            roleIds.add(revUser.SFDC_User__c);
        
        }
    for(Wave_Planning__c wavePlanPassed : lstSObjOld){
        
            dealLocId.add(wavePlanPassed.Deal_Location__c);
        }

        Set<Id> roleIdsToDelete = new Set<Id>();
        
        List<MOB_User_Role_Assignment__c> lstUserRoleAssign = [select User_Assigned_New__c,User_Assigned_New__r.SFDC_User__c,
                                                               User_Assigned_Secondary_New__c, User_Assigned_Secondary_New__r.SFDC_User__c,
                                                               User_Assigned_Secondary_Lead__c, User_Assigned_Secondary_Lead__r.SFDC_User__c from MOB_User_Role_Assignment__c where Deal__c in : dealIdList limit 10000];
        
        for(Id tmpId : roleIds)
        {
          if(tmpId != null)
            {
                Integer Count = 0;
          for(MOB_User_Role_Assignment__c userRoleAssign: lstUserRoleAssign )
          {
             if(userRoleAssign.User_Assigned_New__r.SFDC_User__c == tmpId || 
             userRoleAssign.User_Assigned_Secondary_New__r.SFDC_User__c == tmpId || userRoleAssign.User_Assigned_Secondary_Lead__r.SFDC_User__c == tmpId)
             {
                Count++;
             }
          }
          if(Count >0)
                {
                    roleIdsToDelete.remove(tmpId);
                }
                else if(Count==0)                                                
                {
                    roleIdsToDelete.add(tmpId);
                } 
                else{}
           }                                     
        }
        
        List<Deal_Location__c> lstDealLoc = [select id,Deployment_Lead_New__r.SFDC_User__c, Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c,Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c,
                                             Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c, Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c ,Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__c
                                             from deal_location__c where Wave_Plan_Version__c in : waveVersionId limit 10000];
        
        for(Id tmpId : roleIds)
        {
          if(tmpId != null)
            {
                Integer Count = 0;
          for(Deal_Location__c dealLoc: lstDealLoc )
          {
             if(dealLoc.Deployment_Lead_New__r.SFDC_User__c == tmpId || 
             dealLoc.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c == tmpId || dealLoc.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c == tmpId ||
             
                dealLoc.Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c == tmpId || 
                dealLoc.Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c == tmpId || dealLoc.Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__c == tmpId)
             {
                Count++;
             }
          }
          if(Count >0)
                {
                    roleIdsToDelete.remove(tmpId);
                }
              /*  else if(Count==0 && CheckIdInSet(tmpId,roleIdsToDelete)==false)                                                
                {
                    roleIdsToDelete.add(tmpId);
                }  */                              
           }                                     
        }
        
        List<Wave_Planning__c> lstWavePlan = [select id, Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c, Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c,Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c, 
                                              Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c, Mob_Technology_Lead_Secondary_New__r.SFDC_User__c, Mob_Technology_Lead_Secondary_2__r.SFDC_User__c,
                                              KT_Lead_New__r.SFDC_User__c, Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c , Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c
                                              from Wave_Planning__c where (deal_location__r.Wave_Plan_Version__c in :waveVersionId) and (id not in : dealWaveId) limit 10000];
        
        for(Id tmpId : roleIds)
        {
          if(tmpId != null)
            {
                Integer Count = 0;
          for(Wave_Planning__c wavePlan: lstWavePlan )
          {
             if(wavePlan.Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c == tmpId || 
             wavePlan.Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c == tmpId ||
              wavePlan.Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c == tmpId ||  
                wavePlan.Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c == tmpId || 
                wavePlan.Mob_Technology_Lead_Secondary_New__r.SFDC_User__c == tmpId || 
                wavePlan.Mob_Technology_Lead_Secondary_2__r.SFDC_User__c == tmpId || 
                wavePlan.KT_Lead_New__r.SFDC_User__c == tmpId || wavePlan.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c == tmpId|| wavePlan.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c == tmpId)
             {
                Count++;
             }
          }
          if(Count >0)
                {
                    roleIdsToDelete.remove(tmpId);
                }
             /*   else if(Count==0 && CheckIdInSet(tmpId,roleIdsToDelete)==false)                                                
                {
                    roleIdsToDelete.add(tmpId);
                }   */                                 
           }                                     
        }
        
        List<Deal_TGP__Share> lstDealTgpSharedelete = [Select ParentId,UserOrGroupId from Deal_TGP__Share where ParentId IN: dealIdList 
        AND UserOrGroupId IN: roleIdsToDelete AND RowCause =: UTIL_Constants.MANUAL limit 10000];
        Set<Id> pId=new Set<Id>();
        for(Deal_TGP__Share parentList : lstDealTgpSharedelete){
            pId.add(parentList.ParentId);
        }
        List<Deal_Track__c> dealTrackList=[select id from Deal_Track__c where Deal__c IN : pId limit 10000];
        CheckAccessOfDealTrackDelete(dealTrackList);
        Database.DeleteResult[] dealTgpInsertResult = Database.delete(lstDealTgpSharedelete,false);
    }    

    public void updateDealTrackAccess(){
        Set<Id> dealIdList = new Set<Id>();
        Set<Id> dealTrackIdList = new Set<Id>();
        Map<Id,set<Id>>  dealShareMap = new Map<Id,set<Id>> ();
        Map<Id,set<Id>>  trackShareMap = new Map<Id,set<Id>> ();
        set<Id> tempIdList = new set<Id>();
        Map<Id,Id> dealAndTrackMap = new Map<Id,Id>();
        
        for(Deal_Track__c dt :[Select Deal__c From Deal_Track__c Where Wave_Plan_Version__r.Active__c = true limit 10000]) {
            dealIdList.add(dt.Deal__c);
            dealTrackIdList.add(dt.Id);
            dealAndTrackMap.put(dt.Deal__c,dt.Id);
        }
        
        List<Deal_TGP__Share > dealShareRecList = [Select UserOrGroupId, ParentId From Deal_TGP__Share Where ParentId IN :dealIdList limit 10000];
        
        List<Deal_Track__Share > trackShareRecList = [Select UserOrGroupId, ParentId From Deal_Track__Share Where ParentId IN :dealTrackIdList limit 10000];
        
        
        for(Deal_TGP__Share dealShare : dealShareRecList) {
            if(dealShareMap.containsKey(dealShare.ParentId)) {
                tempIdList = dealShareMap.get(dealShare.ParentId);
            }
            else {
                tempIdList = new set<Id>();
            }
            tempIdList.add(dealShare.UserOrGroupId);
            dealShareMap.put(dealShare.ParentId,tempIdList);
        }
        for(Deal_Track__Share trackShare : trackShareRecList) {
            if(trackShareMap.containsKey(trackShare.ParentId)) {
                tempIdList = trackShareMap.get(trackShare.ParentId);
            }
            else {
                tempIdList = new set<Id>();
            }
            tempIdList.add(trackShare.UserOrGroupId);
            trackShareMap.put(trackShare.ParentId,tempIdList);
        }
        
        List<Id> userList = new List<Id>();
        Map<Id,set<Id>> dealTrackUserIdMap = new Map<Id,set<Id>>();
        tempIdList = new set<Id>();
        Set<Id> dIdList = new set<Id>();
        Set<Id> tIdList  = new set<Id>();
        for(Id dealId : dealIdList) {
            if(dealShareMap.containsKey(dealId)) {
                dIdList = dealShareMap.get(dealId);
            }
            if(dealAndTrackMap.containsKey(dealId)) {
                if(trackShareMap.containsKey(dealAndTrackMap.get(dealId))) {
                    tIdList = trackShareMap.get(dealAndTrackMap.get(dealId));
                }
            }
            for(Id tmpId : dIdList) {
                if(!tIdList.contains(tmpId)) {
                    userList.add(tmpId);
                    if(dealTrackUserIdMap.containsKey(dealAndTrackMap.get(dealId))) {
                        tempIdList = dealTrackUserIdMap.get(dealAndTrackMap.get(dealId));
                    }
                    else {
                        tempIdList = new set<Id>();
                    }
                    tempIdList.add(tmpId);
                    dealTrackUserIdMap.put(dealAndTrackMap.get(dealId),tempIdList);
                }
            }
            
        }
        system.debug('Number of User---->'+userList.size());
        system.debug(dealTrackUserIdMap);
        //Get the Active User Info
        List<Id> activeUserList = new List<Id>();
        Map<Id,boolean> userIsActive = new Map<Id,boolean>();
        if(!userList.isEmpty()) {
            Profile p = [Select id from Profile where Name = 'Workbench User' OR Name='IS Workbench User' limit 1];
            for(User usr:[Select IsActive ,profileid From User Where Id IN : userList and profileid =: p.id limit 10000]) {
                userIsActive.put(usr.Id,usr.IsActive);
                if(usr.IsActive) {
                    activeUserList.add(usr.Id);
                }
            }
            system.debug('number of active user------->'+activeUserList.size());
            //system.debug('User Status-->'+userIsActive);
            system.debug('Active user list--->'+activeUserList);
            List<Deal_Track__Share> insertTrackList = new List<Deal_Track__Share> ();
            Deal_Track__Share trackRec;
            Set<Id>IdList = new set<Id>();
            tempIdList = new set<Id>();
            IdList = dealTrackUserIdMap.keySet();
            system.debug('Effected Deal Track Count---->'+IdList.size());
            if(!IdList.isEmpty()) {
                for(Id trackId : IdList) {
                    if(dealTrackUserIdMap.containsKey(trackId)) {
                        tempIdList = dealTrackUserIdMap.get(trackId);
                        for(Id usrId : tempIdList) {
                            if(userIsActive.containsKey(usrId)) {
                                if(userIsActive.get(usrId)) {
                                    trackRec = new Deal_Track__Share();
                                    trackRec.ParentId = trackId;
                                    trackRec.UserOrGroupId = usrId;
                                    trackRec.AccessLevel = 'Read';
                                    trackRec.RowCause = 'Manual';
                                    insertTrackList.add(trackRec);
                                    system.debug('Deal Track--->'+trackId +' User Id--->'+usrId);
                                }
                            }
                        }
                    }
                }
            }
            system.debug('Total record need to Insert--->'+insertTrackList.size());
            if(!insertTrackList.isEmpty()) {
                Database.insert(insertTrackList); 
            }
        }
        
    }
//END

//========================================    MOB UAM Ends    ==============================================    
    
//========================================    SOL UAM Starts    ==============================================    
    /*-------------------------------------------------------
    Description : Access management for Opportunity
    ---------------------------------------------------------*/
     
    public void CheckAccessOpportunity(List<Opportunity_TGP__c> lstSObj)
    {
        //CheckAccessOpportunityDelete(lstSObj);
        List<UserList> lstUserList = new List<UserList>();
        UserList ulist; 
        List<Opportunity_TGP__c> listOpportunity = new List<Opportunity_TGP__c>();
        listOpportunity = [select Enterprise_Solution_Architect_New__r.SFDC_User__c/*, BSS_Operation_New__r.SFDC_User__c, Analytics_Solution_Lead__r.SFDC_User__c, Complex_Cost_Architect_New__r.SFDC_User__c*/ from Opportunity_TGP__c where ID IN :lstSObj limit 10000];
        for(Opportunity_TGP__c oppTGP : listOpportunity)
        {
            ulist= new UserList();
            ulist.userId = oppTGP.Enterprise_Solution_Architect_New__r.SFDC_User__c;
            ulist.accessLevel= UTIL_Constants.EDIT;
            lstUserList.add(ulist);
            
            /*ulist= new UserList();
            ulist.userId = oppTGP.BSS_Operation_New__r.SFDC_User__c;
            ulist.accessLevel= 'edit';
            lstUserList.add(ulist);            
            
            ulist= new UserList();
            ulist.userId = oppTGP.Complex_Cost_Architect_New__r.SFDC_User__c;
            ulist.accessLevel= 'edit';
            lstUserList.add(ulist);
            
            ulist= new UserList();
            ulist.userId = oppTGP.Analytics_Solution_Lead__r.SFDC_User__c;
            ulist.accessLevel= 'edit';
            lstUserList.add(ulist);*/
        } 
        Opportunity_TGP__Share opportunityShareLeads;
        List<Opportunity_TGP__Share> lstOppTgpShare = new List<Opportunity_TGP__Share>();
        for(Opportunity_TGP__c oppTGP : lstSObj)
        {
            for(UserList tmpUser : lstUserList)
            {
                if(tmpUser.userId != null && tmpUser.accessLevel != null)
                {
                     opportunityShareLeads= new Opportunity_TGP__Share();                     
                     opportunityShareLeads.ParentId = oppTGP.Id;
                     opportunityShareLeads.UserOrGroupId = tmpUser.userId;
                     opportunityShareLeads.AccessLevel = tmpUser.accessLevel;
                     opportunityShareLeads.RowCause = UTIL_Constants.MANUAL;
                     lstOppTgpShare.add(opportunityShareLeads);
                }
            } 
        }
        Database.SaveResult[] oppTgpInsertResult = Database.insert(lstOppTgpShare,false);
    }
    
    /*-------------------------------------------------------
    Description : Access management for Opportunity Team
    ---------------------------------------------------------*/
     
    public void CheckAccessOpportunityTeam(List<Opportunity_Team__c> lstSObj)
    {
        //CheckAccessOpportunityDelete(lstSObj);
        List<UserList> lstUserList = new List<UserList>();
        UserList ulist; 
        List<Opportunity_Team__c> listOpportunityTeam = new List<Opportunity_Team__c>();
        listOpportunityTeam = [Select BPO_Opportunity__c,Offering__c,Opportunity_Team_Member__c,Opportunity_Team_Member__r.SFDC_User__c,Roles__c,Offering__r.name,Roles__r.name from Opportunity_Team__c  where ID IN :lstSObj limit 10000];
        for(Opportunity_Team__c oppTeam : listOpportunityTeam)
        {
            ulist= new UserList();
            ulist.userId = oppTeam.Opportunity_Team_Member__r.SFDC_User__c;
            ulist.accessLevel= UTIL_Constants.EDIT;
            lstUserList.add(ulist);
            
            /*ulist= new UserList();
            ulist.userId = oppTGP.BSS_Operation_New__r.SFDC_User__c;
            ulist.accessLevel= 'edit';
            lstUserList.add(ulist);            
            
            ulist= new UserList();
            ulist.userId = oppTGP.Complex_Cost_Architect_New__r.SFDC_User__c;
            ulist.accessLevel= 'edit';
            lstUserList.add(ulist);
            
            ulist= new UserList();
            ulist.userId = oppTGP.Analytics_Solution_Lead__r.SFDC_User__c;
            ulist.accessLevel= 'edit';
            lstUserList.add(ulist);*/
        } 
        Opportunity_TGP__Share opportunityTeamShareLeads;
        List<Opportunity_TGP__Share> lstOppTgpShare = new List<Opportunity_TGP__Share>();
        for(Opportunity_Team__c oppTeam : lstSObj)
        {
            for(UserList tmpUser : lstUserList)
            {
                if(tmpUser.userId != null && tmpUser.accessLevel != null)
                {
                     opportunityTeamShareLeads = new Opportunity_TGP__Share();                     
                     opportunityTeamShareLeads.ParentId = oppTeam.BPO_Opportunity__c;
                     opportunityTeamShareLeads.UserOrGroupId = tmpUser.userId;
                     opportunityTeamShareLeads.AccessLevel = tmpUser.accessLevel;
                     opportunityTeamShareLeads.RowCause = UTIL_Constants.MANUAL;
                     lstOppTgpShare.add(opportunityTeamShareLeads);
                }
            } 
        }
        Database.SaveResult[] oppTgpInsertResult = Database.insert(lstOppTgpShare,false);
    }
    
    /*--------------------------------------------------------------------
    Description : Access management for Opportunity Delete shared data
    ----------------------------------------------------------------------*/ 
    public void CheckAccessOpportunityDelete(List<Opportunity_TGP__c> lstSObjOld)
    {
        Set<Id> roleIds = new Set<Id>();
        Set<Id> oppTgpId = new Set<Id>();
        boolean isPresent = false;
      
        for(Opportunity_TGP__c oppTgp : lstSObjOld)
        { 
            roleIds.add(oppTgp.Enterprise_Solution_Architect_New__c);
            //roleIds.add(oppTgp.Complex_Cost_Architect_New__c);  
            //roleIds.add(oppTgp.BSS_Operation_New__c);          
            oppTgpId.add(oppTgp.Id);                        
        }
        Set<Id> roleIdsToDelete = new Set<Id>();
       /* for(Id tmpId : roleIds)
        {
            if(tmpId != null)
            {
                string str='select id from deal_location__c where (Deployment_Lead_New__r.SFDC_User__c= '+ tmpId +' or Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c = '+ tmpId +') and (Wave_Plan_Version__r.Deal__c in '+ oppTgpId +')';
                List<Opportunity_Offering__c> lstOffering = [select id from Opportunity_Offering__c where 
                                                    (Solution_Lead_New__c= :tmpId or Offering_Solution_Lead_Secondary_New__c = :tmpId or Solution_Specialist_New__c= :tmpId
                                                    or Technical_Architect_New__c =:tmpId    
                                                    or Domain_Expert_Functional_Architect_New__c=:tmpId or Functional_Architect_Mobilization_New__c=:tmpId) 
                                                    and (Opportunity_TGP__c in : oppTgpId) ];
                if(lstOffering.size()>0)
                {
                    isPresent = true;
                    //return;
                }
                else if(lstOffering.size()==0)                                                
                {
                    roleIdsToDelete.add(tmpId);
                }                                    
            }
        }*/
        /*List<Opportunity_Offering__c> lstOffering = [select id,Solution_Lead_New__c,Offering_Solution_Lead_Secondary_New__c,Solution_Specialist_New__c,Technical_Architect_New__c,
                                                    Domain_Expert_Functional_Architect_New__c,Functional_Architect_Mobilization_New__c from Opportunity_Offering__c where Opportunity_TGP__c in : oppTgpId];
        for(Id tmpId : roleIds)
        {
            if(tmpId != null)
            {
   
              Integer Count = 0; 
              for(Opportunity_Offering__c listOff: lstOffering )
              {
                 if(listOff.Solution_Lead_New__c == tmpId || listOff.Offering_Solution_Lead_Secondary_New__c == tmpId || listOff.Solution_Specialist_New__c == tmpId 
                    || listOff.Technical_Architect_New__c == tmpId || listOff.Domain_Expert_Functional_Architect_New__c == tmpId || listOff.Functional_Architect_Mobilization_New__c == tmpId)
                 {
                    Count++;
                 }
              }
               if(Count>0)
                {
                    isPresent = true;
                    //return;
                }
                else if(Count==0)                                                
                {
                    roleIdsToDelete.add(tmpId);
                }                                    
            }
        }
        
        if(isPresent)
            return;
        */
        if(roleIdsToDelete.size()==0)
        {
            for(Id tmpId : roleIds)
            {
                if(tmpId != null)
                {
                    roleIdsToDelete.add(tmpId );
                }
            }
        }
        List<Review_User_Master__c> reviewUserMasterRecordsList  = [select SFDC_User__c from Review_User_Master__c where ID IN:roleIdsToDelete limit 10000] ;
        Set<Id> userIDsToDeleteAccess = new set<Id>();
        for(Review_User_Master__c reviewUserMasterRecord : reviewUserMasterRecordsList) {
            userIDsToDeleteAccess.add(reviewUserMasterRecord.SFDC_User__c);
        } 
        List<Opportunity_TGP__Share> lstoppTgpSharedelete = [Select ParentId,UserOrGroupId from Opportunity_TGP__Share where 
        ParentId IN: oppTgpId AND UserOrGroupId IN: userIDsToDeleteAccess AND RowCause =:UTIL_Constants.MANUAL limit 10000];
        Database.DeleteResult[] dealTgpInsertResult = Database.delete(lstoppTgpSharedelete,false);
    }   
    //End
    
    /*--------------------------------------------------------------------
    Description : Access management for Opportunity Team Delete shared data
    ----------------------------------------------------------------------*/ 
    public void CheckAccessOpportunityTeamDelete(List<Opportunity_Team__c> lstSObjOld)
    {
        Set<Id> oppTgpId = new Set<Id>();
        Set<Id> userId = new Set<Id>();
        boolean isPresent = false;
      
        for(Opportunity_Team__c oppTeam : lstSObjOld)
        {           
            oppTgpId.add(oppTeam.BPO_Opportunity__c);
            userId.add(oppTeam.Opportunity_Team_Member__c);                        
        }
        
        
        Set<Id> userIdsToDelete = new Set<Id>();
       
        List<Opportunity_Team__c> lstOppTeam = [Select BPO_Opportunity__c,Offering__c,Opportunity_Team_Member__c,
        Opportunity_Team_Member__r.SFDC_User__c,Roles__c,Offering__r.name,Roles__r.name from Opportunity_Team__c  
        where BPO_Opportunity__c IN :oppTgpId AND Roles__c != null limit 10000];
            
        for(Id tmpId : userId)
        {
            if(tmpId != null)
            {
   
              Integer Count = 0; 
              for(Opportunity_Team__c listOff: lstOppTeam )
              {
                 if(listOff.Opportunity_Team_Member__c == tmpId )
                 {
                    Count++;
                    
                 }
              }
               if(Count>0)
                {
                    isPresent = true;
                    //return;
                }
                else if(Count==0)                                                
                {
                   
                    userIdsToDelete.add(tmpId);
                } 
                else{}
            }
        }
        
        if(isPresent && userIdsToDelete.size()==0){
            return;
        }
        if(userIdsToDelete.size()==0)
        {
            for(Id tmpId : userId)
            {
                if(tmpId != null)
                {
                    userIdsToDelete.add(tmpId );
                }
            }
        }
         
        List<Review_User_Master__c> reviewUserMasterRecordsList  = [select SFDC_User__c from Review_User_Master__c where ID IN:userIdsToDelete limit 10000] ;
        Set<Id> userIDsToDeleteAccess = new set<Id>();
        for(Review_User_Master__c reviewUserMasterRecord : reviewUserMasterRecordsList) {
            userIDsToDeleteAccess.add(reviewUserMasterRecord.SFDC_User__c);
        } 
        List<Opportunity_TGP__Share> lstoppTgpSharedelete = [Select ParentId,UserOrGroupId from Opportunity_TGP__Share 
        where ParentId IN: oppTgpId AND UserOrGroupId IN: userIDsToDeleteAccess AND RowCause =:UTIL_Constants.MANUAL limit 10000];
        Database.DeleteResult[] dealTgpInsertResult = Database.delete(lstoppTgpSharedelete,false);
    }   
    //End
    
    /*--------------------------------------------------------------------
    Description : Access management for Solution (Opportunity Offering)
    ----------------------------------------------------------------------*/
   /* public void CheckAccessOffering(List<Opportunity_Offering__c> lstSObj)
    {
        Set<Id> oppIDs = new Set<Id>();
        List<Opportunity_Offering__c> listOffering = new List<Opportunity_Offering__c>();
        listOffering = [select Solution_Lead_New__r.SFDC_User__c, Offering_Solution_Lead_Secondary_New__r.SFDC_User__c, Technical_Architect_New__r.SFDC_User__c,
                                  Domain_Expert_Functional_Architect_New__r.SFDC_User__c, Functional_Architect_Mobilization_New__r.SFDC_User__c,
                                  Solution_Specialist_New__r.SFDC_User__c from Opportunity_Offering__c where ID IN :lstSObj];
        for(Opportunity_Offering__c oppOffPassed : lstSObj){
            oppIDs.add(oppOffPassed.Opportunity_TGP__c);
        }        
        List<UserList> lstUserList = new List<UserList>();
        UserList ulist; 
        for(Opportunity_Offering__c oppOff : listOffering)
        {
            ulist= new UserList();
            ulist.userId = oppOff.Solution_Lead_New__r.SFDC_User__c;
            ulist.accessLevel= 'edit';
            lstUserList.add(ulist);
            
            ulist= new UserList();
            ulist.userId = oppOff.Offering_Solution_Lead_Secondary_New__r.SFDC_User__c;
            ulist.accessLevel= 'edit';
            lstUserList.add(ulist); 

            ulist= new UserList();
            ulist.userId = oppOff.Technical_Architect_New__r.SFDC_User__c;
            ulist.accessLevel= 'edit';
            lstUserList.add(ulist);
                
            ulist= new UserList();
            ulist.userId = oppOff.Domain_Expert_Functional_Architect_New__r.SFDC_User__c;
            ulist.accessLevel= 'read';
            lstUserList.add(ulist); 
            
            ulist= new UserList();
            ulist.userId = oppOff.Functional_Architect_Mobilization_New__r.SFDC_User__c;
            ulist.accessLevel= 'edit';
            lstUserList.add(ulist);
            
            ulist= new UserList();
            ulist.userId = oppOff.Solution_Specialist_New__r.SFDC_User__c;
            ulist.accessLevel= 'edit';
            lstUserList.add(ulist); 
        }        
        
        Opportunity_TGP__Share oppShareLeads;
        List<Opportunity_TGP__Share> lstOpplTgpShare = new List<Opportunity_TGP__Share>();
        for(Opportunity_Offering__c oppOff : lstSObj)
        {
            for(UserList tmpUser : lstUserList)
            {
                for(Id oppId :oppIDs)
                {
                    if(tmpUser.userId != null && tmpUser.accessLevel != null)
                    {
                         oppShareLeads= new Opportunity_TGP__Share();
                         oppShareLeads.ParentId = oppId;
                         oppShareLeads.UserOrGroupId = tmpUser.userId;
                         oppShareLeads.AccessLevel = tmpUser.accessLevel;
                         oppShareLeads.RowCause = 'Manual';
                         lstOpplTgpShare.add(oppShareLeads);
                    }
                }
            } 
        }
        Database.SaveResult[] dealLocInsertResult = Database.insert(lstOpplTgpShare,false);
    }
    */
    /*--------------------------------------------------------------------
    Description : Access management for Offering Delete shared data
    ----------------------------------------------------------------------*/ 
    /*public void CheckAccessOfferingDelete(List<Opportunity_Offering__c> lstSObjOld)
    {
        boolean isPresent = false;
        
        Set<Id> roleIds = new Set<Id>();
        Set<Id> oppIDs = new Set<Id>();
       
        for(Opportunity_Offering__c oppOffPassed : lstSObjOld){
            oppIDs.add(oppOffPassed.Opportunity_TGP__c);
            roleIds.add(oppOffPassed.Solution_Lead_New__c);
            roleIds.add(oppOffPassed.Offering_Solution_Lead_Secondary_New__c);
            roleIds.add(oppOffPassed.Technical_Architect_New__c);
            roleIds.add(oppOffPassed.Domain_Expert_Functional_Architect_New__c);
            roleIds.add(oppOffPassed.Functional_Architect_Mobilization_New__c);
            roleIds.add(oppOffPassed.Solution_Specialist_New__c);
        }        
        
        Set<Id> roleIdsToDelete = new Set<Id>();
        for(Id tmpId : roleIds)
        {
            if(tmpId != null)
            {
                List<Opportunity_TGP__c > lstOpp = [select id from Opportunity_TGP__c where 
                                                  (Enterprise_Solution_Architect_New__c= :tmpId or Complex_Cost_Architect_New__c= :tmpId or BSS_Operation_New__c= :tmpId) and (id in : oppIDs)];
                if(lstOpp.size()>0)
                {
                    isPresent = true;
                    //return;
                }
                else if(lstOpp.size()==0)                                                
                {
                    roleIdsToDelete.add(tmpId);
                }                                    
                                                
           }                                     
        }

        if(isPresent)
            return;

        if(roleIdsToDelete.size()==0)
        {
            for(Id tmpId : roleIds)
            {
                if(tmpId != null)
                {
                    roleIdsToDelete.add(tmpId );
                }
            }
        }
        
        List<Review_User_Master__c> reviewUserMasterRecordsList  = [select SFDC_User__c from Review_User_Master__c where ID IN:roleIdsToDelete] ;
        Set<Id> userIDsToDeleteAccess = new set<Id>();
        for(Review_User_Master__c reviewUserMasterRecord : reviewUserMasterRecordsList) {
            userIDsToDeleteAccess.add(reviewUserMasterRecord.SFDC_User__c);
        } 
        
        List<Opportunity_TGP__Share> lstOppTgpSharedelete = [Select ParentId,UserOrGroupId from Opportunity_TGP__Share where ParentId IN: oppIDs AND UserOrGroupId IN: userIDsToDeleteAccess AND RowCause =: 'Manual'];     
        Database.DeleteResult[] dealTgpInsertResult = Database.delete(lstOppTgpSharedelete,false);
    } 
    */
    /*--------------------------------------------------------------------
    Description : Access management for Review Request Create shared data
    ----------------------------------------------------------------------*/ 
    public void CheckAccessReviewRequest(List<Request_Review__c> lstSObj)
    {
        List<UserList> lstUserList = new List<UserList>();
        UserList ulist; 
        List<Request_Review__c> oppIdList =[select id,Review_Process__r.BPO_Opportunity__c,Review_User_Master__c,Review_User_Master__r.SFDC_User__c
                                                from Request_Review__c where id =: lstSObj limit 10000];
        List<User> userEmailList=[Select id From User where id = : oppIdList[0].Review_User_Master__r.SFDC_User__c limit 10000];
        
        for(User userIDList : userEmailList)
        {
            ulist= new UserList();
            ulist.userId = userIDList.id;
            ulist.accessLevel= UTIL_Constants.READ;
            lstUserList.add(ulist);
        }       
  
        Opportunity_TGP__Share opportunityShareLeads;
        List<Opportunity_TGP__Share> lstOppTgpShare = new List<Opportunity_TGP__Share>();
        for(Request_Review__c oppTGP : oppIdList)
        {
            for(UserList tmpUser : lstUserList)
            {
                if(tmpUser.userId != null && tmpUser.accessLevel != null)
                {
                     opportunityShareLeads= new Opportunity_TGP__Share();                 
                     opportunityShareLeads.ParentId = oppTGP.Review_Process__r.BPO_Opportunity__c;
                     opportunityShareLeads.UserOrGroupId = tmpUser.userId;                     
                     opportunityShareLeads.AccessLevel = tmpUser.accessLevel;
                     opportunityShareLeads.RowCause = UTIL_Constants.MANUAL;
                     lstOppTgpShare.add(opportunityShareLeads);
                }
            } 
        }
        Database.SaveResult[] oppTgpInsertResult = Database.insert(lstOppTgpShare,false); 
    }
    
   /*--------------------------------------------------------------------
    Description : Access management for Review Request Delete shared data
    ----------------------------------------------------------------------*/ 
   public void CheckAccessReviewRequestDelete(List<Request_Review__c> lstSObjOld)
    {
        List<Opportunity_TGP__c> bpoOppList = new List<Opportunity_TGP__c>();
        List<Request_Review__c> reqReviewList = new List<Request_Review__c>();
        List<Opportunity_Offering__c> listOffering = new List<Opportunity_Offering__c>();
        Set<ID> userMaserId = new Set<ID>();
        Set<ID> oppId = new Set<ID>();
        Set<Id> roleIds = new Set<Id>();
        Set<Id> oppTgpId = new Set<Id>();
        Set<Id> roleIdsToDelete = new Set<Id>();
        boolean isPresent = false;
        
        reqReviewList =[select id,Review_Process__r.BPO_Opportunity__c,Review_User_Master__c from Request_Review__c where id =: lstSObjOld limit 10000];
        for(Request_Review__c oppListID : reqReviewList){           
            userMaserId.add(oppListID.Review_User_Master__c);    
            oppId.add(oppListID.Review_Process__r.BPO_Opportunity__c);  
            roleIds.add(oppListID.Review_User_Master__c);    
            oppTgpId.add(oppListID.Review_Process__r.BPO_Opportunity__c);      
        }
        List<Request_Review__c> reqList = [select id,Review_Process__r.BPO_Opportunity__c,Review_User_Master__c from Request_Review__c where Review_Process__r.BPO_Opportunity__c in : oppTgpId limit 10000];
        for(Id tmpId : roleIds)
        {
            if(tmpId != null)
            {
              Integer Count = 0; 
              for(Request_Review__c rList: reqList )
              {
                 if(rList.Review_User_Master__c == tmpId)
                 {
                    Count++;
                 }
              }
              //if(reqList.size()>1)
              if(Count>1)
               {
                  isPresent = true;
                  //return;
               }                             
            }
        }
       if(isPresent){
          return;
       }
        bpoOppList = [select id,Enterprise_Solution_Architect_New__c 
                            from Opportunity_TGP__c where 
                            (Enterprise_Solution_Architect_New__c IN : userMaserId ) and id in : oppId limit 10000];
                 
        listOffering = [select id,Opportunity_TGP__c,Solution_Lead_New__c,Offering_Solution_Lead_Secondary_New__c,Technical_Architect_New__c,Domain_Expert_Functional_Architect_New__c,
                                Functional_Architect_Mobilization_New__c,Solution_Specialist_New__c from Opportunity_Offering__c 
                                where (Solution_Lead_New__c IN :userMaserId or
                                Offering_Solution_Lead_Secondary_New__c IN :userMaserId or
                                Technical_Architect_New__c IN :userMaserId or
                                Domain_Expert_Functional_Architect_New__c IN :userMaserId or
                                Functional_Architect_Mobilization_New__c IN :userMaserId or
                                Solution_Specialist_New__c IN :userMaserId) and Opportunity_TGP__c in : oppId limit 10000];
        ////////////////////
      
        for(Opportunity_TGP__c oppTgp : bpoOppList)
        { 
            roleIds.add(oppTgp.Enterprise_Solution_Architect_New__c);
            //roleIds.add(oppTgp.Complex_Cost_Architect_New__c);  
            //roleIds.add(oppTgp.BSS_Operation_New__c);          
            oppTgpId.add(oppTgp.Id);                        
        }
        List<Opportunity_Offering__c> lstOffering = [select id,Solution_Lead_New__c,Offering_Solution_Lead_Secondary_New__c,Solution_Specialist_New__c,Technical_Architect_New__c,
                                                    Domain_Expert_Functional_Architect_New__c,Functional_Architect_Mobilization_New__c from Opportunity_Offering__c where Opportunity_TGP__c in : oppTgpId limit 10000];
        for(Id tmpId : roleIds)
        {
            if(tmpId != null)
            {
   
              Integer Count = 0; 
              for(Opportunity_Offering__c listOff: lstOffering )
              {
                 if(listOff.Solution_Lead_New__c == tmpId || listOff.Offering_Solution_Lead_Secondary_New__c == tmpId || listOff.Solution_Specialist_New__c == tmpId 
                    || listOff.Technical_Architect_New__c == tmpId || listOff.Domain_Expert_Functional_Architect_New__c == tmpId || listOff.Functional_Architect_Mobilization_New__c == tmpId)
                 {
                    Count++;
                 }
              }
               if(Count>0)
                {
                    isPresent = true;
                    //return;
                }
                else if(Count==0)                                                
                {
                    roleIdsToDelete.add(tmpId);
                }
                else{}
            }
        }
       if(isPresent){
            return;
       }
       if(roleIdsToDelete.size()==0)
        {
            for(Id tmpId : roleIds)
            {
                if(tmpId != null)
                {
                    roleIdsToDelete.add(tmpId );
                }
            }
        }
       ///////////////////
       
        for(Opportunity_Offering__c oppOffPassed : listOffering){
            oppTgpId.add(oppOffPassed.Opportunity_TGP__c);
            roleIds.add(oppOffPassed.Solution_Lead_New__c);
            roleIds.add(oppOffPassed.Offering_Solution_Lead_Secondary_New__c);
            roleIds.add(oppOffPassed.Technical_Architect_New__c);
            roleIds.add(oppOffPassed.Domain_Expert_Functional_Architect_New__c);
            roleIds.add(oppOffPassed.Functional_Architect_Mobilization_New__c);
            roleIds.add(oppOffPassed.Solution_Specialist_New__c);
        }      
      
        List<Opportunity_TGP__c > lstOpp = [select id,Enterprise_Solution_Architect_New__c,BSS_Operation_New__c from Opportunity_TGP__c where id in : oppTgpId limit 10000];        
        for(Id tmpId : roleIds)
        {
            if(tmpId != null)
            {
               Integer Count = 0;
              for(Opportunity_TGP__c oppList: lstOpp )
              {
                 if(oppList.Enterprise_Solution_Architect_New__c == tmpId || oppList.BSS_Operation_New__c == tmpId)
                 {
                    Count++;
                 }
              }
              if(Count >0)
              {
                  isPresent = true;
              }
              else if(Count==0)                                                
              {
                  roleIdsToDelete.add(tmpId);
              }                                
              else{}                                  
           }                                     
        }
        if(isPresent){
            return;
        }
        if(roleIdsToDelete.size()==0)
        {
            for(Id tmpId : roleIds)
            {
                if(tmpId != null)
                {
                    roleIdsToDelete.add(tmpId );
                }
            }
        }
        List<Review_User_Master__c> reviewUserMasterRecordsList  = [select SFDC_User__c from Review_User_Master__c where ID IN:roleIdsToDelete limit 10000] ;
        Set<Id> userIDsToDeleteAccess = new set<Id>();
        for(Review_User_Master__c reviewUserMasterRecord : reviewUserMasterRecordsList) {
            userIDsToDeleteAccess.add(reviewUserMasterRecord.SFDC_User__c);
        } 
        List<Opportunity_TGP__Share> lstoppTgpSharedelete = [Select ParentId,UserOrGroupId from Opportunity_TGP__Share where ParentId IN: oppTgpId AND UserOrGroupId IN: userIDsToDeleteAccess AND RowCause =:UTIL_Constants.MANUAL limit 10000];
        Database.DeleteResult[] dealTgpInsertResult = Database.delete(lstoppTgpSharedelete,false);
       ////////////////// 
    }
    /*--------------------------------------------------------------------
    Description : Access management for Review Action Item Log Create shared data
    ----------------------------------------------------------------------*/ 
    public void CheckAccessReviewRequestLog(List<Review_Action_Item_Log__c> lstSObj)
    {
        List<UserList> lstUserList = new List<UserList>();
        UserList ulist; 
        List<Review_Action_Item_Log__c> oppIdList =[select id,Review_Process__r.BPO_Opportunity__c,Primary_Owner__c,Primary_Owner__r.Email_ID_of_the_reviewer__c
         from Review_Action_Item_Log__c where id =: lstSObj limit 10000];
        List<User> userEmailList=[Select id From User where Email = : oppIdList[0].Primary_Owner__r.Email_ID_of_the_reviewer__c limit 10000];
        
        for(User userIDList : userEmailList)
        {
            ulist= new UserList();
            ulist.userId = userIDList.id;
            ulist.accessLevel= UTIL_Constants.READ;
            lstUserList.add(ulist);
        }       

        Opportunity_TGP__Share opportunityShareLeads;
        List<Opportunity_TGP__Share> lstOppTgpShare = new List<Opportunity_TGP__Share>();
        for(Review_Action_Item_Log__c oppTGP : oppIdList)
        {
            for(UserList tmpUser : lstUserList)
            {
                if(tmpUser.userId != null && tmpUser.accessLevel != null)
                {
                     opportunityShareLeads= new Opportunity_TGP__Share();                 
                     opportunityShareLeads.ParentId = oppTGP.Review_Process__r.BPO_Opportunity__c;
                     opportunityShareLeads.UserOrGroupId = tmpUser.userId;                     
                     opportunityShareLeads.AccessLevel = tmpUser.accessLevel;
                     opportunityShareLeads.RowCause = UTIL_Constants.MANUAL;
                     lstOppTgpShare.add(opportunityShareLeads);
                }
            } 
        }
        Database.SaveResult[] oppTgpInsertResult = Database.insert(lstOppTgpShare,false); 
    }
    
     /*--------------------------------------------------------------------
    Description : Access management for Review Action Item Log Delete shared data
    ----------------------------------------------------------------------*/ 
    public void CheckAccessReviewRequestLogDelete(List<Review_Action_Item_Log__c> lstSObjOld)
    {
        List<Opportunity_TGP__c> bpoOppList = new List<Opportunity_TGP__c>();
        List<Request_Review__c> reqReviewList = new List<Request_Review__c>();
        List<Opportunity_Offering__c> listOffering = new List<Opportunity_Offering__c>();
        Set<ID> oppId = new Set<ID>();
        Set<ID> userMaserId = new Set<ID>();
        Set<Id> roleIds = new Set<Id>();
        Set<Id> oppTgpId = new Set<Id>();
        Set<Id> roleIdsToDelete = new Set<Id>();
        boolean isPresent = false;
        
        List<Review_Action_Item_Log__c> RActionItemLogList = [select id,Review_Process__r.BPO_Opportunity__c,Primary_Owner__c
                                                                from Review_Action_Item_Log__c where id =: lstSObjOld limit 10000]; 
        ///////////////////////////////////////////
        
        for(Review_Action_Item_Log__c oppListID : RActionItemLogList)
        {           
            userMaserId.add(oppListID.Primary_Owner__c);    
            oppId.add(oppListID.Review_Process__r.BPO_Opportunity__c);  
            roleIds.add(oppListID.Primary_Owner__c);    
            oppTgpId.add(oppListID.Review_Process__r.BPO_Opportunity__c);      
        }
        List<Review_Action_Item_Log__c> reqLogList = [select id,Review_Process__r.BPO_Opportunity__c,Primary_Owner__c from Review_Action_Item_Log__c where Review_Process__r.BPO_Opportunity__c in : oppTgpId limit 10000];
        for(Id tmpId : roleIds)
        {
            if(tmpId != null)
            {
              Integer Count = 0; 
              for(Review_Action_Item_Log__c reqLog: reqLogList )
              {
                 if(reqLog.Primary_Owner__c == tmpId)
                 {
                    Count++;
                 }
              }
            // if(reqLogList.size()>1)
              if(Count >1)
              {
                  isPresent = true;
                    //return;
              }                             
            }
        }
       if(isPresent){
            return;
       }
        bpoOppList = [select id,Enterprise_Solution_Architect_New__c 
                            from Opportunity_TGP__c where 
                            (Enterprise_Solution_Architect_New__c IN : userMaserId) and id in : oppId limit 10000];
                 
        listOffering = [select id,Opportunity_TGP__c,Solution_Lead_New__c,Offering_Solution_Lead_Secondary_New__c,Technical_Architect_New__c,Domain_Expert_Functional_Architect_New__c,
                                Functional_Architect_Mobilization_New__c,Solution_Specialist_New__c from Opportunity_Offering__c 
                                where (Solution_Lead_New__c IN :userMaserId or
                                Offering_Solution_Lead_Secondary_New__c IN :userMaserId or
                                Technical_Architect_New__c IN :userMaserId or
                                Domain_Expert_Functional_Architect_New__c IN :userMaserId or
                                Functional_Architect_Mobilization_New__c IN :userMaserId or
                                Solution_Specialist_New__c IN :userMaserId) and Opportunity_TGP__c in : oppId limit 10000];
        ////////////////////
      
        for(Opportunity_TGP__c oppTgp : bpoOppList)
        { 
            roleIds.add(oppTgp.Enterprise_Solution_Architect_New__c);
            //roleIds.add(oppTgp.Complex_Cost_Architect_New__c);  
            //roleIds.add(oppTgp.BSS_Operation_New__c);          
            oppTgpId.add(oppTgp.Id);                        
        }
        List<Opportunity_Offering__c> lstOffering = [select id, Solution_Lead_New__c,Offering_Solution_Lead_Secondary_New__c,Solution_Specialist_New__c,Technical_Architect_New__c,   
                                                    Domain_Expert_Functional_Architect_New__c,Functional_Architect_Mobilization_New__c from Opportunity_Offering__c where Opportunity_TGP__c in : oppTgpId limit 10000];
        for(Id tmpId : roleIds)
        {
            if(tmpId != null)
            {
              Integer Count = 0;
              for(Opportunity_Offering__c lstOff: lstOffering )
              {
                 if(lstOff.Solution_Lead_New__c == tmpId || lstOff.Offering_Solution_Lead_Secondary_New__c == tmpId || lstOff.Solution_Specialist_New__c == tmpId || lstOff.Technical_Architect_New__c == tmpId
                  || lstOff.Domain_Expert_Functional_Architect_New__c == tmpId || lstOff.Functional_Architect_Mobilization_New__c == tmpId)
                 {
                    Count++;
                 }
              }
              if(Count >0)
              {
                  isPresent = true;
              }
              else if(Count==0)                                                
              {
                  roleIdsToDelete.add(tmpId);
              } 
              else{}
            }
        }
        
       if(isPresent){
            return;
       }
       if(roleIdsToDelete.size()==0)
        {
            for(Id tmpId : roleIds)
            {
                if(tmpId != null)
                {
                    roleIdsToDelete.add(tmpId );
                }
            }
        }
       ///////////////////
       
        for(Opportunity_Offering__c oppOffPassed : listOffering)
        {
            oppTgpId.add(oppOffPassed.Opportunity_TGP__c);
            roleIds.add(oppOffPassed.Solution_Lead_New__c);
            roleIds.add(oppOffPassed.Offering_Solution_Lead_Secondary_New__c);
            roleIds.add(oppOffPassed.Technical_Architect_New__c);
            roleIds.add(oppOffPassed.Domain_Expert_Functional_Architect_New__c);
            roleIds.add(oppOffPassed.Functional_Architect_Mobilization_New__c);
            roleIds.add(oppOffPassed.Solution_Specialist_New__c);
        }
        List<Opportunity_TGP__c > lstOpp = [select id,Enterprise_Solution_Architect_New__c,BSS_Operation_New__c from Opportunity_TGP__c 
        where id in : oppTgpId limit 10000];        
        for(Id tmpId : roleIds)
        {
            if(tmpId != null)
            {
               Integer Count = 0;
              for(Opportunity_TGP__c oppList: lstOpp )
              {
                 if(oppList.Enterprise_Solution_Architect_New__c == tmpId || oppList.BSS_Operation_New__c == tmpId)
                 {
                    Count++;
                 }
              }
              if(Count >0)
              {
                  isPresent = true;
              }
              else if(Count==0)                                                
              {
                  roleIdsToDelete.add(tmpId);
              }
              else{}
                                                
           }                                     
        }
        
        if(isPresent){
            return;
        }
        if(roleIdsToDelete.size()==0)
        {
            for(Id tmpId : roleIds)
            {
                if(tmpId != null)
                {
                    roleIdsToDelete.add(tmpId );
                }
            }
        }
        
        List<Review_User_Master__c> reviewUserMasterRecordsList  = [select SFDC_User__c from Review_User_Master__c where ID IN:roleIdsToDelete limit 10000] ;
        Set<Id> userIDsToDeleteAccess = new set<Id>();
        
        for(Review_User_Master__c reviewUserMasterRecord : reviewUserMasterRecordsList)
        {
            userIDsToDeleteAccess.add(reviewUserMasterRecord.SFDC_User__c);
        }
         
        List<Opportunity_TGP__Share> lstoppTgpSharedelete = [Select ParentId,UserOrGroupId from Opportunity_TGP__Share where ParentId IN: oppTgpId AND UserOrGroupId IN: userIDsToDeleteAccess AND RowCause =:UTIL_Constants.MANUAL limit 10000];
        Database.DeleteResult[] dealTgpInsertResult = Database.delete(lstoppTgpSharedelete,false);
        
    }
      
//END
  /*
    private List<User> retriveSolutionAccessToMob() {
        Set<String> userIdSet = new Set<String>();
        List<User> userList = new List<User>();
        for(PermissionSetAssignment psetassignment : [Select AssigneeId from PermissionSetAssignment Where PermissionSetId in 
                                                            (Select Id From PermissionSet where name = 'SWB_Access_to_MWB')]) {
            if(String.isNotEmpty(psetassignment.AssigneeId)) {
                userIdSet.add(psetassignment.AssigneeId);
            }       
        }
        for(User usr: [Select Id From User Where Id =:userIdSet]){
            userList.add(usr);
        }
        return userList;
    }
    */


}