/*
Author : Varsha Chougule.
Story  : MOB_132_b 
Description : Overring New button with visualforce page

Updated by        Story no./Defect No.           Update Date        Update details
------------    -----------------------        --------------    -------------------------------------------------------------
Varsha Chougule      MOB_132_a                 


*/
public class insertNewWavePlanVersionController {
    public String version{get;set;}
    public String dealId{get;set;}
    public String waveId{get;set;}
    public String retURL{get;set;}
    public Wave_Plan_Version__c newWPV{get;set;}
    public List<Wave_Plan_Version__c> lstWPV{get;set;}
    public List<Deal_TGP__c> dealRec{get;set;}
    public boolean isWPVAccess{get;set;}
    
    /******************************
    Method Name: insertNewWavePlanVersionController
    Description: This is Constructor for the insertNewWavePlanVersionController class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/  
    public insertNewWavePlanVersionController(ApexPages.StandardController controller) {
        
        newWPV=(Wave_Plan_Version__c)controller.getRecord();
        waveId=ApexPages.CurrentPage().getParameters().get(UTIL_Constants.URL_PARAMETER_ID);
        if(waveId==null)
        {
            version=ApexPages.CurrentPage().getParameters().get('version');
            newWPV.version__c=Integer.valueOf(version);
            dealId=ApexPages.CurrentPage().getParameters().get('dealId');
            if(dealId!=null)
            {
                dealRec=[select id, name from Deal_TGP__c where id=:dealId];
                if(dealRec.size()>0)
                {
                    newWPV.deal__c=dealRec[0].id;
                }
            }
        }  
        if(waveId!=null)
        {
            lstWPV=[select id , deal__c from Wave_Plan_Version__c  where id=:waveId];
            if(lstWPV.size()>0)
            {
                dealId=lstWPV[0].deal__c;
            }
        }
      /*  
        UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
        Map<String,Boolean> m = uam.CheckUserRole(dealId,'Wave_Plan_Version__c');
        if(m.get('C')==true || m.get('U')==true)
        {
            isWPVAccess=true;
        }
        else
        {
            isWPVAccess=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No priviledge. Please contact your administrator.'));
            return;
        }
        */
        isWPVAccess = UAMSolMobUtility.isWPVAccess_WPV;
        if(!isWPVAccess)
        {
        	isWPVAccess=false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No priviledge. Please contact your administrator.'));
            return;
        }
        
    }
    
    /******************************
    Method Name: SaveRecord
    Description:This method is used to insert the new record.
    Paramenters: NA
    Return Value: pagereference 
    *******************************/
    public pagereference SaveRecord()
    {
        String message;
        boolean isActive;
        try
        {    
            List<Wave_Plan_Version__c> listWavePlanVersion=[Select Display_tracking_message__c,Active__c from Wave_Plan_Version__c where id=:waveId];
            if(listWavePlanVersion.size()>0)
            {
                message=listWavePlanVersion[0].Display_tracking_message__c;
                isActive=listWavePlanVersion[0].Active__c;
            }
            if(message== UTIL_Constants.TRACKING_IS_ON || isActive==false)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Can not edit record: Either Tracking is ON or current version is inactive.')); 
                return null;  
            }
            else
            {
                upsert newWPV;
            }
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Saving Record!'+ex));
            return null;
        }
        if(waveId==null)
            deleteDealShareFromOldWPV();
        PageReference pr=new PageReference('/'+newWPV.id);
        pr.setRedirect(true);
        return pr;  
    }
    
    /******************************
    Method Name: CancelRecord
    Description:This method is used to Cancel the creation of new record.
    Paramenters: NA
    Return Value: pagereference 
    *******************************/ 
    public pagereference CancelRecord()
    {
        PageReference pr;
        if(waveId!=null)
        {
            pr=new PageReference('/'+waveId);
            pr.setRedirect(true);
            return pr;                  
        }
        else
        {
            pr=new PageReference('/'+dealId);
            pr.setRedirect(true);
            return pr;  
        }
    }
    public void deleteDealShareFromOldWPV()
    {
        List<Deal_Location__c> lstDealLoc = [select Deployment_Lead_New__r.SFDC_User__c, Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c ,
                                            Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c, Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c 
                                             from deal_location__c where Wave_Plan_Version__r.Deal__c = : dealId and Wave_Plan_Version__r.active__c=:false];
                                                    
        List<Wave_Planning__c> lstWavePlan = [select Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c, Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c,
                                              Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c, Mob_Technology_Lead_Secondary_New__r.SFDC_User__c,
                                              KT_Lead_New__r.SFDC_User__c, Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c from Wave_Planning__c 
                                              where deal_location__r.Wave_Plan_Version__r.Deal__c=:dealId and deal_location__r.Wave_Plan_Version__r.active__c=:false];                                            
        
        set<Id> lstIdsToDelete = new set<Id> ();
        for(Deal_Location__c tempDealLoc : lstDealLoc )
        {
            lstIdsToDelete.add(tempDealLoc.Deployment_Lead_New__r.SFDC_User__c);
            lstIdsToDelete.add(tempDealLoc.Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c );
            lstIdsToDelete.add(tempDealLoc.Mob_Recruitment_Lead_Primary_New__r.SFDC_User__c);
            lstIdsToDelete.add(tempDealLoc.Mob_Recruitment_Lead_Secondary_New__r.SFDC_User__c);
        }
        for(Wave_Planning__c tempWave : lstWavePlan )
        {
            lstIdsToDelete.add(tempWave.Mobilization_Opex_Lead_Primary_New__r.SFDC_User__c);
            lstIdsToDelete.add(tempWave.Mobilization_Opex_Lead_Secondary_New__r.SFDC_User__c);
            lstIdsToDelete.add(tempWave.Mobilization_Technology_Lead_Primary_New__r.SFDC_User__c);
            lstIdsToDelete.add(tempWave.Mob_Technology_Lead_Secondary_New__r.SFDC_User__c);
            lstIdsToDelete.add(tempWave.KT_Lead_New__r.SFDC_User__c);
            lstIdsToDelete.add(tempWave.Mobilization_KT_Lead_Secondary_New__r.SFDC_User__c );
        }
        List<MOB_User_Role_Assignment__c> lstUserRoleAssign = [select User_Assigned_New__c,User_Assigned_Secondary_New__c from MOB_User_Role_Assignment__c where Deal__c=:dealId ];
        for(MOB_User_Role_Assignment__c tmp : lstUserRoleAssign)
        {
            lstIdsToDelete.remove(tmp.User_Assigned_New__c);
            lstIdsToDelete.remove(tmp.User_Assigned_Secondary_New__c);
        }        
        List<Deal_TGP__Share> lstDealShare = [select id,UserOrGroupId 
                                              from Deal_TGP__Share 
                                              where ParentId=:dealId and UserOrGroupId  in : lstIdsToDelete  AND RowCause =: 'Manual'];
                                             
        Database.DeleteResult[] dealTgpDeleteResult = Database.delete(lstDealShare ,false);
        return;
    }
}