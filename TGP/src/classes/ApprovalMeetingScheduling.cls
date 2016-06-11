/*****************
    @author : Ezdhan Hussain S.K
    @description : this class handles following functionalities for approval meeting sobject
    
    1) Creating approval meeting calendar
    2) submitting / Recalling approval meeting request
    *******************/
    global with sharing class ApprovalMeetingScheduling {
     
      @TestVisible private static boolean run = true;
        public static boolean runOnce(){
        if(run){
         run=false;
         return true;
        }else{
            return run;
        }
    }
        /*************
        @description : This method is invoked when user Recalls Meeting Request.
        @inputs : record id of Aprroval Meeting which is to be submitted
        @output : none
        @logic : updates meeting status to Recall and modifies recordtype to default record type***********/
        Webservice static void recallMeetingRequest(string recordid) {
         Approval_meeting__c meet_handler = new approval_meeting__c();
            meet_handler = [select id,Meeting_status__c,RecordTypeId,Override_Apvr_Suggestion__c from Approval_Meeting__c where id=:recordid limit 1];
            Id devRecordTypeId;
                    if(meet_handler.Override_Apvr_Suggestion__c == false){
                        devRecordTypeId = Schema.SObjectType.Approval_meeting__c.getRecordTypeInfosByName().get(Label.Meeting_Recalled_and_override_false).getRecordTypeId();
                    }
                    else{
                        devRecordTypeId = Schema.SObjectType.Approval_meeting__c.getRecordTypeInfosByName().get(Label.Meeting_Recalled_and_override_true).getRecordTypeId();
                    }
            meet_handler.Meeting_Status__c = Label.Approval_Meeting_Recalled;
            meet_handler.RecordTypeId = devRecordTypeId;
            //system.debug('Meeting recalled'+ meet_handler);
           database.SaveResult sresult = database.update(meet_handler,false);
            //system.debug('Update::: '+sresult);
        }
        /*************
        @description : This method is invoked when user initiates Meeting Request.
        @inputs : trigger.new,trigger.oldmap 
        @output : none
        @logic : sends emails based on meeting status and updates recordtypes,creates calendar events
        ***********/
        public void sendMailWhenSubmitted(List<approval_meeting__c> submittedMeetingList,Map<id,Approval_Meeting__c> oldmap) {
            List<String> mailList = new List<String>();
            List<String> uNames = new List<String>();
            List<String> operationsolids = new List<String>();
            list<string> ccaddresse_forsubmit_recall = new list<string>();
            string submittedtemplate = UtilConstants.EMPTY_STRING;
            string recalltemplate = UtilConstants.EMPTY_STRING;
            string scheduledtemplate = UtilConstants.EMPTY_STRING;
            string pendingtemplate = UtilConstants.EMPTY_STRING;
            string cancelledtemplate = UtilConstants.EMPTY_STRING;
            list<Approval_Meeting__c> list_scheduledmeetings = new list<Approval_Meeting__c>();
            list<Approval_Meeting__c> list_updaterecordtypes = new list<Approval_Meeting__c>();
            list<Approval_Meeting__c> list_cancelledmeetings = new list<Approval_Meeting__c>();
            list<Messaging.SingleEmailMessage> finalmaillist = new list<Messaging.SingleEmailMessage>();
            list<Approval_Meeting__c>  attendeeschanged_app = new list<Approval_Meeting__c>();
            List<approval_meeting__c> appmailList = [Select id,Meeting_subject__c,attendees__c,Override_Apvr_Suggestion__c,Opportunity__c,SG__c,Service_Group__c,
                                                     Scheduled_Start__c,document_link__c,scheduled_meeting_time__c,Scheduled_End__c,Requestor__r.user__c,Opportunity_Solution_Lead__c,
                                                     Meeting_Status__c,Requestor__r.user__r.Email,Approval_Stage__r.opportunity__c,
                                                     Approval_Stage__r.opportunity__r.Opportunity_Solution_Lead__r.user__c,
                                                     Approval_Stage__r.opportunity__r.Opportunity_Solution_Lead__r.user__r.email ,
                                                     Approval_Stage__r.opportunity__r.name,Meeting_Approver__r.approver__r.user__r.email,
                                                     Client_Name__c,Meeting_Approver__r.name From approval_meeting__c where id In :submittedMeetingList LIMIT 2500];
            string groupname = '';
            if(appmailList.size()>0){
                for(approval_meeting__c a1 : appmailList) {
                        ccaddresse_forsubmit_recall.add(a1.Requestor__r.user__r.Email);                 
                    if(a1.Approval_Stage__r.opportunity__r.Opportunity_Solution_Lead__r.user__c !=null){
                        uNames.add(a1.Approval_Stage__r.opportunity__r.Opportunity_Solution_Lead__r.user__c);
                        ccaddresse_forsubmit_recall.add(a1.Approval_Stage__r.opportunity__r.Opportunity_Solution_Lead__r.user__r.email);
                    }
                    if(UtilConstants.BPO.equalsIgnorecase(a1.Service_Group__c) || UtilConstants.BUNDLD_BPO.equalsIgnorecase(a1.Service_Group__c)){
                        groupname = Label.Solution_Operations_Group;
                    }
                    else if(UtilConstants.IO.equalsIgnorecase(a1.Service_Group__c) || UtilConstants.BUNDLD_IO.equalsIgnorecase(a1.Service_Group__c)){
                        groupname= Label.IO_Operations_Group;
                    }
                    else{
                        groupname=Label.IC_Operations_Group;
                    }
                }
            }
         
            
            String userType = Schema.SObjectType.User.getKeyPrefix();
            Group g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name =:groupname LIMIT 5000];
            if(g.groupMembers.size()>0){
                for (GroupMember gm : g.groupMembers){
                 if (((String)gm.UserOrGroupId).startsWith(userType)){
                    unames.add(gm.userOrGroupId);
                     operationsolids.add(gm.userorGroupId);
                 }
                }
            }
            id op_id = operationsolids[0];
            operationsolids.remove(0);
            list<string> operationsemails = new list<string>();
            if(operationsolids.size()>0){
                List<User> queiredusers = [Select id,Email From User where id in:operationsolids AND isactive=:true LIMIT 5000];
                if(queiredusers.size()>0){
                    for(user uRec:queiredusers){
                    operationsemails.add(uRec.email);
                    }
                }
            }
            ////system.debug('operations emails ------ > '+operationsemails);
            List<User> queiredusers = [Select id,Email From User where id in:uNames AND isactive=:true LIMIT 5000];
            list<string> useremails = new list<string>();
            if(queiredusers.size()>0){
                for(User uRec : queiredusers){
                    useremails.add(uRec.email);
                }
            }
            //Querying the templates needed
            for(emailtemplate emt:[select id,name from emailtemplate where isactive=true AND DeveloperName LIKE:UtilConstants.APP_MEET LIMIT 10]){
                if(emt.name.equalsignorecase(Label.App_meeting_submitted_template)){
                    submittedtemplate = emt.id;
                    ////system.debug(' submitted template---- > '+submittedtemplate);
                }
                else if(emt.name.equalsignorecase(Label.App_meeting_recalled_template)){
                    recalltemplate = emt.id;
                    ////system.debug('Recall template---- > '+recalltemplate);
                }
                else if(emt.name.equalsignorecase(Label.App_meeting_scheduled_template)){
                    scheduledtemplate = emt.id;
                    ////system.debug('scheduled template---- > '+scheduledtemplate);
                }
                else if(emt.name.equalsignorecase(Label.App_meeting_cancelled_template)){
                    cancelledtemplate = emt.id;
                     ////system.debug('Cancelled template---- > '+cancelledtemplate);
                }
                else if(emt.name.equalsignorecase(label.App_meeting_pending_template)){
                    pendingtemplate = emt.id;
                     ////system.debug('Pending template---- > '+pendingtemplate);
                }
                else{
                }
            }
            
            String orgWideEmailAddressID=Label.BPOSolutionWorkbenchEmail ;
            ////system.debug('CC address '+ccaddresse_forsubmit_recall);
            
            if(appmailList.size()>0){
               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                for(approval_meeting__c appmeetingRec : appmailList){
                    if(oldmap.get(appmeetingRec.id).Meeting_Status__c !=appmeetingRec.Meeting_Status__c && appmeetingRec.Meeting_Status__c.equalsignorecase(Label.Approval_Meeting_submitted)){
                    mail.setTargetObjectId(op_id);
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                    mail.setToAddresses(operationsemails);
                    mail.setCCAddresses(ccaddresse_forsubmit_recall);
                    mail.setTemplateId(submittedtemplate);
                    mail.setWhatId(appmeetingRec.id);
                    mail.setSaveAsActivity(false);
                    finalmaillist.add(mail);   
                   //system.debug('mail to send-->'+finalmaillist);        
                }
                    else if(oldmap.get(appmeetingRec.id).Meeting_Status__c !=appmeetingRec.Meeting_Status__c && appmeetingRec.Meeting_Status__c.equalsignorecase(Label.Approval_Meeting_Recalled)){
                        mail.setTargetObjectId(op_id);
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        mail.setToAddresses(operationsemails);
                        mail.setCCAddresses(ccaddresse_forsubmit_recall);
                        mail.setTemplateId(recalltemplate);
                        mail.setWhatId(appmeetingRec.id);
                        mail.setSaveAsActivity(false);
                        finalmaillist.add(mail);
                        
                    }
                    else if(appmeetingRec.Meeting_Status__c.equalsignorecase(Label.Approval_Meeting_scheduled)){
                    //system.debug('inside of scheduled block');
                        useremails.add(appmeetingRec.Meeting_Approver__r.approver__r.user__r.email);
                        mail.setTargetObjectId(appmeetingRec.Requestor__r.user__c);
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        mail.setCCAddresses(useremails);
                        mail.setTemplateId(scheduledtemplate);
                        mail.setWhatId(appmeetingRec.id);
                        mail.setSaveAsActivity(false);
                        if(oldmap.get(appmeetingRec.id).Meeting_Status__c != appmeetingRec.Meeting_Status__c){
                            finalmaillist.add(mail);
                        }
                        list_scheduledmeetings.add(appmeetingRec);
                        //if(string.isNotBlank(appmeetingRec.Attendees__c)){
                           
                           // attendeeschanged_app.add(appmeetingRec);
                        //}
                    }
                    else if(oldmap.get(appmeetingRec.id).Meeting_Status__c !=appmeetingRec.Meeting_Status__c && appmeetingRec.Meeting_Status__c.equalsignorecase(Label.Approval_meeting_Pending)){
                        mail.setTargetObjectId(appmeetingRec.Requestor__r.user__c);
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        mail.setCCAddresses(useremails);
                        mail.setTemplateId(pendingtemplate);
                        mail.setWhatId(appmeetingRec.id);
                        mail.setSaveAsActivity(false);
                        finalmaillist.add(mail);
                    }
                    else if(oldmap.get(appmeetingRec.id).Meeting_Status__c != appmeetingRec.Meeting_Status__c 
                            && appmeetingRec.Meeting_Status__c.equalsignorecase(Label.Approval_Meeting_Cancelled)
                            && oldmap.get(appmeetingRec.id).Meeting_Status__c.equalsignorecase(Label.Approval_Meeting_scheduled))
                    {                
                        mail.setTargetObjectId(appmeetingRec.Requestor__r.user__c);
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        mail.setCCAddresses(useremails);
                        mail.setTemplateId(cancelledtemplate);
                        mail.setWhatId(appmeetingRec.id);
                        mail.setSaveAsActivity(false);
                        if(oldmap.get(appmeetingRec.id).Meeting_Status__c != appmeetingRec.Meeting_Status__c){
                            finalmaillist.add(mail);
                        }
                        list_cancelledmeetings.add(appmeetingRec);
                        
                    }
                     
                    else {
                        
                    }
                    if(oldmap.get(appmeetingRec.id).Meeting_Status__c !=null){
                    if(oldmap.get(appmeetingRec.id).Meeting_Status__c.equalsignorecase(Label.Approval_Meeting_scheduled) &&  
                    !appmeetingRec.Meeting_Status__c.equalsignorecase(Label.Approval_Meeting_scheduled)){
                        list_cancelledmeetings.add(appmeetingRec);
                       // system.debug('meeting is cancelled');
                    }
                    }
                    id devRecordTypeId;
                    if(appmeetingRec.Override_Apvr_Suggestion__c == false){
                        if(appmeetingRec.meeting_status__c.equalsignorecase(Label.Approval_Meeting_submitted)){             
                            devRecordTypeId = Schema.SObjectType.Approval_meeting__c.getRecordTypeInfosByName().get(Label.Meeting_submited_And_false).getRecordTypeId();
                        }
                        else if(appmeetingRec.meeting_status__c.equalsignorecase(Label.Approval_meeting_Pending)){
                            devRecordTypeId = Schema.SObjectType.Approval_meeting__c.getRecordTypeInfosByName().get(Label.Meeting_pending_and_override_false).getRecordTypeId();
                        }
                        else if(appmeetingRec.meeting_status__c.equalsignorecase(Label.Approval_Meeting_scheduled)){
                            devRecordTypeId = Schema.SObjectType.Approval_meeting__c.getRecordTypeInfosByName().get(Label.Meeting_scheduled_And_false).getRecordTypeId();
                        }
                        else if(appmeetingRec.meeting_status__c.equalsignorecase(Label.Approval_Meeting_Cancelled)){
                            devRecordTypeId = Schema.SObjectType.Approval_meeting__c.getRecordTypeInfosByName().get(Label.Meeting_cancelled_and_override_false).getRecordTypeId();
                        }
                        else{
                        }
                    }
                    else{
                        if(appmeetingRec.meeting_status__c.equalsignorecase(Label.Approval_Meeting_submitted)){
                            devRecordTypeId = Schema.SObjectType.Approval_meeting__c.getRecordTypeInfosByName().get(Label.Meeting_Submitted_and_override_true).getRecordTypeId();
                        }
                        else if(appmeetingRec.meeting_status__c.equalsignorecase(Label.Approval_meeting_Pending)){
                            devRecordTypeId = Schema.SObjectType.Approval_meeting__c.getRecordTypeInfosByName().get(Label.Meeting_pending_and_override_true).getRecordTypeId();
                        }
                        else if(appmeetingRec.meeting_status__c.equalsignorecase(Label.Approval_Meeting_scheduled)){
                            devRecordTypeId = Schema.SObjectType.Approval_meeting__c.getRecordTypeInfosByName().get(Label.Meeting_scheduled_And_overide_true).getRecordTypeId();
                        }
                         else if(appmeetingRec.meeting_status__c.equalsignorecase(Label.Approval_Meeting_Cancelled)){
                            devRecordTypeId = Schema.SObjectType.Approval_meeting__c.getRecordTypeInfosByName().get(Label.Meeting_cancelled_and_override_true).getRecordTypeId();
                        }
                        else{
                        }
                    }
                    appmeetingRec.recordtypeid = devRecordTypeId;
                    list_updaterecordtypes.add(appmeetingRec);
                }
                if(list_updaterecordtypes.size()> 0){
                database.SaveResult[] sresult = database.update(list_updaterecordtypes,false);
                }
                FlagforApprovalMails__c myCS1 = new FlagforApprovalMails__c();
                myCS1 = FlagforApprovalMails__c.getValues(UtilConstants.CUSTOM_FLAG);
                //system.debug('custom flag------>'+myCS1);
            boolean sendmail = myCS1.sendApprovalMails__c;
               if(finalmaillist.size()>0 && sendmail){
               List<Messaging.sendEmailResult> result = Messaging.sendEmail(finalmaillist);
                 system.debug('Email sent Result '+result);
                }
                if(list_scheduledmeetings.size()>0){
                   createApprovalCalendarMeeting(list_scheduledmeetings);
                    repopulateMeetingDescription(list_scheduledmeetings);
                }
                if(list_cancelledmeetings.size() > 0 ){
                    DeleteApprovalcalendarevents(list_cancelledmeetings);
                }
                /*if(attendeeschanged_app.size() > 0){
                   createeventattendees(attendeeschanged_app);
                }**/
                
            }
        }
        /*****************
        @description : This method will auto - populate fields
        
        1)meeting description
        2)Request Submitted Date
        ***********************/
       public void populateFieldsonInsert(list<approval_meeting__c> app_meetinglist){
            set<string> set_meetingtime = new set<string>();
            ////system.debug('---------app_meetinglist----------'+app_meetinglist);
            Map<string,Opportunity> approvalOpportunityMap = new Map<string,Opportunity>();
            Map<String,Meeting_Lync_Details__c> lyncMap = new Map<String,Meeting_Lync_Details__c>(); 
            List<Approval_meeting__c> app_meetinglist1 = new List<Approval_meeting__c>();
            List<Approval_meeting__c> app_meetinglist2 = new List<Approval_meeting__c>();
            
            app_meetinglist1 = [Select id,recordtypeid,BPO_Net_Revenue_Tds__c,meeting_approver__c,sg__c,Service_Group__c,Solution_A_New__c,
                                Name,Geo_Region__c,Requestor__c,Geo_unit__c,Approval_Stage__r.opportunity__r.Pri_Off__c,
                                Opportunity__c,Meeting_status__c,Requested_Meeting_Time__c,Approval_Stage__r.Opportunity__r.Opportunity_Solution_Lead__r.name,Approval_Stage__r.Opportunity__r.IO_Solution_Architect__r.name,Approval_Stage__r.Opportunity__r.IC_Solution_Architect__r.name, Approval_Stage__r.Opportunity__r.BPO_Net_Rev_Thousands__c, Approval_Stage__r.Opportunity__r.IO_Net_Revenue_Thousands__c,Approval_Stage__r.Opportunity__r.IC_Net_Rev_Thousands__c,
                                Meeting_Description__c,Requested_Meeting_Date__c from approval_meeting__c 
                                where Id IN:app_meetinglist LIMIT 2500]; 
            Set<String> oppNames = new Set<String>(); 
            ////system.debug('--------app_meetinglist1-----------'+app_meetinglist1);
            for(Approval_meeting__c app_meet:app_meetinglist1){
                //set_meetingtime.add(app_meet.Requested_Meeting_Time__c);
                oppNames.add(app_meet.Opportunity__c);
            }
            ////system.debug('------set_meetingtime---------'+set_meetingtime);
            
            for(opportunity op:[Select id,Name,Link_to_SharePoint_Documents__c,Opportunity_Solution_Lead__c,Opportunity_Solution_Lead__r.name,Off__c,
                                        Delivery_Locations__c,Prime_SDO_Lead_dev__c,Prime_SDO_Lead_IO_dev__c,Offerings_IO__c,Delivery_Locations_IO__c From Opportunity where Name In : oppNames LIMIT 5000]){
                approvalOpportunityMap.put(op.name, op);
            }
           // list<Meeting_Lync_Details__c> lync_details = [select id,name,lync__c,active__c from Meeting_Lync_Details__c where Name in :set_meetingtime];
            ////system.debug('--------lync_details------'+lync_details);
           // for(Meeting_Lync_Details__c LyncMeet : lync_details){
             //   lyncMap.put(LyncMeet.Name,LyncMeet);    
            //}
            ////system.debug('-----lyncMap-------'+lyncMap);
            opportunity opp;
           // Meeting_Lync_Details__c lyncUrl = new Meeting_Lync_Details__c();
            for(Approval_meeting__c app_meet:app_meetinglist1){
                if(approvalOpportunityMap.containskey(app_meet.Opportunity__c)){
                        opp = new opportunity();
                        opp = approvalOpportunityMap.get(app_meet.Opportunity__c);
                       // lyncUrl = lyncMap.get(app_meet.Requested_Meeting_Time__c); 
                        String OppURL = URL.getSalesforceBaseUrl().toExternalForm()+UtilConstants.SLASH+opp.id;
                        String SharepointURL = UtilConstants.EMPTY_STRING;
                        string offering = UtilConstants.EMPTY_STRING;
                        string delivery_locations = UtilConstants.EMPTY_STRING;
                        string oppsollead = UtilConstants.EMPTY_STRING;
                        //string lyncconf_link = UtilConstants.EMPTY_STRING;
                        string primesdolead = UtilConstants.EMPTY_STRING;
                   if(string.isNotBlank(opp.Link_to_SharePoint_Documents__c)){
                            sharepointURL = opp.Link_to_SharePoint_Documents__c;
                            sharepointURL = sharepointURL.replaceAll(UtilConstants.SPACE_EMPTY,UtilConstants.SINGLE_SPACE);
                   }
                   if(app_meet.Service_Group__c !=null){
                            oppsollead = app_meet.Solution_A_New__c;
                   /*if(string.isNotBlank(opp.Opportunity_Solution_Lead__r.name)){
                            oppsollead = app_meet.Solution_A_New__c;*/
                   }
                   if(string.isBlank(app_meet.Meeting_status__c)){
                            app_meet.Meeting_status__c = Label.Approval_Meeting_submitted;
                   }
                   
                   // code is added for IO and BPO bundle
                   If(app_meet.Service_Group__c.Contains(UtilConstants.BPO) && opp.Off__c != null){
                        //if(opp.Off__c != null){
                            offering = opp.off__c;
                        }
                        If(app_meet.Service_Group__c.Contains(UtilConstants.IO) && opp.Offerings_IO__c != null){
                        //if(opp.Offerings_IO__c != null){
                            offering = opp.Offerings_IO__c;
                            }
                
                        if(app_meet.Service_Group__c.Contains(UtilConstants.BPO) && opp.Delivery_Locations__c != null){
                           delivery_locations = opp.Delivery_Locations__c;
                        }
                        if(app_meet.Service_Group__c.Contains(UtilConstants.IO) && opp.Delivery_Locations_IO__c != null){
                           delivery_locations = opp.Delivery_Locations_IO__c;
                        }
                   
                  /* if(string.isNotBlank(opp.Off__c)){
                            offering = opp.Off__c;
                   }
                   if(string.isNotBlank(opp.Delivery_Locations__c)){
                            delivery_locations = opp.Delivery_Locations__c;
                   }
                 /* if(lyncUrl.lync__c != null){
                            lyncconf_link = lyncUrl.lync__c;
                   }*/
                   if(opp.prime_sdo_lead_dev__c != null && opp.Prime_SDO_Lead_IO_dev__c != null){
                           primesdolead  = opp.prime_sdo_lead_dev__c+UtilConstants.SEMICOLON_STRING+opp.Prime_SDO_Lead_IO_dev__c;
                    }
                   else if(opp.prime_sdo_lead_dev__c != null){
                           primesdolead  = opp.prime_sdo_lead_dev__c;
                    }
                    else if(opp.Prime_SDO_Lead_IO_dev__c != null){
                           primesdolead  = opp.Prime_SDO_Lead_IO_dev__c;
                    }else{}
                    if(!test.isRunningTest() && app_meet.Requestor__c == null){
                    
                    id usmasterid = [select id from user_master__c where user__c=:Userinfo.getUserId() limit 1].id;
                    app_meet.Requestor__c = usmasterid;
                                       ////system.debug('Requestor__c:::::::'+usmasterid+'Value Ppuldated:::::'+app_meet.Requestor__c);
                    
                    /*if(usmaster != null){
                        if(usmaster.user__r.profile.name.Contains('IO')){
                            app_meet.SG__c = 'IO';
                        }
                        else if(usmaster.user__r.profile.name.Contains('IC')){
                            app_meet.SG__c = 'IC';
                        }
                        else if(usmaster.user__r.profile.name.Contains('Solution')){
                            app_meet.SG__c = 'BPO';
                        }
                        else {
                            app_meet.SG__c = 'BPO';
                            
                            
                        }
                    }*/
                    if(app_meet.Approval_Stage__r.Opportunity__r.BPO_Net_Rev_Thousands__c ==null){
                        app_meet.Approval_Stage__r.Opportunity__r.BPO_Net_Rev_Thousands__c=0;
                    }
                    if(app_meet.Approval_Stage__r.Opportunity__r.IO_Net_Revenue_Thousands__c == null){
                        app_meet.Approval_Stage__r.Opportunity__r.IO_Net_Revenue_Thousands__c =0;
                    }
                    if(app_meet.Approval_Stage__r.Opportunity__r.IC_Net_Rev_Thousands__c == null){
                        app_meet.Approval_Stage__r.Opportunity__r.IC_Net_Rev_Thousands__c =0;
                    }
            if(UtilConstants.BUNDLD_BPO.equalsIgnoreCase(app_meet.Service_Group__c) || UtilConstants.BUNDLD_IO.equalsIgnoreCase(app_meet.Service_Group__c)){
                app_meet.BPO_Net_Revenue_Tds__c = app_meet.Approval_Stage__r.Opportunity__r.BPO_Net_Rev_Thousands__c +app_meet.Approval_Stage__r.Opportunity__r.IO_Net_Revenue_Thousands__c;
                
                //system.debug('Bundled (BPO)'+app_meet.BPO_Net_Revenue_Tds__c);
                if(app_meet.Approval_Stage__r.Opportunity__r.BPO_Net_Rev_Thousands__c > app_meet.Approval_Stage__r.Opportunity__r.IO_Net_Revenue_Thousands__c ){
                    app_meet.Opportunity_Solution_Lead__c = app_meet.Approval_Stage__r.Opportunity__r.Opportunity_Solution_Lead__r.name;
                }else if(app_meet.Approval_Stage__r.Opportunity__r.BPO_Net_Rev_Thousands__c < app_meet.Approval_Stage__r.Opportunity__r.IO_Net_Revenue_Thousands__c ){
                app_meet.Opportunity_Solution_Lead__c = app_meet.Approval_Stage__r.Opportunity__r.IO_Solution_Architect__r.name;
                }else{}
            }
            else if(UtilConstants.BPO.equalsIgnoreCase(app_meet.Service_Group__c)){
                app_meet.Opportunity_Solution_Lead__c = app_meet.Approval_Stage__r.Opportunity__r.Opportunity_Solution_Lead__r.name;
                app_meet.BPO_Net_Revenue_Tds__c =app_meet.Approval_Stage__r.Opportunity__r.BPO_Net_Rev_Thousands__c;
            }else if (UtilConstants.IO.equalsIgnoreCase(app_meet.Service_Group__c)){
                app_meet.BPO_Net_Revenue_Tds__c =app_meet.Approval_Stage__r.Opportunity__r.IO_Net_Revenue_Thousands__c;
                app_meet.Opportunity_Solution_Lead__c = app_meet.Approval_Stage__r.Opportunity__r.IO_Solution_Architect__r.name;
            }else{}
        }
                    app_meet.Request_Submitted_Date__c = System.today();
                    id devRecordTypeId;
                    if(app_meet.Override_Apvr_Suggestion__c == false){
                      devRecordTypeId = Schema.SObjectType.Approval_meeting__c.getRecordTypeInfosByName().get(Label.Meeting_submited_And_false).getRecordTypeId();
                    }
                    else{
                        devRecordTypeId = Schema.SObjectType.Approval_meeting__c.getRecordTypeInfosByName().get(Label.Meeting_Submitted_and_override_true).getRecordTypeId();
                    }
                    string timetostart=UtilConstants.EMPTY_STRING;
                    string minutes = UtilConstants.ZERO;
                    string seconds = UtilConstants.ZERO;
                    app_meet.Meeting_Description__c= populateMeetingDescription(OppURL,opp.name,sharepointURL,
               oppsollead,offering,delivery_locations,primesdolead);
                    //system.debug(' requested time:::'+app_meet.Requested_Meeting_Time__c);
                    if(app_meet.Requested_Meeting_Time__c != UtilConstants.EMPTY_STRING && 
                        app_meet.Requested_Meeting_Time__c != null){
                        app_meet.Scheduled_Meeting_time__c = app_meet.Requested_Meeting_Time__c;
                        }else if(test.isRunningTest()){
                            app_meet.Scheduled_Meeting_time__c = UtilConstants.SCHDULE_MEETING_TIME;
                        }
                        else{
                        }  
                   if(app_meet.Scheduled_Meeting_time__c != null && !app_meet.Scheduled_Meeting_time__c.equalsignorecase(UtilConstants.NON_STD_CALL_TIME)) {
                         TimeZone tz = UserInfo.getTimeZone();
                           integer hourstoadd = 0;
                   integer minutestoadd = 0;
                   if(!Test.isRunningTest()){
                   string usertimezone = string.valueof(userinfo.getTimeZone());
                   Time_Zone_settings__c custsettime = Time_Zone_settings__c.getValues(usertimezone);
                     hourstoadd = integer.valueof(custsettime.hours__c);
                     minutestoadd =integer.valueof(custsettime.minutes__c);
                   }
                 
                        date dt = app_meet.Requested_Meeting_Date__c;
                       
                        string abc = string.valueOf(app_meet.Scheduled_Meeting_time__c);
                        for(string s : abc.split(UtilConstants.PATTRN)){
                            if(s.isNumeric()){
                                timetostart = timetostart+s;
                                if(timetostart== UtilConstants.TWO_THREE_ZERO){
                                    timetostart = UtilConstantsforSWB.zerotwo;
                                    minutes = UtilConstants.THREE_ZERO;
                                }
                            }
                        }
                        //Time myTime = Time.newInstance(timetostart, 0, 0, 0);
                    //system.debug('@@@@@'+timetostart);
                  
                    //System.debug('time -->'+timetostart);
                    // System.debug('minutes-->'+minutes );
                    // date converteddate = dt.format('M/DD/YYYY','America/Chicago');
                        datetime dt1 = Datetime.newInstance(dt.year(),dt.month(),dt.day(),Integer.valueof(timetostart),integer.valueof(minutes),integer.valueof(seconds)); 
                        //system.debug('date before conversion---->'+dt1);
                 
                   dt1 = dt1.addhours(hourstoadd);
                   dt1 = dt1.addminutes(minutestoadd);
                         app_meet.Scheduled_Start__c = dt1;
                         app_meet.Scheduled_End__c = app_meet.Scheduled_Start__c.addHours(1);
                         /*endtime = app_meet.Scheduled_End__c.format('MM/dd/yyyy hh:mm:ss a', 'CST');
                         app_meet.Scheduled_End__c = datetime.parse(endtime);*/
                    }
                    
                  
                    /*app_meet.Scheduled_Start__c = app_meet.Requested_Meeting_Date__c;
                    app_meet.Scheduled_End__c = app_meet.Requested_Meeting_Date__c.addHours(1);*/
                    app_meetinglist2.add(app_meet);
                }
            }
            ////system.debug('--------------'+app_meetinglist2);    
            Database.saveresult[] uresult = database.update(app_meetinglist2);                      
            //system.debug('update result '+uresult);
        }
        /*****************
            @description: method to populate approver based on inputs
            @inputs     : Opportunity value, geo region,geo unit primary offering
            @output     : Meeting Approver
        *****************/
      
    public void populateMeetingApprover(Approval_Meeting__c app_meet){
            ////system.debug(' Approver :::::: '+app_meet);
           string risklevel = [select Approval_stage__r.opportunity__r.risk_level__c from Approval_meeting__c where id=:app_meet.id limit 1].Approval_stage__r.opportunity__r.risk_level__c;
            Approval_meeting__c app = new approval_meeting__c();
            try{
            Meeting_Approver_Master__c meet_master = [select id from Meeting_Approver_master__c 
                                                     where (Geo_region__r.name=:app_meet.geo_region__c OR Geo_region__c=:UtilConstants.EMPTY_STRING)AND
                                                     (Geo_unit__c =: app_meet.geo_unit__c OR Geo_unit__c =:UtilConstants.EMPTY_STRING) AND
                                                     (Risk_level__c =: risklevel OR Risk_level__c=:UtilConstants.EMPTY_STRING) AND
                                                     (Offering__r.name=:app_meet.Primary_Offering__c OR Offering__c=:UtilConstants.EMPTY_STRING) AND 
                                                      (tcv_range_minimum__c <=: app_meet.BPO_Net_Revenue_Tds__c AND tcv_range_maximum__c >=: app_meet.BPO_Net_Revenue_Tds__c)                                                 
                                                     order by Preference__c limit 1];
       
            if(!app_meet.Override_Apvr_Suggestion__c && meet_master != null){
                app.id = app_meet.id;
                app.Meeting_Approver__c = meet_master.id;
            }
            else{
                app.id = app_meet.id;
                app.Override_Apvr_Suggestion__c = true; 
                app.recordtypeid = Schema.SObjectType.Approval_meeting__c.getRecordTypeInfosByName().get(Label.Meeting_Submitted_and_override_true).getRecordTypeId();
            }
           }
            catch(exception e){
               app.id = app_meet.id;
                app.Override_Apvr_Suggestion__c = true;
                app.recordtypeid = Schema.SObjectType.Approval_meeting__c.getRecordTypeInfosByName().get(Label.Meeting_Submitted_and_override_true).getRecordTypeId();
                
            }
             database.saveresult uresult = database.update(app);
        }
        /*

          // SWB-615 Approver Matrix Enhancement  
          
       public void populateMeetingApprover(Approval_Meeting__c app_meet){
           //string risklevel = [select Approval_stage__r.opportunity__r.risk_level__c from Approval_meeting__c where id=:app_meet.id limit 1].Approval_stage__r.opportunity__r.risk_level__c;
            Approval_meeting__c app = new approval_meeting__c();
            
              List<Meeting_Approver_Master__c> meet_master = [Select Id,Geo_region__c ,Geo_region__r.name, OperatingGroup__c,OperatingGroup__r.name,
                                                                Geo_unit__c ,Risk_level__c,country__c,Offering__r.name,tcv_range_minimum__c,tcv_range_maximum__c, Approval_Type__c,Service_Group__c
                                                                from Meeting_Approver_master__c WHERE Approval_Type__c =: app_meet.Approval_Type__c  AND tcv_range_minimum__c <=: app_meet.NRTNew__C  AND tcv_range_maximum__c >=: app_meet.NRTNew__C  order by Preference__c ]; 
    
            List<Meeting_Approver_Master__c> ioFinal = new List<Meeting_Approver_Master__c>();
              ioFinal = getApprover(meet_master,app_meet);
            try{      
                if(!app_meet.Override_Apvr_Suggestion__c  && ioFinal .size() > 0 ){
                    app.id = app_meet.id;
                      app.Meeting_Approver__c = ioFinal[0].Id;
                }
                else{
                    app.id = app_meet.id;
                    app.Override_Apvr_Suggestion__c = true; 
                    app.recordtypeid = Schema.SObjectType.Approval_meeting__c.getRecordTypeInfosByName().get(Label.Meeting_Submitted_and_override_true).getRecordTypeId();
                }
           }
            catch(exception e){
                app.id = app_meet.id;
                app.Override_Apvr_Suggestion__c = true;
                app.recordtypeid = Schema.SObjectType.Approval_meeting__c.getRecordTypeInfosByName().get(Label.Meeting_Submitted_and_override_true).getRecordTypeId();
                
            }
             database.saveresult uresult = database.update(app);
        } 

  
   public List<Meeting_Approver_Master__c> getApprover(List<Meeting_Approver_Master__c> meetinglist, Approval_Meeting__c am){   
       List<Meeting_Approver_Master__c> ioFinal = new List<Meeting_Approver_Master__c>();
      // String SG = (am.Approval_Type__c == 'BPO Final Approval')? 'BPO' : 'IO';
       if(meetinglist.size() > 0){    
       
             
             for(Meeting_Approver_Master__c mam: meetinglist){
                    if(mam.country__c == am.country__c)
                            ioFinal.add(mam);      
                }
               
                if(ioFinal.size() == 0){ 
                      for(Meeting_Approver_Master__c mam: meetinglist){
                        if(mam.country__c == null )
                           ioFinal.add(mam);
                       } 
                }  
                
       
             if(ioFinal.size() > 1){
                  meetinglist = ioFinal;
                  ioFinal = new List<Meeting_Approver_Master__c>();
                  
                for(Meeting_Approver_Master__c mam: meetinglist){
                    if(mam.Geo_Region__r.name == am.Geo_Region__c)
                            ioFinal.add(mam);      
                }
               
                if(ioFinal.size() == 0){ 
                      for(Meeting_Approver_Master__c mam: meetinglist){
                        if(mam.Geo_Region__r.name == null )
                           ioFinal.add(mam);
                       } 
                }              
             }  
                if(ioFinal.size() > 1){
                  meetinglist = ioFinal;
                  ioFinal = new List<Meeting_Approver_Master__c>();
                  for(Meeting_Approver_Master__c mam: meetinglist){
                    if(mam.Geo_unit__c == am.Geo_Unit__c) 
                            ioFinal.add(mam);                       
                  }
                  
                    if(ioFinal.size() == 0){ 
                      for(Meeting_Approver_Master__c mam: meetinglist){
                        if((mam.Geo_unit__c == null ||  am.Geo_unit__c == null || mam.Geo_unit__c != null) && 
                            (mam.Risk_Level__c == am.Risk_Level__c || mam.Risk_Level__c == null ||  am.Risk_Level__c == null || mam.Risk_Level__c != null) && 
                            (mam.Offering__r.name == am.Primary_BPO_Offering__c || mam.Offering__r.name == null || am.Primary_BPO_Offering__c == null || mam.Offering__r.name != null) && 
                            (mam.OperatingGroup__r.name == am.Operating_Group__c || mam.OperatingGroup__r.name == null || am.Operating_Group__c == null || mam.OperatingGroup__r.name != null)){
                           ioFinal.add(mam);
                          }
                     }                            
                   }
                 }
 
            if(ioFinal.size() > 1){
                  meetinglist = ioFinal;
                  ioFinal = new List<Meeting_Approver_Master__c>();
                  for(Meeting_Approver_Master__c mam: meetinglist){
                       if(mam.Risk_Level__c == am.Risk_Level__c) 
                            ioFinal.add(mam);                                   
                  }
                    if(ioFinal.size() == 0){ 
                      for(Meeting_Approver_Master__c mam: meetinglist){
                          if((mam.Risk_Level__c == null ||  am.Risk_Level__c == null || mam.Risk_Level__c != null) && 
                            (mam.Offering__r.name == am.Primary_BPO_Offering__c || mam.Offering__r.name == null || mam.Offering__r.name != null) && 
                            (mam.OperatingGroup__r.name == am.Operating_Group__c || mam.OperatingGroup__r.name == null || am.Operating_Group__c == null || mam.OperatingGroup__r.name != null)){
                            ioFinal.add(mam); 
                          }      
                      }
                    }  
            }
            
            if(ioFinal.size() > 1){
                  meetinglist = ioFinal;
                  ioFinal = new List<Meeting_Approver_Master__c>();
                  for(Meeting_Approver_Master__c mam: meetinglist){
                      if(mam.Offering__r.name == am.Primary_BPO_Offering__c) 
                            ioFinal.add(mam);      
                  }
                   if(ioFinal.size() == 0){ 
                      for(Meeting_Approver_Master__c mam: meetinglist){
                         if((mam.Offering__r.name == null || am.Primary_BPO_Offering__c == null || mam.Offering__r.name != null) && 
                            (mam.OperatingGroup__r.name == am.Operating_Group__c || mam.OperatingGroup__r.name == null || am.Operating_Group__c == null || mam.OperatingGroup__r.name != null)){
                            ioFinal.add(mam);
                            } 
                      }
                   }
           } 
           if(ioFinal.size() > 1){
                  meetinglist = ioFinal;
                  ioFinal = new List<Meeting_Approver_Master__c>();
                  for(Meeting_Approver_Master__c mam: meetinglist){
                      if(mam.OperatingGroup__r.name == am.Operating_Group__c) 
                            ioFinal.add(mam);      
                  }
                   if(ioFinal.size() == 0){ 
                      for(Meeting_Approver_Master__c mam: meetinglist){
                         if(mam.OperatingGroup__r.name == null || mam.OperatingGroup__r.name != null || am.Operating_Group__c== null) 
                            ioFinal.add(mam); 
                      }
                   }
           }       
                             
       }  
     return ioFinal;
  } **/

        /********************
            @description : This method is used in creating/updating events for scheduled meetings
            @inputs : list of approval meeting whose status is scheduled
            @Logic : creates/updates events
        *******************/
        public void createApprovalCalendarMeeting(list<approval_meeting__c> scheduledmeetings){
        list<string> approvalids = new list<string>();
            map<id,Approval_meeting__c> app_meetMap = new map<id,Approval_meeting__c>();
            map<string,Meeting_Lync_Details__c> lyncMap = new map<string,Meeting_Lync_Details__c>();
            set<id> oppids = new set<id>();
            map<id,string> oppdoclink = new map<id,string>();
            //system.debug('list in record:::'+scheduledmeetings);
            for(Approval_meeting__c app : scheduledmeetings){
                approvalids.add(app.id);
                app_meetMap.put(app.id, app);
                oppids.add(app.Approval_Stage__r.opportunity__c);
            }
            for(Opportunity opp : [select id,Link_to_SharePoint_Documents__c from opportunity where ID IN:oppids limit 500]){
                oppdoclink.put(opp.id,opp.Link_to_SharePoint_Documents__c );
            }
            for(Meeting_Lync_Details__c lync : [select id,name,lync__c,Conference_ID__c,Service_Group__c from Meeting_Lync_Details__c limit 10]){
               string lyncName = lync.name;
               lyncName = lyncName.trim();
               lyncName = lyncName.tolowercase();
               String serGrp=lync.Service_Group__c;
               serGrp=serGrp.trim();
               serGrp=serGrp.tolowercase();
                    //system.debug('lync name::::'+lyncName);
                    //system.debug('lync name::::'+lyncName +' serGrp'+serGrp );
                    lyncMap.put(lyncName+UtilConstants.HYPHEN+serGrp,lync);
                    
                    
            }
            string opplink =UtilConstants.EMPTY_STRING;
           
            Meeting_Lync_Details__c lyncUrl = new Meeting_Lync_Details__c();
            approval_meeting__c app_toupdate;
            list<event> previousevents= [SELECT Id,WhatId,WhoId, Subject, StartDateTime, EndDateTime FROM Event where whatid IN:approvalids limit 100];
            //system.debug('approval previous records::;'+previousevents);
            list<event> events_tocreate = new list<event>();
            event ev;
            //System.debug('Size---------->'+previousevents.size());
            string meetingtime = UtilConstants.EMPTY_STRING;
            string meetinglync =UtilConstants.EMPTY_STRING;
            string conferenceid=UtilConstants.EMPTY_STRING;
            if(previousevents.size() ==0){
            //system.debug('list--------->'+scheduledmeetings);
            
            for(Approval_Meeting__c app_meet : scheduledmeetings){
            if(oppdoclink.get(app_meet.approval_stage__r.opportunity__c) != null){
            opplink = oppdoclink.get(app_meet.approval_stage__r.opportunity__c);
            opplink = opplink.replaceall(UtilConstants.SPACE_EMPTY,UtilConstants.SINGLE_SPACE);
            }
            //approval_stage__r.opportunity__c
            //System.debug('lync url---->'+app_meet.scheduled_meeting_time__c.tolowercase().trim());
            //system.debug('app_meet.Service_Group__c.tolowercase().trim()-- '+app_meet.Service_Group__c.tolowercase().trim());
            //system.debug('lyncMap.get(app_meet.scheduled_meeting_time__c.tolowercase().trim()--------'+lyncMap.get(app_meet.scheduled_meeting_time__c.tolowercase().trim()+'-'+utilconstants.BPO.tolowercase()));
            if(app_meet.Service_Group__c.tolowercase().trim().contains(utilconstants.BPO.tolowercase())){
                lyncUrl = lyncMap.get(app_meet.scheduled_meeting_time__c.tolowercase().trim()+utilconstants.HYPHEN+utilconstants.BPO.tolowercase());
             }
             else{
             lyncUrl = lyncMap.get(app_meet.scheduled_meeting_time__c.tolowercase().trim()+utilconstants.HYPHEN+utilconstants.IO.tolowercase());
             }
             //debug('lync url---->'+lyncUrl );
             if(lyncUrl != null){
                 meetingtime =lyncUrl.name;
                 meetinglync  = lyncUrl.lync__c;
                 conferenceid = lyncUrl.Conference_ID__c;
             }
                ev = new event();
                ev.WhatId = app_meet.id;
                ev.Opportunity_id_dev__c = app_meet.Approval_Stage__r.opportunity__c;
                ev.StartDateTime = app_meet.Scheduled_Start__c;
                ev.EndDateTime = app_meet.Scheduled_End__c;
                ev.OwnerId = Label.public_calendar_id;
                ev.Subject = app_meet.Service_Group__c+utilconstants.HYPHEN+app_meet.Meeting_subject__c;
                //ev.Subject = 'Service Group -('+app_meet.Service_Group__c+')-'+app_meet.Meeting_subject__c;
                //ev.Subject = app_meet.Meeting_subject__c+'-(Service Group -'+app_meet.Service_Group__c);
                 ev.description =Label.For_opportunity+utilconstants.NEW_LINE_STRING+URL.getSalesforceBaseUrl().toExternalForm() +
                    UtilConstants.SLASH+app_meet.Approval_Stage__r.opportunity__c+utilconstants.NEW_LINE_STRING+utilconstants.EMPTY_STRING+
                    utilconstants.NEW_LINE_STRING+utilconstants.EMPTY_STRING+utilconstants.NEW_LINE_STRING+
                   utilconstants.oppdocsline_outlook+utilconstants.NEW_LINE_STRING+
                    utilconstants.EMPTY_STRING+opplink+utilconstants.EMPTY_STRING+utilconstants.NEW_LINE_STRING+
                    utilconstants.EMPTY_STRING+utilconstants.NEW_LINE_STRING+utilconstants.EMPTY_STRING+utilconstants.NEW_LINE_STRING+
                    utilconstants.joinonline +utilconstants.NEW_LINE_STRING+utilconstants.EMPTY_STRING+utilconstants.NEW_LINE_STRING+
                    utilconstants.EMPTY_STRING+meetingtime+utilconstants.NEW_LINE_STRING+
                    utilconstants.lync_outlook+meetinglync+utilconstants.NEW_LINE_STRING+
                    utilconstants.conferenceid+conferenceid +utilconstants.NEW_LINE_STRING+utilconstants.EMPTY_STRING+utilconstants.NEW_LINE_STRING+
                    utilconstants.EMPTY_STRING+utilconstants.NEW_LINE_STRING+
                    utilconstants.EMPTY_STRING+utilconstants.outlookdetails+utilconstants.EMPTY_STRING+
                    utilconstants.EMPTY_STRING;
            
                ev.Client__c=app_meet.Client_Name__c;
                ev.Approver__c=app_meet.Meeting_Approver__r.name;
                ev.Opportunity_Solution_Lead__c=app_meet.Opportunity_Solution_Lead__c;
                ev.Type = UtilConstants.MEETING;
                ev.Opportunity_name_Dev__c = app_meet.Opportunity__c;
                events_tocreate.add(ev);
            }
                if(events_tocreate.size() > 0) {
                    Database.saveResult[] sresult = Database.insert(events_tocreate,false);
                  // system.debug('events insert save result' +sresult);
                }
            }
            else{
               
                for(event ev_update:previousevents){
                    app_toupdate = new Approval_meeting__c();
                    app_toupdate = app_meetMap.get(ev_update.whatid);
                    //system.debug('my map::;'+app_toupdate);
                    if(app_toupdate !=null){
                      
            //System.debug('lync url---->'+app_toupdate.scheduled_meeting_time__c.tolowercase().trim());
            
            //system.debug('app_meet.Service_Group__c.tolowercase().trim()-88- '+app_toupdate.Service_Group__c.tolowercase().trim());
            //system.debug('lyncMap.get(app_meet.scheduled_meeting_time__c.tolowercase().trim()-----99---'+lyncMap.get(app_toupdate.scheduled_meeting_time__c.tolowercase().trim()+'-'+'bpo'));
            lyncUrl = lyncMap.get(app_toupdate.scheduled_meeting_time__c.tolowercase().trim()+utilconstants.HYPHEN+utilconstants.BPO.tolowercase());
            //system.debug('lyncUrl--- '+lyncUrl);
            if(app_toupdate.Service_Group__c.tolowercase().trim().contains(utilconstants.BPO.tolowercase())){
                lyncUrl = lyncMap.get(app_toupdate.scheduled_meeting_time__c.tolowercase().trim()+utilconstants.HYPHEN+utilconstants.BPO.tolowercase());
             }
             else{
             lyncUrl = lyncMap.get(app_toupdate.scheduled_meeting_time__c.tolowercase().trim()+utilconstants.HYPHEN+utilconstants.IO.tolowercase());
             }
            
            
            
             //lyncUrl = lyncMap.get(app_toupdate.scheduled_meeting_time__c.tolowercase().trim());
             if(lyncUrl != null){
                 meetingtime =lyncUrl.name;
                 meetinglync  = lyncUrl.lync__c;
                 conferenceid = lyncUrl.Conference_ID__c;
             }
                    ev_update.WhatId = app_toupdate.id;
                    ev_update.Opportunity_id_dev__c = app_toupdate.Approval_Stage__r.opportunity__c;
                    ev_update.whatid = app_toupdate.id;
                    //system.debug('app meeting opportunity'+app_toupdate.Approval_Stage__r.opportunity__c);
                   /* ev.description =Label.For_opportunity+utilconstants.NEW_LINE_STRING+URL.getSalesforceBaseUrl().toExternalForm() +
                    UtilConstants.SLASH+app_toupdate.Approval_Stage__r.opportunity__c+utilconstants.NEW_LINE_STRING+
                   UtilConstants.oppdocsline_outlook+utilconstants.NEW_LINE_STRING+
                    utilconstants.EMPTY_STRING+opplink+utilconstants.EMPTY_STRING+utilconstants.NEW_LINE_STRING+
                    utilconstants.joinonline +utilconstants.NEW_LINE_STRING+
                    utilconstants.EMPTY_STRING+meetingtime+utilconstants.NEW_LINE_STRING+
                    utilconstants.lync_outlook+meetinglync+utilconstants.NEW_LINE_STRING+
                    utilconstants.conferenceid +conferenceid +utilconstants.NEW_LINE_STRING+utilconstants.EMPTY_STRING+utilconstants.NEW_LINE_STRING+
                    utilconstants.EMPTY_STRING+utilconstants.NEW_LINE_STRING+
                    utilconstants.EMPTY_STRING+utilconstants.outlookdetails+''+
                    utilconstants.EMPTY_STRING;*/
                    ev_update.StartDateTime = app_toupdate.Scheduled_Start__c;
                    ev_update.EndDateTime = app_toupdate.Scheduled_End__c;
                    ev_update.OwnerId = Label.public_calendar_id;
                    ev_update.Subject = app_toupdate.Service_Group__c+utilconstants.HYPHEN+app_toupdate.Meeting_subject__c;
                    ev_update.Client__c=app_toupdate.Client_Name__c;
                    ev_update.Approver__c=app_toupdate.Meeting_Approver__r.name;
                    ev_update.Opportunity_Solution_Lead__c=app_toupdate.Opportunity_Solution_Lead__c;
                    ev_update.Type = UtilConstants.MEETING;
                        //system.debug('app oppo::'+app_toupdate.Opportunity__c);
                    ev_update.Opportunity_name_Dev__c = app_toupdate.Opportunity__c;
                    events_tocreate.add(ev_update); 
                }
                }
                if(!events_tocreate.isEmpty()) {
                    Database.saveResult[] sresult = Database.update(events_tocreate,false);
                    // system.debug('events save result' +sresult);
                }
            }
           
        }
        /***********************
            @description : Method is invoked to delete calendar events when Approval Meeting is cancelled
            @inputs     : list of approval meeting whose status is cancelled
        ***********************/
        public void DeleteApprovalcalendarevents(list<approval_meeting__c> cancelledmeetings){
            list<string> canceledids = new list<string>();
            for(Approval_meeting__C app : cancelledmeetings){
                canceledids.add(app.id);
            }
            list<event> events_todelete = [select id from event where whatid IN :canceledids LIMIT 5000];
            if(events_todelete.size() > 0){
           
                Database.deleteResult[] dresult = Database.delete(events_todelete,false); 
                ////system.debug('events delete result' +dresult);
            }
        }
        /*****************
            @description : Resubmits Approval meeting request
            @parameters  : trigger.new and trigger.oldmap
            @output      : none 
    
        *****************/
        public void reSubmitApprovalMeeting(list<approval_meeting__c> newlist, map<id,Approval_meeting__c> oldmap){
           list<Approval_meeting__c> applist = new list<approval_meeting__c>();
            string profilename = [select id,profile.name from user where id=:userinfo.getUserId() LIMIT 1].profile.name;
            ////system.debug('Resubmit New list ---> '+newlist+ 'oldmap----> '+oldmap);
            
            try{
            id usMasterId ;
            if(!test.isrunningtest()){
            usMasterId = [select id from user_master__c where user__c=:Userinfo.getUserId() limit 1].id;
            }
            for(Approval_meeting__c app_meet : [Select id,meeting_status__c,createdbyid,
                                                     scheduled_start__c,Requested_Meeting_Date__c,Override_Apvr_Suggestion__c,
                                                     scheduled_meeting_time__c,Requested_Meeting_Time__c,
                                                     scheduled_end__c From approval_meeting__c
                                                      where id In :newlist LIMIT 2500]){
                if(app_meet.meeting_status__c !=null && oldmap.get(app_meet.id).meeting_status__c != null){
                    if(oldmap.get(app_meet.id).meeting_status__c.equalsignorecase(app_meet.Meeting_Status__c) && app_meet.CreatedByid == userinfo.getUserId()){
                        if(app_meet.Meeting_Status__c.equalsignorecase(label.Approval_Meeting_Recalled) ||
                         app_meet.Meeting_Status__c.equalsignorecase(label.Approval_meeting_Pending) ||
                         app_meet.Meeting_Status__c.equalsignorecase(label.Approval_Meeting_Cancelled)){
                         app_meet.Meeting_Status__c = label.Approval_Meeting_submitted;
                         app_meet.Request_Submitted_Date__c = system.today();
                         if((oldmap.get(app_meet.id).Requested_Meeting_Time__c != app_meet.requested_meeting_time__c ||
                            app_meet.requested_meeting_time__c != app_meet.scheduled_meeting_time__c) && 
                            app_meet.requested_meeting_time__c !=null){
                            app_meet.scheduled_meeting_time__c = app_meet.requested_meeting_time__c;
                       }
                         if(oldmap.get(app_meet.id).Requested_Meeting_Date__c != app_meet.Requested_Meeting_Date__c ||
                         app_meet.Requested_Meeting_Time__c != app_meet.scheduled_meeting_time__c || oldmap.get(app_meet.id).scheduled_meeting_time__c  
                         != app_meet.scheduled_meeting_time__c && !app_meet.Scheduled_Meeting_time__c.equalsignorecase(UtilConstants.NON_STD_CALL_TIME)
                         ){
    string timetostart=UtilConstants.EMPTY_STRING;
    string minutes = UtilConstants.ZERO;
    string seconds = UtilConstants.ZERO;
    TimeZone tz = UserInfo.getTimeZone();
    integer hourstoadd = 0;
    integer minutestoadd = 0;
     if(!Test.isRunningTest()){
        string usertimezone = string.valueof(userinfo.getTimeZone());
        Time_Zone_settings__c custsettime = Time_Zone_settings__c.getValues(usertimezone);
        hourstoadd = integer.valueof(custsettime.hours__c);
        minutestoadd =integer.valueof(custsettime.minutes__c);
     }
    date dt = app_meet.Requested_Meeting_Date__c;
     string abc = string.valueOf(app_meet.scheduled_Meeting_Time__c);
     //system.debug('abc>>>>>>'+abc);
                        for(string s : abc.split(UtilConstants.PATTRN)){
                        //system.debug('s>>>>>>'+s);
                            if(s.isNumeric()){
                                timetostart = timetostart+s;
                                if(timetostart== UtilConstants.TWO_THREE_ZERO){
                                    timetostart = UtilConstantsforSWB.zerotwo;
                                    minutes = UtilConstants.THREE_ZERO;
                                }
                            }
                            //added by SWB 580
                            if(timetostart.equals(UtilConstants.EMPTY_STRING)){
                                timetostart=UtilConstants.ZERO;
                            }
                        }
                 datetime dt1 = Datetime.newInstance(dt.year(),dt.month(),dt.day(),Integer.valueof(timetostart),integer.valueof(minutes),integer.valueof(seconds)); 
                   dt1 = dt1.addhours(hourstoadd);
                   dt1 = dt1.addminutes(minutestoadd);
                         app_meet.Scheduled_Start__c = dt1;
                         app_meet.Scheduled_End__c = app_meet.Scheduled_Start__c.addHours(1);
                         }
                  if(app_meet.Scheduled_Meeting_time__c.equalsignorecase(UtilConstants.NON_STD_CALL_TIME)){
                    app_meet.Scheduled_Start__c = null;
                    app_meet.Scheduled_End__c = null;
                  } 
                         
                          applist.add(app_meet);
                        }
                    }
                    
                    else if(app_meet.Meeting_Status__c.equalsignorecase(label.Approval_Meeting_submitted) &&
                            oldmap.get(app_meet.id).meeting_status__c.equalsignorecase(label.Approval_Meeting_submitted)
                             && profilename.equalsIgnoreCase(Label.Solution_Operations_Profile_Name)
                           ){
                           //system.debug('entered solution operations block');
                        if(app_meet.requested_meeting_time__c != app_meet.scheduled_meeting_time__c && 
                            app_meet.scheduled_meeting_time__c !=null){
                           /* system.debug('entered not equal block');
                            system.debug('scheduele value-->'+app_meet.scheduled_meeting_time__c);
                            system.debug('req previous value--->'+app_meet.requested_meeting_time__c);*/
                            app_meet.requested_meeting_time__c = app_meet.scheduled_meeting_time__c ;
                           // system.debug('req after value--->'+app_meet.requested_meeting_time__c);
                       }
                       
                         if((oldmap.get(app_meet.id).scheduled_meeting_time__c  
                         != app_meet.scheduled_meeting_time__c) &&(!app_meet.Scheduled_Meeting_time__c.equalsignorecase(UtilConstants.NON_STD_CALL_TIME))
                         ){
                       //system.debug('entered equal block');
                        string timetostart=UtilConstants.EMPTY_STRING;
                        string minutes = UtilConstants.ZERO;
                        string seconds = UtilConstants.ZERO;
                        TimeZone tz = UserInfo.getTimeZone();
                        integer hourstoadd = 0;
                        integer minutestoadd = 0;
         if(!Test.isRunningTest()){
            string usertimezone = string.valueof(userinfo.getTimeZone());
            Time_Zone_settings__c custsettime = Time_Zone_settings__c.getValues(usertimezone);
            hourstoadd = integer.valueof(custsettime.hours__c);
            minutestoadd =integer.valueof(custsettime.minutes__c);
         }
        date dt = app_meet.Requested_Meeting_Date__c;
            string abc = string.valueOf(app_meet.scheduled_Meeting_Time__c);
                        for(string s : abc.split(UtilConstants.PATTRN)){
                            if(s.isNumeric()){
                                timetostart = timetostart+s;
                                if(timetostart== UtilConstants.TWO_THREE_ZERO){
                                    timetostart = UtilConstantsforSWB.zerotwo;
                                    minutes = UtilConstants.THREE_ZERO;
                                }
                            }
                        }
                 datetime dt1 = Datetime.newInstance(dt.year(),dt.month(),dt.day(),Integer.valueof(timetostart),integer.valueof(minutes),integer.valueof(seconds)); 
                   dt1 = dt1.addhours(hourstoadd);
                   dt1 = dt1.addminutes(minutestoadd);
                         app_meet.Scheduled_Start__c = dt1;
                         app_meet.Scheduled_End__c = app_meet.Scheduled_Start__c.addHours(1);
                         }
                  if(app_meet.Scheduled_Meeting_time__c.equalsignorecase(UtilConstants.NON_STD_CALL_TIME)){
                    app_meet.Scheduled_Start__c = null;
                    app_meet.Scheduled_End__c = null;
                  } 
                   if(oldmap.get(app_meet.id).Override_Apvr_Suggestion__c==app_meet.Override_Apvr_Suggestion__c 
                   && app_meet.scheduled_start__c != null && app_meet.scheduled_end__c !=null &&
                           app_meet.scheduled_meeting_time__c !=null){
                   
                        app_meet.Meeting_Status__c = label.Approval_Meeting_scheduled;
                         if(usMasterId !=null && app_meet.Meeting_Status__c.equalsignorecase(label.Approval_Meeting_scheduled)){
                        app_meet.Scheduled_By__c = usMasterId;
                        }
                    }
                        applist.add(app_meet);
                        //system.debug('list to update'+applist);
                    }
                    else{
                    
                    }
                   
                }
            }
            if(applist.size() >0){
                 update applist;
                 //system.debug('entered the update logic'+applist);
                sendMailWhenSubmitted(applist,oldMap);
                //System.assertequals(uresult.size(),applist.size());
            }
            else{
                sendMailWhenSubmitted(newlist,oldmap);
            }
            
          }
          Catch(DMLException e)
          {
                     //system.debug('E==='+e);    
           String str = e.getMessage() + e.getStackTraceString();
      
          }
        }
            /************
                @description : method to populate meeting description
    
            **************/
        public string populateMeetingDescription(string OppURL,string oppname,string sharepointURL,
               string oppsollead,string offering,string delivery_locations,string primesdolead){
                string description = UtilConstants.STR3+OppURL+UtilConstants.STR31+oppName+
                UtilConstants.STR32+sharepointURL+
                UtilConstants.STR31+SharepointURL+
                UtilConstants.STR331+oppsollead+UtilConstants.STR33+offering+
                UtilConstants.STR333+delivery_locations+UtilConstants.STR3333+
                primesdolead+UtilConstants.STR333333;
                   //<a href='+lyncconf_link+'>'+lyncconf_link+'</a>
            return description;
        }
        /*********************
            @desctiption : method to add events to attendees,requestor and Approver
        **************************/
       /* public void createeventattendees(List<Approval_Meeting__c> changedattendees_List){
            list<string> app_meetingsids = new list<string>();
            list<string> addattendees = new list<string>();
            set<string> list_attendeesemail = new set<string>();
            list<Approval_Meeting__C> list_requestors_approvers = new list<Approval_Meeting__C>();
            list<event> events_tosave = new list<event>();
            
            try{
            for(Approval_Meeting__c app_meet : changedattendees_List){
                app_meetingsids.add(app_meet.id);
                addattendees = app_meet.attendees__c.split(',');
            }
            list_attendeesemail.addall(addattendees);
                ////system.debug('Meeting Approver list '+changedattendees_List);
            for(Approval_Meeting__c app: [select requestor__r.user__r.email,Meeting_Approver__r.approver__r.user__r.email from Approval_Meeting__c where id IN:changedattendees_List limit 1000]){
                list_attendeesemail.add(app.requestor__r.user__r.email);
                list_attendeesemail.add(app.Meeting_Approver__r.approver__r.user__r.email);
            }        
            ////system.debug('All emails:::::::::::::::::::::: '+list_attendeesemail);
            list<event> queryevents = [select id,whatid from event where whatid IN:app_meetingsids AND OwnerId !=:label.Public_calendar_id limit 1000];
            if(queryevents.size() != list_attendeesemail.size()){
                 Database.DeleteResult [] dresult = database.delete(queryevents);
            }
            event ev;
            list<user> userqueried = [select id from user where email IN:list_attendeesemail AND isactive=:true limit 1000];
            ////system.debug('users queried :::::::::::::::::::::: '+userqueried);
                if(changedattendees_List.size() > userqueried.size()){
                    for(Approval_Meeting__c app_meet : changedattendees_List){
                        for(user u : userqueried){
                            ev = new event();
                            ev.WhatId = app_meet.Approval_Stage__r.opportunity__c;
                            
                            ev.StartDateTime = app_meet.Scheduled_Start__c;
                            ev.EndDateTime = app_meet.Scheduled_End__c;
                            ev.OwnerId = u.id;
                            ev.Subject = app_meet.Meeting_subject__c;
                            ev.Type = UtilConstants.MEETING;
                            ev.Client__c=app_meet.Client_Name__c;
                            ev.Approver__c=app_meet.Meeting_Approver__r.name;
                            ev.Opportunity_Solution_Lead__c=app_meet.Approval_Stage__r.opportunity__r.Opportunity_Solution_Lead__c;
                            events_tosave.add(ev);
                        }
                    }
                }
                else{
                        for(user u : userqueried){
                        for(Approval_Meeting__c app_meet : changedattendees_List){
                            ev = new event();
                            ev.WhatId = app_meet.Approval_Stage__r.opportunity__c;
                            ev.StartDateTime = app_meet.Scheduled_Start__c;
                            ev.EndDateTime = app_meet.Scheduled_End__c;
                            ev.OwnerId = u.id;
                            ev.Subject = app_meet.Meeting_subject__c;
                            ev.Type = UtilConstants.MEETING;
                            ev.Client__c=app_meet.Client_Name__c;
                            ev.Approver__c=app_meet.Meeting_Approver__r.name;
                            ev.Opportunity_Solution_Lead__c=app_meet.Approval_Stage__r.opportunity__r.Opportunity_Solution_Lead__c;
                            events_tosave.add(ev);
                        }
                    }            
                }
                if(events_tosave.size()>0){
                    upsert events_tosave Approval_meeting__c;
                    ////system.debug('Events saved for attendees '+sresult);
                }
            }
            
            catch(exception e){
                string exceptioncaught = string.valueof(e);
            }
        }*/
        
        /************
                @description : method to repopulate meeting description with updated
                               Lync Conference details
            **************/
        public void repopulateMeetingDescription(List<Approval_meeting__c> appmeetinglist){
            List<Approval_meeting__c> approvalrecords = [select id,meeting_description__c,Solution_A_New__c,Service_Group__c,approval_stage__r.opportunity__c,scheduled_meeting_time__c from approval_meeting__c where id IN:appmeetinglist limit 2500];
            set<id> oppNames = new set<id>();
            List<Approval_meeting__c> records_toupdate = new List<Approval_meeting__c>();
            set<string> meetingtimes =new set<string>();
            map<string,Meeting_Lync_Details__c> lyncMap = new map<string,Meeting_Lync_Details__c>();
            map<string,opportunity> oppMap = new map<string,opportunity>();
            for(Approval_meeting__c app : approvalrecords){
               oppNames.add(app.approval_stage__r.opportunity__c);
                meetingtimes.add(app.Scheduled_Meeting_Time__c.toLowercase().trim());
            }
            for(Opportunity opp : [Select id,Name,Link_to_SharePoint_Documents__c,Opportunity_Solution_Lead__c,Opportunity_Solution_Lead__r.name,IO_Solution_Architect__c,IO_Solution_Architect__r.name,Off__c,Offerings_IO__c,Delivery_Locations_IO__c,Delivery_Locations__c,Prime_SDO_Lead_dev__c,Prime_SDO_Lead_IO_dev__c From Opportunity where ID In : oppNames LIMIT 5000]){
               oppMap.put(opp.id, opp);                        
            }
            for(Meeting_Lync_Details__c lync : [select id,name,lync__c,Service_Group__c from Meeting_Lync_Details__c limit 10]){
                string lyncName = lync.name;
               lyncName = lyncName.trim();
               lyncName = lyncName.tolowercase();
               String serGrp=lync.Service_Group__c;
               serGrp=serGrp.trim();
               serGrp=serGrp.tolowercase();
                    //system.debug('lync name::::'+lyncName);
                    //system.debug('lync name::::'+lyncName +' serGrp'+serGrp );
                    lyncMap.put(lyncName+utilconstants.HYPHEN+serGrp,lync);
                    
            }
            Meeting_Lync_Details__c lyncUrl = new Meeting_Lync_Details__c();
          
            
            for(Approval_meeting__c app_meet : approvalrecords){
                opportunity opp;
                if(oppMap.containskey(app_meet.approval_stage__r.opportunity__c)){
                        opp = new opportunity();
                        opp = oppMap.get(app_meet.approval_stage__r.opportunity__c);
                        
                        String SharepointURL = UtilConstants.EMPTY_STRING;
                        string offering = UtilConstants.EMPTY_STRING;
                        string delivery_locations =UtilConstants.EMPTY_STRING;
                        string oppsollead = UtilConstants.EMPTY_STRING;
                        string primesdolead = UtilConstants.EMPTY_STRING;
                        if(opp.Link_to_SharePoint_Documents__c != null){
                            SharepointURL = opp.Link_to_SharePoint_Documents__c;
                            sharepointURL = sharepointURL.replaceAll(UtilConstants.SPACE_EMPTY,UtilConstants.SINGLE_SPACE );
                        }
                        if(app_meet.Service_Group__c.Contains(utilconstants.BPO) && opp.Opportunity_Solution_Lead__r.name != null){
                            oppsollead = opp.Opportunity_Solution_Lead__r.name;
                        }
                        if(app_meet.Service_Group__c.Contains(utilconstants.IO) && opp.IO_Solution_Architect__r.name != null){
                            oppsollead = opp.IO_Solution_Architect__r.name;
                        }
                        If(app_meet.Service_Group__c.Contains(utilconstants.BPO) && opp.Off__c != null){
                        //if(opp.Off__c != null){
                            offering = opp.off__c;
                        }
                        If(app_meet.Service_Group__c.Contains(utilconstants.IO) && opp.Offerings_IO__c != null){
                        //if(opp.Offerings_IO__c != null){
                            offering = opp.Offerings_IO__c;
                            }
                
                        if(app_meet.Service_Group__c.Contains(utilconstants.BPO) && opp.Delivery_Locations__c != null){
                           delivery_locations = opp.Delivery_Locations__c;
                        }
                        if(app_meet.Service_Group__c.Contains(utilconstants.IO) && opp.Delivery_Locations_IO__c != null){
                           delivery_locations = opp.Delivery_Locations_IO__c;
                        }
                    ////system.debug('prime sdo lead::::'+opp.prime_sdo_lead_dev__c);
                        if(opp.prime_sdo_lead_dev__c != null && opp.Prime_SDO_Lead_IO_dev__c != null){
                           primesdolead  = opp.prime_sdo_lead_dev__c+utilconstants.SEMICOLON_STRING+opp.Prime_SDO_Lead_IO_dev__c;
                    }
                   else if(opp.prime_sdo_lead_dev__c != null){
                           primesdolead  = opp.prime_sdo_lead_dev__c;
                    }
                    else if(opp.Prime_SDO_Lead_IO_dev__c != null){
                           primesdolead  = opp.Prime_SDO_Lead_IO_dev__c;
                    }else{}
                    //system.debug('meeting time to lower case:::'+app_meet.scheduled_meeting_time__c.tolowercase().trim());
                    //system.debug('app_meet.Service_Group__c.tolowercase().trim()32324- '+app_meet.Service_Group__c.tolowercase().trim());
                    //system.debug('lyncMap.get(app_meet.scheduled_meeting_time__c.tolowercase().trim()---32323-----'+lyncMap.get(app_meet.scheduled_meeting_time__c.tolowercase().trim()+'-'+'bpo'));
                    if(app_meet.Service_Group__c.tolowercase().trim().contains(utilconstants.BPO.tolowercase())){
                        lyncUrl = lyncMap.get(app_meet.scheduled_meeting_time__c.tolowercase().trim()+utilconstants.HYPHEN+utilconstants.BPO.tolowercase());
                     }
                     else{
                     lyncUrl = lyncMap.get(app_meet.scheduled_meeting_time__c.tolowercase().trim()+UtilConstants.HYPHEN+utilconstants.IO.tolowercase());
                     }
                    //system.debug('lync details::::'+lyncUrl);
                    
                    if(lyncUrl != null){
                        app_meet.Meeting_Description__c = UtilConstants.STR3+URL.getSalesforceBaseUrl().toExternalForm()+
                            UtilConstants.SLASH+opp.id+UtilConstants.GREATER_SYM+
                            opp.Name+UtilConstants.STR32+sharepointURL+UtilConstants.GREATER_SYM+
                            SharepointURL+UtilConstants.STR331+app_meet.Solution_A_New__c+UtilConstants.STR33+offering+
                            UtilConstants.STR333+delivery_locations+UtilConstants.STR3333+primesdolead+
                            UtilConstants.STR333333+lyncUrl.lync__c+UtilConstants.GREATER_SYM+lyncUrl.lync__c+
                            UtilConstants.STR3333332;
                        records_toupdate.add(app_meet);
                    }
                    else{
                        app_meet.Meeting_Description__c =  UtilConstants.STR3+URL.getSalesforceBaseUrl().toExternalForm()+
                            UtilConstants.SLASH+opp.id+UtilConstants.GREATER_SYM+opp.Name+UtilConstants.STR32+sharepointURL+
                            UtilConstants.GREATER_SYM+SharepointURL+UtilConstants.STR331+oppsollead+UtilConstants.STR33+
                            offering+UtilConstants.STR333+delivery_locations+UtilConstants.STR3333+primesdolead+
                            UtilConstants.STRING123;
                                records_toupdate.add(app_meet);
                    }
                }      //<a href='+lyncconf_link+'>'+lyncconf_link+'</a>
            }
            //system.debug('records_toupdate>>>>>>>> '+records_toupdate);
            Database.saveResult[] updateDescription = Database.update(records_toupdate, false);
            //system.debug('updated details::::'+updateDescription);
        }
     /******************
    @ Description: method to check meeting values and send mails
    ************************/
        /*public void checkMeetingStatus(List<approval_meeting__c> MeetingList,Map<id,Approval_Meeting__c> oldmap){
             try{   
            string profilename = [select id,profile.name from user where id=:userinfo.getUserId() LIMIT 1].profile.name;
            list<approval_meeting__c> updateandsendmailList = new List<approval_meeting__c>();
            List<approval_meeting__c> sendEmailList = new List<approval_meeting__c>();
            for(Approval_meeting__c app_meet : meetinglist){
                if(app_meet.Scheduled_Start__c != null && (app_meet.Scheduled_Meeting_Time__c !=null || app_meet.Scheduled_Meeting_Time__c !=UtilConstants.EMPTY_STRING) &&
                  app_meet.Scheduled_End__c !=null && app_meet.Meeting_Approver__c != null && app_meet.Meeting_Status__c.equalsIgnorecase(UtilConstants.SUBMITTED) && profilename.equalsIgnoreCase(Label.Solution_Operations_Profile_Name)){
                    updateandsendmailList.add(app_meet);
                }
                else{
                    sendEmailList.add(app_meet);
                }
            }
            if(!sendEmailList.isEmpty()){
                sendMailWhenSubmitted(sendEmailList,oldmap);
            }
            if(!updateandsendmailList.isEmpty()){
                updateAndSendMail(updateandsendmailList,oldmap);
            }
          }
          Catch(Exception e)
          {*/
         /* if(e !=null){
              String Str=e.getMessage();
              }
               String str = e.getMessage() + e.getStackTraceString();
    
          } 
        }*/
        
        /************
        @description : update status to schedule and send mail
    ****************/
      /*  public void updateAndSendMail(List<approval_meeting__c> MeetingList,Map<id,Approval_Meeting__c> oldmap){
            List<approval_meeting__c> updateList = new List<Approval_meeting__c>();
            List<approval_meeting__c> updatenewList = new List<Approval_meeting__c>();
             
            for(Approval_meeting__c app_meet: [select id,Override_Apvr_Suggestion__c, meeting_status__c from Approval_Meeting__c where id IN:MeetingList LIMIT 5000]){
                //
                
                //system.debug('old Override_Apvr_Suggestion__c'+oldmap.get(app_meet.id).Override_Apvr_Suggestion__c);
                //system.debug('Override_Apvr_Suggestion__c'+app_meet.Override_Apvr_Suggestion__c);
              if(oldmap.get(app_meet.id).Override_Apvr_Suggestion__c==app_meet.Override_Apvr_Suggestion__c){
                  //system.debug('Scheduled meeting');
                //app_meet.Meeting_Status__c = Label.Approval_Meeting_scheduled;
                updateList.add(app_meet);
                }
                else{
                    //system.debug('Not Scheduled 1');
                    updatenewList.add(app_meet);
                }
            }
            try{
                if(updatelist.size() >0 ){
                //update updatelist;
                    sendMailWhenSubmitted(updatelist,oldmap);
                }
                else{
                    sendMailWhenSubmitted(updatenewList,oldmap);
                }
             }
            catch(exception e){
                //string ex = string.valueOf(e);
                 String str = e.getMessage() + e.getStackTraceString();
            }
            
        }*/
    }