@isTest(SeeAlldata= true)
    private class OpexQuestionCheckListControllerTest{


    static OPEX__c opex;
    static Wave_Plan_Version__c wavePlanVersion;
    static Deal_TGP__c deal;
    static OPEX_Version__c opexversion;
    static Wave_Planning__c waveplan;
    static Deal_Location__c dealLoc;
    static Client_Geo_Area_Master__c clientGeo ;
    static Delievery_Location_Master__c deliveryLocMa ;
    static Deal_Home_Location__c dealHome ;
    static OPEX_Section_Name__c opexsec;
    static OPEX_Section_Questionnaire__c opexques;


    static OPEX_Section_Name__c bpoopexsec;
    static OPEX_Section_Questionnaire__c bpopexques;
    static User testUser;
    static Task emailTask;
    static String USER_Name = 'vc7@testorg.com';
    static String USER_Name1 = 'vc71@testorg.com';
    static String USER_Name2 = 'vc72@testorg.com';
    static String USER_Name3 = 'vc73@testorg.com';
    static String USER_Name4 = 'vc74@testorg.com';


   //SET UP DATA 1 Start

    public static void setupData1(){

    // To Create a Test User

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name);
        Database.insert(testUser, false);


    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    insert deal;


    //To create a Wave Plan Version
    wavePlanVersion =new Wave_Plan_Version__c();
    wavePlanVersion.Display_tracking_message__c='Test Data';
    wavePlanVersion.Deal__c=deal.id;
    insert wavePlanVersion;


    clientGeo = new Client_Geo_Area_Master__c();
    clientGeo.Client_Geo_Area_Description__c='TestData';
    insert clientGeo;

    // To create a Delivery Location Master
    deliveryLocMa =new Delievery_Location_Master__c();
    deliveryLocMa.Delivery_Location_Description__c='testdata';
    deliveryLocMa.Name='TestData';
    deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
    insert deliveryLocMa;



    // To create a Deal Home Location
    dealHome =new Deal_Home_Location__c(); 
    dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
    dealHome.Deal__c= deal.id;
    insert dealHome;

 // To create a Deal Location
    dealLoc= new Deal_Location__c();
    dealLoc.Location__c='test Data';
    dealLoc.Deal_Home_Location__c=dealHome.id;
    dealLoc.Mobilization_Recruitment_Lead_Primary__c=testUser.id;
    dealLoc.Mobilization_Recruitment_Lead_Secondary__c=testUser.id;
    dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
    insert dealLoc;
    //To create a Wave Plan
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+7;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.Deal_Location__c=dealLoc.id;
    insert waveplan;

    //To create opex Version

    opexversion=new OPEX_Version__c();
    opexversion.isActive__c=true;
    insert opexversion;

    //To create opex

    opex=new OPEX__c();
    opex.Has_KT_Lead_Submitted__c=true;
    opex.Wave_Plan_Version__c=wavePlanVersion.id;
    opex.OPEX_Version__c=opexversion.id;
    opex.name='Test Data';
    opex.Planned_Date__c=date.today();
    opex.Deal_Location_lk__c=dealLoc.id;
    opex.Wave_Plan_lk__c=waveplan.id;
    opex.Item__c='Pre Go-Live Assessment';
    opex.Is_Submitted__c=true;
    opex.Score__c='Not Stable';
    opex.Focus_Service_operation_Status__c='Not Stable';
    opex.Standard__c='stable';
    opex.Improve_Service_Operation_Status__c='Not Stable';
    opex.Organize_Service_Operation__c='stable';
    opex.Plan_Service_operation_Status__c='stable';
    opex.Visualize_Service_Operation_Status__c='stable';
    opex.Focus__c='Not Stable';
    opex.Standardize__c='Not Stable';
    opex.Plan__c='Not Stable';
    opex.Organize__c='Not Stable';
    opex.Visualize__c='Not Stable';
    opex.Improve__c='Not Stable';
    opex.Process_Score__c=1.00;
    opex.People__c='Meet All Criteria';
    opex.Technology__c='Meet All Criteria';
    opex.Overall_Rating__c='Not Stable';
    opex.Operational_Maturity_Criteria_Remark__c='';
    insert opex;



    opexsec=new OPEX_Section_Name__c();
    opexsec.OPEX_Version__c=opexversion.id;
    opexsec.OPEX_Section_Name__c='Focus the Service operation';
    insert opexsec;


    //To create SRAT Section Questionare

    opexques=new OPEX_Section_Questionnaire__c();
    opexques.OPEX_Section_Name__c=opexsec.id;
  
    opexques.Question_Description__c='Have key client metrics (Performance Dashboard / SLA Performance) been identified and agreed with client and OADM (Delivery, OADM and client should agree and be on same page)?';
    opexques.Sort_Number__c=1;
    opexques.Question_No__c=1;
     opexques.Being_Prepared_Go_Live__c=true;
    insert opexques;



    bpoopexsec=new OPEX_Section_Name__c();
    bpoopexsec.OPEX_Version__c=opexversion.id;
    bpoopexsec.OPEX_Section_Name__c='Focus the Service operation';
    insert bpoopexsec;






    emailTask= new Task();
    emailTask.OwnerId = testUser.id;
    emailTask.Subject = 'Approval Email Attachment on SRAT';
    emailTask.Status = 'Not Started';
    emailTask.Description = 'Please Attach Approval Email from Governance Lead for following SRAT';
    insert emailTask;

    //opex.Deployment_Lead_Task_ID__c=emailTask.id;
    //opex.Has_Deployment_Lead_Saved__c=true;
    opex.Has_Deployment_Lead_Submitted__c=true;
    update opex;


    }
    //SET UP DATA 1 END               
    



   //SET UP DATA 2 Start

    public static void setupData2(){

    // To Create a Test User

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name1);
        Database.insert(testUser, false);


    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    insert deal;


    //To create a Wave Plan Version
    wavePlanVersion =new Wave_Plan_Version__c();
    wavePlanVersion.Display_tracking_message__c='Test Data';
    wavePlanVersion.Deal__c=deal.id;
    insert wavePlanVersion;


    clientGeo = new Client_Geo_Area_Master__c();
    clientGeo.Client_Geo_Area_Description__c='TestData';
    insert clientGeo;

    // To create a Delivery Location Master
    deliveryLocMa =new Delievery_Location_Master__c();
    deliveryLocMa.Delivery_Location_Description__c='testdata';
    deliveryLocMa.Name='TestData';
    deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
    insert deliveryLocMa;



    // To create a Deal Home Location
    dealHome =new Deal_Home_Location__c(); 
    dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
    dealHome.Deal__c= deal.id;
    insert dealHome;

 // To create a Deal Location
    dealLoc= new Deal_Location__c();
    dealLoc.Location__c='test Data';
    dealLoc.Deal_Home_Location__c=dealHome.id;
    dealLoc.Mobilization_Recruitment_Lead_Primary__c=testUser.id;
    dealLoc.Mobilization_Recruitment_Lead_Secondary__c=testUser.id;
    dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
    insert dealLoc;
    //To create a Wave Plan
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+7;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.Deal_Location__c=dealLoc.id;
    insert waveplan;

    //To create opex Version

    opexversion=new OPEX_Version__c();
    opexversion.isActive__c=true;
    insert opexversion;

    //To create opex

    opex=new OPEX__c();
    opex.Has_KT_Lead_Submitted__c=true;
    opex.Wave_Plan_Version__c=wavePlanVersion.id;
    opex.OPEX_Version__c=opexversion.id;
    opex.name='Test Data';
    opex.Planned_Date__c=date.today();
    opex.Deal_Location_lk__c=dealLoc.id;
    opex.Wave_Plan_lk__c=waveplan.id;
    opex.Item__c='Pre Go-Live Assessment';
    opex.Is_Submitted__c=true;
    opex.Score__c='Not Stable';
    opex.Focus_Service_operation_Status__c='Not Stable';
    opex.Standard__c='stable';
    opex.Improve_Service_Operation_Status__c='Not Stable';
    opex.Organize_Service_Operation__c='stable';
    opex.Plan_Service_operation_Status__c='stable';
    opex.Visualize_Service_Operation_Status__c='stable';
    opex.Focus__c='Not Stable';
    opex.Standardize__c='Not Stable';
    opex.Plan__c='Not Stable';
    opex.Organize__c='Not Stable';
    opex.Visualize__c='Not Stable';
    opex.Improve__c='Not Stable';
    opex.Process_Score__c=1.00;
    opex.People__c='Meet All Criteria';
    opex.Technology__c='Meet All Criteria';
    opex.Overall_Rating__c='Not Stable';
    opex.Operational_Maturity_Criteria_Remark__c='';
    insert opex;



    opexsec=new OPEX_Section_Name__c();
    opexsec.OPEX_Version__c=opexversion.id;
    opexsec.OPEX_Section_Name__c='STANDARDIZE THE SERVICE OPERATION';
    insert opexsec;


    //To create SRAT Section Questionare

    opexques=new OPEX_Section_Questionnaire__c();
    opexques.OPEX_Section_Name__c=opexsec.id;
  
    opexques.Question_Description__c='Have key client metrics (Performance Dashboard / SLA Performance) been identified and agreed with client and OADM (Delivery, OADM and client should agree and be on same page)?';
    opexques.Sort_Number__c=1;
    opexques.Question_No__c=1;
opexques.Being_Prepared_Go_Live__c=true;
    insert opexques;



    bpoopexsec=new OPEX_Section_Name__c();
    bpoopexsec.OPEX_Version__c=opexversion.id;
    bpoopexsec.OPEX_Section_Name__c='STANDARDIZE THE SERVICE OPERATION';
    insert bpoopexsec;






    emailTask= new Task();
    emailTask.OwnerId = testUser.id;
    emailTask.Subject = 'Approval Email Attachment on SRAT';
    emailTask.Status = 'Not Started';
    emailTask.Description = 'Please Attach Approval Email from Governance Lead for following SRAT';
    insert emailTask;

    //opex.Deployment_Lead_Task_ID__c=emailTask.id;
    //opex.Has_Deployment_Lead_Saved__c=true;
    opex.Has_Deployment_Lead_Submitted__c=true;
    update opex;


    }
    //SET UP DATA 2 END  

//SET UP DATA 3 Start

    public static void setupData3(){

    // To Create a Test User

    profile p =UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name2);
        Database.insert(testUser, false);


    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    insert deal;


    //To create a Wave Plan Version
    wavePlanVersion =new Wave_Plan_Version__c();
    wavePlanVersion.Display_tracking_message__c='Test Data';
    wavePlanVersion.Deal__c=deal.id;
    insert wavePlanVersion;


    clientGeo = new Client_Geo_Area_Master__c();
    clientGeo.Client_Geo_Area_Description__c='TestData';
    insert clientGeo;

    // To create a Delivery Location Master
    deliveryLocMa =new Delievery_Location_Master__c();
    deliveryLocMa.Delivery_Location_Description__c='testdata';
    deliveryLocMa.Name='TestData';
    deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
    insert deliveryLocMa;



    // To create a Deal Home Location
    dealHome =new Deal_Home_Location__c(); 
    dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
    dealHome.Deal__c= deal.id;
    insert dealHome;

 // To create a Deal Location
    dealLoc= new Deal_Location__c();
    dealLoc.Location__c='test Data';
    dealLoc.Deal_Home_Location__c=dealHome.id;
    dealLoc.Mobilization_Recruitment_Lead_Primary__c=testUser.id;
    dealLoc.Mobilization_Recruitment_Lead_Secondary__c=testUser.id;
    dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
    insert dealLoc;
    //To create a Wave Plan
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+7;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.Deal_Location__c=dealLoc.id;
    insert waveplan;

    //To create opex Version

    opexversion=new OPEX_Version__c();
    opexversion.isActive__c=true;
    insert opexversion;

    //To create opex

    opex=new OPEX__c();
    opex.Has_KT_Lead_Submitted__c=true;
    opex.Wave_Plan_Version__c=wavePlanVersion.id;
    opex.OPEX_Version__c=opexversion.id;
    opex.name='Test Data';
    opex.Planned_Date__c=date.today();
    opex.Deal_Location_lk__c=dealLoc.id;
    opex.Wave_Plan_lk__c=waveplan.id;
    opex.Item__c='Pre Go-Live Assessment';
    opex.Is_Submitted__c=true;
    opex.Score__c='Not Stable';
    opex.Focus_Service_operation_Status__c='Not Stable';
    opex.Standard__c='stable';
    opex.Improve_Service_Operation_Status__c='Not Stable';
    opex.Organize_Service_Operation__c='stable';
    opex.Plan_Service_operation_Status__c='stable';
    opex.Visualize_Service_Operation_Status__c='stable';
    opex.Focus__c='Not Stable';
    opex.Standardize__c='Not Stable';
    opex.Plan__c='Not Stable';
    opex.Organize__c='Not Stable';
    opex.Visualize__c='Not Stable';
    opex.Improve__c='Not Stable';
    opex.Process_Score__c=1.00;
    opex.People__c='Meet All Criteria';
    opex.Technology__c='Meet All Criteria';
    opex.Overall_Rating__c='Not Stable';
    opex.Operational_Maturity_Criteria_Remark__c='';
    insert opex;



    opexsec=new OPEX_Section_Name__c();
    opexsec.OPEX_Version__c=opexversion.id;
    opexsec.OPEX_Section_Name__c='PLAN THE SERVICE OPERATION';
    insert opexsec;


    //To create SRAT Section Questionare

    opexques=new OPEX_Section_Questionnaire__c();
    opexques.OPEX_Section_Name__c=opexsec.id;
  
    opexques.Question_Description__c='Have key client metrics (Performance Dashboard / SLA Performance) been identified and agreed with client and OADM (Delivery, OADM and client should agree and be on same page)?';
    opexques.Sort_Number__c=1;
    opexques.Question_No__c=1;
opexques.Being_Prepared_Go_Live__c=true;
    insert opexques;



    bpoopexsec=new OPEX_Section_Name__c();
    bpoopexsec.OPEX_Version__c=opexversion.id;
    bpoopexsec.OPEX_Section_Name__c='PLAN THE SERVICE OPERATION';
    insert bpoopexsec;






    emailTask= new Task();
    emailTask.OwnerId = testUser.id;
    emailTask.Subject = 'Approval Email Attachment on SRAT';
    emailTask.Status = 'Not Started';
    emailTask.Description = 'Please Attach Approval Email from Governance Lead for following SRAT';
    insert emailTask;

    //opex.Deployment_Lead_Task_ID__c=emailTask.id;
    //opex.Has_Deployment_Lead_Saved__c=true;
    opex.Has_Deployment_Lead_Submitted__c=true;
    update opex;


    }
    //SET UP DATA 3 END  

//SET UP DATA 4 Start

    public static void setupData4(){

    // To Create a Test User

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name3);
        Database.insert(testUser, false);


    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    insert deal;


    //To create a Wave Plan Version
    wavePlanVersion =new Wave_Plan_Version__c();
    wavePlanVersion.Display_tracking_message__c='Test Data';
    wavePlanVersion.Deal__c=deal.id;
    insert wavePlanVersion;


    clientGeo = new Client_Geo_Area_Master__c();
    clientGeo.Client_Geo_Area_Description__c='TestData';
    insert clientGeo;

    // To create a Delivery Location Master
    deliveryLocMa =new Delievery_Location_Master__c();
    deliveryLocMa.Delivery_Location_Description__c='testdata';
    deliveryLocMa.Name='TestData';
    deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
    insert deliveryLocMa;



    // To create a Deal Home Location
    dealHome =new Deal_Home_Location__c(); 
    dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
    dealHome.Deal__c= deal.id;
    insert dealHome;

 // To create a Deal Location
    dealLoc= new Deal_Location__c();
    dealLoc.Location__c='test Data';
    dealLoc.Deal_Home_Location__c=dealHome.id;
    dealLoc.Mobilization_Recruitment_Lead_Primary__c=testUser.id;
    dealLoc.Mobilization_Recruitment_Lead_Secondary__c=testUser.id;
    dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
    insert dealLoc;
    //To create a Wave Plan
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+7;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.Deal_Location__c=dealLoc.id;
    insert waveplan;

    //To create opex Version

    opexversion=new OPEX_Version__c();
    opexversion.isActive__c=true;
    insert opexversion;

    //To create opex

    opex=new OPEX__c();
    opex.Has_KT_Lead_Submitted__c=true;
    opex.Wave_Plan_Version__c=wavePlanVersion.id;
    opex.OPEX_Version__c=opexversion.id;
    opex.name='Test Data';
    opex.Planned_Date__c=date.today();
    opex.Deal_Location_lk__c=dealLoc.id;
    opex.Wave_Plan_lk__c=waveplan.id;
    opex.Item__c='Pre Go-Live Assessment';
    opex.Is_Submitted__c=true;
    opex.Score__c='Not Stable';
    opex.Focus_Service_operation_Status__c='Not Stable';
    opex.Standard__c='stable';
    opex.Improve_Service_Operation_Status__c='Not Stable';
    opex.Organize_Service_Operation__c='stable';
    opex.Plan_Service_operation_Status__c='stable';
    opex.Visualize_Service_Operation_Status__c='stable';
    opex.Focus__c='Not Stable';
    opex.Standardize__c='Not Stable';
    opex.Plan__c='Not Stable';
    opex.Organize__c='Not Stable';
    opex.Visualize__c='Not Stable';
    opex.Improve__c='Not Stable';
    opex.Process_Score__c=1.00;
    opex.People__c='Meet All Criteria';
    opex.Technology__c='Meet All Criteria';
    opex.Overall_Rating__c='Not Stable';
    opex.Operational_Maturity_Criteria_Remark__c='';
    insert opex;



    opexsec=new OPEX_Section_Name__c();
    opexsec.OPEX_Version__c=opexversion.id;
    opexsec.OPEX_Section_Name__c='ORGANIZE THE SERVICE OPERATION';
    insert opexsec;


    //To create SRAT Section Questionare

    opexques=new OPEX_Section_Questionnaire__c();
    opexques.OPEX_Section_Name__c=opexsec.id;
  
    opexques.Question_Description__c='Have key client metrics (Performance Dashboard / SLA Performance) been identified and agreed with client and OADM (Delivery, OADM and client should agree and be on same page)?';
    opexques.Sort_Number__c=1;
    opexques.Question_No__c=1;
opexques.Being_Prepared_Go_Live__c=true;
    insert opexques;



    bpoopexsec=new OPEX_Section_Name__c();
    bpoopexsec.OPEX_Version__c=opexversion.id;
    bpoopexsec.OPEX_Section_Name__c='ORGANIZE THE SERVICE OPERATION';
    insert bpoopexsec;






    emailTask= new Task();
    emailTask.OwnerId = testUser.id;
    emailTask.Subject = 'Approval Email Attachment on SRAT';
    emailTask.Status = 'Not Started';
    emailTask.Description = 'Please Attach Approval Email from Governance Lead for following SRAT';
    insert emailTask;

    //opex.Deployment_Lead_Task_ID__c=emailTask.id;
    //opex.Has_Deployment_Lead_Saved__c=true;
    opex.Has_Deployment_Lead_Submitted__c=true;
    update opex;


    }
    //SET UP DATA 4 END  

//SET UP DATA 5 Start

    public static void setupData5(){

    // To Create a Test User

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name4);
        Database.insert(testUser, false);



    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    insert deal;


    //To create a Wave Plan Version
    wavePlanVersion =new Wave_Plan_Version__c();
    wavePlanVersion.Display_tracking_message__c='Test Data';
    wavePlanVersion.Deal__c=deal.id;
    insert wavePlanVersion;


    clientGeo = new Client_Geo_Area_Master__c();
    clientGeo.Client_Geo_Area_Description__c='TestData';
    insert clientGeo;

    // To create a Delivery Location Master
    deliveryLocMa =new Delievery_Location_Master__c();
    deliveryLocMa.Delivery_Location_Description__c='testdata';
    deliveryLocMa.Name='TestData';
    deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
    insert deliveryLocMa;



    // To create a Deal Home Location
    dealHome =new Deal_Home_Location__c(); 
    dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
    dealHome.Deal__c= deal.id;
    insert dealHome;

 // To create a Deal Location
    dealLoc= new Deal_Location__c();
    dealLoc.Location__c='test Data';
    dealLoc.Deal_Home_Location__c=dealHome.id;
    dealLoc.Mobilization_Recruitment_Lead_Primary__c=testUser.id;
    dealLoc.Mobilization_Recruitment_Lead_Secondary__c=testUser.id;
    dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
    insert dealLoc;
    //To create a Wave Plan
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+7;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.Deal_Location__c=dealLoc.id;
    insert waveplan;

    //To create opex Version

    opexversion=new OPEX_Version__c();
    opexversion.isActive__c=true;
    insert opexversion;

    //To create opex

    opex=new OPEX__c();
    opex.Has_KT_Lead_Submitted__c=true;
    opex.Wave_Plan_Version__c=wavePlanVersion.id;
    opex.OPEX_Version__c=opexversion.id;
    opex.name='Test Data';
    opex.Planned_Date__c=date.today();
    opex.Deal_Location_lk__c=dealLoc.id;
    opex.Wave_Plan_lk__c=waveplan.id;
    opex.Item__c='Pre Go-Live Assessment';
    opex.Is_Submitted__c=true;
    opex.Score__c='Not Stable';
    opex.Focus_Service_operation_Status__c='Not Stable';
    opex.Standard__c='stable';
    opex.Improve_Service_Operation_Status__c='Not Stable';
    opex.Organize_Service_Operation__c='stable';
    opex.Plan_Service_operation_Status__c='stable';
    opex.Visualize_Service_Operation_Status__c='stable';
    opex.Focus__c='Not Stable';
    opex.Standardize__c='Not Stable';
    opex.Plan__c='Not Stable';
    opex.Organize__c='Not Stable';
    opex.Visualize__c='Not Stable';
    opex.Improve__c='Not Stable';
    opex.Process_Score__c=1.00;
    opex.People__c='Meet All Criteria';
    opex.Technology__c='Meet All Criteria';
    opex.Overall_Rating__c='Not Stable';
    opex.Operational_Maturity_Criteria_Remark__c='';
    insert opex;



    opexsec=new OPEX_Section_Name__c();
    opexsec.OPEX_Version__c=opexversion.id;
    opexsec.OPEX_Section_Name__c='VISUALIZE THE SERVICE OPERATION';
    insert opexsec;


    //To create SRAT Section Questionare

    opexques=new OPEX_Section_Questionnaire__c();
    opexques.OPEX_Section_Name__c=opexsec.id;
  
    opexques.Question_Description__c='Have key client metrics (Performance Dashboard / SLA Performance) been identified and agreed with client and OADM (Delivery, OADM and client should agree and be on same page)?';
    opexques.Sort_Number__c=1;
    opexques.Question_No__c=1;
opexques.Being_Prepared_Go_Live__c=true;
    insert opexques;



    bpoopexsec=new OPEX_Section_Name__c();
    bpoopexsec.OPEX_Version__c=opexversion.id;
    bpoopexsec.OPEX_Section_Name__c='VISUALIZE THE SERVICE OPERATION';
    insert bpoopexsec;






    emailTask= new Task();
    emailTask.OwnerId = testUser.id;
    emailTask.Subject = 'Approval Email Attachment on SRAT';
    emailTask.Status = 'Not Started';
    emailTask.Description = 'Please Attach Approval Email from Governance Lead for following SRAT';
    insert emailTask;

    //opex.Deployment_Lead_Task_ID__c=emailTask.id;
    //opex.Has_Deployment_Lead_Saved__c=true;
    opex.Has_Deployment_Lead_Submitted__c=true;
    update opex;


    }
    //SET UP DATA 5 END 

//SET UP DATA 6 Start

    public static void setupData6(){

    // To Create a Test User

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);



    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    insert deal;


    //To create a Wave Plan Version
    wavePlanVersion =new Wave_Plan_Version__c();
    wavePlanVersion.Display_tracking_message__c='Test Data';
    wavePlanVersion.Deal__c=deal.id;
    insert wavePlanVersion;


    clientGeo = new Client_Geo_Area_Master__c();
    clientGeo.Client_Geo_Area_Description__c='TestData';
    insert clientGeo;

    // To create a Delivery Location Master
    deliveryLocMa =new Delievery_Location_Master__c();
    deliveryLocMa.Delivery_Location_Description__c='testdata';
    deliveryLocMa.Name='TestData';
    deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
    insert deliveryLocMa;



    // To create a Deal Home Location
    dealHome =new Deal_Home_Location__c(); 
    dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
    dealHome.Deal__c= deal.id;
    insert dealHome;

 // To create a Deal Location
    dealLoc= new Deal_Location__c();
    dealLoc.Location__c='test Data';
    dealLoc.Deal_Home_Location__c=dealHome.id;
    dealLoc.Mobilization_Recruitment_Lead_Primary__c=testUser.id;
    dealLoc.Mobilization_Recruitment_Lead_Secondary__c=testUser.id;
    dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
    insert dealLoc;
    //To create a Wave Plan
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+7;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.Deal_Location__c=dealLoc.id;
    insert waveplan;

    //To create opex Version

    opexversion=new OPEX_Version__c();
    opexversion.isActive__c=true;
    insert opexversion;

    //To create opex

    opex=new OPEX__c();
    opex.Has_KT_Lead_Submitted__c=true;
    opex.Wave_Plan_Version__c=wavePlanVersion.id;
    opex.OPEX_Version__c=opexversion.id;
    opex.name='Test Data';
    opex.Planned_Date__c=date.today();
    opex.Deal_Location_lk__c=dealLoc.id;
    opex.Wave_Plan_lk__c=waveplan.id;
    opex.Item__c='Pre Go-Live Assessment';
    opex.Is_Submitted__c=true;
    opex.Score__c='Not Stable';
    opex.Focus_Service_operation_Status__c='Not Stable';
    opex.Standard__c='stable';
    opex.Improve_Service_Operation_Status__c='Not Stable';
    opex.Organize_Service_Operation__c='stable';
    opex.Plan_Service_operation_Status__c='stable';
    opex.Visualize_Service_Operation_Status__c='stable';
    opex.Focus__c='Not Stable';
    opex.Standardize__c='Not Stable';
    opex.Plan__c='Not Stable';
    opex.Organize__c='Not Stable';
    opex.Visualize__c='Not Stable';
    opex.Improve__c='Not Stable';
    opex.Process_Score__c=1.00;
    opex.People__c='Meet All Criteria';
    opex.Technology__c='Meet All Criteria';
    opex.Overall_Rating__c='Not Stable';
    opex.Operational_Maturity_Criteria_Remark__c='';
    insert opex;



    opexsec=new OPEX_Section_Name__c();
    opexsec.OPEX_Version__c=opexversion.id;
    opexsec.OPEX_Section_Name__c='IMPROVE THE SERVICE OPERATION';
    insert opexsec;


    //To create SRAT Section Questionare

    opexques=new OPEX_Section_Questionnaire__c();
    opexques.OPEX_Section_Name__c=opexsec.id;
  
    opexques.Question_Description__c='Have key client metrics (Performance Dashboard / SLA Performance) been identified and agreed with client and OADM (Delivery, OADM and client should agree and be on same page)?';
    opexques.Sort_Number__c=1;
    opexques.Question_No__c=1;
opexques.Being_Prepared_Go_Live__c=true;
    insert opexques;



    bpoopexsec=new OPEX_Section_Name__c();
    bpoopexsec.OPEX_Version__c=opexversion.id;
    bpoopexsec.OPEX_Section_Name__c='IMPROVE THE SERVICE OPERATION';
    insert bpoopexsec;






    emailTask= new Task();
    emailTask.OwnerId = testUser.id;
    emailTask.Subject = 'Approval Email Attachment on SRAT';
    emailTask.Status = 'Not Started';
    emailTask.Description = 'Please Attach Approval Email from Governance Lead for following SRAT';
    insert emailTask;

    //opex.Deployment_Lead_Task_ID__c=emailTask.id;
    //opex.Has_Deployment_Lead_Saved__c=true;
    opex.Has_Deployment_Lead_Submitted__c=true;
    update opex;


    }
    //SET UP DATA 6 END 

// BG: SET UP DATA 7 Start

    public static void setupData7(){

    // To Create a Test User

    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name4);
        Database.insert(testUser, false);



    // To create a Deal
    deal =new Deal_TGP__c();
    deal.Name='Test Data';
    insert deal;


    //To create a Wave Plan Version
    wavePlanVersion =new Wave_Plan_Version__c();
    wavePlanVersion.Display_tracking_message__c='Test Data';
    wavePlanVersion.Deal__c=deal.id;
    insert wavePlanVersion;


    clientGeo = new Client_Geo_Area_Master__c();
    clientGeo.Client_Geo_Area_Description__c='TestData';
    insert clientGeo;

    // To create a Delivery Location Master
    deliveryLocMa =new Delievery_Location_Master__c();
    deliveryLocMa.Delivery_Location_Description__c='testdata';
    deliveryLocMa.Name='TestData';
    deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
    insert deliveryLocMa;



    // To create a Deal Home Location
    dealHome =new Deal_Home_Location__c(); 
    dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
    dealHome.Deal__c= deal.id;
    insert dealHome;

 // To create a Deal Location
    dealLoc= new Deal_Location__c();
    dealLoc.Location__c='test Data';
    dealLoc.Deal_Home_Location__c=dealHome.id;
    dealLoc.Mobilization_Recruitment_Lead_Primary__c=testUser.id;
    dealLoc.Mobilization_Recruitment_Lead_Secondary__c=testUser.id;
    dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
    insert dealLoc;
    //To create a Wave Plan
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+7;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.Deal_Location__c=dealLoc.id;
    insert waveplan;

    //To create opex Version

    opexversion=new OPEX_Version__c();
    opexversion.isActive__c=true;
    insert opexversion;

    //To create opex

    opex=new OPEX__c();
    opex.Has_KT_Lead_Submitted__c=true;
    opex.Wave_Plan_Version__c=wavePlanVersion.id;
    opex.OPEX_Version__c=opexversion.id;
    opex.name='Test Data';
    opex.Planned_Date__c=date.today();
    opex.Deal_Location_lk__c=dealLoc.id;
    opex.Wave_Plan_lk__c=waveplan.id;
    opex.Item__c='Pre Go-Live Assessment';
    opex.Is_Submitted__c=true;
    opex.Score__c='Not Stable';
    opex.Focus_Service_operation_Status__c='Not Stable';
    opex.Standard__c='stable';
    opex.Improve_Service_Operation_Status__c='Not Stable';
    opex.Organize_Service_Operation__c='stable';
    opex.Plan_Service_operation_Status__c='stable';
    opex.Visualize_Service_Operation_Status__c='stable';
    opex.Focus__c=null;
    opex.Standardize__c=null;
    opex.Plan__c=null;
    opex.Organize__c=null;
    opex.Visualize__c=null;
    opex.Improve__c=null;
    opex.Process_Score__c=1.00;
    opex.People__c=null;
    opex.Technology__c=null;
    opex.Overall_Rating__c='Not Stable';
    opex.Operational_Maturity_Criteria_Remark__c='';
    insert opex;



    opexsec=new OPEX_Section_Name__c();
    opexsec.OPEX_Version__c=opexversion.id;
    opexsec.OPEX_Section_Name__c='VISUALIZE THE SERVICE OPERATION';
    insert opexsec;


    //To create SRAT Section Questionare

    opexques=new OPEX_Section_Questionnaire__c();
    opexques.OPEX_Section_Name__c=opexsec.id;
  
    opexques.Question_Description__c='Have key client metrics (Performance Dashboard / SLA Performance) been identified and agreed with client and OADM (Delivery, OADM and client should agree and be on same page)?';
    opexques.Sort_Number__c=1;
    opexques.Question_No__c=1;
opexques.Being_Prepared_Go_Live__c=true;
    insert opexques;



    bpoopexsec=new OPEX_Section_Name__c();
    bpoopexsec.OPEX_Version__c=opexversion.id;
    bpoopexsec.OPEX_Section_Name__c='VISUALIZE THE SERVICE OPERATION';
    insert bpoopexsec;






    emailTask= new Task();
    emailTask.OwnerId = testUser.id;
    emailTask.Subject = 'Approval Email Attachment on SRAT';
    emailTask.Status = 'Not Started';
    emailTask.Description = 'Please Attach Approval Email from Governance Lead for following SRAT';
    insert emailTask;

    //opex.Deployment_Lead_Task_ID__c=emailTask.id;
    //opex.Has_Deployment_Lead_Saved__c=true;
    opex.Has_Deployment_Lead_Submitted__c=true;
    update opex;


    }

// BG: Data 7 End 

    static testMethod void test1(){
    test.starttest();
     setupData1();
    ApexPages.StandardController controller;

    apexpages.currentpage().getparameters().put('Id' ,opex.id);

    OpexQuestionCheckListController  obj = new OpexQuestionCheckListController( controller);
     
     
     //obj.serOperSubSecList();
     obj.getServiceOperationQuestionnaire();
     Boolean b;
     obj.itemIndicator= true;
     b = obj.itemIndicator;
     system.assertEquals(b, true);

     obj.whereStr='Being_Prepared_Go_Live__c=true';

     obj.getStandarizeServiceOperationQuestionnaire();
     obj.setFocusServiceOperation();
     obj.setStandardizeServiceOperation();
     obj.getPlanServiceOperationQuestionnaire();
     obj.setPlanServiceOperation();
     obj.getOrgServiceOperationQuestionnaire();
     obj.setOrgStandardizeServiceOperation();
     obj.getVisServiceOperationQuestionnaire();
     obj.setVisStandardizeServiceOperation();
     obj.getImpServiceOperationQuestionnaire();
     obj.setImpStandardizeServiceOperation();
     obj.SaveOPEXChecklist();  
     obj.doCancelChecklist();
     obj.SubmitOPEXChecklist();
     obj.getWhereStr();
     //obj.checkForStability();
     //obj.setMaturityData();
     obj.checkForNoneAnswer();
     test.stoptest();
     
    } 
    
   static testMethod void test2(){
    test.starttest();
     setupData2();
    ApexPages.StandardController controller;

    apexpages.currentpage().getparameters().put('Id' ,opex.id);

    OpexQuestionCheckListController  obj = new OpexQuestionCheckListController( controller);
     
     
     //obj.serOperSubSecList();
     obj.getServiceOperationQuestionnaire();
     Boolean b;
     obj.itemIndicator= true;
     b = obj.itemIndicator;
     system.assertEquals(b, true);

      obj.whereStr='Being_Prepared_Go_Live__c=true';

     obj.getStandarizeServiceOperationQuestionnaire();
     obj.setFocusServiceOperation();
     obj.setStandardizeServiceOperation();
     obj.getPlanServiceOperationQuestionnaire();
     obj.setPlanServiceOperation();
     obj.getOrgServiceOperationQuestionnaire();
     obj.setOrgStandardizeServiceOperation();
     obj.getVisServiceOperationQuestionnaire();
     obj.setVisStandardizeServiceOperation();
     obj.getImpServiceOperationQuestionnaire();
     obj.setImpStandardizeServiceOperation();
     obj.SaveOPEXChecklist();  
     obj.doCancelChecklist();
     obj.SubmitOPEXChecklist();
     obj.getWhereStr();
     //obj.checkForStability();
     //obj.setMaturityData();
     obj.checkForNoneAnswer();
     test.stoptest();
     
    } 
    
    static testMethod void test3(){
    test.starttest();
     setupData3();
    ApexPages.StandardController controller;

    apexpages.currentpage().getparameters().put('Id' ,opex.id);

    OpexQuestionCheckListController  obj = new OpexQuestionCheckListController( controller);
    
    OpexQuestionCheckListController  obj1 = new OpexQuestionCheckListController();
     
     
     //obj.serOperSubSecList();
     obj.getServiceOperationQuestionnaire();
     Boolean b;
     obj.itemIndicator= true;
     b = obj.itemIndicator;
     system.assertEquals(b, true);

      obj.whereStr='Being_Prepared_Go_Live__c=true';

     obj.getStandarizeServiceOperationQuestionnaire();
     obj.setFocusServiceOperation();
     obj.setStandardizeServiceOperation();
     obj.getPlanServiceOperationQuestionnaire();
     obj.setPlanServiceOperation();
     obj.getOrgServiceOperationQuestionnaire();
     obj.setOrgStandardizeServiceOperation();
     obj.getVisServiceOperationQuestionnaire();
     obj.setVisStandardizeServiceOperation();
     obj.getImpServiceOperationQuestionnaire();
     obj.setImpStandardizeServiceOperation();
     obj.SaveOPEXChecklist();  
     obj.doCancelChecklist();
     obj.SubmitOPEXChecklist();
     obj.getWhereStr();
     //obj.checkForStability();
     //obj.setMaturityData();
     obj.checkForNoneAnswer();
     test.stoptest();
     
    }
    
 static testMethod void test4(){
    test.starttest();
     setupData4();
    ApexPages.StandardController controller;

    apexpages.currentpage().getparameters().put('Id' ,opex.id);

    OpexQuestionCheckListController  obj = new OpexQuestionCheckListController( controller);
     
     
     //obj.serOperSubSecList();
     obj.getServiceOperationQuestionnaire();
     Boolean b;
     obj.itemIndicator= true;
     b = obj.itemIndicator;
     system.assertEquals(b, true);
 obj.whereStr='Being_Prepared_Go_Live__c=true';

     obj.getStandarizeServiceOperationQuestionnaire();
     obj.setFocusServiceOperation();
     obj.setStandardizeServiceOperation();
     obj.getPlanServiceOperationQuestionnaire();
     obj.setPlanServiceOperation();
     obj.getOrgServiceOperationQuestionnaire();
     obj.setOrgStandardizeServiceOperation();
     obj.getVisServiceOperationQuestionnaire();
     obj.setVisStandardizeServiceOperation();
     obj.getImpServiceOperationQuestionnaire();
     obj.setImpStandardizeServiceOperation();
     obj.SaveOPEXChecklist();  
     obj.doCancelChecklist();
     obj.SubmitOPEXChecklist();
     obj.getWhereStr();
     //obj.checkForStability();
     //obj.setMaturityData();
     obj.checkForNoneAnswer();
     test.stoptest();
     
    }


static testMethod void test5(){
    test.starttest();
     setupData5();
    ApexPages.StandardController controller;

    apexpages.currentpage().getparameters().put('Id' ,opex.id);

    OpexQuestionCheckListController  obj = new OpexQuestionCheckListController( controller);
     
     
     //obj.serOperSubSecList();
     obj.getServiceOperationQuestionnaire();
     Boolean b;
     obj.itemIndicator= true;
     b = obj.itemIndicator;
     system.assertEquals(b, true);

      obj.whereStr='Being_Prepared_Go_Live__c=true';

     obj.getStandarizeServiceOperationQuestionnaire();
     obj.setFocusServiceOperation();
     obj.setStandardizeServiceOperation();
     obj.getPlanServiceOperationQuestionnaire();
     obj.setPlanServiceOperation();
     obj.getOrgServiceOperationQuestionnaire();
     obj.setOrgStandardizeServiceOperation();
     obj.getVisServiceOperationQuestionnaire();
     obj.setVisStandardizeServiceOperation();
     obj.getImpServiceOperationQuestionnaire();
     obj.setImpStandardizeServiceOperation();
     obj.SaveOPEXChecklist();  
     obj.doCancelChecklist();
     obj.SubmitOPEXChecklist();
     obj.getWhereStr();
     //obj.checkForStability();
     //obj.setMaturityData();
     obj.checkForNoneAnswer();
     test.stoptest();
     
    }

static testMethod void test6(){
    test.starttest();
     setupData6();
    ApexPages.StandardController controller;

    apexpages.currentpage().getparameters().put('Id' ,opex.id);

    OpexQuestionCheckListController  obj = new OpexQuestionCheckListController( controller);
     
     
     //obj.serOperSubSecList();
     obj.getServiceOperationQuestionnaire();
     Boolean b;
     obj.itemIndicator= true;
     b = obj.itemIndicator;
     system.assertEquals(b, true);

      obj.whereStr='Being_Prepared_Go_Live__c=true';

     obj.getStandarizeServiceOperationQuestionnaire();
     obj.setFocusServiceOperation();
     obj.setStandardizeServiceOperation();
     obj.getPlanServiceOperationQuestionnaire();
     obj.setPlanServiceOperation();
     obj.getOrgServiceOperationQuestionnaire();
     obj.setOrgStandardizeServiceOperation();
     obj.getVisServiceOperationQuestionnaire();
     obj.setVisStandardizeServiceOperation();
     obj.getImpServiceOperationQuestionnaire();
     obj.setImpStandardizeServiceOperation();
     obj.SaveOPEXChecklist();  
     obj.doCancelChecklist();
     obj.SubmitOPEXChecklist();
     obj.getWhereStr();
     obj.callisRAIDAccessible();
     //obj.checkForStability();
     //obj.setMaturityData();
     obj.checkForNoneAnswer();
     test.stoptest();
     
    }

    static testMethod void test7(){
    test.starttest();
     setupData7();
    ApexPages.StandardController controller;

    apexpages.currentpage().getparameters().put('Id' ,opex.id);

    OpexQuestionCheckListController  obj = new OpexQuestionCheckListController( controller);
     
     
     //obj.serOperSubSecList();
     obj.getServiceOperationQuestionnaire();
     Boolean b;
     obj.itemIndicator= true;
     b = obj.itemIndicator;
     system.assertEquals(b, true);

      obj.whereStr='Being_Prepared_Go_Live__c=true';

     obj.getStandarizeServiceOperationQuestionnaire();
     obj.setFocusServiceOperation();
     obj.setStandardizeServiceOperation();
     obj.getPlanServiceOperationQuestionnaire();
     obj.setPlanServiceOperation();
     obj.getOrgServiceOperationQuestionnaire();
     obj.setOrgStandardizeServiceOperation();
     obj.getVisServiceOperationQuestionnaire();
     obj.setVisStandardizeServiceOperation();
     obj.getImpServiceOperationQuestionnaire();
     obj.setImpStandardizeServiceOperation();
     obj.SaveOPEXChecklist();  
     obj.doCancelChecklist();
     obj.SubmitOPEXChecklist();
     obj.getWhereStr();
     obj.callisRAIDAccessible();
     //obj.checkForStability();
     //obj.setMaturityData();
     obj.checkForNoneAnswer();
     test.stoptest();
     
    }

}