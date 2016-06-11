/*
Author : Malkeet Singh
Story  : MOB_126 
Description : Controller to create/update records of LegalInfosec 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Varsha Chougule      MOB_131                  31-may-2013       Active inactive

*/
public class LegalInfosecController{
    public String wavePlanVersionId{get;set;}
    public String locationName{get;set;}
    public Integer col1{get;set;}
    public Integer col2{get;set;}
    public Integer col3{get;set;}
    public String wavePlanName{get;set;}
    public Boolean refreshPage {get; set;}
    public Contract_Legal_Infosec__c dealLocation {get;set;}
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
    Public String rerenderText{get;set;}
    Public Boolean showForm{get;set;}
    Public String displayStr{get;set;}
    public boolean isAddVisible{get; set;}
    public boolean isRecordDeactivated{get;set;}
    public boolean valueOfActiveField{get;set;}
    public boolean isNA {get;set;}
    public boolean isEditVisible{get; set;}
     
    /******************************
    Method Name: LegalInfosecController
    Description: This is Constructor for the LegalInfosecController class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/ 
    public LegalInfosecController(ApexPages.StandardController stdCon) {
        dealLocation = new Contract_Legal_Infosec__c();
        isNA=true;          
        isTableRendedered = true;
        buttonName='Add';
        isEditVisible = true;
        
         // Getting Id of Wave Plan Version 
        wavePlanVersionId=ApexPages.CurrentPage().getParameters().get('id');

           // Getting Id of record which we want to edit
        processId=ApexPages.CurrentPage().getParameters().get('processId');
        
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
            
            // To get the Contract Legal Infosec record which we want to edit
            List<Contract_Legal_Infosec__c> op=[Select id,Wave_Plan_Version__r.active__c,Wave_Plan_Version__r.Display_tracking_message__c,Wave_Plan_Version__c,Active__c,Activity__c,Comments__c,Deal_Location_lk__c,Planed_Start_Date__c, Planned_End_Date__c, Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name from Contract_Legal_Infosec__c where id=:processId];
            if(op.size()>0)
            {
                dealLocation=op[0];
                locationName=op[0].Deal_Location_lk__c;
                wavePlanName=op[0].Wave_Plan_lk__c;
                wavePlanVersionId=op[0].Wave_Plan_Version__c;
                buttonName='Update';
                isTableRendedered=false;
                valueOfActiveField=op[0].active__c;
                isWaveVersionActive=op[0].Wave_Plan_Version__r.active__c;
                if(op[0].Wave_Plan_Version__r.Display_tracking_message__c=='Tracking is On')
                {
                    isWaveVersionActive=false;    
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
                col1=3;
                col2=4;
                col3=2;
                sectionTitle='Add New Contract/Legal Infosec Plan';
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
       /* if(CheckProfile.isMobLeadershipProfile()&& processId==null)
        {
            isAddVisible = false;
            isWaveVersionActive = false;
        }
        else
            isAddVisible = true; */
             
        // For UAM
        
        if(processId==null) // Process id is null on inline page of high level plan
        {
        /*    List<wave_plan_version__c> lstDeal = [select deal__c from wave_plan_version__c where id = : wavePlanVersionId];
            String strDealId = lstDeal.get(0).deal__c;
            UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckUserRole(strDealId,'Contract_Legal_Infosec__c');
            isAddVisible = m.get('C');
            isEditVisible= m.get('U');
            if(m.get('NA')==true)
            {
                isNA=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No priviledge. Please contact your administrator.'));
                return;
            }            
          */
            isAddVisible = UAMSolMobUtility.isAddVisible_CLIPlan; 
	        isEditVisible = UAMSolMobUtility.isWaveVersionActive_CLIPlan;   
	          
	     	if(UAMSolMobUtility.isNA_CLIPlan)
	     	{
	     		isNA=false;
	        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No priviledge. Please contact your administrator.'));
                return;
	     	}
            List<Wave_Plan_Version__c> lstWave = [select active__c,Display_tracking_message__c from Wave_Plan_Version__c where id=:wavePlanVersionId];
            if(lstWave.size()>0)
            {
                isWaveVersionActive = lstWave[0].active__c;
                if(lstWave[0].Display_tracking_message__c=='Tracking is On')
                {
                    isWaveVersionActive =false;  
                }
            }
        }
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
        if(locationName=='None')
        {
            locName.add(new SelectOption('None','--None--'));
            return locName;
        }
        List <Deal_Location__c> dealLocation=[select id,name, Deal_Home_Location__r.Delivery_Location_Master__r.name from Deal_Location__c where Wave_Plan_Version__c=:wavePlanVersionId order by Deal_Home_Location__r.Delivery_Location_Master__r.name];
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
        return wavePlans;
    }
    
      /******************************
    Method Name: addWaveProcessDetail
    Description:This method is used to add/Update Contract Legal Infosec Plan records for a particalur wave version.
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
            if(wavePlanName=='None'||locationName=='None'|| dealLocation.Planed_Start_Date__c==null || dealLocation.Planned_End_Date__c==null)
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
                if(dealLocation.Planned_End_Date__c > wp.GO_Live_Date_del__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Planned End Date Cannot be greater than Go Live Date!'));
                    return;
                }
            }
        }
        dealLocation.Wave_Plan_Version__c=wavePlanVersionId;
        dealLocation.Deal_Location_lk__c=locationName;
        dealLocation.Wave_Plan_lk__c=wavePlanName;
        try
        {
            List<Contract_Legal_Infosec__c> serviceList= [Select Activity__c,Comments__c ,Deal_Location_lk__c,Planed_Start_Date__c,Planned_End_Date__c, Wave_Plan_lk__c From Contract_Legal_Infosec__c where Activity__c = : dealLocation.Activity__c and Deal_Location_lk__c = : dealLocation.Deal_Location_lk__c and Wave_Plan_lk__c= :dealLocation.Wave_Plan_lk__c and  Wave_Plan_Version__c=:wavePlanVersionId limit 1];
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
           upsert dealLocation;
           if( buttonName=='Add')
            {
                valueOfActiveField=true;
            }
            else if( buttonName=='Update')
            {
                valueOfActiveField=dealLocation.active__c;
            }
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record '+displayStr+' Succesfully!')); 
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
        dealLocation=new Contract_Legal_Infosec__c();
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
        hiddenNavigator1='Add';
        hiddenNavigator='Add';
        listOfLoactionDetailsActual=null;
        listOfLoactionDetailsActual = new Contract_Legal_Infosec__c[]{};
        List<Contract_Legal_Infosec__c> contractLegalInfosec =[Select id, Active__c,Comments__c, Activity__c,Deal_Location_lk__c,Planed_Start_Date__c,Planned_End_Date__c, Wave_Plan_lk__c, Wave_Plan_lk__r.Wave_Label__c, Deal_Location_lk__r.Deal_Home_Location__r.Delivery_Location_Master__r.name from Contract_Legal_Infosec__c where Wave_Plan_Version__c=:wavePlanVersionId order by createddate desc];
        if(contractLegalInfosec.size()>0)
        {
            for(Contract_Legal_Infosec__c profDet : contractLegalInfosec)
            {
                listOfLoactionDetailsActual.add(profDet);                
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
            if(dealLocation.active__c==false && dealLocation.comments__c ==null && buttonName== 'Update')
             {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                return;
             } 
             List<Contract_Legal_Infosec__c> serviceList= [Select Activity__c,Deal_Location_lk__c,Planed_Start_Date__c,Planned_End_Date__c, Wave_Plan_lk__c From Contract_Legal_Infosec__c where Activity__c = : dealLocation.Activity__c and Deal_Location_lk__c = : dealLocation.Deal_Location_lk__c and Wave_Plan_lk__c= :dealLocation.Wave_Plan_lk__c and  Wave_Plan_Version__c=:wavePlanVersionId limit 1];
            if(serviceList.size()>=1)
            {
                 if(serviceList[0].id != dealLocation.id)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record already exists.'));
                    return;
                }
            }       
            List<Contract_Legal_Infosec__c> tempContractList=[Select id, Active__c from Contract_Legal_Infosec__c where id=:processId];
            if(tempContractList.size()==1)
            {
                if(tempContractList[0].active__c==true && dealLocation.active__c==false)
                {
                    isRecordDeactivated=true;
                }
                
            }    
        }
    }
}