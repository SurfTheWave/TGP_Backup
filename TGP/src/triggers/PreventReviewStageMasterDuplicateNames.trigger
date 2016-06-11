//***************************************************************************************************************
// Name       :  PreventReviewStageMasterDuplicateNames
// Description:  Trigger on Review_Stage_Master__c  to Prevent Duplicate ReviewStage names 
//
//             
//               
// Created By :  Malkeet Singh
// Date       : 5/14/2013
// **************************************************************************************************************

trigger PreventReviewStageMasterDuplicateNames on Review_Stage_Master__c  (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
     //Below Flag is used to stop recursive method call
        
    if(Recursive.reviewstageFlag!= true) 
    PreventDuplicateReviewStageName.ReviewStageNameCheckInsert();
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
      //Below Flag is used to stop recursive method call
        
     if(Recursive.reviewstageFlag!=true) 
     PreventDuplicateReviewStageName.ReviewStageNameCheckUpdate();
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}