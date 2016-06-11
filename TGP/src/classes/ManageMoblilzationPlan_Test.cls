/*
  @Author: 
  @Name: ManageMoblilzationPlan_Test
  @Created Date: 01 January 2015
  @Description:This is a test class for Manage Mobilization Plan.
  @version: 1.0
*/
@isTest
private class ManageMoblilzationPlan_Test{

/*
  @Author: 
  @Name: insertPlanMstrs
  @Created Date: 01 January 2015
  @Description:This is a test method for inserting plan Masters.
  @version: 1.0
*/
static void insertPlanMstrs() {
        BCP_Master__c bCPMaster = new BCP_Master__c(Name = 'test BCP Masters', Section__c = 'Business Impact Analysis', Task__c = 'test Task', BCP_Type__c ='Standard Offering BCP', Task_Order__c = 2, Active__c = True);
            insert bcpMaster;   

             Contract_Legal_Master__c conMaster = new Contract_Legal_Master__c(Name = 'test Contract and Legal', Section__c = 'CP Questions (CPP Process)', Task_Order__c = 3, Active__c = True);
            insert conMaster; 

            Journey_Management_Master__c jrnyMstr = new Journey_Management_Master__c(Name = 'test Journey Mgnt Master', Deliverable_Number__c = 20, Section__c = 'Stakeholder Management', Deliverable__c = 'test Deliverables', Section_Number__c = 12, Active__c = True);
            insert jrnyMstr;
        
            Service_Mgmt_Master__c srvcMstr = new Service_Mgmt_Master__c(Name = 'test Service Mgnt Master', Deliverable__c = 'test deliverables', Deliverable_Order__c = 2, Active__c = True);
            insert srvcMstr;

            Budget_Master__c bdgtMstr = new Budget_Master__c(Name = 'Budget Master', Activity_Order__c = 1.0, Active__c = true);
            insert bdgtMstr;
    }
    
    
/*
  @Author: 
  @Name: manageAllTrackers_testMethod
  @Created Date: 01 January 2015
  @Description:This is a test method to manage all the trackers.
  @version: 1.0
*/    
    static testmethod void manageAllTrackers_testMethod(){
        

        List<Deal__c> dealsList = new List<Deal__c>();
        List<Wave__c> waveList = new List<Wave__c>();
        List<Mobilization_Plan__c> mobplanList= new List<Mobilization_Plan__c>();
        
        UTIL_DataCreationForTestClass utilObj = new UTIL_DataCreationForTestClass();
        User testUser = utilObj.createTestUser('test user 1','test.user.1@example.com','test.1@example.com');        
        insert testUser;
        
        //ManageMoblilzationPlan_Test m = new ManageMoblilzationPlan_Test();
        insertPlanMstrs();
        
        Deal__c strDeal1 = new Deal__c( Name='DealTest123',
                                        Approver__c = testUser.id,
                                        Approval_Status__c = 'Approved');
        dealsList.add(strDeal1);                                
        Deal__c strDeal2 = new Deal__c( Name='DealTest456',
                                        Approver__c = testUser.id,
                                        Approval_Status__c = 'Approved');                                
        dealsList.add(strDeal2);
        Deal__c strDeal3 = new Deal__c( Name='DealTest789',
                                        Approver__c = testUser.id,
                                        Approval_Status__c = 'Approved');
        dealsList.add(strDeal3);                                
        insert dealsList;
        
        
        strDeal1.id=  dealsList[0].id;
        strDeal2.id=  dealsList[1].id;
        strDeal3.id=  dealsList[2].id;
        //System.debug('$$$$ ' +strDeal1.id  + '^^^^^^^^' + strDeal2.id);
        
        Test.startTest();
        {
        
        Mobilization_Plan__c plan123V1= new Mobilization_Plan__c(Deal__c = strDeal1.id,BCP_Type__c = UtilConstants.STD_OFFER,
                                                               Contract_Legal_In_Scope__c = true,  Active__c = true, Service_Management_In_Scope__c = true,
                                                               Journey_Management_In_Scope__c = true);
    
        mobplanList.add(plan123V1);
        Mobilization_Plan__c plan456V1= new Mobilization_Plan__c(Deal__c = strDeal2.id,BCP_Type__c = UtilConstants.NON_STD_OFFER,
                                                Contract_Legal_In_Scope__c = true, Active__c = true,
                                                isTrackingOn__c = true, Service_Management_In_Scope__c = true,
                                                Journey_Management_In_Scope__c = true);
        mobplanList.add(plan456V1);
        
        Mobilization_Plan__c plan789V1= new Mobilization_Plan__c(Deal__c = strDeal3.id,
                                                BCP_Type__c = UtilConstants.CLIENT_DRIVEN_BCP,
                                                Contract_Legal_In_Scope__c = false, Active__c = true,
                                                isTrackingOn__c = false,   Service_Management_In_Scope__c = false,
                                                Journey_Management_In_Scope__c = false);
        mobplanList.add(plan789V1);
        
        
        insert mobplanList;
        
        //System.debug('soql limit after plan insert ^^^^^^' + limits.getQueries());
        
        plan123V1.id= mobplanList[0].id;
        plan456V1.id= mobplanList[1].id; 
        plan789V1.id= mobplanList[2].id; 
        
        
                
        mobplanList = new List<Mobilization_Plan__c>();
        
        Baseline_Mobilization_Plan__c baseLinePlan789V1 = new Baseline_Mobilization_Plan__c(Name = 'Baseline Mobilization Plan', 
                                                                                                   Deal__c = strDeal3.Id,  Mobilization_Plan__c = plan789V1.Id, 
                                                                                                   BCP_Type__c = plan789V1.BCP_Type__c ,   Service_Management_In_Scope__c = plan789V1.Service_Management_In_Scope__c , 
                                                                                                   Journey_Management_In_Scope__c = plan789V1.Journey_Management_In_Scope__c, 
                                                                                                   Version__c =plan789V1.Version__c ,   IsTrackingOn__c = plan789V1.isTrackingOn__c);
        insert baseLinePlan789V1;   
        
        //System.debug('soql limit after basaeline insert ^^^^^^' + limits.getQueries() +'___' + baseLinePlan789V1.id); 
        Wave__c wave123V1 = new Wave__c( Mobilization_Plan__c = plan123V1.id,
                                 Name = 'testWave1',  Planned_Go_Live_Date__c = System.Today());
                                 
        waveList.add(wave123V1) ;
        
        Wave__c wave789V1 = new Wave__c( Mobilization_Plan__c = plan789V1.id,
                                 Name = 'testWave1',    Planned_Go_Live_Date__c = System.Today());
                                 
        waveList.add(wave789V1) ;
        insert waveList;

        //System.debug(' soql limit after wave insert ^^^^^^' + limits.getQueries());
     
        plan123V1.Contract_Legal_In_Scope__c = false;
        plan123V1.Service_Management_In_Scope__c = false;
        plan123V1.Journey_Management_In_Scope__c = false;
        plan123V1.isTrackingOn__c = true;
        plan123V1.BCP_Type__c = UtilConstants.NON_STD_OFFER;
        mobplanList.add(plan123V1);
        
        plan456V1.Contract_Legal_In_Scope__c = false;
        plan456V1.Service_Management_In_Scope__c = false;
        plan456V1.Journey_Management_In_Scope__c = false;
        plan456V1.isTrackingOn__c = false;
        plan456V1.BCP_Type__c = UtilConstants.STD_OFFER;
        mobplanList.add(plan456V1);
        
         /** Out of scope to in scope **/
        plan789V1.Contract_Legal_In_Scope__c = true;
        plan789V1.Service_Management_In_Scope__c = true;
        plan789V1.Journey_Management_In_Scope__c = true;
        plan789V1.Baseline_Mobilization_Plan__c = baseLinePlan789V1.id;
        plan789V1.isTrackingOn__c = false;
        plan789V1.BCP_Type__c = UtilConstants.NON_STD_OFFER;
        mobplanList.add(plan789V1);
        
               
        upsert mobplanList;
        //System.debug(' soql limit after update ^^^^^^' + limits.getQueries());
        
        
        
        mobplanList = new List<Mobilization_Plan__c>();
        /** in scope to out of scope**/
        plan789V1.Contract_Legal_In_Scope__c = false;
        plan789V1.Service_Management_In_Scope__c = false;
        plan789V1.Journey_Management_In_Scope__c = false;
        plan789V1.isTrackingOn__c = true;
        plan789V1.BCP_Type__c = UtilConstants.CLIENT_DRIVEN_BCP;
        mobplanList.add(plan789V1);
        
        Mobilization_Plan__c plan456V2= new Mobilization_Plan__c(Deal__c = strDeal2.id,BCP_Type__c = UtilConstants.STD_OFFER,
                                                               Contract_Legal_In_Scope__c = false, 
                                                               Active__c = true,
                                                               Service_Management_In_Scope__c = false,
                                                               Journey_Management_In_Scope__c = false);
    
        mobplanList.add(plan456V2);
        Mobilization_Plan__c plan123V2= new Mobilization_Plan__c(Deal__c = strDeal1.id,
                                                               BCP_Type__c = UtilConstants.CLIENT_DRIVEN_BCP,
                                                               Contract_Legal_In_Scope__c = false, 
                                                               Active__c = true,
                                                               Service_Management_In_Scope__c = false,
                                                               Journey_Management_In_Scope__c = false);

        mobplanList.add(plan123V2); 
        upsert mobplanList;
        
        
        List<Contract_Legal_Tracker__c> conList = new List<Contract_Legal_Tracker__c>();
        conList  = [SELECT Id, Name FROM Contract_Legal_Tracker__c WHERE Mobilization_Plan__c =: plan123V2.id limit 1];
        System.assertEquals(0, conList.size());
        //System.debug(' soql limit after upsert2^^^^^^' + limits.getQueries());
        
        }
        Test.stopTest();                                                      
     }
     
}


/*****************************************************************************************************************

@isTestData(seeAllData = true)
public class ManageMoblilzationPlan_Test{
   //---Pranjal
    static testMethod void ManageMoblilzationPlanTestMethod(){
    
        Deal__c strDeal = new Deal__c(Name='DealTest123');
        insert strDeal;
        
        //inserting New Plan under Deal.
        List<Mobilization_Plan__c> bcpMobPlans = new List<Mobilization_Plan__c>();        
        Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = strDeal.id, BCP_Type__c = 'Standard Offering BCP', IsTrackingOn__c = True);
        
        bcpMobPlans.add(strmobplan);
        insert bcpMobPlans;
        
        List<BCP_Tracker__c> lstBCP = new List<BCP_Tracker__c>();
        BCP_Tracker__c strBCP = new BCP_Tracker__c(Name = 'test BCP', Mobilization_Plan__c = strmobplan.Id, 
                                                   Task_Description__c = 'test Desc', Resource_Name__c = 'test Resource', 
                                                   Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c=System.Today()+20);
        
        List<BCP_Master__c> lstBCPMaster = new List<BCP_Master__c>();
        BCP_Master__c strBCPMaster = new BCP_Master__c(Name = 'test BCP Masters', Section__c = 'Business Impact Analysis', Task__c = 'test Task', BCP_Type__c ='Standard Offering BCP', Task_Order__c = 2, Active__c = True);
        lstBCPMaster.add(strBCPMaster);
        insert lstBCPMaster;
        
        List<Contract_Legal_Master__c> legalMstrsList = new List<Contract_Legal_Master__c>();
        Contract_Legal_Master__c strConMaster = new Contract_Legal_Master__c(Name = 'test Contract and Legal', Section__c = 'CP Questions (CPP Process)', Task_Order__c = 3, Active__c = True);
        legalMstrsList.add(strConMaster);
        
        List<Contract_Legal_Tracker__c> legalContractList = new List<Contract_Legal_Tracker__c>();
        
        Contract_Legal_Tracker__c strContract = new Contract_Legal_Tracker__c(Name = 'test Contract and Legal', Mobilization_Plan__c= strmobplan.id, Resource_Name__c= 'test Resource', Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c=System.Today()+20, Section__c = 'CP Questions (CPP Process)', Task_Order__c = 3, Active__c = True);  
        
        legalContractList.add(strContract);
        
        List<Journey_Management_Master__c> jrnyMstrs = new List<Journey_Management_Master__c>(); 
        Journey_Management_Master__c strMstrJrny = new Journey_Management_Master__c(Name = 'test Journey Mgnt Master', Deliverable_Number__c = 20, Section__c = 'Stakeholder Management', Deliverable__c = 'test Deliverables', Section_Number__c = 12, Active__c = True);
        jrnyMstrs.add(strMstrJrny);
        insert jrnyMstrs;
        
        List<Journey_Management_Tracker__c> lstJrnyMgntTrkrs = new List<Journey_Management_Tracker__c>();
        Journey_Management_Tracker__c jTrkr = new Journey_Management_Tracker__c(Mobilization_Plan__c = strmobplan.Id, Name = 'test Journey Mgnt Tracker', Responsibility__c = 'Accenture', Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c = System.Today()+20, IsPlanActive__c = True, IsTrackingOn__c = True);
        lstJrnyMgntTrkrs.add(jTrkr);
        insert lstJrnyMgntTrkrs;
        
        Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today()+30);
        insert strWave;
        
        OPEX_Tracker__c ot = new OPEX_Tracker__c(Wave__c = strWave.Id, Mobilization_Plan__c = strmobplan.Id, Name = 'Day 1 Assessment');
        insert ot;
        
        OPEX_Master__c om = new OPEX_Master__c(Name = 'test OPEX Master', Active__c = True, Days_After_Go_Live__c = 2, Item_Order__c =3);
        insert om;
            
        Deal_OPEX_Additional_Tracking_Level_1__c OpexLevel1 = new Deal_OPEX_Additional_Tracking_Level_1__c(OPEX_Tracker_del__c = ot.Id, Name = 'test OPEX Additonal Master');
        insert OpexLevel1;
        
        Deal_OPEX_Additional_Tckn_Level_2_MOMC__c dealOPEXLevel2 = new Deal_OPEX_Additional_Tckn_Level_2_MOMC__c(Deal_OPEX_Additional_Tracking_Level_1__c = OpexLevel1.Id);
        insert dealOPEXLevel2;
        
        List<Service_Mgmt_Master__c> svceMstrsList = new List<Service_Mgmt_Master__c>();
        Service_Mgmt_Master__c smm = new Service_Mgmt_Master__c(Name = 'test Service Mgnt Master', Deliverable__c = 'test deliverables', Deliverable_Order__c = 2, Active__c = True);
        
        svceMstrsList.add(smm);
        insert svceMstrsList;
                
        Service_Management_Tracker__c svceTrkr= new Service_Management_Tracker__c(Name = 'test Service Mgnt Tracker', IsPlanActive__c = True, Mobilization_Plan__c = strmobplan.Id, Resource_Name__c = 'test Resource data', Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c = System.Today()+20, Service_Management_Master__c = svceMstrsList[0].Id);
        insert svceTrkr;
        
        SRAT_Master__c sratMaster = new SRAT_Master__c(Name = 'test SRAT Mater', Active__c = True, Days_Before_Go_Live__c = 3, Item_Order__c = 3);
        insert sratMaster;
        
        SRAT_Additional_Tracking_Level1_Master__c sratAddMaster = new SRAT_Additional_Tracking_Level1_Master__c(Name = 'test SRAT Master', Order__c = 2, Question__c = 'test Question', SRAT_Level1_Tracking_Type__c = 'Manage Mobilization Program', Active__c = True, SRAT_Master__c = sratMaster.Id);
        insert sratAddMaster;
        
        List<SRAT_Tracker__c> lstSratTracker = new List<SRAT_Tracker__c>();
        SRAT_Tracker__c strSRATtrack = new SRAT_Tracker__c(Name = 'test SRAT Tracker', Mobilization_Plan__c = bcpMobPlans[0].Id, SRAT_Master__c =sratMaster.Id, Wave__c = strWave.Id);
        lstSratTracker.add(strSRATtrack);
        insert lstSratTracker;
        
    
        Test.startTest();
    
        ManageMoblilzationPlan newMBP = new ManageMoblilzationPlan();        
        newMBP.insertBCPTrackers(bcpMobPlans);
        newMBP.insertLegalTrackers(bcpMobPlans);
        newMBP.insertJrnyTrkrs(bcpMobPlans);
        newMBP.insertSvceTrkrs(bcpMobPlans);
        Test.stopTest();
    }
     

    static testmethod void manageAllTrackers_testMethod(){
        
        Mobilization_Plan__c mobupd = new Mobilization_Plan__c();
        Mobilization_Plan__c mobplanV2 = new Mobilization_Plan__c();
        List<Deal__c> dealsList = new List<Deal__c>();
        List<Wave__c> waveList = new List<Wave__c>();
        List<Mobilization_Plan__c> mobplanList= new List<Mobilization_Plan__c>();
        
        UTIL_DataCreationForTestClass utilObj = new UTIL_DataCreationForTestClass();
        User testUser = utilObj.createTestUser('test user 1','test.user.1@example.com','test.1@example.com');        
        insert testUser;
        
        ManageMoblilzationPlan_Test m = new ManageMoblilzationPlan_Test();
        m.insertPlanMstrs();
        
        Deal__c strDeal1 = new Deal__c( Name='DealTest123',
                                        Approver__c = testUser.id,
                                        Approval_Status__c = 'Approved');
        dealsList.add(strDeal1);                                
        Deal__c strDeal2 = new Deal__c( Name='DealTest456',
                                        Approver__c = testUser.id,
                                        Approval_Status__c = 'Approved');                                
        dealsList.add(strDeal2);
        Deal__c strDeal3 = new Deal__c( Name='DealTest789',
                                        Approver__c = testUser.id,
                                        Approval_Status__c = 'Approved');
        dealsList.add(strDeal3);                                
        insert dealsList;  
        strDeal1.id=  dealsList[0].id;
        strDeal2.id=  dealsList[1].id;
        strDeal3.id=  dealsList[2].id;
        System.debug('$$$$ ' +strDeal1.id  + '^^^^^^^^' + strDeal2.id);
        
        Test.startTest();
        {
        Mobilization_Plan__c plan123V1= new Mobilization_Plan__c(Deal__c = strDeal1.id,BCP_Type__c = UtilConstants.STD_OFFER,
                                                               Contract_Legal_In_Scope__c = true, 
                                                               Active__c = true,
                                                               Service_Management_In_Scope__c = true,
                                                               Journey_Management_In_Scope__c = true);
    
        mobplanList.add(plan123V1);
       
        Mobilization_Plan__c plan456V1= new Mobilization_Plan__c(Deal__c = strDeal2.id,
                                                BCP_Type__c = UtilConstants.NON_STD_OFFER,
                                                Contract_Legal_In_Scope__c = true, 
                                                Active__c = true,
                                                isTrackingOn__c = true,
                                                Service_Management_In_Scope__c = true,
                                                Journey_Management_In_Scope__c = true);
        mobplanList.add(plan456V1);
        
        Mobilization_Plan__c plan789V1= new Mobilization_Plan__c(Deal__c = strDeal3.id,
                                                BCP_Type__c = UtilConstants.NON_STD_OFFER,
                                                Contract_Legal_In_Scope__c = false, 
                                                Active__c = true,
                                                isTrackingOn__c = false,
                                                Service_Management_In_Scope__c = false,
                                                Journey_Management_In_Scope__c = false);
        mobplanList.add(plan789V1);
        
        
        insert mobplanList;
        System.debug(' soql limit after plan insert ^^^^^^' + limits.getQueries());
        
        plan123V1.id= mobplanList[0].id;
        plan456V1.id= mobplanList[1].id; 
        plan789V1.id= mobplanList[2].id; 
        System.debug('&&&&' +plan123V1.id + '****' + plan456V1.id );
        
        mobplanList = new List<Mobilization_Plan__c>();
        
         Wave__c wave123V1 = new Wave__c( Mobilization_Plan__c = plan123V1.id,
                                 Name = 'testWave1',
                                 Planned_Go_Live_Date__c = System.Today());
                                 
        waveList .add(wave123V1) ;
        
        Wave__c wave789V1 = new Wave__c( Mobilization_Plan__c = plan789V1.id,
                                 Name = 'testWave1',
                                 Planned_Go_Live_Date__c = System.Today());
                                 
        waveList.add(wave789V1) ;
        insert waveList;
        //limits.getQueries();
        System.debug(' soql limit after wave insert ^^^^^^' + limits.getQueries());

        
       MobilizationReBaseline.baselineMobilizationPlan(plan789V1.id, false);
        
        System.debug(' soql limit after baseline  ^^^^^^' + limits.getQueries());
        ////Out of scope to in scope 
        plan789V1.Contract_Legal_In_Scope__c = true;
        plan789V1.Service_Management_In_Scope__c = true;
        plan789V1.Journey_Management_In_Scope__c = true;
        plan789V1.isTrackingOn__c = true;
        plan789V1.BCP_Type__c = UtilConstants.CLIENT_DRIVEN_BCP;
        mobplanList.add(plan789V1);
        
        // in scope to out of scope
        Mobilization_Plan__c plan456V2= new Mobilization_Plan__c(Deal__c = strDeal2.id,BCP_Type__c = UtilConstants.STD_OFFER,
                                                               Contract_Legal_In_Scope__c = false, 
                                                               Active__c = true,
                                                               Service_Management_In_Scope__c = false,
                                                               Journey_Management_In_Scope__c = false);
    
        mobplanList.add(plan456V2);
        Mobilization_Plan__c plan123V2= new Mobilization_Plan__c(Deal__c = strDeal1.id,
                                                               BCP_Type__c = UtilConstants.CLIENT_DRIVEN_BCP,
                                                               Contract_Legal_In_Scope__c = false, 
                                                               Active__c = true,
                                                               Service_Management_In_Scope__c = false,
                                                               Journey_Management_In_Scope__c = false);
    
        //insert plan123V2;
         mobplanList.add(plan123V2); 
        upsert mobplanList;
        }
        Test.stopTest();                                                      
    }
    
****************************************************************************************************************/