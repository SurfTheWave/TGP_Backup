/*
Author : Rajdeep Bhuiya
Story  : Release 1.7  
Description : Activation of most recent High Level Mobilization Plan Logic. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
*/
public with sharing class VFC_ActivateWavePlan {
    private static final string CLASS_NAME = 'VFC_ActivateWavePlan';
    private static final string METHOD_ACTIVATE = 'activateWavePaln';
    public String dealId{get;set;}
    
    /******************************
    Constructor Name: VFC_ActivateWavePlan
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public VFC_ActivateWavePlan(ApexPages.StandardController controller) {
        dealId=ApexPages.currentPage().getParameters().get('dealId');
    }
    
    /******************************
    Method Name: activateWavePaln
    Description: This method will get invoked to activate the most recent High Level Mobilization Plan
    Paramenters: NA
    Return Value: NA
    *******************************/
    public Pagereference activateWavePaln(){
       Wave_Plan_Version__c wavePlanVer = new Wave_Plan_Version__c();
       try{
            List<Wave_Plan_Version__c> wavePlanVerList=[Select Id,Name,Version__c,Active__c,Deal__c, Deal__r.MOB_PMO_Project_ID__c,Deal__r.MOB_PMO_Project_Secondary_2_ID__c,Deal__r.MOB_PMO_Project_Secondary_ID__c,Deal__r.Global_Mobilization_Lead__c,Deal__r.Global_Mobilization_Lead_Secondary__c,Deal__r.Global_Mobilization_Lead_Secondary_2__c from Wave_Plan_Version__c where Deal__c =: dealId order by Version__c desc limit 1];  
            if(wavePlanVerList.size()>0){
               wavePlanVer=wavePlanVerList[0];
               if( wavePlanVer.Deal__r.MOB_PMO_Project_ID__c==UserInfo.getUserId().substring(0,15) || 
                   wavePlanVer.Deal__r.MOB_PMO_Project_Secondary_2_ID__c==UserInfo.getUserId().substring(0,15) || 
                   wavePlanVer.Deal__r.MOB_PMO_Project_Secondary_ID__c==UserInfo.getUserId().substring(0,15) || 
                   wavePlanVer.Deal__r.Global_Mobilization_Lead__c==UserInfo.getName() || 
                   wavePlanVer.Deal__r.Global_Mobilization_Lead_Secondary__c==UserInfo.getName() || 
                   wavePlanVer.Deal__r.Global_Mobilization_Lead_Secondary_2__c==UserInfo.getName()){
                   
                   if(!wavePlanVer.Active__c){
                       wavePlanVer.Active__c=true;
                       database.update(wavePlanVer);
                   }    
                }
            }
        }
        catch(DMLException de){
           UTIL_LoggingService.logHandledException( de, UTIL_Constants.ORG_ID, 
                                                    UTIL_Constants.APPLICATION_NAME, CLASS_NAME, 
                                                    METHOD_ACTIVATE, null, System.Logginglevel.ERROR);
        }
        DealWaveTriggerController dwTrigger = new DealWaveTriggerController();
        List<Wave_Planning__c> wavePlanList=[Select Deal_Location__c,Deal_Location__r.Wave_Plan_Version__r.Deal__c From Wave_Planning__c Where Deal_Location__r.Wave_Plan_Version__r.Deal__c =:dealId];
        if(!wavePlanList.isEmpty()){
            dwTrigger.UpdateTotalFTEsOnDeal(wavePlanList);
        }
        else{
            Decimal count =0;
            Deal_TGP__c dealUpdatedList = new Deal_TGP__c();
            dealUpdatedList = [SELECT Name,Total_No_Of_Projected_FTEs__c from Deal_TGP__c where id =: dealId limit 1];
            dealUpdatedList.Total_No_Of_Projected_FTEs__c = count;
            if(dealUpdatedList!=null) {
                database.update(dealUpdatedList);
            }
        }
        Pagereference pageRef = new PageReference('/'+dealId);
        pageRef.setRedirect(true);
        return pageRef;
    }
}