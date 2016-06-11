/******************************
   @Author       : Jyotsna
   @Class name   : CanvasClassTest
   @CreateDate   : 1-July-2015
   @Description : Test class for CanvasClass 
   @Version : 1.0 
*******************************/
@isTest

private class CanvasClassTest{
     /******************************
     * Method Name: testJSON
     * Description: test method to test generateJSONContent()
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
    static testMethod void testJSON() {
         Profile p = UnitTestDatafactory.getProfile('System Administrator');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='test.123=test@test.com');
         insert uMaster;
         system.runAs(u) {
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         Database.insert(TestOpportunity);
        Costing_Request__c costingReq = new Costing_Request__c();
        costingReq.Opportunity__c= TestOpportunity.Id;
        costingReq.Is_Checked_Out__c = true;
        insert costingReq;
        PageReference pg = Page.EditCanvas;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
        
        test.startTest();
           CanvasClass cc = new CanvasClass(sc);
           cc.getgenerateJSONContent();
           cc.getHostUrl();
           cc.checkin();
           cc.checkout();
           cc.saveRecord();
           cc.forceCheckIn();
           cc.clearPrevData();
           cc.showUpdates();
        test.stopTest();
        }
    }
    
    /******************************
     * Method Name: testJSON1
     * Description: test method to test generateJSONContent()
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
    static testMethod void testJSON1() {
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
         Offering_Master__c offProc=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
         offProc.Service_Group__c = 'BPO';
         insert offProc;
        
         Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
         insert customSetting;  
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         insert TestOpportunity;
         List < Solution_Scope__c > solCompList = new List < Solution_Scope__c > ();
            Solution_Scope__c solComp;
            
            solComp = new Solution_Scope__c(Active__c = True, Opportunity__c = TestOpportunity.id, 
                                        Solution_Component__c = 'Delivery', Offering_Master__c = customSetting.Name__c, 
                                        Service_Group__c = 'BPO',  SAP_Offering_Revenue__c = 20);
            insert solComp;
            opportunity oppr = [Select Id,Name,sap_om_id__c,Account.name,Contract_Start_Date__c,Contract_End_Date__c,Initial_Go_live_Date__c,OperatingGroup__r.name,Geo_Area__c,Fast_Track_Component__c,( Select Id,Name,Solution_Component__c,Offering_Master__r.name from Solution_Components__r ),( Select Id,Name,Opportunity_Team_Member__c from Opportunity_Team__r ) from Opportunity where Id=:TestOpportunity.Id limit 1 ];
            system.debug('***********'+oppr.Solution_Components__r );
        Costing_Request__c costingReq = new Costing_Request__c();
        costingReq.Opportunity__c= TestOpportunity.Id;
        costingReq.country__c = 'India';
        insert costingReq;
        PageReference pg = Page.EditCanvas;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
        
        test.startTest();
           CanvasClass cc = new CanvasClass(sc);
           cc.getgenerateJSONContent();
           
        test.stopTest();
        
    }
    /******************************
     * Method Name: testJSON2
     * Description: test method to test generateJSONContent()
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
    static testMethod void testJSON2() {
         Profile p = UTIL_DataCreationForTestClass.getProfile('Solution Read Only');
         User u = UTIL_DataCreationForTestClass.getUserWithProfile(p,'yetre@asad.com');
         insert u;
         User_Master__c userMaster = new User_Master__c(User__c=u.id,Active__c=true,email__c='test.123=test@test.com');
         insert userMaster;
         system.runAs(u){
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
         Offering_Master__c offProc=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
         offProc.Service_Group__c = 'BPO';
         insert offProc;
        
         Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
         insert customSetting;  
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         insert TestOpportunity;
         List < Solution_Scope__c > solCompList = new List < Solution_Scope__c > ();
            Solution_Scope__c solComp;
            
            solComp = new Solution_Scope__c(Active__c = True, Opportunity__c = TestOpportunity.id, 
                                        Solution_Component__c = 'Delivery', Offering_Master__c = customSetting.Name__c, 
                                        Service_Group__c = 'BPO',  SAP_Offering_Revenue__c = 20);
            insert solComp;
            Opportunity_Teams__c oppTeam = new Opportunity_Teams__c(Opportunity__c=TestOpportunity.id,Opportunity_Team_Member__c=userMaster.Id);
            insert oppTeam;
        Costing_Request__c costingReq = new Costing_Request__c();
        costingReq.Opportunity__c= TestOpportunity.Id;
        costingReq.country__c = 'India;USA';
        costingReq.Is_Checked_Out__c = true;
        insert costingReq;
       // System.runAs(u) {
        PageReference pg = Page.EditCanvas;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
        
        test.startTest();
           CanvasClass cc = new CanvasClass(sc);
           cc.getgenerateJSONContent();
           
        test.stopTest();
            
        }
    }
    
    /******************************
     * Method Name: testJSON
     * Description: test method to test generateJSONContent()
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
    static testMethod void testCheckIn() {
         Profile p = UnitTestDatafactory.getProfile('System Administrator');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='test.123=test@test.com');
         insert uMaster;
         system.runAs(u) {
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         Database.insert(TestOpportunity);
        Costing_Request__c costingReq = new Costing_Request__c();
        costingReq.Opportunity__c= TestOpportunity.Id;
        //costingReq.Is_Checked_Out__c = true;
        insert costingReq;
        PageReference pg = Page.EditCanvas;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
        
       // cc.checkout();
        test.startTest();
           CanvasClass cc = new CanvasClass(sc);
           cc.forceCheckIn();
           cc.checkin();
        test.stopTest();
        }
    }
    
    /******************************
     * Method Name: testJSON
     * Description: test method to test generateJSONContent()
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
    static testMethod void testException() {
         Profile p = UnitTestDatafactory.getProfile('System Administrator');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='test.123=test@test.com');
         insert uMaster;
         system.runAs(u) {
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         Database.insert(TestOpportunity);
        Costing_Request__c costingReq = new Costing_Request__c();
        costingReq.Opportunity__c= TestOpportunity.Id;
        insert costingReq;
        PageReference pg = Page.EditCanvas;
        Test.setCurrentPage(pg);
        Costing_Request__c csToUpdate = [Select id,name,contract_start__c,contract_end__c from costing_request__c where id=:costingReq.Id];
        csToUpdate.contract_start__c = system.today();
        csToUpdate.contract_end__c = system.today();
        pg.getParameters().put('id', csToUpdate.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(csToUpdate);
        
        test.startTest();
           CanvasClass cc = new CanvasClass(sc);
           cc.checkout();
        test.stopTest();
        }
    }
    
}