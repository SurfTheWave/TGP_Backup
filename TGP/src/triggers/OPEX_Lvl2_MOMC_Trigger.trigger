/**
   @Author :Mobilization WorkBench
   @name   : OPEX_Lvl2_MOMC_Trigger
   @CreateDate : 12 December 2015 
   @Description : This is a trigger on Deal_OPEX_Additional_Tckn_Level_2_MOMC__c.
   @Version : 1.0 
  */
trigger OPEX_Lvl2_MOMC_Trigger on Deal_OPEX_Additional_Tckn_Level_2_MOMC__c (before insert, after insert, before update, after update) {

    if(Trigger.isBefore && Trigger.isInsert){
        List<Id> opexL1 = new List<Id>();
        for(Deal_OPEX_Additional_Tckn_Level_2_MOMC__c opexMomc :trigger.new){
            opexL1.add(opexMomc.Deal_OPEX_Additional_Tracking_Level_1__c);
        }
         Map<Id, Deal_OPEX_Additional_Tracking_Level_1__c> opexLevel1Map = new Map<Id,Deal_OPEX_Additional_Tracking_Level_1__c >([SELECT Id, Name, OPEX_Tracker_del__c FROM Deal_OPEX_Additional_Tracking_Level_1__c WHERE Id IN : opexL1 LIMIT 5000]);
         
         for(Deal_OPEX_Additional_Tckn_Level_2_MOMC__c opexMomc :trigger.new){
          opexMomc.OPEX_Tracking_Item__c = opexLevel1Map.get(opexMomc.Deal_OPEX_Additional_Tracking_Level_1__c).OPEX_Tracker_del__c ;
        }
    }

}