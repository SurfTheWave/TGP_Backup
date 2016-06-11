/*
* This class is used to update RaidAction records for RaidRisk and RaidIssue objects
*
*  @ Author Accenture Team
*  @ Date 17/11/2014 
*/
public class RaidActionTriggerController{
        set<Id> raidId = new set<Id>();
        set<Id> IssueId = new set<Id>();
        String SEPERATOR=',';
        List<RAID_Risk__c> updatedRaidRisk=new List<RAID_Risk__c>();
    public void updateRaidActionOnRaidRisk(List<RAID_Action__c> lstRaidActionList, List<RAID_Action__c> oldOrNewRaidActionList){
        
        String serialNumber='';
        String actionTitle='';
        Map<String, List<RAID_Action__c>> riskARaidMap = new MAP<String, List<RAID_Action__c>> ();
        List<RAID_Action__c> tempRaidAList;
        for(RAID_Action__c raidAction :lstRaidActionList){
            raidId.add(raidAction.Risk_Ref_ID__c);  
            system.debug('new risk refid>>>>>>>'+raidId);
        }
        for(RAID_Action__c raidAction :oldOrNewRaidActionList){
            raidId.add(raidAction.Risk_Ref_ID__c);  
            system.debug('old risk refid>>>>>>'+raidId);            
        }
        for(RAID_Action__c raidActionList : [Select Serial_Number__c, Action_Title__c, Risk_Ref_ID__c from RAID_Action__c where Risk_Ref_ID__c IN: raidId limit 5000]){
             if(riskARaidMap.containsKey(raidActionList.Risk_Ref_ID__c)) {
                  tempRaidAList = riskARaidMap.get(raidActionList.Risk_Ref_ID__c);
             }
             else {
               tempRaidAList = new List<RAID_Action__c> ();
             }
             tempRaidAList.add(raidActionList);
             riskARaidMap.put(raidActionList.Risk_Ref_ID__c,tempRaidAList);
             system.debug('riskARaidMap>>>>>>>>'+riskARaidMap);
         }
        
        for(RAID_Risk__c raidRisk : [SELECT Action_Reference_ID__c,Serial_Number__c,Action_Title__c from RAID_Risk__c where id IN : raidId limit 5000]) {
            if(riskARaidMap.containskey(raidRisk.Id)) {
                serialNumber='';
                actionTitle='';
                tempRaidAList = riskARaidMap.get(raidRisk.Id);
                system.debug('tempRaidAList size>>>>>>>>'+tempRaidAList.size());
                    for(RAID_Action__c raidAction : tempRaidAList) {
                        if(serialNumber=='' ||serialNumber==null ){
                            serialNumber = raidAction.Serial_Number__c;
                        }
                        else {
                            serialNumber +=  SEPERATOR +  raidAction.Serial_Number__c  ;
                        }
                        if( actionTitle =='' || actionTitle ==null){
                            actionTitle = raidAction.Action_Title__c;
                        }
                        else {
                            actionTitle +=  SEPERATOR + raidAction.Action_Title__c ;
                        }
                    } 
                    raidRisk.Action_Reference_ID__c = serialNumber;
                    raidRisk.Action_Title__c = actionTitle;
                    updatedRaidRisk.add(raidRisk);
                system.debug('updatedRaidRisk>>>>>>>>'+updatedRaidRisk);
            }
        }
        try {
            if(!updatedRaidRisk.isEmpty()){
            Database.update(updatedRaidRisk);
            }
        }
        catch(Exception exp) {
        system.debug('exp  '+exp);
        } 
    }
    public void updateRaidActionOnRaidIssue(List<RAID_Action__c> lstRaidActionList,List<RAID_Action__c> oldOrNewRaidActionList){
        List<RAID_Issue__c> updatedRaidIssue=new List<RAID_Issue__c>();
        String actionSerialNumber='';
        String actionITitle='';
        for(RAID_Action__c raidAction :lstRaidActionList){
            IssueId.add(raidAction.Issue_Ref_ID__c);
        }
        for(RAID_Action__c raidAction :oldOrNewRaidActionList){
            IssueId.add(raidAction.Issue_Ref_ID__c);
        }
        Map<String, List<RAID_Action__c>> riskIssueRaidMap = new MAP<String, List<RAID_Action__c>> ();
        List<RAID_Action__c> tempRaidIssueList;
       try {
            for(RAID_Action__c raidActionList : [Select Serial_Number__c, Action_Title__c, Issue_Ref_ID__c from RAID_Action__c where Issue_Ref_ID__c IN: IssueId limit 5000]){
                 if(riskIssueRaidMap.containsKey(raidActionList.Issue_Ref_ID__c)) {
                      tempRaidIssueList = riskIssueRaidMap.get(raidActionList.Issue_Ref_ID__c);
                 }
                 else {
                   tempRaidIssueList = new List<RAID_Action__c> ();
                 }
                 tempRaidIssueList.add(raidActionList);
                 riskIssueRaidMap.put(raidActionList.Issue_Ref_ID__c,tempRaidIssueList);
             }
            for(RAID_Issue__c raidIssue: [SELECT id,Action_Reference_ID__c,Serial_Number__c,Action_Title__c from RAID_Issue__c where id IN : IssueId limit 5000]) {
                if(riskIssueRaidMap.containskey(raidIssue.Id)) {
                    actionSerialNumber='';
                    actionITitle='';
                    tempRaidIssueList = riskIssueRaidMap.get(raidIssue.Id);
                        for(RAID_Action__c raidAction : tempRaidIssueList) {
                            if(actionSerialNumber ==null || actionSerialNumber ==''){
                                actionSerialNumber = raidAction.Serial_Number__c;
                            }
                            else {
                                actionSerialNumber += SEPERATOR + raidAction.Serial_Number__c ;
                            }
                            if(actionITitle ==null || actionITitle ==''){
                                actionITitle = raidAction.Action_Title__c;
                            }
                            else {
                                actionITitle += SEPERATOR + raidAction.Action_Title__c  ;
                            }
                        } 
                        raidIssue.Action_Reference_ID__c = actionSerialNumber;
                        raidIssue.Action_Title__c = actionITitle;
                        updatedRaidIssue.add(raidIssue);
                }
            }
            if(!updatedRaidIssue.isEmpty()){
                update(updatedRaidIssue);
            }
        }
        catch(Exception exp) {
            system.debug('exp  '+exp);
         }  
    }   
}