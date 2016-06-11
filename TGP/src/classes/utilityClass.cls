/*
Author : Harshit Shah
Story  : Story-0169/SOL_072  
Description : Utility calss for writing generic methods used as different places in the environment.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Mayank Tayal    Sol_148                    5/15/2013        Sol UAM-Release 2

*/
public  without sharing class utilityClass {
    
    /******************************
    Method Name: updateDeliverylocationinOpportunity
    Description: To save unique of all delivery locations in BPO Opportunity's field.
    Paramenters: OppIdToUpdate
    Return Value: NA
    *******************************/
    public void updateDeliverylocationinOpportunity( Id OppIdToUpdate) {    
        Opportunity_TGP__c oppToUpdateUniqueDeliveryLocation;
        String uniqueDeliveryLocationsforOpportunity = '';
        String updateOfferings = '';
        List<Opportunity_Offering__c > OppOfferingList = new List<Opportunity_Offering__c>();
        if(OppIdToUpdate!= null) {
            oppToUpdateUniqueDeliveryLocation = [select id from Opportunity_TGP__c where Id = :OppIdToUpdate];
            OppOfferingList = [select Service_Delivery_Location_Unique__c, Id, Offering_Master__r.name from Opportunity_Offering__c where Opportunity_TGP__c = :oppToUpdateUniqueDeliveryLocation.Id order by Offering_Master__r.name];
            
            if(OppOfferingList != null && OppOfferingList.size() > 0) {
                set<String> uniqueDeliveryLocationSet = new set<String>();
                set<String> uniqueOfferings = new set<String>();
                for(Opportunity_Offering__c oppOffering : OppOfferingList) {
                    /*Uodate Offieing names in BPO Opportunity - Mohan*/
                    if(updateOfferings == '')
                    updateOfferings = oppOffering.Offering_Master__r.name;
                    else
                    updateOfferings += '; ' + oppOffering.Offering_Master__r.name;
                    /*Updating delivery locations in BPO Opportunity*/  
                    if(oppOffering.Service_Delivery_Location_Unique__c != null && oppOffering.Service_Delivery_Location_Unique__c != '') {
                        String[] deliveryLocation = oppOffering.Service_Delivery_Location_Unique__c.split('; ');
                        for(String s :deliveryLocation) {
                            uniqueDeliveryLocationSet.add(s);
                        }
                    }
                }
                if(uniqueDeliveryLocationSet != null && uniqueDeliveryLocationSet.size() > 0) {
                    for(String uniqueLocation : uniqueDeliveryLocationSet) {
                        uniqueDeliveryLocationsforOpportunity += uniqueLocation + '; ';
                    }
                } 
            }
            oppToUpdateUniqueDeliveryLocation.Service_Delivery_Locations_Unique__c = uniqueDeliveryLocationsforOpportunity;
             oppToUpdateUniqueDeliveryLocation.Offerings__c = updateOfferings;
            update oppToUpdateUniqueDeliveryLocation;  
       }
    }
    
     /******************************
    Method Name: updateDeliverylocationinOpportunity
    Description: To save unique of all delivery locations in BPO Opportunity's field.
    Paramenters: OppIdToUpdate
    Return Value: NA
    *******************************/
    /*public void deleteSchedulingFromOffering( Id offeringID) {
    
       if(offeringID != null)
       { 
            List<Scheduling__c> deleteList =  [Select Id from Scheduling__c where Offerings__c = :offeringID];
            //deleteList = OppIdToDelete;
            delete deleteList ;
       }
        
    }*/
    
}