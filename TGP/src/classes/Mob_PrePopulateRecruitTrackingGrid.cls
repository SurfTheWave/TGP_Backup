public class Mob_PrePopulateRecruitTrackingGrid
{
    public static void insertInRecruitmentTracking(List<Wave_Planning__c> lstWavePlan)
    {
        List<Recruitment_Tracking__c> lstRecruit = new List<Recruitment_Tracking__c>();
        List<Activity_Master__c> lstActivity = [select id, name from Activity_Master__c where Is_Active__c =: true];
        List<Wave_Planning__c> lstWavePlan2 = [select Deal_Location__r.Wave_Plan_Version__c,Deal_Location__r.Wave_Plan_Version__r.active__c,Deal_Location__r.Wave_Plan_Version__r.cloned_from__c from Wave_Planning__c
                               where id = :lstWavePlan.get(0).id limit 1];
                               
        Recruitment_Tracking__c recruit;
        List<Recruitment_Tracking__c> lstRecruit2=[Select id,Wave_Plan_Version__r.active__c,
        Wave_Plan_Version__r.Display_tracking_message__c,Wave_Plan_Version__c,FTE_Number__c,Active__c,
        Activity__c,Deal_Location_lk__c,Planned_Start_Date__c, Planned_End_Date__c, Wave_Plan_lk__c, 
        Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
        Deal_Location_lk__r.Wave_Plan_Version__r.cloned_from__c 
        from Recruitment_Tracking__c 
        where Deal_Location_lk__r.Wave_Plan_Version__C=:lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__C];
        if(lstRecruit2.size()!=0 || lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__r.cloned_from__c==null)
        {        
            if(lstWavePlan.size()>0)
            {
                if(lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__r.active__c==true)
                {
                List<Deal_Location__c> delLocHomeId=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c where id=:lstWavePlan.get(0).Deal_Location__c];
                List<Wave_Planning__c> dealWaveName=[Select id,name,Wave_Label__c from Wave_Planning__c where id=:lstWavePlan.get(0).id];
                    for(Activity_Master__c tmpActivity : lstActivity )
                    {
                        recruit = new Recruitment_Tracking__c ();
                        recruit.Wave_Plan_lk__c = lstWavePlan.get(0).id;
                        recruit.Deal_Location_lk__c = lstWavePlan.get(0).Deal_Location__c;
                        recruit.Wave_Plan_Version__c = lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__C;
                        recruit.activity__c = tmpActivity.name;
                        recruit.Activity_Master_ID__c = tmpActivity.id;
                        recruit.Location_Id_Wave_Id__c =String.valueof(lstWavePlan.get(0).Deal_Location__c) + String.valueof(lstWavePlan.get(0).id);
                        recruit.Location_Name_Wave_Name__c = delLocHomeId[0].Deal_Home_Location__r.Delivery_Location_Master__r.name + ' - ' + dealWaveName[0].Wave_Label__c; 
                        lstRecruit.add(recruit);
                    }
                    insert lstRecruit;
                }
            }
        }
    }
    
    public static void updateInRecruitTracking(List<Wave_Planning__c> lstWavePlan)
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
            List<Recruitment_Tracking__c> lstRecTrack=[Select id,Wave_Plan_Version__r.active__c,
            Wave_Plan_Version__r.Display_tracking_message__c,Wave_Plan_Version__c,FTE_Number__c,Active__c,
            Activity__c,Deal_Location_lk__c,Planned_Start_Date__c, Planned_End_Date__c, Wave_Plan_lk__c, 
            Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
            Deal_Location_lk__r.Wave_Plan_Version__r.cloned_from__c 
            from Recruitment_Tracking__c 
            where Wave_Plan_lk__c IN : wpNewIDSet];
            if(lstRecTrack.size()>0)
            {
            //List<Deal_Location__c> delLocHomeId=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c where id=:lstWavePlan2.get(0).Deal_Location__c];
            //List<Wave_Planning__c> dealWaveName=[Select id,name,Wave_Label__c from Wave_Planning__c where id=:lstWavePlan2.get(0).id];
                 
                List<Recruitment_Tracking__c> templstRecTrack = new List<Recruitment_Tracking__c>();
                for(Wave_Planning__c wp :lstWavePlan2)
                {
                    for(Recruitment_Tracking__c RecTrack :lstRecTrack)
                    {
                        if(RecTrack.Wave_Plan_lk__c == wp.id) {
                            RecTrack.Wave_Plan_lk__c = wp.id;
                            RecTrack.Deal_Location_lk__c = wp.Deal_Location__c;
                            RecTrack.Wave_Plan_Version__c = wp.Deal_Location__r.Wave_Plan_Version__C;
                            /* if(RecTrack.SRAT_Item_master_id__r.Days_Before_Go_Live_Date__c != null)
                            {
                                RecTrack.Planned_Date__c = wp.GO_Live_Date_del__c.addDays(RecTrack.SRAT_Item_master_id__r.Days_Before_Go_Live_Date__c.intValue());
                            }else{ 
                                String temp = RecTrack.Item__c.substring(7);
                                Integer numTemp = Integer.ValueOf(temp);                   
                                RecTrack.Planned_Date__c = wp.GO_Live_Date_del__c.addDays(-numTemp);
                             } */ 
                            RecTrack.Location_Id_Wave_Id__c =String.valueof(wp.Deal_Location__c) + String.valueof(wp.id);
                            RecTrack.Location_Name_Wave_Name__c = wp.Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name + ' - ' + wp.Wave_Label__c;
                            templstRecTrack.add(RecTrack);
                        }
                    }
                    update templstRecTrack;
                }
            }
        }
    }
}