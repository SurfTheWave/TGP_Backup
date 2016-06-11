/*
Author : Shridhar Patankar
Story  : Story-0166/SOL_069  
Description : Controller for assessmentUpload page.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Mayank Tayal    Sol_148                    5/15/2013        Sol UAM-Release 2
Mayank Tayal    Sol_123/Sol_147            5/14/2013        Tab Layouts

*/
public with sharing class BPO_Opportunity_tabController {
    
    public List<Comments_on_Opportunity__c> listCommentsBpo{get;set;}
    public Boolean flag {get;set;}
    public Boolean checkSapOm {get;set;}
    public Boolean flagEdit{get;set;}
    public Boolean isOneNoteLinkAvailable{get;set;}
    public Boolean isOppCircleLinkAvailable{get;set;}
    public Boolean isOppCircleLinkNotAvaiable{get;set;}
    public Boolean isOneNoteLinkNotAvaiable{get;set;}
    
    public Boolean flagImage {get;set;}
    public String tabFocusTemp{get;set;}
    public String tabFocus{get;set;}
    public String CountTemp{get;set;}
    public Integer Count{get;set;}
    public Boolean isVisible{get;set;}
    public String isVisibleTemp{get;set;}
    public Boolean optMessage{get;set;}
    public List<Opportunity_TGP__c> lstUserAssignment;
    public static String NONE = '- None -';
    public static String Q = ' Q';
 /* Opportunity TGP variables*/
    
    public Decimal estimateTCV{get;set;}
    public Decimal estimateTCVSAP{get;set;}
    
    public Decimal estimateISTCV{get;set;}
    public Decimal estimateISTCVSAP{get;set;}
    
    
    public boolean NewValue{get;set;} 
    public boolean NewValue1{get;set;}
    public boolean NewValue2{get;set;}
    public boolean NewValue3{get;set;}
    public boolean NewValue4{get;set;}
    public boolean editValue{get;set;}
    public boolean displayButton{get;set;}
    public Opportunity_TGP__c opportunity1;
    public String ClientName{get;set;}
    public boolean ShowPro{get;set;}
    public boolean field1{get;set;}
    public boolean field2{get;set;}
    public boolean flag1 {get;set;}
    public String newid{get;set;}
    public List<Opportunity_TGP__c> opp {get;set;} //Added to prevent duplicate SAP OM ID
    public List<SAP_OM_Opportunity__c> sapOpp {get;set;} //Added to prevent duplicate SAP OM ID
    public String quarterName{get;set;}
    //Added to make Client Geo Area,Client Geo Unit and Operating group as a drop down.
    public String clientGeoAreaMaster{get;set;}
    public String clientGeoUnitMaster{get;set;}
    public String operatingGroupMaster{get;set;}
    public Boolean toDisplayCommentSection{get;set;}
    ////othercharestestics variables///////
    public boolean isPick{get;set;}
    public String StatusSelectForOffering{get; set;}
    public String StatusSelectForSubOffering{get; set;}
    public Boolean isEdit{get;set;}
    public String bcpValue{get;set;}
    public List<userRole> role{get;set;}
    public List<Profile> profileList{get;set;}
    public Boolean flagEditOtherChar{get;set;}
    public Boolean flagOtherChar{get;set;}
    public Id SYS_ADMIN_PROFILE_ID;
    /* Current Client Capability Assessment variables*/
    //Start
    public String pageid{get;set;}
    public Boolean addButtonRender {get; set;}
    public Boolean test{get; set;} 
    public Boolean saveEditButtonRender {get; set;}
    public string congaoppId {get;set;}//added by vinay chada for Conga report
    //public List<scedulingTabTable> scedulingTabTableList{get; set;}
    public List<Opportunity_Offering__c> lstOfferings;
    public opportunity_TGP__c OppToUpdateSolnStartDate{get; set;}
    public boolean AnalyticsYTDRevenueThousand{get;set;}
    public List<Opportunity_TGP__c> assesment{get;set;}
    public String RunningUser {get;set;}
    public List<Opportunity_Offering__c> opptys1  {get;set;}
    public String RunningUserMailId {get; set;}
    public List<User>  userList{get;set;} 
    public String profileName{get;set;}
    public List<Document> doc{get;set;}
    public List<Solution_Plan__c> listAssessmentDetailsActual{get;set;}
    ///solution plan//////////
    
    public Opportunity_TGP__c objOpportunity{get;set;}
    public Opportunity_TGP__c objOpportunityrec{get;set;}
    public boolean isLinkNotAvaiable{get;set;} 
    public boolean isDocLinkVisible{get;set;}
    public  Document doc1{get;set;} 
    public List<Solution_Document_Master__c> documentname{get;set;}
    public String fname{get;set;}
    public String id{get;set;}
    public String cbName{get;set;}
    public Integer cnt{get;set;}
    public List<String> filenames{get;set;}
    public Solution_Plan__c ccca{get;set;}
    public String comments{get;set;}   
    public Integer intCount{get;set;} 
    Public List<AssessmentDetailsActual> lstAssessmentDetailsActual{get;set;} 
    public String fileExten {get;set;}  
    public String recordId{get;set;}
    public String fileId{get;set;}
    public String result{get;set;}
    public Opportunity_Team_SAP__c oppSapTeam{get;set;}
    public List<Opportunity_Team_SAP__c> listOppSapTeam{get;set;}
    ///solution plan over/////////////
    
    //comments on BPO Opportunity

    public Boolean addButtonRenderForCommentsOnBPOOPP{get; set;}
    public Boolean deleteButtonRender{get;set;}
    public Comments_on_Opportunity__c commOnBpo{get;set;}
    public Boolean booleanPageMessageRender{get;set;}
    public String fileIdDelete ;
    public Boolean saveEditButtonRenderForCommentsOnBPOOpp{get; set;}
    public Boolean readOnlyMode{get;set;}
    public Boolean hideCommercialTab{get;set;}
    public Boolean isGovernanceTabVisible{get;set;}
    
    public String getFileIdDelete(){
        return fileIdDelete;
    }
    
    public void setFileIdDelete(String fileIdDelete){
        this.fileIdDelete = fileIdDelete;
    }
    ///comments on BPO Opportunity over////////

    /////offerings/////////////////
    public Opportunity_Offering__c newProfDetail {get;set;}
    public String hiddenNavigator1{get;set;}
    public String hiddenNavigator2{get;set;}
    public Boolean inputShow {get; set;}
    public Boolean uam {get; set;}
    public Boolean refreshPage {get; set;}
    public Opportunity_Offering__c[] listProfileDetailsActual {get;set;}
    public String oppOffering{get;set;}

    ///////////offerings over/////////////////////
     //////History Tracking BPO Net Revenue////////
    public datetime tcv_mod_date {get; set;}
    public  datetime estimated_tcv_mod_date {get; set;}
    public  List<Opportunity_tgp__history> BPO_revenue_History {get; set;}
    public boolean set_tcv {get; set;}
    public boolean set_est_tcv {get; set;}
 
    //////////////////key buyer value////////////////
    public String category{get;set;}
    public Boolean keyBuyerMessage{get;set;}
    public Key_Buyer_Value__c newProfDetailForKeyBuyerValue {get;set;}
    public Key_Buyer_Value__c[] listProfileDetailsActualForKeyBuyerValue {get;set;}
    public String fileIdDeleteForKeyBuyerValue ;
    
    
    public String getfileIdDeleteForKeyBuyerValue(){
        return fileIdDelete;
    }
    
    public void setfileIdDeleteForKeyBuyerValue(String fileIdDelete){
        this.fileIdDelete = fileIdDelete;
    }
    
    //////////////key buyer value end///////////////
    
    ///////////////Opportunity Timeline and Client Background///////////////
    public ApexPages.StandardController cntrlr; 
    public List<Opportunity_TGP__c> listopportunity1;
    public Boolean flagEditOppTimeLine{get;set;} 
    public Boolean flagOppTimeLine{get;set;} 
    ///////////////Opportunity Timeline and Client Background End///////////////
    public List<Opportunity_Cost_Summary_Document__c> CostSummaryDocument{get;set;}
    
    public List<selectOption> getlocations() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('', NONE));
        for (Delievery_Location_Master__c loc : [SELECT Id, Name, Active__c FROM Delievery_Location_Master__c  WHERE Active__c =: true ORDER BY Name]) { 
            options.add(new selectOption(loc.Name, loc.Name));
        }
        
        return options;
    }
    
    //Start
    public BPO_Opportunity_tabController(ApexPages.StandardController controller) {  
              
       booleanPageMessageRender = false;
       opportunity1=(Opportunity_TGP__c)controller.getRecord();
        //ShowPro = false;   
       toDisplayCommentSection = true;
       
       oppSapTeam = new Opportunity_Team_SAP__c();
       listOppSapTeam = [Select BPO_Opp__c,Client_Account_Lead__c,Client_QA_Director__c,Delivery_Lead_BPO__c,Global_Client_Account_Lead__c,Managing_Director_MC__c,Mobilization_Lead__c,Opportunity_Contact__c,Opportunity_QA_Director__c,
                                Sales_Origination__c,Sales_Capture_Opp_Director__c,Sales_Capture_OSL__c,Sales_Capture_Other__c,Solution_Arch_BPO__c,Technology_Account_Lead__c from Opportunity_Team_SAP__c where BPO_Opp__c=:opportunity1.id];
      lstUserAssignment = [select Enterprise_Solution_Architect_New__r.Name,Complex_Cost_Architect_New__r.Name,Solution_Start_Date__c,Offerings__c,Horizon_Deal__c from Opportunity_TGP__c where id =: opportunity1.id];
      profileList = [select name from profile where id = :userinfo.getProfileId()];
         //Revenue Field History Tracking Code
             BPO_revenue_History = [SELECT OldValue, NewValue, Field, CreatedDate FROM opportunity_tgp__history where parentId=:opportunity1.id AND (Field ='TCV__c' OR Field ='Estimated_TCV__c') order by createddate desc];
      //system.debug('Ye mera Debug Hai'+BPO_revenue_History);
     set_tcv = false;
      set_est_tcv = false;
          for(opportunity_tgp__history br_hist:BPO_revenue_History)
          { //system.debug('here i am'+br_hist);
            //system.debug('here i am'+set_tcv+'~~~'+set_est_tcv);
              if(set_tcv == false || set_est_tcv == false){
                  if(br_hist.field =='TCV__c' && set_tcv == false)
                  {
                      tcv_mod_date = br_hist.createddate;
                      set_tcv = true;
                      //system.debug('1');
                  }
                  else if(br_hist.field =='Estimated_TCV__c' && set_est_tcv == false)
                  {
                      estimated_tcv_mod_date = br_hist.createddate;
                      set_est_tcv = true;
                      //system.debug('2');
                  }
              }
      
      }
       role = [select name from userRole where id=:UserInfo.getUserRoleId()];
             
              //Procurement soln stage
               String SWB=lstUserAssignment[0].Offerings__c;
              if(SWB!=null){
               
                 if(SWB.Contains(UTIL_Constants.PROCUREMENT)) {  
                        ShowPro = true;  
               
                  } 
                else{
                    ShowPro = false;
                }     
              }
        NewValue=false;
        NewValue1=false;
        NewValue2=false;
        NewValue3=false;
        NewValue4=false;
        editValue=false;
        Option=UTIL_Constants.YES;
        displayButton=true;
        field1=true;      
        
       //Get current page ID.
       
       newid=ApexPages.CurrentPage().getParameters().get('id');
       
       congaoppId = newid; //added by vinay chada for Conga report
       //Logic for Edit Opp page.
        if(newid!=null)
        {  
           flag = true;
           //Iterate through Opportunity_TGP__c.
           for(Opportunity_TGP__c opp:[Select estimated_tcv__c,IS_Net_Revenue_SD_Estimate__c,SAP_OM_ID_available_Y_N_del__c,Expected_contract_sign_qtr__c,Stage__c from Opportunity_TGP__c where id=:newid])
            {
                Option=opp.SAP_OM_ID_available_Y_N_del__c;
                quarterName=opp.Expected_contract_sign_qtr__c;
                if(Option == 'No') {
                    estimateTCV = opp.estimated_tcv__c;
                    estimateISTCV=opp.IS_Net_Revenue_SD_Estimate__c;
                }
                else if(Option == 'Yes') {
                    estimateTCVSAP = opp.estimated_tcv__c;
                    estimateISTCVSAP=opp.IS_Net_Revenue_SD_Estimate__c;
                }
                
            }
            
            //system.debug('===='+estimateTCV );
            //system.debug('===='+estimateTCVSAP );
                //Check for option No.
                if(Option != null && Option.equalsIgnoreCase(UTIL_Constants.NO))
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
                   NewValue1=true;
                   NewValue2=false; 
                   NewValue4=true;   
                }
           // nextSection(); 
        }
        tabFocusTemp=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.TAB_FOCUS); //Get current page id.
    
         if(String.isBlank(tabFocusTemp))
         {
             tabFocus='tabZero';
         }
         else
         {
             tabFocus=tabFocusTemp;
         }
         CountTemp=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.COUNT); //Get current page id.
         if(String.isBlank(CountTemp))
         {
             Count=1;
         }
         else
         {
             Count=integer.ValueOf(CountTemp);
         }
         isVisibleTemp=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.IS_VISIBLE);
         if(String.isBlank(isVisibleTemp))
         {
             isVisible=false;
         }
         else
         {
             isVisible=Boolean.ValueOf(isVisibleTemp);
         }
        addButtonRender = true;
        flag = true;
        flagEdit = false;
        flagImage = false;
       
        //UAM Code--Mayank Tayal-Sol_148        
        if(newid!=null)
        {
            List<Opportunity_TGP__c> lstOpp = [select id, Analytics_in_Scope__c, Analytics_Sub_Offering__c ,Analytics_Offerings__c ,name 
                                                from Opportunity_TGP__c where id = : newid];
            String strOppId = lstOpp.get(0).id;
            StatusSelectForOffering = lstOpp.get(0).Analytics_Offerings__c ;
            StatusSelectForSubOffering = lstOpp.get(0).Analytics_Sub_Offering__c ;
            /* UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Opportunity_TGP__c');            
            addButtonRender = m.get('C');
            saveEditButtonRender = m.get('U'); */ 
            
            addButtonRender = UAMSolMobUtility.addButtonRender_BPOOppTgp;
            saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
           
            
            
            
        }
        
        //Add Oppo Cost Summary to document tab.
        
         List<Opportunity_Benchmark_Data__c> oppBenchmarkData = new List<Opportunity_Benchmark_Data__c>();
            oppBenchmarkData = [select Id from Opportunity_Benchmark_Data__c where opportunity__c = :newid]; 
          
         if(oppBenchmarkData.size() > 0 ) {            
             CostSummaryDocument = [select Id,fileLink__c, Document_Name__c,Comments__c ,Date_Uploaded__c from Opportunity_Cost_Summary_Document__c where Opportunity_BenchMark_Data__c =:oppBenchmarkData[0].Id limit 1];
          }
        
        ///comments on BPO Oppo/////////
        
        commentsOnBPOOppconstructor();
        
        ///comments on BPO Opp///////////
        
        
        /////other characteristics tab ////////
        
        otherCharecteristicsConstructor();
        
        ///////other characteristics tab end////////
                
        ////////////////solution plan//////////////
        
        solutionPlanConstructor();
        
        ////////////////// solution plan end////////


        ////////offering ///////////////////
        
        offeringConstructor();
        
        ///////////offering end//////////////
        
        
        ////////////key buyer value////////////////
        
        keyBuyerValueConstructor();
        
        //////////////////key buyer value end////////////////////

        ////////////////VFP_Solution_Live start//////////
        
        solutionLiveConstructor();
        
        ////////////////////////////VFP_Solution_Live end//////////
        
        ////////////////Opportunity Timeline and Client Background//////////////////
        
        
        cntrlr = controller;   
        addButtonRender = true;
        flagOppTimeLine = true;
        flagEditOppTimeLine = false;
        //code added delete link should be display for solution Admin on offering Tab
        if(profileList[0].name.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN) ){
                    deleteButtonRender=true;
         }
        
        //////////////////Opportunity Timeline and Client Background End//////////////////
        
        //Commercial Tab hide Code
        SYS_ADMIN_PROFILE_ID = [select ProfileId from User where Profile.Name = 'System Administrator' limit 1].ProfileId;
        List<PermissionSetAssignment> lstcurrentUserPerSet = [ SELECT Id, PermissionSet.Name,AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId()];
        for (PermissionSetAssignment psa: lstcurrentUserPerSet){
                //system.debug('lstcurrentUserPerSet1234'+lstcurrentUserPerSet);
                if(psa.PermissionSet.Name.equals('Commercial_Write') || psa.PermissionSet.Name.equals('Commercial_Read') || UserInfo.getProfileId().equals(SYS_ADMIN_PROFILE_ID)){
                    //system.debug('psa.PermissionSet.Name1234'+psa.PermissionSet.Name);
                    hideCommercialTab = true;
                }
                else{
                    List<Opportunity_Team__c> lstOppTeam = [select Opportunity_Team_Member__r.SFDC_User__c,Active__c,BPO_Opportunity__c, Offering__c,Opportunity_Team_Member__c,Roles__c from Opportunity_Team__c where BPO_Opportunity__c =: opportunity1.Id];
                    //system.debug('lstOppTeam1234'+lstOppTeam);
                    for(Opportunity_Team__c o : lstOppTeam){
                        //system.debug('o.Opportunity_Team_Member__r.SFDC_User__c1234'+o.Opportunity_Team_Member__r.SFDC_User__c);
                        //system.debug('Userinfo.getUserId()1234'+Userinfo.getUserId());
                        if(o.Opportunity_Team_Member__r.SFDC_User__c == Userinfo.getUserId()){
                            hideCommercialTab = true;
                        }
                    }
                }
            }
         //Governance Tab Visibility
       /** for (PermissionSetAssignment psa: lstcurrentUserPerSet){
                if(psa.PermissionSet.Name.equals('SA_OU_Lead') || UserInfo.getProfileId().equals(SYS_ADMIN_PROFILE_ID)){
                    isGovernanceTabVisible = true;
                }
                else{
                    List<Opportunity_Team__c> lstOppTeam = [select Opportunity_Team_Member__r.SFDC_User__c,Opportunity_Team_Member__r.isUserActive__c,Active__c,BPO_Opportunity__c, Offering__c,Opportunity_Team_Member__c,Roles__c,Roles__r.Name from Opportunity_Team__c where BPO_Opportunity__c =: opportunity1.Id];
                    
                    for(Opportunity_Team__c o : lstOppTeam){
                    //system.debug('team user is active::@@'+o.Opportunity_Team_Member__r.isUserActive__c);
                        if(o.Roles__r.Name.equals('SD Governance Lead/Coach') && (o.Opportunity_Team_Member__r.isUserActive__c)){
                            isGovernanceTabVisible = true;
                        }
                    }
                }
            } */
        List<Opportunity_Team__c> lstOppTeam = [select Opportunity_Team_Member__r.SFDC_User__c,Opportunity_Team_Member__r.UserName__c,Opportunity_Team_Member__r.Name,Active__c,BPO_Opportunity__c, Offering__c,Opportunity_Team_Member__c,Roles__c,Roles__r.Name from Opportunity_Team__c where BPO_Opportunity__c =: opportunity1.Id];
        if(lstOppTeam.size()>0){
            for(Opportunity_Team__c o : lstOppTeam){
            if(o.Roles__c != null && o.Opportunity_Team_Member__c != null){
                if((o.Roles__r.Name.equals('SD Governance Lead/Coach') && !(o.Opportunity_Team_Member__r.Name.contains(system.label.Unassigned)))) {   //|| psa.PermissionSet.Name.equals('SA_OU_Lead') ){
                        isGovernanceTabVisible = true;
                }else{
                 if(UserInfo.getProfileId().equals(SYS_ADMIN_PROFILE_ID)){
                        isGovernanceTabVisible = true;
                 } 
                }            
            }
            }
        }
      }
    //End
    
    public void otherCharecteristicsConstructor(){
        
        addButtonRender = true;
        checkSapOm = true;
        flagOtherChar = true;
        flagEditOtherChar = false;
        AnalyticsYTDRevenueThousand = true;
        
        isPick=true;
        
        pageid=ApexPages.CurrentPage().getParameters().get('id');
        
         //List<Review_User_Master__c> reviewUserName;
        
        //List<User> userName = [select Name,id from User where Email= 'sophia.prem.kumar@accenture.com' limit 1];
        
        if(opportunity1.SAP_OM_Opportunity__r.name != null) {
            checkSapOm = false;
        }
        
        /*if(userName.size()>0){
        
            reviewUserName = [select Name,id from Review_User_Master__c where SFDC_User__c =: userName[0].id limit 1];
            if(reviewUserName.size()>0)
            {
                if(opportunity1.BSS_Operation_New__c == null){
                
                     opportunity1.BSS_Operation_New__c = reviewUserName[0].id;
                }
            }
        }*/
        
               
        
        //UAM Code--Mayank Tayal-Sol_148
        /*if(newid!=null)
        {
            List<Opportunity_TGP__c> lstOpp = [select id, Analytics_Sub_Offering__c ,Analytics_Offerings__c ,name from Opportunity_TGP__c where id = : newid];
            String strOppId = lstOpp.get(0).id;
            StatusSelectForOffering = lstOpp.get(0).Analytics_Offerings__c ;
            StatusSelectForSubOffering = lstOpp.get(0).Analytics_Sub_Offering__c ;
            UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Opportunity_TGP__c');            
            addButtonRender = m.get('C');
            saveEditButtonRender = m.get('U');
        }*/  
        //role = new List<userRole>();
        //role = [select id,name from userRole where id=:UserInfo.getUserRoleId()];   
        
             /*if(role.size()>0)
                {
                    if(role[0].name!=null && role[0].name.equalsIgnoreCase(UTIL_Constants.OPERATION_ROLE))
                         {
                           isEdit=true;
                         }
                } */ 
                
            if(profileList.size()>0) {
                if(profileList[0].name.equalsIgnoreCase(System.Label.PMO_Profile) ) {
                    isEdit=true;
                }
            } 
        }
        
     public PageReference GoBackToHomeTab() {
         String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
         newid=ApexPages.CurrentPage().getParameters().get('id');
         String pagereferenceLink = sfdcBaseURL  + '/apex/BPO_Opportunity_tab?id=' + newid;
         PageReference pg  = new PageReference(pagereferenceLink );
         return pg;    
     }   
        
     
     public void commentsOnBPOOppconstructor(){
        
        addButtonRenderForCommentsOnBPOOPP = true;    
        commOnBpo= new Comments_on_Opportunity__c();
        initializeDetailRecords();
        if(newid!=null)
        {
            List<Opportunity_TGP__c> lstOpp = [select id, name from Opportunity_TGP__c where id = : newid];
            String strOppId = lstOpp.get(0).id;
            
            /*UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Comments_on_Opportunity__c');            
            addButtonRenderForCommentsOnBPOOPP = m.get('C');
            saveEditButtonRenderForCommentsOnBPOOpp = m.get('U');
            deleteButtonRender  = m.get('D');*/
            
            addButtonRenderForCommentsOnBPOOPP = UAMSolMobUtility.addButtonRender_BPOOppTgp;
            saveEditButtonRenderForCommentsOnBPOOpp = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
            deleteButtonRender  = UAMSolMobUtility.deleteButtonRender_BPOOppTgp;
            
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Opportunity_Id_not_valid)); 
        }   
        if(addButtonRenderForCommentsOnBPOOPP && saveEditButtonRenderForCommentsOnBPOOpp)
        {
            readOnlyMode=true;
        }
    }
    //////////////////Opportunity Timeline and Client Background //////////////////
    
        
    /******************************
    Method Name: 
    
    
    ForOppTimeLineClientBackTab
    Description: To save Opp Time Line Client Back Tab records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void saverecordForOppTimeLineClientBackTab()
    {
      
        if(opportunity1.Solution_Start_Date__c==null)
            {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Sol_Start_Date));
              return;
            }
        
        if(opportunity1.RFI_response_due__c==null)
            {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Submit_Date_cannot_be_left_blank));
              return;
            }
        if(opportunity1.RFP_response_due__c==null)
            {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.RFP_Response_cannot_be_left_blank));
              return;
            }
         if(opportunity1.Contract_Signature__c==null)
            {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Contract_Signature_cannot_be_left_blank));
              return;
            }           
        if(opportunity1.Contract_Start_Date__c==null)
            {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Contract_Start_Date_cannot_be_left_blank));
              return;
            }
        if(opportunity1.Contract_End_Date__c==null)
            {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Contract_End_Date_cannot_be_left_blank));
              return;
            }            
        if(opportunity1.Initial_Go_live__c==null)
            {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Initial_Go_live_cannot_be_left_blank));
              return;
            }
       if(opportunity1.Contract_End_Date__c <= opportunity1.Contract_Start_Date__c)
            {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Contract End Date can not be less than Contract Start Date.'));
              return;
            } 
       if(opportunity1.Contract_End_Date__c <= opportunity1.Contract_Signature__c)
            {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Contract End Date can not be less than Contract Signature Date.'));
              return;
            }    
       try
        {
            upsert opportunity1;      
        }
        catch(Exception ex)
        {
            if(ex.getMessage().contains(UTIL_Constants.UPDATE_FAILED))
            {
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Insufficient_access_rights_Cannot_be_Updated));
                   return;
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_in_Saving));
            return;
        }  
        flagOppTimeLine =true;
        
        flagEditOppTimeLine = false;
   }
   
   
    
    /******************************
    Method Name: cancelRecord
    Description: To cancel RecordOpportunity records.
    Paramenters: Void
    Return Value: NA
    *******************************/ 
    public void cancelRecordForOppTimeLineClientBackTab()
    {
        listopportunity1= new List<Opportunity_TGP__c>();
        listopportunity1=[Select Id,Enterprise_Solution_Architect_New__c,Procurement_Solution_Stage__c,
                            RFI_Received__c,RFI_response_due__c,RFP_Received__c,Solution_Workshop__c,RFP_response_due__c,RFP_Down_Select__c,
                            Presentations_Orals__c,Reference_Checks_and_Site_Visits__c,Negotiations__c,Contract__c,Ramp_up_and_Service_Delivery__c,
                            Client_Overview__c,Link_to_client_website__c,TCVV__c,X3rd_Party_Vendors_in_scope__c,
                            Benchmark_Solution1__c,Third_party_Advisors__c,
                            Third_Party_Advisors_Comments__c,Transaction_or_volume_based__c,TBD__c,Fixed__c,FTE__c,Existing_Accenture_client__c,
                            Existing_BPO_Client__c, BCP_Value__c, Estimated_TCV__c,IS_Net_Revenue_SD_Estimate__c
                            from Opportunity_TGP__c where Id = :pageid];
        if(listopportunity1.Size()>0)
        {
            flagOppTimeLine =true;
            flagEditOppTimeLine = false;
        }
         
    }
    
    //////////////////Opportunity Timeline and Client Background End//////////////////
    
    /******************************
    Method Name: initializeDetailRecords
    Description: Added method to initialise all Records.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
     public void initializeDetailRecords() {
        
         listCommentsBpo = new List<Comments_on_Opportunity__c>();
              //SOSL for Key Buyer Values.
              
                for(Comments_on_Opportunity__c comments : [Select Comments__c,Created_Date__c,Created_by__c,LastModifiedDate from Comments_on_Opportunity__c where BPO_Opportunity__c=:newid order by CreatedDate desc]) {
                        listCommentsBpo.add(comments);
                }
                
    }
    //End
    
    
    
    
    /******************************
    Method Name: noAnalyticsInScope
    Description: Logic when Analytics is not in Scope. 
    Paramenters: NA
    Return Value: NA
    *******************************/  
    public void noAnalyticsInScope(){ 
    
       AnalyticsYTDRevenueThousand=false;
        
    }
    /******************************
    Method Name: YesAnalyticsInScope
    Description: Logic when Analytics is in Scope. 
    Paramenters: NA
    Return Value: NA
    *******************************/  
    public void YesAnalyticsInScope(){ 
    
        AnalyticsYTDRevenueThousand = true;
    }
    /******************************
    Method Name: getBCPStandard
    Description: For BCP Radio Buttons
    Paramenters: NA
    Return Value: NA
    *******************************/
    public List<SelectOption> getBCPStandard() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(UTIL_Constants.STANDARD_BCP,UTIL_Constants.STANDARD_BCP));
        options.add(new SelectOption(UTIL_Constants.NON_STANDARD_BCP,UTIL_Constants.NON_STANDARD_BCP));
        return options;
    }
    
    /******************************
    Method Name: addComments
    Description: To add records in Comments detail
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public PageReference addComments() {
        commOnBpo.BPO_Opportunity__c=newid;
        if(String.isBlank(commOnBpo.Comments__c))
        {
            booleanPageMessageRender = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Comments_cannot_be_left_blank));
            return null;
        }
            try{
                insert commOnBpo;
            }
            catch(exception ex){
                booleanPageMessageRender = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_Loading_page));
                return null;
            }
            finally{
                commOnBpo= new Comments_on_Opportunity__c();
            }
        booleanPageMessageRender = true;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Added_Successfully));
        initializeDetailRecords();
        return null;
    }
    //End
    
    /******************************
    Method Name: saveComments
    Description: For saving records in Comments on Bpo Opportunity..
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public PageReference saveComments(){
        
        Comments_on_Opportunity__c[] commentsUpsert = new Comments_on_Opportunity__c[]{};
       
       // list<Comments_on_Opportunity__c> comments =[Select Comments__c,Created_Date__c,Created_by__c from Comments_on_Opportunity__c where BPO_Opportunity__c=:newid order by LastModifiedDate desc]; 
         //if
        // listCommentsBpo.add(comments);
         
        if(listCommentsBpo.size()<=0)
        {
            booleanPageMessageRender = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.There_is_no_record_to_save));
            return null;
        }
        for(Comments_on_Opportunity__c commentsOnBPO : listCommentsBpo)
        {
            if(commentsOnBPO.Comments__c ==null)
            {
                booleanPageMessageRender = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Comments_cannot_be_left_blank));
                return null;
            }
                   
        } 
        
        commentsUpsert.addAll(listCommentsBpo);
       

        try {
            upsert commentsUpsert;
        }
        catch(Exception ex) {
            booleanPageMessageRender = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Please_select_the_required_fields));
            return null;
        }
        booleanPageMessageRender = true;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Updated_Successfully));
        initializeDetailRecords();
        return null;
    }
    //End
    
    /******************************
    Method Name: refreshAccProfilePage
    Description: Method to cancel the page.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public PageReference refreshAccProfilePage(){
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
        for(Comments_on_Opportunity__c coo : [select id, Comments__c,Created_Date__c,Created_by__c from Comments_on_Opportunity__c where BPO_Opportunity__c=:newid and id=:fileIdDelete])
        {
            //To override file from Comments_on_Opportunity__c.
            delete coo;           
        }
        booleanPageMessageRender = true;    
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_deleted_successfully));
        initializeDetailRecords();        
        return null;
    }
    
    /*public PageReference getScheduling()
    {
        
        PageReference pg=new PageReference('/apex/BPO_Opportunity_tab?id='+opportunity1.id +'&tabFocus=tab7&isVisible=true');
        pg.SetRedirect(true);
        return pg;
    }*/
     public pageReference checkOpp() {
         pageReference p1 = new pageReference('http://www.google.co.in');
         return p1; 
     }
     
     ////////////////////////VFP_solution_LIVEConstructor///////////
     
     public void solutionLiveConstructor(){
     
         objOpportunityrec =new Opportunity_TGP__c();
            //isOppCircleLinkNotAvaiable=true;
            if(newid!=null)
            {
                List<Opportunity_TGP__c> lstOpp = [select id, name,Link_to_OneNote__c,Link_to_Opportunity_Circle__c from Opportunity_TGP__c where id = : newid];
                if(lstOpp.size()>0)
                {
                    objOpportunityrec=lstOpp[0];
                    if(objOpportunityrec.Link_to_Opportunity_Circle__c ==null)
                       {
                         isOppCircleLinkNotAvaiable = true;
                       
                       }
                       if(objOpportunityrec.Link_to_OneNote__c ==null)
                       {
                         isOneNoteLinkNotAvaiable = true;
                       
                       }
                       
                }
            }
            if(profileList.size()>0) {
                if(profileList[0].name.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN) || profileList[0].name.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)) {
                    isOneNoteLinkAvailable=true;
                    isOppCircleLinkAvailable=true;
                }
            }
     
     }
     
     public void SaveLinkForOppCircle()
     {
          PageReference pg;
              try
              {
                  if(objOpportunityrec.Link_to_Opportunity_Circle__c == null) {
                      isOppCircleLinkNotAvaiable= true;
                  }
                  else {
                     isOppCircleLinkNotAvaiable= false; 
                  }
                  
                  /*if(objOpportunityrec.Link_to_OneNote__c == null) {
                      isOppCircleLinkNotAvaiable= true;
                  }
                  else {
                     isOppCircleLinkNotAvaiable= false; 
                  }*/
                  upsert objOpportunityrec;
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Link_saved_successfully));  
                
                 
              }
              catch (Exception e)
              {
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_in_Saving));
                  return;
              } 
              return;
              
          }
          public void SaveLinkForOneNote()
          {
            PageReference pg;
              try
              {
                  
                  if(objOpportunityrec.Link_to_OneNote__c == null) {
                      isOneNoteLinkNotAvaiable= true;
                  }
                  else {
                     isOneNoteLinkNotAvaiable= false; 
                  }
                  upsert objOpportunityrec;
                  
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Link_saved_successfully));  
                  
              }
              catch (Exception e)
              {
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_in_Saving));
                  return ;
              } 
              return ;
              
          }
        public PageReference ClickHereForOppCircle() 
        {
            PageReference pageRef;
            String url = objOpportunityrec.Link_to_Opportunity_Circle__c;
            if(String.isEmpty(url)) {
                pageRef = new PageReference('/#');
                return pageRef;
            }
            else {
                pageRef = new PageReference(url);
                pageRef.setRedirect(true);
                return pageRef ;
            }
        }    
        public PageReference ClickHereForOppNote() 
        {
            PageReference pageRef;
            String url = objOpportunityrec.Link_to_OneNote__c;
            if(String.isEmpty(url)) {
                pageRef = new PageReference('/#');
                return pageRef;
            }
            else {
                pageRef = new PageReference(url);
                pageRef.setRedirect(true);
                return pageRef ;
            }
         }
     
     /////////////////////VFP_solution_LIVEConstructor end///////////
     
    /////////////////solution plan//////////////////////
    
    public void solutionPlanConstructor(){
        
            objOpportunity=new Opportunity_TGP__c();
            isLinkNotAvaiable=true;
            if(newid!=null)
            {
                List<Opportunity_TGP__c> lstOpp = [select id, name,Link_to_Additional_Documents__c from Opportunity_TGP__c where id = : newid];
                if(lstOpp.size()>0)
                {
                    objOpportunity=lstOpp[0];
                    if(objOpportunity.Link_to_Additional_Documents__c==null)
                       {
                         isLinkNotAvaiable= false;
                       
                       }
                }
            }
            //List<userRole >role = [select id,name from userRole where id=:UserInfo.getUserRoleId()];
            /* if(role.size()>0) {
                if(role[0].name!=null && (role[0].name.equalsIgnoreCase('Operations') || role[0].name.equalsIgnoreCase('Resource Staffing')))
                isDocLinkVisible=true;
            }
            if(profileList[0].name.equalsIgnoreCase('Workbench Administrator')) {
                isDocLinkVisible=true;
            } */
            
            if(profileList.size()>0) {
                if(profileList[0].name.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN) || profileList[0].name.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)) {
                    isDocLinkVisible=true;
                }
            }
            
            addButtonRender = true;
            doc1 = new Document();
            doc1.IsPublic=true;    
            doc1.name ='file';
            documentname =[select id,name,Document_URL__c, Description__c from Solution_Document_Master__c];
            fname='File';
            cnt=1;
            filenames=new List<String>();
            if(newid!=null) {
                try {
                    assesment=[Select id, name from Opportunity_TGP__c where id=:newid];
                    for(Opportunity_TGP__c cb : assesment) {
                        cbName=cb.name;                 
                    }
                }
                catch(Exception e) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Opportunity_Id_not_found));
                }
                finally {
                    assesment=null;
                }   
              
                RunningUser =UserInfo.getUserId();
                RunningUserMailId =Userinfo.getUserEmail(); 
                opptys1 =[select Name from Opportunity_Offering__c where Opportunity_TGP__r.id=:newid AND
                        (Functional_Architect_Mobilization_New__r.SFDC_User__c=:RunningUser OR 
                         Solution_Lead_New__r.SFDC_User__c=:RunningUser OR
                         Offering_Solution_Lead_Secondary_New__r.SFDC_User__c=:RunningUser OR
                         Solution_Specialist_New__r.SFDC_User__c=:RunningUser OR 
                         technical_Architect_New__r.SFDC_User__c=:RunningUser OR 
                         Opportunity_TGP__r.Complex_Cost_Architect_New__r.SFDC_User__c=:RunningUser OR
                         Opportunity_TGP__r.Enterprise_Solution_Architect_New__r.SFDC_User__c=:RunningUser)];

                initializeDetailRecordsForSolutionPlan();
                List<Solution_Plan__c> lstSolPlan = [Select Name, Picture_ID__c,Comments__c,User__c,File_ID__c,File_Name__c,BPO_Opportunity__c,Date_Uploaded__c,
                                                        Uploaded_By__c,Attached_File_Name__c,Document_url__c from Solution_Plan__c 
                                                        where BPO_Opportunity__c =:newid ORDER By CreatedDate DESC];
                if(lstSolPlan.size() > 0){
                    intCount=2;  
                }
                else {
                    intCount=1;  
                }
              }
            else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Opportunity_Id_not_found));
            }
            //UAM Code--Mayank Tayal-Sol_148
            if(newid!=null)
            {
                List<Opportunity_TGP__c> lstOppTGP = [select id, name from Opportunity_TGP__c  where id = : newid];
                String strOppId = lstOppTGP.get(0).id;
                /* UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
                Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Solution_Plan__c');            
                addButtonRender = m.get('C');
                saveEditButtonRender = m.get('U');
                deleteButtonRender  = m.get('D'); */
                addButtonRender = UAMSolMobUtility.addButtonRender_BPOOppTgp;
                saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
                deleteButtonRender = UAMSolMobUtility.deleteButtonRender_BPOOppTgp;
            }
            if(addButtonRender && saveEditButtonRender)
            {
                readOnlyMode=true;
            } 
            /*profileName=null;
            userList = new List<User>();
            userList=[SELECT Email,Profile.Name FROM User where id=:UserInfo.getUserId()];
            if(userList.size()>0){ 
                profileName=userList[0].Profile.Name;
                if(profileName!=null && profileName == 'Solution Leadership') { 
                    saveEditButtonRender=false;
                }
                else if((profileName!=null) && (profileName == 'System Administrator' ||profileName == 'Workbench Administrator' ||profileName == 'Dev System Administrator')) 
                {
                    saveEditButtonRender=true;
                }
                else if(opptys1.size()>0 ) {
                   saveEditButtonRender =true;
                }
            }
            */
            }
     public class AssessmentDetailsActual
        {
            public Solution_Plan__c objAssessmentDetailsActual{get;set;}
            public boolean isDeleteVisible{get;set;}
            public boolean isUploaded{get;set;}
            
            public AssessmentDetailsActual(Solution_Plan__c objAssessmentDetailsActual, boolean isDeleteVisible,boolean isUploaded)
            {
                this.objAssessmentDetailsActual=objAssessmentDetailsActual;
                this.isDeleteVisible=isDeleteVisible;
                this.isUploaded = isUploaded;
            }
        }
        
        
        /******************************
        Method Name: initializeDetailRecordsForSolutionPlan
        Description: Added method to initialise all Records.
        Paramenters: NA
        Return Value: void
        *******************************/
        //Start
        public void initializeDetailRecordsForSolutionPlan() 
        {
            String strFolderId= [select id from folder where name =: UTIL_Constants.SOLUTION_DOCUMENT].id;
            doc=[Select name from Document where FolderId=:strFolderId];
            listAssessmentDetailsActual = new List<Solution_Plan__c>();
            lstAssessmentDetailsActual=new List<AssessmentDetailsActual>();
            String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name;
            //Search for Current Client Capability Assessment
            for(Solution_Plan__c cAssess : [Select Name, Picture_ID__c,Comments__c,File_ID__c,User__c,File_Name__c,BPO_Opportunity__c,Date_Uploaded__c,Uploaded_By__c,
                                            Attached_File_Name__c,Document_url__c from Solution_Plan__c where BPO_Opportunity__c =:pageid ORDER By CreatedDate DESC]) 
            {
                boolean isDeleteVisible=false;
                boolean isUploaded =false;
                listAssessmentDetailsActual.add(cAssess); 
                
                // Checking Sol User start
                if(opptys1.size()>0) {
                 isUploaded=true;
                }
                else{
                 isUploaded=false;
                }
                //checking sol user end                                    
                if(cAssess.User__c==null) {
                    isDeleteVisible=false;
                }
                if(userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.WORKBENCH_ADMIN)||userProfileName.equalsIgnoreCase(UTIL_Constants.DEV_SYS_ADMIN))  
                {
                    isDeleteVisible=true;
                    isUploaded =true;
                }
                if(cAssess.User__c==UserInfo.getUserId()) {
                    isDeleteVisible=true;
                 }
                lstAssessmentDetailsActual.add(new AssessmentDetailsActual(cAssess,isDeleteVisible,isUploaded));   
            }
        }
        
   /*  public List<Solution_Document_Master__c> DocumentListfromMasters;
 
        public List<Solution_Document_Master__c> getDocumentfromMasters() {
        DocumentListfromMasters = [select id, Name, Document_URL__c, Description__c FROM Solution_Document_Master__c where Name != null];
        return DocumentListfromMasters;
        } */
        
        // public List<Opportunity_Document__c> DocumentListfromMasters;
 
        public List<Opportunity_Document__c> getDocumentfromMasters() {
        List<Opportunity_Document__c> DocumentListfromMaster = [select id, Name, Document_Link__c, Modified_Date__c, Modified_By__c, IsDeleted__c FROM Opportunity_Document__c where BPO_Opportunity__c =: newid];
        return DocumentListfromMaster;
        } 
        
   
        
        public PageReference  docNames()
          {
             documentname =[select id,name,Document_URL__c from Solution_Document_Master__c];
             listAssessmentDetailsActual = new List<Solution_Plan__c>();
             
             for(Solution_Document_Master__c doclist : documentname)
               {
                 Solution_Plan__c solPlan = new Solution_Plan__c();
                 solPlan.File_Name__c = doclist.name;
                 solPlan.BPO_Opportunity__c =pageid;
                 solPlan.Solution_Document_Master__c=doclist.id;
                 solPlan.Document_url__c = doclist.Document_URL__c;
                 listAssessmentDetailsActual.add(solPlan);         
               }
               upsert listAssessmentDetailsActual;
               
              intCount=2;
              PageReference pg=new PageReference('/apex/BPO_Opportunity_tab?id='+pageid+'&tabFocus=tab6');
                pg.SetRedirect(true);
                tabFocus= UTIL_Constants.TAB_THREE;
                return pg;
          }
          public void SaveLink()
          {
              try
              {
                  if(objOpportunity.Link_to_Additional_Documents__c == null) {
                      isLinkNotAvaiable = false;
                  }
                  else {
                     isLinkNotAvaiable = true; 
                  }
                  upsert objOpportunity;
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Link_saved_successfully));       
                  initializeDetailRecordsForSolutionPlan(); 
              }
              catch (Exception e)
              {
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_in_Saving));
                  return;
              } 
              return;
              
          }
          public PageReference ClickHere() 
        {
            PageReference pageRef;
            String url = objOpportunity.Link_to_Additional_Documents__c;
            if(String.isEmpty(url)) {
                pageRef = new PageReference('/#');
                return pageRef;
            }
            else {
                pageRef = new PageReference(url);
                pageRef.setRedirect(true);
                return pageRef ;
            }
         }
        
       ////////// solution plan end//////////////
      
      
      ////////////////////offerings////////////////////////
      
        public void offeringConstructor(){
        
                newProfDetail = new Opportunity_Offering__c();
                hiddenNavigator1='New';
                addButtonRender = true;
                inputShow = false;
                uam = false;
                
                //OppId=ApexPages.CurrentPage().getParameters().get('id');
                initializeDetailRecordsForOffering();
                
                opp =[Select name,id,Enterprise_Solution_Architect_New__c from Opportunity_TGP__c where id =:newid];
                if(opp.Size()>0){
                newProfDetail.Solution_Lead_New__c=opp[0].Enterprise_Solution_Architect_New__c;
                }
                hiddenNavigator2=UTIL_Constants.TEST_VALUE;
                refreshPage = false;
                //UAM Code--Mayank Tayal-Sol_148        
                if(newid!=null)
                {
                    List<Opportunity_TGP__c> lstOpp = [select id, name from Opportunity_TGP__c where id = : newid];
                    String strOppId = lstOpp.get(0).id;
                    /* UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
                    Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Opportunity_TGP__c');            
                    addButtonRender = m.get('C');
                    saveEditButtonRender = m.get('U');
                    deleteButtonRender  = m.get('D');
                    */
                    addButtonRender = UAMSolMobUtility.addButtonRender_BPOOppTgp ;
                    saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
                    deleteButtonRender = UAMSolMobUtility.deleteButtonRender_BPOOppTgp;
                    
                }
                if(addButtonRender==false && saveEditButtonRender==false)
                {
                    readOnlyMode=true;
                }
        } 
      /******************************
    Method Name: initializeDetailRecordsForOfferings
    Description: Added method to initialise all Records.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public void initializeDetailRecordsForOffering() {   
    hiddenNavigator2=UTIL_Constants.ADD;    
    listProfileDetailsActual = new Opportunity_Offering__c[]{};
    List<Opportunity_Offering__c> oppOffering = [Select id,Name, solUserTaskID__c, Opportunity_Link__c,Offering_Master__r.Name, Offering_Solution_Lead_Secondary_New__r.Name,Solution_Lead_New__r.Name,Active__c from Opportunity_Offering__c where Opportunity_TGP__c=:newid order by Offering_Master__r.Name ];
        
        
        if(oppOffering.Size()>0){
            for(Opportunity_Offering__c profDet : oppOffering){
                listProfileDetailsActual.add(profDet);                
            } 
        }  
        
    } 
    
    //End
      
      /******************************
    Method Name: addNewProfDetail
    Description: To add records for Opportunity_Offering__c
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public PageReference addNewProfDetail() {
        hiddenNavigator1= UTIL_Constants.ADD;
        if(oppOffering== UTIL_Constants.NONE){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Please_select_the_valid_Offerings_Name));
            return null;
        }
        newProfDetail.Opportunity_TGP__c=newid;
        newProfDetail.Offering_Master__c=oppOffering;
        /*if(newProfDetail.Solution_Lead_New__c==null)
            {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Offering_Solution_Lead_Primary_cannot_be_left_blank));
              return null;
            }*/
        try{
          List<Opportunity_Offering__c> oppOffl= [Select id,Active__c,Offering_Master__r.Name From Opportunity_Offering__c where Offering_Master__c= :newProfDetail.Offering_Master__c and Opportunity_TGP__c=:newid limit 1];
          if(oppOffl.size()==1){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Record_Already_Exists_Please_check_the_data));
                initializeDetailRecordsForOffering();
                return null;
          }
          //Creating the new task for Solution Architect
          Solution_User_Task__c newTask=new Solution_User_Task__c();
          newTask.Opportunity_ID__c=newid;
          Opportunity_TGP__c oppRecord=[select id, name, Enterprise_Solution_Architect_New__c, Enterprise_Solution_Architect_New__r.SFDC_User__c from Opportunity_TGP__c where id=:newid];
          newTask.Opportunity_Name__c=oppRecord.name;          
          Offerings_Master__c offeringMaster=[select id,name from Offerings_Master__c where id=:newProfDetail.Offering_Master__c];
          newTask.Solution_Architect__c=oppRecord.Enterprise_Solution_Architect_New__c;
          newTask.Offering_Name__c=offeringMaster.name;          
          insert newTask;
          newProfDetail.solUserTaskID__c=newTask.id;
          insert newProfDetail;
          newTask.Offering_ID__c=newProfDetail.id;
          upsert newTask;          
        }
        catch(exception ex){
            if(ex.getMessage().contains(UTIL_Constants.INSUFFICIENT_ACCESS)){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Insufficient_access_rights_Cannot_be_Added));
            }
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_Loading_page));
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex.getMessage()));
            }
            return null;
        }
        finally{
            newProfDetail = new Opportunity_Offering__c();
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Added_Successfully)); 
        
        initializeDetailRecordsForOffering();
        opp =[Select name,id,Enterprise_Solution_Architect_New__c from Opportunity_TGP__c where id =:newid];
        if(opp.Size()>0){
        newProfDetail.Solution_Lead_New__c=opp[0].Enterprise_Solution_Architect_New__c;
        }
        oppOffering=UTIL_Constants.NONE;
        refreshPage = true;
        return null;
    }
    //End
    /******************************
    Method Name: getOffering
    Description: Add method to get Offerings only related to Offerings master
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public List<SelectOption> getOffering(){
       List<SelectOption> offerings=new List<SelectOption>();
       List<Offerings_Master__c> offeringMaster=[select id,name from Offerings_Master__c where Active__c=true order by name];
       if(offeringMaster.Size()>0){
          for(Offerings_Master__c c:offeringMaster){
            offerings.add(new SelectOption(c.id, c.name)); 
          }
       }
        return offerings;
    }          
    //End
    
    /******************************
    Method Name: saveAccProfileDetails
    Description: For saving records in Opportunity Offering.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public PageReference saveAccProfileDetails(){

        if(listProfileDetailsActual.size()==0)
          {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.There_is_no_record_to_save));
            return null;
          }
     /* for(Opportunity_Offering__c off : listProfileDetailsActual){
          if(off.Solution_Lead_New__c==null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Offering_Solution_Lead_Primary_cannot_be_left_blank));
             return null;
          }
      }*/
    List<Opportunity_Offering__c> opportunityOffering = new List<Opportunity_Offering__c>();
    opportunityOffering = [Select id,Name, Opportunity_Link__c,Offering_Master__r.Name, Solution_Lead_New__c,Offering_Solution_Lead_Secondary_New__c,Active__c from Opportunity_Offering__c where Opportunity_TGP__c=:newid];
       if(opportunityOffering.Size()>0){
           Opportunity_Offering__c[] profDetailsToUpsert = new Opportunity_Offering__c[]{};
           if(listProfileDetailsActual.Size()>0){
             for(Opportunity_Offering__c dl : listProfileDetailsActual){
                List<Opportunity_Offering__c> oppOfferl= [Select id,Name,Active__c,Opportunity_Link__c,Offering_Master__r.Name,Solution_Lead_New__c,Offering_Solution_Lead_Secondary_New__c From Opportunity_Offering__c where Offering_Master__c= : dl.Offering_Master__c and Opportunity_TGP__c=:newid limit 1];
                if(oppOfferl.size()==1){
                    if(oppOfferl[0].id != dl.id){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Record_Already_Exists_Please_check_the_data));
                        initializeDetailRecordsForOffering();
                        return null;
                    }
                }
             }
             for(Opportunity_Offering__c s1:listProfileDetailsActual){
                for(Opportunity_Offering__c s2:listProfileDetailsActual){
                    if(s1.id!= s2.id){
                        if(s1.Offering_Master__r.Name== s2.Offering_Master__r.Name && s1.Opportunity_TGP__c==newid  && s2.Opportunity_TGP__c==newid ){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Duplication_is_not_Allowed));
                            initializeDetailRecordsForOffering();
                            return null;
                        } 
                    }
                }
            }
         }
       profDetailsToUpsert.addAll(listProfileDetailsActual);
       try {          
          upsert profDetailsToUpsert;

          initializeDetailRecordsForOffering();
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Updated_Successfully));
          //Modifying the Task Details
          List<Solution_User_Task__c> taskExistList=[select id, name, Offering_Name__c from Solution_User_Task__c];        
          for(Opportunity_Offering__c s1 : listProfileDetailsActual)
          {
              for(Solution_User_Task__c task:taskExistList)
              {
                  if(task.id==s1.solUserTaskID__c)
                  {                      
                      task.Offering_Name__c=s1.Offering_Master__r.name;
                      upsert task;
                  }
              }
          } 
       }
       catch(Exception ex) {
          if(ex.getMessage().contains(UTIL_Constants.INSUFFICIENT_ACCESS)){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.You_do_not_have_permission_to_perform_this_action));
          }
          else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_Loading_page));
          }
          return null;
       }
      }
      else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Please_insert_a_record));
      }
      initializeDetailRecordsForOffering();
      refreshPage = true;
      /*PageReference pg=new PageReference('/apex/BPO_Opportunity_tab?Count=1&id='+OppId+'&isVisible=true&tabFocus=tab3');
      pg.setRedirect(true);
      return pg;*/
      return null;
   }
   //End
   /******************************
    Method Name: refreshAccProfilePage
    Description: Method to cancel the page.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public PageReference refreshAccProfilePageInOff(){
        initializeDetailRecordsForOffering();
        refreshPage = true;
        return null;
    }
    //End
    
    /******************************
    Method Name: inputShow
    Description: Method to render input show.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public void inputShow(){
       
        inputShow = true;
       
    }
    //End
     /******************************
    Method Name: deleteFile
    Description: delete link
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference deleteFileForOff()
    {
 
            boolean deletedrecord=false;
            //Iterate through Offering Scope Image            
            
            for(Opportunity_Offering__c oo : [select id,Offering_Master__r.Name, name from Opportunity_Offering__c where Opportunity_TGP__c =:newid and id=:fileIdDelete])
            {

                //To override file from Offering Scope Image.
                try
                {
                   
                    deletedrecord=true;
                    delete oo;
                     
                    if(deletedrecord && oo.Offering_Master__r.Name == 'Procurement'){
                        
                        for(Opportunity_TGP__c opprtunityRec:[SELECT Id, Name, Procurement_Solution_Stage__c,  Number_of_Categories_in_Scope__c, Year_1_Savings_Commitment__c, Addressable_Spend__c FROM Opportunity_TGP__c where Id= :newid]){
                            opprtunityRec.Year_1_Savings_Commitment__c=null;
                            opprtunityRec.Number_of_Categories_in_Scope__c=null;                        
                            opprtunityRec.Prospect_Segmentation__c = null;
                            opprtunityRec.Addressable_Spend__c=null;  
                            opprtunityRec.Procurement_Solution_Stage__c =null;                                        
                            database.update(opprtunityRec);
                       
                       
                        }
                         
                    }
                }
                catch(Exception ex)
                {
                    
                }
                


                // to update the field Service Delivery Location in BPO Opportunity
                utilityClass utilityClassInstance = new utilityClass();
                utilityClassInstance.updateDeliverylocationinOpportunity(newid);
                
                //utilityClass utilityClassInstanceForScheduling = new utilityClass();
                //utilityClassInstance.deleteSchedulingFromOffering(oo.Id);
                                       
            }  
             
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_deleted_successfully));
            initializeDetailRecordsForOffering();
            PageReference pg=new PageReference('/apex/BPO_Opportunity_tab?Count=1&id='+newid+'&isVisible=true&tabFocus=tab3');
            pg.setRedirect(true);
            //return pg;  
            return null; 
         
                  
    }
    
    ///////////////////offerings end//////////////////////////////
    
    ////////key buyer value//////////////////////////
    
    public void keyBuyerValueConstructor(){
        hiddenNavigator1='New';
        addButtonRender = true;
        
        newProfDetailForKeyBuyerValue = new Key_Buyer_Value__c();
        initializeDetailRecordsForKeyBuyerValue();
        hiddenNavigator2='testValue';
        category='Other';
        refreshPage = false;
        keyBuyerMessage=false;  
        if(newid!=null)
        {
            List<Opportunity_TGP__c> lstOpp = [select id, name from Opportunity_TGP__c where id = : newid];
            String strOppId = lstOpp.get(0).id;
            /* UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Key_Buyer_Value__c');            
            addButtonRender = m.get('C');
            saveEditButtonRender = m.get('U');
            deleteButtonRender  = m.get('D'); */
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
    Method Name: initializeDetailRecords
    Description: Added method to initialise all Records.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
     public void initializeDetailRecordsForKeyBuyerValue() {
     hiddenNavigator2=UTIL_Constants.ADD;
        listProfileDetailsActualForKeyBuyerValue = new List<Key_Buyer_Value__c>();
          //SOSL for Key Buyer Values.
            for(Key_Buyer_Value__c profDet : [Select Description__c,Solution_Component__c,Catagory__c,Importance_to_the_client__c, Active__c from Key_Buyer_Value__c where Opportunity_TGP__c=:newid order by createddate desc]) {
                    listProfileDetailsActualForKeyBuyerValue.add(profDet);
            }
    }
    //End
        
    
    /******************************
    Method Name: getCategories
    Description: To get Categories only related to Key Buyer Value Category_Master
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public List<SelectOption> getCategories(){
       List<SelectOption> Categories=new List<SelectOption>();
             for(Key_Buyer_Value_Category_Master__c c:[select id,name from Key_Buyer_Value_Category_Master__c where Active__c=:true order by name]){
                   Categories.add(new SelectOption(c.name, c.name));
             }
       return Categories;
    }
    //End
    
    /******************************
    Method Name: addNewProfDetail
    Description: To add records in Key Buyer Value
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public PageReference addNewProfDetailForKeyBuyerValue() {
        keyBuyerMessage=true;
        hiddenNavigator1=UTIL_Constants.ADD;
        newProfDetailForKeyBuyerValue.Opportunity_TGP__c=newid;
        newProfDetailForKeyBuyerValue.Catagory__c=category;
        
        if(newProfDetailForKeyBuyerValue.Description__c==null)
          {
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Key_Buyer_Value_Description_cannot_be_left_blank));
           return null;
          }
          if(newProfDetailForKeyBuyerValue.Solution_Component__c==null)
          {
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Solution_Component_cannot_be_left_blank));
           return null;
          }
          if(newProfDetailForKeyBuyerValue.Importance_to_the_client__c==null)
          {
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Importance_to_the_client_cannot_be_None_Please_select_another_value));
           return null;
          }
        try{
          insert newProfDetailForKeyBuyerValue;
        }
        catch(exception ex){
            //INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY
            if(ex.getMessage().contains(UTIL_Constants.INSUFFICIENT_ACCESS)){
                keyBuyerMessage=true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.You_do_not_have_permission_to_perform_this_action));
            }
            else{
            keyBuyerMessage=true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_Loading_page));
            }
            return null;
        }
        finally{
            newProfDetailForKeyBuyerValue = new Key_Buyer_Value__c();
            category='Other';
        }
        keyBuyerMessage=true;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Added_Successfully));
        initializeDetailRecordsForKeyBuyerValue();
        refreshPage = true;
        return null;
    }
    //End
    /******************************
    Method Name: saveAccProfileDetailsForKeyBuyerValue
    Description: For saving records in Key Buyer Value.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public PageReference saveAccProfileDetailsForKeyBuyerValue(){
        Key_Buyer_Value__c[] profDetailsToUpsert = new Key_Buyer_Value__c[]{};
        if(listProfileDetailsActualForKeyBuyerValue.size()<=0)
          {
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.There_is_no_record_to_save));
           return null;
          }
         for(Key_Buyer_Value__c keyBuyerDetail : listProfileDetailsActualForKeyBuyerValue){
             
            if(keyBuyerDetail.Description__c==null)
          {
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Key_Buyer_Value_Description_cannot_be_left_blank));
           return null;
          }
          if(keyBuyerDetail.Solution_Component__c==null)
          {
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Solution_Component_cannot_be_left_blank));
           return null;
          }
          if(keyBuyerDetail.Importance_to_the_client__c==null)
          {
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Importance_to_the_client_cannot_be_None_Please_select_another_value));
           return null;
          }
          
          }
        profDetailsToUpsert.addAll(listProfileDetailsActualForKeyBuyerValue);

        try {
            upsert profDetailsToUpsert;
        }
        catch(Exception ex) {
             if(ex.getMessage().contains(UTIL_Constants.INSUFFICIENT_ACCESS)){
                   keyBuyerMessage=true;
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.You_do_not_have_permission_to_perform_this_action));
                   //return null;
               }else {
               keyBuyerMessage=true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Please_select_the_required_fields));
            }
            return null;
        }
        initializeDetailRecordsForKeyBuyerValue();
        keyBuyerMessage=true;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Updated_Successfully));
        refreshPage = true;
        return null;
    }
    //End
     /******************************
    Method Name: refreshAccProfilePage
    Description: Method to cancel the page.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public PageReference refreshAccProfilePageForKeyBuyerValue(){
        initializeDetailRecordsForKeyBuyerValue();
        refreshPage = true;
        return null;
    }
    //End
     /******************************
    Method Name: deleteFile
    Description: delete link
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference deleteFileForKeyBuyerValue()
    {
        
        //Iterate through Offering Scope Image
        for(Key_Buyer_Value__c  kbv : [select id, name from Key_Buyer_Value__c where Opportunity_TGP__c =:newid and id=:fileIdDelete])
        {
                delete kbv; 
                      
        }    
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_deleted_successfully));
        initializeDetailRecordsForKeyBuyerValue();        
        return null;
    }
    
    ///////key buyer value////////////////
    
    
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
        opportunity1.Enterprise_Solution_Architect_New__c=null;
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
        NewValue1=true;
        NewValue2=false;
        NewValue3=false;
        NewValue4=false;
        displayButton=true;
        opportunity1.SAP_OM_Opportunity__c=null;
        opportunity1.Client_Geo_Area__c=clientGeoAreaMaster;
        if(clientGeoUnitMaster==UTIL_Constants.NONE)
            {  
            opportunity1.Client_Geo_Unit__c =null;  
            }
            else
            {
                opportunity1.Client_Geo_Unit__c =clientGeoUnitMaster; 
            }  
        opportunity1.Operating_Group__c=operatingGroupMaster;
        //system.debug('====='+estimateTCV );
        //system.debug('====='+opportunity1.estimated_tcv__c);
        estimateTCVSAP = estimateTCV; 
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
         //Added for defect D-1457
         if(Option==UTIL_Constants.YES){
         
         opp = new List<Opportunity_TGP__c>();
           for(Opportunity_TGP__c oppty : [Select id,SAP_OM_Opportunity__c from Opportunity_TGP__c])
           {
                //Check for Duplicate SAP OM ID
                if(newid!=null)
                {
                    if(opportunity1.SAP_OM_Opportunity__c ==oppty.SAP_OM_Opportunity__c && oppty.SAP_OM_Opportunity__c!=null && newid != oppty.id)
                    {
                    
                      NewValue4=false;
                    
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Opportunity_with_same_SAP_OM_ID_is_already_present));
                        return null;
                    }
                }
                else
                {
                    if(opportunity1.SAP_OM_Opportunity__c ==oppty.SAP_OM_Opportunity__c && oppty.SAP_OM_Opportunity__c!=null)
                    {
                       NewValue4=false;
                    
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Opportunity_with_same_SAP_OM_ID_is_already_present));
                        return null;
                    }
                }
            }
          }
         //Logic when Option =Yes
         if(Option==UTIL_Constants.YES){
            if(opportunity1.SAP_OM_Opportunity__c==null){
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access rights: Cannot be Updated'));
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.SAP_OM_ID_cannot_be_left_blank));
                
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
            for(SAP_OM_Opportunity__c sap:[select Opportunity_Name__c,Service_Group__c,TCV__c,IS_Net_Revenue__c,Activity__c,Competitive_Sole_Source__c,Client_Geo_Area__c,Geography__c,Client_Geo_Unit__c,Client_Name__c,Expected_contract_sign_Quarter__c,Operating_Group__c,Competitor__c,Win_Probability__c,Pricing_Type__c,Stage__c,
                                                  Client_Account_Lead__c,Client_QA_Director__c,Delivery_Lead_BPO__c,Global_Client_Account_Lead__c,Managing_Director_MC__c,Mobilization_Lead__c,Opportunity_Contact__c,Opportunity_QA_Director__c,Sales_Origination__c,Third_party_Advisors__c,
                                                  Sales_Capture_Opp_Director__c,Sales_Capture_OSL__c,Sales_Capture_Other__c,Solution_Arch_BPO__c,Technology_Account_Lead__c from SAP_OM_Opportunity__c where id=:opportunity1.SAP_OM_Opportunity__c])
            {
                opportunity1.Client_Name__c=sap.Client_Name__c;
                opportunity1.Name=sap.Opportunity_Name__c;
                opportunity1.Stage__c=sap.Stage__c;
                opportunity1.Expected_contract_sign_qtr__c=sap.Expected_contract_sign_Quarter__c;
                //clientGeoAreaMaster = sap.Client_Geo_Area__c;  
                
                if(!mapClientGeoAreaMaster.isEmpty() && sap.Geography__c != null)
                {
                    if(mapClientGeoAreaMaster.get(sap.Geography__c) != null)
                    {
                        opportunity1.Client_Geo_Area__c = mapClientGeoAreaMaster.get(sap.Geography__c);
                    }                           
                }
                
                clientGeoUnitMaster = sap.Client_Geo_Unit__c;  
                operatingGroupMaster= sap.Operating_Group__c;  
                
                //opportunity1.Client_Geo_Area__c=sap.Client_Geo_Area__c;
                clientGeoAreaMaster = opportunity1.Client_Geo_Area__c;
                opportunity1.Client_Geo_Unit__c=sap.Client_Geo_Unit__c;
                opportunity1.Operating_Group__c=sap.Operating_Group__c; 
                opportunity1.Activity__c=sap.Activity__c;
                opportunity1.TCV__c=sap.TCV__c; 
                opportunity1.Estimated_TCV__c=sap.TCV__c;
                
                opportunity1.IS_Net_Revenue_SAP__c=sap.IS_Net_Revenue__c; 
                opportunity1.IS_Net_Revenue_SD_Estimate__c=sap.IS_Net_Revenue__c;
                
                opportunity1.Competitors__c =sap.Competitor__c;
                opportunity1.Win_Probability__c=sap.Win_Probability__c;
                opportunity1.Pricing_Type__c=sap.Pricing_Type__c;
                opportunity1.Competitive_Sole_Source__c=sap.Competitive_Sole_Source__c;
                opportunity1.Third_party_Advisors__c=sap.Third_party_Advisors__c;
                opportunity1.Service_Group__c=sap.Service_Group__c;
                
                if(listOppSapTeam.size()>0) {
                    listOppSapTeam[0].Client_Account_Lead__c =  sap.Client_Account_Lead__c;
                    listOppSapTeam[0].Client_QA_Director__c =  sap.Client_QA_Director__c;
                    listOppSapTeam[0].Delivery_Lead_BPO__c =  sap.Delivery_Lead_BPO__c;
                    //listOppSapTeam[0].Due_Diligence_Lead__c =  sap.Due_Diligence_Lead__c;
                    listOppSapTeam[0].Global_Client_Account_Lead__c =  sap.Global_Client_Account_Lead__c;
                    listOppSapTeam[0].Managing_Director_MC__c =  sap.Managing_Director_MC__c;
                    listOppSapTeam[0].Mobilization_Lead__c =  sap.Mobilization_Lead__c;
                    listOppSapTeam[0].Opportunity_Contact__c =  sap.Opportunity_Contact__c;
                    listOppSapTeam[0].Opportunity_QA_Director__c =  sap.Opportunity_QA_Director__c;
                    listOppSapTeam[0].Sales_Origination__c =  sap.Sales_Origination__c;
                    listOppSapTeam[0].Sales_Capture_Opp_Director__c =  sap.Sales_Capture_Opp_Director__c;
                    listOppSapTeam[0].Sales_Capture_OSL__c =  sap.Sales_Capture_OSL__c;
                    listOppSapTeam[0].Sales_Capture_Other__c =  sap.Sales_Capture_Other__c;
                    listOppSapTeam[0].Solution_Arch_BPO__c =  sap.Solution_Arch_BPO__c;
                    listOppSapTeam[0].Technology_Account_Lead__c =  sap.Technology_Account_Lead__c;
                }
                
                else {
                    oppSapTeam.BPO_Opp__c = opportunity1.Id;
                    oppSapTeam.Client_Account_Lead__c =  sap.Client_Account_Lead__c;
                    oppSapTeam.Client_QA_Director__c =  sap.Client_QA_Director__c;
                    oppSapTeam.Delivery_Lead_BPO__c =  sap.Delivery_Lead_BPO__c;
                    //oppSapTeam.Due_Diligence_Lead__c =  sap.Due_Diligence_Lead__c;
                    oppSapTeam.Global_Client_Account_Lead__c =  sap.Global_Client_Account_Lead__c;
                    oppSapTeam.Managing_Director_MC__c =  sap.Managing_Director_MC__c;
                    oppSapTeam.Mobilization_Lead__c =  sap.Mobilization_Lead__c;
                    oppSapTeam.Opportunity_Contact__c =  sap.Opportunity_Contact__c;
                    oppSapTeam.Opportunity_QA_Director__c =  sap.Opportunity_QA_Director__c;
                    oppSapTeam.Sales_Origination__c =  sap.Sales_Origination__c;
                    oppSapTeam.Sales_Capture_Opp_Director__c =  sap.Sales_Capture_Opp_Director__c;
                    oppSapTeam.Sales_Capture_OSL__c =  sap.Sales_Capture_OSL__c;
                    oppSapTeam.Sales_Capture_Other__c =  sap.Sales_Capture_Other__c;
                    oppSapTeam.Solution_Arch_BPO__c =  sap.Solution_Arch_BPO__c;
                    oppSapTeam.Technology_Account_Lead__c =  sap.Technology_Account_Lead__c;
                }
                  
            }
            estimateTCVSAP = opportunity1.Estimated_TCV__c;
            estimateISTCVSAP= opportunity1.IS_Net_Revenue_SD_Estimate__c;
        }
        //Logic when option is No
        else if(Option==UTIL_Constants.NO)
        {
            
            NewValue1=false;
            NewValue2=true;
            NewValue3=true;
            NewValue4=true;
            clientGeoAreaMaster= opportunity1.Client_Geo_Area__c;  
            clientGeoUnitMaster=opportunity1.Client_Geo_Unit__c;  
            operatingGroupMaster=opportunity1.Operating_Group__c; 
            //estimateTCV = opportunity1.TCV__c;             
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
        qtrName.add(new SelectOption(UTIL_Constants.NONE,UTIL_Constants.NONE_FOR_PICKLIST));
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
              if(!c.name.equals(UTIL_Constants.EALA))
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
       clientGeoUnit.add(new SelectOption(UTIL_Constants.NONE,UTIL_Constants.NONE_FOR_PICKLIST)); 
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
    {    system.debug('In Save Record');
        opportunity1.SAP_OM_ID_available_Y_N_del__c=Option;
       Opportunity_TGP__c existOppRecord = [select id, Activity__c,SAP_OM_Opportunity__r.name,Name,Client_Name__r.name from Opportunity_TGP__c where id=:newid];
       
        //Check for null
        if(opportunity1.Client_Name__c==null)
        {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Client_Name_cannot_be_left_blank));
             return null;
        }
        if(opportunity1.Name==null || opportunity1.Name=='')
        {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Opportunity_Name_cannot_be_left_blank));
             return null;
        }        
        if(opportunity1.Stage__c==null || opportunity1.Stage__c=='')
        {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Stage_cannot_be_None_Please_select_another_value));
             return null;
        }
        if(clientGeoAreaMaster==UTIL_Constants.NONE_FOR_PICKLIST)
        {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Client_Geo_Area_cannot_be_None_Please_select_another_value));
             return null;
        }
        /*if(clientGeoUnitMaster=='--None--')
        {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Client Geo Unit cannot be None. Please select another value'));
             return null;
        }*/
        if(operatingGroupMaster==UTIL_Constants.NONE_FOR_PICKLIST)
        {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Operating_Group_cannot_be_None_Please_select_another_value));
             return null;
        }
        //Check for null
         if(opportunity1.Activity__c==null || opportunity1.Activity__c=='')
        {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Reporting_Status_cannot_be_None_Please_select_another_value));
             return null;
        }
        
        
        
        /*if(opportunity1.Activity__c=='Pipeline' && existOppRecord.Activity__c=='Unqualified' && newid!=null){
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           String senderId='geetesh.sanodia@accenture.com';//sapna.r.rao@accenture.com
           mail.setUseSignature(false);
           mail.setToAddresses(new String[] {senderId});
           mail.setSubject('NOTIFICATION: Opportunity Record Reporting Status has been Changed ');
           mail.setHtmlBody('<span style="font-size:11pt; font-family:Calibri">The BPO Opportunity Reporting Status has been Changed.'+
           '<br> '+
           +'<br> '+'SAP OM ID: '+(existOppRecord.SAP_OM_Opportunity__r.name==null ? '':existOppRecord.SAP_OM_Opportunity__r.name)+
            '<br> '+
           +'<br> '+'Opportunity Name: '+existOppRecord.Name+ 
            '<br> '+
           +'<br> '+'Client Name: CAIRN INDIA : '+existOppRecord.Client_Name__r.name+
            '<br> '+
           +'<br> '+'Reporting Status : '+existOppRecord.Activity__c +' to '+ opportunity1.Activity__c+'</span>');
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        
        
        }*/
        
       
        
        //Check for null
        if(opportunity1.Risk_Level__c==null)
        {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Risk_Level_cannot_be_None_Please_select_another_value));
             return null;
        }
        if(opportunity1.Service_Group__c==null)
        {
             //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Ye Error Message hai!'));
             return null;
        }
        if(opportunity1.Enterprise_Solution_Architect_New__c==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Opportunity_Solution_Lead_cannot_be_left_blank));
             return null;
        }
        if(Option==UTIL_Constants.YES)
        {
        
            if(opportunity1.Tcv__c >= 1000000)
            {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'BPO Net Revenue (SAP OM)(Thousands) : Please enter less than $1B'));
                 if(estimateTCVSAP >= 1000000)
                 {
                     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'BPO Net Revenue (SD Estimate) equal to BPO Net Revenue : Please enter less than $1B'));
                     return null;
                 }
                 return null;
            }
            if(estimateTCVSAP >= 1000000)
            {
                 
                     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'BPO Net Revenue (SD Estimate) equal to BPO Net Revenue : Please enter less than $1B'));
                     return null;
    
            }
            
            try
            {
                if(opportunity1.SAP_OM_Opportunity__c==null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.SAP_OM_ID_cannot_be_left_blank));
                return null;
                } 
                
                if(newid!=null)
                {
                       //system.debug('=========' + opportunity1);
                       //Added to prevent duplicate opportunity with SAP OM ID.
                       /*opp = new List<Opportunity_TGP__c>();
                       for(Opportunity_TGP__c oppty : [Select id,SAP_OM_Opportunity__c from Opportunity_TGP__c]){
                            //Check for Duplicate SAP OM ID
                            if(opportunity1.SAP_OM_Opportunity__c ==oppty.SAP_OM_Opportunity__c && oppty.SAP_OM_Opportunity__c!=null  ){
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Opportunity with same SAP OM ID is already present'));
                                return null;
                            }
                       }*/
                     //Iterate through SAP OM Opportunity.
                    for(SAP_OM_Opportunity__c sap:[select Opportunity_Name__c,Service_Group__c,Competitive_Sole_Source__c,Competitor__c,Pricing_Type__c,Win_Probability__c,Capital_Project_Mgmt_Total_Net_Rev_perc__c,Care_Management_Total_Net_Rev_perc__c,Customer_Contact_Total_Net_Rev_perc__c,
                                                    Emerging_Cross_Industry_Total_Net_Rev_pe__c,Emerging_Industry_Specific_TotNet_Rev_pe__c,Finance_Accounting_Total_Net_Rev_perc__c,
                                                    Health_Administration_Total_Net_Rev_perc__c,Human_Resources_Total_Net_Revenue_perc__c,Insurance_Total_Net_Revenue_perc__c,
                                                    Learning_Total_Net_Revenue_perc__c,Marketing_Total_Net_Revenue_perc__c,Credit_Services_Total_Net_Revenue_perc__c,
                                                    Network_Services_Total_Net_Revenue_perc__c,Pharmaceuticals_Total_Net_Revenue_perc__c,Procurement_Total_Net_Revenue_perc__c,
                                                    Supply_Chain_Total_Net_Revenue_perc__c,Utilities_Total_Net_Revenue_perc__c,Max_Offering_Name__c,TCV__c,IS_Net_Revenue__c,Activity__c,Client_Geo_Area__c,Client_Geo_Unit__c,Client_Name__c,Expected_contract_sign_Quarter__c,Operating_Group__c,Stage__c from SAP_OM_Opportunity__c where id=:opportunity1.SAP_OM_Opportunity__c])
                    {
                        opportunity1.Client_Name__c=sap.Client_Name__c;
                        opportunity1.Name=sap.Opportunity_Name__c;
                        opportunity1.Stage__c=sap.Stage__c;
                        opportunity1.Expected_contract_sign_qtr__c=sap.Expected_contract_sign_Quarter__c;
                        //opportunity1.Client_Geo_Area__c=sap.Client_Geo_Area__c;
                        opportunity1.Client_Geo_Unit__c=sap.Client_Geo_Unit__c;
                        opportunity1.Operating_Group__c=sap.Operating_Group__c; 
                        opportunity1.Activity__c=sap.Activity__c;
                        opportunity1.TCV__c=sap.TCV__c;    
                        opportunity1.IS_Net_Revenue_SAP__c=sap.IS_Net_Revenue__c;                  
                        opportunity1.Competitors__c =sap.Competitor__c;
                                opportunity1.Win_Probability__c=sap.Win_Probability__c;
                                opportunity1.Pricing_Type__c=sap.Pricing_Type__c;
                                opportunity1.Competitive_Sole_Source__c=sap.Competitive_Sole_Source__c;
                                //opportunity1.Service_Group__c=sap.Service_Group__c;
                                
                                system.debug('====sap.Service_Group__c=====' + sap.Service_Group__c);
                        
                     }
                    //Update Opportunity records.
                    system.debug('====opportunity1.Service_Group__c=====' + opportunity1.Service_Group__c);
                    opportunity1.Estimated_TCV__c = estimateTCVSAP ;
                    opportunity1.IS_Net_Revenue_SD_Estimate__c = estimateISTCVSAP ;
                    system.debug('=========' + opportunity1);
                    update opportunity1;
                    system.debug('=========' + opportunity1);
                    if(listOppSapTeam.size() == 0)
                    {
                       Database.insert(oppSapTeam); 
                    }
                    else {
                        Database.upsert(listOppSapTeam);
                    }
                    
                }
                else
                {
                  
                    //Insert Opportunity when Edit record of Opportunity detail page.
                    insert opportunity1;      
                }
            }
            catch(Exception ex)
            {
               if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                   
                   //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.You_do_not_have_permission_to_perform_this_action));
                   return null;
               } 
               else if(ex.getMessage().contains(UTIL_Constants.UPDATE_FAILED)){
                   
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.You_do_not_have_permission_to_perform_this_action));
                   return null;
               }
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Error_in_Saving));
               return null;
            }  
        }
        //Logic for Option No
        if(Option=='No')
        {
        
            if(opportunity1.Tcv__c >= 1000000)
            {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'BPO Net Revenue (SAP OM)(Thousands) : Please enter less than $1B'));
                 if(estimateTCV >= 1000000)
                 {
                     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'BPO Net Revenue (SD Estimate) equal to BPO Net Revenue : Please enter less than $1B'));
                     return null;
                 }
                 return null;
            }
            if(estimateTCV >= 1000000)
            {
                 
                     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'BPO Net Revenue (SD Estimate) equal to BPO Net Revenue : Please enter less than $1B'));
                     return null;
    
            }
            opportunity1.Client_Geo_Area__c=clientGeoAreaMaster;
            opportunity1.Estimated_TCV__c = estimateTCV;
            opportunity1.IS_Net_Revenue_SAP__c = estimateISTCV;
            if(clientGeoUnitMaster==UTIL_Constants.NONE)
            {  
            opportunity1.Client_Geo_Unit__c =null;  
            }
            else
            {
                opportunity1.Client_Geo_Unit__c =clientGeoUnitMaster; 
            }
            opportunity1.Operating_Group__c=operatingGroupMaster; 
            //Code for Checking the Valid Quarter--Starts-By Mayank Tayal
            if(quarterName==UTIL_Constants.NONE)
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
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Please_select_the_valid_Expected_contract_sign_Quarter));
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
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Please_select_the_valid_Expected_contract_sign_Quarter));
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
                }
            }
            catch(Exception ex)
            {
               if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                   
                   //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.You_do_not_have_permission_to_perform_this_action));
                   return null;
               } 
               else if(ex.getMessage().contains(UTIL_Constants.UPDATE_FAILED)){
                   
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.You_do_not_have_permission_to_perform_this_action));
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
        flag =true;
        flagEdit = false;
        return null;  
           
    } 
    
    /******************************
    Method Name: saverecordOtherCharacteristics 
    Description: To Save whichever is updating from master in Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void saverecordOtherCharacteristics()
    {
        
        
      try
      {
          upsert opportunity1;
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,system.Label.Record_Added_Successfully));
      }
      catch(Exception ex)
      {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+ex.getMessage()));
      }          
    return;
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
        bcpValue=opportunity1.BCP_Value__c;
        opportunity1.Client_Geo_Area__c=clientGeoAreaMaster;  
        if(clientGeoUnitMaster==UTIL_Constants.NONE)
            {  
            opportunity1.Client_Geo_Unit__c =null;  
            }
            else
            {
                opportunity1.Client_Geo_Unit__c =clientGeoUnitMaster; 
            }  
         
        opportunity1.Operating_Group__c=operatingGroupMaster;  
        flagOtherChar = false;
        flagEditOtherChar = true;
        
    }
    /******************************
    Method Name: Edit1
    Description: To Edit Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void edit1()
    {
        
        opportunity1.Client_Geo_Area__c=clientGeoAreaMaster; 
        if(clientGeoUnitMaster== UTIL_Constants.NONE)
            {  
            opportunity1.Client_Geo_Unit__c =null;  
            }
            else
            {
                opportunity1.Client_Geo_Unit__c =clientGeoUnitMaster; 
            }   
        
        opportunity1.Operating_Group__c=operatingGroupMaster;  
        flag = false;
        flagEdit = true;
        toDisplayCommentSection = false;

    }
    public void editForOppTimeLine()
    {
        flagOppTimeLine = false;
        flagEditOppTimeLine = true;        
    }
     /******************************
    Method Name: cancelRecord
    Description: To cancel RecordOpportunity records.
    Paramenters: Void
    Return Value: NA
    *******************************/ 
    public void cancelRecord()
    {
            
            flag =true;
            flagEdit = false;
            PageReference pr;
            toDisplayCommentSection = true;  
            pr=new PageReference('/'+opportunity1.id);
            pr.setRedirect(true);
           
         
    }
    
         
    /******************************
    Method Name: pagerefresh
    Description: Refresh othercharacteristics
    Paramenters: NA
    Return Value: NA
    *******************************/  

    public PageReference pagerefresh(){
                PageReference pg=new PageReference('/apex/BPO_Opportunity_tab?id='+pageid+'&Count=1&tabFocus=tab5&isVisible=true');
               
                pg.SetRedirect(true);
                tabFocus= 'tab5';
                return pg;
    }
    
    public List<SelectOption> getstatusOptionsForOffering() {
        
        List<SelectOption> offerings=new List<SelectOption>();
       List<Offerings_Master__c> offeringMaster=[select id,name from Offerings_Master__c where Active__c=true order by name];
       offerings.add(new SelectOption(UTIL_Constants.NONE, UTIL_Constants.NONE_FOR_PICKLIST)); 
       if(offeringMaster.Size()>0){
          for(Offerings_Master__c c:offeringMaster){
            
            offerings.add(new SelectOption(c.name, c.name)); 
          }
       }
        return offerings;
      
  }
    
    public List<SelectOption> getstatusOptionsForSubOffering() {
        
      
       List<SelectOption> subOfferings=new List<SelectOption>();
       //Iterate through Service Master
       List<Analytics_Sub_Offering_Master__c> subOfferingMasterList = new List<Analytics_Sub_Offering_Master__c>();
       //serviceMasterList= [select id,name,Offering__r.Name from Service_Master__c where Offering__r.Name=:opportunity1.Analytics_Offering__c and Active__c=:true order by name];
       subOfferingMasterList= [select id,name,Analytics_Sub_Offering_Name__c,Offering__r.Name 
                                from Analytics_Sub_Offering_Master__c where Offering__r.name=:StatusSelectForOffering and Active__c=:true order by name];  
       //services.add(new SelectOption('None', '--None--'));
       subOfferings.add(new SelectOption(UTIL_Constants.None, UTIL_Constants.NONE_FOR_PICKLIST));
       if(subOfferingMasterList.size()>0)
       {
           for(Analytics_Sub_Offering_Master__c c:subOfferingMasterList)
           { 
                   subOfferings.add(new SelectOption(c.Analytics_Sub_Offering_Name__c, c.Analytics_Sub_Offering_Name__c));              
           }
       }
       /*else
       {
           subOfferings.add(new SelectOption('None', '--None--')); 
       }*/
        
       return subOfferings;
    }
    
    /******************************
    Method Name: saverecord
    Description: To save Opportunity records.
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public void saverecordForOtherCharecteristics()
    {    

      
        opportunity1.BCP_Value__c=bcpValue;  
        opportunity1.Analytics_Offerings__c = StatusSelectForOffering;
        opportunity1.Analytics_Sub_Offering__c = StatusSelectForSubOffering;
        
        
        //Validation for None
        if(opportunity1.Analytics_in_Scope__c == UTIL_Constants.NO)
        {
                
            StatusSelectForOffering = null;
            StatusSelectForSubOffering = null;
            opportunity1.Analytics_Total_Revenue_thousands__c = null;
            opportunity1.Analytics_YTD_Revenue_thousands__c = null;
            opportunity1.Analytics_Deal_Classification__c = null;
            opportunity1.Analytics_Pipeline_Source__c = null;
            opportunity1.Analytics_Commercial_Arrangement__c = null;
            opportunity1.Analytics_RAG_Status__c = null;
            opportunity1.Analytics_Solution_Lead__c = null;
            opportunity1.Analytics_Functional_Architect__c = null;
            opportunity1.Analytics_Offerings__c = UTIL_Constants.NONE_FOR_PICKLIST;
            opportunity1.Analytics_Sub_Offering__c = UTIL_Constants.NONE_FOR_PICKLIST;
            opportunity1.Transition_start_Date__c = null;
            opportunity1.Delivery_Location__c = null;
            opportunity1.FTE_count__c = null;
            opportunity1.Analytics_Total_CCI__c = null;
            opportunity1.Analytics_Delivery_Lead__c = null;
        }
        if(opportunity1.Capacity_Services_in_Scope__c == UTIL_Constants.NO)
        {   
            opportunity1.Talent_Segment_items__c = null;      
        }
        
        if(opportunity1.Capacity_Services_in_Scope__c == UTIL_Constants.NO)
        {
            
            opportunity1.Talent_Segment_items__c = null;          
        }

        if(opportunity1.BSS_SC__c==null)    
          {
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.BSS_SC_value_cannot_be_None_Please_select_another_value));
           return;
          }
         if(opportunity1.BSS_SM__c==null)
            {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.BSS_SM_value_cannot_be_None_Please_select_another_value));
            return;
            }
         if(opportunity1.BSS_EDM__c==null)
            {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.BSS_EDM_value_cannot_be_None_Please_select_another_value));
            return;
            }
        if(opportunity1.BSS_Command_Center__c==null)
            {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.BSS_Command_center_value_cannot_be_None_Please_select_another_value));
            return;
            }
        if(opportunity1.BPO_Tech__c==null)
            {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.BPO_tech_value_cannot_be_None_Please_select_another_value));
            return;
            }
        /*if(role.size()>0)
                {
                    if(role[0].name!=null && role[0].name.equalsIgnoreCase(UTIL_Constants.OPERATION_ROLE))
                         {
                          if(opportunity1.Deal_in_BPOSE__c==null)
                            {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Deal_in_BPOSE_value_cannot_be_None_Please_select_another_value));
                            return;
                            }
                         }
                }*/
                
            if(profileList.size()>0) {
                if(profileList[0].name.equalsIgnoreCase(System.Label.PMO_Profile) ) {
                    if(opportunity1.Deal_in_BPOSE__c==null)
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Deal_in_BPOSE_value_cannot_be_None_Please_select_another_value));
                        return;
                    }
                }
            }    
             
        // Validation for none finish       
        try
        {
            if(opportunity1.Stage__c!=null || opportunity1.Activity__c!=null || opportunity1.Risk_Level__c!=null )
            {
            upsert opportunity1;   
            flagOtherChar =true;
            flagEditOtherChar = false; 
            }
            else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.Mandatory_fields_cannot_be_blank_in_General_Information_Section_Stage_Activity));
            
            //listopportunity1= new List<Opportunity_TGP__c>();            
            opportunity1=new Opportunity_TGP__c();
            }
          
        }
        catch(Exception ex)
        {
            if(ex.getMessage().contains(UTIL_Constants.UPDATE_FAILED))
            {
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,system.Label.You_do_not_have_permission_to_perform_this_action));
                   return;
            }
        }  
        
   }
    /******************************
    Method Name: starting
    Description: Action function to load image
    Paramenters: Void
    Return Value: NA
    *******************************/ 
    public void starting(){
     flagImage = true;
    }
    /******************************
    Method Name: ending
    Description: Action function to stop image
    Paramenters: Void
    Return Value: NA
    *******************************/ 
    public void ending(){
    flagImage = false;
    }
    /******************************
    Method Name: getOfferings
    Description: Refresh Offerings
    Paramenters: NA
    Return Value: NA
    *******************************/  

    public PageReference getOfferings(){
    Opportunity_Offering__c newProfDetail = new Opportunity_Offering__c();
     opp =[Select name,id,Enterprise_Solution_Architect_New__c from Opportunity_TGP__c where id =:newid];
     if(opp.Size()>0){
        newProfDetail.Solution_Lead_New__c=opp[0].Enterprise_Solution_Architect_New__c;
     }
              /*  PageReference pg=new PageReference('/apex/BPO_Opportunity_tab?id='+newid+'&Count=1&tabFocus=tab3&isVisible=true');
                pg.SetRedirect(true);
                tabFocus= 'tab3';
                return pg;
      tabFocus= 'tab3';
      Count = 1;*/
      return null;  
    }
    /******************************
    Method Name: getOfferingsOnGeneralInfo
    Description: Refresh Offerings
    Paramenters: NA
    Return Value: NA
    *******************************/  

    public PageReference getOfferingsOnGeneralInfo(){
        PageReference pg=new PageReference('/apex/BPO_Opportunity_tab?id='+newid+'&Count=1&tabFocus=tab0&isVisible=true');
        pg.SetRedirect(true);
        tabFocus= UTIL_Constants.TAB_0;
        return pg;
    }
     /**
     * Added for Governance data
     * */
    public PageReference governanceDataTab(){
        PageReference pt=new PageReference('/apex/Governance_Data_Page?id='+newid);
        pt.setRedirect(true);
        return pt;    
    }
    

}