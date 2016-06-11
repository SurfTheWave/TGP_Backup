public with sharing class EditHLMPTableController{
    public String newid{get;set;}
    public Boolean flagSave{get;set;}
    public Boolean flagEdit{get;set;}
    //public Boolean isWaveVersionActive{get; set;}
    public List<Wave_Planning__c> wavePlanninglist{get;set;}
    public List<Wave_Process__c> waveProcesslist{get;set;}
    public List<Wave_Planning__c> oldWavePlanninglist{get;set;}
    public List<Wave_Process__c> oldWaveProcesslist{get;set;}
    public Date goLiveDate{get;set;}
    public Decimal fte{get;set;}
    List<Deal_Location__c> locNodelist{get;set;}
          
    public EditHLMPTableController(ApexPages.StandardController controller) {
        newid=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID); 
        
        locNodelist=[Select Wave_Plan_Version__r.Id,  Name,Deal_Home_Location__r.Delivery_Location_Master__r.Name,Wave_Plan_Version__c,NewActive__c from Deal_Location__c where Wave_Plan_Version__c =:newid];

        wavePlanninglist=[Select Deal_Location__r.Id, Deal_Location__r.name,Name,Wave_Label__c,GO_Live_Date_del__c,Revised_Go_Live__c, Deal_Location__c,NewActive__c from Wave_Planning__c where Deal_Location__c =:locNodelist order by Deal_Location__r.name, Wave_Label__c, Name];
        
        waveProcesslist=[Select Wave_Planning__r.Id, Wave_Planning__r.Deal_Location__r.name, Wave_Planning__r.Wave_Label__c,Name,Go_Live_Date__c, Client_Specific_Process_Mapping__r.Name, Wave_Planning__c,Active__c,Number_of_Projected_FTEs__c from Wave_Process__c where  Wave_Planning__c =:wavePlanninglist order by Wave_Planning__r.Deal_Location__r.name, Wave_Planning__r.Wave_Label__c,Client_Specific_Process_Mapping__r.Name];       

        flagSave = false;             
        flagEdit = true;
    }   
             
      public pagereference save(){
        oldWavePlanninglist=[Select Deal_Location__r.Id, Deal_Location__r.name,Name,Wave_Label__c,GO_Live_Date_del__c,Revised_Go_Live__c, Deal_Location__c,NewActive__c from Wave_Planning__c where Deal_Location__c =:locNodelist order by Deal_Location__r.name, Wave_Label__c, Name];
        
        oldWaveProcesslist=[Select Wave_Planning__r.Id, Wave_Planning__r.Deal_Location__r.name, Wave_Planning__r.Wave_Label__c,Name,Go_Live_Date__c, Client_Specific_Process_Mapping__r.Name, Wave_Planning__c,Active__c,Number_of_Projected_FTEs__c from Wave_Process__c where  Wave_Planning__c =:wavePlanninglist order by Wave_Planning__r.Deal_Location__r.name, Wave_Planning__r.Wave_Label__c,Client_Specific_Process_Mapping__r.Name];       
        List<Wave_Planning__c> updateWaveplaningList = new List<Wave_Planning__c>();
        for(Wave_Planning__c oldWave : oldWavePlanninglist){
            for(Wave_Planning__c newWave : wavePlanninglist){
                if((oldWave.id == newWave.id) && (oldWave.GO_Live_Date_del__c != newWave.GO_Live_Date_del__c)){
                oldWave.GO_Live_Date_del__c=newWave.GO_Live_Date_del__c;
                updateWaveplaningList.add(oldWave);                 
                }
            }
        }
       
       
       List<Wave_Process__c> updateWaveProcessList = new List<Wave_Process__c>();
        for(Wave_Process__c oldWaveProc : oldWaveProcesslist){
            for(Wave_Process__c newWaveProc : waveProcesslist){
                if((oldWaveProc.id == newWaveProc.id) && (oldWaveProc.Number_of_Projected_FTEs__c != newWaveProc.Number_of_Projected_FTEs__c)){
                oldWaveProc.Number_of_Projected_FTEs__c=newWaveProc.Number_of_Projected_FTEs__c;
                updateWaveProcessList.add(oldWaveProc);                 
                }
            }
        }
        System.debug('wavePlanning--Biswajit'+updateWaveplaningList.size());
        System.debug('waveProcess--Biswajit'+updateWaveProcessList.size());
        database.update(updateWaveplaningList);
        database.update(updateWaveProcessList);
        
        flagSave = false;
        flagEdit = true;      
        PageReference pageref=new PageReference('/apex/DealSummary_Inline?id='+newid);
        pageref.setRedirect(true);
        return pageref;
        }  
        
        public void edit(){
        flagSave = true;             
        flagEdit = false;
        }
        
        public void cancel(){
            flagEdit = true; 
            flagSave = false;
        }  
}