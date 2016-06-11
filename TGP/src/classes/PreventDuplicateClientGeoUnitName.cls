public class PreventDuplicateClientGeoUnitName
{
//***************************************************************************************************************
    // Method Name: clientGeoUnitNameCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other clientGeoUnit Record or not
    // Created By: Malkeet Singh
    // Story: Story-0153/COM_065
    
    public static void clientGeoUnitNameCheckInsert()
    {
          List<Client_Geo_Unit_Master__c  > triggernew = (List<Client_Geo_Unit_Master__c  >)Trigger.new;
          Map<Id,Client_Geo_Unit_Master__c  > newMap = (Map<Id,Client_Geo_Unit_Master__c  >)Trigger.NewMap;
          Map<Id,Client_Geo_Unit_Master__c  > oldMap = (Map<Id,Client_Geo_Unit_Master__c  >)Trigger.OldMap;
          List<Client_Geo_Unit_Master__c  > Namecheck = new List<Client_Geo_Unit_Master__c  >();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingclientGeoUnitmap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.clientGeoUnitNameFlag = true;
          Integer i=0;
          Integer j=0;
        
          
        if(trigger.isBefore && trigger.isInsert) 
        { 
               
                // Below section filterates duplicate ClientGeoUnit names in the list of ClientGeoUnit names coming in bulk mode from data loader
                for(i=0;i<triggernew.size();i++)
                {
                    Boolean intriggernew = false;
                    for(j=0;j<Namecheck.size();j++)
                    {    // Matching names of entries in the list coming in bulk mode                   
                        if(triggernew[i].Name.toLowerCase()==Namecheck[j].Name.toLowerCase())                            
                        {
                            // Associating error with the duplicate 'clientGeoUnit name' record ik the list 
                            triggernew[i].addError('Client Geo Unit Name already exists');
                            intriggernew = true;                                                        
                        }                       
                        
                    }
                   
                    if(!intriggernew)
                    {
                        // Making List of names and Set of names to check Whether clientGeoUnit Name already exists in Database or not.
                        Namecheck.add(triggernew[i]);
                        Namesets.add(triggernew[i].Name);
                        
                    }  
                }
                          
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Client_Geo_Unit_Master__c   existingName: [select id, Name from Client_Geo_Unit_Master__c   where Name=:Namesets])
                    {
                        existingclientGeoUnitmap.put(existingName.Name.toLowerCase(),existingName.id);
                    }                    
                    for(Client_Geo_Unit_Master__c   clientGeoUnitRec : Namecheck) 
                    {                     
                       if(existingclientGeoUnitmap != null && existingclientGeoUnitmap.size()>0 && existingclientGeoUnitmap.containsKey(clientGeoUnitRec.Name.toLowerCase()))
                        {
                           //Associating error with duplicate 'clientGeoUnit name' records
                            clientGeoUnitRec.addError('Client Geo Unit Name already exists');
                        } 
                        
                    }
                }
            }   
        }
        
        
        //***************************************************************************************************************
    // Method Name: clientGeoUnitNameCheckUpdate
    // Description: Before Updating Records,Checks whether Name  is already present with Other clientGeoUnit Record or not
    // Created By: Malkeet Singh
    // 
    
         public static void clientGeoUnitNameCheckUpdate()
    {
          List<Client_Geo_Unit_Master__c > triggernew = (List<Client_Geo_Unit_Master__c >)Trigger.new;
          Map<Id,Client_Geo_Unit_Master__c > newMap = (Map<Id,Client_Geo_Unit_Master__c >)Trigger.NewMap;
          Map<Id,Client_Geo_Unit_Master__c > oldMap = (Map<Id,Client_Geo_Unit_Master__c >)Trigger.OldMap;
          List<Client_Geo_Unit_Master__c > Namecheck = new List<Client_Geo_Unit_Master__c >();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingclientGeoUnitmap =  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.clientGeoUnitNameFlag = true;
        
          
          if(trigger.isBefore && trigger.isUpdate) 
            { 
            
            // Below section filterates duplicate clientGeoUnit names in the list of clientGeoUnit names coming in bulk mode from data loader
            // Making list clientGeoUnitName1 with trigger.new enteries
                for(Client_Geo_Unit_Master__c  clientGeoUnitName1 : (List<Client_Geo_Unit_Master__c >)trigger.new)
                {
                    if((trigger.isUpdate  && ((clientGeoUnitName1.Name != oldMap.get(clientGeoUnitName1.id).Name) )))
                    {   // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list clientGeoUnitName2 with trigger.new enteries
                        for(Client_Geo_Unit_Master__c  clientGeoUnitName2 : (List<Client_Geo_Unit_Master__c >)trigger.new)
                        {  
                          
                          // Comparing names in two lists clientGeoUnitName1 and clientGeoUnitName2 to filter duplicate names from the list
                          
                            if(clientGeoUnitName1.id !=clientGeoUnitName2.id && clientGeoUnitName1.Name.toLowerCase() == clientGeoUnitName2.Name.toLowerCase()) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                clientGeoUnitName1.addError('Client Geo Unit Name already exists');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether clientGeoUnit Name already exists in Database or not.
                            Namecheck.add(clientGeoUnitName1);
                            Namesets.add(clientGeoUnitName1.Name);
                        }
                    }
                }
                
                
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Client_Geo_Unit_Master__c  existingName: [select id, Name from Client_Geo_Unit_Master__c  where Name=:Namesets])
                    {
                        existingclientGeoUnitmap.put(existingName.Name.toLowerCase(),existingName.id);
                    }
                    
                    for(Client_Geo_Unit_Master__c  clientGeoUnitRec : Namecheck) 
                    {  
                      
                       if(existingclientGeoUnitmap != null && existingclientGeoUnitmap.size()>0 && existingclientGeoUnitmap.containsKey(clientGeoUnitRec.Name.toLowerCase()))
                        {
                        // Adding error to the duplicate record
                            clientGeoUnitRec.addError('Client Geo Unit Name already exists');
                        } 
                        
                    }
                }
            }
    }
  }