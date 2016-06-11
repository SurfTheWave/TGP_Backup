//***************************************************************************************************************
// Name       :  PreventCategoryMasterDuplicateNames 
// Description:  Trigger on Category__c to Prevent Duplicate Category names 
//
// Story      :Sol_151        
//               
// Created By :  Shridhar Patankar
// Date       : 27/05/2013
// **************************************************************************************************************

trigger PreventCategoryMasterDuplicateNames on Category__c(before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
     //Below Flag is used to stop recursive method call
        
    if(Recursive.CategoryNameFlag!= true) 
    PreventCategoryMasterDuplicateNames.categoryMasterNameCheckInsert();
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
      //Below Flag is used to stop recursive method call
        
     if(Recursive.CategoryNameFlag!=true) 
     PreventCategoryMasterDuplicateNames.categoryMasterNameCheckUpdate();
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}