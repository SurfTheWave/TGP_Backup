@isTest
private class UAMSolMobUtilityTest
{
    static User testUser;
    static User testUser1; 
    static Client_Master__c clientName;
    static Client_Geo_Area_Master__c clientGeoArea;
    static Operating_Group_Master__c operatingGroup; 
    static Client_Geo_Unit_Master__c clientGeoUnit; 
    static Opportunity_TGP__c oppTGP;
    static String USER_Name = 'vc7@testorg.com';
    static Service_Master__c serviceMaster; 
    static Assumption_Master__c assumptionMaster;
    static Offerings_Master__c offeringMaster;
    static Opportunity_Offering__c oppOffering;
    static Assumption__c assumption;  
    static Mob_User_Roles_Master__c strMoURM; 
    static Wave_Plan_Version__c wavePlanVersion;
    static Deal_TGP__c deal;
    static Wave_Planning__c waveplan;
    static Wave_Process__c WaveProcess;
    static Deal_Location__c dealLoc;
    static Deal_Home_Location__c dealHome;
    static Delievery_Location_Master__c deliveryLocMa;
    static Client_Geo_Area_Master__c clientGeo;
    static Deal_Location_Facility__c dealLocFac;
    static Commercial_Planning__c comPlan;
    static Facility_Master__c FacMaster;
    //static string USER_NAME1 = 'vc123@testorg.com';
    static Offerings_Master__c offering;
    static Client_Specific_Process_Mapping__c clientSpecificProcessMapping;
    static UAM_Roles_Permissions__c uamRoles;
    static UAM_Roles_Permissions__c uamRoles1;
    
    public static void setupData()
    {
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);     
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
        Database.insert(testUser, false);
        
        Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.SOLUTION_ADMIN);
        testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p1,'vc123@testorg.com');
        Database.insert(testUser1, false);
        
        system.Runas(testUser1)
        {
            clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
            insert clientName;
      
            clientGeoArea = new Client_Geo_Area_Master__c (Name = 'Latin America',Active__c = true);
            insert clientGeoArea;
      
            operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
            insert operatingGroup;
            
            clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
            insert clientGeoUnit;
        }
        
        system.Runas(testUser)
        {
            oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Client_Geo_Area_Prior_Value__c=UTIL_Constants.AsiaPacific,Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='Pipeline',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No');
            insert oppTGP;      
        }
        
        system.Runas(testUser)
        {
            offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
            insert offeringMaster;     
          
            serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
            insert serviceMaster;
            
            assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
            insert assumptionMaster;

        }
        oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppTGP.id);
        insert oppOffering;
     
        assumption = new Assumption__c (Name = 'TestAssumption',Assumption_Master__c = assumptionMaster.id,Category__c = 'TestPeople',Editable__c =True,Applicable__c = True,Opportunity_Offering__c= oppOffering.id );
        insert assumption;
        
    }
    
    public static void setupData1()
    {
        
        Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_NAME);
        insert testUser;
        
        Profile p1 = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.MOB_ADMIN);
        testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,'vc123@testorg.com');
        Database.insert(testUser1, false);
            
        // To create a Client Geo
    
        clientGeo = UTIL_DataCreationForTestClass.getClientGEOAreaMaster('test');
        clientGeo.Client_Geo_Area_Description__c='TestData';
        insert clientGeo;
    
        // To create a Delivery Location Master
        deliveryLocMa = UTIL_DataCreationForTestClass.getDelieveryLocationMaster('testdata',clientGeo.id);
        
        insert deliveryLocMa;
    
        // To create a Deal
        deal = UTIL_DataCreationForTestClass.getDealRecord('Test Data',testUser1.id);
        insert deal;
    
        // To create a offering
        offering = UTIL_DataCreationForTestClass.getOfferingMaster('Test Data');        
        insert offering;
    
        //To create a Wave Plan Version
        wavePlanVersion =UTIL_DataCreationForTestClass.getWavePlanVersionRecord('Test Data',deal.id);
        insert wavePlanVersion;
    
        // To create a Deal Home Location
        dealHome = UTIL_DataCreationForTestClass.getDealHomeLocation(deliveryLocMa.id,deal.id);         
        insert dealHome;
        
        uamRoles = new UAM_Roles_Permissions__c(name = '10001',Object_Name__c='Opportunity_TGP__c',Permissions__c='CRU',Roles__c='Enterprise_Solution_Architect__c');
        insert uamRoles ;
        
        uamRoles1 = new UAM_Roles_Permissions__c(name = '10002',Object_Name__c='Deal_TGP__c',Permissions__c='CRU',Roles__c='Enterprise_Solution_Architect__c');
        insert uamRoles1 ;
        // To create a Deal Location
        dealLoc = UTIL_DataCreationForTestClass.getDealLocation('test Data',dealHome.id,wavePlanVersion.id);      
        insert dealLoc;
    
        // To Create Client Specific Process Mapping
    
        clientSpecificProcessMapping = UTIL_DataCreationForTestClass.getClientSpecificProcessMapping('TestData',deal.id,offering.id);
        insert clientSpecificProcessMapping;
    
        //To create a Wave Plan
    
        waveplan = UTIL_DataCreationForTestClass.getWavePlanning(dealLoc.id,System.today(),'test');
        waveplan.Wave_Comment__c='test data';
        waveplan.Wave_Label__c='TestData';
        waveplan.GO_Live_Date_del__c=date.today()+7;
        waveplan.Deal_Location__c=dealLoc.id;
        waveplan.Number_of_Projected_FTEs__c=1;
        insert waveplan; 
    
        // To create a Wave Process
    
        WaveProcess =UTIL_DataCreationForTestClass.getWaveProcess(waveplan.id);        
        WaveProcess.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
        insert WaveProcess;
        
        strMoURM=new Mob_User_Roles_Master__c();
        strMoURM.Access_Level__c='Edit';
        strMoURM.Role_Name__c='Governance Lead';
        insert strMoURM;
        
        // To Create Commercial Planning
        comPlan = UTIL_DataCreationForTestClass.getWaveCommercialPlanning('TestData','TestData',86);
        comPlan.Delivery_Location__c=deliveryLocMa.id;
        comPlan.Planned_Start_Date__c=date.today();
        comPlan.Planned_End_Date__c=date.today()+7;
        insert comPlan;
    
        //To create a Facility Master 
        FacMaster= new Facility_Master__c();
        FacMaster.Name='test';
        FacMaster.Delivery_Location_Master__c=deliveryLocMa.id;
        insert FacMaster;
        //To create a Deal Location Facility
        dealLocFac=new Deal_Location_Facility__c();
        dealLocFac.Deal_Home_Location__c=dealHome.id;
        dealLocFac.Facility_Master__c=FacMaster.id;
        insert dealLocFac;
        
        MOB_User_Role_Assignment__c roleAssign = new MOB_User_Role_Assignment__c();
        roleAssign.Access_Level__c='Edit';
        roleAssign.Deal__c=deal.id;
        roleAssign.Mob_User_Roles_Master__c=strMoURM.id;
        roleAssign.Role_Name__c='Governance Lead';
        roleAssign.User_Assigned__c=testUser.id;
        roleAssign.User_Assigned_Secondary__c=testUser.id;
        insert roleAssign ;
      
    }
    
    static testMethod void testUamAccessUtillity()
    {
        test.starttest();
        setupData();
        system.Runas(testUser)
        {
            apexpages.currentpage().getparameters().put(UTIL_Constants.URL_PARAMETER_ID ,oppTGP.id);
            UAMSolMobUtility.RunSoqlQueries(oppTGP.id);
        } 
        
        test.stoptest();
    }
    static testMethod void testUamAccessUtillity1()
    {
        test.starttest();
        setupData1();
        system.Runas(testUser)
        {
            apexpages.currentpage().getparameters().put(UTIL_Constants.DEAL_ID_STRING ,deal.id);
            UAMSolMobUtility.RunSoqlQueries(deal.id);
            UAMSolMobUtility.uamAccessUtillity();
        }
        test.stoptest();
    }    
}