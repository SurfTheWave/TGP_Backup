/**   @Author Ravi
   @name   MobAnalyticsUtil
   @CreateDate 15 Augest 2015
   @Description MobAnalytics Class on Service and solution scope objects
   @Version
  */
public without sharing class MobAnalyticsUtil implements Queueable{
    
    public Id Opportunityid;
    public set<Id> oldFteList=new set<Id>();
    public set<Id> newFTeList=new set<Id>();
    public set<Id> oldOcdList=new set<Id>();
    public set<Id> newOcdList=new set<Id>();
    public Map<String, String> costingData;
    public Id oldBnchId;
    public Id newBnchId;
    public set<Id> oldBnchSumId=new set<Id>();
    public set<Id> newBnchSumId=new set<Id>();
    public Opportunity newOpp= new Opportunity();
    
    
    
    //set<Id> oldFtes, set<Id> newFte, set<id>oldOcd, set<id> newOcd, map<String, String> jsonCosting, Id oldBnch, Id newBnch, 
    //set<Id>oldbnchOpp, set<Id> newBnchOpp, Opportunity__c newOpty
    
      
         /**
   *  @name : MobAnalyticsUtil
   *  @Description : constructor for execute of Queueab
   *  @param : oldFtes, newFtes, oldOcds, newOcds, jsonCosting, oldBnch, newBnch, oldbnchOpp, newBnchOpp, newOpty
   *  @return parameter - NA
   *  @throws exception- NA
   */
    public MobAnalyticsUtil(set<Id> oldFtes, set<Id> newFtes, set<id>oldOcds, set<id> newOcds, 
                            map<String, String> jsonCosting, Id oldBnch, Id newBnch, 
                            set<Id>oldbnchOpp, set<Id> newBnchOpp, Opportunity newOpty ){
        OpportunityId  = newOpty.Id;
        oldFteList = oldFtes;
        newFteList = newFtes;
        oldOcdList = oldOcds; 
        newOcdList = newOcds;
        costingData = jsonCosting;
        oldBnchId = oldBnch;
        newBnchid = newBnch;
        oldBnchSumId = oldBnchOpp;
        newBnchSumId = newBnchOpp;
        newOpp = newOpty;
        /*UtilConstants.allowactivation = true;
        UtilConstants.allowstatusupdation = true;*/
        
        
    }
     
   /**
   *  @name : execute
   *  @Description : execute method
   *  @param : context
   *  @return parameter - NA
   *  @throws exception- NA
   */
    public void execute(QueueableContext context){
        try{
            //System.debug('new Opp ' + newOpp);
        	proccessFTEOtherCost(newOpp, newOcdList, newFteList, oldOcdList, oldFteList, 
                             Costingdata,oldBnchId , newBnchId, oldBnchSumId, newBnchSumId );

        }catch(Exception e){
            
        }
   }
        
          
    /**
   *  @name : proccessFTEOtherCost
   *  @Description : method called from MobAnalyticsUtil
   *  @param : newOpp, newOcdList, newFteList, oldOcdList, oldFteList, costingData, oldBnchId, newBnchId, oldBnchSumId , newBnchSumId
   *  @return parameter - Void
   *  @throws exception- DML exception
   */
    public static void proccessFTEOtherCost(Opportunity newOpp, Set<Id> newOcdList, set<Id> newFteList, 
                                            set<Id> oldOcdList, set<Id>oldFteList, Map<String, String>costingData, 
                                            Id oldBnchId, Id newBnchId, Set<id>oldBnchSumId , Set<id>newBnchSumId){
        SWBBPOSEIntegrationConstants.isExceutionFromSync = true;
        UtilConstants.allowactivation = true;
        UtilConstants.allowstatusupdation = false;
        Id oppId = newOpp.Id;
        //System.debug('oppId' + oppid);
        Savepoint sp = Database.setSavepoint();
        Boolean isSuccess = false;
        //String oppId = newOpp.Id;
        List<Service__c> serviceList = [SELECT Id,Solutionscope__c, Name,Solutionscope__r.Opportunity__c, PM_Cost_per_FTE__c, Total_Mob_Cost_per_FTE__c,
                                        PyramidRichnessY1__c, PyramidRichnessY2__c, PyramidRichnessY3__c, 
                                        PyramidRichnessY4__c, PyramidRichnessY5__c, PyramidRichnessY6__c, 
                                        PyramidRichnessY7__c, PyramidRichnessY8__c, PyramidRichnessY9__c, 
                                        PyramidRichnessY10__c,
                                (Select Id,Mob_Totals__c,Costing_Type__c,Total_SDO_FTE__c,Mob_Sub_Category1__c,
                                 Mob_Category1__c From FTE_Details__r WHERE ID IN : newFTeList LIMIT 2000), 
                                (Select Id,Mob_Totals__c,Costing_Type__c, Mob_Category1__c,Mob_Sub_Category1__c,
                                 Cost_Type__c From Other_Cost_Details__r WHERE  ID IN : newOcdList LIMIT 2000) 
                                 FROM Service__c WHERE Solutionscope__r.Opportunity__c  = :oppId AND Solutionscope__r.Service_Group__c = :UtillContstant_Novasuite.BPO LIMIT 9000];
        Set<Id> solutionIds = new Set<Id>();
        
        List<Solution_Scope__c> solutionList = [Select Id, Name, Total_Mob_Cost_per_FTE__c, Service_Group__c ,
                                                PyramidRichnessY1__c, PyramidRichnessY2__c, PyramidRichnessY3__c, PyramidRichnessY4__c, PyramidRichnessY5__c, 
                                                PyramidRichnessY6__c, PyramidRichnessY7__c, PyramidRichnessY8__c, PyramidRichnessY9__c, PyramidRichnessY10__c,
                                            (Select Id,Mob_Totals__c,Costing_Type__c,Total_SDO_FTE__c, Mob_Category1__c,Mob_Sub_Category1__c 
                                                        From FTE_Details__r WHERE ID IN : newFTeList LIMIT 2000), 
                                            (Select Id,Mob_Totals__c,Costing_Type__c, Mob_Category1__c,Mob_Sub_Category1__c,Cost_Type__c 
                                                        From Other_Cost_Details__r WHERE ID IN  :newOcdList LIMIT 2000)
                                             FROM Solution_Scope__c WHERE Opportunity__c  = :oppId AND Service_Group__c = :UtillContstant_Novasuite.BPO LIMIT 9000];
        
        
       List<Solution_Scope__c> solutionListToUpd = new List<Solution_Scope__C>();
       List<Service__c> serviceListToUpd = new List<Service__c>();
        
        List<Opportunity_Delivery_Location__c> oppDelList= [SELECT Id, mob_payroll__c,mob_cost__c,Y1_Payroll__c, 
                                                            Y2_Payroll__c, Y3_Payroll__c, Y4_Payroll__c, Y5_Payroll__c, 
                    Y6_Payroll__c, Y7_Payroll__c, Y8_Payroll__c, Y9_Payroll__c, Y10_Payroll__c, Y1_fte__c, 
                                                            Y2_fte__c, Y3_fte__c, Y4_fte__c, Y5_fte__c, 
                    Y6_fte__c, Y7_fte__c, Y8_fte__c, Y9_fte__c, Y10_fte__c,Y1_other_Cost__c, Y2_other_Cost__c, 
                                                            Y3_other_Cost__c, Y4_other_Cost__c, Y5_other_Cost__c, 
                    Y6_other_Cost__c, Y7_other_Cost__c, Y8_other_Cost__c, Y9_other_Cost__c, Y10_other_Cost__c, 
                    Offering_Service__c, Delivery_Location__r.name,Delivery_Location__c,PyramidRichnessY10__c 
        FROM Opportunity_Delivery_Location__c WHERE Offering_Service__r.Solutionscope__r.Opportunity__C = : oppId 
                                                            AND  Offering_Service__r.Solutionscope__r.Service_Group__c = :UtillContstant_Novasuite.BPO LIMIT 5000] ; 
        
        List<Solution_scope__c> solutionsList = [SELECT Id, Name, PM_Cost_per_FTE__c, Total_Mob_Cost_per_FTE__c,PyramidRichnessY1__c, 
                     PyramidRichnessY2__c, PyramidRichnessY3__c, PyramidRichnessY4__c, PyramidRichnessY5__c, PyramidRichnessY6__c, 
                     PyramidRichnessY7__c, PyramidRichnessY8__c, PyramidRichnessY9__c, PyramidRichnessY10__c 
                    FROM Solution_scope__c WHERE Opportunity__c = :oppId];      
        
        for(Solution_Scope__c sol : solutionList){
            if(sol.FTE_Details__r.size() > 0  || sol.Other_Cost_Details__r.size() > 0 ){
                solutionListToUpd.add(sol);
                sol = proccessSolutionScope(sol.FTE_Details__r, sol.Other_Cost_Details__r, sol);
            }
        }
        
        for(Service__c srv  : serviceList){
            If(srv.FTE_Details__r.size() > 0  || srv.Other_Cost_Details__r.size() > 0  ){
                serviceListToUpd.add(srv);
                srv = proccessService(srv.FTE_Details__r, srv.Other_Cost_Details__r, srv);
             }
        }
        
        try{
 
         if(oppDelList != null && oppDelList.size() >0){
        OppDelLOcCalc.calcOppDelLoc(oppDelList,newFteList,  newOcdList, UtillContstant_Novasuite.FTE);
        OppDelLOcCalc.calcOppDelLoc(oppDelList,newFteList,  newOcdList, UtillContstant_Novasuite.OTHER_COST);
        OppDelLOcCalc.calcOppDelLoc(oppDelList,newFteList,  newOcdList, UtillContstant_Novasuite.PAY);
        PyramindRichness_V2.pyramidRichness(newFteList ,serviceListToUpd, solutionListToUpd, newOpp, oppDelList);
        }

        
        
        //FTEDetailsTriggerOperations.populateDeliveryLocationBPOSE(newFteList);
        //System.debug('Opp to Upd >> ' + newOpp  );

        
           
            if(newOpp.Id <> null){
                UtilConstants.IS_OPPTRIGGER_REQUIRED = false;
                Database.update( newOpp, true);
            }    
            
            if(solutionList.size() > 0){
                Database.update(solutionListToUpd, true);
            }
            if(serviceList.size() > 0){
                Database.update(serviceListToUpd, true);
            }
            if(oppDelList.size() > 0){
                Database.update(oppDelList, true);
            }
            
            isSuccess =true;  
            
        }
        catch(Exception e){
                Database.rollback(sp);
                ExceptionClass.logException(UtillContstant_Novasuite.MOB_ANALYTICS, 
                                            UtillContstant_Novasuite.MOB_ANALYTICS , e, 
                                            UtillContstant_Novasuite.MOB_WKB,UtillContstant_Novasuite.MOB_WKB);    
                costing_request__c cost = new costing_request__c(id=costingData.get(UtillContstant_Novasuite.VAR_ID));
                cost.Calculation__c = false;
                cost.sync_failed_at__c = UtillContstant_Novasuite.M_ANALYTICS;
                cost.Data_Cleaning_dev__c =true;
                cost.In_Progress_IO__c = costingData.get(UtillContstant_Novasuite.IN_PROGRESS); 
                update cost;
                isSuccess = false;
                sync_status__c syncstat = [select id,error__c, Calculation_failed__c 
                                           from sync_Status__C where opportunity__c=:newOpp.Id limit 1];
                syncstat.error__c =UtillContstant_Novasuite.SYNC_MSG;
                syncstat.Calculation_failed__c = true;
                update syncstat;
         }
         finally{
         set<id> datalist = new set<id>();
             if(issuccess){
                 datalist.addALL(oldFteList);
                 datalist.addALL(oldOCDList);
                 datalist.add(oldBnchId);
                 datalist.addAll(oldBnchSumId);
                 database.executeBatch(new deletebatchsync(datalist,newOpp.id,
                                                           UtillContstant_Novasuite.Com,costingData,
                                                           UtillContstant_Novasuite.BPO));
                  
             }
             else{
                 datalist.addALL(newFteList);
                 datalist.addALL(newOCDList);
                 datalist.add(newBnchId);
                 datalist.addAll(newBnchSumId);
                 database.executeBatch(new deletebatchsync(datalist,newOpp.id,UtillContstant_Novasuite.ROLL_BACK,costingData,UtillContstant_Novasuite.BPO));
             }
         }
         /*   
        if(solutionList.size() > 0){
            try{
                Database.update(solutionList, true);
            }
            catch(DMLException e){
                //throw(de); 
                ExceptionClass.logException('MobAnalyticsUtil', 'MobAnalyticsUtil' , e, 'MobWorkbench','MobWorkbench');   
                updateCostingRequestOnSyncComplete cstreq = new updateCostingRequestOnSyncComplete(oppId);
                cstreq.updateCostingRequestRecordOnFailure();
            }
        }
        if(serviceList.size() > 0){
            try{
                Database.update(serviceList, true);
            }
            catch(DMLException e){
                //throw(de);
                ExceptionClass.logException('MobAnalyticsUtil', 'MobAnalyticsUtil' , e, 'MobWorkbench','MobWorkbench');    
                //////updateCostingRequestOnSyncComplete cstreq = new updateCostingRequestOnSyncComplete(oppId);
                //updateCostingRequestRecordOnFailure();
            }
        }
        */
    }
    
   /**
   *  @name : proccessSolutionScope
   *  @Description : method called from proccessFTEOtherCost
   *  @param : inputFTEDetail,inputOtherCost,sol
   *  @return parameter - solution
   *  @throws exception- NA
   */       
    private static Solution_Scope__c  proccessSolutionScope(List<FTE_Details__c> inputFTEDetail, List<Other_Cost_Details__c> inputOtherCost, Solution_Scope__c sol){          
        if(inputFTEDEtail <> null && inputOtherCost <> null){
            double total_Mob_Cost_per_FTE = 0;
            double pM_Cost_per_FTE = 0;
            double pM_Cost_as_of_TtlMobCost = 0;
            double pM_Pyroll_HCost_Loc_as_of_TtlMobCost = 0;
            double pM_Pyrl_LCost_Loc_as_of_TtlMobCost = 0;
            double pM_DNP_Cost_as_of_TtlMobCost = 0;
            double enbl_Ppl_Cost_per_FTE = 0;
            //double Enbl_Ppl_Cost_as_of_TtlMobCost = 0;
            double enbl_Ppl_JBonus_Buyout_RCost_as_of_TMC = 0;
            double enbl_Ppl_InductionCost_as_of_TtlMobCost = 0; // first step
            double enbl_Ppl_RecruitCost_as_of_TtlMobCost = 0;
            double enbl_Ppl_RebadgingCost_as_of_TtlMobCost = 0;
            double kT_Cost_per_FTE = 0;
            //double KT_Cost_as_of_TtlMobCost = 0;
            double kT_MobPyrl_HCost_LocCost_as_of_TMC = 0;
            double kT_MobPyrl_LCost_LocCost_as_of_TMC = 0;
            double kT_Rooms_EpiplexCost_as_of_TtlMobCost = 0;
            double kT_Travel_Costs_as_of_TtlMobCost = 0;
            double pre_Go_Live_Costs = 0;
            //double Pre_Go_Live_Costs_as_of_TtlMobCost = 0;    
            double bPO_Technology_Costs_per_FTE = 0;
            //double BPO_Tech_Costs_as_of_TtlMobCost__c = 0; // second step
            double bPOTech_Pyrl_HCost_LocCost_as_of_TMC = 0;
            double bPOTech_Pyrl_LCost_LocCost_as_of_TMC = 0;
            double bPOTech_DNP_Cost_as_of_TtlMobCost = 0;
            double bPOTech_Tools_Assets_as_of_TtlMobCost = 0;
            double bPOTechVoice_Data_DNP_Cost_as_of_tota = 0;

            double bSS_Cost_per_FTE = 0;
            //double BSS_Cost_as_of_TtlMobCost = 0;
            double bSS_SM_Cost_as_of_TtlMobCost = 0;
            double bSS_EDM_Cost_as_of_TtlMobCost = 0;
            double bSS_SC_Cost_as_of_TtlMobCost = 0;
            double bSS_Tools_Cost_as_of_TtlMobCost = 0;
            double bSS_CCCostasBSS_CCCostas_ofTotal_MobCost = 0;
            double deal_PMO_Cost_per_FTE = 0;
            //double Deal_PMO_Cost_as_of_TtlMobCost = 0;
            double deal_PMO_CM_Cost_as_of_TtlMobCost = 0;
            double deal_PMO_CFM_Cost_as_of_TtlMobCost = 0;
            double deal_PMO_QA_Dir_Cost_as_of_TtlMobCost = 0;
            double deal_PMO_OADM_Cost_as_of_TtlMobCost = 0;
            double deal_PMO_Other_Cst_as_of_Total_Mob_Cost = 0;
            double cS_Costs_per_FTE = 0;
        //  double CS_Costs_as_of_TtlMobCost = 0;
            double cS_Costs_BG_CheckCost_as_of_TtlMobCost = 0;
            double cS_Costs_Tools_Assets_Cost_as_of_TtlMob = 0;
            double cS_Costs_Seat_ReqCost_as_of_TtlMobCost = 0;
            double cS_Costs_Com_JrnyCost_as_of_TtlMobCost = 0;
            double solution_Validation_Cost_per_FTE = 0;
            //double Solution_Validation_Cost_as_of_TMC = 0;
            double unit_Set_up_Cost_per_FTE = 0;
            //double Unit_Set_up_Cost_as_of_TtlMobCost__c = 0;
            double unitSetup_BayCost_as_of_TtlMobCost = 0;
            double unitSetup_DCN_Costs_as_of_TtlMobCost = 0;
            double transformation_Cost_per_FTE = 0;
            double transformation_Cost_as_of_TtlMobCost = 0;


            
            double fteTotDn1 = 0;
            double fteTotDn2 = 0;
            Integer count = 0;
            for(FTE_Details__c fte : inputFTEDEtail ){
                    count++;
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       || UtilConstants.SDO.equalsIgnoreCase(fte.Costing_Type__c)
                        || UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Costing_Type__c) 
                       || UtilConstants.BSS.equalsIgnoreCase(fte.Costing_Type__c) 
                        || UtilConstants.PMO.equalsIgnoreCase(fte.Costing_Type__c)){
                        Total_Mob_Cost_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.SDO.equalsIgnoreCase(fte.Costing_Type__c)){
                        fteTotDn1 += double.valueof(fte.Total_SDO_FTE__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.PROGRAM_MANAGEMENT.equalsIgnoreCase(fte.Mob_Category1__c)){
                        PM_Cost_per_FTE += double.valueof(fte.Mob_Totals__c);
                        PM_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);                                                              
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.PROGRAM_MANAGEMENT.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.PM_HCL.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                       PM_Pyroll_HCost_Loc_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.PROGRAM_MANAGEMENT.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.PM_LCL.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        PM_Pyrl_LCost_Loc_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(fte.Mob_Category1__c)){
                        Enbl_Ppl_Cost_per_FTE += double.valueof(fte.Mob_Totals__c); 
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(fte.Mob_Category1__c) 
                       && UtilConstants.JB_NB_RC.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        Enbl_Ppl_JBonus_Buyout_RCost_as_of_TMC += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(fte.Mob_Category1__c) 
                       && UtilConstants.INDUCTION.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        Enbl_Ppl_InductionCost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(fte.Mob_Category1__c) 
                       && UtilConstants.RECRUITMENT.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        Enbl_Ppl_RecruitCost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(fte.Mob_Category1__c) 
                       && UtilConstants.REBADGING_COST.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        Enbl_Ppl_RebadgingCost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(fte.Mob_Category1__c)){
                        KT_Cost_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.Mob_KT_Cost_HCL_NEW.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        KT_MobPyrl_HCost_LocCost_as_of_TMC += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.Mob_KT_Cost_LCL_NEW.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        KT_MobPyrl_LCost_LocCost_as_of_TMC += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.TRAINING_ROOM_EPIPLEX_CHARGES.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        KT_Rooms_EpiplexCost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(fte.Mob_Category1__c) 
                       && UtilConstants.KT_TRAVEL.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        KT_Travel_Costs_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.SDO.equalsIgnoreCase(fte.Costing_Type__c)){
                        Pre_Go_Live_Costs += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Costing_Type__c)){
                        BPO_Technology_Costs_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Mob_Category1__c) 
                       && UtilConstants.TECH_HCL.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BPOTech_Pyrl_HCost_LocCost_as_of_TMC += double.valueof(fte.Mob_Totals__c);
                        }
                    if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.TECH_LCL.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BPOTech_Pyrl_LCost_LocCost_as_of_TMC += double.valueof(fte.Mob_Totals__c);
                        }
                    if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.STANDARD_TOOL_AND_ASSETS.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BPOTech_Tools_Assets_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                        }
                    /*if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Costing_Type__c) && UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Mob_Category1__c)&& UtilConstants.VD_DNP.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BPOTechVoice_Data_DNP_Cost_as_of_tota += double.valueof(fte.Mob_Totals__c);
                        }*/
                    if(UtilConstants.BSS.equalsIgnoreCase(fte.Costing_Type__c)){
                            BSS_Cost_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.BSS.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.BSS.equalsIgnoreCase(fte.Mob_Category1__c) 
                       && UtilConstants.SERVICE_MANAGEMENT_NEW.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BSS_SM_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                        }
                    if(UtilConstants.BSS.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.BSS.equalsIgnoreCase(fte.Mob_Category1__c) 
                       && UtilConstants.BSS_EDM_NEW.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BSS_EDM_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                        }
                    if(UtilConstants.BSS.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.BSS.equalsIgnoreCase(fte.Mob_Category1__c) 
                       && UtilConstants.BSS_SC_NEW.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BSS_SC_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                        }
                    if(UtilConstants.BSS.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.BSS.equalsIgnoreCase(fte.Mob_Category1__c) 
                       && UtilConstants.BSS_Tools.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BSS_Tools_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.BSS.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.BSS.equalsIgnoreCase(fte.Mob_Category1__c) 
                       && UtilConstants.CMD_CENT.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BSS_CCCostasBSS_CCCostas_ofTotal_MobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.PMO.equalsIgnoreCase(fte.Costing_Type__c)){
                            Deal_PMO_Cost_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.PMO.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.PMO.equalsIgnoreCase(fte.Mob_Category1__c) 
                       && UtilConstants.PMO_CM.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            Deal_PMO_CM_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.PMO.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.PMO.equalsIgnoreCase(fte.Mob_Category1__c) 
                       && UtilConstants.PMO_CFM.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            Deal_PMO_CFM_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.PMO.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.PMO.equalsIgnoreCase(fte.Mob_Category1__c) 
                       && UtilConstants.PMO_QAD.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            Deal_PMO_QA_Dir_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.PMO.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.PMO.equalsIgnoreCase(fte.Mob_Category1__c) 
                       && UtilConstants.PMO_OADM.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            Deal_PMO_OADM_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.PMO.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.PMO.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.PMO_OTHER.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            Deal_PMO_Other_Cst_as_of_Total_Mob_Cost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)){
                            CS_Costs_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.OTHERS_ADDITIONAL_BACKGROUND_CHECKS_BGC.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            CS_Costs_BG_CheckCost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.OTHERS_CAPABILITY_SPECIFIC_TOOLS_AND_ASSETS.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            CS_Costs_Tools_Assets_Cost_as_of_TtlMob += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.OTHERS_SEAT_LOCKDOWN_REQUIREMENT.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            CS_Costs_Seat_ReqCost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                   if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                      && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)
                      && UtilConstants.COMMUNICATIONS.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            CS_Costs_Com_JrnyCost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.SOLUTION_VALIDATION_TRAVEL_VISA_CHARGES.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            Solution_Validation_Cost_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)
                       && (UtilConstants.UNIT_SET_UP_DCN_SETUP_COSTS.equalsIgnoreCase(fte.Mob_Sub_Category1__c) 
                           || UtilConstants.UNIT_SET_UP_ENCLOSED_BAY.equalsIgnoreCase(fte.Mob_Sub_Category1__c))){
                            Unit_Set_up_Cost_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.UNIT_SET_UP_ENCLOSED_BAY.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            UnitSetup_BayCost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.UNIT_SET_UP_DCN_SETUP_COSTS.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            UnitSetup_DCN_Costs_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.TRANSFORMATION_COST.equalsIgnoreCase(fte.Mob_Category1__c)){
                            Transformation_Cost_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                if(count == 1){
                    for(Other_Cost_Details__c ftec: inputOtherCost) {
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           || UtilConstants.SDO.equalsIgnoreCase(ftec.Costing_Type__c)
                            || UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Costing_Type__c) 
                           || UtilConstants.BSS.equalsIgnoreCase(ftec.Costing_Type__c) 
                        || UtilConstants.PMO.equalsIgnoreCase(ftec.Costing_Type__c)){
                            Total_Mob_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                            //PM_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c)){
                            PM_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.PROGRAM_MANAGEMENT.equalsIgnoreCase(ftec.Mob_Category1__c)){                                                          
                            PM_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.PROGRAM_MANAGEMENT.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.PM_HCL.equalsIgnoreCase(ftec.Mob_Sub_Category1__c) 
                           && UtilConstants.PAYROLL_COST.equalsIgnoreCase(ftec.Cost_Type__c)){
                            PM_Pyroll_HCost_Loc_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c); 
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.PROGRAM_MANAGEMENT.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.PM_LCL.equalsIgnoreCase(ftec.Mob_Sub_Category1__c) 
                           && UtilConstants.PAYROLL_COST.equalsIgnoreCase(ftec.Cost_Type__c)){
                            PM_Pyrl_LCost_Loc_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);   
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c)
                           && UtilConstants.PROGRAM_MANAGEMENT.equalsIgnoreCase(ftec.Mob_Category1__c) 
                           && UtilConstants.DNP_FULL.equalsIgnoreCase(ftec.Cost_Type__c)){
                            PM_DNP_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c); 
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(ftec.Mob_Category1__c)){
                            Enbl_Ppl_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);        
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.JB_NB_RC.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Enbl_Ppl_JBonus_Buyout_RCost_as_of_TMC += double.valueof(ftec.Mob_Totals__c);   
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(ftec.Mob_Category1__c) 
                           && UtilConstants.INDUCTION.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Enbl_Ppl_InductionCost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(ftec.Mob_Category1__c) 
                           && UtilConstants.RECRUITMENT.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Enbl_Ppl_RecruitCost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(ftec.Mob_Category1__c) 
                           && UtilConstants.REBADGING_COST.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Enbl_Ppl_RebadgingCost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(ftec.Mob_Category1__c)){
                            KT_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.Mob_KT_Cost_HCL_NEW.equalsIgnoreCase(ftec.Mob_Sub_Category1__c) 
                           && UtilConstants.PAYROLL_COST.equalsIgnoreCase(ftec.Cost_Type__c)){
                            KT_MobPyrl_HCost_LocCost_as_of_TMC += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.Mob_KT_Cost_LCL_NEW.equalsIgnoreCase(ftec.Mob_Sub_Category1__c) 
                           && UtilConstants.PAYROLL_COST.equalsIgnoreCase(ftec.Cost_Type__c)){
                            KT_MobPyrl_LCost_LocCost_as_of_TMC += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.TRAINING_ROOM_EPIPLEX_CHARGES.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            KT_Rooms_EpiplexCost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.KT_TRAVEL.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            KT_Travel_Costs_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.SDO.equalsIgnoreCase(ftec.Costing_Type__c)){
                            Pre_Go_Live_Costs += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Costing_Type__c)){
                            BPO_Technology_Costs_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.TECH_HCL.equalsIgnoreCase(ftec.Mob_Sub_Category1__c) 
                           && UtilConstants.PAYROLL_COST.equalsIgnoreCase(ftec.Cost_Type__c)){
                            BPOTech_Pyrl_HCost_LocCost_as_of_TMC += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.TECH_LCL.equalsIgnoreCase(ftec.Mob_Sub_Category1__c) && UtilConstants.PAYROLL_COST.equalsIgnoreCase(ftec.Cost_Type__c)){
                            BPOTech_Pyrl_LCost_LocCost_as_of_TMC += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.TECHNOLOGY_TOOLS_DNP.equalsIgnoreCase(ftec.Cost_Type__c)){
                            BPOTech_DNP_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.STANDARD_TOOL_AND_ASSETS.equalsIgnoreCase(ftec.Mob_Sub_Category1__c) 
                           && UtilConstants.PAYROLL_COST.equalsIgnoreCase(ftec.Cost_Type__c)){
                            BPOTech_Tools_Assets_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.VD_DNP.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            BPOTechVoice_Data_DNP_Cost_as_of_tota += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.BSS.equalsIgnoreCase(ftec.Costing_Type__c)){
                            BSS_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.BSS.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.BSS.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.SERVICE_MANAGEMENT_NEW.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            BSS_SM_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.BSS.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.BSS.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.BSS_EDM_NEW.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            BSS_EDM_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.BSS.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.BSS.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.BSS_SC_NEW.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            BSS_SC_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.BSS.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.BSS.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.BSS_Tools.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            BSS_Tools_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.BSS.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.BSS.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.CMD_CENT.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            BSS_CCCostasBSS_CCCostas_ofTotal_MobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.PMO.equalsIgnoreCase(ftec.Costing_Type__c)){
                            Deal_PMO_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.PMO.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.PMO.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.PMO_CM.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Deal_PMO_CM_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.PMO.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.PMO.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.PMO_CFM.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Deal_PMO_CFM_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.PMO.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.PMO.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.PMO_QAD.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Deal_PMO_QA_Dir_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.PMO.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.PMO.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.PMO_OADM.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Deal_PMO_OADM_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.PMO.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.PMO.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.PMO_OTHER.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Deal_PMO_Other_Cst_as_of_Total_Mob_Cost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)){
                            CS_Costs_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)&& UtilConstants.OTHERS_ADDITIONAL_BACKGROUND_CHECKS_BGC.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            CS_Costs_BG_CheckCost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c)
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.OTHERS_CAPABILITY_SPECIFIC_TOOLS_AND_ASSETS.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            CS_Costs_Tools_Assets_Cost_as_of_TtlMob += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.OTHERS_SEAT_LOCKDOWN_REQUIREMENT.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            CS_Costs_Seat_ReqCost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.COMMUNICATIONS.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            CS_Costs_Com_JrnyCost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.SOLUTION_VALIDATION_TRAVEL_VISA_CHARGES.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Solution_Validation_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && (UtilConstants.UNIT_SET_UP_DCN_SETUP_COSTS.equalsIgnoreCase(ftec.Mob_Sub_Category1__c) || UtilConstants.UNIT_SET_UP_ENCLOSED_BAY.equalsIgnoreCase(ftec.Mob_Sub_Category1__c))){
                            Unit_Set_up_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.UNIT_SET_UP_ENCLOSED_BAY.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            UnitSetup_BayCost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.UNIT_SET_UP_DCN_SETUP_COSTS.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            UnitSetup_DCN_Costs_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.TRANSFORMATION_COST.equalsIgnoreCase(ftec.Mob_Category1__c)){
                            Transformation_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                    }
                }
                if(inputFTEDEtail.size() == count){
                    sol.Total_Mob_Cost_per_FTE__c = double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(Total_Mob_Cost_per_FTE-(CS_Costs_per_FTE+Transformation_Cost_per_FTE)) / double.valueOf(fteTotDn1 ) : 0;
                    //sol.Total_Mob_Cost_per_FTE__c = double.valueOf(fteTotDn1) > 0 ? double.valueOf(Total_Mob_Cost_per_FTE) / double.valueOf(fteTotDn1 ) : 0;                                                              
                    sol.PM_Cost_per_FTE__c =  double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(PM_Cost_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.PM_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(PM_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.PM_Pyroll_HCost_Loc_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(PM_Pyroll_HCost_Loc_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.PM_Pyrl_LCost_Loc_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(PM_Pyrl_LCost_Loc_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.PM_DNP_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(PM_DNP_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Enbl_Ppl_Cost_per_FTE__c = double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(Enbl_Ppl_Cost_per_FTE) / double.valueOf(fteTotDn1 ) : 0;
                    sol.Enbl_Ppl_Cost_as_of_TtlMobCost__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Enbl_Ppl_Cost_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Enbl_Ppl_JBonus_Buyout_RCost_as_of_TMC__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Enbl_Ppl_JBonus_Buyout_RCost_as_of_TMC*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Enbl_Ppl_InductionCost_as_of_TtlMobCost__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Enbl_Ppl_InductionCost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Enbl_Ppl_RecruitCost_as_of_TtlMobCost__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Enbl_Ppl_RecruitCost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Enbl_Ppl_RebadgingCost_as_of_TtlMobCost__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Enbl_Ppl_RebadgingCost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.KT_Cost_per_FTE__c = double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(KT_Cost_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.KT_Cost_as_of_TtlMobCost__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(KT_Cost_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.KT_MobPyrl_HCost_LocCost_as_of_TMC__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(KT_MobPyrl_HCost_LocCost_as_of_TMC*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.KT_MobPyrl_LCost_LocCost_as_of_TMC__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(KT_MobPyrl_LCost_LocCost_as_of_TMC*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.KT_Rooms_EpiplexCost_as_of_TtlMobCost__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(KT_Rooms_EpiplexCost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.KT_Travel_Costs_as_of_TtlMobCost__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(KT_Travel_Costs_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Pre_Go_Live_Costs__c = double.valueOf(Pre_Go_Live_Costs);
                    sol.Pre_Go_Live_Costs_as_of_TtlMobCost__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Pre_Go_Live_Costs*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BPO_Technology_Costs_per_FTE__c =  double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(BPO_Technology_Costs_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.BPO_Tech_Costs_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BPO_Technology_Costs_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BPOTech_Pyrl_HCost_LocCost_as_of_TMC__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BPOTech_Pyrl_HCost_LocCost_as_of_TMC*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BPOTech_Pyrl_LCost_LocCost_as_of_TMC__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BPOTech_Pyrl_LCost_LocCost_as_of_TMC*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BPOTech_DNP_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BPOTech_DNP_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BPOTech_Tools_Assets_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BPOTech_Tools_Assets_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BPOTechVoice_Data_DNP_Cost_as_of_tota__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BPOTechVoice_Data_DNP_Cost_as_of_tota*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BSS_Cost_per_FTE__c =  double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(BSS_Cost_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.BSS_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BSS_Cost_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BSS_SM_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BSS_SM_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BSS_EDM_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BSS_EDM_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BSS_SC_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BSS_SC_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BSS_Tools_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BSS_Tools_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BSS_CCCostasBSS_CCCostas_ofTotal_MobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BSS_CCCostasBSS_CCCostas_ofTotal_MobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Deal_PMO_Cost_per_FTE__c =  double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(Deal_PMO_Cost_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.Deal_PMO_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Deal_PMO_Cost_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Deal_PMO_CM_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Deal_PMO_CM_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Deal_PMO_CFM_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Deal_PMO_CFM_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Deal_PMO_QA_Dir_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Deal_PMO_QA_Dir_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Deal_PMO_OADM_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Deal_PMO_OADM_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Deal_PMO_Other_Cst_as_of_Total_Mob_Cost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Deal_PMO_Other_Cst_as_of_Total_Mob_Cost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.CS_Costs_per_FTE__c =  double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(CS_Costs_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.CS_Costs_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(CS_Costs_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.CS_Costs_BG_CheckCost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(CS_Costs_BG_CheckCost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.CS_Costs_Tools_Assets_Cost_as_of_TtlMob__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(CS_Costs_Tools_Assets_Cost_as_of_TtlMob*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.CS_Costs_Seat_ReqCost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(CS_Costs_Seat_ReqCost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.CS_Costs_Com_JrnyCost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(CS_Costs_Com_JrnyCost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Solution_Validation_Cost_per_FTE__c =  double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(Solution_Validation_Cost_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.Solution_Validation_Cost_as_of_TMC__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Solution_Validation_Cost_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Unit_Set_up_Cost_per_FTE__c =  double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(Unit_Set_up_Cost_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.Unit_Set_up_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Unit_Set_up_Cost_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.UnitSetup_BayCost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(UnitSetup_BayCost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.UnitSetup_DCN_Costs_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(UnitSetup_DCN_Costs_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Transformation_Cost_per_FTE__c =  double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(Transformation_Cost_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.Transformation_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Transformation_Cost_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                }
            }
        }
    return sol;
    }
   
   /**
   *  @name : proccessService
   *  @Description : method called from proccessFTEOtherCost
   *  @param : inputFTEDetail,inputOtherCost,sol
   *  @return parameter - Service
   *  @throws exception- NA
   */       
    private static Service__c  proccessService(List<FTE_Details__c> inputFTEDetail, 
                                               List<Other_Cost_Details__c> inputOtherCost, Service__c sol){          
        if(inputFTEDEtail <> null && inputOtherCost <> null){
            double total_Mob_Cost_per_FTE = 0;
            double pM_Cost_per_FTE = 0;
            double pM_Cost_as_of_TtlMobCost = 0;
            double pM_Pyroll_HCost_Loc_as_of_TtlMobCost = 0;
            double pM_Pyrl_LCost_Loc_as_of_TtlMobCost = 0;
            double pM_DNP_Cost_as_of_TtlMobCost = 0;
            double enbl_Ppl_Cost_per_FTE = 0;
            //double Enbl_Ppl_Cost_as_of_TtlMobCost = 0;
            double enbl_Ppl_JBonus_Buyout_RCost_as_of_TMC = 0;
            double enbl_Ppl_InductionCost_as_of_TtlMobCost = 0; // first step
            double enbl_Ppl_RecruitCost_as_of_TtlMobCost = 0;
            double enbl_Ppl_RebadgingCost_as_of_TtlMobCost = 0;
            double kT_Cost_per_FTE = 0;
            //double KT_Cost_as_of_TtlMobCost = 0;
            double kT_MobPyrl_HCost_LocCost_as_of_TMC = 0;
            double kT_MobPyrl_LCost_LocCost_as_of_TMC = 0;
            double kT_Rooms_EpiplexCost_as_of_TtlMobCost = 0;
            double kT_Travel_Costs_as_of_TtlMobCost = 0;
            double pre_Go_Live_Costs = 0;
            //double Pre_Go_Live_Costs_as_of_TtlMobCost = 0;    
            double bPO_Technology_Costs_per_FTE = 0;
            //double BPO_Tech_Costs_as_of_TtlMobCost__c = 0; // second step
            double bPOTech_Pyrl_HCost_LocCost_as_of_TMC = 0;
            double bPOTech_Pyrl_LCost_LocCost_as_of_TMC = 0;
            double bPOTech_DNP_Cost_as_of_TtlMobCost = 0;
            double bPOTech_Tools_Assets_as_of_TtlMobCost = 0;
            double bPOTechVoice_Data_DNP_Cost_as_of_tota = 0;
            double bSS_Cost_per_FTE = 0;
            //double BSS_Cost_as_of_TtlMobCost = 0;
            double bSS_SM_Cost_as_of_TtlMobCost = 0;
            double bSS_EDM_Cost_as_of_TtlMobCost = 0;
            double bSS_SC_Cost_as_of_TtlMobCost = 0;
            double bSS_Tools_Cost_as_of_TtlMobCost = 0;
            double bSS_CCCostasBSS_CCCostas_ofTotal_MobCost = 0;
            double deal_PMO_Cost_per_FTE = 0;
            //double Deal_PMO_Cost_as_of_TtlMobCost = 0;
            double deal_PMO_CM_Cost_as_of_TtlMobCost = 0;
            double deal_PMO_CFM_Cost_as_of_TtlMobCost = 0;
            double deal_PMO_QA_Dir_Cost_as_of_TtlMobCost = 0;
            double deal_PMO_OADM_Cost_as_of_TtlMobCost = 0;
            double deal_PMO_Other_Cst_as_of_Total_Mob_Cost = 0;
            double cS_Costs_per_FTE = 0;
        //  double CS_Costs_as_of_TtlMobCost = 0;
            double cS_Costs_BG_CheckCost_as_of_TtlMobCost = 0;
            double cS_Costs_Tools_Assets_Cost_as_of_TtlMob = 0;
            double cS_Costs_Seat_ReqCost_as_of_TtlMobCost = 0;
            double cS_Costs_Com_JrnyCost_as_of_TtlMobCost = 0;
            double solution_Validation_Cost_per_FTE = 0;
            //double Solution_Validation_Cost_as_of_TMC = 0;
            double unit_Set_up_Cost_per_FTE = 0;
            //double Unit_Set_up_Cost_as_of_TtlMobCost__c = 0;
            double unitSetup_BayCost_as_of_TtlMobCost = 0;
            double unitSetup_DCN_Costs_as_of_TtlMobCost = 0;
            double transformation_Cost_per_FTE = 0;
            double transformation_Cost_as_of_TtlMobCost = 0;


            
            double fteTotDn1 = 0;
            double fteTotDn2 = 0;
            Integer count = 0;
            for(FTE_Details__c fte : inputFTEDEtail ){
                    count++;
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       || UtilConstants.SDO.equalsIgnoreCase(fte.Costing_Type__c)
                        || UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Costing_Type__c) 
                       || UtilConstants.BSS.equalsIgnoreCase(fte.Costing_Type__c) 
                        || UtilConstants.PMO.equalsIgnoreCase(fte.Costing_Type__c)){
                        Total_Mob_Cost_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.SDO.equalsIgnoreCase(fte.Costing_Type__c)){
                        fteTotDn1 += double.valueof(fte.Total_SDO_FTE__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.PROGRAM_MANAGEMENT.equalsIgnoreCase(fte.Mob_Category1__c)){
                        PM_Cost_per_FTE += double.valueof(fte.Mob_Totals__c);
                        PM_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);                                                              
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.PROGRAM_MANAGEMENT.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.PM_HCL.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        PM_Pyroll_HCost_Loc_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.PROGRAM_MANAGEMENT.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.PM_LCL.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        PM_Pyrl_LCost_Loc_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(fte.Mob_Category1__c)){
                        Enbl_Ppl_Cost_per_FTE += double.valueof(fte.Mob_Totals__c); 
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(fte.Mob_Category1__c) 
                       && UtilConstants.JB_NB_RC.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        Enbl_Ppl_JBonus_Buyout_RCost_as_of_TMC += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(fte.Mob_Category1__c) && UtilConstants.INDUCTION.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        Enbl_Ppl_InductionCost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(fte.Mob_Category1__c) && UtilConstants.RECRUITMENT.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        Enbl_Ppl_RecruitCost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(fte.Mob_Category1__c) && UtilConstants.REBADGING_COST.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        Enbl_Ppl_RebadgingCost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(fte.Mob_Category1__c)){
                        KT_Cost_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.Mob_KT_Cost_HCL_NEW.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        KT_MobPyrl_HCost_LocCost_as_of_TMC += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.Mob_KT_Cost_LCL_NEW.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        KT_MobPyrl_LCost_LocCost_as_of_TMC += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.TRAINING_ROOM_EPIPLEX_CHARGES.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        KT_Rooms_EpiplexCost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.KT_TRAVEL.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                        KT_Travel_Costs_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.SDO.equalsIgnoreCase(fte.Costing_Type__c)){
                        Pre_Go_Live_Costs += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Costing_Type__c)){
                        BPO_Technology_Costs_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.TECH_HCL.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BPOTech_Pyrl_HCost_LocCost_as_of_TMC += double.valueof(fte.Mob_Totals__c);
                        }
                    if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.TECH_LCL.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BPOTech_Pyrl_LCost_LocCost_as_of_TMC += double.valueof(fte.Mob_Totals__c);
                        }
                    if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.STANDARD_TOOL_AND_ASSETS.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BPOTech_Tools_Assets_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                        }
                    /*if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Costing_Type__c) && UtilConstants.TECHNOLOGY.equalsIgnoreCase(fte.Mob_Category1__c)&& UtilConstants.VD_DNP.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BPOTechVoice_Data_DNP_Cost_as_of_tota += double.valueof(fte.Mob_Totals__c);
                        }*/
                    if(UtilConstants.BSS.equalsIgnoreCase(fte.Costing_Type__c)){
                            BSS_Cost_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.BSS.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.BSS.equalsIgnoreCase(fte.Mob_Category1__c)
                       	&& UtilConstants.SERVICE_MANAGEMENT_NEW.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BSS_SM_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                        }
                    if(UtilConstants.BSS.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.BSS.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.BSS_EDM_NEW.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BSS_EDM_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                        }
                    if(UtilConstants.BSS.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.BSS.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.BSS_SC_NEW.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BSS_SC_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                        }
                    if(UtilConstants.BSS.equalsIgnoreCase(fte.Costing_Type__c) && UtilConstants.BSS.equalsIgnoreCase(fte.Mob_Category1__c)&& UtilConstants.BSS_Tools.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BSS_Tools_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.BSS.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.BSS.equalsIgnoreCase(fte.Mob_Category1__c) 
                       && UtilConstants.CMD_CENT.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            BSS_CCCostasBSS_CCCostas_ofTotal_MobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.PMO.equalsIgnoreCase(fte.Costing_Type__c)){
                            Deal_PMO_Cost_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.PMO.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.PMO.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.PMO_CM.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            Deal_PMO_CM_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.PMO.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.PMO.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.PMO_CFM.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            Deal_PMO_CFM_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.PMO.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.PMO.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.PMO_QAD.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            Deal_PMO_QA_Dir_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.PMO.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.PMO.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.PMO_OADM.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            Deal_PMO_OADM_Cost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.PMO.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.PMO.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.PMO_OTHER.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            Deal_PMO_Other_Cst_as_of_Total_Mob_Cost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)){
                            CS_Costs_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.OTHERS_ADDITIONAL_BACKGROUND_CHECKS_BGC.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            CS_Costs_BG_CheckCost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.OTHERS_CAPABILITY_SPECIFIC_TOOLS_AND_ASSETS.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            CS_Costs_Tools_Assets_Cost_as_of_TtlMob += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.OTHERS_SEAT_LOCKDOWN_REQUIREMENT.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            CS_Costs_Seat_ReqCost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.COMMUNICATIONS.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            CS_Costs_Com_JrnyCost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.SOLUTION_VALIDATION_TRAVEL_VISA_CHARGES.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            Solution_Validation_Cost_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)
                       && (UtilConstants.UNIT_SET_UP_ENCLOSED_BAY.equalsIgnoreCase(fte.Mob_Sub_Category1__c) 
                           || UtilConstants.UNIT_SET_UP_DCN_SETUP_COSTS.equalsIgnoreCase(fte.Mob_Sub_Category1__c))){
                            Unit_Set_up_Cost_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.UNIT_SET_UP_ENCLOSED_BAY.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            UnitSetup_BayCost_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.CSC.equalsIgnoreCase(fte.Mob_Category1__c)
                       && UtilConstants.UNIT_SET_UP_DCN_SETUP_COSTS.equalsIgnoreCase(fte.Mob_Sub_Category1__c)){
                            UnitSetup_DCN_Costs_as_of_TtlMobCost += double.valueof(fte.Mob_Totals__c);
                    }
                    if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(fte.Costing_Type__c) 
                       && UtilConstants.TRANSFORMATION_COST.equalsIgnoreCase(fte.Mob_Category1__c)){
                            Transformation_Cost_per_FTE += double.valueof(fte.Mob_Totals__c);
                    }
                if(count == 1){
                    for(Other_Cost_Details__c ftec: inputOtherCost) {
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           || UtilConstants.SDO.equalsIgnoreCase(ftec.Costing_Type__c)
                            || UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Costing_Type__c) 
                           || UtilConstants.BSS.equalsIgnoreCase(ftec.Costing_Type__c) 
                        || UtilConstants.PMO.equalsIgnoreCase(ftec.Costing_Type__c)){
                            Total_Mob_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                            //PM_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c)){
                            PM_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.PROGRAM_MANAGEMENT.equalsIgnoreCase(ftec.Mob_Category1__c)){                                                          
                            PM_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.PROGRAM_MANAGEMENT.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.PM_HCL.equalsIgnoreCase(ftec.Mob_Sub_Category1__c) 
                           && UtilConstants.PAYROLL_COST.equalsIgnoreCase(ftec.Cost_Type__c)){
                            PM_Pyroll_HCost_Loc_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c); 
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.PROGRAM_MANAGEMENT.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.PM_LCL.equalsIgnoreCase(ftec.Mob_Sub_Category1__c) 
                           && UtilConstants.PAYROLL_COST.equalsIgnoreCase(ftec.Cost_Type__c)){
                            PM_Pyrl_LCost_Loc_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);   
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c)
                           && UtilConstants.PROGRAM_MANAGEMENT.equalsIgnoreCase(ftec.Mob_Category1__c) 
                           && UtilConstants.DNP_FULL.equalsIgnoreCase(ftec.Cost_Type__c)){
                            PM_DNP_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c); 
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(ftec.Mob_Category1__c)){
                            Enbl_Ppl_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);        
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.JB_NB_RC.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Enbl_Ppl_JBonus_Buyout_RCost_as_of_TMC += double.valueof(ftec.Mob_Totals__c);   
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(ftec.Mob_Category1__c) 
                           && UtilConstants.INDUCTION.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Enbl_Ppl_InductionCost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(ftec.Mob_Category1__c) 
                           && UtilConstants.RECRUITMENT.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Enbl_Ppl_RecruitCost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.ENABLE_PEOPLE.equalsIgnoreCase(ftec.Mob_Category1__c) 
                           && UtilConstants.REBADGING_COST.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Enbl_Ppl_RebadgingCost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(ftec.Mob_Category1__c)){
                            KT_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.Mob_KT_Cost_HCL_NEW.equalsIgnoreCase(ftec.Mob_Sub_Category1__c) 
                           && UtilConstants.PAYROLL_COST.equalsIgnoreCase(ftec.Cost_Type__c)){
                            KT_MobPyrl_HCost_LocCost_as_of_TMC += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.Mob_KT_Cost_LCL_NEW.equalsIgnoreCase(ftec.Mob_Sub_Category1__c) 
                           && UtilConstants.PAYROLL_COST.equalsIgnoreCase(ftec.Cost_Type__c)){
                            KT_MobPyrl_LCost_LocCost_as_of_TMC += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.TRAINING_ROOM_EPIPLEX_CHARGES.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            KT_Rooms_EpiplexCost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.KNOWLEDGE_TRANSFER.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.KT_TRAVEL.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            KT_Travel_Costs_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.SDO.equalsIgnoreCase(ftec.Costing_Type__c)){
                            Pre_Go_Live_Costs += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Costing_Type__c)){
                            BPO_Technology_Costs_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.TECH_HCL.equalsIgnoreCase(ftec.Mob_Sub_Category1__c) 
                           && UtilConstants.PAYROLL_COST.equalsIgnoreCase(ftec.Cost_Type__c)){
                            BPOTech_Pyrl_HCost_LocCost_as_of_TMC += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.TECH_LCL.equalsIgnoreCase(ftec.Mob_Sub_Category1__c) 
                           && UtilConstants.PAYROLL_COST.equalsIgnoreCase(ftec.Cost_Type__c)){
                            BPOTech_Pyrl_LCost_LocCost_as_of_TMC += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.TECHNOLOGY_TOOLS_DNP.equalsIgnoreCase(ftec.Cost_Type__c)){
                            BPOTech_DNP_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.STANDARD_TOOL_AND_ASSETS.equalsIgnoreCase(ftec.Mob_Sub_Category1__c) 
                           && UtilConstants.PAYROLL_COST.equalsIgnoreCase(ftec.Cost_Type__c)){
                            BPOTech_Tools_Assets_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.TECHNOLOGY.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.VD_DNP.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            BPOTechVoice_Data_DNP_Cost_as_of_tota += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.BSS.equalsIgnoreCase(ftec.Costing_Type__c)){
                            BSS_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.BSS.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.BSS.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.SERVICE_MANAGEMENT_NEW.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            BSS_SM_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.BSS.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.BSS.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.BSS_EDM_NEW.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            BSS_EDM_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.BSS.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.BSS.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.BSS_SC_NEW.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            BSS_SC_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.BSS.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.BSS.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.BSS_Tools.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            BSS_Tools_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.BSS.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.BSS.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.CMD_CENT.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            BSS_CCCostasBSS_CCCostas_ofTotal_MobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.PMO.equalsIgnoreCase(ftec.Costing_Type__c)){
                            Deal_PMO_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.PMO.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.PMO.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.PMO_CM.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Deal_PMO_CM_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.PMO.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.PMO.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.PMO_CFM.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Deal_PMO_CFM_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.PMO.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.PMO.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.PMO_QAD.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Deal_PMO_QA_Dir_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.PMO.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.PMO.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.PMO_OADM.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Deal_PMO_OADM_Cost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.PMO.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.PMO.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.PMO_OTHER.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Deal_PMO_Other_Cst_as_of_Total_Mob_Cost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)){
                            CS_Costs_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.OTHERS_ADDITIONAL_BACKGROUND_CHECKS_BGC.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            CS_Costs_BG_CheckCost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.OTHERS_CAPABILITY_SPECIFIC_TOOLS_AND_ASSETS.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            CS_Costs_Tools_Assets_Cost_as_of_TtlMob += double.valueof(ftec.Mob_Totals__c);
                       }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.OTHERS_SEAT_LOCKDOWN_REQUIREMENT.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            CS_Costs_Seat_ReqCost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.COMMUNICATIONS.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            CS_Costs_Com_JrnyCost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.SOLUTION_VALIDATION_TRAVEL_VISA_CHARGES.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            Solution_Validation_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && (UtilConstants.UNIT_SET_UP_ENCLOSED_BAY.equalsIgnoreCase(ftec.Mob_Sub_Category1__c) 
                               || UtilConstants.UNIT_SET_UP_DCN_SETUP_COSTS.equalsIgnoreCase(ftec.Mob_Sub_Category1__c))){
                            Unit_Set_up_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.UNIT_SET_UP_ENCLOSED_BAY.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            UnitSetup_BayCost_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.CSC.equalsIgnoreCase(ftec.Mob_Category1__c)
                           && UtilConstants.UNIT_SET_UP_DCN_SETUP_COSTS.equalsIgnoreCase(ftec.Mob_Sub_Category1__c)){
                            UnitSetup_DCN_Costs_as_of_TtlMobCost += double.valueof(ftec.Mob_Totals__c);
                        }
                        if(UtilConstants.APPLICATION_MWB.equalsIgnoreCase(ftec.Costing_Type__c) 
                           && UtilConstants.TRANSFORMATION_COST.equalsIgnoreCase(ftec.Mob_Category1__c)){
                            Transformation_Cost_per_FTE += double.valueof(ftec.Mob_Totals__c);
                        }
                    }
                }
                if(inputFTEDEtail.size() == count){
                    sol.Total_Mob_Cost_per_FTE__c = double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(Total_Mob_Cost_per_FTE-(CS_Costs_per_FTE+Transformation_Cost_per_FTE)) / double.valueOf(fteTotDn1 ) : 0;                                                              
                    sol.PM_Cost_per_FTE__c =  double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(PM_Cost_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.PM_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(PM_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.PM_Pyroll_HCost_Loc_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(PM_Pyroll_HCost_Loc_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.PM_Pyrl_LCost_Loc_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(PM_Pyrl_LCost_Loc_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.PM_DNP_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(PM_DNP_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Enbl_Ppl_Cost_per_FTE__c = double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(Enbl_Ppl_Cost_per_FTE) / double.valueOf(fteTotDn1 ) : 0;
                    sol.Enbl_Ppl_Cost_as_of_TtlMobCost__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Enbl_Ppl_Cost_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Enbl_Ppl_JBonus_Buyout_RCost_as_of_TMC__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Enbl_Ppl_JBonus_Buyout_RCost_as_of_TMC*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Enbl_Ppl_InductionCost_as_of_TtlMobCost__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Enbl_Ppl_InductionCost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Enbl_Ppl_RecruitCost_as_of_TtlMobCost__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Enbl_Ppl_RecruitCost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Enbl_Ppl_RebadgingCost_as_of_TtlMobCost__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Enbl_Ppl_RebadgingCost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.KT_Cost_per_FTE__c = double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(KT_Cost_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.KT_Cost_as_of_TtlMobCost__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(KT_Cost_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.KT_MobPyrl_HCost_LocCost_as_of_TMC__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(KT_MobPyrl_HCost_LocCost_as_of_TMC*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.KT_MobPyrl_LCost_LocCost_as_of_TMC__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ?
                        double.valueOf(KT_MobPyrl_LCost_LocCost_as_of_TMC*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.KT_Rooms_EpiplexCost_as_of_TtlMobCost__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(KT_Rooms_EpiplexCost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.KT_Travel_Costs_as_of_TtlMobCost__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(KT_Travel_Costs_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Pre_Go_Live_Costs__c = double.valueOf(Pre_Go_Live_Costs);
                    sol.Pre_Go_Live_Costs_as_of_TtlMobCost__c = double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Pre_Go_Live_Costs*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BPO_Technology_Costs_per_FTE__c =  double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(BPO_Technology_Costs_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.BPO_Tech_Costs_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BPO_Technology_Costs_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BPOTech_Pyrl_HCost_LocCost_as_of_TMC__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BPOTech_Pyrl_HCost_LocCost_as_of_TMC*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BPOTech_Pyrl_LCost_LocCost_as_of_TMC__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BPOTech_Pyrl_LCost_LocCost_as_of_TMC*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BPOTech_DNP_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BPOTech_DNP_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BPOTech_Tools_Assets_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BPOTech_Tools_Assets_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BPOTechVoice_Data_DNP_Cost_as_of_tota__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BPOTechVoice_Data_DNP_Cost_as_of_tota*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BSS_Cost_per_FTE__c =  double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(BSS_Cost_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.BSS_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BSS_Cost_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BSS_SM_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BSS_SM_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BSS_EDM_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BSS_EDM_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BSS_SC_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BSS_SC_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BSS_Tools_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BSS_Tools_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.BSS_CCCostasBSS_CCCostas_ofTotal_MobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(BSS_CCCostasBSS_CCCostas_ofTotal_MobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Deal_PMO_Cost_per_FTE__c =  double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(Deal_PMO_Cost_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.Deal_PMO_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Deal_PMO_Cost_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Deal_PMO_CM_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Deal_PMO_CM_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Deal_PMO_CFM_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Deal_PMO_CFM_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Deal_PMO_QA_Dir_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Deal_PMO_QA_Dir_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Deal_PMO_OADM_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Deal_PMO_OADM_Cost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Deal_PMO_Other_Cst_as_of_Total_Mob_Cost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Deal_PMO_Other_Cst_as_of_Total_Mob_Cost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.CS_Costs_per_FTE__c =  double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(CS_Costs_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.CS_Costs_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(CS_Costs_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.CS_Costs_BG_CheckCost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(CS_Costs_BG_CheckCost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.CS_Costs_Tools_Assets_Cost_as_of_TtlMob__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(CS_Costs_Tools_Assets_Cost_as_of_TtlMob*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.CS_Costs_Seat_ReqCost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(CS_Costs_Seat_ReqCost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.CS_Costs_Com_JrnyCost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(CS_Costs_Com_JrnyCost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Solution_Validation_Cost_per_FTE__c =  double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(Solution_Validation_Cost_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.Solution_Validation_Cost_as_of_TMC__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Solution_Validation_Cost_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Unit_Set_up_Cost_per_FTE__c =  double.valueOf(fteTotDn1) > 0 ? double.valueOf(Unit_Set_up_Cost_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.Unit_Set_up_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Unit_Set_up_Cost_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.UnitSetup_BayCost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(UnitSetup_BayCost_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.UnitSetup_DCN_Costs_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(UnitSetup_DCN_Costs_as_of_TtlMobCost*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                    sol.Transformation_Cost_per_FTE__c =  double.valueOf(fteTotDn1) > 0 ? 
                        double.valueOf(Transformation_Cost_per_FTE) / double.valueOf(fteTotDn1) : 0;
                    sol.Transformation_Cost_as_of_TtlMobCost__c =  double.valueOf(Total_Mob_Cost_per_FTE) > 0 ? 
                        double.valueOf(Transformation_Cost_per_FTE*100) / double.valueOf(Total_Mob_Cost_per_FTE) : 0;
                }
            }
        }
    return sol;
    }
}