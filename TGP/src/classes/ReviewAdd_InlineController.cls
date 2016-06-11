/*
Author :  Varsha Chougule
Story  :  Story-0089/SOL_034  
Description : Addition New Reviews for an opportunity.


Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
Mayank Tayal    Sol_148                    5/15/2013        Sol UAM-Release 2
*/

public with sharing class ReviewAdd_InlineController {

    public string opportunityId{get;set;}
    public Review_Process__c newReviewProcess{get;set;}
    public list<Review_Process__c> newReviewProcessList{get;set;}
    public boolean userAccess {get;set;}
    public boolean displayMsg {get;set;}
    public boolean displayReview {get; set;}
    public string strDisplayMsg{get;set;} 
    public string reviewIdToDelete{get;set;}
    public String ReviewStage{get;set;}
    public Boolean addButtonRender {get; set;}
    public Boolean saveEditButtonRender {get; set;}
    public Boolean deleteButtonRender {get; set;}
    public Boolean readOnlyMode{get;set;}
    public boolean isDocLinkVisible{get;set;}
    public boolean isLinkNotAvaiable{get;set;} 
    public Opportunity_TGP__c objOpportunity{get;set;}
    
    /******************************
    Method Name: ReviewAdd_InlineController
    Description: Constructor for ReviewAdd_InlineController
    Paramenters: ApexPages.StandardController
    Return Value: NA
    *******************************/
    public ReviewAdd_InlineController(ApexPages.StandardController controller) 
    {
        opportunityId=ApexPages.CurrentPage().getParameters().get('id');
         objOpportunity=new Opportunity_TGP__c();
         isLinkNotAvaiable= true;
        //if user have access to records
        //determineUserAccess();
        userAccess=true;
        //if(userAccess==true)
        //{
            newReviewProcess=new Review_Process__c();
            newReviewProcessList=new list<Review_Process__c>();
            displayMsg=false;
            displayReview=true;
        /*}
        else
        {
            strDisplayMsg='Not authorized to access reviews for this Opportunity!';
            displayMsg=true;
            displayReview=false;  
        }*/
        //UAM Code--Mayank Tayal-Sol_148
        if(opportunityId!=null)
        {
            List<Opportunity_TGP__c> lstOpp = [select id, name  from Opportunity_TGP__c where id = : opportunityId];//Link_to_Approvel__c
            if(lstOpp.size()>0) {
                //String strOppId = lstOpp.get(0).id;
                objOpportunity = lstOpp[0];
               /* if(objOpportunity.Link_to_Approvel__c == null) {
                     isLinkNotAvaiable= false;
                }*/
                
                /* UAM SOL RV List<userRole >role = [select id,name from userRole where id=:UserInfo.getUserRoleId()];
                if(role.size()>0) {
                    if(role[0].name!=null && (role[0].name.equalsIgnoreCase('Operations') || role[0].name.equalsIgnoreCase('Resource Staffing')))
                        isDocLinkVisible=true;
                }
                List<Profile> profileList = [select name from profile where id = :userinfo.getProfileId()];
                if(profileList[0].name.equalsIgnoreCase('Workbench Administrator')) {
                    isDocLinkVisible=true;
                }
                UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
                Map<String,Boolean> m = uam.CheckSolutionUserRole(objOpportunity.Id,'Review_Process__c');            
                addButtonRender = m.get('C');
                saveEditButtonRender = m.get('U');
                deleteButtonRender  = m.get('D'); */
                
                List<Profile> profileList = [select name from profile where id = :userinfo.getProfileId()];
                if( profileList[0].name.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN) || profileList[0].name.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)) {
                    isDocLinkVisible=true;
                }
                
                addButtonRender =UAMSolMobUtility.addButtonRender_BPOOppTgp;
                saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
                deleteButtonRender = UAMSolMobUtility.deleteButtonRender_BPOOppTgp;
            }
        }
        if(addButtonRender==false && saveEditButtonRender==false)
        {
            readOnlyMode=true;
        }
    }

    /******************************
    Method Name: getReviewStageNames
    Description: This method is used to get list of Review stages from master.  
    Paramenters: NA
    Return Value: List<SelectOption>
    *******************************/ 
    public List<SelectOption> getReviewStages()
    {  
        List<SelectOption> StageName=new List<SelectOption>();
        if(ReviewStage=='None')
        {
            StageName.add(new SelectOption('None','--None--'));
            return StageName;
        }
        List <Review_Stage_Master__c> tempReviewStage=[select id,name from Review_Stage_Master__c where active__c=:true order by name];        
        if(tempReviewStage.size()>0)
        {
            for(Review_Stage_Master__c r : tempReviewStage)
            {
                StageName.add(new SelectOption(r.id, r.name)); 
            }
        }
        return StageName;
    }

    /******************************
    Method Name: addReview
    Description: This method is used to add review records.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void addReview()
    {
        try
        {
            if(ReviewStage=='None' || ReviewStage==null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Review Stage!'));  
                return;  
            }
            newReviewProcess.Review_Stage_Master__c=ReviewStage;
            /*if(newReviewProcess.Review_Date__c < Date.today())
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Review Date should be greater than or equal to Today\'s Date!'));  
                return;  
            }*/
            List<Opportunity_TGP__c> oppList=[select id, name, Client_Name__r.name, SAP_OM_Opportunity__r.name, 
                                             Enterprise_Solution_Architect_New__r.name, Client_Geo_Area__r.name, Client_Geo_Unit__r.name, Operating_Group__r.name
                                              from Opportunity_TGP__c where id=:opportunityId];
            
            if(oppList.size()>0)
            {
                newReviewProcess.Client_Name__c=oppList[0].Client_Name__r.name;
                //newReviewProcess.Complex_Cost_Architect__c=oppList[0].Complex_Cost_Architect_New__r.name;
                newReviewProcess.Opportunity_ID__c=oppList[0].SAP_OM_Opportunity__r.name;
                newReviewProcess.Opportunity_Name__c=oppList[0].name;
                newReviewProcess.Opportunity_Solution_lead__c=oppList[0].Enterprise_Solution_Architect_New__r.name;
                List<Opportunity_Offering__c> offeringNameList=[select id,name, Solution_Lead_New__c, Offering_Master__r.name, Offering_Solution_Lead_Secondary_New__c, 
                                        Solution_Specialist_New__c, Technical_Architect_New__c, Functional_Architect_Mobilization_New__c, 
                                        Solution_Specialist_New__r.name from Opportunity_Offering__c where Opportunity_TGP__c=:oppList[0].id];  
                //List<Solution_Specialist_Task__c> solSpec=[select id, name, Opportunity_Offering__c, Solution_Specialist_User__c, Solution_Specialist_User__r.name from Solution_Specialist_Task__c];
                String OfferingNames='';
                String solSpecialistNames='';
                Set<String> solSpecialistUsers=new Set<String>();
                if(offeringNameList.size()>0)
                {
                    for(Opportunity_Offering__c off : offeringNameList)
                    {
                        OfferingNames=OfferingNames+off.Offering_Master__r.name+' ; ';
                        if(off.Solution_Specialist_New__c!=null)
                            solSpecialistUsers.add(off.Solution_Specialist_New__r.name);                                                   
                    }                    
                }
                else
                    OfferingNames='   ';
                if(solSpecialistUsers.size()>0)
                {
                    for(String s:solSpecialistUsers)
                        solSpecialistNames=solSpecialistNames + s + ' ; '; 
                }
                else
                    solSpecialistNames='   ';
                newReviewProcess.Offering__c=OfferingNames;            
                newReviewProcess.Solution_Specialist__c=solSpecialistNames;
            }         
            
            newReviewProcess.BPO_Opportunity__c=opportunityId;
            Decimal version=0;
            if(newReviewProcessList.size()>0)
            {
                for(Review_Process__c r: newReviewProcessList)
                {
                    if(r.Review_Stage_Master__c == newReviewProcess.Review_Stage_Master__c)
                    {
                        if(version < r.version__c)
                        {
                            version=r.version__c;
                        }
                    }
                }
            }
            newReviewProcess.version__c=version + 1;
            //add new review record
            upsert newReviewProcess;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Added Successfully')); 
        }
        catch(Exception ex)
        {   
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving!')); 
            return;
        }
         newReviewProcess=new Review_Process__c();
        return;
    }
    
    /******************************
    Method Name: getReviewList
    Description: This method is get all review records for perticular opportunity.
    Paramenters: NA
    Return Value: list<Review_Process__c>
    *******************************/
    public list<Review_Process__c> getReviewList()
    {
        list<Review_Process__c> tempReviewProcessList=new list<Review_Process__c>();
        
        //List of review records for perticular opportunity
        newReviewProcessList=[select id,Review_Type__c,Review_Type_link__c,NewComments__c,Review_Date__c, NewStatus__c,BPO_Opportunity__c,Version__c,Review_Stage_Master__r.name,Review_Stage_Master__c from Review_Process__c where BPO_Opportunity__c=:opportunityId order by createddate desc];
        if(newReviewProcessList.size()>0)
        {
            for(Review_Process__c reviewList : newReviewProcessList)
            {
                tempReviewProcessList.add(reviewList);  
            }  
        }   
        return tempReviewProcessList; 
    }
    
    /******************************
    Method Name: saveReviewList
    Description: This method is used to save review records.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void saveReviewList()
    {
        try
        {
            /*if(newReviewProcessList.size()>0)
            {
                for(Review_Process__c rev: newReviewProcessList)
                {    
                    if(rev.Review_Date__c < Date.today())
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Review Date should be greater than or equal to Today\'s Date!'));  
                        return;  
                    }
                }
            }*/
            //update the review records
            upsert newReviewProcessList;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Updated Successfully'));
        }
        catch(Exception ex)
        {   
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving!')); 
            getReviewList();
            return;
        }
        return;
    }
    
    /******************************
    Method Name: cancelReviewList
    Description: This method is used to cancel the chenges.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void cancelReviewList()
    {
        getReviewList();
        return;
    }
    
    /******************************
    Method Name: deleteReview
    Description: This method is used to delete review record.
    Paramenters: NA
    Return Value: void
    *******************************/
    public void deleteReview()
    {
        try
        {
            //List of review to delete the perticular record
            List<Review_Process__c> listReview=[select id from Review_Process__c where id=:reviewIdToDelete];
            if(listReview.size()==1)
            {
                //delete the selected record
                delete listReview;
            }
             /* Add by Vinay Chada */
            List<Task> tkDelete=[Select t.Id From Task t where t.Review_Process_Id__c=:reviewIdToDelete];
            if(tkDelete.size() > 0)
            {
                //delete the selected Task record
                delete tkDelete;
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record deleted successfully'));
        }
        catch(Exception ex)
        {   
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Deleting!')); 
            getReviewList();
            return;
        }
        return;
    }
    
    /******************************
    Method Name: determineUserAccess
    Description: Initializing the display for Page Messages
    Paramenters: NA
    Return Value: void
    *******************************/
    public void determineUserAccess()
    {
        List<Opportunity_TGP__c> opportunityRecord=[select id,Enterprise_Solution_Architect_New__c, Enterprise_Solution_Architect_New__r.SFDC_User__c from Opportunity_TGP__c where id=:opportunityId];
        if(opportunityRecord.size()>0)
        {
            if(opportunityRecord[0].Enterprise_Solution_Architect_New__r.SFDC_User__c==UserInfo.getUserID())
            {
                userAccess=true;
                return;
            }
            List<Opportunity_Offering__c> offeringName=[select id,name, Solution_Lead_New__c, Offering_Solution_Lead_Secondary_New__c, Solution_Specialist_New__c from Opportunity_Offering__c where Opportunity_TGP__c=:opportunityRecord[0].id];
            List<Solution_Specialist_Task__c> solSpec=[select id, name, Opportunity_Offering__c, Solution_Specialist_User__c, Solution_Specialist_User__r.name from Solution_Specialist_Task__c];
            if(offeringName.size()>0)
            {
                for(Opportunity_Offering__c off : offeringName)
                {
                    if(off.Solution_Lead_New__c == UserInfo.getUserID()|| off.Offering_Solution_Lead_Secondary_New__c== UserInfo.getUserID())
                    {
                        userAccess=true;
                        return;
                    }
                    if(solSpec.size()>0)
                    {
                        for(Solution_Specialist_Task__c sol : solSpec)
                        {
                           if(sol.Opportunity_Offering__c==off.id)
                           {
                               if(sol.Solution_Specialist_User__c == UserInfo.getUserID())
                               {
                                   userAccess=true;
                                   return;
                               }
                           }
                        }
                    }
                }
            }
            /*if(opportunityRecord[0].Complex_Cost_Architect_New__r.SFDC_User__c == UserInfo.getUserID())
            {
                userAccess=true;
                return;
            }*/
        }
        userAccess=false;
    }
    // Save the link for approvel
    public void SaveLink() {
        try {
            upsert objOpportunity;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Link saved successfully'));       
                  //initializeDetailRecords(); 
        }
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Saving'));
            return;
        } 
        return;
    }
    public PageReference ClickHere() {
        /*String url = objOpportunity.Link_to_Approvel__c;
        PageReference pageRef = new PageReference(url);
        pageRef.setRedirect(true);
        return pageRef;
    }*/
     return null;
     }
    
}