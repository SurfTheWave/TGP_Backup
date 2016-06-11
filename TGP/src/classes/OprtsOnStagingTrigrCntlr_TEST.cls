/*
* @Author : Jyotsna 
* @Description : Test class for  Staging trigger helper class
* @Version : 2.0                
*/
@isTest
private class OprtsOnStagingTrigrCntlr_TEST {

//Class constant varibale definition
    
    
    private static Integer oppId = 0;
    private static Operating_Groups_Master__c testOpGrpMstr;
    private static Account acc;
    private static Geo_Region_Master__c testGeoRegion;
    Public Static SAP_OM_Staging__c staging1;
    Public Static SAP_OM_Staging__c staging2;
    Public Static SAP_OM_Staging__c staging3;
     Public Static SAP_OM_Staging__c staging4;
    Public Static Opportunity op;
    /************************************************************************************************
    * Method Name: createTestData
    * Description: creates test data to test staging trigger helper class
    ************************************************************************************************/
    
    
    
     public static void createTestData(){
  
        testOpGrpMstr = UTIL_DataCreationForTestClass.getOperatingGroupMasterRec('test group master',true);
        insert testOpGrpMstr;
        testGeoRegion = new Geo_Region_Master__c();
        testGeoRegion.name=UTIL_Constants.AsiaPacific;
        testGeoRegion.active__c=true;
        insert testGeoRegion;
        acc = UTIL_DataCreationForTestClass.getAccountRec('test account');
        insert acc;
        
        Profile p1 = UTIL_DataCreationForTestClass.getProfile('Standard Platform User'); 
   
        User testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p1,'testEmail@orgin.com');
        
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
        
        
        FlagCheck__c testFlag=new FlagCheck__c();
        testFlag.MMS_Object_Key__c=true;
        testFlag.name='Test Trigger Flag';
        insert testFlag;
       
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
        staging1 = new SAP_OM_Staging__c();
        staging1.master_client_name__c ='Test Client';
        staging1.opportunity_name__c = 'Test Opp';
        staging1.SAP_OM_ID__c= '020202';
        staging1.opportunity_ID__c = '020202'; 
        staging1.geo_area__c='EMEA';
        staging1.geo_unit__c='India';
        staging1.OG__c = 'Product';
        staging1.reporting_status__c = 'Pipeline';
        staging1.Stage__c = '2A';
        staging1.Hierarchy_Level__c='Parent';
        staging1.BPONR__c=200;
        staging1.TNR__c=250;
         staging1.TCNR__c=250;
        staging1.Cons_Net_Revenue__c=200;
        staging1.OS_net_revenue__c=20.32;
        staging1.MC_Net_Revenue__c=20.32;
        staging1.AO_Net_Revenue__c=20.32;
        staging1.SC_Net_Revenue__c=20.32;
        staging1.SI_Net_Revenue__c=20.32;
        staging1.IO_Net_Revenue__c=20.32;
        staging1.IC_Net_Revenue__c=20.32;
        staging1.Parent_Id__c = 'test';
        insert staging1;
        
         staging2 = new SAP_OM_Staging__c();
        staging2.master_client_name__c ='Test Client';
        staging2.opportunity_name__c = 'Test Opp1';
        staging2.SAP_OM_ID__c='020203';
        staging2.opportunity_ID__c = '020203'; 
        staging2.geo_area__c='EMEA';
        staging2.geo_unit__c='India';
        staging2.OG__c = 'Product';
        staging2.reporting_status__c = 'Pipeline';
        staging2.Stage__c = '2A';
        staging2.Hierarchy_Level__c='Parent';
        staging2.BPONR__c=250;
        staging2.TNR__c=200;
        staging1.TCNR__c=210;

        staging2.Cons_Net_Revenue__c=200;
        staging2.OS_net_revenue__c=20.32;
        staging2.MC_Net_Revenue__c=20.32;
        staging2.AO_Net_Revenue__c=20.32;
        staging2.SC_Net_Revenue__c=20.32;
        staging2.SI_Net_Revenue__c=20.32;
        staging2.IO_Net_Revenue__c=20.32;
        staging2.IC_Net_Revenue__c=20.32;
        insert staging2 ;
         
         op = new Opportunity();   
         op.Name = 'test';
         op.SAP_OM_Item_Id__c =  staging1.Id;
         op.Pipeline_Entry_Date__c = system.today();
         op.StageName='2A';
         op.CloseDate = system.today();
         insert op;
        
   }     
 public static testMethod void createOpportunitonInsertTestPositive(){  
        testOpGrpMstr = UTIL_DataCreationForTestClass.getOperatingGroupMasterRec('test group master',true);
        insert testOpGrpMstr;
        testGeoRegion = new Geo_Region_Master__c();
        testGeoRegion.name=UTIL_Constants.AsiaPacific;
        testGeoRegion.active__c=true;
        insert testGeoRegion;
        acc = UTIL_DataCreationForTestClass.getAccountRec('test account');
        insert acc;
        
        Profile p1 = UTIL_DataCreationForTestClass.getProfile('Standard Platform User'); 
   
        User testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p1,'testEmail@orgin.com');
        
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
        
        
        FlagCheck__c testFlag=new FlagCheck__c();
        testFlag.MMS_Object_Key__c=true;
        testFlag.name='Test Trigger Flag';
        insert testFlag;
       
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

        staging1 = new SAP_OM_Staging__c();
        staging1.master_client_name__c ='Test Client';
        staging1.opportunity_name__c = 'Test Opp';
        staging1.SAP_OM_ID__c= '020202';
        staging1.opportunity_ID__c = '020202'; 
        staging1.geo_area__c='EMEA';
        staging1.geo_unit__c='India';
        staging1.OG__c = 'Product';
        staging1.reporting_status__c = 'Pipeline';
        staging1.Stage__c = '2A';
        staging1.Hierarchy_Level__c='Parent';
        staging1.BPONR__c=200;
        staging1.TNR__c=250;
         staging1.TCNR__c=250;
        staging1.Cons_Net_Revenue__c=200;
        staging1.OS_net_revenue__c=20.32;
        staging1.MC_Net_Revenue__c=20.32;
        staging1.AO_Net_Revenue__c=20.32;
        staging1.SC_Net_Revenue__c=20.32;
        staging1.SI_Net_Revenue__c=20.32;
        staging1.IO_Net_Revenue__c=20.32;
        staging1.IC_Net_Revenue__c=20.32;
        insert staging1;
        
       
        
         test.startTest();
         List<SAP_OM_Staging__c> saprecord1=new List<SAP_OM_Staging__c>();
         Map<Id,SAP_OM_Staging__c> sap=new Map<Id,SAP_OM_Staging__c>();     
         saprecord1.add(staging1);
         staging1.BPONR__c=250;
         staging1.IC_Net_Revenue__c = 19.23;
         staging1.IO_Net_Revenue__c=19.32;
         staging1.TNR__c=199;
         staging1.Cons_Net_Revenue__c=199;
         staging1.OS_net_revenue__c=19.32;      
         staging1.MC_Net_Revenue__c=19.32;
         staging1.SC_Net_Revenue__c=19.32;
         staging1.SI_Net_Revenue__c=19.32;
         staging1.IO_Net_Revenue__c=19.32;
         staging1.IC_Net_Revenue__c=19.32;
         update staging1;
         sap.put(staging1.id,staging1);
         operationsOnStagingTriggerController.createOpportunity(saprecord1,sap,true,true); 
         test.stopTest();
         List<Opportunity> oppList = [Select Id,Name from Opportunity where SAP_OM_Item_Id__c =: staging1.id limit 1000];
         system.debug('oppList-->'+oppList );
         system.assertequals(1,oppList.size());
     } 
    
  // Negative Test

      public static testMethod void createOpportunitonInsertTestNegative(){  
        testOpGrpMstr = UTIL_DataCreationForTestClass.getOperatingGroupMasterRec('test group master',true);
        insert testOpGrpMstr;
        testGeoRegion = new Geo_Region_Master__c();
        testGeoRegion.name=UTIL_Constants.AsiaPacific;
        testGeoRegion.active__c=true;
        insert testGeoRegion;
        acc = UTIL_DataCreationForTestClass.getAccountRec('test account');
        insert acc;
        
        Profile p1 = UTIL_DataCreationForTestClass.getProfile('Standard Platform User'); 
   
        User testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p1,'testEmail@orgin.com');
        
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
        
        
        FlagCheck__c testFlag=new FlagCheck__c();
        testFlag.MMS_Object_Key__c=true;
        testFlag.name='Test Trigger Flag';
        insert testFlag;
       
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

        staging1 = new SAP_OM_Staging__c();
        staging1.master_client_name__c ='Test Client';
        staging1.opportunity_name__c = 'Test Opp';
        staging1.SAP_OM_ID__c= '020202';
        staging1.opportunity_ID__c = '020202'; 
        staging1.geo_area__c='EMEA';
        staging1.geo_unit__c='India';
        staging1.OG__c = 'Product';
        staging1.reporting_status__c = 'Pipeline';
        staging1.Stage__c = '2A';
        staging1.Hierarchy_Level__c='Standalone';
        staging1.BPONR__c=200;
        staging1.TNR__c=250;
         staging1.TCNR__c=250;
        staging1.Cons_Net_Revenue__c=200;
        staging1.OS_net_revenue__c=0.32;
        staging1.MC_Net_Revenue__c=0.32;
        staging1.AO_Net_Revenue__c=0.32;
        staging1.SC_Net_Revenue__c=0.32;
        staging1.SI_Net_Revenue__c=0.32;
        staging1.IO_Net_Revenue__c=0.32;
        staging1.IC_Net_Revenue__c=0.32;
        insert staging1;
        
          test.startTest();
         List<SAP_OM_Staging__c> saprecord1=new List<SAP_OM_Staging__c>();
         Map<Id,SAP_OM_Staging__c> sap=new Map<Id,SAP_OM_Staging__c>();     
         saprecord1.add(staging1);
         staging1.BPONR__c=250;
         staging1.IC_Net_Revenue__c = 19.23;
         staging1.IO_Net_Revenue__c=19.32;
         staging1.TNR__c=199;
         staging1.Cons_Net_Revenue__c=199;
         staging1.OS_net_revenue__c=19.32;      
         staging1.MC_Net_Revenue__c=19.32;
         staging1.SC_Net_Revenue__c=19.32;
         staging1.SI_Net_Revenue__c=19.32;
         staging1.IO_Net_Revenue__c=19.32;
         staging1.IC_Net_Revenue__c=19.32;
         update staging1;
         sap.put(staging1.id,staging1);

          operationsOnStagingTriggerController.createOpportunity(saprecord1,sap,true,true);  
         staging1.Hierarchy_Level__c='Standalone';
         update staging1;
         sap=new Map<Id,SAP_OM_Staging__c>(); 
         sap.put(staging1.id,staging1);
         operationsOnStagingTriggerController.createOpportunity(saprecord1,sap,true,true);
         
         staging1.IC_Net_Revenue__c = 300.0; 
         staging1.IO_Net_Revenue__c=300.0; 
         staging1.TNR__c= 300.0;
         staging1.Cons_Net_Revenue__c=300.0; 
         staging1.OS_net_revenue__c=300.0;     
         staging1.MC_Net_Revenue__c=300.0;
         staging1.SC_Net_Revenue__c=300.0;
         staging1.SI_Net_Revenue__c=300.0;
         staging1.IO_Net_Revenue__c=300.0; 
         staging1.IC_Net_Revenue__c=300.0;
         
        // staging1.Hierarchy_Level__c='Standalone';
         update staging1;
         saprecord1=new List<SAP_OM_Staging__c>();
         saprecord1.add(staging1);
         
         operationsOnStagingTriggerController.createOpportunity(saprecord1,sap,true,true);

         test.stopTest();
         List<Opportunity> oppList = [Select Id,Name from Opportunity where SAP_OM_Item_Id__c =: staging1.id limit 1000];
         system.debug('oppList-->'+oppList );
         system.assertequals(1,oppList.size());
     }
     
     public static testMethod void revertValuesofExParenttest1(){
         List<SAP_OM_Staging__c> saprecord1=new List<SAP_OM_Staging__c>();
         List<SAP_OM_Staging__c> saprecord2=new List<SAP_OM_Staging__c>();
         Map<Id,SAP_OM_Staging__c> sap=new Map<Id,SAP_OM_Staging__c>();
         createTestData();
         sap.put(staging1.id,staging1);
         saprecord2.add(staging1);
          //staging1.Hierarchy_Level__c='Standalone';
        // staging1.Parent_ID__c=null;
         test.startTest();
        // update staging1;
         saprecord1.add(staging1);
        operationsOnStagingTriggerController.createOpportunity(saprecord1,sap,true,false);
         operationsOnStagingTriggerController.revertValuesofExParent(saprecord2);
         test.stopTest();
      
     }
     
      public static testMethod void ParentOpprtFieldsUpdateTest(){
        test.startTest();
         createTestData();   
         List<SAP_OM_Staging__c> saprecord1=new List<SAP_OM_Staging__c>();
         Map<Id,SAP_OM_Staging__c> sap=new Map<Id,SAP_OM_Staging__c>();
         sap.put(staging1.id,staging1);
         sap.put(staging2.id,staging2);
         saprecord1.add(staging2);
         operationsOnStagingTriggerController.createOpportunity(saprecord1,sap,true,false);
         // operationsOnStagingTriggerController.oppList = new List<Opportunity>();
        //  operationsOnStagingTriggerController.oppList.add(op);
         operationsOnStagingTriggerController.updateParentOpportunityFields(saprecord1,sap);
         test.stopTest();
        
    }
    
     public static testMethod void createOpporDeliveryCentres(){
         createTestData();
         List<SAP_OM_Staging__c> saprecord1=new List<SAP_OM_Staging__c>();
         saprecord1.add(staging1);
         test.startTest();
         operationsOnStagingTriggerController.insertOppDeliveryCentres(saprecord1);
         test.stopTest();        
    } 
    
}