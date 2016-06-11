@IsTest

public class FeedBackEmailHandler_Test {
    Static  Client_visit_request__c req1;
    
    public static void setupdata(){
    
    Account acc=new Account(name='AccTest');
    insert acc;
        Email_Template__c emailTemplateRec = new Email_Template__c(name =UtilConstantsforSWB.CLIENT_VISIT_TEMPLATE,ID__c='00XE0000001CHQj');     
       insert emailTemplateRec;

       Email_Template__c emailTemplateRec2 = new Email_Template__c(name =UtilConstantsforSWB.CLIENT_VISIT_FEEDBACK_TEMPLATE,ID__c='00XE0000001CHQk');     
       insert emailTemplateRec2;
        
      Email_Template__c emailTemplateRec3 = new Email_Template__c(name =UtilConstantsforSWB.CLIENT_VISIT_FEEDBACK_UPDATE_TEMPLATE,ID__c='00XE0000001CHQl');          
      insert emailTemplateRec3;
     
    
    req1=new Client_visit_request__c();
    req1.Parent_Company__c=acc.id;
    req1.Support_Group__c='Pittsburgh';
    req1.Primary_Contact__c='Reena Thakre';
    req1.Visit_Category__c='Sales - Charge-back DC';
    req1.Feedback_Receipients__c='Reena Thakre';
    req1.WBS_Element_for_Showcase__c='123456';
    req1.Centre_to_be_visited__c='Bangalore';
    req1.Visit_Date_From__c=system.today();
    req1.Visit_Date_To__c=system.today();
    insert req1;
    
            }
    
    static testMethod void inboundEmailTest() {  
    setupdata();
    Messaging.InboundEmail email = new Messaging.InboundEmail();  

    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope(); 
    String name=[select name from Client_visit_request__c where id= :req1.id limit 1].name;
    email.subject=name;
    system.debug('>>>>>>>>>>>>>>>>>>>>>>>name'+email.subject);
    env.fromAddress='reena.thakre@accenture.com';
    String htmlTextB ='';
    htmlTextB =htmlTextB +'<html>\n';
htmlTextB =htmlTextB +'<body>\n';
htmlTextB =htmlTextB +'<p><font size="2" face="Verdana">Request a Client Visit Feedback Form</font></p>\n';
htmlTextB =htmlTextB +'<table border="1" width="80%">\n';
htmlTextB =htmlTextB +'<tbody>\n';
htmlTextB =htmlTextB +'<tr>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">SWB Request ID</font></td>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">A-000089</font></td>\n';
htmlTextB =htmlTextB +'</tr>\n';
htmlTextB =htmlTextB +'<tr>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">SWB Opportunity ID</font></td>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">302070</font></td>\n';
htmlTextB =htmlTextB +'</tr>\n';
htmlTextB =htmlTextB +'<tr>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">Did the visit meet your expectations?</font></td>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">yes</font></td>\n';
htmlTextB =htmlTextB +'</tr>\n';
htmlTextB =htmlTextB +'<tr>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">Did the visit meet your expectations of what you</font></td>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">wanted to communicate to the client/ have the client see?</font></td>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">yes</font></td>\n';
htmlTextB =htmlTextB +'</tr>\n';
htmlTextB =htmlTextB +'<tr>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">Did the visit contribute to our ability to win the deal?</font></td>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">yes</font></td>\n';
htmlTextB =htmlTextB +'</tr>\n';
htmlTextB =htmlTextB +'<tr>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">Did the floor walk go to the appropriate level of detail?</font></td>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">yes</font></td>\n';
htmlTextB =htmlTextB +'</tr>\n';
htmlTextB =htmlTextB +'<tr>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">Were the right experts available at the delivery location?</font></td>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">yes</font></td>\n';
htmlTextB =htmlTextB +'</tr>\n';
htmlTextB =htmlTextB +'<tr>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">What went especially well on this visit?</font></td>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">yes</font></td>\n';
htmlTextB =htmlTextB +'</tr>\n';
htmlTextB =htmlTextB +'<tr>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">What did not go as planned on this visit?</font></td>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">yes</font></td>\n';
htmlTextB =htmlTextB +'</tr>\n';
htmlTextB =htmlTextB +'<tr>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">How can we improve the Client visit process/tools/etc.?</font></td>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">yes</font></td>\n';
htmlTextB =htmlTextB +'</tr>\n';
htmlTextB =htmlTextB +'<tr>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">On a scale of 1 to 5 please indicate the overall level </font></td>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">of satisfaction with the Client visit</font></td>\n';
htmlTextB =htmlTextB +'<td><font size="2" face="Verdana">5 = Very Satisfied</font></td>\n';
htmlTextB =htmlTextB +'</tr>\n';
htmlTextB =htmlTextB +'</tbody>\n';
htmlTextB =htmlTextB +'</table>\n';
htmlTextB =htmlTextB +'</body>\n';
htmlTextB =htmlTextB +'</html>\n';
    
    email.htmlbody=htmlTextB;
system.debug('>>>>>>>>>>>>>>>>plaintxtbdy'+email.htmlbody);
    FeedBackEmailHandler fb=new FeedBackEmailHandler();
    
   Test.startTest();  
   Messaging.InboundEmailResult result = fb.handleInboundEmail(email, env);  
   Test.stopTest();  

   
   }
}