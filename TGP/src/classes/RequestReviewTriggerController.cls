/*
Author : Harshit Shah
Story :  
Description :Controller for all the trigger operations on request review.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
*/
public with sharing class RequestReviewTriggerController {
    private static final string CLASS_NAME = 'RequestReviewTriggerController';
    private static final string TRIGGER_NAME = 'OperationsOnRequestReview';
    private static final string METHOD_DELETE = 'DeleteReview';
    private static final string METHOD_UPDATE = 'updateReviewStage';
    /*
    Method Name: updateReviewStage
    Parameter: List<Request_Review__c>
    Return Type: Void
    Description: updating review stage .
    */  
    
    
    public static void updateReviewStage(List<Request_Review__c> listNewRequestReview) {    
        try
        {
            set<Id> reviewProcessRecordsId = new set<Id>();
            Map<ID, List<Request_Review__c>> reviewProcessMappedToRequestReview = new Map<ID, List<Request_Review__c>>();
            Review_Process__c ReviewProcessRecordtoUpdate;
            List<Review_Process__c> listReviewProcessTOUpdate = new List<Review_Process__c>();
            for(Request_Review__c requestReview :listNewRequestReview) {
                reviewProcessRecordsId.add(requestReview.Review_Process__c);
            }           
            for(Review_Process__c rp : [select Id, NewStatus__c, (select Review_Type_Master__c,Review_Type_Master__r.name,id,Review_type__c,Review_User_Master__c,Comments_by_SA__c,Comments_by_approver__c,Approval_email_sent_on__c,
                                                           Response_received_on__c,Send_reminder__c,Select_reviewer__c,Status__c,Review_Process__c,Version__c,Review_User_Master__r.Email_ID_of_the_reviewer__c 
                                             from Request_Reviews__r) from Review_Process__c where Id IN: reviewProcessRecordsId])
            {
                reviewProcessMappedToRequestReview.put(rp.Id, rp.Request_Reviews__r);
            }           
            for(Id reviewProcessRecordId : reviewProcessMappedToRequestReview.keySet()) { 
                List<Request_Review__c> requestReviewList= reviewProcessMappedToRequestReview.get(reviewProcessRecordId);
                ReviewProcessRecordtoUpdate = new Review_Process__c();
                boolean isFinalExist=false;
                boolean isPendingExist=false;
                for(Request_Review__c requestReviewRecord : requestReviewList) {
                    if(requestReviewRecord.Review_Type_Master__r.name==UTIL_Constants.FINAL_APROVAL) {
                        isFinalExist=true;
                        if(requestReviewRecord.status__c== UTIL_Constants.REJECTED || requestReviewRecord.status__c== UTIL_Constants.PENDING  || requestReviewRecord.status__c== UTIL_Constants.REWORK || 
                           requestReviewRecord.status__c==null || requestReviewRecord.status__c == UTIL_Constants.READY_FOR_REVIEW || requestReviewRecord.status__c == UTIL_Constants.NOT_SENT) {
                            isPendingExist=true;
                        }
                    }
                }
                Review_Process__c temp = new Review_Process__c();
                temp = [select Review_Stage_Master__r.name from Review_Process__c where id=:reviewProcessRecordId];
                if(UTIL_Constants.Recover_Master_Message==temp.Review_Stage_Master__r.name)
                {
                ReviewProcessRecordtoUpdate.Id = reviewProcessRecordId;
                ReviewProcessRecordtoUpdate.NewStatus__c= UTIL_Constants.Not_Valid;
                listReviewProcessTOUpdate.add(ReviewProcessRecordtoUpdate);
                } 
                if(isFinalExist && !isPendingExist) {
                    ReviewProcessRecordtoUpdate.Id = reviewProcessRecordId;
                    ReviewProcessRecordtoUpdate.NewStatus__c= UTIL_Constants.APPROVED ;
                                listReviewProcessTOUpdate.add(ReviewProcessRecordtoUpdate);
                }
                else if(isPendingExist) {
                    ReviewProcessRecordtoUpdate.Id = reviewProcessRecordId;
                    ReviewProcessRecordtoUpdate.NewStatus__c= UTIL_Constants.PENDING ;
                                listReviewProcessTOUpdate.add(ReviewProcessRecordtoUpdate);
                }
            }
            database.upsert(listReviewProcessTOUpdate);
        }
        catch(Exception exp) {
           UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_UPDATE, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    
    
    /*
    Method Name: DeleteReview
    Parameter: List<Request_Review__c>
    Return Type: Void
    Description: sending email alert on deleting request review .
    */      
    public static void DeleteReview(List<Request_Review__c> listOldRequestReview) {
        String opportunityId;
        String reviewProcessId;
        try {
            opportunityId = ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_OPPID);
            reviewProcessId = ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);
            if(listOldRequestReview.size()>0) {
                set<Id> oldRequestReviewIdList = new set<Id>();
                for(Request_Review__c requestReview :listOldRequestReview) {
                    oldRequestReviewIdList.add(requestReview.Id);
                }
                List<Review_User_Master__c> lstRvwUserMaster=[Select id,Email_ID_of_the_reviewer__c from Review_User_Master__c limit 5000];
                Map<Id,Request_Review__c> requestReviewIdRecordMap = new Map<Id,Request_Review__c>();
                for(Request_Review__c requestReviewRecord : [Select Review_Type_Master__c,Review_Type_Master__r.name,id,Review_type__c,Review_User_Master__c,Review_Process__c,
                                                            Review_User_Master__r.Email_ID_of_the_reviewer__c from Request_Review__c where Id in : oldRequestReviewIdList limit 5000] ) {
                    requestReviewIdRecordMap.put(requestReviewRecord.Id, requestReviewRecord);
                } 
                List<Opportunity_TGP__c> lstEmailOpp = [Select o.TCV__c,o.Enterprise_Solution_Architect_New__c, o.Enterprise_Solution_Architect_New__r.SFDC_User__c, o.SAP_OM_Opportunity__r.name, o.Operating_Group__r.name, o.Offerings__c, o.Name, o.Id,
                                                                         o.Client_Name__r.name,o.Service_Delivery_Locations_Unique__c,o.Client_Geo_Area__r.name,o.Client_Geo_Unit__r.name From Opportunity_TGP__c o where o.Id = : opportunityId limit 5000];          
                List<User> optysolleadname=[Select id,name from User where id=:lstEmailOpp[0].Enterprise_Solution_Architect_New__r.SFDC_User__c limit 5000];
                List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c limit 5000];
                OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};                                
                if(lstIdForOWA.size()>0) {
                    owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c limit 5000];
                }
                List<Request_Review__c> lstRevw ;
                Messaging.SingleEmailMessage mail;
                for(Request_Review__c c: listOldRequestReview) {
                    for(Review_User_Master__c r :lstRvwUserMaster) {
                        if(c.Review_User_Master__c==r.id) {
                            lstRevw = new List<Request_Review__c>();
                            lstRevw.add(requestReviewIdRecordMap.get(c.id));
                            if(c.Status__c!=null) {
                                if(lstEmailOpp.size()>0) {
                                    String OfferingNames =checkNullValues(lstEmailOpp[0].Offerings__c);
                                    mail = new Messaging.SingleEmailMessage();
                                    if (owea.size() > 0 ) {
                                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                                    } 
                                    String[] toAddresses = new String[] {r.Email_ID_of_the_reviewer__c}; 
                                    mail.setToAddresses(toAddresses);
                                    mail.setSubject('NOTIFICATION:  Request to Approve Final Review Solution has been deleted - Client Name:' +' '+lstEmailOpp[0].Client_Name__r.name+'  '+'-'+' '+'Opportunity Name:  '+lstEmailOpp[0].Name);
                                    String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                                                            +'The request to review the Solution Plan for the below BPO opportunity has been deleted.  Please contact the Lead Solution Architect – BPO for more information.'+'<br/>'
                                                            +'<br/>'+'Opportunity Name:'+'&nbsp;&nbsp;'+ lstEmailOpp[0].Name
                                                            +'<br/>'+'MMS ID:'+'&nbsp;&nbsp;'+ checkNullValues(lstEmailOpp[0].SAP_OM_Opportunity__r.name)
                                                            +'<br/>'+'Client Name:'+'&nbsp;&nbsp;'+lstEmailOpp[0].Client_Name__r.name
                                                            +'<br/>'+'BPO Net Revenue (MMS)(Thousands):'+'&nbsp;&nbsp;'+ checkNullValuesDeciamlTCV(lstEmailOpp[0].TCV__c)
                                                            +'<br/>'+'Client Geo Area:'+'&nbsp;&nbsp;'+lstEmailOpp[0].Client_Geo_Area__r.name
                                                            +'<br/>'+'Operating Group:'+'&nbsp;&nbsp;'+lstEmailOpp[0].Operating_Group__r.name
                                                            +'<br/>'+'Offerings:'+'&nbsp;&nbsp;'+OfferingNames
                                                            +'<br/>'+'Delivery Locations:'+'&nbsp;&nbsp;'+checkNullValues(lstEmailOpp[0].Service_Delivery_Locations_Unique__c)
                                                            +'<br/>'+'Review Type:'+'&nbsp;&nbsp;'+lstRevw.get(0).Review_Type_Master__r.name
                                                            +'<br/>'+'Lead Solution Architect – BPO:'+'&nbsp;&nbsp;'+optysolleadname[0].name 
                                                            +'    '+'<br/><br/>'
                                                            +'<br/>'+'<a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ReviewProcessPage?oppid='+opportunityId+'&id='+reviewProcessId+'" target="_parent">Login to BPO Solution Workbench</a>'+'    <font color="Black"><i>(option for those who have a workbench license)</i></font>' +                                              
                                                            +'    '+'<br/><br/>'                                            
                                                            +'    '+'<br/>This is a system generated message.<br/></span>';
                                    mail.setHtmlBody(htmlEmailBody);
                                    mail.saveAsActivity=false;
                                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
                                }
                            }
                        }
                    }
                }
            }
          }
          catch(Exception exp) {
            system.debug('>>This Exception'+exp);
          UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_DELETE, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
          }
          
    }
    
    
    /*
    Method Name: sendApprovalResponseMail
    Parameter: List<Request_Review__c>
    Return Type: Void
    Description: sending email alert on deleting request review .
    */      
    public static void sendApprovalResponseMail(List<Request_Review__c> listRequestReview, List<Request_Review__c> listOldRequestReview) {
        List<Request_Review__c> listNewRequestReview = [select Id, Review_Process__r.BPO_Opportunity__r.Enterprise_Solution_Architect_New__r.Email_ID_of_the_reviewer__c, Review_Process__r.BPO_Opportunity__r.SAP_OM_Opportunity__r.name, Comments_by_approver__c, Review_Process__r.BPO_Opportunity__r.Name, Review_Type_Master__r.Name, Review_Process__r.Review_Stage_Master__r.Name, Review_Process__r.BPO_Opportunity__r.Client_Name__r.Name, Review_Process__r.BPO_Opportunity__r.Offerings__c, Review_User_Master__r.Email_ID_of_the_reviewer__c, Response_From__c, Status__c from Request_Review__c where Id IN: listRequestReview];                              
        Messaging.SingleEmailMessage mail;
        OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};
        List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c limit 5000];
        if(lstIdForOWA.size()>0)
        {
            owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c ];
        }
        
        for(Request_Review__c requestReviewRec :listNewRequestReview) {
            for(Request_Review__c requestReviewRecOld : listOldRequestReview) { 
                if(requestReviewRecOld.Id == requestReviewRec.Id) {
                    mail = new Messaging.SingleEmailMessage();
                    if (owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    if((requestReviewRecOld.Status__c != requestReviewRec.Status__c) && (requestReviewRecOld.Status__c != 'Not Sent')) {
                        String[] toAddresses = new String[] {checkNullValues(requestReviewRec.Review_User_Master__r.Email_ID_of_the_reviewer__c)};
                        String[] ccAddresses = new String[]{checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Enterprise_Solution_Architect_New__r.Email_ID_of_the_reviewer__c)};
                        mail.setToAddresses(toAddresses);
                        mail.setccAddresses(ccAddresses);
                        mail.setSubject('Response Received - Client Name: “' +' '+checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Client_Name__r.Name)+'”  '+'-'+' '+'Opportunity Name:  “'+checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Name) + '”');
                        String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                                                +'Your response was received by Solution Workbench and recorded as follows:'+'<br/>'
                                                +'<br/>'+'MMS ID:'+'&nbsp;&nbsp;'+ checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.SAP_OM_Opportunity__r.name)                      
                                                +'<br/>'+'Client Name:'+'&nbsp;&nbsp;'+checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Client_Name__r.Name)
                                                +'<br/>'+'Opportunity Name:'+'&nbsp;&nbsp;'+ checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Name)                                                
                                                +'<br/>'+'Offerings:'+'&nbsp;&nbsp;'+checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Offerings__c)
                                                +'<br/>'+'Approval Stage:'+'&nbsp;&nbsp;'+checkNullValues(requestReviewRec.Review_Process__r.Review_Stage_Master__r.Name)
                                                +'<br/>'+'Approval Type:'+'&nbsp;&nbsp;'+checkNullValues(requestReviewRec.Review_Type_Master__r.Name)
                                                +'<br/>'+'Approver Name:'+'&nbsp;&nbsp;'+ checkNullValues(requestReviewRec.Response_From__c)
                                                +'<br/>'+'Response Recorded:'+'&nbsp;&nbsp;'+ checkNullValues(requestReviewRec.Status__c)
                                                +'<br/>'+'Approver Comments:'+'&nbsp;&nbsp;'+ checkNullValues(requestReviewRec.Comments_by_approver__c)
                                                +'    '+'<br/><br/>'
                                                +'Link to' + '<a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ReviewProcessPage?oppid='+requestReviewRec.Review_Process__r.BPO_Opportunity__c+'&id='+requestReviewRec.Review_Process__c+'" target="_parent"> Opportunity Approval tab </a>' + 'in Solution Workbench' + '<font color="Black"><i>(option for those who have a workbench license)</i></font>'
                                                +'    '+'<br/><br/>'                                               
                                                +'    '+'<br/>This is a system generated message.<br/></span>'; 
                        mail.setHtmlBody(htmlEmailBody);
                        mail.saveAsActivity=false;
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                        
                    }
                }
           }
        }
    }
    
    
    /*
    Method Name: sendApprovalResponseMail
    Parameter: List<Request_Review__c>
    Return Type: Void
    Description: sending email alert on deleting request review .
          
    public static void sendApprovalResponseMailToRequestor(List<Request_Review__c> listRequestReview, List<Request_Review__c> listOldRequestReview) {
        List<Request_Review__c> listNewRequestReview = [select Id, Approval_Requestor__c, Response_From__c , Approval_Requestor__r.Email, Review_Process__r.BPO_Opportunity__r.SAP_OM_Opportunity__r.name, Review_Process__r.BPO_Opportunity__r.Name, Review_Type_Master__r.Name, Review_Process__r.Review_Stage_Master__r.Name, Review_Process__r.BPO_Opportunity__r.Client_Name__r.Name, Review_Process__r.BPO_Opportunity__r.Offerings__c, Review_User_Master__r.Name, Comments_by_approver__c, Review_User_Master__r.Email_ID_of_the_reviewer__c, Status__c from Request_Review__c where Id IN: listRequestReview];                              
        Messaging.SingleEmailMessage mail;
        OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};
        List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c];
        if(lstIdForOWA.size()>0)
        {
            owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c ];
        }
        for(Request_Review__c requestReviewRec :listNewRequestReview) {
            for(Request_Review__c requestReviewRecOld : listOldRequestReview) { 
                if(requestReviewRecOld.Id == requestReviewRec.Id) {
                    mail = new Messaging.SingleEmailMessage();
                    if (owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    if((requestReviewRecOld.Status__c != requestReviewRec.Status__c) && (requestReviewRecOld.Status__c != 'Not Sent') && (requestReviewRec.Approval_Requestor__r.Email != null)) {
                        String[] toAddresses = new String[] {checkNullValues(requestReviewRec.Approval_Requestor__r.Email)};
                        mail.setToAddresses(toAddresses);
                        mail.setSubject('Approver Responded - Client Name:' +' '+checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Client_Name__r.Name)+' '+'-'+' '+'Opportunity Name:  '+checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Name));
                        String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                                                +'Approver has responded to your approval request. Response is as mentioned below'+'<br/>'
                                                +'<br/>'+'OM ID:'+'&nbsp;&nbsp;'+ checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.SAP_OM_Opportunity__r.name)                      
                                                +'<br/>'+'Opportunity Name:'+'&nbsp;&nbsp;'+ checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Name)
                                                +'<br/>'+'Client Name:'+'&nbsp;&nbsp;'+checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Client_Name__r.Name)
                                                +'<br/>'+'Offerings:'+'&nbsp;&nbsp;'+checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Offerings__c)
                                                +'<br/>'+'Review Stage:'+'&nbsp;&nbsp;'+checkNullValues(requestReviewRec.Review_Process__r.Review_Stage_Master__r.Name)
                                                +'<br/>'+'Review Type:'+'&nbsp;&nbsp;'+checkNullValues(requestReviewRec.Review_Type_Master__r.Name)
                                                +'<br/>'+'Approver Name:'+'&nbsp;&nbsp;'+ checkNullValues(requestReviewRec.Response_From__c)
                                                +'<br/>'+'Approver Response:'+'&nbsp;&nbsp;'+ checkNullValues(requestReviewRec.Status__c)
                                                +'<br/>'+'Approver Comments:'+'&nbsp;&nbsp;'+ checkNullValues(requestReviewRec.Comments_by_approver__c)
                                                +'    '+'<br/><br/>'
                                                +'<br/>'+'<a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ReviewProcessPage?oppid='+requestReviewRec.Review_Process__r.BPO_Opportunity__c+'&id='+requestReviewRec.Review_Process__c+' " target="_parent">Login to BPO Solution Workbench</a>'+'    <font color="Black"><i>(option for those who have a workbench license)</i></font>' +                                             
                                                +'    '+'<br/><br/>'                                               
                                                +'    '+'<br/>This is a system generated message.<br/></span>';                                             
                                                
                                                  
                        mail.setHtmlBody(htmlEmailBody);
                        mail.saveAsActivity=false;
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                        
                    }
                }
           }
        }
    }                            
         
         
         
   */      
     
    /*
    Method Name: sendAlertToFinalApprover
    Parameter: List<Request_Review__c>
    Return Type: Void
    Description: sending email alert on deleting request review .
    */      
    public static void sendAlertToFinalApprover(List<Request_Review__c> listRequestReview, List<Request_Review__c> listOldRequestReview) {
        List<Request_Review__c> listFinalRequestReview = new   List<Request_Review__c>();
        set<Id> reviewProcessSet = new set<Id>();
        for(Request_Review__c rr : listRequestReview ) {
            reviewProcessSet.add(rr.Review_Process__c); 
        }
        listFinalRequestReview  = [select Id, Approval_Requestor__c, Approval_Requestor__r.Email, Review_Process__r.BPO_Opportunity__r.Offerings__c, Review_Process__r.BPO_Opportunity__r.Service_Delivery_Locations_Unique__c, Review_Process__r.BPO_Opportunity__r.Operating_Group__r.name, Review_Process__r.BPO_Opportunity__r.Client_Geo_Area__r.name, Review_Process__r.BPO_Opportunity__r.TCV__c, Review_Process__r.BPO_Opportunity__r.SAP_OM_Opportunity__r.name, Review_Process__r.BPO_Opportunity__r.Name, Review_Type_Master__r.Name, Review_Process__r.Review_Stage_Master__r.Name, Review_Process__r.BPO_Opportunity__r.Client_Name__r.Name, Review_User_Master__r.Email_ID_of_the_reviewer__c, Status__c from Request_Review__c where Review_Process__c IN: reviewProcessSet AND Review_Type_Master__r.Name = 'Final Approval']; 
        List<Request_Review__c> listNewRequestReview = [select Id, Approval_Requestor__c, Approval_Requestor__r.Email, Review_Process__r.BPO_Opportunity__r.Offerings__c, Review_Process__r.BPO_Opportunity__r.Service_Delivery_Locations_Unique__c, Review_Process__r.BPO_Opportunity__r.Operating_Group__r.name, Review_Process__r.BPO_Opportunity__r.Client_Geo_Area__r.name, Review_Process__r.BPO_Opportunity__r.TCV__c, Review_Process__r.BPO_Opportunity__r.SAP_OM_Opportunity__r.name, Review_Process__r.BPO_Opportunity__r.Name, Review_Type_Master__r.Name, Review_Process__r.Review_Stage_Master__r.Name, Review_Process__r.BPO_Opportunity__r.Client_Name__r.Name, Review_User_Master__r.Email_ID_of_the_reviewer__c, Status__c from Request_Review__c where Review_Process__c IN: reviewProcessSet AND Review_Type_Master__r.Name != 'Final Approval'];                              
        
        if(listFinalRequestReview != null && listFinalRequestReview.size() > 0) {
            boolean areAllApproved = true;
            for(Request_Review__c requestReviewRec :listNewRequestReview) {
                if((requestReviewRec.Status__c == 'Pending' ||  requestReviewRec.Status__c == 'Ready For Review' || requestReviewRec.Status__c == 'Rework' || requestReviewRec.Status__c == 'Reject' || requestReviewRec.Status__c == 'Not Sent')
                 && (requestReviewRec.Review_Type_Master__r.Name != 'Final Approval')) {
                   areAllApproved = false;
                }        
            }
            if(areAllApproved == true) {
                Messaging.SingleEmailMessage mail;
                OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};
                List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c];
                if(lstIdForOWA.size()>0)
                {
                    owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c ];
                }
                for(Request_Review__c requestReviewRec :listFinalRequestReview) {
                    if(requestReviewRec.Status__c != 'Approved') {
                        mail = new Messaging.SingleEmailMessage();
                        if (owea.size() > 0 ) {
                            mail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        String[] toAddresses = new String[] {checkNullValues(requestReviewRec.Review_User_Master__r.Email_ID_of_the_reviewer__c)};
                            mail.setToAddresses(toAddresses);
                            mail.setSubject('Other Approvers have responded for Client: “' +checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Client_Name__r.Name) +'” Opportuinty: “'+checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Name) + '”');
                            String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                                                        +'<br>'
                                                        +'The Opportunity is “Approved” by all other approvers and is ready for your final approval for the current stage.'+'<br>'
                                                        +'<br>'+'MMS ID: '+checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.SAP_OM_Opportunity__r.name)
                                                        +'<br>'+'Client Name: '+checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Client_Name__r.name)
                                                        +'<br>'+'Opportunity Name:  '+' '+checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Name)                                                     
                                                        +'<br>'+'BPO Net Revenue (MMS)(Thousands): '+checkNullValuesDeciamlTCV(requestReviewRec.Review_Process__r.BPO_Opportunity__r.TCV__c)
                                                        +'<br>'+'Client Geo Area: '+checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Client_Geo_Area__r.name)
                                                        +'<br>'+'Operating Group: '+checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Operating_Group__r.name)
                                                        +'<br>'+'Offerings: '+checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Offerings__c)
                                                        +'<br>'+'Delivery Locations: '+checkNullValues(requestReviewRec.Review_Process__r.BPO_Opportunity__r.Service_Delivery_Locations_Unique__c)
                                                        +'<br>'+'Approval Stage: '+checkNullValues(requestReviewRec.Review_Process__r.Review_Stage_Master__r.name)
                                                        +'<br>'+'Approval Type: '+checkNullValues(requestReviewRec.Review_Type_Master__r.Name)
                                                        +'    '+'<br><br>'
                                                    +'Link to' + '<a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ReviewProcessPage?oppid='+requestReviewRec.Review_Process__r.BPO_Opportunity__c+'&id='+requestReviewRec.Review_Process__c+'" target="_parent"> Opportunity Approval tab </a>' + 'in Solution Workbench' + '<font color="Black"><i>(option for those who have a workbench license)</i></font>'
                                                    +'    '+'<br/><br/>'                                               
                                                    +'    '+'<br/>This is a system generated message.<br/></span>';
                                                    
                                                      
                            mail.setHtmlBody(htmlEmailBody);
                            mail.saveAsActivity=false;
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                   } 
                }        
            }
        }
    }                             
        /******************************
        Method Name: checkNullValues
        Description: Method to check null and return empty string.
        Parameters : String
        Return Value: String            
        *******************************/
        
        public Static String checkNullValues(String value)
        {
            if(value==null) {
                return UTIL_Constants.EMPTY_STRING;
            }
            else {
                return value;
            }
            
        }
        
        /******************************
        Method Name: checkNullValuesDecimalTCV
        Description: Method to check null and return empty string.
        Parameters : Decimal
        Return Value: String         
        *******************************/
        public Static String checkNullValuesDeciamlTCV(Decimal value)
        {
            if(value==null) {
                return UTIL_Constants.EMPTY_STRING;
            }
            else {
                return UTIL_Constants.EMPTY_STRING+ UTIL_Constants.DOLLAR +String.ValueOf(value.setScale(0).format());
            }
            
        }
    
     

}