/*
Author : Vinay Kumar Chada
Story  : Story-0161/MOB_133  
Description : This Trigger belonges to SRAT Vestion related records Active Mode.
Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
trigger saveSRATVersion on SRAT_VERSION__c (before insert, before update,after insert,after update)

{
    //if(Test.isRunningTest()==false)
    //{
         List<SRAT_VERSION__c> lstVer = new List<SRAT_VERSION__c>();
        if(Recursive.isSRATVersionMarkedActive == false)
        {
            if(Trigger.isBefore)
            {
                for(SRAT_VERSION__c s: Trigger.new)
                {
                    if (s.isActive__c == true)
                    {
                    
                        s.isActive__c=true; 
                        s.Active_Modified_Date__c =date.today();
                        //upsert s;
                        List<SRAT_VERSION__c> lstSRATActive = [select isActive__c, id,SRAT_Name__c,Active_Modified_Date__c from SRAT_VERSION__c where isActive__c=true];
                        for(SRAT_VERSION__c sv : lstSRATActive)
                        {   
                          sv.isActive__c=false; 
                         // sv.Active_Modified_Date__c =date.today();                  
                          lstVer.add(sv);
                        }
                        
                        
                    }
                }
                update lstVer;
                //Recursive.isSRATVersionMarkedActive = true;
            }
            if(Trigger.isAfter)
            {
                // get list of SRAT_User_Section_Question__c where wave plan version tracking is on
                List<SRAT_User_Section_Question__c> lstUsersubQns = [select id,SRAT_Version__c,SRAT__c from SRAT_User_Section_Question__c where SRAT__r.wave_plan_version__r.Display_tracking_message__c='Tracking is On' and SRAT__r.Has_KT_Lead_Submitted__c = false];
                
                List<SRAT_User_Sub_Section_Question__c> lstSubUsersubQns = [select id,SRAT_Version__c,SRAT__c from SRAT_User_Sub_Section_Question__c where SRAT__r.wave_plan_version__r.Display_tracking_message__c='Tracking is On'  and SRAT__r.Has_KT_Lead_Submitted__c = false ];
                
                List<Factory_Specific_Technology__c> lstFactorySpc = [select id,SRAT_Version__c,SRAT__c from Factory_Specific_Technology__c where SRAT__r.wave_plan_version__r.Display_tracking_message__c='Tracking is On'  and SRAT__r.Has_KT_Lead_Submitted__c = false ];
                
                
                Set<Id> lstIds = new Set<Id>();
                for(SRAT_User_Sub_Section_Question__c tmpqn : lstSubUsersubQns)
                {
                    lstIds.add(tmpqn.SRAT__c);
                }
                delete lstUsersubQns;
                delete lstSubUsersubQns;
                delete lstFactorySpc;
                
                List<SRAT__C> lstSRAT = [select SRAT_Version__c from SRAT__c where id in: lstIds];
                for(SRAT_VERSION__c s: Trigger.new)
                {
                    if (s.isActive__c == true)
                    {
                        for(SRAT__C tmpSRAT: lstSRAT)
                        {
                            tmpSRAT.SRAT_Version__c = s.id;
                        }
                    }   
                }
                update lstSRAT;
                //Recursive.isSRATVersionMarkedActive = true;
            }
        }
    //}     
}