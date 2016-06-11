/**
  * @author        
  * @date          30/10/2013
  * @description   UTIL Class for send email functionality for Governance Lead.
  */
public without sharing class UTIL_SendEmailForGovernanceLead{
     /**
      * @description       Method for defining User object record to be created for use in Test Class. 
      * @param             List<SD_Governance_data__c> 
      * @return            void 
      * @throws            NA
      */
    public void sendEmailTOGovernanceLead(List<SD_Governance_data__c> listGovData){        
        List<String> sdLeads = new List<String>();
        List<String> oppIds = new List<String>();
        List<datetime> modifiedDate = new List<Datetime>();
        //listGovData=[Select  id, name, SAP_OM_ID__c,Offerings_Scope_SWB__c,Opportunity__r.id,Opportunity__r.SAP_OM_ID__c,SD_Gov_Lead_Coach__c,opportunity__r.Account.name,LastModifiedDate,Opportunity_Solution_Lead__c,Opportunity__r.name from SD_Governance_data__c];
        Map<String, String> sdLeadsMap ;
        String sapomId;
        String scope; 
        try{
            for(SD_Governance_data__c gs:listGovData){
                if(gs.SD_Gov_Lead_Coach__c!=null){
                    sdLeads.add(gs.SD_Gov_Lead_Coach__c);
                    oppIds.add(gs.Opportunity__r.name);
                    modifiedDate.add(gs.LastModifiedDate); 
                }
                if(gs.Opportunity__r.SAP_OM_ID__c == null){
                       sapomId = UtilConstants.EMPTY_STRING; 
                    }else{
                        sapomId = gs.Opportunity__r.SAP_OM_ID__c;
                    }
                    
                    if(gs.Offerings_Scope_SWB__c == null){
                        scope = UtilConstants.EMPTY_STRING;
                    }else{
                        scope = gs.Offerings_Scope_SWB__c;                                                       
                    }                     
            }
            List<String> users = new List<String>();
            OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1]; 
            //System.debug('----------------------------------->'+owa.address+owa.id);
            List<Messaging.SingleEmailMessage> emailMsgList = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();       
            sdLeadsMap = new Map<String, String>();            
            for(User_master__c itrObj:[SELECT Name,email__c FROM User_master__c where name in:sdLeads Limit 5000]){
                sdLeadsMap.put(itrObj.Name,itrObj.email__c);   
            }
            mail.setOrgWideEmailAddressId(owa.id);            
            for(SD_Governance_Data__c listOpps:listGovData){
                if(listOpps.SD_Gov_Lead_Coach__c!=null){
                
                    //System.debug('-------------map'+sdLeadsMap);
                    //System.debug('-----------------list'+listOpps.SD_Gov_Lead_Coach__c);
                    String emailAddr=sdLeadsMap.get(listOpps.SD_Gov_Lead_Coach__c);
                    //System.debug('emailAddr@@'+emailAddr);              
                    String[] toAddressArr = new String[] {emailAddr};
                    //System.debug('toAddressArr@@'+toAddressArr);
                    
                    mail.setToAddresses(toAddressArr); 
                    mail.setSubject(UtilConstants.UPD_GOVERNANCE_TAB +listOpps.Opportunity__r.name+UtilConstants.FULL_STOP);
                    String part1 = UtilConstants.STR0 + UtilConstants.UPD_GOVERNANCE_TAB_NEW +listOpps.LastModifiedDate;
                    String part2 = UtilConstants.SAP_OM_ID +listOpps.Opportunity__r.SAP_OM_ID__c+ UtilConstants.TAGS;
                    String part3 = UtilConstants.OPP_NAME +listOpps.Opportunity__r.name+ UtilConstants.CLIENT +listOpps.opportunity__r.Account.name+ UtilConstants.TAGS;
                    String part4 = UtilConstants.OPP_SOLUTION_LEAD +listOpps.Opportunity_Solution_Lead__c+ UtilConstants.SCOPE_TAG +listOpps.Offerings_Scope_SWB__c+ UtilConstants.TABLE_TAG;            
                    String part5 = UtilConstants.FONT_STYLE +UtilConstants.START_HREF+URL.getSalesforceBaseUrl().toExternalForm()+UtilConstants.SLASH+listOpps.Opportunity__r.id+utilconstants.INBET_HREF
                     +UtilConstants.LOGIN_BPO_SOLUTION_WRKBNCH + UtilConstants.SYS_MSG ;
                    
                    mail.setHtmlBody(part1+part2+part3+part4+part5); 
                    if(!Test.isRunningtest()){
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                    }             
                }
            }
        }catch(Exception e){
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);
            //System.debug('exception in send mail-->>'+ex.getMessage());
        }
    }        
}