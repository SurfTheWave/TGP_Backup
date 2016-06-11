/*
Author : Varsha Chougule.
Story  : MOB_128  
Description : initiate tracking deal 

Updated by        Story no./Defect No.           Update Date        Update details
------------    -----------------------        --------------    -------------------------------------------------------------
Varsha Chougule      MOB_128  
Nilesh Adkar        MOB-016 / D-134            08-March-13            Only one wave plan version should be active for a deal
Nilesh Adkar        MOB-145                    16-Apr-13              Recruitmrnt tracking should have all mandatory field filled before initiating tracking.
Nilesh Adkar        MOB_053                    26-Apr-13              Tech Assessment planning should have all mandatory field filled before initiating tracking.

*/
public without sharing class Mob_Deal_Tracking_SectionController {
    public Wave_Plan_Version__c newWavePlanVersion{get;set;}
    public boolean visible1{get;set;}
    public boolean visibleCheckBox{get;set;}
    public boolean isVisible{get;set;}
    public boolean isVisible1{get;set;}
    public boolean disable{get;set;}
    public String buttonLabel{get;set;}
    public String pageId{get;set;}
    public PageReference pr{get;set;}
    public boolean checkBoxValue{get;set;}
    public Boolean refreshPage {get; set;}    
    public boolean isEditVisible{get;set;}
    public boolean isNA{get;set;}
    public String strDealId {get;set;}
    public String dtId {get;set;}
    public Deal_Track__c trackDeal = new Deal_Track__c();
    /******************************
    Method Name: Mob_Deal_Tracking_SectionController
    Description: This is Constructor for the Mob_Deal_Tracking_SectionController class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/ 
    public Mob_Deal_Tracking_SectionController(ApexPages.StandardController controller) 
    { 
        isEditVisible = true;
        isNA = true;
        newWavePlanVersion=(Wave_Plan_Version__c)controller.getRecord();
        List<Wave_Plan_Version__c> lstWave = [select deal__c from Wave_Plan_Version__c where id=:newWavePlanVersion.id];
        List<Deal_Track__c> dt = [Select Name From Deal_Track__c Where Wave_Plan_Version__c =:newWavePlanVersion.id limit 1];
        if(!dt.isEmpty() ) {
            dtId = dt[0].Id;
        }
        strDealId = lstWave.get(0).deal__C;
        pageId=ApexPages.CurrentPage().getParameters().get('id'); //Get the id of Current Wave Plan Version ID
        if(pageId == null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Invalid High Level Mobilization Plan ID!'));
        }
       
        
        //Tracking is not On: CheckBox is visible
        if(newWavePlanVersion.Display_tracking_message__c == 'Tracking is On')
        {
            visibleCheckBox=false;
            disable=false;
            isVisible=false;
            isVisible1=true;
        }//Tracking is on: CheckBox is inVisible
        else
        {
            visibleCheckBox=true;
            disable=true;
            isVisible=true;
            isVisible1=false;
        } 
        
        if(newWavePlanVersion.Display_tracking_message__c == null && newWavePlanVersion.active__c==true)
        {           
            isEditVisible = UAMSolMobUtility.isEditVisiblee_MobDealTracking;     
            if(UAMSolMobUtility.isNA_MobDealTracking)
            {
                isNA=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No priviledge. Please contact your administrator.'));
                return;
            }
            
        /*    UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckUserRole(strDealId,'Initiation of Deal Tracking');
    //        isAddVisible = m.get('C');
            isEditVisible= m.get('U');
            if(m.get('NA') || CheckProfile.isMobLeadershipProfile())
            {
                isNA=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No priviledge. Please contact your administrator.'));
            }  */     
        }
    }
    
     /******************************
    Method Name: InitiateTracking
    Description: Method to Initiate the tracking.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void InitiateTracking()
    {
            newWavePlanVersion.Display_tracking_message__c='Tracking is On';
            List<Wave_Plan_Version__c> lstWaveVersion = [select id,Deal__c, Deal__r.Name,Deal__r.Client_Name__r.id from Wave_Plan_Version__c where id=:pageId ];
            trackDeal = new Deal_Track__c();
            trackDeal.Name = 'Tracking '+lstWaveVersion.get(0).Deal__r.Name;
            trackDeal.Wave_Plan_Version__c = newWavePlanVersion.Id;
            trackDeal.Deal__c = lstWaveVersion.get(0).Deal__c;
            trackDeal.Client_Name__c = lstWaveVersion.get(0).Deal__r.Client_Name__r.id;            
            //To deactivate the tracking on other version
            if(lstWaveVersion.size()>0)
            {
                strDealId = lstWaveVersion.get(0).Deal__c; 
                List<Wave_Plan_Version__c> lstWaveVersionByDeal = [select id,Display_tracking_message__c from Wave_Plan_Version__c where Deal__c=:lstWaveVersion.get(0).Deal__c and Display_tracking_message__c='Tracking is On'];
                List<Wave_Plan_Version__c> lstWaveVersionByDealNew=new List<Wave_Plan_Version__c>();
                if(lstWaveVersionByDeal.size()>0)
                {
                    for(Wave_Plan_Version__c wave:lstWaveVersionByDeal)
                    {
                        wave.Display_tracking_message__c=null;
                        lstWaveVersionByDealNew.add(wave);
                    }
                    upsert lstWaveVersionByDealNew;     
                }                        
            }
            isVisible=false;
            isVisible1=true;
            insert trackDeal;
            newWavePlanVersion.Deal_Track__c = trackDeal.Id;
            update newWavePlanVersion;
            List<Deal_Location__c> listDealLocation=[select id,active__c from Deal_Location__c where Wave_Plan_Version__c=:newWavePlanVersion.id];
            List<Wave_Planning__c> listDealWave=[select id,Deal_Location__c,active__c from Wave_Planning__c];
            List<Deal_Location__c> lstDealLoc = new List<Deal_Location__c>();
            List<Wave_Planning__c> lstDealWave= new List<Wave_Planning__c>();
            if(listDealLocation.size()>0)
            {
                for(Deal_Location__c locList : listDealLocation)
                {
                    locList.active__c=false;
                    lstDealLoc.add(locList);                      
                    if(listDealWave.size()>0) 
                    {
                        for(Wave_Planning__c waveList : listDealWave)
                        {
                            if(waveList.Deal_Location__c ==locList.id)
                            {
                                waveList.active__c=false;
                                lstDealWave.add(waveList); 
                                //waveList.active__c=true;
                                //update waveList;    
                            }
                        }
                    }
                    //locList.active__c=true;
                    //update locList;
                }
                update lstDealLoc;
                update lstDealWave;
            }
            visibleCheckBox=false;
            refreshPage =true;
            return;
    }
    
    /******************************
    Method Name: ButtonEnable
    Description: Method to enable the Initiate Tracking Button when CheckBox is selected.  
    Paramenters: NA
    Return Value: void 
    *******************************/ 
    public void ButtonEnable()
    {
        if(checkBoxValue==true)//Enable the Initiate Tracking Button
        {
            /*List<Wave_Plan_Version__c> lstWaveVersion = [select id,Deal__c from Wave_Plan_Version__c where id=:pageId ];
            if(lstWaveVersion.size()>0)
            {
                List<Wave_Plan_Version__c> lstWaveVersionByDeal = [select id,Display_tracking_message__c from Wave_Plan_Version__c where Deal__c=:lstWaveVersion.get(0).Deal__c and Display_tracking_message__c='Tracking is On'];
                if(lstWaveVersionByDeal.size()>0)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Initiate trcking is already active on another version of the same deal.'));  
                    return;          
                }                        
            }*/
                
            disable=false;
            List<Recruitment_Tracking__c> lstWPVRecruitTracking = [select id, active__c, Planned_Start_Date__c, Planned_End_Date__c from Recruitment_Tracking__c where Wave_Plan_Version__c= :pageId ];
            if(lstWPVRecruitTracking.size()>0)
            {
                for(Recruitment_Tracking__c tmpRecruit : lstWPVRecruitTracking)
                {
                    if((tmpRecruit.Planned_Start_Date__c==null || tmpRecruit.Planned_End_Date__c==null)&& tmpRecruit.active__c==true)
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter all the Planned Start Dates , Planned End Dates on active records in Recruitment tracking.'));  
                        disable=true;                        
                        return;          
                    }
                }
            }
            List<Tech_Assessment__c> lstWPVTechAssess = [select id, active__c, Planned_Start_Date__c, Planned_End_Date__c from Tech_Assessment__c where Wave_Plan_Version__c= :pageId ];
            if(lstWPVTechAssess.size()>0)
            {
                for(Tech_Assessment__c tmpTechAssess : lstWPVTechAssess)
                {
                    if((tmpTechAssess.Planned_Start_Date__c==null || tmpTechAssess.Planned_End_Date__c==null)&& tmpTechAssess.active__c==true)
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter all the Planned Start Dates , Planned End Dates on active records in Technology & Work Enablement planning.'));  
                        disable=true;                        
                        return;          
                    }
                }
            }
            List<KT_Planning__c> lstWPVKTPlan = [select id, active__c, Planned_Start_Date__c, Planned_End_Date__c from KT_Planning__c where Wave_Plan_Version__c= :pageId ];
            if(lstWPVKTPlan.size()>0)
            {
                for(KT_Planning__c tmpKTPlan: lstWPVKTPlan)
                {
                    if((tmpKTPlan.Planned_Start_Date__c==null || tmpKTPlan.Planned_End_Date__c==null)&& tmpKTPlan.active__c==true)
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter all the Planned Start Dates , Planned End Dates on active records in KT Planning.'));  
                        disable=true;                        
                        return;          
                    }
                }
            }
            List<Journey_Management_Planning__c> lstWPVJourney = [ select id, active__c, Planned_Start_Date__c, Planned_End_Date__c
                                                                   from Journey_Management_Planning__c 
                                                                   where Wave_Plan_Version__c= :pageId ];
            if(lstWPVJourney.size()>0)
            {
                for(Journey_Management_Planning__c tmpJourney: lstWPVJourney)
                {
                    if((tmpJourney.Planned_Start_Date__c==null || tmpJourney.Planned_End_Date__c==null)&& tmpJourney.active__c==true)
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter all the Planned Start Dates , Planned End Dates on active records in Journey Planning.'));  
                        disable=true;                        
                        return;          
                    }
                }
            }
            
             List<Business_Continuity_Planning__c> lstWPVbcp = [ select id, active__c, Planned_Start_Date__c, Planned_End_Date__c,Wave_Plan_Version__r.BCP__c
                                                                   from Business_Continuity_Planning__c 
                                                                   where Wave_Plan_Version__c= :pageId ];
            if(lstWPVbcp.size()>0)
            {
                for(Business_Continuity_Planning__c tmpJourney: lstWPVbcp)
                {
               if(tmpJourney.Wave_Plan_Version__r.BCP__c != 'Client Driven BCP'){ 
               if((tmpJourney.Planned_Start_Date__c==null || tmpJourney.Planned_End_Date__c==null)&& tmpJourney.active__c==true && tmpJourney.Wave_Plan_Version__r.BCP__c!='Not Applicable')
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter all the Planned Start Dates , Planned End Dates on active records in Business Continuity Planning.'));  
                        disable=true;                        
                        return;          
                    }
                }
                }
            }
            
            
            List<Service_Management__c> lstSERJourney = [ select id, active__c, Planned_Start_Date__c, Planned_End_Date__c
                                                                   from Service_Management__c 
                                                                   where Wave_Plan_Version__c= :pageId ];
            if(lstSERJourney.size()>0)
            {
                for(Service_Management__c tmpService: lstSERJourney)
                {
                    if((tmpService.Planned_Start_Date__c==null || tmpService.Planned_End_Date__c==null)&& tmpService.active__c==true)
                    {
                        
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter all the Planned Start Dates , Planned End Dates on active records in Service Management.'));  
                        disable=true;                        
                        return;          
                    }
                }
            }
            List<Commercial_Planning__c> lstWPVCommerce = [ select id, active__c, Planned_Start_Date__c, Planned_End_Date__c
                                                                   from Commercial_Planning__c
                                                                   where Wave_Plan_Version__c= :pageId ];
            if(lstWPVCommerce.size()>0)
            {
                for(Commercial_Planning__c tmpCommerce : lstWPVCommerce)
                {
                    if((tmpCommerce.Planned_Start_Date__c==null || tmpCommerce.Planned_End_Date__c==null)&& tmpCommerce.active__c==true)
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter all the Planned Start Dates , Planned End Dates on active records in Commercial Planning.'));  
                        disable=true;                        
                        return;          
                    }
                }
            }
            List<Contract_Legal_Infosec__c> lstWPVContract = [ select id, active__c, Planed_Start_Date__c, Planned_End_Date__c,Responsibility__c
                                                                   from Contract_Legal_Infosec__c
                                                                   where Wave_Plan_Version__c= :pageId ];
            if(lstWPVContract.size()>0)
            {
                for(Contract_Legal_Infosec__c tmpContract : lstWPVContract)
                {
                    if((tmpContract.Planed_Start_Date__c==null || tmpContract.Planned_End_Date__c==null || tmpContract.Responsibility__c==null )&& tmpContract.active__c==true)
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter all the Planned Start Dates , Planned End Dates on active records in Contract Legal Infosec.'));  
                        disable=true;                        
                        return;          
                    }
                }
            }
        }
        else if(checkBoxValue==false)//Disable the Initiate Tracking Button
        disable=true;
  
        return;
    }
    
    /******************************
    Method Name: getDealtrack
    Description: Method to Open Deal Track screen.  
    Paramenters: NA
    Return Value: PageReference
    *******************************/ 
    public PageReference getDealtrack()
    {
       //PageReference pg=new PageReference('/apex/Mob_Deal_Track?id='+pageId);
        PageReference pg;
        if(trackDeal.Id != null) {
            pg=new PageReference('/'+trackDeal.Id);
        }
        else if(dtId != null){
            pg=new PageReference('/'+dtId);
        }
        else {
            pg=new PageReference('home/home.jsp');
        }
        pg.SetRedirect(true);
        return pg;    
    }
}