//***************************************************************************************************************
// Name       :  PreventServiceComponentDuplicateNames
// Description:  Trigger on Service_Component__c  to Prevent Duplicate ServiceComponent names 
//
//             
//               
// Created By :  Malkeet Singh
// Date       : 08/03/2013
// **************************************************************************************************************

trigger PreventServiceComponentDuplicateNames on Service_Component__c  (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
     //Below Flag is used to stop recursive method call
        
    if(Recursive.ServiceComponentNameFlag!= true) 
    PreventDuplicateServiceComponentName.serviceComponentNameCheckInsert();
    Recursive.ServiceComponentNameFlag= false;
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
      //Below Flag is used to stop recursive method call
        
     if(Recursive.ServiceComponentNameFlag!=true) 
     PreventDuplicateServiceComponentName.serviceComponentNameCheckUpdate();
        Recursive.ServiceComponentNameFlag= false;
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}