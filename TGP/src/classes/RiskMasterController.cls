/*
Author : Shridhar Patankar
Story  : Story-0041/SOL_004  
Description : Controller for riskMasterPage page.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
public class RiskMasterController {
    public String riskId{get;set;}
    public Risk_Master__c newRisk{get;set;}
    public String Offering{get;set;}
    public String Service{get;set;}
    public String Classification{get;set;}
    public List<Risk_Master__c >listProfileDetailsActual{get;set;}
    //Added for Category coming from Master.
    public String categoryMaster{get;set;}
    /******************************
    Method Name: RiskMasterController 
    Description: Constructor for RiskMasterController
    Paramenters: controller
    Return Value: 
    *******************************/
    //Start
    public RiskMasterController (ApexPages.StandardController controller) {
         newRisk = new Risk_Master__c();
         initializeDetailRecords();
    }
    //End
    
    /******************************
    Method Name: getOfferings 
    Description: Added method to get Offerings only related to Offerings Master.
    Paramenters: 
    Return Value: Offerings
    *******************************/
    //Start
     public List<SelectOption> getOfferings(){
        List<SelectOption> Offerings=new List<SelectOption>();
        Offerings.add(new SelectOption('Common','Common'));             
        for(Offerings_Master__c o:[select name,id from Offerings_Master__c])
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
        for(Service_Master__c o:[select name,Offering__c from Service_Master__c where Offering__r.Name=:offering])
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
    Description: To add records for Risk Master.
    Paramenters: 
    Return Value: void
    *******************************/
    //Start
     public void insertNewRecord() {  
            
            if(newRisk.Risks__c == '' || newRisk.Risks__c == null || newRisk.Classification__c == '' || newRisk.Classification__c == null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Mandatory Fields cannot be left blank.'));
                return;
            }
            
            else {
                if (!('None'.equals(Offering))|| !('None'.equals(Service))){
                    List<Offerings_Master__c> offMaster = new List<Offerings_Master__c>();
                    offMaster = [Select Id from Offerings_Master__c where Name=:Offering];
                    if(offMaster.size()>0)
                        newRisk.Offering_Master__c = offMaster[0].Id;
                    else
                        newRisk.Offering_Master__c = null;
                    List<Service_Master__c> serMaster =  new List<Service_Master__c>();
                    serMaster = [Select Id,name from Service_Master__c where Name=:Service];
                    if(serMaster.size()>0)
                        newRisk.Service_Master__c = serMaster[0].id;
                    else
                        newRisk.Service_Master__c=null;
                }
                newRisk.Category_Master__c=categoryMaster;
                try{
                    insert newRisk;
                    newRisk = new Risk_Master__c();
                }
                catch(Exception ex) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Loading page!'));
                    return;
                }
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Added Successfully!'));
            offering='None';
            service='None';
            initializeDetailRecords();
        }
        //End
     
    /******************************
    Method Name: updateRecord 
    Description: For saving records in Risk Master.
    Paramenters: 
    Return Value: void
    *******************************/
    //Start
    public void updateRecord() {
        try{
            upsert listProfileDetailsActual;
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Loading page!'));
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Saved Successfully!'));        
        initializeDetailRecords();
    }
    //End
   
    /******************************
    Method Name: cancelUpdate 
    Description: Added method to cancel.
    Paramenters: 
    Return Value: void 
    *******************************/
    //Start
    public void cancelUpdate(){
        initializeDetailRecords();
    }
    //End
   
    /******************************
    Method Name: listAllRecords 
    Description: Method to get list of All records in Risk Master.
    Paramenters: 
    Return Value: void
    *******************************/
    //Start
    public void initializeDetailRecords() {       
        listProfileDetailsActual = new List<Risk_Master__c >(); 
        for(Risk_Master__c profDet : [Select Category__c,Offering_Form__c,Services_per_Offering_form__c,Category_Master__c,Risks__c,Offering_Master__r.Name,Service_Master__r.Name,Active_Inactive__c,Classification__c from Risk_Master__c order by CreatedDate DESC ])
             listProfileDetailsActual.add(profDet); 
    }
    //End
}