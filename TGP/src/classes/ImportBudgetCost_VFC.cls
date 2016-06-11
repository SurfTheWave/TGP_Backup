/**
    @Author Divyashree C K
    @name BudgetTracker_VFC
    @CreateDate 18/12/2014
    @Description Upload and Update Budget Tracker excel sheet.
    @Version <1.0>
    @reference Visualforce page: BudgetTracker_VFP
*/


public class ImportBudgetCost_VFC
{
    public Transient Blob fileBody {get; set;}
    public Transient String fileFullData{get;set;}
    public Transient String dropFileName{get;set;}
    public Transient String uploadFileAtt{get;set;}
    public Transient String Description{get;set;}
    public String allLines_Cost_Summary_MWB {get;set;}
    public String fileName{get; set;}
    
    //public List<attachment> listoftrackersheets {get; set;}
    public id hlmpid{get;set;}

/**
    *  Constructor for the class. Gets the High Level Mobilization Plan id, Initializes the page with existing Budget tracker Excel sheet Details.
    *  @name BudgetTracker_VFC
    *  @param controller ApexPages standard controller used to get Highlevel Mobilization Plan id.
    *  @return null
    *  @throws N/A
*/
    public ImportBudgetCost_VFC(ApexPages.StandardController controller) 
    {
        Apexpages.currentPage().getHeaders().put(UtilConstants.X_UA_COMPATIBLE,UtilConstants.IE_EDGE);
        hlmpid=ApexPages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID);
        //initializePage(hlmpid);
    }
    
/**
    *  Initialize the page with Budget Tracker excel sheet data.
    *  @name initializePage
    *  @param hlmpid, type Id to hold the high level mobilization plan id.
    *  @return void
    *  @throws exception-<exception description>

    private void initializePage(id hlmpid)
    {
        try
        {
            List<attachment> listoftrackersheets;
            listoftrackersheets = [select id,Name,Description,createddate from attachment where parentid=:hlmpid limit 1];
        }
        catch(Exception e){}            
    }
*/
    
/**
    *  Creates a Map of field Api names and column order to Map the field of Budget Tracker Object with the Tracker Excel sheet
    *  @name getFieldMap
    *  @param N/A
    *  @return Map<integer, string> BT_fieldMap
    *  @throws exception-<exception description>
    */
    private Map<integer,string> getFieldMap()
    {
        Map<integer,string> BT_fieldMap =new Map<integer,string>();
        List<BudgetCost_field_map__c> lst_BTMap= [select Column_Order__c,name from BudgetCost_field_map__c limit 10];
        for(BudgetCost_field_map__c btm:lst_BTMap){
        BT_fieldMap.put(integer.valueOf(btm.Column_Order__c),btm.name);
    }
    //System.debug('BT_fieldMap ' + BT_fieldMap);
    return BT_fieldMap;
    }
    
/**
    *  Description of the purpose of the classthe method. 
    *  @name <method-name>
    *  @param <parameter-name> <description>
    *  @return <parameter> - <Description about the return parameter>
    *  @throws exception-<exception description>
*/
    private List<String> getListOfRows()
    {
        //System.debug('allLines_Cost_Summary_MWB '+ allLines_Cost_Summary_MWB);
        if(allLines_Cost_Summary_MWB <> null && allLines_Cost_Summary_MWB.contains('Cost Summary - MWB')){
                List<string> listOfRows = allLines_Cost_Summary_MWB.trim().split('\n');
                return listOfRows;
         }
         else{
                return null;
         }
        
    }

/**
    *  Description of the purpose of the classthe method. 
    *  @name <method-name>
    *  @param <parameter-name> <description>
    *  @return <parameter> - <Description about the return parameter>
    *  @throws exception-<exception description>
*/
    private Map<String, Budget_Cost_Summary__c> getMapToUpdate()
    {
        List<Budget_Cost_Summary__c> listToUpd = new List<Budget_Cost_Summary__c>();
        Map<String, Budget_Cost_Summary__c> bdgtUpdList = new Map<String, Budget_Cost_Summary__c>();
        
        try{
               listToUpd = [select id, Name, Active__c, Actuals_Cost_000__c, EAC_Cost_000__c,
                           Forecasts_Cost_000__c, Mobilization_Plan__c, ODE_Cost_000__c, ODE_Variance_Cost_000__c,
                           Serial_Number__c FROM  Budget_Cost_Summary__c where Mobilization_Plan__c =:hlmpid limit 100];
               if(listToUpd.size() > 0){
                   for(Budget_Cost_Summary__c  bdgtCost : listToUpd){
                       bdgtUpdList.put(bdgtCost.Name, bdgtCost);
                   }
               }
            //System.debug('bdgtUpdList ' +bdgtUpdList);
           }
        catch(Exception ex)
        {
            //System.debug('ERROR!!!!'  + ex);
        }
        return bdgtUpdList;
    }
/**
    *  Description of the purpose of the classthe method. 
    *  @name <method-name>
    *  @param <parameter-name> <description>
    *  @return <parameter> - <Description about the return parameter>
    *  @throws exception-<exception description>

    private void deleteOldTrackerData(List<Budget_Cost_Summary__c> listtodelete){
        if(listtodelete.size() > 0){
            try{
                database.delete(listtodelete);
            }
            catch(Exception ex){
            
            }
        }
    } 
*/       
/**
    *  Description of the purpose of the classthe method. 
    *  @name <method-name>
    *  @param <parameter-name> <description>
    *  @return <parameter> - <Description about the return parameter>
    *  @throws exception-<exception description>
*/
    private List<attachment> getListofExceltodelete()
    {
        List<attachment> listofExceltodelete = new List<attachment>();
        try{
               listofExceltodelete = [select id,name from attachment where parentId =:hlmpid and name <> 'HiringOnboardStatus_File.xls.xlsm' limit 100];
           }
        catch(Exception ex)
        {
            //System.debug('Deletion ERROR!! '  + ex);
        }
        return listofExceltodelete;
    }

/**
    *  Description of the purpose of the classthe method. 
    *  @name <method-name>
    *  @param <parameter-name> <description>
    *  @return <parameter> - <Description about the return parameter>
    *  @throws exception-<exception description>
*/
    private void deleteOldTrackerSheet(List<attachment> listofExceltodelete){
        database.delete(listofExceltodelete);
    }    
    
/**
    *  Description of the purpose of the classthe method. 
    *  @name <method-name>
    *  @param <parameter-name> <description>
    *  @return <parameter> - <Description about the return parameter>
    *  @throws exception-<exception description>
*/    
    public pagereference UploadFile()
    {
        attachment budgettrackerexcel ;
        PageReference refreshpage;
        integer firstrow = integer.valueOf(3);
        Map <String, Budget_Cost_Summary__c> lst_Budget_Tracker_Insert = new Map <String, Budget_Cost_Summary__c>();
        Budget_Cost_Summary__c trackerRecord;
        Map<integer,string> fieldMap = new Map<integer,string>();
        Map<String, Schema.SObjectField> BudgetFields;
        // get List of records to delete and previous Tracker sheet
        Map<String, Budget_Cost_Summary__c> bdgtCostUpdMap =getMapToUpdate();
        List<attachment> listofExceltodelete =getListOfExcelToDelete();
        fieldMap = getFieldMap(); //Custom Setting: Col Order,Name
        BudgetFields = Schema.SObjectType.Budget_Cost_Summary__c.fields.getMap();
        List <String> Tracker_Rows = getListOfRows();
        String[] inputValues;
        Mobilization_Plan__c  mplan = new Mobilization_Plan__c (Id = hlmpid );
        try{
            
            if(Tracker_Rows <> null){
            for(integer i=firstrow;i<Tracker_Rows.size();i++)
            {
                inputValues = Tracker_Rows[i].trim().split(System.label.Split);
                trackerRecord = new Budget_Cost_Summary__c(EAC_Cost_000__c = 0, ODE_Cost_000__c = 0);
                //System.debug(inputValues + '>>>>>>' +fieldMap );
                for(integer key : fieldMap.KeySet())
                    {    
                     if(inputValues.size()>key){
                         
                            Schema.SObjectField field = BudgetFields.get(fieldMap.get(key));
                            ////System.debug('Ee humar Debag ba:'+inputValues);
                            if(string.valueOf(field.getDescribe().getType()).equals(UtilConstants.STRING_LABEL)){
                                if(inputValues[key].trim() != UtilConstants.EMPTY_STRING && inputValues[key].trim() != null){
                                    if(bdgtCostUpdMap <> null && bdgtCostUpdMap.containsKey(inputValues[key])){
                                        trackerRecord.Id = bdgtCostUpdMap.get(inputValues[key]).Id;
                                    }
                                    trackerRecord.put(fieldMap.get(key),inputValues[key]);
                                }
                            }
                            if(string.valueOf(field.getDescribe().getType()).equals(UtilConstants.CURRENCY_LABEL)){
                                if(inputValues[key].trim() != UtilConstants.EMPTY_STRING && inputValues[key].trim() != null){
                                    trackerRecord.put(fieldMap.get(key), Double.valueOf(inputValues[key]));
                                }
                            }
                        }    
                    }
                trackerRecord.Mobilization_Plan__c=hlmpid;
                trackerRecord.Serial_Number__c = i-2;
                System.debug('Tracker Record ' + trackerRecord);
                lst_Budget_Tracker_Insert.put(trackerRecord.Name.toUpperCase(), trackerRecord);
                //System.debug('lst_Budget_Tracker_Insert '  +lst_Budget_Tracker_Insert);
                
            }
        System.debug('lst_Budget_Tracker_Insert '  +lst_Budget_Tracker_Insert);
        
        if(lst_Budget_Tracker_Insert.size() > 0){
             Decimal EACcstWOutConti = 0;
             Decimal EACcstWithConti  = 0;
             Decimal ODEcstWOutConti = 0;
             Decimal ODEcstWithConti  = 0;
            if(lst_Budget_Tracker_Insert.get('TOTAL COSTS WITHOUT CONTINGENCY') <> null ){ 
                  EACcstWOutConti = lst_Budget_Tracker_Insert.get('TOTAL COSTS WITHOUT CONTINGENCY').EAC_Cost_000__c;
                  ODEcstWOutConti = lst_Budget_Tracker_Insert.get('TOTAL COSTS WITHOUT CONTINGENCY').ODE_Cost_000__c;
             }
                  
            if(lst_Budget_Tracker_Insert.get('TOTAL COSTS WITH CONTINGENCY') <> null ){
                   EACcstWithConti = lst_Budget_Tracker_Insert.get('TOTAL COSTS WITH CONTINGENCY').EAC_Cost_000__c;
                   ODEcstWithConti = lst_Budget_Tracker_Insert.get('TOTAL COSTS WITH CONTINGENCY').ODE_Cost_000__c;
             }
             
             System.debug('WITHOUT ' +EACcstWOutConti  + 'With  ' +  EACcstWithConti );
            for(Budget_Cost_Summary__c bdgt : lst_Budget_Tracker_Insert.values()){
                        System.debug('bdgt : ' + bdgt);
                        bdgt.EAC_Cost_TCV_w_o_Contingency__c  = (EACcstWOutConti > 0) ? bdgt.EAC_Cost_000__c*100/EACcstWOutConti : 0;
                        bdgt.EAC_Cost_TCV_with_Contingency__c = (EACcstWithConti > 0) ? bdgt.EAC_Cost_000__c*100/EACcstWithConti : 0;
                        bdgt.ODE_Cost_TCV_w_o_Contingency__c  = (ODEcstWOutConti > 0) ? bdgt.ODE_Cost_000__c*100/ODEcstWOutConti : 0;
                        bdgt.ODE_Cost_TCV_with_Contingency__c = (ODEcstWithConti > 0) ? bdgt.ODE_Cost_000__c*100/ODEcstWithConti : 0;
            }
                   
           mplan.EAC_Cost_w_o_Contingency__c  =  EACcstWOutConti ;
           mplan.EAC_Cost_with_Contingency__c =  EACcstWithConti ;
           mplan.ODE_Cost_w_o_Contingency__c  =  ODEcstWOutConti ;
           mplan.ODE_Cost_with_Contingency__c =  ODEcstWithConti ;
        }
        
        budgettrackerexcel = new attachment();
        if(dropFileName<> null && dropFileName <> '')
        budgettrackerexcel.name = dropFileName;
        else 
        budgettrackerexcel.name  = 'BUgetCostSummaary_File';
        budgettrackerexcel.body = fileBody;
        budgettrackerexcel.Description = Description;
        budgettrackerexcel.parentId=hlmpid;
        //System.debug('Attchement '  + budgettrackerexcel);        
        //database.insert(lst_Budget_Tracker_Insert);
        DataBase.UpsertResult[] srt = database.upsert(lst_Budget_Tracker_Insert.values());
        //System.debug('SaveResult  ' + srt);
        database.insert(budgettrackerexcel);
        database.update(mplan);
        // delete Old Records.
        //deleteOldTrackerData(listtodelete);
        deleteOldTrackerSheet(listofExceltodelete);
        fileBody=null;
        budgettrackerexcel = null;
        Description=null;
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,UtilConstants.FILE_UPLOADED_SUCCESSFULLY);
        ApexPages.addMessage(myMsg);
        //refreshpage =new PageReference('/'+hlmpid);
        //refreshpage.setRedirect(true);
        //return refreshpage;
            return null;
            } 
         else{
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, 'An error has occured. Please check the template');
            ApexPages.addMessage(myMsg);
            return null;
         }
        }
        catch(Exception ex){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error,UtilConstants.ERROR_UPLOADING_FILE);
        ApexPages.addMessage(myMsg);
        ExceptionClass.logException('ImportBudgetCost_VFC', 'ImportBudgetCost_VFC' , ex, UtilConstants.APPLICATION_MWB, 'Budget Cost Summary');
        System.debug('Error!!! ' + ex);
        return null;
        }
        
    }
    public void generateReport(){}
}