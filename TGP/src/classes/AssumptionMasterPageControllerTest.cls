/*
Author : IDC Team
Story  : Release 1.5  
Description : Test Class for AssumptionMasterPageController. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
@isTest
public class AssumptionMasterPageControllerTest{
    static Assumption_Master__c newAssumption;
    static Category__c cat;
    static Offerings_Master__c offerMaster;
    static Service_Master__c servMaster;
    static Assumption__c assm;
    static User testUser;
    
    public static void setupData1(){
        
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        
        system.Runas(testUser){
        cat= new Category__c(Name='Facility', Active__c=true); 
        Database.insert(cat, false);
        
        offerMaster = new Offerings_Master__c(Name='test Offer');
        Database.insert(offerMaster, false);
        
        servMaster = new Service_Master__c(Name='test ServeMaster');
        Database.insert(servMaster, false);

        assm = new Assumption__c(Name='test asmm');
        Database.insert(assm, false);
                 
        newAssumption= new Assumption_Master__c(Classification__c='Internal', Category__c='Facility', Assumption__c='test asm', Offering__c=offerMaster.Id,Services_per_offering__c=servMaster.Id);
        insert newAssumption;
        }
     }
     
      public static void setupData2(){
        
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        
        system.Runas(testUser){
        cat= new Category__c(Name='test Catagory', Active__c=true); 
        Database.insert(cat, false);
        
        offerMaster = new Offerings_Master__c(Name='test Offer');
        Database.insert(offerMaster, false);
        
        servMaster = new Service_Master__c(Name='test ServeMaster');
        Database.insert(servMaster, false);

        assm = new Assumption__c(Name='test asmm');
        Database.insert(assm, false);
                 
        newAssumption= new Assumption_Master__c(Classification__c='', Category__c='Facility', Assumption__c='test asm', Offering__c=offerMaster.Id,Services_per_offering__c=servMaster.Id);
        insert newAssumption;
        }
     }
     
       public static void setupData3(){
        
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        
        system.Runas(testUser){
        cat= new Category__c(Name='Facility', Active__c=true); 
        Database.insert(cat, false);
        
        offerMaster = new Offerings_Master__c(Name='test Offer');
        Database.insert(offerMaster, false);
        
        servMaster = new Service_Master__c(Name='test ServeMaster');
        Database.insert(servMaster, false);

        assm = new Assumption__c(Name='test asmm');
        Database.insert(assm, false);
                 
        newAssumption= new Assumption_Master__c(Classification__c='Internal', Category__c='', Assumption__c='test asm', Offering__c=offerMaster.Id,Services_per_offering__c=servMaster.Id);
        insert newAssumption;
        }
     }
     
     public static void setupData4(){
        
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        
        system.Runas(testUser){
        cat= new Category__c(Name='Facility', Active__c=true); 
        Database.insert(cat, false);
        
        offerMaster = new Offerings_Master__c(Name='Learning');
        Database.insert(offerMaster, false);
        
        servMaster = new Service_Master__c(Name='test ServeMaster');
        Database.insert(servMaster, false);

        assm = new Assumption__c(Name='test asmm');
        Database.insert(assm, false);
                 
        newAssumption= new Assumption_Master__c(Classification__c='Internal', Category__c='', Assumption__c='test asm', Offering__c=offerMaster.Id,Services_per_offering__c=servMaster.Id);
        insert newAssumption;
        }
     }
     
     public static void setupData5(){
        
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        
        system.Runas(testUser){
        cat= new Category__c(Name='Facility', Active__c=true); 
        Database.insert(cat, false);
        
        offerMaster = new Offerings_Master__c(Name='Learning');
        Database.insert(offerMaster, false);
        
        servMaster = new Service_Master__c(Name='test ServeMaster');
        Database.insert(servMaster, false);

        assm = new Assumption__c(Name='test asmm');
        Database.insert(assm, false);
                 
        newAssumption= new Assumption_Master__c(Classification__c='', Category__c='', Assumption__c='test asm', Offering__c=offerMaster.Id,Services_per_offering__c=servMaster.Id);
        insert newAssumption;
        }
     }
     
     static testMethod void testInsertAssumptionMaster(){
        setupData1();
        Test.startTest();
         PageReference pageRef= Page.assumptionMasterPage;
         pageRef.getParameters().put('id', String.valueOf(newAssumption.Id));//BG
         Test.setCurrentPageReference(pageRef);
         ApexPages.StandardController controller= new ApexPages.StandardController(newAssumption);
         AssumptionMasterPageController assmMasterPageControl = new AssumptionMasterPageController(controller);
         assmMasterPageControl.getCategory();
         assmMasterPageControl.getServices();
         assmMasterPageControl.getOfferings();
         assmMasterPageControl.newAssumption = newAssumption;
         assmMasterPageControl.insertNewRecord();
         assmMasterPageControl.updateRecord();
        Test.stopTest();
     }
     
     static testMethod void testInsertAssumptionMasterWithClassificationNull(){
        setupData2();
        Test.startTest();
         PageReference pageRef= Page.assumptionMasterPage;
         pageRef.getParameters().put('id', newAssumption.Id);//BG
         Test.setCurrentPageReference(pageRef);
         ApexPages.StandardController controller= new ApexPages.StandardController(newAssumption);
         AssumptionMasterPageController assmMasterPageControl = new AssumptionMasterPageController(controller);
         assmMasterPageControl.newAssumption = newAssumption;
         assmMasterPageControl.insertNewRecord();
        Test.stopTest();
     }
     
      static testMethod void testInsertAssumptionMasterWithAllNull(){
        setupData3();
        Test.startTest();
         PageReference pageRef= Page.assumptionMasterPage;
         pageRef.getParameters().put('id', String.valueOf(newAssumption.Id));//BG
         Test.setCurrentPageReference(pageRef);
         ApexPages.StandardController controller= new ApexPages.StandardController(newAssumption);
         AssumptionMasterPageController assmMasterPageControl = new AssumptionMasterPageController(controller);
         assmMasterPageControl.insertNewRecord();
        Test.stopTest();
     }
     
     static testMethod void testInsertAssumptionMasterPositive(){
        setupData4();
        Test.startTest();
         PageReference pageRef= Page.assumptionMasterPage;
         pageRef.getParameters().put('id', String.valueOf(newAssumption.Id));//BG
         Test.setCurrentPageReference(pageRef);
         ApexPages.StandardController controller= new ApexPages.StandardController(newAssumption);
         AssumptionMasterPageController assmMasterPageControl = new AssumptionMasterPageController(controller);
         assmMasterPageControl.insertNewRecord();
         assmMasterPageControl.updateRecord();
         assmMasterPageControl.cancelUpdate();
        Test.stopTest();
     }
     
     static testMethod void testUpdateAssumptionMasterPositive(){
        setupData5();
        Test.startTest();
         PageReference pageRef= Page.assumptionMasterPage;
         pageRef.getParameters().put('id', String.valueOf(newAssumption.Id));//BG
         Test.setCurrentPageReference(pageRef);
         ApexPages.StandardController controller= new ApexPages.StandardController(newAssumption);
         AssumptionMasterPageController assmMasterPageControl = new AssumptionMasterPageController(controller);
         assmMasterPageControl.getCategory();
         assmMasterPageControl.getServices();
         assmMasterPageControl.getOfferings();
         assmMasterPageControl.insertNewRecord();
         assmMasterPageControl.updateRecord();
        Test.stopTest();
     } 
}