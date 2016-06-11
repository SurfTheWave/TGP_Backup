public class UserTriggerController {
    @future
    public static void insertUpdateApprovalUserMaster(List<Id> recordsIdList) {
        List<Review_User_Master__c> reviewUserMasterListToUpdate = new List<Review_User_Master__c>();
        List<Review_User_Master__c> reviewUserMasterListToInsert = new List<Review_User_Master__c>();
        Review_User_Master__c reviewUserMaster;
        map<String,Review_User_Master__c > approvalUserNameSfdcIdMap = new map<String,Review_User_Master__c>();
        for(Review_User_Master__c reviewUserMasterRecord : [select Id,UserName__c, SFDC_User__c,User_Type__c, Is_Active__c,IsUserActive__c,  Email_ID_of_the_reviewer__c  from Review_User_Master__c limit 5000]) {
            if(reviewUserMasterRecord.UserName__c != null) {
                approvalUserNameSfdcIdMap.put(reviewUserMasterRecord.UserName__c,reviewUserMasterRecord);
            }
        }
        For(User userRecord : [select Id, Name, isActive,User_Type__c,UserName, Email from User where Id IN :recordsIdList AND Profile.Name != 'System Administrator']) {
            reviewUserMaster = approvalUserNameSfdcIdMap.get(userRecord.UserName);
            if(reviewUserMaster != null) {        
                reviewUserMaster.SFDC_User__c= userRecord.Id;
                reviewUserMaster.IsUserActive__c = userRecord.IsActive;
                reviewUserMaster.UserName__c = userRecord.UserName;  
                reviewUserMaster.User_Type__c = userRecord.User_Type__c;
                reviewUserMasterListToUpdate.add(reviewUserMaster);
            }
            else {
                reviewUserMaster = new Review_User_Master__c();
                reviewUserMaster.SFDC_User__c= userRecord.Id;
                reviewUserMaster.Name = userRecord.Name;
                reviewUserMaster.UserName__c = userRecord.UserName;
                reviewUserMaster.User_Type__c = userRecord.User_Type__c;
                reviewUserMaster.IsUserActive__c = userRecord.IsActive;
                reviewUserMaster.Email_ID_of_the_reviewer__c =  userRecord.Email;
                reviewUserMaster.Is_Active__c = true;
                reviewUserMasterListToInsert.add(reviewUserMaster);            
            }
        }
        if (reviewUserMasterListToInsert.size() > 0 && !Test.isRunningTest()) {
            Insert reviewUserMasterListToInsert;
        }
        if(reviewUserMasterListToUpdate.size() > 0 && !Test.isRunningTest()) {
            update reviewUserMasterListToUpdate; 
        }
  }
  
  
  
  //After Update Event
  @future
  public static void updateApprovalUserMaster(List<Id> recordsIdList) {
      List<Review_User_Master__c> reviewUserMasterListToUpdate = new List<Review_User_Master__c>();
      map<String,Review_User_Master__c > approvalUserNameSfdcIdMap = new map<String,Review_User_Master__c>();
      Review_User_Master__c  reviewUserMaster;
      for(Review_User_Master__c reviewUserMasterRecord : [select Id,SFDC_User__c,Is_Active__c, UserName__c,IsUserActive__c,User_Type__c, Email_ID_of_the_reviewer__c  from Review_User_Master__c where SFDC_User__c IN :recordsIdList limit 5000]) {
            if(reviewUserMasterRecord.UserName__c != null) {
                approvalUserNameSfdcIdMap.put(reviewUserMasterRecord.UserName__c,reviewUserMasterRecord);
            }
      }
      
      For(User userRecord : [select Id, isActive,UserName, Email,User_Type__c from User where Id IN:recordsIdList AND userType =:'Standard']) {
          reviewUserMaster = approvalUserNameSfdcIdMap.get(userRecord.UserName);
          if(reviewUserMaster != null) {
              reviewUserMaster.Email_ID_of_the_reviewer__c = userRecord.Email; 
              reviewUserMaster.IsUserActive__c = userRecord.IsActive;  
              reviewUserMaster.UserName__c = userRecord.UserName;             
              reviewUserMaster.User_Type__c = userRecord.User_Type__c;
              reviewUserMasterListToUpdate.add(reviewUserMaster);
          }
      }
      
      if(reviewUserMasterListToUpdate.size() > 0) {
          update reviewUserMasterListToUpdate; 
      }
  }
}