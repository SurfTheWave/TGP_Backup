/*
Author : Varsha Chougule.
Story  : MOB_132_b 
Description : Overring edit button on Deal Location with visualforce page

Updated by        Story no./Defect No.           Update Date        Update details
------------    -----------------------        --------------    -------------------------------------------------------------
Varsha Chougule      MOB_132_a                 4/8/2013


*/

public with sharing class Mob_editButtonOverideLocationController {

    ApexPages.StandardController m_SC=null;
    public String strDealLocId {get;set;}
    public boolean isFormVisible {get;set;}
    private final Deal_Location__c DealLocRec;
    public Boolean isAddVisible{get;set;}
    public Boolean isWaveVersionActive{get; set;}
    public boolean isNA {get;set;}
    /******************************
    Method Name: Mob_editButtonOverideLocationController 
    Description: This is Constructor for the Mob_editButtonOverideLocationController class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/
    public Mob_editButtonOverideLocationController(ApexPages.StandardController controller) 
    {
        isNA=true;
        isAddVisible = true;
        isWaveVersionActive=true;
        isFormVisible = true;
        DealLocRec = (Deal_Location__c)Controller.getRecord();
        strDealLocId = DealLocRec.id;
        m_SC=  controller;
        List<Deal_Location__c> lstDealLoc = [select id,cloned_from__c from Deal_Location__c where cloned_from__c =:strDealLocId];
        if(lstDealLoc.size()>0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.VERSION_EXISTS));            
            isFormVisible = false;
            return;                
        }    
        isAddVisible = UAMSolMobUtility.isAddVisible_DealLoc;
        isWaveVersionActive = UAMSolMobUtility.isWaveVersionActive_DealLoc;
        
        if(UAMSolMobUtility.isNA_DealLoc)
        {
            isNA=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.NO_PRIVILEGE_PLEASE_CONTACT_YOUR_ADMINISTRATOR));
            return;
        }          
    }
    
     /******************************
    Method Name: doSave
    Description:This method is used to save the record.
    Paramenters: NA
    Return Value: pagereference 
    *******************************/
    public PageReference doSave()
    {
        try
        {
            List<Deal_Location__c> lstDealLoc = [select cloned_from__c,Deployment_Lead_New__c,Deployment_Lead_New__r.SFDC_User__c,
                                                    Location_Mobilization_Lead_Secondary_New__c,Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c,
                                                    Location_Mobilization_Lead_Secondary_2__c, Location_Mobilization_Lead_Secondary_2__r.SFDC_User__c,                                                     
                                                    Mob_Recruitment_Lead_Primary_New__c,Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c,
                                                    Mob_Recruitment_Lead_Secondary_New__c,Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c,
                                                    Mob_Recruitment_Lead_Secondary_New_2__c,Mob_Recruitment_Lead_Secondary_New_2__r.SFDC_User__c                                                    
                                                    from Deal_Location__c where cloned_from__c =:strDealLocId];
           if(lstDealLoc.size()>0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.VERSION_EXISTS));            
                return null;                
            }
            if(DealLocRec.Deployment_Lead_New__c != null && (DealLocRec.Location_Mobilization_Lead_Secondary_New__c != null || DealLocRec.Location_Mobilization_Lead_Secondary_2__c != null))
            {
                if(DealLocRec.Deployment_Lead_New__c == DealLocRec.Location_Mobilization_Lead_Secondary_New__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.LOC_MOB_PRIMARY_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null;
                }
                if(DealLocRec.Deployment_Lead_New__c == DealLocRec.Location_Mobilization_Lead_Secondary_2__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.LOC_MOB_PRIMARY_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null;
                }
                if(DealLocRec.Location_Mobilization_Lead_Secondary_New__c == DealLocRec.Location_Mobilization_Lead_Secondary_2__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.LOC_MOB_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null;
                }  
            }
            else if(DealLocRec.Location_Mobilization_Lead_Secondary_New__c != null && DealLocRec.Location_Mobilization_Lead_Secondary_2__c != null)
            {
                if(DealLocRec.Location_Mobilization_Lead_Secondary_New__c == DealLocRec.Location_Mobilization_Lead_Secondary_2__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.LOC_MOB_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null;
                } 
            }            
             
            if(DealLocRec.Mob_Recruitment_Lead_Primary_New__c != null && (DealLocRec.Mob_Recruitment_Lead_Secondary_New__c != null || DealLocRec.Mob_Recruitment_Lead_Secondary_New_2__c != null))
            {
                if(DealLocRec.Mob_Recruitment_Lead_Primary_New__c == DealLocRec.Mob_Recruitment_Lead_Secondary_New__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.MOB_RECRUITMENT_PRIMARY_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null; 
                }
               if(DealLocRec.Mob_Recruitment_Lead_Primary_New__c == DealLocRec.Mob_Recruitment_Lead_Secondary_New_2__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.MOB_RECRUITMENT_PRIMARY_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null; 
                }
               if(DealLocRec.Mob_Recruitment_Lead_Secondary_New__c == DealLocRec.Mob_Recruitment_Lead_Secondary_New_2__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.MOB_RECRUITMENT_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null; 
                }                 
            }
            else if(DealLocRec.Mob_Recruitment_Lead_Secondary_New__c != null && DealLocRec.Mob_Recruitment_Lead_Secondary_New_2__c != null)
             {
                 if(DealLocRec.Mob_Recruitment_Lead_Secondary_New__c == DealLocRec.Mob_Recruitment_Lead_Secondary_New_2__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.MOB_RECRUITMENT_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null; 
                }          
             }           
            return m_SC.save();
        }
        catch(Exception ex) {
            if(ex.getmessage().containsIgnoreCase('Insufficient')){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.INSUFFICIENT_PRIVILAGE));
            }   
            else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));    
            }            
            return null;
        }
    }
    
     /******************************
    Method Name: doCancel
    Description:This method is used to cancel the edit record page.
    Paramenters: NA
    Return Value: pagereference 
    *******************************/
    public PageReference doCancel()
    {
        return m_SC.cancel();
    }
}