/**
 * Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 */
global class RivewAndApprovalInboundEmail implements Messaging.InboundEmailHandler
{   private static final string CLASS_NAME = 'RivewAndApprovalInboundEmail';
    private static final string TRIGGER_NAME = '';
    private static final string METHOD_NAME = 'handleInboundEmail';
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
    Messaging.InboundEnvelope envelope) 
    {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();   
        String reviewId = email.plainTextBody.substringBetween('#'); 
        
        List<Request_Review__c> listRequestReview=[select id,Review_type__c,Review_User_Master__c,Comments_by_SA__c,Comments_by_approver__c,
                                                    Approval_email_sent_on__c,Response_received_on__c,Send_reminder__c,Select_reviewer__c,
                                                    Review_Process__r.BPO_Opportunity__r.SAP_OM_Opportunity__r.name, Review_Process__r.BPO_Opportunity__r.Name, 
                                                    Review_Type_Master__r.Name, Review_Process__r.Review_Stage_Master__r.Name,Review_Process__r.BPO_Opportunity__r.Enterprise_Solution_Architect_New__r.Email_ID_of_the_reviewer__c, 
                                                    Review_Process__r.BPO_Opportunity__r.Client_Name__r.Name, Review_Process__r.BPO_Opportunity__r.Offerings__c, 
                                                    Review_User_Master__r.Email_ID_of_the_reviewer__c,Review_User_Master__r.Name,
                                                    Status__c,Review_Process__c,version__c from Request_Review__c where id=:reviewId.trim()];   
        
        try
        {
            if(listRequestReview.size()==1)
            {
                
                 if(listRequestReview[0].Status__c=='Approved' && (email.plainTextBody.containsIgnoreCase('< approved >') || 
                                                                    email.plainTextBody.containsIgnoreCase('< rejected >') ||
                                                                    email.plainTextBody.containsIgnoreCase('< Rework >') ||
                                                                    email.plainTextBody.containsIgnoreCase('< Ready For Review >'))){
                    
                        
                        OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};
                        List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c];
                        if(lstIdForOWA.size()>0)
                        {
                            owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c ];
                        }
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        if ( owea.size() > 0 ) 
                        {
                            mail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        //List<String> toAddresses = getEmailAddresses();
                        List<String> toAddresses = new List<String>();
                        
                        
                        toAddresses.add(checkNullValues(listRequestReview[0].Review_User_Master__r.Email_ID_of_the_reviewer__c));
                        
                        
                        mail.setToAddresses(toAddresses);
                        mail.replyTo=System.Label.Review_and_Approval_Email;
                        mail.setSubject('ALERT: Response Already Recorded - Client Name:' +' '+checkNullValues(listRequestReview[0].Review_Process__r.BPO_Opportunity__r.Client_Name__r.Name)+'  '+'-'+' '+'Opportunity Name:  '+checkNullValues(listRequestReview[0].Review_Process__r.BPO_Opportunity__r.Name));
                        String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                                                +'Hi,'+'<br/>'
                                                +'<br/>'+'Approval has already been recorded in the system. Hence no further action required by you.<br/>'                      
                                                +'<br/>'+'Regards,<br/>'
                                                                                         
                                                +'    '+'SWB Admin<br/></span>';
                        mail.setHtmlBody(htmlEmailBody);
                        mail.saveAsActivity=false;
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
                        
                        
                        email.plainTextBody = ' ';
                        
                }
                
                
                if(listRequestReview[0].Status__c!='Approved' && (email.plainTextBody.containsIgnoreCase('< approved >') ||
                    email.plainTextBody.containsIgnoreCase('< rejected >') ||
                    email.plainTextBody.containsIgnoreCase('< Rework >') ||
                    email.plainTextBody.containsIgnoreCase('< Ready For Review >')
                    )) 
                {              
                    if(email.plainTextBody.containsIgnoreCase('< approved >'))
                    {
                       listRequestReview[0].Send_reminder__c=false;
                       listRequestReview[0].Select_reviewer__c=false;
                       listRequestReview[0].Status__c='Approved';
                    }                           
                    else if(email.plainTextBody.containsIgnoreCase('< rejected >'))
                    {
                        listRequestReview[0].Send_reminder__c=false;
                        listRequestReview[0].Status__c='Reject';
                    }
                    else if(email.plainTextBody.containsIgnoreCase('< Rework >'))
                    {
                        listRequestReview[0].Send_reminder__c=false;
                        listRequestReview[0].Status__c='Rework';
                    }
                    else if(email.plainTextBody.containsIgnoreCase('< Ready For Review >'))
                    {
                        listRequestReview[0].Send_reminder__c=false;
                        listRequestReview[0].Select_reviewer__c=false;
                        listRequestReview[0].Status__c='Ready For Review';
                    }
                    else {
                        
                    }
                    String approvalComments = email.plainTextBody.substringBetween('*'); 
                      //listRequestReview[0].Comments_by_approver__c=approvalComments;
                    if(approvalComments != 'Provide your comments here by replacing Text in between asterisks'){                 
                        listRequestReview[0].Comments_by_approver__c=approvalComments;  
                    }
                    listRequestReview[0].Response_received_on__c=system.today();
                    String fromAddress = email.fromAddress;
                    String responseFrom = fromAddress.substring(0,FromAddress.indexOf('@'));
                    String responseShould = listRequestReview[0].Review_User_Master__r.Email_ID_of_the_reviewer__c.substring(0,listRequestReview[0].Review_User_Master__r.Email_ID_of_the_reviewer__c.indexOf('@'));    
                    listRequestReview[0].Response_From__c = responseFrom;
                    System.debug('===='+responseFrom);
                    System.debug('===='+responseShould);
                    if(responseFrom == responseShould) {                
                        upsert listRequestReview[0];
                        List<Task> myTask=[Select id, Approval_Status__c from Task where Request_Review_Id__c=:listRequestReview[0].id];
                        System.debug('----myTask------------'+myTask);
                        if(myTask.size()>0)
                        {
                            myTask[0].Approval_Status__c = listRequestReview[0].Status__c; 
                            upsert myTask[0];    
                        }
                        result.success = true;
                   }
                   else {
                       OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};
                        List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c];
                        if(lstIdForOWA.size()>0)
                        {
                            owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c ];
                        }
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        if ( owea.size() > 0 ) 
                        {
                            mail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        String ccemailID='';
                        List<String> toAddresses = new List<String>();
                        List<User> userEmailList=[SELECT Email FROM User where id=:UserInfo.getUserId()];
                        if(userEmailList.size()==1)
                        {
                            ccemailID=userEmailList[0].Email;
                        }
                        toAddresses.add(email.fromAddress);
                        mail.setToAddresses(toAddresses);
                        mail.setCcAddresses(new String[] { ccemailID, listRequestReview[0].Review_User_Master__r.Email_ID_of_the_reviewer__c,listRequestReview[0].Review_Process__r.BPO_Opportunity__r.Enterprise_Solution_Architect_New__r.Email_ID_of_the_reviewer__c});
                        mail.replyTo=System.Label.Review_and_Approval_Email;
                        mail.setSubject('ALERT: Unauthorized Response - Client Name:' +' '+checkNullValues(listRequestReview[0].Review_Process__r.BPO_Opportunity__r.Client_Name__r.Name)+'  '+'-'+' '+'Opportunity Name:  '+checkNullValues(listRequestReview[0].Review_Process__r.BPO_Opportunity__r.Name));
                        String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                                                +'Response not recorded by system.You are not the authorized person to respond to this approval request.'+'<br/>'
                                                +'<br/>'+'OM ID:'+'&nbsp;&nbsp;'+ checkNullValues(listRequestReview[0].Review_Process__r.BPO_Opportunity__r.SAP_OM_Opportunity__r.name)                      
                                                +'<br/>'+'Opportunity Name:'+'&nbsp;&nbsp;'+ checkNullValues(listRequestReview[0].Review_Process__r.BPO_Opportunity__r.Name)
                                                +'<br/>'+'Client Name:'+'&nbsp;&nbsp;'+checkNullValues(listRequestReview[0].Review_Process__r.BPO_Opportunity__r.Client_Name__r.Name)
                                                +'<br/>'+'Offerings:'+'&nbsp;&nbsp;'+checkNullValues(listRequestReview[0].Review_Process__r.BPO_Opportunity__r.Offerings__c)
                                                +'<br/>'+'Review Stage:'+'&nbsp;&nbsp;'+checkNullValues(listRequestReview[0].Review_Process__r.Review_Stage_Master__r.Name)
                                                +'<br/>'+'Review Type:'+'&nbsp;&nbsp;'+checkNullValues(listRequestReview[0].Review_Type_Master__r.Name)
                                                +'<br/>'+'Approver Name: '+'&nbsp;&nbsp;'+ checkNullValues(listRequestReview[0].Review_User_Master__r.Name)                                           
                                                +'    '+'<br/><br/>'                                           
                                                +'    '+'<br/>This is a system generated message.<br/></span>';
                        mail.setHtmlBody(htmlEmailBody);
                        mail.saveAsActivity=false;
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                   }
                }
                
                
                if(listRequestReview[0].Status__c!='Approved' && (email.plainTextBody.containsIgnoreCase('< approved >') )||
                    listRequestReview[0].Status__c!='reject' && (email.plainTextBody.containsIgnoreCase('< rejected >')) ||
                    listRequestReview[0].Status__c!='Rework' && (email.plainTextBody.containsIgnoreCase('< Rework >')) ||
                    listRequestReview[0].Status__c!='Ready For Review' && (email.plainTextBody.containsIgnoreCase('< Ready For Review >'))
                ){
                    
                        OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};
                        List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c];
                        if(lstIdForOWA.size()>0)
                        {
                            owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c ];
                        }
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        if ( owea.size() > 0 ) 
                        {
                            mail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        List<String> toAddresses = getEmailAddresses();
                        toAddresses.add(checkNullValues(listRequestReview[0].Review_User_Master__r.Email_ID_of_the_reviewer__c));
                        mail.setToAddresses(toAddresses);
                        mail.replyTo=System.Label.Review_and_Approval_Email;
                        mail.setSubject('ALERT: Response Not Recorded - Client Name:' +' '+checkNullValues(listRequestReview[0].Review_Process__r.BPO_Opportunity__r.Client_Name__r.Name)+'  '+'-'+' '+'Opportunity Name:  '+checkNullValues(listRequestReview[0].Review_Process__r.BPO_Opportunity__r.Name));
                        String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                                                +'Response not recorded by system.'+'<br/>'
                                                +'<br/>'+'OM ID:'+'&nbsp;&nbsp;'+ checkNullValues(listRequestReview[0].Review_Process__r.BPO_Opportunity__r.SAP_OM_Opportunity__r.name)                      
                                                +'<br/>'+'Opportunity Name:'+'&nbsp;&nbsp;'+ checkNullValues(listRequestReview[0].Review_Process__r.BPO_Opportunity__r.Name)
                                                +'<br/>'+'Client Name:'+'&nbsp;&nbsp;'+checkNullValues(listRequestReview[0].Review_Process__r.BPO_Opportunity__r.Client_Name__r.Name)
                                                +'<br/>'+'Offerings:'+'&nbsp;&nbsp;'+checkNullValues(listRequestReview[0].Review_Process__r.BPO_Opportunity__r.Offerings__c)
                                                +'<br/>'+'Review Stage:'+'&nbsp;&nbsp;'+checkNullValues(listRequestReview[0].Review_Process__r.Review_Stage_Master__r.Name)
                                                +'<br/>'+'Review Type:'+'&nbsp;&nbsp;'+checkNullValues(listRequestReview[0].Review_Type_Master__r.Name)
                                                +'<br/>'+'Existing Response: '+'&nbsp;&nbsp;'+ checkNullValues(listRequestReview[0].Status__c)
                                                +'    '+'<br/><br/>'  
                                                +'    '+'<br/>The response is not Recorded, please check with administrator.<br/>' 
                                                +'<br/>'+'<a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ReviewProcessPage?oppid='+listRequestReview[0].Review_Process__r.BPO_Opportunity__c+'&id='+listRequestReview[0].Review_Process__c+'" target="_parent">Login to BPO Solution Workbench</a>'                                           
                                                +'    '+'<br/><br/>'                                           
                                                +'    '+'<br/>This is a system generated message.<br/></span>';
                        mail.setHtmlBody(htmlEmailBody);
                        mail.saveAsActivity=false;
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
                }
                
               
                
                 
                
            }            
            
        }
        catch(Exception exp) {
          UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_NAME, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
          }
        return result;
    }
    private Static String checkNullValues(String value)
        {
            if(value==null) {
                return UTIL_Constants.EMPTY_STRING;
            }
            else {
                return value;
            }
            
        }
        
        /******************************
    Method Name: getEmailAddresses
    Description: To retrieve Email Addresses of user PMO Group
    Paramenters: NA
    Return Value: List<String>
    *******************************/  
     private static List<String> getEmailAddresses()
     {
        List<String> idList = new List<String>();    
        List<String> mailToAddresses = new List<String>();
        //List for Unprocessed Approval Mail Group
        List<String> lstGrpPMO = new List<String>();
        lstGrpPMO.add('Unprocessed Approval Mail Group');  
        List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpPMO]; 
            for(integer i=0;i<g.size();i++ )
            {
                for (GroupMember gm : g[i].groupMembers) {        
                    idList.add(gm.userOrGroupId);
                }    
            }
            User[] usr = [SELECT email FROM user WHERE id IN :idList];    
            for(User u : usr) {        
                mailToAddresses.add(u.email);    
            }
            return mailToAddresses; 
      } 
}