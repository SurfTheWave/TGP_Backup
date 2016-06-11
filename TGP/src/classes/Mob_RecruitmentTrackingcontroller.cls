/*
Author : Varsha Chougule.
Story  :  MOB_146 
Description : Display the list of waves that are available for tracking recruitment.

Updated by        Story no                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
public with sharing class Mob_RecruitmentTrackingcontroller {

  public Deal_Location__c[] strDealLocationList{get;set;}
  public string locationId{get;set;}
  public string fileName{get;set;}
  public string Folder{get;set;}
  public boolean isPresent{get;set;}
  public string wavePlanVersionId{get;set;}
  public string userProfileName {get;set;}
  public List<MOB_User_Role_Assignment__c> lstUserRoleAssign{get; set;}
  
    /******************************
    Method Name: Mob_RecruitmentTrackingcontroller 
    Description: This is Constructor for the Mob_RecruitmentTrackingcontroller class  
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public Mob_RecruitmentTrackingcontroller()
    {
        wavePlanVersionId=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);
        strDealLocationList= new Deal_Location__c[]{};        
        Set<String> waveLableName= new Set<String>();
        boolean isRTPlanWave=false;
        
        List<Recruitment_Tracking__c> RTActiveList=[Select id,Wave_Plan_Version__r.active__c,Wave_Plan_Version__r.Display_tracking_message__c,Wave_Plan_Version__c,
                                        FTE_Number__c,Active__c,Activity__c,Deal_Location_lk__c,Planned_Start_Date__c, Planned_End_Date__c, 
                                        Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c, 
                                        Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,comments__C,isEditVisible__c  
                                       from Recruitment_Tracking__c where Wave_Plan_Version__c=:wavePlanVersionId and Active__c=true];
        
        for(Recruitment_Tracking__c rtList : RTActiveList){
             waveLableName.add(rtList.Wave_Plan_lk__r.Wave_Label__c);
         }
        //List of Locations.
        List<Deal_Location__c> dealLocationList=[Select id, Wave_Plan_Version__r.deal__c, Wave_Plan_Version__c,Location_Name__c,Wave_Plan_Version__r.deal__r.name,
                                  Wave_Plan_Version__r.name,Location__c, Deployment_Lead_New__r.SFDC_User__c,
                                  Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c  from Deal_Location__c 
                                  where Wave_Plan_Version__r.Display_tracking_message__c=:UTIL_Constants.TRACKING_IS_ON 
                                  and Wave_Plan_Version__c=:wavePlanVersionId and NewActive__c=true order by createddate desc];  
        List<Wave_Planning__c> wavePlanningList=[Select id,Deal_Location__c,Mobilization_Recruitment_Lead_Primary__c,Mobilization_Recruitment_Lead_Secondary__c  from Wave_Planning__c where Wave_Label__c in : waveLableName];  
        userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name;    
        
        List <Wave_Plan_Version__c> WaveDealId=[SELECT  id,Deal_Id__c, Deal_Name__c FROM Wave_Plan_Version__c where id =:wavePlanVersionId];
        lstUserRoleAssign = [select id,Access_Level__c,Deal__c,Mob_User_Roles_Master__c,Role_Name__c,User_Assigned_New__r.SFDC_User__c,User_Assigned_Secondary_New__r.SFDC_User__c 
                                        from MOB_User_Role_Assignment__c where Deal__c = :WaveDealId[0].Deal_Id__c];
        if(lstUserRoleAssign.size()>0){               
        for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign)
            {
                if(UTIL_Constants.PROGRAM_CONTROL_PMO.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c== UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c== UserInfo.getUserId()))
                {
                    isRTPlanWave=true;
                }
                if(UTIL_Constants.GLOBAL_MOBILIZATION_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c== UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c== UserInfo.getUserId()))
                {
                    isRTPlanWave=true;
                }                
                if(UTIL_Constants.DEAL_PMO.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c== UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c== UserInfo.getUserId()))
                {
                    isRTPlanWave=true;
                }
            } 
        }
        
        if(dealLocationList!=null && RTActiveList.size()>0)
        {
            for(Deal_Location__c locationList : dealLocationList)
            {
                if(wavePlanningList.size()>0)
                {
                    for(Wave_Planning__c waveList : wavePlanningList)
                    {
                        if(waveList.Deal_Location__c ==locationList.id)
                        {
                            if(locationList.Deployment_Lead_New__r.SFDC_User__c==UserInfo.getUserId() || 
                                locationList.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() || 
                                waveList.Mobilization_Recruitment_Lead_Primary__c ==UserInfo.getUserId() || 
                                waveList.Mobilization_Recruitment_Lead_Secondary__c  ==UserInfo.getUserId() || 
                                userProfileName.equalsIgnoreCase('System Administrator') || 
                                userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || 
                                userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || 
                                userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) || 
                                userProfileName.equalsIgnoreCase('Dev System Administrator'))
                            {
                                isPresent=false;
                                for(Deal_Location__c tempList : strDealLocationList)
                                {
                                    if(tempList.id==locationList.id)
                                    {
                                        isPresent=true;
                                    } 
                                } 
                                if(isPresent==false)
                                {
                                     strDealLocationList.add(locationList);   
                                     system.debug('------strDealLocationList--in inner if 103-------'+strDealLocationList);
                                }
                            }
                            else if(isRTPlanWave)
                            {
                                isPresent=false;
                                for(Deal_Location__c tempList : strDealLocationList)
                                {
                                    if(tempList.id==locationList.id)
                                    {
                                        isPresent=true;
                                    } 
                                } 
                                if(isPresent==false)
                                {
                                     strDealLocationList.add(locationList);   
                                     system.debug('------strDealLocationList--in inner if 103-------'+strDealLocationList);
                                }
                            }
                        } 
                    }
                }                
                else if(isRTPlanWave)
                {
                    strDealLocationList.add(locationList);               
                }else
                {
                    if(locationList.Deployment_Lead_New__r.SFDC_User__c==UserInfo.getUserId() || locationList.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c==UserInfo.getUserId() || userProfileName.equalsIgnoreCase('System Administrator') || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase('Dev System Administrator'))
                    {
                        strDealLocationList.add(locationList); 
                    }    
                }
            }
        } else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No wave Plan Associated!'));
        }  
    } 
    
     /******************************
    Method Name: goToRecTrack
    Description: This method is used to go on RecruitmentTrackerUpDownLoad page
    Paramenters: NA
    Return Value: pageReference 
    *******************************/ 
    public pageReference goToRecTrack()
    {

        List<Deal_Location__c> locList=[Select id, Wave_Plan_Version__r.deal__c, Wave_Plan_Version__c,Location_Name__c,Wave_Plan_Version__r.deal__r.name,
                                  Wave_Plan_Version__r.name,
                                 Deployment_Lead_New__r.SFDC_User__c,Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c  from Deal_Location__c where id=:locationId ];
        if(locList.size()==1)
        {
            String dealName =UTIL_Constants.EMPTY_STRING;
            String locationName=UTIL_Constants.EMPTY_STRING;
            String wavePlanVersion=UTIL_Constants.EMPTY_STRING;
            
            if(locList[0].Wave_Plan_Version__r.deal__r.name.length() > 41){
              dealName= locList[0].Wave_Plan_Version__r.deal__r.name.substring(0, 40);     
            }else{
              dealName= locList[0].Wave_Plan_Version__r.deal__r.name;     
            }
            
            if(locList[0].Wave_Plan_Version__r.name.length() > 31){
              wavePlanVersion= locList[0].Wave_Plan_Version__r.name.substring(0, 30); 
            }else{
              wavePlanVersion= locList[0].Wave_Plan_Version__r.name;
            }
            
            if(locList[0].Location_Name__c.length() > 21){
              locationName= locList[0].Location_Name__c.substring(0, 20);
            }else{
              locationName= locList[0].Location_Name__c;
            }
                        
            String systemTime= DateTime.now().format('MM-dd-yyyy hh-mm-ss');
            fileName='RT_'+dealName+'_'+wavePlanVersion+'_'+locationName+'_'+systemTime;   
        }
        List<Tracking_Recruitment__c> trackRec =[select id from Tracking_Recruitment__c where Deal_Location__c=:locationId];
        if(trackRec.size()==0)
        {
            Tracking_Recruitment__c newTrackingRec =new  Tracking_Recruitment__c();
            newTrackingRec.Deal_Location__c=locationId;
            newTrackingRec.Count__c=1;
            Folder= [select id from folder where name = 'Recruitment Tracker'].id;
            List<Document> doc=[Select name, id, Body, Description,Type, IsPublic, FolderId, AuthorId from Document where FolderId=:Folder and name=:'Recruitment Tracker Fields Sequence V0 2'];
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
                    newTrackingRec.File_Name__c=newDocument.name;
                    upsert newTrackingRec;
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
        PageReference pr=new PageReference('/apex/RecruitmentTrackerUpDownLoad?id='+locationId);
                    pr.setRedirect(true);
                    return pr;
                    return null;
    }  
}