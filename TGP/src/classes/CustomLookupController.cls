/**
   @Author : Madhusudhan
   @name   : CustomLookupController 
   @CreateDate : 1 April 2015 
   @Description : This class is used for custom lookup functionaliy in new Opportunity Team page
   @Version : 1.0 
  */
public without sharing class CustomLookupController {

    public String searchText{get; set;}
    public String objName {get; set;}
    public String fieldName{get; set;}
    public String oppId{get; set;}
    public String query{get; set;}
    public String profileName{get; set;}
    public list<SObject> objList{get; set;}
    public String rolemaster;
    
    public Boolean isRole{get;set;}
    public Boolean isScope{get;set;}
    public Boolean isTeamMember{get;set;}
   
    public List<Schema.FieldSetMember> teamOppFields;
    public List<Schema.FieldSetMember> solutionScopeFields;
    public List<Schema.FieldSetMember> userMasterFields;
    public Boolean isMore{get;set;}
    /****************
        @method :getTeamOppFields
        @ parameters : 
        none
        @return type :FieldSetMember
        @Description :This method is used for get fieldSet from Opportunity Team
    *******************/
    public List<Schema.FieldSetMember> getTeamOppFields() {
        return SObjectType.Opportunity_Roles_Master__c.FieldSets.teamOppFields.getFields();
    }
     /****************
        @method :getUserMasterFields
        @ parameters : none
        @return type :FieldSetMember
        @Description :This method is used for get fieldSet from User Master 
    *******************/
    public List<Schema.FieldSetMember> getUserMasterFields() {
        return SObjectType.User_Master__c.FieldSets.userMasterFields.getFields();
    }
      /****************
        @method :getSolutionScopeFields
        @ parameters : none
        @return type :FieldSetMember
        @Description :This method is used for get fieldSet from Solution Scope 
    *******************/
    public List<Schema.FieldSetMember> getSolutionScopeFields() {
        return SObjectType.Solution_Scope__c.FieldSets.solutionScopeFields.getFields();
    }
     /****************
        @method :getSolutionScopeFields
        @ parameters : none
        @return type :FieldSetMember
        @Description :This method is used for get fieldSet from Solution Scope 
    *******************/
    public CustomLookupController(){
        
        objName=ApexPages.currentPage().getParameters().get(UtilConstants.OBJECT_NAME);
        system.debug('objName---'+objName);
        searchText=ApexPages.currentPage().getParameters().get(UtilConstants.SEARCHTEXT);
        fieldName=ApexPages.currentPage().getParameters().get(UtilConstants.FIELDNAME);
        oppId=ApexPages.currentPage().getParameters().get(UtilConstants.OPPID);
        system.debug('oppId--- '+oppId);
        rolemaster=ApexPages.currentPage().getParameters().get(UtilConstants.ROLE);
        Profile p = [Select Name from Profile where Id =: userinfo.getProfileid() LIMIT 1];
        profileName=p.Name;
        searchString();  
    }
    /****************
        @method :searchString
        @ parameters : none
        @return type :None
        @Description :This method is used for get fieldSet from Solution Scope 
    *******************/
    public void searchString(){
        objList=new list<SObject>();
        system.debug('objName---'+objName);
        if(objName.equalsignorecase(UtilConstants.opproleobjectname)){
            isRole=true; 
                query=baseQueryRole();
                if(searchText!=UtilConstants.BLANK_SPACE&&searchText!=null){
                    if(searchText.startsWith(UtilConstants.ASTRIC)){
                        searchText=searchText.substring(1, searchText.length());
                        query +=UtilConstants.CustlookUpCtlrSOQLPattern24 +searchText+ UtilConstants.CustlookUpCtlrSOQLPattern2;
                        searchText=UtilConstants.ASTERISK_OPRTR+searchText;
                    }else{
                        query +=UtilConstants.CustlookUpCtlrSOQLPattern3 +searchText+UtilConstants.CustlookUpCtlrSOQLPattern2;
                    }
                
                 system.debug('search Role-query -- '+query );
                }
                else{
                    query +=UtilConstants.CustlookUpCtlrSOQLPattern23;
                }
                objList = Database.query(query);
               system.debug('objList ----- '+objList);
                if(!(objList.size() >0)){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, UtilConstants.NoRolesavailable);
                    ApexPages.addMessage(myMsg);
                }
        }else if(objName.equalsignorecase(UtilConstants.solutionobject)){
                isScope=true;
                query=baseQueryScope();
               system.debug('baseQueryScope() ----- '+query);
                if(searchText!=UtilConstants.BLANK_SPACE &&searchText!=null){
                    if(searchText.startsWith(UtilConstants.ASTERISK_OPRTR)){
                        searchText=searchText.substring(1, searchText.length());
                        query +=UtilConstants.CustlookUpCtlrSOQLPattern22+searchText+UtilConstants.CustlookUpCtlrSOQLPattern2;
                        searchText=UtilConstants.ASTRIC+searchText;
                    }else{
                        query +=UtilConstants.CustlookUpCtlrSOQLPattern3+searchText+UtilConstants.CustlookUpCtlrSOQLPattern2;
                    }
                }
                else{
                    query +=UtilConstants.CustlookUpCtlrSOQLPattern23;
                }
               system.debug('search solution -query -- '+query );
                objList = Database.query(query);
                system.debug('objList -Solution---- '+objList); 
                if(!(objList.size() >0)){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'No Solution Scope/Offering added for selected Opportunity');
                    ApexPages.addMessage(myMsg);
                }
        }else if(objName.equalsignorecase(UtilConstants.usermasterobject)){
                isTeamMember=true;
                query=baseQueryTeamMember();
              
                if(('DMAT User').equalsignorecase(rolemaster)){
                   if(searchText!=''&&searchText!=null ){
                        if(searchText.startsWith(UtilConstants.ASTERISK_OPRTR)){
                            searchText=searchText.substring(1, searchText.length());
                            query +=' where Name like \'%'+searchText+ '%\' and Profile__c=\'DMAT User\' order by name limit 100';
                            searchText='*'+searchText;
                        }else{
                            query +=' where Name like \'%'+searchText+ '%\' and Profile__c=\'DMAT User\' order by name limit 100';
                        } 
                    }
                    else{
                        query +=' where Profile__c=\'DMAT User\' order by name limit 100'; 
                    }   
                }
                else if(searchText!=UtilConstants.BLANK_SPACE&&searchText!=null){
                    if(searchText.startsWith(UtilConstants.ASTERISK_OPRTR)){
                        searchText=searchText.substring(1, searchText.length());
                        query +=UtilConstants.CustlookUpCtlrSOQLPattern20+searchText+UtilConstants.CustlookUpCtlrSOQLPattern6;
                        searchText=UtilConstants.ASTRIC+searchText;
                    }else{
                        query +=UtilConstants.CustlookUpCtlrSOQLPattern16 +searchText+UtilConstants.CustlookUpCtlrSOQLPattern6 ;
                    } 
                }
                else{
                    query +=UtilConstants.ORDERLIMIT; 
                }
               
                objList = Database.query(query);
               
                if(!(objList.size() >0)){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, UtilConstants.nouseravailable);
                    ApexPages.addMessage(myMsg);
                }
            }
        }
      /****************
        @method :getSolutionScopeFields
        @ parameters : none
        @return type :FieldSetMember
        @Description :This method is used for get fieldSet from Solution Scope 
        *******************/
    public String baseQueryRole(){
            query = UtilConstants.selectword;
            for(Schema.FieldSetMember f : this.getTeamOppFields()) {
                query += f.getFieldPath() +UtilConstants.COMMA_STRING;
            }
            
            query +=UtilConstants.CustlookUpCtlrSOQLPattern18 ;
            
            if( profileName.startsWith(UtilConstants.IO_solution)){
                query +=UtilConstants.CustlookUpCtlrSOQLPattern17;
            }else if( profileName.startsWith(UtilConstants.IC_solution)){
                query +=UtilConstants.CustlookUpCtlrSOQLPattern10;
            }else if(UtilConstants.IS_PMO_OPP.equalsIgnoreCase(profileName)){
                //query +=' IC_Role__c=True'+' '+'or'+UtilConstants.CustlookUpCtlrSOQLPattern17;
                query +=UtilConstants.querypattern15;
            }else if(profileName.startsWith(UtilConstants.mobilization) || profileName.startsWith(UtilConstants.solution) ){
                query +=UtilConstants.CustlookUpCtlrSOQLPattern11;
            }else if( profileName.startsWith(UtilConstants.SYSTEM_ADMIN )){
                query +=UtilConstants.CustlookUpCtlrSOQLPattern12;
            }
            return query;
    }
     /****************
        @method :getSolutionScopeFields
        @ parameters : none
        @return type :FieldSetMember
        @Description :This method is used for get fieldSet from Solution Scope 
    *******************/
    public String baseQueryScope(){
            query = UtilConstants.selectword;
            for(Schema.FieldSetMember f : this.getSolutionScopeFields()) {
                query += f.getFieldPath() +UtilConstants.COMMA_STRING;
            }
            
            if(rolemaster.EQUALS(UtilConstants.TECHNICAL_ARCHITECT)){

                
                query +=UtilConstants.CustlookUpCtlrSOQLPattern13+oppId+UtilConstants.CustlookUpCtlrSOQLPattern211;
                system.debug('query ---------------------- '+query );
            }
            else{
                query +=UtilConstants.CustlookUpCtlrSOQLPattern13+oppId+UtilConstants.CustlookUpCtlrSOQLPattern14;
            }
            return query;
    }
     /****************
        @method :getSolutionScopeFields
        @ parameters : none
        @return type :FieldSetMember
        @Description :This method is used for get fieldSet from Solution Scope 
    *******************/
    public String baseQueryTeamMember(){
            query = UtilConstants.selectword;
            for(Schema.FieldSetMember f : this.getUserMasterFields()) {
                query += f.getFieldPath() + UtilConstants.COMMA_STRING;
            }
            query +=UtilConstants.CustlookUpCtlrSOQLPattern15 ;
        return query;   
    }
    
}