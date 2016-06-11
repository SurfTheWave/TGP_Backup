/*
@Author :  mukesh rawat
@name : SRATApprovalProcessController
@CreateDate :    2/3/2015 8:27 AM
@Description : 
@Version : 2
@Modified by : Suma
@Purpose  :  Added missing functionalities for GTL Aproval on 4/16/2015 9:42 PM 
*/
public without sharing class SRATApprovalProcessController {

    public static boolean isExecuting = false;
    List < RecordType > RecId = new List < RecordType > ();
    public List<String> usrEmail{get;set;}
/*
@Author :  mukesh rawat
@name : SRATApprovalProcessController
@CreateDate :    2/3/2015 8:27 AM
@Description : 
@Version : 
*/
    public void submitForApproval(SRAT_Tracker__c sratApprove,List<Mobilization_Team__c> mobTeamRoleList) {
        try{
        
        List < Mobilization_Team__c > SList = new List < Mobilization_Team__c > ();
        SList = [SELECT id, name, Primary_Lead__r.User__c,Primary_Lead__r.user__r.Email 
                 FROM Mobilization_Team__c WHERE id IN: mobTeamRoleList LIMIT 1];
        //system.debug('SList  inside a comtroller::'+SList[0].Primary_Lead__r.User__c);
        // adding submit checklist reviewer name to the item.
        SRAT_Tracker__c sratNew = new SRAT_Tracker__c(Id = sratApprove.Id);
        if(sratApprove.Checklist_Reviewer__c == NULL){
           sratNew.Checklist_Reviewer__c = mobTeamRoleList[0].id;
            database.Update(sratNew);
        }       
        
        	task t1 = new task ();

            t1.ActivityDate = Date.today()+3;
            t1.Status = UtillContstant_Novasuite.NOT_STARTED;
            t1.Description = UtillContstant_Novasuite.SRAT_CHK1;
            t1.Subject = sratApprove.Mobilization_Plan__r.Deal__r.Name+UtillContstant_Novasuite.SRAT_CHK;
            t1.OwnerId = SList[0].Primary_Lead__r.user__c;
            t1.WhatId = sratApprove.Id;
            t1.Priority = UtillContstant_Novasuite.NORMAL;
            insert t1;

        
        /*
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setProcessDefinitionNameOrId(UtilConstants.APPROV_MSG);
        req1.setComments(UtilConstants.MSG_1121);
        req1.setSkipEntryCriteria(true);
        req1.setObjectId(sratApprove.id);
        req1.setNextApproverIds(new Id[] {
            SList[0].Primary_Lead__r.user__c
        });        

        Approval.ProcessResult result = Approval.process(req1);
        List < Id > newWorkItemIds = result.getNewWorkitemIds();
        //System.debug('result *****' +result);
        */
        
        usrEmail=new List<String>();
        usrEmail.clear();
        If(SList[0].Primary_Lead__r.user__r.Email != null) {
            usrEmail.add(SList[0].Primary_Lead__r.user__r.Email);
        }
        if(usrEmail.size()>0) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        string [] toaddress=usrEmail;
            email.setToAddresses(toaddress);
        email.setSenderDisplayName(UtillContstant_Novasuite.BPO_WKB);
        email.setSubject(UtillContstant_Novasuite.SRAT_APP +sratApprove.Name);
        email.setHtmlBody(UtillContstant_Novasuite.SRAT_MSG1 + System.URL.getSalesforceBaseUrl().getHost() 
                          + UtillContstant_Novasuite.FWD_SLASh +sratApprove.Id+ UtillContstant_Novasuite.SRAT_MSG2);  
        
        Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});
        }
        
        }Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);
        }
    }

    
    
/*
@Author :  mukesh rawat
@name : SRATApprovalProcessController
@CreateDate :    2/3/2015 8:27 AM
@Description : 
@Version : 

    public void approveRecord(SRAT_Tracker__c sratApprove) {
        try{
        if (SRATApprovalProcessController.isExecuting) {
            // if was executed during the same context avoid recursion
            return;
        }
        
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments(UtilConstants.MSG_1122);
        req.setAction(UtilConstants.APPROVE);
        //req.setNextApproverIds(new Id[] {sListapprove[0].Primary_Lead__r.user__c});
                
        Id workItemId = getWorkItemId(sratApprove.id);
        if (workItemId != null) {
            req.setWorkitemId(workItemId);
            Approval.ProcessResult result = Approval.process(req);
        } 
    
        SRATApprovalProcessController.isExecuting = true;
        SRAT_Tracker__c[] sratList = new SRAT_Tracker__c[] {};
        //Here the magic by creating a new instance using the same id.
        SRAT_Tracker__c sratNew = new SRAT_Tracker__c(Id = sratApprove.Id);
        sratNew.Checklist_Status__c = UtilConstants.SUBMITTED;
        sratNew.Completed__c = UtilConstants.YES;
        sratNew.Actual_Date__c = System.TODAY();
        sratNew.RAG_Status__c = UtilConstants.GREEN;        
        
        RecId = [select Id, Name from RecordType where DeveloperName = : UtilConstants.SRAT_TRACKER and SobjectType = : UtilConstants.SRAT_OBJ LIMIT 1];
        sratNew.RecordTypeId = RecId[0].Id;
        //then updating the new instance list. 
        update sratNew;
        }Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);
        }
    }

@Author :  mukesh rawat
@name : SRATApprovalProcessController
@CreateDate :    2/3/2015 8:27 AM
@Description : 
@Version : 


    public Id getWorkItemId(Id targetObjectId) {
    try{
        Id retVal = null;
        for (ProcessInstanceWorkitem workItem: [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = : targetObjectId Limit 5000]) {
            retVal = workItem.Id;
        }
        return retVal;
    }Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);
        }
    }
*/  
}