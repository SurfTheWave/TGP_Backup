@RestResource(urlMapping='/Permission/1.0/*')
/*
  @Author: Aswajit Swain
  @Name: HidePermissionService
  @Created Date: 05 Oct 2015
  @Description:
  @version: 1.0
*/
global class HidePermissionService {
     /*
      @Author: Aswajit Swain
      @Name: permissionSetService
      @Created Date: 05 Oct 2015
      @Parms :  
      @Description: 
      @version: 1.0
    */
    @Httpget global static Boolean permissionSetService(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Boolean isAccess= false;
        if(req.params.get('type') =='Solution Report'){
            List<PermissionSetAssignment> pmList = [SELECT Id, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId =:UserInfo.getUserId()];
            for(PermissionSetAssignment pm: pmList){
                if(pm.PermissionSet.Name == 'Report_Editor_Permission_Set'){
                    isAccess = true;
                }
            }
        }else{
            User user= [SELECT Id, Profile.Name FROM User WHERE Id =:UserInfo.getUserId() LIMIT 1];
            String pName=user.Profile.Name;
            if(pName == 'IC Solution Editor' || pName =='IC Solution Read Only' || pName =='IO Solution Read Only' || pName =='IO Solution Editor' || pName =='Solution Editor' || pName =='Solution Read Only' || pName =='Mobilization Read Only' || pName =='Mobilization Editor' || pName =='Workbench Read Only' || pName =='Dmat User' || pName =='Workbench User' ){
                isAccess = true;
            }
            /*if(pName == 'IC Solution Operations'){
                Opportunity opp =[SELECT IC_Opportunity__c From Opportunity WHERE Id='006c000000DfDnz' AND IC_Opportunity__c=true LIMIT 1];
                System.debug('opp  -------------------'+ opp);
                if(opp != null){
                    isAccess = true;
                }
            }*/
        }
        return isAccess; 
     }
}