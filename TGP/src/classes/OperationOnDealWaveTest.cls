@isTest
private class OperationOnDealWaveTest{

    static Wave_Planning__c wavePlanning;
    static Wave_Planning__c wavePlanningRec;
    static Deal_Location__c dealLoc;
    static Wave_Plan_Version__c wavePlanVersion;
    static Deal_TGP__c deal;
    static Client_Geo_Area_Master__c clientGeo;
    static Delievery_Location_Master__c deliveryLocMa;
    static Deal_Home_Location__c dealHome;
    static Profile p;
    static User u;
    static SRAT__c srat;
    static SRAT_VERSION__c sratversion;
    static SRAT_Item_Master__c sratItemMaster;
    static Recruitment_Tracking__c RecruitmentTracking;
    static KT_Planning_Activity_Master__c ktPlanActivityMaster;
    static OPEX__c opex;
    static Activity_Master__c activityMaster;
    static Tech_Assessment_Activity_Master__c techAssActivityMaster;
    

     /*
    *   @Method : setupData
    *   @ Description : This method will create test data
    */

     public static void setupData(){
     
     
         p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        u = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(u, false);
     
          // To create a Client Geo    
        clientGeo = UTIL_DataCreationForTestClass.getClientGEOAreaMaster('test');
        clientGeo.Client_Geo_Area_Description__c='TestData';
        insert clientGeo;
        
        // To create a Deal
        deal =UTIL_DataCreationForTestClass.getDealRecord('Test Data',u.id);
        insert deal;
        
        //To create a Wave Plan Version
        wavePlanVersion =UTIL_DataCreationForTestClass.getWavePlanVersionRecord('Test Data',deal.id);
        wavePlanVersion.active__c = true;
        wavePlanVersion.Display_tracking_message__c = null ;
        insert wavePlanVersion;
     
          // To create a Delivery Location Master
        deliveryLocMa =UTIL_DataCreationForTestClass.getDelieveryLocationMaster('testdata',clientGeo.id);        
        insert deliveryLocMa;
     
         // To create a Deal Home Location
        dealHome =UTIL_DataCreationForTestClass.getDealHomeLocation(deliveryLocMa.id,deal.id);         
        insert dealHome;
     
         // To create a Deal Location
        dealLoc= UTIL_DataCreationForTestClass.getDealLocation('test Data',dealHome.id,wavePlanVersion.id);      
        insert dealLoc;
        
        sratItemMaster = UTIL_DataCreationForTestClass.getSRATItemMaster();
        sratItemMaster.Days_Before_Go_Live_Date__c = -1;
        sratItemMaster.Item_Name__c = 'test';
        insert sratItemMaster;
        
        //To create SRAT Version

        sratversion=new SRAT_Version__c();
        sratversion.isActive__c=true;
        insert sratversion;
        
        ktPlanActivityMaster = UTIL_DataCreationForTestClass.getKTPlanningActivityMaster('Test');
        ktPlanActivityMaster.Is_Active__c = true;
        ktPlanActivityMaster.Activity_Order__c = 20;
        insert ktPlanActivityMaster;
        
         wavePlanningRec = UTIL_DataCreationForTestClass.getWavePlanning(dealLoc.id,System.today(),'test');
         
         insert wavePlanningRec;
        
        RecruitmentTracking = UTIL_DataCreationForTestClass.getRecruitmentTracking(dealLoc.id,wavePlanningRec.id,'TestRecruitmentData','TestActData',date.today(),date.today()+7,11);
        insert RecruitmentTracking;
        
        opex = UTIL_DataCreationForTestClass.getOpexRec('test',date.today(),dealLoc.id,wavePlanningRec.id);
        opex.Active__c=true;
        insert opex;
        
        activityMaster = UTIL_DataCreationForTestClass.getActivityMaster(23);
        activityMaster.Is_Active__c = true;
        insert activityMaster;
        
        techAssActivityMaster = UTIL_DataCreationForTestClass.getTechAssessmentActivityMaster(54);
        techAssActivityMaster.Activity_Order__c = 20;
        insert techAssActivityMaster;
        
        
     }
     
     /*
    *   @Method : testOperationOnWavePlanVersion
    *   @ Description : This method will create wave plan version record
    */
     static testMethod void testOperationOnDealWave(){   
     
         setupData();
                  
         wavePlanning = UTIL_DataCreationForTestClass.getWavePlanning(dealLoc.id,System.today(),'test');
         wavePlanning.Deal_Location__c = dealLoc.id;
         wavePlanning.GO_Live_Date_del__c = System.today();
         wavePlanning.Wave_Label__c = 'test';
         insert wavePlanning;
         
         wavePlanning.Wave_Label__c = 'new test';
         update wavePlanning;
         
         srat = UTIL_DataCreationForTestClass.getSRAT();
        srat.Has_KT_Lead_Submitted__c=true;
        srat.Wave_Plan_Version__c=wavePlanVersion.id;
        //srat.SRAT_Version__c=sratversion.id;
        srat.name='Test Data';
        srat.Planned_Date__c=date.today();
        srat.Deal_Location_lk__c=dealLoc.id;
        srat.Wave_Plan_lk__c=wavePlanning.id;
        insert srat;
        
        RecruitmentTracking = UTIL_DataCreationForTestClass.getRecruitmentTracking(dealLoc.id,wavePlanning.id,'TestRecruitmentData','TestActData',date.today(),date.today()+7,11);
        insert RecruitmentTracking;
        
     }
}