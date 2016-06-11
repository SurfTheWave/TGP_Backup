/**
   @Author         : Komal Priya
   @Trigger name   : operationOnSolCompTrigger
   @CreateDate     : 22 December 2014
   @Description    : Trigger on Solution Component to perform various functions.
   @Version        : 1.0
  */
trigger operationOnSolCompTrigger on Solution_Scope__c(after insert, after update, after delete, before insert,before update) {
Boolean flag=false;
  boolean runrollups = false;


    if(Test.isRunningTest()){
        flag=true;
        runrollups= false;
    }else{
       List<FlagCheck__c> flagCheckList =FlagCheck__c.getAll().values();
        flag=flagCheckList[0].RunsolScopeTrigger__c; 
        runrollups = flagCheckList[0].RunCalculations__C;
    }
if(SWBBPOSEIntegrationConstants.runSolScopeTrigger){
/************************************
    Block of code which will execute normally from Solution Scope trigger
  *******************************************/      
 if(flag && !SWBBPOSEIntegrationConstants.isExceutionFromSync) { 
     if(trigger.isbefore && trigger.isupdate){
       operationOnSolCompTriggerController.stopDeactivation(trigger.new,trigger.oldMap);
    } 
    if (trigger.isAfter) {

        if (trigger.isInsert) {
            
            operationOnSolCompTriggerController.updateServiceGroup(trigger.new);
            List < Solution_Scope__c > scwithDelivery = new List < Solution_Scope__c > ();
            for (Solution_Scope__c solRec: trigger.new) {
                if (solRec.Solution_Component__c.equals(UtilConstants.SOLCOMP_DELIVERY)) {
                    scwithDelivery.add(solRec);
                }
            }
            utilconstants.isinsertcall = true;
            UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +'--'+'solScopetrg_aftinsertmethod';
            system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue); 
            operationOnSolCompTriggerController.updateOffOnOpp(scwithDelivery,'InsertTrigger');
            if (scwithDelivery.size() > 0) {
             //  system.debug('inside delivery of trigger');
             
                operationOnSolCompTriggerController.createSupportingOffs(scwithDelivery);
            }
            
            operationOnSolCompTriggerController.createServices(trigger.new);
            UtilConstantsR3.runWatcherMethodOnOPPTrigger=false;
            
            operationOnSolCompTriggerController.updatePrimaryOffOnOpp(trigger.new);
            
            operationOnSolCompTriggerController.createChildRecsOfSolComp(trigger.new);
            
            operationOnSolCompTriggerController.createAddProcurementRec(trigger.new);
            //operationOnSolCompTriggerController.updateOfferingOnSolutionLive(trigger.new);
        }
        if (trigger.isUpdate) {
            boolean isRollupChanged = false;
            UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +'--'+'solScopetrg_update method';
            system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue);
            /*for (Solution_Scope__c newSScope: trigger.new) {
                for (Solution_Scope__c oldSScope: trigger.old) {
                    //system.debug(newSScope.Other_Cost__c +' =11==  '+ oldSScope.Other_Cost__c);
                    //system.debug(newSScope.Payroll_Cost__c +' =11==  '+ oldSScope.Payroll_Cost__c);
                    //system.debug(newSScope.Sum_Of_Average_FTEs__c +' =11==  '+ oldSScope.Sum_Of_Average_FTEs__c);
                    if (newSScope.id == oldSScope.id && newSScope.active__c == oldSScope.active__c) {
                        isRollupChanged = true;
                        //system.debug(newSScope.Other_Cost__c +' ===  '+ isRollupChanged);
                    }
                }
            }*/
            //system.debug('isRollupChanged'+isRollupChanged);   
            //if (isRollupChanged != true) {
                List < Solution_Scope__c > scToUpdateOff = new List < Solution_Scope__c > ();
                List < Solution_Scope__c > scToUpdatePriOff = new List < Solution_Scope__c > ();
                for (Solution_Scope__c sol: trigger.new) {
                    if (sol.active__c != trigger.oldMap.get(sol.Id).active__c) {
                        scToUpdateOff.add(sol);
                    }
                    if (sol.SAP_Offering_Revenue__c != trigger.oldMap.get(sol.Id).SAP_Offering_Revenue__c) {
                        system.debug('----revenue updated----');
                        scToUpdatePriOff.add(sol);
                    }
                }
                if (!scToUpdateOff.isEmpty()) {
                    UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +'--'+'solScopetrg_update';
            system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue);
                    operationOnSolCompTriggerController.updateOffOnOpp(scToUpdateOff,'UpdateTrigger');
                }
                if (!scToUpdatePriOff.isEmpty()) {
                    UtilConstantsR3.runWatcherMethodOnOPPTrigger=false;
                    
                    operationOnSolCompTriggerController.updatePrimaryOffOnOpp(scToUpdatePriOff);
                }
           // }



       // operationOnSolCompTriggerController.updateOfferingOnSolutionLive(trigger.new);


        }
        
        if (trigger.isDelete) {
            
            operationOnSolCompTriggerController.updateOffOnOpp(trigger.old,'UpdateTrigger');
           // operationOnSolCompTriggerController.updateOfferingOnSolutionLive(trigger.old);
        }
    }
    if (trigger.isBefore) {
        if (trigger.isInsert) {
         UtilConstants.allowactivation = true;
         utilconstants.allowstatusupdation= true;
         utilconstants.isinsertcall = true;
            UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +'--'+'solScopetrg_befinsert';
            system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue);
            operationOnSolCompTriggerController.preventduplicateOffering(trigger.new);
        }
    }
   }
/******************************
    Block of code will execute only in sync transaction
   **********************************/
   else if(flag && SWBBPOSEIntegrationConstants.isExceutionFromSync){
        // logic to populate Yr fields in scope level start here
        if(trigger.isupdate && trigger.isbefore && runrollups ){
            UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +'--'+'solScopetrg_beforeupdate sync';
            system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue);
            map<string,string> FTEtotalsMap = new map<string,string>();
            map<string,string> OCDtotalsMap = new map<string,string>();
            map<string,string> ProlltotalsMap = new map<string,string>();
            decimal total1 = 0;
            decimal total2 = 0;
            decimal total3 = 0;
            decimal total4 = 0;
            decimal total5 = 0;
            decimal total6 = 0;
            decimal total7 = 0;
            decimal total8 = 0;
            decimal total9 = 0;
            decimal total10 = 0;
            decimal baselineftes =0;
            decimal mobcost = 0;
            decimal mobpayroll = 0;
            for(aggregateresult ar: [SELECT solutionscope__c, sum(baseline_fte__c)bftes,Sum(Y1_FTE__c)y1fte, Sum(Y2_FTE__c)y2fte, Sum(Y3_FTE__c)y3fte, Sum(Y4_FTE__c)y4fte, Sum(Y5_FTE__c)y5fte, Sum(Y6_FTE__c)y6fte, Sum(Y7_FTE__c)y7fte, Sum(Y8_FTE__c)y8fte, Sum(Y9_FTE__c)y9fte,Sum(Y10_FTE__c)y10fte, Sum(Y1_Payroll__c)Y1proll,Sum(Y2_Payroll__c)y2proll, 
                Sum(Y3_Payroll__c)y3proll, Sum(Y4_Payroll__c)y4proll, Sum(Y5_Payroll__c)y5proll, Sum(Y6_payroll__c)y6proll, Sum(Y7_payroll__c)y7proll, Sum(Y8_payroll__c)y8proll, Sum(Y9_payroll__c)y9proll, Sum(Y10_payroll__c)y10proll, 
                Sum(Y1_Other_Cost__c)y1ocd,Sum(Y2_other_cost__c)y2ocd,Sum(Y3_other_cost__c)y3ocd, Sum(Y4_Other_Cost__c)y4ocd, Sum(Y5_Other_Cost__c)y5ocd, Sum(Y6_Other_Cost__c)y6ocd, Sum(Y7_other_cost__c)y7ocd,Sum(Y8_Other_Cost__c)y8ocd, Sum(Y9_Other_Cost__c)y9ocd, 
                Sum(Y10_Other_Cost__c)y10ocd,sum(mob_cost__c)mobcost,sum(Mob_payroll__c)mobpayr FROM Service__c where solutionscope__c IN:trigger.new GROUP BY Solutionscope__C limit 5000]){
                id scopeid = (string) ar.get('solutionscope__c');
                total1 = (Decimal) ar.get('y1fte');
                 total2 = (Decimal) ar.get('y2fte');
                 total3 = (Decimal) ar.get('y3fte');
                 total4 = (Decimal) ar.get('y4fte');
                 total5 = (Decimal) ar.get('y5fte');
                 total6 = (Decimal) ar.get('y6fte');
                 total7 = (Decimal) ar.get('y7fte');
                 total8 = (Decimal) ar.get('y8fte');
                 total9 = (Decimal) ar.get('y9fte');
                 total10 = (Decimal) ar.get('y10fte');
                 baselineftes = (decimal) ar.get('bftes');
                FTEtotalsMap.put(scopeid,total1+SWBBPOSEIntegrationConstants.hyphen+total2+SWBBPOSEIntegrationConstants.hyphen+total3+SWBBPOSEIntegrationConstants.hyphen+total4+SWBBPOSEIntegrationConstants.hyphen
                +total5+SWBBPOSEIntegrationConstants.hyphen+total6+SWBBPOSEIntegrationConstants.hyphen+total7+SWBBPOSEIntegrationConstants.hyphen+total8+SWBBPOSEIntegrationConstants.hyphen
                +total9+SWBBPOSEIntegrationConstants.hyphen+total10+SWBBPOSEIntegrationConstants.hyphen+baselineftes);
                 total1 = (Decimal) ar.get('y1ocd');
                 total2 = (Decimal) ar.get('y2ocd');
                 total3 = (Decimal) ar.get('y3ocd');
                 total4 = (Decimal) ar.get('y4ocd');
                 total5 = (Decimal) ar.get('y5ocd');
                 total6 = (Decimal) ar.get('y6ocd');
                 total7 = (Decimal) ar.get('y7ocd');
                 total8 = (Decimal) ar.get('y8ocd');
                 total9 = (Decimal) ar.get('y9ocd');
                 total10 = (Decimal) ar.get('y10ocd');
                 mobcost = (decimal) ar.get('mobcost');
                 OCDtotalsMap.put(scopeid,total1+SWBBPOSEIntegrationConstants.hyphen+total2+SWBBPOSEIntegrationConstants.hyphen+total3+SWBBPOSEIntegrationConstants.hyphen+total4+SWBBPOSEIntegrationConstants.hyphen
                +total5+SWBBPOSEIntegrationConstants.hyphen+total6+SWBBPOSEIntegrationConstants.hyphen+total7+SWBBPOSEIntegrationConstants.hyphen+total8+SWBBPOSEIntegrationConstants.hyphen
                +total9+SWBBPOSEIntegrationConstants.hyphen+total10+SWBBPOSEIntegrationConstants.hyphen+mobcost);
                 total1 = (Decimal) ar.get('y1proll');
                 total2 = (Decimal) ar.get('y2proll');
                 total3 = (Decimal) ar.get('y3proll');
                 total4 = (Decimal) ar.get('y4proll');
                 total5 = (Decimal) ar.get('y5proll');
                 total6 = (Decimal) ar.get('y6proll');
                 total7 = (Decimal) ar.get('y7proll');
                 total8 = (Decimal) ar.get('y8proll');
                 total9 = (Decimal) ar.get('y9proll');
                 total10 = (Decimal) ar.get('y10proll');
                 mobpayroll = (decimal) ar.get('mobpayr');
                 ProlltotalsMap.put(scopeid,total1+SWBBPOSEIntegrationConstants.hyphen+total2+SWBBPOSEIntegrationConstants.hyphen+total3+SWBBPOSEIntegrationConstants.hyphen+total4+SWBBPOSEIntegrationConstants.hyphen
                +total5+SWBBPOSEIntegrationConstants.hyphen+total6+SWBBPOSEIntegrationConstants.hyphen+total7+SWBBPOSEIntegrationConstants.hyphen+total8+SWBBPOSEIntegrationConstants.hyphen
                +total9+SWBBPOSEIntegrationConstants.hyphen+total10+SWBBPOSEIntegrationConstants.hyphen+mobpayroll);
            }
            for(solution_scope__c sScope : Trigger.new){
                if(FTEtotalsMap.get(sScope.id) != null){
                    string ftetotalvalues = FTEtotalsMap.get(sScope.id);
                    list<string> ftetotallist = ftetotalvalues.split(SWBBPOSEIntegrationConstants.hyphen);
                    sScope.Y1_FTE__c = decimal.valueof(ftetotallist[0]);
                    sScope.Y2_FTE__c = decimal.valueof(ftetotallist[1]);
                    sScope.Y3_FTE__c = decimal.valueof(ftetotallist[2]);
                    sScope.Y4_FTE__c = decimal.valueof(ftetotallist[3]);
                    sScope.Y5_FTE__c = decimal.valueof(ftetotallist[4]);
                    sScope.Y6_FTE__c = decimal.valueof(ftetotallist[5]);
                    sScope.Y7_FTE__c = decimal.valueof(ftetotallist[6]);
                    sScope.Y8_FTE__c = decimal.valueof(ftetotallist[7]);
                    sScope.Y9_FTE__c = decimal.valueof(ftetotallist[8]);
                    sScope.Y10_FTE__c = decimal.valueof(ftetotallist[9]);
                    sScope.BaseLine_FTE__C = decimal.valueof(ftetotallist[10]);
                }
                if(OCDtotalsMap.get(sScope.id) != null){
                    string ocdtotalvalues = OCDtotalsMap.get(sScope.id);
                    list<string> ocdtotallist = ocdtotalvalues.split(SWBBPOSEIntegrationConstants.hyphen);
                    sScope.Y1_other_cost__c = decimal.valueof(ocdtotallist[0]);
                    sScope.Y2_other_cost__c = decimal.valueof(ocdtotallist[1]);
                    sScope.Y3_other_cost__c = decimal.valueof(ocdtotallist[2]);
                    sScope.Y4_other_cost__c = decimal.valueof(ocdtotallist[3]);
                    sScope.Y5_other_cost__c = decimal.valueof(ocdtotallist[4]);
                    sScope.Y6_other_cost__c = decimal.valueof(ocdtotallist[5]);
                    sScope.Y7_other_cost__c = decimal.valueof(ocdtotallist[6]);
                    sScope.Y8_other_cost__c = decimal.valueof(ocdtotallist[7]);
                    sScope.Y9_other_cost__c = decimal.valueof(ocdtotallist[8]);
                    sScope.Y10_other_cost__c = decimal.valueof(ocdtotallist[9]);
                    sScope.mob_cost__c = decimal.valueof(ocdtotallist[10]);
                }
                if(ProlltotalsMap.get(sScope.id) != null){
                    string prolltotalvalues = ProlltotalsMap.get(sScope.id);
                    list<string> prolltotallist = prolltotalvalues.split(SWBBPOSEIntegrationConstants.hyphen);
                    sScope.Y1_Payroll__c = decimal.valueof(prolltotallist[0]);
                    sScope.Y2_Payroll__c = decimal.valueof(prolltotallist[1]);
                    sScope.Y3_Payroll__c = decimal.valueof(prolltotallist[2]);
                    sScope.Y4_Payroll__c = decimal.valueof(prolltotallist[3]);
                    sScope.Y5_Payroll__c = decimal.valueof(prolltotallist[4]);
                    sScope.Y6_Payroll__c = decimal.valueof(prolltotallist[5]);
                    sScope.Y7_Payroll__c = decimal.valueof(prolltotallist[6]);
                    sScope.Y8_Payroll__c = decimal.valueof(prolltotallist[7]);
                    sScope.Y9_Payroll__c = decimal.valueof(prolltotallist[8]);
                    sScope.Y10_Payroll__c = decimal.valueof(prolltotallist[9]);
                    sScope.mob_payroll__c = decimal.valueof(prolltotallist[10]);
                }
            }
        }
        // logic to populate Yr fields in scope level ends here
    if(trigger.isBefore && trigger.isUpdate ){
        Set<Id> Oppids = new set<Id>();
        for(Solution_Scope__c solScope : Trigger.new){
           Oppids.add(solScope.Opportunity__c);
        }
        //Map<Id,Opportunity> oppListToIterate = new Map<Id,Opportunity>([Select id,Is_Synced__c from Opportunity where Id in :Oppids]);
        Map<Id,Opportunity> oppListToIterate = MasterQueries.findallOppFromSolscope(Oppids);
        for(Solution_Scope__c sc : Trigger.new){
            if(UtilConstants.BPO.equals(sc.Service_Group__c) && (oppListToIterate.get(sc.Opportunity__c).Is_Synced__c ||
                UtilConstants.issyncedOpp)  && ( sc.FTE_Revenue__c >0
            || sc.Other_Cost_Revenue__c >0)){
                system.debug('iscide if condition logic loop');
                   sc.Active__c = true;
            }else if(sc.Service_Group__c.equals(UtilConstants.BPO) && sc.FTE_Revenue__c <=0 
            && sc.Other_Cost_Revenue__c <=0 && (oppListToIterate.get(sc.Opportunity__c).Is_Synced__c || 
            UtilConstants.issyncedOpp)){
                system.debug('inside else condition logic loop');
                sc.Active__c = false;
            }
            if((sc.Service_Group__c.equals( UtilConstants.IO) || sc.Service_Group__c.equals(SWBBPOSEIntegrationConstants.IC)) 
            && (oppListToIterate.get(sc.Opportunity__c).Is_Synced_io__c || UtilConstants.issyncedOpp)  
            && ( sc.FTE_Revenue__c > 0 || sc.Other_Cost_Revenue__c > 0  || sc.Payroll_Revenue__c > 0 || sc.Volume_Revenue__c > 0)){
                system.debug('inside if condition logic loop');
                   sc.Active__c = true;
            }else if((sc.Service_Group__c.equals( UtilConstants.IO) || sc.Service_Group__c.equals(SWBBPOSEIntegrationConstants.IC)) 
            && sc.FTE_Revenue__c <=0 && sc.Other_Cost_Revenue__c <=0 && sc.Payroll_Revenue__c <=0 && sc.Volume_Revenue__c <=0 
            && (oppListToIterate.get(sc.Opportunity__c).Is_Synced_io__c || UtilConstants.issyncedOpp)){
                system.debug('inside else condition logic loop');
               sc.Active__c = false;
            }
        }
        map<Id,string> scopeId_services = new map<Id,String>();
        for (Solution_Scope__c solCompRec: [select id, name, Services__c, Active__c, fte_revenue__c,other_cost_revenue__c,(select id, name, services__r.Name from
                                           Services__r where 
                                            Scope_Status__c = : UtilConstants.SERVICE_IN_SCOPE order by createdDate asc Limit 5000)
                                            from Solution_Scope__c where id IN: trigger.new AND (Service_Group__c='BPO' OR Service_Group__C='IO') Limit 5000]) {
                /*system.debug(solCompRec.id+' fte revenue'+solCompRec.fte_revenue__c);
                system.debug(solCompRec+' OCD revenue'+solCompRec.other_cost_revenue__c);
                system.debug('solCompRec.Services__r.size()--'+solCompRec.Services__r.size());*/
            if (solCompRec.Services__r.size() > 0) {
               String scopeNames = '';
               for (Service__c serviceName: solCompRec.Services__r) {
                   // system.debug('solCompRec.Services__c 1--'+solCompRec.Services__c);
                    scopeNames = scopeNames + serviceName.services__r.Name + UtilConstants.DELIMITER;
                }
                if(scopeNames.length()>0){
                    scopeNames = scopeNames.substring(0,scopeNames.length()-1);
                }
                //system.debug('scopeNames--'+scopeNames);
                scopeId_services.put(solCompRec.Id,scopeNames);
            }
        }
        for(Solution_Scope__c solComp: Trigger.New){
        
            if(scopeId_services.containskey(solComp.Id)){
               solComp.Services__c = scopeId_services.get(solComp.Id); 
            }
            else{
                solComp.Services__c ='';
            }
                //system.debug('solComp.Services__c--'+solComp.Services__c);
        }
    }
   }
   /******************************
    Block of code will execute during all transactions (sync & normal trigger flow)
   **********************************/
   else if(flag){
   }
 }
}