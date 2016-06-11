/*
Name :         MOB_MakeMECQnsVersionActive
Description :  This class will deactivate other active version if current version is made active
Author :       Nilesh Adkar (Accenture)

Updated by        Update date        User story
-----------    ------------------  --------------

*/
public class MOB_MakeMECQnsVersionActive
{
    public static void makeVersionActive(List<MEC_Post_Contract_Version__c> lstMECPostContractVersion)
    {
            if(lstMECPostContractVersion.size()>0 && Recursive.isMECVersionMarkedActive == false)
            {    
                if(lstMECPostContractVersion.get(0).active__c==true)
                {
                    List<MEC_Post_Contract_End_User__c> lstMECEndUser = [ select id , HAS_Checklist_Version_Changed__c
                                                                            from MEC_Post_Contract_End_User__c
                                                                            where deal__r.Has_Gov_Lead_Submitted__c=false
                                                                        ];
                    for(MEC_Post_Contract_End_User__c tmpMECEndUser : lstMECEndUser )
                    {
                        tmpMECEndUser.HAS_Checklist_Version_Changed__c = true;
                    }                                                    
                    update lstMECEndUser;
                    
                    Id versionId = lstMECPostContractVersion.get(0).id;
                    List<MEC_Post_Contract_Version__c> lstVersionList = [ select id, active__c 
                                                                          from MEC_Post_Contract_Version__c
                                                                          where id <> :versionId and active__c =true
                                                                        ];
                    for(MEC_Post_Contract_Version__c tmpVersion : lstVersionList )
                    {
                        tmpVersion.active__c = false;
                    }
                    //Recursive.isMECVersionMarkedActive = true;                                 
                    update lstVersionList;
                    
                }                                                                    
            }        
    }
}