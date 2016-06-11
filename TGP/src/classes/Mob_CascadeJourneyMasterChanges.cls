public class Mob_CascadeJourneyMasterChanges
{

public static void CascadeJourneyMasterChangesOnUpdate(List<Journey_Management__c> lstOldSection, List<Journey_Management__c> lstNewSection)
{
    if(lstOldSection.size()>0 && lstNewSection.size()>0)
    {
        if(lstOldSection.get(0).Section_Name__c != lstNewSection.get(0).Section_Name__c || lstOldSection.get(0).Section_Number__c != lstNewSection.get(0).Section_Number__c)
        {    
            List<Journey_Management_Planning__c> lstJourney = [select id,Journey_Management_Id__c,Section_Name__c,Section_Number__c
                                                                from  Journey_Management_Planning__c 
                                                                where Journey_Management_Id__c = :lstOldSection.get(0).id
                                                                and wave_plan_version__r.active__c=true 
                                                                and wave_plan_version__r.Display_tracking_message__c=null];
                                                                
            for(Journey_Management_Planning__c tmpJourney : lstJourney )    
            {
                tmpJourney.Section_Name__c =  lstNewSection.get(0).Section_Name__c;
                tmpJourney.Section_Number__c =  lstNewSection.get(0).Section_Number__c;
            }    
            update lstJourney ;
        }
    }
}


public static void CascadeJourneyDeliverableChangesOnUpdate(List<Journey_Management_Deliverable__c> lstOldDeliverable, List<Journey_Management_Deliverable__c> lstNewDeliverable)
{
    if(lstOldDeliverable.size()>0 && lstNewDeliverable.size()>0)
    {
        if(lstOldDeliverable.get(0).Deliverable_Name__c != lstNewDeliverable.get(0).Deliverable_Name__c || lstOldDeliverable.get(0).Deliverable_Number__c != lstNewDeliverable.get(0).Deliverable_Number__c)
        {    
            List<Journey_Management_Planning__c> lstJourney = [select id,Journey_Management_Deliverable_Id__c,Deliverable_Name__c,Deliverable_Number__c
                                                                from  Journey_Management_Planning__c 
                                                                where Journey_Management_Deliverable_Id__c = :lstOldDeliverable.get(0).id
                                                                and wave_plan_version__r.active__c=true 
                                                                and wave_plan_version__r.Display_tracking_message__c=null];
                                                                
            for(Journey_Management_Planning__c tmpJourney : lstJourney )    
            {
                tmpJourney.Deliverable_Name__c =  lstNewDeliverable.get(0).Deliverable_Name__c;
                tmpJourney.Deliverable_Number__c =  lstNewDeliverable.get(0).Deliverable_Number__c;
            }    
            update lstJourney ;
        }
    }
}

public static void CascadeDeliverableMasterChangesOnInsert(List<Journey_Management_Deliverable__c> lstNewDeliverable)
{
    List<Id> lstDelIds = new List<Id>();
    for(Journey_Management_Deliverable__c tmpDel : lstNewDeliverable)
    {
        lstDelIds.add(tmpDel.id);
    }
    List<Journey_Management_Deliverable__c> lstJourneySec = [select Journey_Management__r.section_name__c,Journey_Management__r.section_number__c 
                                                            from Journey_Management_Deliverable__c where id in : lstDelIds] ;
    
    List<Journey_Management_Planning__c> lstJourney = new List<Journey_Management_Planning__c>();
    Journey_Management_Planning__c tmpJourney;
    if(lstNewDeliverable.size()>0)
    {
        List<wave_plan_version__c> lstWavePlanVersion = [select id from wave_plan_version__c
                                                    where active__c=true and Display_tracking_message__c=null];
                                                            
        for(Journey_Management_Deliverable__c tmpDeliverable : lstNewDeliverable)
        {
            for(Wave_Plan_Version__c wavePlanVersion : lstWavePlanVersion )
            {
                tmpJourney = new Journey_Management_Planning__c ();
                tmpJourney.Deliverable_Name__c = tmpDeliverable.Deliverable_Name__c;
                tmpJourney.Deliverable_Number__c = tmpDeliverable.Deliverable_Number__c;
                tmpJourney.Journey_Management_Deliverable_Id__c = tmpDeliverable.id;
                tmpJourney.Journey_Management_Id__c = tmpDeliverable.Journey_Management__c;
                tmpJourney.Section_Name__c = lstJourneySec.get(0).Journey_Management__r.Section_Name__c;
                tmpJourney.Section_Number__c = lstJourneySec.get(0).Journey_Management__r.Section_Number__c;
                tmpJourney.Wave_Plan_Version__c = wavePlanVersion.id;
                lstJourney.add(tmpJourney);
            }
            insert lstJourney;
        }        
    }
}


public static void CascadeJourneyDeliverableChangesOnDelete(List<Journey_Management_Deliverable__c> lstOldDeliverable)
{
    if(lstOldDeliverable.size()>0)
    {
            List<Journey_Management_Planning__c> lstJourney = [select id,Journey_Management_Deliverable_Id__c,Deliverable_Name__c,Deliverable_Number__c
                                                                from  Journey_Management_Planning__c 
                                                                where Journey_Management_Deliverable_Id__c = :lstOldDeliverable.get(0).id
                                                                and wave_plan_version__r.active__c=true 
                                                                and wave_plan_version__r.Display_tracking_message__c=null];
        if(lstJourney.size()>0)
        {
            delete lstJourney ;
        }    
    }
}

}