/*
Author : Malkeet Singh
Story: MOB_162
Description: To Add/update records for Contract Legal Infosec Management Plan object on high level plan

Updated by          Story no                Update Date        Update details
------------      -----------------        --------------    -------------------------------------------------------------
Varsha Chougule      MOB_131                  31-may-2013       Active inactive
*/

public class ContractLegalInfoManagementPlan_Inline
{
    public ApexPages.StandardController stdController;
    public String strWavePlanVersionId {get;set;}
    public Integer col1{get;set;}
    public Integer col2{get;set;}
    public Integer col3{get;set;}
    public Boolean refreshPage {get; set;}
    public Contract_Legal_Infosec__c journeyManagementPlan{get;set;}
    public Contract_Legal_Infosec__c[] listOfLoactionDetailsActual {get;set;}
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
    public List<JourneyMgMt_Plan> lstJourneyMgmtPlan{get; set;}
    Public String strSectionName{get;set;}
    public List<Contract_Legal_Infosec_Section_Master__c> listJourneyManagement{get;set;}
    List<Contract_Legal_Infosec__c> op{get;set;}
    public boolean isRecordDeactivated{get;set;}
    public boolean valueOfActiveField{get;set;}
    public boolean isNA {get;set;}
    public boolean isEdit{get; set;}
    

//    Wrapper class
    
    public class JourneyMgMt_Plan
    {
        public String strSectionName {get;set;}
        public Contract_Legal_Infosec_Section_Master__c journeyMgmt {get;set;}
        public List<Contract_Legal_Infosec__c> lstJourneyMgmtPlanInner {get;set;}
    }


/* ------------------
    Constructor
----------------------*/    
    public ContractLegalInfoManagementPlan_Inline(ApexPages.StandardController controller)
    {
        this.stdController = controller;
        isNA=true;          
        isEditable = true;
        isTrackingOn=false;
        journeyManagementPlan= new Contract_Legal_Infosec__c();
        isTableRendedered = true;
        buttonName='Add';
        
        listJourneyManagement=[select id,section_name__c from Contract_Legal_Infosec_Section_Master__c where Is_Active__c =:true];
         // Getting Id of Wave Plan Version 
        strWavePlanVersionId =ApexPages.CurrentPage().getParameters().get('id');
           // Getting Id of record which we want to edit
        processId=ApexPages.CurrentPage().getParameters().get('processId');
        List<Wave_Plan_Version__c> lstWave = [select active__c,Display_tracking_message__c from Wave_Plan_Version__c where id=:strWavePlanVersionId ];
        initializeDetailRecords();        
        //for Edit Operation
        if(processId!=null)
        {
            showForm=true;
            col1=1;
            col2=1;
            col3=1;
            sectionTitle='Edit Contract/Legal Infosec Plan';
            hiddenNavigator='New1';
            hiddenNavigator1='testValue1'; 
            isActive=true; 
            rerenderText='form3,msg,PanelForButton';  
             
            // To get the Tech Assessment record which we want to edit  
            op=[select Active__c,Cloned_From__c,Comments__c,Task_Name__c,
                Task_Number__c,Task_Master_ID__c,isEditVisible__c ,
                Section_Master_ID__c,Planned_End_Date__c,Planed_Start_Date__c,
                Responsibility__c,Resource_Name__c,Section_Name__c,Section_Number__c,
                Version__c,Wave_Plan_Version__c,Wave_Plan_Version__r.active__c, Wave_Plan_Version__r.Display_tracking_message__c 
                from Contract_Legal_Infosec__c where id=:processId];
                
            if(op.size()>0)
            {
                journeyManagementPlan =op[0];
                strWavePlanVersionId =op[0].Wave_Plan_Version__c;
                
                buttonName='Update';
                isTableRendedered=false;
                valueOfActiveField=op[0].isEditVisible__c ;
                isWaveVersionActive=op[0].Wave_Plan_Version__r.active__c;
                strSectionName = op[0].Section_Master_ID__c;
                if(op[0].Wave_Plan_Version__r.Display_tracking_message__c=='Tracking is On')
                {
                    isWaveVersionActive=false;    
                }
                List<Contract_Legal_Infosec_Task_Master__c> lstActivityMaster = [select id, Task_Name__c, Task_Number__c from Contract_Legal_Infosec_Task_Master__c where Task_Name__c =:op.get(0).Task_Name__c and Task_Number__c=:op.get(0).Task_Number__c];
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
        else  //for Add Operation
        {
            //Checkiing the wave plan version id 
            if(strWavePlanVersionId ==null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Invalid High Level Mobilization Plan ID!'));    
                showForm=false;
            }
            else
            {
                showForm=true;
                col1=3;
                col2=4;
                col3=7;
                sectionTitle='Add New Contract/Legal Infosec Plan';
                initializeDetailRecords();
                hiddenNavigator='New';
                hiddenNavigator1='testValue';  
                isActive=false;
                rerenderText='form3,frm,msg';
                valueOfActiveField=true;            
                
                if(lstWave.size()>0)
                {
                    isWaveVersionActive = lstWave[0].active__c;
                    if(lstWave[0].Display_tracking_message__c=='Tracking is On')
                    {
                        isWaveVersionActive =false;
                        isTrackingOn=true;  
                    }
                }
                refreshPage = false; 
            }
             
        }
         
        isDateEnabled=false;             
         // check mob leadership profile
     /*   if(CheckProfile.isMobLeadershipProfile()&& processId==null)
        {
            isAddVisible = false;
            isWaveVersionActive = false;
        }
        else
            isAddVisible = true; */
             
        // For UAM
        if(processId==null)
        {
            isAddVisible = UAMSolMobUtility.isAddVisible_CLIPlan; 
            isWaveVersionActive = UAMSolMobUtility.isWaveVersionActive_CLIPlan;   
              
            if(UAMSolMobUtility.isNA_CLIPlan)
            {
                isNA=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your Administrator.'));
                return;
            }
       /* List<wave_plan_version__c> lstDeal = [select deal__c from wave_plan_version__c where id = : strWavePlanVersionId ];
        String strDealId = lstDeal.get(0).deal__c;
        UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
        Map<String,Boolean> m = uam.CheckUserRole(strDealId,'Contract_Legal_Infosec__c');
        isAddVisible = m.get('C');
        isWaveVersionActive = m.get('U');
        if(m.get('NA')==true)
        {
            isNA=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your Administrator.'));
            return;
        } */                                                                            
        if(isTrackingOn==true || (lstWave.size()>0 && lstWave[0].active__c==false))
        {
           isAddVisible=false;                                            
           isWaveVersionActive = false;
        }
      }
      if(isAddVisible == true)
      activeRecords(strWavePlanVersionId);
      
    }

    /******************************
    Method Name: initializeDetailRecords
    Description:This method is used to initialize the records.
    Paramenters: NA
    Return Value: void
    *******************************/ 
    public void initializeDetailRecords() 
    {
        Wave_Plan_version__c wavePlanVersion = (Wave_Plan_version__c)stdController.getRecord();
        strWavePlanVersionId  = wavePlanVersion.id;
        
        if(strWavePlanVersionId ==null)
        {
            strWavePlanVersionId  = ApexPages.CurrentPage().getParameters().get('id');
        }

        //Fetch journey planning records
        List<Contract_Legal_Infosec__c> lstJourneyPlan = [select id,name,Active__c,Cloned_From__c,Comments__c,Task_Name__c,Task_Number__c,
                                                                Task_Master_ID__c,Section_Master_ID__c,
                                                                Planned_End_Date__c,Planed_Start_Date__c,Responsibility__c,
                                                                Section_Name__c,Section_Number__c,Version__c,
                                                                Wave_Plan_Version__c,Resource_Name__c,isEditVisible__c,Is_From_Add_Section__c,Milestone__c
                                                                from Contract_Legal_Infosec__c 
                                                                where Wave_Plan_Version__c =:strWavePlanVersionId
                                                                order by Task_Number__c ]; 
                                                                
        listOfLoactionDetailsActual = new Contract_Legal_Infosec__c[]{};                                                       
        
        if(lstJourneyPlan.size()>0)
        {
            for(Contract_Legal_Infosec__c profDet : lstJourneyPlan )
            {
                listOfLoactionDetailsActual.add(profDet);                
            }
        }                                                                 
     set<Id> lstSectionIds = new set<Id>(); 
        
                                                             
        for(Contract_Legal_Infosec__c  tmp : lstJourneyPlan )
        {
           lstSectionIds.add(tmp.Section_Master_ID__c);
        }
       
        List<Contract_Legal_Infosec_Section_Master__c> lstJourneyMgmt = [select id, name,section_number__c, section_name__c from Contract_Legal_Infosec_Section_Master__c where id in :lstSectionIds order by section_number__c];
      
        JourneyMgMt_Plan journeyMgmtPlan;
        lstJourneyMgmtPlan = new List<JourneyMgMt_Plan>();

        Contract_Legal_Infosec__c  journeyPlan;
        List<Contract_Legal_Infosec__c > lstJourneyPlan2 = new List<Contract_Legal_Infosec__c >();
        
        for(Contract_Legal_Infosec_Section_Master__c tmpJourneyMgmt : lstJourneyMgmt)
        {
            lstJourneyPlan2 = new List<Contract_Legal_Infosec__c >(); // detail
            journeyMgmtPlan = new JourneyMgMt_Plan();// wrapper class
            journeyMgmtPlan.journeyMgmt=  tmpJourneyMgmt; // master -> wrapper          
          for(Contract_Legal_Infosec__c  tmpJourneyPlan :lstJourneyPlan ) 
            {
                if(tmpJourneyMgmt.id==tmpJourneyPlan.Section_Master_ID__c)
                {
                    lstJourneyPlan2.add(tmpJourneyPlan );
                }
            } 
            if(lstJourneyPlan2.size()>0)
            {
                journeyMgmtPlan.lstJourneyMgmtPlanInner = lstJourneyPlan2; 
            }
            lstJourneyMgmtPlan.add(journeyMgmtPlan);
        }
        journeyManagementPlan = new Contract_Legal_Infosec__c(); 
    }

    public void activeRecords(String waveId){
         List<Contract_Legal_Infosec__c> lstWPVInfo = [Select id, Active__c, Planed_Start_Date__c, Planned_End_Date__c from Contract_Legal_Infosec__c where Wave_Plan_Version__c=:waveId];
            if(lstWPVInfo.size()>0)
            {
                for(Contract_Legal_Infosec__c tmpTrack : lstWPVInfo )
                {
                    if((tmpTrack.Planed_Start_Date__c==null || tmpTrack.Planned_End_Date__c==null)&& tmpTrack.Active__c==true)
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter all Planned Start Dates and Planned End Dates for active records.'));  
                        return;          
                    }
                }
            } 
        }
    /******************************
    Method Name: saveJourneyPlan
    Description:This method is used to initialize the records.
    Paramenters: NA
    Return Value: void
    *******************************/ 
    public void saveJourneyPlan()
    {
        displayStr = (buttonName == 'Add')? 'Added' : 'Updated';
        journeyManagementPlan.Section_Master_ID__c = strSectionName;
        journeyManagementPlan.Wave_Plan_Version__c =strWavePlanVersionId ;
         if( buttonName == 'Add' || journeyManagementPlan.active__c == true)
         {
            if(strSectionName==null||journeyManagementPlan.Task_Name__c==null ||journeyManagementPlan.Planed_Start_Date__c==null || journeyManagementPlan.Planned_End_Date__c==null || journeyManagementPlan.Resource_Name__c==null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Mandatory fields are not present!'));
                return;
            }
         }
         else
         {
             if(journeyManagementPlan.comments__c ==null && journeyManagementPlan.active__c==false)
             {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                return;
             }
         }
      
        if(journeyManagementPlan.Planed_Start_Date__c > journeyManagementPlan.Planned_End_Date__c)         
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned start date can not be greater than end date.'));
            return;
        }
        List<Contract_Legal_Infosec__c > lstJourneyPlan; 
        if( buttonName=='Add')
        {
            lstJourneyPlan = [select id from Contract_Legal_Infosec__c where(Task_Name__c=:journeyManagementPlan.Task_Name__c)  and Section_Master_ID__c=:journeyManagementPlan.Section_Master_ID__c and id<> :journeyManagementPlan.id and Wave_plan_version__c = :strWavePlanVersionId ];
            journeyManagementPlan.Is_From_Add_Section__c = true;
            List<Contract_Legal_Infosec_Section_Master__c> lstContractMaster = [select section_name__c, section_number__c from Contract_Legal_Infosec_Section_Master__c where id=:journeyManagementPlan.Section_Master_ID__c AND Is_Active__c =:true];
            if(lstContractMaster.size()>0)
            {
                journeyManagementPlan.section_name__c=lstContractMaster.get(0).section_name__c;
            }            
        }            
        else if( buttonName=='Update') 
        {   
           lstJourneyPlan = [select id from Contract_Legal_Infosec__c where(Task_Name__c=:journeyManagementPlan.Task_Name__c)  and Section_Master_ID__c=:journeyManagementPlan.Section_Master_ID__c and id<> :journeyManagementPlan.id and Wave_plan_version__c = :strWavePlanVersionId ];
           
        }
        if(lstJourneyPlan.size()>0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Task Name already exists for the selected Section.'));
            return;
        }
        
       if(buttonName=='Update'&& journeyManagementPlan.active__c==false)
       {
           journeyManagementPlan.isEditVisible__c=false;
       }

        
        try
        {
            upsert journeyManagementPlan;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record '+displayStr+' Successfully.')); 
        }
        catch(System.DmlException e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getDmlMessage(0)));
            return;
        }
        if( buttonName=='Add')
        {
            valueOfActiveField=true;
        }
        else if( buttonName=='Update')
        {
            valueOfActiveField=journeyManagementPlan.active__c;
        }
        
        if(buttonName == 'Add')
            initializeDetailRecords();
    }
 
     /******************************
    Method Name: getSectionNames
    Description: This method is used to get list of Section Names.  
    Paramenters: NA
    Return Value: List<SelectOption>
    *******************************/ 
    public List<SelectOption> getSectionNames()
    {   
        List<SelectOption> secName=new List<SelectOption>();
        if(strSectionName=='None')
        {
            secName.add(new SelectOption('None','--None--'));
            return secName;
        }
        List <Contract_Legal_Infosec_Section_Master__c> lstJourney=[select id,section_name__c from Contract_Legal_Infosec_Section_Master__c where Is_Active__c =:true];
        if(lstJourney.size()>0)
        {
            for(Contract_Legal_Infosec_Section_Master__c c:lstJourney)
            {
                secName.add(new SelectOption(c.id, c.section_name__c )); 
            }
        }
        return secName;
    } 
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
            if(journeyManagementPlan.comments__c ==null && journeyManagementPlan.active__c==false)
             {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                return;
             }      
        List<Contract_Legal_Infosec__c > lstJourneyPlan = [select id from Contract_Legal_Infosec__c where (Task_Name__c=:journeyManagementPlan.Task_Name__c)  and Section_Master_ID__c=:journeyManagementPlan.Section_Master_ID__c and id<> :journeyManagementPlan.id and Wave_plan_version__c = :strWavePlanVersionId ];
        
        if(lstJourneyPlan.size()>0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Task Name already exists for the selected Section.'));
            return;
        }  
            List<Contract_Legal_Infosec__c > tempJourneyList=[Select id, Active__c from Contract_Legal_Infosec__c where id=:processId];
            if(tempJourneyList.size()==1)
            {
                if(tempJourneyList[0].active__c==true && journeyManagementPlan.active__c==false)
                {
                    isRecordDeactivated=true;
                }
                
            }    
        }
    }
    
    public void save()
    {
    Boolean error = false;
    List<Contract_Legal_Infosec__c> oldListOfLoactionDetailsActual = [select id,name,Active__c,Cloned_From__c,Comments__c,Task_Name__c,Task_Number__c,
                                                                        Task_Master_ID__c,Section_Master_ID__c,
                                                                        Planned_End_Date__c,Planed_Start_Date__c,Responsibility__c,
                                                                        Section_Name__c,Section_Number__c,Version__c,
                                                                        Wave_Plan_Version__c,Resource_Name__c,isEditVisible__c,Is_From_Add_Section__c,Milestone__c
                                                                        from Contract_Legal_Infosec__c 
                                                                        where Wave_Plan_Version__c =:strWavePlanVersionId
                                                                        order by Task_Number__c ];
        List<Wave_Planning__c> lstDealWave =[select GO_Live_Date_del__c, id, name,Deal_Location__c from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__c=:strWavePlanVersionId];
        Integer count=0;
        for(Contract_Legal_Infosec__c tmpCLIPlan : listOfLoactionDetailsActual)    
        {
            
              if(tmpCLIPlan.Planed_Start_Date__c!=null && tmpCLIPlan.Planned_End_Date__c!=null)
              {
                  if(tmpCLIPlan.Planed_Start_Date__c > tmpCLIPlan.Planned_End_Date__c)
                  {
                    //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned start date can not be greater than end date for this Section Name : '+tmpCLIPlan.Section_Name__c +' and Task : '+tmpCLIPlan.Task_Name__c));
                    //return;
                    tmpCLIPlan.Planned_End_Date__c.addError('Planned End Date should be greater than Planned Start Date');
                    error = true;
                  }
              }
          
             if(tmpCLIPlan.comments__c ==null && tmpCLIPlan.active__c==false)
             {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                //return;
                tmpCLIPlan.Comments__c.addError('Comment is Mandatory if record is marked as Inactive');
                error = true;
             }
             
             if(tmpCLIPlan.active__c==false && tmpCLIPlan.Milestone__c==true)
              {
                 tmpCLIPlan.comments__c.addError('An inactive activity cannot be a milestone activity');
                 error = true;
              } 
                                 
             if(tmpCLIPlan.Milestone__c==true && tmpCLIPlan.Planned_End_Date__c==null)
             {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned End Date is Mandatory if Milestone is active'));
                //return;
                tmpCLIPlan.Planned_End_Date__c.addError('Planned End Date is Mandatory if Milestone is active');
                error = true;
            }     
           
            for(Contract_Legal_Infosec__c tempOldList: oldListOfLoactionDetailsActual)
            {
                if(tempOldList.id!=tmpCLIPlan.id && tempOldList.Task_Name__c == tmpCLIPlan.Task_Name__c && tempOldList.Section_Master_ID__c == tmpCLIPlan.Section_Master_ID__c)
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
                
            }catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Saving Record!'));
                return;
            }
            finally
            {
                initializeDetailRecords();
            }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Saved Successfully!'));
        activeRecords(strWavePlanVersionId);
        isEdit=false;

    }   
  
    public void cancel()
    {
        isEdit=false;
        initializeDetailRecords();
        activeRecords(strWavePlanVersionId);

    }
    
    public void edit()
    {
        isEdit=true;
        initializeDetailRecords();

    
    }
    public void selectAll()
    {
        
    }
    public void selectAllMilestone()
    {
        
    }
}