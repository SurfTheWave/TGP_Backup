/**
 * Name : VFC_Utilizations_Nova_Test
 * Author : NovaCop Unit Test Generator
 * Description : Test class used for testing the VFC_Utilizations
 * Date : 3/18/15 6:19 PM 
 * Version : <intial Draft> 
 * TODO : This code is auto-generated. Developer should update the inputs for unit tests as well as expected results in assertions
 */
@isTest
private class VFC_Utilizations_Test { 
/*
  @Author: 
  @Name: setUpData
  @Created Date: 01 January 2015
  @Description: This is a test method setUpData for data setup.
  @version: 1.0
*/
    public static void setUpData(){

        //DateTime dt = DateTime.newInstance(2015, 3, 30, 10, 7, 0);
        //String refDate = dt.formatLong();
        Utilization_weekStartDate__c myCS = new Utilization_weekStartDate__c(Name = 'MondayDate',Referenced_Date__c = system.today());
        insert myCS;
        Utilization_weekStartDate__c myCS1 = new Utilization_weekStartDate__c(Name = 'SundayDate',Referenced_Date__c = system.today());
        insert myCS1;
        //User_Master__c userObj = new User_Master__c();
        //database.saveResult sr = database.insert (userObj);
        //system.debug('saved usermaster::::::::::::'+sr);
        
        //Creating Account
        Account acc = new Account(Name = 'Test_Account');
        insert acc;
        
        //Creating Opportunity
        Opportunity opp = new Opportunity();
        
        opp.Name = UtilConstants.TEST_OPP;
        opp.Reporting_Status__c = UtilConstants.PIPELINE;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Account = acc;
        
        Opportunity opp2 = new Opportunity();
        
        opp2.Name = UtilConstants.OPP_NAME_LIST_0;
        opp2.Reporting_Status__c = UtilConstants.PIPELINE;
        opp2.Geo_Area__c = UtilConstants.EALA;
        opp2.StageName = UtilConstants.TWO_B;
        opp2.Risk_Level__c = UtilConstants.NORMAL;
        opp2.CloseDate = System.today();
        opp2.Account = acc;
        
        Opportunity opp3 = new Opportunity();
        
        opp3.Name = UtilConstants.OPP_NAME_LIST;
        opp3.Reporting_Status__c = UtilConstants.PIPELINE;
        opp3.Geo_Area__c = UtilConstants.EALA;
        opp3.StageName = UtilConstants.TWO_B;
        opp3.Risk_Level__c = UtilConstants.NORMAL;
        opp3.CloseDate = System.today();
        opp3.Account = acc;
        
        
        insert opp;
        insert opp2;
        insert opp3;
        
        //User and E-mail
        ID userID = UserInfo.getUserID();
        String Email = [Select Email from User where ID =: userID LIMIT 1].Email;
        
        //User master record
        User_Master__c userObj = new User_Master__c(User__c = userID, Email__c = Email);
        insert userObj;
        
        
        
        
        Utilizations__c utilObj = new Utilizations__c(User__c = userObj.id,Current_Week__c = 0.00, Opportunity__c = opp.ID, 
                                                 Current_Week_1__c = 1.00,
                                                 Current_Week_2__c = 2.00,
                                                 Current_Week_3__c = 0.00,
                                                 Current_Week_4__c = 1.00);
        Utilizations__c utilObj1 = new Utilizations__c(User__c = userObj.id,Current_Week__c = null, Opportunity__c = opp2.ID,
                                                 Current_Week_1__c = null,
                                                 Current_Week_2__c = null,
                                                 Current_Week_3__c = null,
                                                 Current_Week_4__c = null);
        Utilizations__c utilObj2 = new Utilizations__c(User__c = userObj.id,Current_Week__c = null, Opportunity__c = opp3.ID,
                                                 Current_Week_1__c = null,
                                                 Current_Week_2__c = null,
                                                 Current_Week_3__c = null,
                                                 Current_Week_4__c = null);
               
        List<Utilizations__c> utilList = new List<Utilizations__c>{utilObj,utilObj1, utilObj2};
        List<database.saveResult> sr1 = Database.insert(utilList);
        //system.debug('saved utilizations::::::::::::'+sr1);
        
    }
    /*
     *@name testInit_Scenario1()
     *@return void 
     *@description This method for init () In CLASS VFC_Utilizations.cls
     */
     static testMethod void  testInit_Scenario1(){ 
        User stdUser = UtilNovaUnitTest.getUser();
        setUpData();
        Test.startTest();
        VFC_Utilizations vFCUtilizationsTest  =  new  VFC_Utilizations();
        VFC_Utilizations.aggregateVal aggre = new VFC_Utilizations.aggregateVal();
         aggre.clientName = 'Test Client';
         aggre.opporunityName = 'Test Opportunity';
         aggre.currentWeek = 0;
         aggre.currentWeek1 = 0;
         aggre.currentWeek2 = 0;
         aggre.currentWeek3 = 0;
         aggre.currentWeek4 = 0;
        
        VFC_Utilizations.aggregateVal1 aggre1  =  new  VFC_Utilizations.aggregateVal1();
        aggre1.clientName = 'Test Client';
        aggre1.opporunityName = 'Test Opportunity';
        aggre1.currentWeekPercent = 0;
        aggre1.currentWeek1Percent = 0;
        aggre1.currentWeek2Percent = 0;
        aggre1.currentWeek3Percent = 0;
        aggre1.currentWeek4Percent = 0;
        Test.setCurrentPage(Page.VFP_Utilizations);
        
        System.runAs(stdUser) {
            vFCUtilizationsTest.dosave();
            vFCUtilizationsTest.reDirect();
            Test.stopTest();
            System.assert(true);
        }
    }
    /*
     *@name testDoSave_Scenario1()
     *@return void 
     *@description This method for doSave () In CLASS VFC_Utilizations.cls
     */
     static testMethod void  testDoSave_Scenario1(){ 
        User stdUser = UtilNovaUnitTest.getUser();
        VFC_Utilizations vFCUtilizationsTest  =  new  VFC_Utilizations();
        Test.startTest();
        Test.setCurrentPage(Page.VFP_Utilizations);
        System.runAs(stdUser) {
            PageReference pagereferenceTest = vFCUtilizationsTest.doSave();
            /*system.debug('ut---------'+ut.Current_Week__c);
            system.debug('ut1---------'+ut1.Current_Week__c);
            system.debug('ut2---------'+ut2.Current_Week__c);
            system.debug('ut3---------'+ut3.Current_Week__c);
            */
            Test.stopTest();
             System.assert(pagereferenceTest!=null);
        }
    }
    /*
     *@name testDoCancel_Scenario1()
     *@return void 
     *@description This method for doCancel () In CLASS VFC_Utilizations.cls
     */
     static testMethod void  testDoCancel_Scenario1(){ 
        User stdUser = UtilNovaUnitTest.getUser();
        VFC_Utilizations vFCUtilizationsTest  =  new  VFC_Utilizations();
        Test.startTest();
        Test.setCurrentPage(Page.VFP_Utilizations);
        System.runAs(stdUser) {
            PageReference pagereferenceTest = vFCUtilizationsTest.doCancel();
            Test.stopTest();
             System.assert(pagereferenceTest!=null);
        }
    }
    /*
     *@name testReDirect_Scenario1()
     *@return void 
     *@description This method for reDirect () In CLASS VFC_Utilizations.cls
     */
     static testMethod void  testReDirect_Scenario1(){ 
        User stdUser = UtilNovaUnitTest.getUser();
        VFC_Utilizations vFCUtilizationsTest  =  new  VFC_Utilizations();
        Test.startTest();
        Test.setCurrentPage(Page.VFP_Utilizations);
        System.runAs(stdUser) {
            PageReference pagereferenceTest = vFCUtilizationsTest.reDirect();
            Test.stopTest();
            // System.assert(pagereferenceTest!=null);
        }
    }
}