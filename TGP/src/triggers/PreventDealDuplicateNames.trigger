//***************************************************************************************************************
// Name       :  PreventDealDuplicateNames
// Description:  Trigger on Deal_TGP__c to Prevent Duplicate deal names 
//
//             
//               
// Created By :  Malkeet Singh
// Date       : 08/03/2013
// **************************************************************************************************************

trigger PreventDealDuplicateNames on Deal_TGP__c (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
      
    DealTriggerController.beforeInsert();
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
       
     DealTriggerController.beforeUpdate();
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}