/*
* This class will be used as business logic controller for trigger OperationOnOffering on Opportunity_Offering__c
*
*  @Author Accenture Team
*  @Date 18/02/2014 
*/
public with sharing class offeringTriggerController {
    private static final string CLASS_NAME = 'offeringTriggerController';
    private static final string TRIGGER_NAME = 'OperationOnOffering';
    private static final string METHOD_INSERT = 'insertSolUserAssignment';
    private static final string METHOD_UPDATE = 'updateAndEmailSolUserAssignement';
    private static final string METHOD_DELETE = 'deleteOfferingrec';
    private static final string METHOD_UPDATE_BPO = 'updateBPOOpportunityField';
    
    /*
    *   @Method : insertSolUserAssignment
    *   @ Description : This mehod insert the solution user assignment records and Update BPO Opportunity fields
    */
    public static void insertSolUserAssignment (List<Opportunity_Offering__c> newOffList) {
    
        
        List<Solution_User_Assignment__c> solUserAssigList = new List<Solution_User_Assignment__c>();
        try{
        
            updateBPOOpportunityField(newOffList); 

             
            Opportunity_Offering__c  offeringRec = [Select id,Opportunity_TGP__c,Opportunity_TGP__r.Client_Name__r.name,Opportunity_TGP__r.name,
                                                                Offering_Master__r.name,Offering_Master__r.id,Solution_Specialist_New__c,Solution_Specialist_New__r.SFDC_User__c,
                                                                Functional_Architect_Mobilization_New__c, Functional_Architect_Mobilization_New__r.SFDC_User__c,Technical_Architect_New__c,Technical_Architect_New__r.SFDC_user__c, 
                                                                Opportunity_TGP__r.SAP_OM_Opportunity__r.name from Opportunity_Offering__c 
                                                                where id=:newOffList[0].id limit 1];
            Solution_User_Assignment__c  solUserAssign;
            for(Integer i = 0; i<3 ; i++) {
                solUserAssign = new Solution_User_Assignment__c();
                solUserAssign.Offering_Id__c= offeringRec.id;
                solUserAssign.Solutions__c= offeringRec.id;
                solUserAssign.BPO_Opportunity__c= offeringRec.Opportunity_TGP__c;
                solUserAssign.ClientName__c = offeringRec.Opportunity_TGP__r.Client_Name__r.name;        
                solUserAssign.SAP_OM_ID__c = offeringRec.Opportunity_TGP__r.SAP_OM_Opportunity__r.name;
                solUserAssign.Offering_Master__c= offeringRec.Offering_Master__r.id;
                solUserAssign.User__c = UserInfo.getUserId();
                if(i == 0) {
                    solUserAssign.Role__c = UTIL_Constants.MOBILIZATION_ARCHITECT;
                    if(String.isEmpty(offeringRec.Functional_Architect_Mobilization_New__c)) {
                        solUserAssign.Resource_Assigned_User_New__c = offeringRec.Functional_Architect_Mobilization_New__c;
                    }
                }
                else if(i == 1) {
                    solUserAssign.Role__c = UTIL_Constants.SOLUTION_SPECIALIST;
    
                    if(String.isEmpty(offeringRec.Solution_Specialist_New__c)) {
                        solUserAssign.Resource_Assigned_User_New__c = offeringRec.Solution_Specialist_New__c;
                    }
                }
                else {
                    solUserAssign.Role__c = UTIL_Constants.TECHNICAL_ARCHITECT;
                    if(String.isEmpty(offeringRec.Technical_Architect_New__c)) {
                        solUserAssign.Resource_Assigned_User_New__c = offeringRec.Technical_Architect_New__c;
                    }
                }
                solUserAssigList.add(solUserAssign);
            }

            
            if(solUserAssigList.size()>0) {
                Database.insert(solUserAssigList,false);
            }
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_INSERT, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }
    }
    /*
    *   @Method : updateAndEmailSolUserAssignement
    *   @ Description : This mehod update the solution user assignment records and Update BPO Opportunity fields
    */
    public static void updateAndEmailSolUserAssignement(List<Opportunity_Offering__c> newOffList) {

        
        PMOSolutionUserAssignmentController pmoassign = new PMOSolutionUserAssignmentController();
        try {

            updateBPOOpportunityField(newOffList);  

            Opportunity_Offering__c  offeringRec = [Select id,Opportunity_TGP__c,Opportunity_TGP__r.Client_Name__r.name,Opportunity_TGP__r.name,
                                                                Offering_Master__r.name,Offering_Master__r.id,Solution_Specialist_New__c,
                                                                Functional_Architect_Mobilization_New__c,Technical_Architect_New__c, 
                                                                Opportunity_TGP__r.SAP_OM_Opportunity__r.name from Opportunity_Offering__c 
                                                                where id=:newOffList[0].id limit 1];
            List<Solution_User_Assignment__c> solUserAssignList = [Select User__c, SAP_OM_ID__c, ClientName__c, Id,
                                                                    Resource_Assigned_User_New__c, Resource_Assigned_User_New__r.SFDC_User__c, BPO_Opportunity__c,Role__c,Offering_Id__c,Status__c,Date_Assigned__c 
                                                                    From Solution_User_Assignment__c where Offering_Id__c=:newOffList[0].id];
            Opportunity_Offering__c oldOffRec = (Opportunity_Offering__c)Trigger.oldMap.get(offeringRec.ID);
            if(offeringRec.Solution_Specialist_New__c != oldOffRec.Solution_Specialist_New__c || 
                offeringRec.Functional_Architect_Mobilization_New__c != oldOffRec.Functional_Architect_Mobilization_New__c || 
                offeringRec.Technical_Architect_New__c != oldOffRec.Technical_Architect_New__c) {
                for(Solution_User_Assignment__c solUSRRec : solUserAssignList){ 
                    solUSRRec.Offering_Id__c = offeringRec.id;
                    solUSRRec.Solutions__c = offeringRec.id;
                    solUSRRec.BPO_Opportunity__c = offeringRec.Opportunity_TGP__c;
                    solUSRRec.ClientName__c = offeringRec.Opportunity_TGP__r.Client_Name__r.name;        
                    solUSRRec.SAP_OM_ID__c = offeringRec.Opportunity_TGP__r.SAP_OM_Opportunity__r.name;
                    solUSRRec.Offering_Master__c = offeringRec.Offering_Master__r.id;
                    if(!String.isEmpty(solUSRRec.Resource_Assigned_User_New__c)) {
                        if(UTIL_Constants.MOBILIZATION_ARCHITECT.equalsIgnoreCase(solUSRRec.Role__c) && String.isEmpty(offeringRec.Functional_Architect_Mobilization_New__c)) {
                            solUSRRec.Resource_Assigned_User_New__c = null;
                            solUSRRec.Status__c = UTIL_Constants.STR_NEW;
                            solUSRRec.Requester_Name__c = null;
                            solUSRRec.Date_Assigned__c = null;
                            solUSRRec.Date_Requested__c = null;
                            solUSRRec.Date_Needed_by__c = null;
                        }
                        if(UTIL_Constants.TECHNICAL_ARCHITECT.equalsIgnoreCase(solUSRRec.Role__c) && String.isEmpty(offeringRec.Technical_Architect_New__c)) {
                            solUSRRec.Resource_Assigned_User_New__c = null;
                            solUSRRec.Status__c = UTIL_Constants.STR_NEW;
                            solUSRRec.Requester_Name__c = null;
                            solUSRRec.Date_Assigned__c = null;
                            solUSRRec.Date_Requested__c = null;
                            solUSRRec.Date_Needed_by__c = null;
                        }
                        if(UTIL_Constants.SOLUTION_SPECIALIST.equalsIgnoreCase(solUSRRec.Role__c) && String.isEmpty(offeringRec.Solution_Specialist_New__c)) {
                            solUSRRec.Resource_Assigned_User_New__c = null;
                            solUSRRec.Status__c = UTIL_Constants.STR_NEW;
                            solUSRRec.Requester_Name__c = null;
                            solUSRRec.Date_Assigned__c = null;
                            solUSRRec.Date_Requested__c = null;
                            solUSRRec.Date_Needed_by__c = null;
                        }
                    }
                    if(UTIL_Constants.STR_NEW.equalsIgnoreCase(solUSRRec.Status__c) && UTIL_Constants.MOBILIZATION_ARCHITECT.equalsIgnoreCase(solUSRRec.Role__c)
                                 && !String.isEmpty(offeringRec.Functional_Architect_Mobilization_New__c)) {
                        solUSRRec.Resource_Assigned_User_New__c = offeringRec.Functional_Architect_Mobilization_New__c;
                        solUSRRec.Status__c = UTIL_Constants.ASSIGNED;
                        solUSRRec.Requester_Name__c = UserInfo.getUserId();
                        solUSRRec.Date_Assigned__c = system.today();
                        solUSRRec.Date_Requested__c = system.today();
                        solUSRRec.Date_Needed_by__c = system.today();
                    }
                    if(UTIL_Constants.STR_NEW.equalsIgnoreCase(solUSRRec.Status__c) && UTIL_Constants.TECHNICAL_ARCHITECT.equalsIgnoreCase(solUSRRec.Role__c)
                                 && !String.isEmpty(offeringRec.Technical_Architect_New__c)) {
                        solUSRRec.Resource_Assigned_User_New__c = offeringRec.Technical_Architect_New__c;
                        solUSRRec.Status__c = UTIL_Constants.ASSIGNED;
                        solUSRRec.Requester_Name__c = UserInfo.getUserId();
                        solUSRRec.Date_Assigned__c = system.today();
                        solUSRRec.Date_Requested__c = system.today();
                        solUSRRec.Date_Needed_by__c = system.today();
                    }
                    if(UTIL_Constants.STR_NEW.equalsIgnoreCase(solUSRRec.Status__c) && UTIL_Constants.SOLUTION_SPECIALIST.equalsIgnoreCase(solUSRRec.Role__c)
                                 && !String.isEmpty(offeringRec.Solution_Specialist_New__c)) {
                        solUSRRec.Resource_Assigned_User_New__c = offeringRec.Solution_Specialist_New__c;
                        solUSRRec.Status__c = UTIL_Constants.ASSIGNED;
                        solUSRRec.Requester_Name__c = UserInfo.getUserId();
                        solUSRRec.Date_Assigned__c = system.today();
                        solUSRRec.Date_Requested__c = system.today();
                        solUSRRec.Date_Needed_by__c = system.today();
                    }
                    if(UTIL_Constants.MOBILIZATION_ARCHITECT.equalsIgnoreCase(solUSRRec.Role__c) && !String.isEmpty(solUSRRec.Resource_Assigned_User_New__c) && !String.isEmpty(offeringRec.Functional_Architect_Mobilization_New__c) && offeringRec.Functional_Architect_Mobilization_New__c != solUSRRec.Resource_Assigned_User_New__c) {
                        solUSRRec.Resource_Assigned_User_New__c = offeringRec.Functional_Architect_Mobilization_New__c;
                    }
                    if(UTIL_Constants.TECHNICAL_ARCHITECT.equalsIgnoreCase(solUSRRec.Role__c) && !String.isEmpty(solUSRRec.Resource_Assigned_User_New__c) && !String.isEmpty(offeringRec.Technical_Architect_New__c) && offeringRec.Technical_Architect_New__c != solUSRRec.Resource_Assigned_User_New__c) {
                        solUSRRec.Resource_Assigned_User_New__c = offeringRec.Technical_Architect_New__c;
                    }
                    if(UTIL_Constants.SOLUTION_SPECIALIST.equalsIgnoreCase(solUSRRec.Role__c) && !String.isEmpty(solUSRRec.Resource_Assigned_User_New__c) && !String.isEmpty(offeringRec.Solution_Specialist_New__c) && offeringRec.Solution_Specialist_New__c != solUSRRec.Resource_Assigned_User_New__c) {
                        solUSRRec.Resource_Assigned_User_New__c = offeringRec.Solution_Specialist_New__c;
                    } 
                }
                Database.upsert(solUserAssignList,false);
                for(Solution_User_Assignment__c solUserAssignEmail : solUserAssignList){
                    String oppId=solUserAssignEmail.BPO_Opportunity__c;
                    String roleName=solUserAssignEmail.Role__c;
                    String dateNeeded ;
                    String dateRequested ;
                    String comment=solUserAssignEmail.Comments__c;
                    String toAddressId=solUserAssignEmail.Resource_Assigned_User_New__r.SFDC_User__c;
                    String resourceRequest=solUserAssignEmail.Requester_Name__c;
                    if(solUserAssignEmail.Date_Needed_by__c != null){
                        DateTime dtValue = DateTime.newInstance(solUserAssignEmail.Date_Needed_by__c.year(), solUserAssignEmail.Date_Needed_by__c.month(), 
                                                solUserAssignEmail.Date_Needed_by__c.day());                                    
                        dateNeeded= dtValue.format(UTIL_Constants.DATE_FORMAT);                        
                    }
                    if(solUserAssignEmail.Date_Requested__c != null){
                        DateTime dtValue1 = DateTime.newInstance(solUserAssignEmail.Date_Requested__c.year(), solUserAssignEmail.Date_Requested__c.month(), 
                                                solUserAssignEmail.Date_Requested__c.day());                                    
                        dateRequested= dtValue1.format(UTIL_Constants.DATE_FORMAT);
                    }
                    pmoassign.sendEmailAlertToAssignedUser(oppId, roleName, dateNeeded, dateRequested, comment, resourceRequest, toAddressId);
                }
            }  
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_UPDATE, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }                      
    }
    /*
    *   @Method : deleteOfferingrec
    *   @ Description : This mehod delete the solution user assignment records and Update BPO Opportunity fields
    */
    public static void deleteOfferingrec (List<Opportunity_Offering__c> lstOldId) {
        set<id> lstId = new set<id>();
        set<id> lstOppId = new set<id>();
        set<id> lstOffId = new set<id>();
        try {
            for(Opportunity_Offering__c tmpId: lstOldId) {
               lstId.add(tmpId.id);
               lstOppId.add(tmpId.Opportunity_TGP__c);
               lstOffId.add(tmpId.Offering_Master__c);
            }
            System.debug('++++'+lstId );
            System.debug('++++'+lstOppId );
            System.debug('++++'+lstOffId);
            list<Solution_User_Assignment__c> DeleteList = [Select Id From Solution_User_Assignment__c where Offering_Id__c =:lstId limit 5000 ];
            list<Opportunity_Team__c> deleteOppTeam = [Select Id from Opportunity_Team__c where Offering__c IN:lstOffId AND BPO_Opportunity__c IN:lstOppId limit 100];
            if(DeleteList.size()>0) {
                Database.delete(DeleteList,false) ;
            }
            if(deleteOppTeam.size()>0) {
                Database.delete(deleteOppTeam,false) ;
            }
            deleteofferingopportunitycontroller controller = new deleteofferingopportunitycontroller();
            controller.delteteoffering();
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_DELETE, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }   
    }
    /*
    *   @Method : updateBPOOpportunityField
    *   @ Description : This mehod Update BPO Opportunity fields
    */
    public static void updateBPOOpportunityField(List<Opportunity_Offering__c> newOffList) {
        Set<Id> bpoOppIdSet = new set<Id>();
        try {
            for(Opportunity_Offering__c off : newOffList) {
                bpoOppIdSet.add(off.Opportunity_TGP__c);
            }
            List<Opportunity_TGP__c> bpoOppList =  [Select Offerings__c,Offering_Solution_Leads__c,Offering_Solution_Specialists__c 
                                                        from Opportunity_TGP__c where ID in:bpoOppIdSet];
            new UTIL_CorrectionOpportunityData().updateOpportunityRecord(bpoOppList); 
        }
        catch(Exception exp) {
            UTIL_LoggingService.logHandledException(exp, UTIL_Constants.ORG_ID, UTIL_Constants.APPLICATION_NAME, CLASS_NAME, METHOD_UPDATE_BPO, TRIGGER_NAME, 
                                                    System.Logginglevel.ERROR);
        }   
    }
    
    //public static Date dte = System.today();
        
        //Date dte = date.newinstance(2014,8,19);  
        
    //public static Datetime todaysDate = datetime.newInstance(dte.year(), dte.month(), dte.day());
    //public static String day = todaysDate.format('E');  
        
    //public static Date dte1;
        
         
        
    
        
    /*public static void insertSchedulingRec(List<Opportunity_Offering__c> lstNewOff) {
        
    Date d = System.today();
    Date mondayDate1 = d.toStartofWeek();
    DateTime mondayDate2; 
    DateTime mondayDateTime = datetime.newInstance(mondayDate1.year(), mondayDate1.month(),mondayDate1.day());  
    datetime myDate = datetime.newInstance(d.year(), d.month(),d.day());  
    String DayOfWeek = myDate.format('EEEE');                            
    if(DayOfWeek.equalsignorecase('Sunday')) {
        mondayDate2 = mondayDateTime - 6;
    }
    else {
        mondayDate2 = mondayDateTime + 1;
    }
     System.debug('--------mondayDate2 ------------------'+mondayDate2 );   
    String type_1='Opportunity_Offering__c';
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    Schema.SObjectType leadSchema = schemaMap.get(type_1);
    Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
    
    List<Scheduling__c> existingRecList = new List<Scheduling__c>();
    List<Scheduling__c> insertOffList = new List<Scheduling__c>();
    
    List<Scheduling__c> schList =  [SELECT Role_Name__c,User_Master__c,First_Date__c, Key_Field__c,User_Id__c,offerings__c FROM Scheduling__c WHERE BPO_Opportunity_MD__c=: lstNewOff[0].id];
        
         for(Opportunity_Offering__c offNewRec : [select Offering_Solution_Lead_Secondary_New__r.SFDC_User__c,Solution_Lead_New__r.SFDC_User__c,Solution_Specialist_New__r.SFDC_User__c,Technical_Architect_New__c,Technical_Architect_New__r.Name,Solution_Specialist_New__c,Opportunity_TGP__c,Solution_Specialist_New__r.Name,
                                                    Functional_Architect_Mobilization_New__r.Name,Functional_Architect_Mobilization_New__c,
                                                    Solution_Lead_New__r.Name,Solution_Lead_New__c,Offering_Solution_Lead_Secondary_New__r.Name,
                                                    Offering_Solution_Lead_Secondary_New__c from Opportunity_Offering__c where id =: lstNewOff[0].id] ){
            
            if(offNewRec.Solution_Lead_New__c != null){
            
                String label = fieldMap.get('Solution_Lead_New__c').getDescribe().getLabel();
            
                List<Scheduling__c> schListForUpdate = [select Role_Name__c, User_Master__c,Key_Field__c,User_Id__c,offerings__c 
                                                        FROM Scheduling__c WHERE Key_Field__c =: label+';'+offNewRec.Solution_Lead_New__c+';'+offNewRec.Opportunity_TGP__c];


                if(schListForUpdate.size()==0){
                
        
                            Scheduling__c obj = new Scheduling__c(); 
                            obj.BPO_Opportunity_MD__c = offNewRec.Opportunity_TGP__c; 
                            //obj.offerings__c = offNewRec.id;                
                            obj.Role_Name__c = label;
                            
                            obj.User_Id__c = offNewRec.Solution_Lead_New__c;
                            obj.User_Master__c = offNewRec.Solution_Lead_New__c;
                            obj.Key_Field__c = obj.Role_Name__c+';'+obj.User_Id__c+';'+obj.BPO_Opportunity_MD__c;
                            obj.First_Date__c = mondayDate2;
                            obj.User_SFDC_Id__c = offNewRec.Solution_Lead_New__r.SFDC_User__c;
                            obj.Current_week__c = 0;
                            obj.Current_week_1__c = 0;
                            obj.Current_week_2__c = 0;
                            obj.Current_week_3__c = 0;
                            obj.Ongoing__c = 0;
                            insertOffList.add(obj);
                        
                    }
                }
                
            
            
            
            
            if(offNewRec.Offering_Solution_Lead_Secondary_New__c != null){
            
                String label1 = fieldMap.get('Offering_Solution_Lead_Secondary_New__c').getDescribe().getLabel();

                List<Scheduling__c> schListForUpdate = [select Role_Name__c, User_Master__c,Key_Field__c,User_Id__c,offerings__c 
                                                        FROM Scheduling__c WHERE Key_Field__c =: label1+';'+offNewRec.Offering_Solution_Lead_Secondary_New__c+';'+offNewRec.Opportunity_TGP__c];

        
                if(schListForUpdate.size() == 0){
            
                
                        Scheduling__c obj = new Scheduling__c(); 
                        obj.BPO_Opportunity_MD__c = offNewRec.Opportunity_TGP__c; 
                        //obj.offerings__c = offNewRec.id;                
                        obj.Role_Name__c = label1;
                        
                        obj.User_Id__c = offNewRec.Offering_Solution_Lead_Secondary_New__c;
                        obj.User_Master__c = offNewRec.Offering_Solution_Lead_Secondary_New__c;
                        obj.Key_Field__c = obj.Role_Name__c+';'+obj.User_Id__c+';'+obj.BPO_Opportunity_MD__c;
                        obj.First_Date__c = mondayDate2;
                        obj.User_SFDC_Id__c = offNewRec.Offering_Solution_Lead_Secondary_New__r.SFDC_User__c;
                        obj.Current_week__c = 0;
                        obj.Current_week_1__c = 0;
                        obj.Current_week_2__c = 0;
                        obj.Current_week_3__c = 0;
                        obj.Ongoing__c = 0;
                        insertOffList.add(obj);
                    }   
                }
                if(offNewRec.Solution_Specialist_New__c != null){
            
                String label1 = fieldMap.get('Solution_Specialist_New__c').getDescribe().getLabel();

                List<Scheduling__c> schListForUpdate = [select Role_Name__c,User_Master__c, Key_Field__c,User_Id__c,offerings__c 
                                                        FROM Scheduling__c WHERE Key_Field__c =: label1+';'+offNewRec.Solution_Specialist_New__c+';'+offNewRec.Opportunity_TGP__c];

        
                if(schListForUpdate.size() == 0){
            
                
                        Scheduling__c obj = new Scheduling__c(); 
                        obj.BPO_Opportunity_MD__c = offNewRec.Opportunity_TGP__c; 
                        //obj.offerings__c = offNewRec.id;                
                        obj.Role_Name__c = label1;
                        
                        obj.User_Id__c = offNewRec.Solution_Specialist_New__c;
                        obj.User_Master__c = offNewRec.Solution_Specialist_New__c;
                        obj.Key_Field__c = obj.Role_Name__c+';'+obj.User_Id__c +';'+obj.BPO_Opportunity_MD__c;
                        obj.First_Date__c = mondayDate2;
                        obj.User_SFDC_Id__c = offNewRec.Solution_Specialist_New__r.SFDC_User__c;
                        obj.Current_week__c = 0;
                        obj.Current_week_1__c = 0;
                        obj.Current_week_2__c = 0;
                        obj.Current_week_3__c = 0;
                        obj.Ongoing__c = 0;
                        insertOffList.add(obj);
                    }   
                }
               
        }
        System.debug('--------insertOffList------------------'+insertOffList);
        insert insertOffList;
    }*/
     /*
    *   @Method : updateSchedulingRec
    *   @ Description : This mehod insert the solution user assignment records and Update BPO Opportunity fields
    */
    /*public static void updateSchedulingRec(List<Opportunity_Offering__c> lstNewOff,List<Opportunity_Offering__c> lstOldOff ) {
         Set<Scheduling__c> deleteList = new Set<Scheduling__c>();
         Set<String> keySetForSchRecord = new Set<String>();
         Set<Scheduling__c> insertOffList = new Set<Scheduling__c>();
         List<Scheduling__c> schdeleteList = new List<Scheduling__c>();
         List<Scheduling__c> schinsertOffList = new List<Scheduling__c>();
         Map<String, Scheduling__c> schMap = new Map<String, Scheduling__c>();
         
         Date d = System.today();
        Date mondayDate1 = d.toStartofWeek();
        DateTime mondayDate2; 
        DateTime mondayDateTime = datetime.newInstance(mondayDate1.year(), mondayDate1.month(),mondayDate1.day());  
        datetime myDate = datetime.newInstance(d.year(), d.month(),d.day());  
        String DayOfWeek = myDate.format('EEEE');                            
        if(DayOfWeek.equalsignorecase('Sunday')) {
            mondayDate2 = mondayDateTime - 6;
        }
        else {
            mondayDate2 = mondayDateTime + 1;
        }
        System.debug('--------mondayDate2 in update off ------------------'+mondayDate2 );
        String type_1='Opportunity_Offering__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type_1);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
        set<Id> BPOOpportunityIds = new  set<Id>(); 
        
          for(Opportunity_Offering__c oppOffering : lstNewOff) {
            BPOOpportunityIds.add(oppOffering.Opportunity_TGP__c);
          }
          
          Opportunity_Offering__c temp;
          Map<String, List<Scheduling__c>> schedulingRecordMap = new  Map<String, List<Scheduling__c>>();
          for(Scheduling__c schedulingRecord : [select Role_Name__c,id,User_Master__c,Current_week__c,Current_week_1__c,Current_week_2__c , Current_week_3__c ,Ongoing__c ,Key_Field__c,User_Id__c 
                                                            FROM Scheduling__c where BPO_Opportunity_MD__c IN:BPOOpportunityIds]) {
             List<Scheduling__c> schedulingRecordList = new List<Scheduling__c>{schedulingRecord};                                  
            schedulingRecordMap.put(schedulingRecord.Key_Field__c, schedulingRecordList);       
          }
          
          
          for(Opportunity_Offering__c offNewRec : [select Offering_Solution_Lead_Secondary_New__r.SFDC_User__c,Solution_Specialist_New__r.SFDC_User__c,Solution_Lead_New__r.SFDC_User__c,Solution_Specialist_New__c,Opportunity_TGP__c,Solution_Specialist_New__r.Name, ID,
                                                    Functional_Architect_Mobilization_New__r.Name,Functional_Architect_Mobilization_New__c,
                                                    Solution_Lead_New__r.Name,Solution_Lead_New__c,Offering_Solution_Lead_Secondary_New__r.Name,
                                                    Offering_Solution_Lead_Secondary_New__c from Opportunity_Offering__c where id IN: lstNewOff]){
            
            temp = (Opportunity_Offering__c)trigger.oldMap.get(offNewRec.id);
            if(offNewRec.Solution_Lead_New__c != temp.Solution_Lead_New__c) {                           
                String label = fieldMap.get('Solution_Lead_New__c').getDescribe().getLabel();               
                String keySetNew = label+';'+offNewRec.Solution_Lead_New__c+';'+offNewRec.Opportunity_TGP__c;               
                String keySetOld = label+';'+temp.Solution_Lead_New__c+';'+temp.Opportunity_TGP__c; 
                            
                List<Scheduling__c> schListForUpdate = schedulingRecordMap.get(keySetNew);
                
                List<Scheduling__c> schListForUpdateOld =  schedulingRecordMap.get(keySetOld);
                
                if(schListForUpdate == null) {
                    
                    List<Opportunity_Offering__c> offListToCheck = [select Solution_Lead_New__c from Opportunity_Offering__c where Opportunity_TGP__c = :offNewRec.Opportunity_TGP__c AND Solution_Lead_New__c =: temp.Solution_Lead_New__c];
                    if(offListToCheck.size() == 0 && schListForUpdateOld != null) {
                        deleteList.addAll(schListForUpdateOld);
                    }
                    if(offNewRec.Solution_Lead_New__c != null){
                        Scheduling__c obj = new Scheduling__c(); 
                        obj.BPO_Opportunity_MD__c = offNewRec.Opportunity_TGP__c;
                        //obj.offerings__c = offNewRec.id;                
                        obj.Role_Name__c = label;
                        
                        obj.User_Id__c = offNewRec.Solution_Lead_New__c;
                        obj.User_Master__c = offNewRec.Solution_Lead_New__c;
                        obj.Key_Field__c = obj.Role_Name__c +';'+obj.User_Id__c +';'+obj.BPO_Opportunity_MD__c;
                        obj.User_SFDC_Id__c = offNewRec.Solution_Lead_New__r.SFDC_User__c;
                        obj.First_Date__c = mondayDate2;
                        obj.Current_week__c = 0;
                        obj.Current_week_1__c = 0;
                        obj.Current_week_2__c = 0;
                        obj.Current_week_3__c = 0;
                        obj.Ongoing__c = 0;
                        if(insertOffList.size()>0){
                            
                            if(!schMap.containsKey(obj.Key_Field__c)){
                                
                                
                                schMap.put(obj.Key_Field__c,obj);
                                insertOffList.add(obj);
                            
                            }
                        
                        }
                        else{
                            
                            schMap.put(obj.Key_Field__c,obj);
                            insertOffList.add(obj);
                        }
                    }
                 }
                 else {
                    List<Opportunity_Offering__c> offListToCheck = [select Solution_Lead_New__c from Opportunity_Offering__c where Opportunity_TGP__c = :offNewRec.Opportunity_TGP__c AND Solution_Lead_New__c =: temp.Solution_Lead_New__c];
                    if(offListToCheck.size() == 0 && schListForUpdateOld != null) {
                        deleteList.addAll(schListForUpdateOld);
                    }                   
                 }  
            }
            if(offNewRec.Offering_Solution_Lead_Secondary_New__c != temp.Offering_Solution_Lead_Secondary_New__c) {                         
                String label = fieldMap.get('Offering_Solution_Lead_Secondary_New__c').getDescribe().getLabel();                
                String keySetNew = label+';'+offNewRec.Offering_Solution_Lead_Secondary_New__c+';'+offNewRec.Opportunity_TGP__c;                
                String keySetOld = label+';'+temp.Offering_Solution_Lead_Secondary_New__c+';'+temp.Opportunity_TGP__c;  
                            
                List<Scheduling__c> schListForUpdate = schedulingRecordMap.get(keySetNew);
                
                List<Scheduling__c> schListForUpdateOld =  schedulingRecordMap.get(keySetOld);
                
                if(schListForUpdate == null) {
                    
                    List<Opportunity_Offering__c> offListToCheck = [select Offering_Solution_Lead_Secondary_New__c from Opportunity_Offering__c where Opportunity_TGP__c = :offNewRec.Opportunity_TGP__c AND Offering_Solution_Lead_Secondary_New__c =: temp.Offering_Solution_Lead_Secondary_New__c];
                    if(offListToCheck.size() == 0 && schListForUpdateOld != null) {
                        deleteList.addAll(schListForUpdateOld);
                    }
                    if(offNewRec.Offering_Solution_Lead_Secondary_New__c != null){
                        Scheduling__c obj = new Scheduling__c(); 
                        obj.BPO_Opportunity_MD__c = offNewRec.Opportunity_TGP__c;
                        //obj.offerings__c = offNewRec.id;                
                        obj.Role_Name__c = label;
                        
                        obj.User_Id__c = offNewRec.Offering_Solution_Lead_Secondary_New__c;
                        obj.User_Master__c = offNewRec.Offering_Solution_Lead_Secondary_New__c;
                        obj.Key_Field__c = obj.Role_Name__c+';'+obj.User_Id__c +';'+obj.BPO_Opportunity_MD__c;
                        obj.User_SFDC_Id__c = offNewRec.Offering_Solution_Lead_Secondary_New__r.SFDC_User__c;
                        obj.First_Date__c = mondayDate2;
                        obj.Current_week__c = 0;
                        obj.Current_week_1__c = 0;
                        obj.Current_week_2__c = 0;
                        obj.Current_week_3__c = 0;
                        obj.Ongoing__c = 0;
                        if(insertOffList.size()>0){
                            
                            if(!schMap.containsKey(obj.Key_Field__c)){
                                
                                
                                schMap.put(obj.Key_Field__c,obj);
                                insertOffList.add(obj);
                            
                            }
                        
                        }
                        else{
                            
                            schMap.put(obj.Key_Field__c,obj);
                            insertOffList.add(obj);
                        }
                    }
                 }
                 else {
                    List<Opportunity_Offering__c> offListToCheck = [select Offering_Solution_Lead_Secondary_New__c from Opportunity_Offering__c where Opportunity_TGP__c = :offNewRec.Opportunity_TGP__c AND Offering_Solution_Lead_Secondary_New__c =: temp.Offering_Solution_Lead_Secondary_New__c];
                    if(offListToCheck.size() == 0 && schListForUpdateOld != null) {
                        deleteList.addAll(schListForUpdateOld);
                    }                   
                 }  
            }
            if(offNewRec.Solution_Specialist_New__c != temp.Solution_Specialist_New__c) {                           
                String label = fieldMap.get('Solution_Specialist_New__c').getDescribe().getLabel();             
                String keySetNew = label+';'+offNewRec.Solution_Specialist_New__c+';'+offNewRec.Opportunity_TGP__c;             
                String keySetOld = label+';'+temp.Solution_Specialist_New__c+';'+temp.Opportunity_TGP__c;   
                            
                List<Scheduling__c> schListForUpdate = schedulingRecordMap.get(keySetNew);
                
                List<Scheduling__c> schListForUpdateOld =  schedulingRecordMap.get(keySetOld);
                
                if(schListForUpdate == null) {
                    
                    List<Opportunity_Offering__c> offListToCheck = [select Solution_Specialist_New__c from Opportunity_Offering__c where Opportunity_TGP__c = :offNewRec.Opportunity_TGP__c AND Solution_Specialist_New__c =: temp.Solution_Specialist_New__c];
                    if(offListToCheck.size() == 0 && schListForUpdateOld != null) {
                        deleteList.addAll(schListForUpdateOld);
                    }
                    if(offNewRec.Solution_Specialist_New__c != null){
                        Scheduling__c obj = new Scheduling__c(); 
                        
                        obj.BPO_Opportunity_MD__c = offNewRec.Opportunity_TGP__c;
                        //obj.offerings__c = offNewRec.id;                
                        obj.Role_Name__c = label;
                        
                        obj.User_Id__c = offNewRec.Solution_Specialist_New__c;
                        obj.User_Master__c = offNewRec.Solution_Specialist_New__c;
                        obj.Key_Field__c = obj.Role_Name__c +';'+obj.User_Id__c +';'+obj.BPO_Opportunity_MD__c;
                        obj.User_SFDC_Id__c = offNewRec.Solution_Specialist_New__r.SFDC_User__c;
                        obj.First_Date__c = mondayDate2;
                        obj.Current_week__c = 0;
                        obj.Current_week_1__c = 0;
                        obj.Current_week_2__c = 0;
                        obj.Current_week_3__c = 0;
                        obj.Ongoing__c = 0;
                        if(insertOffList.size()>0){
                            
                            if(!schMap.containsKey(obj.Key_Field__c)){
                                
                                
                                schMap.put(obj.Key_Field__c,obj);
                                insertOffList.add(obj);
                            
                            }
                        
                        }
                        else{
                            
                            schMap.put(obj.Key_Field__c,obj);
                            insertOffList.add(obj);
                        }
                    }
                    System.debug('--------insertOffList to insert ------------------'+insertOffList );
                 }
                 else {
                    List<Opportunity_Offering__c> offListToCheck = [select Solution_Specialist_New__c from Opportunity_Offering__c where Opportunity_TGP__c = :offNewRec.Opportunity_TGP__c AND Solution_Specialist_New__c =: temp.Solution_Specialist_New__c];
                    if(offListToCheck.size() == 0 && schListForUpdateOld != null) {
                        deleteList.addAll(schListForUpdateOld);
                    }                   
                 }  
            }
                                                    
            
          }
          System.debug('--------deleteList to delete ------------------'+deleteList );
          for(Scheduling__c recToDelete : deleteList){
            schdeleteList.add(recToDelete); 
          }
          for(Scheduling__c recToDeletInsert : insertOffList){
            schinsertOffList.add(recToDeletInsert); 
          }
          
          System.debug('--------schdeleteList to delete ------------------'+schdeleteList );
          System.debug('--------schinsertOffList to insert------------------'+schinsertOffList);
          
          //database.delete(schdeleteList);
          delete schdeleteList;
          database.insert(schinsertOffList);
            
    }*/
     /*
    *   @Method : updateSchedulingRec
    *   @ Description : This mehod insert the solution user assignment records and Update BPO Opportunity fields
    */
    /*public static void deleteSchedulingRec(List<Opportunity_Offering__c> lstOldOff) {
        
        List<Scheduling__c> deleteList = new List<Scheduling__c>();
    
        String type_1='Opportunity_Offering__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type_1);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
        set<Id> BPOOpportunityIds = new  set<Id>(); 
        
          for(Opportunity_Offering__c oppOffering : lstOldOff) {
            BPOOpportunityIds.add(oppOffering.Opportunity_TGP__c);
          }
        
        Map<String, List<Scheduling__c>> schedulingRecordMap = new  Map<String, List<Scheduling__c>>();
          for(Scheduling__c schedulingRecord : [select Role_Name__c,User_Master__c, Key_Field__c,User_Id__c 
                                                            FROM Scheduling__c where BPO_Opportunity_MD__c IN:BPOOpportunityIds]) {
             List<Scheduling__c> schedulingRecordList = new List<Scheduling__c>{schedulingRecord};                                  
            schedulingRecordMap.put(schedulingRecord.Key_Field__c, schedulingRecordList);       
          }
        
        for(Opportunity_Offering__c offNewRec : lstOldOff){     
                                                
            if(offNewRec.Solution_Lead_New__c != null) {
                String label = fieldMap.get('Solution_Lead_New__c').getDescribe().getLabel();               
                String keySetOld = label+';'+offNewRec.Solution_Lead_New__c+';'+offNewRec.Opportunity_TGP__c;   
                
                List<Opportunity_Offering__c> offListToCheck = [select Solution_Lead_New__c from Opportunity_Offering__c where Opportunity_TGP__c = :offNewRec.Opportunity_TGP__c AND Solution_Lead_New__c =: offNewRec.Solution_Lead_New__c];
                
                if(offListToCheck.size() == 0){
                    
                    List<Scheduling__c> schListForUpdate = schedulingRecordMap.get(keySetOld);
                    
                    deleteList.addAll(schListForUpdate);
                    
                }
                
            
            }
            if(offNewRec.Offering_Solution_Lead_Secondary_New__c != null) {
                String label = fieldMap.get('Offering_Solution_Lead_Secondary_New__c').getDescribe().getLabel();                
                String keySetOld = label+';'+offNewRec.Offering_Solution_Lead_Secondary_New__c+';'+offNewRec.Opportunity_TGP__c;    
                
                List<Opportunity_Offering__c> offListToCheck = [select Offering_Solution_Lead_Secondary_New__c from Opportunity_Offering__c where Opportunity_TGP__c = :offNewRec.Opportunity_TGP__c AND Offering_Solution_Lead_Secondary_New__c =: offNewRec.Offering_Solution_Lead_Secondary_New__c];
                
                if(offListToCheck.size() == 0){
                    
                    List<Scheduling__c> schListForUpdate = schedulingRecordMap.get(keySetOld);
                    
                    deleteList.addAll(schListForUpdate);
                    
                }
                
            
            }
            if(offNewRec.Solution_Specialist_New__c != null) {
                String label = fieldMap.get('Solution_Specialist_New__c').getDescribe().getLabel();             
                String keySetOld = label+';'+offNewRec.Solution_Specialist_New__c+';'+offNewRec.Opportunity_TGP__c; 
                
                List<Opportunity_Offering__c> offListToCheck = [select Solution_Specialist_New__c from Opportunity_Offering__c where Opportunity_TGP__c = :offNewRec.Opportunity_TGP__c AND Solution_Specialist_New__c =: offNewRec.Solution_Specialist_New__c];
                
                if(offListToCheck.size() == 0){
                    
                    List<Scheduling__c> schListForUpdate = schedulingRecordMap.get(keySetOld);
                    
                    deleteList.addAll(schListForUpdate);
                    
                }
                
            
            }
                                                        
            
        }
        
        System.debug('-------deleteList-----------'+deleteList);
        
        delete deleteList;  
        
    }*/
    
}