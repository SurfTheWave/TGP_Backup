/*
  @Author: Shivraj.Gangabyraiah
  @Name: SratOpexScheduler
  @Created Date: 03 January 2015
  @Description: This class is used to give share access to opex and srat level1 records
  @version: 1.0
*/
global class SratOpexScheduler implements Schedulable{
        /*
    @Description: execute
    @Required Parameters: 
    @Return Parameters: void
    */
    global void execute(SchedulableContext SC) {
        List<SRAT_Additional_Tracking_Level_1__c> sratUpdateList=new List<SRAT_Additional_Tracking_Level_1__c>();
        List<Deal_OPEX_Additional_Tracking_Level_1__c> opexUpdateList=new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
        
        List<SRAT_Additional_Tracking_Level_1__c> sratList=[select id,batchExecuted__c from SRAT_Additional_Tracking_Level_1__c 
        where batchExecuted__c=false LIMIT 5000];
        List<Deal_OPEX_Additional_Tracking_Level_1__c> opexList=[select id,batchExecuted__c from Deal_OPEX_Additional_Tracking_Level_1__c 
        where batchExecuted__c=false LIMIT 5000];
        
       
        if(!sratList.isEmpty() && !String.isBlank(String.valueOf(sratList)) ){
             MobilizationSharing mobSharing=new MobilizationSharing();
            mobSharing.createSharing(sratList,UtilConstants.SRAT_ADD_TRACK);
            for(SRAT_Additional_Tracking_Level_1__c sratL1:sratList){
                sratL1.batchExecuted__c=true;
                sratUpdateList.add(sratL1);
            }
            Database.update(sratUpdateList);
        }
        
        if(!opexList.isEmpty() && !String.isBlank(String.valueOf(opexList)) ){
             MobilizationSharing mobSharing=new MobilizationSharing();
            mobSharing.createSharing(opexList,UtilConstants.OPEX_ADD);
            for(Deal_OPEX_Additional_Tracking_Level_1__c opex:opexList){
                opex.batchExecuted__c=true;
                opexUpdateList.add(opex);
            }
            Database.update(opexUpdateList);
        }
        
    }

}