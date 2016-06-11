global class RefreshSyncStatus{
  
    @RemoteAction
    global static Map<string,string> checkStatus(){
    Map<id,Sync_Status__c> syncStatusDetailMap= new Map<id,Sync_Status__c>();
    set<id> opportunityID=new set<id>();
    Map<string,string> pagr= new Map<string,string>();
    List<Sync_Status__c> syncStatusDetailList= [SELECT id,Opportunity__c,Sync_Status_BPO__c,Sync_Status_IO__c,Last_Synced_User__c from Sync_Status__c where (Sync_Status_BPO__c=2 OR Sync_Status_IO__c=2) AND (Last_Synced_By__r.user__c =:userinfo.getuserid() OR Last_Synced_By_IO__r.user__c =:userinfo.getuserid())];           
    for(Sync_Status__c ss : syncStatusDetailList){
            opportunityID.add(ss.Opportunity__c);
            syncStatusDetailMap.put(ss.Opportunity__c, ss);
    }
    List<Costing_Request__c> costDetailList= [SELECT id,Opportunity__c,Opportunity__r.name,Opportunity__r.SAP_OM_Item_Id__r.Name,Checked_Out_By__c,Checked_Out_By_IO__c,In_Progress__c,In_Progress_IO__c,In_Sync__c,In_Sync_IO__c from Costing_Request__c where Opportunity__c=:opportunityID ];   
    if(costDetailList!=null){  
        for(Costing_Request__c cr: costDetailList){          
           if(syncStatusDetailMap.get(cr.Opportunity__c).Sync_Status_BPO__c != Integer.valueof(cr.In_Progress__c) || syncStatusDetailMap.get(cr.Opportunity__c).Sync_Status_IO__c != Integer.valueof(cr.In_Progress_IO__c)){
                if((Integer.valueof(cr.In_Progress__c)==1)||(Integer.valueof(cr.In_Progress_IO__c)==1)){                    
                    pagr.put('Opportunity ID : '+cr.Opportunity__r.SAP_OM_Item_Id__r.Name+', '+' Opportunity Name :'+cr.Opportunity__r.name+', ','  Status: Sync Success');                                             
                }
                else if((Integer.valueof(cr.In_Progress__c)==0)||(Integer.valueof(cr.In_Progress_IO__c)==0)){                                      
                    pagr.put('Opportunity ID : '+cr.Opportunity__r.SAP_OM_Item_Id__r.Name +', '+' Opportunity Name :'+cr.Opportunity__r.name+', ','  Status: Sync Failed');                                          
                }
            }
        }
        Return pagr;
    }
    return null;
    }
    public void finalAction(){
        Map<id,Sync_Status__c> syncStatusDetailMap= new Map<id,Sync_Status__c>();
        set<id> opportunityID=new set<id>();
        List<Sync_Status__c> syncStatusDetailList= [SELECT id,Opportunity__c,Sync_Status_BPO__c,Sync_Status_IO__c,Last_Synced_User__c from Sync_Status__c where (Sync_Status_BPO__c=2 OR Sync_Status_IO__c=2) AND (Last_Synced_By__r.user__c =:userinfo.getuserid() OR Last_Synced_By_IO__r.user__c =:userinfo.getuserid())];           
        for(Sync_Status__c ss : syncStatusDetailList){
            opportunityID.add(ss.Opportunity__c);
            syncStatusDetailMap.put(ss.Opportunity__c, ss);
        }
        List<Costing_Request__c> costDetailList= [SELECT id,Opportunity__c,Opportunity__r.name,Opportunity__r.SAP_OM_Item_Id__r.Name,Checked_Out_By__c,Checked_Out_By_IO__c,In_Progress__c,In_Progress_IO__c,In_Sync__c,In_Sync_IO__c from Costing_Request__c where Opportunity__c=:opportunityID ]; 
        if(costDetailList!=null){  
            for(Costing_Request__c cr: costDetailList){          
               if(syncStatusDetailMap.get(cr.Opportunity__c).Sync_Status_BPO__c != Integer.valueof(cr.In_Progress__c) || syncStatusDetailMap.get(cr.Opportunity__c).Sync_Status_IO__c != Integer.valueof(cr.In_Progress_IO__c)){
                   syncStatusDetailMap.get(cr.Opportunity__c).Sync_Status_BPO__c=  Integer.valueof(cr.In_Progress__c);
                   syncStatusDetailMap.get(cr.Opportunity__c).Sync_Status_IO__c =  Integer.valueof(cr.In_Progress_IO__c);  
                }
            }
        update syncStatusDetailMap.values();
        }
    }
}