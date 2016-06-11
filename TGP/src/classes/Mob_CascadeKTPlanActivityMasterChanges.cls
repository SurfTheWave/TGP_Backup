/*
Dscription : This class populates/updates KT plan grid in High level plan by values in kt plan activity master
             Called by trigger updateActivityOnWPVKTPlaning on KT_Planning_Activity_Master__c 
Author : Nilesh Adkar
Story  : Story-0098/MOB_044  


Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
             
*/

public class Mob_CascadeKTPlanActivityMasterChanges
{

// Update activity name on KT plan grid

public static void CascadeActivityMasterChangesOnUpdate(List<KT_Planning_Activity_Master__c> lstOldActivity, List<KT_Planning_Activity_Master__c> lstNewActivity)
{
    if(lstOldActivity.size()>0 && lstNewActivity.size()>0)
    {
        if((lstOldActivity.get(0).name != lstNewActivity.get(0).name)||(lstOldActivity.get(0).activity_order__c!= lstNewActivity.get(0).activity_order__c))
        {    
            List<KT_Planning__c> lstKTPlan = [select id,activity__c,activity_order__c  from  KT_Planning__c where activity__c =:lstOldActivity.get(0).name]; // and wave_plan_version__r.active__c=true and wave_plan_version__r.Display_tracking_message__c=null];
            for(KT_Planning__c tmpKTPlan : lstKTPlan )    
            {
                tmpKTPlan.activity__c =  lstNewActivity.get(0).name;
                tmpKTPlan.activity_order__c =  lstNewActivity.get(0).activity_order__c ;
                tmpKTPlan.KT_Planning_Activity_Master_ID__c = lstNewActivity.get(0).id;
            }    
            update lstKTPlan ;
        }
    }
}

// Insert activity name on KT plan grid for each wave in wave plan version

public static void CascadeActivityMasterChangesOnInsert(List<KT_Planning_Activity_Master__c> lstNewActivity)
{
    List<KT_Planning__c> lstKTPlan = new List<KT_Planning__c>();
    KT_Planning__c tmpKTPlan;
    if(lstNewActivity.size()>0)
    {
        List<Wave_Planning__c> lstDealWave = [select id, name,Deal_Location__c, Wave_Plan_Version__c,Deal_Location__r.Wave_Plan_Version__r.active__c,Deal_Location__r.Wave_Plan_Version__r.Display_tracking_message__c from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__r.active__c = true and Deal_Location__r.Wave_Plan_Version__r.Display_tracking_message__c=null];
        for(KT_Planning_Activity_Master__c tmpActivity : lstNewActivity)
        {
            for(Wave_Planning__c tmpDealWave : lstDealWave )
            {
                tmpKTPlan = new KT_Planning__c ();
                tmpKTPlan.Wave_Plan_lk__c = tmpDealWave.id ;
                tmpKTPlan.Deal_Location_lk__c = tmpDealWave.Deal_Location__c;
                tmpKTPlan.Wave_Plan_Version__c = tmpDealWave.Deal_Location__r.Wave_Plan_Version__C;
                tmpKTPlan.activity__c =tmpActivity.name;
                tmpKTPlan.Activity_Order__c=tmpActivity.Activity_Order__c;
                tmpKTPlan.KT_Planning_Activity_Master_ID__c = tmpActivity.id;
                lstKTPlan.add(tmpKTPlan);
            }
            insert lstKTPlan;
        }        
    }
}


public static void CascadeActivityMasterChangesOnDelete(List<KT_Planning_Activity_Master__c> lstOldActivity)
{
    if(lstOldActivity.size()>0)
    {
            List<KT_Planning__c> lstKTPlanning = [select id,Activity__c,KT_Planning_Activity_Master_ID__c
                                                    from  KT_Planning__c
                                                    where Activity__c = :lstOldActivity.get(0).Name
                                                    and wave_plan_version__r.active__c=true 
                                                    and wave_plan_version__r.Display_tracking_message__c=null];
        if(lstKTPlanning.size()>0)
        {
            delete lstKTPlanning;
        }    
    }
}

}