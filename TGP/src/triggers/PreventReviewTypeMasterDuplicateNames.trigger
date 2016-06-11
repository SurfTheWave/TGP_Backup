//***************************************************************************************************************
// Name       :  PreventReviewTypeMasterDuplicateNames
// Description:  Trigger on Review_Type_Master__c  to Prevent Duplicate ReviewType names 
//
//             
//               
// Created By :  Varsha Chougule
// Date       : 5/14/2013
// **************************************************************************************************************

trigger PreventReviewTypeMasterDuplicateNames on Review_Type_Master__c  (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
     //Below Flag is used to stop recursive method call
        
    if(Recursive.ReviewTypeFlag!= true) 
    PreventDuplicateReviewTypeName.ReviewTypeNameCheckInsert();
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
      //Below Flag is used to stop recursive method call
        
     if(Recursive.ReviewTypeFlag!=true) 
     PreventDuplicateReviewTypeName.ReviewTypeNameCheckUpdate();
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}