/*
 * @Author Accenture IDC Team
 * @CreatedDate 01/03/2014
 * @Description This class will create mail body and send mail for all events scheduled A week before and for all events scheduled 24 Hours before 
 *               to outbound user master records's email
 */
 
public class UTIL_SendEmailFor24HoursSchedule
{
     
    
    /******************************
    Method Name: sendEmail24Hours
    Description: Send email for all events scheduled A week (7Days-Friday) before
    Paramenters: NA
    Return Value: void
    *******************************/
    public void sendEmail24Hours(List<Outbound_Email_User_Master__c> outboundMasterList)
    {
        datetime t = System.now();
        String strDay = t.format('EEEE');
        
        List<Event> lstevent1 = [Select Scheduled_By__c, Description, Additional_Invitees__c, Meeting_Record_ID__c, Meeting_Type__c, Title__c, Status__c, Approver__c, Meeting_ID__c, Region__c, TCV__c, Estimated_TCV__c, Prime_SDO_Lead__c, Location, Subject, OwnerId , StartDateTime,EndDateTime from Event];
        //List<Outbound_Email_User_Master__c> outboundMasterList = [select id, name, Email_ID__c, Outbound_Email_User_Name__c, Active__c, Comments__c from Outbound_Email_User_Master__c];
        List<User> us=[select name,id from User];
        List<Review_Meeting_Request__c> meetingList =[select Client_Name__c, Comments__c, Opportunity_Name__c, Solution_Specialist__c, Preferred_Meeting_Date_del__c, Status__c, Meeting_Time__c, Meeting_Type__c,
                                                Offering__c, id, Title__c, name, Opportunity_Solution_lead__c, Requester_User__c, LastModifiedDate, Requester_User__r.name, Client_Geo_Area__c, Complex_Cost_Architect__c,
                                                Client_Geo_Unit__c, Operating_Group__c, TCV_M__c, Estimated_TCV_M__c, Prime_SDO_Lead_M__c, Opportunity_ID__c, BPO_Opportunity__c, Has_Email_Sent_24_Hours__c, Has_Email_Sent__c from Review_Meeting_Request__c];
        List<Opportunity_TGP__c > opportunityList=[select id,Link_to_client_website__c,Link_to_Additional_Documents__c, name, SAP_OM_Opportunity__r.name, Client_Geo_Area__r.name, Client_Geo_Unit__r.name, 
                                Operating_Group__r.name from Opportunity_TGP__c];       
        //List<Event> lstevent = [Select Scheduled_By__c, Additional_Invitees__c, Meeting_Record_ID__c, Approver__c, Meeting_ID__c, Region__c, TCV__c, Estimated_TCV__c, Prime_SDO_Lead__c, Location, Subject, OwnerId , StartDateTime,EndDateTime from Event where StartDateTime>=:t+1 and StartDateTime<=:t+2];
        List<Event> lstevent = new List<Event>();
        if(strDay != null && !strDay.equalsIgnoreCase('Friday'))
        {
            lstevent = [Select Scheduled_By__c, Additional_Invitees__c, Meeting_Record_ID__c, Approver__c, Meeting_ID__c, Region__c, TCV__c, Estimated_TCV__c, Prime_SDO_Lead__c, Location, Subject, OwnerId , StartDateTime,EndDateTime from Event where StartDateTime = NEXT_N_DAYS:1 order by StartDateTime];
        }else if(strDay != null && strDay.equalsIgnoreCase('Friday'))
        {
            lstevent = [Select Scheduled_By__c, Additional_Invitees__c, Meeting_Record_ID__c, Approver__c, Meeting_ID__c, Region__c, TCV__c, Estimated_TCV__c, Prime_SDO_Lead__c, Location, Subject, OwnerId , StartDateTime,EndDateTime from Event where StartDateTime = NEXT_N_DAYS:3 order by StartDateTime];    
        }
        
        List<Calendar_Event__c> calEvent=[select id, name, Description__c, Review_Meeting_Request__c from Calendar_Event__c];
        
        List<Messaging.SingleEmailMessage> emailMsgList = new List<Messaging.SingleEmailMessage>();
        DateTime dateVal=DateTime.now()+1;
        if(strDay != null && strDay.equalsIgnoreCase('Friday'))
        {
            dateVal=DateTime.now()+3;
        }
        String supScriptVal = '';
        supScriptVal = getDateSupScript(dateVal);   
        String firstPart='<html>' +
                        '<body>' +
                        '<STYLE type="text/css">' +                        
                        '</STYLE>' +
                        '<font face="Calibri (Body)" style="font-size:11pt"><p>' +
                        '</p>';
        String secondPart='';
        String secondPart1='';
        String secondPart2='';
        String secondPart3='';
        String secondPart4='';
        String secondPart5='';        
        String secondPartWithNoCal='';
        String sixthPartWithNoCal='';
        
        String emptyRow='<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+
                            'No Call</font></td>'+'<td width="550" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt"></td>'
                            +'<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt"></td>'
                            +'<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt"></td>'
                            +'<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt"></td>'
                            +'<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt"></td>'
                            +'<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt"></td>'
                            +'<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt"></td>'
                            +'<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt"></td>'
                            +'<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt"></td>'
                            +'<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt"></td>'
                            ;
        
        String thirdPart='<p>Below is the agenda for the  '+ dateVal.format('EEEE, MMMMM dd') +'<sup>'+supScriptVal+'</sup> approval calls. To access review materials for the meeting click on the Opportunity Documents link below.  To access opportunity details click on the Opportunity Name link <i>(requires Solution Workbench access)</i>.<br/>';
                        
        String fourthPart='<table border="1" cellpadding="5">'+
                        '<tr height="20">'+
                        '<th width="500" style="border:solid #BFBFBF 1.0pt;background-color: #c7c7c7;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Start Time</font></b></th>'+
                        +'<th width="500" style="border:solid #BFBFBF 1.0pt;background-color: #c7c7c7;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Solution Development Approver</font></b></th>'+
                        //'<th width="600" style="width:73.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">End Time</font></b></th>'+
                        '<th width="500" style="border:solid #BFBFBF 1.0pt;background-color: #c7c7c7;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Review Type</font></b></th>'+
                        '<th width="600" style="border:solid #BFBFBF 1.0pt;background-color: #c7c7c7;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Region</font></b></th>'+
                        '<th width="500" style="border:solid #BFBFBF 1.0pt;background-color: #c7c7c7;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Client Local Geo</font></b></th>'+
                        '<th width="600" style="border:solid #BFBFBF 1.0pt;background-color: #c7c7c7;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Client Name</font></b></th>'+
                        '<th width="500" style="border:solid #BFBFBF 1.0pt;background-color: #c7c7c7;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt"></font>Opportunity Name</b></th>'+
                        //'<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Operating Group</font></b></th>'+
                        '<th width="500" style="border:solid #BFBFBF 1.0pt;background-color: #c7c7c7;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">BPO Net Revenue<br/>(Thousands)</font></b></th>'+
                        '<th width="500" style="border:solid #BFBFBF 1.0pt;background-color: #c7c7c7;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Offering(s)</font></b></th>'+
                        //'<th width="500" style="border:solid #BFBFBF 1.0pt;background-color: #c7c7c7;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Delivery Locations</font></b></th>'+
                        +'<th width="500" style="border:solid #BFBFBF 1.0pt;background-color: #c7c7c7;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Prime SDO Lead</font></b></th>'+
                        '<th width="500" style="border:solid #BFBFBF 1.0pt;background-color: #c7c7c7;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Lead Solution Architect – BPO</font>'+
                        '<th width="500" style="border:solid #BFBFBF 1.0pt;background-color: #c7c7c7;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt"></font>Opportunity Documents</b></th>'+
                        '</b></th>';
                        /*'<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Solution Specialist(s)</font></b></th>'+
                        '<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Meeting ID</font></b></th>'+
                        '<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Subject</font></b></th>'+
                        '<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Scheduled By</font></b></th>'+
                        '<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Title</font></b></th>'+
                        '<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Other Attendees</font></b></th>'+
                        '<th width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Status</font></b></th>'+*/
                       
        String fifthPart='';
        String sixthPart='';
        String tableRows1='';
        String meetTime='';
        String sdoLeadName = '';
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
                                                List<Opportunity_team__c> oppTeamList = [SELECT Id,Roles__r.Name,Opportunity_team_Member__c,Opportunity_team_Member__r.Name,Offering__c,BPO_Opportunity__c from Opportunity_team__c where Roles__r.Name =: 'Prime SDO Lead' AND Offering__c =: null AND BPO_Opportunity__c = : opp.id LIMIT 1];
                                                if(oppTeamList.size() > 0) {
                                                    sdoLeadName = oppTeamList[0].Opportunity_team_Member__r.Name;
                                                }
                                                else if(oppTeamList.size() == 0) {
                                                    sdoLeadName = '';
                                                }
                                                for(Event e: lstevent1)
                                                {   system.debug('---r.Meeting_Time__c--for loop-'+r.Meeting_Time__c);
                                                    if(e.id==newEvent.id)
                                                    {
                                                    meetTime=r.Meeting_Time__c;
                                                    String region=r.Client_Geo_Area__c;
                                                    String clientOpNameStr = r.Client_Name__c + '<b> – </b>' + r.Opportunity_Name__c;
                                                        system.debug('---clientOpNameStr-if--'+clientOpNameStr);
                                                        if(meetTime.contains('7am'))
                                                        {
                                                        
                                                            if(region!='EALA'){
                                                                      secondPart1=secondPart1+'{'+region+' Call using EMEA Slot}'+ '<b> – </b>'+checkNullValues(clientOpNameStr);
                                                                        
                                                            }
                                                            else{
                                                             secondPart1=secondPart1+checkNullValues(clientOpNameStr);
                                                                
                                                            }
                                                        }
                                                        if(meetTime.contains('10am'))
                                                        {
                                                            if(region!='North America'){
                                                                secondPart2=secondPart2+'{'+region+' Call using North America Slot}'+ '<b> – </b>' +checkNullValues(clientOpNameStr);
                                                                
                                                            }
                                                                else{
                                                                secondPart2=secondPart2+checkNullValues(clientOpNameStr);
                                                                
                                                            }    
                                                        }
                                                        if(meetTime.contains('2:30 am'))
                                                        {
                                                            if(region!= UTIL_Constants.AsiaPacific){
                                                        secondPart3=secondPart3+'{'+region+' Call using Asia Pacific Slot}'+ '<b> – </b>&nbsp; ';
                                                               
                                                        }   else{
                                                                secondPart3=secondPart3+checkNullValues(clientOpNameStr)+'<b>';
                                                                
                                                            }                                                            
                                                        }
                                                        //String strStartDate=newEvent.StartDateTime.format('hh:mma','America/El_Salvador');
                                                        //strStartDate = strStartDate.toLowerCase();
                                                        String strStartDate;
                                                        TimeZone tz  = UserInfo.getTimeZone();
                                                        String userTimeZone = UTIL_Constants.TIME_ZONE;
                                                        if(tz != null)
                                                        {
                                                            userTimeZone = tz.getID();
                                                        }
                                                            strStartDate=e.StartDateTime.format('h:mm a',userTimeZone); 
                                                        strStartDate = strStartDate.toLowerCase();
                                                        
                                                        if(meetTime.contains('Non Standard Call Time')){
                                                            secondPart4 = secondPart4+strStartDate+' CST Non Standard Call – '+'{'+region+' Call using Non Standard Call Time Slot}'+ '<b> – </b>' +checkNullValues(clientOpNameStr)+'<b> (Solution Development Approver: '+e.Approver__c+')</b>&nbsp;<BR/> ';
                                                        }
                                                       
                                                        if(meetTime.contains('Approvals for <10M')){
                                                            secondPart5 = secondPart5+strStartDate+' CST Approvals for <10M Call – '+'{'+region+' Call using Approvals for <10M Slot}'+ '<b> – </b>' +checkNullValues(clientOpNameStr)+'<b> (Solution Development Approver: '+e.Approver__c+')</b>&nbsp;<BR/> ';
                                                       
                                                        }
                                                                                                                   
                                                    }
                                              
                                                        /*tableRows1='<tr height="20">'+
                                                        '<td width="550" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;width:10%;"> <font face="Calibri (Body)" style="font-size:11pt">'+
                                                        'APAC <br>(10pm CST)<br/></font></td>'+emptyRow+'</tr>'; 
                                                        */
                                               
                                                   
                                                }
                                                
                                                
                                                 
                                               
                                                String retString= formTable24Hours(lstevent1, newEvent.id, r.Client_Name__c,r.Opportunity_Name__c, r.Opportunity_ID__c, 
                                                                    r.Opportunity_Solution_lead__c, r.Offering__c, r.Solution_Specialist__c, opp.Client_Geo_Area__r.name, 
                                                                    opp.Client_Geo_Unit__r.name, opp.Operating_Group__r.name, outboundMasterList, us, cal.Description__c, opp.id,  r.Meeting_Time__c,opp.Link_to_Additional_Documents__c,sdoLeadName);
                                                                    
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
               system.debug('---fifthPart-------'+fifthPart+'----------------meetTime------'+meetTime);
            String tableRow1='';
            String tableRow2='';
            String tableRow3='';
            String tableRow4='';
            String tableRow5='';
            /*if(!fifthPart.contains('EALA')){
                    tableRow1='<tr height="20">'+
                                '<td width="550" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;width:10%;"> <font face="Calibri (Body)" style="font-size:11pt">'+
                                'EALA<br/>(7am CST)</font></td>'+emptyRow+'</tr>';
                    tableRows1=tableRows1+tableRow1; 
              }
             if(!fifthPart.contains('North America <br/>')){
                    
                    tableRow2='<tr height="20">'+
                                '<td width="550" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;width:10%;"> <font face="Calibri (Body)" style="font-size:11pt">'+
                                'North America <br/>(10am CST)</font></td>'+emptyRow+'</tr>'; 
                    tableRows1=tableRows1+tableRow2;
             }
             if(!fifthPart.contains('Non Standard Call Time')){
                    
                    tableRow3='<tr height="20">'+
                                '<td width="550" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;width:10%;"> <font face="Calibri (Body)" style="font-size:11pt">'+
                                'Non Standard Call Time</font></td>'+emptyRow+'</tr>'; 
                    tableRows1=tableRows1+tableRow3;
             }
             if(!fifthPart.contains('Approvals for')){
                    
                    tableRow4='<tr height="20">'+
                                '<td width="550" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;width:10%;"> <font face="Calibri (Body)" style="font-size:11pt">'+
                                'Approvals for <10M</font></td>'+emptyRow+'</tr>'; 
                    tableRows1=tableRows1+tableRow4;
             }
             if(!fifthPart.contains('UTIL_Constants.AsiaPacific<br/>')){
                        
                    tableRow5='<tr height="20">'+
                                '<td width="550" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;width:10%;"> <font face="Calibri (Body)" style="font-size:11pt">'+
                                'UTIL_Constants.AsiaPacific <br/>(10pm CST)</font></td>'+emptyRow+'</tr>'; 
                                tableRows1=tableRows1+tableRow5;
             }*/
             /*else{
                tableRows1='';
             }*/
             sixthPart=tableRows1+'</table>' + 
                         '</tr>' +'<p>To view all upcoming approval calls please go to the ' +
                        '<a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ApprovalProcessPage?tabValue=tab1" target="_parent">Approval Calendar</a>&nbsp;&nbsp;<i>(requires Solution Workbench access).</i>'+
                        +'&nbsp;&nbsp;The Approval Calendar can also be '+'<a href ="https://kxsites.accenture.com/groups/BPOSA/Adverts/Integrate Approval Calendar with Outlook Instructions.docx" target="_parent">integrated into Outlook  </a>  &nbsp;&nbsp;<i>(does not require Solution Workbench access)</i>.</p>'+  
                        '<br/>' +
                        '<b>Meeting Details:</b><br/><br/>'+checkNullValues(descriptionDetails)+ '<br/><br/>'+                        
                        '<p>This is a system generated message. Please do not reply to this message.</p>' +
                        '</font></body>' +
                        '</html>';
            
          
          
            //From Address, Set from organisation wide address.
            /*OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};
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
            mail.setSubject('BPO Solution Approval call agenda for '+dateVal.format('MMM-dd'));            
            mail.setHtmlBody(firstPart+secondPart+thirdPart+fourthPart+fifthPart+sixthPart);
            mail.saveAsActivity=false;
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});*/
            if(meetingList.size()>0)
            {
                for(Review_Meeting_Request__c r : meetingList) 
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
        mail.setSubject('BPO Solution Approval call agenda for '+dateVal.format('MMM-dd'));            
        if (lstevent.size()>0)
        {
            mail.setHtmlBody(firstPart+secondPart+thirdPart+fourthPart+fifthPart+sixthPart);
        }else
        {
            mail.setSubject('No Calls : BPO Solution Approval call agenda for '+dateVal.format('MMM-dd'));
            thirdPart = 'There are no Solution approval calls scheduled for ' +dateVal.format('MMM-dd');                      
                                                
             mail.setHtmlBody(firstPart+secondPart+thirdPart);
          
        }
        mail.saveAsActivity=false;
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        
    }    
    
    /******************************
    Method Name: formTable24Hours
    Description: Send email for all events scheduled 24 Hours before
    Paramenters: NA
    Return Value: void
    *******************************/
    public static String formTable24Hours(List<Event> lstevent, String eventID, String clientName, String oppName,String oppID, 
                                        String oppSolLead,String offerings,String solSpecialists, String geoArea, String geoUnit, String opGroup, 
                                        List<Outbound_Email_User_Master__c> outboundMasterList, List<User> us, String description, String opportunityID, String meetingTime,String OpportunityLink,String primeSDOLead)
    {
        String tableRows='';
        
        List<Opportunity_TGP__c> offeringsForLocation = new List<Opportunity_TGP__c>(); 
        
        /*if(offerings!=null) 
        { 
            offerings = offerings.substring(0,offerings.length()-1); 
        }*/
        
        if(opportunityID != null && opportunityID != '') {   
            Id OpporId = Id.valueOf(opportunityID);   
            offeringsForLocation = [Select id,Name,Service_Delivery_Locations_Unique__c from Opportunity_TGP__c where id =: OpporId];                 
        }
            
        String finalDeliveryLocationUniqueString = '';
                    
        if(offeringsForLocation  != null && offeringsForLocation.size() > 0)
        {
            for (Opportunity_TGP__c allOfferingsRelatedToNewOpportunity : offeringsForLocation)
            {
                finalDeliveryLocationUniqueString = allOfferingsRelatedToNewOpportunity.Service_Delivery_Locations_Unique__c;
            }
        }        
        /*integer lengthOfString = finalDeliveryLocationUniqueString.length();
        if(lengthOfString > 2)
        {
            finalDeliveryLocationUniqueString = finalDeliveryLocationUniqueString.substring(0,lengthOfString-2);                
        } */    
            
        if (lstevent.size()>0)
        {   
            for(Event e: lstevent)
            {
               /*  String strStartDate=e.StartDateTime.format('MM-dd-yyyy HH:mm:ss','America/El_Salvador');
                 String strStartDateForNonStndCall=e.StartDateTime.format(' (hh:mma','America/El_Salvador');
                 strStartDateForNonStndCall = strStartDateForNonStndCall.toLowerCase();
                 String strEndDate=e.EndDateTime.format('MM-dd-yyyy HH:mm:ss','America/El_Salvador');*/
                String strStartDateForNonStndCall;
                String strEndDate;
                TimeZone tz  = UserInfo.getTimeZone();
                String userTimeZone = UTIL_Constants.TIME_ZONE;
                if(tz != null)
                {
                    userTimeZone = tz.getID();
                }
                String strStartDate=e.StartDateTime.format('MM-dd-yyyy HH:mm:ss',userTimeZone);
                strStartDateForNonStndCall=e.StartDateTime.format('hh:mma',userTimeZone);//e.StartDateTime.format(' (hh:mma',userTimeZone);
                strStartDateForNonStndCall = strStartDateForNonStndCall.toLowerCase();
                strEndDate= e.EndDateTime.format('MM-dd-yyyy h:mm a',userTimeZone);
                 String row1='';
                //String strSD=e.StartDateTime.format('MM-dd-yyyy');
                if(e.id==eventID)
                {
                    
                    
                    tableRows='<tr height="20">'+
                            '<td width="600" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;width:7%;"> <font face="Calibri (Body)" style="font-size:11pt">';
                            if(meetingTime=='EMEA (7am CST)')
                            {
                                meetingTime=meetingTime.subString(0,4);
                                tableRows= tableRows + meetingTime+'<br/>(7am CST)';
                                
                            }
                            else if(meetingTime==UTIL_Constants.AsiaPacific_twothirtyCST){
                                   meetingTime=meetingTime.subString(0,12);
                                  tableRows= tableRows + meetingTime+'<br/>(2:30 am CST)';
                            }
                            else if(meetingTime=='North America (10am CST)'){
                                    meetingTime=meetingTime.subString(0,13);
                                     tableRows= tableRows + meetingTime+'<br/>(10am CST)';  
                            }
                            else if(meetingTime=='LATAM (8 am CST)'){
                                    meetingTime=meetingTime.subString(0,5);
                                     tableRows= tableRows + meetingTime+'<br/>(8am CST)';   
                            }
                            else //if(meetingTime=='Non Standard Call Time')
                            {
                                tableRows= tableRows +meetingTime +'<br/>('+strStartDateForNonStndCall+' CST)';
                                
                            }
                            tableRows= tableRows +'</font></td>'+
                            //'<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+e.EndDateTime+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+e.Approver__c+'</font></td>'+
                            +'<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+e.Meeting_Type__c+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+geoArea+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(geoUnit)+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+clientName+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+
                            '<a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/BPO_Opportunity_tab?id='+opportunityID+'" target="_parent">'+oppName+'</a>'+
                            '</font></td>'+
                            
                            //'<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+opGroup+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+checkNullValuesDeciamlTCV(e.Estimated_TCV__c)+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(offerings)+'</font></td>'+
                            //'<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(finalDeliveryLocationUniqueString)+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+primeSDOLead+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+oppSolLead+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+
                            '<a href ="'+checkNullValues(OpportunityLink)+'">' +checkNullValues(OpportunityLink)+'</a>'+'</font></td>'+
                            /*'<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(solSpecialists)+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(e.Approver__c)+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+e.Meeting_ID__c+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+e.Subject+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(e.Scheduled_By__c)+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+e.Title__c+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(e.Additional_Invitees__c)+'</font></td>'+
                            '<td width="500" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> <font face="Calibri (Body)" style="font-size:11pt">'+e.Status__c+'</font></td>'+*/
                            '</tr>';
                }
                else{}
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
    
    /******************************
    Method Name: getDateSupScript
    Description: Method to get superscript text and return string.
    Paramenters: String
    Return Value: String 
    *******************************/
    public Static String getDateSupScript(DateTime dateValue)
    {
        String supVal = '';
        String dayVal = dateValue.day() + '';
        Map<String,String> dayMap = new Map<String,String>();
        dayMap.put('1','st');
        dayMap.put('2','nd');
        dayMap.put('3','rd');
        
        if(dayVal != null && dayVal.length() > 0)
        {
            if(dayVal.length() == 1 )
                supVal = dayMap.get(dayVal);
            else if(dayVal.length() == 2)
            {
                if(!dayVal.equals('11') && !dayVal.equals('12') && !dayVal.equals('13')){
                    dayVal = dayVal.substring(1,2);
                    supVal = dayMap.get(dayVal);                    
                }else{
                    supVal = 'th';
                }                   
            }
            if(supVal == null)
            {
                supVal = 'th';
            }         
       }
        return supVal;       
    }  
}