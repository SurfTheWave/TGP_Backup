/*
  @Author: Yasin Khan
  @Name: waveEmailRemainder
  @Created Date: 15 Dec 2015
  @Description: Util class is used for alert remainders for wave, wave process and wavetrackings.
  @version: 3.5 
*/

global class EmailRemainders{
     
     public static void dealStatusAlert(List<sObject> sObjectList, Map<id,list<String>> dealTeamMapTo,Map<id,list<String>> dealTeamMapCc){          
           List<String>  mobTeamCcList;                    
            List<Deal__c> dealList = ((List<Deal__c>)sObjectList);  
               system.debug('EmailRemainders waveList: ---'+dealList);
            try{
            
                if(dealList.size()>0){
                    system.debug('dealList ---'+dealList);
                    string [] toaddress;
                    string [] ccaddress;
                    string htmlBody;
                    list<Messaging.SingleEmailMessage> emaillist = new list<Messaging.SingleEmailMessage>();
                    for(Deal__c deal: dealList){               
                      
                     if(dealTeamMapTo.get(deal.Id)!=null || dealTeamMapCc.get(deal.Id)!=null){  
                              Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                           
                           if(dealTeamMapTo.get(deal.Id)!=null){
                                toaddress= dealTeamMapTo.get(deal.Id);
                                system.debug('final toaddress---'+toaddress);
                                email.setToAddresses(toaddress);                       
                            }    
                           
                            system.debug('dealTeamMapCc====='+dealTeamMapCc);
                            
                            if(dealTeamMapCc.get(deal.Id)!=null){
                               mobTeamCcList=dealTeamMapCc.get(deal.Id);
                               system.debug('ccaddress======  '+ccaddress);
                            } 
                            mobTeamCcList.add('mazhar.i.gadhwalla@accenture.com');
                            ccaddress=mobTeamCcList;
                            system.debug('final ccaddress---'+ccaddress);
                            email.setccAddresses(ccaddress);
                            // String orgWideEmailAddressID=UtilEmail.emailid();
                            // email.setOrgWideEmailAddressId(orgWideEmailAddressID);          
                            email.setSenderDisplayName('BPO Mob Workbench');
                            email.setSubject(' ACTION REQUIRED: Update Deal RAG status');
                            
                            htmlBody ='Dear Deal Team Member,<br/><br/>Please update the Deal RAG status on your deal ' +deal.name+'. This is just a reminder note. <br/><br/>Regards<br/> MWB ADMIN';                         
                            
                            email.setHtmlBody(htmlBody);
                            emaillist.add(email);                       
                        }   
                    } 
                  if(emaillist != null)
                      Messaging.sendEmail(emaillist);                         
                }
           }
           Catch(Exception e) {
                String sheetThrowingException = UtilConstants.EMPTY_STRING;
                sheetThrowingException = e.getMessage() + e.getStackTraceString();
                throw (e);
           }          
     }
     
     public static void waveStatusAlert(List<sObject> sObjectList, Map<id,list<String>> dealTeamMapTo,Map<id,list<String>> dealTeamMapCc,String msg,String objectName){          
           List<String>  mobTeamCcList;
           if(objectName == 'wave') {                      
            List<Wave__c> waveList = ((List<Wave__c>)sObjectList);  
               system.debug('EmailRemainders waveList: ---'+waveList);
            try{
            
                if(waveList.size()>0){
                    system.debug('waveList---'+waveList);
                    string [] toaddress;
                    string [] ccaddress;
                    string htmlBody;
                    list<Messaging.SingleEmailMessage> emaillist = new list<Messaging.SingleEmailMessage>();
                    for(Wave__c wave : waveList){               
                      
                     if(dealTeamMapTo.get(wave.Mobilization_Plan__r.Deal__c)!=null || dealTeamMapCc.get(wave.Mobilization_Plan__r.Deal__c)!=null){  
                              Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                           
                           if(dealTeamMapTo.get(wave.Mobilization_Plan__r.Deal__c)!=null){
                                toaddress= dealTeamMapTo.get(wave.Mobilization_Plan__r.Deal__c);
                                system.debug('final toaddress---'+toaddress);
                                email.setToAddresses(toaddress);                       
                            }    
                           
                            system.debug('dealTeamMapCc====='+dealTeamMapCc);
                            
                            if(dealTeamMapCc.get(wave.Mobilization_Plan__r.Deal__c)!=null){
                               mobTeamCcList=dealTeamMapCc.get(wave.Mobilization_Plan__r.Deal__c);
                               system.debug('ccaddress======  '+ccaddress);
                            } 
                            mobTeamCcList.add('mazhar.i.gadhwalla@accenture.com');
                            ccaddress=mobTeamCcList;
                            system.debug('final ccaddress---'+ccaddress);
                            email.setccAddresses(ccaddress);
                            // String orgWideEmailAddressID=UtilEmail.emailid();
                           // email.setOrgWideEmailAddressId(orgWideEmailAddressID);           
                            email.setSenderDisplayName('BPO Mob Workbench');
                                                                                           
                            if(msg.equals('plannedgolivedate')){
                               String str = string.valueOfGmt(wave.Planned_Go_Live_Date__c);
                               string dateOutput = str.substring(5,7) +'/'+str.substring(8,10)+'/'+str.substring(0,4); //str.substring(0,10);
                               
                               email.setSubject(' Gentle Reminder: Upcoming Wave Go Live Date');
                            
                               htmlBody ='Dear Deal Team Member,<br/><br/>The planned go live date for your wave '+wave.Name+' is '+dateOutput+' for the Deal '+wave.Mobilization_Plan__r.Deal__r.name+'. This is just a reminder note.<br/><br/>Regards<br/> MWB ADMIN';
                            }else if(msg.equals('waveragstatus')){
                               
                               email.setSubject(' ACTION REQUIRED! Update Wave RAG Status');                                                          
                               htmlBody ='Dear Deal Team Member,<br/><br/>Please update the Wave RAG status on the wave '+wave.Name+' for your deal '+wave.Mobilization_Plan__r.Deal__r.name+'. This is just a reminder note.<br/><br/>Regards<br/> MWB ADMIN';  
                            }else if(msg.equals('nowaveprocess')){
                                
                               email.setSubject(' ACTION REQUIRED! Create Wave Process');
                               htmlBody ='Dear Deal Team Member,<br/><br/>Please add Wave Process on the wave '+wave.Name+' for your deal '+wave.Mobilization_Plan__r.Deal__r.name+'.<br/><br/>Regards<br/> MWB ADMIN';  
                            } 
                          
                            email.setHtmlBody(htmlBody);
                            emaillist.add(email);                       
                        }   
                    } 
                  if(emaillist != null)
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
  
     public static void ktSendAlert(List<sObject> sObjectList, Map<id,list<String>> dealTeamMapTo,Map<id,list<String>> dealTeamMapCc,String msg,String objectName){                                  
            List<KT_Trac__c > ktList = ((List<KT_Trac__c >)sObjectList);  
            List<String>  mobTeamCcList;  
            
            try{           
                if(ktList.size()>0){
                    system.debug('ktList---'+ktList);
                    string [] toaddress;
                    string [] ccaddress;
                    string htmlBody;
                    list<Messaging.SingleEmailMessage> emaillist = new list<Messaging.SingleEmailMessage>();
                    for(KT_Trac__c kt: ktList){               
                      
                     if(dealTeamMapTo.get(kt.Wave__r.Mobilization_Plan__r.Deal__c)!=null || dealTeamMapCc.get(kt.Wave__r.Mobilization_Plan__r.Deal__c)!=null){  
                              Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                           
                           if(dealTeamMapTo.get(kt.Wave__r.Mobilization_Plan__r.Deal__c)!=null){
                                toaddress= dealTeamMapTo.get(kt.Wave__r.Mobilization_Plan__r.Deal__c);
                                system.debug('final toaddress---'+toaddress);
                                email.setToAddresses(toaddress);                       
                            }    
                           
                            system.debug('dealTeamMapCc====='+dealTeamMapCc);
                            
                            if(dealTeamMapCc.get(kt.Wave__r.Mobilization_Plan__r.Deal__c)!=null){
                               mobTeamCcList=dealTeamMapCc.get(kt.Wave__r.Mobilization_Plan__r.Deal__c);
                               system.debug('ccaddress======  '+ccaddress);
                            } 
                            mobTeamCcList.add('mazhar.i.gadhwalla@accenture.com');
                            ccaddress=mobTeamCcList;
                            system.debug('final ccaddress---'+ccaddress);
                            email.setccAddresses(ccaddress);
                            // String orgWideEmailAddressID=UtilEmail.emailid();
                            //email.setOrgWideEmailAddressId(orgWideEmailAddressID);          
                            email.setSenderDisplayName('BPO Mob Workbench');
                            //email.setSubject(' Gentle Reminder from Salesforce');
                              email.setSubject(' ACTION REQUIRED: Update KT Tracker');
                            if(msg.equals('kttracking')){
                               String str = string.valueOfGmt(kt.Planned_End_Date__c );
                               string dateOutput = str.substring(5,7) +'/'+str.substring(8,10)+'/'+str.substring(0,4); //str.substring(0,10);
                                htmlBody ='Dear Deal Team Member,<br/><br/>The planned end date for your KT activity '+ kt.Name + ' is '+dateOutput+' for the wave '+kt.Wave__r.Name+' / Deal '+kt.Wave__r.Mobilization_Plan__r.Deal__r.name+'. Please make the required updates for this activity in Mobilization Workbench to ensure compliance.<br/><br/>Regards<br/> MWB ADMIN';
                            }
                          
                            email.setHtmlBody(htmlBody);
                            emaillist.add(email);                       
                        }   
                    } 
                  if(emaillist != null)
                     Messaging.sendEmail(emaillist); 
                        
                }
           }
           Catch(Exception e) {
                String sheetThrowingException = UtilConstants.EMPTY_STRING;
                sheetThrowingException = e.getMessage() + e.getStackTraceString();
                throw (e);
           }        
     }
           
     public static void recruitSendAlert(List<sObject> sObjectList, Map<id,list<String>> dealTeamMapTo,Map<id,list<String>> dealTeamMapCc,String msg,String objectName){ 
             List<Recruit_Tracker__c > recruitList = ((List<Recruit_Tracker__c >)sObjectList);   
             List<String>  mobTeamCcList;
             try{           
                if(recruitList.size()>0){
                    system.debug('recruitList ---'+recruitList);
                    string [] toaddress;
                    string [] ccaddress;                   
                    string htmlBody;
                    list<Messaging.SingleEmailMessage> emaillist = new list<Messaging.SingleEmailMessage>();
                    for(Recruit_Tracker__c recruit: recruitList){               
                      
                     if(dealTeamMapTo.get(recruit.Wave__r.Mobilization_Plan__r.Deal__c)!=null || dealTeamMapCc.get(recruit.Wave__r.Mobilization_Plan__r.Deal__c)!=null){  
                              Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                           
                           if(dealTeamMapTo.get(recruit.Wave__r.Mobilization_Plan__r.Deal__c)!=null){
                                toaddress= dealTeamMapTo.get(recruit.Wave__r.Mobilization_Plan__r.Deal__c);
                                system.debug('final toaddress---'+toaddress);
                                email.setToAddresses(toaddress);                       
                            }    
                           
                            system.debug('dealTeamMapCc====='+dealTeamMapCc);
                            
                            if(dealTeamMapCc.get(recruit.Wave__r.Mobilization_Plan__r.Deal__c)!=null){
                               mobTeamCcList=dealTeamMapCc.get(recruit.Wave__r.Mobilization_Plan__r.Deal__c);
                               system.debug('ccaddress======  '+ccaddress);
                            } 
                            mobTeamCcList.add('mazhar.i.gadhwalla@accenture.com');
                            ccaddress=mobTeamCcList;
                            system.debug('final ccaddress---'+ccaddress);
                            email.setccAddresses(ccaddress);
                            // String orgWideEmailAddressID=UtilEmail.emailid();
                            // email.setOrgWideEmailAddressId(orgWideEmailAddressID);          
                            email.setSenderDisplayName('BPO Mob Workbench');
                            // email.setSubject(' Gentle Reminder from Salesforce');
                            email.setSubject(' ACTION REQUIRED: Update Recruitment Tracker');
                            String str = string.valueOfGmt(recruit.Planned_End_Date__c);
                            string dateOutput = str.substring(5,7) +'/'+str.substring(8,10)+'/'+str.substring(0,4); //str.substring(0,10);
                            htmlBody ='Dear Deal Team Member,<br/><br/>The planned end date for your recruitment activity '+ recruit.Name +' is '+dateOutput+' for the wave '+recruit.Wave__r.Name+' / Deal '+recruit.Wave__r.Mobilization_Plan__r.Deal__r.name+'. Please make the required updates for this activity in Mobilization Workbench to ensure compliance.<br/><br/>Regards<br/> MWB ADMIN';
                            
                            email.setHtmlBody(htmlBody);
                            emaillist.add(email);                       
                        }   
                    } 
                  if(emaillist != null)
                     Messaging.sendEmail(emaillist); 
                        
                }
           }
           Catch(Exception e) {
                String sheetThrowingException = UtilConstants.EMPTY_STRING;
                sheetThrowingException = e.getMessage() + e.getStackTraceString();
                throw (e);
           }        
     } 
               
     public static void techweSendAlert(List<sObject> sObjectList, Map<id,list<String>> dealTeamMapTo,Map<id,list<String>> dealTeamMapCc,String msg,String objectName){ 
             List<Tech_WE_Tracker__c > techweList = ((List<Tech_WE_Tracker__c >)sObjectList);   
             List<String>  mobTeamCcList;
             try{           
                if(techweList.size()>0){
                    system.debug('recruitList ---'+techweList);
                    string [] toaddress;
                    string [] ccaddress;
                    string htmlBody;
                    list<Messaging.SingleEmailMessage> emaillist = new list<Messaging.SingleEmailMessage>();
                    for(Tech_WE_Tracker__c techwe: techweList){               
                      
                     if(dealTeamMapTo.get(techwe.Wave__r.Mobilization_Plan__r.Deal__c)!=null || dealTeamMapCc.get(techwe.Wave__r.Mobilization_Plan__r.Deal__c)!=null){  
                              Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                           
                           if(dealTeamMapTo.get(techwe.Wave__r.Mobilization_Plan__r.Deal__c)!=null){
                                toaddress= dealTeamMapTo.get(techwe.Wave__r.Mobilization_Plan__r.Deal__c);
                                system.debug('final toaddress---'+toaddress);
                                email.setToAddresses(toaddress);                       
                            }    
                           
                            system.debug('dealTeamMapCc====='+dealTeamMapCc);
                            
                            if(dealTeamMapCc.get(techwe.Wave__r.Mobilization_Plan__r.Deal__c)!=null){
                               mobTeamCcList=dealTeamMapCc.get(techwe.Wave__r.Mobilization_Plan__r.Deal__c);
                               system.debug('ccaddress======  '+ccaddress);
                            } 
                            mobTeamCcList.add('mazhar.i.gadhwalla@accenture.com');
                            ccaddress=mobTeamCcList;
                            system.debug('final ccaddress---'+ccaddress);
                            email.setccAddresses(ccaddress);
                            //String orgWideEmailAddressID=UtilEmail.emailid();
                            //email.setOrgWideEmailAddressId(orgWideEmailAddressID);          
                            email.setSenderDisplayName('BPO Mob Workbench');
                           // email.setSubject(' Gentle Reminder from Salesforce');
                            email.setSubject(' ACTION REQUIRED: Update Technology & Work Enablement Tracker');
                            String str = string.valueOfGmt(techwe.Planned_End_Date__c);
                            string dateOutput = str.substring(5,7) +'/'+str.substring(8,10)+'/'+str.substring(0,4); //str.substring(0,10);
                            htmlBody ='Dear Deal Team Member,<br/><br/>The planned end date for your Tech & WE activity '+ techwe.Name +' is '+dateOutput+' for the wave '+techwe.Wave__r.Name+' / Deal '+techwe.Wave__r.Mobilization_Plan__r.Deal__r.name+'. Please make the required updates for this activity in Mobilization Workbench to ensure compliance.<br/><br/>Regards<br/> MWB ADMIN';
                            
                            email.setHtmlBody(htmlBody);
                            emaillist.add(email);                       
                        }   
                    } 
                  if(emaillist != null)
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