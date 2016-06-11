@isTest
 /**   @Author MWBDeveloper
   @name   UTILMobClasses_Test
   @CreateDate 12 April 2015
   @Description UTILMobClasses_Test
   @Version
  */
private class UTILMobClasses_Test{
    /**
   *  @name : validateUtilMobClasses
   *  @Description : validateUtilMobClasses
   *  @param : NA
   *  @return parameter - void
   *  @throws exception- NA
   */
    private static testMethod void validateUtilMobClasses() {
        Test.startTest();

        UTILMobClasses UMC= new UTILMobClasses();
   //     UtilConstants utlc= new UtilConstants();

   //     String objectName;
        List<sObject> recList = new List<sObject>();
        /*
        List<sObject> sObjectList = new List<sObject>();

        Map<Id, sObject> trkrMap = new Map<Id, sObject>();
        Map<String,Schema.SObjectField> fieldsMap =new Map<String,Schema.SObjectField>();
        system.debug('*********fieldsMap ' + fieldsMap );
        String queryFields = UtilConstants.EMPTY_STRING;
        String queryWithFields = UtilConstants.EMPTY_STRING;
        Schema.getGlobalDescribe();
        Schema.SObjectField fields;
        Schema.DescribeFieldResult fieldResult;
        String fieldName;
        List<String> creatableFields = new List<String>();
        String createableFld;
        List<Id> waveIds = new List<Id>();
        */
        //Map<Id, Wave__c > waveRecMap= new Map<Id, Wave__c >();

        /* Map<String,Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe

        ().Fields.getMap(); */


        
        /*
        queryWithFields = UtilConstants.SELECT_STRING +' '+ queryFields + ' '+ UtilConstants.FROM_STRING +' '+ objectName + 

        UtilConstants.WHERE_STRING ; 

        */



        Id userID = UserInfo.getUserId();
        User_Master__c testUserMaster = new User_Master__c();
        testUserMaster.Name = 'testUserMaster';
        //testUserMaster.user__c = userID;
        database.insert( testUserMaster);

        /*
        Deal__Share dealshare1=new Deal__Share();
        dealshare1.Name='DealShare1';
        insert dealshare1;

        */

    //    List<Deal__Share> dealshare=new List<Deal__Share>();

        Deal__c deal=new Deal__c();
        deal.Name='TestDeal';
        deal.Approver__c= testUserMaster.user__c;
        database.insert( deal);


        List<Mobilization_Plan__c> MOBPlanList = new List<Mobilization_Plan__c>();
        Mobilization_Plan__c mobplan=new Mobilization_Plan__c();
        mobplan.Name='MobilizationPlan1';
        mobplan.Deal__c= deal.id;
        mobplan.Active__c=true;
        //insert mobplan;
        MOBPlanList.add(mobplan);
        database.Insert( MOBPlanList);


        List<Wave__c> WaveList = new List<Wave__c>();
        Wave__c wv1=new Wave__c();
        wv1.name='test1';
        wv1.Mobilization_Plan__c=mobplan.id;
        wv1.Planned_Go_Live_Date__c=System.Today()+25;
        wv1.Active__c=true;
        wv1.IsPlanActive__c = true;
        WaveList.add(wv1);
        database.insert( WaveList) ;
      
        UTILMobClasses.getCreatableFields('Opportunity');
        UMC.populateMobilizationPlan(WaveList);
        UMC.checkGTLRoleDelete(recList);
        UMC.findObjectAPIName(MOBPlanList[0].Id);
        Test.stopTest();
    }
}