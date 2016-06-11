/**
   @Author         : Komal Priya
   @name           : operationOnOppTeamTriggerController
   @CreateDate     : 22 December 2014
   @Description    : TriggerHandler Class for triggers Opportunity Team object
   @Version        : 1.0
  */
  /** Change History
  S.No                  Developer                       Version                             Date
  1                    Jayashree Pradhan                 1.1                                21 January,2015
  */
  /***********
  Change History
  S.No          Developer           version         Date            Method added
  
  1             Ezdhan Hussain      1.2             04 Feb 2015     restrictFromDuplicates 
  2             Ezdhan Hussain      1.3             19 Mar 2015     None
  3             Apoorva Sharma                      19 Nov 2015     updateOnTechArchLeadRole   
  ************/
global without sharing class operationOnOppTeamTriggerController{
    public static String SEPERATOR = UtilConstants.SEMICOLON_STRING ;
    public static String SEPERATOR_withspace = UtilConstants.SEMICOLON_STRING_WHITESPACE;
    public static final String OPERATIONONOPPTEAMTRIGGERCONTROLLER = 'operationOnOppTeamTriggerController';
    public static final String SENDANDUPDATEASSIGNEE = 'sendAndUpdateAssignee';
    public static final String OPERATIONONOPPTEAMTRIGGER = 'operationOnOppTeamTrigger';
    public static final String SENDMAILTOPMO = 'sendMailToPMO';
    public static final String EMAILFORCANCELLEDREQ = 'emailForCancelledReq';
    public static final String EMAILFORONHOLDORNOTFILLEDREQ = 'emailForOnHoldOrNotfilledReq';
    public static final String UPDATEGOVDATAREQ = 'updateGovDataReq';
    public static final String UPDATEOPPTEAMAFTERRECALL = 'updateOppTeamAfterRecall';
    public static final String UPDATEOPPTEAMAFTERPMOUPDATE = 'updateOppTeamAfterPMOUpdate';
    public static Map<id,User_Master__c> TeamUserID = new Map<id,User_Master__c>();
        public static final string updateAfterRouting='updateAfterRouting';
    public static final String EMAILFORPENDINGREQUEST = 'emailForPendingRqst';
   /**
   *  @Description : This method is used to create user master MAP.
   *  @name : getuserMasterMap
   *  @param : null
   *  @return parameter - void
   *  @throws exception- null
   */  
    public static void getuserMasterMap(){
    
               // TeamUserID = new Map<id,User_Master__c>();
                for(User_Master__c u:[Select id, user__r.id,user__r.EMAIL from User_Master__c LIMIT 50000]){
                    TeamUserID.put(u.id,u); 
                }
                
    }
    
      /** Added By Ruchita        
    *@Description:This method is used to populate the offerings only for the role with 'supporting tech architect'      
    *  @name : populateSolutionScope        
    *  @param : List<Opportunity_Teams__c> listOppTeam      
    *  @return parameter - void     
    */      
    public static void populateSolutionScope(List<Opportunity_Teams__c> listOppTeam){       
    system.debug('helloooooooooooooo');     
    set<id> opp_ids=new set<id>();      
    map<id,string> solscopename=new map<id,string>();       
    for(Opportunity_Teams__c oppIds:listOppTeam)        
    {       
    opp_ids.add(oppIds.Opportunity__c);     
    }       
    system.debug('opp_ids'+opp_ids);        
     solscopename=MasterQueries.solscopepopulated(opp_ids);     
     system.debug('helloooooooooooooo'+solscopename);       
    for(Opportunity_Teams__c oppteam:listOppTeam){      
    oppteam.Offering_Dev__c=solscopename.get(oppteam.Opportunity__c);       
    }       
    }       
            
    /** Added by Ruchita        
    *@Description:This Method is used to allow only techleads to add supporting tech resources.     
    *@name:addSupportingTech        
    *@param:list<Opportunity_Teams__c> opportunityList      
    *@return Parameter: void        
    */      
    public static void addSupportingTech(list<Opportunity_Teams__c> opportunityList){       
        set<id> opportunityIds =new set<id>();      
        for(Opportunity_Teams__c opp:opportunityList){      
            opportunityIds.add(opp.Opportunity__c);     
        }       
                
        list<Opportunity_Teams__c> oppTeamRec=[Select id,Opportunity_Role_Dev__c,Opportunity_Team_Member__r.user__c,Opportunity__c from Opportunity_Teams__c where      
                                                Opportunity_Role_Dev__c=:UtilConstantsR3.Tech_Arch and Opportunity__c in :opportunityIds and       
                                                Opportunity_Team_Member__r.user__c=:userinfo.getUserid() LIMIT 5000];      
         for(Opportunity_Teams__c teamRec:opportunityList){                                             
        if(oppTeamRec.isEmpty() && teamRec.Opportunity_Role_Dev__c.equalsIgnoreCase(UtilConstantsforSWB.Supporting_Tech_Architect)){        
              for(Opportunity_Teams__c oppRec:opportunityList){     
               oppRec.addError(UtilConstantsforSWB.ERROR_MSG_SupportingTech);       
              }     
        }       
         }      
                
                
     }      
            
     /** Added by Ruchita       
    *@Description:This Method is used to allow only PMO/route to member to add tech arch lead resources.        
    *@name:addTechArchLead      
    *@param:list<Opportunity_Teams__c> opportunityList      
    *@return Parameter: void        
    */      
    /* public static void addTechArchLead(list<Opportunity_Teams__c> opportunityList){      
     set<id> opportunityIds =new set<id>();     
                
        for(Opportunity_Teams__c opp:opportunityList){      
            opportunityIds.add(opp.Opportunity__c);     
        }       
        list<Opportunity_Teams__c> oppTeamRec=[select id,Opportunity__c from Opportunity_Teams__c where  Opportunity__c in :opportunityIds and      
        Route_To__r.User_Master__r.User__c=:userinfo.getUserid()  ];        
        for(Opportunity_Teams__c teamRec:opportunityList){      
        if(oppTeamRec.isEmpty()){       
        for(Opportunity_Teams__c oppRec:opportunityList){       
        oppRec.addError(UtilConstantsforSWB.ERROR_MSG_TechArchLead);        
        }       
        }       
        }       
    /**
   *  @Description : This method is used restrict duplicate entries of roles.
   *  @name : restrictFromDuplicates
   *  @param : List<Opportunity_Teams__c> oppteamnewlist
   *  @return parameter - void
   *  @throws exception- DML Exception
   */  
    public void restrictFromDuplicates(List<Opportunity_Teams__c> oppteamnewlist){
    
    try{
        set<string> roles = new set<string>();
        set<id> opp_ids = new set<id>();
        map<id,string> maptochecknewvalues = new map<id,string>();
        map<id,string> maptostoreoldvalues = new map<id,string>();
        for(Opportunity_Teams__c opp : oppteamnewlist){
            opp_ids.add(opp.Opportunity__c);
        }
        
        for(Opportunity_Teams__c opp : [select id,role__c from Opportunity_Teams__c where Opportunity__c IN:opp_ids AND id NOT IN: oppteamnewlist limit 5000]){
            maptostoreoldvalues.put(opp.role__c,opp.id);    
        }
        roles.add(label.SD_Governance_Lead_Coach);
        roles.add(Label.Commercial_Team);
        roles.add(Label.Prime_SDO_Lead);
        roles.add(UtilConstants.DELIVERY_LEAD);
        roles.add(UtilConstants.DELIVERY_LEADIC);
        roles.add(Label.Opportunity_Solution_Lead);
        roles.add(Label.Lead_Solution_Architect_IO);
        roles.add(Label.Lead_Solution_Architect_IC);
        
         
        for(Opportunity_Roles_Master__c oppmaster : [select id,name from Opportunity_Roles_Master__c where Name IN:roles LIMIT 5000]){
            maptochecknewvalues.put(oppmaster.id,oppmaster.name);
        }
                    //////System.debug('old Map to check::::::::::: '+maptostoreoldvalues);
            //////System.debug('New Map to check::::::::::: '+maptochecknewvalues);
        for(Opportunity_Teams__c oppteam : oppteamnewlist){
                    //////System.debug('old map contains :::::::::::: '+maptostoreoldvalues.containskey(oppteam.role__c));
            if(maptostoreoldvalues.containskey(oppteam.role__c) && maptochecknewvalues.containskey(oppteam.role__c)){
                oppteam.role__c.addError(UTILConstants.ROLE_AL_EXST);
            }
        }
        
       }
       Catch(Exception e)
       {
          System.debug('E==='+e); 
           string s=e.getMessage();
       }
    }
    /**
   @Author         : Komal Priya
   @name           : updateAccessOnOppAndSolCompForAssignee
   @Description    : This method is used to update opportunity record based on diffrent roles and send mail to to assignee.
   @Version        : 1.0
  */
    public static void updateAccessOnOppAndSolCompForAssignee(List<Opportunity_Teams__c> oppTeamNewList){

    try{
    
        //List<Opportunity_Teams__c> oppTeamToGiveEditAccess = new List<Opportunity_Teams__c>();
        List<Opportunity_Teams__c> oppTeamIdAfterPMOUpdate = new List<Opportunity_Teams__c>();
        //List<Solution_Scope__c> solCompListtoUpdate = new List<Solution_Scope__c>();
        set<Id> oppTeamIds = new set<Id>();
        List<Opportunity_Teams__c> oppTeamIdsToPMO = new List<Opportunity_Teams__c>();
        List<Opportunity_Teams__c> oppTeamIdsToAssign = new List<Opportunity_Teams__c>();
        List<Opportunity_Teams__c> IOoppTeamIdsToAssign = new List<Opportunity_Teams__c>();
        List<Opportunity_Teams__c> oppteamAfterRouteUpdate = new List<Opportunity_Teams__c>();
        string idprefix =UtilConstants.EMPTY_STRING;
        for(Opportunity_Teams__c oppteamList : oppTeamNewList){

                oppTeamIds.add(oppteamList.id);
                
        }                            
        
        for(Opportunity_Teams__c oppTeamRec : [SELECT Id, Name,opportunity__r.Service_Grp__c,Opportunity__r.Com_Lead_Assigned__c,Opportunity_Team_Member__r.isSFDCUser__c,Role__r.CanBeAssignedByPMO__c,OwnerId,Opportunity_Team_Member__r.user__r.IsActive, Opportunity_Team_Member__r.user__r.id,
                                                Team_Member_Request_Status__c,Requestor__r.isSFDCUser__c,Opportunity__r.Opportunity_Solution_Lead__r.isSFDCUser__c,Request_Team_Member__c,Requestor__r.user__c,Requestor__c,Opportunity__c,Opportunity__r.Name,
                                                Requestor__r.user__r.Email,Opportunity__r.ownerId,Role__r.HaveEditAccessOnOpportunity__c,Opportunity_Team_Member__r.name,Route_To__r.User_Master__r.User__c,
                                                Opportunity__r.Opportunity_Solution_Lead__c, Offering__c,Offering__r.Offering_Solution_Lead_Primary__c, opportunity__r.Capability_Lead_Name_s__c, opportunity__r.Industry_Lead_Name_s__c, opportunity__r.Offering_Lead_Name_s__c,
                                                Offering__r.Offering_Solution_Lead_Secondary__c,Opportunity__r.SD_Governance_Lead_Assigned__c, Role__r.name,Role__r.ShouldReceiveAlertMail__c,Role__r.IC_Role__c,Role__r.BPO_Role__c,Role__r.IO_Role__c,
                                                Opportunity_Team_Member__r.user__c,Opportunity_Team_Member__r.user__r.Email ,Last_Routed_User__c,Opportunity__r.Assigned_BPO_tech_Arch__c
                                                FROM Opportunity_Teams__c where id IN : oppTeamIds Limit 5000]){
            
            string ids = oppTeamRec.ownerId;
            idprefix = ids.substring(0,3);
            
            if(oppTeamRec.Request_Team_Member__c==true && idprefix.equals(UtilConstants.OOFIVE)&& oppTeamRec.Last_Routed_User__c==null)
            {
                   System.debug('----oppTeamRec.Request_Team_Member__c---'+oppTeamRec.Request_Team_Member__c);
                    
                    oppTeamIdsToPMO.add(oppTeamRec);
            }
            else if(oppTeamRec.Request_Team_Member__c==true && idprefix.equals(UtilConstants.OOG))
            {
                    oppTeamIdAfterPMOUpdate.add(oppTeamRec);
            }
            else if(oppTeamRec.Request_Team_Member__c==true && oppTeamRec.Last_Routed_User__c!=null && oppTeamRec.Role__r.name.equals(Label.Technical_Architect)){
                system.debug('In route to if------------------------'+oppTeamRec.Team_Member_Request_Status__c);
                oppteamAfterRouteUpdate.add(oppTeamRec);
            }
            else if(oppTeamRec.Request_Team_Member__c==false && oppTeamRec.Opportunity_Team_Member__c != null)
            {
                    //oppTeamIdsToAssign.add(oppTeamRec);
                    //if(oppTeamRec.Role__r.BPO_Role__c){
                        oppTeamIdsToAssign.add(oppTeamRec);
                    //}
            }
           /* else if(oppTeamRec.opportunity__r.Service_Grp__c.equals(UtilConstants.IO)|| oppTeamRec.opportunity__r.Service_Grp__c.equals(UtilConstants.IC))
            {
                    IOoppTeamIdsToAssign.add(oppTeamRec);
                    //////System.debug('------in Feb18IOsendAndUpdateAssignee--------'+IOoppTeamIdsToAssign);
            }*/
            else{
            }
        }
        if(oppTeamIdsToAssign.size()>0)
        {
                        System.debug('------in sendAndUpdateAssignee--------'+oppTeamIdsToAssign);
                        sendAndUpdateAssignee(oppTeamIdsToAssign); 
                        
        }
        if(!oppteamAfterRouteUpdate.isEmpty()){
            System.debug('------oppteamAfterRouteUpdate--------'+oppTeamIdsToPMO);
             updateAfterRouting(oppteamAfterRouteUpdate);
        }
        /*if(IOoppTeamIdsToAssign.size()>0)
        {
                IOsendAndUpdateAssignee(IOoppTeamIdsToAssign); 
        
        }*/
        if(oppTeamIdsToPMO.size()>0)
        {
            System.debug('------in oppTeamIdsToPMO--------'+oppTeamIdsToPMO);
                        sendMailToPMO(oppTeamIdsToPMO);
        }
        if(oppTeamIdAfterPMOUpdate.size()>0)
        {
                        updateOppTeamAfterPMOUpdate(oppTeamIdAfterPMOUpdate);
        }
                                
      }
      Catch(Exception e)
      
      {
                 System.debug('E==='+e); 
                string s=e.getMessage();
      }                 
    } 
    
    
    /**
   *  @Description : This method is used send mail to BPO assignee
   *  @name : sendMailToAssignee
   *  @param : List<Opportunity_Teams__c> oppTeamOldList
   *  @return parameter - void
   *  @throws exception- DML Exception
   */   
     public static void sendMailToAssignee(List<Opportunity_Teams__c> oppTeamOldList){
     
     try{
                
            /*Map<id,User_Master__c> TeamUserID = new Map<id,User_Master__c>();
            for(User_Master__c u:[Select id, user__r.id,user__r.EMAIL from User_Master__c LIMIT 5000]){
                TeamUserID.put(u.id,u); 
            }*/
            system.debug('send mail To assiggneeee----'+oppTeamOldList+'------------------------------------------>'+oppTeamOldList.size());   
            List<String> lstOfUserEmailId = new List<String>();
            List<String> ccAddress;
            String orgWideEmailAddressID=UtilEmail.emailid();
            system.debug('lstOfUserEmailId list------------======='+TeamUserID.size());
            for(Opportunity_Teams__c oppTeamRec : oppTeamOldList){               
                            //lstOfUserEmailId.add(UtilUser.UtilUser(oppTeamRec.Opportunity_Team_Member__c));
                            system.debug('lstOfUserEmailId list------------======='+TeamUserID.get(oppTeamRec.Opportunity_Team_Member__c));
                            lstOfUserEmailId.add(TeamUserID.get(oppTeamRec.Opportunity_Team_Member__c).user__r.id);
                            system.debug('lstOfUserEmailId list------------======='+lstOfUserEmailId);
            }
            Messaging.SingleEmailMessage mail;
            for(Opportunity_Teams__c oppTeamRec : oppTeamOldList){
                system.debug('oppTeamRec list------------======='+oppTeamRec);
                    if(oppTeamRec.Role__r.ShouldReceiveAlertMail__c == true){
                            system.debug('====================>> i am coming Here in If line 290'+ (!oppTeamRec.Role__r.Name.equalsIgnoreCase(UtilConstants.TECHNICAL_ARCHITECT) && !oppTeamRec.Role__r.Name.equalsIgnoreCase(UtilConstantsR3.Tech_Arch_Lead) && !oppTeamRec.Role__r.Name.equalsIgnoreCase( UtilConstantsforSWB.Supporting_Tech_Architect) ));
                            if(!oppTeamRec.Role__r.Name.equalsIgnoreCase(UtilConstants.TECHNICAL_ARCHITECT) && !oppTeamRec.Role__r.Name.equalsIgnoreCase(UtilConstantsR3.Tech_Arch_Lead) && !oppTeamRec.Role__r.Name.equalsIgnoreCase( UtilConstantsforSWB.Supporting_Tech_Architect))                                 //if(oppTeamRec.Role__r.Name != UtilConstants.TECHNICAL_ARCHITECT)
                            {
                                system.debug('====================>> i am satisfying IF Part line 294');
                                Email_Template__c myCS = Email_Template__c.getValues(UtilConstants.BPO_USER);
                                String myCCVal = myCS.ID__c;

                                lstOfUserEmailId.add(oppTeamRec.Opportunity_Team_Member__r.user__r.Email);
                                mail = new Messaging.SingleEmailMessage();
                                mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                                mail.setWhatId(oppTeamRec.id) ;
                                // mail.setTargetObjectId(UtilUser.UtilUser(oppTeamRec.Opportunity_Team_Member__c)) ;
                                system.debug('====================>> i am inLine 308' +TeamUserID.get(oppTeamRec.Opportunity_Team_Member__c).user__r.id);
                                mail.setTargetObjectId(TeamUserID.get(oppTeamRec.Opportunity_Team_Member__c).user__r.id) ;
                                //mail.setTemplateId('00Xc0000000MaAG');
                                mail.setTemplateId(myCCVal);
                                mail.saveAsActivity=false;     
                                if(oppTeamRec.Requestor__c != null){
                                ccAddress = New List<String>();
                                ccAddress.add(TeamUserID.get(oppTeamRec.Requestor__c).user__r.Email);

                                mail.setCCAddresses(ccAddress);
                                }                  
                                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                            }
                            else if(oppTeamRec.Role__r.Name.equalsIgnoreCase(UtilConstantsforSWB.Supporting_Tech_Architect)){
                                system.debug('at line 320');
                                 Email_Template__c myCS = Email_Template__c.getValues(UtilConstantsR3.SuppArch);
                                String myCCVal = myCS.ID__c;

                                lstOfUserEmailId.add(oppTeamRec.Opportunity_Team_Member__r.user__r.Email);
                                mail = new Messaging.SingleEmailMessage();
                                mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                                mail.setWhatId(oppTeamRec.id) ;
                                // mail.setTargetObjectId(UtilUser.UtilUser(oppTeamRec.Opportunity_Team_Member__c)) ;
                                mail.setTargetObjectId(TeamUserID.get(oppTeamRec.Opportunity_Team_Member__c).user__r.id) ;
                                //mail.setTemplateId('00Xc0000000MaAG');
                                mail.setTemplateId(myCCVal);
                                mail.saveAsActivity=false;     
                                if(oppTeamRec.Requestor__c != null){
                                ccAddress = New List<String>();
                                ccAddress.add(TeamUserID.get(oppTeamRec.Requestor__c).user__r.Email);

                                mail.setCCAddresses(ccAddress);
                                }                  
                                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                                
                            }
                            else if(oppTeamRec.Role__r.Name.equalsIgnoreCase(UtilConstantsR3.Tech_Arch_Lead) && oppTeamRec.IsChangesMember__c==true){
                            system.debug('At line 343');
                             Email_Template__c myCS = Email_Template__c.getValues(UtilConstantsR3.LeadArch);
                                String myCCVal = myCS.ID__c;

                                lstOfUserEmailId.add(oppTeamRec.Opportunity_Team_Member__r.user__r.Email);
                                mail = new Messaging.SingleEmailMessage();
                                mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                                mail.setWhatId(oppTeamRec.id) ;
                                // mail.setTargetObjectId(UtilUser.UtilUser(oppTeamRec.Opportunity_Team_Member__c)) ;
                                mail.setTargetObjectId(TeamUserID.get(oppTeamRec.Opportunity_Team_Member__c).user__r.id) ;
                                //mail.setTemplateId('00Xc0000000MaAG');
                                mail.setTemplateId(myCCVal);
                                mail.saveAsActivity=false;     
                                if(oppTeamRec.Requestor__c != null){
                                ccAddress = New List<String>();
                                ccAddress.add(TeamUserID.get(oppTeamRec.Requestor__c).user__r.Email);

                                mail.setCCAddresses(ccAddress);
                                }                  
                                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                            }
                           
                            else
                            {
                                system.debug('====================>> i am coming Here in else part');
                                Email_Template__c myCS = Email_Template__c.getValues(UtilConstants.BPO_USER_TECH_ARCH);
                                String myCCVal = myCS.ID__c;

                                lstOfUserEmailId.add(oppTeamRec.Opportunity_Team_Member__r.user__r.Email);
                                mail = new Messaging.SingleEmailMessage();
                                mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                                mail.setWhatId(oppTeamRec.id) ;
                                
                                mail.setTargetObjectId(TeamUserID.get(oppTeamRec.Opportunity_Team_Member__c).user__r.id) ;
                                
                                mail.setTemplateId(myCCVal);
                                mail.saveAsActivity=false;     
                                if(oppTeamRec.Requestor__c != null){
                                ccAddress = New List<String>();
                                ccAddress.add(TeamUserID.get(oppTeamRec.Requestor__c).user__r.Email);
                                if(oppTeamRec.Last_Routed_User__c !=null){  
                                             //mail.setCCAddresses(ccAddress);
                                             //if(TeamUserID.get(oppTeamRec.Route_To__r.User_Master__c) != null)
                                                ccAddress.add(TeamUserID.get(oppTeamRec.Route_To__r.User_Master__c).User__r.id);       
                                    }       
                                                
                                         List<User> UsrtechList = getEmailIds(Label.Technical_Architect_PMO_Group);     
                                         List<User> UsrList = [SELECT id,name,Email FROM User WHERE id IN: UsrtechList LIMIT 5000];        
                                         List<String> EmailList = new List<String>();           
                                                for(User u :UsrList){       
                                                            
                                                    EmailList.add(u.Email);     
                                                }       
                                                        
                                                //ccAddress.addAll(EmailList);        
                                         System.debug('EmailList=============================>> '+ccAddress); 
                                mail.setCCAddresses(ccAddress);
                                }                  
                                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                            }
                    }
            }
                
        }
         Catch(Exception e)
         
         {
            System.debug('E==='+e); 
            string s=e.getMessage();
         }
                
                
    }
                     //Added by Anusuya
                     /* public static void IOsendAndUpdateAssignee(List<Opportunity_Teams__c> oppTeamIdsToAssign)
                      {
                                                        
                      try{
                               List<opportunity> oppListToUpdate = new List<opportunity>();
                               List<Id> Ids = new List<Id>();
                                List<Opportunity_Teams__c> oppTeamToUpdate = new List<Opportunity_Teams__c>();
                               //////System.debug('Jan 30');
                               for(Opportunity_Teams__c oppTeamrec :  oppTeamIdsToAssign){
                                            Ids.add(oppTeamrec.opportunity__c);
                                        }
                               for(Opportunity_Teams__c oppTeamRec: oppTeamIdsToAssign)
                                { 
                                          //////System.debug('------in Feb20testIOsendAndUpdateAssignee--------'+oppTeamIdsToAssign);
                                         if(oppTeamRec.Role__r.name.Equals(label.Lead_Solution_Architect_IO))
                                                                {
                                                                                oppTeamRec.Opportunity__r.IO_Solution_Architect__c =  oppTeamRec.Opportunity_Team_Member__c;
                                                                                
                                                                                oppListToUpdate.add(oppTeamRec.Opportunity__r);
                                                                                 
                                                                                
                                                                }   
                                         if(oppTeamRec.Role__r.name.Equals(label.Lead_Solution_Architect_IC))
                                                                {
                                                                                oppTeamRec.Opportunity__r.IC_Solution_Architect__c =  oppTeamRec.Opportunity_Team_Member__c;
                                                                                
                                                                                oppListToUpdate.add(oppTeamRec.Opportunity__r);
                                                                                //////System.debug('------in Feb20testIOsendAndUpdateAssignee--------'+oppTeamIdsToAssign);
                                                                                
                                                                }   
                                                                oppTeamRec.Assigned_Date__c = system.today();
                                                                oppTeamToUpdate.add(oppTeamRec); 
                                }
                                update oppListToUpdate;
                                update oppTeamToUpdate;
                               if (oppTeamIdsToAssign.size() > 0)
                                {
                                   IOsendMailToAssignee(oppTeamIdsToAssign);
                                }
                        }
                        Catch(Exception e)
                        {
                        
                           //////System.debug('E==='+e);
                        
                        }
                      
                      }*/
      /**
   *  @Description : This method is used send mail to IO/IC assignee
   *  @name : IOsendMailToAssignee
   *  @param : List<Opportunity_Teams__c> oppTeamOldList
   *  @return parameter - void
   *  @throws exception- DML Exception
   */
      public static void IOsendMailToAssignee(List<Opportunity_Teams__c> oppTeamOldList){
                      
       try{
                List<String> lstOfUserEmailId = new List<String>();
                String orgWideEmailAddressID=UtilEmail.emailid();
                for(Opportunity_Teams__c oppTeamRec : oppTeamOldList)
                {
                      lstOfUserEmailId.add(UtilUser.UtilUser(oppTeamRec.Opportunity_Team_Member__c));
                }
                Messaging.SingleEmailMessage mail;
                Email_Template__c IOmyCS;
                for(Opportunity_Teams__c oppTeamRec : oppTeamOldList)
                {
                     if(oppTeamRec.Role__r.ShouldReceiveAlertMail__c == true)
                     {
                          mail = new Messaging.SingleEmailMessage();
                          if(oppTeamRec.Role__r.IO_Role__c == true )
                          {
                             IOmyCS = Email_Template__c.getValues(UtilConstants.IO_USER);
                             String IOmyCCVal = IOmyCS.ID__c;
                             lstOfUserEmailId.add(oppTeamRec.Opportunity_Team_Member__r.user__r.Email);
                             mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                             mail.setWhatId(oppTeamRec.id) ;
                             mail.setTargetObjectId(UtilUser.UtilUser(oppTeamRec.Opportunity_Team_Member__c)) ;
                             mail.setTemplateId(IOmyCCVal);
                             mail.saveAsActivity=false;  
                             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
                          }
                          system.debug(oppTeamRec.Role__r.IC_Role__c);
                          if(oppTeamRec.Role__r.IC_Role__c == true)
                          {
                          system.debug('in if'+oppTeamRec.Role__r.IC_Role__c);
                              Email_Template__c ICmyCS = Email_Template__c.getValues(UtilConstants.IC_USER);
                              String ICmyCCVal = ICmyCS.ID__c;
                              lstOfUserEmailId.add(oppTeamRec.Opportunity_Team_Member__r.user__r.Email);
                              system.debug('Email ids'+lstOfUserEmailId);
                              mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                              mail.setWhatId(oppTeamRec.id) ;
                              mail.setTargetObjectId(UtilUser.UtilUser(oppTeamRec.Opportunity_Team_Member__c)) ;
                              mail.setTemplateId(ICmyCCVal);
                              mail.saveAsActivity=false;  
                              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                          } 
                                                     
                                                                                   
                    }
                }
                
             }
             Catch(DMLException e)
             {
                 //////System.debug('E==='+e);
                 string s=e.getMessage();
             }   
    }
    /**
   *  @Description : This method is used to assign opp team member and update the opportunity,
                      solution scope,Governance data,commercial team object based on role.
   *  @name : sendAndUpdateAssignee
   *  @param : List<Opportunity_Teams__c> oppTeamIdsToAssign
   *  @return parameter - void
   *  @throws exception- DML Exception
   */
     public static void sendAndUpdateAssignee(List<Opportunity_Teams__c> oppTeamIdsToAssign)
     {
            List<opportunity> oppListToUpdateOSL = new List<opportunity>();
            List<opportunity> oppListToUpdateCommLead = new List<opportunity>();//Vaishnavi
            List<opportunity> oppListToUpdateCPRAnlst = new List<opportunity>();//Vaishnavi
            List<opportunity> oppListToUpdateMobArch = new List<opportunity>();//Vaishnavi
            List<opportunity> oppListToUpdateSSAIO = new List<opportunity>();// 717 Vaishnavi
            List<opportunity> oppListToUpdateSSAIC = new List<opportunity>();// 717 Vaishnavi
            List<opportunity> oppListToUpdateSDGL = new List<opportunity>();// 717 Vaishnavi
            List<opportunity> oppListToUpdateSDO = new List<opportunity>();
            List<opportunity> oppListToUpdateSDGov = new List<opportunity>();
            List<opportunity> oppListToUpdateCommData = new List<opportunity>();
            List<opportunity> oppListToUpdateIS = new List<opportunity>();
            List<opportunity> oppListToUpdateCapabilityData = new List<opportunity>();
            List<opportunity> oppListToUdateDmat=new List<opportunity>(); 
            List<opportunity> oppListToUpdateCapabilityLead = new List<opportunity>();//Vaishnavi 646
            List<opportunity> oppListToUpdateOfferingLead = new List<opportunity>();//Vaishnavi 646
            List<opportunity> oppListToUpdateIndusLead = new List<opportunity>();//Vaishnavi 646
            List<opportunity> oppListToUpdateTechArch = new List<opportunity>();//Vaishnavi 646
            Set<Id> oppIds = new Set<Id>();//Aswajit
            String roleTeamMembrName;//Vaishnavi 646
            List<Opportunity_Teams__c> oppListISRole = new List<Opportunity_Teams__c>();
            List<Opportunity_Teams__c> oppListBPORole = new List<Opportunity_Teams__c>();
            Map<Id, String> oppTeamMap = new Map<Id, String>();
            for(Opportunity_teams__c oppT : [Select id, Opportunity_Team_Member__c, Opportunity_Team_Member__r.name, offering__r.Offering_Solution_Lead_Primary__c, offering__r.Offering_Solution_Lead_Secondary__c from opportunity_teams__c where id IN : oppTeamIdsToAssign LIMIT 5000])
            {    
                //Code for updating Solution BPO on Solution Scope
                String opp;
                if(oppT.offering__r.Offering_Solution_Lead_Primary__c != NULL)
                {
                 opp = oppT.offering__r.Offering_Solution_Lead_Primary__c ;
                }
                IF(oppT.offering__r.Offering_Solution_Lead_Secondary__c != NULL)
                {
                opp = opp +UtilConstants.SEMICOLON_STRING + oppT.offering__r.Offering_Solution_Lead_Secondary__c;
                }
                oppTeamMap.put(oppT.ID, opp);
                opp = null;
                
                
            }
            
            List<Solution_Scope__c> solCompListtoUpdatePrimary = new List<Solution_Scope__c>();
            List<Solution_Scope__c> solCompListtoUpdateSec = new List<Solution_Scope__c>();
            
            
            //List<Opportunity_Teams__c> oppTeamNotForPMO = new List<Opportunity_Teams__c>();
            List<Opportunity_Teams__c> oppTeamToUpdate = new List<Opportunity_Teams__c>();
            
            List<SD_Governance_Data__c> govDataListtoInsert = new List<SD_Governance_Data__c>();
            List<SD_Governance_Data__c> govDataListtoUpdate = new List<SD_Governance_Data__c>();
            List<Commercial_Data__c> commListtoUpdate = new List<Commercial_Data__c>();
            
            List<Id> Ids = new List<Id>();
            SD_Governance_Data__c govObj;
           Commercial_Data__c commObj;
             Map<Id,Commercial_Data__c> commDataMap = new Map<Id,Commercial_Data__c>();
             
             List<Role_Map__c> listOfRoles = Role_Map__c.getall().values();
            
            //List<Role_Map__c> listOfRoles = [select name,Role_Dev__c from Role_Map__c];
            
            Map<String,String> RoleMap = new Map<String,String>();
            for(Role_Map__c roleValue: listOfRoles){
                RoleMap.put(roleValue.name,roleValue.Role_Dev__c);
            }
            
            Map<Id,SD_Governance_Data__c> govDataMap = new Map<Id,SD_Governance_Data__c>();
            
                for(SD_Governance_Data__c govData : [select id,SD_Gov_Lead_Coach__c,Opportunity__r.SD_Governance_Lead_Assigned__c,Active__c,name,opportunity__c from SD_Governance_Data__c Limit 5000]){
                        govDataMap.put(govData.opportunity__c,govData);
                }
                
                for(Commercial_Data__c commData :  [select id,Opportunity__r.Com_Lead_Assigned__c,Active__c,name,opportunity__c from Commercial_Data__c Limit 5000]){
                        commDataMap.put(commData.opportunity__c,commData);
                }
              List<Capability_Involvement__c> capabilityListtoUpdate = new List<Capability_Involvement__c>();    
                Capability_Involvement__c capabilityObj;
                Map<String,Capability_Involvement__c> capabilityDataMap1 = new Map<String,Capability_Involvement__c>();
                Map<String,Capability_Involvement__c> capabilityDataMap = new Map<String,Capability_Involvement__c>();
                for(Capability_Involvement__c capabilityData : [select id,name,opportunity__c,user__C,  Opportunity_dev__c,opportunity_team__r.name from Capability_Involvement__c Limit 5000]){
                        if(capabilityData.opportunity_team__r.name!=null){
                        capabilityDataMap1.put(capabilityData.opportunity_team__r.name , capabilityData );}
                        String s =capabilityData.Opportunity_dev__c +UtilConstants.BLANK_SPACE+ capabilityData.user__C;
                        capabilityDataMap.put(s,capabilityData);
                        system.debug('capabilityDataMap1-->'+capabilityDataMap1);
            }
            
                
            for(Opportunity_Teams__c oppTeamrec :  oppTeamIdsToAssign){
                Ids.add(oppTeamrec.opportunity__c);
            }        
                    for(Opportunity_Teams__c oppTeamRec: oppTeamIdsToAssign)
                 
                   {
                       oppIds.add(oppTeamrec.opportunity__c);
                        if(oppTeamRec.Role__r.IC_Role__c == true || oppTeamRec.Role__r.IO_Role__c == true){
                        
                            oppListISRole.add(oppTeamRec);
                        }
                        if(oppTeamRec.Role__r.BPO_Role__c == true)
                        {
                            system.debug('======================================BPO ROLE');
                            oppListBPORole.add(oppTeamRec);
                        }
                        if(oppTeamRec.Role__r.name.Equals(label.Opportunity_Solution_Lead))
                        {
                        //System.debug('inside if!!');
                                        oppTeamRec.Opportunity__r.Opportunity_Solution_Lead__c =  oppTeamRec.Opportunity_Team_Member__c;
                                       // oppTeamRec.Opportunity__r.SD_Covered__c = UtilConstants.YES ;
                                        oppTeamRec.Opportunity__r.Staffing_Status__c = UtilConstants.ASSIGNED; 
                                        oppListToUpdateOSL.add(oppTeamRec.Opportunity__r);
                                                                               
                        }
                        if(oppTeamRec.Role__r.name.Equals(label.CPR_Analyst))
                        {
                                        oppTeamRec.Opportunity__r.CPR_Analyst__c =  oppTeamRec.Opportunity_Team_Member__r.name;
                                        oppListToUpdateCPRAnlst.add(oppTeamRec.Opportunity__r);
                                                                               
                        }
                        if(oppTeamRec.Role__r.name.Equals(label.Commercial_Team))
                        {
                        
                                        oppTeamRec.Opportunity__r.Commercial_Lead__c =  oppTeamRec.Opportunity_Team_Member__r.name;
                                        oppListToUpdateCommLead.add(oppTeamRec.Opportunity__r);
                                                                               
                        }
                        if(oppTeamRec.Role__r.name.Equals(label.Mobilization_Architect))
                        {
                        
                                        oppTeamRec.Opportunity__r.Mobilization_Architect__c =  oppTeamRec.Opportunity_Team_Member__r.name;
                                                                  
                                        oppListToUpdateMobArch.add(oppTeamRec.Opportunity__r);
                                                                               
                        }
                        if(oppTeamRec.Role__r.name.Equals(label.Support_Solution_Architect_IO))
                        {
                            oppTeamRec.Opportunity__r.Support_Solution_Architect_IO__c = oppTeamRec.Opportunity_Team_Member__r.name;
                            oppListToUpdateSSAIO.add(oppTeamRec.Opportunity__r);
                        }
                        if(oppTeamRec.Role__r.name.Equals(label.Support_Solution_Architect_IC))
                        {
                            oppTeamRec.Opportunity__r.Support_Solution_Architect_IC__c = oppTeamRec.Opportunity_Team_Member__r.name;
                            oppListToUpdateSSAIC.add(oppTeamRec.Opportunity__r);
                        }
                        if(oppTeamRec.Role__r.name.Equals(label.SD_Governance_Lead))
                        {
                            oppTeamRec.Opportunity__r.SD_Governance_Lead__c = oppTeamRec.Opportunity_Team_Member__r.name;
                            oppListToUpdateSDGL.add(oppTeamRec.Opportunity__r);
                        }
                                            
                        if(oppTeamRec.Role__r.name.Equals(Label.Offering_Solution_Lead_Primary))
                        {
                                        System.debug('Role is sol arch bpo-->'+Label.Offering_Solution_Lead_Primary);
                                        String solutionscopevalue = oppTeamMap.get(oppTeamRec.ID);
                                        System.debug('solutionscopevalue ' + solutionscopevalue );
                                        System.debug('oppTeamRec.Opportunity_Team_Member__r.name'+ oppTeamRec.Opportunity_Team_Member__r.name);
                                        if(solutionscopevalue != null && !solutionscopevalue.contains(oppTeamRec.Opportunity_Team_Member__r.name ))
                                        {
                                        solutionscopevalue = solutionscopevalue + UtilConstants.SEMICOLON_STRING + oppTeamRec.Opportunity_Team_Member__r.name;
                                        System.debug('Inside solutionscopevalue if');
                                        }
                                        else if(solutionscopevalue == null )
                                        {
                                            solutionscopevalue = oppTeamRec.Opportunity_Team_Member__r.name;
                                        }
                                        
                                        oppTeamRec.Offering__r.Offering_Solution_Lead_Primary__c = solutionscopevalue ;
                                        
                                        solCompListtoUpdatePrimary.add(oppTeamRec.Offering__r);
                                        
                        }
        
                        /*if(oppTeamRec.Role__r.name.Equals(Label.Offering_Solution_Lead_Secondary))
                        {
                                        oppTeamRec.Offering__r.Offering_Solution_Lead_Secondary__c=  oppTeamRec.Opportunity_Team_Member__r.name;
                                        solCompListtoUpdateSec.add(oppTeamRec.Offering__r);
                        }*/
                        if(oppTeamRec.Role__r.name.Equals(Label.Prime_SDO_Lead))
                        {
                                        oppTeamRec.Opportunity__r.Prime_SDO_Lead_Assigned__c = true;
                                        oppTeamRec.Opportunity__r.Prime_SDO_Lead_dev__c = oppTeamRec.Opportunity_Team_Member__r.name;
                                        oppListToUpdateSDO.add(oppTeamRec.Opportunity__r);
                        }
                         if(oppTeamRec.Role__r.name.Equals('Prime Delivery Lead - IO'))
                        {
                                        oppTeamRec.Opportunity__r.Prime_SDO_Lead_Assigned__c = true;
                                        oppTeamRec.Opportunity__r.Prime_SDO_Lead_IO_dev__c = oppTeamRec.Opportunity_Team_Member__r.name;
                                        oppListToUpdateSDO.add(oppTeamRec.Opportunity__r);
                        }
                        if(oppTeamRec.Role__r.name.Equals(Label.SD_Governance_Lead_Coach))
                        {           
                                     oppTeamRec.Opportunity__r.SD_Governance_Lead_Assigned__c = true;   
                                      //System.debug('---We are in this loop----------'+oppTeamRec.Opportunity__r.SD_Governance_Lead_Assigned__c);                                                                         
                                     if(govDataMap.get(oppTeamRec.opportunity__c) == null){
                                        govObj = new SD_Governance_Data__c();                                                                              
                                       govObj.Opportunity__c = oppTeamRec.opportunity__r.id;
                                        govObj.name =oppTeamRec.Opportunity__r.Name+UtilConstants.GOV;
                                        govObj.SD_Gov_Lead_Coach__c = oppTeamRec.Opportunity_Team_Member__r.name;
                                        govObj.Active__c = true;
                                        govDataListtoInsert.add(govObj);
                                         
                                     } 
                                     else{
                                        govObj = govDataMap.get(oppTeamRec.opportunity__c);
                                        govObj.SD_Gov_Lead_Coach__c = oppTeamRec.Opportunity_Team_Member__r.name;
                                        govObj.Active__c = true;
                                        
                                        govDataListtoUpdate.add(govObj);
                                     } 
                                        oppListToUpdateSDGov.add(oppTeamRec.Opportunity__r);
                        }
                        //Vaishnavi 646
                        if(oppTeamRec.Role__r.name.Equals(label.Industry_Lead))
                        {
                            if(oppTeamRec.Opportunity__r.Industry_Lead_Name_s__c != null)
                            {
                                    if(!oppTeamRec.Opportunity__r.Industry_Lead_Name_s__c.contains(oppTeamRec.Opportunity_Team_Member__r.name))
                                    {
                                        oppTeamRec.Opportunity__r.Industry_Lead_Name_s__c = oppTeamRec.Opportunity__r.Industry_Lead_Name_s__c + ';' + oppTeamRec.Opportunity_Team_Member__r.name ;
                                    }

                                
                            }
                            else
                            {
                                oppTeamRec.Opportunity__r.Industry_Lead_Name_s__c = oppTeamRec.Opportunity_Team_Member__r.name;
                            }
                            
                            oppListToUpdateIndusLead.add(oppTeamRec.Opportunity__r);
                            
                                               
                        }
                        if(oppTeamRec.Role__r.name.Equals(label.Capability_Lead))
                        {   
                            
                            if(oppTeamRec.Opportunity__r.Capability_Lead_Name_s__c != null)
                            {
                                    if(!oppTeamRec.Opportunity__r.Capability_Lead_Name_s__c.contains(oppTeamRec.Opportunity_Team_Member__r.name))
                                    {
                                        oppTeamRec.Opportunity__r.Capability_Lead_Name_s__c = oppTeamRec.Opportunity__r.Capability_Lead_Name_s__c + ';' + oppTeamRec.Opportunity_Team_Member__r.name ;
                                    }

                                
                            }
                            else
                            {
                                oppTeamRec.Opportunity__r.Capability_Lead_Name_s__c = oppTeamRec.Opportunity_Team_Member__r.name;
                            }
                            
                            oppListToUpdateCapabilityLead.add(oppTeamRec.Opportunity__r);
                            
                                               
                        }
                         /*added by Ruchita
                         Update Assigned BPO Tech Arch Lead on Opportunity Tech Attribute Section*/
                        if(oppTeamRec.Role__r.name.Equals(label.Technical_Architect))
                        {
                            if(oppTeamRec.Opportunity__r.Assigned_BPO_tech_Arch__c != null)
                            {
                                    if(!oppTeamRec.Opportunity__r.Assigned_BPO_tech_Arch__c.contains(oppTeamRec.Opportunity_Team_Member__r.name))
                                    {
                                        oppTeamRec.Opportunity__r.Assigned_BPO_tech_Arch__c = oppTeamRec.Opportunity__r.Assigned_BPO_tech_Arch__c + ';' + oppTeamRec.Opportunity_Team_Member__r.name ;
                                    }

                                
                            }
                            else
                            {
                                oppTeamRec.Opportunity__r.Assigned_BPO_tech_Arch__c = oppTeamRec.Opportunity_Team_Member__r.name;
                            }
                            
                            oppListToUpdateTechArch.add(oppTeamRec.Opportunity__r);
                            
                                               
                        }
                        // Tech Attribute Code end
                        
                        if(oppTeamRec.Role__r.name.Equals(label.Offering_Lead))
                        {
                            if(oppTeamRec.Opportunity__r.Offering_Lead_Name_s__c != null)
                            {
                                    if(!oppTeamRec.Opportunity__r.Offering_Lead_Name_s__c.contains(oppTeamRec.Opportunity_Team_Member__r.name))
                                    {
                                        oppTeamRec.Opportunity__r.Offering_Lead_Name_s__c = oppTeamRec.Opportunity__r.Offering_Lead_Name_s__c + ';' + oppTeamRec.Opportunity_Team_Member__r.name ;
                                    }

                                
                            }
                            else
                            {
                                oppTeamRec.Opportunity__r.Offering_Lead_Name_s__c = oppTeamRec.Opportunity_Team_Member__r.name;
                            }
                            
                            oppListToUpdateOfferingLead.add(oppTeamRec.Opportunity__r);
                            
                                               
                        }
                        if(oppTeamRec.Role__r.name.Equals(UtilConstants.COMM_TEAM))
                        {
                                        oppTeamRec.Opportunity__r.Com_Lead_Assigned__c = true;
                                        //System.debug('---We are in this loop----------'+oppTeamRec.Opportunity__r.Com_Lead_Assigned__c);
                                        if(commDataMap.get(oppTeamRec.opportunity__c) == null){
                                            commObj = new Commercial_Data__c();
                                            commObj.Opportunity__c = oppTeamRec.opportunity__r.id;
                                            commObj.name =oppTeamRec.Opportunity__r.Name+UtilConstants.COMM_DATA;
                                            commObj.Active__c = true;
                                            system.debug('Commercial Object Creation------------------------------->');
                                            commListtoUpdate.add(commObj);
                                        }
                                        else{
                                            commObj = commDataMap.get(oppTeamRec.opportunity__c);
                                            //commObj.Opportunity__c = oppTeamRec.opportunity__r.id;
                                            commObj.Active__c = true;
                                            commListtoUpdate.add(commObj);
                                            
                                        }
                                        //System.debug('---commListtoUpdate----------'+commListtoUpdate);
                                        oppListToUpdateCommData.add(oppTeamRec.Opportunity__r);
                        }
                        
                        
                        //added by Reena for capability Involvement
                        if(oppTeamRec.Role__r.name.Equals(UtilConstants.CAPABILITY_MEM))
                        {
                                        
                                        system.debug('.....insideif');
                                        oppTeamRec.Opportunity__r.Capability_Lead__c = true;
                                        if(capabilityDataMap1.containskey(oppTeamRec.name)){
                                            capabilityObj = capabilityDataMap1.get(oppTeamRec.name); 
                                            system.debug('capabilityDataMap1.get(oppTeamRec.id).....'+capabilityDataMap1.get(oppTeamRec.id));
                                            String oppteamname=oppTeamRec.name;
                                            capabilityObj.user__C=oppTeamRec.Opportunity_Team_Member__c;
                                            capabilityObj.name =UtilConstants.CAP_INV+oppteamname.substring(14,20);
                                            capabilityObj.Team_Member_Id_Dev__c=oppTeamRec.Opportunity_Team_Member__c;
                                            
                                            capabilityObj.Active__c = true;   
                                                                               
                                            capabilityListtoUpdate.add(capabilityObj);
                                        
                                       }
                                       else{   
                                            system.debug('oppTeamRec.opportunity__c>>>>>>>oppTeamRec.Opportunity_Team_Member__c>>>>>>'+oppTeamRec.opportunity__c+oppTeamRec.Opportunity_Team_Member__c);                                        
                                            if(capabilityDataMap.get(oppTeamRec.opportunity__c+UtilConstants.BLANK_SPACE+oppTeamRec.Opportunity_Team_Member__c) == null ){                                                                               
                                            capabilityObj = new Capability_Involvement__c();
                                            capabilityObj.Opportunity_dev__c=oppTeamRec.opportunity__r.id;
                                            capabilityObj.Opportunity__c = oppTeamRec.opportunity__r.id;
                                            capabilityObj.Opportunity_Team__c=oppTeamRec.id;
                                            capabilityObj.user__C=oppTeamRec.Opportunity_Team_Member__c;
                                            String oppteamname=oppTeamRec.name;
                                            capabilityObj.name =UtilConstants.CAP_INV+oppteamname.substring(14,20);
                                            capabilityObj.Active__c = true;
                                            capabilityObj.Team_Member_Id_Dev__c=oppTeamRec.Opportunity_Team_Member__c;
                                            capabilityListtoUpdate.add(capabilityObj);
                                            system.debug(capabilityListtoUpdate.size());
                                           }
                                           else{
                                            if(capabilityDataMap.get(oppTeamRec.opportunity__c+UtilConstants.BLANK_SPACE+ oppTeamRec.Opportunity_Team_Member__c) != null ){
                                            capabilityObj = capabilityDataMap.get(oppTeamRec.opportunity__c+UtilConstants.BLANK_SPACE+ oppTeamRec.Opportunity_Team_Member__c); 
                                            String oppteamname=oppTeamRec.name;
                                            capabilityObj.opportunity_team__C=oppTeamRec.id;
                                            capabilityObj.user__C=oppTeamRec.Opportunity_Team_Member__c;
                                            capabilityObj.name =UtilConstants.CAP_INV+oppteamname.substring(14,20);
                                            capabilityObj.Team_Member_Id_Dev__c=oppTeamRec.Opportunity_Team_Member__c;
                                            capabilityObj.Active__c = true;
                                            capabilityObj.Opportunity__C=capabilityDataMap.get(oppTeamRec.opportunity__c+' '+ oppTeamRec.Opportunity_Team_Member__c).Opportunity_dev__c;
                                            capabilityListtoUpdate.add(capabilityObj);
                                           
                                            }
                                          }
                                        }
                                        
                                        system.debug('---capabilityListtoUpdate----------'+capabilityListtoUpdate);
                                        oppListToUpdateCapabilityData.add(oppTeamRec.Opportunity__r);
                        }
                        
                        
                        
                        
                         /*if(oppTeamRec.Role__r.name.Equals('DMAT User'))
                        {
                            oppTeamRec.Opportunity__r.Dmat_User_Assigned__c = true;
                           
                            system.debug('---capabilityListtoUpdate----------'+oppTeamRec);
                            oppListToUdateDmat.add(oppTeamRec.Opportunity__r);
                        }*/
                        
                        for(String keyvalue : RoleMap.keySet()){
                            if(oppTeamRec.Role__r.name.equals(keyvalue)){
                                oppTeamRec.Role_Dev__c = RoleMap.get(keyvalue);     
                            }
                        }
                        if(oppTeamRec.Role__r.name.Equals(label.Lead_Solution_Architect_IO))
                        {
                                        oppTeamRec.Opportunity__r.IO_Solution_Architect__c =  oppTeamRec.Opportunity_Team_Member__c;                                                                               
                                        oppListToUpdateIS.add(oppTeamRec.Opportunity__r);                                                                                                                                                               
                        }   
                        if(oppTeamRec.Role__r.name.Equals(label.Lead_Solution_Architect_IC))
                        {
                                        oppTeamRec.Opportunity__r.IC_Solution_Architect__c =  oppTeamRec.Opportunity_Team_Member__c;                                                                                
                                        oppListToUpdateIS.add(oppTeamRec.Opportunity__r);                                                                                
                                        
                        }
                        
                        system.debug('Email to technical lead architect------------->');
                        oppTeamRec.Assigned_Date__c = system.today();
                        oppTeamRec.Team_Member_Request_Status__c = UtilConstants.ASSIGNED;
                        oppTeamToUpdate.add(oppTeamRec);
                    }
                    //Added By Aswajit
                    if(oppIds!=null){
                        doCapabilityLeadCount(oppIds);
                    }
                    
                                
          try{
              
                if(oppListToUpdateIS.size() > 0){
                    update oppListToUpdateIS;
                }
                if(oppListToUpdateOSL.size()> 0 ){
                    update oppListToUpdateOSL;
                }
                if(oppListToUpdateCPRAnlst.size()> 0 ){
                    update oppListToUpdateCPRAnlst;
                }
                if(oppListToUpdateCommLead.size()> 0 ){
                    update oppListToUpdateCommLead;
                }
                if(oppListToUpdateMobArch.size()> 0 ){
                    update oppListToUpdateMobArch;
                }
                if(solCompListtoUpdatePrimary.size()> 0 ){
                    system.debug('solCompListtoUpdatePrimary.size()> 0');
                    update solCompListtoUpdatePrimary;
                }
                if(oppListToUpdateSSAIO.size()> 0 ){
                    update oppListToUpdateSSAIO;
                }
                if(oppListToUpdateSSAIC.size()> 0 ){
                    update oppListToUpdateSSAIC;
                }
                if(oppListToUpdateSDGL.size()> 0 ){
                    update oppListToUpdateSDGL;
                }
                /*if(solCompListtoUpdateSec.size()> 0 ){
                    update solCompListtoUpdateSec;
                }*/
                if(oppListToUpdateSDO.size()> 0 ){
                    update oppListToUpdateSDO;
                }
                if(oppListToUpdateSDGov.size()> 0 ){
                    update oppListToUpdateSDGov;
                }
                if(oppListToUpdateIndusLead.size()>0)
                {
                    update oppListToUpdateIndusLead;
                }
                if(oppListToUpdateCapabilityLead.size()>0)
                {
                    update oppListToUpdateCapabilityLead;
                }
                if(oppListToUpdateTechArch.size()>0)
                {
                update oppListToUpdateTechArch;
                }
                /*
                if(oppListToUpdateTechArch.size()>0)
                {
                    update oppListToUpdateTechArch;
                }
                */
                if(oppListToUpdateOfferingLead.size()>0)
                {
                    update oppListToUpdateOfferingLead;
                }
                if(oppListToUpdateCommData.size()> 0 ){
                    update oppListToUpdateCommData;
                }
                if(govDataListtoInsert.size() > 0){ 
                    UtilConstantsR3.runGovTrigger=true;
                    insert govDataListtoInsert;
                }
                if(govDataListtoUpdate.size() > 0){
                    update govDataListtoUpdate; 
                }
                if(commListtoUpdate.size() > 0){
                    system.debug('commListtoUpdate----------------------------------------------update');
                    UtilConstantsR3.runCommTrigger=true;
                    upsert commListtoUpdate;
                }
                if(oppTeamToUpdate.size() > 0){
                    update oppTeamToUpdate;
                    system.debug('Email to update done------------->');
                    
                }
                
                /*Added by Reena Thakre*/
                 if(capabilityListtoUpdate.size() > 0){
                    upsert capabilityListtoUpdate;
                }
                if(oppListToUpdateCapabilityData.size() > 0){
                    update oppListToUpdateCapabilityData;
                }
                
               
                oppListToUpdateCapabilityData.clear();
                capabilityListtoUpdate.clear();
                /*******/

                /*if(oppListToUdateDmat.size()>0){
                    update oppListToUdateDmat;
                }
                
                oppListToUdateDmat.clear();*/
                oppListToUpdateOSL.clear();
                oppListToUpdateCPRAnlst.clear();
                oppListToUpdateCommLead.clear();
                oppListToUpdateMobArch.clear();
                solCompListtoUpdatePrimary.clear();
                oppListToUpdateSSAIO.clear();
                oppListToUpdateSSAIC.clear();
                oppListToUpdateSDGL.clear();
                solCompListtoUpdateSec.clear();
                oppListToUpdateIndusLead.clear();
                oppListToUpdateCapabilityLead.clear();
                oppListToUpdateOfferingLead.clear();
                oppListToUpdateSDO.clear();
                oppListToUpdateSDGov.clear();
                oppListToUpdateIS.clear();
                oppListToUpdateCommData.clear();
                //oppListToUpdateTechArch.clear();
             /*********By Diwanshu.setia*******/
             
             if(govDataListtoInsert.size() > 0){ 
                    createCriticalMilestoneRec(govDataListtoInsert);                          
             }
               /*********By Diwanshu.setia******/  
               
               if(oppListISRole.size()>0){
                    IOsendMailToAssignee(oppListISRole);
                }
                else{
                if(oppListBPORole.size()>0){   
                    system.debug('Email to assiggneee------------->');
                    sendMailToAssignee(oppListBPORole);
                }
                }
              }
            catch(Exception e){

                UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,
                        OPERATIONONOPPTEAMTRIGGERCONTROLLER , SENDANDUPDATEASSIGNEE , OPERATIONONOPPTEAMTRIGGER , System.Logginglevel.ERROR);
            }
    }  
    /**
   *  @Description : This method is used to create critical milestone records based on governance data list.
   *  @name : createCriticalMilestoneRec
   *  @param : List<SD_Governance_Data__c> govDataListtoInsert
   *  @return parameter - void
   *  @throws exception- DML Exception
   */ 
        public static void createCriticalMilestoneRec(List<SD_Governance_Data__c> govDataListtoInsert){
        
            list<Critical_Milestone__c> criticalMilestoneListToUpdate = new list<Critical_Milestone__c>();
            Critical_Milestone__c criticalMilestoneRec;
            try{
            for(SD_Governance_Data__c govRc : govDataListtoInsert){
                       
                       
                        for(integer i=1; i<8; ++i)
                         {
                         criticalMilestoneRec = new Critical_Milestone__c();
                        criticalMilestoneRec.Governance_Data__c = govRc.id;
                         criticalMilestoneRec.active__c = true;
                         criticalMilestoneRec.Actual__c = date.today();
                         criticalMilestoneRec.complete__c =UtilConstants.NO;
                        
                         if(i==1)
                         {
                         criticalMilestoneRec.name=UtilConstants.STAGE_1;
                          criticalMilestoneListToUpdate.add(criticalMilestoneRec);
                         
                         }
                        if(i==2)
                        {
                        criticalMilestoneRec.name=UtilConstants.STAGE_2;
                         criticalMilestoneListToUpdate.add(criticalMilestoneRec);
                        
                        }
                        if(i==3)
                         {
                         criticalMilestoneRec.name=UtilConstants.DUE_DILIGENCE;
                          criticalMilestoneListToUpdate.add(criticalMilestoneRec);
                         
                         }
                        if(i==4)
                        {
                        criticalMilestoneRec.name=UtilConstants.CONTRT_START;
                         criticalMilestoneListToUpdate.add(criticalMilestoneRec);
                        
                        }
                        if(i==5)
                         {
                         criticalMilestoneRec.name=UtilConstants.CONTRT_END;
                          criticalMilestoneListToUpdate.add(criticalMilestoneRec);
                        
                         }
                        if(i==6)
                        {
                        criticalMilestoneRec.name=UtilConstants.INIT_GOLIVE;
                         criticalMilestoneListToUpdate.add(criticalMilestoneRec);
                       
                        }
                         if(i==7)
                        {
                        criticalMilestoneRec.name=UtilConstants.EXP_CONTRT;
                         criticalMilestoneListToUpdate.add(criticalMilestoneRec);
                        
                        }
                     
                      } 
                       
                    }
                    if(criticalMilestoneListToUpdate.size() > 0){
                        insert criticalMilestoneListToUpdate;
                    } 
            }
            catch(Exception e){
                            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,
                                    OPERATIONONOPPTEAMTRIGGERCONTROLLER , SENDANDUPDATEASSIGNEE , OPERATIONONOPPTEAMTRIGGER , System.Logginglevel.ERROR);
                        }
        }
        
  /**
   *  @Description : This method is update opp team record after routing is done and tech arch is assigned.
   *  @name : updateAfterRouting
   *  @param : List <Opportunity_Teams__c> oppTeamIdsToPMO
   *  @return parameter - void
   *  @throws exception- DML Exception
   */  
        public static void updateAfterRouting(List<Opportunity_Teams__c> oppTeamIdAafterRouting){
            List<user_master__c> usermaster =[Select id,user__c from user_master__c where user__c =: UserInfo.getUserId() limit 1];
            List<User> reRouteUser = new List<User>();
            List <Opportunity_Teams__c> reRoutingRequestUpdate = new List <Opportunity_Teams__c>();
            for(Opportunity_Teams__c oppTeamPMO: oppTeamIdAafterRouting){
                If(oppTeamPMO.Role__r.name.equals(Label.Technical_Architect)&&oppTeamPMO.Opportunity_Team_Member__c!=null && oppTeamPMO.Last_Routed_User__c!=null){     
                            
                        oppTeamPMO.Team_Member_Request_Status__c=UtilConstants.ASSIGNED;        
                        oppTeamPMO.Assigned_Date__c=System.today();  
                        oppTeamPMO.Request_Team_Member__c=False;
                        reRouteUser.add(new User(Id=oppTeamPMO.Opportunity_Team_Member__r.user__r.id));     
                        reRoutingRequestUpdate.add(oppTeamPMO); 
                        //toUpdateList.add(oppTeamPMO);    
                        //Database.Update(reRoutingRequestUpdate);        
                        //OppteamAssignByOffrngTechLead(reRoutingRequestUpdate,reRouteUser);      
                        
                }
                
                if(!reRoutingRequestUpdate.isEmpty()){
                    try{
                        Database.Update(reRoutingRequestUpdate);  
                        OppteamAssignByOffrngTechLead(reRoutingRequestUpdate,reRouteUser); 
                    }
                    catch(Exception e){
                        UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,
                        OPERATIONONOPPTEAMTRIGGERCONTROLLER , updateAfterRouting , OPERATIONONOPPTEAMTRIGGER , System.Logginglevel.ERROR);
                    }
                }
                
            }
        }       
   /**
   *  @Description : This method is used to send mail to PMO.
   *  @name : sendMailToPMO
   *  @param : List <Opportunity_Teams__c> oppTeamIdsToPMO
   *  @return parameter - void
   *  @throws exception- DML Exception
   */  
    public static void sendMailToPMO(List<Opportunity_Teams__c> oppTeamIdsToPMO)
    {       
            system.debug('Inside sendMailToPMO');
            List <Opportunity_Teams__c> oppTeamCCA = new List <Opportunity_Teams__c>();
            List <Opportunity_Teams__c> oppTeamBSS = new List <Opportunity_Teams__c>();
            List <Opportunity_Teams__c> oppTeamSS = new List <Opportunity_Teams__c>();
            List <Opportunity_Teams__c> oppTeamMA = new List <Opportunity_Teams__c>();
            List <Opportunity_Teams__c> oppTeamTA = new List <Opportunity_Teams__c>();
            List <Opportunity_Teams__c> oppTeamListToUpdate = new List <Opportunity_Teams__c>();
            List <Opportunity_Teams__c> oppTeamDA = new List <Opportunity_Teams__c>();
            List <Opportunity_Teams__c> reRoutingRequestUpdate = new List <Opportunity_Teams__c>();     
            List<User> reRouteUser = new List<User>();
            Group CCAQueueId = [select Id from Group where Name =: UtilConstants.CCA_Q and Type =: UtilConstants.QUEUE Limit 5000];
            Group BSSQueueId = [select Id from Group where Name =: UtilConstants.BSS_Q and Type =: UtilConstants.QUEUE Limit 5000];
            Group SSQueueId = [select Id from Group where Name =: UtilConstants.SS_Q and Type =: UtilConstants.QUEUE Limit 5000];
            Group MAQueueId = [select Id from Group where Name =: UtilConstants.MOB_RCH and Type =: UtilConstants.QUEUE Limit 5000];
            Group TAQueueId = [select Id from Group where Name =: UtilConstants.TECH_AR_QUE and Type =: UtilConstants.QUEUE Limit 5000];
            Group DUQueueId = [select Id from Group where Name =: UtilConstants.DMATQUEUE and Type =: UtilConstants.QUEUE Limit 5000];
            system.debug('DUQueueId--'+DUQueueId);
            List<user_master__c> usermaster =[Select id,user__c from user_master__c where user__c =: UserInfo.getUserId() limit 1];
            for(Opportunity_Teams__c oppTeamPMO: oppTeamIdsToPMO)
            {
                //////System.debug('------oppTeamPMO.Role__r.name-----'+oppTeamPMO.Role__r.name);
                if(oppTeamPMO.Role__r.name.equals(Label.Complex_Cost_Architect))
                {
                                //oppTeamPMO.ownerId='00Gc0000000xr7N';
                                oppTeamPMO.Role_Dev__c = UtilConstants.CCA;
                                oppTeamPMO.ownerId= CCAQueueId.id;
                                oppTeamCCA.add(oppTeamPMO);
                                
                }
                
                if(oppTeamPMO.Role__r.name.equals(Label.BSS_Architect))
                {
                                //oppTeamPMO.ownerId='00Gc0000000xr7N';
                                oppTeamPMO.Role_Dev__c = UtilConstants.BSS;
                                oppTeamPMO.ownerId= BSSQueueId.id;
                                oppTeamBSS.add(oppTeamPMO);
                                
                }
                
                if(oppTeamPMO.Role__r.name.equals(Label.Solution_Specialist))
                {
                                //oppTeamPMO.ownerId='00Gc0000000xrsT';
                                oppTeamPMO.ownerId= SSQueueId.id;
                                oppTeamPMO.Role_Dev__c = UtilConstants.SS;
                                oppTeamSS.add(oppTeamPMO);
                }
                if(oppTeamPMO.Role__r.name.equals(Label.Mobilization_Architect))
                {
                                //oppTeamPMO.ownerId='00Gc0000000xv1E';
                                oppTeamPMO.ownerId= MAQueueId.id;
                                oppTeamPMO.Role_Dev__c = UTILConstants.MA;
                                oppTeamMA.add(oppTeamPMO);
                }
                if(oppTeamPMO.Role__r.name.equals(Label.DMAT_User_Profile))
                {
                                system.debug('Inside Upper IF');
                                oppTeamPMO.ownerId= DUQueueId.id;
                               // oppTeamPMO.Role_Dev__c = UTILConstants.MA;
                                oppTeamDA.add(oppTeamPMO);
                                system.debug('oppTeamDA--'+oppTeamDA);
                }
                if(oppTeamPMO.Role__r.name.equals(Label.Technical_Architect))
                {
                                //oppTeamPMO.ownerId='00Gc0000000xv1J';
                                oppTeamPMO.ownerId= TAQueueId.id;
                                oppTeamPMO.Role_Dev__c = UtilConstants.TA;
                                oppTeamTA.add(oppTeamPMO);
                }
                oppTeamPMO.Team_Member_Request_Status__c = UtilConstants.TASK_STATUS;
                oppTeamPMO.Requested_Date__c = system.today();
                //oppTeamPMO.Requestor__c = usermaster[0].id;
                try{
                    if(usermaster.size() > 0){
                    
                        oppTeamPMO.Requestor__c = usermaster[0].id;
                    }
                }
                catch(Exception e){
                
                    ////System.debug('No User Master record Exist'+e);
                    string s=e.getMessage();
                }
                
                oppTeamListToUpdate.add(oppTeamPMO);
            }
            if(oppTeamListToUpdate.size()>0){
                try{
                        update oppTeamListToUpdate;
                        
                        if(oppTeamCCA.size()>0){
                                        List<User> mailToUser = getEmailIds(Label.Complex_Cost_Architect_PMO_Group);
                                        sendMailToPMOGroup(oppTeamCCA,mailToUser);
                        }
                        if(oppTeamBSS.size()>0){
                                        List<User> mailToUser = getEmailIds(Label.BSS_Architect_PMO_Group);
                                        sendMailToPMOGroup(oppTeamBSS,mailToUser);
                        }
                        if(oppTeamSS.size()>0){
                                        List<User> mailToUser = getEmailIds(Label.Solution_Specialist_PMO_group);
                                        //System.debug('-------mailToUser------'+mailToUser);
                                        sendMailToPMOGroup(oppTeamSS,mailToUser);
                        }
                        if(oppTeamMA.size()>0){
                                        List<User> mailToUser = getEmailIds(Label.Mobilization_Architect_PMO_Group);
                                        sendMailToPMOGroup(oppTeamMA,mailToUser);
                        }
                        if(oppTeamTA.size()>0){
                                        List<User> mailToUser = getEmailIds(Label.Technical_Architect_PMO_Group);
                                        sendMailToPMOGroup(oppTeamTA,mailToUser);
                        }
                        if(oppTeamDA.size()>0){
                                        List<User> mailToUser = getEmailIds(Label.DMAT_PMO_GROUP);
                                        //List<User> mailToUser = getEmailIds('DMAT_User_PMO_Group');
                                        system.debug('mailToUser--'+mailToUser);
                                        system.debug('oppTeamDA1--'+oppTeamDA);
                                        sendMailToPMOGroup(oppTeamDA,mailToUser);
                        }
                        
                }
                catch(Exception e){
                
                    UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,
                        OPERATIONONOPPTEAMTRIGGERCONTROLLER , SENDMAILTOPMO , OPERATIONONOPPTEAMTRIGGER , System.Logginglevel.ERROR);
               }
            }
    }
    /**
   *  @Description : This method is used to send mail to Opportunity Team member assigned by offering tech lead.
   *  @name : OppteamAssignByOffrngTechLead
   *  @param : List <Opportunity_Teams__c> oppTeamIdsToPMO,List of User
   *  @return parameter - void
   *  @throws exception- DML Exception
   */ 
    public static void OppteamAssignByOffrngTechLead(List<Opportunity_Teams__c> oppTeamIdsToPMO,List<User> mailToAddresses){        
                    
                system.debug('==================================>> Oppteam from Route To'+oppTeamIdsToPMO.size());      
                system.debug('==================================>> User Got from Route To'+mailToAddresses.size());     
                system.debug('==================================>> User Got from Route To'+mailToAddresses);        
            try{        
                    
                List<String> userEmailId = new List<string>();      
                String userId=UtilConstants.EMPTY_STRING;       
                for(User u : mailToAddresses){      
                    if( userId.equals(UtilConstants.EMPTY_STRING)){     
                           userId = u.Id;       
                       }else{       
                           userEmailId.add(u.Email);        
                       }        
                   }        
        
                String orgWideEmailAddressID=UtilEmail.emailid();       
                Email_Template__c myCS1;        
                Messaging.SingleEmailMessage mail;      
                List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();     
                for(Opportunity_Teams__c oppTeamRec : oppTeamIdsToPMO){     
                                //if(oppTeamRec.Role__r.ShouldReceiveAlertMail__c == true){     
                                //for(User mailToadd : mailToAddresses){            
                                            
                        List<String> sumOfIds = new List<String>();                         
                        myCS1= Email_Template__c.getValues(UtilConstants.EMAIL_TO_OFFRNG_TECH_LEAD);        
                        String myCCVal = myCS1.ID__c;       
                        mail = new Messaging.SingleEmailMessage();      
                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);       
                        mail.setWhatId(oppTeamRec.id) ;     
                        mail.setTargetObjectId(userId) ;        
                        mail.setToAddresses(userEmailId);       
                        system.debug('==================================>> Mail To be Send (TO)'+userEmailId.size());       
                            //sumOfIds.add(oppTeamRec.Requestor__c);        
                        sumOfIds.addAll(getUserEmail(new List<string> {oppTeamRec.Requestor__c}));      
                        system.debug('==================================>> Mail Sent to Requestor'+oppTeamRec.Requestor__c);        
                            sumOfIds.addAll(getEmailIdsFromTechArchGrp());      
                            sumOfIds.addAll(getUserEmail(new List<string> {oppTeamRec.Route_To__r.User_Master__c})); 
             system.debug('==================================>> Route To User In CC mail in getuseremail' +getUserEmail(new List<string> {oppTeamRec.Route_To__r.User_Master__r.User__c}));                   
               system.debug('==================================>> Route To User In CC mail' +oppTeamRec.Route_To__r.User_Master__r.User__c);                 
                        system.debug('==================================>> Tech arch  group member IDs'+getEmailIdsFromTechArchGrp());      
                        mail.setCCAddresses(sumOfIds);      
                        system.debug('==================================>> all Mail To be Send in CC(requestor and member in tech arch group)'+sumOfIds);       
                        //mail.setCCAddresses(UtilUser.getUserEmail(oppTeamRec.Requestor__c));      
                        mail.setTemplateId(myCCVal);        
                        mail.saveAsActivity=false;      
                        allMails.add( mail );       
                    system.debug('==================================>> mail---------->>'+mail);     
                }       
                Messaging.sendEmail(allMails);      
                system.debug('==================================>> Mail To be Send'+allMails);      
                        
                }       
                Catch(Exception e)      
                {       
                     System.debug('E===************************>> '+e);     
                     string s=e.getMessage();       
                }       
                        
                        
    }       
            
    /**
   *  @Description : This method is used to return email of Users.
   *  @name : getUserEmail
   *  @param : String IDs(User master IDs)
   *  @return parameter - List
   *  @throws exception- null
   */         
    public static List < String > getUserEmail(List<String> uid){       
        List < String > userEmail = new List < String > ();     
        try {       
            for (User_Master__c userMasterRec: [SELECT id, user__r.id, user__r.Email        
                            FROM User_Master__c WHERE id = : uid limit 500]) {      
                userEmail.add(userMasterRec.user__r.Email);     
            }       
            system.debug('==================================>> UserEmails in getUserEmails'+userEmail);     
            return (userEmail);     
                    
        } catch (Exception e) {     
            System.debug(e);      
            return null;        
        }       
    }       
    /**
   *  @Description : This method is used to return email of Tech Arch Group
   *  @name : getEmailIdsFromTechArchGrp
   *  @param : void
   *  @return parameter - List
   *  @throws exception- null
   */          
    public static List<String> getEmailIdsFromTechArchGrp(){        
                
        try{        
                                
                //String lstGrpName = grpName;      
                List<String> idList = new List<String>();       
                List<String> mailToAddresses = new List<String>();                                      
                        
                List<Group> g = [SELECT id,Email,(select userOrGroupId from groupMembers) FROM group WHERE name =:(Label.Technical_Architect_PMO_Group) LIMIT 5000];        
                system.debug('==================================>> Group'+g.size());        
            system.debug('==================================>> Display Group'+g);       
                for(integer i=0;i<g.size();i++ )        
                {       
                    for (GroupMember gm : g[i].groupMembers) {              
                        idList.add(gm.userOrGroupId);       
                                    
                    }           
                }       
                    
                //User[] usr = [SELECT id,email FROM user WHERE id IN :idList Limit 5000];          
                List<String> userIds = new List<String>();      
                for(user usr: [SELECT id,email FROM user WHERE id IN :idList Limit 5000]){      
                  userIds.add(usr.email);       
                  system.debug('==================================>> Tech Arch Group User IDs'+userIds);        
                }       
                            
                return userIds;         
            }       
            Catch(Exception e)      
            {       
                    System.debug('E==='+e);     
                    string s=e.getMessage();        
            }       
                    
            return null;                
                                
        }
   /**
   *  @Description : This method is used to get Email Id.
   *  @name : getEmailIds
   *  @param : String grpName
   *  @return parameter - void
   *  @throws exception- DML Exception
   */  
        public static List<User> getEmailIds(String grpName){
        
        try{
                        
                String lstGrpName = grpName;
                system.debug('lstGrpName--'+lstGrpName);
                List<String> idList = new List<String>();
                List<String> mailToAddresses = new List<String>();                              
                
                List<Group> g = [SELECT id,Email,(select userOrGroupId from groupMembers) FROM group WHERE name =: lstGrpName Limit 5000]; 
                for(integer i=0;i<g.size();i++ )
                {
                    for (GroupMember gm : g[i].groupMembers) {        
                        idList.add(gm.userOrGroupId);
                            
                    }    
                }
                system.debug('idList--'+idList);
                User[] usr = [SELECT email FROM user WHERE id IN :idList Limit 5000];    
                system.debug('usr--'+usr);  
                return usr; 
            }
            Catch(Exception e)
            {
                    ////System.debug('E==='+e);
                    string s=e.getMessage();
            }  
            
            return null;          
                        
        }
        /**
   *  @Description : This method is used to send mail to PMO group.
   *  @name : sendMailToPMOGroup
   *  @param : List<Opportunity_Teams__c> oppTeamIdsToPMO,List<User> mailToAddresses
   *  @return parameter - void
   *  @throws exception- DML Exception
   */ 
       public static void sendMailToPMOGroup(List<Opportunity_Teams__c> oppTeamIdsToPMO,List<User> mailToAddresses){
                
            try{
            
                List<String> userEmailId = new List<string>();
                String userId=UtilConstants.EMPTY_STRING;
                for(User u : mailToAddresses){
                    if( userId.equals(UtilConstants.EMPTY_STRING)){
                           userId = u.Id;
                       }else{
                           userEmailId.add(u.Email);
                       }
                   }
 

                String orgWideEmailAddressID=UtilEmail.emailid();
                Email_Template__c myCS1;
                Messaging.SingleEmailMessage mail;
                List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
                for(Opportunity_Teams__c oppTeamRec : oppTeamIdsToPMO){
                                //if(oppTeamRec.Role__r.ShouldReceiveAlertMail__c == true){
                                //for(User mailToadd : mailToAddresses){     
                                                
                        if(oppTeamRec.Role__r.Name == UtilConstants.TECHNICAL_ARCHITECT )
                                    {
                                         myCS1= Email_Template__c.getValues(UtilConstantsR3.INTIMATE_PMO_TECH_ARCH);
                                        String myCCVal = myCS1.ID__c;  
                                        mail = new Messaging.SingleEmailMessage();
                                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                                        mail.setWhatId(oppTeamRec.id) ;
                                        mail.setTargetObjectId(userId) ;
                                        mail.setToAddresses(userEmailId);
                                        mail.setCCAddresses(UtilUser.getUserEmail(oppTeamRec.Requestor__c));
                                        mail.setTemplateId(myCCVal);
                                        mail.saveAsActivity=false;
                                        allMails.add( mail ); 
                                        /*myCS1= Email_Template__c.getValues(UtilConstants.INTIMATE_PMO);
                                        String myCCVal = myCS1.ID__c;  
                                        mail = new Messaging.SingleEmailMessage();
                                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                                        mail.setWhatId(oppTeamRec.id) ;
                                        mail.setTargetObjectId(userId) ;
                                        mail.setToAddresses(userEmailId);
                                        mail.setCCAddresses(UtilUser.getUserEmail(oppTeamRec.Requestor__c));
                                        mail.setTemplateId(myCCVal);
                                        mail.saveAsActivity=false;
                                        allMails.add( mail );   */                    
                                    }
                                    else if(oppTeamRec.Role__r.Name ==Label.Mobilization_Architect)
                                    {   
                                        myCS1= Email_Template__c.getValues(UtilConstants.INTIMATE_PMO_MOB_ARCH);
                                        String myCCVal = myCS1.ID__c;  
                                        mail = new Messaging.SingleEmailMessage();
                                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                                        mail.setWhatId(oppTeamRec.id) ;
                                        mail.setTargetObjectId(userId) ;
                                        mail.setToAddresses(userEmailId);
                                        mail.setCCAddresses(UtilUser.getUserEmail(oppTeamRec.Requestor__c));
                                        mail.setTemplateId(myCCVal);
                                        mail.saveAsActivity=false;
                                        allMails.add( mail ); 
                                        
                                    }
                                    else if(oppTeamRec.Role__r.Name == Label.DMAT_User_Profile){
                                        system.debug('Inside DMAT Mail');
                                        
                                        myCS1= Email_Template__c.getValues(UtilConstants.INTIMATE_PMO_DMAT_USER);
                                        String myCCVal = myCS1.ID__c;  
                                        system.debug('myCCVal--'+myCCVal);
                                        mail = new Messaging.SingleEmailMessage();
                                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                                        mail.setWhatId(oppTeamRec.id) ;
                                        mail.setTargetObjectId(userId) ;
                                        mail.setToAddresses(userEmailId);
                                        mail.setCCAddresses(UtilUser.getUserEmail(oppTeamRec.Requestor__c));
                                        mail.setTemplateId(myCCVal);
                                        mail.saveAsActivity=false;
                                        allMails.add( mail ); 
                                        
                                    
                                    }
                                    else{
                                        myCS1= Email_Template__c.getValues(UtilConstants.INTIMATE_PMO);
                                        String myCCVal = myCS1.ID__c;  
                                        mail = new Messaging.SingleEmailMessage();
                                        mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                                        mail.setWhatId(oppTeamRec.id) ;
                                        mail.setTargetObjectId(userId) ;
                                        mail.setToAddresses(userEmailId);
                                        mail.setCCAddresses(UtilUser.getUserEmail(oppTeamRec.Requestor__c));
                                        mail.setTemplateId(myCCVal);
                                        mail.saveAsActivity=false;
                                        allMails.add( mail );    
                                    }                       
                                                
                              //}
                               // }
                }
                System.debug('TOAddresses>>> ' + userEmailId);
                Messaging.sendEmail(allMails);
                }
                Catch(Exception e)
                {
                     System.debug('E==='+e);
                     string s=e.getMessage();
                }
                
                
    }
    /**
   *  @Description : This method is used to update opportunity record after PMO Action.
   *  @name : updateOppTeamAfterPMOUpdate
   *  @param : List<Opportunity_Teams__c> oppTeamIdAfterPMOUpdate
   *  @return parameter - void
   *  @throws exception- DML Exception
   */ 
    public static void updateOppTeamAfterPMOUpdate(List<Opportunity_Teams__c> oppTeamIdAfterPMOUpdate){

    List<Opportunity_Teams__c> onHoldList = new List<Opportunity_Teams__c>();
    List<Opportunity_Teams__c> assinedList = new List<Opportunity_Teams__c>();
    List<Opportunity_Teams__c> notFilledList = new List<Opportunity_Teams__c>();
    List<Opportunity_Teams__c> pendingReqstList = new List<Opportunity_Teams__c>();
    
    System_User_Id__c mcs = System_User_Id__c.getValues(UtilConstants.SYS_ID);
    
    Id devRecordTypeId = Schema.SObjectType.Opportunity_Teams__c.getRecordTypeInfosByName().get(UtilConstants.EDIT_OPP).getRecordTypeId();
        
       try{
            for(Opportunity_Teams__c oppTeamRec: oppTeamIdAfterPMOUpdate){
                 
                //////System.debug('oppTeamRec.Opportunity_Team_Member__c----------'+oppTeamRec.Opportunity_Team_Member__c);
                if(oppTeamRec.Team_Member_Request_Status__c.equalsIgnoreCase(UtilConstants.ONHOLD) && oppTeamRec.Opportunity_Team_Member__c == null){
                    
                    onHoldList.add(oppTeamRec);
                }   
                if(oppTeamRec.Team_Member_Request_Status__c.equals(UtilConstants.NOT_FILLED) && oppTeamRec.Opportunity_Team_Member__c == null){
                    
                    oppTeamRec.Request_Team_Member__c=false;
                    
                    if(oppTeamRec.Requestor__r.isSFDCUser__c == true){
                        oppTeamRec.ownerId=oppTeamRec.Requestor__r.user__c;
                    }
                    else if(oppTeamRec.Opportunity__r.Opportunity_Solution_Lead__r.isSFDCUser__c == true){
                        oppTeamRec.ownerId=oppTeamRec.Opportunity__r.Opportunity_Solution_Lead__r.user__c;
                    }
                    else{
                        oppTeamRec.ownerId = oppTeamRec.Opportunity__r.OwnerID;
                    }
                    oppTeamRec.RecordtypeId = devRecordTypeId;
                    notFilledList.add(oppTeamRec);
                }
                if(oppTeamRec.Team_Member_Request_Status__c.equals(UtilConstants.PENDING_CLARIFICATION) && oppTeamRec.Opportunity_Team_Member__c == null && (!oppTeamRec.Role__r.Name.equalsIgnoreCase(UtilConstants.TECHNICAL_ARCHITECT))){      
                                    system.debug('=======>> condition of pending clarification Line 1429');
                            oppTeamRec.Request_Team_Member__c=true;     
                                
                        system.debug('=======>> Owner change in pending request Line 1498' +oppTeamRec.Requestor__r.isSFDCUser__c);
                            if(oppTeamRec.Requestor__r.isSFDCUser__c == true){ 
                                
                                oppTeamRec.ownerId=oppTeamRec.Requestor__r.user__c;     
                            }       
                            else if(oppTeamRec.Opportunity__r.Opportunity_Solution_Lead__r.isSFDCUser__c == true){      
                                oppTeamRec.ownerId=oppTeamRec.Opportunity__r.Opportunity_Solution_Lead__r.user__c;      
                            }       
                            else{       
                                oppTeamRec.ownerId = oppTeamRec.Opportunity__r.OwnerID;     
                            } 
                        system.debug('requestor-------1486----------------->'+oppTeamRec.Requestor__r.user__c);
                        system.debug('owner--1486----------------->'+oppTeamRec.ownerid);              
              system.debug('pendingReqstList size---------1486----------------->'+pendingReqstList.size());
                            //oppTeamRec.RecordtypeId = devRecordTypeId; 
                            oppTeamRec.Team_Member_Request_Status__c = UtilConstants.PENDING_CLARIFICATION;
                            pendingReqstList.add(oppTeamRec);       
                   }
                            //pendingReqstList.add(oppTeamRec);       
                
                          
                else if(oppTeamRec.Opportunity_Team_Member__c != null){
                    if(oppTeamRec.Role__r.Name.equalsIgnoreCase(UtilConstants.TECHNICAL_ARCHITECT)){
                           oppTeamRec.Request_Team_Member__c=False;
                           //oppTeamRec.ownerId=oppTeamRec.Opportunity_Team_Member__r.user__c;
                           oppTeamRec.ownerId = oppTeamRec.Requestor__r.user__c;
                        }else{
                 oppTeamRec.ownerId=oppTeamRec.Requestor__r.user__c;
                                    if(oppTeamRec.Requestor__r.isSFDCUser__c == true){
                                        oppTeamRec.ownerId=oppTeamRec.Requestor__r.user__c;
                                    }
                                    else if(oppTeamRec.Opportunity__r.Opportunity_Solution_Lead__r.isSFDCUser__c == true){
                                        oppTeamRec.ownerId=oppTeamRec.Opportunity__r.Opportunity_Solution_Lead__r.user__c;
                                    }
                                    else{
                                        oppTeamRec.ownerId = oppTeamRec.Opportunity__r.OwnerID;
                                    }
                            
                              }      /*if(oppTeamRec.Role__r.Name.equalsIgnoreCase(UtilConstants.TECHNICAL_ARCHITECT)){        
                           oppTeamRec.Request_Team_Member__c=False;     
                        }*/
                    oppTeamRec.Team_Member_Request_Status__c=UtilConstants.ASSIGNED;
                    oppTeamRec.Assigned_Date__c=System.today();
                    assinedList.add(oppTeamRec);
                }
                else{
                }
            
         }
            if(oppTeamIdAfterPMOUpdate.size() > 0){
                database.update(oppTeamIdAfterPMOUpdate,true);
            }
            // If Recursive call happening comment the next line
            if(assinedList.size() > 0){
                sendAndUpdateAssignee(assinedList);
            }
            if(onHoldList.size() > 0 ){
                emailForOnHoldOrNotfilledReq(onHoldList);
            }
            if(notFilledList.size() > 0 ){
                emailForOnHoldOrNotfilledReq(notFilledList);
            }
       if(pendingReqstList.size() > 0 ){
                emailForPendingRqst(pendingReqstList);
            }           
       }
       catch(exception e){
            //////System.debug('-----------exception---'+e);
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,
                                            OPERATIONONOPPTEAMTRIGGERCONTROLLER , UPDATEOPPTEAMAFTERPMOUPDATE , OPERATIONONOPPTEAMTRIGGER , System.Logginglevel.ERROR);
       }
        
        
}
    /**
   *  @Description : This method is getting called from "Recall" button to recall the request sent to PMMO.
   *  @name : updateOppTeamAfterRecall
   *  @param : String recordid
   *  @return parameter - void
   *  @throws exception- DML Exception
   */ 
    webservice static void updateOppTeamAfterRecall(String recordid){
        
        List<Opportunity_Teams__c> recallList = new List<Opportunity_Teams__c>();
        
        Opportunity_Teams__c oppTeamIdAfterPMOUpdate = [SELECT Id, Name,Opportunity_Team_Member__r.isSFDCUser__c,ownerId,Opportunity_Team_Member__r.user__r.IsActive,
                                                    Team_Member_Request_Status__c,Opportunity__r.Opportunity_Solution_Lead__r.isSFDCUser__c,Request_Team_Member__c,Requestor__r.user__c,Requestor__c,
                                                    Requestor__r.user__r.Email,Requestor__r.isSFDCUser__c,Opportunity__r.ownerId,Role__r.HaveEditAccessOnOpportunity__c,Opportunity_Team_Member__r.name,
                                                    Opportunity__r.Opportunity_Solution_Lead__c, Offering__c,Offering__r.Offering_Solution_Lead_Primary__c,
                                                    Offering__r.Offering_Solution_Lead_Secondary__c, Role__r.name,Role__r.ShouldReceiveAlertMail__c, 
                                                    Opportunity_Team_Member__r.user__c,Opportunity_Team_Member__r.user__r.Email 
                                                    FROM Opportunity_Teams__c where id =: recordid limit 5000];
        //oppTeamIdAfterPMOUpdate.id = recordid;
        oppTeamIdAfterPMOUpdate.Request_Team_Member__c=false;
        //oppTeamIdAfterPMOUpdate.ownerId=oppTeamIdAfterPMOUpdate.Requestor__r.user__c;
        
        if(oppTeamIdAfterPMOUpdate.Requestor__r.isSFDCUser__c == true){
            oppTeamIdAfterPMOUpdate.ownerId=oppTeamIdAfterPMOUpdate.Requestor__r.user__c;
        }
        else if(oppTeamIdAfterPMOUpdate.Opportunity__r.Opportunity_Solution_Lead__r.isSFDCUser__c == true){
            oppTeamIdAfterPMOUpdate.ownerId=oppTeamIdAfterPMOUpdate.Opportunity__r.Opportunity_Solution_Lead__r.user__c;
        }
        else{
            oppTeamIdAfterPMOUpdate.ownerId = oppTeamIdAfterPMOUpdate.Opportunity__r.OwnerID;
        }
        oppTeamIdAfterPMOUpdate.Team_Member_Request_Status__c=UtilConstants.RECALL_STATUS;
        
        Id devRecordTypeId = Schema.SObjectType.Opportunity_Teams__c.getRecordTypeInfosByName().get(UtilConstants.EDIT_OPP).getRecordTypeId();
        oppTeamIdAfterPMOUpdate.RecordtypeId = devRecordTypeId;
        
        recallList.add(oppTeamIdAfterPMOUpdate);
        try{
            if(recallList.size() > 0){
                RecursiveTriggerHelper.run = false;
                database.update(recallList);
            }
            
            emailForCancelledReq(recallList);
        }
        catch(Exception e){
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,
                                                OPERATIONONOPPTEAMTRIGGERCONTROLLER , UPDATEOPPTEAMAFTERRECALL , OPERATIONONOPPTEAMTRIGGER , System.Logginglevel.ERROR);
        }
    }
    /**
   *  @Description : This method is getting called from "Follow Up" button to to follow up with PMMO.
   *  @name : sendMailOnFollowUp
   *  @param : String recordid
   *  @return parameter - void
   *  @throws exception- DML Exception
   */ 
    webservice static void sendMailOnFollowUp(String recordid){
        
        List <Opportunity_Teams__c> oppTeamCCA = new List <Opportunity_Teams__c>();
        List <Opportunity_Teams__c> oppTeamBSS = new List <Opportunity_Teams__c>();
        List <Opportunity_Teams__c> oppTeamSS = new List <Opportunity_Teams__c>();
        List <Opportunity_Teams__c> oppTeamMA = new List <Opportunity_Teams__c>();
        List <Opportunity_Teams__c> oppTeamTA = new List <Opportunity_Teams__c>();
        
        Opportunity_Teams__c oppTeamIdAfterPMOUpdate = [SELECT Id, Name,Opportunity_Team_Member__r.isSFDCUser__c,ownerId,Opportunity_Team_Member__r.user__r.IsActive,
                                                    Team_Member_Request_Status__c,Request_Team_Member__c,Requestor__r.user__c,Requestor__c,
                                                    Requestor__r.user__r.Email,Opportunity__r.ownerId,Role__r.HaveEditAccessOnOpportunity__c,Opportunity_Team_Member__r.name,
                                                    Opportunity__r.Opportunity_Solution_Lead__c, Offering__c,Offering__r.Offering_Solution_Lead_Primary__c,
                                                    Offering__r.Offering_Solution_Lead_Secondary__c, Role__r.name,Role__r.ShouldReceiveAlertMail__c, 
                                                    Opportunity_Team_Member__r.user__c,Opportunity_Team_Member__r.user__r.Email 
                                                    FROM Opportunity_Teams__c where id =: recordid limit 5000];
                                                    
            if(oppTeamIdAfterPMOUpdate.Role__r.name.equals(Label.Complex_Cost_Architect))
            {
                            oppTeamCCA.add(oppTeamIdAfterPMOUpdate);
            }
            if(oppTeamIdAfterPMOUpdate.Role__r.name.equals(Label.BSS_Architect))
            {
                            oppTeamBSS.add(oppTeamIdAfterPMOUpdate);
            }
            if(oppTeamIdAfterPMOUpdate.Role__r.name.equals(Label.Solution_Specialist))
            {
                            oppTeamSS.add(oppTeamIdAfterPMOUpdate);
            }
            if(oppTeamIdAfterPMOUpdate.Role__r.name.equals(Label.Mobilization_Architect))
            {
                            oppTeamMA.add(oppTeamIdAfterPMOUpdate);
            }
            if(oppTeamIdAfterPMOUpdate.Role__r.name.equals(Label.Technical_Architect))
            {
                            oppTeamTA.add(oppTeamIdAfterPMOUpdate);
            }
            if(oppTeamCCA.size()>0){
                            List<User> mailToUser = getEmailIds(Label.Complex_Cost_Architect_PMO_Group);
                            sendMailToPMOGroup(oppTeamCCA,mailToUser);
            }
            if(oppTeamBSS.size()>0){
                            List<User> mailToUser = getEmailIds(Label.BSS_Architect_PMO_Group);
                            sendMailToPMOGroup(oppTeamBSS,mailToUser);
            }
            if(oppTeamSS.size()>0){
                            List<User> mailToUser = getEmailIds(Label.Solution_Specialist_PMO_group);
                            sendMailToPMOGroup(oppTeamSS,mailToUser);
            }
            if(oppTeamMA.size()>0){
                            List<User> mailToUser = getEmailIds(Label.Mobilization_Architect_PMO_Group);
                            sendMailToPMOGroup(oppTeamMA,mailToUser);
            }
            if(oppTeamTA.size()>0){
                            List<User> mailToUser = getEmailIds(Label.Technical_Architect_PMO_Group);
                            sendMailToPMOGroup(oppTeamTA,mailToUser);
            }
        
    }
    /**
   *  @Description : This method is used to send mail for cancelled request.
   *  @name : emailForCancelledReq
   *  @param : List<Opportunity_Teams__c> oppTeamIdsToAssign
   *  @return parameter - void
   *  @throws exception- DML Exception
   */ 
    public static void emailForCancelledReq(List<Opportunity_Teams__c> oppTeamIdsToAssign)
    {
        getuserMasterMap();
        List<opportunity> oppListToUpdate = new List<opportunity>();
        Boolean CCA = false;
        Boolean BSS = false;
        Boolean SS = false;
        Boolean MA = false;
        Boolean TA = false;
        //Map<Id,>
        //List<String> userEmailId;
        String orgWideEmailAddressID=UtilEmail.emailid();
        
        try{
                        List<User> mailToUser = new List<User>();
                        Email_Template__c myCS1;
                        Messaging.SingleEmailMessage mail;
                        
                        for(Opportunity_Teams__c oppteamRec : oppTeamIdsToAssign){
                            if(oppteamRec.Role__r.name.equals(Label.Complex_Cost_Architect))
                            {
                                CCA = true;
                            }
                            if(oppteamRec.Role__r.name.equals(Label.BSS_Architect))
                            {
                                BSS = true;
                            }
                            if(oppteamRec.Role__r.name.equals(Label.Solution_Specialist))
                            {
                               SS = true;
                            }
                            if(oppteamRec.Role__r.name.equals(Label.Mobilization_Architect))
                            {
                                MA = true;
                            }
                            if(oppteamRec.Role__r.name.equals(Label.Technical_Architect))
                            {
                                TA = true;
                            }
                        }
                        if(CCA)
                            {
                                ////System.debug('-------cca----'+Label.Complex_Cost_Architect_PMO_Group);
                                mailToUser = getEmailIds(Label.Complex_Cost_Architect_PMO_Group);
                                ////System.debug('-----mailToUser --cca----'+mailToUser );
                            }
                            if(BSS)
                            {
                                ////System.debug('-------cca----'+Label.Complex_Cost_Architect_PMO_Group);
                                mailToUser = getEmailIds(Label.BSS_Architect_PMO_Group);
                                ////System.debug('-----mailToUser --cca----'+mailToUser );
                            }
                            if(SS)
                            {
                                ////System.debug('Main Jahan rahun'+SS);
                                mailToUser = getEmailIds(Label.Solution_Specialist_PMO_group);
                            }
                            if(MA)
                            {   // //System.debug('Main Jahan bhi rahun'+MA);
                                mailToUser = getEmailIds(Label.Mobilization_Architect_PMO_Group);
                            }
                            if(TA)
                            {   // //System.debug('Teri Yaad, Saath hai:'+TA);
                                mailToUser = getEmailIds(Label.Technical_Architect_PMO_Group);
                            }
                            List<String> userEmailId = new List<string>();
                            String userId=UtilConstants.EMPTY_STRING;
                            for(User u : mailToUser){
                                if( userId.equals(UtilConstants.EMPTY_STRING)){
                                       userId = u.Id;
                                   }else{
                                       userEmailId.add(u.Email);
                                   }
                               }
                      
                        if( CCA || SS || MA || TA  || BSS){    
                            myCS1 = Email_Template__c.getValues(UtilConstants.INTIMATE_PMO_NEW);
                            //System.debug('-----myCS1 --cca----'+myCS1 );
                            String myCCVal = myCS1.ID__c;
                            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                            for(Opportunity_Teams__c oppteamRec : oppTeamIdsToAssign){
                                //System.debug('--------TeamUserID.get(oppTeamRec.Requestor__c).email__c--------'+TeamUserID.get(oppTeamRec.Requestor__c).user__r.EMAIL);
                                //userEmailId = new List<String>(); 
                              //  for(User u : mailToUser){
                                    mail = new Messaging.SingleEmailMessage();
                                    mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                                    mail.setWhatId(oppTeamRec.id) ;
                                    //System.debug('************'+userId);
                                    mail.setTargetObjectId(userId) ;
                                    mail.setToAddresses(userEmailId);
                                    //mail.setTemplateId('00Xc0000000MaGx');
                                    mail.setCCAddresses(new List<String>{TeamUserID.get(oppTeamRec.Requestor__c).user__r.EMAIL});
                                    mail.setTemplateId(myCCVal);
                                    mail.saveAsActivity=false;                      
                                    emails.add(mail);
                               // }
                            
                            }
                            Messaging.sendEmail(emails);
                        }
               }         
        
        catch(Exception e){
           //System.debug('ERROR:' + e);
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,
                                        OPERATIONONOPPTEAMTRIGGERCONTROLLER , EMAILFORCANCELLEDREQ , OPERATIONONOPPTEAMTRIGGER , System.Logginglevel.ERROR);
        }
    }
    /**
   *  @Description : This method is used to send mail for on hold and not filled requests.
   *  @name : emailForOnHoldOrNotfilledReq
   *  @param : List<Opportunity_Teams__c> oppTeamIdsToAssign
   *  @return parameter - void
   *  @throws exception- DML Exception
   */ 
     public static void emailForOnHoldOrNotfilledReq(List<Opportunity_Teams__c> oppTeamIdsToAssign)
    {

        List<String> userEmailId = new List<String>();
        Boolean CCAGroup = false;
        Boolean BSSGroup = false;
        Boolean SSGroup = false;
        Boolean MAGroup = false;
        Boolean TAGroup = false;
        String orgWideEmailAddressID=UtilEmail.emailid();

        try{
                
                List<User> mailToUser = new List<User>();
                Email_Template__c myCS1;
                Messaging.SingleEmailMessage mail ;
                userEmailId = new List<String>();
                
                for(Opportunity_Teams__c oppteamRec : oppTeamIdsToAssign){
                    if(oppteamRec.Role__r.name.equals(UtilConstants.COM_COST_ARCH))
                    {    CCAGroup =true;

                    }
                    if(oppteamRec.Role__r.name.equals(UtilConstants.BSS_ARCH))
                    {    BSSGroup =true;

                    }
                    if(oppteamRec.Role__r.name.equals(UtilConstants.SOL_SPEC))
                    {    SSGroup = true;
                        
                    }
                    if(oppteamRec.Role__r.name.equals(Label.Mobilization_Architect))
                    {    MAGroup = true;
                        
                    }
                    if(oppteamRec.Role__r.name.equals(Label.Technical_Architect))
                    {    TAGroup = true;
                        
                    }
                
                }
                if( SSGroup ){
                    mailToUser = getEmailIds(UtilConstants.SSPG);
                }
                if( BSSGroup ){
                    mailToUser = getEmailIds(UtilConstants.BSSPG);
                }
                if( CCAGroup ){
                    mailToUser = getEmailIds(UtilConstants.CCAPG);
                }
                if( MAGroup ){
                    mailToUser = getEmailIds(UtilConstants.MAPG);
                }
                if( TAGroup ){
                    mailToUser = getEmailIds(UtilConstants.TAPG);
                }
                
                for(User u : mailToUser){
                    userEmailId.add(u.Email);
                } 
                for(Opportunity_Teams__c oppteamRec : oppTeamIdsToAssign){
                    
                    myCS1 = Email_Template__c.getValues(UtilConstants.REQ_ASSIGN);
                    String myCCVal = myCS1.ID__c;  
                     
                    mail = new Messaging.SingleEmailMessage();
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                    mail.setWhatId(oppTeamRec.id) ;
                    mail.setTargetObjectId(TeamUserID.get(oppTeamRec.Requestor__c).user__r.id) ;
                    mail.setCCAddresses(userEmailId);
                    mail.setTemplateId(myCCVal);
                    mail.saveAsActivity=false;                      
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
                }
                            
                            
            }
            catch(Exception e){
                //System.debug('ERROR:' + e);
                UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,
                                            OPERATIONONOPPTEAMTRIGGERCONTROLLER , EMAILFORONHOLDORNOTFILLEDREQ , OPERATIONONOPPTEAMTRIGGER , System.Logginglevel.ERROR);
            }
    }
    /**
   *  @Description : This method is getting called when PMO change status to Pending Claification status
   *  @name : emailForPendingRqst
   *  @param : Opportunity Team record List
   *  @return parameter - void
   *  @throws exception- DML Exception
   */ 
    public static void emailForPendingRqst(List<Opportunity_Teams__c> oppTeamIdsToAssign)       
    {       
        //system.debug('Hey!! I can See U');      
        system.debug('List which get after PMO  function in Pending request' +oppTeamIdsToAssign);      
                
        List<String> userEmailId = new List<String>();      
        Boolean CCAGroup = false;       
        Boolean SSGroup = false;        
        Boolean MAGroup = false;        
        //Boolean TAGroup = false;      
        String orgWideEmailAddressID=UtilEmail.emailid();       
        try{        
                        
                List<User> mailToUser = new List<User>();       
                Email_Template__c myCS1;        
                Messaging.SingleEmailMessage mail ;     
                userEmailId = new List<String>();       
                        
                for(Opportunity_Teams__c oppteamRec : oppTeamIdsToAssign){      
                    if(oppteamRec.Role__r.name.equals(UtilConstants.COM_COST_ARCH))     
                    {    CCAGroup =true;        
                    }       
                    if(oppteamRec.Role__r.name.equals(UtilConstants.SOL_SPEC))      
                    {    SSGroup = true;        
                                
                    }       
                    if(oppteamRec.Role__r.name.equals(Label.Mobilization_Architect))        
                    {    MAGroup = true;        
                                
                    }       
                    /*if(oppteamRec.Role__r.name.equals(Label.Technical_Architect))     
                    {    TAGroup = true;        
                                
                    }*/     
                        
                }       
                if( SSGroup ){      
                    mailToUser = getEmailIds(UtilConstants.SSPG);       
                }       
                if( CCAGroup ){     
                    mailToUser = getEmailIds(UtilConstants.CCAPG);      
                    system.debug('CCA group all Email Ids===================>>'+mailToUser);        
                }       
                if( MAGroup ){      
                    mailToUser = getEmailIds(UtilConstants.MAPG);       
                }       
                /*if( TAGroup ){        
                    mailToUser = getEmailIds(UtilConstants.TAPG);       
                }*/     
                        
                for(User u : mailToUser){       
                    userEmailId.add(u.Email);       
                    system.debug('UsermailIds all in CC===================>>'+userEmailId);     
                }       
                for(Opportunity_Teams__c oppteamRec : oppTeamIdsToAssign){      
                            
                    myCS1 = Email_Template__c.getValues(UtilConstants.EMAIL_TO_REQSTR_FOR_CLARIFICATION);       
                    String myCCVal = myCS1.ID__c;       
                            
                    mail = new Messaging.SingleEmailMessage();      
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressID);       
                    mail.setWhatId(oppTeamRec.id) ;     
                    mail.setTargetObjectId(TeamUserID.get(oppTeamRec.Requestor__c).user__r.id) ;        
                    system.debug('Requester Ids============>>'+TeamUserID.get(oppTeamRec.Requestor__c).user__r.id);     
                    //mail.setCCAddresses(userEmailId);       
                    mail.setTemplateId(myCCVal);        
                    mail.saveAsActivity=false;          
                    system.debug('All there in One mail============>>'+mail);       
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });       
                        
                }       
                                    
                                    
            }       
            catch(Exception e){     
                System.debug('ERROR:' + e);       
                UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,     
                                            OPERATIONONOPPTEAMTRIGGERCONTROLLER , EMAILFORONHOLDORNOTFILLEDREQ ,OPERATIONONOPPTEAMTRIGGER , System.Logginglevel.ERROR);     
            }       
    }
    /**
   *  @Description : This method is getting called upon deletion of opp 
                    team record to update opportunity,solution scope,Gov data,commercial team records.
   *  @name : updateGovDataReq
   *  @param : List<Opportunity_Teams__c> oppTeamIdsToAssign
   *  @return parameter - void
   *  @throws exception- DML Exception
   */ 
    public static void updateGovDataReq(List<Opportunity_Teams__c> oppTeamIdsToAssign)
    {
    
            system.debug('updateGovDataReq');
        
        List<Solution_Scope__c> solScopeListToUpdateOSLP= new List<Solution_Scope__c>();
        List<Solution_Scope__c> solScopeListToUpdateOSLS= new List<Solution_Scope__c>(); 
        List<Opportunity> oppListToUpdateCommTeam = new List<Opportunity>();
        List<Opportunity> oppListToUpdateSDGov= new List<Opportunity>();
        List<Opportunity> oppListToUpdatePrimeSDO = new List<Opportunity>();
        List<Opportunity> oppListToUpdateOSL = new List<Opportunity>();
        List<opportunity> oppListToUpdateSSAIO = new List<opportunity>();// 717 Vaishnavi
        List<opportunity> oppListToUpdateSSAIC = new List<opportunity>();// 717 Vaishnavi
        List<opportunity> oppListToUpdateSDGL = new List<opportunity>();// 717 Vaishnavi
        List<opportunity> oppListToUpdateCommLead = new List<opportunity>();//Vaishnavi
        List<opportunity> oppListToUpdateCPRAnlst = new List<opportunity>();//Vaishnavi
        List<opportunity> oppListToUpdateMobArch = new List<opportunity>();//Vaishnavi 
        List<opportunity> oppListToUpdateCapabilityLead = new List<opportunity>();//Vaishnavi 646
         List<opportunity>  oppListToUpdateTechArch = new List<opportunity>();
        List<opportunity> oppListToUpdateOfferingLead = new List<opportunity>();//Vaishnavi 646
        List<opportunity> oppListToUpdateIndusLead = new List<opportunity>();//Vaishnavi 646
        Set<Id> oppIds = new Set<Id>(); // Aswajit
        Map<ID, string> oppCapLeadNameMap = new Map<ID, string>();//Vaishnavi 646
        Map<ID, string> oppIndLeadNameMap = new Map<ID, string>();//Vaishnavi 646 
        Map<ID, string> oppOffLeadNameMap = new Map<ID, string>();//Vaishnavi 646
        List<opportunity> oppListToUpdateIS = new List<opportunity>();//Vaishnavi 
        
        List<Id> oppIdList = new List<Id>();
        List<Id> oppTeamIdList = new List<Id>();
        List<opportunity> oppListToUpdateCapabilityData = new List<opportunity>();
        
        for(Opportunity_Teams__c oppTeamRec : oppTeamIdsToAssign){  
            oppIdList.add(oppTeamRec.Opportunity__c);
            oppTeamIdList.add(oppTeamRec.id);
        }
        
        //Vaishnavi 646
        List<opportunity> opprList = [Select Id, Capability_Lead_Name_s__c, Industry_Lead_Name_s__c, Offering_Lead_Name_s__c from opportunity where ID IN : oppIdList];
        for(Opportunity opp:opprList)
        {
            oppCapLeadNameMap.put(opp.ID, opp.Capability_Lead_Name_s__c);
            oppIndLeadNameMap.put(opp.ID, opp.Industry_Lead_Name_s__c);
            oppOffLeadNameMap.put(opp.ID, opp.Offering_Lead_Name_s__c);
        }
     
        Map<Id,SD_Governance_Data__c> govdatamap = new Map<Id,SD_Governance_Data__c>();
        List<SD_Governance_Data__c> govdataListToUpdate = new List<SD_Governance_Data__c>();
        List<Commercial_Data__c> commdataListToUpdate = new List<Commercial_Data__c>();
       
         Map<Id,Commercial_Data__c> commDataMap = new Map<Id,Commercial_Data__c>();
         for(Commercial_Data__c commData : [select id,Active__c,name,opportunity__c from Commercial_Data__c Limit 5000]){
                    commDataMap.put(commData.opportunity__c,commData);
            }
        for(SD_Governance_Data__c govRec : [select id,name,Active__c,Opportunity__c from SD_Governance_Data__c where Opportunity__c IN : oppIdList Limit 5000]){
            
            govdatamap.put(govRec.Opportunity__c,govRec);
            
        }
        
          List<Capability_Involvement__c> capabilityListtoUpdate = new List<Capability_Involvement__c>();    
        Capability_Involvement__c capabilityObj;
        Map<String,Capability_Involvement__c> capabilityDataMap1 = new Map<String,Capability_Involvement__c>();
        Map<String,Capability_Involvement__c> capabilityDataMap = new Map<String,Capability_Involvement__c>();
        Map<id,id> oppSetId= new Map<id,id>(); 
        for(Capability_Involvement__c capabilityData : [select id,name,opportunity__c,user__C,  Opportunity_dev__c,opportunity_team__r.name from Capability_Involvement__c Limit 10000]){
                        if(capabilityData.opportunity_team__r.name!=null){
                        capabilityDataMap1.put(capabilityData.opportunity_team__r.name , capabilityData );}
                        String s =capabilityData.Opportunity_dev__c + ' '+ capabilityData.user__C;
                        capabilityDataMap.put(s,capabilityData);
                        system.debug('capabilityDataMap1-->'+capabilityDataMap1);
                        if(capabilityData.opportunity__c!=null){
                        oppSetId.put(capabilityData.id,capabilityData.opportunity__c);}
        }
        
        
        SD_Governance_Data__c govData;
        Commercial_Data__c commData;
        opportunity oppRec;
        Solution_Scope__c solScopeRec;
        Id optyIds;
        for(Opportunity_Teams__c oppteamRec : [SELECT Id, Name,Role__r.name,Role__r.ShouldReceiveAlertMail__c,Offering__c, 
                                                Opportunity__c,Opportunity__r.SD_Covered__c,Opportunity__r.SD_Governance_Lead_Assigned__c,
                                                Opportunity__r.Com_Lead_Assigned__c,Opportunity_Team_Member__r.name,
                                                Opportunity_Team_Member__r.user__c,Opportunity_Team_Member__r.user__r.Email, Opportunity__r.Max_Revenue_Dev__c,
                                                Opportunity__r.BPO_Net_Rev_Thousands__c,opportunity__r.Capability_Lead_Name_s__c, opportunity__r.Industry_Lead_Name_s__c, opportunity__r.Offering_Lead_Name_s__c,Opportunity__r.IO_Net_Revenue_Thousands__c, Opportunity__r.IC_Net_Rev_Thousands__c
                                                FROM Opportunity_Teams__c where id IN: oppTeamIdList Limit 5000]){
            
            oppIds.add(oppTeamRec.Opportunity__c);
            if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals(Label.Prime_SDO_Lead)){
                
                oppTeamRec.Opportunity__r.Prime_SDO_Lead_Assigned__c = false;
                oppTeamRec.Opportunity__r.Prime_SDO_Lead_dev__c = UtilConstants.BLANK_SPACE;
                oppListToUpdatePrimeSDO.add(oppTeamRec.Opportunity__r);
            }
            if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals('Prime Delivery Lead - IO')){
                
               oppTeamRec.Opportunity__r.Prime_SDO_Lead_Assigned__c = false;
                oppTeamRec.Opportunity__r.Prime_SDO_Lead_IO_dev__c = UtilConstants.BLANK_SPACE;
                oppListToUpdatePrimeSDO.add(oppTeamRec.Opportunity__r);
            }
            if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals('DMAT User')){
               optyIds =oppTeamRec.Opportunity__c;
               oppTeamRec.Opportunity__r.Dmat_User_Assigned__c = false;
               oppListToUpdatePrimeSDO.add(oppTeamRec.Opportunity__r);
            }
            if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals(Label.SD_Governance_Lead_Coach)){
                
                oppTeamRec.Opportunity__r.SD_Governance_Lead_Assigned__c = false;
                if(govdatamap.get(oppteamRec.Opportunity__c) != null){
                     govData = govdatamap.get(oppteamRec.Opportunity__c);
                    govData.Active__c = false;
                    
                    govdataListToUpdate.add(govData);
                }
                oppListToUpdateSDGov.add(oppTeamRec.Opportunity__r);
            }
            if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals(Label.Commercial_Team)){
                oppTeamRec.Opportunity__r.Com_Lead_Assigned__c = false;
                if(commDataMap.get(oppteamRec.Opportunity__c) != null){
                    commData = commDataMap.get(oppteamRec.Opportunity__c);
                    commData.Active__c = false;
                    commdataListToUpdate.add(commData);
                }
                oppListToUpdateCommTeam.add(oppTeamRec.Opportunity__r);
            }
           //added by Reena for capability Involvement
            if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals(UtilConstants.CAPABILITY_MEM)){
                List<id> opplist=new List<id>();
                
                Boolean flag=false;
                
                if(capabilityDataMap1.get(oppteamRec.name) != null){
                    capabilityObj = capabilityDataMap1.get(oppteamRec.name);
                    capabilityObj.Active__c = false;
                    capabilityObj.Opportunity__c=null;
                    capabilityListtoUpdate.add(capabilityObj);
                    oppSetId.remove(capabilityObj.id);
                }
                  /*if(oppSetId.size()>0){
                  opplist=oppSetId.values();}
                  for(id i:opplist){
                  if(i==oppteamRec.Opportunity__c){
                  flag=true;
                  }
                  }
                  if(!flag){
                  oppTeamRec.Opportunity__r.Capability_Lead__c = false;                
                  }*/
                  String roleTeamMembers = null;
                    
                                     
                    oppRec = new opportunity();
                    oppRec.id = oppTeamRec.opportunity__c;
              
                roleTeamMembers = oppCapLeadNameMap.get(oppRec.id);
                System.debug('roleTeamMembers-->' + roleTeamMembers);
                if(roleTeamMembers !=null)
                {
                    System.debug('Role team member name is not null');
                    if(roleTeamMembers.contains(oppTeamRec.Opportunity_Team_Member__r.name+';'))
                    {
                        roleTeamMembers = roleTeamMembers.replace(oppTeamRec.Opportunity_Team_Member__r.name+';' , UtilConstants.EMPTY_STRING );
                    }
                    else
                    {
                        roleTeamMembers = roleTeamMembers.replace(oppTeamRec.Opportunity_Team_Member__r.name , UtilConstants.EMPTY_STRING );
                    }
                    System.debug('roleTeamMembers-->' + roleTeamMembers);
                    oppRec.Capability_Lead_Name_s__c  = roleTeamMembers;
                    System.debug(' oppRec.Capability_Lead_Name_s__c -->'+  oppRec.Capability_Lead_Name_s__c );
                }
                else
                {   System.debug('Role team member name is  null');
                    oppRec.Capability_Lead_Name_s__c  = null;
                }
                
                if(oppSetId.size()>0){
                  opplist=oppSetId.values();}
                  for(id i:opplist){
                  if(i==oppteamRec.Opportunity__c){
                  flag=true;
                  }
                  }
                  if(!flag){
                  oppRec.Capability_Lead__c = false;                
                  }
                
                System.debug(' oppRec.Capability_Lead_Name_s__c -->1776'+  oppRec.Capability_Lead_Name_s__c );
                //oppListToUpdateCapabilityLead.add(oppRec);
                //oppListToUpdateCapabilityData.add(oppTeamRec.Opportunity__r);
                oppListToUpdateCapabilityData.add(oppRec);
            }
            if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals(Label.Opportunity_Solution_Lead)){
                    oppRec = new opportunity();
                    oppRec.id = oppTeamRec.opportunity__c;
                    oppRec.Opportunity_Solution_Lead__c = null;
                    if(oppTeamRec.Opportunity__r.Max_Revenue_Dev__c == oppTeamRec.Opportunity__r.BPO_Net_Rev_Thousands__c)
                    {
                    oppRec.SD_Covered__c = UtilConstants.NO;
                    }
                    oppRec.Staffing_Status__c = utilconstants.EMPTY_STRING;
                    
                    oppListToUpdateOSL.add(oppRec);
                    
                 }
                 if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals(Label.CPR_Analyst)){
                    oppRec = new opportunity();
                    oppRec.id = oppTeamRec.opportunity__c;
                    oppRec.CPR_Analyst__c = null;
                                        
                    oppListToUpdateCPRAnlst.add(oppRec);
                    
                 }
                 if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals(Label.Mobilization_Architect)){
                    oppRec = new opportunity();
                    oppRec.id = oppTeamRec.opportunity__c;
                    oppRec.Mobilization_Architect__c = null;
                    
                    
                    oppListToUpdateMobArch.add(oppRec);
                    
                 }
                 if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals(Label.Commercial_Team)){
                    oppRec = new opportunity();
                    oppRec.id = oppTeamRec.opportunity__c;
                    oppRec.Commercial_Lead__c = null;
                    
                    
                    oppListToUpdateCommLead.add(oppRec);
                    
                 }
                 //Vaishnavi 646
                 if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals(Label.Industry_Lead)){
                    String roleTeamMembers;
                    
                                     
                    oppRec = new opportunity();
                    oppRec.id = oppTeamRec.opportunity__c;
                  
                    roleTeamMembers = oppIndLeadNameMap.get(oppRec.id);
                    System.debug('roleTeamMembers-->' + roleTeamMembers);
                    if(roleTeamMembers !=null)
                    {
                        System.debug('Role team member name is not null');
                        if(roleTeamMembers.contains(oppTeamRec.Opportunity_Team_Member__r.name+';'))
                        {
                            roleTeamMembers = roleTeamMembers.replace(oppTeamRec.Opportunity_Team_Member__r.name+';' , UtilConstants.EMPTY_STRING );
                        }
                        else
                        {
                            roleTeamMembers = roleTeamMembers.replace(oppTeamRec.Opportunity_Team_Member__r.name , UtilConstants.EMPTY_STRING );
                        }
                        System.debug('roleTeamMembers-->' + roleTeamMembers);
                        oppRec.Industry_Lead_Name_s__c = roleTeamMembers;
                        System.debug(' oppRec.Industry_Lead_Name_s__c-->'+  oppRec.Industry_Lead_Name_s__c);
                    }
                    else
                    {   System.debug('Role team member name is  null');
                        oppRec.Industry_Lead_Name_s__c = null;
                    }
                    
                    System.debug(' oppRec.Industry_Lead_Name_s__c-->1776'+  oppRec.Industry_Lead_Name_s__c);
                    oppListToUpdateIndusLead.add(oppRec);
                    
                 }
                 /*if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals(Label.Capability_Lead)){
                    String roleTeamMembers;
                    
                                     
                    oppRec = new opportunity();
                    oppRec.id = oppTeamRec.opportunity__c;
                  
                    roleTeamMembers = oppCapLeadNameMap.get(oppRec.id);
                    System.debug('roleTeamMembers-->' + roleTeamMembers);
                    if(roleTeamMembers !=null)
                    {
                        System.debug('Role team member name is not null');
                        if(roleTeamMembers.contains(oppTeamRec.Opportunity_Team_Member__r.name+';'))
                        {
                            roleTeamMembers = roleTeamMembers.replace(oppTeamRec.Opportunity_Team_Member__r.name+';' , UtilConstants.EMPTY_STRING );
                        }
                        else
                        {
                            roleTeamMembers = roleTeamMembers.replace(oppTeamRec.Opportunity_Team_Member__r.name , UtilConstants.EMPTY_STRING );
                        }
                        System.debug('roleTeamMembers-->' + roleTeamMembers);
                        oppRec.Capability_Lead_Name_s__c  = roleTeamMembers;
                        System.debug(' oppRec.Capability_Lead_Name_s__c -->'+  oppRec.Capability_Lead_Name_s__c );
                    }
                    else
                    {   System.debug('Role team member name is  null');
                        oppRec.Capability_Lead_Name_s__c  = null;
                    }
                    
                    System.debug(' oppRec.Capability_Lead_Name_s__c -->1776'+  oppRec.Capability_Lead_Name_s__c );
                    oppListToUpdateCapabilityLead.add(oppRec);
                    
                 }*/
                 if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals(Label.Offering_Lead)){
                    String roleTeamMembers;
                    
                                     
                    oppRec = new opportunity();
                    oppRec.id = oppTeamRec.opportunity__c;
                  
                    roleTeamMembers = oppOffLeadNameMap.get(oppRec.id);
                    System.debug('roleTeamMembers-->' + roleTeamMembers);
                    if(roleTeamMembers !=null)
                    {
                        System.debug('Role team member name is not null');
                        if(roleTeamMembers.contains(oppTeamRec.Opportunity_Team_Member__r.name+';'))
                        {
                            roleTeamMembers = roleTeamMembers.replace(oppTeamRec.Opportunity_Team_Member__r.name+';' , UtilConstants.EMPTY_STRING );
                        }
                        else
                        {
                            roleTeamMembers = roleTeamMembers.replace(oppTeamRec.Opportunity_Team_Member__r.name , UtilConstants.EMPTY_STRING );
                        }
                        System.debug('roleTeamMembers-->' + roleTeamMembers);
                        oppRec.Offering_Lead_Name_s__c = roleTeamMembers;
                        System.debug(' oppRec.Offering_Lead_Name_s__c-->'+  oppRec.Offering_Lead_Name_s__c);
                    }
                    else
                    {   System.debug('Role team member name is  null');
                        oppRec.Offering_Lead_Name_s__c = null;
                    }
                    
                    System.debug(' oppRec.Offering_Lead_Name_s__c-->1776'+  oppRec.Offering_Lead_Name_s__c);
                    oppListToUpdateOfferingLead.add(oppRec);
                    
                 }
                 if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals(label.Lead_Solution_Architect_IO)){
                    oppRec = new opportunity();
                    oppRec.id = oppTeamRec.opportunity__c;
                    oppRec.IO_Solution_Architect__c = null;
                    if(oppTeamRec.Opportunity__r.Max_Revenue_Dev__c == oppTeamRec.Opportunity__r.IO_Net_Revenue_Thousands__c)
                    {
                    oppRec.SD_Covered__c = UtilConstants.NO;
                    }
                    
                    oppListToUpdateIS.add(oppRec);
                    
                 }
                 if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals((label.Lead_Solution_Architect_IC))){
                    oppRec = new opportunity();
                    oppRec.id = oppTeamRec.opportunity__c;
                    oppRec.IC_Solution_Architect__c = null;
                    if(oppTeamRec.Opportunity__r.Max_Revenue_Dev__c == oppTeamRec.Opportunity__r.IC_Net_Rev_Thousands__c)
                    {
                    oppRec.SD_Covered__c = UtilConstants.NO;
                    }
                    
                    oppListToUpdateIS.add(oppRec);
                    
                 }
                 if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals(Label.Offering_Solution_Lead_Primary)){
                    solScopeRec = new Solution_Scope__c();
                    solScopeRec.id = oppTeamRec.Offering__c;
                    solScopeRec.Offering_Solution_Lead_Primary__c = null;
                    solScopeListToUpdateOSLP.add(solScopeRec);
                    
                 }
                 if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals(Label.Offering_Solution_Lead_Secondary)){
                    solScopeRec = new Solution_Scope__c();
                    solScopeRec.id = oppTeamRec.Offering__c;
                    solScopeRec.Offering_Solution_Lead_Secondary__c = null;
                    solScopeListToUpdateOSLS.add(solScopeRec);
                    
                 }
                 if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals(Label.Support_Solution_Architect_IO)){
                    oppRec = new opportunity();
                    oppRec.id = oppTeamRec.opportunity__c;
                    oppRec.Support_Solution_Architect_IO__c = null;
                    oppListToUpdateSSAIO.add(oppRec);
                    
                 }
                 if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals(Label.Support_Solution_Architect_IC)){
                    oppRec = new opportunity();
                    oppRec.id = oppTeamRec.opportunity__c;
                    oppRec.Support_Solution_Architect_IC__c = null;
                    oppListToUpdateSSAIC.add(oppRec);
                    
                 }
                 if(oppTeamRec.Role__r.name != null && oppTeamRec.Role__r.name.Equals(Label.SD_Governance_Lead)){
                    oppRec = new opportunity();
                    oppRec.id = oppTeamRec.opportunity__c;
                    oppRec.SD_Governance_Lead__c = null;
                    oppListToUpdateSDGL.add(oppRec);
                    
                 }

        } 
        try{

            if(oppListToUpdateCommTeam.size() > 0){
                update oppListToUpdateCommTeam;
            }
            if(oppListToUpdateOSL.size() > 0){
                update oppListToUpdateOSL;
            }
            if(oppListToUpdateCPRAnlst.size() > 0){
                update oppListToUpdateCPRAnlst;
            }
            if(oppListToUpdateMobArch.size() > 0){
                update oppListToUpdateMobArch;
            }
            if(oppListToUpdateCommLead.size() > 0){
                update oppListToUpdateCommLead;
            }
            /*if(oppListToUpdateCapabilityLead.size() > 0){
                system.debug('oppListToUpdateCapabilityLead  size is greater than 0');
                system.debug('oppListToUpdateCapabilityLead  size is greater than 0' +oppListToUpdateCapabilityLead[0].Capability_Lead_Name_s__c);
                update oppListToUpdateCapabilityLead;
                
                List<Opportunity> opp = [SELECT Id,Capability_Lead_Name_s__c  FROM Opportunity WHERE ID IN :oppListToUpdateCapabilityLead];
                System.debug('Opp Updated>>> ' + opp);
            }*/
            if(oppListToUpdateIndusLead.size() > 0){
                update oppListToUpdateIndusLead;
            }
            if(oppListToUpdateOfferingLead.size() > 0){
                update oppListToUpdateOfferingLead;
            }
            if(oppListToUpdateIS.size() > 0){
                update oppListToUpdateIS;
            }
            if(oppListToUpdateSDGov.size() > 0){
                update oppListToUpdateSDGov;
            }
            //Added by Yasin for dmat 
            if(oppListToUpdatePrimeSDO.size() > 0){
               List<Opportunity_Teams__c> optTeam = [SELECT Id,Role__r.name,Opportunity__c FROM Opportunity_Teams__c WHERE Opportunity__c =: optyIds AND Role__r.name =: 'DMAT User' Limit 5000];
                if(optTeam.size() > 1){
                     List<Opportunity> opt = oppListToUpdatePrimeSDO;
                     oppListToUpdatePrimeSDO = new List<Opportunity>(); 
                     for(Opportunity opty : opt){
                        if(opty.Id == optyIds){
                            opty.Dmat_User_Assigned__c = true;
                        }
                        oppListToUpdatePrimeSDO.add(opty);
                     }
                     update oppListToUpdatePrimeSDO;
                }else{
                     update oppListToUpdatePrimeSDO;
                }
            }
            if(govdataListToUpdate.size() > 0){
                update govdataListToUpdate;
            }
            if(commdataListToUpdate.size() > 0){
                update commdataListToUpdate;
            }
            if(solScopeListToUpdateOSLP.size() > 0){
                update solScopeListToUpdateOSLP;
            }
            if(solScopeListToUpdateOSLS.size() > 0){
                update solScopeListToUpdateOSLS;
            }
            if(oppListToUpdateSSAIO.size() > 0){
                update oppListToUpdateSSAIO;
            }
            if(oppListToUpdateSSAIC.size() > 0){
                update oppListToUpdateSSAIC;
            }
            if(oppListToUpdateSDGL.size() > 0){
                update oppListToUpdateSDGL;
            }
            if(oppListToUpdateCapabilityData.size() > 0){
                update oppListToUpdateCapabilityData;
            }
            
            if(capabilityListtoUpdate.size() > 0){
                update capabilityListtoUpdate;
            }
            if(oppIds != null){
                doCapabilityLeadCount(oppIds);
            }
            
            oppListToUpdateCommTeam.clear();
            oppListToUpdateOSL.clear();
            oppListToUpdateIS.clear();
            oppListToUpdateCPRAnlst.clear();
            oppListToUpdateMobArch.clear();
            oppListToUpdateCommLead.clear();
            oppListToUpdateCapabilityLead.clear();
            oppListToUpdateIndusLead.clear();
            oppListToUpdateOfferingLead.clear();
            oppListToUpdateSDGov.clear();
            oppListToUpdatePrimeSDO.clear();
            solScopeListToUpdateOSLS.clear();
            solScopeListToUpdateOSLP.clear();
            capabilityListtoUpdate.clear();
            oppListToUpdateSSAIO.clear();
            oppListToUpdateSSAIC.clear();
            oppListToUpdateSDGL.clear();
            
        }
        catch(Exception e){
                System.debug('ERROR:' + e);
                ExceptionClass.logException('operationOnOppTeamTriggerController','operationOnOppTeamTriggerController',e,'Opportunity Team','Opportunity Team');
                UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,
                                            OPERATIONONOPPTEAMTRIGGERCONTROLLER , UPDATEGOVDATAREQ , OPERATIONONOPPTEAMTRIGGER , System.Logginglevel.ERROR);
            }
        
    }
    /**
       *  @Description This method is used to insert utilization records
       *  @name insertUtilizationRecords
       *  @param List<Opportunity_Teams__c> oppTeamNewList
       *  @return parameter - void
       *  @throws exception-DML Exception
    */
    public static void insertUtilizationRecords(List<Opportunity_Teams__c> oppTeamNewList) {
    
    try{
        String KeyUnique;
        String keyField;
        String exsistingKeyfield; 
        set<String> keyFieldSet = new set<String>();
        set<String> exsistingKeyfieldSet = new set<String>();
        set<Id> userMasterIdsSet = new set<Id>();
        set<Id> opportunityIdsSet = new set<Id>();
        List<Utilizations__c> utilizationListToInsert = new List<Utilizations__c>();
        List<Opportunity_Teams__c> oppTeamList = new List<Opportunity_Teams__c>();
        Utilizations__c utilizationObject;
        Map<String, String> keyToMapName = new Map<String, String>();
        
        for(Opportunity_Teams__c oppTeamRecord : oppTeamNewList) {
            if(oppTeamRecord.Opportunity_Team_Member__c != null && oppTeamRecord.Opportunity__c != null) {
                keyField = oppTeamRecord.Opportunity__c + SEPERATOR + oppTeamRecord.Opportunity_Team_Member__c;
                keyFieldSet.add(keyField);
                userMasterIdsSet.add(oppTeamRecord.Opportunity_Team_Member__c);
                opportunityIdsSet.add(oppTeamRecord.Opportunity__c);
                
            }
        }
        oppTeamList  = [Select id,Name,Opportunity__c,Opportunity__r.Name,Opportunity_Team_Member__c from Opportunity_Teams__c
                       where ID IN : oppTeamNewList Limit 5000];
        for(Opportunity_Teams__c oppTeamRecord : oppTeamList) {
            if(oppTeamRecord.Opportunity_Team_Member__c != null && oppTeamRecord.Opportunity__c != null) {
                KeyUnique = oppTeamRecord.Opportunity__c + SEPERATOR + oppTeamRecord.Opportunity_Team_Member__c;
                keyToMapName.put(KeyUnique,oppTeamRecord.Opportunity__r.Name);
            }    
        }
        
        for(Utilizations__c utilizationRecord : [select Opportunity__c, User__c from Utilizations__c where (Opportunity__c IN:opportunityIdsSet OR User__c IN:userMasterIdsSet) limit 4000]) {
           if(utilizationRecord.User__c != null && utilizationRecord.Opportunity__c != null) {
               exsistingKeyfield = utilizationRecord.Opportunity__c + SEPERATOR + utilizationRecord.User__c;
               exsistingKeyfieldSet.add(exsistingKeyfield);
           }
        }
        
        for(String key : keyFieldSet) {
           if(!exsistingKeyfieldSet.contains(key)) {
               String[] splittedIds = new String[]{};
               splittedIds = key.split(SEPERATOR);
               utilizationObject = new Utilizations__c(); 
               utilizationObject.Opportunity__c = splittedIds[0];
               utilizationObject.User__c = splittedIds[1];
               if(keyToMapName.get(key).length()>80){
                   utilizationObject.Name = keyToMapName.get(key).substring(0,67)+UtilConstants.BLANK_SPACE+UtilConstants.Utilizationstr;
               }
               else
               {
                   utilizationObject.Name = keyToMapName.get(key)+UtilConstants.BLANK_SPACE+UtilConstants.Utilizationstr;
               }
               utilizationObject.Current_week__c = 0;
               utilizationObject.Current_week_1__c = 0;
               utilizationObject.Current_week_2__c = 0;
               utilizationObject.Current_week_3__c = 0;
               utilizationObject.Current_week_4__c = 0; 
               utilizationListToInsert.add(utilizationObject);
           }
        }
        database.insert(utilizationListToInsert);
        
        }
        Catch(DMLException e)
        {
            //////System.debug('E==='+e);
            string s=e.getMessage();
        }
    }
/**
   *  @Description This method is used to update utilization records
   *  @name updateUtilizationRecords
   *  @param List<Opportunity_Teams__c> oppTeamNewList,List<Opportunity_Teams__c> oppTeamOldList
   *  @return parameter - void
   *  @throws exception-DML Exception
*/  
    public static void updateUtilizationRecords(List<Opportunity_Teams__c> oppTeamNewList,List<Opportunity_Teams__c> oppTeamOldList) {
    
    
    try{
        String KeyUnique;
        String keyField;
        String exsistingKeyfield; 
        String oldKeyField; 
        String KeyFieldForTeamRecord;
        set<String> keyFieldSet = new set<String>();
        set<String> exsistingKeyfieldSet = new set<String>();
        set<String> oldKeyFieldSet = new set<String>();
        set<String> KeyFieldSetForAllTeamRecords = new set<String>();
        set<String> keyFieldsToVerify = new set<String>();
        set<Id> userMasterIdsSet = new set<Id>();
        set<Id> opportunityIdsSet = new set<Id>();
        set<Id> oppIdSetToVerify = new set<Id>();
        set<Id> oppIdSetToVerifyforDeletion = new set<Id>();
        set<String> keyOfRecordsToDelete = new set<String>();
        List<Utilizations__c> utilizationListToInsert = new List<Utilizations__c>();
        List<Utilizations__c> utilizationListToDelete = new List<Utilizations__c>();
        List<Opportunity_Teams__c> oppTeamList = new List<Opportunity_Teams__c>();
        Map<String, String> keyToMapName = new Map<String, String>();
        Utilizations__c utilizationObject;
        Map<String, Utilizations__c> keyToUtilizationMapped = new Map<String, Utilizations__c>();
    
    
        for(Opportunity_Teams__c oppTeamRecord : oppTeamNewList) {
                if(oppTeamRecord.Opportunity_Team_Member__c != null && oppTeamRecord.Opportunity__c != null) {
                    keyField = oppTeamRecord.Opportunity__c + SEPERATOR  + oppTeamRecord.Opportunity_Team_Member__c;
                    keyFieldSet.add(keyField);
                    userMasterIdsSet.add(oppTeamRecord.Opportunity_Team_Member__c);
                    opportunityIdsSet.add(oppTeamRecord.Opportunity__c);
                }
            }
            
            oppTeamList  = [Select id,Name,Opportunity__c,Opportunity__r.Name,Opportunity_Team_Member__c from Opportunity_Teams__c
                       where ID IN : oppTeamNewList Limit 5000];
        for(Opportunity_Teams__c oppTeamRecord : oppTeamList) {
            if(oppTeamRecord.Opportunity_Team_Member__c != null && oppTeamRecord.Opportunity__c != null) {
                KeyUnique = oppTeamRecord.Opportunity__c + SEPERATOR + oppTeamRecord.Opportunity_Team_Member__c;
                keyToMapName.put(KeyUnique,oppTeamRecord.Opportunity__r.Name);
            }    
        }
        
        for(Utilizations__c utilizationRecord : [select Opportunity__c, User__c from Utilizations__c where (Opportunity__c IN:opportunityIdsSet OR User__c IN:userMasterIdsSet)  limit 4000]) {
            if(utilizationRecord.User__c != null && utilizationRecord.Opportunity__c != null) {
                exsistingKeyfield = utilizationRecord.Opportunity__c + SEPERATOR  + utilizationRecord.User__c;
                exsistingKeyfieldSet.add(exsistingKeyfield);
            }
        }
        String[] splittedIds;
        for(String key : keyFieldSet) {
           if(!exsistingKeyfieldSet.contains(key)) {
               splittedIds = new String[]{};
               splittedIds = key.split(SEPERATOR );
               utilizationObject = new Utilizations__c(); 
               utilizationObject.Opportunity__c = splittedIds[0];
               utilizationObject.User__c = splittedIds[1];
               if(keyToMapName.get(key).length()>80){
                   utilizationObject.Name = keyToMapName.get(key).substring(0,67)+UtilConstants.BLANK_SPACE+UtilConstants.Utilizationstr;
               }
               else
               {
                   utilizationObject.Name = keyToMapName.get(key)+UtilConstants.BLANK_SPACE +UtilConstants.Utilizationstr;
               }
               utilizationObject.Current_week__c = 0;
               utilizationObject.Current_week_1__c = 0;
               utilizationObject.Current_week_2__c = 0;
               utilizationObject.Current_week_3__c = 0;
               utilizationObject.Current_week_4__c = 0; 
               utilizationListToInsert.add(utilizationObject);
           }
        }
        
        for(Opportunity_Teams__c oppTeamOldRecord : oppTeamOldList) {
            if(oppTeamOldRecord.Opportunity_Team_Member__c != null && oppTeamOldRecord.Opportunity__c != null) {
                oldKeyField = oppTeamOldRecord.Opportunity__c + SEPERATOR  + oppTeamOldRecord.Opportunity_Team_Member__c;
                oldKeyFieldSet.add(oldKeyField);                
            }
        }
        
        for(String key : oldKeyFieldSet) {
            if(!keyFieldSet.contains(key)) {
                keyFieldsToVerify.add(key);
                String[] oppId = key.split(SEPERATOR );
                oppIdSetToVerify.add(oppId[0]);
            }
        }
        
        for(Opportunity_Teams__c oppTeamRecord : [select Opportunity__c,Opportunity_Team_Member__c from Opportunity_Teams__c  where Opportunity__c IN :oppIdSetToVerify  limit 4000]) {
            if(oppTeamRecord.Opportunity_Team_Member__c != null && oppTeamRecord.Opportunity__c != null) {
                KeyFieldForTeamRecord = oppTeamRecord.Opportunity__c + SEPERATOR  + oppTeamRecord.Opportunity_Team_Member__c;
                KeyFieldSetForAllTeamRecords.add(KeyFieldForTeamRecord);                
            }            
        }
        
        for(String key : keyFieldsToVerify) {
            if(!KeyFieldSetForAllTeamRecords.contains(key)) {
                keyOfRecordsToDelete.add(key);
                String[] oppId = key.split(SEPERATOR );
                oppIdSetToVerifyforDeletion.add(oppId[0]);
            }
        }
        
        for(Utilizations__c utilizationRecordToCheck : [select Id, Opportunity__c, User__c from Utilizations__c where Opportunity__c IN:oppIdSetToVerifyforDeletion  limit 4000]) {
            if(utilizationRecordToCheck.Opportunity__c != null && utilizationRecordToCheck.User__c != null) {
                String mapKey = utilizationRecordToCheck.Opportunity__c + SEPERATOR  + utilizationRecordToCheck.User__c;   
                keyToUtilizationMapped.put(mapKey,utilizationRecordToCheck);
            }            
        }
        
        for(String keyToDelete :keyOfRecordsToDelete) {
            Utilizations__c utilizationRecordToDelete = keyToUtilizationMapped.get(keyToDelete);
            if(utilizationRecordToDelete != null) {
                utilizationListToDelete.add(utilizationRecordToDelete);
            }
        }
        database.insert(utilizationListToInsert);
        database.delete(utilizationListToDelete);   
    }
    Catch(DMLException e)
    
    {
    
               //////System.debug('E==='+e);
               string s=e.getMessage();
    }
    }
    
/**
   *  @Description This method is used to delete utilization records
   *  @name deleteUtilizationRecords
   *  @param List<Opportunity_Teams__c> oppTeamOldList
   *  @return parameter - void
   *  @throws exception-DML Exception
*/
    public static void deleteUtilizationRecords(List<Opportunity_Teams__c> oppTeamOldList) {
    
    
    try{
        String oldKeyField ; 
        String KeyFieldForTeamRecord;
        set<String> oldKeyFieldSet = new set<String>();
        set<String> KeyFieldSetForAllTeamRecords = new set<String>();
        set<Id> uniqueOpportunities = new set<Id>();
        set<Id> oppIdSetToVerify = new set<Id>();
        set<Id> oppIdSetToVerifyforDeletion = new set<Id>();
        set<String> keyOfRecordsToDelete = new set<String>();
        List<Utilizations__c> utilizationListToDelete = new List<Utilizations__c>();
        Utilizations__c utilizationObject;
        Map<String, Utilizations__c> keyToUtilizationMapped = new Map<String, Utilizations__c>();
        
        for(Opportunity_Teams__c oppTeamOldRecord : oppTeamOldList) {
            if(oppTeamOldRecord.Opportunity_Team_Member__c != null && oppTeamOldRecord.Opportunity__c != null) {
                oldKeyField = oppTeamOldRecord.Opportunity__c + SEPERATOR  + oppTeamOldRecord.Opportunity_Team_Member__c;
                oldKeyFieldSet.add(oldKeyField);
                uniqueOpportunities.add(oppTeamOldRecord.Opportunity__c);                
            }
        }
        
        for(Opportunity_Teams__c oppTeamRecord : [select Opportunity__c,Opportunity_Team_Member__c from Opportunity_Teams__c  where Opportunity__c IN :uniqueOpportunities  limit 4000]) {
            if(oppTeamRecord.Opportunity_Team_Member__c != null && oppTeamRecord.Opportunity__c != null) {
                KeyFieldForTeamRecord = oppTeamRecord.Opportunity__c + SEPERATOR  + oppTeamRecord.Opportunity_Team_Member__c;
                KeyFieldSetForAllTeamRecords.add(KeyFieldForTeamRecord);                
            }            
        }
        
        for(String key : oldKeyFieldSet) {
            if(!KeyFieldSetForAllTeamRecords.contains(key)) {
                keyOfRecordsToDelete.add(key);
                String[] oppId = key.split(SEPERATOR );
                oppIdSetToVerifyforDeletion.add(oppId[0]);
            }
        }
        
        for(Utilizations__c utilizationRecordToCheck : [select Id, Opportunity__c, User__c from Utilizations__c where Opportunity__c IN:oppIdSetToVerifyforDeletion  limit 40000]) {
            if(utilizationRecordToCheck.Opportunity__c != null && utilizationRecordToCheck.User__c != null) {
                String mapKey = utilizationRecordToCheck.Opportunity__c + SEPERATOR  + utilizationRecordToCheck.User__c;   
                keyToUtilizationMapped.put(mapKey,utilizationRecordToCheck);
            }            
        }
        
        for(String keyToDelete :keyOfRecordsToDelete) {
            Utilizations__c utilizationRecordToDelete = keyToUtilizationMapped.get(keyToDelete);
            if(utilizationRecordToDelete != null) {
                utilizationListToDelete.add(utilizationRecordToDelete);
                //////System.debug('-----utilizationListToDelete------'+utilizationListToDelete);
      
            }
        }
        
        if(utilizationListToDelete.size()>0){                    
            database.delete(utilizationListToDelete);
        } 
        
        }
        Catch(Exception e)
        
        {
                   //////System.debug('E==='+e);
                   string s=e.getMessage();
        
        }  
    }
 /**
   *  @Description This method is used to update roles in utilization records
   *  @name updateRoles
   *  @param List<Opportunity_Teams__c> oppTeamNewList
   *  @return parameter - void
   *  @throws exception-DML Exception
*/    
    public static void updateRoles(List<Opportunity_Teams__c> oppTeamNewList) {
    
    try{
        Set<Id> userId = new Set<Id>();
        Set<Id> oppId = new Set<Id>();
        Set<Id> roleId = new Set<Id>();
        Map<Id,String> roleNameMap = new Map<Id,String>();
        List<Utilizations__c> utilRecList = new List<Utilizations__c>();
        
        for(Opportunity_Teams__c oppTeamRecord : oppTeamNewList){
            if(oppTeamRecord.Opportunity_Team_Member__c != null && oppTeamRecord.Opportunity__c != null) {
                userId.add(oppTeamRecord.Opportunity_Team_Member__c);
                oppId.add(oppTeamRecord.Opportunity__c);
                roleId.add(oppTeamRecord.role__c);
            }       
        }
        List<Utilizations__c> utilizationRecordToCheck = [select Id, Opportunity__c, User__c,User_Role_s__c 
                                                        from Utilizations__c where Opportunity__c IN :oppId and
                                                        User__c IN : userId limit 40000]; 
                                                        
        List<Opportunity_Teams__c> oppTeamList = [Select id,Name,Role__c,Role__r.Name,Opportunity__c,Opportunity_Team_Member__c
                                                From Opportunity_Teams__c where Opportunity__c IN : oppId and 
                                                Opportunity_Team_Member__c IN : userId];
        if(utilizationRecordToCheck.size()>0 && oppTeamList.size()>0){
            String roleStringList = UtilConstants.EMPTY_STRING;
                for(Utilizations__c utilRec : utilizationRecordToCheck){
                for(Opportunity_Teams__c oppTeamRec : oppTeamList){
                    if(oppTeamRec.Opportunity__c.equals(utilRec.Opportunity__c) && oppTeamRec.Opportunity_Team_Member__c.equals(utilRec.User__c)){
                        roleStringList += UtilConstants.BLANK_SPACE +oppTeamRec.Role__r.Name +SEPERATOR_withspace;
                    }
                }
                utilRec.User_Role_s__c =  roleStringList;
                //.removeEnd(SEPERATOR);
                utilRecList.add(utilRec);
            }
        }
        if(utilRecList.size()>0){
        set<id> utilids = new set<id>();
            List<database.SaveResult> uresult = database.update(utilRecList,false);
            for(database.saveResult ss:uresult){
                if(ss.isSuccess()){
                   utilids.add(ss.getId()); 
                }
            }
            if(!utilids.isEmpty()){
                NewUtilizationController utilcleanUp = new NewUtilizationController();
                utilcleanUp.cleanUpDupRoles(utilids);
            }
        }
    }
    Catch(DMLException e)
    {
                   //////System.debug('E==='+e);
                   e.getmessage();
    }
    
    } 
    /**
   *  @Description This method is used to update roles in Solution scope records
   *  @name capabilityOfferingLeadInvolvement
   *  @param List<Opportunity_Teams__c> oppTeamNewList,Boolean variable
   *  @return parameter - void
   *  @throws exception-DML Exception
*/  
   public static void capabilityOfferingLeadInvolvement(List<Opportunity_Teams__c> oppTeams,Boolean isDelete){
       Map<Id,Solution_Scope__c> scopeToUpdateMap = new Map<Id,Solution_Scope__c>();
       Solution_Scope__c scope;
       for( Opportunity_Teams__c oppTeam : [Select Id,name,role__c,role__r.name,opportunity__r.Id,Offering__r.Id,Solution_Component__r.Id,Solution_Component__r.name from Opportunity_Teams__c where Id IN:oppTeams] ){
           if( oppTeam.role__c != null ){
               if( oppTeam.role__r.name.equalsignorecase('capability lead') || oppTeam.role__r.name.equalsignorecase('offering lead') ){
               //system.debug('(((((((('+isDelete+oppTeam.Offering__r.Id+oppTeam.Solution_Component__r.name);
                   if( !isDelete ){
                       scope = new Solution_Scope__c(Id=oppTeam.Offering__r.Id,Is_Capability_Offering_Lead_Assigned__c=true);
                   }else{
                   system.debug('After deletee...........'+oppTeam.id);
                       scope = new Solution_Scope__c(Id=oppTeam.Offering__r.Id,Is_Capability_Offering_Lead_Assigned__c=false);
                   }
                   scopeToUpdateMap.put( oppTeam.Offering__r.Id,scope );
               }
           }
       }
       if(!scopeToUpdateMap.values().isEmpty()){
           try{
               update scopeToUpdateMap.values();
           }catch(Exception E){
               String sheetThrowingException = UtilConstants.EMPTY_STRING;
               sheetThrowingException = E.getMessage() + E.getStackTraceString();
               throw (E);
           }
       }
   }
   
   /*Aswajit*/
   public static void doCapabilityLeadCount(Set<Id> oppIds){
        List<Opportunity> oppList = new List<Opportunity>();
        for (Opportunity oppRec: [Select Id, (Select id, Name FROM Opportunity_Team__r WHERE Role__r.Name='Capability Lead') FROM Opportunity where Id IN:oppIds]) {
            if(oppRec.Opportunity_Team__r.size() > 0) {
                oppRec.No_of_CLs__c= oppRec.Opportunity_Team__r.size();
                oppList.add(oppRec);
            }
        }
        if(oppList.size()> 0){
            update oppList;
        }
    }
  /**     
   *  @Description : This method is used check if the team member with Tech Lead Architect role is updated by Tech Architect or not        
   *  @name : updateOnTechArchLeadRole      
   *  @param : List<Opportunity_Teams__c> oppTeamnewList,List<Opportunity_Teams__c> oppTeamOldList      
   *  @return parameter - void      
   *  @throws exception- DML Exception      
   */           
 public static void updateOnTechArchLeadRole(List<Opportunity_Teams__c> oppTeamnewList,List<Opportunity_Teams__c> oppTeamOldList){        
            
     map<String,Id> roleAndMemberMapNew=new map<String,id>();       
     map<String,Id> roleAndMemberMapOld=new map<String,id>();       
     map<id,id>oppforloggedinuser=new map<id,id>();     
     set<id> loggedinUser=new set<id>();        
     set<id> oppid=new set<id>();       
     map<id,Id> loggedinusermap=new map<id,id>();       
     List<Opportunity_Teams__c> sendandupdate =new List<Opportunity_Teams__c>();        
     List<Opportunity_Teams__c> sendandupdateError =new List<Opportunity_Teams__c>();       
     //populating new map       
     for(Opportunity_Teams__c oppTeamRec:oppTeamnewList){       
         oppid.add(oppTeamRec.opportunity__c);      
        if(oppTeamRec.Opportunity_Team_Member__c!=null && oppTeamRec.Role__c!=null){        
            roleAndMemberMapNew.put(oppTeamRec.name+oppTeamRec.Role__c,oppTeamRec.Opportunity_Team_Member__c);      
        }       
     }      
     //populating old map       
    for(Opportunity_Teams__c oppTeamRec:oppTeamOldList){        
        if(oppTeamRec.Opportunity_Team_Member__c!=null && oppTeamRec.Role__c!=null){        
            roleAndMemberMapOld.put(oppTeamRec.name+oppTeamRec.Role__c,oppTeamRec.Opportunity_Team_Member__c);      
            if( oppTeamRec.Opportunity_Role_Dev__c.equalsIgnoreCase(UtilConstantsR3.Tech_Arch_Lead)){       
                loggedinUser.add(oppTeamRec.Opportunity_Team_Member__c);        
            }       
        }       
     }      
            
     //quering usermaster to get logged in user     
            
     for(User_master__c user:[Select id,User__c from User_master__c where id in:loggedinUser LIMIT 5000]){     
        loggedinusermap.put(user.id,user.User__c);      
    }       
    List<user_master__c> user=[Select id,user__c from user_master__c where user__c=:UserInfo.getUserId() LIMIT 5000];      
     List <Opportunity_Teams__c> oteam = [Select id,Role__c,Opportunity_Team_Member__r.user__c,Opportunity_Team_Member__c from Opportunity_Teams__c where opportunity__c IN: oppid and Opportunity_Team_Member__r.user__c = : UserInfo.getUserId()      
                                            and Opportunity_Role_Dev__c =:UtilConstantsR3.Tech_Arch_Lead Limit 5000];       
     system.debug('Logged in user---------->'+oteam.size());        
     if(oteam.size()==1){       
        for(Opportunity_Teams__c team:oteam){       
        oppforloggedinuser.put(team.Opportunity_Team_Member__c,team.id);        
        }       
     }      
     for(Opportunity_Teams__c oppTeamRec:oppTeamnewList){       
         system.debug('Team_Member_Request_Status__c------------------------------------------------>'+oppTeamRec.Team_Member_Request_Status__c);
        if(!oppTeamRec.Opportunity_Role_Dev__c.equalsIgnoreCase(UtilConstantsR3.Tech_Arch_Lead)){       
            sendandupdate.add(oppTeamRec);      
        }       
        else{       
            system.debug('userinfo.getUserId()'+userinfo.getUserId());      
            system.debug('loggedinusermap.get(roleAndMemberMapOld.get(oppTeamRec.name+oppTeamRec.Role__c))'+loggedinusermap.get(roleAndMemberMapOld.get(oppTeamRec.name+oppTeamRec.Role__c)));      
           if(!oteam.isEmpty() && oteam.size()!=1 && oppTeamRec.Opportunity_Role_Dev__c.equalsIgnoreCase(UtilConstantsR3.Tech_Arch_Lead) && roleAndMemberMapOld.get(oppTeamRec.name+oppTeamRec.Role__c)!=roleAndMemberMapNew.get(oppTeamRec.name+oppTeamRec.Role__c)){      
            sendandupdate.add(oppTeamRec);      
            system.debug('In first if');        
           }        
          else if(loggedinusermap.get(roleAndMemberMapOld.get(oppTeamRec.name+oppTeamRec.Role__c))==userinfo.getUserId() && roleAndMemberMapOld.get(oppTeamRec.name+oppTeamRec.Role__c)!=roleAndMemberMapNew.get(oppTeamRec.name+oppTeamRec.Role__c)){      
            sendandupdate.add(oppTeamRec);      
            system.debug('In 2nd if');      
          }     
           else if((oteam.size()==0 && loggedinusermap.get(roleAndMemberMapOld.get(oppTeamRec.name+oppTeamRec.Role__c))==userinfo.getUserId() && roleAndMemberMapOld.get(oppTeamRec.name+oppTeamRec.Role__c)!=roleAndMemberMapNew.get(oppTeamRec.name+oppTeamRec.Role__c))      
            || (oppforloggedinuser.get(oppTeamRec.Opportunity_Team_Member__c)!=oppTeamRec.id) && oteam.size()==1){      
            sendandupdate.add(oppTeamRec);      
            system.debug('In 3nd if');      
          }     
            else if(oteam.isEmpty() && oppTeamRec.Team_Member_Request_Status__c.Equalsignorecase(UtilConstantsR3.Assigned) && oppTeamRec.Opportunity_Role_Dev__c.equalsIgnoreCase(UtilConstantsR3.Tech_Arch_Lead) && roleAndMemberMapOld.get(oppTeamRec.name+oppTeamRec.Role__c)!=roleAndMemberMapNew.get(oppTeamRec.name+oppTeamRec.Role__c)       
                    || (oteam.size()==1 && loggedinusermap.get(roleAndMemberMapOld.get(oppTeamRec.name+oppTeamRec.Role__c))!=userinfo.getUserId() && roleAndMemberMapOld.get(oppTeamRec.name+oppTeamRec.Role__c)!=roleAndMemberMapNew.get(oppTeamRec.name+oppTeamRec.Role__c))      
                    ){      
                oppTeamRec.addError(UtilConstantsR3.ERROR_MSG_TechArch);      
           }        
           else{        
                sendandupdate.add(oppTeamRec);    
           }        
        }       
           system.debug('sendandupdate------------------------------'+sendandupdate.size());     
        if(!sendandupdate.isEmpty()){       
            updateAccessOnOppAndSolCompForAssignee(sendandupdate);      
        }       
     }      
   }
   
     
   /***
   
   ****/
   public static void restrictDmatUser(List<DMAT__c> dmatuserlist){
   set<id>opportunityid =new set<id>();
   for(Dmat__c dmat:dmatuserlist){
       opportunityid.add(dmat.Opportunity_DMAT__c);
   }
   list<Opportunity_Teams__c> oppTeamRec=[Select id, Opportunity_Role_Dev__c,Opportunity_Team_Member__r.user__c,Opportunity__c
                                               from Opportunity_Teams__c where    
                                              Opportunity_Team_Member__r.user__c =:userinfo.getuserid() and
                                               Opportunity_Role_Dev__c ='DMAT User' and opportunity__C in:opportunityid
                                              ];   
       system.debug('oppTeamRec dmat size------'+oppTeamRec.size()+'oppTeamRec------');
        if(oppTeamRec.isEmpty() && (userinfo.getProfileId() == UtilConstantsforSWB.utilMethod(Label.DMAT_User_Profile))){
            for(DMAT__c dmatRec:dmatuserlist){
                       dmatRec.addError('DMAT user not added in Opportunity team');
           }
          }else if(oppTeamRec.isEmpty() && !(userinfo.getProfileId() == UtilConstantsforSWB.utilMethod(Label.DMAT_User_Profile) || userinfo.getProfileId() == UtilConstantsforSWB.utilMethod(Label.System_Admin_Profile) ||  userinfo.getProfileId() == UtilConstantsforSWB.utilMethod(Label.IC_Solution_Operations_Profile) || userinfo.getProfileId() == UtilConstantsforSWB.utilMethod(Label.IO_Solution_Operations_pr) || userinfo.getProfileId() == UtilConstantsforSWB.utilMethod(Label.Solution_Operations_Profile) || userinfo.getProfileId() == UtilConstantsforSWB.utilMethod(Label.IS_PMO_Operations_Profile))){
                   for(DMAT__c dmatRec:dmatuserlist){
                              dmatRec.addError('DMAT user only can create the DMAT records');
                   }
          }
   }
   public static void UpdateCommentsOnOppTeam(Map<id,Opportunity_Teams__c> oldTeamMap, Map<id,Opportunity_Teams__c> newTeamMap){
       String RequestorComments='';
       String AssignmentComments='';
       
       for(Id Key :oldTeamMap.keySet()){
           if(oldTeamMap.get(Key).Assignment_comments__c != newTeamMap.get(Key).Assignment_comments__c){
           if(newTeamMap.get(Key).Assignment_comments__c==null){
               newTeamMap.get(Key).Assignment_comments__c = '';
           }
               newTeamMap.get(Key).Assignment_Comments_Tracking__c='';    
               AssignmentComments = system.today().format()+' ['+userinfo.getFirstname()+' '+userinfo.getLastname()+'] '+newTeamMap.get(Key).Assignment_comments__c;
            if(oldTeamMap.get(Key).Assignment_Comments_Tracking__c !=null)   {
                newTeamMap.get(Key).Assignment_Comments_Tracking__c = AssignmentComments +'\n'+ oldTeamMap.get(Key).Assignment_Comments_Tracking__c;
            }
               else{
                   newTeamMap.get(Key).Assignment_Comments_Tracking__c = AssignmentComments;
               }  
               newTeamMap.get(Key).Assignment_Comments__c = ' ';
           
           }
           
           if(oldTeamMap.get(Key).Requestor_Comments__c != newTeamMap.get(Key).Requestor_Comments__c){
           if(newTeamMap.get(Key).Requestor_Comments__c==null){
               newTeamMap.get(Key).Requestor_Comments__c = ' ';
           }
               newTeamMap.get(Key).Requestor_Comments_Tracking__c='';
                
               
               AssignmentComments = system.today().format()+' ['+userinfo.getFirstname()+' '+userinfo.getLastname()+'] '+newTeamMap.get(Key).Requestor_Comments__c;
              if(oldTeamMap.get(Key).Requestor_Comments_Tracking__c !=null){
                  newTeamMap.get(Key).Requestor_Comments_Tracking__c= AssignmentComments +'\n'+ oldTeamMap.get(Key).Requestor_Comments_Tracking__c;
              }
              else{
                  newTeamMap.get(Key).Requestor_Comments_Tracking__c= AssignmentComments;
              }
               

               newTeamMap.get(Key).Requestor_Comments__c='';
           
           }
       }
   }
   /**
  
   public static void updateFieldsforReporting(List<Opportunity_Teams__c> oppteamnewlist){
       for(Opportunity_Teams__c opt : oppteamnewlist){
           if(opt.Request_Team_Member__c && opt.Role__r.name =='Technical Architect'){
                if(opt.Opportunity_Team_Member__c == NULL && opt.Request_Team_Member__c){
                    // TechArchRequested
                }
                if(opt.Opportunity_Team_Member__c != NULL){
                    // TechArchAssigned
                }
           
           }
       }
   } */
     /**
   *  @Description : Method added for Change Requests D-4396
   *  @name : updateFieldsforReporting
   *  @param : List<Opportunity_Teams__c> oppteamnewlist
   *  @return parameter - void
   *  @throws exception- DML Exception
   */  
   public static void updateFieldsforReporting(List<Opportunity_Teams__c> oppteamnewlist,List<Opportunity_Teams__c> oppteamoldlst){
      map<id,datetime>oppTeamCreatedDateMap=new map<id,datetime>();
      map<id,id>oldoppTeamMembeMap=new map<id,id>();
      map<id,date>ArchAssignedDateMap=new map<id,date>();
      map<id,date>ArchRequestDateMap=new map<id,date>();
      map<id,id>oldTechArch=new map<id,id>();
      map<id,id>newTechArch=new map<id,id>();
      set<id> opportunityids=new set<id>();
      for(Opportunity_Teams__c opt : oppteamnewlist){
        if(UtilConstantsR3.Tech_Arch.equalsignorecase(opt.Opportunity_Role_Dev__c)){
            opportunityids.add(opt.Opportunity__c);
        }
      }
      if(!oppteamoldlst.isEmpty()){
          for(Opportunity_Teams__c opt:oppteamoldlst){
            if(oppTeamCreatedDateMap.get(opt.opportunity__c)==null){
                oppTeamCreatedDateMap.put(opt.opportunity__c,opt.createddate);
                oldoppTeamMembeMap.put(opt.opportunity__c,opt.Opportunity_Team_Member__c);
            }
            else{
                if(oppTeamCreatedDateMap.get(opt.opportunity__c)>opt.createddate){
                    oppTeamCreatedDateMap.put(opt.opportunity__c,opt.createddate);
                    oldoppTeamMembeMap.put(opt.opportunity__c,opt.Opportunity_Team_Member__c);
                }
            }
          }
      }
      oppTeamCreatedDateMap.clear();
      List<Opportunity_Teams__c> oppTeamlst=[Select Opportunity_Role_Dev__c,Request_Team_Member__c,Requested_Date__c,Assigned_Date__c,
                                          Opportunity_Team_Member__c,createddate,opportunity__c
                                           from Opportunity_Teams__c where opportunity__c in: opportunityids and Opportunity_Role_Dev__c=:UtilConstantsR3.Tech_Arch];
      if(!opportunityids.isEmpty()){
            for(Opportunity_Teams__c opt:oppTeamlst){
                if(oppTeamCreatedDateMap.get(opt.opportunity__c)==null){
                    oppTeamCreatedDateMap.put(opt.opportunity__c,opt.createddate);
                    ArchAssignedDateMap.put(opt.opportunity__c,opt.Assigned_Date__c);
                    ArchRequestDateMap.put(opt.opportunity__c,opt.Requested_Date__c);
                    newTechArch.put(opt.opportunity__c,opt.Opportunity_Team_Member__c);
                }
                else{
                    if(oppTeamCreatedDateMap.get(opt.opportunity__c)>opt.createddate){ 
                        oppTeamCreatedDateMap.put(opt.opportunity__c,opt.createddate);
                        ArchAssignedDateMap.put(opt.opportunity__c,opt.Assigned_Date__c);
                        ArchRequestDateMap.put(opt.opportunity__c,opt.Requested_Date__c);
                        newTechArch.put(opt.opportunity__c,opt.Opportunity_Team_Member__c);
                    }
                }
            }
            List<Opportunity>opportunityRecToUpdate=new list<Opportunity>();
            for(Opportunity oppRec : [select id, name,Arch_Request_Date__c,Team_member_assigned_date__c from Opportunity where ID IN:opportunityids]){
                for(Opportunity_Teams__c opt:oppTeamlst){
                    if(oppRec.id==opt.opportunity__c){
                            if(opt.Opportunity_Team_Member__c == NULL){
                                oppRec.Arch_Request_Date__c=ArchRequestDateMap.get(oppRec.id);
                                system.debug('oppRec.Arch_Request_Date__c--------------------------->'+ArchRequestDateMap.get(oppRec.id));
                            }
                        if(opt.Opportunity_Team_Member__c!=null && oppTeamCreatedDateMap.get(oppRec.id)!=null){
                            if(ArchRequestDateMap.containskey(oppRec.id) && oldoppTeamMembeMap.get(oppRec.id)!=null){
                                if(newTechArch.get(oppRec.id)!=oldoppTeamMembeMap.get(oppRec.id)){
                                    oppRec.Team_member_assigned_date__c=system.today();
                                }
                                else{
                                    oppRec.Team_member_assigned_date__c=ArchAssignedDateMap.get(oppRec.id);
                                    system.debug('oppRec.Arch_Request_Date__c--------------------------->'+oppRec.Team_member_assigned_date__c);
                                }
                            }
                            else{
                                oppRec.Team_member_assigned_date__c=ArchAssignedDateMap.get(oppRec.id);
                                system.debug('ArchAssignedDateMap.get(oppRec.id)--------------------------->'+ArchAssignedDateMap.get(oppRec.id));
                            }
                        }
                    }
                }
                opportunityRecToUpdate.add(oppRec);
            }
            
            if(!opportunityRecToUpdate.isEmpty()){
                try{
                    database.update(opportunityRecToUpdate,false);
                }
                catch(Exception e){
                    
                }
            }
      }
     /* Map<id,Opportunity> teamWithOpportunity = new Map<id,Opportunity>();
      for(Opportunity opp : [select id, name,Arch_Request_Date__c,Team_member_assigned_date__c from Opportunity where ID IN:oppIds]){
        for(Opportunity_Teams__c opt : oppteamnewlist){
            if(opt.opportunity__c == opp.id){
                teamWithOpportunity.put(opt.id,opp);
            }
        }
      }
      Opportunity OppRecToUpdate = new Opportunity();
      List<Opportunity> OppListToUpdate = new List<Opportunity>();
       for(Opportunity_Teams__c opt : oppteamnewlist){
           if(opt.Request_Team_Member__c && opt.Role__r.name =='Technical Architect'){
                if(opt.Opportunity_Team_Member__c == NULL){
                    // TechArchRequested
                    OppRecToUpdate=teamWithOpportunity.get(opt.id);
                    OppRecToUpdate.Arch_Request_Date__c = system.today();
                    OppListToUpdate.add(OppRecToUpdate);
                    
                }
                if(opt.Opportunity_Team_Member__c != NULL){
                    // TechArchAssigned : This scenario is invalid, but since I'm writing the Code, I'll check this as well. Coz, Mujhko Rokega Kaun aur Kaiko :P
                    OppRecToUpdate=teamWithOpportunity.get(opt.id);
                    OppRecToUpdate.Team_member_assigned_date__c = system.today();
                    OppListToUpdate.add(OppRecToUpdate);
                    
                }
           }
           if(opt.Opportunity_Team_Member__c != NULL && opt.Role__r.name =='Technical Architect'){
                    //TechArchAssigned
                    OppRecToUpdate=teamWithOpportunity.get(opt.id);
                    OppRecToUpdate.Team_member_assigned_date__c = system.today();
                    OppListToUpdate.add(OppRecToUpdate);
           }
       }
       try{
           if(OppListToUpdate.size()>0){
            database.update(OppListToUpdate);
           }
       }
       catch(Exception w){
        
       }*/
   }
    
    
   /* this method will update the SOlutionLIVE SA field on Opportunity*/
    public static void updateSolutionLIVE_SA_onInsert(List<Opportunity_teams__c> oppteamL){
       
       
       List<opportunity_teams__c> oppteamList =[select id, opportunity__c,opportunity__r.SolutionLive_Supported_Deal__c,opportunity_team_member__r.SolutionLIVE_SA__c from Opportunity_teams__c where
                                                 id in:oppteamL];
       
       
       List<opportunity> oppListToUpdate=new List<Opportunity>();
       set<id> oppsettoupdate =new set<id>();   
       for(Opportunity_teams__c oppteam:oppteamList){      
           if(oppteam.opportunity_team_member__r.SolutionLIVE_SA__c==true){         
              if(!oppsettoupdate.contains(oppteam.opportunity__C)){
                  oppsettoupdate.add(oppteam.opportunity__C);
                  oppteam.opportunity__r.SolutionLive_Supported_Deal__c=true;
                  oppListToUpdate.add(oppteam.opportunity__r);
              }     
           }           
       }
       
       try{
            if(oppListToUpdate.size()>0){
            
            update oppListToUpdate;
            }
       }catch(Exception e){
       
       system.debug(e);
       
       }
        
    } 
    
   
}