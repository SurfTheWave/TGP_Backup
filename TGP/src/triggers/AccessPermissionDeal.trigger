trigger AccessPermissionDeal on Deal_TGP__c (after update) 
{
    List<Deal_TGP__c> lstNewDeal = Trigger.new;
    List<Deal_TGP__c> lstOldDeal = Trigger.old;
    
    UserAccessUtility uam = new UserAccessUtility();
    boolean isActive = false;
    boolean isActiveUAM = false;
    //event check when records are updated
    if (Trigger.isupdate)
    {
    Set<Id> delNewId = new Set<Id>();
    for(Deal_TGP__c newid : lstNewDeal){
        delNewId.add(newid.id);
    }
    Set<Id> delOldId = new Set<Id>();
    for(Deal_TGP__c oldid : lstOldDeal){
        delOldId.add(oldid.id);
    }
    List<MOB_User_Role_Assignment__c> lstUserRoleAssignNew = [select Access_Level__c,Deal__c,Mob_User_Roles_Master__c,Role_Name__c,
                            User_Assigned_New__r.SFDC_User__c ,User_Assigned_New__c,
                            User_Assigned_Secondary_New__r.SFDC_User__c,User_Assigned_Secondary_New__c,
                            User_Assigned_Secondary_Lead__c, User_Assigned_Secondary_Lead__r.SFDC_USER__c
                            from MOB_User_Role_Assignment__c  where Deal__c IN : delNewId limit 10]; 
                            
    
    List<MOB_User_Role_Assignment__c> lstUserRoleAssignOld = [select Access_Level__c,Deal__c,Mob_User_Roles_Master__c,Role_Name__c,
                            User_Assigned_New__r.SFDC_User__c ,User_Assigned_New__c,
                            User_Assigned_Secondary_New__r.SFDC_User__c,User_Assigned_Secondary_New__c,
                            User_Assigned_Secondary_Lead__c, User_Assigned_Secondary_Lead__r.SFDC_USER__c
                            from MOB_User_Role_Assignment__c  where Deal__c IN : delOldId limit 10]; 
    
    for(MOB_User_Role_Assignment__c oldMob : lstUserRoleAssignOld){
            for(MOB_User_Role_Assignment__c newMob : lstUserRoleAssignNew){
            
                if((oldMob.Role_Name__c == newMob.Role_Name__c) &&
                ((oldMob.User_Assigned_New__r.SFDC_User__c != newMob.User_Assigned_New__r.SFDC_User__c) ||
                (oldMob.User_Assigned_Secondary_New__r.SFDC_User__c != newMob.User_Assigned_Secondary_New__r.SFDC_User__c) ||
                (oldMob.User_Assigned_Secondary_Lead__r.SFDC_USER__c != newMob.User_Assigned_Secondary_Lead__r.SFDC_USER__c))){                
                
                isActiveUAM=true;
                break;        
                      
                }
            }
    }
    
   
        for(integer i=0;i<lstOldDeal.size();i++ )
        {
            if((lstOldDeal.get(i).Deal_RAG_Status__c == lstNewDeal.get(i).Deal_RAG_Status__c)
            &&(lstOldDeal.get(i).Deal_Status__c == lstNewDeal.get(i).Deal_Status__c)
            &&(lstOldDeal.get(i).CommentForDealTracking__c== lstNewDeal.get(i).CommentForDealTracking__c)
            &&(lstNewDeal.get(i).Approval_Status__c==true) )
            {
                 isActive=true;
                 break;
            }
        }
        if(isActive && isActiveUAM){
        
            uam.CheckAccessDealDelete(lstOldDeal);   
            uam.CheckAccessDeal(lstNewDeal);    
        }   
        } 
    }