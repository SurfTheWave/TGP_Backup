@isTest
public class SRATRecTypeL1L2Update_Test {
    public static SRAT_Additional_Tracking_Level_1__c sratL1;
    public static SRAT_Additional_Tracking_Level_2__c sratL2;
    //public static SRAT_Additional_Tracking_Level_2_FST__c sratL3;
    private static void setupData(){ 
        
        List<Deal__c> dealsList = new List<Deal__c>();
        List<Wave__c> waveList = new List<Wave__c>();
        List<Mobilization_Plan__c> mobplanList= new List<Mobilization_Plan__c>();
        UTIL_DataCreationForTestClass utilObj = new UTIL_DataCreationForTestClass();
        User testUser = utilObj.createTestUser('test user 1','test.user.1@example.com','test.1@example.com');        
        insert testUser;
        
        Deal__c strDeal1 = new Deal__c( Name='DealTest123',
                                        Approver__c = testUser.id,
                                        Approval_Status__c = 'Approved');
                                        
        insert strDeal1;                                
        Mobilization_Plan__c plan123V1= new Mobilization_Plan__c(Deal__c = strDeal1.id,BCP_Type__c = UtilConstants.STD_OFFER,
                                                               Contract_Legal_In_Scope__c = true,  Active__c = true, Service_Management_In_Scope__c = true,
                                                               Journey_Management_In_Scope__c = true);
        insert plan123V1;   
		Wave__c wave123V1 = new Wave__c( Mobilization_Plan__c = plan123V1.id,
                                 Name = 'testWave1',  Planned_Go_Live_Date__c = System.Today());
        insert  wave123V1;                   
        SRAT_Tracker__c strSRATtrack = new SRAT_Tracker__c(Name = 'test SRAT Tracker',  Wave__c = wave123V1.Id);
        insert strSRATtrack;
        sratL1 = new SRAT_Additional_Tracking_Level_1__c(Name='srat Level Tracker 1',SRAT_Level_1_Tracking_Type__c='Manage Mobilization Program',Question__c='Insertion Of srat Level_1 Record',SRAT_Tracker__c=strSRATtrack.id);
        insert sratL1;
        sratL2 = new SRAT_Additional_Tracking_Level_2__c(Name='srat Level Tracker 2',Question__c='Insertion Of srat Level_1 Record',SRAT_Additional_Tracking_Level_1__c=sratL1.id);
    	insert sratL2;  
        /*sratL3 = new SRAT_Additional_Tracking_Level_2_FST__c(Name='srat Level Tracker FST',Deal_SRAT_Additional_Tracking_Level_1__c=sratL1.id);
 		insert sratL3;*/
            
    }
    
    static testMethod void test() {
        Test.startTest();
        setupData();
        List<SRAT_Additional_Tracking_Level_1__c> sratList = new List<SRAT_Additional_Tracking_Level_1__c>();
        set<id> sratL1id = new set<id>();
        set<id> sratL2id = new set<id>();
        //set<id> sratL3id = new set<id>();
        sratL1id.add(sratL1.id);
        sratL2id.add(sratL2.id);
        //sratL3id.add(sratL3.id);
        SRATRecTypeL1L2Update sratRecordType = new SRATRecTypeL1L2Update(sratL1id,'Level1');
        SRATRecTypeL1L2Update sratRecordType1 = new SRATRecTypeL1L2Update(sratL2id,'Level2');
        //SRATRecTypeL1L2Update sratRecordType2 = new SRATRecTypeL1L2Update(sratL3id,'Level1');
        sratRecordType.query ='Select Id,Name,SRAT_Tracker__c, SRAT_Level_1_Tracking_Type__c from SRAT_Additional_Tracking_Level_1__c';
        sratRecordType1.query ='Select Id,Name,SRAT_Level_1_Tracking_Type__c from SRAT_Additional_Tracking_Level_2__c';
        //sratRecordType2.query ='Select Id,Name,Deal_SRAT_Additional_Tracking_Level_1__c from SRAT_Additional_Tracking_Level_2_FST__c';
        database.executeBatch(sratRecordType);
        database.executeBatch(sratRecordType1);
        //database.executeBatch(sratRecordType2);
        Test.stopTest();    
    }
    
}