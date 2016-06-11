public class PreventDuplicateReviewStageName
{
//***************************************************************************************************************
    // Method Name: ReviewStageNameCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other ReviewStage Record or not
    // Created By: Malkeet Singh
    // Story: 
    
    public static void ReviewStageNameCheckInsert()
    {
          List<Review_Stage_Master__c   > triggernew = (List<Review_Stage_Master__c   >)Trigger.new;
          Map<Id,Review_Stage_Master__c   > newMap = (Map<Id,Review_Stage_Master__c   >)Trigger.NewMap;
          Map<Id,Review_Stage_Master__c   > oldMap = (Map<Id,Review_Stage_Master__c   >)Trigger.OldMap;
          List<Review_Stage_Master__c   > Namecheck = new List<Review_Stage_Master__c   >();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingReviewStagemap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.reviewStageFlag = true;
          Integer i=0;
          Integer j=0;
        
          
        if(trigger.isBefore && trigger.isInsert) 
        { 
               
                // Below section filterates duplicate ReviewStage names in the list of ReviewStage names coming in bulk mode from data loader
                for(i=0;i<triggernew.size();i++)
                {
                    Boolean intriggernew = false;
                    for(j=0;j<Namecheck.size();j++)
                    {    // Matching names of entries in the list coming in bulk mode                   
                        if(triggernew[i].Name.toLowerCase()==Namecheck[j].Name.toLowerCase())                            
                        {
                            // Associating error with the duplicate 'ReviewStage name' record in the list 
                            triggernew[i].addError('Review Stage Name already exists');
                            intriggernew = true;                                                        
                        }                       
                        
                    }
                   
                    if(!intriggernew)
                    {
                        // Making List of names and Set of names to check Whether ReviewStage Name already exists in Database or not.
                        Namecheck.add(triggernew[i]);
                        Namesets.add(triggernew[i].Name);
                        
                    }  
                }
                          
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Review_Stage_Master__c    existingName: [select id, Name from Review_Stage_Master__c    where Name=:Namesets])
                    {
                        existingReviewStagemap.put(existingName.Name.toLowerCase(),existingName.id);
                    }                    
                    for(Review_Stage_Master__c    ReviewStageRec : Namecheck) 
                    {                     
                       if(existingReviewStagemap != null && existingReviewStagemap.size()>0 && existingReviewStagemap.containsKey(ReviewStageRec.Name.toLowerCase()))
                        {
                           //Associating error with duplicate 'ReviewStage name' records
                            ReviewStageRec.addError('Review Stage Name already exists');
                        } 
                        
                    }
                }
            }   
        }
        
        
        //***************************************************************************************************************
    // Method Name: ReviewStageNameCheckUpdate
    // Description: Before Updating Records,Checks whether Name  is already present with Other ReviewStage Record or not
    // Created By: Malkeet Singh
    // 
    
         public static void ReviewStageNameCheckUpdate()
    {
          List<Review_Stage_Master__c  > triggernew = (List<Review_Stage_Master__c  >)Trigger.new;
          Map<Id,Review_Stage_Master__c  > newMap = (Map<Id,Review_Stage_Master__c  >)Trigger.NewMap;
          Map<Id,Review_Stage_Master__c  > oldMap = (Map<Id,Review_Stage_Master__c  >)Trigger.OldMap;
          List<Review_Stage_Master__c  > Namecheck = new List<Review_Stage_Master__c  >();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingReviewStagemap =  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.reviewStageFlag = true;
        
          
          if(trigger.isBefore && trigger.isUpdate) 
            { 
            
            // Below section filterates duplicate ReviewStage names in the list of ReviewStage names coming in bulk mode from data loader
            // Making list ReviewStageName1 with trigger.new enteries
                for(Review_Stage_Master__c   ReviewStageName1 : (List<Review_Stage_Master__c  >)trigger.new)
                {
                    if((trigger.isUpdate  && ((ReviewStageName1.Name != oldMap.get(ReviewStageName1.id).Name) )))
                    {   // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list ReviewStageName2 with trigger.new enteries
                        for(Review_Stage_Master__c   ReviewStageName2 : (List<Review_Stage_Master__c  >)trigger.new)
                        {  
                          
                          // Comparing names in two lists ReviewStageName1 and ReviewStageName2 to filter duplicate names from the list
                          
                            if(ReviewStageName1.id !=ReviewStageName2.id && ReviewStageName1.Name.toLowerCase() == ReviewStageName2.Name.toLowerCase()) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                ReviewStageName1.addError('Review Stage Name already exists');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether ReviewStage Name already exists in Database or not.
                            Namecheck.add(ReviewStageName1);
                            Namesets.add(ReviewStageName1.Name);
                        }
                    }
                }
                
                
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Review_Stage_Master__c   existingName: [select id, Name from Review_Stage_Master__c   where Name=:Namesets])
                    {
                        existingReviewStagemap.put(existingName.Name.toLowerCase(),existingName.id);
                    }
                    
                    for(Review_Stage_Master__c   ReviewStageRec : Namecheck) 
                    {  
                      
                       if(existingReviewStagemap != null && existingReviewStagemap.size()>0 && existingReviewStagemap.containsKey(ReviewStageRec.Name.toLowerCase()))
                        {
                        // Adding error to the duplicate record
                            ReviewStageRec.addError('Review Stage Name already exists');
                        } 
                        
                    }
                }
            }
    }
  }