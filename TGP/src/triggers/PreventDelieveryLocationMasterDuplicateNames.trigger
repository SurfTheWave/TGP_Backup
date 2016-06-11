//***************************************************************************************************************
// Name       :  PreventDelieveryLocationMasterDuplicateNames
// Description:  Trigger on Delievery_Location_Master__c  to Prevent Duplicate DelieveryLocationMaster names 
//
//             
//               
// Created By :  Malkeet Singh
// Date       : 08/03/2013
// **************************************************************************************************************

trigger PreventDelieveryLocationMasterDuplicateNames on Delievery_Location_Master__c  (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
     //Below Flag is used to stop recursive method call
        
    if(Recursive.DelieveryLocationMasterNameFlag!= true) 
    PreventDuplicateDelLocMasterName.delieveryLocationMasterNameCheckInsert();
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
      //Below Flag is used to stop recursive method call
        
     if(Recursive.DelieveryLocationMasterNameFlag!=true) 
     PreventDuplicateDelLocMasterName.delieveryLocationMasterNameCheckUpdate();
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}