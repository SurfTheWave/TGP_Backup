/**
   @Author : Jyotsna Yadav
   @name   : CanvasClass
   @CreateDate : 09 June 2015 
   @Description : Send the parameters to BPOSE through canvas.
   @Version : 1.0 
   */
public with sharing class  CanvasClass {
    /**
   *  @name : getHostUrl
   *  @Description : getHostUrl
   *  @param : NA
   *  @return parameter - string
   *  @throws exception- NA
   */
    public String getHostUrl(){
        return System.URL.getSalesforceBaseURL().toExternalForm(); 
    }
    public  static string serviceGroupDelete;
    public  Costing_Request__c costingRequest{get;set;}
    private Opportunity opportunity;
    public String paramList{get;set;}
    private String emailId;
    public Boolean access{get;set;}
    public boolean ischeckout{set;get;}
    public Id costingId;
    public Id userid{set;get;}
    public boolean showeditblock{set;get;}
    public boolean hideeditblock{set;get;}
    public boolean ischeckin{set;get;}  
    public Boolean isSynced{get;set;}
    public Boolean hasUpdated{get;set;}
    public static String showUpdate{get;set;}
    public Boolean isError{get;set;}
    private User_Master__c userMaster;
    public boolean failureerror{Set;get;}
    public boolean checkEditAccess{get;set;}
    public boolean showresetblock{set;get;}
    public Boolean bpoRendered{get; set;}
    public Boolean ioRendered{get; set;}
    public String selectedRadio{get; set;}
    public String servGrpfromEdit {get; set;}
    public Profile p{get;set;}
   /**
   *  @name : getOptions
   *  @Description : getOptions
   *  @param : NA
   *  @return parameter - string
   *  @throws exception- NA
   */
    public List<selectOption> getOptions(){
        List<selectOption>  options = new List<SelectOption>();
        options.add(new SelectOption(UtilConstants.BPO, UtilConstants.BPO));
        options.add(new SelectOption(UtilConstants.IO, UtilConstants.IO));
        return options;
    }
    /*
    public Boolean bpoRendered {get; 
        set{
            bpoRendered  = false;
        }
    }
    public Boolean ioRendered{
        get;
        set{
            ioRendered = false;
        }
    }
    */
   // public Boolean isSync{get;set;}
    /*Outer class constructor*/
     public CanvasClass (ApexPages.StandardController stdController) {
         bpoRendered = false;
         ioRendered = false;
         costingId = stdController.getId();
         access = false;
         isSynced = false;
         hasUpdated = failureerror = false;
         showUpdate =SWBBPOSEIntegrationConstants.emptystring;
         checkServiceGroupOnEdit_CheckOut();
         checkCheckOut();
         
    }
   
   
   
   public void checkServiceGroupOnEdit_CheckOut(){
        
        String currPage = ApexPages.currentPage().getUrl();  
        System.debug('currPage -- '+ currPage);
        currPage = currPage.replaceFirst(SWBBPOSEIntegrationConstants.apex_url,SWBBPOSEIntegrationConstants.emptystring);
        System.debug('currPage>> '+ currPage);
        //System.debug('BooleanConatisns ' + currPage.containsIgnoreCase('EditCanvas'));
        if(currPage.containsIgnoreCase(SWBBPOSEIntegrationConstants.EditCanvas)){
            System.debug('inside Canvas');
            String srvGrp = ApexPages.currentPage().getParameters().get(SWBBPOSEIntegrationConstants.ServiceGroup);
            if(srvGrp != null){
                if(srvGrp.equalsIgnoreCase(UtilConstants.BPO)){
                    bpoRendered= true;
                    ioRendered = false;
                }
                else if(srvGrp.equalsIgnoreCase(UtilConstants.IO)){
                    bpoRendered=  false;
                    ioRendered = true;
                }
            }
            else{
                bpoRendered= true;
                ioRendered = false;
            }
        }
    }
   
   /**
   *  @name : renderBPOIO
   *  @Description : renderBPOIO : as part of release 3.5 BPO IO Sync
   *  @param : NA 
   *  @return parameter - string
   *  @throws exception- NA
   */
   public pageReference editCostingRequest(){
       String sg = SWBBPOSEIntegrationConstants.emptystring;
       if(bpoRendered){
           sg = SWBBPOSEIntegrationConstants.BPO;
        }
        else{
            sg= SWBBPOSEIntegrationConstants.IO;
        }
        System.debug(sg + '--->< SG');
       PageReference pr = new PageReference(SWBBPOSEIntegrationConstants.checkediturl+ costingRequest.id +SWBBPOSEIntegrationConstants.sg + sg +SWBBPOSEIntegrationConstants.sfdc_override);
       pr.setRedirect(true);
       return pr;
   }
   
   
   
     /**
   *  @name : renderBPOIO
   *  @Description : renderBPOIO : as part of release 3.5 BPO IO Sync
   *  @param : NA 
   *  @return parameter - string
   *  @throws exception- NA
   
    public void selectRenderBPOIO(){
           if(selectedRadio == UtilConstants.BPO){
                 bpoRendered = true;
                 ioRendered = false;
           }
           else if(selectedRadio == UtilConstants.IO){
               bpoRendered = false;
               ioRendered = true;
           }
    }
    */
    
    public void selectRenderBPOIOButton(){
        string srvgrp =SWBBPOSEIntegrationConstants.emptystring;
           if(!bpoRendered && ioRendered ){
                 bpoRendered = true;
                 ioRendered = false;
           }
           else{
               bpoRendered = false;
               ioRendered = true;
           }
           if(bpoRendered){
               srvgrp = SWBBPOSEIntegrationConstants.BPO; 
           }
           else{
               srvgrp = SWBBPOSEIntegrationConstants.IO;  
           }
           Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()  LIMIT 1];
            string accessLevel = ProfileMatrix.giveAccessLevel(p.name,srvgrp,costingRequest.opportunity__c,userid);
            system.debug('access level'+accessLevel);
            if(SWBBPOSEIntegrationConstants.editaccess.equalsignorecase(accessLevel)){
                checkEditAccess = false;
                
                if(costingRequest.Is_checked_out__c){
                    ischeckout = true;
                    access = false;
                }
                else{
                    ischeckout = false;
                    access = true;
                }
                if(costingRequest.Contract_End__c == null || costingRequest.Contract_Start__c == null || costingRequest.Client__c == null){
                    ischeckout = true;
                    access = false;
                }
            }
            else{
                boolean userHasAccess=UserRecordAccess.getHasEditAccess(userid,costingRequest.opportunity__c);
                if(userHasAccess){
                    checkEditAccess = false;
                    access = false;
                    ischeckout = false;  
                }
                 else{
                    access = false;
                    ischeckout = false;
                    checkEditAccess = true;
                }         
             
            }

    }
     /**
   *  @name : renderBPOIO
   *  @Description : renderBPOIO : as part of release 3.5 BPO IO Sync
   *  @param : NA 
   *  @return parameter - string
   *  @throws exception- NA
   */
    
    public void renderBPOIO(){
        //String profile = UserInfo.getProfileId();
        
        
        if(costingRequest.opportunity__r.Service_Grp__c == UtilConstants.IO){
            ioRendered = true;
            bpoRendered = false;
            system.debug('costingRequest.opportunity__r.Service_Grp__c'+costingRequest.opportunity__r.Service_Grp__c);
        }
        else if(costingRequest.opportunity__r.Service_Grp__c == UtilConstants.BPO){
            ioRendered = false;
            bpoRendered = true;
        }
        else if(costingRequest.opportunity__r.Service_Grp__c.equalsignorecase( SWBBPOSEIntegrationConstants.IOandIC)){
            ioRendered = true;
            bpoRendered = false;
        }
        else{
             profile p = [SELECT Id , Name FROM Profile WHERE Id = : UserInfo.getProfileId() LIMIT 1];
            System.debug('p.Name ' + p.Name);
            if(p.Name == SWBBPOSEIntegrationConstants.IOSolutionEditor || p.Name ==  SWBBPOSEIntegrationConstants.IOSolutionOperations || p.Name == SWBBPOSEIntegrationConstants.IOSolutionReadOnly || p.Name == SWBBPOSEIntegrationConstants.ISPMOOperations  ){
                ioRendered = true;
                bpoRendered = false;
            }
            
            else if(p.Name == SWBBPOSEIntegrationConstants.SolutionEditor || p.Name == SWBBPOSEIntegrationConstants.SolutionOperations || p.Name == SWBBPOSEIntegrationConstants.SolutionReadOnly || p.Name == SWBBPOSEIntegrationConstants.SolutionManager ){
                ioRendered = false;
                bpoRendered = true;
            }
            //else if(){
                
            //}
            /*
            else if(p.Name == 'System Administrator'){
                ioRendered = true;
                bpoRendered = true;
            }
            */
            else{
                ioRendered = false;
                bpoRendered = true;
            }
        }
        
        
    }
    
    /* Method to restrict two updates at the same time */
    public void checkCheckOut(){
        try{
            
        hasUpdated = false;
        isError = false;
         costingRequest = [Select In_Sync__c ,Sync_Initiated_Time__c,Sync_Initiated_Time_IO__c,client__c,Id,Checked_Out_By__c,LastModifiedById ,Sync_Failed_At__c,Data_Cleaning_dev__c,Is_BDL_Updated_Dev__c,SSM_Version__c,
                           Has_Updated__c ,calculation__c,Last_BDL_Generated_Scenario__c,BDL_Generated_UTC_Date__c,version__c,In_Progress__c,
                           Last_BDL_Generated_User__c,Last_BDL_Generated_Version__c,Is_checked_out__c,Last_Checked_Out_By_Dev__c,
                           name,opportunity__c,country__c,Contract_Start__c,Contract_End__c,Initial_Go_Live__c,Allow_Deal_Customization__c,
                           Synced_Scenario_Name__c,Last_Synced_Date__c,Last_Synced_Up_By__c,Cost_Summary_and_Metrics__c,MRDB_Last_Refresh_Date__c,
                           Synced_Scenario_Name_IO__c, Version_IO__c,Last_Synced_Date_IO__c,Last_Synced_Up_By_IO__c,Last_Synced_Up_By_IO__r.name,MRDB_Last_Refresh_Date_IO__c ,
                           MRDB_Version_IO__c,Last_IDL_Generated_Scenario__c,Last_IDL_Generated_Version__c,IDL_Generated_UTC_Date__c,Last_IDL_Generated_User__c,Checked_Out_By_IO__c,
                           opportunity__r.Service_Grp__c, In_Progress_IO__c,Calculation_IO__c ,Data_Cleaning_dev_IO__c ,Has_Updated_IO__c ,
                           MRDB_Version__c,In_Sync_IO__c,Sync_Failed_At_IO__c ,
                           CostSummaryandMetrics_IO__c,CDR_Scenario_Name__c,CDR_Sync_Date__c,Is_IDL_Updated_Dev__c,sap_om_id__c
                           from Costing_Request__c where ID =:costingId limit 1];
           // isSync = costingRequest.In_Sync__c;
         system.debug('*********'+costingRequest );
        // renderBPOIO();
         decimal d;
         if(costingRequest.Sync_Initiated_Time__c != null && costingRequest.opportunity__r.Service_Grp__c==SWBBPOSEIntegrationConstants.BPO){
            d = (system.now().gettime()/1000/60) - (costingRequest.Sync_Initiated_Time__c.gettime()/1000/60);
         }
         else if(costingRequest.Sync_Initiated_Time_IO__c != null && costingRequest.opportunity__r.Service_Grp__c==SWBBPOSEIntegrationConstants.IO){
             d = (system.now().gettime()/1000/60) - (costingRequest.Sync_Initiated_Time_IO__c.gettime()/1000/60);
         }
         system.debug('time gap --->'+d);
        if(d >10){
            showresetblock = true; 
         }
         else{
            showresetblock = false; 
         }
         opportunity = [Select Id,Is_Synced__c,Name,sap_om_id__c,Account.name,geo_region__r.name,Contract_Start_Date__c,Contract_End_Date__c,
                        Initial_Go_live_Date__c,OperatingGroup__r.name,Geo_Area__c,Fast_Track_Component__c,
                        ( Select Id,Name,Solution_Component__c, Service_Group__c, Offering_Master__r.name from Solution_Components__r 
                         where Offering_Master__r.name != :UtilConstants.All  LIMIT 200),( Select Id,Name,Opportunity_Team_Member__c from Opportunity_Team__r  LIMIT 200) 
                        from Opportunity where Id=:costingRequest.Opportunity__c limit 1];
          system.debug('*********'+opportunity.solution_components__r);
            userid =userinfo.getUserid();
            isSynced = opportunity.Is_Synced__c; 
          userMaster = [Select email__c,profile__c,id,name from User_Master__c where user__c=:userid limit 1];
          emailID = userMaster.email__c;
         p = [Select Name from Profile where Id =: userinfo.getProfileid()  LIMIT 1];
         
        //Code for IO BPO Sync  
        if(!ioRendered  && !bpoRendered )   
           {
               if(costingRequest.opportunity__r.Service_Grp__c == UtilConstants.IO){
                    ioRendered = true;
                    bpoRendered = false;
                }
                else if(costingRequest.opportunity__r.Service_Grp__c == UtilConstants.BPO){
                    ioRendered = false;
                    bpoRendered = true;
                }
                else if(costingRequest.opportunity__r.Service_Grp__c.equalsIgnoreCase(SWBBPOSEIntegrationConstants.IOandIC)){
                    ioRendered = true;
                    bpoRendered = false;
                }
                else{
                    //Profile p = [SELECT Id , Name FROM Profile WHERE Id = : UserInfo.getProfileId() LIMIT 1];
                    //System.debug('p.Name ' + p.Name);
                    if(p.Name == SWBBPOSEIntegrationConstants.IOSolutionEditor || p.Name == SWBBPOSEIntegrationConstants.IOSolutionOperations || p.Name == SWBBPOSEIntegrationConstants.IOSolutionReadOnly || p.Name == SWBBPOSEIntegrationConstants.ISPMOOperations){
                        ioRendered = true;
                        bpoRendered = false;
                    }
                    
                    else if(p.Name == SWBBPOSEIntegrationConstants.SolutionEditor || p.Name == SWBBPOSEIntegrationConstants.SolutionOperations || p.Name == SWBBPOSEIntegrationConstants.SolutionReadOnly || p.Name == SWBBPOSEIntegrationConstants.SolutionManager ){
                        ioRendered = false;
                        bpoRendered = true;
                    }
                    else{
                        ioRendered = false;
                        bpoRendered = true;
                    }
                }
        }
        String srvGrp_url = ApexPages.currentPage().getParameters().get(SWBBPOSEIntegrationConstants.ServiceGroup);
        if(srvGrp_url != null){
            if(srvGrp_url==SWBBPOSEIntegrationConstants.BPO){
                bpoRendered = true;
                iorendered = false;
            }
            else{
                bpoRendered = false;
                iorendered = true;
            }
        }
        //Code for IO BPO Sync 
         if(costingRequest.In_Progress__c==SWBBPOSEIntegrationConstants.failurestatus || costingRequest.in_progress_io__c==SWBBPOSEIntegrationConstants.failurestatus){
            failureerror = true;
         }
         {

         }
         
         
         if(costingRequest.Contract_End__c <> null && costingRequest.Contract_Start__c <> null && costingRequest.Client__c <> null){
             if((bpoRendered && costingRequest.Initial_Go_Live__c <> null) || ioRendered ){
              //   access = true;
                 string accessLevel = ProfileMatrix.giveAccessLevel(p.name,costingRequest.opportunity__r.Service_Grp__c,costingRequest.opportunity__c,userid);
                 system.debug('access level when dates are provided'+accessLevel);
                 if(SWBBPOSEIntegrationConstants.editaccess.equalsignorecase(accessLevel)){
                    access = true;
                    checkEditAccess = false;
                    if(costingRequest.Is_checked_out__c){
                        ischeckout = true;                            
                    }
                    else{
                        ischeckout = false;           
                    }
                 }
                 else{
                    boolean userHasAccess=UserRecordAccess.getHasEditAccess(userid,costingRequest.opportunity__c);
                    if(userHasAccess && p.name.containsignorecase(SWBBPOSEIntegrationConstants.SolutionEditor)){
                        checkEditAccess = false;
                        access = true;
                        ischeckout = true;   
                    }
                     else{
                        access = false;
                        ischeckout = true;
                        checkEditAccess = true;
                    }   
                 }
                  
             }
             else{
                 access = false;
                 checkEditAccess = true;
             }
         }
         else{
             access = false;
             string accessLevel = ProfileMatrix.giveAccessLevel(p.name,costingRequest.opportunity__r.Service_Grp__c,costingRequest.opportunity__c,userid);
                system.debug('access level when dates are null'+accessLevel);
            if(SWBBPOSEIntegrationConstants.editaccess.equalsignorecase(accessLevel)){
                    checkEditAccess = false;
                    if(costingRequest.Is_checked_out__c){
                        ischeckout = true;                            
                    }
                    else{
                        ischeckout = false;           
                    }
                 }
                 else{
                     boolean userHasAccess=UserRecordAccess.getHasEditAccess(userid,costingRequest.opportunity__c);
                     if(userHasAccess  && p.name.containsignorecase(SWBBPOSEIntegrationConstants.SolutionEditor)){
                         checkEditAccess = false;
                         access = false;
                         ischeckout = true;
                     }
                     else{
                         checkEditAccess = true;
                         access = true;
                         ischeckout = false;
                     }                    
                 }
         }          
                if(costingRequest.Is_checked_out__c && costingRequest.Last_Checked_Out_By_Dev__c == userid ){
                    showeditblock = false;
                    hideeditblock = true;
                    ischeckin = true;        
                } 
                 else{
                     showeditblock = true;
                    hideeditblock = false;
                     ischeckin = false;
                 }
        }catch(Exception E){
             System.debug('ERROR !! ' + e);
             ApexPages.addMessages(e);
             
        }
             
    }
   /* Method for check-in functionality */ 
     public pagereference checkin(){
    system.debug('=========='+costingRequest.Is_checked_out__c);
    costingRequest = [Select In_Sync__c ,Sync_Initiated_Time__c,client__c,Id,Checked_Out_By__c,LastModifiedById ,Sync_Failed_At__c,Data_Cleaning_dev__c,Is_BDL_Updated_Dev__c,SSM_Version__c,version__c,In_Progress__c,
                           Has_Updated__c ,calculation__c,Last_BDL_Generated_Scenario__c,BDL_Generated_UTC_Date__c,
                           Last_BDL_Generated_User__c,Last_BDL_Generated_Version__c,Is_checked_out__c,Last_Checked_Out_By_Dev__c,
                           name,opportunity__c,country__c,Contract_Start__c,Contract_End__c,Initial_Go_Live__c,Allow_Deal_Customization__c,
                           Synced_Scenario_Name__c,Last_Synced_Date__c,Last_Synced_Up_By__c,Cost_Summary_and_Metrics__c,MRDB_Last_Refresh_Date__c,
                           In_Progress_IO__c,Calculation_IO__c ,Data_Cleaning_dev_IO__c ,Has_Updated_IO__c,In_Sync_IO__c,Sync_Failed_At_IO__c ,
                           CostSummaryandMetrics_IO__c,CDR_Scenario_Name__c,CDR_Sync_Date__c, Is_IDL_Updated_Dev__c,
                           MRDB_Version__c,sap_om_id__c from Costing_Request__c where ID =:costingId limit 1];
            decimal d;
         if(costingRequest.Sync_Initiated_Time__c != null){
            d = (system.now().gettime()/1000/60) - (costingRequest.Sync_Initiated_Time__c.gettime()/1000/60);
         }
         system.debug('time gap --->'+d);
        if(d >10){
            showresetblock = true; 
         }
         else{
            showresetblock = false; 
         }
        if(costingRequest.Is_checked_out__c){
            costingRequest.Is_checked_out__c = false;
            costingRequest.Last_Checked_Out_By_Dev__c = UtilConstants.EMPTY_STRING;
            costingRequest.Checked_Out_By__c = null;
            try{
                update costingRequest;
             }catch(Exception E){
                 System.debug('ERROR !! ' + e);
                ApexPages.addMessages(e);
             }
             String srvGrp ;
             if(bpoRendered && !ioRendered){
                 srvGrp = UtilConstants.BPO;
             }
             else if(ioRendered){
                 srvGrp = UtilConstants.IO;
             }
             else{
         
             }
             Pagereference pr = page.CostingRequestDetail_Page;
             pr.getParameters().put(UtilConstants.id_par,costingRequest.id);
             pr.getParameters().put(SWBBPOSEIntegrationConstants.ServiceGroup,srvGrp);
             pr.setRedirect(true);
             checkCheckOut();    
             return pr;
        }
         else{
             if(costingRequest.LastModifiedById == userid){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,SWBBPOSEIntegrationConstants.AlreadyCheckedIn));
             }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,SWBBPOSEIntegrationConstants.ForceCheckedIn)); 
             }
             
             return null;
         }
         
      
     return null;
    }
    
    /* method for check-out functionlaity */
      public pagereference CheckOut(){
    costingRequest = [Select In_Sync__c ,Sync_Initiated_Time__c,client__c,Id,Checked_Out_By__c,LastModifiedById ,Sync_Failed_At__c,Data_Cleaning_dev__c,Is_BDL_Updated_Dev__c,SSM_Version__c,version__c,In_Progress__c,
                           Has_Updated__c ,calculation__c,Last_BDL_Generated_Scenario__c,BDL_Generated_UTC_Date__c,
                           Last_BDL_Generated_User__c,Last_BDL_Generated_Version__c,Is_checked_out__c,Last_Checked_Out_By_Dev__c,
                           name,opportunity__c,country__c,Contract_Start__c,Contract_End__c,Initial_Go_Live__c,Allow_Deal_Customization__c,
                           Synced_Scenario_Name__c,Last_Synced_Date__c,Last_Synced_Up_By__c,Cost_Summary_and_Metrics__c,MRDB_Last_Refresh_Date__c,
                           In_Progress_IO__c, Calculation_IO__c,Data_Cleaning_dev_IO__c ,Has_Updated_IO__c,In_Sync_IO__c,Sync_Failed_At_IO__c,
                           CostSummaryandMetrics_IO__c,CDR_Scenario_Name__c,CDR_Sync_Date__c,
                           MRDB_Version__c,Is_IDL_Updated_Dev__c,sap_om_id__c from Costing_Request__c where ID =:costingId limit 1];
     decimal d;
         if(costingRequest.Sync_Initiated_Time__c != null){
            d = (system.now().gettime()/1000/60) - (costingRequest.Sync_Initiated_Time__c.gettime()/1000/60);
         }
         system.debug('time gap --->'+d);
        if(d >10){
            showresetblock = true; 
         }
         else{
            showresetblock = false; 
         }                     
     costingRequest.Is_checked_out__c = true;
     costingRequest.Last_Checked_Out_By_Dev__c =userid  ;
     costingRequest.Checked_Out_By__c = userMaster.Id;
     costingRequest.has_updated__c=false;
     if(costingRequest.in_progress__c !=SWBBPOSEIntegrationConstants.inprogressstatus){
         costingRequest.calculation__c = false;
         costingRequest.In_sync__c = false;
     }
     //costingRequest.In_Progress__c = '7';
     //costingRequest.IsCheckedOutPage__c = true;
     try{
        update costingRequest;
        system.debug('after update is called value is==='+costingRequest.Is_checked_out__c);
     }catch(Exception E){
         System.debug('ERROR !! '  +e);
        ApexPages.addMessages(e);
     }
         String srvGrp ;
         if(bpoRendered && !ioRendered){
             srvGrp = UtilConstants.BPO;
         }
         else if(ioRendered){
             srvGrp = UtilConstants.IO;
         }
         else{
         
         }
      Pagereference pr = page.EditCanvas;
      pr.getParameters().put(UtilConstants.id_par,costingRequest.id);
      pr.getParameters().put(SWBBPOSEIntegrationConstants.ServiceGroup,srvGrp);
       pr.setRedirect(true); 
        checkCheckOut();   
     return pr;
    }
    
    /*Inner class to set the parameters. */        
    public without sharing class WrapperLabelClass{
        private string pagename; 
        private string enterpriseid;
        private string opportunityid;
        private Boolean IsDealEditableForUser;
        private Boolean IsDealCustomizable,IsOpportunityCheckedOut;
        private Boolean whatif;
        private Integer IsSyncInProgress;
        private integer  IsSyncInProgressForIO;
        // differnet for io and BPO
        private long SAPOMID;
        private string OpportunityName;
        private string clientname;
        private Date contractstartdate;
        private Date contractenddate;
        private Date golivedate;
        private string OG;
        private string Salesgeography;
        private List<String> Offerings;
        private List<String> CountriesInScope;
        private String AuthToken;
        private String InstanceURL;
        private String ServiceGroup;
        /* Constructor of inner class */
        public  WrapperLabelClass(opportunity opportunity,String emailID,Boolean access,Costing_Request__c costingRequest, Boolean bpoScen, Boolean ioScen){
            //InstanceURL = ApexPages.currentPage().getHeaders().get('Host');  
            
            if(bpoScen && !ioScen){
                pageName = UtilConstants.DEAL;
                ServiceGroup= UtilConstants.BPO;
                //serviceGroupDelete=UtilConstants.BPO;
                isDealCustomizable = costingRequest.Allow_Deal_Customization__c;
                IsSyncInProgress = Integer.valueof(costingRequest.In_Progress__c);
                IsSyncInProgressForIO = Integer.valueof(costingRequest.In_Progress_IO__c);
            }
            else if(ioScen){
                pageName= SWBBPOSEIntegrationConstants.IODeal;
                ServiceGroup= UtilConstants.IO;
                //serviceGroupDelete=UtilConstants.IO;
                isDealCustomizable = false;
                IsSyncInProgress = Integer.valueof(costingRequest.In_Progress__c);
                IsSyncInProgressForIO = Integer.valueof(costingRequest.In_Progress_IO__c);
            }
            else{
            }
            enterpriseId = emailId.split(UtilConstants.AT_THE_RATE_OF)[0];
            if(enterpriseId.contains(SWBBPOSEIntegrationConstants.equals)){
                enterpriseId = enterpriseid.split('=')[0];
            }
            
            opportunityId = opportunity.Id;
            isDealEditableForUser = access;
            
            // io false, oif bpo, pick 
            whatIf = false;
            if(costingRequest.sap_om_id__c!=null){
              SAPOMID = long.valueof(costingRequest.sap_om_id__c);
            }else{
                SAPOMID = 0;
            }
            
            opportunityName = opportunity.name;
            if(opportunityName.contains( SWBBPOSEIntegrationConstants.DBL_CD )){
                opportunityName = opportunityName.replace(SWBBPOSEIntegrationConstants.DBL_CD,SWBBPOSEIntegrationConstants.QT);
            }
            system.debug('final opportunity name '+opportunityName);
            clientName = opportunity.Account.name;
            if(clientName!= null && clientName.contains(SWBBPOSEIntegrationConstants.DBL_CD)){
                clientName = clientName.replace(SWBBPOSEIntegrationConstants.DBL_CD,SWBBPOSEIntegrationConstants.QT);
            }
            contractStartDate = costingRequest.Contract_Start__c;
            contractEndDate = costingRequest.Contract_End__c;
            goLiveDate = costingRequest.Initial_Go_Live__c;
            OG = opportunity.OperatingGroup__r.name;
            //SalesGeography = opportunity.Geo_Area__c;
            SalesGeography = opportunity.Geo_Region__r.name;
            countriesInScope = new List<String>{costingRequest.Country__c.replace(UtilConstants.SEMICOLON_STRING,UtilConstants.COMMA_STRING)};
            Offerings = new List<String>{UtilConstants.BSS,UtilConstants.CROSS,UtilConstants.PMO,UtilConstants.TECHNOLOGY};
            Set<String> offeringSet = new Set<String>();
            for( Solution_Scope__c sc : opportunity.Solution_Components__r ){
                
                if(sc.Service_Group__c.equalsIgnoreCase(serviceGroup)){
                    offeringSet.add( sc.Offering_Master__r.name);
                }
               /* if(sc.Solution_Component__c.equalsIgnoreCase(UtilConstants.APPLICATION_MWB)){
                offeringSet.add( sc.Solution_Component__c);
                }else{
                   offeringSet.add(UtilConstants.CROSS); 
                }*/
            }
            offerings.addAll( offeringSet );
            if(costingRequest.Last_Checked_Out_By_Dev__c != null && costingRequest.Last_Checked_Out_By_Dev__c.EqualsIgnoreCase(userInfo.getUserId()) && costingRequest.Is_Checked_Out__c){
                                IsOpportunityCheckedOut =true;
                               // system.debug('if****************************************'+userList.id);
                       }
                      else if(costingRequest.Last_Checked_Out_By_Dev__c != null && costingRequest.Last_Checked_Out_By_Dev__c!=userInfo.getUserId() && costingRequest.Is_Checked_Out__c){
                        //system.debug('else if****************************************'+userList.id);
                                IsOpportunityCheckedOut =false;
                       }
                      else{
                      //  system.debug('else****************************************'+userList.id);
                           IsOpportunityCheckedOut =false;
                       }
            //IsOpportunityCheckedOut = costingRequest.Is_Checked_Out__c;
            AuthToken = userinfo.getSessionID();
            Rest_URL__c rs = Rest_URL__c.getOrgDefaults();
            InstanceURL = rs.Base_URL__c; 
            system.debug('instance URL----------> '+InstanceURL );
            System.debug('offerings -> '+ offerings);
        }
     }
     /* Inner class to serialize the parameters */
    without sharing  Class Canvas_Container{  
        WrapperLabelClass Canvas_request;
        /* Constructor for inner wrapper class */
        public Canvas_Container(opportunity opportunity,String emailID,Boolean access,Costing_Request__c costingRequest, Boolean bpoScen, Boolean ioScen){
            System.debug('Opportunity--> '+ opportunity);
           System.debug('emailId-->' + emailId);
           System.debug('access-->'  + access);
           System.debug('costingRequest  '+ costingRequest);
           System.debug('bpoRendered '+ bpoScen);
           System.debug('ioRendered' + ioScen);
            Canvas_request = new WrapperLabelClass(opportunity,emailId,access,costingRequest, bpoScen, ioScen);
            serviceGroupDelete =Canvas_request.ServiceGroup;
        } 
     }
     /* Method to generate the JSON that needs to be sent to BPOSE */
     public String getgenerateJSONContent() {
       try{ 
           System.debug('Opportunity '+ opportunity);
           System.debug('emailId ' + emailId);
           System.debug('access '  + access);
           System.debug('costingRequest  '+ costingRequest);
           System.debug('bpoRendered '+ bpoRendered);
           System.debug('ioRendered' + ioRendered);
           Canvas_Container cc = new Canvas_Container(opportunity,emailId,access,costingRequest, bpoRendered, ioRendered);   
           paramList = JSON.serialize(cc);
            
            system.debug('canvas Parameters passed'+paramList );
            return JSON.serialize(cc);
        }catch( Exception e ){
            ApexPages.addMessages(e);
           system.debug(e.getmessage()+' error ');
            return null;
        }
    }
    /* Method to save the record and redirect the page back to detail page of the record */
    public PageReference saveRecord(){
        try{
            String srvGrp = ApexPages.currentPage().getParameters().get(SWBBPOSEIntegrationConstants.ServiceGroup);
            if(srvGrp == SWBBPOSEIntegrationConstants.io){
                if(costingRequest.Initial_Go_Live__c == null){
                    costingRequest.Initial_Go_Live__c= costingRequest.Contract_Start__c;   
                }
            }
            update costingRequest;
           // String srvGrp = ApexPages.currentPage().getParameters().get('SG');  
            PageReference page = new PageReference(UtilConstants.SLASH+'apex/check_redirect?id='+costingRequest.Id+'&SG='+srvGrp);                 
            return page;        
        }catch(Exception e){
            System.debug('ERROR ! ' + e);
            String eMsg; 
            isError = true;
            if(e.getMessage().contains(SWBBPOSEIntegrationConstants.FieldCustomValidationException)){
            String msg = e.getMessage().split(SWBBPOSEIntegrationConstants.FieldCustomValidationException)[1];
            eMsg = msg.split(SWBBPOSEIntegrationConstants.colon)[0];
            }else if(e.getMessage().contains(SWBBPOSEIntegrationConstants.InsufficientAccessOrReadOnly)){
              // String msg = e.getMessage().split('INSUFFICIENT_ACCESS_OR_READONLY')[1];
                eMsg = SWBBPOSEIntegrationConstants.insufficient_error ;
            }else{
                eMsg = e.getMessage();
            }
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,eMsg);
            if(!String.valueof(myMsg).contains('Contract duration')){
                ApexPages.addMessage(myMsg);
            }
            
           return null;
        }
        
    }
    public PageReference cancelRecord(){   
            String srvGrp = ApexPages.currentPage().getParameters().get(SWBBPOSEIntegrationConstants.ServiceGroup);      
            PageReference page = new PageReference(UtilConstants.SLASH+SWBBPOSEIntegrationConstants.check_redirecturl +costingRequest.Id+SWBBPOSEIntegrationConstants.sg+srvGrp);
            
            return page;    
    }
    
     /**
   *  @name : showUpdates
   *  @Description : showUpdates
   *  @param : NA
   *  @return parameter - NA
   *  @throws exception- NA
   */
    public void showUpdates(){
        costingRequest = [Select Id,client__c,In_Sync__c,Sync_Failed_At__c,Data_Cleaning_dev__c,Checked_Out_By__c,LastModifiedById,Is_BDL_Updated_Dev__c,SSM_Version__c,
        version__c,In_Progress__c,calculation__c,has_updated__c,Last_BDL_Generated_Scenario__c,BDL_Generated_UTC_Date__c,Last_BDL_Generated_User__c,
        Last_BDL_Generated_Version__c,Is_checked_out__c,Last_Checked_Out_By_Dev__c,name,opportunity__c,country__c,Contract_Start__c,Contract_End__c,
        Initial_Go_Live__c,Allow_Deal_Customization__c,Synced_Scenario_Name__c,Last_Synced_Date__c,Last_Synced_Up_By__c,Cost_Summary_and_Metrics__c,
        MRDB_Last_Refresh_Date__c,
        Synced_Scenario_Name_IO__c, Version_IO__c,Last_Synced_Date_IO__c,Last_Synced_Up_By_IO__c,Last_Synced_Up_By_IO__r.name,MRDB_Last_Refresh_Date_IO__c ,
        MRDB_Version_IO__c,Last_IDL_Generated_Scenario__c,Last_IDL_Generated_Version__c,IDL_Generated_UTC_Date__c,Last_IDL_Generated_User__c,Checked_Out_By_IO__c,
        opportunity__r.Service_Grp__c, In_Progress_IO__c,Calculation_IO__c,Data_Cleaning_dev_IO__c , Has_Updated_IO__c,
        MRDB_Version__c,In_Sync_IO__c,Sync_Failed_At_IO__c ,CDR_Scenario_Name__c,CDR_Sync_Date__c,Is_IDL_Updated_Dev__c, CostSummaryandMetrics_IO__c,sap_om_id__c
        from Costing_Request__c where ID =:costingId limit 1];
       // system.debug('@@@@@@@@@@'+costingRequest);
        showUpdate = '<script> refresh(); </script>';
        
     }
      //Method to set the field Is_Checked_Out__c to 'False'
    /**
   *  @name : forceCheckIn
   *  @Description : forceCheckIn
   *  @param : NA
   *  @return parameter - NA
   *  @throws exception- NA
   */
    public Pagereference forceCheckIn(){
    if(costingRequest.Is_checked_out__c){
        costingRequest.Is_Checked_Out__c=false;
        costingRequest.Checked_Out_By__c=null;
        costingRequest.Last_Checked_Out_By_Dev__c = null;        
        try{
            update costingRequest;
         }catch(Exception e){
             System.debug('ERROR !! ' +e);
            ApexPages.addMessages(e);
         }
         Pagereference pr = page.CostingRequestDetail_Page;
         pr.getParameters().put(UtilConstants.id_par,costingRequest.id);
         pr.setRedirect(true); 
         checkCheckOut();
         return pr;
         }else{
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'The same record is already checked in'));
             return null;
         }

    } 
    
    //Method to delete the records from Other_Cost_Details__c and FTE_Details__c objects
    /**
   *  @name : clearPrevData
   *  @Description : clearPrevData
   *  @param : NA
   *  @return parameter - NA
   *  @throws exception- NA
   */
      public Pagereference clearPrevData(){
    
        //Retrieves Other_Cost_Details__c records  
         set<id> recordstodelete = new set<id>();
         map<string,string> blankMap = new map<string,string>();        
         try{    
            //canvasclass.WrapperLabelClass  cwc =new canvasclass.WrapperLabelClass();
            integer recsize =0;
            List<Other_Cost_Details__c> costRecords=new list<other_cost_details__c>();
            List<payroll__c> payrollRecs=new list<payroll__c>();
            List<volume_detail__c> volumeRecs=new list<volume_detail__c>();
            List<FTE_Details__c> fteRecords=new list<fte_details__c>();
            list<cross_deal__C> crossRecs = new list<cross_deal__c>();
            if(serviceGroupDelete== SWBBPOSEIntegrationConstants.io){
            costRecords = [SELECT Id FROM Other_Cost_Details__c where Is_Transient__c = true and Costing_Request__c =:costingId 
                            AND  (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC)  limit 5000]; 
            fteRecords = [SELECT Id FROM FTE_Details__c where Is_Transient__c=true and Costing_Request__c =:costingId 
                            AND  (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC)  limit 5000];
            payrollRecs =  [SELECT Id FROM Payroll__c where Is_Transient__c=true and Costing_Request__c =:costingId 
                            AND  (service_group__c=:SWBBPOSEIntegrationConstants.IO OR service_group__c=:SWBBPOSEIntegrationConstants.IC)  limit 5000];
            volumeRecs = [select id from volume_Detail__C where Is_Transient__c=true and Cost__c =:costingId limit 5000];
            crossRecs = [select id from cross_deal__c where is_transient__C=true and Cost_Detail__c=:costingId limit 5000];     
            recsize = fteRecords.size()+costRecords.size()+payrollRecs.size()+volumeRecs.size()+crossRecs.size(); 
            }
            else{
            costRecords = [SELECT Id FROM Other_Cost_Details__c where Is_Transient__c = true and Costing_Request__c =:costingId 
                            AND service_group__C=:serviceGroupDelete limit 5000]; 
            fteRecords = [SELECT Id FROM FTE_Details__c where Is_Transient__c=true and Costing_Request__c =:costingId 
                            AND service_group__C=:serviceGroupDelete limit 5000];
            payrollRecs =  [SELECT Id FROM Payroll__c where Is_Transient__c=true and Costing_Request__c =:costingId 
                            AND service_group__C=:serviceGroupDelete limit 5000];
            recsize = fteRecords.size()+costRecords.size()+payrollRecs.size();
            }
            if(recsize != null && recsize  < 7000){
                database.delete(costRecords,true);
                database.delete(fteRecords,true);
                database.delete(payrollRecs,true);
                if(serviceGroupDelete==SWBBPOSEIntegrationConstants.io){
                    database.delete(volumeRecs,true);
                    database.delete(crossrecs,true);
                }       
            }else{
            for(FTE_Details__c fte :fteRecords ){
                recordstodelete.add(fte.id);
            }
            for(other_cost_Details__c ocd : costRecords){
                recordstodelete.add(ocd.id);
            }
            for(payroll__c proll : payrollRecs){
                recordstodelete.add(proll.id);
            }
            for(volume_detail__c  vroll : volumeRecs){
                recordstodelete.add(vroll.id);
            }
            for(cross_deal__C croll : crossRecs){
                recordstodelete.add(croll.id);
            }
              database.executebatch(new DeleteBatchSync(recordstodelete,costingRequest.opportunity__c,'delete',blankMap,serviceGroupDelete)); 
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Data is huge. Cleaning of Data is Initiated'));
            }
                Costing_Request__c costingRecord= new costing_request__C();
                costingRecord.id = costingRequest.id;
                sync_status__C sync = new sync_status__C();
                sync = [select id from sync_Status__c where opportunity__c=:costingRequest.opportunity__c limit 1 ];
                sync.Force_fully_Failed__c = true;
                if(serviceGroupDelete==SWBBPOSEIntegrationConstants.BPO){
                    costingRecord.In_Sync__c = false;
                    costingRecord.Sync_Failed_At__c = SWBBPOSEIntegrationConstants.emptystring;
                    costingRecord.Calculation__c = false;
                    costingRecord.Data_Cleaning_dev__c=false;
                    costingRecord.in_progress__c=SWBBPOSEIntegrationConstants.failurestatus;
                    sync.error__C = SWBBPOSEIntegrationConstants.SyncWasStruckForLongTimeForceCancelledByAdmin;
                }
                else{
                    costingRecord.In_Sync_IO__c = false;
                    costingRecord.Sync_Failed_At_IO__c = SWBBPOSEIntegrationConstants.emptystring;
                    costingRecord.Calculation_IO__c = false;
                    costingRecord.Data_Cleaning_dev_IO__c=false;
                    costingRecord.In_Progress_IO__c=SWBBPOSEIntegrationConstants.failurestatus;
                    sync.Error_IO__c = SWBBPOSEIntegrationConstants.SyncWasStruckForLongTimeForceCancelledByAdmin;
                }
                update costingRecord;
                update sync;
                //checkCheckOut();
            }catch(Exception e){
                ApexPages.addMessages(e);
                system.debug('exception ---->'+e.getStackTraceString()+'message '+e.getmessage());
            }
            pagereference pr = new pagereference('/'+costingRequest.id);     
            return pr;
    
       }  
    }