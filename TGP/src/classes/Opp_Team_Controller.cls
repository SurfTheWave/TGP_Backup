public with sharing class Opp_Team_Controller {

    public List<Opportunity_Team__c> listOppTeam{get;set;}
    public List<Opportunity_Team_SAP__c> listOppSapTeam{get;set;}
    public Opportunity_Team__c oppTeam{get;set;}
    public Opportunity_Team_SAP__c oppSapTeam{get;set;}
    public String newid{get;set;}
    public Boolean flagEdit{get;set;}
    public Boolean saveEditButtonRender {get; set;}
    public Boolean checkSapOm {get;set;}
    public Boolean flag{get;set;}
    public String tabFocusTemp{get;set;}
    public String tabFocus{get;set;}
    public static String strUrl{get;set;}
    public Opportunity_TGP__c opportunity1;
    public String fileIdDelete ;
    public static boolean pageMessageRenderOppTeam{get; set;}
    Public Governance_Data__c govLead {get; set;}
    
    public String getFileIdDelete(){
        return fileIdDelete;
    }
    
    public void setFileIdDelete(String fileIdDelete){
        this.fileIdDelete = fileIdDelete;
    }
    
    
    public Opp_Team_Controller(ApexPages.StandardController controller){
        pageMessageRenderOppTeam  = false;
        flag = true;
        flagEdit = false;
        checkSapOm = true;
        saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
        opportunity1=(Opportunity_TGP__c)controller.getRecord();  
        oppTeam = new Opportunity_Team__c();
        if(opportunity1.SAP_OM_Opportunity__r.name != null) {
            checkSapOm = false;
        }
        //Get current page ID.
        newid=ApexPages.CurrentPage().getParameters().get('id');
        tabFocusTemp=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.TAB_FOCUS); //Get current page id.
    
         if(tabFocusTemp==null)
         {
             tabFocus='tabZero';
         }
         else
         {
             tabFocus=tabFocusTemp;
         }
        
        listOppSapTeam = [Select BPO_Opp__c,BPO_Sales_Lead__c,CDTS__c,OG_Sales_Lead__c,Client_Account_Lead__c,Client_QA_Director__c,Delivery_Lead_BPO__c,Global_Client_Account_Lead__c,Managing_Director_MC__c,Mobilization_Lead__c,Opportunity_Contact__c,Opportunity_QA_Director__c,Sales_Origination__c,Sales_Capture_Opp_Director__c,Sales_Capture_OSL__c,Sales_Capture_Other__c,Solution_Arch_BPO__c,Technology_Account_Lead__c from Opportunity_Team_SAP__c where BPO_Opp__c =:  newid];
        system.debug('listOppSapTeam+++' + listOppSapTeam );
        if(listOppSapTeam.size()>0) {
           oppSapTeam = listOppSapTeam[0];  
        }
        else {
            oppSapTeam = new Opportunity_Team_SAP__c();
            oppSapTeam.BPO_Opp__c=newid;
            listOppSapTeam.add(oppSapTeam);
        }
        
        initializeDetailRecords();
        
        if(newid!=null)
        {
            List<Opportunity_TGP__c> lstOpp = [select id, name, Offering_Master__c  from Opportunity_TGP__c where id = : newid];
            String strOppId = lstOpp.get(0).id;
            
        }
        else
        {
            pageMessageRenderOppTeam = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Opportunity_Id_not_valid)); 
        }   
    }
    
    /******************************
    Method Name: initializeDetailRecords
    Description: Added method to initialise all Records.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
     public void initializeDetailRecords() {
        
         listOppTeam = new List<Opportunity_Team__c>();
         //listOppSapTeam = new List<Opportunity_Team_SAP__c>();
              //SOSL for Opp Team and Opp SAP Team Values.
              
                for(Opportunity_Team__c team : [Select BPO_Opportunity__c,Offering__c,Opportunity_Team_Member__c,Roles__c,Offering__r.name,Roles__r.name from Opportunity_Team__c where BPO_Opportunity__c=:newid AND Roles__r.Name != 'Lead Solution Architect – BPO' ORDER BY  Offering__r.Name,Roles__r.Name]) {
                        listOppTeam.add(team);
                }
                system.debug('listOppTeam-----' + listOppTeam);
               /* for(Opportunity_Team_SAP__c sapTeam : [Select BPO_Opp__c,Client_Account_Lead__c,Client_QA_Director__c,Delivery_Lead_BPO__c,Due_Diligence_Lead__c,Global_Client_Account_Lead__c,Managing_Director_MC__c,Mobilization_Lead__c,Opportunity_Contact__c,Opportunity_QA_Director__c,
                                                              Sales_Origination__c,Sales_Capture_Opp_Director__c,Sales_Capture_OSL__c,Sales_Capture_Other__c,Solution_Arch_BPO__c,Technology_Account_Lead__c from Opportunity_Team_SAP__c where BPO_Opp__c=:newid]) {
                        listOppSapTeam.add(sapTeam);
                }
                
                System.debug('++++'+listOppSapTeam);*/
    }
    //End
    
    public List<selectOption> getOfferings() {
  
      //new list for holding all of the picklist options
      List<selectOption> options = new List<selectOption>(); 
 
      //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
      options.add(new selectOption('', 'All')); 
  
  //query for User records with allowed profile
      for (Opportunity_Offering__c off :[SELECT Offering_Master__c, Offering_Master__r.Name FROM Opportunity_Offering__c WHERE Opportunity_TGP__c =: opportunity1.Id ORDER BY Offering_Master__r.Name])
      { 
        //for all records found - add them to the picklist options
        options.add(new selectOption(off.Offering_Master__c, off.Offering_Master__r.Name)); 
        }
 
        //return the picklist options
        return options; 
     }
     
     
     public List<selectOption> getRoles() {
  
      //new list for holding all of the picklist options
      List<selectOption> options = new List<selectOption>(); 
      //query for User records with allowed profile
      if(oppTeam.Offering__c == null) {
      
          for (Opportunity_Role_master__c oppRole :[SELECT Id, Name FROM Opportunity_Role_master__c where (Is_Offering_Based__c = false OR Is_Opportunity_Based__c = True) AND Active__c = true ORDER BY Name])
          { 
            //for all records found - add them to the picklist options
            options.add(new selectOption(oppRole.Id, oppRole.Name)); 
          }
      }
      else if(oppTeam.Offering__c != null) {
        for (Opportunity_Role_master__c oppRole :[SELECT Id, Name FROM Opportunity_Role_master__c where Active__c = true AND Is_Opportunity_Based__c = False ORDER BY Name])
          { 
            //for all records found - add them to the picklist options
            options.add(new selectOption(oppRole.Id, oppRole.Name)); 
          }  
      }
 
        //return the picklist options
        return options; 
     }
    
     /******************************
    Method Name: addComments
    Description: To add records in Comments detail
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public PageReference addOppTeam() {
        oppTeam.BPO_Opportunity__c=newid;
        System.debug('++++'+oppTeam.Offering__c);
        System.debug('++++'+oppTeam.Roles__c);
        String temp;
        String temp1;
        String temp2;
        
        for (Opportunity_Role_master__c oppRole :[SELECT Id, Name FROM Opportunity_Role_master__c where Active__c = true]){
            if(oppRole.Id == oppTeam.Roles__c) {
                temp = oppRole.Name;
            }
        }
        
        for (Opportunity_Offering__c oppOffering :[SELECT Offering_Master__c, Offering_Master__r.Name FROM Opportunity_Offering__c WHERE Opportunity_TGP__c =: opportunity1.Id]){
            if(oppOffering.Offering_Master__c == oppTeam.Offering__c) {
                temp1 = oppOffering.Offering_Master__r.Name;
            }
        }
        
        System.debug('++++'+temp);
        // temp2 = oppTeam.Opportunity_Team_Member__r.SFDC_User__c;
        List<Review_User_Master__c> listUserMaster = new List<Review_User_Master__c>();
        listUserMaster  = [select SFDC_User__c from Review_User_Master__c where Id =:oppTeam.Opportunity_Team_Member__c]; 
        if(listUserMaster != null && listUserMaster.Size()> 0) {
            temp2  = listUserMaster[0].SFDC_User__c;   
        }
        system.debug('++++4'+temp2);
        /*if(oppTeam.Offering__c == null && (temp == 'Solution Architect – BPO')) {
            pageMessageRenderOppTeam = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Solution Architect – BPO, it would be mandatory to select offering other than “All”'));
            return null;
        }*/
        if(oppTeam.Opportunity_Team_Member__c == null) {
            pageMessageRenderOppTeam = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Opportunity Team Member: You must enter a value'));
             return null;
        }
        
        for(Opportunity_Team__c opp : listOppTeam) {
            if(oppTeam.Offering__c == opp.Offering__c && oppTeam.Roles__c == opp.Roles__c) {
                pageMessageRenderOppTeam = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Same Record cannot be added twice'));
                return null;
            }
        }
        
        /*for(Opportunity_Team__c opp : listOppTeam){
        if(opp.Offering__r.Name == null  &&  (opp.Roles__r.Name =='Solution Architect – BPO')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Solution Architect – BPO, it would be mandatory to select offering other than “All”'));
        }
        }*/
            try{
                Database.insert(oppTeam);

                 String oppId=oppTeam.BPO_Opportunity__c;
                 String roleName=temp;
             
                 String toAddressId=temp2;
                 
                 String offName=temp1;
                 
                 System.debug('++++1'+oppId);
                 System.debug('++++2'+roleName);
                 System.debug('++++3'+toAddressId);
                  // Added for Governance data- sd governance lead.
                List<Opportunity_Team__c> lstOppTeam = [select Opportunity_Team_Member__r.SFDC_User__c,Active__c,BPO_Opportunity__c, Offering__c,Opportunity_Team_Member__r.name,Roles__c,Roles__r.Name from Opportunity_Team__c where BPO_Opportunity__c =:opportunity1.Id  and roles__r.name = 'SD Governance Lead/coach' limit 2];
                
                String teamMember ;
                if(lstOppTeam.size()>0){
                    for(Opportunity_Team__c team:lstOppTeam){
                        teamMember = team.Opportunity_Team_Member__r.name;
                    }
                }  system.debug('teamMember::'+teamMember);             
                govLead = [select id,Opportunity_TGP__c,SD_Governance_Lead_Coach__c from Governance_Data__c where Opportunity_TGP__c=:opportunity1.Id ];
                
               String SDGovLeadConst='SD Governance Lead/Coach';
               //Opportunity_Role_master__c oppRoleSDGov= [select id from Opportunity_Role_master__c where name=:SDGovLeadConst];
                
                if(String.isBlank(govLead.SD_Governance_Lead_Coach__c)&& roleName==SDGovLeadConst){
                    govLead.SD_Governance_Lead_Coach__c = teamMember;
                    pageMessageRenderOppTeam = true;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.msg_for_team_member));
                }else{
                     pageMessageRenderOppTeam = true;
                     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Added_Successfully));
                }
                
                Database.update(govLead);
                // End for Governance data- sd governance lead.
                 
             sendEmailAlertToAssignedUser(oppId, roleName, toAddressId, offName);  
            }
            catch(exception ex){
                pageMessageRenderOppTeam = true;
                system.debug('exception in adding team member--->>>>'+ex.getMessage());
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_Loading_page));
                return null;
            }
            finally{
                oppTeam = new Opportunity_Team__c();
            }
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
        //Iterate through Comments
        List<Solution_User_Assignment__c> solUserAssignList = new List<Solution_User_Assignment__c>();
        List<Opportunity_Team__c> lstTeamDelete = [Select BPO_Opportunity__c,Offering__c,Opportunity_Team_Member__c,Roles__c,Roles__r.Name from Opportunity_Team__c where BPO_Opportunity__c=:newid and id=:fileIdDelete];
        if(lstTeamDelete.size()>0) {
            List<Solution_User_Assignment__c> solUserAssignList1=[Select Offering_Master__c,Date_Needed_by__c,Resource_Assigned_User_New__c,Resource_Assigned_User_New__r.SFDC_User__c,Status__c, User__c,Requester_Name__c, SAP_OM_ID__c,Date_Assigned__c ,Date_Requested__c , ClientName__c, Id, BPO_Opportunity__c,Role__c From Solution_User_Assignment__c where BPO_Opportunity__c  =: lstTeamDelete[0].BPO_Opportunity__c ];
            if(solUserAssignList1.size()>0) {
                for(Solution_User_Assignment__c tempSol : solUserAssignList1) {
                    if(tempSol.Offering_Master__c == null && lstTeamDelete[0].Offering__c == null) {
                        if(lstTeamDelete[0].Roles__r.Name == 'Complex Cost Architect' && tempSol.Role__c == 'Complex Cost Architect') {
                            tempSol.Status__c = 'New';
                            tempSol.Resource_Assigned_User_New__c = null;
                            tempSol.Requester_Name__c = null;
                            tempSol.Date_Assigned__c = null;
                            tempSol.Date_Requested__c = null;
                            tempSol.Date_Needed_by__c = null;
                            
                            solUserAssignList.add(tempSol);
                            
                            break;
                        }
                        else if(lstTeamDelete[0].Roles__r.Name == 'Mobilization Architect' && tempSol.Role__c == 'Mobilization Architect'
                                || lstTeamDelete[0].Roles__r.Name == 'Technical Architect' && tempSol.Role__c == 'Technical Architect'
                                || lstTeamDelete[0].Roles__r.Name == 'Solution Specialist' && tempSol.Role__c == 'Solution Specialist') {
                                    Database.delete(tempSol);
                                    
                                    break;
                        }
                    }
                    else if(tempSol.Offering_Master__c != null && lstTeamDelete[0].Offering__c != null) {
                        if(lstTeamDelete[0].Roles__r.Name != 'Complex Cost Architect' && tempSol.Role__c != 'Complex Cost Architect') {
                            tempSol.Status__c = 'New';
                            tempSol.Resource_Assigned_User_New__c = null;
                            tempSol.Requester_Name__c = null;
                            tempSol.Date_Assigned__c = null;
                            tempSol.Date_Requested__c = null;
                            tempSol.Date_Needed_by__c = null;
                            
                            solUserAssignList.add(tempSol);
                            
                            break;
                       }
                        else if(lstTeamDelete[0].Roles__r.Name == 'Complex Cost Architect' && tempSol.Role__c == 'Complex Cost Architect') {
                        Database.delete(tempSol);
                        
                        break;
                        }
                    }
                }
            }
                
            Database.update(solUserAssignList);
            govLead = [select id,Opportunity_TGP__c from Governance_Data__c where Opportunity_TGP__c=:opportunity1.Id ];                    
            for(Opportunity_Team__c team : lstTeamDelete)
            {
                if(team.Roles__r.Name.equalsIgnoreCase('SD Governance Lead/Coach')){
                    govLead.SD_Governance_Lead_Coach__c = '';                           
                    Database.update(govLead);
                    pageMessageRenderOppTeam = true;  
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Delete_msg_for_team_mem));
                }else{
                    pageMessageRenderOppTeam = true;  
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_deleted_successfully));
                }
                //To override file from Opportunity_Team__c.
                Database.delete(team);           
            }
        } 
        
        initializeDetailRecords();        
        return null;
    }
    
     /******************************
    Method Name: Edit
    Description: To Edit Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void edit()
    {
        //flag = false;
        //flagEdit = true;
         
        flag = false;
        flagEdit = true;
        
    }
    
    /******************************
    Method Name: pagerefresh
    Description: Refresh othercharacteristics
    Paramenters: NA
    Return Value: NA
    *******************************/  

    public PageReference pagerefresh(){
                PageReference pg=new PageReference('/apex/BPO_Opportunity_tab?id='+newid+'&Count=1&tabFocus=tab1&isVisible=true');
               
                pg.SetRedirect(true);
                tabFocus= 'tab1';
                return pg;
    }
    
    public List<selectOption> getlocations() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('',''));
        for (Delievery_Location_Master__c loc : [SELECT Id, Name, Active__c FROM Delievery_Location_Master__c  WHERE Active__c =: true ORDER BY Name]) { 
            options.add(new selectOption(loc.Name, loc.Name));
        }
        
        return options;
    }
    
    /******************************
    Method Name: saverecord
    Description: To save Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void saverecordForOppTeam()
    {    
        // Validation for none finish       
        try
        {
            /*if(oppSapTeam == null)
            {
               oppSapTeam.BPO_Opp__c=newid;
               Database.insert(oppSapTeam); 
            }
            else {*/
                Database.upsert(listOppSapTeam);
            //}
            if(opportunity1.Enterprise_Solution_Architect_New__c!=null)
            {
            Database.upsert(opportunity1);
            Database.upsert(listOppTeam);
            flag =true;
            flagEdit = false; 
            }
            else{
            pageMessageRenderOppTeam = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Mandatory_fields_cannot_be_blank_in_General_Information_Section_Stage_Activity));
            
            //listopportunity1= new List<Opportunity_TGP__c>();            
            opportunity1=new Opportunity_TGP__c();
            //oppSapTeam=new Opportunity_Team_SAP__c();
            }
            govLead = [select id,Opportunity_TGP__c from Governance_Data__c where Opportunity_TGP__c=:opportunity1.Id ];
            Opportunity_Team__c OppTeam = [select Opportunity_Team_Member__r.SFDC_User__c,Active__c,BPO_Opportunity__c, Offering__c,Opportunity_Team_Member__r.name,Roles__c,Roles__r.Name from Opportunity_Team__c where BPO_Opportunity__c =:opportunity1.Id  and roles__r.name = 'SD Governance Lead/coach' limit 2];
          
            govLead.SD_Governance_Lead_Coach__c = OppTeam.Opportunity_Team_Member__r.name;
            if(OppTeam.roles__r.name.equalsIgnoreCase('SD Governance Lead/coach') && !(OppTeam.Opportunity_Team_Member__r.name).equalsIgnoreCase(system.label.Unassigned)){
                pageMessageRenderOppTeam = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.label.msg_for_team_member));
            }
          
          
           /* for(opportunity_team__c team:listOppTeam){
              if(team.roles__r.name.equals('SD Governance Lead/Coach')){
                 govLead.SD_Governance_Lead_Coach__c = team.Opportunity_Team_Member__r.name;                 
              }
            }*/
            
            Database.update(govLead);
          
        }
        catch(Exception ex)
        {
            if(ex.getMessage().contains(UTIL_Constants.UPDATE_FAILED))
            {
                   pageMessageRenderOppTeam = true;
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.You_do_not_have_permission_to_perform_this_action));
                   return;
            }
        }         
   }
   
       /******************************
    Method Name: sendEmailAlertToAssignedUser
    Description: Method for sending the email Alerts-assigned the message object
    Paramenters: NA
    Return Value: void
    *******************************/
    public static void sendEmailAlertToAssignedUser(String oppId, String roleName, String toAddressId, String offName)
    {
    List<Opportunity_Team__c> oppTeamList=[Select BPO_Opportunity__r.name,BPO_Opportunity__r.Service_Delivery_Locations_Unique__c, BPO_Opportunity__r.Client_Name__r.name,BPO_Opportunity__c,Offering__c,Opportunity_Team_Member__c,Opportunity_Team_Member__r.SFDC_User__c,Roles__c,Offering__r.name,Roles__r.name,BPO_Opportunity__r.SAP_OM_Opportunity__r.name,BPO_Opportunity__r.Enterprise_Solution_Architect_New__c,BPO_Opportunity__r.Stage__c,BPO_Opportunity__r.Expected_contract_sign_qtr__c,BPO_Opportunity__r.TCV__c,BPO_Opportunity__r.Client_Geo_Area__r.name,BPO_Opportunity__r.Client_Geo_Unit__r.name,BPO_Opportunity__r.Operating_Group__r.name,BPO_Opportunity__r.Risk_Level__c,BPO_Opportunity__r.Enterprise_Solution_Architect_New__r.Name from Opportunity_Team__c where  BPO_Opportunity__c =: oppId AND Roles__r.Name =: roleName AND Offering__r.name =: offName limit 5000];
    strUrl = URL.getSalesforceBaseUrl().toExternalForm();
    List<User> usrName = new List<User>();
    usrName = [SELECT name FROM user WHERE id=:toAddressId];
    if(usrName.size()>0) {
    try
        {       
             
                String userName ='';
                userName = checkNullValues(usrName[0].name);
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
                List<String> listOfEmailAddress = getUserEmailAddress(toAddressId);
                mail.setToAddresses(ListOfEmailAddress); 
                  
                String subject='NOTIFICATION:  '+ userName +' '+'assigned as a '+checkNullOffValues(roleName)+' - Client Name: '+checkNullValues(oppTeamList[0].BPO_Opportunity__r.Client_Name__r.name)+' - Opportunity Name: '+checkNullValues(oppTeamList[0].BPO_Opportunity__r.name);
                mail.setSubject(subject);    
           
            mail.setHtmlBody
            (
                '<html>' +
                '    <body>' +
                '   <STYLE type="text/css">' +
                
                '</STYLE>' +
                '<font face="Calibri (Body)" style="font-size:11pt" >'+ '</br>' +
                'You have been assigned as a '+ checkNullOffValues(roleName) +' to the following Opportunity: </p>' +
                 '</font>'+
                '<hr/>' +
                '<table border="1" rules="rows" width="60%" cellpadding="5">' +
               // '<tr height="20">  ' +
               //  '<td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Opportunity ID:</font></b></td><td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(Opportunity_ID__c)+'</font>'+''+'</td>' +
                // '</tr>' +
                 '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Name:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+(oppTeamList[0].BPO_Opportunity__r.Client_Name__r.name)+'</font>'+''+'</td>' + 
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Opportunity Name:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+(oppTeamList[0].BPO_Opportunity__r.name)+'</font>'+''+'</td>' + 
               
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Opportunity ID:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(oppTeamList[0].BPO_Opportunity__r.SAP_OM_Opportunity__r.name)+'</font>'+''+'</td>' + 
                
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Lead Solution Architect – BPO:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+(oppTeamList[0].BPO_Opportunity__r.Enterprise_Solution_Architect_New__r.Name)+'</font>'+''+'</td>' + 
                
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Stage:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+(oppTeamList[0].BPO_Opportunity__r.Stage__c)+'</font>'+''+'</td>' + 
               
                
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Expected Contract Sign (Qtr):</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(oppTeamList[0].BPO_Opportunity__r.Expected_contract_sign_qtr__c)+'</font>'+''+'</td>' + 
               
                '</tr>' +
        
        
                '<tr height="20">  ' +
                 '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">BPO Net Revenue (SAP OM)<br/>(Thousands):</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValuesDeciamlTCV(oppTeamList[0].BPO_Opportunity__r.TCV__c)+'</font>'+''+'</td>' + 
                
                
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Geo Area:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(oppTeamList[0].BPO_Opportunity__r.Client_Geo_Area__r.name)+'</font>'+''+'</td>' + 
                
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Client Geo Unit:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(oppTeamList[0].BPO_Opportunity__r.Client_Geo_Unit__r.name)+'</font>'+''+'</td>' + 
                
                '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Operating Group:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(oppTeamList[0].BPO_Opportunity__r.Operating_Group__r.name)+'</font>'+''+'</td>' + 
               
                '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Offerings:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullOfferingValues(oppTeamList[0].Offering__r.Name, oppId, roleName, offName)+'</font>'+''+'</td>' + 
                
                 '</tr>' +
                
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Delivery Location:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(oppTeamList[0].BPO_Opportunity__r.Service_Delivery_Locations_Unique__c)+'</font>'+''+'</td>' + 
               
                '</tr>' +
                
               // '<tr height="20">  ' +
               // '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Operating Group:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(opportunityList[0].Offerings__c)+'</font>'+''+'</td>' + 
               
               // '</tr>' +
                
              //  '<tr height="20">  ' +
              //  '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Operating Group:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(opportunityList[0].Service_Delivery_Locations_Unique__c)+'</font>'+''+'</td>' + 
               
              //  '</tr>' +
        
                '<tr height="20">  ' +
                '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Risk Level:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(oppTeamList[0].BPO_Opportunity__r.Risk_Level__c)+'</font>'+''+'</td>' + 
                
                '</tr>' +
                
                 //'<tr height="20">  ' +
                //'<td width="25%" style="borde:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Date Requested By:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(dateRequested)+'</font>'+''+'</td>' + 
              
                //'</tr>' +
                
               // '<tr height="20">  ' +
               //'<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Date Needed By:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(dateNeeded)+'</font>'+''+'</td>' + 
               
               // '</tr>' +
        
              //  '<tr height="20">  ' +
               // '<td width="25%" style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt"><b><font face="Calibri (Body)">Comments:</font></b></td><td style="border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt;font-size:11pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+checkNullValues(comment)+'</font>'+''+'</td>' + 
                
              //  '</tr>' +
                
               // '<tr height="20">  ' +
               // '<td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt" >Requestor:</font></b></td><td width="25%" valign="top" style="width:25.64%;border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+''+'<p><font face="Calibri (Body)" style="font-size:11pt">'+offeringRecord.Solution_Lead__r.name+'</font>'+''+'</td>' +
               // '</tr>' +
                
                '</table>' +
        
                '<hr/>' +
                 '<font face="Calibri (Body)" style="font-size:11pt" >'+
                '<br/>' +
                '     <a href ="'+strUrl+'/apex/BPO_Opportunity_tab?id='+oppTeamList[0].BPO_Opportunity__r.id+ '" target="_parent">Login to BPO Solution Workbench</a>' + '<i> (option for those who have a workbench license)</i>' +
                '    <p>For more information please contact Lead Solution Architect – BPO.</p>' +
                '    <p>This is a system generated message. Please do not reply to this message.</p>' +
                '</font>'+
                '</body>' +
                '</html>'
            );
            mail.saveAsActivity=false;  
            //Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            //singleEmails.add(mail);
        }
    
        catch(System.EmailException ex)
        {
            pageMessageRenderOppTeam = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in sending mail!'));
            return;
        }
    }

    }
    
    /******************************
    Method Name: checkNullValues
    Description: Method to get the username for user ID.
    Paramenters: NA
    Return Value: void
    *******************************/
    public static String checkNullValues(String value)
    {
        if(value==null)
            return '  ';
        else
            return value;
        
    }
    
    /******************************
    Method Name: checkNullOffValues
    Description: Method to get the username for user ID.
    Paramenters: NA
    Return Value: void
    *******************************/
    public static String checkNullOffValues(String value)
    {
        if(String.isEmpty(value))
            return 'Lead Solution Architect – BPO';
        else
            return value;
        
    }
    
    /******************************
    Method Name: checkNullValues
    Description: Method to get the username for user ID.
    Paramenters: NA
    Return Value: void
    *******************************/
    public static String checkNullOfferingValues(String value, String oppId, String roleName, String offName)
    {
        System.debug('+++++'+value);
        System.debug('+++++'+oppId);
        List<Opportunity_Team__c> oppTeamList=[Select BPO_Opportunity__r.Offerings__c,BPO_Opportunity__r.name,BPO_Opportunity__r.Client_Name__r.name,BPO_Opportunity__c,Offering__c,Opportunity_Team_Member__c,Opportunity_Team_Member__r.SFDC_User__c,Roles__c,Offering__r.name,Roles__r.name,BPO_Opportunity__r.SAP_OM_Opportunity__r.name,BPO_Opportunity__r.Enterprise_Solution_Architect_New__c,BPO_Opportunity__r.Stage__c,BPO_Opportunity__r.Expected_contract_sign_qtr__c,BPO_Opportunity__r.TCV__c,BPO_Opportunity__r.Client_Geo_Area__r.name,BPO_Opportunity__r.Client_Geo_Unit__r.name,BPO_Opportunity__r.Operating_Group__r.name,BPO_Opportunity__r.Risk_Level__c,BPO_Opportunity__r.Enterprise_Solution_Architect_New__r.Name from Opportunity_Team__c where  BPO_Opportunity__c =: oppId AND Roles__r.Name =: roleName AND Offering__r.name =: offName limit 5000];
        if(value == null && oppTeamList[0].BPO_Opportunity__r.Offerings__c == null) {
                return ' ';
        }
        else if(value == null && oppTeamList[0].BPO_Opportunity__r.Offerings__c != null){
            System.debug('+++++1');
            return oppTeamList[0].BPO_Opportunity__r.Offerings__c;
        }
        else {
        System.debug('+++++2');
            return value;
        }
        
    }
    
    /******************************
    Method Name: checkNullValuesDecimalTCV
    Description: Method to check null and return empty string.
    Paramenters: String
    Return Value: String 
    *******************************/
    public Static String checkNullValuesDeciamlTCV(Decimal value)
    {
        if(value==null)
            return '  ';
        else
            return ''+ '$' +String.ValueOf(value.setScale(0).format());// Code added by Ayush for D - 1791 A
        
    } 
    
     public Static String checkDateNullValues(Date value)
    {
        if(value==null)
            return '  ';
        else
            return ''+value;
        
    }
    
    public static List<String> getUserEmailAddress(String userName)
    {
        List<String> emailAddress=new List<String>();
        String id; 
        User[] usr = [SELECT email FROM user WHERE id=:userName];
        if(usr.size()>0) {  
            emailAddress.add(usr[0].email);   
        } 
        return emailAddress; 
    }
}