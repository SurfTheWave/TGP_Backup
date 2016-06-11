//***************************************************************************************************************
// Name       :  PreventTechAsmentActiMasterDuplicateName
// Description:  Controller of Trigger on Tech_Assessment_Activity_Master__c to Prevent Duplicate names 
//
//             
//               
// Created By :  Malkeet Singh
// Date       : 08/03/2013
// **************************************************************************************************************


public class PreventTechAsmentActiMasterDuplicateName
{
//***************************************************************************************************************
    // Method Name: TechAssessmentActivityNameCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other  Record or not
    // Created By: Malkeet Singh
    // 
    
    public static void TechAssessmentActivityNameCheckInsert()
    {
          List<Tech_Assessment_Activity_Master__c> triggernew = (List<Tech_Assessment_Activity_Master__c>)Trigger.new;
          Map<Id,Tech_Assessment_Activity_Master__c> newMap = (Map<Id,Tech_Assessment_Activity_Master__c>)Trigger.NewMap;
          Map<Id,Tech_Assessment_Activity_Master__c> oldMap = (Map<Id,Tech_Assessment_Activity_Master__c>)Trigger.OldMap;
          List<Tech_Assessment_Activity_Master__c> Namecheck = new List<Tech_Assessment_Activity_Master__c>();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingActivitymap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.TechAssessmentActivitiesMasterFlag = true;
          Integer i=0;
          Integer j=0;
        
          
        if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate) ) 
        { 
               
                // Below section filterates duplicate Activity names in the list of Activity names coming in bulk mode from data loader
                for(i=0;i<triggernew.size();i++)
                {
                    Boolean intriggernew = false;
                    for(j=0;j<Namecheck.size();j++)
                    {    // Matching names of entries in the list coming in bulk mode                   
                        if(triggernew[i].Name.toLowerCase()==Namecheck[j].Name.toLowerCase())                            
                        {
                            // Associating error with the duplicate 'Activity name' record ik the list 
                            triggernew[i].addError('Activity Name already exists');
                            intriggernew = true;                                                        
                        }                       
                        
                    }
                   
                    if(!intriggernew)
                    {
                        // Making List of names and Set of names to check Whether Activity Name already exists in Database or not.
                        Namecheck.add(triggernew[i]);
                        Namesets.add(triggernew[i].Name);
                        
                    }  
                }
                          
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Tech_Assessment_Activity_Master__c existingName: [select id, Name from Tech_Assessment_Activity_Master__c where Name=:Namesets])
                    {
                        
                            existingActivitymap.put(existingName.Name.toLowerCase(),existingName.id);
                        
                    }                    
                    for(Tech_Assessment_Activity_Master__c ActivityRec : Namecheck) 
                    {                     
                       if(existingActivitymap != null && existingActivitymap.size()>0 && existingActivitymap.containsKey(ActivityRec.Name.toLowerCase()))
                        {
                           //Associating error with duplicate 'Activity name' records
                            ActivityRec.addError('Activity Name already exists');
                        } 
                        
                    }
                }
            }   
        }
        
        
        //***************************************************************************************************************
    // Method Name: TechAssessmentActivityNameCheckUpdate
    // Description: Before Upsating Records,Checks whether Name  is already present with Other  Record or not
    // Created By: Malkeet Singh
    // 
    
         public static void TechAssessmentActivityNameCheckUpdate()
    {
          List<Tech_Assessment_Activity_Master__c> triggernew = (List<Tech_Assessment_Activity_Master__c>)Trigger.new;
          Map<Id,Tech_Assessment_Activity_Master__c> newMap = (Map<Id,Tech_Assessment_Activity_Master__c>)Trigger.NewMap;
          Map<Id,Tech_Assessment_Activity_Master__c> oldMap = (Map<Id,Tech_Assessment_Activity_Master__c>)Trigger.OldMap;
          List<Tech_Assessment_Activity_Master__c> Namecheck = new List<Tech_Assessment_Activity_Master__c>();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingActivitymap =  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.TechAssessmentActivitiesMasterFlag = true;
        
          
          if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) 
            { 
            
            // Below section filterates duplicate Activity names in the list of Activity names coming in bulk mode from data loader
            // Making list Activityname1 with trigger.new enteries
                for(Tech_Assessment_Activity_Master__c ActivityName1 : (List<Tech_Assessment_Activity_Master__c>)trigger.new)
                {
                    if((trigger.isUpdate  && ((ActivityName1.Name != oldMap.get(ActivityName1.id).Name) )))
                    {   // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list ActivityName2 with trigger.new enteries
                        for(Tech_Assessment_Activity_Master__c ActivityName2 : (List<Tech_Assessment_Activity_Master__c>)trigger.new)
                        {  
                          
                          // Comparing names in two lists ActivityName1 and ActivityName2 to filter duplicate names from the list
                          
                            if(ActivityName1.id !=ActivityName2.id && ActivityName1.Name.toLowerCase() == ActivityName2.Name.toLowerCase()) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                ActivityName1.addError('Activity Name already exists');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether Activity Name already exists in Database or not.
                            Namecheck.add(ActivityName1);
                            Namesets.add(ActivityName1.Name);
                        }
                    }
                }
                
                
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Tech_Assessment_Activity_Master__c existingName: [select id, Name from Tech_Assessment_Activity_Master__c where Name=:Namesets])
                    {
                        
                            existingActivitymap.put(existingName.Name.toLowerCase(),existingName.id);
                        
                    }
                    
                    for(Tech_Assessment_Activity_Master__c ActivityRec : Namecheck) 
                    {  
                      
                       if(existingActivitymap != null && existingActivitymap.size()>0 && existingActivitymap.containsKey(ActivityRec.Name.toLowerCase()))
                        {
                        // Adding error to the duplicate record
                            ActivityRec.addError('Activity Name already exists');
                        } 
                        
                    }
                }
            }
    }
  }