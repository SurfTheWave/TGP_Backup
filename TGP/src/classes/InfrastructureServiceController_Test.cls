/*
      @Description: 
      @Required Parameters: 
      @Return Parameter: 
    */
@isTest
public class InfrastructureServiceController_Test {
    Private static User testUser;
    Private static Profile p;
    Private static Wave_Proc__c wave_proccTest;
    Private static Services_Master__c serMaster;
    Private static Offering_Master__c offeringMaster;
    Private static Services_Component_Master__c ServiceComMaster;
    Private static Infrastructure_Service__c infrastructureSP ;
    Private static Wave__c wav_Obj;
    Private static Mobilization_Plan__c mob_Obj;
    Private static Deal__c dealObj;
    
      /*
      @Description: 
      @Required Parameters: 
      @Return Parameter: 
    */
    public static void setupData(){
        p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.SYSTEM_ADMIN);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        
        
        
         Offering_Master__c offProc=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
        insert offProc;
        Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
        insert customSetting;
        
        
        //offeringMaster=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
        offeringMaster= new Offering_Master__c(Name = UtilConstants.HR, offering_description__c = UtilConstants.TEST_DESC, 
                                                                flywheel_non_flywheel__c = UtilConstants.FLYWHEEL, Service_Group__c=UtilCOnstants.IO);
        insert offeringMaster;
        
        
        //Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offeringMaster.name, offeringMaster.id);
        //insert customSetting;
        
        List<Opportunity> oppList = UnitTestDatafactory.createOppList('TestOppty',1);
        Solution_Scope__c solComp = new Solution_Scope__c();
        solComp.Offering_Master__c = offeringMaster.id;
        solComp.Opportunity__c = oppList[0].Id;
        insert solComp;
        
        /*
         List<Solution_Scope__c> sList = [SELECT Id, Name, Offering_Master__r.Name, Opportunity__r.Off__C FROM Solution_Scope__c WHERE Opportunity__C =:oppList[0].Id];
          System.debug('slist ->' + slist);
        */
        dealObj=new Deal__c(Name='Testdeal', Opportunity__C = oppList[0].Id);
        insert dealObj;
        mob_Obj=new Mobilization_Plan__c(Name ='planTest123', Deal__c = dealObj.id,IsTrackingOn__c = False, Active__c=True, Service_Group__c = UtilCOnstants.IO);
        insert mob_Obj;
        wav_Obj=new Wave__c(Name='testWave',Mobilization_Plan__c=mob_Obj.id,Is_Procurement_Tracking_Applicable__c=false,Active__c=True);
        insert wav_Obj;
         
        serMaster=new Services_Master__c(name= UtilConstants.HR,offering__c=offeringMaster.id);
        insert serMaster;
        
        ServiceComMaster=new Services_Component_Master__c(name= UtilConstants.HR,service__c=serMaster.id, service_component_description__c='test');
        insert ServiceComMaster;
        
        infrastructureSP=new Infrastructure_Service__c(ServiceOffering__c=offeringMaster.id,SubService__c=serMaster.id,
                                                Deal__c=dealObj.id );
        insert infrastructureSP;
        }
   /*
      @Description: 
      @Required Parameters: 
      @Return Parameter: 
    */
    static testMethod void infrastructureServiceMethod(){
        
        setupData();    
        test.starttest();
        
        system.runAs(testUser){
                   
            PageReference tpageRef = Page.InfrastructureService;
            Test.setCurrentPage(tpageRef);
            ApexPages.currentPage().getParameters().put('id',null);
            ApexPages.StandardController testController=new ApexPages.StandardController(infrastructureSP); 
            InfrastructureServiceController InfrastructureService = new InfrastructureServiceController(testController);
            InfrastructureService.saveRecord();   
            InfrastructureService.refreshPg();
           
        
        
            infrastructureSP=new Infrastructure_Service__c(ServiceOffering__c=offeringMaster.id,SubService__c=serMaster.id,
                                                Deal__c=dealObj.id );
            insert infrastructureSP;       
             Test.setCurrentPage(tpageRef);
             ApexPages.currentPage().getParameters().put('id',infrastructureSP.Id);
            ApexPages.StandardController testController2=new ApexPages.StandardController(infrastructureSP); 
            InfrastructureServiceController InfrastructureService2 = new InfrastructureServiceController(testController2);
            InfrastructureService2.saveRecord();  
        }
       
         test.stopTest();
        }
}