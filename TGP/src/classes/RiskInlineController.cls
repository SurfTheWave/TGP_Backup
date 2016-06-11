/*
Author : Shridhar Patankar
Story  : Story-0044/SOL_011  
Description : Controller for riskInline page.Display logic for Risk. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Mayank Tayal    Sol_148                    5/15/2013        Sol UAM-Release 2
Shridhar Patankar Sol_151                  30/05/2013       Added Classification field and Category now coming from master.
*/
public with sharing class RiskInlineController {
 public Risk__c newRisk {get;set;}
 //public List<Risk__c> listProfileDetailsActual {get;set;}
 public List<WrapperRisk> lstRisk{get;set;}
 public List<Opportunity_Offering__c> oppOff {get;set;}
 public Opportunity_Offering__c offering1{get;set;}
 public Boolean addButtonRender {get; set;}
 public Boolean saveEditButtonRender {get; set;}
 public Boolean deleteButtonRender {get; set;}
 public Boolean refreshPage {get; set;}
 public String oppOffId{get;set;}
 public List<Risk_Master__c> listRiskMaster {get;set;}
 public List<Risk__c> listRisk{get;set;}
 public Risk_Master__c newRiskMaster {get;set;}
 public String Service{get;set;}
 public List<Services__c> servicesAdd {get;set;}
 public List<Services__c> servicesSave {get;set;}
 public String ServiceFilter{get;set;}
 public String opportunityName{get;set;}
 public String offeringName{get;set;}
 //Added for Category coming from Master.
 public String categoryMaster{get;set;}
 //Added for Filter Category
 public String categoryMasterFilter{get;set;}
 //Variables Added for Filters.Start
 public String allCategoryPicklistDefault{get;set;}
 // the soql without the order and limit
 public String soql {get;set;}
 public String sortField{get;set;}
 public String Option{get;set;}
 public String cat{get;set;}
 public Boolean edit{get;set;}
 public Boolean app{get;set;}
 public String serv{get;set;}
 public String riskImpact{get;set;}
 public String riskProb{get;set;}
 public String raisedBy{get;set;}
 public Date raisedOn{get;set;}
 public Boolean appFilter{get;set;}
 public Boolean canFilter{get;set;}
 public String valueFilter{get;set;}
 public Boolean apply{get;set;}
 public Boolean cancel{get;set;}
 public Boolean readOnlyMode{get;set;}
 public String fileIdDelete ;
 //End
 //For Delete

    public String getFileIdDelete(){
        return fileIdDelete;
    }
    
    public void setFileIdDelete(String fileIdDelete){
        this.fileIdDelete = fileIdDelete;
    }
    /******************************
    Method Name: RiskInlineController
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/   
    public RiskInlineController (ApexPages.StandardController controller) {
       offering1=(Opportunity_Offering__c)controller.getRecord();
       newRisk = new Risk__c();
       addButtonRender = true;
       appFilter=false;
       categoryMasterFilter='All';
       apply=true;
       valueFilter='Apply Filter';
       
       /*String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;//Get users with Profile Name
       //Logic to not show add button for Sol Admin and Sol Leadership profile.
       List<Sol_UAM_Access_Setting__c> solUamAccess = new List<Sol_UAM_Access_Setting__c>();
       solUamAccess = Sol_UAM_Access_Setting__c.getall().values(); 
         for(Sol_UAM_Access_Setting__c solUam : solUamAccess){
            if(usrProfileName.equalsIgnoreCase(solUam.Profile_Name__c) && solUam.Read_Access__c == true && usrProfileName.equalsIgnoreCase(solUam.Role_Name__c) && usrProfileName.equalsIgnoreCase(solUam.Logic_Role_Name__c)){
              addButtonRender = false ;
          }
       }*/
       riskCall();
       newRisk = new Risk__c();
       listAllRecords();
       oppOffId = ApexPages.CurrentPage().getParameters().get('id');
      List<Opportunity_Offering__c> oppOff = [Select Id,Name,Offering_Text_Name__c,Opportunity_TGP__r.name, Offering_Master__r.Name,Active__c from Opportunity_Offering__c where Id=: oppOffId];
      if(oppOff.size()>0)
      {
          opportunityName=oppOff[0].Opportunity_TGP__r.name;
          offeringName=oppOff[0].Offering_Master__r.name;
      }
      //UAM Code--Mayank Tayal-Sol_148
        if(oppOffId!=null)
        {
           /* List<Opportunity_Offering__c> lstOffering = [select id, name, Opportunity_TGP__c from Opportunity_Offering__c where id = : oppOffId];
            Transient String strOppId = lstOffering.get(0).Opportunity_TGP__c;
            UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Risk__c');            
            addButtonRender = m.get('C');
            saveEditButtonRender = m.get('U');
            deleteButtonRender  = m.get('D');*/
            addButtonRender =UAMSolMobUtility.addButtonRender_BPOOppTgp;
            saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
            deleteButtonRender = UAMSolMobUtility.deleteButtonRender_BPOOppTgp;
        }
        if(addButtonRender==false && saveEditButtonRender==false)
        {
            readOnlyMode=true;
        } 
        if(sortField == null)
        {
            sortField = 'Category_Master__r.Name';
            runQuery();
        }
    }
    // the current sort direction. defaults to asc
      public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
      }
      // toggles the sorting of query from asc<-->desc
      public void toggleSort() {
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        // run the query again
        runQuery();
      }
      // format the soql for display on the visualforce page
      public String debugSoql {
        get { return soql + ' order by ' + sortField + ' ' + sortDir; }
        set;
      }
    /******************************
    Method Name: riskCall
    Description: To retrieve risk,risk Master and Service Master based on the offering.
    Paramenters: NA
    Return Value: NA
    *******************************/  
    public void riskCall(){
        categoryMasterFilter='All';
        ServiceFilter='All';
        edit=false;
        app=false;
        riskImpact='';
        riskProb='';
        raisedBy='';
        offering1.Date__c=null;
        offering1.Probability__c=null;
          oppOffId = ApexPages.CurrentPage().getParameters().get('id');
          if(oppOffId != null && oppOffId!=''){
            soql='Select Category__c,Category_Master__r.Name,Category_Master__c,Risk__c,Potential_Impact__c,Mitigation__c,Risk_probability__c,Risk_Impact__c,Raised_by__c,Raised_On__c,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c, Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Risk_Master__r.Risks__c,Opportunity_Offering__r.Name,Classification__c from Risk__c where Opportunity_Offering__c = : oppOffId';
            oppOff = new List<Opportunity_Offering__c>();   
            //Query to get Offerings related to current id.
            oppOff =[Select Id,Name,Offering_Text_Name__c,Offering_Master__r.Name,Active__c from Opportunity_Offering__c where Id=: oppOffId];
             //Query to get list of Risk
           listRisk = [Select Category__c,Risk__c,Category_Master__r.Name,Category_Master__c,Potential_Impact__c,Mitigation__c,Risk_probability__c,Risk_Impact__c,Raised_by__c,Raised_On__c,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,
                       Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Risk_Master__r.Risks__c,Opportunity_Offering__r.Name,Classification__c 
                       from Risk__c where Opportunity_Offering__c = : oppOffId ORDER BY CreatedDate DESC];
           listRiskMaster = new List<Risk_Master__c>();
              //Query to get list of Risk Master.
           listRiskMaster = [Select Category__c,Risks__c,Offering_Form__c,Services_per_Offering_form__c,Category_Master__c,id,Offering_Master__r.name,Service_Master__r.Name ,Name,Active_Inactive__c, Classification__c
                                    from Risk_Master__c where Active_Inactive__c= :true and (Offering_Master__r.name =:oppOff[0].Offering_Master__r.Name )
                                     // OR  Offering_Master__r.name =:'')
                                    ORDER BY CreatedDate DESC];
            lstRisk = new List<WrapperRisk>();
           if( listRisk!=null && listRisk.size()<=0)
       {
              if(listRiskMaster!=null && listRiskMaster.size()>0)
            {
                for(Risk_Master__c newRiskmaster: listRiskMaster)
                {
                      Risk__c newRiskMasterRecord= new Risk__c();
                      newRiskMasterRecord.Category_Master__c=newRiskmaster.Category_Master__c;
                      newRiskMasterRecord.Risk__c=newRiskmaster.Risks__c;
                      newRiskMasterRecord.Services_per_Offering__c=newRiskmaster.Services_per_Offering_form__c;  
                       newRiskMasterRecord.Classification__c=newRiskmaster.Classification__c;
                        WrapperRisk wRisk=new WrapperRisk(newRiskMasterRecord);
                     //Null Check to render inlineEditing.
                     if(newRisk.Click_Here__c ==null || newRisk.Click_Here__c == ''){
                      wRisk.flagMaster=false;
                      wRisk.flagMaster1=false;
                      wRisk.flagMaster2=true;
                      wRisk.flagMaster3 =false;
                     }
                     lstRisk.add(wRisk);
                }
            }
                       
           }
           else{
                     lstRisk = new List<WrapperRisk>();
                     for(Risk__c risk :listRisk){
                     WrapperRisk wRisk =new WrapperRisk(risk);
                     //Null Check to render inlineEditing.
                     if(risk.Click_Here__c ==null || newRisk.Click_Here__c == ''){
                         wRisk.flagMaster=false;
                         wRisk.flagMaster1 =false;
                         wRisk.flagMaster2 =true;
                         wRisk.flagMaster3 =false;
                     }
                     lstRisk.add(wRisk );
                     
                 }
                 
         }
      }
      else
       {
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Offering Id not found'));
       }
    }
     /******************************
    Method Name: runQuery
    Description: To run query of assumptions.
    Paramenters: NA
    Return Value: NA
    *******************************/  
      public void runQuery() {
 
        try {
          
          listRisk = Database.query(soql + ' order by ' + sortField + ' ' + sortDir);
          lstRisk = new List<WrapperRisk>();
          
        } catch (Exception e) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'+e));
        }
        
       
               if(listRisk.size()>0){
                     
                 for(Risk__c risk :listRisk){
                     WrapperRisk wRisk =new WrapperRisk(risk);
                     //Null Check to render inlineEditing.
                     if(risk.Click_Here__c ==null || newRisk.Click_Here__c == ''){
                         wRisk.flagMaster=false;
                         wRisk.flagMaster1 =false;
                         wRisk.flagMaster2 =true;
                         wRisk.flagMaster3 =false;
                     }
                     lstRisk.add(wRisk );
                     
                 }
               }
     
      }
    /******************************
    Class Name: WrapperRisk
    Description: Wrapper class for Risk
    Paramenters: newRisk
    Return Value: NA
    *******************************/ 
    //Start
     public class WrapperRisk
     {
         public Risk__c newRisk {get;set;}
         public boolean flagMaster{get;set;}
         public boolean flagMaster1{get;set;}
         public boolean flagMaster2{get;set;}
         public boolean flagMaster3{get;set;}
        /******************************
        Method Name: WrapperRisk
        Description: Constructor for Initializing
        Paramenters: newRisk
        Return Value: NA
        *******************************/   
        public WrapperRisk(Risk__c newRisk){
            this.newRisk =newRisk;
            flagMaster=true;
            flagMaster1 =true;
            flagMaster2=false;
            flagMaster3 = true;
        }         
    } 
    //End
    /******************************
    Method Name: getServicesdrop
    Description: Method to get Services.
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public List<SelectOption> getServicesdrop() 
    {
        List<SelectOption> Servicesdrop=new List<SelectOption>();
        Servicesdrop.add(new SelectOption('Common','Common')); 
        List<Service_Master__c > serviceMaster = new List<Service_Master__c >();
        if(oppOff!=null){
            if(oppOff[0].id!=null )
            {
                serviceMaster = [select name,Offering__c from Service_Master__c where Offering__r.Name=:oppOff[0].Offering_Master__r.Name and Active__c = :true];
            }
            if(serviceMaster.Size()>0)
            {
                //Iterate through Service Master.      
                for(Service_Master__c o:serviceMaster)
                { 
                    Servicesdrop.add(new SelectOption(o.name, o.name));              
                }
            }
        }
        return Servicesdrop;
    }
    /******************************
    Method Name: getServicesFilter
    Description: Method to get Services.
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public List<SelectOption> getServicesFilter() 
    {
        List<SelectOption> ServicesFilter=new List<SelectOption>();
        ServicesFilter.add(new SelectOption('All','All')); 
        List<Service_Master__c > serviceMaster = new List<Service_Master__c >();
        if(oppOff!=null){
            if(oppOff[0].id!=null )
            {
                serviceMaster = [select id,name,Offering__c from Service_Master__c where Offering__r.Name=:oppOff[0].Offering_Master__r.Name and Active__c = :true];
            }
            if(serviceMaster.Size()>0)
            {
                //Iterate through Service Master.      
                for(Service_Master__c o:serviceMaster)
                { 
                    ServicesFilter.add(new SelectOption(o.name, o.name));              
                }
            }
                ServicesFilter.add(new SelectOption('Common','Common'));  
        }
        return ServicesFilter;
    }
    /******************************
    Method Name: getCategory
    Description: Add method to get category only related to Category master
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public List<SelectOption> getCategory(){
       List<SelectOption> category=new List<SelectOption>();
       List<Category__c> cat=[select id,name from Category__c where Active__c=true order by name];
       if(cat.Size()>0){
          for(Category__c c : cat){
            category.add(new SelectOption(c.id, c.name)); 
          }
       }
        return category;
    }          
    //End
    /******************************
    Method Name: getCategoryFilter
    Description: Add method to get category only related to Category master
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public List<SelectOption> getCategoryFilter(){
       List<SelectOption> category=new List<SelectOption>();
       List<Category__c> cat=[select id,name,Active__c  from Category__c where Active__c = true order by name];
       if(cat.Size()>0){
          for(Category__c c : cat){
            category.add(new SelectOption(c.id, c.name)); 
          }
          category.add(new SelectOption('All','All')); 
       }
        return category;
    }          
    //End
     /******************************
     Method Name: addNewOppOffer
     Description: Method to add Risk.
     Paramenters: NA
     Return Value: NA
     *******************************/ 
     public PageReference addNewOppOffer() {
         //Check for Risk Probability
        if(newRisk.Risk_probability__c>100 || newRisk.Risk_probability__c<0 ){
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Risk Probability cannot be greater than 100% or less than 0%'));
               return null;
        }
        //Null check for Category and Risk
        if(newRisk.Risk__c==null)
           {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Risk cannot be left blank'));
              return null;
            }
         //Null check for Classification field
        if(newRisk.Classification__c ==null)
           {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Classification cannot be None. Please select another value'));
              return null;
           }
         //Added to get assumptions from master related to Services also.
              //Start
              
              servicesAdd = new List<Services__c>();
              //servicesAdd =[Select id,name,Active__c,Opportunity_Offering__c,Service_Master__c,Service_Master__r.name from Services__c where Opportunity_Offering__c=:oppOffId];
              servicesAdd =[Select id,name,Active__c,Service_Delivery_Location__c,Service_Master__c,Service_Master__r.name from Services__c where Service_Delivery_Location__r.Opportunity_Offering__c=:oppOffId];
              //End 
                   Transient Boolean AddService=false;
                   for(Services__c se : servicesAdd)
                   {
                        
                        if(se.Name==Service)
                        AddService=true;
                        
                   }
                    if(Service=='Common')
                    {
                      AddService=true; 
                    }
                    if(AddService==False)
                    {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Risks can be added for the service in scope. Please check the service for which you are trying to add risks'));
                    return null;
                    }
         newRisk.Opportunity_Offering__c =  oppOffId;
         newRisk.Services_per_Offering__c = Service ;
         newRisk.Category_Master__c=categoryMaster;
      try
        {
             insert newRisk;
            // saveAccProfileDetails(); 
             newRisk = new Risk__c();
             riskCall();
        } 
         
      catch(Exception ex)
        {
             //INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY
             if(ex.getMessage().contains('INSUFFICIENT_ACCESS')){
                   
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have permission to perform this action. '));
                   //return null;
               }else { 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Loading page'));
            }
            return null;
        }
        finally
        {
            newRisk = new Risk__c();
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Added Successfully'));
        listAllRecords();
        
        return null;
    }
    /******************************
     Method Name: listAllRecords
     Description: Method to get list of all records.
     Paramenters: NA
     Return Value: NA
     *******************************/  
    public void listAllRecords()
    {    
        List<Risk__c> listProfileDetailsActual = new Risk__c[]{};
        //Iterate through risk
        for(Risk__c risk :[Select Category__c,Category_Master__c,Risk__c,Risk_Master__r.Risks__c,Potential_Impact__c,Mitigation__c,Risk_probability__c,Risk_Impact__c,Raised_by__c,Raised_On__c,Services_per_Offering__c,Click_Here__c ,Editable__c,Applicable__c,Classification__c from Risk__c ORDER BY CreatedDate DESC])
        listProfileDetailsActual.add(risk);       
    }
    /******************************
     Method Name: saveAccProfileDetails
     Description: Method to save Risk.
     Paramenters: NA
     Return Value: NA
     *******************************/  
     public void saveAccProfileDetails()
     {
        List <Risk__c > uplist=new List <Risk__c >();
        //Added to get assumptions from master related to Services also.
         //Start
         servicesSave = new List<Services__c>();
         //servicesSave =[Select id,name,Active__c,Opportunity_Offering__c,Service_Master__c,Service_Master__r.name from Services__c where Opportunity_Offering__c=:oppOffId];
         servicesSave =[Select id,name,Active__c,Service_Delivery_Location__c,Service_Master__c,Service_Master__r.name from Services__c where Service_Delivery_Location__r.Opportunity_Offering__c=:oppOffId];
         //End 
         //Iterate through wrapper risk
         for(WrapperRisk wrapRisk: lstRisk){
          
            //Check for risk probability
            if(wrapRisk.newRisk.Risk_probability__c>100 || wrapRisk.newRisk.Risk_probability__c<0 ){
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Risk Probability cannot be greater than 100% or less than 0%'));
               riskCall();
               return;
              
            }
          //Null check for risk
          if(wrapRisk.newRisk.Risk__c==null)
           {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Risk cannot be left blank'));
               riskCall();
               return;
               
            }
         //Null check for classification
           if(wrapRisk.newRisk.Classification__c==null)
           {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Classification cannot be None, please select another value')); 
              //riskCall();              
              return;
           }
           Transient Boolean AddService=false;
                   for(Services__c se : servicesSave )
                   {
                        
                        if(se.Name==wrapRisk.newRisk.Services_per_Offering__c)
                        AddService=true;
                        
                   }
                    if(wrapRisk.newRisk.Services_per_Offering__c=='Common' || wrapRisk.newRisk.Services_per_Offering__c==Null)
                    {
                      AddService=true; 
                    }
                    if(AddService==False)
                    {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Risks can be added for the service in scope. Please check the service for which you are trying to add risk'));
                    return;
                    }   
         uplist.add(wrapRisk.newRisk);  
        }
        try{
            upsert uplist;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Updated Successfully'));
         }
         catch(Exception ex) {
          //INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY
             if(ex.getMessage().contains('INSUFFICIENT_ACCESS')){
                   
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have permission to perform this action. '));
                   //return null;
               }else { 
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving record'));
             }
             
          }
           riskCall();
           refreshPage= true;           
     }
        /******************************
        Class Name: backToOffer
        Description: To go Back to Opportunity Offering Page
        Paramenters: NA
        Return Value: PageReference
        *******************************/
       public PageReference backToOffer()
       {
           PageReference pg=new PageReference('/'+oppOffId);
           pg.setRedirect(true);
           return pg;
       }
       
        /******************************
        Class Name: ExportRisk
        Description: To get the records in Excel 
        Paramenters: NA
        Return Value: PageReference
        *******************************/
       public PageReference ExportRisk()
       {
           PageReference pg=new PageReference('/apex/ExportRiskPage?id='+oppOffId);
           pg.setRedirect(true);
           return pg;
       }
    /**********************************************
    Method Name: doCancel
    Description: To cancel the modifications 
    Paramenters: NA
    Return Value: void
    ***********************************************/
    public void doCancel()
    {
        /*PageReference pg=new PageReference('riskInline?id='+oppOffId);
        pg.setRedirect(true);
        return pg;*/
        riskCall();
        clearFilter();
        listAllRecords();
    }
    /**********************************************
     Start for Filter Criteria
    ***********************************************/
    // runs the search with parameters passed via Javascript
    
  public PageReference searchServer() {
    String emptyString='';

      soql='Select Category__c,Category_Master__r.Name,Category_Master__c,Risk__c,Potential_Impact__c,Mitigation__c,Risk_probability__c,Risk_Impact__c,Raised_by__c,Raised_On__c,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c, Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Risk_Master__r.Risks__c,Opportunity_Offering__r.Name,Classification__c from Risk__c where Opportunity_Offering__c = : oppOffId';
      if(cat!=null)
      {
          List<Category__c> tempCatMaster=[select name from Category__c where id=:cat ];
          if(tempCatMaster.Size()>0){
            soql += ' and Category_Master__r.name LIKE \''+String.escapeSingleQuotes(tempCatMaster[0].name)+'%\'';
          }
      }
      else if(categoryMasterFilter=='All')
       {
          soql='Select Category__c,Category_Master__r.Name,Category_Master__c,Risk__c,Potential_Impact__c,Mitigation__c,Risk_probability__c,Risk_Impact__c,Raised_by__c,Raised_On__c,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c, Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Risk_Master__r.Risks__c,Opportunity_Offering__r.Name,Classification__c from Risk__c where Opportunity_Offering__c = : oppOffId';
       }
      if(ServiceFilter!='All')
      {
      soql += ' and Services_per_Offering__c LIKE \''+String.escapeSingleQuotes(ServiceFilter)+'%\'';
      }
      else if(ServiceFilter=='Common')
      {
        soql += ' and (Services_per_Offering__c LIKE \''+String.escapeSingleQuotes(ServiceFilter)+ '\'OR Services_per_Offering__c=\'\')';
      }
      if (riskImpact!='')
      soql += ' and Risk_Impact__c LIKE \''+String.escapeSingleQuotes(riskImpact)+'%\'';
      if (riskProb!='')
      soql += ' and Risk_probability__c ='+riskProb;
      if (raisedBy!='')
      soql += ' and Raised_by__c LIKE \''+String.escapeSingleQuotes(raisedBy)+'%\'';
      if (raisedOn!=Null)
      {  
      Datetime d=raisedOn;
      soql += ' and Raised_On__c ='+d.formatGMT('yyyy-MM-dd');
      }
      if(edit==true)
      {  
          soql += ' and Editable__c=true';
      }
      else{
      
         soql += ' and Editable__c=false';
      }
      if(app== true)
      {
          
          soql += ' and Applicable__c=true';
      }
      else{
          
         soql += ' and Applicable__c=false';
      }
    
    runQuery();
 
    return null;
  }
  /**********************************************
    Method Name: applyFilter
    Description: To apply filter 
    Paramenters: NA
    Return Value: void
    ***********************************************/
    public void applyFilter()
    {
        appFilter=true;
        valueFilter='Clear Filter';
        cancel=true;
        apply=false;
    }
    /**********************************************
    Method Name: clearFilter
    Description: To clear filters 
    Paramenters: NA
    Return Value: void
    ***********************************************/
    public void clearFilter()
    {
        appFilter=false;
        riskCall();
        valueFilter='Apply Filter';
        apply=true;
        cancel=false;
    }
    /******************************
    Method Name: deleteFile
    Description: delete link
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference deleteFile()
    {
        //Iterate through Offering Scope Image
        for(Risk__c rsk : [Select Category__c,Risk__c,Category_Master__r.Name,Category_Master__c,Potential_Impact__c,Mitigation__c,Risk_probability__c,Risk_Impact__c,Raised_by__c,Raised_On__c,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Risk_Master__r.Risks__c,Opportunity_Offering__r.Name,Classification__c from Risk__c where Opportunity_Offering__c = : oppOffId and id=:fileIdDelete])
        {
            //To override file from Offering Scope Image.
            delete rsk ;         
        }    
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record deleted successfully'));
        riskCall();        
        return null;
    }
 }