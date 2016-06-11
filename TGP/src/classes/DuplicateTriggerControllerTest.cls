/*
Author : Malkeet Singh
Story  : MOB_126
Description : Test Class for for All Duplicate Name Trigger Controllers. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class DuplicateTriggerControllerTest{
static Client_Geo_Area_Master__c clientGeoInsert;
static Client_Geo_Unit_Master__c clientGeoUnit;
static Client_Master__c clientName;
static Deal_TGP__c deal;
static Delievery_Location_Master__c deliveryLocMa;
static Facility_Master__c facilityMaster;
 static Operating_Group_Master__c operatingGroup;
 static User testUser; 
static Opportunity_TGP__c oppTGP;
static Key_Buyer_Value_Category_Master__c keyBuyVal;
static Offerings_Master__c offeringMaster;
static Offerings_Master__c offeringMaster2;
static Opportunity_Offering__c oppoffering;
static Service_Master__c serMaster;
static Service_Component__c servComp;
static Review_Stage_Master__c revstg;
static Review_Type_Master__c revtyp;
static Third_Party_Vendor_Master_Custom__c tpvm;
static KT_Planning_Activity_Master__c ktplam;
static Tech_Assessment_Activity_Master__c taacm;
static Category__c catma;

public static void insertData(){


// To create a User

                Profile p =  UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
                testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
                Database.insert(testUser, false);


// To create/Update a Client Geo Area

                clientGeoInsert = new Client_Geo_Area_Master__c();
                clientGeoInsert.Name='TestInsert';
                clientGeoInsert.Client_Geo_Area_Description__c='TestData1';
                insert clientGeoInsert;
                Recursive.clientGeoAreaNameFlag=false;
                clientGeoInsert.Name='TestInsertNew';
                update clientGeoInsert;


// To create/Update a Client Geo Unit

clientGeoUnit = new Client_Geo_Unit_Master__c ();
clientGeoUnit.Name = 'TestLATAM';
clientGeoUnit.Active__c = true;
insert clientGeoUnit;
Recursive.clientGeoUnitNameFlag=false;
clientGeoUnit.Name = 'TestLATAMNew';
Update clientGeoUnit;

//To create/Update Client Area Master Name
 clientName = new Client_Master__c ();
 clientName.Name = 'TestObject1';
 clientName.Active__c = true;
 insert clientName;
Recursive.clientMasterNameFlag=false;
clientName.Name='TestInsertNew';
update clientName;

//To create/Update Deal 

// To create a Deal
deal =new Deal_TGP__c();
deal.Name='Test Data';
insert deal;
Recursive.dealNameFlag=false;
deal.Name='TestInsertNew';
update deal;

// To create a Delivery Location Master
deliveryLocMa =new Delievery_Location_Master__c();
deliveryLocMa.Delivery_Location_Description__c='testdata';
deliveryLocMa.Name='TestData';
deliveryLocMa.Client_Geo_Area_Master__c=clientGeoInsert.id;
insert deliveryLocMa;
Recursive.DelieveryLocationMasterNameFlag = false;
deliveryLocMa.Name='TestInsertNew';
update deliveryLocMa;


// To create/ Update a Facility Master
facilityMaster= new Facility_Master__c();
facilityMaster.Name='test';
facilityMaster.Delivery_Location_Master__c=deliveryLocMa.id;
insert facilityMaster;

Recursive.FacilityMasterNameFlag = false;
facilityMaster.Name='TestInsertNew';
update facilityMaster;

// To create an Operating Group

operatingGroup = new Operating_Group_Master__c ();
operatingGroup.Name = 'TestHSMPS';
operatingGroup.Active__c = true;
insert operatingGroup;
Recursive.OperatingGroupMasterNameFlag = false;
operatingGroup.Name = 'testnew';
Update operatingGroup;


// To create a Opportunity

oppTGP = new Opportunity_TGP__c();

oppTGP.Name = 'TestIBM';
oppTGP.Stage__c='Stage 1';
oppTGP.Client_Name__c= clientName.id ;
oppTGP.Client_Geo_Area__c=clientGeoInsert.id;
oppTGP.Operating_Group__c=operatingGroup.id;
oppTGP.Risk_Level__c='Low';
oppTGP.Expected_contract_sign_qtr__c='FY12-Q4';
oppTGP.Client_Geo_Unit__c=clientGeoUnit.id;
oppTGP.Activity__c='1-Active';
oppTGP.Enterprise_Solution_Architect__c=testUser.id ;
oppTGP.Oppotunity_QA__c='Test';
oppTGP.OG_Sales_Lead__c='Test';
insert oppTGP;



// To create/Update Key Buyer Value record

keyBuyVal= new Key_Buyer_Value_Category_Master__c();
keyBuyVal.Name='test678';
insert keyBuyVal;
Recursive.KeyBuyerValueCategoryMasterNameFlag = false;
keyBuyVal.Name='testnew';
update keyBuyVal;

// To create an Offering
offeringMaster = new Offerings_Master__c ();
offeringMaster.Name = 'TestOffering';
offeringMaster.Active__c = true;
insert offeringMaster;
Recursive.OfferingsMasterNameFlag = false;
offeringMaster.Name = 'new';
Update offeringMaster;

offeringMaster2 = new Offerings_Master__c ();
offeringMaster2.Name = 'testnew';
offeringMaster2.Active__c = true;
insert offeringMaster2;



// To create/ update an Opportunity Offering

oppOffering=new Opportunity_Offering__c();
oppOffering.Solution_Lead__c=testUser.id;
oppOffering.Solution_Specialist__c=testUser.id;
oppOffering.Opportunity_TGP__c=oppTGP.id;
oppOffering.Offering_Master__c=offeringMaster.id;
insert oppOffering;
Recursive.offeringsNameFlag = false;
oppOffering.Offering_Master__c=offeringMaster2.id;
update oppOffering;

// To create a Service Master
serMaster=new Service_Master__c();
serMaster.Name='test';
serMaster.Offering__c=offeringMaster.id;
insert serMaster;
Recursive.ServiceMasterNameFlag = false;
serMaster.Name='testnew';
update serMaster;


// To create a service component master
servComp= new Service_Component__c();
servComp.Name='test';
servComp.Offering_Master__c=offeringMaster.id;
servComp.Service_Master__c=serMaster.id;
insert servComp;
Recursive.ServiceComponentNameFlag = false;
servComp.Name='testnew';
update servComp;

// To create a review stage master
revstg= new Review_Stage_Master__c();
revstg.Name='test';

insert revstg;

Recursive.reviewStageFlag = false;
revstg.Name='testnew';
update revstg;

// To create a review type master
revtyp= new Review_Type_Master__c();
revtyp.Name='test';

insert revtyp;

Recursive.ReviewTypeFlag = false;
revtyp.Name='testnew';
update revtyp;

// To create a third party vendor master
tpvm= new Third_Party_Vendor_Master_Custom__c();
tpvm.Third_Party_Vendor_Name__c='test';
tpvm.Offering_Master__c=offeringMaster.id;

insert tpvm;

Recursive.ThirdPartyVendorNameFlag= false;
tpvm.Third_Party_Vendor_Name__c='testnew';
update tpvm;

// To create a KT planning Activity Master
ktplam= new KT_Planning_Activity_Master__c();
ktplam.Name='test';

insert ktplam;

//Recursive.KTactivityMasterFlag = false;
//ktplam.Name='testnew';
//update ktplam;

// To create a Tech Assessment Activity Master
taacm= new Tech_Assessment_Activity_Master__c();
taacm.Name='test';

insert taacm;

Recursive.TechAssessmentActivitiesMasterFlag = false;
taacm.Name='testnew';
update taacm;

// To create a Category MAster
catma= new Category__c();
catma.Name='test';

insert catma;

Recursive.CategoryNameFlag= false;
catma.Name='testnew';
update catma;


}



static testMethod void test(){
//test.starttest();
//insertData();
  
 }  
 
  
  
}