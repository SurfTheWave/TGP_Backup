@IsTest
private class nonStandardTabControllerTest{
	
		static Opportunity_TGP__c oppObj;
	    static Opportunity_Offering__c offRec;
	    static Client_Master__c clientName;
	    static Client_Geo_Area_Master__c clientGeoArea;
   		 static Operating_Group_Master__c operatingGroup;
    	static Client_Geo_Unit_Master__c clientGeoUnit;
    	static User testUser;
     

     public static void setupData(){
     	
     		Profile p = UTIL_DataCreationForTestClass.getProfile(UTIL_Constants.WORKBENCH_USER);
     
     		testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_Constants.USER_NAME);
     		Database.insert(testUser, false);
    	 	
     		clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      		insert clientName;
      		
      		clientName = new Client_Master__c (Name = 'TestObject1',Active__c = true);
      		insert clientName;
      
      		clientGeoArea = new Client_Geo_Area_Master__c (Name = 'TestAPAC',Active__c = true);
      		insert clientGeoArea;
      
      		operatingGroup = new Operating_Group_Master__c (Name = 'TestHSMPS',Active__c = true);
      		insert operatingGroup;
      
      		clientGeoUnit = new Client_Geo_Unit_Master__c (Name = 'TestLATAM',Active__c = true);
      		insert clientGeoUnit;
     	
     		oppObj = new Opportunity_TGP__c(Name = 'TestIBM',Stage__c='Stage 1',Client_Name__c= clientName.id ,Client_Geo_Area__c=clientGeoArea.id,Operating_Group__c=operatingGroup.id,Risk_Level__c='Low',
                  Expected_contract_sign_qtr__c='FY12-Q4',Client_Geo_Unit__c=clientGeoUnit.id ,Complex_Cost_Architect__c = testUser.id,Activity__c='1-Active',Enterprise_Solution_Architect__c=testUser.id ,
                  Oppotunity_QA__c='KomalTest',OG_Sales_Lead__c='Test');  
                   
      		insert oppObj;
     		
     		offRec = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Opportunity_TGP__c=oppObj.id);
            insert offRec;
         
     }
     public static testMethod void testController() {

        setupData();
        test.starttest();
        //System.runas(testUser)
        //{
            //oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Domain_Expert_Functional_Architect_1__c = testUser.id,Domain_Expert_Functional_Architect_2__c = testUser.id,Domain_Expert_Functional_Architect_3__c = testUser.id,Domain_Expert_Functional_Architect_4__c=testUser.id,Solution_Lead__c = testUser.id ,Opportunity_TGP__c=oppObj.id);
            //insert oppOffering;
            ApexPages.StandardController sc = new ApexPages.StandardController(offRec);
            apexpages.currentpage().getparameters().put('id' ,offRec.id); 
            nonStandardTabController obj = new nonStandardTabController(sc);  
         
        //} 
        test.stoptest();
     }
     public static testMethod void testControllerSave() {

        setupData();
        test.starttest();
        //System.runas(testUser)
        //{
            //oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Domain_Expert_Functional_Architect_1__c = testUser.id,Domain_Expert_Functional_Architect_2__c = testUser.id,Domain_Expert_Functional_Architect_3__c = testUser.id,Domain_Expert_Functional_Architect_4__c=testUser.id,Solution_Lead__c = testUser.id ,Opportunity_TGP__c=oppObj.id);
            //insert oppOffering;
            ApexPages.StandardController sc = new ApexPages.StandardController(offRec);
            apexpages.currentpage().getparameters().put('id' ,offRec.id); 
            nonStandardTabController obj = new nonStandardTabController(sc);  
            obj.oppOffering.Accenture_non_BPO_scope__c = 'Test Accenture Scope';
            obj.oppOffering.Non_standard_BPO_scope__c = 'test non standard bpo scope';
            obj.oppOffering.Third_Party_scope__c = 'test third party scope';
            obj.saverecord();
            //List<Opportunity_Offering__c> offList = [select Accenture_non_BPO_scope__c from Opportunity_Offering__c where id =: offRec.id];
         	//System.assertEquals('Test Accenture Scope', offList[0].Accenture_non_BPO_scope__c);
         
        //} 
        test.stoptest();
     }
     public static testMethod void testControllerCancel() {

        setupData();
        test.starttest();
        //System.runas(testUser)
       // {
            //oppOffering = new Opportunity_Offering__c(Offering_Text_Name__c = 'TestOffering',Domain_Expert_Functional_Architect_1__c = testUser.id,Domain_Expert_Functional_Architect_2__c = testUser.id,Domain_Expert_Functional_Architect_3__c = testUser.id,Domain_Expert_Functional_Architect_4__c=testUser.id,Solution_Lead__c = testUser.id ,Opportunity_TGP__c=oppObj.id);
            //insert oppOffering;
            ApexPages.StandardController sc = new ApexPages.StandardController(offRec);
            apexpages.currentpage().getparameters().put('id' ,offRec.id); 
            nonStandardTabController obj = new nonStandardTabController(sc);  
            obj.oppOffering.Accenture_non_BPO_scope__c = 'Test Accenture Scope';
            obj.oppOffering.Non_standard_BPO_scope__c = 'test non standard bpo scope';
            obj.oppOffering.Third_Party_scope__c = 'test third party scope';
            obj.cancelrecord();
         	obj.editrecord();
       // } 
        test.stoptest();
     }
}