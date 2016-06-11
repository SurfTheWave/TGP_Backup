/*
Author :Malkeet Singh
Story:MOB_034
Description: This Controller  is used to Track MEC Checklist

Updated by        Story no.                Update Date        Update details
------------     -----------------        --------------    -------------------------------------------------------------
*/
public class MecChecklistController {
   public String dealId{get;set;}
   public Boolean initiateMec {get; set;}
   public Boolean mecChecklist {get; set;}
   public Boolean viewMecChecklist {get; set;}
   public Boolean viewItemList{get;set;}
   public Boolean noPrivilige {get; set;}
   public List<Deal_TGP__c> dealList{get;set;}
   public Deal_TGP__c dealRecord{get;set;}
   public List<Opportunity_TGP__c> opportunityList{get;set;} 
   public Opportunity_TGP__c opportunityRecord{get;set;}
   public String itemValue{get;set;}
   public Boolean showMainMsg{get;set;}
   public Boolean showForm{get;set;}
   public List<MOB_User_Role_Assignment__c> userList{get;set;}
    
    /******************************
    Method Name: SRATPlanController
    Description: This is Constructor for the SRATPlanController class  
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/ 
    public MECChecklistController (ApexPages.StandardController stdCon) 
    {        
        initializeMessages();
        itemValue='tab2';
        // Getting Id of Deal
        dealId=ApexPages.CurrentPage().getParameters().get('id');        
        if(dealId != null)
        {
            showForm=true;
            showMainMsg=false;
            userList=[select name, Role_Name__c, User_Assigned_New__c, User_Assigned_Secondary_New__c,User_Assigned_New__r.SFDC_User__c,User_Assigned_Secondary_New__r.SFDC_User__c from MOB_User_Role_Assignment__c where Deal__c=:dealId];            
            dealList=[Select Opportunity_ID__c,Solution_Architect_New__c,Solution_Architect_New__r.SFDC_User__c, Has_Gov_Lead_Submitted__c,Has_Mob_Architect_Saved__c,Has_Mob_Architect_Submitted__c from Deal_TGP__C where id=:DealId];
            if(userList.size()>0)
            {
                dealRecord = dealList[0];
                opportunityList=[select Enterprise_Solution_Architect_New__c, Enterprise_Solution_Architect_New__r.name, id, name from Opportunity_TGP__c where id=:dealRecord.Opportunity_ID__c];
                String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name;            
                //if(opportunityList.size()>0)
                //{
                    //opportunityRecord = opportunityList[0];
                    boolean isMobArchExist;
                    boolean isReadOnlyUser;
                    boolean isGovExist;
                    if(dealRecord.Has_Mob_Architect_Saved__c==false && dealRecord.Has_Mob_Architect_Submitted__c==false)
                    {
                        isMobArchExist=false;
                        
                        for(MOB_User_Role_Assignment__c mobUser : userList)
                        {
                            if(UTIL_Constants.MOBILIZATION_ARCHITECT.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId()))
                            {
                                isMobArchExist=true;
                            }
                        }
                        if(isMobArchExist==true || userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP))
                        {
                            initiateMec=true;
                            viewItemList=true;
                        }
                        else
                        {
                            noPrivilige=true;
                        }
                    }
                    if(dealRecord.Has_Mob_Architect_Saved__c==true && dealRecord.Has_Mob_Architect_Submitted__c==false)
                    {
                        isMobArchExist=false;
                        isReadOnlyUser=false;
                        for(MOB_User_Role_Assignment__c mobUser : userList)
                        {
                            if(UTIL_Constants.MOBILIZATION_ARCHITECT.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId()))
                            {
                                isMobArchExist=true;
                            }
                            if((UTIL_Constants.PROGRAM_CONTROL_PMO.equalsIgnoreCase(mobUser.Role_Name__c) || UTIL_Constants.GLOBAL_MOBILIZATION_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) || UTIL_Constants.DEAL_PMO.equalsIgnoreCase(mobUser.Role_Name__c)) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId()))
                            {
                                isReadOnlyUser=true;
                            }
                        }
                        if(isMobArchExist==true || dealList[0].Solution_Architect_New__r.SFDC_User__c == UserInfo.getUserId() || userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP))
                        {
                            mecChecklist=true;
                            viewItemList=true;
                        }
                        else if(isReadOnlyUser==true)
                        {
                            viewMecChecklist=true;
                            viewItemList=true;
                        }
                        else
                        {
                            List<Wave_Plan_Version__c> lstWPV=[select id from Wave_Plan_Version__c where deal__c=:dealId and active__c=:true];
                            List<Deal_Location__c> lstDealLoc=new List<Deal_Location__c>();
                            if(lstWPV.size()>0)
                            {
                                lstDealLoc=[select Deployment_Lead_New__c, Location_Mobilization_Lead_Secondary_New__c from 
                                                        Deal_Location__c where Wave_Plan_Version__c=:lstWPV[0].id and 
                                                        (Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c =:UserInfo.getUserId() or
                                                        Deployment_Lead_New__r.SFDC_User__c=:UserInfo.getUserId())];
       
                            }
                            if(lstDealLoc.size()>0)
                            {
                                viewMecChecklist=true;
                                viewItemList=true;
                            }
                            else
                            {
                                noPrivilige=true;
                            }
                        }
                    }
                    if(dealRecord.Has_Mob_Architect_Saved__c==true && dealRecord.Has_Mob_Architect_Submitted__c==true)
                    {
                        isMobArchExist=false;
                        isGovExist=false;
                        isReadOnlyUser=false;
                        for(MOB_User_Role_Assignment__c mobUser : userList)
                        {
                            if(UTIL_Constants.MOBILIZATION_ARCHITECT.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId()))
                            {
                                isMobArchExist=true;
                            }
                            if(UTIL_Constants.GOVERNANCE_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId()))
                            {
                                isGovExist=true;
                            }
                            if((UTIL_Constants.PROGRAM_CONTROL_PMO.equalsIgnoreCase(mobUser.Role_Name__c) || UTIL_Constants.GLOBAL_MOBILIZATION_LEAD.equalsIgnoreCase(mobUser.Role_Name__c) || 'Mobilization PMO Project'.equalsIgnoreCase(mobUser.Role_Name__c) ) && ( mobUser.User_Assigned_New__r.SFDC_User__c == UserInfo.getUserId() || mobUser.User_Assigned_Secondary_New__r.SFDC_User__c == UserInfo.getUserId()))
                            {
                                isReadOnlyUser=true;
                            }
                        }
                        if(isMobArchExist==true || dealList[0].Solution_Architect_New__r.SFDC_User__c == UserInfo.getUserId() || isReadOnlyUser==true)
                        {
                            viewMecChecklist=true;
                            viewItemList=true;
                        }
                        else if(isGovExist==true  || userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.MOB_REGIONAL_LEADERSHIP))
                        {
                            if(dealRecord.Has_Gov_Lead_Submitted__c==false)
                            {
                                mecChecklist=true;
                                viewItemList=true;
                            }
                            if(dealRecord.Has_Gov_Lead_Submitted__c==true)
                            {
                                viewMecChecklist=true;
                                viewItemList=true;
                            }
                        }
                        else
                        {
                            List<Wave_Plan_Version__c> lstWPV=[select id from Wave_Plan_Version__c where deal__c=:dealId and active__c=:true];
                            List<Deal_Location__c> lstDealLoc=new List<Deal_Location__c>();
                            if(lstWPV.size()>0)
                            {
                                lstDealLoc=[select Deployment_Lead_New__c, Location_Mobilization_Lead_Secondary_New__c from 
                                                        Deal_Location__c where Wave_Plan_Version__c=:lstWPV[0].id and 
                                                        (Location_Mobilization_Lead_Secondary_New__r.SFDC_User__c =:UserInfo.getUserId() or
                                                        Deployment_Lead_New__r.SFDC_User__c =:UserInfo.getUserId())];
       
                            }
                            if(lstDealLoc.size()>0)
                            {
                                viewMecChecklist=true;
                                viewItemList=true;
                            }
                            else
                            {
                                noPrivilige=true;
                            }
                        }
                    }            
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No such Deal Record exists!'));
                showMainMsg=true;
                showForm=false;
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No such Deal ID exists!'));
            showMainMsg=true;
            showForm=false;
        }       
    }
    public void initializeMessages()
    {
        initiateMec=false;
        viewItemList=false;
        mecChecklist=false;
        noPrivilige=false;
        viewMecChecklist=false;
    }
    /******************************
    Method Name: getMecChecklistPage
    Description: Method to go to the MEC Checklist Page 
    Paramenters: NA
    Return Value: PageReference
    *******************************/
    public PageReference getMecChecklistPage()
    {
        if(itemValue==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the Tab Value!'));
            return null;
        }
        //PageReference pg=new PageReference('/apex/MECChecklist_Inline?id='+dealId+'&itemValue='+itemValue);
        PageReference pg=Page.MECChecklist_Inline; //('/apex/MECChecklist_InlineReadOnly?id='+dealId+'&itemValue='+itemValue);
        pg.getParameters().put('id', dealId);
        pg.getParameters().put('itemValue', itemValue);        
        pg.setRedirect(true);
        return pg;
    }
    
    /******************************
    Method Name: getMecReadOnlyPage
    Description: Method to go to the MEC Checklist Page 
    Paramenters: NA
    Return Value: PageReference
    *******************************/
    public PageReference getMecReadOnlyPage()
    {
        if(itemValue==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the Tab Value!'));
            return null;
        }
        PageReference pg=Page.MECChecklist_InlineReadOnly; //('/apex/MECChecklist_InlineReadOnly?id='+dealId+'&itemValue='+itemValue);
        pg.getParameters().put('id', dealId);
        pg.getParameters().put('itemValue', itemValue);
        pg.setRedirect(true);
        return pg;
    }
    
    /******************************
    Method Name: getRadioItems
    Description: Method to get the items for tab selection 
    Paramenters: NA
    Return Value: List<SelectOption>
    *******************************/
    public List<SelectOption> getRadioItems() 
    {
        List<SelectOption> options = new List<SelectOption>(); 
        //options.add(new SelectOption('tab1','Entry Criteria for Due Diligence')); 
        options.add(new SelectOption('tab2','Entry Criteria for Project Execution')); 
        return options; 
    }
}