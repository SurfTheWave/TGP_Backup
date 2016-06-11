/**
 * Test class for VFC_Cost_Summary_TEST 
 */
@isTest
private class VFC_Budget_Tracker_TEST {

   private static User testUser;
   private static Client_Specific_Process_Mapping__c clientSpecificProcessMapping;
    private static Offerings_Master__c offering;
    private static Wave_Plan_Version__c wavePlanVersion;
    private static Deal_TGP__c deal;
    private static Wave_Planning__c waveplan;
    private static Wave_Planning__c waveplan1;
    private static Wave_Process__c WaveProcess;
    private static Deal_Location__c dealLoc;
    private static Deal_Home_Location__c dealHome;
    private static Delievery_Location_Master__c deliveryLocMa;
    private static Client_Geo_Area_Master__c clientGeo;

    private static Commercial_Planning__c comPlan;
    private static Opportunity_TGP__c oppTGP;
    private static KT_Planning__c kTPlan;
    private static String User_Name1='vc71@testorg.com';
   //static string SWB-Benchmark-Offering;

/*
  @Author: 
  @Name: setupData_Construtor
  @Created Date: 01 January 2015
  @Description:This is a test mehtod for setupData constructor.
  @version: 1.0
*/
    public static void setupData_Construtor() {
    
    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name1);
    Database.insert (testUser);
    
        // To create a Client Geo
        
        clientGeo = new Client_Geo_Area_Master__c();
        clientGeo.Client_Geo_Area_Description__c='TestData';
        insert clientGeo;
        
        // To create a Delivery Location Master
        deliveryLocMa =new Delievery_Location_Master__c();
        deliveryLocMa.Delivery_Location_Description__c='testdata';
        deliveryLocMa.Name='TestData';
        deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
        insert deliveryLocMa;
        
        // To create a Deal
        deal =new Deal_TGP__c();
        deal.Name='Test Data';
        insert deal;
        
        // To create a offering
        offering =new Offerings_Master__c();
        offering.Name='Test Data';
        insert offering;
        
        //To create a Wave Plan Version
        wavePlanVersion =new Wave_Plan_Version__c();
        wavePlanVersion.Display_tracking_message__c='Tracking is On';
        wavePlanVersion.Deal__c=deal.id;
        insert wavePlanVersion;
        
        // To create a Deal Home Location
        dealHome =new Deal_Home_Location__c(); 
        dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
        dealHome.Deal__c= deal.id;
        insert dealHome;
        
        
        // To create a Deal Location
        dealLoc= new Deal_Location__c();
        dealLoc.Location__c='test Data';
        dealLoc.Deal_Home_Location__c=dealHome.id;
        dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
        insert dealLoc;
        
        // To Create Client Specific Process Mapping
        
        clientSpecificProcessMapping = new Client_Specific_Process_Mapping__c();
        clientSpecificProcessMapping.Name='TestData';
        clientSpecificProcessMapping.Deal__c=deal.id;
        clientSpecificProcessMapping.Offering__c=offering.id;
        insert clientSpecificProcessMapping;
        
        //To create a Wave Plan
        
        waveplan =new Wave_Planning__c();
        waveplan.Wave_Comment__c='test data';
        waveplan.Wave_Label__c='TestData';
        waveplan.GO_Live_Date_del__c=date.today()+7;
        waveplan.Deal_Location__c=dealLoc.id;
        waveplan.Number_of_Projected_FTEs__c=1;
        insert waveplan; 
      
        
        // To create a Wave Process
        
        WaveProcess =new Wave_Process__c();
        WaveProcess.Wave_Planning__c=waveplan.id;
        WaveProcess.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
        insert WaveProcess;
        
        
        // To Create Commercial Planning
        comPlan = new Commercial_Planning__c();
        comPlan.Name='TestData';
        comPlan.Activity__c='TestData';
        comPlan.Delivery_Location__c=deliveryLocMa.id;
        comPlan.Planned_Start_Date__c=date.today();
        comPlan.Planned_End_Date__c=date.today()+7;
        insert comPlan;
              
        }
            
            //Pasting before this point
/*
  @Author: 
  @Name: construtorUnitTest
  @Created Date: 01 January 2015
  @Description: This is a test method for constructor unit testing.
  @version: 1.0
*/
static testMethod void construtorUnitTest() {
        setupData_Construtor();
        Test.startTest();
        PageReference pageRef= Page.VFP_Budget_Tracker;
      pageRef.getParameters().put('id', String.valueOf(wavePlanVersion.Id));
      Test.setCurrentPageReference(pageRef);
         ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        VFC_Budget_Tracker obj = new VFC_Budget_Tracker(controller);
        obj.allLines_Cost_Summary_MWB = 'Cost Summary - MWB'+'\n\n'+'Cost Head»ODE Cost ($000)»Actuals Cost ($000)»Forecasts Cost ($000)»EAC Cost ($000)»ODE Variance Cost ($000)'+'\n'+'Total Mob Cost»111.1»123.2»120.3»500.6»112.2';
        
        
     obj.dropFileName='New File';
     obj.fileBody=blob.valueOf('Test'); 
     obj.UploadFile();
     obj.generateReport();
        
             
        Test.stopTest();
    
        
    }


}