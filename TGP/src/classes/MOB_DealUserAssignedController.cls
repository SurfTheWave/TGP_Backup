/******************************
* @Description: MOB_DealUserAssignedController class to manage User Assignment in Mob   
*******************************/
public class MOB_DealUserAssignedController
{
//  Need deal record from previous page
    public ApexPages.StandardController stdController {get; set;}
    public List<MOB_User_Role_Assignment__c> lstUserRoleAssign{get; set;}
    public List<MOB_User_Role_Assignment__c> lstUserRoleAssignOld;
    public String strDealId {get; set;}
    public boolean isAddVisible{get; set;}
    public boolean isNA {get;set;} 
    public boolean isEdit {get;set;} 
    public boolean isError {get;set;}

       
/******************************
* @Method Name: MOB_DealUserAssignedController
* @Description: This is Constructor for the MOB_DealUserAssignedController class  
* @Paramenters: ApexPages.StandardController
* @Return Value: NA
*******************************/
public MOB_DealUserAssignedController(ApexPages.StandardController stdController)
{
    isNA=true;
    isEdit = false;
    isAddVisible=false;
    isError = false;
    this.stdController = stdController;
    Deal_TGP__c DealRec = (Deal_TGP__c)stdController.getRecord();
    strDealId = DealRec.id;
    LoadData();
    // For UAM
    isAddVisible = UAMSolMobUtility.isAddVisible_MURAssign;       
    if(UAMSolMobUtility.isNA_MURAssign)
    {
        isNA = false;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.NO_PRIVILEGE_PLEASE_CONTACT_YOUR_ADMINISTRATOR));
        return;
    }
      
}

/******************************
* @Method Name: LoadData
* @Description: Load User Assignment Data in Grid  
* @Paramenters: NA
* @Return Value: NA
*******************************/
    public void LoadData() {
        lstUserRoleAssign = [select Access_Level__c,Deal__c,Mob_User_Roles_Master__c, Role_Name__c,Mob_User_Roles_Master__r.OrderByName__c,
                            User_Assigned_New__c,User_Assigned_New__r.SFDC_User__c,User_Assigned_New__r.SFDC_User__r.name,User_Assigned_FF__c,
                            User_Assigned_Secondary_New__r.SFDC_User__r.name, User_Assigned_Secondary_New__c,User_Assigned_Secondary_New__r.SFDC_User__c,User_Assigned_Secondary_FF__c,
                            User_Assigned_Secondary_Lead__r.SFDC_User__r.name, User_Assigned_Secondary_Lead__c,User_Assigned_Secondary_Lead__r.SFDC_User__c,User_Assigned_Secondary_Lead_FF__c                            
                            from MOB_User_Role_Assignment__c where Deal__c = :strDealId order by Mob_User_Roles_Master__r.OrderByName__c limit 10];
    }

/******************************
* @Method Name: save
* @Description: Save or Update  
* @Paramenters: NA
* @Return Value: NA
*******************************/
public void save()
{
    lstUserRoleAssignOld = [select Access_Level__c,Deal__c,Mob_User_Roles_Master__c,Role_Name__c,
                            User_Assigned_New__r.SFDC_User__c ,User_Assigned_New__c,
                            User_Assigned_Secondary_New__r.SFDC_User__c,User_Assigned_Secondary_New__c,
                            User_Assigned_Secondary_Lead__c, User_Assigned_Secondary_Lead__r.SFDC_USER__c
                            from MOB_User_Role_Assignment__c  where Deal__c = :strDealId limit 10]; 

    List<deal_tgp__c> lstDeal =[select Program_Control_PMO_ID__c,Program_Control_PMO_Secondary_2_ID__c,Program_Control_PMO_Secondary_ID__c,
                                MOB_PMO_Project_ID__c, MOB_PMO_Project_Secondary_2_ID__c,MOB_PMO_Project_Secondary_ID__c,
                                Global_Mobilization_Lead__c, Global_Mobilization_Lead_Secondary__c, Global_Mobilization_Lead_Secondary_2__c,
                                Global_Mob_Lead_Secondary_2_ID__c,Global_Mob_Lead_ID__c,Global_Mob_Lead_Secondary_ID__c,
                                Governance_Lead_Name_New__c, Governance_Lead_Name_Secondary_New__c, Governance_Lead_Name_Secondary_New_2__c,
                                Governance_Lead_Name_New__r.SFDC_User__c, Governance_Lead_Name_Secondary_New__r.SFDC_USER__c, Governance_Lead_Name_Secondary_New_2__r.SFDC_USER__c                                 
                                from deal_tgp__c where id=:strDealId  ]; 
                                
        String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name;             
      
        for(MOB_User_Role_Assignment__c tmpRole : lstUserRoleAssign) {
        if(tmpRole.User_Assigned_New__c != null && (tmpRole.User_Assigned_Secondary_New__c!= null || tmpRole.User_Assigned_Secondary_Lead__c!= null )) {
            if(tmpRole.User_Assigned_New__c == tmpRole.User_Assigned_Secondary_New__c) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.PRIMARY_AND_SECONDARY_USER_CAN_NOT_BE_SAME));
                isError = true;
                return;
            }
            else if(tmpRole.User_Assigned_New__c == tmpRole.User_Assigned_Secondary_Lead__c){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.PRIMARY_AND_SECONDARY_USER_CAN_NOT_BE_SAME));
                isError = true;
                return;
            }
            else if(tmpRole.User_Assigned_Secondary_New__c == tmpRole.User_Assigned_Secondary_Lead__c){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.SECONDARY_LEADS_CAN_NOT_BE_SAME));
                isError = true;
                return;
                }
            else{}
                                   
        }
        else if(tmpRole.User_Assigned_Secondary_New__c!= null && tmpRole.User_Assigned_Secondary_Lead__c!= null )        
        {
             if(tmpRole.User_Assigned_Secondary_New__c == tmpRole.User_Assigned_Secondary_Lead__c){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.SECONDARY_LEADS_CAN_NOT_BE_SAME));
                isError = true;
                return;
                }         
        }
        else{}
                                         
   }              
    for(MOB_User_Role_Assignment__c tmpRole : lstUserRoleAssign)
    {
        if(UTIL_Constants.GOVERNANCE_LEAD.equalsIgnoreCase(tmpRole.Role_Name__c) && tmpRole.User_Assigned_New__c ==null )
        {    
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.PRIMARY_GOVERNANCE_LEAD_IS_MANDATORY));
            LoadData();
            isError = true;
            return;
        }
        else if(UTIL_Constants.GOVERNANCE_LEAD.equalsIgnoreCase(tmpRole.Role_Name__c) && lstDeal.size()>0 && lstDeal.get(0).Governance_Lead_Name_New__c!= tmpRole.User_Assigned_New__c && (!userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN)))
        {    
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.PRIMARY_GOVERNANCE_LEAD_CAN_NOT_BE_CHANGED));
            LoadData();
            isError = true;
            return;
        }
        else{}
    }
     try
     {
         database.upsert(lstUserRoleAssign);
     }
     catch(Exception e)
     {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
          isError = true;
          return;
     }
     LoadData();
    for(MOB_User_Role_Assignment__c tmpRole : lstUserRoleAssign)
    {
        if(Util_constants.GLOBAL_MOBILIZATION_LEAD.equalsIgnoreCase(tmpRole.Role_Name__c))
        {
            lstDeal.get(0).Global_Mob_Lead_ID__c = tmpRole.User_Assigned_New__r.SFDC_User__c;
            lstDeal.get(0).Global_Mob_Lead_Secondary_ID__c  = tmpRole.User_Assigned_Secondary_New__r.SFDC_User__c;
            lstDeal.get(0).Global_Mob_Lead_Secondary_2_ID__c  = tmpRole.User_Assigned_Secondary_Lead__r.SFDC_User__c;
            
            System.debug('*************MUKESH ******************' +tmpRole.User_Assigned_New__r.SFDC_User__c);

            if(tmpRole.User_Assigned_New__r.SFDC_User__c !=null)
            {
                lstDeal.get(0).Global_Mob_Lead_ID__c = String.valueOf(tmpRole.User_Assigned_New__r.SFDC_User__c).substring(0,15);
                lstDeal.get(0).Global_Mobilization_Lead__c = tmpRole.User_Assigned_New__r.SFDC_User__r.name;
            }
            else{
                 lstDeal.get(0).Global_Mob_Lead_ID__c = UTIL_Constants.EMPTY_STRING;
                 lstDeal.get(0).Global_Mobilization_Lead__c = UTIL_Constants.EMPTY_STRING;   
            }    
            if(tmpRole.User_Assigned_Secondary_New__r.SFDC_User__c !=null) {
                lstDeal.get(0).Global_Mob_Lead_Secondary_ID__c  = String.valueOf(tmpRole.User_Assigned_Secondary_New__r.SFDC_User__c).substring(0,15);
                lstDeal.get(0).Global_Mobilization_Lead_Secondary__c = tmpRole.User_Assigned_Secondary_New__r.SFDC_User__r.name;
            }
            else{ 
                lstDeal.get(0).Global_Mob_Lead_Secondary_ID__c  = UTIL_Constants.EMPTY_STRING;
                lstDeal.get(0).Global_Mobilization_Lead_Secondary__c = UTIL_Constants.EMPTY_STRING;
            }
            if(tmpRole.User_Assigned_Secondary_Lead__r.SFDC_User__c !=null) {
                lstDeal.get(0).Global_Mob_Lead_Secondary_2_ID__c  = String.valueOf(tmpRole.User_Assigned_Secondary_Lead__r.SFDC_User__c).substring(0,15);
                lstDeal.get(0).Global_Mobilization_Lead_Secondary_2__c = tmpRole.User_Assigned_Secondary_Lead__r.SFDC_User__r.name;
            }
            else{ 
                lstDeal.get(0).Global_Mob_Lead_Secondary_2_ID__c  = UTIL_Constants.EMPTY_STRING;
                lstDeal.get(0).Global_Mobilization_Lead_Secondary_2__c = UTIL_Constants.EMPTY_STRING;
            }            
        }
        else if(UTIL_Constants.DEAL_PMO.equalsIgnoreCase(tmpRole.Role_Name__c))
        {
            lstDeal.get(0).MOB_PMO_Project_ID__c = tmpRole.User_Assigned_New__r.SFDC_User__c;
            lstDeal.get(0).MOB_PMO_Project_Secondary_ID__c = tmpRole.User_Assigned_Secondary_New__r.SFDC_User__c;
            lstDeal.get(0).MOB_PMO_Project_Secondary_2_ID__c = tmpRole.User_Assigned_Secondary_Lead__r.SFDC_User__c;

            if(tmpRole.User_Assigned_New__r.SFDC_User__c !=null) {
                lstDeal.get(0).MOB_PMO_Project_ID__c = String.valueOf(tmpRole.User_Assigned_New__r.SFDC_User__c).substring(0,15);
            }
           else {
                  lstDeal.get(0).MOB_PMO_Project_ID__c = UTIL_Constants.EMPTY_STRING;
            }
            if(tmpRole.User_Assigned_Secondary_New__r.SFDC_User__c !=null) {
                lstDeal.get(0).MOB_PMO_Project_Secondary_ID__c = String.valueOf(tmpRole.User_Assigned_Secondary_New__r.SFDC_User__c).substring(0,15);
            }
            else {
                lstDeal.get(0).MOB_PMO_Project_Secondary_ID__c =UTIL_Constants.EMPTY_STRING;
            }
       
        if(tmpRole.User_Assigned_Secondary_Lead__r.SFDC_User__c !=null) {
                lstDeal.get(0).MOB_PMO_Project_Secondary_2_ID__c = String.valueOf(tmpRole.User_Assigned_Secondary_Lead__r.SFDC_User__c).substring(0,15);
            }
            else {
                lstDeal.get(0).MOB_PMO_Project_Secondary_2_ID__c = UTIL_Constants.EMPTY_STRING;
            }
            
        }
        else if(UTIL_Constants.PROGRAM_CONTROL_PMO.equalsIgnoreCase(tmpRole.Role_Name__c))
        {
            lstDeal.get(0).Program_Control_PMO_ID__c = tmpRole.User_Assigned_New__r.SFDC_User__c;
            lstDeal.get(0).Program_Control_PMO_Secondary_ID__c = tmpRole.User_Assigned_Secondary_New__r.SFDC_User__c;
            lstDeal.get(0).Program_Control_PMO_Secondary_2_ID__c = tmpRole.User_Assigned_Secondary_Lead__r.SFDC_User__c;

            if(tmpRole.User_Assigned_New__r.SFDC_User__c !=null) {
                lstDeal.get(0).Program_Control_PMO_ID__c = String.valueOf(tmpRole.User_Assigned_New__r.SFDC_User__c).substring(0,15);
            }
            else {
                lstDeal.get(0).Program_Control_PMO_ID__c = UTIL_Constants.EMPTY_STRING;
            }
            if(tmpRole.User_Assigned_Secondary_New__r.SFDC_User__c !=null) {
                lstDeal.get(0).Program_Control_PMO_Secondary_ID__c = String.valueOf(tmpRole.User_Assigned_Secondary_New__r.SFDC_User__c).substring(0,15);
            }
            else {
                lstDeal.get(0).Program_Control_PMO_Secondary_ID__c = UTIL_Constants.EMPTY_STRING;
            }
            if(tmpRole.User_Assigned_Secondary_Lead__r.SFDC_User__c !=null) {
                lstDeal.get(0).Program_Control_PMO_Secondary_2_ID__c = String.valueOf(tmpRole.User_Assigned_Secondary_Lead__r.SFDC_User__c).substring(0,15);
            }
            else {
                lstDeal.get(0).Program_Control_PMO_Secondary_2_ID__c = UTIL_Constants.EMPTY_STRING;
            }

        }
        
         else if(UTIL_Constants.GOVERNANCE_LEAD.equalsIgnoreCase(tmpRole.Role_Name__c))
        {
            if(tmpRole.User_Assigned_New__r.SFDC_User__c !=null) {
                lstDeal.get(0).Governance_Lead_Name_New__c = String.valueOf(tmpRole.User_Assigned_New__c).substring(0,15);
            }
            
            if(tmpRole.User_Assigned_Secondary_New__r.SFDC_User__c !=null) {
                lstDeal.get(0).Governance_Lead_Name_Secondary_New__c = String.valueOf(tmpRole.User_Assigned_Secondary_New__c).substring(0,15);
            }
            else if(tmpRole.User_Assigned_Secondary_New__r.SFDC_User__c == null) {
                lstDeal.get(0).Governance_Lead_Name_Secondary_New__c = null;
            }
            else{}
            
            if(tmpRole.User_Assigned_Secondary_Lead__r.SFDC_User__c !=null) {
                lstDeal.get(0).Governance_Lead_Name_Secondary_New_2__c = String.valueOf(tmpRole.User_Assigned_Secondary_Lead__c).substring(0,15);
            }
            else if(tmpRole.User_Assigned_Secondary_Lead__r.SFDC_User__c == null) {
                lstDeal.get(0).Governance_Lead_Name_Secondary_New_2__c = null;
            }
            else{}

        }
         else{}
        
    }
    
    try
    {
        database.update(lstDeal);
    }        
    catch(Exception e)
    {
      //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
      isError = true;
      return;
    }
    isEdit=false;

    UserAccessUtility userAccess = new UserAccessUtility ();
    userAccess.CheckAccessDealDelete(strDealId, lstUserRoleAssignOld);
    userAccess.CheckAccessDeal(strDealId, lstUserRoleAssign );      
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.RECORD_UPDATED_SUCCESSFULLY));     
    //LoadData();    

}
/******************************
* @Method Name: cancel
* @Description: Invoked on Cancel button press.  
* @Paramenters: NA
* @Return Value: NA
*******************************/
public void cancel()
{
    lstUserRoleAssign= [select Access_Level__c,Deal__c,Mob_User_Roles_Master__c,Role_Name__c,
                            User_Assigned_New__r.SFDC_User__c,User_Assigned_FF__c,User_Assigned_Secondary_New__r.SFDC_User__c,User_Assigned_Secondary_FF__c, User_Assigned_Secondary_Lead_FF__c,User_Assigned_Secondary_Lead__r.SFDC_User__c
                            from MOB_User_Role_Assignment__c where Deal__c = :strDealId order by Mob_User_Roles_Master__r.OrderByName__c ]; 
   isEdit=false;
}
/******************************
* @Method Name: refreshPage
* @Description: refresh the Page  
* @Paramenters: NA
* @Return Value: NA
*******************************/
public void refreshPage()
{
}
/******************************
* @Method Name: edit
* @Description: Edit Record  
* @Paramenters: NA
* @Return Value: NA
*******************************/
public void edit()
{
    isEdit=true;
}


}