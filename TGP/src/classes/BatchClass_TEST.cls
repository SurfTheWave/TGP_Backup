@isTest
private class BatchClass_TEST {
    public static testmethod void testOppDevCenter(){
    test.startTest();
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
        
        SAP_OM_Staging__c staging1 = new SAP_OM_Staging__c();
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
        staging1.delivery_centers__c='India - Bangalore';
        insert staging1;
        
        List<Opportunity> oppList  = [Select id,delivery_centers__c from Opportunity where SAP_OM_Item_Id__c =: staging1.id];
        
            
       test.stopTest();
    }
    
    public static testmethod void testBatch1(){
        test.startTest();
        
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
        
        SAP_OM_Staging__c staging1 = new SAP_OM_Staging__c();
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
        staging1.delivery_centers__c='India - Bangalore';
        insert staging1;
        
        
         Operating_Groups_Master__c oppGrpMaster = new Operating_Groups_Master__c(Name = 'TestOpperatingGroup', Active__c = true);
            insert oppGrpMaster;  
            
         Opportunity opp=new Opportunity();
            opp.OperatingGroup__c=OppGrpMaster.id;
            opp.name= UtilConstants.TEST_OPP;
            opp.Geo_Area__c= UtilConstants.APAC;
            opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
            opp.StageName= UtilConstants.OA;
            opp.Risk_Level__c= UtilConstants.LOW;
            opp.CloseDate= date.newInstance(2001, 3, 21);
            opp.sap_om_item_id__C =staging1.id;
        
        insert opp;
        
        
        Batch_OpportunityDataCorrection CheckBatch11 = new Batch_OpportunityDataCorrection();
            Database.executeBatch(CheckBatch11);
            
            test.stopTest();
    
    }
    
     public static testmethod void testBatch2(){
     
         test.startTest();
         
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
         testFlag.RunOppTrigger__C=true;
        testFlag.name='Test Trigger Flag';
        insert testFlag;
         
         SAP_OM_Staging__c staging1 = new SAP_OM_Staging__c();
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
        staging1.delivery_centers__c='India - Bangalore';
        staging1.name='020202';
        insert staging1;
        
         Operating_Groups_Master__c oppGrpMaster = new Operating_Groups_Master__c(Name = 'TestOpperatingGroup', Active__c = true);
            insert oppGrpMaster;  
            
         Opportunity opp=new Opportunity();
            opp.OperatingGroup__c=OppGrpMaster.id;
            opp.name= UtilConstants.TEST_OPP;
            opp.Geo_Area__c= UtilConstants.APAC;
            opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
            opp.StageName= UtilConstants.OA;
            opp.Risk_Level__c= UtilConstants.LOW;
            opp.CloseDate= date.newInstance(2001, 3, 21);
            opp.sap_om_item_id__C =staging1.id;
        
        insert opp;
        
        SAP_OM_Staging__c staging2 = new SAP_OM_Staging__c();
        staging2.master_client_name__c ='Test Client';
        staging2.opportunity_name__c = 'Test Opp';
        staging2.SAP_OM_ID__c= '020203';
        staging2.opportunity_ID__c = '020203'; 
        staging2.geo_area__c='EMEA';
        staging2.geo_unit__c='India';
        staging2.OG__c = 'Product';
        staging2.reporting_status__c = 'Pipeline';
        staging2.Stage__c = '2A';
        staging2.Hierarchy_Level__c='Child';
        staging2.BPONR__c=200;
        staging2.delivery_centers__c='India - Bangalore';
        staging2.parent_id__c='020202';
        staging2.Parent_Opportunity__c=opp.id;
        staging2.name='020203';
        staging2.IO_Net_Revenue__c=10;
        staging2.SC_Net_Revenue__c=10;
        staging2.MC_Net_Revenue__c=10;
        staging2.SI_Net_Revenue__c=10;
        insert staging2;
        
        
        
         
        Batch_OpportunityDataParentChild CheckBatch12 = new Batch_OpportunityDataParentChild();
            Database.executeBatch(CheckBatch12);
         
         DataCorrectionScheduleClass sh1 = new DataCorrectionScheduleClass();
        String sch = '0 0 15 * * ?'; 
        system.schedule('DataCorrection_Test1', sch, sh1); 
            
          test.stopTest();
    
    }
    
    public static testmethod void test3(){
        test.startTest();
        FlagCheck__c testFlag=new FlagCheck__c();
        testFlag.MMS_Object_Key__c=true;
        testFlag.RunOppTrigger__C=true;
        testFlag.name='Test Trigger Flag';
        insert testFlag;
        
        
        
        
    test.stopTest();
        
    }
}