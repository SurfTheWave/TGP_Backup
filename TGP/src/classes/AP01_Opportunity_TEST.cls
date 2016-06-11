/**
   @Author : Jayashree Pradhan
   @name   : AP01_Opportunity_TEST
   @CreateDate : 1 January 2015 
   @Description : TriggerHandler test Class for triggers on Opportunity object
   @Version : 1.0 
  */
@isTest
private class AP01_Opportunity_TEST {
    private static List<Opportunity> oppList = new List<Opportunity>();
    private static List<Opportunity> oppNewList = new List<Opportunity>();
    private static List<Opportunity> oppListNegative = new List<Opportunity>();
    private static Map<id,Opportunity> oppMap = new Map<id,Opportunity>();
    private static Map<id,Opportunity> oppAnalyticsMap = new Map<id,Opportunity>();
    private static Opportunity opp;
    private static Opportunity_Roles_Master__c oppRoleMasterOSL;
    private static User stdUser;
    private static User_Master__c testUserMaster;
    /**
   *  @Description : This method is used to create test data for opportunity
   *  @name : init
   *  @param : N/A
   *  @return parameter - void
   *  @throws exception- N/A
   */
    private static void init(){
        
        stdUser = UtilNovaUnitTest.getUser();
        insert stdUser;
         
        Operating_Groups_Master__c oppGrpMaster = new Operating_Groups_Master__c(Name = 'TestOpperatingGroup', Active__c = true);
        insert oppGrpMaster;
        
        oppRoleMasterOSL = new Opportunity_Roles_Master__c(Name = label.Opportunity_Solution_Lead,ShouldReceiveAlertMail__c= true, Description__c = UtilConstants.TEST_DESC,BPO_Role__c=true,IO_Role__c=false,IC_Role__c=false);
        insert oppRoleMasterOSL;
        
            testUserMaster = new User_Master__c();
            testUserMaster.Name = 'testUser Master';
            testUserMaster.user__c = stdUser.Id;
            insert testUserMaster;
        
        Offering_Master__c offMaster = new Offering_Master__c(Name = 'Cross Offering',offering_description__c = UtilConstants.TEST_DESC,
                                    flywheel_non_flywheel__c = UtilConstants.FLYWHEEL,Service_Group__c = 'BPO',active__c = true);
        insert offMaster;  
           
        Services_Master__c serviceMaster = new Services_Master__c(Name = 'ALL', offering__c = offMaster.id,Is_Offering_Specific_Service__c =false,
                                                                  Solution_Component__c='Delivery',active__c = True,Service_Group__c = 'BPO');
        insert serviceMaster; 
        
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
        opp.Analytics_in_Scope__c = true;
        opp.Capacity_Services_in_Scope__c = true;
        opp.BPO_Net_Rev_Thousands__c = 78;
        insert opp;
        
        oppList.add(opp);
        
        for(opportunity oppRec : oppList){
            oppMap.put(oppRec.id,oppRec);
            oppAnalyticsMap.put(oppRec.id,oppRec);
        }
        
         Opportunity_Additional_Role_Master__c oppMaster = new Opportunity_Additional_Role_Master__c(Name = 'BPO Sales Lead', description__c = 'test Desc', ShouldBePopulatedFromSAP__c = true, active__c = True, BPO_Role__c = True, IC_Role__c = True);
         insert oppMaster;
         
         Capacity_Service_Data__c capData = new Capacity_Service_Data__c(name = 'test',Opportunity__c=opp.id); 
         insert  capData;
         
         Analytics_Datas__c  AnaData = new Analytics_Datas__c (name = 'test',Opportunity__c=opp.id);
         insert AnaData ;
    }
    
    /**
   *  @Description : This method is used to create capacity Service for opportunity
   *  @name : testCapacityServices
   *  @param : N/A
   *  @return parameter - void
   *  @throws exception- N/A
   */
    static testMethod void testcreateOppAddTeamRec() {
        init();
        test.starttest();
        AP01_Opportunity oppHandler = new AP01_Opportunity();
        AP01_Opportunity.createOppAddTeamRec(oppList);
        test.stopTest();        
    }
    /**
   *  @Description : 
   *  @name : testcreateOSL
   *  @param : N/A
   *  @return parameter - void
   *  @throws exception- N/A
   */
    static testMethod void testcreateOSL() {
        init();
        test.starttest();
            system.runAs(stdUser){
                AP01_Opportunity oppHandler = new AP01_Opportunity();
                AP01_Opportunity.createOppOSLTeamRec(oppList);
            }
        test.stopTest();        
    }
    /**
   *  @Description : 
   *  @name : testupdateCapacityRec
   *  @param : N/A
   *  @return parameter - void
   *  @throws exception- N/A
   */
     static testMethod void testupdateCapacityRec() {
        init();
        test.starttest();
            opp.name = 'Test Again';
            update opp;
            oppNewList.add(opp);
            system.runAs(stdUser){
                AP01_Opportunity oppHandler = new AP01_Opportunity();
                oppHandler.updateCapacityRec(oppNewList,oppMap);
            }
        test.stopTest();        
    }
    
    /**
   *  @Description : This method is used to create Analytic Service for opportunity
   *  @name : testAnalyticServices
   *  @param : N/A
   *  @return parameter - void
   *  @throws exception- N/A
   */
    static testMethod void testAnalyticServices() {
        init();
        test.starttest();
                opp.name = 'Test Again';
                update opp;
                oppNewList.add(opp);
                AP01_Opportunity oppHandler = new AP01_Opportunity();
                oppHandler.updateAnalyticsRec(oppList,oppAnalyticsMap);

            test.stopTest();        
    }
    
     /**
   *  @Description : This method is used for negative test case
   *  @name : testCapacityServicesNegative
   *  @param : N/A
   *  @return parameter - void
   *  @throws exception- N/A
   */ 
    static testMethod void testCapacityServicesNegative() {
        init();
        List<Opportunity> updateOppList = new List<Opportunity>();
        for(Opportunity oppRec : oppList) {
            oppRec.Capacity_Services_in_Scope__c = false;
            updateOppList.add(oppRec);
            
        }
        update updateOppList;
        
        test.starttest();
        AP01_Opportunity oppHandler = new AP01_Opportunity();
        oppHandler.updateCapacityRec(updateOppList,oppMap);
        test.stopTest();        
    }
    
       /**
   *  @Description : This method is used for negative test case
   *  @name : testAnalyticServicesNegative
   *  @param : N/A
   *  @return parameter - void
   *  @throws exception- N/A
   */
    static testMethod void testAnalyticServicesNegative() {
        init();
        List<Opportunity> updateOppList = new List<Opportunity>();
        for(Opportunity oppRec : oppList) {
            oppRec.Analytics_in_Scope__c = false;
            updateOppList.add(oppRec);
            
        }
        update updateOppList;
        
        test.starttest();
        AP01_Opportunity oppHandler = new AP01_Opportunity();
        oppHandler.updateAnalyticsRec(updateOppList,oppMap);
        AP01_Opportunity.createSolCompRec(oppList,'test');
        test.stopTest();        
    }
    /**
   *  @Description : 
   *  @name : testcreateSolCompRec
   *  @param : N/A
   *  @return parameter - void
   *  @throws exception- N/A
   */
    static testMethod void testcreateSolCompRec() {
        init();
        
        test.starttest();
        AP01_Opportunity oppHandler = new AP01_Opportunity();
        AP01_Opportunity.createSolCompRec(oppList,'test');
        test.stopTest();        
    }
}