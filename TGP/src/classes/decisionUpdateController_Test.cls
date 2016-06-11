@isTest
/*
@name : decisionUpdateController_Test
@CreateDate : 3/11/2015 8:25 PM
@Description : 
@Version : 
*/
private class decisionUpdateController_Test{
/*
@name : decisionUpdateTestMethod
@CreateDate : 3/11/2015 8:25 PM
@Description : 
@Version : 
*/
    static testMethod void decisionUpdateTestMethod(){          
        UTIL_DataCreationForTestClass utilObj = new UTIL_DataCreationForTestClass();
        User testUser = utilObj.createTestUser('test user 1','test.user.1@example.com','test.1@example.com');
        System.runAs(testUser){
            UtilConstants uc = new UtilConstants(); 
            User_Master__c newMuser = new User_Master__c();
            newMuser.Name = 'test Master User';
            insert newMuser;             
            Deal__c strDeal = new Deal__c(Name='DealTest123');
            insert strDeal;            
            //inserting New Plan under Deal.
            Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = strDeal.id);
            //Database.Insert(strmobplan,false);
            insert strmobplan;                            
            //Inserting new Wave        
            Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today());
            insert strWave;            
            Offering_Master__c offMaster = new Offering_Master__c(Name = UtilConstants.HR,offering_description__c = UtilConstants.TEST_DESC,
            flywheel_non_flywheel__c = UtilConstants.FLYWHEEL);
            insert offMaster;             
            Services_Master__c serviceMaster = new Services_Master__c(Name = UtilConstants.HRSERVICE,offering__c = offMaster.id);
            insert serviceMaster;            
            Geo_Region_Master__c geoRegion = new Geo_Region_Master__c(Name = UTIL_Constants.AsiaPacific,Active__c = true);
            insert geoRegion;            
            Country_Master__c countryMaster = new Country_Master__c(Name='IN', Geo_Region__c = geoRegion.Id);
            insert countryMaster;            
            Delivery_Location_Masters__c deliveryLocMaster = new Delivery_Location_Masters__c(Name = UtilConstants.BANGALORE,country__c = countryMaster.id,
                                                                                            delivery_location_description__c = UtilConstants.TEST_DESC,
                                                                                            active__c=true);
            insert deliveryLocMaster;
            
            Client_Specific_Process__c clientApe = new Client_Specific_Process__c(Name = 'test Client Process', Deal__c =strDeal.Id, Process_Offering__c =offMaster.Id, Process_Services__c = serviceMaster.Id);
            insert clientApe;                    
            Wave_Proc__c strWaveProc = new Wave_Proc__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Wave_Process_Location__c = deliveryLocMaster.Id, Wave_Client_Specific_Process__c = clientApe.Id);
            insert strWaveProc;  
           // Inserting new Journey Mgmt. Tracker under Plan
            Journey_Management_Tracker__c strJourney = new Journey_Management_Tracker__c(Name='JMTrackerTest123',Mobilization_Plan__c=strmobplan.id,Actual_Start_Date__c=System.today()+10,
                                                            Actual_End_Date__c=System.today()+20,Milestone__c=true,Planned_Start_Date__c=System.today()+5,Planned_End_Date__c=System.today()+7,
                                                            Section__c='Journey Map',Responsibility__c='Accenture', Status__c='Not Started', Active__c = True);
            insert strJourney;
                    
            //Service_Management_Tracker__c serviceMgnt = new Service_Management_Tracker__c(Mobilization_Plan__c = strmobplan.Id, Name = 'test Delivery', Planned_Start_Date__c = System.Today()+10, Resource_Name__c ='Test Resource', Planned_End_Date__c=System.Today()+20);
            //insert serviceMgnt;
            
            Contract_Legal_Tracker__c strContract = new Contract_Legal_Tracker__c(Name = 'test Contract and Legal', Mobilization_Plan__c= strmobplan.id, Resource_Name__c= 'test Resource', Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c=System.Today()+20);  
            insert strContract;
                   
            Budget_Trac__c strBudget = new Budget_Trac__c(Name = 'test Budget Tracking',Mobilization_Plan__c= strmobplan.id, Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c=System.Today()+20);
            insert strBudget;
            
            Procurement_Wave_Region__c strProcur = new Procurement_Wave_Region__c(Name = 'test Procurement', Wave__c = strWave.Id);
            insert strProcur;
            
            Procurement_Region_Wise_Activity_Item__c strProcurItem = new Procurement_Region_Wise_Activity_Item__c(Wave__c = strWave.Id, Region__c = strProcur.Id,  Name = 'test Procure Region Activity', Type__c = 'test Type', Value__c = 20);
            insert strProcurItem; 
            
            Procurement_Quarter_Wise_Activity_Item__c strProcurQuar = new Procurement_Quarter_Wise_Activity_Item__c(Name = 'test Procur Quarter', Type__c ='test Type', Wave__c = strWave.Id, Value__c = 10);
            insert strProcurQuar;        
            
            Procurement_General_Activity_Item__c strProcurGen = new Procurement_General_Activity_Item__c(Name = 'test Procur General', Type__c ='test Type', Wave__c = strWave.Id, Value__c = 'test Value');
            insert strProcurGen;
            
            //SRAT_Tracker__c strSRATtrack = new SRAT_Tracker__c(Name = 'test SRAT Tracker', Wave__c =strWave.Id, Mobilization_Plan__c = strmobplan.Id);
            //insert strSRATtrack; 
            
            OPEX_Tracker__c strOPEXTrack = new OPEX_Tracker__c(Name = 'Day 1 Assessment', Wave__c =strWave.Id, Mobilization_Plan__c = strmobplan.Id);
            insert strOPEXTrack; 
            
            strWave.Planned_Go_Live_Date__c = System.Today()+30;
            update strWave;
            Tech_WE_Tracker__c strTech = new Tech_WE_Tracker__c(Name = 'Test Tech and We', Wave__c =strWave.Id, Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c=System.Today()+20);
            insert strTech;
            
            Recruit_Tracker__c strRecruit = new Recruit_Tracker__c(Name = 'Test Tech and We', Wave__c =strWave.Id, Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c=System.Today()+20);
            insert strRecruit;
            
            BCP_Tracker__c strBCP = new BCP_Tracker__c(Name = 'test BCP', Mobilization_Plan__c = strmobplan.Id, Task_Description__c = 'test Desc', Resource_Name__c = 'test Resource', Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c=System.Today()+20);
            insert strBCP;
            
            KT_Trac__c strKTtrack = new KT_Trac__c(Name = 'test KT tracker', Wave__c =strWave.Id, Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c=System.Today()+20);
            insert strKTtrack;
            
            List<Decision__c> lstDecision = new List<Decision__c>();
            Decision__c newDecision = new Decision__c(Title__c = 'test Decision', Forum_Raised__c = 'test Strategic', Raised_By__c = newMuser.Id, Owned_by__c = newMuser.Id,Assigned_To__c= newMuser.Id, Raised_at_level__c = 'test Strategic', Primary_Owner__c = newMuser.Id);
            lstDecision.add(newDecision); 
            insert lstDecision;
        
            Test.startTest();     
            decisionUpdateController newDecisonUpdate = new decisionUpdateController();
            newDecisonUpdate.populateFieldsAfterInsert(lstDecision);
            
            lstDecision[0].Mobilization_Plan__c = strmobplan.Id;
            update lstDecision;        
            newDecisonUpdate.populateFieldsAfterInsert(lstDecision);
            
            lstDecision[0].Wave__c = strWave.Id;
            update lstDecision;        
            newDecisonUpdate.populateFieldsAfterInsert(lstDecision);
            
            lstDecision[0].Wave_Proc__c = strWaveProc.Id;
            update lstDecision;        
            newDecisonUpdate.populateFieldsAfterInsert(lstDecision);
            
            lstDecision[0].Journey_Management_Tracker__c = strJourney.Id;
            update lstDecision;        
            newDecisonUpdate.populateFieldsAfterInsert(lstDecision);
            
            lstDecision[0].Budget_Trac__c = strBudget.Id;
            update lstDecision;        
            newDecisonUpdate.populateFieldsAfterInsert(lstDecision);
            
            lstDecision[0].Procurement_Wave_Region__c = strProcur.Id;
            update lstDecision;        
            newDecisonUpdate.populateFieldsAfterInsert(lstDecision);  
            
            lstDecision[0].Budget_Trac__c = strBudget.Id;
            update lstDecision;        
            newDecisonUpdate.populateFieldsAfterInsert(lstDecision);
            
            lstDecision[0].Contract_Legal_Tracker__c = strContract.Id;
            update lstDecision;        
            newDecisonUpdate.populateFieldsAfterInsert(lstDecision);
            
                    
            lstDecision[0].Procurement_Region_Wise_Activity_Item__c = strProcurItem.Id;
            update lstDecision;        
            newDecisonUpdate.populateFieldsAfterInsert(lstDecision);
            
            lstDecision[0].Procurement_Quarter_Wise_Activity_Item__c = strProcurQuar.Id;
            update lstDecision;        
            newDecisonUpdate.populateFieldsAfterInsert(lstDecision);
            
            lstDecision[0].Procurement_General_Activity_Item__c = strProcurGen.Id;
            update lstDecision;        
            newDecisonUpdate.populateFieldsAfterInsert(lstDecision);
            
            lstDecision[0].OPEX_Tracker__c = strOPEXTrack.Id;
            update lstDecision;        
            newDecisonUpdate.populateFieldsAfterInsert(lstDecision);
            
            lstDecision[0].Tech_WE_Tracker__c = strTech.Id;
            update lstDecision;        
            newDecisonUpdate.populateFieldsAfterInsert(lstDecision);
                   
            lstDecision[0].Recruit_Tracker__c = strRecruit.Id;
            update lstDecision;        
            newDecisonUpdate.populateFieldsAfterInsert(lstDecision); 
                    
            lstDecision[0].KT_Trac__c = strKTtrack.Id;
            update lstDecision;        
            newDecisonUpdate.populateFieldsAfterInsert(lstDecision); 
            
            lstDecision[0].BCP_Tracker__c = strBCP.Id;
            update lstDecision;        
            newDecisonUpdate.populateFieldsAfterInsert(lstDecision); 
            Test.StopTest();
            System.assertEquals((testUser != null), true);
        }
    }
}