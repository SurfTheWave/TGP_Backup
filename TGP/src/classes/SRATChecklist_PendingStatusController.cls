/*
Author : Mayank Tayal
Story  :   Story_0094/MOB__019 and Story_0100/MOB_022
Description : As KT Lead, I should able to initiate & complete SRAT as planned in High level mobilization plan 

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/

public class SRATChecklist_PendingStatusController {
    public String waveVersionId{get;set;}
    public String pendingMessage{get;set;}
    public Date Today { get { return Date.today(); }} 
    
    public Boolean showMainMsg{get;set;} 
    public Boolean showForm{get;set;}   
    
    /******************************
    Method Name: SRATChecklist_ReadOnlyInlineController
    Description: Constructor for Initializing
    Paramenters: controller
    Return Value: NA
    *******************************/
    public SRATChecklist_PendingStatusController(ApexPages.StandardController controller) {
        waveVersionId=ApexPages.CurrentPage().getParameters().get('id');
        if(waveVersionId!=null)
        {
            showMainMsg=false;
            showForm=true;
            List<SRAT__c> pendingStatus=[select id, name from SRAT__c where Has_KT_Lead_Submitted__c=true and Has_Deployment_Lead_Submitted__c=false and Planned_Date__c < Today and Wave_Plan_Version__c=:waveVersionId];
            if(pendingStatus.size()>0)
            {
                pendingMessage='One or more SRAT Checklists are pending for submission for Location Mobilization Lead Primary!';
            }
            else
            {
                pendingMessage='No SRAT Checklist pending for submission for Location Mobilization Lead Primary!';
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'High Level Mobilization Plan does not exist!'));
            showMainMsg=true;
            showForm=false; 
        }
    }

}