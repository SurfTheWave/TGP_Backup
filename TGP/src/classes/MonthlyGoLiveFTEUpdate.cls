/*
 * @Author: Aswajit
 * @CreatedDate: 10/12/2015
 * @Description: This Batch class will update monthly go live details. 
 */
global class MonthlyGoLiveFTEUpdate implements Database.Batchable<sObject>{
    /*
     * @Author: Aswajit
     * @CreatedDate: 10/12/2015
     * @Description:  
     * @Name : start
     */
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query= 'Select id,name,MMS_Id__c,Delivery_Location_Text__c,Go_Live_Month_Year__c, Del_Loc_Rec__c, Contract_Extension_Flag__c, opportunity__C, Opportunity_Solution_Lead__c,IC_Solution_Architect__c, IO_Solution_Architect__c, BPO_Net_Rev_Thousands__c, IO_Net_Revenue_Thousands__c, IC_Net_Rev_Thousands__c,Risk_Level__c,SD_Covered__c, BPO_Opportunity__c, IO_Opportunity__c, IC_Opportunity__c, SAP_Modified_Date__c, SAP_Modified_Date_IC__c, SAP_Modified_Date_IO__c,OG__c,Deal__c,Reporting_Status__c,Offerings_BPO__c,Master_Client_Class__c,Stage__c,Geo_Region__c from Monthly_Go_Live_FTE__c WHERE CreatedDate = today';
        return Database.getQueryLocator(query);
    }
    
    /*
     * @Author: Aswajit
     * @CreatedDate: 10/12/2015
     * @Description:  
     * @Name : execute
     */
    global void execute(Database.BatchableContext BC, List<Monthly_Go_Live_FTE__c> monthList){
        Set<String> mmsIdSet = new Set<String>();
        List<id> optyIDSet=new List<ID>();
        Set<Id> dealIds= new Set<Id>();
        for(Monthly_Go_Live_FTE__c mon:monthList){
            if(mon.opportunity__c != null){
                  optyIDSet.add(mon.opportunity__c);
            }
            /*if(mon.MMS_Id__c != null ){
                mmsIdSet.add(mon.MMS_Id__c);
            }*/
            if(mon.Deal__c != null){
                dealIds.add(mon.Deal__c);
            }
        }
        
        Map<String,Opportunity> oppMap=new Map<String,Opportunity>();
        Map<String,Opportunity> oppMapSap=new Map<String,Opportunity>();
        
        Map<String,Deal__c> dealMap = new Map<String, Deal__c>();
        Map<String,Id> locationMap = new Map<String, Id>();
    
        Set<String> mmsIds = new Set<String>();
        Map<String, String> mmsMap = new Map<String, String>();
        List<Id> oppIds = new List<Id>();
        for(Deal__c deal: [Select Id, Name, SAP_OM_ID__c, Opportunity__c From Deal__c WHERE Id IN:dealIds]){
            //dealMap.put(deal.SAP_OM_ID__c, deal);
            if(deal.Opportunity__c != null){
                oppIds.add(deal.Opportunity__c);
                mmsIds.add(deal.SAP_OM_ID__c);
                mmsMap.put(deal.Id, deal.SAP_OM_ID__c);
            }
        }
        optyIDSet.addAll(oppIds);
        Map<String,Opportunity> oppMMsMap=new Map<String,Opportunity>();
        for(Opportunity opp:[Select Id,Name,SAP_OM_ID__c,Deal__c,Contract_Extension_Flag__c, Opportunity_Solution_Lead__c,IC_Solution_Architect__c, IO_Solution_Architect__c, BPO_Net_Rev_Thousands__c, IO_Net_Revenue_Thousands__c, IC_Net_Rev_Thousands__c,Risk_Level__c,SD_Covered__c, BPO_Opportunity__c, IO_Opportunity__c, IC_Opportunity__c, SAP_Modified_Date__c, SAP_Modified_Date_IC__c, SAP_Modified_Date_IO__c,OperatingGroup__c,Off__c,Pri_Off__r.Offering_Master__c, Geo_Region__c,Reporting_Status__c,Master_Client_Class__c,StageName From Opportunity WHERE ID IN:optyIDSet OR SAP_OM_ID__c IN: mmsIds]){
            oppMap.put(opp.ID, opp);
            /*if(!optyIDSet.contains(opp.ID))
                oppMapSap.put(opp.SAP_OM_ID__c, opp);*/
            if(opp.SAP_OM_ID__c != null){
                oppMMsMap.put(opp.SAP_OM_ID__c, opp);
            }
            if(opp.Deal__c != null){
                oppMapSap.put(opp.Deal__c, opp);
            }
        } 
        
        //System.debug('oppMapSap ------------'+ oppMapSap.size());
        for(Delivery_Location_Masters__c location : [Select Id,Name from Delivery_Location_Masters__c]){
            locationMap.put(location.Name, location.Id);
        }
        
        for(Monthly_Go_Live_FTE__c mfte:monthList){
            Opportunity opps;
            if(mfte.opportunity__c != null){
                //System.debug('----oppMap ---- get--------'+ oppMap.get(mfte.opportunity__c));
                opps = oppMap.get(mfte.opportunity__c);
            }else if(mfte.Deal__c != null){ 
                if(oppMapSap != null){
                    //System.debug('oppMapSap.get(mfte.MMS_Id__c) --------------'+oppMapSap.get(mfte.MMS_Id__c));
                    opps = oppMapSap.get(mfte.Deal__c);
                    if(opps == null){
                        opps = oppMMsMap.get(mmsMap.get(mfte.Deal__c));
                    }
                }
            }
            String month='';
            if(Date.parse(mfte.Go_Live_Month_Year__c).month() <= 9){
               month='0'+ Date.parse(mfte.Go_Live_Month_Year__c).month();
            }else{
               month= String.valueOf(Date.parse(mfte.Go_Live_Month_Year__c).month());
            }
            mfte.Go_Live_Month_Year__c = Date.parse(mfte.Go_Live_Month_Year__c).year() +'/'+month ;
            //System.debug('opps -------------'+ opps);
            if(opps != null){
                mfte.Opportunity__c = opps.Id;
                mfte.Deal__c =  mfte.Deal__c != null ? mfte.Deal__c : opps.Deal__c;
                mfte.OG__c = opps.OperatingGroup__c;
                mfte.Offering__c = opps.Pri_Off__r.Offering_Master__c;
                mfte.Reporting_Status__c= opps.Reporting_Status__c;
                mfte.Master_Client_Class__c= opps.Master_Client_Class__c;
                mfte.Offerings_BPO__c= opps.Off__c;
                mfte.Stage__c= opps.StageName;
                mfte.Geo_Region__c= opps.Geo_Region__c;
                
                mfte.Opportunity_Solution_Lead__c= opps.Opportunity_Solution_Lead__c;
                mfte.IC_Solution_Architect__c= opps.IC_Solution_Architect__c;
                mfte.IO_Solution_Architect__c= opps.IO_Solution_Architect__c;
                mfte.BPO_Net_Rev_Thousands__c= opps.BPO_Net_Rev_Thousands__c;
                mfte.IO_Net_Revenue_Thousands__c= opps.IO_Net_Revenue_Thousands__c;
                mfte.IC_Net_Rev_Thousands__c= opps.IC_Net_Rev_Thousands__c;
                mfte.Risk_Level__c= opps.Risk_Level__c;
                mfte.SD_Covered__c= opps.SD_Covered__c;
                mfte.BPO_Opportunity__c= opps.BPO_Opportunity__c;
                mfte.IO_Opportunity__c= opps.IO_Opportunity__c;
                mfte.IC_Opportunity__c= opps.IC_Opportunity__c;
                mfte.SAP_Modified_Date__c= opps.SAP_Modified_Date__c;
                mfte.SAP_Modified_Date_IC__c= opps.SAP_Modified_Date_IC__c;
                mfte.SAP_Modified_Date_IO__c= opps.SAP_Modified_Date_IO__c;
                mfte.MMS_Id__c= opps.SAP_OM_ID__c;
                String location = mfte.Delivery_Location_Text__c != null  ? mfte.Delivery_Location_Text__c : mfte.Del_Loc_Rec__c;
                mfte.Delivery_Location__c = locationMap.get(location);
                mfte.active__c=true;
                mfte.Contract_Extension_Flag__c= opps.Contract_Extension_Flag__c;
                        
            }
        }
        Database.update(monthList,true);
    }
    /*
     * @Author: Aswajit
     * @CreatedDate: 10/12/2015
     * @Description:  
     * @Name : finish
     */
    global void finish(Database.BatchableContext BC){
        Map<String, ID> actualMap= new Map<String, ID>();
        for(Monthly_Go_Live_FTE__c Actual: [Select Id, MMS_Id__c FROM Monthly_Go_Live_FTE__c Where category__C='0.00' AND  MMS_Id__c <> NULL ]){
            actualMap.put( Actual.MMS_Id__c, Actual.Id);
        }
        Set<Id> oppCategoryIds = new Set<id>();
        Map<String, Monthly_Go_Live_FTE__c> oppMap = new Map<String, Monthly_Go_Live_FTE__c>(); 
        List< Monthly_Go_Live_FTE__c> monthList = New List<Monthly_Go_Live_FTE__c>();

        for(Monthly_Go_Live_FTE__c mfte: [Select id,category__C, name,MMS_Id__c,Delivery_Location_Text__c,Opportunity_Solution_Lead__c,IC_Solution_Architect__c, IO_Solution_Architect__c, BPO_Net_Rev_Thousands__c, IO_Net_Revenue_Thousands__c, IC_Net_Rev_Thousands__c,Risk_Level__c,SD_Covered__c, BPO_Opportunity__c, IO_Opportunity__c, IC_Opportunity__c, SAP_Modified_Date__c, SAP_Modified_Date_IC__c,Opportunity__c, SAP_Modified_Date_IO__c,OG__c,Deal__c,Reporting_Status__c,Offerings_BPO__c,Master_Client_Class__c,Stage__c,Geo_Region__c from Monthly_Go_Live_FTE__c  ORDER BY createdDate ASC LIMIT 10000]){
            if(mfte.category__C=='1.00'){
                oppCategoryIds.add(mfte.Opportunity__c);
                oppMap.put(mfte.Opportunity__c, mfte);
                if(actualMap.get(mfte.MMS_ID__C) <> NULL ){
                    mfte.active__C= false;
                }else{
                    mfte.active__C=true;                        
                }
            }
            monthList.add(mfte);
        }
        //System.debug('monthList --------------size-'+ monthList.size());
        Database.update(monthList,true);
        //Database.executeBatch(new MonthlyGoLiveBaselineFTEUpdate());
        
        MonthlyGoLiveFTEDelete dte = new MonthlyGoLiveFTEDelete();
        Database.executeBatch(dte);
    }
   
}