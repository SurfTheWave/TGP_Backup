/*
Name :         MOB_DealClientSpecificProcessController
Description :  Controller for VF page MOB_DealClientSpecificProcess
Author :       Nilesh Adkar (Accenture)

Updated by        Update date        User story
-----------    ------------------  --------------

*/
public with sharing class MOB_DealClientSpecificProcessController
{    
//  Need deal record from previous page
    public ApexPages.StandardController stdController;

//  Object variables    
    public String strProcessName{get; set;}
    public String strOffering{get; set;}
    public String strService{get; set;}
    public String strServiceComponent{get; set;}
    public boolean isActive{get; set;}
    public String strButtonName{get; set;}
    public String sectionTitle{get;set;}
    public String strClientInlinePageURL{get;set;}
    public String strMessage{get; set;}
    public boolean strActive{get; set;}
    public String strComments{get; set;}
    public boolean isVisible{get; set;}
    public String strRerenderString{get;set;}
    public boolean isAddVisible{get; set;}
    public boolean isEditVisible{get; set;}
    public boolean isProcessExistInWave{get;set;}
    public boolean isNA{get; set;}
    
//  For master detail relationship need master id i.e Deal id
    public String strDealId{get; set;}
    
//    For update need client process id
    public String strClientProcessId{get; set;}

//  For rendering update window
    public integer columnNos{get; set;}
    public boolean isTableRendedered{get; set;}

//  For populating picklists
    public List<SelectOption> strOfferingsList{get;set;}
    public List<SelectOption> strServicesList{get;set;}
    public List<SelectOption> strServiceComponentsList{get;set;}
    
    public List<Client_Specific_Process_Mapping__c> strClientProcessList{get;set;}
    
/*
Constructor

*/
    
    public MOB_DealClientSpecificProcessController(ApexPages.StandardController stdController)
    {
        
//    Set initial values if for new record
       this.stdController = stdController;
        strButtonName = 'Add';
        strProcessName = null;
        isNA=true;
        isVisible= false;
        strActive = true;
        strRerenderString='msg,ClientSection,frm';
        

            
//    For new entry, inline page
        sectionTitle='Add New Client Specific Process';
        columnNos = 7;
        isTableRendedered = true;
        
        
//    Load picklist values
        LoadData();

//    for Update get record id
        PageReference pageRef = ApexPages.currentPage();
        PageReference pageRef1 = new PageReference(pageRef.getUrl());
        
//     Client process id
        strClientProcessId = pageRef1.getParameters().get('ProcessId'); 

        // check mob leadership profile
      /*  if(CheckProfile.isMobLeadershipProfile()&& strClientProcessId==null)
            isAddVisible = false;
        else
            isAddVisible = true; */
            
        // For UAM
        
       isAddVisible = UAMSolMobUtility.isAddVisible_CSpecific;
       isEditVisible = UAMSolMobUtility.isEditVisible_CSpecific;      
       if(UAMSolMobUtility.isNA_CSpecific)
       {
            isNA=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No privilege. Please contact your administrator.'));
            return;
       }
            /*UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckUserRole(strDealId,'Client_Specific_Process_Mapping__c');
            isAddVisible = m.get('C');
            isEditVisible= m.get('U');
            if(m.get('NA'))
            {
                isNA=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your administrator.'));
            }*/
                     
//     If ProcessId not null means its update operation
        if(strClientProcessId != null && strClientProcessId != '')
        {
//     Get current record to update
            List<Client_Specific_Process_Mapping__c> lstClientProcess= [Select id, Name ,Process__c, Offering__c,Service_Component__c,Active__c,Deal__c,comments__c From Client_Specific_Process_Mapping__c where id = :strClientProcessId  limit 1];
            if(lstClientProcess.size()>0)
            {
                strProcessName = lstClientProcess.get(0).name;
                strOffering = lstClientProcess.get(0).Offering__c;
                strDealId = lstClientProcess.get(0).Deal__c;
                
// Accoording to current record load offering specific services
                refreshServices();
                strService = lstClientProcess.get(0).Process__c;
                
// Accoording to current record load service specific service components
                refreshServiceComponents();
                strServiceComponent = lstClientProcess.get(0).Service_Component__c;        
                
                strActive = lstClientProcess.get(0).active__c;
                strComments = lstClientProcess.get(0).comments__c;

            }    
            strButtonName= 'Update';
            isAddVisible = true;
            isVisible=true;
            strRerenderString='msg,ClientSection';
            
// Small popup window for update operation, used in VF pages
            sectionTitle='Edit Client Specific Process';
            columnNos = 1;
            isTableRendedered = false;
        }
    }

/*
Description : Load data from master, initiates variables to null
Returns : Nothing
*/
    public void LoadData()
    {

// Need to do this or refreshed values are not seen
//        strClientProcessId = null;
        strProcessName = null;
        strOffering = null;
        strService = null;
        strServiceComponent = null;
        strOfferingsList = null;
        strServicesList=null;
        strServiceComponentsList=null;
        strClientProcessList=null;
        
//    Load offering picklist
        List<Offerings_Master__c> lstOfferings= [Select id,Name From Offerings_Master__c where active__c=:true order by name];
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--')); 
        for(Offerings_Master__c tempOffer : lstOfferings )
        {
            options.add(new SelectOption(tempOffer.id,tempOffer.name));        
        }        
        strOfferingsList = options;
                            
//    Load deal record, i.e parent
        //
        Deal_TGP__c DealRec = (Deal_TGP__c)stdController.getRecord();
        strDealId = DealRec.id;
        if(strDealId==null)
        {
            strDealId = ApexPages.CurrentPage().getParameters().get('id');
        }
//    Load Client processes associated with current deal in table        
        if(strDealId !=null)
        {   
            List<Client_Specific_Process_Mapping__c> lstClientProcess= [Select id, Name , offering__r.name,Process__r.name,Service_Component__r.name , Active__c,comments__c From Client_Specific_Process_Mapping__c where Deal__c = :strDealId  order by CreatedDate desc];
            strClientProcessList = lstClientProcess;
        }

    }

/*
Description : Saves data to Client specific process object
Returns : Page reference as null as its a ActionFunction call
*/    
    public Pagereference SaveProcess()
    {
        
        List<Client_Specific_Process_Mapping__c> lstClientProcess;
        
// To check new duplicate record
    // if found ProcessId in query string, means update operation
        if(strClientProcessId !=null && strClientProcessId !='')
        {
            // Check whether while updating current record are we making it duplicate of other existing record in database
            lstClientProcess = [Select Name ,id From Client_Specific_Process_Mapping__c where Name = : strProcessName and Deal__c= :strDealId and id<> :strClientProcessId limit 1];            
        }
        
    // if ProcessId not found in query string, means new operation
        else if((strClientProcessId ==null || strClientProcessId =='')&& strProcessName!=null)
        {
            // check if record with same process name exists
            lstClientProcess = [Select Name ,id From Client_Specific_Process_Mapping__c where Name = : strProcessName and Deal__c= :strDealId limit 1];            
        }
        
    // if found any record for above conditions then current record is duplicate    
        if(lstClientProcess.size()>=1)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record with same Process name already exists.'));
            //strMessage = 'Record with same Process name already exists.';
            return null;
        }
     // insert or update current record.   
        else
        {
            Client_Specific_Process_Mapping__c objClient = new Client_Specific_Process_Mapping__c();
            
            // if found ProcessId in query string, means update operation
            if(strClientProcessId != null &&  strClientProcessId !='')
            {
                List<Client_Specific_Process_Mapping__c> lstClientProcessUpdate= [Select id,Name ,Process__c, Offering__c,Service_Component__c,Active__c,Deal__c,comments__c From Client_Specific_Process_Mapping__c where id= :strClientProcessId ];                
                if(lstClientProcessUpdate.size() > 0) {
                    objClient = lstClientProcessUpdate.get(0);
                }
            }
            if(strProcessName != null && strProcessName!='')
            {
                objClient.name = strProcessName;
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Process Name cannot be blank.'));
                //strMessage = 'Process name can not be blank.';
                return null;
            }    
            if (strOffering !=null  && strOffering  !='')
            {
                objClient.Offering__c = strOffering;
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select offering.'));
                //strMessage = 'Please select offering.';
                return null;
            }    
                
            if (strService!=null  &&  strService!='')
            {
                objClient.Process__c = strService;
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select service.'));
                //strMessage = 'Please select service.';
                return null;
            }    
                
            if (strServiceComponent!=null  &&  strServiceComponent!='')
            {
                objClient.Service_Component__c = strServiceComponent;
            }
            else
                objClient.Service_Component__c = null;    
                                               
            objClient.Active__c = strActive;
            objClient.Comments__c = strComments;
            
            if (strDealId !=null && strClientProcessId == null)
                objClient.Deal__c = strDealId;
            else if (strDealId ==null )
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Could not associate to deal.'));
                //strMessage = 'Could not associate to deal.';
                return null;
            } 
            if(objClient.Active__c==false && (objClient.Comments__c==null || objClient.Comments__c==''))
            {
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
               return null; 
            }   
            try
            {
                upsert objClient;
            }
            catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex.getdmlMessage(0)));
                return null;
            }
            
// if ProcessId not found in query string, means new operation            
            if(strClientProcessId ==null )
            {
                //strMessage = 'Record Added Successfully.';
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Added Successfully.'));
                LoadData();
                return null;
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Updated Successfully.'));
                //LoadData();
                strClientInlinePageURL = '/apex/MOB_DealClientSpecificProcess?ProcessId='+ objClient.id +'&id='+ objClient.id ;
                PageReference pageRef = new PageReference(strClientInlinePageURL);
                return null;
            }
        } 
                          
    }
    
/*
Description : Refreshes Service master records according to offering selected.
Returns : Void
*/
    
    public void refreshServices()
    {
        strServicesList = null;
        strServiceComponentsList = null;
        List<Service_Master__c> lstServices = [Select id,Name From Service_Master__c where offering__c=:strOffering And Active__c=:true order by name];
        List<SelectOption> options = new List<SelectOption>();
        options = new List<SelectOption>();
        options.add(new SelectOption('','--None--')); 
        for(Service_Master__c tempService : lstServices )
        {
            options.add(new SelectOption(tempService.id,tempService.name));        
        }        
        strServicesList = options;
        
    }

/*
Description : Refreshes Service Components master records according to Service selected.
Returns : Void
*/
  
    public void refreshServiceComponents()
    {
        strServiceComponentsList = null;
        List<Service_Component__c> lstServiceComponents = [Select id, Name From Service_Component__c where Service_Master__c=:strService and Active__c=:true order by name];
        List<SelectOption> options = new List<SelectOption>();
        options = new List<SelectOption>();
        options.add(new SelectOption('','--None--')); 
        for(Service_Component__c tempService : lstServiceComponents )
        {
            options.add(new SelectOption(tempService.id,tempService.name));        
        }        
        strServiceComponentsList = options;
        
    }
    
    /****************************************
    Description : Checking the Process Exist In Deal Wave or not
    Return value: void
    *****************************************/
    public void CheckProcessExistInWave()
    {
        isProcessExistInWave=false;
        if(strClientProcessId !=null && strActive==false)
        {
            List<Wave_Process__c> mainDealLocation=[Select id,Client_Specific_Process_Mapping__c from Wave_Process__c where Wave_Planning__r.Deal_Location__r.Wave_Plan_Version__r.Deal__c =:strDealId 
                                                    And Wave_Planning__r.Deal_Location__r.Wave_Plan_Version__r.active__c=:true];
            if(mainDealLocation.size()>0)
            {
                for(Wave_Process__c p : mainDealLocation)
                {
                    if(p.Client_Specific_Process_Mapping__c==strClientProcessId)
                    {
                        isProcessExistInWave=true;
                    }
                }
            }                                        
        }
        return;
    }
   
}