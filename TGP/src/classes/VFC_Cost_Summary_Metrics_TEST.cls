/**
 * Test class for VFC_Cost_Summary_TEST 
 */
@isTest
private class VFC_Cost_Summary_Metrics_TEST {

    private static User testUser;
    private static Account clientName;
    private static Operating_Groups_Master__c operatingGroup;
    private static Opportunity oppTGP;
    
    /**
   *  @name : setupData_Construtor
   *  @Description : setupData_Construtor
   *  @param : NA
   *  @return parameter - void
   *  @throws exception- NA
   */
    public static void setupData_Construtor() {
    
        Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.SYSTEM_ADMIN);
        testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UtilConstants.USER_NAME);
        Database.insert(testUser, false);
    
        clientName = UTIL_DataCreationForTestClass.getAccountRec('TestObject1');
        insert clientName;
      
        operatingGroup = UTIL_DataCreationForTestClass.getOperatingGroupMasterRec(UtilConstants.TESTOPERATINGGRP,true);
        insert operatingGroup;
        
        //oppTGP =UTIL_DataCreationForTestClass.getOpportunityForBenchmark(operatingGroup);
        oppTGP=new Opportunity();
        oppTGP.OperatingGroup__c=operatingGroup.id;
        oppTGP.name=UtilConstants.TEST_OPP;
        oppTGP.Geo_Area__c=UTIL_Constants.AsiaPacific;
        oppTGP.Reporting_Status__c=UtilConstants.UNQUALIFIED;
        oppTGP.StageName=UtilConstants.OA;
        oppTGP.Risk_Level__c=UtilConstants.LOW;
        oppTGP.AccountId=clientName.Id;
        //Date dd=new Date();
        oppTGP.CloseDate= date.newInstance(2020, 3, 21);
        
        insert oppTGP;
    }
    
    /**
   *  @name : construtorUnitTest
   *  @Description : construtorUnitTest
   *  @param : NA
   *  @return parameter - void
   *  @throws exception- NA
   */
    static testMethod void construtorUnitTest() {
        
        setupData_Construtor();
        Test.startTest();
        PageReference pageRef= Page.Cost_Summary_Metrics;
        pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
        Test.setCurrentPageReference(pageRef);
        VFC_Cost_Summary_Metrics obj = new VFC_Cost_Summary_Metrics();
        
        obj.allLines_Opportunity = 'SWB-Benchmark-OpportunitySAP'+'\n\n'+'OM ID»Client Name»Opportunity Name»Scenario»Version»Contract Start Date»Initial GO-Live»Contract End Date»SSM Version»# of offerings in scope»Multi/Single Offering»TOTAL Baseline SDO FTEs»Onshore Baseline SDO FTEs»Nearshore Baseline SDO FTEs»Offshore Baseline SDO FTEs»Grand Total Cost»SDO Total Cost»BST Total Cost»Service Management Total Cost»Support Center Total Cost»Electronic Data Management Total Cost»Command Center Total Cost»Technology Total Cost»Technology Tools Total Cost»Voice and Data Total Cost»Mobilization Total Cost»PMO Total Cost»OADM Total Cost»CFM Total Cost»CM Total Cost»QAD Total Cost»SDO % of TCC»BST % of TCC»Service Management % of TCC»Support Center % of TCC»Electronic Documentation Management % of TCC»Command Center % of TCC»Technology % of TCC»Technology Tools % of TCC»Voice and Data % of TCC»Mobilization % of TCC»PMO % of TCC»OADM % of TCC»CFM % of TCC»CM % of TCC»QAD % of TCC»# of locations»Mobilization Contingency %»Average Run Contingency %»CI%»Transformation Costs (consulting)»Deal Unlocked?»Deal Data Tables Updated?»Pyramid Richness Year1»Delivery Locations»Languages'+'\n'+
                                   '»TestObject1»TestOpportunity»Master Scope»1»4/1/15»7/1/15»3/31/21»SSM2014_05_29 VDraft0.16.xlsm»2»Single»56.75»6.75»0»50» 27,730,207 » 16,094,390 »9700813»172709»9476851»51252»0»499576»265941»233635»81967»1353461»1353461»0»0»0»0.58»0.35»0.01»0.34»0.00»0.00»0.02»0.01»0.01»0.00»0.05»0.05»0.00»0.00»0.00»10»»»»»Yes»Yes»2.30»Delhi, USA, Bangalore, Charlotte, Chengdu, Cebu, Buenos Aires, India, Czech Republic»English, French';
        
        obj.allLines_Offering = 'SWB-Benchmark-Offering'+'\n\n'+'Costing Type»Sub Service Offering»Service»Sum of Total Cost»Sum of Average FTEs»Average of Location Definition»Count of Language»Average of FTE Type»Sum of Baseline FTEs»Average of Pyramid Richness - Year 1»Sum of Final Month FTE'+'\n'+
                                'SDO»Human Resources»Payroll»100»100»3»1»1»20»3»50'+'\n'+
                                'SDO»Finanace»Payroll»120»120»3»1»1»50»2»50';
        
        obj.allLines_summary =  'SWB-BPOSE-Summary'+'\n\n'+'Costing Type»Sub Service Offering»Service»Mob $»Year 1 $»Year 2 $»Year 3 $»Year 4 $»Year 5 $»Year 6 $»Year 7 $»Year 8 $»Year 9 $»Year 10 $»Grand Total Cost»Year 1 FTE»Year 2 FTE»Year 3 FTE»Year 4 FTE»Year 5 FTE»Year 6 FTE»Year 7 FTE»Year 8 FTE»Year 9 FTE»Year 10 FTE»Grand Total FTE»% of costs»"Average cost / FTE'+
                                'Full deal»Average cost / FTEYR 1+Mob»Average cost / FTE YR 2»Average cost / FTE YR 3»Average cost / FTE YR 4»Average cost / FTE YR 5»Average cost / FTE YR 6»Average cost / FTE YR 7»Average cost / FTE'+
                                'YR 8»Average cost / FTE YR 9»Average cost / FTE YR 10'+'\n'+
                                'SDO»Demo»Omed»24672»37243»35482»33893»32455»21637»1»1»1»1»1»185382»0.98»0.93»0.89»0.85»0.85»1.00»1.00»1.00»1.00»1.00»4.49»1.00»41242»63127»38081»38189»38297»25531»1»1»1»1»1'+'\n'+
                                'BST»Finance and Accounting»Service Management»24672»37243»35482»33893»32455»21637»1»1»1»1»1»185382»0.98»0.93»0.89»0.85»0.85»1.00»1.00»1.00»1.00»1.00»4.49»1.00»41242»63127»38081»38189»38297»25531»1»1»1»1»1';    
        obj.allLines_PriceParameter=    'SWB-Price Parameters \n\n'+
                                        '»Mob \n'+ 
                                        '(All years)»Run Year 1»Run Year 2»Run Year 3»Run Year 4»Run Year 5»Run Year 6»Run Year 7»Run Year 8»Run Year 9»Run Year 10'+'\n'+
                                        'Assumed Margin %»40%»40%»40%»40%»40%»40%»40%»40%»40%»40%»40%'+'\n'+
                                        'Assumed Capital Charges %»5%»5%»5%»5%»5%»5%»5%»5%»5%»5%»5%'+'\n'+
                                        'Assumed FX Contingency %»5%»5%»5%»5%»5%»5%»5%»5%»5%»5%»5%'+'\n'+
                                        'Assumed Cola %»5%»20%»30%»40%»50%»60%»70%»80%»80%»80%»80%'+'\n'+
                                        'Assumed Contingency %»10%»5%»3%»3%»3%»3%»3%»3%»3%»3%»3%';
        
        obj.allLines_OADM=               'SWB-OADM'+'\n\n'+
                                        'Costing Type»Service»Country»Career Level»Baseline FTEs'+'\n'+
                                        'SDO»Service»India»12»5';
        
        obj.allLines_PyramidRichness=    'SWB-Pyramid Richness'+'\n\n'+
                                       'Calculation for PR»Levels»FTE'+'\n'+
                                       '8»5-Senior Manager»0'+'\n'+
                                       '8»5-Senior Manager»0';
                                       
        obj.allLines_ServLocation=    'SWB-Benchmark-Service LocationSub Service Offering»Service»Country»DCN Location»Language Premium Flag»Sum of Total Cost»Sum of Mob cost»Sum of Total FTE/Year»Sum of Total SDO RUN Cost (FTE + Custom Cost)»Sum of Total SDO MOB Cost (FTE + Custom Cost)»Total SDO Cost (less Mob)»SDO Cost Per FTE»Tools Cost Per FTE»DVE Cost Per FTE»Support Center Cost Per FTE»SM Cost Per FTE»EDM Cost Per FTE»CC Cost Per FTE»Mob Cost Per FTE»PMO Cost Per FTE»Total Cost per FTE'+'\n'+
                                 'Finance and Accounting»Order to Cash»India»Delhi»N»854811.1183»35617.12993»86.25»0»0»0»0»0»0»0»0»0»0»0»0»0'+'\n'+
                                 'Finance and Accounting»Order to Cash»India»Delhi»N»854811.1183»35617.12993»86.25»0»0»0»0»0»0»0»0»0»0»0»0»0'+'\n'+
                                 'Finance and Accounting»Order to Cash»India»Bangalore»N»971957.1017»45997.96983»75.2375»0»0»0»0»0»0»0»0»0»0»0»0»0';
                                 
        obj.dropFileName='New File';
        obj.fileBody=blob.valueOf('Test');                                                                  
        obj.UploadFile();
        obj.beanchmarkSummary();
        
        
        obj.goToOpportunity();
        obj.goToBenchmark();
        
        
       } 
        
    


}