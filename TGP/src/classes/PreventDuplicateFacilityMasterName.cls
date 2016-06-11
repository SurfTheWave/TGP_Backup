public class PreventDuplicateFacilityMasterName
{
//***************************************************************************************************************
    // Method Name: FacilityMasterNameCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other FacilityMaster Record or not
    // Created By: Malkeet Singh
    // Story: Story-0153/COM_065
    
    public static void FacilityMasterNameCheckInsert()
    {
          List<Facility_Master__c   > triggernew = (List<Facility_Master__c   >)Trigger.new;
          Map<Id,Facility_Master__c   > newMap = (Map<Id,Facility_Master__c   >)Trigger.NewMap;
          Map<Id,Facility_Master__c   > oldMap = (Map<Id,Facility_Master__c   >)Trigger.OldMap;
          List<Facility_Master__c   > Namecheck = new List<Facility_Master__c   >();
          Set<String> Namesets1 = new Set<String>();
          Set<String> Namesets2 = new Set<String>();
          Map<String,String> existingFacilityMastermap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.FacilityMasterNameFlag = true;
          Integer i=0;
          Integer j=0;
        
          
        if(trigger.isBefore && trigger.isInsert) 
        { 
               
                // Below section filterates duplicate FacilityMaster names in the list of FacilityMaster names coming in bulk mode from data loader
                for(i=0;i<triggernew.size();i++)
                {
                    Boolean intriggernew = false;
                    for(j=0;j<Namecheck.size();j++)
                    {    // Matching names of entries in the list coming in bulk mode                   
                        if((triggernew[i].Name.toLowerCase()==Namecheck[j].Name.toLowerCase()) && (triggernew[i].Delivery_Location_Master__c==Namecheck[j].Delivery_Location_Master__c) )                            
                        {
                            // Associating error with the duplicate 'FacilityMaster name' record in the list 
                            triggernew[i].addError('Facility  already exists');
                            intriggernew = true;                                                        
                        }                       
                        
                    }
                   
                    if(!intriggernew)
                    {
                        // Making List of names and Set of names to check Whether FacilityMaster Name already exists in Database or not.
                        Namecheck.add(triggernew[i]);
                        Namesets1.add(triggernew[i].Name);
                        Namesets2.add(triggernew[i].Delivery_Location_Master__c);
                        
                    }  
                }
                          
                if(Namecheck != null && Namecheck.size()>0)
                {
                    List<Facility_Master__c> facilityMaster=[select id,Delivery_Location_Master__c, Name from Facility_Master__c    where Name=:Namesets1 and Delivery_Location_Master__c=:Namesets2 ];
                    if(facilityMaster.size()>0)
                    {
                    for(Facility_Master__c    existingName: facilityMaster)
                    {
                        //existingfacilityMastermap.put(existingName.Name.toLowerCase(),existingName.Delivery_Location_Master__c);
                                        
                    for(Facility_Master__c    FacilityMasterRec : Namecheck) 
                    {                     
                       if(existingName.Delivery_Location_Master__c==FacilityMasterRec.Delivery_Location_Master__c && existingName.Name.toLowerCase()==FacilityMasterRec.Name.toLowerCase())//existingfacilityMastermap.containsKey(FacilityMasterRec.Name.toLowerCase()))
                        {
                           //Associating error with duplicate 'FacilityMaster name' records
                            FacilityMasterRec.addError('Facility Name already exists');
                        } 
                    }    
                    }
                }
            }
        }   
    }
        
        
        //***************************************************************************************************************
    // Method Name: FacilityMasterNameCheckUpdate
    // Description: Before Updating Records,Checks whether Name  is already present with Other facilityMaster Record or not
    // Created By: Malkeet Singh
    // 
    
         public static void FacilityMasterNameCheckUpdate()
    {
          List<Facility_Master__c  > triggernew = (List<Facility_Master__c  >)Trigger.new;
          Map<Id,Facility_Master__c  > newMap = (Map<Id,Facility_Master__c  >)Trigger.NewMap;
          Map<Id,Facility_Master__c  > oldMap = (Map<Id,Facility_Master__c  >)Trigger.OldMap;
          List<Facility_Master__c  > Namecheck = new List<Facility_Master__c  >();
          Set<String> Namesets1 = new Set<String>();
          Set<String> Namesets2 = new Set<String>();
          Map<String,String> existingfacilityMastermap =  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.FacilityMasterNameFlag = true;
        
          
          if(trigger.isBefore && trigger.isUpdate) 
            { 
            
            // Below section filterates duplicate FacilityMaster names in the list of FacilityMaster names coming in bulk mode from data loader
            // Making list FacilityMasterName1 with trigger.new enteries
                for(Facility_Master__c   FacilityMasterName1 : (List<Facility_Master__c  >)trigger.new)
                {
                
                    
                    
                    if((trigger.isUpdate  && ((FacilityMasterName1.Name != oldMap.get(FacilityMasterName1.id).Name))))
                    {   // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list FacilityMasterName2 with trigger.new enteries
                        for(Facility_Master__c   FacilityMasterName2 : (List<Facility_Master__c  >)trigger.new)
                        {  
                         
                          // Comparing names in two lists FacilityMasterName1 and FacilityMasterName2 to filter duplicate names from the list
                          
                            if(FacilityMasterName1.id !=FacilityMasterName2.id && FacilityMasterName1.Name.toLowerCase() == FacilityMasterName2.Name.toLowerCase() && FacilityMasterName1.Delivery_Location_Master__c !=FacilityMasterName2.Delivery_Location_Master__c) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                FacilityMasterName1.addError('Facility Name already exists');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether FacilityMaster Name already exists in Database or not.
                            Namecheck.add(FacilityMasterName1);
                            Namesets1.add(FacilityMasterName1.Name);
                            
                            Namesets2.add(FacilityMasterName1.Delivery_Location_Master__c);
                        }
                    }
                }
                
                
                if(Namecheck != null && Namecheck.size()>0)
                {
                    List<Facility_Master__c> facilityMaster=[select id,Delivery_Location_Master__c, Name from Facility_Master__c  where Name=:Namesets1 and Delivery_Location_Master__c=:Namesets2];
                    if(facilityMaster.size()>0)
                    {
                    for(Facility_Master__c    existingName: facilityMaster)
                    {
                        //existingfacilityMastermap.put(existingName.Name.toLowerCase(),existingName.Delivery_Location_Master__c);
                                        
                    for(Facility_Master__c    FacilityMasterRec : Namecheck) 
                    {                     
                       if(existingName.Delivery_Location_Master__c==FacilityMasterRec.Delivery_Location_Master__c && existingName.Name.toLowerCase()==FacilityMasterRec.Name.toLowerCase())//existingfacilityMastermap.containsKey(FacilityMasterRec.Name.toLowerCase()))
                        {
                           //Associating error with duplicate 'facilityMaster name' records
                            FacilityMasterRec.addError('Facility Name already exists');
                        } 
                    }    
                    }
                    }
                }
            }   
        }
        }