/*
  @Author: Ezdhan Hussain S.K
  @Name: SSRTTriggerHandlerClass
  @Created Date: 01 January 2015
  @Description: This class handles following functionalities for User Story -SSRT Content Management.
  @version: 1.0
*/
public with sharing class SSRTTriggerHandlerClass{
    Boolean flag;
    Public Opportunity_Roles_Master__c oppRole{
        get{
            Opportunity_Roles_Master__c oppre;
            if(oppRole == null){
                try{
                    oppre =[select id,name from Opportunity_Roles_Master__c where name=:Label.SSRT_Content_Manager_role Limit 1];
                }catch(exception e){
                    oppre = null;
                    ////System.debug('Data Error Query returned null as no SSRT content role exists:::');
                }
                return oppre;
            }else{
                return oppRole;
            }
        }
    }    
    
      /**
     * @description       Method to avoid recursive trigger
     * @name              runOnce
     * @param             NA
     * @return            Boolean value
     * @throws            NA
     */
    @TestVisible private static boolean run = true;   
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    
     /**
     * @description       Method to populate client Master if not provided     
     * @name              insertOppTeam
     * @param             List<SSRT_Content_Management_Request__c> newlist
     * @return            Boolean value
     * @throws            NA
     */
    public void insertOppTeam(List<SSRT_Content_Management_Request__c> newlist){
        try{
            List<Opportunity_Teams__c> oppteamlist_toinsert = new List<Opportunity_Teams__c>();
            List<Opportunity_Teams__c> oppteamlist_toupdate = new List<Opportunity_Teams__c>();
            List<SSRT_Content_Management_Request__c> ssrt_ListToUpdate = new List<SSRT_Content_Management_Request__c>();
            set<id> oppids = new set<id>();
            for(SSRT_Content_Management_Request__c ssrt: newlist){
                if(ssrt.Opportunity__c != null && ssrt.Master_Client_Name__c == null){
                    oppids.add(ssrt.Opportunity__c);
                }
            } 
            List<Opportunity> queryOpps = new List<Opportunity>();
            Map<id,id> oppMap_account = new Map<id,id>();
            if(oppids.size() > 0){
                queryOpps = [select id,accountid FROM Opportunity where ID IN:oppids limit 5000];
            }
            if(queryOpps.size() > 0){
                for(Opportunity opp: queryOpps){
                    oppMap_account.put(opp.id,opp.accountid);
                }
                for(SSRT_Content_Management_Request__c ssrt:[select id,Master_client_name__c,Opportunity__c 
                                FROM SSRT_Content_Management_Request__c Where ID IN:newlist Limit 5000] ){
                    ssrt.Master_Client_Name__c = oppMap_account.get(ssrt.Opportunity__c);
                    ssrt_ListToUpdate.add(ssrt);
                }
                if(ssrt_ListToUpdate.size() > 0){
                    List<DataBase.saveResult> sresult = Database.update(ssrt_ListToUpdate,false);
                    for(DataBase.saveResult ss :sresult){
                        if(ss.isSuccess()){
                            ////System.debug('Saved Records::::::::::::::'+ss);
                        }else{
                            ////System.debug('Failed Records::::::::::::::'+ss);
                        }   }   }   
            }
        }catch(DMLException e){
        String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }  
    
    /**
     * @description       Method to perform insert logic     
     * @name              insertOppTeam
     * @param             List<SSRT_Content_Management_Request__c> newlist
     * @param             boolean bool
     * @return            void
     * @throws            NA
     */
    public void performInsertLogic(List<SSRT_Content_Management_Request__c> newlist,boolean bool){
        try{
            List<Opportunity_Teams__c> oppteamlist_toinsert = new List<Opportunity_Teams__c>();
            List<SSRT_Content_Management_Request__c> list_ssrtintegratormails = new List<SSRT_Content_Management_Request__c>();
            set<id> oppids = new set<id>();
            Opportunity_Teams__c oppteam;
            for(SSRT_Content_Management_Request__c ssrt: newlist){
                if(ssrt.Content_integrator__c != null && ssrt.Opportunity__c != null ){
                    oppteam = new Opportunity_Teams__c();
                    oppteam.Opportunity__c = ssrt.Opportunity__c;
                    oppteam.Opportunity_Team_Member__c = ssrt.Content_integrator__c;
                    oppteam.Role__c = opprole.Id; 
                    oppteamlist_toinsert.add(oppteam);
                }
                if(ssrt.Content_integrator__c != null ){
                    list_ssrtintegratormails.add(ssrt);
                }
            }
            if(oppteamlist_toinsert.size() > 0){
                List<DataBase.saveResult> sresult = Database.insert(oppteamlist_toinsert,false);
                for(DataBase.saveResult ss :sresult){
                    if(ss.isSuccess()){ ////System.debug('Success on Data save- The following has occurred: ');
                    }
                    else{}    
                }
            }
            if(!list_ssrtintegratormails.isEmpty() && bool){
                sendContentIntegratorMail(list_ssrtintegratormails);
            }
        }catch(DMLException e){
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
    
    /**
     * @description       Method to perform update on Opp team if Content_integrator is assgined/changed     
     * @name              performUpdateLogic
     * @param             (Map<id,SSRT_Content_Management_Request__c> oldmap
     * @param             List<SSRT_Content_Management_Request__c> newlist
     * @return            void
     * @throws            Exception logging
     */
    public void performUpdateLogic(Map<id,SSRT_Content_Management_Request__c> oldmap,List<SSRT_Content_Management_Request__c> newlist){
        Opportunity_Teams__c oppTeamRole = new Opportunity_Teams__c();
        List<Opportunity_Teams__c> oppteamlist_toupdate = new List<Opportunity_Teams__c>();
        List<SSRT_Content_Management_Request__c> ssrt_contIntegratOrmailList = new List<SSRT_Content_Management_Request__c>();
        set<id> oppids = new set<id>();
        boolean bool = true;
        for(SSRT_Content_Management_Request__c ssrt: newlist){
            if(ssrt.Opportunity__c != null ){
                oppids.add(ssrt.Opportunity__c);
            }
            if(ssrt.Content_integrator__c != null && oldmap.get(ssrt.id).Content_integrator__c ==null){
                ssrt_contIntegratOrmailList.add(ssrt);
            }
        }
        if(!ssrt_contIntegratOrmailList.isEmpty()){
            sendContentIntegratorMail(ssrt_contIntegratOrmailList);
            bool = false;
        } 
        try{    
            Opportunity_Teams__c oppteam = new Opportunity_Teams__c();   
            oppTeamRole = [SELECT id,role__c,Opportunity_Team_Member__c 
                            FROM Opportunity_Teams__c WHERE Role__r.name=:opprole.name AND Opportunity__c IN:oppids Limit 1];
            for(SSRT_Content_Management_Request__c ssrt: newlist){
                if(ssrt.Content_integrator__c != null && (oldmap.get(ssrt.id).Content_integrator__c !=ssrt.Content_integrator__c || 
                            ssrt.Content_integrator__c != Oppteamrole.Opportunity_Team_Member__c ) && ssrt.Opportunity__c != null ){
                    oppteam.Id = oppTeamRole.Id;
                    oppteam.Opportunity__c = ssrt.Opportunity__c;
                    oppteam.Opportunity_Team_Member__c = ssrt.Content_integrator__c;
                    oppteam.Role__c = opprole.Id; 
                    oppteamlist_toupdate.add(oppteam);
                }               
            }
            if(oppteamlist_toupdate.size() >0){
                List<DataBase.saveResult> uresult = Database.update(oppteamlist_toupdate,false);
                for(DataBase.saveResult ss :uresult){
                    if(ss.isSuccess()){
                        //System.debug('Saved Records::::::::::::::'+ss);
                    }
                    else{
                        //System.debug('Failed Records::::::::::::::'+ss);
                    }    }    }
        }catch(exception e){
            performInsertLogic(newlist,bool);
        }
    }
   
    /**
     * @description       Method to perform delete Corresponding Opp team record id SSRT Request is deleted   
     * @name              deleteOppTeam
     * @param             List<SSRT_Content_Management_Request__c> deletelist
     * @return            void
     * @throws            Exception logging
     */
    public void deleteOppTeam(List<SSRT_Content_Management_Request__c> deletelist){
        set<id> oppids = new set<id>();
        for(SSRT_Content_Management_Request__c ssrt: deletelist){
            oppids.add(ssrt.Opportunity__c);
        }
        try{
            List<Opportunity_Teams__c> oppTeamRole = [SELECT id FROM Opportunity_Teams__c 
                                    WHERE Role__r.name=:Label.SSRT_Content_Manager_role AND Opportunity__c IN:oppids Limit 1];
            if(oppTeamRole.size()>0){
                Database.delete(oppTeamRole,true);                
            }
        }catch(exception e){
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
    
    /**
     * @description       Method to  Send SSRT content integrator mail  
     * @name              sendContentIntegratorMail
     * @param             List<SSRT_Content_Management_Request__c> ssrtList
     * @return            void
     * @throws            Exception logging
     */
    public void sendContentIntegratorMail(List<SSRT_Content_Management_Request__c> ssrtList){
        id tempid =  [SELECT id FROM emailtemplate 
                      WHERE isactive=true AND DeveloperName=: label.SSRT_with_Content_Integrator_No_Opp_template LIMIT 1].id;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        list<Messaging.SingleEmailMessage> finalmaillist = new list<Messaging.SingleEmailMessage>();
        String orgWideEmailAddressID= UtilEmail.emailid(); 
        for(SSRT_Content_Management_Request__c ssrt:[SELECT id,content_integrator__r.user__c 
                                                    FROM SSRT_Content_Management_Request__c where ID IN:ssrtlist limit 1000]){
            mail.setTargetObjectId(ssrt.content_integrator__r.user__c);
            mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
            mail.setTemplateId(tempid);
            mail.setWhatId(ssrt.id);
            mail.setSaveAsActivity(false);
            finalmaillist.add(mail);
        }
        try{

             List<FlagCheck__c> flagCheckList=FlagCheck__c.getAll().values();
             flag=flagCheckList[0].SSRTTrigger__c; 
            if(!test.isRunningTest() && flag==True ){
                List<Messaging.sendEmailResult> emailresult = Messaging.sendEmail(finalmaillist);
            }
        }catch(exception e){
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
}