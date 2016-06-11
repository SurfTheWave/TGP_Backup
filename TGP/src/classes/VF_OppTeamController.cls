/**
 * @author         
 * @date          04/10/2013
 * @description   This is utility class used for the purpose of creating Master user record.
 * @vesion        <1.0>
 */
public with sharing class VF_OppTeamController {
    public string oppId {get;set;}
    public Opportunity_Teams__c oppteam {get;set;}
    public String diplayErrorRole {get;set;}
    public String retUrl;
    public Boolean isOppRO{get;set;}
    public Boolean isOppROLE{get;set;}
    public Boolean isOppDmatROLE{get;set;}
    public Boolean isOppMobROLE{get;set;}
    public String profileName{get;set;}
    public Boolean isIoProfile{get;set;}
    public boolean isOffering{get;set;}
    public boolean CanBeAssignedByPMO{get;set;}
    public Id opportunityId{get;set;}
    public List<Opportunity_teams__c> oppTeamList=new List<Opportunity_teams__c>();
    public List<Opportunity_Team_Role_Master__c> oppRoleMasterList=new List<Opportunity_Team_Role_Master__c>();
    public set<String> roles=new set<String>();
    public set<String> masterRoleSet=new set<String>();
    
    public Boolean isError{get;set;}
    public Boolean BPOGroup{get;set;}
    public Boolean IOGroup{get;set;} 
    public Boolean ICGroup{get;set;} 
    public Boolean BundledGroup{get;set;}
    public Boolean ISgroup{get;set;}  
    public String userId{get;set;}
    public String userType{get;set;}
    public set<String> serviceGroup=new set<String>();
    
     /**
     * @description       This method uses the Opportunity_Teams__c standard controller  .
     * @param             Client_Specific_Process__c standard Controller 
     * @return            Client_Specific_Process__c records on the VF_ClientProcess
     * @throws            NA
     */    
    public VF_OppTeamController(ApexPages.StandardController controller) {
        Profile p = [Select Name from Profile where Id =: userinfo.getProfileid() LIMIT 5000];
        profileName = p.Name;
        if(profileName.startsWith(UtilConstants.IO_solution)|| profileName.startsWith(UtilConstants.IC_solution)){
            isIoProfile = true;
        }
        CanBeAssignedByPMO = true;
        userId=userinfo.getuserid();
        User user=[select user_type__c from user where id=:userId];
        userType=user.user_type__c ;
        isError=false;
        BPOGroup=false;
        IOGroup=false;
        ICGroup=false;
        ISgroup=false;
        BundledGroup=false;
        
        oppId = ApexPages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID);
        retUrl = ApexPages.currentPage().getParameters().get(UtilConstants.RET_URL);
        this.oppteam  = (Opportunity_Teams__c )controller.getRecord();
        //if(!oppId.isBlank()){}
        if(oppId != null && oppId != UtilConstants.EMPTY_STRING){
        oppteam = [SELECT Id, Opportunity__c, Opportunity__r.Name, Opportunity_Team_Member__c, Opportunity_Team_Member__r.Name, 
                    Request_Team_Member__c, Requestor_Comments__c, Needed_By_Date__c, 
                    Role__c, Role__r.name, Offering__c, Offering__r.name FROM
                    Opportunity_Teams__c where Id=:oppId LIMIT 5000];
            if(oppteam.Opportunity__c != null){
                isOppRO = true;
            }
        }
        diplayErrorRole = UtilConstants.DISPLAY_NONE;
    }
    /**
    * @description       This action function save the Opportunity Teams specific record.
    * @param             Deal, Opportunity Team Member, Solution Scope parametrs are provided through VF_OppTeam UI functionality
    * @return            Null
    * @throws            NA
    */
    public pageReference saveRecord(){
         //system.debug('Total rec--'+oppteam);
         try{
            //system.debug('oppteam.Role__c--'+oppteam.Role__c);
            if(oppteam.Role__c!=null){
                ////system.debug('Not Null');
            }else{
                ////system.debug('Null');
            }
            //if(!oppId.isBlank()){}
            if(oppId != null && UtilConstants.EMPTY_STRING != oppId){
                Database.update(oppteam, true);
                return new PageReference(UtilConstants.SLASH+retUrl); 
            }else if(isError){
                  if(!oppTeam.Request_Team_Member__c){                    
                        return null;
                    }
                    else{
                        isError=false;
                        Database.insert(oppteam, true);    
                        return new PageReference(UtilConstants.SLASH+retUrl);
                     }
            }else{
                Database.insert(oppteam, true);    
                        return new PageReference(UtilConstants.SLASH+retUrl);
            }         
        }catch(exception e){
            //system.debug('error--'+e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            //ApexPages.addMessage(myMsg);                
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            ApexPages.addMessages(e);
            String msg = e.getMessage();
        }
        return null;
    }
    
    public PageReference validateRecord(){
     try{
             opportunityId=oppTeam.opportunity__c;
             serviceGroup=new set<String>();
                Opportunity opp=[select Service_Grp__c,BPO_Opportunity__c,IC_Opportunity__c,IO_Opportunity__c from Opportunity where id=:opportunityId limit 1];
                serviceGroup.add(opp.Service_Grp__c);
                if(UtilConstants.BPO.equals(opp.Service_Grp__c)){
                    BPOGroup=true;
                }else if(UtilConstants.IO.equals(opp.Service_Grp__c)){
                    IOGroup=true;
                }else if(UtilConstants.IC.equals(opp.Service_Grp__c)){
                    ICGroup=true;
                }else if((UtilConstants.BPO + UtilConstants.IS).equals(opp.Service_Grp__c)){
                    if(userType!=null && !UtilConstants.EMPTY_STRING.equals(userType)){
                         if((userType).equals('Solution - BPO')){
                            serviceGroup.add(UtilConstants.BPO);
                            BundledGroup =true;
                        }else if((userType).equals('Solution – IS')){
                            ISgroup=true;
                            if(opp.IO_Opportunity__c && opp.IC_Opportunity__c){
                                serviceGroup.add(UtilConstants.IO);
                                serviceGroup.add(UtilConstants.IC);
                            }else if(opp.IC_Opportunity__c){
                                serviceGroup.add(UtilConstants.IC);
                            }else if(opp.IO_Opportunity__c){
                                serviceGroup.add(UtilConstants.IO);
                                
                            }
                            
                        }
                    }
                }else {
                    ISgroup=true;
                    
                    if(opp.IO_Opportunity__c && opp.IC_Opportunity__c){
                        serviceGroup.add(UtilConstants.IO);
                        serviceGroup.add(UtilConstants.IC);
                    }else if(opp.IO_Opportunity__c){
                        serviceGroup.add(UtilConstants.IO);
                    }else if(opp.IC_Opportunity__c){
                        serviceGroup.add(UtilConstants.IC);
                    }
                    ISgroup=true;
                }
                //system.debug('user type is' +userType);
                
               
                //system.debug('service type is' +serviceGroup);
                //system.debug('BEfore query');
                Opportunity_Roles_Master__c oppMaster=[select id,name,CanBeAssignedByPMO__c from Opportunity_Roles_Master__c 
                where id=:oppTeam.role__c limit 1];
                //system.debug('After query');
                oppTeam.Request_Team_Member__c = false;
                if(oppMaster.CanBeAssignedByPMO__c){
                    CanBeAssignedByPMO = !oppMaster.CanBeAssignedByPMO__c;
                    //system.debug('Oh so Pretty: '+CanBeAssignedByPMO);
                }
                //system.debug('Setting things Up');
                if(UtilConstants.TECHNICAL_ARCHITECT.equals(oppMaster.name)){
                //system.debug('Nigaho me meri jo hai bas gaya');
                     isOppROLE=true;
                     isOppMobROLE = false;
                     isOppDmatROLE = false;
                }
                else if(oppMaster.name=='Mobilization Architect'){                                  
                    isOppMobROLE=true;
                    isOppROLE=false;
                    isOppDmatROLE = false;
                }
                else if(oppMaster.name=='DMAT User'){
                    isOppDmatROLE=true;
                    isOppROLE = false;
                    isOppMobROLE = false;
                }
                else{
                    isOppROLE = false;
                    isOppMobROLE = false;
                    isOppDmatROLE = false;
                }
                for(Opportunity_Team_Role_Master__c oppRoleMaster:[select Role_Name__c,Role_To_Be_Checked__c from 
                Opportunity_Team_Role_Master__c where Service_Group__c in :serviceGroup limit 1000]){
                    if(oppRoleMaster.Role_To_Be_Checked__c){
                        masterRoleSet.add(oppRoleMaster.Role_Name__c);
                    }else{
                        roles.add(oppRoleMaster.Role_Name__c);    
                    }
                }
                
                oppTeamList=Database.query('select id from Opportunity_Teams__c where Opportunity__c=:opportunityId and role__r.name IN :masterRoleSet');
                
                if(roles.contains(oppMaster.name)){
                    if(!oppTeamList.isEmpty() && (oppTeamList.size()==masterRoleSet.size())){
                        isError=false;
                        return null;
                    }else{
                         //system.debug('Test Statement for debug process');
                         isError=true;
                         //system.debug('Booleab value is' +isError);
                         return null;
                    }
                 }else{
                        isError=false;
                        return null;
                 }
     }catch(Exception e){
     
     }
     return null;
                
    }
    
    /**
    * @description       This action function refreshes the UI functionality page.
    * @param             Refershes VF_OppTeam UI functionality
    * @return            Null
    * @throws            NA
    */
    public pageReference refreshPg(){
        //system.debug('Hosanna--'+oppteam.Opportunity__c);
        string role = system.currentPageReference().getParameters().get(UtilConstants.ROLE_VALUE);
        //system.debug('role received---> '+role );
        if(UtilConstants.TECHNICAL_ARCHITECT.equals(role)){
                  isOppROLE=true;
                  isOppMobROLE = false;
                  isOppDmatROLE = false;
        }       
        else if(role =='Mobilization Architect'){                                  
                    isOppMobROLE=true;
                    isOppROLE=false;
                    isOppDmatROLE = false;
               }
        else if(role =='DMAT User'){
                    isOppDmatROLE=true;
                    isOppROLE = false;
                    isOppMobROLE = false;
                }
        else{
                    isOppROLE = false;
                    isOppMobROLE = false;
                    isOppDmatROLE = false;
                }   
        //system.debug('opprole---> '+isOppROLE);      
        return null;
    }
    

     /**
    * @description       This action function defined for disabling
    * @param             Null
    * @return            Null
    * @throws            NA
    */
     public pageReference disableoff(){
      string role = system.currentPageReference().getParameters().get(UtilConstants.ROLE_VALUE);
        //system.debug('role received---> '+role );
        if( UtilConstants.SUP_TECHARCH.equals(role)){
                  isOffering=true;
        }
        else{
            isOffering=false;
        }  
        //system.debug('offering---> '+isOffering);      
        return null;
 }    
}