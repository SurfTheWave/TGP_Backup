/*
@name : UAMSWBMWBUtility_MWB_Test
@Description : 
@Version : 
*/
@isTest
private class UAMSWBMWBUtility_MWB_Test{

    /*
    @name : test_UAMSWBMWBUtility_MWB_Test
    @Description : 
    @Version : 
    */    
    static testMethod void test_UAMSWBMWBUtility_MWB_Test(){
        
         Offering_Master__c offeringMaster=new Offering_Master__c(name='Sourcing and Procurement',
                                                                 offering_description__c='test',
                                                                  flywheel_non_flywheel__c='Yes');
         insert offeringMaster;
         
         Services_Master__c serMaster=new Services_Master__c(name='Sourcing and Category Management Service',
                                                                         offering__c=offeringMaster.id);
         insert serMaster;
         
         Services_Component_Master__c SericeComMaster=new Services_Component_Master__c(name='Sourcing and Category Management Service',
                                                                                     service__c=serMaster.Id, 
                                                                                     service_component_description__c='test');
         insert SericeComMaster;
         
         Procurement_General_Activity_Master__c procMaster=new Procurement_General_Activity_Master__c(Name='promastertest',
                                                                Active__c=true, Activity_Description__c='test',
                                                                Activity_Order__c=2.0,     Type__c='testype');
         insert procMaster;
         
         OPEX_Master__c om = new OPEX_Master__c(Name = 'test OPEX Master', Active__c = True, Days_After_Go_Live__c = 45, Item_Order__c =1);
        insert om;
        
        SRAT_Master__c sratMaster = new SRAT_Master__c(Name = 'test SRAT Mater', Active__c = True, 
                                                        Days_Before_Go_Live__c = 60, Item_Order__c = 1);
        insert sratMaster;
        
         OPEX_Additional_Tracking_Level1_Master__c opeL1Mstr = new OPEX_Additional_Tracking_Level1_Master__c(Name = 'test Mstr', Active__c = true, 
                                                                                                                Order__c = 1.0, OPEX_Master__c = OM.ID);
         insert opeL1Mstr;
         
         SRAT_Additional_Tracking_Level1_Master__c srtL1Mstr = new SRAT_Additional_Tracking_Level1_Master__c(Name = 'test srat Mstr', Active__c= true,
                                                                                                                 Question__c = 'Who are you?', SRAT_Level1_Tracking_Type__c ='Manage Mobilization Program',
                                                                                                                 SRAT_Master__c =  sratMaster.Id );
         insert srtL1Mstr;                                                                                                        
         
         List<User> uList = new List<User>();
         Profile testProfile = [SELECT Id FROM profile WHERE Name = 'Mobilization Editor' LIMIT 1];
          //UserRole usrRole = [SELECT Id, Name FROM UserRole WHERE Name = 'Support User' LIMIT 1];
          //String r = usrRole.Id;
          User testUser = new User(LastName = 'test user 1', 
                             Username = 'test.user.1@example.com', 
                             Email = 'test.1@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id,
                             //UserRole = usrRole,
                             isActive = true, 
                             LanguageLocaleKey = 'en_US');  
          uList.add(testUser);
         
          User testUser2 = new User(LastName = 'test user 1', 
                             Username = 'test.user.2@example.com', 
                             Email = 'test.2@example.com', 
                             Alias = 'testu1', 
                             TimeZoneSidKey = 'GMT', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = testProfile.Id,
                             //UserRole = usrRole,
                             isActive = true, 
                             LanguageLocaleKey = 'en_US'); 
         
          uList.add(testUser2);
          insert uList;
          testUser.id= uList[0].id;
          testUser2.id = uList[1].id;
        
          List<User_Master__c> MasterList= new List<User_Master__c>();
         
          User_Master__c UserMasterRef0= new User_Master__c(Name = 'UserMasterTest0', User__c = testUser.Id);
          MasterList.add(UserMasterRef0);
          User_Master__c UserMasterRef1= new User_Master__c(Name = 'UserMasterTest1' ,User__c = testUser2.Id) ;
          MasterList.add(UserMasterRef1);
          User_Master__c UserMasterRef2= new User_Master__c(Name = 'UserMasterTest2');
          MasterList.add(UserMasterRef2);
         
          insert MasterList;

        
         //Inserting Deal
         
         FlagCheck__c flagTest = new FlagCheck__c(name='Custom Setting',FieldOne__c=false);
         insert flagTest;
         Deal__c strDeal1 = new Deal__c( Name='DealTest123', 
                                            Approver__c = testUser.id, Approval_Status__c = 'Approved');
         insert strDeal1;
        
        
         Client_Specific_Process__c clientSP=new Client_Specific_Process__c(Process_Offering__c=offeringMaster.id,
                                                                         Process_Services__c=serMaster.id,
                                                                         Deal__c=strDeal1.id);  
         insert clientSP;
        
         //Inserting Mob Plan
         Mobilization_Plan__c planUAM= new Mobilization_Plan__c(Deal__c = strDeal1.Id,BCP_Type__c = UtilConstants.CLIENT_DRIVEN_BCP,
                                                               Active__c = true,
                                                               Contract_Legal_In_Scope__c = false,   Service_Management_In_Scope__c = false,
                                                               Journey_Management_In_Scope__c = false); 
                                                               
         insert planUAM;
         
          Wave__c waveForPlan= new Wave__c( Mobilization_Plan__c = planUAM.Id,
                                         Name = 'testWave1', Active__c = true,
                                          Planned_Go_Live_Date__c = System.Today());       
          insert waveForPlan;
         
        
         Wave_Proc__c strWaveProc = new Wave_Proc__c(Wave__c = waveForPlan.Id, Mobilization_Plan__c = planUAM.Id, Wave_Client_Specific_Process__c = clientSP.Id);
         insert strWaveProc;
        
         Risks__c r = new Risks__c (Deal__c = strDeal1.Id); insert r;
         Issues__c i = new Issues__c (Deal__c = strDeal1.Id); insert i;
         Action__c a = new Action__c (Deal__c = strDeal1.id); insert a;
         Decision__c d = new Decision__c (Deal__c = strDeal1.Id); insert d;
         
         //System.debug('After RAID insert ^^^^^^^' + limits.getQueries());
         
         Procurement_Wave_Region__c  procWaveReg = new Procurement_Wave_Region__c(Wave__c = waveForPlan.Id, Name = 'test Proc Wave Region');
         insert procWaveReg;

        List<SRAT_Tracker__c> sratList = new List<SRAT_Tracker__c>();
        SRAT_Tracker__c srat = new SRAT_Tracker__c(Name = 'Day 60 Assessment', 
                                            Wave__c =waveForPlan.Id, Mobilization_Plan__c=planUAM.Id,
                                         SRAT_Master__c =sratMaster.ID ,Days_Before_Go_Live__c = 60  );
         sratList.add(srat);                                
        SRAT_Tracker__c srat2 = new SRAT_Tracker__c(Name = 'Day 15 Assessment', 
                                            Wave__c =waveForPlan.Id, Mobilization_Plan__c=planUAM.Id,
                                         Days_Before_Go_Live__c = 15  );
        sratList.add(srat2);
        SRAT_Tracker__c srat3 = new SRAT_Tracker__c(Name = 'Day 75 Assessment', 
                                            Wave__c =waveForPlan.Id, Mobilization_Plan__c=planUAM.Id,
                                         Days_Before_Go_Live__c = 75  );
        sratList.add(srat3);
        
        insert sratList;
        List<OPEX_Tracker__c> opexList = new List<OPEX_Tracker__c>();
        OPEX_Tracker__c opex = new OPEX_Tracker__c(Name = 'Day 45 Assessment', 
                                                    Wave__c =waveForPlan.Id, Mobilization_Plan__c=planUAM.Id,
                                                    OPEX_Master__c = om.Id, Days_After_Go_Live__c =45 );
        opexList.add(opex);
        OPEX_Tracker__c opex2 = new OPEX_Tracker__c(Name = 'Day 60 Assessment', 
                                                    Wave__c =waveForPlan.Id, Mobilization_Plan__c=planUAM.Id,
                                                     Days_After_Go_Live__c =60 );
         opexList.add(opex2);                                           
         OPEX_Tracker__c opex3 = new OPEX_Tracker__c(Name = 'Day 30 Assessment', 
                                                    Wave__c =waveForPlan.Id, Mobilization_Plan__c=planUAM.Id,
                                                     Days_After_Go_Live__c =30 );                                           
          opexLIst.add(opex3);                                          
         insert opexList;
        
        
        Deal_OPEX_Additional_Tracking_Level_1__c opexL1= new Deal_OPEX_Additional_Tracking_Level_1__c(Name = 'test Level1', OPEX_Tracker_del__c = opexList[0].id,
                                                                                    OPEX_Level_1_Tracking_Type__c= 'Focus the Service operation');
        insert opexL1;

        SRAT_Additional_Tracking_Level_1__c sratL1 = new SRAT_Additional_Tracking_Level_1__c(Name = 'test ssrat Level1', srat_Tracker__c = sratList[0].Id,
                                                                                SRAT_Level_1_Tracking_Type__c = 'Manage Mobilization Program');
        
        insert sratL1;
        Baseline_Mobilization_Plan__C bas= new Baseline_Mobilization_Plan__c(Name = 'Baseline MOb Plan',
                                                                        Deal__C = strDeal1.Id, Mobilization_Plan__c = planUAM.id);
        insert bas;
        
        planUAM.Baseline_Mobilization_Plan__C = bas.Id;
        planUAM.isTrackingOn__c = true;
        update planUAM;
        
        OPEX_Tracker__c opex_q =[SELECT id, Name FROM OPEX_TRacker__C WHERE Mobilization_Plan__c = :planUAM.Id LIMIT 1];
        SRAT_TRacker__c srat_q = [SELECT id, Name FROM SRAT_Tracker__C WHERE Mobilization_Plan__c = :planUAM.Id LIMIT 1 ];
                 
         Test.startTest();
         {
             Mobilization_Team__c MTeamRef = new Mobilization_Team__c();
             MTeamRef.Role__c = 'Deal PMO';
             MTeamRef.Primary_Lead__c = MasterList[0].Id ;
             MTeamRef.Active__c = true;
             MTeamRef.Deal__c = strDeal1.Id;
             MTeamRef.Secondary_Lead_1__c = MasterList[1].Id ;
             MTeamRef.Secondary_Lead_2__c = MasterList[2].Id ;
         
             insert MTeamRef ;
         
             MTeamRef.Secondary_Lead_1__c = MasterList[0].Id ;
             MTeamRef.Secondary_Lead_2__c = MasterList[1].Id ;
             MTeamRef.Primary_Lead__c = MasterList[2].Id ;
             MTeamRef.Role__c = 'Program Control PMO';
             Update MTeamRef;
             
             Boolean accessLevel = [select HasEditAccess,RecordId FROM userRecordAccess WHERE
                                         UserId =: uList[0].Id AND 
                                         RecordId =: strDeal1.Id Limit 10].HasEditAccess;
            //System.debug(LoggingLevel.ERROR, 'accessLevel ******'+ accessLevel );
            //System.assertEquals(True, accessLevel);
            Delete mTeamRef;
             accessLevel = [select HasEditAccess,RecordId FROM userRecordAccess WHERE
                                         UserId =: uList[0].Id AND 
                                         RecordId =: strDeal1.Id Limit 10].HasEditAccess;
            //System.debug(LoggingLevel.ERROR, 'accessLevel %%%%%****'+ accessLevel );
            //System.assertEquals(False, accessLevel);
          }
          Test.stopTest();
}

}