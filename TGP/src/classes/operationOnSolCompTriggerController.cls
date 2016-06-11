/**
   @Author      : Komal Priya
   @name        : operationOnSolComponentTriggerController
   @CreateDate  : 22 December 2014
   @Description : TriggerHandler Class for triggers on Solution Comment object
   @Version     : 1.0
  */
public without sharing class operationOnSolCompTriggerController {
    // Flag to prevent Unnecessary triggers on Opportunity. 
    public static boolean preventUpdateOnOpportunity = false;
    public static final String OFFERING_NAME = UtilConstants.S_AND_P;
    public static String SEPERATOR = UtilConstants.SEMICOLON_STRING;
     /**
     *  @Description          : This method is used to update offerings of opportunity record when any solution component record is added
     *  @name                 : updateOpportunityRecords
     *  @param                : List<Opportunity_Comments__c> commentsNewList
     *  @return parameter     :  void
     *  @throws exception     : DML Exception
     */

    public static void updateOffOnOpp(List < Solution_Scope__c > solComponentsList, string trgNm) {
        set < ID > oppIds = new set < ID > ();
        List < Opportunity > oppListToUpdateBPO = new List < Opportunity > ();
        //List < Opportunity > oppListToUpdateIO = new List < Opportunity > ();
        //List < Opportunity > oppListToUpdateIC = new List < Opportunity > ();
        for (Solution_Scope__c solComponrntsRec: solComponentsList) {
            oppIds.add(solComponrntsRec.Opportunity__c);
        }
        system.debug('Opp ids size'+oppids.size()+' Opportunity ids-->'+Oppids);
        list<Opportunity> oppRecs = new list<Opportunity>();
        if(trgNm.equals('InsertTrigger')){
            oppRecs = MasterQueries.oppsAftInstTrig(oppIds);
            system.debug('opportunity records returned'+OppRecs);
        }else if(trgNm.equals('UpdateTrigger')){
            oppRecs = MasterQueries.oppsAftUpdTrig(oppIds);


        }
        for (Opportunity oppRec: oppRecs) {
            system.debug('solution scopes size'+oppRec.Solution_Components__r.size());
            String offListBPO = UtilCOnstants.EMPTY_STRING;
            String offListIO = UtilCOnstants.EMPTY_STRING;
            String offListIC = UtilCOnstants.EMPTY_STRING;
            if (oppRec.Solution_Components__r.size() > 0) {
                for (Solution_Scope__c solComponentRec: oppRec.Solution_Components__r) {
                    //offList += solComponentRec.Offering_Master__r.name + ';';
                    System.debug('************************************'+solComponentRec.Solution_Component__c);
                    if (solComponentRec.Solution_Component__c == UtilConstants.SOLCOMP_DELIVERY) {
                        if (solComponentRec.Offering_Master__r.Service_Group__c !=null && (solComponentRec.Offering_Master__r.Service_Group__c.equals(UtilCOnstants.BPO) && (solComponentRec.Offering_Master__r.name != label.offering_all) && ((trigger.isinsert && trigger.isafter) ||(trigger.isupdate && solComponentRec.Opportunity__r.is_synced__c==false) || trigger.isdelete ))) {
                            offListBPO += solComponentRec.Offering_Master__r.name + UtilCOnstants.DELIMITER;
                            System.debug('************************************'+offListBPO);

                        } else if (solComponentRec.Offering_Master__r.Service_Group__c !=null && solComponentRec.Offering_Master__r.Service_Group__c.equals(UtilCOnstants.IO)) {
                            offListIO += solComponentRec.Offering_Master__r.name + UtilCOnstants.DELIMITER;
                        } else if(solComponentRec.Offering_Master__r.Service_Group__c !=null && solComponentRec.Offering_Master__r.Service_Group__c.equals(UtilCOnstants.IC)){
                            offListIC += solComponentRec.Offering_Master__r.name + UtilCOnstants.DELIMITER;
                        }
                        else{
                            
                        }
                    }

                }

            }
            if (offListBPO != null) {
           oppRec.Off__c = offListBPO.removeEnd(UtilCOnstants.DELIMITER);
                System.debug('BPO offerings---->'+oppRec.Off__c);
               //oppListToUpdateBPO.add(oppRec);
            }
            
            if (offListIO != null) {
                oppRec.Offerings_IO__c = offListIO.removeEnd(UtilCOnstants.DELIMITER);
                //oppListToUpdateIO.add(oppRec);
            }
            if (offListIC != null) 
            {
                oppRec.Offerings_IC__c = offListIC.removeEnd(UtilCOnstants.DELIMITER);
                //oppListToUpdateBPO.add(oppRec);

            }
            oppListToUpdateBPO.add(oppRec);
        }


        try {
            //System.debug('------oppListToUpdate-----'+oppListToUpdate);
           if(oppListToUpdateBPO.size()>0){
                system.debug('BPO list----->'+oppListToUpdateBPO);
                update oppListToUpdateBPO;
           }
          /* if(oppListToUpdateIO.size()>0){
           // update oppListToUpdateIO;
           }
           if(oppListToUpdateIC.size()>0){
           // update oppListToUpdateIC;
           }*/

        } catch (Exception ex) {
        String ErrorMsg = ex.getMessage() + ex.getStackTraceString();
            //System.debug('-----ex-----'+ex);
        }
    }



    /**
     *  @Description          : This method is used to update primary offerings of opportunity 
     *  @name                 : updatePrimaryOffOnOpp
     *  @param                : List<Solution_Scope__c> solComponentsList
     *  @return parameter     :  void
     *  @throws exception     : DML Exception
     */

    public static void updatePrimaryOffOnOpp(List < Solution_Scope__c > solComponentsList) {
       set < ID > oppIds = new set < ID > ();
        system.debug('update primary off method invoked'+trigger.isinsert);
        map<id,Opportunity > oppListToUpdate = new map<id,Opportunity > ();
        map<id,Opportunity > oppListToUpdateIO = new map<id,Opportunity > ();
        map<id,Opportunity > oppListToUpdateIC = new map<id,Opportunity > ();
        for (Solution_Scope__c solComponrntsRec: solComponentsList) {
            oppIds.add(solComponrntsRec.Opportunity__c);
        }
        boolean isinsert = false;
        if(trigger.isinsert !=null ){
            isinsert = true;
        }
       if(isinsert){
       try {
            for (Opportunity oppRec: [select id, name, Off__c, Pri_Off__c, Primary_Offering_Revenue_SAP__c, (select id, SAP_Offering_Revenue__c, name, Offering_Master__c, Offering_Master__r.name, Opportunity__c FROM Solution_Components__r where Active__c = : true AND service_group__c='BPO' AND Offering_Master__r.name !=:label.offering_all
            order by SAP_Offering_Revenue__c desc limit 1) FROM Opportunity where id IN: oppIds LIMIT 500]) {
                    system.debug('I Am IN'+oppRec);
               if (oppRec.Solution_Components__r.size() > 0) {
                    for (Solution_Scope__c solComponentRec: oppRec.Solution_Components__r) {
                        oppRec.Pri_Off__c = solComponentRec.id;
                        system.debug('update primary off method invoked'+oppRec.Pri_Off__c);
                        oppListToUpdate.put(oppRec.id,oppRec);
                    }
                }
            }
            if(oppListToUpdate.values().size() >0){
                update oppListToUpdate.values();
            }
            for(Opportunity oppRec: [select id,Primary_IO_Offering_name__c, (select id, SAP_Offering_Revenue__c,Offering_Master__r.name FROM Solution_Components__r where Active__c = : true AND service_group__c='IO' order by SAP_Offering_Revenue__c desc limit 1) FROM Opportunity where id IN: oppIds LIMIT 5000]){
                if (oppRec.Solution_Components__r.size() > 0) {
                    for (Solution_Scope__c solComponentRec: oppRec.Solution_Components__r) {
                        oppRec.Primary_IO_Offering_name__c = solComponentRec.offering_master__r.name;
                        system.debug('update primary off method invoked'+oppRec.Primary_IO_Offering_name__c);
                      oppListToUpdateIO.put(oppRec.id,oppRec);
                    }
                }   
            }
            if(oppListToUpdateIO.values().size() > 0){
                update oppListToUpdateIO.values();
            }
            for(Opportunity oppRec: [select id,Primary_IO_Offering_name__c, (select id, SAP_Offering_Revenue__c,Offering_Master__r.name FROM Solution_Components__r where Active__c = : true AND service_group__c='IC' order by SAP_Offering_Revenue__c desc limit 1) FROM Opportunity where id IN: oppIds LIMIT 5000]){
                if (oppRec.Solution_Components__r.size() > 0) {
                    for (Solution_Scope__c solComponentRec: oppRec.Solution_Components__r) {
                        oppRec.Primary_IC_Offering_name__c = solComponentRec.offering_master__r.name;
                        system.debug('update primary off method invoked'+oppRec.Primary_IC_Offering_name__c);
                        oppListToUpdateIC.put(oppRec.id,oppRec);
                    }
                }   
            }
            if(oppListToUpdateIC.values().size() > 0){
                update oppListToUpdateIC.values();
            }
        }
        catch (Exception ex) {
            String ErrorMsg = ex.getMessage() + ex.getStackTraceString();
            //System.debug('-----ex-----'+ex);            
        }
     }
    }
    /**
     *  @Description          : This method is used to create child records of offering
     *  @name                 : createChildRecsOfSolComp
     *  @param                : List<Solution_Scope__c> solCompList
     *  @return parameter     : void
     *  @throws exception     : DML Exception
     */




    public static void createChildRecsOfSolComp(List < Solution_Scope__c > solCompList) {
        Set < Id > offMasterIds = new Set < Id > ();
        List < Service__c > servicelist = new List < Service__c > ();
        List < Assumptions_Master__c > assumptionMasterList = new List < Assumptions_Master__c > ();
        List < Client_Dependencies_Master__c > clientDependencyMasterList = new List < Client_Dependencies_Master__c > ();
        List < Opportunity_Assumption__c > oppAssumptionListToInsert = new List < Opportunity_Assumption__c > ();
        List < Opportunity_Client_Dependency__c > oppClientListToInsert = new List < Opportunity_Client_Dependency__c > ();
        Map < Id, Solution_Scope__c > offMasterSolCompMap = new Map < Id, Solution_Scope__c > ();
       // List < Risks_Master__c > riskMasterList = new List < Risks_Master__c > ();
       // List < Opportunity_Risks__c > oppRiskToInsertList = new List < Opportunity_Risks__c > ();
        for (Solution_Scope__c solCompRec: solCompList) {
            offMasterIds.add(solCompRec.Offering_Master__c);
        }
        List < Offering_Master__c > offMasterList = [Select id, Name, (Select id, Name, offering__c
                                                        FROM Services_Masters__r
                                                        WHERE Name = : label.offering_all and Active__c = : true limit 1)
                                                        FROM Offering_Master__c where id In: offMasterIds limit 1000];
        Set < Id > serviceMasterIds = new Set < Id > ();
        if (solCompList.size() > 0) {
            for (Solution_Scope__c solCompRec: solCompList) {
                for (Offering_Master__c offMaster: offMasterList) {
                    if (offMaster.Services_Masters__r.size() > 0) {
                        for (Services_Master__c serviceMRec: offMaster.Services_Masters__r) {
                            Service__c serviceRecord = new Service__c();
                            serviceRecord.services__c = serviceMRec.id;
                            //!!serviceRecord.Solution_Component__c = solCompRec.id;
                            servicelist.add(serviceRecord);
                            serviceMasterIds.add(serviceMRec.Id);



                        }
                    }
                    offMasterSolCompMap.put(solCompRec.Offering_Master__c, solCompRec);
                }


            }
        }


        assumptionMasterList = [Select Id, Name, Active__c, assumption__c, category__c, classification__c, offering__c, Service__c FROM Assumptions_Master__c WHERE offering__c IN: offMasterList and service__c In: serviceMasterIds AND Active__c = : true LIMIT 5000];


        //Updated from Id to List of ids




        clientDependencyMasterList = [Select Id, Name, Active__c, client_depedency__c, category__c, classification__c, offering__c, Services_per_Offering__c FROM Client_Dependencies_Master__c WHERE offering__c IN: offMasterList and Services_per_Offering__c IN: serviceMasterIds AND Active__c = : true LIMIT 5000];




        //Updated from Id to List of ids




       /* riskMasterList = [Select Id, Name, Active__c, category__c, service__r.offering__c, classification__c, offering__c, risk_depedency__c,Service__c, (Select Id, Name, Active__c, category__c, classification__c, offering__c, Service__c from Opportunity_Risks__r) from Risks_Master__c where(offering__c IN: offMasterList and service__c IN: serviceMasterIds) and Active__c = : true LIMIT 5000];


        if (riskMasterList.size() > 0) {
            Opportunity_Risks__c oppRisk;
            //System.debug('*******************map'+offMasterSolCompMap);
            for (Risks_Master__c riskMRec: riskMasterList) {
                //System.debug('*********************'+riskMRec+'==='+riskMRec.offering__c);
                oppRisk = new Opportunity_Risks__c();
                oppRisk.Category__c = riskMRec.category__c;
                oppRisk.Classification__c = riskMRec.Classification__c;
                oppRisk.Link_to_Risk_Master__c = riskMRec.Id;
                oppRisk.Offering__c = offMasterSolCompMap.get(riskMRec.offering__c).Id;
                oppRisk.Risk__c = riskMRec.risk_depedency__c;
                oppRiskToInsertList.add(oppRisk);
            }




        }
        if (oppRiskToInsertList.size() > 0) {
            try {




                insert oppRiskToInsertList;
            } catch (DMLException dme) {
           String ErrorMsg = dme.getMessage() + dme.getStackTraceString();
                //System.debug('Exception Occured'+dme.getMessage()); 
            }
        }
        */
    /**** added by jyotsna end*/
    if (solCompList.size() > 0) {
            for (Solution_Scope__c solCompRec: solCompList) {
                if (assumptionMasterList.size() > 0) {
                    for (Assumptions_Master__c asmp: assumptionMasterList) {
                        if (solCompRec.Solution_Component__c.equalsIgnoreCase(UtilConstants.SOLCOMP_DELIVERY)) {
                            Opportunity_Assumption__c oppAssumptionRec = new Opportunity_Assumption__c();
                            oppAssumptionRec.Offering__c = solCompRec.id;
                            oppAssumptionRec.Classification__c = asmp.classification__c;
                            oppAssumptionRec.Category__c = asmp.category__c;
                            oppAssumptionRec.Assumption__c = asmp.assumption__c;
                            oppAssumptionRec.Link_to_Master_Assumption__c = asmp.id;
                            oppAssumptionListToInsert.add(oppAssumptionRec);
                        }
                    }

                }
                if (clientDependencyMasterList.size() > 0) {
                    for (Client_Dependencies_Master__c clientdepe: clientDependencyMasterList) {
                        if (solCompRec.Solution_Component__c.equalsIgnoreCase(UtilConstants.SOLCOMP_DELIVERY)) {
                            Opportunity_Client_Dependency__c oppClientDependency = new Opportunity_Client_Dependency__c();
                            oppClientDependency.Offering__c = solCompRec.id;
                            oppClientDependency.Classification__c = clientdepe.classification__c;
                            oppClientDependency.Category__c = clientdepe.category__c;
                            oppClientDependency.Client_Dependency__c = clientdepe.client_depedency__c;
                            oppClientDependency.Link_to_Client_Dependency_Master__c = clientdepe.id;
                            oppClientListToInsert.add(oppClientDependency);
                        }
                    }
                }
            }
            if (oppAssumptionListToInsert.size() > 0) {
                try {
                    insert oppAssumptionListToInsert;
                } catch (DMLException dme) {
                String ErrorMsg = dme.getMessage() + dme.getStackTraceString();
                    //System.debug('Exception Occured'+dme.getMessage()); 
                }
            }

            if (oppClientListToInsert.size() > 0) {
                try {
                    insert oppClientListToInsert;
                } catch (DMLException dme) {
                String ErrorMsg = dme.getMessage() + dme.getStackTraceString();
                    //System.debug('Exception Occured'+dme.getMessage()); 
                }

            }


        }
    }


    /**
     *  @Description : This method is used to create record of additional procurement data
     *  @name : createAddProcurementRec
     *  @param : List<Solution_Scope__c> solCompList
     *  @return parameter - void
     *  @throws exception-DML Exception
     */
    public static void createAddProcurementRec(List < Solution_Scope__c > solCompList) {
        List < Additional_Procurement_Data__c > addProcurementList = new List < Additional_Procurement_Data__c > ();
        Offering_Name__c offCustomsetting = Offering_Name__c.getInstance(OFFERING_NAME);
        if (solCompList.size() > 0) {
            for (Solution_Scope__c solRec: solCompList) {
                if (solRec.Offering_Master__c == offCustomsetting.Name__c) {
                    Additional_Procurement_Data__c AddRec = new Additional_Procurement_Data__c();
                    AddRec.Offering__c = solRec.id;
                    AddRec.Prospect_Segmentation__c = UtilConstants.NONE;
                    AddRec.Procurement_Solution_Stage__c = UtilConstants.NONE;
                    AddRec.Total_Savings_Commitment__c = 0;
                    AddRec.Addressable_Spend__c = 0;
                    AddRec.Categories_in_Scope__c = UtilConstants.NONE;
                    addProcurementList.add(AddRec);
                }
            }
            if (addProcurementList.size() > 0) {
                try {
                    insert(addProcurementList);
                } catch (DMLException dme) {
                String ErrorMsg = dme.getMessage() + dme.getStackTraceString();
                    ////System.debug('Exception Occured'+dme.getMessage()); 
                }
            }
        }
    }
    /**
     *  @Description : This method is used to prevent duplicate record creation of Offering with same costing type
     *  @name : preventduplicateOffering
     *  @param : List<Solution_Scope__c> solCompList
     *  @return parameter - void
     *  @throws exception-NA
     */
    public static void preventduplicateOffering(List < Solution_Scope__c > solCompList) {
        Set < Id > oppIds = new Set < Id > ();
        for (Solution_Scope__c solCompRec: solCompList) {
            oppIds.add(solCompRec.Opportunity__c);
        }
        for (Solution_Scope__c solComp: [Select Id, Name, Opportunity__c, Solution_Component__c, Offering_Master__c,Active__c FROM Solution_Scope__c where Opportunity__c IN: oppIds LIMIT 5000]) {


            if (solComp.Solution_Component__c != null && solComp.Offering_Master__c != null) {
                for (Solution_Scope__c solCompRec: solCompList) {
                    if ((solComp.Opportunity__c == solCompRec.Opportunity__c) && (solComp.Solution_Component__c == solCompRec.Solution_Component__c) && (solCompRec.Offering_Master__c == solComp.Offering_Master__c)) {
                        solCompRec.addError(UTIL_ErrorConstants.DUPLICATE_SOLUTION_COMPONENT);
                    }
                }
            }
        }
    }


 /**
     *  @Description : This method is used to update service group
     *  @name : updateServiceGroup
     *  @param : List<Solution_Scope__c> solCompList
     *  @return parameter - void
     *  @throws exception-NA
*/
    public static void updateServiceGroup(List < Solution_Scope__c > solCompList) {
        MasterQueries.findAllActiveOffMasters();
        //List<Offering_Master__c> offList = [Select Id,Name,Service_Group__c from Offering_Master__c where Active__c =: true];
        List<Offering_Master__c> offList = MasterQueries.allActiveOffMasters;


        //System.debug('----------------'+offList);
        List < Solution_Scope__c > solListToUpdate = new List < Solution_Scope__c > ();
        Map < Id, String > mapOfServGrup = new Map < Id, String > ();
        for (Offering_Master__c offm: offList) {
            mapOfServGrup.put(offm.id, offm.Service_Group__c);
        }
        List < Solution_Scope__c > solCompListQueried = [Select Id, Name, Service_Group__c, Offering_Master__c,Offering_Master__r.Service_Group__c,Active__c from Solution_Scope__c where Id IN: solCompList Limit 5000];
        for (Solution_Scope__c solRec: solCompListQueried) {
            solRec.Service_Group__c = mapOfServGrup.get(solRec.Offering_Master__c);
            solListToUpdate.add(solRec);
        }
        try {
            if (solListToUpdate.size() > 0) {
                Database.update(solListToUpdate);
            }
        } catch (Exception e) {
        String ErrorMsg = e.getMessage() + e.getStackTraceString();
            //System.debug(e.getMessage());
        }
    }
/**
     *  @Description : This method is used to create unique sets of supporting offerings at offering level
     *  @name : createSupportingOffs
     *  @param : List<Solution_Scope__c> solCompList
     *  @return parameter - void
     *  @throws exception-NA
 */
    public static void createSupportingOffs(List < Solution_Scope__c > solCompList) {
            MasterQueries.findAllServiceMasters_Delivery();
            List<Services_Master__c> serviceMasterList = MasterQueries.allServiceMasters_Delivery; 
           /* List<Services_Master__c> serviceMasterList = [Select Id,Name,Is_Offering_Specific_Service__c,
                                                         Service_Group__c,Solution_Component__c,offering__c,
                                                         offering__r.Name
                                                         from Services_Master__c where Active__c =: UtilConstants.BOOLEAN_TRUE AND
                                                         Is_Offering_Specific_Service__c =: UtilConstants.BOOLEAN_TRUE AND 
                                                         Solution_Component__c !=: UtilConstants.SOLCOMP_DELIVERY Limit 10000];*/
        //System.debug('-----------serviceMasterList -----------'+serviceMasterList);
        Set < String > uniqueKey = new Set < String > ();
        Set < Id > solDeliveryIds = new Set < Id > ();
        List < Solution_Scope__c > solListToInsert = new List < Solution_Scope__c > ();
        List < CS_SupportOffs__c > listCs = CS_SupportOffs__c.getAll().values();
        for (Services_Master__c serv: serviceMasterList) {
            uniqueKey.add(serv.offering__r.Name + UtilConstants.SEMICOLON_STRING + serv.Solution_Component__c + UtilConstants.SEMICOLON_STRING + serv.Service_Group__c);
        }
        //System.debug('-----------uniqueKey-----------'+serviceMasterList);
        for (Solution_Scope__c solRec: solCompList) {
            if (solRec.Solution_Component__c.equals(UtilConstants.SOLCOMP_DELIVERY)) {
                solDeliveryIds.add(solRec.id);
                }
        }
        List < Solution_Scope__c > solList = [Select Id, Offering_Master__c, Opportunity__c, Service_Group__c,Active__c,Solution_Component__c, Offering_Master__r.name from Solution_Scope__c where ID IN: solDeliveryIds Limit 5000];
 Solution_Scope__c solRecToCreate;
        for (Solution_Scope__c solRec: solList) {
            for (CS_SupportOffs__c csRec: listCs) {
                String key = solRec.Offering_Master__r.name + UtilConstants.SEMICOLON_STRING + csRec.Name + UtilConstants.SEMICOLON_STRING + solRec.Service_Group__c;
                //System.debug('-----key-----'+key);
                String allKey = label.offering_all + UtilConstants.SEMICOLON_STRING + csRec.Name + UtilConstants.SEMICOLON_STRING + solRec.Service_Group__c;
                //System.debug('-----allKey-----'+allKey);
if (uniqueKey.contains(key) || uniqueKey.contains(allKey)) {
                    solRecToCreate = new Solution_Scope__c();
                    solRecToCreate.Opportunity__c = solRec.Opportunity__c;
                    solRecToCreate.Solution_Component__c = csRec.Name;
                    solRecToCreate.Offering_Master__c = solRec.Offering_Master__c;
                    solRecToCreate.IsUserAddedOffering__c = false;
                    solListToInsert.add(solRecToCreate);
                }
            
                
        }

    }
   System.debug('-----solListToInsert-----'+solListToInsert);
     try {
       if (solListToInsert.size() > 0) {
                Database.insert(solListToInsert,true);
            }
     } 
     catch (Exception e) {
        String ErrorMsg = e.getMessage() + e.getStackTraceString();
            System.debug(e.getMessage());
     }
    }
    /**
     *  @Description : This method is used to create services on insert of solution scope
     *  @name : createServices
     *  @param : List<Solution_Scope__c> solCompList
     *  @return parameter - void
     *  @throws exception-NA
     */




    public static void createServices(List < Solution_Scope__c > solCompList) {
        //System.debug('-------------'+solCompList);
        UtilConstantsR3.runServiceTrigger=true;
        Map < Id, List < Id >> mapOfSolToServices = new Map < Id, List < Id >> ();
        Map < Id, List < Id >> mapOfSolToServicesOne = new Map < Id, List < Id >> ();
        List < Service__c > serviceToInsertList = new List < Service__c > ();
        List < Service__c > serviceToInsertListOne = new List < Service__c > ();
        List<Solution_scope__c> solList = [Select Id,Offering_Master__c,Opportunity__c,Service_Group__c,
                                          Solution_Component__c,Offering_Master__r.name,Active__c from Solution_Scope__c
                                          where ID IN : solCompList Limit 10000];
        MasterQueries.findallActiveSerMasters();
        List<Services_Master__c> serList = MasterQueries.allActiveSerMasters;



        /*List<Services_Master__c> serList = [Select Id,Name,Is_Offering_Specific_Service__c,
                                           Service_Group__c,Solution_Component__c,offering__c,
                                           offering__r.Name from Services_Master__c 
                                           where Active__c =: UtilConstants.BOOLEAN_TRUE Limit 10000];*/



        for (Solution_Scope__c solRec: solList) {
            List < Id > serIdList = new List < Id > ();
            if(solRec.Offering_Master__r.name!=null && solRec.Offering_Master__r.name.equals(label.offering_all)) {
                //System.debug('-------------'+'Inside IF');
                for (Services_Master__c serRec: serList) {
                    if (serRec.Solution_Component__c == solRec.Solution_Component__c && solRec.Service_Group__c == serRec.Service_Group__c && serRec.Is_Offering_Specific_Service__c == false && (serRec.offering__r.Name == label.offering_all)) {
                        //System.debug('------2nd If-------'+'Inside IF');
                        serIdList.add(serRec.Id);
                    }
                }
            }
            //System.debug('---------serIdList--------'+serIdList);
            mapOfSolToServices.put(solRec.id, serIdList);
        }
        //System.debug('-----mapOfSolToServices------'+mapOfSolToServices);
        for (Solution_Scope__c solRec: solList) {
            List < Id > serIdListOne = new List < Id > ();
            if (solRec.Offering_Master__r.name != label.offering_all) {
            
                for (Services_Master__c serRec: serList) {
                    /*if (serRec.Solution_Component__c == solRec.Solution_Component__c && solRec.Service_Group__c == serRec.Service_Group__c && serRec.Is_Offering_Specific_Service__c == true && ((solRec.Solution_Component__c !='Technology' && serRec.offering__r.Name == UtilConstants.ALL_HDCODE) || serRec.offering__r.Name == solRec.Offering_Master__r.name)) {
                        serIdListOne.add(serRec.Id);
                    }*/
                    system.debug('i am before if condition');
                    system.debug('service solution component'+serRec.Solution_Component__c);
                    system.debug('scope solution component'+solRec.Solution_Component__c);
                    system.debug('service Service_Group__c'+serRec.Service_Group__c);
                    system.debug('scope Service_Group__c'+solRec.Service_Group__c);
                    system.debug('service offering__r.Name'+serRec.offering__r.Name);
                    system.debug('scope Offering_Master__r'+solRec.Offering_Master__r);
                    if(serRec.Solution_Component__c == solRec.Solution_Component__c && solRec.Service_Group__c == serRec.Service_Group__c && 
                    serRec.Is_Offering_Specific_Service__c == true &&
                    ((serRec.Name.equalsIgnoreCase('Voice And Data') && serRec.offering__r.Name.equals(label.offering_all)) ||
                        (solRec.Solution_Component__c !='Technology'  && serRec.offering__r.Name.equals(label.offering_all)) || 
                        ( serRec.offering__r.Name == solRec.Offering_Master__r.name))){
                        
                        serIdListOne.add(serRec.Id);            
                    }
                }
            }
            mapOfSolToServicesOne.put(solRec.id, serIdListOne);
        }



        System.debug('-----mapOfSolToServicesOne------'+mapOfSolToServicesOne);
        Service__c ser;
        if (mapOfSolToServices.size()>0) {
            for (Id solRecid: mapOfSolToServices.keyset()) {
                List < Id > idList = new List < Id > ();
                idList = mapOfSolToServices.get(solRecid);
                for (Id solId: idList) {
                    ser = new Service__c();
                    ser.Solutionscope__c = solRecid;
                    ser.services__c = solId;
                    ser.Scope_Status__c = UtilConstants.TBD;
                    serviceToInsertList.add(ser);
                }
            }
        }
        if (mapOfSolToServicesOne.size() > 0) {
            for (Id solRecid: mapOfSolToServicesOne.keyset()) {
                List < Id > idList = new List < Id > ();
                idList = mapOfSolToServicesOne.get(solRecid);
                for (Id solId: idList) {
                    ser = new Service__c();
                    ser.Solutionscope__c = solRecid;
                    ser.services__c = solId;
                    ser.Scope_Status__c = UtilConstants.TBD;

                    serviceToInsertListOne.add(ser);
                }
            }
        }
        System.debug('-----------'+serviceToInsertList);
        system.debug('-----------'+serviceToInsertListOne);
        try {




        if (serviceToInsertList.size() > 0) {
            Database.insert(serviceToInsertList,true);
        }
        if (serviceToInsertListOne.size() > 0) {
            Database.insert(serviceToInsertListOne,true);

        }
        } 
        catch (Exception e) {
          String ErrorMsg = e.getMessage() + e.getStackTraceString();
           System.debug(e.getMessage());
            throw(e);
        }


    }

    /**
     *  @Description : This method is being used to populate the offerings in Solution Live Door related list using solution component record.
     *  @name : updateOfferingOnSolutionLive
     *  @param : List<Solution_Scope__c> solscopeList
     *  @return parameter - void
     *  @throws exception-NA
     */
   /* public static void updateOfferingOnSolutionLive(List < Solution_Scope__c > solscopeList){
    set < ID > oppIds = new set < ID > ();
        
       //
       for (Solution_Scope__c solComponrntsRec: solscopeList) {
       // 
            oppIds.add(solComponrntsRec.Opportunity__c);          
            system.debug('I am in......'+oppIds);   
       List < Solution_scope__c > solList = [Select Id, Offering_Master__c,Opportunity__r.SAP_OM_Item_Id__c, Opportunity__c,Offering_Master__r.name from Solution_Scope__c where Opportunity__r.id IN: oppIds];
       system.debug('lets check what is output' +solList);
        List < SSRT_Content_Management_Request__c > solCo= new List < SSRT_Content_Management_Request__c > ();
        
         if(solList.size()>0)
         {
         String offList1 = UtilCOnstants.EMPTY_STRING;
         String s;
         String t;
         for (Solution_Scope__c solComponentRec: solList) {

         if(solComponentRec.Opportunity__r.SAP_OM_Item_Id__c!=null){
         s=solComponentRec.Offering_Master__r.name;
         
         System.debug('I am In as set s************************************'+s);
         if(s!=t){
         t=solComponentRec.Offering_Master__r.name;
         offList1 += solComponentRec.Offering_Master__r.name + UtilCOnstants.DELIMITER;
                            System.debug('I am In As offlist************************************'+offList1);
                            s=null;
                            System.debug('I am In As s************************************'+s);
                            }
                            
         }
         }
           for (SSRT_Content_Management_Request__c ssrt:[select id,Active__c,name,Opportunity__r.Pri_Off__r.Offering_Master__r.Name,Opportunity__c from SSRT_Content_Management_Request__c  where Opportunity__r.id IN: oppIds] )
            {
             system.debug('lets check what is output' +ssrt.Opportunity__r.Pri_Off__r.Offering_Master__r.Name);
            String offList = UtilCOnstants.EMPTY_STRING;
             
                           
                             
                            offList = offList1;
                            System.debug('I am in here also************************************'+offList);
                       
                       
             if (offList != null) {
                ssrt.Service_Offeringss__c = offList.removeEnd(UtilCOnstants.DELIMITER);
                system.debug('I am in......so we are here'+ssrt.Service_Offeringss__c);
            }  
            solCo.add(ssrt);
            
         try {
            //System.debug('------oppListToUpdate-----'+oppListToUpdate);
            update solCo;
        } catch (Exception ex) {
        String ErrorMsg = ex.getMessage() + ex.getStackTraceString();
            //System.debug('-----ex-----'+ex);
        }

            }
          }  
             
         }
  } */

    /*********************
    @author :ezdhan
    This method is added to restrict user from activating/deactivating status post sync up
    ***************************/
    public static void stopDeactivation(List<Solution_Scope__c> solCompList,map<id,solution_scope__c> oldrecs){
    map<id,Solution_Scope__c> triggerMap = new map<id,Solution_Scope__c >();
    
        system.debug('UtilConstants.allowactivation--'+UtilConstants.allowactivation);
        system.debug('UtilConstants.allowstatusupdation--'+UtilConstants.allowstatusupdation);
        map<Id,solution_scope__C> solId_solscope = new map<Id,solution_scope__C>();
        for(solution_scope__C sol1: [select id,Opportunity__r.Is_Synced__c,opportunity__r.Is_Synced_IO__c,active__c,Service_Group__c 
                                    from solution_scope__c where ID IN:solcomplist limit 5000]){
            solId_solscope.put(sol1.Id,sol1);             
        }   
                
        if(!SWBBPOSEIntegrationConstants.isExceutionFromSync){

            for(Solution_Scope__c sol:solCompList){
                system.debug('active--'+sol.active__c+'--'+oldrecs.get(sol.id).active__c);
                System.debug('----chechactive'+(oldrecs.get(sol.id).active__c != sol.active__c));
                system.debug('is Synced --'+solId_solscope.get(sol.Id).opportunity__r.is_synced__c);
                system.debug('service grp--'+solId_solscope.get(sol.Id).Service_Group__c);
                if(null != solId_solscope.get(sol.Id).Service_Group__c ){
                    if(oldrecs.get(sol.id).active__c != sol.active__c &&  
                    ((solId_solscope.get(sol.Id).Service_Group__c.equals(SWBBPOSEIntegrationConstants.IO)) && 
                       solId_solscope.get(sol.Id).opportunity__r.Is_Synced_IO__c)){
                           system.debug('error');
                        sol.active__c.addError(UtilConstants.scopeactivationerror);
                 
                    }
                    if(oldrecs.get(sol.id).active__c != sol.active__c &&  
                    ((solId_solscope.get(sol.Id).Service_Group__c.equals(SWBBPOSEIntegrationConstants.BPO)) &&
                    solId_solscope.get(sol.Id).opportunity__r.Is_Synced__c)){
                           system.debug('error');
                        sol.active__c.addError(UtilConstants.scopeactivationerror);
                 
                    }
                    
                }
            }
            
          
        }
    }
}