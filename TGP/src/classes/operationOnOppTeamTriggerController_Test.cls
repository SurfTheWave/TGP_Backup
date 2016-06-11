/*
  @Author: 
  @Name: operationOnOppTeamTriggerController_Test Test class
  @Created Date: 
  @Description:  Test Class for operation On Opportunity Team Trigger
  @version: 1.0  
*/
@isTest
private class operationOnOppTeamTriggerController_Test{

    private static Opportunity opp;
    private static Opportunity_Roles_Master__c oppRoleMaster;
    private static Opportunity_Roles_Master__c oppRoleMasterCCA;
    private static Opportunity_Roles_Master__c oppRoleMasterSS;
    private static Opportunity_Roles_Master__c oppRoleMasterOSL;
    private static Opportunity_Roles_Master__c oppRoleMasterOSLPrimry;
    private static Opportunity_Roles_Master__c oppRoleMasterSDGov;
    private static Opportunity_Roles_Master__c oppRoleMasterOSLP ;
    private static Opportunity_Roles_Master__c oppRoleMasterOSLS;
    private static Opportunity_Roles_Master__c oppRoleMasterMA ;
    private static Opportunity_Roles_Master__c oppRoleMasterTA ;
    private static Solution_Scope__c solCompBPO;
    private static Opportunity_Roles_Master__c oppRoleMasterOSLSec;
    private static Opportunity_Roles_Master__c oppRoleMasterPrimeSDO;
    private static Opportunity_Roles_Master__c oppRoleMasterCommteam;
    private static Opportunity_Roles_Master__c oppRoleMasterOSLP1;
    
    
    private static List<Opportunity_Teams__c> oppTeamLst;
    private static List<Opportunity_Teams__c> oppTeamLstNew;
     private static List<Opportunity_Teams__c> oppTeamLstNew2;
    private static Opportunity_Teams__c oppTeam;
    private static Opportunity_Teams__c oppTeamNew;
    private static Opportunity_Teams__c oppTeamCCA;
    private static Opportunity_Teams__c oppTeamSS;
    private static Opportunity_Teams__c oppTeamOSL;
    private static Opportunity_Teams__c oppTeamSDGov;
    private static Opportunity_Teams__c oppTeamPrimeTA ;
    
    private static Opportunity_Teams__c oppTeamOSLP;
    private static Opportunity_Teams__c oppTeamOSLS;
    private static User_Master__c testUserMaster;
    private static Opportunity_Teams__c oppTeamComm;
    
    private static Opportunity_Teams__c oppTeamOSlPri;
    private static Opportunity_Teams__c oppTeamOSlSec;
    private static Opportunity_Teams__c oppTeamPrimeSDO;
    
    private static User stdUser;
    
/*
  @Author: 
  @Name: setupUser
  @Created Date: 01 January 2015
  @Description: This is a static method for user data setup.
  @version: 1.0
*/
    public static void setupUser(){
        
            stdUser = UtilNovaUnitTest.getUser();
            
    }
     /**
     * @Description : Creating Test Data.
     * @param : NA
     * @return parameter : void
     * @throws exception: DML Exception
     */
    public static void setupData(){
        
        setupUser();
        test.startTest();
        insert stdUser;
        test.stopTest();
        oppTeamLst = new List<Opportunity_Teams__c>();
        oppTeamLstNew = new List<Opportunity_Teams__c>();
        
        Operating_Groups_Master__c oppGrpMaster = new Operating_Groups_Master__c(Name = 'TestOpperatingGroup', Active__c = true);
        insert oppGrpMaster;   
        
        oppRoleMaster = new Opportunity_Roles_Master__c(Name = Label.Complex_Cost_Architect,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMaster;
        
        oppRoleMasterCCA = new Opportunity_Roles_Master__c(Name = Label.Complex_Cost_Architect,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterCCA;
        
        oppRoleMasterSS = new Opportunity_Roles_Master__c(Name = Label.Solution_Specialist,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterSS;
        
        Email_Template__c emailTemplateRec = new Email_Template__c(name = UtilConstants.BPO_USER,ID__c='00XtabiwertDtSv');
            insert emailTemplateRec;
        
        opp = new Opportunity();
        opp.OperatingGroup__c = OppGrpMaster.id;
        opp.name= UtilConstants.TEST_OPP;
        opp.Geo_Area__c= UTIL_Constants.AsiaPacific;
        opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
        opp.StageName= UtilConstants.OA;
        opp.Risk_Level__c= UtilConstants.LOW;
        opp.SG_Dev__c = UtilConstants.IO;
        opp.SD_Covered__c = UtilConstants.YES;
        opp.Staffing_Status__c = UtilConstants.ASSIGNED;
        opp.IO_Net_Revenue_Thousands__c = 100;
        opp.CloseDate= date.newInstance(2001, 3, 21);
        opp.Industry_Business_Services__c = 'BNK-CREDIT';
        insert opp;
        
            
            testUserMaster = new User_Master__c();
            testUserMaster.Name = stdUser.name;
            testUserMaster.user__c = stdUser.Id;
            insert testUserMaster;
        
            oppTeam = new Opportunity_Teams__c();
            oppTeam.Opportunity__c = opp.Id;
            oppTeam.Role__c = oppRoleMaster.id;
            oppTeam.Opportunity_Team_Member__c = testUserMaster.Id;
            oppTeam.Request_Team_Member__c = true;
            oppTeam.Team_Member_Request_Status__c = UtilConstants.IN_PROGRESS;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeam.Assigned_Date__c = System.today(); 
            oppTeam.Requestor__c  = testUserMaster.Id;

            insert oppTeam;
            
            oppTeamLst.add(oppTeam);
            
            oppTeamNew = new Opportunity_Teams__c();
            oppTeamNew.Opportunity__c = opp.Id;
            oppTeamNew.Role__c = oppRoleMaster.id;
            oppTeamNew.Opportunity_Team_Member__c = testUserMaster.Id;
            oppTeamNew.Request_Team_Member__c = true;
            oppTeamNew.Team_Member_Request_Status__c = UtilConstants.IN_PROGRESS;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamNew.Assigned_Date__c = System.today(); 
            oppTeamNew.Requestor__c  = testUserMaster.Id;

            insert oppTeamNew;
            
         oppTeamNew.Role__c  = oppRoleMasterSS.id;
            update oppTeamNew;
            
            oppTeamLstNew.add(oppTeamNew);
 
    }
    /**
     * @Description : Creating Test Data.
     * @param : NA
     * @return parameter : void
     * @throws exception: DML Exception
     */
    public static void setupData1(){
    
        setupUser();
        /*test.startTest();
        insert stdUser;
        test.stopTest();*/
        oppTeamLstNew = new List<Opportunity_Teams__c>();
        
        Operating_Groups_Master__c oppGrpMaster = new Operating_Groups_Master__c(Name = 'TestOpperatingGroup', Active__c = true);
        insert oppGrpMaster;   
        
        oppRoleMaster = new Opportunity_Roles_Master__c(Name = Label.SD_Governance_Lead_Coach,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMaster;
        
        oppRoleMasterOSLPrimry = new Opportunity_Roles_Master__c(Name = Label.Offering_Solution_Lead_Primary,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterOSLPrimry;
        
        oppRoleMasterOSLSec= new Opportunity_Roles_Master__c(Name = Label.Offering_Solution_Lead_Secondary,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterOSLSec;
        
        
        oppRoleMasterOSL = new Opportunity_Roles_Master__c(Name = label.Opportunity_Solution_Lead,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterOSL;
        
        Email_Template__c emailTemplateRec = new Email_Template__c(name = UtilConstants.BPO_USER,ID__c='00XcibiwertDtSv');
            insert emailTemplateRec;
        
            opp = new Opportunity();
            opp.OperatingGroup__c = OppGrpMaster.id;
            opp.name= UtilConstants.TEST_OPP;
            opp.Geo_Area__c= UTIL_Constants.AsiaPacific;
            opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
            opp.StageName= UtilConstants.OA;
            opp.Risk_Level__c= UtilConstants.LOW;
            opp.SG_Dev__c = UtilConstants.IO;
            opp.SD_Covered__c = UtilConstants.YES;
            opp.Staffing_Status__c = UtilConstants.ASSIGNED;
            opp.IO_Net_Revenue_Thousands__c = 100;
            opp.CloseDate= date.newInstance(2001, 3, 21);
            opp.Industry_Business_Services__c = 'BNK-CREDIT';
            insert opp;
            
            testUserMaster = new User_Master__c();
            testUserMaster.Name = stdUser.name;
            testUserMaster.user__c = stdUser.Id;
            insert testUserMaster;
        
            oppTeam = new Opportunity_Teams__c();
            oppTeam.Opportunity__c = opp.Id;
            oppTeam.Role__c = oppRoleMaster.id;
            oppTeam.Opportunity_Team_Member__c = testUserMaster.Id;
            oppTeam.Request_Team_Member__c = false;
            oppTeam.Team_Member_Request_Status__c = UtilConstants.IN_PROGRESS;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeam.Assigned_Date__c = System.today(); 
            oppTeam.Requestor__c  = testUserMaster.Id;

            //insert oppTeam;
            
            oppTeamLstNew.add(oppTeam);        
      
            insert oppTeamLstNew;
    }
    /**
     * @Description : Creating Test Data.
     * @param : NA
     * @return parameter : void
     * @throws exception: DML Exception
     */
    public static void setupDataOSL(){
    
        setupUser();
        /*test.startTest();
        insert stdUser;
        test.stopTest();*/
        oppTeamLstNew = new List<Opportunity_Teams__c>();
        
        Operating_Groups_Master__c oppGrpMaster = new Operating_Groups_Master__c(Name = 'TestOpperatingGroup', Active__c = true);
        insert oppGrpMaster;   
    
        oppRoleMasterOSLPrimry = new Opportunity_Roles_Master__c(Name = Label.Offering_Solution_Lead_Primary,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterOSLPrimry;
        
        oppRoleMasterOSLSec= new Opportunity_Roles_Master__c(Name = Label.Offering_Solution_Lead_Secondary,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterOSLSec;
        
        
        oppRoleMasterOSL = new Opportunity_Roles_Master__c(Name = label.Opportunity_Solution_Lead,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterOSL;
        
            Email_Template__c emailTemplateRec = new Email_Template__c(name = UtilConstants.BPO_USER,ID__c='00XcabiwertDtSv');
            insert emailTemplateRec;
        
            opp = new Opportunity();
            opp.OperatingGroup__c = OppGrpMaster.id;
            opp.name= UtilConstants.TEST_OPP;
            opp.Geo_Area__c= UTIL_Constants.AsiaPacific;
            opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
            opp.StageName= UtilConstants.OA;
            opp.Risk_Level__c= UtilConstants.LOW;
            opp.SG_Dev__c = UtilConstants.IO;
            opp.SD_Covered__c = UtilConstants.YES;
            opp.Staffing_Status__c = UtilConstants.ASSIGNED;
            opp.IO_Net_Revenue_Thousands__c = 100;
            opp.CloseDate= date.newInstance(2001, 3, 21);
            opp.Industry_Business_Services__c = 'BNK-CREDIT';
            insert opp;
            
            testUserMaster = new User_Master__c();
            testUserMaster.Name = stdUser.name;
            testUserMaster.user__c = stdUser.Id;
            insert testUserMaster;

            
            oppTeamOSL = new Opportunity_Teams__c();
            oppTeamOSL.Opportunity__c = opp.Id;
            oppTeamOSL.Role__c = oppRoleMasterOSL.id;
            oppTeamOSL.Opportunity_Team_Member__c = testUserMaster.Id;
            oppTeamOSL.Request_Team_Member__c = false;
            oppTeamOSL.Team_Member_Request_Status__c = UtilConstants.IN_PROGRESS;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamOSL.Assigned_Date__c = System.today(); 
            oppTeamOSL.Requestor__c  = testUserMaster.Id;

            //insert oppTeamSS;
            oppTeamLstNew.add(oppTeamOSL);
            
            oppTeamOSlPri= new Opportunity_Teams__c();
            oppTeamOSlPri.Opportunity__c = opp.Id;
            oppTeamOSlPri.Role__c = oppRoleMasterOSLPrimry.id;
            oppTeamOSlPri.Opportunity_Team_Member__c = testUserMaster.Id;
            //oppTeamCCA.Request_Team_Member__c = true;
            oppTeamOSlPri.Team_Member_Request_Status__c = UtilConstants.IN_PROGRESS;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamOSlPri.Assigned_Date__c = System.today(); 
            oppTeamOSlPri.Requestor__c  = testUserMaster.Id;

            //insert oppTeamCCA; 
                      
            oppTeamLstNew.add(oppTeamOSlPri);
           
            oppTeamOSlSec = new Opportunity_Teams__c();
            oppTeamOSlSec.Opportunity__c = opp.Id;
            oppTeamOSlSec.Role__c = oppRoleMasterOSLSec.id;
            oppTeamOSlSec.Opportunity_Team_Member__c = testUserMaster.Id;
            //oppTeamOSlSec.Request_Team_Member__c = true;
            oppTeamOSlSec.Team_Member_Request_Status__c = UtilConstants.IN_PROGRESS;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamOSlSec.Assigned_Date__c = System.today(); 
            oppTeamOSlSec.Requestor__c  = testUserMaster.Id;
            
            oppTeamLstNew.add(oppTeamOSlSec);
            
      
            insert oppTeamLstNew;
    }
    /**
     * @Description : Creating Test Data.
     * @param : NA
     * @return parameter : void
     * @throws exception: DML Exception
     */
    public static void setupData2(){
    
            setupUser();
            /*test.startTest();
        insert stdUser;
        test.stopTest();*/
            oppTeamLstNew = new List<Opportunity_Teams__c>();
            
            oppRoleMasterPrimeSDO= new Opportunity_Roles_Master__c(Name = Label.Prime_SDO_Lead,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
            insert oppRoleMasterPrimeSDO;
            
            oppRoleMasterCommteam= new Opportunity_Roles_Master__c(Name = UtilConstants.COMM_TEAM,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
            insert oppRoleMasterCommteam;

            Operating_Groups_Master__c oppGrpMaster = new Operating_Groups_Master__c(Name = 'TestOpperatingGroup', Active__c = true);
            insert oppGrpMaster; 

            testUserMaster = new User_Master__c();
            testUserMaster.Name = stdUser.name;
            testUserMaster.user__c = stdUser.Id;
            insert testUserMaster;
            
            Email_Template__c emailTemplateRec = new Email_Template__c(name = UtilConstants.BPO_USER,ID__c='00XcabiwertDtSv');
            insert emailTemplateRec;
                                
            opp = new Opportunity();
            opp.OperatingGroup__c = OppGrpMaster.id;
            opp.name= UtilConstants.TEST_OPP;
            opp.Geo_Area__c= UTIL_Constants.AsiaPacific;
            opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
            opp.StageName= UtilConstants.OA;
            opp.Risk_Level__c= UtilConstants.LOW;
            opp.SG_Dev__c = UtilConstants.IO;
            opp.SD_Covered__c = UtilConstants.YES;
            opp.Staffing_Status__c = UtilConstants.ASSIGNED;
            opp.IO_Net_Revenue_Thousands__c = 100;
            opp.CloseDate= date.newInstance(2001, 3, 21);
            opp.Industry_Business_Services__c = 'BNK-CREDIT';
            insert opp;           
        
            oppTeamPrimeSDO = new Opportunity_Teams__c();
            oppTeamPrimeSDO.Opportunity__c = opp.Id;
            oppTeamPrimeSDO.Role__c = oppRoleMasterPrimeSDO.id;
            oppTeamPrimeSDO.Opportunity_Team_Member__c = testUserMaster.Id;
            //oppTeamPrimeSDO.Request_Team_Member__c = true;
            oppTeamPrimeSDO.Team_Member_Request_Status__c = UtilConstants.IN_PROGRESS;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamPrimeSDO.Assigned_Date__c = System.today(); 
            oppTeamPrimeSDO.Requestor__c  = testUserMaster.Id;
            
            oppTeamLstNew.add(oppTeamPrimeSDO);
            
            oppTeamComm = new Opportunity_Teams__c();
            oppTeamComm.Opportunity__c = opp.Id;
            oppTeamComm.Role__c = oppRoleMasterCommteam.id;
            oppTeamComm.Opportunity_Team_Member__c = testUserMaster.Id;
            //oppTeamComm.Request_Team_Member__c = true;
            oppTeamComm.Team_Member_Request_Status__c = UtilConstants.IN_PROGRESS;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamComm.Assigned_Date__c = System.today(); 
            oppTeamComm.Requestor__c  = testUserMaster.Id;
            
            oppTeamLstNew.add(oppTeamComm);
            
            insert oppTeamLstNew;
    }
    /**
     * @Description : Creating Test Data.
     * @param : NA
     * @return parameter : void
     * @throws exception: DML Exception
     */
    public static void setupData3(){
    
            setupUser();
            /*test.startTest();
        insert stdUser;
        test.stopTest();*/
            oppTeamLstNew = new List<Opportunity_Teams__c>();
            
            oppRoleMasterPrimeSDO= new Opportunity_Roles_Master__c(Name = label.Lead_Solution_Architect_IO,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=false,IO_Role__c=true,IC_Role__c=false);
            insert oppRoleMasterPrimeSDO;
            
           // oppRoleMasterCommteam= new Opportunity_Roles_Master__c(Name = label.Lead_Solution_Architect_IC,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=false,IO_Role__c=false,IC_Role__c=true);
            //insert oppRoleMasterCommteam;

            Operating_Groups_Master__c oppGrpMaster = new Operating_Groups_Master__c(Name = 'TestOpperatingGroup', Active__c = true);
            insert oppGrpMaster; 

            testUserMaster = new User_Master__c();
            testUserMaster.Name = stdUser.name;
            testUserMaster.user__c = stdUser.Id;
            insert testUserMaster;
            
            Email_Template__c emailTemplateRec = new Email_Template__c(name = UtilConstants.IO_USER,ID__c='abXcabiwertDtSv');
            insert emailTemplateRec;
                                
            opp = new Opportunity();
            opp.OperatingGroup__c = OppGrpMaster.id;
            opp.name= UtilConstants.TEST_OPP;
            opp.Geo_Area__c= UTIL_Constants.AsiaPacific;
            opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
            opp.StageName= UtilConstants.OA;
            opp.Risk_Level__c= UtilConstants.LOW;
            opp.SG_Dev__c = UtilConstants.IO;
            opp.SD_Covered__c = UtilConstants.YES;
            opp.Staffing_Status__c = UtilConstants.ASSIGNED;
            opp.IO_Net_Revenue_Thousands__c = 100;
            opp.CloseDate= date.newInstance(2001, 3, 21);
            opp.Industry_Business_Services__c = 'BNK-CREDIT';
            insert opp;           
        
            oppTeamPrimeSDO = new Opportunity_Teams__c();
            oppTeamPrimeSDO.Opportunity__c = opp.Id;
            oppTeamPrimeSDO.Role__c = oppRoleMasterPrimeSDO.id;
            oppTeamPrimeSDO.Opportunity_Team_Member__c = testUserMaster.Id;
            //oppTeamPrimeSDO.Request_Team_Member__c = true;
            oppTeamPrimeSDO.Team_Member_Request_Status__c = UtilConstants.IN_PROGRESS;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamPrimeSDO.Assigned_Date__c = System.today(); 
            oppTeamPrimeSDO.Requestor__c  = testUserMaster.Id;
            
            //oppTeamLstNew.add(oppTeamPrimeSDO);
            insert oppTeamPrimeSDO;
            
       /*     oppTeamComm = new Opportunity_Teams__c();
            oppTeamComm.Opportunity__c = opp.Id;
            oppTeamComm.Role__c = oppRoleMasterCommteam.id;
            oppTeamComm.Opportunity_Team_Member__c = testUserMaster.Id;
            //oppTeamComm.Request_Team_Member__c = true;
            oppTeamComm.Team_Member_Request_Status__c = UtilConstants.IN_PROGRESS;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamComm.Assigned_Date__c = System.today(); 
            oppTeamComm.Requestor__c  = testUserMaster.Id;
            
            //oppTeamLstNew.add(oppTeamComm);
            
            insert oppTeamComm;*/
    }
    /**
     * @Description : Creating Test Data.
     * @param : NA
     * @return parameter : void
     * @throws exception: DML Exception
     */
    public static void setupData4(){
    
            setupUser();
            /*test.startTest();
        insert stdUser;
        test.stopTest();*/
       
       
        
            oppTeamLstNew = new List<Opportunity_Teams__c>();
            
           // oppRoleMasterPrimeSDO= new Opportunity_Roles_Master__c(Name = label.Lead_Solution_Architect_IO,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=false,IO_Role__c=true,IC_Role__c=false);
            //insert oppRoleMasterPrimeSDO;
            
            oppRoleMasterCommteam= new Opportunity_Roles_Master__c(Name = label.Lead_Solution_Architect_IC,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=false,IO_Role__c=false,IC_Role__c=true);
            insert oppRoleMasterCommteam;

            Operating_Groups_Master__c oppGrpMaster = new Operating_Groups_Master__c(Name = 'TestOpperatingGroup', Active__c = true);
            insert oppGrpMaster; 

            testUserMaster = new User_Master__c();
            testUserMaster.Name = stdUser.name;
            testUserMaster.user__c = stdUser.Id;
            insert testUserMaster;
            
            Email_Template__c emailTemplateRec = new Email_Template__c(name = UtilConstants.IC_USER,ID__c='abXcabiwertDtSv');
            insert emailTemplateRec;
                                
            opp = new Opportunity();
            opp.OperatingGroup__c = OppGrpMaster.id;
            opp.name= UtilConstants.TEST_OPP;
            opp.Geo_Area__c= UTIL_Constants.AsiaPacific;
            opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
            opp.StageName= UtilConstants.OA;
            opp.Risk_Level__c= UtilConstants.LOW;
            opp.SG_Dev__c = UtilConstants.IO;
            opp.SD_Covered__c = UtilConstants.YES;
            opp.Staffing_Status__c = UtilConstants.ASSIGNED;
            opp.IO_Net_Revenue_Thousands__c = 100;
            opp.CloseDate= date.newInstance(2001, 3, 21);
            opp.Industry_Business_Services__c = 'BNK-CREDIT';
            insert opp;           
        
          /*  oppTeamPrimeSDO = new Opportunity_Teams__c();
            oppTeamPrimeSDO.Opportunity__c = opp.Id;
            oppTeamPrimeSDO.Role__c = oppRoleMasterPrimeSDO.id;
            oppTeamPrimeSDO.Opportunity_Team_Member__c = testUserMaster.Id;
            //oppTeamPrimeSDO.Request_Team_Member__c = true;
            oppTeamPrimeSDO.Team_Member_Request_Status__c = UtilConstants.IN_PROGRESS;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamPrimeSDO.Assigned_Date__c = System.today(); 
            oppTeamPrimeSDO.Requestor__c  = testUserMaster.Id;
            
            //oppTeamLstNew.add(oppTeamPrimeSDO);
            insert oppTeamPrimeSDO;*/
            
            oppTeamComm = new Opportunity_Teams__c();
            oppTeamComm.Opportunity__c = opp.Id;
            oppTeamComm.Role__c = oppRoleMasterCommteam.id;
            oppTeamComm.Opportunity_Team_Member__c = testUserMaster.Id;
            //oppTeamComm.Request_Team_Member__c = true;
            oppTeamComm.Team_Member_Request_Status__c = UtilConstants.IN_PROGRESS;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamComm.Assigned_Date__c = System.today(); 
            oppTeamComm.Requestor__c  = testUserMaster.Id;
            
            //oppTeamLstNew.add(oppTeamComm);
            
            insert oppTeamComm;
    }
    /**
     * @Description : Creating Test Data.
     * @param : NA
     * @return parameter : void
     * @throws exception: DML Exception
     */
    public static void setupData5(){
    
            setupUser();
            

            /*test.startTest();
        insert stdUser;
        test.stopTest();*/
            oppTeamLstNew = new List<Opportunity_Teams__c>();
             User usr = [Select id,name from User where Id = :UserInfo.getUserId()];
           
            
            oppRoleMasterCommteam= new Opportunity_Roles_Master__c(Name = 'Capability Lead',ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=false,IO_Role__c=false,IC_Role__c=true);
            insert oppRoleMasterCommteam;

            Operating_Groups_Master__c oppGrpMaster = new Operating_Groups_Master__c(Name = 'TestOpperatingGroup', Active__c = true);
            insert oppGrpMaster; 
             
            testUserMaster = new User_Master__c();
            testUserMaster.Name = usr.name;
            testUserMaster.user__c = usr.Id;
            insert testUserMaster;
            
            Email_Template__c emailTemplateRec = new Email_Template__c(name = UtilConstants.IC_USER,ID__c='abXcabiwertDtSv');
            insert emailTemplateRec;
                                
            opp = new Opportunity();
            opp.OperatingGroup__c = OppGrpMaster.id;
            opp.name= UtilConstants.TEST_OPP;
            opp.Geo_Area__c= UTIL_Constants.AsiaPacific;
            opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
            opp.StageName= UtilConstants.OA;
            opp.Risk_Level__c= UtilConstants.LOW;
            opp.SG_Dev__c = UtilConstants.IO;
            opp.SD_Covered__c = UtilConstants.YES;
            opp.Staffing_Status__c = UtilConstants.ASSIGNED;
            opp.IO_Net_Revenue_Thousands__c = 100;
            opp.CloseDate= date.newInstance(2001, 3, 21);
            opp.Industry_Business_Services__c = 'BNK-CREDIT';
            insert opp;           
        
                  Offering_Master__c offProc=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
        offProc.Service_Group__c = 'BPO';
        insert offProc;
        
        Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
        insert customSetting;
        
      solCompBPO = new Solution_Scope__c(Active__c = True, Opportunity__c = opp.id, 
                                        Solution_Component__c = 'Delivery', Offering_Master__c = offProc.id, 
                                        Service_Group__c = 'BPO',  SAP_Offering_Revenue__c = 20);
        insert solCompBPO;
            
            oppTeamComm = new Opportunity_Teams__c();
            oppTeamComm.Opportunity__c = opp.Id;
            oppTeamComm.Role__c = oppRoleMasterCommteam.id;
            oppTeamComm.Opportunity_Team_Member__c = testUserMaster.Id;
            //oppTeamComm.Request_Team_Member__c = true;
            oppTeamComm.Team_Member_Request_Status__c = UtilConstants.IN_PROGRESS;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamComm.Assigned_Date__c = System.today(); 
            oppTeamComm.Requestor__c  = testUserMaster.Id;
            oppTeamComm.Offering__c = solCompBPO.Id;
            //oppTeamLstNew2.add(oppTeamComm);
              
     
       insert oppTeamComm;
       
       
      Opportunity_Teams__c oppTeamComm1 = new Opportunity_Teams__c();
            oppTeamComm1.Opportunity__c = opp.Id;
            oppTeamComm1.Role__c = oppRoleMasterCommteam.id;
            oppTeamComm1.Opportunity_Team_Member__c = testUserMaster.Id;
            //oppTeamComm1.Request_Team_Member__c = true;
            oppTeamComm1.Team_Member_Request_Status__c = UtilConstants.IN_PROGRESS;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamComm1.Assigned_Date__c = System.today(); 
            oppTeamComm1.Requestor__c  = testUserMaster.Id;
            oppTeamComm1.Offering__c = solCompBPO.Id;
           // oppTeamLstNew2.add(oppTeamComm1);
              
     
       insert oppTeamComm1;
     
           
    }
    /**
     * @Description : Creating Test Data for PMO.
     * @param : NA
     * @return parameter : void
     * @throws exception: DML Exception
     */
    public static void setupDataPMO(){
    
        setupUser();
        /*test.startTest();
        insert stdUser;
        test.stopTest();*/
        oppTeamLstNew = new List<Opportunity_Teams__c>();
        
        Operating_Groups_Master__c oppGrpMaster = new Operating_Groups_Master__c(Name = 'TestOpperatingGroup', Active__c = true);
        insert oppGrpMaster;   
    
        oppRoleMasterOSLPrimry = new Opportunity_Roles_Master__c(Name = Label.Complex_Cost_Architect,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterOSLPrimry;
        
        oppRoleMasterSS = new Opportunity_Roles_Master__c(Name = Label.Solution_Specialist,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterSS;
        
        oppRoleMasterMA = new Opportunity_Roles_Master__c(Name = Label.Mobilization_Architect,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterMA;
        
        oppRoleMasterTA = new Opportunity_Roles_Master__c(Name = Label.Technical_Architect,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterTA;

            Email_Template__c emailTemplateRec = new Email_Template__c(name = 'Inti to req if resource is nt assign',ID__c='00Xcabd000DtSv');
            insert emailTemplateRec;
            
            Email_Template__c emailTemplateRec1 = new Email_Template__c(name = UtilConstants.INTIMATE_PMO_NEW,ID__c='00Xcabu000DtSv');
            insert emailTemplateRec1;
            
            Email_Template__c emailTemplateRec2 = new Email_Template__c(name = UtilConstants.BPO_USER,ID__c='00XcapiwertDtSv');
            insert emailTemplateRec2;
            
            Group CCAQueueId = [select Id from Group where Name = 'CCA Queue' and Type = 'Queue' LIMIT 5000];
            
            opp = new Opportunity();
            opp.OperatingGroup__c = OppGrpMaster.id;
            opp.name= UtilConstants.TEST_OPP;
            opp.Geo_Area__c= UTIL_Constants.AsiaPacific;
            opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
            opp.StageName= UtilConstants.OA;
            opp.Risk_Level__c= UtilConstants.LOW;
            opp.SG_Dev__c = UtilConstants.IO;
            opp.SD_Covered__c = UtilConstants.YES;
            opp.Staffing_Status__c = UtilConstants.ASSIGNED;
            opp.IO_Net_Revenue_Thousands__c = 100;
            opp.CloseDate= date.newInstance(2001, 3, 21);
            opp.Industry_Business_Services__c = 'BNK-CREDIT';
            insert opp;
            
            testUserMaster = new User_Master__c();
            testUserMaster.Name = stdUser.name;
            testUserMaster.user__c = stdUser.Id;
            insert testUserMaster;

            
            oppTeamOSL = new Opportunity_Teams__c();
            oppTeamOSL.Opportunity__c = opp.Id;
            oppTeamOSL.Role__c = oppRoleMasterOSLPrimry.id;
            //oppTeamOSL.Opportunity_Team_Member__c = testUserMaster.Id;
            oppTeamOSL.Request_Team_Member__c = true;
            oppTeamOSL.Team_Member_Request_Status__c = UtilConstants.ONHOLD;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamOSL.Assigned_Date__c = System.today(); 
            oppTeamOSL.Requestor__c  = testUserMaster.Id;
            oppTeamOSL.ownerID = CCAQueueId.Id;

            //insert oppTeamSS;
            oppTeamLstNew.add(oppTeamOSL);
            
            oppTeamComm= new Opportunity_Teams__c();
            oppTeamComm.Opportunity__c = opp.Id;
            oppTeamComm.Role__c = oppRoleMasterSS.id;
            //oppTeamOSL.Opportunity_Team_Member__c = testUserMaster.Id;
            oppTeamComm.Request_Team_Member__c = true;
            oppTeamComm.Team_Member_Request_Status__c = UtilConstants.NOT_FILLED;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamComm.Assigned_Date__c = System.today(); 
            oppTeamComm.Requestor__c  = testUserMaster.Id;
            oppTeamComm.ownerID = CCAQueueId.Id;

            //insert oppTeamSS;
            oppTeamLstNew.add(oppTeamComm);
            
            oppTeamPrimeSDO= new Opportunity_Teams__c();
            oppTeamPrimeSDO.Opportunity__c = opp.Id;
            oppTeamPrimeSDO.Role__c = oppRoleMasterMA.id;
            oppTeamPrimeSDO.Opportunity_Team_Member__c = testUserMaster.Id;
            oppTeamPrimeSDO.Request_Team_Member__c = true;
            oppTeamPrimeSDO.Team_Member_Request_Status__c = 'In Progress';
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamPrimeSDO.Assigned_Date__c = System.today(); 
            oppTeamPrimeSDO.Requestor__c  = testUserMaster.Id;
            oppTeamPrimeSDO.ownerID = CCAQueueId.Id;

            //insert oppTeamSS;
            oppTeamLstNew.add(oppTeamPrimeSDO);
            
            oppTeamPrimeTA= new Opportunity_Teams__c();
            oppTeamPrimeTA.Opportunity__c = opp.Id;
            oppTeamPrimeTA.Role__c = oppRoleMasterTA.id;
            oppTeamPrimeTA.Opportunity_Team_Member__c = testUserMaster.Id;
            oppTeamPrimeTA.Request_Team_Member__c = true;
            oppTeamPrimeTA.Team_Member_Request_Status__c = 'In Progress';
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamPrimeTA.Assigned_Date__c = System.today(); 
            oppTeamPrimeTA.Requestor__c  = testUserMaster.Id;
            oppTeamPrimeTA.ownerID = CCAQueueId.Id;

            //insert oppTeamSS;
            oppTeamLstNew.add(oppTeamPrimeTA);
                        
            insert oppTeamLstNew;
            
    }
    /**
     * @Description : Creating Test Data.
     * @param : NA
     * @return parameter : void
     * @throws exception: DML Exception
     */
    public static void setupDataDelete(){
    
        setupUser();
        /*test.startTest();
        insert stdUser;
        test.stopTest();*/
        oppTeamLstNew = new List<Opportunity_Teams__c>();
        
        Operating_Groups_Master__c oppGrpMaster = new Operating_Groups_Master__c(Name = 'TestOpperatingGroup', Active__c = true);
        insert oppGrpMaster; 
        
        
        oppRoleMasterSDGov= new Opportunity_Roles_Master__c(Name = Label.SD_Governance_Lead_Coach,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=false,IO_Role__c=true,IC_Role__c=false);
        insert oppRoleMasterSDGov;
        
        oppRoleMasterPrimeSDO= new Opportunity_Roles_Master__c(Name = Label.Prime_SDO_Lead,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=false,IO_Role__c=true,IC_Role__c=false);
        insert oppRoleMasterPrimeSDO;
        
        oppRoleMasterCommteam= new Opportunity_Roles_Master__c(Name = Label.Commercial_Team,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=false,IO_Role__c=false,IC_Role__c=true);
        insert oppRoleMasterCommteam;  

    
        oppRoleMasterOSLPrimry = new Opportunity_Roles_Master__c(Name = label.Opportunity_Solution_Lead,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterOSLPrimry;
                

            Email_Template__c emailTemplateRec = new Email_Template__c(name = 'Inti to req if resource is nt assign',ID__c='00Xcabd000DtSv');
            insert emailTemplateRec;
            
            Email_Template__c emailTemplateRec1 = new Email_Template__c(name = UtilConstants.INTIMATE_PMO_NEW,ID__c='00Xcabu000DtSv');
            insert emailTemplateRec1;
            
            Email_Template__c emailTemplateRec2 = new Email_Template__c(name = UtilConstants.BPO_USER,ID__c='00XcakiwertDtSv');
            insert emailTemplateRec2;
             
            Commercial_Master__c clientName = new Commercial_Master__c(Name = 'TestObject1',Active__c = true);
            Database.insert(clientName);
            
            Group CCAQueueId = [select Id from Group where Name = 'CCA Queue' and Type = 'Queue' LIMIT 5000];
            
            opp = new Opportunity();
            opp.OperatingGroup__c = OppGrpMaster.id;
            opp.name= UtilConstants.TEST_OPP;
            opp.Geo_Area__c= UTIL_Constants.AsiaPacific;
            opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
            opp.StageName= UtilConstants.OA;
            opp.Risk_Level__c= UtilConstants.LOW;
            opp.SG_Dev__c = UtilConstants.IO;
            opp.SD_Covered__c = UtilConstants.YES;
            opp.Staffing_Status__c = UtilConstants.ASSIGNED;
            opp.IO_Net_Revenue_Thousands__c = 100;
            opp.CloseDate= date.newInstance(2001, 3, 21);
            opp.Industry_Business_Services__c = 'BNK-CREDIT';
            insert opp;
            
                        testUserMaster = new User_Master__c();
            testUserMaster.Name = stdUser.name;
            testUserMaster.user__c = stdUser.Id;
            insert testUserMaster;
            
            Commercial_Data__c commData = new Commercial_Data__c (Name='Test Object 1', Opportunity__c = opp.Id);
            insert commData;
            
            SD_Governance_Data__c oppGov = new SD_Governance_Data__c(Opportunity__c=opp.Id,SD_Gov_Lead_Coach__c=stdUser.name,Client__c=clientName.id, Solution_Headline__c = '', Risk__c = 'red', BPO_Sales_Lead__c = 'BPO_Sales_Lead', 
                                    Commercial__c = 'Green',Schedule__c='Green', over_all__c = 'Amber',Other__c='No comment', trending__c = 'N/A', Active__c = True, Watchlist__c = 'Yes');
          
            Database.insert(oppGov);
            
            
            oppTeamOSL = new Opportunity_Teams__c();
            oppTeamOSL.Opportunity__c = opp.Id;
            oppTeamOSL.Role__c = oppRoleMasterOSLPrimry.id;
            oppTeamOSL.Opportunity_Team_Member__c = testUserMaster.Id;
            //oppTeamOSL.Request_Team_Member__c = true;
            //oppTeamOSL.Team_Member_Request_Status__c = UtilConstants.ONHOLD;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamOSL.Assigned_Date__c = System.today(); 
            oppTeamOSL.Requestor__c  = testUserMaster.Id;
            oppTeamOSL.ownerID = CCAQueueId.Id;

            //insert oppTeamSS;
            oppTeamLstNew.add(oppTeamOSL);
            
            oppTeamComm= new Opportunity_Teams__c();
            oppTeamComm.Opportunity__c = opp.Id;
            oppTeamComm.Role__c = oppRoleMasterCommteam.id;
            oppTeamOSL.Opportunity_Team_Member__c = testUserMaster.Id;
            oppTeamComm.Request_Team_Member__c = true;
            oppTeamComm.Team_Member_Request_Status__c = UtilConstants.NOT_FILLED;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamComm.Assigned_Date__c = System.today(); 
            oppTeamComm.Requestor__c  = testUserMaster.Id;
            oppTeamComm.ownerID = CCAQueueId.Id;

            //insert oppTeamSS;
            oppTeamLstNew.add(oppTeamComm);
            
            oppTeamPrimeSDO= new Opportunity_Teams__c();
            oppTeamPrimeSDO.Opportunity__c = opp.Id;
            oppTeamPrimeSDO.Role__c = oppRoleMasterPrimeSDO.id;
            oppTeamPrimeSDO.Opportunity_Team_Member__c = testUserMaster.Id;
            oppTeamPrimeSDO.Request_Team_Member__c = true;
            oppTeamPrimeSDO.Team_Member_Request_Status__c = 'In Progress';
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamPrimeSDO.Assigned_Date__c = System.today(); 
            oppTeamPrimeSDO.Requestor__c  = testUserMaster.Id;
            oppTeamPrimeSDO.ownerID = CCAQueueId.Id;

            //insert oppTeamSS;
            oppTeamLstNew.add(oppTeamPrimeSDO);
            
            oppTeamSDGov= new Opportunity_Teams__c();
            oppTeamSDGov.Opportunity__c = opp.Id;
            oppTeamSDGov.Role__c = oppRoleMasterSDGov.id;
            oppTeamSDGov.Opportunity_Team_Member__c = testUserMaster.Id;
            oppTeamSDGov.Request_Team_Member__c = true;
            oppTeamSDGov.Team_Member_Request_Status__c = 'In Progress';
            oppTeamSDGov.Assigned_Date__c = System.today(); 
            oppTeamSDGov.Requestor__c  = testUserMaster.Id;
            oppTeamSDGov.ownerID = CCAQueueId.Id;
            
            oppTeamLstNew.add(oppTeamSDGov);         
                        
            insert oppTeamLstNew;
            
    }
    /**
     * @Description : Creating Test Data.
     * @param : NA
     * @return parameter : void
     * @throws exception: DML Exception
     */
    public static void setupDataDelete1(){
    
        setupUser();
        /*test.startTest();
        insert stdUser;
        test.stopTest();*/
        oppTeamLstNew = new List<Opportunity_Teams__c>();
        
        Operating_Groups_Master__c oppGrpMaster = new Operating_Groups_Master__c(Name = 'TestOpperatingGroup', Active__c = true);
        insert oppGrpMaster; 
        
        oppRoleMasterOSLP = new Opportunity_Roles_Master__c(Name = Label.Offering_Solution_Lead_Primary,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterOSLP ;
        
        oppRoleMasterOSLS = new Opportunity_Roles_Master__c(Name = Label.Offering_Solution_Lead_Secondary,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterOSLS;
        
        

            Email_Template__c emailTemplateRec = new Email_Template__c(name = 'Inti to req if resource is nt assign',ID__c='00Xcabd000DtSv');
            insert emailTemplateRec;
            
            Email_Template__c emailTemplateRec1 = new Email_Template__c(name = UtilConstants.INTIMATE_PMO_NEW,ID__c='00Xcabu000DtSv');
            insert emailTemplateRec1;
            
            Email_Template__c emailTemplateRec2 = new Email_Template__c(name = UtilConstants.BPO_USER,ID__c='00XcabdwertDtSv');
            insert emailTemplateRec2;
             
            Commercial_Master__c clientName = new Commercial_Master__c(Name = 'TestObject1',Active__c = true);
            Database.insert(clientName);
            
            Group CCAQueueId = [select Id from Group where Name = 'CCA Queue' and Type = 'Queue' LIMIT 5000];
            
            opp = new Opportunity();
            opp.OperatingGroup__c = OppGrpMaster.id;
            opp.name= UtilConstants.TEST_OPP;
            opp.Geo_Area__c= UTIL_Constants.AsiaPacific;
            opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
            opp.StageName= UtilConstants.OA;
            opp.Risk_Level__c= UtilConstants.LOW;
            opp.SG_Dev__c = UtilConstants.IO;
            opp.SD_Covered__c = UtilConstants.YES;
            opp.Staffing_Status__c = UtilConstants.ASSIGNED;
            opp.IO_Net_Revenue_Thousands__c = 100;
            opp.CloseDate= date.newInstance(2001, 3, 21);
            opp.Industry_Business_Services__c = 'BNK-CREDIT';
            insert opp;
            
                       testUserMaster = new User_Master__c();
            testUserMaster.Name = stdUser.name;
            testUserMaster.user__c = stdUser.Id;
            insert testUserMaster;
            
            Commercial_Data__c commData = new Commercial_Data__c (Name='Test Object 1', Opportunity__c = opp.Id);
            insert commData;
            
            SD_Governance_Data__c oppGov = new SD_Governance_Data__c(Opportunity__c=opp.Id,Client__c=clientName.id,SD_Gov_Lead_Coach__c=stdUser.name, Solution_Headline__c = '', Risk__c = 'red', BPO_Sales_Lead__c = 'BPO_Sales_Lead', 
                                    Commercial__c = 'Green',Schedule__c='Green', over_all__c = 'Amber',Other__c='No comment', trending__c = 'N/A', Active__c = True, Watchlist__c = 'Yes');
          
            Database.insert(oppGov);
            
 

                    
            oppTeamOSLP= new Opportunity_Teams__c();
            oppTeamOSLP.Opportunity__c = opp.Id;
            oppTeamOSLP.Role__c = oppRoleMasterOSLP.id;
            oppTeamOSLP.Opportunity_Team_Member__c = testUserMaster.Id;
            oppTeamOSLP.Request_Team_Member__c = true;
            oppTeamOSLP.Team_Member_Request_Status__c = 'In Progress';
            oppTeamOSLP.Assigned_Date__c = System.today(); 
            oppTeamOSLP.Requestor__c  = testUserMaster.Id;
            oppTeamOSLP.ownerID = CCAQueueId.Id;
            
            oppTeamLstNew.add(oppTeamOSLP);
            
            oppTeamOSLS= new Opportunity_Teams__c();
            oppTeamOSLS.Opportunity__c = opp.Id;
            oppTeamOSLS.Role__c = oppRoleMasterOSLS.id;
            oppTeamOSLS.Opportunity_Team_Member__c = testUserMaster.Id;
            oppTeamOSLS.Request_Team_Member__c = true;
            oppTeamOSLS.Team_Member_Request_Status__c = 'In Progress';
            oppTeamOSLS.Assigned_Date__c = System.today(); 
            oppTeamOSLS.Requestor__c  = testUserMaster.Id;
            oppTeamOSLS.ownerID = CCAQueueId.Id;
            
            oppTeamLstNew.add(oppTeamOSLS);
                        
            insert oppTeamLstNew;
            
    }
    /**
     * @Description : Restrict duplicate data.
     * @param : NA
     * @return parameter : void
     */
    public static testmethod void testRestrictFromDuplicates(){  
        
        setupData();
        //Test.startTest(); 
            operationOnOppTeamTriggerController operationOppTeam = new operationOnOppTeamTriggerController();
            operationOppTeam.restrictFromDuplicates(oppTeamLst); 
            operationOnOppTeamTriggerController.updateUtilizationRecords(oppTeamLst,oppTeamLstNew);   
            operationOnOppTeamTriggerController.deleteUtilizationRecords(oppTeamLst); 
        //test.stopTest();
    }
    /**
     * @Description :
     * @param : NA
     * @return parameter : void
     */
    public static testmethod void testForSendAndUpdateToAssignee(){  

        setupData1();
        //Test.startTest(); 
            operationOnOppTeamTriggerController operationOppTeam = new operationOnOppTeamTriggerController();
            operationOnOppTeamTriggerController.updateAccessOnOppAndSolCompForAssignee(oppTeamLstNew); 
            //operationOnOppTeamTriggerController.sendAndUpdateAssignee(oppTeamLst);           
        //test.stopTest();
    }
    /**
     * @Description : 
     * @param : NA
     * @return parameter : void
     */
    public static testmethod void testForSendAndUpdateToAssignee1(){  

        setupData2();
        //Test.startTest(); 
            operationOnOppTeamTriggerController operationOppTeam = new operationOnOppTeamTriggerController();
            operationOnOppTeamTriggerController.updateAccessOnOppAndSolCompForAssignee(oppTeamLstNew); 
            //operationOnOppTeamTriggerController.sendAndUpdateAssignee(oppTeamLst);           
        //test.stopTest();
    }
    /**
     * @Description : 
     * @param : NA
     * @return parameter : void
     */
    public static testmethod void testForSendAndUpdateToAssignee2(){  

        setupData3();
        //Test.startTest(); 
            operationOnOppTeamTriggerController operationOppTeam = new operationOnOppTeamTriggerController();
            operationOnOppTeamTriggerController.updateAccessOnOppAndSolCompForAssignee(oppTeamLstNew); 
            //operationOnOppTeamTriggerController.sendAndUpdateAssignee(oppTeamLst);           
        //test.stopTest();
    }
    /**
     * @Description : 
     * @param : NA
     * @return parameter : void
     */
    public static testmethod void testForSendAndUpdateToAssignee3(){  

        setupData4();
        //Test.startTest(); 
            operationOnOppTeamTriggerController operationOppTeam = new operationOnOppTeamTriggerController();
            operationOnOppTeamTriggerController.updateAccessOnOppAndSolCompForAssignee(oppTeamLstNew); 
            //operationOnOppTeamTriggerController.sendAndUpdateAssignee(oppTeamLst);           
       // test.stopTest();
    }
    /**
     * @Description : 
     * @param : NA
     * @return parameter : void
     */
    public static testmethod void testForSendAndUpdateToAssignee4(){  
       User usr = [Select id from User where Id = :UserInfo.getUserId()];
       System.RunAs(usr){
        setupData5(); 
        }
        //Test.startTest(); 
            operationOnOppTeamTriggerController operationOppTeam = new operationOnOppTeamTriggerController();
            operationOnOppTeamTriggerController.updateAccessOnOppAndSolCompForAssignee(oppTeamLstNew); 
            
            //operationOnOppTeamTriggerController.sendAndUpdateAssignee(oppTeamLst);           
       // test.stopTest();
    }
    /**
     * @Description : Creating Test Data.
     * @param : NA
     * @return parameter : void
     */
    public static testmethod void testForSendAndUpdateToAssigneeOSL(){  

        setupDataOSL();
        //Test.startTest(); 
            operationOnOppTeamTriggerController operationOppTeam = new operationOnOppTeamTriggerController();
            operationOnOppTeamTriggerController.updateAccessOnOppAndSolCompForAssignee(oppTeamLstNew); 
            //operationOnOppTeamTriggerController.sendAndUpdateAssignee(oppTeamLst);           
        //test.stopTest();
    }
     /**
     * @Description : Creating Test Data.
     * @param : NA
     * @return parameter : void
     */
    public static testmethod void testForSendUpdatePMO(){  

        setupDataPMO();
        //Test.startTest(); 
        String oppTeamId = oppTeamOSL.id;
        String oppTeamSDO = oppTeamPrimeSDO.id;
        String oppTeamTA = oppTeamPrimeTA.id;
        String oppTeamSSID = oppTeamComm.id;
            operationOnOppTeamTriggerController operationOppTeam = new operationOnOppTeamTriggerController();
            operationOnOppTeamTriggerController.updateAccessOnOppAndSolCompForAssignee(oppTeamLstNew); 
            operationOnOppTeamTriggerController.updateOppTeamAfterRecall(oppTeamId);
            operationOnOppTeamTriggerController.updateOppTeamAfterRecall(oppTeamSDO);
            operationOnOppTeamTriggerController.updateOppTeamAfterRecall(oppTeamTA);
            operationOnOppTeamTriggerController.updateOppTeamAfterRecall(oppTeamSSID); 
            operationOnOppTeamTriggerController.sendMailOnFollowUp(oppTeamId);
            operationOnOppTeamTriggerController.sendMailOnFollowUp(oppTeamSDO);
            operationOnOppTeamTriggerController.sendMailOnFollowUp(oppTeamTA);
            operationOnOppTeamTriggerController.sendMailOnFollowUp(oppTeamSSID);  
                   
        //test.stopTest();
    }
     /**
     * @Description : Creating Test Data.
     * @param : NA
     * @return parameter : void
     */
     
     /**
    public static testmethod void testDelete(){  

        setupDataDelete();
        //Test.startTest(); 
            delete oppTeamLstNew;
                           
        //test.stopTest();
    }
    **/
     /**
     * @Description : Creating Test Data.
     * @param : NA
     * @return parameter : void
     */
     /**
    public static testmethod void testDelete1(){  

        setupDataDelete1();
        //Test.startTest(); 
            delete oppTeamLstNew;
                           
        //test.stopTest();
    }
    **/
    public static void setupdataCapbility(){
    
    Operating_Groups_Master__c oppGrpMaster = new Operating_Groups_Master__c(Name = 'TestOpperatingGroup', Active__c = true);
        insert oppGrpMaster; 
        
        oppRoleMasterOSLP = new Opportunity_Roles_Master__c(Name = 'Capability Lead',ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterOSLP ;
        
        opp = new Opportunity();
        opp.OperatingGroup__c = OppGrpMaster.id;
        opp.name= UtilConstants.TEST_OPP;
        opp.Geo_Area__c= UTIL_Constants.AsiaPacific;
        opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
        opp.StageName= UtilConstants.OA;
        opp.Risk_Level__c= UtilConstants.LOW;
        opp.SG_Dev__c = UtilConstants.IO;
        opp.SD_Covered__c = UtilConstants.YES;
        opp.Staffing_Status__c = UtilConstants.ASSIGNED;
        opp.IO_Net_Revenue_Thousands__c = 100;
        opp.CloseDate= date.newInstance(2001, 3, 21);
        opp.Industry_Business_Services__c = 'BNK-CREDIT';
        insert opp;
        
        Offering_Master__c offProc=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
        offProc.Service_Group__c = 'BPO';
        insert offProc;
        
        Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
        insert customSetting;
        
      solCompBPO = new Solution_Scope__c(Active__c = True, Opportunity__c = opp.id, 
                                        Solution_Component__c = 'Delivery', Offering_Master__c = offProc.id, 
                                        Service_Group__c = 'BPO',  SAP_Offering_Revenue__c = 20);
        insert solCompBPO;
    
    }
    
    
    public static testmethod void testCapablilityOfferingLead(){
        setupUser();
        setupdataCapbility();
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        testUserMaster = new User_Master__c();
        testUserMaster.Name = stdUser.name;
        testUserMaster.user__c = usr.Id;
        insert testUserMaster;
             
        oppTeamOSLP= new Opportunity_Teams__c();
        oppTeamOSLP.Opportunity__c = opp.Id;
        oppTeamOSLP.Role__c = oppRoleMasterOSLP.id;
        oppTeamOSLP.Opportunity_Team_Member__c = testUserMaster.Id;
        oppTeamOSLP.Team_Member_Request_Status__c = 'In Progress';
        oppTeamOSLP.Assigned_Date__c = System.today(); 
        oppTeamOSLP.Requestor__c  = testUserMaster.Id;
        oppTeamOSLP.Offering__c = solCompBPO.Id;
        
        
       
        
        System.RunAs(usr)
     {
       test.startTest();
        insert oppTeamOSLP;     
        test.stopTest();
     }
        
        
    }
    
    
    
    
    
    

}