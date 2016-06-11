/*
Author : Malkeet singh
Story  :
Description : Test Class for Master controllers. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class MasterControllersTest{
static Category__c category; 
static Deal_tgp__c Deal; 

static Client_Master__c clientName;
static Client_Geo_Area_Master__c clientGeoArea;
static Operating_Group_Master__c operatingGroup;
static Client_Geo_Unit_Master__c clientGeoUnit;
static Key_Buyer_Value_Category_Master__c kbValue;
static Service_Master__c serviceMaster; 
static Assumption_Master__c assumptionMaster;
static Offerings_Master__c offeringMaster;
static Opportunity_Offering__c oppOffering;
static KT_Planning_Activity_Master__c ktPlan;
static Facility_Master__c fMaster;
static Delievery_Location_Master__c DLM;
static Contract_Legal_Infosec_Section_Master__c CLISM;
static Contract_Legal_Infosec_Task_Master__c CLITM;
static Operating_Group_Master__c opgroup;
static Review_Stage_Master__c revstage;
static Review_Type_Master__c revtyp;
static Service_Component__c servicomp;
static Service_Management_Task_Master__c sermantask;
static Service_Management_Master__c sermanphmas;
static Third_Party_Vendor_Master_Custom__c thirdvendormas;
static BCP_Section_Master__c bcpSection;
static BCP_Task_Master__c bcptask;
static Journey_Management_Deliverable__c joumandel;
static Tech_Assessment_Activity_Master__c techasacmas;
static Journey_Management__c joumastas;
static Client_Dependency_Master__c cdM;

public static void setupData(){
// To create a deal
Deal=new deal_TGP__c();
deal.name='testghfhhghfg';
insert deal;
Recursive.dealNameFlag=false;



List<deal_TGP__c> DealList1=new List<deal_TGP__c>();
List<deal_TGP__c> dealList=[Select name from deal_TGP__c where id =:deal.id];
for(deal_TGP__c cml: dealList)
{
cml.name='testingghgfhffhfghfd';
DealList1.add(cml);
}
update DealList1;



//To create Category Master


category= new Category__c();
category.name='test';
upsert category;
Recursive.CategoryNameFlag=false;



List<Category__c> CategoryList1=new List<Category__c>();
List<Category__c> CategoryList=[Select name from Category__c where id =:category.id];
for(Category__c cml: CategoryList)
{
cml.name='testing';
CategoryList1.add(cml);
}
update CategoryList1;


//To Create a Client Master
clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
upsert clientName;
Recursive.ClientMasterNameFlag=false;
List<Client_Master__c> clientMasterList2=new List<Client_Master__c>();
List<Client_Master__c> clientMasterList=[Select name from Client_Master__c where id =:clientName.id];
for(Client_Master__c cml : clientMasterList)
{
cml.name='testing';
clientMasterList2.add(cml);
}
update clientMasterList2;

//To Create a Client Geo Area Master
clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
insert clientGeoArea;
Recursive.clientGeoAreaNameFlag=false;
List<Client_Geo_Area_Master__c> clientGeoArea2=new List<Client_Geo_Area_Master__c>();
List<Client_Geo_Area_Master__c> clientGeoArea1=[Select name from Client_Geo_Area_Master__c where id =:clientGeoArea.id];
for(Client_Geo_Area_Master__c cml : clientGeoArea1)
{
cml.name='testing';
clientGeoArea2.add(cml);
}
update clientGeoArea2;


//To Create a operatingGroup Master



operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
insert operatingGroup;

Recursive.OperatingGroupMasterNameFlag=false;
List<Operating_Group_Master__c> operatingGroupList2=new List<Operating_Group_Master__c>();
List<Operating_Group_Master__c> operatingGroupList=[Select name from Operating_Group_Master__c where id =:operatingGroup.id];
for(Operating_Group_Master__c cml : operatingGroupList)
{
cml.name='testing';
operatingGroupList2.add(cml);
}
update operatingGroupList2;


//To Create a Clint Geo Unit

clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
insert clientGeoUnit;

Recursive.clientGeoUnitNameFlag=false;
List<Client_Geo_Unit_Master__c> clientGeounit2=new List<Client_Geo_Unit_Master__c>();
List<Client_Geo_Unit_Master__c> clientGeounit1=[Select name from Client_Geo_Unit_Master__c where id =:clientGeoUnit.id];
for(Client_Geo_Unit_Master__c cml : clientGeounit1)
{
cml.name='testing';
clientGeounit2.add(cml);
}
update clientGeounit2;


//To Create a offeringMaster
offeringMaster = new Offerings_Master__c (Name = 'TestOffering',Active__c = true);
insert offeringMaster;
Recursive.OfferingsMasterNameFlag=false;
List<Offerings_Master__c> offeringMaster2=new List<Offerings_Master__c>();
List<Offerings_Master__c> offeringMaster1=[Select name from Offerings_Master__c where id =:offeringMaster.id];
for(Offerings_Master__c cml : offeringMaster1)
{
cml.name='testing';
offeringMaster2.add(cml);
}
update offeringMaster2;


serviceMaster = new Service_Master__c(Name = 'TestService',Offering__c = offeringMaster.id,Active__c = true );
insert serviceMaster;

Recursive.ServiceMasterNameFlag=false;
List<Service_Master__c> serviceMaster2=new List<Service_Master__c>();
List<Service_Master__c> serviceMaster1=[Select name from Service_Master__c where id =:serviceMaster.id];
for(Service_Master__c cml : serviceMaster1)
{
cml.name='testing';
serviceMaster2.add(cml);
}
update serviceMaster2;


assumptionMaster = new Assumption_Master__c(Category__c = 'TestCategory',Assumption__c = 'TestData',Active_Inactive__c = true);
insert assumptionMaster;
List<Assumption_Master__c> assumptionMaster2=new List<Assumption_Master__c>();
List<Assumption_Master__c> assumptionMaster1=[Select Assumption__c from Assumption_Master__c where id =:assumptionMaster.id];
for(Assumption_Master__c cml : assumptionMaster1)
{
cml.Assumption__c='testing';
assumptionMaster2.add(cml);
}
update assumptionMaster2;


//To insert Delievery_Location_Master__c
DLM= new Delievery_Location_Master__c();

DLM.Client_Geo_Area_Master__c=clientGeoArea.id;
DLM.Name='test';
insert DLM;

Recursive.DelieveryLocationMasterNameFlag = false;

List<Delievery_Location_Master__c> DLM2=new List<Delievery_Location_Master__c>();
List<Delievery_Location_Master__c> DLM1=[Select name from Delievery_Location_Master__c where id =:DLM.id];
for(Delievery_Location_Master__c cml : DLM1)
{
cml.name='testing';
DLM2.add(cml);
}
update DLM2;


//To insert Facility Master

fMaster=new Facility_Master__c();
fMaster.Delivery_Location_Master__c=DLM.id;
fMaster.name='test';
insert fMaster;

Recursive.FacilityMasterNameFlag  = false;
List<Facility_Master__c> fMaster2=new List<Facility_Master__c>();
List<Facility_Master__c> fMaster1=[Select Name from Facility_Master__c where id =:fMaster.id];
for(Facility_Master__c cml : fMaster1)
{
cml.Name='testing';
fMaster2.add(cml);
}
update fMaster2;

//To insert Key Buyer Value

kbValue=new Key_Buyer_Value_Category_Master__c();
kbValue.name='test';
insert kbValue;
Recursive.KeyBuyerValueCategoryMasterNameFlag  = false;
List<Key_Buyer_Value_Category_Master__c> kbValue2=new List<Key_Buyer_Value_Category_Master__c>();
List<Key_Buyer_Value_Category_Master__c> kbValue1=[Select Name from Key_Buyer_Value_Category_Master__c where id =:kbValue.id];
for(Key_Buyer_Value_Category_Master__c cml : kbValue1)
{
cml.Name='testing';
kbValue2.add(cml);
}
update kbValue2;
//To insert KT Planing

ktPlan=new KT_Planning_Activity_Master__c();
ktPlan.name='test';
ktplan.Activity_Order__c=1298;
insert ktPlan;


List<KT_Planning_Activity_Master__c> ktPlan2=new List<KT_Planning_Activity_Master__c>();
List<KT_Planning_Activity_Master__c> ktPlan1=[Select Name from KT_Planning_Activity_Master__c where id =:ktPlan.id];
for(KT_Planning_Activity_Master__c cml : ktPlan1)
{
cml.Name='testing';
ktPlan2.add(cml);
}
update ktPlan2;
//To insert Contract legal infosec master section master


CLISM=new Contract_Legal_Infosec_Section_Master__c();
CLISM.Section_Name__c='test';
CLISM.Section_Number__c='5555';
insert CLISM;

List<Contract_Legal_Infosec_Section_Master__c> CLISM2=new List<Contract_Legal_Infosec_Section_Master__c>();
List<Contract_Legal_Infosec_Section_Master__c> CLISM1=[Select Section_Name__c from Contract_Legal_Infosec_Section_Master__c where id =:CLISM.id];
for(Contract_Legal_Infosec_Section_Master__c cml : CLISM1)
{
cml.Section_Name__c='testing';
CLISM2.add(cml);
}
update CLISM2;

//To insert Contract legal infosec master task master


CLITM=new Contract_Legal_Infosec_Task_Master__c();
CLITM.Contract_Legal_Infosec_Section_Master__c=CLISM.id;
CLITM.Task_Name__c='test';
CLITM.Task_Number__c='5555';
insert CLITM;
Recursive.ContTaskMasterNameFlag= false;

List<Contract_Legal_Infosec_Task_Master__c> CLIT2=new List<Contract_Legal_Infosec_Task_Master__c>();
List<Contract_Legal_Infosec_Task_Master__c> CLIT1=[Select Task_Name__c from Contract_Legal_Infosec_Task_Master__c where id =:CLITM.id];
for(Contract_Legal_Infosec_Task_Master__c cml : CLIT1)
{
cml.Task_Name__c='testing';
CLIT2.add(cml);
}
update CLIT2;

// To craeate a Journet management


//Creating Review type Master
joumastas=new Journey_Management__c();
joumastas.Section_Name__c='test';
joumastas.Section_Number__c='9';
insert joumastas;


//Creating Operating Group
opgroup=new Operating_Group_Master__c();
opgroup.name='test';
opgroup.Active__c=true;
insert opgroup; 

Recursive.OperatingGroupMasterNameFlag = false;

List<Operating_Group_Master__c> opgroup2=new List<Operating_Group_Master__c>();
List<Operating_Group_Master__c> opgroup1=[Select name from Operating_Group_Master__c where id =:opgroup.id];
for(Operating_Group_Master__c cml : opgroup1)
{
cml.name='testing3213123';
opgroup2.add(cml);
}
update opgroup2;

//Creating Review Stage Master
revstage=new Review_Stage_Master__c();
revstage.name='test';
revstage.Active__c=true;

insert revstage; 

Recursive.reviewstageFlag = false;
List<Review_Stage_Master__c> revstage2=new List<Review_Stage_Master__c>();
List<Review_Stage_Master__c> revstage1=[Select name from Review_Stage_Master__c where id =:revstage.id];
for(Review_Stage_Master__c cml : revstage1)
{
cml.name='testing';
revstage2.add(cml);
}
update revstage2;

//Creating Review type Master
revtyp=new Review_Type_Master__c();
revtyp.name='test';
revtyp.Active__c=true;

insert revtyp;
Recursive.reviewTypeFlag = false;
List<Review_Type_Master__c> revtyp2=new List<Review_Type_Master__c>();
List<Review_Type_Master__c> revtyp1=[Select name from Review_Type_Master__c where id =:revtyp.id];
for(Review_Type_Master__c cml : revtyp1)
{
cml.name='testing';
revtyp2.add(cml);
}
update revtyp2;

//Creating Service Component
servicomp=new Service_Component__c();
servicomp.name='test';
servicomp.Offering_Master__c=offeringMaster.id;
servicomp.Service_Master__c=serviceMaster.id;
insert servicomp;
Recursive.ServiceComponentNameFlag= false;

List<Service_Component__c> servicomp2=new List<Service_Component__c>();
List<Service_Component__c> servicomp1=[Select name from Service_Component__c where id =:servicomp.id];
for(Service_Component__c cml : servicomp1)
{
cml.name='testing';
servicomp2.add(cml);
}
update servicomp2;



//Creating Service Management Phase Master
sermanphmas=new Service_Management_Master__c();

sermanphmas.Phase_Name__c='test';
sermanphmas.Phase_Number__c=2232323;
insert sermanphmas;

List<Service_Management_Master__c> sermanphmas2=new List<Service_Management_Master__c>();
List<Service_Management_Master__c> sermanphmas1=[Select Phase_Name__c from Service_Management_Master__c where id =:sermanphmas.id];
for(Service_Management_Master__c cml : sermanphmas1)
{
cml.Phase_Name__c='testing';
sermanphmas2.add(cml);
}
update sermanphmas2;


//Creating Service Management Task Master
sermantask=new Service_Management_Task_Master__c();
sermantask.Service_Management_Phase__c=sermanphmas.id;
sermantask.Task_Name__c='test';
sermantask.Task_Number__c=2;
insert sermantask;

Recursive.SerManTaskMasterNameFlag  = false;
List<Service_Management_Task_Master__c> sermantask2=new List<Service_Management_Task_Master__c>();
List<Service_Management_Task_Master__c> sermantask1=[Select Task_Name__c from Service_Management_Task_Master__c where id =:sermantask.id];
for(Service_Management_Task_Master__c cml : sermantask1)
{
cml.Task_Name__c='testing';
sermantask2.add(cml);
}
update sermantask2;

//Creating Tech Assesment Activity  Master
techasacmas=new Tech_Assessment_Activity_Master__c();

Recursive.TechAssessmentActivitiesMasterFlag   = false;
techasacmas.name='test';
techasacmas.Activity_Order__c=5672;
insert techasacmas;

Recursive.TechAssessmentActivitiesMasterFlag   = false;
List<Tech_Assessment_Activity_Master__c> techasacmas2=new List<Tech_Assessment_Activity_Master__c>();
List<Tech_Assessment_Activity_Master__c> techasacmas1=[Select name from Tech_Assessment_Activity_Master__c where id =:techasacmas.id];
for(Tech_Assessment_Activity_Master__c cml : techasacmas1)
{
cml.name='testing';
techasacmas2.add(cml);
}
update techasacmas2;

//Creating Third Party Vendor Master
thirdvendormas=new Third_Party_Vendor_Master_Custom__c();
thirdvendormas.Third_Party_Vendor_Name__c='test';
thirdvendormas.Offering_Master__c=offeringMaster.id;
insert thirdvendormas;
Recursive.ThirdPartyVendorNameFlag    = false;
List<Third_Party_Vendor_Master_Custom__c> thirdvendormas2=new List<Third_Party_Vendor_Master_Custom__c>();
List<Third_Party_Vendor_Master_Custom__c> thirdvendormas1=[Select Third_Party_Vendor_Name__c from Third_Party_Vendor_Master_Custom__c where id =:thirdvendormas.id];
for(Third_Party_Vendor_Master_Custom__c cml : thirdvendormas1)
{
cml.Third_Party_Vendor_Name__c='testing';
thirdvendormas2.add(cml);
}
update thirdvendormas2;



//Creating BCP Management Task Master
bcpSection=new BCP_Section_Master__c();

bcpSection.Section_Name__c='test';
bcpSection.Section_Number__c='25453453';
insert bcpSection;
//Creating BCP Task
bcptask=new BCP_Task_Master__c();
bcptask.Business_Continuity_Planning_del__c=bcpSection.id;
bcptask.Task_Name__c='test';
bcptask.Task_Number__c=4;
insert bcptask;
Recursive.BCPTaskMasterNameFlag= false;
Recursive.BCPTaskMasterNumberFlag= false;
List<BCP_Task_Master__c> bcptask2=new List<BCP_Task_Master__c>();
List<BCP_Task_Master__c> bcptask1=[Select Task_Name__c from BCP_Task_Master__c where id =:bcptask.id];
for(BCP_Task_Master__c cml : bcptask1)
{
cml.Task_Name__c='testing';
bcptask2.add(cml);
}
update bcptask2;


//Creating Journey Deliverable
joumandel=new Journey_Management_Deliverable__c();
joumandel.Journey_Management__c=joumastas.id;
joumandel.Deliverable_Name__c='test';
joumandel.Deliverable_Number__c='4';
insert joumandel;
Recursive.SerManTaskMasterNameFlag= false;
List<Journey_Management_Deliverable__c> joumandel2=new List<Journey_Management_Deliverable__c>();
List<Journey_Management_Deliverable__c> joumandel1=[Select Deliverable_Name__c from Journey_Management_Deliverable__c where id =:joumandel.id];
for(Journey_Management_Deliverable__c cml : joumandel1)
{
cml.Deliverable_Name__c='testing';
joumandel2.add(cml);
}
update joumandel2;


//Creating Review type Master
cdM=new Client_Dependency_Master__c();
cdM.Services_per_Offering__c=serviceMaster.id;
cdM.Offering__c=offeringMaster.id;
cdM.Category__c=category.id;
insert cdM;

List<Client_Dependency_Master__c> cdM2=new List<Client_Dependency_Master__c>();
List<Client_Dependency_Master__c> cdM1=[Select Services_per_Offering__c from Client_Dependency_Master__c where id =:cdM.id];
for(Client_Dependency_Master__c cml : cdM1)
{
cml.Services_per_Offering__c=serviceMaster.id;
cdM2.add(cml);
}
update cdM2;

}
static testMethod void testclientAsOperationUploadController(){
test.starttest();
setupData();
test.stoptest(); 
} 
}