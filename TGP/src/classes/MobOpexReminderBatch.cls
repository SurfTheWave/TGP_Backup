/*
  @Author: Madhu
  @Name: MobOpexReminderBatch
  @Created Date: 19 Nov 2015
  @Description:  users must be alerted days before the OPEX planned dates to ensure that these items are updated so it won't shows as overdue in MWB..
  @version: 1.0 
*/
global class MobOpexReminderBatch implements Database.Batchable<sObject>,Database.Stateful{
    global String query;
    global String objectName;

    public MobOpexReminderBatch (String opexQuery,String objName){
     //system.debug('dfdsfdsf');
        query=opexQuery;
        objectName=objName; 
       
    }
     global Database.QueryLocator start(Database.BatchableContext bc){
            Date sevenDaysBefore;
         
            if(('sevendays').equals(query)){
                sevenDaysBefore= Date.today().addDays(+7);
                query='SELECT Id, name,Planned_Date__c,Checklist_Status__c,wave__r.name,Wave__r.Mobilization_Plan__r.Deal__r.name,wave__r.Active__c FROM OPEX_Tracker__c where Active__c=true and IsTrackingOn__c=true and Checklist_Status__c!=\'Submitted\' and Mobilization_Plan__r.Active__c=true and  wave__r.Active__c=true and Planned_Date__c=:sevenDaysBefore'; 
            }
            else if(('oneday').equals(query)){
                sevenDaysBefore= Date.today().addDays(+1);
                query='SELECT Id, name,Planned_Date__c,Checklist_Status__c,wave__r.name,Wave__r.Mobilization_Plan__r.Deal__r.name FROM OPEX_Tracker__c where Active__c=true and IsTrackingOn__c=true and Checklist_Status__c!=\'Submitted\' and Mobilization_Plan__r.Active__c=true and  wave__r.Active__c=true and Planned_Date__c=:sevenDaysBefore';
                
            }else if(('afteroneday').equals(query)){
                sevenDaysBefore= Date.today().addDays(-1);
                query='SELECT Id, name,Planned_Date__c,Checklist_Status__c,wave__r.name,Wave__r.Mobilization_Plan__r.Deal__r.name FROM OPEX_Tracker__c where Active__c=true and IsTrackingOn__c=true and Checklist_Status__c!=\'Submitted\' and Mobilization_Plan__r.Active__c=true and  wave__r.Active__c=true and Planned_Date__c=:sevenDaysBefore';
                
            }
            
    // system.debug('query locator---'+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc,List<sObject> sObjectList){
     
        
        if(objectName.equals('OPEX_Tracker__c')||objectName.equals('OPEX_Tracker__c1')||objectName.equals('OPEX_Tracker__c2')){
        List<OPEX_Tracker__c> OpexRecordList = ((list<OPEX_Tracker__c>)sObjectList);
            Set<id> dealIdSet=new set<id>();
            List<OPEX_Tracker__c> opexList=new List<OPEX_Tracker__c>();
            for(OPEX_Tracker__c opex :OpexRecordList){
                opexList.add(opex);
                
                dealIdSet.add(opex.Wave__r.Mobilization_Plan__r.Deal__c);
              //  system.debug('dealIdSet---'+dealIdSet);
            }
            system.debug('opexList:'+opexList);
            //This map is used to map the each deal with team members
            Map<id,list<String>> dealTeamMapTo=new Map<id,list<String>> ();
            List<String> mobTeamList;
            
             Map<id,list<String>> dealTeamMapCc=new Map<id,list<String>> ();
             List<String>  mobTeamCcList;
             
            for(Mobilization_Team__c teamMember : [SELECT Name,Deal__c,Primary_Lead__r.email__c,Secondary_Lead_1__r.email__c,Secondary_Lead_2__r.email__c,Role__c from Mobilization_Team__c where Deal__c IN : dealIdSet limit 5000]) {
            system.debug('!.equalsIgnoreCase(teamMember.Role__c)==== '+teamMember.Role__c);
            if(teamMember.Role__c!=null && (teamMember.Role__c=='Deal PMO')){
                if(dealTeamMapTo.containsKey(teamMember.Deal__c)){                           
                     mobTeamList = dealTeamMapTo.get(teamMember.Deal__c);
                }
                else {
                   mobTeamList = new List<String>();
                }
                if(teamMember.Primary_Lead__r.email__c!=null){
                    mobTeamList.add(teamMember.Primary_Lead__r.email__c);
                }
                if(teamMember.Secondary_Lead_1__r.email__c!=null){
                    mobTeamList.add(teamMember.Secondary_Lead_1__r.email__c);
                }
                if(teamMember.Secondary_Lead_2__r.email__c!=null){
                    mobTeamList.add(teamMember.Secondary_Lead_2__r.email__c);
                }
                if ( mobTeamList != null && !mobTeamList.isEmpty() ) {
                dealTeamMapTo.put(teamMember.Deal__c,mobTeamList);
                }
               // system.debug('dealTeamMapTo  ----'+dealTeamMapTo);
            }
            else if(teamMember.Role__c!=null && ((teamMember.Role__c=='Governance Lead')||(teamMember.Role__c=='Global Transition Lead'))){
                if(dealTeamMapCc.containsKey(teamMember.Deal__c)){                           
                     mobTeamCcList = dealTeamMapCc.get(teamMember.Deal__c);
                }
                else {
                   mobTeamCcList = new List<String>();
                }
                if(teamMember.Primary_Lead__r.email__c!=null){
                    mobTeamCcList.add(teamMember.Primary_Lead__r.email__c);
                }
                if(teamMember.Secondary_Lead_1__r.email__c!=null){
                    mobTeamCcList.add(teamMember.Secondary_Lead_1__r.email__c);
                }
                if(teamMember.Secondary_Lead_2__r.email__c!=null){
                    mobTeamCcList.add(teamMember.Secondary_Lead_2__r.email__c);
                }
                if ( mobTeamCcList != null && !mobTeamCcList.isEmpty() ) {
                dealTeamMapCc.put(teamMember.Deal__c,mobTeamCcList);
                }
               // system.debug('dealTeamMapCc  ----'+dealTeamMapCc);  
            }
            }
            try{
         //  system.debug('sratList---'+sratList);
                if(opexList.size()>0){
                    
                    string [] toaddress;
                    string [] ccaddress;
                    string htmlBody;
                    list<Messaging.SingleEmailMessage> emaillist = new list<Messaging.SingleEmailMessage>();
                    for(OPEX_Tracker__c opex : opexList){               
                        if(dealTeamMapTo.get(opex.Wave__r.Mobilization_Plan__r.Deal__c)!=null){
                            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                            toaddress=dealTeamMapTo.get(opex.Wave__r.Mobilization_Plan__r.Deal__c);
                            system.debug('toaddress---'+toaddress);
                            email.setToAddresses(toaddress);
                            system.debug('dealTeamMapCc====='+dealTeamMapCc);
                         //   ccaddress=new String[]{'mazhar.i.gadhwalla@accenture.com'};
                            if(dealTeamMapCc.get(opex.Wave__r.Mobilization_Plan__r.Deal__c)!=null){
                               mobTeamCcList=dealTeamMapCc.get(opex.Wave__r.Mobilization_Plan__r.Deal__c);
                               system.debug('ccaddress======  '+ccaddress);
                            } 
                            mobTeamCcList.add('mazhar.i.gadhwalla@accenture.com');
                           // ccaddress=new String[]{'mazhar.i.gadhwalla@accenture.com'};
                           ccaddress=mobTeamCcList;
                            email.setccAddresses(ccaddress);
                        //    String orgWideEmailAddressID=UtilEmail.emailid();
                        //    email.setOrgWideEmailAddressId(orgWideEmailAddressID);  
                            email.setSenderDisplayName('BPO Mob Workbench');                            
                            email.setSubject('ACTION REQUIRED!  Complete assessment for OPEX activity '+opex.Name);
                            
                            string str = string.valueOfGmt(opex.Planned_Date__c);
                            string dateOutput = str.substring(5,7) +'/'+str.substring(8,10)+'/'+str.substring(0,4); //str.substring(0,10);
                            
                            if(objectName.equals('OPEX_Tracker__c')||objectName.equals('OPEX_Tracker__c1')){
                            htmlBody ='Dear Deal Team Member<br/><br/>The planned date of assessment for your OPEX activity '+opex.Name+' is '+dateOutput+' for the Wave '+opex.Wave__r.Name+'/ Deal '+opex.Wave__r.Mobilization_Plan__r.Deal__r.name+'. Please ensure the assessment is completed by the due date to ensure compliance. <br/><br/>Regards<br/> MWB ADMIN';
                            }
                            else{
                                htmlBody ='Dear Deal Team Member<br/><br/>The planned date of assessment for your OPEX activity '+opex.Name+' was '+dateOutput+' for the Wave '+opex.Wave__r.Name+'/ Deal '+opex.Wave__r.Mobilization_Plan__r.Deal__r.name+'.Please complete the assessment at the earliest to ensure compliance. <br/><br/>Regards<br/> MWB ADMIN';
                                
                            }
                            email.setHtmlBody(htmlBody);
                            emaillist.add(email);                       
                        }   
                    } 
                Messaging.sendEmail(emaillist); 
                    
                }
            }
            Catch(Exception e) {
                String sheetThrowingException = UtilConstants.EMPTY_STRING;
                sheetThrowingException = e.getMessage() + e.getStackTraceString();
                throw (e);
            }
        } 
    }
     public void finish(Database.BatchableContext bc) {
         
        if(objectName.equals('OPEX_Tracker__c')){
            date mydate= Date.today();
            Date oneDayBefore= mydate.addDays(-1);
            String query='oneday';
            String objName='OPEX_Tracker__c1';
            system.debug('query:'+query);
            MobOpexReminderBatch  reminderBatch = new MobOpexReminderBatch(query,objName);
            ID batchprocessid = Database.executeBatch(reminderBatch,200);      
        }
        if(objectName.equals('OPEX_Tracker__c1')){
            date mydate= Date.today();
            Date oneDayAfter= mydate.addDays(+1);
            String query='afteroneday';
            String objName='OPEX_Tracker__c2';
            system.debug('query:'+query);
            MobOpexReminderBatch  reminderBatch = new MobOpexReminderBatch(query,objName);
            ID batchprocessid = Database.executeBatch(reminderBatch,200);      
        }
       
    }
}