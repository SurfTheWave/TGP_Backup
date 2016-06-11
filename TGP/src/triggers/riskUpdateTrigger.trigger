/*
@Author and Created Date : Suma Ganga,  2/20/2015 2:30 AM
@name : riskUpdateTrigger 
@Description : 
@Version : 
*/
trigger riskUpdateTrigger on Risks__c (after insert, before insert) {

   List<Risks__c> lstNewRisk = Trigger.new;
   List<Risks__c> lstOldRisk = Trigger.old;
    
    riskUpdateController updateController = new riskUpdateController();
    
    
    if(Trigger.isInsert && Trigger.isBefore){
            updateController.populateFieldsAfterInsert(trigger.new);  
        }
        
    
     if(Trigger.isAfter && Trigger.isInsert){
         UAMSWBMWBUtility uamUtility= new UAMSWBMWBUtility();
            //updateController.populateFieldsAfterInsert(trigger.new); 
            //uamUtility.CheckAccessRiskShareInsert(lstNewRisk);
            MobilizationSharing mobSharing=new MobilizationSharing();
            mobSharing.createSharing(Trigger.new,'Risks__Share');

            
        }   
}