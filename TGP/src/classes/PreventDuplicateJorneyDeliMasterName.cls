public class PreventDuplicateJorneyDeliMasterName
{
//***************************************************************************************************************
    // Method Name: JorneyDeliMasterNameCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other Service Management Master Record or not
    // Created By: Malkeet Singh
    // Story: Story-0153/COM_065
    
    public static void JorneyDeliMasterNameCheckInsert()
    {
          List<Journey_Management_Deliverable__c   > triggernew = (List<Journey_Management_Deliverable__c   >)Trigger.new;
          Map<Id,Journey_Management_Deliverable__c   > newMap = (Map<Id,Journey_Management_Deliverable__c   >)Trigger.NewMap;
          Map<Id,Journey_Management_Deliverable__c   > oldMap = (Map<Id,Journey_Management_Deliverable__c   >)Trigger.OldMap;
          List<Journey_Management_Deliverable__c   > Namecheck = new List<Journey_Management_Deliverable__c   >();
          Set<String> Namesets1 = new Set<String>();
          Set<String> Namesets2 = new Set<String>();
          Map<String,String> existingJorneyDeliMastermap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.JourneyDeliMasterNameFlag = true;
          Integer i=0;
          Integer j=0;
        
          
        if(trigger.isBefore && trigger.isInsert) 
        { 
               
                // Below section filterates duplicate BCP Task Master names in the list of BCPTaskMaster names coming in bulk mode from data loader
                for(i=0;i<triggernew.size();i++)
                {
                    Boolean intriggernew = false;
                    for(j=0;j<Namecheck.size();j++)
                    {    // Matching names of entries in the list coming in bulk mode                   
                        if((triggernew[i].Deliverable_Name__c.toLowerCase()==Namecheck[j].Deliverable_Name__c.toLowerCase()) && (triggernew[i].Journey_Management__c==Namecheck[j].Journey_Management__c) )                            
                        {
                            // Associating error with the duplicate 'BCP Task Master name' record in the list 
                            triggernew[i].addError('Deliverable Name already exists');
                            intriggernew = true;                                                        
                        }                       
                        
                    }
                   
                    if(!intriggernew)
                    {
                        // Making List of names and Set of names to check Whether BCP Master Name already exists in Database or not.
                        Namecheck.add(triggernew[i]);
                        Namesets1.add(triggernew[i].Deliverable_Name__c);
                        Namesets2.add(triggernew[i].Journey_Management__c);
                        
                    }  
                }
                          
                if(Namecheck != null && Namecheck.size()>0)
                {
                    List<Journey_Management_Deliverable__c> serviceMaster=[select id,Journey_Management__c, Deliverable_Name__c from Journey_Management_Deliverable__c    where Deliverable_Name__c=:Namesets1 and Journey_Management__c=:Namesets2 ];
                    if(serviceMaster.size()>0)
                    {
                    for(Journey_Management_Deliverable__c    existingName: serviceMaster)
                    {
                        //existingJorneyDeliMastermap.put(existingName.Deliverable_Name__c.toLowerCase(),existingName.Journey_Management__c);
                                        
                    for(Journey_Management_Deliverable__c    ServiceMasterRec : Namecheck) 
                    {                     
                       if(existingName.Journey_Management__c==ServiceMasterRec.Journey_Management__c && existingName.Deliverable_Name__c.toLowerCase()==ServiceMasterRec.Deliverable_Name__c.toLowerCase())//existingJorneyDeliMastermap.containsKey(ServiceMasterRec.Deliverable_Name__c.toLowerCase()))
                        {
                           //Associating error with duplicate 'Service Management Task Master name' records
                            ServiceMasterRec.addError('Deliverable Name already exists');
                        } 
                    }    
                    }
                }
            }
        }   
    }
        
        
        //***************************************************************************************************************
    // Method Name: JorneyDeliMasterNameCheckUpdate
    // Description: Before Updating Records,Checks whether Name  is already present with Other Service Management Task Master Record or not
    // Created By: Malkeet Singh
    // 
    
         public static void JorneyDeliMasterNameCheckUpdate()
    {
          List<Journey_Management_Deliverable__c  > triggernew = (List<Journey_Management_Deliverable__c  >)Trigger.new;
          Map<Id,Journey_Management_Deliverable__c  > newMap = (Map<Id,Journey_Management_Deliverable__c  >)Trigger.NewMap;
          Map<Id,Journey_Management_Deliverable__c  > oldMap = (Map<Id,Journey_Management_Deliverable__c  >)Trigger.OldMap;
          List<Journey_Management_Deliverable__c  > Namecheck = new List<Journey_Management_Deliverable__c  >();
          Set<String> Namesets1 = new Set<String>();
          Set<String> Namesets2 = new Set<String>();
          Map<String,String> existingJorneyDeliMastermap =  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.JourneyDeliMasterNameFlag = true;
        
          
          if(trigger.isBefore && trigger.isUpdate) 
            { 
            
            // Below section filterates duplicate Service Management Task Master names in the list of Service Management Task Master names coming in bulk mode from data loader
            // Making list Service Management Task MasterName1 with trigger.new enteries
                for(Journey_Management_Deliverable__c   SerManTaskMasterName1 : (List<Journey_Management_Deliverable__c  >)trigger.new)
                {
                if((trigger.isUpdate  && ((SerManTaskMasterName1.Deliverable_Name__c != oldMap.get(SerManTaskMasterName1.id).Deliverable_Name__c))))
                    {   // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list ServiceMasterName2 with trigger.new enteries
                        for(Journey_Management_Deliverable__c   ServiceMasterName2 : (List<Journey_Management_Deliverable__c  >)trigger.new)
                        {  
                         // Comparing names in two lists SerManTaskMasterName1 and ServiceMasterName2 to filter duplicate names from the list
                          
                            if(SerManTaskMasterName1.id !=ServiceMasterName2.id && SerManTaskMasterName1.Deliverable_Name__c.toLowerCase() == ServiceMasterName2.Deliverable_Name__c.toLowerCase() && SerManTaskMasterName1.Journey_Management__c!=ServiceMasterName2.Journey_Management__c) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                SerManTaskMasterName1.addError('Deliverable Name already exists');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether Service Management Task Master Name already exists in Database or not.
                            Namecheck.add(SerManTaskMasterName1);
                            Namesets1.add(SerManTaskMasterName1.Deliverable_Name__c);
                            
                            Namesets2.add(SerManTaskMasterName1.Journey_Management__c);
                        }
                    }
                }
                
                
                if(Namecheck != null && Namecheck.size()>0)
                {
                    List<Journey_Management_Deliverable__c> serviceMaster=[select id,Journey_Management__c, Deliverable_Name__c from Journey_Management_Deliverable__c  where Deliverable_Name__c=:Namesets1 and Journey_Management__c=:Namesets2];
                    if(serviceMaster.size()>0)
                    {
                    for(Journey_Management_Deliverable__c    existingName: serviceMaster)
                    {
                        //existingJorneyDeliMastermap.put(existingName.Deliverable_Name__c.toLowerCase(),existingName.Journey_Management__c);
                                        
                    for(Journey_Management_Deliverable__c    ServiceMasterRec : Namecheck) 
                    {                     
                       if(existingName.Journey_Management__c==ServiceMasterRec.Journey_Management__c && existingName.Deliverable_Name__c.toLowerCase()==ServiceMasterRec.Deliverable_Name__c.toLowerCase())//existingJorneyDeliMastermap.containsKey(ServiceMasterRec.Deliverable_Name__c.toLowerCase()))
                        {
                           //Associating error with duplicate 'BCP Task Master name' records
                            ServiceMasterRec.addError('Deliverable Name already exists');
                        } 
                    }    
                    }
                    }
                }
            }   
        }
        }