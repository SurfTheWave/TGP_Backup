/*
@Author: 
@name : operationOnAddTeam
@CreateDate : 2/20/2015 2:31 AM
@Description : 
@Version : 
*/
public without sharing class operationOnAddTeam {
        
    public static Map<Id,Boolean> approverRequsetUserMap;
    public static Map<Id,String> approverRequsetUserMap1;
    public static Map<Id,Boolean> oppTeammapIsChecked;
    public static User currentUser = [select ManagerId,Profile.Name from User where id = :userinfo.getuserid() Limit 100 ];
/******************************
    Method Name: getApproverRequsetUserMap
    Description:  
    Paramenters: NA
    Return Value: void
*******************************/  
     public static void getApproverRequsetUserMap(List<Opportunity_Additional_Team__c> approvalRequestList){

          approverRequsetUserMap = new Map<Id,Boolean>();
         //approverRequsetUserMap1 = new Map<Id,String>();
        /*for( Opportunity_Additional_Team__c appRequestRec : [ select id,name,isChecked__c,Additional_Opportunity_Role__r.ShouldBePopulatedFromSAP__c,
                                                      Opportunity__r.SAP_OM_ID__c from Opportunity_Additional_Team__c where Id IN:approvalRequestList Limit 5000 ]){
            approverRequsetUserMap.put( appRequestRec.Id,appRequestRec.Additional_Opportunity_Role__r.ShouldBePopulatedFromSAP__c );
            //approverRequsetUserMap1.put(appRequestRec.Id,appRequestRec.Opportunity__r.SAP_OM_ID__c);
         }*/

      }
    /*
    @Author: 
    @name : operationOnAddTeam
    @CreateDate :    2/20/2015 2:31 AM
    @Description : 
    @Version : 
    */
   public static void getApproverRequsetUserMap1(List<Opportunity_Additional_Team__c> approvalRequestList){
 
          //approverRequsetUserMap = new Map<Id,Boolean>();
         approverRequsetUserMap1 = new Map<Id,String>();
        /*for( Opportunity_Additional_Team__c appRequestRec : [ select id,name,isChecked__c,Additional_Opportunity_Role__r.ShouldBePopulatedFromSAP__c,
                                                     Opportunity__r.SAP_OM_ID__c from Opportunity_Additional_Team__c where Id IN:approvalRequestList Limit 5000]){
            //approverRequsetUserMap.put( appRequestRec.Id,appRequestRec.Additional_Opportunity_Role__r.ShouldBePopulatedFromSAP__c );
            approverRequsetUserMap1.put(appRequestRec.Id,appRequestRec.Opportunity__r.SAP_OM_ID__c);
         }*/

      }
    /*
    @Author: 
    @name : operationOnAddTeam
    @CreateDate :    2/20/2015 2:31 AM
    @Description : 
    @Version : 
    */
      public static void getoppTeammapIsChecked(List<Opportunity_Additional_Team__c> approvalRequestList){
 
          //approverRequsetUserMap = new Map<Id,Boolean>();
         oppTeammapIsChecked = new Map<Id,Boolean>();
        /*for( Opportunity_Additional_Team__c appRequestRec : [ select id,name,isChecked__c,Additional_Opportunity_Role__r.ShouldBePopulatedFromSAP__c,
                                                       Opportunity__r.SAP_OM_ID__c from Opportunity_Additional_Team__c where Id IN:approvalRequestList Limit 5000 ]){
            //approverRequsetUserMap.put( appRequestRec.Id,appRequestRec.Additional_Opportunity_Role__r.ShouldBePopulatedFromSAP__c );
            oppTeammapIsChecked.put(appRequestRec.Id,appRequestRec.isChecked__c);
         }*/

      }
   /* public static void validateBeforeDelete(List<Opportunity_Additional_Team__c> newApprovalRequestList ){
      
      
        for( Opportunity_Additional_Team__c appRequestRec : newApprovalRequestList){
        
            if(currentUser.Profile.Name != 'System Administrator'){
                appRequestRec.addError( 'Sorry !! You Don\'t have permission to delete this record.' );
            }
            
        }
    }*/
    
    /** THis method will populate the value of BPO Sales Lead in Governance Data**/
    /*
    @Author: 
    @name : operationOnAddTeam
    @CreateDate :    2/20/2015 2:31 AM
    @Description : 
    @Version : 
    */
    public static void getOpportunityRole(List<Opportunity_Additional_Team__c> oppAddTeam){
        Map<id, string> nameMap = new Map<id, string>();
        List<sd_governance_data__c> sdGov = new List<sd_governance_data__c>();
        Set<id> totalOpp = new Set<id>();
        Id BPOSalesLead = [select id from Opportunity_Additional_Role_Master__c where name =:UtilConstants.SOQL_STRING65 Limit 5000 ].id;
      //  //System.debug('Opportunities-->'+);
        for(Opportunity_Additional_Team__c oppTeamList : oppAddTeam){
            if(oppTeamList.Additional_Opportunity_Role__c == BPOSalesLead){
            nameMap.put(oppTeamList.Opportunity__c, oppTeamList.Additional_Opportunity_Team_Member__c);
            totalOpp.add(oppTeamList.Opportunity__c);
            ////System.debug('oppTeamList.Opportunity__c-->'+ oppTeamList.Opportunity__c);
            }
        }
        for(sd_governance_data__c govData : [ select id, opportunity__c from sd_governance_data__c where opportunity__c in :totalOpp Limit 5000]){
            govData.BPO_Sales_Lead__c = nameMap.get(govData.opportunity__c);
            sdGov.add(govData);
            }
            if(sdGov.size()> 0){
                update sdGov;
            }
        }

        /*
        @Author: 
        @name : operationOnAddTeam
        @CreateDate :    2/20/2015 2:31 AM
        @Description : * method to update the latest value 
        @Version : 
        */
        public static void getLatestRole(List<Opportunity_Additional_Team__c> oppAddTeam){
            Set<id> opp = new Set<id>();
           Set<id> oppAddTeamId = new Set<id>();
           List<sd_governance_data__c> sdGovernance = new List<sd_governance_data__c>();
            Map<id,opportunity_Additional_Team__c> teamdetails = new Map<id,opportunity_Additional_Team__c>();
            ////System.debug('oppAddTeam-->'+oppAddTeam);
            Id BPOSalesLead = [select id from Opportunity_Additional_Role_Master__c where name =:UtilConstants.SOQL_STRING65 Limit 5000 ].id;

            if(oppAddTeam!=null){
            for(Opportunity_Additional_Team__c opAd:oppAddTeam){
                if(opAd.Additional_Opportunity_Role__c == BPOSalesLead ){
                    oppAddTeamId.add(opAd.id);
                    opp.add(opAd.opportunity__c);
            }
            }
            ////System.debug('oppAddTeamId-->'+oppAddTeamId);

            for(opportunity_Additional_Team__c oppAdTeam :[select id, opportunity__c, Additional_Opportunity_Team_Member__c, lastmodifieddate 
                                                            from Opportunity_Additional_Team__c where Opportunity__c in : opp and id not in :oppAddTeamId Limit 5000]){

                if(teamdetails.containskey(oppAdTeam.opportunity__c)){
                    if(teamdetails.get(oppAdTeam.opportunity__c).lastmodifieddate < oppAdTeam.lastmodifieddate){
                        teamdetails.put(oppAdTeam.opportunity__c, oppAdTeam);
                        }
                    }
                    else{
                        teamdetails.put(oppAdTeam.opportunity__c, oppAdTeam);
                        }
                }
                }
            for(sd_governance_data__c sdGovRec : [select Id, opportunity__c 
                                                from sd_governance_data__c where opportunity__c in :opp and id not in :oppAddTeamId Limit 5000]){
            ////System.debug('sdGovRec--> '+sdGovRec);
                if(teamdetails.containskey(sdGovRec.opportunity__c)){
                    if(teamdetails.get(sdGovRec.opportunity__c)!=null){
                    sdGovRec.BPO_Sales_Lead__c =teamdetails.get(sdGovRec.opportunity__c).Additional_Opportunity_Team_Member__c; 
                    }
                    }
                else{
                    sdGovRec.BPO_Sales_Lead__c =UtilConstants.EMPTY_STRING;
                    }
                sdGovernance.add(sdGovRec);
                }
                if(sdGovernance.size()> 0){
                update sdGovernance;
            }

    }
        
   /* public static void validateBeforeEdit(List<Opportunity_Additional_Team__c> newApprovalRequestList ){
      
    //userInfo.getProfileId() != '00eE0000000qNqQIAU'
      
      //System.debug('----userInfo.getProfileId()------'+userInfo.getProfileId());
        for( Opportunity_Additional_Team__c appRequestRec : newApprovalRequestList){
        
            if(oppTeammapIsChecked.get(appRequestRec.Id) == true && approverRequsetUserMap.get(appRequestRec.Id) == true && approverRequsetUserMap1.get(appRequestRec.Id) != null && currentUser.Profile.Name != 'System Administrator'){
                appRequestRec.addError( 'Sorry !! You Don\'t have permission to Edit this record.' );
            }
            
        }
    }*/
   
    public static void updateOpp(List<Opportunity_Additional_Team__c > newAdditionalTeams,Boolean isDelete){
        Map<Id,Map<String,String>> oppIdTeamValueMap = new Map<Id,Map<String,String>>();
        List<Opportunity> oppListToUpdate = new List<Opportunity>();
        
        try{
            Map < String, Additional_Team__c > addTeamCustomSettingMap = Additional_Team__c.getall();
            for( Opportunity_Additional_Team__c oppAddTeam : [Select Id,name,Additional_Opportunity_Role__r.Name,Additional_Opportunity_Team_Member__c,Opportunity__c  from Opportunity_Additional_Team__c  where Id IN:newAdditionalTeams Limit 5000] ){
                if( oppIdTeamValueMap.containskey( oppAddTeam.Opportunity__c ) ){
                    Map<String,String> tempMap = oppIdTeamValueMap.get( oppAddTeam.Opportunity__c );
                    tempMap.put( oppAddTeam.Additional_Opportunity_Role__r.Name,oppAddTeam.Additional_Opportunity_Team_Member__c );
                    oppIdTeamValueMap.put( oppAddTeam.Opportunity__c, tempMap);
                }else{
                    Map<String,String> tempMap = new Map<String,String>();
                    tempMap.put( oppAddTeam.Additional_Opportunity_Role__r.Name,oppAddTeam.Additional_Opportunity_Team_Member__c );
                    oppIdTeamValueMap.put( oppAddTeam.Opportunity__c, tempMap);
                }
            }
            Opportunity opportunity;
            //System.debug('***********'+oppIdTeamValueMap);
           // syetm.debug('&&&&&&&&&&&&'+)
            for( Opportunity opp : [Select Id,Name,Global_Client_Account_Lead__c from Opportunity where Id in : oppIdTeamValueMap.keySet()] ){
                for(Schema.FieldSetMember fieldSetMemberObj : operationsOnStagingTriggerController.readFieldSet('Additional_Team', UtilConstants.Opportunity)){
                    opportunity = new Opportunity();
                    opportunity = opp;
                    //System.debug('&&&&&&&&&&&&'+addTeamCustomSettingMap.get(fieldSetMemberObj.getfieldpath()).Name+'+++++++++++++++'+fieldSetMemberObj.getfieldpath()+'============'+oppIdTeamValueMap.get(opp.Id).get(addTeamCustomSettingMap.get(fieldSetMemberObj.getfieldpath()).Role_Name__c));
                    if(!isDelete){
                        if(addTeamCustomSettingMap.containskey(fieldSetMemberObj.getfieldpath()) && addTeamCustomSettingMap.get(fieldSetMemberObj.getfieldpath()).Name != null && oppIdTeamValueMap.get( opp.Id ).containsKey(addTeamCustomSettingMap.get(fieldSetMemberObj.getfieldpath()).Role_Name__c)){
                            opportunity.put(fieldSetMemberObj.getfieldpath(),oppIdTeamValueMap.get(opp.Id).get(addTeamCustomSettingMap.get(fieldSetMemberObj.getfieldpath()).Role_Name__c));
                        }
                    }else{
                         
                        if( addTeamCustomSettingMap.containskey(fieldSetMemberObj.getfieldpath()) && oppIdTeamValueMap.get( opp.Id ).containsKey(addTeamCustomSettingMap.get(fieldSetMemberObj.getfieldpath()).Role_Name__c) ) {
                            opportunity.put(fieldSetMemberObj.getfieldpath(),null);
                        }
                    }
                }
                oppListToUpdate.add(opportunity);
            }
            Boolean oppTeamFlag=true;
            oppTeamFlag=UtilConstants.IS_OPPTRIGGER_REQUIRED;
            if(oppTeamFlag){
                UtilConstants.IS_OPPTRIGGER_REQUIRED=FALSE;
            }
            if( !oppListToUpdate.isEmpty() ){
                update oppListToUpdate;
            }
            
            if(oppTeamFlag){
                UtilConstants.IS_OPPTRIGGER_REQUIRED=TRUE;
            }
        }catch( Exception E ){
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = E.getMessage() + E.getStackTraceString();
            throw (E);
        }
    }
    
}