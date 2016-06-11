/**
   @Author : Rishabh Agrawal
   @name   : TechActionItemLogReminder
   @CreateDate : 11 November 2015
   @Description : 
   @Version : 1.0 
  */
/******************
 * @class name : TechActionItemLogReminder
 * 
 * @purpose : Send Reminder to primary owner
 ******************/
global without sharing  class TechActionItemLogReminder{
/**********
 * @method :sendReminder
 * @purpose :
 
**********/
  webservice static  void sendReminder(List<String> actid){
                system.debug('idssss--'+actid);
                system.debug('idssss--'+actid.size());
      list<String> actionid=new List<String>();
      for(String s:actid){
          actionid=s.split(UtilConstants.COMMA_STRING);
         // actionid.add('\''+s+'\'');
     }
     system.debug('actionid--'+actionid);
                List<Tech_Action_Items__c > actionList=[SELECT id,Primary_Owner__c,
                                                 Primary_Owner__r.user__c,action_item_status__c 
                                                 from Tech_Action_Items__c where id in :actionid LIMIT 5000];
                
                system.debug('---actionList-----'+actionList);
                // for(Tech_Action_Items__c act : actionList){
                 // integer i=0;
                  //  String userId= UtilUser.UtilUser(act.Primary_Owner__c);
                    sendMail(actionList);
                    //i++;
                 //}        
       }
       
         /**
     * @description       This method is used to ensure that only technical architect leads/technical architect are allowed to create approval stage.
     * @param             list<Tech_Approval_Stage__c> requestlist
     * @return            Void
     * @throws            User-Defined Exception
     */  
     public static void addActionItem(list<Tech_Action_Items__c> requestlist){
        set<id> opportunityIds =new set<id>();
        for(Tech_Action_Items__c req:requestlist){
            opportunityIds.add(req.Opportunity_Id_Dev__c);
        }
        
        list<Opportunity_Teams__c> oppTeamRec=[Select id,Opportunity_Role_Dev__c,Opportunity_Team_Member__r.user__c,Opportunity__c from Opportunity_Teams__c where 
                                                (Opportunity_Role_Dev__c=:UtilConstantsR3.SuppTechArch or Opportunity_Role_Dev__c=:UtilConstantsR3.Tech_Arch) and Opportunity__c in :opportunityIds and 
                                                Opportunity_Team_Member__r.user__c=:userinfo.getUserid() limit 5000];
        if(oppTeamRec.isEmpty() &&  userinfo.getProfileId()!=UtilConstantsforSWB.utilMethod(Label.System_Admin_Profile)){
              for(Tech_Action_Items__c requestRec:requestlist){
                requestRec.addError(UtilConstantsR3.ERROR_MSG_TechAction);
              }
        }
        
        
     }
       
/***************
 * @method :sendMail
 * 
 * @param : action Item list
        
***************/         
       public static void sendMail(List<Tech_Action_Items__c > alist){
           try{
           Messaging.SingleEmailMessage mail = null; 
           for(Tech_Action_Items__c a:alist){
                       if(!a.action_item_status__c.EqualsIgnoreCase(UtilConstantsforSWB.ActionItemCompleted)){
                       String orgWideEmailAddressID=UtilEmail.emailid();
           
                       /*Email_Template__c myCS1 = Email_Template__c.getValues(UtilConstantsforSWB.ActionMailBPO);
                       String Cval=myCS1.ID__c;*/
                        id emailtemplate = [select id from emailtemplate where developername=:UtilConstantsR3.Tech_Action_Items LIMIT 5000].id;   
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