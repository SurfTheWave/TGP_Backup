//***************************************************************************************************************
// Name       :  PreventJouManDelMasterDuplicateNames
// Description:  Trigger on Journey_Management_Deliverable__c    to Prevent Duplicate Journey Management Deliverables Task Master names 
//
//             
//               
// Created By :  Sushmanth Hasti
// Date       : 10/06/2013
// **************************************************************************************************************

trigger PreventJouManDelMasterDuplicateNames on Journey_Management_Deliverable__c    (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
     //Below Flag is used to stop recursive method call
        
    if(Recursive.SerManTaskMasterNameFlag!= true) 
    PreventDuplicateJorneyDeliMasterName.JorneyDeliMasterNameCheckInsert();
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
      //Below Flag is used to stop recursive method call
        
     if(Recursive.SerManTaskMasterNameFlag!=true) 
     PreventDuplicateJorneyDeliMasterName.JorneyDeliMasterNameCheckUpdate();
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}