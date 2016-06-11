/*
Author : Mayank Agrawal
Story  : Story-0040/SOL_003  
Description : Controller for assumptionMasterPage page. Maintaining Master Assumption.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
public class AssumptionMasterPageController {
    public Assumption_Master__c newAssumption {get;set;}
    public String Offering{get;set;}
    public String Service{get;set;}
    public Assumption_Master__c[] listnewAssumption {get;set;}
    //Added for Category coming from Master.
    public String categoryMaster{get;set;}
    /*public void dummyFunc(){}*/
    /******************************
    Method Name: AssumptionMasterPageController 
    Description: Constructor for AssumptionMasterPageController
    Paramenters: controller
    Return Value: 
    *******************************/
    //Start
    public AssumptionMasterPageController (ApexPages.StandardController controller){
        newAssumption= new Assumption_Master__c();
        listAllRecords();
    }
    //End
    
  /******************************
    Method Name: getOfferings 
    Description: Added method to get Offerings
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
    Description: To add records for assumption
    Paramenters: 
    Return Value: void
    *******************************/
    //Start
    public void insertNewRecord(){
       
         if(newAssumption.Assumption__c == '' || newAssumption.Assumption__c == null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Mandatory Fields cannot be left blank.'));
             return;
         }
         if(newAssumption.Classification__c== '' || newAssumption.Classification__c == null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Classification field cannot be None.'));
             return;
         }
         
         else {
           // if (!('None'.equals(Offering))|| !('None'.equals(Service))){
                List<Offerings_Master__c> offMaster = new List<Offerings_Master__c>();
                offMaster = [Select Id from Offerings_Master__c where Name=:Offering];
                if(offMaster.size()>0)
                    newAssumption.Offering__c = offMaster[0].Id;
                else
                    newAssumption.Offering__c=null;
                List<Service_Master__c> serMaster =  new List<Service_Master__c>();
                serMaster = [Select Id,name from Service_Master__c where Name=:Service];
                if(serMaster.size()>0)
                    newAssumption.Services_per_offering__c = serMaster[0].id;
                else
                    newAssumption.Services_per_offering__c=null;
           // }
            newAssumption.Category_Master__c=categoryMaster;
            //newAssumption.Offering__c=Offering;

            //newAssumption.Services_per_Offering__c=Service;


            try{
            insert newAssumption;
                newAssumption= new Assumption_Master__c();
            }
            catch(Exception ex) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Loading page!'));
                return;
            }
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Added Successfully!'));
        offering='None';
        service='None';
        listAllRecords();
    }
    //End
    
    /******************************
    Method Name: updateRecord 
    Description: For saving records in Assumption
    Paramenters: 
    Return Value: void
    *******************************/
    //Start
    public void updateRecord(){
           
        try{
            upsert listnewAssumption;
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Loading page!'));
            return;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Saved Successfully!'));
        listAllRecords();
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
        listAllRecords();
    }
    //End
   
    /******************************
    Method Name: listAllRecords 
    Description: Method to get list of All records in Assumption Master.
    Paramenters: 
    Return Value: void
    *******************************/
    //Start
    public void listAllRecords(){    
        listnewAssumption = new Assumption_Master__c[]{};
        //Search for Assumption Master
        for(Assumption_Master__c assm :[Select Category__c,Offering_Form__c,Services_per_Offering_form__c,Category_Master__c,Classification__c,Assumption__c,Offering__r.Name,Services_per_Offering__r.Name,Active_Inactive__c from Assumption_Master__c ORDER BY CreatedDate Desc])     
        listnewAssumption.add(assm);
    }
    //End
}