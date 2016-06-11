/*********
Name : ImportOpexSratChecklist_Test
Description : 
*****/
@isTest
private class ImportOpexSratChecklist_Test{
        private static ImportOpexSratChecklist ctrl;
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
        private static SRAT_Tracker__c sratTracker2;
        private static SRAT_Additional_Tracking_Level_1__c sratLevel1;
        private static SRAT_Additional_Tracking_Level_2__c sratLevel2;
        private static List<SRAT_Tracker__c> sratList = new List<SRAT_Tracker__c>();
        
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
        
      //   ktracker1=new KT_Trac__c(id=ktracker.id,Active__c=false,Wave__c=wave.id);
     //   update ktracker1;
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
        
     //    ktracker1=new KT_Trac__c(id=ktracker.id,Active__c=false,Wave__c=wave.id);
     //   update ktracker1;
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
        wave=new Wave__c(Name='Wave 1',Mobilization_Plan__c=mobPlan.id,Active__c=True);
        insert wave;
        sratTracker=new  SRAT_Tracker__c(Name = 'Day 5 Assessment', Wave__c = wave.Id, Mobilization_Plan__c = mobPlan.Id, Days_Before_Go_Live__c = 5,Active__c = True);
        sratTracker2=new  SRAT_Tracker__c(Name = 'Day 5 Assessment', Wave__c = wave.Id, Mobilization_Plan__c = mobPlan.Id, Days_Before_Go_Live__c = 90,Active__c = True);
    //    insert sratTracker;
        sratList.add(sratTracker);
        sratList.add(sratTracker2);
        insert sratList;
        
        sratLevel1 = new SRAT_Additional_Tracking_Level_1__c(SRAT_Level_1_Tracking_Type__c = 'Manage Mobilization Program', Name= 'test name', SRAT_Tracker__c = sratTracker.Id, Question__c = 'test Question',Overall_RAG_Status__c = 'NA', Comments__c = 'test Comments');
        insert sratLevel1;
    }

/*********
Name : setupData
Description : 
*****/
static void setupDataSratL2Import(){
        Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        Deal__c deal=new Deal__c(Name='Testdeal');
        insert deal;
        Mobilization_Plan__c mobPlan=new Mobilization_Plan__c(Name ='planTest123', Deal__c = deal.id,IsTrackingOn__c = True,Active__c=true);
        insert mobPlan;
        wave=new Wave__c(Name='Wave 1',Mobilization_Plan__c=mobPlan.id,Active__c=True);
        insert wave;
        sratTracker=new  SRAT_Tracker__c(Name = 'Day 5 Assessment', Wave__c = wave.Id, Mobilization_Plan__c = mobPlan.Id, Days_Before_Go_Live__c = 5,Active__c = True);
        sratTracker2=new  SRAT_Tracker__c(Name = 'Day 5 Assessment', Wave__c = wave.Id, Mobilization_Plan__c = mobPlan.Id, Days_Before_Go_Live__c = 90,Active__c = True);
    //    insert sratTracker;
        sratList.add(sratTracker);
        sratList.add(sratTracker2);
        insert sratList;
        
        sratLevel1 = new SRAT_Additional_Tracking_Level_1__c(SRAT_Level_1_Tracking_Type__c = 'Manage Mobilization Program', Name= 'test name', SRAT_Tracker__c = sratTracker.Id, Question__c = 'test Question',Overall_RAG_Status__c = 'NA', Comments__c = 'test Comments');
        insert sratLevel1;
        
        sratLevel2 = new SRAT_Additional_Tracking_Level_2__c(Name='test srat level2',SRAT_Level_1_Tracking_Type__c = 'Manage Mobilization Program',SRAT_Additional_Tracking_Level_1__c=sratLevel1.Id, Section__c='test section', Category__c = 'test category', RAG_Status__c='NA', Comments__c = 'test comments');
        insert sratLevel2;
        
    }

    
/*********
Name : setupData
Description : 
*****/  
    static testMethod void Test1() {

        Test.startTest();
        setupData();
        ctrl = new ImportOpexSratChecklist();
        PageReference tpageRef = Page.ImportOpexLevel1_VFP;
        Test.setCurrentPage(tpageRef);
    //    ApexPages.currentPage().getParameters().put('recordId', opexTracker.id);
    //    tpageRef.getParameters().put('objName', 'KT_Trac__c'); 
    //    ctrl.contentFile = Blob.valueOf('Id,Name,Wave__r.name,Completion_Status__c,Actual_Start_Date__c,Actual_End_Date__c,Active__c,Milestone__c,Tracking_Comments__c\n'+ktracker.id+',Knowledge Transfer Plan11,"Wave 1",,10/12/2015,,true,false,test\r\n');
        ctrl.contentFile = Blob.valueOf('Id,Name,OPEX_Level_1_Tracking_Type__c,OPEX_Tracker_del__c.name\n'+OpexLevel1.id+',Focus the Service operation,Focus the Service operation,Day 60 assessement \r\n'+OpexLevel1Rec2.id+',Plan the Service operation,Plan the Service operation,Day 60 assessement \r\n');
                
        pref = ctrl.OpexL1Import();
            
     //   pref = ext.cancel();
     //   UtilImportTrackers_VFC.addError('CustomError');
        Test.stopTest();
    }
    
/*********
Name : setupData
Description : 
*****/    
    static testMethod void TestOpexL2Import() {

        Test.startTest();
        setupDataOpexL2Import();
        ctrl = new ImportOpexSratChecklist();
        PageReference tpageRef = Page.ImportOpexLevel2_VFP;
        Test.setCurrentPage(tpageRef);
        ctrl.contentFile = Blob.valueOf('Id,OPEX_Level_1_Tracking_Type__c,Name,Answer__c\n'+opexlevel2.id+',"Focus the Service operation","test opex level2","Yes"\n');
                
        pref = ctrl.OpexL2Import();
            
        Test.stopTest();
    }
    
/*********
Name : setupData
Description : 
*****/    
    static testMethod void TestSratL1Import() {

        Test.startTest();
        setupDataSratL1Import();
        ctrl = new ImportOpexSratChecklist();
        PageReference tpageRef = Page.ImportSratLevel1_VFP;
        Test.setCurrentPage(tpageRef);
        ctrl.contentFile = Blob.valueOf('Id,Name,SRAT_Level_1_Tracking_Type__c,Overall_RAG_Status__c,Comments__c\n'+sratLevel1.id+',"test name","Manage Mobilization Program","NA","test Comments"\n');
                
        pref = ctrl.SratL1Import();
            
        Test.stopTest();
    }
    
/*********
Name : setupData
Description : 
*****/    
        static testMethod void TestSratL2Import() {

        Test.startTest();
        setupDataSratL2Import();
        ctrl = new ImportOpexSratChecklist();
        PageReference tpageRef = Page.ImportSratLevel2_VFP;
        Test.setCurrentPage(tpageRef);
        ctrl.contentFile = Blob.valueOf('Id,Name,SRAT_Level_1_Tracking_Type__c,Section__c,Category__c,RAG_Status__c,Comments__c\n'+sratLevel2.id+',"test sratlevel1","Manage Mobilization Program","test section","test category","NA","test comments"\n');
                
        pref = ctrl.SratL2Import();
            
        Test.stopTest();
    }
    
}