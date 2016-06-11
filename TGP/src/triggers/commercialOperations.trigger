trigger commercialOperations on Commercial_Data__c (before insert,before update) {
    if(trigger.isBefore && trigger.isInsert){
        if(!UtilConstantsR3.runCommTrigger){
            for(Commercial_Data__c commData :trigger.new){
                commData.addError('You don\'t have necessary level of access.');
            }
        }
    }
   if(trigger.isUpdate && trigger.isBefore){
        if(SWBBPOSEIntegrationConstants.isExceutionFromSync == false){
         for(Commercial_Data__c commData :trigger.new){
             system.debug('commData-->'+commData.Active_dev__c);
             if(commData.Active_dev__c == false)
             {
                  commData.addError('No Commercial Lead Assigned.');
             }
        }
       }
  }   
    
}