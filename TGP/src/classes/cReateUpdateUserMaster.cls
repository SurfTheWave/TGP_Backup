global class cReateUpdateUserMaster {
	@future
	public static void processRecords(set<string> emailIds, set<id> usrIds, map<Id,String> oldFName, map<Id,String> oldLName){
		system.debug('emailIds--'+emailIds);
		system.debug('usrIds--'+usrIds);
		system.debug('oldFName--'+oldFName);
		system.debug('oldLName--'+oldLName);
		Map < String, User_Master__c > userMasterMap = new Map < String, User_Master__c > ();
		for(User_Master__c userMaster: [Select email__c, isSFDCUser__c, Name, First_Name__c, user__c, Last_Name__c 
            from User_Master__c where email__c IN: emailIds limit 1000]){
            	 userMasterMap.put(userMaster.email__c, userMaster);
            }
		
		map<Id,User> userMap = new map<Id,User>([Select Id, firstname,lastname,email,Allow_Duplicate__c from User 
													where Id IN: usrIds]);
		   User_Master__c userMaster;
        List < User_Master__c > userMasterListtoUpsert = new List < User_Master__c > ();
        for (User user: userMap.values()) {
            userMaster = new User_Master__c();
            if (userMasterMap.containskey(user.email) && (!user.Allow_Duplicate__c)) {
                if (oldFName != null && oldLName != null &&
                	userMasterMap.get(user.email).name.equals(oldFName.get(user.Id) + UtilConstants.BLANK_SPACE + oldLName.get(user.Id))) {
                    userMaster = userMasterMap.get(user.email);
                    userMaster.Name = user.firstName + UtilConstants.BLANK_SPACE + user.LastName;
                    userMaster.email__c = user.email;
                    system.debug('userMaster--111'+userMaster);
                    userMasterListtoUpsert.add(userMaster);
                }
            } else if (!userMasterMap.containskey(user.email)) {
                userMaster.user__c = user.Id;
                userMaster.email__c = user.email;
                userMaster.Name = user.firstName + UtilConstants.BLANK_SPACE + user.LastName;
                system.debug('userMaster--222'+userMaster);
                userMasterListtoUpsert.add(userMaster);
            }
        }
        try {
            if (userMasterListtoUpsert.size() > 0) {
            	System.debug('userMasterListtoUpsert--'+userMasterListtoUpsert);
                upsert userMasterListtoUpsert;
            }
        } catch (DMLException E) {
            String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString();
          throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
                          //ApexPages.addMessage(myMsg);﻿
            //system.debug('E==' + E);
        }
    }

}