/*
Author : Accenture Team
Story  : UTIl_UserApprovalUserDataTest
Description : Test Class for UTIl_UserApprovalUserData

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@istest
public with sharing class UTIl_UserApprovalUserDataTest {
    
    static Client_Master__c clientName;
    static Client_Geo_Area_Master__c clientGeoArea;
    static Operating_Group_Master__c operatingGroup;
    static Client_Geo_Unit_Master__c clientGeoUnit;
    static Opportunity_TGP__c oppTGP;
    static Offerings_Master__c offeringMaster;
    static Opportunity_Offering__c oppOffering;
    static User testUser3;
    static User testUser4;
    static User testUser2;
    static User testUserPMO;
    static Document_for_Request_Review__c objDoc;
    static String User_Name2='vc7@testorg.com';
    static String User_Name1='vc71@testorg.com';
    static String User_NamePMO='vc711@testorg.com';
    static List<Opportunity_TGP__c> opportunityList = new List<Opportunity_TGP__c>();
    static Solution_User_Assignment__c sua;
    static List<Solution_User_Assignment__c> suaList = new List<Solution_User_Assignment__c>();
    static MOB_User_Role_Assignment__c mua;
    static List<MOB_User_Role_Assignment__c> muaList = new List<MOB_User_Role_Assignment__c>();
    static Wave_Plan_Version__c wavePlanVersion;
    static Deal_TGP__c deal;
    static List<Deal_TGP__c> dealList = new List<Deal_TGP__c>();
    static Wave_Planning__c waveplan;
    static List<Wave_Planning__c> dealWaverRecords = new List<Wave_Planning__c>();
    static Wave_Process__c WaveProcess;
    static Deal_Location__c dealLoc;
    static List<Deal_Location__c> dealLocationList = new List<Deal_Location__c>();
    static Deal_Home_Location__c dealHome;
    static Delievery_Location_Master__c deliveryLocMa;
    static Client_Geo_Area_Master__c clientGeo;
    static Mob_User_Roles_Master__c mur_Masternew;
    static Review_User_Master__c objReviewUser;
    public static void setupData()
    {  
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        User testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);

        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SYSTEM_ADMIN);
     
        testUser2 = UTIL_DataCreationForTestClass.getUserWithProfile(p,User_Name1);
        Database.insert(testUser2, false);

        p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
        testUser4 = UTIL_DataCreationForTestClass.getUserWithProfile(p,User_Name2);
        Database.insert(testUser4, false);

        system.runas(testUser2)
        {
            clientName = new Client_Master__c (Name = 'Testv1',Active__c = true);
            insert clientName;
            
            clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
            insert clientGeoArea;
            
            operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
            insert operatingGroup;
            
            clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
            insert clientGeoUnit;
         }
        system.runas(testUser)
        {
            
            
            oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                      Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',
                      Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',TCV__C=55);
            insert oppTGP;
            
            objReviewUser= new Review_User_Master__c();
            objReviewUser.Email_ID_of_the_reviewer__c = testUser4.Email;
            objReviewUser.Name='reviewUaser2';
            objReviewUser.SFDC_User__c = testUser4.Id;
            insert objReviewUser;
            
            
            offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
            insert offeringMaster;
            
            oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
            insert oppOffering;
            opportunityList.add(oppTGP);
            
            sua = new Solution_User_Assignment__c (BPO_Opportunity__c=oppTGP.id,Role__c = 'Complex Cost Architect',Offering_Master__c=offeringMaster.id,Solutions__c=oppOffering.id, Status__c = 'New');
            insert sua;
            suaList.add(sua);
            
            
            // To create a Client Geo
        
            clientGeo = UTIL_DataCreationForTestClass.getClientGEOAreaMaster('test');
            clientGeo.Client_Geo_Area_Description__c='TestData';
            insert clientGeo;
        
            // To create a Delivery Location Master
            deliveryLocMa =UTIL_DataCreationForTestClass.getDelieveryLocationMaster('testdata',clientGeo.id);
            
            insert deliveryLocMa;
        
            // To create a Deal
            deal =UTIL_DataCreationForTestClass.getDealRecord('Test Data',testUser.id);
            insert deal;
            dealList.add(deal);
                    
            //To create a Wave Plan Version
            wavePlanVersion =UTIL_DataCreationForTestClass.getWavePlanVersionRecord('Test Data',deal.id);
            insert wavePlanVersion;
        
            // To create a Deal Home Location
            dealHome =UTIL_DataCreationForTestClass.getDealHomeLocation(deliveryLocMa.id,deal.id);         
            insert dealHome;        
        
            // To create a Deal Location
            dealLoc= UTIL_DataCreationForTestClass.getDealLocation('test Data',dealHome.id,wavePlanVersion.id);      
            insert dealLoc;
            dealLocationList.add(dealLoc);
            
            //To cretae a Deal Wave
            waveplan =UTIL_DataCreationForTestClass.getWavePlanning(dealLoc.id,System.today(),'test');
            insert waveplan;
            dealWaverRecords.add(waveplan);
            
            mur_Masternew = new Mob_User_Roles_Master__c(Access_Level__c = 'edit', Role_Name__c = 'Mobilization Architect');
            insert mur_Masternew;
            
            mua = new MOB_User_Role_Assignment__c (Deal__c = deal.Id, Access_Level__c='edit',Role_Name__c = 'Mobilization Architect',Mob_User_Roles_Master__c = mur_Masternew.Id, User_Assigned__c = null, User_Assigned_Secondary__c=null);
            insert mua;
            muaList.add(mua);
                
        }
    }
    
    
    static testMethod void testMethod1()
    {	SetupData();
        test.starttest();
        
        UTIL_UserToApprovalUserData UTIL_UserToApprovalUserDataInstance = new UTIL_UserToApprovalUserData();
        UTIL_UserToApprovalUserDataInstance.updateOpportunityAndOfferingRecords(opportunityList);
        test.stoptest();
    }
       
    static testMethod void testMethod2()
    {	SetupData(); 
        test.starttest();
        
         UTIL_UserToApprovalUserData UTIL_UserToApprovalUserDataInstance = new UTIL_UserToApprovalUserData();      
        UTIL_UserToApprovalUserDataInstance.updateSolutionUserAssignmentRecords(suaList);
        UTIL_UserToApprovalUserDataInstance.updateMobUserAssignmentRecords(muaList);
        test.stoptest();    
    }
    
     static testMethod void testMethod3()
    {	SetupData();
        test.starttest();
        
        UTIL_UserToApprovalUserData UTIL_UserToApprovalUserDataInstance = new UTIL_UserToApprovalUserData();
        UTIL_UserToApprovalUserDataInstance.updateDealRecords(dealList);
        UTIL_UserToApprovalUserDataInstance.updateDealLocationRecords(dealLocationList);
        //UTIL_UserToApprovalUserDataInstance.updateDealWaveRecords(dealWaverRecords); 
        test.stoptest();
    } 
     static testMethod void testMethod4()
    {	SetupData();
        test.starttest();
        
        UTIL_UserToApprovalUserData UTIL_UserToApprovalUserDataInstance = new UTIL_UserToApprovalUserData();
        //UTIL_UserToApprovalUserDataInstance.updateDealRecords(dealList);
        //UTIL_UserToApprovalUserDataInstance.updateDealLocationRecords(dealLocationList);
        UTIL_UserToApprovalUserDataInstance.updateDealWaveRecords(dealWaverRecords); 
        test.stoptest();
    }    
}