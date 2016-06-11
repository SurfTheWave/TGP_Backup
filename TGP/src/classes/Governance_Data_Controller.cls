public class Governance_Data_Controller {
   
    public Governance_Data__c GData = new Governance_Data__c();
    public Opportunity_Team__c Team {get; set;}
    public Governance_Critical_Milestones__c milestoneTable {get; set;}
    public Opportunity_Governance_Mail__c governanceLookup{get; set;}
    public Opportunity_TGP__c opportunity1;
    Public String oppId;
    public String newid {get;set;}
    
  
    public boolean flagEditGovData{get; set;}
    public boolean flagGovData{get; set;}
    
    public boolean flagEditRiskData{get; set;}
    public boolean editPermRisk{get; set;}
   
    public Transient List<Governance_Data__c> listGovData{get; set;}
    public Transient List<Opportunity_Team__c> listOppTeam {get; set;}
    public List<Governance_Critical_Milestones__c> listMilestoneTable {get; set;}
    public List<Governance_Risk_Item__c> listRiskItemDetails{get; set;}
    public Governance_Data__c GovData{get; set;}
    public Governance_Risk_Item__c newRiskSectionItem{get; set;}
    
    public Boolean addButtonRender {get; set;}
    public Boolean deleteButtonRender {get;set;}
    public Boolean addSolutionHeadlinePageMsg {get; set;}
    public Boolean addRiskPageMsg{get; set;}   
    public Boolean addHideRender {get; set;}
    public Boolean refreshPage{get; set;}
    public Boolean editButtonPermission{get; set;}
    
    public String fileIdDelete;
    public String governanceId{get;set;}
   
   
    public List<Opportunity_Team__c> lstOppTeam;
    public boolean displayPopup {get; set;}
    public String emailIds{get;set;}    
    public String strUserId {get;set;}
    public String userProfileName {get;set;}
    public Set<String> permissionSet = new Set<String>();
    public List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
    public Governance_Risk_Item__c riskItem = new Governance_Risk_Item__c();
    public Boolean risk_flag {get;set;}
    public Boolean resources_flag {get;set;}
    public Boolean commercial_flag {get;set;}
    public Boolean schedule_flag {get;set;}
    public Boolean solution_flag {get;set;}
    public Boolean overall_flag {get; set;}
    public Boolean trending_flag{get; set;}
    public Boolean mailMsg {get;set;}
    public integer sNo {get;set;}
    public String strUrl{get;set;}
    public List<CounterWrapper> counterList{get; set;}
          
    //ApexPages.StandardController controller
    public Governance_Data_Controller() {
        oppId = ApexPages.CurrentPage().getParameters().get('id');
        strUrl = URL.getSalesforceBaseUrl().toExternalForm();
        strUserId = UserInfo.getUserId();
        governanceLookup = new Opportunity_Governance_Mail__c();
        newRiskSectionItem = new Governance_Risk_Item__c();
        listMilestoneTable = new List<Governance_Critical_Milestones__c>();      
                     
        listGovData = [select id,Solution_Dependencies__c, TGP__c,MC__c,Other__c,Overall__c,LastModifiedDate,Trending__c,Trending_Image__c,
                       Resources__c,Risk__c,Schedule__c,BPO_Sales_Lead__c,Opportunity_Solution_Lead__c,Solution__c, 
                       Watchlist__c,Commercial__c,client__c,Offerings_Scope__c,Estimate_SD__c,RAG_Status_Solution__c,
                       RAG_Status_Schedule__c,RAG_Status_Risk__c,RAG_Status_Resources__c,RAG_Status_Overall__c,Solution_Headlines__c,
                       RAG_Status_Commercial__c,Opportunity_TGP__r.SAP_OM_Opportunity__r.name,Opportunity_TGP__r.name,
                       Opportunity_TGP__r.Client_Name__r.name,SD_Governance_Lead_Coach__c,LastModDateWithRiskDate__c from Governance_Data__c where Opportunity_TGP__r.id=:oppId limit 1]; //:oppId
        
        listMilestoneTable = [select Actual__c,Complete__c,Governance_Data__c,Milestone__c,SWB_Date__c from Governance_Critical_Milestones__c where Governance_Data__r.Opportunity_TGP__r.id=:oppId limit 7];  
              
        try{
            /*
             * Starts Condition block to check wheather RAG Status and Trending is selected or not.
             *  IF RAG Status images none, then will render 'none'.
             */
                if(listGovData[0].Risk__c == null){
                    risk_flag = true;
                    listGovData[0].Risk__c = '';
                }
                if(listGovData[0].Commercial__c == null){
                    commercial_flag = true;
                    listGovData[0].Commercial__c = '';
                }
                if(listGovData[0].Overall__c == null){
                    overall_flag = true;
                    listGovData[0].Overall__c = '';
                }
                if(listGovData[0].Schedule__c == null){
                    schedule_flag = true;
                    listGovData[0].Schedule__c = '';
                }
                if(listGovData[0].Solution__c == null){
                    solution_flag = true;
                    listGovData[0].Solution__c = '';
                }if(listGovData[0].Resources__c == null){
                    resources_flag = true;
                    listGovData[0].Resources__c = '';
                }
                if(listGovData[0].Trending__c == null || listGovData[0].Trending__c.equalsIgnoreCase('N/A')){
                    trending_flag = true;
                    listGovData[0].Trending__c = 'N/A';
                }
                if(String.isEmpty(listGovData[0].Solution_Headlines__c)){
                    listGovData[0].Solution_Headlines__c = '';
                }else{
                    listGovData[0].Solution_Headlines__c = (listGovData[0].Solution_Headlines__c).replaceAll('\n','\n');
                }
               
                
            /*
             * Ends IF condition for RAG Status and Trending Images.
             */ 
              if(listGovData.size()>0){
                    GData = listGovData[0];
                }
                governanceId=listGovData[0].id;
            }catch(Exception ex){
               // System.debug('Exception::'+ex.getMessage());
               }
               editPermRisk=true;
               
               
               flagGovData = true;
               flagEditGovData = false;   
               deleteButtonRender = true;
               addSolutionHeadlinePageMsg = false;               
               addRiskPageMsg = false;
               addHideRender = true;
               refreshPage = true;
               addButtonRender = true;
               displayPopup = false;
               sNo  = 1;
               detailRecordsOfRiskSection();
       
               
        //BG Code for Edit Permission
        permissionSetList = [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE  AssigneeId  = : userInfo.getUserId()];
        for(PermissionSetAssignment permissionObj : permissionSetList){
            permissionSet.add(permissionObj.PermissionSet.Name);
        }
       
         lstOppTeam = [select Opportunity_Team_Member__r.SFDC_User__c,Active__c,
                                                BPO_Opportunity__c, Offering__c,Opportunity_Team_Member__c,Roles__c 
                                                from Opportunity_Team__c 
                                                where BPO_Opportunity__c =: oppId];        
                                      
          
        userProfileName = [select u.Profile.Name from User u where u.id = :strUserId].Profile.Name;
        if(permissionSet.contains('SA_OU_Lead') || userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) 
           || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN) 
           || userProfileName.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN)){
                editButtonPermission = true;
            }
            else {
                for(Opportunity_Team__c o : lstOppTeam){
                        if(o.Opportunity_Team_Member__r.SFDC_User__c == Userinfo.getUserId()){
                            editButtonPermission = true;
                        }
                }
            }
//BG Code Ends
       }
    public String getFileIdDelete(){
        return fileIdDelete;
    }
    
    public void setFileIdDelete(String fileIdDelete){
        this.fileIdDelete = fileIdDelete;
    }
    public Governance_Data__c  getGData(){
        return GData;        
    }
 
    public Governance_Risk_Item__c getriskItem(){
        return riskItem;
    }
        
    public void editForGovData(){
        flagGovData = false;             
        flagEditGovData = true;
        editButtonPermission = true; 
        displayPopup = false;
    }
    public void emailForGovData(){       
        flagGovData = true;             
        flagEditGovData = false;
        editButtonPermission = true;
        displayPopup = true;        
    }
    
    /******************************
    Method Name: sendMail
    Description: Send button For Email popup
    Paramenters: NA
    Return Value: PageReference
    *******************************/
    public pagereference sendMail(){
        
        pagereference pr;
        List<Review_User_Master__c> user1 ;
        List<Review_User_Master__c> user2;
        emailIds ='';
        if(governanceLookup.User_1__c != null){
            user1 = [select id,Email_ID_of_the_reviewer__c, name from Review_User_Master__c where id=:governanceLookup.User_1__c limit 1];
            emailIds += user1[0].Email_ID_of_the_reviewer__c+';';
        }
        if(governanceLookup.User_2__c != null){
            user2 = [select id,Email_ID_of_the_reviewer__c, name from Review_User_Master__c where id=:governanceLookup.User_2__c limit 1];
            emailIds += user2[0].Email_ID_of_the_reviewer__c+';';
        }
        system.debug('email id of selected user1 and user2::'+emailIds);
        if(String.isBlank(emailIds)){
            mailMsg = true;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select user.' );
                ApexPages.addMessage(msg);
            system.debug('msg::'+msg);
            pr = new pagereference('/apex/Governance_Data_Page?id='+oppId);
            displayPopup = true;
            return pr;
        }
        String[] mailIds = emailIds.split(';'); 
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
         
      //  EmailTemplate templateId = [Select id from EmailTemplate where name = 'GovernanceEmailTemplate'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(owa.id);    
            mail.setToAddresses(mailIds);          
            mail.setSubject('NOTIFICATION:  Governance Summary - Client Name: '+GData.Opportunity_TGP__r.Client_Name__r.name+' - Opportunity Name: '+GData.Opportunity_TGP__r.Name);
      
            String body;
            String solHeadLines;
           if(governanceLookup.Mail_Message__c == null){
                body = '';
            }else{
                 body = (governanceLookup.Mail_Message__c).replaceAll('\n','<br/>');
            }if(GData.Solution_Headlines__c == null){
                solHeadLines ='';
            }else{
                    solHeadLines = (GData.Solution_Headlines__c).replaceAll('\n','<br/>');
            }
        
            //mail.setPlainTextBody(mailBody);  
            String str1  = '<html><p><font face="Calibri (Body)" style="font-size:11pt" >'+body+'</font></p><style type="text/css">'+
                             '.style1 {color: #00FF99;background: #00CCFF; width:868px;}'+
                             '.style2 {color: #000000;font-weight: bold;width:868px;}'+
                             '.style3{color:#000000;font-weight: bold; font-size: medium;width:868px; }'+
                             '</style></head>'+
                             '<body><div class="style1"></p></div><br/>'+
                             '<div class="style1"><p class="style2">General Information</p></div>'+
                             '<table rules="rows" border="1" cellpadding="5"><tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">SAP OM ID</font></b></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+checkNullStrings(GData.Opportunity_TGP__r.SAP_OM_Opportunity__r.name)+'</font></td></tr>'+
                             '<tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Opportunity Name</font></b></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+GData.Opportunity_TGP__r.Name+'</font></td></tr>'+
                             '<tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Client Name</font></b></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+GData.Opportunity_TGP__r.Client_Name__r.name+'</font></td></tr>'+
                             '<tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Last Modified Date</font></b></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+GData.LastModifiedDate+'</font></td></tr>'+
                             '<tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">BPO Sales Lead</font></b></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+checkNullStrings(GData.BPO_Sales_Lead__c)+'</font></td></tr>'+
                             '<tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">SD Governance Lead/Coach</font></b></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+checkNullStrings(GData.SD_Governance_Lead_Coach__c)+'</font></td></tr>'+
                             '<tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Lead Solution Architect – BPO</font></b></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+checkNullStrings(GData.Opportunity_Solution_Lead__c)+'</font></td></tr>'+
                             '<tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Offering  Scope (SWB)</font></b></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+checkNullStrings(GData.Offerings_Scope__c)+'</font></td></tr>'+
                             '<tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b>BPO Net Revenue  (SD Estimates)<br /> (Thousands) </b></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+checkNullValuesDeciamlTCV(GData.Estimate_SD__c) +'</td></tr></table>'+
                             '<div class="style1"><p class="style2">Solution Headline </p></div>'+
                             '<table rules="rows" width="100%" border="1" cellpadding="5"><tr>'+
                             '<td width="242" align="Justify" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt">'+solHeadLines+'</font></p></td></tr>';
                             
                /*'<td width="271" bordercolor="#CCCCCC" bgcolor="#CCCCCC"><strong> Created Date</strong></td>'+
                             '<td width="339" nowrap="nowrap" bordercolor="#CCCCCC" bgcolor="#CCCCCC"><strong>Created  By</strong></td></tr>';  
*/
        /*
         *  IF Starts For RAG Status images in email template.
         */
        String risk='';
        String overall='';
        String solution='';
        String shcedule='';
        String commercial='';
        String resource='';
         //Risk
       if(GData.Risk__c.equals('Green')){
          risk = '<table><tr><td bgcolor="#00FF00" width="30"height="20"></td></tr></table>';
        }
        if(GData.Risk__c.equals('Red')){
            risk = '<table><tr><td bgcolor="red" width="30" height="20"></td></tr></table>';
        }
        if(GData.Risk__c.equals('Amber')){
             risk = '<table><tr><td bgcolor="#FFBF00" width="30" height="20"></td></tr></table>';
        }
        // Resource
        if(GData.Resources__c.equals('Green')){
             resource =  '<table><tr><td bgcolor="#00FF00" width="30"height="20"></td></tr></table>';
        }
        if(GData.Resources__c.equals('Red')){
             resource =  '<table><tr><td bgcolor="red" width="30" height="20"></td></tr></table>';
        }
        if(GData.Resources__c.equals('Amber')){          
            resource = '<table><tr><td bgcolor="#FFBF00" width="30" height="20"></td></tr></table>'; 
        }
        
        //Schedule
        
        if(GData.schedule__c.equals('Green')){
            shcedule = '<table><tr><td bgcolor="#00FF00" width="30"height="20"></td></tr></table>';
        }
        if(GData.schedule__c.equals('Red')){
            shcedule = '<table><tr><td bgcolor="red" width="30"height="20"></td></tr></table>';
        }
        if(GData.schedule__c.equals('Amber')){
            shcedule = '<table><tr><td bgcolor="#FFBF00" width="30" height="20"></td></tr></table>';
        }
        //Solution
       
        if(GData.Solution__c.equals('Green')){
            solution = '<table><tr><td bgcolor="#00FF00" width="30"height="20"></td></tr></table>';
        }
        if(GData.Solution__c.equals('Red')){
            solution = '<table><tr><td bgcolor="red" width="30"height="20"></td></tr></table>';
        }
        if(GData.Solution__c.equals('Amber')){
            solution = '<table><tr><td bgcolor="#FFBF00" width="30" height="20"></td></tr></table>';
        }
        // Commercial
        if(GData.Commercial__c.equals('Green')){
            commercial = '<table><tr><td bgcolor="#00FF00" width="30"height="20"></td></tr></table>';
        }
        if(GData.Commercial__c.equals('Red')){
            commercial = '<table><tr><td bgcolor="red" width="30"height="20"></td></tr></table>';
        }
        if(GData.Commercial__c.equals('Amber')){
            commercial = '<table><tr><td bgcolor="#FFBF00" width="30" height="20"></td></tr></table>';
        }
        
        //Overall
        
        if(GData.Overall__c.equals('Green')){
            overall = '<table><tr><td bgcolor="#00FF00" width="30"height="20"></td></tr></table>';
        }
        if(GData.Overall__c.equals('Red')){
            overall = '<table><tr><td bgcolor="red" width="30"height="20"></td></tr></table>';
        }
        if(GData.Overall__c.equals('Amber')){
           overall = '<table><tr><td bgcolor="#FFBF00" width="30" height="20"></td></tr></table>';
        }
        if(GData.Trending__c.equalsIgnoreCase('Up')){
            GData.Trending__c = '<html><strong>&#x2191;</strong></html>';           
        }else if(GData.Trending__c.equalsIgnoreCase('down')){  
            GData.Trending__c = '<html><strong>&#x2193;</strong></html>'; 
        }else if(GData.Trending__c.equalsIgnoreCase('No Change')){
            GData.Trending__c = '<html><strong>&#x2192;</strong></html>'; 
        }

        /*
         *  IF ends For RAG Status images in email template.
         */
           
            String str2 =    '</table><div class="style1"><p class="style2">Status</p></div>'+
                             '<table rules="rows" width="600" border="1" cellpadding="5" ><tr>'+
                             '<td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Watchlist</font> </b> </td> &nbsp;'+
                             '<td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt"> '+GData.Watchlist__c+'</font></td>'+
                             '<td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Commercial </font></b></td> &nbsp;'+
                             '<td width="250" position="relative" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> '+commercial+' </td></tr>'+
                             '<tr><td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Trending</font> </b></td> &nbsp;'+
                             '<td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> '+GData.Trending__c+'</td>'+
                             '<td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Solution</font> </b></td> &nbsp;'+
                             '<td width="250" position="relative" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> '+solution+' </td></tr>'+
                             '<tr><td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Over All </font> </b></td> &nbsp;'+
                             '<td width="250" position="relative" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> '+overall+'</td>'+
                             '<td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Resources </font></b></td> &nbsp;'+
                             '<td width="250" position="relative" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> '+resource+' </td></tr>'+
                             '<tr><td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Schedule </font></b></td> &nbsp;'+
                             '<td width="250" position="relative" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> '+shcedule+'</td>'+
                             '<td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Risk</font> </b></td> &nbsp;'+
                             '<td position="relative">'+risk+'</td></tr></table>'+
                             '<div class="style1"><p class="style2">Risk and Action Log </p></div>'+
                             '<table rules="rows" width="700" border="1" align="left" cellpadding="5">'+
                             ' <tr><td width="72" valign="top" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt" ><b><font face="Calibri (Body)" style="font-size:11pt">Number</font></b></td>'+
                             '<td width="198" valign="top" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><b><font face="Calibri (Body)" style="font-size:11pt">Risk</font></b></p></td>'+
                             '<td width="160" valign="top" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><b><font face="Calibri (Body)" style="font-size:11pt">Mitigation Plan</font></b></p></td>'+
                             '<td width="178" valign="top" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><b><font face="Calibri (Body)" style="font-size:11pt">Completion Date</font></b></p></td>'+
                             '<td width="93" valign="top" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><b><font face="Calibri (Body)" style="font-size:11pt">Status</font></b></p></td></tr>';
            
            String dep =     '</table><p></p> <br clear="all" /> <div class="style1"><p class="style3"><strong>Dependencies</strong></p></div>'+
                             '<table rules="rows" width="560" border="1" cellpadding="5"><tr><td width="290" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b>Solution Dependencies </b></td> &nbsp;'+
                             '<td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> '+checkNullStrings(GData.Solution_Dependencies__c)+' </td>'+
                             '<td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Client</font> </b></td> &nbsp;'+
                             '<td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt"> '+checkNullStrings(GData.Client__c)+'</font> </td></tr>'+
                             '<tr><td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">TGP </font></b></td> &nbsp;'+
                             '<td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt"> '+checkNullStrings(GData.TGP__c)+'</font> </td>'+
                             '<td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b>Other </b></td> &nbsp;'+
                             '<td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt"> '+checkNullStrings(GData.Other__c)+'</font> </td></tr>'+
                             '<tr><td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">MC </font></b></td> &nbsp;'+
                             '<td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt"> '+checkNullStrings(GData.MC__c)+'</font> </td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"></td></tr></table>';
           String str3 = '';
            
           String str4 = '';
         integer counter=1;
        for(CounterWrapper riskItem:counterList){ 
           str4+= '<tr><td width="72" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt">'+riskItem.counter+'</font></p></td>'+
                  '<td width="198" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt">'+riskItem.item.Risk__c+'</font></p></td>'+
                  '<td width="160" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt">'+riskItem.item.Mitigation_Plan__c+'</font></p></td>'+
                  '<td width="178" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt">'+(riskItem.item.Completion_Date__c).format()+'</font></p></td>'+
                  '<td width="63" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt">'+riskItem.item.Status__c+'</font></p></td></tr>';
            counter++;
            } 
         String msTable = ''; 
        if(listMilestoneTable.size()!=0){
            msTable+= '<div class="style1"><p class="style2"><strong>Critical Milestone</strong></p></div>'+
                             '<table rules="rows" width="721" border="1" align="left" cellpadding="5" >'+
                             '<tr style="height:60px;padding:1px;"><td width="423" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><strong><font face="Calibri (Body)" style="font-size:11pt">Milestone</font></strong> </td>'+
                             '<td width="118" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><strong><font face="Calibri (Body)" style="font-size:11pt">SWB Date</font></strong></td>'+
                             '<td width="98" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><strong><font face="Calibri (Body)" style="font-size:11pt">Complete</font></strong></td>'+
                             '<td width="92" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><strong><font face="Calibri (Body)" style="font-size:11pt">Actual&nbsp; </font></strong></td>'+
                             '</tr>';
            for(Governance_Critical_Milestones__c milestone:listMilestoneTable){
                String actualDate=String.valueOf( milestone.Actual__c);
                String swbDate=String.valueOf(milestone.SWB_Date__c);
                
                if(actualDate == null){
                    actualDate=' ';                    
                }else{
                    actualDate = milestone.Actual__c.format();
                }
                if(swbDate == null){
                    swbDate = ' ';
                }else{
                    swbDate  = milestone.SWB_Date__c.format();
                }
                if(milestone.Complete__c == null){
                    milestone.Complete__c = ' ';
                }
                 msTable += '<tr><td width="403" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt">'+milestone.Milestone__c+'</font></p></td>'+
                          '<td width="118" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt" ><font face="Calibri (Body)" style="font-size:11pt">'+swbDate+ 
                          '</font></td><td width="98" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+milestone.Complete__c+
                          '</font></td><td width="92" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+actualDate+
                          '</font></td></tr>';
            }
        }
         String str6 = '</table><p>&nbsp;</p><p></p> <br clear="all" /><p align="left"><font face="Calibri (Body)" style="font-size:11pt"><a href="'+strUrl+'/apex/Governance_Data_page?id='+oppId+'" target="_parent">Login to BPO  Solution Workbench</a> '+
                '(option for those who have a workbench license) <br clear="all"/><br/>This is a system generated message. '+
                'Please do not reply to  this message.</font></p></body></html>';
        
        mail.setHtmlBody(str1+str3+str2+str4+dep+msTable+str6);
            
       // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        
         /**
            mail.setTemplateID(templateId.Id);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setOrgWideEmailAddressId(owa.id); 
            mail.setTargetObjectId('005c0000001IkAw');
            mail.setWhatId('a1Gc00000057EJF');         
            mail.setSaveAsActivity(false);  //false
            allmsg.add(mail);
            Messaging.sendEmail(allmsg,false);
            */ 
        try{
            Messaging.SendEmailResult [] res = Messaging.SendEmail(new Messaging.SingleEmailMessage[] {mail});
        
            for ( Messaging.sendEmailResult result : res ) {
                system.debug('mail result;;:::'+res);
                   if ( !res[0].isSuccess () ) {
                       System.debug ('email sent result@'+ result  );
                   }
                   else{
                       ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Email Sent Successfully' );
                       //ApexPages.addMessage(msg);
                       system.debug('msg after sending the mail::'+msg+'  result@@'+result);
                   }
               }  
            governanceLookup.Governance_data__c = GData.Id;
            insert governanceLookup;
            
        }   catch(Exception e){
            system.debug('Exception in send mail::@@::'+e.getMessage());
        }     
        pagereference pt=new pagereference('/apex/Governance_Data_Page?id='+oppId);
        displayPopup = false;
        flagGovData = true;             
        flagEditGovData = false;
        editButtonPermission = true;
          return pt;
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
            return ''+ '$' +String.ValueOf(value.setScale(0).format());
        
    } 
     /******************************
    Method Name: checkNullStrings
    Description: Method to check null and return empty string.
    Paramenters: String
    Return Value: String 
    *******************************/
    public static String checkNullStrings(String value){
        if(value == null)
            return ' ';
        else
            return value;
    }
    /******************************
    Method Name: cancelMail
    Description: Cancel button For Email popup
    Paramenters: NA
    Return Value: PageReference
    *******************************/
    public pagereference cancelMail(){
        pagereference pt=new pagereference('/apex/Governance_Data_Page?id='+oppId);
        displayPopup = false;
        flagGovData = true;             
        flagEditGovData = false;
        editButtonPermission = true;
        return pt;
    }
    
    public pagereference saveGovData(){
        try{
            
            upsert GData;
            upsert listMilestoneTable;
        }catch(Exception e){
           // system.debug('upsert error::'+e.getMessage());
        }
        flagGovData = true;
        flagEditGovData = false;
        editButtonPermission = true; 
        pagereference pr = new pagereference('/apex/Governance_Data_Page?id='+oppId);
        pr.setRedirect(true);
        return pr;
    }
    public void cancelGovData(){
        flagGovData = true;
        flagEditGovData = false; 
    }
    
    public void editForRiskData(){
        flagEditRiskData = true; 
        editPermRisk=false;
    }
    public pagereference saveRiskData(){
        try{
            List<Governance_Risk_Item__c> govRiskItems=new List<Governance_Risk_Item__c>();
            for(CounterWrapper riskItem:counterList){ 
                Governance_Risk_Item__c govRiskItem=new Governance_Risk_Item__c();
                govRiskItem.Id=riskItem.item.Id;
                govRiskItem.Risk__c=riskItem.item.Risk__c;
                govRiskItem.Mitigation_Plan__c=riskItem.item.Mitigation_Plan__c;
                govRiskItem.Completion_Date__c=riskItem.item.Completion_Date__c;                
                govRiskItem.Status__c=riskItem.item.Status__c;
                govRiskItems.add(govRiskItem);
            }
            update govRiskItems;
            
        }catch(Exception e){
           system.debug('Risk Item update error::'+e.getMessage());
        }
        flagEditRiskData = false;
        editPermRisk=true;
        pagereference pr = new pagereference('/apex/Governance_Data_Page?id='+oppId);
        pr.setRedirect(true);
        return pr;
    }
    public void cancelRiskData(){
        flagEditRiskData = false; 
        editPermRisk=true;
    }
    
   public pagereference delForRisk(){ 
       try{
           String delRiskId = ApexPages.CurrentPage().getParameters().get('delRiskId');
           Governance_Risk_Item__c govRiskItem=new Governance_Risk_Item__c();
           govRiskItem.Id=delRiskId;
           delete govRiskItem;
           system.debug('delRiskId::::'+delRiskId);
       
       }catch(Exception e){
           system.debug('Risk Item Delete error::'+e.getMessage());
        }
       flagEditRiskData = false;
       editPermRisk=true;
       pagereference pr = new pagereference('/apex/Governance_Data_Page?id='+oppId);
       pr.setRedirect(true);
       return pr; 
   }
       
    
   /******************************
    * Method Name : addRiskSectionItems
    * Description : Add button for  Risk & Action log Section 
    * Parameters  : NA
    * Return Value: PageReference
    *****************************/
   public PageReference addRiskSectionItems(){
        
       addSolutionHeadlinePageMsg = false;       
                
        if(String.isBlank(newRiskSectionItem.Risk__c)|| String.isBlank(newRiskSectionItem.Mitigation_Plan__c) ||
            String.isBlank(newRiskSectionItem.Status__c)){
            addRiskPageMsg = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill all the data.'));
            return null;
        }
       if(newRiskSectionItem.Completion_Date__c == null){
           addRiskPageMsg = true;
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill all the data.'));
           return null;
       }
        if(oppId != null){
            newRiskSectionItem.Opportunity_Governance_Data__c=governanceId;
            try{
            insert newRiskSectionItem;
            }
            catch(exception ex){
                addRiskPageMsg = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_Loading_page));
                return null;
            }
            finally{
                newRiskSectionItem = new Governance_Risk_Item__c();
            }
            addRiskPageMsg = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Added_Successfully));
            }
       
        detailRecordsOfRiskSection();
        addButtonRender = true; 
        refreshPage = true;
        return null;
    }
   
    /******************************
    Method Name: detailRecordsOfRiskSection
    Description: Added method to initialise all Records.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void detailRecordsOfRiskSection() {  
        Integer counter = 0;
        counterList = new List<CounterWrapper>();
         for(Governance_Risk_Item__c item : [Select id,S_No__c,Name,Risk__c,Mitigation_Plan__c, Completion_Date__c,Status__c from  Governance_Risk_Item__c where Opportunity_Governance_Data__c=:governanceId]){
            counter = counter + 1;
            // add the wrapper to the list
            counterList.add(new CounterWrapper(item, counter));                      
         }
     }
     
      /******************************
    Method Name: CounterWrapper
    Description: Wrapper class for counter variable.
    Paramenters: integer Count, list riskItems
    Return Value: risk Section list.
    *******************************/ 
         
    public class CounterWrapper {
    
      public Integer counter { get; set; }
      public Governance_Risk_Item__c item { get; set;}
    
      public CounterWrapper(Governance_Risk_Item__c item, Integer counter) {
        this.item = item;
        this.counter = counter;
      }
    }
   
   
    /******************************
    Method Name: GoBackToHomeTab
    Description: Back Button
    Paramenters: NA
    Return Value: Page reference
    *******************************/  
    
     public PageReference GoBackToHomeTab() {
         String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
         newid=ApexPages.CurrentPage().getParameters().get('id');
         PageReference pg;
         if(newid != null) {
             String pagereferenceLink = sfdcBaseURL  + '/apex/BPO_Opportunity_tab?id=' + newid ;
             pg  = new PageReference(pagereferenceLink );
         }
         else {
             pg = new PageReference(sfdcBaseURL);
         }
         return pg;    
     }    
 }