public without sharing class SchedulingInline_Controller {

    public String oppId{get;set;}
    public List<Opportunity_TGP__c> lstUserAssignment;
    public List<Opportunity_Offering__c> lstOfferings;
    public List<Scheduling__c> lstScheduling{get; set;}
    public String mondayDate{get; set;}
    public String nextMondayDate{get; set;}
    public String nextMondayDate1{get; set;}
    public String nextMondayDate2{get; set;}
    public List<String> header{get; set;}
    public boolean isEdit{get; set;}
    public boolean isDetail{get; set;}
    public List<Scheduling__c> lstSc{get; set;}
    public Boolean addButtonRender{get;set;}
    public Boolean nonAdminUser{get; set;}
    Date d;
    List<Scheduling__c> lstSc1;
    Set<Id> idList = new Set<Id>(); 
    public Set<String> lstOfferingsForPrimaryUser;
    public Set<String> lstOfferingsForSecondryUser;
    public Set<String> lstOfferingsForDomainExpUser;
    public Set<String> lstOfferingsForDomainExp1User;
    public Set<String> lstOfferingsForDomainExp2User;
    public Set<String> lstOfferingsForDomainExp3User;
    public Set<String> lstOfferingsForDomainExp4User;
    public Set<String> lstOfferingsForTechArcUser;
    public Set<String> lstOfferingsForSolSpcUser;
    public Set<String> lstOfferingsForFuncUser;
    ApexPages.StandardController opportunityObj = null;
    
    public SchedulingInline_Controller(ApexPages.StandardController controller) 
    {
        opportunityObj = controller;
        isEdit = false;
        nonAdminUser = true;
        oppId = ApexPages.CurrentPage().getParameters().get('id');
        lstScheduling = new List<Scheduling__c>();
        String userProfileName = [select u.Profile.Name from User u where u.id = :UserInfo.getUserId()].Profile.Name; //Get users with Profile Name
        if(userProfileName.equalsIgnoreCase(UTIL_Constants.SOLUTION_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SYSTEM_ADMIN) || userProfileName.equalsIgnoreCase(UTIL_Constants.SUPER_ADMIN)) {
            addButtonRender=true;
            isEdit = true;
            nonAdminUser = false;
        }
        addButtonRender = UAMSolMobUtility.addButtonRender_BPOOppTgp;
        d = System.today();
        //To Test --> d = Date.valueOf('2013-11-18T00:00:00Z');
        //d = Date.parse('11/13/2013');     
        Date mondayDate1 = d.toStartofWeek();
        DateTime mondayDate2; 
        DateTime mondayDateTime = datetime.newInstance(mondayDate1.year(), mondayDate1.month(),mondayDate1.day());  
        datetime myDate = datetime.newInstance(d.year(), d.month(),d.day());  
        String DayOfWeek = myDate.format('EEEE');                            
        if(DayOfWeek.equalsignorecase('Sunday')) {
            mondayDate2 = mondayDateTime - 6;
        }
        else {
            mondayDate2 = mondayDateTime + 1;
        }
        //DateTime mondayDate2 = mondayDate1 + 1;
        DateTime mondayDate3 = mondayDate2 + 7;
        DateTime mondayDate4 = mondayDate3 + 7;
        DateTime mondayDate5 = mondayDate4 + 7;
        
        mondayDate = mondayDate2.format('dd-MMM'); 
        nextMondayDate = mondayDate3.format('dd-MMM');
        nextMondayDate1 = mondayDate4.format('dd-MMM');
        nextMondayDate2 = mondayDate5.format('dd-MMM');
         
       header = new List<String>();  
    
   }
   public pageReference Lable()
   {
        List<String> sameRec = new List<String>();
    
     lstOfferingsForPrimaryUser =  new Set<String>();
     lstOfferingsForSecondryUser = new Set<String>();
     lstOfferingsForDomainExpUser = new Set<String>();
     lstOfferingsForDomainExp1User = new Set<String>();
     lstOfferingsForDomainExp2User = new Set<String>();
     lstOfferingsForDomainExp3User = new Set<String>();
     lstOfferingsForDomainExp4User = new Set<String>();
     lstOfferingsForTechArcUser = new Set<String>();
     lstOfferingsForSolSpcUser = new Set<String>();
     lstOfferingsForFuncUser = new Set<String>();
     oppId = ApexPages.CurrentPage().getParameters().get('id');
          lstUserAssignment = [select Complex_Cost_Architect_New__c, Enterprise_Solution_Architect_New__r.Name,Complex_Cost_Architect_New__r.SFDC_User__c, Complex_Cost_Architect_New__r.Name,Enterprise_Solution_Architect_New__c,Enterprise_Solution_Architect_New__r.SFDC_User__c from Opportunity_TGP__c where id =: oppId];
          lstOfferings = [select Name,Solution_Lead_New__r.Name,Solution_Lead_New__c, Solution_Lead_New__r.SFDC_User__c, 
                                      Solution_Specialist_New__c,Solution_Specialist_New__r.Name, Solution_Specialist_New__r.SFDC_User__c,
                                      Functional_Architect_Mobilization_New__c,Functional_Architect_Mobilization_New__r.SFDC_User__c, Functional_Architect_Mobilization_New__r.Name,
                                      Offering_Solution_Lead_Secondary_New__c, Offering_Solution_Lead_Secondary_New__r.Name, Offering_Solution_Lead_Secondary_New__r.SFDC_User__c,
                                      Opportunity_TGP__c,
                                      Domain_Expert_Functional_Architect_New__c,Domain_Expert_Functional_Architect_New__r.Name, Domain_Expert_Functional_Architect_New__r.SFDC_User__c,
                                      Technical_Architect_New__c,Technical_Architect_New__r.SFDC_User__c, Technical_Architect_New__r.Name, 
                                      Domain_Expert_Functional_Architect_1_New__r.Name, Domain_Expert_Functional_Architect_1_New__r.SFDC_User__c, Domain_Expert_Functional_Architect_1_New__c,
                                      Domain_Expert_Functional_Architect_2_New__c, Domain_Expert_Functional_Architect_2_New__r.Name, Domain_Expert_Functional_Architect_2_New__r.SFDC_User__c,
                                      Domain_Expert_Functional_Architect_3_New__c,Domain_Expert_Functional_Architect_3_NEw__r.Name, Domain_Expert_Functional_Architect_3_New__r.SFDC_User__c,
                                      Domain_Expert_Functional_Architect_4_New__c,Domain_Expert_Functional_Architect_4_new__r.Name, Domain_Expert_Functional_Architect_4_new__r.SFDC_User__c
                                      from Opportunity_Offering__c where Opportunity_TGP__c =: oppId];
         
           lstSc = new List<Scheduling__c>();
           lstSc1 = new List<Scheduling__c>(); 
           
           // Code for tech Arch Changes 
           /*
           map<String, Id> approvalUserMasterEmailMappedToSfdcSolutionUser = new map<String, Id>();
           List<String> emailList = new List<String>();
           for(Review_User_Master__c approvalUserMaster : [Select Id, Email_ID_of_the_reviewer__c  from Review_User_Master__c]) {
               emailList.add(approvalUserMaster.Email_ID_of_the_reviewer__c);
           } 
           /*for(User userRecord : [Select Id,Email from user where Email IN:emailList
                                                                 AND Profile.Name = 'Solution Users' 
                                                                 AND UserRole.Name != 'Operations' 
                                                                 AND isActive = True]) {
                   approvalUserMasterEmailMappedToSfdcSolutionUser.put(userRecord.Email,userRecord.Id);
           }*/
           /*
           
           for(User userRecord : [Select Id,Email from user where Email IN:emailList
                                                                 AND Profile.Name = 'Workbench User' 
                                                                 AND isActive = True]) {
                   approvalUserMasterEmailMappedToSfdcSolutionUser.put(userRecord.Email,userRecord.Id);
           }
           */
                    
           // code end tech arch changes
           
           String type_1='Opportunity_TGP__c';
           String type_2='Opportunity_Offering__c';
        
           Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
           Schema.SObjectType leadSchema = schemaMap.get(type_1);
           Schema.SObjectType leadSchema1 = schemaMap.get(type_2);
           Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
           Map<String, Schema.SObjectField> fieldMap1 = leadSchema1.getDescribe().fields.getMap();
           
           if(lstUserAssignment.size()>0)
           {  
               for(Opportunity_TGP__c eachUser : lstUserAssignment)  
               {      
                      for (String fieldName: fieldMap.keySet()) 
                      {
            
                          if(fieldName == 'enterprise_solution_architect_New__c') 
                          {
                                Scheduling__c obj = new Scheduling__c();  
                                String label = fieldMap.get(fieldName).getDescribe().getLabel();//It provides to get the object fields label.
                
                                if(eachUser.Enterprise_Solution_Architect_New__c != null && eachUser.Enterprise_Solution_Architect_New__r.SFDC_User__c != null)
                                {                                  
                                    idList.add(eachUser.Enterprise_Solution_Architect_New__c);               
                                    obj.Role_Name__c = label;
                                    obj.User_Name__c =  eachUser.Enterprise_Solution_Architect_New__r.Name;
                                    obj.BPO_Opportunity_MD__c = oppId;
                                    obj.User_Id__c = eachUser.Enterprise_Solution_Architect_New__r.SFDC_User__c;
                                    lstSc1.add(obj);
                                }
                         }
    
                   }
                   
                }
            }
            if(lstOfferings.size()>0)
            {
                for(Opportunity_Offering__c offerings : lstOfferings) 
                {
                    for(String fieldName1: fieldMap1.keySet())
                    {                      
                         if(fieldName1 == 'Solution_Lead_New__c') 
                         {
                            Scheduling__c obj = new Scheduling__c();
                            String label = fieldMap1.get(fieldName1).getDescribe().getLabel();//It provides to get the object fields label.
                            if(offerings.Solution_Lead_New__c != null)
                            {
                                    if(lstOfferingsForPrimaryUser.isEmpty())
                                    {
                                        lstOfferingsForPrimaryUser.add(offerings.Solution_Lead_New__c); 
                                        idList.add(offerings.Solution_Lead_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Solution_Lead_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Solution_Lead_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                    }
                                    else if(lstOfferingsForPrimaryUser.contains(offerings.Solution_Lead_New__c))                        
                                    {
                                        sameRec.add(offerings.Solution_Lead_New__c);
                                    
                                    }
                                    else
                                    {
                                        lstOfferingsForPrimaryUser.add(offerings.Solution_Lead_New__c);
                                        idList.add(offerings.Solution_Lead_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Solution_Lead_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Solution_Lead_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                    }
                                
                                
                            }
                         }
        
                         
                        if(fieldName1 == 'Offering_Solution_Lead_Secondary_New__c') 
                        {
                    
                            Scheduling__c obj = new Scheduling__c();  
                            String label = fieldMap1.get(fieldName1).getDescribe().getLabel();//It provides to get the object fields label.

                            if(offerings.Offering_Solution_Lead_Secondary_New__c != null)
                            {
                                    if(lstOfferingsForSecondryUser.isEmpty())
                                    {
                                        lstOfferingsForSecondryUser.add(offerings.Offering_Solution_Lead_Secondary_New__c); 
                                        idList.add(offerings.Offering_Solution_Lead_Secondary_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Offering_Solution_Lead_Secondary_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Offering_Solution_Lead_Secondary_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                    }
                                    else if(lstOfferingsForSecondryUser.contains(offerings.Offering_Solution_Lead_Secondary_New__c))                        
                                    {
                                        sameRec.add(offerings.Offering_Solution_Lead_Secondary_New__c);
                                    
                                    }
                                    else
                                    {
                                        lstOfferingsForSecondryUser.add(offerings.Offering_Solution_Lead_Secondary_New__c); 
                                        idList.add(offerings.Offering_Solution_Lead_Secondary_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Offering_Solution_Lead_Secondary_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Offering_Solution_Lead_Secondary_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                    }                            
                                
                            }     
                        }
                        if(fieldName1 == 'Technical_Architect_New__c') 
                        {
                    
                            Scheduling__c obj = new Scheduling__c(); 

                            String label = fieldMap1.get(fieldName1).getDescribe().getLabel();//It provides to get the object fields label.

                            if(offerings.Technical_Architect_New__c != null)
                            {
                                if(lstOfferingsForTechArcUser.isEmpty())
                                    {
                                        lstOfferingsForTechArcUser.add(offerings.Technical_Architect_New__c);   
                                        idList.add(offerings.Technical_Architect_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Technical_Architect_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Technical_Architect_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                
                                    }
                                    else if(lstOfferingsForTechArcUser.contains(offerings.Technical_Architect_New__c))                          
                                    {
                                        sameRec.add(offerings.Technical_Architect_New__c);
                                    
                                    }
                                    else
                                    {
                                        lstOfferingsForTechArcUser.add(offerings.Technical_Architect_New__c);
                                        idList.add(offerings.Technical_Architect_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Technical_Architect_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Technical_Architect_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                    }  
                                
                            }
                            
                    } 
                    /*
                    if(fieldName1 == 'Technical_Architect_New__c') 
                    {
                
                        Scheduling__c obj = new Scheduling__c(); 

                        String label = fieldMap1.get(fieldName1).getDescribe().getLabel();//It provides to get the object fields label.

                        if(offerings.Technical_Architect_New__c != null)
                        {
                            // utilityClass utilityClassInstance = new utilityClass();
                            // Id sfdcUserIdTechArch = utilityClassInstance.getSFDCSolutionUserIDfromApprovalUserMasterId(offerings.Technical_Architect_New__c);
                            Id sfdcUserIdTechArch = approvalUserMasterEmailMappedToSfdcSolutionUser.get(offerings.Technical_Architect_New__r.Email_ID_of_the_reviewer__c);
                            if(lstOfferingsForTechArcUser.isEmpty())
                                {
                                    lstOfferingsForTechArcUser.add(offerings.Technical_Architect_New__c);   
                                    idList.add(sfdcUserIdTechArch);
                                    obj.Role_Name__c = label;
                                    obj.User_Name__c =  offerings.Technical_Architect_New__r.name;
                                    obj.BPO_Opportunity_MD__c = oppId;
                                    obj.User_Id__c = sfdcUserIdTechArch;
                                    obj.offerings__c = offerings.Id;
                                    lstSc1.add(obj);
                            
                                }
                                else if(lstOfferingsForTechArcUser.contains(offerings.Technical_Architect_New__c))                          
                                {
                                    sameRec.add(offerings.Technical_Architect_New__c);
                                
                                }
                                else
                                {
                                    lstOfferingsForTechArcUser.add(offerings.Technical_Architect_New__c);
                                    idList.add(sfdcUserIdTechArch);
                                    obj.Role_Name__c = label;
                                    obj.User_Name__c =  offerings.Technical_Architect_New__r.name;
                                    obj.BPO_Opportunity_MD__c = oppId;
                                    obj.User_Id__c = sfdcUserIdTechArch ;
                                    obj.offerings__c = offerings.Id;
                                    lstSc1.add(obj);
                                }  
                            
                        }
                        
                    }
                    */
                    
                        if(fieldName1 == 'Solution_Specialist_New__c') 
                        {
                    
                            Scheduling__c obj = new Scheduling__c();   
                            String label = fieldMap1.get(fieldName1).getDescribe().getLabel();//It provides to get the object fields label.

                            if(offerings.Solution_Specialist_New__c != null)
                            {
                                if(lstOfferingsForSolSpcUser.isEmpty())
                                    {
                                        lstOfferingsForSolSpcUser.add(offerings.Solution_Specialist_New__c);    
                                        idList.add(offerings.Solution_Specialist_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Solution_Specialist_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Solution_Specialist_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                    }
                                    else if(lstOfferingsForSolSpcUser.contains(offerings.Solution_Specialist_New__c))                       
                                    {
                                        sameRec.add(offerings.Solution_Specialist_New__c);
                                    
                                    }
                                    else
                                    {
                                        lstOfferingsForSolSpcUser.add(offerings.Solution_Specialist_New__c);
                                        idList.add(offerings.Solution_Specialist_new__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Solution_Specialist_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Solution_Specialist_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                    } 
                                
                            }          
                        }
                        
                         if(fieldName1 == 'Functional_Architect_Mobilization_New__c') 
                        {
                    
                            Scheduling__c obj = new Scheduling__c();   
                            String label = fieldMap1.get(fieldName1).getDescribe().getLabel();//It provides to get the object fields label.

                            if(offerings.Functional_Architect_Mobilization_New__c != null)
                            {
                                if(lstOfferingsForFuncUser.isEmpty())
                                    {
                                        lstOfferingsForFuncUser.add(offerings.Functional_Architect_Mobilization_New__c);    
                                        idList.add(offerings.Functional_Architect_Mobilization_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Functional_Architect_Mobilization_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Functional_Architect_Mobilization_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                    }
                                    else if(lstOfferingsForFuncUser.contains(offerings.Functional_Architect_Mobilization_New__c))                       
                                    {
                                        sameRec.add(offerings.Functional_Architect_Mobilization_New__c);
                                    
                                    }
                                    else
                                    {
                                        lstOfferingsForFuncUser.add(offerings.Functional_Architect_Mobilization_New__c);
                                        idList.add(offerings.Functional_Architect_Mobilization_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Functional_Architect_Mobilization_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Functional_Architect_Mobilization_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                    } 
                                
                            }          
                        }
                        
                      if(fieldName1 == 'Domain_Expert_Functional_Architect_New__c') 
                      {
                    
                            Scheduling__c obj = new Scheduling__c();   

                            String label = fieldMap1.get(fieldName1).getDescribe().getLabel();//It provides to get the object fields label.

                            if(offerings.Domain_Expert_Functional_Architect_New__c != null)
                            {
                                if(lstOfferingsForDomainExpUser.isEmpty())
                                    {
                                        lstOfferingsForDomainExpUser.add(offerings.Domain_Expert_Functional_Architect_New__c);  
                                        idList.add(offerings.Domain_Expert_Functional_Architect_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Domain_Expert_Functional_Architect_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Domain_Expert_Functional_Architect_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                    }
                                    else if(lstOfferingsForDomainExpUser.contains(offerings.Domain_Expert_Functional_Architect_New__c))                         
                                    {
                                        sameRec.add(offerings.Domain_Expert_Functional_Architect_New__c);
                                    
                                    }
                                    else
                                    {
                                        lstOfferingsForDomainExpUser.add(offerings.Domain_Expert_Functional_Architect_New__c);
                                        idList.add(offerings.Domain_Expert_Functional_Architect_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Domain_Expert_Functional_Architect_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Domain_Expert_Functional_Architect_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                    } 
                                
                            }          
                        }
                        
                        if(fieldName1 == 'Domain_Expert_Functional_Architect_1_New__c') 
                        {
                    
                            Scheduling__c obj = new Scheduling__c();   
                            String label = fieldMap1.get(fieldName1).getDescribe().getLabel();//It provides to get the object fields label.

                            if(offerings.Domain_Expert_Functional_Architect_1_New__c != null)
                            {
                                if(lstOfferingsForDomainExp1User.isEmpty())
                                    {
                                        lstOfferingsForDomainExp1User.add(offerings.Domain_Expert_Functional_Architect_1_New__c);   
                                        idList.add(offerings.Domain_Expert_Functional_Architect_1_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Domain_Expert_Functional_Architect_1_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Domain_Expert_Functional_Architect_1_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                    }
                                    else if(lstOfferingsForDomainExp1User.contains(offerings.Domain_Expert_Functional_Architect_1_New__c))                          
                                    {
                                        sameRec.add(offerings.Domain_Expert_Functional_Architect_1_New__c);
                                    
                                    }
                                    else
                                    {
                                        lstOfferingsForDomainExp1User.add(offerings.Domain_Expert_Functional_Architect_1_New__c);
                                        idList.add(offerings.Domain_Expert_Functional_Architect_1_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Domain_Expert_Functional_Architect_1_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Domain_Expert_Functional_Architect_1_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                    } 
                                                             
                            }          
                        }
                        if(fieldName1 == 'Domain_Expert_Functional_Architect_2_New__c') 
                        {
                    
                            Scheduling__c obj = new Scheduling__c();   
                            String label = fieldMap1.get(fieldName1).getDescribe().getLabel();//It provides to get the object fields label.

                            if(offerings.Domain_Expert_Functional_Architect_2_New__c != null)
                            {
                                if(lstOfferingsForDomainExp2User.isEmpty())
                                    {
                                        lstOfferingsForDomainExp2User.add(offerings.Domain_Expert_Functional_Architect_2_New__c);   
                                        idList.add(offerings.Domain_Expert_Functional_Architect_2_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Domain_Expert_Functional_Architect_2_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Domain_Expert_Functional_Architect_2_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj); 
                                    }
                                    else if(lstOfferingsForDomainExp2User.contains(offerings.Domain_Expert_Functional_Architect_2_New__c))                          
                                    {
                                        sameRec.add(offerings.Domain_Expert_Functional_Architect_2_New__c);
                                    
                                    }
                                    else
                                    {
                                        lstOfferingsForDomainExp2User.add(offerings.Domain_Expert_Functional_Architect_2_New__c);
                                        idList.add(offerings.Domain_Expert_Functional_Architect_2_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Domain_Expert_Functional_Architect_2_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Domain_Expert_Functional_Architect_2_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj); 
                                    } 
                                                              
                            }          
                        }
                        if(fieldName1 == 'Domain_Expert_Functional_Architect_3_New__c') 
                        {
                    
                            Scheduling__c obj = new Scheduling__c();   
                            String label = fieldMap1.get(fieldName1).getDescribe().getLabel();//It provides to get the object fields label.

                            if(offerings.Domain_Expert_Functional_Architect_3_New__c != null)
                            {
                                if(lstOfferingsForDomainExp3User.isEmpty())
                                    {
                                        lstOfferingsForDomainExp3User.add(offerings.Domain_Expert_Functional_Architect_3_New__c);   
                                        idList.add(offerings.Domain_Expert_Functional_Architect_3_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Domain_Expert_Functional_Architect_3_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Domain_Expert_Functional_Architect_3_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                    }
                                    else if(lstOfferingsForDomainExp3User.contains(offerings.Domain_Expert_Functional_Architect_3_New__c))                          
                                    {
                                        sameRec.add(offerings.Domain_Expert_Functional_Architect_3_New__c);
                                    
                                    }
                                    else
                                    {
                                        lstOfferingsForDomainExp3User.add(offerings.Domain_Expert_Functional_Architect_3_New__c);
                                        idList.add(offerings.Domain_Expert_Functional_Architect_3_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Domain_Expert_Functional_Architect_3_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Domain_Expert_Functional_Architect_3_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                    } 
                                
                                
                            }          
                        }
                        if(fieldName1 == 'Domain_Expert_Functional_Architect_4_New__c') 
                        {
                    
                            Scheduling__c obj = new Scheduling__c(); 
                            String label = fieldMap1.get(fieldName1).getDescribe().getLabel();//It provides to get the object fields label.
                            if(offerings.Domain_Expert_Functional_Architect_4_New__c != null)
                            {
                                if(lstOfferingsForDomainExp4User.isEmpty())
                                    {
                                        lstOfferingsForDomainExp4User.add(offerings.Domain_Expert_Functional_Architect_4_New__c);   
                                        idList.add(offerings.Domain_Expert_Functional_Architect_4_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Domain_Expert_Functional_Architect_4_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Domain_Expert_Functional_Architect_4_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                    }
                                    else if(lstOfferingsForDomainExp4User.contains(offerings.Domain_Expert_Functional_Architect_4_New__c))                          
                                    {
                                        sameRec.add(offerings.Domain_Expert_Functional_Architect_4_New__c);
                                    
                                    }
                                    else
                                    {
                                        lstOfferingsForDomainExp4User.add(offerings.Domain_Expert_Functional_Architect_4_New__c);
                                        idList.add(offerings.Domain_Expert_Functional_Architect_4_New__c);
                                        obj.Role_Name__c = label;
                                        obj.User_Name__c =  offerings.Domain_Expert_Functional_Architect_4_New__r.Name;
                                        obj.BPO_Opportunity_MD__c = oppId;
                                        obj.User_Id__c = offerings.Domain_Expert_Functional_Architect_4_New__r.SFDC_User__c;
                                        obj.offerings__c = offerings.Id;
                                        lstSc1.add(obj);
                                    } 
                                
                                
                            }          
                        }
                  }
                }
            }
             if(lstUserAssignment.size()>0)
           {  
               for(Opportunity_TGP__c eachUser : lstUserAssignment)  
               {      
                      for (String fieldName: fieldMap.keySet()) 
                      {
                                      
                         if(fieldName == 'Complex_Cost_Architect_New__c') 
                        {
                            Scheduling__c obj = new Scheduling__c();  
                            String label = fieldMap.get(fieldName).getDescribe().getLabel();//It provides to get the object fields label.
                            if(eachUser.Complex_Cost_Architect_New__c != null)
                            {
                                idList.add(eachUser.Complex_Cost_Architect_New__c);       
                                obj.Role_Name__c = label;
                                obj.User_Name__c =  eachUser.Complex_Cost_Architect_New__r.Name;
                                obj.BPO_Opportunity_MD__c = oppId;
                                obj.User_Id__c = eachUser.Complex_Cost_Architect_New__r.SFDC_User__c;
                                lstSc1.add(obj);
                            }
                
                        }    
                   }
                   
                }
            }
        if(idList.contains(UserInfo.getUserId()))
        {
            addButtonRender = true;    
        }

        Date dte = System.today();
        
        //Date dte = date.newinstance(2014,4,3);  
        
        Datetime todaysDate = datetime.newInstance(dte.year(), dte.month(), dte.day());
        String day = todaysDate.format('E');  
        
        Date dte1;
        
         
         if(day == 'sun')
         {  
             date  weekStartDate = (dte - 1).toStartofWeek();
             dte1 = weekStartDate + 1;
         }
         else
         {
             dte1 = dte.toStartofWeek() + 1;
         }
         
        List<Scheduling__c> exList = new List<Scheduling__c>();   
        Set<String> roles = new Set<String>();
        Set<String> userId = new Set<String>();
        Map<String, Scheduling__c> roleUserMap = new Map<String, Scheduling__c>(); 
        Set<String> keySet = new Set<String>();
        for(Scheduling__c roleList : lstSc1)
        {
            roles.add(roleList.Role_Name__c);   
            userId.add(roleList.User_Id__c); 
            if(String.isNotEmpty(roleList.offerings__c)) {
                roleUserMap.put(roleList.Role_Name__c+roleList.offerings__c+roleList.User_Id__c, roleList);
            }
            else {
                roleUserMap.put(roleList.Role_Name__c+roleList.User_Id__c, roleList);
            }
        }
        keySet = roleUserMap.keySet();
        List<String> existingRecord = new List<String>();
                
        List<Scheduling__c> updateScheduleList = new List<Scheduling__c>();
        List<Scheduling__c> insertScheduleList = new List<Scheduling__c>();
        List<Scheduling__c> deleteScheduleList = new List<Scheduling__c>();
        List<Scheduling__c> noUpdateScheduleList = new List<Scheduling__c>();
        List<Scheduling__c> schList = new List<Scheduling__c>();
        
        schList = [SELECT Role_Name__c, User_Name__c,User_Id__c,offerings__c FROM Scheduling__c WHERE BPO_Opportunity_MD__c=: oppId];
        
        if(!schList.isempty()){
            
            for(SCheduling__c checkRole :  schList) {
                    
                if(String.isNotEmpty(checkRole.offerings__c))  {  
                           
                    if (roleUserMap.containsKey(checkRole.Role_Name__c+checkRole.offerings__c+checkRole.User_Id__c)) {
                        
                        if(String.isNotEmpty(roleUserMap.get(checkRole.Role_Name__c+checkRole.offerings__c+checkRole.User_Id__c).offerings__c)) {
                            if(checkRole.offerings__c.equalsIgnoreCase(roleUserMap.get(checkRole.Role_Name__c+checkRole.offerings__c+checkRole.User_Id__c).offerings__c)) {
                                    if(checkRole.User_Name__c.equalsIgnoreCase(roleUserMap.get(checkRole.Role_Name__c+checkRole.offerings__c+checkRole.User_Id__c).User_Name__c)) {
                                        
                                        noUpdateScheduleList.add(checkRole);
                                        existingRecord.add(checkRole.Role_Name__c+checkRole.offerings__c+checkRole.User_Id__c);
                                    }
                                    else {
                                        
                                        checkRole.User_Name__c = roleUserMap.get(checkRole.Role_Name__c+checkRole.offerings__c+checkRole.User_Id__c).User_Name__c;                     
                                        updateScheduleList.add(checkRole);
                                        existingRecord.add(checkRole.Role_Name__c+checkRole.offerings__c+checkRole.User_Id__c);
                                    }
                            }
                        }
                        
                    }
                    else  {
                        deleteScheduleList.add(checkRole);
                    }
                }
                else {
                    if (roleUserMap.containsKey(checkRole.Role_Name__c+checkRole.User_Id__c)) {
                        
                        if(checkRole.User_Name__c.equalsIgnoreCase(roleUserMap.get(checkRole.Role_Name__c+checkRole.User_Id__c).User_Name__c)) {
                            
                            noUpdateScheduleList.add(checkRole);
                            existingRecord.add(checkRole.Role_Name__c+checkRole.User_Id__c);
                        }
                        else {
                            
                            checkRole.User_Name__c = roleUserMap.get(checkRole.Role_Name__c+checkRole.User_Id__c).User_Name__c;   
                            
                                              
                            updateScheduleList.add(checkRole);
                            
                            existingRecord.add(checkRole.Role_Name__c+checkRole.User_Id__c);
                        }
                    }
                    else  {
                        deleteScheduleList.add(checkRole);
                    }
                }    
                
            }
        }
        else{
            
                for(Scheduling__c l :lstSc1)
                {
                    Decimal setDefault_Current_week_Val=(l.Current_week__c == null ? 0 : l.Current_week__c);
                    Decimal setDefault_Current_week_1_Val=(l.Current_week_1__c== null ? 0 : l.Current_week_1__c);
                    Decimal setDefault_Current_week_2_Val=(l.Current_week_2__c== null ? 0 : l.Current_week_2__c);
                    Decimal setDefault_Current_week_3_Val=(l.Current_week_3__c== null ? 0 : l.Current_week_3__c);                  
                    Decimal setDefault_Ongoing_Val=(l.Ongoing__c == null ? 0 : l.Ongoing__c );
                    l.Current_week__c=setDefault_Current_week_Val;
                    l.Current_week_1__c=setDefault_Current_week_1_Val;
                    l.Current_week_2__c=setDefault_Current_week_2_Val;
                    l.Current_week_3__c=setDefault_Current_week_3_Val;
                    l.Ongoing__c =setDefault_Ongoing_Val;
                    
                    /*if(dtTime.format('E') == 'sun')
                    {  
                        l.First_Date__c = (dte - 1).toStartofWeek() + 1;
                        l.Last_Date__c = (dte - 1).toStartofWeek() + 7;         
                    }
                    else
                    {
                        l.First_Date__c = dte.toStartofWeek() + 1;
                        l.Last_Date__c = dte.toStartofWeek() + 7; 
                    }*/
                    if(day == 'sun')
                {  
                     date  weekStartDate = (dte - 1).toStartofWeek();
                     dte1 = weekStartDate + 1;
                     l.First_Date__c = dte1;
                     l.Last_Date__c = (dte1 - 1).toStartofWeek() + 7; 
                 }
                
                else
                {
                    date  weekStartDate = dte.toStartofWeek();
                    dte1 = weekStartDate + 1;
                    l.First_Date__c = dte1;
                    l.Last_Date__c = dte.toStartofWeek() + 7; 
                }
                }
            Database.insert(lstSc1, false);
        }
        
        // New Scheduling Records
        if(keySet.removeAll(existingRecord)) {
            for(String role :keySet) {
                insertScheduleList.add(roleUserMap.get(role));
            }
            
        }
       
       
        if(!insertScheduleList.isEmpty()){
            
            for(Scheduling__c l : insertScheduleList)
            {
            
                Decimal setDefault_Current_week_Val=(l.Current_week__c == null ? 0 : l.Current_week__c);
                Decimal setDefault_Current_week_1_Val=(l.Current_week_1__c== null ? 0 : l.Current_week_1__c);
                Decimal setDefault_Current_week_2_Val=(l.Current_week_2__c== null ? 0 : l.Current_week_2__c);
                Decimal setDefault_Current_week_3_Val=(l.Current_week_3__c== null ? 0 : l.Current_week_3__c);       

           
                Decimal setDefault_Ongoing_Val=(l.Ongoing__c == null ? 0 : l.Ongoing__c );
                l.Current_week__c=setDefault_Current_week_Val;
                l.Current_week_1__c=setDefault_Current_week_1_Val;
                l.Current_week_2__c=setDefault_Current_week_2_Val;
                l.Current_week_3__c=setDefault_Current_week_3_Val;
                l.Ongoing__c =setDefault_Ongoing_Val;
                
                if(day == 'sun')
                {  
                     date  weekStartDate = (dte - 1).toStartofWeek();
                     dte1 = weekStartDate + 1;
                     l.First_Date__c = dte1;
                     l.Last_Date__c = (dte1 - 1).toStartofWeek() + 7; 
                 }
                /*if(dtTime.format('E') == 'sun')
                {  
                    date  weekStartDate = (dte - 1).toStartofWeek();
                    dte1 = weekStartDate + 1;
                    l.First_Date__c = dte1;
                    //l.First_Date__c = (dte - 1).toStartofWeek() + 1;
                    l.Last_Date__c = (dte - 1).toStartofWeek() + 7;         
                }*/
                else
                {
                    dte1 = dte.toStartofWeek() + 1;
                    l.First_Date__c = dte1;
                    l.Last_Date__c = dte.toStartofWeek() + 7; 
                }
                
                Database.insert(insertScheduleList, false);
            }
            
        }
        
        Database.upsert(updateScheduleList, false);
        Database.delete(deleteScheduleList, false);
       
        List<Scheduling__c> testRecList = new List<Scheduling__c>();
        
        testRecList = [select Role_Name__c,User_Id__c,offerings__c,First_Date__c,Last_Date__c,User_Name__c,Current_week__c,Current_week_1__c,Current_week_2__c,Current_week_3__c,Ongoing__c from Scheduling__c where BPO_Opportunity_MD__c =: oppId AND Role_Name__c IN : roles];                                
        for(Scheduling__c rec : testRecList)
        {    
            for(Scheduling__c dispRec : lstSc1)
            {   if((rec.User_Id__c == dispRec.User_Id__c) && (rec.Role_Name__c == dispRec.Role_Name__c) && rec.offerings__c == null)
                    {   
                        lstSc.add(rec);
                    }
                //}
               // else
               // {
                    if((rec.User_Id__c == dispRec.User_Id__c) && (rec.Role_Name__c == dispRec.Role_Name__c) && (rec.offerings__c == dispRec.offerings__c) && rec.offerings__c != null)
                    {   
                        lstSc.add(rec);
                    }
               // }
          }
      }
       
      /*  if(!insertScheduleList.isEmpty())
        {   
            for(Scheduling__c l : insertScheduleList)
            {    
                //seting Default value when user create scheduling
                Decimal setDefault_Current_week_Val=(l.Current_week__c == null ? 0 : l.Current_week__c);
                Decimal setDefault_Current_week_1_Val=(l.Current_week_1__c== null ? 0 : l.Current_week_1__c);
                Decimal setDefault_Current_week_2_Val=(l.Current_week_2__c== null ? 0 : l.Current_week_2__c);
                Decimal setDefault_Current_week_3_Val=(l.Current_week_3__c== null ? 0 : l.Current_week_3__c);       

           
                Decimal setDefault_Ongoing_Val=(l.Ongoing__c == null ? 0 : l.Ongoing__c );
                l.Current_week__c=setDefault_Current_week_Val;
                l.Current_week_1__c=setDefault_Current_week_1_Val;
                l.Current_week_2__c=setDefault_Current_week_2_Val;
                l.Current_week_3__c=setDefault_Current_week_3_Val;
                l.Ongoing__c =setDefault_Ongoing_Val;
                
                if(dtTime.format('E') == 'sun')
                {  
                    l.First_Date__c = (dte - 1).toStartofWeek() + 1;
                    l.Last_Date__c = (dte - 1).toStartofWeek() + 7;         
                }
                else
                {
                    l.First_Date__c = dte.toStartofWeek() + 1;
                    l.Last_Date__c = dte.toStartofWeek() + 7; 
                }
                //lstSc.add(l);
            }
        }*/
         
         
       
         for(Scheduling__c listSc : lstSc )
         {
           if(listSc.First_Date__c != null)
           {    
             if(dte1 != listSc.First_Date__c)
             {
                     //Scheduling__c obj = new Scheduling__c();
                     listSc.First_Date__c = listSc.First_Date__c + 7;
                     //listSc.Last_Date__c = listSc.Last_Date__c + 7;
                     listSc.Current_week__c = listSc.Current_week_1__c;
                     listSc.Current_week_1__c = listSc.Current_week_2__c;
                     listSc.Current_week_2__c = listSc.Current_week_3__c;
                     listSc.Current_week_3__c = 0 ;
                     //listSc.Ongoing__c = listSc.Ongoing__c;
                     //listSc.Role_Name__c = listSc.Role_Name__c;
                     //listSc.User_Name__c = listSc.User_Name__c;
                     //listSc.User_Id__c = listSc.User_Id__c;
                     //obj.BPO_Opportunity_MD__c = oppId;
                     //exList.add(obj);                       
              }
              
            }
         }   
    //}
     
      return null;
  }
  
 public void doSave()
 {
     Boolean regexTestResult;
     Integer count = 0;
    for(Scheduling__c validateDate : lstSc)
    {
         regexTestResult = checkNumberFormat(validateDate.Current_week__c,validateDate.Current_week_1__c,validateDate.Current_week_2__c,validateDate.Current_week_3__c,validateDate.Ongoing__c); 
         
         if(validateDate.Current_week__c > 100)
         {
             count = count + 1;
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not give more then 100% effort in current week.'));
         }
         else if(validateDate.Current_week_1__c > 100)
         {
             count = count + 1;
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not give more then 100% effort in current week+1.'));
         }
         else if(validateDate.Current_week_2__c > 100)
         {
             count = count + 1;
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not give more then 100% effort in current week+2.'));
         }
         else if(validateDate.Current_week_3__c > 100)
         {
             count = count + 1;
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not give more then 100% effort in current week+3.'));
         }
         else if(validateDate.Ongoing__c > 100)
         {
             count = count + 1;
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not give more then 100% effort in Ongoing Field.'));
         }
         else if(regexTestResult == true)
         {
             count = count + 1;
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'please enter non negative numeric value'));    
         }
    
    }
    if(count == 0)
    {
        try
        {
             upsert lstSc;
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Record Updated Successfully!'));  
        }
        catch(Exception e)
        {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
          return;
        }
     }   
 }
 public pagereference doCancel()
 {
       Lable();
       return null;
       
 }
     public Boolean checkNumberFormat(Decimal currentWeek,Decimal currentWeek1,Decimal currentWeek2,Decimal currentWeek3,Decimal onGoing) 
    {
        Boolean returnValue = true;
        Boolean falseReturnValue = false;
        Boolean result = true;
        Boolean result1 = true;
        Boolean result2 = true;
        Boolean result3 = true;
        Boolean resultOnGoing = true;
        String numberRegex= '^([0-9][0-9]*)$';
        Pattern MyPattern = Pattern.compile(numberRegex);
        
        if(currentWeek != null)
        {
            String currentWeekValue = String.valueof(currentWeek);
            Matcher MyMatcher = MyPattern.matcher(currentWeekValue);
            result = MyMatcher.matches();
        }
        if(currentWeek1 != null)
        {
            String currentWeekValue1 = String.valueof(currentWeek1);
            Matcher MyMatcher = MyPattern.matcher(currentWeekValue1);
            result1 = MyMatcher.matches();
        }
        if(currentWeek2 != null)
        {
            String currentWeekValue2 = String.valueof(currentWeek2);
            Matcher MyMatcher = MyPattern.matcher(currentWeekValue2);
            result2 = MyMatcher.matches();
        }
        if(currentWeek3 != null)
        {
            String currentWeekValue3 = String.valueof(currentWeek3);
            Matcher MyMatcher = MyPattern.matcher(currentWeekValue3);
            result3 = MyMatcher.matches();
        }
        if(onGoing != null)
        {
            String ongoingText = String.valueof(onGoing);
            Matcher MyMatcher = MyPattern.matcher(ongoingText);
            resultOnGoing = MyMatcher.matches();
        }
        if(result && result1 && result2 && result3 && resultOnGoing)
        {
            return false;    
        }
        else
        {
            return true;
        }
        
    }
   
}