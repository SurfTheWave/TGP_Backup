/*
Author : Sushmanth Hasti
Story  : Story-0111/COM_051  
Description : Controller for ServiceComponentsMaster page.Create / maintain Service component master.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
public class ServiceComponentMasterController {
    public Service_Component__c newServiceComponent {get;set;}
    public String Offering{get;set;}
    public String Service{get;set;}
    public Service_Component__c[] listnewServiceComponent {get;set;}
    /******************************
    Method Name: ServiceComponentMasterController
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/   
    public ServiceComponentMasterController(ApexPages.StandardController controller)
     {
        
        newServiceComponent= new Service_Component__c();
        newServiceComponent=(Service_Component__c)controller.getRecord();

    }
    /******************************
    Method Name: getOfferings
    Description: Method to get Offering.
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public List<SelectOption> getOfferings()
    {
        List<SelectOption> Offerings=new List<SelectOption>();
        Offerings.add(new SelectOption('None','--None--')); 
        //Query to fetch Offering Master   
        List<Offerings_Master__c>  OfferingsMaster=[select name,id from Offerings_Master__c where Active__c=:true order by name];
        //Check Size
        if(OfferingsMaster.size()>0)
        {   
            //Iterate through Offering Master 
            for(Offerings_Master__c o:OfferingsMaster)
            { 
                Offerings.add(new SelectOption(o.id, o.name));              
            }
        }
        return Offerings;
    }
    /******************************
    Method Name: getServices
    Description: Method to get Services.
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public List<SelectOption> getServices()
    {
        List<SelectOption> Services=new List<SelectOption>();
        Services.add(new SelectOption('None','--None--'));  
        //Query to fetch Service master 
        List<Service_Master__c> ServiceMaster = [select name,Offering__c from Service_Master__c where Offering__r.id=:offering and Active__c=:true];
        //Check Size
        if(ServiceMaster.size()>0 )
        {   
            //Iterate through Service Master
            for(Service_Master__c o:ServiceMaster )
            { 
                Services.add(new SelectOption(o.id, o.name));              
            }
        }
        return Services;
    }
     /******************************
    Method Name: saveAccProfileDetails
    Description: Method to Save records.
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference saveAccProfileDetails(){
        //Check for null
        if(Offering=='None'|| Service=='None' || newServiceComponent.Name==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Mandatory Fields!'));
            return null;
        }
        
        String refId='';
        List<Offerings_Master__c> offMaster = new List<Offerings_Master__c>();
        //Fetch offering master records.
        offMaster = [Select Id from Offerings_Master__c where id=:offering];
        List<Service_Master__c> serMaster =  new List<Service_Master__c>();
        //Fetch Service Master records.
        serMaster = [Select Id from Service_Master__c where id=:Service];
        
        newServiceComponent.Offering_Master__c = offMaster[0].Id;
        newServiceComponent.Service_Master__c = serMaster[0].Id;
        try
        {
        insert newServiceComponent;
        refId=newServiceComponent.id;
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Saving Record!'));
            return null;
        }
        finally
        {
            newServiceComponent=new Service_Component__c();
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Saved Successfully!'));
        Offering='None';
        if(refId!=null && refId!=''){
        PageReference pg=new PageReference('/'+refId);
        pg.SetRedirect(true);
        return pg;
        }
        else{
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Service Component not found'));
        }
        return null;
        }
 
}