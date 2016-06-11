public class Mob_CascadeTechActivityMasterChanges
{

public static void CascadeActivityMasterChangesOnUpdate(List<Tech_Assessment_Activity_Master__c> lstOldActivity, List<Tech_Assessment_Activity_Master__c> lstNewActivity)
{
    if(lstOldActivity.size()>0 && lstNewActivity.size()>0)
    {
        if((lstOldActivity.get(0).name != lstNewActivity.get(0).name)||(lstOldActivity.get(0).Activity_Order__c!= lstNewActivity.get(0).Activity_Order__c))
        {    
            List<Tech_Assessment__c> lstTechAssess = [select id,activity__c,Activity_Order__c from  Tech_Assessment__c where activity__c =:lstOldActivity.get(0).name]; // and wave_plan_version__r.active__c=true and wave_plan_version__r.Display_tracking_message__c=null];
            for(Tech_Assessment__c tmpTechAssess : lstTechAssess )    
            {
                tmpTechAssess.activity__c =  lstNewActivity.get(0).name;
                tmpTechAssess.Activity_Order__c =  lstNewActivity.get(0).Activity_Order__c;                
                tmpTechAssess.Tech_Assessment_Activity_Master_ID__c=lstNewActivity.get(0).id;                
            }    
            update lstTechAssess ;
        }
    }
}


public static void CascadeActivityMasterChangesOnInsert(List<Tech_Assessment_Activity_Master__c> lstNewActivity)
{
    List<Tech_Assessment__c> lstTechAssess = new List<Tech_Assessment__c>();
    Tech_Assessment__c tmpTechAssess;
    if(lstNewActivity.size()>0)
    {
        List<Wave_Planning__c> lstDealWave = [select id, name,Deal_Location__c, Wave_Plan_Version__c,Deal_Location__r.Wave_Plan_Version__r.active__c,Deal_Location__r.Wave_Plan_Version__r.Display_tracking_message__c from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__r.active__c = true and Deal_Location__r.Wave_Plan_Version__r.Display_tracking_message__c=null];
        for(Tech_Assessment_Activity_Master__c tmpActivity : lstNewActivity)
        {
            for(Wave_Planning__c tmpDealWave : lstDealWave )
            {
                tmpTechAssess = new Tech_Assessment__c ();
                tmpTechAssess.Wave_Plan_lk__c = tmpDealWave.id ;
                tmpTechAssess.Deal_Location_lk__c = tmpDealWave.Deal_Location__c;
                tmpTechAssess.Wave_Plan_Version__c = tmpDealWave.Deal_Location__r.Wave_Plan_Version__C;
                tmpTechAssess.activity__c =tmpActivity.name;
                tmpTechAssess.Tech_Assessment_Activity_Master_ID__c=tmpActivity.id;
                lstTechAssess.add(tmpTechAssess);
            }
            insert lstTechAssess;
        }        
    }
}


public static void CascadeActivityMasterChangesOnDelete(List<Tech_Assessment_Activity_Master__c > lstOldActivity)
{
    if(lstOldActivity.size()>0)
    {
        List<Tech_Assessment__c> lstTechAssess = [select id,Activity__c,Tech_Assessment_Activity_Master_ID__c
                                                    from  Tech_Assessment__c
                                                    where activity__c = :lstOldActivity.get(0).name
                                                    and wave_plan_version__r.active__c=true 
                                                    and wave_plan_version__r.Display_tracking_message__c=null];
        if(lstTechAssess.size()>0)
        {
            delete lstTechAssess;
        }    
    }
}
}