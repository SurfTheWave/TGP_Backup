/*
Author : Varsha Chougule.
Story  : MOB_132_b 
Description : Overring edit button on Deal Wave with visualforce page

Updated by        Story no./Defect No.           Update Date        Update details
------------    -----------------------        --------------    -------------------------------------------------------------
Varsha Chougule      MOB_132_a                 4/8/2013


*/

public with sharing class Mob_editButtonOverideWaveController {

ApexPages.StandardController m_SC=null;
public boolean isDealTrackingOn{get;set;}
public String strWaveId {get;set;}
public boolean isFormVisible {get;set;}
private final Wave_Planning__c DealWaveRec;
public String  daytoday{get;set;}
public String  Tempday{get;set;}
public Datetime dt{get;set;}
public Datetime dt1{get;set;}
public Boolean isweekend{get;set;}
public Boolean isAddVisible{get;set;}
public Boolean is_WavePlanVersionActive{get;set;}
public Boolean isNA{get;set;}
public Date d{get;set;}
     
    /******************************
    Method Name: Mob_editButtonOverideWaveController 
    Description: This is Constructor for the Mob_editButtonOverideWaveController class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/
    public Mob_editButtonOverideWaveController (ApexPages.StandardController controller) {
        isNA=true;
        isAddVisible = true;
        is_WavePlanVersionActive=true;
        isDealTrackingOn=true;
        isFormVisible = true;
        m_SC=  controller;
        
        d =System.today();
        dt1 = (DateTime)d+1;
        Tempday= dt1.format('EEEE');
        if(Tempday.equalsIgnoreCase('Saturday'))
        {
            d=d+4;
        }    
        if(Tempday.equalsIgnoreCase('Sunday'))
        {
            d=d+3;
        }          
        DealWaveRec = (Wave_Planning__c)Controller.getRecord();
        strWaveId = DealWaveRec.id;
        List<Wave_Planning__c> lstDealWave = [select deal_location__r.wave_plan_version__r.Display_tracking_message__c from Wave_Planning__c where id=:DealWaveRec.id];
        if(lstDealWave.size()>0 && lstDealWave.get(0).deal_location__r.wave_plan_version__r.Display_tracking_message__c== UTIL_Constants.TRACKING_IS_ON )
        {
           isDealTrackingOn=false; 
        }
        List<Wave_Planning__c> lstDealWave2 = [select id,cloned_from__c from Wave_Planning__c where cloned_from__c =:strWaveId];
        if(lstDealWave2.size()>0)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.VERSION_EXISTS));
            isFormVisible = false;
            return;
        }  
        isAddVisible = UAMSolMobUtility.isAddVisible_WavePlan;
        is_WavePlanVersionActive = UAMSolMobUtility.is_WavePlanVersionActive_WavePlan;
        
        if(UAMSolMobUtility.isNA_WavePlan)
        {
            isNA=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,UTIL_Constants.NO_PRIVILEGE_PLEASE_CONTACT_YOUR_ADMINISTRATOR));
            return;
        }  
                  
    }
    /******************************
    Method Name: checkweekend
    Description:This method is used to check the golive date is weekend.
    Paramenters: NA
    Return Value: Void
    *******************************/
    
     public void checkweekend() {
        Date d1= DealWaveRec.GO_Live_Date_del__c;
        dt = (DateTime)d1+1;
        daytoday= dt.format('EEEE');
        if(daytoday.equalsIgnoreCase('Saturday')||daytoday.equalsIgnoreCase('Sunday')) {
            isweekend=true;
        }
        else {
            isweekend=false;
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
            
            List<Wave_Planning__c> lstDealWaveOld = [select id,Go_Live_date_del__c,revised_go_live__c from Wave_Planning__c where id =:strWaveId limit 1];
            if(lstDealWaveOld.size()>0){
            system.debug('~~~~~~~~~~'+lstDealWaveOld.size());
            system.debug('~~~~~~~~~~'+lstDealWaveOld);
            if(lstDealWaveOld[0].Go_Live_date_del__c !=DealWaveRec.Go_Live_date_del__c && lstDealWaveOld[0].revised_go_live__c!=null)
                {
                    DealWaveRec.revised_go_live__c=DealWaveRec.Go_Live_date_del__c;
                }
            }
            List<Wave_Planning__c> lstDealWave = [select id,cloned_from__c,Go_Live_date_del__c from Wave_Planning__c where cloned_from__c =:strWaveId];
            if(lstDealWave.size()>0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.VERSION_EXISTS));
                return null;
            } 
            if(DealWaveRec.KT_Lead_New__c != null && (DealWaveRec.Mobilization_KT_Lead_Secondary_New__c != null || DealWaveRec.Mobilization_KT_Lead_Secondary_2__c != null))  
            {
                if(DealWaveRec.KT_Lead_New__c == DealWaveRec.Mobilization_KT_Lead_Secondary_New__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.MOB_KT_PRIMARY_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null;
                }
               else if(DealWaveRec.KT_Lead_New__c == DealWaveRec.Mobilization_KT_Lead_Secondary_2__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.MOB_KT_PRIMARY_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null;
                }                
               else if(DealWaveRec.Mobilization_KT_Lead_Secondary_New__c == DealWaveRec.Mobilization_KT_Lead_Secondary_2__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.MOB_KT_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null;
                }  
               
            } 
            else if(DealWaveRec.Mobilization_KT_Lead_Secondary_New__c != null && DealWaveRec.Mobilization_KT_Lead_Secondary_2__c != null){
                    if(DealWaveRec.Mobilization_KT_Lead_Secondary_New__c == DealWaveRec.Mobilization_KT_Lead_Secondary_2__c)
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.MOB_KT_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                        return null;
                    }
               }                
            if(DealWaveRec.Mobilization_Opex_Lead_Primary_New__c != null && (DealWaveRec.Mobilization_Opex_Lead_Secondary_New__c != null || DealWaveRec.Mobilization_Opex_Lead_Secondary_2__c !=null))
            {
                
                if(DealWaveRec.Mobilization_Opex_Lead_Primary_New__c == DealWaveRec.Mobilization_Opex_Lead_Secondary_New__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.MOB_OPEX_PRIMARY_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null; 
                }
               else if(DealWaveRec.Mobilization_Opex_Lead_Primary_New__c == DealWaveRec.Mobilization_Opex_Lead_Secondary_2__c )
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.MOB_OPEX_PRIMARY_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null; 
                }
               else if(DealWaveRec.Mobilization_Opex_Lead_Secondary_New__c == DealWaveRec.Mobilization_Opex_Lead_Secondary_2__c )
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.MOB_OPEX_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null; 
                }
            }
            else if(DealWaveRec.Mobilization_Opex_Lead_Secondary_New__c != null && DealWaveRec.Mobilization_Opex_Lead_Secondary_2__c !=null){
                       if(DealWaveRec.Mobilization_Opex_Lead_Secondary_New__c == DealWaveRec.Mobilization_Opex_Lead_Secondary_2__c )
                        {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.MOB_OPEX_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                            return null; 
                        }
                 }
            if(DealWaveRec.Mobilization_Technology_Lead_Primary_New__c != null && (DealWaveRec.Mob_Technology_Lead_Secondary_New__c != null || DealWaveRec.Mob_Technology_Lead_Secondary_2__c !=null))
            {
                if(DealWaveRec.Mobilization_Technology_Lead_Primary_New__c == DealWaveRec.Mob_Technology_Lead_Secondary_New__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.MOB_TECH_PRIMARY_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null; 
                }
               else if(DealWaveRec.Mobilization_Technology_Lead_Primary_New__c == DealWaveRec.Mob_Technology_Lead_Secondary_2__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.MOB_TECH_PRIMARY_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null; 
                }
                else if(DealWaveRec.Mob_Technology_Lead_Secondary_New__c == DealWaveRec.Mob_Technology_Lead_Secondary_2__c)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.MOB_TECH_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null; 
                }
               
            }
            else if(DealWaveRec.Mob_Technology_Lead_Secondary_New__c !=null && DealWaveRec.Mob_Technology_Lead_Secondary_2__c !=null)
                {
                    if(DealWaveRec.Mob_Technology_Lead_Secondary_New__c == DealWaveRec.Mob_Technology_Lead_Secondary_2__c){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.MOB_TECH_SECONDARY_LEAD_CAN_NOT_BE_SAME));            
                    return null; 
                    }
                }
      
            return m_SC.save();
        }
        catch(Exception ex) 
        {
            if(ex.getmessage().containsIgnoreCase('Insufficient'))
            { ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.INSUFFICIENT_PRIVILAGE));}
            else
                {ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,UTIL_Constants.ERROR_IN_SAVING));}                
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