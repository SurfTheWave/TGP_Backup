/*
@Author : Jyotsna Yadav
@name : operationsOnDealReviewNoteController
@CreateDate : 3/2/2015 
@Description : 
@Version : 
*/
public without sharing class operationsOnDealReviewNoteController{
    public static Map<Id,Deal_Review_Notes__c> oldMap;
    public static Map<Id,Deal_Review_Notes__c> newMap;
    public static Map<String,Integer> statusCountMapBI = new Map<String,Integer>();
    public static Map<String,Integer> statusCountMap = new Map<String,Integer>();
/*
  @Author: 
  @Name: getAllData
  @Created Date: 01 January 2015
  @Description: This is a static method getAllData for fetching all the data using quary.
  @version: 1.0
*/
    public static void getAllData(List<Deal_Review_Notes__c> newDeals){
        Integer count=0;
        
        Set<Id> commercialIds = new Set<Id>();
        for( Deal_Review_Notes__c deal : newDeals){
            commercialIds.add( deal.Opportunity_Commerical_Data__c );
        }
        for( Commercial_Data__c commData : [ Select Id,name,( Select Approval_Stage__c from Deal_Review_Notes__r LIMIT 5000) from Commercial_Data__c where Id IN:commercialIds limit 5000] ){
            for( Deal_Review_Notes__c dealRevNote :  commData.Deal_Review_Notes__r){
                if(statusCountMap.containsKey(dealRevNote.Approval_Stage__c+commData.Id)){
                    count = statusCountMap.get( dealRevNote.Approval_Stage__c+commData.Id );
                    statusCountMap.put( dealRevNote.Approval_Stage__c+commData.Id,count+1 );
                    count=0;
                }else{
                    statusCountMap.put( dealRevNote.Approval_Stage__c+commData.Id,1 );
                }
            }
        }
        
    }
 /*
@name : validateBeforeInsertUpdate
@param : List<Deal_Review_Notes__c> newDeals
@Description : 
@Version : 
*/   

    public static void validateBeforeInsertUpdate(List<Deal_Review_Notes__c> newDeals){
        
        getAllData( newDeals );
        for( Deal_Review_Notes__c dealNote : newDeals ){
            //system.debug('*******************'+statusCountMap.get(dealNote.Approval_Stage__c+dealNote.Opportunity_Commerical_Data__c));
            if( statusCountMap.containsKey( dealNote.Approval_Stage__c+dealNote.Opportunity_Commerical_Data__c ) && statusCountMap.get(dealNote.Approval_Stage__c+dealNote.Opportunity_Commerical_Data__c) > 2){
                dealNote.addError(UtilConstants.ERROR_MSG_PART1 +dealNote.Approval_Stage__c+UtilConstants.ERROR_MSG_PART2);
            }
            //statusCountMapBI.get(dealNote.Approval_Stage__c)+;
            
        }
    }
    
    
}