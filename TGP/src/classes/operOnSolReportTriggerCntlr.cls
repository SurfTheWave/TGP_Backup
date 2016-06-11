/*
@Author : jyotsna yadav
 @name : operOnSolReportTriggerCntlr
@CreateDate : 3/27/2015 1:08 AM
@Description : 
@Version : 
*/
public without sharing class operOnSolReportTriggerCntlr {

/*
@Author : jyotsna yadav
@name : operOnSolReportTriggerCntlr
@CreateDate : 3/27/2015 1:08 AM
@Description : 
@Version : 
*/
    static String urlParam =UtilConstants.EMPTY_STRING;
    public static void createReportURL(List < Solution_Report__c > newSolReports) {
    
    try{
        String param, paramVal;
        String stage, reportingStatus = UtilConstants.EMPTY_STRING;
        List < String > parameterList = new List < String > ();
        List < Solution_Report__c > solReportToUpdate = new List < Solution_Report__c > ();
        for (Solution_Report__c solReport: [Select pv__c, Parameter_Value_s__c, Qry_Str__c, Res_Geo__c, Report__r.Report_ID__c from Solution_Report__c where ID IN: newSolReports Limit 5000]) {
            System.debug('Sol Report ' + solreport);
            //if (solReport.Parameter_Value_s__c != null && solReport.Parameter_Value_s__c != UtilConstants.EMPTY_STRING) {
            if (solReport.pv__C!= null && solReport.pv__c!= UtilConstants.EMPTY_STRING) {
                //System.debug('pv -------------'+solReport.pv__c);                //System.debug('-------split --'+solReport.pv__c.split('\n'));                //parameterList = solReport.Parameter_Value_s__c.split(UtilConstants.Splchr5);
                urlParam =UtilConstants.EMPTY_STRING;
                parameterList = solReport.pv__c.split('\n');
                system.debug('Size of params is' +parameterList.size());
                system.debug('*********'+parameterList+parameterList.size());
                Integer recIndex =0;
                    for (Integer i = 0; i < parameterList.size(); i++) {
                        system.debug('iterate is' +i);
                        param= '';
                        paramVal = '';
                        param = parameterList[i].split(UtilConstants.SPLIT)[0];
                        recIndex = i;
                        if(parameterList[i].split(UtilConstants.SPLIT).Size() > 1){
                        paramVal = parameterList[i].split(UtilConstants.SPLIT)[1];
                        }
                        
                        system.debug('param values after split is' +paramVal);
                        if(paramVal != '' || paramVal != null){
                            processParamValue(parameterList.size(), urlParam, paramVal, recIndex);
                        }
                        
                    }
                    System.debug('urlParam---final---------'+urlParam );
                    solReport.Qry_Str__c = urlParam;
                    solReportToUpdate.add(solReport);
             }
         }
            update(solReportToUpdate);
      }Catch(Exception e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString();
          throw (e);
        }
    }
    
    
    private static  String processParamValue(Integer totalSize, String urlParm, String paramValue, Integer recIndex){
        if(recIndex <= totalSize){
            if(paramValue != '' && paramValue != ' ' && paramValue != null){
                if(urlParam != UtilConstants.EMPTY_STRING){
                    urlParam += UtilConstants.Splchr3 + recIndex + UtilConstants.Splchr2 + EncodingUtil.urlEncode(paramValue.trim(), UtilConstants.UTF_8);
                }else{
                    urlParam += UtilConstants.Splchr1 + recIndex + UtilConstants.Splchr2 + EncodingUtil.urlEncode(paramValue.trim(), UtilConstants.UTF_8);
                }          
            } 
        }
        system.debug('string parametre return by method---------------->>' +urlParam + '// END');
        return urlParm;
        
    }

}