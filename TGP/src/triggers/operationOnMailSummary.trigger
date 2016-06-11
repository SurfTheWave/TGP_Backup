/**
 * Name : operationOnMailSummary
 * Author : NovaCop Generator on Mail_Summary__c
 * Description : operationOnMailSummary used to initiate MailSummaryController
 * Date : 3/20/15 5:35 PM 
 * Version : <intial Draft> 
 */
trigger operationOnMailSummary on Mail_Summary__c (after insert){
    if(trigger.isAfter)
    if(trigger.isInsert){
        MailSummaryController mail=new MailSummaryController();
        mail.sendMail(trigger.new);
    }
}