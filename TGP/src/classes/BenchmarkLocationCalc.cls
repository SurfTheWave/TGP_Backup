public class BenchmarkLocationCalc{

    /*
    public void calcLocationOnBenchMark(Map<Id, Opportunity> triggernewMap){
        try{
            List<Benchmark__c> bnchMarkList = new List<Benchmark__c>();
            
            for(Benchmark__c bnch : [SELECT Id, Name, Opportunity__c, BenchMark_Delivery_Location__c, Opportunity__r.Off__c FROM Benchmark__c WHERE Opportunity__c IN : triggernewMap.keySet()]){
                
                if(String.isBlank(triggernewMap.get(bnch.Opportunity__c).Off__c)){
                    bnch.BenchMark_Delivery_Location__c = UtilCOnstants.EMPTY_STRING;
                    bnchMarkList.add(bnch);
                }
                //else if(triggernewMap.get(bnch.Opportunity__c).Off__c != bnch.Opportunity__r.Off__c)
                else{
                    bnch.BenchMark_Delivery_Location__c = triggernewMap.get(bnch.Opportunity__c).Off__c;
                    bnchMarkList.add(bnch);
                }
            }
            
            if(bnchMarkList.size() > 0){
            
                Boolean flagCheck=UtilConstants.IS_OPPTRIGGER_REQUIRED;
                if(flagCheck){
                    UtilConstants.IS_OPPTRIGGER_REQUIRED=false;
                }
                Database.update(bnchMarkList, false);
                if(flagCheck){
                  UtilConstants.IS_OPPTRIGGER_REQUIRED=true;
                }
                
                
            }
            
        }
        catch(Exception e){
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
        }
    }
    */
    public void calcLocationOnBenchMarkFromMap(Map<Id,String> oppoffMap){
        try{
            List<Benchmark__c> bnchMarkList = new List<Benchmark__c>();
            
            for(Benchmark__c bnch : [SELECT Id, Name, Opportunity__c, BenchMark_Delivery_Location__c, Opportunity__r.Delivery_Locations__c FROM Benchmark__c WHERE Opportunity__c IN : oppoffMap.keySet()]){
                
                if(String.isBlank(oppoffMap.get(bnch.Opportunity__c))){
                    bnch.BenchMark_Delivery_Location__c = UtilCOnstants.EMPTY_STRING;
                    bnchMarkList.add(bnch);
                }
                //else if(triggernewMap.get(bnch.Opportunity__c).Off__c != bnch.Opportunity__r.Off__c)
                else{
                    bnch.BenchMark_Delivery_Location__c = bnch.Opportunity__r.Delivery_Locations__c;
                    bnchMarkList.add(bnch);
                }
            }
            
            if(bnchMarkList.size() > 0){
            
                Boolean flagCheck=UtilConstants.IS_OPPTRIGGER_REQUIRED;
                if(flagCheck){
                    UtilConstants.IS_OPPTRIGGER_REQUIRED=false;
                }
                Database.update(bnchMarkList, false);
                if(flagCheck){
                  UtilConstants.IS_OPPTRIGGER_REQUIRED=true;
                }
                
                
            }
            
        }
        catch(Exception e){
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
        }
    }
    


}