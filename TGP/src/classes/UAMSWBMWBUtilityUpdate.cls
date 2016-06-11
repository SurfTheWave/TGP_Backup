/*
@name : UAMSWBMWBUtilityUpdate
@Description : 
@Version : 
*/
public without sharing class UAMSWBMWBUtilityUpdate {
    /*
    @name : updateMobTeamWithShare
    @param : List<Mobilization_team__c> mobilizationTeamList
    @Description : 
    @Version : 
    */
    public static void updateMobTeamWithShare(List < Mobilization_team__c > mobilizationTeamList) {
        set < Id > dealId = new set < Id > ();
        Map < Id, set < Id >> dealWithMobMap = new Map < Id, set < Id >> ();
        Map < Id, Id > dumMap = new Map < Id, Id > ();
        Map < Id, Id > dumMapOne = new Map < Id, Id > ();
        Map < Id, set < Id >> mobMapWithLatestUser = new Map < Id, set < Id >> ();
        Map < Id, Id > userMaster = new Map < Id, Id > ();
        Map < Id, set < Id >> tempMap = new Map < Id, set < Id >> ();
        set < Id > tempset = new set < Id > ();
        dealWithMobMap = getMobTeam(mobilizationTeamList);

        set < Id > mobPlan = new set < id > ();
        set < Id > sratId = new set < Id > ();
        Map < Id, Id > sratWithMobPlan = new Map < Id, id > ();
        Map < Id, Id > mobWithDeal = new Map < Id, Id > ();

        set < Id > opexId = new set < Id > ();
        Map < Id, Id > opexWithMobPlan = new Map < Id, id > ();

        Map < Id, Id > waveWithMob = new Map < Id, Id > ();

        set < Id > waveId = new set < Id > ();
        Set<Id> userSet = new Set<Id>();


        for (Mobilization_team__C mobTeam: mobilizationTeamList) {
            userSet.add(mobTeam.Primary_Lead__c);
            if (mobTeam.Secondary_Lead_1__c != null) {
                userSet.add(mobTeam.Secondary_Lead_1__c);
            }
            if (mobTeam.Secondary_Lead_2__c != null) {
                userSet.add(mobTeam.Secondary_Lead_2__c);
            }
        }
        
        
        for (User_Master__c uam: [select id, user__c from User_Master__c WHERE ID IN : userSet LIMIT 20000]) {
            userMaster.put(uam.id, uam.user__c);
        }
        for (Mobilization_team__C mobTeam: mobilizationTeamList) {
            dealId.add(mobTeam.Deal__c);

            if (tempMap.containsKey(mobTeam.deal__c)) {
                tempSet = tempMap.get(mobTeam.deal__c);
            } else {
                tempSet = new set < id > ();
            }
            tempset.add(userMaster.get(mobTeam.Primary_Lead__c));
            if (mobTeam.Secondary_Lead_1__c != null) {
                tempset.add(userMaster.get(mobTeam.Secondary_Lead_1__c));
            }
            if (mobTeam.Secondary_Lead_2__c != null) {
                tempset.add(userMaster.get(mobTeam.Secondary_Lead_2__c));
            }
            tempMap.put(mobTeam.deal__c, tempSet);
        }
        /*set<Id> one=new set<id>();
        set<Id> two=new set<id>();
        
        for(Id dealAlpha:dealWithMobMap.keySet()){
            one=tempMap.get(dealAlpha);
            two=dealWithMobMap.get(dealAlpha);
            if(one!=null && two!=null){
                if(one.removeAll(two)){
                    mobMapWithLatestUser.put(dealAlpha,one);
                }else{
                    mobMapWithLatestUser.put(dealAlpha,one);
                }
            }
        }*/
        for (Mobilization_plan__C mp: [select id, deal__c from Mobilization_plan__C where Deal__C IN: dealId Limit 5000]) {
            mobPlan.add(mp.id);
            mobWithDeal.put(mp.id, mp.deal__c);
        }



        for (Srat_tracker__c srat: [select id, Mobilization_plan__C from Srat_tracker__c where Mobilization_Plan__c IN: mobPlan Limit 5000]) {
            sratId.add(srat.id);
            sratWithMobPlan.put(srat.id, srat.Mobilization_plan__C);
        }
        for (OPEX_Tracker__c opex: [select id, mobilization_plan__c from OPEX_Tracker__c where Mobilization_Plan__c IN: mobPlan Limit 5000]) {
            opexId.add(opex.id);
            opexWithMobPlan.put(opex.id, opex.Mobilization_Plan__c);
        }
        for (Wave__c wave: [select id, mobilization_plan__c from wave__C where mobilization_plan__c IN: mobPlan Limit 5000]) {
            waveId.add(wave.id);
            waveWithMob.put(wave.id, wave.mobilization_plan__c);
        }


        String query = UtilConstants.SOQL_UAMSWBMWBUtility;
        String dealFlag = UtilConstants.DEAL_SHARE;
        Id batchId = database.executeBatch(new MobilizationTeamSharingUpdate(dealId, query, dealWithMobMap, dealFlag, sratWithMobPlan, mobWithDeal, sratId, opexWithMobPlan, opexId, waveId, waveWithMob, tempMap));
    }

    /*
@name : getMobTeam
@param : List<Mobilization_team__c> mobilizationTeamList
@Description : 
@Version : 
*/


    public static Map < Id, set < Id >> getMobTeam(List < Mobilization_team__c > mobilizationTeamList) {
        Map < Id, set < Id >> dealWithMobTeam = new Map < Id, Set < Id >> ();
        set < Id > userIdset = new set < Id > ();
        set < Id > dealId = new set < Id > ();
        for (Mobilization_team__c mobTeam: mobilizationTeamList) {
            dealId.add(mobTeam.deal__c);
        }


        for (Mobilization_team__C mobilization: [select id, Primary_Lead__r.user__C, Primary_Lead__r.user__r.isActive, Secondary_Lead_1__r.user__c, 
                        Secondary_Lead_1__r.user__r.isActive, Secondary_Lead_2__r.user__c, Secondary_Lead_2__r.user__r.isActive, deal__C,Deal__r.ownerid
                        from Mobilization_team__c where deal__c in : dealId Limit 5000]) {


            if (dealWithMobTeam.containsKey(mobilization.deal__c)) {
                userIdset = dealWithMobTeam.get(mobilization.deal__c);
                if (mobilization.Primary_Lead__r.user__r.isActive) {
                    userIdset.add(mobilization.Primary_Lead__r.user__C);
                }

                if (!String.isEmpty(mobilization.Secondary_Lead_1__r.user__c) && mobilization.Secondary_Lead_1__r.user__r.isActive) {
                    userIdset.add(mobilization.Secondary_Lead_1__r.user__c);
                }
                if (!String.isEmpty(mobilization.Secondary_Lead_2__r.user__c) && mobilization.Secondary_Lead_2__r.user__r.isActive) {
                    userIdset.add(mobilization.Secondary_Lead_2__r.user__c);
                }
                userIdset.add(mobilization.Deal__r.ownerid);
                dealWithMobTeam.put(mobilization.deal__C, userIdset);
            } else {
                userIdset = new set < Id > ();
                if (mobilization.Primary_Lead__r.user__r.isActive) {
                    userIdset.add(mobilization.Primary_Lead__r.user__C);
                }

                if (!String.isEmpty(mobilization.Secondary_Lead_1__r.user__c) && mobilization.Secondary_Lead_1__r.user__r.isActive) {
                    userIdset.add(mobilization.Secondary_Lead_1__r.user__c);
                }
                if (!String.isEmpty(mobilization.Secondary_Lead_2__r.user__c) && mobilization.Secondary_Lead_2__r.user__r.isActive) {
                    userIdset.add(mobilization.Secondary_Lead_2__r.user__c);
                }
                userIdset.add(mobilization.Deal__r.ownerid);
                dealWithMobTeam.put(mobilization.deal__C, userIdset);
            }

        }
        return dealWithMobTeam;
    }
}