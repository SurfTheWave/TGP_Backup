/*
    @author     : Madhusudhan 
    @name       : ClientProcessLookupControllerTest 
    @createDate :   
    @description: 
    @version    : V1
*/
@isTest
private class ClientProcessLookupControllerTest {
        private static User testUser;
        
        private static Profile p;
        private static Offering_Master__c offObj;
        //private  static Delivery_Location_Masters__c location;
        //private static Country_Master__c countryMaster;
        /*    
            @name :         setupData
            @description :  set up test data for Custom lookup controller functionality testing
        */    
        public static void setupData(){    
            p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.WORKBENCH_USER);
            testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
            
            
            offObj = new Offering_Master__c(Name='Offerng test',Service_Group__c='BPO',offering_description__c = 'Test', 
                                                        flywheel_non_flywheel__c = 'Random');
            Database.insert(offObj);
            
            Services_Master__c serviceMaster=new Services_Master__c(Name='test',offering__c=offObj.id);
            Database.insert(serviceMaster);
            
            Services_Component_Master__c ServCompMaster=new Services_Component_Master__c(Name='Ser Comp test',service__c=serviceMaster.id,
                                                                                        service_component_description__c='test Service comp');
            Database.insert(ServCompMaster);
            //countryMaster=new Country_Master__c(Name='India');
       // insert countryMaster;
        //location=new Delivery_Location_Masters__c(Name='India-Hyderabad',country__c=countryMaster.id);
       // insert location;
        }
        /*    
            @name :         customLookUPTestMethod
            @description :  Test for customLookUPTest in CustomLookupController 
        */    
        static testMethod void customLookUPTestMethod(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Offering_Master__c');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ASTERISK_OPRTR); 
                //ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD);
                
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
                clientProcess.baseQueryInfraStructure();
            }
         test.stopTest();
        }
         static testMethod void customLookUPTestMethod1(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Services_Master__c');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ASTERISK_OPRTR); 
                //ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD);
               
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
                clientProcess.baseQueryInfraStructure();
                
            }
         test.stopTest();
        }
        static testMethod void customLookUPTestMethod2(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Services_Component_Master__c');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ASTERISK_OPRTR); 
                //ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD);
               
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
                clientProcess.baseQueryInfraStructure();
            }
         test.stopTest();
        }
        static testMethod void customLookUPTestMethod3(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Client_Specific_Process__c');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ASTERISK_OPRTR); 
                //ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD);
               
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
                clientProcess.baseQueryInfraStructure();
            }
         test.stopTest();
        }
       static testMethod void customLookUPTestMethod4(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Delivery_Location_Masters__c');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ASTERISK_OPRTR); 
                //ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD);
               
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
                clientProcess.baseQueryInfraStructure();
            }
         test.stopTest();
        }
     static testMethod void customLookUPTestMethod5(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Infrastructure_Service__c');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ASTERISK_OPRTR); 
                //ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD);
               
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
                clientProcess.baseQueryInfraStructure();
            }
         test.stopTest();
        }
     static testMethod void customLookUPTestMethod6(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Offering_Master__c_IO');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ASTERISK_OPRTR); 
               // ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD);
               
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
                clientProcess.baseQueryInfraStructure();
            }
         test.stopTest();
        }
         static testMethod void customLookUPTestMethod7(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Offering_Master__c');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD);
                
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
                clientProcess.baseQueryInfraStructure();
            }
         test.stopTest();
        }
         static testMethod void customLookUPTestMethod8(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Services_Master__c');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD);
               
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
                clientProcess.baseQueryInfraStructure();
                
            }
         test.stopTest();
        }
        static testMethod void customLookUPTestMethod9(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Services_Component_Master__c');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD);
               
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
                clientProcess.baseQueryInfraStructure();
            }
         test.stopTest();
        }
        static testMethod void customLookUPTestMethod10(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Client_Specific_Process__c');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD);
               
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
                clientProcess.baseQueryInfraStructure();
            }
         test.stopTest();
        }
       static testMethod void customLookUPTestMethod11(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Delivery_Location_Masters__c');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD);
               
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
                clientProcess.baseQueryInfraStructure();
            }
         test.stopTest();
        }
     static testMethod void customLookUPTestMethod12(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Infrastructure_Service__c');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD);
               
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
                clientProcess.baseQueryInfraStructure();
            }
         test.stopTest();
        }
     static testMethod void customLookUPTestMethod13(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Offering_Master__c_IO');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD);
               
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
                clientProcess.baseQueryInfraStructure();
            }
         test.stopTest();
        }
    
}