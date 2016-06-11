@isTest
/*
  @Author: 
  @Name: ClientProcessController_Test 
  @Created Date: 14 May 2015
  @Description:This is a test class ClientProcessController_Test for ClientProcessController controller .
  @version: 1.0
*/
private class ClientProcessController_Test {
    Private static User testUser;
    Private static Profile p;
    Private static Wave_Proc__c wave_proccTest;
    Private static Services_Master__c serMaster;
    Private static Offering_Master__c offeringMaster;
    Private static Services_Component_Master__c SericeComMaster;
    Private static Client_Specific_Process__c clientSP;
    Private static Wave__c wav_Obj;
    Private static Mobilization_Plan__c mob_Obj;
    Private static Deal__c dealObj;
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
        dealObj=new Deal__c(Name='Testdeal');
        insert dealObj;
        mob_Obj=new Mobilization_Plan__c(Name ='planTest123', Deal__c = dealObj.id,IsTrackingOn__c = True,Active__c=True);
        insert mob_Obj;
        wav_Obj=new Wave__c(Name='testWave',Mobilization_Plan__c=mob_Obj.id,Is_Procurement_Tracking_Applicable__c=true,Active__c=True);
        insert wav_Obj;
        offeringMaster=new Offering_Master__c(name='Sourcing and Procurement',offering_description__c='test',flywheel_non_flywheel__c='Yes');
         insert offeringMaster;
         serMaster=new Services_Master__c(name='Sourcing and Category Management Service',offering__c=offeringMaster.id);
         insert serMaster;
        SericeComMaster=new Services_Component_Master__c(name='Sourcing and Category Management Service',service__c=serMaster.id, service_component_description__c='test');
        insert SericeComMaster;
        clientSP=new Client_Specific_Process__c(Process_Offering__c=offeringMaster.id,Process_Services__c=serMaster.id,Deal__c=dealObj.id);
        insert clientSP;
        }
/*
  @Name: waveProcessMethod
  @Created Date: 14 May 2015
  @Description:This is a test method waveProcessMethod for wave process refresh page,record save etc.
  @version: 1.0
*/
    static testMethod void clientProcessMethod(){
            
        test.starttest();
        setupData();
        system.runAs(testUser){
                   
            PageReference tpageRef = Page.ClientProcess;
            Test.setCurrentPage(tpageRef);
            ApexPages.currentPage().getParameters().put('id',null);
            ApexPages.StandardController testController=new ApexPages.StandardController(clientSP); 
            ClientProcessController clientProcess=new ClientProcessController(testController);
            clientProcess.saveRecord();   
            clientProcess.refreshPg();
            }
         test.stopTest();
        }
}