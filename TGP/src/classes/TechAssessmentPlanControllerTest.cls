/*
Author : Malkeet Singh
Story  : MOB_124
Description : Test Class for TechAssessmentPlanController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest
private class TechAssessmentPlanControllerTest{
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
static Commercial_Planning__c comPlan;
static Opportunity_TGP__c oppTGP;
static Contract_Legal_Infosec__c conLegInfo;
static Service_Management__c serMgmt;
static Client_Master__c clientName;
static Client_Geo_Area_Master__c clientGeoArea;
static Operating_Group_Master__c operatingGroup;
static User testUser;
static Client_Geo_Unit_Master__c clientGeoUnit;
static Tech_Assessment__c techAsess;
static User testUse;
static Mob_User_Roles_Master__c strMoURM;
static MOB_User_Role_Assignment__c roleAssign;

public static void setupData(){

//To create a client Geo Unit

 clientGeoUnit = new Client_Geo_Unit_Master__c ();
 clientGeoUnit.Name = 'TestLATAM';
 clientGeoUnit.Active__c = true;
 insert clientGeoUnit;

/// To create a Test User

Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);

      
// To create a Client Geo

clientGeo = new Client_Geo_Area_Master__c();
clientGeo.Client_Geo_Area_Description__c='TestData';
insert clientGeo;

/// To create a Client

clientName = new Client_Master__c ();
clientName.Name = 'TestObject1';
clientName.Active__c = true;
insert clientName;

 /// To insert Operating Group Master
 
operatingGroup = new Operating_Group_Master__c ();
operatingGroup.Name = 'TestHSMPS';
operatingGroup.Active__c = true;
insert operatingGroup;

///To create a Client Geo Area
clientGeoArea = new Client_Geo_Area_Master__c ();
clientGeoArea.Name = 'TestAPAC';
clientGeoArea.Active__c = true;
 insert clientGeoArea;
 

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
wavePlanVersion.active__c=true;
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

/// To create an Opportunity

oppTGP = new Opportunity_TGP__c();
oppTGP.Name = 'TestIBM';
oppTGP.Stage__c='Stage 1';
oppTGP.Client_Name__c= clientName.id ;
oppTGP.Client_Geo_Area__c=clientGeoArea.id;
oppTGP.Operating_Group__c=operatingGroup.id;
oppTGP.Enterprise_Solution_Architect__c=testUser.id ;
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Activity__c='1-Active';
oppTGP.Oppotunity_QA__c='TestData';
oppTGP.OG_Sales_Lead__c='TestData';
      insert oppTGP;
      
//To create a Contract Legal Infosec record
      
conLegInfo=new Contract_Legal_Infosec__c();
conLegInfo.Name='TestData';
conLegInfo.Activity__c='TestData';
conLegInfo.Planed_Start_Date__c=date.today();
conLegInfo.Planned_End_Date__c=date.today()+7;
conLegInfo.Wave_Plan_lk__c=waveplan.id;
conLegInfo.Deal_Location_lk__c=dealLoc.id;
insert conLegInfo;

// To create Service Management

serMgmt=new Service_Management__c();
serMgmt.Name='TestData';
serMgmt.Activity__c='TestData';
serMgmt.Planned_Start_Date__c=date.today();
serMgmt.Planned_End_Date__c=date.today()+7;
serMgmt.Wave_Plan_lk__c=waveplan.id;
serMgmt.Deal_Location_lk__c=dealLoc.id;
insert serMgmt; 

//To create a Tech Asessment record
techAsess=new Tech_Assessment__c();
techAsess.Name='TestData';
techAsess.Activity__c='TestData';
techAsess.Planned_Start_Date__c=date.today();
techAsess.Planned_End_Date__c=date.today()+7;
techAsess.Wave_Plan_lk__c=waveplan.id;
techAsess.Deal_Location_lk__c=dealLoc.id;
techAsess.comments__c ='test';
insert techAsess; 

    testUser = new User(alias = 'vc30', email='vc30@testorg.com',
    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
    localesidkey='en_US', profileid = p1.Id, country='United States',
    timezonesidkey='America/Los_Angeles', username='vc30@testorg.com');
    insert testUser;
    
     // To create a Mob_User_Roles_Master__c
    strMoURM=new Mob_User_Roles_Master__c();
    strMoURM.Access_Level__c='Edit';
    strMoURM.Role_Name__c='Deal PMO1';
    insert strMoURM;
    
    roleAssign = new MOB_User_Role_Assignment__c();
    roleAssign.Access_Level__c='Edit';
    roleAssign.Deal__c=deal.id;
    roleAssign.Mob_User_Roles_Master__c=strMoURM.id;
    roleAssign.Role_Name__c='Program Control PMO';
    roleAssign.User_Assigned__c=testUser.id;
    roleAssign.User_Assigned_Secondary__c=testUser.id;
    insert roleAssign ;
    
}
static testMethod void test1_1(){
        test.starttest();
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);

        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

        //Run As U1
        System.RunAs(testUser){
        setupData();
        ApexPages.StandardController controller;

        apexpages.currentpage().getparameters().put('ProcessId',techAsess.id);
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

        TechAssessmentPlanController obj = new TechAssessmentPlanController( controller);
        obj.dealLocation.comments__c ='test';

        obj.addWaveProcessDetail();
        }
        test.stoptest();
        
    }

    static testMethod void test1_2(){
        test.starttest();
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
             
                testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
                Database.insert(testUser, false);

        //Run As U1
        System.RunAs(testUser){
            setupData();
            ApexPages.StandardController controller;

            apexpages.currentpage().getparameters().put('ProcessId',techAsess.id);
            apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
             
             TechAssessmentPlanController obj = new TechAssessmentPlanController( controller);
             obj.dealLocation.comments__c ='test';
             
             obj.refreshWaveProcessPage();
        }
         test.stoptest();
        
    }

    static testMethod void test1_3(){
        test.starttest();
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);

        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

        //Run As U1
        System.RunAs(testUser){
            setupData();
            ApexPages.StandardController controller;

            apexpages.currentpage().getparameters().put('ProcessId',techAsess.id);
            apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

            TechAssessmentPlanController obj = new TechAssessmentPlanController( controller);
            obj.dealLocation.comments__c ='test';

            obj.getLocationNames();
        }
        test.stoptest();

    }
    static testMethod void test1_4(){
        test.starttest();
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);

        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

        //Run As U1
        System.RunAs(testUser){
            setupData();
            ApexPages.StandardController controller;

            apexpages.currentpage().getparameters().put('ProcessId',techAsess.id);
            apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

            TechAssessmentPlanController obj = new TechAssessmentPlanController( controller);
            obj.dealLocation.comments__c ='test';

            obj.getWavePlans();
        }
        test.stoptest();

    }
    static testMethod void test1_5(){
        test.starttest();
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);

        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

        //Run As U1
        System.RunAs(testUser){
            setupData();
            ApexPages.StandardController controller;

            apexpages.currentpage().getparameters().put('ProcessId',techAsess.id);
            apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

            TechAssessmentPlanController obj = new TechAssessmentPlanController( controller);
            obj.dealLocation.comments__c ='test';

            obj.checkRecordDeactivated();
        }
        test.stoptest();
    }
    static testMethod void test1_6(){
        test.starttest();
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
         
            testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
            Database.insert(testUser, false);

        //Run As U1
        System.RunAs(testUser){
            setupData();
            ApexPages.StandardController controller;

            apexpages.currentpage().getparameters().put('ProcessId',techAsess.id);
            apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

            TechAssessmentPlanController obj = new TechAssessmentPlanController( controller);
            obj.dealLocation.comments__c ='test';

            
            obj.goToKTTracker();
        }
        test.stoptest();
    }
    static testMethod void test1_7(){
        test.starttest();
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);

        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

        //Run As U1
        System.RunAs(testUser){
            setupData();
            ApexPages.StandardController controller;

            apexpages.currentpage().getparameters().put('ProcessId',techAsess.id);
            apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

            TechAssessmentPlanController obj = new TechAssessmentPlanController( controller);
            obj.dealLocation.comments__c ='test';

            
            obj.getLocationWaveList();
        }
        test.stoptest();

    }
    static testMethod void test1_8(){
        test.starttest();
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);

        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

        //Run As U1
        System.RunAs(testUser){
            setupData();
            ApexPages.StandardController controller;

            apexpages.currentpage().getparameters().put('ProcessId',techAsess.id);
            apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

            TechAssessmentPlanController obj = new TechAssessmentPlanController( controller);
            obj.dealLocation.comments__c ='test';

            obj.initializeDetailRecords();
            //obj.save();
        }
        test.stoptest();

    }
    static testMethod void test1_9(){
        test.starttest();
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);

        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

        //Run As U1
        System.RunAs(testUser){
            setupData();
            ApexPages.StandardController controller;

            apexpages.currentpage().getparameters().put('ProcessId',techAsess.id);
            apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

            TechAssessmentPlanController obj = new TechAssessmentPlanController( controller);
            obj.dealLocation.comments__c ='test';

            obj.cancel();
        
        }
        test.stoptest();

    }
    static testMethod void test1_10(){
        test.starttest();
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);

        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

        //Run As U1
        System.RunAs(testUser){
            setupData();
            ApexPages.StandardController controller;

            apexpages.currentpage().getparameters().put('ProcessId',techAsess.id);
            apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

            TechAssessmentPlanController obj = new TechAssessmentPlanController( controller);
            obj.dealLocation.comments__c ='test';

            
            obj.edit();
        }
        test.stoptest();

    }
    static testMethod void test1_11(){
        test.starttest();
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);

        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

        //Run As U1
        System.RunAs(testUser){
            setupData();
            ApexPages.StandardController controller;

            apexpages.currentpage().getparameters().put('ProcessId',techAsess.id);
            apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

            TechAssessmentPlanController obj = new TechAssessmentPlanController( controller);
            obj.dealLocation.comments__c ='test';

            
            obj.selectAll();
        }
        test.stoptest();

    }
    static testMethod void test1_12(){
        test.starttest();
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);

        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

        //Run As U1
        System.RunAs(testUser){
            setupData();
            ApexPages.StandardController controller;

            apexpages.currentpage().getparameters().put('ProcessId',techAsess.id);
            apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);

            TechAssessmentPlanController obj = new TechAssessmentPlanController( controller);
            obj.dealLocation.comments__c ='test';

            
            obj.selectAllMilestone();
        }
        test.stoptest();

    }  
 
static testMethod void test3_1(){
test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('ProcessId',techAsess.id);
apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
 
 TechAssessmentPlanController obj = new TechAssessmentPlanController( controller);
 obj.dealLocation.comments__c ='test';
 
    obj.addWaveProcessDetail();
    obj.refreshWaveProcessPage();
    obj.getLocationNames();
    obj.getWavePlans();
    obj.checkRecordDeactivated();
    obj.selectAll();
    obj.selectAllMilestone();
 }
 test.stoptest();
    
 }  
 
 /*
 static testMethod void test3_2(){
test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('ProcessId',techAsess.id);
apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
 
 TechAssessmentPlanController obj = new TechAssessmentPlanController( controller);
 obj.dealLocation.comments__c ='test';
     //obj.initializeDetailRecords();
    //obj.save();
 }
 test.stoptest();
    
 }  */
 
 static testMethod void test3_3(){
test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('ProcessId',techAsess.id);
apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
 
 TechAssessmentPlanController obj = new TechAssessmentPlanController( controller);
 obj.dealLocation.comments__c ='test';
 
    obj.cancel();
 }
 test.stoptest();
    
 }  
 static testMethod void test3_4(){
test.starttest();
Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
setupData();
ApexPages.StandardController controller;

apexpages.currentpage().getparameters().put('ProcessId',techAsess.id);
apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
 
 TechAssessmentPlanController obj = new TechAssessmentPlanController( controller);
 obj.dealLocation.comments__c ='test';
 
    obj.edit();
 }
 test.stoptest();
    
 }  
 
}