@isTest
private class MOB_DealClientSpecificTest
{       
    static ApexPages.StandardController sc;
    static Deal_tgp__c deal; 
    static Mob_User_Roles_Master__c strMoURM; 
    static MOB_User_Role_Assignment__c strMoURA;
    static User testUser;
    public static void setupData()
    {
        /*Profile p = [select Id from profile where name='Mob Users'];
        User u= new User(alias = 'mobtest', email='test@test.com',
                                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                    localesidkey='en_US', profileid = p.Id,
                                    timezonesidkey='America/Los_Angeles', username='mobtest@test.com');
        insert u;*/
        
        deal= new Deal_tgp__c(name='mobtest');                                     
        insert deal;
        
        strMoURM=new Mob_User_Roles_Master__c(Access_Level__c='Edit',Role_Name__c='Governance Lead1');
        insert strMoURM;
        
        /*strMoURA=new MOB_User_Role_Assignment__c(Access_Level__c='Edit',Deal__c=deal.id,User_Assigned__c=u.id,Role_Name__c='Governance Lead1',Mob_User_Roles_Master__c=strMoURM.id);
        insert strMoURA;*/
        
        
        sc = new ApexPages.StandardController(deal);               
    }
 
   public static testMethod void testMOB_DealClientSpecific()
   {
      
       Test.startTest();
       
    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

//Run As U1
System.RunAs(testUser){
        setupData();
       Offerings_Master__c offer = new Offerings_Master__c(name='offer_1');
       insert offer;
       Service_Master__c service = new Service_Master__c(offering__c=offer.id);
       insert service;
       Service_Component__c serComp = new Service_Component__c(Offering_Master__c=offer.id ,Service_Master__c=service.id);
       insert serComp;
        strMoURA=new MOB_User_Role_Assignment__c(Access_Level__c='Edit',Deal__c=deal.id,User_Assigned__c=testUser.id,Role_Name__c='Governance Lead1',Mob_User_Roles_Master__c=strMoURM.id);
        insert strMoURA;
       
       PageReference pageRef = Page.MOB_DealClientSpecificProcess;
       Test.setCurrentPage(pageRef);
       MOB_DealClientSpecificProcessController objMobClient = new MOB_DealClientSpecificProcessController(sc);
       objMobClient.refreshServices();
       objMobClient.refreshServiceComponents();
       
       objMobClient.strDealId= deal.id;
       objMobClient.strProcessName = 'hr';
       objMobClient.StrOffering = offer.id;
       objMobClient.strService = service.id;
       objMobClient.strServiceComponent = serComp.id;
       objMobClient.SaveProcess();       

       Client_Specific_Process_Mapping__c objClient = new Client_Specific_Process_Mapping__c();       
       objClient.name = 'pr';
       objClient.Deal__c=deal.id;
       objClient.Offering__c=offer.id;
       objClient.Process__c=service.id;
       objClient.Service_Component__c= serComp.id;
       insert objClient;
       
       
       pageRef = Page.MOB_DealClientSpecificProcess;
       pageRef.getParameters().put('ProcessId', String.valueOf(objClient.id));        
       Test.setCurrentPage(pageRef);
       objMobClient = new MOB_DealClientSpecificProcessController(sc);
       objMobClient.strProcessName = 'hr1';
       objMobClient.StrOffering = offer.id;
       objMobClient.strService = service.id;
       objMobClient.strServiceComponent = serComp.id;
       objMobClient.SaveProcess();  
       objMobClient.CheckProcessExistInWave();  
}      
       Test.stopTest();
   }
   
}