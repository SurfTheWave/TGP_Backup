/**
   @Author : 
   @name   : exportOpexChecklistController_Test
   @CreateDate :  
   @Description : 
   @Version : 1.0 
   
  */
@isTest
private class exportOpexChecklistController_Test{    

        private static User testUser;
        private static SRAT_Tracker__c st; 
        private static Opex_Tracker__c OpexTracker;
        /**********
     * @method :setUpdata1
     * @purpose :
     
    **********/
        static void setUpdata1(){
             Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);        
            testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);        
            Database.insert(testUser, false);
            List<Id> lstopexLevel1Ids = new List<Id>();
            //creating Deal test data..
            Deal__c strDeal = new Deal__c(Name='DealTest123');
            insert strDeal;
            //inserting New Plan under Deal.
            Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = strDeal.id, Active__c = True, IsTrackingOn__c = True);
            insert strmobplan;
            //Inserting new Wave        
            Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today()+30);
            insert strWave;            
                    
            List<SRAT_Tracker__c> lstST = new List<SRAT_Tracker__c>();
            SRAT_Tracker__c SratDel = new SRAT_Tracker__c();
            SratTrackerClass STclass = new SratTrackerClass(); 
            //List<SRAT_Additional_Tracking_Level_1__c> SratLevel1Lst = new List<SRAT_Additional_Tracking_Level_1__c>();
             st = new SRAT_Tracker__c(Name = 'Day 5 Assessment', Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Days_Before_Go_Live__c = 5,Active__c = True);
                SRAT_Tracker__c st30 = new SRAT_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 30 Assessment',Days_Before_Go_Live__c = 30);
            //   insert st;
            //   insert st30;
            lstST.add(st);
            lstST.add(st30);
            insert lstST;
            
            List<SRAT_Additional_Tracking_Level_1__c> SratLevel1Lst = new List<SRAT_Additional_Tracking_Level_1__c>();
            SRAT_Additional_Tracking_Level_1__c strAddTrackLevel = new SRAT_Additional_Tracking_Level_1__c(SRAT_Level_1_Tracking_Type__c = 'Manage Mobilization Program', Name= 'test name', SRAT_Tracker__c = lstST[0].Id, Question__c = 'test Question',Overall_RAG_Status__c = 'NA', Comments__c = 'test Comments');
            SratLevel1Lst.add(strAddTrackLevel);
            insert SratLevel1Lst;
           
            List<SRAT_Additional_Tracking_Level_2__c> sratLevel2Lst = new List<SRAT_Additional_Tracking_Level_2__c>();
            SRAT_Additional_Tracking_Level_2__c strAddTrackLevel2 = new SRAT_Additional_Tracking_Level_2__c(Name = 'test Lvel2', SRAT_Additional_Tracking_Level_1__c = SratLevel1Lst[0].Id, SRAT_Level_1_Tracking_Type__c = 'Manage Mobilization Program', Section__c = 'test Section', Question__c = 'test Question', Category__c = 'People', RAG_Status__c = 'NA', Comments__c  = 'test Success');
            sratLevel2Lst.add(strAddTrackLevel2);
            insert sratLevel2Lst; 
            }
            /**********
       * @method :setUpdata
       * @purpose :
       
      **********/
            static void setUpdata(){
                Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);        
                testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);        
                Database.insert(testUser, false);
                 //creating Deal test data..
                Deal__c strDeal = new Deal__c(Name='DealTest123');
                insert strDeal;
                //inserting New Plan under Deal.
                Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = strDeal.id, Active__c = True, IsTrackingOn__c = True);
                insert strmobplan;
                //Inserting new Wave        
                Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today()+30);
                insert strWave;             
                List<Opex_Tracker__c> opex = new List<Opex_Tracker__c>();
                OpexTracker = new Opex_Tracker__c (Name = 'Day 1 Assessment', Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Days_After_Go_Live__c = 5, Active__c = True);
                Opex_Tracker__c OpexTracker30 = new Opex_Tracker__c (Name = 'Day 30 Assessment', Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Days_After_Go_Live__c = 30, Active__c = True);
                //insert OpexTracker;
                opex.add(OpexTracker);
                opex.add(OpexTracker30);
                insert opex;
                //Opex_Tracker__c OpexTracker1 = new Opex_Tracker__c (Name = 'Day 30 Assessment', Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Days_After_Go_Live__c = 30, Active__c = True);
                //insert OpexTracker1;            
                //opex.add(OpexTracker1);
                
                List<Deal_OPEX_Additional_Tracking_Level_1__c> OpexLevel1Lst = new List<Deal_OPEX_Additional_Tracking_Level_1__c>();
                Deal_OPEX_Additional_Tracking_Level_1__c strDealOPEX = new Deal_OPEX_Additional_Tracking_Level_1__c(Name='test deal', OPEX_Tracker_del__c = opex[0].Id, OPEX_Level_1_Tracking_Type__c = 'Focus the Service operation');
                //insert strDealOPEX;
                OpexLevel1Lst.add(strDealOPEX);
                insert OpexLevel1Lst;
             //   lstopexLevel1Ids.add(OpexLevel1Lst[0].Id);
                
                List<Deal_OPEX_Additional_Tracking_Level_2__c> opexLevel2Lst = new List<Deal_OPEX_Additional_Tracking_Level_2__c>();
                Deal_OPEX_Additional_Tracking_Level_2__c strOpexLevel2 = new Deal_OPEX_Additional_Tracking_Level_2__c(Name = 'test Question', Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1Lst[0].Id);
                opexLevel2Lst.add(strOpexLevel2);
                insert opexLevel2Lst;
            
            }
            
            /**********
       * @method :opeartaionOnAddTeamTest
       * @purpose :
       
      **********/
            static testMethod void opeartaionOnAddTeamTest(){
            
                Test.startTest();        
                setUpdata1();
                PageReference pageRefSrat= Page.ExportSratLevel1_VFP;
                Test.setCurrentPageReference(pageRefSrat);
                ApexPages.currentPage().getParameters().put('recordId', st.id);
                pageRefSrat.getParameters().put('objName', 'SRAT_Additional_Tracking_Level_1__c');
                ExportOpexChecklistController exportCheck = new ExportOpexChecklistController();
                exportCheck.exportSratLevel1Level2(); 
                Test.stopTest();
            }
            /**********
       * @method :opeartaionOnOpexTracker
       * @purpose :
       
      **********/
            static testMethod void opeartaionOnOpexTracker(){
    
                Test.startTest();        
                setupData();
                PageReference pageRef= Page.ExportOpexChecklistCSV_VFP; 
                Test.setCurrentPageReference(pageRef);  
                ApexPages.currentPage().getParameters().put('recordId', OpexTracker.id);
                pageRef.getParameters().put('objName', 'Deal_OPEX_Additional_Tracking_Level_1__c');  
                ExportOpexChecklistController exportCheck = new ExportOpexChecklistController();
                exportCheck.exportToCSV();
                Test.stopTest();        
        }
   }