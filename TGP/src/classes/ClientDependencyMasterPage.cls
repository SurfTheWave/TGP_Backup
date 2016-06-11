/*
Author : Mayank Tayal
Story  : Story-0039/SOL_002  
Description : Controller for clientDependencyMasterPage page.Maintaining Client Dependency Master.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
public class ClientDependencyMasterPage {
    public Client_Dependency_Master__c newDependency {get;set;}
    public String Offering{get;set;}
    public String Service{get;set;}
    public List<Client_Dependency_Master__c> listDependenciesActual{get;set;}
    //Added for Category coming from Master.
    public String categoryMaster{get;set;}
    /******************************
    Method Name: ClientDependencyMasterPage 
    Description: Constructor for ClientDependencyMasterPage
    Paramenters: controller
    Return Value: 
    *******************************/
    //Start
    public ClientDependencyMasterPage (ApexPages.StandardController controller) {
        newDependency = new Client_Dependency_Master__c();
        listAllRecords();
    }
    //End

    /******************************
    Method Name: getOfferings 
    Description: Added method to get Offerings only related to Offerings Master.
    Paramenters: 
    Return Value: Offerings
    *******************************/
    //Start
    public List<SelectOption> getOfferings()
    {
        List<SelectOption> Offerings=new List<SelectOption>();
        Offerings.add(new SelectOption('Common','Common')); 
        for(Offerings_Master__c o:[select name from Offerings_Master__c])
        { 
            Offerings.add(new SelectOption(o.name, o.name));              
        }
       
        return Offerings;
    }
    //End
     
    /******************************
    Method Name: getServices 
    Description: Add method to get services only related to Service master
    Paramenters: 
    Return Value: Services
    *******************************/
    //Start
    public List<SelectOption> getServices()
    {
        List<SelectOption> Services=new List<SelectOption>();
        Services.add(new SelectOption('Common','Common'));
        for(Service_Master__c o:[select name,id from Service_Master__c where Offering__r.Name=:offering])
        { 
            Services.add(new SelectOption(o.name, o.name));              
        }
        return Services;
    } 
    //End
    /******************************
    Method Name: getCategory
    Description: Add method to get category only related to Category master
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public List<SelectOption> getCategory(){
       List<SelectOption> category=new List<SelectOption>();
       List<Category__c> cat=[select id,name,Active__c  from Category__c where Active__c = true order by name];
       if(cat.Size()>0){
          for(Category__c c : cat){
            category.add(new SelectOption(c.id, c.name)); 
          }
       }
        return category;
    }          
    //End
    /******************************
    Method Name: insertNewRecord 
    Description: To add records for ClientDependency Master.
    Paramenters: 
    Return Value: null
    *******************************/
    //Start
    public PageReference insertNewRecord(){
       
         if(newDependency.Client_Dependency__c == '' ||newDependency.Client_Dependency__c == null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Mandatory Fields cannot be left blank.'));
                return null;
         }
         
         else {
            if (!('None'.equals(Offering))|| !('None'.equals(Service))){
                List<Offerings_Master__c> offMaster = new List<Offerings_Master__c>();
                offMaster = [Select Id from Offerings_Master__c where Name=:Offering];
                if(offMaster.size()>0)
                    newDependency.Offering__c = offMaster[0].Id;
                else
                    newDependency.Offering__c = null;
                List<Service_Master__c> serMaster =  new List<Service_Master__c>();
                serMaster = [Select Id,name from Service_Master__c where Name=:Service];
                if(serMaster.size()>0)
                    newDependency.Services_per_offering__c = serMaster[0].id;
                else
                    newDependency.Services_per_offering__c=null;
            }
            newDependency.Category_Master__c=categoryMaster;
            try{
           insert newDependency;
           newDependency = new Client_Dependency_Master__c();
            }
            catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Loading page!'));
            return null;
            }
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Added Successfully!'));
        offering='None';
        service='None';
        listAllRecords();
        return null;
    }
    //End
    
    /******************************
    Method Name: updateRecord 
    Description: For saving records in Client Dependency Master.
    Paramenters: 
    Return Value: null
    *******************************/
    //Start
    public PageReference updateRecord(){
        try{
            upsert listDependenciesActual;
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Loading page!'));
            return null;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Saved Successfully!'));
        listAllRecords();
        return null;
    }
    //End
   
    /******************************
    Method Name: cancelUpdate 
    Description: Added method to cancel.
    Paramenters: 
    Return Value: null
    *******************************/
    //Start
    public PageReference cancelUpdate(){
        listAllRecords();
        return null;
    }
    //End
   
    /******************************
    Method Name: listAllRecords 
    Description: Method to get list of All records in Client Dependency Master.
    Paramenters: 
    Return Value: void
    *******************************/
    //Start
     public void listAllRecords() {    
        listDependenciesActual = new Client_Dependency_Master__c[]{};
        for(Client_Dependency_Master__c clientDep :[Select Category__c,Offering_Form__c,Services_per_Offering_form__c,Category_Master__c ,Client_Dependency__c,Offering__r.Name,Services_per_Offering__r.Name,Active_Inactive__c from Client_Dependency_Master__c ORDER BY CreatedDate Desc])
        listDependenciesActual.add(clientDep);
    }
    //End
}