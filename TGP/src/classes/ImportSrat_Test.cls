/*
    @Author     :   Madhusudhan
    @name :         ImportSrat_Test 
    @CreateDate :   04/08/2015 11:03 AM
    @Description :  Test class for ImportSrat_Test
    @Version : 
*/
@isTest
public with sharing class ImportSrat_Test{
        private static ImportSrat ctrl;
        private static PageReference pref;
        private static User testUser;
        private static Wave__c wave;
        private static OPEX_Tracker__c opexTracker;
        private static OPEX_Tracker__c opexTracker2;
        private static Deal_OPEX_Additional_Tracking_Level_1__c OpexLevel1;
        private static Deal_OPEX_Additional_Tracking_Level_1__c OpexLevel1Rec2;
        private static Deal_OPEX_Additional_Tracking_Level_2__c opexlevel2;
        private static List<Id> opexL1Ids = new List<Id>();
        private static List<OPEX_Tracker__c> opexList = new List<OPEX_Tracker__c>();
        
        private static SRAT_Tracker__c sratTracker;
		private static SRAT_Tracker__c st;
        private static SRAT_Tracker__c sratTracker2;
        private static SRAT_Additional_Tracking_Level_1__c sratLevel1;
        private static SRAT_Additional_Tracking_Level_2__c sratLevel2;
        private static List<SRAT_Tracker__c> sratList = new List<SRAT_Tracker__c>();
		private static List<SRAT_Tracker__c> lstST = new List<SRAT_Tracker__c>();
    	private static List<Export_Fields__c> fieldsList;
        
/*********
Name : setupData
Description : 
*****/       
    static void setupData(){
        Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        Deal__c deal=new Deal__c(Name='Testdeal');
        insert deal;
        Mobilization_Plan__c mobPlan=new Mobilization_Plan__c(Name ='planTest123', Deal__c = deal.id,IsTrackingOn__c = True,Active__c=true);
        insert mobPlan;
        wave=new Wave__c(Name='Wave 1',Mobilization_Plan__c=mobPlan.id,Active__c=True);
        insert wave;
        opexTracker=new OPEX_Tracker__c(Name='Day 60 assessement',Active__c=True,Wave__c=wave.id,Days_After_Go_Live__c=60);
    //    insert opexTracker;
        opexTracker2=new OPEX_Tracker__c(Name='Day 90 assessement',Active__c=True,Wave__c=wave.id,Days_After_Go_Live__c=90);
        opexList.add(opexTracker);
        opexList.add(opexTracker2);
        insert opexList;
        
        OpexLevel1 = new Deal_OPEX_Additional_Tracking_Level_1__c(Name = 'test OPEX level1',OPEX_Tracker_del__c = opexTracker.Id,OPEX_Level_1_Tracking_Type__c = 'Focus the Service operation');
        insert OpexLevel1;
        OpexLevel1Rec2 = new Deal_OPEX_Additional_Tracking_Level_1__c(Name = 'test OPEX level1',OPEX_Tracker_del__c = opexTracker.Id,OPEX_Level_1_Tracking_Type__c = 'Plan the Service operation');
        insert OpexLevel1Rec2;
            
        opexL1Ids.add(OpexLevel1.Id);
        opexL1Ids.add(OpexLevel1Rec2.Id);
		//insert opexL1Ids;
        
		Export_Fields__c strExportFields = new Export_Fields__c(Name = 'test Export fields', 
		Object_Name__c = 'Deal_OPEX_Additional_Tracking_Level_1__c',
		fields_Name__c ='Id,Name,OPEX_Level_1_Tracking_Type__c,Assessment_Notes__c,Assessment_Status__c,OPEX_Tracker__c', 
		Field_Label_Name__c = 'test Field Label', Tracking_on_off__c = true);        
        insert strExportFields;
        fieldsList=new List<Export_Fields__c>();
        fieldsList.add(strExportFields);	
		
    } 
            
/*********
Name : setupData
Description : 
*****/  
    static void setupDataOpexL2Import(){
        Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
 //       email e = 'goudar.devanna@accenture.com';
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        Deal__c deal=new Deal__c(Name='Testdeal');
        insert deal;
        Mobilization_Plan__c mobPlan=new Mobilization_Plan__c(Name ='planTest123', Deal__c = deal.id,IsTrackingOn__c = True,Active__c=true);
        insert mobPlan;
        wave=new Wave__c(Name='Wave 1',Mobilization_Plan__c=mobPlan.id,Active__c=True);
        insert wave;
        opexTracker=new OPEX_Tracker__c(Name='Day 60 assessement',Active__c=True,Wave__c=wave.id,Days_After_Go_Live__c=60);
    //    insert opexTracker;
        opexTracker2=new OPEX_Tracker__c(Name='Day 90 assessement',Active__c=True,Wave__c=wave.id,Days_After_Go_Live__c=90);
        opexList.add(opexTracker);
        opexList.add(opexTracker2);
        insert opexList;
        
        OpexLevel1 = new Deal_OPEX_Additional_Tracking_Level_1__c(Name = 'test OPEX level1',OPEX_Tracker_del__c = opexTracker.Id,OPEX_Level_1_Tracking_Type__c = 'Focus the Service operation');
        insert OpexLevel1;
        OpexLevel1Rec2 = new Deal_OPEX_Additional_Tracking_Level_1__c(Name = 'test OPEX level1',OPEX_Tracker_del__c = opexTracker.Id,OPEX_Level_1_Tracking_Type__c = 'Plan the Service operation');
        insert OpexLevel1Rec2;
        
        opexlevel2 = new Deal_OPEX_Additional_Tracking_Level_2__c(Name='test level2',Answer__c='Yes',Deal_OPEX_Additional_Tracking_Level_1__c=OpexLevel1.Id);
        insert opexlevel2;
    }
    
    
/*********
Name : setupData
Description : 
*****/
    static void setupDataSratL1Import(){
        Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        Deal__c deal=new Deal__c(Name='Testdeal');
        insert deal;
        Mobilization_Plan__c mobPlan=new Mobilization_Plan__c(Name ='planTest123', Deal__c = deal.id,IsTrackingOn__c = True,Active__c=true);
        insert mobPlan;
         Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= mobPlan.id, Planned_Go_Live_Date__c= System.Today()+30);
        insert strWave; 
        
        
        
        SRAT_Master__c sm = new SRAT_Master__c(name='srat days 30',Active__c=TRUE,Days_Before_Go_Live__c=30);
        insert sm;
        //SRAT_Master__c sm = new SRAT_Master__c(name='srat days 30',Active__c=TRUE,Days_Before_Go_Live__c=30);
        //insert sm;
        SRAT_Additional_Tracking_Level1_Master__c sml1 = new SRAT_Additional_Tracking_Level1_Master__c(name='BPO Mobilization Controls',Active__c=true,Question__c='testquest',SRAT_Level1_Tracking_Type__c='BPO Mobilization Controls',SRAT_Master__c=sm.Id);
        insert sml1;
        SRAT_Additional_Tracking_Level2_Master__c sml2 = new SRAT_Additional_Tracking_Level2_Master__c(name='BPO Mobilization Control',Active__c=true,Question__c='testquest2',SRAT_Additional_Tracking_Level1_Master__c=sml1.Id);
        insert sml2;
        
        SRAT_Master__c smRec2 = new SRAT_Master__c(name='srat days 120',Active__c=TRUE,Days_Before_Go_Live__c=120);
        insert smRec2;
        //SRAT_Master__c sm = new SRAT_Master__c(name='srat days 30',Active__c=TRUE,Days_Before_Go_Live__c=30);
        //insert sm;
        SRAT_Additional_Tracking_Level1_Master__c sml1Rec2 = new SRAT_Additional_Tracking_Level1_Master__c(name='BPO Mobilization Controls',Active__c=true,Question__c='testquest',SRAT_Level1_Tracking_Type__c='BPO Mobilization Controls',SRAT_Master__c=smRec2.Id);
        insert sml1Rec2;
        SRAT_Additional_Tracking_Level2_Master__c sml2Rec2 = new SRAT_Additional_Tracking_Level2_Master__c(name='BPO Mobilization Control',Active__c=true,Question__c='testquest2',SRAT_Additional_Tracking_Level1_Master__c=sml1Rec2.Id);
        insert sml2Rec2;
        st = new SRAT_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = mobPlan.Id, Name = 'Day 5 Assessment',Days_Before_Go_Live__c = 5);
        SRAT_Tracker__c st60 = new SRAT_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = mobPlan.Id, Name = 'Day 60 Assessment',Days_Before_Go_Live__c = 60);
		//insert st;
		//insert st60;
        lstST.add(st);
        lstST.add(st60);
        insert lstST;
        sratLevel1 = new SRAT_Additional_Tracking_Level_1__c(SRAT_Level_1_Tracking_Type__c = 'Manage Mobilization Program', Name= 'test name', SRAT_Tracker__c = st.Id, Question__c = 'test Question',Overall_RAG_Status__c = 'NA', Comments__c = 'test Comments');
        insert sratLevel1;
        Export_Fields__c strExportFields = new Export_Fields__c(Name = 'test Export fields', Object_Name__c = 'SRAT_Additional_Tracking_Level_1__c',fields_Name__c ='id,Name,SRAT_Level_1_Tracking_Type__c,Overall_RAG_Status__c,Comments__c', Field_Label_Name__c = 'test Field Label', Tracking_on_off__c = true);        
        insert strExportFields;
        fieldsList=new List<Export_Fields__c>();
        fieldsList.add(strExportFields);
    }
        /*********
        Name : TestSratL1Import
        Description : 
        *****/    
    static testMethod void TestSratL1Import() {
        Test.startTest();
        setupDataSratL1Import();
        ctrl = new ImportSrat();
        PageReference tpageRef = Page.ImportSrat_VFP;
        Test.setCurrentPage(tpageRef);
        tpageRef.getParameters().put(UtilConstants.REC_ID,lstST[0].id); 
        ctrl.allLines_SratLevel1 ='SratLevel2Export'+'\n\n'+'Id»Name»SRAT_Level_1_Tracking_Type__c»Overall_RAG_Status__c»Comments__c\n'+sratLevel1.id+'»test name»Manage Mobilization Program»NA»test Comments\n';       
        pref = ctrl.uploadFile();
        Test.stopTest();
    }
	static testMethod void TestOpexLevel1Import() {
        Test.startTest();
         setupData();
        ctrl = new ImportSrat();
        PageReference tpageRef = Page.ImportOpex_VFP;
        Test.setCurrentPage(tpageRef);
        tpageRef.getParameters().put(UtilConstants.REC_ID,opexList[0].id); 
        ctrl.allLines_OpexLevel1 ='OpexLevel2Export'+'\n\n'+'Id»Name»SRAT_Level_1_Tracking_Type__c»Overall_RAG_Status__c»Comments__c\n'+OpexLevel1.id+'»test name»Manage Mobilization Program»NA»test Comments\n';       
        pref = ctrl.uploadFile();
        Test.stopTest();
    }

}