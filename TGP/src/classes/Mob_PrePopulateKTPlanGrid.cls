/*
Dscription : This class populates KT plan grid in High level plan by values in kt plan activity master
             Called by trigger prePopulateTrackings on Wave_planning__c (Deal Wave)
Author : Nilesh Adkar
Story  : Story-0098/MOB_044  


Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
             
*/
public class Mob_PrePopulateKTPlanGrid
{
    public static void insertInKTPlan(List<Wave_Planning__c> lstWavePlan)
    {
        List<KT_Planning__c> lstKTPlan = new List<KT_Planning__c>();
        List<KT_Planning_Activity_Master__c> lstActivity = [select id, name from KT_Planning_Activity_Master__c];
        List<Wave_Planning__c> lstWavePlan2 = [select Deal_Location__r.Wave_Plan_Version__c,Deal_Location__r.Wave_Plan_Version__r.active__c,Deal_Location__r.Wave_Plan_Version__r.cloned_from__c from Wave_Planning__c
                               where id = :lstWavePlan.get(0).id limit 1];
                               
        KT_Planning__c ktPlan;
        List<KT_Planning__c> lstKTPlan2=[Select id,Wave_Plan_Version__r.active__c,
                                        Wave_Plan_Version__r.Display_tracking_message__c,Wave_Plan_Version__c,
                                        Active__c,Activity__c,Deal_Location_lk__c,Planned_Start_Date__c, 
                                        Planned_End_Date__c, Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c, 
                                        Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
                                        Deal_Location_lk__r.Wave_Plan_Version__r.cloned_from__c 
                                        from KT_Planning__c 
                                        where Deal_Location_lk__r.Wave_Plan_Version__C=:lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__C];
        if(lstKTPlan2.size()!=0 || lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__r.cloned_from__c==null)
        {        
            if(lstWavePlan.size()>0)
            {
                if(lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__r.active__c==true)
                {
                List<Deal_Location__c> delLocHomeId=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c where id=:lstWavePlan.get(0).Deal_Location__c];
                List<Wave_Planning__c> dealWaveName=[Select id,name,Wave_Label__c from Wave_Planning__c where id=:lstWavePlan.get(0).id];
            
                    for(KT_Planning_Activity_Master__c tmpActivity : lstActivity )
                    {
                        ktPlan = new KT_Planning__c ();
                        ktPlan.Wave_Plan_lk__c = lstWavePlan.get(0).id;
                        ktPlan.Deal_Location_lk__c = lstWavePlan.get(0).Deal_Location__c;
                        ktPlan.Wave_Plan_Version__c = lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__C;
                        ktPlan.activity__c = tmpActivity.name;
                        ktPlan.KT_Planning_Activity_Master_ID__c = tmpActivity.id;
                        //Added by Vinay Kumar Chada for D-1650
                        ktPlan.Location_Id_Wave_Id__c =String.valueof(lstWavePlan.get(0).Deal_Location__c) + String.valueof(lstWavePlan.get(0).id);
                        ktPlan.Location_Name_Wave_Name__c = delLocHomeId[0].Deal_Home_Location__r.Delivery_Location_Master__r.name + ' - ' + dealWaveName[0].Wave_Label__c; 
                        lstKTPlan.add(ktPlan);
                    }
                    insert lstKTPlan;
                }
            }
        }
    }
    public static void updateInKTPlan(List<Wave_Planning__c> lstWavePlan)
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
                //wpNewIDSet.add(wp.id);
                wpNewIDSet.add(wp.Deal_Location__r.Wave_Plan_Version__C);
            }
            List<KT_Planning__c> lstKTPlan2=[Select id,Wave_Plan_Version__r.active__c,
                                        Wave_Plan_Version__r.Display_tracking_message__c,Wave_Plan_Version__c,
                                        Active__c,Activity__c,Deal_Location_lk__c,Planned_Start_Date__c, 
                                        Planned_End_Date__c, Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c, 
                                        Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
                                        Deal_Location_lk__r.Wave_Plan_Version__r.cloned_from__c 
                                        from KT_Planning__c 
                                        where Deal_Location_lk__r.Wave_Plan_Version__C IN : wpNewIDSet];
            if(lstKTPlan2.size()>0)
            {
            //List<Deal_Location__c> delLocHomeId=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c where id=:lstWavePlan2.get(0).Deal_Location__c];
            //List<Wave_Planning__c> dealWaveName=[Select id,name,Wave_Label__c from Wave_Planning__c where id=:lstWavePlan2.get(0).id];
                 
                List<KT_Planning__c> templstKTPlan = new List<KT_Planning__c>();
                for(Wave_Planning__c wp :lstWavePlan2)
                {
                    for(KT_Planning__c KTPlan :lstKTPlan2)
                    {
                        if(KTPlan.Wave_Plan_lk__c == wp.id)
                        {
                            KTPlan.Wave_Plan_lk__c = wp.id;
                            KTPlan.Deal_Location_lk__c = wp.Deal_Location__c;
                            KTPlan.Wave_Plan_Version__c = wp.Deal_Location__r.Wave_Plan_Version__C;
                            KTPlan.Location_Id_Wave_Id__c =String.valueof(wp.Deal_Location__c) + String.valueof(wp.id);
                            KTPlan.Location_Name_Wave_Name__c = wp.Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name + ' - ' + wp.Wave_Label__c;
                            templstKTPlan.add(KTPlan);
                        }    
                    }
                    update templstKTPlan;
                }    
            }
        }
    }
}