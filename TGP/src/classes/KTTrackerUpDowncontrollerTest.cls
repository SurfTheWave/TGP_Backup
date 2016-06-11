/**
Author : Vinay Kumar Chada
Story  : 
Description : Test Class for TechAssessmentUpDowncontrollerTest. 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
@isTest(SeeAlldata= true)
private class KTTrackerUpDowncontrollerTest{
static Tracking_KT__c techTracking;
static Document doc;

static Client_Specific_Process_Mapping__c clientSpecificProcessMapping;
static Offerings_Master__c offering;
static Wave_Plan_Version__c wavePlanVersion;
static Deal_TGP__c deal;
static Wave_Planning__c waveplan;
static Wave_Process__c WaveProcess;
static Deal_Location__c dealLoc;
static Deal_Home_Location__c dealHome;
static Delievery_Location_Master__c deliveryLocMa;
static Client_Geo_Area_Master__c clientGeo;

static Commercial_Planning__c comPlan;
static Document newDocument;

public static void setupData(){



clientGeo = new Client_Geo_Area_Master__c();
clientGeo.Client_Geo_Area_Description__c='TestData';
insert clientGeo;

// To create a Delivery Location Master
deliveryLocMa =new Delievery_Location_Master__c();
deliveryLocMa.Delivery_Location_Description__c='testdata';
deliveryLocMa.Name='TestData';
deliveryLocMa.Client_Geo_Area_Master__c=clientGeo.id;
insert deliveryLocMa;

// To create a Deal
deal =new Deal_TGP__c();
deal.Name='Test Data';
insert deal;

// To create a offering
offering =new Offerings_Master__c();
offering.Name='Test Data';
insert offering;

//To create a Wave Plan Version
wavePlanVersion =new Wave_Plan_Version__c();
wavePlanVersion.Display_tracking_message__c='Test Data';
wavePlanVersion.Deal__c=deal.id;
insert wavePlanVersion;

// To create a Deal Home Location
dealHome =new Deal_Home_Location__c(); 
dealHome.Delivery_Location_Master__c=deliveryLocMa.id;
dealHome.Deal__c= deal.id;
insert dealHome;


// To create a Deal Location
dealLoc= new Deal_Location__c();
dealLoc.Location__c='test Data';
dealLoc.Deal_Home_Location__c=dealHome.id;
dealLoc.Wave_Plan_Version__c=wavePlanVersion.id;
insert dealLoc;

// To Create Client Specific Process Mapping

clientSpecificProcessMapping = new Client_Specific_Process_Mapping__c();
clientSpecificProcessMapping.Name='TestData';
clientSpecificProcessMapping.Deal__c=deal.id;
clientSpecificProcessMapping.Offering__c=offering.id;
insert clientSpecificProcessMapping;

//To create a Wave Plan

waveplan =new Wave_Planning__c();
waveplan.Wave_Comment__c='test data';
waveplan.Wave_Label__c='TestData';
waveplan.GO_Live_Date_del__c=date.today()+7;
waveplan.Deal_Location__c=dealLoc.id;
waveplan.Number_of_Projected_FTEs__c=1;
insert waveplan; 

// To create a Wave Process

WaveProcess =new Wave_Process__c();
WaveProcess.Wave_Planning__c=waveplan.id;
WaveProcess.Client_Specific_Process_Mapping__c=clientSpecificProcessMapping.id;
insert WaveProcess;

techTracking = new Tracking_KT__c();
techTracking.File_Name__c='KT Tracker';
techTracking.isDownload__c=true;
techTracking.clickOnDownLoad__c=true;
techTracking.File_Downloader_User_Name__c='Vinay Chada';
techTracking.Deal_Wave__c=waveplan.id;
insert techTracking;

doc = new Document();
doc.name='KT Tracker';
doc.Body = Blob.valueOf('AAC0811EST022916_Quotation.xlsx');
doc.type='xlsx';
doc.AuthorId = UserInfo.getUserId();
 LIST<FOLDER> fol = [SELECT ID,NAME FROM FOLDER WHERE NAME = 'Shared Documents' and type = 'document'];
if(fol.size() > 0)
doc.FolderId = fol[0].id;
else
doc.FolderId = UserInfo.getUserId();
doc.IsPublic = true;
insert doc;

}

public static void setupData1(){

techTracking = new Tracking_KT__c();
techTracking.File_Name__c='KT Tracker';
techTracking.isDownload__c=false;
techTracking.clickOnDownLoad__c=false;
//techTracking.Deal_Wave__c=waveplan.id;
techTracking.File_Downloader_User_Name__c='Vinay Chada';
insert techTracking;

}


public static void setupData2(){

doc = new Document();
doc.name='KT Tracker';
doc.Body = Blob.valueOf('AAC0811EST022916_Quotation.xlsx');
doc.type='xlsx';
doc.AuthorId = UserInfo.getUserId();
 LIST<FOLDER> fol = [SELECT ID,NAME FROM FOLDER WHERE NAME = 'Shared Documents' and type = 'document'];
if(fol.size() > 0)
doc.FolderId = fol[0].id;
else
doc.FolderId = UserInfo.getUserId();
doc.IsPublic = true;
insert doc;

}
static testMethod void test1(){ 
    test.starttest();
    
    setupData();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('Id' ,waveplan.id); 
    KTTrackerUpDowncontroller tTracker = new KTTrackerUpDowncontroller( controller);
    tTracker.DownloadFile();
    tTracker.actionYes();
    tTracker.actionNo();
    tTracker.UploadFile(); 
        
    test.stoptest();
    }
    
    static testMethod void test2(){ 
    test.starttest();
    
    setupData1();
    setupData2();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('Id' ,null); 
    KTTrackerUpDowncontroller  tTracker = new KTTrackerUpDowncontroller ( controller);

    tTracker.count=1;   
    tTracker.fileFullData='SHEET: KT Tracker'+'\n'
                            +'Test Data'+'\n'
                            +',,,1,,,0.2,1,2,,,,,Total,2,20,20,30,30,80,80,36'+'\n'
                            +'SOW Ref,Process,Sub-Process,Tasks,Comments,WD,% of time taken to complete ea. Activity (per month),Round to 100%'+'\n'
                            +'(Calculated),EnterTime taken to complete activity (Actual Hours),Frequency (Y, Q, M, W, D, Ad Hoc),Activities that can aid assessing Accenture trainee proficiency post KT completion,Applications Used,Client SME,Accenture Trainee,Estimate of hours required for KT training'+'\n'
                            +'(Calculated),40%'+'\n'
                            +'GATE 1  '+'\n'
                            +'30% - Concept & Observation'+'\n'
                            +'20% - Notes Submitted for Review'+'\n'
                            +'50% - Draft Documentation and Submit for Review,Gate 1 Weighted Average'+'\n'
                            +'(Calculated),40%'+'\n'
                            +'GATE 2'+'\n'
                            +'50% - Performed w/documentation & Support'+'\n'
                            +'20% - Modify DTP'+'\n'
                            +'30% DTP Submitted for Approval,Gate 2 Weighted Average'+'\n'
                            +'(Calculated),20%'+'\n'
                            +'GATE 3'+'\n'
                            +' 80%  - Performed with limited Support'+'\n'
                            +'20% - DTP Approved,Gate 3 Weighted Average'+'\n'
                            +'(Calculated),Weighted'+'\n'
                            +'% Complete'+'\n'
                            +'% Complete'+'\n'
                            +'% Complete'+'\n'
                            +'% Complete'+'\n'
                            +'% Complete'+'\n'
                            +'% Complete'+'\n'
                             +'% Complete'+'\n'                          
                            +'testdata,process1,sub-p2,test,test,t,1,2,Quarterly,t,Client Led KT,cs2,Accenture R2,7,30,30,50,50,80,80,48';
    tTracker.fileFullDataSheet2='SHEET: DTP Tracker'+'\n'
                                +'TestDAta'+'\n'
                                +',,,,,,Date format should be MM/DD/YY,Date format should be MM/DD/YY,,,Date format should be MM/DD/YY,,,Date format should be MM/DD/YY,,,'+'\n'
                                +'SOW Ref,Process,Sub Process,Task / DTP File Name,SME Name,Knowledge Recipient (KR),Date of Last Approval,Date Submitted,Owner'+'\n'
                                +'Next'+'\n'
                                +'Action,Version 0.1,Date Submitted,Owner'+'\n'
                                +'Next'+'\n'
                                +'Action,Version 0.2,Date Submitted,Owner'+'\n'
                                +'Next'+'\n'
                                +'Action,Version 1.0,Estimate Date to Complete'+'\n'
                                +'Test 2,process1,sub-p3,task2,SME Name,kt,06/06/78,06/05/12,SME,In Draft,05/05/13,ACN,yes,06/05/13,Supervisor,In Draft,In Draft';                      
    tTracker.uploadFileAtt='test';
    tTracker.dropFileName='TechAssessment Tracker.xlsx';

    tTracker.DownloadFile();
    tTracker.actionYes();
    tTracker.actionNo();
    tTracker.UploadFile();
    
    test.stoptest();
    }
    
    static testMethod void test3(){ 
    test.starttest();
    
    setupData1();
   // setupData2();
    ApexPages.StandardController controller;
    apexpages.currentpage().getparameters().put('Id' ,null); //waveplan.id
    KTTrackerUpDowncontroller tTracker = new KTTrackerUpDowncontroller( controller);
    //tTracker.waveId=waveplan.id;
    tTracker.fileFullData='SHEET: KT Tracker'+'\n'
                            +'Test Data'+'\n'
                            +',,,1,,,0.2,1,2,,,,,Total,2,20,20,30,30,80,80,36'+'\n'
                            +'SOW Ref,Process,Sub-Process,Tasks,Comments,WD,% of time taken to complete ea. Activity (per month),Round to 100%'+'\n'
                            +'(Calculated),EnterTime taken to complete activity (Actual Hours),Frequency (Y, Q, M, W, D, Ad Hoc),Activities that can aid assessing Accenture trainee proficiency post KT completion,Applications Used,Client SME,Accenture Trainee,Estimate of hours required for KT training'+'\n'
                            +'(Calculated),40%'+'\n'
                            +'GATE 1  '+'\n'
                            +'30% - Concept & Observation'+'\n'
                            +'20% - Notes Submitted for Review'+'\n'
                            +'50% - Draft Documentation and Submit for Review,Gate 1 Weighted Average'+'\n'
                            +'(Calculated),40%'+'\n'
                            +'GATE 2'+'\n'
                            +'50% - Performed w/documentation & Support'+'\n'
                            +'20% - Modify DTP'+'\n'
                            +'30% DTP Submitted for Approval,Gate 2 Weighted Average'+'\n'
                            +'(Calculated),20%'+'\n'
                            +'GATE 3'+'\n'
                            +' 80%  - Performed with limited Support'+'\n'
                            +'20% - DTP Approved,Gate 3 Weighted Average'+'\n'
                            +'(Calculated),Weighted'+'\n'
                            +'% Complete'+'\n'
                            +'% Complete'+'\n'
                            +'% Complete'+'\n'
                            +'% Complete'+'\n'
                            +'% Complete'+'\n'
                            +'% Complete'+'\n'  
                             +'% Complete'+'\n'                        
                            +'testdata,process1,sub-p2,test,test,t,1,2,Quarterly,t,Client Led KT,cs2,Accenture R2,7,30,30,50,50,80,80,48';
    tTracker.fileFullDataSheet2='SHEET: DTP Tracker'+'\n'
                                +'TestDAta'+'\n'
                                +',,,,,,Date format should be MM/DD/YY,Date format should be MM/DD/YY,,,Date format should be MM/DD/YY,,,Date format should be MM/DD/YY,,,'+'\n'
                                +'SOW Ref,Process,Sub Process,Task / DTP File Name,SME Name,Knowledge Recipient (KR),Date of Last Approval,Date Submitted,Owner'+'\n'
                                +'Next'+'\n'
                                +'Action,Version 0.1,Date Submitted,Owner'+'\n'
                                +'Next'+'\n'
                                +'Action,Version 0.2,Date Submitted,Owner'+'\n'
                                +'Next'+'\n'
                                +'Action,Version 1.0,Estimate Date to Complete'+'\n'
                                +'Test 2,process1,sub-p3,task2,SME Name,kt,06/06/78,06/05/12,SME,In Draft,05/05/13,ACN,yes,06/05/13,Supervisor,In Draft,In Draft';
    tTracker.uploadFileAtt='test';
    tTracker.dropFileName='TechAssessment Tracker.xlsx';

    tTracker.DownloadFile();
    tTracker.actionYes();
    tTracker.actionNo();
    tTracker.UploadFile();
    
    test.stoptest();
    }
}