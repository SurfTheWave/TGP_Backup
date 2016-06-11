/*
Description : Mass Email
Author : Shridhar Patankar
Story no. :Story-0204/Sol_128
Updated by        Story no                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

              
*/
public class EmailClientGeoAreaSendEmail{
 public  static List<Opportunity_TGP__c> oppTGP = new List<Opportunity_TGP__c>();
 public  static List<Opportunity_Offering__c > offering1 = new List<Opportunity_Offering__c >();
 public static String pageid;
 public static String strUrl{get;set;}
 public static Opportunity_TGP__c OTGP;
 
 public EmailClientGeoAreaSendEmail(){
  strUrl = URL.getSalesforceBaseUrl().toExternalForm();
  pageid= ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);
 
 }
    /******************************
    Method Name: sendMail
    Description: To Send Email Addresses to users
    Paramenters: List<Opportunity_TGP__c> lstOldoppTGP,List<Opportunity_TGP__c>lstNewoppTGP
    Return Value: NA
    *******************************/ 
    public static void sendMail(List<Opportunity_TGP__c> lstOldoppTGP,List<Opportunity_TGP__c>lstNewoppTGP,List <Client_Geo_Area_Master__c> clientList,List <Client_Geo_Unit_Master__c> clientUnitList,List <Client_Master__c> clientMasterName,List <Operating_Group_Master__c> opGroup) { 
    oppTGP =[Select id,Activity__c,TCV__c,Client_Geo_Unit__r.name,Client_Name__r.name,name,Client_Geo_Area__r.name,SAP_OM_Opportunity__r.name,Stage__c,CreatedBy.Name,Enterprise_Solution_Architect_New__r.Name,
             Expected_contract_sign_qtr__c,Client_Geo_Area_Prior_Value__c,Operating_Group__r.name,Risk_Level__c from Opportunity_TGP__c where id=:lstOldoppTGP[0].id ]; 
    
    offering1 =[Select id,Opportunity_TGP__c,Offering_Prior_Value__c,Opportunity_TGP__r.Client_Name__r.name,Opportunity_TGP__r.name,Offering_Master__r.name,
                    Opportunity_TGP__r.SAP_OM_Opportunity__r.name,Opportunity_TGP__r.Stage__c,Opportunity_TGP__r.Expected_contract_sign_qtr__c,
                    Opportunity_TGP__r.TCV__c,Opportunity_TGP__r.Client_Geo_Area__r.name,Opportunity_TGP__r.Client_Geo_Unit__r.name,Opportunity_TGP__r.Activity__c,
                    Opportunity_TGP__r.Operating_Group__r.name,Opportunity_TGP__r.Risk_Level__c
                    from Opportunity_Offering__c];
      
   
   // EmailTemplate et=[Select id,name from EmailTemplate where id='00XL0000000M1jfMAC']; 
   //From Address, Set from organisation wide address.
   OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};
    List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c];
            if(lstIdForOWA.size()>0)
            {
                owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c ];
            }
   
   
   
   /* if(OfferingNames!=null) 
           { 
            
                OfferingNames= OfferingNames.substring(0,OfferingNames.length()-1); 
                
           } */
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    if ( owea.size() > 0 ) 
    {
    mail.setOrgWideEmailAddressId(owea.get(0).Id);
    } 
    //mail.setTargetObjectIds(getEmailAddresses());
    
    mail.setToAddresses(getEmailAddresses(lstOldoppTGP,lstNewoppTGP,clientList,clientUnitList,clientMasterName,opGroup));    
    mail.setSubject('NOTIFICATION: New Opportunity for '+ clientList[0].name + ' '+' -'+' '+ 'Client Name:' +' '+ clientMasterName[0].name +' '+ '- '+' '+'Opportunity Name:'+' '+ lstNewoppTGP[0].name);    
    String strClientGEOUnitName='';
    system.debug('===='+clientUnitList);
    system.debug('===='+strClientGEOUnitName);
    if(clientUnitList != null && clientUnitList.size()>0 && clientUnitList[0] != null)
    {
        strClientGEOUnitName=clientUnitList[0].name;
    }
    mail.setHtmlBody('<html>' +
'    <body>' +


'     <p><font face="Calibri (Body)" style="font-size:11pt" >A new opportunity has been added to the Solution Workbench for '+ clientList[0].name +''+' with the following details:</font></p>' +

'  <table border="1" rules="rows"  width="60%" cellpadding="5">' +
'  <tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt" ><b><font face="Calibri (Body)" style="font-size:11pt" >Client Name:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+clientMasterName[0].name+'</font>'+''+'</td>' +'<td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"></td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt" ><b><font face="Calibri (Body)" style="font-size:11pt" >Opportunity Name:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+lstNewoppTGP[0].Name+'</font>'+''+'</td>' +'<td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"></td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Opportunity ID:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(oppTGP[0].SAP_OM_Opportunity__r.name)+'</font>'+''+'</td>' +'<td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"></td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Lead Solution Architect – BPO:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+oppTGP[0].Enterprise_Solution_Architect_New__r.Name+'</font>'+''+'</td>' +'<td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"></td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Stage:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+lstNewoppTGP[0].Stage__c+'</font>'+''+'</td>' +'<td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"></td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Expected Contract Sign (Qtr):</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(lstNewoppTGP[0].Expected_contract_sign_qtr__c)+'</font>'+''+'</td>' +'<td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"></td>'+
'</tr>' +


'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >BPO Net Revenue (SAP OM)<br/>(Thousands):</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"></td>'+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValuesDeciamlTCV(lstNewoppTGP[0].TCV__c)+'</font>'+'<td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"></td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Client Geo Area:</font></b></td><td width="35%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+' '+'<strike>  '+'     '+ +'  '+'<p><font face="Calibri (Body)" style="font-size:11pt">'+lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c +'</font>'+ '</strike></td><td width="35%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+' '+'<p><font face="Calibri (Body)" style="font-size:11pt">'+clientList[0].name+'</font>'+' ' +'<font face="Calibri (Body)" style="font-size:11pt" color="#EEEA3"><b>Edited</b></font>'+'</td>' +
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Client Geo Unit:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+strClientGEOUnitName+'</font>'+''+'</td>' +'<td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"></td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Operating Group:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+opGroup[0].name+'</font>'+''+'</td>' +'<td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"></td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Offerings:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">' +checkNullValues(lstNewoppTGP[0].Offerings__c)+'</font>'+''+'</td>' +'<td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"></td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Delivery Locations:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">' + checkNullValues(lstNewoppTGP[0].Service_Delivery_Locations_Unique__c)+'</font>'+''+'</td>' +'<td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"></td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Requestor Name:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">' + oppTGP[0].CreatedBy.Name+'</font>'+''+'</td>' +'<td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"></td>'+
'</tr>' +

'<tr height="20">  ' +
'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Risk Level:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+lstNewoppTGP[0].Risk_Level__c+'</font>'+''+'</td>' +'<td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"></td>'+
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
    Method Name: getEmailAddresses
    Description: To retrieve Email Addresses of user
    Paramenters: NA
    Return Value: List<String>
    *******************************/  
    public static List<String> getEmailAddresses(List<Opportunity_TGP__c> lstOldoppTGP,List<Opportunity_TGP__c>lstNewoppTGP,List <Client_Geo_Area_Master__c> clientList,List <Client_Geo_Unit_Master__c> clientUnitList,List <Client_Master__c> clientMasterName,List <Operating_Group_Master__c> opGroup) {    
    List<String> idList = new List<String>();    
    List<String> mailToAddresses = new List<String>();
    //List for APAC,Latin America,EALA,North America
    List<String> lstGrpA = new List<String>();  
    List<String> lstGrpL = new List<String>();  
    List<String> lstGrpE = new List<String>();  
    List<String> lstGrpN = new List<String>(); 
    lstGrpA.add(UTIL_Constants.APAC_GROUP);
    lstGrpA.add(UTIL_Constants.DEAL_RADAR_GROUP);
    
    lstGrpL.add(UTIL_Constants.LATIN_AMERICA_GROUP);
    lstGrpL.add(UTIL_Constants.DEAL_RADAR_GROUP);
    
    lstGrpE.add(UTIL_Constants.EALA_GROUP);
    lstGrpE.add(UTIL_Constants.DEAL_RADAR_GROUP);
    
    lstGrpN.add(UTIL_Constants.NORTH_AMERICA_GROUP);
    lstGrpN.add(UTIL_Constants.DEAL_RADAR_GROUP);
     
    //List to change from Apac to others.Start
    List<String> lstGrpAL = new List<String>();  
    List<String> lstGrpAE = new List<String>();
    List<String> lstGrpAN = new List<String>();
    //End
    //List to change from Latin America to others.Start
    List<String> lstGrpLA = new List<String>();
    List<String> lstGrpLE = new List<String>();
    List<String> lstGrpLN = new List<String>();
    //End
    //List to change from EALA to APAC.Start
    List<String> lstGrpEA = new List<String>();
    List<String> lstGrpEL = new List<String>();
    List<String> lstGrpEN = new List<String>();
    //End
    //List to change from North America to others.Start
    List<String> lstGrpNA = new List<String>();
    List<String> lstGrpNL = new List<String>();
    List<String> lstGrpNE = new List<String>();
    //End
    String stringGrpA  = UTIL_Constants.APAC_GROUP;
    String stringGrpL = UTIL_Constants.LATIN_AMERICA_GROUP;
    String stringGrpE = UTIL_Constants.EALA_GROUP;
    String stringGrpN = UTIL_Constants.NORTH_AMERICA_GROUP; 
    lstGrpAL.add(UTIL_Constants.APAC_GROUP);
    lstGrpAL.add(UTIL_Constants.LATIN_AMERICA_GROUP);
    lstGrpAL.add(UTIL_Constants.DEAL_RADAR_GROUP);
    
    
    lstGrpAE.add(UTIL_Constants.APAC_GROUP); 
    lstGrpAE.add(UTIL_Constants.EALA_GROUP);
    lstGrpAE.add(UTIL_Constants.DEAL_RADAR_GROUP);
    
    lstGrpAN.add(UTIL_Constants.APAC_GROUP);
    lstGrpAN.add(UTIL_Constants.NORTH_AMERICA_GROUP);
    lstGrpAN.add(UTIL_Constants.DEAL_RADAR_GROUP);
    
    lstGrpLA.add(UTIL_Constants.LATIN_AMERICA_GROUP);
    lstGrpLA.add(UTIL_Constants.APAC_GROUP);
    lstGrpLA.add(UTIL_Constants.DEAL_RADAR_GROUP);
    
    lstGrpLE.add(UTIL_Constants.LATIN_AMERICA_GROUP);
    lstGrpLE.add(UTIL_Constants.EALA_GROUP);
    lstGrpLE.add(UTIL_Constants.DEAL_RADAR_GROUP);
    
    lstGrpLN.add(UTIL_Constants.LATIN_AMERICA_GROUP);
    lstGrpLN.add(UTIL_Constants.NORTH_AMERICA_GROUP);
    lstGrpLN.add(UTIL_Constants.DEAL_RADAR_GROUP);
    
    lstGrpEA.add(UTIL_Constants.EALA_GROUP);
    lstGrpEA.add(UTIL_Constants.APAC_GROUP);
    lstGrpEA.add(UTIL_Constants.DEAL_RADAR_GROUP);
    
    lstGrpEL.add(UTIL_Constants.EALA_GROUP);
    lstGrpEL.add(UTIL_Constants.LATIN_AMERICA_GROUP);
    lstGrpEL.add(UTIL_Constants.DEAL_RADAR_GROUP);
    
    lstGrpEN.add(UTIL_Constants.EALA_GROUP);
    lstGrpEN.add(UTIL_Constants.NORTH_AMERICA_GROUP);
    lstGrpEN.add(UTIL_Constants.DEAL_RADAR_GROUP);
    
    lstGrpNA.add(UTIL_Constants.NORTH_AMERICA_GROUP);
    lstGrpNA.add(UTIL_Constants.APAC_GROUP);
    lstGrpNA.add(UTIL_Constants.DEAL_RADAR_GROUP);
    
    lstGrpNL.add(UTIL_Constants.NORTH_AMERICA_GROUP);
    lstGrpNL.add(UTIL_Constants.LATIN_AMERICA_GROUP);
    lstGrpNL.add(UTIL_Constants.DEAL_RADAR_GROUP);
    
    lstGrpNE.add(UTIL_Constants.NORTH_AMERICA_GROUP);
    lstGrpNE.add(UTIL_Constants.EALA_GROUP);
    lstGrpNE.add(UTIL_Constants.DEAL_RADAR_GROUP);
    
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c== UTIL_Constants.APAC && clientList[0].name== UTIL_Constants.LATIN_AMERICA) && (lstNewoppTGP[0].Activity__c==UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED)){
    
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpAL]; 
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
    
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c== UTIL_Constants.APAC && clientList[0].name== UTIL_Constants.EALA) && (lstNewoppTGP[0].Activity__c==UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
    
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpAE]; 
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
    
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c== UTIL_Constants.APAC && clientList[0].name==UTIL_Constants.NORTH_AMERICA ) && (lstNewoppTGP[0].Activity__c== UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c==UTIL_Constants.UNQUALIFIED )){
    
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpAN]; 
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
    
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c== UTIL_Constants.LATIN_AMERICA && clientList[0].name==UTIL_Constants.APAC) && (lstNewoppTGP[0].Activity__c== UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
   
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpLA]; 
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
    
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c== UTIL_Constants.LATIN_AMERICA && clientList[0].name== UTIL_Constants.EALA ) && (lstNewoppTGP[0].Activity__c== UTIL_Constants.PIPELINE  || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
   
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpLE]; 
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
    
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c== UTIL_Constants.LATIN_AMERICA && clientList[0].name== UTIL_Constants.NORTH_AMERICA) && (lstNewoppTGP[0].Activity__c==UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
    
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpLN]; 
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
    
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c== UTIL_Constants.EALA && clientList[0].name== UTIL_Constants.APAC) && (lstNewoppTGP[0].Activity__c==UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
    
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpEA]; 
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
    
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c== UTIL_Constants.EALA && clientList[0].name== UTIL_Constants.LATIN_AMERICA) && (lstNewoppTGP[0].Activity__c==UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
    
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpEL]; 
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
    
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c== UTIL_Constants.EALA && clientList[0].name== UTIL_Constants.NORTH_AMERICA) && (lstNewoppTGP[0].Activity__c==UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
    
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpEN]; 
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
    
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c== UTIL_Constants.NORTH_AMERICA && clientList[0].name== UTIL_Constants.APAC) && (lstNewoppTGP[0].Activity__c==UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
    
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpNA]; 
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
     
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c== UTIL_Constants.NORTH_AMERICA && clientList[0].name== UTIL_Constants.LATIN_AMERICA) && (lstNewoppTGP[0].Activity__c==UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
    
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpNL]; 
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
    
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c== UTIL_Constants.NORTH_AMERICA && clientList[0].name== UTIL_Constants.EALA) && (lstNewoppTGP[0].Activity__c==UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
    
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpNE]; 
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
    
    //APAC,Latin America,EALA,NA to any 
    
    
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c== UTIL_Constants.APAC && clientList[0].name!= UTIL_Constants.LATIN_AMERICA && clientList[0].name!= UTIL_Constants.EALA && clientList[0].name!= UTIL_Constants.NORTH_AMERICA) && (lstNewoppTGP[0].Activity__c==UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
   
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
     
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c== UTIL_Constants.LATIN_AMERICA && clientList[0].name!= UTIL_Constants.APAC && clientList[0].name!= UTIL_Constants.EALA && clientList[0].name!= UTIL_Constants.NORTH_AMERICA)  && (lstNewoppTGP[0].Activity__c==UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
   
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpL]; 
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
    
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c== UTIL_Constants.EALA && clientList[0].name!= UTIL_Constants.LATIN_AMERICA && clientList[0].name!= UTIL_Constants.APAC && clientList[0].name!= UTIL_Constants.NORTH_AMERICA)  && (lstNewoppTGP[0].Activity__c==UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
    
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpE]; 
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
     
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c== UTIL_Constants.NORTH_AMERICA && clientList[0].name!= UTIL_Constants.LATIN_AMERICA && clientList[0].name!= UTIL_Constants.EALA && clientList[0].name!= UTIL_Constants.APAC)  && (lstNewoppTGP[0].Activity__c==UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
   
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpN]; 
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
    
    //Any to APAC,Latin America,EALA,NA
     
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c!= UTIL_Constants.LATIN_AMERICA && lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c!= UTIL_Constants.EALA && lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c!= UTIL_Constants.NORTH_AMERICA && clientList[0].name== UTIL_Constants.APAC) && (lstNewoppTGP[0].Activity__c== UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
    
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
     
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c!= UTIL_Constants.APAC && lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c!= UTIL_Constants.EALA && lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c!= UTIL_Constants.NORTH_AMERICA && clientList[0].name== UTIL_Constants.LATIN_AMERICA) && (lstNewoppTGP[0].Activity__c==UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
    
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpL]; 
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
     
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c!= UTIL_Constants.LATIN_AMERICA && lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c!= UTIL_Constants.APAC && lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c!= UTIL_Constants.NORTH_AMERICA && clientList[0].name== UTIL_Constants.EALA) && (lstNewoppTGP[0].Activity__c==UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
    
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpE]; 
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
     
    if((lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c!= UTIL_Constants.LATIN_AMERICA && lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c!= UTIL_Constants.EALA && lstNewoppTGP[0].Client_Geo_Area_Prior_Value__c!= UTIL_Constants.APAC  && clientList[0].name== UTIL_Constants.NORTH_AMERICA) && (lstNewoppTGP[0].Activity__c==UTIL_Constants.PIPELINE || lstNewoppTGP[0].Activity__c== UTIL_Constants.UNQUALIFIED )){
   
    List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name in :lstGrpN]; 
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
    
     return null;
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
            return ''+ '$' +String.ValueOf(value.setScale(0).format()); // Code added by Ayush for D - 1791 A
        
    } 
}