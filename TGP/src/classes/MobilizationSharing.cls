public class MobilizationSharing {
    public void createSharing(List<sObject> objList,String objectName){
        set<Id> objectId=new set<Id>();
        set<Id> dealSet=new set<Id>();
        Map<Id,Id> objWithDealMap=new Map<Id,Id>();
        Map<Id,set<Id>> dealWithMobTeam=new Map<Id,set<Id>>();
        set<Id> userId=new set<Id>();
        Map<Id,set<Id>> tempMap=new Map<Id,set<Id>>();
        
        String query='';
        set<Id> tempSet=new set<Id>();
        
        if(objectName.equals('Deal_OPEX_Additional_Tracking_Level_1__share')){
            
            query='select id,ownerid from Deal_OPEX_Additional_Tracking_Level_1__c where Id in:objectId';
            for(Deal_OPEX_Additional_Tracking_Level_1__c oject:[select id,OPEX_Tracker_del__r.Mobilization_Plan__r.deal__C from Deal_OPEX_Additional_Tracking_Level_1__c where id in:objList]){
                objectId.add(oject.id);
                dealSet.add(oject.OPEX_Tracker_del__r.Mobilization_Plan__r.deal__C);
                objWithDealMap.put(oject.id,oject.OPEX_Tracker_del__r.Mobilization_Plan__r.deal__C);
            }
            dealWithMobTeam=getMobTeam(dealSet);
            
            Id batchId=database.executeBatch(new MobilizationSharingBatch(objectId,objWithDealMap,dealWithMobTeam,objectName,query));
        }else if(objectName.equals('SRAT_Additional_Tracking_Level_1__share')){
            query='select id,ownerid from SRAT_Additional_Tracking_Level_1__c where Id in:objectId';
            for(SRAT_Additional_Tracking_Level_1__c oject:[select id,SRAT_Tracker__r.Mobilization_Plan__r.deal__C from SRAT_Additional_Tracking_Level_1__c where id in:objList]){
                objectId.add(oject.id);
                dealSet.add(oject.SRAT_Tracker__r.Mobilization_Plan__r.deal__C);
                objWithDealMap.put(oject.id,oject.SRAT_Tracker__r.Mobilization_Plan__r.deal__C);
            }
            dealWithMobTeam=getMobTeam(dealSet);
            Id batchSRAT=database.executeBatch(new MobilizationSharingBatch(objectId,objWithDealMap,dealWithMobTeam,objectName,query));
        }else if(objectName.equals('Procurement_Wave_Region__share')){
            query='select id,ownerid from Procurement_Wave_Region__c where Id in:objectId';
            for(Procurement_Wave_Region__c oject:[select id,Wave__r.Mobilization_Plan__r.deal__C from Procurement_Wave_Region__c where id in:objList]){
                objectId.add(oject.id);
                dealSet.add(oject.Wave__r.Mobilization_Plan__r.deal__C);
                objWithDealMap.put(oject.id,oject.Wave__r.Mobilization_Plan__r.deal__C);
            }
            dealWithMobTeam=getMobTeam(dealSet);
            Id procBatch=database.executeBatch(new MobilizationSharingBatch(objectId,objWithDealMap,dealWithMobTeam,objectName,query));
        }else if(objectName.equals('Action__share')){
            query='select id,ownerid from Action__c where Id in:objectId';
            for(Action__c oject:[select id,deal__C from Action__c where id in:objList]){
                objectId.add(oject.id);
                dealSet.add(oject.deal__C);
                objWithDealMap.put(oject.id,oject.deal__C);
            }
            dealWithMobTeam=getMobTeam(dealSet);
            Id actionBatch=database.executeBatch(new MobilizationSharingBatch(objectId,objWithDealMap,dealWithMobTeam,objectName,query));
        }else if(objectName.equals('Issues__share')){
            query='select id,ownerid from Issues__c where Id in:objectId';
            for(Issues__c oject:[select id,deal__C from Issues__c where id in:objList]){
                objectId.add(oject.id);
                dealSet.add(oject.deal__C);
                objWithDealMap.put(oject.id,oject.deal__C);
            }
            dealWithMobTeam=getMobTeam(dealSet);
            Id actionBatch=database.executeBatch(new MobilizationSharingBatch(objectId,objWithDealMap,dealWithMobTeam,objectName,query));
        }else if(objectName.equals('Decision__share')){
            query='select id,ownerid from Decision__c where Id in:objectId';
            for(Decision__c oject:[select id,deal__C from Decision__c where id in:objList]){
                objectId.add(oject.id);
                dealSet.add(oject.deal__C);
                objWithDealMap.put(oject.id,oject.deal__C);
            }
            dealWithMobTeam=getMobTeam(dealSet);
            Id actionBatch=database.executeBatch(new MobilizationSharingBatch(objectId,objWithDealMap,dealWithMobTeam,objectName,query));
        }else if(objectName.equals('Risks__Share')){
            query='select id,ownerid from Risks__c where Id in:objectId';
            for(Risks__c oject:[select id,deal__C from Risks__c where id in:objList]){
                objectId.add(oject.id);
                dealSet.add(oject.deal__C);
                objWithDealMap.put(oject.id,oject.deal__C);
            }
            dealWithMobTeam=getMobTeam(dealSet);
            Id actionBatch=database.executeBatch(new MobilizationSharingBatch(objectId,objWithDealMap,dealWithMobTeam,objectName,query));
        }
        
    }
    
    public static Map<Id,set<Id>> getMobTeam(set<Id> dealId){
        Map<Id,set<Id>> dealWithMobTeam=new Map<Id,Set<Id>>();
        set<Id> userIdset=new set<Id>();
        
        
        for(Mobilization_team__C mobilization:[select id,Primary_Lead__r.user__C,Primary_Lead__r.user__r.isActive,Secondary_Lead_1__r.user__c,Secondary_Lead_1__r.user__r.isActive,Secondary_Lead_2__r.user__c,Secondary_Lead_2__r.user__r.isActive,deal__C,deal__r.ownerid from Mobilization_team__c where deal__c in:dealId]){
             if(dealWithMobTeam.containsKey(mobilization.deal__c)){
                 userIdset=dealWithMobTeam.get(mobilization.deal__c);
             }else{
                 userIdset=new set<Id>();
             }
                 if(mobilization.Primary_Lead__r.user__r.isActive){
                    userIdset.add(mobilization.Primary_Lead__r.user__C);    
                 }
                 
                 if(!String.isEmpty(mobilization.Secondary_Lead_1__r.user__c) && mobilization.Secondary_Lead_1__r.user__r.isActive){
                     userIdset.add(mobilization.Secondary_Lead_1__r.user__c);
                 }
                 if(!String.isEmpty(mobilization.Secondary_Lead_2__r.user__c) && mobilization.Secondary_Lead_2__r.user__r.isActive){
                    userIdset.add(mobilization.Secondary_Lead_2__r.user__c);
                 }
                 userIdset.add(mobilization.deal__r.ownerid);
                 dealWithMobTeam.put(mobilization.deal__C,userIdset);
        }
        
        return dealWithMobTeam;
        
    }
}