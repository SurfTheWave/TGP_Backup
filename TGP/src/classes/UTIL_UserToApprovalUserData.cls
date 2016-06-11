public without sharing class UTIL_UserToApprovalUserData {
	
	public void updateOpportunityAndOfferingRecords(List<Opportunity_TGP__c> scope) {
		Map<Id, Id> userTOApprovalUsrMap = new Map<Id, Id>();
		
		for(Review_User_Master__c RUM :[select Id, SFDC_User__c from Review_User_Master__c where SFDC_User__c != null] ) {
			userTOApprovalUsrMap.put(RUM.SFDC_User__c, RUM.Id);
		}
		 
		List<Opportunity_Offering__c> oppOfferingList = new List<Opportunity_Offering__c>();
		
		oppOfferingList = [SELECT Offering_Solution_Lead_Secondary__c, Offering_Solution_Lead_Secondary_New__c, Functional_Architect_Mobilization__c, Functional_Architect_Mobilization_New__c, Solution_Lead__c, Solution_Lead_New__c, Solution_Specialist__c, Solution_Specialist_New__c,
	    		Domain_Expert_Functional_Architect__c, Domain_Expert_Functional_Architect_New__c, Domain_Expert_Functional_Architect_1__c, Domain_Expert_Functional_Architect_1_New__c, Domain_Expert_Functional_Architect_2__c, Domain_Expert_Functional_Architect_2_New__c,
	    		Domain_Expert_Functional_Architect_3__c, Domain_Expert_Functional_Architect_3_New__c, Domain_Expert_Functional_Architect_4__c,  Domain_Expert_Functional_Architect_4_New__c, 
	    		Id FROM Opportunity_Offering__c where Opportunity_TGP__c In: scope];
	    		
	    for(Opportunity_TGP__c oppRecord : scope)
	    {
	        //'SELECT Complex_Cost_Architect_New__c,Complex_Cost_Architect__c, Enterprise_Solution_Architect__c, Enterprise_Solution_Architect_New__c, BSS_Operation__c, BSS_Operation_New__c, Id FROM Opportunity_TGP__c where (Complex_Cost_Architect__c != null || Enterprise_Solution_Architect__c != null || BSS_Operation__c != null)';
	        
	        oppRecord.Complex_Cost_Architect_New__c = userTOApprovalUsrMap.get(oppRecord.Complex_Cost_Architect__c);
	    	oppRecord.Enterprise_Solution_Architect_New__c = userTOApprovalUsrMap.get(oppRecord.Enterprise_Solution_Architect__c);
	     	oppRecord.BSS_Operation_New__c = userTOApprovalUsrMap.get(oppRecord.BSS_Operation__c);	
	        
	    }
	     for(Opportunity_Offering__c offRecord : oppOfferingList)
	    {
	    	// SELECT Offering_Solution_Lead_Secondary__c, Offering_Solution_Lead_Secondary_New__c, Functional_Architect_Mobilization__c, Functional_Architect_Mobilization_New__c, Solution_Lead__c, Solution_Lead_New__c, Solution_Specialist__c, Solution_Specialist_New__c,
	    	// Domain_Expert_Functional_Architect__c, Domain_Expert_Functional_Architect_New__c, Domain_Expert_Functional_Architect_1__c, Domain_Expert_Functional_Architect_1_New__c, Domain_Expert_Functional_Architect_2__c, Domain_Expert_Functional_Architect_2_New__c,
	    	// Domain_Expert_Functional_Architect_3__c, Domain_Expert_Functional_Architect_3_New__c, Domain_Expert_Functional_Architect_4__c,  Domain_Expert_Functional_Architect_4_New__c, 
	    	//	Id FROM Opportunity_Offering__c)
	        offRecord.Offering_Solution_Lead_Secondary_New__c = userTOApprovalUsrMap.get(offRecord.Offering_Solution_Lead_Secondary__c);
	    	offRecord.Functional_Architect_Mobilization_New__c = userTOApprovalUsrMap.get(offRecord.Functional_Architect_Mobilization__c);
	     	offRecord.Solution_Lead_New__c = userTOApprovalUsrMap.get(offRecord.Solution_Lead__c);	
	     	offRecord.Solution_Specialist_New__c = userTOApprovalUsrMap.get(offRecord.Solution_Specialist__c);	
	     	offRecord.Domain_Expert_Functional_Architect_New__c = userTOApprovalUsrMap.get(offRecord.Domain_Expert_Functional_Architect__c);	
	     	offRecord.Domain_Expert_Functional_Architect_1_New__c = userTOApprovalUsrMap.get(offRecord.Domain_Expert_Functional_Architect_1__c);	
	     	offRecord.Domain_Expert_Functional_Architect_2_New__c = userTOApprovalUsrMap.get(offRecord.Domain_Expert_Functional_Architect_2__c);	
	     	offRecord.Domain_Expert_Functional_Architect_3_New__c = userTOApprovalUsrMap.get(offRecord.Domain_Expert_Functional_Architect_3__c);	
	     	offRecord.Domain_Expert_Functional_Architect_4_New__c = userTOApprovalUsrMap.get(offRecord.Domain_Expert_Functional_Architect_4__c);	
	        
	    }
	    update scope;
	    update oppOfferingList;
	    
	}
	
	public void updateSolutionUserAssignmentRecords(List<Solution_User_Assignment__c> scope) {
		//QUERY: SELECT Resource_Assigned_User__c, Resource_Assigned_User_New__c, Id FROM Solution_User_Assignment__c where (Resource_Assigned_User__c != null)
		Map<Id, Id> userTOApprovalUsrMAp = new Map<Id, Id>();
		for(Review_User_Master__c RUM :[select Id, SFDC_User__c from Review_User_Master__c where SFDC_User__c != null] ) {
			userTOApprovalUsrMap.put(RUM.SFDC_User__c, RUM.Id);
		} 
	
	    for(Solution_User_Assignment__c solUserAssignemntRecord : scope)
	    {	
	        solUserAssignemntRecord.Resource_Assigned_User_New__c = userTOApprovalUsrMap.get(solUserAssignemntRecord.Resource_Assigned_User__c);
	    }
	    update scope;
	}


	public void updateDealRecords(List<Deal_TGP__c> scope) {
		//QUERY: SELECT Resource_Assigned_User__c, Resource_Assigned_User_New__c, Id FROM Solution_User_Assignment__c where (Resource_Assigned_User__c != null)
		Map<Id, Id> userTOApprovalUsrMAp = new Map<Id, Id>();
		for(Review_User_Master__c RUM :[select Id, SFDC_User__c from Review_User_Master__c where SFDC_User__c != null] ) {
			userTOApprovalUsrMap.put(RUM.SFDC_User__c, RUM.Id);
		} 
	
	    for(Deal_TGP__c dealRecord : scope)
	    {	      
	        dealRecord.BSS_Solution_Architect_New__c = userTOApprovalUsrMap.get(dealRecord.BSS_Solution_Architect__c);
	        dealRecord.Complex_Costing_Architect_New__c = userTOApprovalUsrMap.get(dealRecord.Complex_Costing_Architect__c);
	        dealRecord.Governance_Lead_Name_New__c = userTOApprovalUsrMap.get(dealRecord.Governance_Lead_Name__c);
	        dealRecord.Governance_Lead_Name_Secondary_New__c = userTOApprovalUsrMap.get(dealRecord.Governance_Lead_Name_Secondary__c);
	        dealRecord.Solution_Architect_New__c = userTOApprovalUsrMap.get(dealRecord.Solution_Architect__c);
	        dealRecord.Solution_Lead_New__c = userTOApprovalUsrMap.get(dealRecord.Solution_Lead__c);
	        dealRecord.Solution_Specialist_New__c = userTOApprovalUsrMap.get(dealRecord.Solution_Specialist__c);
	        dealRecord.Technology_Architect_New__c = userTOApprovalUsrMap.get(dealRecord.Technology_Architect__c);
	    }
	    update scope;
	}


	public void updateDealLocationRecords(List<Deal_Location__c> scope) {
		//QUERY: SELECT Resource_Assigned_User__c, Resource_Assigned_User_New__c, Id FROM Solution_User_Assignment__c where (Resource_Assigned_User__c != null)
		Map<Id, Id> userTOApprovalUsrMAp = new Map<Id, Id>();
		
		for(Review_User_Master__c RUM :[select Id, SFDC_User__c from Review_User_Master__c where SFDC_User__c != null] ) {
			userTOApprovalUsrMap.put(RUM.SFDC_User__c, RUM.Id);
		} 
	
	    for(Deal_Location__c dealLocationRecord : scope)
	    {	      
	        dealLocationRecord.Deployment_Lead_New__c = userTOApprovalUsrMap.get(dealLocationRecord.Deployment_Lead__c);
	        dealLocationRecord.Location_Mobilization_Lead_Secondary_New__c	= userTOApprovalUsrMap.get(dealLocationRecord.Location_Mobilization_Lead_Secondary__c);
	        dealLocationRecord.Mob_Recruitment_Lead_Primary_New__c = userTOApprovalUsrMap.get(dealLocationRecord.Mobilization_Recruitment_Lead_Primary__c);
	        dealLocationRecord.Mob_Recruitment_Lead_Secondary_New__c = userTOApprovalUsrMap.get(dealLocationRecord.Mobilization_Recruitment_Lead_Secondary__c);	        
	    }
	    
	    update scope;
	    
	}
	
	
	public void updateDealWaveRecords(List<Wave_Planning__c> scope) {
		Map<Id, Id> userTOApprovalUsrMAp = new Map<Id, Id>();
		
		for(Review_User_Master__c RUM :[select Id, SFDC_User__c from Review_User_Master__c where SFDC_User__c != null] ) {
			userTOApprovalUsrMap.put(RUM.SFDC_User__c, RUM.Id);
		}    		
		
	    for(Wave_Planning__c dealWaveRecord : scope) {
	    	dealWaveRecord.KT_Lead_New__c = userTOApprovalUsrMap.get(dealWaveRecord.KT_Lead__c);
	    	dealWaveRecord.Mobilization_KT_Lead_Secondary_New__c = userTOApprovalUsrMap.get(dealWaveRecord.Mobilization_KT_Lead_Secondary__c);
	    	dealWaveRecord.Mob_Recruitment_Lead_Primary_New__c  = userTOApprovalUsrMap.get(dealWaveRecord.Mobilization_Recruitment_Lead_Primary__c);
	    	dealWaveRecord.Mob_Recruitment_Lead_Secondary_New__c = userTOApprovalUsrMap.get(dealWaveRecord.Mobilization_Recruitment_Lead_Secondary__c);
	    	dealWaveRecord.Mobilization_Opex_Lead_Primary_New__c = userTOApprovalUsrMap.get(dealWaveRecord.Mobilization_Opex_Lead_Primary__c); 
	    	dealWaveRecord.Mobilization_Opex_Lead_Secondary_New__c = userTOApprovalUsrMap.get(dealWaveRecord.Mobilization_Opex_Lead_Secondary__c);
	    	dealWaveRecord.Mobilization_Technology_Lead_Primary_New__c	= userTOApprovalUsrMap.get(dealWaveRecord.Mobilization_Technology_Lead_Primary__c);
	    	dealWaveRecord.Mob_Technology_Lead_Secondary_New__c = userTOApprovalUsrMap.get(dealWaveRecord.Mobilization_Technology_Lead_Secondary__c);
	    }
	    update scope;
	}


	public void updateMobUserAssignmentRecords(List<MOB_User_Role_Assignment__c> scope) {
			//QUERY: SELECT Resource_Assigned_User__c, Resource_Assigned_User_New__c, Id FROM Solution_User_Assignment__c where (Resource_Assigned_User__c != null)
			Map<Id, Id> userTOApprovalUsrMAp = new Map<Id, Id>();
			for(Review_User_Master__c RUM :[select Id, SFDC_User__c from Review_User_Master__c where SFDC_User__c != null] ) {
				userTOApprovalUsrMap.put(RUM.SFDC_User__c, RUM.Id);
			} 
		
		    for(MOB_User_Role_Assignment__c mobUserAssignemntRecord : scope)
		    {	
		        mobUserAssignemntRecord.User_Assigned_New__c = userTOApprovalUsrMap.get(mobUserAssignemntRecord.User_Assigned__c);
		        mobUserAssignemntRecord.User_Assigned_Secondary_New__c = userTOApprovalUsrMap.get(mobUserAssignemntRecord.User_Assigned_Secondary__c);		        
		    }
		    update scope;
		}


}