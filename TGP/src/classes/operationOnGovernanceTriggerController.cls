/**
   @Author : Reena Thakre
   @name   : operationOnGovernanceTriggerController
   @CreateDate : 21 Jan 2015 
   @Description : Handler class for Trigger on Governance object
   @Version : 1.0 
  */


public class operationOnGovernanceTriggerController
{
    /**
   @Author : Reena Thakre
   @name   : afterInsertTaskOnGov
   @CreateDate : 21 Jan 2015 
   @Description : This method will create the task for SD Governance Lead whenever a SD governance Lead  is assigned to 
   governance data record on opportunity.
   @Version : 1.0 
  */



    public void afterInsertTaskOnGov(List<SD_Governance_Data__c> GovNewList){
    String sdgovlable=System.label.SD_Governance_Lead_Coach;
    list<Task> lNewTasks = new list<Task>();
    list<Task> lrecurTasks = new list<Task>();
    Task myTask = new Task();
    Task recurTask = new Task();
    set<id>oppids=new set<id>();
    String taskSubConstant=UtilConstants.GOV_DATA;
    List<String> sdLeads = new List<String>();
    Map<String,id> sdLeadMap=new Map<String,Id>();

    for (SD_Governance_Data__c gov:GovNewList){    
    sdLeads.add(gov.SD_Gov_Lead_Coach__c);
    }
        
    //Below code will create a new task for the SD governace Lead which is related to Governance Data
    for(User itrObj:[SELECT Name,id FROM User where name in:sdLeads Limit 5000]){      
      sdLeadMap.put(itrObj.name,itrObj.id);  
     } 
           
    for (SD_Governance_Data__c govList:[Select opportunity__r.name,opportunity__r.Reporting_status__c,SD_Gov_Lead_Coach__c from SD_Governance_Data__c where id in :GovNewList Limit 5000 ]){
    System.debug('--------------------------->'+govList.opportunity__r.Reporting_status__c);
    if(govList.opportunity__r.Reporting_Status__c.Equals(UtilConstants.PIPELINE)  || govList.opportunity__r.Reporting_Status__c.Equals(UtilConstants.UNQUALIFIED)){
    
    if(govList.SD_Gov_Lead_Coach__c!=UtilConstants.EMPTY_STRING){ 
    String oppname=govList.opportunity__r.name;
    //String subjectName=UtilTaskComplete.taskSubjectName(oppname,taskSubConstant);  
    Datetime dt = DateTime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0));
    String dayOfWeek=dt.format(UtilConstants.D_ALPHA);
    System.debug('Day : ' + dayOfWeek);


    //myTask.Subject = subjectName;
    myTask.ownerId =sdLeadMap.get(govList.SD_Gov_Lead_Coach__c);  
    myTask.whatId=govList.id;
    //myTask.ActivityDate = Date.today();
    myTask.RecurrenceType= UtilConstants.RECUR_WEEKLY;
    myTask.RecurrenceInterval = 1;
    myTask.status=UtilConstants.IN_PROGRESS ;
    //if(dayOfWeek!='3')
    myTask.RecurrenceDayOfWeekMask=3;
    
    myTask.IsRecurrence = true;
    myTask.RecurrenceEndDateOnly=Date.today()+365;
    myTask.RecurrenceStartDateOnly=Date.today();

    lNewTasks.add(myTask);
    
    
      
    }
    }
    }
    try{
    insert lNewTasks; 
    }
    catch(Exception e)
    {
    system.debug('-------------'+e);}
    
}

/** This method will fetch the value for BPO Sales Lead**/

    public void getBPOSalesLead(List<sd_governance_data__c> sdGovList){
    set<Id> opp = new set<Id>();
    List<sd_governance_data__c> sdGovernance = new List<sd_governance_data__c>();
    if(sdGovList!=null){
    for(sd_governance_data__c sdGovRecords : sdGovList){
        opp.add(sdGovRecords.Opportunity__c);
    }
    }
    List<opportunity_Additional_Team__c> oppAddTeam = new List<opportunity_Additional_Team__c>();
    Map<id,opportunity_Additional_Team__c> teamdetails = new Map<id,opportunity_Additional_Team__c>();
    for(opportunity_Additional_Team__c oppAdTeam : [select id, opportunity__c, Additional_Opportunity_Team_Member__c, lastmodifieddate from Opportunity_Additional_Team__c where opportunity__c in:opp Limit 5000 ]){
        if(teamdetails.containsKey(oppAdTeam.opportunity__c)){
            if(teamdetails.get(oppAdTeam.opportunity__c).lastmodifieddate < oppAdTeam.lastmodifieddate){
            teamdetails.put(oppAdTeam.opportunity__c, oppAdTeam);
            }
        } else{
            teamdetails.put(oppAdTeam.opportunity__c, oppAdTeam);
              }
        }
    for(sd_governance_data__c sdGovRec : [select Id, opportunity__c from sd_governance_data__c where opportunity__c in:opp Limit 5000]){
    if(teamdetails.containskey(sdGovRec.opportunity__c)){
    if(teamdetails.get(sdGovRec.opportunity__c)!=null){
           sdGovRec.BPO_Sales_Lead__c =teamdetails.get(sdGovRec.opportunity__c).Additional_Opportunity_Team_Member__c; 
        sdGovernance.add(sdGovRec);
       }
        }
        }
        update sdGovernance;
        
    }


public void afterUpdateTaskOnGov(List<SD_Governance_Data__c> GovNewList){

set<id>govid=new set<id>();
for(SD_Governance_Data__c gov:GovNewList){
govid.add(gov.id);
}
UtilTaskComplete.taskCompleteList(govid);
afterInsertTaskOnGov(GovNewList);


        }
        
        
        
        
}