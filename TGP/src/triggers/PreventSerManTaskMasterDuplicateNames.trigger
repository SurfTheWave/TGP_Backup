//***************************************************************************************************************
// Name       :  PreventSerManTaskMasterDuplicateNames
// Description:  Trigger on Service_Management_Task_Master__c  to Prevent Duplicate Service Management Task Master names 
//
//             
//               
// Created By :  Sushmanth Hasti
// Date       : 10/06/2013
// **************************************************************************************************************

trigger PreventSerManTaskMasterDuplicateNames on Service_Management_Task_Master__c  (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
     //Below Flag is used to stop recursive method call
        
    if(Recursive.SerManTaskMasterNameFlag!= true) 
    PreventDuplicateSerManTaskMasterName.serManTaskMasterNameCheckInsert();
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
      //Below Flag is used to stop recursive method call
        
     if(Recursive.SerManTaskMasterNameFlag!=true) 
     PreventDuplicateSerManTaskMasterName.SerManTaskMasterNameCheckUpdate();
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}