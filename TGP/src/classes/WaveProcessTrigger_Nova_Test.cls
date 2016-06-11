/**
 * Name : WaveProcessTrigger_Nova_Test
 * Author : NovaCop Unit Test Generator
 * Description : Test class used for testing the WaveProcessTrigger
 * Date : 3/18/15 6:19 PM 
 * Version : <intial Draft> 
 * TODO : This code is auto-generated. Developer should update the inputs for unit tests as well as expected results in assertions
 */
@isTest
private class WaveProcessTrigger_Nova_Test { 
     static User testUser;
    static list<Wave_Proc__c> listWaveProc;
/*
  @Author: 
  @Name: setupData
  @Created Date: 01 January 2015
  @Description: This is a static method setupData for data setup for testing.
  @version: 1.0
*/
     public static void setupData(){
     Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        Deal__c dealObj=new Deal__c(Name='Testdeal');
    insert dealObj;
    Mobilization_Plan__c mob_Obj=new Mobilization_Plan__c(Name ='planTest123', Deal__c = dealObj.id,IsTrackingOn__c = True,Active__c=True);
    insert mob_Obj;
    Wave__c wav_Obj=new Wave__c(Name='testWave',Mobilization_Plan__c=mob_Obj.id,Is_Procurement_Tracking_Applicable__c=true,Active__c=True);
    insert wav_Obj;

        
        Procurement_General_Activity_Master__c procMaster=new Procurement_General_Activity_Master__c(Name='promastertest',Active__c=true,Activity_Description__c='test',Activity_Order__c=2.0,Type__c='testype');
       insert procMaster;
        
         
    Offering_Master__c offeringMaster=new Offering_Master__c(name='Sourcing and Procurement',offering_description__c='test',flywheel_non_flywheel__c='Yes');
         insert offeringMaster;
         Services_Master__c serMaster=new Services_Master__c(name='Sourcing and Category Management Service',offering__c=offeringMaster.id);
         insert serMaster;
    Services_Component_Master__c SericeComMaster=new Services_Component_Master__c(name='Sourcing and Category Management Service',service__c=serMaster.id, service_component_description__c='test');
    insert SericeComMaster;
    Client_Specific_Process__c clientSP=new Client_Specific_Process__c(Process_Offering__c=offeringMaster.id,Process_Services__c=serMaster.id,Deal__c=dealObj.id);  
        insert clientSP;
        Wave_Proc__c wave_proccTest =  new Wave_Proc__c(Wave__c = wav_Obj.id,Wave_Client_Specific_Process__c=clientSP.id);
        insert wave_proccTest;
        listWaveProc=new list<Wave_Proc__c>();
        listWaveProc.add(wave_proccTest);
     }
    
/*
  @Author: 
  @Name: testWaveProcessTrigger
  @Created Date: 01 January 2015
  @Description:This is a test method testWaveProcessTrigger for testing the updation wave.
  @version: 1.0
*/      
     static testMethod  void testWaveProcessTrigger(){
    test.starttest();
        setupData();
        System.runAs(testUser) {
        
            WaveProcess.updateWave(listWaveProc);
        }
         
    }
}