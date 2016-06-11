public class PreventDuplicateClientMasterName
{
//***************************************************************************************************************
    // Method Name: ClientMasterNameCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other ClientMaster Record or not
    // Created By: Malkeet Singh
    // Story: Story-0153/COM_065
    
    public static void clientMasterNameCheckInsert()
    {
          List<Client_Master__c   > triggernew = (List<Client_Master__c   >)Trigger.new;
          Map<Id,Client_Master__c   > newMap = (Map<Id,Client_Master__c   >)Trigger.NewMap;
          Map<Id,Client_Master__c   > oldMap = (Map<Id,Client_Master__c   >)Trigger.OldMap;
          List<Client_Master__c   > Namecheck = new List<Client_Master__c   >();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingClientMastermap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.ClientMasterNameFlag = true;
          Integer i=0;
          Integer j=0;
        
          
        if(trigger.isBefore && trigger.isInsert) 
        { 
               
                // Below section filterates duplicate ClientMaster names in the list of ClientMaster names coming in bulk mode from data loader
                for(i=0;i<triggernew.size();i++)
                {
                    Boolean intriggernew = false;
                    for(j=0;j<Namecheck.size();j++)
                    {    // Matching names of entries in the list coming in bulk mode                   
                        if(triggernew[i].Name.toLowerCase()==Namecheck[j].Name.toLowerCase())                            
                        {
                            // Associating error with the duplicate 'ClientMaster name' record in the list 
                            triggernew[i].addError('Client Name already exists');
                            intriggernew = true;                                                        
                        }                       
                        
                    }
                   
                    if(!intriggernew)
                    {
                        // Making List of names and Set of names to check Whether ClientMaster Name already exists in Database or not.
                        Namecheck.add(triggernew[i]);
                        Namesets.add(triggernew[i].Name);
                        
                    }  
                }
                          
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Client_Master__c    existingName: [select id, Name from Client_Master__c    where Name=:Namesets])
                    {
                        existingClientMastermap.put(existingName.Name.toLowerCase(),existingName.id);
                    }                    
                    for(Client_Master__c    ClientMasterRec : Namecheck) 
                    {                     
                       if(existingClientMastermap != null && existingClientMastermap.size()>0 && existingClientMastermap.containsKey(ClientMasterRec.Name.toLowerCase()))
                        {
                           //Associating error with duplicate 'ClientMaster name' records
                            ClientMasterRec.addError('Client Name already exists');
                        } 
                        
                    }
                }
            }   
        }
        
        
        //***************************************************************************************************************
    // Method Name: ClientMasterNameCheckUpdate
    // Description: Before Updating Records,Checks whether Name  is already present with Other ClientMaster Record or not
    // Created By: Malkeet Singh
    // 
    
         public static void ClientMasterNameCheckUpdate()
    {
          List<Client_Master__c  > triggernew = (List<Client_Master__c  >)Trigger.new;
          Map<Id,Client_Master__c  > newMap = (Map<Id,Client_Master__c  >)Trigger.NewMap;
          Map<Id,Client_Master__c  > oldMap = (Map<Id,Client_Master__c  >)Trigger.OldMap;
          List<Client_Master__c  > Namecheck = new List<Client_Master__c  >();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingClientMastermap =  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.ClientMasterNameFlag = true;
        
          
          if(trigger.isBefore && trigger.isUpdate) 
            { 
            
            // Below section filterates duplicate ClientMaster names in the list of ClientMaster names coming in bulk mode from data loader
            // Making list ClientMasterName1 with trigger.new enteries
                for(Client_Master__c   ClientMasterName1 : (List<Client_Master__c  >)trigger.new)
                {
                    if((trigger.isUpdate  && ((ClientMasterName1.Name != oldMap.get(ClientMasterName1.id).Name) )))
                    {   // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list ClientMasterName2 with trigger.new enteries
                        for(Client_Master__c   ClientMasterName2 : (List<Client_Master__c  >)trigger.new)
                        {  
                          
                          // Comparing names in two lists ClientMasterName1 and ClientMasterName2 to filter duplicate names from the list
                          
                            if(ClientMasterName1.id !=ClientMasterName2.id && ClientMasterName1.Name.toLowerCase() == ClientMasterName2.Name.toLowerCase()) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                ClientMasterName1.addError('Client Name already exists');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether ClientMaster Name already exists in Database or not.
                            Namecheck.add(ClientMasterName1);
                            Namesets.add(ClientMasterName1.Name);
                        }
                    }
                }
                
                
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Client_Master__c   existingName: [select id, Name from Client_Master__c   where Name=:Namesets])
                    {
                        existingClientMastermap.put(existingName.Name.toLowerCase(),existingName.id);
                    }
                    
                    for(Client_Master__c   ClientMasterRec : Namecheck) 
                    {  
                      
                       if(existingClientMastermap != null && existingClientMastermap.size()>0 && existingClientMastermap.containsKey(ClientMasterRec.Name.toLowerCase()))
                        {
                        // Adding error to the duplicate record
                            ClientMasterRec.addError('Client Name already exists');
                        } 
                        
                    }
                }
            }
    }
  }