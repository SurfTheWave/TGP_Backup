/*
Author : Nilesh Adkar
Story: MOB_162
Description: To Add/update records for Journey Management Plan object on high level plan

Updated by          Story no                Update Date        Update details
------------      -----------------        --------------    -------------------------------------------------------------
Varsha Chougule      MOB_131                  31-may-2013       Active inactive
*/

public class JourneyManagementPlan_Inline
{
    public ApexPages.StandardController stdController;
    public String strWavePlanVersionId {get;set;}
    public Integer col1{get;set;}
    public Integer col2{get;set;}
    public Integer col3{get;set;}
    public Boolean refreshPage {get; set;}
    public Journey_Management_Planning__c journeyManagementPlan{get;set;}
    public Journey_Management_Planning__c[] listOfLoactionDetailsActual {get;set;}
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
    public List<Journey_Management__c> listJourneyManagement{get;set;}
    List<Journey_Management_Planning__c> op{get;set;}
    public boolean isRecordDeactivated{get;set;}
    public boolean valueOfActiveField{get;set;}
    public boolean isNA {get;set;}
    public boolean isEdit{get; set;}

//    Wrapper class
    
    public class JourneyMgMt_Plan 
    {
        public String strSectionName {get;set;}
        public String strSectionNo{get;set;}
        public Journey_Management__c journeyMgmt {get;set;}
        public List<Journey_Management_Planning__c> lstJourneyMgmtPlanInner {get;set;}
        
   /*     public integer compareTo(Object compareTo)
        {
            JourneyMgMt_Plan jmp = (JourneyMgMt_Plan) compareTo;
            if(Integer.valueOf(jmp.strSectionNo)>Integer.valueOf(this.strSectionNo))
                return 0;
            else 
                return 1;
        }*/
    }


/* ------------------
    Constructor
----------------------*/    
    public JourneyManagementPlan_Inline(ApexPages.StandardController controller)
    {
        this.stdController = controller;
        isNA=true;          
        isEditable = true;
        isTrackingOn=false;
        journeyManagementPlan= new Journey_Management_Planning__c();
        isTableRendedered = true;
        buttonName='Add';
        
        listJourneyManagement=[select id,section_name__c from Journey_Management__c where Is_Active__c =: true];
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
            sectionTitle='Edit Journey Management Plan';
            hiddenNavigator='New1';
            hiddenNavigator1='testValue1'; 
            isActive=true; 
            rerenderText='form3,msg,PanelForButton';  
             
            // To get the Tech Assessment record which we want to edit  
            op=[select Active__c,Cloned_From__c,Comments__c,Deliverable_Name__c,
                Deliverable_Number__c,Journey_Management_Deliverable_Id__c,
                Journey_Management_Id__c,Planned_End_Date__c,Planned_Start_Date__c,
                Responsibility__c,Section_Name__c,Section_Number__c,isEditVisible__c ,
                Version__c,Wave_Plan_Version__c,Wave_Plan_Version__r.active__c, Wave_Plan_Version__r.Display_tracking_message__c 
                from Journey_Management_Planning__c where id=:processId];
                
            if(op.size()>0)
            {
                journeyManagementPlan =op[0];
                strWavePlanVersionId =op[0].Wave_Plan_Version__c;
                
                buttonName='Update';
                isTableRendedered=false;
                valueOfActiveField=op[0].isEditVisible__c ;
                isWaveVersionActive=op[0].Wave_Plan_Version__r.active__c;
                strSectionName = op[0].Journey_Management_Id__c;
                if(op[0].Wave_Plan_Version__r.Display_tracking_message__c=='Tracking is On')
                {
                    isWaveVersionActive=false;    
                }
                List<Journey_Management_Deliverable__c> lstActivityMaster = [select id, Deliverable_Name__c, Deliverable_Number__c from Journey_Management_Deliverable__c where Deliverable_Name__c =:op.get(0).Deliverable_Name__c and Deliverable_Number__c=:op.get(0).Deliverable_Number__c];
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
                sectionTitle='Add New Journey Management Plan';
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
      /*  if(CheckProfile.isMobLeadershipProfile()&& processId==null)
        {
            isAddVisible = false;
            isWaveVersionActive = false;
        }
        else
            isAddVisible = true; */
             
        // For UAM
        if(processId==null)
        {
            isAddVisible = UAMSolMobUtility.isAddVisible_JMPlan; 
            isWaveVersionActive = UAMSolMobUtility.isWaveVersionActive_JMPlan;   
              
            if(UAMSolMobUtility.isNA_JMPlan)
            {
                isNA=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your Administrator.'));
                return;
            }
           /* List<wave_plan_version__c> lstDeal = [select deal__c from wave_plan_version__c where id = : strWavePlanVersionId ];
            String strDealId = lstDeal.get(0).deal__c;
            UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckUserRole(strDealId,'Journey_Management_Planning__c');
            isAddVisible = m.get('C');
            isWaveVersionActive = m.get('U');
            if(m.get('NA')==true)
            {
                isNA=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your Administrator.'));
                return;
            }  */                                                                           
            if(isTrackingOn==true || lstWave[0].active__c==false)
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
        List<Journey_Management_Planning__c> lstJourneyPlan = [select id,name,Active__c,Cloned_From__c,Comments__c,Deliverable_Name__c,Deliverable_Number__c,
                                                                Journey_Management_Deliverable_Id__c,Journey_Management_Id__c,
                                                                Planned_End_Date__c,Planned_Start_Date__c,Responsibility__c,
                                                                Section_Name__c,Section_Number__c,Version__c,
                                                                Wave_Plan_Version__c ,isEditVisible__c, Is_From_Add_Section__c,Milestone__c 
                                                                from Journey_Management_Planning__c 
                                                                where Wave_Plan_Version__c =:strWavePlanVersionId
                                                                order by Section_Number__c,Deliverable_Number__c asc]; 
        
        listOfLoactionDetailsActual = new Journey_Management_Planning__c[]{};                                                       
        
        if(lstJourneyPlan.size()>0)
        {
            for(Journey_Management_Planning__c profDet : lstJourneyPlan)
            {
                listOfLoactionDetailsActual.add(profDet);                
            }
        }                                                                 
                                                                
        // List for master ids in  journey planning                                                       
        set<Id> lstSectionIds = new set<Id>();  
        
        // Add ids of master in journey planning records to list  
        if(lstJourneyPlan.size()>0)
        {                                                             
            for(Journey_Management_Planning__c tmp : lstJourneyPlan )
            {
               lstSectionIds.add(tmp.Journey_Management_Id__c);
            }
        }

        // Fetch only those records from master which has id in journey planning records
        List<Journey_Management__c> lstJourneyMgmt = [select id, name,section_number__c, section_name__c from journey_management__c where id in :lstSectionIds  order by section_number__c];
        
        JourneyMgMt_Plan journeyMgmtPlan;
        lstJourneyMgmtPlan = new List<JourneyMgMt_Plan>();
        
        Journey_Management_Planning__c journeyPlan;
        List<Journey_Management_Planning__c > lstJourneyPlan2 = new List<Journey_Management_Planning__c >();
        
        for(Journey_Management__c tmpJourneyMgmt : lstJourneyMgmt)
        {
            lstJourneyPlan2 = new List<Journey_Management_Planning__c >();
            journeyMgmtPlan = new JourneyMgMt_Plan();
            journeyMgmtPlan.journeyMgmt=  tmpJourneyMgmt;
            for(Journey_Management_Planning__c tmpJourneyPlan :lstJourneyPlan )
            {
                if(tmpJourneyMgmt.id==tmpJourneyPlan.Journey_Management_Id__c)
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
        //lstJourneyMgmtPlan.sort();
        journeyManagementPlan = new Journey_Management_Planning__c();   
                       
    }
    
    public void activeRecords(String waveId){
    List<Journey_Management_Planning__c> lstWPVInfo = [Select id, Active__c, Planned_End_Date__c, Planned_Start_Date__c from Journey_Management_Planning__c where Wave_Plan_Version__c=:strWavePlanVersionId];
           
            if(lstWPVInfo.size()>0)
            {
                for(Journey_Management_Planning__c tmpTrack : lstWPVInfo )
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
        journeyManagementPlan.Journey_Management_Id__c = strSectionName;
        List<Journey_Management__c> lstJourneyMgmtTemp=[select id, Section_Name__c, Section_Number__c  from Journey_Management__c where id=:strSectionName AND Is_Active__c =: true];
        if(lstJourneyMgmtTemp.size()>0)
        {
            journeyManagementPlan.Section_Name__c = lstJourneyMgmtTemp[0].Section_Name__c; 
            journeyManagementPlan.Section_Number__c = lstJourneyMgmtTemp[0].Section_Number__c;
        }
        journeyManagementPlan.Wave_Plan_Version__c =strWavePlanVersionId ;
         if( buttonName == 'Add' || journeyManagementPlan.active__c == true)
         {
            if(strSectionName==null||journeyManagementPlan.Deliverable_Name__c==null || journeyManagementPlan.Planned_Start_Date__c==null || journeyManagementPlan.Planned_End_Date__c==null || journeyManagementPlan.Responsibility__c==null)
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
        List<Journey_Management_Planning__c > lstJourneyPlan;
        if( buttonName=='Add')
        {
            lstJourneyPlan = [select id from Journey_Management_Planning__c where ((Deliverable_Name__c=:journeyManagementPlan.Deliverable_Name__c  and Journey_Management_Id__c=:journeyManagementPlan.Journey_Management_Id__c) ) and Wave_plan_version__c = :strWavePlanVersionId ];
            journeyManagementPlan.Is_From_Add_Section__c = true;
            
        }            
        else if( buttonName=='Update')    
            lstJourneyPlan = [select id from Journey_Management_Planning__c where ((Deliverable_Name__c=:journeyManagementPlan.Deliverable_Name__c  and Journey_Management_Id__c=:journeyManagementPlan.Journey_Management_Id__c) ) and id<> :journeyManagementPlan.id and Wave_plan_version__c = :strWavePlanVersionId ];
        
        if(lstJourneyPlan.size()>0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record with same deliverable name or deliverable number already exists.'));
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
        List <Journey_Management__c> lstJourney=[select id,section_name__c from Journey_Management__c where Is_Active__c =: true];
        if(lstJourney.size()>0)
        {
            for(Journey_Management__c c:lstJourney)
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
        List<Journey_Management_Planning__c > lstJourneyPlan = [select id from Journey_Management_Planning__c where ((Deliverable_Name__c=:journeyManagementPlan.Deliverable_Name__c  and Journey_Management_Id__c=:journeyManagementPlan.Journey_Management_Id__c) or Deliverable_Number__c=:journeyManagementPlan.Deliverable_Number__c) and id<> :journeyManagementPlan.id and Wave_plan_version__c = :strWavePlanVersionId ];
        
        if(lstJourneyPlan.size()>0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record with same deliverable name or deliverable number already exists.'));
            return;
        }  
            List<Journey_Management_Planning__c > tempJourneyList=[Select id, Active__c from Journey_Management_Planning__c where id=:processId];
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
        List<Journey_Management_Planning__c> oldListOfLoactionDetailsActual  = [select id,name,Active__c,Cloned_From__c,Comments__c,Deliverable_Name__c,Deliverable_Number__c,
                                                                Journey_Management_Deliverable_Id__c,Journey_Management_Id__c,
                                                                Planned_End_Date__c,Planned_Start_Date__c,Responsibility__c,
                                                                Section_Name__c,Section_Number__c,Version__c,
                                                                Wave_Plan_Version__c ,isEditVisible__c, Is_From_Add_Section__c,Milestone__c 
                                                                from Journey_Management_Planning__c 
                                                                where Wave_Plan_Version__c =:strWavePlanVersionId
                                                                order by Section_Number__c,Deliverable_Number__c asc];
        List<Wave_Planning__c> lstDealWave =[select GO_Live_Date_del__c, id, name,Deal_Location__c from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__c=:strWavePlanVersionId];
        Integer count=0;
        for(Journey_Management_Planning__c tmpJMPlan : listOfLoactionDetailsActual)    
        {
            
              if(tmpJMPlan.Planned_Start_Date__c!=null && tmpJMPlan.Planned_End_Date__c!=null)
              {
                  if(tmpJMPlan.Planned_Start_Date__c > tmpJMPlan.Planned_End_Date__c)
                  {
                    //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned start date can not be greater than end date for this Section Name : '+tmpJMPlan.Section_Name__c +' and Deliverable : '+tmpJMPlan.Deliverable_Name__c));
                    //return;
                    tmpJMPlan.Planned_End_Date__c.addError('Planned End Date should be greater than Planned Start Date');
                    error = true;
                  }
              }
          
             if(tmpJMPlan.comments__c ==null && tmpJMPlan.active__c==false)
             {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                //return;
                tmpJMPlan.Comments__c.addError('Comment is Mandatory if record is marked as Inactive');
                error = true;
             }
             
             if(tmpJMPlan.active__c==false && tmpJMPlan.Milestone__c==true)
              {
                 tmpJMPlan.comments__c.addError('An inactive activity cannot be a milestone activity');
                 error = true;
              } 
                                 
             if(tmpJMPlan.Milestone__c==true && tmpJMPlan.Planned_End_Date__c==null)
             {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned End Date is Mandatory if Milestone is active'));
                //return;
                tmpJMPlan.Planned_End_Date__c.addError('Planned End Date is Mandatory if Milestone is active');
                error = true;
            }
            
            for(Journey_Management_Planning__c  tempOldList: oldListOfLoactionDetailsActual)
            {
                if(tempOldList.id!=tmpJMPlan.id && tempOldList.Deliverable_Name__c  == tmpJMPlan.Deliverable_Name__c && tempOldList.Deliverable_Number__c  == tmpJMPlan.Deliverable_Number__c && tempOldList.Journey_Management_Id__c == tmpJMPlan.Journey_Management_Id__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record with same deliverable name or deliverable number already exists.'));
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