/*****************
@author : Ezdhan Hussain S.K
@description : This class implements scheduleble class
                It is executed every weekday between 12:00 AM - 1:00AM
                
*******************/
global without sharing class ApprovalMeetingDailyAgendaClass implements Schedulable  {
    //this variable is used to schedule batch apex only in test class
    public static String CRON_EXP = UtilConstants.CRON;

   /* 
        * Execute method queries a template desinged in email templates
        * Emails stored in custom settings are retrieved
        * All TO and CC addresses are mapped
        * Email is sent
    }*/
    global void execute(SchedulableContext ctx) {
        
        list<dateavalueforagenda__c> customlist = new list<dateavalueforagenda__c>();
        dateavalueforagenda__c CustomS = dateavalueforagenda__c.getOrgDefaults();
        datetime todaydate = system.now();
        string todayvalue = todaydate.format(UtilConstantsforSWB.DAY_FORMAT);
        Date datobj ;
        If(todayvalue.equalsIgnoreCase(UtilConstantsforSWB.FRIDAY)){
            datobj = system.today()+3;
        }
        else{
            datobj = system.today()+1;
        }
        Integer dy = datobj.day();
        CustomS.next_date__c=dy;
        customlist.add(CustomS);
        system.debug('+++'+dy);
        
        
        try{
        update customlist;
        }
        catch(exception e){
            string error = string.valueOf(e);
        }
        
        //queryng template id
        id emailtempid = [SELECT Id FROM EmailTemplate WHERE IsActive=true AND DeveloperName=:Label.Daily_Agenda_mail_template_name  LIMIT 1].id;
        //querying email addresses from custom settings
        Daily_Agenda_Mails_List__c cs = Daily_Agenda_Mails_List__c.getInstance(UtilConstants.DAILY_AGNDA);
        List<string> Alltoaddresses = cs.To_Addresses__c.split(UtilConstants.COMMA_STRING); 
        List<string> Allccaddresses = new list<string>();
        if(cs.CC_Addresses__c!=null){
         Allccaddresses = cs.CC_Addresses__c.split(UtilConstants.COMMA_STRING); 
        }
        String orgWideEmailAddressID=UtilEmail.emailid(); 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(!Test.IsRunningTest()){
            Id userid = [select id from user where email=:Alltoaddresses[0] limit 1].id;
            Alltoaddresses.remove(0);
            mail.setTargetObjectId(userid);
        }else{
            Id userid = UserInfo.getUserId();
            Alltoaddresses.add(UtilConstants.TEST_USER_2234_EMAIL);
            mail.setTargetObjectId(userid);
        }
        
        
        
        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
        if(Alltoaddresses.size()>0){
        mail.setToAddresses(Alltoaddresses);
        }
        if(Allccaddresses.size()>0){
           mail.setCCAddresses(Allccaddresses);
        }
        
        mail.setTemplateId(emailtempid);
     
        mail.setSaveAsActivity(false);
       list<Messaging.SendEmailResult> result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
      /*  list<dateavalueforagenda__c> customlist = new list<dateavalueforagenda__c>();
      dateavalueforagenda__c CustomS = dateavalueforagenda__c.getOrgDefaults();
    datetime todaydate = system.now();
        string todayvalue = todaydate.format(UtilConstantsforSWB.DAY_FORMAT);
        if(todayvalue.equalsIgnoreCase(UtilConstantsforSWB.THURSDAY)){
            CustomS.next_date__c = CustomS.next_date__c+3;
            customlist.add(CustomS);
        }
        else{
            CustomS.next_date__c = CustomS.next_date__c+1;
            customlist.add(CustomS);
        }
        try{
        update customlist;
        }
        catch(exception e){
            string error = string.valueOf(e);
        }*/
       //Assertion to check proper execuion in test class
        for(Messaging.sendEmailResult ss: result){
            system.assert(ss.issuccess());
        }
    }
}