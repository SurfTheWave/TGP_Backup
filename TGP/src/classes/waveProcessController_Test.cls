@isTest
/*
  @Author: 
  @Name: VF_OppTeamController_Test 
  @Created Date: 14 May 2015
  @Description:This is a test class waveProcessController_Test for waveProcessController controller .
  @version: 1.0
*/
private class waveProcessController_Test {
    static User testUser;
    static Profile p;
    static Wave_Proc__c wave_proccTest;
    static Services_Master__c serMaster;
    static Offering_Master__c offeringMaster;
    static Services_Component_Master__c SericeComMaster;
    static Client_Specific_Process__c clientSP;
    static Infrastructure_Service__c infrastructureSP;
    static Delivery_Location_Masters__c location;
    static Country_Master__c countryMaster;
    static Wave__c wav_Obj;
    static Mobilization_Plan__c mob_Obj;
    static Deal__c dealObj;
/*
  @Author: Madhusudhan
  @Name: setupData
  @Created Date: 14 May 2015
  @Description:this is a test method setupData for data setup.
  @version: 1.0
*/
       public static void setupData(){
        p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        
        Offering_Master__c offProc=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
        insert offProc;
        Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
        insert customSetting;
        
        
         List<Opportunity> oppList = UnitTestDatafactory.createOppList('TestOppty',1);
         Offering_Master__c offMaster = new Offering_Master__c(Name = UtilConstants.HR, offering_description__c = UtilConstants.TEST_DESC, 
                                                                flywheel_non_flywheel__c = UtilConstants.FLYWHEEL, Service_Group__c=UtilCOnstants.BPO);
         insert offMaster;
        
          Solution_Scope__c solComp = new Solution_Scope__c();
          solComp.Offering_Master__c = offMaster.id;
          solComp.Opportunity__c = oppList[0].Id;
          insert solComp;
          
          /*
          List<Solution_Scope__c> sList = [SELECT Id, Name, Offering_Master__r.Name FROM Solution_Scope__c WHERE Opportunity__C =:oppList[0].Id];
          System.debug('slist ->' + slist);
            */

        dealObj=new Deal__c(Name='Testdeal', Opportunity__C = oppList[0].Id);
        insert dealObj;
        mob_Obj=new Mobilization_Plan__c(Name ='planTest123', Deal__c = dealObj.id,Service_Group__c = 'BPO');
        insert mob_Obj;
        wav_Obj=new Wave__c(Name='testWave',Mobilization_Plan__c=mob_Obj.id,Is_Procurement_Tracking_Applicable__c=true,Active__c=True);
        insert wav_Obj;
        /*
        offeringMaster=new Offering_Master__c(name= UtilConstants.HR ,offering_description__c='test',flywheel_non_flywheel__c='Yes', Service_Group__c=UtilCOnstants.BPO);
         insert offeringMaster;
         */
         serMaster=new Services_Master__c(name= UtilConstants.HR,offering__c=offMaster.id);
         insert serMaster;
        SericeComMaster=new Services_Component_Master__c(name='Sourcing and Category Management Service',service__c=serMaster.id, service_component_description__c='test');
        insert SericeComMaster;
        clientSP=new Client_Specific_Process__c(name='clientprocess',Process_Offering__c=offMaster.id,Process_Services__c=serMaster.id,Deal__c=dealObj.id);  
        insert clientSP;
        //infrastructureSP=new Infrastructure_Service__c(name='infraservice',ServiceOffering__c=offeringMaster.id,SubService__c=serMaster.id,Deal__c=dealObj.id);
        //insert infrastructureSP;  
        countryMaster=new Country_Master__c(Name='India');
        insert countryMaster;
        location=new Delivery_Location_Masters__c(Name='India-Hyderabad',country__c=countryMaster.id);
        insert location;
        }
/*
  @Name: waveProcessMethod
  @Created Date: 14 May 2015
  @Description:This is a test method waveProcessMethod for wave process refresh page,record save etc.
  @version: 1.0
*/
    static testMethod void waveProcessMethod(){
            
        test.starttest();
        setupData();
       // system.runAs(testUser){
        wave_proccTest =  new Wave_Proc__c(Wave__c = wav_Obj.id,Wave_Client_Specific_Process__c=clientSP.id,
         Sending_Location__c = location.id,
        Number_of_Projected_FTEs__c = 32, Wave_Process_Location__c  = location.id,Mobilization_Plan__c = mob_Obj.id);
        insert wave_proccTest;      
        
            PageReference tpageRef = Page.WaveProcess_VFP;
            
            Test.setCurrentPage(tpageRef);
            ApexPages.currentPage().getParameters().put('id',wave_proccTest.id);
            ApexPages.StandardController testController=new ApexPages.StandardController(wave_proccTest); 
            waveProcessController waveProcess=new waveProcessController(testController);
            waveProcess.ClientProcessLookUpStr='clientprocess';
            waveProcess.InfrastructLookUpStr='infraservice';
            waveProcess.SendLocLookUpStr='India-Hyderabad';
            waveProcess.RecvLocLookUpStr='India-chennai';
            waveProcessController.getData1('');
            waveProcess.saveRecord();   
            waveProcess.refreshPg();
        
        //wave_proccTest =  new Wave_Proc__c(Wave__c = wav_Obj.id,Wave_Client_Specific_Process__c=clientSP.id,Wave_Infrastructure_Service__c=infrastructureSP.id, Sending_Location__c = location.id, Wave_Process_Location__c  = location.id);
        //insert wave_proccTest;      
          
          wave_proccTest =  new Wave_Proc__c(Wave__c = wav_Obj.id , Mobilization_Plan__c =mob_Obj.Id );
        //insert wave_proccTest;  
         PageReference wavePageErr = Page.WaveProcess_VFP;
            Test.setCurrentPage(wavePageErr );
            ApexPages.StandardController testController2=new ApexPages.StandardController(wave_proccTest); 
            waveProcessController waveProcess2=new waveProcessController(testController2);
            waveProcess2.saveRecord();   
            waveProcess2.refreshPg();
            
            /*
            
             Wave_Proc__c     wave_proccTest2 =  new Wave_Proc__c(Wave__c = wav_Obj.id,
                Wave_Infrastructure_Service__c=infrastructureSP.Id, Sending_Location__c = location.id,
                Number_of_Projected_FTEs__c = 32, Wave_Process_Location__c  = location.id,Mobilization_Plan__c = mob_Obj.id);
            PageReference wavePageErr2 = Page.WaveProcess_VFP;
            Test.setCurrentPage(wavePageErr2);
            ApexPages.StandardController testController3=new ApexPages.StandardController(wave_proccTest2 ); 
            waveProcessController waveProcess3=new waveProcessController(testController3);
            waveProcess3.saveRecord();   
            waveProcess3.refreshPg();

          */  
            
            //}
         test.stopTest();
        }
}