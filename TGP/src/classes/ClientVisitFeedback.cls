/**@Author- Reena Thakre
**/
public Class ClientVisitFeedback{
        
/* To update the center to be visited field*/
    public void updateCentertobeVisited(List<Client_Visit_Feedback__c> feedbacks){
        
        List<Client_Visit_Feedback__c> feedbackList =new List<Client_Visit_Feedback__c>();
        set<id> setid=new set<id>();
        for(Client_Visit_Feedback__c feedback: [select center__c, Client_Visit_Request__c from Client_Visit_Feedback__c where id in :feedbacks limit 1000 ]){
              setid.add(feedback.Client_Visit_Request__c);             
           }
        Map<id,String> centersMap =new Map<id,String>();
        for(Client_Visit_Request__c c:[select id,Centre_to_be_visited__c from Client_Visit_Request__c  where id  in :setid limit 1000]){
             centersMap.put(c.id,c.Centre_to_be_visited__c);       
        }
        
        for(Client_Visit_Feedback__c feedback :[select center__c, Client_Visit_Request__c from Client_Visit_Feedback__c where id in :feedbacks limit 1000 ]){
               if(centersMap.containsKey(feedback.Client_Visit_Request__c)){
               feedback.center__c=centersMap.get(feedback.Client_Visit_Request__c);
               feedbackList.add(feedback);
                }
                   
        }try{
          database.update(feedbackList);
        }catch(Exception e){         
              system.debug(e);
        }
    }
    
        //this methode is to send the mail once the feedback request is created 
         public static void sendEmailonCreate (List<client_visit_feedback__c> feedbacks)    {  
                try{
                Id targetID;
                List<String> lstOfUserEmailId = new List<String>();
                List<String> lstOfCCUsersEmailId = new List<String>();                
                String orgWideEmailAddressID=UtilEmail.emailid();
                List<ID>usersID=new List <ID>();
                List<String> CCemail=new List<String>();
                Messaging.SingleEmailMessage mail;
                List<String>grpNames=new List<String>();
                List<id>groupIDs=new List<id>();
                Map<String, id> grpidMap=new Map<String,Id>();
                Map<id, List<id>> grpMemMap=new Map<id, List<id>> ();
                Map<id,string> emailMap=new Map<id, String>();
                
                Email_Template__c template=Email_Template__c.getValues(UtilConstantsforSWB.CLIENT_VISIT_FEEDBACK_UPDATE_TEMPLATE);
                id newClient = template.ID__c;               
                String currentuserid =Userinfo.getuserid();
               // CCemail.add(currentuserid);   
                                                         
               Id CCgroupid=[Select Id from Group where name=:UtilConstantsforSWB.CONTACT_CENTER_GROUP limit 1].id;                              
                for(GroupMember member:[Select UserOrGroupId From GroupMember where GroupId =:CCgroupid]){
                          String id=member.UserOrGroupId;
                          CCemail.add(id);                             
                } 
                if(CCemail.size()>0){
                          targetID=CCemail.get(0);
                          CCemail.remove(0);
                          }           
                for(User usr:[select email, firstname,lastname from user where id in:CCemail]){
                         lstOfUserEmailId.add(usr.email);
                         system.debug('>>>>>>>>>>>>>eamil'+lstOfUserEmailId);
                }      
    
    
                for(client_visit_feedback__c feedback:[select Client_Visit_Request__r.Support_Group__c,center__c, Client_Visit_Request__c from Client_Visit_Feedback__c where id in :feedbacks limit 1000 ]){
                grpNames.add(feedback.Client_Visit_Request__r.Support_Group__c);                  
                }
                    
                    
                for(Group grpID:[Select Id,name from Group where name in:grpNames limit 1000]){
                groupIDs.add(grpID.id);
                grpidMap.put(grpID.name,grpID.id);
                    }
                    
                
                    
                for(GroupMember grpMem :[Select UserOrGroupId, GroupId From GroupMember where GroupId in :groupIDs limit 1000]){                   
                usersID.add(grpMem.UserOrGroupId);                  
                if(grpMemMap.containskey(grpMem.GroupId)){
                List<id> ids=grpMemMap.get(grpMem.GroupId);
                ids.add(grpMem.UserOrGroupId);
                grpMemMap.put(grpMem.GroupId,ids);
                }
                else {
                grpMemMap.put(grpMem.GroupId,new List<id>{grpMem.UserOrGroupId});
                }
                }
                    
                    
                for(User usr:[select email from user where id in:usersID limit 100]){         
                emailMap.put(usr.id,usr.email);
                }
    
    
                for(client_visit_feedback__c feedback : [select center__c,Client_Visit_Request__r.Support_Group__c, Client_Visit_Request__c from Client_Visit_Feedback__c where id in :feedbacks limit 1000 ])
                 {       
                          
                          Id GroupId;
                          if(grpidMap.containskey(feedback.Client_Visit_Request__r.Support_Group__c)&& grpidMap.get(feedback.Client_Visit_Request__r.Support_Group__c)!=null ){
                          GroupId=grpidMap.get(feedback.Client_Visit_Request__r.Support_Group__c);
                          }
                          
                          List<id> GroupMemIdList =new List<id>();
                          if(grpMemMap.containskey(GroupId) && grpMemMap.get(GroupId)!=null ){
                          GroupMemIdList=grpMemMap.get(GroupId);
                          }
                          
                          if(GroupMemIdList.size()>0 && targetId==null){
                          targetID=GroupMemIdList.get(0);
                           GroupMemIdList.remove(0);
                         }
                         
                         
                          for(id ids:GroupMemIdList){                                                 
                          if(emailMap.containskey(ids) && emailMap.get(ids)!=null ){
                          lstOfUserEmailId.add(emailMap.get(ids));
                          
                          }
                          
                          }
                          
                          
                          
                          
    
                        mail = new Messaging.SingleEmailMessage();
                        mail.setTargetObjectId(targetID);
                        mail.setWhatId(feedback.id);
                        //mail.setCCAddresses(lstOfCCUsersEmailId);                         
                        mail.setTemplateId(newClient);
                        mail.saveAsActivity=false;
                        mail.setToAddresses(lstOfUserEmailId);
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        if(targetID!=null)
                        Messaging.sendEmail(new Messaging.SingleEmailMessage [] { mail}); 
                         
                }
                 
               }
                Catch(DMLException e)
                {                
                 string s=e.getMessage();
                } 
        }
    
    
}