public class Mob_CascadeComercialActivityMasterChange
{

public static void CascadeActivityMasterChangesOnUpdate(List<Commercial_Plan_Activity_Master__c> lstOldActivity, List<Commercial_Plan_Activity_Master__c> lstNewActivity)
{
    if(lstOldActivity.size()>0 && lstNewActivity.size()>0)
    {
        if((lstOldActivity.get(0).Activity_Name__c != lstNewActivity.get(0).Activity_Name__c)||(lstOldActivity.get(0).Activity_Order__c!= lstNewActivity.get(0).Activity_Order__c))
        {    
            List<Commercial_Planning__c> lstCommercePlan = [select id,activity__c,Activity_Order__c from  Commercial_Planning__c where activity__c =:lstOldActivity.get(0).Activity_Name__c ]; //and wave_plan_version__r.active__c=true and wave_plan_version__r.Display_tracking_message__c=null];
            for(Commercial_Planning__c tmpCommercePlan : lstCommercePlan )    
            {
                tmpCommercePlan.activity__c =  lstNewActivity.get(0).Activity_Name__c;
                tmpCommercePlan.Activity_Order__c =  lstNewActivity.get(0).Activity_Order__c;
                tmpCommercePlan.Commercial_Plan_Activity_Master_Id__c =  lstNewActivity.get(0).id;
            }    
            update lstCommercePlan ;
        }
    }
}


public static void CascadeActivityMasterChangesOnInsert(List<Commercial_Plan_Activity_Master__c> lstNewActivity)
{
    List<Commercial_Planning__c> lstCommercePlan = new List<Commercial_Planning__c>();
    Commercial_Planning__c tmpCommercePlan;
    if(lstNewActivity.size()>0)
    {
        List<Wave_Plan_Version__c> lstWavePlanVersion = [select id, active__c,Display_tracking_message__c from Wave_Plan_Version__c where active__c = true and Display_tracking_message__c=null];
        for(Commercial_Plan_Activity_Master__c tmpActivity : lstNewActivity)
        {
            for(Wave_Plan_Version__c tmpWavePlanVersion : lstWavePlanVersion)
            {
                tmpCommercePlan = new Commercial_Planning__c ();
                tmpCommercePlan.Wave_Plan_Version__c = tmpWavePlanVersion.id;
                tmpCommercePlan.activity__c =tmpActivity.Activity_Name__c;
                tmpCommercePlan.Activity_Order__c =tmpActivity.Activity_Order__c;
                tmpCommercePlan.Commercial_Plan_Activity_Master_Id__c = tmpActivity.id;
                lstCommercePlan.add(tmpCommercePlan);
            }
        }        
    }
    insert lstCommercePlan;
}

public static void CascadeActivityMasterChangesOnDelete(List<Commercial_Plan_Activity_Master__c> lstOldActivity)
{
    if(lstOldActivity.size()>0)
    {
            List<Commercial_Planning__c> lstCommercePlan = [select id,Activity__c,Commercial_Plan_Activity_Master_Id__c
                                                                from  Commercial_Planning__c
                                                                where activity__c = :lstOldActivity.get(0).Activity_Name__c
                                                                and wave_plan_version__r.active__c=true 
                                                                and wave_plan_version__r.Display_tracking_message__c=null];
        if(lstCommercePlan.size()>0)
        {
            delete lstCommercePlan;
        }    
    }
}
}