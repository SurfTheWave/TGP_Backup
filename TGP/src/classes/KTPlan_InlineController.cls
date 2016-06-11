/*
Author : Sanjay Kumar Das
Story  : Story-0137/MOB_121  
Description :  VF Page - KT Plan

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Varsha Chougule  MOB_131                  31-may-2013       Active inactive

*/
public without sharing class KTPlan_InlineController  
{
    public String wavePlanVersionId{get;set;}
    public String locationName{get;set;}
    public Integer col1{get;set;}
    public Integer col2{get;set;}
    public Integer col3{get;set;}
    public Integer Max_Activity_Order{get;set;}     
    public String WavePlanName{get;set;}
    //MOB_045 Start
    public String WavePlaningName{get;set;}
    //MOB_045 End
    public Boolean refreshPage {get; set;}
    public KT_Planning__c dealLocation {get;set;}
    public KT_Planning__c[] listOfLoactionDetailsActual {get;set;}
    public boolean isTableRendedered{get; set;}
    public String ProcessId{get;set;}
    public String buttonName{get;set;}
    public Boolean isDateEnabled {get; set;} 
    public String SectionTitle{get;set;}
    public String hiddenNavigator{get;set;}
    public String hiddenNavigator1{get;set;}
    public Boolean isWaveVersionActive{get; set;}
    public Boolean isActive{get; set;}
    public boolean isEditable{get; set;}    
    public String rerenderText{get;set;}
    Public Boolean showForm{get;set;}
    Public String displayStr{get;set;}
    public boolean isAddVisible{get; set;}
    public Boolean isTrackingOn{get; set;}
    public  List<Wave_Planning__c> wavePlanList{get;set;}
    public Boolean isValidUser{get; set;} 
    public boolean isRecordDeactivated{get;set;}
    public boolean valueOfActiveField{get;set;}
    public boolean isNA {get;set;}
    public boolean isEdit {get;set;} 
    public Boolean isDealTrackingOn{get; set;}    
    public List<SelectOption> lstLocationWave {get;set;}
    public String soqlQuery {get;set;}
    public List<KT_Planning__c> rTrackingPageSize {get;set;}

    public Boolean disablePrevious1{get; set;}
    public Boolean disableNext1{get; set;}
    public List<MOB_User_Role_Assignment__c> userList{get;set;}
    /******************************
    Method Name: KTPlan_InlineController
    Description: This is Constructor for the KTPlan_InlineController class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/  
    public KTPlan_InlineController (ApexPages.StandardController stdCon) {
        isNA=true;
        isEdit = false;          
        isEditable = true;
        isTrackingOn=false;
        dealLocation = new KT_Planning__c ();
        isTableRendedered = true;
        buttonName= UTIL_Constants.Add;
        // Getting Id of Wave Plan Version 
        
        wavePlanVersionId=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);
        List<Wave_Plan_Version__c> lstWave1 = [select Deal_Id__c, active__c, Display_tracking_message__c from Wave_Plan_Version__c where id=:wavePlanVersionId];
        userList=[select id, name, Role_Name__c, User_Assigned_New__c,User_Assigned_New__r.SFDC_User__c,
                             User_Assigned_Secondary_New__c,User_Assigned_Secondary_New__r.SFDC_User__c, 
                             User_Assigned_Secondary_Lead__c,User_Assigned_Secondary_Lead__r.SFDC_User__c
                             from MOB_User_Role_Assignment__c where Deal__c=:lstWave1[0].Deal_Id__c]; 
        if(lstWave1.size()>0 && lstWave1.get(0).Display_tracking_message__c =='Tracking is On')
        {
            isDealTrackingOn = true;
        }
        else
        {
            isDealTrackingOn = false;
        }    
        // Getting Id of record which we want to edit
        ProcessId=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.PROCESS_ID);
        
        //for Edit Operation
        if(ProcessId!=null)
        {
            showForm=true;
            col1=1;
            col2=1;
            col3=1;
            SectionTitle='Edit KT Plan';
            hiddenNavigator='New1';
            hiddenNavigator1='testValue1';
            isActive=true; 
             rerenderText='form3,msg,PanelForButton'; 
             
             // Getting the records for KT_Planning__c object for a particular process 
            List<KT_Planning__c> op=[Select id,Wave_Plan_Version__r.active__c,Wave_Plan_Version__r.Display_tracking_message__c,Wave_Plan_lk__r.NewActive__c,Wave_Plan_Version__c,Active__c,Activity__c,Deal_Location_lk__c,Planned_Start_Date__c, Planned_End_Date__c, Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Comments__c,isEditVisible__c  from KT_Planning__c where id=:ProcessId];
            if(op.size()>0)
            {
                dealLocation=op[0];
                locationName=op[0].Deal_Location_lk__c;
                WavePlanName=op[0].Wave_Plan_lk__c;
                WavePlaningName=op[0].Wave_Plan_lk__c;
                wavePlanVersionId=op[0].Wave_Plan_Version__c;
                buttonName='Update';
                isTableRendedered=false;
                valueOfActiveField=op[0].isEditVisible__c ;
                isWaveVersionActive=op[0].Wave_Plan_Version__r.active__c;
                if(op[0].Wave_Plan_Version__r.Display_tracking_message__c=='Tracking is On')
                {
                    isWaveVersionActive=false; 
                                    
                }
                List<KT_Planning_Activity_Master__c> lstActivityMaster = [select id,Activity_Order__c, name from KT_Planning_Activity_Master__c where name=:op.get(0).Activity__c order by Activity_Order__c];
                if(lstActivityMaster.size()>0 )
                {
                    isEditable = false;
                }
                else
                {
                    isEditable = true;
                }                
            }
        }
        else //for Add Operation
        {
           //Checkiing the wave plan version id 
            if(wavePlanVersionId==null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Invalid High Level Mobilization Plan ID!'));    
                showForm=false;
            }
            else
            {
                showForm=true;
                col1=3;
                col2=4;
                col3=2;
                SectionTitle='Add New KT Plan';
                initializeDetailRecords();
                hiddenNavigator='New';
                hiddenNavigator1='testValue'; 
                isActive=false;
                rerenderText='form3,frm,msg'; 
                valueOfActiveField=true;      
                List<Wave_Plan_Version__c> lstWave = [select active__c,Display_tracking_message__c from Wave_Plan_Version__c where id=:wavePlanVersionId];
                
                if(lstWave.size()>0)
                {
                    isWaveVersionActive = lstWave[0].active__c;
                    if(lstWave[0].Display_tracking_message__c== UTIL_Constants.TRACKING_IS_ON)
                    {
                        isWaveVersionActive =false;                        
                        //Start MOB_045                     
                        wavePlanList=new List<Wave_Planning__c>(); 
                        String strId=UserInfo.getUserId();  
                        wavePlanList=[Select Wave_Label__c, Location_Name__c, KT_Lead_New__r.SFDC_User__c , Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c, Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c,
                                    Deal_Location__r.Deployment_Lead_New__r.SFDC_User__c ,Deal_Location__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c
                                    from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__c=:wavePlanVersionId and 
                                    (KT_Lead_New__r.SFDC_User__c  =:strId or Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c =:strId or Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c =:strId or 
                                    Deal_Location__r.Deployment_Lead_New__r.SFDC_User__c=:strId or 
                                    Deal_Location__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c=:strId or Deal_Location__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c=:strId )];
                              if(wavePlanList.size()>0)
                                 {
                                   isTrackingOn=true;
                                 }
                              else
                                 {
                                 isTrackingOn=false;
                                 }
                                 String userProfileName = [select u.Profile.Name from User u where u.id = :strId].Profile.Name;                    
                                 if(userProfileName.equalsIgnoreCase('System Administrator') || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN))
                                 {
                                     isTrackingOn=true;
                                 }
                                 
                                 // UAM Changes- add by Vinay Chada
                                 for(MOB_User_Role_Assignment__c mobUser : userList)
                                    {
                                        if('Program Control PMO'.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_Lead__r.SFDC_User__c == UserInfo.getUserId()))
                                        {
                                            isTrackingOn=true;
                                        }
                                        if('Global Mobilization Lead'.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_Lead__r.SFDC_User__c == UserInfo.getUserId()))
                                        {
                                            isTrackingOn=true;
                                        }
                                        if(UTIL_Constants.DEAL_PMO.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_Lead__r.SFDC_User__c == UserInfo.getUserId()))
                                        {
                                            isTrackingOn=true;
                                        }
                                        
                                    }
                        //MOB_045 End
                    }
                }
                List<Delievery_Location_Master__c> loc=new List<Delievery_Location_Master__c>();
                List<Deal_Location__c> c=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__c from Deal_Location__c where Wave_Plan_Version__c=:wavePlanVersionId order by Deal_Home_Location__r.Delivery_Location_Master__r.name];        
                if(c.size()>0)
                {
                    locationName= c[0].id;
                }
                else
                {
                    locationName=UTIL_Constants.NONE;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Deal Locations and Wave Plans are not present!'));            
                }       
                refreshPage = false; 
            }
        
        }
        isDateEnabled=false;  
         // check mob leadership profile
        /*if(CheckProfile.isMobLeadershipProfile()&& processId==null)
        {
            isAddVisible = false;
            isWaveVersionActive = false;
        }
        else
            isAddVisible = true;
        */     
        // For UAM
        if(processId==null)
       {

            /*List<wave_plan_version__c> lstDeal = [select deal__c from wave_plan_version__c where id = : wavePlanVersionId];
            String strDealId = lstDeal.get(0).deal__c;            
            UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckUserRole(strDealId,'KT_Planning__c');
            isAddVisible = m.get('C');
            isWaveVersionActive = m.get('U');
            if(m.get('NA')==true)
            {
                isNA=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your administrator.'));
                return;
            }
            */
             
            isAddVisible = UAMSolMobUtility.isAddVisible_KTPlan;         
            isWaveVersionActive = UAMSolMobUtility.isWaveVersionActive_KTPlan;
            if(UAMSolMobUtility.isNA_KTPlan)
            {
                isNA = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your administrator.'));
                return;
            }
                        
            if(isDealTrackingOn==true || lstWave1[0].active__c==false)
            {
               isAddVisible=false;                                            
               isWaveVersionActive = false;
            }
       }
        //system.debug('isAddVisible-------->>>'+isAddVisible);
        //system.debug('isWaveVersionActive-------->>>'+isWaveVersionActive);
       // system.debug('isNA_KTPlan-------->>>'+UAMSolMobUtility.isNA_KTPlan);
       // system.debug('isNA-------->>>'+isNA);
       // system.debug('isEdit-------->>>'+isEdit);     
       // system.debug('isEditable -------->>>'+isEditable );
       // system.debug('isTrackingOn-------->>>'+isTrackingOn);
      //  system.debug('isTableRendedered -------->>>'+isTableRendedered);
        
        if(isAddVisible == true)
        activeRecords(wavePlanVersionId);
       
    }
    
    /******************************
    Method Name: getLocationNames
    Description: This method is used to get list of deal location for a particular wave version.  
    Paramenters: NA
    Return Value: List<SelectOption>
    *******************************/ 
    public List<SelectOption> getLocationNames()
    {   
        List<SelectOption> locName=new List<SelectOption>();
        if(locationName==UTIL_Constants.NONE)
        {
            locName.add(new SelectOption(UTIL_Constants.NONE, UTIL_Constants.NONE_FOR_PICKLIST));
            return locName;
        }
        List <Deal_Location__c> dealLocation=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c 
                            where Wave_Plan_Version__c=:wavePlanVersionId order by Deal_Home_Location__r.Delivery_Location_Master__r.name];
        if(dealLocation.size()>0)
        {
            for(Deal_Location__c c:dealLocation)
            {
                LocName.add(new SelectOption(c.id, c.Deal_Home_Location__r.Delivery_Location_Master__r.name)); 
            }
        }
        return LocName;
    }

    
     /******************************
    Method Name: getWavePlans
    Description: This method is used to get list of Wave for a particular Deal Location.  
    Paramenters: NA
    Return Value: List<SelectOption>
    *******************************/  
    public List<SelectOption> getWavePlans()
    {   
        List<SelectOption> wavePlans=new List<SelectOption>();        
        if(locationName==UTIL_Constants.NONE)
        {
            wavePlans.add(new SelectOption(UTIL_Constants.NONE,UTIL_Constants.NONE_FOR_PICKLIST));
            wavePlanName=UTIL_Constants.NONE;
            return wavePlans;
        }
        List<Wave_Planning__c> wavePlanning= [select id, Wave_Label__c from Wave_Planning__c where Deal_Location__c=:locationName and NewActive__c=:true order by Wave_Label__c];            
        if(wavePlanning.size()>0)
        {
            for(Wave_Planning__c c:wavePlanning)
            { 
                wavePlans.add(new SelectOption(c.id, c.Wave_Label__c));              
            }
        }
        else
        {
            wavePlans.add(new SelectOption(UTIL_Constants.NONE,UTIL_Constants.NONE_FOR_PICKLIST));
            wavePlanName=UTIL_Constants.NONE;
            return wavePlans;
        }
        return wavePlans;
    }
    
    
    public List<SelectOption> getLocationWaveList()
    {
        List<SelectOption> LocationWaveList=new List<SelectOption>();
        //List<Wave_Planning__c> wavePlanning= [select id, Wave_Label__c,Deal_Location__c, Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__c=:wavePlanVersionId and NewActive__c=:true order by Wave_Label__c];            
        List<Wave_Planning__c> wavePlanning= [select id, Wave_Label__c,Deal_Location__c, Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__c=:wavePlanVersionId order by Wave_Label__c];
        if(wavePlanning.size()>0)
        {
            for(Wave_Planning__c w: wavePlanning)
            { 
                LocationWaveList.add(new SelectOption(''+w.Deal_Location__c+''+w.id,''+w.Deal_Location__r.Deal_Home_Location__r.Delivery_Location_Master__r.name+' - '+w.Wave_Label__c));
            }
        }
        return LocationWaveList;
    }
  
    
    /******************************
    Method Name: addWaveProcessDetail
    Description:This method is used to add/Update KT Plan records for a particalur wave version.
    Paramenters: NA
    Return Value: void
    *******************************/  
    public void addWaveProcessDetail() {
        if(buttonName== 'Update')
        {
            dealLocation.id=ProcessId;
        }
        else
        {
            dealLocation.Is_From_Add_Section__c = true;
        }
        hiddenNavigator=UTIL_Constants.Add;
         hiddenNavigator1=UTIL_Constants.Add;
         if(dealLocation.active__c==true ||buttonName== UTIL_Constants.Add)
         {
            if(wavePlanName==UTIL_Constants.NONE||locationName==UTIL_Constants.NONE|| dealLocation.Planned_Start_Date__c==null || dealLocation.Planned_End_Date__c==null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Mandatory fields are not present!'));
                return;
            }
         }
         else
         {
             if(dealLocation.comments__c ==null && buttonName== UTIL_Constants.STR_UPDATE)
             {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                return;
             }
         }
        List<Wave_Planning__c> wavePlanning=[select GO_Live_Date_del__c, id, name from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__c=:wavePlanVersionId and Deal_Location__c=:locationName  and id=:WavePlanName];
        if(wavePlanning.size()>0)
        {
            for(Wave_Planning__c wp: wavePlanning)
            {
                if(dealLocation.Planned_End_Date__c > wp.GO_Live_Date_del__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned End Date Cannot be greater than Go Live Date!'));
                    return;
                }
            }
        }

        List<Deal_Location__c> delLocHomeId=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c where id=:locationName];
        List<Wave_Planning__c> dealWaveName=[Select id,name,Wave_Label__c from Wave_Planning__c where id=:WavePlanName];

        dealLocation.Wave_Plan_Version__c=wavePlanVersionId;
        dealLocation.Deal_Location_lk__c=locationName;
        dealLocation.Wave_Plan_lk__c=WavePlanName;
        dealLocation.Location_Id_Wave_Id__c =String.valueof(locationName) + String.valueof(WavePlanName);
        dealLocation.Location_Name_Wave_Name__c =delLocHomeId[0].Deal_Home_Location__r.Delivery_Location_Master__r.name+ ' - ' +dealWaveName[0].Wave_Label__c; 
        //dealLocation.Location_Name_Wave_Name__c =Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name+ ' - ' + Wave_Plan_lk__r.Wave_Label__c;
        
        
        try
        {
            List<KT_Planning__c> serviceList= [Select Activity__c,Deal_Location_lk__c,Planned_Start_Date__c,Planned_End_Date__c, Wave_Plan_lk__c,Wave_Plan_lk__r.NewActive__c From KT_Planning__c where Activity__c = : dealLocation.Activity__c and Deal_Location_lk__c = : dealLocation.Deal_Location_lk__c and Wave_Plan_lk__c= :dealLocation.Wave_Plan_lk__c and  Wave_Plan_Version__c=:wavePlanVersionId limit 1];
            if(serviceList.size()>=1 )
            {
                if(serviceList[0].id != dealLocation.id)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record already exists.'));
                    return;
                }
            }
           if(processId!=null) //for edit operation
           {
               dealLocation.id=processId;
               displayStr='Updated';
           }
           else // for add operation
           { 
              dealLocation.Activity_Order__c = Max_Activity_Order+1;          
              displayStr='Added';
           }
        
           if(buttonName==UTIL_Constants.STR_UPDATE&& dealLocation.active__c==false)
           {
               dealLocation.isEditVisible__c=false;
           }
    
           
           upsert dealLocation;
           if( buttonName==UTIL_Constants.Add)
            {
                valueOfActiveField=true;
            }
            else if( buttonName==UTIL_Constants.STR_UPDATE)
            {
                valueOfActiveField=dealLocation.active__c;
            }
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record '+displayStr+' Successfully!')); 
        } 
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Saving Record!'));
            return;
        }
        finally
        {
            initializeDetailRecords();
        }
        dealLocation=new KT_Planning__c();
        return; 
    }
    
     public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
      }
     
      // the current field to sort by. defaults to last name
      public String sortField {
        //get  { if (sortField == null) {sortField = 'Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Wave_Plan_lk__r.Wave_Label__c'; } return sortField;  }
        get  { if (sortField == null) {sortField = 'Location_Name_Wave_Name__c, Activity_Order__c'; } return sortField;  }
        set;
      }
  
    /******************************
    Method Name: initializeDetailRecords
    Description:This method is used to initialize the records.
    Paramenters: NA
    Return Value: void
    *******************************/ 
    public void initializeDetailRecords() 
    {   
        hiddenNavigator1=UTIL_Constants.Add;
        hiddenNavigator=UTIL_Constants.Add;
        listOfLoactionDetailsActual=null;
        listOfLoactionDetailsActual = new KT_Planning__c[]{};
        //List <KT_Planning__c> ktPlanning=[Select id, Active__c, Activity__c,Deal_Location_lk__c,Planned_Start_Date__c,Planned_End_Date__c, Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,comments__c,isEditVisible__c  from KT_Planning__c where Wave_Plan_Version__c=:wavePlanVersionId order by Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Wave_Plan_lk__r.Wave_Label__c ];

        List <KT_Planning__c> ktPlanning=[Select id, Active__c, Activity__c,Activity_Order__c,Deal_Location_lk__c,Planned_Start_Date__c,
                                         Planned_End_Date__c, Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c,Is_From_Add_Section__c,
                                         Location_Name_Wave_Name__c, Location_Id_Wave_Id__c,
                                         Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,comments__c,
                                         isEditVisible__c,Milestone__c  from KT_Planning__c where Wave_Plan_Version__c=:wavePlanVersionId
                                         order by Location_Name_Wave_Name__c, Activity_order__c ];
                    
                 
        soqlQuery='Select id,Activity_Order__c ,Active__c, Activity__c,Deal_Location_lk__c,Planned_Start_Date__c,Planned_End_Date__c, Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c,Is_From_Add_Section__c,Location_Name_Wave_Name__c, Location_Id_Wave_Id__c,Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,comments__c,isEditVisible__c,Milestone__c  from KT_Planning__c where Wave_Plan_Version__c=:wavePlanVersionId ';            
        List<KT_Planning__c> ktPlanning1=Database.query(soqlQuery  + ' order by ' + sortField + ' ' + sortDir + ' LIMIT '+list_size +' OFFSET '+ counter );
        rTrackingPageSize  = Database.query(soqlQuery); 
        total_size =rTrackingPageSize.size(); 
        
        if(ktPlanning.size()>0)
        {    Max_Activity_Order = 100;
            for(KT_Planning__c profDet : ktPlanning1)
            {     if(Max_Activity_Order < profDet.Activity_Order__c)
                            {   Max_Activity_Order = (Integer)profDet.Activity_Order__c; }
                listOfLoactionDetailsActual.add(profDet);                
            }
        }
    }
    
    public void activeRecords(String waveId){
    
    List<KT_Planning__c> lstWPVInfo = [Select id, Active__c, Planned_Start_Date__c,Planned_End_Date__c  from KT_Planning__c where Wave_Plan_Version__c=:waveId order by Location_Name_Wave_Name__c, Activity_Order__c];
           integer counter =0;
           integer Error_On_Page =0;
            if(lstWPVInfo.size()>0)
            {
                for(KT_Planning__c tmpTrack : lstWPVInfo )
                {   counter = counter+1;
                    if((tmpTrack.Planned_Start_Date__c==null || tmpTrack.Planned_End_Date__c==null)&& tmpTrack.Active__c==true)
                    {  if(counter/100 ==0)
                        {
                           Error_On_Page =1;         
                        }
                        else{
                        Error_On_Page =(counter/100)+1;
                        }  
                       system.debug('Error:'+Error_On_Page);
                       system.debug('Record num:'+counter);
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter all Planned Start Dates and Planned End Dates for active records on Page #'+Error_On_Page));  
                       break;
                        //return;          
                    }
                }
            } 
    }
    /******************************
    Method Name: refreshWaveProcessPage
    Description: This method is used to refresh the page.
    Paramenters: NA
    Return Value: void
    *******************************/  
    public void refreshWaveProcessPage(){
        initializeDetailRecords();
        refreshPage = true;
    }
      //MOB_045 Start
 /******************************
    Method Name: goToKTTracker
    Description:This method is used to Navigate to new Page for KT Tracker.
    Paramenters: NA
    Return Value: PageReference 
    *******************************/  
     public PageReference goToKTTracker()
    {
     
    
      PageReference  pr=new PageReference('/apex/KTPlanTracker?id='+wavePlanVersionId);
      pr.setRedirect(true);
      return pr;  
    }
    
    //MOB_045 End
    /******************************
    Method Name: checkRecordDeactivated
    Description: This method is used to check the record is deactivated.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void checkRecordDeactivated()
    {
        isRecordDeactivated=false;
        if(processId!=null)
        {
            if(dealLocation.comments__c ==null && buttonName== UTIL_Constants.STR_UPDATE)
                 {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                    return;
                 }
            List<KT_Planning__c> serviceList= [Select Activity__c,Deal_Location_lk__c,Planned_Start_Date__c,Planned_End_Date__c, Wave_Plan_lk__c From KT_Planning__c where Activity__c = : dealLocation.Activity__c and Deal_Location_lk__c = : dealLocation.Deal_Location_lk__c and Wave_Plan_lk__c= :dealLocation.Wave_Plan_lk__c and  Wave_Plan_Version__c=:wavePlanVersionId limit 1];
            if(serviceList.size()>=1 )
            {
                if(serviceList[0].id != dealLocation.id)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record already exists.'));
                    return;
                }
            }
            List<KT_Planning__c> tempKTList=[Select id, Active__c from KT_Planning__c where id=:processId];
            if(tempKTList.size()==1)
            {
                if(tempKTList[0].active__c==true && dealLocation.active__c==false)
                {
                    isRecordDeactivated=true;
                }
                
            }    
        }
    }
    public void save()
    {
    system.debug('START of Save method.....');
        Boolean error = false;
        List <KT_Planning__c> oldListOfLoactionDetailsActual=[Select id, Active__c, Activity__c,Deal_Location_lk__c,Planned_Start_Date__c,
                    Planned_End_Date__c, Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c,Is_From_Add_Section__c,
                    Location_Name_Wave_Name__c, Location_Id_Wave_Id__c, 
                    Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,comments__c,
                    isEditVisible__c  from KT_Planning__c where Wave_Plan_Version__c=:wavePlanVersionId and active__c =:true
                    order by Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Wave_Plan_lk__r.Wave_Label__c ];
    
        List<Wave_Planning__c> lstDealWave =[select GO_Live_Date_del__c,Revised_Go_Live__c, id, name,Deal_Location__c from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__c=:wavePlanVersionId ];
        system.debug('~~~~~'+lstDealWave);
    map<id,Deal_Location__c> DLMap = new map<id,Deal_Location__c>();
      List<Deal_Location__c> delLocHomeId=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c];
      for(Deal_Location__c dl : delLocHomeId) {
        DLMap.put(dl.Id, dl );
      }
      
      map<id,Wave_Planning__c> WPMap = new map<id,Wave_Planning__c>();
      List<Wave_Planning__c> WPList=[Select id,name,Wave_Label__c from Wave_Planning__c];
      for(Wave_Planning__c wp : WPList) {
        WPMap.put(wp.Id, wp );
      }
     
    for(KT_Planning__c tempOldList : oldListOfLoactionDetailsActual){
       for(KT_Planning__c tmpKTPlan : listOfLoactionDetailsActual)    
        {
            if(tempOldList.id==tmpKTPlan.id){ 
              if(tmpKTPlan.Planned_Start_Date__c!=null && tmpKTPlan.Planned_End_Date__c!=null )
              {
                  if(tmpKTPlan.Planned_Start_Date__c > tmpKTPlan.Planned_End_Date__c)
                  {
                    //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned start date can not be greater than planned end date for this Activity : '+tmpKTPlan.active__c +' and Location - Wave : '+tmpKTPlan.Location_Name_Wave_Name__c));
                    tmpKTPlan.Planned_End_Date__c.addError('Planned End Date should be greater than Planned Start Date');
                    //return;
                    error = true;
                  }
              }
          
             if(tmpKTPlan.comments__c ==null && tmpKTPlan.active__c==false)
             {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                //return;
                tmpKTPlan.Comments__c.addError('Comment is Mandatory if record is marked as Inactive');
                error = true;
             }
             
             if(tmpKTPlan.active__c==false && tmpKTPlan.Milestone__c==true)
              {
                 //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'An inactive Activity can not be a Milestone.'));
                 //return;
                 tmpKTPlan.comments__c.addError('An inactive activity cannot be a milestone activity');
                 error = true;
              } 
                                 
             if(tmpKTPlan.Milestone__c==true && tmpKTPlan.Planned_End_Date__c==null)
             {
                    //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned End Date is Mandatory if Milestone is active'));
                    //return;
                    tmpKTPlan.Planned_End_Date__c.addError('Planned End Date is Mandatory if Milestone is active');
                    error = true;
             }
             
             
            if(tmpKTPlan.Location_Id_Wave_Id__c != null) {
                tmpKTPlan.Deal_Location_lk__c = string.valueof(tmpKTPlan.Location_Id_Wave_Id__c).substring(0,18);
                tmpKTPlan.Wave_Plan_lk__c = string.valueof(tmpKTPlan.Location_Id_Wave_Id__c).substring(18,36);
            }
            else{
                tmpKTPlan.Deal_Location_lk__c = null;
                tmpKTPlan.Wave_Plan_lk__c = null;
            }    
            
            /*
            code for validation
            */
     System.debug('list size  ---- '+lstDealWave.size());
     if(lstDealWave.size()>0)
{
    for(Wave_Planning__c wp: lstDealWave)
    {
    System.debug('------------after for loop ---'+tmpKTPlan.Planned_End_Date__c+wp.Revised_Go_Live__c);
        if(wp.Revised_Go_Live__c!=null){
            if(tmpKTPlan.Wave_Plan_lk__c==wp.id && tmpKTPlan.Planned_End_Date__c > wp.Revised_Go_Live__c)
                {
                    System.debug('inside first validation message');
                    tmpKTPlan.Planned_End_Date__c.addError('Planned End Date Cannot be greater than Revised Go Live Date!');
                    error = true;
                }
        }
        else{
            if(tmpKTPlan.Wave_Plan_lk__c==wp.id && tmpKTPlan.Planned_End_Date__c > wp.GO_Live_Date_del__c)
                {
                                    System.debug('inside second validation message');
                    tmpKTPlan.Planned_End_Date__c.addError('Planned End Date Cannot be greater than Go Live Date!');
                    error = true;
                }
        }
    }
}
            
            /*
            validation ends
            */
            
            
            //List<Deal_Location__c> delLocHomeId=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c where id=:tmpKTPlan.Deal_Location_lk__c];
            //List<Wave_Planning__c> dealWaveName=[Select id,name,Wave_Label__c from Wave_Planning__c where id=:tmpKTPlan.Wave_Plan_lk__c];
            //tmpKTPlan.Location_Name_Wave_Name__c = delLocHomeId[0].Deal_Home_Location__r.Delivery_Location_Master__r.name + ' - ' + dealWaveName[0].Wave_Label__c;
            Deal_Location__c DLRecord= DLMap.get(tmpKTPlan.Deal_Location_lk__c);
            Wave_Planning__c WPRecord= WPMap.get(tmpKTPlan.Wave_Plan_lk__c);                       
            tmpKTPlan.Location_Name_Wave_Name__c = DLRecord.Deal_Home_Location__r.Delivery_Location_Master__r.name + ' - ' + WPRecord.Wave_Label__c;
           }
         }  
        }
        if(error == true) {
            return;
        }
        for(KT_Planning__c tempOldOKTPlan : listOfLoactionDetailsActual){
        for(KT_Planning__c tmpKTPlan : listOfLoactionDetailsActual)
            
            {    
                        
                if(tempOldOKTPlan.id!=tmpKTPlan.id ){
                    //system.debug('Old ID--->>'+tempOldOKTPlan.id +'Nww ID--->>'+tmpKTPlan.id);
                    if(tmpKTPlan.Activity__c==tempOldOKTPlan.Activity__c){
                      //  system.debug('Old Activity--->>'+tempOldOKTPlan.Activity__c +'Nww Activity--->>'+tmpKTPlan.Activity__c);
                        if(tmpKTPlan.Location_Name_Wave_Name__c==tempOldOKTPlan.Location_Name_Wave_Name__c){
                       //     system.debug('Old Loc and Wave--->>'+tempOldOKTPlan.Location_Name_Wave_Name__c+'id:'+tempOldOKTPlan.Deal_Location_lk__c+'Nww Loc and Wave--->>'+tmpKTPlan.Location_Name_Wave_Name__c+'id:'+tempOldOKTPlan.Deal_Location_lk__c);
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Duplicate Records not allowed!'));
                            return;
                        }
                    }
                }
            } 
        }
         try{
             update listOfLoactionDetailsActual;
                
            }catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Saving Record!'));
                return;
            }
            finally
            {
                initializeDetailRecords();
            }
        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Saved Successfully!')); 
        activeRecords(wavePlanVersionId);
        isEdit=false;
        disablePrevious1=false;
        disableNext1 = false;
    }   
     
public void cancel()
{
    initializeDetailRecords();
    activeRecords(wavePlanVersionId);
    isEdit=false;
    disablePrevious1=false;
    disableNext1 = false;
}

public void edit()
{
    isEdit=true;
    initializeDetailRecords();
    disablePrevious1=true;
    disableNext1 = true;

}
public void selectAll()
{
    
}
public void selectAllMilestone()
{

}

//////////

/* Pagination Code Start */
   
   private integer counter=0;  //keeps track of the offset
   private integer list_size=100; //sets the page size or number of rows
   public integer total_size; //used to show user the total size of the list
   public integer CurrentPage;
   
   public PageReference Beginning() { //user clicked beginning
      counter = 0;
      initializeDetailRecords();
      return null;
   }
 
   public PageReference Previous() { //user clicked previous button
      counter -= list_size;
     initializeDetailRecords();
      return null;
   }

   public PageReference Next() { //user clicked next button
      counter += list_size;
     initializeDetailRecords();
      return null;
   } 
 
   public PageReference End() { //user clicked end
      //counter = total_size - math.mod(total_size, list_size);  
      if(math.mod(total_size, list_size) == 0){
          counter = (total_size - math.mod(total_size, list_size))-5;
      }else{
          counter = total_size - math.mod(total_size, list_size);
      }   
     initializeDetailRecords();
      return null;
   }

   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0)
      
       return false; else return true;

   }

   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) 
      
      return false; else return true;

   }
 
   public Integer getTotal_size() {
      return total_size;
   }
 
   public Integer getpageNumber() {
      //return counter/list_size + 1;
      CurrentPage =counter/list_size + 1;
      return counter/list_size + 1;
   }

   public Integer getTotalPages() {
     if(total_size <=100){
          return  1;
      }else{ 
          if (math.mod(total_size, list_size) > 0) {
             return (total_size/list_size) + 1;
          } else {
             return (total_size/list_size);
          }
      }
   }

    /* Pagination Code End*/
    

/////////
}