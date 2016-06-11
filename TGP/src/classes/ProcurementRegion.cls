/**
    @Author : Shivraj.gangabyraiah
    @name:  ProcurementRegion
    @CreateDate :  2/21/2015
    @Description: This class contains all methods to insert region wise activty item records, it is called from procurement region trigger
    @Version: 1.0
    @reference: None
*/
public without sharing class ProcurementRegion {
    
    /**
    @Author : Shivraj.gangabyraiah
    @name:  createRegionWise
    @CreateDate :  2/21/2015
    @Description: This method creates region wise activity records for each procurement region
    */
    public static void createRegionWise(List<Procurement_Wave_Region__c> procRegionList){
        List<Procurement_Region_Wise_Activity_Item__c> regionWiseList = new List<Procurement_Region_Wise_Activity_Item__c>();
        Procurement_Region_Wise_Activity_Item__c prItem=null;
        try{
            for(Procurement_Wave_Region__c pr:procRegionList){
                for(Procurement_Region_Wise_Activity_Master__c prmaster:[select id,name,Active__c,Activity_Description__c,Activity_Order__c,Type__c FROM 
                Procurement_Region_Wise_Activity_Master__c WHERE Active__c=true LIMIT 2000]){
                   // if(pr.Active__c==true){
                        prItem = new Procurement_Region_Wise_Activity_Item__c();
                        prItem.name = prmaster.name;
                        prItem.Active__c = prmaster.Active__c;
                        prItem.Activity_Description__c=prmaster.Activity_Description__c;
                        prItem.Activity_Order__c = prmaster.Activity_Order__c;
                        prItem.Region__c=pr.id;
                        prItem.Type__c=prmaster.Type__c;
                        prItem.Wave__c=pr.Wave__c;
                        prItem.Value__c=0;
                        prItem.Procurement_Region_Wise_Activity_Master__c=prmaster.id;
                        
                        regionWiseList.add(prItem);
                   // }
                    
                }
            }
        Database.upsert(regionWiseList);

        }catch(Exception e){
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.PROCUREMENT_REGION, UtilConstants.PROCUREMENT_REGION, null, System.Logginglevel.ERROR);
        }
    }
}