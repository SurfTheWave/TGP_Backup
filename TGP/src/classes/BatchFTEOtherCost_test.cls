@istest
private class BatchFTEOtherCost_test{
  private static Opportunity opp;
    private static Opportunity oppWithSAP;
    private static Solution_Scope__c solCompBPO;
    private static Solution_Scope__c solCompIO;
    private static Solution_Scope__c solCompIC;
    private static List<Solution_Scope__c> solList;
    private static List<Solution_Scope__c> solListBlank;
    static testMethod void datasetup(){
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
        insert opp;
        
        solCompBPO = new Solution_Scope__c(Active__c = True, Opportunity__c = opp.id, 
                                        Solution_Component__c = 'Delivery', Offering_Master__c = customSetting.Name__c, 
                                        Service_Group__c = 'BPO',  SAP_Offering_Revenue__c = 20);
        insert solCompBPO;  
        
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
        solList.add(solCompIO);
        solList.add(solCompIC);
    }
    static testMethod void positivetest(){
        datasetup();
         List<Service__c> lstService1 = new List<Service__c>();
         List<list<sobject>> testdatalist = new List<list<sobject>>();
         list<fte_Details__c> ftedetails = new list<fte_details__c>();
         list<other_cost_details__c> ocddetails = new list<other_cost_details__c>();
        lstService1 = [Select id,services__c,Solutionscope__c,Scope_Status__c from Service__c where Solutionscope__c IN :solList ];
        FTE_details__c fte = new FTE_details__c();
        fte.Service__c = lstService1[0].id;
        fte.Sub_Service_Group__c = lstService1[0].solutionscope__c;
        fte.opportunity__C = opp.id;
        Other_Cost_details__C ocd = new Other_Cost_details__C();
        ocd.Service__c = lstService1[0].id;
        ocd.Sub_Service_Group__c = lstService1[0].solutionscope__c;
        ocd.opportunity__C = opp.id;
        ocd.Cost_Type__c = 'Payroll';
        
        insert fte;
        ftedetails.add(fte);
        insert ocd;
        ocddetails.add(ocd);
        system.debug('fte opportunity ---->'+fte.opportunity__C);
        test.starttest();
        BatchFTEOtherCost bte = new BatchFTEOtherCost(opp.id,'BPO');
        testdatalist.add((list<sobject>) ftedetails);
        testdatalist.add((list<sobject>) ocddetails);
        /*bte.start(null);
        bte.execute(null,testdatalist);
        bte.finish(null);*/
        database.executebatch(bte,200);
        test.stoptest();
    }
}