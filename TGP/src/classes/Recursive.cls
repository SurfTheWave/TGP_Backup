// **************************************************************************************************************
// Name:                Recursive
// Description:         Contains all the String Constants
// Story:               Story-0153/COM_065
// Created By:          Malkeet Singh
//
// ************************Version Updates***********************************************************************
// Updated by             Description
// Shridhar Patankar      Added boolean for Offerings and Opportunity 
// Updated by             Description
// Manik Chaudhary        Added boolean for Third Party Vendor Master 

public class Recursive {
//Deal name check
public static boolean dealNameFlag = false;
//Client Geo Area name Check
public static boolean clientGeoAreaNameFlag = false;
//Client Geo Unit name Check
public static boolean clientGeoUnitNameFlag = false;
//Client Master name Check
public static boolean ClientMasterNameFlag = false;
// Operating Group Master Name Check
public static boolean OperatingGroupMasterNameFlag = false;
// Service Master Name Check
public static boolean ServiceMasterNameFlag = false;
// Delivery Location Master Name Check
public static boolean DelieveryLocationMasterNameFlag = false;
// Facility Master Name Check
public static boolean FacilityMasterNameFlag = false;
// Key Buyer Value Category Master Name Check
public static boolean KeyBuyerValueCategoryMasterNameFlag = false;
// Offerings Master Name Check
public static boolean OfferingsMasterNameFlag = false;
// Offerings Name Check
public static boolean offeringsNameFlag = false;
//Opportunity Name Check
public static boolean opportunityNameFlag = false;
// Service Component Name Check
public static boolean ServiceComponentNameFlag = false;
// Third Party Vendor Master Check
public static boolean ThirdPartyVendorNameFlag = false;
//TechAssessmentActivitiesMaster Name Check
public static boolean TechAssessmentActivitiesMasterFlag = false;
//Category Name check. Added for Sol_151.
public static boolean CategoryNameFlag=false;   
//saveOPEXVersion  Name Check
public static boolean OpexFlag= false;
//saveOPEXVersion  Name Check
public static boolean SratFlag= false;
//KTactivityMaster Name Check
public static boolean KTactivityMasterFlag= false;
//Review Stage Name Check
public static boolean reviewstageFlag= false;
//Review Type Name Check
public static boolean reviewTypeFlag= false;
// Service Management Task Name Check
public static boolean SerManTaskMasterNameFlag= false;
// BCP Task Name Check
public static boolean BCPTaskMasterNameFlag= false;
// BCP Task Name Check
public static boolean BCPTaskMasterNumberFlag= false;
// Journey Deliverable Name Check
public static boolean JourneyDeliMasterNameFlag= false;
// Contract Task Name Check
public static boolean ContTaskMasterNameFlag =false;
// 
public static boolean isDealWaveUpdateFromWaveProcess = false;
//for trigger saveSRATVersion
public static boolean isSRATVersionMarkedActive = false;
//for trigger onlyOneActive on MEC_Post_Contract_Version__c 
public static boolean isMECVersionMarkedActive = false;
}