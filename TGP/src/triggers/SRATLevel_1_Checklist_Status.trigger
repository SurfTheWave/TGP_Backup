trigger SRATLevel_1_Checklist_Status on SRAT_Additional_Tracking_Level_1__c (After insert,After Update) {

    List<SRAT_Additional_Tracking_Level_1__c> lstNewSratLevel1 = Trigger.new;
    List<SRAT_Additional_Tracking_Level_1__c> lstOldSratLevel1 = Trigger.old;
    
    SRATUpdateController updateController = new SRATUpdateController();
    UAMSWBMWBUtility uamUtility= new UAMSWBMWBUtility();
    
    if(trigger.isafter && trigger.isUpdate){       
            updateController.changehecklistStatusLevel1AfterUpdate(trigger.oldmap, trigger.new);          
            
    }
    if(Trigger.isAfter && Trigger.isInsert){           
       //uamUtility.sratAdditionalTrakingLevel1ShareInsert(lstNewSratLevel1 );      
      // MobilizationSharing mobSharing=new MobilizationSharing();
      // mobSharing.createSharing(Trigger.new,'SRAT_Additional_Tracking_Level_1__share');              
    }

}