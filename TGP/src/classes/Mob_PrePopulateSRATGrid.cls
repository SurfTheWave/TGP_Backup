public class Mob_PrePopulateSRATGrid
{
    public static void insertInSRAT(List<Wave_Planning__c> lstWavePlan)
    {
        List<SRAT__C> lstSRAT = new List<SRAT__C>();
        List<SRAT_Item_master__c> lstItem = [select id, item_name__c,Days_Before_Go_Live_Date__c from SRAT_Item_master__c where Is_Active__c =: true];
        List<Wave_Planning__c> lstWavePlan2 = [select Deal_Location__r.Wave_Plan_Version__c,Deal_Location__r.Wave_Plan_Version__r.active__c,Deal_Location__r.Wave_Plan_Version__r.cloned_from__c,GO_Live_Date_del__c from Wave_Planning__c
                               where id = :lstWavePlan.get(0).id limit 1];
        List<SRAT_VERSION__c> lstSratVersion=[select SRAT_Name__c, id, name from SRAT_VERSION__c where isActive__c=:true];
        SRAT__C srat;
        List<SRAT__C> lstSRAT2=[Select id,SRAT_Item_master_id__c,Item__c ,Wave_Plan_Version__r.active__c,
                                Wave_Plan_Version__r.Display_tracking_message__c,Wave_Plan_Version__c,Active__c,
                                Deal_Location_lk__c,Planned_Date__c,Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c,
                                Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
                                Deal_Location_lk__r.Wave_Plan_Version__r.cloned_from__c,SRAT_Version__c 
                                from SRAT__C 
                                where Deal_Location_lk__r.Wave_Plan_Version__C=:lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__C];
        if(lstSRAT2.size()!=0 || lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__r.cloned_from__c==null)
        {        
            if(lstWavePlan.size()>0)
            {
                if(lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__r.active__c==true)
                {
                 List<Deal_Location__c> delLocHomeId=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c where id=:lstWavePlan.get(0).Deal_Location__c];
                 List<Wave_Planning__c> dealWaveName=[Select id,name,Wave_Label__c from Wave_Planning__c where id=:lstWavePlan.get(0).id];
                    for(SRAT_Item_master__c tmpItem : lstItem )
                    {
                        srat = new SRAT__C ();
                        srat.Wave_Plan_lk__c = lstWavePlan.get(0).id;
                        srat.Deal_Location_lk__c = lstWavePlan.get(0).Deal_Location__c;
                        srat.Wave_Plan_Version__c = lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__C;
                        srat.Item__c = tmpItem.Item_Name__c;
                        srat.SRAT_Item_master_id__c= tmpItem.id;
                        srat.active__c=true;
                        srat.Planned_Date__c = lstWavePlan2.get(0).GO_Live_Date_del__c.addDays(tmpItem.Days_Before_Go_Live_Date__c.intValue());
                        srat.Location_Id_Wave_Id__c =String.valueof(lstWavePlan.get(0).Deal_Location__c) + String.valueof(lstWavePlan.get(0).id);
                        srat.Location_Name_Wave_Name__c = delLocHomeId[0].Deal_Home_Location__r.Delivery_Location_Master__r.name + ' - ' + dealWaveName[0].Wave_Label__c;
                        if(lstSratVersion.size()>0)
                            srat.SRAT_Version__c = lstSratVersion.get(0).id;
                        lstSRAT.add(srat);
                    }
                    insert lstSRAT;
                }
            }
        }
    } 
    public static void updateInSRAT(List<Wave_Planning__c> lstWavePlan)
    {
        set<Id> wpIDSet = new set<Id>();
        set<Id> wpNewIDSet = new set<Id>();
        for(Wave_Planning__c wp :lstWavePlan) {
          wpIDSet.add(wp.id);
        }
        List<Wave_Planning__c> lstWavePlan2 = [select Deal_Location__r.Wave_Plan_Version__c,Deal_Location__r.Wave_Plan_Version__r.active__c,Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name, Wave_Label__c,Deal_Location__r.Wave_Plan_Version__r.cloned_from__c,GO_Live_Date_del__c from Wave_Planning__c
                               where id IN : wpIDSet and Deal_Location__r.Wave_Plan_Version__r.Display_tracking_message__c=:null and Deal_Location__r.Wave_Plan_Version__r.active__c=:true limit 100];
                                                      
        if(lstWavePlan2.size()>0)
        {
            for(Wave_Planning__c wp :lstWavePlan2) {
                wpNewIDSet.add(wp.id);
            }
            List<SRAT__C> lstSRAT=[select id,SRAT_Item_master_id__c,Item__c ,Wave_Plan_Version__r.active__c,
                                    Wave_Plan_Version__r.Display_tracking_message__c,Wave_Plan_Version__c,Active__c,
                                    Deal_Location_lk__c,Planned_Date__c,Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c, 
                                    Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
                                    Deal_Location_lk__r.Wave_Plan_Version__r.cloned_from__c,SRAT_Item_master_id__r.Days_Before_Go_Live_Date__c from SRAT__C 
                                    where Wave_Plan_lk__c IN : wpNewIDSet];
            if(lstSRAT.size()>0)
            {
            //List<Deal_Location__c> delLocHomeId=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c where id=:lstWavePlan2.get(0).Deal_Location__c];
            //List<Wave_Planning__c> dealWaveName=[Select id,name,Wave_Label__c from Wave_Planning__c where id=:lstWavePlan2.get(0).id];
                 
                List<SRAT__C> templstSRAT = new List<SRAT__C>();
                for(Wave_Planning__c wp :lstWavePlan2)
                {
                    for(SRAT__C srat :lstSRAT)
                    {
                        if(srat.Wave_Plan_lk__c == wp.id) {
                            srat.Wave_Plan_lk__c = wp.id;
                            srat.Deal_Location_lk__c = wp.Deal_Location__c;
                            srat.Wave_Plan_Version__c = wp.Deal_Location__r.Wave_Plan_Version__C;
                            if(srat.SRAT_Item_master_id__r.Days_Before_Go_Live_Date__c != null)
                            {
                                srat.Planned_Date__c = wp.GO_Live_Date_del__c.addDays(srat.SRAT_Item_master_id__r.Days_Before_Go_Live_Date__c.intValue());
                            }else{ 
                                String temp = srat.Item__c.substring(7);
                                Integer numTemp = Integer.ValueOf(temp);                   
                                srat.Planned_Date__c = wp.GO_Live_Date_del__c.addDays(-numTemp);
                             } 
                            srat.Location_Id_Wave_Id__c =String.valueof(wp.Deal_Location__c) + String.valueof(wp.id);
                            srat.Location_Name_Wave_Name__c = wp.Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name + ' - ' + wp.Wave_Label__c;
                            templstSRAT.add(srat);
                        }
                    }
                    update templstSRAT;
                }
            }
        }
    }
}