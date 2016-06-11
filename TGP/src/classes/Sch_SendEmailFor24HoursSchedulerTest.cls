@IsTest
private class Sch_SendEmailFor24HoursSchedulerTest{
    
    public static Outbound_Email_User_Master__c outboundEmailUser1;
    public static Outbound_Email_User_Master__c outboundEmailUser2;
    public static Outbound_Email_User_Master__c outboundEmailUser3;
    public static List<Outbound_Email_User_Master__c> outboundEmailUserMasterList;
    static Opportunity_Team__c oppTeam;
    static Opportunity_Role_Master__c roleMaster;
    static Review_Meeting_Request__c rmr;
    static Review_Meeting_Request__c rmr1;
    static Review_Meeting_Request__c rmr2;
    static Event lstevent1;
    static Calendar_Event__c ce;
    static User testUser;
    static Approver_Master__c appamster;
    static Client_Master__c clientName;
    static Client_Geo_Area_Master__c clientGeoArea;
    static Operating_Group_Master__c operatingGroup;
    static Client_Geo_Unit_Master__c clientGeoUnit;
    static Opportunity_TGP__c oppTGP;
    
    public static void setupData()
    {   

            Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);      
      
            outboundEmailUserMasterList = new List<Outbound_Email_User_Master__c>();
            
            outboundEmailUser1 = new Outbound_Email_User_Master__c();
            outboundEmailUser1.Outbound_Email_User_Name__c = 'test user';
            outboundEmailUser1.Email_ID__c = 'komal.priya@accenture.com';
            outboundEmailUser1.Active__c = true;
            
            insert outboundEmailUser1;
            outboundEmailUserMasterList.add(outboundEmailUser1);
            
            outboundEmailUser2 = new Outbound_Email_User_Master__c();
            outboundEmailUser2.Outbound_Email_User_Name__c = 'test user';
            outboundEmailUser2.Email_ID__c = 'komal.priya@accenture.com';
            outboundEmailUser2.Active__c = true;
            
            insert outboundEmailUser2;
            
            outboundEmailUserMasterList.add(outboundEmailUser2);
            
            clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
            insert clientName;
      
            clientGeoArea = new Client_Geo_Area_Master__c (Name = 'testLATAM',Active__c = true);
            insert clientGeoArea;
      
            operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
            insert operatingGroup;
      
            clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
            insert clientGeoUnit;
            
            oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='APAC',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
            insert oppTGP;
            
            roleMaster = new Opportunity_Role_Master__c(Name = 'Prime SDO Lead');
      
            insert roleMaster;
      
             oppTeam = new Opportunity_Team__c(Offering__c = null,BPO_Opportunity__c = oppTGP.Id,Roles__c = roleMaster.Id);
     
             insert oppTeam;
            
            rmr = new Review_Meeting_Request__c(Has_Email_Sent__c=false,BPO_Opportunity__c=oppTGP.id,Client_Name__c='test1',TCV_M__c=58000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='North America (10am CST)');
            insert rmr;
            
            rmr1 = new Review_Meeting_Request__c(Has_Email_Sent__c=false,BPO_Opportunity__c=oppTGP.id,Client_Name__c='test1',TCV_M__c=58000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='EALA (7am CST)');
            insert rmr1;
            
            
            datetime t = System.now();
            lstevent1 = new Event(StartDateTime=t+1,EndDateTime=t+2,ActivityDateTime=t+1,Meeting_Record_ID__c=rmr.id,IsAllDayEvent=false,Subject='testSub',OwnerId=testUser.id);
            insert lstevent1;
            
            appamster = new Approver_Master__c(Approver_Mail_ID__c='a1@logo.com',Region__c='testRegion',TCV_Range__c='testTCV');
            insert appamster;
    
            datetime dt = System.now();
            ce = new Calendar_Event__c(Start_Date__c=dt+1,End_Date__c=dt+4,TCV__c=5454,Subject__c='TestCalenderEvent',Review_Meeting_Request__c=rmr.id,Approver_Master__c=appamster.id);
            insert ce;
    }

    public static testMethod void testController() {
        
            
            setupData();
            Sch_SendEmailFor24HoursScheduler obj = new Sch_SendEmailFor24HoursScheduler(); 
            String sch = '0 0 17 * * ?';
            Id jobId = System.schedule('Test Change of Agent', sch, obj);
            System.assert(jobId!=null);


    }
    public static testMethod void testController1() {
        
            setupData();
            
            String QUERY = 'select id, name, Email_ID__c, Outbound_Email_User_Name__c, Active__c, Comments__c from Outbound_Email_User_Master__c where Active__c = true';
            Id jobId = Database.executeBatch(new Batch_SendEmailFor24HoursSchedule(QUERY), 10);


    }
    public static testMethod void testController2() {
        
            //setupData();
            Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     Database.insert(testUser, false);
      
      
            outboundEmailUserMasterList = new List<Outbound_Email_User_Master__c>();
            
            outboundEmailUser1 = new Outbound_Email_User_Master__c();
            outboundEmailUser1.Outbound_Email_User_Name__c = 'test user';
            outboundEmailUser1.Email_ID__c = 'komal.priya@accenture.com';
            outboundEmailUser1.Active__c = true;
            
            insert outboundEmailUser1;
            outboundEmailUserMasterList.add(outboundEmailUser1);
            
            outboundEmailUser2 = new Outbound_Email_User_Master__c();
            outboundEmailUser2.Outbound_Email_User_Name__c = 'test user';
            outboundEmailUser2.Email_ID__c = 'komal.priya@accenture.com';
            outboundEmailUser2.Active__c = true;
            
            insert outboundEmailUser2;
            
            outboundEmailUserMasterList.add(outboundEmailUser2);
            
            clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
            insert clientName;
      
            clientGeoArea = new Client_Geo_Area_Master__c (Name = 'testLATAM',Active__c = true);
            insert clientGeoArea;
      
            operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
            insert operatingGroup;
      
            clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
            insert clientGeoUnit;
            
            oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c='APAC',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
            insert oppTGP;
            
            roleMaster = new Opportunity_Role_Master__c(Name = 'Prime SDO Lead');
      
            insert roleMaster;
      
             oppTeam = new Opportunity_Team__c(Offering__c = null,BPO_Opportunity__c = oppTGP.Id,Roles__c = roleMaster.Id);
     
             insert oppTeam;
            
            
            rmr1 = new Review_Meeting_Request__c(Has_Email_Sent__c=false,BPO_Opportunity__c=oppTGP.id,Client_Name__c='test1',TCV_M__c=58000,Status__c='Submitted',Preferred_Meeting_Date_del__c=Date.today()+1,Meeting_Time__c='EALA (7am CST)');
            insert rmr1;
            
            
            datetime t = System.now();
            lstevent1 = new Event(StartDateTime=t+1,EndDateTime=t+2,ActivityDateTime=t+1,Meeting_Record_ID__c=rmr1.id,IsAllDayEvent=false,Subject='testSub',OwnerId=testUser.id);
            insert lstevent1;
            
            appamster = new Approver_Master__c(Approver_Mail_ID__c='a1@logo.com',Region__c='testRegion',TCV_Range__c='testTCV');
            insert appamster;
    
            datetime dt = System.now();
            ce = new Calendar_Event__c(Start_Date__c=dt+1,End_Date__c=dt+4,TCV__c=5454,Subject__c='TestCalenderEvent',Review_Meeting_Request__c=rmr1.id,Approver_Master__c=appamster.id);
            insert ce;
            
            String QUERY = 'select id, name, Email_ID__c, Outbound_Email_User_Name__c, Active__c, Comments__c from Outbound_Email_User_Master__c where Active__c = true';
            Id jobId = Database.executeBatch(new Batch_SendEmailFor24HoursSchedule(QUERY), 10);


    }
    

}