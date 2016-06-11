public class SendEmailOnBenchmarkSyncComplete {

    public String userEmail;
    public String firstName;
    public SendEmailOnBenchmarkSyncComplete(){
        String userName = UserInfo.getUserName();
        User activeUser = [Select FirstName,Email From User where Username = : userName limit 1];
        firstName = activeUser.FirstName;
        userEmail = activeUser.Email;
        //SendEmailToSyncInitiator();
    }
    public void SendEmailToSyncInitiatorOnSuccess(){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<String> sendTo = new List<String>();
        sendTo.add(userEmail);
        mail.setToAddresses(sendTo);
        mail.setSubject('What\'s in a name? That which we call a rose By any other name would smell as sweet');
        String body = 'Dear ' + firstName + ', <br />';
        body += 'Sync completed<br />';
        body += 'You have passsed!<br />';
        mail.setHtmlBody(body);
        mails.add(mail);
        try{
            Messaging.sendEmail(mails);
            }
        catch(Exception w){
            throw (w);
        }    
    }
    
    public void SendEmailToSyncInitiatorOnFailure(){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<String> sendTo = new List<String>();
        sendTo.add(userEmail);
        mail.setToAddresses(sendTo);
        mail.setSenderDisplayName('What\'s in a name? That which we call a rose By any other name would smell as sweet');
        mail.setSubject('You failed!!!!');
        String body = 'Dear ' + firstName + ', <br />';
        body += 'Sync Failed <br />';
        body += 'You Shall not Pass!!! <br />';
        mail.setHtmlBody(body);
        mails.add(mail);
        try{
            Messaging.sendEmail(mails);
            }
        catch(Exception w){
            throw (w);
        }    
    }
}