/*
Author : Rajdeep Bhuiya
Story  : Release 1.7  
Description : Deletion of a High Level Mobilization Plan Logic. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/

public with sharing class VFC_DelWavePlan {

    private static final string CLASS_NAME = 'VFC_DelWavePlan';
    private static final string METHOD_DELETE = 'activateWavePaln';
    public String delId{get;set;}
    public String dealId{get;set;}
    
    /******************************
    Constructor Name: VFC_DelWavePlan
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public VFC_DelWavePlan(ApexPages.StandardController controller) {
        delId=ApexPages.currentPage().getParameters().get('delID');    
    }

    
    /******************************
    Method Name: delWavePaln
    Description: This method will get invoked to delete an High Level Mobilization Plan
    Paramenters: NA
    Return Value: NA
    *******************************/
    public Pagereference delWavePaln(){
       Wave_Plan_Version__c wavePlanVer = new Wave_Plan_Version__c();
       Deal_TGP__c deal = new Deal_TGP__c();
       try{
            List<Wave_Plan_Version__c> wavePlanVerList=[Select Id,Name,Version__c,Active__c,Deal__c, Deal__r.MOB_PMO_Project_ID__c,Deal__r.MOB_PMO_Project_Secondary_2_ID__c,Deal__r.MOB_PMO_Project_Secondary_ID__c,Deal__r.Global_Mobilization_Lead__c,Deal__r.Global_Mobilization_Lead_Secondary__c,Deal__r.Global_Mobilization_Lead_Secondary_2__c from Wave_Plan_Version__c where Id =: delId limit 1];  
            if(wavePlanVerList.size()>0){
               wavePlanVer=wavePlanVerList[0];
               dealId=wavePlanVerList[0].Deal__c;
               
               if( wavePlanVer.Deal__r.MOB_PMO_Project_ID__c==UserInfo.getUserId().substring(0,15) || 
                   wavePlanVer.Deal__r.MOB_PMO_Project_Secondary_2_ID__c==UserInfo.getUserId().substring(0,15) || 
                   wavePlanVer.Deal__r.MOB_PMO_Project_Secondary_ID__c==UserInfo.getUserId().substring(0,15) || 
                   wavePlanVer.Deal__r.Global_Mobilization_Lead__c==UserInfo.getName() || 
                   wavePlanVer.Deal__r.Global_Mobilization_Lead_Secondary__c==UserInfo.getName() || 
                   wavePlanVer.Deal__r.Global_Mobilization_Lead_Secondary_2__c==UserInfo.getName()){
                    
                   List<KT_Planning__c> KTPlanList=[Select Id from KT_Planning__c where Wave_Plan_Version__c=:wavePlanVer.Id];
                   List<OPEX__c> OpexList=[Select Id from OPEX__c where Wave_Plan_Version__c=:wavePlanVer.Id];
                   List<Recruitment_Tracking__c> RecrtTrngList=[Select Id from Recruitment_Tracking__c where Wave_Plan_Version__c=:wavePlanVer.Id];
                   List<SRAT__c> SratList=[Select Id from SRAT__c where Wave_Plan_Version__c=:wavePlanVer.Id];
                   List<Tech_Assessment__c> TechAssmntList=[Select Id from Tech_Assessment__c where Wave_Plan_Version__c=:wavePlanVer.Id];
                    
                   database.delete(KTPlanList);
                   database.delete(OpexList);
                   database.delete(RecrtTrngList);
                   database.delete(SratList);
                   database.delete(TechAssmntList);
                   database.delete(wavePlanVerList);
                }    
            }
        }
        catch(DMLException de){
            UTIL_LoggingService.logHandledException( de, UTIL_Constants.ORG_ID, 
                                                    UTIL_Constants.APPLICATION_NAME, CLASS_NAME, 
                                                    METHOD_DELETE, null, System.Logginglevel.ERROR);
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