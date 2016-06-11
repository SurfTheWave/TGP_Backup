//***************************************************************************************************************
// Name       :  PreventOperatingMasterDuplicateNames
// Description:  Trigger on Operating_Group_Master__c  to Prevent Duplicate OperatingGrouopMaster names 
//
//             
//               
// Created By :  Malkeet Singh
// Date       : 08/03/2013
// **************************************************************************************************************

trigger PreventOperatingGroupMasterDuplicateNames on Operating_Group_Master__c  (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
     //Below Flag is used to stop recursive method call
        
    if(Recursive.OperatingGroupMasterNameFlag!= true) 
    PreventDuplicateOperatingGroupMasterName.operatingGroupMasterNameCheckInsert();
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
      //Below Flag is used to stop recursive method call
        
     if(Recursive.OperatingGroupMasterNameFlag!=true  || Test.isRunningTest()) 
     PreventDuplicateOperatingGroupMasterName.operatingGroupMasterNameCheckUpdate();
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}