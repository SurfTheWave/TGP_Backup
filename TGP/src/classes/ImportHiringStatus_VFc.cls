/**
    @Author Yasin
    @name ImportHiringStatus_VFc
    @CreateDate 04/1/2016
    @Description Upload and Update hiring status excel sheet.
    @Version <3.5>
    @reference Visualforce page: ImportHiringStatus_VFP
*/

public class ImportHiringStatus_VFc
{
    public Transient Blob fileBody {get; set;}
    public Transient String fileFullData{get;set;}
    public Transient String dropFileName{get;set;}
    public Transient String uploadFileAtt{get;set;}
    public Transient String Description{get;set;}
    public String allLines_Hiring_Status {get;set;}
    public String fileName{get; set;}
    public id hlmpid{get;set;}

    /**
    *  Constructor for the class. Gets the High Level Mobilization Plan id, Initializes the page with existing HiringStatus Excel sheet Details.
    *  @name ImportHiringStatus_VFC
    *  @param controller ApexPages standard controller used to get Highlevel Mobilization Plan id.
    *  @return null
    *  @throws N/A
   */
   
    public ImportHiringStatus_VFc(ApexPages.StandardController controller) 
    {
        Apexpages.currentPage().getHeaders().put(UtilConstants.X_UA_COMPATIBLE,UtilConstants.IE_EDGE);
        hlmpid=ApexPages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID);
    }
    
    /*
     * @Description: fetch fields from hiring custom setting object
     * @Name        : getFieldMap
     * @param       : NA
     * @return parameter : Map<integer,string> 
     * @throws exception: NA
    */    
    private Map<integer,string> getFieldMap()
    {
        Map<integer,string> HS_fieldMap =new Map<integer,string>();
        List<HiringStatus_Field_Map__c> lst_HSMap= [select Column_Order__c,name from HiringStatus_Field_Map__c limit 21];
        for(HiringStatus_Field_Map__c hsm:lst_HSMap){
        HS_fieldMap.put(integer.valueOf(hsm.Column_Order__c),hsm.name);
        }
    return HS_fieldMap;
    }
    
    /*
     * @Description: read and parse excel sheet values
     * @Name        : getListOfRows
     * @param       : NA
     * @return parameter : List<String>
     * @throws exception: NA
    */  
    private List<String> getListOfRows()
    {
        if(allLines_Hiring_Status <> null && allLines_Hiring_Status.contains('Hiring Status')){
                List<string> listOfRows = allLines_Hiring_Status.trim().split('\n');
                return listOfRows;
         }
         else{
                return null;
         }        
    }
    
    /*
     * @Description: get all exisiting hiring status before uploading new sheet 
     * @Name        : getMapToUpdate
     * @param       : NA
     * @return parameter : Map<String, Hiring_Status__c>
     * @throws exception: NA
    */      
    private Map<String, Hiring_Status__c> getMapToUpdate()
    {
        List<Hiring_Status__c> listToUpd = new List<Hiring_Status__c>();
        Map<String, Hiring_Status__c> bdgtUpdList = new Map<String, Hiring_Status__c>();      
        try{
               listToUpd = [select Id, Name,Wave__c, Date_Requested__c, Joining_Date__c, Contact_Number__c, Delivery_Location__c, Location__c, Passport_Status__c, 
                               Pool__c, Candidate_Status__c, Role__c, Process__c, Last_Name__c, Middle_Name__c, Skill_Category_Voice_Data__c, Demand_Type_New_Backfill__c, 
                               Career_Level__c, Deal__c, Offering__c, Sourcing_Request_Number__c, SL_No__c 
                               FROM  Hiring_Status__c WHERE  Wave__c =: hlmpid limit 100];                           
               if(listToUpd.size() > 0){
                   for(Hiring_Status__c  bdgtCost : listToUpd){
                       bdgtUpdList.put(bdgtCost.Name, bdgtCost);
                   }
               }
           }
        catch(Exception ex){ }
        return bdgtUpdList;
    }
    
   /*
     * @Description: To get all exisiting hiring attachment
     * @Name        : UploadFile
     * @param       : String attachmentName
     * @return parameter : List<attachment> 
     * @throws exception: NA
   */
   private List<attachment> getExistingExcelSheet(String attachmentName){
        List<attachment> listofExceltodelete = [select id,name,createdDate from attachment where parentId =: hlmpid and name =: attachmentName order by createdDate desc limit 1 ];
        return listofExceltodelete;    
   }
   
   /*
     * @Description: upload new hiring status sheet
     * @Name        : UploadFile
     * @param       : NA
     * @return parameter : pagereference 
     * @throws exception: file uploading error 
   */
   public pagereference UploadFile()
   {
        attachment hiringstatustrackerexcel ;
        List<attachment> existingtrackerexcel;
        PageReference refreshpage;
        integer firstrow = integer.valueOf(3);
        Map <String, Hiring_Status__c> lst_Hiring_Status_Insert = new Map <String, Hiring_Status__c>();
        Hiring_Status__c trackerRecord;
        Map<integer,string> fieldMap = new Map<integer,string>();
        Map<String, Schema.SObjectField> HiringStatusFields; 
        
        SavePoint sp = Database.setSavePoint();
                
        // get List of records to delete and previous Tracker sheet
        Map<String, Hiring_Status__c> hiringStatusUpdMap =getMapToUpdate();
        List<Hiring_Status__c> oldrecords = new List<Hiring_Status__c>();
        Set<Id> oldrecordsId = new Set<Id>();        
        oldrecords = hiringStatusUpdMap.Values();    
        
        if(oldrecords.size()>0){
           /*for(Hiring_Status__c hs :oldrecords)
              oldrecordsId.add(hs.Id);*/            
             delete oldrecords; 
        }
         
        //List<attachment> listofExceltodelete =getListOfExcelToDelete();
        fieldMap = getFieldMap(); //Custom Setting: Col Order,Name                           
        HiringStatusFields = Schema.SObjectType.Hiring_Status__c.fields.getMap();
        List <String> Tracker_Rows = getListOfRows();
        String[] inputValues;
        Wave__c  waveCreation = new Wave__c (Id = hlmpid );        
        
        try{
            
            if(Tracker_Rows <> null){
            for(integer i=firstrow;i<Tracker_Rows.size();i++)
            {
                inputValues = Tracker_Rows[i].trim().split(System.label.Split);
                trackerRecord = new Hiring_Status__c();
                for(integer key : fieldMap.KeySet())
                    {    
                     if(inputValues.size()>key){                         
                         Schema.SObjectField field = HiringStatusFields.get(fieldMap.get(key));                         
                          Schema.DisplayType fieldDataType = field.getDescribe().getType(); 
                        
                         /* if(fieldDataType == Schema.DisplayType.Id){                 
                                  if(oldrecordsId.contains(String.valueOf(inputValues[key]))){ 
                                        trackerRecord.Id = String.valueOf(inputValues[key]);
                                    }
                          }*/
 
                          if(string.valueOf(field.getDescribe().getType()).equals(UtilConstants.STRING_LABEL)){
                                if(inputValues[key].trim() != UtilConstants.EMPTY_STRING && inputValues[key].trim() != null){ 
                                      trackerRecord.put(fieldMap.get(key),inputValues[key]);
                                }
                          }                                                    
                                                                                           
                          if(fieldDataType == Schema.DisplayType.Double){
                                if(inputValues[key].trim() != UtilConstants.EMPTY_STRING && inputValues[key].trim() != null){
                                    trackerRecord.put(fieldMap.get(key), Double.valueOf(inputValues[key]));
                                }
                          }
                                                     
                          if(fieldDataType == Schema.DisplayType.Date){
                                if(inputValues[key].trim() != UtilConstants.EMPTY_STRING && inputValues[key].trim() != null){
                                    trackerRecord.put(fieldMap.get(key), Date.parse(inputValues[key]));
                                }
                           }
                           
                           if(fieldDataType == Schema.DisplayType.Phone){
                                if(inputValues[key].trim() != UtilConstants.EMPTY_STRING && inputValues[key].trim() != null){
                                    trackerRecord.put(fieldMap.get(key), inputValues[key]);
                                }
                           }   
                           
                        }    
                    }
                trackerRecord.Wave__c=hlmpid;
                lst_Hiring_Status_Insert.put(trackerRecord.Name.toUpperCase(), trackerRecord);              
            }  
               
        existingtrackerexcel = getExistingExcelSheet('HiringStatus_File.xls.xlsm');
        hiringstatustrackerexcel = (existingtrackerexcel.size() >0)? existingtrackerexcel[0] : new attachment();  
        hiringstatustrackerexcel.name  = 'HiringStatus_File.xls.xlsm';
        hiringstatustrackerexcel.body = fileBody;
        hiringstatustrackerexcel.Description = Description;
        if(!(existingtrackerexcel.size() > 0))
             hiringstatustrackerexcel.parentId=hlmpid;
        DataBase.UpsertResult[] srt = database.upsert(lst_Hiring_Status_Insert.values());                
        database.upsert(hiringstatustrackerexcel);
        database.update(waveCreation);                       
        fileBody=null;
        hiringstatustrackerexcel = null;
        Description=null;
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,UtilConstants.FILE_UPLOADED_SUCCESSFULLY);
        ApexPages.addMessage(myMsg);
            return null;
            } 
         else{
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, 'An error has occured. Please check the template');
               ApexPages.addMessage(myMsg);
               return null;
         }
        }
        catch(Exception ex){
                Database.rollback(sp);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error,UtilConstants.ERROR_UPLOADING_FILE);
                ApexPages.addMessage(myMsg);
                ExceptionClass.logException('ImportHiringStatus_VFc', 'ImportHiringStatus_VFc' , ex, UtilConstants.APPLICATION_MWB, 'Hiring Status');
                return null;
        }
    }
}