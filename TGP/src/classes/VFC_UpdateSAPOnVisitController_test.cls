/**
   @Author         : Reena Thakre
   @name           : VFP_UpdateSAPOnVisitController_test
   @CreateDate     : 24 November 2015
   @Description    : Test class  VFP_UpdateSAPOnVisitController
   @Version        : 1.0
 **/
 
@isTest
private class VFC_UpdateSAPOnVisitController_test{ 
  
    //public static STRING searchTextId;
    //public static STRING searchTextId1;
    public static List <Opportunity> opprecList;
    public static STRING requestid;
    public static  STRING selectedId;
    public static STRING visitID;
    public static Opportunity opp;
    public static Opportunity oppWithSAP;
    public static Account acc;
    public static Client_visit_request__c req1;
    public static void setupdata(){    
    acc=new Account(name='AccTest');
    insert acc;
    Email_Template__c emailTemplateRec = new Email_Template__c(name =UtilConstantsforSWB.CLIENT_VISIT_TEMPLATE,ID__c='00XE0000001CHQj');     
    insert emailTemplateRec;
    Email_Template__c emailTemplateRec2 = new Email_Template__c(name =UtilConstantsforSWB.CLIENT_VISIT_FEEDBACK_TEMPLATE,ID__c='00XE0000001CHQk');     
    insert emailTemplateRec2;
    
    req1=new Client_visit_request__c();
    req1.Parent_Company__c=acc.id;
    req1.Support_Group__c='Pittsburgh';
    req1.Primary_Contact__c='Reena Thakre';
    req1.Visit_Category__c='Sales - Charge-back DC';
    req1.Feedback_Receipients__c='Reena Thakre';
    req1.WBS_Element_for_Showcase__c='123456';
    req1.Centre_to_be_visited__c='Bangalore';
    req1.Visit_Date_From__c=system.today();
    req1.Visit_Date_To__c=system.today();
    req1.Request_status__C='Completed' ;
    insert req1;
    
    
    
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
    
    
    }
    
    
    /*
     *@name testGetListOfSAPOM_Scenario1()
     *@return void 
     *@description This method for getListOfopp ()
     */
     static testMethod void  testGetListOfSAPOM_Scenario1(){ 
     
         setUpData();
         
        User stdUser = UtilNovaUnitTest.getUser();
        
        VFC_UpdateSAPOnVisitController vFP_UpdateSAPOnVisitControllerTest  =  new  VFC_UpdateSAPOnVisitController();
        Test.startTest();
        vFP_UpdateSAPOnVisitControllerTest.searchTextId=oppWithSAP.name;
       vFP_UpdateSAPOnVisitControllerTest.searchTextId1=oppWithSAP.name;
        Test.setCurrentPage(Page.VFP_UpdateSAPOnVisit);
        ApexPages.currentPage().getParameters().put('visitID', req1.id);
        System.runAs(stdUser) {
            vFP_UpdateSAPOnVisitControllerTest.getSapOmRecord();
            Test.stopTest();
             
        }
    }
    
    
     
    
    static testMethod void  testGetListOfSAPOM_Scenario2(){      
        setUpData();
        
        
        User stdUser = UtilNovaUnitTest.getUser();        
        
        Test.startTest();
        Test.setCurrentPage(Page.VFP_UpdateSAPOnVisit);
        ApexPages.currentPage().getParameters().put('visitID', req1.id);
        VFC_UpdateSAPOnVisitController vFP_UpdateSAPOnVisitControllerTest  =  new  VFC_UpdateSAPOnVisitController();
       vFP_UpdateSAPOnVisitControllerTest.searchTextId=oppWithSAP.name;
       vFP_UpdateSAPOnVisitControllerTest.searchTextId1=oppWithSAP.name;
        Apexpages.currentPage().getParameters().put('selectedId',oppWithSAP.name);
        
        System.runAs(stdUser) {
        vFP_UpdateSAPOnVisitControllerTest.callSelect();
        Test.stopTest();
             
        }
    }

}