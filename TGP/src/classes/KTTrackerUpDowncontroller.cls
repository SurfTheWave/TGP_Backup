/*
Author : Sushmanth Hasti
Story  :  
Description : 

Updated by        Story no                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/

public with sharing class KTTrackerUpDowncontroller {

    public boolean disableDownload{get;set;}
    public boolean disableUpload{get;set;}
    public string locationId{get;set;}
    public string waveId{get;set;}
    public string fileId{get;set;}
    public string fileName{get;set;}
    public string fileType{get;set;}
    public string displayfileName{get;set;}
    public Wave_Planning__c strDealLocation{get;set;}//
    public Wave_Planning__c strDealWave{get;set;}
    public List<Tracking_KT__c> trackRec{get;set;}
    public List<Document> doc{get;set;}
    public Document document{get;set;}
    public String  UserName{get;set;}
    public String fileData{get;set;}
    public String  downLoaderUserName{get;set;}
    public Boolean refreshPage {get; set;}
    public integer count{get;set;}
    public boolean flagImage{get;set;}
    public boolean fileDownloadedConfirm{get;set;}
    public boolean isVisibleDownload {get;set;}
  
    List<String> allLines = new List<String>();     
    private Integer inputCharacterMax { get { return 100000; } set; } // this is a somewhat arbitrary character limit
    String[] filelinesLeft = new String[]{};
    String[] filelinesRight = new String[]{};
    List<KT_Tracker__c> ktTracker;
    List<DTP_Tracker__c> dtTracker ;
    
    public Transient String fileFullData{get;set;}
    public Transient String fileFullDataSheet2{get;set;}
    public Transient String dropFileName{get;set;}
    public Transient String uploadFileAtt{get;set;}
    public boolean isDone{get;set;}

    
    /******************************
    Method Name: KTTrackerUpDowncontroller
    Description: This is Constructor for the KTTrackerUpDowncontroller class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/ 
    public KTTrackerUpDowncontroller (ApexPages.StandardController controller)
    {
        Apexpages.currentPage().getHeaders().put(UTIL_Constants.X_UA_COMPATIBLE,UTIL_Constants.IE_EDGE);
        isDone=false;
        count=0;
        refreshPage = false;       
        waveId=ApexPages.CurrentPage().getParameters().get(system.label.ID);
        
        //Take File name for this location from Tracking_Recruitment__c object
        trackRec =[select id,File_Name__c,isDownload__c,clickOnDownLoad__c,File_Downloader_User_Name__c from Tracking_KT__c where Deal_Wave__c=:waveId];
        if(trackRec.size()==1)
        {
            downLoaderUserName=trackRec[0].File_Downloader_User_Name__c;
            disableDownload=trackRec[0].isDownload__c;
            UserName=UserInfo.getName();
            
            //If file is allready downloaded
            if(disableDownload)
            {
                //if file is downloaded by current user
                if(downLoaderUserName!= null && downLoaderUserName.equals(UserName))
                {
                    isVisibleDownload=true;
                    fileDownloadedConfirm=false;
                    disableDownload=true;
                    disableUpload=false;
                }
                //if file is not downloaded by current user
                else
                {
                    isVisibleDownload=true;
                    fileDownloadedConfirm=false;
                    disableDownload=true;
                    disableUpload=true;
                }
            }
            //If file is not downloaded by anyone
            else
            {
                //If file is downloaded but confirmation is not done
                if(trackRec[0].clickOnDownLoad__c==true)
                {
                    //If file is downloaded by current user but confirmation is not done
                    if(downLoaderUserName!= null && downLoaderUserName.equals(UserName))
                    {
                        isVisibleDownload=false;
                        fileDownloadedConfirm=true;
                        disableDownload=false;
                        disableUpload=true;    
                    }
                    //If file is not downloaded by current user but confirmation is not done
                    else
                    {
                        isVisibleDownload=true; 
                        fileDownloadedConfirm=false;
                        disableDownload=false;
                        disableUpload=true;
                    }
                }
                //If file is not downloaded by anyone
                else
                {
                    isVisibleDownload=true;
                    fileDownloadedConfirm=false;
                    disableDownload=false;
                    disableUpload=true;    
                }
            }
           
            //File stored in Document for perticular location
            doc=[Select name, id, Description,Type, IsPublic, FolderId, AuthorId from Document where name=:trackRec[0].File_Name__c];   
            if(doc.size()>0)
            {
                fileId=doc[0].id; 
                fileType=doc[0].type;
                displayfileName=doc[0].name+'.'+doc[0].type; 
            }
        }
        strDealWave=new Wave_Planning__c();
        
        //Wave for which we have to stored the file
        List<Wave_Planning__c> DealWaveList=[Select id,Wave_Label__c, Deal_Location__r.Wave_Plan_Version__r.deal__c, Deal_Location__r.Wave_Plan_Version__c,Location_Name__c,Deal_Location__r.id,  
                                                Deal_Location__r.Wave_Plan_Version__r.deal__r.name,Deal_Location__r.Wave_Plan_Version__r.name, Deal_Location__r.Deployment_Lead_New__r.SFDC_User__c,
                                                Deal_Location__r.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c,KT_Lead_New__r.SFDC_User__c,Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c
                                                 from Wave_Planning__c where id=: waveId];        
        if(DealWaveList.size()>0)
        {                       
            strDealWave=DealWaveList[0]; 
            //fileName='KT Tracker_'+DealWaveList[0].Deal_Location__r.Wave_Plan_Version__r.deal__r.name+'_'+DealWaveList[0].Deal_Location__r.Wave_Plan_Version__r.name+'_'+DealWaveList[0].Location_Name__c+'_'+DealWaveList[0].Wave_Label__c;    
              String dealName ='';
              String locationName='';
              String waveName='';
               
              if(DealWaveList[0].Deal_Location__r.Wave_Plan_Version__r.deal__r.name.length() > 41){
                  dealName= DealWaveList[0].Deal_Location__r.Wave_Plan_Version__r.deal__r.name.substring(0, 40); 
              }else{
                  dealName=DealWaveList[0].Deal_Location__r.Wave_Plan_Version__r.deal__r.name;  
              }
              
              if(DealWaveList[0].Location_Name__c.length() > 31){
                  locationName= DealWaveList[0].Location_Name__c.substring(0, 30);
              }else{
                  locationName= DealWaveList[0].Location_Name__c;
              }
              
              if(DealWaveList[0].Wave_Label__c.length() > 21){
                  waveName= DealWaveList[0].Wave_Label__c.substring(0, 20); 
              }else{
                  waveName= DealWaveList[0].Wave_Label__c;
              }
              
             String systemTime= DateTime.now().format(UTIL_Constants.SYSTEM_TIME_FORMAT);            
             fileName='KT_'+dealName+'_'+locationName+'_'+waveName+'_'+systemTime;   
        }
        
    }
    
    /******************************
    Method Name: DownloadFile
    Description: This method is used to download the file  
    Paramenters: NA
    Return Value: void
    *******************************/
    public void DownloadFile()
    {
        try
        {
            UserName=UserInfo.getName();  
            
            //Record for current Location-file pair from Tracking_Recruitment__c object
            trackRec =[select id,File_Name__c,isDownload__c,clickOnDownLoad__c,File_Downloader_User_Name__c from Tracking_KT__c where Deal_Wave__c=:waveId];
            if(trackRec.size()==1)
            {
                //Change the name of file in the document
                doc=[Select name, id, Description,Type, IsPublic, FolderId, AuthorId from Document where name=:trackRec[0].File_Name__c];   
                if(doc.size()>0)
                {
                    //doc[0].name=fileName+'_'+System.now().format('EEEE, MMMM d, yyyy - hh-mm-ss');
                     doc[0].name=fileName;
                    upsert doc[0];
                    fileId=doc[0].id; 
                    fileDownloadedConfirm=true;   
                    trackRec[0].File_Name__c=doc[0].name;     
                }
                trackRec[0].isDownload__c=false;
                trackRec[0].clickOnDownLoad__c=true;
                trackRec[0].File_Downloader_User_Name__c=UserName;
                upsert trackRec[0];
            }
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,''+e));  
            return;
        }
        return;    
    }
    
    /******************************
    Method Name: actionYes
    Description: This method confirms that file is successfuly downloaded by user  
    Paramenters: NA
    Return Value: void
    *******************************/
    public pagereference actionYes()
    {
        try
        {
            UserName=UserInfo.getName();    
            //Record for current Location-file pair from Tracking_Recruitment__c object
            trackRec =[select id,File_Name__c,isDownload__c,File_Downloader_User_Name__c from Tracking_KT__c where Deal_Wave__c=:waveId];
            if(trackRec.size()==1)
            {   
                trackRec[0].isDownload__c=true;
                trackRec[0].clickOnDownLoad__c=false;
                upsert trackRec[0];
                disableDownload=true;           
                disableUpload=false;
                fileDownloadedConfirm=false;  
                isVisibleDownload=true;
            }
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.EMPTY_STRING+e));  
            return null;
        }
        pagereference pr=new PageReference(UTIL_Constants.APEX_KTTRACKERUPDOWN_ID+waveId);
        pr.setRedirect(true);
        return pr;       
    }
    
    /******************************
    Method Name: actionNo
    Description: This method confirms that file is not successfuly downloaded by user  
    Paramenters: NA
    Return Value: void
    *******************************/
    public pagereference actionNo()
    {
        try
        {
            UserName=UserInfo.getName(); 
            //Record for current Location-file pair from Tracking_Recruitment__c object
            trackRec =[select id,File_Name__c,isDownload__c,File_Downloader_User_Name__c from Tracking_KT__c where Deal_Wave__c=:waveId];
            if(trackRec.size()==1)
            {   
                trackRec[0].isDownload__c=false;
                trackRec[0].clickOnDownLoad__c=false;
                upsert trackRec[0];
                fileDownloadedConfirm=false;  
                isVisibleDownload=true;
            }
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.EMPTY_STRING+e));  
            return null;
        }
        pagereference pr=new PageReference(UTIL_Constants.APEX_KTTRACKERUPDOWN_ID+waveId);
        pr.setRedirect(true);
        return pr;        
    }
    
     /******************************
    Method Name: UploadFile
    Description: This method is used to upload the file  
    Paramenters: NA
    Return Value: void
    *******************************/
    public void UploadFile()
    {
        count=count+1;                        
     
        //Record for current Location-file pair from Tracking_Recruitment__c object
        trackRec =[select id,File_Name__c,isDownload__c,File_Downloader_User_Name__c from Tracking_KT__c where Deal_Wave__c=:waveId];
        if(trackRec.size()==1)
        {
            String name=trackRec[0].File_Name__c+UTIL_Constants.XLSX;
            if(dropFileName!=name && count==1)
            {
                count=0;
                fileFullData = UTIL_Constants.EMPTY_STRING ;
                uploadFileAtt = UTIL_Constants.EMPTY_STRING;
                dropFileName = UTIL_Constants.EMPTY_STRING;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.YOU_CAN_NOT_UPLOAD_DIFFERENT_FILE));
                return;    
            }
        } 
     if(fileFullData != null && fileFullData != UTIL_Constants.EMPTY_STRING && uploadFileAtt != null && uploadFileAtt != UTIL_Constants.EMPTY_STRING && dropFileName != null && dropFileName != UTIL_Constants.EMPTY_STRING){
        boolean isInserted=false;  
        boolean dtIsInserted=false; 
        flagImage=true;
        Savepoint sp = Database.setSavepoint();
        if(fileFullData != uploadFileAtt)
        {
            try
            {
                if(fileFullData !=null && fileFullData != UTIL_Constants.EMPTY_STRING)
                {
                    if(uploadFileAtt !=null && uploadFileAtt!=UTIL_Constants.EMPTY_STRING)
                    {
                        ktTracker = new List<KT_Tracker__c>();
                        Integer pivot = fileFullData.indexOf( UTIL_Constants.BACK_R, Integer.valueOf(Math.floor(fileFullData.length() / 2)) );
                        if ( pivot > inputCharacterMax ) 
                        {
                            divideString(fileFullData);
                        }
                        else 
                        {
                            allLines = fileFullData.split(UTIL_Constants.BACK_N);
                        }
                        if(allLines.size() != 0)
                        {
                         /*if(allLines.size() == 27){
                             count=0;
                             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Not able to upload the empty sheet(without data)'));
                             return;
                         }*/
                             boolean isRecordExist=false;    
                            for (Integer i=27;i<allLines.size();i++)
                            {   
                                String[] inputvalues = new String[]{};
                                inputvalues = allLines[i].split(',');
                                KT_Tracker__c kt = new KT_Tracker__c();
                    
                                if(inputvalues.size() != 0)
                                {
                                    integer temp=inputvalues.size();
                                    if(temp>=1)
                                    {
                                        if(inputvalues[0] !=null && inputvalues[0] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                             kt.SOW_Ref__c= inputvalues[0];
                                        }
                                    }
                                    if(temp>=2)
                                    {
                                        if(inputvalues[1] !=null && inputvalues[1] !=UTIL_Constants.EMPTY_STRING)
                                        {
                                            kt.Process__c = inputvalues[1];
                                        }
                                    }
                                    if(temp>=3)
                                    {
                                        if(inputvalues[2] !=null && inputvalues[2] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            kt.Sub_Process__c= inputvalues[2];
                                        }
                                    }
                                    if(temp>=4)
                                    {
                                        if(inputvalues[3] !=null && inputvalues[3] !=UTIL_Constants.EMPTY_STRING)
                                        {
                                           kt.Tasks__c= inputvalues[3];
                                        }
                                    }
                                    if(temp>=5)
                                    {
                                        if(inputvalues[4] !=null && inputvalues[4] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            kt.Comments__c= inputvalues[4];
                                        }
                                    }
                                    if(temp>=6)
                                    {
                                   
                                        if(inputvalues[5] !=null && inputvalues[5] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            kt.WD__c= inputvalues[5];
                                        }
                                    }
                                    /*
                                    if(temp>=7)
                                    {

                                        if(inputvalues[6] !=null && inputvalues[6] !='')
                                        { 
                                        //Decimal timeTaken = decimal.valueOf(inputvalues[6])*100;
                                            kt.Time_taken_to_complete_month__c=decimal.valueOf(inputvalues[6]);//timeTaken ;
                                        }
                                    } */
                                    if(temp>=7)
                                    {
                                        if(inputvalues[6] !=null && inputvalues[6] !=UTIL_Constants.EMPTY_STRING && inputvalues[6] !=UTIL_Constants.ZERO)
                                        { 
                                            kt.Round_to__c= decimal.valueOf(inputvalues[6]);
                                        }
                                    }
                                    if(temp>=8)
                                    {
                                        if(inputvalues[7] !=null && inputvalues[7] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            kt.Time_taken_to_complete_Hours__c = decimal.valueOf(inputvalues[7]);                 
                                        }
                                    }
                                    if(temp>=9)
                                    {
                                        if(inputvalues[8] !=null && inputvalues[8] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            kt.Frequency__c= inputvalues[8]; 
                                        }
                                    }                                   
                                    if(temp>=10)
                                    {
                                        if(inputvalues[9] !=null && inputvalues[9] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            kt.Applications_Used__c = inputvalues[9]; 
                                        }
                                    }
                                    if(temp>=11)
                                    {                           
                                        if(inputvalues[10] !=null && inputvalues[10] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            kt.Accenture_Post_KT_completion__c = inputvalues[10]; //This filed belongs to KT Approach
                                        }
                                    }
                                    if(temp>=12)
                                    {                           
                                        if(inputvalues[11] !=null && inputvalues[11] !=UTIL_Constants.EMPTY_STRING)
                                        {
                                            kt.Client_SME__c = inputvalues[11];
                                        }
                                    }
                                    if(temp>=13)
                                    {
                                        if(inputvalues[12] !=null && inputvalues[12] !=UTIL_Constants.EMPTY_STRING)
                                        {
                                            kt.Accenture_Trainee__c = inputvalues[12];
                                        }
                                    }
                                    if(temp>=14)
                                    {
                                        if(inputvalues[13] !=null && inputvalues[13] !=UTIL_Constants.EMPTY_STRING && inputvalues[13] != UTIL_Constants.ZERO)
                                        { 

                                            kt.Estimate_hours_required_KT_traini__c = decimal.valueOf(inputvalues[13]);
                                        }
                                    }
                                     if(temp>=15)
                                    {                           
                                        if(inputvalues[14] !=null && inputvalues[14] !=UTIL_Constants.EMPTY_STRING )
                                        { 
                                            kt.GATE_1__c =decimal.valueOf(inputvalues[14]);
                                        }
                                    }
                                   if(temp>=16)
                                    {
                                        if(inputvalues[15] !=null && inputvalues[15] !=UTIL_Constants.EMPTY_STRING && inputvalues[15] !=UTIL_Constants.ZERO)
                                        { 
                                            kt.Gate_1_Weighted_Average__c = decimal.valueOf(inputvalues[15]);
                                        }
                                    }
                                    if(temp>=17)
                                    {                           
                                        if(inputvalues[16] !=null && inputvalues[16] !=UTIL_Constants.EMPTY_STRING)
                                        {
                                            kt.Gate_2__c = decimal.valueOf(inputvalues[16]);
                                        }
                                    }
                                    if(temp>=18)
                                    {                           
                                        if(inputvalues[17] !=null && inputvalues[17] !=UTIL_Constants.EMPTY_STRING && inputvalues[17] !=UTIL_Constants.ZERO)
                                        {
                                            kt.Gate_2_Weighted_Average__c = decimal.valueOf(inputvalues[17]);
                                        }
                                    }
                                    if(temp>=19)
                                    {
                                        if(inputvalues[18] !=null && inputvalues[18] !=UTIL_Constants.EMPTY_STRING)
                                        {
                                            kt.GATE_3__c = decimal.valueOf(inputvalues[18]);
                                        }
                                    }
                                    if(temp>=20)
                                    {
                                        if(inputvalues[19] !=null && inputvalues[19] !=UTIL_Constants.EMPTY_STRING && inputvalues[19] !=UTIL_Constants.ZERO)
                                        { 
                                            kt.Gate_3_Weighted_Average__c= decimal.valueOf(inputvalues[19]);
                                        }
                                    }
                                    if(temp>=21)
                                    {                           
                                        if(inputvalues[20] !=null && inputvalues[20] !=UTIL_Constants.EMPTY_STRING && inputvalues[20] !=UTIL_Constants.ZERO)
                                        { 
                                            kt.Weighted_Complete__c= decimal.valueOf(inputvalues[20]);
                                        }
                                    }
if((inputvalues.size() >= 1 && inputvalues[0] !=UTIL_Constants.EMPTY_STRING )|| 
(inputvalues.size() >= 2 && inputvalues[1] !=UTIL_Constants.EMPTY_STRING) || 
(inputvalues.size() >= 3 && inputvalues[2] !=UTIL_Constants.EMPTY_STRING) || 
(inputvalues.size() >= 4 && inputvalues[3] !=UTIL_Constants.EMPTY_STRING) || 
(inputvalues.size() >= 5 && inputvalues[4] !=UTIL_Constants.EMPTY_STRING) || 
(inputvalues.size() >= 6 && inputvalues[5] !=UTIL_Constants.EMPTY_STRING) || 
(inputvalues.size() >= 7 && inputvalues[6] !=UTIL_Constants.EMPTY_STRING && inputvalues[6] !=UTIL_Constants.ZERO) || 
(inputvalues.size() >= 8 && inputvalues[7] !=UTIL_Constants.EMPTY_STRING) || 
(inputvalues.size() >= 9 && inputvalues[8] !=UTIL_Constants.EMPTY_STRING) || 
(inputvalues.size() >= 10 && inputvalues[9] !=UTIL_Constants.EMPTY_STRING) || 
(inputvalues.size() >= 11 && inputvalues[10] !=UTIL_Constants.EMPTY_STRING) || 
(inputvalues.size() >= 12 && inputvalues[11] !=UTIL_Constants.EMPTY_STRING) || 
(inputvalues.size() >= 13 && inputvalues[12] !=UTIL_Constants.EMPTY_STRING) || 
(inputvalues.size() >= 14 && inputvalues[13] !=UTIL_Constants.EMPTY_STRING && inputvalues[13] !=UTIL_Constants.ZERO) || 
(inputvalues.size() >= 15 && inputvalues[14] !=UTIL_Constants.EMPTY_STRING) || 
(inputvalues.size() >= 16 && inputvalues[15] !=UTIL_Constants.EMPTY_STRING && inputvalues[15] !=UTIL_Constants.ZERO) || 
(inputvalues.size() >= 17 && inputvalues[16] !=UTIL_Constants.EMPTY_STRING) || 
(inputvalues.size() >= 18 && inputvalues[17] !=UTIL_Constants.EMPTY_STRING && inputvalues[17] !=UTIL_Constants.ZERO) || 
(inputvalues.size() >= 19 && inputvalues[18] !=UTIL_Constants.EMPTY_STRING) ||
(inputvalues.size() >= 20 && inputvalues[19] !=UTIL_Constants.EMPTY_STRING && inputvalues[19] !=UTIL_Constants.ZERO) || 
(inputvalues.size() >= 21 && inputvalues[20] !=UTIL_Constants.EMPTY_STRING && inputvalues[20] !=UTIL_Constants.ZERO) || 
(inputvalues.size() >= 22 && inputvalues[21] !='')){                     

                                    isRecordExist=true;
                                    kt.Deal_Wave__c = waveId;                                    
                                    ktTracker.add(kt);
                                    isInserted=true;
                               }  
                                }
                       
                            }
                            if(isRecordExist==false){
                                count=0;
                                fileFullData = UTIL_Constants.EMPTY_STRING ;
                                uploadFileAtt = UTIL_Constants.EMPTY_STRING;
                                dropFileName = UTIL_Constants.EMPTY_STRING;                               
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.CANNOT_UPLOAD_EMPTY_SHEET_WITHOUT_DATA));
                                
                                flagImage=false;
                                return;
                            }
                            /* Delete the Object Data */ 
                            if(isInserted==true)      
                            {
                      
                                /* Delete the Object Data */
                                if(fileFullData != uploadFileAtt)
                                {
                                    list<KT_Tracker__c> DeleteList = [select Id from KT_Tracker__c where Deal_Wave__c =:waveId limit 5000];  
                                    if(DeleteList.size()>0)
                                    {
                                        delete DeleteList;
                                    }                           
                                }
                                insert ktTracker;    
                                isDone=true;                                
                            }
                        }
                    }
                }
            }
            catch (Exception e)
            {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,''+e));
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_UPLOADING_FILE+e));
                Database.rollback(sp);
                fileFullData = UTIL_Constants.EMPTY_STRING ;
                uploadFileAtt = UTIL_Constants.EMPTY_STRING;
                dropFileName = UTIL_Constants.EMPTY_STRING;
                flagImage=false;
                return;
            }
            
            //////////////////////////////////////
            
            try
            {
                if(fileFullDataSheet2 !=null && fileFullDataSheet2 != UTIL_Constants.EMPTY_STRING)
                {
                    if(uploadFileAtt !=null && uploadFileAtt!=UTIL_Constants.EMPTY_STRING)
                    {
                        dtTracker = new List<DTP_Tracker__c>();
                        Integer pivot = fileFullDataSheet2.indexOf( UTIL_Constants.BACK_R, Integer.valueOf(Math.floor(fileFullDataSheet2.length() / 2)) );
                        if ( pivot > inputCharacterMax ) 
                        {
                            divideString(fileFullDataSheet2);
                        }
                        else 
                        {
                            allLines = fileFullDataSheet2.split(UTIL_Constants.BACK_N);
                        }
                        if(allLines.size() != 0)
                        {                         
                            for (Integer i=10;i<allLines.size();i++)
                            {
                                String[] dtInputvalues = new String[]{};
                                dtInputvalues = allLines[i].split(UTIL_Constants.COMMA_STRING);
                                DTP_Tracker__c dt = new DTP_Tracker__c();
                            
                            if(dtInputvalues.size() != 0)
                                {
                                    integer temp=dtInputvalues.size();
                                    if(temp>=1)
                                    {
                                        if(dtInputvalues[0] !=null && dtInputvalues[0] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            dt.SOW_Ref__c = dtInputvalues[0];
                                        }
                                    }
                                    if(temp>=2)
                                    {
                                        if(dtInputvalues[1] !=null && dtInputvalues[1] !=UTIL_Constants.EMPTY_STRING)
                                        {
                                            dt.Process__c = dtInputvalues[1];
                                        }
                                    }
                                    if(temp>=3)
                                    {
                                        if(dtInputvalues[2] !=null && dtInputvalues[2] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            dt.Sub_Process__c  = dtInputvalues[2];
                                        }
                                    }
                                    if(temp>=4)
                                    {
                                        if(dtInputvalues[3] !=null && dtInputvalues[3] !=UTIL_Constants.EMPTY_STRING)
                                        {
                                           dt.DTP_File_Name__c = dtInputvalues[3];
                                        }
                                    }
                                    if(temp>=5)
                                    {
                                        if(dtInputvalues[4] !=null && dtInputvalues[4] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            dt.SME_Name__c = dtInputvalues[4];
                                        }
                                    }
                                    if(temp>=6)
                                    {
                                        if(dtInputvalues[5] !=null && dtInputvalues[5] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            dt.Knowledge_Recipient__c = dtInputvalues[5];
                                        }
                                    }
                                    if(temp>=7)
                                    {
                                        if(dtInputvalues[6] !=null && dtInputvalues[6] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            dt.Date_of_Last_Approval__c = date.parse(dtInputvalues[6]);
                                        }
                                    }
                                    if(temp>=8)
                                    {
                                        if(dtInputvalues[7] !=null && dtInputvalues[7] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            dt.Date_Submitted_1__c = date.parse(dtInputvalues[7]);
                                        }
                                    }
                                    if(temp>=9)
                                    {
                                        if(dtInputvalues[8] !=null && dtInputvalues[8] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            dt.Owner_Next_Action_1__c = dtInputvalues[8];                 
                                        }
                                    }
                                    if(temp>=10)
                                    {
                                        if(dtInputvalues[9] !=null && dtInputvalues[9] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            dt.Version_0_1__c = dtInputvalues[9]; 
                                        }
                                    }
                                    if(temp>=11)
                                    {                           
                                        if(dtInputvalues[10] !=null && dtInputvalues[10] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            dt.Date_Submitted_2__c = date.parse(dtInputvalues[10]);
                                        }
                                    }
                                    if(temp>=12)
                                    {                           
                                        if(dtInputvalues[11] !=null && dtInputvalues[11] !=UTIL_Constants.EMPTY_STRING)
                                        {
                                            dt.Owner_Next_Action_2__c = dtInputvalues[11];
                                        }
                                    }
                                    if(temp>=13)
                                    {
                                        if(dtInputvalues[12] !=null && dtInputvalues[12] !=UTIL_Constants.EMPTY_STRING)
                                        {
                                            dt.Version_0_2__c = dtInputvalues[12];
                                        }
                                    }
                                    if(temp>=14)
                                    {
                                        if(dtInputvalues[13] !=null && dtInputvalues[13] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            dt.Date_Submitted_3__c = date.parse(dtInputvalues[13]);
                                        }
                                    }
                                    if(temp>=15)
                                    {                           
                                        if(dtInputvalues[14] !=null && dtInputvalues[14] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                            dt.Owner_Next_Action_3__c = dtInputvalues[14];
                                        }
                                    }
                                    if(temp>=16)
                                    {
                                        if(dtInputvalues[15] !=null && dtInputvalues[15] !=UTIL_Constants.EMPTY_STRING)
                                        { 
                                           dt.Version_0_3__c = dtInputvalues[15];
                                        }
                                    }
                                    if(temp>=17)
                                    {                           
                                        if(dtInputvalues[16] !=null && dtInputvalues[16] !=UTIL_Constants.EMPTY_STRING)
                                        {
                                            dt.Estimate_Date_to_Complete__c = dtInputvalues[16];
                                        }
                                    }
                                   
                                    dt.Deal_Wave__c = waveId ;
                                    dtTracker.add(dt);
                                    dtIsInserted=true;
                                }
                       
                            }
                   
                            /* Delete the Object Data */ 
                            if(dtIsInserted==true)      
                            {
                      
                                /* Delete the Object Data */
                                if(fileFullData != uploadFileAtt)
                                {
                                    list<DTP_Tracker__c> DeleteList = [select Id from DTP_Tracker__c where Deal_Wave__c =:waveId limit 5000]; 
                                    if(DeleteList.size()>0)
                                    {
                                        delete DeleteList;
                                    }                           
                                }
                                insert dtTracker;   
                                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File Multiple Tab Data uploaded successfully'));  
                                isDone=true;                                  
                            }
                        }
                    }
                }
            }
            catch (Exception e)
            {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,''+e));
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'+e));
                Database.rollback(sp);
                fileFullData = UTIL_Constants.EMPTY_STRING ;
                uploadFileAtt = UTIL_Constants.EMPTY_STRING;
                dropFileName = UTIL_Constants.EMPTY_STRING;
                flagImage=false;
                return;
            }
            
        }
        if(isDone==true)
        {
        List<Document> docForDelete = new List<Document>();
        try 
        { 
            //Document doc1 = new Document();
            //doc1.Name = fileName+'_'+System.now().format('EEEE, MMMM d, yyyy - hh-mm-ss');
            //doc1.type= 'xlsx';
            //doc1.FolderId = [select id from folder where name = 'Recruitment Tracker'].id;    
            //doc1.Body = EncodingUtil.base64Decode(uploadFileAtt);
            //insert doc1;
            //displayfileName=doc1.name+'.'+doc1.type; 
            //fileId=doc1.id;
            if(trackRec.size()==1)
            {
                docForDelete =[Select name,Body,type,id from Document where name=:trackRec[0].File_Name__c];
                if(docForDelete.size()>0)
                {
                    //docForDelete[0].Name = fileName+'_'+System.now().format('EEEE, MMMM d, yyyy - hh-mm-ss');
                    docForDelete[0].Name = fileName;
                    docForDelete[0].Body = EncodingUtil.base64Decode(uploadFileAtt);
                    upsert docForDelete[0];                    
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.FILE_UPLOADED_SUCCESSFULLY)); 
                    displayfileName=docForDelete[0].name+UTIL_Constants.DOT+docForDelete[0].type; 
                    fileId=docForDelete[0].id;
                }
                trackRec[0].File_Name__c=docForDelete[0].name;
                trackRec[0].isDownload__c=false;
                trackRec[0].clickOnDownLoad__c=false;
                upsert(trackRec[0]);
                count=0;
                flagImage=false;
                isDone=false;
            }
        }  
        catch (DMLException e) 
        {  
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_UPLOADING_FILE+e));
            flagImage=false;            
            return;
        }
      /*  finally {  
         docForDelete[0].body = null; // clears the viewstate  
         //docForDelete[0]= new Document();      
         }   */
        disableUpload=true;
        disableDownload=false;
        flagImage=false;      
        return;  
    }
    }else{
    count=0;
    fileFullData = UTIL_Constants.EMPTY_STRING ;
    uploadFileAtt = UTIL_Constants.EMPTY_STRING;
    dropFileName = UTIL_Constants.EMPTY_STRING;
        return;
    }
}
    
    /******************************
    Method Name: divideString
    Description: This method is used to divide the input string  
    Paramenters: String
    Return Value: void
    *******************************/
    public void divideString(String input) 
    {
        Integer pivot = input.indexOf( UTIL_Constants.BACK_R, Integer.valueOf(Math.floor(input.length() / 2)) ); 
        String left = input.substring(0,pivot);
        String right = input.substring(pivot); 

        if ( pivot < inputCharacterMax ) 
        {
            // split left and right chunks, add to allLines
            filelinesLeft = left.split(UTIL_Constants.BACK_N);
            filelinesRight = right.split(UTIL_Constants.BACK_N);

            allLines.addAll(filelinesLeft);
            allLines.addAll(filelinesRight);
        }
        else
        {
            // divide and conquer!
            divideString(left);
            divideString(right);
        } 
    }
}