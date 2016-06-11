public class PreventDuplicateOperatingGroupMasterName
{
//***************************************************************************************************************
    // Method Name: OperatingGroupMasterNameCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other OperatingGroupMaster Record or not
    // Created By: Malkeet Singh
    // Story: Story-0153/COM_065
    
    public static void operatingGroupMasterNameCheckInsert()
    {
          List<Operating_Group_Master__c   > triggernew = (List<Operating_Group_Master__c   >)Trigger.new;
          Map<Id,Operating_Group_Master__c   > newMap = (Map<Id,Operating_Group_Master__c   >)Trigger.NewMap;
          Map<Id,Operating_Group_Master__c   > oldMap = (Map<Id,Operating_Group_Master__c   >)Trigger.OldMap;
          List<Operating_Group_Master__c   > Namecheck = new List<Operating_Group_Master__c   >();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingOperatingMasterGroupmap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.OperatingGroupMasterNameFlag = true;
          Integer i=0;
          Integer j=0;
        
          
        if(trigger.isBefore && trigger.isInsert) 
        { 
               
                // Below section filterates duplicate OperatingGroupMaster names in the list of OperatingGroupMaster names coming in bulk mode from data loader
                for(i=0;i<triggernew.size();i++)
                {
                    Boolean intriggernew = false;
                    for(j=0;j<Namecheck.size();j++)
                    {    // Matching names of entries in the list coming in bulk mode                   
                        if(triggernew[i].Name.toLowerCase()==Namecheck[j].Name.toLowerCase())                            
                        {
                            // Associating error with the duplicate 'OperatingGroupMaster name' record in the list 
                            triggernew[i].addError('Operating Group Name already exists');
                            intriggernew = true;                                                        
                        }                       
                        
                    }
                   
                    if(!intriggernew)
                    {
                        // Making List of names and Set of names to check Whether OperatingGroupMaster Name already exists in Database or not.
                        Namecheck.add(triggernew[i]);
                        Namesets.add(triggernew[i].Name);
                        
                    }  
                }
                          
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Operating_Group_Master__c    existingName: [select id, Name from Operating_Group_Master__c    where Name=:Namesets])
                    {
                        existingOperatingMasterGroupmap.put(existingName.Name.toLowerCase(),existingName.id);
                    }                    
                    for(Operating_Group_Master__c    OperatingMasterGroupRec : Namecheck) 
                    {                     
                       if(existingOperatingMasterGroupmap != null && existingOperatingMasterGroupmap.size()>0 && existingOperatingMasterGroupmap.containsKey(OperatingMasterGroupRec.Name.toLowerCase()))
                        {
                           //Associating error with duplicate 'OperatingGroupMaster name' records
                            OperatingMasterGroupRec.addError('Operating Group Name already exists');
                        } 
                        
                    }
                }
            }   
        }
        
        
        //***************************************************************************************************************
    // Method Name: OperatingGroupMasterNameCheckUpdate
    // Description: Before Updating Records,Checks whether Name  is already present with Other OperatingGroupMaster Record or not
    // Created By: Malkeet Singh
    // 
    
         public static void operatingGroupMasterNameCheckUpdate()
    {
          List<Operating_Group_Master__c  > triggernew = (List<Operating_Group_Master__c  >)Trigger.new;
          Map<Id,Operating_Group_Master__c  > newMap = (Map<Id,Operating_Group_Master__c  >)Trigger.NewMap;
          Map<Id,Operating_Group_Master__c  > oldMap = (Map<Id,Operating_Group_Master__c  >)Trigger.OldMap;
          List<Operating_Group_Master__c  > Namecheck = new List<Operating_Group_Master__c  >();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingOperatingMastermap =  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.OperatingGroupMasterNameFlag = true;
        
          
          if(trigger.isBefore && trigger.isUpdate) 
            { 
            
            // Below section filterates duplicate OperatingMaster names in the list of OperatingMaster names coming in bulk mode from data loader
            // Making list OperatingGroupMasterName1 with trigger.new enteries
                for(Operating_Group_Master__c   OperatingGroupMasterName1 : (List<Operating_Group_Master__c  >)trigger.new)
                {
                    if((trigger.isUpdate  && ((OperatingGroupMasterName1.Name != oldMap.get(OperatingGroupMasterName1.id).Name) )))
                    {   // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list OperatingGroupMasterName2 with trigger.new enteries
                        for(Operating_Group_Master__c   OperatingGroupMasterName2 : (List<Operating_Group_Master__c  >)trigger.new)
                        {  
                          
                          // Comparing names in two lists OperatingGroupMasterName1 and OperatingGroupMasterName2 to filter duplicate names from the list
                          
                            if(OperatingGroupMasterName1.id !=OperatingGroupMasterName2.id && OperatingGroupMasterName1.Name.toLowerCase() == OperatingGroupMasterName2.Name.toLowerCase()) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                OperatingGroupMasterName1.addError('Operating Group Name already exists');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether OperatingMaster Name already exists in Database or not.
                            Namecheck.add(OperatingGroupMasterName1);
                            Namesets.add(OperatingGroupMasterName1.Name);
                        }
                    }
                }
                
                
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Operating_Group_Master__c   existingName: [select id, Name from Operating_Group_Master__c   where Name=:Namesets])
                    {
                        existingOperatingMastermap.put(existingName.Name.toLowerCase(),existingName.id);
                    }
                    
                    for(Operating_Group_Master__c   OperatingMasterRec : Namecheck) 
                    {  
                      
                       if(existingOperatingMastermap != null && existingOperatingMastermap.size()>0 && existingOperatingMastermap.containsKey(OperatingMasterRec.Name.toLowerCase()))
                        {
                        // Adding error to the duplicate record
                            OperatingMasterRec.addError('Operating Group Name already exists');
                        } 
                        
                    }
                }
            }
    }
  }