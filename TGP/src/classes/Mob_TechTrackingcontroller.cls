/*
Author : Varsha Chougule.
Story  :  MOB_146 
Description : Display the list of waves that are available for tracking recruitment.

Updated by        Story no                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
public with sharing class Mob_TechTrackingcontroller {

    public Wave_Planning__c[] strwaveplanList{get;set;}
    public Wave_Planning__c[] wavePlanningList{get;set;}
    public string waveId{get;set;}
    public string fileName{get;set;}
    public string Folder{get;set;}
    public boolean isPresent{get;set;}
    public string wpvid{get;set;}
    public string userProfileName {get;set;}
    public List<MOB_User_Role_Assignment__c> lstUserRoleAssign{get; set;}
    
  
    /******************************
    Method Name: Mob_TechTrackingcontroller 
    Description: This is Constructor for the Mob_TechTrackingcontroller class  
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public Mob_TechTrackingcontroller ()
    {
        wpvid=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);
        strwaveplanList= new Wave_Planning__c[]{};
        boolean isTAPlanWave=false;
        userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name;                    
        
        Set<String> waveLableName= new Set<String>();
        List<Tech_Assessment__c> taActiveList=[Select id, Active__c, Activity__c,Deal_Location_lk__c,Planned_Start_Date__c,Planned_End_Date__c, 
                                                Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,
                                                Comments__c,isEditVisible__c,Is_From_Add_Section__c,Location_Id_Wave_Id__c,Location_Name_Wave_Name__c,
                                                Milestone__c  from Tech_Assessment__c where Wave_Plan_Version__c=:wpvid];   
         for(Tech_Assessment__c taList : taActiveList){
             waveLableName.add(taList.Wave_Plan_lk__r.Wave_Label__c);
         }                                       
                                                
        List<Wave_Planning__c> wavePlanningList=[Select id,Deal_Location__r.Wave_Plan_Version__r.deal__c, Deal_Location__r.Wave_Plan_Version__c, 
                                                Location_Name__c, Wave_Label__c,Deal_Location__r.id,
                                                Deal_Location__r.Deployment_Lead_New__r.SFDC_User__c, Deal_Location__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c,
                                                Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c,Mob_Technology_Lead_Secondary_New__r.SFDC_User__c
                                                from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__r.Display_tracking_message__c=:UTIL_Constants.TRACKING_IS_ON and Deal_Location__r.Wave_Plan_Version__c=:wpvid and Wave_Label__c in : waveLableName and Deal_Location__r.NewActive__c=true and NewActive__c=true];  
        
        List <Wave_Plan_Version__c> WaveDealId=[SELECT  id,Deal_Id__c, Deal_Name__c FROM Wave_Plan_Version__c where id =:wpvid];
        lstUserRoleAssign = [select id,Access_Level__c,Deal__c,Mob_User_Roles_Master__c,Role_Name__c,User_Assigned_New__r.SFDC_User__c,User_Assigned_Secondary_New__r.SFDC_User__c 
                                        from MOB_User_Role_Assignment__c where Deal__c = :WaveDealId[0].Deal_Id__c];
        if(lstUserRoleAssign.size()>0){               
        for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign)
            {
                if(UTIL_Constants.PROGRAM_CONTROL_PMO.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c== UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c== UserInfo.getUserId()))
                {                
                    isTAPlanWave=true;
                }
                if(UTIL_Constants.GLOBAL_MOBILIZATION_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c== UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c== UserInfo.getUserId()))
                {
                    isTAPlanWave=true;
                }                
                if(UTIL_Constants.DEAL_PMO.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c== UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c== UserInfo.getUserId()))
                {
                    isTAPlanWave=true;
                }
            } 
        }
        
        if(wavePlanningList.size()>0)
        {
            for(Wave_Planning__c waveList : wavePlanningList)
            {
                if(waveList.Deal_Location__r.Deployment_Lead_New__r.SFDC_User__c==UserInfo.getUserId() 
                || waveList.Deal_Location__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() 
                || waveList.Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c ==UserInfo.getUserId() 
                || waveList.Mob_Technology_Lead_Secondary_New__r.SFDC_User__c  ==UserInfo.getUserId() 
                || userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) 
                || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) 
                || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP)
                || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)
                || userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN))
                {                
                    strwaveplanList.add(waveList);   
                }else if(isTAPlanWave=true)
                {
                  strwaveplanList.add(waveList);        
                }
            }
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No wave Plan Associated!'));
        }
        
    }
                            
     /******************************
    Method Name: goToTechTrack
    Description: This method is used to go on TechAssessmentUpDown page
    Paramenters: NA
    Return Value: pageReference 
    *******************************/ 
    public pageReference goToTechTrack()
    {
        List<Wave_Planning__c> waveList=[Select id,Deal_Location__r.Wave_Plan_Version__r.deal__r.name, Deal_Location__r.Wave_Plan_Version__r.name, Location_Name__c, Wave_Label__c
                                        from Wave_Planning__c where id=:waveId and NewActive__c = true];
        if(waveList.size()==1)
        {
             String dealName =UTIL_Constants.EMPTY_STRING;
             String locationName=UTIL_Constants.EMPTY_STRING;
             String waveName=UTIL_Constants.EMPTY_STRING;
             
             if(waveList[0].Deal_Location__r.Wave_Plan_Version__r.deal__r.name.length() > 41){
                  dealName= waveList[0].Deal_Location__r.Wave_Plan_Version__r.deal__r.name.substring(0, 40);
              }else{
                  dealName= waveList[0].Deal_Location__r.Wave_Plan_Version__r.deal__r.name; 
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
             fileName='TWE_'+dealName+'_'+locationName+'_'+waveName+'_'+systemTime;   
        }
        List<Tracking_Tech_Assessment__c> trackTech =[select id from Tracking_Tech_Assessment__c where Deal_Wave__c=:waveId];
        if(trackTech.size()==0)
        {
            Tracking_Tech_Assessment__c newTrackingTech =new  Tracking_Tech_Assessment__c ();
            newTrackingTech.Deal_Wave__c=waveId;
            newTrackingTech.Count__c=1;
            Folder= [select id from folder where name = 'Tech Assessment Tracker'].id;
            List<Document> doc=[Select name, id, Body, Description,Type, IsPublic, FolderId, AuthorId from Document where FolderId=:Folder and name=:'Tech Assessment Tracker V1.0'];
            if(doc.size()==1)
            {
                Document newDocument = new Document();
                newDocument .name=fileName;
                newDocument .type=doc[0].Type;
                newDocument .Body=doc[0].Body;
                newDocument .Description=doc[0].Description;
                newDocument .IsPublic=doc[0].IsPublic;
                newDocument .AuthorId =doc[0].AuthorId ;
                newDocument .FolderId=doc[0].FolderId;
                try
                {
                    upsert newDocument;   
                    newTrackingTech.File_Name__c=newDocument.name;
                    upsert newTrackingTech;
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
        PageReference pr=new PageReference('/apex/TechAssessmentUpDown?id='+waveId);
                    pr.setRedirect(true);
                    return pr;
                    return null;
    }  
}