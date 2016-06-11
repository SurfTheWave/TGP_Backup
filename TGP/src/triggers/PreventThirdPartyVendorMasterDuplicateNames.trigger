//***************************************************************************************************************
// Name       :  PreventKeyBuyerValueCategoryMasterDuplicateNames
// Description:  Trigger on Key_Buyer_Value_Category_Master__c  to Prevent Duplicate KeyBuyerValueCategoryMaster names 
//
//             
//               
// Created By :  Malkeet Singh
// Date       : 08/03/2013
// **************************************************************************************************************

trigger PreventThirdPartyVendorMasterDuplicateNames on Third_Party_Vendor_Master_Custom__c  (before insert,before update){
           
    try{ 
    // Before Insert call
    if(Trigger.isbefore && Trigger.isInsert)
     {
     
     
     //Below Flag is used to stop recursive method call
        
    if(Recursive.ThirdPartyVendorNameFlag!= true) 
    PreventDuplThirdPartyVendorMasterName.ThirdPartyVendorMasterNameCheckInsert();
    }
    // Before Update call
      if(Trigger.isBefore && Trigger.isUpdate)
     {
      //Below Flag is used to stop recursive method call
        
      if(Recursive.ThirdPartyVendorNameFlag!=true) 
     PreventDuplThirdPartyVendorMasterName.ThirdPartyVendorMasterNameCheckUpdate();
     }
     
    }
    //Exception handling
    catch(Exception e)
    {
      Trigger.New[0].addError(e.getMessage());
    }
    
}