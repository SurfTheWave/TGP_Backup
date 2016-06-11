/**
     * @author         Madhusudhan
     * @date          06/05/2015
     * @description   This class is used for insert/ update record in Client Specific proccess object while select the value from custom lookup click the save button.
     * @vesion        <1.0>
     */
    public with sharing class waveProcessController {
        public string dealId {get;set;}
        public Wave_Proc__c waveProcess {get;set;}
        public Mobilization_Plan__c mobPlan {get;set;}
        public String diplayErrorOffering {get;set;}
        public String diplayErrorService {get;set;}
        public String diplayErrorClientProcess {get;set;}
        public Boolean diplayInfServ {get;set;}
        public String diplayErrorInfServ {get;set;}
        public String diplayErrorDelLoc {get;set;}
        public String diplayErrorSendingDelLoc {get;set;}
        public String diplayErrorNoofProjFTE {get;set;}
        public String retUrl;
        public String sendingLocationId {get; set;}
        public String serviceGroup {get; set;}
        
        public String ClientProcessLookUpStr{get;set;}
        public String InfrastructLookUpStr{get;set;}
        
        public String SendLocLookUpStr{get;set;}
        public String RecvLocLookUpStr{get;set;}
         /**
         * @description       This method uses the Wave_Proc__c standard controller  .
         * @param             Wave_Proc__c standard Controller 
         * @return            Wave_Proc__c records on the wave process
         * @throws            NA
         */    
        public waveProcessController(ApexPages.StandardController controller) {
            
            dealId = ApexPages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID);
           // system.debug('dealId ----'+dealId );
           
            retUrl = ApexPages.currentPage().getParameters().get(UtilConstants.RET_URL);
            
            
             
            if(dealId!= null && dealId!= UtilConstants.EMPTY_STRING){
             waveProcess = [SELECT Id,Active__c,Name,Mobilization_Plan__r.name,Mobilization_Plan__r.Deal__c,
                            Wave__r.name, Mobilization_Plan__r.Service_Group__c, Wave_Client_Specific_Process__c,
                            Wave_Client_Specific_Process__r.name,Wave_Process_Location__c,Sending_Location__c,
                            Wave_Process_Location__r.name,Sending_Location__r.name,Number_of_Projected_FTEs__c,
                            Wave_Infrastructure_Service__c,Wave_Infrastructure_Service__r.name,
                            Wave_Process_RAG_Status__c, Wave_Process_RAG_Comments__c, 
                            Wave_Process_Completion_Status__c, Mobilization_Plan__r.IsTRackingOn__c 
                            FROM Wave_Proc__c where Id=:dealId LIMIT 5000];
            ClientProcessLookUpStr = waveProcess.Wave_Client_Specific_Process__r.name;
            InfrastructLookUpStr=    waveProcess.Wave_Infrastructure_Service__r.name;
            
            SendLocLookUpStr=waveProcess.Sending_Location__r.name;
            RecvLocLookUpStr=waveProcess.Wave_Process_Location__r.name;                                            
            
            }else{
                waveProcess  = (Wave_Proc__c)controller.getRecord();
                
            }
            
            String mobid=(waveProcess.Mobilization_Plan__c);
            if(!string.isBlank(mobid)){
                mobPlan=[select deal__c,  Service_Group__c  from Mobilization_Plan__c where id=:mobid.trim() limit 1];
            }
            serviceGroup = mobPlan.Service_Group__c;
            
            if(serviceGroup==UtilConstants.IO){
                diplayInfServ=true;    
            }else{
                diplayInfServ=false;
            }
            
            diplayErrorClientProcess = UtilConstants.DISPLAY_NONE;
            diplayErrorInfServ=UtilConstants.DISPLAY_NONE;
            diplayErrorDelLoc =UtilConstants.DISPLAY_NONE;
            diplayErrorSendingDelLoc=UtilConstants.DISPLAY_NONE;
            diplayErrorNoofProjFTE=UtilConstants.DISPLAY_NONE;
        }
        /**
        * @description       This action function save the wave process specific record.
        * @param             NA
        * @return            Null
        * @throws            NA
        */
        public pageReference saveRecord(){
             
             diplayErrorClientProcess = UtilConstants.DISPLAY_NONE;
             diplayErrorInfServ=UtilConstants.DISPLAY_NONE;
             diplayErrorDelLoc =UtilConstants.DISPLAY_NONE;
             diplayErrorSendingDelLoc=UtilConstants.DISPLAY_NONE;
             diplayErrorNoofProjFTE=UtilConstants.DISPLAY_NONE;
             
             ClientProcessLookUpStr = ApexPages.currentPage().getParameters().get(UtilConstants.CLIENTPROCESSLOOKUPSTR);
             InfrastructLookUpStr=ApexPages.currentPage().getParameters().get(UtilConstants.INFRASTRUCTLOOKUPSTR);
             
             SendLocLookUpStr=ApexPages.currentPage().getParameters().get(UtilConstants.SENDLOCLOOKSTR);
             RecvLocLookUpStr=ApexPages.currentPage().getParameters().get(UtilConstants.RECVLOCLOOKUPSTR);
             
             try{
                boolean errorexist=false; 
                if(serviceGroup==UtilConstants.IO){
                    if(waveProcess.Wave_Infrastructure_Service__c ==null || String.ISBLANK(String.Valueof(waveProcess.Wave_Infrastructure_Service__c))){
                        diplayErrorInfServ=UTIL_Constants.DISPLAY_BLOCK;
                        errorexist=true;
                    }        
                }else{
                    if(waveProcess.Wave_Client_Specific_Process__c==null || String.ISBLANK(String.Valueof(waveProcess.Wave_Client_Specific_Process__c))){
                        diplayErrorClientProcess =UTIL_Constants.DISPLAY_BLOCK;
                        errorexist=true;
                    }
                }
                if(waveProcess.Sending_Location__c ==null 
                   || String.ISBLANK(String.Valueof(waveProcess.Sending_Location__c))){
                    diplayErrorSendingDelLoc=UTIL_Constants.DISPLAY_BLOCK;
                    errorexist=true;
                }
                if(waveProcess.Wave_Process_Location__c ==null 
                   || String.ISBLANK(String.Valueof(waveProcess.Wave_Process_Location__c))){
                    diplayErrorDelLoc =UTIL_Constants.DISPLAY_BLOCK;
                    errorexist=true;
                }
                if(waveProcess.Number_of_Projected_FTEs__c ==null || 
                   String.ISBLANK(String.Valueof(waveProcess.Number_of_Projected_FTEs__c))){
                    diplayErrorNoofProjFTE =UTIL_Constants.DISPLAY_BLOCK;
                    errorexist=true;
                }
                //system.debug('diplayErrorInfServ::'+diplayErrorInfServ);
                //system.debug('diplayErrorClientProcess::'+diplayErrorClientProcess);
                //system.debug('diplayErrorSendingDelLoc::'+diplayErrorSendingDelLoc);
                //system.debug('diplayErrorDelLoc::'+diplayErrorDelLoc);
                //system.debug('diplayErrorNoofProjFTE::'+diplayErrorNoofProjFTE);
                //system.debug('errorexist::'+errorexist);
                if(errorexist){
                    return null;
                }else{
                    if(dealId != null && dealId != UtilConstants.EMPTY_STRING){
                        Database.update(waveProcess, true);
                    }else{
                        Database.insert(waveProcess, true);
                    }
                    return new PageReference('/'+waveProcess.Id);
                }
                
              }catch(DMLException e){
                ApexPages.Message errMsg= new ApexPages.Message(ApexPages.Severity.ERROR, e.getDmlMessage(0));
                ApexPages.addMessage(errMsg);  
                return null;
        
            }catch(exception e){
                String msg = e.getMessage();
                //system.debug('Exp...'+e);
                 return null;
            }
           
        }
        /**
        * @description       This action function refreshes the UI functionality page.
        * @param             Refershes VF_OppTeam UI functionality
        * @return            Null
        * @throws            NA
        */
        public pageReference refreshPg(){
            //System.debug('Refresh Mth--'+oppteam.Opportunity__c);
            return null;
        }
        
        @RemoteAction
        /**
        * @description       This is a method in MWB.
        * @Name              getData1
        * @param             
        * @return            query
        * @throws            NA
        */
    public static List<SObject> getData1(String param){
        //System.debug('Inside Method');
        param = String.escapeSingleQuotes(param);
        return Database.query(UTIL_Constants.mobTeamStrSQL1+param+UTIL_Constants.mobTeamStrSQL2);
    }
       
    }