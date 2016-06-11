/*
  @Author: Shivraj.gangabyraiah
  @created Date: 12th January,2015
  @Name: MobilizationTeam
  @Description: This class contains all methods required to update Mobilization Team records
*/
public without sharing class MobilizationTeam {
    
    /*
      @Author: Shivraj.gangabyraiah
      @Name: createMobilizationTeam
      @Description: This method is created mobilization team record with role as 'Goverance Lead ' after deal is approved
      @Parameters: List ofg Deals which are updated after approval
    */
    public static void createMobilizationTeam(List<Deal__c> dealList){
        List<Mobilization_Team__c> mobilizationTeamList = new List<Mobilization_Team__c>();
        set<Id> userId = new set<Id>();
        
        try{
            for(Deal__C deal:dealList){
                userId.add(deal.Approver__c);
            }
        
        /*
         *This method creates mob team with primary role user Master ID::
           Condition:: if multiple userMaster are created with same userId then there will multiple Goverance lead for a deal
           Since code is developed with condtion that there will be 1-1 mapping bt user and usermaster
         *
        */
        Mobilization_Team__c mobilizationTeam=new Mobilization_Team__c();
        Mobilization_Team__c gtlMobilizationTeam=new Mobilization_Team__c();
            for(User_Master__C userMaster:[select id,name,First_Name__c,user__C 
                                           from User_Master__c where user__c in :userId Limit 5000]){
                for(Deal__c deal:dealList){
                      mobilizationTeam = new Mobilization_Team__c();
                      mobilizationTeam.Deal__c = deal.id;
                      mobilizationTeam.Role__c = UtilConstants.ROLE_ID;
                      
                      gtlMobilizationTeam=new Mobilization_Team__c();
                      gtlMobilizationTeam.Deal__c = deal.id;
                      gtlMobilizationTeam.Role__c = UtillContstant_Novasuite.GTL;
                      
                      if((deal.Approver__c).equals(userMaster.user__c)){
                            mobilizationTeam.Primary_Lead__c = userMaster.id;
                            gtlMobilizationTeam.Primary_Lead__c = userMaster.id;
                      }
                      
                      
                      mobilizationTeamList.add(mobilizationTeam);
                      mobilizationTeamList.add(gtlMobilizationTeam);
                    
                }
             }
         
            Database.upsert(mobilizationTeamList);
         
         }catch(Exception e){
                 UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.MOBTEAM , UtilConstants.MOBTEAM , null, System.Logginglevel.ERROR);
         }
    }
    
    /*
      @Author: Shivraj.gangabyraiah
      @Name: checkDuplicateRoles
      @Paramaters: List of Mobilization Team records before saving
      @Description: This method is called to prevent creation of duplicate Mobilization team with same role for given Deal
    */    
    public static void checkDuplicateRoles(List<Mobilization_Team__c> mobilizationTeam){
        
        set<Id> dealId = new set<Id>();
        set<Id> waveId=new set<Id>();
        set<Id> locationdId=new set<Id>();
        Map<Id,List<String>> mobilizationTeamValues = new Map<Id,List<String>>();
        List<String> mobilizationRoles = new List<String>();
        List<String> mobilizationWaveRoles= new List<String>();
        List<String> mobilizationLocation= new List<String>();
        Map<Id,String> dealWithStatus = new Map<Id,String>();
        List<Mobilization_Team__c> mobilizationTeamList = new List<Mobilization_Team__c>();
        List<Mobilization_Team__c> mobilizationTeamWaveList = new List<Mobilization_Team__c>();
        List<Mobilization_Team__c> mobilizationTeamLocationList = new List<Mobilization_Team__c>();
        Map<Id,List<String>> mobilizationWaveValues=new Map<Id,List<String>>();
        Map<Id,List<String>> mobilizationLocationValues=new Map<Id,List<String>>();
        
        try{
        
            for(Mobilization_Team__c mobilizationTeamToInsert:mobilizationTeam){
                dealId.add(mobilizationTeamToInsert.deal__c);
                waveId.add(mobilizationTeamToInsert.Wave__c);
                locationdId.add(mobilizationTeamToInsert.Delivery_Location_Master__c);
            }
            
            for(Deal__c deal:[select id,name,Approval_Status__c,(select id,role__c from Mobilization_Teams__r) 
                              from Deal__c where id IN:dealId LIMIT 2000]){
                mobilizationRoles = new List<String>();
                mobilizationTeamList = deal.Mobilization_Teams__r;
                if(mobilizationTeamList!=NULL){
                    if(!mobilizationTeamList.isEmpty()){
                        for(Mobilization_Team__c mobilizationTeamFromDeal:mobilizationTeamList){
                            mobilizationRoles.add(mobilizationTeamFromDeal.role__c);
                        }    
                    }
                }
                
                
                mobilizationTeamValues.put(deal.id,mobilizationRoles);
                dealWithStatus.put(deal.id,deal.Approval_Status__c);
            }
            
            for(Wave__C wave:[select id,(select id,role__c from Mobilization_Teams__r) 
                              from wave__c where ID IN:waveId LIMIT 5000]){
                mobilizationWaveRoles=new List<String>();
                mobilizationTeamWaveList=wave.Mobilization_Teams__r;
                if(mobilizationTeamWaveList!=NULL){
                    if(!mobilizationTeamWaveList.isEmpty()){
                        for(Mobilization_team__c mobTeam:mobilizationTeamWaveList){
                            mobilizationWaveRoles.add(mobTeam.role__c);
                        }
                    }    
                }
                
                mobilizationWaveValues.put(wave.id,mobilizationWaveRoles);
                             
            }
            
            /*for(Delivery_Location_Masters__c location:[select id,(select id,role__c from Mobilization_Teams__r) from Delivery_Location_Masters__c where ID IN:locationdId LIMIT 5000]){
                mobilizationLocation=new List<String>();
                mobilizationTeamLocationList =location.Mobilization_Teams__r;
                if(mobilizationTeamLocationList!=NULL){
                    if(!mobilizationTeamLocationList.isEmpty()){
                        for(Mobilization_team__c mobTeam:mobilizationTeamLocationList){
                            mobilizationLocation.add(mobTeam.role__c);
                        }
                    }    
                }
                
                mobilizationLocationValues.put(location.id,mobilizationLocation);  
            }*/
            for(Mobilization_Team__c mobPlan: mobilizationTeam){
           
                mobilizationRoles = new List<String>();
                mobilizationRoles = mobilizationTeamValues.get(mobPlan.Deal__c);
                String approvalStatus = dealWithStatus.get(mobPlan.Deal__c);
                if(!String.isEmpty(mobPlan.Deal__c)){
                    if(String.isEmpty(approvalStatus) || approvalStatus.equals(UtilConstants.PENDING_STATUS) 
                       || approvalStatus.equals(UtilConstants.RECALL_STATUS) 
                       || approvalStatus.equals(UtilConstants.REJECT_STATUS)){
                        mobPlan.addError(utilConstants.DEAL_NOT_APPROVED);
                    }    
                }
                if(mobilizationRoles!=NULL){
                    if(!mobilizationRoles.isEmpty()){
                        for(String role: mobilizationRoles){
                           if(String.isEmpty(mobPlan.Wave__c) && String.isEmpty(mobPlan.Delivery_Location_Master__c)){
                                if(role.equals(mobPlan.Role__c)){
                                    mobPlan.addError(UtilConstants.ROLE_ERROR_MESSAGE);
                                }   
                           }
                        }    
                    }
                }
                
                
                mobilizationWaveRoles=new List<String>();
                mobilizationWaveRoles=mobilizationWaveValues.get(mobPlan.wave__c);
                if(mobilizationWaveRoles!=NULL){
                    if(!mobilizationWaveRoles.isEmpty()){
                        for(String role:mobilizationWaveRoles){
                            if(role.equals(mobPlan.role__c)){
                                mobPlan.addError(UtillContstant_Novasuite.ROLE_EXISTS);
                            }
                        }
                    }    
                }
                
               /* mobilizationLocation=new List<String>();
                mobilizationLocation=mobilizationLocationValues.get(mobPlan.Delivery_Location_Master__c);
                if(mobilizationLocation!=NULL){
                    if(!mobilizationLocation.isEmpty()){
                        for(String role:mobilizationLocation){
                            if(role.equals(mobPlan.role__c)){
                                mobPlan.addError('Role already exists for selected location');
                            }
                        }
                    }    
                }*/
                
            }
            
            
        }catch(Exception e){
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.MOBTEAM , UtilConstants.MOBTEAM , null, System.Logginglevel.ERROR);
        }
    }
    /*
      @Author: Madhusudhan
      @Name: populateDealOnMobilizationTeam
      @Paramaters: List of Mobilization Team records After Trigger
      @Description: Populate the deal Name on Mobilization Team object
    */  
    public static void populateDealOnMobilizationTeam(List<Mobilization_Team__c> mobilizationTeam){
        set<Id> waveId = new set<Id>();
        Map<String,String> waveMap = new MAP<String,String> ();
        try{
        for(Mobilization_Team__c mt : mobilizationTeam){
            if(mt.Wave__c!=null && mt.Deal__c==null){
                waveId.add(mt.Wave__c);
            }
        }
        //system.debug('waveId--'+waveId);
        String dealId;
        for(Wave__c waveList : [select id,Mobilization_Plan__r.Deal__c from Wave__c where id IN: waveId LIMIT 2000]){
             if(waveMap.containsKey(waveList.id)) {
                    dealId = waveMap.get(waveList.id);
                 }
                 else {
                    dealId=UTILConstants.EMPTY_STRING;
                 }
                 dealId=waveList.Mobilization_Plan__r.Deal__c;
                 waveMap.put(waveList.id,dealId);
        }
        for(Mobilization_Team__c mt : mobilizationTeam){
            if(waveMap.containsKey(mt.Wave__c)) {
                dealId = waveMap.get(mt.Wave__c);
                //system.debug('dealId---'+dealId);
                mt.Deal__c=dealId;
            }
        }
       }
       Catch(DMLException e)
       {
          UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,
                        UtilConstants.MOBTEAM , UtilConstants.MOBTEAM , null, System.Logginglevel.ERROR);
       }
    }
    
    /*
     method to Populate the GTL Role in SRAT Tracker
    
   
    public void populateGTLrole(List<Mobilization_Team__c> mobteam){
        List<Mobilization_Plan__c> mobplan=new List<Mobilization_Plan__c>();
        set<Id> dealId =  new set<id>();
        try{
            for(Mobilization_Team__c mobilizationTeam:mobteam){
                if((mobilizationTeam.Role__c).equals('GTl')){
                    dealId.add(mobilizationTeam.Deal__c);
                }
            }
            
            List<Deal__c> dealList = [select id,(select id from Mobilization_Plans__r) where id IN :dealId];
            
            
        }
            
        }*/
        
}