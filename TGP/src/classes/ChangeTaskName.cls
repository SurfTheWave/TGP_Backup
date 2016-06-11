/**
   @Author         : Apoorva
   @name           : ChangeTaskName
   @CreateDate     : 
   @Description    : class Defined for changing task name
   @Version        : 1.0
  */
public with sharing class ChangeTaskName {
 /**
   *  @Description : 
   *  @name : changeTaskName
   *  @param : 
   *  @return parameter - void
   *  @throws exception- null
   */     
     public static void changeTaskName(List<task> tlist){
       Map<Id, Task> reqtasks = new Map<Id, Task>();
        For (Task t: tlist) {
            if (t.WhatId != null) {
                 String objectT=t.WhatId.getSObjectType().getDescribe().getName();
                reqtasks.put(t.WhatId, t);
                if(objectT.equalsIgnoreCase(UtilConstants.APPR_REQ)){
                    List<approval_request__c> objList=[Select id,approval_stage__r.opportunity__r.Name, 
                                                       approver__c,approver__r.user__c from approval_request__c
                                                       where id in:reqtasks.keySet() limit 5000];
                        if (reqtasks.size() > 0) {
                            for (approval_request__c req : objList) {
                                t.Subject =req.approval_stage__r.opportunity__r.Name +UtilConstants.ApprovalValue;
                                DateTime currentTime = system.now();
                                String currentTimeS= currentTime.format(UtilConstants.DATE_FORM);
                                if(currentTimeS.Equals(UtilConstants.MONDAY) || currentTimeS.Equals(UtilConstants.TUESDAY)||currentTimeS.Equals(UtilConstants.SUNDAY)){
                                   t.ActivityDate=t.ActivityDate;
                                }
                                else if(currentTimeS.Equals(UtilConstants.WEDNESDAY)||currentTimeS.Equals(UtilConstants.THURSDAY)||currentTimeS.Equals(UtilConstants.FRIDAY)){
                                    t.ActivityDate=t.ActivityDate+2;
                                }
                                else if(currentTimeS.Equals(UtilConstants.Saturday)){
                                    t.ActivityDate=t.ActivityDate+1;
                                }else{}

                              t.Ownerid= req.approver__r.user__c;
                              }    
                         }
                    }
        else if(objectT.equalsIgnoreCase(UtilConstants.ActionItem)){
        List<Action_Item__c> maillist=new List<Action_Item__c>();  
        List<Action_Item__c> objList=[Select id,approval_stage__r.opportunity__r.Name, Primary_Owner__c,Primary_Owner__r.user__c, due_date__c from Action_Item__c where id in:reqtasks.keySet() LIMIT 5000];
        if (reqtasks.size() > 0) {
            for (Action_Item__c req : objList) { 
                t.Subject =req.approval_stage__r.opportunity__r.Name +UtilConstants.ActionItems;
              //String userId= UtilUser.UtilUser(req.Primary_Owner__c);
              
              t.Ownerid= req.Primary_Owner__r.user__c;
              t.ActivityDate=req.due_date__c;
                maillist.add(req);
              
              //sendMail(objList[0].id,userId);
              
              }  
                sendMail(maillist);
             }
        }
        
        else if(objectT.equalsIgnoreCase(UtilConstants.Governance_OBJ)){
            
        List<SD_Governance_Data__c> objList=[Select id,opportunity__r.Name from SD_Governance_Data__c where id in:reqtasks.keySet() LIMIT 5000];
        if (reqtasks.size() > 0) {
            for (SD_Governance_Data__c req : objList) { 
                t.Subject =req.opportunity__r.Name +UtilConstants.GOV_DATA2;
                            
              }  
             }
        }
          
        else if(objectT.equalsIgnoreCase('SRAT_Tracker__c')){
           List<SRAT_Tracker__c> objList=[SELECT id, Mobilization_Plan__r.Deal__r.name,Checklist_Reviewer__r.Primary_Lead__r.user__c FROM SRAT_Tracker__c where id in:reqtasks.keySet() LIMIT 5000];
            if (reqtasks.size() > 0) {
                for (SRAT_Tracker__c req : objList) { 
                    //system.debug('Reviewer for this task:: '+req.Checklist_Reviewer__r.Primary_Lead__r.user__c);
                    t.Subject = req.Mobilization_Plan__r.Deal__r.name +':SRAT Checklist approval';
                    t.ownerId = req.Checklist_Reviewer__r.Primary_Lead__r.user__c;
                    }  
             }
        }
        
      else if(objectT.equalsIgnoreCase(UtilConstantsR3.APPR_REQ)){
            List<Tech_Approval_Request__c> objList=[Select id,approval_stage__r.opportunity__r.Name, 
                                                       approver__c,approver__r.user__c from Tech_Approval_Request__c
                                                       where id in:reqtasks.keySet() limit 5000];
                        if (reqtasks.size() > 0) {
                            for (Tech_Approval_Request__c req : objList) {
                                t.Subject =req.approval_stage__r.opportunity__r.Name +UtilConstants.ApprovalValue;
                                DateTime currentTime = system.now();
                                String currentTimeS= currentTime.format(UtilConstants.DATE_FORM);
                                if(currentTimeS.Equals(UtilConstants.MONDAY) || currentTimeS.Equals(UtilConstants.TUESDAY)||currentTimeS.Equals(UtilConstants.SUNDAY)){
                                   t.ActivityDate=t.ActivityDate;
                                }
                                else if(currentTimeS.Equals(UtilConstants.WEDNESDAY)||currentTimeS.Equals(UtilConstants.THURSDAY)||currentTimeS.Equals(UtilConstants.FRIDAY)){
                                    t.ActivityDate=t.ActivityDate+2;
                                }
                                else if(currentTimeS.Equals(UtilConstants.Saturday)){
                                    t.ActivityDate=t.ActivityDate+1;
                                }else{}

                              t.Ownerid= req.approver__r.user__c;
                              }    
                         }
        
        }
        else if(objectT.equalsIgnoreCase(UtilConstantsR3.ActionItem)){
        List<Tech_Action_Items__c> maillist=new List<Tech_Action_Items__c>();  
        List<Tech_Action_Items__c> objList=[Select id,tech_approval_stage__r.opportunity__r.Name, Primary_Owner__c,Primary_Owner__r.user__c, due_date__c from Tech_Action_Items__c where id in:reqtasks.keySet() LIMIT 5000];
        if (reqtasks.size() > 0) {
            for (Tech_Action_Items__c req : objList) { 
                t.Subject =req.tech_approval_stage__r.opportunity__r.Name +UtilConstants.ActionItems ;
              t.Ownerid= req.Primary_Owner__r.user__c;
              t.ActivityDate=req.due_date__c;
                maillist.add(req);
              
              //sendMail(objList[0].id,userId);
              
              }  
                sendMailTechAction(maillist);
             }
        }else{}

     }      
   }
 }
 
 /* *@Description:This Method is used to Send a mail     
    *@name:sendMail        
    *@param:List<Action_Item__c> maillist     
    *@return Parameter: void        
    */   
 public static void sendMail(List<Action_Item__c> maillist){
                        String orgWideEmailAddressID=UtilEmail.emailid();
     for(Action_Item__c m:maillist){
                        Email_Template__c myCS1 = Email_Template__c.getValues(UtilConstants.ActionItemMail );
                        if(myCS1!=null){
                            String myCCVal = myCS1.ID__c;
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        
                            mail.setWhatId(m.id) ;
                            mail.setTargetObjectId(m.Primary_Owner__r.user__c) ;
                            mail.setTemplateId(myCCVal); 
                            mail.saveAsActivity=false;                       
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        }
        }
 }
 
    /* *@Description:This Method is used to Send a mail     
    *@name:sendMailTechAction        
    *@param:List<Tech_Action_Items__c> maillist    
    *@return Parameter: void        
    */ 
      public static void sendMailTechAction(List<Tech_Action_Items__c> maillist){
                            String orgWideEmailAddressID=UtilEmail.emailid();
         for(Tech_Action_Items__c m:maillist){
                                id emailtempid = [select id from emailtemplate where developername=:UtilConstantsR3.Tech_Action_Items limit 1].id;
                                String myCCVal = emailtempid;
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                            
                                mail.setWhatId(m.id) ;
                                mail.setTargetObjectId(m.Primary_Owner__r.user__c) ;
                                mail.setTemplateId(myCCVal); 
                                mail.saveAsActivity=false;                       
                                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                            
            }
     }
 
 /**@Description:This Method is used to delete Task   
    *@name:deltask        
    *@param:List<task>taskNew
    *@return Parameter: void        
    */    
 public static void deltask(List<task>taskNew){
 
 List<task>t1=new List<Task>();
 for(task t2:taskNew){
 for(task t:[select id from task where ownerid=:t2.ownerid And whatid=:t2.whatId LIMIT 5000]){
 
 t1.add(t);
 }}
 delete(t1);
 }
    /*@Description:This Method is used to Update existing task 
    *@name:updateExistingTasks        
    *@param:List<task> taskList
    *@return Parameter: void        
    */ 
    public static void updateExistingTasks(List<task> taskList){
        Set<Id> activityIds = new Set<Id>();
        List<Task> tasksToUpdateList = new List<Task>();
        for( Task t : taskList ){
            if( !t.IsRecurrence ){
                activityIds.add( t.RecurrenceActivityId );
            }
        }
        for(Task t : [ Select status from Task where RecurrenceActivityId IN : activityIds LIMIT 5000]){
            t.status = UtilConstants.COMPLETED;
            tasksToUpdateList.add( t );
        }
        try{
            Database.update( tasksToUpdateList );
        }catch(Exception e){
          string exceptionCaught = string.valueof(e);
}
    }
}