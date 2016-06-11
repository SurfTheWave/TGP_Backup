/**
   @Author         : Shashank Shastri
   @name           : sendEmailReminderOnTaskOverDue
   @Version        : 1.0
  */
public class sendEmailReminderOnTaskOverDue{
    
   /**
   *  @Description : Constructor defined
   *  @name : SendEmailReminderOnTaskOverDue
   */   
    /*public sendEmailReminderOnTaskOverDue(){
    
    }*/
  
  /**
   *  @Description : This method is used to Send reminder mail.
   *  @name : SendEmailReminderOnTaskOverDue
   *  @param : Map<id,List<Opportunity_Teams__c>> MapTeamTask
   *  @return parameter - void
   */   
  public static void SendEmailReminderOnTaskOverDue(Map<id,List<Opportunity_Teams__c>> MapTeamTask){
      List<Opportunity_Teams__c> listTOsendMail;
      Salesforce_Base_URL__c mc = Salesforce_Base_URL__c.getInstance();
      List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
      for(ID sendToteam : MapTeamTask.KeySet()){
          listTOsendMail = MapTeamTask.get(sendToteam);
          if(listTOsendMail.size()>0){
              // Logic to send mail:
              
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      // Step 2: Set list of people who should get the email
      List<String> sendTo = new List<String>();
        String Client=UtilConstantsR3.hyphen;
        String OpportunityID=UtilConstantsR3.hyphen;
        String Opportunity=UtilConstantsR3.hyphen;
        String Requestor=UtilConstantsR3.hyphen;
        String DateRequested=UtilConstantsR3.hyphen;
        String DateNeeded=UtilConstantsR3.hyphen;
        String Comments=UtilConstantsR3.hyphen;
      sendTo.add(listTOsendMail[0].Route_To__r.User_Master__r.User__r.Email);
      mail.setToAddresses(sendTo);
        String body=UtilConstants.EMPTY_STRING;
      // Step 4. Set email contents - you can use variables!
      mail.setSubject(UtilConstants.SUB_TAG1);

      body =UtilConstants.BODYTAG1;
      for(Opportunity_Teams__c t:listTOsendMail){
      if(t.Client__c!=NULL){
      Client=t.Client__c;
      }
      if(t.Opportunity__r.sap_om_id__c!=NULL){
      OpportunityID=t.Opportunity__r.sap_om_id__c;
      }
      if(t.Opportunity__r.name!=NULL){
      Opportunity=t.Opportunity__r.name;
      }
      if(t.Requestor__r.User__r.name!=NULL){
      Requestor=t.Requestor__r.User__r.name;
      }
      if(t.Requested_Date__c!=NULL){
      DateRequested=String.valueOf(t.Requested_Date__c);
      }
      if(t.Needed_By_Date__c!=NULL){
      DateNeeded=string.valueOf(t.Needed_By_Date__c);
      }
      if(t.Assignment_comments__c!=NULL){
      Comments=t.Assignment_comments__c;
      }
      body += UtilConstants.TAG8+Client+UtilConstants.TAG9+OpportunityID+UtilConstants.TAG9+Opportunity+UtilConstants.TAG9+Requestor +UtilConstants.TAG9+DateRequested+UtilConstants.TAG9+DateNeeded +UtilConstants.TAG9+Comments+UtilConstants.TAGS;
      }
      body +=UtilConstants.TAG7;
        body += UtilConstants.TAG6;
        body += UtilConstants.TAG4+mc.Domain_URL__c+UtilConstants.TAG5;
        body += UtilConstants.TAG1;
        body +=UtilConstants.TAG3;
        body +=UtilConstants.TAG1;
        body +=UtilConstants.TAG2;       
      mail.setHtmlBody(body);
      mails.add(mail);
          }
      }
      Messaging.sendEmail(mails);
  }
  
 }