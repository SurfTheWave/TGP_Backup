//***************************************************************************************************************
// Name       :  PreventDuplicateDealName
// Description:  Controller of Trigger on Deal_TGP__c to Prevent Duplicate deal names 
//
//             
//               
// Created By :  Malkeet Singh
// Date       : 08/03/2013
// **************************************************************************************************************


public class PreventDuplicateDealName
{
//***************************************************************************************************************
    // Method Name: dealNameCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other Deal Record or not
    // Created By: Malkeet Singh
    // 
    
    public static void dealNameCheckInsert()
    {
          List<Deal_TGP__c> triggernew = (List<Deal_TGP__c>)Trigger.new;
          Map<Id,Deal_TGP__c> newMap = (Map<Id,Deal_TGP__c>)Trigger.NewMap;
          Map<Id,Deal_TGP__c> oldMap = (Map<Id,Deal_TGP__c>)Trigger.OldMap;
          List<Deal_TGP__c> Namecheck = new List<Deal_TGP__c>();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingdealmap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.dealNameFlag = true;
          Integer i=0;
          Integer j=0;
        
          
        if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate) ) 
        { 
               
                // Below section filterates duplicate deal names in the list of deal names coming in bulk mode from data loader
                for(i=0;i<triggernew.size();i++)
                {
                    Boolean intriggernew = false;
                    for(j=0;j<Namecheck.size();j++)
                    {    // Matching names of entries in the list coming in bulk mode                   
                        if(triggernew[i].Name.toLowerCase()==Namecheck[j].Name.toLowerCase() && triggernew[i].Deal_Rejected__c!=true && Namecheck[j].Deal_Rejected__c!=true)                            
                        {
                            // Associating error with the duplicate 'deal name' record ik the list 
                            triggernew[i].addError('Deal Name already exists');
                            intriggernew = true;                                                        
                        }                       
                        
                    }
                   
                    if(!intriggernew)
                    {
                        // Making List of names and Set of names to check Whether Deal Name already exists in Database or not.
                        Namecheck.add(triggernew[i]);
                        Namesets.add(triggernew[i].Name);
                        
                    }  
                }
                          
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Deal_TGP__c existingName: [select id, Name,Deal_Rejected__c from Deal_TGP__c where Name=:Namesets])
                    {
                        if(existingName.Deal_Rejected__c!=true)
                        {
                            existingdealmap.put(existingName.Name.toLowerCase(),existingName.id);
                        }
                    }                    
                    for(Deal_TGP__c dealRec : Namecheck) 
                    {                     
                       if(existingdealmap != null && existingdealmap.size()>0 && existingdealmap.containsKey(dealRec.Name.toLowerCase()))
                        {
                           //Associating error with duplicate 'deal name' records
                            dealRec.addError('Deal Name already exists');
                        } 
                        
                    }
                }
            }   
        }
        
        
        //***************************************************************************************************************
    // Method Name: dealNameCheckUpdate
    // Description: Before Upsating Records,Checks whether Name  is already present with Other Deal Record or not
    // Created By: Malkeet Singh
    // 
    
         public static void dealNameCheckUpdate()
    {
          List<Deal_TGP__c> triggernew = (List<Deal_TGP__c>)Trigger.new;
          Map<Id,Deal_TGP__c> newMap = (Map<Id,Deal_TGP__c>)Trigger.NewMap;
          Map<Id,Deal_TGP__c> oldMap = (Map<Id,Deal_TGP__c>)Trigger.OldMap;
          List<Deal_TGP__c> Namecheck = new List<Deal_TGP__c>();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingdealmap =  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.dealNameFlag = true;
        
          
          if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) 
            { 
            
            // Below section filterates duplicate deal names in the list of deal names coming in bulk mode from data loader
            // Making list dealname1 with trigger.new enteries
                for(Deal_TGP__c dealName1 : (List<Deal_TGP__c>)trigger.new)
                {
                    if((trigger.isUpdate  && ((dealName1.Name != oldMap.get(dealName1.id).Name) )))
                    {   // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list dealName2 with trigger.new enteries
                        for(Deal_TGP__c dealName2 : (List<Deal_TGP__c>)trigger.new)
                        {  
                          
                          // Comparing names in two lists dealName1 and dealName2 to filter duplicate names from the list
                          
                            if(dealName1.id !=dealName2.id && dealName1.Name.toLowerCase() == dealName2.Name.toLowerCase() && dealName1.Deal_Rejected__c!=true && dealName2.Deal_Rejected__c!=true) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                dealName1.addError('Deal Name already exists');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether Deal Name already exists in Database or not.
                            Namecheck.add(dealName1);
                            Namesets.add(dealName1.Name);
                        }
                    }
                }
                
                
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Deal_TGP__c existingName: [select id, Name,Deal_Rejected__c from Deal_TGP__c where Name=:Namesets])
                    {
                        if(existingName.Deal_Rejected__c!=true)
                        {
                            existingdealmap.put(existingName.Name.toLowerCase(),existingName.id);
                        }
                    }
                    
                    for(Deal_TGP__c dealRec : Namecheck) 
                    {  
                      
                       if(existingdealmap != null && existingdealmap.size()>0 && existingdealmap.containsKey(dealRec.Name.toLowerCase()))
                        {
                        // Adding error to the duplicate record
                            dealRec.addError('Deal Name already exists');
                        } 
                        
                    }
                }
            }
    }
  }