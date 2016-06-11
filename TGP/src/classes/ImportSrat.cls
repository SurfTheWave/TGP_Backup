/*
Author : Madhusudhan
Release  :2.0 Enhancements 
Description :  Re usability code for Import functionality for All Trackers

Created Date       Modified Date
--------------    -------------------------------------------------------------
05-July-2015       

*/
public with sharing class ImportSrat{

    //Excel related fields
    public Transient Blob fileBody {get; set;}
    List<String> allLines = new List<String>();
    List<String> allSratLevel1 = new List<String>();
    List<String> allLines_Off = new List<String>();
    public String allLines_SratLevel1 {get;set;}
    public String allLines_SratLevel2 {get;set;}
    public String allLines_OpexLevel1 {get;set;}
    public String allLines_OpexLevel2 {get;set;}
    public List<Error_Workbook> errorWorkbook{get;set;} 
    public String fileName{get;set;}
    public String recordId{get;set;}
    public String dealName{get;set;}
    public Transient String dropFileName{get;set;}
    public Transient String fileFullData{get;set;}        
    // Sobject name
    public string selectedValue {get; set;}
    public String coma {get;set;}
    public String newLine {get;set;}
    //DML Operations
    public string dmlOpps{get; set;}
    //Calling constructor    
    public ImportSrat() {                                                                                                     
        coma = ',';
        newLine ='\n';
      
    }
     public String xlsHeader {
         get {    
             String strHeader = '';
             strHeader += '<?xml version="1.0"?>';
             strHeader += '<?mso-application progid="Excel.Sheet"?>';
             return strHeader;
         }
     }
    //Destination of the cancel Button 
    public PageReference cancel(){
    PageReference  pr = new PageReference('/home/home.jsp');
    return null;
    }                                                                         
//================here starts coding=====================================================================================
    //Defining list, sets and string
    public list<Schema.Sobjectfield> sObjectFieldsList {get; set;}
    public set<string> FieldNames{get;set;}
    //transient used to limit the page size
    transient list<string> headersList{get;set;}
    public list<string> headersLebelList{get;set;}
    transient set<Integer> headersContainedList{get;set;}
    transient list<list<string>> csvRows{get;set;}
    transient String[] ListOfRecordsOnly {get; set;}
    transient String[] ListOfRecordsWithId {get; set;}  
    transient map<string, object> fieldswithDataType;
    public list<list<string>> failRecords {get; set;}
    public list<list<list<string>>> allaFailRecords {get; set;}
    public String objLabel{get;set;}
    //Method                             
    public PageReference uploadFile(){
      recordId=ApexPages.currentPage().getParameters().get(UtilConstants.REC_ID);
      system.debug('recordId---'+recordId);
    errorWorkbook=new List<Error_Workbook>();
        if(allLines_SratLevel1!=null && allLines_SratLevel1!=''){
            fileName='SratLevel1_2';
            SRAT_Tracker__c srat=[select Mobilization_Plan__r.deal__r.name from SRAT_Tracker__c where  id=:recordId limit 1];
            dealName=srat.Mobilization_Plan__r.deal__r.name;
            updateSheetData('SRAT_Additional_Tracking_Level_1__c',allLines_SratLevel1,'SratLevel1Export');
        }
        if(allLines_SratLevel2!=null && allLines_SratLevel2!=''){
            
            updateSheetData('SRAT_Additional_Tracking_Level_2__c',allLines_SratLevel2,'SratLevel2Export');
        }
        if(allLines_OpexLevel1!=null && allLines_OpexLevel1!=''){
            fileName='OpexLevel1_2';
            OPEX_Tracker__c opex=[select Mobilization_Plan__r.deal__r.name from OPEX_Tracker__c where  id=:recordId limit 1];
            dealName=opex.Mobilization_Plan__r.deal__r.name;
            updateSheetData('Deal_OPEX_Additional_Tracking_Level_1__c',allLines_OpexLevel1,'OpexLevel1Export');
        }
        if(allLines_OpexLevel2!=null && allLines_OpexLevel2!=''){
            
            updateSheetData('Deal_OPEX_Additional_Tracking_Level_2__c',allLines_OpexLevel2,'OpexLevel2Export');
        }
     if(errorWorkbook!=null && !errorWorkbook.isEmpty()){
            PageReference reRend = new PageReference('/apex/FailedSrat');
            reRend.setRedirect(false);
            return reRend;                  
         }
        Pagereference pageRef = new PageReference('/'+recordId);
        pageRef.setRedirect(false);
        return null;  
    }
    
    public void updateSheetData(String objName,String allLines,String errorFileName){  
    //Initiallizing
    FieldNames = new set<string>();
    headersList = new list<string>();
    
    headersContainedList = new set<Integer>();
    ListOfRecordsOnly = new String[]{};
    csvRows = new list<list<String>>();
    ListOfRecordsWithId = new String[]{};
    sObject dynObject;
    string firsTRecordIds = '';                    
    fieldswithDataType = new map<string, object>();
    //Sobject which is selected   
    selectedValue =objName;

    recordId=System.currentPageReference().getParameters().get('recordId');
    Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();  
    Schema.DescribeSObjectResult r = gd.get(selectedValue).getDescribe();  
    
    //get name of Sobject
    String tempName = r.getName();   
    objLabel=r.getLabel();
    //Fields of sobject
    sObjectFieldsList = Schema.getGlobalDescribe().get(selectedValue).getDescribe().fields.getMap().values();
    //Loop over fields list
    for(Schema.Sobjectfield schemaField : sObjectFieldsList) {
        Schema.Describefieldresult FieldResult = schemaField.getDescribe();
        //Check if the is updatable or creatable
        if( FieldResult.isUpdateable() && FieldResult.isCreateable()) {         
            //Populated list with fields API Names
            FieldNames.add(FieldResult.getName().toLowerCase());            
            //map of field with corresponding data type values
            fieldswithDataType.put(FieldResult.getName().toLowerCase(), FieldResult.getType());            
        }                
    }        

    for(String row : allLines.trim().split(UtilConstants.NEW_LINE)) {
    
        //add row
        csvRows.add(row.split('»'));
    }
    
    //system.debug('headersLebelList-----'+headersLebelList);
    // Get the fields from the custom settings----------------------
    List<Export_Fields__c>  fieldsList=[Select Object_Name__c,fields_Name__c from Export_Fields__c where Object_Name__c =:objName Limit 1];
    String [] fields;
    String fieldN=UtilConstants.EMPTY_STRING;
    if(fieldsList.size()>0){
        for(Export_Fields__c flds : fieldsList) {
            headersList = flds.fields_Name__c.split(UtilConstants.COMMA); 
        }
    }
    //list for Indexes with Id also
    set<Integer> IdContainedIndex = new set<Integer>();
    //here adding Id column but removing other unkwon fields
    integer WithId = 0;
    for(string head : headersList){  
        //Getting index(List of integers) values of the unknown fields in the Excel file
        if(!fieldswithDataType.containskey(head.toLowerCase().trim())){ 
        IdContainedIndex.add(WithId);
            for(integer d=0; d<headersList.size(); d++){
                if(headersList[d].trim()== 'Id'){
                    IdContainedIndex.remove(d);
              //  system.debug('IdContainedIndex--if id remove- '+IdContainedIndex);
                }
            }
        }
        WithId++;
    }
    list<object> MyHeaderMap = new  list<object>();
    //get the fields datatype which are in file
    for(string head : headersList){
        object mapofFile = fieldswithDataType.get(head.toLowerCase().trim());
        //list of object contains data type of fields in the file
        MyHeaderMap.add(mapofFile);                  
    }                         
    //list of the Records with corresponding Id's
    list<string> FieldValueWithId = new list<string>();
    sObject ObjectWithIdRecords;//sObject
    list<Sobject> SobjectForUpdate = new list<Sobject>();//List of records
    //========================================================upsert===========================================
    //Here's is upsert method
    dmlOpps='Upsert';
    if(dmlOpps == 'Upsert'){
        //Limiting the loop
        for(Integer k=0; k<headersList.size(); k++ ){
            //Check if the Id Column is there
            if(headersList[k].trim()== 'Id')
            //Loop for the size of the string
            for(Integer h=3; h<csvRows.size(); h++){
                //Assigning the value of csvrows to list
                ListOfRecordsWithId = csvRows.get(h);
                firsTRecordIds = '';
                integer b = 0;
                //Defining a dynamic object             
                ObjectWithIdRecords = Schema.getGlobalDescribe().get(selectedValue).newSObject();
                //system.debug('ListOfRecordsWithId---'+ListOfRecordsWithId);
                if(ListOfRecordsWithId!=null && !String.isBlank(ListOfRecordsWithId[b])){
                //system.debug('ListOfRecordsWithId.size()-----'+ListOfRecordsWithId.size());
                    //putting value of field according to the field index
                    Integer rowSize=0;
                    if(headersList.size() <= ListOfRecordsWithId.size()){
                        rowSize=headersList.size();
                    }else{
                        rowSize=ListOfRecordsWithId.size();
                    }
                    for(Integer y=0; y<rowSize; y++){ 
                    //system.debug('ListOfRecordsWithId.size()-----'+y);
                        //Check weather is provided or not
                        if(!IdContainedIndex.contains(y)){ 
                            Object s = null;
                            try {        
                                //processing the datatype of the record and the field
                                if ( MyHeaderMap[y]!=null &&( MyHeaderMap[y]==DisplayType.Double||MyHeaderMap[y]==DisplayType.Currency || MyHeaderMap[y]==DisplayType.Percent)){

                                s = decimal.valueOf((String)ListOfRecordsWithId[y]); 

                                } else if (MyHeaderMap[y]==DisplayType.Boolean){                 
                                if (ListOfRecordsWithId[y]=='true'){
                                s = true;               
                                }else if (ListOfRecordsWithId[y]=='false'){
                                s = false;              
                                }else {
                                s = Boolean.valueOf(ListOfRecordsWithId[y]);
                                }
                                } else if (MyHeaderMap[y]==DisplayType.Integer) {
                                s = Integer.valueOf(ListOfRecordsWithId[y]);
                                } else if (MyHeaderMap[y]==DisplayType.Date) {

                                if(ListOfRecordsWithId[y]!=''){
                                    String[] myDateOnly = ListOfRecordsWithId[y].split(' ');
                                    String[] strDate = myDateOnly[0].split('/');
                                    Integer myIntDate = integer.valueOf(strDate[1].trim());
                                    Integer myIntMonth = integer.valueOf(strDate[0]);
                                    Integer myIntYear = integer.valueOf(strDate[2]);
                                    Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
                                    s=d;
                                }

                                } else if (MyHeaderMap[y]==DisplayType.DateTime) {                                     
                                s = DateTime.valueOf(ListOfRecordsWithId[y]);
                                } else if (MyHeaderMap[y]==DisplayType.REFERENCE) {
                                    if(ListOfRecordsWithId[y] <> null && ListOfRecordsWithId[y] <> ''){
                                      //  id idList = Id.valueOf(ListOfRecordsWithId[y]);
                                       // s = idList; 
                                    }
                                } else if ((MyHeaderMap[y]==DisplayType.PickList || MyHeaderMap[y]==DisplayType.PickList) && MyHeaderMap[y]==null) {
                                s = '';
                                }else{ 
                                     if(ListOfRecordsWithId[y] <> null && ListOfRecordsWithId[y] <> ''){
                                        s = ListOfRecordsWithId[y];
                                     }  
                                }           
                            }catch (System.TypeException e){

                                continue;                                      
                            }  
                            ObjectWithIdRecords.put(headersList[y].trim(), s);                                             
                           //System.debug('******ObjectWithIdRecords-- '+ObjectWithIdRecords);
                        }
                    }
                    
                    //Add object ot list of object
                     
                    SobjectForUpdate.add(ObjectWithIdRecords);
                   // System.debug('******SobjectForUpdate-- '+SobjectForUpdate);
                }
                
            }                                         
        }                                       
        try{
            Database.SaveResult[] srList = Database.update(SobjectForUpdate, false); 
            list<string> singleRecord=new list<string>();
            allaFailRecords=new list<list<list<string>>>();
            failRecords=new list<list<string>>();
            List<String> errorHeaderList=new List<String>();
            headersLebelList = new list<string>();
            headersLebelList=csvRows.get(2);
            errorHeaderList.addall(headersList);
            headersLebelList.add('Error');
                if(srList!=null){
                    for (Integer idx = 0; idx < srList.size(); idx++) {
                        if(srList[idx].isSuccess()){
                            continue;
                        }else{

                            for(Database.Error err : srList[idx].getErrors()) {
                                system.debug('Database.Error--- '+err);
                                string recordId=SobjectForUpdate.get(idx).id;
                                for(integer j=1; j<csvRows.size(); j++ ){
                                    singleRecord= csvRows.get(j);
                                    if(singleRecord[0].equals(recordId)){
                                        for(String str:headersLebelList){
                                            if(headersLebelList.size()>singleRecord.size()+1){
                                                singleRecord.add('');
                                            }else{
                                                break;
                                            }
                                        }
                                        singleRecord.add(err.getMessage());
                                        failRecords.add(singleRecord);
                                       // system.debug('failRecords------ '+failRecords);
                                    }
                                }
                            }  
                        }
                    } 
                    allaFailRecords.add(failRecords);
                    //system.debug('allaFailRecords.size()----- '+allaFailRecords.size());
                    if(!failRecords.isEmpty() && failRecords.size()>0){
                        errorWorkbook.add(new Error_Workbook(allaFailRecords,errorFileName,headersLebelList));
                    }
                }

            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.INFO,'Records Have been updated Succesfully');
            ApexPages.addMessage(errormsg);           
            }
            catch (Exception e){
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later');
                ApexPages.addMessage(errormsg);
               // system.debug('Exception --- '+e);
            } 
        }
           
    }
    public class Error_Workbook {
        public list<list<list<string>>> data{get; set;}
        public string sheetName{get;set;}  
        public list<String> headerList{get;set;}
        //Constructor for Error_Workbook
        public Error_Workbook(list<list<list<string>>> data, String sheetName,list<string> headerList) {
            this.data=data;
            this.sheetName=sheetName;  
            this.headerList=headerList;
        } 
    }  
  public static void addError(String error) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
  }   
}