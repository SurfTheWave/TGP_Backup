/*
@Author and Created Date : Goudar Devanna,  1/09/2015 4:23 AM
@name : OpexTrigger 
@Description : 
@Version : 
*/
trigger OpexTrigger on OPEX_Tracker__c (after insert, after update, before insert, before update, before delete) {
    Boolean flag=false;
    if(Test.isRunningTest()){
        flag=true;
    }else{
        List<FlagCheck__c> flagCheckList=FlagCheck__c.getAll().values();
        flag=flagCheckList[0].FieldOne__c; 
    }
    
    if(flag) {
List<OPEX_Tracker__c> lstOpexTracker = new List<OPEX_Tracker__c>();
List<OPEX_Tracker__c> lstOT = new List<OPEX_Tracker__c>();
OPEX_Tracker__c OpexDel = new OPEX_Tracker__c();
List<OPEX_Tracker__c> lstOpexChklistSubmit = new List<OPEX_Tracker__c>();
List<id> lstWaveIds = new List<id>();
List<Wave__c> lstWaveIsTrackingOn = new List<Wave__c>();


OpexTrackerClass OTclass = new OpexTrackerClass();

if(trigger.isBefore && trigger.isInsert)
    {
                
        UTILMobClasses util =  new UTILMobClasses();       
        util.populateMobilizationPlan(trigger.new);
    }

    
if(trigger.isAfter && trigger.isInsert)
    {
             
        for(OPEX_Tracker__c OTracker: trigger.new)
        {
            
            lstWaveIds.add(OTracker.Wave__c);  
            lstOT.add(OTracker);
          
            
        }
        for(Wave__c wave: [Select Id,Name from Wave__c where Id IN: lstWaveIds and IsTrackingOn__c = TRUE])
        {
         lstWaveIsTrackingOn.add(wave);
        }   
        if(!lstWaveIsTrackingOn.isEmpty()) {                  
            OTclass.InsertOpexL1L2(lstOT);           
            }
                    
    }
    
    
if(trigger.isBefore && trigger.isDelete)
    {
        /*
        UTILMobClasses utilCls = new UTILMobClasses();
        utilCls.checkBeforeDeletingChildRecords(trigger.old);
        */
    
         for(OPEX_Tracker__c OTDel: trigger.old)
        {
            OpexDel = OTDel;
        }
        
        OTclass.OpexDelete(OpexDel);
    }
 
 if(trigger.isAfter && trigger.isUpdate) {
    for(OPEX_Tracker__c submitChecklist: trigger.new) { 
        if( (submitChecklist.Submit_Checklist__c && submitChecklist.Submit_Checklist__c != Trigger.oldMap.get(submitChecklist.id).Submit_Checklist__c) || (submitChecklist.IsPlanActive__c == FALSE && submitChecklist.IsPlanActive__c != Trigger.oldMap.get(submitChecklist.id).IsPlanActive__c) ) {
            lstOpexChklistSubmit.add(submitChecklist);
        }
    }
    
    OTclass.updateRecTypeOpexlevel2(lstOpexChklistSubmit);
 }
 
  }
 
 }