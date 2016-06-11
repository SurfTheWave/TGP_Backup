//***************************************************************************************************************
// Name       :  PreventTechAssessmentActivitiesMasterDuplicateName
// Description:  Trigger on Deal_TGP__c to Prevent Duplicate deal names 
//
//             
//               
// Created By :  Malkeet Singh
// Date       : 08/03/2013
// **************************************************************************************************************

trigger PreventTechAssessmentActivitiesMasterDuplicateName on Tech_Assessment_Activity_Master__c (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
      if(Recursive.TechAssessmentActivitiesMasterFlag!= true)
      {
       PreventTechAsmentActiMasterDuplicateName.TechAssessmentActivityNameCheckInsert();
      }
    
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
       
    if(Recursive.TechAssessmentActivitiesMasterFlag!= true)
    {
      PreventTechAsmentActiMasterDuplicateName.TechAssessmentActivityNameCheckUpdate();
    }
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}