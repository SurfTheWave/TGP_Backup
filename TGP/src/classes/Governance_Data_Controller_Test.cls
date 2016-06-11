/**
 * This class contains unit tests for validating the behavior of Governance Data Controller.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */

@isTest

private class Governance_Data_Controller_Test {
    
    static Governance_Data__c oppGov;
    static Opportunity_TGP__c oppTGP;
    static Governance_Risk_Item__c govRisk;
    static Governance_Critical_Milestones__c govMilestone;
    static User testUser;
    static Client_Master__c clientName;
    static Client_Geo_Area_Master__c clientGeoArea;
    static Operating_Group_Master__c operatingGroup;
    static Client_Geo_Unit_Master__c clientGeoUnit;
    static Review_User_Master__c user1;
    static Review_User_Master__c user2; 
    static Opportunity_Governance_Mail__c mailObj;
    
    static Governance_Data__c oppGov1;
    static Governance_Risk_Item__c govRisk1;
    static Governance_Critical_Milestones__c govMilestone1;
    static String[] mailIds;
    static String emailId;
    static List<String> userList1 ;
    

  public static void setupData(){
    // Profile for workbench
    Profile profile_workbench = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
    
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(profile_workbench,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
     
    system.Runas(testUser){
        
        clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
            Database.insert(clientName,false);
              
        clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
            Database.insert(clientGeoArea,false);
              
        operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
            Database.insert (operatingGroup,false);
              
        clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
             Database.insert(clientGeoUnit,false);             
         
         
        oppTGP = new Opportunity_TGP__c(Name = 'TestGov',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,
                                Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,
                                Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                                Oppotunity_QA__c='SumaTest',OG_Sales_Lead__c='SumaTest',SAP_OM_ID_available_Y_N_del__c ='No');
            insert oppTGP;
          
        oppGov = new Governance_Data__c(Opportunity_TGP__c=oppTGP.Id);
             Database.insert(oppGov,false);
              
         govRisk = new Governance_Risk_Item__c(Opportunity_Governance_Data__c = oppGov.Id,Risk__c='TestRisk', Status__c='Incomplete',
                                                    Mitigation_Plan__c='Testplan',Completion_Date__c=Date.today());
              Database.insert(govRisk,false);
              
         govMilestone = new Governance_Critical_Milestones__c(Governance_Data__c=oppGov.Id);
              Database.insert(govMilestone, false);
              
         oppGov1 = new Governance_Data__c(Opportunity_TGP__c=oppTGP.Id, Client__c=clientName.Name,risk__c='red', schedule__c='Green',Resources__c='amber',
                                                Commercial__c='Green',Overall__c='Amber', Solution__c = 'red', MC__c='Yes',Other__c='No comment',
                                                SD_Governance_Lead_Coach__c='testUser1',Solution_Headlines__c='TestHeadLines', 
                                                Trending__c='No Change',Watchlist__c='No');
         govRisk1 = new Governance_Risk_Item__c(Opportunity_Governance_Data__c = oppGov.Id,Risk__c='TestRisk', Status__c='Incomplete',Completion_Date__c=Date.today(),Mitigation_Plan__c='Testplan');
         govMilestone1 = new Governance_Critical_Milestones__c(Governance_Data__c=oppGov.Id,Milestone__c='Stage1 Test Date');
         emailId = 'sumalatha.ganga@accenture.com;example.tgp@accenture.com;';
         
         user1 = new Review_User_Master__c(Email_ID_of_the_reviewer__c = 'sumalatha.ganga@accenture.com');
            Database.insert(user1, false);
    
         user2 = new Review_User_Master__c(Email_ID_of_the_reviewer__c = 'example@accenture.com');
            Database.insert(user2, false);
        
         mailObj = new Opportunity_Governance_Mail__c(mail_message__c='testmsg');
              Database.insert(mailObj , false);
         
         userList1 = new  List<String>();
             
          
        
    }
  }
  
    static testMethod void myUnitTest() {
        setupData();
        test.starttest();
        
        PageReference pageRef= Page.Governance_Data_Page;
        pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
        Test.setCurrentPageReference(pageRef);
       
        Governance_Data_Controller insertGovData= new Governance_Data_Controller();
        
        insertGovData.oppId = oppTGP.id;
        insertGovData.saveGovData();
        insertGovData.newRiskSectionItem = govRisk1;        
        insertGovData.addRiskSectionItems();
        insertGovData.detailRecordsOfRiskSection();
        insertGovData.milestoneTable = govMilestone1;
        insertGovData.getriskItem();
        insertGovData.getGData();       
        insertGovData.cancelGovData();
        insertGovData.GoBackToHomeTab();
        insertGovData.editForGovData();
        Governance_Data_Controller.checkNullStrings('null');
        Governance_Data_Controller.checkNullValuesDeciamlTCV(22534.67);
       
        // mailing part
        insertGovData.governanceLookup.User_1__c = user1.Id;
        userList1.add(user1.Email_ID_of_the_reviewer__c);
        
        insertGovData.governanceLookup.User_2__c = user2.Id;
        userList1.add(user2.Email_ID_of_the_reviewer__c);
        insertGovData.emailIds = userList1[0] ;
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];        
        mailIds = insertGovData.emailIds.split(';');
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setOrgWideEmailAddressId(owa.Id);
        mail.setToAddresses(mailIds);
        mail.setSubject('NOTIFICATION:  Governance Summary -Test mail');
        mail.setHtmlBody('hai test mail body!');
        mail.saveAsActivity = false;
        emails.add(mail);
        Messaging.sendEmail(emails);
        
        insertGovData.emailForGovData();
        // for inner class.
        Governance_Data_Controller.CounterWrapper insertWrapper = new Governance_Data_Controller.CounterWrapper(govRisk1,2);
        insertGovData.cancelMail();
        insertGovData.sendMail();
        insertGovData.governanceLookup.User_2__c =  user2.Id;
        
        test.stoptest();
        
    }
}