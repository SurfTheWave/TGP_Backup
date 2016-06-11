public class PreventDuplicateServiceMasterName
{
//***************************************************************************************************************
    // Method Name: ServiceMasterNameCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other ServiceMaster Record or not
    // Created By: Malkeet Singh
    // Story: Story-0153/COM_065
    
    public static void serviceMasterNameCheckInsert()
    {
          List<Service_Master__c   > triggernew = (List<Service_Master__c   >)Trigger.new;
          Map<Id,Service_Master__c   > newMap = (Map<Id,Service_Master__c   >)Trigger.NewMap;
          Map<Id,Service_Master__c   > oldMap = (Map<Id,Service_Master__c   >)Trigger.OldMap;
          List<Service_Master__c   > Namecheck = new List<Service_Master__c   >();
          Set<String> Namesets1 = new Set<String>();
          Set<String> Namesets2 = new Set<String>();
          Map<String,String> existingServiceMastermap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.ServiceMasterNameFlag = true;
          Integer i=0;
          Integer j=0;
        
          
        if(trigger.isBefore && trigger.isInsert) 
        { 
               
                // Below section filterates duplicate ServiceMaster names in the list of ServiceMaster names coming in bulk mode from data loader
                for(i=0;i<triggernew.size();i++)
                {
                    Boolean intriggernew = false;
                    for(j=0;j<Namecheck.size();j++)
                    {    // Matching names of entries in the list coming in bulk mode                   
                        if((triggernew[i].Name.toLowerCase()==Namecheck[j].Name.toLowerCase()) && (triggernew[i].Offering__c==Namecheck[j].Offering__c) )                            
                        {
                            // Associating error with the duplicate 'ServiceMaster name' record in the list 
                            triggernew[i].addError('Service  already exists');
                            intriggernew = true;                                                        
                        }                       
                        
                    }
                   
                    if(!intriggernew)
                    {
                        // Making List of names and Set of names to check Whether ServiceMaster Name already exists in Database or not.
                        Namecheck.add(triggernew[i]);
                        Namesets1.add(triggernew[i].Name);
                        Namesets2.add(triggernew[i].Offering__c);
                        
                    }  
                }
                          
                if(Namecheck != null && Namecheck.size()>0)
                {
                    List<Service_Master__c> serviceMaster=[select id,Offering__c, Name from Service_Master__c    where Name=:Namesets1 and Offering__c=:Namesets2 ];
                    if(serviceMaster.size()>0)
                    {
                    for(Service_Master__c    existingName: serviceMaster)
                    {
                        //existingServiceMastermap.put(existingName.Name.toLowerCase(),existingName.Offering__c);
                                        
                    for(Service_Master__c    ServiceMasterRec : Namecheck) 
                    {                     
                       if(existingName.Offering__c==ServiceMasterRec.Offering__c && existingName.Name.toLowerCase()==ServiceMasterRec.Name.toLowerCase())//existingServiceMastermap.containsKey(ServiceMasterRec.Name.toLowerCase()))
                        {
                           //Associating error with duplicate 'ServiceMaster name' records
                            ServiceMasterRec.addError('Service Name already exists');
                        } 
                    }    
                    }
                }
            }
        }   
    }
        
        
        //***************************************************************************************************************
    // Method Name: ServiceMasterNameCheckUpdate
    // Description: Before Updating Records,Checks whether Name  is already present with Other ServiceMaster Record or not
    // Created By: Malkeet Singh
    // 
    
         public static void ServiceMasterNameCheckUpdate()
    {
          List<Service_Master__c  > triggernew = (List<Service_Master__c  >)Trigger.new;
          Map<Id,Service_Master__c  > newMap = (Map<Id,Service_Master__c  >)Trigger.NewMap;
          Map<Id,Service_Master__c  > oldMap = (Map<Id,Service_Master__c  >)Trigger.OldMap;
          List<Service_Master__c  > Namecheck = new List<Service_Master__c  >();
          Set<String> Namesets1 = new Set<String>();
          Set<String> Namesets2 = new Set<String>();
          Map<String,String> existingServiceMastermap =  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.ServiceMasterNameFlag = true;
        
          
          if(trigger.isBefore && trigger.isUpdate) 
            { 
            
            // Below section filterates duplicate ServiceMaster names in the list of ServiceMaster names coming in bulk mode from data loader
            // Making list ServiceMasterName1 with trigger.new enteries
                for(Service_Master__c   ServiceMasterName1 : (List<Service_Master__c  >)trigger.new)
                {
                if((trigger.isUpdate  && ((ServiceMasterName1.Name != oldMap.get(ServiceMasterName1.id).Name))))
                    {   // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list ServiceMasterName2 with trigger.new enteries
                        for(Service_Master__c   ServiceMasterName2 : (List<Service_Master__c  >)trigger.new)
                        {  
                        // Comparing names in two lists ServiceMasterName1 and ServiceMasterName2 to filter duplicate names from the list
                          
                            if(ServiceMasterName1.id !=ServiceMasterName2.id && ServiceMasterName1.Name.toLowerCase() == ServiceMasterName2.Name.toLowerCase() && ServiceMasterName1.Offering__c !=ServiceMasterName2.Offering__c) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                ServiceMasterName1.addError('Service Name already exists');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether ServiceMaster Name already exists in Database or not.
                            Namecheck.add(ServiceMasterName1);
                            Namesets1.add(ServiceMasterName1.Name);
                            
                            Namesets2.add(ServiceMasterName1.Offering__c);
                        }
                    }
                }
                
                
                if(Namecheck != null && Namecheck.size()>0)
                {
                    List<Service_Master__c> serviceMaster=[select id,Offering__c, Name from Service_Master__c  where Name=:Namesets1 and Offering__c=:Namesets2];
                    if(serviceMaster.size()>0)
                    {
                    for(Service_Master__c    existingName: serviceMaster)
                    {
                        //existingServiceMastermap.put(existingName.Name.toLowerCase(),existingName.Offering__c);
                                        
                    for(Service_Master__c    ServiceMasterRec : Namecheck) 
                    {                     
                       if(existingName.Offering__c==ServiceMasterRec.Offering__c && existingName.Name.toLowerCase()==ServiceMasterRec.Name.toLowerCase())//existingServiceMastermap.containsKey(ServiceMasterRec.Name.toLowerCase()))
                        {
                           //Associating error with duplicate 'ServiceMaster name' records
                            ServiceMasterRec.addError('Service Name already exists');
                        } 
                    }    
                    }
                    }
                }
            }   
        }
        }