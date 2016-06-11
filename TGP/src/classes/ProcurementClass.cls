/**
    @Author : Shivraj.gangabyraiah
    @name:  ProcurementClass
    @CreateDate :  2/21/2015
    @Description: This class contains all methods to insert quarter wise activty item records, it is called from wave trigger
    @Version: 1.0
    @reference: None
*/
public without sharing class ProcurementClass {
    
    /**
    @Author : Shivraj.gangabyraiah
    @name:  createSpendSavingsPlan
    @CreateDate :  2/21/2015
    @Description: This method creates procurement quarter records for each wave update 
    @Version: 1.0
    @reference: None
	*/
    public static void createSpendSavingsPlan(List<Wave__c> waveList){
        List<Procurement_Quarter_Wise_Activity_Item__c> quarterList = new List<Procurement_Quarter_Wise_Activity_Item__c>();
        List<Procurement_Quarter_Wise_Activity_Item__c> procTodelete = new List<Procurement_Quarter_Wise_Activity_Item__c>();
        set<Id> waveId = new Set<Id>();
        
        for(Wave__C wave:waveList){
            waveId.add(wave.id);
        }
        //System.debug('Bandya');
        try{
            
            procTodelete=[select id from Procurement_Quarter_Wise_Activity_Item__c where Wave__c IN:waveId LIMIT 5000];
            Procurement_Quarter_Wise_Activity_Item__c itemQ1=null;
            Procurement_Quarter_Wise_Activity_Item__c itemQ2=null ;
            Procurement_Quarter_Wise_Activity_Item__c itemQ3=null;
            Procurement_Quarter_Wise_Activity_Item__c itemQ4=null;
            Database.delete(procTodelete);
            
            List<Procurement_Quarter_Wise_Activity_Master__c> quarterMasterList=[select id,name,Active__c,Activity_Description__c,Activity_Order__c,Type__c FROM Procurement_Quarter_Wise_Activity_Master__c LIMIT 2000];
            for(Wave__C wave:waveList){
                
              if(wave.Procurement_Q1_Start_Date__c!=NULL){
                for(Procurement_Quarter_Wise_Activity_Master__c quarterMaster:quarterMasterList){
                    itemQ1 = new Procurement_Quarter_Wise_Activity_Item__c();
                    itemQ1.name=quarterMaster.name;
                    itemQ1.Active__c = quarterMaster.Active__c;
                    itemQ1.Activity_Description__c=quarterMaster.Activity_Description__c;
                    itemQ1.Activity_Order__c=quarterMaster.Activity_Order__c;
                    itemQ1.Quarter_dd__c=UtilConstants.Q1;
                    itemQ1.Type__c=quarterMaster.Type__c;
                    itemQ1.Value__c=0;
                    itemQ1.Wave__c=wave.id;
                    itemQ1.Procurement_Quarter_Wise_Activity_Master__c=quarterMaster.id;
                    
                    //System.debug('Check process');
                
                    quarterList.add(itemQ1);
                    
                    itemQ2 = new Procurement_Quarter_Wise_Activity_Item__c();
                    itemQ2.name=quarterMaster.name;
                    itemQ2.Active__c = quarterMaster.Active__c;
                    itemQ2.Activity_Description__c=quarterMaster.Activity_Description__c;
                    itemQ2.Activity_Order__c=quarterMaster.Activity_Order__c;
                    itemQ2.Quarter_dd__c=UtilConstants.Q2;
                    itemQ2.Type__c=quarterMaster.Type__c;
                    itemQ2.Value__c=0;
                    itemQ2.Wave__c=wave.id;
                    itemQ2.Procurement_Quarter_Wise_Activity_Master__c=quarterMaster.id;
                    
                    
                    quarterList.add(itemQ2);
                    
                    itemQ3 = new Procurement_Quarter_Wise_Activity_Item__c();
                    itemQ3.name=quarterMaster.name;
                    itemQ3.Active__c = quarterMaster.Active__c;
                    itemQ3.Activity_Description__c=quarterMaster.Activity_Description__c;
                    itemQ3.Activity_Order__c=quarterMaster.Activity_Order__c;
                    itemQ3.Quarter_dd__c=UtilConstants.Q3;
                    itemQ3.Type__c=quarterMaster.Type__c;
                    itemQ3.Value__c=0;
                    itemQ3.Wave__c=wave.id;
                    itemQ3.Procurement_Quarter_Wise_Activity_Master__c=quarterMaster.id;
                    
                    quarterList.add(itemQ3);
                    
                    itemQ4 = new Procurement_Quarter_Wise_Activity_Item__c();
                    itemQ4.name=quarterMaster.name;
                    itemQ4.Active__c = quarterMaster.Active__c;
                    itemQ4.Activity_Description__c=quarterMaster.Activity_Description__c;
                    itemQ4.Activity_Order__c=quarterMaster.Activity_Order__c;
                    itemQ4.Quarter_dd__c=UtilConstants.Q4;
                    itemQ4.Type__c=quarterMaster.Type__c;
                    itemQ4.Value__c=0;
                    itemQ4.Wave__c=wave.id;
                    itemQ4.Procurement_Quarter_Wise_Activity_Master__c=quarterMaster.id;
                    
                    quarterList.add(itemQ4);
                }
              }  
                
            }
        
            Database.insert(quarterList);
            //System.debug('Inserted recorss');
        }catch(Exception e){
         UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.PROCUREMENT, UtilConstants.PROCUREMENT, null, System.Logginglevel.ERROR);
        }
   }
    
   /**
    @Author : Shivraj.gangabyraiah
    @name:  updateRollUpSummary
    @CreateDate :  2/21/2015
    @Description: This method is used to update the roll up summary when a quarter record is edited to have target value 
    @Version: 1.0
    @reference: None
	*/
   public static void updateRollUpSummary(List<Procurement_Quarter_Wise_Activity_Item__c> procQuarterList){
        set<Id> waveId=new set<Id>();
        for(Procurement_Quarter_Wise_Activity_Item__c proc:procQuarterList){
            waveId.add(proc.Wave__c);
        }
        
        Boolean check=false;
        Decimal actualValue=0;
        List<Procurement_Quarter_Wise_Activity_Item__c> quarterToUpdate= new List<Procurement_Quarter_Wise_Activity_Item__c>();
        
        try{
            for(Wave__c wave:[select id,name,Total_Savings_To_date_Target__c,(select id,Actual_Value_dev__c,name,Value__c,Quarter_dd__c FROM Procurement_Quarter_Wise_Activity_Items__r ORDER BY Quarter_dd__c,name limit 5000 ) FROM Wave__c where ID IN:waveId LIMIT 5000]){
                for(Procurement_Quarter_Wise_Activity_Item__c procQuarter:wave.Procurement_Quarter_Wise_Activity_Items__r){
                    if((procQuarter.name).equals(UtilConstants.TOTAL_SAVE_TODATE)){
                         actualValue=procQuarter.Value__c;
                         check=true;           
                    }
                    if((procQuarter.name).equals(UtilConstants.TOTAL_SAVE_TARGET) && (check)){
                        procQuarter.Actual_Value_dev__c=actualValue;
                        check=false;
                        quarterToUpdate.add(procQuarter);
                    }
                    
                
                }
                
                
            }
        if(!quarterToUpdate.isEmpty()){
            Database.upsert(quarterToUpdate);
        }
        

        }catch(Exception e){
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.PROCUREMENT, UtilConstants.PROCUREMENT, null, System.Logginglevel.ERROR);
        }
    }
}