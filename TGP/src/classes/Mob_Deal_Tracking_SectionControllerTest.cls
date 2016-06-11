/*
Author : Varsha Chougule.
Story  : MOB_128  
Description : Test class for Mob_Deal_Tracking_SectionController 

Updated by        Story no./Defect No.           Update Date        Update details
------------    -----------------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class Mob_Deal_Tracking_SectionControllerTest
{
    static User testUser; 
    static Wave_Plan_Version__c wavePlanVersion;
    static Deal_TGP__c deal;
    static User testUser1;
    static Deal_Location__c dealLocation;
    static Client_Specific_Process_Mapping__c clientSpecificProcessMapping;
    static Offerings_Master__c offering;
    static Wave_Planning__c waveplan;
    static Wave_Process__c WaveProcess;
    static Deal_Location__c dealLoc;
    static Deal_Home_Location__c dealHome;
    static Delievery_Location_Master__c deliveryLocMa;
    static Client_Geo_Area_Master__c clientGeo;
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
    static Recruitment_Tracker__c recTracker;
    static Tracking_Recruitment__c trackRecruitment;
    static Tech_Tracker__c techTrack;
    static Tracking_Tech_Assessment__c trackTech ;
    
    public static void setupData()
    {
        deal=new Deal_TGP__c(Name='DealTest123');
        insert deal;

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

        // To create a offering
        offering =new Offerings_Master__c();
        offering.Name='Test offering Data';
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
        dealLoc.Location__c='test  Data';
        dealLoc.Deal_Home_Location__c=dealHome.id;
        dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
        insert dealLoc;

    } 
    
    public static void setupDataForWave()
    {
        //To create a Wave Plan
        waveplan =new Wave_Planning__c();
        waveplan.Wave_Comment__c='test comment data';
        waveplan.Wave_Label__c='TestWavePlanData';
        waveplan.GO_Live_Date_del__c=date.today()+7;
        waveplan.Deal_Location__c=dealLoc.id;
        waveplan.Number_of_Projected_FTEs__c=1;
        insert waveplan; 
    }
    public static void setupdataForRT()
    {        
        Activity_Master__c act = new Activity_Master__c(name='act1',Activity_Order__c=20);
        insert act;

        setupDataForWave();
        
        strRecruitmentTracking=new Recruitment_Tracking__c(Name='TestRecruitment',Activity_Order__c=25, Planned_Start_Date__c=System.today()+1, Planned_End_Date__c=System.today()+2,
        Deal_Location_lk__c=dealLoc.id, Wave_Plan_lk__c=waveplan.id, FTE_Number__c=10, Activity__c='TestActivity', Wave_Plan_Version__c=wavePlanVersion.id,Activity_Master_ID__c=act.id);
        insert strRecruitmentTracking;  
    }
    public static void setupDataForTA()  
    {      
        Tech_Assessment_Activity_Master__c actT = new Tech_Assessment_Activity_Master__c(name='act1',Activity_Order__c=30);
        insert actT;
        
        setupDataForWave();
        
        List<Recruitment_Tracking__c> tempLstRT=[select id from Recruitment_Tracking__c  where Wave_Plan_Version__c=:wavePlanVersion.id];
        if(tempLstRT.size()>0)
        {
            delete tempLstRT;
        }    
    }
    public static void setupDataForKT()
    {
        List<KT_Planning_Activity_Master__c> lst = new List<KT_Planning_Activity_Master__c>();
        KT_Planning_Activity_Master__c ktAct = new KT_Planning_Activity_Master__c(Name='kt1_1',Activity_Order__c=50);
        insert ktAct;

        setupDataForWave();
        
        List<Recruitment_Tracking__c> tempLstRT=[select id from Recruitment_Tracking__c  where Wave_Plan_Version__c=:wavePlanVersion.id];
        if(tempLstRT.size()>0)
        {
            delete tempLstRT;
        } 
        List<Tech_Assessment__c > tempLstTA=[select id from Tech_Assessment__c where Wave_Plan_Version__c=:wavePlanVersion.id];
        if(tempLstTA.size()>0)
        {
            delete tempLstTA;
        } 
    }
    public static void setupDataForJM() 
    {       
        Journey_Management__c jManagaement=new Journey_Management__c (Section_Name__c='TestKT', Section_Number__c='999');
        insert jManagaement; 
        Journey_Management_Deliverable__c delivery = new Journey_Management_Deliverable__c(Deliverable_Name__c='del1',Deliverable_Number__c='1',Journey_Management__c=jManagaement.id);     
        insert delivery;

        Journey_Management_Planning__c jManagaementPlanning=new Journey_Management_Planning__c  (Section_Name__c='TestKT', Section_Number__c='999', Journey_Management_Deliverable_ID__c= delivery.id);
        insert jManagaementPlanning;      
    }
    public static void setupDataForBCP()
    {        
        BCP_Section_Master__c sectionB = new BCP_Section_Master__c();
        sectionB.Section_Name__c='bcp1';
        sectionB.Section_Number__c='10';
        insert sectionB;
        
        BCP_Task_Master__c taskB = new BCP_Task_Master__c();
        taskB.Business_Continuity_Planning_del__c=sectionB.id;
        taskB.Task_Name__c='task1';
        taskB.Task_Number__c=10;
        insert taskB;

        List<Journey_Management_Planning__c > tempLstJM=[select id from Journey_Management_Planning__c where Wave_Plan_Version__c=:wavePlanVersion.id];
        if(tempLstJM.size()>0)
        {
            delete tempLstJM;
        }  
    }
    public static void setupDataSM()
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
        insert serManTa;
        
        List<Journey_Management_Planning__c > tempLstJM=[select id from Journey_Management_Planning__c where Wave_Plan_Version__c=:wavePlanVersion.id];
        if(tempLstJM.size()>0)
        {
            delete tempLstJM;
        }  
        List<Business_Continuity_Planning__c > tempLstBCP=[select id from Business_Continuity_Planning__c where Wave_Plan_Version__c=:wavePlanVersion.id];
        if(tempLstBCP.size()>0)
        {
            delete tempLstBCP;
        }    
    }
    public static void setupDataForCP()
    {        
        Commercial_Plan_Activity_Master__c actC = new Commercial_Plan_Activity_Master__c(Activity_Name__c='act',Activity_Order__c=20);
        insert actC;
 
        strCommercialPlanning=new Commercial_Planning__c (Name='TestKT',Activity_Order__c=15, Planned_Start_Date__c=System.today()+1, Planned_End_Date__c=System.today()+2, 
        Activity__c='TestActivity', Wave_Plan_Version__c=wavePlanVersion.id,Commercial_Plan_Activity_Master_Id__c=actC.id);
        insert strCommercialPlanning; 
        
        List<Journey_Management_Planning__c > tempLstJM=[select id from Journey_Management_Planning__c where Wave_Plan_Version__c=:wavePlanVersion.id];
        if(tempLstJM.size()>0)
        {
            delete tempLstJM;
        }  
        List<Business_Continuity_Planning__c > tempLstBCP=[select id from Business_Continuity_Planning__c where Wave_Plan_Version__c=:wavePlanVersion.id];
        if(tempLstBCP.size()>0)
        {
            delete tempLstBCP;
        } 
        List<Service_Management__c > tempLstSM=[select id from Service_Management__c where Wave_Plan_Version__c=:wavePlanVersion.id];
        if(tempLstSM.size()>0)
        {
            delete tempLstSM;
        } 
    }

    public static void setupDataForCLI()
    {        
        Contract_Legal_Infosec_Section_Master__c sectionC = new Contract_Legal_Infosec_Section_Master__c(Section_Name__c='sec',Section_Number__c='12');
        insert sectionC;
        Contract_Legal_Infosec_Task_Master__c taskC = new Contract_Legal_Infosec_Task_Master__c(Contract_Legal_Infosec_Section_Master__c=sectionC.id,Task_Name__c='task1',Task_Number__c='12');
        insert taskC;
        
        List<Journey_Management_Planning__c > tempLstJM=[select id from Journey_Management_Planning__c where Wave_Plan_Version__c=:wavePlanVersion.id];
        if(tempLstJM.size()>0)
        {
            delete tempLstJM;
        }  
        List<Business_Continuity_Planning__c > tempLstBCP=[select id from Business_Continuity_Planning__c where Wave_Plan_Version__c=:wavePlanVersion.id];
        if(tempLstBCP.size()>0)
        {
            delete tempLstBCP;
        } 
        List<Service_Management__c > tempLstSM=[select id from Service_Management__c where Wave_Plan_Version__c=:wavePlanVersion.id];
        if(tempLstSM.size()>0)
        {
            delete tempLstSM;
        } 
        List<Commercial_Planning__c > tempLstCP=[select id from Commercial_Planning__c where Wave_Plan_Version__c=:wavePlanVersion.id];
        if(tempLstCP.size()>0)
        {
            delete tempLstcp;
        }  
    }
 
    static testMethod void test1()
    {
        test.starttest();
        setupdata();
        setupDataForRT();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef = Page.MOB_DealClientSpecificProcess;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.Id);
        Apexpages.currentpage().getparameters().put('pageId' ,wavePlanVersion.Id);
        Mob_Deal_Tracking_SectionController obj = new Mob_Deal_Tracking_SectionController(controller);
        obj.InitiateTracking();
        obj.checkBoxValue=true;
        obj.ButtonEnable();
        obj.checkBoxValue=false;
        obj.ButtonEnable();
        obj.getDealtrack();
        obj.checkBoxValue=true;
        obj.InitiateTracking();
        obj.ButtonEnable();
        obj.getDealtrack();
        test.stoptest();
     }
     static testMethod void test2()
    {
        test.starttest();
        setupdata();
        setupDataForTA();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef = Page.MOB_DealClientSpecificProcess;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.Id);
        Apexpages.currentpage().getparameters().put('pageId' ,wavePlanVersion.Id);
        Mob_Deal_Tracking_SectionController obj = new Mob_Deal_Tracking_SectionController(controller);
        obj.InitiateTracking();
        obj.checkBoxValue=true;
        obj.ButtonEnable();
        obj.checkBoxValue=false;
        obj.ButtonEnable();
        obj.getDealtrack();
        obj.checkBoxValue=true;
        obj.InitiateTracking();
        obj.ButtonEnable();
        obj.getDealtrack();
        test.stoptest();
     } 
    static testMethod void test3()
    {
        test.starttest();
        setupdata();
        setupDataForKT();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef = Page.MOB_DealClientSpecificProcess;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.Id);
        Apexpages.currentpage().getparameters().put('pageId' ,wavePlanVersion.Id);
        Mob_Deal_Tracking_SectionController obj = new Mob_Deal_Tracking_SectionController(controller);
        obj.InitiateTracking();
        obj.checkBoxValue=true;
        obj.ButtonEnable();
        obj.checkBoxValue=false;
        obj.ButtonEnable();
        obj.getDealtrack();
        obj.checkBoxValue=true;
        obj.InitiateTracking();
        obj.ButtonEnable();
        obj.getDealtrack();
        test.stoptest();
     } 
     static testMethod void test4()
    {
        test.starttest();
        setupdata();
        setupDataForJM();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef = Page.MOB_DealClientSpecificProcess;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.Id);
        Apexpages.currentpage().getparameters().put('pageId' ,wavePlanVersion.Id);
        Mob_Deal_Tracking_SectionController obj = new Mob_Deal_Tracking_SectionController(controller);
        obj.InitiateTracking();
        obj.checkBoxValue=true;
        obj.ButtonEnable();
        obj.checkBoxValue=false;
        obj.ButtonEnable();
        obj.getDealtrack();
        obj.checkBoxValue=true;
        obj.InitiateTracking();
        obj.ButtonEnable();
        obj.getDealtrack();
        test.stoptest();
     }
     static testMethod void test5()
    {
        test.starttest();
        setupdata();
        setupDataForBCP();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef = Page.MOB_DealClientSpecificProcess;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.Id);
        Apexpages.currentpage().getparameters().put('pageId' ,wavePlanVersion.Id);
        Mob_Deal_Tracking_SectionController obj = new Mob_Deal_Tracking_SectionController(controller);
        obj.InitiateTracking();
        obj.checkBoxValue=true;
        obj.ButtonEnable();
        obj.checkBoxValue=false;
        obj.ButtonEnable();
        obj.getDealtrack();
        obj.checkBoxValue=true;
        obj.InitiateTracking();
        obj.ButtonEnable();
        obj.getDealtrack();
        test.stoptest();
     }
     static testMethod void test6()
    {
        test.starttest();
        setupdata();
        setupDataSM();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef = Page.MOB_DealClientSpecificProcess;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.Id);
        Apexpages.currentpage().getparameters().put('pageId' ,wavePlanVersion.Id);
        Mob_Deal_Tracking_SectionController obj = new Mob_Deal_Tracking_SectionController(controller);
        obj.InitiateTracking();
        obj.checkBoxValue=true;
        obj.ButtonEnable();
        obj.checkBoxValue=false;
        obj.ButtonEnable();
        obj.getDealtrack();
        obj.checkBoxValue=true;
        obj.InitiateTracking();
        obj.ButtonEnable();
        obj.getDealtrack();
        test.stoptest();
     }
     static testMethod void test7()
    {
        test.starttest();
        setupdata();
        setupDataForCP();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef = Page.MOB_DealClientSpecificProcess;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.Id);
        Apexpages.currentpage().getparameters().put('pageId' ,wavePlanVersion.Id);
        Mob_Deal_Tracking_SectionController obj = new Mob_Deal_Tracking_SectionController(controller);
        obj.InitiateTracking();
        obj.checkBoxValue=true;
        obj.ButtonEnable();
        obj.checkBoxValue=false;
        obj.ButtonEnable();
        obj.getDealtrack();
        obj.checkBoxValue=true;
        obj.InitiateTracking();
        obj.ButtonEnable();
        obj.getDealtrack();
        test.stoptest();
     }
     static testMethod void test8()
    {
        test.starttest();
        setupdata();
        setupDataForCLI();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        PageReference pageRef = Page.MOB_DealClientSpecificProcess;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.Id);
        Apexpages.currentpage().getparameters().put('pageId' ,wavePlanVersion.Id);
        Mob_Deal_Tracking_SectionController obj = new Mob_Deal_Tracking_SectionController(controller);
        obj.InitiateTracking();
        obj.checkBoxValue=true;
        obj.ButtonEnable();
        obj.checkBoxValue=false;
        obj.ButtonEnable();
        obj.getDealtrack();
        obj.checkBoxValue=true;
        obj.InitiateTracking();
        obj.ButtonEnable();
        obj.getDealtrack();
        test.stoptest();
     }
 }