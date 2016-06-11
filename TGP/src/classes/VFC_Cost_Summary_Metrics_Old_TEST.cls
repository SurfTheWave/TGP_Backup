/**
 * Test class for VFC_Cost_Summary_Metrics_Old_TEST 
 */
@isTest
private class VFC_Cost_Summary_Metrics_Old_TEST {

    static User testUser;
    static Client_Master__c clientName;
   static Client_Geo_Area_Master__c clientGeoArea;
   static Operating_Group_Master__c operatingGroup;
   static Client_Geo_Unit_Master__c clientGeoUnit;
   static SAP_OM_Opportunity__c sAPOMOpp;
   static Opportunity_TGP__c oppTGP;
   
   static String User_Name1='vc71@testorg.com';
   //static string SWB-Benchmark-Offering;
/******************
 * @method name : setupData_Construtor
  
 * @description :
******************/
    public static void setupData_Construtor() {
    
    Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,USER_Name1);
    Database.insert (testUser);
    
     clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
        insert clientName;
      
      clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      insert clientGeoArea;
      
      operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      insert operatingGroup;
      
      clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      insert clientGeoUnit;

      sAPOMOpp = new SAP_OM_Opportunity__c(Name = '45',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,
                  Expected_contract_sign_Quarter__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Opportunity_Name__c = 'IBMTest');
      insert sAPOMOpp;
      
      oppTGP = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='ShridharTest',OG_Sales_Lead__c='ShridharTest',SAP_OM_ID_available_Y_N_del__c ='No',SAP_OM_Opportunity__c =sAPOMOpp.id);
      insert oppTGP;
    
    
    }
/******************
 * @method name : construtorUnitTest
  
 * @description :
******************/
static testMethod void construtorUnitTest() {
        setupData_Construtor();
        Test.startTest();
        PageReference pageRef= Page.Cost_Summary_Metrics_Old;
        pageRef.getParameters().put('id', String.valueOf(oppTGP.Id));
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController controller= new ApexPages.StandardController(oppTGP);
        VFC_Cost_Summary_Metrics_Old obj = new VFC_Cost_Summary_Metrics_Old(controller);
        obj.allLines_Opportunity = 'SWB-Benchmark-Opportunity'+'\n\n'+'SAP OM ID»Client Name»Opportunity Name»Scenario»Version»Contract Start Date»Initial GO-Live»Contract End Date»SSM Version»# of offerings in scope»Multi/Single Offering»TOTAL Baseline SDO FTEs»Onshore Baseline SDO FTEs»Nearshore Baseline SDO FTEs»Offshore Baseline SDO FTEs»Grand Total Cost»SDO Total Cost»BST Total Cost»Service Management Total Cost»Support Center Total Cost»Electronic Data Management Total Cost»Command Center Total Cost»Technology Total Cost»Technology Tools Total Cost»Voice and Data Total Cost»Mobilization Total Cost»PMO Total Cost»OADM Total Cost»CFM Total Cost»CM Total Cost»QAD Total Cost»SDO % of TCC»BST % of TCC»Service Management % of TCC»Support Center % of TCC»Electronic Documentation Management % of TCC»Command Center % of TCC»Technology % of TCC»Technology Tools % of TCC»Voice and Data % of TCC»Mobilization % of TCC»PMO % of TCC»OADM % of TCC»CFM % of TCC»CM % of TCC»QAD % of TCC»# of locations»Mobilization Contingency %»Average Run Contingency %»CI%»Transformation Costs (consulting)»Deal Unlocked?»Deal Data Tables Updated?»Pyramid Richness Year1»Delivery Locations»Languages'+'\n'+
                                    '45»TestObject1»TestIBM»Tier 3 - Revised on/offshore»2»11/1/14»2/1/15»1/31/20»SSM2014_05_29 VDraft0.16.xlsm»2»Multi»374.0178447»8»12»366.0178447»17464304.57»15289185.17»331»312»13»112»232»2175119.4»525706.65»1649412.75»4»3»1»3»1»4»0.87545342»3»1»2»1»1»0.12454658»0.03010178»0.0944448»12»32»2»1»1»3»4»1»23»10»50»TRUE»TRUE»2.559105249»A,b,c,c»10';
        
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
        obj.dropFileName='New File';
        obj.fileBody=blob.valueOf('Test');                                                                  
        obj.UploadFile();
        obj.beanchmarkSummary();
        
        Test.stopTest();
    
        
    }


}