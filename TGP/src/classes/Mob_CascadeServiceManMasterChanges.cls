public class Mob_CascadeServiceManMasterChanges
{

public static void CascadeServiceManMasterChangesOnUpdate(List<Service_Management_Master__c> lstOldSection, List<Service_Management_Master__c> lstNewSection)
{
    if(lstOldSection.size()>0 && lstNewSection.size()>0)
    {
        if(lstOldSection.get(0).Phase_Name__c != lstNewSection.get(0).Phase_Name__c || lstOldSection.get(0).Phase_Number__c != lstNewSection.get(0).Phase_Number__c)
        {    
            List<Service_Management__c> lstJourney = [select id,Phase_ID__c,Phase_Name__c,Phase_Number__c
                                                                from  Service_Management__c 
                                                                where Phase_ID__c= :lstOldSection.get(0).id
                                                                and wave_plan_version__r.active__c=true 
                                                                and wave_plan_version__r.Display_tracking_message__c=null];
                                                                
            for(Service_Management__c tmpJourney : lstJourney )    
            {
                tmpJourney.Phase_Name__c =  lstNewSection.get(0).Phase_Name__c;
                tmpJourney.Phase_Number__c =  lstNewSection.get(0).Phase_Number__c;
            }    
            update lstJourney ;
        }
    }
}


public static void CascadeJourneyDeliverableChangesOnUpdate(List<Service_Management_Task_Master__c> lstOldDeliverable, List<Service_Management_Task_Master__c> lstNewDeliverable)
{
    if(lstOldDeliverable.size()>0 && lstNewDeliverable.size()>0)
    {
        if(lstOldDeliverable.get(0).Task_Name__c!= lstNewDeliverable.get(0).Task_Name__c|| lstOldDeliverable.get(0).Task_Number__c != lstNewDeliverable.get(0).Task_Number__c)
        {    
            List<Service_Management__c> lstJourney = [select id,Task_ID__c,Task_Name__c,Task_Number__c
                                                                from  Service_Management__c 
                                                                where Task_ID__c = :lstOldDeliverable.get(0).id
                                                                and wave_plan_version__r.active__c=true 
                                                                and wave_plan_version__r.Display_tracking_message__c=null];
                                                                
            for(Service_Management__c tmpJourney : lstJourney )    
            {
                tmpJourney.Task_Name__c=  lstNewDeliverable.get(0).Task_Name__c;
                tmpJourney.Task_Number__c =  lstNewDeliverable.get(0).Task_Number__c;
            }    
            update lstJourney ;
        }
    }
}

public static void CascadeDeliverableMasterChangesOnInsert(List<Service_Management_Task_Master__c> lstNewDeliverable)
{
    List<Id> lstDelIds = new List<Id>();
    for(Service_Management_Task_Master__c tmpDel : lstNewDeliverable)
    {
        lstDelIds.add(tmpDel.id);
    }
    List<Service_Management_Task_Master__c> lstJourneySec = [select Service_Management_Phase__r.Phase_Name__c,Service_Management_Phase__r.Phase_Number__c 
                                                            from Service_Management_Task_Master__c where id in : lstDelIds] ;
    
    List<Service_Management__c> lstJourney = new List<Service_Management__c>();
    Service_Management__c tmpJourney;
    if(lstNewDeliverable.size()>0)
    {
        List<wave_plan_version__c> lstWavePlanVersion = [select id from wave_plan_version__c
                                                    where active__c=true and Display_tracking_message__c=null ];
                                                            
        for(Service_Management_Task_Master__c tmpDeliverable : lstNewDeliverable)
        {
            for(Wave_Plan_Version__c wavePlanVersion : lstWavePlanVersion )
            {
                tmpJourney = new Service_Management__c ();
                tmpJourney.Task_Name__c= tmpDeliverable.Task_Name__c;
                tmpJourney.Task_Number__c = tmpDeliverable.Task_Number__c;
                tmpJourney.Task_ID__c = tmpDeliverable.id;
                tmpJourney.Phase_ID__c = tmpDeliverable.Service_Management_Phase__c;
                tmpJourney.Phase_Name__c = lstJourneySec.get(0).Service_Management_Phase__r.Phase_Name__c;
                tmpJourney.Phase_Number__c = lstJourneySec.get(0).Service_Management_Phase__r.Phase_Number__c;
                tmpJourney.Wave_Plan_Version__c = wavePlanVersion.id;
                lstJourney.add(tmpJourney);
            }
            insert lstJourney;
        }        
    }
}


public static void CascadeJourneyDeliverableChangesOnDelete(List<Service_Management_Task_Master__c> lstOldDeliverable)
{
    if(lstOldDeliverable.size()>0)
    {
            List<Service_Management__c> lstJourney = [select id,Task_ID__c,Task_Name__c,Task_Number__c
                                                                from  Service_Management__c 
                                                                where Task_ID__c = :lstOldDeliverable.get(0).id
                                                                and wave_plan_version__r.active__c=true 
                                                                and wave_plan_version__r.Display_tracking_message__c=null];
        if(lstJourney.size()>0)
        {
            delete lstJourney ;
        }    
    }
}

}