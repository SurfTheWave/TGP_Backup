public with sharing class OSLassignmentController{
    public String taskId{get;set;}
    public boolean isSAuser{get;set;}
    public Opportunity_TGP__c opportunityRecord{get;set;}
    public String solTaskId{get;set{solTaskId=value;}}
    public List<Opportunity_Solution_Lead_Task__c> oslRecordList{get;set;}
    public Opportunity_Solution_Lead_Task__c oslRecord{get;set;}
    public Boolean showMainMsg{get;set;}
    public Boolean showForm{get;set;}   
    public String listViewSelected {get; set;}
    public ApexPages.StandardController stdController{get; set;}    
    public List<Opportunity_Solution_Lead_Task__c> ccatList{get;set;}
    public Opportunity_Solution_Lead_Task__c ccatRecord{get;set;}
    public boolean temp{get;set;}
    public String oppId{get;set;}
    public String Option {get;set;}
    public boolean field1{get;set;}
    public boolean displayOppName{get;set;}
    public boolean field2{get;set;}
    public boolean displayButton{get;set;}
    public boolean gridVisible{get;set;}
    public Opportunity_TGP__c newOpp{get;set;}  
    public Opportunity_TGP__c newOpp1{get;set;}  
    public String strUrl{get;set;}
    public Opportunity_Solution_Lead_Task__c oppSoluLeadTask {get;set;}
    public List<SelectOption> statusOptions {get;set;}
    public String statusValue {get;set;}
    public sObject ss = new Opportunity_Solution_Lead_Task__c();
    public String StatusSelectNEW{get; set;}
    public Opportunity_Team_SAP__c oppTeamSap = new Opportunity_Team_SAP__c();  
    public Opportunity_Commerical_Data__c commercialRecord;
    public Governance_Data__c governanceRecord;
    public List<Governance_Data__c> lstGov;

    
    public OSLassignmentController()
   {
         field2=true;
         strUrl = URL.getSalesforceBaseUrl().toExternalForm();
        
         // UAM SOL RV
         List<Profile> profileList = [select name from profile where id = :userinfo.getProfileId()];
         List<userRole> role = [select name from userRole where id=:UserInfo.getUserRoleId()];
        
       //  if(role.size()>0)
       //  {
        // if((profileList[0].name.equalsIgnoreCase(System.Label.PMO_Profile)))
        // {
             Option='yes';
             displayButton=true;
             field1=true;
             ccatRecord=new Opportunity_Solution_Lead_Task__c();
             gridVisible=false;
         /*}
         else
         {
         field2=false;
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have permission to perform this action.'));
         return;
         
         }*/
       //  }
       /*  else
         {
         field2=false;
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have permission to perform this action.'));
         return;
         
         }*/
         
         
        oppSoluLeadTask = new Opportunity_Solution_Lead_Task__c();        
        statusOptions = new List<SelectOption>();

        // Use DescribeFieldResult object to retrieve status field.
        Schema.DescribeFieldResult statusFieldDescription = Opportunity_Solution_Lead_Task__c.Staffing_Status__c.getDescribe();

        // For each picklist value, create a new select option
        for (Schema.Picklistentry picklistEntry: statusFieldDescription.getPicklistValues()){

            statusOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));

            // obtain and assign default value
            if (picklistEntry.defaultValue){
                oppSoluLeadTask.Staffing_Status__c = pickListEntry.getValue();
            }  
        }            
   } 
   
   public void noSAPID()
   { 
        field1=false;
        displayButton=false;
        ccatRecord=new Opportunity_Solution_Lead_Task__c();
        gridVisible=true;
        displayOppName=true;
   }
   
   public void yesSAPID()
   { 
        field1=true;
        displayButton=true;
        gridVisible=false;
        displayOppName=false;
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
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        return options;
    } 
    public void nextSection() 
    {
        
        if(Option=='yes')
        {
            list<Opportunity_TGP__c> oppTGPList = [Select id,SAP_OM_Opportunity__c from Opportunity_TGP__c];
            if(oppTGPList.size()>0)
            {
                for(Opportunity_TGP__c oppty :oppTGPList)
                {
                    //Check for Duplicate SAP OM ID
                    if(ccatRecord.SAP_OM_Opportunity__c ==oppty.SAP_OM_Opportunity__c && oppty.SAP_OM_Opportunity__c!=null  )
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Opportunity with same SAP OM ID is already present'));
                        return;
                    }
                }
            }
            if(ccatRecord.SAP_OM_Opportunity__c==null)
            {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access rights: Cannot be Updated'));
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter SAP OM ID'));
                return;    
            }
           List<SAP_OM_Opportunity__c > listSAPOpp= [select Opportunity_Name__c,Client_Name__c from SAP_OM_Opportunity__c where id=:ccatRecord.SAP_OM_Opportunity__c];
           if(listSAPOpp.size()>0)
           {
                for(SAP_OM_Opportunity__c sap:listSAPOpp)
                {
                    ccatRecord.Client_Name_Master__c=sap.Client_Name__c;
                    ccatRecord.Opportunity_TGP__c=sap.Opportunity_Name__c;   
                }
           }
        }
        gridVisible=true;
        return; 
    }
    public void AssignSolutionLead()
    {
        try
        {
             if(ccatRecord.Opportunity_TGP__c == null)
             {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Opportunity Name cannot be left blank'));
                 return;    
             }
             if(ccatRecord.Client_Name_Master__c == null)
             {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Client Name cannot be left blank'));
                 return;    
             }
             if(StatusSelectNEW == 'Assigned' && ccatRecord.Opportunity_Solution_Lead_New__c == null)
             {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Solution Lead cannot be left blank if Staffing Status field value is Assigned'));
                 return;    
             }
             if(ccatRecord.Opportunity_Solution_Lead_New__c == null){
                Id reviewUserMasterId = [select Id from Review_user_Master__c where SFDC_User__c =: UserInfo.getUserId() limit 1].id;
                 ccatRecord.Opportunity_Solution_Lead_New__c= reviewUserMasterId;
             }
          //   if(ccatRecord.Opportunity_Solution_Lead__c == null)
          //   {
          //       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Solution Lead cannot be left blank'));
          //       return;    
          //  }              
          //  if(ccatRecord.Opportunity_Solution_Lead__c != null && ccatRecord.Horizon_Deal__c == true) 
          //  {
          //      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'If the Horizon Deal Box is checked, the Lead Solution Architect – BPO field should not be filled'));
          //      return;           
          //  }
          //  if (ccatRecord.Opportunity_Solution_Lead__c == null && ccatRecord.Horizon_Deal__c == false)
          //   {
          //       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'if Lead Solution Architect – BPO isn’t filled out, then Horizon must be checked'));
          //       return;    
          //   } 
             upsert ccatRecord;    
             
             newOpp=new Opportunity_TGP__c();
             
              //List<User> userName = [select Name,id from User where Email= 'sophia.prem.kumar@accenture.com' limit 1];
        
        
             List<User> userName = [select Name,id from User where name=: System.label.BSS_User limit 1];
        
            
            if(userName.size()>0){
            
                List<Review_User_Master__c> reviewUserName = [select Name,id from Review_User_Master__c where SFDC_User__c =: userName[0].id limit 1];
                
                
                if(reviewUserName.size()>0)
                {
                    
                         newOpp.BSS_Operation_New__c = reviewUserName[0].id;
                         
                    
                }
            }
            
             
             newOpp.Name=ccatRecord.Opportunity_TGP__c;
             newOpp.Client_Name__c=ccatRecord.Client_Name_Master__c;
             newOpp.Horizon_Deal__c = ccatRecord.Horizon_Deal__c;
             
             newOpp.Enterprise_Solution_Architect_New__c=ccatRecord.Opportunity_Solution_Lead_New__c;
             newOpp.Staffing_Status__c=StatusSelectNEW; 
             if(ccatRecord.SAP_OM_Opportunity__c!= null)
             {
                 newOpp.SAP_OM_Opportunity__c=ccatRecord.SAP_OM_Opportunity__c;
             }
             newOpp.SAP_OM_ID_available_Y_N_del__c=Option;
             //Added by Shridhar Description :- For populating Client geo area,Operating Group and Client Geo Unit
             //Start
             //Iterate through SAP OM Opportunity.
            for(SAP_OM_Opportunity__c sap:[select Opportunity_Name__c,Max_Offering_Name__c,TCV__c,Activity__c,Client_Geo_Area__c,Client_Geo_Unit__c,
                                            Client_Name__c,Expected_contract_sign_Quarter__c,Operating_Group__c,Stage__c,SAP_Create_Date__c,CSG__c,Delivery_Centers__c,
                                            Expected_Contract_Signing_Date__c,Function_Business_Services__c,Industry_Business_Services__c,Master_Client_Name__c,Primary_offerings_new__c,
                                            Mergers_Acquisitions__c,Pipeline_Entry_Date__c,Primary_Work_Location__c,Proposal_Submission_Date__c,Restricted__c,RSD_Quarter__c,
                                            Stage_Update_Date__c,Sub_CSG__c,Third_Party_Advisors__c,Total_Solution_Contingency__c,Total_Solution_Contingency_Amount__c,BPO_Margin_Diff__c,
                                            Total_Current_Net_Revenue__c,SAP_OM_ID_External_ID__c, Competitive_Sole_Source__c from SAP_OM_Opportunity__c where id=:newOpp.SAP_OM_Opportunity__c])
            {
          
                newOpp.Client_Geo_Area__c=sap.Client_Geo_Area__c;
                newOpp.Client_Geo_Unit__c=sap.Client_Geo_Unit__c;
                newOpp.Operating_Group__c=sap.Operating_Group__c; 
                newOpp.Client_Geo_Area__c=sap.Client_Geo_Area__c;
                newOpp.Client_Geo_Unit__c=sap.Client_Geo_Unit__c;
                newOpp.Operating_Group__c=sap.Operating_Group__c; 
                newOpp.Activity__c=sap.Activity__c; 
                newOpp.TCV__c=sap.TCV__c; 
                newOpp.Estimated_TCV__c=sap.TCV__c; 
                newOpp.Stage__c =sap.Stage__c ;
                newOpp.Third_party_Advisors__c=sap.Third_Party_Advisors__c; 
                newOpp.Expected_contract_sign_qtr__c=sap.Expected_contract_sign_Quarter__c;
                newOpp.Primary_offerings__c=sap.Primary_offerings_new__c;
                newOpp.SAP_Create_Date__c=sap.SAP_Create_Date__c;
                newOpp.CSG__c=sap.CSG__c;
                newOpp.Delivery_Centers__c=sap.Delivery_Centers__c;
                newOpp.Expected_Contract_Signing_Date__c=sap.Expected_Contract_Signing_Date__c;
                newOpp.Function_Business_Services__c=sap.Function_Business_Services__c;
                newOpp.Industry_Business_Services__c=sap.Industry_Business_Services__c;
                newOpp.Master_Client_Name__c=sap.Master_Client_Name__c;
                newOpp.Mergers_Acquisitions__c=sap.Mergers_Acquisitions__c;
                newOpp.Pipeline_Entry_Date__c=sap.Pipeline_Entry_Date__c;
                newOpp.Primary_Work_Location__c=sap.Primary_Work_Location__c;
                newOpp.Proposal_Submission_Date__c=sap.Proposal_Submission_Date__c;
                newOpp.Restricted__c=sap.Restricted__c;
                newOpp.RSD_Quarter__c=sap.RSD_Quarter__c;
                newOpp.Stage_Update_Date__c=sap.Stage_Update_Date__c;
                newOpp.Sub_CSG__c=sap.Sub_CSG__c;
                newOpp.Total_Solution_Contingency__c=sap.Total_Solution_Contingency__c;
                newOpp.Total_Solution_Contingency_Amount__c=sap.Total_Solution_Contingency_Amount__c;
                newOpp.Total_Current_Net_Revenue__c=sap.Total_Current_Net_Revenue__c;
                newOpp.SAP_OM_ID__c=sap.SAP_OM_ID_External_ID__c;
                //newOpp.SOURCING_PROCUREMENT__c=sap.SOURCING_PROCUREMENT__c;
                newOpp.Competitive_Sole_Source__c= sap.Competitive_Sole_Source__c;
                newOpp.BPO_Margin_Diff__c=sap.BPO_Margin_Diff__c;
                 //Added for SOL-170.Shridhar 
                for(Offerings_Master__c offMaster : [Select id,Name,Category__c from Offerings_Master__c where Name =:sap.Max_Offering_Name__c])
                {
                     newOpp.Offering_Master__c=offMaster.id;
                }                 
            }
            //End 
              upsert newOpp;
              
              oppTeamSap = new Opportunity_Team_SAP__c();
              oppTeamSap.BPO_Opp__c = newOpp.Id;
              
              for(SAP_OM_Opportunity__c sap:[select Opportunity_Name__c,Max_Offering_Name__c,TCV__c,Activity__c,Client_Geo_Area__c,Client_Geo_Unit__c,Client_Name__c,Expected_contract_sign_Quarter__c,Operating_Group__c,Stage__c,Client_Account_Lead__c,Client_QA_Director__c,Delivery_Lead_BPO__c,Global_Client_Account_Lead__c,Managing_Director_MC__c,Mobilization_Lead__c,Opportunity_Contact__c,Opportunity_QA_Director__c,Sales_Capture_Opp_Director__c,Sales_Capture_OSL__c,Sales_Capture_Other__c, Sales_Origination__c,Solution_Arch_BPO__c,Technology_Account_Lead__c from SAP_OM_Opportunity__c where id=:newOpp.SAP_OM_Opportunity__c])
              {
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
              }
              
              upsert oppTeamSap;
              
              commercialRecord = new Opportunity_Commerical_Data__c();
              commercialRecord.Opportunity_TGP__c = newOpp.Id;
              upsert commercialRecord;
            
              governanceRecord = new Governance_data__c();
              governanceRecord.Opportunity_TGP__c = newOpp.Id;
              upsert governanceRecord;
              
               lstGov = [select id from Governance_Data__c where Opportunity_TGP__c=:newOpp.Id];
                    List<Governance_Critical_Milestones__c> com = new List<Governance_Critical_Milestones__c>();
                    for(Governance_Data__c o: lstGov){
                          
                       Governance_Critical_Milestones__c dataa= new Governance_Critical_Milestones__c(Governance_Data__c=o.id);
                       dataa.Milestone__c = 'Stage 1 Submit Date (RFI Response Due)';
                       com.add(dataa);
                        
                       dataa= new Governance_Critical_Milestones__c(Governance_Data__c=o.id);
                       dataa.Milestone__c = 'Stage 2 Submit Date (RFP or Proposal Response Due)';
                       com.add(dataa);
                        
                       dataa= new Governance_Critical_Milestones__c(Governance_Data__c=o.id);
                       dataa.Milestone__c = 'Due Diligence Start Date';
                       com.add(dataa);
                        
                       dataa= new Governance_Critical_Milestones__c(Governance_Data__c=o.id);
                       dataa.Milestone__c = 'Contract Start Date';
                       com.add(dataa);
                        
                       dataa= new Governance_Critical_Milestones__c(Governance_Data__c=o.id);
                       dataa.Milestone__c = 'Contract End Date';
                       com.add(dataa);
                        
                       dataa= new Governance_Critical_Milestones__c(Governance_Data__c=o.id);
                       dataa.Milestone__c = 'Initial Go Live Date';
                       com.add(dataa);
                        
                       dataa= new Governance_Critical_Milestones__c(Governance_Data__c=o.id);
                       dataa.Milestone__c = 'Expected Contract Sign Date';
                       com.add(dataa); 
                        
                    }
                     insert com; 
                    
              
              List<Opportunity_TGP__c> opportunityList=[select id,SAP_OM_Opportunity__r.name, name,Enterprise_Solution_Architect_New__r.name,Client_Name__r.name from Opportunity_TGP__c where name=:ccatRecord.Opportunity_TGP__c and Enterprise_Solution_Architect_New__c =:ccatRecord.Opportunity_Solution_Lead_New__c and Client_Name__c=: ccatRecord.Client_Name_Master__c];
                if(opportunityList.size()>0) 
                    {
                      newOpp1 =opportunityList[0];
                      List<User> ta=[select id, name from User where id=:ccatRecord.Opportunity_Solution_Lead_New__r.SFDC_User__c];
              
                      if(ta.size()>0)
                      {
                          sendEmailAlertToAssignedUser('Lead Solution Architect – BPO', ta[0].id, ta[0].name);
                      }
             
                    }               
            
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Opportunity successfully added'));
        }
        catch(Exception ex)
        { 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving record'));
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
            return;    
        }
        ccatRecord=new Opportunity_Solution_Lead_Task__c();
        return;
    }
 /******************************
    Method Name: getUserEmailAddress
    Description: To retrieve Email Addresses of Assigned User
    Paramenters: NA
    Return Value: List<String>
    *******************************/  
    public static List<String> getUserEmailAddress(String userName)
    {
        List<String> emailAddress=new List<String>();
        String id; 
        
        User[] usr = [SELECT email FROM user WHERE id=:userName];    
        emailAddress.add(usr[0].email);    
        return emailAddress; 
    }
     /********************************
    Method Name: sendEmailAlertToAssignedUser
    Description: Method for sending the email Alerts-Form the message object
    Paramenters: NA
    Return Value: void
    *******************************/
     public void sendEmailAlertToAssignedUser(String userType, String userID, String userName)
    {        
        try
        {            
            OrgWideEmailAddress[] owea=new OrgWideEmailAddress[] {};
            List<Organization_wide_Email_Address__c> lstIdForOWA =[select id, OWA_id__c from Organization_wide_Email_Address__c];
            if(lstIdForOWA.size()>0)
            {
                owea = [select Id,Address from OrgWideEmailAddress where id=:lstIdForOWA[0].OWA_id__c ];
            }

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if ( owea.size() > 0 ) 
            {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }

            mail.setToAddresses(getUserEmailAddress(userID));
            //mail.setSenderDisplayName('BPO Solution Workbench ');    
            String subject='NOTIFICATION: '+checkNullValues(userName)+' assigned as Lead Solution Architect – BPO - Client Name: '+checkNullValues(newOpp1.Client_Name__r.name)+' - Opportunity Name: ' +checkNullValues(newOpp1.name);
            mail.setSubject(subject);    
        
            mail.setHtmlBody
            (
                '<html>' +
                '    <body>' +
                '   <STYLE type="text/css">' +
               
                '</STYLE>' +
               '<font face="Calibri (Body)" style="font-size:11pt" >'+
                'An Lead Solution Architect – BPO has been assigned to the following Opportunity:</p>' +
                 '</font>'+
        '<hr/>' +
                '<table border="1" rules="rows" width="60%" cellpadding="5">' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Name:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(newOpp1.Client_Name__r.name)+'</font>'+''+'</td>' + 
               // '<td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="verdana" size="2" >Client name:</font></b></td><td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+''+'<p><font face="verdana"  size="2">'+checkNullValues(newOpp1.Client_Name__r.name)+'</font>'+''+'</td>'+
                '</tr>' +
        
                '<tr height="20">  ' +
               '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Opportunity Name:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(newOpp1.name)+'</font>'+''+'</td>' + 
               //'<td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="verdana" size="2" >Opportunity name:</font></b></td><td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+''+'<p><font face="verdana" size="2">'+checkNullValues(newOpp1.name)+'</font>'+''+'</td>'+
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Opportunity ID:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(newOpp1.SAP_OM_Opportunity__r.name)+'</font>'+''+'</td>' + 
                //'<td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="verdana" size="2" >Opportunity ID:</font></b></td><td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+''+'<p><font face="verdana"  size="2">'+checkNullValues(newOpp1.SAP_OM_Opportunity__r.name)+'</font>'+''+'</td>'+
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Lead Solution Architect – BPO:</font></b></td><td>'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(newOpp1.Enterprise_Solution_Architect_New__r.name)+'</font>'+''+'</td>' + 
                //'<td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="verdana" size="2" >Lead Solution Architect – BPO:</font></b></td><td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+''+'<p><font face="verdana" size="2">'+checkNullValues(newOpp1.Enterprise_Solution_Architect__r.name)+'</font>'+''+'</td>'+
                '</tr>' +
                
                '</table>' +
        
                '<hr/>' +
                 '<font face="Calibri (Body)" style="font-size:11pt" >'+
                '<br/>' +
                '    <a href ="'+strUrl+'/'+checkNullValues(newOpp1.id)+'" target="_parent">Login to BPO Solution Workbench</a>' + '<a>(option for those who have a workbench license)</a>' +
                '    <p>This is a system generated message. Please do not reply to this message.</p>' +
                '</font>'+
                '</body>' +
                '</html>'
            );
            mail.saveAsActivity=false;  
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
            
        }
        catch(System.EmailException ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in sending mail'));
            return;
        }
    }
     /******************************
        Method Name: findUserName
        Description: Method to get the username for user ID.
        Paramenters: NA
        Return Value: void
        *******************************/
        public String checkNullValues(String value)
        {
            if(value==null)
                return '  ';
            else
                return value;
            
        }
        
  // use apex describe to build the Staffing Status picklist values
  public List<String> statusStaffing{
    get {
      if (statusStaffing == null) {
 
        statusStaffing = new List<String>();
        Schema.DescribeFieldResult field = Opportunity_Solution_Lead_Task__c.Staffing_Status__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          statusStaffing.add(f.getLabel());
 
      }
      return statusStaffing;          
    }
    set;
  }
  public List<SelectOption> getstatusOptionsNew() {
      List<selectOption> dislpayPicklistValues = new List<selectOption>();
      dislpayPicklistValues  = PicklistValues(ss,'Staffing_Status__c');
      return dislpayPicklistValues; 
  }
  
  public list<SelectOption> PicklistValues(SObject obj, String fld){
  list<SelectOption> options = new list<SelectOption>();
  // Get the object type of the SObject.
  Schema.sObjectType objType = obj.getSObjectType(); 
  // Describe the SObject using its object type.
  Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
  // Get a map of fields for the SObject
  map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
  // Get the list of picklist values for this field.
  list<Schema.PicklistEntry> values =
     fieldMap.get(fld).getDescribe().getPickListValues();
  // Add these values to the selectoption list.
  for (Schema.PicklistEntry a : values)
  { 
     options.add(new SelectOption(a.getLabel(), a.getValue())); 
  }
  return options;
 }
 
  }