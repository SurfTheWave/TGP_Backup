/**
   @Author         : TGP MWB Team
   @name           : UTILMobClasses
   @CreateDate     : 5 January 2015
   @Description    : Utility code for Mobilization WorkBench.
   @Version        : 1.0
  */
global without sharing class UTILMobClasses {
    /**
     *@Method        : getCreatableFields
     *@Parameter     : Object Name
     *@Description   : This method will accept object name and will return all editable in Query format 
                        with Select Statement
    */
    public static Boolean flag = TRUE;
    public static Boolean SRATapprovaltriggerFlag = TRUE;
    public static String getCreatableFields(String objectName) {
        try {
            String queryFields = UtilConstants.EMPTY_STRING;
            String queryWithFields = UtilConstants.EMPTY_STRING;
            Map < String, Schema.SObjectField > fieldsMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
            List < String > creatableFields = new List < String > ();
            if (!fieldsMap.isEmpty()) {
                for (Schema.SObjectField fields: fieldsMap.Values()) {
                    Schema.DescribeFieldResult fieldResult = fields.getDescribe();
                    String fieldName = fieldResult.getName();
                    if (fieldResult.isCreateable()) {
                        creatableFields.add(fieldName);
                    }
                }
            }
            for (String createableFld: creatableFields) {
                queryFields += createableFld + UtilConstants.COMMA_STRING;
            }
            if (queryFields.endsWith(UtilConstants.COMMA_STRING)) {
                queryFields = queryFields.substring(0, queryFields.lastIndexOf(UtilConstants.COMMA_STRING));
            }
            queryWithFields = UtilConstants.SELECT_STRING + UtilConstants.EMPTY_STRING + queryFields + UtilConstants.EMPTY_STRING + UtilConstants.FROM_STRING + UtilConstants.EMPTY_STRING + objectName + UtilConstants.WHERE_STRING;
            return queryWithFields;
        } Catch(Exception e) {
            //System.debug('E==='+e);
        }
        return null;
    }
    /*
    @Method: checkDeletingChildRecordsIfMobPlanIsInactive
    @Description : This method will check if the  mOb plan is inactive.The child records would not become inactive. 
                    However, no user should be able to delete the child records either. 
   //Commenting as Delete button is overridden
    global void checkBeforeDeletingChildRecords(List<sObject> recList ){
        for(sObject s: recList){
            Object objInst = s.get(UtilConstants.INACTIVE_MOB_FIELD_NAME);
            String valueinField = String.valueOf(objInst );
            if(valueinField.equals('false')){
                s.addError(UtilConstants.INACTIVE_REC_DEL_MSG , false);
            }
        } 
    }
*    @Method: checkDeletingActiveRecords
*    @Description : This method will check if the record is Active. Only Inactive records can be deleted
    
    global void checkDeletingActiveRecords(List<sObject> recList ){
        for(sObject s: recList){
            Object objInst = s.get(UtilConstants.ACTIVE_FIELD_NAME);
            String valueinField = String.valueOf(objInst );
            if(valueinField.equals('true')){
                s.addError(UtilConstants.ACTIVE_REC_DEL_MSG, false);
            }
        } 
    }
   */
    /**
     *@Method: checkGTLRoleDelete
     *@Parameter: List<sObject>: Object Name
     *@Description: This method will accept object name and will return all editable in Query format with Select 
                    Statement
    */
    global void checkGTLRoleDelete(List < sObject > recList) {
        for (sObject s: recList) {
            Object objInst = s.get(UtilConstants.GTL_ROLE_FIELD);
            String valueinField = String.valueOf(objInst);
            if (valueinField.equals(UtilConstants.GTL_ROLE_NAME)) {
                s.addError(UtilConstants.GTL_ROLE_DEL_MSG, false);
            }
        }
    }
    /*
     *    @Method:populateMobilizationPlan
     *    @Description : This method will populate the object name and will return all editable in Query format with Select 
                        Statement
     */
    public void populateMobilizationPlan(List < sObject > sObjectList) {
        try {
            Map < Id, sObject > trkrMap = new Map < Id, sObject > ();
            List < Id > waveIds = new List < Id > ();
            for (sObject trkr: sObjectList) {
                //System.debug(trkr + 'rtkr');
                waveIds.add(String.valueOf(trkr.get(UtilConstants.WAVE_API)));
            }
            Map < Id, Wave__c > waveRecMap = new Map < Id, Wave__c > ([SELECT ID, Mobilization_Plan__c
            FROM Wave__c WHERE Id IN: waveIds LIMIT 5000]);
            //System.debug('waveRecMap' + waveRecMap);
            for (sObject obj: sObjectList) {
                obj.put(UtilConstants.MOBILIZATION_PLAN_API, waveRecMap.get(String.valueOf(obj.get(UtilConstants.WAVE_API))).Mobilization_Plan__c);
                //System.debug('Obj%%%%' + obj);
            }
        } Catch(Exception e) {
            //System.debug('E==='+e);
        }
    }
    /**
     * @Method name   : findObjectAPIName 
     * @Description   : Get the object name Using record id for Export functionality.
     * @Param         : recordID of type ID
     * @return Value  : Object api name of type String.   
     **/
    global string findObjectAPIName(id recordId) {
        string objectAPIName = UtilConstants.EMPTY_STRING;
        try {
            if (recordId == null) return null;
            Schema.SObjectType sobj = recordId.getSobjectType();
            objectAPIName = string.valueof(sobj);
        } catch (Exception e) {
            e.getMessage();
        }
        return objectAPIName;
    }
}