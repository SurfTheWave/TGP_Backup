public class ReportCreationTabController {

    public String tabFocus { get; set; }

    public Integer Count { get; set; }
    public String selectedTab1{get;set;}
    public boolean mobLeadershipUser{get;set;}
    public List<PermissionSetAssignment> mobUserList {get; set;}

    public ReportCreationTabController() {
        selectedTab1=ApexPages.CurrentPage().getParameters().get('tab');
        mobUserList = [Select AssigneeId from PermissionSetAssignment Where PermissionSetId in 
                                                            (Select Id From PermissionSet where name = 'MobilizationLeadership_with_WorkbenchUser') and AssigneeId = : userInfo.getUserId()]; 
            
        if(mobUserList.size()>0) {
            mobLeadershipUser=true; 
        }
        List<userRole> role = [select id,name from userRole where id=:UserInfo.getUserRoleId()];        
        if(role.size()>0)
        {
            if(role[0].name!=null && role[0].name.equalsIgnoreCase('Mob Leadership'))
            {
               mobLeadershipUser=true;                            
            }
        }

        String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name; //Get users with Profile Name
       
        if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)) {
            mobLeadershipUser=true;
        }
        
        if(selectedTab1==null)
        {
            selectedTab1='tab1';
        }

    }
    
    /******************************
    Method Name: Page Refresh
    Description: Refresh ReportCreationTab
    Paramenters: NA
    Return Value: NA
    *******************************/  
   public PageReference functionF1()
    {
        PageReference pr=new PageReference('/apex/ReportCreationTab?tab=tab1');
        pr.setRedirect(true);
        return pr; 
    }
    public PageReference functionF2()
    {
        PageReference pr=new PageReference('/apex/ReportCreationTab?tab=tab2');
        pr.setRedirect(true);
        return pr; 
    }
 
    
    
}