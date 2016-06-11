/*
@Author and Created Date : Diwanshu Setia ,  1/19/2015 4:49 AM
@name : MailSummaryController_Test 
@Description : 
@Version : 
*/
@isTest
private class MailSummaryController_Test {    
    private static SD_Governance_Data__c oppGov;
    //static Opportunity opp;
    private static Risk_And_Action_Log__c govRisk;
    private static Critical_Milestone__c govMilestone;
    private static User testUser;
    private static Commercial_Master__c clientName;
    private static Geo_Region_Master__c clientGeoArea;
    private static Operating_Groups_Master__c operatingGroup;
    private static Geo_Region_Master__c clientGeoUnit;
    private static User_Master__c user1;
    private static User_Master__c user2; 
    private static Mail_Summary__c mailObj; 
    
    private static SD_Governance_Data__c oppGov1;
    private static SD_Governance_Data__c oppGov2;
    private static Risk_And_Action_Log__c govRisk1;
    private static Risk_And_Action_Log__c govRisk2;
    private static Critical_Milestone__c govMilestone1;
    private static String[] mailIds;
    private static String emailId;
    private static List<String> userList1;
    private static List<String> userList2;
     private static List<id> oppId = new List<id>();
     private static Set<id> sdGovData = new Set<id>();
    private static Opportunity_Roles_Master__c oppRoleMaster;    
     private static String risk='';
     private static String overall='';
     private static String solution='';
     private static String schedule='';
     private static String commercial='';
     private static String resource='';
     private static String watchlist='';
     private static String emailIds;
     private static String body='';
     private static String msTable = '';
     private static String msTablee = '';     
     private static String actualDate= '';
     private static String swbDate='';   
     private static SD_Governance_Data__c GData = new SD_Governance_Data__c();
    
     private static Transient List<Opportunity_Teams__c> listOppTeam =new List<Opportunity_Teams__c>();
     private static Mail_Summary__c governanceLookup;
    
    //Setup Data..
     
 /******************************
    Method Name: setupData
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public static void setupData(){
    
    
        UtilConstants uc=new UtilConstants();
        Id userID = UserInfo.getUserId();
        User_Master__c testUserMaster = new User_Master__c();
        testUserMaster.Name = 'OPP_SOL_LEAD';
        insert testUserMaster;
        
        
        //Getting Profile for workbench
        Profile profile_workbench = UTIL_DataCreationForTestClass.getProfile(UtilConstants.WORKBENCH_USER);
        //test User details..
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(profile_workbench,UtilConstants.USER_NAME);
        Database.insert(testUser, true);
        
        User_Master__c testUserMaster2 = new User_Master__c();
        testUserMaster2.user__c = testUser.id;
        testUserMaster.Name = 'testUserMaster2';        
        insert testUserMaster2; 
     
        System.runAs(testUser){        
            clientName = new Commercial_Master__c(Name = 'TestObject1',Active__c = true);
            Database.insert(clientName,false);
            
            clientGeoArea = new Geo_Region_Master__c (Name = 'TestAPAC',Active__c = true);
            Database.insert(clientGeoArea,false);
            
            operatingGroup = new Operating_Groups_Master__c(Name = 'TestHSMPS',Active__c = true);
            Database.insert (operatingGroup,false);
                  
            clientGeoUnit = new Geo_Region_Master__c(Name = 'TestLATAM',Active__c = true);
            Database.insert(clientGeoUnit,false);     
            
            oppRoleMaster = new Opportunity_Roles_Master__c(Name=UtilConstants.OPP_SOL_LEAD);
            Database.insert(oppRoleMaster);
            
            Opportunity opp= new Opportunity();        
            opp.OperatingGroup__c= operatingGroup.id;        
            opp.name= UtilConstants.TEST_OPP;
            opp.Geo_Area__c= UTIL_Constants.AsiaPacific;        
            opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;        
            opp.StageName= UtilConstants.OA;        
            opp.Risk_Level__c= UtilConstants.LOW;        
            opp.CloseDate= date.newInstance(2001, 3, 21);  
            opp.BPO_Net_Rev_Thousands__c = 1000;      
            insert opp; 
                    
            Transient List<SD_Governance_Data__c> listGovData=new List<SD_Governance_Data__c>();
            List<Risk_And_Action_Log__c> listRiskItemDetails= new List<Risk_And_Action_Log__c>();
            List<Critical_Milestone__c> listMilestoneTable = new List<Critical_Milestone__c>();   
            List<sd_governance_data__c> sdGov = new List<sd_governance_data__c>();
            //List<id> oppId = new List<id>();   
            
            
             MailSummaryController_Test.setupGovData('Red','Green','Amber');                
                                     
        /*    oppGov = new SD_Governance_Data__c(Opportunity__c=opp.Id,Client__c=clientName.id, Solution_Headline__c = 'test the test', Risk__c = 'Amber', BPO_Sales_Lead__c = 'BPO_Sales_Lead', 
                                    Commercial__c = 'Red',Schedule__c='Green', over_all__c = 'Amber',Other__c='', trending__c = 'Up', Active__c = True, Watchlist__c = 'Yes');
                
             
              listGovData.add(oppGov);
            // system.debug('******listGovData******' + listGovData[0]);  
              sdGov.add(oppGov);      
           //  system.debug('******oppGov ******' + oppGov );  
            // system.debug('******sdGov******' + sdGov);            
             Database.insert(oppGov,false);
             
                
              if(oppGov.Risk__c=='Red'){
              
              
              listGovData.add(oppGov);
           //  system.debug('******listGovData******' + listGovData[0]);  
              sdGov.add(oppGov);      
           //  system.debug('******oppGov ******' + oppGov );  
          //   system.debug('******sdGov******' + sdGov);            
             Database.insert(oppGov,false);
            }
            else if(oppGov.Risk__c=='Green')
            {
              
              
              listGovData.add(oppGov);
           //  system.debug('******listGovData******' + listGovData[0]);  
              sdGov.add(oppGov);      
          //   system.debug('******oppGov ******' + oppGov );  
          //   system.debug('******sdGov******' + sdGov);            
             Database.update(oppGov,false);
            }
            else if(oppGov.Risk__c=='Amber')
            {
              
              
              listGovData.add(oppGov);
         //    system.debug('******listGovData******' + listGovData[0]);  
              sdGov.add(oppGov);      
         //    system.debug('******oppGov ******' + oppGov );  
         //    system.debug('******sdGov******' + sdGov);            
             Database.update(oppGov,false);
            }
            
            
        */
                   
            govRisk = new Risk_And_Action_Log__c(Governance_Data__c=oppGov.Id,Risk__c='', Status__c='In Process', Mitigation_Plan__c='',Completion_Date__c= null);
          
           govRisk.Mitigation_Plan__c=null;
            listRiskItemDetails.add(govRisk);
          //   system.debug('******govRisk******' + govRisk);
         //   system.debug('******listRiskItemDetails******' + listRiskItemDetails);
            Database.insert(govRisk, false);
          
          
           if(govRisk.Mitigation_Plan__c==null){
           
           listRiskItemDetails.add(govRisk);
         //    system.debug('******govRisk******' + govRisk);
         //   system.debug('******listRiskItemDetails******' + listRiskItemDetails);
            Database.update(govRisk, false);
           
            }
            else
            {
             govRisk.Mitigation_Plan__c='Testplan';
           listRiskItemDetails.add(govRisk);
         //    system.debug('******govRisk******' + govRisk);
        //    system.debug('******listRiskItemDetails******' + listRiskItemDetails);
            Database.update(govRisk, false);
            }
           
           
           
            
            govMilestone = new Critical_Milestone__c(Name = 'Stage1 Test Date', Governance_Data__c = oppGov.Id,actual__c=System.Today());
            String actual='';
            //Removed String as its defined static
            swbDate='';
            
            govMilestone.actual__c=null;
            listMilestoneTable.add(govMilestone);
        //    system.debug('******govMilestone******' + govMilestone);
        //    system.debug('******listMilestoneTable******' + listMilestoneTable);
            Database.insert(govMilestone, false);
            
           
            
             mailObj = new Mail_Summary__c(Governance_Data__c = oppGov.Id, User_1__c = testUserMaster.Id, User_2__c = testUserMaster2.Id, Email_Message__c = '');      
            Database.insert(mailObj, false);
           
        /* oppGov1 = new SD_Governance_Data__c( Commercial__c='Green',MC__c='Yes',Risk__c = 'red',Opportunity__c=opp.Id,Other__c='No comment',Over_all__c='Red',Resources__c='Amber',SD_Gov_Lead_Coach__c='testUser1',Solution__c='red',Solution_Headline__c='TestHeadLines',Trending__c='No Change',Watchlist__c='Yes');
            Database.update(oppGov1,false);
            
            govRisk1 = new Risk_And_Action_Log__c(Risk__c='TestRisk', Status__c='In Process',Completion_Date__c=Date.today(),Mitigation_Plan__c='Testplan', Governance_Data__c = oppGov1.Id);
            Database.update(govRisk1,false);
            
            oppGov2 = new SD_Governance_Data__c( Client__c=clientName.Name,Risk__c = 'Green',Commercial__c='Red',MC__c='No',Opportunity__c=opp.Id,Other__c='No comment',Over_all__c='Amber',Resources__c='Red',SD_Gov_Lead_Coach__c='testUser1',Solution__c='Amber',Solution_Headline__c='TestHeadLines',Trending__c='Not Applicable',Watchlist__c='Yes');
            Database.insert(oppGov2,false);
            
            govRisk2 = new Risk_And_Action_Log__c(Risk__c='TestRisk', Status__c='Complete',Completion_Date__c=Date.today(),Mitigation_Plan__c='Testplan2', Governance_Data__c = oppGov2.Id);
            Database.insert(govRisk2,false);
            
            govMilestone1 = new Critical_Milestone__c(Name='Stage1 Test Date', Actual__c = System.Today());
            Database.insert(govMilestone1, false);*/
           
            emailId = 'diwanshu.setia@accenture.com;example.tgp@accenture.com;';
            //Database.insert(govMilestone1, false);
            user1 = new User_Master__c(email__c = 'diwanshu.setia@accenture.com');
            Database.insert(user1, false);        
            user2 = new User_Master__c(email__c = 'example@accenture.com');
            Database.insert(user2, false);            
            mailObj = new Mail_Summary__c(Email_Message__c='');
            Database.insert(mailObj, false);        
            userList1 = new List<String>();
        }
    }
     /******************************
    Method Name: setupGovData
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    public static void setupGovData(String strSchedule,String strOverall,String strCommercial){                   
    Operating_Groups_Master__c oppOperatingGrup = UnitTestDatafactory.createOperatingGroup('India');           
    List<sd_governance_data__c> sdGov1 = new List<sd_governance_data__c>();            
    Opportunity opp = new Opportunity();            
    opp.Name = 'TestOpp1' + math.Random();            
    opp.Reporting_Status__c = UtilConstants.WON;            
    opp.Geo_Area__c = UtilConstants.EALA;                        
    opp.OperatingGroup__c = oppOperatingGrup.id;            
    opp.StageName = UtilConstants.TWO_B;            
    opp.Risk_Level__c = UtilConstants.NORMAL;            
    opp.CloseDate = System.today();             
    Database.insert(opp);         
     oppGov = new SD_Governance_Data__c(Opportunity__c=opp.id,Client__c=clientName.id, Solution_Headline__c = 'test the test', Risk__c = 'Amber', BPO_Sales_Lead__c = 'BPO_Sales_Lead',                                     
     Commercial__c =strCommercial,Schedule__c=strSchedule, over_all__c = strOverall,Other__c='', trending__c = 'Up', Active__c = True, Watchlist__c = 'Yes');                             
     List<SD_Governance_Data__c> listGovData1=new List<SD_Governance_Data__c>();             
     listGovData1.add(oppGov);             
   // system.debug('******call listGovData1******' + listGovData1[0]);               
     sdGov1.add(oppGov);                  
   //  system.debug('******call oppGov ******' + oppGov );              
     //system.debug('******call sdGov******' + sdGov);                         
     Database.insert(oppGov,false);
             
                     
     //setupGovData('Red','Green','Amber');               
     
      }
      
    //test meethod execution for MailSummaryController class
     /******************************
    Method Name: testMailSummaryController
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    static testMethod void testMailSummaryController() {
        setupData();
        Test.startTest();  
        
        
             
        MailSummaryController insertGovData = new MailSummaryController();         
        insertGovData.newRiskSectionItem = govRisk; 
        MailSummaryController.checkNullStrings('null');
        MailSummaryController.checkNullValuesDeciamlTCV(null);
         
        //mailing part
        //insertGovData.governanceLookup.User_1__c = user1.Id;
        userList1.add(user1.email__c); 
        userList1.add(user2.email__c);
        insertGovData.emailIds = userList1[0];        
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];        
         mailIds = insertGovData.emailIds.split(';');      
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setOrgWideEmailAddressId(owa.Id);
        mail.setToAddresses(mailIds);
        mail.setSubject('NOTIFICATION:  Governance Summary -Test mail');
        mail.setHtmlBody('Hi User Email test body content!');
        mail.saveAsActivity = false;
        emails.add(mail);
         
        Messaging.sendEmail(emails);
        //insertGovData.sendMail();    
        Test.stopTest();
    }
}