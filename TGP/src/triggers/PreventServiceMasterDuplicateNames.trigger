//***************************************************************************************************************
// Name       :  PreventServiceMasterDuplicateNames
// Description:  Trigger on Service_Master__c  to Prevent Duplicate ServiceMaster names 
//
//             
//               
// Created By :  Malkeet Singh
// Date       : 08/03/2013
// **************************************************************************************************************

trigger PreventServiceMasterDuplicateNames on Service_Master__c  (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
     //Below Flag is used to stop recursive method call
        
    if(Recursive.ServiceMasterNameFlag!= true) 
    PreventDuplicateServiceMasterName.serviceMasterNameCheckInsert();
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
      //Below Flag is used to stop recursive method call
        
     if(Recursive.ServiceMasterNameFlag!=true  || Test.isRunningTest()) 
     PreventDuplicateServiceMasterName.serviceMasterNameCheckUpdate();
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}