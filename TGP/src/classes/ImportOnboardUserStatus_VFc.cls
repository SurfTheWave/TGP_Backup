/**
    @Author Yasin
    @name ImportOnboardUserStatus_VFc
    @CreateDate 04/2/2016
    @Description Upload and Update Onboard user status excel sheet.
    @Version <3.5>
    @reference Visualforce page: ImportOnboardUserStatus_VFP
*/

public class ImportOnboardUserStatus_VFc
{
    public Transient Blob fileBody {get; set;}
    public Transient String fileFullData{get;set;}
    public Transient String dropFileName{get;set;}
    public Transient String uploadFileAtt{get;set;}
    public Transient String Description{get;set;}
    public String allLines_Onboard_User_Status {get;set;}
    public String fileName{get; set;}
    public id hlmpid{get;set;}

    /**
    *  Constructor for the class. Gets the High Level Mobilization Plan id, Initializes the page with existing ImportOnboardUserStatus Excel sheet Details.
    *  @name ImportOnboardUserStatus_VFC
    *  @param controller ApexPages standard controller used to get Highlevel Mobilization Plan id.
    *  @return null
    *  @throws N/A
   */
   
    public ImportOnboardUserStatus_VFc(ApexPages.StandardController controller) 
    {
        Apexpages.currentPage().getHeaders().put(UtilConstants.X_UA_COMPATIBLE,UtilConstants.IE_EDGE);
        hlmpid=ApexPages.currentPage().getParameters().get(UtilConstants.URL_PARAMETER_ID);
    }
        
    private Map<integer,string> getFieldMap()
    {
        Map<integer,string> HS_fieldMap =new Map<integer,string>();
        List<OnboardUserstatus_Field_Map__c> lst_HSMap= [select Column_Order__c,name from OnboardUserstatus_Field_Map__c limit 25];
        for(OnboardUserstatus_Field_Map__c hsm:lst_HSMap){
        HS_fieldMap.put(integer.valueOf(hsm.Column_Order__c),hsm.name);
        }
    return HS_fieldMap;
    }
    
    private List<String> getListOfRows()
    {
        if(allLines_Onboard_User_Status <> null && allLines_Onboard_User_Status.contains('Onboard User status')){
                List<string> listOfRows = allLines_Onboard_User_Status.trim().split('\n');
                return listOfRows;
         }
         else{
                return null;
         }        
    }
    
    private Map<String, Onboard_User_status__c> getMapToUpdate()
    {
        List<Onboard_User_status__c> listToUpd = new List<Onboard_User_status__c>();
        Map<String, Onboard_User_status__c> onboardUserStatusUpdList = new Map<String, Onboard_User_status__c>();
        
        try{
               listToUpd = [select id,Name,  SL_No__c, Demand_ID__c, SR__c, Deal__c, Status__c, Career_Level__c, Demand_Type_New_Backfill__c, Role__c, Location__c,
                               Skill_Category_Voice_Data__c, Onboard_Date__c, Employee_ID__c, Middle_Name__c, Last_Name__c, Pool__c, Process__c, Wave__c,
                               Delivery_Location__c, Passport_Status__c, KT_Resource__c, KT_Location__c, Contact_Number__c, BGC_Status__c, Waves__c 
                               FROM  Onboard_User_status__c WHERE Waves__c =:hlmpid limit 100];                           
               if(listToUpd.size() > 0){
                   for(Onboard_User_status__c bdgtCost : listToUpd){
                       onboardUserStatusUpdList.put(bdgtCost.Name, bdgtCost);
                   }
               }
           }
        catch(Exception ex){ }
        return onboardUserStatusUpdList;
    }
      
   private List<attachment> getExistingExcelSheet(String attachmentName){
             List<attachment> listofExceltodelete = [select id,name,createdDate from attachment where parentId =: hlmpid and name =: attachmentName order by createdDate desc limit 1 ];
        return listofExceltodelete;    
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
        attachment onboarduserstatustrackerexcel ;
        List<attachment> existingtrackerexcel;        
        PageReference refreshpage;
        integer firstrow = integer.valueOf(3);
        Map <String, Onboard_User_status__c> lst_onboarduser_Status_Insert = new Map <String, Onboard_User_status__c>();
        Onboard_User_status__c trackerRecord;
        Map<integer,string> fieldMap = new Map<integer,string>();
        Map<String, Schema.SObjectField> OnboardUserStatusFields;      
        
          SavePoint sp = Database.setSavePoint();
          
        // get List of records to delete and previous Tracker sheet
        Map<String, Onboard_User_status__c> onboardStatusUpdMap =getMapToUpdate();
        
        List<Onboard_User_status__c> oldrecords = new List<Onboard_User_status__c>();
        Set<Id> oldrecordsId = new Set<Id>();        
        oldrecords = onboardStatusUpdMap .Values();    
        
        if(oldrecords.size()>0){         
             delete oldrecords; 
        }

        //List<attachment> listofExceltodelete =getListOfExcelToDelete();       
        fieldMap = getFieldMap(); //Custom Setting: Col Order,Name                           
        OnboardUserStatusFields = Schema.SObjectType.Onboard_User_status__c.fields.getMap();
        List <String> Tracker_Rows = getListOfRows();              
        String[] inputValues;
        Wave__c  mplan = new Wave__c (Id = hlmpid );        
        try{
            
            if(Tracker_Rows <> null){
            for(integer i=firstrow;i<Tracker_Rows.size();i++)
            {
                inputValues = Tracker_Rows[i].trim().split(System.label.Split);
                trackerRecord = new Onboard_User_status__c();
                for(integer key : fieldMap.KeySet())
                    {    
                     if(inputValues.size()>key){                         
                            Schema.SObjectField field = OnboardUserStatusFields.get(fieldMap.get(key));
                            Schema.DisplayType fieldDataType = field.getDescribe().getType();   
                            
                          if(string.valueOf(field.getDescribe().getType()).equals(UtilConstants.STRING_LABEL)){
                                if(inputValues[key].trim() != UtilConstants.EMPTY_STRING && inputValues[key].trim() != null){ 
                                   /* if(onboardStatusUpdMap <> null && onboardStatusUpdMap.containsKey(inputValues[key])){
                                        trackerRecord.Id = onboardStatusUpdMap.get(inputValues[key]).Id;
                                    }*/
                                      trackerRecord.put(fieldMap.get(key),inputValues[key]);
                                }
                          }
                          
                          if(fieldDataType == Schema.DisplayType.Picklist){
                                   if(inputValues[key].trim() != UtilConstants.EMPTY_STRING && inputValues[key].trim() != null)
                                    trackerRecord.put(fieldMap.get(key),inputValues[key]);
                          }                          
                           
                          if(fieldDataType == Schema.DisplayType.Phone){
                                   if(inputValues[key].trim() != UtilConstants.EMPTY_STRING && inputValues[key].trim() != null)
                                    trackerRecord.put(fieldMap.get(key),inputValues[key]);
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
                        }    
                    }
                trackerRecord.Waves__c=hlmpid;
                lst_onboarduser_Status_Insert.put(trackerRecord.Name.toUpperCase(), trackerRecord);              
            }  
       
        existingtrackerexcel = getExistingExcelSheet('OnboardUserStatus_File.xls.xlsm'); 
        onboarduserstatustrackerexcel = (existingtrackerexcel.size() >0)? existingtrackerexcel[0] : new attachment();  
        onboarduserstatustrackerexcel.name  = 'OnboardUserStatus_File.xls.xlsm';
        onboarduserstatustrackerexcel.body = fileBody;
        onboarduserstatustrackerexcel.Description = Description;
        if(!(existingtrackerexcel.size() > 0))
        onboarduserstatustrackerexcel.parentId=hlmpid;
        DataBase.UpsertResult[] srt = database.upsert(lst_onboarduser_Status_Insert.values());
        database.upsert(onboarduserstatustrackerexcel);
        database.update(mplan);
        fileBody=null;
        onboarduserstatustrackerexcel = null;
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
                ExceptionClass.logException('ImportOnboardUserStatus_VFc', 'ImportOnboardUserStatus_VFc' , ex, UtilConstants.APPLICATION_MWB, 'Onboard User status');
                return null;
        }
    }
    public void generateReport(){}
}