/******************
 * @class name : ApprovalSection
  
 * @description :
******************/
public  without sharing class ApprovalSection {
        public boolean bool {get;set;}
        public boolean bool1 {get;set;}
        public boolean bool2 {get;set;}
        public approval_request__c req {get;set;} 
        public string approverid {get;set;}
        public string profileid{get;set;}
        public String requestorid{get;set;}
        public boolean match{get;set;}
        public string systemAdminprofileid;
       // public Opportunity_Teams__c opteamember{get;set;} 
        public string solutionoperationprofileid;
/***************
 * @method :ApprovalSection
 * @description : Intialization 
 * @param :
***************/        
        public ApprovalSection(ApexPages.StandardController controller) {
            init();
        }
/***************
 * @method :ApprovalSection
 * @description :
 * @param : none 
 * @returntype : void
***************/    
        public void init(){
            Map<Id,Id> OpportunityTeam=new Map<id,Id>();
            String pageid =Apexpages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID);
            //system.debug(+ pageid);
            req = [SELECT id,approver__c,approval_stage__c,approval_stage__r.opportunity__r.Opportunity_Solution_Lead__c,response_received_date__c, opp_dev__c,comments_by_approver__c,approval_request_status__c,requestor__c,requestor__r.email__c,approval_request__c.approval_request_type__c,Service_Group__c,RecordTypeId from approval_request__c where Id =: pageId LIMIT 1];
            
            String approvaltype =Apexpages.currentPage().getParameters().get('type');
          match=false;
            if(approvaltype!=null){
           if(approvaltype.equalsIgnoreCase('BPO Final Approval') ||approvaltype.equalsIgnoreCase('IO Final Approval') ){
           match=true;
           }}
            
            List<Opportunity_Teams__c> opteamember=[Select id,Opportunity_Team_Member__r.user__c from Opportunity_Teams__c where Opportunity__c=:req.opp_dev__c  LIMIT 5000];
            for(Opportunity_Teams__c oteam:opteamember){
                OpportunityTeam.put(oteam.Opportunity_Team_Member__r.user__c,oteam.id);
            }
            //system.debug('88'+req);
            profileid=userInfo.getProfileId();
            approverid=UtilUser.UtilUser(req.approver__c);
            requestorid=UtilUser.UtilUser(req.requestor__c);
            if(approverid.Equals(userinfo.getUserId())||(profileid.Equals(UtilConstantsforSWB.utilmethod(Label.System_Admin_Profile)))||(profileid.Equals(UtilConstantsforSWB.utilmethod(Label.Solution_Operations_Profile_Name)))){
                bool=true;
            }
            else{
                bool=false;
                } 
            if(requestorid.Equals(userinfo.getUserId())||(profileid.Equals(UtilConstantsforSWB.utilmethod(Label.System_Admin_Profile)))||(profileid.Equals(UtilConstantsforSWB.utilmethod(Label.Solution_Operations_Profile_Name)))){
                bool1=true;
            }
            else{
                bool1=false;
            }
            if(opteamember!=null){
            if(requestorid.Equals(userinfo.getUserId())|| OpportunityTeam.containsKey(userinfo.getUserId())||(profileid.Equals(UtilConstantsforSWB.utilmethod(Label.Solution_Operations_Profile_Name)))){
                bool2=true;
            }
            else{
                bool2=false;
            }
            }
            else{
                bool2=bool1;
            }
        }
/***************
 * @method :saveData
 * @description :
 * @param : none
 * @returntype : PageReference
***************/       
    public  PageReference saveData()  {
         PageReference pageRef;
   try{
            map<string,Id> recordTypeMap = new map<string,Id>();
            list<RecordType> recTypes = [Select Id, Name From RecordType Where sObjectType = :UtilConstants.APPR_REQ
                                         and isActive = true LIMIT 5000];
            for(RecordType r:recTypes){
                recordTypeMap.put(r.Name, r.Id);
                //system.debug( '************'+ r.Name );
                //system.debug( '************'+ r.Id );
            }
   if (req.Service_Group__c.equals(UtilConstants.BPO))
   { 
       //system.debug('Prior/Post Approval'+recordTypeMap.get('Prior/Post Approval'));
       //system.debug('Prior/Post Approval'+req.approval_request_status__c);            
       if(req.approval_request_status__c.equals(UTILConstants.APPROVED_STATUS)){
           system.debug('Approved'+recordTypeMap.get('Approved'));
           req.RecordTypeId = recordTypeMap.get(UTILConstants.APPROVED_STATUS);
           system.debug('Approved 123'+recordTypeMap.get(UTILConstants.APPROVED_STATUS));
           
       }
     else{
           req.RecordTypeId = recordTypeMap.get(UTILConstants.PRIOR);
           //system.debug('Prior/Post Approval'+recordTypeMap.get('Prior/Post Approval'));
         
       }
       }
      else if (req.Service_Group__c.equals(UTILConstants.IO))
   {
       //system.debug('IO Prior/Post Approval'+recordTypeMap.get('IO Prior/Post Approval'));
       //system.debug('IO Prior/Post Approval'+req.approval_request_status__c);            
       if(req.approval_request_status__c.equals(UTILConstants.APPROVED_STATUS)){
           //system.debug('IO Approved'+recordTypeMap.get('IO Approved'));
           req.RecordTypeId = recordTypeMap.get(UtilConstants.IOAPPR);
       }
     else{
           req.RecordTypeId = recordTypeMap.get(UtilConstants.IOPRIOR);
           //system.debug('IO Prior/Post Approval'+recordTypeMap.get('IO Prior/Post Approval'));
         
       }
      }
      else{
      if (req.Service_Group__c.equals(UtilConstants.IC))

       {  
       
       if(req.approval_request_status__c.equals(UTILConstants.APPROVED_STATUS)){
           req.RecordTypeId = recordTypeMap.get(UtilCOnstants.ICAPPR);

       }
       
     else{
           req.RecordTypeId = recordTypeMap.get(UtilConstants.ICPRIOR);  

        }
       }
       }
       req.response_received_date__c=date.today();
       if(req.approval_request_status__c!=UtilConstants.PEND_WITH_APPR2){
           system.debug('req.RecordTypeId-----------  '+req.RecordTypeId);
     update(req);     
       }
       else{
       }
     approval_request__c app = [select id,name, recordtypeid from approval_request__c where id=:req.id LIMIT 5000];
        pageRef = new pagereference(UTILConstants.SLASH+ApexPages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID)); 
        pageRef.setRedirect(true);        
        //return pageRef;
      
    }
    catch(System.dmlException e)
   {   
       pageRef=new pagereference('/apex/ApprovalErrorPage?id='+req.Id+'&type='+req.approval_request_type__c);
       pageRef.setRedirect(true);   
       
   }
   
        return pageRef;
   }
    
 /***************
 * @method :GoTOOpportunity
 * @param : none
 * @description :
 * @returntype : PageReference
***************/ 
    public void ShowError(){
        String pageid =Apexpages.currentPage().getParameters().get('type');
        boolean match=false;
        if(pageid.equalsIgnoreCase('BPO Final Approval')){
            match=true;
        }
    }
    
 /***************
 * @method :GoTOOpportunity
 * @param : none
 * @description :
 * @returntype : PageReference
***************/ 
    public pagereference GoTOOpportunity(){
        String pageid =Apexpages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID);
        pagereference pageRef;
    pageRef=new PageReference('/'+pageid);        
        pageRef.setRedirect(true);
        return pageRef;
    }
/***************
 * @method :sendReminder
 * @param : none
 * @description :
 * @returntype : PageReference
***************/   
   public PageReference sendReminder(){
        PageReference pageRef;
        if(req.approval_request_status__c.EqualsIgnoreCase(UtilConstants.PEND_WITH_APPR2)){
              pageRef = new PageReference(UtilConstants.VFURL+req.opp_dev__c+'&stgId='+req.approval_stage__c+UtilConstants.VFURL_APPND+req.Id);
         }
         else{
             pageRef =null;
         }
   
                        pageRef.setRedirect(true);
                        return pageRef;
   }
/***************
 * @method :recallRequest
 * @param : none
 * @description :
 * @returntype : PageReference
***************/   
   public PageReference recallRequest(){
       Email_Template__c myCS1 = Email_Template__c.getValues(UtilConstants.RECALL_MAIL_BPO);
       String Cval=myCS1.ID__c;
       CreateApprovalDocument_VFC.updateRecall( req.Id );
       String approverid=UtilUser.UtilUser(req.approver__c);
       String orgWideEmailAddressID=UtilEmail.emailid();
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
       List<String> CCAddresses = new List<String>();

       CCAddresses.add(UserInfo.getUserEmail());
       if(req.Service_Group__c.equals(UtilConstants.BPO) && req.approval_stage__r.opportunity__r.Opportunity_Solution_Lead__c!=null){
           // CCAddresses.add(req.approval_stage__r.opportunity__r.Opportunity_Solution_Lead__c);
           List<User_MAster__c> oslemail=[SELECT Id, email__c FROM User_Master__c where 
                                          id=:req.approval_stage__r.opportunity__r.Opportunity_Solution_Lead__c limit 1];
           CCAddresses.add(oslemail[0].email__c);
       }
       //CCAddresses.add(req.requestor__r.email__c);
       //system.debug('CCAddresses'+CCAddresses);
       mail.setCcAddresses(CCAddresses);
       mail.setTargetObjectId(approverid) ;
       mail.setWhatId(req.id) ;
       mail.setTemplateId(Cval);
       mail.saveAsActivity=false;                      
if(!Test.IsRunningTest()){                     
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       }
       PageReference pageRef = new PageReference(UtilConstants.SLASH+req.Id);
       return pageRef;
   }
 }