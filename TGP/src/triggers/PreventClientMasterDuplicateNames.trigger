//***************************************************************************************************************
// Name       :  PreventClientMasterDuplicateNames
// Description:  Trigger on Client_Master__c  to Prevent Duplicate ClientMaster names 
//
//             
//               
// Created By :  Malkeet Singh
// Date       : 08/03/2013
// **************************************************************************************************************

trigger PreventClientMasterDuplicateNames on Client_Master__c  (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
     //Below Flag is used to stop recursive method call
        
    if(Recursive.ClientMasterNameFlag!= true) 
    PreventDuplicateClientMasterName.clientMasterNameCheckInsert();
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
      //Below Flag is used to stop recursive method call
        
     if(Recursive.ClientMasterNameFlag!=true) 
     PreventDuplicateClientMasterName.clientMasterNameCheckUpdate();
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}