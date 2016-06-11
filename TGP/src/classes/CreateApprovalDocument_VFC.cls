/**
   @Author : Apoorva Sharma
   @name   : CreateApprovalDocument_VFC
   @CreateDate : 26 December 2014 
   @Description : 
   @Version : 1.0
  @lastmodified by :Ezdhan 
  @changes : Commented System.debug statements
         Removed hardcoded values  
  */
 global with sharing class CreateApprovalDocument_VFC {
        public String form { get; set; }
        public String approvalrequestid{get;set;}
        public String opportunitydocumentsid{get;set;}
        public list <approval_request__c> approvalrequestresult {get;set;} 
        public List<String> approvalrequestidlist{set;get;}
        public list <opportunity_documents__c> oppdocumentrelatedlist{get;set;}
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
      /***********************
    @method Name : 
    CreateApprovalDocument_VFC
    @parameters  : 
    ApexPages.StandardController controller
    @return type : 
    none
  ************************/
        public CreateApprovalDocument_VFC(ApexPages.StandardController controller) {
            init();
        }
       /***********************
    @method Name : 
    createApprovalDocuments
    @parameters  : 
    none
    @return type : 
    void
  ************************/
       public void createApprovalDocuments(){
       try{
       
       }
       Catch(Exception e)
       {
        String str= e.getmessage();
          // system.debug('E==='+e);
       }
              
       }
    /***********************
    @method Name : 
    init
    @parameters  : 
    none
    @return type : 
    void
  ************************/
       public void init(){
       
       try{
           String url=ApexPages.currentPage().getUrl();
            String id=ApexPages.currentPage().getParameters().get(UtilConstants.LIST_VALUE);
             String ids=ApexPages.currentPage().getParameters().get('id');
            approvalrequestidlist = new List<string>();
            
            approvalrequestidlist=id.split(UtilConstants.COMMA_STRING);
            
            
            approvalrequestresult = [SELECT approval_request_type__c,approver__c,approval_request_status__c,
                                     approval_stage__r.approval_stage_type__c,Version__c,approval_stage__c 
                                     FROM approval_request__c where id in :approvalrequestidlist limit 5000];
                    for(approval_request__c appRec:approvalrequestresult){
                    approvalrequestidstopass.add(appRec.id);
                }
            oppdocumentrelatedlist=[SELECT Name,document__c,comments__c,modified_by__c,modified_date__c,Service_Group__c 
                                   FROM opportunity_documents__c WHERE opportunity__c =:ids and IS_Tech_Document__c= false limit 5000 ];  
                                                   
          if(!oppdocumentrelatedlist.isEmpty()){
                    oppdoumentResultsList =new List<OpportunityDocumentsWrapper>();
                    for(Opportunity_Documents__c oppdocRec :oppdocumentrelatedlist){
                        OpportunityDocumentsWrapper ow =new OpportunityDocumentsWrapper(oppdocRec);
                        oppdoumentResultsList.add(ow);  
                        //documentidlist.add(oppdocRec.id);
                    }
                }
                
              }
          Catch(Exception e)
          {
           String str= e.getmessage();
                    // system.debug('E==='+e);
          } 
       }
       /*guh*/
       /***********************
    @method Name : 
    sendReminder
    @parameters  : 
    List<String> reqid
    @return type : 
    void
  ************************/
       webservice static  void sendReminder(List<String> reqid){
                 //system.debug('reqid'+reqid);
                 list<String> reqids=new List<String>();
                    for(String s:reqid){
                              String[] temp1=s.split(UtilConstants.COMMA_STRING);                     
                              reqids.add(temp1[0]);
                             // system.debug('********reqids'+reqids); 
                             // reqids=s.split(UtilConstants.COMMA_STRING);
         // actionid.add('\''+s+'\'');
     }
                 //system.debug('********reqids after loop'+reqids);
                 List<approval_request__c> approvaldocumentsList=[SELECT id,Opportunity__c,Service_Group__c,Opportunity_Id_Dev__c,
                                                                  approver__r.User__c, requestor__r.Email__c,
                                                                  approval_request_type__c,approval_request_status__c FROM 
                                                                  approval_request__c where id in :reqids AND approval_request_status__c=:UtilConstantsforSWB.PendingwithApprover limit 5000];
                 //system.debug('**********approvaldocumentsList'+approvaldocumentsList);
                 sendMail(approvaldocumentsList);
                 ////system.debug('approvaldocumentsList==========='+approvaldocumentsList[0].Service_Group__c);
                 /* for(integer i=0;i<reqid.size();i++){
                    sendMail(approvaldocumentsList);
                 } */
                 
                 

       }
     /***********************
    @method Name : 
    sendMail
    @parameters  : 
    List<approval_request__c> maillist
    @return type : 
    void
  ************************/
            webservice static void sendMail(List<approval_request__c> maillist){
                //system.debug('*** maillist'+maillist);
                Map<id, string> OppName=new Map<id,string>();
                set<id> IOteammbers=new set<id>();
                set<id> ICteammbers=new set<id>();
                set<id> BPOteammbers=new set<id>();
                list<string> IOemillist=new list<string>(); 
                list<string> ICemillist=new list<string>(); 
                list<string> BPOemillist=new list<string>();
                
                
                for(approval_request__c Opstg:maillist){
                 OppName.put(Opstg.id,Opstg.Opportunity_Id_Dev__c);
                 }
                for(Opportunity_Teams__c Optm:[select Opportunity_Team_Member__c,Role__r.Name 
                                               from Opportunity_Teams__c where 
                                               Role__r.Name =:UtilConstants.OPP_SOL_LEAD AND 
                                               Opportunity__r.id =:OppName.values() limit 5000]){
                    BPOteammbers.add(Optm.Opportunity_Team_Member__c);
                 }
                if(!BPOteammbers.isEmpty()){
               
                 for(User_Master__c urlist: [select User__r.Email from 
                                             User_Master__c where id IN:BPOteammbers limit 500]){
                   BPOemillist.add(urlist.User__r.Email);
                   }
                 }
                for(Opportunity_Teams__c Optm:[select Opportunity_Team_Member__c,
                                               Role__r.Name from Opportunity_Teams__c where 
                                               Role__r.Name =:UtilConstants.IO_OPP_SOL_LEAD AND 
                                               Opportunity__r.id =:OppName.values() limit 5000]){
                    IOteammbers.add(Optm.Opportunity_Team_Member__c);
                 }
                if(!IOteammbers.isEmpty()){
              
                 for(User_Master__c urlist:[select User__r.Email from User_Master__c
                                            where id IN:IOteammbers limit 500]){
                   IOemillist.add(urlist.User__r.Email);
                   }
                    }
                    for(Opportunity_Teams__c Optm:[select Opportunity_Team_Member__c,Role__r.Name from 
                                                   Opportunity_Teams__c where Role__r.Name=:UtilConstants.IC_OP_SOL_LEAD 
                                                   AND Opportunity__r.id =:OppName.values() limit 5000]){
                     ICteammbers.add(Optm.Opportunity_Team_Member__c);
                      }
                if(!ICteammbers.isEmpty()){
                   for(User_Master__c urlists:[select User__r.Email from User_Master__c 
                                               where id IN:ICteammbers limit 500]){
                    ICemillist.add(urlists.User__r.Email);
                   }
                }
                Email_Template__c myCS1 = Email_Template__c.getValues(UtilConstantsforSWB.ApprovalMailBPO);
                String Cval=myCS1.ID__c;
                Email_Template__c myCS2 = Email_Template__c.getValues(UtilConstantsforSWB.FinalApprovalBPO);
                String CvalFinal=myCS2.ID__c;
                Email_Template__c myCS3 = Email_Template__c.getValues(UtilConstantsforSWB.ApprovalMailIC);
                String CvalIC=myCS3.ID__c;
                Email_Template__c myCS4 = Email_Template__c.getValues(UtilConstantsforSWB.ApprovalMailIO);
                String CvalIO=myCS4.ID__c;
                Messaging.SingleEmailMessage mail;
                List<String> CCAddresses;
                list<String> reqids=new List<String>();
                    for(approval_request__c appList:maillist){
                    /*appList=[SELECT id,Opportunity__c,Service_Group__c,Opportunity_Id_Dev__c,
                                                                  approver__r.User__c, requestor__r.Email__c,
                                                                  approval_request_type__c,approval_stage__r.of_Approval_Request_IO__c FROM 
                                                                  approval_request__c where id in :reqids limit 5000];*/
                          //system.debug('approval_stage__r.of_Approval_Request_IO__c'+appList.approval_stage__r.of_Approval_Request_IO__c);
                          //system.debug('*** BPO value'+appList.Service_Group__c);
                            if(UtilConstants.BPO.equals(appList.Service_Group__c)){
                                //system.debug('*** BPO inside');
                                //String approverid=UtilUser.UtilUser(appList.approver__c);
                                if(UtilConstants.FIN_APPRBPO.equals(appList.approval_request_type__c) && UtilConstants.PEND_WITH_REQSTR.equals(appList.approval_request_status__c))
                                            
                                            {
                                            system.debug('I am inside not with BPO'+appList.approval_request_status__c);
                                            
                                            }
                                else{ 
                                    system.debug('*** BPO inside'+appList.approval_request_status__c);       
                                String orgWideEmailAddressID=UtilEmail.emailid();
                                String emailAddress = UserInfo.getUserEmail();
                                mail = new Messaging.SingleEmailMessage();
                                mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                               // List<String> toAddresses = new List<String>();                   
                                //toAddresses.add(maillist[0].approver__r.Email__c);
                                CCAddresses = new List<String>();                   
                                CCAddresses.add(emailAddress);
                                 for(string st:BPOemillist){
                                        CCAddresses.add(st);
                                      }
                                // mail.setToAddresses(toAddresses);
                               mail.setCcAddresses(CCAddresses);
                                mail.setTargetObjectId(appList.approver__r.user__c) ;
                                mail.setWhatId(appList.id) ;
                                //system.debug('UtilConstantsforSWB.FinalApprovalBPO'+appList.approval_request_type__c);
                                if((UtilConstantsforSWB.FinalApproval.EqualsIgnoreCase(appList.approval_request_type__c)))
                                {
                                mail.setTemplateId(Cval);
                                }
                                else{
                                    mail.setTemplateId(Cval);
                                }  
                                mail.saveAsActivity=false;                      
                                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                                }
                            } else if(UtilConstants.IC.equals(appList.Service_Group__c)){
                                        //system.debug('*** IC inside');
                                        if(UtilConstants.FIN_APPRIC.equals(appList.approval_request_type__c) && UtilConstants.PEND_WITH_REQSTR.equals(appList.approval_request_status__c))
                                            {
                                            system.debug('I am inside not with IC'+appList.approval_request_status__c);
                                            }
                                            else{
                                            system.debug('*** IC inside'+appList.approval_request_status__c);
                                        String approverid=UtilUser.UtilUser(maillist[0].approver__c);
                                        String orgWideEmailAddressID=UtilEmail.emailid(); 
                                system.debug('orgWideEmailAddressIDorgWideEmailAddressIDorgWideEmailAddressIDorgWideEmailAddressIDorgWideEmailAddressID'+orgWideEmailAddressID);
                                        //String orgWideEmailAddressID=UtilEmail.emailid();
                                        //String orgWideEmailAddressID='ravi.a.mandala@accenture.com'; 
                                        String emailAddress = UserInfo.getUserEmail();
                                        mail = new Messaging.SingleEmailMessage();
                                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                                       // List<String> toAddresses = new List<String>();                   
                                        //toAddresses.add(maillist[0].approver__r.Email__c);
                                        //system.debug('Inside IC');
                                        CCAddresses = new List<String>();                   
                                        CCAddresses.add(emailAddress);
                                        for(string st:ICemillist){
                                        CCAddresses.add(st);
                                      }
                                        //system.debug('++++'+CCAddresses);
                                       // mail.setToAddresses(toAddresses);
                                        mail.setCcAddresses(CCAddresses);
                                        mail.setTargetObjectId(approverid) ;
                                        mail.setWhatId(appList.id) ;
                                        //mail.setTemplateId('00Xc0000000Mafn');
                                        mail.setTemplateId(CvalIC);
                                        mail.saveAsActivity=false;                      
                                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                                        }
                                    }else if(UtilConstants.IO.equals(appList.Service_Group__c)){
                                            
                                            if(UtilConstants.FIN_APPRIO.equals(appList.approval_request_type__c) && UtilConstants.PEND_WITH_REQSTR.equals(appList.approval_request_status__c))
                                            
                                            {
                                            system.debug('I am inside not with IO'+appList.approval_request_status__c);
                                            }
                                            
                                            else{
                                                system.debug('*** IO inside'+appList.approval_request_status__c);
                                                String approverid=UtilUser.UtilUser(maillist[0].approver__c);
                                                String orgWideEmailAddressID=UtilEmail.emailid();
                                                //String orgWideEmailAddressID=UtilEmail.emailid();
                                                //String orgWideEmailAddressID='ravi.a.mandala@accenture.com'; 
                                                 //system.debug('emailbyravi1'+orgWideEmailAddressID);
                                                String emailAddress = UserInfo.getUserEmail();
                                                mail = new Messaging.SingleEmailMessage();
                                                mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                                                //system.debug('emailbyravi'+orgWideEmailAddressID);
                                               // List<String> toAddresses = new List<String>();                   
                                                //toAddresses.add(maillist[0].approver__r.Email__c);
                                                //system.debug('Inside IO');
                                                CCAddresses = new List<String>();                   
                                                CCAddresses.add(emailAddress);
                                                for(string st:IOemillist){
                                                CCAddresses.add(st);
                                              }
                                                //system.debug('++++'+CCAddresses);
                                               // mail.setToAddresses(toAddresses);
                                                mail.setCcAddresses(CCAddresses);
                                                mail.setTargetObjectId(approverid) ;
                                                mail.setWhatId(appList.id) ;
                                                //mail.setTemplateId('00Xc0000000Mafs');
                                                mail.setTemplateId(CvalIO);  
                                                mail.saveAsActivity=false;                      
                                                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                                                }
                                            }
                                            
                                            else{
                                            }
                        }
                        
                       
       }
   /***********************
    @method Name : 
    approvalDocumentsReq
    @parameters  : 
    List<String> documentid, List<String> requestid
    @return type : 
    void
  ************************/
       webservice static  void approvalDocumentsReq(List<String> documentid, List<String> requestid){
           try{
           String approvalDocuments = UtilConstants.EMPTY_STRING;
           //system.debug('approvalDocumentsReq');
        List<user_master__c> usermaster =[Select id,user__c ,email__c from user_master__c
                                          where user__c =: UserInfo.getUserId() and email__c=:UserInfo.getUserEmail() limit 1];
        approval_request__c appReqToUpdate = new approval_request__c();
        List<approval_request__c> approvaldocumentsListToUpdate = new List<approval_request__c>();
           
        for(approval_request__c appRequest: [SELECT approver__c,approval_request_status__c,Service_Group__c,
                                             Opportunity__c,Opportunity_Id_Dev__c,approval_stage__r.of_Approval_Request_IO__c,approval_stage__r.of_Approval_Request_IC__c,approval_stage__r.of_approval_request__c,approval_sent_date__c,approver__r.Email__c,
                                             approver__r.user__c,requestor__c,approval_request_type__c, 
                                             id,SharePoint_Links__c,
                                             ( SELECT Name,approval_document__r.document__c,
                                             Document_Sharepoint_Link_DEV__c,Opportunity_Approval_Request__c,
                                             approval_document__c from approval_documents__r 
                                             where approval_document__c in :documentid  limit 5000) 
                                             FROM approval_request__c where id in :requestid limit 5000]){
            String sharepointlinks=UtilConstants.EMPTY_STRING;
                if(appRequest.SharePoint_Links__c!=null){
                    sharepointlinks=appRequest.SharePoint_Links__c;
                }
             //system.debug('approval_request_status__c'+appRequest.approval_request_status__c);
            if(!UtilConstants.APPROVED_STATUS.Equals(appRequest.approval_request_status__c) && 
               !UtilConstants.PEND_WITH_APPR2.Equals(appRequest.approval_request_status__c)){
               // system.debug('approvalDocumentsReq'+appRequest.approval_documents__r);
            for( approval_documents__c appDocs : appRequest.approval_documents__r ){
                if(appDocs.Opportunity_Approval_Request__c.Equals(appRequest.id)){
                    //system.debug('sharepointlinks-----'+sharepointlinks);
                    //system.debug('appDocs.Document_Sharepoint_Link_DEV__c-----'+appDocs.Document_Sharepoint_Link_DEV__c);
                    if(!sharepointlinks.contains(appDocs.Document_Sharepoint_Link_DEV__c)){
                   sharepointlinks+=appDocs.Document_Sharepoint_Link_DEV__c+UtilConstants.COMMA+UtilConstants.EMPTY_STRING;
                   //sharepointlinks+=appDocs.Document_Sharepoint_Link_DEV__c+UtilConstants.EMPTY_STRING;
                    //sharepointlinks+=UtilConstants.START_HREF+appDocs.Document_Sharepoint_Link_DEV__c+
                             //UtilConstants.INBET_HREF+appDocs.approval_document__r.document__c+UtilConstants.END_HREF;
                            
                       }
                  }
                }
                //approval_request_type__c , 'IO Final Approval'), approval_stage__r.of_Approval_Request_IO__c <> 0, ISPICKVAL( Service_Group__c ,'IO') ),True,false)
                //system.debug('sharepointlinkssharepointlinks:::'+sharepointlinks);
                appReqToUpdate = appRequest;
                appRequest.SharePoint_Links__c=sharepointlinks;
                appRequest.approval_sent_date__c=date.Today();
                system.debug(' app request type****'+appRequest.approval_request_type__c);
                system.debug(' app request ****'+appRequest.approval_stage__r.of_Approval_Request_IO__c);
                system.debug(' app request ****'+appRequest.approval_stage__r.of_approval_request__c);
                system.debug(' app request ****'+appRequest.approval_stage__r.of_Approval_Request_IC__c);
                
               /* if(UtilConstants.FIN_APPRBPO.equals(appRequest.approval_request_type__c) && appRequest.approval_stage__r.of_approval_request__c!=0 && UtilConstants.BPO.equals(appRequest.Service_Group__c))
                {
                
                 appRequest.approval_request_status__c='Not Sent';
                 system.debug('*** pening with approver insideBPO'+appRequest.approval_request_status__c);
                }else
                if(UtilConstants.FIN_APPRIO.equals(appRequest.approval_request_type__c) && appRequest.approval_stage__r.of_Approval_Request_IO__c!=0 && UtilConstants.IO.equals(appRequest.Service_Group__c))
                {
                appRequest.approval_request_status__c='Not Sent';
                 system.debug('*** pening with approver insideIO'+appRequest.approval_request_status__c);
                }else
                if(UtilConstants.FIN_APPRIC.equals(appRequest.approval_request_type__c) && appRequest.approval_stage__r.of_Approval_Request_IC__c!=0 && UtilConstants.IC.equals(appRequest.Service_Group__c))
                {
                appRequest.approval_request_status__c='Not Sent';
                 system.debug('*** pening with approver insideIC'+appRequest.approval_request_status__c);
                }*/
                //else
               // {
                appRequest.approval_request_status__c=UtilConstants.PEND_WITH_APPR2;
                 system.debug('*** pening with approver inside'+appRequest.approval_request_status__c);
                //}
                appRequest.requestor__c=usermaster[0].id;
                approvaldocumentsListToUpdate.add(appRequest );
            }
        }
            //try{
                //system.debug('******list to up****'+approvaldocumentsListToUpdate);
                database.update(approvaldocumentsListToUpdate,false);
                //system.debug('approvaldocumentsListToUpdate++++'+approvaldocumentsListToUpdate);
                sendMail(approvaldocumentsListToUpdate);
                String Approverid=UtilUser.UtilUser(approvaldocumentsListToUpdate[0].approver__c);
                String userprofileid =userInfo.getProfileId();
                //system.debug(' userprofileid'+userInfo.getProfileId());
                
            //}
            //catch(Exception e){
                 //system.debug('Exception-----'+e);
                
            //}
           }catch(Exception e){
               //system.debug('exception------------------------------------------'+e);
               throw new myException();
               
           }    
     } 
     //Added by Joytsna Start
     
     /***********************
    @method Name : 
    updateRecall
    @parameters  : 
    id of appReqid
    @return type : 
    void
  ************************/
     webservice static  void updateRecall(Id appReqId){
     
         requestTaskClose.isRecalled = true;
         Approval_Request__c appReq = [ Select name,approval_request_status__c from Approval_Request__c 
                                       where Id =: appReqId limit 1];
         appReq.approval_request_status__c = UtilConstants.PEND_WITH_REQSTR2;
         update appReq;
         
     }
     //Addd by Jyotsna END
     
     
     /***********************
    @method Name : 
    approvalDocumentsReminderCreateDocument
    @parameters  : 
    list of docuement ids  and request ids
    @return type : 
    void

  ************************/    

    webservice static  void approvalDocumentsReminderCreateDocument(List<String> documentid, List<String> requestid){
                 list<String> reqids=new List<String>();
            for(String s:requestid){
                 String[] temp=s.split(UtilConstants.COMMA_STRING);
                reqids.add(temp[0]);
                 //system.debug('::::::::::SIZE:'+reqids);
                }
        // system.debug('createApprovalDocumentsMethod');
        list<String> documentid1=new List<String>();
         //system.debug('documentid'+documentid);
        for(String s:documentid){
            String[] temp=s.split(UtilConstants.COMMA_STRING);
             documentid1.add(temp[0]);
           // system.debug('::::::::::SIZEdocumentid:'+documentid);
             }
         /*List<Opportunity_Documents__c> oppdocument=[Select id from opportunity_documents__c
                                                     where id IN:documentid1 limit 5000];*/
         /*List<Approval_request__c> requesltist =[Select id,Service_Group__c,approval_request_status__c from 
                                                 Approval_request__c where id IN:reqids limit 5000];*/
    map<Id,Approval_request__c> requesltist = new map<Id,Approval_request__c>([Select id,Service_Group__c,approval_request_status__c,approval_request_type__c from 
                                                 Approval_request__c where id IN:reqids limit 5000]);                                                
         List<approval_documents__c> approvalDocumentList=new List<approval_documents__c>();
         for(Opportunity_Documents__c opp:[Select id from opportunity_documents__c
                                                     where id IN:documentid1 limit 5000]){
             for(Approval_request__c req:requesltist.values()){
                 
                 //System.debug('Check');
                 approval_documents__c appdoc =new approval_documents__c();
                 if(((UtilConstants.PEND_WITH_APPR2).equals(req.approval_request_status__c))){
                    // System.debug('Check TWo' +req.id);
                    appdoc.approval_document__c=opp.id;
                    appdoc.Opportunity_Approval_Request__c=req.id;
                     approvalDocumentList.add(appdoc);
                 }
             }
         }
         //system.debug('approvalDocumentList size'+approvalDocumentList.size());
         if(!approvalDocumentList.isEmpty()){
            List<database.SaveResult> result= database.insert(approvalDocumentList,false);
            system.debug('documentid+requestid***'+documentid+'*****'+requestid);
            approvalDocumentsReminder(documentid,requestid);
         }
         else{
         approvalDocumentsReminder(documentid,requestid);  
         }   
     }
    /***********************
    @method Name : 
    approvalDocumentsReminder
    @parameters  : 
    list of docuement ids  and request ids
    @return type : 
    void
  ************************/
    webservice static  void approvalDocumentsReminder(List<String> documentid, List<String> requestid){
        
        
        approval_request__c appReqToUpdate = new approval_request__c();
        List<approval_request__c> approvaldocumentsListToUpdate = new List<approval_request__c>();
        for(approval_request__c appRequest: [SELECT approver__c, approver__r.user__c,
                                             Service_Group__c,Opportunity_Id_Dev__c,approval_sent_date__c,approver__r.Email__c,
                                             requestor__c,approval_request_type__c,approval_request_status__c, 
                                             id,SharePoint_Links__c,( SELECT Name,
                                             approval_document__r.document__c,Document_Sharepoint_Link_DEV__c,
                                             Opportunity_Approval_Request__c from approval_documents__r where 
                                             approval_document__c in :documentid limit 5000) FROM approval_request__c 
                                             where id in :requestid limit 5000]){
            String sharepointlinks=UtilConstants.EMPTY_STRING;
            if(UtilConstants.PEND_WITH_APPR2.Equals(appRequest.approval_request_status__c)){
            for( approval_documents__c appDocs : appRequest.approval_documents__r ){
                if(appDocs.Opportunity_Approval_Request__c.Equals(appRequest.id)){
                    if(!appRequest.SharePoint_Links__c.contains(appDocs.Document_Sharepoint_Link_DEV__c)){
                    //sharepointlinks+=appDocs.Document_Sharepoint_Link_DEV__c;
                     sharepointlinks+=appDocs.Document_Sharepoint_Link_DEV__c+UtilConstants.COMMA+UtilConstants.EMPTY_STRING;
                    }
                  }
                }
                //system.debug('sharepointlinks'+sharepointlinks);
                appReqToUpdate = appRequest;
                  // appRequest.SharePoint_Links__c+=sharepointlinks+UtilConstants.COMMA+UtilConstants.EMPTY_STRING;
                   appRequest.SharePoint_Links__c+=sharepointlinks+UtilConstants.EMPTY_STRING;
                approvaldocumentsListToUpdate.add(appRequest );
            }}
            try{
                sendMail(approvaldocumentsListToUpdate);
                database.update(approvaldocumentsListToUpdate,false);
                //sendMail(approvaldocumentsListToUpdate);
                String Approverid=UtilUser.UtilUser(approvaldocumentsListToUpdate[0].approver__c);
                String userprofileid =userInfo.getProfileId();  
            }
            catch(Exception e){

               String str= e.getmessage();   //system.debug('Exception-----'+e);


                
            }
        }
     
      /***********************
    @method Name 
    createApprovalDocumentsMethod
    @parameters
    list of docuement ids  and request ids
    @return type 
    void
  ************************/
     webservice static  void createApprovalDocumentsMethod(List<String> documentid, List<String> requestid){
         list<String> reqids=new List<String>();
            for(String s:requestid){
                 String[] temp=s.split(UtilConstants.COMMA_STRING);
                reqids.add(temp[0]);
                 //system.debug('::::::::::SIZE:'+reqids);
                }
         //system.debug('createApprovalDocumentsMethod');
        list<String> documentid1=new List<String>();
        for(String s:documentid){
            String[] temp=s.split(UtilConstants.COMMA_STRING);
             documentid1.add(temp[0]);
           // system.debug('::::::::::SIZE:'+documentid);
             }
         /*List<Opportunity_Documents__c> oppdocument=[Select id from opportunity_documents__c where 
                                                     id IN:documentid1 limit 5000];*/
         /*List<Approval_request__c> requesltist =[Select id,Service_Group__c,approval_request_status__c from 
                                                 Approval_request__c where id IN:reqids limit 5000];*/
    map<Id,Approval_request__c> requesltist = new map<Id, Approval_request__c>([Select id,Service_Group__c,approval_request_status__c from 
                                                 Approval_request__c where id IN:reqids limit 5000]);                                                 
         List<approval_documents__c> approvalDocumentList=new List<approval_documents__c>();
         for(Opportunity_Documents__c opp:[Select id from opportunity_documents__c where 
                                                     id IN:documentid1 limit 5000]){
             for(Approval_request__c req:requesltist.values()){
                 
                // System.debug('Check');
                 approval_documents__c appdoc =new approval_documents__c();
                 //system.debug('req.approval_request_status__c'+req.approval_request_status__c);
                 if((!(UtilConstants.APPROVED_STATUS).equals(req.approval_request_status__c)) &&
                    (!(UtilConstants.PEND_WITH_APPR2).equals(req.approval_request_status__c))){
                    // system.debug('Current User::::'+Userinfo.getUserName());
                    // System.debug('Check TWo' +req.id);
                    appdoc.approval_document__c=opp.id;
                    appdoc.Opportunity_Approval_Request__c=req.id;
                     approvalDocumentList.add(appdoc);
                 }
             }
         }
         //system.debug('approvalDocumentList size'+approvalDocumentList.size());
         if(!approvalDocumentList.isEmpty()){
             try{

                 List<database.SaveResult> result= database.insert(approvalDocumentList,false);
                 //system.debug('result'+result);
             }
             catch(Exception e){

                String str= e.getmessage();  //system.debug('Exception::::::::::'+e);


             }
         }
         approvalDocumentsReq(documentid,requestid);
     }
     
     /**
     * @description       submits request for approval.
     * @param             NA
     * @return            PageReference
     * @throws            DML Exception
     */  
    public PageReference submitforapproval()
    {
    PageReference pageRef;
        selectedDocuments.clear();
        for(OpportunityDocumentsWrapper owr:oppdoumentResultsList){
            if(owr.checked){
                selectedDocuments.add(owr);
                documentidlist.add(owr.oppdoc.id);
            }
        }
        if(!selectedDocuments.isEmpty()){
            if(!documentidlist.isEmpty() && !approvalrequestidstopass.isEmpty() && approvalrequestidstopass.size()!=1){
                createApprovalDocumentsMethod(documentidlist,approvalrequestidstopass);
                pageRef=new pagereference('/'+approvalrequestresult[0].approval_stage__c);
                pageRef.setRedirect(true); 
            }
            else if(approvalrequestidstopass.size()==1 && !documentidlist.isEmpty()){
                if(!approvalrequestresult[0].approval_request_status__c.equalsignorecase('Pending')){
                    system.debug('Documentlist---'+documentidlist);
                     system.debug('approvalrequestide---'+approvalrequestidstopass);
                    createApprovalDocumentsMethod(documentidlist,approvalrequestidstopass);
                     system.debug('approvalrequestresult---'+approvalrequestresult);
                      system.debug('approvalrequestresult1---'+approvalrequestresult[0].approval_stage__c);
                    pageRef=new pagereference('/'+approvalrequestresult[0].approval_stage__c);
                    pageRef.setRedirect(true); 
                }
                else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'One or more request are pending with approver. You can send reminder for them to the approver using Send Reminder Button'));
                }
            }
            return pageRef;
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Select at least one Document before sending it for approval.'));
            
        }
        return pageRef;
    }
      /**
     * @description       sends reminder mails to approver.
     * @param             NA
     * @return            PageReference
     * @throws            DML Exception
     */  
    public PageReference sendReminderButtonAction()
    {
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
               // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Select at least one Document before sending reminder.'));
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
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Select at least one Document before sending reminder.'));
            
        
            }
        }
        return pageRef;
    }
}