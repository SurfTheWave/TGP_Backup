public class MailSummaryController{
    
   // Public String oppId;
    public String emailIds;
    public String strUrl;
    private Mail_Summary__c governanceLookup{get;set;}
    public Set<Id> userMasterIds;
    public SD_Governance_Data__c GData = new SD_Governance_Data__c();
    public Transient List<SD_Governance_Data__c> listGovData;
    public Transient List<Opportunity_Teams__c> listOppTeam ;
    public List<Critical_Milestone__c> listMilestoneTable ;
    public List<Risk_And_Action_Log__c> listRiskItemDetails;
    public SD_Governance_Data__c GovData;
    public Risk_And_Action_Log__c newRiskSectionItem;
   public Boolean isMailSent{get;set;}
   // Salesforce_Base_URL__c myCS3 = Salesforce_Base_URL__c.getValues(''); 
    //String Cv=myCS3.Domain_URL__c;

    
   public MailSummaryController(ApexPages.StandardController controller) {
     //   oppId = ApexPages.CurrentPage().getParameters().get('oppId');
        this.governanceLookup = (Mail_Summary__c)controller.getRecord();
        isMailSent = false;
        
    }
    
    public MailSummaryController(){}

    /******************************
    Method Name: sendMail
    Description: Send button For Email popup
    Paramenters: NA
    Return Value: PageReference
    *******************************/
    public Pagereference sendMail(List<Mail_Summary__c> mailSummary){
        system.debug('mailSummary-->'+mailSummary);
        pagereference pr;        
        emailIds ='';
        Set<id> sdGovData = new Set<id>();
            for(Mail_Summary__c mailS : mailSummary){
                   sdGovData.add(mailS.Governance_Data__c);
               }
       List<sd_governance_data__c> sdGov = new List<sd_governance_data__c>();
       List<id> oppId = new List<id>();
        for(sd_governance_data__c sdGovern: [select opportunity__c, id from sd_governance_data__c where id in:sdGovData ]){
                                oppId.add(sdGovern.opportunity__c);
            }
        userMasterIds = new Set<Id>();
        String body;
       // system.debug('governanceLookup.User_1__c-->'+governanceLookup.User_1__c);
        for(Mail_Summary__c mS : mailSummary){
      //system.debug('oppId-->'+ApexPages.CurrentPage().getParameters().get('oppId'));
        
        if(mS.Email_Message__c == null){
              body = '';
          }else{
               body = (mS.Email_Message__c).replaceAll('\n','<br/>');
          }
        if(mS.User_1__c != null){
            userMasterIds.add(mS.User_1__c);
            
        }
        if(mS.User_2__c != null){
            userMasterIds.add(mS.User_2__c);
            
        }
        if( userMasterIds.size() > 0 ){
            for( User_Master__c uMaster : [select id,email__c, name from User_Master__c where id IN : userMasterIds] ){
                emailIds += uMaster.email__c+';';
            }
        }
        }
        
        String[] mailIds = emailIds.split(';'); 
        system.debug( '*********'+userMasterIds+'******'+mailIds);
        system.debug('oppId-->'+oppId);
        listRiskItemDetails= new List<Risk_And_Action_Log__c>();
        listMilestoneTable = new List<Critical_Milestone__c>();      
                     
        listGovData = [Select SAP_OM_ID__c,opportunity__r.Account.name,BPO_Net_RevTnds__c,BPO_Sales_Lead__c,Opportunity_Solution_Lead__c,Opportunity__r.Opportunity_Solution_Lead__c,Commercial__c,MC__c ,Offerings_Scope_SWB__c ,Opportunity__c,Other__c,Over_all__c
                   ,Resources__c,Risk__c,Schedule__c,SD_Gov_Lead_Coach__c,Solution__c,Solution_Dependencies__c,Solution_Headline__c,TGP__c,Trending__c,Watchlist__c,
                        Name,LastModifiedDate,LastModifiedDatee__c,Active__c,Opportunity__r.Master_Client_Name__c,Client__c,Opportunity__r.Name from SD_Governance_Data__c  where Opportunity__r.id=:oppId limit 1]; //:oppId
        
        listMilestoneTable = [Select Name,Active__c,Actual__c,Complete__c,Governance_Data__c,Planned_SWB_Date__c 
                               from Critical_Milestone__c where Governance_Data__r.Opportunity__r.id=:oppId limit 7];  
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];
        system.debug('listGovData-->'+listGovData);
        try{
            /*
             * Starts Condition block to check wheather RAG Status and Trending is selected or not.
             *  IF RAG Status images none, then will render 'none'.
             */
                if(listGovData[0].Risk__c == null){
                    //risk_flag = true;
                    listGovData[0].Risk__c = '';
                }
                if(listGovData[0].Commercial__c == null){
                    //commercial_flag = true;
                    listGovData[0].Commercial__c = '';
                }
                if(listGovData[0].Over_all__c == null){
                    //overall_flag = true;
                    listGovData[0].Over_all__c = '';
                }
                if(listGovData[0].Schedule__c == null){
                    //schedule_flag = true;
                    listGovData[0].Schedule__c = '';
                }
                if(listGovData[0].Solution__c == null){
                    //solution_flag = true;
                    listGovData[0].Solution__c = '';
                }if(listGovData[0].Resources__c == null){
                    //resources_flag = true;
                    listGovData[0].Resources__c = '';
                }
                if(listGovData[0].Trending__c == null || listGovData[0].Trending__c.equalsIgnoreCase('N/A')){
                    //trending_flag = true;
                    listGovData[0].Trending__c = 'N/A';
                }
                if(String.isEmpty(listGovData[0].Solution_Headline__c)){
                    listGovData[0].Solution_Headline__c = '';
                }else{
                    listGovData[0].Solution_Headline__c = (listGovData[0].Solution_Headline__c).replaceAll('\n','\n');
                }
               
                
            /*
             * Ends IF condition for RAG Status and Trending Images.
             */ 
              if(listGovData.size()>0){
                    GData = listGovData[0];
                }
                //governanceId=listGovData[0].id;
            }catch(Exception ex){
              // UTIL_LoggingService.logHandledException(ex, UtilConstants.ORG_ID, UtilConstants.APPLICATION_NAME,'Governance_data_controller', 'Constructor', 
                 //  null, System.Logginglevel.ERROR);
                 system.debug('ex in constructor::'+ex);
               }
               
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
         
     //  EmailTemplate templateId = [Select id from EmailTemplate where name = 'GovernanceEmailTemplate'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(owa.id);    
            mail.setToAddresses(mailIds);          
           mail.setSubject('NOTIFICATION:  Governance Summary - Client Name: '+GData.opportunity__r.Account.name+' - Opportunity Name: '+GData.Opportunity__r.Name);
      
          
          String solHeadLines;
          
         if(GData.Solution_Headline__c == null){
              solHeadLines ='';
          }else{
                  solHeadLines = (GData.Solution_Headline__c).replaceAll('\n','<br/>');
          }
       //  system.debug('*******'+GData.Opportunity__r.SAP_OM_ID__c+'========='+GData.BPO_Net_RevTnds__c);
            //mail.setPlainTextBody(mailBody);  
           //Added by apoorva
            DateTime dT = GData.LastModifiedDate;
            String myDate = dT.format('MMMM d,  yyyy');
        //-------
          String str1  = '<html><p><font face="Calibri (Body)" style="font-size:11pt" >'+body+'</font></p><style type="text/css">'+
                             '.style1 {color: #00FF99;background: #7070FF; width:868px;}'+
                             '.style2 {color: #000000;font-weight: bold;width:868px;}'+
                             '.style3{color:#000000;font-weight: bold; font-size: medium;width:868px; }'+
                             '</style></head>'+
                             '<body><div class="style1"></p></div><br/>'+
                             '<div class="style1"><p class="style2">General Information</p></div>'+
                             '<table rules="rows" border="1" cellpadding="5"><tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">SAP OM ID</font></b></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+checkNullStrings(GData.SAP_OM_ID__c)+'</font></td></tr>'+
                             '<tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Opportunity Name</font></b></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+checkNullStrings(GData.Opportunity__r.Name)+'</font></td></tr>'+
                             '<tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Client Name</font></b></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+checkNullStrings(GData.opportunity__r.Account.name)+'</font></td></tr>'+
                             '<tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Last Modified Date</font></b></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+myDate+'</font></td></tr>'+
                            // '<tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">BPO Sales Lead</font></b></td>'+
                            // '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+checkNullStrings(GData.BPO_Sales_Lead__c)+'</font></td></tr>'+
                             '<tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">SD Governance Lead/Coach</font></b></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+GData.SD_Gov_Lead_Coach__c+'</font></td></tr>'+
                             '<tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Lead Solution Architect – BPO</font></b></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+checkNullStrings(GData.Opportunity_Solution_Lead__c)+'</font></td></tr>'+
                             '<tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Offering  Scope (SWB)</font></b></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+checkNullStrings(GData.Offerings_Scope_SWB__c)+'</font></td></tr>'+
                             '<tr><td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b>BPO Net Revenue  (SD Estimates)<br /> (Thousands) </b></td>'+
                             '<td style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt">'+checkNullValuesDeciamlTCV(GData.BPO_Net_RevTnds__c) +'</td></tr></table>'+
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
        String schedule='';
        String commercial='';
        String resource='';
        String watchlist='';
        if(GData.Watchlist__c!=null){
            watchlist=GData.Watchlist__c;
        }
        //Risk
        system.debug('GData.risk__c-->'+GData.risk__c);
        if(GData.risk__c!=null){
      if(GData.risk__c.equals('Green')){
          risk = '<table><tr><td bgcolor="#00FF00" width="30"height="20"></td></tr></table>';
        }
        if(GData.risk__c.equals('Red')){
            risk = '<table><tr><td bgcolor="red" width="30" height="20"></td></tr></table>';
        }
        if(GData.risk__c.equals('Amber')){
             risk = '<table><tr><td bgcolor="#FFBF00" width="30" height="20"></td></tr></table>';
        }
        }
        // Resource
        if(GData.resources__c!=null){
        if(GData.resources__c.equals('Green')){
             resource =  '<table><tr><td bgcolor="#00FF00" width="30"height="20"></td></tr></table>';
        }
        if(GData.resources__c.equals('Red')){
             resource =  '<table><tr><td bgcolor="red" width="30" height="20"></td></tr></table>';
        }
        if(GData.resources__c.equals('Amber')){          
            resource = '<table><tr><td bgcolor="#FFBF00" width="30" height="20"></td></tr></table>'; 
        }
        }
        //Schedule
        if(GData.schedule__c!=null){
        if(GData.schedule__c.equals('Green')){
            schedule = '<table><tr><td bgcolor="#00FF00" width="30"height="20"></td></tr></table>';
        }
        if(GData.schedule__c.equals('Red')){
            schedule = '<table><tr><td bgcolor="red" width="30"height="20"></td></tr></table>';
        }
        if(GData.schedule__c.equals('Amber')){
            schedule = '<table><tr><td bgcolor="#FFBF00" width="30" height="20"></td></tr></table>';
        }
        }
        //Solution
       if(GData.solution__c!=null){
        if(GData.solution__c.equals('Green')){
            solution = '<table><tr><td bgcolor="#00FF00" width="30"height="20"></td></tr></table>';
        }
        if(GData.solution__c.equals('Red')){
            solution = '<table><tr><td bgcolor="red" width="30"height="20"></td></tr></table>';
        }
        if(GData.solution__c.equals('Amber')){
            solution = '<table><tr><td bgcolor="#FFBF00" width="30" height="20"></td></tr></table>';
        }
        }
        // Commercial
        if(GData.commercial__c!=null){
        if(GData.commercial__c.equals('Green')){
            commercial = '<table><tr><td bgcolor="#00FF00" width="30"height="20"></td></tr></table>';
        }
        if(GData.Commercial__c.equals('Red')){
            commercial = '<table><tr><td bgcolor="red" width="30"height="20"></td></tr></table>';
        }
        if(GData.Commercial__c.equals('Amber')){
            commercial = '<table><tr><td bgcolor="#FFBF00" width="30" height="20"></td></tr></table>';
        }
        }
        
        //Overall
        if(GData.over_all__c!=null){
        if(GData.over_all__c.equals('Green')){
            overall = '<table><tr><td bgcolor="#00FF00" width="30"height="20"></td></tr></table>';
        }
        if(GData.over_all__c.equals('Red')){
            overall = '<table><tr><td bgcolor="red" width="30"height="20"></td></tr></table>';
        }
        if(GData.over_all__c.equals('Amber')){
           overall = '<table><tr><td bgcolor="#FFBF00" width="30" height="20"></td></tr></table>';
        }
        }
        // trending
        if(GData.trending__c!=null){
        if(GData.trending__c.equalsIgnoreCase('Up')){
          GData.trending__c = '<html><strong>&#x2191;</strong></html>';          
        }else if(GData.Trending__c.equalsIgnoreCase('down')){  
          GData.trending__c = '<html><strong>&#x2193;</strong></html>'; 
        }else if(GData.trending__c.equalsIgnoreCase('No Change')){
          GData.trending__c = '<html><strong>&#x2192;</strong></html>'; 
        }
        }

        /*
         *  IF ends For RAG Status images in email template.
         */
           
            String str2 =    '</table><div class="style1"><p class="style2">Status</p></div>'+
                             '<table rules="rows" width="600" border="1" cellpadding="5" ><tr>'+
                             '<td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Watchlist</font> </b> </td> &nbsp;'+
                             '<td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt"> '+watchlist+'</font></td>'+
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
                             '<td width="250" position="relative" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"> '+schedule+'</td>'+
                             '<td width="250" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><b><font face="Calibri (Body)" style="font-size:11pt">Risk</font> </b></td> &nbsp;'+
                             '<td position="relative">'+risk+'</td></tr></table>'+
                             '<div class="style1"><p class="style2">Risk and Action Log </p></div>'+
                             '<table rules="rows" width="700" border="1" align="left" cellpadding="5">'+
                             ' <tr><td width="72" valign="top" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt" ><b><font face="Calibri (Body)" style="font-size:11pt">Number</font></b></td>'+
                             '<td width="198" valign="top" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><b><font face="Calibri (Body)" style="font-size:11pt">Risk</font></b></p></td>'+
                             '<td width="160" valign="top" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><b><font face="Calibri (Body)" style="font-size:11pt">Mitigation Plan</font></b></p></td>'+
                             '<td width="178" valign="top" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><b><font face="Calibri (Body)" style="font-size:11pt">Completion Date</font></b></p></td>'+
                             '<td width="93" valign="top" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><b><font face="Calibri (Body)" style="font-size:11pt">Status</font></b></p></td></tr>';
            
            String dep =    '</table><p></p> <br clear="all" /> <div class="style1"><p class="style3"><strong>Dependencies</strong></p></div>'+
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
       
        for(Risk_And_Action_Log__c riskItem:[Select id,Name,Risk__c,Mitigation_Plan__c, Completion_Date__c,Status__c from  Risk_And_Action_Log__c where Governance_Data__c=:listGovData[0].id]){
          //  id oppid=riskitem.sd_data_governance__r.opportunity__c;
            if(riskItem.Risk__c==null)
            {riskItem.Risk__c = '';}
            if(riskItem.Mitigation_Plan__c==null)
            {riskItem.Mitigation_Plan__c='';
            }
            if(listGovData.size()!=0){
            
            if(riskItem.Completion_Date__c==null){
            str4+= '<tr><td width="72" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt">'+counter+'</font></p></td>'+
                  '<td width="198" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt">'+riskItem.Risk__c+'</font></p></td>'+
                  '<td width="160" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt">'+riskItem.Mitigation_Plan__c+'</font></p></td>'+
                  '<td width="178" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt"></font></p></td>'+
                  '<td width="63" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt">'+riskItem.Status__c+'</font></p></td></tr>';
                  counter++;
                       }
                       else{
        system.debug('riskItem-->'+riskItem.Mitigation_Plan__c+ 'riskItem.Risk__c-->'+riskItem.Risk__c+riskItem.Completion_Date__c+riskItem.Status__c+counter);
           str4+= '<tr><td width="72" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt">'+counter+'</font></p></td>'+
                  '<td width="198" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt">'+riskItem.Risk__c+'</font></p></td>'+
                  '<td width="160" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt">'+riskItem.Mitigation_Plan__c+'</font></p></td>'+
                  '<td width="178" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt">'+(riskItem.Completion_Date__c).format()+'</font></p></td>'+
                  '<td width="63" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt">'+riskItem.Status__c+'</font></p></td></tr>';
            counter++;
            } 
           }
           }
           String msTable = '';
           String msTablee = ''; 
           
           
        if(listMilestoneTable.size()!=0){
            msTable+= '<div class="style1"><p class="style2"><strong>Critical Milestone</strong></p></div>'+
                             '<table rules="rows" width="721" border="1" align="left" cellpadding="5" >'+
                             '<tr style="height:60px;padding:1px;"><td width="423" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><strong><font face="Calibri (Body)" style="font-size:11pt">Milestone</font></strong> </td>'+
                             '<td width="118" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><strong><font face="Calibri (Body)" style="font-size:11pt">SWB Date</font></strong></td>'+
                             '<td width="98" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><strong><font face="Calibri (Body)" style="font-size:11pt">Complete</font></strong></td>'+
                             '<td width="92" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><strong><font face="Calibri (Body)" style="font-size:11pt">Actual&nbsp; </font></strong></td>'+
                             '</tr>';
            for(Critical_Milestone__c milestone:listMilestoneTable){
                String actualDate=String.valueOf( milestone.Actual__c);
                String swbDate=String.valueOf(milestone.Planned_SWB_Date__c);
                
                if(actualDate == null){
                    actualDate=' ';                    
                }else{
                    actualDate = milestone.Actual__c.format();
                }
                if(swbDate == null){
                    swbDate = ' ';
                }else{
                    swbDate  = milestone.Planned_SWB_Date__c.format();
                }
                if(milestone.Complete__c == null){
                    milestone.Complete__c = ' ';
                }
                 msTable +=  '<tr><td width="403" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><p><font face="Calibri (Body)" style="font-size:11pt">'+milestone.name+'</font></p></td>'+
                          '<td width="118" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt" ><font face="Calibri (Body)" style="font-size:11pt">'+swbDate+ 
                          '</font></td><td width="98" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+milestone.Complete__c+
                          '</font></td><td width="92" valign="top" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><font face="Calibri (Body)" style="font-size:11pt">'+actualDate+
                          '</font></td></tr>';
            }
        }
        
        else
        {
        
        system.debug('inside else');
         msTablee += '<div class="style1"><p class="style2"><strong>Critical Milestone</strong></p></div>'+
                             '<table rules="rows" width="721" border="1" align="left" cellpadding="5" >'+
                             '<tr style="height:60px;padding:1px;"><td width="423" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><strong><font face="Calibri (Body)" style="font-size:11pt">Milestone</font></strong> </td>'+
                             '<td width="118" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><strong><font face="Calibri (Body)" style="font-size:11pt">SWB Date</font></strong></td>'+
                             '<td width="98" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><strong><font face="Calibri (Body)" style="font-size:11pt">Complete</font></strong></td>'+
                             '<td width="92" bgcolor="#A0A0A0" style=";border:solid #BFBFBF 1.0pt;padding:3.75pt 3.75pt 3.75pt 3.75pt;height:15.0pt"><strong><font face="Calibri (Body)" style="font-size:11pt">Actual&nbsp; </font></strong></td>'+
                             '</tr>';
         system.debug('msTablee--->'+ msTablee);
      
         }
        
        
      String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + oppId[0];

         String str6 = '</table><p>&nbsp;</p><p></p> <br clear="all" /><p align="left"><font face="Calibri (Body)" style="font-size:11pt"><a href="'+ fullRecordURL  +'">Login to Solution Workbench</a> '+
                '(option for those who have a workbench license) <br clear="all"/><br/>This is a system generated message. '+
                'Please do not reply to  this message.</font></p></body></html>';
        
        mail.setHtmlBody(str1+str3+str2+str4+dep+msTable+msTablee+str6);
            
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
                       
                      // ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Email Sent Successfully' );
                      //ApexPages.addMessage(msg);
                     //system.debug('msg after sending the mail::'+msg+'  result@@'+result);
                   }
               }  
            governanceLookup.Governance_data__c = GData.Id;
            insert governanceLookup;
            
        }   catch(Exception e){
            system.debug('Exception in send mail::@@::'+e.getMessage());
        }     
        isMailSent = true;
        //pagereference pt=new pagereference('/'+GData.Id);
                //  return pt;
                return null;
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
    
      
    
}