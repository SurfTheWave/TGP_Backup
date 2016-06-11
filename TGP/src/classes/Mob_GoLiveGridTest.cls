/*
    Author : Harshit shah
    Story  :   
    Description : Test Class for DealHomeLocation_InlineController. 

    Updated by        Story no.                Update Date        Update details
    ------------    -----------------        --------------    -------------------------------------------------------------


    */
    @isTest
    public class Mob_GoLiveGridTest{

    static Client_Specific_Process_Mapping__c clientSpecificProcessMapping;
    static SRAT__c srat;
    static SRAT_VERSION__c sratversion;
    static OPEX__c opex;
    static Commercial_Planning__c comPlan;
    static KT_Planning__c kTPlan;
    static Recruitment_Tracking__c RecruitmentTracking;
    static Contract_Legal_Infosec_Section_Master__c joumg;
    static Contract_Legal_Infosec_Task_Master__c joumgde;
    static Tech_Assessment__c techAsess;
    static Offerings_Master__c offering;
    static User testUser;
    static Wave_Plan_Version__c wavePlanVersion;
    static Deal_TGP__c deal;
    static Wave_Planning__c waveplan;
    static Wave_Planning__c waveplan1;
    static Wave_Process__c WaveProcess;
    static Deal_Location__c dealLoc;
    static Deal_Location__c dealLoc1;
    static Deal_Home_Location__c dealHome;
    static Delievery_Location_Master__c deliveryLocMa;
    static Client_Geo_Area_Master__c clientGeo;
    static Deal_Location_Facility__c dealLocFac;
    static Facility_Master__c FacMaster;
    static List<Wave_Plan_Version__c> wpvList = new List<Wave_Plan_Version__c>();
    static List<Deal_Home_Location__c> dealHomeLocationList = new List<Deal_Home_Location__c>();


    public static void setupData(){
    
        // To create a Client Geo
    
        clientGeo = new Client_Geo_Area_Master__c();
        clientGeo.Client_Geo_Area_Description__c='TestData';
        Database.insert(clientGeo);
    
        // To create a Delivery Location Master
        deliveryLocMa =new Delievery_Location_Master__c();
        deliveryLocMa.Delivery_Location_Description__c='testdata';
        deliveryLocMa.Name='TestData';
        deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
        Database.insert(deliveryLocMa);
    
        // To create a Deal
        deal =new Deal_TGP__c();
        deal.Name='Test Data';
        Database.insert(deal);
    
        // To create a offering
        offering =new Offerings_Master__c();
        offering.Name='Test Data';
        Database.insert(offering);
    
        //To create a Wave Plan Version
        wavePlanVersion =new Wave_Plan_Version__c();
        wavePlanVersion.Display_tracking_message__c='Test Data';
        wavePlanVersion.Deal__c = deal.id;
        Database.insert(wavePlanVersion);
        wpvList.add(wavePlanVersion);
        
        // To create a Deal Home Location
        dealHome =new Deal_Home_Location__c(); 
        dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
        dealHome.Deal__c= deal.id;
        dealHome.Active__c=true;
        Database.insert(dealHome);
        dealHomeLocationList.add(dealHome); 

        // To create a Deal Location
        dealLoc= new Deal_Location__c();
        dealLoc.Location__c='test Data';
        dealLoc.NewActive__c=false;
        dealLoc.Deal_Home_Location__c=dealHome.id;
        dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
        Database.insert(dealLoc);
        
        // To create a Deal Location
        /*dealLoc1= new Deal_Location__c();
        dealLoc1.Location__c='test Data1';
        dealLoc1.Deal_Home_Location__c=dealHome.id;
        dealLoc1.Wave_Plan_Version__c=wavePlanVersion.id;
        dealLoc1.NewActive__c = false;
        insert dealLoc1;*/
    
        // To Create Client Specific Process Mapping
    
        clientSpecificProcessMapping = new Client_Specific_Process_Mapping__c();
        clientSpecificProcessMapping.Name='TestData';
        clientSpecificProcessMapping.Deal__c=deal.id;
        clientSpecificProcessMapping.Offering__c=offering.id;
        Database.insert(clientSpecificProcessMapping);
    
        //To create a Wave Plan
    
        waveplan =new Wave_Planning__c();
        waveplan.Wave_Comment__c='test data';
        waveplan.Wave_Label__c='TestData';
        waveplan.GO_Live_Date_del__c=date.today()+7;
        waveplan.Deal_Location__c=dealLoc.id;
        waveplan.NewActive__c=false;
        waveplan.Number_of_Projected_FTEs__c=1;
        Database.insert(waveplan);
        List<Wave_Planning__c> lstWavePlan = [Select Wave_Label__c,GO_Live_Date_del__c,Number_of_Projected_FTEs__c,Active__c,NewActive__c,Deal_Location__c,isEditVisible__c from Wave_Planning__c];
             
        //To create a Wave Plan
    
        /*waveplan1 =new Wave_Planning__c();
        waveplan1.Wave_Comment__c='test data1';
        waveplan1.Wave_Label__c='TestData1';
        waveplan1.GO_Live_Date_del__c=date.today()+7;
        waveplan1.Deal_Location__c=dealLoc1.id;
        waveplan1.Number_of_Projected_FTEs__c=1;
        insert waveplan1;*/ 
    
        // To create a Wave Process
    
        WaveProcess =new Wave_Process__c();
        WaveProcess.Wave_Planning__c=waveplan.id;
        WaveProcess.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
        Database.insert(WaveProcess);
    
        // To Create Commercial Planning
        comPlan = new Commercial_Planning__c();
        comPlan.Name='TestData';
        comPlan.Activity__c='TestData';
        comPlan.Delivery_Location__c=deliveryLocMa.id;
        comPlan.Planned_Start_Date__c=date.today();
        comPlan.Planned_End_Date__c=date.today()+7;
        Database.insert(comPlan);
    
        //To create a Facility Master 
        FacMaster= new Facility_Master__c();
        FacMaster.Name='test';
        FacMaster.Delivery_Location_Master__c=deliveryLocMa.id;
        Database.insert(FacMaster);
        //To create a Deal Location Facility
        dealLocFac=new Deal_Location_Facility__c();
        dealLocFac.Deal_Home_Location__c=dealHome.id;
        dealLocFac.Facility_Master__c=FacMaster.id;
        Database.insert(dealLocFac);
        
        //To create SRAT Version

        sratversion=new SRAT_Version__c();
        sratversion.isActive__c=true;
        Database.insert(sratversion);
        
        //To create SRAT

    srat=new SRAT__c();
    srat.Has_KT_Lead_Submitted__c=true;
    srat.Wave_Plan_Version__c=wavePlanVersion.id;
    srat.SRAT_Version__c=sratversion.id;
    srat.name='Test Data';
    srat.Planned_Date__c=date.today();
    srat.Deal_Location_lk__c=dealLoc.id;
    srat.Wave_Plan_lk__c=waveplan.id;
    Database.insert(srat);
    
    opex =new OPEX__c();
    opex.Deal_Location_lk__c=dealLoc.id;
    opex.Wave_Plan_lk__c=waveplan.id;
    opex.Item__c='Day 30 Assessment';
    opex.Active__c=true;
    opex.Planned_Date__c=date.today();
    opex.Deal_Location__c='India';
    opex.Wave_Plan_Version__c=wavePlanVersion.id;
    Database.insert(opex); 
    
    // To Create Commercial Planning
    comPlan = new Commercial_Planning__c();
    comPlan.Name='TestData';
    comPlan.Activity__c='TestData';
    comPlan.Delivery_Location__c=deliveryLocMa.id;
    comPlan.Planned_Start_Date__c=date.today();
    comPlan.Planned_End_Date__c=date.today()+7;
    Database.insert(comPlan);


      
//To create a Contract Legal Infosec record
      
    kTPlan=new KT_Planning__c();
    kTPlan.Activity__c='TestData';
    kTPlan.Planned_Start_Date__c=date.today();
    kTPlan.Planned_End_Date__c=date.today()+7;
    kTPlan.Wave_Plan_lk__c=waveplan.id;
    kTPlan.isEditVisible__c=false;
    kTPlan.Milestone__c=false;
    kTPlan.Wave_Plan_Version__c=wavePlanVersion.id;
    kTPlan.Deal_Location_lk__c=dealLoc.id;
    kTPlan.Comments__c=null;
    Database.insert(kTPlan);
    
    //To create a Recruitment tracking Plan record
      
    RecruitmentTracking=new Recruitment_Tracking__c();
    RecruitmentTracking.Name='TestRecruitmentData';
    RecruitmentTracking.Activity__c='TestActData';
    RecruitmentTracking.Planned_Start_Date__c=date.today();
    RecruitmentTracking.Planned_End_Date__c=date.today()+7;
    RecruitmentTracking.Wave_Plan_lk__c=waveplan.id;
    RecruitmentTracking.Deal_Location_lk__c=dealLoc.id;
    RecruitmentTracking.FTE_Number__c=11;
    RecruitmentTracking.Wave_Plan_Version__c=wavePlanVersion.id;
    Database.insert(RecruitmentTracking);
      
      
     /* //To create a Contract_Legal_Infosec_Section_Master__c
      
        joumg=new Contract_Legal_Infosec_Section_Master__c();
        joumg.Section_Name__c='TestData';
        joumg.Section_Number__c='5555';
        insert joumg;
        List<Contract_Legal_Infosec_Section_Master__c>  smList=[Select name ,id from Contract_Legal_Infosec_Section_Master__c where id=:joumg.id];
         upsert smList[0];
        //To create a Contract_Legal_Infosec_Task_Master__c
              
        joumgde=new Contract_Legal_Infosec_Task_Master__c();
        joumgde.Task_Name__c='Name';
        joumgde.Task_Number__c='555555';
        joumgde.Contract_Legal_Infosec_Section_Master__c=joumg.id;
        insert joumgde;*/
        
        //To create a Tech Asessment record
        techAsess=new Tech_Assessment__c();
        techAsess.Name='TestData';
        techAsess.Activity__c='TestData';
        techAsess.Planned_Start_Date__c=date.today();
        techAsess.Planned_End_Date__c=date.today()+7;
        techAsess.Wave_Plan_lk__c=waveplan.id;
        techAsess.Deal_Location_lk__c=dealLoc.id;
        techAsess.comments__c ='test';
        Database.insert(techAsess);
        
        Contract_Legal_Infosec__c contractLegalInfosec=new Contract_Legal_Infosec__c();
        contractLegalInfosec.Active__c=true;
        contractLegalInfosec.Wave_Plan_lk__c=waveplan.id;
        contractLegalInfosec.isEditVisible__c=true;
        contractLegalInfosec.Wave_Plan_Version__c=wavePlanVersion.id;
        database.insert(contractLegalInfosec);
        
        //To Create Tech Assessment record  
        Tech_Assessment__c techAssesment=new Tech_Assessment__c();
        techAssesment.Name='Test TechAssessment';
        techAssesment.Activity__c='Test Activity';
        techAssesment.Deal_Location_lk__c=dealLoc.Id;
        techAssesment.Wave_Plan_lk__c=waveplan.id;
        techAssesment.Wave_Plan_Version__c=wavePlanVersion.id;
        database.insert(techAssesment);
    }
    
    static testMethod void insertLocationTest() {
        setupData();
        Mob_GoLiveGrid.addLocation(dealHomeLocationList);
        //Mob_GoLiveGrid.enableHighLevelPlans(String.valueOf(wavePlanVersion.Id));
    }
    static testMethod void insertHLVTest() {
        setupData();
        Mob_GoLiveGrid.enableHighLevelPlans(String.valueOf(wavePlanVersion.Id));
    }
    static testMethod void insertLocationTestforDiableHighLevelPlans() {
        setupData();
        Mob_GoLiveGrid.disableHighLevelPlans(String.valueOf(wavePlanVersion.Id));
   }
    
}