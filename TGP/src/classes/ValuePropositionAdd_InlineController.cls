/*
Author : Varsha Chougule
Story  : Story-0165/SOL_068  
Description : Controller for ValuePropositionAdd_Inline page.

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------


*/
public with sharing class ValuePropositionAdd_InlineController {
    public String hiddenNavigator1{get;set;}
    public String hiddenNavigator2{get;set;}
    public String OppId{get;set;}
    public Boolean refreshPage {get; set;}
    public Boolean addButtonRender {get; set;}
    public Boolean saveEditButtonRender{get;set;}
    public Boolean deleteButtonRender {get; set;}
    public Boolean isEditMode {get;set;}
    public String selected{get;set;}
    public Value_Proposition__c accProfile;
    public Value_Proposition__c newProfDetail {get;set;}
    public List<Value_Proposition__c> listProfileDetailsActual {get;set;}
    public String fileIdDelete ;
    public Boolean readOnlyMode{get;set;}
    
    public String getFileIdDelete(){
        return fileIdDelete;
    }
    
    public void setFileIdDelete(String fileIdDelete){
        this.fileIdDelete = fileIdDelete;
    }
    
    /******************************
    Method Name: ValuePropositionAdd_InlineController 
    Description: Constructor for ValuePropositionAdd_InlineController
    Paramenters: stdCon
    Return Value: void
    *******************************/
    //Start
    public ValuePropositionAdd_InlineController(ApexPages.StandardController stdCon){
        hiddenNavigator1='New';
        addButtonRender = true;
        /*String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name; //Get users with Profile Name
         //Logic to show add button for Sol Admin and Sol Leadership profile.
        List<Sol_UAM_Access_Setting__c> solUamAccess = new List<Sol_UAM_Access_Setting__c>();
        solUamAccess = Sol_UAM_Access_Setting__c.getall().values(); 
        for(Sol_UAM_Access_Setting__c solUam : solUamAccess){
            if(usrProfileName.equalsIgnoreCase(solUam.Profile_Name__c) && solUam.Read_Access__c == true && usrProfileName.equalsIgnoreCase(solUam.Role_Name__c) && usrProfileName.equalsIgnoreCase(solUam.Logic_Role_Name__c)){
                    addButtonRender = false ;
            }
        }*/
        newProfDetail = new Value_Proposition__c();
        OppId=ApexPages.CurrentPage().getParameters().get('id');
        initializeDetailRecords();
        hiddenNavigator2='testValue';
        refreshPage = false;
        //UAM Code--Mayank Tayal-Sol_148
        if(OppId!=null)
        {
          /*  List<Opportunity_TGP__c> lstOpp = [select id, name from Opportunity_TGP__c where id = : OppId];
            String strOppId = lstOpp.get(0).id;
            UAM_RoleSearchUtility uam = new UAM_RoleSearchUtility();
            Map<String,Boolean> m = uam.CheckSolutionUserRole(strOppId,'Value_Proposition__c');            
            addButtonRender = m.get('C');
            saveEditButtonRender = m.get('U');
            deleteButtonRender  = m.get('D'); */
            addButtonRender = UAMSolMobUtility.addButtonRender_BPOOppTgp;
            saveEditButtonRender = UAMSolMobUtility.saveEditButtonRender_BPOOppTgp;
            deleteButtonRender  = UAMSolMobUtility.deleteButtonRender_BPOOppTgp;           
        }
        if(addButtonRender==false && saveEditButtonRender==false)
        {
            readOnlyMode=true;
        }
    }
    //End
    
    /******************************
    Method Name: addNewProfDetail
    Description: To add records for ValuePropositionAdd_Inline
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public PageReference addNewProfDetail() {
        hiddenNavigator1='Add';
        newProfDetail.Opportunity_TGP__c=OppId;
        if(newProfDetail.Key_Messages_Win_Themes__c==null)
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Key Messages/Win Themes cannot be left blank'));
             return null;
         }
         if(newProfDetail.Evidence__c==null)
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Evidence cannot be left blank'));
             return null;
         }
         if(newProfDetail.How_do_these_relate_to_buyer_values__c==null)
         {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'How do these relate to buyer values cannot be left blank'));
             return null;
         }
        try{
            insert newProfDetail;
        }
        catch(Exception ex){
             if(ex.getMessage().contains('INSUFFICIENT_ACCESS')){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have permission to perform this action.'));
             }
             else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please select the required fields'));
             }
            return null;
        }
        finally{
            newProfDetail = new Value_Proposition__c();
        }
        initializeDetailRecords();
        refreshPage = true;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Added Successfully'));
        return null;
        
    }
    //End

    /******************************
    Method Name: initializeDetailRecords
    Description: Added method to initialise all Records.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public void initializeDetailRecords(){
        hiddenNavigator2='Add';
        listProfileDetailsActual = new List<Value_Proposition__c>();
        for(Value_Proposition__c profDet : [Select Key_Messages_Win_Themes__c, Evidence__c, How_do_these_relate_to_buyer_values__c, Active__c from Value_Proposition__c where Opportunity_TGP__c=:OppId order by createddate desc]){
            listProfileDetailsActual.add(profDet);                
        } 
    } 
    //End

    /******************************
    Method Name: saveAccProfileDetails
    Description: For saving records in Value Proposition.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public PageReference saveAccProfileDetails(){
        Value_Proposition__c [] profDetailsToUpsert = new Value_Proposition__c []{};
        if(listProfileDetailsActual.size()<=0)
        {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'There is no record to save'));
                return null;
        }
         for(Value_Proposition__c valueProp : listProfileDetailsActual){
           if(valueProp.Key_Messages_Win_Themes__c== null || valueProp.Key_Messages_Win_Themes__c== '')
             {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Key Messages/Win Themes cannot be left blank'));
                return null;
             
             }
             if(valueProp.Evidence__c== null || valueProp.Evidence__c== '')
              {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Evidence cannot be left blank'));
                return null;
              } 
              if(valueProp.How_do_these_relate_to_buyer_values__c== null)
                {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'How do these relate to buyer values cannot be left blank'));
                 return null;
                }
           
          }
        profDetailsToUpsert.addAll(listProfileDetailsActual);

        try {
            upsert profDetailsToUpsert;
        }
        catch(Exception ex) {
          if(ex.getMessage().contains('INSUFFICIENT_ACCESS')){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have permission to perform this action.'));                   
          }
          else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please select the required fields'));
          }
            return null;
        }
        refreshPage = true;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Updated Successfully'));
        return null;
    }
    //End

    /******************************
    Method Name: refreshAccProfilePage
    Description: Method to cancel the page.
    Paramenters: NA
    Return Value: void
    *******************************/
    //Start
    public PageReference refreshAccProfilePage(){
        initializeDetailRecords();
        refreshPage = true;
        return null;
    }  
    //End
    /******************************
    Method Name: deleteFile
    Description: delete link
    Paramenters: NA
    Return Value: NA
    *******************************/   
    public PageReference deleteFile()
    {
        //Iterate through Offering Scope Image
        for(Value_Proposition__c  vp : [select id, name from Value_Proposition__c where Opportunity_TGP__c =:OppId and id=:fileIdDelete])
        {
            //To override file from Offering Scope Image.
            delete vp;           
        }    
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record deleted successfully'));
        initializeDetailRecords();        
        return null;
    }
}