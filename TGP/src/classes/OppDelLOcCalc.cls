public class OppDelLOcCalc {
        private class FTEWrapper{
            id DelLOcId;
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
            decimal baselinftes=0;
            decimal mobcost =0;
            decimal mobpayroll =0;
        }
        

public static void calcOppDelLoc(List<Opportunity_Delivery_Location__c> DelLocList, Set<Id> newFtes, Set<Id> newOcds,string type){
    map<id,Opportunity_Delivery_Location__c> delMaptoupdate = new map<id,Opportunity_Delivery_Location__c>();
        map<id,FTEWrapper> oppDelLocmapforFTEtotals = new map<id,FTEWrapper>();
        map<id,FTEWrapper> oppDelLocmapforOCDtotals = new map<id,FTEWrapper>();
        map<id,string> servicemapforProlltotals = new map<id,string>();
        map<id,string> servicemapforOthertotals = new map<id,string>();
         string servid;                        
        system.debug('fte list for ---> '+type+' size '+newftes.size());
        system.debug('OCD list for ---> '+type+' size '+newocds.size());
        system.debug('delivery list for ---> '+type+' size '+DelLocList.size());
            FTEWrapper wrapFTE; 
        if(type.equalsignorecase('Payroll')){
          for (AggregateResult ar :[SELECT Opportunity_Delivery_Location__c, sum(Mob_Totals__c)mob, sum(Run_Yr1__c) y1,sum(Run_Yr2__c)y2,sum(Run_Yr3__c)y3,
                                 sum(Run_Yr4__c)y4,sum(Run_Yr5__c)y5,sum(Run_Yr6__c)y6,sum(Run_Yr7__c)y7,sum(Run_Yr8__c)y8,sum(Run_Yr9__c)y9,sum(Run_Yr10__c) y10,
                                 sum(Baseline_FTEs__c)bftes
                                 FROM FTE_Details__c  where ID IN :newFtes  GROUP BY Opportunity_Delivery_Location__c limit 9000]) {                     
            //quantity = (decimal)ar.get('countids');
            decimal baselineftes = 0;
            servid = (string) ar.get('Opportunity_Delivery_Location__c');
            /*if(oppDelLocmapforFTEtotals.ContainsKey(servId)){
                oppDelLocmapforFTEtotals.get(servId);
            }
            else{
                wrapFTE = new FTEWrapper();
                wrapFTE.DelLOcId = servId;
            }*/
            wrapFTE = new FTEWrapper();
            wrapFTE.Tyear1 = (decimal)ar.get('y1');
            wrapFTE.Tyear2 = (decimal)ar.get('y2');
            wrapFTE.Tyear3 = (decimal)ar.get('y3');
            wrapFTE.Tyear4 = (decimal)ar.get('y4');
            wrapFTE.Tyear5 = (decimal)ar.get('y5');
            wrapFTE.Tyear6 = (decimal)ar.get('y6');
            wrapFTE.Tyear7 = (decimal)ar.get('y7');
            wrapFTE.Tyear8 = (decimal)ar.get('y8');
            wrapFTE.Tyear9 = (decimal)ar.get('y9');
            wrapFTE.Tyear10 = (decimal)ar.get('y10');
            wrapFTE.mobpayroll = (decimal)ar.get('mob');
           // baselineftes = (decimal) ar.get('bftes');
            /*totalsum = Tyear1+Tyear2+Tyear3+Tyear4+Tyear5+Tyear6+Tyear7+Tyear8+Tyear9+Tyear10;
            servMap.put(servid,totalsum);*/
           oppDelLocmapforFTEtotals.put(servId, wrapFTE); 
           //oppDelLocmapforFTEtotals.put(servid,Tyear1+';'+Tyear2+';'+Tyear3+';'+Tyear4+';'+Tyear5+';'+Tyear6+';'+Tyear7+';'+Tyear8+';'+Tyear9+';'+Tyear10+';'+baselineftes);
            }
            
            FTEWrapper wrapOCD;
            for (AggregateResult ar :[SELECT Opportunity_Delivery_Location__c, sum(Mob_Totals__c)mob, sum(Run_Yr1__c) y1,sum(Run_Yr2__c)y2,sum(Run_Yr3__c)y3,
                                 sum(Run_Yr4__c)y4,sum(Run_Yr5__c)y5,sum(Run_Yr6__c)y6,sum(Run_Yr7__c)y7,sum(Run_Yr8__c)y8,sum(Run_Yr9__c)y9,sum(Run_Yr10__c) y10
                                  FROM OTHER_COST_DETAILS__C where ID IN :newOcds AND Cost_type__c LIKE:'Payroll%' GROUP BY Opportunity_Delivery_Location__c limit 9000]) {
            //quantity = (decimal)ar.get('countids');
            
            wrapOCD = new FTEWrapper();
            servid = (string) ar.get('Opportunity_Delivery_Location__c');
            /*if(oppDelLocmapforOCDtotals.containsKey(servID)){
                wrapOCD = oppDelLocmapforOCDtotals.get(servId);
            }
            else{
                wrapOCD = new FTEWrapper();
                wrapOCD.DelLOcId = servID;
            }*/
            
            wrapOCD.Tyear1 =(decimal)ar.get('y1');
            wrapOCD.Tyear2 =(decimal)ar.get('y2');
            wrapOCD.Tyear3 =(decimal)ar.get('y3');
            wrapOCD.Tyear4 =(decimal)ar.get('y4');
            wrapOCD.Tyear5 =(decimal)ar.get('y5');
            wrapOCD.Tyear6 =(decimal)ar.get('y6');
            wrapOCD.Tyear7 =(decimal)ar.get('y7');
            wrapOCD.Tyear8 =(decimal)ar.get('y8');
            wrapOCD.Tyear9 =(decimal)ar.get('y9');
            wrapOCD.Tyear10 =(decimal)ar.get('y10');
            wrapOCD.mobpayroll = (decimal)ar.get('mob');
            
            
            /*totalsum = Tyear1+Tyear2+Tyear3+Tyear4+Tyear5+Tyear6+Tyear7+Tyear8+Tyear9+Tyear10;
            servMap.put(servid,totalsum);*/
            oppDelLocmapforOCDtotals.put(servId, wrapOCD);  
            //oppDelLocmapforOCDtotals.put(servid,Tyear1+';'+Tyear2+';'+Tyear3+';'+Tyear4+';'+Tyear5+';'+Tyear6+';'+Tyear7+';'+Tyear8+';'+Tyear9+';'+Tyear10+';'+baselineftes);
            }   
            
             FTEWrapper ftes = new FTEWRApper();
              FTEWrapper ocds = new FTEWrapper();
            for(Opportunity_Delivery_Location__c oppDLoc : DelLocList){
                
                //if(oppDelLocmapforFTEtotals.ContainsKey(oppDloc.Id))
                ftes = oppDelLocmapforFTEtotals.get(oppDLoc.Id);
                ocds = oppDelLocmapforOCDtotals.get(oppDLoc.Id);
                if(ftes!= null ){
                    oppDLoc.Y1_Payroll__c=ftes.Tyear1;
                    oppDLoc.Y2_Payroll__c=ftes.Tyear2;
                    oppDLoc.Y3_Payroll__c=ftes.Tyear3;
                    oppDLoc.Y4_Payroll__c=ftes.Tyear4;
                    oppDLoc.Y5_Payroll__c=ftes.Tyear5;
                    oppDLoc.Y6_Payroll__c=ftes.Tyear6;
                    oppDLoc.Y7_Payroll__c=ftes.Tyear7;
                    oppDLoc.Y8_Payroll__c=ftes.Tyear8;
                    oppDLoc.Y9_Payroll__c=ftes.Tyear9;
                    oppDLoc.Y10_Payroll__c=ftes.Tyear10;
                    oppDLoc.Mob_payroll__c =ftes.mobpayroll;    
                }
                if(ocds != null){
                    oppDLoc.Y1_Payroll__c+=ocds.Tyear1;
                    oppDLoc.Y2_Payroll__c+=ocds.Tyear2;
                    oppDLoc.Y3_Payroll__c+= ocds.Tyear3;
                    oppDLoc.Y4_Payroll__c+= ocds.Tyear4;
                    oppDLoc.Y5_Payroll__c+=ocds.Tyear5;
                    oppDLoc.Y6_Payroll__c+= ocds.Tyear6;
                    oppDLoc.Y7_Payroll__c+= ocds.Tyear7;
                    oppDLoc.Y8_Payroll__c+=ocds.Tyear8;
                    oppDLoc.Y9_Payroll__c+= ocds.Tyear9;
                    oppDLoc.Y10_Payroll__c+= ocds.Tyear10;
                    system.debug('delivery payroll '+oppDLoc.Mob_payroll__c);
                    system.debug('ocd payroll '+ocds.mobpayroll);
                    oppDLoc.Mob_payroll__c+=ocds.mobpayroll;
                }
                delMaptoupdate.put(oppDLoc.id,oppDLoc);
            }
        } 
        else if(type.equalsignorecase('fte')){
            for (AggregateResult ar :[SELECT Opportunity_Delivery_Location__c, sum(FTEYr1__c) y1,sum(FTEYr2__c)y2,sum(FTEYR3__c)y3,
                                 sum(FTEYr4__c)y4,sum(FTEYr5__c)y5,sum(FTEYr6__c)y6,sum(FTEYr7__c)y7,sum(FTEYr8__c)y8,sum(FTEYr9__c)y9,sum(FTEYr10__c) y10,
                                 sum(Baseline_FTEs__c)bftes
                                 FROM FTE_Details__c  where ID IN :newFtes  GROUP BY Opportunity_Delivery_Location__c limit 9000]) {                     
            //quantity = (decimal)ar.get('countids');
            servid = (string) ar.get('Opportunity_Delivery_Location__c');
            /*if(oppDelLocmapforFTEtotals.ContainsKey(servId)){
                oppDelLocmapforFTEtotals.get(servId);
            }
            else{
                wrapFTE = new FTEWrapper();
                wrapFTE.DelLOcId = servId;
            }*/
             wrapFTE = new FTEWrapper();
            wrapFTE.Tyear1 = (decimal)ar.get('y1');
            wrapFTE.Tyear2 = (decimal)ar.get('y2');
            wrapFTE.Tyear3 = (decimal)ar.get('y3');
            wrapFTE.Tyear4 = (decimal)ar.get('y4');
            wrapFTE.Tyear5 = (decimal)ar.get('y5');
            wrapFTE.Tyear6 = (decimal)ar.get('y6');
            wrapFTE.Tyear7 = (decimal)ar.get('y7');
            wrapFTE.Tyear8 = (decimal)ar.get('y8');
            wrapFTE.Tyear9 = (decimal)ar.get('y9');
            wrapFTE.Tyear10 = (decimal)ar.get('y10');
            wrapFTE.baselinftes = (decimal)ar.get('bftes');
           // baselineftes = (decimal) ar.get('bftes');
            /*totalsum = Tyear1+Tyear2+Tyear3+Tyear4+Tyear5+Tyear6+Tyear7+Tyear8+Tyear9+Tyear10;
            servMap.put(servid,totalsum);*/
           oppDelLocmapforFTEtotals.put(servId, wrapFTE); 
           //oppDelLocmapforFTEtotals.put(servid,Tyear1+';'+Tyear2+';'+Tyear3+';'+Tyear4+';'+Tyear5+';'+Tyear6+';'+Tyear7+';'+Tyear8+';'+Tyear9+';'+Tyear10+';'+baselineftes);
            }
            FTEWrapper ftes = new FTEWRApper();
            for(Opportunity_Delivery_Location__c oppDLoc : DelLocList){
                
                //if(oppDelLocmapforFTEtotals.ContainsKey(oppDloc.Id))
                ftes = oppDelLocmapforFTEtotals.get(oppDLoc.Id);
               
               if(ftes != null){ 
                oppDLoc.Y1_fte__c=ftes.Tyear1;
                oppDLoc.Y2_fte__c=ftes.Tyear2;
                oppDLoc.Y3_fte__c=ftes.Tyear3;
                oppDLoc.Y4_fte__c=ftes.Tyear4;
                oppDLoc.Y5_fte__c=ftes.Tyear5;
                oppDLoc.Y6_fte__c=ftes.Tyear6;
                oppDLoc.Y7_fte__c=ftes.Tyear7;
                oppDLoc.Y8_fte__c=ftes.Tyear8;
                oppDLoc.Y9_fte__c=ftes.Tyear9;
                oppDLoc.Y10_fte__c=ftes.Tyear10;
                oppDLoc.Baseline_FTE__c =ftes.baselinftes;
                delMaptoupdate.put(oppDLoc.id,oppDLoc);
               }    
            
            }
            //FTEDetailsTriggerOperations.populateDeliveryLocationBPOSE(newFtes);
        }
        else{
            FTEWrapper wrapOCD;
            for (AggregateResult ar :[SELECT Opportunity_Delivery_Location__c,  sum(Mob_Totals__c)mob, sum(Run_Yr1__c) y1,sum(Run_Yr2__c)y2,sum(Run_Yr3__c)y3,
                                 sum(Run_Yr4__c)y4,sum(Run_Yr5__c)y5,sum(Run_Yr6__c)y6,sum(Run_Yr7__c)y7,sum(Run_Yr8__c)y8,sum(Run_Yr9__c)y9,sum(Run_Yr10__c) y10
                                  FROM OTHER_COST_DETAILS__C where ID IN :newOcds AND Cost_type__c LIKE:'DNP%' GROUP BY Opportunity_Delivery_Location__c limit 9000]) {
            //quantity = (decimal)ar.get('countids');
            
            wrapOCD = new FTEWrapper();
           
            servid = (string) ar.get('Opportunity_Delivery_Location__c');
           /* if(oppDelLocmapforOCDtotals.containsKey(servID)){
                wrapOCD = oppDelLocmapforOCDtotals.get(servId);
            }
            else{
                wrapOCD = new FTEWrapper();
                wrapOCD.DelLOcId = servID;
            }*/
            wrapOCD.Tyear1=(decimal)ar.get('y1');
            wrapOCD.Tyear2=(decimal)ar.get('y2');
            wrapOCD.Tyear3=(decimal)ar.get('y3');
            wrapOCD.Tyear4=(decimal)ar.get('y4');
            wrapOCD.Tyear5=(decimal)ar.get('y5');
            wrapOCD.Tyear6=(decimal)ar.get('y6');
            wrapOCD.Tyear7=(decimal)ar.get('y7');
            wrapOCD.Tyear8=(decimal)ar.get('y8');
            wrapOCD.Tyear9=(decimal)ar.get('y9');
            wrapOCD.Tyear10=(decimal)ar.get('y10');
            wrapOCD.mobcost = (decimal)ar.get('mob');            
            /*totalsum = Tyear1+Tyear2+Tyear3+Tyear4+Tyear5+Tyear6+Tyear7+Tyear8+Tyear9+Tyear10;
            servMap.put(servid,totalsum);*/
            oppDelLocmapforOCDtotals.put(servId, wrapOCD);  
            //oppDelLocmapforOCDtotals.put(servid,Tyear1+';'+Tyear2+';'+Tyear3+';'+Tyear4+';'+Tyear5+';'+Tyear6+';'+Tyear7+';'+Tyear8+';'+Tyear9+';'+Tyear10+';'+baselineftes);
            }
                FTEWrapper ftes = new FTEWRApper();
              FTEWrapper ocds = new FTEWrapper();
            for(Opportunity_Delivery_Location__c oppDLoc : DelLocList){  
                //if(oppDelLocmapforFTEtotals.ContainsKey(oppDloc.Id))
                ocds = oppDelLocmapforOCDtotals.get(oppDLoc.Id);
                if(ocds != null){
                    oppDLoc.Y1_other_cost__c= ocds.Tyear1;
                    oppDLoc.Y2_other_cost__c= ocds.Tyear2;
                    oppDLoc.Y3_other_cost__c= ocds.Tyear3;
                    oppDLoc.Y4_other_cost__c=ocds.Tyear4;
                    oppDLoc.Y5_other_cost__c= ocds.Tyear5;
                    oppDLoc.Y6_other_cost__c=ocds.Tyear6;
                    oppDLoc.Y7_other_cost__c= ocds.Tyear7;
                    oppDLoc.Y8_other_cost__c=ocds.Tyear8;
                    oppDLoc.Y9_other_cost__c= ocds.Tyear9;
                    oppDLoc.Y10_other_cost__c=ocds.Tyear10;
                    oppDLoc.mob_cost__c =ocds.mobcost;
                    delMaptoupdate.put(oppDLoc.id,oppDLoc);
                }           
        }

     }
     try{
         database.update(delMaptoupdate.values(),true);
     }
     catch(exception e){
         system.debug('exception ---- '+e);
     }
 }
}