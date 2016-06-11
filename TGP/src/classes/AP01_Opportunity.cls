/**
   @Author : Jayashree Pradhan
   @name   : AP01_Opportunity
   @CreateDate : 12 December 2014 
   @Description : TriggerHandler Class for triggers on Opportunity object
   @Version : 1.0 
  */
public without sharing class AP01_Opportunity{
   
   
   /**
   *  @Description : This method is used to create Opportunity Additional Team record in scope for opportunity
   *  @name : createOppAddTeamRec
   *  @param : List<opportunity> OppNewList
   *  @return parameter - void
   *  @throws exception- DML Exception
   */
    public static void createOppAddTeamRec(List<opportunity> oppNewList){
    
        //system.debug('--userinfo.getProfileId();---'+userinfo.getProfileId());
        UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +'--'+'OppTRGCls AddRoleMasQuery';
        system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue);
        List<Opportunity_Additional_Role_Master__c> oppAddteamList = [SELECT Id, Name, BPO_Role__c, active__c, ShouldBePopulatedFromSAP__c FROM Opportunity_Additional_Role_Master__c
                                                                        where ShouldBePopulatedFromSAP__c = true AND BPO_Role__c = true AND active__c = true LIMIT 5000];
        List<Opportunity_Additional_Team__c> addTeamListToUpdate = new List<Opportunity_Additional_Team__c>();
        for(opportunity oppRec : oppNewList){
            
            for(Opportunity_Additional_Role_Master__c addTeamRec : oppAddteamList ){
                
                //system.debug('--addTeamRec----'+addTeamRec);
                //system.debug('--oppRec.id----'+oppRec.id);
                
                Opportunity_Additional_Team__c obj = new Opportunity_Additional_Team__c();
                obj.Active__c = true;
                obj.Additional_Opportunity_Role__c = addTeamRec.id;
                obj.Opportunity__c = oppRec.id;
                obj.isChecked__c = true;
               //obj.ownerId = '005E0000003z3FW';
                addTeamListToUpdate.add(obj);
            }
        }
        //system.debug('--addTeamListToUpdate----'+addTeamListToUpdate);
        try{
            if(addTeamListToUpdate.size() > 0){
                database.insert(addTeamListToUpdate);
                
            }
        }
        catch(Exception e){
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
        }
    }
    
     /**
   *  @Description : This method is used to create OSL in Opportunity Team record in scope for opportunity
   *  @name : createOppOSLTeamRec
   *  @param : List<opportunity> OppNewList
   *  @return parameter - void
   *  @throws exception- DML Exception
   */
    public static void createOppOSLTeamRec(List<opportunity> oppNewList){
            UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +'--'+'OppTRGCls OSL&UsrMasQuery';
            system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue);
            List<Opportunity_Teams__c> oppTeamList = new List<Opportunity_Teams__c>();
            List<User_Master__c> userIDs = new List<User_Master__c>();
            List<Opportunity_Roles_Master__c> oslIDs = new List<Opportunity_Roles_Master__c>(); 
            Opportunity_Roles_Master__c OSlID;
            User_Master__c userId;          
            oslIDs = [SELECT Id, Name, Role_Level__c, Active__c FROM Opportunity_Roles_Master__c where name =: UtilConstants.OPP_SOL_LEAD limit 1];
            userIDs = [SELECT Id, Name, Active__c, user__c, isSFDCUser__c FROM User_Master__c where user__c=:UserInfo.getUserId() limit 1];
            system.debug('userIDs--'+userIDs);
        
        for(opportunity oppRec : oppNewList){
            
            Opportunity_Teams__c oppTeamObj = new Opportunity_Teams__c();
            
            if(oslIDs.size()>0)
            {
               OSlID  = oslIDs[0];
                oppTeamObj.Role__c = OSlID.id;
            }
            else
            {
            oppTeamObj.Role__c = null;
            }
            if(userIDs.size()>0)
            {
                 userId = userIDs[0];
                oppTeamObj.Opportunity_Team_Member__c = userId.id;
            }
            else
            {
            oppTeamObj.Opportunity_Team_Member__c = null;
            }
            
            
            oppTeamObj.Opportunity__c = oppRec.id;
            
            oppTeamList.add(oppTeamObj);
        }
        
        try{
            if(oppTeamList.size() > 0){
                
                database.insert(oppTeamList);
                
            }
        }
        catch(Exception e){
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
        }
    }
   
   
   
    /**
   *  @Description : This method is used to create capacity record in scope for opportunity
   *  @name : updateCapacityRec
   *  @param : List<opportunity> OppNewList,Map<id,opportunity> OppOldMap
   *  @return parameter - void
   *  @throws exception- DML Exception
   */
    public void updateCapacityRec(List<opportunity> oppNewList,Map<id,opportunity> OppOldMap){
        List <Capacity_Service_Data__c> capList = new List <Capacity_Service_Data__c>();
        List <Capacity_Service_Data__c> capToupdate = new List <Capacity_Service_Data__c>();
        List <Capacity_Service_Data__c> capToInsert = new List <Capacity_Service_Data__c>();
        List <Opportunity> oppWithChild = new List <Opportunity>();
        List <Opportunity> oppWithInactiveCap = new List <Opportunity>();
        List <Opportunity> oppWithActiveCap = new List <Opportunity>();
        UtilConstantsR3.runCapasityTrigger=false;
        for(opportunity opp: oppNewList){
            if ((opp.Capacity_Services_in_Scope__c != OppOldMap.get(opp.Id).Capacity_Services_in_Scope__c) || (opp.name != OppOldMap.get(opp.Id).name)){
                if(!opp.Capacity_Services_in_Scope__c){
                oppWithInactiveCap.add(opp);
                }
            if(opp.Capacity_Services_in_Scope__c){
                oppWithActiveCap.add(opp);
                
            }
            }
        }
        if(oppWithInactiveCap.size() > 0){
            capList  = [Select id,Name from Capacity_Service_Data__c where Opportunity__c IN:oppWithInactiveCap limit 1000];
        }
            if(capList.size()>0){
                for(Capacity_Service_Data__c cap : capList){
                    cap.Active__c = false;
                    capToupdate.add(cap);
                }
                
            try{
                  Database.update( capToupdate );
                }
                catch(DMLException de){
                    ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, de.getMessage() );
                    ApexPages.addMessage(msg);  
                    
                }
            }
            if(oppWithActiveCap.size() > 0){                                                  
                oppWithChild  = [SELECT id,Name,(SELECT id FROM Capacity_Service_Data__r limit 100 ) FROM Opportunity WHERE id IN:oppWithActiveCap limit 1000];
            }    
            if(oppWithChild.size()>0){
            for(Opportunity capObj  : oppWithChild){
                if(capObj.Capacity_Service_Data__r.size() > 0) {
                    for(Capacity_Service_Data__c capRec :capObj.Capacity_Service_Data__r){
                        capRec.Active__c = true;
                        capRec.Name = capObj.Name+Label.Capacity_Services_Name;
                        capToupdate.add(capRec);
                } 
            }
                else{
                    Capacity_Service_Data__c capData = new Capacity_Service_Data__c();
                    capData.Name = capObj.Name+Label.Capacity_Services_Name;
                    capData.Opportunity__c = capObj.id;
                    capToInsert.add(capData);
                }
                
            }
            if(capToupdate.size()>0){
                Database.update( capToupdate );
            }
            else if(capToInsert.size()>0){
                Database.insert( capToInsert );
            }
            else{
            }
            }
          }
    
    
    /**
   *  @Description : This method is used to create Analytics record in scope for opportunity
   *  @name : updateAnalyticsRec
   *  @param : List<opportunity> oppNewList,Map<id,opportunity> OppOldMap
   *  @return parameter - void
   *  @throws exception- DML Exception
   */
    public void updateAnalyticsRec(List<opportunity> oppNewList,Map<id,opportunity> OppOldMap){
        List <Analytics_Datas__c> analyticList = new List <Analytics_Datas__c>();
        List <Analytics_Datas__c> analyticToupdate = new List <Analytics_Datas__c>();
        List <Analytics_Datas__c> analyticToInsert = new List <Analytics_Datas__c>();
        List <Opportunity> oppWithChild = new List <Opportunity>();
        List <Opportunity> oppWithInactiveAnalytic = new List <Opportunity>();
        List <Opportunity> oppWithActiveAnalytic = new List <Opportunity>();
        UtilConstantsR3.runAnalyticTrigger=false;
        
        for(opportunity opp: oppNewList){
            if ((opp.Analytics_in_Scope__c != OppOldMap.get(opp.Id).Analytics_in_Scope__c) || (opp.Name != OppOldMap.get(opp.Id).Name)){
                if(!opp.Analytics_in_Scope__c){
                oppWithInactiveAnalytic.add(opp);
                }
            if(opp.Analytics_in_Scope__c){
                oppWithActiveAnalytic.add(opp);
                
            }
            }
        }
        if(oppWithInactiveAnalytic.size() > 0){
            analyticList  = [Select id,Name from Analytics_Datas__c where Opportunity__c IN:oppWithInactiveAnalytic limit 1000];
        }
            if(!analyticList.isEmpty()){
                for(Analytics_Datas__c analytic : analyticList){
                    analytic.Active__c = false;
                    analyticToupdate.add(analytic);
                }
                
            try{
                  Database.update( analyticToupdate );
                }
                catch(DMLException de){
                    ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, de.getMessage() );
                    ApexPages.addMessage(msg);  
                    
                }
            }
            if(oppWithActiveAnalytic.size() > 0){                                                 
                oppWithChild  = [SELECT id,Name,(SELECT id FROM Analytics_Data__r limit 100) FROM Opportunity WHERE id IN:oppWithActiveAnalytic limit 1000];
            }    
            if( !oppWithChild.isEmpty() ){
            for(Opportunity oppObj  : oppWithChild){
                if(oppObj.Analytics_Data__r.size() > 0) {
                    for(Analytics_Datas__c analyticRec :oppObj.Analytics_Data__r){
                        analyticRec.Active__c = true;
                        analyticRec.Name = oppObj.Name+Label.Analytic_Data_Name;
                        analyticToupdate.add(analyticRec);
                } 
            }
                else{
                    Analytics_Datas__c analyticData = new Analytics_Datas__c();
                    analyticData.Name = oppObj.Name+Label.Analytic_Data_Name;//' - ' +'Analytic Services';
                    analyticData.Opportunity__c = oppObj.id;
                    analyticToInsert.add(analyticData);
                }
                
            }
            if(analyticToupdate.size()>0){
                Database.update( analyticToupdate );
            }
            else if(analyticToInsert.size()>0){
                Database.insert( analyticToInsert );
            }
            else{
            }
            } 
          }
          
     /**
   *  @Description : This method is used to delete the task on user when opporunity status has been changed
   *  @name : closeTaskonSDGovn
   *  @param : List<opportunity> OppNewList,Map<id,opportunity> OppOldMap
   *  @return parameter - void
   **/
    public void closeTaskonSDGovn(List<opportunity> oppNewList,Map<id,opportunity> OppOldMap){
    try{         
         Set<Id> oppids = new Set<Id>();
         Set<Id> ownerIds = new Set<Id>();
         List<String> govIdList=new List<String>();
         List<Task> taskstoupdate = new list<Task>();
         //Fetch only Opportunity which follow criteria
         for(Opportunity opp : oppNewList){
            if((opp.Reporting_Status__c != UtilConstantsforSWB.PIPELINE || opp.Reporting_Status__c != UtilConstantsforSWB.UNQUALIFIED)
            && opp.Reporting_Status__c != OppOldMap.get(opp.Id).Reporting_Status__c) {
                oppids.add(opp.id);
            }
        }
        if(oppids.size()>0){
        for(SD_Governance_Data__c s:[SELECT id, opportunity__c from SD_Governance_Data__c where opportunity__c= :oppids limit 100]){
            ownerIds.add(s.id);
        }     
        UtilTaskComplete.taskCompleteList(ownerIds);
        }
      }
      Catch(Exception e)
      {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
      } 
    }
/**
   *  @name : createSolCompRec
   *  @param : List<opportunity> oppNewList,String origin
   *  @return parameter - void
   **/         
      public static void createSolCompRec(List<opportunity> oppNewList,String origin){
     
          Solution_Scope__c solCompObj;
          List<Solution_Scope__c> solScopeListToUpdate = new List<Solution_Scope__c>();
          Map<String,Services_Master__c> oppLevelOfferingsMap = new Map<String,Services_Master__c>();
          // Following List is queried from Custom Settings
          UtilConstants.DebugTraceValue = UtilConstants.DebugTraceValue +'--'+'OppTRGCls SerMasQuery';
          system.debug('UtilConstants.DebugTraceValue--'+UtilConstants.DebugTraceValue);
          for( Services_Master__c serMaster : [select name,Service_Group__c,Solution_Component__c,offering__c,offering__r.name from Services_Master__c where active__c=:true and Is_Offering_Specific_Service__c=:false and offering__r.name =:UtilConstants.ALL and offering__r.active__c =: true LIMIT 5000] ){
              if( !oppLevelOfferingsMap.containsKey(serMaster.Solution_Component__c+UtilConstants.SPLIT+serMaster.Service_Group__c) ){
                  oppLevelOfferingsMap.put(serMaster.Solution_Component__c+UtilConstants.SPLIT+serMaster.Service_Group__c,serMaster);
              }
          }
          //system.debug('********'+oppLevelOfferingsMap+'::::::::::::::::'+oppNewList);
          //List<Services_Master__c>oppLevelOfferingsMap= [select name,Service_Group__c from Services_Master__c where ];
         // id offMasterID = [Select id,Name from Offering_Master__c where Name =:'ALL' and Active__c =: true limit 1].id;
          for(opportunity opp : oppNewList){
            //  if(opp.BPO_Opportunity__c == true){
                
                  for(String oppLevelOffering : oppLevelOfferingsMap.keySet()){
                      
                      if( (origin == UtilConstants.WOSAP)&&(opp.BPO_Opportunity__c && oppLevelOffering.contains(UtilConstants.BPO))||(opp.IO_Opportunity__c && oppLevelOffering.contains(UtilConstants.IO)) ||(opp.IC_Opportunity__c && oppLevelOffering.contains(UtilConstants.IC))){
                          solCompObj = new Solution_Scope__c();
                          solCompObj.Opportunity__c = opp.id;
                          solCompObj.IsUserAddedOffering__c = false;
                          solCompObj.Solution_Component__c = oppLevelOffering.split(UtilConstants.SPLIT)[0];
                          solCompObj.Offering_Master__c = oppLevelOfferingsMap.get(oppLevelOffering).offering__c;
                          solCompObj.Service_Group__c = oppLevelOfferingsMap.get(oppLevelOffering).Service_Group__c;
                          solScopeListToUpdate.add(solCompObj);
                      }
                      if( (origin != UtilConstants.EMPTY_STRING && origin != UtilConstants.WOSAP)&&(opp.BPO_Opportunity__c && oppLevelOffering.contains(UtilConstants.BPO) && (!origin.contains(UtilConstants.BPO)) )||(opp.IO_Opportunity__c && oppLevelOffering.contains(UtilConstants.IO)&& (!origin.contains(UtilConstants.IO))) ||(opp.IC_Opportunity__c && oppLevelOffering.contains(UtilConstants.IC)&& (!origin.contains(UtilConstants.IC)))){
                          solCompObj = new Solution_Scope__c();
                          solCompObj.Opportunity__c = opp.id;
                          solCompObj.IsUserAddedOffering__c = false;
                          solCompObj.Solution_Component__c = oppLevelOffering.split(UtilConstants.SPLIT)[0];
                          solCompObj.Offering_Master__c = oppLevelOfferingsMap.get(oppLevelOffering).offering__c;
                          solCompObj.Service_Group__c = oppLevelOfferingsMap.get(oppLevelOffering).Service_Group__c;
                          solScopeListToUpdate.add(solCompObj);
                      }
                 
              }
              //}
          }    
          //system.debug('********'+solScopeListToUpdate);
          if(solScopeListToUpdate.size()>0)   {
              //database.insert(solScopeListToUpdate);
              if(origin == UtilConstants.WOSAP){
                   try{
                       UtilConstants.IS_RECURSIVE =TRUE;
                       insert solScopeListToUpdate;
                   }catch(Exception e){
                       String sheetThrowingException = UtilConstants.EMPTY_STRING;
                       sheetThrowingException = e.getMessage() + e.getStackTraceString();
                       if(!Test.isRunningTest()){
                         throw (e);
                       }
                   }
              }else{
                  operationsOnStagingTriggerController.oppOfferingToInsertList.addAll(solScopeListToUpdate);
              }
      
           }
       }     
         /******************************
        Method Name: createCostingRecord
        Description: method called from AP01_Opportunity
        Return Value: void
        *******************************/ 
        public static void createCostingRecord( List<Opportunity> newOpps ){
            List<sync_status__c > syncReqToInsert = new List<sync_status__c >();
            List<Costing_Request__c> costReqToInsert = new List<Costing_Request__c>();
            Costing_Request__c costReq;
            sync_status__c syncstatus;
            for( Opportunity opp : newOpps ){
                costReq = new Costing_Request__c();
                syncstatus = new sync_status__c();
                costReq.Country__c = opp.Country__c;
                costReq.Opportunity__c = opp.Id;
                syncstatus.opportunity__c = opp.id;
                costReqToInsert.add(costReq);
                syncReqToInsert.add(syncstatus);
            }
            if( costReqToInsert.size() > 0 && syncReqToInsert.size() > 0 ){
                try{  
                    database.insert(costReqToInsert,true);
                    database.insert(syncReqToInsert,true);
                }catch(Exception E){
                    
                }
            }
        }
        
     /**
   *  @Description : This method is used to generate the auto mail to DMAT user if opportunity Stage and net revenue fields are changed
   *  @name : emailToDMATuser
   *  @param : List<opportunity> OppNewList,Map<id,opportunity> OppOldMap
   *  @return parameter - void
   **/
  public void emailToDMATuser(List<opportunity> oppNewList,Map<id,opportunity> OppOldMap){
    //system.debug('-- 415 emailToDMATuser');
   //  system.debug('-- 416 OppOldMap:'+OppOldMap);
     // system.debug('-- 417 oppNewList:'+oppNewList);

     try{         
         Set<Id> oppids = new Set<Id>();
         Set<Id> ownerIds = new Set<Id>();
         List<Opportunity_Teams__c> oppTeamList=new List<Opportunity_Teams__c>();
         List<Opportunity> oppRecord=new list<Opportunity>();
         Map<id,list<String>> oppMap=new Map<id,list<string>>();
         //public List<String> usrEmail{get;set;}
         string [] toaddress;
         //Fetch only Opportunity which follow criteria
         for(Opportunity opp : oppNewList){
            if((opp.BPO_Net_Rev_Thousands__c != OppOldMap.get(opp.Id).BPO_Net_Rev_Thousands__c || opp.StageName != OppOldMap.get(opp.Id).StageName)) {
                oppids.add(opp.id);
                oppRecord.add(opp);
            }
        }
        
         //system.debug('-- 435 oppids:'+oppids);
        //system.debug('-- 436 oppRecord:'+oppRecord);
      
        //list<string> emailList=new list<String>();
        //usrEmail=new List<String>();
        list<String> oppTeamemail;
        if(oppids.size()>0){
            for(Opportunity_Teams__c oppTeam:[SELECT id,Opportunity_Team_Member__r.Profile__c,Opportunity_Team_Member__r.email__c,opportunity__c from Opportunity_Teams__c where opportunity__c in :oppids and Opportunity_Team_Member__r.Profile__c='DMAT User' limit 100]){
                 if(oppMap.containsKey(oppTeam.opportunity__c)) {
                          oppTeamemail=oppMap.get(oppTeam.opportunity__c);
                     }
                     else {
                       oppTeamemail=new list<String>();
                     }  
                oppTeamemail.add(oppTeam.Opportunity_Team_Member__r.email__c); 
                oppMap.put(oppTeam.opportunity__c,oppTeamemail);
            }     
        }  
        
        //system.debug('oppTeamemail 454:'+oppTeamemail);
        //system.debug('oppTeamemail 455'+oppTeamemail);
                 
        Rest_URL__c rs = Rest_URL__c.getOrgDefaults();
        String InstanceURL = rs.Base_URL__c; 
        if(oppMap.values().size()>0){
            list<Messaging.SingleEmailMessage> emaillist = new list<Messaging.SingleEmailMessage>();
            for(Opportunity opp : [select SAP_OM_Item_Id__r.name,name, Account.name,Opportunity_Solution_Lead__r.name,StageName,BPO_Net_Rev_Thousands__c from Opportunity where id in :oppids]){               
                    if(oppMap.get(opp.id)!=null){
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        toaddress=oppMap.get(opp.id);
                        email.setToAddresses(toaddress);
                        String orgWideEmailAddressID=UtilEmail.emailid();
                        email.setOrgWideEmailAddressId(orgWideEmailAddressID);
                        email.setSubject('Opportunity '+opp.name+' change notification');
                        string htmlBody = '<html>'+
                        '<head>'+
                        '<style>'+
                        'h4 {color:red;}'+
                        'TH {font-size: 11px; font-face: arial;background: #CCCCCC; border-width: 1 }'+
                        'td  {width:200px; height:70px bgcolor:#C0C0C0;} '+
                        'TR {border: solid #CCCCCC; border-width: 1}'+
                        '</style>'+
                        '</head>'+
                        '<body>'+
                        'This is to notify that the following opportunity has been changed<br/>'+
                        '<br></br>'+
                        '<table rules="rows" border="1" cellpadding="5">'+
                        '<tr>'+
                         '<td>MMS ID</td>'+
                          '<td>'+opp.SAP_OM_Item_Id__r.name+'</td>'+
                         '</tr> '+
                         '<tr>'+
                          '<td>Opportunity Name</td>'+
                          '<td>'+opp.name+'</td>'+
                         '</tr><tr><td>Client</td><td>'+opp.Account.name+'</td></tr> <tr>'+
                          '<td>Lead Solution Architect - BPO</td><td>'+opp.Opportunity_Solution_Lead__r.name+'</td></tr>'+
                         '<tr><td>Stage</td><td> Previous Value – '+OppOldMap.get(opp.id).StageName+'<br/>Current Value  – '+opp.StageName+'</td></tr>'+
                         '<tr><td>BPO Net Revenue</td><td>Previous Value – '+OppOldMap.get(opp.id).BPO_Net_Rev_Thousands__c+'<br/>Current Value  – '+ opp.BPO_Net_Rev_Thousands__c+'</td></tr></table><br />'+
                        '<a href="'+InstanceURL +'/'+opp.id+'">Login to Operations Solution Workbench</a>(option for those who have a workbench license)<br/>'+
                        'This is a system generated message.Please do not reply to this message</body></html>';
                        email.setHtmlBody(htmlBody);
                        emaillist.add(email);                       
                    }   
            }  
            //system.debug('-*- line: 487 emaillist :'+emaillist);
            Messaging.sendEmail(emaillist);
           // system.debug('-*- line: 487 emaillist :'+emaillist);
         }
        }
          Catch(Exception e) {
          system.debug('-*- 505 exception:');
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
          }
     }


        /**
   *  @Description : This method is used to generate the auto mail to Watchers  user when BPO Tech Arch Assigned gets populated for the first time
   *  @name : emailToDMATuser
   *  @param : List<opportunity> OppNewList,Map<id,opportunity> OppOldMap
   *  @return parameter - void
   **/
     public static void emailToWatchers(List<opportunity> oppNewList,List<opportunity> OppOldMap){
         map<id,string> oldtechArchMap=new map<id,string>();
         set<id> opportunityids=new set<id>();
         for(opportunity oldopp:OppOldMap){
                oldtechArchMap.put(oldopp.id,oldopp.Assigned_BPO_tech_Arch__c);
         }
         for(opportunity newopp:oppNewList){
             if(oldtechArchMap.get(newopp.id)==null && newopp.Assigned_BPO_tech_Arch__c!=null){
                 opportunityids.add(newopp.id);
             }
         }
         
         if(!opportunityids.isEmpty()){
             List<Watcher__c> watcherList=[Select id,Watcher_Master__c,Watcher_Master__r.name,Opportunity__c,Watcher_Name_Dev__c from Watcher__c  
                                            where opportunity__c in :opportunityids limit 50000];
             try{
                 WatchersOperations.sendMailToAddedWatcher(watcherList);
              }
              catch(Exception e){
                  throw e;
              }
         }
     }
     Public static void emailOppStageChange(Map<id,Opportunity> oldMapValue,List<Opportunity> newListValue){
             List<string> userEmail= new List<string>();
             List<Id> userIDs = new List<Id>();
             Email_Template__c myCS1;
             Id targetObjectID=null;
             List<Messaging.SingleEmailMessage> mailtosend=new List<Messaging.SingleEmailMessage>();
             for(GroupMember gm:[SELECT Id, UserOrGroupId, GroupId FROM GroupMember WHERE GroupId='00G56000000UEbA']){
                        userIds.add(gm.UserOrGroupId);
             }                           
             for(User us:[SELECT id,Email From User WHERE Id IN:userIds]){
                  if(targetObjectID==null){
                    system.debug('targetObjectID---------->'+us.id);
                    targetObjectID=us.id;
                  }
                  else{
                    userEmail.add(us.Email); 
                    system.debug('serEmail1--'+userEmail);
                  }            
             }             
            // String tempId = [SELECT Id FROM EmailTemplate WHERE DeveloperName='MobTeamOppStatusChange1' LIMIT 1].id;
             myCS1= Email_Template__c.getValues('MobTeamOppStatusChange1'); 
             String tempId = myCS1.ID__c;      
             for(opportunity oppCheck:[SELECT Id, StageName, Name,(SELECT id,Opportunity_Team_Member__c,Opportunity_Team_Member__r.User__r.Email,Opportunity_Team_Member__r.User__r.Id, Role__r.Name from Opportunity_Team__r where Role__r.Name='Mobilization Architect') FROM Opportunity where id IN: newListValue]){
               if((oldMapValue.get(oppCheck.Id).StageName == '1' && oppCheck.StageName == '2A') || (oldMapValue.get(oppCheck.Id).StageName == '2A' && oppCheck.StageName == '2B') || (oldMapValue.get(oppCheck.Id).StageName == '2B' && oppCheck.StageName == '3A') || (oldMapValue.get(oppCheck.Id).StageName == '3A' && oppCheck.StageName == '3B')){                                                        
                    if(oppCheck.Opportunity_Team__r != null){
                        for (Opportunity_Teams__c oppTeam:oppCheck.Opportunity_Team__r){
                             if(oppTeam.Opportunity_Team_Member__r.User__r.Email !=null){
                                 userEmail.add(oppTeam.Opportunity_Team_Member__r.User__r.Email);    
                                 system.debug('serEmail--'+userEmail);                                                     
                             }
                         }
                    }
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                                                        
                    mail.setTargetObjectId(userIDs[0]) ;                   
                    mail.setTemplateId(tempId);                                
                    mail.setToAddresses(userEmail);          
                    mail.saveAsActivity=false;
                    mail.setWhatId(oppCheck.id);
                    mailtosend.add(mail);
                  //  Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail}); 
                 }
              }  
              Messaging.sendEmail(mailtosend);                       
     }
   }