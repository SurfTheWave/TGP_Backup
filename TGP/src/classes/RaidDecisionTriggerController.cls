/*
* This class is used to update RaidDecision records for RaidRisk and RaidIssue objects
*
*  @ Author Accenture Team
*  @ Date 17/11/2014 
*/
public class RaidDecisionTriggerController{
    set<Id> raidId = new set<Id>();
    set<Id> IssueId = new set<Id>();
    String SEPERATOR=',';
    List<RAID_Risk__c> updatedRaidRisk=new List<RAID_Risk__c>();
    public void updateRaidDecisionOnRaidRisk(List<RAID_Decision__c> lstRaidDecisionList, List<RAID_Decision__c> oldRaidDecisionList){
            List<RAID_Risk__c> updatedRaidRisk=new List<RAID_Risk__c>();
            String serialNumber='';
            String decisionTitle='';
            Map<String, List<RAID_Decision__c>> riskDecisionRaidMap = new MAP<String, List<RAID_Decision__c>> ();
            List<RAID_Decision__c> tempRaidDecisionList;
            for(RAID_Decision__c raidDecision :lstRaidDecisionList){
                raidId.add(raidDecision.Risk_Ref_ID__c);
            }
            for(RAID_Decision__c raidDecision :oldRaidDecisionList){
                raidId.add(raidDecision.Risk_Ref_ID__c);
            }
            for(RAID_Decision__c raidDecisionList : [Select Serial_Number__c, Decision_Title__c, Risk_Ref_ID__c from RAID_Decision__c where Risk_Ref_ID__c IN: raidId limit 5000]){
                 if(riskDecisionRaidMap.containsKey(raidDecisionList.Risk_Ref_ID__c)) {
                      tempRaidDecisionList = riskDecisionRaidMap.get(raidDecisionList.Risk_Ref_ID__c);
                 }
                 else {
                   tempRaidDecisionList = new List<RAID_Decision__c> ();
                 }
                 tempRaidDecisionList.add(raidDecisionList);
                 riskDecisionRaidMap.put(raidDecisionList.Risk_Ref_ID__c,tempRaidDecisionList);
             }
            
            for(RAID_Risk__c raidRisk : [SELECT Decision_Reference_ID__c,Serial_Number__c,Decision_Title__c from RAID_Risk__c where id IN : raidId limit 5000]) {
                if(riskDecisionRaidMap.containskey(raidRisk.Id)) {
                    tempRaidDecisionList = riskDecisionRaidMap.get(raidRisk.Id);
                    serialNumber='';
                    decisionTitle='';
                    for(RAID_Decision__c raidDecision : tempRaidDecisionList) {
                        if(serialNumber ==null || serialNumber =='' ){
                            serialNumber = raidDecision.Serial_Number__c;
                        }
                        else {
                            serialNumber += SEPERATOR + raidDecision.Serial_Number__c ;
                        }
                        if(decisionTitle==null || decisionTitle=='' ){
                            decisionTitle = raidDecision.Decision_Title__c;
                        }
                        else {
                            decisionTitle += SEPERATOR + raidDecision.Decision_Title__c ;
                        }
                    } 
                    raidRisk.Decision_Reference_ID__c = serialNumber;
                    raidRisk.Decision_Title__c = decisionTitle;
                    updatedRaidRisk.add(raidRisk);
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
                //Update Decision title, Decision Ref id in Issue object
    public void updateRaidDecisionOnRaidIssue(List<RAID_Decision__c> lstRaidDecisionList,List<RAID_Decision__c> oldNewRaidDecisionList){
        List<RAID_Issue__c> updatedRaidIssue=new List<RAID_Issue__c>();
        String decisionSerialNumber='';
        String decisionTitle='';       
        Map<String, List<RAID_Decision__c>> riskIssueRaidMap = new MAP<String, List<RAID_Decision__c>> ();
        List<RAID_Decision__c> tempRaidIssueList;
        for(RAID_Decision__c raidDecision :lstRaidDecisionList){
            IssueId.add(raidDecision.Issue_Ref_ID__c);
        } 
        for(RAID_Decision__c raidDecision :oldNewRaidDecisionList){
            IssueId.add(raidDecision.Issue_Ref_ID__c);
        }
        for(RAID_Decision__c raidDecisionList : [Select Serial_Number__c, Decision_Title__c, Issue_Ref_ID__c from RAID_Decision__c where Issue_Ref_ID__c IN: IssueId limit 5000]){
             if(riskIssueRaidMap.containsKey(raidDecisionList.Issue_Ref_ID__c)) {
                  tempRaidIssueList = riskIssueRaidMap.get(raidDecisionList.Issue_Ref_ID__c);
             }
             else {
               tempRaidIssueList = new List<RAID_Decision__c> ();
             }
             tempRaidIssueList.add(raidDecisionList);
             riskIssueRaidMap.put(raidDecisionList.Issue_Ref_ID__c,tempRaidIssueList);
         }
        for(RAID_Issue__c raidIssue: [SELECT id,Decision_Reference_ID__c,Serial_Number__c,Decision_Title__c from RAID_Issue__c where id IN : IssueId limit 5000]) {
            if(riskIssueRaidMap.containskey(raidIssue.Id)) {
                tempRaidIssueList = riskIssueRaidMap.get(raidIssue.Id);
                decisionSerialNumber='';
                decisionTitle='';   
                for(RAID_Decision__c raidDecision : tempRaidIssueList) {
                    if(decisionSerialNumber ==null || decisionSerialNumber=='' ){
                        decisionSerialNumber = raidDecision.Serial_Number__c;
                    }
                    else {
                        decisionSerialNumber +=  SEPERATOR + raidDecision.Serial_Number__c  ;
                    }
                    if(decisionTitle ==null || decisionTitle==''){
                        decisionTitle = raidDecision.Decision_Title__c;
                    }
                    else {
                        decisionTitle += SEPERATOR + raidDecision.Decision_Title__c ;
                    }
                } 
                raidIssue.Decision_Reference_ID__c = decisionSerialNumber;
                raidIssue.Decision_Title__c = decisionTitle;
                updatedRaidIssue.add(raidIssue);
            }
        }
        try {
            if(!updatedRaidIssue.isEmpty()){
                update(updatedRaidIssue);
            }
        }               
        catch(Exception exp) {
            system.debug('exp  '+exp);
        }
    }
}