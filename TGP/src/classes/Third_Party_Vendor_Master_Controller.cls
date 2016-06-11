/*
Author : Manik Chaudhary
Story  : Story-0276/SOL_127_a  
Description : Create/update Third party vendor master for each offering.. 
*/

public class Third_Party_Vendor_Master_Controller {

   public Third_Party_Vendor_Master_Custom__c thirdPVendorname{get;set;}
   public String Offering{get;set;}
 
   /******************************
    Method Name: Third_Party_Vendor_Master_Controller
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/
   
    public Third_Party_Vendor_Master_Controller(ApexPages.StandardController controller)
     {
        thirdPVendorname=new  Third_Party_Vendor_Master_Custom__c();
     }
    
    /******************************
    Method Name: getOfferings
    Description: Method to get Offering from the Offering Master.
    Paramenters: NA
    Return Value: NA
    *******************************/  
    
     public List<SelectOption> getOfferings()
     {
        List<SelectOption> Offerings=new List<SelectOption>();
        Offerings.add(new SelectOption('','--None--')); 
        
        //Query to fetch from Offering Master   
        List<Offerings_Master__c>  OfferingsMaster=[select name,id from Offerings_Master__c where Active__c=:true order by name ];
       
        //Check the Size of the List 
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
    Method Name: saveMethod
    Description: Method to Save records.
    Paramenters: NA
    Return Value: NA
    *******************************/   


     public PageReference saveMethod(){
        
       /* if(ThirdPVendorname==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Provide Value in Third party Vendor Name !'));
            
        }
        
        
        List<Offerings_Master__c> offeringMaster = new List<Offerings_Master__c>();
        
        //Fetch the offering master records.
        offeringMaster = [Select Id from Offerings_Master__c where Name=:offering];
        */
        thirdPVendorname.Offering_Master__c=Offering;
        try
        {
            
            insert thirdPVendorname;     //insert the records in the Third Party Vendor Master object 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Saved Successfully!'));
            
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Saving Record!'));
            return null;     
        }
        /*finally
        {
            thirdPVendorname=new  Third_Party_Vendor_Master_Custom__c();
            Offering=''; 
        }*/
        
       PageReference Ref=new PageReference('/'+thirdPVendorname.id);  //to redirect to the detail page of the inserted record
       Ref.setredirect(true);
       return Ref;

        
       
        }
    /******************************
    Method Name: cancelMethod
    Description: Method to Cancel the modification.
    Paramenters: NA
    Return Value: NA
    *******************************/  
        public PageReference cancelmethod()
        {
            thirdPVendorname=new  Third_Party_Vendor_Master_Custom__c();
            Offering='';
            return null;
        }


}