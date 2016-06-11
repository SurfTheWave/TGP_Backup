global class MonthlyGoLiveFTEDelete implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query= '';
        //if(!test.isrunningtest()){
            query = 'Select id,name,Opportunities__c,Delivery_Location_Text__c,Operating_Group_Text__c,Offering_Text__c, OG__c,Opportunity__c,Deal__c,Deals__c from Monthly_Go_Live_FTE__c WHERE CreatedDate != today';
        //}
        /*else{
          query = 'Select id,name,Opportunities__c,Delivery_Location_Text__c,Operating_Group_Text__c,Offering_Text__c, OG__c,Opportunity__c,Deal__c,Deals__c from Monthly_Go_Live_FTE__c';
        }*/
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Monthly_Go_Live_FTE__c> monthList){
        /*for(Monthly_Go_Live_FTE__c mon:monthList){
        }*/                               
        Database.Delete(monthList,false);
                    
    }
    global void finish(Database.BatchableContext BC){
        
        // Report data
        List<Monthly_Go_Live_FTE__c> monthlyFTEList=[SELECT Id, Name, Del_Loc_Rec__c,Go_Live_Month_Year__c, Contract_Extension_Flag__c, Opportunity_Solution_Lead__c, Deal__c, IC_Solution_Architect__c, Delivery_Location__c, Delivery_Location_Text__c, FTE__c, Go_Live_Date__c, Go_Live_Month__c, Offering__c, Offering_Text__c, OG__c, Operating_Group_Text__c, Opportunity__c, Deals__c, Opportunities__c, IO_Solution_Architect__c, BPO_Net_Rev_Thousands__c, Category__c, MMS_Id__c, Active__c, Stage__c, Geo_Region__c, IO_Net_Revenue_Thousands__c, Master_Client_Class__c, Reporting_Status__c, Offerings_BPO__c, IC_Net_Rev_Thousands__c, Risk_Level__c, SD_Covered__c, BPO_Opportunity__c, IO_Opportunity__c, IC_Opportunity__c, SAP_Modified_Date__c, SAP_Modified_Date_IC__c, SAP_Modified_Date_IO__c FROM Monthly_Go_Live_FTE__c WHERE CreatedDate = today];
        List<Monthly_Go_Live_FTE_Report__c> monthlyReport= new List<Monthly_Go_Live_FTE_Report__c>();
        for(Monthly_Go_Live_FTE__c mfte : monthlyFTEList){
            Monthly_Go_Live_FTE_Report__c rep = new Monthly_Go_Live_FTE_Report__c();
            rep.Name= mfte.Name;
            rep.Opportunity__c = mfte.Opportunity__c;
            rep.Category__c = mfte.Category__c;
            rep.OG__c = mfte.OG__c;
            rep.Offering__c = mfte.Offering__c;
            rep.Reporting_Status__c= mfte.Reporting_Status__c;
            rep.Master_Client_Class__c= mfte.Master_Client_Class__c;
            rep.Offerings_BPO__c= mfte.Offerings_BPO__c;
            rep.Stage__c= mfte.Stage__c;
            rep.Geo_Region__c= mfte.Geo_Region__c;
            
            rep.Opportunity_Solution_Lead__c= mfte.Opportunity_Solution_Lead__c;
            rep.IC_Solution_Architect__c= mfte.IC_Solution_Architect__c;
            rep.IO_Solution_Architect__c= mfte.IO_Solution_Architect__c;
            rep.BPO_Net_Revenue_Thousands__c= mfte.BPO_Net_Rev_Thousands__c;
            rep.IO_Net_Revenue_Thousands__c=  mfte.IO_Net_Revenue_Thousands__c;
            rep.IC_Net_Revenue_Thousands__c= mfte.IC_Net_Rev_Thousands__c;
            rep.Risk_Level__c= mfte.Risk_Level__c;
            rep.SD_Covered__c= mfte.SD_Covered__c;
            rep.BPO_Opportunity__c= mfte.BPO_Opportunity__c;
            rep.IO_Opportunity__c= mfte.IO_Opportunity__c;
            rep.IC_Opportunity__c= mfte.IC_Opportunity__c;
            rep.SAP_Modified_Date__c= mfte.SAP_Modified_Date__c;
            rep.SAP_Modified_Date_IC__c= mfte.SAP_Modified_Date_IC__c;
            rep.SAP_Modified_Date_IO__c= mfte.SAP_Modified_Date_IO__c;
            rep.MMS_Id__c= mfte.MMS_Id__c;
            rep.Delivery_Location__c = mfte.Delivery_Location__c ;
            rep.active__c=mfte.active__c;
            rep.Deal__c = mfte.Deal__c;
            rep.FTE__c= mfte.FTE__c;
            rep.Go_Live_Date__c= mfte.Go_Live_Date__c;
            rep.Go_Live_Month_Year__c= mfte.Go_Live_Month_Year__c;
            rep.Contract_Extension_Flag__c= mfte.Contract_Extension_Flag__c;
            monthlyReport.add(rep);
        }
        
        Database.insert(monthlyReport, true);
        // Deleting all record not created today
        Delete [Select Id FROM Monthly_Go_Live_FTE_Report__c WHERE CreatedDate != today];
        
    }
}