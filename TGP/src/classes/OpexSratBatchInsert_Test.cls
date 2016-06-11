@isTest
/*
@name : OpexSratBatchInsert_Test
@CreateDate : 4/8/2015 3:51 AM
@Description : 
@Version : 
*/
private class OpexSratBatchInsert_Test{    

        private static User testUser;
        private static SRAT_Tracker__c st; 
        private static Opex_Tracker__c OpexTracker;
        
/*
@name : test1
@Description : 
@Version : 
*/
        static testMethod void test1(){
            
            Test.starttest();
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
            List<Wave__c> lstWave = new List<Wave__c>();
            Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today()+30);
            insert strWave;  
            lstWave.add(strWave);
                        
              
            OPEX_Master__c om = new OPEX_Master__c(Name= 'Day 7 Assessment', Days_After_Go_Live__c = 7,Active__c = TRUE);
            insert om;
            OPEX_Master__c om30 = new OPEX_Master__c(Name= 'Day 30 Assessment', Days_After_Go_Live__c = 30,Active__c = TRUE);
            insert om30;
            OPEX_Master__c om60 = new OPEX_Master__c(Name= 'Day 60 Assessment', Days_After_Go_Live__c = 60,Active__c = TRUE);
            insert om60;
            
            SRAT_Master__c sm = new SRAT_Master__c(name='srat days 30',Active__c=TRUE,Days_Before_Go_Live__c=30);
            insert sm;
            SRAT_Master__c sm60 = new SRAT_Master__c(name='srat days 60',Active__c=TRUE,Days_Before_Go_Live__c=60);
            insert sm60;
            SRAT_Master__c sm90 = new SRAT_Master__c(name='srat days 90',Active__c=TRUE,Days_Before_Go_Live__c=90);
            insert sm90;
            
            OPEX_Additional_Tracking_Level1_Master__c om1 = new OPEX_Additional_Tracking_Level1_Master__c(name='Focus the Service operation', Active__c=TRUE, OPEX_Level_1_Tracking_Type__c= 'Focus the Service operation',OPEX_Master__c=om.Id);
            insert om1;
            OPEX_Additional_Tracking_Level1_Master__c om1Rec2 = new OPEX_Additional_Tracking_Level1_Master__c(name='Focus the Service operation', Active__c=TRUE, OPEX_Level_1_Tracking_Type__c= 'Focus the Service operation',OPEX_Master__c=om30.Id);
            insert om1Rec2;
            OPEX_Additional_Tracking_Level1_Master__c om1Rec3 = new OPEX_Additional_Tracking_Level1_Master__c(name='Focus the Service operation', Active__c=TRUE, OPEX_Level_1_Tracking_Type__c= 'Focus the Service operation',OPEX_Master__c=om60.Id);
            insert om1Rec3;
            
            SRAT_Additional_Tracking_Level1_Master__c sml1 = new SRAT_Additional_Tracking_Level1_Master__c(name='BPO Mobilization Controls',Active__c=true,Question__c='testquest',SRAT_Level1_Tracking_Type__c='BPO Mobilization Controls',SRAT_Master__c=sm.Id);
            insert sml1;
            SRAT_Additional_Tracking_Level1_Master__c sml1Rec2 = new SRAT_Additional_Tracking_Level1_Master__c(name='BPO Mobilization Controls',Active__c=true,Question__c='testquest',SRAT_Level1_Tracking_Type__c='BPO Mobilization Controls',SRAT_Master__c=sm60.Id);
            insert sml1Rec2;
            SRAT_Additional_Tracking_Level1_Master__c sml1Rec3 = new SRAT_Additional_Tracking_Level1_Master__c(name='BPO Mobilization Controls',Active__c=true,Question__c='testquest',SRAT_Level1_Tracking_Type__c='BPO Mobilization Controls',SRAT_Master__c=sm90.Id);
            insert sml1Rec3;
            
            
            OPEX_Additional_Tracking_Level2_Master__c om2 = new OPEX_Additional_Tracking_Level2_Master__c(name='Focus the Service operation Question 1',Active__c= TRUE, OPEX_Additional_Tracking_Level1_Master__c=om1.Id,Question__c='testq1');
            insert om2;
            OPEX_Additional_Tracking_Level2_Master__c om2Rec2 = new OPEX_Additional_Tracking_Level2_Master__c(name='Focus the Service operation Question 1',Active__c= TRUE, OPEX_Additional_Tracking_Level1_Master__c=om1Rec2.Id,Question__c='testq1');
            insert om2Rec2;
            OPEX_Additional_Tracking_Level2_Master__c om2Rec3 = new OPEX_Additional_Tracking_Level2_Master__c(name='Focus the Service operation Question 1',Active__c= TRUE, OPEX_Additional_Tracking_Level1_Master__c=om1Rec3.Id,Question__c='testq1');
            insert om2Rec3;
            
            SRAT_Additional_Tracking_Level2_Master__c sml2 = new SRAT_Additional_Tracking_Level2_Master__c(name='BPO Mobilization Control',Active__c=true,Question__c='testquest2',SRAT_Additional_Tracking_Level1_Master__c=sml1.Id);
            insert sml2;
            SRAT_Additional_Tracking_Level2_Master__c sml2Rec2 = new SRAT_Additional_Tracking_Level2_Master__c(name='BPO Mobilization Control',Active__c=true,Question__c='testquest2',SRAT_Additional_Tracking_Level1_Master__c=sml1Rec2.Id);
            insert sml2Rec2;
            SRAT_Additional_Tracking_Level2_Master__c sml2Rec3 = new SRAT_Additional_Tracking_Level2_Master__c(name='BPO Mobilization Control',Active__c=true,Question__c='testquest2',SRAT_Additional_Tracking_Level1_Master__c=sml1Rec3.Id);
            insert sml2Rec3;
            
            
              
            List<OPEX_Tracker__c> lstOT = new List<OPEX_Tracker__c>();  
              
            OPEX_Tracker__c ot = new OPEX_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 7 Assessment',Days_After_Go_Live__c=7,OPEX_Master__c=om.Id);
    //    insert ot; 
        
            OPEX_Tracker__c ot30 = new OPEX_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 30 Assessment',Days_After_Go_Live__c=30,OPEX_Master__c=om30.Id);
     //   insert ot2;  
            OPEX_Tracker__c ot60 = new OPEX_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 30 Assessment',Days_After_Go_Live__c=60,OPEX_Master__c=om60.Id);
            lstOT.add(ot);
            lstOT.add(ot30);
            lstOT.add(ot60);
        //  insert lstOT;
                          
            WaveTrackerApex waveapex = new WaveTrackerApex();
              
            waveapex.insertSRATracking(lstWave);
            waveapex.insertOPEXTracking(lstWave);
              
            Test.stoptest();
        /*
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
            */
            
            
            }
                                
   }