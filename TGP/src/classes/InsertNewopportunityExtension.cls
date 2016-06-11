/*
Author : Varsha Chougle
Story  : Story-0054/SOL_006  
Description : Controller for insertNewopportunity page.Create/maintain an opportunity data.. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Shridhar Patankar  Story-0054/SOL_006      26/02/2013       Added to prevent duplicate opportunity with SAP OM ID.
Mayank Tayal        D-0305                 22/03/2013        Made the Expected contract Sign field as Dropdown.
Shridhar Patankar   Sol_107                11/06/2013       TO make client geo area,client geo unit and Operating group as a dropdown.
*/
public with sharing class InsertNewopportunityExtension {
    public boolean NewValue{get;set;}
    public boolean NewValue1{get;set;}
    public boolean NewValue2{get;set;}
    public boolean NewValue3{get;set;}
    public boolean NewValue4{get;set;}
    public boolean editValue{get;set;}
    public boolean displayButton{get;set;}
    public Opportunity_TGP__c opportunity1;
    public String ClientName{get;set;}
    public boolean field1{get;set;}
    public boolean field2{get;set;}
    public boolean flag {get;set;}
    public String newid{get;set;}
    public List<Opportunity_TGP__c> opp {get;set;} //Added to prevent duplicate SAP OM ID
    public List<SAP_OM_Opportunity__c> sapOpp {get;set;} //Added to prevent duplicate SAP OM ID
    public String quarterName{get;set;}
    public Boolean addButtonRender {get; set;}
    public Boolean saveEditButtonRender {get; set;}
    public Boolean showFormMsg{get;set;}
    public String strUrl{get;set;}
    public String keyPrefix{get;set;}
    //Added to make Client Geo Area,Client Geo Unit and Operating group as a drop down.
    public String clientGeoAreaMaster{get;set;}
    public String clientGeoUnitMaster{get;set;}
    public String operatingGroupMaster{get;set;}
    public String runningUser{get;set;}
    public Opportunity_Team_SAP__c oppTeamSap;
    public Opportunity_Commerical_Data__c commercialRecord;
    public Governance_Data__c governanceRecord;


    /******************************
    Method Name: InsertNewopportunityExtension
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/   
    public InsertNewopportunityExtension (ApexPages.StandardController controller) {
        opportunity1=(Opportunity_TGP__c)controller.getRecord();
        oppTeamSap = new Opportunity_Team_SAP__c();
        oppTeamSap.BPO_Opp__c = opportunity1.Id;
        commercialRecord = new Opportunity_Commerical_Data__c();
        governanceRecord = new Governance_Data__c();
        
        commercialRecord.Opportunity_TGP__c = opportunity1.Id;
        governanceRecord.Opportunity_TGP__c = opportunity1.Id;
               
        runningUser = UserInfo.getUserId();
        strUrl = URL.getSalesforceBaseUrl().toExternalForm();
        Schema.DescribeSObjectResult res = Opportunity_TGP__c.SObjectType.getDescribe();
        keyPrefix = res.getKeyPrefix();
       
        NewValue=false;
        NewValue1=false;
        NewValue2=false;
        NewValue3=false;
        NewValue4=false;
        editValue=false;
        Option=UTIL_Constants.YES;
        displayButton=true;
        field1=true;
        //Get Current Page id.
        newid=ApexPages.CurrentPage().getParameters().get('id');
        //Logic for Edit Opp page.
        if(newid!=null)
        {  
           flag = true;
           //Iterate through Opportunity_TGP__c.
           for(Opportunity_TGP__c opp:[Select SAP_OM_ID_available_Y_N_del__c from Opportunity_TGP__c where id=:newid])
            {
                Option=opp.SAP_OM_ID_available_Y_N_del__c;
            }
                //Check for option No.
                if(Option==UTIL_Constants.NO)
                {
                     field1=false;
                     NewValue1=false;
                     NewValue2=true;
                     NewValue3=true;
                     NewValue4=true;
                     displayButton=false;
                }
                //Check for option No.
                if(Option==UTIL_Constants.YES)
                {
                   editValue=true;      
                }
            nextSection(); 
        }
        //UAM Code--Mayank Tayal-Sol_148        
        if(newid!=null)
        {
            /* List<Opportunity_TGP__c> lstOpp = [select id, name from Opportunity_TGP__c where id = : newid];
            String strOppId = lstOpp.get(0).id;
            UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Opportunity_TGP__c');            
            addButtonRender = m.get('C');
            saveEditButtonRender = m.get('U'); */
            
            addButtonRender = UAMSolMobUtility.addButtonRender_BPOOppTgp;
            saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
        }
        else{
        addButtonRender = true;
        saveEditButtonRender = true;
        }
        
        /* UAM SOL RV List<userRole> role = [select name from userRole where id=:UserInfo.getUserRoleId()];
        List<User> profiles = [Select id, name, profile.name from User where id=:runningUser];
        if(profiles.size()>0 )
        { 
             if(profiles[0].profile.name.equalsIgnoreCase('Solution Users') || profiles[0].profile.name.equalsIgnoreCase('Workbench Administrator') || profiles[0].profile.name.equalsIgnoreCase('Workbench User') )
             {
                 if(role .size()>0)
                 {
                     if(!role[0].name.equalsIgnoreCase('Operations'))
                         opportunity1.Enterprise_Solution_Architect__c =runningUser;
                     else{
                         showFormMsg=true;
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Insufficient Privileges!'));
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You do not have permission to perform this action. '));
                         return;   
                         }
                 }
                 else
                 { 
                     opportunity1.Enterprise_Solution_Architect__c =runningUser;
                     
                 }
             }
             
             else{
                 showFormMsg=true;
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Insufficient Privileges!'));
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You do not have permission to perform this action. '));
                 return;
             }
        }
        else{
                 showFormMsg=true;
                // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Insufficient Privileges!'));
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You do not have permission to perform this action.'));
                 return;
             }*/
        List<Review_User_Master__c> RUM = [select Id from Review_User_Master__c where SFDC_User__c =: runningUser limit 1];
        
        //List<User> userName = [select Name,id from User where Email= 'sophia.prem.kumar@accenture.com' limit 1];
        
        
        
        List<User> userName = [select Name,id from User where name=:System.label.BSS_User limit 1];
        system.debug('~~~'+userName);
        
        if(userName.size()>0){
        
            List<Review_User_Master__c> reviewUserName = [select Name,id from Review_User_Master__c where SFDC_User__c =: userName[0].id limit 1];
            system.debug('~~~'+reviewUserName);
            
            if(reviewUserName.size()>0)
            {
                
                     opportunity1.BSS_Operation_New__c = reviewUserName[0].id;
                     
                
            }
        }
        
        
        if(RUM != null && RUM.Size() > 0) {
            Id runningUserAUMRecord = RUM[0].Id;
            opportunity1.Enterprise_Solution_Architect_New__c = runningUserAUMRecord;
        }
        else {
            showFormMsg = true;
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have permission to perform this action as you are not recorded in user master'));
        }
    }
     /******************************
    Method Name: noSAPID
    Description: Logic when SAP OM ID is not there. 
    Paramenters: NA
    Return Value: NA
    *******************************/  
    public void noSAPID(){ 
        field1=false;
        field2=true;
        NewValue1=false;
        NewValue2=true;
        NewValue3=true;
        NewValue4=true;
        displayButton=false;
        opportunity1.Client_Name__c=null;
        opportunity1.Name=null;
        opportunity1.Stage__c=null;
        opportunity1.Expected_contract_sign_qtr__c=null;
        opportunity1.Client_Geo_Area__c=null;
        opportunity1.Client_Geo_Unit__c=null;
        opportunity1.Operating_Group__c=null; 
        opportunity1.Activity__c=null;
    }
    /******************************
    Method Name: yesSAPID
    Description: Logic when SAP OM ID is there. 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void yesSAPID(){ 
        field2=false;
        field1=true;
        NewValue1=false;
        NewValue2=false;
        NewValue3=false;
        NewValue4=false;
        displayButton=true;
        opportunity1.SAP_OM_Opportunity__c=null;
    }
    public String Option = null; 
    /******************************
    Method Name: getOption
    Description: To get options. 
    Paramenters: NA
    Return Value: NA
    *******************************/    
    public String getOption() 
    {
        return Option;
    }
    /******************************
    Method Name: setOption
    Description: To set options. 
    Paramenters: Option
    Return Value: NA
    *******************************/ 
    public void setOption(String Option) 
    {
        this.Option=Option;
    } 
    /******************************
    Method Name: nextSection
    Description: On click Next button. 
    Paramenters: NA
    Return Value: NA
    *******************************/       
    public PageReference nextSection() 
    { 
          //Story-0054/SOL_006 Starts
         //Added to prevent duplicate opportunity with SAP OM ID.
         if(newid==null){
         opp = new List<Opportunity_TGP__c>();
           for(Opportunity_TGP__c oppty : [Select id,SAP_OM_Opportunity__c from Opportunity_TGP__c]){
                //Check for Duplicate SAP OM ID
                if(opportunity1.SAP_OM_Opportunity__c ==oppty.SAP_OM_Opportunity__c && oppty.SAP_OM_Opportunity__c!=null  ){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Opportunity with same SAP OM ID is already present'));
                    return null;
            }
            }
            }
         //Logic when Option =Yes
         if(Option==UTIL_Constants.YES){
            if(opportunity1.SAP_OM_Opportunity__c==null){
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access rights: Cannot be Updated'));
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'SAP OM ID cannot be left blank'));
                
                return null;    
            }
            NewValue3=true;
            NewValue4=true;
            NewValue1=true;
            NewValue2=false;
            
            List<Client_Geo_Area_Master__c> lstClientGeoAreaMaster = [select id,name from Client_Geo_Area_Master__c where Active__c=true order by name];
            Map<String,Id> mapClientGeoAreaMaster = new Map<String,Id>();
            if(lstClientGeoAreaMaster.size() > 0)
            {
                for(Client_Geo_Area_Master__c cgaMasterObj:lstClientGeoAreaMaster)
                {
                    mapClientGeoAreaMaster.put(cgaMasterObj.name,cgaMasterObj.id);
                }
            }
            
            //Iterate through SAP OM Opportunity.
            for(SAP_OM_Opportunity__c sap:[select Name,Opportunity_Name__c,Service_Group__c,Competitive_Sole_Source__c,Competitor__c,Win_Probability__c,Pricing_Type__c,
                                            Max_Offering_Name__c,TCV__c,IS_Net_Revenue__c,Activity__c,Client_Geo_Area__c,Geography__c,Client_Geo_Unit__c,Client_Name__c,Primary_offerings_new__c,
                                            Expected_contract_sign_Quarter__c,Operating_Group__c,Stage__c,Client_Account_Lead__c,Client_QA_Director__c,Delivery_Lead_BPO__c,
                                            Global_Client_Account_Lead__c,Managing_Director_MC__c,Mobilization_Lead__c,Opportunity_Contact__c,
                                            Opportunity_QA_Director__c,Sales_Capture_Opp_Director__c,Sales_Capture_OSL__c,Sales_Capture_Other__c,Sales_Origination__c,
                                            Solution_Arch_BPO__c,Technology_Account_Lead__c ,SAP_Create_Date__c,CSG__c,Delivery_Centers__c,Expected_Contract_Signing_Date__c,
                                            Function_Business_Services__c,Industry_Business_Services__c,Master_Client_Name__c,Mergers_Acquisitions__c,Pipeline_Entry_Date__c,
                                            Primary_Work_Location__c,Proposal_Submission_Date__c,Restricted__c,RSD_Quarter__c,Stage_Update_Date__c,Sub_CSG__c,
                                            Third_Party_Advisors__c,Total_Solution_Contingency__c,Total_Solution_Contingency_Amount__c,Total_Current_Net_Revenue__c,
                                            SAP_OM_ID_External_ID__c,BPO_Margin_Diff__c from SAP_OM_Opportunity__c where id=:opportunity1.SAP_OM_Opportunity__c])
            {
                system.debug('Service_Group__c~~~~'+sap.Service_Group__c);
                oppTeamSap.Client_Account_Lead__c =  sap.Client_Account_Lead__c;
                oppTeamSap.Client_QA_Director__c =  sap.Client_QA_Director__c;
                oppTeamSap.Delivery_Lead_BPO__c =  sap.Delivery_Lead_BPO__c;
                //oppTeamSap.Due_Diligence_Lead__c =  sap.Due_Diligence_Lead__c;
                oppTeamSap.Global_Client_Account_Lead__c =  sap.Global_Client_Account_Lead__c;
                oppTeamSap.Managing_Director_MC__c =  sap.Managing_Director_MC__c;
                oppTeamSap.Mobilization_Lead__c =  sap.Mobilization_Lead__c;
                oppTeamSap.Opportunity_Contact__c =  sap.Opportunity_Contact__c;
                oppTeamSap.Opportunity_QA_Director__c =  sap.Opportunity_QA_Director__c;
                oppTeamSap.Sales_Origination__c =  sap.Sales_Origination__c;
                oppTeamSap.Sales_Capture_Opp_Director__c =  sap.Sales_Capture_Opp_Director__c;
                oppTeamSap.Sales_Capture_OSL__c =  sap.Sales_Capture_OSL__c;
                oppTeamSap.Sales_Capture_Other__c =  sap.Sales_Capture_Other__c;
                oppTeamSap.Solution_Arch_BPO__c =  sap.Solution_Arch_BPO__c;
                oppTeamSap.Technology_Account_Lead__c =  sap.Technology_Account_Lead__c;
                
                
                opportunity1.Service_Group__c =  sap.Service_Group__c; //komal change
                opportunity1.Client_Name__c=sap.Client_Name__c;
                opportunity1.Name=sap.Opportunity_Name__c;
                opportunity1.Stage__c=sap.Stage__c;
                opportunity1.Expected_contract_sign_qtr__c=sap.Expected_contract_sign_Quarter__c;
                //opportunity1.Client_Geo_Area__c=sap.Client_Geo_Area__c;
                opportunity1.Third_party_Advisors__c=sap.Third_Party_Advisors__c;
                opportunity1.Client_Geo_Unit__c=sap.Client_Geo_Unit__c;
                opportunity1.Operating_Group__c=sap.Operating_Group__c; 
                opportunity1.Activity__c=sap.Activity__c;
                opportunity1.TCV__c=sap.TCV__c;
                
                opportunity1.Estimated_TCV__c=sap.TCV__c;
                opportunity1.IS_Net_Revenue_SAP__c=sap.IS_Net_Revenue__c;
                opportunity1.IS_Net_Revenue_SD_Estimate__c=sap.IS_Net_Revenue__c;
                
                opportunity1.SAP_OM_ID__c = sap.Name;
                opportunity1.Primary_offerings__c=sap.Primary_offerings_new__c;
                opportunity1.Win_Probability__c=sap.Win_Probability__c;
                opportunity1.Competitors__c=sap.Competitor__c;
                opportunity1.Pricing_Type__c=sap.Pricing_Type__c;
                opportunity1.Competitive_Sole_Source__c=sap.Competitive_Sole_Source__c;
                opportunity1.SAP_Create_Date__c=sap.SAP_Create_Date__c;
                opportunity1.CSG__c=sap.CSG__c;
                opportunity1.Delivery_Centers__c=sap.Delivery_Centers__c;
                opportunity1.Expected_Contract_Signing_Date__c=sap.Expected_Contract_Signing_Date__c;
                opportunity1.Function_Business_Services__c=sap.Function_Business_Services__c;
                opportunity1.Industry_Business_Services__c=sap.Industry_Business_Services__c;
                opportunity1.Master_Client_Name__c=sap.Master_Client_Name__c;
                opportunity1.Mergers_Acquisitions__c=sap.Mergers_Acquisitions__c;
                opportunity1.Pipeline_Entry_Date__c=sap.Pipeline_Entry_Date__c;
                opportunity1.Primary_Work_Location__c=sap.Primary_Work_Location__c;
                opportunity1.Proposal_Submission_Date__c=sap.Proposal_Submission_Date__c;
                opportunity1.Restricted__c=sap.Restricted__c;
                opportunity1.RSD_Quarter__c=sap.RSD_Quarter__c;
                opportunity1.Stage_Update_Date__c=sap.Stage_Update_Date__c;
                opportunity1.Sub_CSG__c=sap.Sub_CSG__c;
                opportunity1.Third_Party_Advisors__c=sap.Third_Party_Advisors__c;
                opportunity1.Total_Solution_Contingency__c=sap.Total_Solution_Contingency__c;
                opportunity1.Total_Solution_Contingency_Amount__c=sap.Total_Solution_Contingency_Amount__c;
                opportunity1.Total_Current_Net_Revenue__c=sap.Total_Current_Net_Revenue__c;
                opportunity1.SAP_OM_ID__c=sap.SAP_OM_ID_External_ID__c;
                //opportunity1.SOURCING_PROCUREMENT__c=sap.SOURCING_PROCUREMENT__c;
                opportunity1.BPO_Margin_Diff__c=sap.BPO_Margin_Diff__c;
                system.debug('Initialization ends:::'+opportunity1.Service_Group__c);
                if(!mapClientGeoAreaMaster.isEmpty() && sap.Geography__c != null)
                {
                    if(mapClientGeoAreaMaster.get(sap.Geography__c) != null)
                    {
                        opportunity1.Client_Geo_Area__c = mapClientGeoAreaMaster.get(sap.Geography__c);
                    }                           
                }
                
                //Added for SOL-170.Shridhar 
                for(Offerings_Master__c offMaster : [Select id,Name,Category__c from Offerings_Master__c where Name =:sap.Max_Offering_Name__c])
                {
                     opportunity1.Offering_Master__c=offMaster.id;
                }
            }
        }
        //Logic when option is No
        else if(Option==UTIL_Constants.NO)
        {
            
            NewValue1=false;
            NewValue2=true;
            NewValue3=true;
            NewValue4=true;
            /*opportunity1.Client_Name__c=null;
            opportunity1.Name=null;
            opportunity1.Stage__c=null;
            opportunity1.Expected_contract_sign_qtr__c=null;
            opportunity1.Client_Geo_Area__c=null;
            opportunity1.Client_Geo_Unit__c=null;
            opportunity1.Operating_Group__c=null; 
            opportunity1.Activity__c=null;*/
        }
        return null;
    }
     /******************************
    Method Name: getSAPOMIDOptions
    Description: To get SAP OM ID options(Yes or NO).
    Paramenters: NA
    Return Value: NA
    *******************************/  
    public List<SelectOption> getSAPOMIDOptions() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(UTIL_Constants.YES,UTIL_Constants.YES));
        options.add(new SelectOption(UTIL_Constants.NO,UTIL_Constants.NO));
        return options;
    }
    /******************************
    Method Name: getQuarterNames
    Description: To get the list of all the Fiscal Year Quarters.
    Paramenters: NA
    Return Value: List<SelectOption>
    *******************************/ 
    public List<SelectOption> getQuarterNames()
    {
        List<SelectOption> qtrName=new List<SelectOption>();
        qtrName.add(new SelectOption('None','--None--'));
        /*for(Integer i=1;i<=4;i++)
        {
            Integer year1=datetime.now().year()-1;
            String strYear=String.valueOf(year1);
            String qtrValue='FY'+strYear.subString(2,4)+' Q'+i;
            qtrName.add(new SelectOption(qtrValue, qtrValue));            
        }*/
        for(Integer i=1;i<=4;i++)
        {
            Integer year1=datetime.now().year();
            String strYear=String.valueOf(year1);
            String qtrValue='FY'+strYear.subString(2,4)+' Q'+i;
            qtrName.add(new SelectOption(qtrValue, qtrValue));            
        }
        for(Integer i=1;i<=4;i++)
        {
            Integer year1=datetime.now().year()+1;
            String strYear=String.valueOf(year1);
            String qtrValue='FY'+strYear.subString(2,4)+' Q'+i;
            qtrName.add(new SelectOption(qtrValue, qtrValue));            
        }
        for(Integer i=1;i<=4;i++)
        {
            Integer year1=datetime.now().year()+2;
            String strYear=String.valueOf(year1);
            String qtrValue='FY'+strYear.subString(2,4)+' Q'+i;
            qtrName.add(new SelectOption(qtrValue, qtrValue));            
        }              
        return qtrName;
    }
    /******************************
    Method Name: getclientGeoArea
    Description: Add method to get category only related to Client Geo Area master
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public List<SelectOption> getclientGeoArea(){
       List<SelectOption> clientGeoArea=new List<SelectOption>();
       List<Client_Geo_Area_Master__c> cgam=[select id,name,Active__c  from Client_Geo_Area_Master__c where Active__c = true order by name];
       if(cgam.Size()>0){
          for(Client_Geo_Area_Master__c c : cgam)
          {
              if(!c.name.equals('EALA'))
              {
                clientGeoArea.add(new SelectOption(c.id, c.name));        
              }
          }
       }
        return clientGeoArea;
    }          
    //End
    /******************************
    Method Name: getclientGeoUnit
    Description: Add method to get category only related to Category Geo Unit master.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public List<SelectOption> getclientGeoUnit(){
       List<SelectOption> clientGeoUnit=new List<SelectOption>();
       List<Client_Geo_Unit_Master__c> cgum=[select id,name,Active__c  from Client_Geo_Unit_Master__c where Active__c = true order by name];
       clientGeoUnit.add(new SelectOption('None','--None--')); 
       if(cgum.Size()>0){
          for(Client_Geo_Unit_Master__c c : cgum){
            clientGeoUnit.add(new SelectOption(c.id, c.name)); 
          }
       }
        return clientGeoUnit;
    }          
    //End
    /******************************
    Method Name: getoperatingGroup
    Description: Add method to get category only related to Category master
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public List<SelectOption> getoperatingGroup(){
       List<SelectOption> operatingGroup=new List<SelectOption>();
       List<Operating_Group_Master__c> ogm=[select id,name,Active__c  from Operating_Group_Master__c where Active__c = true order by name];
       if(ogm.Size()>0){
          for(Operating_Group_Master__c c : ogm){
            operatingGroup.add(new SelectOption(c.id, c.name)); 
          }
       }
        return operatingGroup;
    }          
    //End
    /******************************
    Method Name: saverecord
    Description: To save Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public PageReference saverecord()
    {
    
        system.debug('--inside method--'+opportunity1.Service_Group__c);
        opportunity1.SAP_OM_ID_available_Y_N_del__c=Option;  
        
        system.debug('--opportunity1.Service_Group__c--'+opportunity1.Service_Group__c);
                 
        //Check for null
        if(opportunity1.Stage__c==null || opportunity1.Stage__c=='')
        {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Stage cannot be None. Please select another value'));
             return null;
        }
        
         
        if(opportunity1.Name==null || opportunity1.Name=='')
        { 
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Opportunity Name cannot be left blank'));
             return null;
        }
        /* if(opportunity1.Risk_Level__c==null)
        {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Risk Level cannot be None. Please select another value'));
             return null;
        }*/
        //Check for null
        if(opportunity1.Activity__c==null || opportunity1.Activity__c=='')
        {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Reporting Status cannot be None. Please select another value'));
             return null;
        }
        if(string.valueOF(opportunity1.Client_Name__c) == null )
        {
            
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Client Name cannot be left blank'));
             return null;
        }
        //Check for null
        /*if(opportunity1.Enterprise_Solution_Architect__c==null)
        {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required field is missing: [Enterprise Solution Architect]'));
             return null;
        }*/
        //Check for null
       
        if(Option==UTIL_Constants.YES)
        {
            try
            {
                if(newid!=null)
                {
                
                    system.debug('--opportunity1.Service_Group__c inside if--'+opportunity1.Service_Group__c);
                    //Update Opportunity records.
                    update opportunity1;
                    update oppTeamSap;
                    update commercialRecord;
                }
                else
                {
                system.debug('-------opportunity1------------'+opportunity1);
                    //Insert Opportunity when Edit record of Opportunity detail page.
        if(opportunity1.Risk_Level__c==null)
            {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Risk Level cannot be None. Please select another value'));
                 return null;
            }
                    insert opportunity1;                    
                    oppTeamSap.BPO_Opp__c = opportunity1.Id;
                    insert oppTeamSap;
                    commercialRecord.Opportunity_TGP__c = opportunity1.Id;
                    insert commercialRecord; 
                 // INSERTS GOVERNANCE RECORD FOR FIRST TIME.
                    InsertGovernanceRecord();          
                }
            }
            catch(Exception ex)
            {
               if(ex.getMessage().contains('Update failed')){
                   
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have permission to perform this action.'));
                   return null;
               }
               
                return null;
            }  
        }
        //Logic for Option No
        if(Option==UTIL_Constants.NO)
        {
            opportunity1.Client_Geo_Area__c=clientGeoAreaMaster; 
            if(clientGeoUnitMaster=='None')
            {
            opportunity1.Client_Geo_Unit__c=null;
            }
            else{ 
            opportunity1.Client_Geo_Unit__c =clientGeoUnitMaster;  
            }
            opportunity1.Operating_Group__c=operatingGroupMaster; 
            //Code for Checking the Valid Quarter--Starts-By Mayank Tayal
            if(quarterName=='None')
            {
             opportunity1.Expected_contract_sign_qtr__c=null;
            }
            else
            {
            Integer yearValue=Integer.valueOf(quarterName.subString(2,4));        
            Integer qtrValue=Integer.valueOf(quarterName.subString(6,7));
            
            Integer year1=datetime.now().year();
            String strYear=String.valueOf(year1);
            Integer currentYearValue=Integer.valueOf(strYear.subString(2,4));
            
            if(yearValue < currentYearValue)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the valid Expected contract sign (Quarter)'));
                return null;            
            }
            else if(yearValue==currentYearValue)
            {
                Integer currentMonth=datetime.now().month();
                Integer currentQuarter=0;
                if(currentMonth>=1 && currentMonth<=3)
                {
                    currentQuarter=1;
                }
                if(currentMonth>=4 && currentMonth<=6)
                {
                    currentQuarter=2;
                }
                if(currentMonth>=7 && currentMonth<=9)
                {
                    currentQuarter=3;
                }
                if(currentMonth>=10 && currentMonth<=12)
                {
                    currentQuarter=4;
                }
                if(qtrValue<currentQuarter)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the valid Expected contract sign (Quarter)'));
                    return null;
                }
            }
            //Code for Checking the Valid Quarter--Ends-By Mayank Tayal
            opportunity1.Expected_contract_sign_qtr__c=quarterName;
            }
            try
            {
                if(newid!=null)
                {
                    
                    opportunity1.SAP_OM_Opportunity__c=null;                     
                    update opportunity1;
                }
                else
                {
                    opportunity1.SAP_OM_Opportunity__c=null;                    
                    insert opportunity1;
                    commercialRecord.Opportunity_TGP__c = opportunity1.Id;
                    insert commercialRecord; 
                    // INSERTS GOVERNANCE RECORD FOR FIRST TIME.
                    InsertGovernanceRecord();
                }
            }
            catch(Exception ex)
            {
                
               if(ex.getMessage().contains('Update failed')){
                   
                   
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have permission to perform this action.'));
                   return null;
               }
                return null;
            }
        }
        PageReference pr;  
        if(opportunity1.id!=null){      
        pr=new PageReference('/'+opportunity1.id);
        pr.setRedirect(true);
        return pr; 
       }
        return null;       
    }   
    //End   
    /*******************************
        Method Name: InsertGovernanceRecord
        Description: Inserting Governance record while creating the Opportunity record for the first time.
        Paramenters: NA
        Return Value: NA    
    ********************************/   
    public void InsertGovernanceRecord(){
        
        try{
        governanceRecord = new Governance_data__c();
        governanceRecord.Opportunity_TGP__c = opportunity1.Id;
        upsert governanceRecord;
        
        List<String> milestoneList = new List<String>();
        milestoneList.add('Stage 1 Submit Date (RFI Response Due)');
        milestoneList.add('Stage 2 Submit Date (RFP or Proposal Response Due)');
        milestoneList.add('Due Diligence Start Date');
        milestoneList.add('Contract Start Date');
        milestoneList.add('Contract End Date');
        milestoneList.add('Initial Go Live Date');
        milestoneList.add('Expected Contract Sign Date');        
        
         List<Governance_Critical_Milestones__c> updatedMilestoneList = new List<Governance_Critical_Milestones__c>();
        Governance_Critical_Milestones__c milestoneObj = new Governance_Critical_Milestones__c(Governance_Data__c=[select id from Governance_Data__c where Opportunity_TGP__c=:opportunity1.Id].id);
        for(integer i=0;i<milestoneList.size();i++){
            milestoneObj.Milestone__c = milestoneList[i];
            updatedMilestoneList.add(milestoneObj);
            milestoneObj = new Governance_Critical_Milestones__c(Governance_Data__c=[select id from Governance_Data__c where Opportunity_TGP__c=:opportunity1.Id].id);
            
        }
        Database.insert(updatedMilestoneList);
        }catch(Exception ex){
            system.debug('insert milestone@'+ex.getMessage());
        }
              
        
    }  
}