/**
   @Author : Madhusudhan
   @name   : CustomLookupController 
   @CreateDate :  May 5th 2015 
   @Description : This class is used for custom lookup functionality in client Specific Process page
   @Version : 1.0 
  */
public without sharing  class ClientProcessLookupController {

    public String searchText{get; set;}
    public String objName {get; set;}
    public String fieldName{get; set;}
    public String OfferId{get; set;}
    public String query{get; set;}
    public list<SObject> objList{get; set;}
    
    public Boolean isOffering{get;set;}
    public Boolean isServices{get;set;}
    public Boolean isServiceComponent{get;set;}
    public Boolean isClientProces{get;set;}
    public Boolean isInfrastructure{get;set;}
    public Boolean isDeliveryLoc{get;set;}
   
    public List<Schema.FieldSetMember> offeringMasterFields;
    public List<Schema.FieldSetMember> ServiceMasterfieldSet;
    public List<Schema.FieldSetMember> ServiceComponentfieldSet;
    public List<Schema.FieldSetMember> ClientProcessfieldSet;
    public List<Schema.FieldSetMember> InfrastructurefieldSet;
    public List<Schema.FieldSetMember> deliveryLocMasterfieldSet;
    
    public Boolean isMore{get;set;}
    /****************
    @method :getTeamOppFields
    @ parameters : 
    none
    @return type :FieldSetMember
    @Description :This method is used for get fieldSet from Opportunity Team
  *******************/
    public List<Schema.FieldSetMember> getOfferingMasterFields() {
        return SObjectType.Offering_Master__c.FieldSets.offeringMasterFields.getFields();
    }
    /****************
    @method :getSolutionScopeFields
    @ parameters : none
    @return type :FieldSetMember
    @Description :This method is used for get fieldSet from Solution Scope 
  *******************/
    public List<Schema.FieldSetMember> getServiceMasterfieldSet() {
        return SObjectType.Services_Master__c.FieldSets.ServiceMasterfieldSet.getFields();
    }
     /****************
    @method :getUserMasterFields
    @ parameters : none
    @return type :FieldSetMember
    @Description :This method is used for get fieldSet from User Master 
    *******************/
    public List<Schema.FieldSetMember> getServiceComponentfieldSet() {
        return SObjectType.Services_Component_Master__c.FieldSets.ServiceComponentfieldSet.getFields();
    }
     /****************
    @method :getClientProcessfieldSet
    @ parameters : none
    @return type :FieldSetMember
    @Description :This method is used for get fieldSet from Client Specific Process  
    *******************/
    public List<Schema.FieldSetMember> getClientProcessfieldSet() {
        return SObjectType.Client_Specific_Process__c.FieldSets.ClientProcessfieldSet.getFields();
    }
    
    
         /****************
    @method :getInfraStructurefieldSet
    @ parameters : none
    @return type :FieldSetMember
    @Description :This method is used for get fieldSet from Client Specific Process  
    *******************/
    public List<Schema.FieldSetMember> getInfraStructurefieldSet() {
        return SObjectType.Infrastructure_Service__c.FieldSets.InfraStructurefieldSet.getFields();
    }
    
    
     /****************
    @method :getDeliveryLocMasterfieldSet
    @ parameters : none
    @return type :FieldSetMember
    @Description :This method is used for get fieldSet from Delivery Location Master  
    *******************/
    public List<Schema.FieldSetMember> getDeliveryLocMasterfieldSet() {
        return SObjectType.Delivery_Location_Masters__c.FieldSets.deliveryLocMasterfieldSet.getFields();
    }
   /****************
    @method :getSolutionScopeFields
    @ parameters : none
    @return type :FieldSetMember
    @Description :This method is used for get fieldSet from Solution Scope 
  *******************/
    public ClientProcessLookupController(){
        
        objName=ApexPages.currentPage().getParameters().get(UtilConstants.OBJECT_NAME);
        searchText=ApexPages.currentPage().getParameters().get(UtilConstants.SEARCHTEXT);
        fieldName=ApexPages.currentPage().getParameters().get(UtilConstants.FIELDNAME);
        OfferId=ApexPages.currentPage().getParameters().get(UtilConstants.id_par);       
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
        if(objName.equalsignorecase(UtilConstants.OFFERING_MASTER_OBJ)){
            isOffering=true; 
                query=baseQueryOfferingMaster();
                if(!string.isBlank(searchText)){
                    if(searchText.startsWith(UtilConstants.ASTRIC)){
                        searchText=searchText.substring(1, searchText.length());
                        query +=UtilConstants.querypattern14+searchText+UtilConstants.CustlookUpCtlrSOQLPattern2;
                        searchText=UtilConstants.ASTERISK_OPRTR+searchText;
                    }else{
                        query +=UtilConstants.querypattern13+searchText+UtilConstants.CustlookUpCtlrSOQLPattern2;
                    }
                
                 system.debug('search Offering-query -- '+query );
                }
                else{
                    query +=utilConstants.querypattern12;
                }
                objList = Database.query(query);
               system.debug('objList ----- '+objList);
                if(!(objList.size() >0)){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,UtilConstants.PROCESS_OFF_NOT_AVAILABLE);
                    ApexPages.addMessage(myMsg);
                }
            }
            /////////////////
            else if(objName.equalsignorecase(UtilConstants.OFFERINF_MASTER_IO)){
            isOffering=true; 
                query=baseQueryOfferingMaster();
                if(!string.isBlank(searchText)){
                    if(searchText.startsWith(UtilConstants.ASTRIC)){
                        searchText=searchText.substring(1, searchText.length());
                        query +=UtilConstants.querypattern11+searchText+UtilConstants.CustlookUpCtlrSOQLPattern2;
                        searchText=UtilConstants.ASTERISK_OPRTR+searchText;
                    }else{
                        query +=UtilConstants.querypattern10+searchText+UtilConstants.CustlookUpCtlrSOQLPattern2;
                    }
                
               system.debug('search Offering-query -- '+query );
                }
                else{
                    query +=UtilConstants.QUERY9;
                }
                objList = Database.query(query);
                system.debug('objList ----- '+objList);
                if(!(objList.size() >0)){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,UtilConstants.PROCESS_OFF_NOT_AVAILABLE);
                    ApexPages.addMessage(myMsg);
                }
            }
            /////////////////
            else if(objName.equalsignorecase(UtilConstants.SERVICE_MASTER_OBJ)){
                isServices=true;
               system.debug('baseQueryTeamMember() ----- '+query);
               if(!string.isBlank(OfferId)){
                    query=baseQueryServicesMaster();
                    if(!string.isBlank(searchText)){
                        if(searchText.startsWith(UtilConstants.ASTERISK_OPRTR)){
                            searchText=searchText.substring(1, searchText.length());
                            query +=UtilConstants.CustlookUpCtlrSOQLPattern20+searchText+utilConstants.querypattern9+OfferId+UtilConstants.querypattern3;
                            searchText=UtilConstants.ASTRIC+searchText;
                        }else{
                            query +=UtilConstants.CustlookUpCtlrSOQLPattern16 +searchText+utilConstants.querypattern9+OfferId+UtilConstants.querypattern3;
                        } 
                    }
                    else{
                        query +=UtilConstants.querypattern8+OfferId+UtilConstants.querypattern3; 
                    }
                    system.debug('search Team Member -query -- '+query );
                    objList = Database.query(query);
                    system.debug('objList --Team member--- '+objList);  
                    if(!(objList.size() >0)){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,UtilConstants.PROC_SER_NOT_AVAILABLE);
                        ApexPages.addMessage(myMsg);
                    }
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,UtilConstants.PLEASE_SELECT_OFFERING);
                    ApexPages.addMessage(myMsg);
                }
                
            }
            else if(objName.equalsignorecase(UtilConstants.SERVICE_COMP_MASTER_OBJ)){
                isServiceComponent=true;
                if(!string.isBlank(OfferId)){
                    query=baseQueryServicesComponentMaster();
                   system.debug('baseQueryTeamMember() ----- '+query);
                    if(!string.isBlank(searchText)){
                        if(searchText.startsWith(UtilConstants.ASTERISK_OPRTR)){
                            searchText=searchText.substring(1, searchText.length());
                            query +=UtilConstants.CustlookUpCtlrSOQLPattern20+searchText+UtilConstants.querypattern7+OfferId+UtilConstants.querypattern3;
                            searchText=UtilConstants.ASTRIC+searchText;
                        }else{
                            query +=UtilConstants.CustlookUpCtlrSOQLPattern16+searchText+UtilConstants.querypattern7+OfferId+UtilConstants.querypattern3;
                        } 
                    }
                    else{
                        query +=UtilConstants.querypattern5+OfferId+UtilConstants.querypattern6; 
                    }
                    system.debug('search Team Member -query -- '+query );
                    objList = Database.query(query);
                    system.debug('objList --Team member--- '+objList);  
                    if(!(objList.size() >0)){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,UtilConstants.PROC_SER_COMP_NOT_AVAILABLE);
                        ApexPages.addMessage(myMsg);
                    }
                }
                else{
                    //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,UtilConstants.PLEASE_SELECT_PROC_SER_COMP);
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,UtilConstants.PLEASE_SELECT_OFFERING);
                    ApexPages.addMessage(myMsg);
                }
            }
            
            
            else if(objName.equalsignorecase(UtilConstants.CLIENT_SPECIFIC_PROC_OBJ)){
                isClientProces=true;
               
                query=baseQueryClientSpecificProcess();
                system.debug('baseQueryTeamMember() ----- '+query);
                if(!string.isBlank(searchText)){
                    if(searchText.startsWith(UtilConstants.ASTERISK_OPRTR)){
                        searchText=searchText.substring(1, searchText.length());
                        query +=UtilConstants.querypattern1+OfferId+UtilConstants.querypattern4+searchText+UtilConstants.CustlookUpCtlrSOQLPattern6;
                        searchText=UtilConstants.ASTRIC+searchText;
                    }else{
                        query +=UtilConstants.querypattern1+OfferId+UtilConstants.querypattern2+searchText+UtilConstants.CustlookUpCtlrSOQLPattern6;
                    } 
                }
                else{
                    query +=UtilConstants.querypattern1+OfferId+UtilConstants.querypattern3; 
                }
                system.debug('search Team Member -query -- '+query );
                objList = Database.query(query);
                system.debug('objList --Team member--- '+objList);  
                if(!(objList.size() >0)){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,UtilConstants.CLIENT_PROC_NOT_AVAILABLE);
                    ApexPages.addMessage(myMsg);
                }
               
            }
            
            else if(objName.equalsignorecase(UtilConstants.INFRASTRUCTURE_SERVICE)){
                isInfrastructure=true;
               
                query=baseQueryInfraStructure();
               system.debug('baseQueryTeamMember() ----- '+query);
                if(!string.isBlank(searchText)){
                    if(searchText.startsWith(UtilConstants.ASTERISK_OPRTR)){
                        searchText=searchText.substring(1, searchText.length());
                        query +=UtilConstants.querypattern1+OfferId+UtilConstants.querypattern4+searchText+UtilConstants.CustlookUpCtlrSOQLPattern6;
                        searchText=UtilConstants.ASTRIC+searchText;
                    }else{
                        query +=UtilConstants.querypattern1+OfferId+UtilConstants.querypattern2+searchText+UtilConstants.CustlookUpCtlrSOQLPattern6;
                    } 
                }
                else{
                    query +=UtilConstants.querypattern1+OfferId+UtilConstants.querypattern3; 
                }
               system.debug('search Team Member -query -- '+query );
                objList = Database.query(query);
                system.debug('objList --Team member--- '+objList);  
                if(!(objList.size() >0)){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,UtilConstants.INFRA_NOT_AVAILABLE);
                    ApexPages.addMessage(myMsg);
                }
               
            }
            else if(objName.equalsignorecase(UtilConstants.DEL_LOC_MASTER) ||objName.equalsignorecase(UtilConstants.DEL_LOC_MASTER_C1) ){
                isDeliveryLoc=true;
               
                query=baseQueryDeliveryLocation();
                system.debug('baseQueryTeamMember() ----- '+query);
                if(!string.isBlank(searchText)){
                    if(searchText.startsWith(UtilConstants.ASTERISK_OPRTR)){
                        searchText=searchText.substring(1, searchText.length());
                        query +=UtilConstants.querypattern1+OfferId+UtilConstants.querypattern4+searchText+UtilConstants.CustlookUpCtlrSOQLPattern6;
                        searchText=UtilConstants.ASTRIC+searchText;
                    }else{
                        query +=UtilConstants.querypattern1+OfferId+UtilConstants.querypattern2+searchText+UtilConstants.CustlookUpCtlrSOQLPattern6 ;
                    } 
                }
                else{
                    query +=UtilConstants.ORDERLIMIT; 
                }
                system.debug('search Team Member -query -- '+query );
                objList = Database.query(query);
                system.debug('objList --Team member--- '+objList);  
                if(!(objList.size() >0)){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,UtilConstants.DEL_LOC_NOT_AVAILABLE);
                    ApexPages.addMessage(myMsg);
                }             
            }
            
        }
      /****************
    @method :baseQueryOfferingMaster
    @ parameters : none
    @return type :String
    @Description :This method is used to create the base query for Offering Master
    *******************/
    public String baseQueryOfferingMaster(){
            query = UtilConstants.selectword;
            for(Schema.FieldSetMember f : this.getOfferingMasterFields()) {
                query += f.getFieldPath() + UtilConstants.COMMA_STRING;
            }
            system.debug('query ----- '+query );
            query +=UtilConstants.QUERY6;
          
            return query;
    }
    /****************
    @method :getSolutionScopeFields
    @ parameters : none
    @return type :FieldSetMember
    @Description :This method is used for get fieldSet from Solution Scope 
  *******************/
    public String baseQueryServicesMaster(){
            query = UtilConstants.selectword;
            for(Schema.FieldSetMember f : this.getServiceMasterfieldSet()) {
                query += f.getFieldPath() + UtilConstants.COMMA_STRING;
            }
            system.debug('query ----- '+query );
            query +=UtilConstants.QUERY4;
            return query;
    }
    /****************
    @method :baseQueryServicesComponentMaster
    @ parameters : none
    @return type :String
    @Description :This method is used to create the base query for services Component Master
  *******************/
    public String baseQueryServicesComponentMaster(){
            query = UtilConstants.selectword;
            for(Schema.FieldSetMember f : this.getServiceComponentfieldSet()) {
                query += f.getFieldPath() + UtilConstants.COMMA_STRING;
            }
            system.debug('query ----- '+query );
            query +=UtilConstants.QUERY5;
            return query;
    }
    /****************
    @method :baseQueryClientSpecificProcess
    @ parameters : none
    @return type :String
    @Description :This method is used to create the base query for client Specific Process
  *******************/
    public String baseQueryClientSpecificProcess(){
            query = UtilConstants.selectword;
            for(Schema.FieldSetMember f : this.getClientProcessfieldSet()) {
                query += f.getFieldPath() + UtilConstants.COMMA_STRING;
            }
            system.debug('query ----- '+query );
            query +=UtilConstants.QUERY3;
            return query;
    }
    
    
        /****************
    @method :baseQueryInfraStructure
    @ parameters : none
    @return type :String
    @Description :This method is used to create the base query for client Specific Process
  *******************/
    public String baseQueryInfraStructure(){
            query = UtilConstants.selectword;
            for(Schema.FieldSetMember f : this.getInfraStructurefieldSet()) {
                query += f.getFieldPath() + UtilConstants.COMMA_STRING;
            }
            system.debug('query ----- '+query );
            query +=UtilConstants.QUERY2;
            return query;
    }
    
    /****************
    @method :baseQueryClientSpecificProcess
    @ parameters : none
    @return type :String
    @Description :This method is used to create the base query for client Specific Process
  *******************/
    public String baseQueryDeliveryLocation(){
            query = UtilConstants.selectword;
            for(Schema.FieldSetMember f : this.getDeliveryLocMasterfieldSet()) {
                query += f.getFieldPath() + UtilConstants.COMMA_STRING;
            }
          system.debug('query ----- '+query );
            query +=UtilConstants.QUERY1;
            return query;
    }
}