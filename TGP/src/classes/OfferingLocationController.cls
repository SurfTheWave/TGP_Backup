/*
Author :  Mayank Tayal
Story  : Story-0168/SOL_071  
Description : Delivery locations Sections under Offering detail page.


Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Shridhar Patankar   Story-0168/SOL_071    4/03/2013         To prevent Duplicate Offering Locations.

*/
public with sharing class OfferingLocationController {
    public String pageid{get;set;}
    public String locationName{get;set;}
    public Boolean refreshPage {get; set;}
    public Boolean addButtonRender {get; set;}
    public Boolean saveEditButtonRender {get; set;}
    public Boolean deleteButtonRender {get; set;}
    public Delivery_Location__c newLocDetail{get;set;}
    public Delivery_Location__c[] listLocationDetailsActual{get;set;}
    public String fileIdDelete ;
    public Boolean readOnlyMode{get;set;}
    
    public String getFileIdDelete(){
        return fileIdDelete;
    }
    
    public void setFileIdDelete(String fileIdDelete){
        this.fileIdDelete = fileIdDelete;
    }

    /******************************
    Method Name: OfferingLocationController
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/  
    public OfferingLocationController(ApexPages.StandardController controller) {
        newLocDetail= new Delivery_Location__c();
        addButtonRender = true;
        /* String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;//Get users with Profile Name
         //Logic to not show add button for Sol Admin and Sol Leadership profile.
         List<Sol_UAM_Access_Setting__c> solUamAccess = new List<Sol_UAM_Access_Setting__c>();
         solUamAccess = Sol_UAM_Access_Setting__c.getall().values(); 
            for(Sol_UAM_Access_Setting__c solUam : solUamAccess){
                if(usrProfileName.equalsIgnoreCase(solUam.Profile_Name__c) && solUam.Read_Access__c == true && usrProfileName.equalsIgnoreCase(solUam.Role_Name__c) && usrProfileName.equalsIgnoreCase(solUam.Logic_Role_Name__c)){
                addButtonRender = false ;
          }
       }*/
        pageid=ApexPages.CurrentPage().getParameters().get('id');
        if(pageid!=null && pageid!=''){
        initializeDetailRecords();
        }
        else{
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Offering not found.'));
        }
        refreshPage = false;
        //UAM Code--Mayank Tayal-Sol_148
            if(pageid!=null)
            {
                /*List<Opportunity_Offering__c> lstOffering = [select id, name, Opportunity_TGP__c from Opportunity_Offering__c where id = : pageid];
                String strOppId = lstOffering.get(0).Opportunity_TGP__c;
                UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
                Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Services__c');            
                addButtonRender = m.get('C');
                saveEditButtonRender = m.get('U');
                deleteButtonRender  = m.get('D');*/
                
                addButtonRender = UAMSolMobUtility.addButtonRender_BPOOppTgp;
                saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
                deleteButtonRender  = UAMSolMobUtility.deleteButtonRender_BPOOppTgp;
            }
            if(addButtonRender==false && saveEditButtonRender==false)
            {
                readOnlyMode=true;
            }   

    }
    /******************************
    Method Name: getLocationNames
    Description: Method to get Locations.
    Paramenters: NA
    Return Value: NA
    *******************************/  
    public List<SelectOption> getLocationNames()
        {
            List<SelectOption> LocName=new List<SelectOption>();
            List<Delievery_Location_Master__c> DelieveryLocationMaster=[select id,name from Delievery_Location_Master__c where Active__c=true order by name];
            //Check size
            if(DelieveryLocationMaster.size()>0)
            {
                //Iterate through Delievery Location Master
                for(Delievery_Location_Master__c c: DelieveryLocationMaster)
                    { 
                        LocName.add(new SelectOption(c.id, c.name));              
                    }
            } 
            return LocName;
        } 
     /******************************
    Method Name: addNewLocDetail
    Description: Method to add Locations.
    Paramenters: NA
    Return Value: NA
    *******************************/      
    public PageReference addNewLocDetail() {
        //newLocDetail.Offering_Name__c=pageid;
        newLocDetail.Service_Delivery_Location__c=pageid;
        newLocDetail.Delivery_Location_Master__c=locationName;
        try{
        //Query to fetch Delivery Location records.
        List<Delivery_Location__c> dhl= [Select id,Active__c,Delivery_Location_Master__c,Service_Delivery_Location__c From Delivery_Location__c where Delivery_Location_Master__c = : newLocDetail.Delivery_Location_Master__c and Service_Delivery_Location__c=:pageid limit 1];
        if(dhl.size()==1)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record already exists.'));
            //Iniatialize records
            initializeDetailRecords();
            return null;
        }
         insert newLocDetail;              
        } catch(Exception ex){
           if(ex.getMessage().contains('INSUFFICIENT_ACCESS')){
                   
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access rights: Cannot be Added'));
                   //return null;
               }else {  
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving!'));
          }
          return null;
        }finally{
            newLocDetail=new Delivery_Location__c();
        }
        initializeDetailRecords();
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Added Successfully'));
        refreshPage = true;
        return null;
    }
    /******************************
    Method Name: initializeDetailRecords
    Description: Method to initialise detail records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void initializeDetailRecords() {
        listLocationDetailsActual = new Delivery_Location__c[]{};
          //Query to fetch Delivery_Location__c
            List <Delivery_Location__c> DeliveryLocation=[Select id,Active__c,Delivery_Location_Master__c from Delivery_Location__c where Service_Delivery_Location__c=:pageid];
            //Check size
            if(DeliveryLocation.size()>0)
            {
                //Iterate through DeliveryLocation
                for(Delivery_Location__c profDet :DeliveryLocation) 
                {
                    listLocationDetailsActual.add(profDet);                
                }
            }
    } 
   /******************************
    Method Name: saveLocationDetails
    Description: Method to save Location details.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public PageReference saveLocationDetails(){
     List<Delivery_Location__c> DeliveryLocation= new  List<Delivery_Location__c>();
     //Query to fetch records of Delivery location
      DeliveryLocation=[Select id,Active__c,Delivery_Location_Master__c from Delivery_Location__c where Service_Delivery_Location__c=:pageid];
       //Check size.
       if(DeliveryLocation.Size()>0)
       {
        Delivery_Location__c[] waveDetailsToUpsert = new Delivery_Location__c[]{};
        if(listLocationDetailsActual.size()>0)
        {
            //Iterate through list of Delivery Location
            for(Delivery_Location__c sm:listLocationDetailsActual)
            {
                //Query to fetch records of Delivery Location
                List<Delivery_Location__c> dhl= [Select id,Active__c,Delivery_Location_Master__c From Delivery_Location__c where Delivery_Location_Master__c = : sm.Delivery_Location_Master__c and Service_Delivery_Location__c=:pageid limit 1];
                if(dhl.size()==1)
                {
                    if(dhl[0].id != sm.id)
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record already exists.'));
                        initializeDetailRecords();
                        return null;
                    }
                }
            }
            //Logic to prevent Duplications.
            for(Delivery_Location__c s1:listLocationDetailsActual)
            {
                for(Delivery_Location__c s2:listLocationDetailsActual)
                if(s1.id!= s2.id)
                {
                   if(s1.Delivery_Location_Master__c == s2.Delivery_Location_Master__c && s1.Service_Delivery_Location__c==pageid && s2.Service_Delivery_Location__c==pageid)
                   {
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Duplication is not Allowed'));
                        initializeDetailRecords();
                        return null;
                   } 
                }
            }
        }
        
        waveDetailsToUpsert.addAll(listLocationDetailsActual);
        try {
            upsert waveDetailsToUpsert;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Updated Successfully'));
        }
        catch(Exception ex) {
            if(ex.getMessage().contains('INSUFFICIENT_ACCESS')){
                   
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access rights: Cannot be Updated'));
                   //return null;
               }else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving!'));
            
            }
            return null;
        }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please insert a record!'));
        }
       
        initializeDetailRecords();
        refreshPage = true;
        return null;
    }
   /******************************
    Method Name: refreshAccProfilePage
    Description: Method to cancel.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public PageReference refreshAccProfilePage(){
        initializeDetailRecords();
        refreshPage = true;
        return null;
    }
    /******************************
    Method Name: deleteFile
    Description: delete link
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference deleteFile()
    {
        //Iterate through Delivery Location
        for(Delivery_Location__c delLoc : [Select id,Active__c,Delivery_Location_Master__c From Delivery_Location__c where Service_Delivery_Location__c=:pageid and id=:fileIdDelete])
        {
            //To override file from Offering Scope Image.
            delete delLoc;           
        }    
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Deleted Successfully'));
        initializeDetailRecords();        
        return null;
    }


}