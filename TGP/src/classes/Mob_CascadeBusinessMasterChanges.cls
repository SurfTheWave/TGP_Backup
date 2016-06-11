public class Mob_CascadeBusinessMasterChanges
{

public static void CascadeBusinessMasterChangesOnUpdate(List<BCP_Section_Master__c> lstOldSection, List<BCP_Section_Master__c> lstNewSection)
{
    if(lstOldSection.size()>0 && lstNewSection.size()>0)
    {
        if(lstOldSection.get(0).Section_Name__c != lstNewSection.get(0).Section_Name__c  || lstOldSection.get(0).Section_Number__c != lstNewSection.get(0).Section_Number__c)
        {    
            List<Business_Continuity_Planning__c> lstJourney = [select id,BCP_Section_Master_Id__c,Section_Name__c,Section_Number__c
                                                                from  Business_Continuity_Planning__c 
                                                                where BCP_Section_Master_Id__c = :lstOldSection.get(0).id
                                                                and wave_plan_version__r.active__c=true 
                                                                and wave_plan_version__r.Display_tracking_message__c=null];
                                                                
            for(Business_Continuity_Planning__c tmpJourney : lstJourney )    
            {
                tmpJourney.Section_Name__c =  lstNewSection.get(0).Section_Name__c;
                tmpJourney.Section_Number__c =  lstNewSection.get(0).Section_Number__c;
            }    
            update lstJourney ;
        }
    }
}


public static void CascadeBusinessTaskChangesOnUpdate(List<BCP_Task_Master__c> lstOldDeliverable, List<BCP_Task_Master__c> lstNewDeliverable)
{
    if(lstOldDeliverable.size()>0 && lstNewDeliverable.size()>0)
    {
        if(lstOldDeliverable.get(0).Task_Name__c != lstNewDeliverable.get(0).Task_Name__c || lstNewDeliverable.get(0).Task_Number__c != lstNewDeliverable.get(0).Task_Number__c)
        {    
            List<Business_Continuity_Planning__c> lstJourney = [select id,BCP_Task_Master_Id__c,Task_Name__c,Task_Number__c
                                                                from  Business_Continuity_Planning__c 
                                                                where BCP_Task_Master_Id__c = :lstOldDeliverable.get(0).id
                                                                and wave_plan_version__r.active__c=true 
                                                                and wave_plan_version__r.Display_tracking_message__c=null];
                                                                
            for(Business_Continuity_Planning__c tmpJourney : lstJourney )    
            {
                tmpJourney.Task_Name__c =  lstNewDeliverable.get(0).Task_Name__c;
                tmpJourney.Task_Number__c =  lstNewDeliverable.get(0).Task_Number__c;
            }    
            update lstJourney ;
        }
    }
}

public static void CascadeTaskMasterChangesOnInsert(List<BCP_Task_Master__c> lstNewDeliverable)
{
    List<Id> lstDelIds = new List<Id>();
    for(BCP_Task_Master__c tmpDel : lstNewDeliverable)
    {
        lstDelIds.add(tmpDel.id);
    }
    List<BCP_Task_Master__c> lstJourneySec = [select Business_Continuity_Planning_del__r.section_name__c,Business_Continuity_Planning_del__r.Section_Number__c
                                                            from BCP_Task_Master__c where id in : lstDelIds] ;
    
    List<Business_Continuity_Planning__c> lstJourney = new List<Business_Continuity_Planning__c>();
    Business_Continuity_Planning__c tmpJourney;
    if(lstNewDeliverable.size()>0)
    {
        List<wave_plan_version__c> lstWavePlanVersion = [select id from wave_plan_version__c
                                                    where active__c=true and Display_tracking_message__c=null ];
                                                            
        for(BCP_Task_Master__c tmpDeliverable : lstNewDeliverable)
        {
            for(Wave_Plan_Version__c wavePlanVersion : lstWavePlanVersion )
            {
                tmpJourney = new Business_Continuity_Planning__c ();
                tmpJourney.Task_Name__c = tmpDeliverable.Task_Name__c;
                tmpJourney.Task_Number__c = tmpDeliverable.Task_Number__c;
                tmpJourney.BCP_Task_Master_Id__c = tmpDeliverable.id;
                tmpJourney.BCP_Section_Master_Id__c = tmpDeliverable.Business_Continuity_Planning_del__c;
                tmpJourney.Section_Name__c = lstJourneySec.get(0).Business_Continuity_Planning_del__r.Section_Name__c;
                tmpJourney.Section_Number__c = lstJourneySec.get(0).Business_Continuity_Planning_del__r.Section_Number__c;
                tmpJourney.Wave_Plan_Version__c = wavePlanVersion.id;
                lstJourney.add(tmpJourney);
            }
            insert lstJourney;
        }        
    }
}


public static void CascadeBusinessTaskChangesOnDelete(List<BCP_Task_Master__c> lstOldDeliverable)
{
    if(lstOldDeliverable.size()>0)
    {
            List<Business_Continuity_Planning__c> lstJourney = [select id,BCP_Task_Master_Id__c,Task_Name__c,Task_Number__c
                                                                from  Business_Continuity_Planning__c 
                                                                where BCP_Task_Master_Id__c = :lstOldDeliverable.get(0).id
                                                                and wave_plan_version__r.active__c=true 
                                                                and wave_plan_version__r.Display_tracking_message__c=null];
        if(lstJourney.size()>0)
        {
            delete lstJourney ;
        }    
    }
}

}