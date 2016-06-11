/*
  @Author: Yasin Khan
  @Name: waveEmailRemainder
  @Created Date: 15 Dec 2015
  @Description: Util class is used to get all active deal teammember ids.
  @version: 3.5 
*/

global class waveEmailRemainder{

       global static Map<id,list<String>> dealTeamMapTo;
       global static Map<id,list<String>> dealTeamMapCc;
                  
       public static Map<id,list<String>> getMailIDs(Set<id> dealIdSets, Integer numberOfTimes){
            
           system.debug('waveStatusAlert dealIdSets :'+dealIdSets);
          
           //This map is used to map the each deal with team members
           dealTeamMapTo=new Map<id,list<String>> ();
           List<String> mobTeamList;
                
           dealTeamMapCc=new Map<id,list<String>> ();
           List<String>  mobTeamCcList;
            
          for(Mobilization_Team__c teamMember : [SELECT Name,Deal__c,Primary_Lead__r.email__c,Secondary_Lead_1__r.email__c,Secondary_Lead_2__r.email__c,Role__c,Active__c from Mobilization_Team__c where Deal__c IN : dealIdSets AND Active__c = true limit 5000]) {
            system.debug('!.equalsIgnoreCase(teamMember.Role__c)==== '+teamMember.Role__c);
            if(teamMember.Role__c!=null &&(teamMember.Role__c == 'Deal PMO')){
                if(dealTeamMapTo.containsKey(teamMember.Deal__c)){                           
                     mobTeamList = dealTeamMapTo.get(teamMember.Deal__c);
                }
                else {
                   mobTeamList = new List<String>();
                }
                if(teamMember.Primary_Lead__r.email__c!=null){
                    mobTeamList.add(teamMember.Primary_Lead__r.email__c);
                }
                if(teamMember.Secondary_Lead_1__r.email__c!=null){
                    mobTeamList.add(teamMember.Secondary_Lead_1__r.email__c);
                }
                if(teamMember.Secondary_Lead_2__r.email__c!=null){
                    mobTeamList.add(teamMember.Secondary_Lead_2__r.email__c);
                }
                 if ( mobTeamList != null && !mobTeamList.isEmpty() ) {
                dealTeamMapTo.put(teamMember.Deal__c,mobTeamList);
                }
                system.debug('dealTeamMapTo  ----'+dealTeamMapTo);
            }
            else if(teamMember.Role__c!=null && ((teamMember.Role__c=='Governance Lead')||(teamMember.Role__c=='Global Transition Lead'))){
                if(dealTeamMapCc.containsKey(teamMember.Deal__c)){                           
                     mobTeamCcList = dealTeamMapCc.get(teamMember.Deal__c);
                }
                else {
                   mobTeamCcList = new List<String>();
                }
                if(teamMember.Primary_Lead__r.email__c!=null){
                    mobTeamCcList.add(teamMember.Primary_Lead__r.email__c);
                }
                if(teamMember.Secondary_Lead_1__r.email__c!=null){
                    mobTeamCcList.add(teamMember.Secondary_Lead_1__r.email__c);
                }
                if(teamMember.Secondary_Lead_2__r.email__c!=null){
                    mobTeamCcList.add(teamMember.Secondary_Lead_2__r.email__c);
                }
                if ( mobTeamCcList != null && !mobTeamCcList.isEmpty() ) {
                dealTeamMapCc.put(teamMember.Deal__c,mobTeamCcList);
                }
                system.debug('dealTeamMapCc  ----'+dealTeamMapCc);  
            }
         }
           if(numberOfTimes == 1)
              return dealTeamMapTo;
           else 
              return dealTeamMapCc;
       }
      
       public static void waveStatusAlert(List<sObject> sObjectList, Set<id> dealIdSets,String msg,String objectName){                               
           dealTeamMapTo = getMailIDs(dealIdSets, 1);  
           dealTeamMapCc = getMailIDs(dealIdSets, 2);         
           system.debug('-- waveStatusAlert 81 EmailRemainders:');     
           if(objectName == 'wave')    
                EmailRemainders.waveStatusAlert(sObjectList, dealTeamMapTo,dealTeamMapCc,msg,objectName);        
       }  
       
       public static void dealAlert(List<sObject> sObjectList, Set<id> dealIdSets){                               
           dealTeamMapTo = getMailIDs(dealIdSets, 1);  
           dealTeamMapCc = getMailIDs(dealIdSets, 2);               
                EmailRemainders.dealStatusAlert(sObjectList, dealTeamMapTo,dealTeamMapCc);         
       } 
                
       public static void trackingStatusAlert(List<sObject> sObjectList, Set<id> dealIdSets,String msg,String objectName){   
           dealTeamMapTo = getMailIDs(dealIdSets, 1);  
           dealTeamMapCc = getMailIDs(dealIdSets, 2);   
           if(objectName == 'KT')           
                EmailRemainders.ktSendAlert(sObjectList, dealTeamMapTo,dealTeamMapCc,msg,objectName);           
           else if(objectName == 'Recruit')
                EmailRemainders.recruitSendAlert(sObjectList, dealTeamMapTo,dealTeamMapCc,msg,objectName);            
           else if(objectName == 'TechWE')
                EmailRemainders.techweSendAlert(sObjectList, dealTeamMapTo,dealTeamMapCc,msg,objectName);   
       }    
}