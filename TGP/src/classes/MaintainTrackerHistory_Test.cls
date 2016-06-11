/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class MaintainTrackerHistory_Test {
    
    private static User testUser;
    private static Deal__c strDeal;
    private static Mobilization_Plan__c strmobplan;
    private static Wave__c strWave;
    private static Journey_Management_Tracker__c strJourney;
    private static boolean showMessage {get;set;}
    private static boolean WaveTrue {get;set;}
    private static final String CLASS_NAME='MaintainTrackerHistory_Test';
// Setting up test data.
 /******************************
     * Method Name: setupData
     * Description: 
     * Paramenters: 
     * Return Value: profile
     *******************************/
  public static void setupData()
    {
    
    try
    {
        // Getting Profile
        Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Admin);
        // Getting testUser with Profile.
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
        Database.insert(testUser, false);
        // Inserting new Test Deal
        strDeal=new Deal__c(Name='DealTest123');
        insert strDeal;
        //inserting New Plan under Deal.
        strmobplan = new Mobilization_Plan__c(Name='planTest123', Deal__c=strDeal.id);
        Database.Insert(strmobplan,false);
        // Inserting new Journey Mgmt. Tracker under Plan
        strJourney =new Journey_Management_Tracker__c(Name='JMTrackerTest123',Mobilization_Plan__c=strmobplan.id,Actual_Start_Date__c=System.today()+10,
                                    Actual_End_Date__c=System.today()+20,Milestone__c=true,Planned_Start_Date__c=System.today()+5,Planned_End_Date__c=System.today()+7,
                                    Section__c='Journey Map',Responsibility__c='Accenture', Status__c='Not Started' );
        insert strJourney; 
        // UPDATING THE RECORD
        strJourney = [select id,Actual_Start_Date__c,Actual_End_Date__c,Planned_Start_Date__c,Planned_End_Date__c from Journey_Management_Tracker__c where Name='JMTrackerTest123' limit 100];
        strJourney.Responsibility__c = 'Client';
        strJourney.Actual_Start_Date__c=date.valueof('2015-01-13');
        strJourney.Milestone__c=false;
        update strJourney;
        
        // updating in History object
        Journey_Management_Tracker__History journeyHistory = new  Journey_Management_Tracker__History(ParentId =strJourney.Id, Field='Actual_Start_Date__c');
        insert journeyHistory;
        
        showMessage  = false;
        WaveTrue= false;
       }
       Catch(DMLException e)
       {
           UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,CLASS_NAME, CLASS_NAME, 
                   null, System.Logginglevel.ERROR);           
       }
    }
  //my test starts by taking the test data.
    /******************************
     * Method Name: myUnitTest
     * Description: my test starts by taking the test data
     * Paramenters: 
     * Return Value: profile
     *******************************/ 
   static testMethod void myUnitTest() {
       //   system.runAs(testUser){
            setupData();
            Test.startTest();
            PageReference pageRef= Page.MaintainTrackerHistory_VFP;
            Test.setCurrentPageReference(pageRef);
            DateTime dateVal=DateTime.now();
            DateTime dateValNew=dateVal+1;
            pageRef.getParameters().put('ObjName', 'Journey_Management_Tracker__c');
            pageRef.getParameters().put('ID',strJourney.id );
            pageRef.getParameters().put('Field1', 'Responsibility__c');
            pageRef.getParameters().put('Field2', 'Actual_Start_Date__c');
            pageRef.getParameters().put('Field3', 'Milestone__c');
            pageRef.getParameters().put('Field4', '');
            pageRef.getParameters().put('Field5', '');
            pageRef.getParameters().put('Field6', '');
            pageRef.getParameters().put('Field7', '');
            pageRef.getParameters().put('Field8', '');
            pageRef.getParameters().put('Field9', '');
            pageRef.getParameters().put('Field10', '');
            pageRef.getParameters().put('Field11', '');
            pageRef.getParameters().put('Field12', '');
            pageRef.getParameters().put('Wave', 'NA');
            
            try{
                MaintainTrackerHistoryController myTrackerHistory = new MaintainTrackerHistoryController ();
            }catch(Exception ex){
                UTIL_LoggingService.logHandledException(ex, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,CLASS_NAME, CLASS_NAME, 
                        null, System.Logginglevel.ERROR);               
            }
        
        
        MaintainTrackerHistoryController.HistoryInfo hist = new MaintainTrackerHistoryController.HistoryInfo('Actual_Start_Date__c',String.valueof(dateVal),String.valueof(dateVal),'System',String.valueof(dateVal),'NA');
        if(pageRef.getParameters().get('Wave')!='NA')
            {
                WaveTrue= true;
            }else{
                WaveTrue = false;
            }
        
               
        Test.stopTest();
    }
  // }
}