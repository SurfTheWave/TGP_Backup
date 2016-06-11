public class Mob_CascadeSRATMasterChanges
{

public static void CascadeItemMasterChangesOnUpdate(List<SRAT_Item_master__c> lstOldItem, List<SRAT_Item_master__c> lstNewItem)
{
    if(lstOldItem.size()>0 && lstNewItem.size()>0)
    {
        if(lstOldItem.get(0).Item_name__c  != lstNewItem.get(0).Item_name__c )
        {    
            List<SRAT__c> lstSRAT = [select id,Item__c , Days_Before_Go_Live_Date__c from  SRAT__c where Item__c =:lstOldItem.get(0).Item_name__c  and wave_plan_version__r.active__c=true and wave_plan_version__r.Display_tracking_message__c=null];
            for(SRAT__c tmpSRAT : lstSRAT )    
            {
                tmpSRAT.Item__c =  lstNewItem.get(0).Item_name__c ;
                tmpSRAT.SRAT_Item_master_id__c= lstNewItem.get(0).id;  
              	tmpSRAT.Days_Before_Go_Live_Date__c =  lstNewItem.get(0).Days_Before_Go_Live_Date__c;          
            }    
            update lstSRAT ;
        }
    }
}


public static void CascadeItemMasterChangesOnInsert(List<SRAT_Item_master__c> lstNewItem)
{
    List<SRAT__c> lstSRAT = new List<SRAT__c>();
    SRAT__c tmpSRAT;
    if(lstNewItem.size()>0)
    {
        List<Wave_Planning__c> lstDealWave = [select id ,GO_Live_Date_del__c,Deal_Location__c, Wave_Plan_Version__c,Deal_Location__r.Wave_Plan_Version__r.active__c,Deal_Location__r.Wave_Plan_Version__r.Display_tracking_message__c from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__r.active__c = true and Deal_Location__r.Wave_Plan_Version__r.Display_tracking_message__c=null];
        for(SRAT_Item_master__c tmpItem : lstNewItem)
        {
            for(Wave_Planning__c tmpDealWave : lstDealWave )
            {
                tmpSRAT = new SRAT__c ();
                tmpSRAT.Wave_Plan_lk__c = tmpDealWave.id ;
                tmpSRAT.Deal_Location_lk__c = tmpDealWave.Deal_Location__c;
                tmpSRAT.Wave_Plan_Version__c = tmpDealWave.Deal_Location__r.Wave_Plan_Version__C;
                tmpSRAT.Item__c =tmpItem.Item_name__c ;
                tmpSRAT.SRAT_Item_master_id__c=tmpItem.id;
                tmpSRAT.Planned_Date__c = tmpDealWave.GO_Live_Date_del__c.addDays(tmpItem.Days_Before_Go_Live_Date__c.intValue());
                tmpSRAT.Days_Before_Go_Live_Date__c =  tmpItem.Days_Before_Go_Live_Date__c;   
                lstSRAT.add(tmpSRAT);
            }
            insert lstSRAT;
        }        
    }
}


public static void CascadeItemMasterChangesOnDelete(List<SRAT_Item_master__c > lstOldItem)
{
    if(lstOldItem.size()>0)
    {
        List<SRAT__c> lstSRAT = [select id,Item__c,SRAT_Item_master_id__c
                                                    from  SRAT__c
                                                    where Item__c = :lstOldItem.get(0).Item_name__c 
                                                    and wave_plan_version__r.active__c=true 
                                                    and wave_plan_version__r.Display_tracking_message__c=null];
        if(lstSRAT.size()>0)
        {
            delete lstSRAT;
        }    
    }
}
}