trigger UpdateFTEsOnDealWave on Wave_Process__c (after insert,after update,after delete) 
{
    List<Wave_Process__c> lstProcess;
    //if(Test.isRunningTest()==false)
    //{
        if(Trigger.isdelete==false)    
            lstProcess = Trigger.new;
        else if(Trigger.isdelete==true)
            lstProcess = Trigger.old;
           
        set<Id> setDealWaveId = new set<Id>();
        for(Wave_Process__c tmpProcess : lstProcess)
        {
            setDealWaveId.add(tmpProcess.Wave_Planning__c);
        }
        List<Wave_Planning__c> lstDealWave = [select id,Number_of_FTEs__c from Wave_Planning__c where id in: setDealWaveId];
        List<Wave_Process__c> lstProcess2 = [select Wave_Planning__C,Number_of_Projected_FTEs__c,Active__c from Wave_Process__c where Wave_Planning__C in:setDealWaveId and Active__c=true];
        if(lstDealWave.size()>0)
        {      
            for(Wave_Planning__c tmpWavePlan : lstDealWave)
            {
                Decimal count = 0;
                if(lstProcess2.size()>0)
                {
                    for(Wave_Process__c tmpProcess : lstProcess2 )
                    {
                        if(tmpWavePlan.id==tmpProcess.Wave_Planning__c && tmpProcess.Number_of_Projected_FTEs__c !=null)
                        {
                            count = count + tmpProcess.Number_of_Projected_FTEs__c;
                        }
                    }
                }else{
                    count=0;
                }
                tmpWavePlan.Number_of_FTEs__c=count;
            }
        }
        Recursive.isDealWaveUpdateFromWaveProcess = true;
        if(lstDealWave.size()>0)
        {
            update lstDealWave;
        }
        Recursive.isDealWaveUpdateFromWaveProcess = false;

    //}    
}