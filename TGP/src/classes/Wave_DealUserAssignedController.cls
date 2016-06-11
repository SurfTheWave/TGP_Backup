/******************************
* @Description: MOB_DealUserAssignedController class to manage User Assignment in Mob   
*******************************/
public class Wave_DealUserAssignedController
{
//  Need deal record from previous page
    public ApexPages.StandardController stdController {get; set;}
    public List<WaveUserAssignWrapper> waveUserAssignList{get; set;}
    
    public String strDealId {get; set;}
    public boolean isAddVisible{get; set;}
    public boolean isNA {get;set;} 
    public boolean isEdit {get;set;} 
    public boolean isError {get;set;}
    
    public String ktLead='KT Lead';
    public String techLead='Technology Lead';
    public String opexAss='Opex Assessor';
    

/******************************
Inner Class  Name: OpportunityDataWrapperDisplay
Description: 
Paramenters: NA
Return Value: NA
*******************************/ 
/* --------------------------------------------------------------------- */
public class WaveUserAssignWrapper{
      public Id waveId{get;set;}
      public String location{get;set;}
      public String wave{get;set;}
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
public Wave_DealUserAssignedController(ApexPages.StandardController stdController)
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
    
    if(waveUserAssignList.size()==0){
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
        
        List<Deal_Location__c> locNodelist=[Select Wave_Plan_Version__r.Id,  Name,Deal_Home_Location__r.Delivery_Location_Master__r.Name,Wave_Plan_Version__c, 
                    Deployment_Lead_New__r.SFDC_User__r.Name, Location_Mobilization_Lead_Secondary_New__r.SFDC_User__r.Name,Location_Mobilization_Lead_Secondary_2__r.SFDC_User__r.Name, 
                    Mob_Recruitment_Lead_Primary_New__r.SFDC_User__r.Name, Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__r.Name, Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__r.Name, 
                    NewActive__c  from Deal_Location__c where Wave_Plan_Version__c =:dtlist];
        
        List<Wave_Planning__c> waveNodelist=[Select Id,Location_Name__c,Wave_Label__c, KT_Lead_New__r.SFDC_User__r.Name,KT_Lead_New__c, 
                                                                       Mobilization_KT_Lead_Secondary_New__r.SFDC_User__r.Name,Mobilization_KT_Lead_Secondary_New__c,
                                                                       Mobilization_KT_Lead_Secondary_2__r.SFDC_User__r.Name,Mobilization_KT_Lead_Secondary_2__c,
                                                                       Mobilization_Opex_Lead_Primary_New__r.SFDC_User__r.Name,Mobilization_Opex_Lead_Primary_New__c,
                                                                       Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__r.Name,Mobilization_Opex_Lead_Secondary_New__c, 
                                                                       Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__r.Name,Mobilization_Opex_Lead_Secondary_2__c,
                                                                       Mobilization_Technology_Lead_Primary_New__r.SFDC_User__r.Name,Mobilization_Technology_Lead_Primary_New__c,
                                                                       Mob_Technology_Lead_Secondary_New__r.SFDC_User__r.Name,Mob_Technology_Lead_Secondary_New__c,
                                                                       Mob_Technology_Lead_Secondary_2__r.SFDC_User__r.Name,Mob_Technology_Lead_Secondary_2__c
                                                     from Wave_Planning__c where Deal_Location__c =:locNodelist order by Location_Name__c,Wave_Label__c];
        
       
       waveUserAssignList=new List<WaveUserAssignWrapper>();                                             
                                                    
       //////String tempLocation='';
       for(Wave_Planning__c itrObj:waveNodelist){
           WaveUserAssignWrapper waveUserAssignWrapperFirst=new WaveUserAssignWrapper();
           WaveUserAssignWrapper waveUserAssignWrapperSecond=new WaveUserAssignWrapper();
           WaveUserAssignWrapper waveUserAssignWrapperThird=new WaveUserAssignWrapper();
           
           
           waveUserAssignWrapperFirst.waveId=itrObj.Id;
           waveUserAssignWrapperFirst.wave=itrObj.Wave_Label__c;
           
           waveUserAssignWrapperFirst.location=itrObj.Location_Name__c;
           
           /*if(tempLocation==''){
               waveUserAssignWrapperFirst.location=itrObj.Location_Name__c;
               tempLocation=itrObj.Location_Name__c;
           }else{
               tempLocation='';
           }*/
           
           waveUserAssignWrapperFirst.roleName=ktLead;
           waveUserAssignWrapperFirst.primaryLead=itrObj.KT_Lead_New__r.SFDC_User__r.Name;
           waveUserAssignWrapperFirst.secLead1=itrObj.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__r.Name;
           waveUserAssignWrapperFirst.secLead2=itrObj.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__r.Name;
           
           MOB_User_Role_Assignment__c tempObj=new MOB_User_Role_Assignment__c();
           
           tempObj.User_Assigned_New__c=itrObj.KT_Lead_New__c;
           tempObj.User_Assigned_Secondary_New__c=itrObj.Mobilization_KT_Lead_Secondary_New__c;
           tempObj.User_Assigned_Secondary_Lead__c=itrObj.Mobilization_KT_Lead_Secondary_2__c;
           
           waveUserAssignWrapperFirst.userRoleAssignment=tempObj;
           
           waveUserAssignWrapperSecond.waveId=itrObj.Id;
           waveUserAssignWrapperSecond.wave='';
           waveUserAssignWrapperSecond.location='';
           waveUserAssignWrapperSecond.roleName=techLead;
           
           waveUserAssignWrapperSecond.primaryLead=itrObj.Mobilization_Technology_Lead_Primary_New__r.SFDC_User__r.Name;
           waveUserAssignWrapperSecond.secLead1=itrObj.Mob_Technology_Lead_Secondary_New__r.SFDC_User__r.Name;
           waveUserAssignWrapperSecond.secLead2=itrObj.Mob_Technology_Lead_Secondary_2__r.SFDC_User__r.Name;
           
           
           tempObj=new MOB_User_Role_Assignment__c();
           
           tempObj.User_Assigned_New__c=itrObj.Mobilization_Technology_Lead_Primary_New__c;
           tempObj.User_Assigned_Secondary_New__c=itrObj.Mob_Technology_Lead_Secondary_New__c;
           tempObj.User_Assigned_Secondary_Lead__c=itrObj.Mob_Technology_Lead_Secondary_2__c;
           
           waveUserAssignWrapperSecond.userRoleAssignment=tempObj;
           
           waveUserAssignWrapperThird.waveId=itrObj.Id;
           waveUserAssignWrapperThird.wave='';
           waveUserAssignWrapperSecond.location='';
           waveUserAssignWrapperThird.roleName=opexAss;
           
           waveUserAssignWrapperThird.primaryLead=itrObj.Mobilization_Opex_Lead_Primary_New__r.SFDC_User__r.Name;
           waveUserAssignWrapperThird.secLead1=itrObj.Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__r.Name;
           waveUserAssignWrapperThird.secLead2=itrObj.Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__r.Name;
           
           
           tempObj=new MOB_User_Role_Assignment__c();
           
           tempObj.User_Assigned_New__c=itrObj.Mobilization_Opex_Lead_Primary_New__c;
           tempObj.User_Assigned_Secondary_New__c=itrObj.Mobilization_Opex_Lead_Secondary_New__c;
           tempObj.User_Assigned_Secondary_Lead__c=itrObj.Mobilization_Opex_Lead_Secondary_2__c;
           
           waveUserAssignWrapperThird.userRoleAssignment=tempObj;
           
           waveUserAssignList.add(waveUserAssignWrapperFirst);
           waveUserAssignList.add(waveUserAssignWrapperSecond);
           waveUserAssignList.add(waveUserAssignWrapperThird);
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
        
        List<Deal_Location__c> locNodelist=[Select Wave_Plan_Version__r.Id,  Name,Deal_Home_Location__r.Delivery_Location_Master__r.Name,Wave_Plan_Version__c, 
                    Deployment_Lead_New__r.SFDC_User__r.Name, Location_Mobilization_Lead_Secondary_New__r.SFDC_User__r.Name,Location_Mobilization_Lead_Secondary_2__r.SFDC_User__r.Name, 
                    Mob_Recruitment_Lead_Primary_New__r.SFDC_User__r.Name, Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__r.Name, Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__r.Name, 
                    NewActive__c  from Deal_Location__c where Wave_Plan_Version__c =:dtlist];
        
        List<Wave_Planning__c> waveNodelist=[Select Id, Wave_Label__c, KT_Lead_New__r.SFDC_User__r.Name,KT_Lead_New__c, 
                                                                       Mobilization_KT_Lead_Secondary_New__r.SFDC_User__r.Name,Mobilization_KT_Lead_Secondary_New__c,
                                                                       Mobilization_KT_Lead_Secondary_2__r.SFDC_User__r.Name,Mobilization_KT_Lead_Secondary_2__c,
                                                                       Mobilization_Opex_Lead_Primary_New__r.SFDC_User__r.Name,Mobilization_Opex_Lead_Primary_New__c,
                                                                       Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__r.Name,Mobilization_Opex_Lead_Secondary_New__c, 
                                                                       Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__r.Name,Mobilization_Opex_Lead_Secondary_2__c,
                                                                       Mobilization_Technology_Lead_Primary_New__r.SFDC_User__r.Name,Mobilization_Technology_Lead_Primary_New__c,
                                                                       Mob_Technology_Lead_Secondary_New__r.SFDC_User__r.Name,Mob_Technology_Lead_Secondary_New__c,
                                                                       Mob_Technology_Lead_Secondary_2__r.SFDC_User__r.Name,Mob_Technology_Lead_Secondary_2__c
                                                     from Wave_Planning__c where Deal_Location__c =:locNodelist order by Wave_Label__c];
   
   
   
   for(waveUserAssignWrapper itrObj : waveUserAssignList) {
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
       for(Wave_Planning__c dealLoc:waveNodelist){
           for(waveUserAssignWrapper wrapObj:waveUserAssignList){
               if(dealLoc.Id==wrapObj.waveId) {
                   if(wrapObj.roleName==ktLead){
                       dealLoc.KT_Lead_New__c=wrapObj.userRoleAssignment.User_Assigned_New__c;
                       dealLoc.Mobilization_KT_Lead_Secondary_New__c=wrapObj.userRoleAssignment.User_Assigned_Secondary_New__c;
                       dealLoc.Mobilization_KT_Lead_Secondary_2__c=wrapObj.userRoleAssignment.User_Assigned_Secondary_Lead__c;
                   }
                   if(wrapObj.roleName==techLead){
                       dealLoc.Mobilization_Technology_Lead_Primary_New__c=wrapObj.userRoleAssignment.User_Assigned_New__c;
                       dealLoc.Mob_Technology_Lead_Secondary_New__c=wrapObj.userRoleAssignment.User_Assigned_Secondary_New__c;
                       dealLoc.Mob_Technology_Lead_Secondary_2__c=wrapObj.userRoleAssignment.User_Assigned_Secondary_Lead__c;
                   }   
                   if(wrapObj.roleName==opexAss){
                   dealLoc.Mobilization_Opex_Lead_Primary_New__c=wrapObj.userRoleAssignment.User_Assigned_New__c;
                   dealLoc.Mobilization_Opex_Lead_Secondary_New__c=wrapObj.userRoleAssignment.User_Assigned_Secondary_New__c;
                   dealLoc.Mobilization_Opex_Lead_Secondary_2__c=wrapObj.userRoleAssignment.User_Assigned_Secondary_Lead__c;
                   }
               }       
           }
       }
       database.update(waveNodelist);
    }catch(Exception e){
        //  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Cannot select the User.User is Inactive in the User Master'));
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