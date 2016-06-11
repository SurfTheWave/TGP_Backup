/**
 * Name : WaveTrigger_Nova_Test
 * Author : NovaCop Unit Test Generator
 * Description : Test class used for testing the WaveTrigger
 * Date : 3/20/15 5:35 PM 
 * Version : <intial Draft> 
 * TODO : This code is auto-generated. Developer should update the inputs for unit tests as well as expected results in assertions
 */
@isTest
private class WaveTrigger_Nova_Test { 
    static User testUser;
    /**
    *  @Description        : 
    *  @name               : 
    *  @param              : 
    *  @return parameter   : 
    *  @throws exception   : 
    */
    public static void setupData(){
       Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        Deal__c dealObj=new Deal__c(Name='Testdeal');
    insert dealObj;
    Mobilization_Plan__c mob_Obj=new Mobilization_Plan__c(Name ='planTest123', Deal__c = dealObj.id,IsTrackingOn__c = True,Active__c=True);
    insert mob_Obj;
    Wave__c wav_Obj=new Wave__c(Name='testWave',Mobilization_Plan__c=mob_Obj.id,Is_Procurement_Tracking_Applicable__c=true,
                                    Procurement_Q1_Start_Date__c= System.Today()+20,Active__c=True);
    insert wav_Obj;
        
        wave__c waveUpdate=[select id,Procurement_Q1_Start_Date__c from wave__C where id=:wav_Obj.id limit 5000];
        
        waveUpdate.Procurement_Q1_Start_Date__c=System.Today()+11;
        update waveUpdate;
        
        Wave__c wav_Obj1=new Wave__c(id=wav_Obj.id,Procurement_Q1_Start_Date__c= System.Today()+26);
        update wav_Obj1;
         Wave__c wav_Obj2=new Wave__c(id=wav_Obj1.id,Active__c=false);
        update wav_Obj2;
        delete wav_Obj2;
    }
    /**
    *  @Description        : 
    *  @name               : 
    *  @param              : 
    *  @return parameter   : 
    *  @throws exception   : 
    */
     public static void setupData1(){
       Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME,'test1@testorg.com');
        Database.insert(testUser, false);
        Deal__c dealObj=new Deal__c(Name='Testdeal');
    insert dealObj;
    Mobilization_Plan__c mob_Obj=new Mobilization_Plan__c(Name ='planTest123', Deal__c = dealObj.id,IsTrackingOn__c = True,Active__c=True);
    insert mob_Obj;
    Wave__c wav_Obj=new Wave__c(Name='testWave',Mobilization_Plan__c=mob_Obj.id,Is_Procurement_Tracking_Applicable__c=true,
                                    Procurement_Q1_Start_Date__c= System.Today()+20,Active__c=True);
    insert wav_Obj;
        Wave__c wav_Obj1=new Wave__c(id=wav_Obj.id,Procurement_Q1_Start_Date__c= System.Today()+26);
        update wav_Obj1;
         Wave__c wav_Obj2=new Wave__c(id=wav_Obj1.id,Active__c=false);
        update wav_Obj2;
        delete wav_Obj2;
    }
    /**
    *  @Description        : 
    *  @name               : 
    *  @param              : 
    *  @return parameter   : 
    *  @throws exception   : 
    */
     static testMethod  void testWaveTrigger1(){
     Test.starttest();  
         setupData1();
         Test.stoptest();
    }
     
    /**
    *  @Description        : 
    *  @name               : 
    *  @param              : 
    *  @return parameter   : 
    *  @throws exception   : 
    */
    static testMethod void testProcurement(){
        Test.startTest();
            Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
            testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME,'test1@testorg.com');
            Database.insert(testUser, false);
            
            Deal__c deal=new Deal__c(name='Test Deal');
            insert deal;
            
            Mobilization_Plan__c mobPlan=new Mobilization_Plan__c(Deal__C=deal.id);
            insert mobPlan;
            
            Procurement_Quarter_Wise_Activity_Master__c procMaster=new Procurement_Quarter_Wise_Activity_Master__c(name='test',Active__c=TRUE,Activity_Description__c='Test',Activity_Order__c=2,TYPE__c='test');
            insert procMaster;
            
            List<Wave__c> waveList=new List<Wave__c>();
            
            Wave__C wave=new Wave__C(Mobilization_Plan__c=mobPlan.id,Is_Procurement_Tracking_Applicable__c=true,
                                    Active__c=True,Procurement_Q1_Start_Date__c=System.today());
          insert (wave);
            
            
            wave.Procurement_Q1_Start_Date__c=System.today()+10; 
            
            update wave;
            
            
             Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= mobPlan.id, Planned_Go_Live_Date__c= System.Today()+30);
            insert strWave; 
           List<Procurement_Quarter_Wise_Activity_Item__c> PQWAItemList = new List<Procurement_Quarter_Wise_Activity_Item__c>();
           Procurement_Quarter_Wise_Activity_Item__c PQWAItem = new Procurement_Quarter_Wise_Activity_Item__c (Name = 'TestItem', Active__c = true ,Wave__c =strWave.Id, Type__c = 'Test',Quarter_dd__c = 'Q2', Value__c = 50);
           PQWAItemList.add(PQWAItem);
           Procurement_Quarter_Wise_Activity_Item__c PQWAItem2 = new Procurement_Quarter_Wise_Activity_Item__c (Name = 'TestItem2', Active__c = true ,Wave__c =strWave.Id, Type__c = 'Test',Quarter_dd__c = 'Q2', Value__c = 50);
           PQWAItemList.add(PQWAItem2);
           Insert PQWAItemList;
           PQWAItemList[0].name = UtilConstants.TOTAL_SAVE_TODATE;
           PQWAItemList[0].Value__c = 90;
           PQWAItemList[1].name = UtilConstants.TOTAL_SAVE_TARGET;
           PQWAItemList[1].Value__c = 80;
           Update PQWAItemList;
            
            Test.stopTest();
    }
    
    /**
    *  @Description        : 
    *  @name               : 
    *  @param              : 
    *  @return parameter   : 
    *  @throws exception   : 
    */
    static testMethod void testWaveTriggerApex(){
        Test.startTest();
            Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
            testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME,'test1@testorg.com');
            Database.insert(testUser, false);
            
            Deal__c deal=new Deal__c(name='Test Deal');
            insert deal;
            
            Mobilization_Plan__c mobPlan=new Mobilization_Plan__c(Deal__C=deal.id);
            insert mobPlan;
            
          Recruitement_Activity_Master__c recruitTest=new Recruitement_Activity_Master__c(name='test',Activity_Order__c=2);
            insert recruitTest;
        
          KT_Activity_Master__c ktTest=new KT_Activity_Master__c(name='test',Activity_Order__c=2);
          insert ktTest;
        
          Tech_WE_Activity_Master__c techMaster = new Tech_WE_Activity_Master__c(name='test',Activity_Order__c=2);
          insert techMaster;
        
          SRAT_Master__c sratMaster=new SRAT_Master__c(name='test',Item_Order__c=2.0,Days_Before_Go_Live__c=2.0);
          insert sratMaster;
        
          OPEX_Master__c opexMaster=new OPEX_Master__c(name='test',Item_Order__c=2.0,Days_After_Go_Live__c=2.0);
          insert opexmaster;
                
            Wave__C wave=new Wave__C(Mobilization_Plan__c=mobPlan.id,isTrackingOn__c=true);
          insert (wave);
            
            Test.stopTest();
    }
}