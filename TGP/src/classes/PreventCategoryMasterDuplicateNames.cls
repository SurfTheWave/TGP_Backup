public class PreventCategoryMasterDuplicateNames 
{
//***************************************************************************************************************
    // Method Name: categoryMasterNameCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other ClientMaster Record or not
    // Created By: Shridhar Patankar
    // Story: Story-151
    
    public static void categoryMasterNameCheckInsert()
    {
          List<Category__c> triggernew = (List<Category__c>)Trigger.new;
          Map<Id,Category__c> newMap = (Map<Id,Category__c>)Trigger.NewMap;
          Map<Id,Category__c> oldMap = (Map<Id,Category__c>)Trigger.OldMap;
          List<Category__c> Namecheck = new List<Category__c>();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingCategorymap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.CategoryNameFlag= true;
          Integer i=0;
          Integer j=0;
        
          
        if(trigger.isBefore && trigger.isInsert) 
        { 
               
                // Below section filterates duplicate Category names in the list of Category names coming in bulk mode from data loader
                for(i=0;i<triggernew.size();i++)
                {
                    Boolean intriggernew = false;
                    for(j=0;j<Namecheck.size();j++)
                    {    // Matching names of entries in the list coming in bulk mode                   
                        if(triggernew[i].Name.toLowerCase()==Namecheck[j].Name.toLowerCase())                            
                        {
                            // Associating error with the duplicate 'ClientMaster name' record in the list 
                            triggernew[i].addError('Category already exists');
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
                    for(Category__c existingName: [select id, Name from Category__c where Name=:Namesets])
                    {
                        existingCategorymap.put(existingName.Name.toLowerCase(),existingName.id);
                    }                    
                    for(Category__c CategoryMasterRec : Namecheck) 
                    {                     
                       if(existingCategorymap!= null && existingCategorymap.size()>0 && existingCategorymap.containsKey(CategoryMasterRec.Name.toLowerCase()))
                        {
                           //Associating error with duplicate 'Category name' records
                            CategoryMasterRec.addError('Category already exists');
                        } 
                        
                    }
                }
            }   
        }
        
        
        //***************************************************************************************************************
    // Method Name: ClientMasterNameCheckUpdate
    // Description: Before Updating Records,Checks whether Name  is already present with Other Category Record or not
    // Created By: Shridhar Patankar
    // 
    
         public static void categoryMasterNameCheckUpdate()
    {
          List<Category__c> triggernew = (List<Category__c>)Trigger.new;
          Map<Id,Category__c> newMap = (Map<Id,Category__c>)Trigger.NewMap;
          Map<Id,Category__c> oldMap = (Map<Id,Category__c>)Trigger.OldMap;
          List<Category__c> Namecheck = new List<Category__c>();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingCategoryMastermap =  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.CategoryNameFlag= true;
        
          
          if(trigger.isBefore && trigger.isUpdate) 
            { 
            
            // Below section filterates duplicate ClientMaster names in the list of ClientMaster names coming in bulk mode from data loader
            // Making list ClientMasterName1 with trigger.new enteries
                for(Category__c CategoryMasterName1 : (List<Category__c>)trigger.new)
                {
                      if((trigger.isUpdate  && ((CategoryMasterName1.Name != oldMap.get(CategoryMasterName1.id).Name) )))
                    {   // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list CategoryMasterName2 with trigger.new enteries
                        for(Category__c CategoryMasterName2 : (List<Category__c>)trigger.new)
                        {  
                          
                          // Comparing names in two lists CategoryMasterName1 and CategoryMasterName2 to filter duplicate names from the list
                          
                            if(CategoryMasterName1.id !=CategoryMasterName2.id && CategoryMasterName1.Name.toLowerCase() == CategoryMasterName2.Name.toLowerCase()) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                CategoryMasterName1.addError('Category Name already exists');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether Category Name already exists in Database or not.
                            Namecheck.add(CategoryMasterName1);
                            Namesets.add(CategoryMasterName1.Name);
                        }
                    }
                }
                
                
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Category__c existingName: [select id, Name from Category__c where Name=:Namesets])
                    {
                        existingCategoryMastermap.put(existingName.Name.toLowerCase(),existingName.id);
                    }
                    
                    for(Category__c ClientMasterRec : Namecheck) 
                    {  
                      
                       if(existingCategoryMastermap!= null && existingCategoryMastermap.size()>0 && existingCategoryMastermap.containsKey(ClientMasterRec.Name.toLowerCase()))
                        {
                        // Adding error to the duplicate record
                            ClientMasterRec.addError('Category Name already exists');
                        } 
                        
                    }
                }
            }
    }
  }