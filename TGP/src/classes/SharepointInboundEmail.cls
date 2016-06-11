/**
 * Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 */
global class SharepointInboundEmail implements Messaging.InboundEmailHandler
{
    private static final string CLASS_NAME = 'SharepointInboundEmail';
    private static final string TRIGGER_NAME = 'SharePoint Integration';
    private static final string METHOD_INSERT = 'handleInboundEmail';  
 global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
    Messaging.InboundEnvelope envelope) 
    {
    Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
    String orgLink = '';
    String myPlainText= '';
    String subject = '';
    subject = email.subject;
    myPlainText = email.plainTextBody;
    System.debug('Plain text+++++++++++' + myPlainText );
    
    List<String> links = new List<String>();
    
    String[] split = myPlainText.split('Last Modified');
    System.debug('++++++'+split);
    String secondString = split[1].trim();
    
    String[] split1 = secondString.split('by');
     System.debug('++++++'+split1);
    String modifedDate = split1[0].trim();
    String thirdString = split1[1].trim();
    
    Integer split2 = thirdString.indexOf('\n');
    
    String modifiedBy = thirdString.substring(0,split2+1);
    
    DateTime modified = DateTime.parse(modifedDate);
    
     System.debug('++++++'+modifedDate);
     System.debug('++++++'+modifiedBy);
     System.debug('++++++'+modified);
     //System.debug('++++++'+date4);
    
    Pattern myPattern = Pattern.compile('\\<([^>]*)\\>');
    Matcher myMatch = myPattern.matcher(myPlainText);

    // loops till we reach the end of our group matches
    while (myMatch.find()) {    
        // pass our match to a string to manipulate
        String matchingPattern = myMatch.group(1);
        links.add(matchingPattern);
    }

    Integer count = 0;
    //Integer count1 = 0;
    for(integer i=0;i<links.size();i++)
    {
        System.debug('links+++++     ['+i+']   '+links[i] );
        if(links[i].contains('%2520')) {
            links[i] = links[i].replace('%2520',' ');
        }
        else if(links[i].contains('%20')) {
            links[i] = links[i].replace('%20',' ');
        }
        
        System.debug('links+++++     ['+i+']   '+links[i] );
        
        if(links[i].contains(System.Label.document_folder_name)) {
            count = i;
            orgLink = links[i].replaceAll(' ','%20');
        }
        /*else {
            count1 = count1 + 1;
        }*/
    }
    
    if(/*count1 == links.size() && */myPlainText.contains('has been added') && !((myPlainText.contains(System.Label.Opportunity_Documents)) || (myPlainText.contains('View E2E Workbench Shared Folders<')))) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c limit 5000];
              OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};                                
              if(lstIdForOWA.size()>0) {
                  owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c limit 5000];
              }
              if (owea.size() > 0 ) {
                  mail.setOrgWideEmailAddressId(owea.get(0).Id);
              } 
              List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name = 'Alert SharePoint Group']; 
              Set<Id> idList = new Set<Id>();
              String[] mailToAddresses  = new String[]{};
              for (GroupMember gm : g[0].groupMembers) {        
                      idList.add(gm.userOrGroupId);
              } 
              User[] usr = [SELECT email FROM user WHERE id IN :idList];    
              for(User u : usr) {        
                  mailToAddresses.add(u.email);    
              }
              mail.setToAddresses(mailToAddresses);
              mail.setSubject(subject);
              String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                        +'The following alert was not captured by SWB. Kindly handle the alert manually.'+'<br/>'
                        +'<br/>'+'Subject of the Email alert :'+'&nbsp;&nbsp;'+ subject
                        +'<br/><br/>'                                            
                        +'<br/>This is a system generated message.<br/></span>';                                
              mail.setHtmlBody(htmlEmailBody);
              mail.saveAsActivity=false;
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
              
              return null;    
    }
    else {
    
    String temp = links[count];
    Integer lastIndex = temp.lastIndexOf('/');
    
    String docName = temp.subString(lastIndex+1, temp.length());
    String temp1 = temp.subString(0,lastIndex - 1);
    Integer lastIndex1 = temp1.lastIndexOf('/');
    String temp2 = temp1.subString(0,lastIndex1 - 1);
    String folderName = temp.subString(lastIndex1+1,lastIndex);
    Integer lastIndex2 = temp2.lastIndexOf('/');
    String finalString = temp.subString(lastIndex2+1,lastIndex1);
    
    String finalString1 = finalString.replace('%20',' ');
    String finalString2 = docName.replace('%20',' ');
    String finalString3 = folderName.replace('%20',' ');
    
    System.debug('++++++'+finalString1);
    System.debug('++++++'+finalString2);
    System.debug('++++++'+finalString3);
    
    String[] clientOppName = new String[]{};
    if(finalString1.contains('--')) {
        clientOppName = finalString1.split('--');
    }
    
    System.debug('++++++'+clientOppName);
    String oppName = '';
    String clientName = '';
    if(!clientOppName.isEmpty()) {
        oppName = clientOppName[1];
        if(oppName.endsWith('%60')) {
            oppName = oppName + ' ';
        }
        clientName = clientOppName[0];
    }
    
    System.debug('++++++'+oppName);
    System.debug('++++++'+clientName);
    
    if(oppName.contains('%60')) {
        oppName = checkSpecChar(oppName);
        oppName = oppName.trim();
    }
    else {
        oppName = oppName.trim();
    }
    
    if(clientName.contains('%60')) {
        clientName = checkSpecChar(clientName);
        clientName = clientName.trim();
    }
    else {
        clientName = clientName.trim();
    }
    
    System.debug('++++++'+oppName);
    System.debug('++++++'+clientName);
    
    String oppClient = clientName + ' -- ' + oppName;
    
    if(myPlainText.contains('has been added') && myPlainText.contains('.') && System.Label.document_folder_name.equalsIgnoreCase(finalString3)) {
        List<Opportunity_TGP__c> opp = new List<Opportunity_TGP__c>();
        //List<Client_Master__c> clientmaster = new List<Client_Master__c>();
        
        opp = [SELECT Id,Name,Client_Name__c,Client_Name__r.Name,Opportunity_Client__c from Opportunity_TGP__c where Opportunity_Client__c =: oppClient];
        //clientmaster = [SELECT Id,Name from Client_Master__c where Name =: clientName];
        System.debug('++++' + opp );
        if(opp.size() == 0 || opp.isEmpty()) {
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c limit 5000];
              OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};                                
              if(lstIdForOWA.size()>0) {
                  owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c limit 5000];
              }
              if (owea.size() > 0 ) {
                  mail.setOrgWideEmailAddressId(owea.get(0).Id);
              } 
              List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name = 'Alert SharePoint Group']; 
              Set<Id> idList = new Set<Id>();
              String[] mailToAddresses  = new String[]{};
              for (GroupMember gm : g[0].groupMembers) {        
                      idList.add(gm.userOrGroupId);
              } 
              User[] usr = [SELECT email FROM user WHERE id IN :idList];    
              for(User u : usr) {        
                  mailToAddresses.add(u.email);    
              }
              mail.setToAddresses(mailToAddresses);
              mail.setSubject('Alert not recorded from Sharepoint');
              String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                        +'The Client Name and/or Opportunity Name for the below opportunity does not match Solution Workbench.'+'<br/>'
                        +'<br/>'+'Folder Name :'+'&nbsp;&nbsp;'+ finalString1
                        +'<br/>'+'Document Name :'+'&nbsp;&nbsp;'+ finalString2
                        +'<br/><br/>'                                            
                        +'<br/>This is a system generated message.<br/></span>';                                
              mail.setHtmlBody(htmlEmailBody);
              mail.saveAsActivity=false;
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });               
        }
        else if(opp.size() > 1) {
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c limit 5000];
              OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};                                
              if(lstIdForOWA.size()>0) {
                  owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c limit 5000];
              }
              if (owea.size() > 0 ) {
                  mail.setOrgWideEmailAddressId(owea.get(0).Id);
              } 
              List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name = 'Alert SharePoint Group']; 
              Set<Id> idList = new Set<Id>();
              String[] mailToAddresses  = new String[]{};
              for (GroupMember gm : g[0].groupMembers) {        
                      idList.add(gm.userOrGroupId);
              } 
              User[] usr = [SELECT email FROM user WHERE id IN :idList];    
              for(User u : usr) {        
                  mailToAddresses.add(u.email);    
              }
              mail.setToAddresses(mailToAddresses);
              mail.setSubject('Alert not recorded from Sharepoint');
              String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                        +'The below Client - Opportunity Name have mutliple records in Solution Workbench.It cannot be processed.Kindly proceed manually.'+'<br/>'
                        +'<br/>'+'Opportunity Name :'+'&nbsp;&nbsp;'+ opp[0].Name
                        +'<br/>'+'Client Name :'+'&nbsp;&nbsp;'+ opp[0].Client_Name__r.Name
                        +'<br/>'+'Client - Opportunity Name :'+'&nbsp;&nbsp;'+ oppClient
                        +'<br/>'+'Document Name :'+'&nbsp;&nbsp;'+ finalString2
                        +'<br/><br/>'                                            
                        +'<br/>This is a system generated message.<br/></span>';                                
              mail.setHtmlBody(htmlEmailBody);
              mail.saveAsActivity=false;
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        }
        else {
            for(Integer i = 0; i < opp.size(); i++) {
                if(opp.size() > 0 /*&& clientmaster.size() > 0 && opp[i].Client_Name__c == clientmaster[0].Id*/ && finalString2 != null){
                    Opportunity_Document__c testDoc = new Opportunity_Document__c();
                    System.debug('++++1');
                        testDoc.ClientOppDocName__c = opp[0].Client_Name__r.Name + opp[0].Name + finalString2;
                        if(finalString2.length() > 80) {
                            System.debug('++++1');
                            testDoc.Name = finalString2.subString(0,80);
                            testDoc.Complete_Document_Name__c = finalString2;
                        }
                        else {
                            System.debug('++++2');
                            testDoc.Name = finalString2;
                            testDoc.Complete_Document_Name__c = finalString2;
                        }
                        testDoc.Document_Link__c = orgLink;
                        testDoc.BPO_Opportunity__c = opp[0].Id;
                        testDoc.Client_Name__c = opp[0].Client_Name__c;
                        testDoc.Modified_Date__c = modified;
                        testDoc.Modified_By__c = modifiedBy;
                    
                   try {
                            insert testDoc;
                        }
                        catch(Exception exp) {
                            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_INSERT, TRIGGER_NAME, 
                                                        System.Logginglevel.ERROR);
                        }
                    }
                }
            }
        }
    else if(myPlainText.contains('has been changed') && System.Label.document_folder_name.equalsIgnoreCase(finalString3)) {
        System.debug('++++2');
        list<Opportunity_Document__c> updateList = [SELECT Id,Name from Opportunity_Document__c
                                                           where BPO_Opportunity__r.Name =: oppName AND Client_Name__r.Name =: clientName AND Name =: finalString2 AND IsDeleted__c =:false];
        if(updateList.size() == 1) {
            updateList[0].Modified_By__c = modifiedBy;
            updateList[0].Modified_Date__c = modified;
            
            update updateList;
        }
        else if(updateList.size() == 0 || updateList.isEmpty()) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c limit 5000];
              OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};                                
              if(lstIdForOWA.size()>0) {
                  owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c limit 5000];
              }
              if (owea.size() > 0 ) {
                  mail.setOrgWideEmailAddressId(owea.get(0).Id);
              } 
              List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name = 'Alert SharePoint Group']; 
              Set<Id> idList = new Set<Id>();
              String[] mailToAddresses  = new String[]{};
              for (GroupMember gm : g[0].groupMembers) {        
                      idList.add(gm.userOrGroupId);
              } 
              User[] usr = [SELECT email FROM user WHERE id IN :idList];    
              for(User u : usr) {        
                  mailToAddresses.add(u.email);    
              }
              mail.setToAddresses(mailToAddresses);
              mail.setSubject('File Name is changed in Sharepoint');
              String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                        +'The File Name for the below document is changed in SharePoint but not updated in SWB. Please update the File Name manually in SWB.'+'<br/>'
                        +'<br/>'+'Client Name :'+'&nbsp;&nbsp;'+ clientName
                        +'<br/>'+'Opportunity Name :'+'&nbsp;&nbsp;'+ oppName
                        +'<br/>'+'URL of File :'+'&nbsp;&nbsp;'+ orgLink
                        +'<br/><br/>'                                            
                        +'<br/>This is a system generated message.<br/></span>';                                
              mail.setHtmlBody(htmlEmailBody);
              mail.saveAsActivity=false;
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
                                                           
        return null;
    }
    else if(myPlainText.contains('has been deleted') && myPlainText.contains('.')) {
       System.debug('++++3');
       
       list<Opportunity_Document__c> deletedList = new list<Opportunity_Document__c>();
       Integer firstIndex = myPlainText.indexOf('>');
       Integer secondIndex = myPlainText.indexOf('.',firstIndex);
       String docName1 = myPlainText.substring(firstIndex+1,secondIndex+5);
       
       String temp5 = '>';
       String temp6 = 'has been deleted';
       
       String myPlainText1 = myPlainText.replaceAll('\n',' ');

       Pattern p = Pattern.compile(Pattern.quote(temp5) + '(.*?)' + Pattern.quote(temp6));
       Matcher m = p.matcher(myPlainText1);
       while (m.find()) {
           System.debug('++++'+m.group(1));
           break;
       }
       
       Integer lastIndex8 = m.group(1).lastIndexOf('>');
       String finalString5 = m.group(1).substring(lastIndex8+1);
       String finalString4 = finalString5.trim();
       //System.debug('++++'+ docName1);
       System.debug('++++'+ finalString4);
       if(finalString4.contains('...')) {
           System.debug('++++contains...');
           finalString4 = finalString4.replace('...','');
           System.debug('++++'+finalString4); 
           deletedList = [SELECT Id,Name from Opportunity_Document__c where Name LIKE: finalString4 + '%' AND IsDeleted__c =: false];
       }
       else {
           System.debug('++++does not contains...');
           deletedList = [SELECT Id,Name from Opportunity_Document__c where Name =: finalString4 AND IsDeleted__c =: false];
       }
       if(deletedList.size() == 1) {
           system.debug('++++4');
           delete deletedList;
       }
       else if(deletedList.size() > 1) {
           system.debug('++++5');
           deletedList[0].IsDeleted__c = true;
           
           update deletedList;
       }
    else if(deletedList.size() == 0 || deletedList.isEmpty()) {
               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                  List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c limit 5000];
                  OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};                                
                  if(lstIdForOWA.size()>0) {
                      owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c limit 5000];
                  }
                  if (owea.size() > 0 ) {
                      mail.setOrgWideEmailAddressId(owea.get(0).Id);
                  } 
                  List<Group> g = [SELECT id,(select userOrGroupId from groupMembers) FROM group WHERE name = 'Alert SharePoint Group']; 
                  Set<Id> idList = new Set<Id>();
                  String[] mailToAddresses  = new String[]{};
                  for (GroupMember gm : g[0].groupMembers) {        
                          idList.add(gm.userOrGroupId);
                  } 
                  User[] usr = [SELECT email FROM user WHERE id IN :idList];    
                  for(User u : usr) {        
                      mailToAddresses.add(u.email);    
                  }
                  mail.setToAddresses(mailToAddresses);
                  mail.setSubject('File to be deleted from SolutionWorkBench');
                  String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                            +'The file name' + finalString4 + 'is removed from the SharePoint but not Solution Workbench.Please delete the file manually from Solution Workbench.'+'<br/>'
                            +'<br/><br/>'                                            
                            +'<br/>This is a system generated message.<br/></span>';                                
                  mail.setHtmlBody(htmlEmailBody);
                  mail.saveAsActivity=false;
                  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
           }
        }
            return null;
        }
    }
    
    public String checkSpecChar(String tempString) {
        if(tempString.contains(' %60%60 ')) {
            tempString = tempString.replace(' %60%60 ','&');
        }
        if(tempString.contains(' %60%60%60 ')) {
            tempString = tempString.replace(' %60%60%60 ','/');
        }
        if(tempString.contains(' %60%60%60%60 ')) {
            tempString = tempString.replace(' %60%60%60%60 ','*');
        }
        if(tempString.contains(' %60%60%60%60%60 ')) {
            tempString = tempString.replace(' %60%60%60%60%60 ',':');
        }
        if(tempString.contains(' %60%60%60%60%60%60 ')) {
            tempString = tempString.replace(' %60%60%60%60%60%60 ','#');
        }
        if(tempString.contains(' %60%60%60%60%60%60%60 ')) {
            tempString = tempString.replace(' %60%60%60%60%60%60%60 ','%');
        }
        if(tempString.contains(' %60%60%60%60%60%60%60%60 ')) {
            tempString = tempString.replace(' %60%60%60%60%60%60%60%60 ','"');
        }
        if(tempString.contains(' %60%60%60%60%60%60%60%60%60 ')) {
            tempString = tempString.replace(' %60%60%60%60%60%60%60%60%60 ','>');
        }
        if(tempString.contains(' %60%60%60%60%60%60%60%60%60%60 ')) {
            tempString = tempString.replace(' %60%60%60%60%60%60%60%60%60%60 ','<');
        }
        if(tempString.contains(' %60%60%60%60%60%60%60%60%60%60%60 ')) {
            tempString = tempString.replace(' %60%60%60%60%60%60%60%60%60%60%60 ','\\');
        }
        if(tempString.contains(' %60%60%60%60%60%60%60%60%60%60%60%60 ')) {
            tempString = tempString.replace(' %60%60%60%60%60%60%60%60%60%60%60%60 ','~');
        }
        if(tempString.contains(' %60%60%60%60%60%60%60%60%60%60%60%60%60 ')) {
            tempString = tempString.replace(' %60%60%60%60%60%60%60%60%60%60%60%60%60 ','?');
        }
        if(tempString.contains(' %60%60%60%60%60%60%60%60%60%60%60%60%60%60 ')) {
            tempString = tempString.replace(' %60%60%60%60%60%60%60%60%60%60%60%60%60%60 ','{');
        }
        if(tempString.contains(' %60%60%60%60%60%60%60%60%60%60%60%60%60%60%60 ')) {
            tempString = tempString.replace(' %60%60%60%60%60%60%60%60%60%60%60%60%60%60%60 ','}');
        }
        if(tempString.contains(' %60%60%60%60%60%60%60%60%60%60%60%60%60%60%60%60 ')) {
            tempString = tempString.replace(' %60%60%60%60%60%60%60%60%60%60%60%60%60%60%60%60 ','|');
        }
        
        return tempString;
    } 
}