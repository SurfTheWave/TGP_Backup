/**
    *@Author : Mukesh Rawat       
    *@Description:This Class is used to allow PMO to route the request of Opportunity record to Offering tech Lead.     
    *@name:RouteToOffrngleadController        
    *@param:list<Opportunity_Teams__c> opportunityList      
    */ 
global without sharing class RouteToOffrngleadController{

/**
    *@Description:This Method is used to allow PMO to route the request of Opportunity record to Offering tech Lead.     
    *@name:routeToOffrnglead        
    *@param:String alloptmId   
    */    
     WebService static String routeToOffrnglead(String alloptmId){
     UtilConstants.PreventTriggerOnRouting = True;
     String status;
        if(alloptmId!=null){
            Opportunity_Teams__c userList = [SELECT id, name,Opportunity_Team_Member__c,Opportunity__r.name, Requestor__c,Opportunity_Team_Member__r.User__r.id,Opportunity_Team_Member__r.User__r.email,Route_To__c,Route_To__r.User_Master__r.User__r.id FROM Opportunity_Teams__c WHERE Id=:alloptmId limit 1];
            List<User> sendUserListforemail= new List<User>();
            List<User> offeringTechList= new List<User>();
                    
                    try{
                        //for(Opportunity_Teams__c opptm : userList){
                            
                            //system.debug('User ID===============>>' +userList.Route_To__r.User_Master__r.User__r.id);
                            userList.ownerId = userList.Route_To__r.User_Master__r.User__r.id;
                            task routingtask =new task();
                            routingtask.subject= UtillContstant_Novasuite.ASSIGN_TECH_ARC_OPP+userList.Opportunity__r.name;
                            routingtask.Ownerid=userList.ownerId;
                            routingtask.whatid=userList.id;
                            //system.debug('routingtask.Ownerid-------------------->'+routingtask.Ownerid);
                            //system.debug('routingtask.whatid-------------------->'+routingtask.whatid);
                            routingtask.ActivityDate=system.today()+3 ;
                            routingtask.Status= UtillContstant_Novasuite.NOT_STARTED;
                            Database.insert(routingtask);
                            //system.debug('userList.Route_To__r.User_Master__r.User__r.id-------------------->'+userList.Route_To__r.User_Master__r.User__r.id);
                            sendUserListforemail.add(new User(Id=userList.Route_To__r.User_Master__r.User__r.id));
                            
                            offeringTechList.add(new User(Id=userList.Opportunity_Team_Member__c));
                            //system.debug('==================================>> Requestor-->>'+userList.Requestor__c);
                            userList.Route_To__c = NULL;
                            Database.Update(userList);
                            If(userList.Opportunity_Team_Member__c==null){
                                    //Database.Update(userList);
                                    RouteToOffrngleadController.sendMailToPMOGroup(new List<Opportunity_Teams__c> {userList},sendUserListforemail);
                            }else{
                                    //Database.Update(userList);
                                    RouteToOffrngleadController.OppteamAssignByOffrngTechLead(new List<Opportunity_Teams__c> {userList},offeringTechList);
                      
                                    
                            }
                        
                                    
                                status =UtilConstants.OK_STR;
                            }catch(Exception e){
                                String s = e.getMessage();
                                //system.debug('===========>> error message' +s);
                            }
                
            
        }
        
        else{
                status =UtilConstants.ERROR_STR;
            }
            return status;
    }


/**
   *  @Description : This method is used send mail to PMO Group(Tech Arch) and assignee.
   *  @name : sendMailToPMOGroup
   *  @param : List<Opportunity_Teams__c> oppTeamOldList,List Of User
   *  @return parameter - void
   *  @throws exception- DML Exception
   */  
       public static void sendMailToPMOGroup(List<Opportunity_Teams__c> oppTeamIdsToPMO,List<User> mailToAddresses){
              
                //system.debug('==================================>> Oppteam from Route To'+oppTeamIdsToPMO.size());
                //system.debug('==================================>> User Got from Route To'+mailToAddresses.size());
                //system.debug('==================================>> User Got from Route To'+mailToAddresses);
            try{
            
                List<String> userEmailId = new List<string>();
                String userId=UtilConstants.EMPTY_STRING;
                for(User u : mailToAddresses){
                    if( userId.equals(UtilConstants.EMPTY_STRING)){
                           userId = u.Id;
                       }else{
                           userEmailId.add(u.Email);
                       }
                   }
 

                String orgWideEmailAddressID=UtilEmail.emailid();
                Email_Template__c myCS1;
                Messaging.SingleEmailMessage mail;
                List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
                for(Opportunity_Teams__c oppTeamRec : oppTeamIdsToPMO){
                                //if(oppTeamRec.Role__r.ShouldReceiveAlertMail__c == true){
                                //for(User mailToadd : mailToAddresses){    
                                    
                        List<String> sumOfIds = new List<String>();                    
                        myCS1= Email_Template__c.getValues(UtilConstants.EMAIL_TO_OFFRNG_TECH_LEAD);
                        String myCCVal = myCS1.ID__c;  
                        mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        mail.setWhatId(oppTeamRec.id) ;
                        mail.setTargetObjectId(userId) ;
                        mail.setToAddresses(userEmailId);
                       //system.debug('==================================>> Mail To be Send (TO)'+userEmailId.size());
                            //sumOfIds.add(oppTeamRec.Requestor__c);
                    sumOfIds.addAll(getUserEmail(new List<string> {oppTeamRec.Requestor__c}));
                        //system.debug('==================================>> Mail Sent to Requestor'+oppTeamRec.Requestor__c);
                            sumOfIds.addAll(getEmailIdsFromTechArchGrp());
                    //system.debug('==================================>> Tech arch  group member IDs'+getEmailIdsFromTechArchGrp());
                        //mail.setCCAddresses(sumOfIds);
                        //system.debug('==================================>> all Mail To be Send in CC(requestor and member in tech arch group)'+sumOfIds);
                        //mail.setCCAddresses(UtilUser.getUserEmail(oppTeamRec.Requestor__c));
                        mail.setTemplateId(myCCVal);
                        mail.saveAsActivity=false;
                        allMails.add( mail );  
                    //system.debug('==================================>> mail---------->>'+mail);
                }
                    if(!Test.isRunningTest()){
                    Messaging.sendEmail(allMails);
                    }    
                //system.debug('==================================>> Mail To be Send'+allMails);
                
                }
                Catch(Exception e)
                {
                     //System.debug('E===************************>> '+e);
                     string s=e.getMessage();
                }
                
                
    }
    
    
    
    /**
   *  @Description : This method is used send mail to opportunity team member after assigned by offering tech lead.
   *  @name : OppteamAssignByOffrngTechLead
   *  @param : List<Opportunity_Teams__c> oppTeamOldList,List Of User
   *  @return parameter - void
   *  @throws exception- DML Exception
   */ 
    public static void oppteamAssignByOffrngTechLead(List<Opportunity_Teams__c> oppTeamIdsToPMO,List<User> mailToAddresses){
              
                //system.debug('==================================>> Oppteam from Route To'+oppTeamIdsToPMO.size());
                //system.debug('==================================>> User Got from Route To'+mailToAddresses.size());
                //system.debug('==================================>> User Got from Route To'+mailToAddresses);
            try{
            
                List<String> userEmailId = new List<string>();
                String userId=UtilConstants.EMPTY_STRING;
                for(User u : mailToAddresses){
                    if( userId.equals(UtilConstants.EMPTY_STRING)){
                           userId = u.Id;
                       }else{
                           userEmailId.add(u.Email);
                       }
                   }
 

                String orgWideEmailAddressID=UtilEmail.emailid();
                Email_Template__c myCS1;
                Messaging.SingleEmailMessage mail;
                List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
                for(Opportunity_Teams__c oppTeamRec : oppTeamIdsToPMO){
                                //if(oppTeamRec.Role__r.ShouldReceiveAlertMail__c == true){
                                //for(User mailToadd : mailToAddresses){    
                                    
                        List<String> sumOfIds = new List<String>();                    
                        myCS1= Email_Template__c.getValues(UtilConstants.EMAIL_TO_OFFRNG_TECH_LEAD);
                        String myCCVal = myCS1.ID__c;  
                        mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        mail.setWhatId(oppTeamRec.id) ;
                        mail.setTargetObjectId(userId) ;
                        mail.setToAddresses(userEmailId);
                        //system.debug('==================================>> Mail To be Send (TO)'+userEmailId.size());
                            //sumOfIds.add(oppTeamRec.Requestor__c);
                    sumOfIds.addAll(getUserEmail(new List<string> {oppTeamRec.Requestor__c}));
                        //system.debug('==================================>> Mail Sent to Requestor'+oppTeamRec.Requestor__c);
                            sumOfIds.addAll(getEmailIdsFromTechArchGrp());
                            sumOfIds.addAll(getUserEmail(new List<string> {oppTeamRec.Route_To__r.User_Master__r.User__r.id}));
                    //system.debug('==================================>> Tech arch  group member IDs'+getEmailIdsFromTechArchGrp());
                        mail.setCCAddresses(sumOfIds);
                        //system.debug('==================================>> all Mail To be Send in CC(requestor and member in tech arch group)'+sumOfIds);
                        //mail.setCCAddresses(UtilUser.getUserEmail(oppTeamRec.Requestor__c));
                        mail.setTemplateId(myCCVal);
                        mail.saveAsActivity=false;
                        allMails.add( mail );  
                    //system.debug('==================================>> mail---------->>'+mail);
                }
                Messaging.sendEmail(allMails);
                //system.debug('==================================>> Mail To be Send'+allMails);
                
                }
                Catch(Exception e)
                {
                     //System.debug('E===************************>> '+e);
                     string s=e.getMessage();
                }
                
                
    }
    
    
    
    
    /**
   *  @Description : This method is used get email of List of User.
   *  @name : getUserEmail
   *  @param : List of ids
   *  @return parameter - List of emails(string)
   */ 
     public static List < String > getUserEmail(List<String> uid){
        List < String > userEmail = new List < String > ();
        try {
            for (User_Master__c userMasterRec: [SELECT id, user__r.id, user__r.Email 
                            FROM User_Master__c WHERE id = : uid limit 500]) {
                userEmail.add(userMasterRec.user__r.Email);
            }
            //system.debug('==================================>> UserEmails in getUserEmails'+userEmail);
            return (userEmail);
            
        } catch (Exception e) {
            //System.debug(e); 
            return null;
        }
    }
    
    /**
   *  @Description : This method is used get email of Tech Arch PMO group.
   *  @name : getEmailIdsFromTechArchGrp
   *  @param :null
   *  @return parameter - List of emails(string)
   */ 
    public static List<String> getEmailIdsFromTechArchGrp(){
        
        try{
                        
                //String lstGrpName = grpName;
                List<String> idList = new List<String>();
                List<String> mailToAddresses = new List<String>();                              
                
                List<Group> grp = [SELECT id,Email,(select userOrGroupId from groupMembers LIMIT 200) FROM group WHERE name =:(Label.Technical_Architect_PMO_Group) LIMIT 5000]; 
                //system.debug('==================================>> Group'+g.size());
            //system.debug('==================================>> Display Group'+g);
                for(integer i=0;i<grp.size();i++ )
                {
                    for (GroupMember gm : grp[i].groupMembers) {        
                        idList.add(gm.userOrGroupId);
                            
                    }    
                }
            
                //User[] usr = [SELECT id,email FROM user WHERE id IN :idList Limit 5000];    
                List<String> userIds = new List<String>();
                for(user usr: [SELECT id,email FROM user WHERE id IN :idList Limit 5000]){
                  userIds.add(usr.email); 
                  //system.debug('==================================>> Tech Arch Group User IDs'+userIds);
                }
                    
                return userIds; 
            }
            Catch(Exception e)
            {
                    //System.debug('E==='+e);
                    string sss=e.getMessage();
            }  
            
            return null;          
                        
        }
    
}