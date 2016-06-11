/*
  @Author: 
  @Name: operationOnOppTeamTriggerController_Test Test class
  @Created Date: 
  @Description:  Test Class for operation On Opportunity Team Trigger
  @version: 1.0  
*/
@isTest
private class ShareWithOppTeam_Test{

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
    private static Opportunity_Roles_Master__c oppRoleMasterPrimeDelivery;
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
    private static Opportunity_Teams__c oppTeamPrimeDelivery;
    private static User stdUser;
    private static Opportunity_Client_Dependency__c oppClientDep;
    private static Client_Dependencies_Master__c clientDependencyMaster;
    private static Offering_Master__c offProc;
    private static Service__c service;
    private static Solution_Scope__c solComp;
    private static Assumptions_Master__c assumptionmaster;
    private static Opportunity_Assumption__c oppAssumption;
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
            
            
        
            
            
             offProc=new offering_master__c(name='HR Services', offering_description__c='test');
             offProc.Service_Group__c = 'BPO';
             insert offProc;
             
             Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
            insert customSetting;
            
            Offering_Name__c customSetting1=new Offering_Name__c(name='Sourcing and Procurement') ;
            insert customSetting1;
            
             clientDependencyMaster= new Client_Dependencies_Master__c (name='test', Offering__c= offProc.id);
            insert clientDependencyMaster;
            
             
            
            
            Services_Master__c sm = new Services_Master__c();
            sm.Name = 'Test';
            sm.offering__c = offProc.id;
            sm.active__c = true;
            sm.Solution_Component__c = 'Delivery';
            sm.Is_Offering_Specific_Service__c = true;
            sm.Service_Group__c = 'BPO';
            insert sm;
            
             solComp = new Solution_Scope__c(Opportunity__c = opp.id,Solution_Component__c = 'Delivery', Offering_Master__c = offProc.id,Service_Group__c = 'BPO');
            insert solComp;
        
        
            service= new Service__c(services__c=sm.id,Solutionscope__c=solComp.id);
            insert service;
           
            assumptionmaster= new Assumptions_Master__c(assumption__c='testing',name='test', Offering__c=offProc.id, Service__c=sm.id);
            insert assumptionmaster;
            
             Opportunity_Client_Dependency__c oppClientDep1= new Opportunity_Client_Dependency__c (Link_to_Client_Dependency_Master__c=clientDependencyMaster.id,offering__C=solComp.id,Service__c=service.id);
             insert oppClientDep1;
             
             
             Opportunity_Assumption__c oppAssumption1 =new Opportunity_Assumption__c(Assumption__c='testing',Offering__c=solComp.id,Service__c=service.id, Link_to_Master_Assumption__c=assumptionmaster.id);        
             insert oppAssumption1 ;
             
    }
    
     public static testmethod void testOppClientDependency(){
        setupData();
        oppClientDep= new Opportunity_Client_Dependency__c (Link_to_Client_Dependency_Master__c=clientDependencyMaster.id,offering__C=solComp.id,Service__c=service.id);
        
        
        insert oppClientDep;
        
        
        }
    
     public static testmethod void testOppAssumption(){
        setupData();
        oppAssumption =new Opportunity_Assumption__c(Assumption__c='testing',Offering__c=solComp.id,Service__c=service.id, Link_to_Master_Assumption__c=assumptionmaster.id);       
        insert oppAssumption ;
        
        
        }
    
     public static testmethod void testnewteammember(){
             setupData();
            Opportunity_Teams__c oppTeamNew1 = new Opportunity_Teams__c();
            oppTeamNew1.Opportunity__c = opp.Id;
            oppTeamNew1.Role__c = oppRoleMasterCCA.id;
            oppTeamNew1.Opportunity_Team_Member__c = testUserMaster.Id;
            oppTeamNew1.Request_Team_Member__c = true;
            oppTeamNew1.Team_Member_Request_Status__c = UtilConstants.IN_PROGRESS;
            //oppTeam.Opportunity_Team_Member__c = oppTeamMember.Id;
            oppTeamNew1.Assigned_Date__c = System.today(); 
            oppTeamNew1.Requestor__c  = testUserMaster.Id;

            insert oppTeamNew1;
            
     
     }
    
    
    }