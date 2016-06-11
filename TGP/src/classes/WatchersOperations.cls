/**
   @Author :Apoorva Sharma
   @name   : WatchersOperations 
   @CreateDate : 16 November 2015 
   @Description : This class is used for performing operations on watchers.
   @Version : 1.0 
  */
public with sharing class WatchersOperations {

   /**
     * @description       This method is used to add default watchers for an opportunity.
     * @param             Set<ID> Opportunity ID 
     * @return            Void
     * @throws            DML Exception
     */    
 public static void addDefaultWatchers(Set<id> opportunityIDs){
    list<Opportunity> opportunityRecList= new List<Opportunity>();
    map<String,List<id>> watchermastermap=new map<String,List<id>>();
    Watcher__c watcher;
    list<Watcher__c> defaultFactoryWatcherToAdd=new list<Watcher__c>();
    list<Watcher__c> defaultGeoWatcherToAdd=new list<Watcher__c>();
    list<Watcher__c> defaultTsdmWatcherToAdd=new list<Watcher__c>();
    list<Watcher__c> genericWatcherList=new list<Watcher__c>();
    //map<string,string> existingwatchers=new set<string,string>();
    set<String>existingwatchers =new set<string>();
    UtilConstantsR3.runaddWatcher=false;
    for(Watcher_Master__c watchermaster :[Select id,name from Watcher_Master__c where active__c=true limit 5000]){
            if(watchermastermap.get(watchermaster.name)!=null){
                watchermastermap.get(watchermaster.name).add(watchermaster.id);
            }
            else{
                list<id> idlist=new list<id>();
                idlist.add(watchermaster.id);
                watchermastermap.put(watchermaster.name,idlist);
            }
    }
    for(Watcher__c watch :[Select id,Watcher_Master__c,Opportunity__c from Watcher__c where Opportunity__c in:opportunityIDs limit 5000]){
        existingwatchers.add(watch.Watcher_Master__c+UtilConstantsR3.hyphen+watch.Opportunity__c);
    }
    opportunityRecList=[Select id,In_scope_Factories__c,OperatingGroup__r.name,OperatingGroup__c,TSDM_Region__c from Opportunity where id in:opportunityIDs limit 5000];
    
    
    for(Opportunity oppRec:opportunityRecList){
        // Adding Geo Watchers
        system.debug('Geo Watcher------------------------------------------->'+watcher);
        if(oppRec.TSDM_Region__c!=null && watchermastermap.get(oppRec.TSDM_Region__c+UtilConstantsR3.geoLead)!=null){
            if(watchermastermap.containsKey(oppRec.TSDM_Region__c+UtilConstantsR3.geoLead)){
                for(Id i:watchermastermap.get(oppRec.TSDM_Region__c+UtilConstantsR3.geoLead)){
                    if(!existingwatchers.contains(i+UtilConstantsR3.hyphen+oppRec.id)){
                        watcher=new Watcher__c();
                        watcher.Opportunity__c=oppRec.id;
                        watcher.Watcher_Master__c=i;
                        //watcher.Watcher_Master__c=watchermastermap.get(oppRec.TSDM_Region__c+UtilConstantsR3.geoLead);
                        defaultGeoWatcherToAdd.add(watcher);
                        system.debug('Geo Watcher------------------------------------------->'+watcher);
                    }
                }
            }
        }
        
        //Adding TSDM Watcher
            if(oppRec.OperatingGroup__c!=null){
            if(oppRec.OperatingGroup__c!=null && watchermastermap.get(oppRec.OperatingGroup__r.name+UtilConstantsR3.hyphen+oppRec.TSDM_Region__c)!=null
                &&(!oppRec.OperatingGroup__r.name.EqualsIgnoreCase(UtilConstantsR3.cmt) && !oppRec.OperatingGroup__r.name.EqualsIgnoreCase(UtilConstantsR3.hps) && 
                !oppRec.OperatingGroup__r.name.EqualsIgnoreCase(UtilConstantsR3.fs) )
                ){
                if(watchermastermap.containsKey(oppRec.OperatingGroup__r.name+UtilConstantsR3.hyphen+oppRec.TSDM_Region__c)){
                    for(Id i:watchermastermap.get(oppRec.OperatingGroup__r.name+UtilConstantsR3.hyphen+oppRec.TSDM_Region__c)){
                        if(!existingwatchers.contains(i+UtilConstantsR3.hyphen+oppRec.id)){
                            watcher=new Watcher__c();
                            watcher.Opportunity__c=oppRec.id;
                            watcher.Watcher_Master__c=i;
                            //watcher.Watcher_Master__c=watchermastermap.get(oppRec.OperatingGroup__r.name+UtilConstantsR3.hyphen+oppRec.TSDM_Region__c);
                            defaultTsdmWatcherToAdd.add(watcher);
                            system.debug('TSDM Watcher------------------------------------------->'+watcher);
                            //watcher=null;
                        }
                    }
                }
            }
            else if(oppRec.OperatingGroup__r.name.EqualsIgnoreCase(UtilConstantsR3.hps) && oppRec.OperatingGroup__c!= null && 
                    watchermastermap.get(UtilConstantsR3.hpswatcher+UtilConstantsR3.hyphen+oppRec.TSDM_Region__c)!=null){
                if(watchermastermap.containsKey(UtilConstantsR3.hpswatcher+UtilConstantsR3.hyphen+oppRec.TSDM_Region__c)){
                    for(Id i:watchermastermap.get(UtilConstantsR3.hpswatcher+UtilConstantsR3.hyphen+oppRec.TSDM_Region__c)){
                        if(!existingwatchers.contains(i+UtilConstantsR3.hyphen+oppRec.id)){
                            watcher=new Watcher__c();
                            watcher.Opportunity__c=oppRec.id;
                            watcher.Watcher_Master__c=i;
                            //watcher.Watcher_Master__c=watchermastermap.get(UtilConstantsR3.hpswatcher+UtilConstantsR3.hyphen+oppRec.TSDM_Region__c);
                            defaultTsdmWatcherToAdd.add(watcher);
                        }
                    }
                }
            }
            else if(oppRec.OperatingGroup__r.name.EqualsIgnoreCase(UtilConstantsR3.fs) && oppRec.OperatingGroup__c!= null &&
                    watchermastermap.get(UtilConstantsR3.fswatcher+UtilConstantsR3.hyphen+oppRec.TSDM_Region__c)!=null){
                    if(watchermastermap.containsKey(UtilConstantsR3.fswatcher+UtilConstantsR3.hyphen+oppRec.TSDM_Region__c)){
                    for(Id i:watchermastermap.get(UtilConstantsR3.fswatcher+UtilConstantsR3.hyphen+oppRec.TSDM_Region__c)){
                        if(!existingwatchers.contains(i+UtilConstantsR3.hyphen+oppRec.id)){
                            watcher=new Watcher__c();
                            watcher.Opportunity__c=oppRec.id;
                            watcher.Watcher_Master__c=i;
                            //watcher.Watcher_Master__c=watchermastermap.get(UtilConstantsR3.hpswatcher+UtilConstantsR3.hyphen+oppRec.TSDM_Region__c);
                            defaultTsdmWatcherToAdd.add(watcher);
                        }
                    }
                }
            }
            else if(oppRec.OperatingGroup__r.name.EqualsIgnoreCase(UtilConstantsR3.cmt) && oppRec.OperatingGroup__c!= null 
            && watchermastermap.get(UtilConstantsR3.cmtwatcher+UtilConstantsR3.hyphen+oppRec.TSDM_Region__c)!=null){
                if(watchermastermap.containsKey(UtilConstantsR3.cmtwatcher+UtilConstantsR3.hyphen+oppRec.TSDM_Region__c)){
                    for(Id i:watchermastermap.get(UtilConstantsR3.cmtwatcher+UtilConstantsR3.hyphen+oppRec.TSDM_Region__c)){
                        if(!existingwatchers.contains(i+UtilConstantsR3.hyphen+oppRec.id)){
                            watcher=new Watcher__c();
                            watcher.Opportunity__c=oppRec.id;
                            watcher.Watcher_Master__c=i;
                            //watcher.Watcher_Master__c=watchermastermap.get(UtilConstantsR3.hpswatcher+UtilConstantsR3.hyphen+oppRec.TSDM_Region__c);
                            defaultTsdmWatcherToAdd.add(watcher);
                        }
                    }
                }
            }
        }
            
        //Adding Factory Watcher
        if(oppRec.In_scope_Factories__c!=null){
            list<String> factoryWatachers=oppRec.In_scope_Factories__c.split(UtilConstants.SEMICOLON_STRING);
            if(!factoryWatachers.isEmpty()){
                system.debug('I love Starwars!!!! '+factoryWatachers);
                for(String s:factoryWatachers){
                
                //watcher=new Watcher__c();
                if(watchermastermap.get(s+UtilConstantsR3.Factory)!=null){
                    //system.debug('s+UtilConstantsR3.Factory '+s+UtilConstantsR3.Factory);
                    if(watchermastermap.containsKey(s+UtilConstantsR3.Factory)){
                        for(Id i:watchermastermap.get(s+UtilConstantsR3.Factory)){
                        //system.debug('Oh my God, it\'s a mirage');
                          
                           system.debug(s+' '+i);
                            if(!existingwatchers.contains(i+UtilConstantsR3.hyphen+oppRec.id)){
                                //system.debug('I\'m tellin y\'all it\'s sabotage');
                                watcher=new Watcher__c();
                                watcher.Opportunity__c=oppRec.id;
                                watcher.Watcher_Master__c=i;
                                defaultFactoryWatcherToAdd.add(watcher);
                            }
                        }
                    }
                }
              }
            }
        }
    }
    
    if(!defaultGeoWatcherToAdd.isEmpty()){
      genericWatcherList.addAll(defaultGeoWatcherToAdd);
     }
    if(!defaultTsdmWatcherToAdd.isEmpty()){
     genericWatcherList.addAll(defaultTsdmWatcherToAdd);
    }
    system.debug('defaultFactoryWatcherToAdd.isEmpty()'+defaultFactoryWatcherToAdd.isEmpty());
    if(!defaultFactoryWatcherToAdd.isEmpty()){
        genericWatcherList.addAll(defaultFactoryWatcherToAdd);
    }
    
    // insert watchers
    system.debug('genericWatcherList.isEmpty()'+genericWatcherList.isEmpty());
    if(!genericWatcherList.isEmpty()){
        try{
        system.debug('Ye hai Samasya ki jadd: '+genericWatcherList);
         database.insert(genericWatcherList);
        }catch(Exception e){
            system.debug('ye error message hai '+e);
          string exceptionCaught = string.valueof(e);
}
    }
 }
 
   /**
     * @description       This method is used to check if TSDM Region,OG or In Scope Facory is changes for an opportunity and call addDefaultWatchers
     *                    if there is a change .
     * @param             Trigger.New, Trigger.Old
     * @return            Void
     * @throws            NA
     */   
 public static void compareOppdata(list<Opportunity> oldoppdata,list<Opportunity> newoppdata){
    map<id,String>tsdmmap=new map<id,String>();
    map<id,id>ogmap=new map<id,id>();
    map<id,String>factorymap=new map<id,string>();
    map<id,string>stagechange=new map<id,string>();
    map<id,string>statuschange=new map<id,string>();
    set<id> OpportunityIdforEmail =new set<id>();        // this set is passed to sendEmailToWatcher method
    set<id> OpportunityId =new set<id>();               // this set is passed to  addDefaultWatchers method
    
    for(Opportunity oppRec:oldoppdata){
        tsdmmap.put(oppRec.id,oppRec.TSDM_Region__c);
        ogmap.put(oppRec.id,oppRec.OperatingGroup__c);
        factorymap.put(oppRec.id,oppRec.In_scope_Factories__c);
        statuschange.put(oppRec.id,oppRec.Reporting_Status__c);
        stagechange.put(oppRec.id,oppRec.StageName);
    }
        //comparing with new list
        
        for(Opportunity opp:newoppdata){
            if(opp.TSDM_Region__c!=tsdmmap.get(opp.id)){
                OpportunityId.add(opp.id);
            }
            else if(opp.OperatingGroup__c!=ogmap.get(opp.id)){
                OpportunityId.add(opp.id);
            }
            else if(opp.In_scope_Factories__c!=factorymap.get(opp.id)){
                OpportunityId.add(opp.id);
            }
            
            // stage or status change
            if(stagechange.get(opp.id)!=null && statuschange.get(opp.id)!=null ){
                if(opp.Assigned_BPO_tech_Arch__c !=NULL && (opp.StageName!=stagechange.get(opp.id) || (opp.Reporting_Status__c!=statuschange.get(opp.id) && 
                    (opp.Reporting_Status__c.equalsignorecase(UtilConstantsR3.won)|| opp.Reporting_Status__c.equalsignorecase(UtilConstantsR3.lost) || opp.Reporting_Status__c.equalsignorecase(UtilConstantsR3.approved))))){
                    OpportunityIdforEmail.add(opp.id);
                }
            }
        }
        
        if(!OpportunityId.isEmpty()){
            addDefaultWatchers(OpportunityId);
        }
        
        if(!OpportunityIdforEmail.isEmpty()){
            //system.debug('come at me bro');
            sendEmailToWatcher(OpportunityIdforEmail);
        }
    
 }
 
 /**
     * @description   Email Notification to Watchers on Stage or Deal Status Change.
     * @param         Set<id>
     * @return        Void
     * @throws        NA
     */ 
 public static void sendEmailToWatcher(Set<ID> opportunityIDs){
    
    set<string> watchername=new set<string>();
    list<string> maillist =new list<string>();
    map<string,List<user>> userwatchermap =new map<string,List<user>>();
    list<string> mailAddresses =new list<string>();
    Id targetObjectID=null;
    Messaging.SingleEmailMessage mail;
    for(Watcher__c watcher: [Select id,Watcher_Master__r.name,Watcher_Master__r.Watcher__r.email__c,Watcher_Master__r.Watcher__r.user__c from Watcher__c where opportunity__c in:opportunityIDs LIMIT 5000]){
        watchername.add(watcher.Watcher_Master__r.name);
        if(targetObjectID==null){
            targetObjectID=watcher.Watcher_Master__r.Watcher__r.user__c;
        }
        else{
            if(targetObjectID!=watcher.Watcher_Master__r.Watcher__r.user__c){
            mailAddresses.add(watcher.Watcher_Master__r.Watcher__r.email__c);
            }
       }
    }
    
    /*for(Group watchergroup: [SELECT id, (select userOrGroupId from groupMembers) FROM group WHERE name = : watchername LIMIT 5000]){
        for(groupMember gm:watchergroup.groupMembers){
            maillist.add(gm.userOrGroupId);
        }
    }
    User[] usr = [SELECT id, email FROM user WHERE id IN :maillist limit 5000];
      for(User u : usr)
      {
        if(targetObjectID==null){
            system.debug('targetObjectID---------->'+u.id);
            targetObjectID=u.id;
        }
        else{
        mailAddresses.add(u.email);
        }
      }*/
      set<string> uniquemailaddress=new set<string>();
      uniquemailaddress.addall(mailAddresses);
      mailAddresses.clear();
      mailAddresses.addAll(uniquemailaddress);
      system.debug('targetObjectID 1---------->'+targetObjectID);
      String orgWideEmailAddressID=UtilEmail.emailid(); 
      //Email_Template__c myCS = Email_Template__c.getValues(UtilConstantsR3.WatchersStatusNStageNotification);
      system.debug('at283');
      Id myCCVal =[select id from emailtemplate where developername='Deal_Status_Stage_Change_Notification' limit 1].id;   
      // system.debug('at285'); 
      List<Messaging.SingleEmailMessage> mailtosend=new List<Messaging.SingleEmailMessage>();
     // system.debug('opportunityIDs------------------------------------------------------------>'+opportunityIDs);
      for(Id oppid: opportunityIDs){
          if(!mailAddresses.isEmpty()){
            mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
            system.debug('what id-------------------------------------->'+oppid);
            mail.setWhatId(oppid) ;
            mail.setTargetObjectId(targetObjectID);
            mail.setTemplateId(myCCVal);
            mail.saveAsActivity=false;     
            mail.setToAddresses(mailAddresses);
            mailtosend.add(mail);
          }
      }
     // system.debug('yu mad bro '+mailtosend.size());
      Messaging.sendEmail(mailtosend);
  }
  
   /**
     * @description       This method is used to ensure that only technical arechitect leads are allowed to add watchers.
     * @param             list<Watcher__c> watcherList
     * @return            Void
     * @throws            User-Defined Exception
     */  
     public static void addWatchers(list<Watcher__c> watcherList){
        set<id> opportunityIds =new set<id>();
        for(Watcher__c watch:watcherList){
            opportunityIds.add(watch.Opportunity__c);
        }
        
        list<Opportunity_Teams__c> oppTeamRec=[Select id,Opportunity_Role_Dev__c,Opportunity_Team_Member__r.user__c,Opportunity__c from Opportunity_Teams__c where 
                                                Opportunity_Role_Dev__c=:UtilConstantsR3.Tech_Arch_Lead and Opportunity__c in :opportunityIds and 
                                                Opportunity_Team_Member__r.user__c=:userinfo.getUserid() limit 5000];
        if(oppTeamRec.isEmpty() &&  userinfo.getProfileId()!=UtilConstantsforSWB.utilMethod(Label.System_Admin_Profile)){
              for(Watcher__c watchRec:watcherList){
               watchRec.addError(UtilConstantsR3.ERROR_MSG_Watcher);
              }
        }
        
        
     }
     
/**
     * @description   Email Notification to Watchers when it is added for an opportunity.
     * @param         Set<id>
     * @return        Void
     * @throws        NA
     */
     public static void sendMailToAddedWatcher(list<Watcher__c> watcherList){
        Messaging.SingleEmailMessage mail;
        list<string> maillist =new list<string>();
        list<string> mailAddresses =new list<string>();
        String orgWideEmailAddressID=UtilEmail.emailid();
        map<string,string>istechArchAssigned=new map<string,string>();
        for(Watcher__c opRec:[Select id,Opportunity__r.Assigned_BPO_tech_Arch__c from Watcher__c where id in:watcherList]){
            istechArchAssigned.put(opRec.id,opRec.Opportunity__r.Assigned_BPO_tech_Arch__c);
        }
        Email_Template__c myCS = Email_Template__c.getValues(UtilConstantsR3.Watchers);
        String myCCVal = myCS.ID__c;
        Id targetObjectID=null;
        set<string>watcherGroup=new set<string>();
        for(Watcher__c watch:watcherList){
            watcherGroup.add(watch.Watcher_Name_Dev__c);
        }

      List<Messaging.SingleEmailMessage> mailtosend=new List<Messaging.SingleEmailMessage>();
      for(Watcher__c watcherRec:[Select id,Watcher_Master__r.Watcher__r.user__c from Watcher__c where id in :watcherList LIMIT 5000]){
        if(istechArchAssigned.get(watcherRec.id)!=null){
            mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
            mail.setWhatId(watcherRec.id) ;
            mail.setTargetObjectId(watcherRec.Watcher_Master__r.Watcher__r.user__c);
            mail.setTemplateId(myCCVal);
            mail.saveAsActivity=false;     
            //mail.setToAddresses(mailAddresses);
            mailtosend.add(mail);
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
      }
      Messaging.sendEmail(mailtosend);
   } 
    /**
     * @description   Delete watcher records on opportunity.
     * @param         list<Opportunity> oldoppdetails,list<Opportunity>newoppdetails
     * @return        Void
     * @throws        NA
     */
    public static Boolean watcherFlag=true;
    public static set<Id> oppIdFinalSet=new set<Id>();
    public static List<Watcher__c> existingwatcher=new List<Watcher__c>();
     public static void deleteWatchers(list<Opportunity> oldoppdetails,list<Opportunity>newoppdetails){
        map<id,string> oldTsdm=new map<id,string>();
        map<id,string> oldOG=new map<id,string>();
        map<id,string> oldInsope=new map<id,string>();
        map<id,string> newTsdm=new map<id,string>();
        map<id,string> newOG=new map<id,string>();
        map<id,string> newInsope=new map<id,string>();
        set<id>opportunityIDs=new set<id>();
        list<String> newInscopefactory=new list<String>();
        list<String> oldInscopefactory=new list<String>();
        Set<String> incopeFacoryset= new Set<String>();
        
         
        
         
        List<watcherWrapper> watcherWrapperclass =new list<watcherWrapper>();
        watcherWrapper wrapper;
        for(Opportunity oppRec:oldoppdetails){
            oldTsdm.put(oppRec.id,oppRec.TSDM_Region__c);
            oldOG.put(oppRec.id,oppRec.OG_Dev_Field__c);
            oldInsope.put(oppRec.id,oppRec.In_scope_Factories__c);
        }
        for(Opportunity oppRec:newoppdetails){
            newTsdm.put(oppRec.id,oppRec.TSDM_Region__c);
            newOG.put(oppRec.id,oppRec.OG_Dev_Field__c);
            newInsope.put(oppRec.id,oppRec.In_scope_Factories__c);
            opportunityIDs.add(oppRec.id);
            
        }
         
         if(watcherFlag){
             for(Opportunity oppRec:newoppdetails){
                 oppIdFinalSet.add(oppRec.id);
             }
             watcherFlag=false;
             existingwatcher=[Select id,Watcher_Master__r.name,Opportunity__c from Watcher__c 
                                 where Opportunity__c in:opportunityIDs limit 5000];
         }
         
         if(oppIdFinalSet.containsAll(opportunityIDs)){
             
         }else {
             existingwatcher=[Select id,Watcher_Master__r.name,Opportunity__c from Watcher__c 
                                 where Opportunity__c in:opportunityIDs limit 5000];
         }
        
        for(Watcher__c watchRec:existingwatcher){
            system.debug('watchRec.Watcher_Master__r.name---->'+watchRec.Watcher_Master__r.name);
            if(oldTsdm.get(watchRec.Opportunity__c)!=null && newTsdm.get(watchRec.Opportunity__c)!=null && 
                oldTsdm.get(watchRec.Opportunity__c)!=newTsdm.get(watchRec.Opportunity__c) && 
                watchRec.Watcher_Master__r.name.contains(oldTsdm.get(watchRec.Opportunity__c))){
                        wrapper =new watcherWrapper();
                        wrapper.id=watchRec.id;
                        wrapper.tobedeleted=true;
                        watcherWrapperclass.add(wrapper);
                        system.debug('in watcher geo wala loop');
            }
            if(oldOG.get(watchRec.Opportunity__c)!=null && newOG.get(watchRec.Opportunity__c)!=null && oldOG.get(watchRec.Opportunity__c)!=newOG.get(watchRec.Opportunity__c)
                && watchRec.Watcher_Master__r.name.contains(oldOG.get(watchRec.Opportunity__c))){
                        wrapper =new watcherWrapper();
                        wrapper.id=watchRec.id;
                        wrapper.tobedeleted=true;
                        watcherWrapperclass.add(wrapper);
                        system.debug('in watcher og wala loop');
            }
            if(newInsope.get(watchRec.Opportunity__c)!=oldInsope.get(watchRec.Opportunity__c)){
                if(newInsope.get(watchRec.Opportunity__c)!=null){
                    newInscopefactory=newInsope.get(watchRec.Opportunity__c).split(UtilConstants.SEMICOLON_STRING);
                }
                if(oldInsope.get(watchRec.Opportunity__c)!=null){
                    oldInscopefactory=oldInsope.get(watchRec.Opportunity__c).split(UtilConstants.SEMICOLON_STRING);
                }
                incopeFacoryset.addAll(newInscopefactory);
                for(String s:oldInscopefactory){
                    if(!incopeFacoryset.contains(s) && watchRec.Watcher_Master__r.name.contains(s)){
                        wrapper =new watcherWrapper();
                        wrapper.id=watchRec.id;
                        wrapper.tobedeleted=true;
                        watcherWrapperclass.add(wrapper);
                        system.debug('in watcher factory wala loop');
                    }
                    
                }
                newInscopefactory.clear();
                oldInscopefactory.clear();
                incopeFacoryset.clear();
            }
        }
        system.debug('watcherWrapperclass----------------------------->'+watcherWrapperclass);
        set<string>idstodelete=new set<string>();
        for(watcherWrapper wwr:watcherWrapperclass){
            if(wwr.tobedeleted){
                idstodelete.add(wwr.id);
            }
        }
        system.debug('idstodelete----------------------------->'+idstodelete);
        if(!watcherWrapperclass.isEmpty()){
            List<Watcher__c> watcherRecToDelete=[Select id from Watcher__c where id in:idstodelete];
            try{
                database.delete(watcherRecToDelete,true);
            }
            catch(Exception e){
                
            }
        }
     }
     
     /**
     * @description :Wrapper class for watcher.
     */
     
     public class watcherWrapper{
         public String id;
         public boolean tobedeleted;
     }
     
}