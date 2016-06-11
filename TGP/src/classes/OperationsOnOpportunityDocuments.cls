/*
@Author : 
@name : OperationsOnOpportunityDocuments
@CreateDate : 3/10/2015 4:38 AM
@Description : 
@Version : 
*/
public without sharing class OperationsOnOpportunityDocuments {

/*
@Author : 
@name : OperationsOnOpportunityDocuments
@CreateDate : 3/10/2015 4:38 AM
@Description : 
@Version : 
*/
    public static void insertDocument(List < opportunity_documents__c > documentlist) {
        try{
        List < opportunity_documents__c > newdoc = new List < opportunity_documents__c > ();
        Set < Id > opportunitydocument = new Set < id > ();
        for (opportunity_documents__c a: documentlist) {
            opportunitydocument.add(a.id);
        }
      List < opportunity_documents__c > oppdoc = [SELECT Id, opportunity__c, opportunity__r.Accountid, Client__c, document__c,
        link__c, modified_by__c, Document_Link__c FROM opportunity_documents__c where id IN: opportunitydocument Limit 5000];
        for (opportunity_documents__c opp: oppdoc) {
            
            opp.Client__c = opp.opportunity__r.Accountid;
            newdoc.add(opp);
        }
        update(newdoc);
        }
        Catch(DMLException e) {
           String sheetThrowingException = UtilConstants.EMPTY_STRING;
           sheetThrowingException = e.getMessage() + e.getStackTraceString();
           throw (e);
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
           //ApexPages.addMessage(myMsg);﻿
        }
    }
/*
@Author : 
@name : OperationsOnOpportunityDocuments
@CreateDate : 3/10/2015 4:38 AM
@Description : 
@Version : 
*/
    public static void validatedeleteforOpportunityDocument(List < opportunity_documents__c > documentlist) {
        try {
            list<string> profileNames = new list<string>{Label.Solution_Operations_Profile_Name,UtilConstants.SYSTEM_ADMIN};
                map<id,profile> userprofiles = new map<id,profile>();
                userprofiles = UtilConstantsforSWB.queryProfiles(profileNames);
            //List<opportunity_documents__c> opportunityDocumentslist=[Select id,IsUserAddedDocument__c from opportunity_documents__c where id IN :docids];
            for (opportunity_documents__c oppdoc: documentlist) {
                if (oppdoc.IsUserAddedDocument__c == false &&(!userprofiles.containsKey(userinfo.getProfileid()))) {
                    oppdoc.addError(UtilConstants.ERROR_MSG_OPP_DEL);
                }
            }
        } Catch(DMLException e) {
           String sheetThrowingException = UtilConstants.EMPTY_STRING;
           sheetThrowingException = e.getMessage() + e.getStackTraceString();
           throw (e);
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
           //ApexPages.addMessage(myMsg);﻿
           //system.debug('E==='+e);
        }
    }
}