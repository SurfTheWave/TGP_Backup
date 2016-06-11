/**
   @Author : Jayashree Pradhan
   @Trigger name : operationOnDeliveryLocationTrigger
   @CreateDate : 12 December 2014
   @Description : Trigger to populate delivery location field on service record
   @Version : 1.0
   */
trigger operationOnDeliveryLocationTrigger on Opportunity_Delivery_Location__c(before insert, before update, after delete, after insert, after update) {
    if(SWBBPOSEIntegrationConstants.rundeliverylocationtrigger){
    if (trigger.isAfter) {
        if (trigger.isInsert || trigger.isUpdate ) {
            AP01_OpportunityDeliveryLocation.updateOppDeliveryLocation(Trigger.new);
            AP01_OpportunityDeliveryLocation.updateDeliverylocOnOpp(Trigger.new);
            
        }
        if (trigger.isDelete ) {
           // AP01_OpportunityDeliveryLocation.updateOppDeliveryLocation(Trigger.old);
            AP01_OpportunityDeliveryLocation.updateDeliverylocOnOpp(Trigger.old);
        }
    }
    if (trigger.isBefore) {
        //Added By Aswajit
        Map<String,id> countryMap=new Map<String,id>();
        for(Country_Master__c cm:[SELECT Id, Name FROM Country_Master__c WHERE active__c =true]){
            countryMap.put(cm.Name, cm.Id);
        }
        if (trigger.isInsert) {
            AP01_OpportunityDeliveryLocation.validateDeliveryLocation(Trigger.new);
            //added By Aswajit
            for(Opportunity_Delivery_Location__c oppDeliveryRec: Trigger.new){
            
                if(String.isNotBlank(oppDeliveryRec.Country_Location__c)){
                    if(oppDeliveryRec.Country_Location__c.length() > 1){
                        String country;
                        if(oppDeliveryRec.Country_Location__c.contains(' - ') ){
                            country= oppDeliveryRec.Country_Location__c.split(' - ')[0];
                        }else if(oppDeliveryRec.Country_Location__c.contains('-')){
                           country= oppDeliveryRec.Country_Location__c.split('-')[0]; 
                        }
                        if(country != null){   
                            oppDeliveryRec.Country__c = countryMap.get(country);
                        }
                    }
                }
            }
        }
        if (trigger.isupdate) {
            for(Opportunity_Delivery_Location__c oppDeliveryRec: Trigger.new){
                if(String.isNotBlank(oppDeliveryRec.Country_Location__c)){
                    if(oppDeliveryRec.Country_Location__c.length() > 1){
                        String country;
                        if(oppDeliveryRec.Country_Location__c.contains(' - ') ){
                            country= oppDeliveryRec.Country_Location__c.split(' - ')[0];
                        }else if(oppDeliveryRec.Country_Location__c.contains('-')){
                           country= oppDeliveryRec.Country_Location__c.split('-')[0]; 
                        }
                        if(country != null){   
                            oppDeliveryRec.Country__c = countryMap.get(country);
                        }
                    }
                }
            }
            List<Opportunity_Delivery_Location__c> oppDelLocList = new List<Opportunity_Delivery_Location__c>();
            for( Opportunity_Delivery_Location__c oppDelLoc : trigger.new ){
                if(oppDelLoc.Delivery_Location__c != trigger.oldMap.get(oppDelLoc.Id).Delivery_Location__c ){
                    oppDelLocList.add( oppDelLoc );
                }
            }
            if(!oppDelLocList.isEmpty() ){
                AP01_OpportunityDeliveryLocation.validateDeliveryLocation(oppDelLocList);
            }
            if(SWBBPOSEIntegrationConstants.rundeliverylocationtrigger){
             AP01_OpportunityDeliveryLocation.restrictDeliveryLocationupdate(trigger.new, trigger.oldMap);
            }
        }
    }
   }
}