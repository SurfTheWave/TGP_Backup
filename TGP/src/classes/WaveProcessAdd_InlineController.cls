/*
Description : This controller is used to add/update Wave Process Records using inline page in Deal.
Author : Malkeet Singh

Updated by        Story no                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Nilesh Adkar    Story-0030/MOB_016        04-Mar-13        Disabling add / edit functionality for old wave version and its 
                                                           children after cloning and creating new wave plan vesrion.
              
*/

public class WaveProcessAdd_InlineController {
    public String waveId{get;set;}
    public String clientSpecificProcessName{get;set;}
    public Boolean refreshPage {get; set;}
    public Boolean is_WavePlanVersionActive{get; set;}
    public Boolean is_WavePlanVersionActived{get; set;}
    public Wave_Process__c newWaveProcessDetail {get;set;}
    public List<Wave_Process__c> listWaveDetailsActual {get;set;}
    public Boolean showMainMsg{get;set;}
    public Boolean showForm{get;set;}
    public Boolean showForm2{get;set;}
    public Boolean isAddVisible{get;set;}
    public boolean isNA{get; set;}
    
    /******************************
    Method Name: waveProcessAdd_InlineController
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/  
    public waveProcessAdd_InlineController(ApexPages.StandardController stdCon) 
    {
        isNA=true;
        newWaveProcessDetail = new Wave_Process__c();       
        waveId=ApexPages.CurrentPage().getParameters().get('id'); // getting Id of Wave Plan Record
        if(waveId!=null)
        {
            showMainMsg=false;
            showForm=true;
            showForm2=true;
            initializeDetailRecords();
            refreshPage = false;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Invalid Deal Wave ID!'));
            showMainMsg=true;
            showForm=false;
            showForm2=false;            
        } 
        // check mob leadership profile
        /*if(CheckProfile.isMobLeadershipProfile())
            isAddVisible = false;
        else
            isAddVisible = true; */
            
        // For UAM
        

            List<Wave_Planning__c> lstDealWave = [select deal_location__r.wave_plan_version__r.deal__c, 
                                                    deal_location__r.wave_plan_version__r.Display_tracking_message__c,
                                                    deal_location__r.wave_plan_version__r.active__c
                                                     from Wave_Planning__c where id = : waveId];
            if(lstDealWave.size()>0)
            {                                                                
                /*String strDealId = lstDealWave.get(0).deal_location__r.wave_plan_version__r.deal__c;
                UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
                Map<String,Boolean> m = uam.CheckUserRole(strDealId,'Wave_Process__c');
                isAddVisible = m.get('C');
                is_WavePlanVersionActive = m.get('U');
                if(m.get('NA'))
                {
                    isNA=false;
                    showMainMsg=true;
                    
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your administrator.'));
                }*/ 
                isAddVisible = UAMSolMobUtility.isAddVisible_WaveProcess;
                is_WavePlanVersionActive = UAMSolMobUtility.is_WavePlanVersionActive_WaveProcess;
                is_WavePlanVersionActived=lstDealWave[0].deal_location__r.wave_plan_version__r.active__c;
                if(UAMSolMobUtility.isNA_WaveProcess)
                {
                    isNA=false;
                    showMainMsg=true;
                    
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your administrator.'));
                }
                           
            }
            if(lstDealWave.size()>0 && lstDealWave[0].deal_location__r.wave_plan_version__r.Display_tracking_message__c=='Tracking is On')
            {
                 is_WavePlanVersionActive =false;
                 isAddVisible=false;
            } 
            if(lstDealWave.size()>0 && lstDealWave[0].deal_location__r.wave_plan_version__r.active__c==false)
            {
                is_WavePlanVersionActive =false;
                 isAddVisible=false;
            }           
    }
    
    /*******************************************
    Description: Method to get list of Client Specific Process names from Client Specific Process Name Object
    Method Name: getClientSpecificProcessNames
    Parameters : None
    Return Type: List<SelectOption>
    ********************************************/
    public List<SelectOption> getClientSpecificProcessNames()
    {
        List<SelectOption> clientSpecificProcessName=new List<SelectOption>();
        // Below list will always contain one record
        List <Wave_Planning__c> wp=[select id, name, Deal_Name__c from Wave_Planning__c where id=:WaveId limit 1];      
        if(wp.size()>0)
        {
            List<Client_Specific_Process_Mapping__c> processMap=[select id,name from Client_Specific_Process_Mapping__c where Deal__r.name=:wp[0].Deal_Name__c and active__c=:true order by name];
            if(processMap.size()>0)
            {
                for(Client_Specific_Process_Mapping__c c : processMap)
                { 
                    // Adding list of client specific process names in variable ClientSpecificProcessName which is retrived in VF page to get values of select list
                    clientSpecificProcessName.add(new SelectOption(c.id, c.name));              
                }
            }
            else
            {
                clientSpecificProcessName.add(new SelectOption('None','--None--'));
            }
        }
        return clientSpecificProcessName;
    }          

    /*******************************************
    Description: Method to add New Wave Process Record
    Method Name: addWaveProcessDetail
    Parameters : None
    Return Type: void
    ********************************************/
    public void addWaveProcessDetail() 
    {
        if(clientSpecificProcessName=='None')
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select valid Process!'));
            return;
        }
        if(newWaveProcessDetail.Number_of_Projected_FTEs__c ==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Number of Projected FTEs!'));
            return;
        }
        try
        {
            List<Wave_Process__c> dhl= [select id,Wave_Planning__c,Active__c,Client_Specific_Process_Mapping__c,Number_of_Projected_FTEs__c,Wave_Process_Comment__c from Wave_Process__c where Client_Specific_Process_Mapping__c=:clientSpecificProcessName And Wave_Planning__c =:WaveId limit 1];
            // To check Duplicacy of Wave Process Name
            if(dhl.size()>0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Process Name  already exists!'));
                initializeDetailRecords();
                return;
            }
            newWaveProcessDetail.Wave_Planning__c=WaveId;
            newWaveProcessDetail.Client_Specific_Process_Mapping__c=clientSpecificProcessName;
            // To add the record in Wave Process oject 
            insert newWaveProcessDetail;
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving!'));
            initializeDetailRecords();
            return;
        }
        finally
        {
            newWaveProcessDetail = new Wave_Process__c();
        }
        initializeDetailRecords();
        refreshPage = true;        
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Added Successfully.'));
    }
    
    /*******************************************
    Description: To initialize the Wave records
    Method Name: initializeDetailRecords
    Parameters : None
    Return Type: void
    ********************************************/
    public void initializeDetailRecords() 
    {       
        listWaveDetailsActual = [Select id,Wave_Planning__c,Active__c,Client_Specific_Process_Mapping__c,Comment__c,Completion_Status__c,Process_RAG_Status__c,Number_of_Projected_FTEs__c,Wave_Process_Comment__c from Wave_Process__c where Wave_Planning__c=:waveId order by createddate desc];
        List<Wave_Planning__c> lstWavePlanVersion = [Select id,Deal_Location__r.Wave_Plan_Version__r.active__c,Deal_Location__r.Wave_Plan_Version__r.Display_tracking_message__c from wave_planning__c where id =:waveId];
        if(lstWavePlanVersion.size()>0)
        {
            is_WavePlanVersionActive = lstWavePlanVersion.get(0).Deal_Location__r.Wave_Plan_Version__r.Active__c;
            if(lstWavePlanVersion.get(0).Deal_Location__r.Wave_Plan_Version__r.Display_tracking_message__c=='Tracking is On')
            {
                is_WavePlanVersionActive =false;  
            }
        }      
    } 

    /*******************************************
    Description: To save the updated Wave records
    Method Name: saveWaveProcessDetails
    Parameters : None
    Return Type: void
    ********************************************/
    public void saveWaveProcessDetails()
    {
        List<Wave_Process__c> waveProcess =[Select id,Active__c,Client_Specific_Process_Mapping__c,Comment__c,Completion_Status__c,Process_RAG_Status__c,Wave_Planning__c,Number_of_Projected_FTEs__c from Wave_Process__c where Wave_Planning__c=:WaveId];
        List<Wave_Process__c> waveDetailsToUpsert = new List<Wave_Process__c>();
        if(listWaveDetailsActual.size()>0)
        {
            for(Wave_Process__c lst : listWaveDetailsActual)
            {
                if(lst.Number_of_Projected_FTEs__c ==null)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Number of Projected FTEs cannot be blank!'));
                    return;
                }
            }
        }
        if(waveProcess.size()>0)
        {
            for(Wave_Process__c sm:waveProcess)
            {
                Integer count=0;
                if(listWaveDetailsActual.size()>0)
                {
                    for(Wave_Process__c lst : listWaveDetailsActual)
                    {
                        if(lst.Client_Specific_Process_Mapping__c == sm.Client_Specific_Process_Mapping__c && lst.Wave_Planning__c==sm.Wave_Planning__c)
                        {
                            count++;
                            if(count==2)
                            {
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Duplicate Records not allowed!'));
                                initializeDetailRecords();
                                return;
                            }
                        }
                    } 
                }
            }
            for(Wave_Process__c s1:listWaveDetailsActual )
            {
                if(s1.Wave_Process_Comment__c==null && s1.Active__c==false)
                     {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                        return;
                     }
                for(Wave_Process__c s2:listWaveDetailsActual )
                {
                    if(s1.id!= s2.id)
                    {
                        // To check duplicacy of records
                       if(s1.Client_Specific_Process_Mapping__c == s2.Client_Specific_Process_Mapping__c && s1.Wave_Planning__c==s2.Wave_Planning__c)
                       {
                           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Duplicate Records not allowed!'));
                            initializeDetailRecords();
                            return;
                       } 
                    }
                }
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please insert the record!'));
            initializeDetailRecords();
            return;
        }
        waveDetailsToUpsert.addAll(listWaveDetailsActual);
        try 
        {
            // Updating records of Wave Process  
            upsert waveDetailsToUpsert;                
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving!'));
            initializeDetailRecords();
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Saved Successfully.'));
        initializeDetailRecords();
        updateOPEXDetails();
        refreshPage = true;
    }
    
    /****************************************
    Description : Refreshing the Wave Process Page
    Return value: void
    *****************************************/
    public void refreshWaveProcessPage()
    {       
        initializeDetailRecords();
        refreshPage = true;
    } 
     /*******************************************
    Description: To update the OPEX records 
    Method Name: updateOPEXDetails
    Parameters : None
    Return Type: void
    ********************************************/
    public void updateOPEXDetails(){
    
     List<OPEX__c> updateOpexList=new List<OPEX__c>();
     Set<Opex__C> updateOpexSet = new Set<OPEX__c>();
     
     List<Wave_Process__c> waveProcList=[Select id,Wave_Planning__c,Wave_Planning__r.Deal_Location__c,Wave_Planning__r.Active__c,Wave_Planning__r.NewActive__c,Active__c,Client_Specific_Process_Mapping__c,Comment__c,Completion_Status__c,Process_RAG_Status__c,Number_of_Projected_FTEs__c from Wave_Process__c 
                                                where Wave_Planning__c=:waveId order by createddate desc];
     List<OPEX__c> lstOpex=[Select id,Active__c, Wave_Plan_lk__c,Deal_Location_lk__c,isEditVisible__c,Milestone__c,Wave_Process__c  from OPEX__c where 
                                            Wave_Plan_lk__c=:waveId order by createddate desc];
        for(Wave_Process__c wpc : waveProcList){
                for(OPEX__c opx : lstOpex){            
                    if(wpc.id== opx.Wave_Process__c && wpc.Wave_Planning__c== opx.Wave_Plan_lk__c && wpc.Wave_Planning__r.Deal_Location__c == opx.Deal_Location_lk__c) {                        
                         if(wpc.Active__c && wpc.Wave_Planning__r.NewActive__c ){
                                opx.id=opx.id;
                                opx.active__c=true;                        
                                updateOpexList.add(opx);
                         }
                         else {
                                opx.id=opx.id;
                                opx.active__c=false;  
                                updateOpexList.add(opx);
                             }
                     }
                }
                
            }
            update updateOpexList;
        } 
    }