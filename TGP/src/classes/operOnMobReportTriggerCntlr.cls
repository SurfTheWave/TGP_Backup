/*
@Author : jyotsna yadav
 @name : operOnMobReportTriggerCntlr
@CreateDate : 3/28/2015 2:11 AM
@Description : 
@Version : 
*/
public without sharing class operOnMobReportTriggerCntlr {
/*
@Author : jyotsna yadav
 @name : operOnMobReportTriggerCntlr
@CreateDate : 3/28/2015 2:11 AM
@Description : 
@Version : 
*/
    public static void createReportURL(List < Mob_Reports__c > newMobReports) {
    try{
        String param, paramVal, urlParam = UtilConstants.EMPTY_STRING;
        String stage, reportingStatus = UtilConstants.EMPTY_STRING;
        List < String > parameterList = new List < String > ();
        List < Mob_Reports__c > mobReportToUpdate = new List < Mob_Reports__c > ();
        for (Mob_Reports__c mobReport: [Select Parameter_Value_s__c, Qry_Str__c
        from Mob_Reports__c where ID IN: newMobReports Limit 5000]) {
            if (mobReport.Parameter_Value_s__c != null && mobReport.Parameter_Value_s__c != UtilConstants.EMPTY_STRING) {
                parameterList = mobReport.Parameter_Value_s__c.split(UtilConstants.Splchr5);
                //system.debug('*********'+parameterList+parameterList.size());
                for (Integer i = 0; i < parameterList.size(); i++) {
                    param = parameterList[i].split(UtilConstants.SPLIT)[0];
                    paramVal = parameterList[i].split(UtilConstants.Splchr4)[1];
                    
                        if (urlParam != UtilConstants.EMPTY_STRING) {
                            urlParam += UtilConstants.Splchr3 + i + UtilConstants.Splchr2 + EncodingUtil.urlEncode(paramVal, UtilConstants.UTF_8);
                        } else {
                            urlParam += UtilConstants.Splchr1 + i + UtilConstants.Splchr2 + EncodingUtil.urlEncode(paramVal, UtilConstants.UTF_8);
                        }
                    }
                    
                mobReport.Qry_Str__c = urlParam;
                mobReportToUpdate.add(mobReport);
            }
        }
        if (mobReportToUpdate.size() > 0) {
            UtilConstants.IS_RECURSIVE = true;
            update mobReportToUpdate;
        }
        }Catch(Exception e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString();
          throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
                          //ApexPages.addMessage(myMsg);﻿
        }
    }
}