@isTest
    private class Mob_RebaselineHighLevelPlanTest
    {
    static Deal_TGP__c strDealTGP;
    static Deal_TGP__c deal;
    static Wave_Plan_Version__c strWavePlanVersion;
    static Wave_Plan_Version__c strWavePlanVersion1;
    static Deal_Location__c strDealLocation;
    static Wave_Planning__c strWavePlanning;
    static Client_Master__c clientName;
    static Client_Geo_Area_Master__c clientGeoArea;
    static Operating_Group_Master__c operatingGroup;
    static Client_Geo_Unit_Master__c clientGeoUnit;
    static Opportunity_TGP__c oppTGP;
    static Offerings_Master__c oppOffering;
    static Client_Specific_Process_Mapping__c clientProcess;
    static Wave_Process__c strWaveProcess;
    static SRAT__c strSRAT;
    static OPEX__c strOPEX;
    static Contract_Legal_Infosec__c conLegInfo;
    static Commercial_Planning__c comPlan;
    static KT_Planning__c strKTPlanning;
    static Recruitment_Tracking__c strRecruitmentTracking;
    static Commercial_Planning__c strCommercialPlanning;
    static Contract_Legal_Infosec__c strContractLegalInfosec;
    static Tech_Assessment__c strTechAssessment;
    static Mob_User_Roles_Master__c strMoURM; 
    static MOB_User_Role_Assignment__c strMoURA;
    static Tracking_KT__c trackTracker;
    static DTP_Tracker__c dtpTracker;
    static KT_Tracker__c ktTracker;
    static Wave_Planning__c waveplan;
    static Client_Specific_Process_Mapping__c clientSpecificProcessMapping;
    static Offerings_Master__c offering;
    static Wave_Plan_Version__c wavePlanVersion;
    static Recruitment_Tracker__c recTracker;
    static Tracking_Recruitment__c trackRecruitment;
    static Tech_Tracker__c techTrack;
    static Deal_Location__c dealLoc;
    static Deal_Home_Location__c dealHome;
    static Delievery_Location_Master__c deliveryLocMa;
    static Client_Geo_Area_Master__c clientGeo;
    static Tracking_Tech_Assessment__c trackTech ;
/*-----------------------------------------------------------------------------------------------------------------------------*/
    public static void setupDataWPV()
    {
        strDealTGP=new Deal_TGP__c(Name='DealTest123');
        insert strDealTGP;
        strWavePlanVersion =new Wave_Plan_Version__c(Name='WaveTest123',Deal__c=strDealTGP.id,Active__c=true);
        insert strWavePlanVersion;  
    }
    public static void setupDataDealLocation()
    {
        setupDataWPV();
        strDealLocation=new Deal_Location__c(Wave_Plan_Version__c=strWavePlanVersion .id);
        insert strDealLocation;
        strDealLocation.cloned_from__C=strDealLocation.id;
        update strDealLocation;
    }
    public static void setupDataDealWave()
    {
        setupDataDealLocation();
        strWavePlanning=new Wave_Planning__c(Wave_Label__c='waveTest', Number_of_Projected_FTEs__c=1,GO_Live_Date_del__c=System.today()+1, Deal_Location__c=strDealLocation.id);
        insert  strWavePlanning;
        strWavePlanning.cloned_from__C=strWavePlanning.id;
        update strWavePlanning;
    }
    public static void setupDataWaveProcess()
    {
        setupDataDealWave();
        oppOffering = new Offerings_Master__c(Active__c=true);
        insert oppOffering;

        clientProcess=new Client_Specific_Process_Mapping__c(Name='processTest', Deal__c=strDealTGP.id, Offering__c=oppOffering.id);
        insert clientProcess;

        strWaveProcess=new Wave_Process__c(Wave_Planning__c=strWavePlanning.id, Client_Specific_Process_Mapping__c=clientProcess.id);
        insert strWaveProcess;      

        strWaveProcess.cloned_from__C=strWaveProcess.id;
        //update strWaveProcess;
    }
    public static void setupDataSRAT()
    {
        setupDataDealWave();
        SRAT_Item_Master__c item = new SRAT_Item_Master__c(Days_Before_Go_Live_Date__c=-91,Item_Name__c='SRAT T-91');
        insert item;
        setupDataDealWave();
        strSRAT=new SRAT__c(Name='TestSrat', Planned_Date__c=System.today()+1, Deal_Location_lk__c=strDealLocation.id, Wave_Plan_lk__c=strWavePlanning.id, 
        Wave_Plan_Version__c=strWavePlanVersion.id, Item__c='SRAT T-90',SRAT_Item_Master_Id__c=item.id);
        insert strSRAT;     
        strSRAT.cloned_from__C=strSRAT.id;
        update strSRAT;
        SRAT_User_Section_Question__c secqn= new SRAT_User_Section_Question__c();
        secqn.SRAT__C = strSRAT.id;
        insert secqn;
        SRAT_User_Sub_Section_Question__c subqn= new SRAT_User_Sub_Section_Question__c();
        subqn.SRAT__C = strSRAT.id;
        insert subqn;
        Factory_Specific_Technology__c fact = new Factory_Specific_Technology__c();
        fact.SRAT__C = strSRAT.id;
        fact.RAG_Status__c='G=Complete';
        fact.Application_Name__c='fact_1';
        insert fact;
    }
    public static void setupDataOPEX()
    {
        setupDataWaveProcess();
        OPEX_Item_master__c item = new OPEX_Item_master__c(Days_After_Go_Live_Date__c=91,Item_Name__c='OPEX T-91');
        insert item;
        
        item = new OPEX_Item_master__c(Days_After_Go_Live_Date__c=61,Item_Name__c='OPEX T-61', Is_Active__c=false);
        insert item;
        
        strOPEX=new OPEX__c(Name='TestOpex', Planned_Date__c=System.today()+1, Deal_Location_lk__c=strDealLocation.id, Wave_Plan_lk__c=strWavePlanning.id,Wave_Plan_Version__c=strWavePlanVersion.id, Item__c='Ok-Day-90',opex_Item_Master_Id__c=item.id);
        insert strOPEX;     
        strOPEX.cloned_from__C=strOPEX.id;
        update strOPEX;
        OPEX_User_Section_Question__c secqn = new OPEX_User_Section_Question__c();
        secqn.OPEX__C = strOPEX.id;
        insert secqn;
        
        
    }
    public static void setupDataServiceManagement()
    {
        
        // To Create Service Management Phase Master
        Service_Management_Master__c serManPh= new Service_Management_Master__c();
        serManPh.Phase_Name__c='Test';
        serManPh.Phase_Number__c=19;
        insert serManPh;
        // To Create Service Management Task Master
        Service_Management_Task_Master__c serManTa= new Service_Management_Task_Master__c();
        serManTa.Task_Name__c='Test';
        serManTa.Task_Number__c=191;
        serManTa.Service_Management_Phase__c=serManPh.id;
        serManTa.Is_Active__c =true;
        insert serManTa;
           
        setupDataWPV();
    // To create Service Management

       Service_Management__c serMgmt=new Service_Management__c();
        serMgmt.Name='TestData';
        serMgmt.Activity__c='TestData';
        serMgmt.Planned_Start_Date__c=date.today();
        serMgmt.Planned_End_Date__c=date.today()+7;
        serMgmt.Wave_Plan_Version__c=strWavePlanVersion.id;
        serMgmt.Phase_Name__c='Test';
        serMgmt.Phase_Number__c=19;
        serMgmt.Task_Name__c='Test';
        serMgmt.Task_Number__c=191;
        serMgmt.Task_ID__c=serManTa.id;
        insert serMgmt;  
   
    }
    
    public static void setupDataServiceManagement1()
    {
        Service_Management_Master__c serManPh1= new Service_Management_Master__c();
        serManPh1.Phase_Name__c='Test1';
        serManPh1.Phase_Number__c=20;
        insert serManPh1;
        
        Service_Management_Task_Master__c serManTa1= new Service_Management_Task_Master__c();
        serManTa1.Task_Name__c='Test1';
        serManTa1.Task_Number__c=201;
        serManTa1.Service_Management_Phase__c=serManPh1.id;
        serManTa1.Is_Active__c =true;
        insert serManTa1;
                       
        setupDataWPV();   
    }
    
    public static void setupDataKTPlanning1()
    {
        
        List<KT_Planning_Activity_Master__c> lst = new List<KT_Planning_Activity_Master__c>();
        KT_Planning_Activity_Master__c ktAct = new KT_Planning_Activity_Master__c(Name='kt1_1', Activity_Order__c=20);
        insert ktAct;
        
        ktAct = new KT_Planning_Activity_Master__c(Name='kt1_2',Activity_Order__c=25,Is_Active__c=true);
        insert ktAct;
        
        setupDataDealWave();
        /*strKTPlanning=new KT_Planning__c( Planned_Start_Date__c=System.today()+1, Planned_End_Date__c=System.today()+2, 
        Deal_Location_lk__c=strDealLocation.id, Wave_Plan_lk__c=strWavePlanning.id, Activity__c='TestActivity', Wave_Plan_Version__c=strWavePlanVersion.id,KT_Planning_Activity_Master_ID__c=ktAct.id);
        insert strKTPlanning; */      
    }
    public static void setupDataKTPlanning2()
    {
        
        List<KT_Planning_Activity_Master__c> lst = new List<KT_Planning_Activity_Master__c>();
        KT_Planning_Activity_Master__c ktAct = new KT_Planning_Activity_Master__c(Name='kt1_1',Activity_Order__c=30);
        insert ktAct;
        
        ktAct = new KT_Planning_Activity_Master__c(Name='kt1_2',Activity_Order__c=35,Is_Active__c=true);
        insert ktAct;
        
        setupDataDealWave();
    }   
    public static void setupDataKTTracker()
    {
        setupDataDealWave();
        //To Insert KT Tracker
        ktTracker= new KT_Tracker__c();
        ktTracker.name='test';
        ktTracker.Deal_Wave__c=strWavePlanning.id;
        insert ktTracker;       

        //To Insert DTP Tracker
        dtpTracker= new DTP_Tracker__c();
        dtpTracker.name='test';
        dtpTracker.Deal_Wave__c=strWavePlanning.id;
        insert dtpTracker;
        
        //To Insert Tracking_KT__c
        trackTracker= new Tracking_KT__c();
        trackTracker.name='test';
        trackTracker.Deal_Wave__c=strWavePlanning.id;
        insert trackTracker;
    }
    public static void setupDataRecruitmentTracking()
    {
        
        Activity_Master__c act = new Activity_Master__c(name='act1',Activity_Order__c=15);
        insert act;
        
        act = new Activity_Master__c(name='act2',Activity_Order__c=20, Is_Active__c=true);
        insert act;

        setupDataDealWave();
        /*strRecruitmentTracking=new Recruitment_Tracking__c(Name='TestRecruitment', Planned_Start_Date__c=System.today()+1, Planned_End_Date__c=System.today()+2,
        Deal_Location_lk__c=strDealLocation.id, Wave_Plan_lk__c=strWavePlanning.id, FTE_Number__c=10, Activity__c='TestActivity', Wave_Plan_Version__c=strWavePlanVersion.id,Activity_Master_ID__c=act.id);
        insert strRecruitmentTracking;*/  
    }
    public static void setupDataRecruitmentTracker()
    {
        setupDataDealLocation();
    //To Insert Recruitment_Tracker__c
     
        recTracker= new Recruitment_Tracker__c();
        recTracker.Wave_Name__c='test';
        recTracker.Deal_Location__c=strDealLocation.id;
        insert recTracker;
        
    //To Insert Tracking_Recruitment__c
        trackRecruitment= new Tracking_Recruitment__c();
        trackRecruitment.Name='test';
        trackRecruitment.Deal_Location__c=strDealLocation.id;
        insert trackRecruitment;        
    }
    public static void setupDataCommercialPlanning()
    {
       
        Commercial_Plan_Activity_Master__c act = new Commercial_Plan_Activity_Master__c(Activity_Name__c='act',Activity_Order__c=50);
        insert act;
        
        setupDataWPV();
        
        /*strCommercialPlanning=new Commercial_Planning__c (Name='TestKT', Planned_Start_Date__c=System.today()+1, Planned_End_Date__c=System.today()+2, 
        Activity__c='TestActivity', Wave_Plan_Version__c=strWavePlanVersion.id,Commercial_Plan_Activity_Master_Id__c=act.id);
        insert strCommercialPlanning; */
        Budget_Solution__c sol = new  Budget_Solution__c(Wave_Plan_Version__c=strWavePlanVersion.id);
        insert sol;
        Budget_Reforecast__c reforecast = new Budget_Reforecast__c(Budget_Solution__c=sol.id );          
        insert reforecast; 
    }
    public static void setupDataContractLegalInfosec()
    {
        //To create a Contract Legal Infosec record
        
        Contract_Legal_Infosec_Section_Master__c section = new Contract_Legal_Infosec_Section_Master__c(Section_Name__c='sec',Section_Number__c='12');
        insert section;
        Contract_Legal_Infosec_Task_Master__c task = new Contract_Legal_Infosec_Task_Master__c(Contract_Legal_Infosec_Section_Master__c=section.id,Task_Name__c='task1',Task_Number__c='12');
        insert task;
        
        setupDataWPV();
        /*conLegInfo=new Contract_Legal_Infosec__c();
        conLegInfo.Name='TestData';
        conLegInfo.Activity__c='TestData';
        conLegInfo.Planed_Start_Date__c=date.today();
        conLegInfo.Planned_End_Date__c=date.today()+7;
        conLegInfo.Wave_Plan_Version__c=strWavePlanVersion.id;
        conLegInfo.Task_Master_ID__c=task.id;
        insert conLegInfo; */     
    }
    public static void setupDataTechAssessment()
    {
        
        Tech_Assessment_Activity_Master__c act = new Tech_Assessment_Activity_Master__c(name='act1',Activity_Order__c=12);
        insert act;
        setupDataDealWave();
        /*strTechAssessment=new Tech_Assessment__c(Name='TestKT', Planned_Start_Date__c=System.today()+1, Planned_End_Date__c=System.today()+2, 
        Deal_Location_lk__c=strDealLocation.id, Wave_Plan_lk__c=strWavePlanning.id, Activity__c='TestActivity', Wave_Plan_Version__c=strWavePlanVersion.id,Tech_Assessment_Activity_Master_ID__c=act.id);
        insert strTechAssessment; */      
    }
    public static void setupDataTechTracker()
    {
        setupDataDealWave();
        TechTrack = new Tech_Tracker__c();
        TechTrack.name='test';
        TechTrack.Deal_Wave__c=strWavePlanning.id;
        insert TechTrack ;
        trackTech = new Tracking_Tech_Assessment__c();
        trackTech.name='test';         
        trackTech.Deal_Wave__c=strWavePlanning.id;
        insert trackTech;
                 
    }
    public static void setupDataJourneyPlan()
    {
        
        Journey_Management__c jManagaement=new Journey_Management__c (Section_Name__c='TestKT', Section_Number__c='999');
        insert jManagaement; 
        Journey_Management_Deliverable__c delivery = new Journey_Management_Deliverable__c(Deliverable_Name__c='del1',Deliverable_Number__c='1',Journey_Management__c=jManagaement.id);     
        insert delivery;
        setupDataWPV();
        /*Journey_Management_Planning__c jManagaementPlanning=new Journey_Management_Planning__c  (Section_Name__c='TestKT', Section_Number__c='999', Journey_Management_Deliverable_ID__c= delivery.id);
        insert jManagaementPlanning;  */      
    }
    public static void setupDataBCPPlan()
    {
        
        BCP_Section_Master__c section = new BCP_Section_Master__c();
        section.Section_Name__c='bcp1';
        section.Section_Number__c='10';
        insert section;
        
        BCP_Task_Master__c task = new BCP_Task_Master__c();
        task.Business_Continuity_Planning_del__c=section.id;
        task.Task_Name__c='task1';
        task.Task_Number__c=10;
        insert task;
        
        setupDataWPV();
        // To create a BCP record
        /*Business_Continuity_Planning__c bcpRec=new Business_Continuity_Planning__c ();
        bcpRec.Wave_Plan_Version__c=strWavePlanVersion.id;
        bcpRec.Active__c=true;
        bcpRec.Comments__c='test';
        bcpRec.Section_Number__c='2';
        bcpRec.Section_Name__c='test';
        bcpRec.Task_Name__c='test';
        bcpRec.Task_Number__c=3;
        bcpRec.Planned_End_Date__c=date.today()+7;
        bcpRec.Planned_Start_Date__c=date.today();
        bcpRec.BCP_Section_Master_Id__c=section.id;
        bcpRec.BCP_Task_Master_Id__c=task.id;
        insert bcpRec; */     
    }
/*-----------------------------------------------------------------------------------------------------------------------------*/

    static testMethod void testrebaselineHighLevelPlan()
    {
        Test.startTest();
        setupDataWPV();
        Mob_RebaselineHighLevelPlan.rebaselineHighLevelPlan(strWavePlanVersion.id);
        Test.stopTest();
    }
    static testMethod void testcloneDealLocation()
    {
        Test.startTest();
        setupDataDealLocation();
        Mob_RebaselineHighLevelPlan.cloneDealLocation(strWavePlanVersion.id,strWavePlanVersion.id,2);
        Test.stopTest();
    }
    static testMethod void testcloneDealWave()
    {
        Test.startTest();
        setupDataDealWave();
        Mob_RebaselineHighLevelPlan.cloneDealWave(strWavePlanVersion.id,strWavePlanVersion.id,2);
        Test.stopTest();
    }
    static testMethod void testcloneWaveProcess()
    {
        Test.startTest();
        setupDataWaveProcess();
        Mob_RebaselineHighLevelPlan.cloneWaveProcess(strWavePlanVersion.id,strWavePlanVersion.id,2);
        Test.stopTest();
    }
    
    static testMethod void testcloneOPEX()
    {
        Test.startTest();
        setupDataOPEX();
        Mob_RebaselineHighLevelPlan.cloneOPEX(strWavePlanVersion.id,strWavePlanVersion.id,2);
        Test.stopTest();
    }
    
    static testMethod void testcloneServiceManagement()
    {
        Test.startTest();
        setupDataServiceManagement();
        Mob_RebaselineHighLevelPlan.cloneServiceManagement(strWavePlanVersion.id,strWavePlanVersion.id,2);
        Test.stopTest();
    }
    
    static testMethod void testcloneServiceManagement1()
    {
        Test.startTest();
        setupDataServiceManagement1();
        
        Deal_TGP__c strDealTGP1=new Deal_TGP__c(Name='DealTest1234');
        insert strDealTGP1;
        strWavePlanVersion1 =new Wave_Plan_Version__c(Name='WaveTest1234',Deal__c=strDealTGP1.id,Active__c=true);
        insert strWavePlanVersion1;
           
        Mob_RebaselineHighLevelPlan.cloneServiceManagement(strWavePlanVersion1.id,strWavePlanVersion1.id,2);
        Test.stopTest();
    }
    
    static testMethod void testcloneKTPlanning1()
    {
        Test.startTest();
        setupDataKTPlanning1();
        Mob_RebaselineHighLevelPlan.cloneKTPlanning(strWavePlanVersion.id,strWavePlanVersion.id,2);
        Test.stopTest();
    }
    static testMethod void testcloneKTPlanning2()
    {
        Test.startTest();
        setupDataKTPlanning2();
        Mob_RebaselineHighLevelPlan.cloneKTPlanning(strWavePlanVersion.id,strWavePlanVersion.id,2);
        Test.stopTest();
    }
    static testMethod void testcloneKTTracker()
    {
        Test.startTest();
        setupDataKTTracker();
        Mob_RebaselineHighLevelPlan.cloneKTTracker(strWavePlanVersion.id,strWavePlanVersion.id,2);
        Test.stopTest();
    }
    static testMethod void testcloneRecruitmentTracking()
    {
        Test.startTest();
        setupDataRecruitmentTracking();
        Mob_RebaselineHighLevelPlan.cloneRecruitmentTracking(strWavePlanVersion.id,strWavePlanVersion.id,2);
        Test.stopTest();
    }
    static testMethod void testcloneRecruitmentTracker()
    {
        Test.startTest();
        setupDataRecruitmentTracker();
        Mob_RebaselineHighLevelPlan.cloneRecruitmentTracker(strWavePlanVersion.id,strWavePlanVersion.id,2);
        Test.stopTest();
    }
    static testMethod void testcloneCommercialPlanning()
    {
        Test.startTest();
        setupDataCommercialPlanning();
        Mob_RebaselineHighLevelPlan.cloneCommercialPlanning(strWavePlanVersion.id,strWavePlanVersion.id,2);
        Test.stopTest();
    }
    static testMethod void testcloneContractLegalInfosec()
    {
        Test.startTest();
        setupDataContractLegalInfosec();
        Mob_RebaselineHighLevelPlan.cloneContractLegalInfosec(strWavePlanVersion.id,strWavePlanVersion.id,2);
        Test.stopTest();
    }
    static testMethod void testcloneTechAssessment()
    {
        Test.startTest();
        setupDataTechAssessment();
        Mob_RebaselineHighLevelPlan.cloneTechAssessment(strWavePlanVersion.id,strWavePlanVersion.id,2);
        Test.stopTest();
    }
    static testMethod void testcloneTechTracker()
    {
        Test.startTest();
        setupDataTechTracker();
        Mob_RebaselineHighLevelPlan.cloneTechTracker(strWavePlanVersion.id,strWavePlanVersion.id,2);
        Test.stopTest();
    }
    static testMethod void testcloneJourneyPlan()
    {
        Test.startTest();
        setupDataJourneyPlan();
        Mob_RebaselineHighLevelPlan.cloneJourneyPlan(strWavePlanVersion.id,strWavePlanVersion.id,2);
        Test.stopTest();
    }
    static testMethod void testcloneBCPPlan()
    {
        Test.startTest();
        setupDataBCPPlan();
        Mob_RebaselineHighLevelPlan.cloneBCPPlan(strWavePlanVersion.id,strWavePlanVersion.id,2);
        Test.stopTest();
    }
    static testMethod void testisWavePlanVersionActive()
    {
        Test.startTest();
        setupDataWPV();
        Mob_RebaselineHighLevelPlan.isWavePlanVersionActive(strWavePlanVersion.id);
        Test.stopTest();
    }
    static testMethod void testisAuthenticMobUser()
    {
        Test.startTest();

        setupDataWPV();
        Mob_RebaselineHighLevelPlan.isAuthenticMobUser(strWavePlanVersion.id);
  
        Test.stopTest();
    }
    static testMethod void testcloneSRAT()
    {
        Test.startTest();
        setupDataSRAT();
        //Mob_RebaselineHighLevelPlan.cloneSRAT(strWavePlanVersion.id,strWavePlanVersion.id,2);
        Test.stopTest();
    }
    
}