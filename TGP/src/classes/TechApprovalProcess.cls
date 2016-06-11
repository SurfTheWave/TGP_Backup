/**
   @Author :Apoorva Sharma
   @name   : TechApprovalProcess 
   @CreateDate : 25 November 2015 
   @Description : This class is used for performing submit for approval and send reminder for approval Tech Approval Process.
   @Version : 1.0 
  */
 global with sharing class TechApprovalProcess {
        public String form { get; set; }
        public String approvalrequestid{get;set;}
        public String opportunitydocumentsid{get;set;}
        public list <Tech_Approval_Request__c> approvalrequestresult {get;set;} 
        public List<String> approvalrequestidlist{set;get;}
        public list <Opportunity_Documents__c>opportunityDocuments{get;set;} 
        public List<OpportunityDocumentsWrapper> oppdoumentResultsList {get;set;}
        public List<String> documentidlist =new list<string>();
        public List<String> approvalrequestidstopass =new list<string>();
        public List<OpportunityDocumentsWrapper> selectedDocuments {
        get {
            if (selectedDocuments == null) selectedDocuments = new List<OpportunityDocumentsWrapper>();
            return selectedDocuments;
        }
        set;
     }
        
     /**
     * @description       init method.
     * @param             NA
     * @return            NA
     * @throws            Exception
     */  
        public void init(){
            try{
               String url=ApexPages.currentPage().getUrl();
                String id=ApexPages.currentPage().getParameters().get(UtilConstants.LIST_VALUE);
                String oppid = ApexPages.currentPage().getParameters().get('id');
                approvalrequestidlist = new List<string>();
                approvalrequestidlist=id.split(UtilConstants.COMMA_STRING);
                approvalrequestresult = [SELECT id,approval_request_type__c,approver__c,
                                         approval_stage__r.approval_stage_type__c,Version__c ,approval_stage__c ,approval_request_status__c
                                         FROM Tech_Approval_Request__c where id in :approvalrequestidlist limit 5000];
                for(Tech_Approval_Request__c appRec:approvalrequestresult){
                    approvalrequestidstopass.add(appRec.id);
                }
                opportunityDocuments = [SELECT id, Name,document__c,comments__c,modified_by__c,modified_date__c,Modified_Onn__c,Service_Group__c 
                                        FROM Opportunity_Documents__c where opportunity__c = :oppid and IS_Tech_Document__c= true limit 5000];
                if(!opportunityDocuments.isEmpty()){
                    oppdoumentResultsList =new List<OpportunityDocumentsWrapper>();
                    for(Opportunity_Documents__c oppdocRec :opportunityDocuments){
                        OpportunityDocumentsWrapper ow =new OpportunityDocumentsWrapper(oppdocRec);
                        oppdoumentResultsList.add(ow);  
                        //documentidlist.add(oppdocRec.id);
                    }
                }
            }
            Catch(Exception e)
            {
                String str= e.getmessage();
            } 
       }
       
       public TechApprovalProcess(ApexPages.StandardController controller) {
            init();
        }
        
      public void TechApprovalProcess (){
           try{
          }
        Catch(Exception e){
            String str= e.getmessage();
       }
              
       }
       /**
     * @description       creates approval documents for tech approval document.
     * @param             NA
     * @return            NA
     * @throws            Userdefined Exception
     */  
       webservice static  void createApprovalDocumentsMethod(List<String> documentid, List<String> requestid){
           list<String> reqids=new List<String>();
           for(String s:requestid){
               String[] temp=s.split(UtilConstants.COMMA_STRING);
               reqids.add(temp[0]);
            }
            list<String> documentid1=new List<String>();
            for(String s:documentid){
                String[] temp=s.split(UtilConstants.COMMA_STRING);
                documentid1.add(temp[0]);
            }
            map<Id,Tech_Approval_Request__c> requesltist = new map<Id, Tech_Approval_Request__c>([Select id,Service_Group__c,approval_request_status__c from 
                                                                                              Tech_Approval_Request__c where id IN:reqids limit 5000]);                                                 
            List<Tech_Approval_Documents__c> approvalDocumentList=new List<Tech_Approval_Documents__c>();
            for(Opportunity_Documents__c opp:[Select id from opportunity_documents__c where 
                                                     id IN:documentid1 limit 5000]){
             for(Tech_Approval_Request__c req:requesltist.values()){
                 Tech_Approval_Documents__c appdoc =new Tech_Approval_Documents__c();
                 if((!(UtilConstants.APPROVED_STATUS).equals(req.approval_request_status__c)) &&
                    (!(UtilConstants.PEND_WITH_APPR2).equals(req.approval_request_status__c))){
                        appdoc.Approval_Documents__c=opp.id;
                        appdoc.Opportunity_Tech_Approval_Request__c=req.id;
                        approvalDocumentList.add(appdoc);
                        
                 }
             }
         }
         
         if(!approvalDocumentList.isEmpty()){
             try{
                 //insert approvalDocumentList;
                 List<database.SaveResult> result= database.insert(approvalDocumentList,false);
                 
             }
             catch(Exception e){
                  
             }
         }
         
         approvalDocumentsReq(documentid,requestid);
     }
     
     /**
     * @description       updates tech approval request with pending status and other fields value.
     * @param             NA
     * @return            NA
     * @throws            Userdefined Exception
     */  
     webservice static  void approvalDocumentsReq(List<String> documentid, List<String> requestid){
        String approvalDocuments = UtilConstants.EMPTY_STRING;
        List<user_master__c> usermaster =[Select id,user__c ,email__c from user_master__c
                                          where user__c =: UserInfo.getUserId() and email__c=:UserInfo.getUserEmail() limit 1];
        Tech_Approval_Request__c appReqToUpdate = new Tech_Approval_Request__c();
        List<Tech_Approval_Request__c> approvaldocumentsListToUpdate = new List<Tech_Approval_Request__c>();
           
        for(Tech_Approval_Request__c appRequest: [SELECT approver__c,approval_request_status__c,Service_Group__c,
                                                 Opportunity__c,approval_sent_date__c,approver__r.Email__c,
                                                 approver__r.user__c,requestor__c,approval_request_type__c, 
                                                 id,SharePoint_Links__c,
                                                ( SELECT Name,Approval_Documents__r.document__c,
                                                 Document_Sharepoint_Link_DEV__c,Opportunity_Tech_Approval_Request__c,
                                                 Approval_Documents__c from Tech_Approval_Documents__r 
                                                 where Approval_Documents__c in :documentid  limit 5000) 
                                                 FROM Tech_Approval_Request__c where id in :requestid limit 5000]){
            String sharepointlinks=UtilConstants.EMPTY_STRING;
                if(appRequest.SharePoint_Links__c!=null){
                    sharepointlinks=appRequest.SharePoint_Links__c;
                }
            if(!UtilConstants.APPROVED_STATUS.Equals(appRequest.approval_request_status__c) && 
               !UtilConstants.PEND_WITH_APPR2.Equals(appRequest.approval_request_status__c)){
            for( Tech_Approval_Documents__c appDocs : appRequest.Tech_Approval_Documents__r ){
                
                if(appDocs.Opportunity_Tech_Approval_Request__c.equals(appRequest.id)){
                    if(appDocs.Document_Sharepoint_Link_DEV__c!=null){
                    if(!sharepointlinks.contains(appDocs.Document_Sharepoint_Link_DEV__c)){
                   sharepointlinks+=appDocs.Document_Sharepoint_Link_DEV__c+UtilConstants.COMMA+UtilConstants.EMPTY_STRING;
                       }
                    }
                  }
                }
                    appReqToUpdate = appRequest;
                    appRequest.SharePoint_Links__c=sharepointlinks;
                    appRequest.approval_sent_date__c=date.Today();
                    appRequest.approval_request_status__c=UtilConstants.PEND_WITH_APPR2;
                    appRequest.requestor__c=usermaster[0].id;
                    approvaldocumentsListToUpdate.add(appRequest);
            }
        }
         try{
                database.update(approvaldocumentsListToUpdate,false);
                sendMail(approvaldocumentsListToUpdate);
                //String Approverid=UtilUser.UtilUser(approvaldocumentsListToUpdate[0].approver__c);
                //String userprofileid =userInfo.getProfileId();
           }
           catch(Exception e){
                throw e;
           }    
     }
     
     /**
     * @description       Method defined for sending mail.
     * @param             List<Tech_Approval_Request__c> maillist
     * @return            void
     * @throws            Userdefined Exception
     */  
     webservice static void sendMail(List<Tech_Approval_Request__c> maillist){
        Map<id, string> OppName=new Map<id,string>();
        set<id> BPOteammbers=new set<id>();
        list<string> BPOemillist=new list<string>();
        for(Tech_Approval_Request__c Opstg:maillist){
            OppName.put(Opstg.id,Opstg.Opportunity__c);
        }
        for(Opportunity_Teams__c Optm:[select Opportunity_Team_Member__r.user__r.email,Role__r.Name 
                                       from Opportunity_Teams__c where  Role__r.Name =:UtilConstants.OPP_SOL_LEAD AND 
                                       Opportunity__r.id =:OppName.values() limit 5000]){
        BPOemillist.add(optm.Opportunity_Team_Member__r.user__r.email);
        }
        Messaging.SingleEmailMessage mail;
        id emailtempid = [select id from emailtemplate where developername=:UtilConstantsR3.Tech_Approval_Test limit 1].id;
        id emailtempidforArchead=[select id from emailtemplate where developername=:UtilConstantsR3.Tech_Arch_Lead_Approval limit 1].id;
        String Cval=emailtempid;
        String Cval1=emailtempidforArchead;
        List<String> CCAddresses;
        list<String> reqids=new List<String>();
        for(Tech_Approval_Request__c appList:maillist){
            if(UtilConstants.BPO.equals(appList.Service_Group__c)){
                       
                String orgWideEmailAddressID=UtilEmail.emailid();
                String emailAddress = UserInfo.getUserEmail();
                mail = new Messaging.SingleEmailMessage();
                mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                CCAddresses = new List<String>();                   
                CCAddresses.add(emailAddress);
                for(string st:BPOemillist){
                CCAddresses.add(st);
                }
                mail.setCcAddresses(CCAddresses);
                mail.setTargetObjectId(appList.approver__r.user__c) ;
                mail.setWhatId(appList.id) ;
                if(!UtilConstantsR3.Arch_Lead_Approval.equalsIgnoreCase(appList.approval_request_type__c)){
                	mail.setTemplateId(Cval);
                }
                else{
                	mail.setTemplateId(Cval1);
                }
                mail.saveAsActivity=false;                      
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }
    
    /**
     * @description       send reminder mails when no document is selected.
     * @param             List<String> reqid
     * @return            void
     * @throws            NA
     */  
    webservice static  void sendReminder(List<String> reqid){
        list<String> reqids=new List<String>();
        for(String s:reqid){
            String[] temp1=s.split(UtilConstants.COMMA_STRING);                     
            reqids.add(temp1[0]);
        }
        List<Tech_Approval_Request__c> approvaldocumentsList=[SELECT id,Opportunity__c,Service_Group__c,
                                                                  approver__r.User__c, requestor__r.Email__c,
                                                                  approval_request_type__c,approval_request_status__c FROM 
                                                                  Tech_Approval_Request__c where id in :reqids 
                                                                  AND approval_request_status__c=:UtilConstantsforSWB.PendingwithApprover limit 5000];
        sendMail(approvaldocumentsList);
    }
    
    /**
     * @description       creates approval document when reminder is sent.
     * @param             List<String> reqid
     * @return            void
     * @throws            NA
     */  
    webservice static  void approvalDocumentsReminderCreateDocument(List<String> documentid, List<String> requestid){
        list<String> reqids=new List<String>();
        for(String s:requestid){
            String[] temp=s.split(UtilConstants.COMMA_STRING);
            reqids.add(temp[0]);
        }
        list<String> documentid1=new List<String>();
        for(String s:documentid){
            String[] temp=s.split(UtilConstants.COMMA_STRING);
            documentid1.add(temp[0]);
        }
        map<Id,Tech_Approval_Request__c> requesltist = new map<Id,Tech_Approval_Request__c>([Select id,Service_Group__c,approval_request_status__c,approval_request_type__c from 
                                                                                            Tech_Approval_Request__c where id IN:reqids limit 5000]);                                                
        List<Tech_Approval_Documents__c> approvalDocumentList=new List<Tech_Approval_Documents__c>();
        for(Opportunity_Documents__c opp:[Select id from opportunity_documents__c
                                            where id IN:documentid1 limit 5000]){
            for(Tech_Approval_Request__c req:requesltist.values()){
                Tech_Approval_Documents__c appdoc =new Tech_Approval_Documents__c();
                if(((UtilConstants.PEND_WITH_APPR2).equals(req.approval_request_status__c))){
                    appdoc.Approval_Documents__c=opp.id;
                    appdoc.Opportunity_Tech_Approval_Request__c=req.id;
                    approvalDocumentList.add(appdoc);
                }
            }
        }
        if(!approvalDocumentList.isEmpty()){
            List<database.SaveResult> result= database.insert(approvalDocumentList,false);
            system.debug('documentid+requestid***'+documentid+'*****'+requestid);
            approvalDocumentsReminder(documentid,requestid);
        }
        else{
            approvalDocumentsReminder(documentid,requestid);  
            }   
    }
    
     /**
     * @description       Method defined for Approval Documents Reminder
     * @param             List<String> documentid, List<String> requestid
     * @return            void
     * @throws            NA
     */ 
    webservice static  void approvalDocumentsReminder(List<String> documentid, List<String> requestid){
        Tech_Approval_Request__c appReqToUpdate = new Tech_Approval_Request__c();
        List<Tech_Approval_Request__c> approvaldocumentsListToUpdate = new List<Tech_Approval_Request__c>();
        for(Tech_Approval_Request__c appRequest: [SELECT approver__c, approver__r.user__c,
                                                    Service_Group__c,approval_sent_date__c,approver__r.Email__c,
                                                    requestor__c,approval_request_type__c,approval_request_status__c, 
                                                    id,SharePoint_Links__c,( SELECT Name,
                                                    Approval_Documents__r.document__c,Document_Sharepoint_Link_DEV__c,
                                                    Opportunity_Tech_Approval_Request__c from Tech_Approval_Documents__r where 
                                                    Approval_Documents__c in :documentid limit 5000) FROM Tech_Approval_Request__c 
                                                    where id in :requestid limit 5000]){
            String sharepointlinks=UtilConstants.EMPTY_STRING;
            if(UtilConstants.PEND_WITH_APPR2.Equals(appRequest.approval_request_status__c)){
                for( Tech_Approval_Documents__c appDocs : appRequest.Tech_Approval_Documents__r ){
                    if(appDocs.Opportunity_Tech_Approval_Request__c.Equals(appRequest.id)){
                        if(!appRequest.SharePoint_Links__c.contains(appDocs.Document_Sharepoint_Link_DEV__c)){
                            sharepointlinks+=appDocs.Document_Sharepoint_Link_DEV__c+UtilConstants.COMMA+UtilConstants.EMPTY_STRING;
                        }
                }
            }
            appReqToUpdate = appRequest;
            appRequest.SharePoint_Links__c+=sharepointlinks+UtilConstants.EMPTY_STRING;
            approvaldocumentsListToUpdate.add(appRequest );
            }
        }
        try{
            sendMail(approvaldocumentsListToUpdate);
            database.update(approvaldocumentsListToUpdate,false);
            //String Approverid=UtilUser.UtilUser(approvaldocumentsListToUpdate[0].approver__c);
            //String userprofileid =userInfo.getProfileId();  
        }
        catch(Exception e){
            String str= e.getmessage();
        }
    }
    
    /**
     * @description       recall the tech approval request.
     * @param             Id appReqId
     * @return            void
     * @throws            DML Exception
     */  
    /*webservice static  void updateRecall(Id appReqId){
     
         Tech_Approval_Request__c appReq = [ Select name,approval_request_status__c from Tech_Approval_Request__c 
                                       where Id =: appReqId limit 1];
         appReq.approval_request_status__c = UtilConstants.PEND_WITH_REQSTR2;
         try{
            update appReq;
         }
         catch(Exception e) {
            String str= e.getmessage();
         }
         
     }*/
     
     /**
     * @description       submits the approval request for approval.
     * @param             NA
     * @return            PageReference
     * @throws            DML Exception
     */  
     public PageReference submit() {
        PageReference pageRef;
        selectedDocuments.clear();
        try{
            for(OpportunityDocumentsWrapper owr:oppdoumentResultsList){
                if(owr.checked){
                    selectedDocuments.add(owr);
                    documentidlist.add(owr.oppdoc.id);
                }
            }
            if(!selectedDocuments.isEmpty()){
                try{
                    if(!documentidlist.isEmpty() && !approvalrequestidstopass.isEmpty() && approvalrequestidstopass.size()!=1){
                        createApprovalDocumentsMethod(documentidlist,approvalrequestidstopass);
                        pageRef=new pagereference('/'+approvalrequestresult[0].approval_stage__c);
                        pageRef.setRedirect(true); 
                    }
                    else if(approvalrequestidstopass.size()==1 && !documentidlist.isEmpty()){
                        if(!approvalrequestresult[0].approval_request_status__c.equalsignorecase('Pending')){
                            createApprovalDocumentsMethod(documentidlist,approvalrequestidstopass);
                            pageRef=new pagereference('/'+approvalrequestresult[0].approval_stage__c);
                            pageRef.setRedirect(true); 
                        }
                        else{
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'One or more request are pending with approver. You can send reminder for them to the approver using Send Reminder Button'));
                            pageRef=null;
                        }
                    }
                    else if(documentidlist.isEmpty()){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Select at least one Document before sending it for approval.'));
                        pageRef=null;
                    }
                }
                catch(Exception e){
                    if(e.getMessage().equalsIgnorecase('List index out of bounds: 0')){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Your user and user master records are not in sync.'));
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                    }
                    pageRef=null;
                }
                return pageRef;   
            }
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Select at least one Document before sending it for approval.'));
                pageRef=null;
            }
        }    
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Select at least one Document before sending it for approval.'));
            pageRef=null;
        }
        return pageRef;
     }
     
     
     /**
     * @description       sends reminder mails to approver.
     * @param             NA
     * @return            PageReference
     * @throws            DML Exception
     */  
     public PageReference sendReminderButtonAction(){
        PageReference pageRef;
        selectedDocuments.clear();
        for(OpportunityDocumentsWrapper owr:oppdoumentResultsList){
            if(owr.checked){
                selectedDocuments.add(owr);
                documentidlist.add(owr.oppdoc.id);
            }
        }
        
        if(!selectedDocuments.isEmpty()){
            if(!documentidlist.isEmpty() && !approvalrequestidstopass.isEmpty()){
                approvalDocumentsReminderCreateDocument(documentidlist,approvalrequestidstopass);
                pageRef=new pagereference('/'+approvalrequestresult[0].approval_stage__c);
                pageRef.setRedirect(true); 
            }
            else{
                pageRef=null;
            }
        }
        else{
            if(!approvalrequestidstopass.isempty()){
                sendReminder(approvalrequestidstopass);
                pageRef=new pagereference('/'+approvalrequestresult[0].approval_stage__c);
                pageRef.setRedirect(true); 
            }
            else{
                pageRef=null;
            }
        }
        return pageRef;
     }
}