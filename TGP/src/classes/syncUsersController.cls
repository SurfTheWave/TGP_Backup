public class syncUsersController {

public List<User> userListtoDisplay{get; set;}

public void syncUsers() {
    try {
        List<User> userListToUpdate = new List<User>();
        List<Review_User_Master__c> reviewUserMasterList =  [select isUserActive__c,Name,User_Type__c, SFDC_User__c, Email_ID_of_the_reviewer__c from Review_User_Master__c];
        Map<Id,User> idUserMap = new Map<Id,User>();
        User userRecord;
        For(User userRec : [select Id, isActive,Name, User_Type__c, Email from User where profile.Name != 'System Administrator']) {
            idUserMap.put(userRec.Id,userRec); 
        }
        for(Review_User_Master__c reviewUserMasterRecord : reviewUserMasterList ) {
           userRecord = new User();
           if(reviewUserMasterRecord.SFDC_User__c != null) {
               userRecord = idUserMap.get(reviewUserMasterRecord.SFDC_User__c);
               if(userRecord != null && reviewUserMasterRecord.isUserActive__c != userRecord.isActive) {
                    userRecord.isActive = reviewUserMasterRecord.isUserActive__c;
                    userRecord.User_Type__c = reviewUserMasterRecord.User_Type__c;
                    userListToUpdate.add(userRecord);
               }
           }
        }
        
        if(userListToUpdate.size() >0) {
            update userListToUpdate;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Records Synchronised Successfully'));
        }
        else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'No records to update'));
        }
            
        userListtoDisplay = userListToUpdate;
         
     }
     catch(Exception Exp) {
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Records Not Synchronised Successfully'));
     } 
 }
    
}