/**
   @Author <Jayashree Pradhan>
   @Trigger name <capacityDataAfterUpdate>
   @CreateDate <12 December 2014>
   @Description <Trigger to populate record on capacity data object and Analytics Data  >
   @Version <1.0>
  */
trigger operationOnOppTrigger on Opportunity(after update, after insert, before insert, before update) {
    Boolean flag=false;
  boolean runrollups = false;
    if(Test.isRunningTest()){
        flag=true;
        runrollups= false;
    }else{
       List<FlagCheck__c> flagCheckList =FlagCheck__c.getAll().values();
        flag=flagCheckList[0].RunoppTrigger__c; 
        runrollups = flagCheckList[0].RunCalculations__C;
    }
    
 if(flag) {
    map<id,string>geoMap=new map<id,string>();
    
    if(Trigger.isBefore){
        
        if(Trigger.isInsert && (UtilConstants.IS_OPPTRIGGER_REQUIRED)){
        
           
        
        
            List<Opportunity> blankSAPIDList = new List<Opportunity>();
                for(Geo_Region_Master__c g:[Select id,name from Geo_Region_Master__c limit 4]){
                geoMap.put(g.id,g.name);
                }
                for (Opportunity oppRec: trigger.new) {
                    
                    if(String.isEmpty(oppRec.SAP_OM_ID__c) || oppRec.SAP_OM_ID__c == null)
                    {
                        oppRec.CloseDate = system.today();
                        blankSAPIDList.add(oppRec);
                    }
                     if(geoMap.get(oppRec.Geo_Region__c)!=null){
                    system.debug('geoMap.get(oppRec.Geo_Region__c)-----------'+geoMap.get(oppRec.Geo_Region__c));
                    if(geoMap.get(oppRec.Geo_Region__c).equalsIgnorecase(UtilConstantsR3.LatinAmerica)){
                        oppRec.tsdm_region__c=UtilConstantsR3.LATAM;
                      }
                     else if(geoMap.get(oppRec.Geo_Region__c).equalsIgnorecase(UtilConstantsR3.NorthAmerica)){
                        oppRec.tsdm_region__c=UtilConstantsR3.NA;
                         }
                     else if(geoMap.get(oppRec.Geo_Region__c).equalsIgnorecase('Asia Pacific')){
                         oppRec.tsdm_region__c='APAC';
                     }
                     else{
                        oppRec.tsdm_region__c=geoMap.get(oppRec.Geo_Region__c);
                     }
                    }
                }

             
        }
        
        if(Trigger.isUpdate && (UtilConstants.IS_OPPTRIGGER_REQUIRED)){
           
            for(opportunity oppRec:trigger.old){
                for(opportunity oppRecNEw:trigger.new){
                    oppRecNEw.Previous_Deal_Stage__c=oppRec.stagename;
                    oppRecNEw.Previous_Deal_Status__c=oppRec.Reporting_Status__c;
                }
            }
        }
        
        //Vaishnavi
      /*  if(trigger.isUpdate)
        {
           /* if(!AP01_Opportunity.hasAlreadyExecuted())
            {
            for(Opportunity oppRec:trigger.new)
            {
                if
                (
                    (   oppRec.BPO_Net_Rev_Thousands__c!= (trigger.oldMap.get(oppRec.ID)).BPO_Net_Rev_Thousands__c)
                    ||
                    (  oppRec.IO_Net_Revenue_Thousands__c!= (trigger.oldMap.get(oppRec.ID)).IO_Net_Revenue_Thousands__c)
                    ||
                    (  oppRec.IC_Net_Rev_Thousands__c!= (trigger.oldMap.get(oppRec.ID)).IC_Net_Rev_Thousands__c)
                )
                {
                    oppRec.SD_Covered__c = UtilConstants.NO;
                    //AP01_Opportunity.setAlreadyExecuted();
                    
                }
            }
            }
        } */
        
        
            if(IOCostModelUpload.stopTriggerExecution == false && operationOnSolCompTriggerController.preventUpdateOnOpportunity == false  && (UtilConstants.IS_OPPTRIGGER_REQUIRED)) {
                if (Trigger.IsUpdate || Trigger.IsInsert) {
                    list < opportunity > oppListToUpdate = new list < opportunity > ();
                    List < Geo_Region_Master__c > geoRegionMasterList=MasterQueries.findallGeoRegionMasters();
                    Map < String, Id > geoRegionMasterMap = new Map < String, Id > ();
                    for (Geo_Region_Master__c rec: geoRegionMasterList) {
                        geoRegionMasterMap.put(rec.name, rec.id);
                    }
                    set < ID > idSet = new set < ID > ();
                    for (opportunity opp: trigger.new) {
                        idSet.add(opp.id);
                    }
                    for (opportunity oppRec: Trigger.new) {
                        if(trigger.isBefore && trigger.isInsert){
                            Default_Countries__c mc = Default_Countries__c.getOrgDefaults();
                            oppRec.Country__c = mc.Countries__c;
                        }
                        if (geoRegionMasterMap.get(oppRec.Geo_Region_Dev__c) != null) {
                        oppRec.Geo_Region__c = geoRegionMasterMap.get(oppRec.Geo_Region_Dev__c);
                        }
                        
                        //Service Group Update -- Aswajit
                        if(oppRec.Service_Grp__c !=null)
                              oppRec.Service_Group_Lookup__c=MasterQueries.serviceGroupMap().get(oppRec.Service_Grp__c);
                    }
                }
            }
            
    
            if(trigger.isupdate && !UtilConstants.isinsertcall && UtilConstants.IS_OPPTRIGGER_REQUIRED){
                String offListBPO = UtilCOnstants.EMPTY_STRING;
                string offListIO = UtilCOnstants.EMPTY_STRING;  
                string offListIC = UtilCOnstants.EMPTY_STRING;  
                map<id,string> oppoffMap = new map<id,string>();
                map<id,id> oppprioffMap = new map<id,id>();
                map<id,string> oppoffIOMap = new map<id,string>();
                map<id,string> oppoffICMap = new map<id,string>();
                map<id,string> opppriIOMap = new map<id,string>();
                if(UtilConstants.stopTriggersForIO){
                for(Opportunity Opp : [select id,Off__c,Service_Grp__c, (select Offering_Master__r.name,Opportunity__c,service_group__c from Solution_Components__r where active__c = true AND (service_group__c=:'BPO' OR service_group__c=:'IO') AND Solution_Component__c='Delivery' AND Offering_Master__r.name !=:label.offering_all) from Opportunity where ID IN:trigger.new ]){
                    offListBPO = UtilCOnstants.EMPTY_STRING;
                    for(solution_scope__c sol:opp.Solution_Components__r){
                             if(sol.service_group__c!= null && sol.service_group__c.equalsignorecase('BPO')){
                                    offListBPO += sol.Offering_Master__r.name + UtilCOnstants.DELIMITER;
                            }
                             else if(sol.service_group__c!= null && sol.service_group__c.equalsignorecase('IO')){
                                    offListIO += sol.Offering_Master__r.name + UtilCOnstants.DELIMITER;
                            }
                            else if(sol.service_group__c!= null && sol.service_group__c.equalsignorecase('IC')){
                                offListIC += sol.Offering_Master__r.name + UtilCOnstants.DELIMITER;
                            }
                    }
                    if(offListBPO != null){
                        offListBPO.removeend(UtilCOnstants.DELIMITER);
                        oppoffMap.put(opp.id,offListBPO);
                    }
                     if(offListIO != null){
                        offListIO.removeend(UtilCOnstants.DELIMITER);
                        oppoffIOMap.put(opp.id,offListIO);
                    }
                    if(offListIC != null){
                        offListIC.removeend(UtilCOnstants.DELIMITER);
                        oppoffICMap.put(opp.id,offListIC);
                    }
                    
               }
               }
               if(UtilConstants.stopTriggersForIO){
               for (Opportunity oppRec: [select id, name, Off__c, Pri_Off__c, Primary_Offering_Revenue_SAP__c, (select id, SAP_Offering_Revenue__c, name, Offering_Master__c, Offering_Master__r.name, Opportunity__c FROM Solution_Components__r where Active__c = : true AND Service_Group__c=:'BPO' AND Offering_Master__r.name !=:label.offering_all order by SAP_Offering_Revenue__c desc limit 1) FROM Opportunity where id IN: trigger.new LIMIT 500]) {
                   if (oppRec.Solution_Components__r.size() > 0) {
                       for (Solution_Scope__c solComponentRec: oppRec.Solution_Components__r) {
                           oppprioffMap.put(oppRec.id,solComponentRec.id);
                       }
                   }
               }
               for (Opportunity oppRec: [select id, name, Off__c, Pri_Off__c, Primary_Offering_Revenue_SAP__c, (select id, SAP_Offering_Revenue__c, name, Offering_Master__c, Offering_Master__r.name, Opportunity__c FROM Solution_Components__r where Active__c = : true AND Service_Group__c=:'IO' AND Offering_Master__r.name !=:label.offering_all order by SAP_Offering_Revenue__c desc limit 1) FROM Opportunity where id IN: trigger.new LIMIT 500]) {
                       if (oppRec.Solution_Components__r.size() > 0) {
                           for (Solution_Scope__c solComponentRec: oppRec.Solution_Components__r) {
                               opppriIOMap.put(oppRec.id,solComponentRec.Offering_Master__r.name);
                           }
                       }
                    }
               }
                map<id,set<string>> deliverylocmap = new map<id,set<string>>();
                map<id,set<string>> deliverylocmapIO = new map<id,set<string>>();
               if(!SWBBPOSEIntegrationConstants.rundeliverylocationtrigger){
                    set<string> locNames = new set<string>();
                    set<string> locNamesIO = new set<string>();
                    String deliveryLocationList = UtilConstants.EMPTY_STRING;
                    for(Opportunity_Delivery_Location__c oppDeliveryLocation: [select id,Offering_Service__r.Service_Group__c,
                    Delivery_Location__r.name,Offering_Service__c,offering_service__r.solutionscope__r.opportunity__c from 
                    Opportunity_Delivery_Location__c where Active__c =: true AND offering_service__r.solutionscope__r.opportunity__c IN: trigger.new LIMIT 5000]){
                        system.debug('delivery lication name--> '+oppDeliveryLocation.Delivery_Location__r.name);
                           if(oppDeliveryLocation.Offering_Service__r.Service_Group__c.equalsIgnorecase('BPO')){      
                             locNames.add(oppDeliveryLocation.Delivery_Location__r.name);
                             deliverylocmap.put(oppDeliveryLocation.offering_service__r.solutionscope__r.opportunity__c,locNames);
                           }
                           else{
                                locNamesIO.add(oppDeliveryLocation.Delivery_Location__r.name);
                                deliverylocmapIO.put(oppDeliveryLocation.offering_service__r.solutionscope__r.opportunity__c,locNamesIO);
                           }
                        
                    }
                }
                
                if( Trigger.isUpdate){
                         BenchmarkLocationCalc bnchCalc = new BenchmarkLocationCalc();
                         bnchCalc.calcLocationOnBenchMarkFromMap(oppoffMap);
                 }
            
        
                for(Opportunity opp:trigger.new){
                  if(oppoffMap.get(opp.id) !=null){
                      opp.off__c = UtilCOnstants.EMPTY_STRING;
                      opp.off__c = oppoffMap.get(opp.id);
                  }
                  else{
                    opp.off__c = UtilCOnstants.EMPTY_STRING;
                  }
                   if(oppoffIOMap.get(opp.id) !=null){
                     opp.Offerings_IO__c = UtilCOnstants.EMPTY_STRING;
                     opp.Offerings_IO__c = oppoffIOMap.get(opp.id);
                  }
                  else{
                    opp.Offerings_IO__c = UtilCOnstants.EMPTY_STRING;
                  }
                  
                  if(oppprioffMap.get(opp.id) !=null){
                     opp.Pri_Off__c = oppprioffMap.get(opp.id); 
                  }
                  else{
                      opp.Pri_Off__c = null;
                  }
                  if(opppriIOMap.get(opp.id) != null){
                    opp.Primary_IO_Offering_Name__c = opppriIOMap.get(opp.id);


                  }
                  else{
                    opp.Primary_IO_Offering_Name__c = null;

                  }
                  if(deliverylocmap.get(opp.id) != null && !SWBBPOSEIntegrationConstants.rundeliverylocationtrigger){
                    opp.Delivery_Locations__c =  '';
                      for(string s: deliverylocmap.get(opp.id)){
                        opp.Delivery_Locations__c += s+ UtilConstants.SEMICOLON_STRING ;
                      }
                  }
                  if(deliverylocmapIO.get(opp.id) != null && !SWBBPOSEIntegrationConstants.rundeliverylocationtrigger){
                          opp.Delivery_Locations_IO__c =  '';
                          for(string s: deliverylocmapIO.get(opp.id)){
                            opp.Delivery_Locations_IO__c += s+ UtilConstants.SEMICOLON_STRING ;
                          }
                  }
                }
                
          }
           //logic to update planned FTE Count
           if(trigger.isupdate && SWBBPOSEIntegrationConstants.RunFTErollup && runrollups){
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
            for(aggregateresult ar: [SELECT opportunity__c, sum(baseline_fte__c)bftes,Sum(Y1_FTE__c)y1fte, Sum(Y2_FTE__c)y2fte, Sum(Y3_FTE__c)y3fte, Sum(Y4_FTE__c)y4fte, Sum(Y5_FTE__c)y5fte, Sum(Y6_FTE__c)y6fte, Sum(Y7_FTE__c)y7fte, Sum(Y8_FTE__c)y8fte, Sum(Y9_FTE__c)y9fte,Sum(Y10_FTE__c)y10fte, Sum(Y1_Payroll__c)Y1proll,Sum(Y2_Payroll__c)y2proll, 
                Sum(Y3_Payroll__c)y3proll, Sum(Y4_Payroll__c)y4proll, Sum(Y5_Payroll__c)y5proll, Sum(Y6_payroll__c)y6proll, Sum(Y7_payroll__c)y7proll, Sum(Y8_payroll__c)y8proll, Sum(Y9_payroll__c)y9proll, Sum(Y10_payroll__c)y10proll, 
                Sum(Y1_Other_Cost__c)y1ocd,Sum(Y2_other_cost__c)y2ocd,Sum(Y3_other_cost__c)y3ocd, Sum(Y4_Other_Cost__c)y4ocd, Sum(Y5_Other_Cost__c)y5ocd, Sum(Y6_Other_Cost__c)y6ocd, Sum(Y7_other_cost__c)y7ocd,Sum(Y8_Other_Cost__c)y8ocd, Sum(Y9_Other_Cost__c)y9ocd, 
                Sum(Y10_Other_Cost__c)y10ocd,sum(mob_cost__c)mobcost,sum(Mob_payroll__c)mobpayr FROM solution_scope__C where Opportunity__c IN:trigger.new GROUP BY Opportunity__c limit 5000]){
                id scopeid = (string) ar.get('opportunity__c');
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
            for(opportunity opp : Trigger.new){
                if(FTEtotalsMap.get(opp.id) != null){
                    string ftetotalvalues = FTEtotalsMap.get(opp.id);
                    list<string> ftetotallist = ftetotalvalues.split(SWBBPOSEIntegrationConstants.hyphen);
                    opp.Y1_FTE__c = decimal.valueof(ftetotallist[0]);
                    opp.Y2_FTE__c = decimal.valueof(ftetotallist[1]);
                    opp.Y3_FTE__c = decimal.valueof(ftetotallist[2]);
                    opp.Y4_FTE__c = decimal.valueof(ftetotallist[3]);
                    opp.Y5_FTE__c = decimal.valueof(ftetotallist[4]);
                    opp.Y6_FTE__c = decimal.valueof(ftetotallist[5]);
                    opp.Y7_FTE__c = decimal.valueof(ftetotallist[6]);
                    opp.Y8_FTE__c = decimal.valueof(ftetotallist[7]);
                    opp.Y9_FTE__c = decimal.valueof(ftetotallist[8]);
                    opp.Y10_FTE__c = decimal.valueof(ftetotallist[9]);
                    opp.baseline_fte__C = decimal.valueof(ftetotallist[10]);
                }
                if(OCDtotalsMap.get(opp.id) != null){
                    string ocdtotalvalues = OCDtotalsMap.get(opp.id);
                    list<string> ocdtotallist = ocdtotalvalues.split(SWBBPOSEIntegrationConstants.hyphen);
                    opp.Y1_other_cost__c = decimal.valueof(ocdtotallist[0]);
                    opp.Y2_other_cost__c = decimal.valueof(ocdtotallist[1]);
                    opp.Y3_other_cost__c = decimal.valueof(ocdtotallist[2]);
                    opp.Y4_other_cost__c = decimal.valueof(ocdtotallist[3]);
                    opp.Y5_other_cost__c = decimal.valueof(ocdtotallist[4]);
                    opp.Y6_other_cost__c = decimal.valueof(ocdtotallist[5]);
                    opp.Y7_other_cost__c = decimal.valueof(ocdtotallist[6]);
                    opp.Y8_other_cost__c = decimal.valueof(ocdtotallist[7]);
                    opp.Y9_other_cost__c = decimal.valueof(ocdtotallist[8]);
                    opp.Y10_other_cost__c = decimal.valueof(ocdtotallist[9]);
                    opp.mob_cost__c = decimal.valueof(ocdtotallist[10]);
                }
                if(ProlltotalsMap.get(opp.id) != null){
                    string prolltotalvalues = ProlltotalsMap.get(opp.id);
                    list<string> prolltotallist = prolltotalvalues.split(SWBBPOSEIntegrationConstants.hyphen);
                    opp.Y1_Payroll__c = decimal.valueof(prolltotallist[0]);
                    opp.Y2_Payroll__c = decimal.valueof(prolltotallist[1]);
                    opp.Y3_Payroll__c = decimal.valueof(prolltotallist[2]);
                    opp.Y4_Payroll__c = decimal.valueof(prolltotallist[3]);
                    opp.Y5_Payroll__c = decimal.valueof(prolltotallist[4]);
                    opp.Y6_Payroll__c = decimal.valueof(prolltotallist[5]);
                    opp.Y7_Payroll__c = decimal.valueof(prolltotallist[6]);
                    opp.Y8_Payroll__c = decimal.valueof(prolltotallist[7]);
                    opp.Y9_Payroll__c = decimal.valueof(prolltotallist[8]);
                    opp.Y10_Payroll__c = decimal.valueof(prolltotallist[9]);
                    opp.mob_payroll__c = decimal.valueof(prolltotallist[10]);
                }
            }
        }
      /* if(trigger.isupdate && (UtilConstants.IS_OPPTRIGGER_REQUIRED)){
        map<id,decimal> oppMap = new map<id,decimal>();
        map<id,string> oppMap1 = new map<id,string>();
        decimal Tyear1=0;
        decimal Tyear2=0;
        decimal Tyear3=0;
        decimal Tyear4=0;
        decimal Tyear5=0;
        decimal Tyear6=0;
        decimal Tyear7=0;
        decimal Tyear8=0;
        decimal Tyear9=0;
        decimal Tyear10=0;
        string oppid;
        for (AggregateResult ar :[SELECT Opportunity__c, sum(FTEYr1__c) y1,sum(FTEYr2__c)y2,sum(FTEYR3__c)y3,
                                 sum(FTEYr4__c)y4,sum(FTEYr5__c)y5,sum(FTEYr6__c)y6,sum(FTEYr7__c)y7,sum(FTEYr8__c)y8,sum(FTEYr9__c)y9,sum(FTEYr10__c) y10
                                 FROM Fte_details__c where Opportunity__c IN :Trigger.new GROUP BY Opportunity__c limit 5000]) {
            //quantity = (decimal)ar.get('countids');
            decimal totalsum = 0;
            Tyear1 = (decimal)ar.get('y1');
            Tyear2 = (decimal)ar.get('y2');
            Tyear3 = (decimal)ar.get('y3');
            Tyear4 = (decimal)ar.get('y4');
            Tyear5 = (decimal)ar.get('y5');
            Tyear6 = (decimal)ar.get('y6');
            Tyear7 = (decimal)ar.get('y7');
            Tyear8 = (decimal)ar.get('y8');
            Tyear9 = (decimal)ar.get('y9');
            Tyear10 = (decimal)ar.get('y10');
            oppid = (string) ar.get('opportunity__c');
            totalsum = Tyear1+Tyear2+Tyear3+Tyear4+Tyear5+Tyear6+Tyear7+Tyear8+Tyear9+Tyear10;
            oppMap.put(oppid,totalsum);
            oppmap1.put(oppid,Tyear1+';'+Tyear2+';'+Tyear3+';'+Tyear4+';'+Tyear5+';'+Tyear6+';'+Tyear7+';'+Tyear8+';'+Tyear9+';'+Tyear10);
        } 
            for(opportunity opp: trigger.new){
                if(oppMap.get(opp.id) != null && (opp.actual_FTE_count__c==null || opp.actual_FTE_count__c==0)){
                    opp.Planned_FTE_Count__c = oppMap.get(opp.id);
                    string ftevalues = oppmap1.get(opp.id);
                    list<string> allftes = ftevalues.split(';');
                    opp.Y1_FTE__c = decimal.valueof(allftes[0]);
                    opp.Y2_FTE__c = decimal.valueof(allftes[1]);
                    opp.Y3_FTE__c = decimal.valueof(allftes[2]);
                    opp.Y4_FTE__c = decimal.valueof(allftes[3]);
                    opp.Y5_FTE__c = decimal.valueof(allftes[4]);
                    opp.Y6_FTE__c = decimal.valueof(allftes[5]);
                    opp.Y7_FTE__c = decimal.valueof(allftes[6]);
                    opp.Y8_FTE__c = decimal.valueof(allftes[7]);
                    opp.Y9_FTE__c = decimal.valueof(allftes[8]);
                    opp.Y10_FTE__c = decimal.valueof(allftes[9]);
                }
            }
            
        }*/
    }
    if (Trigger.isAfter ) {
        system.debug('UtilConstantsR3.runWatcherMethodOnOPPTrigger'+UtilConstantsR3.runWatcherMethodOnOPPTrigger);
        if(Trigger.isUpdate && (UtilConstants.IS_OPPTRIGGER_REQUIRED) && UtilConstantsR3.runWatcherMethodOnOPPTrigger){
                 system.debug('Whatever');
                 WatchersOperations.compareOppdata(trigger.old,trigger.new);
                 WatchersOperations.deleteWatchers(trigger.old,trigger.new);
                 UtilConstantsR3.runWatcherMethodOnOPPTrigger = false;
        }
         if(Trigger.isUpdate && (UtilConstants.IS_OPPTRIGGER_REQUIRED)){
             AP01_Opportunity.emailToWatchers(trigger.new,trigger.old);
        }
        if (trigger.isInsert && (UtilConstants.IS_OPPTRIGGER_REQUIRED)) {
            UtilConstants.isinsertcall = true;
            List < Opportunity > oppList = new List < Opportunity > ();
            List < Opportunity > oppListToUpdateOff = new List < Opportunity > ();
            List < Opportunity > oppListToCreateOff = new List < Opportunity > ();
            Set<id>OpportunityIds = new set<id>();
            for (Opportunity oppRec: trigger.new) {
                OpportunityIds.add(oppRec.id);
                if (String.isEmpty(oppRec.SAP_OM_ID__c)) {
                    oppList.add(oppRec);
                }
            }
            
            if(!OpportunityIds.isEmpty()){
                WatchersOperations.addDefaultWatchers(OpportunityIds);
            }
            if (oppList.size() > 0) {
                AP01_Opportunity.createOppAddTeamRec(oppList);
            }
            
            AP01_Opportunity.createSolCompRec(trigger.new, UtilConstants.WOSAP);
            List < Profile > PROFILE = MasterQueries.retreiveProfile();
            String MyProflieName = PROFILE[0].Name;
            if (MyProflieName == UtilConstants.WORKBENCH_USER) {
                AP01_Opportunity.createOppOSLTeamRec(trigger.new);
            }
            AP01_Opportunity.createCostingRecord(trigger.new);
          }
          
          //Vaishnavi
        /*if(trigger.isUpdate)
        {
            List<Opportunity> opp = new List<Opportunity>();
            List<Opportunity> updateSDCoveredList = new List<Opportunity>();
            for(Opportunity opp1: trigger.new)
            {
                opp.add(opp1);
            }
            for(Opportunity oppRec:opp)
            {
                if
                (
                    (((oppRec.Opportunity_Solution_Lead__c!=null || oppRec.Opportunity_Solution_Lead__c!='') ) && oppRec.Max_Revenue_Dev__c !=oppRec.BPO_Net_Rev_Thousands__c && oppRec.BPO_Net_Rev_Thousands__c!= (trigger.oldMap.get(oppRec.ID)).BPO_Net_Rev_Thousands__c)
                    ||
                    (((oppRec.IO_Solution_Architect__c!=null) || (oppRec.IO_Solution_Architect__c!='')) && oppRec.Max_Revenue_Dev__c !=oppRec.IO_Net_Revenue_Thousands__c && oppRec.IO_Net_Revenue_Thousands__c!= (trigger.oldMap.get(oppRec.ID)).IO_Net_Revenue_Thousands__c)
                    ||
                    (((oppRec.IC_Solution_Architect__c!=null || oppRec.IC_Solution_Architect__c!='')) && oppRec.Max_Revenue_Dev__c !=oppRec.IC_Net_Rev_Thousands__c && oppRec.IC_Net_Rev_Thousands__c!= (trigger.oldMap.get(oppRec.ID)).IC_Net_Rev_Thousands__c)
                )
                {
                    oppRec.SD_Covered__c = UtilConstants.NO;
                    updateSDCoveredList.add(oppRec);
                    
                }
            }
            update updateSDCoveredList;
        }*/
        //Vaishnavi
        /*if(trigger.isUpdate)
        {
            List<Opportunity> opp = new List<Opportunity>();
            List<Opportunity> updateSDCoveredList = new List<Opportunity>();
            for(Opportunity opp1: trigger.new)
            {
                opp.add(opp1);
            }
            for(Opportunity oppRec:opp)
            {
                if
                (
                    ( oppRec.BPO_Net_Rev_Thousands__c!= (trigger.oldMap.get(oppRec.ID)).BPO_Net_Rev_Thousands__c)
                    ||
                    ( oppRec.IO_Net_Revenue_Thousands__c!= (trigger.oldMap.get(oppRec.ID)).IO_Net_Revenue_Thousands__c)
                    ||
                    ( oppRec.IC_Net_Rev_Thousands__c!= (trigger.oldMap.get(oppRec.ID)).IC_Net_Rev_Thousands__c)
                )
                {
                    oppRec.SD_Covered__c = UtilConstants.NO;
                    updateSDCoveredList.add(oppRec);
                    
                }
            }
            update updateSDCoveredList;
        }*/
          if (IOCostModelUpload.stopTriggerExecution == false && (UtilConstants.IS_OPPTRIGGER_REQUIRED)) {
              if (Trigger.IsUpdate) {
                  AP01_Opportunity oppN = new AP01_Opportunity();
                  List < opportunity > oppListToPass = new List < opportunity > ();
                  List < Opportunity > oppListToPass1 = new List < opportunity > ();
                  for (opportunity opp: trigger.new) {
                      if ((opp.Capacity_Services_in_Scope__c != trigger.oldMap.get(opp.Id).Capacity_Services_in_Scope__c) || (opp.name != trigger.oldMap.get(opp.Id).name)) {
                          oppListToPass.add(opp);
                      }
                      if ((opp.Analytics_in_Scope__c != trigger.oldMap.get(opp.Id).Analytics_in_Scope__c) || (opp.Name != trigger.oldMap.get(opp.Id).Name)) {
                          oppListToPass1.add(opp);
                      }
                      }
                      if (oppListToPass.size() > 0) {
                          oppN.updateCapacityRec(oppListToPass, trigger.oldMap);
                      }
                      if (oppListToPass1.size() > 0) {
                          oppN.updateAnalyticsRec(oppListToPass1, trigger.oldMap);
                      }
              }
         }
         
         
         if (IOCostModelUpload.stopTriggerExecution == false && operationOnSolCompTriggerController.preventUpdateOnOpportunity == false && (UtilConstants.IS_OPPTRIGGER_REQUIRED)) {
             if (Trigger.IsUpdate) {
             system.debug('-- line:464');
                 AP01_Opportunity opp = new AP01_Opportunity();
                 opp.closeTaskonSDGovn(trigger.new, trigger.oldMap);
                 opp.emailToDMATuser(trigger.new, trigger.oldMap);
             }
         }
         
         
                  //IOBPO Sync Benchmark Update
         if(Trigger.isAfter && Trigger.isUpdate){
             BenchmarkLocationCalc bnchCalc = new BenchmarkLocationCalc();
             //bnchCalc.calcLocationOnBenchMark(trigger.newMap);
         }
         //Rishabh
         //for ticket 434
         if(trigger.isUpdate){
         if(OppRecursiveTrigger.runOnce()){         
             AP01_Opportunity.emailOppStageChange(trigger.oldMap,trigger.new);                     
         }
         } 
        
     }
    }
}