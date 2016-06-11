//***************************************************************************************************************
// Name       :  PreventFacilityMasterDuplicateNames
// Description:  Trigger on Facility_Master__c  to Prevent Duplicate FacilityMaster names 
//
//             
//               
// Created By :  Malkeet Singh
// Date       : 08/03/2013
// **************************************************************************************************************

trigger PreventFacilityMasterDuplicateNames on Facility_Master__c  (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
     //Below Flag is used to stop recursive method call
        
    if(Recursive.FacilityMasterNameFlag!= true) 
    PreventDuplicateFacilityMasterName.FacilityMasterNameCheckInsert();
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
      //Below Flag is used to stop recursive method call
        
     if(Recursive.FacilityMasterNameFlag!=true) 
     PreventDuplicateFacilityMasterName.FacilityMasterNameCheckUpdate();
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}