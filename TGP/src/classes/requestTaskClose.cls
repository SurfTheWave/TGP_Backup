/*
@Author :  
@name : requestTaskClose
@CreateDate :  1/8/2015 12:14 AM
@Description : 
@Version : 
*/
public with sharing class requestTaskClose {
  
   public static Map<Id,Id> approverRequsetUserMap;
   public static Boolean isRecalled = false;
   
/*
@Author :  
@name : requestTaskClose
@CreateDate :  1/8/2015 12:14 AM
@Description : 
@Version : 
*/
   public static void requestTaskClose(List<approval_request__c> rlist){
   try{
    //System.Debug('****** in task close method entery'+ rlist);
       Set<Id> reqids = new Set<Id>();
       List<Task> taskstoupdate = new list<Task>();
         for( approval_request__c req : rlist){
           //System.Debug('******+ in task close method +*******'+req.approval_request_status__c);
              if((UtilConstants.REWORK1.Equals(req.approval_request_status__c) || 
                   UtilConstants.APPRVD.Equals(req.approval_request_status__c) ||
                   UtilConstants.REJ.Equals(req.approval_request_status__c) ||
                   UtilConstants.READYREV.Equals(req.approval_request_status__c))) {
                    reqids.add(req.id);
            //System.Debug('******+ ids for task +*******'+reqids);
                    }
            }
   //system.debug('task query!!!'+[SELECT Id, (SELECT Id, Whatid, status FROM Tasks) from approval_request__c Where Id in: reqids limit 5000]);
 for(approval_request__c req : [SELECT Id, (SELECT Id, Whatid, status FROM Tasks limit 5000) 
     from approval_request__c Where Id in: reqids Limit 5000]) {

        //System.Debug('******Task completion starts*******'+req.Tasks);

        for(Task t : req.Tasks) {

            t.status= UtilConstants.COMPLETED;

            taskstoupdate.add(t);
            }
    }
//System.debug('Task list----------->'+taskstoupdate);
    if(taskstoupdate.size()>0) {

        List<Database.saveResult> uresult = database.update (taskstoupdate,false);
       //System.Debug('******Task list updated *******');

    }
   
   
   
   }Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString();
          throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
                          //ApexPages.addMessage(myMsg);﻿
        }
   
   }
   
/*
@Author :  //Added by Jyotsna 
@name : requestTaskClose
@CreateDate :  1/8/2015 12:14 AM
@Description : 
@Version : 
*/
    public static void validateBeforeDelete( List<Approval_Request__c> approvalRequestList ){
        try{
        for( Approval_Request__c appRequestRec : approvalRequestList){
            if( UtilConstants.PEND_APPROV.equalsIgnoreCase(appRequestRec.approval_request_status__c) &&
                appRequestRec.approval_sent_date__c != null ){
                    appRequestRec.addError(UtilConstants.SRYAPPREQ);
            }
            
             if( UtilConstants.APPRVD.equalsIgnoreCase(appRequestRec.approval_request_status__c) && 
                 appRequestRec.approval_sent_date__c != null ){
                     appRequestRec.addError(UtilConstants.SRYAPPREQAPP);
            }            
        }
             //System.Debug('********ValidateBeforeDelete ends********');
            }Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString();
          throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
                          //ApexPages.addMessage(myMsg);﻿
        }
      }
      
/*
@Author :  
@name : requestTaskClose
@CreateDate :  1/8/2015 12:14 AM
@Description : 
@Version : 
*/
    public static void getApproverRequsetUserMap(List<Approval_Request__c> approvalRequestList){
        try{
       //System.Debug('***getApproverRequsetUserMap starts ********');
          approverRequsetUserMap = new Map<Id,Id>();
        for( Approval_Request__c appRequestRec : [ Select name,requestor__c,requestor__r.user__c 
            from Approval_Request__c where Id IN:approvalRequestList Limit 5000]){
                approverRequsetUserMap.put( appRequestRec.Id,appRequestRec.requestor__r.user__c );
        }
        //System.Debug('****getApproverRequsetUserMap ends ********');
        }Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString();
          throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
                          //ApexPages.addMessage(myMsg);﻿
        }
      }
   /* public static void validateBeforeEdit( Map<Id,Approval_Request__c> oldApprovalRequestMap,List<Approval_Request__c> newApprovalRequestList ){
      
       System.Debug('********validateBeforeEdit starts ********');
    
        //system.debug( '******'+approverRequsetUserMap );
        for( Approval_Request__c appRequestRec : newApprovalRequestList){
        system.debug(':::::::::'+appRequestRec.approval_request_status__c);
            system.debug('((((('+ appRequestRec.approval_sent_date__c != null );
            system.debug(':::::::::'+userinfo.getUserId()+approverRequsetUserMap.get( appRequestRec.Id ) );
            //system.debug('****'+userinfo.getProfileId()+ (userinfo.getProfileId().equalsignorecase(UtilConstantsforSWB.SolutionEditor)));
            if( !(isRecalled) && oldApprovalRequestMap.get(appRequestRec.Id).approval_request_status__c != null && oldApprovalRequestMap.get(appRequestRec.Id).approval_request_status__c.equalsIgnoreCase('Pending with Approver') && oldApprovalRequestMap.get(appRequestRec.Id).approval_sent_date__c != null && (userinfo.getUserId() == approverRequsetUserMap.get( appRequestRec.Id ) && userinfo.getProfileId().equalsignorecase(UtilConstantsforSWB.SolutionEditor))){
                appRequestRec.addError( 'Sorry !! Approval request is pending.It can not be edited.' );
            }
            if(oldApprovalRequestMap.get(appRequestRec.Id).approval_request_status__c.equalsIgnoreCase('Approved')){
            system.debug(':::::::::'+appRequestRec.approval_request_status__c);
            appRequestRec.addError('Sorry !! Approval Request is approved.It can not be edited');
            }
            
        }
        System.Debug('********validateBeforeEdit ends ********');

      }*/
    //Added by Jyotsna End
    
/*
@Author :  
@name : requestTaskClose
@CreateDate :  1/8/2015 12:14 AM
@Description : 
@Version : 
*/
    public static void sendMail(List<approval_request__c> rlist){
       //System.Debug('*******requestTaskClose sendMail starts ********');
        Map<id, string> OppName=new Map<id,string>();
        set<id> BPOteammbers=new set<id>();
        list<string> BPOemillist=new list<string>();
        List<String> ccAddresses ;
        List<String> toAddress;
    try{
        For( Approval_Request__c r : rlist){
            OppName.put(r.id,r.Opportunity_Id_Dev__c);
        }
       for(Opportunity_Teams__c Optm:[select Opportunity_Team_Member__c,Role__r.Name 
                                        from Opportunity_Teams__c where Role__r.Name =: UtilConstants.OPP_SOL_LEAD 
                                        AND Opportunity__c =:OppName.values()Limit 5000]){
                    BPOteammbers.add(Optm.Opportunity_Team_Member__c);
                 }
        if(!BPOteammbers.isEmpty()){
                for(User_Master__c urlist:[select User__r.Email from User_Master__c where id IN:BPOteammbers Limit 5000]){
                   BPOemillist.add(urlist.User__r.Email);
                   }
                    }

        List<Approval_Request__c>alist=[SELECT id,Opportunity__c,Service_Group__c,Opportunity_Id_Dev__c,
                                                    approval_request_status__c,
                                                                  approver__r.User__c, requestor__r.Email__c,
                                                                  approval_request_type__c FROM 
                                                                  approval_request__c where id in :rlist];
      for( Approval_Request__c appRequestRec : alist){
                   //system.debug('appRequestRec.approval_request_status__c'+appRequestRec.approval_request_status__c);
            if( appRequestRec.approval_request_status__c != null && 
                !appRequestRec.approval_request_status__c.equals(UtilConstants.PEND_WITH_APPR2) 
                && !appRequestRec.approval_request_status__c.equals(UtilConstants.PEND_REQ)){
                        /*Email_Template__c myCS1 = Email_Template__c.getValues('Post Approval Response Recorded');
                        String myCCVal = myCS1.ID__c; */
                id emailtempid = [select id from emailtemplate where developername=:label.post_approval_template limit 1].id;
                string myCCval = emailtempid;
                       String orgWideEmailAddressID=UtilEmail.emailid();
                    
                        String Approverid=UtilUser.UtilUser(appRequestRec.approver__c);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        //List<String> ccAddresses = new List<String>();
                        ccAddresses = new List<String>();
                        //toAddress= new List<String>();
                if(appRequestRec.Requestor__r.email__c!=null){
                        ccAddresses.add(appRequestRec.Requestor__r.email__c);
                    //system.debug('toAddress'+toAddress);
                }
                        for(string st:BPOemillist){
                                        ccAddresses.add(st);
                                      }
                       //System.debug('++++'+ ccAddresses);
                       //System.debug('++++appRequestRec.Requestor__r.Email__c'+ appRequestRec.Requestor__r.Email__c);                    
                        
                        mail.setCCAddresses(ccAddresses);
                        //mail.setToAddresses(toAddress);
                        mail.setWhatId(appRequestRec.id) ;
                        mail.setTargetObjectId(Approverid) ;
                        mail.setTemplateId(myCCVal); 
                        mail.saveAsActivity=false;                       
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });       
                
            }
            //System.Debug('*****requestTaskClose sendMail ends ********');

          }
         }Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString();
          throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
                          //ApexPages.addMessage(myMsg);﻿
        }
     } 

/*
@Author :  
@name : requestTaskClose
@CreateDate :  1/8/2015 12:14 AM
@Description : 
@Version : 
*/
    public static void sendEmailToApprover(List<Approval_Request__c> approvalRequestList){
        set<Id> approvalStageId = new Set<Id>();
        try{
        for(Approval_Request__c appRequest:approvalRequestList){
            approvalStageId.add(appRequest.approval_stage__c);
        }
        for(Approval_stage__c approvalStage:[select id,(select id,approval_stage__r.opportunity__r.IC_Solution_Architect__c,name,approval_stage__r.opportunity__r.IO_Solution_Architect__c,approval_request_status__c,approval_request_type__c,approval_stage__r.approval_stage_status__c,approval_stage__r.of_Approval_Request_IC_IO1__c,approval_stage__r.of_Approval_Request_BPO_IC__c,Service_Group__c,approval_stage__r.of_Approval_Request_IO__c,approval_stage__r.of_approval_request__c,approval_stage__r.of_Approval_Request_IC__c,
           approver__r.user__c,approval_stage__r.opportunity__r.Opportunity_Solution_Lead__c,approval_stage__r.opportunity__r.BPO_opportunity__c,approval_stage__r.opportunity__r.IO_opportunity__c,approval_stage__r.of_Approval_Request_BPO_IC_IO1__c,approval_stage__r.opportunity__r.IC_opportunity__c,approval_stage__r.opportunity__r.Service_Grp__c,Requestor__r.email__c from Approval_Request__r limit 5000), of_Approval_Request_IO__c,of_approval_request__c,of_Approval_Request_IC__c from Approval_stage__c WHERE ID IN:approvalStageId Limit 5000]){
            List<Approval_Request__c> appreq = approvalStage.approval_request__r;
            Integer approvalsize=appreq.size();
            //system.debug('approval req size:::::'+approvalsize);
            Boolean alpha=false;
            Boolean alphaIo=false;
            Boolean alphaIc=false; 
            Boolean alphaOps=false;  
            Boolean beta=false;
            Boolean betaIo=false;
            Boolean betaIc=false;
            Boolean betaOps=false;
            Boolean bpo=false;
            String userLookup =UtilConstants.BLANK_SPACE;
            String SAIO=UtilConstants.BLANK_SPACE;
            String SAIC=UtilConstants.BLANK_SPACE;
            
               
            
            String requestoruserLookup=UtilConstants.BLANK_SPACE;
            String OSL=UtilConstants.BLANK_SPACE;
            Id approavlId;
            String userLookupIo =UtilConstants.BLANK_SPACE;
            String requestoruserLookupIo=UtilConstants.BLANK_SPACE;            
            Id approavlIdIo;
            String userLookupIc =UtilConstants.BLANK_SPACE;
            String requestoruserLookupIc=UtilConstants.BLANK_SPACE;            
            Id approavlIdIc;
            String userLookupOps =UtilConstants.BLANK_SPACE;
            String requestoruserLookupOps=UtilConstants.BLANK_SPACE;            
            Id approavlIdOps;
            
            for(Approval_Request__c app:approvalStage.Approval_Request__r){
                
                OSL=app.approval_stage__r.opportunity__r.Opportunity_Solution_Lead__c;
                //System.debug(' OSL is +++++++++' +OSL);
                //system.debug('I am in for loop');
                if((app.approval_request_type__c).equals(UtilConstants.FIN_APPRBPO) && ((app.approval_stage__r.opportunity__r.BPO_opportunity__c)==(UtilConstants.BOOLEAN_TRUE) ) && (app.approval_stage__r.of_approval_request__c==1) && (app.approval_request_status__c == UtilConstants.PEND_WITH_APPR2))
                {
                //system.debug('I am in with beta');                     
                    beta=true;
                    //system.debug('Beta BPO TRUE');
                userLookup=app.approver__r.user__c;
                system.debug('I am in userLookup'+userLookup);
                requestoruserLookup=app.Requestor__r.email__c;
                //requestoruserLookup='diwanshu.setia@accenture.com';
                //system.debug('I am in requestoruserLookup'+requestoruserLookup);
                approavlId=app.id; 
                }
                if((app.approval_request_type__c).equals(UtilConstants.FIN_APPRIO) && ((app.approval_stage__r.opportunity__r.IO_opportunity__c)==(UtilConstants.BOOLEAN_TRUE)) && (app.approval_stage__r.of_Approval_Request_IO__c==1) && (app.approval_request_status__c == UtilConstants.PEND_WITH_APPR2))
                {
                //system.debug('I am in with betaIo');
                    betaIo=true;
                    //system.debug('Beta IO TRUE');
                userLookupIo=app.approver__r.user__c;
                //system.debug('I am in userLookupIo'+userLookupIo);
                requestoruserLookupIo=app.Requestor__r.email__c;
                //requestoruserLookupIo='diwanshu.setia@accenture.com';
                //system.debug('I am in requestoruserLookupIo'+requestoruserLookupIo);
                 approavlIdIo=app.id; 
                }
                if((app.approval_request_type__c).equals(UtilConstants.FIN_APPRIC) && ((app.approval_stage__r.opportunity__r.IC_opportunity__c)==(UtilConstants.BOOLEAN_TRUE)) && (app.approval_stage__r.of_Approval_Request_IC__c==1) && (app.approval_request_status__c == UtilConstants.PEND_WITH_APPR2))
                {
                //system.debug('I am in with betaIc');
                    betaIc=true;
                    //system.debug('Beta IC TRUE');
                userLookupIc=app.approver__r.user__c;
                //system.debug('I am in userLookupIc'+userLookupIc);
                requestoruserLookupIc=app.Requestor__r.email__c;
               // requestoruserLookupIc='diwanshu.setia@accenture.com';
                
                //system.debug('I am in requestoruserLookupIc'+requestoruserLookupIc);
                approavlIdIc=app.id; 
                }
                //system.debug('BPO APprovals'+app.approval_stage__r.of_Approval_Request_BPO_IC__c);
                //system.debug('IO Approvals'+app.approval_stage__r.of_Approval_Request_IC_IO1__c);
                //system.debug('Ops Approvals'+app.approval_request_type__c);
                //system.debug('Status'+app.approval_request_status__c);
                //system.debug('beta'+beta);
                //system.debug('beta'+betaIo);
                //system.debug('Stage status +++++++++'+app.approval_stage__r.approval_stage_status__c);
                
                if((app.approval_request_type__c).equals(UtilConstants.FIN_APPRIO) && app.approval_stage__r.of_Approval_Request_BPO_IC__c == 1 && app.approval_stage__r.opportunity__r.IO_Opportunity__c && app.approval_stage__r.opportunity__r.BPO_Opportunity__c ||
                
                (app.approval_request_type__c).equals(UtilConstants.FIN_APPRBPO) && app.approval_stage__r.of_Approval_Request_IC_IO1__c == 1  && app.approval_stage__r.opportunity__r.IO_Opportunity__c  && app.approval_stage__r.opportunity__r.BPO_Opportunity__c )
                {
                //system.debug('i am inside with bpo true');
                bpo=true;
                //system.debug('i am inside with bpo true'+bpo);
                }
              //system.debug('i am inside with bpo true'+bpo);
              if(bpo && (UtilConstants.FIN_APPROPP).equals(app.approval_request_type__c) && 
              ((UtilConstants.PENDING_STATUS.equals(app.approval_request_status__c)) || 
              (UtilConstants.READYREV.equals(app.approval_request_status__c))))
                {
                
                //system.debug('I am in with betaOps');                     
                    betaOps=true;
                    //system.debug('Beta betaOps TRUE');
                userLookupOps=app.approver__r.user__c;
                //system.debug('I am in userLookup'+userLookup);
                //requestoruserLookup=app.Requestor__r.email__c;
                requestoruserLookupOps=app.Requestor__r.email__c;
                //system.debug('I am in requestoruserLookup'+requestoruserLookupOps);
                approavlIdOps=app.id; 
                }
                
              /*  userLookup=app.approver__r.user__c;
                requestoruserLookup=app.Requestor__r.email__c;
                approavlId=app.id; */
                
               //OSL=app.approval_stage__r.opportunity__r.Opportunity_Solution_Lead__c;
              // OSL='a0Qc00000029kx4';
              OSL=app.approval_stage__r.opportunity__r.Opportunity_Solution_Lead__c;
               SAIO=app.approval_stage__r.opportunity__r.IO_Solution_Architect__c;
               SAIC=app.approval_stage__r.opportunity__r.IC_Solution_Architect__c;
               //OSL='a0Qc00000029kx4';
                //System.debug(' OSL is +++++++++' +OSL);  
                
            }
            if(beta){
              
                //system.debug('I am inside beta');
                for(Integer i=0;i<approvalsize;i++)
                {
                //system.debug('I am inside for loop 1');
                  if((!UtilConstants.FIN_APPRBPO.equals(appreq[i].approval_request_type__c))) 
                   {
                    //system.debug('I am inside final BPO');
                      if((UtilConstants.APPRVD.EqualsIgnoreCase(appreq[i].approval_request_status__c)) 
                          && (UtilConstants.BPO.EqualsIgnoreCase(appreq[i].Service_Group__c))){
                       
                       //if((appreq[i].approval_stage__r.of_Approval_Request_IO__c == 0))
                            alpha=true;
                            //System.Debug( 'Alpha Set true BPO+++++++++');
                       } /*else if (appreq[i].Service_Group__c.EqualsIgnoreCase(UtilConstants.BPO)){
                            alpha=false;
                            System.Debug( 'Alpha Set false BPO +++++++++');
                            break;
                        }*/
                   }
                   }    
            }
            
             if(betaIo){
            //system.debug('I am inside betaIo');
                for(Integer i=0;i<approvalsize;i++)
                {
                //system.debug('I am inside for loop 2');
                  if((!UtilConstants.FIN_APPRIO.equals(appreq[i].approval_request_type__c))) 
                   {
                   // system.debug('I am inside final IO');
                       if((UtilConstants.APPRVD.EqualsIgnoreCase(appreq[i].approval_request_status__c)) && 
                       (UtilConstants.IO.EqualsIgnoreCase(appreq[i].Service_Group__c))){
                       
                       //if((appreq[i].approval_stage__r.of_Approval_Request_IO__c == 0))
                            alphaIo=true;                            
                           // System.Debug( 'Alpha Set true IO+++++++++');
                       } /*else if (appreq[i].Service_Group__c.EqualsIgnoreCase(UtilConstants.IO)){
                            alphaIo=false;
                            System.Debug( 'Alpha Set false IO +++++++++');
                            break;
                        }*/
                   }
                   }
                   }
                   if(betaIc){
            //system.debug('I am inside betaIc');
                for(Integer i=0;i<approvalsize;i++)
                {
                //system.debug('I am inside for loop 3');
                  if((!(UtilConstants.FIN_APPRIC).equals(appreq[i].approval_request_type__c))) 
                   {
                    //system.debug('I am inside final IC');
                       if((UtilConstants.APPRVD.EqualsIgnoreCase(appreq[i].approval_request_status__c)) && 
                       (UtilConstants.IC.EqualsIgnoreCase(appreq[i].Service_Group__c))){
                      
                       //if((appreq[i].approval_stage__r.of_Approval_Request_IO__c == 0))
                            alphaIc=true;
                           // System.Debug( 'Alpha Set true IC+++++++++');
                       } /*else if (appreq[i].Service_Group__c.EqualsIgnoreCase(UtilConstants.IC)){
                            alphaIc=false;
                            System.Debug( 'Alpha Set false IC +++++++++');
                            break;
                        }*/
                   }
                   }
                   }
                   if(betaOps){
            //system.debug('I am inside betaOps');
                for(Integer i=0;i<approvalsize;i++)
                {
                //system.debug('I am inside for loop 2 Ops');
                  if((!UtilConstants.FIN_APPROPP.equals(appreq[i].approval_request_type__c))) 
                   {
                    //system.debug('I am inside final Ops');
                       if((UtilConstants.APPRVD.EqualsIgnoreCase(appreq[i].approval_request_status__c)) && ((UtilConstants.IO.EqualsIgnoreCase(appreq[i].Service_Group__c)) || (UtilConstants.BPO.EqualsIgnoreCase(appreq[i].Service_Group__c)) )){
                      
                       //if((appreq[i].approval_stage__r.of_Approval_Request_IO__c == 0))
                            alphaOps=true;
                           // System.Debug( 'Alpha Set true ops+++++++++');
                       }/* else if((appreq[i].approval_request_type__c).equals(UtilConstants.FIN_APPROPP)){
                            alphaOps=false;
                            System.Debug( 'Alpha Set false Ops +++++++++');
                            break;
                        }*/
                   }
                    
                   }
                   }
            
            if(alpha){
               
                        
                  //system.debug('I am inside alpha');
                 Email_Template__c myCS1 = Email_Template__c.getValues(UtilConstantsforSWB.FinalApprovalBPO);
                 String myCCVal = myCS1.ID__c;
                 String orgWideEmailAddressID=UtilEmail.emailid();
                 //system.debug('orgWideEmailAddressID+++++++++'+orgWideEmailAddressID);
                 List<User_MAster__c> userOSL = [SELECT Id, email__c FROM User_Master__c where 
                                          id =:OSL limit 1];
                   //system.debug('userOSL+++++++++'+userOSL);
                 //String Approverid=UtilUser.UtilUser(appRequestRec.approver__c);
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                 mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                mail.setWhatId(approavlId) ;
                mail.setTargetObjectId(userLookup);
                List<String> CCAddresses = new List<String>();
                if(!userOSL.isEmpty()){
                CCAddresses.add(userOSL[0].email__c);
                }
                CCAddresses.add(requestoruserLookup);
                mail.setCcAddresses(CCAddresses);
                        //mail.setccAddress();
                        mail.setTemplateId(myCCVal); 
                        mail.saveAsActivity=false;                       
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
                }
                if(alphaIo){
          
            
                 //system.debug('I am inside alpha');
                 Email_Template__c myCS1 = Email_Template__c.getValues(UtilConstantsforSWB.FinalApprovalIO);
                 String myCCVal = myCS1.ID__c;
                 String orgWideEmailAddressID=UtilEmail.emailid();
                 List<User_MAster__c> userOSL = [SELECT Id, email__c FROM User_Master__c where 
                                          id =:OSL];
                 //String Approverid=UtilUser.UtilUser(appRequestRec.approver__c);
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                 mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                mail.setWhatId(approavlIdIo) ;
                        mail.setTargetObjectId(userLookupIo);
                List<String> CCAddresses = new List<String>();
                if(!userOSL.isEmpty()){
                CCAddresses.add(userOSL[0].email__c);
                }
                CCAddresses.add(requestoruserLookupIo);
                mail.setCcAddresses(CCAddresses);
                        //mail.setccAddress();
                        mail.setTemplateId(myCCVal); 
                        mail.saveAsActivity=false;                       
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
                        } 
             if(alphaIc){                     
                 //system.debug('I am inside alpha');
                 Email_Template__c myCS1 = Email_Template__c.getValues(UtilConstantsforSWB.FinalApprovalIC);
                 String myCCVal = myCS1.ID__c;
                 String orgWideEmailAddressID=UtilEmail.emailid();
                 List<User_MAster__c> userOSL = [SELECT Id, email__c FROM User_Master__c where 
                                          id =:OSL limit 1];
                 //String Approverid=UtilUser.UtilUser(appRequestRec.approver__c);
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                 mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                mail.setWhatId(approavlIdIc) ;
                        mail.setTargetObjectId(userLookupIc);
                List<String> CCAddresses = new List<String>();
                if(!userOSL.isEmpty()){
                CCAddresses.add(userOSL[0].email__c);
                }
                CCAddresses.add(requestoruserLookupIc);
                mail.setCcAddresses(CCAddresses);
                        //mail.setccAddress();
                        mail.setTemplateId(myCCVal); 
                        mail.saveAsActivity=false;                       
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
                        } 
            if(alphaOps){             
          // system.debug('I am inside alphaOps');
                 Email_Template__c myCS1 = Email_Template__c.getValues(UtilConstantsforSWB.FinalApprovalOps);
                 String myCCVal = myCS1.ID__c;
                 String orgWideEmailAddressID=UtilEmail.emailid();
                // system.debug('orgWideEmailAddressID+++++++++'+orgWideEmailAddressID);
                 
                 List<User_MAster__c> userOSL = [SELECT Id, email__c FROM User_Master__c where 
                                          id =:OSL limit 1];
                  // system.debug('userOSL+++++++++'+userOSL);
                   List<User_MAster__c> userSAIO = [SELECT Id, email__c FROM User_Master__c where 
                                          id =:SAIO limit 1];                 
                 //String Approverid=UtilUser.UtilUser(appRequestRec.approver__c);
                             
                 //String Approverid=UtilUser.UtilUser(appRequestRec.approver__c);
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                 mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                mail.setWhatId(approavlIdOps) ;
                mail.setTargetObjectId(userLookupOps);
                List<String> CCAddresses = new List<String>(); 
                if(!userOSL.isEmpty()){
                CCAddresses.add(userOSL[0].email__c);
                }   
                 if(!userSAIO.isEmpty()){
                CCAddresses.add(userSAIO[0].email__c);
                }  
                            
                CCAddresses.add(requestoruserLookupOps);
                mail.setCcAddresses(CCAddresses);
                        //mail.setccAddress();
                        mail.setTemplateId(myCCVal); 
                        mail.saveAsActivity=false;                       
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
                        } 
            
            
        }
        }Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString();
          throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
                          //ApexPages.addMessage(myMsg);﻿
        }
        
    }
    
     /**
     * @description       This method is used to update Operational Approval dev at Opportunity Level.
     * @param             list<Approval_Request__c > requestlist
     * @return            Void
     * @throws            dml exception
     */  
     public static void updateOperationalApprovalDate(list<Approval_Request__c > requestlist){
     	Set<id> opportunityId=new set<id>();
     	map<id,datetime>appreqDateMap=new map<id,datetime>();
     	map<id,string>appreqStatus=new map<id,string>();
     	for(Approval_Request__c techReq:requestlist){
     		//if(UtilConstantsR3.approved.equalsIgnoreCase(techReq.approval_request_status__c) && 
     		 //  UtilConstantsR3.Arch_Lead_Approval.equalsIgnorecase(techReq.approval_request_type__c)){
     		   	opportunityId.add(techReq.Opportunity_Id_Dev__c);
     		//}
     	}
     	
     	List<Approval_Request__c> ApprovalRequest=[SELECT id,Approval_Stage__r.Opportunity__c,approval_request_status__c, Approval_Stage_Created_Date__c,approval_request_type__c,
     										           Approval_Stage__r.approval_stage_type__c,Approval_Stage__c from Approval_Request__c where Approval_Stage__r.Opportunity__c in:opportunityId and approval_request_type__c='Tech for Ops Approval'
     														and (approval_request_status__c=:UtilConstants.APPROVED_STATUS or approval_request_status__c=:UtilConstants.PENDING_STATUS) and (Approval_Stage__r.approval_stage_type__c=:UtilConstants.STAGE2_SOL_APPROVAL or
     														Approval_Stage__r.approval_stage_type__c=:UtilConstants.STAGE3_SOL_APPROVAL)
     														order by Approval_Stage_Created_Date__c asc
     														limit 5000];
     	List<Opportunity> opportunityRecToUpdate=new List<Opportunity>();
        Opportunity oppRectoUpdate;
        List<Approval_Request__c> ApprovalRequestWOFlyBy = new List<Approval_Request__c>();
        if(!ApprovalRequest.isEmpty()){
        	for(Approval_Request__c appr:ApprovalRequest){
        		if(!appr.Approval_Stage__r.approval_stage_type__c.equalsIgnoreCase(UtilConstants.FLY_BY_SOL_REVIEW )){
        			ApprovalRequestWOFlyBy.add(appr);
        		}
        	}
        	
        }
        
        if(!ApprovalRequestWOFlyBy.isEmpty()){
        	for(Approval_Request__c appr:ApprovalRequest){
        		if(appreqDateMap.get(appr.Approval_Stage__r.Opportunity__c)==null){
        			appreqDateMap.put(appr.Approval_Stage__r.Opportunity__c,appr.Approval_Stage_Created_Date__c);
        			appreqStatus.put(appr.Approval_Stage__r.Opportunity__c,appr.approval_request_status__c);
        		}
        		else{
        			if(appreqDateMap.get(appr.Approval_Stage__r.Opportunity__c)>appr.Approval_Stage_Created_Date__c){
        				appreqDateMap.put(appr.Approval_Stage__r.Opportunity__c,appr.Approval_Stage_Created_Date__c);
        				appreqStatus.put(appr.Approval_Stage__r.Opportunity__c,appr.approval_request_status__c);
        			}
        		}
        	}
        	
        	for(Opportunity oppRec:[select id,Operational_Approval_Date_Dev__c from opportunity where id in:opportunityId]){
        		if(appreqDateMap.get(oppRec.id)!=null && appreqStatus.get(oppRec.id)!=null){
        			if(UtilConstants.PENDING_STATUS.equalsIgnoreCase(appreqStatus.get(oppRec.id))){
        				oppRec.Operational_Approval_Date_Dev__c=appreqDateMap.get(oppRec.id)+1;
        			}
        			if(UtilConstants.APPROVED_STATUS.equalsIgnoreCase(appreqStatus.get(oppRec.id))){
        				oppRec.Operational_Approval_ApprovedDev__c=true;
        			}
        			opportunityRecToUpdate.add(oppRec);
        		}
        	}
        }
        
        if(!opportunityRecToUpdate.isEmpty()){
        	try{
        		database.update(opportunityRecToUpdate,false);
        	}catch(Exception e){
        		
        	}
        }
     }
}