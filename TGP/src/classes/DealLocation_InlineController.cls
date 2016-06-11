/*
Author : Sanjay Kumar Das
Story  : Story-0131/MOB_114 
Description : VF Page - Deal Locations (Go Live Plan Page)

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
public class DealLocation_InlineController
 {
    public String wavePlanVersionId{get;set;}
    public String locationName{get;set;}    
    public Boolean refreshPage {get; set;}
    public Deal_Location__c dealLocation {get;set;}
    public List<Deal_Location__c> listOfLoactionDetailsActual {get;set;}
    public Boolean showMainMsg{get;set;}
    public Boolean showForm{get;set;}
    public Boolean showForm2{get;set;}
    public Boolean isAddVisible{get;set;}
    public Boolean isWaveVersionActive{get; set;}
    public boolean isNA {get;set;}
    
    
    /******************************
    Method Name: DealLocation_InlineController
    Description: This is Constructor for the DealLocation_InlineController class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/     
    public DealLocation_InlineController(ApexPages.StandardController controller) 
    {
        isNA=true;          
        dealLocation = new Deal_Location__c();
        wavePlanVersionId=ApexPages.CurrentPage().getParameters().get('id');

         // check mob leadership profile
      /*  if(CheckProfile.isMobLeadershipProfile())
            isAddVisible = false;
        else
            isAddVisible = true; */
        //Checkiing the wave version id         
        if(wavePlanVersionId!=null)
        {
            showMainMsg=false;
            showForm=true;
            showForm2=true;
            initializeDetailRecords();
            refreshPage = false;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Invalid High Level Mobilization Plan ID!'));
            showMainMsg=true;
            showForm=false;
            showForm2=false; 
        }
        // check mob leadership profile
        /*if(CheckProfile.isMobLeadershipProfile())
            isAddVisible = false;
        else
            isAddVisible = true;
          */  
        // For UAM
        
            /*List<wave_plan_version__c> lstDeal = [select deal__c from wave_plan_version__c where id = : wavePlanVersionId];
            string strDealId = lstDeal.get(0).deal__c;
            
            UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckUserRole(strDealId,'Deal_Location__c');
            isAddVisible = m.get('C');
            isWaveVersionActive = m.get('U');
            if(m.get('NA')==true)
            {
                isNA=false;
                showMainMsg = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your administrator.'));
                return;
            } */           
            
            isAddVisible = UAMSolMobUtility.isAddVisible_DealLoc;
            isWaveVersionActive = UAMSolMobUtility.isWaveVersionActive_DealLoc;
            
            if(UAMSolMobUtility.isNA_DealLoc)
            {
                isNA=false;
                showMainMsg = true;
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
                    isAddVisible =false;
                    isWaveVersionActive =false;
                }
            }
    }
    
    /******************************
    Method Name: getLocationNames
    Description: This method is used to get list of deal location for a particular wave version.  
    Paramenters: NA
    Return Value: List<SelectOption>
    *******************************/ 
    /*public List<SelectOption> getLocationNames()
    {
        List<SelectOption> locName=new List<SelectOption>();       
        List<Wave_Plan_Version__c> WavePlanVersion=[select id, name, Deal__c from Wave_Plan_Version__c where id=:wavePlanVersionId];          
        String dealName= WavePlanVersion[0].Deal__c;  
        List<Deal_Home_Location__c> dealHomeLocation =[select id,name,Delivery_Location_Master__r.name from Deal_Home_Location__c where Deal__c=:dealName and Active__c=:true order by Delivery_Location_Master__r.name]; 
        if(dealHomeLocation.size()>0)
        {
            for(Deal_Home_Location__c c : dealHomeLocation)
            {                         
                locName.add(new SelectOption(c.id, c.Delivery_Location_Master__r.name));              
            }
        }
        else
        {
            locName.add(new SelectOption('None','--None--'));
        }
        return locName;
    }
    */
    /******************************
    Method Name: addLocationDetail
    Description:This method is used to add locations for a particalur wave plan.
    Paramenters: NA
    Return Value: void
    *******************************/
    /*public void addLocationDetail(List<Wave_Plan_Version__c> lstWavePlanVersion) 
    {      
         Wave_Plan_Version__c wavePlanVersion = lstWavePlanVersion.get(0);                       
        try
        {
            List<Deal_Location__c> dhl= [Select id,Active__c,NewActive__c,Deal_Home_Location__c,Hyperlink__c,Comment__c,Location_RAG_Status__c from Deal_Location__c where Deal_Home_Location__c=:locationName and Wave_Plan_Version__c=:wavePlanVersion.Id limit 1];
            if(dhl.size()>0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record already exists!'));
                initializeDetailRecords();
                return;
            }
            dealLocation.Wave_Plan_Version__c=wavePlanVersion.Id;
            dealLocation.Deal_Home_Location__c='Bangalore';
            insert dealLocation;      
             
        } 
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving!'));
            initializeDetailRecords();
            return;
        }
        finally
        {
            dealLocation = new Deal_Location__c();
        }
        initializeDetailRecords();
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Added Successfully.'));  
        refreshPage = true;
        //PageReference pg=new PageReference('/wavePlanVersionId ');
        
    }
    */
    /******************************
    Method Name: initializeDetailRecords
    Description:This method is used to initialize the records.
    Paramenters: NA
    Return Value: void
    *******************************/ 
    public void initializeDetailRecords() {
        listOfLoactionDetailsActual = [select id,Active__c,NewActive__c,Deal_Home_Location__c,Hyperlink__c,Comment__c,Wave_Plan_Version__c,Location_Name__c from Deal_Location__c where Wave_Plan_Version__c=:wavePlanVersionId order by createddate desc];
    }
    
    /******************************
    Method Name: saveLocationDetails
    Description:This method is used to save the location records.
    Paramenters: NA
    Return Value: void
    *******************************/      
    /*public void saveLocationDetails()
    {    
        List<Deal_Location__c> dealLocation= [Select id,Active__c,NewActive__c,Deal_Home_Location__c,Hyperlink__c,Comment__c,Wave_Plan_Version__c from Deal_Location__c where Wave_Plan_Version__c=:wavePlanVersionId];
        List<Deal_Location__c> waveDetailsToUpsert = new List<Deal_Location__c>();
        if(dealLocation.size()>0)
        {
            for(Deal_Location__c dl: dealLocation)
            {
                Integer count=0;
                if(listOfLoactionDetailsActual.size()>0)
                {
                    for(Deal_Location__c dhl: listOfLoactionDetailsActual)
                    {
                        if(dhl.Deal_Home_Location__c == dl.Deal_Home_Location__c)
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
            for(Deal_Location__c s1:listOfLoactionDetailsActual)
            {
                for(Deal_Location__c s2:listOfLoactionDetailsActual)
                if(s1.id!= s2.id)
                {
                   if(s1.Deal_Home_Location__c == s2.Deal_Home_Location__c && s1.Wave_Plan_Version__c==wavePlanVersionId  && s2.Wave_Plan_Version__c==wavePlanVersionId )
                   {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Duplication is not Allowed'));
                        initializeDetailRecords();
                        return;
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
        waveDetailsToUpsert.addAll(listOfLoactionDetailsActual);
        try 
        {
            upsert waveDetailsToUpsert;            
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving!'));
            initializeDetailRecords();
            return;
        }        
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Saved Successfully.'));
        initializeDetailRecords();
        refreshPage = true;
    }
    */
    /******************************
    Method Name: refreshLocationPage
    Description: This method is used to refresh the page.
    Paramenters: NA
    Return Value: void
    *******************************/     
    public void refreshLocationPage(){
        initializeDetailRecords();
        refreshPage = true;
    }  
}