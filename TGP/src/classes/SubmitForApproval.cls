/*
Author : Malkeet Singh
Story  : MOB_004 
Description : For Submit Approval button controller

Updated by        Story no.                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

*/
global class SubmitForApproval  {
/*public String DealId{get;set;}
public SubmitForApproval (ApexPages.StandardController stdCon) {

// To get id of Deal record

DealId=ApexPages.CurrentPage().getParameters().get('id');
}
 

public String pageMessage{get;set;}
public Boolean showButton{get;set;}
*/

webservice static String approvalMethod(String id)
{
    String DealId=id;
    List <Deal_TGP__c> lst=[SELECT id,name,Is_Submitted__c,Governance_Lead_Name_New__r.SFDC_User__c,Solution_Architect_New__r.SFDC_User__c
                            ,Comments__c 
                            FROM Deal_TGP__c 
                            WHERE id =: DealId];
    List<Profile> profileList = [select name from profile where id = :userinfo.getProfileId() limit 1];
    if(profileList[0].name.equalsIgnoreCase(UTIL_Constants.MOB_LEADERSHIP) )
    {
       return UTIL_Constants.MSG4;
    }
   
    if(lst.size()==0 || lst[0].Is_Submitted__c==true)
    {
        return UTIL_Constants.MSG2;
    }
    if(lst.size()==0 || lst[0].Governance_Lead_Name_New__r.SFDC_User__c==null)
    {
        return UTIL_Constants.MSG1;
    }
    
    else
    {
        for(Deal_TGP__c parser:lst)
        {
            // Create an approval request for the Deal

            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        
            req.setComments(parser.Comments__c);

            req.setObjectId(parser.id);

            req.setNextApproverIds(new Id[] {parser.Governance_Lead_Name_New__r.SFDC_User__c});

            // Submit the approval request for the Deal

            Approval.ProcessResult result = Approval.process(req);
        
             List<Deal_TGP__c> lstNewDeal = new List<Deal_TGP__c>();
             lstNewDeal.add(parser);
             UserAccessUtility uam = new UserAccessUtility();
             uam.CheckAccessDeal(lstNewDeal);
             Mob_PrepopulateUserRoles mobRoles= new Mob_PrepopulateUserRoles();
             mobRoles.insertUserRoles(lstNewDeal);             
        }
        return UTIL_Constants.MSG3;
    }
    
  }
  /*public PageReference returnBack()
  {
      PageReference pg=new PageReference('/'+DealId);
      pg.setRedirect(true);
      return pg;
  }*/
    
}