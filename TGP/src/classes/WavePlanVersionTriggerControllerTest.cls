@isTest
private class WavePlanVersionTriggerControllerTest{

static Deal_TGP__c  deal;
static Wave_Plan_Version__c wavePlanVersion;
static List<Wave_Plan_Version__c> wavePlanVersionList;
static User  testUser;
static Service_Management_Task_Master__c servmanta;
static Contract_Legal_Infosec_Task_Master__c joumgde;
static Journey_Management_Deliverable__c joumandel;
static BCP_Task_Master__c bcptask;
static Service_Management_Master__c sermanphmas;
static Contract_Legal_Infosec_Section_Master__c CLISM;
static Journey_Management__c joumastas;
static BCP_Section_Master__c bcpSection;
static Commercial_Plan_Activity_Master__c testRec;
static Deal_Home_Location__c dealHome;
static Delievery_Location_Master__c deliveryLocMa;
static Client_Geo_Area_Master__c clientGeo;


    public static void setupData1(){
        // To Create a Test User
        wavePlanVersionList = new List<Wave_Plan_Version__c>();
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
             
                testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
                Database.insert(testUser, false);
                
        // To create a Deal
        deal =new Deal_TGP__c();
        deal.Name='Test Data';
        insert deal;
        
        //To create a Wave Plan Version
        wavePlanVersion =new Wave_Plan_Version__c();
        wavePlanVersion.Deal__c=deal.id;
        wavePlanVersion.Name='TestData';
        insert wavePlanVersion;
        
        wavePlanVersionList.add(wavePlanVersion);
        
        testRec = new Commercial_Plan_Activity_Master__c(Is_Active__c = true, Activity_Name__c = 'Test124', Activity_Order__c=1234);
            insert testRec;
        
        sermanphmas=new Service_Management_Master__c();

        sermanphmas.Phase_Name__c='test';
        sermanphmas.Phase_Number__c=2232323;
        insert sermanphmas;
        
        servmanta= new Service_Management_Task_Master__c ();
        servmanta.Task_Name__c='TestRecruitmentData';
        servmanta.Task_Number__c=32;
        servmanta.Service_Management_Phase__c=sermanphmas.id;
        servmanta.Is_Active__c = true;
        insert servmanta;
        
        
        CLISM=new Contract_Legal_Infosec_Section_Master__c();
        CLISM.Section_Name__c='test';
        CLISM.Section_Number__c='5555';
        insert CLISM;
        
        joumgde=new Contract_Legal_Infosec_Task_Master__c();
        joumgde.Task_Name__c='Name';
        joumgde.Task_Number__c='555555';
        joumgde.Contract_Legal_Infosec_Section_Master__c=CLISM.id;
        joumgde.Is_Active__c = true;
        insert joumgde;
        
         joumastas=new Journey_Management__c();
        joumastas.Section_Name__c='test';
        joumastas.Section_Number__c='9';
        insert joumastas;
        
         joumandel=new Journey_Management_Deliverable__c();
        joumandel.Journey_Management__c=joumastas.id;
        joumandel.Deliverable_Name__c='test';
        joumandel.Deliverable_Number__c='4';
        joumandel.Is_Active__c = true;
        insert joumandel;
        
        bcpSection=new BCP_Section_Master__c();

        bcpSection.Section_Name__c='test';
        bcpSection.Section_Number__c='25453453';
        insert bcpSection;
        
        bcptask=new BCP_Task_Master__c();
        bcptask.Business_Continuity_Planning_del__c=bcpSection.id;
        bcptask.Task_Name__c='test';
        bcptask.Task_Number__c=4;
        bcptask.Is_Active__c = true;
        insert bcptask;
        
        clientGeo = new Client_Geo_Area_Master__c();
        clientGeo.Client_Geo_Area_Description__c='TestData';
        insert clientGeo;
        
        // To create a Delivery Location Master
        deliveryLocMa =new Delievery_Location_Master__c();
        deliveryLocMa.Delivery_Location_Description__c='testdata';
        deliveryLocMa.Name='TestData';
        deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
        insert deliveryLocMa;
        
        dealHome =new Deal_Home_Location__c(); 
        dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
        dealHome.Deal__c= deal.id;
        insert dealHome;
        
        
        
        
    }
    static testMethod void test1(){
        
        test.starttest();
        setupData1();
            
            //WavePlanVersionTriggerController obj = new WavePlanVersionTriggerController();
            WavePlanVersionTriggerController.insertWPVRecordOperation(wavePlanVersionList);
            
            
        
         test.stoptest();
 
    }
}