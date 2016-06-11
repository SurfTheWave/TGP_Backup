//***************************************************************************************************************
// Name       :  PreventOfferingsMasterDuplicateNames
// Description:  Trigger on Offerings_Master__c  to Prevent Duplicate OfferingsMaster names 
//
//             
//               
// Created By :  Malkeet Singh
// Date       : 08/03/2013
// **************************************************************************************************************

trigger PreventOfferingsMasterDuplicateNames on Offerings_Master__c  (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
     //Below Flag is used to stop recursive method call
        
    if(Recursive.OfferingsMasterNameFlag!= true) 
    PreventDuplicateOfferingsMasterName.offeringsMasterNameCheckInsert();
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
      //Below Flag is used to stop recursive method call
        
     if(Recursive.OfferingsMasterNameFlag!=true) 
     PreventDuplicateOfferingsMasterName.offeringsMasterNameCheckUpdate();
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}