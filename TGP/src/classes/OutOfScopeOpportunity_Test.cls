/*
  @Author: 
  @Name: OutOfScopeOpportunity_Test
  @Created Date: 
  @Description:
  @version: 1.0
*/
@isTest
private class OutOfScopeOpportunity_Test {
  private static Integer oppId = 0;
    private static Operating_Groups_Master__c testOpGrpMstr;
    private static Account acc;
    private static Geo_Region_Master__c testGeoRegion;
    Private Static SAP_OM_Staging__c staging1;
    Private Static SAP_OM_Staging__c staging2;
    Private Static SAP_OM_Staging__c staging3;
     Private Static SAP_OM_Staging__c staging4;
     Private static User_Master__c userMaster;
    Private Static Opportunity op;
    /************************************************************************************************
    * Method Name: createTestData
    * Description: creates test data to test staging trigger helper class
    ************************************************************************************************/
    
    /*
  @Author: 
  @Name: createTestData
  @Created Date: 
  @Description:
  @version: 1.0
*/
    
     public static void createTestData(){
  
        testOpGrpMstr = UTIL_DataCreationForTestClass.getOperatingGroupMasterRec('test group master',true);
        database.insert(testOpGrpMstr);
        testGeoRegion = new Geo_Region_Master__c();
        testGeoRegion.name=UTIL_Constants.AsiaPacific;
        testGeoRegion.active__c=true;
        database.insert(testGeoRegion);
        acc = UTIL_DataCreationForTestClass.getAccountRec('test account');
        database.insert(acc);
        
        Profile p1 = UTIL_DataCreationForTestClass.getProfile(UtilConstants.SYSTEM_ADMIN); 
   
        User testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p1,'testEmail@orgin.com');
        
        database.insert(testUser);
        userMaster=new User_Master__c(name='testuser1', User__c=testUser.id);
        database.insert(userMaster);
        System_User_Id__c testSystemUserRec = UTIL_DataCreationForTestClass.getSystemUserCSRec('System Id',testUser.Id);
        database.insert(testSystemUserRec);
        
        
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
        database.insert(testStagingCSRecList);
        
        
        FlagCheck__c testFlag=new FlagCheck__c();
        testFlag.MMS_Object_Key__c=true;
        testFlag.name='Test Trigger Flag';
        database.insert(testFlag);
       
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
           database.insert(roleMasterList);
        }
        
        
        
        List<Offering_Master__c> offList = new List<Offering_Master__c>();
        Offering_Master__c off1 = new Offering_Master__c(service_group__c = 'BPO',active__c = true,name='Human Resources',offering_description__c='test desc',flywheel_non_flywheel__c='test F');
        Offering_Master__c off2 = new Offering_Master__c(service_group__c = 'BPO',active__c = true,name='Sourcing and Procurement',offering_description__c='test desc',flywheel_non_flywheel__c='test NF');
        Offering_Master__c off3 = new Offering_Master__c(service_group__c = 'BPO',active__c = true,name='Cross Offering',offering_description__c='test desc',flywheel_non_flywheel__c='test Flywheel');
        offList.add(off1);
        offList.add(off2);
        offList.add(off3); 
        database.insert(offList);
        
        List<Services_Master__c> servMasterList = new List<Services_Master__c>();
        Services_Master__c serv1 = new Services_Master__c(Name='test 1',active__c=true,Is_Offering_Specific_Service__c=false,offering__c=offList[2].Id,Service_Group__c='BPO',Solution_Component__c='BSS');
        Services_Master__c serv2 = new Services_Master__c(Name='test 2',active__c=true,Is_Offering_Specific_Service__c=false,offering__c=offList[2].Id,Service_Group__c='BPO',Solution_Component__c='PMO');
        Services_Master__c serv3 = new Services_Master__c(Name='Technology Tools',active__c=true,Is_Offering_Specific_Service__c=false,offering__c=offList[2].Id,Service_Group__c='BPO',Solution_Component__c='Technology');
        servMasterList.add(serv1);
        servMasterList.add(serv2);
        servMasterList.add(serv3);
        database.insert(servMasterList);
        
        List<Tech_Tool_Master__c> techMasterList = new List<Tech_Tool_Master__c>();
        Tech_Tool_Master__c tech1 = new Tech_Tool_Master__c(Name='Bold Chat',Active__c=true,Mandatory__c=true,Services__c=serv3.id);
        Tech_Tool_Master__c tech2 = new Tech_Tool_Master__c(Name='Optical Character Recognition',Active__c=true,Mandatory__c=true,Services__c=serv3.id);
        Tech_Tool_Master__c tech3 = new Tech_Tool_Master__c(Name='ACF',Active__c=true,Mandatory__c=true,Services__c=serv3.id);
        techMasterList.add(tech1);
        techMasterList.add(tech2);
        techMasterList.add(tech3);
        database.insert(techMasterList);
        Offering_Name__c offeringCS = new Offering_Name__c(name='Sourcing and Procurement',name__c=offList[1].Id);
        database.insert(offeringCS);
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
       // staging1.Parent_Id__c = 'test';
        database.insert (staging1);
   
   }
   /*
  @Author: 
  @Name: testTechTool
  @Created Date: 
  @Description:
  @version: 1.0
*/
    private static testMethod void testTechTool(){
        createTestData();
        List<Tech_tools__C> techTool = new List<Tech_tools__C>(); 
        List<Tech_tools__C> techTool1 = new List<Tech_tools__C>();       
            Opportunity opp= [Select id,Service_Grp__c,Opportunity_Solution_Lead__c,Opportunity_Solution_Lead__r.user__c from opportunity where SAP_OM_ID__c=:staging1.SAP_OM_ID__c limit 1];           
            //opp.Opportunity_Solution_Lead__c= testUser1.id;
            
            database.update(opp);
            techTool = [SELECT Id, Name,Service__c,Tech_Tool__c,Tech_Tool__r.name,Scope_Status__c,Out_Of_Scope_Reason__c FROM Tech_tools__C WHERE Service__r.Solutionscope__r.Opportunity__r.id =:opp.id ];   
                                         
            for(Tech_tools__C tt:techTool ){
                if(tt.Tech_Tool__r.name=='Bold Chat'){
                     tt.Scope_Status__c='Out of scope' ;  
                     tt.Out_Of_Scope_Reason__c ='Deal Size';
                     techTool1.add(tt);               
                }
            }
            database.update(techTool1);
            test.starttest();
             PageReference tpageRef = Page.OutOfScope_Opportunity_Tab;
            Test.setCurrentPage(tpageRef);           
            OutOfScopeOpportunity oppTeam1=new OutOfScopeOpportunity();                  
            test.stopTest();
  }          
}