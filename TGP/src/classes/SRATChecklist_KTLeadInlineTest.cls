@isTest
    private class SRATChecklist_KTLeadInlineTest{

     
    static SRAT__c srat;
    static SRAT__c srat2;
    static SRAT__c srat1;
    static Wave_Plan_Version__c wavePlanVersion;
    static Deal_TGP__c deal;
    static SRAT_VERSION__c sratversion;
    static Wave_Planning__c waveplan;
    static Deal_Location__c dealLoc;
    static Client_Geo_Area_Master__c clientGeo ;
    static Delievery_Location_Master__c deliveryLocMa ;
    static Deal_Home_Location__c dealHome ;
    static SRAT_Section_Name__c sratsec;
    static SRAT_Section_Questionnaire__c sratques;
    static SRAT_Sub_Section_Name__c sratsubsec;
    static SRAT_Sub_Section_Questionnaire__c sratsubques;

    static SRAT_Section_Name__c bposratsec;
    static SRAT_Section_Questionnaire__c bposratques;
    static SRAT_Sub_Section_Name__c bposratsubsec;
    static SRAT_Sub_Section_Questionnaire__c bposratsubques;
    
    static Factory_Specific_Technology__c delapp;
    static Factory_Specific_Technology__c manageapp;
    static User testUser;
    static Task emailTask;
    static SRAT_User_Section_Question__c sratUser;
    static SRAT_User_Sub_Section_Question__c sratSubUser;
    static SRAT_User_Sub_Section_Question__c sratSubUser1;
    static SRAT_User_Sub_Section_Question__c sratSubUser2;


    public static void setupData(){
    
       //To create SRAT Version

    sratversion=new SRAT_Version__c();
    sratversion.isActive__c=true;
    insert sratversion;

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
    dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
    dealLoc.Deployment_Lead__c=testUser.id;
    dealLoc.Mobilization_Recruitment_Lead_Primary__c=testUser.id;
    dealLoc.Mobilization_Recruitment_Lead_Secondary__c=testUser.id;
    insert dealLoc;
    
    //To create a Wave Plan
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+7;
    waveplan.KT_Lead__c=testUser.id;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.Deal_Location__c=dealLoc.id;
    insert waveplan;


 

    //To create SRAT

    srat=new SRAT__c();
    srat.Wave_Plan_Version__c=wavePlanVersion.id;
    srat.SRAT_Version__c=sratversion.id;
    srat.name='Test Data';
    srat.Planned_Date__c=date.today();
    srat.Deal_Location_lk__c=dealLoc.id;
    srat.Wave_Plan_lk__c=waveplan.id;
    insert srat;
    
    
    
    srat2=new SRAT__c();
    srat2.Wave_Plan_Version__c=wavePlanVersion.id;
    srat2.SRAT_Version__c=sratversion.id;
    srat2.name='Test Data';
    srat2.Planned_Date__c=date.today();
    srat2.Deal_Location_lk__c=dealLoc.id;
    srat2.Wave_Plan_lk__c=waveplan.id;
    insert srat2;

    sratSubUser = new SRAT_User_Sub_Section_Question__c();
    sratSubUser.SRAT__c = srat.id;
    sratSubUser.Title__c = 'test';
    insert sratSubUser;
    
    sratSubUser1 = new SRAT_User_Sub_Section_Question__c();
    sratSubUser1.SRAT__c = srat.id;
    insert sratSubUser1;
    
    sratSubUser2 = new SRAT_User_Sub_Section_Question__c();
    sratSubUser2.SRAT__c = srat.id;
    sratSubUser2.Reference__c = 'ABC';
    insert sratSubUser2;
   


    sratsec=new SRAT_Section_Name__c();
    sratsec.SRAT_Version__c=sratversion.id;
    sratsec.SRAT_Section_Name__c='Manage Mobilization Program';
    insert sratsec;
    
    //To create SRAT Section Questionare

    sratques=new SRAT_Section_Questionnaire__c();
    sratques.SRAT_Section_Name__c=sratsec.id;
    sratques.Question_Description__c='Ensure that the mobilization program is set up and managed using standard mobilization protocols; that mobilization scope and approach incorporate critical risks; that clear exit criteria are agreed with Delivery leadership; and the mobilization program is properly closed down.';
    sratques.Sort_Order__c=1;
    insert sratques;

    sratsubsec=new SRAT_Sub_Section_Name__c();
    sratsubsec.SRAT_Section_Name__c=sratsec.id;
    sratsubsec.SRAT_Sub_Section_Name__c='1.0 Manage Mobilization Program';
    insert sratsubsec;

    sratsubques=new SRAT_Sub_Section_Questionnaire__c();
    sratsubques.SRAT_Sub_Section_Id__c=sratsubsec.id;
    sratsubques.Question_Description__c='Mobilization approach and estimates are agreed and signed-off with Factory Global Mobilization Lead. Necessary exceptions to standard onboarding deliverables are confirmed.';
    sratsubques.Sort_Number__c=1;
    insert sratsubques;


    bposratsec=new SRAT_Section_Name__c();
    bposratsec.SRAT_Version__c=sratversion.id;
    bposratsec.SRAT_Section_Name__c='BPO Mobilization Controls';
    insert bposratsec;
    
    //To create SRAT Section Questionare


    bposratsubsec=new SRAT_Sub_Section_Name__c();
    bposratsubsec.SRAT_Section_Name__c=bposratsec.id;
    bposratsubsec.SRAT_Sub_Section_Name__c='OM Readiness Summary';
    insert bposratsubsec;

    bposratsubques=new SRAT_Sub_Section_Questionnaire__c();
    bposratsubques.SRAT_Sub_Section_Id__c=bposratsubsec.id;
    bposratsubques.Question_Description__c='Mobilization approach and estimates are agreed and signed-off with Factory Global Mobilization Lead. Necessary exceptions to standard onboarding deliverables are confirmed.';
    bposratsubques.Sort_Number__c=1;
    insert bposratsubques;

    delapp=new Factory_Specific_Technology__c();
    delapp.Application_Name__c='test appln';
    delapp.Application_Type__c='Service Delivery Applications';
    delapp.SRAT__c=srat.id;
    delapp.SRAT_Version__c=sratversion.id;
    delapp.RAG_Status__c='G=Complete';
    insert delapp;

    manageapp=new Factory_Specific_Technology__c();
    manageapp.Application_Name__c='test appln2';
    manageapp.Application_Type__c='Service Management Applications';
    manageapp.SRAT__c=srat.id;
    manageapp.SRAT_Version__c=sratversion.id;
    manageapp.RAG_Status__c='G=Complete';
    insert manageapp;

    emailTask= new Task();
    emailTask.OwnerId = testUser.id;
    emailTask.Subject = 'Approval Email Attachment on SRAT';
    emailTask.Status = 'Not Started';
    emailTask.Description = 'Please Attach Approval Email from Governance Lead for following SRAT';
    insert emailTask;

    srat.Deployment_Lead_Task_ID__c=emailTask.id;
    update srat;


    }
    public static void setupData1(){
    
     //To create SRAT Version

    sratversion=new SRAT_Version__c();
    sratversion.isActive__c=true;
    insert sratversion;

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
    dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
    dealLoc.Deployment_Lead__c=testUser.id;
    dealLoc.Mobilization_Recruitment_Lead_Primary__c=testUser.id;
    dealLoc.Mobilization_Recruitment_Lead_Secondary__c=testUser.id;
    insert dealLoc;
    //To create a Wave Plan
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+7;
    waveplan.KT_Lead__c=testUser.id;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.Deal_Location__c=dealLoc.id;
    insert waveplan;


   

    //To create SRAT

    srat=new SRAT__c();
    srat.Wave_Plan_Version__c=wavePlanVersion.id;
    srat.SRAT_Version__c=sratversion.id;
    srat.name='Test Data';
    srat.Planned_Date__c=date.today();
    srat.Deal_Location_lk__c=dealLoc.id;
    srat.Wave_Plan_lk__c=waveplan.id;
    srat.Days_Before_Go_Live_Date__c = 3;
    insert srat;
    
    //To create SRAT

    srat1=new SRAT__c();
    //srat1.Wave_Plan_Version__c=wavePlanVersion.id;
    srat1.SRAT_Version__c=sratversion.id;
    srat1.name='Test Data';
    srat1.Planned_Date__c=date.today();
    srat1.Deal_Location_lk__c=dealLoc.id;
    srat1.Wave_Plan_lk__c=waveplan.id;
    srat1.Days_Before_Go_Live_Date__c = 13;
    insert srat1;



    sratsec=new SRAT_Section_Name__c();
    sratsec.SRAT_Version__c=sratversion.id;
    sratsec.SRAT_Section_Name__c='Manage Mobilization Program';
    insert sratsec;
    //To create SRAT Section Questionare

    sratques=new SRAT_Section_Questionnaire__c();
    sratques.SRAT_Section_Name__c=sratsec.id;
    sratques.Question_Description__c='Ensure that the mobilization program is set up and managed using standard mobilization protocols; that mobilization scope and approach incorporate critical risks; that clear exit criteria are agreed with Delivery leadership; and the mobilization program is properly closed down.';
    sratques.Sort_Order__c=1;
    insert sratques;

    sratsubsec=new SRAT_Sub_Section_Name__c();
    sratsubsec.SRAT_Section_Name__c=sratsec.id;
    sratsubsec.SRAT_Sub_Section_Name__c='1.0 Manage Mobilization Program';
    insert sratsubsec;

    sratsubques=new SRAT_Sub_Section_Questionnaire__c();
    sratsubques.SRAT_Sub_Section_Id__c=sratsubsec.id;
    sratsubques.Question_Description__c='Mobilization approach and estimates are agreed and signed-off with Factory Global Mobilization Lead. Necessary exceptions to standard onboarding deliverables are confirmed.';
    sratsubques.Sort_Number__c=1;
    insert sratsubques;


    bposratsec=new SRAT_Section_Name__c();
    bposratsec.SRAT_Version__c=sratversion.id;
    bposratsec.SRAT_Section_Name__c='BPO Mobilization Controls';
    insert bposratsec;
    //To create SRAT Section Questionare


    bposratsubsec=new SRAT_Sub_Section_Name__c();
    bposratsubsec.SRAT_Section_Name__c=bposratsec.id;
    bposratsubsec.SRAT_Sub_Section_Name__c='BPO Mobilization Controls';
    insert bposratsubsec;

    bposratsubques=new SRAT_Sub_Section_Questionnaire__c();
    bposratsubques.SRAT_Sub_Section_Id__c=bposratsubsec.id;
    bposratsubques.Question_Description__c='Mobilization approach and estimates are agreed and signed-off with Factory Global Mobilization Lead. Necessary exceptions to standard onboarding deliverables are confirmed.';
    bposratsubques.Sort_Number__c=1;
    insert bposratsubques;

    delapp=new Factory_Specific_Technology__c();
    delapp.Application_Name__c='test appln';
    delapp.Application_Type__c='Service Delivery Applications';
    delapp.SRAT__c=srat.id;
    delapp.SRAT_Version__c=sratversion.id;
    delapp.RAG_Status__c='G=Complete';    
    insert delapp;

    manageapp=new Factory_Specific_Technology__c();
    manageapp.Application_Name__c='test appln2';
    manageapp.Application_Type__c='Service Management Applications';
    manageapp.SRAT__c=srat.id;
    manageapp.SRAT_Version__c=sratversion.id;
    manageapp.RAG_Status__c='G=Complete';
    insert manageapp;

    emailTask= new Task();
    emailTask.OwnerId = testUser.id;
    emailTask.Subject = 'Approval Email Attachment on SRAT';
    emailTask.Status = 'Not Started';
    emailTask.Description = 'Please Attach Approval Email from Governance Lead for following SRAT';
    insert emailTask;

    srat.Deployment_Lead_Task_ID__c=emailTask.id;
    srat.Has_Deployment_Lead_Saved__c=true;
    srat.Has_Deployment_Lead_Submitted__c=true;
    srat.Has_KT_Lead_Submitted__c=true;
    update srat;

    }
    static testMethod void test1(){
    test.starttest();
     setupData();
    ApexPages.StandardController controller;

    apexpages.currentpage().getparameters().put('Id' ,srat.id);

    SRATChecklist_KTLeadInlineController obj = new SRATChecklist_KTLeadInlineController(controller);
    SRATChecklist_KTLeadInlineController.PreviousSubSec  obj1 = new SRATChecklist_KTLeadInlineController.PreviousSubSec(sratSubUser,true, 'test' , 'test2');
    
     //SRATChecklist_KTLeadInlineController s1 = new SRATChecklist_KTLeadInlineController(controller)
     //obj.PreviousSubSec(sratSubUser,true, 'test' , 'test2');
     obj.isCalledFromSubmit=true;
     //obj.assignMessages();
     //obj.assignColors(String coloringField);
     //obj.mainQueries();
     obj.getActionFunction();
     obj.initializeSerDelApp();
     obj.initializeservManageApp();
     obj.servDelApp.Application_Name__c='testing';
     obj.servManageApp.Application_Name__c='testing2';
     obj.addservDelApp();
     obj.addmanageDelApp();
     obj.getQuestionnaire();
     obj.getBPOMobQuestionnaire();
     obj.getBusOpsQuestionnaire();
     obj.getDelCapQuestionnaire();
     obj.getClientChgQuestionnaire();
     obj.getOMReadinessSummaryQuestionnaire();
     obj.getFacEngSpecTabQues();
     obj.getServiceDelApp();
     obj.getServiceManageApp();
     //obj.setTabQuestionnaires(1);
     //obj.setBPOMobilization();  
     //obj.setAllValues();
     PageReference saveAccProfileDetails1= obj.saveSRATChecklist();
     PageReference saveAccProfileDetails2= obj.doCancelChecklist();
     PageReference saveAccProfileDetails3= obj.SubmitSRATChecklist();
     
     test.stoptest();
     
    } 
    static testMethod void test2(){
    test.starttest();
    setupData();
    ApexPages.StandardController controller;

    apexpages.currentpage().getparameters().put('Id' ,srat.id);
     
     SRATChecklist_KTLeadInlineController  obj = new SRATChecklist_KTLeadInlineController( controller);
     sratSubUser= new SRAT_User_Sub_Section_Question__c();
     sratSubUser.SRAT__c = srat.id;
     sratUser= new SRAT_User_Section_Question__c ();
     SRATChecklist_ReadOnlyInlineController.SubQuestion objSubQues=new SRATChecklist_ReadOnlyInlineController.SubQuestion(sratSubUser,'red',10);
     List<SRATChecklist_ReadOnlyInlineController.SubQuestion> listSubQues=new List<SRATChecklist_ReadOnlyInlineController.SubQuestion>();
     listSubQues.add(objSubQues);
     SRATChecklist_ReadOnlyInlineController.SubSection objSub=new SRATChecklist_ReadOnlyInlineController.SubSection(sratsubsec,listSubQues);
     List<SRATChecklist_ReadOnlyInlineController.SubSection> listSubSec=new List<SRATChecklist_ReadOnlyInlineController.SubSection>();
     listSubSec.add(objSub);
     SRATChecklist_ReadOnlyInlineController.MainQuestion obj1=new SRATChecklist_ReadOnlyInlineController.MainQuestion(sratUser,listSubSec);
 
     obj.isCalledFromSubmit=true;
     obj.getQuestionnaire();
     obj.getBPOMobQuestionnaire();
     obj.getBusOpsQuestionnaire();
     obj.getDelCapQuestionnaire();
     obj.getClientChgQuestionnaire();
     obj.getOMReadinessSummaryQuestionnaire();
     obj.getFacEngSpecTabQues();
     obj.getServiceDelApp();
     obj.getServiceManageApp();
     //obj.setTabQuestionnaires(1);
    //obj.setBPOMobilization();
     obj.initializeSerDelApp();
     obj.addservDelApp();
     obj.addmanageDelApp();
     //obj.setAllValues();
     //obj.listOfServiceDelApp[0].Application_Name__c='Service Delivery Applications';
     //obj.listOfServiceManageApp[0].Application_Name__c='Service Management Applications';
     PageReference saveAccProfileDetails1= obj.saveSRATChecklist();
     PageReference saveAccProfileDetails2= obj.doCancelChecklist();
     PageReference saveAccProfileDetails3= obj.SubmitSRATChecklist();
     
     test.stoptest();
        
     } 
     
      static testMethod void test15(){
            test.starttest();
                setupData();
                ApexPages.StandardController controller;
                apexpages.currentpage().getparameters().put('Id' ,srat.id);
                SRATChecklist_KTLeadInlineController  obj = new SRATChecklist_KTLeadInlineController( controller);
                sratSubUser= new SRAT_User_Sub_Section_Question__c();
                sratSubUser.SRAT__c = srat.id;
                sratUser= new SRAT_User_Section_Question__c ();
                List<Id> sratIdSet = new List<Id>();
                sratIdSet.add(srat.id);
                obj.sratIdList = sratIdSet;
                obj.mainQueries();
            test.stopTest();
     }
     
     
     static testMethod void test3(){
    test.starttest();
    setupData();
    ApexPages.StandardController controller;

    apexpages.currentpage().getparameters().put('Id' ,srat.id);
     
     SRATChecklist_KTLeadInlineController  obj = new SRATChecklist_KTLeadInlineController( controller);
     //obj.assignMessages();
     //obj.assignColors(String coloringField);
     //obj.mainQueries();
     
     obj.getQuestionnaire();
     obj.getBPOMobQuestionnaire();
     obj.getBusOpsQuestionnaire();
     obj.getDelCapQuestionnaire();
     obj.getClientChgQuestionnaire();
     obj.getOMReadinessSummaryQuestionnaire();
     obj.getFacEngSpecTabQues();
     obj.getServiceDelApp();
     obj.getServiceManageApp();
     //obj.setTabQuestionnaires(1);
     //obj.setBPOMobilization();
     obj.initializeSerDelApp();
     obj.addservDelApp();
     obj.addmanageDelApp();
     //obj.setAllValues();
    //obj.listOfServiceDelApp[0].Application_Name__c='Service Delivery Applications';
     //obj.listOfServiceManageApp[0].Application_Name__c='Service Management Applications';
     PageReference saveAccProfileDetails3= obj.SubmitSRATChecklist();
     PageReference saveAccProfileDetails1= obj.saveSRATChecklist();
     PageReference saveAccProfileDetails2= obj.doCancelChecklist(); 
     
     test.stoptest();
        
     } 
     static testMethod void test4(){
    test.starttest();
    setupData();
    ApexPages.StandardController controller;

    apexpages.currentpage().getparameters().put('Id' ,null);
     
     SRATChecklist_KTLeadInlineController  obj = new SRATChecklist_KTLeadInlineController( controller);
     //obj.assignMessages();
     //obj.assignColors(String coloringField);
     //obj.mainQueries();
     
     obj.isCalledFromSubmit=true;
     obj.getQuestionnaire();
     obj.getBPOMobQuestionnaire();
     obj.getBusOpsQuestionnaire();
     obj.getDelCapQuestionnaire();
     obj.getClientChgQuestionnaire();
     obj.getOMReadinessSummaryQuestionnaire();
     //obj.getFacEngSpecTabQues();
     obj.getServiceDelApp();
     obj.getServiceManageApp();
     //obj.setTabQuestionnaires(1);
     //obj.setBPOMobilization();
     obj.initializeSerDelApp();
     //obj.addservDelApp();
     //obj.addmanageDelApp();
     //obj.setAllValues();
     //obj.saveSRATChecklist();
     //obj.doCancelChecklist();
     //obj.depLeadSubmitSRATChecklist();
     
     test.stoptest();
        
     } 
     static testMethod void test5(){
    test.starttest();
    setupData1();
    ApexPages.StandardController controller;

    apexpages.currentpage().getparameters().put('Id' ,srat.id);
     
     SRATChecklist_KTLeadInlineController  obj = new SRATChecklist_KTLeadInlineController( controller);
     //obj.assignMessages();
     //obj.assignColors(String coloringField);
     //obj.mainQueries();
    
     obj.isCalledFromSubmit=true;
     obj.getQuestionnaire();
     obj.getBPOMobQuestionnaire();
     obj.getBusOpsQuestionnaire();
     obj.getDelCapQuestionnaire();
     obj.getClientChgQuestionnaire();
     obj.getOMReadinessSummaryQuestionnaire();
     obj.getFacEngSpecTabQues();
     obj.getServiceDelApp();
     obj.getServiceManageApp();
     //obj.setTabQuestionnaires(1);
     //obj.setBPOMobilization();
     obj.initializeSerDelApp();
     obj.addservDelApp();
     obj.addmanageDelApp();
     //obj.setAllValues();
     PageReference saveAccProfileDetails3= obj.SubmitSRATChecklist();
     PageReference saveAccProfileDetails1= obj.saveSRATChecklist();
     PageReference saveAccProfileDetails2= obj.doCancelChecklist(); 
     
     test.stoptest();
        
     }

static testMethod void test6(){
    test.starttest();
    setupData1();

    

    ApexPages.StandardController controller;

    apexpages.currentpage().getparameters().put('Id' ,srat1.id);
     
     SRATChecklist_KTLeadInlineController  obj = new SRATChecklist_KTLeadInlineController( controller);
     //obj.assignMessages();
     //obj.assignColors(String coloringField);
     //obj.mainQueries();
     obj.isCalledFromSubmit=true;
    
     obj.getQuestionnaire();
     obj.getBPOMobQuestionnaire();
     obj.getBusOpsQuestionnaire();
     obj.getDelCapQuestionnaire();
     obj.getClientChgQuestionnaire();
     obj.getOMReadinessSummaryQuestionnaire();
     obj.getFacEngSpecTabQues();
     obj.getServiceDelApp();
     obj.getServiceManageApp();
     //obj.setTabQuestionnaires(1);
     //obj.setBPOMobilization();
     obj.initializeSerDelApp();
     obj.addservDelApp();
     obj.addmanageDelApp();
     //obj.setAllValues();
     PageReference saveAccProfileDetails3= obj.SubmitSRATChecklist();
     PageReference saveAccProfileDetails1= obj.saveSRATChecklist();
     PageReference saveAccProfileDetails2= obj.doCancelChecklist(); 
     
     test.stoptest();
        
     }     
     static testMethod void test7(){
    test.starttest();
    setupData1();

    

    ApexPages.StandardController controller;

    apexpages.currentpage().getparameters().put('Id' ,srat1.id);
     
     SRATChecklist_KTLeadInlineController  obj = new SRATChecklist_KTLeadInlineController( controller);
     //obj.assignMessages();
     //obj.assignColors(String coloringField);
     //obj.mainQueries();
     obj.isCalledFromSubmit=true;
    
     obj.getQuestionnaire();
     obj.getBPOMobQuestionnaire();
     obj.getBusOpsQuestionnaire();
     obj.getDelCapQuestionnaire();
     obj.getClientChgQuestionnaire();
     obj.getOMReadinessSummaryQuestionnaire();
     obj.getFacEngSpecTabQues();
     obj.getServiceDelApp();
     obj.getServiceManageApp();
     //obj.setTabQuestionnaires(1);
     //obj.setBPOMobilization();
     obj.initializeSerDelApp();
     obj.addservDelApp();
     obj.addmanageDelApp();
     //obj.setAllValues();
     PageReference saveAccProfileDetails3= obj.SubmitSRATChecklist();
     PageReference saveAccProfileDetails1= obj.saveSRATChecklist();
     PageReference saveAccProfileDetails2= obj.doCancelChecklist(); 
     
     
     
     test.stoptest();
        
     }     
     

 // SETUP DATA 
 
 
   public static void setupData2(){
    
       //To create SRAT Version

    sratversion=new SRAT_Version__c();
    sratversion.isActive__c=true;
    insert sratversion;

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
    dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
    dealLoc.Deployment_Lead__c=testUser.id;
    dealLoc.Mobilization_Recruitment_Lead_Primary__c=testUser.id;
    dealLoc.Mobilization_Recruitment_Lead_Secondary__c=testUser.id;
    insert dealLoc;
    
    //To create a Wave Plan
    waveplan =new Wave_Planning__c();
    waveplan.Wave_Label__c='TestData';
    waveplan.GO_Live_Date_del__c=date.today()+7;
    waveplan.KT_Lead__c=testUser.id;
    waveplan.Number_of_Projected_FTEs__c=1;
    waveplan.Deal_Location__c=dealLoc.id;
    insert waveplan;


 

    //To create SRAT

    srat=new SRAT__c();
    srat.Wave_Plan_Version__c=wavePlanVersion.id;
    srat.SRAT_Version__c=sratversion.id;
    srat.name='Test Data';
    srat.Planned_Date__c=date.today();
    srat.Deal_Location_lk__c=dealLoc.id;
    srat.Wave_Plan_lk__c=waveplan.id;
    insert srat;
    
    
    
    srat2=new SRAT__c();
    srat2.Wave_Plan_Version__c=wavePlanVersion.id;
    srat2.SRAT_Version__c=sratversion.id;
    srat2.name='Test Data';
    srat2.Planned_Date__c=date.today();
    srat2.Deal_Location_lk__c=dealLoc.id;
    srat2.Wave_Plan_lk__c=waveplan.id;
    insert srat2;

    sratSubUser = new SRAT_User_Sub_Section_Question__c();
    sratSubUser.SRAT__c = srat.id;
    sratSubUser.Title__c = 'test';
    insert sratSubUser;
    
    sratSubUser1 = new SRAT_User_Sub_Section_Question__c();
    sratSubUser1.SRAT__c = srat.id;
    insert sratSubUser1;
    
    sratSubUser2 = new SRAT_User_Sub_Section_Question__c();
    sratSubUser2.SRAT__c = srat.id;
    sratSubUser2.Reference__c = 'ABC';
    insert sratSubUser2;
   


    sratsec=new SRAT_Section_Name__c();
    sratsec.SRAT_Version__c=sratversion.id;
    sratsec.SRAT_Section_Name__c='Manage Mobilization Program';
    insert sratsec;
    
    //To create SRAT Section Questionare

    sratques=new SRAT_Section_Questionnaire__c();
    sratques.SRAT_Section_Name__c=sratsec.id;
    sratques.Question_Description__c='Ensure that the mobilization program is set up and managed using standard mobilization protocols; that mobilization scope and approach incorporate critical risks; that clear exit criteria are agreed with Delivery leadership; and the mobilization program is properly closed down.';
    sratques.Sort_Order__c=1;
    insert sratques;

    sratsubsec=new SRAT_Sub_Section_Name__c();
    sratsubsec.SRAT_Section_Name__c=sratsec.id;
    sratsubsec.SRAT_Sub_Section_Name__c='1.0 Manage Mobilization Program';
    insert sratsubsec;

    sratsubques=new SRAT_Sub_Section_Questionnaire__c();
    sratsubques.SRAT_Sub_Section_Id__c=sratsubsec.id;
    sratsubques.Question_Description__c='Mobilization approach and estimates are agreed and signed-off with Factory Global Mobilization Lead. Necessary exceptions to standard onboarding deliverables are confirmed.';
    sratsubques.Sort_Number__c=1;
    insert sratsubques;


    bposratsec=new SRAT_Section_Name__c();
    bposratsec.SRAT_Version__c=sratversion.id;
    bposratsec.SRAT_Section_Name__c='BPO Mobilization Controls';
    insert bposratsec;
    
    //To create SRAT Section Questionare


    bposratsubsec=new SRAT_Sub_Section_Name__c();
    bposratsubsec.SRAT_Section_Name__c=bposratsec.id;
    bposratsubsec.SRAT_Sub_Section_Name__c='OM Readiness Summary';
    insert bposratsubsec;

    bposratsubques=new SRAT_Sub_Section_Questionnaire__c();
    bposratsubques.SRAT_Sub_Section_Id__c=bposratsubsec.id;
    bposratsubques.Question_Description__c='Mobilization approach and estimates are agreed and signed-off with Factory Global Mobilization Lead. Necessary exceptions to standard onboarding deliverables are confirmed.';
    bposratsubques.Sort_Number__c=1;
    insert bposratsubques;

    delapp=new Factory_Specific_Technology__c();
  //manageapp.Application_Name__c='test appln1';
    delapp.Application_Name__c=null;
    delapp.Application_Type__c='Service Delivery Applications';
    delapp.SRAT__c=srat.id;
    delapp.SRAT_Version__c=sratversion.id;
    delapp.RAG_Status__c='G=Complete';
    try{
    insert delapp;
    }
    catch(exception e){
    System.assert( e.getMessage().contains('Insert failed.'));
    }
    manageapp=new Factory_Specific_Technology__c();
    manageapp.Application_Name__c=null;
   //manageapp.Application_Name__c='test appln2';
    manageapp.Application_Type__c='Service Management Applications';
    manageapp.SRAT__c=srat.id;
    manageapp.SRAT_Version__c=sratversion.id;
    manageapp.RAG_Status__c='G=Complete';
    try{
    insert manageapp;
     }
     
    catch(exception e){
    System.assert( e.getMessage().contains('Insert failed.'));
    }
     
    emailTask= new Task();
    emailTask.OwnerId = testUser.id;
    emailTask.Subject = 'Approval Email Attachment on SRAT';
    emailTask.Status = 'Not Started';
    emailTask.Description = 'Please Attach Approval Email from Governance Lead for following SRAT';
    insert emailTask;

    srat.Deployment_Lead_Task_ID__c=emailTask.id;
    update srat;


    }
    
   
   
   
     
     static testMethod void test8(){
    test.starttest();
    setupData2();

    

    ApexPages.StandardController controller;

    apexpages.currentpage().getparameters().put('Id' ,srat.id);
     List<ApexPages.Message> msgList = ApexPages.getMessages();
        
     SRATChecklist_KTLeadInlineController  obj = new SRATChecklist_KTLeadInlineController( controller);
     //obj.assignMessages();
     //obj.assignColors(String coloringField);
     //obj.mainQueries();
     obj.isCalledFromSubmit=true;
    
     obj.getQuestionnaire();
     obj.getBPOMobQuestionnaire();
     obj.getBusOpsQuestionnaire();
     obj.getDelCapQuestionnaire();
     obj.getClientChgQuestionnaire();
     obj.getOMReadinessSummaryQuestionnaire();
     obj.getFacEngSpecTabQues();
     obj.getServiceDelApp();
     obj.getServiceManageApp();
     //obj.setTabQuestionnaires(1);
     //obj.setBPOMobilization();
     obj.initializeSerDelApp();
     obj.addservDelApp();
     obj.addmanageDelApp();
     //obj.setAllValues();
     
    
     
     PageReference saveAccProfileDetails3= obj.SubmitSRATChecklist();
     PageReference saveAccProfileDetails1= obj.saveSRATChecklist();
     PageReference saveAccProfileDetails2= obj.doCancelChecklist(); 
     
     test.stoptest();
        
     }     
     
     
 }