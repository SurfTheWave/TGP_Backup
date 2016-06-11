/*
@Author : Apoorva Sharma
@name : OperationsOnApprovalDocumentController
@CreateDate : 3/14/2015 7:27 AM
@Description : 
@Version : 
*/
public without sharing class OperationsOnApprovalDocumentController {

/*
@Author : Apoorva Sharma
@name : OperationsOnApprovalDocumentController
@CreateDate : 3/14/2015 7:27 AM
@Description : 
@Version : 
*/
public static void populateLinkToSharePoint(List < approval_documents__c > approvaldocument) {
    
    String sheetThrowingException = UtilConstants.EMPTY_STRING;
    try{
        Set < Id > opportunitydocument = new Set < id > ();
        for (approval_documents__c a: approvaldocument) {
            opportunitydocument.add(a.approval_document__c);
        }
        List < Opportunity_Documents__c > opportunityDocumentRecord = [Select id, document__c, Document_Link__c, opportunity__c, 
            modified_by__c from Opportunity_Documents__c where Id IN: opportunitydocument Limit 5000];
        if (!opportunityDocumentRecord.isEmpty()) {
            for (approval_documents__c approvalRec: approvaldocument) {
                //    system.debug('approvaldocumentapprovaldocumentapprovaldocumentapprovaldocument'+approvalRec);
                //system.debug('approvaldocumentapprovaldocumentapprovaldocumentapprovaldocument'+approvalRec.approval_document__c);
                for (Opportunity_Documents__c oppdoc: opportunityDocumentRecord) {
                    if (approvalRec.approval_document__c.Equals(oppdoc.Id)) {
                        if (oppdoc.Document_Link__c != null) {
                            if (oppdoc.modified_by__c != null && oppdoc.document__c != null) {
                                //system.debug('approvalDocumentName'+oppdoc.document__c);
                                String link = oppdoc.Document_Link__c;
                                //link = link.ReplaceAll('<.*?>', '');
                                //system.debug('linklinklink'+link);
                                //String link=oppdoc.Document_Link__c;
                                approvalRec.Document_Sharepoint_Link_DEV__c = oppdoc.Document_Link__c;
                                // approvalRec.Document_Sharepoint_Link_DEV__c=UtilConstants.START_HREF+link+UtilConstants.INBET_HREF+oppdoc.document__c+UtilConstants.END_HREF;
                            } else {
                                String link = oppdoc.Document_Link__c;
                                link = link.ReplaceAll(UtilConstants.Splchr, UtilConstants.EMPTY_STRING);
                                //system.debug('linklinklink'+link);
                                //String link=oppdoc.Document_Link__c;
                                // approvalRec.Document_Sharepoint_Link_DEV__c=oppdoc.Document_Link__c;
                                approvalRec.Document_Sharepoint_Link_DEV__c = UtilConstants.START_HREF + link + UtilConstants.INBET_HREF + oppdoc.document__c + UtilConstants.END_HREF;
                            }
                        }
                    }
                }
            }
        }
        } catch(DmlException e) {
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);﻿
          }        
    }
/*
@Author : Apoorva Sharma
@name : OperationsOnApprovalDocumentController
@CreateDate : 3/14/2015 7:27 AM
@Description : * Throws an error when approval document with
               * duplicate request and opportunity document is 
               * inserted
@Version : 
*/
    public static void duplicateApprovalDocuments(List < approval_documents__c > approvaldocument) {
        Set<ID> oppdoc=new Set<ID>();
        String sheetThrowingException = UtilConstants.EMPTY_STRING;
        try {
              
            for(approval_documents__c appdoc:approvaldocument){
                oppdoc.add(appdoc.approval_document__c);
            }
            List<opportunity_documents__c>olist=[SELECT Id, opportunity__c from opportunity_documents__c where id IN :oppdoc Limit 5000];
            Set<ID> Oppids=new set<id>();
            for(opportunity_documents__c o: olist){
                Oppids.add(o.opportunity__c);
            }
            List <approval_documents__c > existingapprovaldocument = [Select id, approval_document__c,
                Opportunity_Approval_Request__c from approval_documents__c where approval_document__r.opportunity__c in:Oppids  Limit 5000];
                    for (approval_documents__c existingDoc: existingapprovaldocument) {
                        for (approval_documents__c newDocument: approvaldocument) {
                        if ((newDocument.approval_document__c.Equals(existingDoc.approval_document__c)) &&
                             (newDocument.Opportunity_Approval_Request__c.Equals(existingDoc.Opportunity_Approval_Request__c))){
                                newDocument.addError(UtilConstants.Msg);
                                 
                                 //throw new myException(UtilConstants.Msg);
                    }
                }
            }
        } catch(DmlException e) {
            sheetThrowingException = e.getMessage() + e.getStackTraceString();
            throw (e);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
            //ApexPages.addMessage(myMsg);﻿
          }
    }
}