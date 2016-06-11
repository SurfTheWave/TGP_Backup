/*
  @Author: 
  @Name: TechToolTrigger
  @Created Date: 
  @Description:
  @version: 1.0
*/
trigger TechToolTrigger on Tech_Tools__c (after Update) {
    Map<id,Tech_Tools__c> triggerMap = new Map<id,Tech_Tools__c>();
    Map<Id, Id> techMap =new Map<Id, Id>();
    Id techID;
    for(Tech_Tools__c tech: trigger.new){
        triggerMap.put(tech.id,tech);
    }
    //System.debug('inside the trigger');
    String tempId = [SELECT Id FROM EmailTemplate WHERE DeveloperName=:UtillContstant_Novasuite.TECH_TOOL_VERIFY LIMIT 1].id;
    
    if(!SWBBPOSEIntegrationConstants.isExceutionFromSync){
        for(Tech_Tools__c tech: [Select id,Service__r.Solutionscope__r.Opportunity__r.Is_Synced__c,Service__r.Solutionscope__r.Opportunity__r.Opportunity_Solution_Lead__r.user__c,Scope_Status__c,Out_Of_Scope_Reason__c,Out_Of_Scope_Reason_Description__c from Tech_Tools__c where ID IN:trigger.new limit 5000]){
            if(trigger.oldMap.get(tech.id).Scope_Status__c != tech.Scope_Status__c && tech.Service__r.Solutionscope__r.opportunity__r.is_synced__c){
                triggerMap.get(tech.id).Scope_Status__c.addError(UtilConstants.scopecantbeupdate);
            }
             if(tech.Scope_Status__c.equalsignorecase(utilconstants.OUT_SCOPE) && 
                    (String.isBlank(tech.Out_Of_Scope_Reason__c))){
                    triggerMap.get(tech.id).Out_Of_Scope_Reason__c.addError(SWBBPOSEIntegrationConstants.outofreason);
             }
             if(tech.Scope_Status__c.equalsignorecase(utilconstants.OUT_SCOPE) && 
                tech.Out_Of_Scope_Reason__c.equals(UtillContstant_Novasuite.OTHER)  && (String.isBlank(tech.Out_Of_Scope_Reason_Description__c))){
                triggerMap.get(tech.id).Out_Of_Scope_Reason_Description__c.addError(SWBBPOSEIntegrationConstants.outofreason);
             }
        }
     }
          for(Tech_Tools__c tech:[Select id,Service__r.Solutionscope__r.Opportunity__r.Is_Synced__c,Service__r.Solutionscope__r.Opportunity__r.Opportunity_Solution_Lead__r.user__c,Scope_Status__c from Tech_Tools__c where ID IN:trigger.new limit 5000]){
           if(tech.Service__r.Solutionscope__r.Opportunity__r.Opportunity_Solution_Lead__r.user__c != null){
           if(trigger.oldMap.get(tech.id).Scope_Status__c != tech.Scope_Status__c && tech.Scope_Status__c.equals(UtillContstant_Novasuite.OUT_OF_SCOPE)){
              if(!techMap.containsKey(tech.Service__r.Solutionscope__r.Opportunity__c)){
                  if(tech.Service__r.Solutionscope__r.Opportunity__r.Opportunity_Solution_Lead__c != null){
                  techMap.put(tech.Service__r.Solutionscope__r.Opportunity__c, tech.Service__r.Solutionscope__r.Opportunity__r.Opportunity_Solution_Lead__r.user__c);
                  techID=tech.id;
              }
              }
           }
           }
        }
        //System.debug('inside tech tool trigger ---');
       // if(TechToolTriggerHandler.isRecursive){
           if(techMap != null){
            TechToolTriggerHandler.processSendMail(techMap, tempId,TechID);
            //system.debug('techMap---'+techMap+'---'+tempId);
            }
      //  }
    
}