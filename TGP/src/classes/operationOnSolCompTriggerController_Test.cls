/*
* @Author :
* @Description : Test class for  trigger helper class
* @Version : 1.0                
*/
@isTest
private class operationOnSolCompTriggerController_Test {
    private static Opportunity opp;
    private static Opportunity oppWithSAP;
    private static Solution_Scope__c solCompBPO;
    private static Solution_Scope__c solCompIO;
    private static Solution_Scope__c solCompIC;
    private static List<Solution_Scope__c> solList;
    private static List<Solution_Scope__c> solListBlank;
    /******************************
    Method Name: setupData
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
    private static void setupData(){ 
        Offering_Master__c offProc=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
        insert offProc;
        
        Services_Master__c sm = new Services_Master__c();
        sm.Name = 'Test';
        sm.offering__c = offProc.id;
        sm.active__c = true;
        sm.Solution_Component__c = 'Delivery';
        sm.Is_Offering_Specific_Service__c = true;
        sm.Service_Group__c = 'BPO';
        insert sm;
        
        
        Offering_Master__c offAll = new Offering_Master__c();
        offAll.Name = 'All';
        offAll.offering_description__c = 'Test Offering';
        offAll.flywheel_non_flywheel__c = 'Flywheel';
        offAll.Service_Group__c = 'BPO';
        offAll.active__c = true;
        insert offAll;
        
        Services_Master__c sm1 = new Services_Master__c();
        sm1.Name = 'TestOppLevel';
        sm1.offering__c = offAll.id;
        sm1.active__c = true;
        sm1.Solution_Component__c = 'BST';
        sm1.Is_Offering_Specific_Service__c = false;
        sm1.Service_Group__c = 'BPO';
        insert sm1;
        
        Services_Master__c sm2 = new Services_Master__c();
        sm2.Name = 'TestOFFLevel';
        sm2.offering__c = offAll.id;
        sm2.active__c = true;
        sm2.Solution_Component__c = 'BST';
        sm2.Is_Offering_Specific_Service__c = true;
        sm2.Service_Group__c = 'BPO';
        insert sm2;
        
        Offering_Master__c offIO = new Offering_Master__c();
        offIO.Name = 'Test Offering Io';
        offIO.offering_description__c = 'Test Offering Io';
        offIO.flywheel_non_flywheel__c = 'Flywheel';
        offIO.Service_Group__c = 'IO';
        offIO.active__c = true;
        insert offIO;
        
        Offering_Master__c offIC = new Offering_Master__c();
        offIC.Name = 'Test Offering IC';
        offIC.offering_description__c = 'Test Offering IC';
        offIC.flywheel_non_flywheel__c = 'Flywheel';
        offIC.Service_Group__c = 'IC';
        offIC.active__c = true;
        insert offIC;
        
        Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
        insert customSetting;
        
        
        
        
        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        insert ogm;
        
        opp = new Opportunity();
        
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = ogm.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();
        opp.Name = UtilConstants.TEST_OPP;
   //     opp.Is_Synced__c = FALSE;
        insert opp;
        
        solCompBPO = new Solution_Scope__c(Active__c = True, Opportunity__c = opp.id, 
                                        Solution_Component__c = 'Delivery', Offering_Master__c = customSetting.Name__c, 
                                        Service_Group__c = 'BPO',  SAP_Offering_Revenue__c = 20);
        insert solCompBPO;  
        
        solCompBPO.Active__c = FALSE;
        update solCompBPO;
        
        solCompIO = new Solution_Scope__c(Active__c = True, Opportunity__c = opp.id, 
                                        Solution_Component__c = 'Delivery', Offering_Master__c = offIO.id, 
                                        Service_Group__c = 'IO',  SAP_Offering_Revenue__c = 20);
        insert solCompIO;  
        
        solCompIC = new Solution_Scope__c(Active__c = True, Opportunity__c = opp.id, 
                                        Solution_Component__c = 'Delivery', Offering_Master__c = offIC.id, 
                                        Service_Group__c = 'IC',  SAP_Offering_Revenue__c = 20);
        insert solCompIC; 
        
        solList = new List<Solution_Scope__c>();
        solList.add(solCompBPO);
    //    insert solList;
        solList.add(solCompIO);
        solList.add(solCompIC);
        
        
    }
    /******************************
    Method Name: testupdateOffOnOpp
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/ 
 /*   static testMethod void testupdateOffOnOpp(){
        setupData();
        test.startTest();
        if(!solList.isempty()) {
        operationOnSolCompTriggerController.updateOffOnOpp(solList,'InsertTrigger');
        }
        test.StopTest();                
    }    */
    /******************************
    Method Name: testcreateSupportingOffs
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/     
    static testMethod void testcreateSupportingOffs(){
        setupData();
        test.startTest();
        operationOnSolCompTriggerController.createSupportingOffs(solList);
        test.StopTest();                
    }    
     /******************************
    Method Name: testcreatechildRecs
    Description: 
    Paramenters: NA
    Return Value: NA
    *******************************/    
    static testMethod void testcreatechildRecs(){
        List<Solution_Scope__C> solListOne = new List<Solution_Scope__c>();
        
        Operating_Groups_Master__c ogm = new Operating_Groups_Master__c();
        ogm.Name = 'test name ogm';
        insert ogm;
        
        Opportunity opp1 = new Opportunity();
        opp1.Reporting_Status__c = UtilConstants.WON;
        opp1.Geo_Area__c = UtilConstants.EALA;
        opp1.OperatingGroup__c = ogm.id;
        opp1.StageName = UtilConstants.TWO_B;
        opp1.Risk_Level__c = UtilConstants.NORMAL;
        opp1.CloseDate = System.today();
        opp1.Name = UtilConstants.TEST_OPP;
        insert opp1;
        
        Offering_Master__c offProc=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
        offProc.Service_Group__c = 'BPO';
        insert offProc;
        
        Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
        insert customSetting;
        
        
        Services_Master__c sm = new Services_Master__c();
        sm.Name = 'Test';
        sm.offering__c = offProc.id;
        sm.active__c = true;
        sm.Solution_Component__c = 'Delivery';
        sm.Is_Offering_Specific_Service__c = true;
        sm.Service_Group__c = 'BPO';
        insert sm;
        
        Services_Master__c sm1 = new Services_Master__c();
        sm1.Name = 'ALL';
        sm1.offering__c = offProc.id;
        sm1.active__c = true;
        //sm1.Solution_Component__c = 'Technology';
        sm1.Is_Offering_Specific_Service__c = false;
        sm1.Service_Group__c = 'BPO';
        insert sm1;
        
        Services_Master__c sm2 = new Services_Master__c();
        sm2.Name = 'All';
        sm2.offering__c = offProc.id;
        sm2.active__c = true;
        sm2.Solution_Component__c = 'BST';
        sm2.Is_Offering_Specific_Service__c = true;
        sm2.Service_Group__c = 'BPO';
        insert sm2;
        
         List<Assumptions_Master__c> assmpMasList = new List<Assumptions_Master__c>();
        Assumptions_Master__c assmpMaster = new Assumptions_Master__c(Name = UtilConstants.TEST_ASSUMPTION,offering__c = offProc.id,Service__c=sm1.id,active__c=true,assumption__c = UtilConstants.TEST_ASSUMPTION,
                                            category__c = UtilConstants.PEOPLE,classification__c = UtilConstants.INTERNAL);
        assmpMasList.add(assmpMaster);
        insert assmpMasList;
        
        List<Client_Dependencies_Master__c> clientDepeMasList = new List<Client_Dependencies_Master__c>();
        Client_Dependencies_Master__c clientDepMaster = new Client_Dependencies_Master__c(Name = UtilConstants.CLIENT_DEP,offering__c = offProc.id,
                                           Services_per_Offering__c=sm1.id , active__c=true, client_depedency__c = UtilConstants.TEST_CLIENT,
                                            category__c = UtilConstants.PEOPLE,classification__c = UtilConstants.INTERNAL);
        clientDepeMasList.add(clientDepMaster);
        insert clientDepeMasList;
        
        Risks_Master__c riskMaster = new Risks_Master__c(Name = 'test Risk Master', service__c = sm1.Id,active__c=true,offering__c = offProc.Id, category__c = 'People', classification__c = 'Internal', risk_depedency__c = 'test Risk Dependancy');
        insert riskMaster;
        
       Solution_Scope__c solComp = new Solution_Scope__c(Opportunity__c = opp1.id,Solution_Component__c = 'Delivery', Offering_Master__c = offProc.id,Service_Group__c = 'BPO');
        insert solComp;
        solListOne.add(solComp);
        
        
        test.startTest();
        operationOnSolCompTriggerController.createChildRecsOfSolComp(solListOne);
        test.StopTest();                       
    }
    
   
}