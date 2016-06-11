@isTest
/*
  @Author: 
  @Name: checkDeleteMWB_Latest_NovaTest 
  @Created Date: 01 January 2015
  @Description: This is a test class for checking the deletion of the MWB on latest Nova.
  @version: 1.0
*/
private class checkDeleteMWB_Latest_NovaTest {
  private static User testUser;
  private static Opportunity_Roles_Master__c oppRoleMaster; 
  private Static Id parentId;
  private Static Id recordId;
  private Static String urlParamater;
  private static opportunity testOpportunity;
  private static User_Master__c testUserMaster;
  private static Deal__c testDeal;

/*
  @Author: 
  @Name: setUpData
  @Created Date: 01 January 2015
  @Description:This is a test method to test for the set up data in class.
  @version: 1.0
*/  
  static void setUpData(){
        testUser=new User();
    Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Admin);
        testUser=UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME,'test1@testorg.com');  
        
        UserRole role=UTIL_DataCreationForTestClass.getRole();
        testUser.UserRoleid=role.id;
        
        
    
    testOpportunity= new Opportunity(); 
        testOpportunity.name= UtilConstants.TEST_OPP;
        testOpportunity.Geo_Area__c= UTIL_Constants.AsiaPacific;        
        testOpportunity.Reporting_Status__c= UtilConstants.UNQUALIFIED;        
        testOpportunity.StageName= UtilConstants.OA;        
        testOpportunity.Risk_Level__c= UtilConstants.LOW;        
        testOpportunity.CloseDate= date.newInstance(2001, 3, 21);  
        testOpportunity.BPO_Net_Rev_Thousands__c = 1000;
      
    testUserMaster = new User_Master__c();
        testUserMaster.name='Test User Master';
        testUserMaster.user__c=testUser.id;
            
        
            
        testDeal=new Deal__c(Name='Test Deal',Approver__c=testUser.id,Opportunity__c=testOpportunity.id,Approval_Status__c='Approved');
        
  }
 
/*
  @Author: 
  @Name: testCheckDeleteMobTeam
  @Created Date: 01 January 2015
  @Description: This is a test method to check whether a MobTeam is deleted or not.
  @version: 1.0
*/ 
 static testMethod void testCheckDeleteMobTeam(){
      checkDeleteMWB_Latest_NovaTest.setUpData();
            
            
          insert testuser;
          
          System.runAs(testUser){
            Test.startTest();
                insert testOpportunity;
                insert testUserMaster;
                
                Mobilization_Team__c testTeam=new Mobilization_team__c(Deal__c=testDeal.id);
                insert testTeam;
                
                ApexPages.StandardController testController=new ApexPages.StandardController(testTeam);
                PageReference pageRef=Page.DeleteMobilizationTeamMember;
                pageRef.getParameters().put('id',testTeam.id);
                pageRef.getParameters().put('retURL','/pageRef');
                Test.setCurrentPage(pageRef);
                CheckDeleteMWB testCheck=new CheckDeleteMWB(testController);
                testCheck.parentId=testDeal.id;
                testCheck.CheckDeleteMWB();
            
                Test.stopTest();
            }
    
  }

/*
  @Author: 
  @Name: testCheckDeleteMobPlan
  @Created Date: 01 January 2015
  @Description: This is a test method to check whether a MobPlan is deleted or not.
  @version: 1.0
*/  
  static testMethod void testCheckDeleteMobPlan(){
    checkDeleteMWB_Latest_NovaTest.setUpData();
            
            
          insert testuser;
          System.runAs(testUser){
            Test.startTest();
        insert testOpportunity;
        insert testUserMaster;
        insert testDeal;
          
        Mobilization_Plan__c testMobPlan=new Mobilization_Plan__c(Deal__c=testDeal.id);
        insert testMobPlan;
        
        ApexPages.StandardController testMObController=new ApexPages.StandardController(testMobPlan);
        PageReference pageRefMob=Page.DeleteMobilizationPlan;
        pageRefMob.getParameters().put('id',testMobPlan.id);
        pageRefMob.getParameters().put('retURL','/pageRefMob');
        Test.setCurrentPage(pageRefMob);
        CheckDeleteMWB testMobCheck=new CheckDeleteMWB(testMObController);
        testMobCheck.parentId=testMobPlan.id;
        testMobCheck.CheckDeleteMWB();
        
        Test.stopTest();
      }
  }

/*
  @Author: 
  @Name: testCheckDeleteWave
  @Created Date: 01 January 2015
  @Description: This is a test methed to check whether a Wave is deleted or not.
  @version: 1.0
*/  
  static testMethod void testCheckDeleteWave(){
    checkDeleteMWB_Latest_NovaTest.setUpData();
            
            
          insert testuser;
          System.runAs(testUser){
            Test.startTest();
        insert testOpportunity;
        insert testUserMaster;
        insert testDeal;
        
        Mobilization_Plan__c testMobPlan=new Mobilization_Plan__c(Deal__c=testDeal.id);
        insert testMobPlan;
        
        Wave__c testWave=new Wave__c(Mobilization_Plan__c=testMobPlan.id,Active__c=TRUE);
        insert testWave;
        
        ApexPages.StandardController testWaveController=new ApexPages.StandardController(testWave);
        PageReference pageRefWave=Page.DeleteWave;
        pageRefWave.getParameters().put('id',testWave.id);
        pageRefWave.getParameters().put('retURL','/pageRefWave');
        Test.setCurrentPage(pageRefWave);
        CheckDeleteMWB testWaveCheck=new CheckDeleteMWB(testWaveController);
        testWaveCheck.parentId=testWave.id;
        testWaveCheck.CheckDeleteMWB();
        
        Test.stopTest();
        
      }
  }
  
/*
  @Author: 
  @Name: testCheckDeleteBudget
  @Created Date: 01 January 2015
  @Description: This is a test mehtod to check whether a Budget is deleted or not.
  @version: 1.0
*/
  static testMethod void testCheckDeleteBudget(){
    checkDeleteMWB_Latest_NovaTest.setUpData();
            
            
          insert testuser;
          System.runAs(testUser){
            Test.startTest();
        insert testOpportunity;
        insert testUserMaster;
        insert testDeal;
        
        Mobilization_Plan__c testMobPlan=new Mobilization_Plan__c(Deal__c=testDeal.id);
        insert testMobPlan;
        
        Budget_Trac__c testBudget=new Budget_Trac__c(Mobilization_Plan__c=testMobPlan.id);
        insert testBudget;
        
        ApexPages.StandardController testBudgetController=new ApexPages.StandardController(testBudget);
        PageReference pageRefBudget=Page.DeleteBudgetTrackingItem;
        pageRefBudget.getParameters().put('id',testBudget.id);
        pageRefBudget.getParameters().put('retURL','/pageRefBudget');
        Test.setCurrentPage(pageRefBudget);
        CheckDeleteMWB testBudgetCheck=new CheckDeleteMWB(testBudgetController);
        testBudgetCheck.parentId=testBudget.id;
        testBudgetCheck.CheckDeleteMWB();
        Test.stopTest();
      }
  }
  
/*
  @Author: 
  @Name: testCheckDeleteBCP
  @Created Date: 01 January 2015
  @Description:This is a test method to test whether a BCP is deleted or not.
  @version: 1.0
*/
  static testMethod void testCheckDeleteBCP(){
      checkDeleteMWB_Latest_NovaTest.setUpData();
            
            
          insert testuser;
          System.runAs(testUser){
            Test.startTest();
        insert testOpportunity;
        insert testUserMaster;
        insert testDeal;
        
        Mobilization_Plan__c testMobPlan=new Mobilization_Plan__c(Deal__c=testDeal.id);
        insert testMobPlan;
      
        BCP_Tracker__c bcp=new BCP_Tracker__c(Mobilization_Plan__c=testMobPlan.id);
        insert bcp;
        ApexPages.StandardController testBCPController=new ApexPages.StandardController(bcp);
        PageReference pageRefBcp=Page.DeleteBCPTracker;
        pageRefBcp.getParameters().put('id',bcp.id);
        pageRefBcp.getParameters().put('retURL','/pageRefBcp');
        Test.setCurrentPage(pageRefBcp);
        CheckDeleteMWB testBcpCheck=new CheckDeleteMWB(testBcpController);
        testBcpCheck.parentId=bcp.id;
        testBcpCheck.CheckDeleteMWB();
        Test.stopTest();
      }
      
  }
  
/*
  @Author: 
  @Name: testCheckDeleteContract
  @Created Date: 01 January 2015
  @Description: This is a test method to check whether a Contract is deleted or not.
  @version: 1.0
*/
  static testMethod void testCheckDeleteContract(){
    checkDeleteMWB_Latest_NovaTest.setUpData();
        Test.startTest();
            
        insert testuser;
          System.runAs(testUser){
      insert testOpportunity;
      insert testUserMaster;
      insert testDeal;
        
      Mobilization_Plan__c testMobPlan=new Mobilization_Plan__c(Deal__c=testDeal.id);
      insert testMobPlan;  
      
      Contract_Legal_Tracker__c contract = new Contract_Legal_Tracker__c(Mobilization_Plan__c=testMobPlan.id);
            insert contract;
            
            ApexPages.StandardController testContractController=new ApexPages.StandardController(contract);
            PageReference pageRefContract=Page.DeleteBCPTracker;
            pageRefContract.getParameters().put('id',contract.id);
            pageRefContract.getParameters().put('retURL','/pageRefBcp');
            Test.setCurrentPage(pageRefContract);
            CheckDeleteMWB testContract=new CheckDeleteMWB(testContractController);
            testContract.parentId=contract.id;
            testContract.CheckDeleteMWB();
            Test.stopTest();
    }
    
  }
  

/*
  @Author: 
  @Name: testCheckDeleteService
  @Created Date: 01 January 2015
  @Description: This is a test method to check whether Service is deleted or not.
  @version: 1.0
*/
  static testMethod void testCheckDeleteService(){
    checkDeleteMWB_Latest_NovaTest.setUpData();
        
            
        insert testuser;
        System.runAs(testUser){
          Test.startTest();
      insert testOpportunity;
      insert testUserMaster;
      insert testDeal;
        
      Mobilization_Plan__c testMobPlan=new Mobilization_Plan__c(Deal__c=testDeal.id);
      insert testMobPlan;  
      
      Service_Management_Tracker__c service = new Service_Management_Tracker__c(Mobilization_Plan__c=testMobPlan.id);
            insert service;
            
            ApexPages.StandardController testServiceTracker=new ApexPages.StandardController(service);
            PageReference pageRefService=Page.DeleteBCPTracker;
            pageRefService.getParameters().put('id',service.id);
            pageRefService.getParameters().put('retURL','/pageRefBcp');
            Test.setCurrentPage(pageRefService);
            CheckDeleteMWB testService=new CheckDeleteMWB(testServiceTracker);
            testService.parentId=service.id;
            testService.CheckDeleteMWB();
            Test.stopTest();
    }
    
    
  }
  
/*
  @Author: 
  @Name: testCheckDeleteJourney
  @Created Date: 01 January 2015
  @Description:This is a test method to check whether Journey is deleted or not.
  @version: 1.0
*/
  static testMethod void testCheckDeleteJourney(){
    checkDeleteMWB_Latest_NovaTest.setUpData();
        
            
        insert testuser;
        System.runAs(testUser){
          Test.startTest();
      insert testOpportunity;
      insert testUserMaster;
      insert testDeal;
        
      Mobilization_Plan__c testMobPlan=new Mobilization_Plan__c(Deal__c=testDeal.id);
      insert testMobPlan;  
      
      Journey_Management_Tracker__c journey=new Journey_Management_Tracker__c(Mobilization_Plan__c=testMobPlan.id);
            insert journey;
            
            ApexPages.StandardController testjournayTracker=new ApexPages.StandardController(journey);
            PageReference pageRefJourney=Page.DeleteBCPTracker;
            pageRefJourney.getParameters().put('id',journey.id);
            pageRefJourney.getParameters().put('retURL','/pageRefBcp');
            Test.setCurrentPage(pageRefJourney);
            CheckDeleteMWB testjournay=new CheckDeleteMWB(testjournayTracker);
            testjournay.parentId=journey.id;
            testjournay.CheckDeleteMWB();
            Test.stopTest();
    }
    
  }
  

/*
  @Author: 
  @Name: testCheckDeleteWP
  @Created Date: 01 January 2015
  @Description: This is a test method to check whether WP is deleted or not.
  @version: 1.0
*/
  static testMethod void testCheckDeleteWP(){
    checkDeleteMWB_Latest_NovaTest.setUpData();
        
            
        insert testuser;
        System.runAs(testUser){
          Test.startTest();
      insert testOpportunity;
      insert testUserMaster;
      insert testDeal;
      
            Mobilization_Plan__c testMobPlan=new Mobilization_Plan__c(Deal__c=testDeal.id);
      insert testMobPlan;  
            
      Wave__c testWave=new Wave__c(Mobilization_Plan__c=testMobPlan.id,Active__c=TRUE);
      insert testWave;
      
      Wave_Proc__c wp=new Wave_Proc__c(wave__c=testWave.id,Active__C=TRUE);
            insert wp;
            
            ApexPages.StandardController testWp=new ApexPages.StandardController(wp);
            PageReference pageRefWp=Page.DeleteWaveProcess;
            pageRefWp.getParameters().put('id',wp.id);
            pageRefWp.getParameters().put('retURL','/pageRefWp');
            Test.setCurrentPage(pageRefWp);
            CheckDeleteMWB testWavePro=new CheckDeleteMWB(testWp);
            testWavePro.parentId=wp.id;
            testWavePro.CheckDeleteMWB();
            Test.stopTest();
    }
    
  }

/*
  @Author: 
  @Name: testCheckDeleteKT
  @Created Date: 01 January 2015
  @Description: This is the test mehtod to check whether KT is deleted or not.
  @version: 1.0
*/  
  static testMethod void testCheckDeleteKT(){
    checkDeleteMWB_Latest_NovaTest.setUpData();
        
            
        insert testuser;
        System.runAs(testUser){
          Test.startTest();
      insert testOpportunity;
      insert testUserMaster;
      insert testDeal;
      
            Mobilization_Plan__c testMobPlan=new Mobilization_Plan__c(Deal__c=testDeal.id);
      insert testMobPlan;  
            
      Wave__c testWave=new Wave__c(Mobilization_Plan__c=testMobPlan.id,Active__c=TRUE);
      insert testWave;
      
      KT_Trac__c kt= new KT_Trac__c(wave__c=testWave.id);
            insert kt;
            
            ApexPages.StandardController testKt=new ApexPages.StandardController(kt);
            PageReference pagerefKt=Page.DeleteWaveProcess;
            pagerefKt.getParameters().put('id',kt.id);
            pagerefKt.getParameters().put('retURL','/pagerefKt');
            Test.setCurrentPage(pagerefKt);
            CheckDeleteMWB testKtTracker=new CheckDeleteMWB(testKt);
            testKtTracker.parentId=kt.id;
            testKtTracker.CheckDeleteMWB();
            Test.stopTest();
    }
    
    
  }
  

/*
  @Author: 
  @Name: testCheckDeleteRecruit
  @Created Date: 01 January 2015
  @Description:This is a test method to check whether Recruit is deleted or not.
  @version: 1.0
*/
  static testMethod void testCheckDeleteRecruit(){
    checkDeleteMWB_Latest_NovaTest.setUpData();
        
            
        insert testuser;
        System.runAs(testUser){
          Test.startTest();
      insert testOpportunity;
      insert testUserMaster;
      insert testDeal;
      
            Mobilization_Plan__c testMobPlan=new Mobilization_Plan__c(Deal__c=testDeal.id);
      insert testMobPlan;  
            
      Wave__c testWave=new Wave__c(Mobilization_Plan__c=testMobPlan.id,Active__c=TRUE);
      insert testWave;
      
      Recruit_Tracker__c recruit=new Recruit_Tracker__c(wave__c=testWave.id);
            insert recruit;
            
            ApexPages.StandardController testRt=new ApexPages.StandardController(recruit);
            PageReference pageRecruit=Page.DeleteRecruitmentTrackingItem;
            pageRecruit.getParameters().put('id',recruit.id);
            pageRecruit.getParameters().put('retURL','/pageRecruit');
            Test.setCurrentPage(pageRecruit);
            CheckDeleteMWB testRecruit=new CheckDeleteMWB(testRt);
            testRecruit.parentId=recruit.id;
            testRecruit.CheckDeleteMWB();
            Test.stopTest();
    }
    
    
  }
  
/*
  @Author: 
  @Name: testCheckDeleteTech
  @Created Date: 01 January 2015
  @Description: This is a test method to check whether Tech is deleted.
  @version: 1.0
*/
  static testMethod void testCheckDeleteTech(){
    checkDeleteMWB_Latest_NovaTest.setUpData();
        
            
        insert testuser;
        System.runAs(testUser){
          Test.startTest();
      insert testOpportunity;
      insert testUserMaster;
      insert testDeal;
      
      Mobilization_Plan__c testMobPlan=new Mobilization_Plan__c(Deal__c=testDeal.id);
      insert testMobPlan;
            
      Wave__c testWave=new Wave__c(Mobilization_Plan__c=testMobPlan.id,Active__c=TRUE);
      insert testWave;
      
      Tech_WE_Tracker__c tech=new Tech_WE_Tracker__c(wave__c=testWave.id);
            insert tech;    
                  
      ApexPages.StandardController testTech=new ApexPages.StandardController(tech);
            PageReference pageTech=Page.DeleteTechWETrackerItem;
            pageTech.getParameters().put('id',tech.id);
            pageTech.getParameters().put('retURL','/pageTech');
            Test.setCurrentPage(pageTech);
            CheckDeleteMWB testTechT=new CheckDeleteMWB(testTech);
            testTechT.parentId=tech.id;
            testTechT.CheckDeleteMWB();
            Test.stopTest();
      
    }
    
    
    
  }

/*
  @Author: 
  @Name: testCheckDeleteOpex
  @Created Date: 01 January 2015
  @Description: This is a test method to check whether Opex is deleted or not.
  @version: 1.0
*/
  static testMethod void testCheckDeleteOpex(){
    checkDeleteMWB_Latest_NovaTest.setUpData();
        
            
        insert testuser;
        System.runAs(testUser){
          Test.startTest();
      insert testOpportunity;
      insert testUserMaster;
      insert testDeal;
      
      Mobilization_Plan__c testMobPlan=new Mobilization_Plan__c(Deal__c=testDeal.id);
      insert testMobPlan;  
            
      Wave__c testWave=new Wave__c(Mobilization_Plan__c=testMobPlan.id,Active__c=TRUE);
      insert testWave;
      
      OPEX_Tracker__c opex=new OPEX_Tracker__c(name='Day 1 Test',wave__c=testWave.id,Days_After_Go_Live__c =5.0);
            insert opex;
            
            ApexPages.StandardController testOpex=new ApexPages.StandardController(opex);
            PageReference pageOpex=Page.DeleteOPEXTrackerItem;
            pageOpex.getParameters().put('id',opex.id);
            pageOpex.getParameters().put('retURL','/pageOpex');
            Test.setCurrentPage(pageOpex);
            CheckDeleteMWB testOpexT=new CheckDeleteMWB(testOpex);
            testOpexT.parentId=opex.id;
            testOpexT.CheckDeleteMWB();
            Test.stopTest();
    }
    
  }
  
/*
  @Author: 
  @Name: testCheckDeleteRisks
  @Created Date: 01 January 2015
  @Description: This is a test method to check whether risk is deleted or not.
  @version: 1.0
*/
  static testMethod void testCheckDeleteRisks(){
    checkDeleteMWB_Latest_NovaTest.setUpData();
        
            
        insert testuser;
        System.runAs(testUser){
          Test.startTest();
      insert testOpportunity;
      insert testUserMaster;
      insert testDeal;
      
      Risks__c risk=new Risks__c(deal__c=testDeal.id);
            insert risk;
            
            ApexPages.StandardController testRisk=new ApexPages.StandardController(risk);
            PageReference pageRisk=Page.DeleteRisks;
            pageRisk.getParameters().put('id',risk.id);
            pageRisk.getParameters().put('retURL','/pageRisk');
            Test.setCurrentPage(pageRisk);
            CheckDeleteMWB testRiskMe=new CheckDeleteMWB(testRisk);
            testRiskMe.parentId=risk.id;
            testRiskMe.CheckDeleteMWB();
            Test.stopTest();
    }
    
  }
  
}