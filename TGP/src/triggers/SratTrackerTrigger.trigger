/*
@Author and Created Date : Goudar Devanna,  1/30/2015 5:37 AM
@name : SratTrackerTrigger 
@Description : 
@Version : 
*/
trigger SratTrackerTrigger on SRAT_Tracker__c (after insert, after update, before insert, before update, before delete) {

    Boolean flag=false;
    if(Test.isRunningTest()){
        flag=true;
    }else{
        List<FlagCheck__c> flagCheckList=FlagCheck__c.getAll().values();
        flag=flagCheckList[0].FieldOne__c; 
    }
    
    if(flag) {

List<SRAT_Tracker__c> lstST = new List<SRAT_Tracker__c>();
SRAT_Tracker__c SratDel = new SRAT_Tracker__c();
List<id> lstWaveIds = new List<id>();
List<Wave__c> lstWaveIsTrackingOn = new List<Wave__c>();

List<SRAT_Tracker__c> lstsratChklistSubmit = new List<SRAT_Tracker__c>();



SratTrackerClass STclass = new SratTrackerClass ();

if(Trigger.isInsert&& Trigger.isBefore){       
 UTILMobClasses util =  new UTILMobClasses();        
 util.populateMobilizationPlan(trigger.new);    
 }
    
if(trigger.isAfter && trigger.isInsert)
    {
             
        for(SRAT_Tracker__c STracker: trigger.new)
        {
                         
                lstWaveIds.add(STracker.Wave__c);        
                lstST.add(STracker);                        
                            
        }
        
        for(Wave__c wave: [Select Id,Name from Wave__c where Id IN: lstWaveIds and IsTrackingOn__c = TRUE])
        {
         lstWaveIsTrackingOn.add(wave);
        }   
        if(!lstWaveIsTrackingOn.isEmpty()) {                  
            STclass.InsertSratL1L2(lstST);           
            }
               
   
    }
    
    
if(trigger.isBefore && trigger.isDelete)
    {
         /*
         UTILMobClasses utilCls = new UTILMobClasses();
         utilCls.checkBeforeDeletingChildRecords(trigger.old);
         */
                  
         for(SRAT_Tracker__c STDel: trigger.old)
        {
            SratDel = STDel;
        }
        
        STclass.SratDelete(SratDel);
    }
 
  if(trigger.isAfter && trigger.isUpdate) {
    for(SRAT_Tracker__c ChecklistReviewed: trigger.new) {
        if( (ChecklistReviewed.Checklist_Reviewed__c && ChecklistReviewed.Checklist_Reviewed__c !=Trigger.oldMap.get(ChecklistReviewed.id).Checklist_Reviewed__c) || (ChecklistReviewed.IsPlanActive__c  == FALSE && ChecklistReviewed.IsPlanActive__c  != Trigger.oldMap.get(ChecklistReviewed.id).IsPlanActive__c ) ) {
            lstsratChklistSubmit.add(ChecklistReviewed);
        }
    }
   
    STclass.updateRecTypesratlevel2(lstsratChklistSubmit);



}
 
 }

}