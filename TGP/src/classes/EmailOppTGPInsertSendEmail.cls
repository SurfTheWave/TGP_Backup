/*
Description : Send Email to Deal radar group when opportunity is created.
Author : Shridhar Patankar
Story no. :Story-0204/Sol_128

Updated by        Story no                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

              
*/
public class EmailOppTGPInsertSendEmail{
 public static List<Opportunity_TGP__c> oppTGP = new List<Opportunity_TGP__c>();
 public static List<Opportunity_TGP__c> lstNewoppTGP;
 public static String pageid;
 public static String strUrl{get;set;}
 public static Opportunity_TGP__c OTGP;
 public EmailOppTGPInsertSendEmail(){
  strUrl = URL.getSalesforceBaseUrl().toExternalForm();
  pageid= ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);
 
 }
    
    /******************************
    Method Name: sendMail
    Description: To Send Email Addresses to users
    Paramenters: List<Opportunity_TGP__c> lstOldoppTGP,List<Opportunity_TGP__c>lstNewoppTGP
    Return Value: NA
    *******************************/ 
    public static void sendMailInsert(Opportunity_TGP__c lstNewoppTGP1) { 
    
    lstNewoppTGP=[Select id,Activity__c,TCV__c,Offerings__c,Client_Geo_Unit__r.name,Client_Name__r.name,name,Client_Geo_Area__r.name,SAP_OM_Opportunity__r.name,Stage__c,CreatedBy.Name,Enterprise_Solution_Architect_New__r.Name,Opportunity_Client__c,
                  Expected_contract_sign_qtr__c,Client_Geo_Area_Prior_Value__c,Service_Delivery_Locations_Unique__c,Operating_Group__r.name,Risk_Level__c from Opportunity_TGP__c where id=:lstNewoppTGP1.id]; 
            
   
   // EmailTemplate et=[Select id,name from EmailTemplate where id='00XL0000000M1jfMAC']; 
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
    
    mail.setToAddresses(getEmailAddressesInsert());    
    mail.setSubject('NOTIFICATION: New Opportunity added to Solution Workbench - '+ 'Client Name:' +' '+ lstNewoppTGP[0].Client_Name__r.name +' - '+ ' '+'Opportunity Name:'+' '+ lstNewoppTGP[0].name);    

    mail.setHtmlBody('<html>' +
'    <body>' +
'   <STYLE type="text/css">' +
               
'</STYLE>' +

'     <p><font face="Calibri (Body)" style="font-size:11pt" >A new opportunity has been added to the Solution Workbench with the following details:</font></p>' +

'  <table border="1" rules="rows"  width="60%" cellpadding="5">' +
'  <tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt" ><b><font face="Calibri (Body)" style="font-size:11pt" >Client Name:</font></b></td><td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+lstNewoppTGP[0].Client_Name__r.name+'</font>'+''+'</td>' +
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt" ><b><font face="Calibri (Body)" style="font-size:11pt" >Opportunity Name:</font></b></td><td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+lstNewoppTGP[0].Name+'</font>'+''+'</td>' +
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Opportunity ID:</font></b></td><td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(lstNewoppTGP[0].SAP_OM_Opportunity__r.name)+'</font>'+''+'</td>' +
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Lead Solution Architect – BPO:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+lstNewoppTGP[0].Enterprise_Solution_Architect_New__r.Name+'</font>'+''+'</td>' +
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Stage:</font></b></td><td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+lstNewoppTGP[0].Stage__c+'</font>'+''+'</td>' +
'</tr>' +

'<tr height="20">  ' +
'<td width="30%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Expected Contract Sign (Qtr):</font></b></td><td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(lstNewoppTGP[0].Expected_contract_sign_qtr__c)+'</font>'+''+'</td>' +
'</tr>' +


'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >BPO Net Revenue (MMS)<br/>(Thousands):</font></b></td><td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"></td>'+'<p><font face="Calibri (Body)" style="font-size:11pt">'+ checkNullValuesDeciamlTCV(lstNewoppTGP[0].TCV__c)+'</font>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Client Geo Area:</font></b></td><td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><p><font face="Calibri(Body)" style="font-size:11pt">'+lstNewoppTGP[0].Client_Geo_Area__r.name +'</font></p></td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Client Geo Unit:</font></b></td><td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><p><font face="Calibri(Body)" style="font-size:11pt">'+checkNullValues(lstNewoppTGP[0].Client_Geo_Unit__r.name)+'</font></p></td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Operating Group:</font></b></td><td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><p><font face="Calibri(Body)" style="font-size:11pt">'+lstNewoppTGP[0].Operating_Group__r.name+'</font></p></td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Offerings:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">' +checkNullValues(lstNewoppTGP[0].Offerings__c)+'</font></p></td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Delivery Locations:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">' + checkNullValues(lstNewoppTGP[0].Service_Delivery_Locations_Unique__c)+'</font></p></td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Requestor Name:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">' + lstNewoppTGP[0].CreatedBy.Name+'</font></p></td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Opportunity Client:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">' + lstNewoppTGP[0].Opportunity_Client__c+'</font></p></td>'+
'</tr>' +

'</table>' +

'<br/>' +
'    <font face="Calibri (Body)" style="font-size:11pt" ><a href ="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/BPO_Opportunity_tab?id='+lstNewoppTGP[0].id+ '" target="_parent">Login to BPO Solution Workbench</a>' + '<a>(option for those who have a workbench license)</a>' +
'    <p>This is a system generated message. Please do not reply to this message.</p></font>' +
'</body>' +
'</html>'
);

    //mail.setSenderDisplayName('TGP Support');
    mail.saveAsActivity=false;  
//    String[] toAddresses;
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
 /******************************
    Method Name: getEmailAddressesInsert
    Description: To retrieve Email Addresses of user
    Paramenters: NA
    Return Value: List<String>
    *******************************/  
    public static List<String> getEmailAddressesInsert() {    
    List<String> idList = new List<String>();    
    List<String> mailToAddresses = new List<String>();
    //List for Deal Radar Group
    List<String> lstGrpA = new List<String>();  
    
    lstGrpA.add(UTIL_Constants.DEAL_RADAR_GROUP);
    
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpA]; 
    for(integer i=0;i<g.size();i++ )
    {
        for (GroupMember gm : g[i].groupMembers) {        
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
    Method Name: checkNullValues
    Description: Method to check null and return empty string.
    Paramenters: String
    Return Value: String 
    *******************************/
    public Static String checkNullValues(String value)
    {
        if(value==null || String.isEmpty(value))
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
            return ''+ '$' +String.ValueOf(value.setScale(0).format());
        
    } 
}