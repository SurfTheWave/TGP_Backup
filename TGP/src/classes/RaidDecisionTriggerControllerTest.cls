/**
     Author : Madhusudhan 
    Story  : Mob_R1.7_004 R17 Release
    Description : Test Class for RaidDecisionTriggerControllerTest

    Updated by        Story no.                Update Date        Update details
    ------------    -----------------        --------------    -------------------------------------------------------------

     */
@isTest(SeeAlldata= true)
private class RaidDecisionTriggerControllerTest {
    static Client_Specific_Process_Mapping__c clientSpecificProcessMapping;
    static Offerings_Master__c offering;
    static Wave_Plan_Version__c wavePlanVersion;
    static Deal_TGP__c deal;
    static Wave_Planning__c waveplan;
    static Wave_Process__c WaveProcess;
    static Deal_Location__c dealLoc;
    static Deal_Home_Location__c dealHome;
    static Delievery_Location_Master__c deliveryLocMa;
    static Client_Geo_Area_Master__c clientGeo;
    static Opportunity_TGP__c oppTGP;
    static Recruitment_Tracking__c RecruitmentTracking;
    static SRAT__c srat;
    static OPEX__c opex;
    static RAID_Risk__c riskRAID;
    static RAID_Action__c actionRAID;
    static RAID_Issue__c issueRAID;
    static RAID_Decision__c decisioRAID;
    static Deal_Location__c recruitmentRecord;
    static User testUser; 
    static Review_User_Master__c objReviewUser; 
    static Admin_level_acces__c adminLevelAccObj;
    static List<RAID_Decision__c> decisionRAIDList;
    static List<RAID_Decision__c> olddecisionRAIDList;
    private static User u;
    private static User u1;
    private static Profile p;
    private static Profile p1;
    private static string USER_NAME = 'vc12@testorg.com';

    public static void setupData(){
         p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        
        u =UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_NAME);
        Database.insert(u, false); 
              
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
        deal.Name='Tesing the Deal Data';
        insert deal;

        // To create a offering
        offering =new Offerings_Master__c();
        offering.Name='Test offering Data';
        insert offering;

        //To create a Wave Plan Version
        wavePlanVersion =new Wave_Plan_Version__c();
        wavePlanVersion.Display_tracking_message__c='Test wave plan version Data';
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

        // To Create Client Specific Process Mapping

        clientSpecificProcessMapping = new Client_Specific_Process_Mapping__c();
        clientSpecificProcessMapping.Name='TestData';
        clientSpecificProcessMapping.Deal__c=deal.id;
        clientSpecificProcessMapping.Offering__c=offering.id;
        insert clientSpecificProcessMapping;

        //To create a Wave Plan

        waveplan =new Wave_Planning__c();
        waveplan.Wave_Comment__c='test comment data';
        waveplan.Wave_Label__c='TestWavePlanData';
        waveplan.GO_Live_Date_del__c=date.today()+7;
        waveplan.Deal_Location__c=dealLoc.id;
        waveplan.Number_of_Projected_FTEs__c=10;
        insert waveplan; 

        // To create a Wave Process

        WaveProcess =new Wave_Process__c();
        WaveProcess.Wave_Planning__c=waveplan.id;
        WaveProcess.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
        WaveProcess.Number_of_Projected_FTEs__c=2;
        insert WaveProcess;


        srat= new SRAT__c();
        srat.Name='test';
        srat.Planned_Date__c=date.today();
        srat.Deal_Location_lk__c=dealLoc.id;
        srat.Wave_Plan_lk__c=waveplan.id;
        srat.Wave_Plan_Version__c=wavePlanVersion.id;
        insert srat;
/*
        opex =new OPEX__c();
        opex.Deal_Location_lk__c=dealLoc.id;
        opex.Wave_Plan_lk__c=waveplan.id;
        opex.Item__c='TestData';
        opex.Active__c=true;
        opex.Planned_Date__c=date.today();
        opex.Deal_Location__c='India';
        opex.Wave_Plan_Version__c=wavePlanVersion.id;
        insert opex; 

        recruitmentRecord =new Deal_Location__c();
        //recruitmentRecord.Wave_Plan_Version__r.deal__c=deal.id;
        recruitmentRecord.Wave_Plan_Version__c=wavePlanVersion.id;
        //recruitmentRecord.Location_Name__c='TestLocation';
        //recruitmentRecord.Wave_Plan_Version__r.deal__r.name='testDeal';
        //recruitmentRecord.Wave_Plan_Version__r.name='testWavePlanVersion';
        insert recruitmentRecord; */    

        riskRAID = new RAID_Risk__c ();
        riskRAID.Deal__c = deal.id;
        riskRAID.Title__c = 'TestTitle';
        riskRAID.Module_Name__c='SRAT';
        riskRAID.ModuleID__c=srat.id;
        riskRAID.Forum_Raised__c='Tactical /Program Level';
        riskRAID.Raised_at_level__c='High';
        riskRAID.Risk_Impact__c='High';
        riskRAID.Risk_Probability__c='High';
        riskRAID.Workstream_Area__c='High';
        riskRAID.Raised_by_Client_Accenture__c = 'test';
        riskRAID.Serial_Number__c='A-1';
        insert riskRAID;

        issueRAID= new RAID_Issue__c();
        issueRAID.Deal__c = deal.id;
        issueRAID.Title__c = 'TestTitle';
        issueRAID.Module_Name__c='SRAT';
        issueRAID.Module_ID__c=srat.id;
        issueRAID.Forum_Raised__c='Tactical /Program Level';
        issueRAID.Raised_at_level__c='High';
        issueRAID.Issue_Severity__c='Low';
        issueRAID.Workstream_Area__c='High';
        issueRAID.Raised_by_Client_Accenture__c='Accenture';
        issueRAID.Serial_Number__c='A-1';
        insert issueRAID;

        decisioRAID= new RAID_Decision__c();
        decisioRAID.Deal__c = deal.id;
        decisioRAID.Description__c= 'TestDecision';
        decisioRAID.Decision_Title__c='DecisionTitle1';
        decisioRAID.Module_Name__c='SRAT';
        decisioRAID.Module_ID__c=srat.id;
        decisioRAID.Forum_Raised__c='Tactical /Program Level';
        decisioRAID.Raised_at_level__c='High';
        decisioRAID.Workstream_Area__c='High';
        decisioRAID.Serial_Number__c='A-1';
        insert decisioRAID;
        decisionRAIDList=new List<RAID_Decision__c>();

        decisionRAIDList.add(decisioRAID);  
        /* decisioRAID.Description__c= 'TestDecision1';
        update decisioRAID; 
        olddecisionRAIDList.add(decisioRAID); */

        }
              
         static testMethod void test1(){
             setupData();
              test.starttest();
              
              RaidDecisionTriggerController raidac=new RaidDecisionTriggerController();
              raidac.updateRaidDecisionOnRaidRisk(decisionRAIDList,decisionRAIDList);
              test.stoptest();  
        }
        static testMethod void test2(){
              setupData();
              test.starttest();
              RaidDecisionTriggerController raidac=new RaidDecisionTriggerController();            
              raidac.updateRaidDecisionOnRaidIssue(decisionRAIDList,decisionRAIDList);
              test.stoptest();  
        }

}