/*
* @Author : 
* @Description : Test class for  MonthlyGoLiveFTEUpdateTest
* @Version :               
*/
@isTest
private class MonthlyGoLiveFTEUpdateTest {
    private static Integer oppId = 0;
    private static Operating_Groups_Master__c testOpGrpMstr;
    private static Account acc;
    private static Geo_Region_Master__c testGeoRegion;
     public static void createTestData(){
    
        testOpGrpMstr = UTIL_DataCreationForTestClass.getOperatingGroupMasterRec('test group master',true);
        insert testOpGrpMstr;
        testGeoRegion = new Geo_Region_Master__c();
        testGeoRegion.name='APAC';
        testGeoRegion.active__c=true;
        insert testGeoRegion;
        acc = UTIL_DataCreationForTestClass.getAccountRec('test account');
       // insert acc;
        Profile p = UTIL_DataCreationForTestClass.getProfile('Standard Platform User'); 
        
        User testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,'test1233435@testorg.com','test1235335@test.net');
        
        insert testUser;
        
        System_User_Id__c testSystemUserRec = UTIL_DataCreationForTestClass.getSystemUserCSRec('System Id',testUser.Id);
        insert testSystemUserRec;
        
        List<Staging_CustomSetting__c> testStagingCSRecList = new List<Staging_CustomSetting__c>(); 
        testStagingCSRecList.add(UTIL_DataCreationForTestClass.getStagingCSRec('HR_TNR__c','Human Resources','BPO','Offering Master'));
        testStagingCSRecList.add(UTIL_DataCreationForTestClass.getStagingCSRec('client_account_lead__c','Client Account Lead','BPO','Additional Role Master'));
        testStagingCSRecList.add(UTIL_DataCreationForTestClass.getStagingCSRec('client_QA_director__c','Client QA Director','BPO','Additional Role Master'));
        testStagingCSRecList.add(UTIL_DataCreationForTestClass.getStagingCSRec('delivery_lead_BPO__c','Delivery Lead-BPO','BPO','Additional Role Master'));
        testStagingCSRecList.add(UTIL_DataCreationForTestClass.getStagingCSRec('global_client_account_lead__c','Global Client Account Lead','BPO','Additional Role Master'));
        testStagingCSRecList.add(UTIL_DataCreationForTestClass.getStagingCSRec('managing_director_MC__c','Managing Director MC','BPO','Additional Role Master'));
        testStagingCSRecList.add(UTIL_DataCreationForTestClass.getStagingCSRec('mobilization_lead__c','Mobilization Lead','BPO','Additional Role Master'));
        testStagingCSRecList.add(UTIL_DataCreationForTestClass.getStagingCSRec('opportunity_contact__c','Opportunity Contact','BPO','Additional Role Master'));
        testStagingCSRecList.add(UTIL_DataCreationForTestClass.getStagingCSRec('opportunity_QA_director__c','Opportunity QA Director','BPO','Additional Role Master'));
        testStagingCSRecList.add(UTIL_DataCreationForTestClass.getStagingCSRec('sales_capture_opp_director__c','Sales Capture - Opp Director','BPO','Additional Role Master'));
        testStagingCSRecList.add(UTIL_DataCreationForTestClass.getStagingCSRec('sales_capture_OSL__c','Sales Capture - OSL','BPO','Additional Role Master'));
        testStagingCSRecList.add(UTIL_DataCreationForTestClass.getStagingCSRec('sales_capture_other__c','Sales Capture - Other','BPO','Additional Role Master'));
        testStagingCSRecList.add(UTIL_DataCreationForTestClass.getStagingCSRec('sales_origination__c','Sales Origination','BPO','Additional Role Master'));
        testStagingCSRecList.add(UTIL_DataCreationForTestClass.getStagingCSRec('solution_arch_BPO__c','Solution Arch - BPO','BPO','Additional Role Master'));
        testStagingCSRecList.add(UTIL_DataCreationForTestClass.getStagingCSRec('technology_account_lead__c','Technology Account Lead','BPO','Additional Role Master'));
        insert testStagingCSRecList;
        List<Opportunity_Additional_Role_Master__c> roleMasterList = new List<Opportunity_Additional_Role_Master__c>();
        Opportunity_Additional_Role_Master__c roleMaster;
        for( Staging_CustomSetting__c cs: testStagingCSRecList){
            roleMaster = new Opportunity_Additional_Role_Master__c();
            roleMaster.active__c = true;
            roleMaster.BPO_Role__c = true;
            if(!cs.Name.contains('HR_TNR__c')){
                roleMaster.Name = cs.Master_Record_Name__c;
            }
            
                      roleMasterList.add(roleMaster);
        }
        if(roleMasterList.size()>0){
            roleMasterList.add(new Opportunity_Additional_Role_Master__c(name='BPO Sales Lead',active__c=true));
            insert roleMasterList;
        }
        List<Offering_Master__c> offList = new List<Offering_Master__c>();
        Offering_Master__c off1 = new Offering_Master__c(service_group__c = 'BPO',active__c = true,name='Human Resources',offering_description__c='test desc',flywheel_non_flywheel__c='test F');
        Offering_Master__c off2 = new Offering_Master__c(service_group__c = 'BPO',active__c = true,name='Sourcing and Procurement',offering_description__c='test desc',flywheel_non_flywheel__c='test NF');
        Offering_Master__c off3 = new Offering_Master__c(service_group__c = 'BPO',active__c = true,name='Cross Offering',offering_description__c='test desc',flywheel_non_flywheel__c='test Flywheel');
        offList.add(off1);
        offList.add(off2);
        offList.add(off3); 
        insert offList;
        
        List<Services_Master__c> servMasterList = new List<Services_Master__c>();
        Services_Master__c serv1 = new Services_Master__c(Name='test 1',active__c=true,Is_Offering_Specific_Service__c=false,offering__c=offList[2].Id,Service_Group__c='BPO',Solution_Component__c='BST');
        Services_Master__c serv2 = new Services_Master__c(Name='test 2',active__c=true,Is_Offering_Specific_Service__c=false,offering__c=offList[2].Id,Service_Group__c='BPO',Solution_Component__c='PMO');
        Services_Master__c serv3 = new Services_Master__c(Name='test 3',active__c=true,Is_Offering_Specific_Service__c=false,offering__c=offList[2].Id,Service_Group__c='BPO',Solution_Component__c='Technology');
        servMasterList.add(serv1);
        servMasterList.add(serv2);
        servMasterList.add(serv3);
        insert servMasterList;
        
        Offering_Name__c offeringCS = new Offering_Name__c(name='Sourcing and Procurement',name__c=offList[1].Id);
        insert offeringCS;
    }
    
    /*
    * @Author : 
    * @Description : Test class for  MonthlyGoLiveFTEUpdateTest
    * @Version :               
    */
    private static testmethod void test() {
        createTestData();
        SAP_OM_Staging__c staging = UTIL_DataCreationForTestClass.getSAPOMStagingRec(123121,'test group master','test account','test opportunity','test stage',0.5);
        staging.HR_TNR__c=123.23;
        staging.IO_Net_Revenue__c = 129.87;
        staging.BPONR__c = 100;
        staging.IC_Net_Revenue__c = 150;
        staging.geo_area__c='APAC';
        staging.geo_unit__c='India';
        staging.Hierarchy_Level__c = 'standalone';
        insert staging;
        List<Opportunity> oppList = [Select Id,Name from Opportunity where SAP_OM_ID__c=:123121+'' limit 1];
        system.assertequals(1,oppList.size());   

        Monthly_Go_Live_FTE__c fte= new Monthly_Go_Live_FTE__c();
        fte.Opportunity__c = oppList[0].Id;
        fte.MMS_Id__c='123121';
        insert fte;

        Test.startTest();
        /*MonthlyGoLiveFTEUpdate goLive = new MonthlyGoLiveFTEUpdate();       
        Database.executeBatch(goLive);*/
        scheduledMonthlyGoLiveFTEUpdate sch1 = new scheduledMonthlyGoLiveFTEUpdate ();
        String sch = '0 0 23 * * ?'; system.schedule('Test monthly ftes', sch, sch1); 
        Test.stopTest();
    }
}