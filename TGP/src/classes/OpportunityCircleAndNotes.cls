Global Class OpportunityCircleAndNotes {


    webservice static String requestOppCircle(Id oppid){
    List<String> lstOfCCUsersEmailId = new List<String>(); 
    Set<id> usersId=new Set<id>(); 
    String orgWideEmailAddressID=UtilEmail.emailid();
    List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    String MyProflieName = PROFILE[0].Name;
    String result='Not Applicable';
    Opportunity opp=[select id, service_grp__c from Opportunity where id=:oppid];
    String ServiceGroup=opp.service_grp__c;
    
    for(Opportunity_teams__c oppTeams:[select id,opportunity_team_member__r.user__c from Opportunity_teams__c where opportunity__c=:oppid]){
    usersId.add(oppTeams.opportunity_team_member__r.user__c);
    }
    
        
    if(ServiceGroup!='IO' && ServiceGroup!='IC' && ServiceGroup!='IO + IC'){
    result='Insufficient Privileges';   
    if(MyProflieName=='Solution Editor'  ||MyProflieName=='System Administrator'  || MyProflieName=='Solution Operations'){    
    result='False';
    if(MyProflieName!='Solution Editor')
    {
    result='True'; 
    }else
    {if(MyProflieName=='Solution Editor' && usersId.contains(Userinfo.getuserid()) )
    {  
    result='True'; 
    }
    }
    }
    }
    
    IF(result=='True'){
    Email_Template__c template=Email_Template__c.getValues(UtilConstantsforSWB.NEW_OPPORTUNITY_CIRCLE_REQ);
                id templateId = template.ID__c;
    
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    List<String> CCemail=new List<String>(); 
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    Id CCgroupid=[Select Id from Group where name='Opportunity Circle' limit 1].id;
                              
                for(GroupMember member:[Select UserOrGroupId From GroupMember where GroupId =:CCgroupid limit 10]){
                          String id=member.UserOrGroupId;
                          CCemail.add(id);   
                          system.debug('>>>>>>>>>>>>>CCusers'+CCemail);
                } 
     for(User usr:[select email, firstname,lastname from user where id in:CCemail limit 10]){
                         lstOfCCUsersEmailId.add(usr.email);
                         system.debug('>>>>>>>>>>>>>lstOfCCUsersEmailId'+lstOfCCUsersEmailId);
                }    
    List<String> sendTo = new List<String>();
   lstOfCCUsersEmailId.add('bpo_swb@accenture.com');
   
    mail.setToAddresses(lstOfCCUsersEmailId);
    //mail.setCCAddresses(lstOfCCUsersEmailId);
    mail.setTemplateID(templateId); 
    mail.setSaveAsActivity(false);
    mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
    mail.setTargetObjectId(Userinfo.getuserid());  
    mail.setWhatId(oppid);
    Messaging.sendEmail(new Messaging.SingleEmailMessage [] { mail}); 
    }
    
    
return result;
}

}