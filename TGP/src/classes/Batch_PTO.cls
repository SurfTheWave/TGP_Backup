global class Batch_PTO implements Database.Batchable<SObject> {
    
    private string query {get; set;} 
    private List<Holiday_Master__c> holidays;
    private List<Holiday_Master__c> holidayList;
    private Map<String,List<Holiday_Master__c>> holidayMap;
    private Set<String> countries;
    private List<Country_Master__c> countryList;
    
    
    private PTO__c pto;
    private List<PTO__c> ptoList;
  
    
    global Batch_PTO() {             
        ptoList = new List<PTO__c>();
        holidayMap = new Map<String,List<Holiday_Master__c>>();
        countries = new Set<String>();
       
        query = 'SELECT Id,Active__c,Opportunity__c,User__c,User__r.Resource_Country__c,Name FROM Utilizations__c';     
        countryList = [SELECT Id,Name FROM Country_Master__c];
        holidays = [SELECT Id,Name,Start_Date__c,End_Date__c,Country__c,Country__r.Name From Holiday_Master__c];
        
        if(countryList.size() >0 && holidays.size() > 0){  
            for(Country_Master__c cm : countryList){
                holidayList = new List<Holiday_Master__c>();          
                for(Holiday_Master__c hm : holidays){
                   if(cm.Name == hm.Country__r.Name)
                    holidayList.add(hm);     
                }
                if(holidayList.size()>0){
                    holidayMap.put(cm.Name,holidayList);
                    countries.add(cm.Name); 
                }                   
            }
        } 
    }
    
    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext context, List<Utilizations__c> scope) {
        if(scope.size()>0){
          for(Utilizations__c utl :scope){
                if(countries.contains(utl.User__r.Resource_Country__c))
                         holidayList = holidayMap.get(utl.User__r.Resource_Country__c);
                if(holidayList.size() > 0 && !(utl.Name == UtilConstants.OPP_NAME_LIST_1 || utl.Name == UtilConstants.OPP_NAME_LIST_2)){  
                  for(Holiday_Master__c hm : holidayList){ 
                     pto = new PTO__c();                 
                     pto.Utilization__c = utl.Id;
                     pto.PTO_Start__c = hm.Start_Date__c; 
                     pto.PTO_End__c = hm.End_Date__c;
                     pto.Name = hm.Name;
                     pto.isHoliday__c = true;
                     ptoList.add(pto);
                  }                
               } 
            } 
        }       
      if(ptoList.size()>0) 
        insert ptoList;   
    }
    
    global void finish(Database.BatchableContext context){ }
}