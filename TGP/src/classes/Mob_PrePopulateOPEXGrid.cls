public class Mob_PrePopulateOPEXGrid
{
    public static void insertInOPEX(List<Wave_Planning__c> lstWavePlan)
    {
        /*List<OPEX__C> lstOPEX = new List<OPEX__C>();
        List<OPEX_Item_master__c> lstItem = [select id, item_name__c,Days_After_Go_Live_Date__c from OPEX_Item_master__c where Is_Active__c =: true];
        List<Wave_Planning__c> lstWavePlan2 = [select Deal_Location__r.Wave_Plan_Version__c,Deal_Location__c,
                                                Deal_Location__r.Wave_Plan_Version__r.active__c,
                                                Deal_Location__r.Wave_Plan_Version__r.cloned_from__c,GO_Live_Date_del__c from Wave_Planning__c
                                                where id = :lstWavePlan.get(0).id limit 1];
        OPEX__C opex;
        List<OPEX__C> lstOPEX2=[Select id,OPEX_Item_master_id__c,Item__c ,Wave_Plan_Version__r.active__c,Wave_Plan_Version__r.Display_tracking_message__c,Wave_Plan_Version__c,Active__c,Deal_Location_lk__c,Planned_Date__c,Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Deal_Location_lk__r.Wave_Plan_Version__r.cloned_from__c from OPEX__C where Deal_Location_lk__r.Wave_Plan_Version__C=:lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__C];
        if(lstOPEX2.size()!=0 || lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__r.cloned_from__c==null)
        {        
            if(lstWavePlan.size()>0)
            {
                if(lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__r.active__c==true)
                {
                    for(OPEX_Item_master__c tmpItem : lstItem )
                    {
                        opex = new OPEX__C ();
                        opex.Wave_Plan_lk__c = lstWavePlan2.get(0).id;
                        opex.Deal_Location_lk__c = lstWavePlan2.get(0).Deal_Location__c;
                        opex.Wave_Plan_Version__c = lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__C;
                        opex.Item__c = tmpItem.Item_Name__c;
                        opex.OPEX_Item_master_id__c= tmpItem.id;
                        opex.active__c=true;
                        opex.Planned_Date__c = lstWavePlan2.get(0).GO_Live_Date_del__c.addDays(tmpItem.Days_After_Go_Live_Date__c.intValue());
                        lstOPEX.add(opex);
                    }
                    insert lstOPEX;
                }
            }
        }*/
    }
    public static void updateInOPEX(List<Wave_Planning__c> lstWavePlan)
    {
        set<Id> wpIDSet = new set<Id>();
        set<Id> wpNewIDSet = new set<Id>();
        for(Wave_Planning__c wp :lstWavePlan) {
          wpIDSet.add(wp.id);
        }
        List<Wave_Planning__c> lstWavePlan2 = [select Deal_Location__r.Wave_Plan_Version__c,Deal_Location__c,
                                                Deal_Location__r.Wave_Plan_Version__r.active__c,
                                                Deal_Location__r.Wave_Plan_Version__r.cloned_from__c,
                                                Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name, Wave_Label__c,
                                                GO_Live_Date_del__c from Wave_Planning__c
                                               where id IN : wpIDSet and Deal_Location__r.Wave_Plan_Version__r.Display_tracking_message__c=:null and Deal_Location__r.Wave_Plan_Version__r.active__c=:true limit 100];
        if(lstWavePlan2.size()>0)
        {
             for(Wave_Planning__c wp :lstWavePlan2) {
                wpNewIDSet.add(wp.id);
            }
            List<OPEX__C> lstOPEX=[Select id,OPEX_Item_master_id__c,Item__c ,Wave_Plan_Version__r.active__c,Deal_Wave__c,
                                    Wave_Plan_Version__r.Display_tracking_message__c,Wave_Plan_Version__c,Active__c,
                                    Deal_Location_lk__c,Planned_Date__c,Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c, 
                                    Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
                                    Deal_Location_lk__r.Wave_Plan_Version__r.cloned_from__c,OPEX_Item_master_id__r.Days_After_Go_Live_Date__c from OPEX__C
                                    where Wave_Plan_lk__c  IN : wpNewIDSet];
            if(lstOPEX.size()>0)
            {
                List<OPEX__C> templstOPEX = new List<OPEX__C>();
                //List<Deal_Location__c> delLocHomeId=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c where id=:lstWavePlan2.get(0).Deal_Location__c];
                //List<Wave_Planning__c> dealWaveName=[Select id,name,Wave_Label__c from Wave_Planning__c where id=:lstWavePlan2.get(0).id];
                for(Wave_Planning__c wp :lstWavePlan2)
                {
                    for(OPEX__C tmpOpex : lstOPEX)
                    {
                        if(tmpOpex.Wave_Plan_lk__c == wp.id)
                        {
                            tmpOpex.Wave_Plan_lk__c = wp.id;
                            tmpOpex.Deal_Location_lk__c = wp.Deal_Location__c;
                            tmpOpex.Wave_Plan_Version__c = wp.Deal_Location__r.Wave_Plan_Version__C;
                            tmpOpex.Planned_Date__c = wp.GO_Live_Date_del__c.addDays(tmpOpex.OPEX_Item_master_id__r.Days_After_Go_Live_Date__c.intValue());
                            tmpOpex.Location_Id_Wave_Id__c =String.valueof(wp.Deal_Location__c) + String.valueof(wp.id);
                            tmpOpex.Location_Name_Wave_Name__c = wp.Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name + ' - ' + wp.Wave_Label__c;
                            templstOPEX.add(tmpOpex);
                        }
                    }
                }
                update templstOPEX ;
            }
        }
    }
    
    public static void insertInOPEXForProcess(List<Wave_Process__c> lstWaveProcess)
    {
        List<OPEX__C> lstOPEX = new List<OPEX__C>();
        List<OPEX_Item_master__c> lstItem = [select id, item_name__c,Days_After_Go_Live_Date__c from OPEX_Item_master__c where Is_Active__c =: true];
        
        List<Wave_Process__c> lstWaveProcess2 = [select id,Wave_Planning__c,Wave_Planning__r.Deal_Location__r.Wave_Plan_Version__c,
                                                Wave_Planning__r.Deal_Location__r.Wave_Plan_Version__r.active__c,
                                                Wave_Planning__r.Deal_Location__r.Wave_Plan_Version__r.cloned_from__c,
                                                Wave_Planning__r.GO_Live_Date_del__c 
                                                from Wave_Process__c where id = :lstWaveProcess.get(0).id limit 1];
                               
                                                      
        OPEX__C opex;
        List<OPEX__C> lstOPEX2=[Select id,OPEX_Item_master_id__c,Item__c ,Wave_Plan_Version__r.active__c,
                                Wave_Plan_Version__r.Display_tracking_message__c,Wave_Plan_Version__c,Active__c,
                                Deal_Location_lk__c,Planned_Date__c,Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c,
                                Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
                                Deal_Location_lk__r.Wave_Plan_Version__r.cloned_from__c from OPEX__C 
                                where Deal_Location_lk__r.Wave_Plan_Version__C=:lstWaveProcess2.get(0).Wave_Planning__r.Deal_Location__r.Wave_Plan_Version__C];
        
        if(lstOPEX2.size()!=0 || lstWaveProcess2.get(0).Wave_Planning__r.Deal_Location__r.Wave_Plan_Version__r.cloned_from__c==null)
        {        
            if(lstWaveProcess.size()>0)
            {
                if(lstWaveProcess2.get(0).Wave_Planning__r.Deal_Location__r.Wave_Plan_Version__r.active__c==true)
                {
                 List<Deal_Location__c> delLocHomeId=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c where id=:lstWaveProcess2.get(0).Wave_Planning__r.Deal_Location__c];
                 List<Wave_Planning__c> dealWaveName=[Select id,name,Wave_Label__c from Wave_Planning__c where id=:lstWaveProcess2.get(0).Wave_Planning__c];
                 for(OPEX_Item_master__c tmpItem : lstItem )
                    {
                        opex = new OPEX__C ();
                        opex.Wave_Process__c= lstWaveProcess2.get(0).id;
                        opex.Wave_Plan_lk__c = lstWaveProcess2.get(0).Wave_Planning__c;
                        opex.Deal_Location_lk__c = lstWaveProcess2.get(0).Wave_Planning__r.Deal_Location__c;
                        opex.Wave_Plan_Version__c = lstWaveProcess2.get(0).Wave_Planning__r.Deal_Location__r.Wave_Plan_Version__C;
                        opex.Item__c = tmpItem.Item_Name__c;
                        opex.OPEX_Item_master_id__c= tmpItem.id;
                        opex.active__c=true;
                        opex.Planned_Date__c = lstWaveProcess2.get(0).Wave_Planning__r.GO_Live_Date_del__c.addDays(tmpItem.Days_After_Go_Live_Date__c.intValue());
                        opex.Location_Id_Wave_Id__c =String.valueof(lstWaveProcess2.get(0).Wave_Planning__r.Deal_Location__c) + String.valueof(lstWaveProcess2.get(0).id);
                        opex.Location_Name_Wave_Name__c = delLocHomeId[0].Deal_Home_Location__r.Delivery_Location_Master__r.name + ' - ' + dealWaveName[0].Wave_Label__c;
                        lstOPEX.add(opex);
                    }
                    insert lstOPEX;
                }
            }
        }    
    }
    
}