/**
 * Name : VFC_LinkToSAPOMController_Nova_Test
 * Author : NovaCop Unit Test Generator
 * Description : Test class used for testing the VFC_LinkToSAPOMController
 * Date : 3/18/15 6:19 PM 
 * Version : <intial Draft> 
 * TODO : This code is auto-generated. Developer should update the inputs for unit tests as well as expected results in assertions
 */
@isTest
private class VFC_LinkToSAPOMController_Nova_Test { 
    
    public static Opportunity opp;
    public static Opportunity oppWithSAP;
    public static Solution_Scope__c solComp;
    public static Solution_Scope__c solCompForWithSAPOM;
    public static RecordType recType;
    public static Record_Type_ID__c rectypeId;
    public static Opportunity_Additional_Team__c oppAdditonal;
    public static Opportunity_Additional_Team__c oppAdditonalSAP;
      /******************************
     * Method Name: setUpData
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/
    public static void setUpData(){
    
        Offering_Master__c offProc=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
        insert offProc;
        
        Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
        insert customSetting;
        
        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        insert ogm;
        
        opp = new Opportunity();
        
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Name = UtilConstants.TEST_OPP;
        insert opp;
        
        oppWithSAP = new Opportunity();
        
        oppWithSAP.Reporting_Status__c = UtilConstants.WON;
        oppWithSAP.Geo_Area__c = UtilConstants.EALA;
        oppWithSAP.OperatingGroup__c = ogm.id;
        oppWithSAP.StageName = UtilConstants.TWO_B;
        oppWithSAP.Risk_Level__c = UtilConstants.NORMAL;
        oppWithSAP.CloseDate = System.today();
        oppWithSAP.Name = UtilConstants.TEST_OPP;
        insert oppWithSAP;
        
        //Offering_Master__c off= UTIL_DataCreationForTestClass.getOffering();
        //insert off;
        
        
        solComp = new Solution_Scope__c(Active__c = True, Opportunity__c = opp.id, 
                                        Solution_Component__c = 'Delivery', Offering_Master__c = customSetting.Name__c, 
                                        Service_Group__c = 'BPO',  SAP_Offering_Revenue__c = 20);
        insert solComp; 
        
        solCompForWithSAPOM = new Solution_Scope__c(Active__c = True, Opportunity__c = oppWithSAP.id, 
                                        Solution_Component__c = 'Delivery', Offering_Master__c = customSetting.Name__c, 
                                        Service_Group__c = 'BPO',  SAP_Offering_Revenue__c = 20);
        insert solCompForWithSAPOM;
        
        recType = [SELECT Id, Name, IsActive FROM RecordType where name = 'With SAP OM Id where ShouldBePopulatedFromSAP true' Limit 500];
        
        rectypeId = new Record_Type_ID__c(name = 'ShouldBePopulatedFromSAP true',ID__c = recType.id);
        insert rectypeId;
        
         Opportunity_Additional_Role_Master__c oppMaster = new Opportunity_Additional_Role_Master__c(Name = 'BPO Sales Lead', description__c = 'test Desc', ShouldBePopulatedFromSAP__c = true, active__c = True, BPO_Role__c = True, IC_Role__c = True);
         insert oppMaster;  
        
        oppAdditonal = new Opportunity_Additional_Team__c(Additional_Opportunity_Role__c = oppMaster.Id, 
                                    Opportunity__c = opp.Id, Additional_Opportunity_Team_Member__c = 'test Team Member',
                                     isChecked__c = True);
                                     
         insert oppAdditonal;
         
         oppAdditonalSAP = new Opportunity_Additional_Team__c(Additional_Opportunity_Role__c = oppMaster.Id, 
                                    Opportunity__c = oppWithSAP.Id, Additional_Opportunity_Team_Member__c = 'test Team Member',
                                     isChecked__c = True);
                                     
         insert oppAdditonalSAP;
    }
    /*
     *@name testGetListOfSAPOM_Scenario1()
     *@return void 
     *@description This method for getListOfSAPOM () In CLASS VFC_LinkToSAPOMController.cls
     */
     static testMethod void  testGetListOfSAPOM_Scenario1(){ 
     
         setUpData();
         
        User stdUser = UtilNovaUnitTest.getUser();
        
        VFC_LinkToSAPOMController vFCLinkToSAPOMControllerTest  =  new  VFC_LinkToSAPOMController();
        Test.startTest();
        Test.setCurrentPage(Page.VFP_LinkToSAPOM);
        ApexPages.currentPage().getParameters().put('oppId', opp.id);
        System.runAs(stdUser) {
            List<Opportunity> listTest = vFCLinkToSAPOMControllerTest.getListOfSAPOM();
            Test.stopTest();
             System.assert(listTest.isEmpty());
        }
    }
    /*
     *@name testCallSelect_Scenario1()
     *@return void 
     *@description This method for callSelect () In CLASS VFC_LinkToSAPOMController.cls
     */
     static testMethod void  testCallSelect_Scenario1(){ 
     
         setUpData();
         
        User stdUser = UtilNovaUnitTest.getUser();
       
        VFC_LinkToSAPOMController vFCLinkToSAPOMControllerTest  =  new  VFC_LinkToSAPOMController();
        Test.startTest();
        Test.setCurrentPage(Page.VFP_LinkToSAPOM);
        ApexPages.currentPage().getParameters().put('selectedId', oppWithSAP.id);
        System.runAs(stdUser) {
            vFCLinkToSAPOMControllerTest.callSelect();
            Test.stopTest();
             System.assert(true);
        }
    }
    /*
     *@name testSearchSelectedSAPOM_Scenario1()
     *@return void 
     *@description This method for searchSelectedSAPOM () In CLASS VFC_LinkToSAPOMController.cls
     */
     static testMethod void  testSearchSelectedSAPOM_Scenario1(){ 
        User stdUser = UtilNovaUnitTest.getUser();
        VFC_LinkToSAPOMController vFCLinkToSAPOMControllerTest  =  new  VFC_LinkToSAPOMController();
        Test.startTest();
        Test.setCurrentPage(Page.VFP_LinkToSAPOM);
        ApexPages.currentPage().getParameters().put('searchId', 'testSearchId');
        System.runAs(stdUser) {
            vFCLinkToSAPOMControllerTest.searchSelectedSAPOM();
            Test.stopTest();
             System.assert(true);
        }
    }
    /*
     *@name test
     _Scenario1()
     *@return void 
     *@description This method for doLink () In CLASS VFC_LinkToSAPOMController.cls
     * */
     static testMethod void  testDoLink_Scenario1(){ 
     
         setUpData();
         
        User stdUser = UtilNovaUnitTest.getUser();
        VFC_LinkToSAPOMController vFCLinkToSAPOMControllerTest  =  new  VFC_LinkToSAPOMController();
        Test.startTest();
        Test.setCurrentPage(Page.VFP_LinkToSAPOM);
        ApexPages.currentPage().getParameters().put('oppId', opp.id);
        ApexPages.currentPage().getParameters().put('selectedId', oppWithSAP.id);

        System.runAs(stdUser) {
        
            vFCLinkToSAPOMControllerTest.callSelect();
            List<opportunity> oppList = vFCLinkToSAPOMControllerTest.getListOfSAPOM();
            PageReference pagereferenceTest = vFCLinkToSAPOMControllerTest.doLink();
            Test.stopTest();
             System.assert(pagereferenceTest!=null);
        }
    }
    /*
     *@name testFirst_Scenario1()
     *@return void 
     *@description This method for first () In CLASS VFC_LinkToSAPOMController.cls
     */
     static testMethod void  testFirst_Scenario1(){ 
        User stdUser = UtilNovaUnitTest.getUser();
        VFC_LinkToSAPOMController vFCLinkToSAPOMControllerTest  =  new  VFC_LinkToSAPOMController();
        Test.startTest();
        Test.setCurrentPage(Page.VFP_LinkToSAPOM);
        ApexPages.currentPage().getParameters().put('searchId', 'testSearchId');
        System.runAs(stdUser) {
            vFCLinkToSAPOMControllerTest.first();
            Test.stopTest();
             System.assert(true);
        }
    }
    /*
     *@name testLast_Scenario1()
     *@return void 
     *@description This method for last () In CLASS VFC_LinkToSAPOMController.cls
     */
     static testMethod void  testLast_Scenario1(){ 
        User stdUser = UtilNovaUnitTest.getUser();
        VFC_LinkToSAPOMController vFCLinkToSAPOMControllerTest  =  new  VFC_LinkToSAPOMController();
        Test.startTest();
        Test.setCurrentPage(Page.VFP_LinkToSAPOM);
        ApexPages.currentPage().getParameters().put('searchId', 'testSearchId');
        System.runAs(stdUser) {
            vFCLinkToSAPOMControllerTest.last();
            Test.stopTest();
             System.assert(true);
        }
    }
    /*
     *@name testPrevious_Scenario1()
     *@return void 
     *@description This method for previous () In CLASS VFC_LinkToSAPOMController.cls
     */
     static testMethod void  testPrevious_Scenario1(){ 
        User stdUser = UtilNovaUnitTest.getUser();
        VFC_LinkToSAPOMController vFCLinkToSAPOMControllerTest  =  new  VFC_LinkToSAPOMController();
        Test.startTest();
        Test.setCurrentPage(Page.VFP_LinkToSAPOM);
        ApexPages.currentPage().getParameters().put('searchId', 'testSearchId');
        System.runAs(stdUser) {
            vFCLinkToSAPOMControllerTest.previous();
            Test.stopTest();
             System.assert(true);
        }
    }
    /*
     *@name testNext_Scenario1()
     *@return void 
     *@description This method for next () In CLASS VFC_LinkToSAPOMController.cls
     */
     static testMethod void  testNext_Scenario1(){ 
        User stdUser = UtilNovaUnitTest.getUser();
        VFC_LinkToSAPOMController vFCLinkToSAPOMControllerTest  =  new  VFC_LinkToSAPOMController();
        Test.startTest();
        Test.setCurrentPage(Page.VFP_LinkToSAPOM);
        ApexPages.currentPage().getParameters().put('searchId', 'testSearchId');
        System.runAs(stdUser) {
            vFCLinkToSAPOMControllerTest.next();
            Test.stopTest();
             System.assert(true);
        }
    }
    /*
     *@name testCancel_Scenario1()
     *@return void 
     *@description This method for cancel () In CLASS VFC_LinkToSAPOMController.cls
     */
     static testMethod void  testCancel_Scenario1(){ 
        User stdUser = UtilNovaUnitTest.getUser();
        VFC_LinkToSAPOMController vFCLinkToSAPOMControllerTest  =  new  VFC_LinkToSAPOMController();
        Test.startTest();
        Test.setCurrentPage(Page.VFP_LinkToSAPOM);
        ApexPages.currentPage().getParameters().put('searchId', 'testSearchId');
        System.runAs(stdUser) {
            vFCLinkToSAPOMControllerTest.cancel();
            Test.stopTest();
             System.assert(true);
        }
    }
    /*
     *@name testDoCancel_Scenario1()
     *@return void 
     *@description This method for doCancel () In CLASS VFC_LinkToSAPOMController.cls
     */
     static testMethod void  testDoCancel_Scenario1(){ 
         setUpData();
        User stdUser = UtilNovaUnitTest.getUser();
        VFC_LinkToSAPOMController vFCLinkToSAPOMControllerTest  =  new  VFC_LinkToSAPOMController();
        Test.startTest();
        Test.setCurrentPage(Page.VFP_LinkToSAPOM);
        ApexPages.currentPage().getParameters().put('oppId', opp.id);
        System.runAs(stdUser) {
            PageReference pagereferenceTest = vFCLinkToSAPOMControllerTest.doCancel();
            Test.stopTest();
             System.assert(pagereferenceTest==null);
        }
    }
    /*
     *@name testDohasNext_Scenario1()
     *@return void 
     *@description This method for hasNext () In CLASS VFC_LinkToSAPOMController.cls
     */
     static testMethod void  testDohasNext_Scenario1(){ 
        User stdUser = UtilNovaUnitTest.getUser();
        VFC_LinkToSAPOMController vFCLinkToSAPOMControllerTest  =  new  VFC_LinkToSAPOMController();
        Test.startTest();
        Test.setCurrentPage(Page.VFP_LinkToSAPOM);
        ApexPages.currentPage().getParameters().put('searchId', 'testSearchId');
        System.runAs(stdUser) {
            vFCLinkToSAPOMControllerTest.hasNext=true;
            vFCLinkToSAPOMControllerTest.hasPrevious = true;
            vFCLinkToSAPOMControllerTest.pageNumber = 2;
            Test.stopTest();
        }
    }
}