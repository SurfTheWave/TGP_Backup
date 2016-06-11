/**
   @Author :Apoorva Sharma
   @name   : TechApprovalRequestOperations 
   @CreateDate : 27 November 2015 
   @Description : This class is used for perform operations on Tech Approval Request.
   @Version : 1.0 
  */
public with sharing class TechApprovalRequestOperations {
    
    /**
     * @description       closes task associated with approval request when an approver takes an action
     * @param             List<Tech_Approval_Request__c> rlist
     * @return            Void
     * @throws            DML Exception
     */  
     public static void requestTaskClose(List<Tech_Approval_Request__c> rlist){
        try{
            Set<Id> reqids = new Set<Id>();
            List<Task> taskstoupdate = new list<Task>();
            for( Tech_Approval_Request__c req : rlist){
               
                if((req.approval_request_status__c.EqualsIgnorecase(UtilConstants.REWORK1) || 
                    req.approval_request_status__c.EqualsIgnorecase(UtilConstants.APPRVD) ||
                    req.approval_request_status__c.EqualsIgnorecase(UtilConstants.REJ) ||
                    req.approval_request_status__c.EqualsIgnorecase(UtilConstants.READYREV))
                 ||(req.isRecalled__c &&  req.approval_request_status__c.EqualsIgnorecase(UtilConstants.PEND_REQ) && req.Approval_Sent_Date__c!=null )) {
                            reqids.add(req.id);
                
                }
            }
            if(!reqids.isEmpty()){
                for(Tech_Approval_Request__c req : [SELECT Id, (SELECT Id, Whatid, status FROM Tasks limit 5000) 
                                                from Tech_Approval_Request__c Where Id in: reqids Limit 5000]) {
                    for(Task t : req.Tasks) {
                    t.status= UtilConstants.COMPLETED;
                    taskstoupdate.add(t);
                    }
                }
            }
            if(taskstoupdate.size()>0) {
                List<Database.saveResult> uresult = database.update (taskstoupdate,false);
            }
        }
        Catch(DMLException e) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
        }
    }
    
    /**
     * @description       sends response received mail once approver has taken an action
     * @param             List<Tech_Approval_Request__c> rlist
     * @return            Void
     * @throws            DML Exception
     */  
     public static void sendMail(List<Tech_Approval_Request__c> rlist){
        Map<id, string> OppName=new Map<id,string>();
        set<id> BPOteammbers=new set<id>();
        list<string> BPOemillist=new list<string>();
        List<String> ccAddresses ;
        List<String> toAddress;
        try{
            For(Tech_Approval_Request__c r : rlist){
                OppName.put(r.id,r.Opportunity_Id_Dev__c);
            }
            for(Opportunity_Teams__c Optm:[select Opportunity_Team_Member__c,Opportunity_Team_Member__r.email__c,Role__r.Name 
                                            from Opportunity_Teams__c where Role__r.Name =: UtilConstants.OPP_SOL_LEAD 
            AND Opportunity__c =:OppName.values()Limit 5000]){
            BPOemillist.add(Optm.Opportunity_Team_Member__r.email__c);
            }
            id emailtempid = [select id from emailtemplate where developername=:UtilConstantsR3.Tech_Post_Approval limit 1].id;
            string myCCval = emailtempid;
            String orgWideEmailAddressID=UtilEmail.emailid();
            List<Tech_Approval_Request__c>alist=[SELECT id,Opportunity__c,Service_Group__c,Opportunity_Id_Dev__c,
                                            approval_request_status__c,approver__r.User__c, requestor__r.Email__c,
                                            approval_request_type__c FROM Tech_Approval_Request__c where id in :rlist];
              for( Tech_Approval_Request__c appRequestRec : alist){
                if( appRequestRec.approval_request_status__c != null && !appRequestRec.approval_request_status__c.equalsignorecase(UtilConstants.EMPTY_STRING ) && 
                    !appRequestRec.approval_request_status__c.equalsignorecase(UtilConstants.PEND_WITH_APPR2) 
                    && !appRequestRec.approval_request_status__c.equalsignorecase(UtilConstants.PEND_REQ)){
                      String Approverid=appRequestRec.approver__r.User__c;
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                    ccAddresses = new List<String>();
                    if(appRequestRec.Requestor__r.email__c!=null){
                        ccAddresses.add(appRequestRec.Requestor__r.email__c);
                    }
                    for(string st:BPOemillist){ 
                        ccAddresses.add(st);
                    }
                    mail.setCCAddresses(ccAddresses);
                    mail.setWhatId(appRequestRec.id) ;
                    mail.setTargetObjectId(Approverid) ;
                    mail.setTemplateId(myCCVal); 
                    mail.saveAsActivity=false;                       
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });       
                }
            }
        }
        Catch(DMLException e) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
        }
    }
    
    /**
     * @description       validates the delete operation 
     * @param             List<Tech_Approval_Request__c> rlist
     * @return            Void
     * @throws            DML Exception
     */  
    public static void validateBeforeDelete( List<Tech_Approval_Request__c> approvalRequestList ){
        try{
            for( Tech_Approval_Request__c appRequestRec : approvalRequestList){
                if( appRequestRec.approval_request_status__c.equalsIgnoreCase(UtilConstants.PEND_APPROV) &&
                    appRequestRec.approval_sent_date__c != null ){
                    appRequestRec.addError(UtilConstantsR3.SRYAPPREQ);
                }
            if( appRequestRec.approval_request_status__c.equalsIgnoreCase(UtilConstants.APPRVD) && 
                appRequestRec.approval_sent_date__c != null ){
                appRequestRec.addError(UtilConstantsR3.SRYAPPREQAPP);
            }            
        }
        }Catch(DMLException e) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
        }
    }
    
    /**
     * @description       mail to final approver once all the intermidiatry approval is done
     * @param             List<Tech_Approval_Request__c> rlist
     * @return            Void
     * @throws            DML Exception
     */  
    public static void sendMailToFinalApprover(List<Tech_Approval_Request__c> rlist){
         set<id> approvalstage=new set<id>();
         List<Messaging.SingleEmailMessage> mailtosend=new List<Messaging.SingleEmailMessage>();
         for(Tech_Approval_Request__c techAppRec:rlist){
            approvalstage.add(techAppRec.Approval_Stage__c);
         }
         //map<string,string> statustype=new map<string,string>();
         id emailtempid = [select id from emailtemplate where developername=:UtilConstantsR3.Tech_Final_Approval limit 1].id;
         id finalArchlead = [select id from emailtemplate where developername=:UtilConstantsR3.Tech_Final_Approval_Arch_lead limit 1].id;
         string myCCval = emailtempid;
         string myCCval1 = finalArchlead;
         String orgWideEmailAddressID=UtilEmail.emailid();
         Messaging.SingleEmailMessage mail;
         list<Tech_Approval_Stage__c> techApprovalRecords=[Select id,Final_Approval__c,(select id,approval_request_status__c,approval_request_type__c,approver__r.User__c
                                                            ,Requestor__r.email__c from Tech_Approval_Requests__r),Arch_Lead_Approval_count__c,Tech_for_Ops_Approval__c,
                                                            Tech_Lead_Approval_Count__c
                                                            from Tech_Approval_Stage__c where id in :approvalstage];
        for(Tech_Approval_Stage__c appstageRec:techApprovalRecords){
            Integer approvalsize=appstageRec.Tech_Approval_Requests__r.size();
            boolean isFinalApproval=false;
            string approver;
            string requestor;
            string apprvalrequestid;
            string apprvaltype;
            boolean sendfinalapprovalmail=false;
            boolean onlyFinalApprovalPending = false;
            for(Tech_Approval_Request__c appreqRec :appstageRec.Tech_Approval_Requests__r){
                if(appreqRec.approval_request_status__c.equalsignorecase(UtilConstants.PEND_WITH_APPR2) && 
                    appstageRec.Final_Approval__c.equalsignorecase(appreqRec.approval_request_type__c)){
                     system.debug('is Final approval-------true'+appreqRec.approval_request_type__c);
                     isFinalApproval=true;
                     approver=appreqRec.approver__r.User__c;
                     requestor=appreqRec.Requestor__r.email__c;
                     apprvalrequestid=appreqRec.id;
                     apprvaltype=appreqRec.approval_request_type__c;
                }
            }
            
            if(isFinalApproval){
                for(Integer i=0;i<approvalsize;i++)
                {   
                    
                    
                    if((!(appstageRec.Tech_Approval_Requests__r[i].approval_request_type__c).equals(appstageRec.Final_Approval__c))){
                        if((appstageRec.Tech_Approval_Requests__r[i].approval_request_status__c.EqualsIgnoreCase(UtilConstants.APPRVD))){
                               onlyFinalApprovalPending = true;
                             //sendfinalapprovalmail=true;
                        }
                        else{
                            onlyFinalApprovalPending = false;
                            break;
                        }
                    }
                }
            }

            //send email for Arch Lead
            if(onlyFinalApprovalPending){
                mail = new Messaging.SingleEmailMessage();
                mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                mail.setWhatId(apprvalrequestid) ;
                mail.setTargetObjectId(approver);
                List<String> CCAddresses = new List<String>(); 
                CCAddresses.add(requestor);
                mail.setCcAddresses(CCAddresses);
                if(UtilConstantsR3.Arch_Lead_Approval.equalsIgnoreCase(apprvaltype))
                {
                	mail.setTemplateId(myCCVal1); 
                }else{
                	mail.setTemplateId(myCCVal);
                }
                mail.saveAsActivity=false;                       
                mailtosend.add(mail); 
            }
        }
        
        if(!mailtosend.isEmpty()){
            Messaging.sendEmail(mailtosend);
        }   
        
    }
    
     /**
     * @description       this method will restrict approval of final Approval if intermidiatary Approvals are pending
     * @param             List<Tech_Approval_Request__c> rlist
     * @return            Void
     * @throws            User Defined Exception
     */  
     public static void restrictApproval(List<Tech_Approval_Request__c> rlist,String FinalApproval){
        //list of all thoes records which are pending with approver or either not sent
        
        set<id>Approvalstage=new set<id>();
        for(Tech_Approval_Request__c rec:rlist){
            Approvalstage.add(rec.Approval_Stage__c);
        }
        List<Tech_Approval_Request__c> techRequestRecords=[Select id,approval_request_status__c,approval_request_type__c,Final_Approval__c
                                                             from Tech_Approval_Request__c where approval_request_type__c!=:FinalApproval
                                                             and (approval_request_status__c=:UtilConstants.PENDING_STATUS  or approval_request_status__c=:UtilConstants.PEND_WITH_REQSTR) 
                                                             and Approval_Stage__c in:Approvalstage ];
        if(!techRequestRecords.isEmpty()){
            throw new myException();
        }
     }
     
     /**
     * @description       This method is used to ensure that only technical arechitect leads/technical arechitect are allowed to create approval request.
     * @param             list<Watcher__c> watcherList
     * @return            Void
     * @throws            User-Defined Exception
     */  
     public static void addRequest(list<Tech_Approval_Request__c> requestlist){
        set<id> opportunityIds =new set<id>();
        for(Tech_Approval_Request__c req:requestlist){
            opportunityIds.add(req.Opportunity_Id_Dev__c);
        }
        
        list<Opportunity_Teams__c> oppTeamRec=[Select id,Opportunity_Role_Dev__c,Opportunity_Team_Member__r.user__c,Opportunity__c from Opportunity_Teams__c where 
                                                (Opportunity_Role_Dev__c=:UtilConstantsR3.SuppTechArch or Opportunity_Role_Dev__c=:UtilConstantsR3.Tech_Arch) and Opportunity__c in :opportunityIds and 
                                                Opportunity_Team_Member__r.user__c=:userinfo.getUserid() limit 5000];
        if(oppTeamRec.isEmpty() &&  userinfo.getProfileId()!=UtilConstantsforSWB.utilMethod(Label.System_Admin_Profile)){
              for(Tech_Approval_Request__c requestRec:requestlist){
                requestRec.addError(UtilConstantsR3.ERROR_MSG_TestRequest);
              }
        }
        
        
     }
     
     
      /**
     * @description       This method is used to ensure that only technical arechitect leads/technical arechitect are allowed to create Tech MOM.
     * @param             list<Tech_Minutes_Of_Meeting__c > momlist
     * @return            Void
     * @throws            User-Defined Exception
     */  
     public static void addMOM(list<Tech_Minutes_Of_Meeting__c > requestlist){
        set<id> opportunityIds =new set<id>();
        for(Tech_Minutes_Of_Meeting__c req:requestlist){
            opportunityIds.add(req.Opportunity_Id_Dev__c);
        }
        
        list<Opportunity_Teams__c> oppTeamRec=[Select id,Opportunity_Role_Dev__c,Opportunity_Team_Member__r.user__c,Opportunity__c from Opportunity_Teams__c where 
                                                (Opportunity_Role_Dev__c=:UtilConstantsR3.SuppTechArch or Opportunity_Role_Dev__c=:UtilConstantsR3.Tech_Arch) and Opportunity__c in :opportunityIds and 
                                                Opportunity_Team_Member__r.user__c=:userinfo.getUserid() limit 5000];
        if(oppTeamRec.isEmpty() &&  userinfo.getProfileId()!=UtilConstantsforSWB.utilMethod(Label.System_Admin_Profile)){
              for(Tech_Minutes_Of_Meeting__c requestRec:requestlist){
                requestRec.addError(UtilConstantsR3.ERROR_MSG_TechMOM);
              }
        }
        
        
     }
     
     /**
     * @description       This method is used to update Tech Solution Deck Score at Opportunity Level.
     * @param             list<Tech_Approval_Request__c > requestlist
     * @return            Void
     * @throws            dml exception
     */  
     public static void updateTechSolutionDeckScore(list<Tech_Approval_Request__c > requestlist){
     	Set<id> opportunityId=new set<id>();
     	map<id,datetime>appreqDateMap=new map<id,datetime>();
     	map<id,decimal>scoremap=new map<id,decimal>();
     	for(Tech_Approval_Request__c techReq:requestlist){
     		if(UtilConstantsR3.approved.equalsIgnoreCase(techReq.approval_request_status__c) && 
     		   UtilConstantsR3.Arch_Lead_Approval.equalsIgnorecase(techReq.approval_request_type__c)){
     		   	opportunityId.add(techReq.Opportunity_Id_Dev__c);
     		}
     	}
     	List<Tech_Approval_Request__c> techApprovalRequest=[SELECT id,Approval_Stage__r.Opportunity__c,approval_request_status__c, Approval_Stage_Created_Date__c,approval_request_type__c,Tech_Solution_Deck_Score__c,
     														Approval_Stage__r.Opportunity__r.Tech_Solution_Deck_Score__c,response_received_date__c,Approval_Stage__r.approval_stage_type__c,
     														Approval_Stage__c
     														from Tech_Approval_Request__c where Approval_Stage__r.Opportunity__c in:opportunityId and approval_request_type__c=:UtilConstantsR3.Arch_Lead_Approval
     														and approval_request_status__c=:UtilConstantsR3.approved order by Approval_Stage_Created_Date__c asc
     														limit 5000];
     	system.debug('techApprovalRequest list size'+techApprovalRequest.size());
        List<Opportunity> opportunityRecToUpdate=new List<Opportunity>();
        Opportunity oppRectoUpdate;
        List<Tech_Approval_Request__c> techApprovalRequestWOFlyBy = new List<Tech_Approval_Request__c>();
        if(!techApprovalRequest.isEmpty()){
        	for(Tech_Approval_Request__c techReq:techApprovalRequest){
        		if(!UtilConstantsR3.FLY_BY_SOL_REVIEW.equalsIgnoreCase(techReq.Approval_Stage__r.approval_stage_type__c)){
	     			techApprovalRequestWOFlyBy.add(techReq);
	     		}
        	}
        	system.debug('techApprovalRequestWOFlyBy list size'+techApprovalRequestWOFlyBy.size());
        	if(!techApprovalRequestWOFlyBy.isEmpty()){
        		for(Tech_Approval_Request__c techReq:techApprovalRequestWOFlyBy){
        			if(appreqDateMap.get(techReq.Approval_Stage__r.Opportunity__c)==null){
        			appreqDateMap.put(techReq.Approval_Stage__r.Opportunity__c,techReq.Approval_Stage_Created_Date__c);
        			scoremap.put(techReq.Approval_Stage__r.Opportunity__c,techReq.Tech_Solution_Deck_Score__c);
        			system.debug('techReq.Approval_Stage__r.Opportunity__c,techReq.Tech_Solution_Deck_Score__c'+techReq.Approval_Stage__r.Opportunity__c+techReq.Tech_Solution_Deck_Score__c);
        			}
        			else{
        				if(appreqDateMap.get(techReq.Approval_Stage__r.Opportunity__c)>techReq.Approval_Stage_Created_Date__c){
        					scoremap.put(techReq.Approval_Stage__r.Opportunity__c,techReq.Tech_Solution_Deck_Score__c);
        					system.debug('techReq.Approval_Stage__r.Opportunity__c,techReq.Tech_Solution_Deck_Score__c'+techReq.Approval_Stage__r.Opportunity__c+techReq.Tech_Solution_Deck_Score__c);
        				}
        			}
        		}
        	}
        	else{
        		 //appreqDateMap.clear();
        		 system.debug('techApprovalRequest list size in else part'+techApprovalRequest.size());
        		 system.debug('techApprovalRequest list size in else part'+techApprovalRequest.size());
        		for(Tech_Approval_Request__c techReq:techApprovalRequest){
        			if(appreqDateMap.get(techReq.Approval_Stage__r.Opportunity__c)==null){
        			appreqDateMap.put(techReq.Approval_Stage__r.Opportunity__c,techReq.Approval_Stage_Created_Date__c);
        			scoremap.put(techReq.Approval_Stage__r.Opportunity__c,techReq.Tech_Solution_Deck_Score__c);
        			system.debug('flybytechReq.Approval_Stage__r.Opportunity__c,techReq.Tech_Solution_Deck_Score__c'+techReq.Approval_Stage__r.Opportunity__c+techReq.Tech_Solution_Deck_Score__c);
        			}
        			else{
        				if(appreqDateMap.get(techReq.Approval_Stage__r.Opportunity__c)>techReq.Approval_Stage_Created_Date__c){
        					scoremap.put(techReq.Approval_Stage__r.Opportunity__c,techReq.Tech_Solution_Deck_Score__c);
        					system.debug('flybytechReq.Approval_Stage__r.Opportunity__c,techReq.Tech_Solution_Deck_Score__c'+techReq.Approval_Stage__r.Opportunity__c+techReq.Tech_Solution_Deck_Score__c);
        				}
        			}
        		}
        	}
        	//system.debug('scoremap.values.size()'+scoremap.values.size());
        	for(Opportunity oppRec:[select id,Tech_Solution_Deck_Score__c from opportunity where id in:opportunityId]){
        		if(scoremap.get(oppRec.id)!=null){
        			system.debug('scoremap.get(oppRec.id)'+scoremap.get(oppRec.id));
        			oppRec.Tech_Solution_Deck_Score__c=scoremap.get(oppRec.id);
        			opportunityRecToUpdate.add(oppRec);
        		}
        	}
        	system.debug('flybytechReqopportunityRecToUpdate list size'+opportunityRecToUpdate.size());
        	if(!opportunityRecToUpdate.isEmpty()){
        		try{
        			database.update(opportunityRecToUpdate,false);
        		}
        		catch(Exception e){
        			
        		}
        	}
        }
     }
}