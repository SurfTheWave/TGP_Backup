/*
@Author : Apoorva Sharma
@name : SharePointInboundEmail
@CreateDate :   1/5/2015 9:15 AM
@Description :  * Email services are automated processes that use Apex classes
                * to process the contents, headers, and attachments of inbound
                * email.
@Version : 
*/
global with sharing class SharePointInboundEmailNew implements Messaging.InboundEmailHandler {

    /*
@Author :  
@name : SharePointInboundEmail
@CreateDate :   1/5/2015 9:15 AM
@Description :  * Email services are automated processes that use Apex classes
                * to process the contents, headers, and attachments of inbound
                * email.
@Version : 
*/
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String orgLink = UtilConstants.EMPTY_STRING;
        String myPlainText = UtilConstants.EMPTY_STRING;
        String subject = UtilConstants.EMPTY_STRING;
        subject = email.subject;

        myPlainText = email.plainTextBody;
        System.debug('Plain text+++++++++++' + myPlainText );

        List < String > links = new List < String > ();

        String[] split = myPlainText.split(UtilConstants.LAST_MOD);
        System.debug('++++++'+split);
        String secondString = split[1].trim();

        String[] split1 = secondString.split(UtilConstants.BY_STRING);
        System.debug('++++++'+split1);
        String modifedDate = split1[0].trim();
        String thirdString = split1[1].trim();

        Integer split2 = thirdString.indexOf(UtilConstants.NEWLINE);

        String modifiedBy = thirdString.substring(0, split2 + 1);

        DateTime modified = DateTime.parse(modifedDate);

        //System.debug('++++++datetime'+modifedDate);
        //System.debug('++++++by'+modifiedBy);
        //System.debug('++++++date'+modified);
        //System.debug('++++++'+date4);

        Pattern myPattern = Pattern.compile(UtilConstants.REG_PATTERN);
        Matcher myMatch = myPattern.matcher(myPlainText);

        // loops till we reach the end of our group matches
        while (myMatch.find()) {
            // pass our match to a string to manipulate
            String matchingPattern = myMatch.group(1);
            links.add(matchingPattern);
        }

        Integer count = 0;
        //Integer count1 = 0;
        for (integer i = 0; i < links.size(); i++) {
            System.debug('links+++++     ['+i+']   '+links[i] );
            if (links[i].contains(UtilConstants.CUSTOM_SPACE)) {
                links[i] = links[i].replace(UtilConstants.CUSTOM_SPACE, UtilConstants.BLANK_SPACE);
            } else if (links[i].contains(UtilConstants.SINGLE_SPACE)) {
                links[i] = links[i].replace(UtilConstants.SINGLE_SPACE, UtilConstants.BLANK_SPACE);
            } else {}

            System.debug('links+++++     ['+i+']   '+links[i] );

            if (links[i].contains(UtilConstants.REQ_DOC) || links[i].contains(System.Label.X1_Tech_Documents)) {
                count = i;
                orgLink = links[i].replaceAll(UtilConstants.BLANK_SPACE, UtilConstants.SINGLE_SPACE);
                system.debug('orgLink '+orgLink );
            }
        }

        if (myPlainText.contains(UtilConstants.MSG_ADD) && !((myPlainText.contains(System.Label.Opportunity_Documents)) || 
            (myPlainText.contains(UtilConstants.VE2EWorkbench)))) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            List < Group > g = [SELECT id, (select userOrGroupId from groupMembers) FROM group WHERE name = : UtilConstants.OP_GROUP Limit 5000];
            Set < Id > idList = new Set < Id > ();
            String[] mailToAddresses = new String[] {};
            for (GroupMember gm: g[0].groupMembers) {
                idList.add(gm.userOrGroupId);
            }

            for (User u: [SELECT email FROM user WHERE id IN: idList Limit 5000]) {
                mailToAddresses.add(u.email);
            }
            String orgWideEmailAddressID = UtilEmail.emailid();
            mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
            if (Test.isRunningTest() && !(mailToAddresses.size() > 0)) {
                mailToAddresses.add(UtilConstants.USR_MAIL);
            }
            mail.setToAddresses(mailToAddresses);
            mail.setSubject(subject);
            String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                        +'The following alert was not captured by SWB. Kindly handle the alert manually.'+'<br/>'
                        +'<br/>'+'Subject of the Email alert :'+'&nbsp;&nbsp;'+ subject
                        +'<br/><br/>'                                            
                        +'<br/>This is a system generated message. Please do not reply to this message.<br/></span>';
            mail.setHtmlBody(htmlEmailBody);
            mail.saveAsActivity = false;
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                mail
            });

            return null;
        } else {

            /* added and changed*/
            if (myPlainText.contains(UtilConstants.MSG_ADD) || myPlainText.contains(UtilConstants.MESSAGE_CHANGED)) {
                String temp = links[count];
                Integer lastIndex = temp.lastIndexOf(UtilConstants.SLASH_OPRTR);

                String docName = temp.subString(lastIndex + 1, temp.length());
                String temp1 = temp.subString(0, lastIndex - 1);
                Integer lastIndex1 = temp1.lastIndexOf(UtilConstants.SLASH);
                String temp2 = temp1.subString(0, lastIndex1 - 1);
                String folderName = temp.subString(lastIndex1 + 2, lastIndex);
                Integer lastIndex2 = temp2.lastIndexOf(UtilConstants.SLASH_OPRTR);
                String finalString = temp.subString(lastIndex2 + 1, lastIndex1);

                String finalString1 = finalString.replace(UtilConstants.SINGLE_SPACE, UtilConstants.SPACE_EMPTY);
                String finalString2 = docName.replace(UtilConstants.SINGLE_SPACE, UtilConstants.SPACE_EMPTY);
                String finalString3 = folderName.replace(UtilConstants.SINGLE_SPACE, UtilConstants.SPACE_EMPTY);
                //system.debug('folder namesbdcvjshd   '+folderName+'----------'+lastIndex1);

                //System.debug('++finalString1++++'+finalString1);
                //System.debug('+++finalString2+++'+finalString2);
                //System.debug('+++finalString3+++'+finalString3);

                String[] clientOppName = new String[] {};
                if (finalString1.contains(UtilConstants.Double_Dash)) {
                    clientOppName = finalString1.split(UtilConstants.Double_Dash);
                }

                //System.debug('++++++clientOppName'+clientOppName);
                String oppName = UtilConstants.EMPTY_STRING;
                String clientName = UtilConstants.EMPTY_STRING;
                if (!clientOppName.isEmpty()) {
                    oppName = clientOppName[1];
                    if (oppName.endsWith(UtilConstants.ONE_SPACE)) {
                        oppName = oppName + UtilConstants.SPACE_EMPTY;
                        //system.debug('opp name'+oppName);
                    }
                    clientName = clientOppName[0];
                }

                //System.debug('++++++oppName1'+oppName);
                //System.debug('++++++oppName1'+clientName);

                if (oppName.contains(UtilConstants.ONE_SPACE)) {
                    oppName = checkSpecChar(oppName);
                    oppName = oppName.trim();
                    //system.debug('opp name'+oppName);
                } else {
                    oppName = oppName.trim();
                    //system.debug('opp name'+oppName);
                }

                if (clientName.contains(UtilConstants.ONE_SPACE)) {
                    clientName = checkSpecChar(clientName);
                    clientName = clientName.trim();
                } else {
                    clientName = clientName.trim();
                }

                //System.debug('++++++oppName2'+oppName);
                //System.debug('++++++oppName2'+clientName);

                String oppClient = clientName +UtilConstants.BLANK_SPACE + UtilConstants.Double_Dash + UtilConstants.BLANK_SPACE + oppName;
                system.debug('finalString3 for tech documents section----------------------------->'+finalString3);

                if (myPlainText.contains(UtilConstants.MSG_ADD) && finalString3.equalsIgnoreCase(UtilConstants.REQ_DOC)) {
                    List < Opportunity > opp = new List < Opportunity > ();
                    //system.debug('in has been added');

                    opp = [SELECT Id, Service_Grp__c,Name, Accountid, SP_Folder_Name__c,Active__c from Opportunity where SP_Folder_Name__c = : oppClient and Active__c=true Limit 5000];
                    //System.debug('++++' + opp );
                    if (opp.size() == 0 || opp.isEmpty()) {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                        List < Group > g = [SELECT id, (select userOrGroupId from groupMembers) FROM group WHERE name = : UtilConstants.OP_GROUP Limit 5000];
                        Set < Id > idList = new Set < Id > ();
                        String[] mailToAddresses = new String[] {};
                        for (GroupMember gm: g[0].groupMembers) {
                            idList.add(gm.userOrGroupId);
                        }

                        for (User u: [SELECT email FROM user WHERE id IN: idList Limit 5000]) {
                            mailToAddresses.add(u.email);
                        }
                        String orgWideEmailAddressID = UtilEmail.emailid();
                        String Subjectmsg = UtilConstants.UnProcessedMessage2;
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        if (Test.isRunningTest() && !(mailToAddresses.size() > 0)) {
                            mailToAddresses.add(UtilConstants.USR_MAIL);
                        }
                        mail.setToAddresses(mailToAddresses);
                        mail.setSubject(Subjectmsg);
                        String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                            +'A new alert mail was received from SharePoint just now but system was not able to process it. Please take the necessary action from your end.'+'<br/>'
                            +'<br/>'+'Subject of Email Recieved :'+'&nbsp;&nbsp;'+ subject
                            +'<br/>'+'Folder Name :'+'&nbsp;&nbsp;'+ oppClient
                            +'<br/>'+'Document Name :'+'&nbsp;&nbsp;'+ finalString2
                            +'<br/><br/>'                                           
                            +'<br/>This is a system generated message. Please do not reply to this message<br/></span>';
                        mail.setHtmlBody(htmlEmailBody);
                        mail.saveAsActivity = false;

                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                            mail
                        });

                    } else if (opp.size() > 1) {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        List < Group > g = [SELECT id, (select userOrGroupId from groupMembers ) FROM group WHERE name = : UtilConstants.OP_GROUP Limit 5000];
                        Set < Id > idList = new Set < Id > ();
                        String[] mailToAddresses = new String[] {};
                        for (GroupMember gm: g[0].groupMembers) {
                            idList.add(gm.userOrGroupId);
                        }

                        for (User u: [SELECT email FROM user WHERE id IN: idList Limit 5000]) {
                            mailToAddresses.add(u.email);
                        }
                        String orgWideEmailAddressID = UtilEmail.emailid();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        if (Test.isRunningTest() && !(mailToAddresses.size() > 0)) {
                            mailToAddresses.add(UtilConstants.USR_MAIL);
                        }
                        mail.setToAddresses(mailToAddresses);
                        mail.setSubject(UtilConstants.UnProcessedMessage2);
                        String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                                +'A new alert mail was received from SharePoint just now but system was not able to process it. Please take the necessary action from your end.'+'<br/>'
                                +'<br/>'+'Subject of Email Recieved :'+'&nbsp;&nbsp;'+ subject
                                +'<br/>'+'Folder Name :'+'&nbsp;&nbsp;'+ oppClient
                                +'<br/>'+'Document Name :'+'&nbsp;&nbsp;'+ finalString2
                                +'<br/><br/>'                                           
                                +'<br/>This is a system generated message. Please do not reply to this message<br/></span>';
                        mail.setHtmlBody(htmlEmailBody);
                        mail.saveAsActivity = false;

                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                            mail
                        });
                    } else {
                        opportunity_documents__c testDoc;
                        for (Integer i = 0; i < opp.size(); i++) {
                            if (opp.size() > 0 && finalString2 != null) {
                                testDoc = new opportunity_documents__c();
                                //System.debug('++++1');
                                //testDoc.ClientOppDocName__c = opp[0].Client_Name__r.Name + opp[0].Name + finalString2;
                                if (finalString2.length() > 80) {
                                    //System.debug('++++1');
                                    // testDoc.Name = finalString2.subString(0,80);
                                    testDoc.document__c = finalString2;
                                } else {
                                    //System.debug('++++2');
                                    // testDoc.Name = finalString2;
                                    testDoc.document__c = finalString2;
                                }
                                testDoc.Document_Link__c ='<a href="'+orgLink+'">'+finalString2+'</a>';
                                //testDoc.link__c = orgLink;
                                testDoc.opportunity__c = opp[0].Id;
                                testDoc.Client__c = opp[0].Accountid;
                                testDoc.modified_date__c = date.newinstance(modified.year(), modified.month(), modified.day());
                                testDoc.modified_by__c = modifiedBy;
                                testDoc.Service_Group__c = opp[0].Service_Grp__c;

                                try {
                                    insert testDoc;
                                } catch (Exception e) {
                                    String ErrorMsg = e.getMessage() + e.getStackTraceString();
                                    throw (e);
                                    // UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_INSERT, TRIGGER_NAME, 
                                    // System.Logginglevel.ERROR);
                                }
                            }
                        }
                    }
                    return null;
                }
                else if(myPlainText.contains(UtilConstants.MSG_ADD) && finalString3.equalsIgnoreCase(System.Label.X1_Tech_Documents)){
                    List<Opportunity> opp = [SELECT Id, Service_Grp__c,Name, Accountid, SP_Folder_Name__c,Active__c from Opportunity where SP_Folder_Name__c = : oppClient and Active__c=true Limit 5000];
                    if (opp.size() == 0 || opp.isEmpty() || opp.size()>1) {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                        List < Group > g = [SELECT id, (select userOrGroupId from groupMembers) FROM group WHERE name = : UtilConstants.OP_GROUP Limit 5000];
                        Set < Id > idList = new Set < Id > ();
                        String[] mailToAddresses = new String[] {};
                        for (GroupMember gm: g[0].groupMembers) {
                            idList.add(gm.userOrGroupId);
                        }

                        for (User u: [SELECT email FROM user WHERE id IN: idList Limit 5000]) {
                            mailToAddresses.add(u.email);
                        }
                        String orgWideEmailAddressID = UtilEmail.emailid();
                        String Subjectmsg = UtilConstants.UnProcessedMessage2;
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        if (Test.isRunningTest() && !(mailToAddresses.size() > 0)) {
                            mailToAddresses.add(UtilConstants.USR_MAIL);
                        }
                        mail.setToAddresses(mailToAddresses);
                        mail.setSubject(Subjectmsg);
                        String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                            +'A new alert mail was received from SharePoint just now but system was not able to process it. Please take the necessary action from your end.'+'<br/>'
                            +'<br/>'+'Subject of Email Recieved :'+'&nbsp;&nbsp;'+ subject
                            +'<br/>'+'Folder Name :'+'&nbsp;&nbsp;'+ oppClient
                            +'<br/>'+'Document Name :'+'&nbsp;&nbsp;'+ finalString2
                            +'<br/><br/>'                                           
                            +'<br/>This is a system generated message. Please do not reply to this message<br/></span>';
                        mail.setHtmlBody(htmlEmailBody);
                        mail.saveAsActivity = false;

                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                            mail
                        });
                    }
                    else{
                        opportunity_documents__c testDoc;
                        for (Integer i = 0; i < opp.size(); i++) {
                            if (opp.size() > 0 && finalString2 != null) {
                                testDoc = new opportunity_documents__c();
                                //System.debug('++++1');
                                //testDoc.ClientOppDocName__c = opp[0].Client_Name__r.Name + opp[0].Name + finalString2;
                                if (finalString2.length() > 80) {
                                    //System.debug('++++1');
                                    // testDoc.Name = finalString2.subString(0,80);
                                    testDoc.document__c = finalString2;
                                } else {
                                    //System.debug('++++2');
                                    // testDoc.Name = finalString2;
                                    testDoc.document__c = finalString2;
                                }
                                testDoc.Document_Link__c ='<a href="'+orgLink+'">'+finalString2+'</a>';
                                //testDoc.link__c = orgLink;
                                testDoc.opportunity__c = opp[0].Id;
                                testDoc.Client__c = opp[0].Accountid;
                                testDoc.modified_date__c = date.newinstance(modified.year(), modified.month(), modified.day());
                                testDoc.modified_by__c = modifiedBy;
                                testDoc.Service_Group__c = opp[0].Service_Grp__c;
                                testDoc.IS_Tech_Document__c=true;

                                try {
                                    insert testDoc;
                                } catch (Exception e) {
                                    String ErrorMsg = e.getMessage() + e.getStackTraceString();
                                    throw (e);
                                    // UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_INSERT, TRIGGER_NAME, 
                                    // System.Logginglevel.ERROR);
                                }
                            }
                        }
                    }
                    return null;
                }
                else if (myPlainText.contains(UtilConstants.MESSAGE_CHANGED) && finalString3.equalsIgnoreCase(UtilConstants.REQ_DOC)) {
                    //System.debug('++++2');
                    list < opportunity_documents__c > updateList = [SELECT Id, Name, document__c,Active__c from opportunity_documents__c
                    where document__c = : finalString2 AND opportunity__r.Name = : oppName AND Client__r.Name = : clientName and Active__c=true Limit 5000];
                    if (updateList.size() == 1) {
                        updateList[0].modified_by__c = modifiedBy;
                        updateList[0].modified_date__c = date.newinstance(modified.year(), modified.month(), modified.day());

                        update updateList;
                    } else if (updateList.size() == 0 || updateList.isEmpty()) {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        List < Group > g = [SELECT id, (select userOrGroupId from groupMembers) FROM group WHERE name = : UtilConstants.OP_GROUP Limit 5000];
                        Set < Id > idList = new Set < Id > ();
                        String[] mailToAddresses = new String[] {};
                        for (GroupMember gm: g[0].groupMembers) {
                            idList.add(gm.userOrGroupId);
                        }

                        for (User u: [SELECT email FROM user WHERE id IN: idList Limit 5000]) {
                            mailToAddresses.add(u.email);
                        }
                        String orgWideEmailAddressID = UtilEmail.emailid();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        if (Test.isRunningTest() && !(mailToAddresses.size() > 0)) {
                            mailToAddresses.add(UtilConstants.USR_MAIL);
                        }
                        mail.setToAddresses(mailToAddresses);
                        mail.setSubject(UtilConstants.UnProcessedMessage2);
                        String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                                +'A new alert mail was received from SharePoint just now but system was not able to process it. Please take the necessary action from your end.'+'<br/>'
                                +'<br/>'+'Subject of Email Recieved :'+'&nbsp;&nbsp;'+ subject
                                +'<br/>'+'Folder Name :'+'&nbsp;&nbsp;'+ oppClient
                                +'<br/>'+'Document Name :'+'&nbsp;&nbsp;'+ finalString2
                                +'<br/><br/>'                                           
                                +'<br/>This is a system generated message.Please do not reply to this message.<br/></span>'; 
                        mail.setHtmlBody(htmlEmailBody);
                        mail.saveAsActivity = false;

                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                            mail
                        });
                    } else {}
                }
                else if (myPlainText.contains(UtilConstants.MESSAGE_CHANGED) && finalString3.equalsIgnoreCase(System.Label.X1_Tech_Documents)) {
                    list < opportunity_documents__c > updateList = [SELECT Id, Name, document__c,Active__c from opportunity_documents__c
                    where document__c = : finalString2 AND opportunity__r.Name = : oppName AND Client__r.Name = : clientName and Active__c=true Limit 5000];
                    if (updateList.size() == 1) {
                        updateList[0].modified_by__c = modifiedBy;
                        updateList[0].modified_date__c = date.newinstance(modified.year(), modified.month(), modified.day());

                        update updateList;
                    } else if (updateList.size() == 0 || updateList.isEmpty()) {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        List < Group > g = [SELECT id, (select userOrGroupId from groupMembers) FROM group WHERE name = : UtilConstants.OP_GROUP Limit 5000];
                        Set < Id > idList = new Set < Id > ();
                        String[] mailToAddresses = new String[] {};
                        for (GroupMember gm: g[0].groupMembers) {
                            idList.add(gm.userOrGroupId);
                        }

                        for (User u: [SELECT email FROM user WHERE id IN: idList Limit 5000]) {
                            mailToAddresses.add(u.email);
                        }
                        String orgWideEmailAddressID = UtilEmail.emailid();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        if (Test.isRunningTest() && !(mailToAddresses.size() > 0)) {
                            mailToAddresses.add(UtilConstants.USR_MAIL);
                        }
                        mail.setToAddresses(mailToAddresses);
                        mail.setSubject(UtilConstants.UnProcessedMessage2);
                        String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                                +'A new alert mail was received from SharePoint just now but system was not able to process it. Please take the necessary action from your end.'+'<br/>'
                                +'<br/>'+'Subject of Email Recieved :'+'&nbsp;&nbsp;'+ subject
                                +'<br/>'+'Folder Name :'+'&nbsp;&nbsp;'+ oppClient
                                +'<br/>'+'Document Name :'+'&nbsp;&nbsp;'+ finalString2
                                +'<br/><br/>'                                           
                                +'<br/>This is a system generated message.Please do not reply to this message.<br/></span>'; 
                        mail.setHtmlBody(htmlEmailBody);
                        mail.saveAsActivity = false;

                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                            mail
                        });
                    } else {}
                    
                }
            }
            if (myPlainText.contains(UtilConstants.MESSAGE)) {

                list < opportunity_documents__c > deletedList = new list < opportunity_documents__c > ();
                Integer firstIndex = myPlainText.indexOf(UtilConstants.GREATER_SYM);
                Integer secondIndex = myPlainText.indexOf(UtilConstants.FULL_STOP, firstIndex);
                String docName1 = myPlainText.substring(firstIndex + 1, secondIndex + 5);

                String temp5 = UtilConstants.GREATER_SYM;
                String temp6 = UtilConstants.MESSAGE;

                String myPlainText1 = myPlainText.replaceAll(UtilConstants.NEWLINE, UtilConstants.BLANK_SPACE);

                Pattern p = Pattern.compile(Pattern.quote(temp5) + UtilConstants.PATTERN_STR + Pattern.quote(temp6));
                Matcher m = p.matcher(myPlainText1);
                while (m.find()) {
                    //System.debug('++++'+m.group(1));
                    break;
                }

                Integer lastIndex8 = m.group(1).lastIndexOf(UtilConstants.GREATER_SYM);
                String finalString5 = m.group(1).substring(lastIndex8 + 1);
                String finalString4 = finalString5.trim();
                //System.debug('++++'+ docName1);
                //System.debug('++++'+ finalString4);
                if (finalString4.contains(UtilConstants.ELLIPSIS)) {
                    //System.debug('++++contains...');
                    finalString4 = finalString4.replace(UtilConstants.ELLIPSIS, UtilConstants.EMPTY_STRING);
                    //System.debug('++++finalString4finalString4'+finalString4); 
                    deletedList = [SELECT Id, Name, document__c from opportunity_documents__c where document__c LIKE: finalString4 Limit 5000];
                } else {
                    //System.debug('++++does not contains...');
                    deletedList = [SELECT Id, Name from opportunity_documents__c where document__c = : finalString4 Limit 5000];
                }
                if (deletedList.size() == 1) {
                    //system.debug('++++4');
                    delete deletedList;
                } else if (deletedList.size() > 1) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List < Group > g = [SELECT id, (select userOrGroupId from groupMembers) FROM group WHERE name = : UtilConstants.OP_GROUP Limit 5000];
                    Set < Id > idList = new Set < Id > ();
                    String[] mailToAddresses = new String[] {};
                    for (GroupMember gm: g[0].groupMembers) {
                        idList.add(gm.userOrGroupId);
                    }

                    for (User u: [SELECT email FROM user WHERE id IN: idList Limit 5000]) {
                        mailToAddresses.add(u.email);
                    }
                    String orgWideEmailAddressID = UtilEmail.emailid();
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                    if (Test.isRunningTest() && !(mailToAddresses.size() > 0)) {
                        mailToAddresses.add(UtilConstants.USR_MAIL);
                    }
                    mail.setToAddresses(mailToAddresses);
                    mail.setSubject(UtilConstants.UnProcessedMessage);
                    String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                        +'A new alert mail was received from SharePoint for document deletion just now but system was not able to process it. Please take the necessary action from your end.'+'<br/>'
                        +'<br/>'+'Subject of Email Recieved :'+'&nbsp;&nbsp;'+ subject
                        +'<br/>'+'Document Name :'+'&nbsp;&nbsp;'+finalString4
                        +'<br/><br/>'                                           
                        +'<br/>This is a system generated message.Please do not reply to this message.<br/></span>';                                
                    mail.setHtmlBody(htmlEmailBody);
                    mail.saveAsActivity = false;

                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                        mail
                    });
                } else if (deletedList.size() == 0 || deletedList.isEmpty()) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List < Group > g = [SELECT id, (select userOrGroupId from groupMembers) FROM group WHERE name = : UtilConstants.OP_GROUP Limit 5000];
                    Set < Id > idList = new Set < Id > ();
                    String[] mailToAddresses = new String[] {};
                    for (GroupMember gm: g[0].groupMembers) {
                        idList.add(gm.userOrGroupId);
                    }

                    for (User u: [SELECT email FROM user WHERE id IN: idList Limit 5000]) {
                        mailToAddresses.add(u.email);
                    }
                    String orgWideEmailAddressID = UtilEmail.emailid();
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                    if (Test.isRunningTest() && !(mailToAddresses.size() > 0)) {
                        mailToAddresses.add(UtilConstants.USR_MAIL);
                    }
                    mail.setToAddresses(mailToAddresses);
                    mail.setSubject(UtilConstants.UnProcessedMessage);
                    String htmlEmailBody  ='<span style="font-size:11pt; font-family:Calibri">'
                        +'A new alert mail was received from SharePoint for document deletion just now but system was not able to process it. Please take the necessary action from your end.'+'<br/>'
                        +'<br/>'+'Subject of Email Recieved :'+'&nbsp;&nbsp;'+ subject
                        +'<br/>'+'Document Name :'+'&nbsp;&nbsp;'+finalString4
                        +'<br/><br/>'                                           
                        +'<br/>This is a system generated message.Please do not reply to this message.<br/></span>';                                
                    mail.setHtmlBody(htmlEmailBody);
                    mail.saveAsActivity = false;
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                        mail
                    });
                } else {}



                return null;
            }
        }

        return null;
    }

    /*
@Author :  
@name : SharePointInboundEmail
@CreateDate :   1/5/2015 9:15 AM
@Description :  * Email services are automated processes that use Apex classes
                * to process the contents, headers, and attachments of inbound
                * email.
@Version : 
*/
    public String checkSpecChar(String tempString) {
        try {
            if (tempString.contains(UtilConstants.SPACING_TAG_2)) {
                tempString = tempString.replace(UtilConstants.SPACING_TAG_2, UtilConstants.AMPERSAN);
            }
            if (tempString.contains(UtilConstants.SPACING_TAG_3)) {
                tempString = tempString.replace(UtilConstants.SPACING_TAG_3, UtilConstants.SLASH_OPRTR);
            }
            if (tempString.contains(UtilConstants.SPACING_TAG_4)) {
                tempString = tempString.replace(UtilConstants.SPACING_TAG_4, UtilConstants.ASTERISK_OPRTR);
            }
            if (tempString.contains(UtilConstants.SPACING_TAG_5)) {
                tempString = tempString.replace(UtilConstants.SPACING_TAG_5, UtilConstants.COLON_OPRTR);
            }
            if (tempString.contains(UtilConstants.SPACING_TAG_6)) {
                tempString = tempString.replace(UtilConstants.SPACING_TAG_6, UtilConstants.HASH_OPRTR);
            }
            if (tempString.contains(UtilConstants.SPACING_TAG_7)) {
                tempString = tempString.replace(UtilConstants.SPACING_TAG_7, UtilConstants.AMPERSAND_OPRTR);
            }
            if (tempString.contains(UtilConstants.SPACING_TAG_8)) {
                tempString = tempString.replace(UtilConstants.SPACING_TAG_8, UtilConstants.QUOTES_OPRTR);
            }
            if (tempString.contains(UtilConstants.SPACING_TAG_9)) {
                tempString = tempString.replace(UtilConstants.SPACING_TAG_9, UtilConstants.GREATER_SYM);
            }
            if (tempString.contains(UtilConstants.SPACING_TAG_10)) {
                tempString = tempString.replace(UtilConstants.SPACING_TAG_10, UtilConstants.LESS_OPRTR);
            }
            if (tempString.contains(UtilConstants.SPACING_TAG_11)) {
                tempString = tempString.replace(UtilConstants.SPACING_TAG_11, UtilConstants.DOUBLESLASH_OPRTR);
            }
            if (tempString.contains(UtilConstants.SPACING_TAG_12)) {
                tempString = tempString.replace(UtilConstants.SPACING_TAG_12, UtilConstants.TILDE_OPRTR);
            }
            if (tempString.contains(UtilConstants.SPACING_TAG_13)) {
                tempString = tempString.replace(UtilConstants.SPACING_TAG_13, UtilConstants.QUESTION_OPRTR);
            }
            if (tempString.contains(UtilConstants.SPACING_TAG_14)) {
                tempString = tempString.replace(UtilConstants.SPACING_TAG_14, UtilConstants.OPEN_OPRTR);
            }
            if (tempString.contains(UtilConstants.SPACING_TAG_15)) {
                tempString = tempString.replace(UtilConstants.SPACING_TAG_15, UtilConstants.CLOSE_OPRTR);
            }
            if (tempString.contains(UtilConstants.SPACING_TAG_16)) {
                tempString = tempString.replace(UtilConstants.SPACING_TAG_16, UtilConstants.VTBAR_OPRTR);
            }

            return tempString;
        } Catch(DMLException e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);﻿
        }
    }
}