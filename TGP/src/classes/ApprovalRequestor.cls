public class ApprovalRequestor{
     String reqid{get;set;}
     String profileid{get;set;}
     String approverid{get;set;}
     public boolean bool{get;set;}
     List<Approval_request__c> reqlist{get;set;}
     public ApprovalRequestor(ApexPages.StandardController controller) {
     reqid=ApexPages.currentPage().getParameters().get('id');
     reqlist =[Select id, approver__c,requestor__r.email__c,approval_request_type__c from approval_request__c where id =:reqid];
     profileid=userInfo.getProfileId();
     approverid=UtilUser.UtilUser(reqlist[0].requestor__c);
     if(approverid.Equals(userinfo.getUserId())||(profileid.Equals('00eE0000000qNqQIAU'))){
      bool=true;
     }else{
     bool=false;
    }
    
    }
    
    public void sendReminder(){
                        //String reqid=ApexPages.currentPage().getParameters().get('id');
                        //List<Approval_request__c> reqlist =[Select id, approver__c,requestor__r.email__c,approval_request_type__c from approval_request__c where id =:reqid];
                        String approverid=UtilUser.UtilUser(reqlist[0].approver__c);
                        String orgWideEmailAddressID=UtilEmail.emailid();
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        List<String> CCAddresses = new List<String>();                   
                        CCAddresses.add(reqlist[0].requestor__r.email__c);
                        mail.setCcAddresses(CCAddresses);
                        mail.setTargetObjectId(approverid) ;
                        mail.setWhatId(reqid) ;
                        if((reqlist[0].approval_request_type__c.EqualsIgnoreCase('Final Approval'))){
                        mail.setTemplateId('00Xc0000000MZy5');
                        }
                        else{
                             mail.setTemplateId('00Xc0000000MZoj');
                        }  
                        mail.saveAsActivity=false;                      
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    
}