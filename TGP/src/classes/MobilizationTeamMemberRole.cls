/*
   @Author: Mukesh
   @Created Date: 7th May,2015
   @Name: MobilizationTeamMemberRole
   @Description: This class is used to populate "GTL" and "GL" Role's Primary user on Deal.
   @Version: 1.0
*/
public class MobilizationTeamMemberRole {

/*
 @Description:Method populateRole use to poplulate primary user of GTL and GL Role.
 */     
public static void populateRole (List<Mobilization_Team__c> mobilizationTeam){
    set<Id> dealId = new set<id>();
    Map<Id,Id> userMaster=new Map<Id,Id>();
    Map<Id,set<string>> tempMap=new Map<Id,set<string>>();
    set<string> primaryset = new set<string>();
    set<string> pickdealId = new set<string>();
    set<string> tempset=new set<string>();    
    Deal__c dealupdatefield = new Deal__c();
    List<Deal__c> DealList = new LIst<Deal__c>();
        
        
    try{
        for(Mobilization_Team__c mobTeam:[select Id,Primary_Lead__c,Primary_Lead__r.name,Role__c,deal__c from Mobilization_Team__c WHERE id IN: mobilizationTeam LIMIT 5000]){
            if(((mobTeam.Role__c).equals(UtilConstants.GTL_ROLE_NAME))||((mobTeam.Role__c).equals(UtilConstants.ROLE_ID))){
                if(tempMap.containsKey(mobTeam.deal__c)){
                    tempSet=tempMap.get(mobTeam.deal__c);
                }else{
                    tempSet=new set<string>();                                    
                }
                dealId.add(mobTeam.deal__c);
                tempSet.add(mobTeam.Primary_Lead__r.name + UtilConstants.COMMA_STRING + mobTeam.Role__c);
                tempMap.put(mobTeam.deal__c,tempset);
            }
        }   
        for(deal__c dealupdate: [SELECT id,name,Governance_Lead__c,Global_Transition_Lead__c FROM Deal__c WHERE id IN:dealId LIMIT 5000]){
            set<string> setofuser = tempMap.get(dealupdate.Id);
            if(setofuser!=null && !setofuser.isEmpty()){
                for(string userRole :setofuser ){                                       
                     string[] picktosplit = userRole.split('\\,');
                     string username = picktosplit[0];
                     string role = picktosplit[1];
                     if(role.equals(UtilConstants.ROLE_ID)){
                        dealupdate.Governance_Lead__c=username;
                     }else{
                        dealupdate.Global_Transition_Lead__c=username;
                     }
                    
                }
                DealList.add(dealupdate);
            }
            
        }
        Database.update(DealList,false);
         
      }catch(Exception e){
                UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                            UtilConstants.MOBTEAM , UtilConstants.MOBTEAM , null, System.Logginglevel.ERROR);
       }
    }
    
}