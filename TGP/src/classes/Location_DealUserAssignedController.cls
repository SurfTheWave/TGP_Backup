/******************************
* @Description: MOB_DealUserAssignedController class to manage User Assignment in Mob   
*******************************/
public class Location_DealUserAssignedController
{
//  Need deal record from previous page
    public ApexPages.StandardController stdController {get; set;}
    
    public List<LocUserAssignWrapper> locUserAssignList{get; set;}
    
    public String strDealId {get; set;}
    public boolean isAddVisible{get; set;}
    public boolean isNA {get;set;} 
    public boolean isEdit {get;set;} 
    public boolean isError {get;set;}
    
    public String mobLead='Location Mobilization Lead';
    public String recLead='Recruitment Lead';
    

/******************************
Inner Class  Name: OpportunityDataWrapperDisplay
Description: 
Paramenters: NA
Return Value: NA
*******************************/ 
/* --------------------------------------------------------------------- */
public class LocUserAssignWrapper{
      public Id locationId{get;set;}
      public String location{get;set;}
      public String roleName{get;set;}
      
      public String primaryLead{get;set;}
      public String secLead1{get;set;}
      public String secLead2{get;set;}
      
      public MOB_User_Role_Assignment__c userRoleAssignment{get;set;}
}  
       
/******************************
* @Method Name: MOB_DealUserAssignedController
* @Description: This is Constructor for the MOB_DealUserAssignedController class  
* @Paramenters: ApexPages.StandardController
* @Return Value: NA
*******************************/
public Location_DealUserAssignedController(ApexPages.StandardController stdController)
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
    isAddVisible = UAMSolMobUtility.isAddVisible_MURAssign; ///Checked Later      
    if(UAMSolMobUtility.isNA_MURAssign)///checked later
    {
        isNA = false;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.NO_PRIVILEGE_PLEASE_CONTACT_YOUR_ADMINISTRATOR));
        return;
    }
    
    if(locUserAssignList.size()==0){
        isAddVisible=false;
    }
      
}

/******************************
* @Method Name: LoadData
* @Description: Load User Assignment Data in Grid  
* @Paramenters: NA
* @Return Value: NA
*******************************/
    public void LoadData() {
        List<Deal_TGP__c> dealList = [Select Id,Name from Deal_TGP__c where id=:strDealId];
        List<Wave_Plan_Version__c> dtlist=[Select Name,Active__c from Wave_Plan_Version__c where Deal__c=:dealList and Active__c=:true];
        
        List<Deal_Location__c> lstDealLocAssign = [select Id,Location_Name__c,  Deployment_Lead_New__c,Deployment_Lead_New__r.SFDC_User__r.Name,
                                                    Location_Mobilization_Lead_Secondary_New__c,Location_Mobilization_Lead_Secondary_New__r.SFDC_User__r.Name,
                                                    Location_Mobilization_Lead_Secondary_2__c, Location_Mobilization_Lead_Secondary_2__r.SFDC_User__r.Name,                                                     
                                                    Mob_Recruitment_Lead_Primary_New__c,Mob_Recruitment_Lead_Primary_New__r.SFDC_User__r.Name,
                                                    Mob_Recruitment_Lead_Secondary_New__c,Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__r.Name,
                                                    Mob_Recruitment_Lead_Secondary_New_2__c,Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__r.Name                                                    
                                                    from Deal_Location__c where Wave_Plan_Version__c =:dtlist order by Location_Name__c ];
                                                    
       locUserAssignList=new List<LocUserAssignWrapper>();                                             
                                                    
       for(Deal_Location__c itrObj:lstDealLocAssign){
           LocUserAssignWrapper locuserAssignWrapperFirst=new LocUserAssignWrapper();
           LocUserAssignWrapper locuserAssignWrapperSecond=new LocUserAssignWrapper();
           
           
           locuserAssignWrapperFirst.locationId=itrObj.Id;
           locuserAssignWrapperFirst.location=itrObj.Location_Name__c;
           locuserAssignWrapperFirst.roleName=mobLead;
           locuserAssignWrapperFirst.primaryLead=itrObj.Deployment_Lead_New__r.SFDC_User__r.Name;
           locuserAssignWrapperFirst.secLead1=itrObj.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__r.Name;
           locuserAssignWrapperFirst.secLead2=itrObj.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__r.Name;
           
           MOB_User_Role_Assignment__c tempObj=new MOB_User_Role_Assignment__c();
           
           tempObj.User_Assigned_New__c=itrObj.Deployment_Lead_New__c;
           tempObj.User_Assigned_Secondary_New__c=itrObj.Location_Mobilization_Lead_Secondary_New__c;
           tempObj.User_Assigned_Secondary_Lead__c=itrObj.Location_Mobilization_Lead_Secondary_2__c;
           
           locuserAssignWrapperFirst.userRoleAssignment=tempObj;
           
           locuserAssignWrapperSecond.locationId=itrObj.Id;
           locuserAssignWrapperSecond.location='';
           locuserAssignWrapperSecond.roleName=recLead;
           locuserAssignWrapperSecond.primaryLead=itrObj.Mob_Recruitment_Lead_Primary_New__r.SFDC_User__r.Name;
           locuserAssignWrapperSecond.secLead1=itrObj.Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__r.Name;
           locuserAssignWrapperSecond.secLead2=itrObj.Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__r.Name;
           
           
           tempObj=new MOB_User_Role_Assignment__c();
           
           tempObj.User_Assigned_New__c=itrObj.Mob_Recruitment_Lead_Primary_New__c;
           tempObj.User_Assigned_Secondary_New__c=itrObj.Mob_Recruitment_Lead_Secondary_New__c;
           tempObj.User_Assigned_Secondary_Lead__c=itrObj.Mob_Recruitment_Lead_Secondary_New_2__c;
           
           locuserAssignWrapperSecond.userRoleAssignment=tempObj;
           
           locUserAssignList.add(locuserAssignWrapperFirst);
           locUserAssignList.add(locuserAssignWrapperSecond);
       }                                                                                                                          
    }

/******************************
* @Method Name: save
* @Description: Save or Update  
* @Paramenters: NA
* @Return Value: NA
*******************************/
public void save()
{
   List<Deal_TGP__c> dealList = [Select Id,Name from Deal_TGP__c where id=:strDealId];
   List<Wave_Plan_Version__c> dtlist=[Select Name,Active__c from Wave_Plan_Version__c where Deal__c=:dealList and Active__c=:true];
        
   List<Deal_Location__c> lstDealLocAssignOld = [select Id,Location_Name__c,Deployment_Lead_New__c,
                                                                            Location_Mobilization_Lead_Secondary_New__c,
                                                                            Location_Mobilization_Lead_Secondary_2__c,                                                     
                                                                            Mob_Recruitment_Lead_Primary_New__c,
                                                                            Mob_Recruitment_Lead_Secondary_New__c,
                                                                            Mob_Recruitment_Lead_Secondary_New_2__c                                                    
                                                 from Deal_Location__c where Wave_Plan_Version__c =:dtlist order by Location_Name__c ];
   
   
   
   for(LocUserAssignWrapper itrObj : locUserAssignList) {
        if(itrObj.userRoleAssignment.User_Assigned_New__c != null && (itrObj.userRoleAssignment.User_Assigned_Secondary_New__c!= null || itrObj.userRoleAssignment.User_Assigned_Secondary_Lead__c!= null )) {
            if(itrObj.userRoleAssignment.User_Assigned_New__c == itrObj.userRoleAssignment.User_Assigned_Secondary_New__c) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.PRIMARY_AND_SECONDARY_USER_CAN_NOT_BE_SAME));
                isError = true;
                return;
            }
            else if(itrObj.userRoleAssignment.User_Assigned_New__c == itrObj.userRoleAssignment.User_Assigned_Secondary_Lead__c){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.PRIMARY_AND_SECONDARY_USER_CAN_NOT_BE_SAME));
                isError = true;
                return;
            }
            else if(itrObj.userRoleAssignment.User_Assigned_Secondary_New__c == itrObj.userRoleAssignment.User_Assigned_Secondary_Lead__c){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.SECONDARY_LEADS_CAN_NOT_BE_SAME));
                isError = true;
                return;
                }
        }
        else if(itrObj.userRoleAssignment.User_Assigned_Secondary_New__c!= null && itrObj.userRoleAssignment.User_Assigned_Secondary_Lead__c!= null )        
        {
             if(itrObj.userRoleAssignment.User_Assigned_Secondary_New__c == itrObj.userRoleAssignment.User_Assigned_Secondary_Lead__c){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.SECONDARY_LEADS_CAN_NOT_BE_SAME));
                isError = true;
                return;
                }         
        }
    }              
    try{
       for(Deal_Location__c dealLoc:lstDealLocAssignOld){
           for(LocUserAssignWrapper wrapObj:locUserAssignList){
               if(dealLoc.Id==wrapObj.locationId) {
                   if(wrapObj.roleName==mobLead){
                       dealLoc.Deployment_Lead_New__c=wrapObj.userRoleAssignment.User_Assigned_New__c;
                       dealLoc.Location_Mobilization_Lead_Secondary_New__c=wrapObj.userRoleAssignment.User_Assigned_Secondary_New__c;
                       dealLoc.Location_Mobilization_Lead_Secondary_2__c=wrapObj.userRoleAssignment.User_Assigned_Secondary_Lead__c;
                   }
                   if(wrapObj.roleName==recLead){
                       dealLoc.Mob_Recruitment_Lead_Primary_New__c=wrapObj.userRoleAssignment.User_Assigned_New__c;
                       dealLoc.Mob_Recruitment_Lead_Secondary_New__c=wrapObj.userRoleAssignment.User_Assigned_Secondary_New__c;
                       dealLoc.Mob_Recruitment_Lead_Secondary_New_2__c=wrapObj.userRoleAssignment.User_Assigned_Secondary_Lead__c;
                   }
               }       
           }
       }
       database.update(lstDealLocAssignOld);
    }catch(Exception e){
          //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
          isError = true;
          return;
    }
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.RECORD_UPDATED_SUCCESSFULLY));
    LoadData();
    isEdit=false;
}
/******************************
* @Method Name: cancel
* @Description: Invoked on Cancel button press.  
* @Paramenters: NA
* @Return Value: NA
*******************************/
public void cancel()
{
   LoadData();  
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