//This Trigger belonges to OPEX Vestion related records Active Mode.
    
    trigger saveOPEXVersion on OPEX_Version__c (before insert, before update, after insert, after update)
    {    
           
        if(Trigger.isBefore)
        {
               List<OPEX_Version__c> lstCurrerntSRATs = Trigger.new;
               OPEX_Version__c CurrerntSRAT = lstCurrerntSRATs.get(0);
               if(Recursive.opexFlag!=true)
               {
                
                for (OPEX_Version__c opex : System.Trigger.new)
                    {
                        
                        List<OPEX_Version__c> lstOPEXActive = [select isActive__c, id from OPEX_Version__c where isActive__c=true and id <>: CurrerntSRAT.id];
                        if(opex.isActive__c==true)
                            {  
                                Recursive.opexFlag=true;
                                for(OPEX_Version__c op : lstOPEXActive)
                                    { 
                                        op.isActive__c=false;
                                        update op;                    
                                    }               
                           }
                    }
                }
        }
    
     if(Trigger.Isupdate && Trigger.isAfter )
        {
              List<OPEX_User_Section_Question__c> lstUsersubQns = [select id, OPEX_Version__c, OPEX__c from OPEX_User_Section_Question__c where OPEX__r.wave_plan_version__r.Display_tracking_message__c='Tracking is On' and OPEX__r.Is_Submitted__c = false];
                Set<Id> lstIds = new Set<Id>();
                if(lstUsersubQns.size()>0)
                    {
                         for(OPEX_User_Section_Question__c tmpqn : lstUsersubQns)
                            {
                                lstIds.add(tmpqn.OPEX__c);
                            }
                        delete lstUsersubQns;  
                        List<OPEX__c> lstOpex = [select OPEX_Version__c from OPEX__c where id in: lstIds];
                        for(OPEX_Version__c s: Trigger.new)
                            {
                                if (s.isActive__c == true)
                                {
                                    for(OPEX__c tmpOPex: lstOpex)
                                    {
                                        tmpOPex.OPEX_Version__c = s.id;
                                        update tmpOPex;
                                    }
                                }   
                            }
                     }
                
        }
    }