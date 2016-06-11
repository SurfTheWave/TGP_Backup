public class BusinessContinuityPlan_InlineController
{
    public ApexPages.StandardController stdController;
    public Wave_Plan_Version__c strWavePlanVersion{get;set;}
    public Wave_Plan_Version__c wpvRecord{get;set;}
    public String strWavePlanVersionId {get;set;}
    public Integer col1{get;set;}
    public Integer col2{get;set;}
    public Integer col3{get;set;}
    public Boolean refreshPage {get; set;}
    public Business_Continuity_Planning__c journeyManagementPlan{get;set;}
    public Business_Continuity_Planning__c[] listOfLoactionDetailsActual {get;set;}
    public List<Wave_Plan_Version__c> listOfLoactionDetailsActual2 {get;set;}
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
    public List<BCP_Section_Master__c> listJourneyManagement{get;set;}
    List<Business_Continuity_Planning__c> op{get;set;}
    public String taskNumber;
    public String Status {get;set;}
    public boolean isShowComments{get;set;}
    public boolean sectionDisplay{get;set;}
    public boolean isRecordDeactivated{get;set;}
    public boolean topSectionDisplay{get;set;}
    public boolean valueOfActiveField{get;set;}
    public boolean isNA {get;set;}
    public List<Wave_Plan_Version__c> lstWPV {get;set;}   
    public boolean isEdit{get; set;}
    

//    Wrapper class
    
    public class JourneyMgMt_Plan
    {
        public BCP_Section_Master__c journeyMgmt {get;set;}
        public List<Business_Continuity_Planning__c> lstJourneyMgmtPlanInner {get;set;}
    }


/* ------------------
    Constructor
----------------------*/    
    public BusinessContinuityPlan_InlineController(ApexPages.StandardController controller)
    {
        this.stdController = controller;
        strWavePlanVersion=(Wave_Plan_Version__c)controller.getRecord();
        lstWPV = new List<Wave_Plan_Version__c>();
        lstWPV.add(strWavePlanVersion);
        isNA=true;          
        isEditable = true;
        isTrackingOn=false;
        journeyManagementPlan= new Business_Continuity_Planning__c();
        isTableRendedered = true;
        buttonName='Add';
        
        listJourneyManagement=[select id,Section_Name__c,Section_Number__c from BCP_Section_Master__c where Is_Active__c =: true];
         // Getting Id of Wave Plan Version 
        strWavePlanVersionId =ApexPages.CurrentPage().getParameters().get('id');
           // Getting Id of record which we want to edit
        processId=ApexPages.CurrentPage().getParameters().get('processId');
        List<Wave_Plan_Version__c> lstWave = [select active__c,Display_tracking_message__c from Wave_Plan_Version__c where id=:strWavePlanVersionId ];
        initializeDetailRecords();        
        //for Edit Operation
        if(processId!=null)
        {
            sectionDisplay=true;
            topSectionDisplay=true;
            showForm=true;
            col1=1;
            col2=1;
            col3=1;
            sectionTitle='Edit Business Continuity Plan';
            hiddenNavigator='New1';
            hiddenNavigator1='testValue1'; 
            isActive=true; 
            rerenderText='form3,msg,PanelForButton';  
             
            // To get the Tech Assessment record which we want to edit  
            op=[select Active__c,Comments__c,Resource_Name__c,Section_Number__c,isEditVisible__c ,
                Section_Name__c,Task_Name__c,Task_Number__c,Planned_End_Date__c,Planned_Start_Date__c,
                Wave_Plan_Version__c,Wave_Plan_Version__r.active__c,BCP_Section_Master_Id__c, Wave_Plan_Version__r.Display_tracking_message__c 
                from Business_Continuity_Planning__c where id=:processId];
                
            if(op.size()>0)
            {
                journeyManagementPlan =op[0];
                strWavePlanVersionId =op[0].Wave_Plan_Version__c;
                
                buttonName='Update';
                isTableRendedered=false;
                valueOfActiveField=op[0].isEditVisible__c ;
                isWaveVersionActive=op[0].Wave_Plan_Version__r.active__c;
                strSectionName = op[0].BCP_Section_Master_Id__c;
                if(op[0].Wave_Plan_Version__r.Display_tracking_message__c=='Tracking is On')
                {
                    isWaveVersionActive=false;    
                }
                List<BCP_Task_Master__c > lstActivityMaster = [select id, Task_Name__c from BCP_Task_Master__c where Task_Name__c =:op.get(0).Task_Name__c];
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
                sectionTitle='Add New Business Continuity Plan';
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
            isAddVisible = UAMSolMobUtility.isAddVisible_BCPlan; 
            isWaveVersionActive = UAMSolMobUtility.isWaveVersionActive_BCPlan;   
              
            if(UAMSolMobUtility.isNA_BCPlan)
            {
                isNA=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your administrator.'));
                return;
            }
                
         /*   List<wave_plan_version__c> lstDeal = [select deal__c from wave_plan_version__c where id = : strWavePlanVersionId ];
            String strDealId = lstDeal.get(0).deal__c;
            UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckUserRole(strDealId,'Business_Continuity_Planning__c');
            isAddVisible = m.get('C');
            isWaveVersionActive = m.get('U');
            if(m.get('NA')==true)
            {
                isNA=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your administrator.'));
                return;
            }*/
                
            if(isTrackingOn==true || lstWave[0].active__c==false)
            {
               isAddVisible=false;                                            
               isWaveVersionActive = false;
            }
        }
        //if(isAddVisible == true)
       // activeRecords(strWavePlanVersionId);  
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

        
         listOfLoactionDetailsActual2 = [select id,name,BCP__C,BCP_Comments__c from Wave_Plan_Version__c where id=:strWavePlanVersionId];
         
         if(listOfLoactionDetailsActual2.size()>0)
         {
         for(Wave_Plan_Version__c wpv: listOfLoactionDetailsActual2)
             {
                
                if(wpv.BCP__c=='Client Driven BCP' || wpv.BCP__c==null)
                {
                sectionDisplay=false;
               
                }
                else
                {
                
                 sectionDisplay=true;
                 activeRecords(strWavePlanVersionId);
                }
            }
         }
        
        List<Business_Continuity_Planning__c> lstJourneyPlan = [select id,name,Active__c,Comments__c,isEditVisible__c ,
                                                                Resource_Name__c,Section_Number__c,
                                                                Section_Name__c,Task_Name__c,
                                                                Planned_End_Date__c,Planned_Start_Date__c,
                                                                BCP_Task_Master_Id__c,BCP_Section_Master_Id__c,
                                                                Task_Number__c,Wave_Plan_Version__c,Is_From_Add_Section__c,Milestone__c
                                                                from Business_Continuity_Planning__c 
                                                                where Wave_Plan_Version__c =:strWavePlanVersionId order by Task_Number__c ];  
         listOfLoactionDetailsActual = new Business_Continuity_Planning__c[]{};                                                       
        
        if(lstJourneyPlan.size()>0)
        {
            for(Business_Continuity_Planning__c profDet : lstJourneyPlan )
            {
                listOfLoactionDetailsActual.add(profDet);                
            }
        } 
                                                                          
      set<Id> lstSectionIds = new set<Id>(); 
        
                                                             
        for(Business_Continuity_Planning__c tmp : lstJourneyPlan )
        {
           lstSectionIds.add(tmp.BCP_Section_Master_Id__c);
        }
       
        List<BCP_Section_Master__c> lstJourneyMgmt = [select id, name,Section_Name__c,Section_Number__c from BCP_Section_Master__c where id in :lstSectionIds and Is_Active__c =: true order by Section_Number__c  ];          
      
        JourneyMgMt_Plan journeyMgmtPlan;
        lstJourneyMgmtPlan = new List<JourneyMgMt_Plan>();
        
        Business_Continuity_Planning__c journeyPlan;
        List<Business_Continuity_Planning__c > lstJourneyPlan2 = new List<Business_Continuity_Planning__c >();
        
        for(BCP_Section_Master__c tmpJourneyMgmt : lstJourneyMgmt)
        {
            lstJourneyPlan2 = new List<Business_Continuity_Planning__c >(); // detail
            journeyMgmtPlan = new JourneyMgMt_Plan();// wrapper class
            journeyMgmtPlan.journeyMgmt =  tmpJourneyMgmt; // master -> wrapper
          for(Business_Continuity_Planning__c tmpJourneyPlan :lstJourneyPlan ) 
            {
                if(tmpJourneyMgmt.id==tmpJourneyPlan.BCP_Section_Master_Id__c)
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
        journeyManagementPlan = new Business_Continuity_Planning__c();     
                         
    }

    public void activeRecords(String waveId){
            List<Business_Continuity_Planning__c> lstWPVInfo = [Select id, Active__c, Planned_End_Date__c, Planned_Start_Date__c  from Business_Continuity_Planning__c where Wave_Plan_Version__c=:waveId];           
            if(lstWPVInfo.size()>0)
            {
                for(Business_Continuity_Planning__c tmpTrack : lstWPVInfo )
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
    Method Name: saveJourneyPlan
    Description:This method is used to initialize the records.
    Paramenters: NA
    Return Value: void
    *******************************/ 
    public void saveJourneyPlan()
    {
        displayStr = (buttonName == 'Add')? 'Added' : 'Updated';
        journeyManagementPlan.BCP_Section_Master_Id__c = strSectionName;
        //BG BCP Fix insert start
        List<BCP_Section_Master__c> secName=[Select Section_Name__c from BCP_Section_Master__c where id=: strSectionName];
        journeyManagementPlan.Section_Name__c = secName[0].Section_Name__c;
        //BG BCP Fix update End
        journeyManagementPlan.Wave_Plan_Version__c =strWavePlanVersionId ;
         if( buttonName == 'Add' || journeyManagementPlan.active__c == true)
         {
            if(strSectionName==null||journeyManagementPlan.Task_Name__c==null ||journeyManagementPlan.Planned_Start_Date__c==null || journeyManagementPlan.Planned_End_Date__c==null || journeyManagementPlan.Resource_Name__c==null)
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
        if(journeyManagementPlan.Planned_Start_Date__c > journeyManagementPlan.Planned_End_Date__c)         
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned start date can not be greater than end date.'));
            return;
        }
        List<Business_Continuity_Planning__c > lstJourneyPlan;
        if( buttonName=='Add')
        {
            lstJourneyPlan = [select id from Business_Continuity_Planning__c where (Task_Name__c=:journeyManagementPlan.Task_Name__c ) and BCP_Section_Master_Id__c=:journeyManagementPlan.BCP_Section_Master_Id__c and Wave_plan_version__c = :strWavePlanVersionId ];
            journeyManagementPlan.Is_From_Add_Section__c = true;
            
        }            
        else if( buttonName=='Update')    
            lstJourneyPlan = [select id from Business_Continuity_Planning__c where (Task_Name__c=:journeyManagementPlan.Task_Name__c ) and BCP_Section_Master_Id__c=:journeyManagementPlan.BCP_Section_Master_Id__c and id<> :journeyManagementPlan.id and Wave_plan_version__c = :strWavePlanVersionId ];
        
        if(lstJourneyPlan.size()>0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record with same Task name already exists.'));
            return;
        }
        
       if(buttonName=='Update'&& journeyManagementPlan.active__c==false)
       {
           journeyManagementPlan.isEditVisible__c=false;
       }

        upsert journeyManagementPlan;
        if( buttonName=='Add')
        {
            valueOfActiveField=true;
        }
        else if( buttonName=='Update')
        {
            valueOfActiveField=journeyManagementPlan.active__c;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record '+displayStr+' Successfully.'));
        
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
        List <BCP_Section_Master__c> lstJourney=[select id,section_name__c from BCP_Section_Master__c];
        if(lstJourney.size()>0)
        {
            for(BCP_Section_Master__c c:lstJourney)
            {
                secName.add(new SelectOption(c.id, c.section_name__c )); 
            }
        }
        return secName;
    }
     public Pagereference changeStatus() 
        { 
            Status=strWavePlanVersion.BCP__c;
            if(strWavePlanVersion.BCP__c=='Client Driven BCP')
                {
                    isShowComments=true;
                }
                
            return null ;        
        }
    public void saveWPVrecord()
    {
       // Wave_Plan_version__c wavePlanVersion = (Wave_Plan_version__c)stdController.getRecord();
       // strWavePlanVersionId  = wavePlanVersion.id;
        List<wave_plan_version__c> wpvRecord;
        if(listOfLoactionDetailsActual2.size()>0)
        {  
          if(listOfLoactionDetailsActual2[0].BCP_Comments__c== null && listOfLoactionDetailsActual2[0].BCP__c== 'Client Driven BCP')
          {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Provide Comments')); 
             return;
          }
         wpvRecord = [select deal__c,BCP__c,cloned_from__c from wave_plan_version__c where id = : strWavePlanVersionId ];
        if(wpvRecord.size()>0)
        {  
           Wave_Plan_Version__c waveRecord= new Wave_Plan_Version__c();
            waveRecord=wpvRecord[0];
            waveRecord.BCP__c=listOfLoactionDetailsActual2[0].BCP__c;
            waveRecord.BCP_Comments__c=listOfLoactionDetailsActual2[0].BCP_Comments__c;
            update waveRecord;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Updated Successfully'));
        }
       /* wpvRecord = [select deal__c,BCP__c,cloned_from__c from wave_plan_version__c where id = : strWavePlanVersionId ];
        if(wpvRecord.get(0).BCP__c!='Client Driven BCP')
        {
            Mob_PrePopulateBusinessContinuityGrid.insertBusinessContinuity(wpvRecord);
        }*/
        }
        initializeDetailRecords(); 
        
        
      return;
    }
    
    /******************************
        Method Name: getstatusValues
        Description: Add method to get Offerings only related to Opportunity
        Paramenters: NA
        Return Value: void
        *******************************/
        //Start
        public List<SelectOption> getstatusValues()
        {
           List<SelectOption> statusValues=new List<SelectOption>();
            statusValues.add(new SelectOption('Client Driven BCP','Client Driven BCP'));
            statusValues.add(new SelectOption('Standard Offering BCP','Standard Offering BCP'));
            statusValues.add(new SelectOption('Non-Standard Offering BCP','Non-Standard Offering BCP'));
            
          /* List<Wave_Plan_version__c> wpv = [Select id,Name,BCP__c from Wave_Plan_version__c];
           if(wpv.Size()>0)
           {
              for(Wave_Plan_version__c c:wpv)
              {
                 
                statusValues.add(new SelectOption(c.id,c.BCP__c)); 
              }
           }*/
           
            return statusValues;
        }   
  /*  public void showComments()
    {
        if(strWavePlanVersion.BCP__c=='Client Driven BCP')
        {
            isShowComments=true;
        }
    } */
    
    
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
        List<Business_Continuity_Planning__c> lstBCPPlan = [select id from Business_Continuity_Planning__c where (Task_Name__c=:journeyManagementPlan.Task_Name__c ) and BCP_Section_Master_Id__c=:journeyManagementPlan.BCP_Section_Master_Id__c and id<> :journeyManagementPlan.id and Wave_plan_version__c = :strWavePlanVersionId ];
        
        if(lstBCPPlan.size()>0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record with same Task name already exists.'));
            return;
        } 
            List<Business_Continuity_Planning__c> tempBCPList=[Select id, Active__c from Business_Continuity_Planning__c where id=:processId];
            if(tempBCPList.size()==1)
            {
                if(tempBCPList[0].active__c==true && journeyManagementPlan.active__c==false)
                {
                    isRecordDeactivated=true;
                }
                
            }    
        }
    }
    
    public void save()
    {
        Boolean error = false;
        List<Business_Continuity_Planning__c> oldListOfLoactionDetailsActual = [select id,name,Active__c,Comments__c,isEditVisible__c ,
                                                                Resource_Name__c,Section_Number__c,
                                                                Section_Name__c,Task_Name__c,
                                                                Planned_End_Date__c,Planned_Start_Date__c,
                                                                BCP_Task_Master_Id__c,BCP_Section_Master_Id__c,
                                                                Task_Number__c,Wave_Plan_Version__c,Is_From_Add_Section__c,Milestone__c
                                                                from Business_Continuity_Planning__c 
                                                                where Wave_Plan_Version__c =:strWavePlanVersionId order by Task_Number__c ];
        List<Wave_Planning__c> lstDealWave =[select GO_Live_Date_del__c, id, name,Deal_Location__c from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__c=:strWavePlanVersionId];
        Integer count=0;
        //BG BCP Section Name update fix start
        Map<Id, String> bcpSectionMasterIsWithName =  new Map<Id, String>();
        for(BCP_Section_Master__c bcpName : [select id,Section_Name__c,Section_Number__c from BCP_Section_Master__c]) {
        	bcpSectionMasterIsWithName.put(bcpName.Id, bcpName.Section_Name__c);	
      	}        
        //BG BCP Section Name update fix end
        for(Business_Continuity_Planning__c tmpBCPlan : listOfLoactionDetailsActual)    
        {
         	tmpBCPlan.Section_Name__c = bcpSectionMasterIsWithName.get(tmpBCPlan.BCP_Section_Master_Id__c); //BG BCP Section Name update fix   
              if(tmpBCPlan.Planned_Start_Date__c!=null && tmpBCPlan.Planned_End_Date__c!=null)
              {
                  if(tmpBCPlan.Planned_Start_Date__c > tmpBCPlan.Planned_End_Date__c)
                  {
                    //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned start date can not be greater than end date for this Section Name : '+tmpBCPlan.Section_Name__c +' and Task : '+tmpBCPlan.Task_Name__c));
                    //return;
                    tmpBCPlan.Planned_End_Date__c.addError('Planned End Date should be greater than Planned Start Date');
                    error = true;
                  }
              }
          
             if(tmpBCPlan.comments__c ==null && tmpBCPlan.active__c==false)
             {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                //return;
                tmpBCPlan.Comments__c.addError('Comment is Mandatory if record is marked as Inactive');
                error = true;
             }
             
             if(tmpBCPlan.active__c==false && tmpBCPlan.Milestone__c==true)
              {
                 tmpBCPlan.comments__c.addError('An inactive activity cannot be a milestone activity');
                 error = true;
              } 
                                 
              if(tmpBCPlan.Milestone__c==true && tmpBCPlan.Planned_End_Date__c==null)
             {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned End Date is Mandatory if Milestone is active'));
                //return;
                tmpBCPlan.Planned_End_Date__c.addError('Planned End Date is Mandatory if Milestone is active');
                error = true;
            }                  
            for(Business_Continuity_Planning__c tempOldList: oldListOfLoactionDetailsActual)
            {
                if(tempOldList.id!=tmpBCPlan.id && tempOldList.Task_Name__c == tmpBCPlan.Task_Name__c && tempOldList.BCP_Section_Master_Id__c== tmpBCPlan.BCP_Section_Master_Id__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record with same Task name already exists.'));
                    return;        
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