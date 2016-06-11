/**
    @Author : Shivraj.gangabyraiah
    @name:  WaveProcess
    @CreateDate :  2/21/2015
    @Description:  This class contains methods to create general activity items and to update procurement check on wave object
    @Version: 1.0
    @reference: None
*/
public without sharing class WaveProcess {
  
    /**
    @Author : Shivraj.gangabyraiah
    @name:  WaveProcess
    @CreateDate :  2/21/2015
    @Description:  This methods is used to create general activty items from wave
  */
    public static void updateWave(List<Wave_Proc__c> waveProcessList){
        
        set<Id> waveProcessId =  new Set<Id>();
        set<Id> waveId = new Set<Id>();
       
      
        List<Wave__c> waveProcurement = new List<Wave__c>();
        set<String> procSet=new set<String>();
        procSet.add(UtilConstants.Sourcing_only);
        procSet.add(UtilConstants.S2C);
        procSet.add(UtilConstants.S2O);
        procSet.add(UtilConstants.S2P);
        procSet.add(UtilConstants.TSM);
        List<Procurement_General_Activity_Item__c> prItemList = new List<Procurement_General_Activity_Item__c>();
        try{
            for(Wave_Proc__c wp:waveProcessList){
                waveProcessId.add(wp.id);
            }
            
            for(Wave_Proc__c waveprocess:[select id,Wave__c,name,Wave_Client_Specific_Process__r.Process_Offering__r.name,Wave_Client_Specific_Process__r.Process_Offering__c,Wave_Client_Specific_Process__r.Process_Services__r.name,Wave_Client_Specific_Process__r.Process_Services__c FROM Wave_Proc__c WHERE ID IN :waveProcessId LIMIT 5000]){
                if((waveprocess.Wave_Client_Specific_Process__r.Process_Offering__r.name).equalsIgnoreCase(UtilConstants.PROCUREMENT) && procSet.contains(waveprocess.Wave_Client_Specific_Process__r.Process_Services__r.name)){
                    //system.debug('Alpha eneterd here as expected' +waveprocess.name);
                    waveId.add(waveprocess.Wave__c);
                }
            }
            Procurement_General_Activity_Item__c item;
            
            List<Procurement_General_Activity_Master__c> procmaster=[select id,name,Active__c,Activity_Description__c,Activity_Order__c,Type__c FROM Procurement_General_Activity_Master__c WHERE Active__c=true LIMIT 2000];
            for(Wave__c wave:[select id,Is_Procurement_Tracking_Applicable__c FROM Wave__c WHERE ID IN:waveId limit 5000]){
                wave.Is_Procurement_Tracking_Applicable__c = true;
                waveProcurement.add(wave);
                
                for(Procurement_General_Activity_Master__c pr:procmaster){
                    item = new Procurement_General_Activity_Item__c();
                    item.name=pr.name;
                    item.Active__c=pr.Active__c;
                    item.Activity_Description__c=pr.Activity_Description__c;
                    item.Activity_Order__c=pr.Activity_Order__c;
                    item.Type__c=pr.Type__c;
                    item.Value__c=String.valueOf(0);
                    item.Wave__c=wave.id;
                    item.Procurement_General_Activity_Master__c=pr.id;
                    
                    prItemList.add(item);
                }
            }
            
            Database.upsert(waveProcurement);
            Database.upsert(prItemList);
            //system.debug('Is Entering here when created and after');
        }catch(Exception e){
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.WAVEPROCESS, UtilConstants.WAVEPROCESS, null, System.Logginglevel.ERROR);
        }
    }
}