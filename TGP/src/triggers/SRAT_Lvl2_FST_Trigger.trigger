/**
   @Author :Mobilization WorkBench
   @name   :SRAT_Lvl2_FST_Trigger 
   @CreateDate :12 December 2015 
   @Description : This is a trigger on SRAT_Additional_Tracking_Level_2_FST__c.
   @Version : 1.0 
  */
trigger SRAT_Lvl2_FST_Trigger on SRAT_Additional_Tracking_Level_2_FST__c (before insert, after insert, before update, after update) {
   try {
    if(Trigger.isBefore && Trigger.isInsert){
        List<Id> sratL1 = new List<Id>();
        for(SRAT_Additional_Tracking_Level_2_FST__c sratFST:trigger.new){
            sratL1.add(sratFST.Deal_SRAT_Additional_Tracking_Level_1__c);
        }
         Map<Id, SRAT_Additional_Tracking_Level_1__c> sratLevel1Map = new Map<Id,SRAT_Additional_Tracking_Level_1__c>([SELECT Id, Name, SRAT_Tracker__c FROM SRAT_Additional_Tracking_Level_1__c WHERE Id IN : sratL1 LIMIT 5000]);
         
         for(SRAT_Additional_Tracking_Level_2_FST__c sratFST:trigger.new){
            sratFST.SRAT_Tracking_Item__c = sratLevel1Map.get(sratFST.Deal_SRAT_Additional_Tracking_Level_1__c).SRAT_Tracker__c;
        }
     }   
    }
    catch(Exception e){
   
   }
    
}