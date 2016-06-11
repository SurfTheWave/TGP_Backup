/*
Name :         Mob_CascadeActivityMasterChanges
Description :  Addition and updatation of record in activity master is reflected in recruitment tracking records.
Story : MOB-145
Author :       Nilesh Adkar (Accenture)

Updated by        Update date        User story
-----------    ------------------  --------------

*/
public class Mob_CascadeActivityMasterChanges
{

public static void CascadeActivityMasterChangesOnUpdate(List<Activity_Master__c> lstOldActivity, List<Activity_Master__c> lstNewActivity)
{
    if(lstOldActivity.size()>0 && lstNewActivity.size()>0)
    {
        if((lstOldActivity.get(0).name != lstNewActivity.get(0).name)||(lstOldActivity.get(0).Activity_Order__c!= lstNewActivity.get(0).Activity_Order__c))
        {    
            List<Recruitment_Tracking__c> lstRecruitTrack = [select id,activity__c,Activity_Order__c from  Recruitment_Tracking__c where activity__c =:lstOldActivity.get(0).name ]; //and wave_plan_version__r.active__c=true and wave_plan_version__r.Display_tracking_message__c=null order by id];
            for(Recruitment_Tracking__c tmpRecruitTrack : lstRecruitTrack )    
            {
                tmpRecruitTrack.activity__c =  lstNewActivity.get(0).name;
                tmpRecruitTrack.Activity_Order__c =  lstNewActivity.get(0).Activity_Order__c;
                tmpRecruitTrack.Activity_Master_ID__c = lstNewActivity.get(0).id;
            }    
            update lstRecruitTrack ;
        }
    }
}


public static void CascadeActivityMasterChangesOnInsert(List<Activity_Master__c> lstNewActivity)
{
    List<Recruitment_Tracking__c> lstRecruit = new List<Recruitment_Tracking__c>();
    Recruitment_Tracking__c tmpRecruitTrack;
    if(lstNewActivity.size()>0)
    {
        List<Wave_Planning__c> lstDealWave = [select id, name,Deal_Location__c, Wave_Plan_Version__c,Deal_Location__r.Wave_Plan_Version__r.active__c,Deal_Location__r.Wave_Plan_Version__r.Display_tracking_message__c from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__r.active__c = true and Deal_Location__r.Wave_Plan_Version__r.Display_tracking_message__c=null];
        for(Activity_Master__c tmpActivity : lstNewActivity)
        {
            for(Wave_Planning__c tmpDealWave : lstDealWave )
            {
                tmpRecruitTrack = new Recruitment_Tracking__c ();
                tmpRecruitTrack.Wave_Plan_lk__c = tmpDealWave.id ;
                tmpRecruitTrack.Deal_Location_lk__c = tmpDealWave.Deal_Location__c;
                tmpRecruitTrack.Wave_Plan_Version__c = tmpDealWave.Deal_Location__r.Wave_Plan_Version__C;
                tmpRecruitTrack.activity__c = tmpActivity.name;
                tmpRecruitTrack.Activity_Order__c = tmpActivity.Activity_Order__c;
                tmpRecruitTrack.Activity_Master_ID__c = tmpActivity.id;
                lstRecruit.add(tmpRecruitTrack);
            }
            insert lstRecruit;
        }        
    }
}

public static void CascadeActivityMasterChangesOnDelete(List<Activity_Master__c> lstOldActivity)
{
    if(lstOldActivity.size()>0)
    {
        List<Recruitment_Tracking__c > lstRecruitTrack = [select id,Activity__c,Activity_Master_ID__c
                                                            from  Recruitment_Tracking__c 
                                                            where Activity__c = :lstOldActivity.get(0).name
                                                            and wave_plan_version__r.active__c=true 
                                                            and wave_plan_version__r.Display_tracking_message__c=null];
        if(lstRecruitTrack.size()>0)
        {
            delete lstRecruitTrack;
        }    
    }
}
}