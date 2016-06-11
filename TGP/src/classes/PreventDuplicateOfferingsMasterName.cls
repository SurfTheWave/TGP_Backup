public class PreventDuplicateOfferingsMasterName
{
//***************************************************************************************************************
    // Method Name: OfferingsMasterNameCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other OfferingsMaster Record or not
    // Created By: Malkeet Singh
    // Story: Story-0153/COM_065
    
    public static void offeringsMasterNameCheckInsert()
    {
          List<Offerings_Master__c   > triggernew = (List<Offerings_Master__c   >)Trigger.new;
          Map<Id,Offerings_Master__c   > newMap = (Map<Id,Offerings_Master__c   >)Trigger.NewMap;
          Map<Id,Offerings_Master__c   > oldMap = (Map<Id,Offerings_Master__c   >)Trigger.OldMap;
          List<Offerings_Master__c   > Namecheck = new List<Offerings_Master__c   >();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingOfferingsMastermap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.OfferingsMasterNameFlag = true;
          Integer i=0;
          Integer j=0;
        
          
        if(trigger.isBefore && trigger.isInsert) 
        { 
               
                // Below section filterates duplicate OfferingsMaster names in the list of OfferingsMaster names coming in bulk mode from data loader
                for(i=0;i<triggernew.size();i++)
                {
                    Boolean intriggernew = false;
                    for(j=0;j<Namecheck.size();j++)
                    {    // Matching names of entries in the list coming in bulk mode                   
                        if(triggernew[i].Name.toLowerCase()==Namecheck[j].Name.toLowerCase())                            
                        {
                            // Associating error with the duplicate 'OfferingsMaster name' record in the list 
                            triggernew[i].addError('Offering Name is already exist');
                            intriggernew = true;                                                        
                        }                       
                        
                    }
                   
                    if(!intriggernew)
                    {
                        // Making List of names and Set of names to check Whether OfferingsMaster Name already exists in Database or not.
                        Namecheck.add(triggernew[i]);
                        Namesets.add(triggernew[i].Name);
                        
                    }  
                }
                          
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Offerings_Master__c    existingName: [select id, Name from Offerings_Master__c    where Name=:Namesets])
                    {
                        existingOfferingsMastermap.put(existingName.Name.toLowerCase(),existingName.id);
                    }                    
                    for(Offerings_Master__c    OfferingsMasterRec : Namecheck) 
                    {                     
                       if(existingOfferingsMastermap != null && existingOfferingsMastermap.size()>0 && existingOfferingsMastermap.containsKey(OfferingsMasterRec.Name.toLowerCase()))
                        {
                           //Associating error with duplicate 'OfferingsMaster name' records
                            OfferingsMasterRec.addError('Offering Name is already exist');
                        } 
                        
                    }
                }
            }   
        }
        
        
        //***************************************************************************************************************
    // Method Name: OfferingsMasterNameCheckUpdate
    // Description: Before Updating Records,Checks whether Name  is already present with Other OfferingsMaster Record or not
    // Created By: Malkeet Singh
    // 
    
         public static void offeringsMasterNameCheckUpdate()
    {
          List<Offerings_Master__c  > triggernew = (List<Offerings_Master__c  >)Trigger.new;
          Map<Id,Offerings_Master__c  > newMap = (Map<Id,Offerings_Master__c  >)Trigger.NewMap;
          Map<Id,Offerings_Master__c  > oldMap = (Map<Id,Offerings_Master__c  >)Trigger.OldMap;
          List<Offerings_Master__c  > Namecheck = new List<Offerings_Master__c  >();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingOfferingsMastermap =  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.OfferingsMasterNameFlag = true;
        
          
          if(trigger.isBefore && trigger.isUpdate) 
            { 
            
            // Below section filterates duplicate OfferingsMaster names in the list of OfferingsMaster names coming in bulk mode from data loader
            // Making list OfferingsMasterName1 with trigger.new enteries
                for(Offerings_Master__c   OfferingsMasterName1 : (List<Offerings_Master__c  >)trigger.new)
                {
                    if((trigger.isUpdate  && ((OfferingsMasterName1.Name != oldMap.get(OfferingsMasterName1.id).Name) )))
                    {   // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list OfferingsMasterName2 with trigger.new enteries
                        for(Offerings_Master__c   OfferingsMasterName2 : (List<Offerings_Master__c  >)trigger.new)
                        {  
                          
                          // Comparing names in two lists OfferingsMasterName1 and OfferingsMasterName2 to filter duplicate names from the list
                          
                            if(OfferingsMasterName1.id !=OfferingsMasterName2.id && OfferingsMasterName1.Name.toLowerCase() == OfferingsMasterName2.Name.toLowerCase()) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                OfferingsMasterName1.addError('Offering Name is already exist');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether OfferingsMaster Name already exists in Database or not.
                            Namecheck.add(OfferingsMasterName1);
                            Namesets.add(OfferingsMasterName1.Name);
                        }
                    }
                }
                
                
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Offerings_Master__c   existingName: [select id, Name from Offerings_Master__c   where Name=:Namesets])
                    {
                        existingOfferingsMastermap.put(existingName.Name.toLowerCase(),existingName.id);
                    }
                    
                    for(Offerings_Master__c   OfferingsMasterRec : Namecheck) 
                    {  
                      
                       if(existingOfferingsMastermap != null && existingOfferingsMastermap.size()>0 && existingOfferingsMastermap.containsKey(OfferingsMasterRec.Name.toLowerCase()))
                        {
                        // Adding error to the duplicate record
                            OfferingsMasterRec.addError('Offering Name is already exist');
                        } 
                        
                    }
                }
            }
    }
  }