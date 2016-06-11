/*
  @Author: Rishab
  @Name: TechToolTriggerHandler
  @Created Date: 
  @Description:
  @version: 1.0
*/
public with sharing class TechToolTriggerHandler{
    public static Boolean isRecursive=true;
    Public static List<Id> userIds = new List<Id>();
    Public static List<String> emailList = new List<String>();
    /*
  @Author: Rishab
  @Name: processSendMail
  @Created Date: 
  @Description:
  @version: 1.0
*/
    public static void processSendMail(Map<Id, Id> techMap, String tempId, ID techToolId){       
        try{
            for(GroupMember gm:[SELECT Id, UserOrGroupId, GroupId FROM GroupMember WHERE Group.DeveloperName=:UtillContstant_Novasuite.TECH_TOOL_OUT_OF_SCOPE_APPROVAL limit 500]){
                userIds.add(gm.UserOrGroupId);
            }               
            for(User us:[SELECT Email From User WHERE Id IN:userIds]){
                emailList.add(us.Email);          
            }
            Messaging.SingleEmailMessage[] mailList = new List<Messaging.SingleEmailMessage>();
            for(Id uid: techMap.keyset()){
                mailList.add(doSendEmail(tempId,techMap.get(uid), techToolId));
            }
            Messaging.sendEmail(mailList);
        }catch(Exception ex){
            String str=ex.getMessage();
        }
        
        
    }
    /*
  @Author: Rishab
  @Name: doSendEmail
  @Created Date: 
  @Description:
  @version: 1.0
*/
    Private static Messaging.SingleEmailMessage doSendEmail(String tempId, Id userId, Id techID){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(userId) ;
        mail.setTemplateId(tempId);
        mail.setCcAddresses(emailList);                  
        mail.saveAsActivity=false;
        mail.setWhatId(techID);
        return mail;     
    }

}