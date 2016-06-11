public class PreventDuplicateBCPTaskMasterName
{
//***************************************************************************************************************
    // Method Name: BCPTaskMasterNameCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other Service Management Master Record or not
    // Created By: Malkeet Singh
    // Story: Story-0153/COM_065
    
    public static void BCPTaskMasterNameCheckInsert()
    {
          List<BCP_Task_Master__c   > triggernew = (List<BCP_Task_Master__c   >)Trigger.new;
          Map<Id,BCP_Task_Master__c   > newMap = (Map<Id,BCP_Task_Master__c   >)Trigger.NewMap;
          Map<Id,BCP_Task_Master__c   > oldMap = (Map<Id,BCP_Task_Master__c   >)Trigger.OldMap;
          List<BCP_Task_Master__c   > Namecheck = new List<BCP_Task_Master__c   >();
          Set<String> Namesets1 = new Set<String>();
          Set<String> Namesets2 = new Set<String>();
          Map<String,String> existingBCPTaskMastermap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.BCPTaskMasterNameFlag = true;
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
                        if((triggernew[i].Task_Name__c.toLowerCase()==Namecheck[j].Task_Name__c.toLowerCase()) && (triggernew[i].Business_Continuity_Planning_del__c==Namecheck[j].Business_Continuity_Planning_del__c) )                            
                        {
                            // Associating error with the duplicate 'BCP Task Master name' record in the list 
                            triggernew[i].addError('Task already exists');
                            intriggernew = true;                                                        
                        }                       
                        
                    }
                   
                    if(!intriggernew)
                    {
                        // Making List of names and Set of names to check Whether BCP Master Name already exists in Database or not.
                        Namecheck.add(triggernew[i]);
                        Namesets1.add(triggernew[i].Task_Name__c);
                        Namesets2.add(triggernew[i].Business_Continuity_Planning_del__c);
                        
                    }  
                }
                          
                if(Namecheck != null && Namecheck.size()>0)
                {
                    List<BCP_Task_Master__c> serviceMaster=[select id,Business_Continuity_Planning_del__c, Task_Name__c from BCP_Task_Master__c    where Task_Name__c=:Namesets1 and Business_Continuity_Planning_del__c=:Namesets2 ];
                    if(serviceMaster.size()>0)
                    {
                    for(BCP_Task_Master__c    existingName: serviceMaster)
                    {
                        //existingBCPTaskMastermap.put(existingName.Task_Name__c.toLowerCase(),existingName.BCP_Section_Master__c);
                                        
                    for(BCP_Task_Master__c    ServiceMasterRec : Namecheck) 
                    {                     
                       if(existingName.Business_Continuity_Planning_del__c==ServiceMasterRec.Business_Continuity_Planning_del__c && existingName.Task_Name__c.toLowerCase()==ServiceMasterRec.Task_Name__c.toLowerCase())//existingBCPTaskMastermap.containsKey(ServiceMasterRec.Task_Name__c.toLowerCase()))
                        {
                           //Associating error with duplicate 'Service Management Task Master name' records
                            ServiceMasterRec.addError('BCP Task Name already exists');
                        } 
                    }    
                    }
                }
            }
        }   
    }
        
        
        //***************************************************************************************************************
    // Method Name: SerManTaskMasterNameCheckUpdate
    // Description: Before Updating Records,Checks whether Name  is already present with Other Service Management Task Master Record or not
    // Created By: Malkeet Singh
    // 
    
         public static void BCPTaskMasterNameCheckUpdate()
    {
          List<BCP_Task_Master__c  > triggernew = (List<BCP_Task_Master__c  >)Trigger.new;
          Map<Id,BCP_Task_Master__c  > newMap = (Map<Id,BCP_Task_Master__c  >)Trigger.NewMap;
          Map<Id,BCP_Task_Master__c  > oldMap = (Map<Id,BCP_Task_Master__c  >)Trigger.OldMap;
          List<BCP_Task_Master__c  > Namecheck = new List<BCP_Task_Master__c  >();
          Set<String> Namesets1 = new Set<String>();
          Set<String> Namesets2 = new Set<String>();
          Map<String,String> existingBCPTaskMastermap =  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.BCPTaskMasterNameFlag = true;
        
          
          if(trigger.isBefore && trigger.isUpdate) 
            { 
            
            // Below section filterates duplicate Service Management Task Master names in the list of Service Management Task Master names coming in bulk mode from data loader
            // Making list Service Management Task MasterName1 with trigger.new enteries
                for(BCP_Task_Master__c   SerManTaskMasterName1 : (List<BCP_Task_Master__c  >)trigger.new)
                {
                
                    if((trigger.isUpdate  && ((SerManTaskMasterName1.Task_Name__c != oldMap.get(SerManTaskMasterName1.id).Task_Name__c))))
                    {   // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list ServiceMasterName2 with trigger.new enteries
                        for(BCP_Task_Master__c   ServiceMasterName2 : (List<BCP_Task_Master__c  >)trigger.new)
                        {  
                          // Comparing names in two lists SerManTaskMasterName1 and ServiceMasterName2 to filter duplicate names from the list
                          
                            if(SerManTaskMasterName1.id !=ServiceMasterName2.id && SerManTaskMasterName1.Task_Name__c.toLowerCase() == ServiceMasterName2.Task_Name__c.toLowerCase() && SerManTaskMasterName1.Business_Continuity_Planning_del__c!=ServiceMasterName2.Business_Continuity_Planning_del__c) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                SerManTaskMasterName1.addError('BCP Task Name already exists');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether Service Management Task Master Name already exists in Database or not.
                            Namecheck.add(SerManTaskMasterName1);
                            Namesets1.add(SerManTaskMasterName1.Task_Name__c);
                            
                            Namesets2.add(SerManTaskMasterName1.Business_Continuity_Planning_del__c);
                        }
                    }
                }
                
                
                if(Namecheck != null && Namecheck.size()>0)
                {
                    List<BCP_Task_Master__c> serviceMaster=[select id,Business_Continuity_Planning_del__c, Task_Name__c from BCP_Task_Master__c  where Task_Name__c=:Namesets1 and Business_Continuity_Planning_del__c=:Namesets2];
                    if(serviceMaster.size()>0)
                    {
                    for(BCP_Task_Master__c    existingName: serviceMaster)
                    {
                        //existingBCPTaskMastermap.put(existingName.Task_Name__c.toLowerCase(),existingName.BCP_Section_Master__c);
                                        
                    for(BCP_Task_Master__c    ServiceMasterRec : Namecheck) 
                    {                     
                       if(existingName.Business_Continuity_Planning_del__c==ServiceMasterRec.Business_Continuity_Planning_del__c && existingName.Task_Name__c.toLowerCase()==ServiceMasterRec.Task_Name__c.toLowerCase())//existingBCPTaskMastermap.containsKey(ServiceMasterRec.Task_Name__c.toLowerCase()))
                        {
                           //Associating error with duplicate 'BCP Task Master name' records
                            ServiceMasterRec.addError('BCP Task Name already exists');
                        } 
                    }    
                    }
                    }
                }
            }   
        }
        }