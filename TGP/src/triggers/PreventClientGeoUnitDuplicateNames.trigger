//***************************************************************************************************************
// Name       :  PreventclientGeoUnitDuplicateNames
// Description:  Trigger on Client_Geo_Unit_Master__c to Prevent Duplicate clientGeoUnit names 
//
//             
//               
// Created By :  Malkeet Singh
// Date       : 08/03/2013
// **************************************************************************************************************

trigger PreventClientGeoUnitDuplicateNames on Client_Geo_Unit_Master__c (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
     //Below Flag is used to stop recursive method call
        
    if(Recursive.clientGeoUnitNameFlag!= true) 
    PreventDuplicateClientGeoUnitName.clientGeoUnitNameCheckInsert();
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
      //Below Flag is used to stop recursive method call
        
     if(Recursive.clientGeoUnitNameFlag!=true) 
     PreventDuplicateClientGeoUnitName.clientGeoUnitNameCheckUpdate();
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}