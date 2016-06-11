/*
Author : Malkeet Singh
Story  : MOB_123
Description : Test Class for ServiceManagementPlan_InlineController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Shridhar Patankar                        13/06/2013

*/
@isTest
private class ServiceManagementPlan_InTest{
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
    static Service_Management_Master__c serManPh;
    static Commercial_Planning__c comPlan;
    static Opportunity_TGP__c oppTGP;
    static Contract_Legal_Infosec__c conLegInfo;
    static Service_Management__c serMgmt;
    static Client_Master__c clientName;
    static Client_Geo_Area_Master__c clientGeoArea;
    static Operating_Group_Master__c operatingGroup;
    static User testUser;
    static Client_Geo_Unit_Master__c clientGeoUnit;
    static Service_Management_Task_Master__c serManTa;

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
        wavePlanVersion.Deal__c=deal.id;
        wavePlanVersion.Active__c=true;
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
        serMgmt.Phase_Name__c='Test';
        serMgmt.Phase_Number__c=19;
        serMgmt.Task_Name__c='Test';
        serMgmt.Task_Number__c=19;
        serMgmt.Wave_Plan_Version__c = wavePlanVersion.id;
        insert serMgmt; 
        
        // To Create Service Management Phase Master
        serManPh= new Service_Management_Master__c();
        serManPh.Phase_Name__c='Test';
        serManPh.Phase_Number__c=19;
        insert serManPh;
        
        // To Create Service Management Task Master
        serManTa= new Service_Management_Task_Master__c();
        serManTa.Task_Name__c='Test';
        serManTa.Task_Number__c=19;
        serManTa.Service_Management_Phase__c=serManPh.id;
        insert serManTa;
    
    
    }
    //////////////////////////////////////////////////////

    static testMethod void test1(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,serMgmt.id);
        apexpages.currentpage().getparameters().put('strWavePlanVersionId' ,null);
         
         ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController(controller);
         obj.initializeDetailRecords();
         obj.strSectionName=serManPh.id;
         obj.buttonName='add';
         obj.saveServicePlan();
         obj.serviceManagementPlan.comments__c ='testCommand';
         obj.serviceManagementPlan.active__c=true;
         obj.saveServicePlan();
         
         test.stoptest();
    
    } 
    
    static testMethod void test1_1(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,serMgmt.id);
        apexpages.currentpage().getparameters().put('strWavePlanVersionId' ,null);
         
         ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController(controller);
         obj.initializeDetailRecords();
         obj.strSectionName=serManPh.id;
         obj.buttonName='add';
         
         obj.serviceManagementPlan.comments__c ='testCommand';
         obj.serviceManagementPlan.active__c=true;
         
         obj.serviceManagementPlan.comments__c ='testCommand';
         obj.serviceManagementPlan.active__c=true;
         obj.serviceManagementPlan.Planned_Start_Date__c=system.today()+1;
         obj.serviceManagementPlan.Planned_End_Date__c=system.today()+1;
         obj.saveServicePlan();
         
         
         
         test.stoptest();
    
    } 
    
    static testMethod void test1_2(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,serMgmt.id);
        apexpages.currentpage().getparameters().put('strWavePlanVersionId' ,null);
         
         ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController(controller);
         obj.initializeDetailRecords();
         obj.strSectionName=serManPh.id;
         obj.buttonName='add';
         
         obj.serviceManagementPlan.comments__c ='testCommand';
         obj.serviceManagementPlan.active__c=true;
         
         obj.serviceManagementPlan.comments__c ='testCommand';
         obj.serviceManagementPlan.active__c=true;
         obj.serviceManagementPlan.Planned_Start_Date__c=system.today()+1;
         obj.serviceManagementPlan.Planned_End_Date__c=system.today()+1;
         
         obj.serviceManagementPlan.comments__c ='testCommand';
         obj.serviceManagementPlan.active__c=true;
         obj.serviceManagementPlan.Planned_Start_Date__c=system.today()+1;
         obj.serviceManagementPlan.Planned_End_Date__c=system.today()+3;
         obj.buttonName='add';
         obj.saveServicePlan();
         
         
         
         test.stoptest();
    
    } 
    
    static testMethod void test1_3(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,serMgmt.id);
        apexpages.currentpage().getparameters().put('strWavePlanVersionId' ,null);
         
         ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController(controller);
         obj.initializeDetailRecords();
         obj.strSectionName=serManPh.id;
         obj.buttonName='add';
         
         obj.serviceManagementPlan.comments__c ='testCommand';
         obj.serviceManagementPlan.active__c=true;
         
         obj.serviceManagementPlan.comments__c ='testCommand';
         obj.serviceManagementPlan.active__c=true;
         obj.serviceManagementPlan.Planned_Start_Date__c=system.today()+1;
         obj.serviceManagementPlan.Planned_End_Date__c=system.today()+1;
         
         obj.serviceManagementPlan.comments__c ='testCommand';
         obj.serviceManagementPlan.active__c=true;
         obj.serviceManagementPlan.Planned_Start_Date__c=system.today()+1;
         obj.serviceManagementPlan.Planned_End_Date__c=system.today()+3;
         obj.buttonName='add';
         
         obj.serviceManagementPlan.comments__c ='testCommand';
         obj.serviceManagementPlan.active__c=true;
         obj.serviceManagementPlan.Planned_Start_Date__c=system.today()+1;
         obj.serviceManagementPlan.Planned_End_Date__c=system.today()+3;
         obj.buttonName='Update';
         obj.saveServicePlan();
         
         test.stoptest();
    
    } 
    
    static testMethod void test1_4(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,serMgmt.id);
        apexpages.currentpage().getparameters().put('strWavePlanVersionId' ,null);
         
         ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController(controller);
         obj.initializeDetailRecords();
         obj.strSectionName=serManPh.id;
         obj.buttonName='add';
         obj.saveServicePlan();
         
         obj.getSectionNames();
         obj.checkRecordDeactivated();
         
        
        
         test.stoptest();
    
    } 

    /////////////////////////////////////////////////////////////// 
 
 ////  
    static testMethod void test2_1(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,null);
        apexpages.currentpage().getparameters().put('strWavePlanVersionId' ,null);
        
        ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController(controller);
        obj.initializeDetailRecords();
        obj.strSectionName=serManPh.id;
        obj.buttonName='add';
        obj.saveServicePlan();
        
        obj.getSectionNames();
        obj.checkRecordDeactivated();
        
        
        test.stoptest();
    
    }
    
    static testMethod void test2_2(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,null);
        apexpages.currentpage().getparameters().put('strWavePlanVersionId' ,null);
        
        ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController(controller);
        obj.initializeDetailRecords();
        obj.strSectionName=serManPh.id;
        obj.buttonName='add';
        
        obj.serviceManagementPlan.comments__c ='testCommand';
        obj.serviceManagementPlan.active__c=true;
        obj.saveServicePlan();
        
        test.stoptest();
    
    }
    
    static testMethod void test2_3(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,null);
        apexpages.currentpage().getparameters().put('strWavePlanVersionId' ,null);
        
        ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController(controller);
        obj.initializeDetailRecords();
        obj.strSectionName=serManPh.id;
        obj.buttonName='add';
        
        obj.serviceManagementPlan.comments__c ='testCommand';
        obj.serviceManagementPlan.active__c=true;
        
        obj.serviceManagementPlan.comments__c ='testCommand';
        obj.serviceManagementPlan.active__c=true;
        obj.serviceManagementPlan.Planned_Start_Date__c=system.today()+1;
        obj.serviceManagementPlan.Planned_End_Date__c=system.today()+1;
        obj.saveServicePlan();
        
        test.stoptest();
    
    }
    
    static testMethod void test2_4(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,null);
        apexpages.currentpage().getparameters().put('strWavePlanVersionId' ,null);
        
        ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController(controller);
        obj.initializeDetailRecords();
        obj.strSectionName=serManPh.id;
        obj.buttonName='add';
        
        obj.serviceManagementPlan.comments__c ='testCommand';
        obj.serviceManagementPlan.active__c=true;
        
        obj.serviceManagementPlan.comments__c ='testCommand';
        obj.serviceManagementPlan.active__c=true;
        obj.serviceManagementPlan.Planned_Start_Date__c=system.today()+1;
        obj.serviceManagementPlan.Planned_End_Date__c=system.today()+1;
        
        obj.serviceManagementPlan.comments__c ='testCommand';
        obj.serviceManagementPlan.active__c=true;
        obj.serviceManagementPlan.Planned_Start_Date__c=system.today()+1;
        obj.serviceManagementPlan.Planned_End_Date__c=system.today()+3;
        obj.buttonName='add';
        obj.saveServicePlan();
        
        test.stoptest();
    
    }
    
    static testMethod void test2_5(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,null);
        apexpages.currentpage().getparameters().put('strWavePlanVersionId' ,null);
        
        ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController(controller);
        obj.initializeDetailRecords();
        obj.strSectionName=serManPh.id;
        obj.buttonName='add';
        
        obj.serviceManagementPlan.comments__c ='testCommand';
        obj.serviceManagementPlan.active__c=true;
        
        obj.serviceManagementPlan.comments__c ='testCommand';
        obj.serviceManagementPlan.active__c=true;
        obj.serviceManagementPlan.Planned_Start_Date__c=system.today()+1;
        obj.serviceManagementPlan.Planned_End_Date__c=system.today()+1;
        
        obj.serviceManagementPlan.comments__c ='testCommand';
        obj.serviceManagementPlan.active__c=true;
        obj.serviceManagementPlan.Planned_Start_Date__c=system.today()+1;
        obj.serviceManagementPlan.Planned_End_Date__c=system.today()+3;
        obj.buttonName='add';
        
        obj.serviceManagementPlan.comments__c ='';
        obj.serviceManagementPlan.active__c=false;
        obj.serviceManagementPlan.Planned_Start_Date__c=system.today()+1;
        obj.serviceManagementPlan.Planned_End_Date__c=system.today()+3;
        obj.buttonName='Update';
        obj.saveServicePlan();
        
        
        test.stoptest();
    
    }
    ////////////////////////////////////////////    
    static testMethod void testForCancel(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,null);
        apexpages.currentpage().getparameters().put('strWavePlanVersionId' ,null);
        
        ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController(controller);
        obj.initializeDetailRecords();
        obj.cancel();
        
        test.stoptest();
    
    }  
    static testMethod void test3_1(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,null);
        apexpages.currentpage().getparameters().put('strWavePlanVersionId' ,wavePlanVersion.id);
        
        
        ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController( controller);
        obj.initializeDetailRecords();
        obj.getSectionNames();
        
        test.stoptest();
    } 
    
    static testMethod void test3_2(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,null);
        apexpages.currentpage().getparameters().put('strWavePlanVersionId' ,wavePlanVersion.id);
        
        
        ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController( controller);
        obj.initializeDetailRecords();
        obj.checkRecordDeactivated();
        
        test.stoptest();
    }
    static testMethod void test3_3(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,null);
        apexpages.currentpage().getparameters().put('strWavePlanVersionId' ,wavePlanVersion.id);
        
        
        ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController( controller);
        
        
        obj.save();
        
        test.stoptest();
    }
    static testMethod void test3_4(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,null);
        apexpages.currentpage().getparameters().put('strWavePlanVersionId' ,wavePlanVersion.id);
        
        
        ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController( controller);
        obj.initializeDetailRecords();
        obj.edit();
        test.stoptest();
    }
    static testMethod void test3_5(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,null);
        apexpages.currentpage().getparameters().put('strWavePlanVersionId' ,wavePlanVersion.id);
        
        
        ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController( controller);
        obj.initializeDetailRecords();
        obj.selectAll();
        obj.selectAllMilestone();
        
        
        test.stoptest();
    }
    static testMethod void test3_6(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,null);
        apexpages.currentpage().getparameters().put('strWavePlanVersionId' ,wavePlanVersion.id);
        
        
        ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController( controller);
        obj.initializeDetailRecords();
        obj.selectAllMilestone();
        
        
        test.stoptest();
    }
    static testMethod void test4(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,null);
        
        ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController( controller);
        obj.initializeDetailRecords();
        obj.getSectionNames();
        obj.checkRecordDeactivated();
        
        test.stoptest();
        
        }  
        static testMethod void test5(){
        test.starttest();
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        apexpages.currentpage().getparameters().put('processId' ,null);
        
        
        ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController( controller);
        obj.initializeDetailRecords();
        //obj.saveServicePlan();
        obj.getSectionNames();
        obj.checkRecordDeactivated();
        
        test.stoptest();
    
    }
    static testMethod void test6(){
        test.starttest();
        
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_REGIONAL_LEADERSHIP);
        
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        
        //Run As U1
        System.RunAs(testUser){
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('processId' ,serMgmt.id);
        
        
        ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController( controller);
        obj.initializeDetailRecords();
        //obj.saveServicePlan();
        obj.getSectionNames();
        obj.checkRecordDeactivated();
        
        
        }
        test.stoptest();
    
    }   
    /*static testMethod void test7(){
        test.starttest();
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        
        //Run As U1
        System.RunAs(testUser){
        setupData();
        ApexPages.StandardController controller= new ApexPages.StandardController(wavePlanVersion);
        
        apexpages.currentpage().getparameters().put('id' ,wavePlanVersion.id);
        
        
        ServiceManagementPlan_InlineController obj = new ServiceManagementPlan_InlineController( controller);
        obj.initializeDetailRecords();
        //obj.saveServicePlan();
        obj.getSectionNames();
        obj.checkRecordDeactivated();
        
        }
        test.stoptest();
    
    }*/
 
 
}