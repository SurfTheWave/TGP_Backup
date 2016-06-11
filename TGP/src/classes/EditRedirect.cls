Public class EditRedirect{
    public string error{get;set;}
    public boolean displayPopup {get; set;}
    public boolean shareAccess=false;
    public boolean access=false;
    public boolean accessIC=false;
    public boolean accessSolScope=false;
    public integer solScope;
    public Costing_Request__c Record;
    public Costing_Request__c costingRequest;
    public EditRedirect(ApexPages.StandardController controller) {
        costingRequest = (Costing_Request__c)controller.getRecord(); 
    }

    public pageReference checkEditAccess(){
        PageReference pg;
        string permission;
        string serviceGrp='';
        Record=[SELECT Id, Opportunity__c,Opportunity__r.Service_Grp__c,Last_Checked_Out_By_Dev__c,Is_Checked_Out__c
                FROM Costing_Request__c where Id=:costingRequest.id ];
        solScope=[SELECT Count() FROM Solution_scope__c where opportunity__c=:Record.Opportunity__c and solution_component__c='Delivery' ];
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
         Map<String, Read_Access_Profiles__c> allProfiles= Read_Access_Profiles__c.getAll(); 
         String srvGrp = ApexPages.currentPage().getParameters().get('SG');
          if(Record.Opportunity__r.Service_Grp__c == null && srvGrp == null){
            displayPopup =true;
            error='Opportunity is not tagged to any service group, Costing can\'t be Done';
            pg = null;
          }
          else if(solScope == 0){
                displayPopup =true;
                error='No active delivery scope has been added for the opportunity. Please add scope from the “Solution Scope” screen to load costing page.';
                pg = null;           
          }
          else if(record.Opportunity__r.Service_Grp__c == 'IC'){
                displayPopup =true;
                error='Costing is Not Applicable for IC Deals';
                pg = null;                   
          }
          else{
            permission = ProfileMatrix.giveAccessLevel(profileName,Record.Opportunity__r.Service_Grp__c,Record.Opportunity__c,userinfo.getuserid()); 
            boolean userHasAccess = UserRecordAccess.getHasEditAccess(userinfo.getuserid(),Record.opportunity__c);
            if(permission!='E' && !userHasAccess){
                displayPopup =true;
                error='You do not have access to Costing Request Record.';
                pg = null;  
            }
            else{
            if(srvGrp == null){
            if(record.Opportunity__r.Service_Grp__c!='BPO' && record.Opportunity__r.Service_Grp__c!='IO'){
            if(record.Opportunity__r.Service_Grp__c == 'IO + IC'){
                serviceGrp = 'IO';
            }
            else if(profilename.contains('IO') || profileName == 'IS PMO Operations'){
                serviceGrp = 'IO';
            }
            else{
                serviceGrp = 'BPO';
            }
            }
            else{
                serviceGrp = Record.Opportunity__r.Service_Grp__c;
            } 
            }
            else{
                serviceGrp =srvGrp;
            }           
            /*else{
                serviceGrp ='BPO';
            } */   
            
           /*) else{
                Map<String, Read_Access_Profiles__c> readProfiles =  Read_Access_Profiles__c.getAll();
                //readProfiles =[select Name from Read_Access_Profiles__c where name=:profileName LIMIT 1];
                 if(readProfiles.get(profileName) != null){
                     displayPopup =true;
                     error='You do not have access to Costing Request Record.';
                     pg = null;   
                 }                    
                else if(profileName=='System Administrator' || profileName=='Solution Operations' ||profileName=='IO Solution Operations' || profileName.equalsignorecase('IS PMO Operations')){
                    pg=new PageReference('/apex/EditCanvas?id='+Record.id+'&SG='+serviceGrp);           
                }
                else{          
                    boolean accessEdit1 = UserRecordAccess.getHasEditAccess(userinfo.getUserId(),Record.Opportunity__c);
                    if(accessEdit1){
                       pg=new PageReference('/apex/EditCanvas?id='+Record.id+'&SG='+serviceGrp);                                  
                    }
                    else{
                        displayPopup =true;
                        error='You do not have access to Costing Request Record.';
                        pg = null;                     
                    }  
                }  
             } */
             pg=new PageReference('/apex/EditCanvas?id='+Record.id+'&SG='+serviceGrp);
             }  
            }        
    return pg;
    }
    public PageReference popUpRedirect(){
         PageReference pg=new PageReference('/'+Record.Opportunity__c);
         return pg;    
     }
}