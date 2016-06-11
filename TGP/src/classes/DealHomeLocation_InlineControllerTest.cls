/*
    Author : Malkeet Singh
    Story  :   
    Description : Test Class for DealHomeLocation_InlineController. 

    Updated by        Story no.                Update Date        Update details
    ------------    -----------------        --------------    -------------------------------------------------------------


    */
    @isTest(SeeAlldata= true)
    private class DealHomeLocation_InlineControllerTest{

    static Client_Specific_Process_Mapping__c clientSpecificProcessMapping;
    static Offerings_Master__c offering;
    static User testUser;
    static User testUser1;
    static Wave_Plan_Version__c wavePlanVersion;
    static Deal_TGP__c deal;
    static Wave_Planning__c waveplan;
    static Wave_Process__c WaveProcess;
    static Deal_Location__c dealLoc;
    static Deal_Home_Location__c dealHome;
    static Delievery_Location_Master__c deliveryLocMa;
    static Client_Geo_Area_Master__c clientGeo;
    static Deal_Location_Facility__c dealLocFac;
    static Commercial_Planning__c comPlan;
    static Facility_Master__c FacMaster;
    private static string USER_NAME = 'vc123@testorg.com';


    public static void setupData(){
        
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_NAME);
        insert testUser1;
    
        // To create a Client Geo
    
        clientGeo = UTIL_DataCreationForTestClass.getClientGEOAreaMaster('testClientGEO');
        clientGeo.Client_Geo_Area_Description__c='TestData';
        insert clientGeo;
    
        // To create a Delivery Location Master
        deliveryLocMa =UTIL_DataCreationForTestClass.getDelieveryLocationMaster('testdata',clientGeo.id);
        
        insert deliveryLocMa;
    
        // To create a Deal
        deal =UTIL_DataCreationForTestClass.getDealRecord('Test Data',testUser.id);
        insert deal;
    
        // To create a offering
        offering = UTIL_DataCreationForTestClass.getOfferingMaster('Test Data');        
        insert offering;
    
        //To create a Wave Plan Version
        wavePlanVersion =UTIL_DataCreationForTestClass.getWavePlanVersionRecord('Test Data',deal.id);
        insert wavePlanVersion;
    
        // To create a Deal Home Location
        dealHome =UTIL_DataCreationForTestClass.getDealHomeLocation(deliveryLocMa.id,deal.id);         
        insert dealHome;
    
    
        // To create a Deal Location
        dealLoc= UTIL_DataCreationForTestClass.getDealLocation('test Data',dealHome.id,wavePlanVersion.id);      
        insert dealLoc;
    
        // To Create Client Specific Process Mapping
    
        clientSpecificProcessMapping = UTIL_DataCreationForTestClass.getClientSpecificProcessMapping('TestData',deal.id,offering.id);
        insert clientSpecificProcessMapping;
    
        //To create a Wave Plan
    
        waveplan =UTIL_DataCreationForTestClass.getWavePlanning(dealLoc.id,System.today(),'test');
        waveplan.Wave_Comment__c='test data';
        waveplan.Wave_Label__c='TestData';
        waveplan.GO_Live_Date_del__c=date.today()+7;
        waveplan.Deal_Location__c=dealLoc.id;
        waveplan.Number_of_Projected_FTEs__c=1;
        insert waveplan; 
    
        // To create a Wave Process
    
        WaveProcess =UTIL_DataCreationForTestClass.getWaveProcess(waveplan.id);        
        WaveProcess.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
        insert WaveProcess;
    
        // To Create Commercial Planning
        comPlan = UTIL_DataCreationForTestClass.getWaveCommercialPlanning('TestData','TestData',2314);
        comPlan.Delivery_Location__c=deliveryLocMa.id;
        comPlan.Planned_Start_Date__c=date.today();
        comPlan.Planned_End_Date__c=date.today()+7;
        insert comPlan;
    
        //To create a Facility Master 
        FacMaster= new Facility_Master__c();
        FacMaster.Name='test';
        FacMaster.Delivery_Location_Master__c=deliveryLocMa.id;
        insert FacMaster;
        //To create a Deal Location Facility
        dealLocFac=new Deal_Location_Facility__c();
        dealLocFac.Deal_Home_Location__c=dealHome.id;
        dealLocFac.Facility_Master__c=FacMaster.id;
        insert dealLocFac;
      
    }
    
    /*static void byPassTrigger()
    {
        ApexTrigger at = [select id from ApexTrigger where name='AccessPermissionDealWave'];
        at.status = 'Inactive';
        update at;
    }*/
    static testMethod void test1(){
    //byPassTrigger();
    test.starttest();
    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
//byPassTrigger();
    setupData();
    ApexPages.StandardController controller;

    apexpages.currentpage().getparameters().put('Id' ,deal.id);
    apexpages.currentpage().getparameters().put('pageid',deal.id);
     
     DealHomeLocation_InlineController obj = new DealHomeLocation_InlineController( controller);
      try
     {
         obj.getLocationNames();
         obj.addLocationDetail();
         obj.initializeDetailRecords();
         obj.saveLocationDetails();
         obj.refreshLocationPage();
         obj.CheckRelationWithWavePlanVersion();
    }
    
      catch(Exception ex)
      {
         
      }
     test.stoptest();
        
     }  
    } 
     
     static testMethod void test2(){
        test.starttest();
      Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);

//Run As U1
    System.RunAs(testUser){
    setupData();
    ApexPages.StandardController controller;

    apexpages.currentpage().getparameters().put('Id' ,null);
     
     DealHomeLocation_InlineController obj = new DealHomeLocation_InlineController( controller);
      try
      {
         obj.getLocationNames();
         obj.addLocationDetail();
         obj.initializeDetailRecords();
         obj.saveLocationDetails();
         obj.refreshLocationPage();
         obj.CheckRelationWithWavePlanVersion();
      }
      catch(Exception ex)
      {
          
      }
      
    }
    
     test.stoptest();
        
  }  
     
     
      
    }