//***************************************************************************************************************
// Name       :  PreventBCPTaskMasterDuplicateNames
// Description:  Trigger on BCP_Task_Master__c   to Prevent Duplicate Service Management Task Master names 
//
//             
//               
// Created By :  Sushmanth Hasti
// Date       : 10/06/2013
// **************************************************************************************************************

trigger PreventBCPTaskMasterDuplicateNames on BCP_Task_Master__c   (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
     //Below Flag is used to stop recursive method call
        
    if(Recursive.BCPTaskMasterNameFlag != true) 
    PreventDuplicateBCPTaskMasterName.BCPTaskMasterNameCheckInsert();
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
      //Below Flag is used to stop recursive method call
        
     if(Recursive.BCPTaskMasterNameFlag !=true) 
     PreventDuplicateBCPTaskMasterName.BCPTaskMasterNameCheckUpdate();
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}