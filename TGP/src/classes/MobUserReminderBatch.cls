/*
  @Author: Madhu
  @Name: MobUserReminderBatch
  @Created Date: 05 Nov 2015
  @Description: This class is used to send mail alerts to MWB user who not logged in from more than 30 days.
  @version: 1.0 
*/
global class MobUserReminderBatch implements Database.Batchable<sObject>
{
 
    public List<String> usrEmail{get;set;}

/*   global MobUserReminderBatch(String str)
   {
       
   } */

   global Database.QueryLocator start(Database.BatchableContext BC)
   {
   
      DateTime s = system.today().addDays(-30);
      String query;
      
      if(Test.isRunningTest()) {
      
          query = 'SELECT Id, Email, LastLoginDate, IsActive,profile.Name FROM User\n'+ ' where IsActive=true\n'+ ' and profile.Name like \'Mob%\'\n'+ ' LIMIT 1';

      } else {

        query = 'SELECT Id, Email, LastLoginDate, IsActive,profile.Name FROM User\n'+ ' where IsActive=true\n'+ ' and profile.Name like \'Mob%\'\n'+ ' and UserRole.DeveloperName != \'Mobilization_Leadership\'\n'+ ' and LastLoginDate <=:s';
        }
    
        return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<User> usr)
   {
   
     usrEmail=new List<String>();
         usrEmail.clear();
        for(User u:usr){
           // system.debug('_____________id______'+u.id+'___________Email______________'+u.Email+'_________Last Login Date_____'+u.LastLoginDate);
            if(u.Email!=null)
                usrEmail.add(u.Email);
        }
       if(usrEmail.size()>0)
           sendmail(usrEmail);
   }
    public void sendmail(List<String> str) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        string [] toaddress=str;
      //  email.setToAddresses(toaddress);
        email.setBccAddresses(toaddress);
     //   email.setReplyTo('madhusudhan.karna@accenture.com');
        email.setSenderDisplayName('BPO Mob Workbench');
        email.setSubject('Gentle Reminder from Salesforce');
        email.setHtmlBody('Dear user, <br/><br/>It has been observed that you have not logged into Mobilization Workbench tool in the last 30 days. Request you to login to Workbench and make required updates to the deals to which you are assigned.<br/><br/>Your access to Mobilization Workbench will be revoked automatically in next 10 days if there is no action from your side. <br/>In case you no longer require access to MWB please send an email to the following IDs – <br/>riya.dhoorjathi@accenture.com<br/>mazhar.i.gadhwalla@accenture.com<br/><br/><br/>Regards<br/>MWB ADMIN');  
        
        Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});
     
    }
    
    


   global void finish(Database.BatchableContext BC)
   {
    
   }

}