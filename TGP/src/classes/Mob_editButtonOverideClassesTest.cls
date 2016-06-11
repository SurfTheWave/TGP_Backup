/*
Author :Shashank Shastri
Story  :   
Description : Test Class for Mob_editButtonOverideClasses. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
*/

@isTest
private class Mob_editButtonOverideClassesTest{
static Client_Specific_Process_Mapping__c clientSpecificProcessMapping;
static Offerings_Master__c offering;
static Wave_Plan_Version__c wavePlanVersion;
// Create User Records
static User testUser; 
static User testUser1; 
static User testUser2;

// Create User Master Records
static Review_User_Master__c objReviewUser;
static Review_User_Master__c objReviewUser1;
static Review_User_Master__c objReviewUser2;
// Deal Record
static Deal_TGP__c deal;

// Wave Plan
static Wave_Planning__c waveplan;
static Wave_Planning__c waveplan1;
static Wave_Planning__c waveplan2;
static Wave_Planning__c waveplan3;
static Wave_Planning__c waveplan4;

// Wave Process
static Wave_Process__c WaveProcess;
static Deal_Location__c dealLoc;
static Deal_Location__c dealLoc1;
static Deal_Location__c dealLoc2;
static Deal_Location__c dealLoc3;
static Deal_Location__c dealLoc4;

static Deal_Home_Location__c dealHome;
static Delievery_Location_Master__c deliveryLocMa;
static Client_Geo_Area_Master__c clientGeo;
static Commercial_Planning__c comPlan;

public static void setupData(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    Database.insert(testUser, false);

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
    wavePlanVersion.Display_tracking_message__c='Test Data';
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

    //To create a Wave Plan
    
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Comment__c='test data';
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+7;
    waveplan.Deal_Location__c=dealLoc.id;
    waveplan.Number_of_Projected_FTEs__c=1;
    insert waveplan;
    
    
}
/*
    *You gonna Miss me by my walk
    *You gonna Miss me by my walk
*/
public static void setupData_KT12(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    Database.insert(testUser, false);
    
    objReviewUser= new Review_User_Master__c();
    objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser.Name='reviewUser1';        
    objReviewUser.Is_Active__c=true;        
    objReviewUser.SFDC_User__c = testUser.Id;        
    insert objReviewUser;                
    
    objReviewUser1= new Review_User_Master__c();        
    objReviewUser1.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser1.Name='reviewUser2';        
    objReviewUser1.Is_Active__c=true;        
    objReviewUser1.SFDC_User__c = testUser.id;        
    insert objReviewUser1;
    
    objReviewUser2= new Review_User_Master__c();        
    objReviewUser2.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser2.Name='reviewUser3';        
    objReviewUser2.Is_Active__c=true;        
    objReviewUser2.SFDC_User__c = testUser.id;        
    insert objReviewUser2;
    
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
    wavePlanVersion.Display_tracking_message__c='Test Data';
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
    dealLoc.Deployment_Lead_New__c = objReviewUser.id;
    dealLoc.Location_Mobilization_Lead_Secondary_New__c = objReviewUser1.id;
    dealLoc.Location_Mobilization_Lead_Secondary_2__c = objReviewUser2.id;
    insert dealLoc;

    //To create a Wave Plan
    
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Comment__c='test data';
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+3;
    waveplan.Deal_Location__c=dealLoc.id;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.KT_Lead_New__c = objReviewUser.id;
    waveplan.Mobilization_KT_Lead_Secondary_2__c = objReviewUser.id;
    waveplan.Mobilization_KT_Lead_Secondary_New__c = objReviewUser2.id;
    insert waveplan;
    
    
}

public static void setupData_KT13(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    Database.insert(testUser, false);
    
    objReviewUser= new Review_User_Master__c();
    objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser.Name='reviewUser1';        
    objReviewUser.Is_Active__c=true;        
    objReviewUser.SFDC_User__c = testUser.Id;        
    insert objReviewUser;                
    
    objReviewUser1= new Review_User_Master__c();        
    objReviewUser1.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser1.Name='reviewUser2';        
    objReviewUser1.Is_Active__c=true;        
    objReviewUser1.SFDC_User__c = testUser.id;        
    insert objReviewUser1;
    
    objReviewUser2= new Review_User_Master__c();        
    objReviewUser2.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser2.Name='reviewUser3';        
    objReviewUser2.Is_Active__c=true;        
    objReviewUser2.SFDC_User__c = testUser.id;        
    insert objReviewUser2;
    
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
    wavePlanVersion.Display_tracking_message__c='Test Data';
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
    dealLoc.Deployment_Lead_New__c = objReviewUser.id;
    dealLoc.Location_Mobilization_Lead_Secondary_New__c = objReviewUser1.id;
    dealLoc.Location_Mobilization_Lead_Secondary_2__c = objReviewUser2.id;
    insert dealLoc;

    //To create a Wave Plan
    
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Comment__c='test data';
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+3;
    waveplan.Deal_Location__c=dealLoc.id;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.KT_Lead_New__c = objReviewUser.id;
    waveplan.Mobilization_KT_Lead_Secondary_2__c = objReviewUser1.id;
    waveplan.Mobilization_KT_Lead_Secondary_New__c = objReviewUser.id;
    insert waveplan;
    
    
}

public static void setupData_KT23(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    Database.insert(testUser, false);
    
    objReviewUser= new Review_User_Master__c();
    objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser.Name='reviewUser1';        
    objReviewUser.Is_Active__c=true;        
    objReviewUser.SFDC_User__c = testUser.Id;        
    insert objReviewUser;                
    
    objReviewUser1= new Review_User_Master__c();        
    objReviewUser1.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser1.Name='reviewUser2';        
    objReviewUser1.Is_Active__c=true;        
    objReviewUser1.SFDC_User__c = testUser.id;        
    insert objReviewUser1;
    
    objReviewUser2= new Review_User_Master__c();        
    objReviewUser2.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser2.Name='reviewUser3';        
    objReviewUser2.Is_Active__c=true;        
    objReviewUser2.SFDC_User__c = testUser.id;        
    insert objReviewUser2;
    
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
    wavePlanVersion.Display_tracking_message__c='Test Data';
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
    dealLoc.Deployment_Lead_New__c = objReviewUser.id;
    dealLoc.Location_Mobilization_Lead_Secondary_New__c = objReviewUser1.id;
    dealLoc.Location_Mobilization_Lead_Secondary_2__c = objReviewUser2.id;
    insert dealLoc;

    //To create a Wave Plan
    
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Comment__c='test data';
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+3;
    waveplan.Deal_Location__c=dealLoc.id;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.KT_Lead_New__c = objReviewUser.id;
    waveplan.Mobilization_KT_Lead_Secondary_2__c = objReviewUser1.id;
    waveplan.Mobilization_KT_Lead_Secondary_New__c = objReviewUser1.id;
    insert waveplan;
    
    
}
/*
    *You gonna miss me when I'm gone
*/
// Tech Lead


public static void setupData_Tech12(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    Database.insert(testUser, false);
    
    objReviewUser= new Review_User_Master__c();
    objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser.Name='reviewUser1';        
    objReviewUser.Is_Active__c=true;        
    objReviewUser.SFDC_User__c = testUser.Id;        
    insert objReviewUser;                
    
    objReviewUser1= new Review_User_Master__c();        
    objReviewUser1.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser1.Name='reviewUser2';        
    objReviewUser1.Is_Active__c=true;        
    objReviewUser1.SFDC_User__c = testUser.id;        
    insert objReviewUser1;
    
    objReviewUser2= new Review_User_Master__c();        
    objReviewUser2.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser2.Name='reviewUser3';        
    objReviewUser2.Is_Active__c=true;        
    objReviewUser2.SFDC_User__c = testUser.id;        
    insert objReviewUser2;
    
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
    wavePlanVersion.Display_tracking_message__c='Test Data';
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
    dealLoc.Deployment_Lead_New__c = objReviewUser.id;
    dealLoc.Location_Mobilization_Lead_Secondary_New__c = objReviewUser1.id;
    dealLoc.Location_Mobilization_Lead_Secondary_2__c = objReviewUser2.id;
    insert dealLoc;

    //To create a Wave Plan
    
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Comment__c='test data';
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+3;
    waveplan.Deal_Location__c=dealLoc.id;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.Mobilization_Technology_Lead_Primary_New__c= objReviewUser.id;
    waveplan.Mob_Technology_Lead_Secondary_New__c= objReviewUser.id;
    insert waveplan;
    
    
}

public static void setupData_Tech13(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    Database.insert(testUser, false);
    
    objReviewUser= new Review_User_Master__c();
    objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser.Name='reviewUser1';        
    objReviewUser.Is_Active__c=true;        
    objReviewUser.SFDC_User__c = testUser.Id;        
    insert objReviewUser;                
    
    objReviewUser1= new Review_User_Master__c();        
    objReviewUser1.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser1.Name='reviewUser2';        
    objReviewUser1.Is_Active__c=true;        
    objReviewUser1.SFDC_User__c = testUser.id;        
    insert objReviewUser1;
    
    objReviewUser2= new Review_User_Master__c();        
    objReviewUser2.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser2.Name='reviewUser3';        
    objReviewUser2.Is_Active__c=true;        
    objReviewUser2.SFDC_User__c = testUser.id;        
    insert objReviewUser2;
    
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
    wavePlanVersion.Display_tracking_message__c='Test Data';
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
    dealLoc.Deployment_Lead_New__c = objReviewUser.id;
    dealLoc.Location_Mobilization_Lead_Secondary_New__c = objReviewUser1.id;
    dealLoc.Location_Mobilization_Lead_Secondary_2__c = objReviewUser2.id;
    insert dealLoc;

    //To create a Wave Plan
    
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Comment__c='test data';
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+3;
    waveplan.Deal_Location__c=dealLoc.id;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.Mobilization_Technology_Lead_Primary_New__c= objReviewUser.id;
    waveplan.Mob_Technology_Lead_Secondary_2__c= objReviewUser.id;
    insert waveplan;
    
    
}

public static void setupData_Tech23(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    Database.insert(testUser, false);
    
    objReviewUser= new Review_User_Master__c();
    objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser.Name='reviewUser1';        
    objReviewUser.Is_Active__c=true;        
    objReviewUser.SFDC_User__c = testUser.Id;        
    insert objReviewUser;                
    
    objReviewUser1= new Review_User_Master__c();        
    objReviewUser1.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser1.Name='reviewUser2';        
    objReviewUser1.Is_Active__c=true;        
    objReviewUser1.SFDC_User__c = testUser.id;        
    insert objReviewUser1;
    
    objReviewUser2= new Review_User_Master__c();        
    objReviewUser2.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser2.Name='reviewUser3';        
    objReviewUser2.Is_Active__c=true;        
    objReviewUser2.SFDC_User__c = testUser.id;        
    insert objReviewUser2;
    
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
    wavePlanVersion.Display_tracking_message__c='Test Data';
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
    dealLoc.Deployment_Lead_New__c = objReviewUser.id;
    dealLoc.Location_Mobilization_Lead_Secondary_New__c = objReviewUser1.id;
    dealLoc.Location_Mobilization_Lead_Secondary_2__c = objReviewUser2.id;
    insert dealLoc;

    //To create a Wave Plan
    
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Comment__c='test data';
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+3;
    waveplan.Deal_Location__c=dealLoc.id;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.Mob_Technology_Lead_Secondary_New__c= objReviewUser.id;
    waveplan.Mob_Technology_Lead_Secondary_2__c= objReviewUser.id;
    insert waveplan;
    
    
}
//Tech Lead Part Ends
// Opex starts
public static void setupData_Opex12(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    Database.insert(testUser, false);
    
    objReviewUser= new Review_User_Master__c();
    objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser.Name='reviewUser1';        
    objReviewUser.Is_Active__c=true;        
    objReviewUser.SFDC_User__c = testUser.Id;        
    insert objReviewUser;                
    
    objReviewUser1= new Review_User_Master__c();        
    objReviewUser1.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser1.Name='reviewUser2';        
    objReviewUser1.Is_Active__c=true;        
    objReviewUser1.SFDC_User__c = testUser.id;        
    insert objReviewUser1;
    
    objReviewUser2= new Review_User_Master__c();        
    objReviewUser2.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser2.Name='reviewUser3';        
    objReviewUser2.Is_Active__c=true;        
    objReviewUser2.SFDC_User__c = testUser.id;        
    insert objReviewUser2;
    
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
    wavePlanVersion.Display_tracking_message__c='Test Data';
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
    dealLoc.Deployment_Lead_New__c = objReviewUser.id;
    dealLoc.Location_Mobilization_Lead_Secondary_New__c = objReviewUser1.id;
    dealLoc.Location_Mobilization_Lead_Secondary_2__c = objReviewUser2.id;
    insert dealLoc;

    //To create a Wave Plan
    
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Comment__c='test data';
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+3;
    waveplan.Deal_Location__c=dealLoc.id;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.Mobilization_Opex_Lead_Primary_New__c= objReviewUser.id;
    waveplan.Mobilization_Opex_Lead_Secondary_New__c= objReviewUser.id;
    insert waveplan;
    
    
}
public static void setupData_Opex13(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    Database.insert(testUser, false);
    
    objReviewUser= new Review_User_Master__c();
    objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser.Name='reviewUser1';        
    objReviewUser.Is_Active__c=true;        
    objReviewUser.SFDC_User__c = testUser.Id;        
    insert objReviewUser;                
    
    objReviewUser1= new Review_User_Master__c();        
    objReviewUser1.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser1.Name='reviewUser2';        
    objReviewUser1.Is_Active__c=true;        
    objReviewUser1.SFDC_User__c = testUser.id;        
    insert objReviewUser1;
    
    objReviewUser2= new Review_User_Master__c();        
    objReviewUser2.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser2.Name='reviewUser3';        
    objReviewUser2.Is_Active__c=true;        
    objReviewUser2.SFDC_User__c = testUser.id;        
    insert objReviewUser2;
    
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
    wavePlanVersion.Display_tracking_message__c='Test Data';
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
    dealLoc.Deployment_Lead_New__c = objReviewUser.id;
    dealLoc.Location_Mobilization_Lead_Secondary_New__c = objReviewUser1.id;
    dealLoc.Location_Mobilization_Lead_Secondary_2__c = objReviewUser2.id;
    insert dealLoc;

    //To create a Wave Plan
    
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Comment__c='test data';
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+3;
    waveplan.Deal_Location__c=dealLoc.id;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.Mobilization_Opex_Lead_Primary_New__c= objReviewUser.id;
    waveplan.Mobilization_Opex_Lead_Secondary_2__c= objReviewUser.id;
    insert waveplan;
    
    
}
public static void setupData_Opex23(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    Database.insert(testUser, false);
    testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,'Raju@dataentry.com.dev');
    testUser1.email = 'raju@dataentry.com';
    Database.insert(testUser1, false);
    
    objReviewUser= new Review_User_Master__c();
    objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser.Name='reviewUser1';        
    objReviewUser.Is_Active__c=true;        
    objReviewUser.SFDC_User__c = testUser.Id;        
    insert objReviewUser;                
    
    objReviewUser1= new Review_User_Master__c();        
    objReviewUser1.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser1.Name='reviewUser2';        
    objReviewUser1.Is_Active__c=true;        
    objReviewUser1.SFDC_User__c = testUser.id;        
    insert objReviewUser1;
    
    objReviewUser2= new Review_User_Master__c();        
    objReviewUser2.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser2.Name='reviewUser3';        
    objReviewUser2.Is_Active__c=true;        
    objReviewUser2.SFDC_User__c = testUser.id;        
    insert objReviewUser2;
    
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
    wavePlanVersion.Display_tracking_message__c='Test Data';
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
    dealLoc.Deployment_Lead_New__c = objReviewUser.id;
    dealLoc.Location_Mobilization_Lead_Secondary_New__c = objReviewUser1.id;
    dealLoc.Location_Mobilization_Lead_Secondary_2__c = objReviewUser2.id;
    insert dealLoc;

    //To create a Wave Plan
    
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Comment__c='test data';
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+3;
    waveplan.Deal_Location__c=dealLoc.id;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.Mobilization_Opex_Lead_Secondary_New__c= objReviewUser.id;
    waveplan.Mobilization_Opex_Lead_Secondary_2__c= objReviewUser.id;
    insert waveplan;
    
    
}


//Opex Ends

//Location Stuff Starts
public static void setupData_Loc12(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    Database.insert(testUser, false);
    testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,'Raju@dataentry.com.dev');
    testUser1.email = 'raju@dataentry.com';
    Database.insert(testUser1, false);
    
    objReviewUser= new Review_User_Master__c();
    objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser.Name='reviewUser1';        
    objReviewUser.Is_Active__c=true;        
    objReviewUser.SFDC_User__c = testUser.Id;        
    insert objReviewUser;                
    
    objReviewUser1= new Review_User_Master__c();        
    objReviewUser1.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser1.Name='reviewUser2';        
    objReviewUser1.Is_Active__c=true;        
    objReviewUser1.SFDC_User__c = testUser.id;        
    insert objReviewUser1;
    
    objReviewUser2= new Review_User_Master__c();        
    objReviewUser2.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser2.Name='reviewUser3';        
    objReviewUser2.Is_Active__c=true;        
    objReviewUser2.SFDC_User__c = testUser.id;        
    insert objReviewUser2;
    
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
    wavePlanVersion.Display_tracking_message__c='Test Data';
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
    dealLoc.Deployment_Lead_New__c = objReviewUser.id;
    dealLoc.Deployment_Lead_New__c= objReviewUser.id;
    dealLoc.Location_Mobilization_Lead_Secondary_New__c= objReviewUser.id;
    insert dealLoc;    
    
}
public static void setupData_Loc13(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    Database.insert(testUser, false);
    testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,'Raju@dataentry.com.dev');
    testUser1.email = 'raju@dataentry.com';
    Database.insert(testUser1, false);
    
    objReviewUser= new Review_User_Master__c();
    objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser.Name='reviewUser1';        
    objReviewUser.Is_Active__c=true;        
    objReviewUser.SFDC_User__c = testUser.Id;        
    insert objReviewUser;                
    
    objReviewUser1= new Review_User_Master__c();        
    objReviewUser1.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser1.Name='reviewUser2';        
    objReviewUser1.Is_Active__c=true;        
    objReviewUser1.SFDC_User__c = testUser.id;        
    insert objReviewUser1;
    
    objReviewUser2= new Review_User_Master__c();        
    objReviewUser2.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser2.Name='reviewUser3';        
    objReviewUser2.Is_Active__c=true;        
    objReviewUser2.SFDC_User__c = testUser.id;        
    insert objReviewUser2;
    
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
    wavePlanVersion.Display_tracking_message__c='Test Data';
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
    dealLoc.Deployment_Lead_New__c = objReviewUser.id;
    dealLoc.Deployment_Lead_New__c= objReviewUser.id;
    dealLoc.Location_Mobilization_Lead_Secondary_2__c = objReviewUser.id;
    insert dealLoc;    
    
}

public static void setupData_Loc23(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    Database.insert(testUser, false);
    testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,'Raju@dataentry.com.dev');
    testUser1.email = 'raju@dataentry.com';
    Database.insert(testUser1, false);
    
    objReviewUser= new Review_User_Master__c();
    objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser.Name='reviewUser1';        
    objReviewUser.Is_Active__c=true;        
    objReviewUser.SFDC_User__c = testUser.Id;        
    insert objReviewUser;                
    
    objReviewUser1= new Review_User_Master__c();        
    objReviewUser1.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser1.Name='reviewUser2';        
    objReviewUser1.Is_Active__c=true;        
    objReviewUser1.SFDC_User__c = testUser.id;        
    insert objReviewUser1;
    
    objReviewUser2= new Review_User_Master__c();        
    objReviewUser2.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser2.Name='reviewUser3';        
    objReviewUser2.Is_Active__c=true;        
    objReviewUser2.SFDC_User__c = testUser.id;        
    insert objReviewUser2;
    
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
    wavePlanVersion.Display_tracking_message__c='Test Data';
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
    dealLoc.Deployment_Lead_New__c = objReviewUser.id;
    dealLoc.Location_Mobilization_Lead_Secondary_New__c= objReviewUser.id;
    dealLoc.Location_Mobilization_Lead_Secondary_2__c = objReviewUser.id;
    insert dealLoc;    
    
}
//Location Stuff Ends
//Recruitment Lead bhi le hi lo
    public static void setupData_Rec12(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    Database.insert(testUser, false);
    testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,'Raju@dataentry.com.dev');
    testUser1.email = 'raju@dataentry.com';
    Database.insert(testUser1, false);
    
    objReviewUser= new Review_User_Master__c();
    objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser.Name='reviewUser1';        
    objReviewUser.Is_Active__c=true;        
    objReviewUser.SFDC_User__c = testUser.Id;        
    insert objReviewUser;                
    
    objReviewUser1= new Review_User_Master__c();        
    objReviewUser1.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser1.Name='reviewUser2';        
    objReviewUser1.Is_Active__c=true;        
    objReviewUser1.SFDC_User__c = testUser.id;        
    insert objReviewUser1;
    
    objReviewUser2= new Review_User_Master__c();        
    objReviewUser2.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser2.Name='reviewUser3';        
    objReviewUser2.Is_Active__c=true;        
    objReviewUser2.SFDC_User__c = testUser.id;        
    insert objReviewUser2;
    
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
    wavePlanVersion.Display_tracking_message__c='Test Data';
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
    dealLoc.Deployment_Lead_New__c = objReviewUser.id;
    dealLoc.Mob_Recruitment_Lead_Primary_New__c= objReviewUser.id;
    dealLoc.Mob_Recruitment_Lead_Secondary_New__c= objReviewUser.id;
    insert dealLoc;    
    
}
public static void setupData_Rec13(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    Database.insert(testUser, false);
    testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,'Raju@dataentry.com.dev');
    testUser1.email = 'raju@dataentry.com';
    Database.insert(testUser1, false);
    
    objReviewUser= new Review_User_Master__c();
    objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser.Name='reviewUser1';        
    objReviewUser.Is_Active__c=true;        
    objReviewUser.SFDC_User__c = testUser.Id;        
    insert objReviewUser;                
    
    objReviewUser1= new Review_User_Master__c();        
    objReviewUser1.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser1.Name='reviewUser2';        
    objReviewUser1.Is_Active__c=true;        
    objReviewUser1.SFDC_User__c = testUser.id;        
    insert objReviewUser1;
    
    objReviewUser2= new Review_User_Master__c();        
    objReviewUser2.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser2.Name='reviewUser3';        
    objReviewUser2.Is_Active__c=true;        
    objReviewUser2.SFDC_User__c = testUser.id;        
    insert objReviewUser2;
    
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
    wavePlanVersion.Display_tracking_message__c='Test Data';
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
    dealLoc.Deployment_Lead_New__c = objReviewUser.id;
    dealLoc.Mob_Recruitment_Lead_Primary_New__c= objReviewUser.id;
    dealLoc.Mob_Recruitment_Lead_Secondary_New_2__c= objReviewUser.id;
    insert dealLoc;    
    
}
public static void setupData_Rec23(){

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
    Database.insert(testUser, false);
    testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,'Raju@dataentry.com.dev');
    testUser1.email = 'raju@dataentry.com';
    Database.insert(testUser1, false);
    
    objReviewUser= new Review_User_Master__c();
    objReviewUser.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser.Name='reviewUser1';        
    objReviewUser.Is_Active__c=true;        
    objReviewUser.SFDC_User__c = testUser.Id;        
    insert objReviewUser;                
    
    objReviewUser1= new Review_User_Master__c();        
    objReviewUser1.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser1.Name='reviewUser2';        
    objReviewUser1.Is_Active__c=true;        
    objReviewUser1.SFDC_User__c = testUser.id;        
    insert objReviewUser1;
    
    objReviewUser2= new Review_User_Master__c();        
    objReviewUser2.Email_ID_of_the_reviewer__c = testUser.Email;        
    objReviewUser2.Name='reviewUser3';        
    objReviewUser2.Is_Active__c=true;        
    objReviewUser2.SFDC_User__c = testUser.id;        
    insert objReviewUser2;
    
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
    wavePlanVersion.Display_tracking_message__c='Test Data';
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
    dealLoc.Deployment_Lead_New__c = objReviewUser.id;
    dealLoc.Mob_Recruitment_Lead_Secondary_New__c= objReviewUser.id;
    dealLoc.Mob_Recruitment_Lead_Secondary_New_2__c= objReviewUser.id;
    insert dealLoc;    
    
}
//Recruitment Lead stuff
static testMethod void test(){
test.starttest();
    setupData();
    ApexPages.StandardController controller= new ApexPages.StandardController(waveplan);
    Mob_editButtonOverideWaveController obj = new Mob_editButtonOverideWaveController ( controller);
    obj.checkweekend();
    obj.doSave();
    obj.doCancel();
test.stoptest();
        
 }
 
static testMethod void test_KTLead12(){
test.starttest();
    setupData_KT12();
    ApexPages.StandardController controller= new ApexPages.StandardController(waveplan);
    Mob_editButtonOverideWaveController obj = new Mob_editButtonOverideWaveController ( controller);
    obj.checkweekend();
    obj.doSave();
    obj.doCancel();
test.stoptest();
        
 }
static testMethod void test_KTLead13(){
test.starttest();
    setupData_KT13();
    ApexPages.StandardController controller= new ApexPages.StandardController(waveplan);
    Mob_editButtonOverideWaveController obj = new Mob_editButtonOverideWaveController ( controller);
    obj.checkweekend();
    obj.doSave();
    obj.doCancel();
test.stoptest();
        
 }
static testMethod void test_KTLead23(){
test.starttest();
    setupData_KT23();
    ApexPages.StandardController controller= new ApexPages.StandardController(waveplan);
    Mob_editButtonOverideWaveController obj = new Mob_editButtonOverideWaveController ( controller);
    obj.checkweekend();
    obj.doSave();
    obj.doCancel();
test.stoptest();
        
 }


 static testMethod void test_Tech12(){
test.starttest();
    setupData_Tech12();
    ApexPages.StandardController controller= new ApexPages.StandardController(waveplan);
    Mob_editButtonOverideWaveController obj = new Mob_editButtonOverideWaveController ( controller);
    obj.checkweekend();
    obj.doSave();
    obj.doCancel();
test.stoptest();
        
 }
 static testMethod void test_Tech13(){
test.starttest();
    setupData_Tech13();
    ApexPages.StandardController controller= new ApexPages.StandardController(waveplan);
    Mob_editButtonOverideWaveController obj = new Mob_editButtonOverideWaveController ( controller);
    obj.checkweekend();
    obj.doSave();
    obj.doCancel();
test.stoptest();
        
 }
 static testMethod void test_Tech23(){
test.starttest();
    setupData_Tech23();
    ApexPages.StandardController controller= new ApexPages.StandardController(waveplan);
    Mob_editButtonOverideWaveController obj = new Mob_editButtonOverideWaveController ( controller);
    obj.checkweekend();
    obj.doSave();
    obj.doCancel();
test.stoptest();
        
 }
 static testMethod void test_Opex12(){
test.starttest();
    setupData_Opex12();
    ApexPages.StandardController controller= new ApexPages.StandardController(waveplan);
    Mob_editButtonOverideWaveController obj = new Mob_editButtonOverideWaveController ( controller);
    obj.checkweekend();
    obj.doSave();
    obj.doCancel();
test.stoptest();
        
 }
 static testMethod void test_Opex13(){
test.starttest();
    setupData_Opex13();
    ApexPages.StandardController controller= new ApexPages.StandardController(waveplan);
    Mob_editButtonOverideWaveController obj = new Mob_editButtonOverideWaveController ( controller);
    obj.checkweekend();
    obj.doSave();
    obj.doCancel();
test.stoptest();
        
 }
 static testMethod void test_Opex23(){
test.starttest();
    setupData_Opex23();
    ApexPages.StandardController controller= new ApexPages.StandardController(waveplan);
    Mob_editButtonOverideWaveController obj = new Mob_editButtonOverideWaveController ( controller);
    obj.checkweekend();
    obj.doSave();
    obj.doCancel();
test.stoptest();
        
 }
 static testMethod void testInsufficient(){
test.starttest();
    setupData_Opex23();
    System.runAs(testUser1){
    ApexPages.StandardController controller= new ApexPages.StandardController(waveplan);
    Mob_editButtonOverideWaveController obj = new Mob_editButtonOverideWaveController ( controller);
    obj.checkweekend();
    obj.doSave();
    obj.doCancel();
    }
test.stoptest();
        
 }
 
 //Location Level Things bhi to cover karni padegi
 static testMethod void testLoc12(){
test.starttest();
    setupData_Loc12();
    ApexPages.StandardController controller= new ApexPages.StandardController(dealLoc);
    Mob_editButtonOverideLocationController obj = new Mob_editButtonOverideLocationController(controller);
    obj.doSave();
    obj.doCancel();
test.stoptest();
        
 }
 static testMethod void testLoc13(){
test.starttest();
    setupData_Loc13();
    ApexPages.StandardController controller= new ApexPages.StandardController(dealLoc);
    Mob_editButtonOverideLocationController obj = new Mob_editButtonOverideLocationController(controller);
    obj.doSave();
    obj.doCancel();
test.stoptest();
        
 }
 static testMethod void testLoc23(){
test.starttest();
    setupData_Loc23();
    ApexPages.StandardController controller= new ApexPages.StandardController(dealLoc);
    Mob_editButtonOverideLocationController obj = new Mob_editButtonOverideLocationController(controller);
    obj.doSave();
    obj.doCancel();
test.stoptest();
        
 }
 static testMethod void testRec12(){
test.starttest();
    setupData_Rec12();
    ApexPages.StandardController controller= new ApexPages.StandardController(dealLoc);
    Mob_editButtonOverideLocationController obj = new Mob_editButtonOverideLocationController(controller);
    obj.doSave();
    obj.doCancel();
test.stoptest();
        
 }
 static testMethod void testRec13(){
test.starttest();
    setupData_Rec13();
    ApexPages.StandardController controller= new ApexPages.StandardController(dealLoc);
    Mob_editButtonOverideLocationController obj = new Mob_editButtonOverideLocationController(controller);
    obj.doSave();
    obj.doCancel();
test.stoptest();
        
 }
 static testMethod void testRec23(){
test.starttest();
    setupData_Rec23();
    ApexPages.StandardController controller= new ApexPages.StandardController(dealLoc);
    Mob_editButtonOverideLocationController obj = new Mob_editButtonOverideLocationController(controller);
    obj.doSave();
    obj.doCancel();
test.stoptest();
        
 }
 static testMethod void testInsufficientOnLoc(){
test.starttest();
    setupData_Opex23();
    System.runAs(testUser1){
    ApexPages.StandardController controller= new ApexPages.StandardController(dealLoc);
    Mob_editButtonOverideLocationController obj = new Mob_editButtonOverideLocationController(controller);
    obj.doSave();
    obj.doCancel();
    }
test.stoptest();
        
 }
}