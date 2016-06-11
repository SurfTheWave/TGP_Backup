/*
Author : Sanjay Kumar Das.
Story  :  MOB_045 
Description : Display the list of Location and waves that are available for KT Plan.

Updated by        Story no                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
public with sharing class Mob_KTTrackingcontroller {

  public  List<Wave_Planning__c> wavePlanList{get;set;}
  public string waveId{get;set;}
  public String newid{get;set;}
  public string fileName{get;set;}
  public string Folder{get;set;}
  public string userProfileName {get;set;}
  public List<MOB_User_Role_Assignment__c> lstUserRoleAssign{get; set;}
 /******************************
    Method Name: Mob_KTTrackingcontroller 
    Description: This is Constructor for the Mob_KTTrackingcontroller class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/ 
    public Mob_KTTrackingcontroller(ApexPages.StandardController controller) 
    {
        newid=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);   
        String strId=UserInfo.getUserId();
        wavePlanList=new List<Wave_Planning__c>();
        userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name; 
        Set<String> waveLableName= new Set<String>();
        boolean isKTPlanWave=false;
        List <KT_Planning__c> ktActiveList=[Select id, Active__c, Activity__c,Deal_Location_lk__c,Planned_Start_Date__c,
                    Planned_End_Date__c, Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c,Is_From_Add_Section__c,
                    Location_Name_Wave_Name__c, Location_Id_Wave_Id__c, 
                    Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,comments__c,
                    isEditVisible__c  from KT_Planning__c where Wave_Plan_Version__c=:newid and active__c =:true];
         for(KT_Planning__c ktList : ktActiveList){
             waveLableName.add(ktList.Wave_Plan_lk__r.Wave_Label__c);
         }
        List <Wave_Plan_Version__c> WaveDealId=[SELECT  id,Deal_Id__c, Deal_Name__c FROM Wave_Plan_Version__c where id =:newid];
        lstUserRoleAssign = [select id,Access_Level__c,Deal__c,Mob_User_Roles_Master__c,Role_Name__c,User_Assigned_New__r.SFDC_User__c,User_Assigned_Secondary_New__r.SFDC_User__c 
                                        from MOB_User_Role_Assignment__c where Deal__c = :WaveDealId[0].Deal_Id__c];
        if(lstUserRoleAssign.size()>0){               
        for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign)
            {
                if(UTIL_Constants.PROGRAM_CONTROL_PMO.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c== UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c== UserInfo.getUserId()))
                {
                    isKTPlanWave=true;
                }
                if(UTIL_Constants.GLOBAL_MOBILIZATION_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c== UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c== UserInfo.getUserId()))
                {
                    isKTPlanWave=true; 
                }                
                if(UTIL_Constants.DEAL_PMO.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c== UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c== UserInfo.getUserId()))
                {
                    isKTPlanWave=true;
                }
            } 
        }                                                   
        if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN))
        {
            wavePlanList=[Select Id,Deal_Location__r.Wave_Plan_Version__r.deal__c,Deal_Location__r.Wave_Plan_Version__c,
                       Wave_Label__c, Location_Name__c,KT_Lead_New__r.SFDC_User__c,Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c,
                       Deal_Location__r.Deployment_Lead_New__r.SFDC_User__c,Deal_Location__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c 
                       from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__c=:newid and Wave_Label__c in : waveLableName];
        }
        else if(isKTPlanWave)
        {
        
            wavePlanList=[Select Id,Deal_Location__r.Wave_Plan_Version__r.deal__c,Deal_Location__r.Wave_Plan_Version__c,
                           Wave_Label__c, Location_Name__c,KT_Lead_New__r.SFDC_User__c,Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c,
                           Deal_Location__r.Deployment_Lead_New__r.SFDC_User__c,Deal_Location__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c 
                           from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__c=:newid and Wave_Label__c in : waveLableName and Deal_Location__r.NewActive__c=true];
                       
        }
        else
        {
            wavePlanList=[Select Id,Deal_Location__r.Wave_Plan_Version__r.deal__c,Deal_Location__r.Wave_Plan_Version__c,
                       Wave_Label__c, Location_Name__c,KT_Lead_New__r.SFDC_User__c,Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c,
                       Deal_Location__r.Deployment_Lead_New__r.SFDC_User__c,Deal_Location__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c 
                       from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__c=:newid and Wave_Label__c in : waveLableName and Deal_Location__r.NewActive__c=true and (KT_Lead_New__r.SFDC_User__c =:strId or Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c=:strId or Deal_Location__r.Deployment_Lead_New__r.SFDC_User__c=:strId 
                       or Deal_Location__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c=:strId )];
                       
        }
        if(wavePlanList.size()<=0)
        {
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No wave Plan Associated!'));    
        }

    }

    /******************************
    Method Name: goToKTTrack
    Description: This method is used to go on KTTrackerUpDown page
    Paramenters: NA
    Return Value: pageReference 
    *******************************/ 
    public pageReference goToKTTrack()
    {
        List<Wave_Planning__c> waveList=[Select id,Deal_Location__r.Wave_Plan_Version__r.deal__r.name, Deal_Location__r.Wave_Plan_Version__r.name, Location_Name__c, Wave_Label__c
                                        from Wave_Planning__c where id=:waveId];
        if(waveList.size()==1)
        {
             //fileName='KT Tracker_'+waveList[0].Deal_Location__r.Wave_Plan_Version__r.deal__r.name+'_'+waveList[0].Deal_Location__r.Wave_Plan_Version__r.name+'_'+waveList[0].Location_Name__c+'_'+waveList[0].Wave_Label__c+'_'+System.now().format('EEEE, MMMM d, yyyy - hh-mm-ss');   
              String dealName ='';
              String locationName='';
              String waveName='';               

              if(waveList[0].Deal_Location__r.Wave_Plan_Version__r.deal__r.name.length() > 41){
                  dealName= waveList[0].Deal_Location__r.Wave_Plan_Version__r.deal__r.name.substring(0, 40);
              }else{
                  dealName=waveList[0].Deal_Location__r.Wave_Plan_Version__r.deal__r.name;
              }
              
              if(waveList[0].Location_Name__c.length() > 31){
                  locationName= waveList[0].Location_Name__c.substring(0, 30);
              }else{
                  locationName= waveList[0].Location_Name__c;
              }
              
              if(waveList[0].Wave_Label__c.length() > 21){
                  waveName= waveList[0].Wave_Label__c.substring(0, 20); 
              }else{
                  waveName= waveList[0].Wave_Label__c;
              }
              
             String systemTime= DateTime.now().format('MM-dd-yyyy hh-mm-ss');            
             fileName='KT_'+dealName+'_'+locationName+'_'+waveName+'_'+systemTime;   

        }
        List<Tracking_KT__c> trackKT =[select id from Tracking_KT__c where Deal_Wave__c=:waveId];
        if(trackKT.size()==0)
        {
            Tracking_KT__c newTrackingKT =new  Tracking_KT__c ();
            newTrackingKT.Deal_Wave__c=waveId;
            newTrackingKT.Count__c=1;
            Folder= [select id from folder where name = 'KT Tracker'].id;
            List<Document> doc=[Select name, id, Body, Description,Type, IsPublic, FolderId, AuthorId from Document where FolderId=:Folder and name=:'KT Tracker-V1.2.1'];
            if(doc.size()==1)
            {
                Document newDocument = new Document();
                newDocument.name=fileName;
                newDocument.type=doc[0].Type;
                newDocument.Body=doc[0].Body;
                newDocument.Description=doc[0].Description;
                newDocument.IsPublic=doc[0].IsPublic;
                newDocument.AuthorId =doc[0].AuthorId ;
                newDocument.FolderId=doc[0].FolderId;
                try
                {
                    upsert newDocument;   
                    newTrackingKT.File_Name__c=newDocument.name;
                    upsert newTrackingKT;
                }
                catch (DMLException e)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in file download'+e));
                    return null;
                } 
                finally
                {
                    newDocument.name = fileName;
                    newDocument = new Document(); 
                }
            }
        } 
        PageReference pr=new PageReference('/apex/KTTrackerUpDown?id='+waveId);
                    pr.setRedirect(true);
                    return pr;
                    return null;
    }   
}