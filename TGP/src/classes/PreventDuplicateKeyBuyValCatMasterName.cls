public class PreventDuplicateKeyBuyValCatMasterName
{
//***************************************************************************************************************
    // Method Name: KeyBuyerValueCategoryMasterNameCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other KeyBuyerValueCategoryMaster Record or not
    // Created By: Malkeet Singh
    // Story: Story-0153/COM_065
    
    public static void keyBuyerValueCategoryMasterNameCheckInsert()
    {
          List<Key_Buyer_Value_Category_Master__c   > triggernew = (List<Key_Buyer_Value_Category_Master__c   >)Trigger.new;
          Map<Id,Key_Buyer_Value_Category_Master__c   > newMap = (Map<Id,Key_Buyer_Value_Category_Master__c   >)Trigger.NewMap;
          Map<Id,Key_Buyer_Value_Category_Master__c   > oldMap = (Map<Id,Key_Buyer_Value_Category_Master__c   >)Trigger.OldMap;
          List<Key_Buyer_Value_Category_Master__c   > Namecheck = new List<Key_Buyer_Value_Category_Master__c   >();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingKeyBuyerValueCategoryMastermap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.KeyBuyerValueCategoryMasterNameFlag = true;
          Integer i=0;
          Integer j=0;
        
          
        if(trigger.isBefore && trigger.isInsert) 
        { 
               
                // Below section filterates duplicate KeyBuyerValueCategoryMaster names in the list of KeyBuyerValueCategoryMaster names coming in bulk mode from data loader
                for(i=0;i<triggernew.size();i++)
                {
                    Boolean intriggernew = false;
                    for(j=0;j<Namecheck.size();j++)
                    {    // Matching names of entries in the list coming in bulk mode                   
                        if(triggernew[i].Name.toLowerCase()==Namecheck[j].Name.toLowerCase())                            
                        {
                            // Associating error with the duplicate 'KeyBuyerValueCategoryMaster name' record in the list 
                            triggernew[i].addError('Key Buyer Value Category Name already exists');
                            intriggernew = true;                                                        
                        }                       
                        
                    }
                   
                    if(!intriggernew)
                    {
                        // Making List of names and Set of names to check Whether KeyBuyerValueCategoryMaster Name already exists in Database or not.
                        Namecheck.add(triggernew[i]);
                        Namesets.add(triggernew[i].Name);
                        
                    }  
                }
                          
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Key_Buyer_Value_Category_Master__c    existingName: [select id, Name from Key_Buyer_Value_Category_Master__c    where Name=:Namesets])
                    {
                        existingKeyBuyerValueCategoryMastermap.put(existingName.Name.toLowerCase(),existingName.id);
                    }                    
                    for(Key_Buyer_Value_Category_Master__c    KeyBuyerValueCategoryMasterRec : Namecheck) 
                    {                     
                       if(existingKeyBuyerValueCategoryMastermap != null && existingKeyBuyerValueCategoryMastermap.size()>0 && existingKeyBuyerValueCategoryMastermap.containsKey(KeyBuyerValueCategoryMasterRec.Name.toLowerCase()))
                        {
                           //Associating error with duplicate 'KeyBuyerValueCategoryMaster name' records
                            KeyBuyerValueCategoryMasterRec.addError('Key Buyer Value Category Name already exists');
                        } 
                        
                    }
                }
            }   
        }
        
        
        //***************************************************************************************************************
    // Method Name: KeyBuyerValueCategoryMasterNameCheckUpdate
    // Description: Before Updating Records,Checks whether Name  is already present with Other KeyBuyerValueCategoryMaster Record or not
    // Created By: Malkeet Singh
    // 
    
         public static void keyBuyerValueCategoryMasterNameCheckUpdate()
    {
          List<Key_Buyer_Value_Category_Master__c  > triggernew = (List<Key_Buyer_Value_Category_Master__c  >)Trigger.new;
          Map<Id,Key_Buyer_Value_Category_Master__c  > newMap = (Map<Id,Key_Buyer_Value_Category_Master__c  >)Trigger.NewMap;
          Map<Id,Key_Buyer_Value_Category_Master__c  > oldMap = (Map<Id,Key_Buyer_Value_Category_Master__c  >)Trigger.OldMap;
          List<Key_Buyer_Value_Category_Master__c  > Namecheck = new List<Key_Buyer_Value_Category_Master__c  >();
          Set<String> Namesets = new Set<String>();
          Map<String,String> existingKeyBuyerValueCategoryMastermap =  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.KeyBuyerValueCategoryMasterNameFlag = true;
        
          
          if(trigger.isBefore && trigger.isUpdate) 
            { 
            
            // Below section filterates duplicate KeyBuyerValueCategoryMaster names in the list of KeyBuyerValueCategoryMaster names coming in bulk mode from data loader
            // Making list KeyBuyerValueCategoryMasterName1 with trigger.new enteries
                for(Key_Buyer_Value_Category_Master__c   KeyBuyerValueCategoryMasterName1 : (List<Key_Buyer_Value_Category_Master__c  >)trigger.new)
                {
                    if((trigger.isUpdate  && ((KeyBuyerValueCategoryMasterName1.Name != oldMap.get(KeyBuyerValueCategoryMasterName1.id).Name) )))
                    {   // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list KeyBuyerValueCategoryMasterName2 with trigger.new enteries
                        for(Key_Buyer_Value_Category_Master__c   KeyBuyerValueCategoryMasterName2 : (List<Key_Buyer_Value_Category_Master__c  >)trigger.new)
                        {  
                          
                          // Comparing names in two lists KeyBuyerValueCategoryMasterName1 and KeyBuyerValueCategoryMasterName2 to filter duplicate names from the list
                          
                            if(KeyBuyerValueCategoryMasterName1.id !=KeyBuyerValueCategoryMasterName2.id && KeyBuyerValueCategoryMasterName1.Name.toLowerCase() == KeyBuyerValueCategoryMasterName2.Name.toLowerCase()) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                KeyBuyerValueCategoryMasterName1.addError('Key Buyer Value Category Name already exists');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether KeyBuyerValueCategoryMaster Name already exists in Database or not.
                            Namecheck.add(KeyBuyerValueCategoryMasterName1);
                            Namesets.add(KeyBuyerValueCategoryMasterName1.Name);
                        }
                    }
                }
                
                
                if(Namecheck != null && Namecheck.size()>0)
                {
                    for(Key_Buyer_Value_Category_Master__c   existingName: [select id, Name from Key_Buyer_Value_Category_Master__c   where Name=:Namesets])
                    {
                        existingKeyBuyerValueCategoryMastermap.put(existingName.Name.toLowerCase(),existingName.id);
                    }
                    
                    for(Key_Buyer_Value_Category_Master__c   KeyBuyerValueCategoryMasterRec : Namecheck) 
                    {  
                      
                       if(existingKeyBuyerValueCategoryMastermap != null && existingKeyBuyerValueCategoryMastermap.size()>0 && existingKeyBuyerValueCategoryMastermap.containsKey(KeyBuyerValueCategoryMasterRec.Name.toLowerCase()))
                        {
                        // Adding error to the duplicate record
                            KeyBuyerValueCategoryMasterRec.addError('Key Buyer Value Category Name already exists');
                        } 
                        
                    }
                }
            }
    }
  }