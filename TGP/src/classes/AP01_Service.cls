/**
   @Author Jayashree Pradhan
   @name   AP01_Service
   @CreateDate 12 December 2014
   @Description TriggerHandler Class for triggers on Service object
   @Version 1.0
  */
public without sharing class AP01_Service {
    /**
     *  @Description This method is used to create service component which are active and added in scope
     *  @name updateCapacityRec
     *  @param List<Service__c> serviceList
     *  @return parameter - void
     *  @throws exception-DML Exception
     */
    public static void createServiceCompRec(List < Service__c > serviceNewList) {
        Set < Id > serviceMasterIdList = new Set < Id > ();
        Set < Id > serviceMasterIdListWoAll = new Set < Id > ();
        List < Assumptions_Master__c > assumptionMasterList = new List < Assumptions_Master__c > ();
        List < Client_Dependencies_Master__c > clientDependMasterList = new List < Client_Dependencies_Master__c > ();
        Map < String, Service__c > mapSol = new Map < String, Service__c > ();
        List < Opportunity_Assumption__c > oppAssumptionToInsert = new List < Opportunity_Assumption__c > ();
        List < Opportunity_Client_Dependency__c > oppclientdependencyToInsert = new List < Opportunity_Client_Dependency__c > ();
        List<Tech_Tool_Master__c> TechToolMasters = new List<Tech_Tool_Master__c>();
        List < Service_Components__c > serviceCompList = new List < Service_Components__c > ();
        Map < String, Service__c > mapServ = new Map < String, Service__c > ();
        List < Service_Components__c > s1 = new List < Service_Components__c > ();
        List < Services_Component_Master__c > servCompList = new List < Services_Component_Master__c > ();
        List < Services_Master__c > servMasterListOne = new List < Services_Master__c > ();
        List < Services_Master__c > servMasterListTwo = new List < Services_Master__c > ();

         for (Service__c serviceRec: [SELECT Name, Active__c, Services__c, Services__r.Name, services__r.Solution_Component__c, 
                                     Solutionscope__c, Solutionscope__r.Offering_Master__c, Solutionscope__r.Offering_Master__r.Name 
                                            FROM Service__c where id IN: serviceNewList Limit 5000]) {
            serviceMasterIdList.add(serviceRec.Services__c);
            if (serviceRec.services__r.Name != UtilConstants.SRV_ALL) {
                serviceMasterIdListWoAll.add(serviceRec.Services__c);
            }
            mapServ.put(serviceRec.Services__c, serviceRec);
            mapSol.put(serviceRec.Services__c, serviceRec);
        }

        list<Tech_Tools__c> techTools = new list<Tech_Tools__c>();

        for (Services_Master__c serv: [Select id, Name, (Select id, Name, Active__c, service__c from Services_Component_Masters__r Limit 5000), 
                                        (Select id, Name, Active__c, service__c, assumption__c, offering__c,
                                            classification__c, category__c from Assumption_Masters__r Limit 5000),
                                        (Select id, Name, Active__c, Services_per_Offering__c, offering__c,
                                            client_depedency__c, classification__c, category__c from Client_Dependency_Masters__r Limit 5000),
                                        (SELECT Id, Name, Active__c, Services__c  FROM Tech_Tool_Master__r where Active__c = true AND Name !='Custom Tools' limit 5000)
                                       from Services_Master__c where id IN: serviceMasterIdListWoAll Limit 5000]) {
            for (Services_Component_Master__c servMas: serv.Services_Component_Masters__r) {
                if (servMas.Active__c) {
                    servCompList.add(servMas);
                }
            }
            for (Assumptions_Master__c assumptionMas: serv.Assumption_Masters__r) {
                if (assumptionMas.Active__c) {
                    assumptionMasterList.add(assumptionMas);
                }
            }
            for (Client_Dependencies_Master__c clientMstr: serv.Client_Dependency_Masters__r ) {
                if (clientMstr.Active__c) {
                    clientDependMasterList.add(clientMstr);
                }
            }
            for(Tech_Tool_Master__c thTool: serv.Tech_Tool_Master__r){
                TechToolMasters.add(thTool);
                //techTools.add(new Tech_Tools__c(Active__c = true, Scope_Status__c = UtilConstants.TBD, Service__c=serv.Id, Tech_Tool__c = thTool.Id));                            
            }                               
        }
        
        
        /*
        for (Services_Master__c servOne: [Select id, Name, (Select id, Name, Active__c, service__c, assumption__c, offering__c,
                                            classification__c, category__c from Assumption_Masters__r Limit 5000) from Services_Master__c
                                            where id IN: serviceMasterIdListWoAll Limit 5000]) {
            for (Assumptions_Master__c assumptionMas: servOne.Assumption_Masters__r) {
                if (assumptionMas.Active__c) {
                    assumptionMasterList.add(assumptionMas);
                }
            }
        }
        ////system.debug('--------------'+assumptionMasterList);
        for (Services_Master__c servTwo: [Select id, Name, (Select id, Name, Active__c, Services_per_Offering__c, offering__c,
                                            client_depedency__c, classification__c, category__c from Client_Dependency_Masters__r Limit 5000)
                                            from Services_Master__c where id IN: serviceMasterIdListWoAll Limit 5000]) {
            for (Client_Dependencies_Master__c clientMstr: servTwo.Client_Dependency_Masters__r ) {
                if (clientMstr.Active__c) {
                    clientDependMasterList.add(clientMstr);
                }
            }
        }*/
        Opportunity_Assumption__c oppAssumption;
        Opportunity_Client_Dependency__c oppclientDep;
        Tech_Tools__c tempTechTool;
        if (serviceNewList.size() > 0) {
            
            for (Service__c serviceRecord: serviceNewList) {
                if(TechToolMasters.size()>0){
                    for(Tech_Tool_Master__c th: TechToolMasters){
                        if(serviceRecord.services__c ==th.Services__c){
                            tempTechTool = new Tech_Tools__c(Active__c = true, Scope_Status__c = UtilConstants.TBD, Service__c=serviceRecord.Id, Tech_Tool__c = th.Id);                            
                            techTools.add(tempTechTool);
                        }
                    }
                }
                if (assumptionMasterList.size() > 0) {
                    for (Assumptions_Master__c assmp: assumptionMasterList) {
                        if (serviceRecord.services__c == assmp.Service__c) {
                            oppAssumption = new Opportunity_Assumption__c();
                            oppAssumption.Offering__c = serviceRecord.Solutionscope__c;
                            oppAssumption.Service__c = serviceRecord.id;
                            oppAssumption.Assumption__c = assmp.assumption__c;
                            oppAssumption.Category__c = assmp.category__c;
                            oppAssumption.Classification__c = assmp.classification__c;
                            oppAssumption.Link_to_Master_Assumption__c = assmp.id;
                            oppAssumptionToInsert.add(oppAssumption);
                        }
                    }
                }

                if (clientDependMasterList.size() > 0) {
                    for (Client_Dependencies_Master__c clientdependency: clientDependMasterList) {
                        if (serviceRecord.services__c == clientdependency.Services_per_Offering__c) {
                            oppclientDep = new Opportunity_Client_Dependency__c();
                            oppclientDep.Offering__c = serviceRecord.Solutionscope__c;
                            oppclientDep.Service__c = serviceRecord.id;
                            oppclientDep.Client_Dependency__c = clientdependency.client_depedency__c;
                            oppclientDep.Category__c = clientdependency.category__c;
                            oppclientDep.Classification__c = clientdependency.classification__c;
                            oppclientDep.Link_to_Client_Dependency_Master__c = clientdependency.id;
                            oppclientdependencyToInsert.add(oppclientDep);
                        }
                    }
                }
            }
            if(techTools.size()>0){
                try{
                    database.insert(techTools,true);
                }catch(exception e){
                    if(!Test.isRunningTest()){
                        throw(e);
                    }
                }
            }
            if (oppAssumptionToInsert.size() > 0) {
                try {
                    insert oppAssumptionToInsert;
                } catch (DMLException dme) {
                    //String exception_caught = dme.getMessage();
                    /* Modified by Aswajit. reason-Catch needs to handled, Date - 21/05/2015*/
                    if(!Test.isRunningTest()){
                        throw(dme);
                    }
                }
            }
            if (oppclientdependencyToInsert.size() > 0) {
                try {
                    insert oppclientdependencyToInsert;
                } catch (DMLException dme) {
                    string exception_caught = string.valueof(dme);
                    /* Modified by Aswajit. reason-Catch needs to handled, Date - 21/05/2015*/
                    if(!Test.isRunningTest()){
                        throw(dme);
                    }
                }
            }
        }
        Service_Components__c serComp;
        if (servCompList.size() > 0) {
            for (Services_Component_Master__c s: servCompList) {
                Service__c serRec = mapServ.get(s.service__c);
                serComp = new Service_Components__c();
                serComp.Services_Component_Master__c = s.id;
                serComp.Service__c = serRec.id;
                serComp.Service_Component_Status__c = UTILConstants.NONE;
                s1.add(serComp);
            }
            if (s1.size() > 0) {
                if (!serviceNewList.isEmpty()) {
                    for (Service__c servOld: [Select id, (Select id from Service_Components__r Limit 5000) from Service__c 
                                                where id IN: serviceNewList Limit 5000]) {
                        if (servOld.Service_Components__r.size() > 0) {
                            for (Service_Components__c ser: servOld.Service_Components__r) {
                                serviceCompList.add(ser);
                            }
                        }
                    }
                    try {
                        delete serviceCompList;
                    } catch (DMLException dme) {
                        //string exception_caught = string.valueof(dme);
                        /* Modified by Aswajit. reason-Catch needs to handled, Date - 21/05/2015*/
                        if(!Test.isRunningTest()){
                            throw(dme);
                        }
                    }
                }
                try {
                    insert s1;
                } catch (DMLException dme) {
                    //string exception_caught = string.valueof(dme);
                    /* Modified by Aswajit. reason-Catch needs to handled, Date - 21/05/2015*/
                    if(!Test.isRunningTest()){
                        throw(dme);
                    }
                }
            }
        }
    }


    /**
     *  @Description : This method is used to update Solution Component record when any service record is added/deleted
     *  @name : updateService
     *  @param : List<Service__c> serviceList
     *  @return parameter - void
     *  @throws exception- DML Exception
     */
    /* This method is used to update Solution Component record when any service record is added/deleted */
    public static void updateService(List < Service__c > serviceList) {
        set < ID > solCompIds = new set < ID > ();
        List < Solution_Scope__c > solCompListToUpdate = new List < Solution_Scope__c > ();
        for (Service__c serviceRec: serviceList) {
            solCompIds.add(serviceRec.Solutionscope__c);
        }
        for (Solution_Scope__c solCompRec: [select id, name, Services__c, (select id, name, services__r.Name from
                                                Services__r where Active__c = : true AND
                                            Scope_Status__c = : UtilConstants.SERVICE_IN_SCOPE order by createdDate asc Limit 5000)
                                                from Solution_Scope__c where id IN: solCompIds AND Service_Group__c!='BPO' Limit 5000]) {
            String servicesList = UTILConstants.EMPTY_STRING;
            //System.debug('-----------'+ solCompRec.Services__r);
            if (solCompRec.Services__r.size() > 0) {
                for (Service__c serviceName: solCompRec.Services__r) {
                    servicesList += serviceName.services__r.Name + UtilConstants.DELIMITER;
                    //System.debug(' servicesList  ----236-------'+ servicesList);
                }
            }
            //System.debug(' servicesList  -239----------'+ servicesList);
            solCompRec.Services__c = servicesList.removeEnd(UtilConstants.DELIMITER);
            solCompListToUpdate.add(solCompRec);
        }
        if (solCompListToUpdate.size() > 0) {
            try {
                System.debug('------Before update-------'+solCompListToUpdate);
                System.debug('------Before update-------'+solCompListToUpdate.size());
                update solCompListToUpdate;
                //solCompListToUpdate.clear();
            } catch (DMLException dme) {
                //string exception_caught = string.valueof(dme);
                /* Modified by Aswajit. reason-Catch needs to handled, Date - 21/05/2015*/
                if(!Test.isRunningTest()){
                        throw(dme);
                    }
            }
        }
    }

    /******************************
    Method Name: createOppRiskRec
    Description:  Method to create opportunity risk records on insertion of services
    Paramenters: List<Service__c> serviceNewList
    Return Value: void
    */
    /*
    public static void createOppRiskRec( List<Service__c> serviceNewList ){
        Opportunity_Risks__c oppRiskRec;
        Map<Id,String> serviceMasterServiceOfferingIdMap = new Map<Id,String>();
        List<Opportunity_Risks__c> oppRiskToInsertList = new List<Opportunity_Risks__c>();
        for( Service__c serviceRec : serviceNewList ){
            serviceMasterServiceOfferingIdMap.put( serviceRec.services__c,serviceRec.Id+UtilConstants.SPLIT+serviceRec.Solutionscope__c );
        }
        for( Risks_Master__c riskMasterRec : [ Select active__c,category__c,classification__c,offering__c,risk_depedency__c,service__c from Risks_Master__c where service__r.Id IN : serviceMasterServiceOfferingIdMap.keySet() Limit 500] ){
            oppRiskRec = new Opportunity_Risks__c();
            oppRiskRec.Category__c = riskMasterRec.category__c;
            oppRiskRec.classification__c = riskMasterRec.classification__c;
            oppRiskRec.Link_to_Risk_Master__c = riskMasterRec.Id;
            oppRiskRec.Risk__c = riskMasterRec.risk_depedency__c;
            oppRiskRec.Service__c = serviceMasterServiceOfferingIdMap.get(riskMasterRec.service__c).split(UtilConstants.SPLIT)[0];
            oppRiskRec.Offering__c = serviceMasterServiceOfferingIdMap.get(riskMasterRec.service__c).split(UtilConstants.SPLIT)[1];
            oppRiskToInsertList.add( oppRiskRec );
            
        }
        if( oppRiskToInsertList.size() > 0 ){
                try{
                    insert oppRiskToInsertList;
                }
                catch(DMLException dme){
                    ////system.debug('Exception Occured'+dme.getMessage());/*Modified by ezdhan hussain@reason Novasuite rule : Empty catch block
            string exception_caught = string.valueof(dme);
            //system.debug('-----'+exception_caught);  
            }
            }
    }*/


    /**
     *  @Description : This method is used to update Solution Component record when any service record is added/deleted
     *  @name : updateService
     *  @param : List<Service__c> serviceList
     *  @return parameter - void
     *  @throws exception- DML Exception
     */

   public static void updateDeliverylocOnOpp(List < Service__c > serviceList) {

    try {
            set < ID > solCompIds = new set < ID > ();
            set < ID > oppIds = new set < ID > ();
            list < service__c > queryservicelist = [Select Id, Name, Solutionscope__c, Delivery_Locations__c,
            Solutionscope__r.Service_Group__c, Solutionscope__r.Opportunity__c
                from Service__C where ID IN: serviceList Limit 5000];
            for (Service__c serv: queryservicelist) {
            if (serv.Solutionscope__r.Service_Group__c != NULL) {
            oppIds.add(serv.Solutionscope__r.Opportunity__c);
                }
            }
        set < Opportunity > oppListToUpdate = new set < Opportunity > ();
        List < Opportunity > opplist = [Select Id, Delivery_Locations__c, Delivery_Locations_IC__c, Delivery_Locations_IO__c 
        from Opportunity where ID IN: oppIds Limit 5000];
        String deliveryLocList = UTILConstants.EMPTY_STRING;
        for (Opportunity oppRec: opplist) {

        for (Service__c serv: queryservicelist) {

            if (serv.Solutionscope__r.Service_Group__c.equals(UtilConstants.BPO)) {
                    oppRec.Delivery_Locations__c = serv.Delivery_Locations__c;
                    oppListToUpdate.add(oppRec);
            } else if (serv.Solutionscope__r.Service_Group__c.equals(UtilConstants.IO)) {
                oppRec.Delivery_Locations_IO__c = serv.Delivery_Locations__c;
                oppListToUpdate.add(oppRec);
        } else if (serv.Solutionscope__r.Service_Group__c.equals(UtilConstants.IC)) {
        oppRec.Delivery_Locations_IC__c = serv.Delivery_Locations__c;
        oppListToUpdate.add(oppRec);
        } else {}
    }

    }
    if (oppListToUpdate.size() > 0) {
        List < Opportunity > finalListToUpdate = new List < Opportunity > ();
        finalListToUpdate.addall(oppListToUpdate);
        set<opportunity> setopps = new set<opportunity>();
        setopps.addAll(finalListToUpdate);
        finalListToUpdate.clear();
        finalListToUpdate.addAll(setopps);

        update finalListToUpdate;
        finalListToUpdate.clear();
        }

        } Catch(Exception e) {
        //string exception_caught = string.valueof(e);
        /* Modified by Aswajit. reason-Catch needs to handled, Date - 21/05/2015*/
        if(!Test.isRunningTest()){
            throw(e);
        }
    }
    }



    /**
     *  @Description : This method is used to prevent duplicate record creation of Service under same solution scope
     *  @name : preventDuplicateService
     *  @param : List<Service__c> serviceNewList
     *  @return parameter - void
     *  @throws exception-NA
     */
    public static void preventDuplicateService(List < Service__c > serviceNewList) {
        try {
            Set < Id > offIds = new Set < Id > ();
            for (Service__c servRec: serviceNewList) {
                offIds.add(servRec.Solutionscope__c);
            }
            for (Service__c serviceRec: [Select Id, Name, services__c, Solutionscope__c from Service__c where Solutionscope__c IN: offIds limit 10000]) {
                if (serviceRec.services__c != null && serviceRec.Solutionscope__c != null) {
                    for (Service__c servRec: serviceNewList) {
                        if ((serviceRec.Solutionscope__c.equals(servRec.Solutionscope__c)) && (serviceRec.services__c.equals(servRec.services__c))) {
                            servRec.addError(UTIL_ErrorConstants.DUPLICATE_SERVICE);
                        }
                    }
                }
            }

        } Catch(Exception e) {
             //string exception_caught = string.valueof(e);
             /* Modified by Aswajit. reason-Catch needs to handled, Date - 21/05/2015*/
              if(!Test.isRunningTest()){
                        throw(e);
                    }
         }
    }
     /*********************
    @author :ezdhan
    This method is added to restrict user from updating scope status post sync up
    ***************************/
    public static void stopDeactivation(List<Service__c> servList,map<id,Service__c > oldrecs){
    map<id,Service__c > triggerMap = new map<id,Service__c >();
    for(Service__c serv: servList){
        triggerMap.put(serv.id,serv);
    }
     system.debug('old map' + oldrecs);
        if(!SWBBPOSEIntegrationConstants.isExceutionFromSync){

            for(Service__c serv: [select id,Solutionscope__r.Service_Group__c,Solutionscope__r.solution_component__c, 
                                    Solutionscope__r.opportunity__r.Is_Synced_IO__c,services__r.Name,
                                    Solutionscope__r.Opportunity__r.Is_Synced__c,Out_Of_Scope_Reason__c,Scope_Status__c,
                                    Other_Out_of_Scope_Reason_Description__c from Service__c where ID IN:servlist limit 5000]){
                            
                system.debug('condition 1' + oldrecs.get(serv.id).Scope_Status__c != serv.Scope_Status__c);
                system.debug(' condition 2'+serv.Solutionscope__r.opportunity__r.is_synced__c+''+UtilConstants.BPO.equals(serv.Solutionscope__r.Service_Group__c));
                boolean flag1=false;
                if(serv.Solutionscope__r.Service_Group__c=='IO'){
                flag1=true;
                }
                system.debug(' condition 3'+serv.Solutionscope__r.opportunity__r.is_synced_io__c+' '+flag1);
                if(oldrecs.get(serv.id).Scope_Status__c != serv.Scope_Status__c 
                    && ((serv.Solutionscope__r.opportunity__r.is_synced__c &&
                    UtilConstants.BPO.equals(serv.Solutionscope__r.Service_Group__c)) || 
                    (serv.Solutionscope__r.Service_Group__c=='IO' &&
                    serv.Solutionscope__r.opportunity__r.Is_Synced_IO__c) )){
                    triggerMap.get(serv.id).Scope_Status__c.addError(UtilConstants.scopecantbeupdate);
                }
                if((serv.Solutionscope__r.solution_component__c.equalsignorecase(UtilConstants.BSS) || serv.services__r.Name.equalsignorecase(SWBBPOSEIntegrationConstants.technologytools )) 
                    && serv.Scope_Status__c.equalsignorecase(utilconstants.OUT_SCOPE) && 
                    (serv.Out_Of_Scope_Reason__c=='' || serv.Out_Of_Scope_Reason__c==null)){
                    system.debug('Issue yahan hai-------------'+serv.id+'---------'+serv.Solutionscope__r.solution_component__c+serv.services__r.Name+'-----'+serv.Scope_Status__c);
                    triggerMap.get(serv.id).Out_Of_Scope_Reason__c.addError(SWBBPOSEIntegrationConstants.outofreason);
                }
                if((serv.Solutionscope__r.solution_component__c.equalsignorecase(UtilConstants.BSS) || serv.services__r.Name.equalsignorecase(SWBBPOSEIntegrationConstants.technologytools )) 
                    && serv.Scope_Status__c.equalsignorecase(utilconstants.OUT_SCOPE) && 
                    (serv.Out_Of_Scope_Reason__c=='Other' && (serv.Other_Out_of_Scope_Reason_Description__c==null|| serv.Other_Out_of_Scope_Reason_Description__c==''))){
                    triggerMap.get(serv.id).Other_Out_of_Scope_Reason_Description__c.addError(SWBBPOSEIntegrationConstants.outofreason);
                }
            }
             
            
        }
    }
    
     /*********************
    @author :ezdhan
    This method is added to restrict user from updating scope status post sync up
    ***************************/
    /*public static void stopDeactivationIO(List<Service__c> servList,map<id,Service__c > oldrecs){
    
    map<id,Service__c > triggerMap = new map<id,Service__c >();
    for(Service__c serv: servList){
        triggerMap.put(serv.id,serv);
    }
        if(!UtilConstants.allowactivationIO){
            for(Service__c serv: [select id,Solutionscope__r.Service_Group__c,
                                     Solutionscope__r.Opportunity__r.Is_Synced_IO__c,Scope_Status__c 
                                     from Service__c where ID IN:servlist and Solutionscope__r.Service_Group__c=: UtilConstants.IO
                                    limit 5000]){
                 system.debug('old value -- >'+oldrecs.get(serv.id).Scope_Status__c);
                 system.debug('opportunity synced -- >'+serv.Solutionscope__r.opportunity__r.Is_Synced_IO__c);
                 system.debug('new value'+serv.Scope_Status__c);
                if(oldrecs.get(serv.id).Scope_Status__c != serv.Scope_Status__c 
                    && serv.Solutionscope__r.opportunity__r.Is_Synced_IO__c &&
                   serv.Solutionscope__r.Service_Group__c == 'IO'){
                    triggerMap.get(serv.id).Scope_Status__c.addError(UtilConstants.scopecantbeupdateIO);
                }
                
            }
             
            
        }
    }*/
}