public class PreventDuplicateDelLocMasterName
{
//***************************************************************************************************************
    // Method Name: DelieveryLocationMasterNameCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other DelieveryLocationMaster Record or not
    // Created By: Malkeet Singh
    // Story: Story-0153/COM_065
    
    public static void delieveryLocationMasterNameCheckInsert()
    {
          List<Delievery_Location_Master__c   > triggernew = (List<Delievery_Location_Master__c   >)Trigger.new;
          Map<Id,Delievery_Location_Master__c   > newMap = (Map<Id,Delievery_Location_Master__c   >)Trigger.NewMap;
          Map<Id,Delievery_Location_Master__c   > oldMap = (Map<Id,Delievery_Location_Master__c   >)Trigger.OldMap;
          List<Delievery_Location_Master__c   > Namecheck = new List<Delievery_Location_Master__c   >();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingDelieveryLocationMastermap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.DelieveryLocationMasterNameFlag = true;
          Integer i=0;
          Integer j=0;
        
          
        if(trigger.isBefore && trigger.isInsert) 
        { 
               
                // Below section filterates duplicate DelieveryLocationMaster names in the list of DelieveryLocationMaster names coming in bulk mode from data loader
                for(i=0;i<triggernew.size();i++)
                {
                    Boolean intriggernew = false;
                    for(j=0;j<Namecheck.size();j++)
                    {    // Matching names of entries in the list coming in bulk mode                   
                        if(triggernew[i].Name.toLowerCase()==Namecheck[j].Name.toLowerCase())                            
                        {
                            // Associating error with the duplicate 'DelieveryLocationMaster name' record in the list 
                            triggernew[i].addError('Delivery Location Name already exists');
                            intriggernew = true;                                                        
                        }                       
                        
                    }
                   
                    if(!intriggernew)
                    {
                        // Making List of names and Set of names to check Whether DelieveryLocationMaster Name already exists in Database or not.
                        Namecheck.add(triggernew[i]);
                        Namesets.add(triggernew[i].Name);
                        
                    }  
                }
                          
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Delievery_Location_Master__c    existingName: [select id, Name from Delievery_Location_Master__c    where Name=:Namesets])
                    {
                        existingDelieveryLocationMastermap.put(existingName.Name.toLowerCase(),existingName.id);
                    }                    
                    for(Delievery_Location_Master__c    DelieveryLocationMasterRec : Namecheck) 
                    {                     
                       if(existingDelieveryLocationMastermap != null && existingDelieveryLocationMastermap.size()>0 && existingDelieveryLocationMastermap.containsKey(DelieveryLocationMasterRec.Name.toLowerCase()))
                        {
                           //Associating error with duplicate 'DelieveryLocationMaster name' records
                            DelieveryLocationMasterRec.addError('Delivery Location Name already exists');
                        } 
                        
                    }
                }
            }   
        }
        
        
        //***************************************************************************************************************
    // Method Name: DelieveryLocationMasterNameCheckUpdate
    // Description: Before Updating Records,Checks whether Name  is already present with Other DelieveryLocationMaster Record or not
    // Created By: Malkeet Singh
    // 
    
         public static void delieveryLocationMasterNameCheckUpdate()
    {
          List<Delievery_Location_Master__c  > triggernew = (List<Delievery_Location_Master__c  >)Trigger.new;
          Map<Id,Delievery_Location_Master__c  > newMap = (Map<Id,Delievery_Location_Master__c  >)Trigger.NewMap;
          Map<Id,Delievery_Location_Master__c  > oldMap = (Map<Id,Delievery_Location_Master__c  >)Trigger.OldMap;
          List<Delievery_Location_Master__c  > Namecheck = new List<Delievery_Location_Master__c  >();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingDelieveryLocationMastermap =  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.DelieveryLocationMasterNameFlag = true;
        
          
          if(trigger.isBefore && trigger.isUpdate) 
            { 
            
            // Below section filterates duplicate DelieveryLocationMaster names in the list of DelieveryLocationMaster names coming in bulk mode from data loader
            // Making list DelieveryLocationMasterName1 with trigger.new enteries
                for(Delievery_Location_Master__c   DelieveryLocationMasterName1 : (List<Delievery_Location_Master__c  >)trigger.new)
                {
                    if((trigger.isUpdate  && ((DelieveryLocationMasterName1.Name != oldMap.get(DelieveryLocationMasterName1.id).Name) )))
                    {   // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list DelieveryLocationMasterName2 with trigger.new enteries
                        for(Delievery_Location_Master__c   DelieveryLocationMasterName2 : (List<Delievery_Location_Master__c  >)trigger.new)
                        {  
                          
                          // Comparing names in two lists DelieveryLocationMasterName1 and DelieveryLocationMasterName2 to filter duplicate names from the list
                          
                            if(DelieveryLocationMasterName1.id !=DelieveryLocationMasterName2.id && DelieveryLocationMasterName1.Name.toLowerCase() == DelieveryLocationMasterName2.Name.toLowerCase()) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                DelieveryLocationMasterName1.addError('Delivery Location Name already exists');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether DelieveryLocationMaster Name already exists in Database or not.
                            Namecheck.add(DelieveryLocationMasterName1);
                            Namesets.add(DelieveryLocationMasterName1.Name);
                        }
                    }
                }
                
                
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Delievery_Location_Master__c   existingName: [select id, Name from Delievery_Location_Master__c   where Name=:Namesets])
                    {
                        existingDelieveryLocationMastermap.put(existingName.Name.toLowerCase(),existingName.id);
                    }
                    
                    for(Delievery_Location_Master__c   DelieveryLocationMasterRec : Namecheck) 
                    {  
                      
                       if(existingDelieveryLocationMastermap != null && existingDelieveryLocationMastermap.size()>0 && existingDelieveryLocationMastermap.containsKey(DelieveryLocationMasterRec.Name.toLowerCase()))
                        {
                        // Adding error to the duplicate record
                            DelieveryLocationMasterRec.addError('Delivery Location Name already exists');
                        } 
                        
                    }
                }
            }
    }
  }