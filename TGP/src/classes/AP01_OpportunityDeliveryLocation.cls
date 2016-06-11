/**
   @Author : Jayashree Pradhan
   @name   : AP01_OpportunityDeliveryLocation
   @CreateDate : 22 December 2014
   @Description : TriggerHandler Class for triggers on Opportunity Delivery Location object
   @Version : 1.0
  */
/******************
 * @class name : AP01_OpportunityDeliveryLocation 
 * @purpose :
 ******************/
public with sharing class AP01_OpportunityDeliveryLocation {
    /**
   *  @Description : This method is used to update opportunity record when any solution component record is added
   *  @name : updateOpportunityRecords
   *  @param : List<Opportunity_Delivery_Location__c> deliveryLocList
   *  @return parameter - void
   *  @throws exception-DML Exception
   */
public static void updateOppDeliveryLocation(List<Opportunity_Delivery_Location__c> deliveryLocList){
        set<ID> serviceIds = new set<ID>();
        List<Service__c> serviceListToUpdate = new List<Service__c>();
        for(Opportunity_Delivery_Location__c deliveryLocRec : deliveryLocList){
            serviceIds.add(deliveryLocRec.Offering_Service__c);
        }
        for(Service__c serviceRec : [select id,name,Delivery_Locations__c,(select id, name, Delivery_Location__c,
                                    Delivery_Location__r.name,Offering_Service__c from 
                                    Opportunity_Delivery_Locations__r where Active__c =: true order by createdDate asc ) 
                                    from Service__c where id IN : serviceIds LIMIT 5000]){
            String deliveryLocationList = UtilConstants.EMPTY_STRING;
            if(serviceRec.Opportunity_Delivery_Locations__r.size() > 0){
                
                for(Opportunity_Delivery_Location__c oppDeliveryLocation : serviceRec.Opportunity_Delivery_Locations__r){
                    if(String.IsNotBlank(oppDeliveryLocation.Delivery_Location__r.name)){
                        deliveryLocationList += oppDeliveryLocation.Delivery_Location__r.name + UtilConstants.SEMICOLON_STRING;
                    }
                }
                System.debug('====deliveryLocationList1 '+deliveryLocationList );
            }
            
            
            System.debug('====deliveryLocationList2 '+deliveryLocationList );
            serviceRec.Delivery_Locations__c = deliveryLocationList.removeEnd(UtilConstants.SEMICOLON_STRING);
            serviceListToUpdate.add(serviceRec);
        }
        if(serviceListToUpdate.size()>0){
            try{
                update serviceListToUpdate;
            }
            catch(DMLException dme){
                //System.debug('exception Occured'+dme.getMessage());
            }
        }
    }
    
    /**
   *  @Description : This method is used to update Opportunity record when any service record is added/deleted
   *  @name : updateService
   *  @param : List<Service__c> serviceList
   *  @return parameter - void
   *  @throws exception- DML Exception
   **/
   public static void updateDeliverylocOnOpp(List<Opportunity_Delivery_Location__c> deliveryLocList){
     try{
     set<ID> oppIds = new set<ID>();
     set<ID> serviceID = new set<ID>();
     set<String> locNameBPO;
     set<String> locNameIO;
     set<String> locNameIC;
     List<Opportunity> oppToUpdate = new List<Opportunity>();
     List<Opportunity> oppToUpdateIO = new List<Opportunity>();
     List<Opportunity> oppToUpdateIC = new List<Opportunity>();
     // Prepare Opportunity Id Set

     for(Opportunity_Delivery_Location__c dl: deliveryLocList){
        serviceID.add(dl.Offering_Service__c);
     }
     system.debug('lala'+serviceID);
     
     for(Service__c ser :[select id, Solutionscope__r.Opportunity__c from Service__c where ID IN: serviceID]){
        oppIds.add(ser.Solutionscope__r.Opportunity__c);
     }
     system.debug('kaka'+oppIds);
     // Quering All the Delivery Locations for the Opportunities in the Set
     List<Opportunity_Delivery_Location__c> deliveryListqueried = /*[Select id,Name,Delivery_Location__r.Name,
                                                                  Offering_Service__r.Solutionscope__r.Opportunity__c,
                                                                  Offering_Service__r.Solutionscope__r.Service_Group__c
                                                                  from Opportunity_Delivery_Location__c where Offering_Service__r.Solutionscope__r.Opportunity__c IN:
                                                                  oppIds];*/ new list<Opportunity_Delivery_Location__c>();
     deliveryListqueried = masterqueries.querydeliverylocs(oppIds);                                                                 
     system.debug('All the locations:'+deliveryListqueried.size());

     List<Opportunity> oppList = /*[Select Id,Name,Delivery_Locations__c,Delivery_Locations_IC__c,Delivery_Locations_IO__c
                                 from Opportunity where ID IN : oppIds]; */ new list<Opportunity>();
     oppList = masterqueries.queryoppdeliveryloc(oppIds);
     String deliveryLocationListBPO = UtilConstants.EMPTY_STRING;
     String deliveryLocationListIO = UtilConstants.EMPTY_STRING;
     String deliveryLocationListIC = UtilConstants.EMPTY_STRING;                           
     for(Opportunity opp : oppList){
        locNameBPO = new Set<String>();
        locNameIO = new Set<String>();
        locNameIC = new Set<String>();

         for(Opportunity_Delivery_Location__c devLoc : deliveryListqueried){
            
             if(devLoc.Offering_Service__r.Solutionscope__r.Opportunity__c == opp.id && UtilCOnstants.BPO.equals(devLoc.Offering_Service__r.Solutionscope__r.Service_Group__c)){
                 locNameBPO.add(devLoc.Delivery_Location__r.name);  
                 system.debug('locNameBPO:'+locNameBPO);         
             }
             else if(devLoc.Offering_Service__r.Solutionscope__r.Opportunity__c == opp.id && UtilConstants.IO.equals(devLoc.Offering_Service__r.Solutionscope__r.Service_Group__c)){
                 locNameIO.add(devLoc.Delivery_Location__r.name);
                 system.debug('locNameIO:'+locNameIO);   
                 //deliveryLocationListIO += UtilConstants.SEMICOLON_STRING + devLoc.Delivery_Location__r.name;                
             }
             else if(devLoc.Offering_Service__r.Solutionscope__r.Opportunity__c == opp.id && UtilConstants.IC.equals(devLoc.Offering_Service__r.Solutionscope__r.Service_Group__c)){
                 locNameIC.add(devLoc.Delivery_Location__r.name); 
                 system.debug('locNameIC:'+locNameIC);  
                 //deliveryLocationListIC += UtilConstants.SEMICOLON_STRING + devLoc.Delivery_Location__r.name;                
             }
         }
        if(locNameBPO.size()>0){
            for(String s:locNameBPO){
                deliveryLocationListBPO += UtilConstants.SEMICOLON_STRING + s;
            }
             
        }
        if(locNameIO.size()>0){
            for(String s:locNameIO){
                deliveryLocationListIO += UtilConstants.SEMICOLON_STRING + s;
            }
            system.debug('deliveryLocationListIO :'+deliveryLocationListIO );
        }
        if(locNameIC.size()>0){
            for(String s:locNameIC){
                deliveryLocationListIC += UtilConstants.SEMICOLON_STRING + s;
            }
            
        }

         if(deliveryLocationListBPO != null) // && opp.Delivery_Locations__c != null)
        {
             opp.Delivery_Locations__c = deliveryLocationListBPO.removeStart(UtilCOnstants.DELIMITER);
             //oppToUpdateBPO.add(opp);
             system.debug('And his momma cried:'+opp.Delivery_Locations__c);
         }
         
         
         if(deliveryLocationListIO != null){
         opp.Delivery_Locations_IO__c = deliveryLocationListIO.removeStart(UtilCOnstants.DELIMITER);
         //oppToUpdateIO.add(opp);
         system.debug('(Chorous1) in the Ghetto:'+oppToUpdateIO);
         system.debug('(Chorous11) in the Ghetto:'+oppToUpdateIO.size());
         }
         if(deliveryLocationListIC != null){
         opp.Delivery_Locations_IC__c = deliveryLocationListIC.removeStart(UtilCOnstants.DELIMITER);
         //oppToUpdateIC.add(opp);
         system.debug('(Chorous) in the Ghetto:'+opp.Delivery_Locations__c);
         }
        oppToUpdate.add(opp);        
     }
     if(oppToUpdate.size()>0){
         update oppToUpdate;
     }
    /* system.debug('Dosent matteor: '+oppToUpdateIO.size());
     if(oppToUpdateIO.size()>0){
     system.debug('Rest everything is not: '+oppToUpdateIO.size());    
         update oppToUpdateIO;
     }
     if(oppToUpdateIC.size()>0){
         update oppToUpdateIC;
     }*/
     }
     Catch(Exception e){
         string exception_caught = string.valueof(e);
         system.debug('-----'+exception_caught); 
         system.debug('E==='+e);
     }
        
 }

 
 
/**
   *  @Description : This method is used to prevent duplicate delivery location
   *  @name : validateDeliveryLocation
   *  @param : List<Opportunity_Delivery_Location__c> deliveryLocList
   *  @return parameter - void
   *  @throws exception-DML Exception
*/    
    public static void validateDeliveryLocation(List<Opportunity_Delivery_Location__c> deliveryLocList){
        try{
        //System.debug('-------deliveryLocList-------'+deliveryLocList);
        Set<Id> serviceIds = new Set<Id>();
        for(Opportunity_Delivery_Location__c oppDelivery : deliveryLocList){
            serviceIds.add(oppDelivery.Offering_Service__c);    
        }
        List<Opportunity_Delivery_Location__c> oppDeliveryLoc = [Select Id,Name,Offering_Service__c,Delivery_Location__c,Delivery_Location__r.Name From Opportunity_Delivery_Location__c 
                                                                 where Offering_Service__c IN : serviceIds LIMIT 5000];
        for(Opportunity_Delivery_Location__c oppDeliveryRec : deliveryLocList){
            for(Opportunity_Delivery_Location__c oppDev : oppDeliveryLoc){
                if(oppDev.Offering_Service__c == oppDeliveryRec.Offering_Service__c){
                    if(oppDev.Delivery_Location__c == oppDeliveryRec.Delivery_Location__c){
                        oppDeliveryRec.addError(UtilConstants.OPP_ERROR1);
                    }   
                }
            }   
        }
      }
      Catch(Exception e)
      {
          String stri=e.getMessage();
      }     
    }     
/**
   *  @method : restrictDeliveryLocationupdate
   *  @param : List<Opportunity_Delivery_Location__c> deliveryLocList, map<id ,Opportunity_Delivery_Location__c> oldmap
   *  @return parameter - void
   *  @Description:
   *  @Modified reason: Opportunity owner not able to edit dlivery location ticket-676
*/         
    public static void restrictDeliveryLocationupdate(List<Opportunity_Delivery_Location__c> deliveryLocList,map<id,Opportunity_Delivery_Location__c> oldmap){
        try{
        user loggedinuser = [select id,profile.name,UserRole.name from user where id=:Userinfo.getUserID() Limit 1];
            //System.debug('Profile Name:::'+loggedinuser.profile.name+'::::; Role ' +loggedinuser.UserRole.name);
        set<id> oppids = new set<id>();
        set<id> oppteamids = new set<id>();
        Set<Id> oppOwnerIds = new Set<Id>();
        for(Opportunity_Delivery_Location__c oppdLoc: [select Offering_Service__r.Solutionscope__r.opportunity__c from Opportunity_Delivery_Location__c where ID IN:deliveryLocList LIMIT 2500]){
            oppids.add(oppdLoc.Offering_Service__r.Solutionscope__r.opportunity__c);
            //added aswajit
            oppOwnerIds.add(oppdLoc.Offering_Service__r.Solutionscope__r.opportunity__r.ownerId);
        }
        if(!oppids.isEmpty()){
            for(Opportunity_Teams__c oppteam:[select id,Opportunity_Team_Member__r.user__c from Opportunity_Teams__c where Opportunity__c IN:oppids LIMIT 2500]){
                oppteamids.add(oppteam.Opportunity_Team_Member__r.user__c);
            } 
            
        }
         for(Opportunity_Delivery_Location__c oppdLoc: deliveryLocList){
            if(!oppteamids.isEmpty()){
              if(!loggedinuser.profile.name.equalsignorecase(Label.Solution_Operations_Profile_Name) && !loggedinuser.profile.name.equalsignorecase(Label.System_Admin_Profile) && !oppOwnerIds.contains(loggedinuser.Id)){
                  if(loggedinuser.userrole.name != null && !loggedinuser.userrole.name.equalsignorecase(label.Solution_Leadership_Role)){
                      if(!oppteamids.contains(loggedinuser.id)){
                          oppdLoc.addError(UtilConstants.OPP_ERROR2);
                      }
                  }
              }
              else{
                  
              }
            }
        }
        
       }
       Catch(Exception e)
       {
           String str=e.getMessage();
       }
       
    }
    
    }