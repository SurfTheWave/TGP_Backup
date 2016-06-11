public class Mob_CascadeContractLegalMasterChanges
{

public static void CascadeJourneyMasterChangesOnUpdate(List<Contract_Legal_Infosec_Section_Master__c> lstOldSection, List<Contract_Legal_Infosec_Section_Master__c> lstNewSection)
{
    if(lstOldSection.size()>0 && lstNewSection.size()>0)
    {
        if(lstOldSection.get(0).Section_Name__c != lstNewSection.get(0).Section_Name__c || lstOldSection.get(0).Section_Number__c != lstNewSection.get(0).Section_Number__c)
        {    
            List<Contract_Legal_Infosec__c> lstJourney = [select id,Section_Master_ID__c,Section_Name__c,Section_Number__c
                                                                from  Contract_Legal_Infosec__c 
                                                                where Section_Master_ID__c = :lstOldSection.get(0).id
                                                                and wave_plan_version__r.active__c=true 
                                                                and wave_plan_version__r.Display_tracking_message__c=null];
                                                                
            for(Contract_Legal_Infosec__c tmpJourney : lstJourney )    
            {
                tmpJourney.Section_Name__c =  lstNewSection.get(0).Section_Name__c;
                tmpJourney.Section_Number__c =  lstNewSection.get(0).Section_Number__c;
            }    
            update lstJourney ;
        }
    }
}


public static void CascadeJourneyTaskChangesOnUpdate(List<Contract_Legal_Infosec_Task_Master__c> lstOldTask, List<Contract_Legal_Infosec_Task_Master__c> lstNewTask)
{
    if(lstOldTask.size()>0 && lstNewTask.size()>0)
    {
        if(lstOldTask.get(0).Task_Name__c != lstNewTask.get(0).Task_Name__c || lstOldTask.get(0).Task_Number__c != lstNewTask.get(0).Task_Number__c)
        {    
            List<Contract_Legal_Infosec__c> lstJourney = [select id,Task_Master_ID__c,Task_Name__c,Task_Number__c
                                                                from  Contract_Legal_Infosec__c 
                                                                where Task_Master_ID__c = :lstOldTask.get(0).id
                                                                and wave_plan_version__r.active__c=true 
                                                                and wave_plan_version__r.Display_tracking_message__c=null];
                                                                
            for(Contract_Legal_Infosec__c tmpJourney : lstJourney )    
            {
                tmpJourney.Task_Name__c =  lstNewTask.get(0).Task_Name__c;
                tmpJourney.Task_Number__c =  lstNewTask.get(0).Task_Number__c;
            }    
            update lstJourney ;
        }
    }
}

public static void CascadeTaskMasterChangesOnInsert(List<Contract_Legal_Infosec_Task_Master__c> lstNewTask)
{
    List<Id> lstDelIds = new List<Id>();
    for(Contract_Legal_Infosec_Task_Master__c tmpDel : lstNewTask)
    {
        lstDelIds.add(tmpDel.id);
    }
    List<Contract_Legal_Infosec_Task_Master__c> lstJourneySec = [select Contract_Legal_Infosec_Section_Master__r.section_name__c,Contract_Legal_Infosec_Section_Master__r.section_number__c 
                                                            from Contract_Legal_Infosec_Task_Master__c where id in : lstDelIds] ;
    
    List<Contract_Legal_Infosec__c> lstJourney = new List<Contract_Legal_Infosec__c>();
    Contract_Legal_Infosec__c tmpJourney;
    if(lstNewTask.size()>0)
    {
        List<wave_plan_version__c> lstWavePlanVersion = [select id from wave_plan_version__c
                                                    where active__c=true and Display_tracking_message__c=null];
                                                            
        for(Contract_Legal_Infosec_Task_Master__c tmpTask : lstNewTask)
        {
            for(Wave_Plan_Version__c wavePlanVersion : lstWavePlanVersion )
            {
                tmpJourney = new Contract_Legal_Infosec__c ();
                tmpJourney.Task_Name__c = tmpTask.Task_Name__c;
                tmpJourney.Task_Number__c = tmpTask.Task_Number__c;
                tmpJourney.Task_Master_ID__c = tmpTask.id;
                tmpJourney.Section_Master_ID__c = tmpTask.Contract_Legal_Infosec_Section_Master__c;
                tmpJourney.Section_Name__c = lstJourneySec.get(0).Contract_Legal_Infosec_Section_Master__r.Section_Name__c;
                tmpJourney.Section_Number__c = lstJourneySec.get(0).Contract_Legal_Infosec_Section_Master__r.Section_Number__c;
                tmpJourney.Wave_Plan_Version__c = wavePlanVersion.id;
                lstJourney.add(tmpJourney);
            }
            insert lstJourney;
        }        
    }
}


public static void CascadeJourneyMasterChangesOnDelete(List<Contract_Legal_Infosec_Section_Master__c> lstOldSection)
{
    if(lstOldSection.size()>0)
    {
        List<Contract_Legal_Infosec__c> lstJourney = [select id,Task_Master_ID__c,Task_Name__c,Task_Number__c
                                                        from  Contract_Legal_Infosec__c 
                                                        where Section_Master_ID__c = :String.valueof(lstOldSection.get(0).id)
                                                        and wave_plan_version__r.active__c=true 
                                                        and wave_plan_version__r.Display_tracking_message__c=null];
        if(lstJourney.size()>0)
        {
            delete lstJourney ;
        }    
    }
}

public static void CascadeJourneyTaskChangesOnDelete(List<Contract_Legal_Infosec_Task_Master__c> lstOldTask)
{
    if(lstOldTask.size()>0)
    {
        List<Contract_Legal_Infosec__c> lstJourney = [select id,Task_Master_ID__c,Task_Name__c,Task_Number__c
                                                            from  Contract_Legal_Infosec__c 
                                                            where Task_Master_ID__c = :String.valueof(lstOldTask.get(0).id)
                                                            and wave_plan_version__r.active__c=true 
                                                            and wave_plan_version__r.Display_tracking_message__c=null];
        if(lstJourney.size()>0)
        {
            delete lstJourney ;
        }    
    }
}

}