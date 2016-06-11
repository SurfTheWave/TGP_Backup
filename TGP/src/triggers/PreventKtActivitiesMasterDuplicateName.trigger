//***************************************************************************************************************
// Name       :  PreventTechAssessmentActivitiesMasterDuplicateName
// Description:  Trigger on Deal_TGP__c to Prevent Duplicate deal names 
//
//             
//               
// Created By :  Malkeet Singh
// Date       : 08/03/2013
// **************************************************************************************************************

trigger PreventKtActivitiesMasterDuplicateName on KT_Planning_Activity_Master__c (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
      if(Recursive.KTactivityMasterFlag!= true)
      {
       PreventKTActiMasterDuplicateName.KtActivityNameCheckInsert();
      }
    
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
       
    if(Recursive.KTactivityMasterFlag!= true)
    {
      PreventKTActiMasterDuplicateName.KtActivityNameCheckUpdate();
    }
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}