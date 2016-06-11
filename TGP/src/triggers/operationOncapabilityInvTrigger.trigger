trigger operationOncapabilityInvTrigger on Capability_Involvement__c (after Insert, after update) {

          List<Capability_Involvement__c> capabilityList=new List<Capability_Involvement__c>();
          List<Capability_Involvement__c> capabilityoldList=new List<Capability_Involvement__c>();
      if(trigger.isAfter){

          if(trigger.isInsert){
                  operationOncapabilityInvController.shareRecordsToCapabilityLead(Trigger.new);                 
          }

           if(trigger.isUpdate){
                  
                  for(integer i=0;i<trigger.new.size();i++){
                  
                  if(trigger.new[i].user__c !=trigger.old[i].user__c)
                  { 
                  capabilityList.add(trigger.new[i]);
                  capabilityoldList.add(trigger.old[i]);
                  }
                  else{
                  if(trigger.new[i].opportunity_team__C ==null ){                  
                  capabilityoldList.add(trigger.old[i]);
                  }                 
                  }
                  }
                operationOncapabilityInvController.shareRecordsToCapabilityLead(capabilityList);
                operationOncapabilityInvController.removePermissionSetAccess(capabilityoldList);
           }               
          }
     }