/**
   @Author :Apoorva Sharma
   @name   : TechApprovalProcess 
   @CreateDate : 27 November 2015 
   @Description : This class performs action related to TechApproverSection VF page.
   @Version : 1.0 
  */
public with sharing class TechApproverSection {
    
        public boolean bool {get;set;}
        public boolean bool1 {get;set;}
        public boolean bool2 {get;set;}
        public boolean bool3 {get;set;}
        public boolean bool4 {get;set;}
        public Tech_Approval_Request__c req {get;set;} 
        public string approverid {get;set;}
        public string profileid{get;set;}
        public String requestorid{get;set;}
        public boolean match{get;set;}
        public boolean match2{get;set;}
        public string systemAdminprofileid;
        public string solutionoperationprofileid;
        
        /**
     * @description       init method.
     * @param             NA
     * @return            void
     * @throws            NA
     */  
        public void init(){
            Map<Id,Id> OpportunityTeam=new Map<id,Id>();
            String pageid =Apexpages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID);
            String errortype =Apexpages.currentPage().getParameters().get(UtilConstantsR3.typeurl);
            match=false;
            match2=false;
            if(errortype!=null){
            	if(errortype.EqualsIgnoreCase(UtilConstantsR3.finalS)){
            		match=true;
            	}
            	else{
            		match=false;
            	}
            	if(errortype.EqualsIgnoreCase(UtilConstantsR3.ArchLead)){
            		match2=true;
            	}
            	else{
            		match2=false;
            	}
            }
            req = [SELECT id,approver__c,approval_stage__c,approval_stage__r.opportunity__r.Opportunity_Solution_Lead__c,response_received_date__c
                    ,comments_by_approver__c,approval_request_status__c,requestor__c,requestor__r.email__c,approval_request_type__c,
                    Approval_Stage__r.opportunity__c,approver__r.user__c,requestor__r.user__c,isRecalled__c,
                    Service_Group__c,RecordTypeId,Tech_Solution_Deck_Score__c from Tech_Approval_Request__c where Id =: pageId LIMIT 1];

            List<Opportunity_Teams__c> opteamember=[Select id,Opportunity_Team_Member__r.user__c from Opportunity_Teams__c 
                                                    where Opportunity__c=:req.Approval_Stage__r.opportunity__c  LIMIT 5000];
                                                    
            if(req!=null){
            	if(UtilConstantsR3.Arch_Lead_Approval.equalsIgnoreCase(req.approval_request_type__c)){
            		bool3=true;
            	}
            	else{
            		bool3=false;
            	}
            }
            for(Opportunity_Teams__c oteam:opteamember){
                OpportunityTeam.put(oteam.Opportunity_Team_Member__r.user__c,oteam.id);
            }
            profileid=userInfo.getProfileId();
            approverid=req.approver__r.user__c;
            requestorid=req.requestor__r.user__c;
            if(approverid.Equals(userinfo.getUserId())||(profileid.Equals(UtilConstantsforSWB.utilmethod(Label.System_Admin_Profile)))||
                (profileid.Equals(UtilConstantsforSWB.utilmethod(Label.Solution_Operations_Profile_Name)))){
                    bool=true;
            }
            else{
                bool=false;
            } 
            if(requestorid.Equals(userinfo.getUserId())||(profileid.Equals(UtilConstantsforSWB.utilmethod(Label.System_Admin_Profile)))||
                (profileid.Equals(UtilConstantsforSWB.utilmethod(Label.Solution_Operations_Profile_Name)))){
                bool1=true;
            }
            else{
                bool1=false;
            }
            if(opteamember!=null){
                if(requestorid.Equals(userinfo.getUserId())|| OpportunityTeam.containsKey(userinfo.getUserId())||
                    (profileid.Equals(UtilConstantsforSWB.utilmethod(Label.Solution_Operations_Profile_Name)))){
                    bool2=true;
                }
                else{
                    bool2=false;
                }
            }
        else{
            bool2=bool1;
        }
        
        if(bool && bool3){
        	bool4=true;
        }
        else{
        	bool4=false;
        }
    }
    
    /**
     * @description       Initialization.
     * @param             NA
     * @return            NA
     * @throws            NA
     */  
    public TechApproverSection(ApexPages.StandardController controller) {
        init();
    }
    
    /**
     * @description       Saves the record when approver takes an action.
     * @param             NA
     * @return            PageReference
     * @throws            NA
     */ 
     public  PageReference saveData()  {
        PageReference pageRef;
        try{
            map<string,Id> recordTypeMap = new map<string,Id>();
            list<RecordType> recTypes = [Select Id, Name From RecordType Where sObjectType = :UtilConstantsR3.APPR_REQ
                                            and isActive = true LIMIT 5000];
            for(RecordType r:recTypes){
                recordTypeMap.put(r.Name, r.Id);
            }
            if (req.Service_Group__c.equals(UtilConstants.BPO))
            {           
                if(req.approval_request_status__c.equals(UTILConstants.APPROVED_STATUS)){
                system.debug('Approved'+recordTypeMap.get(UTILConstants.APPROVED_STATUS));
                    req.RecordTypeId = recordTypeMap.get(UTILConstants.APPROVED_STATUS);
                system.debug('Approved 123'+recordTypeMap.get(UTILConstants.APPROVED_STATUS));
            }
                else{
                    req.RecordTypeId = recordTypeMap.get(UTILConstants.PRIOR);
                }
            }
            req.response_received_date__c=date.today();
            if(req.approval_request_status__c!=UtilConstants.PEND_WITH_APPR2){
                system.debug('req.RecordTypeId-----------  '+req.RecordTypeId);
                update(req);     
            }
            Tech_Approval_Request__c app = [select id,name, recordtypeid from Tech_Approval_Request__c where id=:req.id LIMIT 5000];
            pageRef = new pagereference(UTILConstants.SLASH+ApexPages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID)); 
            pageRef.setRedirect(true);        
        }
        catch(Exception e)
        {   
           system.debug('e.message----------------------------->'+e.getmessage());
        	if(!e.getMessage().contains(UtilConstantsR3.FIELD_CUSTOM_VALIDATION_EXCEPTION)){
            	pageRef=new pagereference(UtilConstantsR3.TechApprovalErrorPageURL+req.Id+UtilConstantsR3.typeFinal);
        	}
        	else{
        		pageRef=new pagereference(UtilConstantsR3.TechApprovalErrorPageURL+req.Id+UtilConstantsR3.typeArchlead);
        	}
            pageRef.setRedirect(true);   
        }

        return pageRef;
        }
        
        /**
     * @description       Recalls the request from approver.
     * @param             NA
     * @return            PageReference
     * @throws            NA
     */ 
        public PageReference recallRequest(){
               map<string,Id> recordTypeMap = new map<string,Id>();
               list<RecordType> recTypes = [Select Id, Name From RecordType Where sObjectType = :UtilConstantsR3.APPR_REQ
                                            and isActive = true LIMIT 5000];
                for(RecordType r:recTypes){
                    recordTypeMap.put(r.Name, r.Id);
                }
               try{
                    req.approval_request_status__c = UtilConstants.PEND_WITH_REQSTR2;
                    req.RecordTypeId = recordTypeMap.get(UTILConstants.PRIOR);
                    req.isRecalled__c=true;
                    update req;
               }
               catch(Exception e){
                system.debug('Exception-------------------------------------------------->'+e);
               }
               String approverid=UtilUser.UtilUser(req.approver__c);
               String orgWideEmailAddressID=UtilEmail.emailid();
               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
               mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
               List<String> CCAddresses = new List<String>();
               id emailtempid = [select id from emailtemplate where developername=:UtilConstantsR3.Recall_Tech_Approval_Request limit 1].id;
               string myCCval = emailtempid;
               CCAddresses.add(UserInfo.getUserEmail());
               if(req.Service_Group__c.equals(UtilConstants.BPO) && req.approval_stage__r.opportunity__r.Opportunity_Solution_Lead__c!=null){
                   // CCAddresses.add(req.approval_stage__r.opportunity__r.Opportunity_Solution_Lead__c);
                   List<User_MAster__c> oslemail=[SELECT Id, email__c FROM User_Master__c where 
                                                  id=:req.approval_stage__r.opportunity__r.Opportunity_Solution_Lead__c limit 1];
                   CCAddresses.add(oslemail[0].email__c);
               }
               //CCAddresses.add(req.requestor__r.email__c);
               system.debug('CCAddresses'+CCAddresses);
               mail.setCcAddresses(CCAddresses);
               mail.setTargetObjectId(approverid) ;
               mail.setWhatId(req.id) ;
               mail.setTemplateId(myCCval);
               mail.saveAsActivity=false;                      
              if(!Test.IsRunningTest()){                     
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
              }
               PageReference pageRef = new PageReference(UtilConstants.SLASH+req.Id);
               return pageRef;
   }
   
   /**
     * @description       Send Reminder to  the request from approver.
     * @param             NA
     * @return            PageReference
     * @throws            NA
     */ 
   public PageReference sendReminder(){
        PageReference pageRef;
        if(req.approval_request_status__c.EqualsIgnoreCase(UtilConstants.PEND_WITH_APPR2)){
              pageRef = new PageReference('https://accentureopsworkbench--r3qa.cs42.my.salesforce.com/apex/TechApprovalProcessOpportunityDocument?id='+req.Approval_Stage__r.opportunity__c+'&stgId='+req.approval_stage__c+UtilConstants.VFURL_APPND+req.Id);
         }
         else{
             pageRef =null;
         }
   
                        pageRef.setRedirect(true);
                        return pageRef;
   }
   
   /**
     * @description       GO Back TO Opprtunity.
     * @param             NA
     * @return            PageReference
     * @throws            NA
     */ 
  public pagereference GoTOOpportunity(){
        String pageid =Apexpages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID);
        pagereference pageRef;
        pageRef=new PageReference(UtilConstants.SLASH+pageid);        
        pageRef.setRedirect(true);
        return pageRef;
    }
}