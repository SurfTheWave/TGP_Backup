/*
Author : Malkeet Singh
Story  : MOB_120  
Description :  To add/update records in OPEX Plan

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Varsha Chougule  MOB_131                  31-may-2013       Active inactive

*/
public with sharing class OPEXPlanController{
    public String wavePlanVersionId{get;set;}
    public String strDealId{get;set;}
    public String locationName{get;set;}
    public Integer col1{get;set;}
    public Integer col2{get;set;}
    public Integer col3{get;set;}
    public String wavePlanName{get;set;}
    public Boolean refreshPage {get; set;}
    public OPEX__c dealLocation {get;set;}
    public OPEX__c[] listOfLoactionDetailsActual {get;set;}
    public boolean isTableRendedered{get; set;}
    public String processId{get;set;}
    public String buttonName{get;set;}
    public Boolean isDateEnabled {get; set;} 
    public String sectionTitle{get;set;}
    public String hiddenNavigator{get;set;}
    public String hiddenNavigator1{get;set;}
    public Boolean isWaveVersionActive{get; set;}
    public Boolean isActive{get; set;}
    Public String rerenderText{get;set;}
    Public Boolean showForm{get;set;}
    Public String displayStr{get;set;}
    public boolean isAddVisible{get; set;}
    public boolean locationChange{get;set;}
    public boolean isEditable{get; set;}
    public boolean isRecordDeactivated{get;set;}
    public boolean valueOfActiveField{get;set;}
    public boolean isNA{get; set;}    
    public boolean isEdit {get;set;}
    public String soqlQuery {get;set;}
    public List<OPEX__c> rTrackingPageSize {get;set;}
    public Boolean disablePrevious1{get; set;}
    public Boolean disableNext1{get; set;}
    /******************************
    Method Name: OPEXPlanController
    Description: This is Constructor for the OPEXPlanController class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/  
    public OPEXPlanController(ApexPages.StandardController stdCon) 
    {
        isNA=true;
        isAddVisible = false;
        isTableRendedered = true;
        buttonName='Add';
        dealLocation = new OPEX__c();
        // Getting Id of Wave Plan Version 
        wavePlanVersionId=ApexPages.CurrentPage().getParameters().get('id');

        // Getting Id of record which we want to edit
        processId=ApexPages.CurrentPage().getParameters().get('processId');
        
        //for Edit Operation
        if(processId!=null)
        {
            isAddVisible = true;
            showForm=true;
            col1=1;
            col2=1;
            col3=1;
            sectionTitle='Edit Operational Maturity Plan';
            hiddenNavigator='New1';
            hiddenNavigator1='testValue1';
            isActive=true; 
            rerenderText='form3,msg,PanelForButton';   
            
            // To get the OPEX record which we want to edit
            List<OPEX__c> op=[Select id,Wave_Plan_Version__r.active__c,Wave_Plan_Version__r.deal__c,Wave_Plan_Version__r.Display_tracking_message__c,
                                Wave_Plan_Version__c,Active__c,Item__c,Deal_Location_lk__c,Planned_Date__c, Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c, 
                                Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,comments__c,isEditVisible__c, Wave_Process__c,   
                                Wave_Process__r.Client_Specific_Process_Mapping__r.name from OPEX__c where id=:processId];
            if(op.size()>0)
            {
                dealLocation=op[0];
                locationName=op[0].Deal_Location_lk__c;
                wavePlanName=op[0].Wave_Plan_lk__c;
                wavePlanVersionId=op[0].Wave_Plan_Version__c;
                strDealId=op[0].Wave_Plan_Version__r.deal__c;
                buttonName='Update';
                isTableRendedered=false;
                valueOfActiveField=op[0].isEditVisible__c ;
                isWaveVersionActive=op[0].Wave_Plan_Version__r.active__c;
                if(op[0].Wave_Plan_Version__r.Display_tracking_message__c=='Tracking is On')
                {
                    isWaveVersionActive=false;    
                }
                List<OPEX_Item_Master__c> lstActivityMaster = [select id, Item_Name__c from OPEX_Item_Master__c where Item_Name__c =:op.get(0).Item__c and Is_Active__c =: true];
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
                col2=3;
                col3=3;
                sectionTitle='Add New OPEX Plan';
                initializeDetailRecords();
                hiddenNavigator='New';
                hiddenNavigator1='testValue';
                isActive=false;      
                rerenderText='form3,frm,msg'; 
                valueOfActiveField=true; 
                List<Delievery_Location_Master__c> loc=new List<Delievery_Location_Master__c>();
                List<Deal_Location__c> c=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__c from Deal_Location__c where Wave_Plan_Version__c=:wavePlanVersionId order by Deal_Home_Location__r.Delivery_Location_Master__r.name];        
                if(c.size()>0)
                {
                    locationName= c[0].id;
                }
                else
                {
                    locationName='None';
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
        */
        // For UAM
        
            /*List<wave_plan_version__c> lstDeal = [select deal__c from wave_plan_version__c where id = : wavePlanVersionId];
            strDealId = lstDeal.get(0).deal__c;
            
            UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckUserRole(strDealId,'OPEX__c');
           // isAddVisible = m.get('C');
            isWaveVersionActive = m.get('U');
            if(m.get('NA')==true)
            {
                isNA=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your administrator.'));
                return;
            }
            */
            //isAddVisible = m.get('C');;
            isWaveVersionActive = UAMSolMobUtility.isWaveVersionActive_Opex;
         
            if(UAMSolMobUtility.isNA_Opex)
            {
                isNA = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your administrator.'));
                return;
            }
            
            List<Wave_Plan_Version__c> lstWave = [select active__c,Display_tracking_message__c from Wave_Plan_Version__c where id=:wavePlanVersionId];
            if(lstWave.size()>0)
            {
                //isWaveVersionActive = lstWave[0].active__c;
                if(lstWave[0].Display_tracking_message__c=='Tracking is On')
                {
                    isWaveVersionActive =false;  
                }
                if(lstWave[0].active__c==false)
                {
                    isWaveVersionActive =false;
                }
            }            
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
        List<SelectOption> LocName=new List<SelectOption>();
        if(locationName=='None')
        {
            LocName.add(new SelectOption('None','--None--'));
            return LocName;
        }
        List<Deal_Location__c> dealLocation=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c where Wave_Plan_Version__c=:wavePlanVersionId order by Deal_Home_Location__r.Delivery_Location_Master__r.name];
        if(dealLocation.size()>0)
        {
            for(Deal_Location__c c: dealLocation)
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
        if(locationName=='None')
        {
            wavePlans.add(new SelectOption('None','--None--'));
            wavePlanName='None';
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
            wavePlans.add(new SelectOption('None','--None--'));
            wavePlanName='None';
            return wavePlans;
        }
        if(locationChange==true)
        {
            changeDate();
        }
        locationChange=false;
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
    Description:This method is used to add/Update OPEX Plan records for a particalur wave version.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void addWaveProcessDetail() {
        if(buttonName== 'Update')
        {
            dealLocation.id=processId;
        }
        hiddenNavigator='Add';
        hiddenNavigator1='Add';
         if(dealLocation.active__c==true)
         {
            if(dealLocation.Item__c==null || dealLocation.Item__c==''||wavePlanName=='None'||locationName=='None'||dealLocation.Planned_Date__c==null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Mandatory fields are not present!'));
                return;
            }
         }
         else
         {
             if(dealLocation.comments__c ==null && buttonName== 'Update')
             {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                return;
             }
         }        
        List<Wave_Planning__c> wavePlanning=[select GO_Live_Date_del__c, id, name from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__c=:wavePlanVersionId and Deal_Location__c=:locationName  and id=:wavePlanName];
        if(wavePlanning.size()>0)
        {
            for(Wave_Planning__c wp: wavePlanning)
            {
                
                
                    if(dealLocation.Item__c!='Pre Go-Live Assessment' )
                    {
                        if(dealLocation.Planned_Date__c <= wp.GO_Live_Date_del__c)
                        {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned Date Cannot be Less than or Equal to Go Live Date!'));
                            return;
                        }
                    }
                
            }
        }
        List<Deal_Location__c> delLocHomeId=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c where id=:locationName];
        List<Wave_Planning__c> dealWaveName=[Select id,name,Wave_Label__c from Wave_Planning__c where id=:WavePlanName];

        dealLocation.Wave_Plan_Version__c=wavePlanVersionId;
        dealLocation.Deal_Location_lk__c=locationName;
        dealLocation.Wave_Plan_lk__c=wavePlanName;
        dealLocation.Location_Id_Wave_Id__c =String.valueof(locationName) + String.valueof(WavePlanName);
        dealLocation.Location_Name_Wave_Name__c =delLocHomeId[0].Deal_Home_Location__r.Delivery_Location_Master__r.name+ ' - ' +dealWaveName[0].Wave_Label__c; 
        
        try
        {
            List<OPEX__c> serviceList= [Select Item__c,Deal_Location_lk__c,Planned_Date__c, Wave_Plan_lk__c,Wave_Process__c,Wave_Process__r.Client_Specific_Process_Mapping__r.name 
                                        from OPEX__c  where Item__c = : dealLocation.Item__c and Deal_Location_lk__c = : dealLocation.Deal_Location_lk__c 
                                        and Wave_Plan_lk__c= :dealLocation.Wave_Plan_lk__c and Wave_Process__c=:dealLocation.Wave_Process__c and Wave_Plan_Version__c=:wavePlanVersionId limit 1];

            if(serviceList.size()>=1)
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
              displayStr='Added';
           }
        
           if(buttonName=='Update'&& dealLocation.active__c==false)
           {
               dealLocation.isEditVisible__c=false;
           }
            List<Wave_Planning__C> lstDealWave = [select NewActive__c from Wave_Planning__C where id= :wavePlanName ];
            {
                if(lstDealWave.size()>0 && lstDealWave.get(0).NewActive__c ==false )
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Wave is inactive for this record.'));
                    return;
                }
            }
           upsert dealLocation;
           valueOfActiveField=dealLocation.active__c;
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
        //dealLocation=new OPEX__c();
        return; 
    }
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
      }
     
      // the current field to sort by. defaults to last name
      public String sortField {
        //get  { if (sortField == null) {sortField = 'Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Wave_Plan_lk__r.Wave_Label__c'; } return sortField;  }
        get  { if (sortField == null) {sortField = 'Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Wave_Process__r.Client_Specific_Process_Mapping__r.name,Wave_Plan_lk__r.Wave_Label__c,Planned_Date__c'; } return sortField;  }
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
        hiddenNavigator1='Add';
        hiddenNavigator='Add';
        listOfLoactionDetailsActual=null;
        listOfLoactionDetailsActual = new OPEX__c[]{};
        List<OPEX__c> opex =[Select id,Active__c,Item__c,Checklist_Hyperlink__c,Deal_Location_lk__c,Planned_Date__c, Wave_Plan_lk__c, 
                            Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name ,Assessment_Status__c,
                            Comments__c,isEditVisible__c,Wave_Process__c,Wave_Process__r.Client_Specific_Process_Mapping__r.name, Location_Name_Wave_Name__c, Location_Id_Wave_Id__c, Milestone__c,
                            Wave_Plan_Version__r.Display_tracking_message__c,Wave_Plan_lk__r.Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c,Wave_Plan_lk__r.Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c, Wave_Plan_lk__r.Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c,
                            Is_Submitted__c,Wave_Plan_Version__r.Deal__r.Governance_Lead_Name_New__r.SFDC_User__c,Wave_Plan_Version__r.Deal__r.Governance_Lead_Name_Secondary_New__r.SFDC_User__c,Wave_Plan_Version__r.Deal__r.Governance_Lead_Name_Secondary_New_2__r.SFDC_User__c,  
                            Wave_Plan_Version__r.Deal__r.Program_Control_PMO_ID__c, Wave_Plan_Version__r.Deal__r.Program_Control_PMO_Secondary_ID__c, Wave_Plan_Version__r.Deal__r.Global_Mob_Lead_ID__c,Wave_Plan_Version__r.Deal__r.Program_Control_PMO_Secondary_2_ID__c ,
                            Wave_Plan_Version__r.Deal__r.Global_Mob_Lead_Secondary_ID__c, Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c, Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c, Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c, 
                            Wave_Plan_lk__r.KT_Lead_New__r.SFDC_User__c, Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c, Wave_Plan_Version__r.Deal__r.MOB_PMO_Project_ID__c, Wave_Plan_Version__r.Deal__r.Global_Mob_Lead_Secondary_2_ID__c ,
                            Wave_Plan_Version__r.Deal__r.MOB_PMO_Project_Secondary_ID__c, Wave_Plan_Version__r.Deal__r.MOB_PMO_Project_Secondary_2_ID__c,Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c  from OPEX__c 
                            where Wave_Plan_Version__c=:wavePlanVersionId  
                            order by Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Wave_Process__r.Client_Specific_Process_Mapping__r.name,Wave_Plan_lk__r.Wave_Label__c,Planned_Date__c ];

        // Query For Pagination
        soqlQuery='Select id,Active__c,Item__c,Checklist_Hyperlink__c,Deal_Location_lk__c,Planned_Date__c, Wave_Plan_lk__c,Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name';
        soqlQuery+=',Assessment_Status__c,Comments__c,isEditVisible__c,Wave_Process__c,Wave_Process__r.Client_Specific_Process_Mapping__r.name, Location_Name_Wave_Name__c, Location_Id_Wave_Id__c,';
        soqlQuery+='Milestone__c,Wave_Plan_Version__r.Display_tracking_message__c,Wave_Plan_lk__r.Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c,Wave_Plan_lk__r.Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c,';
        soqlQuery+='Wave_Plan_lk__r.Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c,Is_Submitted__c,Wave_Plan_Version__r.Deal__r.Governance_Lead_Name_New__r.SFDC_User__c,Wave_Plan_Version__r.Deal__r.Governance_Lead_Name_Secondary_New__r.SFDC_User__c,Wave_Plan_Version__r.Deal__r.Governance_Lead_Name_Secondary_New_2__r.SFDC_User__c,';
        soqlQuery+='Wave_Plan_Version__r.Deal__r.Program_Control_PMO_ID__c, Wave_Plan_Version__r.Deal__r.Program_Control_PMO_Secondary_ID__c, Wave_Plan_Version__r.Deal__r.Global_Mob_Lead_ID__c,Wave_Plan_Version__r.Deal__r.Program_Control_PMO_Secondary_2_ID__c,';
        soqlQuery+='Wave_Plan_Version__r.Deal__r.Global_Mob_Lead_Secondary_ID__c, Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c, Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c, Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c,';
        soqlQuery+='Wave_Plan_lk__r.KT_Lead_New__r.SFDC_User__c, Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c, Wave_Plan_Version__r.Deal__r.MOB_PMO_Project_ID__c, Wave_Plan_Version__r.Deal__r.Global_Mob_Lead_Secondary_2_ID__c ,';
        soqlQuery+='Wave_Plan_Version__r.Deal__r.MOB_PMO_Project_Secondary_ID__c, Wave_Plan_Version__r.Deal__r.MOB_PMO_Project_Secondary_2_ID__c,Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c  from OPEX__c where Wave_Plan_Version__c=:wavePlanVersionId';
        //Query For Pagination over   
              List<OPEX__c> List_opex = Database.query(soqlQuery  + ' order by ' + sortField + ' ' + sortDir + ' LIMIT '+list_size +' OFFSET '+ counter );
               rTrackingPageSize  = Database.query(soqlQuery); 
        total_size =rTrackingPageSize.size();                    
        if(opex.size()>0)
        {
            for(OPEX__c profDet : List_opex) 
            {
                listOfLoactionDetailsActual.add(profDet);                
            }
           
        }    
    }
    
    /*
     * @Class Name   : OPEX 
     * @Method Name  : OPEX with parameters
     * @Description  : Class for OPEX with CheckList 
     * @Paramenters  : NA
     * @Return Value : NA
     */
    public class OPEXNewList
    {
        public OPEX__c newOPEX{get; set;}
        public String item {get; set;}
        public String locationWave {get; set;}
        public String clientSpecificProcessMappingName {get; set;}
        public Date plannedDate {get; set;} 
        public Boolean active {get; set;} 
        public Boolean milestone {get; set;} 
        public String comments {get; set;} 
        public String assessmentStatus {get; set;}
        public Boolean isEditVisible{get;set;}
        public String ChecklistHyperlink{get;set;}
        public Boolean isTrackerOff {get; set;} 
        public Boolean isRecordDeactivated {get; set;} 
        public Boolean isclickforChecklist {get; set;} 
        public Boolean isViewSubmitted {get; set;} 
        public Boolean isNoPrivilege {get; set;} 
       
        
    /*
     * @Method Name  : OPEX 
     * @Description  : Class for OPEX with parameters
     * @Paramenters  : OPEX__c,String, boolean, String are the parameters passing to OPEX contructor
     * @Return Value : NA
     */
        public OPEXNewList(OPEX__c newOPEX,String item, String locationWave, String clientSpecificProcessMappingName, date plannedDate, 
                            boolean active, boolean milestone, String comments, String assessmentStatus, boolean isEditVisible, String ChecklistHyperlink, 
                            boolean isTrackerOff,boolean isRecordDeactivated,boolean isclickforChecklist,boolean isViewSubmitted,boolean isNoPrivilege)
        {
            this.newOPEX=newOPEX;
            this.item=item; 
            this.locationWave=locationWave;
            this.clientSpecificProcessMappingName=clientSpecificProcessMappingName; 
            this.plannedDate=plannedDate; 
            this.active=active;
            this.milestone=milestone;
            this.comments=comments;
            this.assessmentStatus=assessmentStatus;
            this.isEditVisible=isEditVisible;
            this.ChecklistHyperlink=ChecklistHyperlink;
            this.isTrackerOff=isTrackerOff;
            this.isRecordDeactivated=isRecordDeactivated;
            this.isclickforChecklist=isclickforChecklist;
            this.isViewSubmitted=isViewSubmitted;   
            this.isNoPrivilege=isNoPrivilege;       
        }       
    }
    
    /******************************
     *@ Method Name: getListOfOPEX
     *@ Description: Method to get the list of OPEX with CheckList.  
     *@ Paramenters: NA
     *@ Return Value: List<OPEX>
    *******************************/
    public List<OPEXNewList> getListOfOPEX()
    {
        List<OPEXNewList> listOfOPEX=new List<OPEXNewList>();
        String item=null;
        String locationWave=null;
        String clientSpecificProcessMappingName=null;
        Date plannedDate=null;
        Boolean active=null;
        Boolean milestone=null;
        String comments=null; 
        String assessmentStatus=null;
        Boolean isEditVisible=null;
        String ChecklistHyperlink=null;
        Boolean isTrackerOff=null;
        Boolean isRecordDeactivated=null;
        Boolean isclickforChecklist=null;
        Boolean isViewSubmitted=null;
        Boolean isNoPrivilege=null;
        String strUserId = UserInfo.getUserId();
        
        
        String userProfileName = [select u.Profile.Name from User u where u.id = :strUserId].Profile.Name; //Get users with Profile Name
        if(listOfLoactionDetailsActual.size()>0)
        {
            for(OPEX__c opx:listOfLoactionDetailsActual)
            {
                strUserId = strUserId.substring(0,15);
                item=opx.Item__c;                
                locationWave=opx.Location_Name_Wave_Name__c;
                clientSpecificProcessMappingName=opx.Wave_Process__r.Client_Specific_Process_Mapping__r.name;
                plannedDate=opx.Planned_Date__c;
                active=opx.Active__c;
                milestone=opx.Milestone__c;
                comments=opx.Comments__c;
                assessmentStatus=opx.Assessment_Status__c;
                isEditVisible=opx.isEditVisible__c;
                String tempId=opx.Id;
                if(opx.Wave_Plan_Version__r.Display_tracking_message__c == null)
                {
                    ChecklistHyperlink='Tracking is OFF';
                    isTrackerOff=true;
                    isRecordDeactivated=false;
                    isclickforChecklist=false;
                    isViewSubmitted=false;
                    isNoPrivilege=false;
                }else 
                {  
                    if(opx.Active__c == false){                 
                        ChecklistHyperlink='Record Deactivated';
                        isRecordDeactivated=true;
                        isTrackerOff=false;
                        isclickforChecklist=false;
                        isViewSubmitted=false;
                        isNoPrivilege=false;
                    }else
                    {
                        if(opx.Wave_Plan_lk__r.Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c == strUserId || opx.Wave_Plan_lk__r.Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c == strUserId || opx.Wave_Plan_lk__r.Mobilization_Opex_Lead_Secondary_2__r.SFDC_User__c == strUserId
                        || userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)
                        || userProfileName.equalsIgnoreCase(System.Label.Mobilization_Regional_Leadership) || userProfileName.equalsIgnoreCase(System.Label.Mobilization_Admin)
                         || opx.Wave_Plan_Version__r.Deal__r.Program_Control_PMO_ID__c == strUserId ||
                            opx.Wave_Plan_Version__r.Deal__r.Program_Control_PMO_Secondary_ID__c == strUserId ||
                            opx.Wave_Plan_Version__r.Deal__r.Program_Control_PMO_Secondary_2_ID__c == strUserId ||
                            opx.Wave_Plan_Version__r.Deal__r.Global_Mob_Lead_ID__c == strUserId ||
                            opx.Wave_Plan_Version__r.Deal__r.Global_Mob_Lead_Secondary_ID__c== strUserId ||
                            opx.Wave_Plan_Version__r.Deal__r.Global_Mob_Lead_Secondary_2_ID__c== strUserId ||
                            opx.Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c == strUserId ||
                            opx.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c == strUserId ||
                            opx.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c == strUserId ||
                            opx.Wave_Plan_lk__r.KT_Lead_New__r.SFDC_User__c == strUserId ||
                            opx.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c == strUserId ||
                            opx.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c == strUserId ||
                            opx.Wave_Plan_Version__r.Deal__r.MOB_PMO_Project_ID__c == strUserId ||
                            opx.Wave_Plan_Version__r.Deal__r.MOB_PMO_Project_Secondary_ID__c == strUserId ||
                            opx.Wave_Plan_Version__r.Deal__r.MOB_PMO_Project_Secondary_2_ID__c == strUserId
                            )
                        {
                            if(opx.Is_Submitted__c == false)
                            {
                                ChecklistHyperlink= System.URL.getSalesforceBaseUrl().toExternalForm()+'/apex/OPEXCheckListPage?id='+tempId;
                                isclickforChecklist=true;
                                isTrackerOff=false;
                                isRecordDeactivated=false;
                                isViewSubmitted=false;
                                isNoPrivilege=false;
                            }else
                            {
                            //  ChecklistHyperlink=HYPERLINK('/apex/OPEXQuestioniareCheckListReadOnlyPage?id=' & opx.Id, 'View Submitted Operational Maturity', '_parent');
                                ChecklistHyperlink= System.URL.getSalesforceBaseUrl().toExternalForm()+'/apex/OPEXQuestioniareCheckListReadOnlyPage?id='+tempId;
                                isViewSubmitted=true;
                                isTrackerOff=false;
                                isRecordDeactivated=false;
                                isclickforChecklist=false;
                                isNoPrivilege=false;
                            
                            }
                        }else
                        {
                            if(opx.Wave_Plan_Version__r.Deal__r.Governance_Lead_Name_New__r.SFDC_User__c == strUserId ||
                            opx.Wave_Plan_Version__r.Deal__r.Governance_Lead_Name_Secondary_New__r.SFDC_User__c == strUserId ||
                            opx.Wave_Plan_Version__r.Deal__r.Governance_Lead_Name_Secondary_New_2__r.SFDC_User__c == strUserId 
                            //|| opx.Wave_Plan_Version__r.Deal__r.Program_Control_PMO_ID__c == strUserId ||
                            //opx.Wave_Plan_Version__r.Deal__r.Program_Control_PMO_Secondary_ID__c == strUserId ||
                            //opx.Wave_Plan_Version__r.Deal__r.Program_Control_PMO_Secondary_2_ID__c == strUserId ||
                            //opx.Wave_Plan_Version__r.Deal__r.Global_Mob_Lead_ID__c == strUserId ||
                            //opx.Wave_Plan_Version__r.Deal__r.Global_Mob_Lead_Secondary_ID__c== strUserId ||
                            //opx.Wave_Plan_Version__r.Deal__r.Global_Mob_Lead_Secondary_2_ID__c== strUserId ||
                            //opx.Deal_Location_lk__r.Deployment_Lead_New__r.SFDC_User__c == strUserId ||
                            //opx.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c == strUserId ||
                            //opx.Deal_Location_lk__r.Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c == strUserId ||
                            //opx.Wave_Plan_lk__r.KT_Lead_New__r.SFDC_User__c == strUserId ||
                            //opx.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c == strUserId ||
                            //opx.Wave_Plan_lk__r.Mobilization_KT_Lead_Secondary_2__r.SFDC_User__c == strUserId ||
                            //opx.Wave_Plan_Version__r.Deal__r.MOB_PMO_Project_ID__c == strUserId ||
                            //opx.Wave_Plan_Version__r.Deal__r.MOB_PMO_Project_Secondary_ID__c == strUserId ||
                            //opx.Wave_Plan_Version__r.Deal__r.MOB_PMO_Project_Secondary_2_ID__c == strUserId
                            )
                            {
                                 ChecklistHyperlink= System.URL.getSalesforceBaseUrl().toExternalForm()+'/apex/OPEXQuestioniareCheckListReadOnlyPage?id='+tempId;
                                 isViewSubmitted=true;
                                 isTrackerOff=false;
                                 isRecordDeactivated=false;
                                 isclickforChecklist=false;
                                 isNoPrivilege=false;
                            }else
                            {
                                ChecklistHyperlink='No Privilege';
                                isNoPrivilege=true;
                                isTrackerOff=false;
                                isRecordDeactivated=false;
                                isclickforChecklist=false;
                                isViewSubmitted=false;
                            }
                        }
                    }
                }
                
                listOfOPEX.add(new OPEXNewList(opx,item,locationWave,clientSpecificProcessMappingName,plannedDate,active,milestone,comments,assessmentStatus,isEditVisible,
                                                ChecklistHyperlink,isTrackerOff,isRecordDeactivated,isclickforChecklist,isViewSubmitted,isNoPrivilege));
            }
        } 
        return listOfOPEX;
    }
    
    public void activeRecords(String waveId)
    {
        List<OPEX__c> lstWPVInfo = [Select id, Active__c, Planned_Date__c from OPEX__c where Wave_Plan_Version__c=:waveId];           
            if(lstWPVInfo.size()>0)
            {
                for(OPEX__c tmpTrack : lstWPVInfo )
                {
                    if(tmpTrack.Planned_Date__c==null && tmpTrack.Active__c==true)
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter all Planned Dates for active records.'));  
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
    *******************************/      public void refreshWaveProcessPage(){
        initializeDetailRecords();
        refreshPage = true;
    }
    
    /******************************
    Method Name: changeDate
    Description: This method is used to auto populate planned dates based on the go live date.
    Paramenters: NA
    Return Value: void
    *******************************/ 
    public void changeDate()
    {
        Date d;          
        List<Wave_Planning__c> wavePlanning=[select GO_Live_Date_del__c from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__c=:wavePlanVersionId and Deal_Location__c=:locationName  and id=:wavePlanName];
        if(wavePlanning.size()==1)
        {
            if(dealLocation.item__c !=null)
            {
                if(dealLocation.item__c =='Day 30 Assessment')
                {
                    d=wavePlanning[0].GO_Live_Date_del__c+30;
                }
                else if(dealLocation.item__c =='Day 60 Assessment')
                {
                    d=wavePlanning[0].GO_Live_Date_del__c+60;
                }
                else if(dealLocation.item__c =='Day 90 Assessment')
                {
                    d=wavePlanning[0].GO_Live_Date_del__c+90;
                }
                else if(dealLocation.item__c =='Day 7 Assessment')
                {
                    d=wavePlanning[0].GO_Live_Date_del__c+7;
                }
            } 
        }
        /*if(dealLocation.item__c !='Day 1 Assessment' && dealLocation.item__c !='Pre Go-Live Assessment')
        {
            dealLocation.Planned_Date__c=d;
        }*/
        dealLocation.Planned_Date__c=d;
    }
    
    /******************************
    Method Name: assignWave
    Description: This method is used to assign the first wave dependency to record when no wave dependency is selected.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void assignWave()
    {
        locationChange=true;
        List<Wave_Planning__c> wavePlanning= [select id from Wave_Planning__c where Deal_Location__c=:locationName order by Wave_Label__c];            
        if(wavePlanning.size()>0)
        {
           wavePlanName= wavePlanning[0].id;
        }    
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
            dealLocation.id=processId;
            if(dealLocation.comments__c ==null && buttonName== 'Update')
             {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                return;
             }       
            List<OPEX__c> tempOPEXList=[Select id, Active__c from OPEX__c where id=:processId];
            if(tempOPEXList.size()==1)
            {
                if(tempOPEXList[0].active__c==true && dealLocation.active__c==false)
                {
                    isRecordDeactivated=true;
                }
            }    
        }
    }
    
    public void save()
    {   
    
     Boolean error = false;
     List<OPEX__c> oldListOfLoactionDetailsActual=[Select id,Active__c,Item__c,Checklist_Hyperlink__c,Deal_Location_lk__c,Planned_Date__c, Wave_Plan_lk__c, 
                            Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name ,
                            Comments__c,isEditVisible__c,Wave_Process__c,Wave_Process__r.Client_Specific_Process_Mapping__r.name, Location_Name_Wave_Name__c, Location_Id_Wave_Id__c, Milestone__c  from OPEX__c 
                            where Wave_Plan_Version__c=:wavePlanVersionId  and active__c =:true order by Planned_Date__c,Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name,Wave_Plan_lk__r.Wave_Label__c, Wave_Process__r.Client_Specific_Process_Mapping__r.name ];
        
        List<Wave_Planning__c> wavePlanning=[select GO_Live_Date_del__c, id, name from Wave_Planning__c where Deal_Location__r.Wave_Plan_Version__c=:wavePlanVersionId];
        for(OPEX__c tempOldList : oldListOfLoactionDetailsActual){
            for(OPEX__c tempNewList : listOfLoactionDetailsActual){
              if(tempOldList.id==tempNewList.id){              
                    if(tempNewList.comments__c ==null && tempNewList.active__c==false)
                    {
                        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                        //return;
                        tempNewList.comments__c.addError('Comment is Mandatory if record is marked as Inactive');
                        error = true;
                    }
                    if(tempNewList.active__c==false && tempNewList.Milestone__c==true)
                    {
                         tempNewList.comments__c.addError('An inactive activity cannot be a milestone activity');
                         error = true;
                    }
                    if(tempNewList.Milestone__c==true && tempNewList.Planned_Date__c==null)
                    {
                    //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned End Date is Mandatory if Milestone is active'));
                    //return;
                    tempNewList.Planned_Date__c.addError('Planned Date is Mandatory if Milestone is active');
                    error = true;
                    }  
                  /* if(lstDealWave.size()>0)
                    {
                        for(Wave_Planning__c wp: lstDealWave)
                        {
                            if(tempNewList.Item__c!='Pre Go-Live Assessment' )
                            {
                                if(tempNewList.Planned_Date__c <= wp.GO_Live_Date_del__c)
                                {
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned Date Cannot be Less than or Equal to Go Live Date!'));
                                    return;
                                }
                            }
                        }
                    } */
                }       
            }              
        }
        if(error == true) {
            return;
        }
        for(OPEX__c tmpOPEXPlan : listOfLoactionDetailsActual){
            for(OPEX__c tempOldOPEXPlan : oldListOfLoactionDetailsActual)
            {                           
                if(tempOldOPEXPlan.id!=tmpOPEXPlan.id && tempOldOPEXPlan.Item__c== tmpOPEXPlan.Item__c && tempOldOPEXPlan.Location_Name_Wave_Name__c == tmpOPEXPlan.Location_Name_Wave_Name__c && tempOldOPEXPlan.Wave_Process__c== tmpOPEXPlan.Wave_Process__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Duplicate Records not allowed!'));
                    return;
                }
            } 
        }
      
        try 
        {
            update listOfLoactionDetailsActual;            
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving!'));
            initializeDetailRecords();
            return;
        }        
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Saved Successfully.'));           
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