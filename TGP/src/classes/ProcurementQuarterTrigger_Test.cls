/*
    @author     : 
    @name :         BudgetCostExport_Test 
    @createDate :   4/7/2015 3:03 AM
    @description :  Test class for budget cost export functionality testing
    @version : 
*/
@isTest(seeAllData = false)
private class ProcurementQuarterTrigger_Test{
    /*    
    @name :         test1
    @description :  Test sample data for procurement quarter trigger functionality testing
    */
    static testMethod void test1(){
        Test.starttest();
        //creating Deal test data..
        Deal__c strDeal = new Deal__c(Name='DealTest123');
        insert strDeal;
        
        //inserting New Plan under Deal.
        List<Mobilization_Plan__c> bcpMobPlans = new List<Mobilization_Plan__c>();        
        Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = strDeal.id, BCP_Type__c = 'Standard Offering BCP', IsTrackingOn__c = True);
        //Database.Insert(strmobplan,false);
        //insert strmobplan;
        bcpMobPlans.add(strmobplan);
        insert bcpMobPlans;
        
        //Creatinh BCP_Tracker__c test data for 
        List<BCP_Tracker__c> lstBCP = new List<BCP_Tracker__c>();
        BCP_Tracker__c strBCP = new BCP_Tracker__c(Name = 'test BCP', Mobilization_Plan__c = strmobplan.Id, 
                                       Task_Description__c = 'test Desc', Resource_Name__c = 'test Resource', 
                                       Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c=System.Today()+20);
        //insert strBCP;
        List<BCP_Master__c> lstBCPMaster = new List<BCP_Master__c>();
        BCP_Master__c strBCPMaster = new BCP_Master__c(Name = 'test BCP Masters', Section__c = 'Business Impact Analysis', Task__c = 'test Task', BCP_Type__c ='Standard Offering BCP', Task_Order__c = 2, Active__c = True);
        lstBCPMaster.add(strBCPMaster);
        insert lstBCPMaster;
        
        List<Contract_Legal_Master__c> legalMstrsList = new List<Contract_Legal_Master__c>();
        Contract_Legal_Master__c strConMaster = new Contract_Legal_Master__c(Name = 'test Contract and Legal', Section__c = 'CP Questions (CPP Process)', Task_Order__c = 3, Active__c = True);
        legalMstrsList.add(strConMaster);
        
        List<Contract_Legal_Tracker__c> legalContractList = new List<Contract_Legal_Tracker__c>();
        //inserting test data for Contract legal tracker..
        Contract_Legal_Tracker__c strContract = new Contract_Legal_Tracker__c(Name = 'test Contract and Legal', Mobilization_Plan__c= strmobplan.id, Resource_Name__c= 'test Resource', Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c=System.Today()+20, Section__c = 'CP Questions (CPP Process)', Task_Order__c = 3, Active__c = True);  
        //insert strContract;
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
        List<Procurement_Quarter_Wise_Activity_Item__c> PQWAItemList = new List<Procurement_Quarter_Wise_Activity_Item__c>();
        Procurement_Quarter_Wise_Activity_Item__c PQWAItem = new Procurement_Quarter_Wise_Activity_Item__c (Name = 'TestItem', Active__c = true ,Wave__c =strWave.Id, Type__c = 'Test',Quarter_dd__c = 'Q2', Value__c = 50);
        PQWAItemList.add(PQWAItem);
        Procurement_Quarter_Wise_Activity_Item__c PQWAItem2 = new Procurement_Quarter_Wise_Activity_Item__c (Name = 'TestItem2', Active__c = true ,Wave__c =strWave.Id, Type__c = 'Test',Quarter_dd__c = 'Q2', Value__c = 50);
        PQWAItemList.add(PQWAItem2);
        Insert PQWAItemList;
        PQWAItemList[0].name = UtilConstants.TOTAL_SAVE_TODATE;
        PQWAItemList[0].Value__c = 90;
        PQWAItemList[1].name = UtilConstants.TOTAL_SAVE_TARGET;
        PQWAItemList[1].Value__c = 80;
        Update PQWAItemList;
        Test.stoptest();
    }       
       /*    
        @Name :         test2
        @Description :  Test for createSpendSavingsPlan in ProcurementClass
        */
        static testMethod void test2(){
            Test.starttest();
            //creating Deal test data..
            Deal__c strDeal = new Deal__c(Name='DealTest123');
            insert strDeal;
            
            //inserting New Plan under Deal.
            List<Mobilization_Plan__c> bcpMobPlans = new List<Mobilization_Plan__c>();        
            Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = strDeal.id, BCP_Type__c = 'Standard Offering BCP', IsTrackingOn__c = True);
            //Database.Insert(strmobplan,false);
            //insert strmobplan;
            bcpMobPlans.add(strmobplan);
            insert bcpMobPlans;
            
            //Creatinh BCP_Tracker__c test data for 
            List<BCP_Tracker__c> lstBCP = new List<BCP_Tracker__c>();
            BCP_Tracker__c strBCP = new BCP_Tracker__c(Name = 'test BCP', Mobilization_Plan__c = strmobplan.Id, 
                                           Task_Description__c = 'test Desc', Resource_Name__c = 'test Resource', 
                                           Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c=System.Today()+20);
            //insert strBCP;
            List<BCP_Master__c> lstBCPMaster = new List<BCP_Master__c>();
            BCP_Master__c strBCPMaster = new BCP_Master__c(Name = 'test BCP Masters', Section__c = 'Business Impact Analysis', Task__c = 'test Task', BCP_Type__c ='Standard Offering BCP', Task_Order__c = 2, Active__c = True);
            lstBCPMaster.add(strBCPMaster);
            insert lstBCPMaster;
            
            List<Contract_Legal_Master__c> legalMstrsList = new List<Contract_Legal_Master__c>();
            Contract_Legal_Master__c strConMaster = new Contract_Legal_Master__c(Name = 'test Contract and Legal', Section__c = 'CP Questions (CPP Process)', Task_Order__c = 3, Active__c = True);
            legalMstrsList.add(strConMaster);
            
            List<Contract_Legal_Tracker__c> legalContractList = new List<Contract_Legal_Tracker__c>();
            //inserting test data for Contract legal tracker..
            Contract_Legal_Tracker__c strContract = new Contract_Legal_Tracker__c(Name = 'test Contract and Legal', Mobilization_Plan__c= strmobplan.id, Resource_Name__c= 'test Resource', Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c=System.Today()+20, Section__c = 'CP Questions (CPP Process)', Task_Order__c = 3, Active__c = True);  
            //insert strContract;
            legalContractList.add(strContract);
            
            List<Journey_Management_Master__c> jrnyMstrs = new List<Journey_Management_Master__c>(); 
            Journey_Management_Master__c strMstrJrny = new Journey_Management_Master__c(Name = 'test Journey Mgnt Master', Deliverable_Number__c = 20, Section__c = 'Stakeholder Management', Deliverable__c = 'test Deliverables', Section_Number__c = 12, Active__c = True);
            jrnyMstrs.add(strMstrJrny);
            insert jrnyMstrs;
            
            List<Journey_Management_Tracker__c> lstJrnyMgntTrkrs = new List<Journey_Management_Tracker__c>();
            Journey_Management_Tracker__c jTrkr = new Journey_Management_Tracker__c(Mobilization_Plan__c = strmobplan.Id, Name = 'test Journey Mgnt Tracker', Responsibility__c = 'Accenture', Planned_Start_Date__c = System.Today()+10, Planned_End_Date__c = System.Today()+20, IsPlanActive__c = True, IsTrackingOn__c = True);
            lstJrnyMgntTrkrs.add(jTrkr);
            insert lstJrnyMgntTrkrs;
            List<Wave__c> WaveList = new List<Wave__c>();
            Wave__c strWave1 = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id,Procurement_Q1_Start_Date__c = System.Today()+3, Planned_Go_Live_Date__c= System.Today()+30);
            WaveList.add(strWave1);
            //Wave__c strWave2 = new Wave__c(Name='Test Wave', Mobilization_Plan__c= strmobplan.id,Procurement_Q1_Start_Date__c = System.Today()+3 Planned_Go_Live_Date__c= System.Today()+30);
            //WaveList.add(strWave2);  
            Insert WaveList;
            ProcurementClass.createSpendSavingsPlan(WaveList);
            Test.stoptest();
       }
}