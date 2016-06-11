@IsTest
private class DealGeneralInfo_ControllerTest{

    static Opportunity_TGP__c oppObj;
    static Deal_TGP__c dealRec;
    static Client_Master__c clientName;
    static Client_Geo_Unit_Master__c getclientGeoUnit;
    static Client_Geo_Area_Master__c getCientGEOAreaMaster;
    static Operating_Group_Master__c operatinGroupMaster; 
    static User testUser1;
    private static string USER_NAME = 'vc12@testorg.com';
    
    public static void setupData(){
    	
    	Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
    	testUser1 = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_NAME);
    	insert testUser1;
    	
        clientName = UTIL_DataCreationForTestClass.getClientMaster('TestObject1');
        insert clientName; 
        getclientGeoUnit = UTIL_DataCreationForTestClass.getClientGeoUnitMaster('TestObject1');
        insert getclientGeoUnit;
        dealRec = UTIL_DataCreationForTestClass.getDealRecord('test',testUser1.id); 
        dealRec.Client_Name__c = clientName.id;
        insert dealRec;
        getCientGEOAreaMaster = UTIL_DataCreationForTestClass.getClientGEOAreaMaster('TestObject1');
        insert getCientGEOAreaMaster;
        operatinGroupMaster = UTIL_DataCreationForTestClass.getOperatingGroupMaster('TestObject1',true);
        insert operatinGroupMaster;
        ApexPages.StandardController sc = new ApexPages.StandardController(dealRec);
        apexpages.currentpage().getparameters().put('id' ,dealRec.id);         
        DealGeneralInfo_Controller obj = new DealGeneralInfo_Controller(sc);      
    }

    public static testMethod void testgetclientGeoUnit() {
        setupData();
        test.starttest(); 
            ApexPages.StandardController sc = new ApexPages.StandardController(dealRec);
            apexpages.currentpage().getparameters().put('id' ,dealRec.id);         
            DealGeneralInfo_Controller obj = new DealGeneralInfo_Controller(sc);  
            obj.getclientGeoUnit();
        test.stoptest();
        
    }
    public static testMethod void testgetclientGeoArea() {
        setupData(); 
        test.starttest(); 
            ApexPages.StandardController sc = new ApexPages.StandardController(dealRec);
            apexpages.currentpage().getparameters().put('id' ,dealRec.id);         
            DealGeneralInfo_Controller obj = new DealGeneralInfo_Controller(sc);  
            obj.getclientGeoArea();
        test.stoptest();
        
    }
   
    public static testMethod void testgetoperatingGroup() {
        setupData();
        test.starttest(); 
            ApexPages.StandardController sc = new ApexPages.StandardController(dealRec);
            apexpages.currentpage().getparameters().put('id' ,dealRec.id);         
            DealGeneralInfo_Controller obj = new DealGeneralInfo_Controller(sc);  
            obj.getoperatingGroup();
        test.stoptest();
        
    }
    public static testMethod void testDealGeneralInfo_Controller() {
        setupData();
        test.starttest(); 
            ApexPages.StandardController sc = new ApexPages.StandardController(dealRec);
            apexpages.currentpage().getparameters().put('id' ,dealRec.id);         
            DealGeneralInfo_Controller obj = new DealGeneralInfo_Controller(sc);  
            obj.edit1();
            obj.saverecord();
            obj.cancelRecord();
        test.stoptest();
        
    }
    
}