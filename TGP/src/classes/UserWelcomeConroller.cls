public without sharing class UserWelcomeConroller {
    public user currentuser{get;set;}
    public user userUpdate;
    public Boolean firstTimeLogin {get; set;}
    public void userLogin() {
        
        currentuser=new User();
        currentuser=[Select Id,Name,Email,First_Time_Login__c from User where Id=:userinfo.getuserId()];
        
       String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
        firstTimeLogin = false;
        if(currentuser.First_Time_Login__c && (usrProfileName.startsWithIgnoreCase('Mob') || usrProfileName == 'Workbench Read Only') ) {
            
            firstTimeLogin = true;
            userUpdate = new user(Id=currentuser.Id);
            userUpdate.First_Time_Login__c = false;
            update userUpdate;
        }
    }
}