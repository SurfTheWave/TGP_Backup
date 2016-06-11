/**
    @Author Divyashree
    @name MobilizationPlanTrigger 
    @CreateDate 12/30/2014
    @Description Trigger to manage Mobilization Plan and its Trackers
    @Version 1.0
    @reference none
*/
trigger MobilizationPlanTrigger on Mobilization_Plan__c (after insert, after update, before insert, before update, before Delete) {
    
    Boolean flag=false;
    if(Test.isRunningTest()){
        flag=true;
    }else{
        List<FlagCheck__c> flagCheckList=FlagCheck__c.getAll().values();
        flag=flagCheckList[0].FieldOne__c; 
    }
    if(flag){
        List<Mobilization_Plan__c> lstMobplan = new List<Mobilization_Plan__c>();
   //List<Id> lstMobIds = new List<Id>();
   //List<Wave__c> lstWave = new List<Wave__c>();
    
    /*
   if(Trigger.isDelete){
       UTILMobClasses utilCls = new UTILMobClasses();
       utilCls.checkDeletingActiveRecords(trigger.old);
   } 
   */
    
   if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate ){
             try{ 
                 Boolean isInsert = trigger.isInsert;
                                                
                   ManageMoblilzationPlan mngPlan = new ManageMoblilzationPlan();
                   mngPlan.manageAllTrackers(trigger.newMap, isInsert , trigger.oldMap);
                   
           //Devanna: Collect list of records where isOnTracking is enabled for Mobilization plan.
               if(UTILMobClasses.flag) {
                
                UTILMobClasses.flag = FALSE;      
                              
               for(Mobilization_Plan__c mobplan: trigger.new){
                        if(mobplan.IsTrackingOn__c  && mobplan.IsTrackingOn__c != Trigger.oldMap.get(mobplan.id).IsTrackingOn__c) {
                          
                            lstMobplan.add(mobplan);                            
                                       
                         }
                }
                
                if(!lstMobplan.isEmpty()) {
                            Database.executeBatch(new OpexSratBatchInsert(lstMobplan),6);           
                
                }
               }                
                        
            }
            catch(Exception e){
                UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.MOBLILZATIONPLAN_TRIGGER , UtilConstants.MOBLILZATIONPLAN_TRIGGER , null, System.Logginglevel.ERROR);
            }
        }
    }
    
    else {
        try{
            if(trigger.isInsert){
                ManageMoblilzationPlan mngPlan = new ManageMoblilzationPlan();
                mngPlan.checkPlanStatus(trigger.new, true , null); 
              }
           // else{
            else if(trigger.isUpdate && trigger.isBefore){
                ManageMoblilzationPlan mngPlan = new ManageMoblilzationPlan();
                mngPlan.checkForTracking(trigger.newMap, false, trigger.oldMap);
            }else{
            	
            }
        }
        catch(Exception e){
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.MOBLILZATIONPLAN_TRIGGER , UtilConstants.MOBLILZATIONPLAN_TRIGGER , null, System.Logginglevel.ERROR);
        }
     }
        
    }
  
}