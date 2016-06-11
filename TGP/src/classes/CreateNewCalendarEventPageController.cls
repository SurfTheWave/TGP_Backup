/*
Author : Mayank Tayal
Story  :   SOL_077
Description :As a PMO, I should be able to schedule approval meeting on a shared calendar 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Mayank Tayal    Sol_148                    5/15/2013          Sol UAM-Release 2
Mayank Tayal    SOL_154                    21 May 2013        Change in Flow for Meeting Request & Scheduling Call
Shridhar Patankar D-1832                   15 Oct 2013        Updated for Solution Leadership in Read only mode. 
*/
public class CreateNewCalendarEventPageController {
    private static final string CLASS_NAME = 'CreateNewCalendarEventPageController';
    private static final string METHOD_INSERT = 'saveEvent';
    public Calendar_Event__c newCalEvent{get;set;}
    public String meetingId{get;set;}
    public String calendarEventId{get;set;}
    public Boolean showMainMsg{get;set;}
    public Boolean mainMsg{get;set;}
    public Boolean regionMandatory{get;set;}
    public Boolean regionNotMandatory{get;set;}
    public String statusValue{get;set;}
    public String meetingDescription{get;set;}
    public Boolean ROFlag{get;set;}
    public Boolean EditFlag{get;set;}
    public String RunningUser {get;set;}
    public List<Review_Meeting_Request__c> meetingList{get;set;}
    public Review_Meeting_Request__c meetingRecord{get;set;}
    public String requesterEmailID{get;set;}
    public List<Approver_Master__c> appMas{get;set;}
    
    public Boolean continueSave{get;set;}
    public String[] approverList{get;set;}
    
    public Boolean inviteeSecVisible{get;set;}
    
    public String sectionTitle{get;set;}
    public String strUrl{get;set;}
    public Boolean redirect{get;set;}
    
    public Boolean showOppSection{get;set;}
    public Boolean headValue{get;set;}
    public Boolean sideValue{get;set;}
    public Boolean meetIDEdit{get;set;}
    public Boolean meetIDRead{get;set;}
    public Boolean addButtonRender{get;set;}
    public Boolean showForm{get;set;}
    public Boolean showFormMsg{get;set;}
    public Boolean showerrorMsg{get;set;}
    public String readOnlyMeetingID{get;set;}
    
    public List<Opportunity_TGP__c> opportunityList{get;set;}
    public Opportunity_TGP__c opportunityRecord{get;set;}
    
    public string strStartDate{get;set;}
    public string strEnddate{get;set;}
    
    public String ApproverOnEdit{get;set;}
    
    public Boolean saveButtonVisibility;
    
    public void mailers()
    {
       SendEmailForFollowingWeekScheduler.sendEmail7Days();
       SendEmailFor24HoursScheduler.sendEmail24Hours();          
    }        
    public void chkMail()
    {
        /*for(MEC_Post_Contract_End_User_Questionnaire__c s:[select id from MEC_Post_Contract_End_User_Questionnaire__c limit 90])
            delete s;*/
        //SendEmailForFollowingWeekScheduler.sendEmail7Days();
        Event e1=new Event();
        e1.OwnerId = UserInfo.getUserId();
        e1.Subject = 'Test Event-4 Jun';
        e1.StartDateTime =DateTime.parse('6/4/2013 9:10 AM');
        e1.EndDateTime =DateTime.parse('6/4/2013 10:10 AM');
        try{
        insert e1;
        }catch(Exception ex)
        {
            
        }
        
        /*Document doc1=new Document();
        doc1.AuthorId = UserInfo.getUserId();
        doc1.FolderId = UserInfo.getUserId();
        doc1.Url=URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.OutlookEvent?id='+e.id;
        doc1.name='Event File'+e.id;
        insert doc1;*/        
        PageReference pdf =  new PageReference('/servlet/servlet.OutlookEvent?id='+e1.id);//00UL0000001XgmwMAC');
        
        //pdf.getParameters().put('id',(String)account.id); 
        pdf.setRedirect(true);
        // Take the PDF content
        Blob b;
        If(Test.isRunningTest()==False)
        {
        b = pdf.getContent();
        }
        else
        b=Blob.valueOf('data');
        // Create the email attachment
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('attachment.vcs');
        efa.setBody(b);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Test Attachment Mail');
        mail.setToAddresses( new String[]{'bpo_swb@accenture.com'} );
        mail.setPlainTextBody('Test Mailers Attachment');

        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

        // Sends the email
        Messaging.SendEmailResult [] r = 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
    /*
    @future (callout=true)
    public static void eventMail(String eventID)
    {
        
        //for(Integer i=0;i<10000;i++)
            
        try
        {
            List<String> mailToAddresses=new List<String>();
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
            //PageReference pdf =  new PageReference(strUrl+'/servlet/servlet.OutlookEvent?id='+eventID.trim());
            PageReference pdf =  new PageReference('https://c.cs8.visual.force.com/servlet/servlet.OutlookEvent?id='+eventID);//00UL0000001Xj52MAC');//+eventID+'&un=mayank.tayal%40accenture.com.trial.devwb&pw=mayank23');//00UL0000001XgmwMAC');
            
            pdf.setRedirect(true);
            Blob b;  
            If(Test.isRunningTest()==False)
            {          
            b = pdf.getContent();
            }
            else
            b=Blob.valueOf('data');
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('Calendar.vcs');
            efa.setBody(b);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[]{'bpo_swb@accenture.com'});
            //mail.setSenderDisplayName('BPO Solution Support');    
            String subject='Booking confirmed for requested slot!';
            mail.setSubject(subject);    
        
            mail.setHtmlBody('test mail');            
            mail.saveAsActivity=false;  
            system.debug('Test Mail');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(System.EmailException ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in sending mail!'));
            return;
        }
    }
    */
    /******************************
    Method Name: CreateNewCalendarEventPageController
    Description: Controller for initializing
    Paramenters: NA
    Return Value: void
    *******************************/
    public CreateNewCalendarEventPageController(ApexPages.StandardController controller) {
        
        saveButtonVisibility = true;
        showerrorMsg=false;
        strUrl = URL.getSalesforceBaseUrl().toExternalForm();
        ROflag=false;
        EditFlag=true;
        setDescription(); 
        ApproverOnEdit = '';
        //meetingId=ApexPages.CurrentPage().getParameters().get('meetID');
        meetingId=ApexPages.CurrentPage().getParameters().get('calID');
        calendarEventId=ApexPages.CurrentPage().getParameters().get('id');
        
        if(calendarEventId!=null)
        {
            List<Event> eventExist=[select id, Meeting_Record_ID__c, Meeting_ID__c from Event where id=:calendarEventId];
            if(eventExist!=null && eventExist.size()>0)
            {
                meetingId=eventExist[0].Meeting_Record_ID__c;
            }
        }
        newCalEvent = new Calendar_Event__c();
        if(meetingId!=null)
        {
            List<Review_Meeting_Request__c> revProc=[select Client_Name__c, Comments__c, Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c, Status__c, Meeting_Time__c, Meeting_Type__c,
                                                       Offering__c, id, Title__c, name, Opportunity_Solution_lead__c, Requester_User__c, LastModifiedDate, Requester_User__r.name, Client_Geo_Area__c, Complex_Cost_Architect__c,
                                                       Client_Geo_Unit__c, Operating_Group__c, TCV_M__c, Estimated_TCV_M__c, Prime_SDO_Lead_M__c, Opportunity_ID__c, BPO_Opportunity__c, Review_Process__r.Review_Stage_Master__r.name
                                                       from Review_Meeting_Request__c where id=:meetingId];
            if(revProc.size()>0)
            {
                meetingRecord=revProc[0];
                opportunityList=[select id, name, Client_Name__r.name, SAP_OM_Opportunity__r.name,  Enterprise_Solution_Architect_New__c,Enterprise_Solution_Architect_New__r.SFDC_User__c, 
                             Enterprise_Solution_Architect_New__r.Name, Client_Geo_Area__r.name, Client_Geo_Unit__r.name, 
                                Operating_Group__r.name, TCV__c from Opportunity_TGP__c where id=:meetingRecord.BPO_Opportunity__c];
                if(opportunityList.size()>0)
                {
                    opportunityRecord=opportunityList[0];
                }
                showOppSection=true;
                if(meetingRecord.Status__c=='Submitted')
                {
                    newCalEvent.Assigned_To__c=UserInfo.getUserID();
                    newCalEvent.Review_Meeting_Request__c=meetingRecord.id;
                    newCalEvent.TCV__c=meetingRecord.TCV_M__c;
                    newCalEvent.Estimated_TCV__c=meetingRecord.Estimated_TCV_M__c;
                    newCalEvent.Prime_SDO_Lead__c=meetingRecord.Prime_SDO_Lead_M__c;
                    newCalEvent.Region__c=meetingRecord.Client_Geo_Area__c;
                    newCalEvent.Subject__c=meetingRecord.Title__c;
                    date d=meetingRecord.Preferred_Meeting_Date_del__c;
                    String strConvertedDate =d.format();
                    if(meetingRecord.Meeting_Time__c=='EMEA (7am CST)')
                    {
                        newCalEvent.Start_Date__c=DateTime.parse(strConvertedDate+' 7:00 AM');
                        newCalEvent.End_Date__c=DateTime.parse(strConvertedDate+' 8:00 AM');
                    }
                    if(meetingRecord.Meeting_Time__c=='APAC (2:30 am CST)')
                    {
                        newCalEvent.Start_Date__c=DateTime.parse(strConvertedDate+' 2:30 AM');
                        newCalEvent.End_Date__c=DateTime.parse(strConvertedDate+' 3:30 AM');
                    }
                    if(meetingRecord.Meeting_Time__c=='North America (10am CST)')
                    {
                        newCalEvent.Start_Date__c=DateTime.parse(strConvertedDate+' 10:00 AM');
                        newCalEvent.End_Date__c=DateTime.parse(strConvertedDate+' 11:00 AM');
                    }
                    if(meetingRecord.Meeting_Time__c=='LATAM (8 am CST)')
                    {
                        newCalEvent.Start_Date__c=DateTime.parse(strConvertedDate+' 8:00 AM');
                        newCalEvent.End_Date__c=DateTime.parse(strConvertedDate+' 9:00 AM');
                    }
                    sectionTitle='New Event';
                    headValue=true;
                    sideValue=true;
                    meetIDEdit=true;
                    meetIDRead=false;
                    newCalEvent.Description__c=meetingDescription; 
                    fillApproverValue();                 
                }
                else
                {
                    List<Calendar_Event__c> calEvent=[select All_Day_Event__c, Approver_Master__c, Description__c, Assigned_To__c,  End_Date__c, Location__c,
                                                Review_Meeting_Request__c, Review_Meeting_Request__r.name, Region__c, Reminder__c, Reminder_Values__c, Show_Time_As__c, Start_Date__c, Subject__c,
                                                TCV__c, Estimated_TCV__c, Prime_SDO_Lead__c, Additional_Invitees__c, id, name from Calendar_Event__c where Review_Meeting_Request__c=:meetingRecord.id];
                    if(calEvent.size()>0)
                    {
                        newCalEvent = calEvent[0];
                        sectionTitle='Edit Event';
                        regionMandatory = false;
                        regionNotMandatory=true; 
                        readOnlyMeetingID=newCalEvent.Review_Meeting_Request__r.name;
                        headValue=false;
                        sideValue=false;
                        meetIDEdit=false;
                        meetIDRead=true;
                        String otherApprovers=calEvent[0].Additional_Invitees__c;
                        ApproverOnEdit = newCalEvent.Approver_Master__c;
                        newCalEvent.Description__c=meetingDescription;
                        if(otherApprovers!=null)
                        {
                            String[] lstOtherApprovers=otherApprovers.split(' ;');
                            List<Approver_Master__c> approverMasterList = [select id, name, Approver_Mail_ID__c, IS_SFDC_User__c, Comments__c from Approver_Master__c];
                            approverList=new String[]{};
                            if(lstOtherApprovers!=null)
                            {
                                inviteeSecVisible=true;
                                if(lstOtherApprovers.size()>0)
                                {
                                    for(String s: lstOtherApprovers)
                                    {
                                        for(Approver_Master__c a: approverMasterList )
                                        {
                                            if(a.name==s.trim())
                                                approverList.add(a.id);
                                        }
                                    }
                                }
                            }
                        }
                    }                   
                }
                //fillApproverValue();
            }
        }
        else
        {
            newCalEvent.Assigned_To__c=UserInfo.getUserID();
            newCalEvent.Description__c=meetingDescription;
            sectionTitle='New Event';
            showOppSection=false;
            headValue=true;
            sideValue=true;
            meetIDEdit=true;
            meetIDRead=false;           
        }               
        initializePageMessages();
        continueSave=true;
        
        //UAM Code--Mayank Tayal-Sol_148        
        /* UAM Sol RV List<userRole> role = [select id,name from userRole where id=:UserInfo.getUserRoleId()];  
        // UAM Code -- Hareesh
        String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name; //Get users with Profile Name
        if(userProfileName.equalsIgnoreCase('Workbench Administrator')) {
            addButtonRender=true; 
            showForm=true;
            showFormMsg=false;
        }
        else if(role.size()>0)
        {
            if(role[0].name!=null && role[0].name.equalsIgnoreCase('Operations'))
            {
                addButtonRender=true; 
                showForm=true;
                showFormMsg=false;             
            }
            else if(role[0].name!=null && role[0].name.equalsIgnoreCase('Solution Leadership'))
            {
                showForm=true;
                showFormMsg=false;  
                ROflag=true;
                EditFlag=false;
            }
            else 
            {            
                showFormMsg=true;
                showForm=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Insufficient Privileges!'));
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You do not have the level of access necessary to perform the operation you requested. '));               
            }
        } 
        
        else
        {
            showFormMsg=true;
            showForm=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Insufficient Privileges!'));
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You do not have the level of access necessary to perform the operation you requested. '));            
        }*/
        
        String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name; //Get users with Profile Name
        if(userProfileName.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)) {
            addButtonRender=true; 
            showForm=true;
            showFormMsg=false;
        }
        else
        {
            showFormMsg=true;
            showForm=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Insufficient Privileges!'));
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You do not have the level of access necessary to perform the operation you requested. '));            
        }
    }
    
    /******************************
    Method Name: initializePageMessages
    Description: Initializing the display for Page Messages
    Paramenters: NA
    Return Value: void
    *******************************/
    public void initializePageMessages()
    {
        showMainMsg=false;
        mainMsg=false;
        showerrorMsg=false;
    }
    
    /******************************
    Method Name: setDescription
    Description: Setting the Description
    Paramenters: NA
    Return Value: void
    *******************************/
    public void setDescription()
    {
         meetingDescription='Join Online Meeting (Lync Conferencing details)<br/><br/>'+
                            'EMEA Call  slot 7:00am CST <br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/4GCPP353 <br/>'+
                            'Conference ID: 185759473 <br/><br/>'+
                            'LATAM Call slot 8:00am  CST<br/>'+ 
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/DD56C1Y8<br/>'+
                            'Conference ID: 403604928<br/><br/>'+ 
                            'North America Call slot 10:00am  CST<br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/NML8V9VL <br/>'+
                            'Conference ID: 127058362<br/><br/>'+
                            'APAC Call slot 2:30am CST<br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/HCG7FFFS <br/>'+
                            'Conference ID: 960381695 <br/><br/>'+
                            'Non Standard Call Time<br/>'+
                            'Lync: https://Lync.accenture.com/meet/reena.kushalappa/H2Z3WF4V <br/>'+
                            'Conference ID: 70925039 <br/><br/>'+
                            'Find a local number <br/>'+
                            'Lync: https://Lync.accenture.com/dialin <br/><br/>'+
                            'Join by Phone <br/>'+
                            '+1 703 948 0488 (Sterling, United States)  <br/>'+   
                            '+91 80 6160 7676 (Bangalore, India) <br/>'+    
                            '+63 2 720 7300 (Manila, Philippines)<br/>'+   
                            '+44 20 3335 5555 (London, United Kingdom)<br/>'+     
                            '+39 0236005680 (Milan, Italy)<br/>'+
                            '+91 22 6160 7676 (Mumbai, India)<br/>'+
                            '+34 91 114 3650 (Madrid, Spain)<br/>'+
                            '+55 11 3130 0000 (Sao Paulo, Brazil)<br/>'+ 
                            '+54 114318 8600 (Buenos Aires, Argentina) <br/>'+     
                            '+81 3 3588 4460 (Tokyo, Japan)<br/>'+
                            '+49 9281 925 3543 (Hof, Germany)<br/>'+
                            '+33 1 5323 3939 (Paris, France)<br/>'+
                            '+31 20 343 2734 (Amsterdam, Netherlands)  <br/>'+    
                            '+86 21 61577600 (Shanghai, China)<br/>'+
                            '+65 6603 2222 (Singapore, Singapore)';
    }
    
    /******************************
    Method Name: fillApproverValue
    Description: Method for getting Approver values based on TCV and Region values
    Paramenters: NA
    Return Value: void
    *******************************/
    public void fillApproverValue()
    {
        initializePageMessages();
        List<Approver_Master__c> appMas = [select id, name, TCV_Range__c, IS_SFDC_User__c, Region__c, Approver_Mail_ID__c from Approver_Master__c];
        if(newCalEvent.TCV__c >= 100000)
        {
            regionMandatory=false;
            regionNotMandatory=true;                       
            if(appMas.size()>0)
            {
                for(Approver_Master__c app: appMas)
                {
                    if(app.TCV_Range__c=='100M+')
                        newCalEvent.Approver_Master__c = app.id;
                }                
            }                
        }
        else if(newCalEvent.TCV__c < 100000 && newCalEvent.TCV__c >= 40000)
        {
            regionMandatory=false;
            regionNotMandatory=true;
            /*if(appMas.size()>0)
            {
                for(Approver_Master__c app: appMas)
                {
                    if(app.TCV_Range__c=='40-100M')
                        newCalEvent.Approver_Master__c = app.id;
                }                
            }*/ 
           if(newCalEvent.Region__c == 'North America')
           {
                if(appMas.size()>0)
                {
                    for(Approver_Master__c app: appMas)
                    {
                        if(app.TCV_Range__c=='40-100M' && app.Region__c=='North America')
                            newCalEvent.Approver_Master__c = app.id;
                    }                
                }               
           } 
           if(newCalEvent.Region__c == 'EMEA')
           {
                if(appMas.size()>0)
                {
                    for(Approver_Master__c app: appMas)
                    {
                        if(app.TCV_Range__c=='40-100M' && app.Region__c=='EMEA')
                            newCalEvent.Approver_Master__c = app.id;
                    }                
                }                
           } 
           if(newCalEvent.Region__c == 'APAC')
           {
                if(appMas.size()>0)
                {
                    for(Approver_Master__c app: appMas)
                    {
                        if(app.TCV_Range__c=='40-100M' && app.Region__c=='APAC')
                            newCalEvent.Approver_Master__c = app.id;
                    }                
                }               
           } 
           if(newCalEvent.Region__c == 'Latin America')
           {
                if(appMas.size()>0)
                {
                    for(Approver_Master__c app: appMas)
                    {
                        if(app.TCV_Range__c=='40-100M' && app.Region__c=='Latin America')
                            newCalEvent.Approver_Master__c = app.id;
                    }                
                }               
           }             
        }
        else if(newCalEvent.TCV__c < 40000 && newCalEvent.TCV__c >= 10000)
        {
           regionMandatory=true;
           regionNotMandatory=false;
           newCalEvent.Approver_Master__c=null;
           if(newCalEvent.Region__c == 'North America')
           {
                if(appMas.size()>0)
                {
                    for(Approver_Master__c app: appMas)
                    {
                        if(app.TCV_Range__c=='10-40M' && app.Region__c=='North America')
                            newCalEvent.Approver_Master__c = app.id;
                    }                
                }               
           } 
           if(newCalEvent.Region__c == 'EMEA')
           {
                if(appMas.size()>0)
                {
                    for(Approver_Master__c app: appMas)
                    {
                        if(app.TCV_Range__c=='10-40M' && app.Region__c=='EMEA')
                            newCalEvent.Approver_Master__c = app.id;
                    }                
                }                
           } 
           if(newCalEvent.Region__c == 'APAC')
           {
                if(appMas.size()>0)
                {
                    for(Approver_Master__c app: appMas)
                    {
                        if(app.TCV_Range__c=='10-40M' && app.Region__c=='APAC')
                            newCalEvent.Approver_Master__c = app.id;
                    }                
                }               
           } 
           if(newCalEvent.Region__c == 'Latin America')
           {
                if(appMas.size()>0)
                {
                    for(Approver_Master__c app: appMas)
                    {
                        if(app.TCV_Range__c=='10-40M' && app.Region__c=='Latin America')
                            newCalEvent.Approver_Master__c = app.id;
                    }                
                }               
           } 
        }
        else if(newCalEvent.TCV__c < 10000 && newCalEvent.TCV__c >= 0)
        {
            regionMandatory=true;
            regionNotMandatory=false;
        }
        else
        {
            mainMsg=true;
            regionMandatory=false;
            regionNotMandatory=false;
            showerrorMsg=true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'TCV Value should be greater than or equal to 10M!'));
            return;
        }        
    }
    
    /******************************
    Method Name: getApprovers
    Description: This method is used to get list of all Approvers from Approver Master.  
    Paramenters: NA
    Return Value: List<SelectOption>
    *******************************/ 
    public List<SelectOption> getApprovers()
    {
        List<SelectOption> approver=new List<SelectOption>();       
        List<SAP_OM_Opportunity__c> sapOMOppList=[select id, name from SAP_OM_Opportunity__c]; 
        List<Approver_Master__c> approverMasterList = [select id, name, Approver_Mail_ID__c, IS_SFDC_User__c, Comments__c from Approver_Master__c order by name ASC];       
        if(approverMasterList.size()>0)
        {
             for(Approver_Master__c a : approverMasterList)
             {                 
                 approver.add(new SelectOption(a.id, a.name)); 
             }             
        }
        else
        {
            approver.add(new SelectOption('None','--None--'));
        }
        return approver;
    }
    
    /******************************
    Method Name: getStatusValues
    Description: This method is used to get list of all Approvers from Approver Master.  
    Paramenters: NA
    Return Value: List<SelectOption>
    *******************************/ 
    public List<SelectOption> getStatusValues()
    {
        List<SelectOption> status=new List<SelectOption>(); 
        status.add(new SelectOption('Scheduled', 'Scheduled'));
        status.add(new SelectOption('Cancelled', 'Cancelled'));             
        return status;
    }
    
    /******************************
    Method Name: changeMeeting
    Description: This method is used to get list of all Approvers from Approver Master.  
    Paramenters: NA
    Return Value: void
    *******************************/ 
    public void changeMeeting()
    {
        List<Review_Meeting_Request__c> revProc=[select Client_Name__c, Comments__c, Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c, Status__c, Meeting_Time__c, Meeting_Type__c,
                                                       Offering__c, id, Title__c, name, Opportunity_Solution_lead__c, Requester_User__c, LastModifiedDate, Requester_User__r.name, Client_Geo_Area__c, Complex_Cost_Architect__c,
                                                       Client_Geo_Unit__c, Operating_Group__c, TCV_M__c, Estimated_TCV_M__c, Prime_SDO_Lead_M__c, Opportunity_ID__c, BPO_Opportunity__c, Review_Process__c, Review_Process__r.Review_Stage_Master__r.name
                                                       from Review_Meeting_Request__c where id=:newCalEvent.Review_Meeting_Request__c];
        if(revProc.size()>0)
        {
            meetingRecord=revProc[0];
            opportunityList=[select id, name, Client_Name__r.name, SAP_OM_Opportunity__r.name, Enterprise_Solution_Architect_New__c, Enterprise_Solution_Architect_New__r.SFDC_User__c, 
                            Enterprise_Solution_Architect_New__r.name, Client_Geo_Area__r.name, Client_Geo_Unit__r.name, 
                                Operating_Group__r.name, TCV__c from Opportunity_TGP__c where id=:meetingRecord.BPO_Opportunity__c];
            if(opportunityList.size()>0)
            {
                opportunityRecord=opportunityList[0];
            }
            showOppSection=true;
            newCalEvent = new Calendar_Event__c();
            newCalEvent.Assigned_To__c=UserInfo.getUserID();
            newCalEvent.Review_Meeting_Request__c=meetingRecord.id;
            newCalEvent.TCV__c=meetingRecord.TCV_M__c;
            newCalEvent.Estimated_TCV__c=meetingRecord.Estimated_TCV_M__c;
            newCalEvent.Prime_SDO_Lead__c=meetingRecord.Prime_SDO_Lead_M__c;
            newCalEvent.Region__c=meetingRecord.Client_Geo_Area__c;
            newCalEvent.Subject__c=meetingRecord.Title__c;
            date d=meetingRecord.Preferred_Meeting_Date_del__c;
            String strConvertedDate =d.format();
            if(meetingRecord.Meeting_Time__c=='EMEA (7am CST)')
            {
                newCalEvent.Start_Date__c=DateTime.parse(strConvertedDate+' 7:00 AM');
                newCalEvent.End_Date__c=DateTime.parse(strConvertedDate+' 8:00 AM');
            }
            if(meetingRecord.Meeting_Time__c=='APAC (2:30 am CST)')
            {
                newCalEvent.Start_Date__c=DateTime.parse(strConvertedDate+' 2:30 AM');
                newCalEvent.End_Date__c=DateTime.parse(strConvertedDate+' 3:30 AM');
            }
            if(meetingRecord.Meeting_Time__c=='North America (10am CST)')
            {
                newCalEvent.Start_Date__c=DateTime.parse(strConvertedDate+' 10:00 AM');
                newCalEvent.End_Date__c=DateTime.parse(strConvertedDate+' 11:00 AM');
            }
            if(meetingRecord.Meeting_Time__c=='LATAM (8 am CST)')
                    {
                        newCalEvent.Start_Date__c=DateTime.parse(strConvertedDate+' 8:00 AM');
                        newCalEvent.End_Date__c=DateTime.parse(strConvertedDate+' 9:00 AM');
                    }
            meetingId=meetingRecord.id;
            if(meetingRecord.Status__c=='Scheduled' || meetingRecord.Status__c=='Cancelled')
            {
                statusValue=meetingRecord.Status__c;
                List<Calendar_Event__c> calEventList=[select All_Day_Event__c, Approver_Master__c, Description__c, Assigned_To__c,  End_Date__c, Location__c,
                                                Review_Meeting_Request__c, Review_Meeting_Request__r.name, Region__c, Reminder__c, Reminder_Values__c, Show_Time_As__c, Start_Date__c, Subject__c,
                                                TCV__c, Estimated_TCV__c, Prime_SDO_Lead__c, Additional_Invitees__c, id, name from Calendar_Event__c where Review_Meeting_Request__c=:meetingRecord.id];
                if(calEventList.size()>0)
                {
                    newCalEvent = calEventList[0];
                    //sectionTitle='Edit Event';
                    readOnlyMeetingID=newCalEvent.Review_Meeting_Request__r.name;
                    headValue=false;
                    sideValue=false;
                    meetIDEdit=false;
                    meetIDRead=true;                    
                    String otherApprovers=calEventList[0].Additional_Invitees__c;
                    if(otherApprovers!=null)
                    {
                        String[] lstOtherApprovers=otherApprovers.split(' ;');
                        List<Approver_Master__c> approverMasterList = [select id, name, Approver_Mail_ID__c, IS_SFDC_User__c, Comments__c from Approver_Master__c];
                        approverList=new String[]{};
                        if(lstOtherApprovers!=null)
                        {
                            inviteeSecVisible=true;
                            if(lstOtherApprovers.size()>0)
                            {
                                for(String s: lstOtherApprovers)
                                {
                                    for(Approver_Master__c a: approverMasterList )
                                    {
                                        if(a.name==s.trim())
                                            approverList.add(a.id);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            fillApproverValue();            
        }
    }
    
    /******************************
    Method Name: sendEmailToApprover
    Description: Method for sending the email Alerts-Form the message object
    Paramenters: NA
    Return Value: void
    *******************************/
    public void sendEmailToApprover(Set<String> mailAddresses, String eventID)
    {
        
        try
        {
            List<String> mailToAddresses=new List<String>();
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
            mailToAddresses.addAll(mailAddresses);
            
            //PageReference pdf =  new PageReference(strUrl+'/servlet/servlet.OutlookEvent?id='+eventID.trim());
            /*PageReference pdf =  new PageReference('https://cs8.salesforce.com/servlet/servlet.OutlookEvent?id='+eventID);//00UL0000001Xj52MAC');//+eventID+'&un=mayank.tayal%40accenture.com.trial.devwb&pw=mayank23');//00UL0000001XgmwMAC');
            pdf.setRedirect(true); 
            Blob b; 
            If(Test.isRunningTest()==False)
            {            
            b = pdf.getContent();
            }
            else
            b=Blob.valueOf('data');
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('Calendar.vcs');
            efa.setBody(b);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});*/
            //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(mailToAddresses);
            //mail.setSenderDisplayName('BPO Solution Support');    
            String subject='NOTIFICATION: Meeting confirmed for requested slot - Client Name:'+' '+meetingRecord.Client_Name__c+ ' '+'- Opportunity Name: '+meetingRecord.Opportunity_Name__c;
            mail.setSubject(subject);  
            string OfferingNames = checkNullValues(meetingRecord.Offering__c);
          
            string SolutionSpecialist= checkNullValues(meetingRecord.Solution_Specialist__c);
            
            TimeZone tz  = UserInfo.getTimeZone();
            String userTimeZone = UTIL_Constants.TIME_ZONE;
            if(tz != null)
            {
                userTimeZone = tz.getID();
            }
            strStartDate=newCalEvent.Start_Date__c.format('MM-dd-yyyy h:mm a',userTimeZone); 
            strEndDate= newCalEvent.End_Date__c.format('MM-dd-yyyy h:mm a',userTimeZone); 
            
            //strStartDate=newCalEvent.Start_Date__c.format('MM-dd-yyyy h:mm a','America/El_Salvador'); 
            //strEndDate= newCalEvent.End_Date__c.format('MM-dd-yyyy h:mm a','America/El_Salvador'); 
            
            mail.setHtmlBody
            (
                '<html>' +
                '    <body>' +
                '   <STYLE type="text/css">' +                
                '</STYLE>' +
                '<font face="Calibri (Body)" style="font-size:11pt">' +
                '<p>A new meeting request has been confirmed with following details: </p>' +
                '<table border="1" rules="rows" width="60%" cellpadding="5">' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Opportunity ID:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(meetingRecord.Opportunity_ID__c)+'</font>'+''+'</td>' +
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Client Name:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+meetingRecord.Client_Name__c+'</font>'+''+'</td>' +
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Opportunity Name:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+
                +
                '<a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/BPO_Opportunity_tab?id='+meetingRecord.BPO_Opportunity__c+'" target="_parent">'+meetingRecord.Opportunity_Name__c+'</a></font>'+''+'</td>' +
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Lead Solution Architect – BPO:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+meetingRecord.Opportunity_Solution_lead__c+'</font>'+''+'</td>' +
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Complex Cost Architect:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(meetingRecord.Complex_Cost_Architect__c)+'</font>'+''+'</td>' +
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Solution Specialist:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(SolutionSpecialist)+'</font>'+''+'</td>' +
                '</tr>' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Offering:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(OfferingNames)+'</font>'+''+'</td>' +
                '</tr>' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Client Geo Area:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(meetingRecord.Client_Geo_Area__c)+'</font>'+''+'</td>' +
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Client Geo Unit:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(meetingRecord.Client_Geo_Unit__c)+'</font>'+''+'</td>' +
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Operating Group:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(meetingRecord.Operating_Group__c)+'</font>'+''+'</td>' +
                '</tr>' +
                        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">BPO Net Revenue (SAP OM)<br/>(Thousands):</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+ checkNullValuesDeciamlTCV(newCalEvent.TCV__c) +'</font>'+''+'</td>' +
                '</tr>' +                
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Approver:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+appMas[0].name+'</font>'+''+'</td>' +
                '</tr>' +
                
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Review Name:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+meetingRecord.Review_Process__r.Review_Stage_Master__r.name+'</font>'+''+'</td>' +
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Scheduled By:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+findUserName(newCalEvent.Assigned_To__c)+'</font>'+''+'</td>' +
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Subject:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newCalEvent.Subject__c+'</font>'+''+'</td>' +
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Meeting Start:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+strStartDate+'&nbsp;&nbsp;CST</font>'+''+'</td>' +
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Meeting End:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+strEndDate+'&nbsp;&nbsp;CST</font>'+''+'</td>' +
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Status:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+meetingRecord.Status__c+'</font>'+''+'</td>' +
                '</tr>' +               
                
                '</table>' +        
        
                '<br/>' +
                '    <a href ="'+strUrl+'/apex/ApprovalProcessPage?meetID='+meetingRecord.id+'" target="_parent">Login to BPO Solution Workbench</a>' + '<a>(option for those who have a workbench license)</a>' +
                '    <p>This is a system generated message. Please do not reply to this message.</p>' +
               // '<b> Meeting Details:</b><br/><br/>'+checkNullValues(newCalEvent.Description__c)+ '<br/>'+
                '</font></body>' +
                '</html>'
            );
            //}
            mail.saveAsActivity=false;  
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(System.EmailException ex)
        {
            mainMsg=true;
            showerrorMsg=true;
            redirect=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in sending mail!'));
            return;
        }
    }
    
    /******************************
    Method Name: saveEvent
    Description: Method for saving the event and blocking the calendar
    Paramenters: NA
    Return Value: void
    *******************************/
    public void saveEvent()
    {
        
            initializePageMessages();
            
            System.debug('-------statusValue in saveEvent-------------'+statusValue);
            
            try
            {
                if(meetIDRead==true)
                {
                    //Deleting the Previous Calendar Event Record and Events
                    deleteEvent();
                }
                if(statusValue=='Cancelled')
                {
                    //Deleting the Calendar Event Record and Events
                    deleteEvent();
                    //Changing the status of the Meetings
                    meetingRecord.Status__c='Cancelled';
                    upsert meetingRecord;
                    mainMsg=true;
                    showerrorMsg=true;
                    redirect=true;
                    inviteeSecVisible=false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Meeting Request Cancelled Successfully!'));
                    newCalEvent = new Calendar_Event__c();
                    newCalEvent.Assigned_To__c=UserInfo.getUserID();
                    List<Review_Process__c> revProcList=[select id, name, Review_Date__c from Review_Process__c where id=:meetingRecord.Review_Process__c];
                    if(revProcList!=null && revProcList.size()>0)
                    {
                        List<Review_Meeting_Request__c> meetLists=[select id,name, Status__c, Review_Process__c from Review_Meeting_Request__c where Review_Process__c=:revProcList[0].id and Status__c=:'Scheduled' order by LastModifiedDate desc];
                        if(meetLists!=null && meetLists.size()>0)
                        {
                            List<Calendar_Event__c> calEventLst=[select id, name, Review_Meeting_Request__c, Start_Date__c from Calendar_Event__c where Review_Meeting_Request__c=:meetLists[0].id];
                            if(calEventLst!=null && calEventLst.size()>0)
                                revProcList[0].Review_Date__c=calEventLst[0].Start_Date__c;
                        }
                        else
                        {
                            revProcList[0].Review_Date__c=null;
                        }
                        upsert revProcList[0];
                    }
                    return;                
                }
            }
            catch(Exception e)
            {
                mainMsg=true;
                redirect=false;
                showerrorMsg=true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving after delete!'));
                return;
            }
            Set<String> mailAddresses =new Set<String>();
            Set<String> userIDsEvents=new Set<String>();
            
            if(newCalEvent.Start_Date__c==null)
            {
                mainMsg=true;
                showerrorMsg=true;
                redirect=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required Field Missing: [Start (Date/Time)]'));
                return;
            }
            if(newCalEvent.Subject__c=='' || newCalEvent.Subject__c==null)
            {
                mainMsg=true;
                showerrorMsg=true;
                redirect=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required Field Missing: [Subject]'));
                return;
            }
            if(newCalEvent.End_Date__c==null)
            {
                mainMsg=true;
                redirect=false;
                showerrorMsg=true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required Field Missing: [End (Date/Time)]'));
                return;
            }
            if(newCalEvent.Review_Meeting_Request__c==null)
            {
                mainMsg=true;
                showerrorMsg=true;
                redirect=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required Field Missing: [Meeting ID]'));
                return;
            }
            List<Review_Meeting_Request__c> meetingsLst=[select id, name from Review_Meeting_Request__c where Status__c=:'Submitted' and id=:newCalEvent.Review_Meeting_Request__c];
            //if(meetingsLst==null)
            //{
                if(meetingsLst.size()==0 && meetIDRead==false && meetIDEdit==true)
                {
                    mainMsg=true;
                    showerrorMsg=true;
                    redirect=false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The meeting with the meeting ID has already been scheduled!'));
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select different meeting ID or a new meeting request needs to be raised for this Opportunity!'));
                    return;
                }
            //}        
            /*if(newCalEvent.TCV__c==null)
            {
                mainMsg=true;
                redirect=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required Field Missing: [TCV]'));
                return;
            }*/
            if(newCalEvent.TCV__c <0)
            {
                mainMsg=true;
                showerrorMsg=true;
                redirect=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'TCV Value should be greater than or equal to 0M!'));
                return;
            }
            if(continueSave==false)
            {
                mainMsg=true;
                showerrorMsg=true;
                redirect=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please set the Approver Name to default value!'));
                return;
            }
            if(newCalEvent.TCV__c <= 40000 && newCalEvent.TCV__c >= 10000 && newCalEvent.Region__c==null)
            {
                mainMsg=true;
                showerrorMsg=true;
                redirect=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required Field Missing: [Region] for TCV Value: '+newCalEvent.TCV__c));
                return;
            }        
            appMas = [select id, name, IS_SFDC_User__c, TCV_Range__c, Region__c, Approver_Mail_ID__c from Approver_Master__c where id=:newCalEvent.Approver_Master__c];                
            getMeetingRecordDetails();
            
            newCalEvent.Estimated_TCV__c=meetingRecord.Estimated_TCV_M__c;
            newCalEvent.Prime_SDO_Lead__c=meetingRecord.Prime_SDO_Lead_M__c;
            
            List<Approver_Master__c> approverInviteeList=[select id, name, Approver_Mail_ID__c, IS_SFDC_User__c, Comments__c from Approver_Master__c];
            String approvers='';
            if(approverList!=null)
            {
                if(approverList.size()>0)
                {                
                    for(String s: approverList)
                    {
                        for(Approver_Master__c a: approverInviteeList)
                        {
                            if(a.id==s)
                                approvers=approvers+a.name+' ; ';
                        }
                    }
                }
            }
            newCalEvent.Additional_Invitees__c=approvers;
            if(opportunityRecord!=null)
            {
                
               /* if(opportunityRecord.Complex_Cost_Architect_New__c!=null && opportunityRecord.Complex_Cost_Architect_New__r.SFDC_User__c != null)
                {
                    //userIDsEvents.add(opportunityRecord.Complex_Cost_Architect__c);
                    List<User> us1=[select id, name, Email from User where id=:opportunityRecord.Complex_Cost_Architect_New__r.SFDC_User__c and isActive=true];
                    if(us1.size()>0)
                    {
                        userIDsEvents.add(opportunityRecord.Complex_Cost_Architect_New__r.SFDC_User__c);
                        mailAddresses.add(us1[0].email);
                    }
                }                  
                */
                if(opportunityRecord.Enterprise_Solution_Architect_New__c!=null && opportunityRecord.Enterprise_Solution_Architect_New__r.SFDC_USer__c != null)
                {
                    //userIDsEvents.add(opportunityRecord.Enterprise_Solution_Architect__c);
                    List<User> us1=[select id, name, Email from User where id=:opportunityRecord.Enterprise_Solution_Architect_New__r.SFDC_USer__c and isActive=true];
                    if(us1.size()>0)
                    {
                        userIDsEvents.add(opportunityRecord.Enterprise_Solution_Architect_New__r.SFDC_User__c);
                        mailAddresses.add(us1[0].email);
                    }
                }
                
                
                List<Opportunity_Offering__c> offeringNameList=[select id,name, Functional_Architect_Mobilization_New__c, Functional_Architect_Mobilization_New__r.SFDC_User__c, Solution_Lead_New__c,Solution_Lead_New__r.SFDC_User__c, Offering_Solution_Lead_Secondary_New__c,Offering_Solution_Lead_Secondary_New__r.SFDC_User__c, Technical_Architect_New__c, Technical_Architect_New__r.SFDC_User__c, Solution_Specialist_New__c, Solution_Specialist_New__r.SFDC_User__c from Opportunity_Offering__c where Opportunity_TGP__c=:opportunityRecord.id];  
                if(offeringNameList.size()>0)
                {
                    for(Opportunity_Offering__c off : offeringNameList)
                    {
                        if(off.Solution_Lead_New__c!=null && off.Solution_Lead_New__r.SFDC_User__c != null)
                        {
                            //userIDsEvents.add(off.Solution_Lead__c);
                            List<User> us1=[select id, name, Email from User where id=:off.Solution_Lead_New__r.SFDC_User__c and isActive=true];
                            if(us1.size()>0)
                            {
                                userIDsEvents.add(off.Solution_Lead_New__r.SFDC_User__c);
                                mailAddresses.add(us1[0].email);
                            }
                        }                  
                        
                        if(off.Functional_Architect_Mobilization_New__c!=null && off.Functional_Architect_Mobilization_New__r.SFDC_User__c != null)
                        {
                            //userIDsEvents.add(off.Functional_Architect_Mobilization__c);
                            List<User> us1=[select id, name, Email from User where id=:off.Functional_Architect_Mobilization_New__r.SFDC_User__c and isActive=true];
                            if(us1.size()>0)
                            {
                                userIDsEvents.add(off.Functional_Architect_Mobilization_New__r.SFDC_User__c);
                                mailAddresses.add(us1[0].email);
                            }
                        }                  
                        
                        if(off.Offering_Solution_Lead_Secondary_New__c!=null && off.Offering_Solution_Lead_Secondary_New__r.SFDC_User__c != null)
                        {
                            //userIDsEvents.add(off.Offering_Solution_Lead_Secondary__c);
                            List<User> us1=[select id, name, Email from User where id=:off.Offering_Solution_Lead_Secondary_New__r.SFDC_User__c and isActive=true];
                            if(us1.size()>0)
                            {
                                userIDsEvents.add(off.Offering_Solution_Lead_Secondary_New__r.SFDC_User__c);
                                mailAddresses.add(us1[0].email);
                            }
                        }
                        
                        if(off.Solution_Specialist_New__c!=null && off.Solution_Specialist_New__r.SFDC_User__c != null)
                        {
                            //userIDsEvents.add(off.Solution_Specialist__c);
                            List<User> us1=[select id, name, Email from User where id=:off.Solution_Specialist_New__r.SFDC_User__c and isActive=true];
                            if(us1.size()>0)
                            {
                                userIDsEvents.add(off.Solution_Specialist_New__r.SFDC_User__c);
                                mailAddresses.add(us1[0].email);
                            }
                        }  
                        if(off.Technical_Architect_New__c!=null && off.Technical_Architect_New__r.SFDC_User__c != null)
                        {
                            
                            List<User> us1=[select id, name, Email from User where id=:off.Technical_Architect_New__r.SFDC_User__c and isActive=true];
                            if(us1.size()>0)
                            {
                                userIDsEvents.add(off.Technical_Architect_New__r.SFDC_User__c);
                                mailAddresses.add(us1[0].email);
                                
                            }
                        }
                    }
                    
                }            
            }
            List<User_for_Calendar__c> lstUserForCal =[select id, name, User_Name__c from User_for_Calendar__c];
            /*if(lstUserForCal.size()>0)
            {
                List<User> us1=[select id, name, Email from User where Username=:lstUserForCal[0].User_Name__c  and isActive=true];
                if(us1.size()>0)
                {
                    userIDsEvents.add(us1[0].id);
                    mailAddresses.add(us1[0].email);
                }
            }*/
            
            //creating the event for all users of User_for_Calendar__c - START        
            if(lstUserForCal.size()>0)
            {
                List<String> userNameListForCal = new List<String>();
                for(User_for_Calendar__c userForCalObj : lstUserForCal)
                {
                    if(userForCalObj != null)
                    {
                        userNameListForCal.add(userForCalObj.User_Name__c) ;
                    }                  
                }
                
                List<User> us1=[select id, name, Email from User where Username in : userNameListForCal and isActive=true];
                if(us1.size()>0)
                {
                    for( User usrObj : us1)
                    {
                       if(usrObj != null)
                       {
                          userIDsEvents.add(usrObj.id);
                          mailAddresses.add(usrObj.email);
                       }                    
                    }
                }
            }
            //creating the event for all users of User_for_Calendar__c - END
                    
            try
            {            
                
                //New Event for the Public Calendar-Approval Calendar
                List<ID_for_Calendar__c> lstIdForCal =[select id, name, Calendar_Id__c from ID_for_Calendar__c];
                if(lstIdForCal.size()>0)
                {
                    userIDsEvents.add(lstIdForCal[0].Calendar_Id__c);
                }
                upsert newCalEvent;
                
                System.debug('-------newCalEvent-------------'+newCalEvent);
                
                //New Event for the Meeting Requester            
                //userIDsEvents.add(meetingRecord.Requester_User__c); 
                //mailAddresses.add(requesterEmailID); 
                
                if(meetingRecord.Requester_User__c!=null)
                {
                    List<User> us1=[select id, name, Email from User where id=:meetingRecord.Requester_User__c and isActive=true];
                    if(us1.size()>0)
                        {
                            userIDsEvents.add(meetingRecord.Requester_User__c);
                            mailAddresses.add(us1[0].email);
                        }
                }           
                
                //New Event for the Approver---Master            
                if(appMas.size()>0)
                {
                    if(appMas[0].IS_SFDC_User__c==true)
                    {
                        List<User> app=[select name, id from User where Email=:appMas[0].Approver_Mail_ID__c and isActive=true];
                        if(app.size()>0)
                        {
                            userIDsEvents.add(app[0].id);
                        }
                    }
                    mailAddresses.add(appMas[0].Approver_Mail_ID__c);
                }               
                
                //New Event for all the Approver Invitees            
                if(approverList!=null)
                {
                    if(approverList.size()>0)
                    {
                        for(String s: approverList)
                        {
                            for(Approver_Master__c a: approverInviteeList)
                            {
                                if(a.id==s)
                                {
                                    mailAddresses.add(a.Approver_Mail_ID__c);
                                    if(a.IS_SFDC_User__c==true)
                                    {
                                        List<User> us=[select name,id, Email from User where Email=:a.Approver_Mail_ID__c and isActive=true];
                                        if(us.size()>0)
                                        {
                                            userIDsEvents.add(us[0].id);                                        
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                //Creating events for various Users
                Event newEve=new Event();
                system.debug('--------userIDsEvents--------'+userIDsEvents);
                    for(String sid: userIDsEvents)
                    {
                        newEve=new Event();
                        newEve=createCalendarEvent(sid);
                        insert newEve;
                        system.debug('------newEve-----'+newEve);
                    }
                System.debug('-------meetingRecord.Status__c---statusValue----------'+statusValue);
                //Changing the status of the Meetings
                meetingRecord.Status__c=statusValue; 
                
                 System.debug('-------meetingRecord.Status__c-------------'+meetingRecord.Status__c);  
                         
                String startDate=newCalEvent.Start_Date__c.format('yyyy-MM-dd');
                Date myDate = date.valueOf(startDate);
                //meetingRecord.Preferred_Meeting_Date_del__c=myDate;
                //Added for D-1819. To update Scheduled Meeting Date  Author-Shridhar Patankar
                //Start
                meetingRecord.Scheduled_Meeting_Date__c=myDate;
                meetingRecord.Scheduled_Meeting_Time__c=meetingRecord.Meeting_Time__c;
                //End
                system.debug('------meetingRecord-----'+meetingRecord);
                system.debug('------meetingRecord.Status__c before insert-----'+meetingRecord.Status__c);
                
                upsert meetingRecord; 
                
                //Updating the Review Process Record
                List<Review_Process__c> revProcList=[select id, name, Review_Date__c from Review_Process__c where id=:meetingRecord.Review_Process__c];
                if(revProcList!=null && revProcList.size()>0)
                {
                    revProcList[0].Review_Date__c=newCalEvent.Start_Date__c;
                    upsert revProcList[0];                
                }  
                
                //CreateNewCalendarEventPageController.eventMail(newEve.id);
                sendEmailToApprover(mailAddresses, newEve.id);
            }
            catch(Exception e)
            {
                mainMsg=true;
                showerrorMsg=true;
                redirect=false;
                UTIL_LoggingService.logHandledException(e, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_INSERT, null, 
                                                    System.Logginglevel.ERROR);
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving!'+e));
                return;
            }
            mainMsg=true;
            redirect=true;
            inviteeSecVisible=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'New Event created successfully!'));
            //showerrorMsg=false;
            newCalEvent = new Calendar_Event__c();
            newCalEvent.Assigned_To__c=UserInfo.getUserID();  
          
        
        
        
    }
    
    /******************************
    Method Name: deleteEvent
    Description: Method to delete the events
    Paramenters: NA
    Return Value: void
    *******************************/
    public void deleteEvent()
    {
        try
        {            
            List<Event> eventLst=[select id, Meeting_Record_ID__c from Event where Meeting_Record_ID__c=:meetingId];
            if(eventLst!=null && eventLst.size()>0)
            {
                for(Event eve: eventLst)
                {
                    delete eve;
                }
            }
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Error in Deleting!'));      
            return;
        }                
    }
    
    /******************************
    Method Name: getMeetingRecordDetails
    Description: Method to get the details of the Meeting record.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void getMeetingRecordDetails()
    {
        meetingList =[select Client_Name__c,Scheduled_Meeting_Date__c, Comments__c, Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c, Status__c, Meeting_Time__c, Meeting_Type__c,
                        Offering__c, id, Title__c, name, Opportunity_Solution_lead__c, Requester_User__c, LastModifiedDate, Requester_User__r.name, Client_Geo_Area__c, Complex_Cost_Architect__c,
                        Client_Geo_Unit__c, Operating_Group__c, TCV_M__c, Estimated_TCV_M__c, Prime_SDO_Lead_M__c, Opportunity_ID__c, BPO_Opportunity__c, Review_Process__c, Review_Process__r.Review_Stage_Master__r.name from Review_Meeting_Request__c where 
                        id=:newCalEvent.Review_Meeting_Request__c];
                        
                        
         System.debug('-----meetingList.Status__c-----------'+meetingList[0].Status__c);
         
        if(meetingList.size()>0)
        {
            meetingRecord=meetingList[0];
            List<User> us=[select id, name, Email from User where id=:meetingRecord.Requester_User__c and isActive=true];
            if(us.size()>0)
            {
                requesterEmailID = us[0].email;
            }
        }                
    }
    
    /******************************
    Method Name: createCalendarEvent
    Description: Method to create Event for different users.
    Paramenters: NA
    Return Value: void
    *******************************/
    public Event createCalendarEvent(String userID)
    {
        Event newEve=new Event();        
        newEve.OwnerId = userID.trim();
        newEve.Subject = newCalEvent.Subject__c;
        newEve.StartDateTime =newCalEvent.Start_Date__c;
        newEve.EndDateTime =newCalEvent.End_Date__c; 
        newEve.TCV__c =newCalEvent.TCV__c;   
        newEve.Estimated_TCV__c =newCalEvent.Estimated_TCV__c;    
        newEve.Prime_SDO_Lead__c=newCalEvent.Prime_SDO_Lead__c;
        newEve.Region__c =newCalEvent.Region__c;
        if(appMas.size()>0)        
            newEve.Approver__c =appMas[0].name;
        String oppURL='For Opportunity click on the link below (requires Solution Workbench login): \n'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/BPO_Opportunity_tab?id='+meetingRecord.BPO_Opportunity__c+'\n\n';
        String newDescription=newCalEvent.Description__c.replaceall('<br />', '\n');
        newEve.Description =oppURL+newDescription;//newCalEvent.Description__c;        
        newEve.Meeting_ID__c=meetingRecord.name;
        newEve.Meeting_Record_ID__c=meetingRecord.id;
        newEve.Additional_Invitees__c=newCalEvent.Additional_Invitees__c;
        newEve.Client_Geo_Area__c=meetingRecord.Client_Geo_Area__c;
        newEve.Client_Geo_Unit__c=meetingRecord.Client_Geo_Unit__c;
        newEve.Client_Name__c=meetingRecord.Client_Name__c;
        newEve.Comments__c=meetingRecord.Comments__c;
        newEve.Complex_Cost_Architect__c=meetingRecord.Complex_Cost_Architect__c;
        newEve.Date_Request_Submitted__c=meetingRecord.LastModifiedDate;
        newEve.Meeting_Type__c=meetingRecord.Review_Process__r.Review_Stage_Master__r.name;
        newEve.Offering__c=meetingRecord.Offering__c;
        newEve.Operating_Group__c=meetingRecord.Operating_Group__c;
        newEve.Opportunity_Name__c=meetingRecord.Opportunity_Name__c;
        newEve.Opportunity_Solution_Lead__c=meetingRecord.Opportunity_Solution_Lead__c;
        newEve.Requester__c=meetingRecord.Requester_User__r.name;
        newEve.Opportunity_ID__c=meetingRecord.Opportunity_ID__c;
        newEve.Solution_Specialist__c=meetingRecord.Solution_Specialist__c;
        newEve.Status__c=statusValue;
        newEve.Title__c=meetingRecord.Title__c;
        newEve.BPO_Opportunity__c=meetingRecord.BPO_Opportunity__c;
        newEve.Scheduled_By__c=UserInfo.getName();
        
        System.debug('---------------------'+newEve);
        
        return newEve;
        
        
    }
    
    /******************************
    Method Name: findUserName
    Description: Method to get the username for user ID.
    Paramenters: NA
    Return Value: void
    *******************************/
    public String findUserName(String userid)
    {
        String username='';
        List<User> us=[select name,id from User where id=:userid and isActive=true];
        if(us.size()>0)
            username=us[0].name;
        return username;
    }
    
    /******************************
    Method Name: continueSaveApprover
    Description: Method if the user doesn't want to go with the modified Approver Name
    Paramenters: NA
    Return Value: void
    *******************************/
    public void continueSaveApprover()
    {
        showMainMsg=false;
        continueSave=true;
    }
    
    /******************************
    Method Name: notSaveApprover
    Description: Method if the user doesn't want to go with the modified Approver Name
    Paramenters: NA
    Return Value: void
    *******************************/
    public void notSaveApprover()
    {
        showMainMsg=false;
        //continueSave=false;
        if(calendarEventId == null)
        {
            fillApproverValue();
        }
        else
        {
            newCalEvent.Approver_Master__c = ApproverOnEdit;
        }
    }
    
    /******************************
    Method Name: addNewInvitees
    Description: Method to make the Approver Invitee list visible
    Paramenters: NA
    Return Value: void
    *******************************/
    public void addNewInvitees()
    {
        inviteeSecVisible=true;
    }
    
    /******************************
    Method Name: findUserName
    Description: Method to get the username for user ID.
    Paramenters: NA
    Return Value: void
    *******************************/
    public String checkNullValues(String value)
    {
        if(value==null)
            return '  ';
        else
            return value;
        
    }
    
    /******************************
    Method Name: checkNullValuesDecimalTCV
    Description: Method to check null and return empty string.
    Paramenters: String
    Return Value: String 
    *******************************/
    public Static String checkNullValuesDeciamlTCV(Decimal value)
    {
        if(value==null)
            return '  ';
        else
            return ''+ '$' +String.ValueOf(value.setScale(0).format()); // Code added by Ayush for D - 1791 A
        
    } 
    
    /******************************
    Method Name: changeApprover
    Description: Method to display warning on Approver change
    Paramenters: NA
    Return Value: void
    *******************************/
    public void changeApprover()
    {
        mainMsg=false;
        
        appMas = [select id, name, IS_SFDC_User__c, TCV_Range__c, Region__c, Approver_Mail_ID__c from Approver_Master__c where id=:newCalEvent.Approver_Master__c];
        System.debug('----------appMas ----------------'+appMas );
        if(newCalEvent.TCV__c > 100000)
        {            
            if(appMas.size()>0)
            {
                if(appMas[0].TCV_Range__c!='100M+')
                {                    
                    showMainMsg=true;
                    List<Approver_Master__c> appMas1 = [select id, name, IS_SFDC_User__c, TCV_Range__c, Region__c, Approver_Mail_ID__c from Approver_Master__c where TCV_Range__c=:'100M+'];
                     if(appMas1!=null && appMas1.size()>0){ 
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You can select only '+ appMas1[0].name+' for TCV: '+newCalEvent.TCV__c+' M! Do you still want to continue?'));
                    }return;
                }
            }
        }
        else if(newCalEvent.TCV__c <= 100000 && newCalEvent.TCV__c > 40000)
        {
            /*if(appMas.size()>0)
            {
                if(appMas[0].TCV_Range__c!='40-100M')
                {
                    showMainMsg=true;
                    List<Approver_Master__c> appMas1 = [select id, name, IS_SFDC_User__c, TCV_Range__c, Region__c, Approver_Mail_ID__c from Approver_Master__c where TCV_Range__c=:'40-100M'];
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You can select only '+ appMas1[0].name+' for TCV: '+newCalEvent.TCV__c+' M! Do you still want to continue?'));
                    return;
                }
            }*/
            if(newCalEvent.Region__c == 'North America')
            {
               if(appMas.size()>0)
                {
                    if(appMas[0].TCV_Range__c!='40-100M' || appMas[0].Region__c!='North America' )
                    {
                        showMainMsg=true;
                        List<Approver_Master__c> appMas1 = [select id, name, IS_SFDC_User__c, TCV_Range__c, Region__c, Approver_Mail_ID__c from Approver_Master__c where TCV_Range__c=:'40-100M' and Region__c=:'North America'];
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You can select only '+ appMas1[0].name+' for TCV: '+newCalEvent.TCV__c+' M and Region: NA! Do you still want to continue?'));
                        return;
                    }
                }
           } 
           if(newCalEvent.Region__c == 'EMEA')
           {
               if(appMas.size()>0)
                {
                    if(appMas[0].TCV_Range__c!='40-100M' || appMas[0].Region__c!='EMEA')
                    {
                        showMainMsg=true;
                        List<Approver_Master__c> appMas1 = [select id, name, IS_SFDC_User__c, TCV_Range__c, Region__c, Approver_Mail_ID__c from Approver_Master__c where TCV_Range__c=:'40-100M' and Region__c=:'EMEA'];
                         if(appMas1!=null && appMas1.size()>0){ 
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You can select only '+ appMas1[0].name+' for TCV: '+newCalEvent.TCV__c+' M and Region: EMEA! Do you still want to continue?'));
                        }
                        return;
                    }
                }
           } 
           if(newCalEvent.Region__c == 'APAC' )
           {
               if(appMas.size()>0)
                {
                    if(appMas[0].TCV_Range__c!='40-100M' || appMas[0].Region__c!='APAC')
                    {
                        showMainMsg=true;
                        List<Approver_Master__c> appMas1 = [select id, name, IS_SFDC_User__c, TCV_Range__c, Region__c, Approver_Mail_ID__c from Approver_Master__c where TCV_Range__c=:'40-100M' and Region__c=:'APAC'];
                         if(appMas1!=null && appMas1.size()>0){ 
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You can select only '+ appMas1[0].name+' for TCV: '+newCalEvent.TCV__c+' M and Region: APAC! Do you still want to continue?'));
                        }
                        return;
                    }
                }
           } 
           if(newCalEvent.Region__c == 'Latin America' )
           {
               if(appMas.size()>0)
                {
                    if(appMas[0].TCV_Range__c!='40-100M' || appMas[0].Region__c!='Latin America')
                    {
                        showMainMsg=true;
                        List<Approver_Master__c> appMas1 = [select id, name, IS_SFDC_User__c, TCV_Range__c, Region__c, Approver_Mail_ID__c from Approver_Master__c where TCV_Range__c=:'40-100M' and Region__c=:'Latin America'];
                        if(appMas1!=null && appMas1.size()>0){ 
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You can select only '+ appMas1[0].name+' for TCV: '+newCalEvent.TCV__c+' M and Region: Latin America! Do you still want to continue?'));
                        }
                        return;
                    }
                }
           } 
        }
        else if(newCalEvent.TCV__c <= 40000 && newCalEvent.TCV__c >= 10000)
        {
           
           if(newCalEvent.Region__c == 'North America')
           {
               if(appMas.size()>0)
                {
                    if(appMas[0].TCV_Range__c!='10-40M' || appMas[0].Region__c!='North America')
                    {
                        showMainMsg=true;
                        List<Approver_Master__c> appMas1 = [select id, name, IS_SFDC_User__c, TCV_Range__c, Region__c, Approver_Mail_ID__c from Approver_Master__c where TCV_Range__c=:'10-40M' and Region__c=:'North America'];
                         if(appMas1!=null && appMas1.size()>0){ 
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You can select only '+ appMas1[0].name+' for TCV: '+newCalEvent.TCV__c+' M and Region: NA! Do you still want to continue?'));
                       } return;
                    }
                }
           } 
           if(newCalEvent.Region__c == 'EMEA')
           {
               if(appMas.size()>0  )
                {
                    if(appMas[0].TCV_Range__c!='10-40M' || appMas[0].Region__c!='EMEA')
                    {
                        showMainMsg=true;
                        List<Approver_Master__c> appMas1 = [select id, name, IS_SFDC_User__c, TCV_Range__c, Region__c, Approver_Mail_ID__c from Approver_Master__c where TCV_Range__c=:'10-40M' and Region__c=:'EMEA'];
                        if(appMas1!=null && appMas1.size()>0){ 
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You can select only '+appMas1[0].Name +' for TCV: '+newCalEvent.TCV__c+' M and Region: EMEA! Do you still want to continue?'));
                        }return;
                    }
                }
           } 
           if(newCalEvent.Region__c == 'APAC' )
           {
               if(appMas.size()>0)
                {
                    if(appMas[0].TCV_Range__c!='10-40M' || appMas[0].Region__c!='APAC')
                    {
                        showMainMsg=true;
                        List<Approver_Master__c> appMas1 = [select id, name, IS_SFDC_User__c, TCV_Range__c, Region__c, Approver_Mail_ID__c from Approver_Master__c where TCV_Range__c=:'10-40M' and Region__c=:'APAC'];
                        if(appMas1!=null && appMas1.size()>0){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You can select only '+ appMas1[0].name+' for TCV: '+newCalEvent.TCV__c+' M and Region: APAC! Do you still want to continue?'));
                        }
                        return;
                    }
                }
           } 
           if(newCalEvent.Region__c == 'Latin America' )
           {
               if(appMas.size()>0)
                {
                    if(appMas[0].TCV_Range__c!='10-40M' || appMas[0].Region__c!='Latin America')
                    {
                        showMainMsg=true;
                        List<Approver_Master__c> appMas1 = [select id, name, IS_SFDC_User__c, TCV_Range__c, Region__c, Approver_Mail_ID__c from Approver_Master__c where TCV_Range__c=:'10-40M' and Region__c=:'Latin America'];
                        if(appMas1!=null && appMas1.size()>0){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You can select only '+ appMas1[0].name+' for TCV: '+newCalEvent.TCV__c+' M and Region: Latin America! Do you still want to continue?'));
                        
                        }return;
                    }
                }
           } 
        }                
    }    
}