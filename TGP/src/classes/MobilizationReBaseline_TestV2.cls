@isTest(seeAllData = true)
/******************
 * @class name : MobilizationReBaseline_TestV2
  
 * @description :
******************/
private class MobilizationReBaseline_TestV2{

    static Client_Specific_Process__c clientSP = new Client_Specific_Process__c ();
    //String clientSpId = new String();
/******************
 * @method name : planToTrkId
  
 * @description :
******************/
    static String planToTrkId;
 /******************
 * @method name : loadData
  
 * @description :
******************/
    static String loadData(){
        List<Deal__c> dealsList = new List<Deal__c>();
        List<Wave__c> waveList = new List<Wave__c>();
        List<Mobilization_Plan__c> mobplanList= new List<Mobilization_Plan__c>();
        
        UTIL_DataCreationForTestClass utilObj = new UTIL_DataCreationForTestClass();
        User testUser = utilObj.createTestUser('test user 1','test.user.1@example.com','test.1@example.com');        
        insert testUser;
        
        Offering_Master__c offeringMaster=new Offering_Master__c(name='Test Offering',offering_description__c='test',flywheel_non_flywheel__c='Yes');
         insert offeringMaster;
         
         Services_Master__c serMaster=new Services_Master__c(name='test Service Master',offering__c=offeringMaster.id);
         insert serMaster;
         
         Services_Component_Master__c SericeComMaster=new Services_Component_Master__c(name='Sourcing Service',service__c=serMaster.id, service_component_description__c='test');
         insert SericeComMaster;
            
            
        
        Deal__c strDeal1 = new Deal__c( Name='DealTest123',
                                        Approver__c = testUser.id,
                                        Approval_Status__c = 'Approved');
        insert strDeal1;
        
        
        Client_Specific_Process__c cSP=new Client_Specific_Process__c(Process_Offering__c=offeringMaster.id,
         Process_Services__c=serMaster.id,
          Deal__c=strDeal1.id);  
          insert cSP;
          clientSP.id = cSP.Id; 
       
        Mobilization_Plan__c plantoBaseline= new Mobilization_Plan__c(Deal__c = strDeal1.Id,BCP_Type__c = UtilConstants.STD_OFFER,
          Active__c = true,Contract_Legal_In_Scope__c = true,   Service_Management_In_Scope__c = true,Journey_Management_In_Scope__c = true); 
                                                               
        insert planToBaseline;
       /* 
         Mobilization_Plan__c  plantoTrk = new Mobilization_Plan__c (Deal__c = planToBaseline.Deal__c ,BCP_Type__c = UtilConstants.STD_OFFER,
                                                               Active__c = true,
                                                               Contract_Legal_In_Scope__c = false,   Service_Management_In_Scope__c = false,
                                                               Journey_Management_In_Scope__c = false);
       insert planToTrk;
       planToTrkId = planToTrk.Id;
       */  
         return planToBaseline.id;
                                                 
    }
/*****************
  * @methodname: baselineMobilizationPlan_testMethod
  * @description:
*****************/
    static testmethod void baselineMobilizationPlan_testMethod(){
    
        //Deal__c strDeal__c = new Deal__c();
        String planToBaselineId = loadData();
         List<Wave__c> waveList = new List<Wave__c>();
        
        Wave__c waveForPlan= new Wave__c( Mobilization_Plan__c = planToBaselineId,
                                         Name = 'testWave1', Active__c = true,
                                          Planned_Go_Live_Date__c = System.Today());       
        
        waveList .add(waveForPlan) ;
        
        Wave__c inactiveWavePlan = new Wave__c( Mobilization_Plan__c = planToBaselineId,  Name = 'testWave2', Active__c = true, Planned_Go_Live_Date__c = System.Today());
                                 
        waveList.add(inactiveWavePlan ) ;
        insert waveList;
        waveForPlan.id = waveList[0].id;
        inactiveWavePlan.id = waveList[1].id;
        
        inactiveWavePlan.Active__c = false;
        update inactiveWavePlan;
        
        wave_Proc__c wp =new wave_Proc__c (Wave__c = waveForPlan.id,  Wave_Client_Specific_Process__c=clientSP.id);
        insert wp;
        
       // System.debug('Limits after wave process insert ^^^^^^^^ ' + limits.getQueries());
        Boolean checkForTracking = true;
        String statusMsg = MobilizationReBaseline.baselineMobilizationPlan(planToBaselineId, true);    
        
        if(checkForTracking){
            Baseline_Mobilization_Plan__c  bsMp = [SELECT ID, Name FROM Baseline_Mobilization_Plan__c  WHERE Mobilization_Plan__c = :planToBaselineId LIMIT 1];
            System.assertEquals(bsMp.Id, statusMsg);
        }
        else{
            System.assertEquals(UtilConstants.SUCCESS_MESSAGE, statusMsg);                                                                                                                           
            }
        //System.debug('Status^^^^' + statusMsg);
   }
    

  /*  
    static testmethod void baselineMobilizationPlan_testMethod2(){
        String planToBaselineId = loadData();
        Mobilization_Plan__c  planToBaseline = new Mobilization_Plan__c  ();
        planToBaseline =[SELECT Id, Deal__c FROM Mobilization_Plan__c  WHERE Id= :planToBaselineId];
        
       
       test.startTest(); {
        List<Wave__c> waveList = new List<Wave__c>();
        
        Wave__c wave_PlanBase= new Wave__c( Mobilization_Plan__c = planToBaselineId,
                                         Name = 'testWave1', Active__c = true,
                                          Planned_Go_Live_Date__c = System.Today());       
        waveList .add(wave_PlanBase) ;
        
        Wave__c inactiveWave_PlanBase = new Wave__c( Mobilization_Plan__c = planToBaselineId,  Name = 'testWave2', Active__c = false, Planned_Go_Live_Date__c = System.Today());
        waveList.add(inactiveWave_PlanBase) ;
        
        Wave__c wave_PlanTrk= new Wave__c( Mobilization_Plan__c = planToTrkId, Name = 'testWave3', Active__c = true,
                                          Planned_Go_Live_Date__c = System.Today() + 30);       
        waveList.add(wave_PlanTrk) ;
        
        insert waveList;
        //System.debug('Limits after wave insert ^^^^^^^^ ' + limits.getQueries());
        wave_PlanBase.Id = waveList[0].id;
        inactiveWave_PlanBase.Id = waveList[1].id;
        
        wave_Proc__c wp =new wave_Proc__c (Wave__c = wave_PlanBase.id,  Wave_Client_Specific_Process__c=clientSP.id);
        insert wp;
        
        //System.debug('Limits after wave process insert ^^^^^^^^ ' + limits.getQueries());
        Boolean checkForTracking = true;
        String statusMsg = MobilizationReBaseline.baselineMobilizationPlan(planToBaselineId, true); 
        
        String statusMsg_PlanToTrk = MobilizationReBaseline.baselineMobilizationPlan(planToTrkId, false);
         }
        test.stopTest();
    }
    */
}