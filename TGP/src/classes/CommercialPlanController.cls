/*
Author :Malkeet Singh
Description: This Inline Controller is used to add records in Commerical Plan Object
Story No:MOB_125

Updated by          Story no                Update Date        Update details
------------      -----------------        --------------    -------------------------------------------------------------
Nilesh Adkar        Mob-016                    26-Feb-13        To check whether wave plan version is active or not.
Varsha Chougule     Mob-052                    23-May-13        As a mob user, I should be able to initiate Budget Tracker.
Varsha Chougule     MOB_131                   31-may-2013       Active inactive

*/

public class CommercialPlanController{
    public String wavePlanVersionId{get;set;}
    public Integer col1{get;set;}
    public Integer col2{get;set;}
    public Integer col3{get;set;}
    public Integer Max_Activity_Order{get;set;} 
    public Boolean refreshPage {get; set;}
    public Commercial_Planning__c dealLocation {get;set;}
    public Commercial_Planning__c[] listOfLoactionDetailsActual {get;set;}
    public boolean isTableRendedered{get; set;}
    public String processId{get;set;}
    public String buttonName{get;set;}
    public Boolean isDateEnabled {get; set;} 
    public String sectionTitle{get;set;}
    public String hiddenNavigator{get;set;}
    public String hiddenNavigator1{get;set;}
    public Boolean isWaveVersionActive{get; set;}
    public Boolean isActive{get; set;}
    public boolean isEditable{get; set;}
    Public String rerenderText{get;set;}
    Public Boolean showForm{get;set;}
    Public String displayStr{get;set;} 
    public boolean isAddVisible{get; set;}
    public Boolean isTrackingOn{get; set;}
    public  List<Wave_Planning__c> wavePlanList{get;set;} 
    public boolean isRecordDeactivated{get;set;}
    public boolean valueOfActiveField{get;set;}
    public boolean isAvailable{get;set;}
    public boolean isAvailable1{get;set;}
    public List<MOB_User_Role_Assignment__c> lstUserRoleAssign{get; set;}
    public boolean isNA {get;set;}
    public boolean isEdit {get;set;}
    public Boolean isDealTrackingOn{get; set;}
    public String userId;
     /******************************
    Method Name: CommercialPlanController
    Description: This is Constructor for the CommercialPlanController class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/ 
    public CommercialPlanController(ApexPages.StandardController stdCon) 
    {
        isTableRendedered = true;
        isTrackingOn=false;
        isEditable = true;
        isNA=true;          
        buttonName = UTIL_Constants.Add;
        dealLocation = new Commercial_Planning__c();
        isWaveVersionActive = true;       
        //To get Id of Wave Plan Version
        wavePlanVersionId=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID); // id has to be there as this is inline page to custom object Wave Plan Version
        List<Wave_Plan_Version__c> lstWave1 = [select active__c,Display_tracking_message__c from Wave_Plan_Version__c where id=:wavePlanVersionId];
        if(lstWave1.size()>0 && lstWave1.get(0).Display_tracking_message__c =='Tracking is On')
        {
            isDealTrackingOn = true;
        }
        else
        {
            isDealTrackingOn = false;
        }
         
        //calling a method to give access to budget tracker to KT lead and Location Mob lead.    
        LocLeadKTLeadAccess();
        
           // Getting Id of record which we want to edit
        processId=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.PROCESS_ID);

        //for Edit Operation
        if(processId!=null)
        {
            showForm=true; 
            col1=1;
            sectionTitle='Edit Commercial Plan';
            hiddenNavigator='New1';
            hiddenNavigator1='testValue1';  
            isActive=true; 
            rerenderText='form3,msg,PanelForButton'; 
             
             // To get the Commercial Planning record which we want to edit
            List<Commercial_Planning__c> op=[Select id,Wave_Plan_Version__r.active__c,Wave_Plan_Version__r.Display_tracking_message__c,Wave_Plan_Version__c,Activity__c,Planned_Start_Date__c, Planned_End_Date__c,active__c,comments__c,isEditVisible__c from Commercial_Planning__c where id=:processId];
            if(op.size()>0)
            {
                dealLocation=op[0];
                wavePlanVersionId=op[0].Wave_Plan_Version__c;
                buttonName= UTIL_Constants.STR_UPDATE;
                isTableRendedered=false;
                valueOfActiveField=op[0].isEditVisible__c ;//active__c;
                isWaveVersionActive=op[0].Wave_Plan_Version__r.active__c;               
                if(op[0].Wave_Plan_Version__r.Display_tracking_message__c==UTIL_Constants.TRACKING_IS_ON)
                {
                    isWaveVersionActive=false;    
                }
                List<Commercial_Plan_Activity_Master__c> lstActivityMaster = [select id, Activity_Name__c from Commercial_Plan_Activity_Master__c where activity_name__C=:op.get(0).Activity__c];
                if(lstActivityMaster.size()>0 ) {
                    isEditable = false;
                }
                else {
                    isEditable = true;
                }                
            }
        }
        else  //for Add Operation
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
                col1=6;
                sectionTitle='Add New Commercial Plan';
                initializeDetailRecords();
                hiddenNavigator='New';
                hiddenNavigator1='testValue';  
                isActive=false;
                rerenderText='form3,frm,msg';   
                valueOfActiveField=true;   
                List<Wave_Plan_Version__c> lstWave = [select active__c,Display_tracking_message__c,deal__c
                                                        from Wave_Plan_Version__c where id=:wavePlanVersionId];
                List<MOB_User_Role_Assignment__c> lstUser = [ select id,Access_Level__c,Deal__c,Mob_User_Roles_Master__c,
                                                                Role_Name__c,User_Assigned_New__c,User_Assigned_Secondary_New__c,User_Assigned_Secondary_Lead__c,
                                                                User_Assigned_New__r.SFDC_User__c,User_Assigned_Secondary_New__r.SFDC_User__c, User_Assigned_Secondary_Lead__r.SFDC_User__c
                                                               from MOB_User_Role_Assignment__c where deal__c= : lstWave.get(0).deal__c
                                                              ];                                                      
                if(lstWave.size()>0)
                {               
                    isWaveVersionActive = lstWave[0].active__c;              
                    if(lstWave[0].Display_tracking_message__c == UTIL_Constants.TRACKING_IS_ON)
                    {
                        isWaveVersionActive =false;  
                        //Start MOB_052 
                        lstUserRoleAssign = [select id,Access_Level__c,Deal__c,Mob_User_Roles_Master__c,Role_Name__c,User_Assigned_New__c,User_Assigned_New__r.SFDC_User__c,
                                                User_Assigned_Secondary_New__c,User_Assigned_Secondary_New__r.SFDC_User__c,
                                                User_Assigned_Secondary_Lead__c,User_Assigned_Secondary_Lead__r.SFDC_User__c 
                                                from MOB_User_Role_Assignment__c where Deal__c = :lstWave[0].deal__c];    
                        
                        isAvailable=false; 
                        if(lstUserRoleAssign.size()>0)
                        {
                            for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign)
                            {
                                if('Global Mobilization Lead'.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_Lead__r.SFDC_User__c == UserInfo.getUserId()))
                                {
                                    isAvailable=true;
                                    isTrackingOn=true;
                                } 
                                if('Deal PMO'.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_Lead__r.SFDC_User__c == UserInfo.getUserId()))
                                {
                                    isAvailable=true;
                                    isTrackingOn=true;
                                }    
                            }
                        }    
                        if(isAvailable==false)
                        {
                            List<Budget_Solution__c> lstBudgetSolution=[Select id, isSubmittedToGovernanceLead__c from Budget_Solution__c where Wave_Plan_Version__c=: wavePlanVersionId order by Number__c];
                            if(lstBudgetSolution.size()>0)
                            {
                                if(lstBudgetSolution[0].isSubmittedToGovernanceLead__c== true)
                                {
                                    isAvailable1=false;
                                    if(lstUserRoleAssign.size()>0)
                                    {
                                        for(MOB_User_Role_Assignment__c mobUser : lstUserRoleAssign)
                                        {
                                            if('Governance Lead'.equalsIgnoreCase(mobUser.Role_Name__c) && (mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_Lead__r.SFDC_User__c == UserInfo.getUserId()))
                                            {
                                                isTrackingOn=true;
                                                isAvailable1=true;
                                            }
                                        }
                                    }
                                }
                            }
                            if(isAvailable1==false)
                            {
                                isTrackingOn=false;
                            }
                            
                        }           
                        String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name;                    
                         if(userProfileName.equalsIgnoreCase('System Administrator') || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN))
                         {
                             isTrackingOn=true;
                         } 
   
                        
                        //MOB_052 End
                    }
                }       
                refreshPage = false; 
            }
        }         
        isDateEnabled=false; 
         // check mob leadership profile
      /*  if(CheckProfile.isMobLeadershipProfile()&& processId==null)
        {
            isAddVisible = false;
            isWaveVersionActive = false;
        }
        else
            isAddVisible = true;  */ 
             
        // For UAM
       if(processId==null) 
       {
            /* List<wave_plan_version__c> lstDeal = [select deal__c from wave_plan_version__c where id = : wavePlanVersionId];
            String strDealId = lstDeal.get(0).deal__c;
            UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckUserRole(strDealId,'Commercial_Planning__c');
            isAddVisible = m.get('C');
            isWaveVersionActive = m.get('U');
            if(m.get('NA')==true)
            {
                isNA=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your Administrator.'));
                return;
            }
            */
            
            isAddVisible = UAMSolMobUtility.isAddVisible_CommPlan;
            isWaveVersionActive = UAMSolMobUtility.isWaveVersionActive_CommPlan;
            
            if(UAMSolMobUtility.isNA_CommPlan)
            {
                isNA=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your Administrator.'));
                return;
            }
            
            if(isDealTrackingOn==true || lstWave1[0].active__c==false)
            {
               isAddVisible=false;                                            
               isWaveVersionActive = false;
            }
       }
       if(isAddVisible == true)
       activeRecords(wavePlanVersionId);                
    }
    
      /******************************
    Method Name: LocLeadKTLeadAccess
    Description:This method is used to give access to KT lead and Location Mob lead.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void LocLeadKTLeadAccess()
    {

        userId = UserInfo.getUserId();
        List<Deal_Location__c> dealLocRecord = [select Deployment_Lead_New__r.SFDC_User__c, Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c, Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c  
                                        from Deal_Location__c where Wave_Plan_Version__c =: wavePlanVersionId];
        List<Wave_Planning__c> dealWaveRecord = [select KT_Lead_New__r.SFDC_User__c,Deal_Location__c, Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c, Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c
                                        from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__c =: wavePlanVersionId];
        if(isDealTrackingOn == true)
        {
            if(dealLocRecord.size()>0)
            {
                for(Deal_Location__c tempDealLoc : dealLocRecord )
                    {
                    if(userId == tempDealLoc.Deployment_Lead_New__r.SFDC_User__c || userId == tempDealLoc.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c || userId == tempDealLoc.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c) {
                        isTrackingOn=true;
                    }
                    if(dealWaveRecord.size()>0)
                    {
                        for(Wave_Planning__c tempWavePlan : dealWaveRecord )
                        {
                            if(tempDealLoc.id == tempWavePlan.Deal_Location__c)
                            {
                                if(userId == tempWavePlan.KT_Lead_New__r.SFDC_User__c || userId == tempWavePlan.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c || userId == tempWavePlan.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c)
                                {
                                    isTrackingOn=true;
                                    
                                }
                            }
                         }    
                    }
                }
            }
        }
    }
    
      /******************************
    Method Name: addWaveProcessDetail
    Description:This method is used to add/Update Commercial Plan records for a particalur wave version.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void addWaveProcessDetail() {  
        if(buttonName== UTIL_Constants.STR_UPDATE)
        {
            dealLocation.id=processId;
        }
        else if(buttonName== UTIL_Constants.Add)
        {
            dealLocation.Is_From_Add_Section__c = true;
        }     
        hiddenNavigator=UTIL_Constants.Add;
         if( buttonName == UTIL_Constants.Add || dealLocation.active__c==true)
         {
            if(dealLocation.Planned_Start_Date__c==null || dealLocation.Planned_End_Date__c==null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Mandatory fields are not present!'));
                return;
            }
                        
            if(dealLocation.Planned_Start_Date__c > dealLocation.Planned_End_Date__c)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned start date can not be greater than end date.'));
                return;
            }
            
         }
         else
         {
             if(dealLocation.comments__c ==null && buttonName== UTIL_Constants.STR_UPDATE)
             {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive.'));
                return;
             }
         }        
        dealLocation.Wave_Plan_Version__c=wavePlanVersionId;
        try
        {
            List<Commercial_Planning__c> serviceList= [Select active__c,Activity__c,Planned_Start_Date__c, Planned_End_Date__c From Commercial_Planning__c where Activity__c = : dealLocation.Activity__c  and Wave_Plan_Version__c=:wavePlanVersionId limit 1];
            if(serviceList.size()>=1)
            //Checking for the Duplicacy(Activity should be unique)
            {
                if(serviceList[0].id != dealLocation.id)
                {
                //Apex message for REcord Already Exists
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
           {  dealLocation.Activity_Order__c = Max_Activity_Order+1;   
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
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record '+displayStr+' Successfully.')); 
        } 
        catch(Exception ex)
        {
        //Apex message for Error Saving record
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Saving Record!'));
            return;
        }
        finally
        {
            initializeDetailRecords();
        }
        dealLocation=new Commercial_Planning__c();
        return; 
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
        listOfLoactionDetailsActual = new Commercial_Planning__c[]{};
        List< Commercial_Planning__c> commercialPlanning=[Select id,Active__c,Activity__c,Activity_Order__c,Planned_Start_Date__c, Planned_End_Date__c,comments__c,
                                                            isEditVisible__c,Is_From_Add_Section__c,Milestone__c  from Commercial_Planning__c 
                                                            where Wave_Plan_Version__c=:wavePlanVersionId order by Activity_Order__c];
         if(commercialPlanning.size()>0)       
          {    Max_Activity_Order = 100;          
               for(Commercial_Planning__c profDet : commercialPlanning)            
                {   
                 if(Max_Activity_Order < profDet.Activity_Order__c)                         
                    {                      
                      Max_Activity_Order = (Integer)profDet.Activity_Order__c;                   
                       }               
                    listOfLoactionDetailsActual.add(profDet);                            
                    }       
                 }
    }
    
    
    public void activeRecords(String waveId){
     List<Commercial_Planning__c> lstWPVInfo = [Select id, Active__c, Planned_Start_Date__c,Planned_End_Date__c from Commercial_Planning__c 
                                                where Wave_Plan_Version__c=:wavePlanVersionId];       
        if(lstWPVInfo.size()>0)
        {
            for(Commercial_Planning__c tmpTrack : lstWPVInfo )
            {
                if((tmpTrack.Planned_Start_Date__c==null || tmpTrack.Planned_End_Date__c==null)&& tmpTrack.Active__c==true)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter all Planned Start Dates and Planned End Dates for active records.'));  
                    return;          
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
      //MOB_052 Start
    /******************************
    Method Name: BudgetTracker
    Description:This method is used to Navigate to budget Tracker.
    Paramenters: NA
    Return Value: void
    *******************************/ 
 
     public void BudgetTracker()
    {
        List<Budget_Solution__c> lstBudgetSolution =new List<Budget_Solution__c>();
        String budgetSolutionId= null;
        lstBudgetSolution = [select id from Budget_Solution__c where Wave_Plan_Version__c=: wavePlanVersionId];
        List<Budget__c> lstBudget = [select id, name, number__c from Budget__c];
        try
        {
            if(lstBudgetSolution.size()==0)
            {
                if(lstBudget.size()>0)
                { 
                    List<Budget_Solution__c> tempBudgetSolution = new List<Budget_Solution__c>();  
                    Budget_Solution__c newBudgetSolution;
                    for(Budget__c b : lstBudget)
                    {
                        newBudgetSolution=new Budget_Solution__c ();
                        newBudgetSolution.name= b.name;
                        newBudgetSolution.number__c = b.number__c;
                        newBudgetSolution.Wave_Plan_Version__c=wavePlanVersionId;
                        tempBudgetSolution.add(newBudgetSolution);
                    }
                    upsert tempBudgetSolution;
                    List<Wave_Plan_Version__c> lstWPVTemp=[select id,Budget_Tarcking_is_initiated__c from Wave_Plan_Version__c where id=:wavePlanVersionId ];
                    if(lstWPVTemp.size()>0)
                    {
                        lstWPVTemp[0].Budget_Tarcking_is_initiated__c=true;
                        upsert lstWPVTemp[0];
                    }
                }        
            }
        }
        catch(Exception ex)
        {
            //Apex message for Error Saving record
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Saving Record!'+ex));
            return;
        }
        return;
    }

    //MOB_052 End
    
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
            dealLocation.id=processId;
            if(dealLocation.comments__c ==null && buttonName== UTIL_Constants.STR_UPDATE)
             {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                return;
             }  
             List<Commercial_Planning__c> serviceList= [Select active__c,Activity__c,Planned_Start_Date__c, Planned_End_Date__c From Commercial_Planning__c where Activity__c = : dealLocation.Activity__c  and Wave_Plan_Version__c=:wavePlanVersionId limit 1];
            if(serviceList.size()>=1)
            //Checking for the Duplicacy(Activity should be unique)
            {
                if(serviceList[0].id != dealLocation.id)
                {
                //Apex message for REcord Already Exists
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record already exists.'));
                    return;
                }
            }    
            List<Commercial_Planning__c> tempCommercialPlanningList=[Select id, Active__c from Commercial_Planning__c where id=:processId];
            if(tempCommercialPlanningList.size()==1)
            {
                if(tempCommercialPlanningList[0].active__c==true && dealLocation.active__c==false)
                {
                    isRecordDeactivated=true;
                }
                
            }    
        }
    }
    
    public void save()
    {
        Boolean error = false;
        List <Commercial_Planning__c> oldListOfLoactionDetailsActual=[Select id,Active__c,Activity__c,Planned_Start_Date__c, Planned_End_Date__c,comments__c,isEditVisible__c,
                                                                              Is_From_Add_Section__c,Milestone__c  from Commercial_Planning__c 
                                                                              where Wave_Plan_Version__c=:wavePlanVersionId order by createddate desc];
    
        for(Commercial_Planning__c tmpCPlan : listOfLoactionDetailsActual)    
        {
          if(tmpCPlan.Planned_Start_Date__c!=null && tmpCPlan.Planned_End_Date__c!=null)
          {
              if(tmpCPlan.Planned_Start_Date__c > tmpCPlan.Planned_End_Date__c)
              {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned start date can not be greater than end date for this Activity : '+tmpCPlan.Activity__c));                
                //return;
                tmpCPlan.Planned_End_Date__c.addError('Planned End Date should be greater than Planned Start Date');
                error = true;
              }
          }
          
          if(tmpCPlan.active__c==false && tmpCPlan.comments__c ==null)
          {
             //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
             //return;
             tmpCPlan.Comments__c.addError('Comment is Mandatory if record is marked as Inactive');
             error = true;
          }
          
          if(tmpCPlan.active__c==false && tmpCPlan.Milestone__c==true)
          {
             tmpCPlan.comments__c.addError('An inactive activity cannot be a milestone activity');
             error = true;
          } 
          
            if(tmpCPlan.Milestone__c==true && tmpCPlan.Planned_End_Date__c==null)
             {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned End Date is Mandatory if Milestone is active'));
                //return;
                tmpCPlan.Planned_End_Date__c.addError('Planned End Date is Mandatory if Milestone is active');
                error = true;
            }
            
            for(Commercial_Planning__c tempOldList: oldListOfLoactionDetailsActual)
            {
                if(tempOldList.id!=tmpCPlan.id && tempOldList.Activity__c == tmpCPlan.Activity__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Duplicate Records not allowed!'));
                    //return;
                    error = true;
                }
            }    
        }
        if(error == true) {
            return;
        }         
    try{
        update listOfLoactionDetailsActual;            
        } 
        catch(Exception ex)
        {
        //Apex message for Error Saving record
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Saving Record!'));
            return;
        }    
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Saved Successfully!')); 
        initializeDetailRecords();
        activeRecords(wavePlanVersionId);
        isEdit=false;
    } 
    
    public void cancel()
    {
        initializeDetailRecords();
        activeRecords(wavePlanVersionId);
        isEdit=false;
    }
    
    public void edit()
    {
        initializeDetailRecords();
        isEdit=true;    
    }
    public void selectAll()
    {
        
    }
    public void selectAllMilestone()
    {
        
    }
}