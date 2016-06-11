@isTest
/*
@name : OtherCostTriggerOperationTest
@CreatedDate : 9/10/2015 3:32 PM
@Description : 
@Version : 
*/

private class OtherCostTriggerOperation_Test{
    private static User testUser;
    
    static testMethod void test1(){
    
    Profile p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.MOB_Editor);
    testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME,'test1@testorg.com');
        
    insert testUser;
        
    Geo_Region_Master__c geoM=new Geo_Region_Master__c(Name=UTIL_Constants.AsiaPacific,Active__c=true);  
    insert geoM;   
     
    Operating_Groups_Master__c opGrpM=new Operating_Groups_Master__c(Name='TestGroupMaster',Active__c=true,Description__c='TestDescp');
    insert opGrpM;
    
    Opportunity opp=new Opportunity(Name='TestOpp',Geo_Region__c=geoM.Id,Geo_Unit__c='ASEAN',OperatingGroup__c=opGrpM.Id,Reporting_Status__c='pipeline',StageName='0A',Risk_Level__c='Low',closedate=system.today());    
    insert opp;
    
    Offering_Master__c off=new Offering_Master__c(Name='Sourcing and Procurement',offering_description__c='Test offering Master',flywheel_non_flywheel__c='tesfly');
    insert off;
    
    Offering_Name__c offName=new Offering_Name__c(name='Sourcing and Procurement');
    insert offName;
    
    Solution_Scope__c sscope1=new Solution_Scope__c(Opportunity__c=opp.Id,Solution_Component__c='Delivery',Offering_Master__c=off.id,IsUserAddedOffering__c=false); 
    insert sscope1;
    //Solution_Scope__c sscope2=new Solution_Scope__c(Opportunity__c=opp.Id,Solution_Component__c='PMO',Offering_Master__c=off.Id); 
    
    Services_Master__c srvM=new Services_Master__c(Name='Tpayroll',active__c=true,Solution_Component__c='Delivery',offering__c=off.Id,Service_Group__c='BPO');
    insert srvM;
    
    Service__c srv=new Service__c(services__c=srvM.Id,Scope_Status__c='tbd',Solutionscope__c=sscope1.Id);
    insert srv;
    
    Tech_Tool_Master__c techMaster=new Tech_Tool_Master__c(Name='tec Master',Services__c=srvM.id,Tech_Tool_Description__c='Test master');
    insert techMaster;    
    
    Tech_Tools__c tech=new Tech_Tools__c(Tech_Tool__c=techMaster.Id,Service__c=srv.Id,Active__c=true);
    insert tech;
    //Tech_Tools__c=tech.Id
    
    Costing_Request__c cost=new Costing_Request__c(Opportunity__c=opp.Id,Country__c='India');
    insert cost;
    
    Opportunity_Delivery_Location__c oppLocation=new Opportunity_Delivery_Location__c(Offering_Service__c=srv.id);
    insert oppLocation;
    
    //Creating Other_Cost_Details__c test data   
    List<Other_Cost_Details__c> ocdList=new List<Other_Cost_Details__c>();

    Other_Cost_Details__c ocd1=new Other_Cost_Details__c(Name='TestOcd1',Opportunity__c=opp.Id,Service__c=srv.Id,Costing_Request__c=cost.Id,Service_Group__c='TestGroup1',Sub_Service_Group__c=sscope1.Id,Cost_Type__c='payroll',Offering2__c='off2a',Run_Yr1__c=3/4,Mob_Totals__c=10,Phases__c='test phase1');
       
    //Other_Cost_Details__c ocd2=new Other_Cost_Details__c(Name='TestOcd2',Opportunity__c=opp.Id,Service__c=srv.Id,Costing_Request__c=cost.Id,Service_Group__c='TestGroup2',Sub_Service_Group__c=sscope1.Id,Cost_Type__c='Sync',Offering2__c='off2b',Run_Yr1__c=3,Mob_Totals__c=12,Phases__c='test phase2');
    
    ocdList.add(ocd1);    
    //ocdList.add(ocd2);
    insert ocdList;
    //database.insert(ocdList);
    
      
   Test.starttest();
    
    OtherCostTriggerOperation.mapMissingTechTool(ocdList,ocdList[0].Opportunity__c);
    OtherCostTriggerOperation.populatePayrollData(ocdList);
    //OtherCostTriggerOperation.insertDeliveryLocation(ocdList,ocdList[0].Opportunity__c);
    
    Test.StopTest();
    
    
    /*System.assertEquals(cost.Country__c,'India');
    System.assertNotEquals(cost.Country__c,'India');
    System.assertEquals(sscope1.Solution_Component__c,'Technology');
    System.assertNotEquals(sscope1.Solution_Component__c,'Technology');*/
  } 
  
  static testMethod void TestForAPAC() {
  		test.starttest();
		Geo_Region_Master__c geoApac=new Geo_Region_Master__c(name=UTIL_Constants.AsiaPacific,active__c=true);
    	insert geoApac;
        Country_Master__c countryApac=new Country_Master__c(name='India',active__c=true,Geo_Region__c=geoApac.id);
        insert countryApac;
        List<Delivery_Location_Masters__c> delloclist=new list<Delivery_Location_Masters__c>();
        Delivery_Location_Masters__c deliverylocMaster1=new Delivery_Location_Masters__c(name=UTIL_Constants.AsiaPacific_NonDCN_Location,active__c=true,country__c=countryApac.id);
        Delivery_Location_Masters__c deliverylocMaster2=new Delivery_Location_Masters__c(name=UTIL_Constants.AsiaPacific_Client_Location,active__c=true,country__c=countryApac.id);
        Delivery_Location_Masters__c deliverylocMaster3=new Delivery_Location_Masters__c(name='Mumbai',active__c=true,country__c=countryApac.id);
        Delivery_Location_Masters__c deliverylocMaster4=new Delivery_Location_Masters__c(name='India-Banglore',active__c=true,country__c=countryApac.id);
        delloclist.add(deliverylocMaster1);
        delloclist.add(deliverylocMaster2);
        delloclist.add(deliverylocMaster3);
        delloclist.add(deliverylocMaster4);
        
        Operating_Groups_Master__c opGrpM=new Operating_Groups_Master__c(Name='TestGroupMaster',Active__c=true,Description__c='TestDescp');
    	insert opGrpM;
    
	    Opportunity opp=new Opportunity(Name='TestOpp',Geo_Region__c=geoApac.Id,Geo_Unit__c='ASEAN',OperatingGroup__c=opGrpM.Id,Reporting_Status__c='pipeline',StageName='0A',Risk_Level__c='Low',closedate=system.today());    
	    insert opp;
    
	    Offering_Master__c off=new Offering_Master__c(Name='Sourcing and Procurement',offering_description__c='Test offering Master',flywheel_non_flywheel__c='tesfly',Service_Group__c='BPO');
	    insert off;
    
	    Offering_Name__c offName=new Offering_Name__c(name='Sourcing and Procurement');
	    insert offName;
    
	    Solution_Scope__c sscope1=new Solution_Scope__c(Opportunity__c=opp.Id,Solution_Component__c='Delivery',Offering_Master__c=off.id,IsUserAddedOffering__c=false); 
	    insert sscope1;
    //Solution_Scope__c sscope2=new Solution_Scope__c(Opportunity__c=opp.Id,Solution_Component__c='PMO',Offering_Master__c=off.Id); 
    
	    Services_Master__c srvM=new Services_Master__c(Name='Tpayroll',active__c=true,Solution_Component__c='Delivery',offering__c=off.Id,Service_Group__c='BPO');
	    insert srvM;
	    
	    Service__c srv=new Service__c(services__c=srvM.Id,Scope_Status__c='tbd',Solutionscope__c=sscope1.Id);
	    insert srv;
	    List<Other_Cost_Details__c> FTElist=new List<Other_Cost_Details__c>();
	    Other_Cost_Details__c fterec1= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Banglore',Load_Type_Dev__c='Client',Opportunity__c=opp.id,Country__c=countryApac.id,source__c='Sync');
		Other_Cost_Details__c fterec2= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Mumbai',Load_Type_Dev__c='Client',Opportunity__c=opp.id,Country__c=countryApac.id,source__c='Sync');
		Other_Cost_Details__c fterec3= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Chennai',Load_Type_Dev__c='Other',Opportunity__c=opp.id,Country__c=countryApac.id,source__c='Sync');
	    Other_Cost_Details__c fterec4= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Manglore',Load_Type_Dev__c='Client',Opportunity__c=opp.id,Country__c=countryApac.id,source__c='Sync');
		FTElist.add(fterec1);
		FTElist.add(fterec2);
		FTElist.add(fterec3);
		FTElist.add(fterec4);
		insert FTElist;
		test.stoptest();
    }
    
    static testMethod void TestForNALATAMAndEmea() {
  		test.starttest();
		Geo_Region_Master__c geo1=new Geo_Region_Master__c(name='North America',active__c=true);
		Geo_Region_Master__c geo2=new Geo_Region_Master__c(name='Latin America',active__c=true);
		Geo_Region_Master__c geo3=new Geo_Region_Master__c(name='EMEA',active__c=true);
		Geo_Region_Master__c geo4=new Geo_Region_Master__c(name='EMEA',active__c=true);
    	insert geo1;
    	insert geo2;
    	insert geo3;
    	insert geo4;
        Country_Master__c country1=new Country_Master__c(name='India',active__c=true,Geo_Region__c=geo1.id);
        Country_Master__c country2=new Country_Master__c(name='India',active__c=true,Geo_Region__c=geo2.id);
        Country_Master__c country3=new Country_Master__c(name='India',active__c=true,Geo_Region__c=geo3.id);
        Country_Master__c country4=new Country_Master__c(name='India',active__c=true,Geo_Region__c=geo4.id);
        insert country1;
        insert country2;
        insert country3; insert country4;
        List<Delivery_Location_Masters__c> delloclist=new list<Delivery_Location_Masters__c>();
        Delivery_Location_Masters__c deliverylocMaster1=new Delivery_Location_Masters__c(name='NA NON DCN Location',active__c=true,country__c=country1.id);
        Delivery_Location_Masters__c deliverylocMaster2=new Delivery_Location_Masters__c(name='NA Client Location',active__c=true,country__c=country1.id);
        Delivery_Location_Masters__c deliverylocMaster3=new Delivery_Location_Masters__c(name='EMEA Client Location',active__c=true,country__c=country1.id);
        Delivery_Location_Masters__c deliverylocMaster4=new Delivery_Location_Masters__c(name='EMEA NON DCN Location',active__c=true,country__c=country1.id);
        Delivery_Location_Masters__c deliverylocMaster5=new Delivery_Location_Masters__c(name='LATAM NON DCN Location',active__c=true,country__c=country1.id);
        Delivery_Location_Masters__c deliverylocMaster6=new Delivery_Location_Masters__c(name='LATAM Client Location',active__c=true,country__c=country1.id);
        Delivery_Location_Masters__c deliverylocMaster7=new Delivery_Location_Masters__c(name=UTIL_Constants.AsiaPacific_Client_Location,active__c=true,country__c=country1.id);
        Delivery_Location_Masters__c deliverylocMaster8=new Delivery_Location_Masters__c(name=UTIL_Constants.AsiaPacific_NonDCN_Location,active__c=true,country__c=country1.id);
        delloclist.add(deliverylocMaster1);
        delloclist.add(deliverylocMaster2);
        delloclist.add(deliverylocMaster3);
        delloclist.add(deliverylocMaster4);
        delloclist.add(deliverylocMaster5);
        delloclist.add(deliverylocMaster6);
        delloclist.add(deliverylocMaster7);
        delloclist.add(deliverylocMaster8);
        insert delloclist;
        Operating_Groups_Master__c opGrpM=new Operating_Groups_Master__c(Name='TestGroupMaster',Active__c=true,Description__c='TestDescp');
    	insert opGrpM;
    
	    Opportunity opp=new Opportunity(Name='TestOpp',Geo_Region__c=geo1.Id,Geo_Unit__c='ASEAN',OperatingGroup__c=opGrpM.Id,Reporting_Status__c='pipeline',StageName='0A',Risk_Level__c='Low',closedate=system.today());    
	    insert opp;
    
	    Offering_Master__c off=new Offering_Master__c(Name='Sourcing and Procurement',offering_description__c='Test offering Master',flywheel_non_flywheel__c='tesfly',Service_Group__c='BPO');
	    insert off;
    
	    Offering_Name__c offName=new Offering_Name__c(name='Sourcing and Procurement');
	    insert offName;
    
	    Solution_Scope__c sscope1=new Solution_Scope__c(Opportunity__c=opp.Id,Solution_Component__c='Delivery',Offering_Master__c=off.id,IsUserAddedOffering__c=false); 
	    insert sscope1;
    //Solution_Scope__c sscope2=new Solution_Scope__c(Opportunity__c=opp.Id,Solution_Component__c='PMO',Offering_Master__c=off.Id); 
    
	    Services_Master__c srvM=new Services_Master__c(Name='Tpayroll',active__c=true,Solution_Component__c='Delivery',offering__c=off.Id,Service_Group__c='BPO');
	    insert srvM;
	    
	    Service__c srv=new Service__c(services__c=srvM.Id,Scope_Status__c='tbd',Solutionscope__c=sscope1.Id);
	    insert srv;
	    List<Other_Cost_Details__c> FTElist=new List<Other_Cost_Details__c>();
	    Other_Cost_Details__c fterec1= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Banglore',Load_Type_Dev__c='Client',Opportunity__c=opp.id,Country__c=country1.id,source__c='Sync');
		Other_Cost_Details__c fterec2= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Mumbai',Load_Type_Dev__c='Other',Opportunity__c=opp.id,Country__c=country1.id,source__c='Sync');
		Other_Cost_Details__c fterec3= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Chennai',Load_Type_Dev__c='Other',Opportunity__c=opp.id,Country__c=country2.id,source__c='Sync');
	    Other_Cost_Details__c fterec4= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Manglore',Load_Type_Dev__c='Client',Opportunity__c=opp.id,Country__c=country2.id,source__c='Sync');
	    Other_Cost_Details__c fterec5= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Banglore',Load_Type_Dev__c='Client',Opportunity__c=opp.id,Country__c=country3.id,source__c='Sync');
		Other_Cost_Details__c fterec6= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Mumbai',Load_Type_Dev__c='Other',Opportunity__c=opp.id,Country__c=country3.id,source__c='Sync');
		Other_Cost_Details__c fterec7= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Chennai',Load_Type_Dev__c='Other',Opportunity__c=opp.id,Country__c=country4.id,source__c='Sync');
	    Other_Cost_Details__c fterec8= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Manglore',Load_Type_Dev__c='Client',Opportunity__c=opp.id,Country__c=country4.id,source__c='Sync');
		FTElist.add(fterec1);
		FTElist.add(fterec2);
		FTElist.add(fterec3);
		FTElist.add(fterec4);
		FTElist.add(fterec5);
		FTElist.add(fterec6);
		FTElist.add(fterec7);
		FTElist.add(fterec8);
		insert FTElist;
		test.stoptest();
    }
    
    static testMethod void TestForNALATAMAndEmeaWithExistingDeliveryLocation() {
  		test.starttest();
		Geo_Region_Master__c geo1=new Geo_Region_Master__c(name='North America',active__c=true);
		Geo_Region_Master__c geo2=new Geo_Region_Master__c(name='Latin America',active__c=true);
		Geo_Region_Master__c geo3=new Geo_Region_Master__c(name='EMEA',active__c=true);
		Geo_Region_Master__c geo4=new Geo_Region_Master__c(name='EMEA',active__c=true);
    	insert geo1;
    	insert geo2;
    	insert geo3;
    	insert geo4;
        Country_Master__c country1=new Country_Master__c(name='India',active__c=true,Geo_Region__c=geo1.id);
        Country_Master__c country2=new Country_Master__c(name='India',active__c=true,Geo_Region__c=geo2.id);
        Country_Master__c country3=new Country_Master__c(name='India',active__c=true,Geo_Region__c=geo3.id);
        Country_Master__c country4=new Country_Master__c(name='India',active__c=true,Geo_Region__c=geo4.id);
        insert country1;
        insert country2;
        insert country3; insert country4;
        List<Delivery_Location_Masters__c> delloclist=new list<Delivery_Location_Masters__c>();
        Delivery_Location_Masters__c deliverylocMaster1=new Delivery_Location_Masters__c(name='NA NON DCN Location',active__c=true,country__c=country1.id);
        Delivery_Location_Masters__c deliverylocMaster2=new Delivery_Location_Masters__c(name='NA Client Location',active__c=true,country__c=country1.id);
        Delivery_Location_Masters__c deliverylocMaster3=new Delivery_Location_Masters__c(name='EMEA Client Location',active__c=true,country__c=country1.id);
        Delivery_Location_Masters__c deliverylocMaster4=new Delivery_Location_Masters__c(name='EMEA NON DCN Location',active__c=true,country__c=country1.id);
        Delivery_Location_Masters__c deliverylocMaster5=new Delivery_Location_Masters__c(name='LATAM NON DCN Location',active__c=true,country__c=country1.id);
        Delivery_Location_Masters__c deliverylocMaster6=new Delivery_Location_Masters__c(name='LATAM Client Location',active__c=true,country__c=country1.id);
        Delivery_Location_Masters__c deliverylocMaster7=new Delivery_Location_Masters__c(name=UTIL_Constants.AsiaPacific_Client_Location,active__c=true,country__c=country1.id);
        Delivery_Location_Masters__c deliverylocMaster8=new Delivery_Location_Masters__c(name=UTIL_Constants.AsiaPacific_NonDCN_Location,active__c=true,country__c=country1.id);
        delloclist.add(deliverylocMaster1);
        delloclist.add(deliverylocMaster2);
        delloclist.add(deliverylocMaster3);
        delloclist.add(deliverylocMaster4);
        delloclist.add(deliverylocMaster5);
        delloclist.add(deliverylocMaster6);
        delloclist.add(deliverylocMaster7);
        delloclist.add(deliverylocMaster8);
        Delivery_Location_Masters__c deliverylocMaster9=new Delivery_Location_Masters__c(name='Banglore',active__c=true,country__c=country1.id);
        insert deliverylocMaster9;
        insert delloclist;
        Operating_Groups_Master__c opGrpM=new Operating_Groups_Master__c(Name='TestGroupMaster',Active__c=true,Description__c='TestDescp');
    	insert opGrpM;
    
	    Opportunity opp=new Opportunity(Name='TestOpp',Geo_Region__c=geo1.Id,Geo_Unit__c='ASEAN',OperatingGroup__c=opGrpM.Id,Reporting_Status__c='pipeline',StageName='0A',Risk_Level__c='Low',closedate=system.today());    
	    insert opp;
    
	    Offering_Master__c off=new Offering_Master__c(Name='Sourcing and Procurement',offering_description__c='Test offering Master',flywheel_non_flywheel__c='tesfly',Service_Group__c='BPO');
	    insert off;
    
	    Offering_Name__c offName=new Offering_Name__c(name='Sourcing and Procurement');
	    insert offName;
    
	    Solution_Scope__c sscope1=new Solution_Scope__c(Opportunity__c=opp.Id,Solution_Component__c='Delivery',Offering_Master__c=off.id,IsUserAddedOffering__c=false); 
	    insert sscope1;
    //Solution_Scope__c sscope2=new Solution_Scope__c(Opportunity__c=opp.Id,Solution_Component__c='PMO',Offering_Master__c=off.Id); 
    
	    Services_Master__c srvM=new Services_Master__c(Name='Tpayroll',active__c=true,Solution_Component__c='Delivery',offering__c=off.Id,Service_Group__c='BPO');
	    insert srvM;
	    
	    Service__c srv=new Service__c(services__c=srvM.Id,Scope_Status__c='tbd',Solutionscope__c=sscope1.Id);
	    insert srv;
	    Opportunity_Delivery_Location__c oppdelloc=new Opportunity_Delivery_Location__c(Offering_Service__c=srv.id,Delivery_Location__c=deliverylocMaster9.id);
	    List<Other_Cost_Details__c> FTElist=new List<Other_Cost_Details__c>();
	    Other_Cost_Details__c fterec1= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Banglore',Load_Type_Dev__c='Client',Opportunity__c=opp.id,Country__c=country1.id,source__c='Sync');
		Other_Cost_Details__c fterec2= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Mumbai',Load_Type_Dev__c='Other',Opportunity__c=opp.id,Country__c=country1.id,source__c='Sync');
		Other_Cost_Details__c fterec3= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Chennai',Load_Type_Dev__c='Other',Opportunity__c=opp.id,Country__c=country2.id,source__c='Sync');
	    Other_Cost_Details__c fterec4= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Manglore',Load_Type_Dev__c='Client',Opportunity__c=opp.id,Country__c=country2.id,source__c='Sync');
	    Other_Cost_Details__c fterec5= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Banglore',Load_Type_Dev__c='Client',Opportunity__c=opp.id,Country__c=country3.id,source__c='Sync');
		Other_Cost_Details__c fterec6= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Mumbai',Load_Type_Dev__c='Other',Opportunity__c=opp.id,Country__c=country3.id,source__c='Sync');
		Other_Cost_Details__c fterec7= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Chennai',Load_Type_Dev__c='Other',Opportunity__c=opp.id,Country__c=country4.id,source__c='Sync');
	    Other_Cost_Details__c fterec8= new Other_Cost_Details__c(Service__c=srv.id,Delivery_Location_Dev__c='Manglore',Load_Type_Dev__c='Client',Opportunity__c=opp.id,Country__c=country4.id,source__c='Sync');
		FTElist.add(fterec1);
		FTElist.add(fterec2);
		FTElist.add(fterec3);
		FTElist.add(fterec4);
		FTElist.add(fterec5);
		FTElist.add(fterec6);
		FTElist.add(fterec7);
		FTElist.add(fterec8);
		insert FTElist;
		test.stoptest();
    }
  
  

}