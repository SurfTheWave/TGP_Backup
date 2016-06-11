/*
@Author and Created Date : jyotsna yadav,  2/7/2015 5:20 AM
@name : operationOnOppTeamTrigger 
@Description : 
@Version : 
*/
trigger operationOnOppTeamTrigger on Opportunity_Teams__c (after insert,after update,after delete,before delete,before update,before insert) {
operationOnOppTeamTriggerController oppteamhandler = new operationOnOppTeamTriggerController();
Boolean flag;
list<Opportunity_Teams__c> oppTeamList = new list<Opportunity_Teams__c>();
List<Opportunity_Teams__c> oppTeamListToValidate = new List<Opportunity_Teams__c>();
    if(Test.isRunningTest()){
        flag=true;
    }else{
        List<Oppteamtrigger_flag__c> flagCheckList=Oppteamtrigger_flag__c.getAll().values();
        flag=flagCheckList[0].runtrigger__c; 
    }
    if(flag){
    
     if(trigger.isBefore && trigger.isInsert){ 
        System.debug('-----------before insert -----91');
        UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +'--'+'Opp team before insert Trigger';
        system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue);
        
        operationOnOppTeamTriggerController.addSupportingTech(trigger.new);     
        //operationOnOppTeamTriggerController.UpdateCommentsOnOppTeam(trigger.oldMap,trigger.newMap);
    } 
    
     if(trigger.isupdate && trigger.isBefore){
         UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +'--'+'Opp team before update Trigger';
        system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue);
        
        for(Opportunity_Teams__c teamRec:trigger.new){
            if(UtilConstantsR3.Tech_Arch.equalsignorecase(teamRec.Opportunity_Role_Dev__c) && UtilConstantsR3.Assigned.equalsignorecase(teamRec.Team_Member_Request_Status__c)){
                 teamRec.IsChangesMember__c=true;
            }
            if(teamRec.Opportunity_Role_Dev__c.equalsignorecase(UtilConstantsR3.Tech_Arch) && teamRec.Route_To__c!=null){
                teamRec.Last_Routed_User__c=teamRec.Route_To__c;
            }
        }
        operationOnOppTeamTriggerController.UpdateCommentsOnOppTeam(trigger.oldMap,trigger.newMap);
    }
    
    if(trigger.isAfter){
    
        if(RecursiveTriggerHelper.runOnce()){
            if(trigger.isInsert){
                UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +'--'+'Opp team  after insert Trigger';
                system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue);
                
                oppteamhandler.restrictFromDuplicates(trigger.new);
                operationOnOppTeamTriggerController.getuserMasterMap();
                operationOnOppTeamTriggerController.updateAccessOnOppAndSolCompForAssignee(trigger.new);
                UAMSWBMWBUtility.CheckAccessOppShareInsert(trigger.new);
                operationOnOppTeamTriggerController.insertUtilizationRecords(trigger.new);
                operationOnOppTeamTriggerController.updateRoles(trigger.new); 
                List<Opportunity_teams__c> oteamlist=new list<Opportunity_teams__c>();
                operationOnOppTeamTriggerController.updateFieldsforReporting(trigger.new,oteamlist);
                operationOnOppTeamTriggerController.updateSolutionLIVE_SA_onInsert(trigger.new);
                //added by apoorva
                ShareStageWithOppTeam.newteammember(trigger.new);
                operationOnOppTeamTriggerController.capabilityOfferingLeadInvolvement(trigger.new,false);
               ShareWithOppTeam.newteammember(trigger.new);
               ShareWithOppTeam.teammemberAssmp(trigger.new);
            }
           if(trigger.isUpdate && !UtilConstants.PreventTriggerOnRouting){
               UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +'--'+'Opp team after update Trigger';
        system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue);
                oppteamhandler.restrictFromDuplicates(trigger.new);
                operationOnOppTeamTriggerController.getuserMasterMap();
                //operationOnOppTeamTriggerController.updateAccessOnOppAndSolCompForAssignee(trigger.new);               
                operationOnOppTeamTriggerController.updateOnTechArchLeadRole(trigger.new,trigger.old);
                operationOnOppTeamTriggerController.updateUtilizationRecords(trigger.new,trigger.old);                
                operationOnOppTeamTriggerController.updateRoles(trigger.new);
                for(Opportunity_Teams__c oppTeamRec : trigger.old){
                    if(oppTeamRec.Opportunity_Team_Member__c != null){
                        oppTeamList.add(oppTeamRec);
                    }
                }
                if(oppTeamList.size()>0){
                    UAMSWBMWBUtility.CheckAccessOppShareDelete(trigger.old);
                }
                UAMSWBMWBUtility.CheckAccessOppShareInsert(trigger.new); 
                operationOnOppTeamTriggerController.updateFieldsforReporting(trigger.new,trigger.old);             
                //added by apoorva
                ShareStageWithOppTeam.teammember(trigger.old);
                ShareStageWithOppTeam.restrictShareForTeamMember(trigger.old, trigger.new);
                ShareStageWithOppTeam.newteammember(trigger.new);
                operationOnOppTeamTriggerController.capabilityOfferingLeadInvolvement(trigger.new,false);
                //ShareWithOppTeam.teammember(trigger.old);
                ShareWithOppTeam.newteammember(trigger.new);
                ShareWithOppTeam.restrictShareForTeamMember(trigger.old, trigger.new);
                ShareWithOppTeam.teammemberAssmp(trigger.new);
                ShareWithOppTeam.restrictShareAssmp(trigger.old, trigger.new);
                operationOnOppTeamTriggerController.updateSolutionLIVE_SA_onInsert(trigger.new);
               
            }
            if(trigger.isDelete){
                UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +'--'+'Opp team after delete Trigger';
        system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue);
        
                UAMSWBMWBUtility.CheckAccessOppShareDelete(trigger.old);
                operationOnOppTeamTriggerController.deleteUtilizationRecords(trigger.old);
                operationOnOppTeamTriggerController.updateRoles(trigger.old);
                //operationOnOppTeamTriggerController.capabilityOfferingLeadInvolvement(trigger.old,true);//capbality
                
            }
        }
        
    }
         
    if(trigger.isBefore && trigger.isDelete){
     UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +'--'+'Opp team before delete Trigger';
        system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue);
        
            operationOnOppTeamTriggerController.updateGovDataReq(trigger.old);
            operationOnOppTeamTriggerController.capabilityOfferingLeadInvolvement(trigger.old,true);
            
            
    }
    
    if(Trigger.isBefore && trigger.isUpdate){
        for(Opportunity_Teams__c oppTeam:trigger.new){
            Opportunity_Teams__c oldOppTeam=trigger.oldMap.get(oppTeam.id);
            if(oppTeam.Opportunity_Team_Member__c!=oldOppTeam.Opportunity_Team_Member__c){
                oppTeamListToValidate.add(oppTeam);
            }
        }
    }
    
    if(trigger.isBefore && trigger.isInsert){       
    system.debug('hieeeeeeeeeeee  76'+trigger.new);     
    list<Opportunity_Teams__c> listOfRole=new list<Opportunity_Teams__c>();     
    map<id,Opportunity_Roles_Master__c > rolename=new map<id,Opportunity_Roles_Master__c >();       
    rolename=MasterQueries.rolenames();     
    for(Opportunity_Teams__c role:trigger.new){     
   if(rolename.get(role.Role__c).name.EQUALS(UtilConstants.SUP_TECHARCH)){        
    listOfRole.add(role);       
   }        
    }       
    if(listOfRole.size()>0){        
    operationOnOppTeamTriggerController.populateSolutionScope(listOfRole);      
    }       
    }        
  }
}