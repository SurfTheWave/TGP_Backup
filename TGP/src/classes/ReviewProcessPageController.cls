/*
Author : Mayank Tayal
Story  :   SOL_081
Description :Reqeust by SA to schedule a call.
Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Mayank Tayal    Sol_148                    5/15/2013           Sol UAM-Release 2
Mayank Tayal    SOL_153                    20 May 2013        Change in Flow for Meeting Request
*/
public class ReviewProcessPageController {   
    public String sapOMIDValue{get;set;}
    public String offeringValue{get;set;}
    public String opportunityId{get;set;}
    public List<Opportunity_TGP__c> opportunityList{get;set;} 
    public List<Opportunity_Team__c> oppTeamList{get;set;}
    public List<Opportunity_Offering__c> offeringNameList{get;set;}   
    public Opportunity_TGP__c opportunityRecord{get;set;}
    public Opportunity_Offering__c offeringRecord{get;set;}
    public String meetingID{get;set;}
    public String pageID{get;set;}
    public List<Review_Process__c> reviewProcessList{get;set;}
    public String version{get;set;}
    public Review_Meeting_Request__c newReviewMeet{get;set;}
    public List<Review_Meeting_Request__c> detailMeetingsList{get;set;}
    public String newid{get;set;}
    public Boolean userAccess{get;set;}
    public Boolean revDateRender{get;set;}
    public Review_Process__c newReviewProcess{get;set;}
    
    public Boolean tab1Message{get;set;}
    public Boolean tab2Message{get;set;}
    public Boolean tab3Message{get;set;}
    public Boolean showMainMsg{get;set;}
    public Boolean showForm{get;set;}
    
    public Boolean showToUser{get;set;}
    public Boolean addButtonRender {get; set;}
    public Boolean saveEditButtonRender {get; set;}  
    public Boolean readOnlyMode{get;set;}
    public String testurl{get;set;} 
    
    public string strPrefMeedate{get;set;} 
    public string strDateReq{get;set;}

    public String tabFocus{get;set;}
    public String tabFocusTemp{get;set;}
    /******************************
    Class Name: MeetingRequestReview
    Description: Wrapper Class To set Editible for Submitted Meetings     
    *******************************/
    public class MeetingRequestReview
    {
        public Review_Meeting_Request__c meetingRequest{get; set;}
        public boolean isDisableMeeting{get;set;}        
        
        //Constructor for MeetingRequestReview
        public MeetingRequestReview(Review_Meeting_Request__c meetingRequest, boolean isDisableMeeting)
        {
            this.meetingRequest=meetingRequest;
            this.isDisableMeeting=isDisableMeeting;  
        }       
    }
    
    /******************************
    Method Name: ReviewProcessPageController
    Description: Constructor to initialize.  
    Paramenters: NA
    Return Value: NA
    *******************************/
    public ReviewProcessPageController(ApexPages.StandardController controller) {        
        newReviewProcess = new Review_Process__c();
        newReviewMeet = new Review_Meeting_Request__c();
        Set<String> solSpecialistUsers=new Set<String>();        
        meetingID='';
        opportunityId=ApexPages.CurrentPage().getParameters().get('oppid');
        pageID=ApexPages.CurrentPage().getParameters().get('id');
        opportunityList=[select id, name, Client_Name__r.name, SAP_OM_Opportunity__r.name, Complex_Cost_Architect_New__c, Enterprise_Solution_Architect_New__c, 
                            Complex_Cost_Architect_New__r.name, Enterprise_Solution_Architect_New__r.name, Client_Geo_Area__r.name, Client_Geo_Unit__r.name, 
                                Operating_Group__r.name, TCV__c, Estimated_TCV__c, PrimeSDOLeadName__c, PrimeSDOLeadName__r.Name from Opportunity_TGP__c where id=:opportunityId];
        oppTeamList = [SELECT Id,BPO_Opportunity__c,Opportunity_Team_Member__c,Offering__c,Roles__c,Roles__r.Name,Opportunity_Team_Member__r.Name from Opportunity_Team__c where BPO_Opportunity__c =: opportunityId];
        
        reviewProcessList=[select Version__c,Review_Type__c, Review_Date__c, Review_Stage_Master__c, Client_Name__c, Comments__c, Opportunity_Name__c, 
                              Solution_Specialist__c, Preferred_Meeting_Date_del__c, Meeting_Time__c, Meeting_Type__c,Complex_Cost_Architect__c,
                                Offering__c, id, Client_Geo_Unit__c, Client_Geo_Area__c, TCV_M__c, name, Has_Request_Raised__c, Opportunity_Solution_lead__c, 
                                    Title__c, Requester_User__c, Review_Stage_Master__r.name, Opportunity_ID__c, Review_Name__c  from Review_Process__c where id=:pageID];
        if(reviewProcessList.size()>0)
        {
            newReviewProcess = reviewProcessList[0];            
            revDateRender=true; 
            if(newReviewProcess.Review_Date__c==null)
            {
                revDateRender=false;
            }
            version='V'+ reviewProcessList[0].version__c;         
            if(opportunityList.size()>0)
            {
                showMainMsg=false;
                showForm=true;
                opportunityRecord=opportunityList[0];
                
                newReviewProcess.Client_Name__c=opportunityRecord.Client_Name__r.name;
                for(Integer i = 0 ; i < oppTeamList.size(); i++) {
                    if(oppTeamList[i].Roles__r.Name == 'Complex Cost Architect' && oppTeamList[i].Offering__c == null) {
                        newReviewProcess.Complex_Cost_Architect__c=oppTeamList[i].Opportunity_Team_Member__r.Name;
                    }
                    if(oppTeamList[i].Roles__r.Name == 'Solution Specialist') {
                        solSpecialistUsers.add(oppTeamList[i].Opportunity_Team_Member__r.Name);
                    }
                }
                
                System.debug('++++++'+newReviewProcess.Complex_Cost_Architect__c);
                System.debug('++++++'+solSpecialistUsers);
                //newReviewProcess.Complex_Cost_Architect__c=opportunityRecord.Complex_Cost_Architect_New__r.name;
                newReviewProcess.Opportunity_ID__c=opportunityRecord.SAP_OM_Opportunity__r.name;
                newReviewProcess.Opportunity_Name__c=opportunityRecord.name;
                newReviewProcess.Opportunity_Solution_lead__c=opportunityRecord.Enterprise_Solution_Architect_New__r.name;
                List<Opportunity_Offering__c> offeringNameList=[select id,name, Solution_Lead_New__c, Offering_Master__r.name, Offering_Solution_Lead_Secondary_New__c, 
                                        Solution_Specialist_New__c, Technical_Architect_New__c, Functional_Architect_Mobilization_New__c, Domain_Expert_Functional_Architect_New__c,
                                        Solution_Specialist_New__r.name from Opportunity_Offering__c where Opportunity_TGP__c=:opportunityRecord.id];
                String OfferingNames='';
                String solSpecialistNames='';
                
                if(offeringNameList.size()>0)
                {
                    for(Opportunity_Offering__c off : offeringNameList)
                    {
                        OfferingNames=OfferingNames+off.Offering_Master__r.name+' ; ';
                       
                        //if(off.Solution_Specialist_New__c!=null)
                        //    solSpecialistUsers.add(off.Solution_Specialist_New__r.name);                                                   
                    }
                    OfferingNames= OfferingNames.substring(0,OfferingNames.length()-1);                    
                }
                else
                    OfferingNames='   ';
                if(solSpecialistUsers.size()>0)
                {
                    for(String s:solSpecialistUsers)
                        solSpecialistNames=solSpecialistNames + s + ' ; ';
                        
                }
                if(solSpecialistNames.length()>0) 
                   { 
                    
                        solSpecialistNames= solSpecialistNames.substring(0,solSpecialistNames.length()-1); 
                        
                   }
                else
                
                    solSpecialistNames='   ';
                    
                //Added code Sushmanth
                if(OfferingNames.length()>0) 
                   { 
                    
                        OfferingNames= OfferingNames.substring(0,OfferingNames.length()-1); 
                        
                   }
                
                   if(solSpecialistNames.length()>0) 
                   { 
                    
                        solSpecialistNames= solSpecialistNames.substring(0,solSpecialistNames.length()-1); 
                        
                   }
                newReviewProcess.Offering__c=OfferingNames;          
                newReviewProcess.Solution_Specialist__c=solSpecialistNames;
                initializePageMessages();
                newReviewMeet.Status__c='In Progress';
                showToUser=true; 
                
                        
            }
            
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No such Opportunity ID exists'));
                showMainMsg=true;
                showForm=false;            
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No such Review ID exists'));
            showMainMsg=true;
            showForm=false;            
        }
        //UAM Code--Mayank Tayal-Sol_148
        if(opportunityId!=null)
        {
         /*   List<Opportunity_TGP__c> lstOpp = [select id, name from Opportunity_TGP__c where id = : opportunityId];
            String strOppId = lstOpp.get(0).id;
            UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Review_Process__c');            
            addButtonRender = m.get('C');
            saveEditButtonRender = m.get('U'); */            
            addButtonRender =UAMSolMobUtility.addButtonRender_BPOOppTgp;
          saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;

        }
        if(addButtonRender==false && saveEditButtonRender==false)
        {
            readOnlyMode=true;
        }
        
        tabFocusTemp=ApexPages.CurrentPage().getParameters().get('tabFocus'); //Get current page id.
    
         if(tabFocusTemp==null)
         {
             tabFocus='tab01';
         }
         else
         {
             tabFocus=tabFocusTemp;
         }   
         
         System.debug('End iN constructor' + newReviewProcess)      ;
    }    
    
    
    
    
    public PageReference GoBackToHomeTab() {
         String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
         newid=ApexPages.CurrentPage().getParameters().get('oppid');
         PageReference pg;
         if(newid != null) {
             String pagereferenceLink = sfdcBaseURL  + '/apex/BPO_Opportunity_tab?id=' + newid ;
             pg  = new PageReference(pagereferenceLink );
         }
         else {
             pg = new PageReference(sfdcBaseURL);
         }
         return pg;    
     }   
     
     
    /******************************
    Method Name: getMeetingReviewList
    Description: This method is get all request review records for perticular review.
    Paramenters: NA
    Return Value: list<MeetingRequestReview>
    *******************************/
    public List<MeetingRequestReview> getMeetingReviewList()
    {
        List<MeetingRequestReview> listOfMeetingReview=new List<MeetingRequestReview>();
        detailMeetingsList=[select Client_Name__c, Comments__c,Scheduled_Meeting_Date__c,Scheduled_Meeting_Time__c,Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c, Status__c, Meeting_Time__c, Meeting_Type__c,
                                                   Offering__c, id, Title__c, name, Opportunity_Solution_lead__c, Requester_User__c, Client_Geo_Area__c,Review_Process__r.Review_Stage_Master__r.name,
                                                    Complex_Cost_Architect__c, Client_Geo_Unit__c, Operating_Group__c, TCV_M__c, Estimated_TCV_M__c, Prime_SDO_Lead_M__c, Opportunity_ID__c, Review_Process__c, Review_Process__r.Meeting_Time__c from Review_Meeting_Request__c 
                                                            where BPO_Opportunity__c=:opportunityId and Review_Process__c=:pageid order by createddate desc];
        if(detailMeetingsList.size()>0)
        {
            for(Review_Meeting_Request__c r: detailMeetingsList)
            {
                Boolean isDisableMeeting=false;                
                if(r.status__c == 'Submitted')
                {
                   isDisableMeeting=true;                   
                }                              
                listOfMeetingReview.add(new MeetingRequestReview(r, isDisableMeeting));
                
            } 
        }
        return listOfMeetingReview;
    }
    
    
    /******************************
    Method Name: initializePageMessages
    Description: Initializing the display for Page Messages
    Paramenters: NA
    Return Value: void
    *******************************/
    public void initializePageMessages()
    {
        tab1Message=false;             
    }        
     
     
     /******************************
            Method Name: getEmailAddresses
            Description: To retrieve Email Addresses of user
            Paramenters: NA
            Return Value: List<String>
            *******************************/  
            public  List<String> getEmailAddresses()
            {
                List<String> idList = new List<String>();    
                List<String> mailToAddresses = new List<String>();
                List<String> lstGrpPMO = new List<String>();
                lstGrpPMO.add('PMO group');
               // Boolean isPMOuser;
                
                List<Group> pmog = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpPMO]; 
                for(integer i=0;i<pmog.size();i++ )
                {
                    for (GroupMember gm : pmog[i].groupMembers) {     
                        
                        
                       /*if(UserInfo.getUserId()==gm.userOrGroupId)
                        {
                         isPMOuser=true;
                        
                        } */          
                        idList.add(gm.userOrGroupId);   
                    }    
                }
                User[] usr = [SELECT email FROM user WHERE id IN :idList];    
                for(User u : usr) {        
                    mailToAddresses.add(u.email);    
                }
                
                return mailToAddresses; 
            }
           
            /******************************
            Method Name: getUserEmailAddress
            Description: To retrieve Email Addresses of Assigned User
            Paramenters: NA
            Return Value: List<String>
            *******************************/  
            public static List<String> getUserEmailAddress(String userName)
            {
                List<String> emailAddress=new List<String>();
                String id; 
                
                User[] usr = [SELECT email FROM user WHERE id=:userName];    
                emailAddress.add(usr[0].email);    
                return emailAddress; 
            }
            
    // Below method is replaced with new functionality. Now the mails will be sent to PMO Group instead of Operaions role.      
    
   /******************************
    Method Name: sendEmailAlertToPmo
    Description: Method for sending the email Alerts-Form the message object while adding
    Paramenters: NA
    Return Value: void
    *******************************/
    public void sendEmailAlertToPmo(Review_Meeting_Request__c newRevMeet, String status)
    {
        try
        {
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
            //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(getEmailAddresses());
            //mail.setSenderDisplayName('BPO Solution Support');    
            String subject='NOTIFICATION: Meeting Request '+ status +' '+'- Client Name: '+newRevMeet.Client_Name__c+' - Opportunity Name: '+newRevMeet.Opportunity_Name__c;
            mail.setSubject(subject);    
               string OfferingNames = checkNullValues(newRevMeet.Offering__c);
             /*  if(OfferingNames!=null) 
           { 
            
                OfferingNames= OfferingNames.substring(0,OfferingNames.length()-1); 
                
           } */
           string SolutionSpecialist = checkNullValues(newRevMeet.Solution_Specialist__c);
            /*   if(SolutionSpecialist!=null) 
           { 
            
                SolutionSpecialist= SolutionSpecialist.substring(0,SolutionSpecialist.length()-1); 
                
           } */
           DateTime dtValue = DateTime.newInstance(newRevMeet.Preferred_Meeting_Date_del__c.year(), newRevMeet.Preferred_Meeting_Date_del__c.month(), newRevMeet.Preferred_Meeting_Date_del__c.day());
            strPrefMeedate= dtValue.format('MM-dd-yyyy');

            DateTime dtValue1 = DateTime.newInstance(Date.today().year(), Date.today().month(), Date.today().day());
            strDateReq= dtValue1.format('MM-dd-yyyy');

            mail.setHtmlBody
            (
                '<html>' +
                '    <body>' +
                '   <STYLE type="text/css">' +
                
                '</STYLE>' +                
                '<font face="Calibri (Body)" style="font-size:11pt">' +
                '<p> A new meeting request has been submitted with following details: </p>' +                
                '<table border="1" rules="rows" width="60%" cellpadding="5">' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Opportunity ID:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(newRevMeet.Opportunity_ID__c)+'</font>'+''+'</td>' +
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Name:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Client_Name__c+'</font>'+''+'</td>' +
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Opportunity Name:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">' +
                '<a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/BPO_Opportunity_tab?id='+newReviewMeet.BPO_Opportunity__c+'" target="_parent">'+newRevMeet.Opportunity_Name__c+'</a></font>'+''+'</td>' +
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Lead Solution Architect – BPO:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Opportunity_Solution_lead__c+'</font>'+''+'</td>' +
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Complex Cost Architect:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(newRevMeet.Complex_Cost_Architect__c)+'</font>'+''+'</td>' +
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Solution Specialist:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+SolutionSpecialist+'</font>'+''+'</td>' +
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Geo Area:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Client_Geo_Area__c+'</font>'+''+'</td>' +
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Geo Unit:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Client_Geo_Unit__c+'</font>'+''+'</td>' +
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">BPO Net Revenue (MMS)<br/>(Thousands):</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNumNullValues(newRevMeet.TCV_M__c)+'</font>'+''+'</td>' +
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Operating Group:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Operating_Group__c+'</font>'+''+'</td>' +
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Offerings:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+OfferingNames+'</font>'+''+'</td>' +
                '</tr>' +
                
               
                
               /* '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Meeting ID:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.name+'</font>'+''+'</td>' +
                '</tr>' +*/
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Meeting Type:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Review_Process__r.Review_Stage_Master__r.name+'</font>'+''+'</td>' +
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Subject:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Title__c+'</font>'+''+'</td>' +
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Preferred Meeting Date:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+strPrefMeedate+'</font>'+''+'</td>' +
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Meeting Time:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Meeting_Time__c+'</font>'+''+'</td>' +
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Status:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Status__c+'</font>'+''+'</td>' +
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Comments:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(newRevMeet.Comments__c)+'</font>'+''+'</td>' +
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Requestor:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+UserInfo.getName()+'</font>'+''+'</td>' +
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Date Request Submitted:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+'<p><font face="Calibri (Body)" style="font-size:11pt">'+strDateReq+'</font>'+''+'</td>' +
                '</tr>' +
        
                '</table>' +                      
        
                '<br/>' +
                '    <a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ApprovalProcessPage?meetID='+newRevMeet.id+'" target="_parent">Login to BPO Solution Workbench</a>' + '<a>(option for those who have a workbench license)</a>' +
                '    <p>This is a system generated message. Please do not reply to this message.</p>' +
                '</font></body>' +
                '</html>'
            );
            mail.saveAsActivity=false;
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(System.EmailException ex)
        {
            tab3Message=true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Failure in sending mail'));
            return;
        }
    }
    /******************************
    Method Name: sendEmailAlertToPmo
    Description: Method for sending the email Alerts-Form the message object while Saving and modifying.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void sendEmailAlertToPmoUpdate(Review_Meeting_Request__c newRevMeet, String status)
        {
        try
        {
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
            //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(getEmailAddresses());
            //mail.setSenderDisplayName('BPO Solution Support');    
            String subject='NOTIFICATION: Meeting Request '+ status +' '+'- Client Name: '+newRevMeet.Client_Name__c+' - Opportunity Name: '+newRevMeet.Opportunity_Name__c;
            mail.setSubject(subject); 
             system.debug('------------------------OPPORTUNITY ID----------------'+newRevMeet+newRevMeet.BPO_Opportunity__c+'OPP NAME-------'+newRevMeet.Opportunity_Name__c);
            string OfferingNames = checkNullValues(newRevMeet.Offering__c);
            /*   if(OfferingNames!=null) 
           { 
                
                OfferingNames= OfferingNames.substring(0,OfferingNames.length()-1); 
                
           } */
           string SolutionSpecialist= checkNullValues(newRevMeet.Solution_Specialist__c);
            /*   if(SolutionSpecialist!=null) 
           { 
                
                SolutionSpecialist= SolutionSpecialist.substring(0,SolutionSpecialist.length()-1); 
             
           } */
           DateTime dtValue = DateTime.newInstance(newRevMeet.Preferred_Meeting_Date_del__c.year(), newRevMeet.Preferred_Meeting_Date_del__c.month(), newRevMeet.Preferred_Meeting_Date_del__c.day());
            strPrefMeedate= dtValue.format('MM-dd-yyyy');

            DateTime dtValue1 = DateTime.newInstance(Date.today().year(), Date.today().month(), Date.today().day());
            strDateReq= dtValue1.format('MM-dd-yyyy');

           
            mail.setHtmlBody
            (
                '<html>' +
                '    <body>' +
                '   <STYLE type="text/css">' +
                '</STYLE>' +                
                '<font face="Calibri (Body)" style="font-size:11pt">' +
                '<p> An existing meeting request has been modified with following details: </p>' +                
                '<table border="1" rules="rows" width="60%" cellpadding="5">' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Opportunity ID:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(newRevMeet.Opportunity_ID__c)+'</font>'+''+'</td>' +
                '</tr>' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Name:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Client_Name__c+'</font>'+''+'</td>' +
                '</tr>' +
    
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Opportunity Name:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">' +
                '<a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/BPO_Opportunity_tab?id='+opportunityId+'" target="_parent">'+newRevMeet.Opportunity_Name__c+'</a></font>'+''+'</td>' +
                '</tr>' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Lead Solution Architect – BPO:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Opportunity_Solution_lead__c+'</font>'+''+'</td>' +
                '</tr>' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Complex Cost Architect:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(newRevMeet.Complex_Cost_Architect__c)+'</font>'+''+'</td>' +
                '</tr>' +
                 '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Solution Specialist:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+SolutionSpecialist+'</font>'+''+'</td>' +
                '</tr>' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Geo Area:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Client_Geo_Area__c+'</font>'+''+'</td>' +
                '</tr>' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Geo Unit:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Client_Geo_Unit__c+'</font>'+''+'</td>' +
                '</tr>' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">BPO Net Revenue (MMS)<br/>(Thousands):</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNumNullValues(newRevMeet.TCV_M__c)+'</font>'+''+'</td>' +
                '</tr>' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Operating Group:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Operating_Group__c+'</font>'+''+'</td>' +
                '</tr>' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Offerings:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+OfferingNames+'</font>'+''+'</td>' +
                '</tr>' +
               
                /*'<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Meeting ID:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.name+'</font>'+''+'</td>' +
                '</tr>' +*/
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Meeting Type:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Review_Process__r.Review_Stage_Master__r.name+'</font>'+''+'</td>' +
                '</tr>' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Subject:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Title__c+'</font>'+''+'</td>' +
                '</tr>' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Preferred Meeting Date:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+strPrefMeedate+'</font>'+''+'</td>' +
                '</tr>' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Meeting Time:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Meeting_Time__c+'</font>'+''+'</td>' +
                '</tr>' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Status:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+newRevMeet.Status__c+'</font>'+''+'</td>' +
                '</tr>' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Comments:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(newRevMeet.Comments__c)+'</font>'+''+'</td>' +
                '</tr>' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Requestor:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+UserInfo.getName()+'</font>'+''+'</td>' +
                '</tr>' +
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Date Request Submitted:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+strDateReq+'</font>'+''+'</td>' +
                '</tr>' +
                '</table>' +                      
                '<br/>' +
                '    <a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ApprovalProcessPage?meetID='+newRevMeet.id+'" target="_parent">Login to BPO Solution Workbench</a>' + '<a>(option for those who have a workbench license)</a>' +
                '    <p>This is a system generated message. Please do not reply to this message.</p>' +
                '</font></body>' +
                '</html>'
            );
            mail.saveAsActivity=false;
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(System.EmailException ex)
        {
            tab3Message=true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Failure in sending mail'));
            return;
        }
    }
    /******************************
    Method Name: emailToPMO
    Description: Action Method for button Add & Email to PMO
    Paramenters: NA
    Return Value: void
    *******************************/
    public void emailToPMO()
    {
        Set<String> solSpecialistUsers=new Set<String>();
        try
        {            
            /*if(newReviewMeet.Meeting_Type__c==null)
            {
                tab3Message=true;
                showMainMsg=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required field missing: [Meeting Type]!'));
                return;
            }*/
            if(newReviewMeet.Preferred_Meeting_Date_del__c==null)
            {
                tab3Message=true;
                showMainMsg=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Meeting Date cannot be left blank'));
                return;
            }
            if(newReviewMeet.Meeting_Time__c==null)
            {
                tab3Message=true;
                showMainMsg=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Meeting Time cannot be None. Please select another value'));
                return;
            }
            if(newReviewMeet.Preferred_Meeting_Date_del__c<Date.today())
            {
                tab3Message=true;
                showMainMsg=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Meeting Date should be greater than or equal to Today\'s Date'));
                return;
            }
            if(opportunityRecord.TCV__c==null)
            {
                tab3Message=true;
                showMainMsg=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'BPO Net Revenue (MMS) Value for this opportunity is blank. Please update the same in General Information tab in BPO Opportunity before requesting for a approval meeting.'));
                return;
            }
            newReviewMeet.Client_Name__c=opportunityRecord.Client_Name__r.name;
            for(Integer i = 0 ; i < oppTeamList.size(); i++) {
                    if(oppTeamList[i].Roles__r.Name == 'Complex Cost Architect' && oppTeamList[i].Offering__c == null) {
                        newReviewMeet.Complex_Cost_Architect__c=oppTeamList[i].Opportunity_Team_Member__r.Name;
                    }
                    if(oppTeamList[i].Roles__r.Name == 'Solution Specialist') {
                        solSpecialistUsers.add(oppTeamList[i].Opportunity_Team_Member__r.Name);
                    }
                    if(oppTeamList[i].Roles__r.Name == 'Prime SDO Lead' && oppTeamList[i].Offering__c == null) {
                        newReviewMeet.Prime_SDO_Lead_M__c=oppTeamList[i].Opportunity_Team_Member__r.Name;
                    }
                }
            //newReviewMeet.Complex_Cost_Architect__c=opportunityRecord.Complex_Cost_Architect_New__r.name;
            newReviewMeet.Opportunity_ID__c=opportunityRecord.SAP_OM_Opportunity__r.name;
            newReviewMeet.Opportunity_Name__c=opportunityRecord.name;
            newReviewMeet.Opportunity_Solution_lead__c=opportunityRecord.Enterprise_Solution_Architect_New__r.name;
            newReviewMeet.TCV_M__c=opportunityRecord.TCV__c;
            
            if(opportunityRecord.Estimated_TCV__c != null && opportunityRecord.Estimated_TCV__c != 0)
            {
                newReviewMeet.Estimated_TCV_M__c=opportunityRecord.Estimated_TCV__c;
            }else
            {
                newReviewMeet.Estimated_TCV_M__c=opportunityRecord.TCV__c;
            }
            
            //newReviewMeet.Prime_SDO_Lead_M__c=opportunityRecord.PrimeSDOLeadName__r.Name;
            newReviewMeet.Client_Geo_Unit__c=opportunityRecord.Client_Geo_Unit__r.name;
            newReviewMeet.Client_Geo_Area__c=opportunityRecord.Client_Geo_Area__r.name;
            newReviewMeet.Operating_Group__c = opportunityRecord.Operating_Group__r.name;
            sapOMIDValue=opportunityRecord.id;
            newReviewMeet.BPO_Opportunity__c=opportunityRecord.id;
            offeringNameList=[select id,name, Solution_Lead_New__c, Offering_Master__r.name, Offering_Solution_Lead_Secondary_New__c, Solution_Specialist_New__r.name, Solution_Specialist_New__c from Opportunity_Offering__c where Opportunity_TGP__c=:opportunityRecord.id];  
            //List<Solution_Specialist_Task__c> solSpec=[select id, name, Opportunity_Offering__c, Solution_Specialist_User__c, Solution_Specialist_User__r.name from Solution_Specialist_Task__c];
            String OfferingNames='';
            String solSpecialistNames='';
            if(offeringNameList.size()>0)
            {
                for(Opportunity_Offering__c off : offeringNameList)
                {
                    OfferingNames=OfferingNames+off.Offering_Master__r.name+' ; ';
                    //if(off.Solution_Specialist_New__c!=null)
                      //  solSpecialistUsers.add(off.Solution_Specialist_New__r.name);                                                   
                }
                if(OfferingNames.length()>0) 
           { 
            
                OfferingNames= OfferingNames.substring(0,OfferingNames.length()-1); 
                
           } 
                                   
            }
            else
                OfferingNames='   ';
            if(solSpecialistUsers.size()>0)
            {
                for(String s:solSpecialistUsers)
                    solSpecialistNames=solSpecialistNames + s + ' ; '; 
            }
            if(solSpecialistNames.length()>0) 
           { 
            
                solSpecialistNames= solSpecialistNames.substring(0,solSpecialistNames.length()-1); 
                
           }
            
            else
                solSpecialistNames='   ';
                if(OfferingNames.length()>0) 
           { 
            
                OfferingNames= OfferingNames.substring(0,OfferingNames.length()-1); 
                
           }
           if(solSpecialistNames.length()>0) 
           { 
            
                solSpecialistNames= solSpecialistNames.substring(0,solSpecialistNames.length()-1); 
                
           }
            newReviewMeet.Offering__c=OfferingNames;            
            newReviewMeet.Solution_Specialist__c=solSpecialistNames;
          /*  
            String strTcvValue = String.valueof(newReviewMeet.Estimated_TCV_M__c);
            if(strTcvValue == null || (strTcvValue != null && strTcvValue.length() <= 0) ){
                strTcvValue = String.valueof(newReviewMeet.TCV_M__c);
            }
            */
            String strTcvValue = '';
            if(newReviewMeet.Estimated_TCV_M__c != null) {
                strTcvValue = (newReviewMeet.Estimated_TCV_M__c).format();
            }
           
            
            newReviewMeet.Title__c= newReviewMeet.Client_Geo_Area__c+' - '+ '$'+ strTcvValue  +' - '+newReviewProcess.Review_Stage_Master__r.name+' - '+newReviewMeet.Client_Name__c+' - '+newReviewMeet.Opportunity_Name__c;
            newReviewMeet.Status__c='Submitted'; 
            newReviewMeet.Requester_User__c=UserInfo.getUserID();
            newReviewMeet.Review_Process__c =pageID;
            //newReviewMeet.Has_Request_Raised__c=true;
          
            upsert newReviewMeet;
            upsert newReviewProcess;
            List<Review_Meeting_Request__c> meetingList =[select Client_Name__c, Comments__c, Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c, Status__c, Meeting_Time__c, Meeting_Type__c,
                                                            Offering__c, id, Title__c, name, Opportunity_Solution_lead__c, Requester_User__c, Client_Geo_Area__c, Complex_Cost_Architect__c,
                                                            Client_Geo_Unit__c, Operating_Group__c, TCV_M__c, Estimated_TCV_M__c, Prime_SDO_Lead_M__c, Opportunity_ID__c, Review_Process__c, Review_Process__r.Review_Stage_Master__r.name
                                                            from Review_Meeting_Request__c where id=:newReviewMeet.id];


            if(meetingList.size()>0)
                meetingID=meetingList[0].name;
            sendEmailAlertToPmo(meetingList[0], 'Submitted');
            
        }
        catch(System.EmailException ex)
        {
            tab3Message=true;
            showMainMsg=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Failure in sending mail'));
            return;
        }
        catch(Exception ex)
        {
            tab3Message=true;
            showMainMsg=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Failure in saving record'));
            return;
        }
        //reInitialize();
        newReviewMeet = new Review_Meeting_Request__c();
        newReviewMeet.Status__c='In Progress';
        tab3Message=true;
        showMainMsg=false;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Approval Meeting Request sent successfully'));     
    }
    
   
    /******************************
    Method Name: saveAndEmailToPMO
    Description: Action Method for button Save & Email to PMO
    Paramenters: NA
    Return Value: void
    *******************************/
    public void saveAndEmailToPMO()
    {
        try
        {
            List<Review_Meeting_Request__c> oldMeetingList=[select Client_Name__c, Comments__c,BPO_Opportunity__c, Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c, Status__c, Meeting_Time__c, Meeting_Type__c,
                                                            Offering__c, id, Title__c, name, Opportunity_Solution_lead__c, Requester_User__c, Client_Geo_Area__c, Complex_Cost_Architect__c,
                                                            Client_Geo_Unit__c, Operating_Group__c, TCV_M__c, Estimated_TCV_M__c, Prime_SDO_Lead_M__c, Review_Process__c, Review_Process__r.Review_Stage_Master__r.name,
                                                            Opportunity_ID__c from Review_Meeting_Request__c where BPO_Opportunity__c=:opportunityId and Status__c=:'Submitted' order by createddate desc];
            if(detailMeetingsList.size()>0)
            {
                for(Review_Meeting_Request__c r: detailMeetingsList)
                {
                    /*if(r.Meeting_Type__c==null)
                    {
                        tab3Message=true;
                        showMainMsg=false;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required field missing: [Meeting Type]!'));
                        return;
                    }*/
                    if(r.Preferred_Meeting_Date_del__c==null)
                    {
                        tab3Message=true;
                        showMainMsg=false;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Meeting Date cannot be left blank'));
                        return;
                    }
                    if(r.Meeting_Time__c==null)
                    {
                        tab3Message=true;
                        showMainMsg=false;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Meeting Time cannot be left blank'));
                        return;
                    }                    
                    if(oldMeetingList.size()>0)
                    {
                        for(Review_Meeting_Request__c r2: oldMeetingList)
                        {
                            if(r.id==r2.id )
                            {
                                if(r.Preferred_Meeting_Date_del__c!=r2.Preferred_Meeting_Date_del__c || r.Meeting_Time__c!=r2.Meeting_Time__c || r.Comments__c!=r2.Comments__c)
                                {
                                    if(r.Preferred_Meeting_Date_del__c<Date.today() && r.status__c == 'Submitted')
                                    {
                                        tab3Message=true;
                                        showMainMsg=false;
                                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Meeting Date should be greater than or equal to Today\'s Date'));
                                        return;
                                    }
                                    //upsert r;
                                    database.update(r);
                                    sendEmailAlertToPmoUpdate(r, 'Modified');
                                    System.debug('-----@@@--'+r);
                                }
                            }
                        }
                    }
                }
            }
        }
        catch(Exception ex)
        {
            tab3Message=true;
            showMainMsg=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Failure in saving'));
            return;
        }
        tab3Message=true;
        showMainMsg=false;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Meeting request(s) modified and email to operations sent successfully'));     
    }
    
    /******************************
    Method Name: checkNullValues
    Description: Method to Check the NULL values for String.
    Paramenters: NA
    Return Value: void
    *******************************/
    public String checkNullValues(String value)
    {
        if(value==null)
            return '   ';
        else
            return value;
        
    }
    
    /******************************
    Method Name: checkNumNullValues
    Description: Method to Check the NULL values for Number.
    Paramenters: NA
    Return Value: void
    *******************************/
    public String checkNumNullValues(Decimal value)
    {
        if(value==null)
            return '   ';
        else
            return ''+ '$' +String.ValueOf(value.setScale(0).format());// Code added by Ayush for D - 1791 A
        
    }
    
    /******************************
    Method Name: refreshPage
    Description: Method to refresh the list.
    Paramenters: NA
    Return Value: void
    *******************************/
    public static void refreshPage()
    {
        List<Review_Meeting_Request__c> lstMeetingReq=[select Client_Name__c, Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c, Status__c, Meeting_Time__c, Meeting_Type__c,
                                    Offering__c, id, name, Opportunity_Solution_lead__c, Requester_User__c, Opportunity_ID__c, TCV_M__c, Estimated_TCV_M__c, Prime_SDO_Lead_M__c, Operating_Group__c, Client_Geo_Unit__c, Complex_Cost_Architect__c,
                                    Client_Geo_Area__c, Review_Process__r.Review_Stage_Master__r.name,BPO_Opportunity__c, BPO_Opportunity__r.name, BPO_Opportunity__r.SAP_OM_Opportunity__c, BPO_Opportunity__r.Client_Name__r.name, 
                                    BPO_Opportunity__r.Operating_Group__r.name, BPO_Opportunity__r.Enterprise_Solution_Architect_New__r.name, BPO_Opportunity__r.Client_Geo_Unit__r.name, BPO_Opportunity__r.Client_Geo_Area__r.name, 
                                    BPO_Opportunity__r.TCV__c, BPO_Opportunity__r.Estimated_TCV__c, BPO_Opportunity__r.PrimeSDOLeadName__c, BPO_Opportunity__r.Complex_Cost_Architect_New__c,Review_Process__r.version__c from Review_Meeting_Request__c order by createddate desc];
 
        List<Review_Meeting_Request__c> templstMeetingReq= new List<Review_Meeting_Request__c>();
        if(lstMeetingReq.size()>0)
        {
            for(Review_Meeting_Request__c r : lstMeetingReq)      
            {                
                string version='V'+ r.Review_Process__r.version__c; 
               /* 
                String strTcvValue = String.valueof(r.Estimated_TCV_M__c);

                if(strTcvValue == null || (strTcvValue != null && strTcvValue.length() <= 0) ){
                    strTcvValue = String.valueof(r.TCV_M__c);
                }
                */
                String strTcvValue = '';
                if(r.Estimated_TCV_M__c != null) {
                    strTcvValue = (r.Estimated_TCV_M__c).format();
                }
                r.Title__c= r.Client_Geo_Area__c+' - '+'$'+ strTcvValue  +' - '+r.Review_Process__r.Review_Stage_Master__r.name+' - '+r.Client_Name__c+' - '+r.Opportunity_Name__c;
            
                //r.Title__c=r.Client_Name__c+' / '+r.Opportunity_Name__c+' / '+r.Review_Process__r.Review_Stage_Master__r.name+'-'+version;                
                templstMeetingReq.add(r);
            }
        }   
        try
        {
            upsert templstMeetingReq;
            
        }
        catch(Exception ex)
        {
           // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex.getMessage()));
           return;
           
        }                   
        return;
    }   
    /******************************
    Method Name: refreshPageTrigger
    Description: Method to refresh the list.
    Paramenters: NA
    Return Value: void
    *******************************/
    public static void refreshPageTrigger (List<Opportunity_TGP__c> oppTGPList) {
        List<Id> oppIDList = new List<Id>();
        for(Opportunity_TGP__c opp :oppTGPList) {
            oppIDList.add(opp.Id);
        }
        if(!oppIDList.isEmpty()) {
            List<Review_Meeting_Request__c> lstMeetingReq=[select Client_Name__c, Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c, Status__c, 
                                                            Meeting_Time__c, Meeting_Type__c, Offering__c, id, name, Opportunity_Solution_lead__c, Requester_User__c, 
                                                            Opportunity_ID__c, TCV_M__c, Estimated_TCV_M__c, Prime_SDO_Lead_M__c, Operating_Group__c, Client_Geo_Unit__c,
                                                            Complex_Cost_Architect__c, Client_Geo_Area__c, Review_Process__r.Review_Stage_Master__r.name,BPO_Opportunity__c,
                                                            BPO_Opportunity__r.name, BPO_Opportunity__r.SAP_OM_Opportunity__c, BPO_Opportunity__r.Client_Name__r.name, 
                                                            BPO_Opportunity__r.Operating_Group__r.name, BPO_Opportunity__r.Enterprise_Solution_Architect_New__r.name, 
                                                            BPO_Opportunity__r.Client_Geo_Unit__r.name, BPO_Opportunity__r.Client_Geo_Area__r.name, 
                                                            BPO_Opportunity__r.TCV__c, BPO_Opportunity__r.Estimated_TCV__c, BPO_Opportunity__r.PrimeSDOLeadName__c, 
                                                            BPO_Opportunity__r.Complex_Cost_Architect_New__c,Review_Process__r.version__c 
                                                            from Review_Meeting_Request__c Where BPO_Opportunity__c IN :oppIDList order by createddate desc];
     
            List<Review_Meeting_Request__c> templstMeetingReq= new List<Review_Meeting_Request__c>();
            if(lstMeetingReq.size()>0)
            {
                for(Review_Meeting_Request__c r : lstMeetingReq)      
                {                
                    string version='V'+ r.Review_Process__r.version__c; 
                   /* 
                    String strTcvValue = String.valueof(r.Estimated_TCV_M__c);
    
                    if(strTcvValue == null || (strTcvValue != null && strTcvValue.length() <= 0) ){
                        strTcvValue = String.valueof(r.TCV_M__c);
                    }
                    */
                    String strTcvValue = '';
                    if(r.Estimated_TCV_M__c != null) {
                        strTcvValue = (r.Estimated_TCV_M__c).format();
                    }
                    r.Title__c= r.Client_Geo_Area__c+' - '+'$'+ strTcvValue  +' - '+r.Review_Process__r.Review_Stage_Master__r.name+' - '+r.Client_Name__c+' - '+r.Opportunity_Name__c;
                
                    //r.Title__c=r.Client_Name__c+' / '+r.Opportunity_Name__c+' / '+r.Review_Process__r.Review_Stage_Master__r.name+'-'+version;                
                    templstMeetingReq.add(r);
                }
            }   
            try {
                upsert templstMeetingReq;
                
            }
            catch(Exception ex) {
               // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex.getMessage()));
               return;
            }  
        }                 
        return;
    }   
}