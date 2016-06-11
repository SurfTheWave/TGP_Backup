/*
Author : Madhusudhan
Release  :2.0 Mobilization workbench
Description :  Re usability code for Import functionaliy for All Trackers

Created Date       Modified Date
--------------    -------------------------------------------------------------
08-Jan-2015       

*/
public with sharing class UtilImportTrackers_VFC{                
    // Sobject name
    public string selectedValue {get; set;}
    public String coma {get;set;}
    public String newLine {get;set;}
    //DML Operations
    public string dmlOpps{get; set;}
    //Calling constructor    
    public UtilImportTrackers_VFC() {                                                                                                     
        coma = ',';
        newLine ='\n';
    }
    //Destination of the cancel Button 
    public PageReference cancel(){
    PageReference  pr = new PageReference('/home/home.jsp');
    return null;
    }                                                                         
//================here starts coding=====================================================================================
    //Defining list, sets and string
    public blob BlobFile{get;set;}
    public string RecordsInTheFile {get;set;}
    public list<Schema.Sobjectfield> sObjectFieldsList {get; set;}
    public set<string> FieldNames{get;set;}
    //transient used to limit the page size
    transient list<string> headersList{get;set;}
    transient set<Integer> headersContainedList{get;set;}
    transient list<list<string>> csvRows{get;set;}
    transient String[] ListOfRecordsOnly {get; set;}
    transient String[] ListOfRecordsWithId {get; set;}  
    transient map<string, object> fieldswithDataType;
    public list<list<string>> failRecords {get; set;}
    public list<list<string>> testRecords {get; set;}
    public String recordId{get;set;}
    public String objLabel{get;set;}
    //Method                                                                             
    public PageReference processingFile(){                                                                                            //Initiallizing
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
    selectedValue = System.currentPageReference().getParameters().get('objName');
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
    //Check if the no file is selected
    if(blobFile == null){
        //Error Message
        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.FATAL,'Kindly Choose your File First');
        ApexPages.addMessage(errormsg);
        return null;
    }
       //file processing
    RecordsInTheFile = BlobFile.tostring();//taking blob file to a string   
    csvRows=parseCSV(RecordsInTheFile);
    system.debug('csvRows--- '+csvRows);
    headersList = RecordsInTheFile.split('\r\n');//splitting at new line

       //list of headers (field Names) only
    headersList = headersList[0].split(','); 
    system.debug('headersList--- '+headersList);
    //list for Indexes with Id also
    set<Integer> IdContainedIndex = new set<Integer>();
    //here adding Id column but removing other unkwon fields
    integer WithId = 0;
    for(string head : headersList){
        //Getting index(List of integers) values of the unknown fields in the csv file

        if(!fieldswithDataType.containskey(head.toLowerCase())){ 
        IdContainedIndex.add(WithId);
            for(integer d=0; d<headersList.size(); d++){
                if(headersList[d].trim()== 'Id'){
                    IdContainedIndex.remove(d);

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
        system.debug('MyHeaderMap--- '+MyHeaderMap);                
    }   
    system.debug('MyHeaderMap--- '+MyHeaderMap.size());                              
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
            for(Integer h=1; h<csvRows.size(); h++){
                //Assigning the value of csvrows to list
                ListOfRecordsWithId = csvRows.get(h);
                firsTRecordIds = '';
                integer b = 0;
                //List of Id's in the record
                FieldValueWithId = ListOfRecordsWithId[b].split(',');
                //Defining a dynamic object             
                ObjectWithIdRecords = Schema.getGlobalDescribe().get(selectedValue).newSObject();
                if(ListOfRecordsWithId[b] !=''){
                    //putting value of field according to the field index
                    system.debug('ListOfRecordsWithId.size()---'+ListOfRecordsWithId.size());
                    for(Integer y=0; y<ListOfRecordsWithId.size(); y++){ 
                        //Check weather is provided or not
                        if(!IdContainedIndex.contains(y)){ 
                            Object s = null;
                            try {      
                            system.debug('MyHeaderMap[y]=--- '+MyHeaderMap[y]);  
                                //processing the datatype of the record and the field
                                if (MyHeaderMap[y]==DisplayType.Double||MyHeaderMap[y]==DisplayType.Currency || MyHeaderMap[y]==DisplayType.Percent){

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
                                        id idList = Id.valueOf(ListOfRecordsWithId[y]);
                                        s = idList; 
                                    }
                                } else if ((MyHeaderMap[y]==DisplayType.PickList || MyHeaderMap[y]==DisplayType.PickList) && MyHeaderMap[y]==null) {
                                s = '';
                                }else{ 
                                    s = ListOfRecordsWithId[y];

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
                     system.debug('ObjectWithIdRecords--- '+ObjectWithIdRecords);
                }
                
            }                                         
        }                                       
        try{
            Database.SaveResult[] srList = Database.update(SobjectForUpdate, false); 
            list<string> singleRecord=new list<string>();
            failRecords=new list<list<string>>();
            List<String> errorHeaderList=new List<String>();
            errorHeaderList.addall(headersList);
            errorHeaderList.add('Error');
            failRecords.add(errorHeaderList);
            //list<string> recordId=new List<string>();
            // Iterate through each returned result
                if(srList!=null){
                    for (Integer idx = 0; idx < srList.size(); idx++) {
                        if(srList[idx].isSuccess()){
                            continue;
                        }else{
                            for(Database.Error err : srList[idx].getErrors()) {
                                string recordId=SobjectForUpdate.get(idx).id;
                                    for(integer j=1; j<csvRows.size(); j++ ){
                                        singleRecord= csvRows.get(j);
                                        if(singleRecord[0].contains(recordId)){
                                            for(String str:errorHeaderList){
                                                if(errorHeaderList.size()>singleRecord.size()+1){
                                                    singleRecord.add('');
                                                }else{
                                                    break;
                                                }
                                            }
                                            singleRecord.add(err.getMessage());
                                            failRecords.add(singleRecord);
                                        }
                                    }
                            }
                        }
                    }     
                }
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.INFO,'Records Have been updated Succesfully');
            ApexPages.addMessage(errormsg);           
            }
            catch (Exception e){
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later');
                ApexPages.addMessage(errormsg);
            } 
        }
        if(!failRecords.isEmpty() && failRecords.size()>1){
            PageReference reRend = new PageReference('/apex/ExportFailedRecords');
            reRend.setRedirect(false);
            return reRend;                  
         }
        Pagereference pageRef = new PageReference('/'+recordId);
        pageRef.setRedirect(false);
        return null;      
    }
    
    public static List<List<String>> parseCSV(String contents) {

      System.debug('## parseCSV called with contents = ' + contents);
        // Determine if it is split by newLine(\n) or return carriage(\r) or a \r\nn
        Boolean hasNewLine = false;
        Boolean hasCarrReturn = false;
        
        //First check for a \r\n char
        if(contents.contains('\r\n')) {
            System.debug('## Contains at least one \'\\r\\n\' character');
            hasNewLine = true;
            hasCarrReturn = false;
        }
        else {
            //If not then check for either a /r or /n
            if(contents.contains('\n')) {
                System.debug('## Contains at least one newline character');
                hasNewLine = true;
            }
            if(contents.contains('\r')) {
                System.debug('## Contains at least one carriage return character');
                hasCarrReturn = true;
            }
        }
        
        List<List<String>> allFields = new List<List<String>>();
        if(hasNewLine && hasCarrReturn) {
            addError('The file contains both newline and carriage returns');
        }
        else {
            
            String splitBy = '\n';
            if(hasCarrReturn) {
                splitBy = '\r';
            }
            contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
            // now replace all remaining double quotes - we do this so that we can reconstruct
            // fields with commas inside assuming they begin and end with a double quote
            contents = contents.replaceAll('""','DBLQT');
            // we are not attempting to handle fields with a newline inside of them
            // so, split on newline to get the spreadsheet rows
            List<String> lines = new List<String>();
            try {
                lines = contents.split(splitBy);
            } catch (System.ListException e) {
                e.getMessage();
            }
            Integer num = 0;
            
            for(String line : lines) {
                List<String> fields = line.split(',', -1);  
                List<String> cleanFields = new List<String>();
                String compositeField;
                Boolean makeCompositeField = false;
                for(String field : fields) {
                    if (field.trim().startsWith('"') && field.trim().endsWith('"')) {
                        cleanFields.add(field.replaceAll('DBLQT','"'));
                        
                    } else if (field.trim().startsWith('"')) {
                        makeCompositeField = true;
                        compositeField = field;
                    } else if (field.trim().endsWith('"')) {
                        compositeField += ',' + field;
                        cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                        makeCompositeField = false;
                    } else if (makeCompositeField) {
                        compositeField +=  ',' + field;
                       // System.debug('compositeField-makeCompositeField-- true--- ' +compositeField);
                    } else {
                        cleanFields.add(field.replaceAll('DBLQT','"'));
                    }
                }
                
                // Remove double quotes (if present) from start and end of each field
                List<String> noQuoteFields = new List<String>();
                for(String field : cleanFields) {
                    if(field.trim().startsWith('"') && field.trim().endsWith('"')) {
                       // system.debug('field clean---'+field );
                        field=field.replaceAll('"','').trim();
                        //field = field.substring(1, field.length() - 1);
                        system.debug('field trim--'+field);
                    }
                    noQuoteFields.add(field);
                }
                allFields.add(noQuoteFields);
            }
        }
        
        // Remove any rows before header row so that header row is first row:
        Integer headerRow = -1;
        for(Integer i=0; (i < allFields.size() && headerRow == -1) ; i++) {
            // Determine if all fields in this row are non-blank:
            List<String> row = allFields.get(i);
            Boolean isHeaderRow = true;
            
            for(String field : row) {
                if(field == '') { // field is blank
                    isHeaderRow = false;
                }
            }
            
            if(isHeaderRow) {
                headerRow = i;
            }
        }
               // System.debug('## headerRow ' +headerRow);
        
        for(Integer i=0; i < headerRow; i++) {
            allFields.remove(0);
        }
 
       // System.debug('## About to return ' + allFields.size() + ' lines...');
        return allFields;
    }
  public static void addError(String error) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
  }   
}