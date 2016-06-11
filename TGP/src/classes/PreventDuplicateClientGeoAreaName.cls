public class PreventDuplicateClientGeoAreaName
{
//***************************************************************************************************************
    // Method Name: clientGeoAreaNameCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other ClientGeoArea Record or not
    // Created By: Malkeet Singh
    // Story: Story-0153/COM_065
    
    public static void clientGeoAreaNameCheckInsert()
    {
          List<Client_Geo_Area_Master__c > triggernew = (List<Client_Geo_Area_Master__c >)Trigger.new;
          Map<Id,Client_Geo_Area_Master__c > newMap = (Map<Id,Client_Geo_Area_Master__c >)Trigger.NewMap;
          Map<Id,Client_Geo_Area_Master__c > oldMap = (Map<Id,Client_Geo_Area_Master__c >)Trigger.OldMap;
          List<Client_Geo_Area_Master__c > Namecheck = new List<Client_Geo_Area_Master__c >();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingClientGeoAreamap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.clientGeoAreaNameFlag = true;
          Integer i=0;
          Integer j=0;
        
          
        if(trigger.isBefore && trigger.isInsert) 
        { 
               
                // Below section filterates duplicate ClientGeoArea names in the list of ClientGeoArea names coming in bulk mode from data loader
                for(i=0;i<triggernew.size();i++)
                {
                    Boolean intriggernew = false;
                    for(j=0;j<Namecheck.size();j++)
                    {    // Matching names of entries in the list coming in bulk mode                   
                        if(triggernew[i].Name.toLowerCase()==Namecheck[j].Name.toLowerCase())                            
                        {
                            // Associating error with the duplicate 'ClientGeoArea name' record ik the list 
                            triggernew[i].addError('Client Geo Area Name already exists');
                            intriggernew = true;                                                        
                        }                       
                        
                    }
                   
                    if(!intriggernew)
                    {
                        // Making List of names and Set of names to check Whether ClientGeoArea Name already exists in Database or not.
                        Namecheck.add(triggernew[i]);
                        Namesets.add(triggernew[i].Name);
                        
                    }  
                }
                          
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Client_Geo_Area_Master__c  existingName: [select id, Name from Client_Geo_Area_Master__c  where Name=:Namesets])
                    {
                        existingClientGeoAreamap.put(existingName.Name.toLowerCase(),existingName.id);
                    }                    
                    for(Client_Geo_Area_Master__c  ClientGeoAreaRec : Namecheck) 
                    {                     
                       if(existingClientGeoAreamap != null && existingClientGeoAreamap.size()>0 && existingClientGeoAreamap.containsKey(ClientGeoAreaRec.Name.toLowerCase()))
                        {
                           //Associating error with duplicate 'ClientGeoArea name' records
                            ClientGeoAreaRec.addError('Client Geo Area Name already exists');
                        } 
                        
                    }
                }
            }   
        }
        
        
        //***************************************************************************************************************
    // Method Name: clientGeoAreaNameCheckUpdate
    // Description: Before Upsating Records,Checks whether Name  is already present with Other ClientGeoArea Record or not
    // Created By: Malkeet Singh
    // 
    
         public static void clientGeoAreaNameCheckUpdate()
    {
          List<Client_Geo_Area_Master__c> triggernew = (List<Client_Geo_Area_Master__c>)Trigger.new;
          Map<Id,Client_Geo_Area_Master__c> newMap = (Map<Id,Client_Geo_Area_Master__c>)Trigger.NewMap;
          Map<Id,Client_Geo_Area_Master__c> oldMap = (Map<Id,Client_Geo_Area_Master__c>)Trigger.OldMap;
          List<Client_Geo_Area_Master__c> Namecheck = new List<Client_Geo_Area_Master__c>();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingClientGeoAreamap =  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.clientGeoAreaNameFlag = true;
        
          
          if(trigger.isBefore && trigger.isUpdate) 
            { 
            
            // Below section filterates duplicate ClientGeoArea names in the list of ClientGeoArea names coming in bulk mode from data loader
            // Making list clientGeoAreaName1 with trigger.new enteries
                for(Client_Geo_Area_Master__c clientGeoAreaName1 : (List<Client_Geo_Area_Master__c>)trigger.new)
                {
                    if((trigger.isUpdate  && ((clientGeoAreaName1.Name != oldMap.get(clientGeoAreaName1.id).Name) )))
                    {   // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list clientGeoAreaName2 with trigger.new enteries
                        for(Client_Geo_Area_Master__c clientGeoAreaName2 : (List<Client_Geo_Area_Master__c>)trigger.new)
                        {  
                          
                          // Comparing names in two lists clientGeoAreaName1 and clientGeoAreaName2 to filter duplicate names from the list
                          
                            if(clientGeoAreaName1.id !=clientGeoAreaName2.id && clientGeoAreaName1.Name.toLowerCase() == clientGeoAreaName2.Name.toLowerCase()) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                clientGeoAreaName1.addError('Client Geo Area Name already exists');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether ClientGeoArea Name already exists in Database or not.
                            Namecheck.add(clientGeoAreaName1);
                            Namesets.add(clientGeoAreaName1.Name);
                        }
                    }
                }
                
                
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Client_Geo_Area_Master__c existingName: [select id, Name from Client_Geo_Area_Master__c where Name=:Namesets])
                    {
                        existingClientGeoAreamap.put(existingName.Name.toLowerCase(),existingName.id);
                    }
                    
                    for(Client_Geo_Area_Master__c ClientGeoAreaRec : Namecheck) 
                    {  
                      
                       if(existingClientGeoAreamap != null && existingClientGeoAreamap.size()>0 && existingClientGeoAreamap.containsKey(ClientGeoAreaRec.Name.toLowerCase()))
                        {
                        // Adding error to the duplicate record
                            ClientGeoAreaRec.addError('Client Geo Area Name already exists');
                        } 
                        
                    }
                }
            }
    }
  }