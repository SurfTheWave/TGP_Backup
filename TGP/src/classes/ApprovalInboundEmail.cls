/******************************
   @Author       : 
   @Class name   : ApprovalInboundEmail 
   @CreateDate   : 
   @Description : Email services are automated processes that use Apex classes
                   * to process the contents, headers, and attachments of inbound emails.
   @Version : 1.0 
*******************************/
global with sharing class ApprovalInboundEmail implements Messaging.InboundEmailHandler {
    
     private static final string CLASS_NAME = UtilConstants.APPROVE_AGENDA;
     private static final string METHOD_NAME = UtilConstants.HANDLE_INBOUND;                     
     public string subject;
     /******************************
     * Method Name: handleInboundEmail
     * Description: test data setup for Operation on Mobilization report trigger functionality testing
     * Paramenters: Messaging.InboundEmail email, Messaging.InboundEnvelope envelope
     * Return Value: 
     *******************************/ 
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        subject = email.subject;
        Boolean pendingcheck = false;
        Boolean opscheck = false;
        //Boolean ApprStagecheck = false;        
        String reviewId = email.plaintextBody.substringBetween(UtilConstants.HASH); 
        //system.debug('reviewid----------------------------------'+reviewId.trim());
        reviewId=reviewId.replace(UtilConstants.QTS,UtilConstants.EMPTY_STRING);
        Email_Template__c myCS1 = Email_Template__c.getValues(UtilConstantsforSWB.ApprReqCannotBeApproved);
                String Template=myCS1.ID__c;
        Email_Template__c myCS2 = Email_Template__c.getValues(UtilConstantsforSWB.Opscannotbeapproved);
              String TemplateOps=myCS2.ID__c;
        Email_Template__c myCS3 = Email_Template__c.getValues(UtilConstantsforSWB.StageApproved);                
               String TemplateStage=myCS3.ID__c;        
          String queryString = UtilCOnstants.SOQL_STRING;
          if(email.plainTextBody.containsIgnoreCase(UtilConstants.APPR)||
              email.plainTextBody.containsIgnoreCase(UtilConstants.REJECT)||
              email.plainTextBody.containsIgnoreCase(UtilConstants.READY_FOR_REVIEW) || 
              email.plainTextBody.containsIgnoreCase(UtilConstants.REWORK)){       
        List<Approval_Request__c> listRequestReview=[Select id,approval_stage__r.Id,comments_by_approver__c,approval_stage__r.of_Approval_Request_IC_IO1__c,approval_stage__r.of_Approval_Request_BPO_IC_IO1__c,approval_stage__r.approval_stage_type__c,approval_stage__r.of_Approval_Request_BPO_IC__c,approval_stage__r.opportunity__r.IO_Opportunity__c,approval_stage__r.opportunity__r.IC_Opportunity__c,approval_stage__r.of_approval_request__c,approval_stage__r.of_Approval_Request_IC_IO2__c,approval_stage__r.of_Approval_Request_IC__c,approval_stage__r.of_Approval_Request_IO__c,approval_stage__r.opportunity__r.Service_Grp__c, Approver__c, Approver__r.Email__c,approval_stage__r.Opportunity__r.Name, approval_request_status__c,response_received_date__c,Requestor__r.Email__c,approval_stage__r.approval_stage_status__c,approval_request_type__c,Service_Group__c,RecordTypeId,approval_stage__r.opportunity__r.BPO_Opportunity__c from approval_request__c where id=:reviewId limit 1000];  
         try{
            //system.debug('***********Review IC Test Start *********');
             map<string,Id> recordTypeMap = new map<string,Id>();
     
       for(RecordType r:[Select Id, Name From RecordType Where sObjectType = :UtilConstants.APPR_REQ and isActive = true LIMIT 5000 ]){
           recordTypeMap.put(r.Name, r.Id);
       }
           if(listRequestReview.size()==1)
            {
             if(listRequestReview[0].approval_request_status__c!=UtilConstants.PEND_WITH_REQSTR){
              //system.debug('Request Type'+listRequestReview[0].approval_request_type__c);
             //system.debug('service Groooop'+listRequestReview[0].approval_stage__r.opportunity__r.Service_Grp__c);
             //system.debug('BPO OPppppppppp'+listRequestReview[0].approval_stage__r.opportunity__r.BPO_Opportunity__c);
             //system.debug('IO Opppp'+listRequestReview[0].approval_stage__r.opportunity__r.IO_Opportunity__c );
             //system.debug('BPO RollUpppppppppppp'+listRequestReview[0].approval_stage__r.of_Approval_Request_BPO_IC__c);
             //system.debug('IO Roll Uppppppppp'+listRequestReview[0].approval_stage__r.of_Approval_Request_IC_IO1__c);
             // By Anamika and Diwanshu
                 if((listRequestReview[0].approval_stage__r.of_approval_request__c > 0 && listRequestReview[0].approval_stage__r.opportunity__r.Service_Grp__c.EqualsIgnoreCase(UtilConstants.BPO) && listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRBPO)) || (listRequestReview[0].approval_stage__r.of_Approval_Request_IO__c > 0 && listRequestReview[0].approval_stage__r.opportunity__r.Service_Grp__c.EqualsIgnoreCase(UtilConstants.IO) && listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRIO)) || (listRequestReview[0].approval_stage__r.of_Approval_Request_IC__c > 0 && listRequestReview[0].approval_stage__r.opportunity__r.Service_Grp__c.EqualsIgnoreCase(UtilConstants.IC) && listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRIC)))             
               {
                system.debug('Inside BPO or IO or IC +++++++');
               pendingcheck = true;
               }
             /*  else if(listRequestReview[0].approval_stage__r.of_Approval_Request_IO__c > 0 && listRequestReview[0].approval_stage__r.opportunity__r.Service_Grp__c =='IO' && listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRIO))
               {
               system.debug('Inside IO +++++++');
               pendingcheck = true;
               }
               else if(listRequestReview[0].approval_stage__r.of_Approval_Request_IC__c > 0 && listRequestReview[0].approval_stage__r.opportunity__r.Service_Grp__c =='IC' && listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRIC))
               {
               system.debug('Inside IC +++++++');Bndl
               pendingcheck = true;
               }*/
               else if(listRequestReview[0].approval_stage__r.opportunity__r.Service_Grp__c.EqualsIgnoreCase(UtilConstants.Bndl) && listRequestReview[0].approval_stage__r.opportunity__r.BPO_Opportunity__c == UtilConstants.BOOLEAN_TRUE && listRequestReview[0].approval_stage__r.opportunity__r.IC_Opportunity__c == UtilConstants.BOOLEAN_TRUE && listRequestReview[0].approval_stage__r.opportunity__r.IO_Opportunity__c == UtilConstants.BOOLEAN_FALSE && ((listRequestReview[0].approval_stage__r.of_Approval_Request_IC__c > 0 && listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRIC)) || (listRequestReview[0].approval_stage__r.of_approval_request__c > 0 && listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRBPO))))
               {
               //system.debug('Inside BPO IC +++++++');
               pendingcheck = true;
               }
               else if(listRequestReview[0].approval_stage__r.opportunity__r.Service_Grp__c.EqualsIgnoreCase(UtilConstants.Bndl) && listRequestReview[0].approval_stage__r.opportunity__r.BPO_Opportunity__c == UtilConstants.BOOLEAN_TRUE && listRequestReview[0].approval_stage__r.opportunity__r.IO_Opportunity__c == UtilConstants.BOOLEAN_TRUE && listRequestReview[0].approval_stage__r.opportunity__r.IC_Opportunity__c == UtilConstants.BOOLEAN_FALSE && ((listRequestReview[0].approval_stage__r.of_Approval_Request_IO__c > 0 && listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRIO)) || (listRequestReview[0].approval_stage__r.of_approval_request__c > 0 && listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRBPO))))
               {
               //system.debug('Inside BPO IO +++++++');
               pendingcheck = true;
               }
               else if(listRequestReview[0].approval_stage__r.opportunity__r.Service_Grp__c.EqualsIgnoreCase(UtilConstants.Bndl) && listRequestReview[0].approval_stage__r.opportunity__r.IO_Opportunity__c == UtilConstants.BOOLEAN_TRUE && listRequestReview[0].approval_stage__r.opportunity__r.IC_Opportunity__c == UtilConstants.BOOLEAN_TRUE && listRequestReview[0].approval_stage__r.opportunity__r.BPO_Opportunity__c == UtilConstants.BOOLEAN_FALSE && ((listRequestReview[0].approval_stage__r.of_Approval_Request_IO__c > 0 && listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRIO)) || (listRequestReview[0].approval_stage__r.of_Approval_Request_IC__c > 0 && listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRIC))))
               {
               //system.debug('Inside IO IC +++++++');
               pendingcheck = true;
               }
               else if(listRequestReview[0].approval_stage__r.opportunity__r.Service_Grp__c.EqualsIgnoreCase(UtilConstants.Bndl) && listRequestReview[0].approval_stage__r.opportunity__r.BPO_Opportunity__c == UtilConstants.BOOLEAN_TRUE && listRequestReview[0].approval_stage__r.opportunity__r.IO_Opportunity__c == UtilConstants.BOOLEAN_TRUE && listRequestReview[0].approval_stage__r.opportunity__r.IC_Opportunity__c == UtilConstants.BOOLEAN_TRUE && ((listRequestReview[0].approval_stage__r.of_Approval_Request_IO__c > 0 && listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRIO)) || (listRequestReview[0].approval_stage__r.of_approval_request__c > 0 && listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRBPO)) || (listRequestReview[0].approval_stage__r.of_Approval_Request_IC__c > 0 && listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRIC))))
               {
               //system.debug('Inside BPO IO IC +++++++');
               pendingcheck = true;
               }
               else if(listRequestReview[0].approval_request_type__c=='Operations Approval' && listRequestReview[0].approval_stage__r.opportunity__r.Service_Grp__c.EqualsIgnoreCase(UtilConstants.Bndl) && listRequestReview[0].approval_stage__r.opportunity__r.BPO_Opportunity__c == UtilConstants.BOOLEAN_TRUE && listRequestReview[0].approval_stage__r.opportunity__r.IO_Opportunity__c == UtilConstants.BOOLEAN_TRUE && (listRequestReview[0].approval_stage__r.of_Approval_Request_BPO_IC__c==0 || listRequestReview[0].approval_stage__r.of_Approval_Request_IC_IO1__c==0))
               {
               //system.debug('Inside operational +++++++');
               opscheck = true;
               }
               
              /*else if (listRequestReview[0].approval_stage__r.approval_stage_status__c =='Approved')               
                {                 
                 //system.debug('Inside Stage Approved');                 
                 ApprStagecheck = true;               
                }/*             
                /*  String OSL=UtilConstants.BLANK_SPACE;
               String SAIO=UtilConstants.BLANK_SPACE;
               String SAIC=UtilConstants.BLANK_SPACE;
            
               OSL=listRequestReview[0].approval_stage__r.opportunity__r.Opportunity_Solution_Lead__c;
               SAIO=listRequestReview[0].approval_stage__r.opportunity__r.IO_Solution_Architect__c;
               SAIC=listRequestReview[0].approval_stage__r.opportunity__r.IC_Solution_Architect__c; */
               
               // By Anamika and Diwanshu
                 if (pendingcheck==UtilConstants.BOOLEAN_TRUE)
                 {                                  
                 //system.debug('Inside PendingCheck +++++++'+pendingcheck);
                 
                 String orgWideEmailAddressID=UtilEmail.emailid();
                 String Approverid=UtilUser.UtilUser(listRequestReview[0].approver__c);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        String[] toAddresses = new String[]{};         
                        toAddresses.add(email.fromAddress);
                        //system.debug('++++'+toAddresses);
                       List<String> CCAddresses = new List<String>();
                        if(listRequestReview[0].Requestor__r.Email__c!=null){                      
                        CCAddresses.add(listRequestReview[0].Requestor__r.Email__c);
                        }  
                        
                    
               /*    if (listRequestReview[0].Service_Group__c == 'BPO')
                    {
                    
                    List<User_MAster__c> userOSL = [SELECT Id, email__c FROM User_Master__c where 
                                          id =:OSL];
                   if(!userOSL.isEmpty()){
                                         CCAddresses.add(userOSL[0].email__c);
                                         
                  }
                  }
                  if (listRequestReview[0].Service_Group__c == 'IO')
                  {
                    List<User_MAster__c> userSAIO = [SELECT Id, email__c FROM User_Master__c where 
                                          id =:SAIO];
                                           if(!userSAIO.isEmpty()){
                CCAddresses.add(userSAIO[0].email__c);
                }
                  }
                   if (listRequestReview[0].Service_Group__c == 'IC')
                   {
                    List<User_MAster__c> userSAIC = [SELECT Id, email__c FROM User_Master__c where 
                                          id =:SAIC];
                                          if(!userSAIC.isEmpty()){
                CCAddresses.add(userSAIC[0].email__c);
                }
                   }*/
                        mail.setCCAddresses(CCAddresses);                     
                        mail.setToAddresses(toAddresses);
                       // mail.setCCAddresses(CCAddresses);
                        //system.debug('REQUESTOR +++++++++++++' +listRequestReview[0].Requestor__r.Email__c);
                       // mail.setSubject(UtilConstants.MSG1);
                      //  String htmlEmailBody  ='You cannot create or approve the request unless all other pending requests approved';                                
                        //mail.setHtmlBody(htmlEmailBody);
                        mail.setTargetObjectId(Approverid) ;
                        mail.setWhatId(listRequestReview[0].id) ;
                        mail.setTemplateId(Template);
                        mail.saveAsActivity=false;
                     
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                 }
                 if (opscheck==UtilConstants.BOOLEAN_TRUE)
                 {                                  
                 //system.debug('Inside opscheck +++++++'+opscheck);
                 
                 String orgWideEmailAddressID=UtilEmail.emailid();
                 String Approverid=UtilUser.UtilUser(listRequestReview[0].approver__c);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        String[] toAddresses = new String[]{};         
                        toAddresses.add(email.fromAddress);
                        //system.debug('++++'+toAddresses);
                       List<String> CCAddresses = new List<String>();
                        if(listRequestReview[0].Requestor__r.Email__c!=null){                      
                        CCAddresses.add(listRequestReview[0].Requestor__r.Email__c);
                        }  
                        
                    
                 /*  if (listRequestReview[0].Service_Group__c == 'BPO')
                    {
                    
                    List<User_MAster__c> userOSL = [SELECT Id, email__c FROM User_Master__c where 
                                          id =:OSL];
                   if(!userOSL.isEmpty()){
                                         CCAddresses.add(userOSL[0].email__c);
                                         
                  }
                  }
                  if (listRequestReview[0].Service_Group__c == 'IO')
                  {
                    List<User_MAster__c> userSAIO = [SELECT Id, email__c FROM User_Master__c where 
                                          id =:SAIO];
                                           if(!userSAIO.isEmpty()){
                CCAddresses.add(userSAIO[0].email__c);
                }
                  }
                   if (listRequestReview[0].Service_Group__c == 'IC')
                   {
                    List<User_MAster__c> userSAIC = [SELECT Id, email__c FROM User_Master__c where 
                                          id =:SAIC];
                                          if(!userSAIC.isEmpty()){
                CCAddresses.add(userSAIC[0].email__c);
                }
                   }*/
                        mail.setCCAddresses(CCAddresses);                     
                        mail.setToAddresses(toAddresses);
                       // system.debug('REQUESTOR +++++++++++++' +listRequestReview[0].Requestor__r.Email__c);
                        mail.setTargetObjectId(Approverid) ;
                        mail.setWhatId(listRequestReview[0].id) ;
                        mail.setTemplateId(TemplateOps);
                        mail.saveAsActivity=false;
                     
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                 }
                    /* if (ApprStagecheck==UtilConstants.BOOLEAN_TRUE)
                 {                                  
                 //system.debug('Inside PendingCheck +++++++'+pendingcheck);
                 
                 String orgWideEmailAddressID=UtilEmail.emailid();
                 String Approverid=UtilUser.UtilUser(listRequestReview[0].approver__c);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        String[] toAddresses = new String[]{};         
                        toAddresses.add(email.fromAddress);
                        //system.debug('++++'+toAddresses);
                       List<String> CCAddresses = new List<String>();
                        if(listRequestReview[0].Requestor__r.Email__c!=null){                      
                        CCAddresses.add(listRequestReview[0].Requestor__r.Email__c);
                        }  
                        
                    
                 /*  if (listRequestReview[0].Service_Group__c == 'BPO')
                    {
                    
                    List<User_MAster__c> userOSL = [SELECT Id, email__c FROM User_Master__c where 
                                          id =:OSL];
                   if(!userOSL.isEmpty()){
                                         CCAddresses.add(userOSL[0].email__c);
                                         
                  }
                  }
                  if (listRequestReview[0].Service_Group__c == 'IO')
                  {
                    List<User_MAster__c> userSAIO = [SELECT Id, email__c FROM User_Master__c where 
                                          id =:SAIO];
                                           if(!userSAIO.isEmpty()){
                CCAddresses.add(userSAIO[0].email__c);
                }
                  }
                   if (listRequestReview[0].Service_Group__c == 'IC')
                   {
                    List<User_MAster__c> userSAIC = [SELECT Id, email__c FROM User_Master__c where 
                                          id =:SAIC];
                                          if(!userSAIC.isEmpty()){
                CCAddresses.add(userSAIC[0].email__c);
                }
                   }*/
                      /*  mail.setCCAddresses(CCAddresses);                     
                        mail.setToAddresses(toAddresses);
                       // mail.setCCAddresses(CCAddresses);
                       // system.debug('REQUESTOR +++++++++++++' +listRequestReview[0].Requestor__r.Email__c);
                       // mail.setSubject(UtilConstants.MSG1);
                      //  String htmlEmailBody  ='You cannot create or approve the request unless all other pending requests approved';                                
                        //mail.setHtmlBody(htmlEmailBody);
                        mail.setTargetObjectId(Approverid) ;
                        mail.setWhatId(listRequestReview[0].id) ;
                        mail.setTemplateId(TemplateStage);
                        mail.saveAsActivity=false;
                     
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                 }*/
                                
                 //by Anamika and Diwanshu 
               
                      String fromAddress = email.fromAddress;
                      String responseShould = listRequestReview[0].Approver__r.Email__c;
                      //system.debug('response from'+fromAddress);
                      //system.debug('response should'+fromAddress);
                      String approvalComments = email.plainTextBody.substringBetween(UtilConstants.ASTRIC);                                             
                     
                      if(!fromAddress.equalsIgnoreCase(responseShould)){
                      //system.debug('not authorized');
                        checkUnauthorizedAccess(email, listRequestReview);
                       }
                       else{
                        if(email.plainTextBody.containsIgnoreCase(UtilConstants.APPR))
                        {
                          system.debug('********Approved starts *********');
                               
                                
                                
                                      
                                /*  listRequestReview[0].approval_request_status__c=UtilConstants.APPRVD;
                                   listRequestReview[0].response_received_date__c=date.Today();
                                   if(listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPR) || 
                                           listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.DSAPPR) ){
                                   listRequestReview[0].approval_stage__r.approval_stage_status__c=UtilConstants.APPRVD;}
                                  
                                   //system.debug('********Approved ends *********'+listRequestReview[0].approval_stage__r.of_Approval_Request_IO__c==0);    
                                   
                                   */
                                   
                                  // changed for new approval requirement by anamika and diwanshu
                                   listRequestReview[0].approval_request_status__c=UtilConstants.APPRVD;
                                   system.debug('********Approved starts *********'+listRequestReview[0].approval_request_status__c);
                                   listRequestReview[0].response_received_date__c=date.Today();
                                   if(listRequestReview[0].approval_request_status__c.EqualsIgnoreCase(UtilConstants.APPRVD) && listRequestReview[0].approval_stage__r.approval_stage_type__c!=UtilConstants.FLY_BY_SOL_REVIEW)
                                     {
                                     //system.debug('I am in');
                                           //BPO
                                           if(listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRBPO) && listRequestReview[0].approval_stage__r.of_approval_request__c ==0 && listRequestReview[0].approval_stage__r.opportunity__r.Service_Grp__c.EqualsIgnoreCase(UtilConstants.BPO) && listRequestReview[0].Service_Group__c.EqualsIgnoreCase(UtilConstants.BPO)){
                                           
                                           listRequestReview[0].approval_stage__r.approval_stage_status__c=UtilConstants.APPRVD;
                                           //system.debug('********Approved ends *********'+listRequestReview[0].approval_stage__r.approval_stage_status__c); 
                                           }
                                   
                                           //IO
                                          if(listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRIO) && listRequestReview[0].approval_stage__r.of_Approval_Request_IO__c==0 && listRequestReview[0].approval_stage__r.opportunity__r.Service_Grp__c.EqualsIgnoreCase(UtilConstants.IO) && listRequestReview[0].Service_Group__c.EqualsIgnoreCase(UtilConstants.IO))
                                           {
                                            
                                            listRequestReview[0].approval_stage__r.approval_stage_status__c=UtilConstants.APPRVD;
                                           // system.debug('********Approved ends *********'+listRequestReview[0].approval_stage__r.approval_stage_status__c); 
                                   
                                            //IC
                                           }
                                          if(listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRIC) && listRequestReview[0].approval_stage__r.of_Approval_Request_IC__c==0 && listRequestReview[0].approval_stage__r.opportunity__r.Service_Grp__c.EqualsIgnoreCase(UtilConstants.IC) && listRequestReview[0].Service_Group__c.EqualsIgnoreCase(UtilConstants.IC))
                                           {
                                           
                                           listRequestReview[0].approval_stage__r.approval_stage_status__c=UtilConstants.APPRVD;
                                           //system.debug('********Approved ends *********'+listRequestReview[0].approval_stage__r.approval_stage_status__c); 
                                           }
                                           //IO IC combo
                                          if(listRequestReview[0].approval_stage__r.opportunity__r.IC_Opportunity__c==UtilConstants.BOOLEAN_TRUE && listRequestReview[0].approval_stage__r.opportunity__r.IO_Opportunity__c==UtilConstants.BOOLEAN_TRUE && listRequestReview[0].approval_stage__r.opportunity__r.BPO_Opportunity__c==UtilConstants.BOOLEAN_FALSE )
                                          {
                                          if(listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRIO))
                                           {
                                            listRequestReview[0].approval_stage__r.approval_stage_status__c=UtilConstants.APPRVD;
                                           //system.debug('********Approved ends *********'+listRequestReview[0].approval_stage__r.approval_stage_status__c);
                                           }
                                           
                                          }
                                          //BPO IC combo
                                          if(listRequestReview[0].approval_stage__r.opportunity__r.IC_Opportunity__c==UtilConstants.BOOLEAN_TRUE && listRequestReview[0].approval_stage__r.opportunity__r.IO_Opportunity__c==UtilConstants.BOOLEAN_FALSE && listRequestReview[0].approval_stage__r.opportunity__r.BPO_Opportunity__c==UtilConstants.BOOLEAN_TRUE)
                                          {
                                          if(listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPRBPO))
                                           {
                                            listRequestReview[0].approval_stage__r.approval_stage_status__c=UtilConstants.APPRVD;
                                           //system.debug('********Approved ends *********'+listRequestReview[0].approval_stage__r.approval_stage_status__c);
                                           }
                                           
                                          } 
                                          //BPO IO IC Combo
                                           if(listRequestReview[0].approval_stage__r.opportunity__r.IC_Opportunity__c==UtilConstants.BOOLEAN_TRUE && listRequestReview[0].approval_stage__r.opportunity__r.IO_Opportunity__c==UtilConstants.BOOLEAN_TRUE && listRequestReview[0].approval_stage__r.opportunity__r.BPO_Opportunity__c==UtilConstants.BOOLEAN_TRUE && listRequestReview[0].approval_stage__r.of_Approval_Request_BPO_IC__c >0 && listRequestReview[0].approval_stage__r.of_Approval_Request_IC_IO1__c >0 )
                                          {
                                          if(listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPROPP))
                                           {
                                            listRequestReview[0].approval_stage__r.approval_stage_status__c=UtilConstants.APPRVD;
                                           //system.debug('********Approved ends *********'+listRequestReview[0].approval_stage__r.approval_stage_status__c);
                                           }
                                           
                                          } 
                                          //BPO IO combo
                                           if(listRequestReview[0].approval_stage__r.opportunity__r.IC_Opportunity__c==UtilConstants.BOOLEAN_FALSE && listRequestReview[0].approval_stage__r.opportunity__r.IO_Opportunity__c==UtilConstants.BOOLEAN_TRUE && listRequestReview[0].approval_stage__r.opportunity__r.BPO_Opportunity__c==UtilConstants.BOOLEAN_TRUE && listRequestReview[0].approval_stage__r.of_Approval_Request_BPO_IC__c >0 && listRequestReview[0].approval_stage__r.of_Approval_Request_IC_IO1__c >0)
                                          {
                                          if(listRequestReview[0].approval_request_type__c.EqualsIgnoreCase(UtilConstants.FIN_APPROPP))
                                          {
                                          listRequestReview[0].approval_stage__r.approval_stage_status__c=UtilConstants.APPRVD;
                                          //system.debug('********Approved ends *********'+listRequestReview[0].approval_stage__r.approval_stage_status__c);
                                          }
                                          }
                                          // changed for new approval requirement by anamika and diwanshu 
                                    }
                                   
                                          
                               
                                }
                                   
                                                                                                                               
                                                          
                          else if(email.plainTextBody.containsIgnoreCase(UtilConstants.REJECT))
                                {
                                   //system.debug('********Rejected starts *********'); 
                                   listRequestReview[0].approval_request_status__c=UtilConstants.REJ;
                                   listRequestReview[0].response_received_date__c=date.Today();
                                   //system.debug('********Rejected ends *********'); 
                                }
                                
                         else if(email.plainTextBody.containsIgnoreCase(UtilConstants.REWORK))
                                {
                                   //system.debug('********Rework Starts *********'); 
                                   listRequestReview[0].approval_request_status__c=UtilConstants.REWORK1;
                                   listRequestReview[0].response_received_date__c=date.Today();
                                   //system.debug('********Rework ends *********'); 
                                }
                                
                         else if(email.plainTextBody.containsIgnoreCase(UtilConstants.READY_FOR_REVIEW))
                                {
                                    //system.debug('********Ready for review Starts *********'); 
                                    listRequestReview[0].approval_request_status__c=UtilConstants.READYREV;
                                    listRequestReview[0].response_received_date__c=date.Today();
                                   //system.debug('********Ready for review ends *********'); 
                                }
                                
                                
                                 //system.debug('===========Comments Started==========');
                         if(approvalComments != UtilConstants.COMMENT){                 
                                                listRequestReview[0].comments_by_approver__c=approvalComments;  
                           }        
                        //system.debug('===========Comments Ended==========');
                        
                      if (listRequestReview[0].Service_Group__c.equals(UtilConstants.BPO))
                                       { 
                                           //system.debug('Prior/Post Approval'+recordTypeMap.get('Prior/Post Approval'));
                                           //system.debug('Prior/Post Approval'+listRequestReview[0].approval_request_status__c);           
                                          if(listRequestReview[0].approval_request_status__c.equals(UtilConstants.APPRVD)){
                                             //system.debug('Approved'+recordTypeMap.get('Approved'));
                                             listRequestReview[0].RecordTypeId = recordTypeMap.get(UtilConstants.APPRVD);
                                               }
                                           else{
                                             listRequestReview[0].RecordTypeId = recordTypeMap.get(UtilConstants.PRIOR);
                                             //system.debug('Prior/Post Approval'+recordTypeMap.get(UtilConstants.PRIOR));
                                               }
                                       }
                      else if (listRequestReview[0].Service_Group__c.equals(UtilConstants.IO))
                                       {           
                                           if(listRequestReview[0].approval_request_status__c.equals(UtilConstants.APPRVD)){
                                               //system.debug('IO Approved'+recordTypeMap.get('IO Approved'));
                                               listRequestReview[0].RecordTypeId = recordTypeMap.get(UtilConstants.IOAPPR);
                                               }
                                           else{
                                               listRequestReview[0].RecordTypeId = recordTypeMap.get(UtilConstants.IOPRIOR);
                                               //system.debug('IO Prior/Post Approval'+recordTypeMap.get(UtilConstants.IOPRIOR));
                                               }
                                       }
                        else{ 
                                if(listRequestReview[0].Service_Group__c==UtilConstants.IC)
                                       {          
                                           if(listRequestReview[0].approval_request_status__c.equals(UtilConstants.APPRVD)){
                                               //system.debug('IC Approved'+recordTypeMap.get(UtilConstants.ICAPPR));
                                               listRequestReview[0].RecordTypeId = recordTypeMap.get(UtilConstants.ICAPPR);
                                               }
                                           else{
                                               listRequestReview[0].RecordTypeId = recordTypeMap.get(UtilConstants.ICPRIOR);
                                               //system.debug('IC Prior/Post Approval'+recordTypeMap.get(UtilConstants.ICPRIOR));        
                                               }
                                       }
                            }
                                       
                   //system.debug( '**************' + listRequestReview[0]  );
                   //update(listRequestReview[0]); 
                              
                        //system.debug('********Updating DB *********'); 
                        database.update(listRequestReview,false);
                       //system.debug('********Updating DB *********'+listRequestReview[0] ); 

                        update listRequestReview[0].approval_stage__r;
                        
                        //system.debug('approval request status'+listRequestReview[0].approval_request_status__c);
                        if(!listRequestReview[0].approval_request_status__c.equalsIgnoreCase(UtilConstants.PEND_WITH_APPR2)|| 
                        !listRequestReview[0].approval_request_status__c.equalsIgnoreCase(UtilConstants.PEND_WITH_REQSTR2) ){
                        /*String orgWideEmailAddressID=UtilEmail.emailid();
                        String Approverid=UtilUser.UtilUser(listRequestReview[0].approver__c);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        List<String> toAddresses = new List<String>();
                        //system.debug('++++'+ email.fromAddress);
                        //system.debug('++++'+ listRequestReview[0].Requestor__r.Email__c);                    
                        toAddresses.add(email.fromAddress);
                        //system.debug('++++'+toAddresses);
                        //mail.setToAddresses(toAddresses);
                        mail.setWhatId(listRequestReview[0].id) ;
                        mail.setTargetObjectId(Approverid) ;
                        //mail.setTemplateId('00Xc0000000MZwJ'); 
                        mail.setTemplateId('CvalApproved'); 
                        mail.saveAsActivity=false;                       
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });     */       
                       }   
                       else{
                        String orgWideEmailAddressID=UtilEmail.emailid();
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        String[] toAddresses = new String[]{};         
                        toAddresses.add(email.fromAddress);
                        //system.debug('++++'+toAddresses);
                        mail.setToAddresses(toAddresses);
                        mail.setSubject(UtilConstants.MSG1);
                        String htmlEmailBody  =UtilConstants.STR1+ subject
                                                        +UtilConstants.STR11;                                
                        mail.setHtmlBody(htmlEmailBody);
                        mail.saveAsActivity=false;
                     
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                       }
                            
                 }
                                    
                 
                 
                 
                 
                 
                 
                   /* set<id> BPOteammbers=new set<id>(); 
        list<string> BPOemillist=new list<string>();
        for(Opportunity_Teams__c Optm:[select Opportunity_Team_Member__c,Role__r.Name from Opportunity_Teams__c where Role__r.Name =:UtilCOnstants.OPP_SOL_LEAD AND Opportunity__r.Name =:listRequestReview[0].approval_stage__r.Opportunity__r.Name LIMIT 5000]){
                    BPOteammbers.add(Optm.Opportunity_Team_Member__c);
                 }
        if(!BPOteammbers.isEmpty()){
                 for(User_Master__c urlist:[select User__r.Email from User_Master__c where id IN:BPOteammbers LIMIT 5000]){
                   BPOemillist.add(urlist.User__r.Email);
                   }
                    }
        
                       String orgWideEmailAddressID=UtilEmail.emailid();
                        String Approverid=UtilUser.UtilUser(listRequestReview[0].approver__c);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        List<String> toAddresses = new List<String>();
                        //system.debug('++++'+ email.fromAddress);
                        //system.debug('++++'+ listRequestReview[0].Requestor__r.Email__c);                    
                        toAddresses.add(email.fromAddress);
                        //system.debug('++++'+toAddresses);
                        List<String> CCAddresses = new List<String>();
                       if(listRequestReview[0].Requestor__r.Email__c!=null){
                       // CCAddresses.add(BPOemillist[0].Email__c);
                        CCAddresses.add(listRequestReview[0].Requestor__r.Email__c);
                       
                            
                        
                        }
                        
                        
                          for(string st:BPOemillist){
                                        CCAddresses.add(st);
                            } 
                
                           
              Set<Id> idList = new Set<Id>();
              for (Group gr :  [SELECT id,(select userOrGroupId from groupMembers Limit 1) FROM group WHERE name =:Label.Solution_Operations_Group LIMIT 500]) { 
                for(GroupMember gm:gr.groupmembers){       
                      idList.add(gm.userOrGroupId);
                }
              } 
              if(!idList.isEmpty()){
                 for(User u :  [SELECT email FROM user WHERE id IN :idList LIMIT 5000]) {        
                  CCAddresses.add(u.email);    
                }
              }
                        mail.setToAddresses(toAddresses);
                        mail.setCcAddresses(CCAddresses);
                        mail.setWhatId(Approverid) ;
                        mail.setTargetObjectId(Approverid) ;
                        //mail.setTemplateId('00Xc0000000DtTC'); 
                        mail.setTemplateId('00Xc0000000MaDK'); 
                        mail.saveAsActivity=false;                       
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
              
              
               
                
                 }
                 else{
                 
                       String orgWideEmailAddressID=UtilEmail.emailid();
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        String[] toAddresses = new String[]{};         
                        toAddresses.add(email.fromAddress);
                        //system.debug('++++'+toAddresses);
                        mail.setToAddresses(toAddresses);
                        mail.setSubject(UtilConstants.MSG2);
                        String htmlEmailBody  =UtilConstants.STR2+ subject
                        +UtilConstants.STR22;                                
                        mail.setHtmlBody(htmlEmailBody);
                        mail.saveAsActivity=false;
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                     //io
                    /* orgWideEmailAddressID=UtilEmail.emailidForIOIC('IO');
                     mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    //ic
                    orgWideEmailAddressID=UtilEmail.emailidForIOIC('IC');
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
                 
                 }
                
            }
            
            else{
                        String orgWideEmailAddressID=UtilEmail.emailid();
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        String[] toAddresses = new String[]{};         
                        toAddresses.add(email.fromAddress);
                        //system.debug('++++'+toAddresses);
                        mail.setToAddresses(toAddresses);
                        mail.setSubject(UtilConstants.MSG2);
                        String htmlEmailBody  =UtilConstants.STR2+ subject
                        +UtilConstants.STR22;                                
                        mail.setHtmlBody(htmlEmailBody);
                        mail.saveAsActivity=false;
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
                  /*  //io
                     orgWideEmailAddressID=UtilEmail.emailidForIOIC('IO');
                     mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    //ic
                    orgWideEmailAddressID=UtilEmail.emailidForIOIC('IC');
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
                
            }  
        }
        catch(Exception e){ 
            String str= e.getmessage();
        }
          }
          
          else{
            
            List<Action_Item__c> actionitems=[Select id,action_item_status__c, comments__c, Primary_Owner__c from Action_Item__c where id=:reviewId limit 1];
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

       }
       return result; 
    }
    
   @testvisible
    /***************
     * @method :checkUnauthorizedAccess
     * @returntype : void
     * @param : Messaging.InboundEmail email, List<approval_request__c> listRequestReview
    ***************/    
    private static void checkUnauthorizedAccess(Messaging.InboundEmail email, List<approval_request__c> listRequestReview)
    {                   
        
     Email_Template__c myCS3 = Email_Template__c.getValues(UtilConstantsforSWB.UnauthorizedMailApproval);                
     String CvalUnAuthorized=myCS3.ID__c;    
       //system.debug('CvalUnAuthorized'+CvalUnAuthorized);
        set<id> BPOteammbers=new set<id>(); 
        list<string> BPOemillist=new list<string>();
        for(Opportunity_Teams__c Optm:[select Opportunity_Team_Member__c,Role__r.Name from Opportunity_Teams__c where Role__r.Name =:UtilCOnstants.OPP_SOL_LEAD AND Opportunity__r.Name =:listRequestReview[0].approval_stage__r.Opportunity__r.Name LIMIT 5000]){
                    BPOteammbers.add(Optm.Opportunity_Team_Member__c);
                 }
        if(!BPOteammbers.isEmpty()){
                 for(User_Master__c urlist:[select User__r.Email from User_Master__c where id IN:BPOteammbers LIMIT 5000]){
                   BPOemillist.add(urlist.User__r.Email);
                   }
                    }
        
                       String orgWideEmailAddressID=UtilEmail.emailid();
                        String Approverid=UtilUser.UtilUser(listRequestReview[0].approver__c);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        List<String> toAddresses = new List<String>();
                        //system.debug('++++'+ email.fromAddress);
                        //system.debug('++++'+ listRequestReview[0].Requestor__r.Email__c);                    
                        toAddresses.add(email.fromAddress);
                        //system.debug('++++'+toAddresses);
                        List<String> CCAddresses = new List<String>();
                       if(listRequestReview[0].Requestor__r.Email__c!=null){
                        CCAddresses.add(listRequestReview[0].Approver__r.Email__c);
                        CCAddresses.add(listRequestReview[0].Requestor__r.Email__c);
                       
                            
                        
                        }
                        
                        
                          for(string st:BPOemillist){
                                        CCAddresses.add(st);
                            } 
                
                           
              Set<Id> idList = new Set<Id>();
              for (Group gr :  [SELECT id,(select userOrGroupId from groupMembers Limit 1) FROM group WHERE name =:Label.Solution_Operations_Group LIMIT 500]) { 
                for(GroupMember gm:gr.groupmembers){       
                      idList.add(gm.userOrGroupId);
                }
              } 
              if(!idList.isEmpty()){
                 for(User u :  [SELECT email FROM user WHERE id IN :idList LIMIT 5000]) {        
                  CCAddresses.add(u.email);    
                }
              }
                        mail.setToAddresses(toAddresses);
                        mail.setCcAddresses(CCAddresses);
                        mail.setWhatId(listRequestReview[0].id) ;
                        mail.setTargetObjectId(Approverid) ;
                        //mail.setTemplateId('00Xc0000000DtTC'); 
                        mail.setTemplateId(CvalUnAuthorized); 
                        mail.saveAsActivity=false;                       
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        //io
                     /*orgWideEmailAddressID=UtilEmail.emailidForIOIC('IO');
                     mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    //ic
                    orgWideEmailAddressID=UtilEmail.emailidForIOIC('IC');
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
     }  
     
     
     
        }