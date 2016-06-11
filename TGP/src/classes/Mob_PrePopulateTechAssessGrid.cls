public class Mob_PrePopulateTechAssessGrid
{
    public static void insertInTechAssess(List<Wave_Planning__c> lstWavePlan)
    {
        List<Tech_Assessment__c> lstTechAssess = new List<Tech_Assessment__c>();
        List<Tech_Assessment_Activity_Master__c> lstActivity = [select id, name from Tech_Assessment_Activity_Master__c where Is_Active__c =: true];
        List<Wave_Planning__c> lstWavePlan2 = [select Deal_Location__r.Wave_Plan_Version__c,Deal_Location__r.Wave_Plan_Version__r.active__c,Deal_Location__r.Wave_Plan_Version__r.cloned_from__c from Wave_Planning__c
                               where id = :lstWavePlan.get(0).id limit 1];
        Tech_Assessment__c techAssess;
        List<Tech_Assessment__c> lstTechAssess2=[Select id,Wave_Plan_Version__r.active__c,
                                                Wave_Plan_Version__r.Display_tracking_message__c,Wave_Plan_Version__c,Active__c,Activity__c,
                                                Deal_Location_lk__c,Planned_Start_Date__c, Planned_End_Date__c, Wave_Plan_lk__c, 
                                                Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
                                                Deal_Location_lk__r.Wave_Plan_Version__r.cloned_from__c 
                                                from Tech_Assessment__c 
                                                where Deal_Location_lk__r.Wave_Plan_Version__C=:lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__C];
        if(lstTechAssess2.size()!=0 || lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__r.cloned_from__c==null)
        {        
            if(lstWavePlan.size()>0)
            {
                if(lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__r.active__c==true)
                {
                List<Deal_Location__c> delLocHomeId=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c where id=:lstWavePlan.get(0).Deal_Location__c];
                List<Wave_Planning__c> dealWaveName=[Select id,name,Wave_Label__c from Wave_Planning__c where id=:lstWavePlan.get(0).id];
                    for(Tech_Assessment_Activity_Master__c tmpActivity : lstActivity )
                    {
                        techAssess = new Tech_Assessment__c ();
                        techAssess.Wave_Plan_lk__c = lstWavePlan.get(0).id;
                        techAssess.Deal_Location_lk__c = lstWavePlan.get(0).Deal_Location__c;
                        techAssess.Wave_Plan_Version__c = lstWavePlan2.get(0).Deal_Location__r.Wave_Plan_Version__C;
                        techAssess.activity__c = tmpActivity.name;
                        techAssess.Tech_Assessment_Activity_Master_ID__c = tmpActivity.id;
                        techAssess.Location_Id_Wave_Id__c =String.valueof(lstWavePlan.get(0).Deal_Location__c) + String.valueof(lstWavePlan.get(0).id);
                        techAssess.Location_Name_Wave_Name__c = delLocHomeId[0].Deal_Home_Location__r.Delivery_Location_Master__r.name + ' - ' + dealWaveName[0].Wave_Label__c; 
                        lstTechAssess.add(techAssess);
                    }
                    insert lstTechAssess;
                }
            }
        }
    }
    public static void updateInTechAssess(List<Wave_Planning__c> lstWavePlan)
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
            List<Tech_Assessment__c> lstTechAssess2=[Select id,Wave_Plan_Version__r.active__c,
                                                Wave_Plan_Version__r.Display_tracking_message__c,Wave_Plan_Version__c,Active__c,Activity__c,
                                                Deal_Location_lk__c,Planned_Start_Date__c, Planned_End_Date__c, Wave_Plan_lk__c, 
                                                Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
                                                Deal_Location_lk__r.Wave_Plan_Version__r.cloned_from__c 
                                                from Tech_Assessment__c 
                                                where Deal_Location_lk__r.Wave_Plan_Version__C IN : wpNewIDSet];
            if(lstTechAssess2.size()>0)
            {
            //List<Deal_Location__c> delLocHomeId=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c where id=:lstWavePlan2.get(0).Deal_Location__c];
            //List<Wave_Planning__c> dealWaveName=[Select id,name,Wave_Label__c from Wave_Planning__c where id=:lstWavePlan2.get(0).id];
                 
                List<Tech_Assessment__c> tempTechAssess = new List<Tech_Assessment__c>();
                for(Wave_Planning__c wp :lstWavePlan2) {
                    for(Tech_Assessment__c TechAssess :lstTechAssess2)
                    {
                        if(TechAssess.Wave_Plan_lk__c == wp.id) {
                            TechAssess.Wave_Plan_lk__c = wp.id;
                            TechAssess.Deal_Location_lk__c = wp.Deal_Location__c;
                            TechAssess.Wave_Plan_Version__c = wp.Deal_Location__r.Wave_Plan_Version__C;
                            TechAssess.Location_Id_Wave_Id__c =String.valueof(wp.Deal_Location__c) + String.valueof(wp.id);
                            TechAssess.Location_Name_Wave_Name__c = wp.Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name + ' - ' + wp.Wave_Label__c;
                            tempTechAssess.add(TechAssess);
                       }
                    }
                }
                update tempTechAssess;
            }
        }
    }
}