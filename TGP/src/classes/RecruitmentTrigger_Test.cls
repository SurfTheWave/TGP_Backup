/*
   @Author       : 
   @Class name   : RecruitmentTrigger_Test
   @CreateDate   : 
   @Description : 
   @Version : 1.0 
  */
@isTest
private class RecruitmentTrigger_Test{
    
    Private static List<Recruit_Tracker__c> lstRecTrack = new List<Recruit_Tracker__c>();
    //setup test data
    /******************************
     * Method Name: setupData
     * Description: test data setup for Recruitment trigger functionality testing
     * Paramenters: 
     * Return Value: 
     *******************************/
    public static void setupData(){
        
        //insert MAster User data
        User_Master__c newMasterUser = new User_Master__c(Name = 'test Master User');
        insert newMasterUser; 
        //insert deal data
        Deal__c strDeal = new Deal__c(Name='DealTest123');
        insert strDeal;
        //inserting New Plan under Deal.
        Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = strDeal.id);
        //Database.Insert(strmobplan,false);
        insert strmobplan;
        //Inserting new Wave        
        Wave__c strWave = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id, Planned_Go_Live_Date__c= System.Today()+30);
        insert strWave;        
        //Insert Recruitment Tracker
        Recruit_Tracker__c strRecruitTrack = new Recruit_Tracker__c(Name ='test Activity', Wave__c = strWave.Id, Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c = System.Today()+20);
        //insert strRecruitTrack;
        lstRecTrack.add(strRecruitTrack);
        //test insert for sObject
        insert lstRecTrack;
        //Deleting the test user data
        delete lstRecTrack;
        //Utility method 
        UtilConstants uc = new UtilConstants();
        List<SObject> sobjectList = new List<SObject>();
        sobjectList.add(lstRecTrack[0]);
            
    }
    //
     /******************************
     * Method Name: RecruitmentTriggerTest
     * Description: test starts by taking the test data.
     * Paramenters: 
     * Return Value: 
     *******************************/
    static testMethod void RecruitmentTriggerTest(){
        //system.runAs(testUser);
        Test.startTest();        
        setupData();  
        UTILMobClasses util =  new UTILMobClasses();
        util.populateMobilizationPlan(lstRecTrack);      
        Test.stopTest();        
    }

}