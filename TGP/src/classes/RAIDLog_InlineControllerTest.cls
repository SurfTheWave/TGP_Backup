/*
Author : Shridhar Patankar
Story  :  MOB_029, MOB_030, MOB_031, MOB_032
Description : Test Class for RAIDLog_InlineController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class RAIDLog_InlineControllerTest{
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

public static void setupDataNew(){

       Profile p = UTIL_DataCreationForTestClass.getProfile('System Administrator');
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        insert testUser;
      
            objReviewUser= new Review_User_Master__c();
            objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email; 
            objReviewUser.Name='reviewUaser1'; 
            objReviewUser.Is_Active__c=true; 
            objReviewUser.SFDC_User__c = testUser.Id; 
            insert objReviewUser;   

adminLevelAccObj = new Admin_level_acces__c();
adminLevelAccObj.Name = 'System Administrator';
adminLevelAccObj.Profile_name__c = 'System Administrator';
insert adminLevelAccObj;
      
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
insert recruitmentRecord; 

RAID_Risk__c riskRAID1 = new RAID_Risk__c ();
riskRAID1.Deal__c = deal.id;
riskRAID1.Title__c = 'TestTitle';
riskRAID1.Module_Name__c='SRAT';
riskRAID1.ModuleID__c=srat.id;
riskRAID1.Forum_Raised__c='Tactical /Program Level';
riskRAID1.Raised_at_level__c='High';
riskRAID1.Risk_Impact__c='High';
riskRAID1.Risk_Probability__c='High';
riskRAID1.Workstream_Area__c='High';
riskRAID1.Raised_by_Client_Accenture__c = 'test';
riskRAID1.Primary_Owner_New__c=objReviewUser.id;
insert riskRAID1;


}



public static void setupData(){

       Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        insert testUser;
        
        adminLevelAccObj = new Admin_level_acces__c();
adminLevelAccObj.Name = 'System Administrator';
adminLevelAccObj.Profile_name__c = 'System Administrator';
insert adminLevelAccObj;
      
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
insert recruitmentRecord; 

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
  
actionRAID= new RAID_Action__c ();
actionRAID.Deal__c = deal.id;
actionRAID.Module_Name__c='SRAT';
actionRAID.Module_ID__c=srat.id;
actionRAID.Forum_Raised__c='Tactical /Program Level';
actionRAID.Raised_at_level__c='High';
actionRAID.Workstream_Area__c='High';
actionRAID.Action_Title__c='ActionTitle';
actionRAID.Raised_by_Client_Accenture__c='Accenture';
actionRAID.Action_Title__c='testActionTitle';
actionRAID.Serial_Number__c='A-1';
insert actionRAID;

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
decisioRAID.Module_Name__c='SRAT';
decisioRAID.Module_ID__c=srat.id;
decisioRAID.Forum_Raised__c='Tactical /Program Level';
decisioRAID.Decision_Title__c='testDecisionTitle';
decisioRAID.Raised_at_level__c='High';
decisioRAID.Workstream_Area__c='High';
decisioRAID.Serial_Number__c='A-1';
insert decisioRAID;
      
}
public static void setupData1(){

 adminLevelAccObj = new Admin_level_acces__c();
adminLevelAccObj.Name = 'System Administrator';
adminLevelAccObj.Profile_name__c = 'System Administrator';
insert adminLevelAccObj;
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

opex =new OPEX__c();
opex.Deal_Location_lk__c=dealLoc.id;
opex.Wave_Plan_lk__c=waveplan.id;
opex.Item__c='TestData';
opex.Active__c=true;
opex.Planned_Date__c=date.today();
opex.Deal_Location__c='India';

opex.Wave_Plan_Version__c=wavePlanVersion.id;
insert opex; 

riskRAID = new RAID_Risk__c ();
riskRAID.Deal__c = deal.id;
riskRAID.Title__c = 'Test Title';
riskRAID.Module_Name__c='OPEX';
riskRAID.ModuleID__c=opex.id;
riskRAID.Forum_Raised__c='Tactical /Program Level';
riskRAID.Raised_at_level__c='High';
riskRAID.Risk_Impact__c='High';
riskRAID.Risk_Probability__c='High';
riskRAID.Workstream_Area__c='High';
riskRAID.Raised_by_Client_Accenture__c = 'test';
riskRAID.Serial_Number__c='A-1';
insert riskRAID;
  
actionRAID= new RAID_Action__c ();
actionRAID.Deal__c = deal.id;
actionRAID.Module_Name__c='OPEX';
actionRAID.Module_ID__c=opex.id;
actionRAID.Forum_Raised__c='Tactical /Program Level';
actionRAID.Raised_at_level__c='High';

actionRAID.Action_Title__c='ActionTitle';
actionRAID.Raised_by_Client_Accenture__c='Accenture';
actionRAID.Workstream_Area__c='High';
actionRAID.Serial_Number__c='A-1';
insert actionRAID;

issueRAID= new RAID_Issue__c();
issueRAID.Deal__c = deal.id;
issueRAID.Title__c = 'TestTitle';
issueRAID.Module_Name__c='OPEX';
issueRAID.Module_ID__c=opex.id;
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
decisioRAID.Module_Name__c='OPEX';
decisioRAID.Module_ID__c=opex.id;
decisioRAID.Decision_Title__c='testDecisionTitle';
decisioRAID.Forum_Raised__c='Tactical /Program Level';
decisioRAID.Raised_at_level__c='High';
decisioRAID.Workstream_Area__c='High';
insert decisioRAID;
      
}
public static void setupData2(){
    
    
    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        insert testUser;
      
            objReviewUser= new Review_User_Master__c();
            objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email; 
            objReviewUser.Name='reviewUaser1'; 
            objReviewUser.Is_Active__c=true; 
            objReviewUser.SFDC_User__c = testUser.Id; 
            insert objReviewUser;   
            
             adminLevelAccObj = new Admin_level_acces__c();
adminLevelAccObj.Name = 'System Administrator';
adminLevelAccObj.Profile_name__c = 'System Administrator';
insert adminLevelAccObj;
            
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

opex =new OPEX__c();
opex.Deal_Location_lk__c=dealLoc.id;
opex.Wave_Plan_lk__c=waveplan.id;
opex.Item__c='TestData';
opex.Active__c=true;
opex.Planned_Date__c=date.today();
opex.Deal_Location__c='India';

opex.Wave_Plan_Version__c=wavePlanVersion.id;
insert opex; 

riskRAID = new RAID_Risk__c ();
riskRAID.Deal__c = deal.id;
riskRAID.Title__c = 'TestTitle';
riskRAID.Module_Name__c='Deal';
riskRAID.ModuleID__c=deal.id;
riskRAID.Forum_Raised__c= 'Tactical /Program Level';
riskRAID.Raised_at_level__c='High';
riskRAID.Risk_Impact__c='High';
riskRAID.Risk_Probability__c='High';
riskRAID.Workstream_Area__c='High';
riskRAID.Raised_by_Client_Accenture__c = 'Accenture';
riskRAID.Serial_Number__c='A-1';
riskRAID.Decision_Reference_ID__c = null;
riskRAID.Action_Reference_ID__c = null;
insert riskRAID;
  
actionRAID= new RAID_Action__c ();
actionRAID.Deal__c = deal.id;
actionRAID.Module_Name__c='Deal';
actionRAID.Module_ID__c=deal.id;
actionRAID.Forum_Raised__c='Tactical /Program Level';
actionRAID.Serial_Number__c='A-1';
actionRAID.Raised_at_level__c='High';

actionRAID.Action_Title__c='ActionTitle';
actionRAID.Raised_by_Client_Accenture__c='Accenture';
actionRAID.Workstream_Area__c='High';
insert actionRAID;

issueRAID= new RAID_Issue__c();
issueRAID.Deal__c = deal.id;
issueRAID.Title__c = 'TestTitle';
issueRAID.Module_Name__c='Deal';
issueRAID.Module_ID__c=deal.id;
issueRAID.Forum_Raised__c='Tactical /Program Level';
issueRAID.Raised_at_level__c='High';
issueRAID.Issue_Severity__c='Low';
issueRAID.Workstream_Area__c='High';
issueRAID.Raised_by_Client_Accenture__c='Accenture';
issueRAID.Serial_Number__c='A-1';
insert issueRAID;

/*decisioRAID= new RAID_Decision__c();
decisioRAID.Deal__c = deal.id;
decisioRAID.Description__c= 'TestDecision';
decisioRAID.Module_Name__c='Deal';
decisioRAID.Module_ID__c=deal.id;
decisioRAID.Forum_Raised__c='Tactical /Program Level';
decisioRAID.Raised_at_level__c='High';
decisioRAID.Workstream_Area__c='High';
insert decisioRAID;*/
      
}
public static void setupData3(){

 adminLevelAccObj = new Admin_level_acces__c();
adminLevelAccObj.Name = 'System Administrator';
adminLevelAccObj.Profile_name__c = 'System Administrator';
insert adminLevelAccObj;
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

opex =new OPEX__c();
opex.Deal_Location_lk__c=dealLoc.id;
opex.Wave_Plan_lk__c=waveplan.id;
opex.Item__c='TestData';
opex.Active__c=true;
opex.Planned_Date__c=date.today();
opex.Deal_Location__c='India';

opex.Wave_Plan_Version__c=wavePlanVersion.id;
insert opex; 

riskRAID = new RAID_Risk__c ();
riskRAID.Deal__c = deal.id;
riskRAID.Title__c = 'TestTitle';
riskRAID.Module_Name__c='WavePlanVersion';
riskRAID.ModuleID__c=wavePlanVersion.id;
riskRAID.Forum_Raised__c='Tactical /Program Level';
riskRAID.Raised_at_level__c='High';
riskRAID.Risk_Impact__c='High';
riskRAID.Risk_Probability__c='High';
riskRAID.Workstream_Area__c= 'High';
riskRAID.Raised_by_Client_Accenture__c = 'test';
insert riskRAID;
  
actionRAID= new RAID_Action__c ();
actionRAID.Deal__c = deal.id;
actionRAID.Module_Name__c='WavePlanVersion';
actionRAID.Module_ID__c=wavePlanVersion.id;
actionRAID.Forum_Raised__c='Tactical /Program Level';
actionRAID.Raised_at_level__c='High';
actionRAID.Raised_by_Client_Accenture__c='Accenture';

actionRAID.Action_Title__c='ActionTitle';
actionRAID.Workstream_Area__c='High';
insert actionRAID;

/*issueRAID= new RAID_Issue__c();
issueRAID.Deal__c = deal.id;
issueRAID.Title__c = 'TestTitle';
issueRAID.Module_Name__c='WavePlanVersion';
issueRAID.Module_ID__c=wavePlanVersion.id;
issueRAID.Forum_Raised__c='Tactical /Program Level';
issueRAID.Raised_at_level__c='High';
issueRAID.Issue_Severity__c='Low';
issueRAID.Workstream_Area__c='High';
insert issueRAID;

decisioRAID= new RAID_Decision__c();
decisioRAID.Deal__c = deal.id;
decisioRAID.Description__c= 'TestDecision';
decisioRAID.Module_Name__c='WavePlanVersion';
decisioRAID.Module_ID__c=wavePlanVersion.id;
decisioRAID.Forum_Raised__c='Tactical /Program Level';
decisioRAID.Raised_at_level__c='High';
decisioRAID.Workstream_Area__c='High';
insert decisioRAID;*/
      
}
public static void setupData4(){

 adminLevelAccObj = new Admin_level_acces__c();
adminLevelAccObj.Name = 'System Administrator';
adminLevelAccObj.Profile_name__c = 'System Administrator';
insert adminLevelAccObj;
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

opex =new OPEX__c();
opex.Deal_Location_lk__c=dealLoc.id;
opex.Wave_Plan_lk__c=waveplan.id;
opex.Item__c='TestData';
opex.Active__c=true;
opex.Planned_Date__c=date.today();
opex.Deal_Location__c='India';

opex.Wave_Plan_Version__c=wavePlanVersion.id;
insert opex; 

riskRAID = new RAID_Risk__c ();
riskRAID.Deal__c = deal.id;
riskRAID.Title__c = 'TestTitle';
riskRAID.Module_Name__c='DealLocation';
riskRAID.ModuleID__c=dealLoc.id;
riskRAID.Forum_Raised__c='Tactical /Program Level';
riskRAID.Raised_at_level__c='High';
riskRAID.Risk_Impact__c='High';
riskRAID.Risk_Probability__c='High';
riskRAID.Workstream_Area__c='High';
riskRAID.Raised_by_Client_Accenture__c = 'test';
insert riskRAID;
  
actionRAID= new RAID_Action__c ();
actionRAID.Deal__c = deal.id;
actionRAID.Module_Name__c='DealLocation';
actionRAID.Module_ID__c=dealLoc.id;
actionRAID.Forum_Raised__c='Tactical /Program Level';
actionRAID.Raised_at_level__c='High';

actionRAID.Action_Title__c='ActionTitle';
actionRAID.Raised_by_Client_Accenture__c='Accenture';
actionRAID.Workstream_Area__c='High';
insert actionRAID;

/*issueRAID= new RAID_Issue__c();
issueRAID.Deal__c = deal.id;
issueRAID.Title__c = 'TestTitle';
issueRAID.Module_Name__c='DealLocation';
issueRAID.Module_ID__c=dealLoc.id;
issueRAID.Forum_Raised__c='Tactical /Program Level';
issueRAID.Raised_at_level__c='High';
issueRAID.Issue_Severity__c='Low';
issueRAID.Workstream_Area__c='High';
insert issueRAID;

decisioRAID= new RAID_Decision__c();
decisioRAID.Deal__c = deal.id;
decisioRAID.Description__c= 'TestDecision';
decisioRAID.Module_Name__c='DealLocation';
decisioRAID.Module_ID__c=dealLoc.id;
decisioRAID.Forum_Raised__c='Tactical /Program Level';
decisioRAID.Raised_at_level__c='High';
decisioRAID.Workstream_Area__c='High';
insert decisioRAID;*/
      
}
public static void setupData5(){

 adminLevelAccObj = new Admin_level_acces__c();
adminLevelAccObj.Name = 'System Administrator';
adminLevelAccObj.Profile_name__c = 'System Administrator';
insert adminLevelAccObj;
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

opex =new OPEX__c();
opex.Deal_Location_lk__c=dealLoc.id;
opex.Wave_Plan_lk__c=waveplan.id;
opex.Item__c='TestData';
opex.Active__c=true;
opex.Planned_Date__c=date.today();
opex.Deal_Location__c='India';

opex.Wave_Plan_Version__c=wavePlanVersion.id;
insert opex; 

riskRAID = new RAID_Risk__c ();
riskRAID.Deal__c = deal.id;
riskRAID.Title__c = 'TestTitle';
riskRAID.Module_Name__c='DealWave';
riskRAID.ModuleID__c=waveplan.id;
riskRAID.Forum_Raised__c='Tactical /Program Level';
riskRAID.Raised_at_level__c='High';
riskRAID.Risk_Impact__c='High';
riskRAID.Risk_Probability__c='Low';
riskRAID.Workstream_Area__c='High';
riskRAID.Raised_by_Client_Accenture__c = 'test';
insert riskRAID;
  
actionRAID= new RAID_Action__c ();
actionRAID.Deal__c = deal.id;
actionRAID.Module_Name__c='DealWave';
actionRAID.Module_ID__c=waveplan.id;
actionRAID.Forum_Raised__c='Tactical /Program Level';
actionRAID.Raised_at_level__c='High';

actionRAID.Action_Title__c='ActionTitle';
actionRAID.Raised_by_Client_Accenture__c='Accenture';
actionRAID.Workstream_Area__c='High';

insert actionRAID;

/*issueRAID= new RAID_Issue__c();
issueRAID.Deal__c = deal.id;
issueRAID.Title__c = 'TestTitle';
issueRAID.Module_Name__c='DealWave';
issueRAID.Module_ID__c=waveplan.id;
issueRAID.Forum_Raised__c='Tactical /Program Level';
issueRAID.Raised_at_level__c='High';
issueRAID.Issue_Severity__c='Low';  
issueRAID.Workstream_Area__c='High';
insert issueRAID;

decisioRAID= new RAID_Decision__c();
decisioRAID.Deal__c = deal.id;
decisioRAID.Description__c= 'TestDecision';
decisioRAID.Module_Name__c='DealWave';
decisioRAID.Module_ID__c=waveplan.id;
decisioRAID.Forum_Raised__c='Tactical /Program Level';
decisioRAID.Raised_at_level__c='High';
decisioRAID.Workstream_Area__c='High';
insert decisioRAID;*/
      
}
public static void setupData6(){

 adminLevelAccObj = new Admin_level_acces__c();
adminLevelAccObj.Name = 'System Administrator';
adminLevelAccObj.Profile_name__c = 'System Administrator';
insert adminLevelAccObj;
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

opex =new OPEX__c();
opex.Deal_Location_lk__c=dealLoc.id;
opex.Wave_Plan_lk__c=waveplan.id;
opex.Item__c='TestData';
opex.Active__c=true;
opex.Planned_Date__c=date.today();
opex.Deal_Location__c='India';

opex.Wave_Plan_Version__c=wavePlanVersion.id;
insert opex; 

riskRAID = new RAID_Risk__c ();
riskRAID.Deal__c = deal.id;
riskRAID.Title__c = 'TestTitle';
riskRAID.Module_Name__c='DealHomeLocation';
riskRAID.ModuleID__c=dealHome.id;
riskRAID.Forum_Raised__c='Tactical /Program Level';
riskRAID.Raised_at_level__c='High';
riskRAID.Risk_Impact__c='Low';
riskRAID.Risk_Probability__c='High';
riskRAID.Workstream_Area__c='High';
riskRAID.Raised_by_Client_Accenture__c = 'test';
insert riskRAID;
  
actionRAID= new RAID_Action__c ();
actionRAID.Deal__c = deal.id;
actionRAID.Module_Name__c='DealHomeLocation';
actionRAID.Module_ID__c=dealHome.id;
actionRAID.Forum_Raised__c='Tactical /Program Level';
actionRAID.Raised_at_level__c='High';

actionRAID.Action_Title__c='ActionTitle';
actionRAID.Raised_by_Client_Accenture__c='Accenture';
actionRAID.Workstream_Area__c='High';
insert actionRAID;

/*issueRAID= new RAID_Issue__c();
issueRAID.Deal__c = deal.id;
issueRAID.Title__c = 'TestTitle';
issueRAID.Module_Name__c='DealHomeLocation';
issueRAID.Module_ID__c=dealHome.id;
issueRAID.Forum_Raised__c='Tactical /Program Level';
issueRAID.Raised_at_level__c='High';
issueRAID.Issue_Severity__c='Low';
issueRAID.Workstream_Area__c='High';
insert issueRAID;

decisioRAID= new RAID_Decision__c();
decisioRAID.Deal__c = deal.id;
decisioRAID.Description__c= 'TestDecision';
decisioRAID.Module_Name__c='DealHomeLocation';
decisioRAID.Module_ID__c=dealHome.id;
decisioRAID.Forum_Raised__c='Tactical /Program Level';
decisioRAID.Raised_at_level__c='High';
decisioRAID.Workstream_Area__c='High';
insert decisioRAID;*/
      
}
public static void setupData7(){

 adminLevelAccObj = new Admin_level_acces__c();
adminLevelAccObj.Name = 'System Administrator';
adminLevelAccObj.Profile_name__c = 'System Administrator';
insert adminLevelAccObj;
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

List<Deal_Location__c> recruitmentRec=[Select id, Wave_Plan_Version__r.deal__c, Wave_Plan_Version__c,Location_Name__c, 
                                                      Wave_Plan_Version__r.deal__r.name,Wave_Plan_Version__r.name
                                                     from Deal_Location__c where id=: dealLoc.id]; 
                                                     

System.debug('-------recruitmentRec.size()--- '+recruitmentRec.size());
                                                     
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

opex =new OPEX__c();
opex.Deal_Location_lk__c=dealLoc.id;
opex.Wave_Plan_lk__c=waveplan.id;
opex.Item__c='TestData';
opex.Active__c=true;
opex.Planned_Date__c=date.today();
opex.Deal_Location__c='India';

opex.Wave_Plan_Version__c=wavePlanVersion.id;
insert opex; 

riskRAID = new RAID_Risk__c ();
riskRAID.Deal__c = deal.id;
riskRAID.Title__c = 'TestTitle';
riskRAID.Module_Name__c='RECRUITMENT';
riskRAID.ModuleID__c=dealLoc.id;
riskRAID.Forum_Raised__c='Tactical /Program Level';
riskRAID.Raised_at_level__c='High';
riskRAID.Risk_Impact__c='High';
riskRAID.Risk_Probability__c='High';
riskRAID.Workstream_Area__c='High';
riskRAID.Raised_by_Client_Accenture__c = 'test';
insert riskRAID;
  
actionRAID= new RAID_Action__c ();
actionRAID.Deal__c = deal.id;
actionRAID.Module_Name__c='RECRUITMENT';
actionRAID.Module_ID__c=dealLoc.id;
actionRAID.Forum_Raised__c='Tactical /Program Level';
actionRAID.Raised_at_level__c='High';
actionRAID.Raised_by_Client_Accenture__c='Accenture';

actionRAID.Action_Title__c='ActionTitle';
actionRAID.Workstream_Area__c='High';
insert actionRAID;

issueRAID= new RAID_Issue__c();
issueRAID.Deal__c = deal.id;
issueRAID.Title__c = 'TestTitle';
issueRAID.Module_Name__c='RECRUITMENT';
issueRAID.Module_ID__c=dealHome.id;
issueRAID.Forum_Raised__c='Tactical /Program Level';
issueRAID.Raised_at_level__c='High';
issueRAID.Issue_Severity__c='Low';
issueRAID.Workstream_Area__c='High';
insert issueRAID;

decisioRAID= new RAID_Decision__c();
decisioRAID.Deal__c = deal.id;
decisioRAID.Description__c= 'TestDecision';
decisioRAID.Module_Name__c='RECRUITMENT';
decisioRAID.Module_ID__c=dealHome.id;
decisioRAID.Forum_Raised__c='Tactical /Program Level';
decisioRAID.Raised_at_level__c='High';
decisioRAID.Workstream_Area__c='High';
insert decisioRAID;
      
}

public static void setupData8(){

 adminLevelAccObj = new Admin_level_acces__c();
adminLevelAccObj.Name = 'System Administrator';
adminLevelAccObj.Profile_name__c = 'System Administrator';
insert adminLevelAccObj;
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
wavePlanVersion.name='test wave plan version';
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

opex =new OPEX__c();
opex.Deal_Location_lk__c=dealLoc.id;
opex.Wave_Plan_lk__c=waveplan.id;
opex.Item__c='TestData';
opex.Active__c=true;
opex.Planned_Date__c=date.today();
opex.Deal_Location__c='India';

opex.Wave_Plan_Version__c=wavePlanVersion.id;
insert opex; 

riskRAID = new RAID_Risk__c ();
riskRAID.Deal__c = deal.id;
riskRAID.Title__c = 'TestTitle';
riskRAID.Module_Name__c='KTTRACKER';
riskRAID.ModuleID__c=waveplan.id;
riskRAID.Forum_Raised__c='Tactical /Program Level';
riskRAID.Raised_at_level__c='High';
riskRAID.Risk_Impact__c='High';
riskRAID.Risk_Probability__c='High';
riskRAID.Workstream_Area__c='High';
riskRAID.Raised_by_Client_Accenture__c = 'test';
insert riskRAID;
  
actionRAID= new RAID_Action__c ();
actionRAID.Deal__c = deal.id;
actionRAID.Module_Name__c='KTTRACKER';
actionRAID.Module_ID__c=waveplan.id;
actionRAID.Forum_Raised__c='Tactical /Program Level';
actionRAID.Raised_at_level__c='High';

actionRAID.Action_Title__c='ActionTitle';
actionRAID.Raised_by_Client_Accenture__c='Accenture';
actionRAID.Workstream_Area__c='High';
insert actionRAID;

issueRAID= new RAID_Issue__c();
issueRAID.Deal__c = deal.id;
issueRAID.Title__c = 'TestTitle';
issueRAID.Module_Name__c='KTTRACKER';
issueRAID.Module_ID__c=dealLoc.id;
issueRAID.Forum_Raised__c='Tactical /Program Level';
issueRAID.Raised_at_level__c='High';
issueRAID.Issue_Severity__c='Low';
issueRAID.Workstream_Area__c='High';
insert issueRAID;

decisioRAID= new RAID_Decision__c();
decisioRAID.Deal__c = deal.id;
decisioRAID.Description__c= 'TestDecision';
decisioRAID.Module_Name__c='KTTRACKER';

decisioRAID.Module_ID__c=dealLoc.id;
decisioRAID.Decision_Title__c='testDecisionTitle';
decisioRAID.Forum_Raised__c='Tactical /Program Level';
decisioRAID.Raised_at_level__c='High';
decisioRAID.Workstream_Area__c='High';
insert decisioRAID;
      
}


public static void setupData9(){

 adminLevelAccObj = new Admin_level_acces__c();
adminLevelAccObj.Name = 'System Administrator';
adminLevelAccObj.Profile_name__c = 'System Administrator';
insert adminLevelAccObj;
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

opex =new OPEX__c();
opex.Deal_Location_lk__c=dealLoc.id;
opex.Wave_Plan_lk__c=waveplan.id;
opex.Item__c='TestData';
opex.Active__c=true;
opex.Planned_Date__c=date.today();
opex.Deal_Location__c='India';

opex.Wave_Plan_Version__c=wavePlanVersion.id;
insert opex; 

riskRAID = new RAID_Risk__c ();
riskRAID.Deal__c = deal.id;
riskRAID.Title__c = 'TestTitle';
riskRAID.Module_Name__c='TECHASSESSMENT';
riskRAID.ModuleID__c=waveplan.id;
riskRAID.Forum_Raised__c='Tactical /Program Level';
riskRAID.Raised_at_level__c='High';
riskRAID.Risk_Impact__c='High';
riskRAID.Risk_Probability__c='High';
riskRAID.Workstream_Area__c='High';
riskRAID.Raised_by_Client_Accenture__c = 'test';
insert riskRAID;
  
actionRAID= new RAID_Action__c ();
actionRAID.Deal__c = deal.id;
actionRAID.Module_Name__c='TECHASSESSMENT';
actionRAID.Module_ID__c=waveplan.id;
actionRAID.Forum_Raised__c='Tactical /Program Level';
actionRAID.Raised_at_level__c='High';
actionRAID.Action_Title__c='ActionTitle';
actionRAID.Raised_by_Client_Accenture__c='Accenture';
actionRAID.Workstream_Area__c='High';
insert actionRAID;

issueRAID= new RAID_Issue__c();
issueRAID.Deal__c = deal.id;
issueRAID.Title__c = 'TestTitle';
issueRAID.Module_Name__c='TECHASSESSMENT';
issueRAID.Module_ID__c=dealLoc.id;
issueRAID.Forum_Raised__c='Tactical /Program Level';
issueRAID.Raised_at_level__c='High';
issueRAID.Issue_Severity__c='Low';
issueRAID.Workstream_Area__c='High';
insert issueRAID;

decisioRAID= new RAID_Decision__c();
decisioRAID.Deal__c = deal.id;
decisioRAID.Description__c= 'TestDecision';
decisioRAID.Module_Name__c='TECHASSESSMENT';
decisioRAID.Module_ID__c=dealLoc.id;
decisioRAID.Forum_Raised__c='Tactical /Program Level';
decisioRAID.Raised_at_level__c='High';
decisioRAID.Decision_Title__c='testDecisionTitle';
decisioRAID.Workstream_Area__c='High';
insert decisioRAID;
      
}

static testMethod void testRAIDLog_InlineControllerNew(){
setupDataNew();
test.starttest();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' , srat.id);

apexpages.currentpage().getparameters().put('moduleName' ,'SRAT');

 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     
     
     
     riskRAID = new RAID_Risk__c ();
    riskRAID.Deal__c = deal.id;
    riskRAID.Title__c = 'TestTitle';
    riskRAID.Module_Name__c='KTTRACKER';
    riskRAID.ModuleID__c=waveplan.id;
    riskRAID.Forum_Raised__c='Tactical /Program Level';
    riskRAID.Raised_at_level__c='High';
    riskRAID.Risk_Impact__c='High';
    riskRAID.Risk_Probability__c='High';
    riskRAID.Workstream_Area__c='High';
    riskRAID.Raised_by_Client_Accenture__c = 'test';
    insert riskRAID;
    obj.riskRAID = riskRAID;
     //obj.saveRisksRAID();
     
     test.stoptest();
    }
    
   /** static testMethod void testRAIDLog_InlineController(){
setupData();
test.starttest();

ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' , srat.id);
apexpages.currentpage().getparameters().put('Id' ,opex.id);
apexpages.currentpage().getparameters().put('Id' ,deal.id);
apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.id);
apexpages.currentpage().getparameters().put('Id' ,dealLoc.id);
apexpages.currentpage().getparameters().put('Id' ,waveplan.id);
apexpages.currentpage().getparameters().put('Id' ,dealHome.id);
apexpages.currentpage().getparameters().put('moduleName' ,'SRAT');
apexpages.currentpage().getparameters().put('moduleName' ,'OPEX');
apexpages.currentpage().getparameters().put('moduleName' ,'Deal');
apexpages.currentpage().getparameters().put('moduleName' ,'WavePlanVersion');
apexpages.currentpage().getparameters().put('moduleName' ,'DealLocation');
apexpages.currentpage().getparameters().put('moduleName' ,'DealWave');
apexpages.currentpage().getparameters().put('moduleName' ,'DealHomeLocation');
apexpages.currentpage().getparameters().put('moduleName' ,'KTTRACKER');
 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     obj.riskRAID.Title__c='testing1..';
     obj.issueRAID.Title__c='testing2..';
     obj.decisioRAID.Description__c='description';
     //obj.initializePageMessages();
   //  obj.saveRisksRAID();
     //obj.initializeRiskRecords(); 
     //obj.saveRisksRecords();
     
     
     
     //obj.saveActionsRAID();
     //obj.initializeActionRecords();
     obj.saveActionRecords();
     //obj.saveIssuesRAID();
     //obj.initializeIssueRecords();
     obj.saveIssuesRecords();
     
     //obj.saveDecisionRAID();
     //obj.initializeDecisionRecords();
     //obj.saveDecisionRecords();
     
     
     test.stoptest();
    } */
    
     /*static testMethod void testRAIDLog_InlineController1(){
test.starttest();
setupData1();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,opex.id);

//apexpages.currentpage().getparameters().put('Id' ,deal.id);
//apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.id);
//apexpages.currentpage().getparameters().put('Id' ,dealLoc.id);
//apexpages.currentpage().getparameters().put('Id' ,waveplan.id);
//apexpages.currentpage().getparameters().put('Id' ,dealHome.id);
apexpages.currentpage().getparameters().put('moduleName' ,'OPEX');
//apexpages.currentpage().getparameters().put('moduleName' ,'OPEX');
//apexpages.currentpage().getparameters().put('moduleName' ,'Deal');
//apexpages.currentpage().getparameters().put('moduleName' ,'WavePlanVersion');
//apexpages.currentpage().getparameters().put('moduleName' ,'DealLocation');
//apexpages.currentpage().getparameters().put('moduleName' ,'DealWave');
//apexpages.currentpage().getparameters().put('moduleName' ,'DealHomeLocation');

 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     obj.riskRAID.Title__c='testing1..';
     obj.issueRAID.Title__c='testing2..';
     obj.decisioRAID.Description__c='description';
     obj.actionRAID.Description__c = 'test description';
  //   obj.saveRisksRAID();
    // obj.saveRisksRecords();
     
     test.stoptest();
    }*/
    /*static testMethod void testRAIDLog_InlineController10(){
test.starttest();
setupData1();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,opex.id);

apexpages.currentpage().getparameters().put('moduleName' ,'OPEX');


 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     obj.riskRAID.Title__c='testing1..';
     obj.issueRAID.Title__c='testing2..';
     obj.decisioRAID.Description__c='description';
     //obj.saveRisksRAID();
     //obj.saveRisksRecords();
     
     test.stoptest();
    }*/
    /*static testMethod void testRAIDLog_InlineController12(){
test.starttest();
setupData1();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,opex.id);

apexpages.currentpage().getparameters().put('moduleName' ,'OPEX');


 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     obj.riskRAID.Title__c='testing1..';
     obj.issueRAID.Title__c='testing2..';
     obj.decisioRAID.Description__c='description';
     
     //obj.saveActionRecords();
   
     test.stoptest();
    }*/
    /*static testMethod void testRAIDLog_InlineController123(){
test.starttest();
setupData1();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,opex.id);

apexpages.currentpage().getparameters().put('moduleName' ,'OPEX');


 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     obj.riskRAID.Title__c='testing1..';
     obj.issueRAID.Title__c='testing2..';
     obj.decisioRAID.Description__c='description';
     //obj.saveDecisionRecords();
     test.stoptest();
    }*/
    static testMethod void testRAIDLog_InlineController2(){
test.starttest();
setupData2();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,deal.id);

apexpages.currentpage().getparameters().put('moduleName' ,'Deal');


 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     obj.riskRAID.Title__c='testing1..';
     obj.issueRAID.Title__c='testing2..';
     obj.decisioRAID.Description__c='description';
    // obj.saveRisksRAID();
     //obj.initializeRiskRecords(); 
     //obj.saveRisksRecords();
     
     //obj.saveActionRecords();
     
     test.stoptest();
    }
    static testMethod void testRAIDLog_InlineController21(){
test.starttest();
setupData2();

ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,deal.id);
apexpages.currentpage().getparameters().put(UTIL_constants.TAB ,'2');
apexpages.currentpage().getparameters().put('moduleName' ,'Deal');


 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     
     obj.actionRAID.Raised_by_Client_Accenture__c = 'Accenture';
     obj.actionRAID.Forum_Raised__c = 'Strategic / Engagement Level';
     obj.actionRAID.Workstream_Area__c = 'Manage Transition Programme';
     obj.actionRAID.Raised_at_level__c = 'Strategic / Engagement Level';
     obj.actionRAID.Raised_By_Person_New__c = objReviewUser.id;
     obj.actionRAID.Primary_Owner_New__c = objReviewUser.id;
     obj.actionRAID.Assigned_To_New__c = objReviewUser.id;
     obj.actionRAID.Owned_by__c = 'test';
     obj.actionRAID.Actual_Closed_Date__c = system.today()-3;
      obj.actionRAID.Date_Raised__c = system.today()-1;
     obj.actionRAID.Action_Closure_Notes_Comments__c = 'test';
     obj.DealID = deal.id;
     
     obj.saveActionsRAID();
     
     test.stoptest();
    }
    static testMethod void testRAIDLog_InlineController211(){
test.starttest();
setupData2();

ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,deal.id);

apexpages.currentpage().getparameters().put('moduleName' ,'Deal');


 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     
     
     obj.saveActionsRAID();
     
     test.stoptest();
    }
   
 static testMethod void testRAIDLog_InlineController221(){
test.starttest();
setupData2();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,deal.id);

apexpages.currentpage().getparameters().put('moduleName' ,'Deal');


 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     
     obj.saveIssuesRAID();
     
     test.stoptest();
    }
    static testMethod void testRAIDLog_InlineController23(){
test.starttest();
setupData2();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,deal.id);
apexpages.currentpage().getparameters().put(UTIL_constants.TAB ,'4');

apexpages.currentpage().getparameters().put('moduleName' ,'Deal');


 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     obj.decisioRAID.Description__c = 'test';
     obj.decisioRAID.Forum_Raised__c = 'Strategic / Engagement Level';
     obj.decisioRAID.Workstream_Area__c = 'Manage Transition Programme';
     obj.decisioRAID.Raised_at_level__c = 'test';
     obj.decisioRAID.Raised_By_Person_New__c = objReviewUser.id;
     obj.decisioRAID.Assigned_To_New__c = objReviewUser.id;
     obj.decisioRAID.Owned_by__c = 'test';
     obj.issueRAID.Actual_Close_Date__c = system.today()-3;
     obj.issueRAID.Date_Raised__c = system.today()-1;
     obj.decisioRAID.Primary_Owner_New__c = objReviewUser.id;
     obj.decisioRAID.Additional_Notes_Comments__c = 'test';
     obj.saveDecisionRAID();
     
     test.stoptest();
    }
    static testMethod void testRAIDLog_InlineController231(){
test.starttest();
setupData2();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,deal.id);

apexpages.currentpage().getparameters().put('moduleName' ,'Deal');


 RAIDLog_InlineController obj = new RAIDLog_InlineController();

     obj.saveDecisionRAID();
     
     test.stoptest();
    }
    static testMethod void testRAIDLog_InlineController24(){
test.starttest();
setupData2();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,deal.id);
apexpages.currentpage().getparameters().put(UTIL_constants.TAB ,'1');

apexpages.currentpage().getparameters().put('moduleName' ,'Deal');


 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     obj.riskRAID.Title__c = 'test';
     obj.riskRAID.Forum_Raised__c = 'Strategic / Engagement Level';
     obj.riskRAID.Workstream_Area__c = 'Manage Transition Programme';
     obj.riskRAID.Raised_at_level__c = 'test';
     obj.riskRAID.Risk_Probability__c = 'High';
     obj.riskRAID.Risk_Impact__c = 'High';
     obj.riskRAID.Primary_Owner_New__c = objReviewUser.id;
     obj.riskRAID.Raised_By_Person_New__c = objReviewUser.id;
     obj.riskRAID.Assigned_To_New__c = objReviewUser.id;
     obj.riskRAID.Raised_by_Client_Accenture__c = 'Accenture';
     obj.riskRAID.Owned_by__c = 'test';
     
     //obj.saveRisksRAID();
     
     test.stoptest();
    }
    static testMethod void testRAIDLog_InlineController241(){
test.starttest();
setupData2();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,deal.id);
apexpages.currentpage().getparameters().put(UTIL_constants.TAB ,'1');

apexpages.currentpage().getparameters().put('moduleName' ,'Deal');


 RAIDLog_InlineController obj = new RAIDLog_InlineController();
    
     
     obj.saveRisksRAID();
     
     test.stoptest();
    }
    
    static testMethod void testRAIDLog_InlineController2toTestsaveIssuesRecords(){
test.starttest();
setupData2();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,deal.id);
apexpages.currentpage().getparameters().put('moduleName' ,'Deal');

 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     obj.riskRAID.Title__c='testing1..';
     obj.issueRAID.Title__c='testing2..';
     obj.decisioRAID.Description__c='description';
    // obj.saveIssuesRecords();
     obj.cancelAction();
    // obj.cancelIssue();
   //  obj.cancelRisk();
     obj.cancelDecision();
     
     //obj.saveDecisionRAID();
    // obj.initializeDecisionRecords();
     //obj.saveDecisionRecords();
     test.stoptest();
}
    
        static testMethod void testRAIDLog_InlineController3(){
test.starttest();
setupData3();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.id);
/*apexpages.currentpage().getparameters().put('Id' ,opex.id);
apexpages.currentpage().getparameters().put('Id' ,deal.id);
apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.id);
apexpages.currentpage().getparameters().put('Id' ,dealLoc.id);
apexpages.currentpage().getparameters().put('Id' ,waveplan.id);
apexpages.currentpage().getparameters().put('Id' ,dealHome.id);*/
apexpages.currentpage().getparameters().put('moduleName' ,'WavePlanVersion');
/*apexpages.currentpage().getparameters().put('moduleName' ,'OPEX');
apexpages.currentpage().getparameters().put('moduleName' ,'Deal');
apexpages.currentpage().getparameters().put('moduleName' ,'WavePlanVersion');
apexpages.currentpage().getparameters().put('moduleName' ,'DealLocation');
apexpages.currentpage().getparameters().put('moduleName' ,'DealWave');
apexpages.currentpage().getparameters().put('moduleName' ,'DealHomeLocation');*/

 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     obj.riskRAID.Title__c='testing1..';
     obj.issueRAID.Title__c='testing2..';
     obj.decisioRAID.Description__c='description';
     //obj.initializePageMessages();
    // obj.saveRisksRAID();
     //obj.initializeRiskRecords(); 
    // obj.saveRisksRecords();
     //obj.saveActionsRAID();
     //obj.initializeActionRecords();
    // obj.saveActionRecords();
    // obj.saveIssuesRAID();
     //obj.initializeIssueRecords();
     obj.saveIssuesRecords();
     List<selectOption> RiskRefIdOptions = obj.getRiskRefId(); 
     List<selectOption> IssueRefIdOptions = obj.getIssueRefId(); 
     
     //obj.saveDecisionRAID();
    // obj.initializeDecisionRecords();
     //obj.saveDecisionRecords();
     test.stoptest();
    }
    static testMethod void testRAIDLog_InlineController4(){
test.starttest();
setupData4();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,dealLoc.id);
/*apexpages.currentpage().getparameters().put('Id' ,opex.id);
apexpages.currentpage().getparameters().put('Id' ,deal.id);
apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.id);
apexpages.currentpage().getparameters().put('Id' ,dealLoc.id);
apexpages.currentpage().getparameters().put('Id' ,waveplan.id);
apexpages.currentpage().getparameters().put('Id' ,dealHome.id);*/
apexpages.currentpage().getparameters().put('moduleName' ,'DealLocation');
/*apexpages.currentpage().getparameters().put('moduleName' ,'OPEX');
apexpages.currentpage().getparameters().put('moduleName' ,'Deal');
apexpages.currentpage().getparameters().put('moduleName' ,'WavePlanVersion');
apexpages.currentpage().getparameters().put('moduleName' ,'DealLocation');
apexpages.currentpage().getparameters().put('moduleName' ,'DealWave');
apexpages.currentpage().getparameters().put('moduleName' ,'DealHomeLocation');*/

 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     obj.riskRAID.Title__c='testing1..';
     obj.issueRAID.Title__c='testing2..';
     obj.decisioRAID.Description__c='description';
     //obj.initializePageMessages();
   //  obj.saveRisksRAID();
     //obj.initializeRiskRecords(); 
   //  obj.saveRisksRecords();
     //obj.saveActionsRAID();
     //obj.initializeActionRecords();
   //  obj.saveActionRecords();
     //obj.saveIssuesRAID();
     //obj.initializeIssueRecords();
     obj.saveIssuesRecords();
     
     //obj.saveDecisionRAID();
     //obj.initializeDecisionRecords();
     //obj.saveDecisionRecords();
     test.stoptest();
    }
    
    static testMethod void testRAIDLog_InlineController5(){
test.starttest();
setupData5();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,waveplan.id);
/*apexpages.currentpage().getparameters().put('Id' ,opex.id);
apexpages.currentpage().getparameters().put('Id' ,deal.id);
apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.id);
apexpages.currentpage().getparameters().put('Id' ,dealLoc.id);
apexpages.currentpage().getparameters().put('Id' ,waveplan.id);
apexpages.currentpage().getparameters().put('Id' ,dealHome.id);*/
apexpages.currentpage().getparameters().put('moduleName' ,'DealWave');
/*apexpages.currentpage().getparameters().put('moduleName' ,'OPEX');
apexpages.currentpage().getparameters().put('moduleName' ,'Deal');
apexpages.currentpage().getparameters().put('moduleName' ,'WavePlanVersion');
apexpages.currentpage().getparameters().put('moduleName' ,'DealLocation');
apexpages.currentpage().getparameters().put('moduleName' ,'DealWave');
apexpages.currentpage().getparameters().put('moduleName' ,'DealHomeLocation');*/

 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     obj.riskRAID.Title__c='testing1..';
     obj.issueRAID.Title__c='testing2..';
     obj.decisioRAID.Description__c='description';
     //obj.initializePageMessages();
     obj.saveRisksRAID();
     //obj.initializeRiskRecords(); 
     //obj.saveRisksRecords();
     //obj.saveActionsRAID();
     //obj.initializeActionRecords();
    // obj.saveActionRecords();
     //obj.saveIssuesRAID();
     //obj.initializeIssueRecords();
   //  obj.saveIssuesRecords();
     
     //obj.saveDecisionRAID();
    // obj.initializeDecisionRecords();
    // obj.saveDecisionRecords();
     test.stoptest();
    }
    /*static testMethod void testRAIDLog_InlineController6(){
test.starttest();
setupData6();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,dealHome.id);
//apexpages.currentpage().getparameters().put('Id' ,opex.id);
//apexpages.currentpage().getparameters().put('Id' ,deal.id);
//apexpages.currentpage().getparameters().put('Id' ,wavePlanVersion.id);
//apexpages.currentpage().getparameters().put('Id' ,dealLoc.id);
//apexpages.currentpage().getparameters().put('Id' ,waveplan.id);
//apexpages.currentpage().getparameters().put('Id' ,dealHome.id);
apexpages.currentpage().getparameters().put('moduleName' ,'DealHomeLocation');
//apexpages.currentpage().getparameters().put('moduleName' ,'OPEX');
//apexpages.currentpage().getparameters().put('moduleName' ,'Deal');
//apexpages.currentpage().getparameters().put('moduleName' ,'WavePlanVersion');
//apexpages.currentpage().getparameters().put('moduleName' ,'DealLocation');
//apexpages.currentpage().getparameters().put('moduleName' ,'DealWave');
//apexpages.currentpage().getparameters().put('moduleName' ,'DealHomeLocation');

 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     obj.riskRAID.Title__c='testing1..';
     obj.issueRAID.Title__c='testing2..';
     obj.decisioRAID.Description__c='description';
     //obj.initializePageMessages();
    // obj.saveRisksRAID();
     //obj.initializeRiskRecords(); 
    // obj.saveRisksRecords();
     //obj.saveActionsRAID();
     //obj.initializeActionRecords();
     obj.saveActionRecords();
     //obj.saveIssuesRAID();
     //obj.initializeIssueRecords();
    // obj.saveIssuesRecords();
     
     //obj.saveDecisionRAID();
     //obj.initializeDecisionRecords();
     //obj.saveDecisionRecords();
     test.stoptest();
    }*/
 
  /*static testMethod void testRAIDLog_InlineController9(){
test.starttest();
setupData9();
ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put(UTIL_constants.URL_PARAMETER_ID ,waveplan.id);
apexpages.currentpage().getparameters().put('moduleName' ,UTIL_constants.TECH_ASSESSMENT);
 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     obj.riskRAID.Title__c='testing1..';
     obj.issueRAID.Title__c='testing2..';
     obj.decisioRAID.Description__c='description';

     //obj.saveRisksRecords();
     //obj.saveActionsRAID();
     //obj.saveActionRecords();
     test.stoptest();
    } */
    
    /*static testMethod void testRAIDLog_InlineController101(){
test.starttest();
setupData9();

ApexPages.StandardController controller;
apexpages.currentpage().getparameters().put('Id' ,dealLoc.id);
apexpages.currentpage().getparameters().put('moduleName' ,'KTTRACKER');
 RAIDLog_InlineController obj = new RAIDLog_InlineController();
     obj.riskRAID.Title__c='testing1..';
     obj.issueRAID.Title__c='testing2..';
     obj.decisioRAID.Description__c='description';
    //obj.saveRisksRAID(); 
    // obj.saveRisksRecords();
     //obj.saveActionsRAID();
     obj.saveActionRecords();
     //obj.saveIssuesRAID();
       
     test.stoptest();
    }*/
 }