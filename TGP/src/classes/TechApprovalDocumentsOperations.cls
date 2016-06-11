/**
   @Author :Apoorva Sharma
   @name   : TechApprovalDocumentsOperations 
   @CreateDate : 26 November 2015 
   @Description : This class is used for perform operations on Tech Approval Documents.
   @Version : 1.0 
  */
public with sharing class TechApprovalDocumentsOperations {
	
    /**
     * @description       populates the sharepoint link from opportunity document (Rich text area value)
     * @param             List <Tech_Approval_Documents__c> approvaldocument
     * @return            Void
     * @throws            DML Exception
     */  
    public static void populateLinkToSharePoint(List <Tech_Approval_Documents__c> approvaldocument) {
    
    String sheetThrowingException = UtilConstants.EMPTY_STRING;
    try{
        Set < Id > opportunitydocument = new Set < id > ();
        for (Tech_Approval_Documents__c a: approvaldocument) {
            opportunitydocument.add(a.Approval_Documents__c);
        }
        List < Opportunity_Documents__c > opportunityDocumentRecord = [Select id, document__c, Document_Link__c, opportunity__c, 
            modified_by__c from Opportunity_Documents__c where Id IN: opportunitydocument Limit 5000];
        if (!opportunityDocumentRecord.isEmpty()) {
            for (Tech_Approval_Documents__c approvalRec: approvaldocument) {
                for (Opportunity_Documents__c oppdoc: opportunityDocumentRecord) {
                    if (approvalRec.Approval_Documents__c.Equals(oppdoc.Id)) {
                        if (oppdoc.Document_Link__c != null) {
                            if (oppdoc.modified_by__c != null && oppdoc.document__c != null) {
                                //system.debug('approvalDocumentName'+oppdoc.document__c);
                                String link = oppdoc.Document_Link__c;
                                //link = link.ReplaceAll('<.*?>', '');
                                system.debug('linklinklink'+link);
                                //String link=oppdoc.Document_Link__c;
                                approvalRec.Document_Sharepoint_Link_DEV__c = oppdoc.Document_Link__c;
                                // approvalRec.Document_Sharepoint_Link_DEV__c=UtilConstants.START_HREF+link+UtilConstants.INBET_HREF+oppdoc.document__c+UtilConstants.END_HREF;
                            } else {
                                String link = oppdoc.Document_Link__c;
                                link = link.ReplaceAll(UtilConstants.Splchr, UtilConstants.EMPTY_STRING);
                                system.debug('linklinklink'+link);
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
    
     /**
     * @description       prevents duplicate tech approval documents 
     * @param             List <Tech_Approval_Documents__c> approvaldocument
     * @return            Void
     * @throws            DML Exception
     */  
     public static void duplicateApprovalDocuments(List < Tech_Approval_Documents__c > approvaldocument) {
        Set<ID> oppdoc=new Set<ID>();
        String sheetThrowingException = UtilConstants.EMPTY_STRING;
        try {
              
            for(Tech_Approval_Documents__c appdoc:approvaldocument){
                oppdoc.add(appdoc.Approval_Documents__c);
            }
            List<opportunity_documents__c>olist=[SELECT Id, opportunity__c from opportunity_documents__c where id IN :oppdoc Limit 5000];
            Set<ID> Oppids=new set<id>();
            for(opportunity_documents__c o: olist){
                Oppids.add(o.opportunity__c);
            }
            List <Tech_Approval_Documents__c > existingapprovaldocument = [Select id, Approval_Documents__c,
                Opportunity_Tech_Approval_Request__c from Tech_Approval_Documents__c where Approval_Documents__r.opportunity__c in:Oppids  Limit 5000];
                    for (Tech_Approval_Documents__c existingDoc: existingapprovaldocument) {
                        for (Tech_Approval_Documents__c newDocument: approvaldocument) {
                        if ((newDocument.Approval_Documents__c.Equals(existingDoc.Approval_Documents__c)) &&
                             (newDocument.Opportunity_Tech_Approval_Request__c.Equals(existingDoc.Opportunity_Tech_Approval_Request__c))){
                                newDocument.addError(UtilConstants.Msg);
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