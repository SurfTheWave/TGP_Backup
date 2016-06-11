/**
   @Author :Apoorva Sharma
   @name   : TechApprovalEmailService 
   @CreateDate : 27 November 2015 
   @Description : This class is used for perform operations on Tech Approval Request, when approval is done via mail.
   @Version : 1.0 
  */
global without sharing  class TechApprovalEmailService implements Messaging.InboundEmailHandler {
     
     private static final string CLASS_NAME = UtilConstants.APPROVE_AGENDA;
     private static final string METHOD_NAME = UtilConstants.HANDLE_INBOUND;                     
     public string subject;
     
     
     /**
     * @description       Handles the action when a approver responses vai mail
     * @param             Messaging.InboundEmail email, Messaging.InboundEnvelope envelope
     * @return            Messaging.InboundEmailResult
     * @throws            DML Exception
     */  
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        List<ExceptionLog__c> ExceptionLog=new List<ExceptionLog__c>();
        subject = email.subject;
        String reviewId = email.plaintextBody.substringBetween(UtilConstants.HASH); 
        reviewId=reviewId.replace(UtilConstants.QTS,UtilConstants.EMPTY_STRING);
        id emailtempid = [select id from emailtemplate where developername=:UtillContstant_Novasuite.TECH_FINAL_APP_CAN_NOT_BE_APVED limit 1].id;      
        String orgWideEmailAddressID=UtilEmail.emailid();
          
        string ccVal=emailtempid; 
        if(email.plainTextBody.containsIgnoreCase(UtilConstants.APPR)|| email.plainTextBody.containsIgnoreCase(UtilConstants.REJECT)||
         email.plainTextBody.containsIgnoreCase(UtilConstants.READY_FOR_REVIEW) || email.plainTextBody.containsIgnoreCase(UtilConstants.REWORK)){
            
            List<Tech_Approval_Request__c> listRequestReview=[Select id,approval_stage__r.Id,comments_by_approver__c,approval_stage__r.approval_stage_type__c,
                                                        Approver__c, Approver__r.Email__c,approval_stage__r.Opportunity__c,approver__r.user__c, 
                                                        approval_request_status__c,response_received_date__c,Requestor__r.Email__c,
                                                        approval_stage__r.approval_stage_status__c,approval_request_type__c,Final_Approval__c,
                                                        Service_Group__c,RecordTypeId from Tech_Approval_Request__c where id=:reviewId limit 50000]; 
                                                        
            map<string,Id> recordTypeMap = new map<string,Id>();
            for(RecordType r:[Select Id, Name From RecordType Where sObjectType = :UtilConstantsR3.APPR_REQ and isActive = true LIMIT 5000 ]){
                recordTypeMap.put(r.Name, r.Id);
            }
            
            if(!listRequestReview.isEmpty() && listRequestReview.size()==1){
                String Approverid=listRequestReview[0].approver__r.user__c;  
                if(!listRequestReview[0].approval_request_status__c.equalsignorecase(UtilConstants.PEND_WITH_REQSTR)){
                      String fromAddress = email.fromAddress;
                      String responseShould = listRequestReview[0].Approver__r.Email__c;
                      String approvalComments = email.plainTextBody.substringBetween(UtilConstants.ASTRIC); 
                      if(!fromAddress.equalsIgnoreCase(responseShould)){
                            checkUnauthorizedAccess(email, listRequestReview);
                      }
                      else{
                        // updates the approval request status that is coming from the mail
                        
                        
                        if(email.plainTextBody.containsIgnoreCase(UtilConstants.REJ)){
                            listRequestReview[0].approval_request_status__c=UtilConstants.REJ;
                            listRequestReview[0].RecordTypeId = recordTypeMap.get(UtilConstants.PRIOR);
                        }
                        else if(email.plainTextBody.containsIgnoreCase(UtilConstants.REWORK1)){
                            listRequestReview[0].approval_request_status__c=UtilConstants.REWORK1;
                            listRequestReview[0].RecordTypeId = recordTypeMap.get(UtilConstants.PRIOR);
                        }
                        else if(email.plainTextBody.containsIgnoreCase(UtilConstants.READYREV)){
                            listRequestReview[0].approval_request_status__c=UtilConstants.READYREV;
                            listRequestReview[0].RecordTypeId = recordTypeMap.get(UtilConstants.PRIOR);
                        }
                        else if(email.plainTextBody.containsIgnoreCase(UtilConstants.APPRVD)){
                            listRequestReview[0].approval_request_status__c=UtilConstants.APPRVD;
                            listRequestReview[0].RecordTypeId = recordTypeMap.get(UtilConstants.APPRVD);
                        }else{}
                        listRequestReview[0].response_received_date__c=date.Today();
                         if(!approvalComments.equalsignorecase(UtilConstants.COMMENT)){
                            listRequestReview[0].comments_by_approver__c=approvalComments;
                         }
                         
                         try{
                            database.update(listRequestReview,true);
                         }
                         catch(Exception e){
                                if(listRequestReview[0].approval_request_status__c.EqualsIgnoreCase(UtilConstants.APPRVD) && 
                                    listRequestReview[0].approval_request_type__c.equalsignorecase(listRequestReview[0].Final_Approval__c) ){
                                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                    mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                                    //List<String> toAddresses = new List<String>();                
                                    //toAddresses.add(email.fromAddress);
                                    List<String> ccAddresses = new List<String>();
                                    if(listRequestReview[0].Requestor__r.Email__c!=null){
                                        //CCAddresses.add(listRequestReview[0].Approver__r.Email__c);
                                        ccAddresses.add(listRequestReview[0].Requestor__r.Email__c);
                                    }
                                    /*for(string st:BPOemillist){
                                        CCAddresses.add(st);
                                    } 
                                    Set<Id> idList = new Set<Id>();
                                    for (Group gr :  [SELECT id,(select userOrGroupId from groupMembers Limit 1) FROM group WHERE name =:
                                                        Label.Solution_Operations_Group LIMIT 500]) { 
                                        for(GroupMember gm:gr.groupmembers){       
                                            idList.add(gm.userOrGroupId);
                                        }
                                    } 
                                    if(!idList.isEmpty()){
                                        for(User u :  [SELECT email FROM user WHERE id IN :idList LIMIT 5000]) {        
                                            CCAddresses.add(u.email);    
                                        }
                                    }*/
                                    //mail.setToAddresses(toAddresses);
                                    mail.setCcAddresses(ccAddresses);
                                    mail.setWhatId(listRequestReview[0].id) ;
                                    mail.setTargetObjectId(Approverid) ;
                                    mail.setTemplateId(ccVal); 
                                    mail.saveAsActivity=false;                       
                                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });       
                                    
                                }
                                ExceptionLog__c exlog =new ExceptionLog__c();
                                exlog.ExceptionDescription__c=e.getMessage().substring(0,100);
                                exlog.ExceptionDetails__c=String.valueof(e);
                                exlog.ExceptionLogTimestamp__c=system.now();
                                exlog.ExceptionType__c=e.getTypeName();
                                exlog.Application__c=UtilConstants.SWB;
                                exlog.MethodName__c=UtilConstantsR3.handleInboundEmail;
                                exlog.ClassName__c=UtilConstantsR3.TechApprovalEmailService;
                                exlog.ContextUser__c=userinfo.getuserid();
                                ExceptionLog.add(exlog);
                         }
                      }
                }
            }
            else{
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        String[] toAddresses = new String[]{};         
                        toAddresses.add(email.fromAddress);
                        mail.setToAddresses(toAddresses);
                        mail.setSubject(UtilConstants.MSG2);
                        String htmlEmailBody=UtilConstants.STR2+ subject
                        +UtilConstants.STR22;                                
                        mail.setHtmlBody(htmlEmailBody);
                        mail.saveAsActivity=false;
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            }
            
        }
        else if(email.plainTextBody.containsIgnoreCase(UtilConstants.CMP) || email.plainTextBody.containsIgnoreCase(UtilConstants.ONHOLD1) ||email.plainTextBody.containsIgnoreCase(UtilConstants.NXTSTAGE)
                 || email.plainTextBody.containsIgnoreCase(UtilConstants.NSTARTED) ||  email.plainTextBody.containsIgnoreCase(UtilConstants.NSTARTED)){
                List<Tech_Action_Items__c> actionitems=[Select id,action_item_status__c, comments__c, Primary_Owner__c from Tech_Action_Items__c where id=:reviewId limit 1];
                if(actionitems.size()==1){
                    String actionComments = email.plainTextBody.substringBetween(UtilConstants.ASTRIC);
                    if(email.plainTextBody.containsIgnoreCase(UtilConstants.CMP))
                    {
                        actionitems[0].action_item_status__c=UtilConstants.CMPL;
                    }                           
                    else if(email.plainTextBody.containsIgnoreCase(UtilConstants.ONHOLD1))
                    {
                        actionitems[0].action_item_status__c=UtilConstants.ONHLD2;
                    }
                    else if(email.plainTextBody.containsIgnoreCase(UtilConstants.NXTSTAGE))
                    {
                        actionitems[0].action_item_status__c=UtilConstants.NXTSTG2;
                    }
                    else if(email.plainTextBody.containsIgnoreCase(UtilConstants.NSTARTED))
                    {
                        actionitems[0].action_item_status__c=UtilConstants.NSTARTED2;
                    }
                    else if(email.plainTextBody.containsIgnoreCase(UtilConstants.INPROG ))
                    {
                        actionitems[0].action_item_status__c=UtilConstants.INPROG2;
                    }
                    else {
                    
                    }
    
                    actionitems[0].comments__c=actionComments;
                    database.update(actionitems,false);
                }
         }else{}
        return result;
    }
    
    /**
     * @description       Handles the action when a approver responses vai mail
     * @param             Messaging.InboundEmail email, Messaging.InboundEnvelope envelope
     * @return            Messaging.InboundEmailResult
     * @throws            DML Exception
     */  
    private static void checkUnauthorizedAccess(Messaging.InboundEmail email, List<Tech_Approval_Request__c> listRequestReview){
                         
        id emailtempid = [select id from emailtemplate where developername=:UtilConstantsR3.Tech_Unauthorized_Approver limit 1].id;          
        string CvalUnAuthorized=emailtempid;    
        list<string> BPOemillist=new list<string>();
        for(Opportunity_Teams__c Optm:[select Opportunity_Team_Member__r.email__c,Role__r.Name from Opportunity_Teams__c where 
            Role__r.Name =:UtilCOnstants.OPP_SOL_LEAD AND Opportunity__c =:listRequestReview[0].approval_stage__r.Opportunity__c LIMIT 5000]){
            BPOemillist.add(Optm.Opportunity_Team_Member__r.email__c);
        }
        String orgWideEmailAddressID=UtilEmail.emailid();
        String Approverid=listRequestReview[0].approver__r.user__c;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
        List<String> toAddresses = new List<String>();                
        toAddresses.add(email.fromAddress);
        List<String> ccAddresses = new List<String>();
        if(listRequestReview[0].Requestor__r.Email__c!=null){
            ccAddresses.add(listRequestReview[0].Approver__r.Email__c);
            ccAddresses.add(listRequestReview[0].Requestor__r.Email__c);
        }
        for(string st:BPOemillist){
            ccAddresses.add(st);
        } 
        Set<Id> idList = new Set<Id>();
        for (Group gr :  [SELECT id,(select userOrGroupId from groupMembers Limit 1) FROM group WHERE name =:
                            Label.Solution_Operations_Group LIMIT 500]) { 
            for(GroupMember gm:gr.groupmembers){       
                idList.add(gm.userOrGroupId);
            }
        } 
        if(!idList.isEmpty()){
            for(User u :  [SELECT email FROM user WHERE id IN :idList LIMIT 5000]) {        
                ccAddresses.add(u.email);    
            }
        }
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        mail.setWhatId(listRequestReview[0].id) ;
        mail.setTargetObjectId(Approverid) ;
        mail.setTemplateId(CvalUnAuthorized); 
        mail.saveAsActivity=false;                       
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
    }
}