/*
  @Author: Rishab
  @Name: VFC_TechToolsController
  @Created Date: 
  @Description:
  @version: 1.0
*/
public class VFC_TechToolsController {
    public List<Tech_tools__C> techTool{get;set;}
    public List<Tech_Tool_Comments__c> techToolComment{get;set;}  
    Public Opportunity OppRecord{get;set;}
    public List<TectToolsWrapper> techToolResultsList {get;set;}
    public List<Tech_Tool_Comments__c> techToolCommentDisplay{get;Set;}
    public List<Tech_Tool_Comments__History> techToolCommentDisplay1{get;Set;}
    public List<Tech_Tool_Comments__c> techToolCommentInsert= new List<Tech_Tool_Comments__c>();
    public List<Tech_Tool_Comments__c> techToolCommentUpdate= new List<Tech_Tool_Comments__c>();
    Public Map<id,Tech_Tool_Comments__c> techToolCommentMp = new Map<id,Tech_Tool_Comments__c>();
   
    public VFC_TechToolsController() {                
    }
    public VFC_TechToolsController(ApexPages.StandardController controller){
    }
    
    /*
      @Author: Rishab
      @Name: callFirst
      @Created Date: 
      @Description:
      @version: 1.0
    */ 
    public void callFirst(){
        OppRecord=[Select SAP_OM_Item_Id__c,Client_Name__c,Name,StageName,Account.Name,BPO_Reporting_Status__c,Opportunity_Solution_Lead__c,
                   Geo_Region__c,Geo_Unit__c,OperatingGroup__c,Service_Grp__c,BPO_Net_Rev_Thousands__c,ECSD_Quarter__c from opportunity
                   where  id = :ApexPages.currentPage().getParameters().get('id') ];
        techTool = [SELECT Id, Name,Custom_Tool_Name__c,Service__c,Service__r.services__c,Approval_For_Out_of_Scope_Tool__c,
                    Service__r.Solutionscope__r.Offering_Master__c,LastModifiedDate,Tech_Tool_Type__c,Comments__c,LastModifiedBy.Name,
                    Tech_Tool__c,Scope_Status__c,Out_Of_Scope_Reason__c,Out_Of_Scope_Reason_Description__c FROM Tech_tools__C
                    WHERE Scope_Status__c=:UtillContstant_Novasuite.OUT_OF_SCOPE AND Tech_Tool__r.Mandatory__C= TRUE 
                    AND Service__r.Solutionscope__r.Opportunity__r.Id =:ApexPages.currentPage().getParameters().get('id') ];  
        techToolComment = [SELECT Id, Tech_Tool__c, Opportunity__c, User__c, Comment__c FROM Tech_Tool_Comments__c 
                           where Opportunity__c=:ApexPages.currentPage().getParameters().get('id') AND User__c=: UserInfo.getUserId()];
        techToolCommentDisplay1 = [SELECT ParentId, Field, OldValue,Parent.Copy_First_Value_del__c,Parent.Opportunity__c,
                                   Parent.Tech_Tool__r.Tech_Tool__c,CreatedDate,Parent.User__c,Parent.Tech_Tool__r.Tech_Tool_Type__c,
                                   Parent.Comment__c ,Parent.LastModifiedDate,Parent.Tech_Tool__r.Service__r.Solutionscope__r.Offering_Master__c,NewValue 
                                   FROM Tech_Tool_Comments__History  where Parent.Opportunity__c=: ApexPages.currentPage().getParameters().get('id')  ORDER BY CreatedDate Desc];
        for(Tech_Tool_Comments__History  techi:techToolCommentDisplay1 ){
        //System.debug('CommentDisplay'+techi.Field+' FirstValue'+techi.Parent.Copy_First_Value_del__c+' Parent.Comment__c'+techi.Parent.Comment__c );
        }
        if(!techToolComment.isEmpty()){
            for(Tech_Tool_Comments__c techComment : techToolComment){
                techToolCommentMp.put(techComment.Tech_Tool__c,techComment);                  
            }
        }
        if(!techTool.isEmpty()){
            techToolResultsList=new List<TectToolsWrapper>();
            for(Tech_tools__C techRec : techTool){
                if(null!= techToolCommentMp.get(techRec.id) ){
                    techRec.Comments__c =  techToolCommentMp.get(techRec.id).Comment__c;         
                }
                else{
                    techRec.Comments__c='';   
                }           
                TectToolsWrapper tech =new TectToolsWrapper(techRec);               
                techToolResultsList.add(tech);                          
            }
         }
    }
    
    /*
      @Author: Rishab
      @Name: doSave
      @Created Date: 
      @Description:
      @version: 1.0
    */ 
    public PageReference doSave() {
        id OppID = ApexPages.currentPage().getParameters().get('id');
        List<Tech_tools__c> techListToUpdate = new List<Tech_tools__C>();
        for(TectToolsWrapper tech: techToolResultsList){
            if(tech.checked){             
                techListToUpdate.add(tech.techTool);
                if(techToolCommentMp.keyset().contains(tech.techTool.id)){
                    if(tech.techTool.Comments__c !=  techToolCommentMp.get(tech.techTool.id).Comment__c ){
                        techToolCommentMp.get(tech.techTool.id).Comment__c = tech.techTool.Comments__c ; 
                       
                        techToolCommentUpdate.add(techToolCommentMp.get(tech.techTool.id))  ;                     
                    }
                }else{
                    Tech_Tool_Comments__c techTlCmnt = new Tech_Tool_Comments__c();
                    techTlCmnt.Opportunity__c=OppID;
                    techTlCmnt.Tech_Tool__c=tech.techTool.id;
                    techTlCmnt.User__c=UserInfo.getUserId();
                    techTlCmnt.Comment__c = tech.techTool.Comments__c;
                    techTlCmnt.Copy_First_Value_del__c=tech.techTool.Comments__c;
                    techToolCommentInsert.add(techTlCmnt);
                }
            }        
        }         
        if(techListToUpdate.size() > 0){
            update techListToUpdate;
        }
        if(techToolCommentUpdate.size() > 0){
            update techToolCommentUpdate;
        }
        if(techToolCommentInsert.size()>0){
            insert techToolCommentInsert;   
        }
        PageReference pg=new PageReference('/'+OppID);
        return pg;
    }
    /*
      @Author: Rishab
      @Name: doCancel
      @Created Date: 
      @Description:
      @version: 1.0
    */ 
    public PageReference doCancel() {
         PageReference pg=new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
         return pg;
    }
    
}