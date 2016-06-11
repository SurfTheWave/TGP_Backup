/*
Author : Shridhar Patankar
Story  :   SOL_080
Description :Outbound Emails to the recipient. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Mayank Tayal        SOL_146                9 May 2013        Changed the Recepient List
Mayank Tayal        SOL_168                5 June 2013       Changed the Mail template
*/
global class SendEmailForFollowingWeekScheduler implements Schedulable   
{ 
    /******************************
    Method Name: execute
    Description: Method to execute when the scheduled Apex Job is run
    Paramenters: NA
    Return Value: void
    *******************************/
    global void execute (SchedulableContext ctx)
    {       
        sendEmail7Days(); 
    } 
    
    /******************************
    Method Name: sendEmail7Days
    Description: Send email for all events scheduled A week (7Days-Friday) before
    Paramenters: NA
    Return Value: void
    *******************************/
    public static void sendEmail7Days()
    {
        datetime t = System.now();
        
        List<Event> lstevent1 = [Select Scheduled_By__c, Description, Additional_Invitees__c, Meeting_Record_ID__c, Meeting_Type__c, Title__c, Status__c, Approver__c, Meeting_ID__c, Region__c, TCV__c, Location, Subject, OwnerId , StartDateTime,EndDateTime from Event];
        List<Outbound_Email_User_Master__c> outboundMasterList = [select id, name, Email_ID__c, Outbound_Email_User_Name__c, Active__c, Comments__c from Outbound_Email_User_Master__c];
        List<User> us=[select name,id from User];
        List<Review_Meeting_Request__c> meetingList =[select Client_Name__c, Comments__c, Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c, Status__c, Meeting_Time__c, Meeting_Type__c,
                                                Offering__c, id, Title__c, name, Opportunity_Solution_lead__c, Requester_User__c, LastModifiedDate, Requester_User__r.name, Client_Geo_Area__c, Complex_Cost_Architect__c,
                                                Client_Geo_Unit__c, Operating_Group__c, TCV_M__c, Opportunity_ID__c, BPO_Opportunity__c, Has_Email_Sent_24_Hours__c, Has_Email_Sent__c from Review_Meeting_Request__c];
        List<Opportunity_TGP__c > opportunityList=[select id,Link_to_client_website__c,Link_to_Additional_Documents__c, name, SAP_OM_Opportunity__r.name, Client_Geo_Area__r.name, Client_Geo_Unit__r.name, 
                                Operating_Group__r.name from Opportunity_TGP__c];       
        List<Event> lstevent = [Select Scheduled_By__c, Additional_Invitees__c, Meeting_Record_ID__c, Approver__c, Meeting_ID__c, Region__c, TCV__c, Location, Subject, OwnerId , StartDateTime,EndDateTime from Event where StartDateTime>=:t and StartDateTime<=:t+7];
        List<Calendar_Event__c> calEvent=[select id, name, Description__c, Review_Meeting_Request__c from Calendar_Event__c];
        
        List<Messaging.SingleEmailMessage> emailMsgList = new List<Messaging.SingleEmailMessage>();
        DateTime dateVal=DateTime.now();
        String firstPart='<html>' +
                        '<body>' +
                        '<STYLE type="text/css">' +                        
                        '</STYLE>';                      
        
        String thirdPart='<font face="Calibri (Body)" style="font-size:11pt"><p><b>To view all upcoming approval calls please go to the following link for the calendar(requires Solution Workbench access):</b><br/>' +
                        '<a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ApprovalProcessPage?tabValue=tab1" target="_parent">Approval Calendar</a></p><br/>' +
                        '<b>To access review materials for the meeting click on the Opportunity Documents link below.  To access opportunity details click on the Opportunity Name link (requires Solution Workbench access): </b><br/>'+
                        '<u><font color="blue">Upcoming Approval Meetings</font></u><br/>';
                        
        String fourthPart='<table border="1" cellpadding="5">'+
                        '<tr height="20">'+
                        '<th width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Start Time</font></b></th>'+
                        //'<th width="600" style="width:73.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">End Time</font></b></th>'+
                        '<th width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Review Type</font></b></th>'+
                        '<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Client Name</font></b></th>'+
                        '<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Opportunity Documents</font></b></th>'+
                        '<th width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Opportunity Name</font></b></th>'+
                        '<th width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Region</font></b></th>'+
                        '<th width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Client Local Geo</font></b></th>'+
                        //'<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Operating Group</font></b></th>'+
                        '<th width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">BPO Net Revenue (SAP OM)<br/>(Thousands)</font></b></th>'+
                        '<th width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Offering(s)</font></b></th>'+
                        '<th width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Delivery Locations</font></b></th>'+
                        '<th width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Lead Solution Architect – BPO</font></b></th>'+
                        /*'<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Solution Specialist(s)</font></b></th>'+
                        '<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Meeting ID</font></b></th>'+
                        '<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Subject</font></b></th>'+
                        '<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Scheduled By</font></b></th>'+
                        '<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Title</font></b></th>'+
                        '<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Approver</font></b></th>'+
                        '<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Other Attendees</font></b></th>'+
                        '<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Status</font></b></th>'+*/
                        '</tr>';
        String fifthPart='';
        String sixthPart='';
        if (lstevent.size()>0)
        {
            String descriptionDetails='';
            for(Event newEvent: lstevent)
            {
                
                if(meetingList.size()>0)
                {
                    for(Review_Meeting_Request__c r:meetingList) 
                    {
                        
                        if(r.id==newEvent.Meeting_Record_ID__c && r.Has_Email_Sent__c==false)
                        {
                            for(Calendar_Event__c cal:calEvent)
                            {
                                if(cal.Review_Meeting_Request__c==r.id)
                                {
                                   
                                    if(opportunityList.size()>0)
                                    {
                                        for(Opportunity_TGP__c opp:opportunityList)
                                        {                                            
                                            if(opp.id==r.BPO_Opportunity__c)//&& r.Opportunity_ID__c!=null && opp.SAP_OM_Opportunity__r.name!=null)
                                            {
                                                
                                                String retString= formTable7Days(lstevent1, newEvent.id, r.Client_Name__c,r.Opportunity_Name__c, r.Opportunity_ID__c, 
                                                                    r.Opportunity_Solution_lead__c, r.Offering__c, r.Solution_Specialist__c, opp.Client_Geo_Area__r.name, 
                                                                    opp.Client_Geo_Unit__r.name, opp.Operating_Group__r.name, outboundMasterList, us, cal.Description__c, opp.id,  r.Meeting_Time__c,opp.Link_to_Additional_Documents__c);
                                                fifthPart=fifthPart + retString;
                                                descriptionDetails=cal.Description__c;
                                                if(retString!=null)
                                                {
                                                    //emailMsgList.add(mail);
                                                    r.Has_Email_Sent__c=true;
                                                    try{
                                                        upsert r;
                                                    }
                                                    catch(Exception ex)
                                                    {
                                                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving!'));
                                                        return;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            sixthPart='</table>' +                
                        //'<br/>' +
                        '<p>This is a system generated message. Please do not reply to this message.</p>' +
                        '<b>Meeting Details:</b><br/><br/>'+checkNullValues(descriptionDetails)+ '<br/>'+                        
                        '</font></body>' +
                        '</html>';            
            //From Address, Set from organisation wide address.
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
            mail.setToAddresses(getEmailAddresses(outboundMasterList));
            mail.setSubject('REMINDER: Approval call agenda for the following week');            
            mail.setHtmlBody(firstPart+thirdPart+fourthPart+fifthPart+sixthPart);
            mail.saveAsActivity=false;
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            if(meetingList.size()>0)
            {
                for(Review_Meeting_Request__c r:meetingList) 
                {
                    r.Has_Email_Sent__c=false;
                    
                }
                try{
                        upsert meetingList;
                    }
                    catch(Exception ex)
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving!'));
                        return;
                    }
            } 
        }
    }    
    
    /******************************
    Method Name: formTable7Days
    Description: Send email for all events scheduled a Week before
    Paramenters: NA
    Return Value: void
    *******************************/
    public static String formTable7Days(List<Event> lstevent, String eventID, String clientName, String oppName,String oppID, 
                                        String oppSolLead,String offerings,String solSpecialists, String geoArea, String geoUnit, String opGroup, 
                                        List<Outbound_Email_User_Master__c> outboundMasterList, List<User> us, String description, String opportunityID, String meetingTime, String OpportunityLink)
    {
        String tableRows='';
        List<Opportunity_Offering__c> offeringsForLocation = new List<Opportunity_Offering__c >(); 
        
        
        /*if(offerings!=null)
         /*if(offerings!=null) 
           { 
            
                offerings = offerings.substring(0,offerings.length()-1); 
           }*/
        if(opportunityID != null && opportunityID != '') {   
            Id OpporId = Id.valueOf(opportunityID);   
            offeringsForLocation = [Select id,Service_Delivery_Location_Unique__c  from Opportunity_Offering__c where Opportunity_TGP__c = :OpporId];                 
        }
        String allOfferingsDeliveryLocation = '';
        String finalDeliveryLocationUniqueString = '';
        set<String> uniqueDeliveryLocation = new set<String>();
        if(offeringsForLocation  != null && offeringsForLocation.size() > 0) {
            for (Opportunity_Offering__c allOfferingsRelatedToNewOpportunity : offeringsForLocation) {
                  allOfferingsDeliveryLocation += allOfferingsRelatedToNewOpportunity.Service_Delivery_Location_Unique__c;
            }
            String[] eachSplittedLocation = allOfferingsDeliveryLocation.split(';');
            for(String Location :eachSplittedLocation) {
                uniqueDeliveryLocation.add(Location);
            }
        }
        for(String s : uniqueDeliveryLocation) {
         finalDeliveryLocationUniqueString += s + ';' ;    
        }    
            
               
        if (lstevent.size()>0)
        {
            for(Event e: lstevent)
            {
                 String strStartDate=e.StartDateTime.format('MM-dd-yyyy HH:mm:ss','America/El_Salvador');
                 String strEndDate=e.EndDateTime.format('MM-dd-yyyy HH:mm:ss','America/El_Salvador');
                 String strSD=e.StartDateTime.format('MM-dd-yyyy');
                if(e.id==eventID)
                {
                    tableRows='<tr height="20">'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">';
                            if(meetingTime=='EALA (7am CST)' || meetingTime=='APAC (10 pm CST)' || meetingTime=='North America (10am CST)')
                            {
                                tableRows= tableRows +strSD+'&nbsp;&nbsp;'+ meetingTime;
                            }
                            else
                            {
                                tableRows= tableRows + strStartDate +'&nbsp;&nbsp;CST';
                            }
                            tableRows= tableRows +'</font></td>'+
                            //'<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" size="1">'+e.EndDateTime+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+e.Meeting_Type__c+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+clientName+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+
                            '<a href ="'+checkNullValues(OpportunityLink)+'">' +checkNullValues(OpportunityLink)+'</a>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+
                            '<a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/BPO_Opportunity_tab?id='+opportunityID+'" target="_parent">'+oppName+'</a>'+
                            '</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+geoArea+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(geoUnit)+'</font></td>'+
                            //'<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+opGroup+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+checkNullValuesDeciamlTCV(e.TCV__c)+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(offerings)+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+finalDeliveryLocationUniqueString+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+oppSolLead+'</font></td>'+
                            /*'<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(solSpecialists)+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+e.Meeting_ID__c+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+e.Subject+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(e.Scheduled_By__c)+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+e.Title__c+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+e.Approver__c+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(e.Additional_Invitees__c)+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+e.Status__c+'</font></td>'+*/
                            '</tr>';
                }
            }
        }
        return tableRows;
    }
    /******************************
    Method Name: getEmailAddresses
    Description: To retrieve Email Addresses of user
    Paramenters: NA
    Return Value: List<String>
    *******************************/  
    public static List<String> getEmailAddresses(List<Outbound_Email_User_Master__c> outboundMasterList)
    {    
        List<String> idList = new List<String>();    
        List<String> mailToAddresses = new List<String>();             
        if(outboundMasterList.size()>0)
        {
            for(Outbound_Email_User_Master__c a: outboundMasterList)
            {
                if(a.Active__c==true)
                {
                    mailToAddresses.add(a.Email_ID__c); 
                }                   
            }
        }    
        return mailToAddresses;  
    }
    
    /******************************
    Method Name: findUserName
    Description: Method to get the username for user ID.
    Paramenters: NA
    Return Value: void
    *******************************/
    public static String findUserName(List<User> us, String userid)
    {
        String username='';
        if(us.size()>0)
        {
            for(User us1: us)
            {
                if(us1.id==userid)
                    username=us1.name;
            }
        }
        return username;
    }
    
    /******************************
    Method Name: checkNullValues
    Description: Method to check the null values.
    Paramenters: NA
    Return Value: void
    *******************************/
    public static String checkNullValues(String value)
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
            return ''+ '$' +String.ValueOf(value.setScale(0).format());// Code added by Ayush for D - 1791 A
        
    }       
 }