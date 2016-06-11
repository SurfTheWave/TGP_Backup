public class Mob_CascadeOPEXMasterChanges
{

public static void CascadeItemMasterChangesOnUpdate(List<OPEX_Item_master__c> lstOldItem, List<OPEX_Item_master__c> lstNewItem)
{
    if(lstOldItem.size()>0 && lstNewItem.size()>0)
    {
        if(lstOldItem.get(0).Item_name__c  != lstNewItem.get(0).Item_name__c )
        {    
            List<OPEX__c> lstOPEX = [select id,Item__c from  OPEX__c where Item__c =:lstOldItem.get(0).Item_name__c  and wave_plan_version__r.active__c=true and wave_plan_version__r.Display_tracking_message__c=null];
            for(OPEX__c tmpOPEX : lstOPEX )    
            {
                tmpOPEX.Item__c =  lstNewItem.get(0).Item_name__c ;
                tmpOPEX.OPEX_Item_master_id__c=lstNewItem.get(0).id;                
            }    
            update lstOPEX ;
        }
    }
}


public static void CascadeItemMasterChangesOnInsert(List<OPEX_Item_master__c> lstNewItem)
{
    List<OPEX__c> lstOPEX = new List<OPEX__c>();
    OPEX__c tmpOPEX;
    if(lstNewItem.size()>0)
    {
        List<Wave_Planning__c> lstDealWave = [select id ,GO_Live_Date_del__c,Deal_Location__c, Wave_Plan_Version__c,
                                             Deal_Location__r.Wave_Plan_Version__r.active__c,
                                             Deal_Location__r.Wave_Plan_Version__r.Display_tracking_message__c 
                                             from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__r.active__c = true 
                                             and Deal_Location__r.Wave_Plan_Version__r.Display_tracking_message__c=null];
                                             
        List<Wave_Process__c> lstDealWaveProcess = [select id ,Wave_Planning__r.GO_Live_Date_del__c, Wave_Planning__r.Deal_Location__c, 
                                                    Wave_Planning__r.Deal_Location__r.Wave_Plan_Version__c,Wave_Planning__c,
                                                    Wave_Planning__r.Deal_Location__r.Wave_Plan_Version__r.active__c,
                                                    Wave_Planning__r.Deal_Location__r.Wave_Plan_Version__r.Display_tracking_message__c 
                                                    from Wave_Process__c where Wave_Planning__r.Deal_Location__r.Wave_Plan_Version__r.active__c = true 
                                                    and Wave_Planning__r.Deal_Location__r.Wave_Plan_Version__r.Display_tracking_message__c=null];                                      
                                             
        for(OPEX_Item_master__c tmpItem : lstNewItem)
        {
            for(Wave_Process__c tmpDealWaveProcess : lstDealWaveProcess )
            {
                tmpOPEX = new OPEX__c ();
                tmpOPEX.Wave_Process__c= tmpDealWaveProcess.id ;
                tmpOPEX.Wave_Plan_lk__c = tmpDealWaveProcess.Wave_Planning__c;
                tmpOPEX.Deal_Location_lk__c = tmpDealWaveProcess.Wave_Planning__r.Deal_Location__c;
                tmpOPEX.Wave_Plan_Version__c = tmpDealWaveProcess.Wave_Planning__r.Deal_Location__r.Wave_Plan_Version__c;
                tmpOPEX.Item__c =tmpItem.Item_name__c ;
                tmpOPEX.OPEX_Item_master_id__c=tmpItem.id;
                tmpOPEX.Planned_Date__c = tmpDealWaveProcess.Wave_Planning__r.GO_Live_Date_del__c.addDays(tmpItem.Days_After_Go_Live_Date__c.intValue());
                lstOPEX.add(tmpOPEX);
            }
            insert lstOPEX;
        }        
    }
}


public static void CascadeItemMasterChangesOnDelete(List<OPEX_Item_master__c > lstOldItem)
{
    if(lstOldItem.size()>0)
    {
        List<OPEX__c> lstOPEX = [select id,Item__c,OPEX_Item_master_id__c
                                                    from  OPEX__c
                                                    where Item__c = :lstOldItem.get(0).Item_name__c 
                                                    and wave_plan_version__r.active__c=true 
                                                    and wave_plan_version__r.Display_tracking_message__c=null];
        if(lstOPEX.size()>0)
        {
            delete lstOPEX;
        }    
    }
}
}