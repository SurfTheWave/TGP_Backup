/*
Author : Mayank Tayal
Description: User should able to add facilities for each location
Story No:    MOB_127

Updated by          Story no                Update Date        Update details
------------      -----------------        --------------    -------------------------------------------------------------

*/
public class DealLocationFacility_InlineController {
    public String pageid{get;set;}
    public String facilityName{get;set;}
    public Boolean refreshPage {get; set;}
    public Deal_Location_Facility__c dealLocation {get;set;}
    public List<Deal_Location_Facility__c> listOfLoactionDetailsActual {get;set;}
    public Boolean showMainMsg{get;set;}
    public Boolean showForm{get;set;}
    public Boolean showForm2{get;set;}
    public boolean isNA {get;set;}    
    public boolean isSaveVisible {get;set;}    
    
    /******************************
    Method Name: DealLocationFacility_InlineController
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/
    public DealLocationFacility_InlineController(ApexPages.StandardController controller) 
    {
        isSaveVisible = true;
        isNA = true;
        dealLocation = new Deal_Location_Facility__c();
        pageid=ApexPages.CurrentPage().getParameters().get('id'); // id of custom object on which this inline page is placed.
        if(pageid!=null)
        {
            showMainMsg=false;
            showForm=true;
            showForm2=true;
            initializeDetailRecords();
            facilityName='None';
            refreshPage = false;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Invalid Deal Location ID!'));
            showMainMsg=true;
            showForm=false;
            showForm2=false;   
            return;         
        }
        
        // For UAM
        /*List<Deal_Home_Location__c > lstDealLoc = [select Deal__c from Deal_Home_Location__c where id=:pageid];        
        string strDealId = lstDealLoc.get(0).Deal__c;
        UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
        Map<String,Boolean> m = uam.CheckUserRole(strDealId ,'Deal_Location_Facility__c');
        showForm = m.get('C');
        isSaveVisible = m.get('U');
        if(m.get('NA'))
        {
            showForm = false;
            showForm2 = false;
            showMainMsg=true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No privilege. Please contact your administrator.'));
        }*/
        showForm = UAMSolMobUtility.showForm_DLFacility;
        isSaveVisible = UAMSolMobUtility.isSaveVisible_DLFacility;
        if(UAMSolMobUtility.isNA_DLFacility)
        {
            showForm = false;
            showForm2 = false;
            showMainMsg=true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No privilege. Please contact your administrator.'));
        }
        
    }
    
    /*******************************************
    Description: Get list of facilities from Facility Master
    Returns : List of Facilities from Facility Master
    ********************************************/
    public List<SelectOption> getFacilityNames()
    {
        List<SelectOption> locName=new List<SelectOption>();
        List<Deal_Home_Location__c> dealHomeLocation=[select id, name, Delivery_Location_Master__c from Deal_Home_Location__c where id=:pageid];
        List<Facility_Master__c> facilityMaster =[select id,name,Delivery_Location_Master__c from Facility_Master__c where Active__c=:true order by name];
        Boolean flag=false;
        if(dealHomeLocation.size()>0)
        {
            for(Deal_Home_Location__c dc: dealHomeLocation)
            {    
                if(facilityMaster.size()>0)
                {
                    for(Facility_Master__c c:facilityMaster )
                    { 
                        if(c.Delivery_Location_Master__c == dc.Delivery_Location_Master__c)
                        {
                            locName.add(new SelectOption(c.id, c.name));
                            flag=true;
                        }                   
                    }
                }                 
            }
        }
        if(flag==false)
        {
             locName.add(new SelectOption('None', '--None--'));
        }
        return locName;
    }

    /****************************
    Description: Add New Facility
    Returns: void
    ******************************/     
    public void addLocationDetail() 
    {
        if(facilityName=='None')
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select valid facility!'));
            return;
        }        
        try
        {
            List<Deal_Location_Facility__c> dhl= [Select id,Facility_Master__c,Active__c,Deal_Home_Location__c  From Deal_Location_Facility__c where Deal_Home_Location__c = : pageid and Facility_Master__c=:facilityName limit 1];
            if(dhl.size()==1)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record already exists!'));
                initializeDetailRecords();
                return;
            }
            dealLocation.Deal_Home_Location__c=pageid;
            dealLocation.Facility_Master__c=facilityName;
            insert dealLocation;              
        } 
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving!'));
            initializeDetailRecords();
            return;
        }
        finally
        {
            dealLocation=new Deal_Location_Facility__c();
        }
        initializeDetailRecords();
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Added Succesfully!'));
        refreshPage = true;
    }
    
    /*******************************************
    Description : To load list of facilities associated with Deal Location
    Returns : Void
    *******************************************/
    public void initializeDetailRecords() {
        listOfLoactionDetailsActual = [select id,Facility_Master__c,Active__c,Deal_Home_Location__c from Deal_Location_Facility__c where Deal_Home_Location__c=:pageid order by createddate desc];    
    }
    
    /****************************************
    Description : Save Deal Facility records
    Return value: void
    *****************************************/  
    public void saveLocationDetails()
    {
        List<Deal_Location_Facility__c> dealLocationFacility = [Select id,Facility_Master__c,Active__c,Deal_Home_Location__c from Deal_Location_Facility__c where Deal_Home_Location__c=:pageid];
        List<Deal_Location_Facility__c> waveDetailsToUpsert = new List<Deal_Location_Facility__c>();
        if(dealLocationFacility.size()>0)
        {
            for(Deal_Location_Facility__c dlf: dealLocationFacility)
            {
                Integer count=0;
                if(listOfLoactionDetailsActual.size()>0)
                {
                    for(Deal_Location_Facility__c lst : listOfLoactionDetailsActual)
                    {
                        if(lst.Deal_Home_Location__c == dlf.Deal_Home_Location__c && lst.Facility_Master__c == dlf.Facility_Master__c)
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
            for(Deal_Location_Facility__c  s1:listOfLoactionDetailsActual)
            {
                for(Deal_Location_Facility__c s2:listOfLoactionDetailsActual)
                if(s1.id!= s2.id)
                {
                   if(s1.Facility_Master__c == s2.Facility_Master__c && s1.Deal_Home_Location__c==pageid && s2.Deal_Home_Location__c==pageid)
                   {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Duplicate Records not allowed!'));
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
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving!'));
            initializeDetailRecords();
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Saved successfully!'));
        initializeDetailRecords();
        refreshPage = true;
    }
    
    /****************************************
    Description : Refreshing the Current Facility Page
    Return value: void
    *****************************************/
    public PageReference refreshLocationPage()
    {
        initializeDetailRecords();
        refreshPage = true;
        return null;
    }
}