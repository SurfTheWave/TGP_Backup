/*
Author : Mayank Tayal
Description: This Inline Controller is used to add records in Deal Home Location Object
Story No:    MOB_125

Updated by          Story no                Update Date        Update details
------------      -----------------        --------------    -------------------------------------------------------------

*/
public with sharing class DealHomeLocation_InlineController {
    public String pageid{get;set;}
    public String locationName{get;set;}
    public Boolean refreshPage {get; set;}
    public Deal_Home_Location__c dealLocation {get;set;}
    public List<Deal_Home_Location__c> listOfLoactionDetailsActual {get;set;}
    public boolean ischanged{get;set;}
    public Boolean showMainMsg{get;set;}
    public Boolean showForm{get;set;}
    public Boolean showForm2{get;set;}
    public Boolean isAddVisible{get;set;}
    public boolean isNA {get;set;}
    public Boolean isSaveVisible{get;set;}
    
    /******************************
    Method Name: DealHomeLocation_InlineController
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/
    public DealHomeLocation_InlineController(ApexPages.StandardController controller) {
        dealLocation = new Deal_Home_Location__c();
        pageid=ApexPages.CurrentPage().getParameters().get('id');// id of custom object on which this inline page is placed.
        if(pageid!=null)
        {
            showMainMsg=false;
            showForm=true;
            showForm2=true;
            initializeDetailRecords();
            refreshPage = false;
            ischanged=false;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Invalid Deal ID!'));
            showMainMsg=true;
            showForm=false;
            showForm2=false;            
        } 
        isNA=true;          
        // check mob leadership profile
        /* if(CheckProfile.isMobLeadershipProfile())
            isAddVisible = false;
        else
            isAddVisible = true;  
        */    
        // For UAM
        
        isAddVisible = UAMSolMobUtility.isAddVisible_DealHome;
        isSaveVisible = UAMSolMobUtility.isSaveVisible_DealHome;
         
        if(UAMSolMobUtility.isNA_DealHome)
        {
            showMainMsg=true;
            showForm = false;
            showForm2 = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your administrator.'));
        }
        
            /*UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckUserRole(pageid,'Deal_Home_Location__c');
            isAddVisible = m.get('C');
            isSaveVisible= m.get('U');
            if(m.get('NA'))
            {
                showMainMsg=true;
                showForm = false;
                showForm2 = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No Privilege. Please contact your Administrator.'));
            }*/
    }

    /*******************************************
    Description: Get list of locations from Delievery Location Master
    Returns : List of locations from Delievery Location Master
    ********************************************/
    public List<SelectOption> getLocationNames()
        {
            List<SelectOption> locName=new List<SelectOption>();
            List<Delievery_Location_Master__c> delieveryLocationMaster=[select id,name from Delievery_Location_Master__c where Active__c=true order by name];
            if(delieveryLocationMaster.size()>0)
            {
                for(Delievery_Location_Master__c c: delieveryLocationMaster)
                    { 
                        locName.add(new SelectOption(c.id, c.name));              
                    }
            } 
            return locName;
        }
        
    /****************************
    Description: Add New location
    Returns: void
    ******************************/                  
    public void addLocationDetail() {          
        try{
            List<Deal_Home_Location__c> lstDealHomeLoc= [Select id,Active__c,Delivery_Location_Master__c,Hyperlink__c,Deal__c,Comments__c From Deal_Home_Location__c where Delivery_Location_Master__c = : locationName and Deal__c=:pageid limit 1];
            if(lstDealHomeLoc.size()>0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record already exists.'));
                initializeDetailRecords();
                return;
            }
            dealLocation.Deal__c=pageid;
            dealLocation.Delivery_Location_Master__c=locationName;
            insert dealLocation;              
        } 
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving!'));          
            return;
        }
        finally
        {
            dealLocation=new Deal_Home_Location__c();
            initializeDetailRecords();
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Added Successfully.'));
        refreshPage = true;
    }

    
    /*******************************************
    Description : To load list of locations associated with deal
    Returns : Void
    *******************************************/        
    public void initializeDetailRecords() {       
        listOfLoactionDetailsActual = [Select id,Active__c,Delivery_Location_Master__c,Hyperlink__c,Deal__c,Comments__c,Delivery_Location_Master__r.name from Deal_Home_Location__c where Deal__c=:pageid order by createddate desc];
    } 
    
    /****************************************
    Description : Save Deal home location
    Return value: void
    *****************************************/    
    public void saveLocationDetails()
    {
        List<Deal_Home_Location__c> lstDealHomeLoc= [Select id,Active__c,Delivery_Location_Master__c,Hyperlink__c,Deal__c,Comments__c From Deal_Home_Location__c where Deal__c=:pageid];
        List<Deal_Home_Location__c> waveDetailsToUpsert = new List<Deal_Home_Location__c>();
        if(lstDealHomeLoc.Size()>0)
        {            
            if(lstDealHomeLoc.size()>0)
            {               
                for(Deal_Home_Location__c sm:lstDealHomeLoc)
                {
                    Integer count=0;
                    if(listOfLoactionDetailsActual.size()>0)
                    {
                        for(Deal_Home_Location__c lst : listOfLoactionDetailsActual)
                        {
                            if(lst.Delivery_Location_Master__c == sm.Delivery_Location_Master__c)
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
                for(Deal_Home_Location__c s1:listOfLoactionDetailsActual)
                {
                    for(Deal_Home_Location__c s2:listOfLoactionDetailsActual)
                    if(s1.id!= s2.id)
                    {
                       //Checking for duplication for Wave Names Editing at the same time to same name
                       if(s1.Delivery_Location_Master__c== s2.Delivery_Location_Master__c)
                       {
                           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Duplicate Records not allowed'));
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
        if(listOfLoactionDetailsActual.size()>0)
        {
            for(Deal_Home_Location__c  l: listOfLoactionDetailsActual)
            {
                if(l.active__c==false && l.comments__c==null)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is Mandatory if record is marked as Inactive'));
                    return;   
                }
            }
        }
        waveDetailsToUpsert.addAll(listOfLoactionDetailsActual);
        try 
        {
            upsert waveDetailsToUpsert;            
        }
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving!'+ex));
            initializeDetailRecords();
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Saved Successfully.'));
        initializeDetailRecords();
        refreshPage = true;
    }

    /****************************************
    Description : Refreshing the Current Location Page
    Return value: void
    *****************************************/
    public void refreshLocationPage(){
        initializeDetailRecords();
        refreshPage = true;
    }

    /****************************************
    Description : Checking the relationship with Wave Plan Version
    Return value: void
    *****************************************/
    public void CheckRelationWithWavePlanVersion(){
        ischanged=false;
        List<Deal_Location__c> mainDealLocation=[Select id,Deal_Home_Location__c from Deal_Location__c where Wave_Plan_Version__r.Deal__c =:pageid];
        List<Deal_Home_Location__c> oldDealHomeLocation=[Select id,Delivery_Location_Master__c,Deal__c,active__c from Deal_Home_Location__c where Deal__c=:pageid];
        if(oldDealHomeLocation.size()>0)
        {
            for(Deal_Location__c loc:mainDealLocation)
            {
                for(Deal_Home_Location__c oldLocation:oldDealHomeLocation)
                {
                    if(oldLocation.id == loc.Deal_Home_Location__c)
                    { 
                        if(listOfLoactionDetailsActual.size()>0)
                        {
                            for(Deal_Home_Location__c newLocation : listOfLoactionDetailsActual)   
                            {
                                if(oldLocation.id==newLocation.id && oldLocation.Delivery_Location_Master__c != newLocation.Delivery_Location_Master__c)
                                {
                                    ischanged=true;
                                }
                           
                                else
                                {
                                    ischanged=true;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}