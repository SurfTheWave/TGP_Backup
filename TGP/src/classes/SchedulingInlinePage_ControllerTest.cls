@IsTest
private class SchedulingInlinePage_ControllerTest{

    static Opportunity_TGP__c oppObj;
    static Client_Master__c clientName;
    static Client_Geo_Area_Master__c clientGeoArea;
    static Operating_Group_Master__c operatingGroup;
    static Client_Geo_Unit_Master__c clientGeoUnit;
    static User testUser;
    static User testUser1;
    static Review_User_Master__c testUser2;
    static Review_User_Master__c testUser3;
    static Review_User_Master__c revUser;
    static Opportunity_Offering__c oppOffering;
    static Scheduling__c oppScheduling;
    static User enterpriseSolArchitect; 
    static User complexCostArchitect; 
    static User workbenchAdminUser; 
    static User DEFA_1;
    static User DEFA_2;
    static User DEFA_3;
    static User DEFA_4;
    static Opportunity_Offering__c oppOfferingRec;
    static Opportunity_Offering__c oppOfferingRec1;
    static Opportunity_Offering__c oppOfferingRec2;
    
    public static void setupData(){
      Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
      
      Profile adminProfile = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SOLUTION_ADMIN);
      
     // workbenchAdminUser = [Select id from user where Profile.name  = 'Workbench User' and IsActive = true limit 1];
     workbenchAdminUser  = new user(Alias = 'testwby1',isActive =true,lastname = 'wbu1',firstname='wbu1',profileid=p.id,
                                      email='wbu1@accenture.com',username='wbu1@accenture.com',EmailEncodingKey='UTF-8', 
                                      LanguageLocaleKey='en_US', LocaleSidKey='en_US',TimeZoneSidKey='America/Los_Angeles');
      insert workbenchAdminUser ;

      
      testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);

      
      testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser1, false);
     
     
     
     testUser2 = UTIL_DataCreationForTestClass.getReviewUserMaster('test@email.com','test');
     testUser2.SFDC_User__c = testUser.id;
     testUser2.Is_Active__c = true;
     insert testUser2;
     
     testUser3 = UTIL_DataCreationForTestClass.getReviewUserMaster('test123@email.com','test');
     testUser3.SFDC_User__c = testUser.id;
     testUser3.Is_Active__c = true;
     insert testUser3;
     
     revUser = UTIL_DataCreationForTestClass.getReviewUserMaster('test123@email.com','test');
     revUser.SFDC_User__c = testUser.id;
     revUser.Is_Active__c = true;
     insert revUser;
      
       clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;
    
      oppObj = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Complex_Cost_Architect_New__c = testUser2.id,Activity__c='1-Active',Enterprise_Solution_Architect_New__c=testUser2.id ,
                  Oppotunity_QA__c='KomalTest',OG_Sales_Lead__c='Test');   
      insert oppObj;
      
    }
    
    
    
    public static testMethod void testControllerForSave() {
        setupData();
        test.starttest();
            oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Domain_Expert_Functional_Architect_1__c = testUser.id,Domain_Expert_Functional_Architect_2__c = testUser.id,Domain_Expert_Functional_Architect_3__c = testUser.id,Domain_Expert_Functional_Architect_4__c=testUser.id,Solution_Lead__c = testUser.id ,Opportunity_TGP__c=oppObj.id);
            insert oppOffering;
            
            Opportunity_Offering__c offRec = [select name from Opportunity_Offering__c where id=:oppOffering.id];
            oppScheduling = new Scheduling__c(BPO_Opportunity_MD__c = oppObj.id,Role_Name__c = 'Solution Architect - BPO', User_Name__c = 'Test',offerings__c = offRec.name);
            insert oppScheduling;
            
            List<Scheduling__c> testRecord = new List<Scheduling__c>();
            Scheduling__c scRec = new Scheduling__c(Current_week__c = 1,Current_week_1__c = 2,Current_week_2__c = 3,Current_week_3__c = 3,Ongoing__c = 40,BPO_Opportunity_MD__c = oppObj.id);
            testRecord.add(scRec);
          
            PageReference pageRef = Page.SchedulingInline_Page;
            Test.setCurrentPage(pageRef);    
            //Opportunity_Offering__c offRec = [select name from Opportunity_Offering__c where id=:oppOffering.id];
            
            ApexPages.StandardController sc = new ApexPages.StandardController(oppObj);
            apexpages.currentpage().getparameters().put('id' ,oppObj.id); 
            SchedulingInlinePage_Controller obj = new SchedulingInlinePage_Controller(sc); 
           
            //obj.Lable();
            obj.lstSc = testRecord;
            obj.doSave();           
         test.stoptest();
         
    }

}