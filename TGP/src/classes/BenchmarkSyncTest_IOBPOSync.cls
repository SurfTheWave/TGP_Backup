@isTest
public class BenchmarkSyncTest_IOBPOSync{
    public static Operating_Groups_Master__c testOpGrpMstr;
    public static String User_Name='vc71@testorg.com';
    public static Account TestAccount;
    public static Operating_Groups_Master__c TestOperatingGroup;
    public static Offering_Master__c OfferingMasterOpp;
    public static Offering_Master__c OfferingMasterOff;
    public static Services_Master__c ServicesMasterOpp;
    public static Services_Master__c ServicesMasterOff;
    public static Services_Component_Master__c ServiceComponentMaster;
    public static opportunity TestOpportunity;
    public static solution_scope__c TestSolutionScope;
    public static List<service__c> TestService;
    public static List<Service_Components__c> TestServiceComponent;
    public static FTE_Details__c TestFteDetails;
    public static Other_Cost_Details__c TestOtherCost; 
    public static Set<id> nFTEIds;
    public static Set<id> oFTEIds;
    public static Set<id> nOCDids;
    public static Set<id> oOCDids;
    public static Map<String,String>costdataMap;
    public static Costing_Request__c costingReq;
    public static List<FTE_Details__c> fteList = new List<FTE_Details__c>();
    public static List<Other_Cost_Details__c> otherCostList = new List<Other_Cost_Details__c>();
    
     public static void SetupData() {
         TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('test group master'); 
         TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Offering_Master__c off2 = new Offering_Master__c(service_group__c = 'IO',active__c = true,name='Sourcing and Procurement',offering_description__c='test desc',flywheel_non_flywheel__c='test NF');
         insert off2;
         Offering_Name__c offCustomsetting = new Offering_Name__c(name = 'Sourcing and Procurement',name__c=off2.id);
         insert offCustomsetting;
         
         OfferingMasterOff = new Offering_Master__c();
         OfferingMasterOff.name = 'Finance and Accounting';
         OfferingMasterOff.active__c = true;
         OfferingMasterOff.flywheel_non_flywheel__c = 'Flywheel';
         OfferingMasterOff.offering_description__c = 'This is just Crazy';
         OfferingMasterOff.Service_Group__c = 'IO';
         database.insert(OfferingMasterOff);
         
         ServicesMasterOff = new Services_Master__c();
         ServicesMasterOff.name = 'Order To Cash';
         ServicesMasterOff.active__c = true;
         ServicesMasterOff.Is_Offering_Specific_Service__c = true;
         ServicesMasterOff.offering__c = OfferingMasterOff.id;
         ServicesMasterOff.service_description__c = 'Even This is Crazy'; 
         ServicesMasterOff.Service_Group__c = 'IO';
         ServicesMasterOff.Solution_Component__c = 'Delivery';
         database.insert(ServicesMasterOff);
         
         ServicesMasterOff = new Services_Master__c();
         ServicesMasterOff.name = 'OADM';
         ServicesMasterOff.active__c = true;
         ServicesMasterOff.Is_Offering_Specific_Service__c = true;
         ServicesMasterOff.offering__c = OfferingMasterOff.id;
         ServicesMasterOff.service_description__c = 'Even This is Crazy'; 
         ServicesMasterOff.Service_Group__c = 'IO';
         ServicesMasterOff.Solution_Component__c = 'Delivery';
         database.insert(ServicesMasterOff);

         ServiceComponentMaster = new Services_Component_Master__c();
         ServiceComponentMaster.name = 'Team Workspace Mgmt';
         ServiceComponentMaster.active__c =  true;
         ServiceComponentMaster.service__c = ServicesMasterOff.id;
         ServiceComponentMaster.service_component_description__c = 'Nothing Else Matters';
         database.insert(ServiceComponentMaster);
         
         ServiceComponentMaster = new Services_Component_Master__c();
         ServiceComponentMaster.name = 'Team Workspace';
         ServiceComponentMaster.active__c =  true;
         ServiceComponentMaster.service__c = ServicesMasterOff.id;
         ServiceComponentMaster.service_component_description__c = 'Nothing Else Matters';
         database.insert(ServiceComponentMaster);
         
         EconomicProfile_Master__c newEPMaster= new EconomicProfile_Master__c(Active__c=true,name='Infrastructure Consulting');
         database.insert(newEPMaster);
        
         Role_Master__c newRole = new Role_Master__c(Active__c=true,name='Task');
         database.insert(newRole);
        
         Load_Type_Master__c newLoad = new Load_Type_Master__c(Active__c=true,name='NA');
         database.insert(newLoad);
        
         Rate__c newRate = new Rate__c(Active__c=true,name='Standard');
         database.insert(newRate);
        
         Bill_Code_Master__c Billi = new Bill_Code_Master__c(Active__c=true,name='31');
         database.insert(Billi);
         
         /*
         Career_Level__c noCareer = new Career_Level__c(Active__c=true,name='11-Analyst');
         database.insert(noCareer);
         Career_Level__c noCareer1 = new Career_Level__c(Active__c=true,name='9-Consultant');
         database.insert(noCareer1);
         Career_Level__c noCareer2 = new Career_Level__c(Active__c=true,name='8-Consultant');
         database.insert(noCareer2);
         Career_Level__c noCareer3 = new Career_Level__c(Active__c=true,name='7-Manager');
         database.insert(noCareer3);
         */
        
         Career_Track_Master__c noCareerTrack = new Career_Track_Master__c(Active__c=true,name='Client & Market');
         database.insert(noCareerTrack);
        
         Country_Master__c noCountry = new Country_Master__c(Active__c=true,name='Austria');
         database.insert(noCountry);
        
         Resource_Group_Master__c newResourceGroup = new Resource_Group_Master__c(Active__c=true,name='ACN Onshore');
         database.insert(newResourceGroup);
         
         TestOpportunity = new Opportunity();
         TestOpportunity.Reporting_Status__c = UtilConstants.WON;
         TestOpportunity.Geo_Area__c = UtilConstants.EALA;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id;
         TestOpportunity.StageName = UtilConstants.TWO_B;
         TestOpportunity.Risk_Level__c = UtilConstants.NORMAL;
         TestOpportunity.CloseDate = System.today();
         TestOpportunity.Name = UtilConstants.TEST_OPP;
         insert TestOpportunity;
         
         costingReq = new Costing_Request__c();
         costingReq = [SELECT id, Name FROM Costing_Request__C WHERE Opportunity__c = :testOpportunity.id];
         System.debug('costingReq ' + costingReq);
         
         Benchmark__c bnch = new Benchmark__C (Opportunity__c =testOpportunity.id, Name= testOpportunity.Name+ UtilConstants.VFP_BENCHMARK_DATA );
         insert bnch;
         /*
         costingReq = new Costing_Request__c();
         costingReq.Opportunity__c = TestOpportunity.id;
         upsert costingReq ;
         */
         TestSolutionScope = new Solution_Scope__c(Opportunity__c = TestOpportunity.id,Solution_Component__c = UtilConstants.DELIVERY, Offering_Master__c = OfferingMasterOff.id, Service_Group__c = 'IO');
         insert TestSolutionScope;
         
        TestService = [select id from service__c where Solutionscope__c =:TestSolutionScope.id];
         
        TestServiceComponent = [select id from Service_Components__c where service__c IN:TestService];
        nFTEIds = new Set<id>();
        oFTEIds = new Set<id>();
        nOCDids = new Set<id>();
        oOCDids = new Set<id>(); 
         
        TestFteDetails = new Fte_Details__c();
        TestFteDetails.Service_Group__c  =UtilConstants.IO;
        TestFteDetails.Name ='Test FTE';
        TestFteDetails.Service__c =TestService[0].id;
        TestFteDetails.Activity_Description__c ='jane kya hoga rama re';
        TestFteDetails.Bill_Code__c = Billi.id;
        //TestFteDetails.Career_Level__c = noCareer.id;
        TestFteDetails.Career_Track__c = noCareerTrack.id;
        TestFteDetails.Country__c = noCountry.id;
        TestFteDetails.Economic_Profile__c = newEPMaster.id;
        TestFteDetails.Load_Type__c = newLoad.id;
        TestFteDetails.Rate_Type__c = newRate.id;
        TestFteDetails.Resource_Group__c = newResourceGroup.id;
        TestFteDetails.Role_Master__c = newRole.id;
        TestFteDetails.Service_Component__c = TestServiceComponent[0].id;
        //Service_Group__c = ;
        TestFteDetails.Sub_Service_Group__c = TestSolutionScope.id;
        TestFteDetails.Costing_Type__c='SDO' ;
        TestFteDetails.Baseline_FTEs__c=10 ; 
        TestFteDetails.DCN_FTE_Type__c='Employee' ; 
        //TestFteDetails.Delivery_Location__c=  noCountry.id; 
        TestFteDetails.FTEMobTotals__c=10 ; 
        TestFteDetails.FTEYr10__c=10 ; 
        TestFteDetails.FTEYr1__c=10 ; 
        TestFteDetails.FTEYr2__c=10 ; 
        TestFteDetails.FTEYr3__c=10 ; 
        TestFteDetails.FTEYr4__c=10 ; 
        TestFteDetails.FTEYr5__c=10 ; 
        TestFteDetails.FTEYr6__c=10 ; 
        TestFteDetails.FTEYr7__c=10 ; 
        TestFteDetails.FTEYr8__c=10 ; 
        TestFteDetails.FTEYr9__c=10 ; 
        //TestFteDetails.FTE_Grand_Total_Cost__c=10 ; 
        TestFteDetails.FTE_Type__c='Employee' ; 
        TestFteDetails.Language__c='Bhojpuri' ; 
        TestFteDetails.Location_typeCode__c='1' ; 
        TestFteDetails.Location_typeName__c='ACN OnShore' ; 
        TestFteDetails.Mob_Cost__c=10 ; 
        TestFteDetails.Mob_Totals__c=10 ; 
        TestFteDetails.Run_Yr10__c=10 ; 
        TestFteDetails.Run_Yr1__c=10 ; 
        TestFteDetails.Run_Yr2__c=10 ; 
        TestFteDetails.Run_Yr3__c=10 ; 
        TestFteDetails.Run_Yr4__c=10 ; 
        TestFteDetails.Run_Yr5__c=10 ; 
        TestFteDetails.Run_Yr6__c=10 ; 
        TestFteDetails.Run_Yr7__c=10 ; 
        TestFteDetails.Run_Yr8__c=10 ; 
        TestFteDetails.Run_Yr9__c=10 ; 
        //TestFteDetails.Total_SDO_FTE__c=10 ;  
        
        TestFteDetails.Opportunity__c= TestOpportunity.id; 
        TestFteDetails.Phase__c='' ; 
        TestFteDetails.Final_Month_FTE__c =10;
        TestFteDetails.Costing_Request__c = costingReq.id;
        ftelist.add(TestFteDetails);
        //insert TestFteDetails;
        
        //nFTEIds.add(TestFteDetails.id);
        //oFTEIds.add(TestFteDetails.id);
        
        TestFteDetails = new Fte_Details__c();
        TestFteDetails.Service_Group__c  =UtilConstants.IO;
        TestFteDetails.Name ='Test FTE';
        TestFteDetails.Service__c =TestService[0].id;
        TestFteDetails.Activity_Description__c ='jane kya hoga rama re';
        TestFteDetails.Bill_Code__c = Billi.id;
        //TestFteDetails.Career_Level__c = noCareer.id;
        TestFteDetails.Career_Track__c = noCareerTrack.id;
        TestFteDetails.Country__c = noCountry.id;
        TestFteDetails.Economic_Profile__c = newEPMaster.id;
        TestFteDetails.Load_Type__c = newLoad.id;
        TestFteDetails.Rate_Type__c = newRate.id;
        TestFteDetails.Resource_Group__c = newResourceGroup.id;
        TestFteDetails.Role_Master__c = newRole.id;
        TestFteDetails.Service_Component__c = TestServiceComponent[0].id;
        //Service_Group__c = ;
        TestFteDetails.Sub_Service_Group__c = TestSolutionScope.id;
        TestFteDetails.Costing_Type__c='SDO' ;
        TestFteDetails.Baseline_FTEs__c=10 ; 
        TestFteDetails.DCN_FTE_Type__c='Employee' ; 
        //TestFteDetails.Delivery_Location__c=  noCountry.id; 
        TestFteDetails.FTEMobTotals__c=10 ; 
        TestFteDetails.FTEYr10__c=10 ; 
        TestFteDetails.FTEYr1__c=10 ; 
        TestFteDetails.FTEYr2__c=10 ; 
        TestFteDetails.FTEYr3__c=10 ; 
        TestFteDetails.FTEYr4__c=10 ; 
        TestFteDetails.FTEYr5__c=10 ; 
        TestFteDetails.FTEYr6__c=10 ; 
        TestFteDetails.FTEYr7__c=10 ; 
        TestFteDetails.FTEYr8__c=10 ; 
        TestFteDetails.FTEYr9__c=10 ; 
        //TestFteDetails.FTE_Grand_Total_Cost__c=10 ; 
        TestFteDetails.FTE_Type__c='Employee' ; 
        TestFteDetails.Language__c='Bhojpuri' ; 
        TestFteDetails.Location_typeCode__c='1' ; 
        TestFteDetails.Location_typeName__c='ACN OnShore' ; 
        TestFteDetails.Mob_Cost__c=10 ; 
        TestFteDetails.Mob_Totals__c=10 ; 
        TestFteDetails.Run_Yr10__c=10 ; 
        TestFteDetails.Run_Yr1__c=10 ; 
        TestFteDetails.Run_Yr2__c=10 ; 
        TestFteDetails.Run_Yr3__c=10 ; 
        TestFteDetails.Run_Yr4__c=10 ; 
        TestFteDetails.Run_Yr5__c=10 ; 
        TestFteDetails.Run_Yr6__c=10 ; 
        TestFteDetails.Run_Yr7__c=10 ; 
        TestFteDetails.Run_Yr8__c=10 ; 
        TestFteDetails.Run_Yr9__c=10 ; 
        //TestFteDetails.Total_SDO_FTE__c=10 ;  
        TestFteDetails.Opportunity__c= TestOpportunity.id; 
        TestFteDetails.Phase__c='' ; 
        TestFteDetails.Final_Month_FTE__c =10;
        TestFteDetails.Costing_Request__c = costingReq.id;
        fteList.add(TestFteDetails);
        //insert TestFteDetails;
        
        //nFTEIds.add(TestFteDetails.id);
        //oFTEIds.add(TestFteDetails.id);
        
        TestFteDetails = new Fte_Details__c();
        TestFteDetails.Service_Group__c  =UtilConstants.IO;
        TestFteDetails.Name ='Test FTE';
        TestFteDetails.Service__c =TestService[1].id;
        TestFteDetails.Activity_Description__c ='jane kya hoga rama re';
        TestFteDetails.Bill_Code__c = Billi.id;
        //TestFteDetails.Career_Level__c = noCareer1.id;
        TestFteDetails.Career_Track__c = noCareerTrack.id;
        TestFteDetails.Country__c = noCountry.id;
        TestFteDetails.Economic_Profile__c = newEPMaster.id;
        TestFteDetails.Load_Type__c = newLoad.id;
        TestFteDetails.Rate_Type__c = newRate.id;
        TestFteDetails.Resource_Group__c = newResourceGroup.id;
        TestFteDetails.Role_Master__c = newRole.id;
        TestFteDetails.Service_Component__c = TestServiceComponent[1].id;
        //Service_Group__c = ;
        TestFteDetails.Sub_Service_Group__c = TestSolutionScope.id;
        TestFteDetails.Costing_Type__c='SDO' ;
        TestFteDetails.Baseline_FTEs__c=10 ; 
        TestFteDetails.DCN_FTE_Type__c='Employee' ; 
        //TestFteDetails.Delivery_Location__c=  noCountry.id; 
        TestFteDetails.FTEMobTotals__c=10 ; 
        TestFteDetails.FTEYr10__c=10 ; 
        TestFteDetails.FTEYr1__c=10 ; 
        TestFteDetails.FTEYr2__c=10 ; 
        TestFteDetails.FTEYr3__c=10 ; 
        TestFteDetails.FTEYr4__c=10 ; 
        TestFteDetails.FTEYr5__c=10 ; 
        TestFteDetails.FTEYr6__c=10 ; 
        TestFteDetails.FTEYr7__c=10 ; 
        TestFteDetails.FTEYr8__c=10 ; 
        TestFteDetails.FTEYr9__c=10 ; 
        //TestFteDetails.FTE_Grand_Total_Cost__c=10 ; 
        TestFteDetails.FTE_Type__c='Employee' ; 
        TestFteDetails.Language__c='Bhojpuri' ; 
        TestFteDetails.Location_typeCode__c='2' ; 
        TestFteDetails.Location_typeName__c='ACN NearShore' ; 
        TestFteDetails.Mob_Cost__c=10 ; 
        TestFteDetails.Mob_Totals__c=10 ; 
        TestFteDetails.Run_Yr10__c=10 ; 
        TestFteDetails.Run_Yr1__c=10 ; 
        TestFteDetails.Run_Yr2__c=10 ; 
        TestFteDetails.Run_Yr3__c=10 ; 
        TestFteDetails.Run_Yr4__c=10 ; 
        TestFteDetails.Run_Yr5__c=10 ; 
        TestFteDetails.Run_Yr6__c=10 ; 
        TestFteDetails.Run_Yr7__c=10 ; 
        TestFteDetails.Run_Yr8__c=10 ; 
        TestFteDetails.Run_Yr9__c=10 ; 
        //TestFteDetails.Total_SDO_FTE__c=10 ;  
        TestFteDetails.Opportunity__c= TestOpportunity.id; 
        TestFteDetails.Phase__c='' ; 
        TestFteDetails.Final_Month_FTE__c =10;
        TestFteDetails.Costing_Request__c = costingReq.id;
        fteList.add(TestFteDetails);
        //insert TestFteDetails;
        //nFTEIds.add(TestFteDetails.id);
        //oFTEIds.add(TestFteDetails.id);
        // 2nd fte record for BSS
        TestFteDetails = new Fte_Details__c();
        TestFteDetails.Service_Group__c  =UtilConstants.IO;
        TestFteDetails.Name ='Test FTE';
        TestFteDetails.Service__c =TestService[0].id;
        TestFteDetails.Activity_Description__c ='jane kya hoga rama re';
        TestFteDetails.Bill_Code__c = Billi.id;
        //TestFteDetails.Career_Level__c = noCareer2.id;
        TestFteDetails.Career_Track__c = noCareerTrack.id;
        TestFteDetails.Country__c = noCountry.id;
        TestFteDetails.Economic_Profile__c = newEPMaster.id;
        TestFteDetails.Load_Type__c = newLoad.id;
        TestFteDetails.Rate_Type__c = newRate.id;
        TestFteDetails.Resource_Group__c = newResourceGroup.id;
        TestFteDetails.Role_Master__c = newRole.id;
        TestFteDetails.Service_Component__c = TestServiceComponent[0].id;
        //Service_Group__c = ;
        TestFteDetails.Sub_Service_Group__c = TestSolutionScope.id;
        TestFteDetails.Costing_Type__c='BSS' ;
        TestFteDetails.Baseline_FTEs__c=10 ; 
        TestFteDetails.DCN_FTE_Type__c='Contractor' ; 
        //TestFteDetails.Delivery_Location__c=  noCountry.id; 
        TestFteDetails.FTEMobTotals__c=10 ; 
        TestFteDetails.FTEYr10__c=10 ; 
        TestFteDetails.FTEYr1__c=10 ; 
        TestFteDetails.FTEYr2__c=10 ; 
        TestFteDetails.FTEYr3__c=10 ; 
        TestFteDetails.FTEYr4__c=10 ; 
        TestFteDetails.FTEYr5__c=10 ; 
        TestFteDetails.FTEYr6__c=10 ; 
        TestFteDetails.FTEYr7__c=10 ; 
        TestFteDetails.FTEYr8__c=10 ; 
        TestFteDetails.FTEYr9__c=10 ; 
        //TestFteDetails.FTE_Grand_Total_Cost__c=10 ; 
        TestFteDetails.FTE_Type__c='Contractor' ; 
        TestFteDetails.Language__c='Bhojpuri' ; 
        TestFteDetails.Location_typeCode__c='3' ; 
        TestFteDetails.Location_typeName__c='ACN OffShore' ; 
        TestFteDetails.Mob_Cost__c=10 ; 
        TestFteDetails.Mob_Totals__c=10 ; 
        TestFteDetails.Run_Yr10__c=10 ; 
        TestFteDetails.Run_Yr1__c=10 ; 
        TestFteDetails.Run_Yr2__c=10 ; 
        TestFteDetails.Run_Yr3__c=10 ; 
        TestFteDetails.Run_Yr4__c=10 ; 
        TestFteDetails.Run_Yr5__c=10 ; 
        TestFteDetails.Run_Yr6__c=10 ; 
        TestFteDetails.Run_Yr7__c=10 ; 
        TestFteDetails.Run_Yr8__c=10 ; 
        TestFteDetails.Run_Yr9__c=10 ; 
        //TestFteDetails.Total_SDO_FTE__c=10 ;  
        TestFteDetails.Opportunity__c= TestOpportunity.id; 
        TestFteDetails.Phase__c='' ; 
        TestFteDetails.Final_Month_FTE__c =10;
        TestFteDetails.Costing_Request__c = costingReq.id;
        fteList.add(TestFteDetails);
        //insert TestFteDetails;
        
        //nFTEIds.add(TestFteDetails.id);
        //oFTEIds.add(TestFteDetails.id);
        //For tech tools
        TestFteDetails = new Fte_Details__c();
        TestFteDetails.Service_Group__c  =UtilConstants.IO;
        TestFteDetails.Name ='Test FTE';
        TestFteDetails.Service__c =TestService[0].id;
        TestFteDetails.Activity_Description__c ='jane kya hoga rama re';
        TestFteDetails.Bill_Code__c = Billi.id;
        //TestFteDetails.Career_Level__c = noCareer.id;
        TestFteDetails.Career_Track__c = noCareerTrack.id;
        TestFteDetails.Country__c = noCountry.id;
        TestFteDetails.Economic_Profile__c = newEPMaster.id;
        TestFteDetails.Load_Type__c = newLoad.id;
        TestFteDetails.Rate_Type__c = newRate.id;
        TestFteDetails.Resource_Group__c = newResourceGroup.id;
        TestFteDetails.Role_Master__c = newRole.id;
        TestFteDetails.Service_Component__c = TestServiceComponent[0].id;
        //Service_Group__c = ;
        TestFteDetails.Sub_Service_Group__c = TestSolutionScope.id;
        TestFteDetails.Costing_Type__c='Technology' ;
        TestFteDetails.Baseline_FTEs__c=10 ; 
        TestFteDetails.DCN_FTE_Type__c='Employee' ; 
        //TestFteDetails.Delivery_Location__c=  noCountry.id; 
        TestFteDetails.FTEMobTotals__c=10 ; 
        TestFteDetails.FTEYr10__c=10 ; 
        TestFteDetails.FTEYr1__c=10 ; 
        TestFteDetails.FTEYr2__c=10 ; 
        TestFteDetails.FTEYr3__c=10 ; 
        TestFteDetails.FTEYr4__c=10 ; 
        TestFteDetails.FTEYr5__c=10 ; 
        TestFteDetails.FTEYr6__c=10 ; 
        TestFteDetails.FTEYr7__c=10 ; 
        TestFteDetails.FTEYr8__c=10 ; 
        TestFteDetails.FTEYr9__c=10 ; 
        //TestFteDetails.FTE_Grand_Total_Cost__c=10 ; 
        TestFteDetails.FTE_Type__c='Headcounts Transferred form client' ; 
        TestFteDetails.Language__c='Bhojpuri' ; 
        TestFteDetails.Location_typeCode__c='3' ; 
        TestFteDetails.Location_typeName__c='ACN OffShore' ; 
        TestFteDetails.Mob_Cost__c=10 ; 
        TestFteDetails.Mob_Totals__c=10 ; 
        TestFteDetails.Run_Yr10__c=10 ; 
        TestFteDetails.Run_Yr1__c=10 ; 
        TestFteDetails.Run_Yr2__c=10 ; 
        TestFteDetails.Run_Yr3__c=10 ; 
        TestFteDetails.Run_Yr4__c=10 ; 
        TestFteDetails.Run_Yr5__c=10 ; 
        TestFteDetails.Run_Yr6__c=10 ; 
        TestFteDetails.Run_Yr7__c=10 ; 
        TestFteDetails.Run_Yr8__c=10 ; 
        TestFteDetails.Run_Yr9__c=10 ; 
        //TestFteDetails.Total_SDO_FTE__c=10 ;  
        TestFteDetails.Opportunity__c= TestOpportunity.id; 
        TestFteDetails.Phase__c='' ; 
        TestFteDetails.Final_Month_FTE__c =10;
        TestFteDetails.Costing_Request__c = costingReq.id;
        ftelist.add(TestFteDetails);
        //insert TestFteDetails;

        //nFTEIds.add(TestFteDetails.id);
        //oFTEIds.add(TestFteDetails.id);
        
        insert fteList;
        for(FTe_Details__C fte : fteList){
            nFTEIds.add(fte.id);
            oFTEIds.add(fte.id);
        }
        System.debug('nFTEs '+ nFTEIds);

        TestOtherCost = new Other_Cost_Details__c ();
        TestOtherCost.Service_Group__c  =UtilConstants.IO;
        TestOtherCost.Name ='Test Other Cost';
        TestOtherCost.Service__c =TestService[0].id;
        
        //TestOtherCost.Career_Level__c = noCareer.id;
        
        TestOtherCost.Country__c = noCountry.id;
        
        TestOtherCost.Service_Component__c = TestServiceComponent[0].id;
        
        TestOtherCost.Sub_Service_Group__c = TestSolutionScope.id;
        TestOtherCost.Costing_Type__c='SDO' ;
        
        TestOtherCost.Location_typeCode__c='1' ; 
        TestOtherCost.Location_typeName__c='ACN OnShore' ; 
        TestOtherCost.Mob_Cost__c=10 ; 
        TestOtherCost.Mob_Totals__c=10 ; 
        TestOtherCost.Run_Yr10__c=10 ; 
        TestOtherCost.Run_Yr1__c=10 ; 
        TestOtherCost.Run_Yr2__c=10 ; 
        TestOtherCost.Run_Yr3__c=10 ; 
        TestOtherCost.Run_Yr4__c=10 ; 
        TestOtherCost.Run_Yr5__c=10 ; 
        TestOtherCost.Run_Yr6__c=10 ; 
        TestOtherCost.Run_Yr7__c=10 ; 
        TestOtherCost.Run_Yr8__c=10 ; 
        TestOtherCost.Run_Yr9__c=10 ;
        TestOtherCost.Opportunity__c= TestOpportunity.id; 
        insert TestOtherCost;
        //TestOtherCost.Phase__c='' ; 
        //TestOtherCost.Final_Month_FTE__c =10;
        
        nOCDids.add(TestOtherCost.id);
        nOCDids.add(TestOtherCost.id);
        
        TestOtherCost = new Other_Cost_Details__c ();
        TestOtherCost.Service_Group__c  =UtilConstants.IO;
        TestOtherCost.Name ='Test Other Cost';
        TestOtherCost.Service__c =TestService[0].id;
        
        //TestOtherCost.Career_Level__c = noCareer2.id;
        
        TestOtherCost.Country__c = noCountry.id;
        
        TestOtherCost.Service_Component__c = TestServiceComponent[0].id;
        
        TestOtherCost.Sub_Service_Group__c = TestSolutionScope.id;
        TestOtherCost.Costing_Type__c='SDO' ;
        
        TestOtherCost.Location_typeCode__c='1' ; 
        TestOtherCost.Location_typeName__c='ACN OnShore' ; 
        TestOtherCost.Mob_Cost__c=10 ; 
        TestOtherCost.Mob_Totals__c=10 ; 
        TestOtherCost.Run_Yr10__c=10 ; 
        TestOtherCost.Run_Yr1__c=10 ; 
        TestOtherCost.Run_Yr2__c=10 ; 
        TestOtherCost.Run_Yr3__c=10 ; 
        TestOtherCost.Run_Yr4__c=10 ; 
        TestOtherCost.Run_Yr5__c=10 ; 
        TestOtherCost.Run_Yr6__c=10 ; 
        TestOtherCost.Run_Yr7__c=10 ; 
        TestOtherCost.Run_Yr8__c=10 ; 
        TestOtherCost.Run_Yr9__c=10 ; 
        
        TestOtherCost.Opportunity__c= TestOpportunity.id; 
        //TestOtherCost.Phase__c='' ; 
        //TestOtherCost.Final_Month_FTE__c =10;
        insert TestOtherCost;

        nOCDids.add(TestOtherCost.id);
        nOCDids.add(TestOtherCost.id);
        TestOtherCost = new Other_Cost_Details__c ();
        TestOtherCost.Service_Group__c  =UtilConstants.IO;
        TestOtherCost.Name ='Test Other Cost';
        TestOtherCost.Service__c =TestService[1].id;
        
        //TestOtherCost.Career_Level__c = noCareer.id;
        
        TestOtherCost.Country__c = noCountry.id;
        
        TestOtherCost.Service_Component__c = TestServiceComponent[1].id;
        
        TestOtherCost.Sub_Service_Group__c = TestSolutionScope.id;
        TestOtherCost.Costing_Type__c='SDO' ;
        
        TestOtherCost.Location_typeCode__c='1' ; 
        TestOtherCost.Location_typeName__c='ACN OnShore' ; 
        TestOtherCost.Mob_Cost__c=10 ; 
        TestOtherCost.Mob_Totals__c=10 ; 
        TestOtherCost.Run_Yr10__c=10 ; 
        TestOtherCost.Run_Yr1__c=10 ; 
        TestOtherCost.Run_Yr2__c=10 ; 
        TestOtherCost.Run_Yr3__c=10 ; 
        TestOtherCost.Run_Yr4__c=10 ; 
        TestOtherCost.Run_Yr5__c=10 ; 
        TestOtherCost.Run_Yr6__c=10 ; 
        TestOtherCost.Run_Yr7__c=10 ; 
        TestOtherCost.Run_Yr8__c=10 ; 
        TestOtherCost.Run_Yr9__c=10 ; 
        
        TestOtherCost.Opportunity__c= TestOpportunity.id; 
        insert TestOtherCost;
        //TestOtherCost.Phase__c='' ; 
        //TestOtherCost.Final_Month_FTE__c =10;

        nOCDids.add(TestOtherCost.id);
        nOCDids.add(TestOtherCost.id);
        
        TestOtherCost = new Other_Cost_Details__c ();
        TestOtherCost.Service_Group__c  =UtilConstants.IO;
        TestOtherCost.Name ='Test Other Cost';
        TestOtherCost.Service__c =TestService[1].id;
        
        //TestOtherCost.Career_Level__c = noCareer2.id;
        
        TestOtherCost.Country__c = noCountry.id;
        
        TestOtherCost.Service_Component__c = TestServiceComponent[0].id;
        
        TestOtherCost.Sub_Service_Group__c = TestSolutionScope.id;
        TestOtherCost.Costing_Type__c='BSS' ;
        
        TestOtherCost.Location_typeCode__c='1' ; 
        TestOtherCost.Location_typeName__c='ACN OnShore' ; 
        TestOtherCost.Mob_Cost__c=10 ; 
        TestOtherCost.Mob_Totals__c=10 ; 
        TestOtherCost.Run_Yr10__c=10 ; 
        TestOtherCost.Run_Yr1__c=10 ; 
        TestOtherCost.Run_Yr2__c=10 ; 
        TestOtherCost.Run_Yr3__c=10 ; 
        TestOtherCost.Run_Yr4__c=10 ; 
        TestOtherCost.Run_Yr5__c=10 ; 
        TestOtherCost.Run_Yr6__c=10 ; 
        TestOtherCost.Run_Yr7__c=10 ; 
        TestOtherCost.Run_Yr8__c=10 ; 
        TestOtherCost.Run_Yr9__c=10 ; 
        
        TestOtherCost.Opportunity__c= TestOpportunity.id; 
        //TestOtherCost.Phase__c='' ; 
        //TestOtherCost.Final_Month_FTE__c =10;
        insert TestOtherCost;

        nOCDids.add(TestOtherCost.id);
        nOCDids.add(TestOtherCost.id);
        
        
        
        costdataMap = new Map<String,String>();
     }
     
     static testMethod void TrustThisMethod(){
          SetupData();
          test.startTest();
         // Map<String, String> costDataMap = new Map<String, String>();
          costDataMap.put('ID', costingReq.Id);
          costDataMap.put('Opportunity__c', TestOpportunity.id);
            // Call Benchmark Function
           // BenchmarkSync_IOBPOSync_V2.getFTEandOtherCost(nFteIds, nOcdIds, new Set<Id>(), TestOpportunity.id);
           System.enqueueJob(new BenchmarkSync_IO_Queue (nFteIds, nOcdIds, new set<Id>(), new Set<Id>(), oFTEids, oOcdIds, new Set<Id>(), new Set<Id>(), costDataMap));
           // BenchmarkSync.populateBenchMarkObjs(nFTEIds,nOCDids,oFTEids,oOCDids,costdataMap);
          test.stopTest();
      }
      static testMethod void TrustThisMethodToo(){
          //SetupData1();
          test.startTest();
            // Call Benchmark Function
            //BenchmarkSync.populateBenchMarkObjs(nFTEIds,nOCDids,oFTEids,oOCDids,costdataMap);
          test.stopTest();
      }
       
}