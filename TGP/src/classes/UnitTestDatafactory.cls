@isTest
/*
   @Author : Jayashree Pradhan
   @name   : UnitTestDatafactory
   @CreateDate : 1 January 2015 
   @Description : Class for creating Test Data
   @Version : 1.0 
  */
public with sharing class UnitTestDatafactory {

    private static final string ALIAS = UtilConstants.ALIAS;
    private static final string EMAIL = UtilConstants.USER_NAME;
    private static final string EMAIL_ENCODING_KEY = UtilConstants.UTF_8;
    private static final string LANGUAGE_LOCAL_KEY = UtilConstants.EN_US;
    private static final string COUNTRY = UtilConstants.COUNTRY;
    private static final string TIME_ZONE = UtilConstants.TIME_ZONE;
    private static final string USER_NAME = UtilConstants.USER_NAME;
    /**
     *  @Description : This method is used to create operating group Master record
     *  @name : createOperatingGroup
     *  @param : String Name
     *  @return parameter - Operating_Groups_Master__c
     *  @throws exception- N/A
     */
    public static Operating_Groups_Master__c createOperatingGroup(String Name) {
        try {
            Operating_Groups_Master__c operatingGroupRec = new Operating_Groups_Master__c();
            operatingGroupRec.Name = Name;
            insert operatingGroupRec;
            return operatingGroupRec;
        } Catch(DMLException e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);
            //System.debug('E==='+e);
        }
        return null;
    }

    /******************************
     * Method Name: getProfile
     * Description: get the profile record based on profile name
     * Paramenters: profile Name
     * Return Value: profile
     */
    public static profile getProfile(String profileName) {
        try {
            Profile p = [Select id from Profile where Name = : profileName limit 1];
            return p;
        } Catch(Exception e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);      
            //System.debug('E==='+e);
        }
        return null;
    }

    /******************************
     * Method Name: getUserWithProfile
     * Description: get user record based on profile
     * Paramenters: profile 
     * Return Value: User
     */
    public static User getUserWithProfile(Profile p, String userName) {
        try {
            User testUser;
            testUser = new User(alias = ALIAS, email = EMAIL,
                                emailencodingkey = EMAIL_ENCODING_KEY, lastname = UtilConstants.TEST, languagelocalekey = LANGUAGE_LOCAL_KEY,
                                localesidkey = LANGUAGE_LOCAL_KEY, profileid = p.Id, country = COUNTRY,
                                timezonesidkey = TIME_ZONE, username = userName);

            return testUser;
        } Catch(Exception e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);         
            //System.debug('E==='+e);
        }
        return null;
    }

    /**
     *  @Description : This method is used to create list of opportunities
     *  @name : createOppList
     *  @param : String OppName,Integer count
     *  @return parameter - List<Opportunity>
     *  @throws exception- N/A
     */
    public static List < Opportunity > createOppList(String OppName, Integer count) {
        try {
            List < Opportunity > oppList = new List < Opportunity > ();
            Operating_Groups_Master__c oppOperatingGrup = createOperatingGroup('India');
            Opportunity opp;
            for (Integer i = 0; i < count; i++) {
                opp = new Opportunity();
                opp.Name = OppName + math.Random();
                opp.Reporting_Status__c = UtilConstants.WON;
                opp.Geo_Area__c = UtilConstants.EALA;
                opp.OperatingGroup__c = oppOperatingGrup.id;
                opp.StageName = UtilConstants.TWO_B;
                opp.Risk_Level__c = UtilConstants.NORMAL;
                opp.CloseDate = System.today();

                oppList.add(opp);
            }
            insert oppList;
            return oppList;
        } Catch(Exception e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);         
            //System.debug('E==='+e);
        }
        return null;
    }
     /**
     *  @Description : This method is used to create the Solution Scope record details
     *  @name : createSolCompList
     *  @param : NA
     *  @return parameter - List < Solution_Scope__c >
     *  @throws exception- NA
     */
    public static List < Solution_Scope__c > createSolCompList(String OppId) {
        try {
            List < Solution_Scope__c > solCompList = new List < Solution_Scope__c > ();
            Solution_Scope__c solComp;
            //Operating_Groups_Master__c oppOperatingGrup = createOperatingGroup('India');
            Offering_Master__c offMaster = new Offering_Master__c(Name = UtilConstants.HR, offering_description__c = UtilConstants.TEST_DESC, 
                                                                flywheel_non_flywheel__c = UtilConstants.FLYWHEEL);
            insert offMaster;

            //for(Integer i=0;i<count;i++) {
            solComp = new Solution_Scope__c();
            solComp.Offering_Master__c = offMaster.id;
            solComp.Opportunity__c = OppId;
            solCompList.add(solComp);
            //}
            insert solCompList;
            return solCompList;
        } Catch(Exception e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);         
            //System.debug('E==='+e);
        }
        return null;
    }
    /**
     *  @Description : This method is used to create map of opportunities
     *  @name : createOppMap
     *  @param : List<Opportunity> oppListToCreate
     *  @return parameter - Map<id,Opportunity>
     *  @throws exception- N/A
     */
    public static Map < id, Opportunity > createOppMap(List < Opportunity > oppListToCreate) {
        try {
            List < Opportunity > updateOppList = new List < Opportunity > ();
            Map < id, Opportunity > oppMap = new Map < id, Opportunity > ();
            for (Opportunity opp: oppListToCreate) {
                opp.Solution_Start_Date__c = System.today();
                opp.Stage_1_Submit_Date__c = System.today();
                opp.RFP_Received_Date__c = System.today();
                opp.Initial_Go_live_Date__c = System.today();
                opp.Contract_End_Date__c = System.today();
                //opp.Contract_Signature_Date__c = System.today();
                opp.Contract_Start_Date__c = System.today();
                opp.Alt_SP_Folder_Name__c = UtilConstants.TEST_FOLDER;
                opp.Capacity_Services_in_Scope__c = true;
                updateOppList.add(opp);

            }
            update updateOppList;
            for (Opportunity oppNew: updateOppList) {
                oppMap.put(oppNew.id, oppNew);
            }
            return oppMap;
        } Catch(Exception e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);         
            //System.debug('E==='+e);
        }
        return null;
    }
    /**
     *  @Description : This method is used to create map of opportunities with analytic services
     *  @name : createOppMapForAnalytics
     *  @param : List<Opportunity> oppListToCreate
     *  @return parameter - Map<id,Opportunity>
     *  @throws exception- N/A
     */
    public static Map < id, Opportunity > createOppMapForAnalytics(List < Opportunity > oppListToCreate) {
        try {
            List < Opportunity > updateOppList = new List < Opportunity > ();
            Map < id, Opportunity > oppMap = new Map < id, Opportunity > ();
            for (Opportunity opp: oppListToCreate) {
                opp.Solution_Start_Date__c = System.today();
                opp.Stage_1_Submit_Date__c = System.today();
                opp.RFP_Received_Date__c = System.today();
                opp.Initial_Go_live_Date__c = System.today();
                opp.Contract_End_Date__c = System.today();
                //opp.Contract_Signature_Date__c = System.today();
                opp.Contract_Start_Date__c = System.today();
                opp.Alt_SP_Folder_Name__c = UtilConstants.TEST_FOLDER;
                opp.Analytics_in_Scope__c = true;
                updateOppList.add(opp);

            }
            update updateOppList;
            for (Opportunity oppNew: updateOppList) {
                oppMap.put(oppNew.id, oppNew);
            }
            return oppMap;
        } Catch(Exception e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);         
            //System.debug('E==='+e);
        }
        return null;
    }
    /**
     *  @Description : This method is used to create list of opportunities with delivery services
     *  @name : createOppDeliveryLoc
     *  @param : NA
     *  @return parameter - List<Opportunity_Delivery_Location__c>
     *  @throws exception- N/A
     */
    public static List < Opportunity_Delivery_Location__c > createOppDeliveryLoc() {
        try {
            List < Opportunity_Delivery_Location__c > oppDeliveryList = new List < Opportunity_Delivery_Location__c > ();
            Operating_Groups_Master__c oppOperatingGrup = createOperatingGroup('India');
            Opportunity opp = new Opportunity();

            opp.Reporting_Status__c = UtilConstants.WON;
            opp.Geo_Area__c = UtilConstants.EALA;
            opp.OperatingGroup__c = oppOperatingGrup.id;
            opp.StageName = UtilConstants.TWO_B;
            opp.Risk_Level__c = UtilConstants.NORMAL;
            opp.CloseDate = System.today();
            opp.Name = UtilConstants.TEST_OPP;

            insert opp;

            Offering_Master__c offMaster = new Offering_Master__c(Name = UtilConstants.HR, offering_description__c = UtilConstants.TEST_DESC,
            flywheel_non_flywheel__c = UtilConstants.FLYWHEEL);
            insert offMaster;

            Services_Master__c serviceMaster = new Services_Master__c(Name = UtilConstants.HRSERVICE, offering__c = offMaster.id);
            insert serviceMaster;

            Solution_Scope__c solComp = new Solution_Scope__c(Opportunity__c = opp.id, Solution_Component__c = UtilConstants.BSS,
            Offering_Master__c = offMaster.id);
            insert solComp;

            Service__c serviceRec = new Service__c(Solutionscope__c = solComp.id, Services__c = serviceMaster.id);
            insert serviceRec;

            Geo_Region_Master__c geoRegion = new Geo_Region_Master__c(Name = UTIL_Constants.AsiaPacific, Active__c = true);
            insert geoRegion;

            Country_Master__c countryMaster = new Country_Master__c(Name = UtilConstants.INDIA, Geo_Region__c = geoRegion.id, active__c = true);
            insert countryMaster;

            Delivery_Location_Masters__c deliveryLocMaster = new Delivery_Location_Masters__c(
            Name = UtilConstants.BANGALORE, country__c = countryMaster.id,
            delivery_location_description__c = UtilConstants.TEST_DESC,
            active__c = true);
            insert deliveryLocMaster;

            Opportunity_Delivery_Location__c oppDeliverylocation = new Opportunity_Delivery_Location__c(Offering_Service__c = serviceRec.id,
            Delivery_Location__c = deliveryLocMaster.id);
            oppDeliveryList.add(oppDeliverylocation);
            insert oppDeliveryList;
            return oppDeliveryList;
        } Catch(DMLException e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);         
            //System.debug('E==='+e);
        }
        return null;
    }
    /**
     *  @Description : This method is used to create list of Assumption master
     *  @name : createAssumptionMasterList
     *  @param : NA
     *  @return parameter - List<Assumptions_Master__c>
     *  @throws exception- N/A
     */
    public static List < Assumptions_Master__c > createAssumptionMasterList() {
        try {
            List < Assumptions_Master__c > assmpMasList = new List < Assumptions_Master__c > ();
            List < Opportunity_Assumption__c > oppAssumpList = new List < Opportunity_Assumption__c > ();
            Operating_Groups_Master__c oppOperatingGrup = createOperatingGroup(UtilConstants.INDIA);
            Opportunity opp = new Opportunity();

            opp.Reporting_Status__c = UtilConstants.WON;
            opp.Geo_Area__c = UtilConstants.EALA;
            opp.OperatingGroup__c = oppOperatingGrup.id;
            opp.StageName = UtilConstants.TWO_B;
            opp.Risk_Level__c = UtilConstants.NORMAL;
            opp.CloseDate = System.today();
            opp.Name = UtilConstants.TEST_OPP;

            insert opp;
            Offering_Master__c offMaster = new Offering_Master__c(Name = UtilConstants.HR, offering_description__c = UtilConstants.TEST_DESC,
            flywheel_non_flywheel__c = UtilConstants.FLYWHEEL);
            insert offMaster;

            Services_Master__c serviceMaster = new Services_Master__c(Name = UtilConstants.HRSERVICE, offering__c = offMaster.id);
            insert serviceMaster;

            Solution_Scope__c solComp = new Solution_Scope__c(Opportunity__c = opp.id, Solution_Component__c = UtilConstants.BSS,
            Offering_Master__c = offMaster.id);
            insert solComp;

            Service__c serviceRec = new Service__c(Solutionscope__c = solComp.id, Services__c = serviceMaster.id);
            insert serviceRec;

            Assumptions_Master__c assmpMaster = new Assumptions_Master__c(Name = UtilConstants.TEST_ASSUMPTION, offering__c = offMaster.id, Service__c = serviceMaster.id, active__c = true, assumption__c = UtilConstants.TEST_ASSUMPTION,
            category__c = UtilConstants.PEOPLE, classification__c = UtilConstants.INTERNAL);
            assmpMasList.add(assmpMaster);
            insert assmpMasList;

            Opportunity_Assumption__c oppAssmp = new Opportunity_Assumption__c(Assumption__c = UtilConstants.ASSUMP_DESC, Category__c = UtilConstants.PEOPLE,
            classification__c = UtilConstants.INTERNAL, Edited__c = false,
            Link_to_Master_Assumption__c = assmpMasList[0].id, Offering__c = solComp.id,
            Service__c = serviceRec.id);
            oppAssumpList.add(oppAssmp);
            insert oppAssumpList;
            return assmpMasList;

        } Catch(Exception e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);         
            //System.debug('E==='+e);
        }
        return null;
    }
    /**
     *  @Description : This method is used to create map of Assumption master
     *  @name : createAssumptionMasterList
     *  @param : List<Assumptions_Master__c> assmpMasList
     *  @return parameter - Map<id,Assumptions_Master__c>
     *  @throws exception- N/A
     */
    public static Map < id, Assumptions_Master__c > createAssumptionMasterMap(List < Assumptions_Master__c > assmpMasList) {
        try {
            List < Assumptions_Master__c > assmpMasListOne = new List < Assumptions_Master__c > ();
            Map < id, Assumptions_Master__c > assmpMasMap = new Map < id, Assumptions_Master__c > ();
            for (Assumptions_Master__c assmp: assmpMasList) {
                assmp.category__c = UtilConstants.FACILITY;
                assmp.classification__c = UtilConstants.EXTERNAL;
                assmp.assumption__c = UtilConstants.TEST_ASSUMPTION;
                assmpMasListOne.add(assmp);
            }
            update assmpMasListOne;
            for (Assumptions_Master__c assmpOne: assmpMasListOne) {
                assmpMasMap.put(assmpOne.id, assmpOne);
            }
            return assmpMasMap;
        } Catch(DMLException e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);         
            //System.debug('E==='+e);
        }
        return null;
    }
    /**
     *  @Description : This method is used to create list of client dependancies master services
     *  @name : createClientDepenMasterList
     *  @param : NA
     *  @return parameter - List<Client_Dependencies_Master__c>
     *  @throws exception- N/A
     */
    public static List < Client_Dependencies_Master__c > createClientDepenMasterList() {
        try {
            List < Client_Dependencies_Master__c > clientDepeMasList = new List < Client_Dependencies_Master__c > ();
            List < Opportunity_Client_Dependency__c > oppClientDepList = new List < Opportunity_Client_Dependency__c > ();
            Operating_Groups_Master__c oppOperatingGrup = createOperatingGroup(UtilConstants.INDIA);
            Opportunity opp = new Opportunity();
            opp.Reporting_Status__c = UtilConstants.WON;
            opp.Geo_Area__c = UtilConstants.EALA;
            opp.OperatingGroup__c = oppOperatingGrup.id;
            opp.StageName = UtilConstants.TWO_B;
            opp.Risk_Level__c = UtilConstants.NORMAL;
            opp.CloseDate = System.today();
            opp.Name = UtilConstants.TEST_OPP;
            insert opp;
            Offering_Master__c offMaster = new Offering_Master__c(Name = UtilConstants.HR, offering_description__c = UtilConstants.TEST_DESC,
            flywheel_non_flywheel__c = UtilConstants.FLYWHEEL);
            insert offMaster;

            Services_Master__c serviceMaster = new Services_Master__c(Name = UtilConstants.HRSERVICE, offering__c = offMaster.id);
            insert serviceMaster;

            Solution_Scope__c solComp = new Solution_Scope__c(Opportunity__c = opp.id, Solution_Component__c = UtilConstants.BSS,
            Offering_Master__c = offMaster.id);
            insert solComp;

            Service__c serviceRec = new Service__c(Solutionscope__c = solComp.id, Services__c = serviceMaster.id);
            insert serviceRec;

            Client_Dependencies_Master__c clientDepMaster = new Client_Dependencies_Master__c(Name = UtilConstants.CLIENT_DEP, offering__c = offMaster.id, Services_per_Offering__c = serviceMaster.id, active__c = true, client_depedency__c = UtilConstants.TEST_CLIENT,
            category__c = UtilConstants.PEOPLE, classification__c = UtilConstants.INTERNAL);
            clientDepeMasList.add(clientDepMaster);
            insert clientDepeMasList;

            Opportunity_Client_Dependency__c oppclientDep = new Opportunity_Client_Dependency__c(Client_Dependency__c = UtilConstants.CLIENT_DESC, Category__c = UtilConstants.PEOPLE,
                                                            classification__c = UtilConstants.INTERNAL, Edited__c = false,
                                                            Link_to_Client_Dependency_Master__c = clientDepeMasList[0].id, Offering__c = solComp.id,
                                                            Service__c = serviceRec.id);
            oppClientDepList.add(oppclientDep);
            insert oppClientDepList;
            return clientDepeMasList;

        } Catch(DMLException e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);         
            //System.debug('E==='+e);
        }
        return null;

    }
    /**
     *  @Description : This method is used to create map of client dependancies master services
     *  @name : createClientDepMasterMap
     *  @param : List<Client_Dependencies_Master__c> clientDepMasList
     *  @return parameter - Map<id,Client_Dependencies_Master__c>
     *  @throws exception- N/A
     */
    public static Map < id, Client_Dependencies_Master__c > createClientDepMasterMap(List < Client_Dependencies_Master__c > clientDepMasList) {
        try {
            List < Client_Dependencies_Master__c > clientDepMasListOne = new List < Client_Dependencies_Master__c > ();
            Map < id, Client_Dependencies_Master__c > clientDepMasMap = new Map < id, Client_Dependencies_Master__c > ();
            for (Client_Dependencies_Master__c clientDepMas: clientDepMasList) {
                clientDepMas.category__c = UtilConstants.FACILITY;
                clientDepMas.classification__c = UtilConstants.EXTERNAL;
                clientDepMas.client_depedency__c = UtilConstants.TEST_ASSUMPTION;
                clientDepMasListOne.add(clientDepMas);
            }
            update clientDepMasListOne;
            for (Client_Dependencies_Master__c clientDepOne: clientDepMasListOne) {
                clientDepMasMap.put(clientDepOne.id, clientDepOne);
            }
            return clientDepMasMap;
        } Catch(Exception e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);         
            //System.debug('E==='+e);
        }
        return null;
    }


    /**
     *  @Description : This method is used to get the opportunities 
     *  @name : getOpportunity
     *  @param : NA
     *  @return parameter - Opportunity 
     *  @throws exception- N/A
     */
    public static Opportunity getOpportunity() {
        try {
            Opportunity opp = new Opportunity();
            Operating_Groups_Master__c oppOperatingGrup = createOperatingGroup(UtilConstants.INDIA);
            opp.OperatingGroup__c = oppOperatingGrup.id;
            opp.name = UtilConstants.TEST_OPP;
            opp.Geo_Area__c = UTIL_Constants.AsiaPacific;
            opp.Reporting_Status__c = UtilConstants.UNQUALIFIED;
            opp.StageName = UtilConstants.OA;
            opp.Risk_Level__c = UtilConstants.LOW;
            opp.SAP_OM_Id_Dev__c = UtilConstants.SAPIDDEV;
            opp.SAP_OM_ID__c = UtilConstants.SAPOMID;
            opp.CloseDate = date.newInstance(2001, 3, 21);
            insert opp;
            return opp;
        } Catch(DMLException e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);         
            //System.debug('E==='+e);
        }
        return null;
    }
    /**
     *  @Description : This method is used to get the opportunity teams
     *  @name : getOpportunity_Teams
     *  @param : NA
     *  @return parameter - Opportunity Teams
     *  @throws exception- N/A
     */
    public static Opportunity_Teams__c getOpportunity_Teams() {
        try {
            Opportunity_Teams__c oppTeam = new Opportunity_Teams__c();
            Opportunity opp = getOpportunity();
            oppTeam.Role__c = UserInfo.getUserRoleId();
            oppTeam.Opportunity_Team_Member__c = UserInfo.getUserId();
            oppTeam.Opportunity__C = opp.id;
            insert oppTeam;
            return oppTeam;
        } Catch(Exception e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);         
            //System.debug('E==='+e);
        }
        return null;
    }

    /**
     *  @Description : This method is used to get the offering master details
     *  @name : getOffering
     *  @param : NA
     *  @return parameter - Offering Master
     *  @throws exception- N/A
     */
    public static Offering_Master__c getOffering() {
        try {
            Offering_Master__c off = new Offering_Master__c();
            off.name = UtilConstants.TEST_OFFER;
            off.offering_description__c = UtilConstants.NEW_VAR;
            off.flywheel_non_flywheel__c = UtilConstants.ER;
            insert off;
            return off;
        } Catch(DMLException e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);         
            //System.debug('E==='+e);
        }
        return null;
    }

    /**
     *  @Description : This method is used to get the Solution scope details
     *  @name : getSolutionCompforVF
     *  @param : Integer count
     *  @return parameter - List<Solution_Scope__c>
     *  @throws exception- N/A
     */
    public static List < Solution_Scope__c > getSolutionCompforVF(Integer count) {
        try {
            List < Solution_Scope__c > solCompList = new List < Solution_Scope__c > ();
            Offering_Master__c off = getOffering();
            Solution_Scope__c newSolComp;
            Opportunity opp = getOpportunity();
            for (Integer i = 0; i < count; i++) {
                newSolComp = new Solution_Scope__c();

                newSolComp.opportunity__c = opp.id;
                newSolComp.Offering_Master__c = off.id;
                newSolComp.Active__c = true;
                newSolComp.SAP_Offering_Revenue__c = 20;
                solCompList.add(newSolComp);
            }
            insert solCompList;
            return solCompList;
        } catch (DMLException e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);         
            //System.debug('E==='+e);
        }
        return null;
    }
    /**
     *  @Description : This method is used to create the opportunity records
     *  @name : createOpportunityRecord
     *  @param : Integer count
     *  @return parameter - void
     *  @throws exception- N/A
     */
    public static void createOpportunityRecord(String oppName) {
        try{
        Operating_Groups_Master__c oppOperatingGrup = createOperatingGroup(UtilConstants.INDIA);
        Opportunity opp = new Opportunity();
        opp.Name = oppName;
        opp.Reporting_Status__c = UtilConstants.WON;
        opp.Geo_Area__c = UtilConstants.EALA;
        opp.OperatingGroup__c = oppOperatingGrup.id;
        opp.StageName = UtilConstants.TWO_B;
        opp.Risk_Level__c = UtilConstants.NORMAL;
        opp.CloseDate = System.today();

        insert opp;
        }Catch(DMLException e) {
          String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
          //ApexPages.addMessage(myMsg);

        }
    }
}