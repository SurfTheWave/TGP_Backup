trigger updateGEOregion on Pipeline_Trend_Report__c (before insert , before update) {

    List<Pipeline_Trend_Report__c> pipeLineNewRec = Trigger.new;
    
    List<Client_Geo_Area_Master__c> lstClientGeoAreaMaster = [select id,name from Client_Geo_Area_Master__c where Active__c=true order by name];
    Map<String,Id> mapClientGeoAreaMaster = new Map<String,Id>();
    if(lstClientGeoAreaMaster.size() > 0)
    {
        for(Client_Geo_Area_Master__c cgaMasterObj:lstClientGeoAreaMaster)
        {
            mapClientGeoAreaMaster.put(cgaMasterObj.name,cgaMasterObj.id);
        }
    }
    
    if(trigger.isInsert){
    
        for(Pipeline_Trend_Report__c trendRec : pipeLineNewRec){
        
            if(!mapClientGeoAreaMaster.isEmpty() && trendRec.Geo_Region__c != null)
               {
                    if(mapClientGeoAreaMaster.get(trendRec.Geo_Region__c) != null)
                        {
                            
                            trendRec.Geo_Region_lookup__c = mapClientGeoAreaMaster.get(trendRec.Geo_Region__c);
                            
                        }                           
               }
        }

    }
        if(trigger.isUpdate ){
    
        for(Pipeline_Trend_Report__c trendRec : pipeLineNewRec){
        
            if(!mapClientGeoAreaMaster.isEmpty() && trendRec.Geo_Region__c != null)
               {
                    if(mapClientGeoAreaMaster.get(trendRec.Geo_Region__c) != null)
                        {
                            
                            trendRec.Geo_Region_lookup__c = mapClientGeoAreaMaster.get(trendRec.Geo_Region__c);
                            
                        }                           
               }
        }

        
    }

}