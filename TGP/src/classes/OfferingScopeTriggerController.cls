/*
* This class will be used as business logic controller for trigger OfferingScopeAfterInsertServices on Service_Master__c 
*
*  @ Author Accenture Team
*  @ Date 1/12/2014 
*/
public class OfferingScopeTriggerController {
     // Class Constants
    private static final String CLASS_NAME = 'OfferingScopeTriggerController';
    private static final String TRIGGER_NAME = 'OfferingScopeAfterInsertServices';
    private static final String METHOD_AFTER_INSERT = 'copyScopeFromServices';   
    
    /*
    *   @ Method : copyScopeFromServices
    *   @ Description : This method called by the After insert trigger, and it assign the 
    *                   scope to offerings.
    */
    public void copyScopeFromServices(List<services__c> newServiceList) {
        try{
        Set<ID> serviceId = new Set<ID>();
        for(services__c ser:newServiceList){
            serviceId.add(ser.Opportunity_Offering__c); 
        }
        List<Services__c> serviceList=[Select Service_Text_Name__c, Service_Master__c, Opportunity_Offering__c, Name, Id,
                                                Opportunity_Offering__r.Offering_Master__r.name,Opportunity_Offering__r.Opportunity_TGP__c 
                                                From Services__c where Opportunity_Offering__c in : serviceId];

        Map<Id, String> serviceMap = new Map<Id, String>();
        list<Opportunity_Offering__c> offList = new list<Opportunity_Offering__c>();
        String serName='';
        
        for ( Services__c ser : serviceList ) { 
            if(serviceMap.containskey(ser.Opportunity_Offering__c)) {
                serName=serviceMap.get(ser.Opportunity_Offering__c);              
                if(!serName.contains(ser.name))
                     serName=serName+';'+ser.name;
                     serviceMap.put(ser.Opportunity_Offering__c,serName); 
            }else{
                serviceMap.put(ser.Opportunity_Offering__c,ser.name); 
            }  
         }
        
        for(String key :serviceMap.keySet() ){
            Opportunity_Offering__c off = new Opportunity_Offering__c();
            off.id=key;
            off.Service_Names__c=serviceMap.get(key);
            offList.add(off);
        }
            update offList;
        }catch(Exception ex){
            UTIL_LoggingService.logHandledException(ex, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, null, null, 
                                                CLASS_NAME, System.Logginglevel.ERROR);
            
        }
    } 
}