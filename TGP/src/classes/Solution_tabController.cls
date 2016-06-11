/*
Author : Shridhar Patankar
Story  : Release 2
Description : Controller for Solution Tab.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Mayank Tayal    Sol_148                    5/15/2013           Sol UAM-Release 2

*/
public class Solution_tabController {

     public PageReference Cancel() {
        return null;
    }
    

    public List<Opportunity_TGP__c> opp {get;set;}
    public Boolean addButtonRender {get; set;}
    public Boolean saveEditButtonRender {get; set;}
    public Boolean OfferingUser{get;set;}
    public Boolean OfferingUserEdit{get;set;}
    public String tabFocus{get;set;}
    public String tabFocusTemp{get;set;}
    public Boolean flag{get;set;}
    public Boolean isVisible{get;set;}
    public String isVisibleTemp{get;set;}
    public Boolean Assum{get;set;}
    public Integer Count{get;set;}
    public Integer CountService{get;set;}
    public Integer CountRisk{get;set;}
    public Integer CountClient{get;set;}
    public String CountTemp{get;set;}
    public String CountTempService{get;set;}
    public String CountTempRisk{get;set;}
    public String CountTempClient{get;set;}
    public Boolean AddSolCharUserEdit{get;set;}
    public Boolean AddSolCharUser{get;set;}
    public Boolean OfferingMsg{get;set;}
    String strTab{get;set;}
    public Boolean plus1{get;set;}
    public Boolean plus2{get;set;}
    public Boolean plus3{get;set;}
    public Boolean plus4{get;set;}
    public Boolean plus5{get;set;}
    public Boolean button0{get;set;}
    public Boolean button1{get;set;}
    public Boolean button2{get;set;}
    public Boolean button3{get;set;}
    public Boolean button4{get;set;}
    
    //Third Party Vendor Master variables.
    public String[] thirdPartyvendor{get;set;} 
    public Third_Party_Vendor_Master_Custom__c thirdPartyVendorMaster {get;set;}
    public Boolean vendor{get;set;}
    
    //Assumption variables Start
    public Opportunity_Offering__c oppOffering {get;set;}
    public String offId{get;set;}
    public List<Assumption_Master__c> listAssumptionMaster{get;set;}
    public List<Assumption_Master__c> listAssumptionMasternew{get;set;}
    public Assumption__c newAssumption  {get;set;}
    public Assumption__c newAssumptionnew  {get;set;}
    public List<Assumption__c> assume =new List<Assumption__c>();
    public List<Opportunity_Offering__c> oppOff = new List<Opportunity_Offering__c>(); 
    public List<Services__c> services {get;set;}
    public Integer sizeOfList{get;set;} 
    //End
    
    //Risk variables Start
     public Risk__c newRisk {get;set;}
     public List<Risk__c> risk =new List<Risk__c>();
     public List<Risk_Master__c> listRiskMaster = new List<Risk_Master__c>();
    //End 
    
    //Client Dependency variables Start 
     public Client_Dependency__c newClientDependency {get;set;}
     public List<Client_Dependency_Master__c> listClientDependencyMaster = new List<Client_Dependency_Master__c>();
     public List<Client_Dependency__c> clientDependency =new List<Client_Dependency__c>(); 
    //End  
    
    //Current Client Capability Assessment Start
    public String fileIdDelete ;
    public Document doc1{get;set;}
    public String cbName{get;set;}
    public String docid{get;set;}
    public List<DisplayFile> display1;
    public Current_Client_Capability_Assessment__c ccca{get;set;}
    public List<Current_Client_Capability_Assessment__c> listAssessmentDetailsActual{get;set;}
    public String comments{get;set;}
    public final Opportunity_Offering__c client;
    public Integer cnt{get;set;}
    public List<String> filenames{get;set;}
    public List<Opportunity_Offering__c> assesment{get;set;}
    public String fname{get;set;}
    public Boolean deleteButtonRender {get; set;}
    public Boolean readOnlyMode{get;set;}
    public String fileExten {get;set;}
    public Boolean refreshPage {get;set;}
    public Boolean btnOfferingTeam {get; set;}
    //Current Client Capability Assessment End
    
    /////////////////service component///////////////
    public SelectOption[] selectedDelLocation { get; set; }
    public SelectOption[] availableDelLocation {get; set; }
    public Service_Delivery_Location__c[]  listServiceDeliveryModel {get;set;}
    public List<Delievery_Location_Master__c> listDelieveryLocationMaster{get;set;}
    public string serviceName { get; set; }
    public string serviceId { get; set; }
    public List<Delivery_Location__c> savedDelLocationList{get;set;}
    public Services__c newOppOffer{get;set;}
    public Services__c[]  listProfileDetailsActual {get;set;}
    public String oppServices{get;set;}
    public String newid{get;set;}
    ////////service component end///////////////
    
    ///////////assumptionInline start //////////////
    public Boolean appFilter{get;set;}
    public  String categoryMasterFilter{get;set;}
    public Boolean apply{get;set;}
    public Boolean cancel{get;set;}
    //public Boolean readOnlyMode{get;set;}
    
    public Boolean canFilter{get;set;}
    public String valueFilter{get;set;}
    public List<WrapperAssumption> lstAssume{get;set;}
    public String opportunityName{get;set;}
    public String offeringName{get;set;}
    public String sortField{get;set;}
    public String soql {get;set;}
    public String ServiceFilter{get;set;}
    public String Option{get;set;}
    public String cat{get;set;}
    public Boolean edit{get;set;}
    public Boolean app{get;set;}
    public String serv{get;set;}
    public String oppOffId{get;set;}
    public Boolean showForm {get;set;}
    public Boolean showMainMsg {get;set;}
    public Boolean formMsg {get;set;}
    public List<Assumption__c > listAssumption  {get;set;}
    public List<Services__c> servicesAdd {get;set;}
    public String Service{get;set;}
    public String categoryMaster{get;set;}
    public List<Services__c> servicesSave {get;set;}
    public String oppTeamRec {get;set;}
    
    //////////////assumptionInline end //////////////
    
    /////////////////Non Standard Tab///////////
    public boolean detailSection{get;set;}
    public boolean editSection{get;set;}
    public Opportunity_Offering__c offRec{get;set;}
    
    ////////////Non Standard Tab///////////
    
    ///////////////client dependency////////////////////
    public List<Client_Dependency__c> listClientDependency {get;set;}
    public List<WrapperClientDependency> lstClientDependency{get;set;}
    ///////////client dependency end////////////////////
    
    
    
     /******************************
    Method Name: Solution_tabController
    Description: Default Constructor for Initializing ServicesComponent default constructor
    Paramenters: controller
    Return Value: NA
    *******************************/      
    public Solution_tabController()
    {
        selectedDelLocation = new List<SelectOption>();
        availableDelLocation = new List<SelectOption>();
        Set<SelectOption> availableDelLocationSet = new Set<SelectOption>();
        
        listServiceDeliveryModel = new List<Service_Delivery_Location__c>();
        listDelieveryLocationMaster = new List<Delievery_Location_Master__c>();
        serviceName = ApexPages.currentPage().getParameters().get(UTIL_Constants.SERVICE_NAME);
        serviceId = ApexPages.currentPage().getParameters().get(UTIL_Constants.SERVICE_ID);
        offId = ApexPages.currentPage().getParameters().get(UTIL_Constants.OFF_ID);
        
        listDelieveryLocationMaster = [select id,name from Delievery_Location_Master__c where Active__c=true order by name]; 
        savedDelLocationList = [select id,name,Delivery_Location_Master__c,Delivery_Location_Master__r.name,Service_Delivery_Location__c,Service_Delivery_Location__r.Name from Delivery_Location__c where Service_Delivery_Location__c =:serviceId];        
        
        for(Delivery_Location__c dl : savedDelLocationList)
        {
            for(Delievery_Location_Master__c dlm : listDelieveryLocationMaster)
            {   
                if(dlm.id != null && dl.Delivery_Location_Master__c != null)
                {
                    if(dlm.id != dl.Delivery_Location_Master__c)
                    {
                        availableDelLocationSet.add(new SelectOption(dlm.id, dlm.name));  
                    }else
                    {
                        selectedDelLocation.add(new SelectOption(dl.Delivery_Location_Master__c, dl.Delivery_Location_Master__r.name));
                    }   
                }                     
            }
        }
        if(!availableDelLocationSet.isEmpty() && !selectedDelLocation.isEmpty()){
            availableDelLocationSet.removeAll(selectedDelLocation);         
        }
        
        if(!availableDelLocation.isEmpty()){
            availableDelLocation.clear();
        }
        
        for(SelectOption sel : availableDelLocationSet){
            availableDelLocation.add(sel);
        }
        
        if(availableDelLocation.size() <=0 && savedDelLocationList.size() <= 0)
        {
            for(Delievery_Location_Master__c dlm : listDelieveryLocationMaster)
            {
                availableDelLocation.add(new SelectOption(dlm.id, dlm.name));
            }   
        }
    }
    
     public PageReference GoBackToHomeTab() {
         String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
         newid=ApexPages.CurrentPage().getParameters().get('id');
         Opportunity_Offering__c oppOffering = new Opportunity_Offering__c();
         oppOffering = [select Opportunity_TGP__c from Opportunity_Offering__c where Id =:newid];
         PageReference pg;
         if(oppOffering.Opportunity_TGP__c != null) {
             String pagereferenceLink = sfdcBaseURL  + '/apex/BPO_Opportunity_tab?id=' + String.valueOf(oppOffering.Opportunity_TGP__c);
             pg  = new PageReference(pagereferenceLink );
         }
         else {
             pg = new PageReference(sfdcBaseURL);
         }
         return pg;    
     }   
     
     
     /******************************
    Method Name: Solution_tabController
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/               
    public Solution_tabController(ApexPages.StandardController controller) {
        
         offId=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID); //Get current page id.
         oppOffering =(Opportunity_Offering__c )controller.getRecord();
         addButtonRender = true;
         btnOfferingTeam = true;
         
         Opportunity_Offering__c oppOffRec = [select Opportunity_TGP__r.Enterprise_Solution_Architect_New__r.name from Opportunity_Offering__c where id =: oppOffering.id limit 1];
        List<Opportunity_Role_master__c> oppRoleMasterList = [select Name,id from Opportunity_Role_master__c where name = 'Solution Architect - BPO'];
        
        List<Opportunity_Team__c> oppTeamRecList  = [select BPO_Opportunity__c,Roles__c,Roles__r.name,Offering__c,Opportunity_Team_Member__r.name,Opportunity_Team_Member__c from Opportunity_Team__c where BPO_Opportunity__c =: oppOffering.Opportunity_TGP__c and Offering__c =: oppOffering.Offering_Master__c];

        if(oppTeamRecList.size() > 0){
          
          for(Opportunity_Team__c oppTeam : oppTeamRecList){
            
            if(oppTeam.Roles__c == oppRoleMasterList[0].id){
          
              oppTeamRec = oppTeam.Opportunity_Team_Member__r.name;
            }
            
          }
          
        }
        if(oppTeamRec == null){
          
          
          oppTeamRec = oppOffRec.Opportunity_TGP__r.Enterprise_Solution_Architect_New__r.name;
        }
         
         
         if(oppOffering.Third_Party_Vendor__c==null){
            vendor = false;
         }else
            vendor = true;
            
         button0 = true;
         
         doc1 = new Document();
         doc1.IsPublic=true;    
         doc1.name ='file';
         
         this.client= oppOffering;
         fname='File';
         cnt=1;
         filenames=new List<String>();
         display1=new List<DisplayFile>();
               
         tabFocusTemp=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.TAB_FOCUS ); //Get current page id.
        
         if(tabFocusTemp==null)
         {
             tabFocus='tab01';
         }
         else
         {
             tabFocus=tabFocusTemp;
         }
         CountTemp=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.Count); //Get current page id.
         if(CountTemp==null)
         {
             Count=1;
         }
         else
         {
             Count=integer.ValueOf(CountTemp);
         }
         CountTempService =ApexPages.CurrentPage().getParameters().get(UTIL_Constants.COUNT_SERVICES); //Get current page id.
         if(CountTempService ==null)
         {
             CountService=1;
         }
         else
         {
             CountService=integer.ValueOf(CountTempService);
         }
         CountTempRisk=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.COUNT_RISK); //Get current page id.
         if(CountTempRisk==null)
         {
             CountRisk=1;
         }
         else
         {
             CountRisk=integer.ValueOf(CountTempRisk);
         }
         CountTempClient=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.COUNT_CLIENT); //Get current page id.
         if(CountTempClient==null)
         {
             CountClient=1;
         }
         else
         {
             CountClient=integer.ValueOf(CountTempClient);
         }
         isVisibleTemp=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.IS_VISIBLE);
         if(isVisibleTemp==null)
         {
             isVisible=false;
         }
         else
         {
             isVisible=Boolean.ValueOf(isVisibleTemp);
         }
         if(offId==null)
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Offering_Id_not_found));
             
         }
           /*String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;//Get users with Profile Name
            //Logic to not show add button for Sol Admin and Sol Leadership profile.
            List<Sol_UAM_Access_Setting__c> solUamAccess = new List<Sol_UAM_Access_Setting__c>();
            solUamAccess = Sol_UAM_Access_Setting__c.getall().values(); 
            for(Sol_UAM_Access_Setting__c solUam : solUamAccess){
                if(usrProfileName.equalsIgnoreCase(solUam.Profile_Name__c) && solUam.Read_Access__c == true && usrProfileName.equalsIgnoreCase(solUam.Role_Name__c) && usrProfileName.equalsIgnoreCase(solUam.Logic_Role_Name__c)){
                        addButtonRender = false ;
                }
            }*/
          //UAM Code--Mayank Tayal-Sol_148
          if(offId!=null)
          {
              /*  List<Opportunity_Offering__c> lstOffering = [select id, name, Opportunity_TGP__c from Opportunity_Offering__c where id = : offId];
                String strOppId = lstOffering.get(0).Opportunity_TGP__c;
                UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
                Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Opportunity_Offering__c');            
                addButtonRender = m.get('C');
                saveEditButtonRender = m.get('U');
                deleteButtonRender  = m.get('D'); */
                 addButtonRender =UAMSolMobUtility.addButtonRender_BPOOppTgp;
                 saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
                 deleteButtonRender = UAMSolMobUtility.deleteButtonRender_BPOOppTgp;
          }
            
          if(offId!=null)
          {
              assesment=[Select id, name from Opportunity_Offering__c where id=:offId];
              for(Opportunity_Offering__c cb:assesment)
              {
                  cbName=cb.name;                 
              }
              initializeDetailRecords();
          }
         /*if(pageid!=null)
            {
                List<Opportunity_Offering__c> lstOffering = [select id, name, Opportunity_TGP__c from Opportunity_Offering__c where id = : pageid];
                String strOppId = lstOffering.get(0).Opportunity_TGP__c;
                UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
                Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Offering_Scope_Image__c');            
                addButtonRender = m.get('C');
                saveEditButtonRender = m.get('U');
                deleteButtonRender  = m.get('D');
            }*/
            
            if(addButtonRender==false && saveEditButtonRender==false)
            {
                readOnlyMode=true;
                btnOfferingTeam = false;
            }
            
            
           flag= false;
           Assum = true;
           OfferingUser =true;
           OfferingUserEdit = false;
           AddSolCharUser =true;
           AddSolCharUserEdit = false;
           OfferingMsg = false;
           
           
           ////////////////////service component////////////////
           
           serviceComponentConstructor();
           
           ////////service component end////////////////////////
            
           /////////////////assumptionInline start /////////////
            
           assumptionInlineControllerConstructor();
              
           /////////////////assumptionInline end////////////////
              
           //////////////non standard tab//////////////////////
              
           nonStandardControllerConstructor();
              
           /////////////non standard tab///////////////////////
             
           //////client dependency////////////////////////////
             
           clientDependencyControllerConstructor();
             
           ///////client dependency end///////////////////////
    }
    
      public String sortDir {
        get  { if (sortDir == null) {  sortDir = UTIL_Constants.ASC_ORDER; } return sortDir;  }
        set;
      }
      public void toggleSort() {
        sortDir = sortDir.equals(UTIL_Constants.ASC_ORDER) ? UTIL_Constants.DESC_ORDER : UTIL_Constants.ASC_ORDER;
        runQuery();
      }
      public void toggleSortForClientDependency() {
        sortDir = sortDir.equals(UTIL_Constants.ASC_ORDER) ? UTIL_Constants.DESC_ORDER : UTIL_Constants.ASC_ORDER;
        runQueryForClientDependency();
      }
      
      public String debugSoql {
        get { return soql + UTIL_Constants.ORDER_BY + sortField + ' ' + sortDir; }
        set;
      
    }
    
    ////////////////service component method start///////////////
    
    public void serviceComponentConstructor(){
           
       newOppOffer = new Services__c ();
       addButtonRender = true;
            /*String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;//Get users with Profile Name
           //Logic to not show add button for Sol Admin and Sol Leadership profile.
                List<Sol_UAM_Access_Setting__c> solUamAccess = new List<Sol_UAM_Access_Setting__c>();
                solUamAccess = Sol_UAM_Access_Setting__c.getall().values(); 
                    for(Sol_UAM_Access_Setting__c solUam : solUamAccess){
                        if(usrProfileName.equalsIgnoreCase(solUam.Profile_Name__c) && solUam.Read_Access__c == true && usrProfileName.equalsIgnoreCase(solUam.Role_Name__c) && usrProfileName.equalsIgnoreCase(solUam.Logic_Role_Name__c)){
                            addButtonRender = false ;
              }
           }*/
         if(offId!=null && offId!=''){ 
                  
            initializeDetailRecordsForServiceComponent();
            newOppOffer.Status__c=UTIL_Constants.NONE;
         }
         else{
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Offering_Id_not_found));
         }
           refreshPage = false;
           //UAM Code--Mayank Tayal-Sol_148
         if(offId!=null)
         {
             /*   List<Opportunity_Offering__c> lstOffering = [select id, name, Opportunity_TGP__c from Opportunity_Offering__c where id = : offId];
                 String strOppId = lstOffering.get(0).Opportunity_TGP__c;
                UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
                Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Services__c');            
                addButtonRender = m.get('C');
                saveEditButtonRender = m.get('U');
                deleteButtonRender  = m.get('D'); */                                
                addButtonRender = UAMSolMobUtility.addButtonRender_BPOOppTgp;
                saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
                deleteButtonRender = UAMSolMobUtility.deleteButtonRender_BPOOppTgp;
                
         }
            /* List<userRole> role = [select name from userRole where id=:UserInfo.getUserRoleId()]; 
                List<Profile> profileList = [select name from profile where id = :userinfo.getProfileId()];
    
                if(profileList.size() > 0)
                {    
                    if( profileList[0].name.equalsIgnoreCase('Standard')) { 
                        addButtonRender = false;
                        saveEditButtonRender = false;
                        deleteButtonRender = false;
                    }
                    if((role.size() > 0 && role[0].name.equalsIgnoreCase('Resource Staffing')) || profileList[0].name.equalsIgnoreCase('Workbench Administrator')) {
                        addButtonRender = true; 
                        saveEditButtonRender = true; 
                        deleteButtonRender = true;
                    }
                }*/  
            List<Profile> profileList = [select name from profile where id = :userinfo.getProfileId()];

            if(profileList.size() > 0)
            {    
                if(profileList[0].name.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN) || profileList[0].name.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)) {
                    addButtonRender = true; 
                    saveEditButtonRender = true; 
                    deleteButtonRender = true;
                }
            }
                     
            if(addButtonRender==false && saveEditButtonRender==false)
            {
                readOnlyMode=true;
            }     
    }
    /******************************
    Method Name: initializeDetailRecordsForServiceComponent
    Description: To Initialize detail records.
    Paramenters: NA
    Return Value: void
    *******************************/  
    public void initializeDetailRecordsForServiceComponent() {       
    
        listProfileDetailsActual = new Services__c[]{};  
        for(Services__c profDet : [Select Name,Service_Master__c,Service_Component__c,Service_Text_Name__c,
                                    Status__c,Active__c,Service_Delivery_Location__c  from Services__c 
                                        where Service_Delivery_Location__r.Opportunity_Offering__c=:offId Order by CreatedDate DESC]) {
                listProfileDetailsActual.add(profDet);                
        } 
        
        listServiceDeliveryModel = new List<Service_Delivery_Location__c>();
        
        for(Service_Delivery_Location__c serviceDel : [Select Name,Opportunity_Offering__c,Service_Del_Location__c 
                                                        from Service_Delivery_Location__c where Opportunity_Offering__c=:offId 
                                                        Order by CreatedDate DESC]) {     //Opportunity_Offering__r.Name          
                listServiceDeliveryModel.add(serviceDel);                
        }
                   
    } 
    
    /******************************
    Method Name: addNewOppOfferForServiceComponent
    Description: To add Services
    Paramenters: NA
    Return Value: NA
    *******************************/  
    public PageReference addNewOppOfferForServiceComponent() 
    {
        try
        {
            if(oppServices==UTIL_Constants.NONE)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Please_select_the_valid_Service));
                return null;
            }
             String sm = oppServices;
             List<Services__c> service = [Select Name,id,Service_Delivery_Location__c,Service_Delivery_Location__r.Name 
                                            from Services__c where Service_Delivery_Location__r.Opportunity_Offering__c=:offId ];
             
             if(service != null){
                 for(Services__c ser : service){
                     if(oppServices.equals(ser.Name)){
                          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Record_Already_Exists_Please_check_the_data));
                          return null;
                     }
                 } 
             }
             Opportunity_Offering__c oppOffServices = [Select Id,Name,Offering_Text_Name__c,Offering_Master__r.name 
                                                        from Opportunity_Offering__c where Id=:offId];
                 
                //Iterate through Service Master.
                 system.debug('SM-->'+sm+' Master--->'+oppOffServices.Offering_Master__r.name);
            for(Service_Master__c smaster:  [Select id,Name from Service_Master__c where Name=: sm and Active__c = :true 
                                                and Offering__r.Name=:oppOffServices.Offering_Master__r.name])
            {
                //Insert service delivery location record            
            
                Service_Delivery_Location__c serviceDeliveryLocation;
                serviceDeliveryLocation = new Service_Delivery_Location__c();
                serviceDeliveryLocation.Opportunity_Offering__c = offId;
                serviceDeliveryLocation.Service_Master__c = smaster.id;
                serviceDeliveryLocation.Name = smaster.name; 
                
                insert serviceDeliveryLocation;
                
                list<Service_Delivery_Location__c> servDelLocationList = new list<Service_Delivery_Location__c>();
                servDelLocationList = [Select id,Name from Service_Delivery_Location__c where Opportunity_Offering__c =: offId 
                                        and Name =: smaster.name and Service_Master__c =: smaster.id];
                
                //To fetch list of Service Components. 
                List<Service_Component__c> serComp = [Select Name,id from Service_Component__c where Service_Master__c=: smaster.id and 
                                                        Active__c = :true and Offering_Master__r.Name=:oppOffServices.Offering_Master__r.name];
                if(serComp.Size()>0){
                      List<Services__c> newSerList=new List<Services__c>();  
                      for(Service_Component__c sComp:serComp ){
                       newOppOffer= new Services__c();
                       newOppOffer.Name = smaster.name;
                       newOppOffer.Service_Master__c=smaster.id;
                       newOppOffer.Status__c=UTIL_Constants.NONE;
                       newOppOffer.Service_Component__c=sComp.Name;
                       newOppOffer.Opportunity_Offering__c= offId;
                       newOppOffer.Service_Text_Name__c =oppServices;
                       newOppOffer.Service_Delivery_Location__c = servDelLocationList[0].id;
                       newSerList.add(newOppOffer);
                       //insert newOppOffer;
                       }
                      insert  newSerList;
                }
               else{
                       newOppOffer= new Services__c();
                       newOppOffer.Name = smaster.name;
                       newOppOffer.Service_Master__c=smaster.id;
                       newOppOffer.Status__c=UTIL_Constants.NONE;
                       newOppOffer.Service_Component__c=UTIL_Constants.NONE;
                       newOppOffer.Opportunity_Offering__c= offId;
                       newOppOffer.Service_Delivery_Location__c = servDelLocationList[0].id;
                       newOppOffer.Service_Text_Name__c =oppServices;
                       insert newOppOffer;  
               }
                   
                Opportunity_Offering__c oppOffUpdate =  new Opportunity_Offering__c();
                //Query to fetch Opportunity Offering
                oppOffUpdate = [Select Id,Name from Opportunity_Offering__c where Id=:offId limit 1];
                if(oppOffUpdate!=null ){
                oppOffUpdate.Service_Master__c = smaster.id;
                /*try{
                upsert oppOffUpdate;
                }
                catch(exception ex){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Failure in adding record'));
                    return null;
                }*/
                }                        
            }
              
         }
        catch(exception ex){
             //INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY
             if(ex.getMessage().contains(UTIL_Constants.INSUFFICIENT_ACCESS)){
                   
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.You_do_not_have_permission_to_perform_this_action));
                   //return null;
               }else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_Loading_page));
            }
            return null;
        }finally{
            newOppOffer= new Services__c();
        }
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Added_Successfully));
         initializeDetailRecordsForServiceComponent();
         refreshPage = true;
         return null;
    }
        
    /******************************
    Method Name: ServiceComponent
    Description: To get Services
    Paramenters: NA
    Return Value: NA
    *******************************/  
    public List<SelectOption> getServicesForServiceComponent()
    {
           List<SelectOption> services=new List<SelectOption>();
           Opportunity_Offering__c oppOffServices =  new Opportunity_Offering__c();
           
           //Query to fetch Opportunity Offering
            oppOffServices = [Select Id,Name,Offering_Text_Name__c,Offering_Master__r.name from Opportunity_Offering__c where Id=:offId];
           
           //Iterate through Service Master
           List<Service_Master__c> serviceMasterList = new List<Service_Master__c>();
           serviceMasterList= [select id,name,Offering__r.Name from Service_Master__c where Offering__r.Name=:oppOffServices.Offering_Master__r.name and Active__c=:true order by name];            
           
           if(serviceMasterList.size()>0)
           {
               for(Service_Master__c c:serviceMasterList)
               { 
                       services.add(new SelectOption(c.name, c.name));              
               }
           }
           else
           {
               services.add(new SelectOption(UTIL_Constants.NONE, UTIL_Constants.NONE_FOR_PICKLIST)); 
           }
            
           return services;
    } 
    
    /******************************
     Method Name: saveAccProfileDetailsForServiceComponent
     Description: To save Services
     Paramenters: NA
     Return Value: Null
     *******************************/  
     public PageReference saveAccProfileDetailsForServiceComponent(){
        
        Services__c[] profDetailsToUpsert = new Services__c []{};
        boolean flag = false;
        for(Services__c op :listProfileDetailsActual)
         {
            if(op.Status__c==null)
              {
                flag=true;
              }
         }
         if(flag)
           {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Status_cannot_be_none_Please_select_another_value));
              return null;
           }
        profDetailsToUpsert.addAll(listProfileDetailsActual);
          if(listProfileDetailsActual.Size()>0){         
            try {
            upsert profDetailsToUpsert;
              
            system.debug('------profDetailsToUpsert-------'+ profDetailsToUpsert);
            }
            catch(Exception ex) {
             //INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY
             if(ex.getMessage().contains(UTIL_Constants.INSUFFICIENT_ACCESS)){
                   
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.You_do_not_have_permission_to_perform_this_action));
                   //return null;
               }else {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Failure_in_saving_record));
            }
            return null;
           
        }
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Updated_Successfully));
        }
        else{
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, system.Label.There_is_no_record_to_save));
        }
         //getSelectedDelLocations();
         refreshPage = true;
         return null;
    }
             

    /******************************
     Method Name: cancelNow
     Description: To cancel reocrd.
     Paramenters: NA
     Return Value: NA
     *******************************/  
    public PageReference cancelNowForServiceComponent(){
          initializeDetailRecordsForServiceComponent();
          refreshPage = true;
          return null;
    }  
    /******************************
    Method Name: deleteFile
    Description: delete link
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference deleteFileForServiceComponent()
    {
        
        //Iterate through Offering Scope Image
        Map<id,id> mapServiceDel = new Map<id,id>();
        Map<id,id> mapOppOfferingId = new Map<id,id>();
        List<Services__c> servList = new  List<Services__c> ();
        
        if(fileIdDelete != null )
        {
            servList = [select id, name, Service_Delivery_Location__c from Services__c where id=:fileIdDelete];
        }        
        
        if(!servList.isEmpty() && servList.size() > 0)
        {
            for(Services__c serv : servList)
            {
                if(serv != null )
                {
                    //To override file from Offering Scope Image.
                    mapServiceDel = new Map<id,id>();
                    mapServiceDel.put(serv.Service_Delivery_Location__c,serv.Service_Delivery_Location__c);
                
                    delete serv; 
                }                         
            }
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_deleted_successfully));
        }
        //To delete Service delivery locations if all service components deleted
        if(!mapServiceDel.isEmpty() && mapServiceDel.size() > 0)
        {
            Set<Id> servId = mapServiceDel.keySet();
            
            list<Services__c> serviceLisAfterDelete = [select id, name, Service_Delivery_Location__c from Services__c where Service_Delivery_Location__c in : servId];
            
            if( serviceLisAfterDelete.size() == 0 )
            {
                for(Service_Delivery_Location__c servDelLocationToDelete : [select id, name, Opportunity_Offering__c from Service_Delivery_Location__c  where id in : servId])
                {
                    if(servDelLocationToDelete != null)
                    {
                        mapOppOfferingId = new Map<id,id>();
                        mapOppOfferingId.put(servDelLocationToDelete.Opportunity_Offering__c,servDelLocationToDelete.Opportunity_Offering__c);
                        
                        delete servDelLocationToDelete; 
                    }                              
                }
            }   
        }
        
        // To Update the Service Delivery Location field on Opportunity Offering - Start
        if(!mapOppOfferingId.isEmpty() && mapOppOfferingId.size() > 0)
        {
            Set<Id> oppOfferingId = mapOppOfferingId.keySet();            
            Opportunity_Offering__c OfferingObjToUpdateDelLocations = new Opportunity_Offering__c();
             
            list<Service_Delivery_Location__c> serviceDelLisAfterDelete = [select Id,Service_Del_Location__c,Opportunity_Offering__c from Service_Delivery_Location__c where Opportunity_Offering__c in : oppOfferingId ]; //Opportunity_Offering__r.Name
            String finalDelLocationForOfferingString = '';
            
            for (Id oppId :oppOfferingId){
                if(oppId != null)
                    OfferingObjToUpdateDelLocations.id = oppId;             
            }
            if( serviceDelLisAfterDelete != null && serviceDelLisAfterDelete.size() > 0 )
            {
                String strServiceDeliveryLoc = '';          
                set<String> finalDelLocationForOfferingSet = new set<String>();                
                
                for (Service_Delivery_Location__c servDelLoc : serviceDelLisAfterDelete) 
                {
                    strServiceDeliveryLoc  = servDelLoc.Service_Del_Location__c;

                    if(strServiceDeliveryLoc != null)
                    {
                        String[] arrayServDelLoc =  strServiceDeliveryLoc.split('; ');

                        for(String strDelLoc : arrayServDelLoc ) 
                        {
                            finalDelLocationForOfferingSet.add(strDelLoc);
                        }    
                    }
                }
                
                if(finalDelLocationForOfferingSet != null && !finalDelLocationForOfferingSet.isEmpty())
                {
                    for( String uniqueServiceDelLoc : finalDelLocationForOfferingSet)
                    {
                        finalDelLocationForOfferingString += uniqueServiceDelLoc + '; ';
                    }
                }               
            }
            
            integer lengthOfStr = finalDelLocationForOfferingString.length();
           
            if(lengthOfStr > 2)
            {
                finalDelLocationForOfferingString = finalDelLocationForOfferingString.substring(0,lengthOfStr-2);                
            }

            OfferingObjToUpdateDelLocations.Service_Delivery_Location_Unique__c = finalDelLocationForOfferingString; 
            
            update OfferingObjToUpdateDelLocations;
            
            Opportunity_Offering__c OpptoUpdate = [select Id, Opportunity_TGP__c from Opportunity_Offering__c where id = :OfferingObjToUpdateDelLocations.Id];    
            if(OpptoUpdate != null && OpptoUpdate.Opportunity_TGP__c != null) {
                utilityClass utilityClassInstance = new utilityClass();
                utilityClassInstance.updateDeliverylocationinOpportunity(OpptoUpdate.Opportunity_TGP__c);
            }        
        }   
        // To Update the Service Delivery Location field on Opportunity Offering - End
             
        initializeDetailRecordsForServiceComponent();        
        return null;
    }
    
    /******************************
    Method Name: saveDeliveryLocation
    Description: To save delivery locations at service level
    Paramenters: NA
    Return Value: NA
    *******************************/
    public PageReference saveDeliveryLocation() 
    {
        List<Delivery_Location__c> listDelLocationToUpsert = new List<Delivery_Location__c>();
        Opportunity_Offering__c OfferingToUpdateDelievryLocations = new Opportunity_Offering__c();
        Delivery_Location__c delLocation = new Delivery_Location__c();
        list<Delivery_Location__c > DeleteList = new list<Delivery_Location__c >();
        list<Service_Delivery_Location__c> serviceDelList = new list<Service_Delivery_Location__c>();
        
        DeleteList = [select Id,Service_Delivery_Location__r.Name,Service_Delivery_Location__c  from Delivery_Location__c where Service_Delivery_Location__c =: serviceId];
        serviceDelList = [select Id,Opportunity_Offering__c,Service_Del_Location__c from Service_Delivery_Location__c where Id =: serviceId]; //,Opportunity_Offering__r.Name
        
        if(DeleteList.size() > 0)
        {
            delete DeleteList;
        }
        
        String strServiceDelLocation = '';
        for( SelectOption so : selectedDelLocation) 
        { 
            if(selectedDelLocation.size() > 0)
            {
                delLocation = new Delivery_Location__c();
                delLocation.Service_Delivery_Location__c = serviceId;
                delLocation.Delivery_Location_Master__c = so.getValue(); 
                strServiceDelLocation +=  so.getLabel() +'; ';
                listDelLocationToUpsert.add(delLocation);
            }            
        }
        insert listDelLocationToUpsert;  
        
        if(strServiceDelLocation != null)
        {
            integer length = strServiceDelLocation.length();
            if(length > 2)
            {
                strServiceDelLocation = strServiceDelLocation.substring(0,length-2);                
            }
            for(Service_Delivery_Location__c serviceObj : serviceDelList)
            {
                serviceObj.Service_Del_Location__c = strServiceDelLocation;
            }
            strServiceDelLocation=''; 
        }
        update serviceDelList;            
        
        // For getting unique delivery location for all services in offerings
        list<Service_Delivery_Location__c> allServicesListForOffering = new list<Service_Delivery_Location__c>();
        
        if(serviceDelList  != null && serviceDelList.size() > 0) {
            OfferingToUpdateDelievryLocations.Id = serviceDelList[0].Opportunity_Offering__c; 
            allServicesListForOffering = [select Id,Service_Del_Location__c,Opportunity_Offering__c from Service_Delivery_Location__c where Opportunity_Offering__c =: serviceDelList[0].Opportunity_Offering__c ]; //Opportunity_Offering__r.Name,
        }

        String finalDeliveryLocationForOfferingString = '';

        if (allServicesListForOffering  != null && allServicesListForOffering.size() > 0 ) 
        {
            set<String>  finalDeliveryLocationForOffering= new set<String>();
            String strServiceDeliveryLocation = '';

            for (Service_Delivery_Location__c service : allServicesListForOffering) 
            {
                strServiceDeliveryLocation  = service.Service_Del_Location__c;

                if(strServiceDeliveryLocation != null)
                {
                    String[] arraySplited =  strServiceDeliveryLocation.split('; ');

                    for(String S :arraySplited ) 
                    {
                        finalDeliveryLocationForOffering.add(S);
                    }    
                }
            }

            if(finalDeliveryLocationForOffering != null && !finalDeliveryLocationForOffering.isEmpty())
            {
                for(String uniqueLocation :finalDeliveryLocationForOffering) 
                {
                    finalDeliveryLocationForOfferingString += uniqueLocation + '; ';
                }
            } 
        }
        
        integer lengthOfString = finalDeliveryLocationForOfferingString.length();
        if(lengthOfString > 2)
        {
            finalDeliveryLocationForOfferingString = finalDeliveryLocationForOfferingString.substring(0,lengthOfString-2);                
        }
        OfferingToUpdateDelievryLocations.Service_Delivery_Location_Unique__c = finalDeliveryLocationForOfferingString; 
        
        update OfferingToUpdateDelievryLocations;
        
        
        //Code to update Service Delivery Location Unique in BPO Opportunity .
        Opportunity_Offering__c oppOfferingToGetOpportunity  ;
        if(serviceDelList  != null && serviceDelList.size() > 0) {
            oppOfferingToGetOpportunity  = [select Id, Opportunity_TGP__c from Opportunity_Offering__c Where Id = :serviceDelList[0].Opportunity_Offering__c]; 
        }
        if(oppOfferingToGetOpportunity  != null) {
            Id OppIdTOUpdate = oppOfferingToGetOpportunity.Opportunity_TGP__c;
            //Calling utilityClass Method for updating the DeliveryLocation Unique field in BPO Opportunity
            utilityClass utilityClassInstance = new utilityClass();
            utilityClassInstance.updateDeliverylocationinOpportunity(OppIdTOUpdate);
        }
        return null;
    }
    
    ////////////////service component method end///////////////
    
    //////client dependency method start////////////////////
    
    public void clientDependencyControllerConstructor(){
             
        newClientDependency = new Client_Dependency__c();
           
        clientDependencyCall();
        newClientDependency = new Client_Dependency__c();
        listAllRecordsForClientDependency();
        if(oppOff.size()>0)
         {
              opportunityName=oppOff[0].Opportunity_TGP__r.name;
              offeringName=oppOff[0].Offering_Master__r.name;
         }
          //UAM Code--Mayank Tayal-Sol_148
            if(oppOffId!=null)
            {
                /*List<Opportunity_Offering__c> lstOffering = [select id, name, Opportunity_TGP__c from Opportunity_Offering__c where id = : offId];
                String strOppId = lstOffering.get(0).Opportunity_TGP__c;
                UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
                Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Client_Dependency__c');            
                addButtonRender = m.get('C');
                saveEditButtonRender = m.get('U');
                deleteButtonRender  = m.get('D');*/
                
                addButtonRender = UAMSolMobUtility.addButtonRender_BPOOppTgp;
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
              runQueryForClientDependency();
              }
    }
    /******************************
    Method Name: clientDependencyCall
    Description: To retrieve Client Dependency,Client Dependency Master and Service Master based on the offering.
    Paramenters: NA
    Return Value: NA
    *******************************/  
    public void clientDependencyCall(){
        
        categoryMasterFilter='All';
        ServiceFilter='All';
        edit=false;
        app=false;
        //oppOffId = ApexPages.CurrentPage().getParameters().get('id');
        if(offId != null && offId!=''){
        showForm =true;
        showMainMsg =false;
        formMsg=true;
        soql='Select Category__c,Category_Master__c,Category_Master__r.Name,Client_Dependency__c ,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Client_Dependency_Master__r.Client_Dependency__c ,Opportunity_Offering__r.Name from Client_Dependency__c where Opportunity_Offering__c = : offId';
        oppOff = new List<Opportunity_Offering__c>();   
        //Query to get Offerings related to current id.
        oppOff =[Select Id,Name,Opportunity_TGP__r.name,Offering_Text_Name__c,Offering_Master__r.Name,Active__c from Opportunity_Offering__c where Id=: offId];
        //Query to get list of Client Dependency
        listClientDependency = [Select Category__c,Category_Master__c ,Category_Master__r.name,Client_Dependency__c ,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,
                                 Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Client_Dependency_Master__r.Client_Dependency__c ,Opportunity_Offering__r.Name 
                                 from Client_Dependency__c where Opportunity_Offering__c = : offId ORDER BY CreatedDate DESC ];
        listClientDependencyMaster = new List<Client_Dependency_Master__c>();
        //Query to get list of Client Dependency Master
        listClientDependencyMaster = [Select Category__c,Services_per_Offering_form__c,Offering_Form__c,Category_Master__c ,Client_Dependency__c,id,Offering__r.name,Services_per_Offering__r.Name ,Name,Active_Inactive__c 
                                from Client_Dependency_Master__c where Active_Inactive__c= :true and (Offering__r.name =:oppOff[0].Offering_Text_Name__c 
                                OR Offering__r.name =:'')
                                ORDER BY CreatedDate DESC];
        lstClientDependency= new List<WrapperClientDependency>();
          
        if(listClientDependency!=null && listClientDependency.size()<=0)
        {
               for(Client_Dependency_Master__c newClientDep: listClientDependencyMaster)
               {
                    Client_Dependency__c newClientDepRecord= new Client_Dependency__c();
                    newClientDepRecord.Category_Master__c=newClientDep.Category_Master__c;
                    newClientDepRecord.Client_Dependency__c=newClientDep.Client_Dependency__c;
                    newClientDepRecord.Services_per_Offering__c=newClientDep.Services_per_Offering_form__c;
              
                    WrapperClientDependency wClientDependency = new WrapperClientDependency(newClientDepRecord);
                    //Null Check to render inlineEditing.
                    if(newClientDependency.Click_Here__c ==null || newClientDependency.Click_Here__c == ''){
                            wClientDependency.flagMaster=false;
                            wClientDependency.flagMaster1=false;
                            wClientDependency.flagMaster2=true;
                            wClientDependency.flagMaster3 =false; 
                    }
                    lstClientDependency.add(wClientDependency);   
               }              
         }
         else{
            
             lstClientDependency = new List<WrapperClientDependency>();
             for(Client_Dependency__c ClientDependency : listClientDependency ){
             WrapperClientDependency wClientDependency = new WrapperClientDependency(ClientDependency);
             //Null Check to render inlineEditing.
             if(ClientDependency.Click_Here__c ==null || ClientDependency.Click_Here__c == ''){
                 wClientDependency.flagMaster=false;
                 wClientDependency.flagMaster1 =false;
                 wClientDependency.flagMaster2 =true;
                 wClientDependency.flagMaster3 =false;
             }
             lstClientDependency.add(wClientDependency);
             }
         }
      }  
      else{
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Offering_Id_not_found));
         showForm =false;
         showMainMsg =true;
         formMsg=false;
       }
    
    }
    /******************************
    Method Name: runQueryForClientDependency
    Description: To run query of assumptions.
    Paramenters: NA
    Return Value: NA
    *******************************/  
      public void runQueryForClientDependency() {
 
            try {
                
                // listClientDependency =new List<Client_Dependency__c>(); 
                listClientDependency = Database.query(soql  + UTIL_Constants.ORDER_BY + sortField + ' ' + sortDir);
                lstClientDependency = new List<WrapperClientDependency>();
                //lstClientDependency =Database.query(soql);
            } catch (Exception e) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'+e));
            }
            
           
           if(listClientDependency.size()>0){
                 
                 for(Client_Dependency__c ClientDependency : listClientDependency ){
                 WrapperClientDependency wClientDependency = new WrapperClientDependency(ClientDependency);
                 //Null Check to render inlineEditing.
                 if(ClientDependency.Click_Here__c ==null || ClientDependency.Click_Here__c == ''){
                     wClientDependency.flagMaster=false;
                     wClientDependency.flagMaster1 =false;
                     wClientDependency.flagMaster2 =true;
                     wClientDependency.flagMaster3 =false;
                 }
                 
                lstClientDependency.add(wClientDependency);
               
                 }
          }
     
      }
    /******************************
    Class Name: WrapperClientDependency
    Description: Wrapper class for Client Dependency
    Paramenters: newClientDependency
    Return Value: NA
    *******************************/  
    //Start
     public class WrapperClientDependency {
     public Client_Dependency__c newClientDependency{get;set;}
     public boolean flagMaster{get;set;}
     public boolean flagMaster1{get;set;}
     public boolean flagMaster2{get;set;}
     public boolean flagMaster3{get;set;}
        /******************************
        Method Name: WrapperClientDependency
        Description: Constructor for Initializing
        Paramenters: newClientDependency
        Return Value: NA
        ******************************/
        public WrapperClientDependency (Client_Dependency__c newClientDependency){
            this.newClientDependency =newClientDependency;
            flagMaster=true;
            flagMaster1 =true;
            flagMaster2=false;
            flagMaster3 = true;
        }
         
    } 
    //End
    
    /******************************
     Method Name: listAllRecordsForClientDependency
     Description: Method to get list of all records.
     Paramenters: NA
     Return Value: NA
     *******************************/  
    public void listAllRecordsForClientDependency()
    {    
        Transient List<Client_Dependency__c > listProfileDetailsActual = new Client_Dependency__c[]{};
         //SOSL for Client Dependency
        for(Client_Dependency__c clientDep :[Select Category__c,Category_Master__c ,Client_Dependency__c,Client_Dependency_Master__r.Client_Dependency__c,Services_per_Offering__c,Click_Here__c ,Editable__c,Applicable__c from Client_Dependency__c ORDER BY CreatedDate DESC])
        listProfileDetailsActual.add(clientDep);
       
    }
    
    /******************************
     Method Name: addNewOppOfferForClientDependency
     Description: Method to add Client Dependency.
     Paramenters: NA
     Return Value: NA
     *******************************/  
     public PageReference addNewOppOfferForClientDependency() {
        //Null check for Category and Client Dependency.
        if(newClientDependency.Client_Dependency__c==null)
           {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Client_Dependency_cannot_be_left_blank));
              return null;
            }
              //Added to get assumptions from master related to Services also.
              //Start
              servicesAdd = new List<Services__c>();
              //servicesAdd =[Select id,name,Active__c,Opportunity_Offering__c,Service_Master__c,Service_Master__r.name from Services__c where Opportunity_Offering__c=:oppOffId];
              servicesAdd =[Select id,name,Active__c,Service_Delivery_Location__c,Service_Master__c,Service_Master__r.name from Services__c where Service_Delivery_Location__r.Opportunity_Offering__c=:oppOffId];
              //End 
                   Boolean AddService=false;
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
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Client_Dependency_can_be_added_for_the_service_in_scope));
                    return null;
                    }
         newClientDependency.Opportunity_Offering__c =    oppOffId;
         newClientDependency.Services_per_Offering__c =   Service ;
         newClientDependency.Category_Master__c=categoryMaster;
         
      try
        {
             insert newClientDependency;
             //saveAccProfileDetails(); 
             newClientDependency= new Client_Dependency__c();
             ClientDependencyCall();
        } 
         
      catch(Exception ex)
        {
             //INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY
             if(ex.getMessage().contains(UTIL_Constants.INSUFFICIENT_ACCESS)){
                   
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.You_do_not_have_permission_to_perform_this_action));
                   //return null;
               }else { 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Failure_in_saving_record));
            }
            return null;
        }
        finally
        {
            newClientDependency= new Client_Dependency__c();
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Added_Successfully));
        listAllRecordsForClientDependency();
        return null;
    }
    
    /******************************
     Method Name: saveAccProfileDetailsForClientDependency
     Description: Method to save Client Dependency.
     Paramenters: NA
     Return Value: NA
     *******************************/  
     public PageReference saveAccProfileDetailsForClientDependency()
     {
         List <Client_Dependency__c > uplist=new List <Client_Dependency__c  >();
         servicesSave = new List<Services__c>();
         servicesSave =[Select id,name,Active__c,Service_Delivery_Location__c,Service_Master__c,Service_Master__r.name from Services__c where Service_Delivery_Location__r.Opportunity_Offering__c=:oppOffId];
         for(WrapperClientDependency wrapClientDep: lstClientDependency){
         if(wrapClientDep.newClientDependency.Client_Dependency__c==null )
         {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Client_Dependency_cannot_be_left_blank));
              ClientDependencyCall();
              listAllRecordsForClientDependency();
              return null;
         }
         Boolean AddService=false;
         for(Services__c se : servicesSave )
         {
            
            if(se.Name==wrapClientDep.newClientDependency.Services_per_Offering__c)
            AddService=true;
            
         }
         if(wrapClientDep.newClientDependency.Services_per_Offering__c==UTIL_Constants.COMMON || wrapClientDep.newClientDependency.Services_per_Offering__c==Null)
         {
            AddService=true; 
         }
         if(AddService==False)
         {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Client_Dependency_can_be_added_for_the_service_in_scope));
            return null;
         }
            
         uplist.add(wrapClientDep.newClientDependency);
         }
         try{
          upsert uplist;
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Updated_Successfully));
         }
         catch(Exception ex) {
             //INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY
             if(ex.getMessage().contains(UTIL_Constants.INSUFFICIENT_ACCESS)){
                   
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.You_do_not_have_permission_to_perform_this_action));
                   //return null;
               }else { 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Failure_in_saving_record));
            }
            return null;
           }
           ClientDependencyCall();
           listAllRecordsForClientDependency();
           refreshPage = true;
           return null;
     }
     //End
     
     /******************************
    Class Name: ExportClientDependency
    Description: To get the records in Excel 
    Paramenters: NA
    Return Value: PageReference
    *******************************/
       public PageReference ExportClientDependency()
       {
           PageReference pg=new PageReference('/apex/ExportClientDependencyPage?id='+oppOffId);
           pg.setRedirect(true);
           return pg;
       }
       
        /**********************************************
    Method Name: doCancelForClientDependency
    Description: To cancel the modifications 
    Paramenters: NA
    Return Value: void
    ***********************************************/
    public void doCancelForClientDependency()
    {
        /*PageReference pg=new PageReference('clientDependencyInline?id='+oppOffId);
        pg.setRedirect(true);
        return pg;*/
        ClientDependencyCall();
        listAllRecordsForClientDependency();
    }
     // runs the search with parameters passed via Javascript
  public PageReference runSearchForClientDependency() {
     
      String emptyString='';

      soql='Select Category__c,Category_Master__r.Name,Category_Master__c,Client_Dependency__c ,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Client_Dependency_Master__r.Client_Dependency__c ,Opportunity_Offering__r.Name from Client_Dependency__c where Opportunity_Offering__c = : oppOffId ';
      if(cat!=null)
      {
          List<Category__c> tempCatMaster=[select name from Category__c where id=:cat ];
          if(tempCatMaster.Size()>0){
            soql += ' and Category_Master__r.name LIKE \''+String.escapeSingleQuotes(tempCatMaster[0].name)+'%\'';
          }
      }
      else if(categoryMasterFilter=='All')
       {
          soql='Select Category__c,Category_Master__c,Client_Dependency__c ,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Client_Dependency_Master__r.Client_Dependency__c ,Opportunity_Offering__r.Name from Client_Dependency__c where Opportunity_Offering__c = : oppOffId';
       }
       
      if(ServiceFilter!='All')
      {
      soql += ' and Services_per_Offering__c LIKE \''+String.escapeSingleQuotes(ServiceFilter)+'%\'';
      }
      else if(ServiceFilter=='Common')
      {
        soql += ' and (Services_per_Offering__c LIKE \''+String.escapeSingleQuotes(ServiceFilter)+ '\'OR Services_per_Offering__c=\'\')';
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
   
    runQueryForClientDependency();
 
    return null;
  }
  
  /**********************************************
    Method Name: clearFilter
    Description: To clear filters 
    Paramenters: NA
    Return Value: void
    ***********************************************/
    public void clearFilterForClientDependency()
    {
        appFilter=false;
        clientDependencyCall();
        valueFilter=UTIL_Constants.APPLY_FILTER;
        apply=true;
        cancel=false;
    }
     /******************************
    Method Name: deleteFile
    Description: delete link
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference deleteFileForClientDependency()
    {
        
        //Iterate through Offering Scope Image
        for(Client_Dependency__c cd : [select id, name from Client_Dependency__c where Opportunity_Offering__c=:oppOffId and id=:fileIdDelete])
        {
            //To override file from Offering Scope Image.
            delete cd ;           
        }    
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_deleted_successfully));
        ClientDependencyCall();        
        return null;
    }
    
     ///////client dependency end//////////////////////
     
     
     //////////////////////NON STANDARD TAB START////////////////
     
     public void nonStandardControllerConstructor(){
              
            detailSection = true;
            editSection = false;
    
             offId=ApexPages.CurrentPage().getParameters().get('id'); //Get current page id.
             offRec = [select id,Third_Party_scope__c ,Accenture_non_BPO_scope__c,Non_standard_BPO_scope__c,Opportunity_TGP__c from Opportunity_Offering__c where id = : oppOffering.id];
     }
     /******************************
    Method Name: saverecord
    Description: To save Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void saverecordForNonStandaredScopeTab(){
    
        try {
            upsert offRec;
            
            detailSection = true;
            editSection = false;
            
        }
        catch (Exception ex) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.You_cannot_update_offering_please_contact_workbench_administrator));
        }
            
    }
    
    /******************************
    Method Name: cancelrecord
    Description: To cancel records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void cancelrecordNonStandaredScopeTab(){
        
        editSection = false;
        detailSection = true;
        //oppRec = [select id,name,Non_standard_BPO_scope__c,Accenture_non_BPO_scope__c from Opportunity_TGP__c where id =: offRec.Opportunity_TGP__c];
        offRec = [select id,Third_Party_scope__c ,Accenture_non_BPO_scope__c,Non_standard_BPO_scope__c,Opportunity_TGP__c from Opportunity_Offering__c where id = : oppOffering.id];
    }
    
    //////////////////NON STANDARD TAB END////////////////
    
      ////////////////////////assumptionInline start/////////////////
      
      public void assumptionInlineControllerConstructor(){
            
          newAssumption = new Assumption__c();
          addButtonRender = true;
          appFilter=false;
          categoryMasterFilter='All';
          apply=true;
          valueFilter=UTIL_Constants.APPLY_FILTER;
          //Get users with Profile Name
          /*String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name; 
          //Logic to not show add button for Sol Admin and Sol Leadership profile.
          List<Sol_UAM_Access_Setting__c> solUamAccess = new List<Sol_UAM_Access_Setting__c>();
          solUamAccess = Sol_UAM_Access_Setting__c.getall().values(); 
           for(Sol_UAM_Access_Setting__c solUam : solUamAccess){
              if(usrProfileName.equalsIgnoreCase(solUam.Profile_Name__c) && solUam.Read_Access__c == true && usrProfileName.equalsIgnoreCase(solUam.Role_Name__c) && usrProfileName.equalsIgnoreCase(solUam.Logic_Role_Name__c)){
              addButtonRender = false ;
              }
           }*/
          assumptionCall();
          newAssumption = new Assumption__c();
          listAllRecords();
          List<Opportunity_Offering__c> oppOff = [Select Id,Name,Offering_Text_Name__c,Opportunity_TGP__r.name, Offering_Master__r.Name,Active__c from Opportunity_Offering__c where Id=: offId];
          if(oppOff.size()>0)
          {
              opportunityName=oppOff[0].Opportunity_TGP__r.name;
              offeringName=oppOff[0].Offering_Master__r.name;
          }
          //UAM Code--Mayank Tayal-Sol_148
            if(offId!=null)
            {
                       
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
      /******************************
    Method Name: assumptionCall
    Description: To retrieve Assumption,Assumption Master and Service Master based on the offering.
    Paramenters: NA
    Return Value: NA
    *******************************/  
     public void assumptionCall(){
        categoryMasterFilter='All';
        ServiceFilter='All';
        edit=false;
        app=false;
         //Get current page id.
     oppOffId = ApexPages.CurrentPage().getParameters().get('id'); 
     if(oppOffId != null && oppOffId!='')
     {
      showForm =true;
      showMainMsg =false;
      formMsg=true;
      
      soql ='Select Category__c,Category_Master__c,Category_Master__r.Name,Assumption__c,Classification__c ,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Assumption_Master__r.Assumption__c,Opportunity_Offering__r.Name from Assumption__c where Opportunity_Offering__c = : oppOffId ';
      //Query to get list of Assumptions
       listAssumption = [Select Category__c,Assumption__c,Category_Master__c,Category_Master__r.Name,Classification__c ,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,
                                            Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Assumption_Master__r.Assumption__c,
                                            Opportunity_Offering__r.Name from Assumption__c where Opportunity_Offering__c = : oppOffId 
                                            ORDER BY CreatedDate DESC ];
      
      oppOff = new List<Opportunity_Offering__c>();                                      
      //Query to get Offerings related to current id.
      oppOff = [Select Id,Name,Offering_Text_Name__c,Offering_Master__r.Name,Active__c from Opportunity_Offering__c where Id=: oppOffId];
      services = new List<Services__c>();
      services =[Select id,name,Active__c,Service_Delivery_Location__c,Service_Master__c,Service_Master__r.name from Services__c where Service_Delivery_Location__r.Opportunity_Offering__c=:oppOffId];
      //End
      Set<String> ServiceStr = new Set<String>();
          for(Services__c s : services)
          {
               ServiceStr.add(s.name);
               
          }
      listAssumptionMaster = new List<Assumption_Master__c>();
      //Query to get list of Assumption Master.
      listAssumptionMaster = [Select Category__c,Category_Master__c, Services_per_Offering_form__c,Offering_Form__c,Assumption__c,Classification__c ,id,Offering__r.Name,Services_per_Offering__r.Name ,Name,Active_Inactive__c 
                              from Assumption_Master__c where Active_Inactive__c= :true 
                              and (Offering__r.Name =:oppOff[0].Offering_Master__r.Name OR Offering__r.Name =:'') and (Services_per_Offering__r.Name in :ServiceStr OR Services_per_Offering__r.Name='') ORDER BY CreatedDate DESC];
      lstAssume = new List<WrapperAssumption>();     
        
       if(listAssumption!=null && listAssumption.size()<=0)
        {
            if(listAssumptionMaster!=null && listAssumptionMaster.size()>0)
            {
                for(Assumption_Master__c newAssum: listAssumptionMaster)
                {
                    Assumption__c newAssRec= new Assumption__c();
                    newAssRec.Category_Master__c=newAssum.Category_Master__c;
                    newAssRec.Assumption__c=newAssum.Assumption__c;
                    newAssRec.Services_per_Offering__c=newAssum.Services_per_Offering_form__c;
                    newAssRec.Classification__c=newAssum.Classification__c;                 
                    WrapperAssumption wAssumption=new WrapperAssumption(newAssRec);
                    
                    //Null Check to render inlineEditing.
                    if(newAssRec.Click_Here__c ==null || newAssRec.Click_Here__c =='')
                    {
                          wAssumption.flagMaster=false;
                          wAssumption.flagMaster1=false;
                          wAssumption.flagMaster2=true;
                          wAssumption.flagMaster3 =false;
                    }
                    lstAssume.add(wAssumption);
                }
            }
        }
        else
        {                 
             lstAssume = new List<WrapperAssumption>();
             //Itirate through list of Assumption
             for(Assumption__c assumption : listAssumption)
             {
                WrapperAssumption wAssumption=new WrapperAssumption (assumption);                
                 if(assumption.Click_Here__c ==null || assumption.Click_Here__c =='')
                 {
                
                     wAssumption.flagMaster=false;
                     wAssumption.flagMaster1 =false;
                     wAssumption.flagMaster2 =true;
                     wAssumption.flagMaster3 =false;
                     
                 }
                 lstAssume.add(wAssumption);
             }         
         }    
       }
       else
       {
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Offering Id not found'));
         showForm =false;
         showMainMsg =true;
         formMsg=false;
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
          listAssumption= Database.query(soql+ UTIL_Constants.ORDER_BY + sortField +' ' + sortDir);
          lstAssume = new List<WrapperAssumption>();
        } catch (Exception e) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'+e));
        }
           
           if(listAssumption.Size()>0)
           {
                 //Itirate through list of Assumption
                 for(Assumption__c assumption : listAssumption){
                
                 WrapperAssumption wAssumption=new WrapperAssumption (assumption );
                
                 if(assumption.Click_Here__c ==null || assumption.Click_Here__c ==''){
                
                     wAssumption.flagMaster=false;
                     wAssumption.flagMaster1 =false;
                     wAssumption.flagMaster2 =true;
                     wAssumption.flagMaster3 =false;
                     
                 }
                 lstAssume.add(wAssumption);
                 }
            }
      }
     
     /******************************
    Class Name: WrapperAssumption
    Description: Wrapper class for Assumption
    Paramenters: newAssumption
    Return Value: NA
    *******************************/ 
    //Start 
    public  class WrapperAssumption {
        public Assumption__c newAssumption{get;set;}
        public boolean flagMaster{get;set;}
        public boolean flagMaster1{get;set;}
        public boolean flagMaster2{get;set;}
        public boolean flagMaster3{get;set;}
        
    /******************************
    Method Name: WrapperAssumption
    Description: Constructor for Initializing
    Paramenters: newAssumption
    Return Value: NA
    *******************************/   
    public WrapperAssumption(Assumption__c newAssumption){
            this.newAssumption=newAssumption;
             flagMaster=true;
             flagMaster1 =true;
             flagMaster2=false;
             flagMaster3=true;
        }
         
    } 
    
    /******************************
    Method Name: getlstAssume1
    Description: for wrapper list assumption to show pre populate records from master.
    Paramenters: NA
    Return Value: NA
    *******************************/  
      public List<WrapperAssumption> getlstAssume1()
      {
          lstAssume = new List<WrapperAssumption>();
                if( listAssumption.size()<=0){
           //Itirate through List of Assumption Master.
          
          WrapperAssumption wAssumption=new WrapperAssumption(newAssumption);
                      //Null Check to render inlineEditing.
                      if(newAssumption.Click_Here__c ==null || newAssumption.Click_Here__c ==''){
                      wAssumption.flagMaster=false;
                      wAssumption.flagMaster1=false;
                      wAssumption.flagMaster2=true;
                      wAssumption.flagMaster3 =false;
                     }
                      lstAssume.add(wAssumption);
             
         }
         else{
                 
                 lstAssume = new List<WrapperAssumption>();
                 //Itirate through list of Assumption
                 for(Assumption__c assumption : listAssumption){
                
                 WrapperAssumption wAssumption=new WrapperAssumption (assumption );
                
                 if(assumption.Click_Here__c ==null || assumption.Click_Here__c ==''){
                
                     wAssumption.flagMaster=false;
                     wAssumption.flagMaster1 =false;
                     wAssumption.flagMaster2 =true;
                     wAssumption.flagMaster3 =false;
                     
                 }
                 lstAssume.add(wAssumption);
                 }
         
         } 
       
                 return lstAssume;
      }
      /******************************
    Method Name: getServicesdrop
    Description: Method to get Services.
    Paramenters: NA
    Return Value: NA
    *******************************/   
      public List<SelectOption> getServicesdrop() 
    {
        List<SelectOption> Servicesdrop=new List<SelectOption>();
        Servicesdrop.add(new SelectOption(UTIL_Constants.COMMON,UTIL_Constants.COMMON)); 
        
        List<Service_Master__c > serviceMaster = new List<Service_Master__c >();
        if(oppOff!=null){
        if(oppOff[0].id!=null )
        {
        serviceMaster = [select name,id,Offering__c from Service_Master__c where Offering__r.Name=:oppOff[0].Offering_Master__r.Name and Active__c = :true];
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
        ServicesFilter.add(new SelectOption(UTIL_Constants.COMMON,UTIL_Constants.COMMON));  
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
       List<Category__c> cat=[select id,name,Active__c from Category__c where Active__c=true order by name];
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
     Description: Method to add Assumption.
     Paramenters: NA
     Return Value: NA
     *******************************/  
     public PageReference addNewOppOffer() {
        //Null check for Assumption
        if(newAssumption.Assumption__c ==null)
           {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Assumption_cannot_be_left_blank));
              return null;
           }
        //Null check for Assumption
        if(newAssumption.Classification__c ==null)
           {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Classification_cannot_be_None_Please_select_another_value));
              return null;
           }
         //Added to get assumptions from master related to Services also.
              //Start
              
              servicesAdd = new List<Services__c>();
              //servicesAdd =[Select id,name,Active__c,Opportunity_Offering__c,Service_Master__c,Service_Master__r.name from Services__c where Opportunity_Offering__c=:oppOffId];
              servicesAdd =[Select id,name,Active__c,Service_Delivery_Location__c,Service_Master__c,Service_Master__r.name from Services__c where Service_Delivery_Location__r.Opportunity_Offering__c=:oppOffId];
              //End 
               Boolean AddService=false;
                   for(Services__c se : servicesAdd)
                   {
                        
                        if(se.Name==Service)
                        AddService=true;
                        
                   }
                    if(Service==UTIL_Constants.COMMON)
                    {
                      AddService=true; 
                    }
                    if(AddService==False)
                    {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Assumptions_can_be_added_for_the_service_in_scope));
                    return null;
                    }
          
             newAssumption.Opportunity_Offering__c =  oppOffId;
             newAssumption.Services_per_Offering__c = Service ;
             newAssumption.Category_Master__c=categoryMaster;
        
      try
        { 
                    insert newAssumption;
                    
            //saveAccProfileDetails(); 
            newAssumption= new Assumption__c();
            assumptionCall();
        }
        catch(Exception ex)
        {
             //INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY
             /*if(ex.getMessage().contains('INSUFFICIENT_ACCESS')){
                   
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access rights: Cannot be Added'));
                   //return null;
               }else {*/
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_in_Saving));
            //} 
            return null;
        }
         finally
        {
            newAssumption= new Assumption__c();
            
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Added_Successfully));
        listAllRecords();
        categoryMasterFilter='All';
        ServiceFilter='All';
        edit=false;
        app=false;
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
        Transient List<Assumption__c > listProfileDetailsActual = new Assumption__c[]{};
        //Iterate through Assumption
        for(Assumption__c assm :[Select Category__c,Category_Master__c,Assumption__c,Classification__c,Offering_text__c,Assumption_Master__r.Assumption__c,Services_per_Offering__c,Editable__c,Applicable__c from Assumption__c ORDER BY CreatedDate DESC])
        listProfileDetailsActual.add(assm);
       
    }
    /******************************
     Method Name: saveAccProfileDetails
     Description: Method to save Assumption.
     Paramenters: NA
     Return Value: NA
     *******************************/  
     public PageReference saveAccProfileDetails(){
         List <Assumption__c> uplist=new List <Assumption__c>();
         //Added to get assumptions from master related to Services also.
         //Start
         servicesSave = new List<Services__c>();
         servicesSave =[Select id,name,Active__c,Service_Delivery_Location__c,Service_Master__c,Service_Master__r.name from Services__c where Service_Delivery_Location__r.Opportunity_Offering__c=:oppOffId];
         //End 
         //Iterate through wrapper Assumption
         for(WrapperAssumption wAssume : lstAssume){
           //Null check for assumption
           if(wAssume.newAssumption.Assumption__c ==null)
           {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Assumption_cannot_be_left_blank));
               assumptionCall();
               listAllRecords();
              return null;
           }
           //Null check for classification
           if(wAssume.newAssumption.Classification__c==null)
           {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Classification_cannot_be_None_Please_select_another_value));
               
              return null;
           }
          
                   Boolean AddService=false;
                   for(Services__c se : servicesSave )
                   {
                        
                        if(se.Name==wAssume.newAssumption.Services_per_Offering__c)
                        AddService=true;
                        
                   }
                    if(wAssume.newAssumption.Services_per_Offering__c==UTIL_Constants.COMMON || wAssume.newAssumption.Services_per_Offering__c==Null)
                    {
                      AddService=true; 
                    }
                    if(AddService==False)
                    {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Assumptions_can_be_added_for_the_service_in_scope));
                    return null;
                    }
         uplist.add(wAssume.newAssumption);
         }
         
         try{
          
          upsert uplist;
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Saved_Successfully));
         }
         catch(Exception ex) {
          //INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY
             if(ex.getMessage().contains(UTIL_Constants.INSUFFICIENT_ACCESS)){
                   
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.You_do_not_have_permission_to_perform_this_action));
                   //return null;
               }else { 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_in_Saving));
            }
            
            return null;
             
         }
           assumptionCall();
           listAllRecords();
           getlstAssume1();
           refreshPage = true;
           return null;
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
       
    /**********************************************
    Method Name: doCancel
    Description: To cancel the modifications 
    Paramenters: NA
    Return Value: void
    ***********************************************/
    public void doCancel()
    {
        /*PageReference pg=new PageReference('assumptionInline?id='+oppOffId);
        pg.setRedirect(true);
        return pg;*/
        assumptionCall();
        listAllRecords();
    }
     /**********************************************
     Start for Filter Criteria
    ***********************************************/
    // runs the search with parameters passed via Javascript
  public PageReference runSearch() {
     
      String emptyString='';

      soql ='Select Category__c,Category_Master__r.Name,Category_Master__c,Assumption__c,Classification__c ,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Assumption_Master__r.Assumption__c,Opportunity_Offering__r.Name from Assumption__c where Opportunity_Offering__c = : oppOffId';
      if(cat!=null)
      {
          List<Category__c> tempCatMaster=[select name from Category__c where id=:cat ];
          if(tempCatMaster.Size()>0){
            soql += ' and Category_Master__r.name LIKE \''+String.escapeSingleQuotes(tempCatMaster[0].name)+'%\'';
          }
      }
      else if(categoryMasterFilter=='All')
       {
            soql ='Select Category__c,Category_Master__c,Assumption__c,Classification__c ,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Assumption_Master__r.Assumption__c,Opportunity_Offering__r.Name from Assumption__c where Opportunity_Offering__c = : oppOffId';
       }
      if(ServiceFilter!='All' && ServiceFilter!='Common')
      {
        
        //soql ='Select Category__c,Category_Master__c,Assumption__c,Classification__c ,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Assumption_Master__r.Assumption__c,Opportunity_Offering__r.Name from Assumption__c where Opportunity_Offering__c = : oppOffId';
        soql += ' and Services_per_Offering__c LIKE \''+String.escapeSingleQuotes(ServiceFilter)+'%\'';
      }
      else if(ServiceFilter==UTIL_Constants.COMMON)
      {
       
        soql += ' and (Services_per_Offering__c LIKE \''+String.escapeSingleQuotes(ServiceFilter)+ '\' OR Services_per_Offering__c=\'\')';
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
        
        
        app=true;
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
        ServiceFilter='All';
        assumptionCall();
        valueFilter=UTIL_Constants.APPLY_FILTER;
        apply=true;
        cancel=false;

        
        
    }
    /******************************
    Method Name: deleteFile
    Description: delete link
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference deleteFileForAssumptions()
    {
       //Iterate through Offering Scope Image
        for(Assumption__c asmp : [Select Category__c,Category_Master__c,Assumption__c,Classification__c ,Opportunity_Offering__r.Offering_Text_Name__c,
                                  Editable__c,Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Assumption_Master__r.Assumption__c,
                                  Opportunity_Offering__r.Name from Assumption__c where Opportunity_Offering__c=:oppOffId and id=:fileIdDelete])
        {
            //To override file from Offering Scope Image.
            delete asmp;           
        }    
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_deleted_successfully));
        assumptionCall();
        return null;
    }
     
     ///////////////////  assumptionInline end/////////////////
    /******************************
    Method Name: starting
    Description: Action function to load image
    Paramenters: Void
    Return Value: NA
    *******************************/ 
    public void starting(){
     flag = true;
    }
    /******************************
    Method Name: ending
    Description: Action function to stop image
    Paramenters: Void
    Return Value: NA
    *******************************/ 
    public void ending(){
    flag = false;
    }
    /******************************
    Method Name: getServiceDeliveryModel
    Description: Page reference refreshing for Assumptions, Risks, and Client Dependency
    Paramenters: NA
    Return Value: NA
    *******************************/  

    public PageReference getServiceDeliveryModel(){
      if(offId!=null)
      {
        PageReference pg=new PageReference('/apex/Solution_tab?id='+offId+'&CountService=2&tabFocus=tab0&isVisible=true');
        pg.SetRedirect(true);
        return pg;
      }
      return null;  
    }
     /******************************
    Method Name: getAssumption
    Description: Navigate to Page assumptionInline
    Paramenters: NA
    Return Value: NA
    *******************************/  

   public PageReference getAssumption(){
    
      if(offId!=null)
      {
      listAssumptionMaster = new List<Assumption_Master__c>();
      oppOff = [Select Id,Name,Offering_Text_Name__c,Offering_Master__r.Name,Active__c from Opportunity_Offering__c where Id=: offId];
      //Added to get assumptions from master related to Services also.
      //Start
      services = new List<Services__c>();
      //services =[Select id,name,Active__c,Opportunity_Offering__c,Service_Master__c,Service_Master__r.name from Services__c where Opportunity_Offering__c=:offId];
      services =[Select id,name,Active__c,Service_Delivery_Location__c,Service_Master__c,Service_Master__r.name,Service_Delivery_Location__r.name from Services__c where Service_Delivery_Location__r.Opportunity_Offering__c=:offId];
      //End
      Set<String> ServiceStr = new Set<String>();
      if(oppOff.Size()>0){
        List<Assumption__c > listAssumption = [Select Category__c,Assumption__c,Category_Master__c,Category_Master__r.Name,Classification__c ,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,
                                            Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Assumption_Master__r.Assumption__c,
                                            Opportunity_Offering__r.Name from Assumption__c where Opportunity_Offering__c = :OffId 
                                            ORDER BY CreatedDate DESC ];
        sizeOfList=listAssumption.size();
        Boolean FlagServices=false;
       /* for(Assumption__c assump : listAssumption )
        {
             if(assump.Services_per_Offering__c!=services.Name ) 
             FlagServices=true;
        }*/
        if(listAssumption.Size()==0)
           {
          //Query to get list of Assumption Master.
          listAssumptionMasternew= [Select Category__c,Services_per_Offering_form__c,Category_Master__c, Assumption__c,Classification__c ,id,Offering__r.Name,Services_per_Offering__r.Name ,Name,Active_Inactive__c 
                              from Assumption_Master__c where Active_Inactive__c= :true 
                              and (Offering__r.Name =:oppOff[0].Offering_Master__r.Name OR Offering__r.Name =:'' ) and Services_per_Offering__r.Name='' ORDER BY CreatedDate DESC];
          if(listAssumptionMasternew.Size()>0){
          
         //Itirate through List of Assumption Master.
              for(Assumption_Master__c temp : listAssumptionMasternew){
                      
                          newAssumption  = new Assumption__c();
                          newAssumption.Category_Master__c = temp.Category_Master__c;
                          newAssumption.Assumption__c=temp.Assumption__c;
                          newAssumption.Assumption_Master__c=temp.id;                    
                          newAssumption.Opportunity_Offering__c=offId;
                          newAssumption.Click_Here__c ='Click here';
                          newAssumption.Services_per_Offering__c = temp.Services_per_Offering_form__c;
                          newAssumption.Applicable__c= oppOff[0].Active__c ;
                          newAssumption.Classification__c=temp.Classification__c;
                          assume.add(newAssumption);
                      }
                      
                      if(assume.Size()>0 && sizeOfList==0){
                      upsert assume;
                      }
              }
         }
       
        if(services.size()>0)
        {
                for(Services__c s : services)
                {
                    Boolean isExist =false;
                    for(Assumption__c ass : listAssumption)
                    {
                        
                        if(ass.Services_per_Offering__c==s.name && ass.Click_Here__c!=null)
                        {
                            
                            isExist =true;
                        }
                    }
                    if(isExist==false)
                    {
                        ServiceStr.add(s.name);
                    }
                }
            //Query to get list of Assumption Master.
            listAssumptionMaster = [Select Category__c,Category_Master__c,Services_per_Offering_form__c, Assumption__c,Classification__c ,id,Offering__r.Name,Services_per_Offering__r.Name ,Name,Active_Inactive__c 
                                    from Assumption_Master__c where Active_Inactive__c= :true 
                                    and (Offering__r.Name =:oppOff[0].Offering_Master__r.Name  and Services_per_Offering__r.Name in :ServiceStr ) ORDER BY CreatedDate DESC];
          
        if(listAssumptionMaster.Size()>0){
          
         //Itirate through List of Assumption Master.
        for(Assumption_Master__c temp : listAssumptionMaster ){
                      
                          newAssumptionnew  = new Assumption__c();
                          newAssumptionnew.Category_Master__c = temp.Category_Master__c;
                          newAssumptionnew.Assumption__c=temp.Assumption__c;
                          newAssumptionnew.Assumption_Master__c=temp.id;                    
                          newAssumptionnew.Opportunity_Offering__c=offId;
                          newAssumptionnew.Click_Here__c ='Click here';
                          newAssumptionnew.Services_per_Offering__c = temp.Services_per_Offering_form__c;
                          newAssumptionnew.Applicable__c= oppOff[0].Active__c ;
                          newAssumptionnew.Classification__c=temp.Classification__c;
                          assume.add(newAssumptionnew  );
                      
                      }
                     // if(assume.Size()>0 && sizeOfList==0){
                      
                      upsert assume;
                     // }
          }
          }
          
                PageReference pg=new PageReference('/apex/Solution_tab?id='+offId+'&Count=2&tabFocus=tab2&isVisible=true');
                pg.SetRedirect(true);
                tabFocus= 'tab2';
                return pg;
         }   
        
      } 
                
      tabFocus= 'tab2';
      Count = 2;
      return null;  
    }
     /******************************
    Method Name: getRisk
    Description: Navigate to Page riskInline
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference getRisk(){
      if(offId!=null)
      {
            //Query to get Offerings related to current id.
              oppOff =[Select Id,Name,Offering_Text_Name__c,Offering_Master__r.Name,Active__c from Opportunity_Offering__c where Id=: offId];
              services = new List<Services__c>();
              services =[Select id,name,Active__c,Service_Delivery_Location__c,Service_Master__c,Service_Master__r.name from Services__c where Service_Delivery_Location__r.Opportunity_Offering__c=:offId]; 
              Set<String> ServiceStr = new Set<String>();   
               if(oppOff.Size()>0){
                    //Query to get list of Risk
                    List<Risk__c> listRisk = [Select Category__c,Risk__c,Classification__c,Potential_Impact__c,Mitigation__c,Risk_probability__c,Risk_Impact__c,Raised_by__c,Raised_On__c,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c,
                                             Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Risk_Master__r.Risks__c,Opportunity_Offering__r.Name, Category_Master__c 
                                             from Risk__c where Opportunity_Offering__c = : offId ORDER BY CreatedDate DESC];
                    sizeOfList=listRisk.size();
                    if(listRisk.size()==0)
                    {
                        //Query to get list of Risk Master.
                        listRiskMaster = [Select Category__c,Risks__c,id,Offering_Form__c,Services_per_Offering_form__c,Classification__c,Category_Master__c,Offering_Master__r.name,Service_Master__r.Name ,Name,Active_Inactive__c 
                                          from Risk_Master__c where Active_Inactive__c= :true and (Offering_Master__r.name =:oppOff[0].Offering_Master__r.Name OR Offering_Master__r.name =:'' )
                                          and Service_Master__r.Name = '' 
                                          ORDER BY CreatedDate DESC];
           
                        if(listRiskMaster.size()>0)
                        {
                              //Itirate through List of Risk Master
                              for(Risk_Master__c temp : listRiskMaster ){
                              newRisk = new Risk__c();
                              newRisk.Category_Master__c = temp.Category_Master__c ;
                              newRisk.Risk__c=temp.Risks__c;
                              newRisk.Risk_Master__c =temp.id;                    
                              newRisk.Opportunity_Offering__c=offId;
                              newRisk.Click_Here__c ='Click here';
                              newRisk.Services_per_Offering__c = temp.Services_per_Offering_form__c;
                              newRisk.Applicable__c= oppOff[0].Active__c ;
                              newRisk.Classification__c=temp.Classification__c;
                              risk.add(newRisk);
                              }
                                if(risk.Size()>0 && sizeOfList==0){
                                    upsert risk;
                                }
                        }
                    }
                    if(services.size()>0)
                    {
                    for(Services__c s : services)
                    {
                        Boolean isExist =false;
                        for(Risk__c rik : listRisk )
                        {
                            
                            if(rik.Services_per_Offering__c==s.name && rik.Click_Here__c!=null)
                            {
                                
                                isExist =true;
                            }
                        }
                        if(isExist==false)
                        {
                            ServiceStr.add(s.name);
                        }
                    }
                   //Query to get list of Risk Master.
                   listRiskMaster = [Select Category__c,Risks__c,id,Classification__c,Services_per_Offering_form__c,Offering_Form__c,Category_Master__c,Offering_Master__r.name,Service_Master__r.Name ,Name,Active_Inactive__c 
                                            from Risk_Master__c where Active_Inactive__c= :true and (Offering_Master__r.name =:oppOff[0].Offering_Master__r.Name 
                                            and Service_Master__r.Name in :ServiceStr )
                                            ORDER BY CreatedDate DESC];
           
                       if(listRiskMaster.size()>0){
                              //Itirate through List of Risk Master
                              for(Risk_Master__c temp : listRiskMaster ){
                                  newRisk = new Risk__c();
                                  newRisk.Category_Master__c = temp.Category_Master__c ;
                                  newRisk.Risk__c=temp.Risks__c;
                                  newRisk.Risk_Master__c =temp.id;                    
                                  newRisk.Opportunity_Offering__c=offId;
                                  newRisk.Click_Here__c ='Click here';
                                  newRisk.Services_per_Offering__c = temp.Services_per_Offering_form__c;
                                  newRisk.Applicable__c= oppOff[0].Active__c ;
                                  newRisk.Classification__c=temp.Classification__c;
                                  risk.add(newRisk);
                              }
                                 // if(risk.Size()>0 && sizeOfList==0){
                                          upsert risk;
                                 // }
                       }
                    }   
                    
                            PageReference pg=new PageReference('/apex/Solution_tab?id='+offId+'&CountRisk=2&tabFocus=tab3&isVisible=true');
                            pg.SetRedirect(true);
                            return pg;
      }
     }
      tabFocus= UTIL_Constants.TAB_THREE;
      Count = 2;
      return null;    
    }
     /******************************
    Method Name: getClientDependency
    Description: Navigate to Page clientDependencyInline
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference getClientDependency(){
      if(offId!=null){
            //Query to get Offerings related to current id.
            oppOff =[Select Id,Name,Offering_Text_Name__c,Offering_Master__r.Name,Active__c from Opportunity_Offering__c where Id=: offId];
              //Added to get assumptions from master related to Services also.
              //Start
              services = new List<Services__c>();
              //services =[Select id,name,Active__c,Opportunity_Offering__c,Service_Master__c,Service_Master__r.name from Services__c where Opportunity_Offering__c=:offId];
              services =[Select id,name,Active__c,Service_Delivery_Location__c,Service_Master__c,Service_Master__r.name from Services__c where Service_Delivery_Location__r.Opportunity_Offering__c=:offId];
              //End
            Set<String> ServiceStr = new Set<String>();
            if(oppOff.Size()>0){
                //Query to get list of Client Dependency
                List<Client_Dependency__c> listClientDependency = [Select Category__c,Client_Dependency__c ,Opportunity_Offering__r.Offering_Text_Name__c,Editable__c, Category_Master__c, 
                                                               Services_per_Offering__c,Click_Here__c,Applicable__c,id,name,Client_Dependency_Master__r.Client_Dependency__c ,Opportunity_Offering__r.Name 
                                                               from Client_Dependency__c where Opportunity_Offering__c = : offId ORDER BY CreatedDate DESC ];
                sizeOfList=listClientDependency.size();
                if(listClientDependency.size()==0)
                {
                        //Query to get list of Client Dependency Master
                        listClientDependencyMaster = [Select Category__c,Offering_Form__c,Services_per_Offering_form__c,Category_Master__c,Client_Dependency__c,id,Offering__r.name,Services_per_Offering__r.Name ,Name,Active_Inactive__c 
                                                      from Client_Dependency_Master__c where Active_Inactive__c= :true and (Offering__r.name =:oppOff[0].Offering_Master__r.Name OR Offering__r.Name =:'' )
                                                      and Services_per_Offering__r.Name = ''  ORDER BY CreatedDate DESC];
            
                        if( listClientDependencyMaster.size()>0)
                        {
                            //Iterate through List of Client Dependency Master
                            for(Client_Dependency_Master__c temp : listClientDependencyMaster )
                            {
                                      newClientDependency= new Client_Dependency__c();
                                      newClientDependency.Category_Master__c = temp.Category_Master__c ;
                                      newClientDependency.Client_Dependency__c=temp.Client_Dependency__c;
                                      newClientDependency.Client_Dependency_Master__c =temp.id;                    
                                      newClientDependency.Opportunity_Offering__c=offId;
                                      newClientDependency.Click_Here__c = UTIL_Constants.CLICK_HERE;
                                      newClientDependency.Services_per_Offering__c = temp.Services_per_Offering_form__c;
                                      newClientDependency.Applicable__c= oppOff[0].Active__c ;
                                      clientDependency.add(newClientDependency);
                            }
                                      if(clientDependency.Size()>0 && sizeOfList==0){
                                          upsert clientDependency;
                                      }
                        }
                }
                if(services.size()>0)
                {
                    for(Services__c s : services)
                    {
                        Boolean isExist =false;
                        for(Client_Dependency__c cd : listClientDependency )
                        {
                            
                            if(cd.Services_per_Offering__c==s.name && cd.Click_Here__c!=null)
                            {
                                
                                isExist =true;
                            }
                        }
                        if(isExist==false)
                        {
                            ServiceStr.add(s.name);
                        }
                    }
                        //Query to get list of Client Dependency Master
                        listClientDependencyMaster = [Select Category__c,Services_per_Offering_form__c,Offering_Form__c,Category_Master__c,Client_Dependency__c,id,Offering__r.name,Services_per_Offering__r.Name ,Name,Active_Inactive__c 
                                                      from Client_Dependency_Master__c where Active_Inactive__c= :true and (Offering__r.name =:oppOff[0].Offering_Master__r.Name 
                                                      and Services_per_Offering__r.Name in :ServiceStr ) ORDER BY CreatedDate DESC];
            
                        if( listClientDependencyMaster.size()>0)
                        {
                            //Iterate through List of Client Dependency Master
                            for(Client_Dependency_Master__c temp : listClientDependencyMaster )
                            {
                                      newClientDependency= new Client_Dependency__c();
                                      newClientDependency.Category_Master__c = temp.Category_Master__c ;
                                      newClientDependency.Client_Dependency__c=temp.Client_Dependency__c;
                                      newClientDependency.Client_Dependency_Master__c =temp.id;                    
                                      newClientDependency.Opportunity_Offering__c=offId;
                                      newClientDependency.Click_Here__c ='Click here';
                                      newClientDependency.Services_per_Offering__c = temp.Services_per_Offering_form__c;
                                      newClientDependency.Applicable__c= oppOff[0].Active__c ;
                                      clientDependency.add(newClientDependency);
                            }
                                          upsert clientDependency;
                        }
                }
                
                              PageReference pg=new PageReference('/apex/Solution_tab?id='+offId+'&CountClient=2&tabFocus=tab4&isVisible=true');
                              pg.SetRedirect(true);
                              return pg;
                         } 
                }
      tabFocus= 'tab4';
      Count = 2;
      return null;    
      
    }
    /******************************
    Method Name: Edit1
    Description: To Edit Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void edit1()
    {
        OfferingUser= false;
        OfferingUserEdit= true;
        button0 = true;
          
    }            
            
    /******************************
    Method Name: addSolCharEdit
    Description: To Edit Additioanl Solution Charact Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void addSolCharEdit()
    {
        
        ////////non standard scope tab//////////
        
        editSection = true;
        detailSection = false;
        
        ////////non standard scope tab end//////////
        AddSolCharUser = false;
        AddSolCharUserEdit = true;
        OfferingMsg = true;        
    }
    
     /******************************
    Method Name: saverecord
    Description: To save Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void saverecord(){
     if(offId!=null){
       try
            {
                  if(thirdPartyvendor!=null && thirdPartyvendor.Size()>0 ){
                   String vendorList='';
                   String vendorListNew;
                   for(String s:thirdPartyvendor){
                       vendorList=vendorList+s+';';
                       vendorListNew = vendorList;
                       }
                   oppOffering.X3rd_Party_VendorsList__c=vendorListNew ;
                  }
                    if(thirdPartyvendor.Size()>0){
                        for( String  t : thirdPartyvendor){
                           if(t=='Others'){
                           vendor = true;
                           }
                           else
                           vendor = false;
                           }
                           upsert oppOffering;
                     }
                    
                   if(thirdPartyvendor!=null && thirdPartyvendor.Size()>0){
                      oppOff =[Select Id,Name,Offering_Text_Name__c,X3rd_Party_VendorsList__c,Opportunity_TGP__c,Solution_Specialist_New__c,Functional_Architect_Mobilization_New__c,Offering_Master__r.Name,Active__c from Opportunity_Offering__c where Id=: offId];
                      opp = new List<Opportunity_TGP__c>();
                      opp = [Select X3rd_Party_Vendors_in_scope__c,id from Opportunity_TGP__c where id =:oppOff[0].Opportunity_TGP__c];
                      if(oppOff[0].X3rd_Party_VendorsList__c=='None;' )
                      {
                      opp[0].X3rd_Party_Vendors_in_scope__c = false;
                      }
                      else{
                      opp[0].X3rd_Party_Vendors_in_scope__c = true;
                      }
                      upsert opp[0];
                  } 
            }
            catch(Exception ex)
            {
               if(ex.getMessage().contains(UTIL_Constants.UPDATE_FAILED)){
                   
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.You_do_not_have_permission_to_perform_this_action));
                   return;
               }
            
            }  
            OfferingUser=true;
            OfferingUserEdit= false;
            AddSolCharUser=true;
            AddSolCharUserEdit= false;
            OfferingMsg = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Updated_Successfully));
     
      }
     }
    /******************************
    Method Name: saverecordOfferingUser
    Description: To save Offering Users records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void saverecordOfferingUser(){
     if(offId!=null){
       try
            {
               upsert oppOffering;  
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Updated_Successfully)); 
            }
            catch(Exception ex)
            {
               if(ex.getMessage().contains(UTIL_Constants.UPDATE_FAILED)){
                   
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.You_do_not_have_permission_to_perform_this_action));
                   return;
               }
            
            }  
            OfferingUser=true;
            OfferingUserEdit= false;
            OfferingMsg = true;
     
      }
     }
    /******************************
    Method Name: cancelRecord
    Description: To cancel RecordOpportunity records.
    Paramenters: Void
    Return Value: NA
    *******************************/ 
    public void cancelRecord()
    {
            
            OfferingUser=true;
            OfferingUserEdit= false;
            OfferingMsg = true;
         
    }
    /******************************
    Method Name: getThirdPartyVendorName
    Description: Add method to get Offerings only related to Offerings master
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public List<SelectOption> getThirdPartyVendorName(){
       List<SelectOption> thirdParty=new List<SelectOption>();
       List<Third_Party_Vendor_Master_Custom__c> thirdPartyVendorMaster=[select id,name,Third_Party_Vendor_Name__c from Third_Party_Vendor_Master_Custom__c  order by name];
       List<Opportunity_Offering__c> oppOfferings =  new List<Opportunity_Offering__c>();
       //Query to fetch Opportunity Offering
        oppOfferings = [Select Id,Name,Offering_Text_Name__c,Offering_Master__r.name from Opportunity_Offering__c where Id=:offId];
       if(oppOfferings.Size()>0){
       //Iterate through Service Master
       List<Third_Party_Vendor_Master_Custom__c> thirdPartyList= [select id,name,Offering_Master__r.Name,Third_Party_Vendor_Name__c  
                                                                    from Third_Party_Vendor_Master_Custom__c where Offering_Master__r.Name=:oppOfferings[0].Offering_Master__r.name OR Offering_Master__r.Name =:'' order by name];            
       if(thirdPartyList.size()>0)
       {
           for(Third_Party_Vendor_Master_Custom__c c :thirdPartyList)
           { 
                   thirdParty.add(new SelectOption(c.Third_Party_Vendor_Name__c, c.Third_Party_Vendor_Name__c));  
           }
           thirdParty.add(new SelectOption(UTIL_Constants.OTHERS,UTIL_Constants.OTHERS));
           thirdParty.add(new SelectOption(UTIL_Constants.NONE,UTIL_Constants.NONE));
       }
       else
       {
           thirdParty.add(new SelectOption(UTIL_Constants.NONE, '--None--'));
           thirdParty.add(new SelectOption(UTIL_Constants.OTHERS,UTIL_Constants.OTHERS)); 
       }
       }
       
       return thirdParty;
    }          
    //End
    /******************************
    Method Name: getthirdPartyvendor
    Description: Add method to get Offerings only related to Offerings master
    Paramenters: NA
    Return Value: void
    *******************************/
   public String[] getthirdPartyvendor() 
    {        
        return thirdPartyvendor;
        
    }
    public void setOtherComments(){
          if(thirdPartyvendor.Size()>0){
            for( String  t : thirdPartyvendor){
                if(t=='Others'){
                    vendor = true;
                }
                else
                    vendor = false;
           }
         }
       
    }
    /******************************
    Method Name: plus1
    Description: rendering another lookup user
    Paramenters: NA
    Return Value: void
    *******************************/
   public void plus1() 
    {
      plus1 = true;
      button0 = false;
      button1 =true;
      button2 =false;
      button3 =false;
      
       
    }
    /******************************
    Method Name: plus2
    Description: rendering another lookup user
    Paramenters: NA
    Return Value: void
    *******************************/
   public void  plus2() 
    {
      plus2 = true;
      button0 = false;
      button1 =false;
      button2 =true;
      button3 =false;
      
       
    }
    /******************************
    Method Name: plus3
    Description: rendering another lookup user
    Paramenters: NA
    Return Value: void
    *******************************/
   public void  plus3() 
    {
      plus3 = true;
      button0 = false;
      button1 =false;
      button2 =false;
      button3 =true;
      
        
    }
    /******************************
    Method Name: plus4
    Description: rendering another lookup user
    Paramenters: NA
    Return Value: void
    *******************************/
   public void  plus4() 
    {
      plus4 = true;
      button0 = false;
      button1 =false;
      button2 =false;
      button3 =false;
     
        
    }
    
    public String getFileIdDelete(){
        return fileIdDelete;
    }
    
    public void setFileIdDelete(String fileIdDelete){
        this.fileIdDelete = fileIdDelete;
    }
   
    public class DisplayFile{
        public String fileName{get; set;}
        public String fileID{get; set;}
        public String comments{get;set;}
        public displayFile(String fileName, String fileID, String comments){
            this.fileName=fileName;
            this.fileID=fileID;
            this.comments=comments;
        }
    }
    public List<DisplayFile> getDisplay1() {    
        return display1;
    }
    public String getComments() {    
        return comments;
    }
    
    /******************************
    Method Name: initializeDetailRecords
    Description: Added method to initialise all Records.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public void initializeDetailRecords() 
    {       
        listAssessmentDetailsActual = new List<Current_Client_Capability_Assessment__c>();
        //Search for Current Client Capability Assessment
        for(Current_Client_Capability_Assessment__c cAssess : [Select Name, File_ID__c, File_Name__c, Comments__c, Active__c 
                                                                from Current_Client_Capability_Assessment__c where Solution__c=:offId ORDER By CreatedDate DESC]) 
        {
               listAssessmentDetailsActual.add(cAssess);                
        }        
    }
    //End
    
    /******************************
    Method Name: saveNow
    Description: For saving records in Current Client Capability Assessment.
    Paramenters: NA
    Return Value: null
    *******************************/
    //Start
    public PageReference saveNow()
    {
        Current_Client_Capability_Assessment__c[] profDetailsToUpsert = new Current_Client_Capability_Assessment__c[]{};
        profDetailsToUpsert.addAll(listAssessmentDetailsActual); 
        boolean flag=false;
        for(Current_Client_Capability_Assessment__c r : profDetailsToUpsert)
          {
             if(r.File_Name__c!=null)
               {
                 flag=true;
               }
          }
        if(flag==false)
          {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.There_is_no_record_to_save));
            return null;
          } 
        try {
            upsert profDetailsToUpsert;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Updated_Successfully));
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Failure_in_saving_record));
            return null;
        }
        OfferingMsg = true; 
        initializeDetailRecords();
        return null;
    }
    //End

    /******************************
    Method Name: upload
    Description: For uploading of files.
    Paramenters: NA
    Return Value: null
    *******************************/
    //Start
    public PageReference upload() 
    {
        doc1.AuthorId = UserInfo.getUserId();
        doc1.FolderId = UserInfo.getUserId();
        if(doc1.body==null) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Choose_document_before_clicking_on_upload));
            return null;
        }
        try 
        {
            insert doc1;
            display1.add(new DisplayFile(doc1.name,doc1.id,client.Comments__c));
            //To fetch records from Document.
            List<Document> doc= [select id,name from Document where id=:doc1.id ORDER By CreatedDate DESC];// name=:document.name];
            ccca=new Current_Client_Capability_Assessment__c();
            if(offId!=null)
            { 
                ccca.Solution__c=assesment[0].id;
                ccca.File_ID__c=doc[0].id;
                ccca.File_Name__c=doc[0].name;
                ccca.Comments__c=client.Comments__c;
                insert ccca;                          
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Solution_Id_not_found));
            }    
        } 
        catch (DMLException e){
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Failure_in_uploading_file));
          return null;
        } 
        finally
        {
              doc1.body = null;
              doc1.name = fname;
              doc1 = new Document();
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.File_uploaded_successfully));       
        OfferingMsg = true; 
        initializeDetailRecords();
        client.Comments__c=null; 
        return null;
    }
    //End

    /******************************
    Method Name: cancelNow
    Description: Added method to cancel.
    Paramenters: NA
    Return Value: null
    *******************************/
    //Start
    public PageReference cancelNow()
    {
        initializeDetailRecords();
        return null; 
    }
    //End
    /******************************
    Method Name: deleteFile
    Description: delete link
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference deleteFile()
    {
        for(Document ddoc:[Select name, id from Document where id=:fileIdDelete])
        {            
            delete ddoc;              
        }
        for(Current_Client_Capability_Assessment__c cca: [select id, name,File_Name__c from Current_Client_Capability_Assessment__c where Solution__c=:offId and File_ID__c=:fileIdDelete])
        {
            delete cca;           
        }    
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_deleted_successfully));
        OfferingMsg = true; 
        initializeDetailRecords();   
        return null;
    } 
    
}