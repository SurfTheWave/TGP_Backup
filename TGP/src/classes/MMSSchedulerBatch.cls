global class MMSSchedulerBatch implements Database.Batchable<sObject>,Database.Stateful{
    	
    global String query;
    global string iden;
	global List<Opportunity> InactiveList=new List<Opportunity>();
    global List<Opportunity> ParentList=new List<Opportunity>();
    global List<Opportunity> childOppList=new List<Opportunity>();
    global List<Sap_om_staging__C> sapList=new List<Sap_om_staging__C>();
    
    global set<String> inactive=new set<String>();
    global Map<String,Opportunity> OpportunityInactiveMap=new Map<String,Opportunity>();
    
    global set<String> parentIdSet=new set<String>();
    global Map<String,Opportunity> OpportunityParentMap=new Map<String,Opportunity>();
    
    global set<String> sapIdSet=new set<String>();
    global Map<String,sap_om_staging__C> sapOmMap=new Map<String,sap_om_staging__C>();
    
    global set<String> childOppSet=new set<String>();
    global Map<String,Opportunity> childOppMap=new Map<String,Opportunity>();
    
    global MMSSchedulerBatch(String tgpQuery,String tgpOpp,set<String> inactiveSet,Map<String,Opportunity> InactiveMap,
                             set<String> parentSet,Map<String,Opportunity> parentOpp,set<String> sapSet,
                             Map<String,sap_om_staging__C> sapMap){
        query=tgpQuery;
        iden=tgpOpp;
        OpportunityInactiveMap=InactiveMap;
        OpportunityParentMap=parentOpp;
        inactive=inactiveSet;
        parentIdSet=parentSet;
        sapIdSet=sapSet;
        sapOmMap=sapMap;
        /*childOppSet=childOps;
        childOppMap=childOpsMap;*/
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc,List<sObject> sObjectList){
        for(sObject opp:sObjectList){
            Id pId=String.valueOf(opp.get('id'));
            if(iden.equalsIgnoreCase('Inactive')){
                InactiveList.add(OpportunityInactiveMap.get(pId));
            }else if(iden.equalsIgnoreCase('Child')){
                system.debug('Come here for parent');
                 ParentList.add(OpportunityParentMap.get(pId));      
            }else if(iden.equalsIgnoreCase('SAP')){
                sapList.add(sapOmMap.get(pId));
            }/*else if(iden.equalsIgnoreCase('ChildOpp')){
                childOppList.add(childOppMap.get(pId));
            }*/
        }
        UtilConstants.IS_OPPTRIGGER_REQUIRED=false;
        RecursiveTriggerHelper.runOnce();
        
        if(!InactiveList.isEmpty()){
            database.update(InactiveList,true);
        }
        if(!ParentList.isEmpty()){
            system.debug('Hello come here' +ParentList.size());
            database.update(ParentList,true);
        }
        if(!sapList.isEmpty()){
            database.update(sapList,true);
        }
        /*if(!childOppList.isEmpty()){
            database.update(childOppList,true);
        }*/
    }
    
    global void finish(Database.BatchableContext bc){
        if(iden.equalsIgnoreCase('Inactive')){
            String identifi='Child';
            String inactiveQuery='select id from opportunity where Id in:parentIdSet';
            Id dump=database.executeBatch(new MMSSchedulerBatch(inactiveQuery,'Child',inactive,
                                                                OpportunityInactiveMap,parentIdSet,
                                                                OpportunityParentMap,sapIdSet,sapOmMap),100);
        }else if(iden.equalsIgnoreCase('Child')){
            String identifi='SAP';
            String inactiveQuery='select id from sap_om_staging__C where Id in:sapIdSet';
            Id dump=database.executeBatch(new MMSSchedulerBatch(inactiveQuery,'SAP',inactive,
                                                                OpportunityInactiveMap,parentIdSet,
                                                                OpportunityParentMap,sapIdSet,sapOmMap),100);
        }/*else if(iden.equalsIgnoreCase('SAP')){
            String identifi='Child';
            String inactiveQuery='select id from opportunity where Id in:childOppSet';
            Id dump=database.executeBatch(new MMSSchedulerBatch(inactiveQuery,'ChildOpp',inactive,
                                                                OpportunityInactiveMap,parentIdSet,
                                                                OpportunityParentMap,sapIdSet,sapOmMap,
                                                                childOppSet,childOppMap),100);
        }*/
    }
}