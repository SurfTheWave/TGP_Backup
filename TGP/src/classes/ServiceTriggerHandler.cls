/*******************
@Author : Ezdhan
@description : This Class contains logic of Sync 
to populate fields on service sobject before update event
@invocation point : opeartionsOnServiceTrigger
*************************/
public without Sharing Class ServiceTriggerHandler{
    /**************************
        @method Name : runBeforeUpdate
        @Inputs : List of Service records
        @returns : Void
        @Description : This method is executed only 
        through sync, Logic should contain only before update event
        No DML statements
    *****************************/
    public static void runBeforeUpdate(list<service__c> newservList){
      UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +UtilConstants.Double_Dash+'servtrg_befinsert sync logic';
          system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue);
        //system.debug('inside status upd code');
        Set<Id> Oppids = new set<Id>();
       for(Service__c serviceRec : newservList){
        Oppids.add(serviceRec.Opportunity_Id_Dev__c);
        }
        //Map<Id,Opportunity> oppListToIterate = new Map<Id,Opportunity>([Select id,Is_Synced__c from Opportunity where Id in :Oppids]);
        Map<Id,Opportunity> oppListToIterate = MasterQueries.findallOppFromService(Oppids);
        for (Service__c ns: newservList) {
        system.debug('inside scope update logic loop'+ns);
            if(ns.Service_Group__c.equals(UtilConstants.BPO) && (oppListToIterate.get(ns.Opportunity_Id_Dev__c).Is_Synced__c ||


             UtilConstants.issyncedOpp)  && ( ns.FTE_Revenue__c >0
            || ns.Other_Cost_Revenue__c >0)){
                system.debug('inside if condition logic loop');
                   ns.Scope_Status__c = SWBBPOSEIntegrationConstants.InScope;
            }else if(ns.Service_Group__c.equals(UtilConstants.BPO) && ns.FTE_Revenue__c <=0 
            && ns.Other_Cost_Revenue__c <=0 && (oppListToIterate.get(ns.Opportunity_Id_Dev__c).Is_Synced__c || 

            UtilConstants.issyncedOpp)){
                system.debug('inside else condition logic loop');
                ns.Scope_Status__c = SWBBPOSEIntegrationConstants.outofscope;
            }
            if((ns.Service_Group__c.equals( UtilConstants.IO) || ns.Service_Group__c.equals(SWBBPOSEIntegrationConstants.IC)) 
            && (oppListToIterate.get(ns.Opportunity_Id_Dev__c).Is_Synced_io__c || UtilConstants.issyncedOpp)  
            && ( ns.FTE_Revenue__c > 0 || ns.Other_Cost_Revenue__c > 0  || ns.Payroll_Revenue_c__c > 0 || ns.Volume_Revenue__c > 0)){
                system.debug('inside if condition logic loop');
                   ns.Scope_Status__c = SWBBPOSEIntegrationConstants.InScope;
            }else if((ns.Service_Group__c.equals( UtilConstants.IO) || ns.Service_Group__c.equals(SWBBPOSEIntegrationConstants.IC)) 
            && ns.FTE_Revenue__c <=0 && ns.Other_Cost_Revenue__c <=0 && ns.Payroll_Revenue_c__c <=0 && ns.Volume_Revenue__c <=0 
            && (oppListToIterate.get(ns.Opportunity_Id_Dev__c).Is_Synced__c || UtilConstants.issyncedOpp)){
                system.debug('inside else condition logic loop');
                ns.Scope_Status__c = SWBBPOSEIntegrationConstants.outofscope;
            }
            else{
                
            }
            system.debug('status--'+ns.Scope_Status__c);
        }                


    //added by ezdhan to update delivery locations on Service

    map<id,set<string>> servmap = new map<id,set<string>>();
    system.debug('In here....................');
        set<string> locNames;
         String deliveryLocationList = UtilConstants.EMPTY_STRING;
        for(Service__c serviceRec : [select id,name,Delivery_Locations__c,(select id, name, Delivery_Location__c,
                Delivery_Location__r.name,Offering_Service__c from 
                Opportunity_Delivery_Locations__r where Active__c =: true order by createdDate asc ) 
                from Service__c where id IN : trigger.new LIMIT 5000]){
           locNames = new set<string>();           
            if(serviceRec.Opportunity_Delivery_Locations__r.size() > 0){
                for(Opportunity_Delivery_Location__c oppDeliveryLocation : serviceRec.Opportunity_Delivery_Locations__r){
                system.debug('delivery lication name--> '+oppDeliveryLocation.Delivery_Location__r.name);
                    locNames.add(oppDeliveryLocation.Delivery_Location__r.name);
                    //deliveryLocationList += oppDeliveryLocation.Delivery_Location__r.name + UtilConstants.SEMICOLON_STRING;
                }
            }
            servmap.put(serviceRec.id,locNames);
        }
        for(service__c serv: newservList){
            if(servmap.get(serv.id) != null){
                serv.Delivery_Locations__c = UtilConstants.EMPTY_STRING;
                for(string s : servmap.get(serv.id)){
                   serv.Delivery_Locations__c += s+UtilConstants.SEMICOLON_STRING;
                }
                //serv.Delivery_Locations__c = servmap.get(serv.id);
            }
        }

        map<id,string> servicemapforFTEtotals = new map<id,string>();
        map<id,string> servicemapforOCDtotals = new map<id,string>();
        map<id,string> servicemapforProlltotals = new map<id,string>();
        map<id,string> servicemapforOthertotals = new map<id,string>();
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
        string servid;
        for (AggregateResult ar :[SELECT Service__c,sum(FTEYr1__c) y1,sum(FTEYr2__c)y2,sum(FTEYR3__c)y3,
                                 sum(FTEYr4__c)y4,sum(FTEYr5__c)y5,sum(FTEYr6__c)y6,sum(FTEYr7__c)y7,sum(FTEYr8__c)y8,sum(FTEYr9__c)y9,sum(FTEYr10__c) y10,
                                 sum(Baseline_FTEs__c)bftes FROM Fte_details__c where service__C IN :Trigger.new GROUP BY Service__c limit 5000]) {
            //quantity = (decimal)ar.get('countids');
            decimal baselineftes = 0;
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
            servid = (string) ar.get('Service__c');
            baselineftes = (decimal) ar.get('bftes');
            /*totalsum = Tyear1+Tyear2+Tyear3+Tyear4+Tyear5+Tyear6+Tyear7+Tyear8+Tyear9+Tyear10;
            servMap.put(servid,totalsum);*/
            servicemapforFTEtotals.put(servid,Tyear1+';'+Tyear2+';'+Tyear3+';'+Tyear4+';'+Tyear5+';'+Tyear6+';'+Tyear7+';'+Tyear8+';'+Tyear9+';'+Tyear10+';'+baselineftes);
        } 
        for (AggregateResult ar :[SELECT Service__c,sum(Mob_Totals__c)mob, sum(Run_Yr1__c) y1,sum(Run_Yr2__c)y2,sum(Run_Yr3__c)y3,
                                 sum(Run_Yr4__c)y4,sum(Run_Yr5__c)y5,sum(Run_Yr6__c)y6,sum(Run_Yr7__c)y7,sum(Run_Yr8__c)y8,sum(Run_Yr9__c)y9,sum(Run_Yr10__c) y10
                                 FROM other_cost_details__c where service__C IN :Trigger.new AND Cost_Type__c LIKE:'DNP%' GROUP BY Service__c limit 5000]) {
            //quantity = (decimal)ar.get('countids');
            decimal mobcost = 0;
            Tyear1 = (decimal)ar.get('y1') ;
            Tyear2 = (decimal)ar.get('y2') ;
            Tyear3 = (decimal)ar.get('y3') ;
            Tyear4 = (decimal)ar.get('y4') ;
            Tyear5 = (decimal)ar.get('y5') ;
            Tyear6 = (decimal)ar.get('y6') ;
            Tyear7 = (decimal)ar.get('y7') ;
            Tyear8 = (decimal)ar.get('y8') ;
            Tyear9 = (decimal)ar.get('y9') ;
            Tyear10 = (decimal)ar.get('y10') ;
            mobcost = (decimal) ar.get('mob');
            servid = (string) ar.get('Service__c');
            /*totalsum = Tyear1+Tyear2+Tyear3+Tyear4+Tyear5+Tyear6+Tyear7+Tyear8+Tyear9+Tyear10;
            servMap.put(servid,totalsum);*/
            servicemapforOCDtotals.put(servid,Tyear1+';'+Tyear2+';'+Tyear3+';'+Tyear4+';'+Tyear5+';'+Tyear6+';'+Tyear7+';'+Tyear8+';'+Tyear9+';'+Tyear10+';'+mobcost);
        } 
        for (AggregateResult ar :[SELECT Service__c,sum(Mob_Payroll_Ops__c)mob, sum(Y1_Ops__c) y1,sum(Y2_Ops__c)y2,sum(Y3_Ops__c)y3,
                                 sum(Y4_Ops__c)y4,sum(Y5_Ops__c)y5,sum(Y6_Ops__c)y6,sum(Y7_Ops__c)y7,sum(Y8_Ops__c)y8,sum(Y9_Ops__c)y9,sum(Y10_ops__c) y10
                                 FROM Payroll__c where service__C IN :Trigger.new GROUP BY Service__c limit 5000]) {
            //quantity = (decimal)ar.get('countids');
            decimal mobpayroll = 0;
            Tyear1 = (decimal)ar.get('y1') ;
            Tyear2 = (decimal)ar.get('y2') ;
            Tyear3 = (decimal)ar.get('y3') ;
            Tyear4 = (decimal)ar.get('y4') ;
            Tyear5 = (decimal)ar.get('y5') ;
            Tyear6 = (decimal)ar.get('y6') ;
            Tyear7 = (decimal)ar.get('y7') ;
            Tyear8 = (decimal)ar.get('y8') ;
            Tyear9 = (decimal)ar.get('y9') ;
            Tyear10 = (decimal)ar.get('y10') ;
            servid = (string) ar.get('Service__c');
            mobpayroll = (decimal) ar.get('mob');
            /*totalsum = Tyear1+Tyear2+Tyear3+Tyear4+Tyear5+Tyear6+Tyear7+Tyear8+Tyear9+Tyear10;
            servMap.put(servid,totalsum);*/
            servicemapforProlltotals.put(servid,Tyear1+';'+Tyear2+';'+Tyear3+';'+Tyear4+';'+Tyear5+';'+Tyear6+';'+Tyear7+';'+Tyear8+';'+Tyear9+';'+Tyear10+';'+mobpayroll);
        } 
            for(service__c serv: newservList){
                if(servicemapforFTEtotals.get(serv.id) != null){
                    string ftevalues = servicemapforFTEtotals.get(serv.id);
                    list<string> allftes = ftevalues.split(';');
                    serv.Y1_FTE__c = decimal.valueof(allftes[0]);
                    serv.Y2_FTE__c = decimal.valueof(allftes[1]);
                    serv.Y3_FTE__c = decimal.valueof(allftes[2]);
                    serv.Y4_FTE__c = decimal.valueof(allftes[3]);
                    serv.Y5_FTE__c = decimal.valueof(allftes[4]);
                    serv.Y6_FTE__c = decimal.valueof(allftes[5]);
                    serv.Y7_FTE__c = decimal.valueof(allftes[6]);
                    serv.Y8_FTE__c = decimal.valueof(allftes[7]);
                    serv.Y9_FTE__c = decimal.valueof(allftes[8]);
                    serv.Y10_FTE__c = decimal.valueof(allftes[9]);
                    serv.Baseline_FTE__C = decimal.valueof(allftes[10]);
                }
                if(servicemapforOCDtotals.get(serv.id) != null){
                    string ocdvalues = servicemapforOCDtotals.get(serv.id);
                    list<string> allocds = ocdvalues.split(';');
                    serv.Y1_Other_Cost__c = decimal.valueof(allocds[0]);
                    serv.Y2_Other_Cost__c = decimal.valueof(allocds[1]);
                    serv.Y3_Other_Cost__c = decimal.valueof(allocds[2]);
                    serv.Y4_Other_Cost__c = decimal.valueof(allocds[3]);
                    serv.Y5_Other_Cost__c = decimal.valueof(allocds[4]);
                    serv.Y6_Other_Cost__c = decimal.valueof(allocds[5]);
                    serv.Y7_Other_Cost__c = decimal.valueof(allocds[6]);
                    serv.Y8_Other_Cost__c = decimal.valueof(allocds[7]);
                    serv.Y9_Other_Cost__c = decimal.valueof(allocds[8]);
                    serv.Y10_Other_Cost__c = decimal.valueof(allocds[9]);
                    serv.mob_cost__c = decimal.valueof(allocds[10]);
                }
                if(servicemapforProlltotals.get(serv.id) != null){
                    string Prollvalues = servicemapforProlltotals.get(serv.id);
                    list<string> allprolls = Prollvalues.split(';');
                    serv.Y1_Payroll__c = decimal.valueof(allprolls[0]);
                    serv.Y2_Payroll__c = decimal.valueof(allprolls[1]);
                    serv.Y3_Payroll__c = decimal.valueof(allprolls[2]);
                    serv.Y4_Payroll__c = decimal.valueof(allprolls[3]);
                    serv.Y5_Payroll__c = decimal.valueof(allprolls[4]);
                    serv.Y6_Payroll__c = decimal.valueof(allprolls[5]);
                    serv.Y7_Payroll__c = decimal.valueof(allprolls[6]);
                    serv.Y8_Payroll__c = decimal.valueof(allprolls[7]);
                    serv.Y9_Payroll__c = decimal.valueof(allprolls[8]);
                    serv.Y10_Payroll__c = decimal.valueof(allprolls[9]);
                    serv.mob_payroll__c = decimal.valueof(allprolls[10]);
                }
            }


    }

}