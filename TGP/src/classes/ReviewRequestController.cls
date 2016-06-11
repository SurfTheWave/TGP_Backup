/*
@Author :  
@name : ReviewRequestController
@CreateDate :   1/10/2015 1:10 AM
@Description : 
@Version : 
*/
public with sharing class ReviewRequestController {

/*
@Author :  
@name : ReviewRequestController
@CreateDate :   1/10/2015 1:10 AM
@Description :  Mail to reviewer 
@Version : 
*/
    public static void sendMailToReviewer(List<Review_Request__c> rlist){
        try{
        id templateForReviewer = [select id from Emailtemplate where developerName=:UtilConstants.MAIL_INTIMATE_REVIEW Limit 1].id;
        //system.debug('template id-->'+templateForReviewer);
         for(Review_Request__c reviewlist :[Select Reviewer__c,id from Review_Request__c where Id IN : rlist Limit 5000]){
                        String reviewer=UtilUser.UtilUser(reviewlist.Reviewer__c);
                        //System.debug('**********IC Review Request mail***********');
                        String orgWideEmailAddressID=UtilEmail.emailid();
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        mail.setWhatId(reviewlist.id) ;
                        mail.setTargetObjectId(reviewer) ;
                        mail.setTemplateId(templateForReviewer); 
                        mail.saveAsActivity=false;                       
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
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
@name : ReviewRequestController
@CreateDate :  1/10/2015 1:10 AM
@Description : Mail to approver once review is done 
@Version : 
*/
    public static void sendMailToApprover(List<Review_Request__c> rlist){
        try{
        id templateForReviewCompleted = [select id from Emailtemplate where developerName=: UtilConstants.REVIEW_COMPLETE Limit 1].id;
         for(Review_Request__c reviewlist : [select id,Approval_Request__r.Approver__c,Review_Completed__c 
             from review_request__c where id IN:rlist Limit 5000]){
                        if(reviewlist.Review_Completed__c==true){
                        //system.debug('User master id:::::::::::::'+reviewlist.Approval_Request__r.Approver__c);
                        String approver=UtilUser.UtilUser(reviewlist.Approval_Request__r.Approver__c);
                        String orgWideEmailAddressID=UtilEmail.emailid();
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        mail.setWhatId(reviewlist.id) ;
                        mail.setTargetObjectId(approver) ;
                        mail.setTemplateId(templateForReviewCompleted); 
                        mail.saveAsActivity=false;                       
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }}
        }Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString();
          throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);﻿
        }
 }
 

}