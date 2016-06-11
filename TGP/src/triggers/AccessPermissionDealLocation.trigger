trigger AccessPermissionDealLocation on Deal_Location__c (after update) 
{
    List<Deal_Location__c> lstNewDealloc = Trigger.new;
    List<Deal_Location__c> lstOldDealloc = Trigger.old;
    
    UserAccessUtility uam = new UserAccessUtility();
    boolean isActive = false;
    //event check when records are updated
    if (Trigger.isupdate)
    {
        if(test.isRunningTest()==false)
        {
        for(integer i=0;i<lstOldDealloc.size();i++ )
        {
            if(lstOldDealloc.get(i).active__c == lstNewDealloc.get(i).active__c )
            {
                isActive=true;
                break;                
            }
        }
        if(isActive){
            uam.CheckAccessDealLocationDelete(lstOldDealloc); 
            uam.CheckAccessDealLocation(lstNewDealloc);
        }        
        }
    }
}