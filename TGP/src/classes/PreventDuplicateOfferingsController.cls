//***************************************************************************************************************
// Name       :  PreventDuplicateOfferingsController
// Description:  Class call from Trigger PreventDuplicateOfferings on Opportunity_Offering__c to Prevent Duplicate Offerings names created in Opp Offerings Tab
//
//             
//               
// Created By :  Shridhar Patankar
// Date       : 14/03/2013
// **************************************************************************************************************
public class PreventDuplicateOfferingsController{
    //***************************************************************************************************************
    // Method Name: offeringsNameCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other Offerings Record or not
    // Created By: Shridhar Patankar
    //***********************************************************************************************   
    public static void offeringsNameCheckInsert(){
          List<Opportunity_Offering__c> triggernew = (List<Opportunity_Offering__c>)Trigger.new;
          Map<Id,Opportunity_Offering__c> newMap = (Map<Id,Opportunity_Offering__c>)Trigger.NewMap;
          Map<Id,Opportunity_Offering__c> oldMap = (Map<Id,Opportunity_Offering__c>)Trigger.OldMap;
          List<Opportunity_Offering__c> Namecheck = new List<Opportunity_Offering__c>();
          Set<String> Namesets = new Set<String>();
          Set<String> Namesets1 = new Set<String>();
          Map<String,String> existingOfferingsmap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.offeringsNameFlag = true;
          Integer i=0;
          Integer j=0;
        
          
        if(trigger.isBefore && trigger.isInsert) { 
                // Below section filterates duplicate OfferingsMaster names in the list of OfferingsMaster names coming in bulk mode from data loader
                for(i=0;i<triggernew.size();i++){
                    Boolean intriggernew = false;
                    for(j=0;j<Namecheck.size();j++){
                        // Matching names of entries in the list coming in bulk mode                   
                        if((triggernew[i].Offering_Master__c==Namecheck[j].Offering_Master__c) && (triggernew[i].Opportunity_TGP__c==Namecheck[j].Opportunity_TGP__c) )                            
                        {
                            // Associating error with the duplicate 'OfferingsMaster name' record in the list 
                            triggernew[i].addError('Offering Name already exists');
                            intriggernew = true;                                                        
                        }                       
                        
                    }
                      if(!intriggernew){
                        // Making List of names and Set of names to check Whether OfferingsMaster Name already exists in Database or not.
                        Namecheck.add(triggernew[i]);
                        Namesets.add(triggernew[i].Offering_Master__c);
                        Namesets1.add(triggernew[i].Opportunity_TGP__c);
                   }  
                }
                if(Namecheck != null && Namecheck.size()>0){
                    
                    for(Opportunity_Offering__c existingName: [select id, Name,Offering_Master__c,Opportunity_TGP__c from Opportunity_Offering__c where Offering_Master__c=:Namesets and Opportunity_TGP__c = :Namesets1])
                    {
                        existingOfferingsmap.put(existingName.Opportunity_TGP__c ,existingName.Offering_Master__c);
                        for(Opportunity_Offering__c OfferingsRec : Namecheck){  
                            if(existingName.Offering_Master__c==OfferingsRec.Offering_Master__c && existingName.Opportunity_TGP__c ==OfferingsRec.Opportunity_TGP__c ) {
                                    //Associating error with duplicate 'OfferingsMaster name' records
                                    OfferingsRec.addError('Offering Name already exists ');
                            } 
                        }
                   }
                }
            }   
        }
        
        
        /***************************************************************************************************************
        * Method Name: offeringsNameCheckUpdate
        * Description: Before Updating Records,Checks whether Name  is already present with Other Offerings Record or not
        *Created By: Shridhar Patankar
        *****************************************************************************************************************/
    
         public static void offeringsNameCheckUpdate(){
          List<Opportunity_Offering__c> triggernew = (List<Opportunity_Offering__c>)Trigger.new;
          Map<Id,Opportunity_Offering__c> newMap = (Map<Id,Opportunity_Offering__c>)Trigger.NewMap;
          Map<Id,Opportunity_Offering__c> oldMap = (Map<Id,Opportunity_Offering__c>)Trigger.OldMap;
          List<Opportunity_Offering__c> Namecheck = new List<Opportunity_Offering__c>();
          Set<String> Namesets = new Set<String>();
          Set<String> Namesets1 = new Set<String>();
          Map<String,String> existingOfferingsmap =  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.offeringsNameFlag = true;
        
          
          if(trigger.isBefore && trigger.isUpdate) { 
            // Below section filterates duplicate Offerings names in the list of Offerings names coming in bulk mode from data loader
            // Making list OfferingsName1 with trigger.new enteries
                for(Opportunity_Offering__c OfferingsName1 : (List<Opportunity_Offering__c>)trigger.new){
                    if((trigger.isUpdate  && ((OfferingsName1.Offering_Master__c != oldMap.get(OfferingsName1.id).Offering_Master__c))))
                    {     
                        // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list OfferingsMasterName2 with trigger.new enteries
                        for(Opportunity_Offering__c OfferingsName2 : (List<Opportunity_Offering__c>)Trigger.Old){//(List<Opportunity_Offering__c>)trigger.new){  
                           // Comparing names in two lists OfferingsMasterName1 and OfferingsMasterName2 to filter duplicate names from the list
                           if(OfferingsName1.Offering_Master__c ==OfferingsName2.Offering_Master__c && OfferingsName1.Opportunity_TGP__c == OfferingsName2.Opportunity_TGP__c ) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                OfferingsName1.addError('Offerings Name already exists');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether OfferingsMaster Name already exists in Database or not.
                            Namecheck.add(OfferingsName1);
                            Namesets.add(OfferingsName1.Offering_Master__c);
                            Namesets1.add(OfferingsName1.Opportunity_TGP__c);
                             
                        }
                    }
                }
                if(Namecheck != null && Namecheck.size()>0){
                    for(Opportunity_Offering__c existingName: [select id, Name,Offering_Master__c,Opportunity_TGP__c from Opportunity_Offering__c where Offering_Master__c=:Namesets and Opportunity_TGP__c = :Namesets1])
                    {
                        existingOfferingsmap.put(existingName.Name,existingName.Offering_Master__c);
                        for(Opportunity_Offering__c OfferingsRec : Namecheck) {  
                           if(existingName.Offering_Master__c==OfferingsRec.Offering_Master__c && existingName.Opportunity_TGP__c ==OfferingsRec.Opportunity_TGP__c ){
                                // Adding error to the duplicate record
                                OfferingsRec.addError('Offering Name already exists');
                            } 
                            
                        }
                   }
                }
            }
    }
  }