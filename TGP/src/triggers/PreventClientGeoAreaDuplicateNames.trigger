//***************************************************************************************************************
// Name       :  PreventClientGeoAreaDuplicateNames
// Description:  Trigger on Client_Geo_Area_Master__c to Prevent Duplicate clientGeoArea names 
//
//             
//               
// Created By :  Malkeet Singh
// Date       : 08/03/2013
// **************************************************************************************************************

trigger PreventClientGeoAreaDuplicateNames on Client_Geo_Area_Master__c (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
     //Below Flag is used to stop recursive method call
        
    if(Recursive.clientGeoAreaNameFlag!= true) 
    PreventDuplicateClientGeoAreaName.clientGeoAreaNameCheckInsert();
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
      //Below Flag is used to stop recursive method call
        
     if(Recursive.clientGeoAreaNameFlag!=true || test.isRunningTest()) 
     PreventDuplicateClientGeoAreaName.clientGeoAreaNameCheckUpdate();
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}