/*
*    @isBest
*    because the previous class was not doing it's Job properly.
*/
@isTest
public class IOCostModelUpload_Test{
public static String User_Name='vc71@testorg.com';
    public static Account TestAccount;
    public static Operating_Groups_Master__c TestOperatingGroup;
    public static Offering_Master__c OfferingMasterOpp;
    public static Offering_Master__c OfferingMasterOff;
    public static Services_Master__c ServicesMasterOpp;
    public static Services_Master__c ServicesMasterOff;
    public static Solution_Scope__c TestSolutionScope1;
    public static Services_Component_Master__c ServiceComponentMaster;
    public static opportunity TestOpportunity;
    public static solution_scope__c TestSolutionScope;
    public static List<service__c> TestService;
    public static List<Service_Components__c> TestServiceComponent;
    public static Opportunity_Additional_Role_Master__c TestRoleMaster;
    public static EconomicProfile_Master__c TestEPMaster;
    public static Role_Master__c TestRole;
    public static Load_Type_Master__c TestLoad;
    public static Rate__c TestRate;
    public static Bill_Code_Master__c TestBillCode;
    public static Career_Level__c TestCareerLevel;
    public static Career_Track_Master__c TestCareerTrack;
    public static Country_Master__c TestCountry;
    public static Resource_Group_Master__c TestResourceGroup;
    public static Delivery_Location_Masters__c TestDelLocMaster;
    
    private static void SetupData() {
    // Create Operating Group
        TestOperatingGroup = new Operating_Groups_Master__c();
        TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('test group master'); 
    // Create Account
        TestAccount = new Account (Name = 'TestAccount');
            database.insert(TestAccount);
    // Creating Offering Master
        OfferingMasterOpp = new Offering_Master__c();
        OfferingMasterOpp.name = 'Cross';
        OfferingMasterOpp.active__c = true;
        OfferingMasterOpp.flywheel_non_flywheel__c = 'Flywheel';
        OfferingMasterOpp.offering_description__c = 'I Am Entropy';
        OfferingMasterOpp.Service_Group__c = 'IO';
            database.insert(OfferingMasterOpp);
        OfferingMasterOff = new Offering_Master__c();
        OfferingMasterOff.name = 'Finance and Accounting';
        OfferingMasterOff.active__c = true;
        OfferingMasterOff.flywheel_non_flywheel__c = 'Flywheel';
        OfferingMasterOff.offering_description__c = 'Say What';
        OfferingMasterOff.Service_Group__c = 'IO';
            database.insert(OfferingMasterOff);
    // Dont understand why would any one do this. But it is required for running this test class
    Offering_Master__c off2 = new Offering_Master__c(service_group__c = 'BPO',active__c = true,name='Sourcing and Procurement',offering_description__c='test desc',flywheel_non_flywheel__c='test NF');
    insert off2;
    Offering_Name__c offCustomsetting = new Offering_Name__c(name = 'Sourcing and Procurement',name__c=off2.id);
    insert offCustomsetting;
    // Creating Service Master     
        ServicesMasterOff = new Services_Master__c();
        ServicesMasterOff.name = 'Order To Cash';
        ServicesMasterOff.active__c = true;
        ServicesMasterOff.Is_Offering_Specific_Service__c = true;
        ServicesMasterOff.offering__c = OfferingMasterOff.id;
        ServicesMasterOff.service_description__c = 'This is Madness'; 
        ServicesMasterOff.Service_Group__c = 'IO';
        ServicesMasterOff.Solution_Component__c = 'Delivery';
            database.insert(ServicesMasterOff);
        
        // creating service master to cover else part(mismatch offering)
        // Creating Service Master     
        Services_Master__c ServicesMasterOff1 = new Services_Master__c();
        ServicesMasterOff1.name = 'Harry';
        ServicesMasterOff1.active__c = true;
        ServicesMasterOff1.Is_Offering_Specific_Service__c = true;
        ServicesMasterOff1.offering__c = OfferingMasterOff.id;
        ServicesMasterOff1.service_description__c = 'This is Madness'; 
        ServicesMasterOff1.Service_Group__c = 'IO';
        ServicesMasterOff1.Solution_Component__c = 'Delivery';
            database.insert(ServicesMasterOff1);
    // Creating Service Component Master
        ServiceComponentMaster = new Services_Component_Master__c();
        ServiceComponentMaster.name = 'Team Workspace Mgmt';
        ServiceComponentMaster.active__c =  true;
        ServiceComponentMaster.service__c = ServicesMasterOff.id;
        ServiceComponentMaster.service_component_description__c = 'This is Spaarta!!!!';
            database.insert(ServiceComponentMaster);
    //
        TestEPMaster= new EconomicProfile_Master__c(Active__c=true,name='Infrastructure Consulting');
            database.insert(TestEPMaster);
            
        TestRole = new Role_Master__c(Active__c=true,name='Task');
            database.insert(TestRole);
            
        TestLoad = new Load_Type_Master__c(Active__c=true,name='NA');
            database.insert(TestLoad);
            
        TestRate = new Rate__c(Active__c=true,name='Standard');
            database.insert(TestRate);
            
        TestBillCode = new Bill_Code_Master__c(Active__c=true,name='31');
            database.insert(TestBillCode);
            
        TestCareerLevel = new Career_Level__c(Active__c=true,name='11-Analyst');
            database.insert(TestCareerLevel);
           
        TestCareerTrack = new Career_Track_Master__c(Active__c=true,name='Client & Market');
            database.insert(TestCareerTrack);
            
        TestCountry = new Country_Master__c(Active__c=true,name='Austria');
            database.insert(TestCountry);
            
        TestResourceGroup = new Resource_Group_Master__c(Active__c=true,name='ACN Onshore');
            database.insert(TestResourceGroup);
    // Delivery Location Master
        TestDelLocMaster = new Delivery_Location_Masters__c();
            TestDelLocMaster.active__c=true;    
            TestDelLocMaster.Is_IO_Location__c=true;
            TestDelLocMaster.country__c = TestCountry.id;
            TestDelLocMaster.delivery_location_type__c = 'DCN';
            TestDelLocMaster.Name = 'Test Country';
            insert TestDelLocMaster;
    // Load Data from Custom Settings
        List<sObject> OtherCost = Test.loadData(Other_Cost_SWB_field_map__c.sObjectType, 'Other');
        List<sObject> Volume = Test.loadData(Volume_SWB_field_map__c.sObjectType, 'Volume');
        List<sObject> Payroll = Test.loadData(payroll_swb_field_map__c.sObjectType, 'Payroll');
        List<sObject> Pyramid = Test.loadData(pyramid_swb_field_map__c.sObjectType, 'Pyramid');
        
    // Creating Opportunity
        TestOpportunity = new Opportunity();
         TestOpportunity.Reporting_Status__c = UtilConstants.WON;
         TestOpportunity.Geo_Area__c = UtilConstants.EALA;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id;
         TestOpportunity.StageName = UtilConstants.TWO_B;
         TestOpportunity.Risk_Level__c = UtilConstants.NORMAL;
         TestOpportunity.CloseDate = System.today();
         TestOpportunity.Name = UtilConstants.TEST_OPP;
         insert TestOpportunity;
        //creating one more oppertunity
        /*Opportunity TestOpportunity1 = new Opportunity();
         TestOpportunity1.Reporting_Status__c = UtilConstants.WON;
         TestOpportunity1.Geo_Area__c = UtilConstants.EALA;
         TestOpportunity1.OperatingGroup__c = TestOperatingGroup.id;
         TestOpportunity1.StageName = UtilConstants.TWO_B;
         TestOpportunity.Risk_Level__c = UtilConstants.NORMAL;
         TestOpportunity1.CloseDate = System.today();
         TestOpportunity1.Name = UtilConstants.TEST_OPP;
         insert TestOpportunity1;*/
        
     
     // Creating Solution Scope
         TestSolutionScope = new Solution_Scope__c(Opportunity__c = TestOpportunity.id,Solution_Component__c = UtilConstants.DELIVERY, Offering_Master__c = OfferingMasterOff.id, Service_Group__c = 'IO');
             insert TestSolutionScope;
         TestSolutionScope1 = new Solution_Scope__c(Opportunity__c = TestOpportunity.id,Solution_Component__c = UtilConstants.DELIVERY, Offering_Master__c = OfferingMasterOpp.id, Service_Group__c = 'IO');
             insert TestSolutionScope1;
    }   
    static testmethod void Karna(){
        SetupData();
        test.startTest();
        PageReference pageRef = Page.pagename1;
    pageRef.getParameters().put('id', String.valueOf(TestOpportunity.Id));
    Test.setCurrentPage(pageRef);
    ApexPages.StandardController controller= new ApexPages.StandardController(TestOpportunity);
     IOCostModelUpload obj = new IOCostModelUpload(controller);
     obj.allLines_Pyramid_SWB = 'Pyramid - SWB\n\n'+
                                'Description»ActivityDescription»Phase»ServiceGroup»SubServiceGroup»Service»Service Component»ResourceGroup»Country»CareerTrack»EconomicProfile»RateType»LoadType»Role»CareerLevel»BillCode»M1»M2»M3»M4»M5»M6»M7»M8»M9»M10»M11»M12»M13»M14»M15»M16»M17»M18»M19»M20»M21»M22»M23»M24»M25»M26»M27»M28»M29»M30»M31»M32»M33»M34»M35»M36»M37»M38»M39»M40»M41»M42»M43»M44»M45»M46»M47»M48»M49»M50»M51»M52»M53»M54»M55»M56»M57»M58»M59»M60»M61»M62»M63»M64»M65»M66»M67»M68»M69»M70»M71»M72»M73»M74»M75»M76»M77»M78»M79»M80»M81»M82»M83»M84»M85»M86»M87»M88»M89»M90»M91»M92»M93»M94»M95»M96»M97»M98»M99»M100»M101»M102»M103»M104»M105»M106»M107»M108»M109»M110»M111»M112»M113»M114»M115»M116»M117»M118»M119»M120»»»\n'+
                                'Pyramid Details»dsfsd1»Service Delivery»IO»Finance and Accounting»Order To Cash»Team Workspace Mgmt»ACN Onshore»Austria»Client & Market»Infrastructure Consulting»Standard»NA»Task»11-Analyst»31»186.00»186.00»186.00»186.00»181.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»';
     obj.allLines_Payroll_SWB = 'Payroll - SWB\n\n'+
                                'Description»ActivityDescription»Phase»ServiceGroup»SubServiceGroup»Service»Service Component»ResourceGroup»Country»CareerTrack»EconomicProfile»RateType»LoadType»Role»CareerLevel»BillCode»M1»M2»M3»M4»M5»M6»M7»M8»M9»M10»M11»M12»M13»M14»M15»M16»M17»M18»M19»M20»M21»M22»M23»M24»M25»M26»M27»M28»M29»M30»M31»M32»M33»M34»M35»M36»M37»M38»M39»M40»M41»M42»M43»M44»M45»M46»M47»M48»M49»M50»M51»M52»M53»M54»M55»M56»M57»M58»M59»M60»M61»M62»M63»M64»M65»M66»M67»M68»M69»M70»M71»M72»M73»M74»M75»M76»M77»M78»M79»M80»M81»M82»M83»M84»M85»M86»M87»M88»M89»M90»M91»M92»M93»M94»M95»M96»M97»M98»M99»M100»M101»M102»M103»M104»M105»M106»M107»M108»M109»M110»M111»M112»M113»M114»M115»M116»M117»M118»M119»M120»Unused1»»\n'+
                                'Payroll Cost»dsfsd1»Service Delivery»IO»Finance and Accounting»Order To Cash»Team Workspace Mgmt»ACN Onshore»Austria»Client & Market»Infrastructure Consulting»Standard»NA»Task»11-Analyst»31»123.00»123.00»123.00»123.00»123.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»';

     obj.allLines_Other_Cost_SWB = 'Other Cost - SWB\n\n'+
                                    'Cost Type»Phase»ServiceGroup»SubServiceGroup»Service»Service Component»Activity Description»ResourceGroup»Country»CareerTrack»EconomicProfile»RateType»LoadType»Unused1»Unused2»M1»M2»M3»M4»M5»M6»M7»M8»M9»M10»M11»M12»M13»M14»M15»M16»M17»M18»M19»M20»M21»M22»M23»M24»M25»M26»M27»M28»M29»M30»M31»M32»M33»M34»M35»M36»M37»M38»M39»M40»M41»M42»M43»M44»M45»M46»M47»M48»M49»M50»M51»M52»M53»M54»M55»M56»M57»M58»M59»M60»M61»M62»M63»M64»M65»M66»M67»M68»M69»M70»M71»M72»M73»M74»M75»M76»M77»M78»M79»M80»M81»M82»M83»M84»M85»M86»M87»M88»M89»M90»M91»M92»M93»M94»M95»M96»M97»M98»M99»M100»M101»M102»M103»M104»M105»M106»M107»M108»M109»M110»M111»M112»M113»M114»M115»M116»M117»M118»M119»M120»»\n'+
                                    'DNP Cost»Service Delivery»IO»Finance and Accounting»Order To Cash»Team Workspace Mgmt»DNP »ACN Onshore»Austria»Client & Market»Infrastructure Consulting»Standard»NA»»»123.00»123.00»125.00»127.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»';
     obj.allLines_Volume_SWB = 'Volume - SWB\n\n'+
                                'Phase»ServiceGroup»SubServiceGroup»Service»Service Component»Description»M1»M2»M3»M4»M5»M6»M7»M8»M9»M10»M11»M12»M13»M14»M15»M16»M17»M18»M19»M20»M21»M22»M23»M24»M25»M26»M27»M28»M29»M30»M31»M32»M33»M34»M35»M36»M37»M38»M39»M40»M41»M42»M43»M44»M45»M46»M47»M48»M49»M50»M51»M52»M53»M54»M55»M56»M57»M58»M59»M60»M61»M62»M63»M64»M65»M66»M67»M68»M69»M70»M71»M72»M73»M74»M75»M76»M77»M78»M79»M80»M81»M82»M83»M84»M85»M86»M87»M88»M89»M90»M91»M92»M93»M94»M95»M96»M97»M98»M99»M100»M101»M102»M103»M104»M105»M106»M107»M108»M109»M110»M111»M112»M113»M114»M115»M116»M117»M118»M119»M120\n'+
                                'Service Delivery»IO»Finance and Accounting»Order To Cash»Team Workspace Mgmt»Testing »1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»1.000»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»';
     obj.dropFileName='New File';
     obj.fileBody=blob.valueOf('Test');
     system.debug('before Upload'); 
     obj.UploadFile();
     system.debug('after Upload');
     obj.toOpportunity();
   test.stopTest();
    }
    
    
    static testmethod void samratKelvish(){
        SetupData();
        test.startTest();
        PageReference pageRef = Page.pagename1;
    pageRef.getParameters().put('id', String.valueOf(TestOpportunity.Id));
    Test.setCurrentPage(pageRef);
    ApexPages.StandardController controller= new ApexPages.StandardController(TestOpportunity);
     IOCostModelUpload obj = new IOCostModelUpload(controller);
     obj.allLines_Pyramid_SWB = 'Pyramid - SWB\n\n';
     obj.allLines_Payroll_SWB = 'Payroll - SWB\n\n';

     obj.allLines_Other_Cost_SWB = 'Other Cost - SWB\n\n';
     obj.allLines_Volume_SWB = 'Volume - SWB\n\n';
     obj.dropFileName='New File';
     obj.fileBody=blob.valueOf('Test');
     system.debug('before Upload'); 
     obj.UploadFile();
     
     
        

     system.debug('after Upload');
     obj.toOpportunity();
   test.stopTest();
    }
    static testmethod void coverElsePart(){
        SetupData();
        test.startTest();
        PageReference pageRef = Page.pagename1;
    pageRef.getParameters().put('id', String.valueOf(TestOpportunity.Id));
    Test.setCurrentPage(pageRef);
    ApexPages.StandardController controller= new ApexPages.StandardController(TestOpportunity);
     IOCostModelUpload obj = new IOCostModelUpload(controller);
     obj.allLines_Pyramid_SWB = 'Pyramid - SWB\n\n'+
                                'Description»ActivityDescription»Phase»ServiceGroup»SubServiceGroup»Service»Service Component»ResourceGroup»Country»CareerTrack»EconomicProfile»RateType»LoadType»Role»CareerLevel»BillCode»M1»M2»M3»M4»M5»M6»M7»M8»M9»M10»M11»M12»M13»M14»M15»M16»M17»M18»M19»M20»M21»M22»M23»M24»M25»M26»M27»M28»M29»M30»M31»M32»M33»M34»M35»M36»M37»M38»M39»M40»M41»M42»M43»M44»M45»M46»M47»M48»M49»M50»M51»M52»M53»M54»M55»M56»M57»M58»M59»M60»M61»M62»M63»M64»M65»M66»M67»M68»M69»M70»M71»M72»M73»M74»M75»M76»M77»M78»M79»M80»M81»M82»M83»M84»M85»M86»M87»M88»M89»M90»M91»M92»M93»M94»M95»M96»M97»M98»M99»M100»M101»M102»M103»M104»M105»M106»M107»M108»M109»M110»M111»M112»M113»M114»M115»M116»M117»M118»M119»M120»»»\n'+
                                'Pyramid Details»dsfsd1»Service Delivery»IO»»»»»»»»»»»»»186.00»186.00»186.00»186.00»181.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»';
     
     obj.allLines_Payroll_SWB = 'Payroll - SWB\n\n'+
                                'Description»ActivityDescription»Phase»ServiceGroup»SubServiceGroup»Service»Service Component»ResourceGroup»Country»CareerTrack»EconomicProfile»RateType»LoadType»Role»CareerLevel»BillCode»M1»M2»M3»M4»M5»M6»M7»M8»M9»M10»M11»M12»M13»M14»M15»M16»M17»M18»M19»M20»M21»M22»M23»M24»M25»M26»M27»M28»M29»M30»M31»M32»M33»M34»M35»M36»M37»M38»M39»M40»M41»M42»M43»M44»M45»M46»M47»M48»M49»M50»M51»M52»M53»M54»M55»M56»M57»M58»M59»M60»M61»M62»M63»M64»M65»M66»M67»M68»M69»M70»M71»M72»M73»M74»M75»M76»M77»M78»M79»M80»M81»M82»M83»M84»M85»M86»M87»M88»M89»M90»M91»M92»M93»M94»M95»M96»M97»M98»M99»M100»M101»M102»M103»M104»M105»M106»M107»M108»M109»M110»M111»M112»M113»M114»M115»M116»M117»M118»M119»M120»Unused1»»\n'+
                                'Payroll Cost»dsfsd1»Service Delivery»IO»»»»»»»»»»»31»123.00»123.00»123.00»123.00»123.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»';

     obj.allLines_Other_Cost_SWB = 'Other Cost - SWB\n\n'+
                                    'Cost Type»Phase»ServiceGroup»SubServiceGroup»Service»Service Component»Activity Description»ResourceGroup»Country»CareerTrack»EconomicProfile»RateType»LoadType»Unused1»Unused2»M1»M2»M3»M4»M5»M6»M7»M8»M9»M10»M11»M12»M13»M14»M15»M16»M17»M18»M19»M20»M21»M22»M23»M24»M25»M26»M27»M28»M29»M30»M31»M32»M33»M34»M35»M36»M37»M38»M39»M40»M41»M42»M43»M44»M45»M46»M47»M48»M49»M50»M51»M52»M53»M54»M55»M56»M57»M58»M59»M60»M61»M62»M63»M64»M65»M66»M67»M68»M69»M70»M71»M72»M73»M74»M75»M76»M77»M78»M79»M80»M81»M82»M83»M84»M85»M86»M87»M88»M89»M90»M91»M92»M93»M94»M95»M96»M97»M98»M99»M100»M101»M102»M103»M104»M105»M106»M107»M108»M109»M110»M111»M112»M113»M114»M115»M116»M117»M118»M119»M120»»\n'+
                                    'DNP Cost»Service Delivery»IO»»»»»»»»»»»»»123.00»123.00»125.00»127.00»»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»';
     obj.allLines_Volume_SWB = 'Volume - SWB\n\n'+
                                'Phase»ServiceGroup»SubServiceGroup»Service»Service Component»Description»M1»M2»M3»M4»M5»M6»M7»M8»M9»M10»M11»M12»M13»M14»M15»M16»M17»M18»M19»M20»M21»M22»M23»M24»M25»M26»M27»M28»M29»M30»M31»M32»M33»M34»M35»M36»M37»M38»M39»M40»M41»M42»M43»M44»M45»M46»M47»M48»M49»M50»M51»M52»M53»M54»M55»M56»M57»M58»M59»M60»M61»M62»M63»M64»M65»M66»M67»M68»M69»M70»M71»M72»M73»M74»M75»M76»M77»M78»M79»M80»M81»M82»M83»M84»M85»M86»M87»M88»M89»M90»M91»M92»M93»M94»M95»M96»M97»M98»M99»M100»M101»M102»M103»M104»M105»M106»M107»M108»M109»M110»M111»M112»M113»M114»M115»M116»M117»M118»M119»M120\n'+
                                'Service Delivery»»»»»»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»';     obj.dropFileName='New File';
     obj.dropFileName='New File';
     obj.fileBody=blob.valueOf('Test');
     system.debug('before Upload'); 
     obj.UploadFile();
     system.debug('after Upload');
     obj.toOpportunity();
   test.stopTest();
    }
    /*static testmethod void coverElseInsertOtherCostSWB(){
        SetupData();
        test.startTest();
        PageReference pageRef = Page.pagename1;
    pageRef.getParameters().put('id', String.valueOf(TestOpportunity.Id));
    Test.setCurrentPage(pageRef);
    ApexPages.StandardController controller= new ApexPages.StandardController(TestOpportunity);
     IOCostModelUpload obj = new IOCostModelUpload(controller);
     obj.allLines_Pyramid_SWB = 'Pyramid - SWB\n\n'+
                                'Description»ActivityDescription»Phase»ServiceGroup»SubServiceGroup»Service»Service Component»ResourceGroup»Country»CareerTrack»EconomicProfile»RateType»LoadType»Role»CareerLevel»BillCode»M1»M2»M3»M4»M5»M6»M7»M8»M9»M10»M11»M12»M13»M14»M15»M16»M17»M18»M19»M20»M21»M22»M23»M24»M25»M26»M27»M28»M29»M30»M31»M32»M33»M34»M35»M36»M37»M38»M39»M40»M41»M42»M43»M44»M45»M46»M47»M48»M49»M50»M51»M52»M53»M54»M55»M56»M57»M58»M59»M60»M61»M62»M63»M64»M65»M66»M67»M68»M69»M70»M71»M72»M73»M74»M75»M76»M77»M78»M79»M80»M81»M82»M83»M84»M85»M86»M87»M88»M89»M90»M91»M92»M93»M94»M95»M96»M97»M98»M99»M100»M101»M102»M103»M104»M105»M106»M107»M108»M109»M110»M111»M112»M113»M114»M115»M116»M117»M118»M119»M120»»»\n'+
                                'Pyramid Details»dsfsd1»Service Delivery»IO»Finance and Accounting»Order To Cash»Team Workspace Mgmt»ACN Onshore»Austria»Client & Market»Infrastructure Consulting»Standard»NA»Task»11-Analyst»31»186.00»186.00»186.00»186.00»181.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»';
     obj.allLines_Payroll_SWB = 'Payroll - SWB\n\n'+
                                'Description»ActivityDescription»Phase»ServiceGroup»SubServiceGroup»Service»Service Component»ResourceGroup»Country»CareerTrack»EconomicProfile»RateType»LoadType»Role»CareerLevel»BillCode»M1»M2»M3»M4»M5»M6»M7»M8»M9»M10»M11»M12»M13»M14»M15»M16»M17»M18»M19»M20»M21»M22»M23»M24»M25»M26»M27»M28»M29»M30»M31»M32»M33»M34»M35»M36»M37»M38»M39»M40»M41»M42»M43»M44»M45»M46»M47»M48»M49»M50»M51»M52»M53»M54»M55»M56»M57»M58»M59»M60»M61»M62»M63»M64»M65»M66»M67»M68»M69»M70»M71»M72»M73»M74»M75»M76»M77»M78»M79»M80»M81»M82»M83»M84»M85»M86»M87»M88»M89»M90»M91»M92»M93»M94»M95»M96»M97»M98»M99»M100»M101»M102»M103»M104»M105»M106»M107»M108»M109»M110»M111»M112»M113»M114»M115»M116»M117»M118»M119»M120»Unused1»»\n'+
                                'Payroll Cost»dsfsd1»Service Delivery»IO»Finance and Accounting»Order To Cash»Team Workspace Mgmt»ACN Onshore»Austria»Client & Market»Infrastructure Consulting»Standard»NA»Task»11-Analyst»31»123.00»123.00»123.00»123.00»123.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»';

     obj.allLines_Other_Cost_SWB = 'Other Cost - SWB\n\n'+
                                    'Cost Type»Phase»ServiceGroup»SubServiceGroup»Service»Service Component»Activity Description»ResourceGroup»Country»CareerTrack»EconomicProfile»RateType»LoadType»Unused1»Unused2»M1»M2»M3»M4»M5»M6»M7»M8»M9»M10»M11»M12»M13»M14»M15»M16»M17»M18»M19»M20»M21»M22»M23»M24»M25»M26»M27»M28»M29»M30»M31»M32»M33»M34»M35»M36»M37»M38»M39»M40»M41»M42»M43»M44»M45»M46»M47»M48»M49»M50»M51»M52»M53»M54»M55»M56»M57»M58»M59»M60»M61»M62»M63»M64»M65»M66»M67»M68»M69»M70»M71»M72»M73»M74»M75»M76»M77»M78»M79»M80»M81»M82»M83»M84»M85»M86»M87»M88»M89»M90»M91»M92»M93»M94»M95»M96»M97»M98»M99»M100»M101»M102»M103»M104»M105»M106»M107»M108»M109»M110»M111»M112»M113»M114»M115»M116»M117»M118»M119»M120»»\n'+
                                    'DNP Cost»Service Delivery»IO»»»»»»»»»»»»»123.00»123.00»125.00»127.00»»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»0.00»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»';
     obj.allLines_Volume_SWB = 'Volume - SWB\n\n'+
                                'Phase»ServiceGroup»SubServiceGroup»Service»Service Component»Description»M1»M2»M3»M4»M5»M6»M7»M8»M9»M10»M11»M12»M13»M14»M15»M16»M17»M18»M19»M20»M21»M22»M23»M24»M25»M26»M27»M28»M29»M30»M31»M32»M33»M34»M35»M36»M37»M38»M39»M40»M41»M42»M43»M44»M45»M46»M47»M48»M49»M50»M51»M52»M53»M54»M55»M56»M57»M58»M59»M60»M61»M62»M63»M64»M65»M66»M67»M68»M69»M70»M71»M72»M73»M74»M75»M76»M77»M78»M79»M80»M81»M82»M83»M84»M85»M86»M87»M88»M89»M90»M91»M92»M93»M94»M95»M96»M97»M98»M99»M100»M101»M102»M103»M104»M105»M106»M107»M108»M109»M110»M111»M112»M113»M114»M115»M116»M117»M118»M119»M120\n'+
                                'Service Delivery»»»»»»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»1,000»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»';     obj.dropFileName='New File';
     obj.fileBody=blob.valueOf('Test');
     system.debug('before Upload'); 
     obj.UploadFile();
     system.debug('after Upload');
     obj.toOpportunity();
   test.stopTest();
    }*/
    /*  Before un commenting this, check syncdeletequeue class. check if it is even of any use.  
    static testmethod void Bheeshma(){
        SetupData();
        test.startTest();
        PageReference pageRef = Page.pagename1;
    pageRef.getParameters().put('id', String.valueOf(TestOpportunity.Id));
    Test.setCurrentPage(pageRef);
    ApexPages.StandardController controller= new ApexPages.StandardController(TestOpportunity);
     IOCostModelUpload obj = new IOCostModelUpload(controller);
     obj.allLines_Pyramid_SWB = 'Pyramid - SWB\n\n';                                
     obj.allLines_Payroll_SWB = 'Payroll - SWB\n\n';
     obj.allLines_Other_Cost_SWB = 'Other Cost - SWB\n\n';
     obj.allLines_Volume_SWB = 'Volume - SWB\n\n';
     obj.dropFileName='New File';
     obj.fileBody=blob.valueOf('Test');
     system.debug('before Upload'); 
     obj.UploadFile();
     system.debug('after Upload');
     obj.toOpportunity();
   test.stopTest();
    }*/
}