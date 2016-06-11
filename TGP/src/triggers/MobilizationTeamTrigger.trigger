/*
   @Author: Shivraj.gangabyraiah
   @Created Date: 12th January,2015
   @Name: MobilizationTeamTrigger
   @Description: This trigger is used to prevent creation of duplicate teams with same role for a Deal
   @Version: 1.0
*/
trigger MobilizationTeamTrigger on Mobilization_Team__c (before insert,after insert,before update,after update,after delete) {
   List<Mobilization_Team__c> lstNewDealTeam = Trigger.new;
   List<Mobilization_Team__c> lstOldDealTeam = Trigger.old;
   List<Mobilization_Team__c> mobilizationList = new List<Mobilization_Team__c>(); 
   List<Mobilization_team__c> mobilizationTeamforDeal=new List<Mobilization_team__c>();
    UAMSWBMWBUtility uamUtility= new UAMSWBMWBUtility();    
    set<Id> dealId=new set<Id>();
    Map<Id,List<Id>> dealWithTeamMap=new Map<Id,List<Id>>();
    List<Id> mobTeamId=new List<Id>();
    Boolean DeleteMobTeamFlag=FALSE;
    Map<ID,Mobilization_Team__c> DummyMap = new Map<ID, Mobilization_Team__C>();
    
   if(!Test.isRunningTest()){
       
    List<FlagCheck__c> flagCheckList= FlagCheck__c.getAll().values();
        Boolean mobTeamTriggerFlag = flagCheckList[0].MobilizationTeamTrigger__c;
    if(mobTeamTriggerFlag) {
       try{ 
            if(trigger.IsInsert && trigger.isBefore){
                MobilizationTeam.populateDealOnMobilizationTeam(Trigger.new);
                for(Mobilization_Team__c mobilizationTeam:trigger.new){
                    mobilizationList.add(mobilizationTeam); 
                }
            }
            if(trigger.isupdate && trigger.isBefore){
                MobilizationTeam.populateDealOnMobilizationTeam(Trigger.new);
             }         
            if(!mobilizationList.isEmpty()){
                    MobilizationTeam.checkDuplicateRoles(mobilizationList);    
            }
            if(Trigger.isAfter && Trigger.isInsert) {
                UAMSWBMWBUtilityUpdate.updateMobTeamWithShare(lstNewDealTeam);
                MobilizationTeamMemberRole.populateRole(Trigger.new);
                
            }
           if (Trigger.isAfter && Trigger.isupdate){
               uamUtility.shareOnUpdate(Trigger.new,Trigger.oldMap, FALSE);
               UAMSWBMWBUtility.updateMobTeamWithShare(Trigger.new,Trigger.oldMap);
               for(Mobilization_team__c mobTeam:Trigger.new){
                   if(mobTeam.primary_lead__c !=trigger.oldMap.get(mobTeam.id).primary_lead__C){
                       mobilizationTeamforDeal.add(mobTeam);
                   }
               }               
               MobilizationTeamMemberRole.populateRole(mobilizationTeamforDeal);
           }
           if (Trigger.isAfter && Trigger.isDelete){
               uamUtility.ShareOnUpdate(lstOldDealTeam,DummyMap,TRUE);
           } 
       }catch(Exception e){
            System.debug('ERROR!!!' +  e);
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                            UtilConstants.MOB , UtilConstants.MOB , null, System.Logginglevel.ERROR);
       } 
   
        }
    }
    
}