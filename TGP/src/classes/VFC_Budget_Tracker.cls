/**
    @Author Shashank Shastri
    @name BudgetTracker_VFC
    @CreateDate 18/12/2014
    @Description Upload and Update Budget Tracker excel sheet.
    @Version <1.0>
    @reference Visualforce page: BudgetTracker_VFP
*/


public class VFC_Budget_Tracker 
{
    public Transient Blob fileBody {get; set;}
    public Transient String fileFullData{get;set;}
    public Transient String dropFileName{get;set;}
    public Transient String uploadFileAtt{get;set;}
    public Transient String Description{get;set;}
    public Transient String Deal_Name{get;set;}
    public Transient String Client_Name{get;set;}
    public String allLines_Cost_Summary_MWB {get;set;}
    public attachment budgettrackerexcel {get; set;}
    public List<attachment> listoftrackersheets {get; set;}
    public List<Wave_Plan_Version__c> waveplandetail {get; set;}
    public id hlmpid{get;set;}

/**
    *  Constructor for the class. Gets the High Level Mobilization Plan id, Initializes the page with existing Budget tracker Excel sheet Details.
    *  @name BudgetTracker_VFC
    *  @param controller ApexPages standard controller used to get Highlevel Mobilization Plan id.
    *  @return null
    *  @throws N/A
*/

    public VFC_Budget_Tracker(ApexPages.StandardController controller) 
    {
        Apexpages.currentPage().getHeaders().put(UTIL_Constants.X_UA_COMPATIBLE,UTIL_Constants.IE_EDGE);
        hlmpid=ApexPages.currentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);
        initializePage(hlmpid);
    }
    
/**
    *  Initialize the page with Budget Tracker excel sheet data.
    *  @name initializePage
    *  @param hlmpid, type Id to hold the high level mobilization plan id.
    *  @return void
    *  @throws exception-<exception description>
*/

    private void initializePage(id hlmpid)
    {
        try
        {
            waveplandetail = [select id, name, Client_Name__c,Deal_Name__c from wave_plan_version__c where id=:hlmpid limit 1];
            if(waveplandetail.size()>0){
            Deal_Name = waveplandetail[0].Deal_Name__c;
            Client_Name = waveplandetail[0].Client_Name__c;
            }
            listoftrackersheets = [select id,Name,Description,createddate from attachment where parentid=:hlmpid limit 1];
        }
        catch(Exception e){}            
    }
    
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
        List<Budget_Tracker_map__c> lst_BTMap= [select Column_Order__c,name from Budget_Tracker_map__c limit 10];
        for(Budget_Tracker_map__c btm:lst_BTMap){
        BT_fieldMap.put(integer.valueOf(btm.Column_Order__c),btm.name);
    }
    //Map<integer,string> fieldMap = 
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
        List<string> listOfRows = allLines_Cost_Summary_MWB.trim().split(UTIL_Constants.BACK_N);
        return listOfRows;
    }

/**
    *  Description of the purpose of the classthe method. 
    *  @name <method-name>
    *  @param <parameter-name> <description>
    *  @return <parameter> - <Description about the return parameter>
    *  @throws exception-<exception description>
*/
    private List<Budget_Tracker__c> getListToDelete()
    {
        List<Budget_Tracker__c> listtodelete = new List<Budget_Tracker__c>();
        try{
               listtodelete = [select id from Budget_Tracker__c where High_Level_Mobilization_Plan__c =:hlmpid limit 100];
           }
        catch(Exception ex)
        {
            
        }
        return listtodelete;
    }
/**
    *  Description of the purpose of the classthe method. 
    *  @name <method-name>
    *  @param <parameter-name> <description>
    *  @return <parameter> - <Description about the return parameter>
    *  @throws exception-<exception description>
*/
    private void deleteOldTrackerData(List<Budget_Tracker__c> listtodelete){
        try{
                database.delete(listtodelete);
        }
        catch(Exception ex){}
    }    
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
               listofExceltodelete = [select id from attachment where parentId =:hlmpid limit 100];
           }
        catch(Exception ex)
        {
            
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
        PageReference refreshpage;
        integer firstrow = integer.valueOf(UTIL_Constants.VALUE_THREE);
        List <Budget_Tracker__c> lst_Budget_Tracker_Insert = new List <Budget_Tracker__c>();
        Budget_Tracker__c trackerRecord;
        Map<integer,string> fieldMap = new Map<integer,string>();
        Map<String, Schema.SObjectField> BudgetFields;
        // get List of records to delete and previous Tracker sheet
        List<Budget_Tracker__c> listtodelete =getListToDelete();
        List<attachment> listofExceltodelete =getListOfExcelToDelete();
        fieldMap = getFieldMap();
        BudgetFields = Schema.SObjectType.Budget_Tracker__c.fields.getMap();
        List <String> Tracker_Rows = getListOfRows();
        String[] inputValues;
        try{
            for(integer i=firstrow;i<Tracker_Rows.size();i++)
            {
                inputValues = Tracker_Rows[i].trim().split(System.label.Split);
                trackerRecord = new Budget_Tracker__c();
                //system.debug(inputValues.size());
                for(integer key : fieldMap.KeySet())
                    {    
                        if(inputValues.size()>key && inputValues[key].trim() != null){
                        Schema.SObjectField field = BudgetFields.get(fieldMap.get(key));
                        //system.debug('Ee humar Debag ba:'+inputValues[key]);
                        
                        if(string.valueOf(field.getDescribe().getType()).equals(UTIL_Constants.STRING_LABEL)){
                            if(inputValues[key].trim().length()!=0){
                            trackerRecord.put(fieldMap.get(key),inputValues[key]);
                            }
                        }
                        if(string.valueOf(field.getDescribe().getType()).equals(UTIL_Constants.CURRENCY_LABEL)){
                            if(inputValues[key].trim().length()!=0){
                            trackerRecord.put(fieldMap.get(key),decimal.valueOf(inputValues[key].trim().substring(0,inputValues[key].trim().indexOf('.')+2)));
                        }
                    }
                    }    
                    }
                trackerRecord.High_Level_Mobilization_Plan__c=hlmpid;
                trackerRecord.S_No__c=i-2;
                system.debug('Data:'+trackerRecord);
                lst_Budget_Tracker_Insert.add(trackerRecord);
            }
        budgettrackerexcel = new attachment();
        budgettrackerexcel.name = dropFileName;
        budgettrackerexcel.body = fileBody;
        budgettrackerexcel.Description = Description;
        budgettrackerexcel.parentId=hlmpid;
        database.insert(lst_Budget_Tracker_Insert);
        database.insert(budgettrackerexcel);
        // delete Old Records.
        lst_Budget_Tracker_Insert=null;
        deleteOldTrackerData(listtodelete);
        deleteOldTrackerSheet(listofExceltodelete);
        fileBody=null;
        budgettrackerexcel = null;
        Description=null; 
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,UTIL_Constants.FILE_UPLOADED_SUCCESSFULLY);
        ApexPages.addMessage(myMsg);
        refreshpage =new PageReference(UTIL_Constants.BUDGET_TRACKER_REDIRECT_URL+hlmpid);
        refreshpage.setRedirect(true);
        return refreshpage;
        }
        catch(Exception ex){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error,UTIL_Constants.ERROR_UPLOADING_FILE);
        ApexPages.addMessage(myMsg);
        system.debug('Abe Error yaha hai:'+ex);
        return null;
        }
        
    }
    public void generateReport(){
    initializePage(hlmpid);
    }
}