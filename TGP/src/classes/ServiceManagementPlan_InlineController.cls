/*
Author : Sushmanth Hasti
Story: MOB_056
Description: To Add/update records for Service Management Plan object on high level plan

Updated by          Story no                Update Date        Update details
------------      -----------------        --------------    -------------------------------------------------------------
Varsha Chougule      MOB_131                  31-may-2013       Active inactive
*/

public class ServiceManagementPlan_InlineController
{
    public ApexPages.StandardController stdController;
    public String strWavePlanVersionId {get;set;}
    public Integer col1{get;set;}
    public Integer col2{get;set;}
    public Integer col3{get;set;}
    public Boolean refreshPage {get; set;}
    public Service_Management__c serviceManagementPlan{get;set;}
    public Service_Management__c[] listOfLoactionDetailsActual {get;set;}
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
    public List<ServiceMgMt_Plan> lstServiceMgmtPlan{get; set;}
    Public String strSectionName{get;set;}
    public List<Service_Management_Master__c> listServiceManagement{get;set;}
    List<Service_Management__c> op{get;set;}
    public boolean isRecordDeactivated{get;set;}
    public boolean valueOfActiveField{get;set;}
    public boolean isNA{get; set;}
    public boolean isEdit{get; set;}
    

//    Wrapper class
    
    public class ServiceMgMt_Plan
    {
        public Service_Management_Master__c serviceMgmt {get;set;}
        public String noOfSpaces{get;set;}
        public List<Service_Management__c> lstServiceMgmtPlanInner {get;set;}
        public boolean isTaskPresent{get;set;}
    }


/* ------------------
    Constructor
----------------------*/    
    public ServiceManagementPlan_InlineController(ApexPages.StandardController controller)
    {
        this.stdController = controller;
        isEditable = true;
        isTrackingOn=false;
        isNA=true;
        serviceManagementPlan= new Service_Management__c();
        isTableRendedered = true;
        buttonName='Add';
        
        listServiceManagement=[select id,Phase_Name__c from Service_Management_Master__c where Is_Active__c =: true];
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
            sectionTitle='Edit Service Management Plan';
            hiddenNavigator='New1';
            hiddenNavigator1='testValue1'; 
            isActive=true; 
            rerenderText='form3,msg,PanelForButton';  
             
            // To get the Service Management record which we want to edit  
            op=[select Active__c,Comments__c,Phase_ID__c,
                Planned_End_Date__c,Planned_Start_Date__c,Task_Name__c,Resource_Name__c,
                Phase_Name__c,Version__c,Wave_Plan_Version__c,Wave_Plan_Version__r.active__c, 
                Wave_Plan_Version__r.Display_tracking_message__c,isEditVisible__c  
                from Service_Management__c where id=:processId];
                
            if(op.size()>0)
            {
                serviceManagementPlan =op[0];
                strWavePlanVersionId =op[0].Wave_Plan_Version__c;
                
                buttonName='Update';
                isTableRendedered=false;
                valueOfActiveField=op[0].isEditVisible__c ;
                isWaveVersionActive=op[0].Wave_Plan_Version__r.active__c;
                strSectionName = op[0].Phase_ID__c;
                if(op[0].Wave_Plan_Version__r.Display_tracking_message__c=='Tracking is On')
                {
                    isWaveVersionActive=false;    
                }
                List<Service_Management_Task_Master__c> lstActivityMaster = [select id, Task_Name__c from Service_Management_Task_Master__c where Task_Name__c =:op.get(0).Task_Name__c ];
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
                sectionTitle='Add Service Management Plan';
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
        /* if(CheckProfile.isMobLeadershipProfile()&& processId==null)
        {
            isAddVisible = false;
            isWaveVersionActive = false;
        }
        else
            isAddVisible = true; */
             
        // For UAM
        if(processId==null)
        {        
            /* List<wave_plan_version__c> lstDeal = [select deal__c from wave_plan_version__c where id = : strWavePlanVersionId ];
            String strDealId = lstDeal.get(0).deal__c;
            UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckUserRole(strDealId,'Service_Management__c');
            isAddVisible = m.get('C');
            isWaveVersionActive = m.get('U');
            if(m.get('NA'))
            {
                isNA=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your administrator.'));
                return;
            }
            */
            
            isAddVisible = UAMSolMobUtility.isAddVisible_SMPlan;
            isWaveVersionActive = UAMSolMobUtility.isWaveVersionActive_SMPlan;
            
            if(UAMSolMobUtility.isNA_SMPlan)
            {
                isNA=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your administrator.'));
                return;
            }
            
                                                                   
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

        
        
                List<Service_Management_Master__c> lstServiceMgmt = [select id, name,Phase_Name__c,Phase_Number__c,Number_of_spaces__c from Service_Management_Master__c where Is_Active__c =: true  order by Phase_Number__c];
        List<Service_Management__c> lstServicePlan = [select id, Active__c,Comments__c,Phase_ID__c,isEditVisible__c ,
                                                                Planned_End_Date__c,Planned_Start_Date__c,Task_Name__c,Task_Number__c,Resource_Name__c, Phase_Name__c, 
                                                                Version__c,Wave_Plan_Version__c,Wave_Plan_Version__r.active__c, Wave_Plan_Version__r.Display_tracking_message__c, Is_From_Add_Section__c, Milestone__c
                                                                from Service_Management__c 
                                                                where Wave_Plan_Version__c =:strWavePlanVersionId order by Task_Number__c];  
                                                                
                                                                
         listOfLoactionDetailsActual = new Service_Management__c[]{};                                                       
        
        if(lstServicePlan.size()>0)
        {
            for(Service_Management__c profDet : lstServicePlan)
            {
                listOfLoactionDetailsActual.add(profDet);                
            }
        } 
        
        ServiceMgMt_Plan serviceMgmtPlan;
        lstServiceMgmtPlan = new List<ServiceMgMt_Plan>();
        
        Service_Management__c servicePlan;
        List<Service_Management__c > lstServicePlan2 = new List<Service_Management__c >();
        boolean isTask =true;
        
        for(Service_Management_Master__c tmpServiceMgmt : lstServiceMgmt)
        {
            lstServicePlan2 = new List<Service_Management__c >();
            serviceMgmtPlan = new ServiceMgMt_Plan();
            serviceMgmtPlan.serviceMgmt =  tmpServiceMgmt;
            String noOfSpace='';
            Integer i=0;
            if(tmpServiceMgmt.Number_of_spaces__c !=null)
            {
                for(i=0; i<tmpServiceMgmt.Number_of_spaces__c; i++ )
                {
                    noOfSpace=noOfSpace+'  '; 
                }      
            }
            serviceMgmtPlan.noOfSpaces= noOfSpace;
            for(Service_Management__c tmpServicePlan :lstServicePlan )
            {
                if(tmpServiceMgmt.id==tmpServicePlan.Phase_ID__c)
                {
                    lstServicePlan2.add(tmpServicePlan);
                }
            }
            if(lstServicePlan2.size()>0)
            {
                serviceMgmtPlan.lstServiceMgmtPlanInner = lstServicePlan2;
                if(isTask==true )
                    serviceMgmtPlan.isTaskPresent = true;
                else
                    serviceMgmtPlan.isTaskPresent = false;   
                isTask=true;
            }
            else if(lstServicePlan2.size()==0)
            {
                if(isTask==true )
                    serviceMgmtPlan.isTaskPresent = true;
                else
                    serviceMgmtPlan.isTaskPresent = false;    
                isTask=false;
            }
            lstServiceMgmtPlan.add(serviceMgmtPlan);
            serviceManagementPlan = new Service_Management__c();
        }                       
    }
    
    public void activeRecords(String waveId){
    
        List<Service_Management__c> lstWPVInfo = [Select id, Active__c, Planned_Start_Date__c,Planned_End_Date__c  from Service_Management__c where Wave_Plan_Version__c =:waveId];       
        if(lstWPVInfo.size()>0)
        {
            for(Service_Management__c tmpTrack : lstWPVInfo )
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
    Method Name: saveServicePlan
    Description:This method is used to initialize the records.
    Paramenters: NA
    Return Value: void
    *******************************/ 
    public void saveServicePlan()
    {
        displayStr = (buttonName == 'Add')? 'Added' : 'Updated';
        serviceManagementPlan.Phase_ID__c= strSectionName;
         //BG SCP Fix insert start
        List<Service_Management_Master__c> secName=[Select id, name,Phase_Name__c,Phase_Number__c,Number_of_spaces__c from Service_Management_Master__c where id=: strSectionName];
        serviceManagementPlan.Phase_Name__c = secName[0].Phase_Name__c;
        //BG SCP Fix update End
        serviceManagementPlan.Wave_Plan_Version__c =strWavePlanVersionId ;
         if( buttonName == 'Add' || serviceManagementPlan.active__c == true)
         {
            if(strSectionName==null||serviceManagementPlan.Task_Name__c==null || serviceManagementPlan.Planned_Start_Date__c==null || serviceManagementPlan.Planned_End_Date__c==null || serviceManagementPlan.Resource_Name__c==null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Mandatory fields are not present.'));
                return;
            }
         }
         else
         {
             if(serviceManagementPlan.comments__c ==null && serviceManagementPlan.active__c==false)
             {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                return;
             }
         }
        if(serviceManagementPlan.Planned_Start_Date__c > serviceManagementPlan.Planned_End_Date__c)         
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned start date cannot be greater than end date.'));
            return;
        }
        List<Service_Management__c > lstServicePlan;
        if( buttonName=='Add')
        {
            lstServicePlan = [select id from Service_Management__c where (Task_Name__c=:serviceManagementPlan.Task_Name__c ) and Phase_ID__c=:strSectionName];
            serviceManagementPlan.Is_From_Add_Section__c = true;
        }
        else if( buttonName=='Update')    
       lstServicePlan = [select id from Service_Management__c where (Task_Name__c=:serviceManagementPlan.Task_Name__c) and Phase_ID__c=:strSectionName and id<> :serviceManagementPlan.id and Wave_plan_version__c = :strWavePlanVersionId];            
       if(lstServicePlan.size()>0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record with same Task name already exists.'));
            return;
        } 
        
       if(buttonName=='Update'&& serviceManagementPlan.active__c==false)
       {
           serviceManagementPlan.isEditVisible__c=false;
       }
              
        upsert serviceManagementPlan;
        if( buttonName=='Add')
        {
            valueOfActiveField=true;
        }
        else if( buttonName=='Update')
        {
            valueOfActiveField=serviceManagementPlan.active__c;
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
        List <Service_Management_Master__c> lstService=[select id,Phase_Name__c from Service_Management_Master__c where Is_Active__c =: true];
        if(lstService.size()>0)
        {
            for(Service_Management_Master__c c:lstService)
            {
                secName.add(new SelectOption(c.id, c.Phase_Name__c)); 
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
            if(serviceManagementPlan.comments__c ==null && serviceManagementPlan.active__c==false)
             {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                return;
             }      
           List<Service_Management__c > lstServicePlan = [select id from Service_Management__c where (Task_Name__c=:serviceManagementPlan.Task_Name__c) and Phase_ID__c=:strSectionName and id<> :serviceManagementPlan.id and Wave_plan_version__c = :strWavePlanVersionId];            
           if(lstServicePlan.size()>0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'123Record with same Task name already exists.'));
                return;
            }   
            List<Service_Management__c > tempServiceList=[Select id, Active__c from Service_Management__c  where id=:processId];
            if(tempServiceList.size()==1)
            {
                if(tempServiceList[0].active__c==true && serviceManagementPlan.active__c==false)
                {
                    isRecordDeactivated=true;
                }
                
            }    
        }
    }
    
    public void save()
    {

        Boolean error = false;
        List <Service_Management__c> oldListOfLoactionDetailsActual=[select id, Active__c,Comments__c,Phase_ID__c,isEditVisible__c ,
                                                                Planned_End_Date__c,Planned_Start_Date__c,Task_Name__c,Task_Number__c,Resource_Name__c, Phase_Name__c, 
                                                                Version__c,Wave_Plan_Version__c,Wave_Plan_Version__r.active__c, Wave_Plan_Version__r.Display_tracking_message__c, Is_From_Add_Section__c, Milestone__c
                                                                from Service_Management__c 
                                                                where Wave_Plan_Version__c =:strWavePlanVersionId order by Task_Number__c];
        //BG SCP Section Name update fix start
        Map<Id, String> scpSectionMasterIsWithName =  new Map<Id, String>();
        for(Service_Management_Master__c scpName : [select id,Phase_Name__c from Service_Management_Master__c]) {
        	scpSectionMasterIsWithName.put(scpName.Id, scpName.Phase_Name__c);	
      	}        
        //BG SCP Section Name update fix end
    
        for(Service_Management__c tmpSMPlan : listOfLoactionDetailsActual)   
        {
            tmpSMPlan.Phase_Name__c = scpSectionMasterIsWithName.get(tmpSMPlan.Phase_ID__c); //BG BCP Section Name update fix 
            if(tmpSMPlan.Planned_Start_Date__c > tmpSMPlan.Planned_End_Date__c)
            {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned start date can not be greater than end date for this Phase Name : '+tmpSMPlan.Phase_Name__c+' and Task : '+tmpSMPlan.Task_Name__c));
                //return;
                tmpSMPlan.Planned_End_Date__c.addError('Planned End Date should be greater than Planned Start Date');
                error = true;
            }
            
            if(tmpSMPlan.comments__c ==null && tmpSMPlan.active__c==false)
            {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                //return;
                tmpSMPlan.Comments__c.addError('Comment is Mandatory if record is marked as Inactive');
                error = true;
            }
            if(tmpSMPlan.active__c==false && tmpSMPlan.Milestone__c==true)
            {
                 tmpSMPlan.comments__c.addError('An inactive activity cannot be a milestone activity');
                 error = true;
            }    
            if(tmpSMPlan.Milestone__c==true && tmpSMPlan.Planned_End_Date__c==null)
             {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned End Date is Mandatory if Milestone is active'));
                //return;
                tmpSMPlan.Planned_End_Date__c.addError('Planned End Date is Mandatory if Milestone is active');
                error = true;
            }
            
            for(Service_Management__c tempOldList: oldListOfLoactionDetailsActual)
            {
                if(tempOldList.id!=tmpSMPlan.id && tempOldList.Task_Name__c == tmpSMPlan.Task_Name__c && tempOldList.Phase_ID__c== tmpSMPlan.Phase_ID__c)
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