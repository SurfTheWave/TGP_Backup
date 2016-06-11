/*
@Author and Created Date : Goudar Devanna,  1/15/2015 12:01 AM
@name : OpexTrackerLevel1 
@Description : 
@Version : 
*/
trigger OpexTrackerLevel1 on Deal_OPEX_Additional_Tracking_Level_1__c (after insert, after update, before insert, before update) {

List<Deal_OPEX_Additional_Tracking_Level_1__c> lstNewOpexLevel1 = Trigger.new;
List<Deal_OPEX_Additional_Tracking_Level_1__c> lstOldOpexLevel1 = Trigger.old;

List<Deal_OPEX_Additional_Tracking_Level_1__c> lstOpexTrackerLevel1 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
List<Deal_OPEX_Additional_Tracking_Level_1__c> lstOTL1 = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
Boolean StabilityScoreFlag = FALSE;
Boolean L2StabilityscoreFlag = FALSE;

OpexTrackerClass OTclass = new OpexTrackerClass();
UAMSWBMWBUtility uamUtility= new UAMSWBMWBUtility();

     if(trigger.isAfter && trigger.isUpdate)
    {
        
        for(Deal_OPEX_Additional_Tracking_Level_1__c opexTrackerLevel1: trigger.new)
        {
            if(opexTrackerLevel1.Stability_Score__c != Trigger.oldMap.get(opexTrackerLevel1.id).Stability_Score__c)
            {      
                lstOpexTrackerLevel1.add(opexTrackerLevel1);
                StabilityScoreFlag = TRUE;
            }
            
            if(opexTrackerLevel1.Level_2_Stability_Score_Count__c != 0 && (opexTrackerLevel1.Level_2_Stability_Score_Count__c != Trigger.oldMap.get(opexTrackerLevel1.id).Level_2_Stability_Score_Count__c) )
            {
                lstOTL1.add(opexTrackerLevel1);
                L2StabilityscoreFlag = TRUE;
            }
            
        }
        
        if(StabilityScoreFlag == TRUE)
        {
            OTclass.UpdateOpexOverallScore(lstOpexTrackerLevel1);
        }
        
        if(L2StabilityscoreFlag == TRUE)
        {
            OTclass.UpdateOpexChecklistStatus(lstOTL1);
        }
    }
    
    if(Trigger.isAfter && Trigger.isInsert){           
         OTclass.UpdateOpexOverallScore(trigger.new); 
    }
}