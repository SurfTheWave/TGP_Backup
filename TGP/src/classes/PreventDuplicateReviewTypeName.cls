public class PreventDuplicateReviewTypeName
{
//***************************************************************************************************************
    // Method Name: ReviewTypeNameCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other ReviewType Record or not
    // Created By: Varsha Chougule
    // Story: 
    
    public static void ReviewTypeNameCheckInsert()
    {
          List<Review_Type_Master__c   > triggernew = (List<Review_Type_Master__c   >)Trigger.new;
          Map<Id,Review_Type_Master__c   > newMap = (Map<Id,Review_Type_Master__c   >)Trigger.NewMap;
          Map<Id,Review_Type_Master__c   > oldMap = (Map<Id,Review_Type_Master__c   >)Trigger.OldMap;
          List<Review_Type_Master__c   > Namecheck = new List<Review_Type_Master__c   >();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingReviewTypemap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.ReviewTypeFlag = true;
          Integer i=0;
          Integer j=0;
        
          
        if(trigger.isBefore && trigger.isInsert) 
        { 
               
                // Below section filterates duplicate ReviewType names in the list of ReviewType names coming in bulk mode from data loader
                for(i=0;i<triggernew.size();i++)
                {
                    Boolean intriggernew = false;
                    for(j=0;j<Namecheck.size();j++)
                    {    // Matching names of entries in the list coming in bulk mode                   
                        if(triggernew[i].Name.toLowerCase()==Namecheck[j].Name.toLowerCase())                            
                        {
                            // Associating error with the duplicate 'ReviewType name' record in the list 
                            triggernew[i].addError('Review Type Name already exists');
                            intriggernew = true;                                                        
                        }                       
                        
                    }
                   
                    if(!intriggernew)
                    {
                        // Making List of names and Set of names to check Whether ReviewType Name already exists in Database or not.
                        Namecheck.add(triggernew[i]);
                        Namesets.add(triggernew[i].Name);
                        
                    }  
                }
                          
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Review_Type_Master__c    existingName: [select id, Name from Review_Type_Master__c    where Name=:Namesets])
                    {
                        existingReviewTypemap.put(existingName.Name.toLowerCase(),existingName.id);
                    }                    
                    for(Review_Type_Master__c    ReviewTypeRec : Namecheck) 
                    {                     
                       if(existingReviewTypemap != null && existingReviewTypemap.size()>0 && existingReviewTypemap.containsKey(ReviewTypeRec.Name.toLowerCase()))
                        {
                           //Associating error with duplicate 'ReviewType name' records
                            ReviewTypeRec.addError('Review Type Name already exists');
                        } 
                        
                    }
                }
            }   
        }
        
        
        //***************************************************************************************************************
    // Method Name: ReviewTypeNameCheckUpdate
    // Description: Before Updating Records,Checks whether Name  is already present with Other ReviewType Record or not
    // Created By: Malkeet Singh
    // 
    
         public static void ReviewTypeNameCheckUpdate()
    {
          List<Review_Type_Master__c  > triggernew = (List<Review_Type_Master__c  >)Trigger.new;
          Map<Id,Review_Type_Master__c  > newMap = (Map<Id,Review_Type_Master__c  >)Trigger.NewMap;
          Map<Id,Review_Type_Master__c  > oldMap = (Map<Id,Review_Type_Master__c  >)Trigger.OldMap;
          List<Review_Type_Master__c  > Namecheck = new List<Review_Type_Master__c  >();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingReviewTypemap =  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.ReviewTypeFlag = true;
        
          
          if(trigger.isBefore && trigger.isUpdate) 
            { 
            
            // Below section filterates duplicate ReviewType names in the list of ReviewType names coming in bulk mode from data loader
            // Making list ReviewTypeName1 with trigger.new enteries
                for(Review_Type_Master__c   ReviewTypeName1 : (List<Review_Type_Master__c  >)trigger.new)
                {
                    if((trigger.isUpdate  && ((ReviewTypeName1.Name != oldMap.get(ReviewTypeName1.id).Name) )))
                    {   // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list ReviewTypeName2 with trigger.new enteries
                        for(Review_Type_Master__c   ReviewTypeName2 : (List<Review_Type_Master__c  >)trigger.new)
                        {  
                          
                          // Comparing names in two lists ReviewTypeName1 and ReviewTypeName2 to filter duplicate names from the list
                          
                            if(ReviewTypeName1.id !=ReviewTypeName2.id && ReviewTypeName1.Name.toLowerCase() == ReviewTypeName2.Name.toLowerCase()) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                ReviewTypeName1.addError('Review Type Name already exists');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether ReviewType Name already exists in Database or not.
                            Namecheck.add(ReviewTypeName1);
                            Namesets.add(ReviewTypeName1.Name);
                        }
                    }
                }
                
                
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Review_Type_Master__c   existingName: [select id, Name from Review_Type_Master__c   where Name=:Namesets])
                    {
                        existingReviewTypemap.put(existingName.Name.toLowerCase(),existingName.id);
                    }
                    
                    for(Review_Type_Master__c   ReviewTypeRec : Namecheck) 
                    {  
                      
                       if(existingReviewTypemap != null && existingReviewTypemap.size()>0 && existingReviewTypemap.containsKey(ReviewTypeRec.Name.toLowerCase()))
                        {
                        // Adding error to the duplicate record
                            ReviewTypeRec.addError('Review Type Name already exists');
                        } 
                        
                    }
                }
            }
    }
  }