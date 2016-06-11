/**
   @Author : Apoorva Sharma
   @name   : ActionReminder
   @CreateDate : 8 January 2014 
   @Description : 
   @Version : 1.0 
  */
/******************
 * @class name : ActionReminder
 * 
 * @purpose : Send Reminder to primary owner
 ******************/
global class ActionReminder {
/**********
 * @method :sendReminder
 * @purpose :
 
**********/
  webservice static  void sendReminder(List<String> actid){
                //system.debug('idssss--'+actid);
                //system.debug('idssss--'+actid.size());
      list<String> actionid=new List<String>();
      for(String s:actid){
          actionid=s.split(UtilConstants.COMMA_STRING);
         // actionid.add('\''+s+'\'');
     }
     //system.debug('actionid--'+actionid);
                List<action_item__c> actionList=[SELECT id,Primary_Owner__c,
                                                 Primary_Owner__r.user__c,action_item_status__c 
                                                 from Action_Item__c where id in :actionid LIMIT 5000];
                
                //system.debug('---actionList-----'+actionList);
                // for(Action_Item__c act : actionList){
                 // integer i=0;
                  //  String userId= UtilUser.UtilUser(act.Primary_Owner__c);
                    sendMail(actionList);
                    //i++;
                 //}        
       }
       
/***************
 * @method :sendMail
 * 
 * @param : action Item list
        
***************/         
       public static void sendMail(List<action_item__c> alist){
           try{
           Messaging.SingleEmailMessage mail = null; 
           for(action_item__c a:alist){
                       if(!a.action_item_status__c.EqualsIgnoreCase(UtilConstantsforSWB.ActionItemCompleted)){
                       String orgWideEmailAddressID=UtilEmail.emailid();
           
                       /*Email_Template__c myCS1 = Email_Template__c.getValues(UtilConstantsforSWB.ActionMailBPO);
                       String Cval=myCS1.ID__c;*/
                        id emailtemplate = [select id from emailtemplate where developername=:UtilConstantsforSWB.ActionMailBPO limit 1].id;   
                        String Cval=emailtemplate;
                        mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
           
                        mail.setWhatId(a.id) ;
                        mail.setTargetObjectId(a.Primary_Owner__r.user__c) ;
                        mail.setTemplateId(Cval); 
                        mail.saveAsActivity=false;                       
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
               }
            }
         }
         Catch(Exception e)
         {
             String str= e.getmessage();
         }
        } 

}