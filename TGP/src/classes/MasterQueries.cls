public class MasterQueries {
    public static Map<id,Opportunity> OppFromSolScope;
    public static Map<id,Opportunity> OppFromService;
    public static list<Offering_Master__c> allActiveOffMasters;
    private static boolean allActMasFlag = false;
    public static void findAllActiveOffMasters(){
        if(!allActMasFlag){
            allActiveOffMasters = [Select Id,Name,Service_Group__c, offering_description__c from Offering_Master__c where Active__c =: true];
            allActMasFlag = true;
        }
    }
    
    public static list<Services_Master__c> allServiceMasters_Delivery;
    private static boolean allSerMas_DelFlag = false;
    public static void findAllServiceMasters_Delivery(){
        if(!allSerMas_DelFlag){
            allServiceMasters_Delivery = [Select Id,Name,Is_Offering_Specific_Service__c,
                                                 Service_Group__c,Solution_Component__c,offering__c,
                                                 offering__r.Name
                                                 from Services_Master__c where Active__c =: UtilConstants.BOOLEAN_TRUE AND
                                                 Is_Offering_Specific_Service__c =: UtilConstants.BOOLEAN_TRUE AND 
                                                 Solution_Component__c !=: UtilConstants.SOLCOMP_DELIVERY Limit 10000];
            allSerMas_DelFlag = true;
        }
    }
    public static list<Operating_Groups_Master__c> alloperatinggroupmasters = new  list<Operating_Groups_Master__c>();
    public static boolean queryOppGroupmasters = true;
    public static list<Operating_Groups_Master__c> queryAllOppGroups(){
        if(queryOppGroupmasters){
            alloperatinggroupmasters = [select id, name from Operating_Groups_Master__c where Active__c = true limit 1000];
            if(alloperatinggroupmasters.size() >0){
                queryOppGroupmasters = false;
            }
        }
            return alloperatinggroupmasters;
    }
    public static list<Services_Master__c> allActiveSerMasters;
    public static map<Id,Services_Master__c> allServMastId_ServMasMap;
    private static boolean allActSerFlag = false;
    public static void findallActiveSerMasters(){
        if(!allActSerFlag){
            allServMastId_ServMasMap = new map<Id,Services_Master__c>([Select Id,Name,Is_Offering_Specific_Service__c,
                                           Service_Group__c,Solution_Component__c,offering__c,
                                           offering__r.Name from Services_Master__c 
                                           where offering__r.Active__c =: UtilConstants.BOOLEAN_TRUE AND Active__c =: UtilConstants.BOOLEAN_TRUE Limit 10000]);
            allActiveSerMasters = allServMastId_ServMasMap.Values();
            allActSerFlag = true;
        }
    }
    public static List < Geo_Region_Master__c > geoRegionMasterList;
    private static boolean allGeoRegionFlag = false;
    public static List < Geo_Region_Master__c > findallGeoRegionMasters(){
        if(!allGeoRegionFlag ){
            geoRegionMasterList= [select id, name from Geo_Region_Master__c where Active__c = true ];
            allGeoRegionFlag=true;
        }
        system.debug('Geo region size'+geoRegionMasterList.size());
        return geoRegionMasterList;
    }
    
    public static Map<id,Opportunity> findallOppFromSolscope(Set<Id> idSet){
        OppFromSolScope =  new Map<Id,Opportunity>([Select id,Is_Synced__c,is_synced_io__c  from Opportunity where Id in :idSet]);
        return OppFromSolScope;
    }
    public static Boolean allSerOppFound = false;
    public static Map<id,Opportunity> findallOppFromService(Set<Id> idSet){
        if(!allSerOppFound){
            OppFromService =  new Map<Id,Opportunity>([Select id,Is_Synced__c,is_synced_io__c from Opportunity where Id in :idSet]);
            allSerOppFound = true;
        }
        return OppFromService;
    }
    public static List<Opportunity> aftInsertOpp = new List<Opportunity>();
    public static Boolean isAftInsertTrig = true;
    public static list<Opportunity> oppsAftInstTrig(Set<Id> oppIds){
        system.debug('master queries before set'+oppIds);
        system.debug('is after trigger flag-->'+isAftInsertTrig);
        if(isAftInsertTrig){
        system.debug('inside if of master query');
            aftInsertOpp= [select id, name, Off__c, Offerings_IO__c, Offerings_IC__c, Service_Grp__c, Pri_Off__c,
                                    Primary_Offering_Revenue_SAP__c, Active__c, (select id,Active__c,Opportunity__r.is_synced__c,SAP_Offering_Revenue__c, Service_Group__c, Solution_Component__c,
                                    name, Offering_Master__c, Offering_Master__r.Service_Group__c, Offering_Master__r.name, Opportunity__c
                                    FROM Solution_Components__r where Active__c = : true order by createdDate asc)
                                    FROM Opportunity where id IN: oppIds LIMIT 5000];
            if(!aftInsertOpp.isempty()){
                isAftInsertTrig = false;
            }
            system.debug('Queried aftInsertOpp: '+aftInsertOpp);
        }
        //if()
        return aftInsertOpp;
    }
    
    public static List<Opportunity> aftUpdOpp = new List<Opportunity>();
    public static Boolean isAftUpdTrig = true;
    public static list<Opportunity> oppsAftUpdTrig(Set<Id> oppIds){
        //system.debug('master queries after set'+oppIds);
        if(isAftUpdTrig){
            aftUpdOpp= [select id, name, Off__c, Offerings_IO__c, Offerings_IC__c, Service_Grp__c, Pri_Off__c,
                                    Primary_Offering_Revenue_SAP__c, (select id,Opportunity__r.is_synced__c,Active__c, SAP_Offering_Revenue__c, Service_Group__c, Solution_Component__c,
                                    name, Offering_Master__c, Offering_Master__r.Service_Group__c, Offering_Master__r.name, Opportunity__c
                                    FROM Solution_Components__r where Active__c = : true order by createdDate asc)
                                    FROM Opportunity where id IN: oppIds LIMIT 5000];
            if(!aftUpdOpp.isEmpty()){
                isAftUpdTrig = false;
            }
        }
        return aftUpdOpp;
    }
    
    public static List<Profile> profileList = new List<Profile>();
    public static Boolean isFlag = true;
    public static list<Profile> retreiveProfile(){
        //system.debug('master queries after set'+oppIds);
        if(isFlag){
            profileList =  [SELECT Id, Name FROM Profile WHERE Id = : userinfo.getProfileId() LIMIT 1];
            isFlag = false;
        }
        return profileList;
    }
    public static List<Opportunity> oppdeliveryloc = new List<Opportunity>();
    public static Boolean firstcall = true;
    public static list<Opportunity> queryoppdeliveryloc(Set<Id> oppIds){
        //system.debug('master queries after set'+oppIds);
        if(firstcall){
            oppdeliveryloc= [Select Id,Name,Delivery_Locations__c,Delivery_Locations_IC__c,Delivery_Locations_IO__c
                                 from Opportunity where ID IN : oppIds LIMIT 5000];
            if(!oppdeliveryloc.isempty()){
               firstcall = false;
            }
        }
        return oppdeliveryloc;
    }
     public static List<Opportunity_Delivery_Location__c > deliverylocs = new List<Opportunity_Delivery_Location__c >();
    public static Boolean invokedfirsttime= true;
    public static list<Opportunity_Delivery_Location__c > querydeliverylocs(Set<Id> oppIds){
        //system.debug('master queries after set'+oppIds);
        if(invokedfirsttime){
            deliverylocs = [Select id,Name,Delivery_Location__r.Name,
                                                                  Offering_Service__r.Solutionscope__r.Opportunity__c,
                                                                  Offering_Service__r.Solutionscope__r.Service_Group__c
                                                                  from Opportunity_Delivery_Location__c where Offering_Service__r.Solutionscope__r.Opportunity__c IN:
                                                                  oppIds LIMIT 5000];
            if(! deliverylocs.isempty()){
                invokedfirsttime= false;
            }
        }
        return deliverylocs;
    }
    public static list<Country_Master__c> countryMasterslist = new list<Country_Master__c>();
    public static boolean givecountrymaster = true;
    public static  list<Country_Master__c> querycountrymasters(){
        if(givecountrymaster){
            countryMasterslist = [SELECT id, name,Geo_Region__r.name FROM Country_Master__c];
        }
        if(!countryMasterslist.isempty()){
            givecountrymaster = false;
        }
        return countryMasterslist;
    }
    public static list<Delivery_Location_Masters__c > deliveryMasterslist = new list<Delivery_Location_Masters__c >();
    public static boolean givedeliverymaster = true;
    public static  list<Delivery_Location_Masters__c> querydeliverymasters(){
        if(givedeliverymaster){
            deliveryMasterslist = [SELECT id, name  FROM Delivery_Location_Masters__c];
        }
        if(!deliveryMasterslist.isempty()){
            givedeliverymaster = false;
        }
        return deliveryMasterslist;
    }
    
    
    public static Map<String,Id> serviceGroup=new Map<String,Id>();
    public static boolean giveServiceGroup=true;
    public static Map<String, Id> serviceGroupMap(){
        //Map<String, Id> srvGroupMap = new Map<String, Id>();
        if(giveServiceGroup){
            for(SeriveGroupsMaster__c srv: [Select Id, Name,Service_Group__c FROM SeriveGroupsMaster__c]){
              serviceGroup.put(srv.Name, srv.Id);
          }
            giveServiceGroup=false;
        }
        
        return serviceGroup;
    }
    
    
     public static list<Payroll__c> payrolllist = new list<Payroll__c>();
    public static boolean payRollQueried = true;
    public static  list<Payroll__c> queryPayroll(Id opportunityId){
        if(payRollQueried){
            payrolllist = [select id from Payroll__c where Opportunity__c=:opportunityId Limit 5000];
        }
        if(!payrolllist.isempty()){
            payRollQueried = false;
        }
        return payrolllist;
    }
/**    
    *@Description:     
    *  @name  :solscopepopulated
    *  @param :set<id> opportunityids
    *  @return:parameter -map<id,string>
    */
    public static map<id,string> solscopepopulated(set<id> opportunityids){
    string listOfSolScopeNames='';
    map<id,string> solscopename=new map<id,string>();
    list<Solution_Scope__c > solscope=new list<Solution_Scope__c >();
    solscope= [select id,Offering_Master__r.name,Opportunity__c from Solution_Scope__c where Opportunity__c in:opportunityids and Solution_Component__c='Technology' and Service_Group__c='BPO' and Active__c=true LIMIT 5000];
    for(Solution_Scope__c sol:solscope)
    {
       if(solscopename.containskey(sol.Opportunity__c)){
       system.debug('solscopename'+solscopename);
       listOfSolScopeNames=solscopename.get(sol.Opportunity__c);
       listOfSolScopeNames+=';'+sol.Offering_Master__r.name;
       solscopename.put(sol.Opportunity__c, listOfSolScopeNames);
    }
   else{
        solscopename.put(sol.Opportunity__c, sol.Offering_Master__r.name);
   }
  
    }
    return solscopename;

}
/**    
    *@Description:     
    *  @name  :rolenames
    *  @param :
    *  @return:parameter -map<id,Opportunity_Roles_Master__c >
    */
    public static map<id,Opportunity_Roles_Master__c > rolenames(){
        Map<ID, Opportunity_Roles_Master__c > m = new Map<ID, Opportunity_Roles_Master__c >([SELECT Id, name FROM Opportunity_Roles_Master__c limit 100]);
        return m;
    }
    
     public static list<Opportunity_Additional_Role_Master__c> addlroleMasterList = new list<Opportunity_Additional_Role_Master__c>();
    public static boolean addlrolemasterQueried = true;
    public static  list<Opportunity_Additional_Role_Master__c> querydata(){
        if(addlrolemasterQueried ){
            addlroleMasterList = [Select Name, active__c, ShouldBePopulatedFromSAP__c
            from Opportunity_Additional_Role_Master__c where ShouldBePopulatedFromSAP__c = True and active__c = true Limit 5000];
        }
        if(!addlroleMasterList.isempty()){
            addlrolemasterQueried = false;
        }
        return addlroleMasterList;
    }
    
     
     public static list<Operating_Groups_Master__c> oppGrupMasterList = new list<Operating_Groups_Master__c>();
    public static boolean oppGrupQueried = true;
    public static  list<Operating_Groups_Master__c> queryOppGrup(){
        if(oppGrupQueried){
            oppGrupMasterList = [select id,name from Operating_Groups_Master__c where active__C=true LIMIT 1000];
        }
        if(!oppGrupMasterList.isempty()){
            oppGrupQueried = false;
        }
        return oppGrupMasterList;
    }
    
    public static List<Opportunity_Additional_Role_Master__c> oppAdditionalMasterList;
    public static Boolean oppAddiMaster=true;
    
    public static List<Opportunity_Additional_Role_Master__c> queryAdditionalMaster(){
        if(oppAddiMaster){
            oppAdditionalMasterList=[Select Name, active__c, ShouldBePopulatedFromSAP__c
            from Opportunity_Additional_Role_Master__c where ShouldBePopulatedFromSAP__c = True and active__c = true Limit 5000];
        }
        if(!oppAdditionalMasterList.isEmpty()){
            oppAddiMaster=false;
        }
        return oppAdditionalMasterList;
    }
}